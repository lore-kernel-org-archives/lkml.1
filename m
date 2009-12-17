Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbZLQJF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbZLQJF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 04:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759324AbZLQJFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 04:05:22 -0500
Received: from hmcexedge02.ikoula.com ([78.24.135.22]:4389 "EHLO
	mail.hmc.ikoula.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752379AbZLQJFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 04:05:17 -0500
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Dec 2009 04:05:16 EST
From: Romain Kubany <rkubany@ikoula.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 17 Dec 2009 09:59:47 +0100
Subject: Possible regression of LBA48 support for piix
Thread-Topic: Possible regression of LBA48 support for piix
Thread-Index: Acp+90jcb9hvSydBQqC2RSYAeHFnhw==
Message-ID: <A9C151C7BD19EC47976D4AA14CF277A8BC64DFB2AF@HMCEXMBX01CLUS.hmcikoula.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {1A0F744F-2E54-441D-965C-A27530A3D974}
x-cr-hashedpuzzle: AetT BIi3 BWSH B9hu Cy69 EGUC E5hL FaR1 HaAs H6YY IYXK
 I1Ev JNUy JWXu JZ5V
 J7X6;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{1A0F744F-2E54-441D-965C-A27530A3D974};cgBrAHUAYgBhAG4AeQBAAGkAawBvAHUAbABhAC4AYwBvAG0A;Thu,
 17 Dec 2009 08:59:47
 GMT;UABvAHMAcwBpAGIAbABlACAAcgBlAGcAcgBlAHMAcwBpAG8AbgAgAG8AZgAgAEwAQgBBADQAOAAgAHMAdQBwAHAAbwByAHQAIABmAG8AcgAgAHAAaQBpAHgA
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We are using Microsoft Hyper-V Virtualization technology for some of our GNU/Linux guests and we recently discovered 
that the emulated hardware does not seem to support LBA48 adressing on IDE controller.

After some tests, here are the results on a VM with a 200GB virtual disk : disk is detected as 214748MB up to kernel 2.6.27.41 and as 136899MB in 2.6.28 and up.

The two kernels (2.6.27.41 and 2.6.28) were compiled with approximatively the same parameters (just an oldconfig between them, I'll paste a line to their respective config at the end of the mail)
except that many changes occured in IDE management between 2.6.27 and 2.6.28 series of the kernel so it is possible that the problem is coming from a misconfiguration on our side (in which case I'll present you my truthful apologies for making you waste your time).

Here are some useful informations (I think) for start :

[On the "working" kernel, 2.6.27.41 w/ 200GB recognized vdisk]

# hdparm -I /dev/hda

/dev/hda:

ATA device, with non-removable media
        Model Number:       Virtual HD
        Serial Number:
        Firmware Revision:  1.1.0
Standards:
        Likely used: 2
Configuration:
        Logical         max     current
        cylinders       16383   65535
        heads           16      16
        sectors/track   63      255
        --
        bytes/track: 65024      bytes/sector: 512
        CHS current addressable sectors:  267382800
        LBA    user addressable sectors:  267382800
        device size with M = 1024*1024:      130558 MBytes
        device size with M = 1000*1000:      136899 MBytes (136 GB)
Capabilities:
        LBA, IORDY(can be disabled)
        Buffer size: 64.0kB
        Standby timer values: spec'd by Vendor
        R/W multiple sector transfer: Max = 128 Current = 128
        DMA: sdma0 sdma1 sdma2 mdma0 mdma1 *mdma2
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4
             Cycle time: no flow control=333ns  IORDY flow control=120ns

-------------------------------------------------------------------------


# fdisk -l

Disk /dev/hda: 214.7 GB, 214748364800 bytes
16 heads, 63 sectors/track, 416101 cylinders
Units = cylinders of 1008 * 512 = 516096 bytes
Disk identifier: 0xd7267427

   Device Boot      Start         End      Blocks   Id  System
/dev/hda1   *           1         204      102815+  83  Linux
/dev/hda2             205        2236     1024128   82  Linux swap / Solaris
/dev/hda3            2237       20805     9358776   83  Linux


-------------------------------------------------------------------------

(some dmesg lines, I'll provide more if necessary)

[    0.580031] piix 0000:00:07.1: IDE controller (0x8086:0x7111 rev 0x01)
[    0.580031] piix 0000:00:07.1: not 100% native mode: will probe irqs later
[    0.580031]     ide0: BM-DMA at 0xffa0-0xffa7
[    0.584031]     ide1: BM-DMA at 0xffa8-0xffaf
[    0.584031] Probing IDE interface ide0...
[    0.908031] hda: Virtual HD, ATA DISK drive
[    1.632031] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    1.632031] hda: MWDMA2 mode selected
[    1.636031] Probing IDE interface ide1...
[    2.424031] hdc: Virtual CD, ATAPI CD/DVD-ROM drive
[    3.148031] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO2
[    3.148031] hdc: MWDMA2 mode selected
[    3.148031] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    3.156031] isa bounce pool size: 16 pages
[    3.156031] ide1 at 0x170-0x177,0x376 on irq 15
[    3.164031] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    3.164031] ide_generic: I/O resource 0x1F0-0x1F7 not free.
[    3.164031] ide_generic: I/O resource 0x170-0x177 not free.
[    3.168031] hda: max request size: 512KiB
[    3.168031] hda: 419430400 sectors (214748 MB) w/64KiB Cache, CHS=26108/255/63
[    3.176031]  hda: hda1 hda2 hda3
[    3.196031] Driver 'sd' needs updating - please use bus_type methods


-------------------------------------------------------------------------

[On the "non-working" kernel, 2.6.28 w/ 136GB recognized vdisk]


# hdparm -I /dev/hda

/dev/hda:

ATA device, with non-removable media
        Model Number:       Virtual HD
        Serial Number:
        Firmware Revision:  1.1.0
Standards:
        Likely used: 2
Configuration:
        Logical         max     current
        cylinders       16383   65535
        heads           16      16
        sectors/track   63      255
        --
        bytes/track: 65024      bytes/sector: 512
        CHS current addressable sectors:  267382800
        LBA    user addressable sectors:  267382800
        device size with M = 1024*1024:      130558 MBytes
        device size with M = 1000*1000:      136899 MBytes (136 GB)
Capabilities:
        LBA, IORDY(can be disabled)
        Buffer size: 64.0kB
        Standby timer values: spec'd by Vendor
        R/W multiple sector transfer: Max = 128 Current = 128
        DMA: sdma0 sdma1 sdma2 mdma0 mdma1 *mdma2
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4
             Cycle time: no flow control=333ns  IORDY flow control=120ns

-------------------------------------------------------------------------

# fdisk -l

Disk /dev/hda: 136.8 GB, 136899993600 bytes
16 heads, 63 sectors/track, 265260 cylinders
Units = cylinders of 1008 * 512 = 516096 bytes
Disk identifier: 0xd7267427

   Device Boot      Start         End      Blocks   Id  System
/dev/hda1   *           1         204      102815+  83  Linux
/dev/hda2             205        2236     1024128   82  Linux swap / Solaris
/dev/hda3            2237       20805     9358776   83  Linux

-------------------------------------------------------------------------

[    0.768002] piix 0000:00:07.1: IDE controller (0x8086:0x7111 rev 0x01)
[    0.772002] piix 0000:00:07.1: not 100% native mode: will probe irqs later
[    0.772002]     ide0: BM-DMA at 0xffa0-0xffa7
[    0.776002]     ide1: BM-DMA at 0xffa8-0xffaf
[    0.780002] Probing IDE interface ide0...
[    1.068002] hda: Virtual HD, ATA DISK drive
[    1.744004] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    1.744004] hda: MWDMA2 mode selected
[    1.744004] Probing IDE interface ide1...
[    2.480005] hdc: Virtual CD, ATAPI CD/DVD-ROM drive
[    3.156006] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO2
[    3.156006] hdc: MWDMA2 mode selected
[    3.164006] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    3.172006] isa bounce pool size: 16 pages
[    3.176006] ide1 at 0x170-0x177,0x376 on irq 15
[    3.180006] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    3.180006] ide-gd driver 1.18
[    3.184006] hda: max request size: 128KiB
[    3.184006] hda: 267382800 sectors (136899 MB) w/64KiB Cache, CHS=65535/16/63
[    3.188006]  hda: hda1 hda2 hda3
[    3.208006] Driver 'sd' needs updating - please use bus_type methods

-------------------------------------------------------------------------

As you can see, the "max request size" and number of sectors differ from one kernel to another.

Here, you can find the config used for our 2.6.27.41 kernel : http://pastebin.com/f6cf213f8 

And here, the one for the 2.6.28 : http://pastebin.com/f7b687511 

For conclusion, here is a lspci -vv (identical under both kernels) : http://pastebin.com/f11b553d4 

Maybe it's not a bug, I hope I'm wrong and it's because I forgot an option in menuconfig but I think I've enabled everything that could be related so... any idea ?
