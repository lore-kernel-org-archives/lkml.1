Return-Path: <linux-kernel-owner+w=401wt.eu-S932779AbXHFNvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779AbXHFNvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbXHFNv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:51:28 -0400
Received: from mail.suse.de ([195.135.220.2]:37358 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbXHFNv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:51:26 -0400
Date: Mon, 6 Aug 2007 15:51:24 +0200
From: Olaf Hering <olh@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Robert Hancock <hancockr@shaw.ca>, linuxppc-dev@ozlabs.org,
       stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.22.y] ieee1394: revert "sbp2: enforce 32bit DMA	mapping"
Message-ID: <20070806135124.GA2900@suse.de>
References: <fa.Qn3Snqoik3hhnxcA6HqjGV0Yzck@ifi.uio.no> <46B4B3DC.7020609@shaw.ca> <46B4B7C6.1040107@s5r6.in-berlin.de> <1186272926.938.8.camel@localhost.localdomain> <46B5824B.1000103@s5r6.in-berlin.de> <1186351473.938.21.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1186351473.938.21.camel@localhost.localdomain>
X-DOS: I got your 640K Real Mode Right Here Buddy!
X-Homeland-Security: You are not supposed to read this line! You are a terrorist!
User-Agent: Mutt und vi sind doch schneller als Notes (und GroupWise)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, Benjamin Herrenschmidt wrote:

> BTW. Any reason why you don't set the DMA mask in the ohci driver rather
> than the sbp2 one ?

I used this patch, and the attached CD was found.
What dma mask should be used in ohci_probe()?


---
 drivers/ieee1394/ohci1394.c       |    2 ++
 drivers/ieee1394/sbp2.c           |    3 +++
 drivers/pci/pci.c                 |    1 +
 drivers/pci/probe.c               |    1 +
 include/asm-powerpc/dma-mapping.h |    1 +
 5 files changed, 8 insertions(+)

--- a/drivers/ieee1394/ohci1394.c
+++ b/drivers/ieee1394/ohci1394.c
@@ -3223,6 +3223,8 @@ static int __devinit ohci1394_pci_probe(
 	}
 #endif /* CONFIG_PPC_PMAC */
 
+	if (pci_set_dma_mask(dev, DMA_32BIT_MASK))
+		FAIL(-ENXIO, "Failed to set DMA mask");
         if (pci_enable_device(dev))
 		FAIL(-ENXIO, "Failed to enable OHCI hardware");
         pci_set_master(dev);
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -775,12 +775,15 @@ static struct sbp2_lu *sbp2_alloc_device
 			goto failed_alloc;
 		}
 #else
+		printk(KERN_DEBUG "%s():%u dev '%s' %p parent '%s' %p %016lx\n",__func__,__LINE__,hi->host->device.bus_id,hi->host->device.dma_mask,hi->host->device.parent->bus_id,(hi->host->device.parent->dma_mask),*(hi->host->device.parent->dma_mask));
 		if (dma_set_mask(hi->host->device.parent, DMA_32BIT_MASK)) {
 			SBP2_ERR("failed to set 4GB DMA mask");
 			goto failed_alloc;
 		}
 #endif
 	}
