Return-Path: <linux-kernel-owner+w=401wt.eu-S1764311AbZDCOVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764311AbZDCOVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbZDCOVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:21:36 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:54822 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197AbZDCOVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:21:32 -0400
Date: Fri, 3 Apr 2009 10:21:30 -0400
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tytso@mit.edu, drees76@gmail.com, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090403142129.GH3795@csclub.uwaterloo.ca>
References: <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090401143622.b1885643.akpm@linux-foundation.org> <20090402010044.GA16092@elte.hu> <20090403040649.GF3795@csclub.uwaterloo.ca> <alpine.LFD.2.00.0904022112260.4130@localhost.localdomain> <20090403072507.GO5178@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403072507.GO5178@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 09:25:07AM +0200, Jens Axboe wrote:
> CFQ was just faster, plus it supported things like io priorities that AS
> does not.

Faster at what?  I am now wondering if switching the servers at work to
anticipatory will make them be more responsive when an rsnapshot run is
done (which it is every 3 hours).  That would provide another data point.
It is currently very easy to tell when 10:00, 13:00, 16:00 and 19:00
comes around.

> Who knows, it's definitely interesting and something to look into why AS
> performs that differently to CFQ on his box. Lennart, can you give some
> information on what file system + mount options, disk drive(s), etc? A
> full dmesg would be good, too.

Well the system is setup like this:

Core 2 Quad Q6600 CPU (2.4GHz quad core).
Asus P5K mainboard (Intel P35 chipset)
6GB of ram
PVR500 dual NTSC tuner pci card
4 x 500GB WD5000AAKS SATA drives
	25GB sda1 + sdb1 raid1 for /
	25GB sdc1 + sdd1 raid1 for /home
	remaining as sda2 + sdb2 + sdc2 + sdd2 raid5 for LVM.
	1.2TB /var uses most of the LVM for mythtv storage and other data
	6GB swap on LVM
	94GB test volume on LVM (this uses ext4 but is hardly ever used)
	all filesystems other than the test one are ext3

I run the ICH9 in AHCI mode since in IDE mode it doesn't do 64bit DMA
and the bounce buffers seemed to be having issues keeping up.

So normal use of the machine is:

mythtv-backend + mysql takes care of the mythtv recording work.

mythtv-frontend with output on an nvidia 8600GT (with proprietary drivers
in use)
commercial flagging and some transcode to mpeg4 for shows I keep for a
while run in parallel, since after all there are 4 cores to use.

folding@home running smp (using all 4 cores) at idle priority

birtornado running with many torrents running slowly seeding (I limit it
to 5kb/s up at all times due to monthly caps on transfers from my ISP,
s this way it can do something consistently without going over).
It probably has 300GB worth of files being seeded at the moment.

So when I first built the machine it ran really nicely, but I think that
was with 2.6.16 or 2.6.18 or so.  It was a while ago.  It worked quite
well, responsiveness was good, etc.  2.6.24 - 2.6.26 has been not
so great.  Well until I switched the ioscheduler a couple of days ago.

So the behaviour with cfq is:
Disk light seems to be constantly on if there is any disk activity.  iotop
can show a total io of maybe 1MB/s and the disk light is on constantly.
Rarely does it seem to make it over about 15MB/s of total io.  Running a
sync command in the hopes that it will get a clue usually takes 20 to
30 seconds to complete.  Running it again right after it completes can
take another 5 seconds if something is recording at the time.  That seems
like a long time to handle a few seconds worth of MPEG2 NTSC video.
Starting playback on mythtv most often fails on the first attempt with a
15 second timeout, and then on the second attempt it will usually manage
to start playback.  Sometimes it takes a 3rd attempt.

The behaviour with anticipatory is:
Disk light flashes every second or two for a moment, iotop shows much
faster completion of io, and I have even seen 75MB/s worth of IO when
restarting the bittornado client and having it hash check the data
of files.  With cfq that never seemed to get over about 15MB/s and the
system would become unusable while doing it.  mythtv reponsiveness is
instant like it used to be in the past.  Running sync returns practically
immediately.  Maybe 1second in worst case (which was with 2 shows
recording, 2 transcoding, and bittorrent hash checking).

