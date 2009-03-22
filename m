Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbZCVDp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbZCVDp0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 23:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZCVDpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 23:45:10 -0400
Received: from main.gmane.org ([80.91.229.2]:48340 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbZCVDpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 23:45:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Micah Anderson <micah@riseup.net>
Subject: SATA partition detection failures
Date: Sat, 21 Mar 2009 23:06:00 -0400
Message-ID: <87prga9rzb.fsf@pond.riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: user-12lc0n3.cable.mindspring.com
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
Cancel-Lock: sha1:cpjFm1o+ctxXsraG6TyQmzyTAjw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been experiencing some odd behavior with 2.6.26 and 2.6.28 on a
Debian Lenny system with two SATA drives, its as if the kernel initially
sees the partitions on the second device, but then forgets about them
later. I can only get the partitions to be recognized by the system if I
force a partition table re-read (blockdev --rereadpt /dev/sdb).

On boot, the kernel sees the partition tables for /dev/sdb, a
SATA WDC WD5000YS drive, I can tell because I see in the dmesg the
device and its parititions:

[   34.375757]  sdb: sdb1 sdb2 sdb3

Also, if I debug the initramfs, I can see the partitions exist:

(initramfs)  ls -l /dev/[hs]d* 
brw-rw----    1 0        0         22,   0 Mar 17 21:13 /dev/hdc
brw-rw----    1 0        0          8,   0 Mar 17 21:13 /dev/sda
brw-rw----    1 0        0          8,   1 Mar 17 21:13 /dev/sda1
brw-rw----    1 0        0          8,   2 Mar 17 21:13 /dev/sda2
brw-rw----    1 0        0          8,   3 Mar 17 21:13 /dev/sda3
brw-rw----    1 0        0          8,  16 Mar 17 21:13 /dev/sdb
brw-rw----    1 0        0          8,  17 Mar 17 21:13 /dev/sdb1
brw-rw----    1 0        0          8,  18 Mar 17 21:13 /dev/sdb2
brw-rw----    1 0        0          8,  19 Mar 17 21:13 /dev/sdb3

However, once the system is fully up, the partitions do not exist in /dev/sdb* (although /dev/sdb exists):

# ls -l /dev/sdb*
brw-rw---- 1 root disk 8, 16 2009-03-17 15:10 /dev/sdb

One feels the urge to blame udev, but udev relies on what is in /sys,
and /sys/block/sdb doesn't contain any partitions:

# ls -l /sys/block/sdb*
bdi  capability  dev  device  ext_range  holders  power  queue  range  removable  ro  size  slaves  stat  subsystem  uevent

compare with /sys/block/sda:

# ls -l /sys/block/sda*
bdi         dev     ext_range  power  range      ro    sda2  size    stat       uevent
capability  device  holders    queue  removable  sda1  sda3  slaves  subsystem

Additionally, /proc/partitions doesn't show any partitions for /dev/sdb:

# cat /proc/partitions 
major minor  #blocks  name

   8        0  488386584 sda
   8        1     489951 sda1
   8        2     979965 sda2
   8        3  486914085 sda3
   8       16  488386584 sdb
   9        0     489856 md0
   9        1  486913984 md1
 253        0  486912956 dm-0
 253        1    1048576 dm-1
 253        2    5242880 dm-2
 253        3    5242880 dm-3
 253        4  475377664 dm-4
 253        5     979965 dm-5


Oddly, I can open up the partition table with fdisk/cfdisk and I can
see that /dev/sdb has valid partitions:

Disk /dev/sdb: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1          61      489951   fd  Linux raid autodetect
/dev/sdb2              62         183      979965   83  Linux
/dev/sdb3             184       60801   486914085   fd  Linux raid autodetect

Even more strange is that if I run: blockdev --rereadpt /dev/sdb

suddenly they show up again! On the console I see:

[  866.514569] sd 2:0:0:0: [sdb] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[  866.517793] sd 2:0:0:0: [sdb] Write Protect is off
[  866.521806] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  866.530926]  sdb: sdb1 sdb2 sdb3

and udev triggers and /dev/sdb* exist now:

brw-rw---- 1 root disk 8, 16 2009-03-17 15:10 /dev/sdb
brw-rw---- 1 root disk 8, 17 2009-03-17 15:24 /dev/sdb1
brw-rw---- 1 root disk 8, 18 2009-03-17 15:24 /dev/sdb2
brw-rw---- 1 root disk 8, 19 2009-03-17 15:24 /dev/sdb3

