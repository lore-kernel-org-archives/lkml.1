Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbXFLXAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbXFLXAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbXFLXAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:00:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44719 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbXFLXAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:00:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.22-rc4-mm2: GPF during suspend to RAM on HPC nx6325
Date: Wed, 13 Jun 2007 01:06:50 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <200706110102.52946.rjw@sisk.pl> <200706122355.26223.rjw@sisk.pl> <200706130009.51278.rjw@sisk.pl>
In-Reply-To: <200706130009.51278.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_KcybGuWUHuoPH3a"
Message-Id: <200706130106.50574.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_KcybGuWUHuoPH3a
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday, 13 June 2007 00:09, Rafael J. Wysocki wrote:
> On Tuesday, 12 June 2007 23:55, Rafael J. Wysocki wrote:
> > On Monday, 11 June 2007 09:17, Tejun Heo wrote:
> > > Hello, Rafael.
> > > 
> > > Rafael J. Wysocki wrote:
> > > > gregkh-driver-sysfs-use-singly-linked-list-for-sysfs_dirent-tree.patch breaks
> > > > suspend to RAM on HPC nx6325 (x86_64).
> > > > 
> > > > With this patch applied I get a general protection fault in mutex_lock+0x15
> > > > (kernel/mutex.c:91), called by sysfs_hash_and_remove() (fs/sysfs/inode.c:298),
> > > > called by threshold_cpu_callback(), called from _cpu_down().
> > > 
> > > I'm not sure whether this is bug in sysfs or in sysfs handling code in
> > > mce_amd and I can't test mce_amd here.  Can you please apply the
> > > attached patch and post the resulting dmesg including oops?
> > 
> > I've applied the patch, but the oops is a kernel panic, so I can't generate a
> > dmesg including it. ;-)
> > 
> > Here's the dmesg output from a fresh boot (runlevel 2):
> > 
> > http://www.sisk.pl/kernel/debug/2.6.22-rc4-mm2/dmesg.log
> > 
> > Here's a picture of the oops taken after a failed attempt to suspend:
> > 
> > http://www.sisk.pl/kernel/debug/2.6.22-rc4-mm2/during_suspend.jpg
> > 
> > Here's a picture of the oops taken after a failed attempt to offline CPU1
> > using 'echo 1 > /sys/devices/system/cpu/cpu1/online':
> > 
> > http://www.sisk.pl/kernel/debug/2.6.22-rc4-mm2/after_offlining_cpu1.jpg
> > 
> > [Sorry for the quality of pictures, I couldn't get anything better.]
> 
> More information:
> 
> With the debug patch applied the oops is a NULL pointer dereference
> at sysfs_hash_and_remove+0x16, which according to gdb is
> 
> (gdb) l *sysfs_hash_and_remove+0x16
> 0xffffffff802d4bff is in sysfs_hash_and_remove (/home/rafael/src/mm/linux-2.6.22-rc4-mm2/fs/sysfs/inode.c:294).
> 289             int found = 0;
> 290
> 291             if (!dir)
> 292                     return -ENOENT;
> 293
> 294             if (dir->d_inode == NULL)
> 295                     /* no inode means this hasn't been made visible yet */
> 296                     return -ENOENT;
> 297
> 298             mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);

Update:

I've managed to obtain a dmesg output containing the oops, which is appended.
I've slightly modified your debug patch before (attached), by adding a printk()
in mce_amd.c:617 .

Greetings,
Rafael


