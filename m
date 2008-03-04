Return-Path: <linux-kernel-owner+w=401wt.eu-S933663AbYCDWeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663AbYCDWeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 17:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYCDWeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 17:34:12 -0500
Received: from th5.kapitza.ras.ru ([83.149.229.88]:44995 "EHLO ari.home"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750696AbYCDWeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 17:34:10 -0500
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Mar 2008 17:34:10 EST
Date: Wed, 5 Mar 2008 01:27:30 +0300 (MSK)
From: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: ehci-hcd affects hda speed
Message-ID: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have recently installed a VT6212L-based PCI USB controller into my old 
rock-stable P3B-F computer just to discover that, even being idle, it 
significantly slows down main PATA hard drive. I have found an earlier 
thread with similar (?) problem (archived at http://marc.info/?t=111749614000002&r=1&w=2 )
but it provides no solution. Can this behaviour be explained? Can it be fixed?

There's one thing that makes me optimistic: USB traffic _speeds_up_ hda. 
That is hdparm gives ~20% improvement in buffered reads if a USB flash is 
inserted and another xterm simultaneously runs
# dd if=/dev/sda of=/dev/null bs=1024

Here's what I see:

------------------------------------------------------------------------------
# hdparm -t -T /dev/hda
 	/dev/hda:
 	 Timing cached reads:   312 MB in  2.01 seconds = 155.60 MB/sec
 	 Timing buffered disk reads:   88 MB in  3.06 seconds =  28.77 MB/sec
# modprobe ehci-hcd
# hdparm -t -T /dev/hda
 	/dev/hda:
 	 Timing cached reads:   274 MB in  2.01 seconds = 136.58 MB/sec
 	 Timing buffered disk reads:   44 MB in  3.10 seconds =  14.20 MB/sec
# rmmod ehci-hcd
# hdparm -t -T /dev/hda
 	/dev/hda:
 	 Timing cached reads:   286 MB in  2.01 seconds = 142.48 MB/sec
 	 Timing buffered disk reads:   90 MB in  3.06 seconds =  29.44 MB/sec
------------------------------------------------------------------------------

And here's what I have (kernel 2.6.24.3):

------------------------------------------------------------------------------
#lspci -v

00:09.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 62) (prog-if 00 [UHCI])
         Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
         Flags: medium devsel, IRQ 5
         I/O ports at d000 [size=32]
         Capabilities: [80] Power Management version 2

00:09.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 62) (prog-if 00 [UHCI])
         Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
         Flags: medium devsel, IRQ 9
         I/O ports at b800 [size=32]
         Capabilities: [80] Power Management version 2

00:09.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 65) (prog-if 20 [EHCI])
         Subsystem: VIA Technologies, Inc. USB 2.0
         Flags: bus master, medium devsel, latency 32, IRQ 11
         Memory at d3800000 (32-bit, non-prefetchable) [size=256]
         Capabilities: [80] Power Management version 2

# cat /proc/interrupts
            CPU0
   0:  100814528    XT-PIC-XT        timer
   1:       4057    XT-PIC-XT        i8042
   2:          0    XT-PIC-XT        cascade
   3:       1013    XT-PIC-XT
   4:          2    XT-PIC-XT
   5:    7165568    XT-PIC-XT        bttv0, FM801, uhci_hcd:usb2, uhci_hcd:usb3
   8:   25956003    XT-PIC-XT
   9:     661413    XT-PIC-XT        eth1, uhci_hcd:usb4
  10:          4    XT-PIC-XT
  11:   13526145    XT-PIC-XT        eth0, ehci_hcd:usb1
  12:    1068179    XT-PIC-XT        i8042
  14:     710123    XT-PIC-XT        ide0
  15:       4365    XT-PIC-XT        ide1
NMI:          0   Non-maskable interrupts
TRM:          0   Thermal event interrupts
SPU:          0   Spurious interrupts
ERR:          0
------------------------------------------------------------------------------

Please let me know if I missed something important.

Thanks
-L