This is the complete kernel boot output, captured over serial:

root  (hd0,0)                                                                   
 Filesystem type is ext2fs, partition type 0xfd                                 
kernel  /vmlinuz-2.6.26-1-686 root=/dev/mapper/vg_shoveler0-root ro console=tty 
0 console=ttyS0,115200n8                                                        
   [Linux-bzImage, setup=0x3000, size=0x16c890]                                 
initrd  /initrd.img-2.6.26-1-686                                                
[    0.000000] Initializing cgroup subsys cpuset         
[    0.000000] Initializing cgroup subsys cpu                                   
[    0.000000] Linux version 2.6.26-1-686 (Debian 2.6.26-13) (waldi@debian.org) (gcc version 4.1.3 20080704 (prerelease) (Debian 4.1.2-24)) #1 SMP Sat Jan 10 18:29:31 UTC 2009
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000f7ef9000 (usable)
[    0.000000]  BIOS-e820: 00000000f7ef9000 - 00000000f7f00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000f7f00000 - 00000000f7f80000 (usable)
[    0.000000]  BIOS-e820: 00000000f7f80000 - 00000000f8000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000404000000 (usable)
[    0.000000] Warning only 4GB will be used.
[    0.000000] Use a HIGHMEM64G enabled kernel.
[    0.000000] 3200MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at [c00f6330] 000f6330
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->  1048576
[    0.000000] DMI present.
[    0.000000] ACPI Error (tbxfroot-0218): A valid RSDP was not found [20080321]
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000] MPTABLE: OEM ID:   Product ID: Kings Canyon <6>MPTABLE: Product ID: Kings Canyon <6>MPTABLE: APIC at: 0xFEE00000
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #6
[    0.000000] Processor #1
[    0.000000] Processor #7
[    0.000000] I/O APIC #2 Version 32 at 0xFEC00000.
[    0.000000] I/O APIC #3 Version 32 at 0xFEC80000.
[    0.000000] I/O APIC #4 Version 32 at 0xFEC80400.
[    0.000000] I/O APIC #5 Version 32 at 0xFEC81000.
[    0.000000] I/O APIC #8 Version 32 at 0xFEC81400.
[    0.000000] Enabling APIC mode:  Flat.  Using 5 I/O APICs
[    0.000000] Processors: 4
[    0.000000] Allocating PCI resources starting at f8800000 (gap: f8000000:06c00000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
[    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
[    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 37960 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1040384
[    0.000000] Kernel command line: root=/dev/mapper/vg_shoveler0-root ro console=tty0 console=ttyS0,115200n8
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 3189.489 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] console [ttyS0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Memory: 4017032k/4194304k available (1769k kernel code, 44444k reserved, 752k data, 244k init, 3145188k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
[    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.004000]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.004000]       .init : 0xc037f000 - 0xc03bc000   ( 244 kB)
[    0.004000]       .data : 0xc02ba4ab - 0xc0376620   ( 752 kB)
[    0.004000]       .text : 0xc0100000 - 0xc02ba4ab   (1769 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.084173] Calibrating delay using timer specific routine.. 6385.02 BogoMIPS (lpj=12770043)
[    0.092770] Security Framework initialized
[    0.096929] SELinux:  Disabled at boot.
[    0.100821] Capability LSM initialized
[    0.104640] Mount-cache hash table entries: 512
[    0.109426] Initializing cgroup subsys ns
[    0.113497] Initializing cgroup subsys cpuacct
[    0.117999] Initializing cgroup subsys devices
[    0.122517] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    0.127767] CPU: L2 cache: 512K
[    0.130964] CPU: L3 cache: 1024K
[    0.134249] CPU: Physical Processor ID: 0
[    0.138313] Intel machine check architecture supported.
[    0.143590] Intel machine check reporting enabled on CPU#0.
[    0.148009] CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
[    0.152009] CPU0: Thermal monitoring enabled
[    0.156009] Checking 'hlt' instruction... OK.
[    0.174377] ACPI: Core revision 20080321
[    0.178393] ACPI Exception (tbxface-0629): AE_NO_ACPI_TABLES, While loading namespace from ACPI tables [20080321]
[    0.188754] ACPI: Unable to load the System Description Tables
[    0.195131] ExtINT not setup in hardware but reported by MP table
[    0.200012] ENABLING IO-APIC IRQs
[    0.203606] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
[    0.247725] CPU0: Intel(R) Xeon(TM) CPU 3.20GHz stepping 05
[    0.364022] Booting processor 1/6 ip 6000
[    0.376023] Initializing CPU#1
[    0.376023] Calibrating delay using timer specific routine.. 6379.17 BogoMIPS (lpj=12758343)
[    0.376023] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    0.376023] CPU: L2 cache: 512K
[    0.376023] CPU: L3 cache: 1024K
[    0.376023] CPU: Physical Processor ID: 3
[    0.376023] Intel machine check architecture supported.
[    0.376023] Intel machine check reporting enabled on CPU#1.
[    0.376023] CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
[    0.376023] CPU1: Thermal monitoring enabled
[    0.456028] CPU1: Intel(R) Xeon(TM) CPU 3.20GHz stepping 05
[    0.463891] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.468029] Booting processor 2/1 ip 6000
[    0.484030] Initializing CPU#2
[    0.484030] Calibrating delay using timer specific routine.. 6379.13 BogoMIPS (lpj=12758277)
[    0.484030] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    0.484030] CPU: L2 cache: 512K
[    0.484030] CPU: L3 cache: 1024K
[    0.484030] CPU: Physical Processor ID: 0
[    0.484030] Intel machine check architecture supported.
[    0.484030] Intel machine check reporting enabled on CPU#2.
[    0.484030] CPU2: Intel P4/Xeon Extended MCE MSRs (12) available
[    0.484030] CPU2: Thermal monitoring enabled
[    0.561948] CPU2: Intel(R) Xeon(TM) CPU 3.20GHz stepping 05
[    0.572032] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.576148] Booting processor 3/7 ip 6000
[    0.592027] Initializing CPU#3
[    0.592027] Calibrating delay using timer specific routine.. 6379.17 BogoMIPS (lpj=12758342)
[    0.592027] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    0.592027] CPU: L2 cache: 512K
[    0.592027] CPU: L3 cache: 1024K
[    0.592027] CPU: Physical Processor ID: 3
[    0.592027] Intel machine check architecture supported.
[    0.592027] Intel machine check reporting enabled on CPU#3.
[    0.592027] CPU3: Intel P4/Xeon Extended MCE MSRs (12) available
[    0.592027] CPU3: Thermal monitoring enabled
[    0.672411] CPU3: Intel(R) Xeon(TM) CPU 3.20GHz stepping 05
[    0.681559] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.685559] Brought up 4 CPUs
[    0.688581] Total of 4 processors activated (25522.50 BogoMIPS).
[    0.693559] net_namespace: 660 bytes
[    0.697193] Booting paravirtualized kernel on bare hardware
[    0.701559] NET: Registered protocol family 16
[    0.705559] PCI: PCI BIOS revision 2.10 entry at 0xfd875, last bus=7
[    0.710082] PCI: Using configuration type 1 for base access
[    0.714082] Setting up standard PCI resources
[    0.746082] ACPI: Interpreter disabled.
[    0.749978] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.754082] pnp: PnP ACPI: disabled
[    0.758086] PnPBIOS: Scanning system for PnP BIOS support...
[    0.762540] PnPBIOS: Found PnP BIOS installation structure at 0xc00f63c0
[    0.770070] PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0x8ebc, dseg 0x400
[    0.781811] PnPBIOS: 21 nodes reported by PnP BIOS; 21 recorded by driver
[    0.785812] PCI: Probing PCI hardware
[    0.789811] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
[    0.793812] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH4 GPIO
[    0.797812] PCI: Transparent bridge - 0000:00:1e.0
[    0.801812] PCI: Discovered primary peer bus 10 [IRQ]
[    0.807657] PCI: Discovered primary peer bus 11 [IRQ]
[    0.811657] PCI: Discovered primary peer bus 12 [IRQ]
[    0.817802] PCI: Using IRQ router PIIX/ICH [8086/2480] at 0000:00:1f.0
[    0.821802] PCI->APIC IRQ transform: 0000:00:1d.0[A] -> IRQ 16
[    0.825802] PCI->APIC IRQ transform: 0000:00:1d.1[B] -> IRQ 19
[    0.829802] PCI->APIC IRQ transform: 0000:00:1d.2[C] -> IRQ 18
[    0.833802] PCI->APIC IRQ transform: 0000:03:01.0[A] -> IRQ 24
[    0.837802] PCI->APIC IRQ transform: 0000:03:02.0[A] -> IRQ 28
[    0.841802] PCI->APIC IRQ transform: 0000:03:02.1[B] -> IRQ 29
[    0.845802] PCI->APIC IRQ transform: 0000:06:02.0[A] -> IRQ 76
[    0.849802] PCI->APIC IRQ transform: 0000:06:02.1[B] -> IRQ 77
[    0.853802] PCI->APIC IRQ transform: 0000:07:01.0[A] -> IRQ 16
[    0.865803] system 00:00: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.873431] system 00:00: iomem range 0xfebffc00-0xfebfffff has been reserved
[    0.881437] system 00:01: iomem range 0x0-0x9ffff could not be reserved
[    0.888854] system 00:01: iomem range 0xe4000-0xfffff could not be reserved
[    0.895872] system 00:09: iomem range 0xe0000-0xe3fff has been reserved
[    0.902541] system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
[    0.909217] system 00:0b: ioport range 0x1000-0x105f has been reserved
[    0.915788] system 00:0b: ioport range 0x1060-0x107f has been reserved
[    0.922202] system 00:0b: ioport range 0x1180-0x11bf has been reserved
[    0.928791] system 00:0e: iomem range 0xfec00000-0xfec0ffff could not be reserved
[    0.936329] system 00:0e: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.943867] system 00:0f: iomem range 0xd1800-0xd3fff could not be reserved
[    0.956176] PCI: Bridge: 0000:01:1d.0
[    0.957463]   IO window: disabled.
[    0.960181]   MEM window: disabled.
[    0.964179]   PREFETCH window: disabled.
[    0.968180] PCI: Bridge: 0000:01:1f.0
[    0.972176]   IO window: 3000-3fff
[    0.976176]   MEM window: 0xfc200000-0xfc7fffff
[    0.980762]   PREFETCH window: disabled.
[    0.984737] PCI: Bridge: 0000:00:02.0
[    0.988449]   IO window: 3000-3fff
[    0.992173]   MEM window: 0xfc100000-0xfc7fffff
[    0.996759]   PREFETCH window: disabled.
[    1.000736] PCI: Bridge: 0000:04:1d.0
[    1.004444]   IO window: disabled.
[    1.008174]   MEM window: disabled.
[    1.011718]   PREFETCH window: disabled.
[    1.015697] PCI: Bridge: 0000:04:1f.0
[    1.019403]   IO window: 4000-4fff
[    1.022859]   MEM window: 0xfc900000-0xfc9fffff
[    1.027440]   PREFETCH window: 0x00000000f8800000-0x00000000f88fffff
[    1.033845] PCI: Bridge: 0000:00:03.0
[    1.037555]   IO window: 4000-4fff
[    1.041015]   MEM window: 0xfc800000-0xfc9fffff
[    1.045599]   PREFETCH window: 0x00000000f8800000-0x00000000f88fffff
[    1.053060] PCI: Bridge: 0000:00:1e.0
[    1.056769]   IO window: 5000-5fff
[    1.060227]   MEM window: 0xfca00000-0xfdffffff
[    1.063219]   PREFETCH window: 0x00000000f8900000-0x00000000f89fffff
[    1.069718] NET: Registered protocol family 2
[    1.090206] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    1.097757] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.106011] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    1.113643] TCP: Hash tables configured (established 131072 bind 65536)
[    1.118129] TCP reno registered
[    1.129461] NET: Registered protocol family 1
[    1.134270] checking if image is initramfs... it is
[    1.696156] Freeing initrd memory: 7404k freed
[    1.703731] audit: initializing netlink socket (disabled)
[    1.707759] type=2000 audit(1237322534.682:1): initialized
[    1.716156] highmem bounce pool size: 64 pages
[    1.720162] Total HugeTLB memory allocated, 0
[    1.725470] VFS: Disk quotas dquot_6.5.1
[    1.729483] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.733722] msgmni has been set to 1718
[    1.740225] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.745472] io scheduler noop registered
[    1.749472] io scheduler anticipatory registered
[    1.754142] io scheduler deadline registered
[    1.758482] io scheduler cfq registered (default)
[    1.767817] isapnp: Scanning for PnP cards...
[    2.128128] isapnp: No Plug & Play device found
[    2.138797] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    2.148319] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.154508] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.160694] 00:11: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.167191] 00:12: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.174897] brd: module loaded
[    2.180023] PNP: PS/2 Controller [PNP0303,PNP0f13] at 0x60,0x64 irq 1,12
[    2.187694] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.192719] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.200967] mice: PS/2 mouse device common for all mice
[    2.209263] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    2.215424] rtc0: alarms up to one day
[    2.219382] cpuidle: using governor ladder
[    2.223385] cpuidle: using governor menu
[    2.227364] No iBFT detected.
[    2.231221] TCP cubic registered
[    2.234499] NET: Registered protocol family 17
[    2.239498] Using IPI No-Shortcut mode
[    2.247302] registered taskstats version 1
[    2.251486] rtc_cmos 00:05: setting system clock to 2009-03-17 20:42:16 UTC (1237322536)
[    2.259806] Freeing unused kernel memory: 244k freed
Loading, please wait...
Begin: Loading essential drivers ... done.
Begin: Running /scripts/init-premount ... FATAL: Error inserting fan (/lib/modules/2.6.26-1-686/kernel/drivers/acpi/fan.ko): No such device
WARNING: Error i[    2.384460] thermal: Unknown symbol acpi_processor_set_thermal_limit
nserting processor (/lib/modules/2.6.26-1-686/kernel/drivers/acpi/processor.ko): No such device
FATAL: Error inserting thermal (/lib/modules/2.6.26-1-686/kernel/drivers/acpi/thermal.ko): Unknown symbol in module, or unknown parameter (see dmesg)
[    2.595390] usbcore: registered new interface driver usbfs
[    2.600139] usbcore: registered new interface driver hub
[    2.608131] usbcore: registered new device driver usb
[    2.616130] SCSI subsystem initialized
[    2.635255] USB Universal Host Controller Interface driver v3.0
[    2.643228] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.649604] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    2.655072] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00002000
[    2.661564] usb usb1: configuration #1 chosen from 1 choice
[    2.669099] hub 1-0:1.0: USB hub found
[    2.672978] hub 1-0:1.0: 2 ports detected
[    2.694969] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
[    2.701614] Copyright (c) 1999-2006 Intel Corporation.
[    2.732435] Floppy drive(s): fd0 is 1.44M
[    2.754112] FDC 0 is a post-1991 82077
[    2.793348] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    2.798126] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.808773] usb usb1: Product: UHCI Host Controller
[    2.813753] usb usb1: Manufacturer: Linux 2.6.26-1-686 uhci_hcd
[    2.819776] usb usb1: SerialNumber: 0000:00:1d.0
[    2.827774] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.832512] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[    2.841394] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002020
[    2.849461] usb usb2: configuration #1 chosen from 1 choice
[    2.855194] hub 2-0:1.0: USB hub found
[    2.859161] hub 2-0:1.0: 2 ports detected
[    2.967244] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.973920] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.980961] usb usb2: Product: UHCI Host Controller
[    2.988318] usb usb2: Manufacturer: Linux 2.6.26-1-686 uhci_hcd
[    2.993284] usb usb2: SerialNumber: 0000:00:1d.1
[    3.000315] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.005708] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[    3.015910] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
[    3.021902] usb usb3: configuration #1 chosen from 1 choice
[    3.027731] hub 3-0:1.0: USB hub found
[    3.031707] hub 3-0:1.0: 2 ports detected
[    3.050009] usb 1-1: new low speed USB device using uhci_hcd and address 2
[    3.142951] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.149897] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.159020] usb usb3: Product: UHCI Host Controller
[    3.164022] usb usb3: Manufacturer: Linux 2.6.26-1-686 uhci_hcd
[    3.170068] usb usb3: SerialNumber: 0000:00:1d.2
[    3.246118] usb 1-1: configuration #1 chosen from 1 choice
[    3.459637] e1000: 0000:03:02.0: e1000_probe: (PCI-X:133MHz:64-bit) 00:30:48:2d:07:3a
[    3.464467] usb 1-1: New USB device found, idVendor=0624, idProduct=0341
[    3.471681] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.479659] usb 1-1: Product: HP 336047-B21
[    3.484547] usb 1-1: Manufacturer: Avocent
[    3.495265] usbcore: registered new interface driver hiddev
[    3.515257] input: Avocent HP 336047-B21 as /class/input/input0
[    3.516687] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[    3.542769] input,hidraw0: USB HID v1.10 Keyboard [Avocent HP 336047-B21] on usb-0000:00:1d.0-1
[    3.570737] input: Avocent HP 336047-B21 as /class/input/input1
[    3.810741] e1000: 0000:03:02.1: e1000_probe: (PCI-X:133MHz:64-bit) 00:30:48:2d:07:3b
[    3.823924] input,hidraw1: USB HID v1.10 Mouse [Avocent HP 336047-B21] on usb-0000:00:1d.0-1
[    3.829324] usbcore: registered new interface driver usbhid
[    3.837313] usbhid: v2.6:USB HID core driver
[    3.862257] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
[    3.885736] sata_mv 0000:03:01.0: version 1.24
[    3.890508] sata_mv 0000:03:01.0: Gen-II 32 slots 8 ports SCSI mode IRQ via INTx
[    3.902011] scsi0 : sata_mv
[    3.905326] scsi1 : sata_mv
[    3.909939] scsi2 : sata_mv
[    3.909939] scsi3 : sata_mv
[    3.917251] scsi4 : sata_mv
[    3.920300] scsi5 : sata_mv
[    3.923342] scsi6 : sata_mv
[    3.923342] scsi7 : sata_mv
[    3.927381] ata1: SATA max UDMA/133 mmio m1048576@0xfc200000 port 0xfc222000 irq 24
[    3.935344] ata2: SATA max UDMA/133 mmio m1048576@0xfc200000 port 0xfc224000 irq 24
[    3.943345] ata3: SATA max UDMA/133 mmio m1048576@0xfc200000 port 0xfc226000 irq 24
[    3.951344] ata4: SATA max UDMA/133 mmio m1048576@0xfc200000 port 0xfc228000 irq 24
[    3.959344] ata5: SATA max UDMA/133 mmio m1048576@0xfc200000 port 0xfc232000 irq 24
[    3.967344] ata6: SATA max UDMA/133 mmio m1048576@0xfc200000 port 0xfc234000 irq 24
[    3.975344] ata7: SATA max UDMA/133 mmio m1048576@0xfc200000 port 0xfc236000 irq 24
[    3.983342] ata8: SATA max UDMA/133 mmio m1048576@0xfc200000 port 0xfc238000 irq 24
[    4.467422] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.503642] ata1.00: ATA-8: WDC WD5002ABYS-01B1B0, 02.03B02, max UDMA/133
[    4.511595] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.519603] ata1.00: max_sectors limited to 256 for NCQ
[    4.547241] ata1.00: max_sectors limited to 256 for NCQ
[    4.551748] ata1.00: configured for UDMA/133
[    5.031650] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.069430] ata2.00: ATA-7: WDC WD5000YS-01MPB1, 09.02E09, max UDMA/133
[    5.073434] ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.080273] ata2.00: max_sectors limited to 256 for NCQ
[    5.111746] ata2.00: max_sectors limited to 256 for NCQ
[    5.116074] ata2.00: configured for UDMA/133
[    5.439140] ata3: SATA link down (SStatus 0 SControl 300)
[    5.764452] ata4: SATA link down (SStatus 0 SControl 300)
[    6.089202] ata5: SATA link down (SStatus 0 SControl 300)
[    6.413260] ata6: SATA link down (SStatus 0 SControl 300)
[    6.737318] ata7: SATA link down (SStatus 0 SControl 300)
[    7.060647] ata8: SATA link down (SStatus 0 SControl 300)
[    7.068439] scsi 0:0:0:0: Direct-Access     ATA      WDC WD5002ABYS-0 02.0 PQ: 0 ANSI: 5
[    7.076597] scsi 1:0:0:0: Direct-Access     ATA      WDC WD5000YS-01M 09.0 PQ: 0 ANSI: 5
[   19.019773] scsi8 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
[   19.019776]         <Adaptec AIC7902 Ultra320 SCSI adapter>
[   19.019778]         aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 101-133Mhz, 512 SCBs
[   34.163649] scsi9 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
[   34.163652]         <Adaptec AIC7902 Ultra320 SCSI adapter>
[   34.163653]         aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI-X 101-133Mhz, 512 SCBs
[   34.202685] Uniform Multi-Platform E-IDE driver
[   34.204182] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   34.221183] ICH3: IDE controller (0x8086:0x248b rev 0x02) at  PCI slot 0000:00:1f.1
[   34.229208] ICH3: not 100% native mode: will probe irqs later
[   34.235228]     ide0: BM-DMA at 0x2060-0x2067
[   34.242726]     ide1: BM-DMA at 0x2068-0x206f
[   34.255769] Driver 'sd' needs updating - please use bus_type methods
[   34.260403] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[   34.271258] sd 0:0:0:0: [sda] Write Protect is off
[   34.278648] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   34.288602] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[   34.296556] sd 0:0:0:0: [sda] Write Protect is off
[   34.303902] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   34.310041]  sda: sda1 sda2 sda3
[   34.324592] sd 0:0:0:0: [sda] Attached SCSI disk
[   34.328662] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   34.336111] sd 1:0:0:0: [sdb] Write Protect is off
[   34.344592] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   34.357052] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   34.364309] sd 1:0:0:0: [sdb] Write Protect is off
[   34.370429] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   34.375757]  sdb: sdb1 sdb2 sdb3
[   34.390429] sd 1:0:0:0: [sdb] Attached SCSI disk
[   35.601071] hdc: CD-224E, ATAPI CD/DVD-ROM drive
[   36.277324] hdc: UDMA/33 mode selected
[   36.282605] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   36.286878] ide1 at 0x170-0x177,0x376 on irq 15
[   36.312299] hdc: ATAPI 24X CD-ROM drive, 128kB Cache
[   36.317578] Uniform CD-ROM driver Revision: 3.20
done.
Begin: Mounting root file system ... Begin: Running /scripts/local-top ... Begin: Loading[   36.401305] md: raid1 personality registered for level 1
Success: loaded module raid1.
done.
Begin: Assembling all MD arrays ... [   36.417883] md: md0 stopped.
[   36.499256] md: could not open unknown-block(8,17).
[   36.503264] md: md_import_device returned -6
mdadm: failed to[   36.507819] md: bind<sda1>
 add /dev/sdb1 to /dev/md0: No such device or address