---
Initializing container subsys cpuset
Linux version 2.6.22-rc4-mm2 (rafael@albercik) (gcc version 4.1.2 20061115 (prerelease) (SUSE Linux)) #30 SMP Wed Jun 13 00:42:53 CEST 2007
Command line: root=/dev/sda3 vga=792 resume=/dev/sda1 2
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000077fd0000 (usable)
 BIOS-e820: 0000000077fd0000 - 0000000077fe5600 (reserved)
 BIOS-e820: 0000000077fe5600 - 0000000077ff8000 (ACPI NVS)
 BIOS-e820: 0000000077ff8000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
 BIOS-e820: 00000000ffbc0000 - 00000000ffcc0000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 491472) 1 entries of 256 used
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP 000F7D30, 0024 (r2 HP    )
ACPI: XSDT 77FE57B4, 0054 (r1 HP     0944      6070620 HP          1)
ACPI: FACP 77FE5684, 00F4 (r4 HP     0944            3 HP          1)
ACPI: DSDT 77FE58DC, EE7A (r1 HP        SB400    10000 MSFT  100000E)
ACPI: FACS 77FF7E80, 0040
ACPI: APIC 77FE5808, 0062 (r1 HP     0944            1 HP          1)
ACPI: MCFG 77FE586C, 003C (r1 HP     0944            1 HP          1)
ACPI: TCPA 77FE58A8, 0032 (r2 HP     0944            1 HP          1)
ACPI: SSDT 77FF4756, 0059 (r1 HP       HPQNLP        1 MSFT  100000E)
ACPI: SSDT 77FF47AF, 0206 (r1 HP     PSSTBLID        1 HP          1)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 491472) 1 entries of 256 used
No mptable found.
sizeof(struct page) = 56
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   491472
On node 0 totalpages: 491375
Node 0 memmap at 0xffff810001000000 size 27525120 first pfn 0xffff810001000000
  DMA zone: 56 pages used for memmap
  DMA zone: 1382 pages reserved
  DMA zone: 2561 pages, LIFO batch:0
  DMA32 zone: 6663 pages used for memmap
  DMA32 zone: 480713 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ATI board detected. Disabling timer routing over 8254.
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 47368 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 483274
Kernel command line: root=/dev/sda3 vga=792 resume=/dev/sda1 2
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 1995.104 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
CPU 0: aperture @ 148000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 1924312k/1965888k available (2209k kernel code, 40868k reserved, 1445k data, 248k init)
Calibrating delay using timer specific routine.. 3993.98 BogoMIPS (lpj=7987976)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 1153 Objects with 113 Devices 337 Methods 33 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 2 Objects with 0 Devices 2 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0003) - 8 Objects with 0 Devices 0 Methods 0 Regions
 tbxface-0587 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
..MP-BIOS bug: 8254 timer not connected to IO-APIC
Using local APIC timer interrupts.
result 12469416
Detected 12.469 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3990.28 BogoMIPS (lpj=7980564)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Turion(tm) 64 X2 Mobile Technology TL-60 stepping 02
Brought up 2 CPUs
Time: 22:45:28  Date: 05/12/107
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: No mmconfig possible on device 00:18
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x15
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 3 Wake, Enabled 11 Runtime GPEs in this block
Completing Region/Field/Buffer/Package initialization:..................................................................................................................................................................
Initialized 30/33 Regions 0/0 Fields 64/64 Buffers 68/78 Packages (1172 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:.......
Executed 7 _INI methods requiring 2 _STA executions (examined 120 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [C074] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:14.4
PCI: Bus #03 (-#06) is hidden behind transparent bridge #02 (-#03) (try 'pci=assign-busses')
Please report the result to linux-kernel to fix this permanently
ACPI: PCI Interrupt Routing Table [\_SB_.C074._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C074.C075._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C074.C0DF._PRT]
ACPI: PCI Interrupt Link [C125] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C126] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C127] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C128] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C129] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C12A] (IRQs 9) *0, disabled.
ACPI: PCI Interrupt Link [C12B] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C12C] (IRQs *10 11)
ACPI: Power Resource [C223] (off)
ACPI: Power Resource [C1FE] (off)
ACPI: Power Resource [C217] (on)
ACPI: Power Resource [C34B] (off)
ACPI: Power Resource [C34C] (off)
ACPI: Power Resource [C34D] (off)
ACPI: Power Resource [C34E] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 0 of device 0000:00:14.2
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
ACPI: RTC can wake from S4
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:00: iomem range 0x100000-0x77ffffff could not be reserved
pnp: 00:0a: ioport range 0x40b-0x40b has been reserved
pnp: 00:0a: ioport range 0x4d0-0x4d1 has been reserved
pnp: 00:0a: ioport range 0x4d6-0x4d6 has been reserved
pnp: 00:0a: iomem range 0xffb00000-0xffbfffff could not be reserved
pnp: 00:0a: iomem range 0xfff00000-0xffffffff could not be reserved
pnp: 00:0b: ioport range 0x8000-0x802f has been reserved
pnp: 00:0b: ioport range 0x8100-0x811f has been reserved
pnp: 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
pnp: 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
pnp: 00:0c: iomem range 0xcf000-0xcffff has been reserved
pnp: 00:0c: iomem range 0x78000000-0x7fffffff could not be reserved
pnp: 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: 6000-6fff
  MEM window: d4300000-d43fffff
  PREFETCH window: c0000000-c7ffffff
PCI: Bridge: 0000:00:04.0
  IO window: 4000-5fff
  MEM window: d0000000-d3ffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: 2000-3fff
  MEM window: cc000000-cfffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: c8000000-c80fffff
  PREFETCH window: disabled.
PCI: Bus 3, cardbus bridge: 0000:02:04.0
  IO window: 00001000-000010ff
  IO window: 00001400-000014ff
  PREFETCH window: 88000000-8bffffff
  MEM window: 90000000-93ffffff
PCI: Bridge: 0000:00:14.4
  IO window: 1000-1fff
  MEM window: d4000000-d42fffff
  PREFETCH window: 88000000-8bffffff