+	else
+		printk(KERN_DEBUG "%s():%u dev '%s' parent '%s'\n",__func__,__LINE__,hi->host->device.bus_id,hi->host->device.parent->bus_id);
 
 	/* Prevent unloading of the 1394 host */
 	if (!try_module_get(hi->host->driver->owner)) {
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1358,6 +1358,7 @@ pci_set_dma_mask(struct pci_dev *dev, u6
 		return -EIO;
 
 	dev->dma_mask = mask;
+	printk(KERN_DEBUG "%s() '%s' %p %016lx\n",__func__,dev->dev.bus_id,dev->dev.dma_mask,*(dev->dev.dma_mask));
 
 	return 0;
 }
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -937,6 +937,7 @@ void pci_device_add(struct pci_dev *dev,
 
 	set_dev_node(&dev->dev, pcibus_to_node(bus));
 	dev->dev.dma_mask = &dev->dma_mask;
+	printk(KERN_DEBUG "%s() '%s' %p %016lx\n",__func__,dev->dev.bus_id,dev->dev.dma_mask,*(dev->dev.dma_mask));
 	dev->dev.coherent_dma_mask = 0xffffffffull;
 
 	/* Fix up broken headers */
--- a/include/asm-powerpc/dma-mapping.h
+++ b/include/asm-powerpc/dma-mapping.h
@@ -92,6 +92,7 @@ static inline int dma_set_mask(struct de
 {
 	struct dma_mapping_ops *dma_ops = get_dma_ops(dev);
 
+	printk(KERN_DEBUG "%s() '%s' %016llx %p\n",__func__,dev->bus_id,(unsigned long long)dma_mask,dma_ops);
 	if (unlikely(dma_ops == NULL))
 		return -EIO;
 	if (dma_ops->set_dma_mask != NULL)

Using PowerMac machine description
Page orders: linear mapping = 24, virtual = 12, io = 12
Found initrd at 0xc000000001500000:0xc000000001763000
Found U3 memory controller & host bridge @ 0xf8000000 revision: 0x32
Mapped at 0xd000080080000000
Found a K2 mac-io controller, rev: 32, mapped at 0xd000080080041000
PowerMac motherboard: PowerMac G5
DART: table not allocated, using direct DMA
Starting Linux PPC64 #4 SMP Mon Aug 6 15:40:01 CEST 2007
-----------------------------------------------------
ppc64_pft_size                = 0x0
physicalMemorySize            = 0x10000000
ppc64_caches.dcache_line_size = 0x80
ppc64_caches.icache_line_size = 0x80
htab_address                  = 0xc00000000f800000
htab_hash_mask                = 0x7fff
-----------------------------------------------------
Linux version 2.6.22.1-ppc64 (geeko@buildhost) (gcc version 4.1.2 20070115 (prerelease) (SUSE Linux)) #4 SMP Mon Aug 6 15:40:01 CEST 2007
[boot]0012 Setup Arch
Top of RAM: 0x10000000, Total RAM: 0x10000000
Memory hole size: 0MB
Entering add_active_range(0, 0, 65536) 0 entries of 256 used
Found U3-AGP PCI host bridge.  Firmware bus number: 240->255
Can't get bus-range for /ht@0,f2000000, assume bus 0
Found U3-HT PCI host bridge.  Firmware bus number: 0->239
PCI Host 0, io start: 400000; io end: bfffff
PCI Host 1, io start: 0; io end: 3fffff
via-pmu: Server Mode is disabled
PMU driver v2 initialized for Core99, firmware: 0c
nvram: Checking bank 0...
nvram: gen0=493, gen1=492
nvram: Active bank is: 0
nvram: OF partition at 0x410
nvram: XP partition at 0x1020
nvram: NR partition at 0x1120
Zone PFN ranges:
  DMA             0 ->    65536
  Normal      65536 ->    65536
early_node_map[1] active PFN ranges
    0:        0 ->    65536
On node 0 totalpages: 65536
  DMA zone: 896 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 64640 pages, LIFO batch:15
  Normal zone: 0 pages used for memmap
[boot]0015 Setup Done
Built 1 zonelists.  Total pages: 64640
Kernel command line: 
mpic: Setting up MPIC " MPIC 1   " version 1.2 at 80040000, max 4 CPUs
mpic: ISU size: 120, shift: 7, mask: 7f
mpic: Initializing for 120 sources
mpic: Setting up MPIC " MPIC 2   " version 1.2 at f8040000, max 4 CPUs
mpic: ISU size: 120, shift: 7, mask: 7f
mpic: Initializing for 120 sources
PID hash table entries: 1024 (order: 10, 8192 bytes)
time_init: decrementer frequency = 33.333333 MHz
time_init: processor frequency   = 1600.000000 MHz
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [tty0]
Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
freeing bootmem node 0
Memory: 242692k/262144k available (5920k kernel code, 19452k reserved, 1384k data, 1103k bss, 292k init)
Calibrating delay loop... 66.56 BogoMIPS (lpj=332800)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 256
PowerMac SMP probe found 1 cpus
Brought up 1 CPUs
NET: Registered protocol family 16
KeyWest i2c @0xf8001003 irq 42 /u3@0,f8000000/i2c@f8001000
 channel 0 bus <multibus>
 channel 1 bus <multibus>
KeyWest i2c @0x80018000 irq 26 /ht@0,f2000000/pci@3/mac-io@7/i2c@18000
 channel 0 bus <multibus>
PMU i2c /ht@0,f2000000/pci@3/mac-io@7/via-pmu@16000/pmu-i2c
 channel 1 bus <multibus>
 channel 2 bus <multibus>
CPU Hotplug not supported by firmware - disabling.
PCI: Probing PCI hardware
pci_device_add() '0000:f0:0b.0' c000000001978860 00000000ffffffff
pci_device_add() '0000:f0:10.0' c00000000ff41860 00000000ffffffff
pci_device_add() '0001:00:01.0' c00000000ff41060 0000000000000000
pci_device_add() '0001:06:03.0' c00000000ff47860 0000000000000000
pci_device_add() '0001:00:02.0' c00000000ff47060 0000000000000000
Can't get ranges for PCI-PCI bridge /ht@0,f2000000/pci@2
pci_device_add() '0001:00:03.0' c00000000ff48860 0000000000000000
pci_device_add() '0001:01:07.0' c00000000ff48060 0000000000000000
pci_device_add() '0001:01:08.0' c00000000ff4b860 0000000000000000
pci_device_add() '0001:01:09.0' c00000000ff4b060 0000000000000000
pci_device_add() '0001:00:04.0' c00000000ff6c860 0000000000000000
pci_device_add() '0001:02:0b.0' c00000000ff6c060 0000000000000000
pci_device_add() '0001:02:0b.1' c00000000ff6d860 0000000000000000
pci_device_add() '0001:02:0b.2' c00000000ff6d060 0000000000000000
pci_device_add() '0001:00:05.0' c00000000ff6e860 0000000000000000
pci_device_add() '0001:03:0d.0' c00000000ff6e060 0000000000000000
pci_device_add() '0001:03:0e.0' c00000000ff71860 0000000000000000
pci_device_add() '0001:00:06.0' c00000000ff71060 0000000000000000
pci_device_add() '0001:04:0f.0' c00000000ff72860 0000000000000000
pci_device_add() '0001:00:07.0' c00000000ff72060 0000000000000000
pci_device_add() '0001:05:0c.0' c00000000ff73860 0000000000000000
mapping IO f0000000 -> d000080000400000, size: 800000
mapping IO f4000000 -> d000080000000000, size: 400000
PCI: Probing PCI hardware done
Registering pmac pic with sysfs...
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 2, 16384 bytes)
TCP established hash table entries: 8192 (order: 5, 196608 bytes)
TCP bind hash table entries: 8192 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
Unpacking initramfs... done
Freeing initrd memory: 2444k freed
nvram_init: Could not find nvram partition for nvram buffered error logging.
rtas_flash: no firmware flash support
IBM eBus Device Driver
Registering G5 CPU frequency driver
Frequency method: i2c/pfunc, Voltage method: i2c/pfunc
Low: 1301 Mhz, High: 1600 Mhz, Cur: 1600 MHz
audit: initializing netlink socket (disabled)
audit(1186407931.610:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
rpadlpar_io_init: partition not DLPAR capable
nvidiafb: Device ID: 10de0321 
nvidiafb: CRTC0 analog not found
nvidiafb: CRTC1 analog found
nvidiafb: EDID found from BUS1
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
nvidiafb: Found OF EDID for head 2
nvidiafb: EDID found from BUS2
nvidiafb: CRTC 1appears to have a CRT attached
nvidiafb: Using CRT on CRTC 1
Trying to im_free nonexistent area (d0000800800c1000)
Console: switching to colour frame buffer device 160x64
nvidiafb: PCI nVidia NV32 framebuffer (64MB @ 0xA8000000)
vio_register_driver: driver hvc_console registering
HVSI: registered 0 devices
Generic RTC Driver v1.07
pmac_zilog: 0.6 (Benjamin Herrenschmidt <benh@kernel.crashing.org>)
ttyS0 at MMIO 0x80013020 (irq = 22) is a Z85c30 ESCC - Serial port
ttyS1 at MMIO 0x80013000 (irq = 23) is a Z85c30 ESCC - Serial port
MacIO PCI driver attached to K2 chipset
input: Macintosh mouse button emulation as /class/input/input0
PowerMac G5 Thermal control driver 1.3
adb: starting probe task...
adb: finished probe task...
Detected fan controls:
  0: PWM fan, id 1, location: BACKSIDE,SYS CTRLR FAN
  1: RPM fan, id 2, location: DRIVE BAY
  2: PWM fan, id 2, location: SLOT,PCI FAN
  3: RPM fan, id 3, location: CPU A INTAKE
  4: RPM fan, id 4, location: CPU A EXHAUST
  5: RPM fan, id 5, location: CPU B INTAKE
  6: RPM fan, id 6, location: CPU B EXHAUST
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PCI: Enabling device: (0001:03:0d.0), cmd 16
ide0: Found Apple K2 ATA-6 controller, bus ID 3, irq 39
Probing IDE interface ide0...
hda: PIONEER DVD-RW DVR-106D, ATAPI CD/DVD-ROM drive
hda: Enabling Ultra DMA 2
ide0 at 0xd00008008729a000-0xd00008008729a007,0xd00008008729a160 on irq 39
PCI: Enabling device: (0001:02:0b.2), cmd 6
ehci_hcd 0001:02:0b.2: EHCI Host Controller
ehci_hcd 0001:02:0b.2: new USB bus registered, assigned bus number 1
ehci_hcd 0001:02:0b.2: irq 63, io mem 0x80100000
ehci_hcd 0001:02:0b.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: new device found, idVendor=0000, idProduct=0000
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.22.1-ppc64 ehci_hcd
usb usb1: SerialNumber: 0001:02:0b.2
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
PCI: Enabling device: (0001:01:08.0), cmd 2
ohci_hcd 0001:01:08.0: OHCI Host Controller
ohci_hcd 0001:01:08.0: new USB bus registered, assigned bus number 2
ohci_hcd 0001:01:08.0: irq 27, io mem 0x80081000
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.22.1-ppc64 ohci_hcd
usb usb2: SerialNumber: 0001:01:08.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
PCI: Enabling device: (0001:01:09.0), cmd 2
ohci_hcd 0001:01:09.0: OHCI Host Controller
ohci_hcd 0001:01:09.0: new USB bus registered, assigned bus number 3
ohci_hcd 0001:01:09.0: irq 28, io mem 0x80080000
usb usb3: new device found, idVendor=0000, idProduct=0000
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.22.1-ppc64 ohci_hcd
usb usb3: SerialNumber: 0001:01:09.0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
PCI: Enabling device: (0001:02:0b.0), cmd 2
ohci_hcd 0001:02:0b.0: OHCI Host Controller
ohci_hcd 0001:02:0b.0: new USB bus registered, assigned bus number 4
ohci_hcd 0001:02:0b.0: irq 63, io mem 0x80102000
usb usb4: new device found, idVendor=0000, idProduct=0000
usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: OHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.22.1-ppc64 ohci_hcd
usb usb4: SerialNumber: 0001:02:0b.0
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 3 ports detected
PCI: Enabling device: (0001:02:0b.1), cmd 2
ohci_hcd 0001:02:0b.1: OHCI Host Controller
ohci_hcd 0001:02:0b.1: new USB bus registered, assigned bus number 5
ohci_hcd 0001:02:0b.1: irq 63, io mem 0x80101000
usb usb5: new device found, idVendor=0000, idProduct=0000
usb usb5: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: OHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.22.1-ppc64 ohci_hcd
usb usb5: SerialNumber: 0001:02:0b.1
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
mice: PS/2 mouse device common for all mice
PowerMac i2c bus pmu 2 registered
PowerMac i2c bus pmu 1 registered
PowerMac i2c bus mac-io 0 registered
PowerMac i2c bus u3 1 registered
PowerMac i2c bus u3 0 registered
FCU Initialized, RPM fan shift is 3
usb 5-2: new full speed USB device using ohci_hcd and address 2
usb 5-2: new device found, idVendor=05ac, idProduct=1003
usb 5-2: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: Hub in Apple Extended USB Keyboard
usb 5-2: Manufacturer: Mitsumi Electric
usb 5-2: configuration #1 chosen from 1 choice
hub 5-2:1.0: USB hub found
hub 5-2:1.0: 3 ports detected
usb 5-2.1: new low speed USB device using ohci_hcd and address 3
usb 5-2.1: new device found, idVendor=05ac, idProduct=0307
usb 5-2.1: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2.1: Product: Apple Optical USB Mouse
usb 5-2.1: Manufacturer: Logitech
usb 5-2.1: configuration #1 chosen from 1 choice
usb 5-2.3: new full speed USB device using ohci_hcd and address 4
usb 5-2.3: new device found, idVendor=05ac, idProduct=020c
usb 5-2.3: new device strings: Mfr=1, Product=3, SerialNumber=0
usb 5-2.3: Product: Apple Extended USB Keyboard
usb 5-2.3: Manufacturer: Mitsumi Electric
usb 5-2.3: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Logitech Apple Optical USB Mouse as /class/input/input1
input: USB HID v1.10 Mouse [Logitech Apple Optical USB Mouse] on usb-0001:02:0b.1-2.1
input: Mitsumi Electric Apple Extended USB Keyboard as /class/input/input2
input: USB HID v1.10 Keyboard [Mitsumi Electric Apple Extended USB Keyboard] on usb-0001:02:0b.1-2.3
input: Mitsumi Electric Apple Extended USB Keyboard as /class/input/input3
input: USB HID v1.10 Device [Mitsumi Electric Apple Extended USB Keyboard] on usb-0001:02:0b.1-2.3
usbcore: registered new interface driver usbhid
/dev/shm/R/linux-2.6.22/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
oprofile: using ppc64/970 performance monitoring.
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
input: PMU as /class/input/input4
Registered led device: pmu-front-led
Freeing unused kernel memory: 292k freed
SCSI subsystem initialized
libata version 3.00 loaded.
sata_svw 0001:05:0c.0: version 2.2
pci_set_dma_mask() '0001:05:0c.0' c00000000ff73860 00000000ffffffff
scsi0 : sata_svw
scsi1 : sata_svw
scsi2 : sata_svw
scsi3 : sata_svw
ata1: SATA max UDMA/133 cmd 0xd0000800872a1000 ctl 0xd0000800872a1020 bmdma 0xd0000800872a1030 irq 16
ata2: SATA max UDMA/133 cmd 0xd0000800872a1100 ctl 0xd0000800872a1120 bmdma 0xd0000800872a1130 irq 16
ata3: SATA max UDMA/133 cmd 0xd0000800872a1200 ctl 0xd0000800872a1220 bmdma 0xd0000800872a1230 irq 16
ata4: SATA max UDMA/133 cmd 0xd0000800872a1300 ctl 0xd0000800872a1320 bmdma 0xd0000800872a1330 irq 16
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-6: ST380013AS, 3.05, max UDMA/133
ata1.00: 156301488 sectors, multi 0: LBA48 
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7: Maxtor 6Y080M0, YAR511W0, max UDMA/133
ata2.00: 156312576 sectors, multi 0: LBA 
ata2.00: configured for UDMA/133
ata3: SATA link down (SStatus 4 SControl 300)
ata4: SATA link down (SStatus 4 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST380013AS       3.05 PQ: 0 ANSI: 5
scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6Y080M0   YAR5 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: [mac] sda1 sda2 sda3 sda4 sda5 sda6 sda7 sda8
sd 0:0:0:0: [sda] Attached SCSI disk
sd 1:0:0:0: [sdb] 156312576 512-byte hardware sectors (80032 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 156312576 512-byte hardware sectors (80032 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: [mac] sdb1 sdb2 sdb3 sdb4 sdb5 sdb6 sdb7 sdb8
sd 1:0:0:0: [sdb] Attached SCSI disk
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected Apple U3 chipset
agpgart: configuring for size idx: 8
agpgart: AGP aperture is 32M @ 0x0
tg3.c:v3.77 (May 31, 2007)
PCI: Enabling device: (0001:06:03.0), cmd 6
hda: ATAPI 32X DVD-ROM DVD-R CD-R/RW drive, 2000kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
snd-aoa-fabric-layout: found bus with layout 36
snd-aoa-fabric-layout: Using PMF GPIOs
snd-aoa-codec-tas: found 'deq' node
snd-aoa-fabric-layout: can use this codec
snd-aoa-codec-tas: tas found, addr 0x35 on /ht@0,f2000000/pci@3/mac-io@7/i2c@18000/deq@6a
pci_set_dma_mask() '0001:06:03.0' c00000000ff47860 ffffffffffffffff
eth0: Tigon3 [partno(3C996B-T) rev 0105 PHY(5701)] (PCI:33MHz:64-bit) 10/100/1000Base-T Ethernet 00:04:76:f3:c2:4f
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[0]
eth0: dma_rwctrl[76ff2d0f] dma_mask[64-bit]
sungem.c:v0.98 8/24/03 David S. Miller (davem@redhat.com)
pci_set_dma_mask() '0001:04:0f.0' c00000000ff72860 00000000ffffffff
PHY ID: 2062e0, addr: 1
eth1: Sun GEM (PCI) 10/100/1000BaseT Ethernet 00:0a:95:a6:5d:66 
eth1: Found BCM5421-K2 PHY
pci_set_dma_mask() '0001:03:0e.0' c00000000ff71860 00000000ffffffff
PCI: Enabling device: (0001:03:0e.0), cmd 2
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[40]  MMIO=[80200000-802007ff]  Max Packet=[4096]  IR/IT contexts=[8/8]
Adding 1023992k swap on /dev/sdb3.  Priority:-1 extents:1 across:1023992k
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
ieee1394: Node added: ID:BUS[0-00:1023]  GUID[0010100305179115]
ieee1394: Host added: ID:BUS[0-01:1023]  GUID[000a95fffea65d66]
sbp2_alloc_device():778 dev 'fw-host0' 0000000000000000 parent '0001:03:0e.0' c00000000ff71860 00000000ffffffff
dma_set_mask() '0001:03:0e.0' 00000000ffffffff c0000000005fee68
scsi4 : SBP-2 IEEE-1394
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
REISERFS (device sdb4): found reiserfs format "3.6" with standard journal
REISERFS (device sdb4): using ordered data mode
reiserfs: using flush barriers
REISERFS (device sdb4): journal params: device sdb4, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
REISERFS (device sdb4): checking transaction log (sdb4)
REISERFS (device sdb4): Using r5 hash to sort names
eth1: Link is up at 100 Mbps, full-duplex.
AppArmor: AppArmor initialized<5>audit(1186407949.200:2):  info="AppArmor initialized" pid=1871
fuse init (API version 7.8)
ieee1394: sbp2: Logged into SBP-2 device
ieee1394: sbp2: Node 0-00:1023: Max speed [S400] - Max payload [2048]
scsi 4:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-85JS  F100 PQ: 0 ANSI: 0
scsi 4:0:0:0: Attached scsi generic sg2 type 5
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda caddy
sr 4:0:0:0: Attached scsi CD-ROM sr0
audit(1186407951.229:3): operation="file_lock" requested_mask="k" denied_mask="k" name="/var/run/klogd.pid" pid=1949 profile="/sbin/klogd"
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (1024 buckets, 8192 max)
eth1: Link is up at 100 Mbps, full-duplex.
eth1: Pause is enabled (rxfifo: 10240 off: 7168 on: 5632)
audit(1186407961.889:4): operation="file_lock" requested_mask="k" denied_mask="k" name="/var/run/klogd.pid" pid=3061 profile="/sbin/klogd"
audit(1186407962.979:5): audit_pid=3113 old=0 by auid=4294967295
