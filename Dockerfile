FROM ubuntu:16.04
MAINTAINER Tim Haak <tim@haak.co>

ADD Preferences.xml /
ADD start.sh /

ENV DEBIAN_FRONTEND="noninteractive" \
    TERM="xterm"

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup &&\
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    apt-get -q update && \
    apt-get -qy dist-upgrade && \
    apt-get install -qy \
      iproute2 \
      ca-certificates \
      ffmpeg \
      jq \
      openssl \
      xmlstarlet \
      curl \
      sudo \
      wget \
    && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

ENV PLEX_DOWNLOAD="https://downloads.plex.tv/plex-media-server/1.2.0.2838-a68e2fe/plexmediaserver_1.2.0.2838-a68e2fe_amd64.deb"

RUN wget -O plex_server.deb $PLEX_DOWNLOAD && \
dpkg -i plex_server.deb && \
rm plex_server.deb && \
apt-get -y autoremove && \
apt-get -y clean && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /tmp/*

VOLUME ["/config","/data"]

ENV RUN_AS_ROOT="true" \
    CHANGE_DIR_RIGHTS="false" \
    CHANGE_CONFIG_DIR_OWNERSHIP="true" \
    HOME="/config" \
    PLEX_DISABLE_SECURITY=1

EXPOSE 32400

CMD ["/start.sh"]