PCI: Setting latency timer of device 0000:00:04.0 to 64
PCI: Setting latency timer of device 0000:00:05.0 to 64
PCI: Setting latency timer of device 0000:00:06.0 to 64
ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, low) -> IRQ 20
Time: acpi_pm clocksource has been installed.
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 5184k freed
XXX0 registering threshold_bank4 (ffff81000411cb50)
XXX0 registering misc0 (ffff810003853ef0)
audit: initializing netlink socket (disabled)
audit(1181688327.944:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: MSI quirk detected. MSI deactivated.
Boot video device is 0000:01:05.0
PCI: Setting latency timer of device 0000:00:04.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:04.0:pcie00]
Allocate Port Service[0000:00:04.0:pcie01]
Allocate Port Service[0000:00:04.0:pcie03]
PCI: Setting latency timer of device 0000:00:05.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:05.0:pcie00]
Allocate Port Service[0000:00:05.0:pcie01]
Allocate Port Service[0000:00:05.0:pcie03]
PCI: Setting latency timer of device 0000:00:06.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:06.0:pcie00]
Allocate Port Service[0000:00:06.0:pcie01]
Allocate Port Service[0000:00:06.0:pcie03]
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:04.0:pcie01 failed with error 2
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:05.0:pcie01 failed with error 2
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:06.0:pcie01 failed with error 2
vesafb: framebuffer at 0xc0000000, mapped to 0xffffc20010100000, using 4608k, total 16384k
vesafb: mode is 1024x768x24, linelength=3072, pages=6
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
RAMDISK driver initialized: 16 RAM disks of 128000K size 1024 blocksize
sata_sil 0000:00:12.0: version 2.2
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 16 (level, low) -> IRQ 16
scsi0 : sata_sil
scsi1 : sata_sil
ata1: SATA max UDMA/100 cmd 0xffffc20000024080 ctl 0xffffc2000002408a bmdma 0xffffc20000024000 irq 0
ata2: SATA max UDMA/100 cmd 0xffffc200000240c0 ctl 0xffffc200000240ca bmdma 0xffffc20000024008 irq 0
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: FUJITSU MHV2080BH, 892C, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHV2080B 892C PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
sd 0:0:0:0: [sda] Attached SCSI disk
PNP: PS/2 Controller [PNP0303:C214,PNP0f13:C215] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input0
input: AT Translated Set 2 keyboard as /class/input/input1
NET: Registered protocol family 1
swsusp: Resume From Partition /dev/sda1
PM: Checking swsusp image.
PM: Resume from disk failed.
  Magic number: 11:471:805
