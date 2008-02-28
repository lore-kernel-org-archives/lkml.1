Return-Path: <linux-kernel-owner+w=401wt.eu-S1762719AbYB1Tbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762719AbYB1Tbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758635AbYB1Tbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:31:44 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:41873 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758919AbYB1Tbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:31:41 -0500
Date: Thu, 28 Feb 2008 20:30:53 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: pci_proc_init: proc_dir_entry '00' already registered
Message-ID: <20080228193053.GA9537@aepfle.de>
References: <20080210100757.GA28322@aepfle.de> <20080210180003.GC1754@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080210180003.GC1754@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, Alexey Dobriyan wrote:

> On Sun, Feb 10, 2008 at 11:07:57AM +0100, Olaf Hering wrote:
> > Current Linus tree gives this new warning during bootup:
> > 
> > +proc_dir_entry '00' already registered
> > +Call Trace:
> > +[c00000007b0dfba0] [c00000000000e4b0] .show_stack+0x70/0x1bc (unreliable)
> > +[c00000007b0dfc50] [c0000000000f2714] .proc_register+0x130/0x210
> > +[c00000007b0dfd00] [c0000000000f299c] .proc_mkdir_mode+0x40/0x70
> > +[c00000007b0dfd80] [c000000000276ed8] .pci_proc_attach_device+0xac/0x144
> > +[c00000007b0dfe20] [c0000000005bdb3c] .pci_proc_init+0x74/0xac
> > +[c00000007b0dfea0] [c0000000005a27ac] .kernel_init+0x1d0/0x394
> > +[c00000007b0dff90] [c00000000001e258] .kernel_thread+0x4c/0x68
> 
> Can you insert dump_stack() when '00' is registered, not just second
> time?

Its pci_bus_add_device(). Full dmesg attached:

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index ef5a6a2..3c6fcd9 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -16,6 +16,8 @@ #include <linux/proc_fs.h>
 #include <linux/init.h>
 
 #include "pci.h"
