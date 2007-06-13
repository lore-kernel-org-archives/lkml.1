Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbXFMLmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbXFMLmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 07:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbXFMLmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 07:42:33 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60713 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757232AbXFMLmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 07:42:32 -0400
Date: Wed, 13 Jun 2007 13:07:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       Zhu Yi <yi.zhu@intel.com>
Subject: Re: ipw3945 driver in recent -mm kernels
Message-ID: <20070613110718.GA1800@elf.ucw.cz>
References: <20070609192703.GA6410@elf.ucw.cz> <20070609215712.GA13678@elf.ucw.cz> <466DA14D.6080309@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466DA14D.6080309@linux.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

BTW could we get some more reasonable path? Currently wifi drivers are
in

drivers/net/wireless/mac80211/iwlwifi

...ouch. drivers/mac80211/iwlwifi would be better...

> > I still do not see the wlan led. It seems to scan okay, but I can't
> > seem to connect, and I get this in logs:
> > 
> > Jun  9 23:53:21 amd kernel: wlan0: deauthenticated
> > Jun  9 23:53:21 amd kernel: wlan0: RX deauthentication from
> > 00:11:2f:0e:95:a0 (reason=4)
> 
> >From Table 19 in the IEEE 802.11 spec lists reason 4 a 
> 'disassociation due to inactivity'  Odd that it would happen during
>  association.  Were you able to associate at all before you
> started seeing the problem?

No, I could not get any connection.


> > Jun  9 23:53:21 amd last message repeated 2 times
> > Jun  9 23:53:22 amd kernel: wlan0: authenticate with AP
> > 00:11:2f:0e:95:a0
...
> 
> This may be related to mac80211's link activity detection
> at times immediately following an association/reassociation.
> 
> I've seen similar behavior here; a temporary work around I am using is 
> to disable the 'lost link detection' in mac80211.  

Trying with that patch:

root@amd:/data/l/linux-mm/drivers/net/wireless/mac80211/iwlwifi#
insmod iwl3945.ko
root@amd:/data/l/linux-mm/drivers/net/wireless/mac80211/iwlwifi#
killall klogd
root@amd:/data/l/linux-mm/drivers/net/wireless/mac80211/iwlwifi#
iwlist wlan0 scan
Warning: Driver for device wlan0 has been compiled with version 22
of Wireless Extension, while this program supports up to version 17.
Some things may be broken...

wlan0     Interface doesn't support scanning : Network is down

root@amd:/data/l/linux-mm/drivers/net/wireless/mac80211/iwlwifi#
ifconfig wlan0 up
root@amd:/data/l/linux-mm/drivers/net/wireless/mac80211/iwlwifi#
iwlist wlan0 scan
Warning: Driver for device wlan0 has been compiled with version 22
of Wireless Extension, while this program supports up to version 17.
Some things may be broken...

wlan0     Scan completed :
          Cell 01 - Address: 00:11:2F:0E:95:A0
                    ESSID:"pavel"
                    Mode:Master
                    Channel:1
                    Frequency:2.412 GHz
                    Quality=88/100  Signal level=-45 dBm
                    Encryption key:off
                    Bit Rate:1 Mb/s
                    Bit Rate:2 Mb/s
                    Bit Rate:5.5 Mb/s
                    Bit Rate:11 Mb/s
                    Bit Rate:6 Mb/s
                    Bit Rate:9 Mb/s
                    Bit Rate:12 Mb/s
                    Bit Rate:18 Mb/s
                    Bit Rate:24 Mb/s
                    Bit Rate:36 Mb/s
                    Bit Rate:48 Mb/s
                    Bit Rate:54 Mb/s
                    Extra:tsf=000001d9866dbe25

root@amd:/data/l/linux-mm/drivers/net/wireless/mac80211/iwlwifi#
iwconfig wlan0 essid pavel
root@amd:/data/l/linux-mm/drivers/net/wireless/mac80211/iwlwifi#
iwl3945: REPLY_ADD_STA failed

root@amd:/data/l/linux-mm/drivers/net/wireless/mac80211/iwlwifi#
ifconfig eth0 down
root@amd:/data/l/linux-mm/drivers/net/wireless/mac80211/iwlwifi#
iwconfig
eth0      no wireless extensions.

lo        no wireless extensions.

irlan0    no wireless extensions.

wmaster0  no wireless extensions.

Warning: Driver for device wlan0 has been compiled with version 22
of Wireless Extension, while this program supports up to version 17.
Some things may be broken...

wlan0     IEEE 802.11g  ESSID:"pavel"
          Mode:Managed  Frequency:2.412 GHz  Access Point:
00:11:2F:0E:95:A0
          Bit Rate=11 Mb/s
          Retry min limit:7   RTS thr:off   Fragment thr=2346 B
          Encryption key:off
          Link Quality=77/100  Signal level=-40 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

root@amd:/data/l/linux-mm/drivers/net/wireless/mac80211/iwlwifi#
ifconfig wlan0 10.0.0.6 up
root@amd:/data/l/linux-mm/drivers/net/wireless/mac80211/iwlwifi# ping
10.0.0.3
PING 10.0.0.3 (10.0.0.3): 56 data bytes


(no link here).

Aha, so I pressed ^c and  attempted to kick it into life, and got some errors:

root@amd:/data/l/linux-mm/drivers/net/wireless/mac80211/iwlwifi#
ifconfig wlan0 down
root@amd:/data/l/linux-mm/drivers/net/wireless/mac80211/iwlwifi#
ifconfig wlan0 up
iwl3945: Microcode SW error detected.  Restarting 0x82000000.
iwl3945: Error Reply type 0x0000003A cmd REPLY_RXON_ASSOC (0x11) seq
0x0430 ser 0x00000000
iwl3945: Error setting RXON_ASSOC configuration (-5).
iwl3945: Error sending REPLY_RXON: time out after 500ms.
iwl3945: Error setting new configuration (-110).
iwl3945: Error sending REPLY_ADD_STA: time out after 500ms.
iwl3945: ipw going down
root@amd:/data/l/linux-mm/drivers/net/wireless/mac80211/iwlwifi#
iwl3945: Can't stop Rx DMA.
iwl3945: Grabbing access while already held at line 825.
iwl3945: Microcode SW error detected.  Restarting 0x82000000.
iwl3945: Error Reply type 0x000004EB cmd REPLY_TX_PWR_TABLE_CMD (0x97)
seq 0x0402 ser 0x00000000
iwl3945: ipw going down
iwl3945: Can't stop Rx DMA.
iwl3945: Grabbing access while already held at line 825.

...I'll turn on the microcode debug now.
										Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
