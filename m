Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbZBRUhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbZBRUhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 15:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZBRUhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 15:37:05 -0500
Received: from physics.harvard.edu ([128.103.101.20]:45152 "EHLO
	physics.harvard.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbZBRUhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 15:37:04 -0500
X-Greylist: delayed 688 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Feb 2009 15:37:04 EST
From: Andy Neitzke <neitzke@physics.harvard.edu>
Reply-To: Andy Neitzke <neitzke@post.harvard.edu>
To: linux-kernel@vger.kernel.org
Subject: unable to shut down cleanly with 2.6.29-rc (can't remove snd-hda-codec-analog)
Date: Wed, 18 Feb 2009 15:25:31 -0500
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200902181525.31331.neitzke@physics.harvard.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With 2.6.29-rc kernels I am unable to shutdown my laptop (Thinkpad X60t) 
cleanly.  The shutdown gets stuck when it tries to unload the modules related 
to ALSA; specifically module "snd-hda-codec-analog" is the 
troublemaker.  "lsmod" indicates this module is "Used by 1" but doesn't give 
any clue about who is using it.

I had no problem with 2.6.28.  Bisection identifies the bad commit as 
1289e9e8b42f973f2ab39e5f4f2239ff826c27e9, 
"ALSA: hda - Modularize HD-audio driver".  Indeed before this commit the 
offending module did not exist.

Some basic info below (taken before trying to shut down):

andy@chirality ~ $ lsmod
Module                  Size  Used by
i915                  148472  2 
coretemp                6640  0 
snd_seq_oss            29840  0 
snd_seq_midi_event      6624  1 snd_seq_oss
snd_seq                49712  4 snd_seq_oss,snd_seq_midi_event
snd_seq_device          6708  2 snd_seq_oss,snd_seq
snd_pcm_oss            37984  0 
snd_mixer_oss          14672  1 snd_pcm_oss
ntfs                   84976  1 
ricoh_mmc               4144  0 
snd_hda_codec_analog    76064  1 
arc4                    1968  2 
ecb                     3024  2 
cryptomgr              86672  0 
aead                    6704  1 cryptomgr
crypto_blkcipher       11428  2 ecb,cryptomgr
crypto_hash            10144  1 cryptomgr
crypto_algapi          15408  6 
arc4,ecb,cryptomgr,aead,crypto_blkcipher,crypto_hash
snd_hda_intel          26600  0 
snd_hda_codec          56928  2 snd_hda_codec_analog,snd_hda_intel
snd_pcm                72984  3 snd_pcm_oss,snd_hda_intel,snd_hda_codec
ath9k                 235776  0 
snd_timer              20496  2 snd_seq,snd_pcm
firewire_ohci          23236  0 
snd                    56424  10 
snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_hda_codec_analog,snd_hda_intel,snd_hda_codec,snd_pcm,snd_timer
yenta_socket           24764  0 
mac80211              149768  1 ath9k
firewire_core          37972  1 firewire_ohci
rsrc_nonstatic          9840  1 yenta_socket
snd_page_alloc          8832  2 snd_hda_intel,snd_pcm
e1000e                112032  0 
psmouse                41596  0 
pcmcia_core            33252  2 yenta_socket,rsrc_nonstatic
video                  20628  0 
sdhci_pci               7856  0 
cfg80211               37808  1 mac80211
i2c_i801                9420  0 
rtc_cmos               10952  0 
intelfb                34936  0 
crc_itu_t               2000  1 firewire_core
sdhci                  15988  1 sdhci_pci
rtc_core               16356  1 rtc_cmos
rtc_lib                 2720  1 rtc_core
output                  3040  1 video
thinkpad_acpi          59028  0 
rfkill                 10628  4 ath9k,thinkpad_acpi
backlight               4728  2 video,thinkpad_acpi
led_class               4280  3 ath9k,sdhci,thinkpad_acpi
evdev                  10448  10 
nvram                   7260  1 thinkpad_acpi

andy@chirality ~ $ lspci
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 
945GT Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 
943/940GML Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS, 943/940GML 
Express Integrated Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition 
Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 
(rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 
(rev 02)
00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 
(rev 02)
00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 
(rev 02)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI 
Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge 
(rev 02)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller 
(rev 02)
00:1f.2 SATA controller: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA 
AHCI Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 
02)
02:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet 
Controller
03:00.0 Network controller: Atheros Communications, Inc. AR5418 802.11a/b/g/n 
Wireless PCI Express Adapter (rev 01)
15:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b4)
15:00.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C552 IEEE 1394 Controller (rev 
09)
15:00.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host 
Adapter (rev 18)


-Andy