[   36.524325] raid1: raid set md0 active with 1 out of 2 mirrors
mdadm: /dev/md0 [   36.530810] md: md1 stopped.
has been started with 1 drive (out of 2).
[   36.543977] md: bind<sda3>
[   36.559183] raid1: raid set md1 active with 1 out of 2 mirrors
mdadm: /dev/md1 has been started with 1 drive (out of 2).
Success: assembled all arrays.
done.
Begin: Waiting for udev to process events ... done.
[   36.635782] device-mapper: uevent: version 1.0.3
[   36.639775] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
  Volume group "vg_shoveler0" not found
Enter passphrase to unlock the disk /dev/md1 (md1_crypt): 
key slot 0 unlocked.
Command successful.
File descriptor 3 left open
  4 logical volume(s) in volume group "vg_shoveler0" now active
cryptsetup: md1_crypt setup successfully
done.
Begin: Running /scripts/local-premount ... done.
[   41.119869] kjournald starting.  Commit interval 5 seconds
Begin: Running /[   41.119869] EXT3-fs: mounted filesystem with ordered data mode.
scripts/local-bottom ... done.
done.
Begin: Running /scripts/init-bottom ... done.
INIT: version 2.86 booting
Starting the hotplug events dispatcher: udevd[   42.134635] udevd version 125 started
.
Synthesizing the initial hotplug events...done.
Waiting for /dev to be fully populated...[   42.670909] EDAC MC: Ver: 2.1.0 Jan 10 2009
[   42.686611] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   42.706153] input: PC Speaker as /class/input/input2
[   42.743895] EDAC e7xxx: tolm = f8000, remapbase = 3fc000, remaplimit = 404000
[   42.754953] EDAC MC0: Giving out device to 'e7xxx_edac' 'E7501': DEV 0000:00:00.0
[   42.758991] EDAC PCI0: Giving out device to module 'e7xxx_edac' controller 'EDAC PCI controller': DEV '0000:00:00.0' (POLLED)
[   42.784928] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   42.878770] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[   42.887797] iTCO_wdt: Found a ICH3-S TCO device (Version=1, TCOBASE=0x1060)
[   42.895736] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   43.002068] PCI: No IRQ known for interrupt pin B of device 0000:00:1f.3. Probably buggy MP table.
[   43.129537] Intel 82802 RNG detected
[   43.205068] parport_pc 00:15: reported by Plug and Play BIOS
[   43.212367] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE,EPP]
[   43.251994] Error: Driver 'pcspkr' is already registered, aborting...
done.
Setting the system clock.
Checking root file system...fsck 1.41.3 (12-Oct-2008)
/dev/mapper/vg_shoveler0-root: clean, 12115/65536 files, 77966/262144 blocks
done.
[   43.970669] EXT3 FS on dm-1, internal journal
Setting the system clock.
Cleaning up ifupdown....
Loading kernel modules...[   44.203508] loop: module loaded
done.
Generating udev events for MD arrays...done.
Starting early crypto disks...sda2_crypt (starting).
done.
Setting up LVM Volume Groups  Reading all physical volumes.  This may take a while...
  Found volume group "vg_shoveler0" using metadata type lvm2
  4 logical volume(s) in volume group "vg_shoveler0" now active