Anyhow here is dmesg from bootup.  The only thing I have seen in it since
boot (I unfortunately cleared it yesterday to see if any more messages
were happening since the change) are messages about mpeg2 data dropped
by ivtv because the system wasn't keeping up.  I haven't seen any of
those messages since the switch.  They were happening a lot before.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.26-1-amd64 (Debian 2.6.26-13) (waldi@debian.org) (gcc version 4.1.3 20080704 (prerelease) (Debian 4.1.2-24)) #1 SMP Sat Jan 10 17:57:00 UTC 2009
[    0.000000] Command line: root=/dev/md0 ro quiet 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff80000 (usable)
[    0.000000]  BIOS-e820: 00000000cff80000 - 00000000cff8e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cff8e000 - 00000000cffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cffe0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001b0000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 158) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 851840) 1 entries of 3200 used
[    0.000000] Entering add_active_range(0, 1048576, 1769472) 2 entries of 3200 used
[    0.000000] max_pfn_mapped = 1769472
[    0.000000] init_memory_mapping
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FBCD0, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT CFF80100, 0054 (r1 A_M_I_ OEMXSDT   3000805 MSFT       97)
[    0.000000] ACPI: FACP CFF80290, 00F4 (r3 A_M_I_ OEMFACP   3000805 MSFT       97)
[    0.000000] ACPI: DSDT CFF80440, 90AB (r1  A0871 A0871018       18 INTL 20060113)
[    0.000000] ACPI: FACS CFF8E000, 0040
[    0.000000] ACPI: APIC CFF80390, 006C (r1 A_M_I_ OEMAPIC   3000805 MSFT       97)
[    0.000000] ACPI: MCFG CFF80400, 003C (r1 A_M_I_ OEMMCFG   3000805 MSFT       97)
[    0.000000] ACPI: OEMB CFF8E040, 0081 (r1 A_M_I_ AMI_OEM   3000805 MSFT       97)
[    0.000000] ACPI: HPET CFF894F0, 0038 (r1 A_M_I_ OEMHPET   3000805 MSFT       97)
[    0.000000] ACPI: OSFR CFF89530, 00B0 (r1 A_M_I_ OEMOSFR   3000805 MSFT       97)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000001b0000000
[    0.000000] Entering add_active_range(0, 0, 158) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 851840) 1 entries of 3200 used
[    0.000000] Entering add_active_range(0, 1048576, 1769472) 2 entries of 3200 used
[    0.000000] Bootmem setup node 0 0000000000000000-00000001b0000000
[    0.000000]   NODE_DATA [0000000000010000 - 0000000000014fff]
[    0.000000]   bootmap [0000000000015000 -  000000000004afff] pages 36
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-675397] TEXT DATA BSS
[    0.000000]   early res: 3 [37775000-37fef581] RAMDISK
[    0.000000]   early res: 4 [9ec00-fffff] BIOS reserved
[    0.000000]   early res: 5 [8000-ffff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe20002dfffff] PMD -> [ffff810001200000-ffff810003ffffff] on node 0
[    0.000000]  [ffffe20003800000-ffffe20005ffffff] PMD -> [ffff81000c000000-ffff81000e7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1769472
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      158
[    0.000000]     0:      256 ->   851840
[    0.000000]     0:  1048576 ->  1769472
[    0.000000] On node 0 totalpages: 1572638
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1251 pages reserved
[    0.000000]   DMA zone: 2691 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833464 pages, LIFO batch:31
[    0.000000]   Normal zone: 9856 pages used for memmap
[    0.000000]   Normal zone: 711040 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cff80000 - 00000000cff8e000
[    0.000000] PM: Registered nosave memory: 00000000cff8e000 - 00000000cffe0000
[    0.000000] PM: Registered nosave memory: 00000000cffe0000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000:2ee00000)
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 37168 bytes of per cpu data
[    0.000000] NR_CPUS: 32, nr_cpu_ids: 4
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1547195
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/md0 ro quiet 
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] time.c: Detected 2405.452 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Checking aperture...
[    0.004000] Calgary: detecting Calgary via BIOS EBDA area
[    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing software IO TLB between 0x4000000 - 0x8000000
[    0.004000] Memory: 6122760k/7077888k available (2226k kernel code, 167792k reserved, 1082k data, 392k init)
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000] hpet clockevent registered
[    0.083783] Calibrating delay using timer specific routine.. 4895.00 BogoMIPS (lpj=9790007)
[    0.083821] Security Framework initialized
[    0.083826] SELinux:  Disabled at boot.
[    0.083829] Capability LSM initialized
[    0.084005] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.088005] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.088005] Mount-cache hash table entries: 256
[    0.088185] Initializing cgroup subsys ns
[    0.088190] Initializing cgroup subsys cpuacct
[    0.088192] Initializing cgroup subsys devices
[    0.088211] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.088213] CPU: L2 cache: 4096K
[    0.088215] CPU 0/0 -> Node 0
[    0.088216] CPU: Physical Processor ID: 0
[    0.088217] CPU: Processor Core ID: 0
[    0.088224] CPU0: Thermal monitoring enabled (TM2)
[    0.088225] using mwait in idle threads.
[    0.089074] ACPI: Core revision 20080321
[    0.148009] CPU0: Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
[    0.148009] Using local APIC timer interrupts.
[    0.152009] APIC timer calibration result 16704557
[    0.152009] Detected 16.704 MHz APIC timer.
[    0.152009] Booting processor 1/1 ip 6000
[    0.160010] Initializing CPU#1
[    0.160010] Calibrating delay using timer specific routine.. 4767.29 BogoMIPS (lpj=9534596)
[    0.160010] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.160010] CPU: L2 cache: 4096K
[    0.160010] CPU 1/1 -> Node 0
[    0.160010] CPU: Physical Processor ID: 0
[    0.160010] CPU: Processor Core ID: 1
[    0.160010] CPU1: Thermal monitoring enabled (TM2)
[    0.240015] CPU1: Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
[    0.240015] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.244015] Booting processor 2/2 ip 6000
[    0.252015] Initializing CPU#2
[    0.252015] Calibrating delay using timer specific routine.. 4811.00 BogoMIPS (lpj=9622005)
[    0.252015] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.252015] CPU: L2 cache: 4096K
[    0.252015] CPU 2/2 -> Node 0
[    0.252015] CPU: Physical Processor ID: 0
[    0.252015] CPU: Processor Core ID: 2
[    0.252015] CPU2: Thermal monitoring enabled (TM2)
[    0.331645] CPU2: Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
[    0.331664] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.336021] Booting processor 3/3 ip 6000
[    0.347625] Initializing CPU#3
[    0.347625] Calibrating delay using timer specific routine.. 4853.64 BogoMIPS (lpj=9707299)
[    0.347625] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.347625] CPU: L2 cache: 4096K
[    0.347625] CPU 3/3 -> Node 0
[    0.347625] CPU: Physical Processor ID: 0
[    0.347625] CPU: Processor Core ID: 3
[    0.347625] CPU3: Thermal monitoring enabled (TM2)
[    0.424043] CPU3: Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
[    0.424061] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.428290] Brought up 4 CPUs
[    0.428290] Total of 4 processors activated (19326.95 BogoMIPS).
[    0.428290] CPU0 attaching sched-domain:
[    0.428290]  domain 0: span 0-1
[    0.428290]   groups: 0 1
[    0.428290]   domain 1: span 0-3
[    0.428290]    groups: 0-1 2-3
[    0.428290]    domain 2: span 0-3
[    0.428290]     groups: 0-3
[    0.428290] CPU1 attaching sched-domain:
[    0.428290]  domain 0: span 0-1
[    0.428290]   groups: 1 0
[    0.428290]   domain 1: span 0-3
[    0.428290]    groups: 0-1 2-3
[    0.428290]    domain 2: span 0-3
[    0.428290]     groups: 0-3
[    0.428290] CPU2 attaching sched-domain:
[    0.428290]  domain 0: span 2-3
[    0.428290]   groups: 2 3
[    0.428290]   domain 1: span 0-3
[    0.428290]    groups: 2-3 0-1
[    0.428290]    domain 2: span 0-3
[    0.428290]     groups: 0-3
[    0.428290] CPU3 attaching sched-domain:
[    0.428290]  domain 0: span 2-3
[    0.428290]   groups: 3 2
[    0.428290]   domain 1: span 0-3
[    0.428290]    groups: 2-3 0-1
[    0.428290]    domain 2: span 0-3
[    0.428290]     groups: 0-3
[    0.428290] net_namespace: 1224 bytes
[    0.428290] Booting paravirtualized kernel on bare hardware
[    0.428290] NET: Registered protocol family 16
[    0.428290] ACPI: bus type pci registered
[    0.428290] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.428290] PCI: Not using MMCONFIG.
[    0.428290] PCI: Using configuration type 1 for base access
[    0.428290] ACPI: EC: Look up EC in DSDT
[    0.442132] ACPI: Interpreter enabled
[    0.442134] ACPI: (supports S0 S1 S3 S4 S5)
[    0.442171] ACPI: Using IOAPIC for interrupt routing
[    0.442223] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.445747] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.457787] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.468107] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.468851] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.468855] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.470581] PCI: Transparent bridge - 0000:00:1e.0
[    0.470809] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.471412] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.471519] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.471717] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    0.471826] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.471946] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.489478] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.489649] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.489793] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.489907] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *4 5 6 7 10 11 12 14 15)
[    0.490021] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.490135] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.491031] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.491145] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.494260] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.494260] pnp: PnP ACPI init
[    0.494260] ACPI: bus type pnp registered
[    0.494260] pnp 00:00: parse allocated resources
[    0.494260] pnp 00:00:   add io  0xcf8-0xcff flags 0x1
[    0.494260] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.494260] pnp 00:01: parse allocated resources
[    0.494260] pnp 00:01:   add mem 0xfed14000-0xfed19fff flags 0x1
[    0.494260] pnp 00:01: PNP0c01: calling quirk_system_pci_resources+0x0/0x15c
[    0.494260] pnp 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.494260] pnp 00:02: parse allocated resources
[    0.494260] pnp 00:02:   add dma 4 flags 0x4
[    0.494260] pnp 00:02:   add io  0x0-0xf flags 0x1
[    0.494260] pnp 00:02:   add io  0x81-0x83 flags 0x1
[    0.494260] pnp 00:02:   add io  0x87-0x87 flags 0x1
[    0.494260] pnp 00:02:   add io  0x89-0x8b flags 0x1
[    0.494260] pnp 00:02:   add io  0x8f-0x8f flags 0x1
[    0.494260] pnp 00:02:   add io  0xc0-0xdf flags 0x1
[    0.494260] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.494260] pnp 00:03: parse allocated resources
[    0.494260] pnp 00:03:   add io  0x70-0x71 flags 0x1
[    0.494260] pnp 00:03:   add irq 8 flags 0x1
[    0.494260] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.494260] pnp 00:04: parse allocated resources
[    0.494260] pnp 00:04:   add io  0x61-0x61 flags 0x1
[    0.494260] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.494260] pnp 00:05: parse allocated resources
[    0.494260] pnp 00:05:   add io  0xf0-0xff flags 0x1
[    0.494260] pnp 00:05:   add irq 13 flags 0x1
[    0.494260] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.494260] pnp 00:06: parse allocated resources
[    0.494260] pnp 00:06:   add io  0x0-0xffffffffffffffff flags 0x10000001
[    0.494260] pnp 00:06:   add io  0x0-0xffffffffffffffff flags 0x10000001
[    0.494260] pnp 00:06:   add io  0x290-0x297 flags 0x1
[    0.494260] pnp 00:06: PNP0c02: calling quirk_system_pci_resources+0x0/0x15c
[    0.494260] pnp 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.494260] pnp 00:07: parse allocated resources
[    0.494260] pnp 00:07:   add io  0x10-0x1f flags 0x1
[    0.494260] pnp 00:07:   add io  0x22-0x3f flags 0x1
[    0.494260] pnp 00:07:   add io  0x44-0x4d flags 0x1
[    0.494260] pnp 00:07:   add io  0x50-0x5f flags 0x1
[    0.494260] pnp 00:07:   add io  0x62-0x63 flags 0x1
[    0.494260] pnp 00:07:   add io  0x65-0x6f flags 0x1
[    0.494260] pnp 00:07:   add io  0x72-0x7f flags 0x1
[    0.494260] pnp 00:07:   add io  0x80-0x80 flags 0x1
[    0.494260] pnp 00:07:   add io  0x84-0x86 flags 0x1
[    0.494260] pnp 00:07:   add io  0x88-0x88 flags 0x1
[    0.494260] pnp 00:07:   add io  0x8c-0x8e flags 0x1
[    0.494260] pnp 00:07:   add io  0x90-0x9f flags 0x1
[    0.494260] pnp 00:07:   add io  0xa2-0xbf flags 0x1
[    0.494260] pnp 00:07:   add io  0xe0-0xef flags 0x1
[    0.494260] pnp 00:07:   add io  0x4d0-0x4d1 flags 0x1
[    0.494260] pnp 00:07:   add io  0x800-0x87f flags 0x1
[    0.494260] pnp 00:07:   add io  0x400-0x3ff flags 0x10000001
[    0.494260] pnp 00:07:   add io  0x480-0x4bf flags 0x1
[    0.494260] pnp 00:07:   add mem 0xfed1c000-0xfed1ffff flags 0x1
[    0.494260] pnp 00:07:   add mem 0xfed20000-0xfed3ffff flags 0x1
[    0.494260] pnp 00:07:   add mem 0xfed50000-0xfed8ffff flags 0x1
[    0.494260] pnp 00:07:   add mem 0xffa00000-0xffafffff flags 0x1
[    0.494260] pnp 00:07:   add mem 0xffb00000-0xffbfffff flags 0x1
[    0.494260] pnp 00:07:   add mem 0xffe00000-0xffefffff flags 0x1
[    0.494260] pnp 00:07:   add mem 0xfff00000-0xfffffffe flags 0x1
[    0.494260] pnp 00:07: PNP0c02: calling quirk_system_pci_resources+0x0/0x15c
[    0.494260] pnp 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.494260] pnp 00:08: parse allocated resources
[    0.494260] pnp 00:08:   add mem 0xfed00000-0xfed003ff flags 0x0
[    0.494260] pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.494260] pnp 00:09: parse allocated resources
[    0.494260] pnp 00:09:   add mem 0xfec00000-0xfec00fff flags 0x0
[    0.494260] pnp 00:09:   add mem 0xfee00000-0xfee00fff flags 0x0
[    0.494260] pnp 00:09: PNP0c02: calling quirk_system_pci_resources+0x0/0x15c
[    0.494260] pnp 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.494260] pnp 00:0a: parse allocated resources
[    0.494260] pnp 00:0a:   add io  0x60-0x60 flags 0x1
[    0.494260] pnp 00:0a:   add io  0x64-0x64 flags 0x1
[    0.494260] pnp 00:0a:   add irq 1 flags 0x1
[    0.494260] pnp 00:0a: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.494260] pnp 00:0b: parse allocated resources
[    0.494260] pnp 00:0b:   add mem 0xe0000000-0xefffffff flags 0x0
[    0.494260] pnp 00:0b: PNP0c02: calling quirk_system_pci_resources+0x0/0x15c
[    0.494260] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.494260] pnp 00:0c: parse allocated resources
[    0.494260] pnp 00:0c:   add mem 0x0-0x9ffff flags 0x1
[    0.494260] pnp 00:0c:   add mem 0xc0000-0xcffff flags 0x0
[    0.494260] pnp 00:0c:   add mem 0xe0000-0xfffff flags 0x0
[    0.494260] pnp 00:0c:   add mem 0x100000-0xcfffffff flags 0x1
[    0.494260] pnp 00:0c:   add mem 0x0-0xffffffffffffffff flags 0x10000000
[    0.494260] pnp 00:0c: PNP0c01: calling quirk_system_pci_resources+0x0/0x15c
[    0.494260] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.494580] pnp: PnP ACPI: found 13 devices
[    0.494582] ACPI: ACPI bus type pnp unregistered
[    0.498261] usbcore: registered new interface driver usbfs
[    0.498261] usbcore: registered new interface driver hub
[    0.498261] usbcore: registered new device driver usb
[    0.498261] PCI: Using ACPI for IRQ routing
[    0.517244] PCI-GART: No AMD northbridge found.
[    0.517250] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.517255] hpet0: 4 64-bit timers, 14318180 Hz
[    0.518262] ACPI: RTC can wake from S4
[    0.521171] Switched to high resolution mode on CPU 0
[    0.521836] Switched to high resolution mode on CPU 1
[    0.523590] Switched to high resolution mode on CPU 2
[    0.524768] Switched to high resolution mode on CPU 3
[    0.529149] pnp: the driver 'system' has been registered
[    0.529161] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
[    0.529164] system 00:01: driver attached
[    0.529173] system 00:06: ioport range 0x290-0x297 has been reserved
[    0.529176] system 00:06: driver attached
[    0.529182] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.529185] system 00:07: ioport range 0x800-0x87f has been reserved
[    0.529188] system 00:07: ioport range 0x480-0x4bf has been reserved
[    0.529192] system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.529196] system 00:07: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.529199] system 00:07: iomem range 0xfed50000-0xfed8ffff has been reserved
[    0.529202] system 00:07: iomem range 0xffa00000-0xffafffff has been reserved
[    0.529206] system 00:07: iomem range 0xffb00000-0xffbfffff has been reserved
[    0.529209] system 00:07: iomem range 0xffe00000-0xffefffff has been reserved
[    0.529213] system 00:07: iomem range 0xfff00000-0xfffffffe could not be reserved
[    0.529215] system 00:07: driver attached
[    0.529222] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.529226] system 00:09: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.529229] system 00:09: driver attached
[    0.529236] system 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
[    0.529239] system 00:0b: driver attached
[    0.529245] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.529249] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[    0.529252] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.529255] system 00:0c: iomem range 0x100000-0xcfffffff could not be reserved
[    0.529258] system 00:0c: driver attached
[    0.530253] PCI: Bridge: 0000:00:01.0
[    0.530253]   IO window: c000-cfff
[    0.530253]   MEM window: 0xfa000000-0xfe8fffff
[    0.530253]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[    0.530253] PCI: Bridge: 0000:00:1c.0
[    0.530253]   IO window: disabled.
[    0.530253]   MEM window: disabled.
[    0.530253]   PREFETCH window: 0x00000000eff00000-0x00000000efffffff
[    0.530253] PCI: Bridge: 0000:00:1c.4
[    0.530253]   IO window: d000-dfff
[    0.530253]   MEM window: 0xfea00000-0xfeafffff
[    0.530253]   PREFETCH window: disabled.
[    0.530253] PCI: Bridge: 0000:00:1c.5
[    0.530253]   IO window: disabled.
[    0.530253]   MEM window: 0xfe900000-0xfe9fffff
[    0.530253]   PREFETCH window: disabled.
[    0.530253] PCI: Bridge: 0000:05:02.0
[    0.530253]   IO window: disabled.
[    0.530253]   MEM window: disabled.
[    0.530253]   PREFETCH window: 0x00000000f0000000-0x00000000f7ffffff
[    0.530253] PCI: Bridge: 0000:00:1e.0
[    0.530253]   IO window: e000-efff
[    0.530253]   MEM window: 0xfeb00000-0xfebfffff
[    0.530253]   PREFETCH window: 0x00000000f0000000-0x00000000f7ffffff
[    0.530253] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.530253] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.530253] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
[    0.530253] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.530253] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 17
[    0.530253] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[    0.530253] ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 16 (level, low) -> IRQ 16
[    0.530253] PCI: Setting latency timer of device 0000:00:1c.5 to 64
[    0.530253] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.530253] NET: Registered protocol family 2
[    0.577123] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.577123] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.581992] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.581992] TCP: Hash tables configured (established 524288 bind 65536)
[    0.581992] TCP reno registered
[    0.595229] NET: Registered protocol family 1
[    0.595229] checking if image is initramfs... it is
[    1.187643] Freeing initrd memory: 8681k freed
[    1.199197] audit: initializing netlink socket (disabled)
[    1.199197] type=2000 audit(1234114909.180:1): initialized
[    1.199326] Total HugeTLB memory allocated, 0
[    1.199326] VFS: Disk quotas dquot_6.5.1
[    1.199326] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.199326] msgmni has been set to 11975
[    1.199326] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.199326] io scheduler noop registered
[    1.199326] io scheduler anticipatory registered
[    1.199326] io scheduler deadline registered
[    1.199326] io scheduler cfq registered (default)
[    1.199326] pci 0000:01:00.0: Boot video device
[    1.199326] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    1.199326] assign_interrupt_mode Found MSI capability
[    1.199326] Allocate Port Service[0000:00:01.0:pcie00]
[    1.199326] Allocate Port Service[0000:00:01.0:pcie03]
[    1.199326] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    1.199326] assign_interrupt_mode Found MSI capability
[    1.199326] Allocate Port Service[0000:00:1c.0:pcie00]
[    1.199326] Allocate Port Service[0000:00:1c.0:pcie02]
[    1.199326] Allocate Port Service[0000:00:1c.0:pcie03]
[    1.199326] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[    1.199326] assign_interrupt_mode Found MSI capability
[    1.199326] Allocate Port Service[0000:00:1c.4:pcie00]
[    1.199326] Allocate Port Service[0000:00:1c.4:pcie02]
[    1.199326] Allocate Port Service[0000:00:1c.4:pcie03]
[    1.199326] PCI: Setting latency timer of device 0000:00:1c.5 to 64
[    1.199326] assign_interrupt_mode Found MSI capability
[    1.199326] Allocate Port Service[0000:00:1c.5:pcie00]
[    1.199326] Allocate Port Service[0000:00:1c.5:pcie02]
[    1.199326] Allocate Port Service[0000:00:1c.5:pcie03]
[    1.376076] hpet_resources: 0xfed00000 is busy
[    1.376076] Linux agpgart interface v0.103
[    1.376076] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    1.376076] pnp: the driver 'serial' has been registered
[    1.376077] brd: module loaded
[    1.376077] input: Macintosh mouse button emulation as /class/input/input0
[    1.376077] pnp: the driver 'i8042 kbd' has been registered
[    1.376077] i8042 kbd 00:0a: driver attached
[    1.376077] pnp: the driver 'i8042 aux' has been registered
[    1.376077] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    1.376077] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    1.376077] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.399968] mice: PS/2 mouse device common for all mice
[    1.399968] pnp: the driver 'rtc_cmos' has been registered
[    1.399968] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.399968] rtc0: alarms up to one month, y3k
[    1.399968] rtc_cmos 00:03: driver attached
[    1.399968] cpuidle: using governor ladder
[    1.399968] cpuidle: using governor menu
[    1.399968] No iBFT detected.
[    1.399968] TCP cubic registered
[    1.399968] NET: Registered protocol family 17
[    1.399968] registered taskstats version 1
[    1.399968] rtc_cmos 00:03: setting system clock to 2009-02-08 17:41:49 UTC (1234114909)
[    1.399968] Freeing unused kernel memory: 392k freed
[    1.424678] input: AT Translated Set 2 keyboard as /class/input/input1
[    1.477565] ACPI: SSDT CFF8E0D0, 01D2 (r1    AMI   CPU1PM        1 INTL 20060113)
[    1.480491] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.480491] ACPI: SSDT CFF8E2B0, 0143 (r1    AMI   CPU2PM        1 INTL 20060113)
[    1.480491] ACPI: ACPI0007:01 is registered as cooling_device1
[    1.480491] ACPI: SSDT CFF8E400, 0143 (r1    AMI   CPU3PM        1 INTL 20060113)
[    1.480491] ACPI: ACPI0007:02 is registered as cooling_device2
[    1.480491] ACPI: SSDT CFF8E550, 0143 (r1    AMI   CPU4PM        1 INTL 20060113)
[    1.480491] ACPI: ACPI0007:03 is registered as cooling_device3
[    1.596989] USB Universal Host Controller Interface driver v3.0
[    1.596989] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
[    1.596989] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[    1.596989] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.596989] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.596989] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000b800
[    1.596989] usb usb1: configuration #1 chosen from 1 choice
[    1.596989] hub 1-0:1.0: USB hub found
[    1.596989] hub 1-0:1.0: 2 ports detected
[    1.653713] Uniform Multi-Platform E-IDE driver
[    1.653713] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    1.653713] No dock devices found.
[    1.657713] SCSI subsystem initialized
[    1.661847] libata version 3.00 loaded.
[    1.704762] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    1.704765] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.704767] usb usb1: Product: UHCI Host Controller
[    1.704769] usb usb1: Manufacturer: Linux 2.6.26-1-amd64 uhci_hcd
[    1.704770] usb usb1: SerialNumber: 0000:00:1a.0
[    1.706649] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
[    1.706649] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[    1.706649] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.706649] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    1.706649] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000b880
[    1.706649] usb usb2: configuration #1 chosen from 1 choice
[    1.706649] hub 2-0:1.0: USB hub found
[    1.706649] hub 2-0:1.0: 2 ports detected
[    1.812149] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.812153] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.812156] usb usb2: Product: UHCI Host Controller
[    1.812158] usb usb2: Manufacturer: Linux 2.6.26-1-amd64 uhci_hcd
[    1.812161] usb usb2: SerialNumber: 0000:00:1a.1
[    1.813962] ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 18 (level, low) -> IRQ 18
[    1.813962] PCI: Setting latency timer of device 0000:00:1a.2 to 64
[    1.813962] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.813962] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[    1.813962] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000bc00
[    1.813962] usb usb3: configuration #1 chosen from 1 choice
[    1.813962] hub 3-0:1.0: USB hub found
[    1.813962] hub 3-0:1.0: 2 ports detected
[    1.944886] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.944889] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.944892] usb usb3: Product: UHCI Host Controller
[    1.944894] usb usb3: Manufacturer: Linux 2.6.26-1-amd64 uhci_hcd
[    1.944896] usb usb3: SerialNumber: 0000:00:1a.2
[    1.949961] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
[    1.949961] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[    1.949961] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.949961] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 4
[    1.957946] ehci_hcd 0000:00:1a.7: debug port 1
[    1.957946] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
[    1.957946] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf9fffc00
[    1.969966] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    1.969966] usb usb4: configuration #1 chosen from 1 choice
[    1.969966] hub 4-0:1.0: USB hub found
[    1.969966] hub 4-0:1.0: 6 ports detected
[    2.120490] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    2.120494] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.120497] usb usb4: Product: EHCI Host Controller
[    2.120499] usb usb4: Manufacturer: Linux 2.6.26-1-amd64 ehci_hcd
[    2.120501] usb usb4: SerialNumber: 0000:00:1a.7
[    2.122100] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[    2.122100] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    2.122100] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.122100] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    2.122100] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b080
[    2.122100] usb usb5: configuration #1 chosen from 1 choice
[    2.122100] hub 5-0:1.0: USB hub found
[    2.122100] hub 5-0:1.0: 2 ports detected
[    2.248513] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.248516] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.248519] usb usb5: Product: UHCI Host Controller
[    2.248521] usb usb5: Manufacturer: Linux 2.6.26-1-amd64 uhci_hcd
[    2.248524] usb usb5: SerialNumber: 0000:00:1d.0
[    2.250070] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[    2.250070] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    2.250070] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.250070] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    2.250070] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b400
[    2.250070] usb usb6: configuration #1 chosen from 1 choice
[    2.250070] hub 6-0:1.0: USB hub found
[    2.250070] hub 6-0:1.0: 2 ports detected
[    2.378035] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.378039] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.378042] usb usb6: Product: UHCI Host Controller
[    2.378044] usb usb6: Manufacturer: Linux 2.6.26-1-amd64 uhci_hcd
[    2.378046] usb usb6: SerialNumber: 0000:00:1d.1
[    2.379606] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    2.379606] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    2.379606] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.379606] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    2.379606] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b480
[    2.379606] usb usb7: configuration #1 chosen from 1 choice
[    2.379606] hub 7-0:1.0: USB hub found
[    2.379606] hub 7-0:1.0: 2 ports detected
[    2.515666] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    2.515669] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.515672] usb usb7: Product: UHCI Host Controller
[    2.515674] usb usb7: Manufacturer: Linux 2.6.26-1-amd64 uhci_hcd
[    2.515677] usb usb7: SerialNumber: 0000:00:1d.2
[    2.515688] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[    2.515688] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    2.515688] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.515688] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
[    2.531823] ehci_hcd 0000:00:1d.7: debug port 1
[    2.531823] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    2.531823] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf9fff800
[    2.567648] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.567648] usb usb8: configuration #1 chosen from 1 choice
[    2.567648] hub 8-0:1.0: USB hub found
[    2.567648] hub 8-0:1.0: 6 ports detected
[    2.671676] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
[    2.671679] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.671682] usb usb8: Product: EHCI Host Controller
[    2.671684] usb usb8: Manufacturer: Linux 2.6.26-1-amd64 ehci_hcd
[    2.671687] usb usb8: SerialNumber: 0000:00:1d.7
[    2.671863] ahci 0000:00:1f.2: version 3.0
[    2.671863] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 22 (level, low) -> IRQ 22
[    2.834274] usb 2-1: new low speed USB device using uhci_hcd and address 2
[    2.968763] usb 2-1: configuration #1 chosen from 1 choice
[    3.234256] usb 2-1: New USB device found, idVendor=051d, idProduct=0002
[    3.234256] usb 2-1: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[    3.234256] usb 2-1: Product: Smart-UPS 1500 FW:601.3.D USB FW:8.1
[    3.234256] usb 2-1: Manufacturer: American Power Conversion
[    3.234256] usb 2-1: SerialNumber: AS0719222574
[    3.897902] usbcore: registered new interface driver hiddev
[    3.907306] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    3.907311] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part 
[    3.907316] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    3.911275] scsi0 : ahci
[    3.911275] scsi1 : ahci
[    3.911275] scsi2 : ahci
[    3.911275] scsi3 : ahci
[    3.911275] scsi4 : ahci
[    3.911275] scsi5 : ahci
[    3.911275] ata1: SATA max UDMA/133 abar m2048@0xf9ffe800 port 0xf9ffe900 irq 1275
[    3.911275] ata2: SATA max UDMA/133 abar m2048@0xf9ffe800 port 0xf9ffe980 irq 1275
[    3.911275] ata3: DUMMY
[    3.911275] ata4: DUMMY
[    3.911275] ata5: SATA max UDMA/133 abar m2048@0xf9ffe800 port 0xf9ffeb00 irq 1275
[    3.911275] ata6: SATA max UDMA/133 abar m2048@0xf9ffe800 port 0xf9ffeb80 irq 1275
[    4.522988] usb 7-1: new low speed USB device using uhci_hcd and address 2
[    4.837395] usb 7-1: configuration #1 chosen from 1 choice
[    4.837395] usb 7-1: New USB device found, idVendor=15c2, idProduct=ffdc
[    4.837395] usb 7-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.029494] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.041541] ata1.00: HPA detected: current 976771055, native 976773168
[    5.041541] ata1.00: ATA-7: WDC WD5000AAKS-00TMA0, 12.01C01, max UDMA/133
[    5.041541] ata1.00: 976771055 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.041541] ata1.00: configured for UDMA/133
[    5.188625] usb 7-2: new low speed USB device using uhci_hcd and address 3
[    5.365313] usb 7-2: configuration #1 chosen from 1 choice
[    5.368267] usb 7-2: New USB device found, idVendor=0b38, idProduct=0010
[    5.368270] usb 7-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.871651] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.871651] ata2.00: ATA-8: WDC WD5000AAKS-00YGA0, 12.01C02, max UDMA/133
[    5.871651] ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.875683] ata2.00: configured for UDMA/133
[    6.378722] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.871651] ata5.00: ATA-8: WDC WD5000AAKS-00YGA0, 12.01C02, max UDMA/133
[    5.871651] ata5.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.391641] ata5.00: configured for UDMA/133
[    6.942956] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.947471] ata6.00: ATA-8: WDC WD5000AAKS-00YGA0, 12.01C02, max UDMA/133
[    6.947471] ata6.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.947471] ata6.00: configured for UDMA/133
[    6.947471] scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 12.0 PQ: 0 ANSI: 5
[    6.947471] scsi 1:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 12.0 PQ: 0 ANSI: 5
[    6.947471] scsi 4:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 12.0 PQ: 0 ANSI: 5
[    6.947471] scsi 5:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 12.0 PQ: 0 ANSI: 5
[    7.190467] JMB: IDE controller (0x197b:0x2363 rev 0x03) at  PCI slot 0000:03:00.1
[    7.190467] ACPI: PCI Interrupt 0000:03:00.1[B] -> GSI 17 (level, low) -> IRQ 17
[    7.190467] JMB: 100% native mode on irq 17
[    7.190467]     ide0: BM-DMA at 0xd400-0xd407
[    7.190467]     ide1: BM-DMA at 0xd408-0xd40f
[    7.190467] Probing IDE interface ide0...
[    7.339303] hiddev96hidraw0: USB HID v1.10 Device [American Power Conversion Smart-UPS 1500 FW:601.3.D USB FW:8.1] on usb-0000:00:1a.1-1
[    7.351770] input: HID 0b38:0010 as /class/input/input2
[    7.371588] input,hidraw1: USB HID v1.10 Keyboard [HID 0b38:0010] on usb-0000:00:1d.2-2
[    7.392467] input: HID 0b38:0010 as /class/input/input3
[    7.408058] input,hidraw2: USB HID v1.10 Device [HID 0b38:0010] on usb-0000:00:1d.2-2
[    7.408082] usbcore: registered new interface driver usbhid
[    7.408085] usbhid: v2.6:USB HID core driver
[    7.967911] hda: PLEXTOR DVDR PX-760A, ATAPI CD/DVD-ROM drive
[    8.303604] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    8.303673] hda: UDMA/66 mode selected
[    8.303744] Probing IDE interface ide1...
[    9.232484] ide0 at 0xdc00-0xdc07,0xd882 on irq 17
[    9.241583] ide1 at 0xd800-0xd807,0xd482 on irq 17
[    9.241583] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   10.241657] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[   10.241661] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[   10.241668] PCI: Setting latency timer of device 0000:03:00.0 to 64
[   10.245557] scsi6 : ahci
[   10.245557] scsi7 : ahci
[   10.245557] ata7: SATA max UDMA/133 abar m8192@0xfeafe000 port 0xfeafe100 irq 16
[   10.245557] ata8: SATA max UDMA/133 abar m8192@0xfeafe000 port 0xfeafe180 irq 16
[   10.906187] ata7: SATA link down (SStatus 0 SControl 300)
[   11.292125] ata8: SATA link down (SStatus 0 SControl 300)
[   11.320150] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   11.320150] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   11.320150] atl1 0000:02:00.0: version 2.1.3
[   11.904008] Driver 'sd' needs updating - please use bus_type methods
[   11.904008] sd 0:0:0:0: [sda] 976771055 512-byte hardware sectors (500107 MB)
[   11.904009] sd 0:0:0:0: [sda] Write Protect is off
[   11.904009] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   11.904009] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   11.904009] sd 0:0:0:0: [sda] 976771055 512-byte hardware sectors (500107 MB)
[   11.904009] sd 0:0:0:0: [sda] Write Protect is off
[   11.904009] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   11.904009] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   11.904009]  sda:<6>ACPI: PCI Interrupt 0000:05:03.0[A] -> GSI 16 (level, low) -> IRQ 16
[   11.918139]  sda1 sda2
[   11.918251] sd 0:0:0:0: [sda] Attached SCSI disk
[   11.918316] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   11.918329] sd 1:0:0:0: [sdb] Write Protect is off
[   11.918331] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   11.918350] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   11.918391] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   11.918402] sd 1:0:0:0: [sdb] Write Protect is off
[   11.918404] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   11.918423] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   11.918425]  sdb: sdb1 sdb2
[   11.935044] sd 1:0:0:0: [sdb] Attached SCSI disk
[   11.935096] sd 4:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
[   11.935108] sd 4:0:0:0: [sdc] Write Protect is off
[   11.935110] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   11.935129] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   11.935164] sd 4:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
[   11.935175] sd 4:0:0:0: [sdc] Write Protect is off
[   11.935177] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   11.935196] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   11.935198]  sdc: sdc1 sdc2
[   11.943259] sd 4:0:0:0: [sdc] Attached SCSI disk
[   11.943259] sd 5:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
[   11.943259] sd 5:0:0:0: [sdd] Write Protect is off
[   11.943259] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[   11.943259] sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   11.943259] sd 5:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
[   11.943259] sd 5:0:0:0: [sdd] Write Protect is off
[   11.943259] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[   11.943259] sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   11.943259]  sdd: sdd1 sdd2
[   11.960964] sd 5:0:0:0: [sdd] Attached SCSI disk
[   11.967109] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16]  MMIO=[febff800-febfffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   11.994057] hda: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
[   11.994057] Uniform CD-ROM driver Revision: 3.20
[   12.132930] md: raid1 personality registered for level 1
[   12.136816] xor: automatically using best checksumming function: generic_sse
[   12.157605]    generic_sse:  8587.000 MB/sec
[   12.157605] xor: using function: generic_sse (8587.000 MB/sec)
[   12.157605] async_tx: api initialized (async)
[   12.226046] raid6: int64x1   2255 MB/s
[   12.294046] raid6: int64x2   3042 MB/s
[   12.362086] raid6: int64x4   2669 MB/s
[   12.430086] raid6: int64x8   1725 MB/s
[   12.498087] raid6: sse2x1    3823 MB/s
[   12.566087] raid6: sse2x2    4355 MB/s
[   12.634088] raid6: sse2x4    7250 MB/s
[   12.634088] raid6: using algorithm sse2x4 (7250 MB/s)
[   12.634088] md: raid6 personality registered for level 6
[   12.634088] md: raid5 personality registered for level 5
[   12.634088] md: raid4 personality registered for level 4
[   12.638108] md: md0 stopped.
[   12.647060] md: bind<sdb1>
[   12.647060] md: bind<sda1>
[   12.658281] raid1: raid set md0 active with 2 out of 2 mirrors
[   12.658281] md: md1 stopped.
[   12.707292] md: bind<sdd1>
[   12.707129] md: bind<sdc1>
[   12.716865] raid1: raid set md1 active with 2 out of 2 mirrors
[   12.716865] md: md2 stopped.
[   12.778826] md: bind<sdb2>
[   12.779362] md: bind<sdc2>
[   12.781148] md: bind<sdd2>
[   12.781148] md: bind<sda2>
[   12.789087] raid5: device sda2 operational as raid disk 0
[   12.789089] raid5: device sdd2 operational as raid disk 3
[   12.789091] raid5: device sdc2 operational as raid disk 2
[   12.789092] raid5: device sdb2 operational as raid disk 1
[   12.791697] raid5: allocated 4274kB for md2
[   12.791697] raid5: raid level 5 set md2 active with 4 out of 4 devices, algorithm 2
[   12.791697] RAID5 conf printout:
[   12.791697]  --- rd:4 wd:4
[   12.791697]  disk 0, o:1, dev:sda2
[   12.791697]  disk 1, o:1, dev:sdb2
[   12.791697]  disk 2, o:1, dev:sdc2
[   12.791697]  disk 3, o:1, dev:sdd2
[   12.903039] device-mapper: uevent: version 1.0.3
[   12.903039] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[   12.964067] PM: Starting manual resume from disk
[   13.055693] kjournald starting.  Commit interval 5 seconds
[   13.055693] EXT3-fs: mounted filesystem with ordered data mode.
[   13.286980] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d800018f90fd]
[   14.954097] udev: starting version 136
[   14.954097] udev: deprecated sysfs layout; update the kernel or disable CONFIG_SYSFS_DEPRECATED; some udev features will not work correctly
[   15.403737] input: Power Button (FF) as /class/input/input4
[   15.448661] ACPI: Power Button (FF) [PWRF]
[   15.448758] input: Power Button (CM) as /class/input/input5
[   15.515258] ACPI: Power Button (CM) [PWRB]
[   15.557826] input: PC Speaker as /class/input/input6
[   15.585410] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   15.588707] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   15.640968] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[   15.641047] iTCO_wdt: Found a ICH9 TCO device (Version=2, TCOBASE=0x0860)
[   15.641078] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   15.676124] ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 18
[   15.837745] Linux video capture interface: v2.00
[   15.918394] ivtv:  Start initialization, version 1.3.0
[   15.918394] ivtv0: Initializing card #0
[   15.918394] ivtv0: Autodetected Hauppauge card (cx23416 based)
[   15.918394] ACPI: PCI Interrupt 0000:06:08.0[A] -> GSI 18 (level, low) -> IRQ 18
[   15.970787] tveeprom 1-0050: Hauppauge model 23552, rev D492, serial# 9396298
[   15.970790] tveeprom 1-0050: tuner model is Philips FQ1236A MK4 (idx 92, type 57)
[   15.970792] tveeprom 1-0050: TV standards NTSC(M) (eeprom 0x08)
[   15.970794] tveeprom 1-0050: second tuner model is Philips TEA5768HL FM Radio (idx 101, type 62)
[   15.970796] tveeprom 1-0050: audio processor is CX25843 (idx 37)
[   15.970798] tveeprom 1-0050: decoder processor is CX25843 (idx 30)
[   15.970800] tveeprom 1-0050: has radio, has no IR receiver, has no IR transmitter
[   15.970802] ivtv0: Autodetected WinTV PVR 500 (unit #1)
[   16.025414] cx25840 1-0044: cx25843-23 found @ 0x88 (ivtv i2c driver #0)
[   16.075968] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[   16.075968] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   16.085710] tuner 1-0060: chip found @ 0xc0 (ivtv i2c driver #0)
[   16.085710] tea5767 1-0060: type set to Philips TEA5767HN FM Radio
[   16.107789] tuner 1-0043: chip found @ 0x86 (ivtv i2c driver #0)
[   16.111830] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[   16.128506] tda9887 1-0043: creating new instance
[   16.128506] tda9887 1-0043: tda988[5/6/7] found
[   16.128506] tuner 1-0061: chip found @ 0xc2 (ivtv i2c driver #0)
[   16.128506] wm8775 1-001b: chip found @ 0x36 (ivtv i2c driver #0)
[   16.154237] tuner-simple 1-0061: creating new instance
[   16.154237] tuner-simple 1-0061: type set to 57 (Philips FQ1236A MK4)
[   16.162279] ivtv0: Registered device video0 for encoder MPG (4096 kB)
[   16.162279] ivtv0: Registered device video32 for encoder YUV (2048 kB)
[   16.162279] ivtv0: Registered device vbi0 for encoder VBI (1024 kB)
[   16.162279] ivtv0: Registered device video24 for encoder PCM (320 kB)
[   16.162279] ivtv0: Registered device radio0 for encoder radio
[   16.162279] ivtv0: Initialized card #0: WinTV PVR 500 (unit #1)
[   16.162279] ivtv1: Initializing card #1
[   16.162279] ivtv1: Autodetected Hauppauge card (cx23416 based)
[   16.162279] ACPI: PCI Interrupt 0000:06:09.0[A] -> GSI 19 (level, low) -> IRQ 19
[   16.214206] tveeprom 2-0050: Hauppauge model 23552, rev D492, serial# 9396298
[   16.214206] tveeprom 2-0050: tuner model is Philips FQ1236A MK4 (idx 92, type 57)
[   16.214206] tveeprom 2-0050: TV standards NTSC(M) (eeprom 0x08)
[   16.214206] tveeprom 2-0050: second tuner model is Philips TEA5768HL FM Radio (idx 101, type 62)
[   16.214206] tveeprom 2-0050: audio processor is CX25843 (idx 37)
[   16.214206] tveeprom 2-0050: decoder processor is CX25843 (idx 30)
[   16.214206] tveeprom 2-0050: has radio, has no IR receiver, has no IR transmitter
[   16.214206] ivtv1: Correcting tveeprom data: no radio present on second unit
[   16.214206] ivtv1: Autodetected WinTV PVR 500 (unit #2)
[   16.244731] cx25840 2-0044: cx25843-23 found @ 0x88 (ivtv i2c driver #1)
[   16.254001] tuner 2-0043: chip found @ 0x86 (ivtv i2c driver #1)
[   16.254018] tda9887 2-0043: creating new instance
[   16.254020] tda9887 2-0043: tda988[5/6/7] found
[   16.257949] tuner 2-0061: chip found @ 0xc2 (ivtv i2c driver #1)
[   16.257969] wm8775 2-001b: chip found @ 0x36 (ivtv i2c driver #1)
[   16.266692] tuner-simple 2-0061: creating new instance
[   16.266694] tuner-simple 2-0061: type set to 57 (Philips FQ1236A MK4)
[   16.276481] ivtv1: Registered device video1 for encoder MPG (4096 kB)
[   16.276508] ivtv1: Registered device video33 for encoder YUV (2048 kB)
[   16.276525] ivtv1: Registered device vbi1 for encoder VBI (1024 kB)
[   16.276542] ivtv1: Registered device video25 for encoder PCM (320 kB)
[   16.276544] ivtv1: Initialized card #1: WinTV PVR 500 (unit #2)
[   16.276570] ivtv:  End initialization
[  297.202646] EXT3 FS on md0, internal journal
[  297.938039] loop: module loaded
[  298.001375] w83627ehf: Found W83627DHG chip at 0x290
[  298.020007] coretemp coretemp.0: Using relative temperature scale!
[  298.020045] coretemp coretemp.1: Using relative temperature scale!
[  298.020079] coretemp coretemp.2: Using relative temperature scale!
[  298.020110] coretemp coretemp.3: Using relative temperature scale!
[ 4599.205244] fuse init (API version 7.9)
[ 4599.623123] kjournald starting.  Commit interval 5 seconds
[ 4599.652504] EXT3 FS on md1, internal journal
[ 4599.652504] EXT3-fs: mounted filesystem with ordered data mode.
[ 4599.749170] kjournald starting.  Commit interval 5 seconds
[ 4599.782877] EXT3 FS on dm-1, internal journal
[ 4599.782877] EXT3-fs: mounted filesystem with ordered data mode.
[ 4600.001137] kjournald2 starting.  Commit interval 5 seconds
[ 4600.029133] EXT4 FS on dm-2, internal journal
[ 4600.029133] EXT4-fs: mounted filesystem with ordered data mode.
[ 4600.029133] EXT4-fs: file extents enabled
[ 4600.033741] EXT4-fs: mballoc enabled
[ 4600.152047] Adding 6291448k swap on /dev/mapper/MainVG-Swap.  Priority:-1 extents:1 across:6291448k
[ 4611.159518] atl1 0000:02:00.0: eth0 link is up 100 Mbps full duplex
[ 4611.159518] atl1 0000:02:00.0: eth0 link is up 1000 Mbps full duplex
[ 4612.636342] NET: Registered protocol family 10
[ 4612.636342] lo: Disabled Privacy Extensions
[ 4613.573786] RPC: Registered udp transport module.
[ 4613.573786] RPC: Registered tcp transport module.
[ 4613.757806] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[ 4614.522350] ttyS0: LSR safety check engaged!
[ 4614.532858] ttyS0: LSR safety check engaged!

So anything else I can provide?

-- 
Len Sorensen
