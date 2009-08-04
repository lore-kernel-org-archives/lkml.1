Return-Path: <linux-kernel-owner+w=401wt.eu-S932580AbZHDJBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbZHDJBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 05:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932480AbZHDJA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 05:00:59 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63076 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476AbZHDJA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 05:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:content-type
         :content-transfer-encoding:message-id;
        b=YPiq5qF5V859RqAP/iavOo4Wd+NV+59SYWFfk8QlPgITQy8QZ61B5m2OpZ6bBYmg+J
         +BMcke9lqqiaFtx4hEN4fo+lObGQHCHNo9aah/JMJ0iwydtuHP7SwMUqlUbK2tooaC2I
         rdnNvb4wD351wL6lMwGf1E1WiFmKAVGCoLPHs=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: sound: -EPERM on first mplayer invocation
Date: Tue, 4 Aug 2009 11:01:43 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org
References: <200908022336.48898.vda.linux@googlemail.com> <s5hr5vt8jyp.wl%tiwai@suse.de>
In-Reply-To: <s5hr5vt8jyp.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908041101.43252.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009 08:55, Takashi Iwai wrote:
> Denys Vlasenko wrote:
> > Hi,
> > 
> > For a long time I observe the following nuisance:
> > when I run mplayer for the very first time after boot,
> > I can't adjust the volume. mplayer spews this to stderr:
> > 
> > alsa-control: error setting left channel, Operation not permitted
> > 
> > This happens even if I login as root and run mplayer as root.
> > 
> > I tracked it down to snd_ctl_elem_write in sound/core/control.c
> > 
...
> > 
> > Thus, vd->owner != file.
> > 
> > As I said, it only happens on very first run of mplayer,
> > and it isn't a recent change, I think I saw it at least
> > for one year with different kernels.
> > 
> > Takashi, any idea what might be happening here?
> > How can I help you more with tracking it down?
> 
> This implies that another process (e.g. a sound daemon like PA)
> already opened the device and locked this specific control element.
> If so, this is no bug but the right behavior.
> Check "fuser /dev/snd/controlC*".

Nothing uses them:

shadow:~# lsof -nP | grep '/dev/.*control'
shadow:~# fuser /dev/snd/controlC*
shadow:~#

I tried running bare X with only xterm and mplayer,
and I see the same symptoms when I try to adjust volume:

...
[Mixer] No hardware mixing, inserting volume filter.
[libaf] Adding filter volume
[dummy] Was reinitialized: 48000Hz/2ch/s16le
alsa-control: error setting left channel, Operation not permitted0 78%
alsa-control: error setting left channel, Operation not permitted0 77%
alsa-control: error setting left channel, Operation not permitted0 76%
alsa-control: error setting left channel, Operation not permitted0 75%
...

Here is the list of processes just before I started mplayer.
AFAICS, no sound daemons:

