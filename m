Return-Path: <linux-kernel-owner+w=401wt.eu-S1946580AbXBQJt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946580AbXBQJt2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 04:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946579AbXBQJt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 04:49:28 -0500
Received: from yumi.tdiedrich.de ([85.10.210.183]:1334 "EHLO yumi.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946575AbXBQJt0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 04:49:26 -0500
Date: Sat, 17 Feb 2007 10:49:19 +0100
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: pata_amd dropping to PIO on resume
Message-ID: <20070217094919.GA24506@melchior.yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Jeff Garzik <jeff@garzik.org>, Robert Hancock <hancockr@shaw.ca>,
	Linux Kernel ML <linux-kernel@vger.kernel.org>,
	linux-ide@vger.kernel.org, Alan <alan@lxorguk.ukuu.org.uk>
References: <fa.q7ZuddHInqn2dVlS+EWjXjPvFC8@ifi.uio.no> <45D63BCE.2080700@shaw.ca> <45D6436C.4060209@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <45D6436C.4060209@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Robert Hancock wrote:
> >Yes, the fact that it's going into simplex mode is the problem, it 
> >wasn't in simplex to start with. It looks like pata_amd does an 
> >ata_pci_clear_simplex only for certain chip models, maybe this model 
> >needs it as well?
> 
> Deleting the ata_pci_clear_simplex() call, then adding 
> ATA_FLAG_IGN_SIMPLEX to the ata_port_info info[] array, is also worth 
> trying.

I tried the latter option and it works fine.
I didn't delete the ata_pci_clear_simplex call, since it is not
called for this model.

BTW, this the nVidia MCP55 IDE controller:
00:04.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1)
00:04.0 0101: 10de:036e (rev a1)

