FROM nginx:latest
RUN mkdir /etc/consul-templates

#Install Curl
RUN apt-get update -qq && apt-get -y install wget unzip

#Download and Install Consul Template
ENV CT_URL https://releases.hashicorp.com/consul-template/0.12.2/
ENV CT_FILENAME consul-template_0.12.2_linux_amd64.zip
RUN wget $CT_URL$CT_FILENAME && unzip -d /usr/local/bin $CT_FILENAME

#Setup Consul Template Files
ENV CT_FILE /etc/consul-templates/nginx.conf.templ
ENV NX_FILE /etc/nginx/nginx.conf

#Default Variables
ENV CONSUL consul:8500

# Command will
# 1. Write Consul Template File
# 2. Start Nginx
# 3. Start Consul Template

ADD /nginx.conf.templ /etc/consul-templates

CMD /usr/sbin/nginx -c $NX_FILE \
& CONSUL_TEMPLATE_LOG=debug consul-template \
  -consul=$CONSUL \
  -template "$CT_FILE:$NX_FILE:/usr/sbin/nginx -s reload";