PID   USER     TIME   COMMAND
    1 root       0:00 /bin/sh /init 
    2 root       0:00 [kthreadd]
    3 root       0:00 [migration/0]
    4 root       0:00 [ksoftirqd/0]
    5 root       0:00 [watchdog/0]
    6 root       0:00 [events/0]
    7 root       0:00 [khelper]
   13 root       0:00 [async/mgr]
  184 root       0:00 [kblockd/0]
  186 root       0:00 [kacpid]
  187 root       0:00 [kacpi_notify]
  188 root       0:00 [kacpi_hotplug]
  284 root       0:00 [ata/0]
  285 root       0:00 [ata_aux]
  289 root       0:00 [ksuspend_usbd]
  293 root       0:00 [khubd]
  296 root       0:00 [kseriod]
  298 root       0:00 [kgameportd]
  356 root       0:00 [khungtaskd]
  357 root       0:00 [pdflush]
  358 root       0:00 [pdflush]
  359 root       0:00 [kswapd0]
  360 root       0:00 [aio/0]
  361 root       0:00 [nfsiod]
  362 root       0:00 [crypto/0]
  551 root       0:00 [scsi_eh_0]
  553 root       0:00 [scsi_eh_1]
  555 root       0:00 [scsi_eh_2]
  557 root       0:00 [scsi_eh_3]
  612 root       0:00 [bnx2x]
  670 root       0:00 [mlx4]
  688 root       0:00 [netxen]
  691 root       0:00 [sfc_refill/0]
  692 root       0:00 [sfc_reset]
  709 root       0:00 [kpsmoused]
  715 root       0:00 [rpciod/0]
  765 root       0:00 [kjournald]
  783 root       0:00 udevd 
  800 root       0:00 [reiserfs/0]
  807 1          0:00 rpc.portmap 
  866 root       0:00 runsvdir -P /var/service _____________________________________________ 
  867 root       0:00 sleep 32000 
  868 root       0:00 runsv fw 
  869 root       0:00 runsv gpm 
  870 root       0:00 runsv ntp 
  871 root       0:00 runsv top 
  872 root       0:00 runsv klog 
  873 logger     0:00 svlogd -tt /var/log/service/ntp 
  876 root       0:00 gpm -D -2 -m /dev/psaux -t ps2 
  880 root       0:00 top 
  884 root       0:00 runsv once 
  885 root       0:00 runsv tftp 
  903 root       0:00 runsv sshd 
  904 root       0:00 runsv vpnc 
  905 root       0:00 runsv ora_db_test1st 
  906 root       0:00 runsv dhcp_if 
  911 logger     0:00 svlogd -tt /var/log/service/klog 
  913 root       0:00 socklog ucspi 
  932 root       0:00 runsv httpd 
  933 root       0:00 runsv httpd_ssl 
  934 root       0:00 runsv vsftp 
  935 root       0:00 runsv proxy-2222-to-22 
  948 root       0:00 runsv ftpd_bbox 
  949 root       0:00 runsv ora_listener 
  950 root       0:00 runsv nfs_v3 
  951 root       0:00 runsv nmeter 
  952 root       0:00 runsv getty_gay 
  953 root       0:00 runsv telnetd_bbox 
  954 root       0:00 runsv clock_server 
  955 root       0:00 runsv getty_tty1 
  966 time       0:00 taiclockd 
  975 root       0:00 runsv getty_tty2 
  976 root       0:00 runsv getty_tty3 
  977 root       0:00 nmeter %t %c x %x p%p f %f b %b m %m if%[nif] 
  994 logger     0:00 svlogd -tt /var/log/service/dhcp_if 
  996 root       0:00 ./udhcpc -vv --hostname=null --foreground --interface=if --pidfile=/.local/var/service/dhcp_if/udhcpc.pid --script=/.local/var/service/dhcp_if/dhcp_handler 
 1004 logger     0:00 svlogd -tt /var/log/service/ora_db_test1st 
 1007 logger     0:00 svlogd -tt /var/log/service/tftp 
 1009 root       0:00 udpsvd -v -c 10 -l localhost 0 69 tftpd /pub/tftp 
 1011 root       0:00 -bash 
 1022 root       0:00 runsv getty_tty4 
 1024 root       0:00 runsv getty_tty5 
 1025 logger     0:00 svlogd -tt /var/log/service/vsftp 
 1028 logger     0:00 svlogd -tt /var/log/service/httpd 
 1035 root       0:00 runsv getty_tty6 
 1036 root       0:00 runsv getty_tty7 
 1037 root       0:00 runsv getty_tty8 
 1038 root       0:00 runsv httpd_bbox 
 1039 root       0:00 runsv syslog 
 1040 root       0:00 runsv tidy_tmp 
 1041 root       0:00 runsv dnscache_int 
 1042 root       0:00 runsv automount 
 1043 root       0:00 runsv crond_bbox 
 1044 root       0:00 runsv dhcpd_if 
 1045 root       0:00 runsv inetd_bbox 
 1046 root       0:00 runsv dhcp_if_pinger 
 1047 logger     0:00 svlogd -tt /var/log/service/sshd 
 1049 logger     0:00 svlogd -tt /var/log/service/httpd_ssl 
 1051 logger     0:00 svlogd -tt /var/log/service/vpnc 
 1053 root       0:00 tcpserver -v -R -H -l 0 -c 40 0.0.0.0 80 setuidgid root httpd -f /.local/var/service/httpd/httpd.conf 
 1055 root       0:00 getty 38400 /dev/tty3 linux 
 1059 root       0:00 getty 38400 /dev/tty8 linux 
 1061 logger     0:00 svlogd -tt /var/log/service/inetd_bbox 
 1075 root       0:00 tcpserver -v -R -H -l 0 -c 40 0.0.0.0 443 stunnel -f -p ../host.pem -l setuidgid -- setuidgid root httpd -f /.local/var/service/httpd_ssl/httpd.conf 
 1077 root       0:00 tcpsvd -vE -l 0 -c 40 0 22 /usr/bin/sshd -i -D -e -p22 -u0 
 1090 logger     0:00 svlogd -tt /var/log/service/automount 
 1092 root       0:00 automount -f -s -v --timeout 15 /.local/mnt/auto program /.local/var/service/automount/mapper.sh 
 1103 root       0:00 getty 38400 /dev/tty5 linux 
 1110 logger     0:00 svlogd -tt /var/log/service/telnetd_bbox 
 1112 logger     0:00 svlogd /var/log/service/syslog 
 1113 logger     0:00 svlogd -tt /var/log/service/tidy_tmp 
 1122 root       0:00 sleep 1260 
 1127 root       0:00 getty 38400 /dev/tty7 linux 
 1157 logger     0:00 svlogd -tt /var/log/service/httpd_bbox 
 1159 root       0:00 tcpserver -v -R -H -l 0 -c 40 0.0.0.0 81 setuidgid root ./busybox httpd -vvv -i -h /.1/video 
 1166 root       0:00 getty 38400 /dev/tty6 linux 
 1171 logger     0:00 svlogd -tt /var/log/service/dnscache_int 
 1173 logger     0:00 svlogd -tt /var/log/service/crond_bbox 
 1179 root       0:00 crond -f -d7 
 1190 root       0:00 syslogd -m 0 -n -S -s 99 -b 9 -O /.local/var/service/syslog/syslog 
 1200 root       0:00 getty 38400 /dev/tty4 linux 
 1205 logger     0:00 svlogd -tt /var/log/service/ora_listener 
 1225 logger     0:00 svlogd -tt /var/log/service/proxy-2222-to-22 
 1229 logger     0:00 svlogd -tt /var/log/service/dhcpd_if 
 1234 logger     0:00 svlogd -tt /var/log/service/ftpd_bbox 
 1236 root       0:00 tcpsvd -vE -l 0 -c 40 0.0.0.0 21 setuidgid root ./busybox ftpd -vv -t10 /.1/video 
 1733 root       0:00 [hd-audio0]
 1741 dns        0:00 dnscache 
 2292 root       0:00 xinit 
 2293 root       0:00 X :0 
 2297 root       0:00 xterm -geometry +1+1 -n login 
 2298 root       0:00 bash 
 2302 root       0:00 ps -A 


When I exit mplayer and start it again, it works.

What can I try next?
-- 
vda
