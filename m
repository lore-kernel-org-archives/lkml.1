Return-Path: <linux-kernel-owner+w=401wt.eu-S1760952AbXI1Ojb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbXI1Ojb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbXI1OjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:39:23 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:45423 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753453AbXI1OjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:39:20 -0400
Message-ID: <46FD1200.9020407@idlum.be>
Date: Fri, 28 Sep 2007 16:38:56 +0200
From: Pierre-Yves Paulus <py@idlum.be>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: linux-kernel@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
       BlueZ development <bluez-devel@lists.sourceforge.net>
Subject: Re: Warnings and Oops on 2.6.23-rc6 while activily using rfcomm links
 (mm/slab.c)
References: <46F92364.3080603@idlum.be>	<46F952BD.4010009@redhat.com>	<46FA5E2E.3010300@idlum.be>	<20070927085658.1c66f1c8@gondolin.boeblingen.de.ibm.com>	<46FBC1AE.4020404@idlum.be>	<46FBF17A.6030009@idlum.be> <20070928085438.4eb5a38f@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070928085438.4eb5a38f@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 87.67.141.16 (16.141-67-87.adsl-dyn.isp.belgacom.be)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> This looks suspiciously like someone tried to decrease a refcount on a
> freed kobject. Unfortunately, we only see this after the fact with slub
> debugging turned on :( So could you please turn it off again (but leave
> kobject debugging on) and try with the following silly debug patch:
> 
> ---
>  lib/kobject.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.orig/lib/kobject.c
> +++ linux-2.6/lib/kobject.c
> @@ -502,8 +502,12 @@ static void kobject_release(struct kref 
>   */
>  void kobject_put(struct kobject * kobj)
>  {
> -	if (kobj)
> +	if (kobj) {
> +		if (!atomic_read(&kobj->kref.refcount))
> +			pr_debug("%s: kobject %s@%p already has zero refcount!\n",
> +				 __FUNCTION__, kobj->name, kobj);
>  		kref_put(&kobj->kref, kobject_release);
> +	}
>  }

I applied it, and re-tested without enabling slub debugging this time. I 
got one Oops so far, but it seems it didn't hit your patch's log 
statement. Testing is going on...


Linux version 2.6.23-rc8 (root@debian) (gcc version 4.1.2 20061115 
(prerelease) (Debian 4.1.1-21)) #1 Fri Sep 28 17:12:14 CEST 2007
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000000f7b0000 (usable)
  BIOS-e820: 000000000f7b0000 - 000000000f7b3000 (ACPI NVS)
  BIOS-e820: 000000000f7b3000 - 000000000f7c0000 (ACPI data)
  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
247MB LOWMEM available.
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->    63408
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
     0:        0 ->    63408
DMI 2.2 present.
ACPI: RSDP 000F63C0, 0014 (r0 AMDGX3)
ACPI: RSDT 0F7B3040, 0028 (r1 AMDGX3 AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 0F7B30C0, 0074 (r1 AMDGX3 AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 0F7B3180, 35BD (r1 AMDGX3 AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 0F7B0000, 0040
ACPI: PM-Timer IO Port: 0x9c10
Allocating PCI resources starting at 10000000 (gap: 0f7c0000:f0830000)
swsusp: Registered nosave memory region: 000000000009e000 - 000000000009f000
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
Built 1 zonelists in Zone order.  Total pages: 62913
Kernel command line: root=UUID=c925de24-972b-437c-860f-8109d900aa4b ro 
panic=60 console=ttyS1,38400 console=tty0
No local APIC present or hardware disabled
Initializing CPU#0
PID hash table entries: 1024 (order: 10, 4096 bytes)
Detected 498.060 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS1] enabled
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 243152k/253632k available (1707k kernel code, 9908k reserved, 
679k data, 312k init, 0k highmem)
virtual kernel memory layout:
     fixmap  : 0xfffb3000 - 0xfffff000   ( 304 kB)
     vmalloc : 0xd0000000 - 0xfffb1000   ( 767 MB)
     lowmem  : 0xc0000000 - 0xcf7b0000   ( 247 MB)
       .init : 0xc0358000 - 0xc03a6000   ( 312 kB)
       .data : 0xc02aac35 - 0xc0354aa4   ( 679 kB)
       .text : 0xc0100000 - 0xc02aac35   (1707 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=22, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 997.66 BogoMIPS 
(lpj=1995326)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (32 bytes/line), D cache 64K (32 bytes/line)
CPU: L2 Cache: 128K (32 bytes/line)
Compat vDSO mapped to ffffe000.
CPU: AMD Geode(TM) Integrated Processor by AMD PCS stepping 02
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0c00)
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
EISA bus registered
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfa740, last bus=0
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 11) *0
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 11) *0
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
NET: Registered protocol family 8
NET: Registered protocol family 20
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
pnp: 00:00: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:00: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
checking if image is initramfs...<6>Switched to high resolution mode on 
CPU 0
  it is
Freeing initrd memory: 4718k freed
audit: initializing netlink socket (disabled)
audit(1190989119.245:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0b: ttyS2 at I/O 0x3e8 (irq = 5) is a 16550A
00:0c: ttyS3 at I/O 0x2e8 (irq = 5) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
EISA: Probing bus 0 at eisa.0
Cannot allocate resource for EISA slot 1
Cannot allocate resource for EISA slot 6
EISA: Detected 0 cards.
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
Freeing unused kernel memory: 312k freed
SCSI subsystem initialized
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [LNKC] BIOS reported IRQ 0, using IRQ 11
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKC] -> GSI 11 (level, 
low) -> IRQ 11
eth0: RealTek RTL8139 at 0xf200, 00:04:5f:85:78:91, IRQ 11
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [LNKB] -> GSI 11 (level, 
low) -> IRQ 11
eth1: RealTek RTL8139 at 0xf600, 00:04:5f:85:78:92, IRQ 11
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
usbcore: registered new device driver usb
ACPI: PCI Interrupt Link [LNKD] BIOS reported IRQ 0, using IRQ 10
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI 10 (level, 
low) -> IRQ 10
sata_via 0000:00:0a.0: routed to hard irq line 11
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
scsi0 : sata_via
scsi1 : sata_via
scsi2 : sata_via
ata1: SATA max UDMA/133 cmd 0x0001ff00 ctl 0x0001ff0a bmdma 0x0001fb00 
irq 10
ata2: SATA max UDMA/133 cmd 0x0001fe00 ctl 0x0001fe0a bmdma 0x0001fb08 
irq 10
ata3: PATA max UDMA/133 cmd 0x0001fd00 ctl 0x0001fd0a bmdma 0x0001fb10 
irq 10
ata1: SATA link down (SStatus 0 SControl 310)
ata2: SATA link down (SStatus 0 SControl 310)
ACPI: PCI Interrupt 0000:00:0f.4[D] -> Link [LNKD] -> GSI 10 (level, 
low) -> IRQ 10
ohci_hcd 0000:00:0f.4: OHCI Host Controller
ohci_hcd 0000:00:0f.4: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:0f.4: irq 10, io mem 0xefffd000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
AMD5536: IDE controller at PCI slot 0000:00:0f.2
AMD5536: chipset revision 1
AMD5536: not 100% native mode: will probe irqs later
AMD5536: 0000:00:0f.2 (rev 01) UDMA100 controller
     ide0: BM-DMA at 0xfa00-0xfa07, BIOS settings: hda:DMA, hdb:pio
hda: PQI IDE DiskOnModule, ATA DISK drive
usb 1-1: new full speed USB device using ohci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 7 ports detected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
usb 1-1.4: new full speed USB device using ohci_hcd and address 3
hda: max request size: 128KiB
hda: 4062240 sectors (2079 MB) w/0KiB Cache, CHS=4030/16/63, UDMA(33)
  hda: hda1 hda2 < hda5 hda6 >
usb 1-1.4: configuration #1 chosen from 1 choice
hub 1-1.4:1.0: USB hub found
hub 1-1.4:1.0: 3 ports detected
usb 1-1.5: new full speed USB device using ohci_hcd and address 4
usb 1-1.5: configuration #1 chosen from 1 choice
hub 1-1.5:1.0: USB hub found
hub 1-1.5:1.0: 3 ports detected
ReiserFS: hda6: found reiserfs format "3.6" with standard journal
ReiserFS: hda6: using ordered data mode
ReiserFS: hda6: journal params: device hda6, size 8192, journal first 
block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
ReiserFS: hda6: checking transaction log (hda6)
usb 1-1.2: new full speed USB device using ohci_hcd and address 5
ReiserFS: hda6: Using r5 hash to sort names
usb 1-1.2: configuration #1 chosen from 1 choice
usb 1-1.4.2: new full speed USB device using ohci_hcd and address 6
usb 1-1.4.2: configuration #1 chosen from 1 choice
usb 1-1.4.3: new full speed USB device using ohci_hcd and address 7
usb 1-1.4.3: configuration #1 chosen from 1 choice
usb 1-1.5.2: new full speed USB device using ohci_hcd and address 8
usb 1-1.5.2: configuration #1 chosen from 1 choice
usb 1-1.5.3: new full speed USB device using ohci_hcd and address 9
usb 1-1.5.3: configuration #1 chosen from 1 choice
usb 1-1.4.1: new full speed USB device using ohci_hcd and address 10
usb 1-1.4.1: configuration #1 chosen from 1 choice
usb 1-1.5.1: new full speed USB device using ohci_hcd and address 11
usb 1-1.5.1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: HID 0a5c:4502 as /class/input/input0
input: USB HID v1.11 Keyboard [HID 0a5c:4502] on usb-0000:00:0f.4-1.4.2
input: HID 0a5c:4503 as /class/input/input1
input: USB HID v1.11 Mouse [HID 0a5c:4503] on usb-0000:00:0f.4-1.4.3
input: HID 0a5c:4502 as /class/input/input2
input: USB HID v1.11 Keyboard [HID 0a5c:4502] on usb-0000:00:0f.4-1.5.2
input: HID 0a5c:4503 as /class/input/input3
input: USB HID v1.11 Mouse [HID 0a5c:4503] on usb-0000:00:0f.4-1.5.3
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: HCI USB driver ver 2.9
usbcore: registered new interface driver hci_usb
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:01.2[A] -> Link [LNKA] -> GSI 10 (level, 
low) -> IRQ 10
geode-aes: GEODE AES engine enabled.
AMD Geode RNG detected
ACPI: PCI Interrupt 0000:00:0f.3[B] -> Link [LNKB] -> GSI 11 (level, 
low) -> IRQ 11
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input5
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input6
ACPI: Sleep Button (CM) [SLPB]
ACPI: AC Adapter [AC] (on-line)
input: PC Speaker as /class/input/input7
Real Time Clock Driver v1.12ac
FDC 0 is a post-1991 82077
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
Adding 264560k swap on /dev/hda5.  Priority:-1 extents:1 across:264560k
loop: module loaded
Software Watchdog Timer: 0.07 initialized. soft_noboot=0 soft_margin=60 
sec (nowayout= 0)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: 
dm-devel@redhat.com
eth0: link down
eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
kobject l2cap: registering. parent: <NULL>, set: module
kobject holders: registering. parent: l2cap, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
kobject_uevent_env
fill_kobj_path: path = '/module/l2cap'
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
DEV: registering device: ID = 'acl0060574FEB37'
kobject acl0060574FEB37: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0060574FEB37
bus bluetooth: add device acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0060574FEB37'
DEV: registering device: ID = 'acl00E0033364E5'
kobject acl00E0033364E5: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl00E0033364E5
bus bluetooth: add device acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00E0033364E5'
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
DEV: registering device: ID = 'acl0017B066F14B'
kobject acl0017B066F14B: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0017B066F14B
bus bluetooth: add device acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
hcid[2876]: segfault at 3a46344e eip b7f47fdf esp bfaef4a0 error 4
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
bus bluetooth: remove device acl0060574FEB37
PM: Removing info for bluetooth:acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0060574FEB37'
kobject acl0060574FEB37: cleaning up
bus bluetooth: remove device acl00E0033364E5
PM: Removing info for bluetooth:acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00E0033364E5'
kobject acl00E0033364E5: cleaning up
bus bluetooth: remove device acl0017B066F14B
PM: Removing info for bluetooth:acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
kobject acl0017B066F14B: cleaning up
DEV: registering device: ID = 'acl00126253F906'
kobject acl00126253F906: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00126253F906
bus bluetooth: add device acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
bus bluetooth: remove device acl00126253F906
PM: Removing info for bluetooth:acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
kobject acl00126253F906: cleaning up
kobject rfcomm: registering. parent: <NULL>, set: module
kobject holders: registering. parent: rfcomm, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
kobject_uevent_env
fill_kobj_path: path = '/module/rfcomm'
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
DEV: registering device: ID = 'acl0017B066F14B'
kobject acl0017B066F14B: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0017B066F14B
bus bluetooth: add device acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
bus bluetooth: remove device acl0017B066F14B
PM: Removing info for bluetooth:acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
kobject acl0017B066F14B: cleaning up
DEV: registering device: ID = 'acl0060574FEB37'
kobject acl0060574FEB37: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0060574FEB37
bus bluetooth: add device acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0060574FEB37'
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEV: registering device: ID = 'acl00E0033364E5'
kobject acl00E0033364E5: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl00E0033364E5
bus bluetooth: add device acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00E0033364E5'
bus bluetooth: remove device acl0060574FEB37
PM: Removing info for bluetooth:acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0060574FEB37'
kobject acl0060574FEB37: cleaning up
bus bluetooth: remove device acl00E0033364E5
PM: Removing info for bluetooth:acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00E0033364E5'
kobject acl00E0033364E5: cleaning up
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
DEV: registering device: ID = 'acl0017B066F14B'
kobject acl0017B066F14B: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0017B066F14B
bus bluetooth: add device acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
DEV: registering device: ID = 'acl0060574FEB37'
kobject acl0060574FEB37: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0060574FEB37
bus bluetooth: add device acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0060574FEB37'
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
hcidump[3008]: segfault at 0809d000 eip 08058d98 esp bfd510c0 error 4
DEV: registering device: ID = 'rfcomm0'
kobject rfcomm0: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
DEVICE: moving 'rfcomm0' to 'acl000AD9D7A99A'
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
DEV: registering device: ID = 'acl00126253F906'
kobject acl00126253F906: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00126253F906
bus bluetooth: add device acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
DEV: registering device: ID = 'rfcomm1'
kobject rfcomm1: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm1
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
DEVICE: moving 'rfcomm1' to 'acl0017B066F14B'
fill_kobj_path: path = '/class/tty/rfcomm1'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
DEV: registering device: ID = 'rfcomm2'
kobject rfcomm2: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm2
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
DEVICE: moving 'rfcomm2' to 'acl0060574FEB37'
fill_kobj_path: path = '/class/tty/rfcomm2'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
DEV: registering device: ID = 'rfcomm3'
kobject rfcomm3: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm3
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
DEVICE: moving 'rfcomm3' to 'acl00126253F906'
fill_kobj_path: path = '/class/tty/rfcomm3'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
DEV: registering device: ID = 'acl0016202CBF0B'
kobject acl0016202CBF0B: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl0016202CBF0B
bus bluetooth: add device acl0016202CBF0B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0016202CBF0B'
DEV: registering device: ID = 'rfcomm4'
kobject rfcomm4: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm4
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
DEVICE: moving 'rfcomm4' to 'acl006057BB4D92'
fill_kobj_path: path = '/class/tty/rfcomm4'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
bus bluetooth: remove device acl0016202CBF0B
PM: Removing info for bluetooth:acl0016202CBF0B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0016202CBF0B'
kobject acl0016202CBF0B: cleaning up
DEV: registering device: ID = 'acl00E0033364E5'
kobject acl00E0033364E5: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl00E0033364E5
bus bluetooth: add device acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00E0033364E5'
DEV: registering device: ID = 'rfcomm5'
kobject rfcomm5: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm5
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm5'
DEVICE: moving 'rfcomm5' to 'acl00E0033364E5'
fill_kobj_path: path = '/class/tty/rfcomm5'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm5'
DEV: registering device: ID = 'acl0016202CBF0B'
kobject acl0016202CBF0B: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0016202CBF0B
bus bluetooth: add device acl0016202CBF0B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0016202CBF0B'
bus bluetooth: remove device acl0016202CBF0B
PM: Removing info for bluetooth:acl0016202CBF0B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0016202CBF0B'
kobject acl0016202CBF0B: cleaning up
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEVICE: moving 'rfcomm0' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: Unregistering device. ID = 'rfcomm0'
PM: Removing info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject rfcomm0: cleaning up
device_create_release called for rfcomm0
bus bluetooth: remove device acl0017B066F14B
PM: Removing info for bluetooth:acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
DEVICE: moving 'rfcomm1' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm1'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
kobject acl0017B066F14B: cleaning up
DEV: Unregistering device. ID = 'rfcomm1'
PM: Removing info for No Bus:rfcomm1
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
kobject rfcomm1: cleaning up
device_create_release called for rfcomm1
bus bluetooth: remove device acl00E0033364E5
PM: Removing info for bluetooth:acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00E0033364E5'
DEVICE: moving 'rfcomm5' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm5'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm5'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00E0033364E5'
kobject acl00E0033364E5: cleaning up
DEV: Unregistering device. ID = 'rfcomm5'
PM: Removing info for No Bus:rfcomm5
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm5'
kobject rfcomm5: cleaning up
device_create_release called for rfcomm5
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
bus bluetooth: remove device acl00126253F906
PM: Removing info for bluetooth:acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
bus bluetooth: remove device acl0060574FEB37
PM: Removing info for bluetooth:acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0060574FEB37'
DEVICE: moving 'rfcomm2' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm2'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0060574FEB37'
kobject acl0060574FEB37: cleaning up
DEV: Unregistering device. ID = 'rfcomm2'
PM: Removing info for No Bus:rfcomm2
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
kobject rfcomm2: cleaning up
device_create_release called for rfcomm2
DEVICE: moving 'rfcomm4' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm4'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
DEV: Unregistering device. ID = 'rfcomm4'
PM: Removing info for No Bus:rfcomm4
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
kobject rfcomm4: cleaning up
device_create_release called for rfcomm4
DEVICE: moving 'rfcomm3' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm3'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
kobject acl00126253F906: cleaning up
DEV: Unregistering device. ID = 'rfcomm3'
PM: Removing info for No Bus:rfcomm3
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
kobject rfcomm3: cleaning up
device_create_release called for rfcomm3
DEV: registering device: ID = 'acl0016202CBF0B'
kobject acl0016202CBF0B: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl0016202CBF0B
bus bluetooth: add device acl0016202CBF0B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0016202CBF0B'
bus bluetooth: remove device acl0016202CBF0B
PM: Removing info for bluetooth:acl0016202CBF0B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl0016202CBF0B'
kobject acl0016202CBF0B: cleaning up
DEV: registering device: ID = 'acl0017B066F14B'
kobject acl0017B066F14B: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0017B066F14B
bus bluetooth: add device acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
DEV: registering device: ID = 'acl00126253F906'
kobject acl00126253F906: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl00126253F906
bus bluetooth: add device acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00126253F906'
DEV: registering device: ID = 'acl0060574FEB37'
kobject acl0060574FEB37: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0060574FEB37
bus bluetooth: add device acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0060574FEB37'
DEV: registering device: ID = 'acl00E0033364E5'
kobject acl00E0033364E5: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00E0033364E5
bus bluetooth: add device acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00E0033364E5'
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl000AD9D7A99A'
bus bluetooth: remove device acl0017B066F14B
PM: Removing info for bluetooth:acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
kobject acl0017B066F14B: cleaning up
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
bus bluetooth: remove device acl00E0033364E5
PM: Removing info for bluetooth:acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00E0033364E5'
kobject acl00E0033364E5: cleaning up
bus bluetooth: remove device acl00126253F906
PM: Removing info for bluetooth:acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00126253F906'
kobject acl00126253F906: cleaning up
bus bluetooth: remove device acl0060574FEB37
PM: Removing info for bluetooth:acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0060574FEB37'
kobject acl0060574FEB37: cleaning up
bus bluetooth: remove device acl006057BB4D92
PM: Removing info for bluetooth:acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
kobject acl006057BB4D92: cleaning up
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEV: registering device: ID = 'acl0060574FEB37'
kobject acl0060574FEB37: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0060574FEB37
bus bluetooth: add device acl0060574FEB37
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0060574FEB37'
DEV: registering device: ID = 'acl00E0033364E5'
kobject acl00E0033364E5: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00E0033364E5
bus bluetooth: add device acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00E0033364E5'
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEV: registering device: ID = 'acl006057BB4D92'
kobject acl006057BB4D92: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl006057BB4D92
bus bluetooth: add device acl006057BB4D92
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl006057BB4D92'
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl0017B066F14B'
kobject acl0017B066F14B: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl0017B066F14B
bus bluetooth: add device acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
DEV: registering device: ID = 'acl00126253F906'
kobject acl00126253F906: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl00126253F906
bus bluetooth: add device acl00126253F906
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl00126253F906'
DEV: registering device: ID = 'rfcomm0'
kobject rfcomm0: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm0
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
DEVICE: moving 'rfcomm0' to 'acl006057BB4D92'
fill_kobj_path: path = '/class/tty/rfcomm0'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm0'
DEV: registering device: ID = 'rfcomm1'
kobject rfcomm1: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm1
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
DEVICE: moving 'rfcomm1' to 'acl0017B066F14B'
fill_kobj_path: path = '/class/tty/rfcomm1'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
DEV: registering device: ID = 'rfcomm2'
kobject rfcomm2: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm2
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
DEVICE: moving 'rfcomm2' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm2'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
bus bluetooth: remove device acl00E0033364E5
PM: Removing info for bluetooth:acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00E0033364E5'
kobject acl00E0033364E5: cleaning up
DEVICE: moving 'rfcomm2' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm2'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
DEV: Unregistering device. ID = 'rfcomm2'
PM: Removing info for No Bus:rfcomm2
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
kobject rfcomm2: cleaning up
device_create_release called for rfcomm2
DEV: registering device: ID = 'rfcomm2'
kobject rfcomm2: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm2
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
DEVICE: moving 'rfcomm2' to 'acl0060574FEB37'
fill_kobj_path: path = '/class/tty/rfcomm2'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm2'
DEV: registering device: ID = 'acl00E0033364E5'
kobject acl00E0033364E5: registering. parent: hci2, set: devices
PM: Adding info for bluetooth:acl00E0033364E5
bus bluetooth: add device acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00E0033364E5'
hcidump[4634]: segfault at 080ab0a7 eip 0805f3c7 esp bfd11d00 error 4
DEV: registering device: ID = 'rfcomm3'
kobject rfcomm3: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm3
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
DEVICE: moving 'rfcomm3' to 'acl00E0033364E5'
fill_kobj_path: path = '/class/tty/rfcomm3'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEV: registering device: ID = 'rfcomm4'
kobject rfcomm4: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm4
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
DEVICE: moving 'rfcomm4' to 'acl00126253F906'
fill_kobj_path: path = '/class/tty/rfcomm4'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm4'
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEV: registering device: ID = 'rfcomm5'
kobject rfcomm5: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm5
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm5'
DEVICE: moving 'rfcomm5' to 'acl000AD9D7A99A'
fill_kobj_path: path = '/class/tty/rfcomm5'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm5'
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
DEVICE: moving 'rfcomm5' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm5'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm5'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
DEV: Unregistering device. ID = 'rfcomm5'
PM: Removing info for No Bus:rfcomm5
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm5'
kobject rfcomm5: cleaning up
device_create_release called for rfcomm5
bus bluetooth: remove device acl0017B066F14B
PM: Removing info for bluetooth:acl0017B066F14B
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
DEVICE: moving 'rfcomm1' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm1'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl0017B066F14B'
kobject acl0017B066F14B: cleaning up
DEV: Unregistering device. ID = 'rfcomm1'
PM: Removing info for No Bus:rfcomm1
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
kobject rfcomm1: cleaning up
device_create_release called for rfcomm1
DEV: registering device: ID = 'acl000AD9D7A99A'
kobject acl000AD9D7A99A: registering. parent: hci1, set: devices
PM: Adding info for bluetooth:acl000AD9D7A99A
bus bluetooth: add device acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
bus bluetooth: remove device acl00E0033364E5
PM: Removing info for bluetooth:acl00E0033364E5
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00E0033364E5'
DEVICE: moving 'rfcomm3' to '<NULL>'
fill_kobj_path: path = '/class/tty/rfcomm3'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00E0033364E5'
kobject acl00E0033364E5: cleaning up
DEV: Unregistering device. ID = 'rfcomm3'
PM: Removing info for No Bus:rfcomm3
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm3'
kobject rfcomm3: cleaning up
device_create_release called for rfcomm3
DEV: registering device: ID = 'rfcomm1'
kobject rfcomm1: registering. parent: tty, set: devices
PM: Adding info for No Bus:rfcomm1
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
DEVICE: moving 'rfcomm1' to 'acl000AD9D7A99A'
fill_kobj_path: path = '/class/tty/rfcomm1'
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
DEV: Unregistering device. ID = 'rfcomm1'
PM: Removing info for No Bus:rfcomm1
kobject_uevent_env
fill_kobj_path: path = '/class/tty/rfcomm1'
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject rfcomm1: cleaning up
device_create_release called for rfcomm1
bus bluetooth: remove device acl000AD9D7A99A
PM: Removing info for bluetooth:acl000AD9D7A99A
kobject_uevent_env
fill_kobj_path: path = 
'/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.4/1-1.4.1/1-1.4.1:1.0/hci1/acl000AD9D7A99A'
kobject acl000AD9D7A99A: cleaning up
WARNING: at lib/kref.c:33 kref_get()
  [<c01c6db7>] kref_get+0x34/0x3d
  [<c01c61a9>] kobject_get+0xf/0x13
  [<c022578d>] get_device+0xe/0x14
  [<c02257a6>] device_move+0x13/0x114
  [<d02fcb7c>] rfcomm_tty_close+0x23/0x61 [rfcomm]
  [<c020f88d>] release_dev+0x1c0/0x54e
  [<d004f49b>] finish_urb+0x79/0x9d [ohci_hcd]
  [<d004f5f4>] dl_done_list+0x135/0x1aa [ohci_hcd]
  [<c020fc22>] tty_release+0x7/0xa
  [<c015dabd>] __fput+0x93/0x147
  [<c015b66a>] filp_close+0x51/0x58
  [<c015c70b>] sys_close+0x54/0x83
  [<c0103c72>] syscall_call+0x7/0xb
  =======================
DEVICE: moving 'rfcomm1' to '<NULL>'
kobject <NULL>: cleaning up
device_create_release called for rfcomm1
BUG: unable to handle kernel paging request at virtual address 533e343c
  printing eip:
c015aa43
*pde = 00000000
Oops: 0000 [#1]
Modules linked in: rfcomm l2cap battery ipv6 dm_snapshot dm_mirror 
dm_mod softdog loop tsdev evdev parport_pc parport psmouse serio_raw 
floppy rtc pcspkr ac button snd_cs5535audio snd_ac97_codec ac97_bus 
snd_pcm snd_timer snd soundcore snd_page_alloc geode_rng cs5535_gpio 
geode_aes blkcipher hci_usb bluetooth usbhid hid reiserfs ide_disk 
generic amd74xx ide_core ohci_hcd sata_via ata_generic 8139cp libata 
8139too usbcore mii scsi_mod thermal processor fan
CPU:    0
EIP:    0060:[<c015aa43>]    Not tainted VLI
EFLAGS: 00010006   (2.6.23-rc8 #1)
EIP is at __kmalloc_track_caller+0x61/0xa9
eax: 00000000   ebx: 533e343c   ecx: c0351f6c   edx: c111f2e0
esi: c0351f6c   edi: 00000286   ebp: 000004d0   esp: cd76bdb8
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process klogd (pid: 2437, ti=cd76a000 task=c127fa40 task.ti=cd76a000)
Stack: 00000092 00000000 c744c000 00000080 c744c000 c0351b98 c024b6b2 
00000000
        000004d0 cf4a71a0 000004d0 cd1942c0 7fffffff c0248391 ffffffff 
0000003d
        c029d743 00000001 c127fa40 c012a510 cd76be08 cf4a7340 cd76be40 
cd1942c0
Call Trace:
  [<c024b6b2>] __alloc_skb+0x57/0x101
  [<c0248391>] sock_alloc_send_skb+0x6e/0x18e
  [<c029d743>] unix_wait_for_peer+0x75/0x7e
  [<c012a510>] autoremove_wake_function+0x0/0x35
  [<c029d9d6>] unix_dgram_sendmsg+0x162/0x3fc
  [<c0144990>] filemap_fault+0x1e3/0x331
  [<c0245c12>] sock_aio_write+0xf6/0x102
  [<c015cb4e>] do_sync_write+0xc6/0x109
  [<c012a510>] autoremove_wake_function+0x0/0x35
  [<c0115c4a>] do_page_fault+0x2bf/0x631
  [<c015d365>] vfs_write+0xbc/0x12f
  [<c015d80c>] sys_write+0x41/0x67
  [<c0103c72>] syscall_call+0x7/0xb
  [<c02a0000>] __inet6_check_established+0x242/0x353
  =======================
Code: 00 00 00 85 d2 74 06 83 7a 0c 00 75 17 89 54 24 04 83 c9 ff 89 ea 
89 f0 89 1c 24 e8 fe f1 ff ff 89 c3 eb 0d 8b 5a 0c 0f b7 42 0a <8b> 04 
83 89 42 0c 89 f8 50 9d 90 8d b4 26 00 00 00 00 89 e8 25
EIP: [<c015aa43>] __kmalloc_track_caller+0x61/0xa9 SS:ESP 0068:cd76bdb8
BUG: unable to handle kernel paging request at virtual address 533e343c
  printing eip:
c015aa43
*pde = 00000000
Oops: 0000 [#2]
Modules linked in: rfcomm l2cap battery ipv6 dm_snapshot dm_mirror 
dm_mod softdog loop tsdev evdev parport_pc parport psmouse serio_raw 
floppy rtc pcspkr ac button snd_cs5535audio snd_ac97_codec ac97_bus 
snd_pcm snd_timer snd soundcore snd_page_alloc geode_rng cs5535_gpio 
geode_aes blkcipher hci_usb bluetooth usbhid hid reiserfs ide_disk 
generic amd74xx ide_core ohci_hcd sata_via ata_generic 8139cp libata 
8139too usbcore mii scsi_mod thermal processor fan
CPU:    0
EIP:    0060:[<c015aa43>]    Tainted: G      D VLI
EFLAGS: 00010006   (2.6.23-rc8 #1)
EIP is at __kmalloc_track_caller+0x61/0xa9
eax: 00000000   ebx: 533e343c   ecx: c0351f6c   edx: c111f2e0
esi: c0351f6c   edi: 00000286   ebp: 00000020   esp: cd76ba98
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Process klogd (pid: 2437, ti=cd76a000 task=c127fa40 task.ti=cd76a000)
Stack: c024b68d c10e8980 c1235900 00000080 c1235900 c0351b98 c024b6b2 
00000000
        00000020 00000000 00000011 cb3ea994 cb3ea980 d011e870 ffffffff 
00000064
        c0223cfe c43740b0 00000004 cecea400 00000002 00000039 00000010 
cecea400
Call Trace:
  [<c024b68d>] __alloc_skb+0x32/0x101
  [<c024b6b2>] __alloc_skb+0x57/0x101
  [<d011e870>] hci_recv_fragment+0xb9/0x210 [bluetooth]
  [<c0223cfe>] serial8250_console_putchar+0x0/0x92
  [<d010d78f>] hci_usb_rx_complete+0xaa/0x105 [hci_usb]
  [<d008671c>] usb_hcd_giveback_urb+0x2d/0x5b [usbcore]
  [<d004f49b>] finish_urb+0x79/0x9d [ohci_hcd]
  [<d004f5f4>] dl_done_list+0x135/0x1aa [ohci_hcd]
  [<d004f49b>] finish_urb+0x79/0x9d [ohci_hcd]
  [<d005165a>] ohci_irq+0x164/0x1d3 [ohci_hcd]
  [<d008693e>] usb_hcd_irq+0x21/0x4d [usbcore]
  [<c013ffdf>] handle_IRQ_event+0x23/0x51
  [<c0141213>] handle_level_irq+0x4f/0x84
  [<c010663a>] do_IRQ+0x53/0x6d
  [<c0104c43>] common_interrupt+0x23/0x30
  [<c014c657>] unmap_vmas+0x172/0x4a8
  [<c011fc55>] irq_exit+0x40/0x58
  [<c014f104>] exit_mmap+0x65/0xcf
  [<c011a350>] mmput+0x1b/0x5e
  [<c011e478>] do_exit+0x1c6/0x65d
  [<c021a439>] do_unblank_screen+0xd/0x102
  [<c0105664>] die+0x1ce/0x1d6
  [<c0115ed6>] do_page_fault+0x54b/0x631
  [<c011598b>] do_page_fault+0x0/0x631
  [<c02a9f3a>] error_code+0x6a/0x70
  [<c015aa43>] __kmalloc_track_caller+0x61/0xa9
  [<c024b6b2>] __alloc_skb+0x57/0x101
  [<c0248391>] sock_alloc_send_skb+0x6e/0x18e
  [<c029d743>] unix_wait_for_peer+0x75/0x7e
  [<c012a510>] autoremove_wake_function+0x0/0x35
  [<c029d9d6>] unix_dgram_sendmsg+0x162/0x3fc
  [<c0144990>] filemap_fault+0x1e3/0x331
  [<c0245c12>] sock_aio_write+0xf6/0x102
  [<c015cb4e>] do_sync_write+0xc6/0x109
  [<c012a510>] autoremove_wake_function+0x0/0x35
  [<c0115c4a>] do_page_fault+0x2bf/0x631
  [<c015d365>] vfs_write+0xbc/0x12f
  [<c015d80c>] sys_write+0x41/0x67
  [<c0103c72>] syscall_call+0x7/0xb
  [<c02a0000>] __inet6_check_established+0x242/0x353
  =======================
Code: 00 00 00 85 d2 74 06 83 7a 0c 00 75 17 89 54 24 04 83 c9 ff 89 ea 
89 f0 89 1c 24 e8 fe f1 ff ff 89 c3 eb 0d 8b 5a 0c 0f b7 42 0a <8b> 04 
83 89 42 0c 89 f8 50 9d 90 8d b4 26 00 00 00 00 89 e8 25
EIP: [<c015aa43>] __kmalloc_track_caller+0x61/0xa9 SS:ESP 0068:cd76ba98
Kernel panic - not syncing: Fatal exception in interrupt
Rebooting in 60 seconds..