Index: linux-2.6.20/drivers/ata/pata_amd.c
===================================================================
--- linux-2.6.20.orig/drivers/ata/pata_amd.c	2007-02-17 10:27:59.000000000 +0100
+++ linux-2.6.20/drivers/ata/pata_amd.c	2007-02-17 10:28:14.000000000 +0100
@@ -611,7 +611,7 @@
 		},
 		{	/* 8: Nvidia Nforce2 and later */
 			.sht = &amd_sht,
-			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_IGN_SIMPLEX,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = 0x7f,	/* UDMA 133, no swdma */


[ 1087.954496] ata5.00: disabled
[ 1087.954500] ata5.01: disabled
[ 1087.958725] Trying to free nonexistent resource <00000000000001f0-00000000000001f7>
[ 1087.958730] Trying to free nonexistent resource <0000000000000170-0000000000000177>
[ 1089.559228] pata_amd 0000:00:04.0: version 0.2.7
[ 1089.559240] PCI: Setting latency timer of device 0000:00:04.0 to 64
[ 1089.560866] ata7: PATA max UDMA/133 cmd 0x1F0 ctl 0x3F6 bmdma 0xF000 irq 14
[ 1089.561118] ata8: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xF008 irq 15
[ 1089.561133] scsi8 : pata_amd
[ 1089.717718] ata7.00: ATAPI, max UDMA/33
[ 1089.797629] ata7.01: ATAPI, max UDMA/66
[ 1089.877519] ata7.00: configured for UDMA/33
[ 1089.957429] ata7.01: configured for UDMA/33
[ 1089.957948] scsi9 : pata_amd
[ 1089.957996] ata8: port disabled. ignoring.
[ 1089.957998] ata8: reset failed, giving up
[ 1089.960193] scsi 8:0:0:0: CD-ROM            _NEC     DVD_RW ND-3500AG 2.1A PQ: 0 ANSI: 5
[ 1089.962400] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[ 1089.962442] sr 8:0:0:0: Attached scsi CD-ROM sr0
[ 1089.962474] sr 8:0:0:0: Attached scsi generic sg1 type 5
[ 1089.963938] scsi 8:0:1:0: CD-ROM            PIONEER  DVD-ROM DVD-106  1.22 PQ: 0 ANSI: 5
[ 1089.966730] sr1: scsi3-mmc drive: 40x/40x cd/rw xa/form2 cdda tray
[ 1089.966769] sr 8:0:1:0: Attached scsi CD-ROM sr1
[ 1089.966802] sr 8:0:1:0: Attached scsi generic sg2 type 5
[ 1096.079852] Stopping tasks ... done.
[ 1096.126558] Shrinking memory...  -\|/-done (51275 pages freed)
[ 1097.076333] Freed 205100 kbytes in 1.63 seconds (125.82 MB/s)
[ 1097.076336] Suspending console(s)
[ 1097.080211] ACPI: PCI interrupt for device 0000:01:08.0 disabled
[ 1097.092133] ata8: port disabled. ignoring.
[ 1097.092135] ata8: reset failed, giving up
[ 1097.092153] ACPI: PCI interrupt for device 0000:00:02.1 disabled
[ 1097.098774] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[ 1097.105558] Extended CMOS year: 20
[ 1097.105562] swsusp: critical section: 
[ 1097.119909] swsusp: Need to copy 120019 pages
[   46.569060] Extended CMOS year: 20
[   46.586207] ACPI: Unable to turn cooling device [ffff81003fe90890] 'on'
[   46.599040] PCI: Enabling device 0000:00:02.0 (0000 -> 0002)
[   46.599044] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 22 (level, low) -> IRQ 22
[   46.599050] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   46.599055] PM: Writing back config space on device 0000:00:02.0 at offset f (was 1030100, writing 103010a)
[   46.599062] PM: Writing back config space on device 0000:00:02.0 at offset 4 (was 0, writing fe02f000)
[   46.599066] PM: Writing back config space on device 0000:00:02.0 at offset 1 (was b00006, writing b00007)
[   46.612354] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 23 (level, low) -> IRQ 23
[   46.612358] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   46.612371] usb usb1: root hub lost power or was reset
[   46.612378] ehci_hcd 0000:00:02.1: debug port 1
[   46.612380] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[   46.612390] PM: Writing back config space on device 0000:00:04.0 at offset b (was 82391043, writing 8239f043)
[   46.612397] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   46.612409] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   46.612441] ata8: port disabled. ignoring.
[   46.612443] ata8: reset failed, giving up
[   46.626342] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   46.626357] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   46.626369] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   46.626382] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   46.626395] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   46.626408] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[   46.638998] PM: Writing back config space on device 0000:01:08.0 at offset 1 (was 2900005, writing 2900001)
[   46.639008] ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
[   46.646863] PCI: Setting latency timer of device 0000:06:00.0 to 64
[   46.646918] ACPI: PCI Interrupt 0000:07:00.0[A] -> Link [APC6] -> GSI 16 (level, low) -> IRQ 16
[   46.646933] PM: Writing back config space on device 0000:07:00.1 at offset 1 (was 100000, writing 100004)
[   46.678942] usb usb2: root hub lost power or was reset
[   46.745556]  usbdev1.28_ep00: PM: resume from 0, parent 1-2 still 1
[   46.745558] hub 1-2:1.0: PM: resume from 1, parent 1-2 still 1
[   46.745561]  usbdev1.28_ep81: PM: resume from 0, parent 1-2:1.0 still 1
[   46.745564]  usbdev1.30_ep00: PM: resume from 0, parent 1-5 still 1
[   46.745567] usb-storage 1-5:1.0: PM: resume from 1, parent 1-5 still 1
[   46.745570]  host7: PM: resume from 0, parent 1-5:1.0 still 1
[   46.745573]  usbdev1.30_ep01: PM: resume from 0, parent 1-5:1.0 still 1
[   46.745575]  usbdev1.30_ep82: PM: resume from 0, parent 1-5:1.0 still 1
[   46.745578]  usbdev2.12_ep00: PM: resume from 0, parent 2-3 still 1
[   46.745581] usb 2-3:1.0: PM: resume from 1, parent 2-3 still 1
[   46.745584]  usbdev2.12_ep81: PM: resume from 0, parent 2-3:1.0 still 1
[   46.745586]  usbdev2.12_ep02: PM: resume from 0, parent 2-3:1.0 still 1
[   46.745589] usb 1-2.3: PM: resume from 1, parent 1-2 still 1
[   46.745592]  usbdev1.31_ep00: PM: resume from 0, parent 1-2.3 still 1
[   46.745595] usbhid 1-2.3:1.0: PM: resume from 1, parent 1-2.3 still 1
[   46.745597]  usbdev1.31_ep81: PM: resume from 0, parent 1-2.3:1.0 still 1
[   46.745600] usb 1-2.4: PM: resume from 1, parent 1-2 still 1
[   46.745603]  usbdev1.32_ep00: PM: resume from 0, parent 1-2.4 still 1
[   46.745606] usbhid 1-2.4:1.0: PM: resume from 1, parent 1-2.4 still 1
[   46.745608]  usbdev1.32_ep81: PM: resume from 0, parent 1-2.4:1.0 still 1
[   46.748609] Restarting tasks ... done.
[   46.978564] ata1: SATA link down (SStatus 0 SControl 300)
[   46.988548] usb 2-3: USB disconnect, address 12
[   47.772562] usb 1-2: USB disconnect, address 28
[   47.772566] usb 1-2.3: USB disconnect, address 31
[   47.772751] usb 1-2.4: USB disconnect, address 32
[   47.877433] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   47.885748] usb 1-2: new high speed USB device using ehci_hcd and address 33
[   47.894989] ata2.00: configured for UDMA/133
[   47.895035] SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
[   47.895043] sda: Write Protect is off
[   47.895045] sda: Mode Sense: 00 3a 00 00
[   47.895055] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   47.927453] ata7.00: configured for UDMA/33
[   47.948020] usb 1-2: configuration #1 chosen from 1 choice
[   47.948171] hub 1-2:1.0: USB hub found
[   47.948340] hub 1-2:1.0: 4 ports detected
[   48.007363] ata7.01: configured for UDMA/33
[   48.087186] usb 1-5: USB disconnect, address 30
[   48.200356] usb 1-5: new high speed USB device using ehci_hcd and address 35
[   48.263383] usb 1-5: configuration #1 chosen from 1 choice
[   48.263755] scsi10 : SCSI emulation for USB Mass Storage devices
[   48.263856] usb-storage: device found at 35
[   48.263858] usb-storage: waiting for device to settle before scanning
[   48.383455] usb 2-3: new full speed USB device using ohci_hcd and address 13
[   48.458433] usb 2-3: configuration #1 chosen from 1 choice
[   48.553393] usb 1-2.3: new low speed USB device using ehci_hcd and address 36
[   48.597647] usb 1-2.3: configuration #1 chosen from 1 choice
[   48.599177] input: Logitech USB-PS/2 Optical Mouse as /class/input/input14
[   48.599206] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.1-2.3
[   48.693218] usb 1-2.4: new low speed USB device using ehci_hcd and address 37
[   48.743343] usb 1-2.4: configuration #1 chosen from 1 choice
[   48.745447] input: HID 046a:0001 as /class/input/input15
[   48.745474] input: USB HID v1.00 Keyboard [HID 046a:0001] on usb-0000:00:02.1-2.4
[   50.761266] scsi 10:0:0:0: Direct-Access     Generic  CF Reader        1.01 PQ: 0 ANSI: 0
[   50.762291] sd 10:0:0:0: Attached scsi removable disk sdb
[   50.762324] sd 10:0:0:0: Attached scsi generic sg3 type 0
[   50.762761] scsi 10:0:0:1: Direct-Access     Generic  SM/SD/MS Reader  1.00 PQ: 0 ANSI: 0
[   50.987471] SCSI device sdc: 1984000 512-byte hdwr sectors (1016 MB)
[   50.988530] sdc: Write Protect is off
[   50.988533] sdc: Mode Sense: 03 00 00 00
[   50.988535] sdc: assuming drive cache: write through
[   50.991339] SCSI device sdc: 1984000 512-byte hdwr sectors (1016 MB)
[   50.992774] sdc: Write Protect is off
[   50.992777] sdc: Mode Sense: 03 00 00 00
[   50.992779] sdc: assuming drive cache: write through
[   50.992784]  sdc: sdc1
[   50.993510] sd 10:0:0:1: Attached scsi removable disk sdc
[   50.993545] sd 10:0:0:1: Attached scsi generic sg4 type 0
[   50.994196] usb-storage: device scan complete
[   51.419715] [drm] Loading R300 Microcode
[   96.950745] usb 1-5: USB disconnect, address 35

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
