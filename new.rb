

username = "bobbygrayson@gmail.com"
pwd = "w00tw00t"
target_path = "/home/bobby/rubytapas"
# saving auth cookie
system %Q{wget --save-cookies /tmp/cookie.txt --keep-session-cookies --post-data "username=#{username}&password=#{pwd}" -O - \
https://rubytapas.dpdcart.com/subscriber/login?__dpd_cart=d08391e6-5fe2-4400-8b27-2dc17b413027}

(25..600).each do |i|
  %x[wget -q -S --spider --load-cookies /tmp/cookie.txt https://rubytapas.dpdcart.com/subscriber/download?file_id=#{i} > spider.log 2>&1]
  head_log = File.read("spider.log")
  if head_log =~ /Content-Disposition.*filename="(.+)\.(.+)"/
    name, extension = $1, $2
    puts "Processing #{name}.#{extension}..."
    if name && extension && !name.empty? && !extension.empty?
      if Dir.glob("#{target_path}/**/#{name}.#{extension}").size == 0
        puts "Downloading #{name}.#{extension}..."
        filename = "#{name}.#{extension}"
          if filename =~ /.*(\d{3}).*/
            target_folder = $1
            target_fullpath = "#{target_path}/#{target_folder}"
            Dir.mkdir(target_fullpath) unless File.exist?(target_fullpath)
            puts "*** wget --load-cookies /tmp/cookie.txt --output-document='#{target_path}/#{target_folder}/#{name}.#{extension}' https://rubytapas.dpdcart.com/subscriber/download?file_id=#{i}"
            system "wget --load-cookies /tmp/cookie.txt --output-document='#{target_path}/#{target_folder}/#{name}.#{extension}' https://rubytapas.dpdcart.com/subscriber/download?file_id=#{i}"
        end
      end
    end
  end
end 
