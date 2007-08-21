Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbXHUIDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbXHUIDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 04:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbXHUID2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 04:03:28 -0400
Received: from ns.miraclelinux.com ([219.118.163.66]:3265 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbXHUIDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 04:03:25 -0400
Message-ID: <46CA9C49.2070109@miraclelinux.com>
Date: Tue, 21 Aug 2007 17:03:21 +0900
From: Kiyoshi Sasaki <ksasaki@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: linux-usb-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] on the system with companion host controller,
 error -71 returns
References: <46CA8D4D.70201@miraclelinux.com>
In-Reply-To: <46CA8D4D.70201@miraclelinux.com>
Content-Type: multipart/mixed;
 boundary="------------030409010808040004090800"
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.21.3327
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030409010808040004090800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

attaching dmesgs.

-- 

Kiyoshi Sasaki <ksasaki@miraclelinux.com>

> Hello,
> 
> I see below errors in dmesg on ICH6/ICH7 machine:
> 
> usb 1-1: device not accepting address 2, error -71
> or
> usb 1-1: device descriptor read/all, error -71
> 
> I'm trying to debug it, but by now I can't make it.
> Can you give me your help ?
> 
> ----
> 
> On ICH6/ICH7, in case load sequence is uhci first and ehci second,
> each controller is initialized/registered in usb_add_hcd() like below.
> 
> uhci_hcd 0000:00:1d.0: UHCI Host Controller
> uhci_hcd 0000:00:1d.1: UHCI Host Controller
> uhci_hcd 0000:00:1d.2: UHCI Host Controller
> uhci_hcd 0000:00:1d.3: UHCI Host Controller
> ehci_hcd 0000:00:1d.7: EHCI Host Controller
> 
> And on ehci_hcd turn, usb_add_hcd() calls ehci_run() to start ehci.
> In ehci_run(), it sets Configure Flag (CF) to 1 for enabling full
> USB 2.0 functionality.
> 
> static int ehci_run (struct usb_hcd *hcd)
> {
> ...
>         /*
>          * Start, enabling full USB 2.0 functionality ... usb 1.1 devices
>          * are explicitly handed to companion controller(s), so no TT is
>          * involved with the root hub.  (Except where one is integrated,
>          * and there's no companion controller unless maybe for USB OTG.)
>          */
>         hcd->state = HC_STATE_RUNNING;
>         writel (FLAG_CF, &ehci->regs->configured_flag);
> ...
> }
> 
> On the other hand, uhci tries to get device information using
> hub_set_address() and usb_get_device_descriptor().
> These functions send URB, and URB is processed like below.
> This is done asynchronously.
> 
> - uhci_irq()
>   - uhci_scan_schedule()
>     - uhci_scan_qh()
>       - uhci_result_common()
>         - uhci_map_status()
> 
> uhci_map_status() checks td_status. And the flag is TD_CTRL_STALLED
> |TD_CTRL_CRCTIMEO, and return with error.
> So, hub_set_address() and usb_get_device_descriptor() return -71.
> 
> After some debugging, I found if hub_set_address() and
> usb_get_device_descriptor() is called before CF becomes 1,
> no error returns. Conversely, if these are called even just after
> CF becomes 1, error -71 returns.
> CF becomes 1 means "writel (FLAG_CF, &ehci->regs->configured_flag)".
> 
> To avoid this error, my silly idea is
> 
> 1) before set CF to 1, wait some asynchronous uhci processing
> 2) load ehci first and uhci second
> 
> But for 1), simple msleep() will not work well, and need to
> control khubd and so on, so this seems not smart.
> 
> 
> Do you have any idea to fix this issue ?
> 

--------------030409010808040004090800
Content-Type: text/plain;
 name="dmesg_1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg_1"

USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 233
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 233, io base 0x00003000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 50
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 50, io base 0x00003020
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[B] -> GSI 22 (level, low) -> IRQ 50
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 50, io base 0x00003040
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[C] -> GSI 21 (level, low) -> IRQ 58
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 58, io base 0x00003060
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-1: new full speed USB device using uhci_hcd and address 2
ohci_hcd: 2005 April 22 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 20 (level, low) -> IRQ 66
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 66, io mem 0xdfd00000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
SCSI subsystem initialized
libata version 2.21 loaded.
ata_piix 0000:00:1f.2: version 2.11
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 74
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x000130e8 ctl 0x000130de bmdma 0x000130b0 irq 0
ata2: SATA max UDMA/133 cmd 0x000130e0 ctl 0x000130da bmdma 0x000130b8 irq 0
usb 1-1: device not accepting address 2, error -71
ata1.00: ata_hpa_resize 1: sectors = 156250080, hpa_sectors = 156301488
ata1.00: Host Protected Area detected:
	current size: 156250080 sectors
	native size: 156301488 sectors
ata1.00: ATA-7: WDC WD800JD-19MSA1, 10.01E01, max UDMA/133
ata1.00: 156250080 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: ata_hpa_resize 1: sectors = 156250080, hpa_sectors = 156301488
ata1.00: Host Protected Area detected:
	current size: 156250080 sectors
	native size: 156301488 sectors
ata1.00: configured for UDMA/133
ATA: abnormal status 0x7F on port 0x000130e7
ATA: abnormal status 0x7F on port 0x000130e7
ata2.01: ata_hpa_resize 1: sectors = 156250080, hpa_sectors = 156301488
ata2.01: Host Protected Area detected:
	current size: 156250080 sectors
	native size: 156301488 sectors
ata2.01: ATA-7: WDC WD800JD-19MSA1, 10.01E01, max UDMA/133
ata2.01: 156250080 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.01: ata_hpa_resize 1: sectors = 156250080, hpa_sectors = 156301488
ata2.01: Host Protected Area detected:
	current size: 156250080 sectors
	native size: 156301488 sectors
