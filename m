Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbXCYTR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbXCYTR4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 15:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbXCYTRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 15:17:55 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:50243 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752063AbXCYTRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 15:17:53 -0400
Message-ID: <4606CA92.1000405@boichat.ch>
Date: Mon, 26 Mar 2007 03:16:34 +0800
From: Nicolas Boichat <nicolas@boichat.ch>
User-Agent: Thunderbird 1.5.0.10 (X11/20070309)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, alsa-devel@lists.sourceforge.net,
       tiwai@suse.de
Subject: [BUG] Patch "CPU hotplug: call check_tsc_sync_source() with irqs
 off" breaks some drivers
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 137.132.187.18 (nusnet-187-18.dynip.nus.edu.sg)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm running a Macbook Pro first generation (Core Duo, so x86).

I ran accross these two problems while upgrading from 2.6.21-rc3 to the
current git HEAD:
 1. appletouch cannot initialize the device properly at boot time (the
module is automatically loaded by Gentoo), I have to reload the module
to get it to work.
 2. ALSA hda_intel (patch_sigmatel) fails to read properly the subsystem
id. "head  /proc/asound/card0/codec#0" returns:
> Codec: SigmaTel STAC9221 A1
> Address: 0
> Vendor Id: 0x83847680
> Subsystem Id: 0x100
> Revision Id: 0x103401
while I expect this subsystem id: 0x106b0200.
This is due to a read failure in sound/pci/hda/hda_codec.c at line 553
(I have to reboot on OS X to get the id correct again, and it seems to
happen quite randomly, so I'm not absolutely certain this bug is
related, but it's something i have never seen before...)

I found out which commit seems to cause these bugs:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d04f41e35343f1d788551fd3f753f51794f4afcf

The latest GIT without this commit works fine, but doesn't with it.

See below for the relevant parts of a diff, with my comments where
needed, of the dmesg output with and without this commit. You can get
the raw dmesg outputs, and my .config there:
http://www.boichat.ch/nicolas/linux/

Best regards,

Nicolas Boichat

--- dmesg-2.6.21-rc4-head-notimestamp	2007-03-26 02:19:57.000000000 +0800

Vanilla git

+++ dmesg-2.6.21-rc4-head-without-d04f41-notimestamp	2007-03-26 02:20:14.000000000 +0800

Vanilla git with commit d04f41e35343f1d788551fd3f753f51794f4afcf reverted.

@@ -1,4 +1,4 @@
-Linux version 2.6.21-rc4 (nicolas@nunuche) (gcc version 4.1.2 (Gentoo 4.1.2)) #1 SMP PREEMPT Sun Mar 25 17:06:13 SGT 2007
+Linux version 2.6.21-rc4 (nicolas@nunuche) (gcc version 4.1.2 (Gentoo 4.1.2)) #2 SMP PREEMPT Sun Mar 25 18:16:15 SGT 2007
 BIOS-provided physical RAM map:
 sanitize start
 sanitize end
@@ -93,14 +93,14 @@
 Enabling fast FPU save and restore... done.
 Enabling unmasked SIMD FPU exception support... done.
 Initializing CPU#0
 PID hash table entries: 4096 (order: 12, 16384 bytes)
-Detected 1952.371 MHz processor.

This is WRONG. I have a 1.83 Ghz Core Duo.

+Detected 1831.082 MHz processor.

This is right.

 Console: colour VGA+ 80x25
 Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
 Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
@@ -114,7 +114,7 @@
       .data : 0xc03457ab - 0xc041782c   ( 840 kB)
       .text : 0xc0100000 - 0xc03457ab   (2325 kB)
 Checking if this processor honours the WP bit even in supervisor mode... Ok.
-Calibrating delay using timer specific routine.. 4945.92 BogoMIPS (lpj=2472960)
+Calibrating delay using timer specific routine.. 4689.63 BogoMIPS (lpj=2344818)
 Mount-cache hash table entries: 512
 CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000c1a9 00000000 00000000
 monitor/mwait feature present.
@@ -143,7 +143,7 @@
 SMP alternatives: switching to SMP code
 Booting processor 1/1 eip 3000
 Initializing CPU#1
-Calibrating delay using timer specific routine.. 3661.28 BogoMIPS (lpj=1830642)
+Calibrating delay using timer specific routine.. 3661.30 BogoMIPS (lpj=1830650)
 CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000c1a9 00000000 00000000
 monitor/mwait feature present.
 CPU: L1 I cache: 32K, L1 D cache: 32K
@@ -154,12 +154,12 @@
 Intel machine check architecture supported.
 Intel machine check reporting enabled on CPU#1.
 CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
-Total of 2 processors activated (8607.20 BogoMIPS).
+Total of 2 processors activated (8350.93 BogoMIPS).
 ENABLING IO-APIC IRQs
 ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
 checking TSC synchronization [CPU#0 -> CPU#1]: passed.
 Brought up 2 CPUs
-migration_cost=34
+migration_cost=46
 PM: Adding info for No Bus:platform
 NET: Registered protocol family 16
 PM: Adding info for No Bus:vtcon0
@@ -336,9 +336,9 @@
 pnp: 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
 pnp: 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
 pnp: 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
+Time: tsc clocksource has been installed.
 pnp: 00:06: iomem range 0xfed00000-0xfed003ff has been reserved
 PM: Adding info for No Bus:mem
-Time: tsc clocksource has been installed.
 PM: Adding info for No Bus:kmem
 PM: Adding info for No Bus:null
 PM: Adding info for No Bus:port
@@ -385,7 +385,7 @@
 Machine check exception polling timer started.
 PM: Adding info for platform:pcspkr
 audit: initializing netlink socket (disabled)
-audit(1174817446.273:1): initialized
+audit(1174817951.346:1): initialized
 highmem bounce pool size: 64 pages
 Total HugeTLB memory allocated, 0
 io scheduler noop registered
@@ -755,66 +772,76 @@
 sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
 Uniform CD-ROM driver Revision: 3.20
 sr 0:0:0:0: Attached scsi CD-ROM sr0
-drivers/usb/input/appletouch.c: Could not do mode read request from device (Geyser 3 mode)
-appletouch: probe of 1-2:1.1 failed with error -12
 usb 5-4: new high speed USB device using ehci_hcd and address 4
+Clocksource tsc unstable (delta = -288700753 ns)
 PM: Adding info for usb:5-4
 PM: Adding info for No Bus:usbdev5.4_ep00
 usb 5-4: configuration #1 chosen from 1 choice
 PM: Adding info for usb:5-4:1.0
 PM: Adding info for No Bus:usbdev5.4
-Clocksource tsc unstable (delta = -292504439 ns)
 usbcore: registered new interface driver appletouch
@@ -921,6 +948,7 @@
 -> GSI 22 (level, low) -> IRQ 21
 PCI: Setting latency timer of device 0000:00:1b.0 to 64
 hda_codec: STAC922x, Apple subsys_id=100
+hda_intel: azx_get_response timeout, switching to polling mode...
 PM: Adding info for No Bus:pcmC0D1p
 PM: Adding info for No Bus:pcmC0D0p
 PM: Adding info for No Bus:pcmC0D0c