+#define olh(fmt,args ...) \
+	printk(KERN_DEBUG "%s(%u) %s(%u):c%u,j%lu " fmt "\n",__FUNCTION__,__LINE__,current->comm,current->pid,smp_processor_id(),jiffies,##args)
 
 /**
  * pci_bus_alloc_resource - allocate a resource from a parent bus
@@ -80,6 +82,7 @@ pci_bus_alloc_resource(struct pci_bus *b
 int pci_bus_add_device(struct pci_dev *dev)
 {
 	int retval;
+	olh("%s",dev->dev.bus_id);
 	retval = device_add(&dev->dev);
 	if (retval)
 		return retval;
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index ef18fcd..1a9ef7c 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -6,6 +6,8 @@
  *	Copyright (c) 1997--1999 Martin Mares <mj@ucw.cz>
  */
 
+#define olh(fmt,args ...) \
+	printk(KERN_DEBUG "%s(%u) %s(%u):c%u,j%lu " fmt "\n",__FUNCTION__,__LINE__,current->comm,current->pid,smp_processor_id(),jiffies,##args)
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/module.h>
@@ -390,6 +392,7 @@ int pci_proc_attach_device(struct pci_de
 	struct proc_dir_entry *e;
 	char name[16];
 
+	olh("%d: %p - %s",proc_initialized,dev,dev->dev.bus_id);
 	if (!proc_initialized)
 		return -EACCES;
 
@@ -478,6 +481,7 @@ static int __init pci_proc_init(void)
 		entry->proc_fops = &proc_bus_pci_dev_operations;
 	proc_initialized = 1;
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+		olh("%s",dev->dev.bus_id);
 		pci_proc_attach_device(dev);
 	}
 	return 0;
DART table allocated at: c00000007f000000
Using PowerMac machine description
Page orders: linear mapping = 24, virtual = 12, io = 12
Found initrd at 0xc000000001300000:0xc000000001559c00
Found U4 memory controller & host bridge @ 0xf8000000 revision: 0x42
Mapped at 0xd000080080000000
Found a Shasta mac-io controller, rev: 0, mapped at 0xd000080080041000
PowerMac motherboard: PowerMac G5 Dual Core
DART IOMMU initialized for U4 type chipset
console [udbg0] enabled
CPU maps initialized for 1 thread per core
 (thread shift is 0)
Starting Linux PPC64 #231 SMP Thu Feb 28 19:53:21 CET 2008
-----------------------------------------------------
ppc64_pft_size                = 0x0
physicalMemorySize            = 0x80000000
htab_address                  = 0xc00000007c000000
htab_hash_mask                = 0x3ffff
-----------------------------------------------------
Linux version 2.6.25-rc3-g5-dirty (olaf@g5) (gcc version 4.1.0 (SUSE Linux)) #231 SMP Thu Feb 28 19:53:21 CET 2008
[boot]0012 Setup Arch
Entering add_active_range(0, 0, 524288) 0 entries of 256 used
Found U4-PCIE PCI host bridge.  Firmware bus number: 0->255
PCI host bridge /pci@0,f0000000  ranges:
 MEM 0x00000000f1000000..0x00000000f1ffffff -> 0x00000000f1000000 
  IO 0x00000000f0000000..0x00000000f07fffff -> 0x0000000000000000
 MEM 0x0000000090000000..0x00000000afffffff -> 0x0000000090000000 
Can't get bus-range for /ht@0,f2000000, assume bus 0
Found U3-HT PCI host bridge.  Firmware bus number: 0->239
PCI host bridge /ht@0,f2000000 (primary) ranges:
SMU: Driver 0.7 (c) 2005 Benjamin Herrenschmidt, IBM Corp.
nvram: Checking bank 0...
nvram: gen0=210, gen1=211
nvram: Active bank is: 1
nvram: OF partition at 0x410
nvram: XP partition at 0x1020
nvram: NR partition at 0x1120
Top of RAM: 0x80000000, Total RAM: 0x80000000
Memory hole size: 0MB
Zone PFN ranges:
  DMA             0 ->   524288
  Normal     524288 ->   524288
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   524288
On node 0 totalpages: 524288
  DMA zone: 7168 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 517120 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
[boot]0015 Setup Done
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517120
Kernel command line: root=UUID=a77c3a2a-dd4a-4cf6-8c74-287c49897b10 sysrq=1 quiet video=nvidiafb:1024x768@85,bpp:16 panic=12 
mpic: Setting up MPIC " MPIC 1   " version 1.2 at f8040000, max 4 CPUs
mpic: ISU size: 124, shift: 7, mask: 7f
mpic: Initializing for 124 sources
mpic: Setting up HT PICs workarounds for U3/U4
mpic:   - HT:07.0 [0x90] vendor 106b device 0053 has 86 irqs
PID hash table entries: 4096 (order: 12, 32768 bytes)
time_init: decrementer frequency = 33.333333 MHz
time_init: processor frequency   = 2300.000000 MHz
clocksource: timebase mult[7800001] shift[22] registered
clockevent: decrementer mult[888] shift[16] cpu[0]
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [tty0]
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Memory: 2004604k/2097152k available (6632k kernel code, 91864k reserved, 940k data, 489k bss, 248k init)
Calibrating delay loop... 66.56 BogoMIPS (lpj=332800)
Mount-cache hash table entries: 256
device-tree: Duplicate name in /ht@0,f2000000/pci@8/mac-io@7/i2c@18000, renamed to "i2c-bus@0#1"
PowerMac SMP probe found 2 cpus
KeyWest i2c @0xf8001003 irq 16 /u4@0,f8000000/i2c@f8001000
 channel 1 bus /u4@0,f8000000/i2c@f8001000/i2c-bus@1
KeyWest i2c @0x80018000 irq 27 /ht@0,f2000000/pci@8/mac-io@7/i2c@18000
 channel 0 bus /ht@0,f2000000/pci@8/mac-io@7/i2c@18000/i2c-bus@0
 channel 0 bus /ht@0,f2000000/pci@8/mac-io@7/i2c@18000/i2c-bus@0
SMU i2c /smu@0,0/smu-i2c-control@0
 channel b bus /smu@0,0/smu-i2c-control@0/i2c-bus@b
 channel e bus /smu@0,0/smu-i2c-control@0/i2c-bus@e
Processor timebase sync using platform function
mpic: requesting IPIs ... 
Processor 1 found.
clockevent: decrementer mult[888] shift[16] cpu[1]
Brought up 2 CPUs
net_namespace: 304 bytes
NET: Registered protocol family 16
PCI: Probing PCI hardware
IOMMU table initialized, virtual merging enabled
PCI: Closing bogus Apple Firmware region 2 on bus 0x0a
pci_bus_add_device(85) swapper(1):c0,j4294937324 0000:00:0b.0
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b113800 - 0000:00:0b.0
pci_bus_add_device(85) swapper(1):c0,j4294937324 0000:0a:00.0
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b113000 - 0000:0a:00.0
PCI: Closing bogus Apple Firmware region 2 on bus 0x02
PCI: Closing bogus Apple Firmware region 2 on bus 0x01
PCI: Closing bogus Apple Firmware region 2 on bus 0x03
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:00:00.0
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b149800 - 0001:00:00.0
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:00:01.0
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b149000 - 0001:00:01.0
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:00:02.0
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b1a4800 - 0001:00:02.0
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:00:03.0
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b1a4000 - 0001:00:03.0
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:00:04.0
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b1a5800 - 0001:00:04.0
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:00:05.0
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b1a5000 - 0001:00:05.0
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:00:06.0
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b1a6800 - 0001:00:06.0
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:00:07.0
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b1a6000 - 0001:00:07.0
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:00:08.0
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b1a7800 - 0001:00:08.0
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:00:09.0
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b1a7000 - 0001:00:09.0
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:05:04.0
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b1a9800 - 0001:05:04.0
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:05:04.1
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b1a9000 - 0001:05:04.1
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:01:07.0
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b1ab800 - 0001:01:07.0
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:01:0b.0
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b1ab000 - 0001:01:0b.0
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:01:0b.1
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b1ac800 - 0001:01:0b.1
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:01:0b.2
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b1ac000 - 0001:01:0b.2
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:03:0c.0
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b1ae800 - 0001:03:0c.0
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:03:0d.0
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b1ae000 - 0001:03:0d.0
pci_bus_add_device(85) swapper(1):c0,j4294937324 0001:03:0e.0
pci_proc_attach_device(395) swapper(1):c0,j4294937324 0: c00000007b1af800 - 0001:03:0e.0
PCI: Cannot allocate resource region 0 of device 0000:0a:00.0, will remap
PCI: Cannot allocate resource region 1 of device 0000:0a:00.0, will remap
PCI: Cannot allocate resource region 3 of device 0000:0a:00.0, will remap
PCI: Bridge: 0000:00:0b.0
  IO window: 0000-ffff
  MEM window: 0xa8000000-0xa9ffffff
  PREFETCH window: 0x0000000090000000-0x00000000a7ffffff
PCI: Bridge: 0001:00:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0001:00:02.0
  IO window: disabled.
  MEM window: 0xfa500000-0xfa5fffff
  PREFETCH window: disabled.
PCI: Bridge: 0001:00:03.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0001:00:04.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0001:00:05.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0001:00:06.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0001:00:07.0
  IO window: disabled.
  MEM window: 0xfa000000-0xfa3fffff
  PREFETCH window: disabled.
PCI: Bridge: 0001:00:08.0
  IO window: disabled.
  MEM window: 0x80000000-0x800fffff
  PREFETCH window: disabled.
PCI: Bridge: 0001:00:09.0
  IO window: disabled.
  MEM window: 0xfa400000-0xfa4fffff
  PREFETCH window: disabled.
PCI: Probing PCI hardware done
Registering pmac pic with sysfs...
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
NET: Registered protocol family 2
Time: timebase clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Unpacking initramfs... done
Freeing initrd memory: 2407k freed
nvram_init: Could not find nvram partition for nvram buffered error logging.
Registering G5 CPU frequency driver
Frequency method: SCOM, Voltage method: GPIO
Low: 1150 Mhz, High: 2300 Mhz, Cur: 2300 MHz
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SGI XFS with large block/inode numbers, no debug enabled
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_proc_init(484) swapper(1):c0,j4294937353 0000:00:0b.0
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b113800 - 0000:00:0b.0
pci_proc_init(484) swapper(1):c0,j4294937353 0000:0a:00.0
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b113000 - 0000:0a:00.0
pci_proc_init(484) swapper(1):c0,j4294937353 0001:00:00.0
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b149800 - 0001:00:00.0
proc_dir_entry '00' already registered
Call Trace:
[c00000007b0dfb60] [c00000000000f4ec] .show_stack+0x5c/0x1f0 (unreliable)
[c00000007b0dfc10] [c000000000112e40] .proc_register+0x190/0x250
[c00000007b0dfcd0] [c000000000113130] .proc_mkdir_mode+0x40/0x80
[c00000007b0dfd50] [c0000000002c7548] .pci_proc_attach_device+0x158/0x190
[c00000007b0dfe00] [c00000000065c3f8] .pci_proc_init+0xb8/0x100
[c00000007b0dfe90] [c00000000063c8a8] .kernel_init+0x1d8/0x420
[c00000007b0dff90] [c000000000021dac] .kernel_thread+0x4c/0x68
pci_proc_init(484) swapper(1):c0,j4294937353 0001:00:01.0
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b149000 - 0001:00:01.0
pci_proc_init(484) swapper(1):c0,j4294937353 0001:00:02.0
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b1a4800 - 0001:00:02.0
pci_proc_init(484) swapper(1):c0,j4294937353 0001:00:03.0
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b1a4000 - 0001:00:03.0
pci_proc_init(484) swapper(1):c0,j4294937353 0001:00:04.0
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b1a5800 - 0001:00:04.0
pci_proc_init(484) swapper(1):c0,j4294937353 0001:00:05.0
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b1a5000 - 0001:00:05.0
pci_proc_init(484) swapper(1):c0,j4294937353 0001:00:06.0
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b1a6800 - 0001:00:06.0
pci_proc_init(484) swapper(1):c0,j4294937353 0001:00:07.0
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b1a6000 - 0001:00:07.0
pci_proc_init(484) swapper(1):c0,j4294937353 0001:00:08.0
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b1a7800 - 0001:00:08.0
pci_proc_init(484) swapper(1):c0,j4294937353 0001:00:09.0
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b1a7000 - 0001:00:09.0
pci_proc_init(484) swapper(1):c0,j4294937353 0001:05:04.0
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b1a9800 - 0001:05:04.0
pci_proc_init(484) swapper(1):c0,j4294937353 0001:05:04.1
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b1a9000 - 0001:05:04.1
pci_proc_init(484) swapper(1):c0,j4294937353 0001:01:07.0
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b1ab800 - 0001:01:07.0
pci_proc_init(484) swapper(1):c0,j4294937353 0001:01:0b.0
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b1ab000 - 0001:01:0b.0
pci_proc_init(484) swapper(1):c0,j4294937353 0001:01:0b.1
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b1ac800 - 0001:01:0b.1
pci_proc_init(484) swapper(1):c0,j4294937353 0001:01:0b.2
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b1ac000 - 0001:01:0b.2
pci_proc_init(484) swapper(1):c0,j4294937353 0001:03:0c.0
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b1ae800 - 0001:03:0c.0
pci_proc_init(484) swapper(1):c0,j4294937353 0001:03:0d.0
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b1ae000 - 0001:03:0d.0
pci_proc_init(484) swapper(1):c0,j4294937353 0001:03:0e.0
pci_proc_attach_device(395) swapper(1):c0,j4294937353 1: c00000007b1af800 - 0001:03:0e.0
nvidiafb: Device ID: 10de0141 
nvidiafb: CRTC0 analog found
nvidiafb: CRTC1 analog found
i2c-adapter i2c-0: unable to read EDID block.
i2c-adapter i2c-0: unable to read EDID block.
i2c-adapter i2c-0: unable to read EDID block.
nvidiafb: Found OF EDID for head 1
nvidiafb: EDID found from BUS1
nvidiafb: EDID found from BUS2
nvidiafb: CRTC 0 appears to have a CRT attached
nvidiafb: Using CRT on CRTC 0
Console: switching to colour frame buffer device 128x48
nvidiafb: PCI nVidia NV14 framebuffer (64MB @ 0x90000000)
Generic RTC Driver v1.07
...