Freeing unused kernel memory: 248k freed
Write protecting the kernel read-only data: 1108k
sd 0:0:0:0: Attached scsi generic sg0 type 0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ATIIXP: IDE controller at PCI slot 0000:00:14.1
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
ATIIXP: chipset revision 128
ATIIXP: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x7040-0x7047, BIOS settings: hda:DMA, hdb:pio
ATIIXP: simplex device: DMA disabled
ide1: ATIIXP Bus-Master DMA disabled (BIOS)
Probing IDE interface ide0...
hda: HL-DT-ST DVDRAM GMA-4082N, ATAPI CD/DVD-ROM drive
hda: selected mode 0x22
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Basic memory bitmaps created
swsusp: Basic memory bitmaps freed
Attempting manual resume
swsusp: Resume From Partition 8:1
PM: Checking swsusp image.
PM: Resume from disk failed.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Floppy drive(s): fd0 is 1.44M
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of 00:07 failed with error -16
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ieee80211_crypt: registered algorithm 'NULL'
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:00:13.0: OHCI Host Controller
/home/rafael/src/mm/linux-2.6.22-rc4-mm2/drivers/usb/core/inode.c: creating file 'devices'
/home/rafael/src/mm/linux-2.6.22-rc4-mm2/drivers/usb/core/inode.c: creating file '001'
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:13.0: created debug files
ohci_hcd 0000:00:13.0: irq 19, io mem 0xd4401000
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
ohci_hcd 0000:00:13.0: OHCI controller state
ohci_hcd 0000:00:13.0: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:13.0: control 0x083 HCFS=operational CBSR=3
ohci_hcd 0000:00:13.0: cmdstatus 0x00000 SOC=0
ohci_hcd 0000:00:13.0: intrstatus 0x00000004 SF
ohci_hcd 0000:00:13.0: intrenable 0x8000005a MIE RHSC UE RD WDH
ohci_hcd 0000:00:13.0: hcca frame #0005
ohci_hcd 0000:00:13.0: roothub.a 02000204 POTPGT=2 NPS NDP=4(4)
ohci_hcd 0000:00:13.0: roothub.b 00000000 PPCM=0000 DR=0000
ohci_hcd 0000:00:13.0: roothub.status 00008000 DRWE
ohci_hcd 0000:00:13.0: roothub.portstatus [0] 0x00000100 PPS
ohci_hcd 0000:00:13.0: roothub.portstatus [1] 0x00010101 CSC PPS CCS
ohci_hcd 0000:00:13.0: roothub.portstatus [2] 0x00000100 PPS
ohci_hcd 0000:00:13.0: roothub.portstatus [3] 0x00000100 PPS
usb usb1: default language 0x0409
usb usb1: new device found, idVendor=0000, idProduct=0000
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.22-rc4-mm2 ohci_hcd
usb usb1: SerialNumber: 0000:00:13.0
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: global over-current protection
hub 1-0:1.0: power on to power good time: 4ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: no over-current condition exists
hub 1-0:1.0: trying to enable port power on non-switchable hub
/home/rafael/src/mm/linux-2.6.22-rc4-mm2/drivers/usb/core/inode.c: creating file '001'
piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
sdhci: SDHCI controller found at 0000:02:04.3 [104c:803c] (rev 0)
hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0004
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00010101 CSC PPS CCS
hub 1-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:00:13.1: OHCI Host Controller
ACPI: PCI Interrupt 0000:02:04.3[A] -> GSI 20 (level, low) -> IRQ 20
mmc0: SDHCI at 0xd4019000 irq 20 PIO
/home/rafael/src/mm/linux-2.6.22-rc4-mm2/drivers/usb/core/inode.c: creating file '002'
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.1: created debug files
ohci_hcd 0000:00:13.1: irq 19, io mem 0xd4402000
ohci_hcd 0000:00:13.1: OHCI controller state
ohci_hcd 0000:00:13.1: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:13.1: control 0x083 HCFS=operational CBSR=3
ohci_hcd 0000:00:13.1: cmdstatus 0x00000 SOC=0
ohci_hcd 0000:00:13.1: intrstatus 0x00000004 SF
ohci_hcd 0000:00:13.1: intrenable 0x8000005a MIE RHSC UE RD WDH
ohci_hcd 0000:00:13.1: hcca frame #0005
ohci_hcd 0000:00:13.1: roothub.a 02000204 POTPGT=2 NPS NDP=4(4)
ohci_hcd 0000:00:13.1: roothub.b 00000000 PPCM=0000 DR=0000
ohci_hcd 0000:00:13.1: roothub.status 00008000 DRWE
ohci_hcd 0000:00:13.1: roothub.portstatus [0] 0x00010101 CSC PPS CCS
ohci_hcd 0000:00:13.1: roothub.portstatus [1] 0x00000100 PPS
ohci_hcd 0000:00:13.1: roothub.portstatus [2] 0x00000100 PPS
ohci_hcd 0000:00:13.1: roothub.portstatus [3] 0x00010301 CSC LSDA PPS CCS
usb usb2: default language 0x0409
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.22-rc4-mm2 ohci_hcd
usb usb2: SerialNumber: 0000:00:13.1
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: global over-current protection
hub 2-0:1.0: power on to power good time: 4ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: no over-current condition exists
hub 2-0:1.0: trying to enable port power on non-switchable hub
/home/rafael/src/mm/linux-2.6.22-rc4-mm2/drivers/usb/core/inode.c: creating file '001'
hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, DMA
Uniform CD-ROM driver Revision: 3.20
ACPI: PCI Interrupt 0000:02:04.2[A] -> GSI 20 (level, low) -> IRQ 20
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
ehci_hcd: block sizes: qh 192 qtd 96 itd 192 sitd 96
ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.2: EHCI Host Controller
/home/rafael/src/mm/linux-2.6.22-rc4-mm2/drivers/usb/core/inode.c: creating file '003'
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:13.2: reset hcs_params 0x2408 dbg=0 cc=2 pcc=4 ordered !ppc ports=8
ehci_hcd 0000:00:13.2: reset hcc_params a012 thresh 1 uframes 256/512/1024
ehci_hcd 0000:00:13.2: MWI active
ehci_hcd 0000:00:13.2: irq 19, io mem 0xd4403000
ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:13.2: init command 010009 (park)=0 ithresh=1 period=256 RUN
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb3: default language 0x0409
usb usb3: new device found, idVendor=0000, idProduct=0000
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: EHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.22-rc4-mm2 ehci_hcd
usb usb3: SerialNumber: 0000:00:13.2
usb usb3: uevent
usb usb3: usb_probe_device
usb 1-2: new full speed USB device using ohci_hcd and address 2
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
usb 3-0:1.0: uevent
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 8 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: Single TT
hub 3-0:1.0: TT requires at most 8 FS bit times (666 ns)
hub 3-0:1.0: power on to power good time: 20ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
ohci_hcd 0000:00:13.0: urb ffff810004496308 path 2 ep0in 5ec20000 cc 5 --> status -62
/home/rafael/src/mm/linux-2.6.22-rc4-mm2/drivers/usb/core/inode.c: creating file '001'
ohci_hcd 0000:00:13.0: urb ffff810004496308 path 2 ep0in 5ec20000 cc 5 --> status -62
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
ohci_hcd 0000:00:13.0: urb ffff810004496308 path 2 ep0in 5ec20000 cc 5 --> status -62
tg3.c:v3.77 (May 31, 2007)
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 23 (level, low) -> IRQ 23
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00030100 PESC CSC PPS
hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0012
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00010100 CSC PPS
hub 2-0:1.0: port 1, status 0100, change 0001, 12 Mb/s
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
eth0: Tigon3 [partno(BCM95788A50) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:17:08:2e:2e:f3
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
eth0: dma_rwctrl[763f0000] dma_mask[32-bit]
hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [3] = 0x00010100 CSC PPS
hub 2-0:1.0: port 4, status 0100, change 0001, 12 Mb/s
Yenta: CardBus bridge found at 0000:02:04.0 [103c:30b0]
hub 2-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x100
hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0004
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00030100 PESC CSC PPS
hub 1-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
Yenta: Enabling burst memory read transactions
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:04.0, mfunc 0x01a11002, devctl 0x64
hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
hub 3-0:1.0: state 7 ports 8 chg 0000 evt 0000
ehci_hcd 0000:00:13.2: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
hub 3-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 16
hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:13.2: port 2 full speed --> companion
ehci_hcd 0000:00:13.2: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
hub 3-0:1.0: port 2 not reset yet, waiting 50ms
Yenta: ISA IRQ mask 0x0eb8, PCI irq 20
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#02) from #03 to #06
ehci_hcd 0000:00:13.2: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
ehci_hcd 0000:00:13.2: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT
hub 3-0:1.0: port 3, status 0501, change 0001, 480 Mb/s
pcmcia: parent PCI bridge I/O window: 0x1000 - 0x1fff
pcmcia: parent PCI bridge Memory window: 0xd4000000 - 0xd42fffff
pcmcia: parent PCI bridge Memory window: 0x88000000 - 0x8bffffff
bcm43xx driver
hub 3-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x501
floppy0: no floppy controllers found
ehci_hcd 0000:00:13.2: port 3 full speed --> companion
ehci_hcd 0000:00:13.2: GetStatus port 3 status 003801 POWER OWNER sig=j CONNECT
hub 3-0:1.0: port 3 not reset yet, waiting 50ms
ACPI: PCI Interrupt 0000:02:04.1[A] -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:13.2: GetStatus port 3 status 003002 POWER OWNER sig=se0 CSC
ehci_hcd 0000:00:13.2: GetStatus port 8 status 001403 POWER sig=k CSC CONNECT
hub 3-0:1.0: port 8, status 0501, change 0001, 480 Mb/s
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[d4011000-d40117ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
ACPI: PCI Interrupt 0000:30:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:30:00.0 to 64
bcm43xx: Chip ID 0x4311, rev 0x1
bcm43xx: Number of cores: 4
bcm43xx: Core 0: ID 0x800, rev 0x11, vendor 0x4243
bcm43xx: Core 1: ID 0x812, rev 0xa, vendor 0x4243
bcm43xx: Core 2: ID 0x817, rev 0x3, vendor 0x4243
bcm43xx: Core 3: ID 0x820, rev 0x1, vendor 0x4243
bcm43xx: PHY connected
bcm43xx: Detected PHY: Analog: 4, Type 2, Revision 8
bcm43xx: Detected Radio: ID: 2205017f (Manuf: 17f Ver: 2050 Rev: 2)
bcm43xx: Radio turned off
hub 3-0:1.0: debounce: port 8: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:13.2: port 8 low speed --> companion
bcm43xx: Radio turned off
ehci_hcd 0000:00:13.2: GetStatus port 8 status 003002 POWER OWNER sig=se0 CSC
hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0002
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00010101 CSC PPS CCS
hub 2-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
usb 2-1: new full speed USB device using ohci_hcd and address 2
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
usb 2-1: ep0 maxpacket = 8
usb 2-1: default language 0x0409
usb 2-1: new device found, idVendor=08ff, idProduct=2580
usb 2-1: new device strings: Mfr=0, Product=1, SerialNumber=0
usb 2-1: Product: Fingerprint Sensor
usb 2-1: uevent
usb 2-1: usb_probe_device
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: adding 2-1:1.0 (config #1, interface 0)
usb 2-1:1.0: uevent
usb 2-1:1.0: uevent
/home/rafael/src/mm/linux-2.6.22-rc4-mm2/drivers/usb/core/inode.c: creating file '002'
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [3] = 0x00010301 CSC LSDA PPS CCS
hub 2-0:1.0: port 4, status 0301, change 0001, 1.5 Mb/s
hub 2-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x301
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [3] = 0x00100303 PRSC LSDA PPS PES CCS
usb 2-4: new low speed USB device using ohci_hcd and address 3
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [3] = 0x00100303 PRSC LSDA PPS PES CCS
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x25a0b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio4/input0
usb 2-4: skipped 1 descriptor after interface
usb 2-4: default language 0x0409
usb 2-4: new device found, idVendor=046d, idProduct=c510
usb 2-4: new device strings: Mfr=1, Product=2, SerialNumber=0
input: SynPS/2 Synaptics TouchPad as /class/input/input2
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f9929613f0c]
usb 2-4: Product: USB Receiver
usb 2-4: Manufacturer: Logitech
usb 2-4: uevent
usb 2-4: usb_probe_device
usb 2-4: configuration #1 chosen from 1 choice
usb 2-4: adding 2-4:1.0 (config #1, interface 0)
usb 2-4:1.0: uevent
usb 2-4:1.0: uevent
/home/rafael/src/mm/linux-2.6.22-rc4-mm2/drivers/usb/core/inode.c: creating file '003'
hub 3-0:1.0: state 7 ports 8 chg 0000 evt 0100
hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0004
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00010101 CSC PPS CCS
hub 1-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
usb 1-2: new full speed USB device using ohci_hcd and address 3
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
usb 1-2: skipped 1 descriptor after interface
usb 1-2: default language 0x0409
usb 1-2: new device found, idVendor=03f0, idProduct=171d
usb 1-2: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-2: Product: HP Integrated Module
usb 1-2: Manufacturer: Broadcom Corp
usb 1-2: uevent
usb 1-2: usb_probe_device
usb 1-2: configuration #1 chosen from 1 choice
usb 1-2: adding 1-2:1.0 (config #1, interface 0)
usb 1-2:1.0: uevent
usb 1-2:1.0: uevent
usb 1-2: adding 1-2:1.1 (config #1, interface 1)
usb 1-2:1.1: uevent
usb 1-2:1.1: uevent
usb 1-2: adding 1-2:1.2 (config #1, interface 2)
usb 1-2:1.2: uevent
usb 1-2:1.2: uevent
usb 1-2: adding 1-2:1.3 (config #1, interface 3)
usb 1-2:1.3: uevent
usb 1-2:1.3: uevent
/home/rafael/src/mm/linux-2.6.22-rc4-mm2/drivers/usb/core/inode.c: creating file '003'
hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0010
hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0004
usbcore: registered new interface driver hiddev
usbhid 2-4:1.0: usb_probe_interface
usbhid 2-4:1.0: usb_probe_interface - got id
input: Logitech USB Receiver as /class/input/input3
input,hidraw0: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:13.1-4
usbcore: registered new interface driver usbhid
/home/rafael/src/mm/linux-2.6.22-rc4-mm2/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: HCI USB driver ver 2.9
hci_usb 1-2:1.0: usb_probe_interface
hci_usb 1-2:1.0: usb_probe_interface - got id
usb_endpoint usbdev1.3_ep83: ep_device_release called for usbdev1.3_ep83
usb_endpoint usbdev1.3_ep03: ep_device_release called for usbdev1.3_ep03
hci_usb 1-2:1.2: usb_probe_interface
hci_usb 1-2:1.2: usb_probe_interface - got id
hci_usb 1-2:1.3: usb_probe_interface
hci_usb 1-2:1.3: usb_probe_interface - got id
usbcore: registered new interface driver hci_usb
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
usb 2-1: usb auto-suspend
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
hub 3-0:1.0: hub_suspend
usb usb3: usb auto-suspend
ehci_hcd 0000:00:13.2: suspend root hub
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Floppy drive(s): fd0 is 1.44M
floppy0: no floppy controllers found
Adding 1052216k swap on /dev/sda1.  Priority:-1 extents:1 across:1052216k
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (8192 buckets, 65536 max)
ACPI: AC Adapter [C1BD] (on-line)
ACPI: Battery Slot [C1BF] (battery present)
ACPI: Battery Slot [C1BE] (battery absent)
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input5
ACPI: Sleep Button (CM) [C25A]
input: Lid Switch as /class/input/input6
ACPI: Lid Switch [C25B]
ACPI: Transitioning device [C34F] to D3
ACPI: Transitioning device [C34F] to D3
ACPI: Fan [C34F] (off)
ACPI: Transitioning device [C350] to D3
ACPI: Transitioning device [C350] to D3
ACPI: Fan [C350] (off)
ACPI: Transitioning device [C351] to D3
ACPI: Transitioning device [C351] to D3
ACPI: Fan [C351] (off)
ACPI: Transitioning device [C352] to D3
ACPI: Transitioning device [C352] to D3
ACPI: Fan [C352] (off)
ACPI Exception (processor_throttling-0084): AE_NOT_FOUND, Evaluating _PTC [20070126]
ACPI Exception (processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [20070126]
ACPI: Processor [C000] (supports 8 throttling states)
ACPI Exception (processor_throttling-0084): AE_NOT_FOUND, Evaluating _PTC [20070126]
ACPI Exception (processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [20070126]
ACPI: Processor [C001] (supports 8 throttling states)
ACPI: Thermal Zone [TZ1] (67 C)
ACPI: Thermal Zone [TZ2] (57 C)
ACPI: Thermal Zone [TZ3] (36 C)
powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-60 processors (2 cpu cores) (version 2.00.00)
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x13
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x15
powernow-k8:    2 : fid 0x8 (1600 MHz), vid 0x17
powernow-k8:    3 : fid 0x0 (800 MHz), vid 0x1e
powernow-k8: ph2 null fid transition 0xc
usb usb3: usb auto-resume
usb usb3: finish resume
ehci_hcd 0000:00:13.2: resume root hub
hub 3-0:1.0: hub_resume
hub 3-0:1.0: state 7 ports 8 chg 0000 evt 0000
usb 2-1: usb auto-resume
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00040103 PSSC PPS PES CCS
usb 2-1: finish resume
hub 3-0:1.0: hub_suspend
usb usb3: usb auto-suspend
ehci_hcd 0000:00:13.2: suspend root hub
usb 2-1: usb auto-suspend
usb usb3: usb auto-resume
usb usb3: finish resume
ehci_hcd 0000:00:13.2: resume root hub
hub 3-0:1.0: hub_resume
hub 3-0:1.0: state 7 ports 8 chg 0000 evt 0000
usb 2-1: usb auto-resume
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00040103 PSSC PPS PES CCS
usb 2-1: finish resume
hub 3-0:1.0: hub_suspend
usb usb3: usb auto-suspend
ehci_hcd 0000:00:13.2: suspend root hub
usb 2-1: usb auto-suspend
Cannot set affinity for irq 0
CPU 1 is now offline
SMP alternatives: switching to UP code
XXX1 removing <NULL> (ffff810002a5c530)
Unable to handle kernel NULL pointer dereference at 0000000000000010 RIP: 
 [<ffffffff802d2db7>] sysfs_hash_and_remove+0x16/0xcb
PGD 0 
Oops: 0000 [1] SMP 
CPU 0 
Modules linked in: cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table thermal processor fan button battery ac snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat iptable_filter ip6table_mangle nf_conntrack_ipv4 nf_conntrack nfnetlink ip_tables ip6table_filter ip6_tables x_tables ipv6 loop rfcomm hidp l2cap dm_mod hci_usb bluetooth usbhid ff_memless psmouse pcmcia bcm43xx ohci1394 firmware_class snd_hda_intel ieee1394 yenta_socket rsrc_nonstatic ieee80211softmac ieee80211 pcmcia_core snd_pcm shpchp tg3 ehci_hcd tifm_7xx1 ide_cd cdrom snd_timer sdhci tifm_core i2c_piix4 i2c_core ohci_hcd ieee80211_crypt usbcore snd soundcore snd_page_alloc k8temp hwmon pci_hotplug rtc_cmos rtc_core rtc_lib mmc_core ext3 jbd edd atiixp ide_disk ide_core sg
Pid: 4085, comm: bash Not tainted 2.6.22-rc4-mm2 #30
RIP: 0010:[<ffffffff802d2db7>]  [<ffffffff802d2db7>] sysfs_hash_and_remove+0x16/0xcb
RSP: 0018:ffff810005d3fcb8  EFLAGS: 00010283
RAX: ffff810003045cc0 RBX: ffff810002a5c520 RCX: 0000000100000000
RDX: 00000000fffffffe RSI: ffff810005d3fd18 RDI: 0000000000000000
RBP: ffff810005d3fcd8 R08: ffffffff80548688 R09: 000000000257e422
R10: ffff810005d3fa18 R11: ffff810000000001 R12: 0000000000000001
R13: 0000000000000000 R14: ffff810005d3fd18 R15: ffff81000411cb50
FS:  00002b0000382b90(0000) GS:ffffffff80592000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000010 CR3: 0000000004c1b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bash (pid: 4085, threadinfo ffff810005d3e000, task ffff81000331a800)
Stack:  ffff810002a5c520 0000000000000001 ffffffff806965e0 ffff810005d3fd18
 ffff810005d3fce8 ffffffff802d4f2e ffff810005d3fd68 ffffffff80215a8c
 ffff810005d3fd18 0000000400000001 0000000000000004 0000000480543da0
Call Trace:
 [<ffffffff802d4f2e>] sysfs_remove_link+0xd/0xf
 [<ffffffff80215a8c>] threshold_cpu_callback+0x12d/0x31b
 [<ffffffff80424ca7>] notifier_call_chain+0x33/0x65
 [<ffffffff80240c5d>] __raw_notifier_call_chain+0x9/0xb
 [<ffffffff80240c6e>] raw_notifier_call_chain+0xf/0x11
 [<ffffffff80250a5b>] _cpu_down+0x1c7/0x29f
 [<ffffffff80250b60>] cpu_down+0x2d/0x44
 [<ffffffff8037a2d8>] store_online+0x32/0x75
 [<ffffffff80376a96>] sysdev_store+0x24/0x26
 [<ffffffff802d346e>] sysfs_write_file+0xf3/0x134
 [<ffffffff8028fbc4>] vfs_write+0xcf/0x158
 [<ffffffff8029014d>] sys_write+0x47/0x70
 [<ffffffff8020bdae>] system_call+0x7e/0x83


Code: 48 8b 47 10 48 8b 9f 98 00 00 00 48 85 c0 0f 84 96 00 00 00 
RIP  [<ffffffff802d2db7>] sysfs_hash_and_remove+0x16/0xcb
 RSP <ffff810005d3fcb8>
CR2: 0000000000000010

--Boundary-00=_KcybGuWUHuoPH3a
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="debug.patch"

---
 arch/x86_64/kernel/mce_amd.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.22-rc4-mm2/arch/x86_64/kernel/mce_amd.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/arch/x86_64/kernel/mce_amd.c
+++ linux-2.6.22-rc4-mm2/arch/x86_64/kernel/mce_amd.c
@@ -434,6 +434,7 @@ static __cpuinit int allocate_threshold_
 	kobject_set_name(&b->kobj, "misc%i", block);
 	b->kobj.parent = &per_cpu(threshold_banks, cpu)[bank]->kobj;
 	b->kobj.ktype = &threshold_ktype;
+	printk("XXX%d registering %s (%p)\n", cpu, kobject_name(&b->kobj), &b->kobj);
 	err = kobject_register(&b->kobj);
 	if (err)
 		goto out_free;
@@ -454,6 +455,7 @@ recurse:
 
 out_free:
 	if (b) {
+		printk("XXX%d unregistering %s (%p)\n", cpu, kobject_name(&b->kobj), &b->kobj);
 		kobject_unregister(&b->kobj);
 		kfree(b);
 	}
@@ -511,6 +513,7 @@ static __cpuinit int threshold_create_ba
 #else
 	b->cpus = cpu_core_map[cpu];
 #endif
+	printk("XXX%d registering %s (%p)\n", cpu, kobject_name(&b->kobj), &b->kobj);
 	err = kobject_register(&b->kobj);
 	if (err)
 		goto out_free;
@@ -580,6 +583,7 @@ static void deallocate_threshold_block(u
 		return;
 
 	list_for_each_entry_safe(pos, tmp, &head->blocks->miscj, miscj) {
+		printk("XXX%d unregistering %s (%p)\n", cpu, kobject_name(&pos->kobj), &pos->kobj);
 		kobject_unregister(&pos->kobj);
 		list_del(&pos->miscj);
 		kfree(pos);
@@ -608,6 +612,9 @@ static void threshold_remove_bank(unsign
 #ifdef CONFIG_SMP
 	/* sibling symlink */
 	if (shared_bank[bank] && b->blocks->cpu != cpu) {
+		struct kobject *kobj = &per_cpu(device_mce, cpu).kobj;
+
+		printk("XXX%d removing %s (%p)\n", cpu, kobject_name(kobj), kobj);
 		sysfs_remove_link(&per_cpu(device_mce, cpu).kobj, name);
 		per_cpu(threshold_banks, cpu)[bank] = NULL;
 		return;
@@ -626,6 +633,7 @@ static void threshold_remove_bank(unsign
 	deallocate_threshold_block(cpu, bank);
 
 free_out:
+	printk("XXX%d unregistering %s (%p)\n", cpu, kobject_name(&b->kobj), &b->kobj);
 	kobject_unregister(&b->kobj);
 	kfree(b);
 	per_cpu(threshold_banks, cpu)[bank] = NULL;

--Boundary-00=_KcybGuWUHuoPH3a--