.
Starting remaining crypto disks...done.
Checking file systems...fsck 1.41.3 (12-Oct-2008)
/dev/md0: clean, 47/122880 files, 97056/489856 blocks
/dev/mapper/vg_shoveler0-usr: clean, 19614/327680 files, 141986/1310720 blocks
/dev/mapper/vg_shoveler0-var: clean, 2404/327680 files, 162666/1310720 blocks
done.
Setting kernel variables (/etc/sysctl.conf)...done.
Mounting local filesystems...[   46.987408] kjournald starting.  Commit interval 5 seconds
[   47.053398] EXT3 FS on md0, internal journal
[   47.057403] EXT3-fs: mounted filesystem with ordered data mode.
[   47.109475] kjournald starting.  Commit interval 5 seconds
[   47.109475] EXT3 FS on dm-2, internal journal
[   47.109475] EXT3-fs: mounted filesystem with ordered data mode.
[   47.152371] kjournald starting.  Commit interval 5 seconds
done.
[   47.152575] EXT3 FS on dm-3, internal journal
[   47.152580] EXT3-fs: mounted filesystem with ordered data mode.
Activating swapfile swap...[   47.497038] Adding 979956k swap on /dev/mapper/sda2_crypt.  Priority:-1 extents:1 across:979956k
done.
Setting up networking....
Configuring network interfaces...[   48.905311] NET: Registered protocol family 10
[   48.909308] lo: Disabled Privacy Extensions
[   48.984339] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   48.985275] e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
[   49.000331] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
if-up.d/mountnfs[eth0]: waiting for interface eth1 before doing NFS mounts (warning).
[   49.101671] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   49.104158] e1000: eth1: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   49.115883] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
done.
Setting console screen modes and fonts.
INIT: Entering runlevel: 2
Starting enhanced syslogd: rsyslogd.
Starting system message bus: dbus.
Starting domain name service...: bind9.
Starting virtual private network daemon: phoenix.
Starting OpenBSD Secure Shell server: sshd.
Starting MTA: exim4.
Starting nagios-statd-server: nagios-statd.
Starting puppet configuration management tool[   57.307052] tun: Universal TUN/TAP device driver, 1.6
[   57.311052] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   57.324824] tun0: Disabled Privacy Extensions
.
Starting NTP server: ntpd.
Starting MD monitoring service: mdadm --monitor
.
Starting periodic command scheduler: crond.
Starting Munin-Node: done.
[   65.159188] warning: `ntpd' uses 32-bit capabilities (legacy support in use)

output from scripts/ver_linux:

Linux shoveler 2.6.28-1-686-bigmem #1 SMP Mon Feb 23 04:05:37 UTC 2009 i686 GNU/Linux
 
Gnu C                  ./ver_linux:
Gnu make               3.81
binutils               2.18.0.20080103
util-linux             2.13.1.1
mount                  2.13.1.1
module-init-tools      3.4
e2fsprogs              1.41.3
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               6.10
udev                   125
Modules Loaded         tun ipv6 loop parport_pc parport psmouse serio_raw pcspkr intel_rng rng_core i2c_i801 i2c_core iTCO_wdt evdev joydev shpchp pci_hotplug e7xxx_edac edac_core ext3 jbd mbcache serpent xts gf128mul dm_crypt dm_mirror dm_region_hash dm_log dm_snapshot dm_mod raid1 md_mod sd_mod crc_t10dif ide_cd_mod cdrom ide_pci_generic usbhid hid piix ide_core ata_generic sata_mv floppy aic79xx scsi_transport_spi uhci_hcd libata e1000 scsi_mod usbcore thermal_sys