ata2.01: configured for UDMA/133
  Vendor: ATA       Model: WDC WD800JD-19MS  Rev: 10.0
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 156250080 512-byte hdwr sectors (80000 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
SCSI device sda: 156250080 512-byte hdwr sectors (80000 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
  Vendor: ATA       Model: WDC WD800JD-19MS  Rev: 10.0
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdb: 156250080 512-byte hdwr sectors (80000 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
SCSI device sdb: 156250080 512-byte hdwr sectors (80000 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
 sdb:
sd 1:0:1:0: Attached scsi disk sdb
usb 1-1: new full speed USB device using uhci_hcd and address 4
usb 1-1: configuration #1 chosen from 1 choice
input: ServerEngines SE USB Device as /class/input/input0
input: USB HID v1.11 Keyboard [ServerEngines SE USB Device] on usb-0000:00:1d.0-1
input: ServerEngines SE USB Device as /class/input/input1
input: USB HID v1.11 Mouse [ServerEngines SE USB Device] on usb-0000:00:1d.0-1
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
audit(1184168677.728:2): selinux=0 auid=4294967295
intel_rng: FWH not detected
input: PC Speaker as /class/input/input2
input: PS/2 Generic Mouse as /class/input/input3
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 74
hda: ATAPI 24X DVD-ROM drive, 256kB Cache, UDMA(66)
Uniform CD-ROM driver Revision: 3.20
Intel(R) PRO/1000 Network Driver - version 7.2.9-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:0a:00.0[A] -> GSI 16 (level, low) -> IRQ 169
PCI: Setting latency timer of device 0000:0a:00.0 to 64
e1000: 0000:0a:00.0: e1000_probe: (PCI Express:2.5Gb/s:32-bit) 00:16:e6:5c:e0:fe
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:1:0: Attached scsi generic sg1 type 0
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:0b:00.0[A] -> GSI 17 (level, low) -> IRQ 177
PCI: Setting latency timer of device 0000:0b:00.0 to 64
e1000: 0000:0b:00.0: e1000_probe: (PCI Express:2.5Gb/s:32-bit) 00:16:e6:5c:e0:ff
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
floppy0: no floppy controllers found
lp: driver loaded but no devices found
ACPI: Power Button (FF) [PWRF]
ACPI: Power Button (CM) [PWRB]
ibm_acpi: ec object not found

--------------030409010808040004090800
Content-Type: text/plain;
 name="dmesg_2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg_2"

USB Universal Host Controller Interface driver v3.0
GSI 19 sharing vector 0x92 and IRQ 19
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 21 (level, low) -> IRQ 146
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 146, io base 0x00001000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[A] -> GSI 21 (level, low) -> IRQ 146
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 146, io base 0x00001020
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
GSI 20 sharing vector 0x9A and IRQ 20
ACPI: PCI Interrupt 0000:00:1d.2[B] -> GSI 23 (level, low) -> IRQ 154
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 154, io base 0x00001040
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb 1-1: new full speed USB device using uhci_hcd and address 2
GSI 21 sharing vector 0xA2 and IRQ 21
ACPI: PCI Interrupt 0000:00:1d.3[C] -> GSI 22 (level, low) -> IRQ 162
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 162, io base 0x00001060
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ohci_hcd: 2005 April 22 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
GSI 22 sharing vector 0xAA and IRQ 22
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 20 (level, low) -> IRQ 170
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 170, io mem 0xdf700000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
usb 1-1: device descriptor read/all, error -71
SCSI subsystem initialized
megasas: 00.00.03.05 Mon Oct 02 11:21:32 PDT 2006
megasas: 0x1000:0x0060:0x1033:0x835a: bus 3:slot 0:func 0
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 169
PCI: Setting latency timer of device 0000:03:00.0 to 64
megasas: FW now in Ready state
scsi0 : LSI Logic SAS based MegaRAID driver
  Vendor: SEAGATE   Model: ST973402SS        Rev: 0002
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: SEAGATE   Model: ST973402SS        Rev: 0002
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: LSI       Model: MegaRAID SAS RMB  Rev: 1.12
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 141885440 512-byte hdwr sectors (72645 MB)
sda: Write Protect is off
sda: Mode Sense: 1f 00 10 08
SCSI device sda: drive cache: write through w/ FUA
SCSI device sda: 141885440 512-byte hdwr sectors (72645 MB)
sda: Write Protect is off
sda: Mode Sense: 1f 00 10 08
SCSI device sda: drive cache: write through w/ FUA
 sda: sda1 sda2 sda3
sd 0:2:0:0: Attached scsi disk sda
libata version 2.21 loaded.
ata_piix 0000:00:1f.2: version 2.11
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
GSI 23 sharing vector 0xB2 and IRQ 23
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 178
ata_piix 0000:00:1f.2: 0x1F0 IDE port busy
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi1 : ata_piix
scsi2 : ata_piix
ata1: DUMMY
ata2: SATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x00000000000110a8 irq 15
ATA: abnormal status 0x7F on port 0x0000000000010177
usb 5-7: new high speed USB device using ehci_hcd and address 3
usb 5-7: configuration #1 chosen from 1 choice
hub 5-7:1.0: USB hub found
hub 5-7:1.0: 3 ports detected
usb 1-1: new full speed USB device using uhci_hcd and address 4
usb 1-1: configuration #1 chosen from 1 choice
input: ServerEngines SE USB Device as /class/input/input0
input: USB HID v1.11 Keyboard [ServerEngines SE USB Device] on usb-0000:00:1d.0-1
input: ServerEngines SE USB Device as /class/input/input1
input: USB HID v1.11 Mouse [ServerEngines SE USB Device] on usb-0000:00:1d.0-1
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
audit(1184930680.318:2): selinux=0 auid=4294967295
input: PC Speaker as /class/input/input2
Intel(R) PRO/1000 Network Driver - version 7.2.9-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:14:00.0[A] -> GSI 18 (level, low) -> IRQ 185
PCI: Setting latency timer of device 0000:14:00.0 to 64
e1000: 0000:14:00.0: e1000_probe: (PCI Express:2.5Gb/s:32-bit) 00:0e:0c:e2:e5:78
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:14:00.1[B] -> GSI 19 (level, low) -> IRQ 178
PCI: Setting latency timer of device 0000:14:00.1 to 64
e1000: 0000:14:00.1: e1000_probe: (PCI Express:2.5Gb/s:32-bit) 00:0e:0c:e2:e5:79
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 178
hda: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
intel_rng: FWH not detected
input: PS/2 Generic Mouse as /class/input/input3
sd 0:2:0:0: Attached scsi generic sg0 type 0
floppy0: no floppy controllers found
lp: driver loaded but no devices found
ACPI: Power Button (FF) [PWRF]
ibm_acpi: ec object not found

--------------030409010808040004090800--
