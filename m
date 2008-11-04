Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbYKDWpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbYKDWpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbYKDWpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:45:22 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:51890 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753731AbYKDWpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:45:15 -0500
Date: Tue, 4 Nov 2008 17:45:10 -0500
From: Theodore Tso <tytso@mit.edu>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: 2.6.28-rc2: REGRESSION in early boot
Message-ID: <20081104224510.GA7672@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I've opened a Kernel Bug to track this regression:

     http://bugzilla.kernel.org/show_bug.cgi?id=11951

My fileserver boots under 2.6.27, but it is failing to boot on
2.6.28-rc2.  It took me a while to bisect, so after I finished the
bisection, I retested with the latest mainline
(v2.6.28-rc3-54-g75fa677), and the problem still shows up.

Essentially, the system panics in early boot, resulting in multiple
oops.  I finally was able get the very first oops, and the image of
that oops can be found here:

http://thunk.org/tytso/2.6.27-regress/92b29b8/IMG_0331.JPG

>From the console snapshot, it looks like two CPU simultaneously
OOPS'ed with a:

BUG: unable to handle kernel NULL dereference at 00000000
BUG: unable to handle kernel NULL dereference at 00000038

On the stack is "scheduler_tick+0x83/0x15f"

When doing a bisection, the last good commit (i.e., the last one which
I can boot on my system) is git id: d6c88a50 (which preceeds 2.6.28-rc1).

The first bad git ID is:

commit d6c88a507ef0b6afdb013cba4e7804ba7324d99a
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Wed Oct 15 15:27:23 2008 +0200

    genirq: revert dynarray
    
    Revert the dynarray changes. They need more thought and polishing.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

... but in fact, the failure is different from the above messages.
The failure is also in early boot, but the oops message is quite
different:

http://thunk.org/tytso/2.6.27-regress/b9d7ccf/IMG_0322.JPG

The failure was in kmem_cache_alloc+0xab/0xc4, called by
__create_workqueue_key+0x21/0x145.

Walking forwards, the first git ID which shows the same failure as
what shows up in 2.6.28-rc2 and 2.6.28-rc3 is git ID: 92b29b8, which
apparently is a merge of the tracing-v28-for-linus branch.  Because
there were two failures back-to-back, it's possible either I or git
bisect got confused, since normally the bisect normally doesn't
terminate on a merge commit.  I'll try double-checking the two
ancestors of the merge commit by hand, but in the meantime I thought
I'd send what I have in case it rings a bell.

Again, my system is totally failing to boot since 2.6.28-rc1.  This is
a Aberdeen (white box) fileserver, with a SuperMicro X6DH8-XG2
motherboard, with two Pentium 4 Xeon 3.0GHz with hyperthreading.

I've enclosed a successful dmesg for a 2.6.27 kernel, my .config file,
my /proc/cpuinfo, my /proc/timer_list, and my bisection log.

						- Ted

--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-2.6.27"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.27-00071-gcd2e3c6 (root@closure) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #79 SMP Fri Oct 10 23:48:12 EDT 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009b400 (usable)
[    0.000000]  BIOS-e820: 000000000009b400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff70000 (usable)
[    0.000000]  BIOS-e820: 00000000cff70000 - 00000000cff78000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cff78000 - 00000000cff80000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cff80000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffffc00 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x1000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] kernel direct mapping tables up to 38000000 @ 7000-c000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] RAMDISK: 3791d000 - 37fef30f
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F6860, 0014 (r0 PTLTD )
[    0.000000] ACPI: RSDT CFF72D76, 003C (r1 PTLTD    RSDT    6040000  LTP        0)
[    0.000000] ACPI: FACP CFF77E20, 0074 (r1 INTEL  LINDHRST  6040000 PTL         3)
[    0.000000] ACPI: DSDT CFF731CC, 4C54 (r1  Intel LINDHRST  6040000 MSFT  100000E)
[    0.000000] ACPI: FACS CFF78FC0, 0040
[    0.000000] ACPI: APIC CFF77E94, 00B4 (r1 PTLTD  	 APIC    6040000  LTP        0)
[    0.000000] ACPI: BOOT CFF77F48, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
[    0.000000] ACPI: SPCR CFF77F70, 0050 (r1 PTLTD  $UCRTBL$  6040000 PTL         1)
[    0.000000] ACPI: MCFG CFF77FC0, 0040 (r1 PTLTD  	 MCFG    6040000  LTP        0)
[    0.000000] ACPI: SSDT CFF72DB2, 041A (r1  PmRef    CpuPm     3000 INTL 20030224)
[    0.000000] 3968MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 38000000
[    0.000000]   low ram: 00000000 - 38000000
[    0.000000]   bootmap 00009000 - 00010000
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 0038000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 0000c0f598]    TEXT DATA BSS ==> [0000100000 - 0000c0f598]
[    0.000000]   #4 [003791d000 - 0037fef30f]          RAMDISK ==> [003791d000 - 0037fef30f]
[    0.000000]   #5 [0000c10000 - 0000c1b000]    INIT_PG_TABLE ==> [0000c10000 - 0000c1b000]
[    0.000000]   #6 [000009b400 - 0000100000]    BIOS reserved ==> [000009b400 - 0000100000]
[    0.000000]   #7 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
[    0.000000]   #8 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 0000010000]
[    0.000000] found SMP MP-table at [c00f6800] 000f6800
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00038000
[    0.000000]   HighMem  0x00038000 -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009b
[    0.000000]     0: 0x00000100 -> 0x000cff70
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1048331
[    0.000000] free_area_init_node: node 0, pgdat c0610700, node_mem_map c1000000
[    0.000000]   DMA zone: 3939 pages, LIFO batch:0
[    0.000000]   Normal zone: 222200 pages, LIFO batch:31
[    0.000000]   HighMem zone: 805168 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 3, version 32, address 0xfec80000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec80400] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 4, version 32, address 0xfec80400, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec84000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 5, version 32, address 0xfec84000, GSI 72-95
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec84400] gsi_base[96])
[    0.000000] IOAPIC[4]: apic_id 8, version 32, address 0xfec84400, GSI 96-119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 5 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] mapped IOAPIC to ffff9000 (fec80000)
[    0.000000] mapped IOAPIC to ffff8000 (fec80400)
[    0.000000] mapped IOAPIC to ffff7000 (fec84000)
[    0.000000] mapped IOAPIC to ffff6000 (fec84400)
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at d1000000 (gap: d0000000:10000000)
[    0.000000] PERCPU: Allocating 1221020 bytes of per cpu data
[    0.000000] NR_CPUS: 8, nr_cpu_ids: 4, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1031307
[    0.000000] Kernel command line: root=UUID=051dd1fd-28e9-4b92-b970-03406cf78bf3 ro quiet splash
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c07b7000 soft=c07af000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] TSC: PIT calibration confirmed by PMTIMER.
[    0.000000] TSC: using PIT calibration value
[    0.000000] Detected 2992.458 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        8191
[    0.003333] ... CLASSHASH_SIZE:           4096
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.003333] ... MAX_LOCKDEP_CHAINS:      16384
[    0.003333] ... CHAINHASH_SIZE:          8192
[    0.003333]  memory used by lock dependency info: 2463 kB
[    0.003333]  per task-struct memory footprint: 1920 bytes
[    0.003333] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.003333] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.003333] Memory: 4100120k/4980736k available (3515k kernel code, 92272k reserved, 1753k data, 1544k init, 3276224k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfff50000 - 0xfffff000   ( 700 kB)
[    0.003333]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.003333]     vmalloc : 0xf8800000 - 0xff9fe000   ( 113 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.003333]       .init : 0xc062a000 - 0xc07ac000   (1544 kB)
[    0.003333]       .data : 0xc046ef43 - 0xc0625700   (1753 kB)
[    0.003333]       .text : 0xc0100000 - 0xc046ef43   (3515 kB)
[    0.003333] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.003375] Calibrating delay loop (skipped), value calculated using timer frequency.. 5987.28 BogoMIPS (lpj=9974860)
[    0.003420] Security Framework initialized
[    0.003429] SELinux:  Disabled at boot.
[    0.003486] Mount-cache hash table entries: 512
[    0.005095] Initializing cgroup subsys debug
[    0.005100] Initializing cgroup subsys ns
[    0.005105] Initializing cgroup subsys cpuacct
[    0.005110] Initializing cgroup subsys devices
[    0.005145] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.005150] CPU: L2 cache: 2048K
[    0.005154] CPU: Physical Processor ID: 0
[    0.005159] Intel machine check architecture supported.
[    0.005167] Intel machine check reporting enabled on CPU#0.
[    0.005172] CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.005176] using mwait in idle threads.
[    0.005199] Checking 'hlt' instruction... OK.
[    0.018746] ACPI: Core revision 20080609
[    0.033188] ENABLING IO-APIC IRQs
[    0.033331] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.066479] CPU0: Intel(R) Xeon(TM) CPU 3.00GHz stepping 03
[    0.066662] lockdep: fixing up alternatives.
[    0.066662] CPU 1 irqstacks, hard=c07b8000 soft=c07b0000
[    0.066662] Booting processor 1/6 ip 6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 5987.03 BogoMIPS (lpj=9974450)
[    0.003333] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 3
[    0.003333] Intel machine check architecture supported.
[    0.003333] Intel machine check reporting enabled on CPU#1.
[    0.003333] CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.158063] CPU1: Intel(R) Xeon(TM) CPU 3.00GHz stepping 03
[    0.158079] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.160310] lockdep: fixing up alternatives.
[    0.160347] CPU 2 irqstacks, hard=c07b9000 soft=c07b1000
[    0.160352] Booting processor 2/1 ip 6000
[    0.003333] Initializing CPU#2
[    0.003333] Calibrating delay using timer specific routine.. 5987.97 BogoMIPS (lpj=9974352)
[    0.003333] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] Intel machine check architecture supported.
[    0.003333] Intel machine check reporting enabled on CPU#2.
[    0.003333] CPU2: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.254801] CPU2: Intel(R) Xeon(TM) CPU 3.00GHz stepping 03
[    0.254834] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.256991] lockdep: fixing up alternatives.
[    0.257025] CPU 3 irqstacks, hard=c07ba000 soft=c07b2000
[    0.257030] Booting processor 3/7 ip 6000
[    0.003333] Initializing CPU#3
[    0.003333] Calibrating delay using timer specific routine.. 5987.02 BogoMIPS (lpj=9974447)
[    0.003333] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 3
[    0.003333] Intel machine check architecture supported.
[    0.003333] Intel machine check reporting enabled on CPU#3.
[    0.003333] CPU3: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.351340] CPU3: Intel(R) Xeon(TM) CPU 3.00GHz stepping 03
[    0.351372] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.353339] Brought up 4 CPUs
[    0.353345] Total of 4 processors activated (23948.31 BogoMIPS).
[    0.353463] CPU0 attaching sched-domain:
[    0.353469]  domain 0: span 0,2 level SIBLING
[    0.353473]   groups: 0 2
[    0.353481]   domain 1: span 0-3 level CPU
[    0.353485]    groups: 0,2 1,3
[    0.353523] CPU1 attaching sched-domain:
[    0.353527]  domain 0: span 1,3 level SIBLING
[    0.353531]   groups: 1 3
[    0.353537]   domain 1: span 0-3 level CPU
[    0.353541]    groups: 1,3 0,2
[    0.353555] CPU2 attaching sched-domain:
[    0.353558]  domain 0: span 0,2 level SIBLING
[    0.353562]   groups: 2 0
[    0.353569]   domain 1: span 0-3 level CPU
[    0.353572]    groups: 0,2 1,3
[    0.353585] CPU3 attaching sched-domain:
[    0.353588]  domain 0: span 1,3 level SIBLING
[    0.353592]   groups: 3 1
[    0.353599]   domain 1: span 0-3 level CPU
[    0.353603]    groups: 1,3 0,2
[    0.354046] khelper used greatest stack depth: 2828 bytes left
[    0.356960] net_namespace: 896 bytes
[    0.357010] Booting paravirtualized kernel on bare hardware
[    0.357772] NET: Registered protocol family 16
[    0.360812] No dock devices found.
[    0.363721] EISA bus registered
[    0.363721] ACPI: bus type pci registered
[    0.363721] PCI: Found Intel Corporation E7520 Memory Controller Hub with MMCONFIG support.
[    0.363721] PCI: Using MMCONFIG for extended config space
[    0.363721] PCI: Using configuration type 1 for base access
[    0.379706] ACPI: EC: Look up EC in DSDT
[    0.393316] ACPI: Interpreter enabled
[    0.393325] ACPI: (supports S0 S1 S4 S5)
[    0.393452] ACPI: Using IOAPIC for interrupt routing
[    0.410443] ACPI: Device [PRT] status [0000000c]: functional but not present; setting present
[    0.418200] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.420307] PCI: 0000:00:01.0 reg 10 32bit mmio: [dd000000, dd000fff]
[    0.420580] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.420600] pci 0000:00:02.0: PME# disabled
[    0.420728] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.420743] pci 0000:00:04.0: PME# disabled
[    0.420870] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.420886] pci 0000:00:06.0: PME# disabled
[    0.421031] PCI: 0000:00:1d.0 reg 20 io port: [1400, 141f]
[    0.421155] PCI: 0000:00:1d.1 reg 20 io port: [1420, 143f]
[    0.421278] PCI: 0000:00:1d.2 reg 20 io port: [1440, 145f]
[    0.421400] PCI: 0000:00:1d.3 reg 20 io port: [1460, 147f]
[    0.421542] PCI: 0000:00:1d.7 reg 10 32bit mmio: [dd001000, dd0013ff]
[    0.421687] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.421705] pci 0000:00:1d.7: PME# disabled
[    0.421894] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.421915] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
[    0.421932] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH4 GPIO
[    0.421982] PCI: 0000:00:1f.1 reg 10 io port: [0, 7]
[    0.422002] PCI: 0000:00:1f.1 reg 14 io port: [0, 3]
[    0.422022] PCI: 0000:00:1f.1 reg 18 io port: [0, 7]
[    0.422041] PCI: 0000:00:1f.1 reg 1c io port: [0, 3]
[    0.422061] PCI: 0000:00:1f.1 reg 20 io port: [14a0, 14af]
[    0.422081] PCI: 0000:00:1f.1 reg 24 32bit mmio: [0, 3ff]
[    0.422198] PCI: 0000:00:1f.3 reg 20 io port: [1100, 111f]
[    0.422362] pci 0000:01:00.0: PXH quirk detected; SHPC device MSI disabled
[    0.422453] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.422465] pci 0000:01:00.0: PME# disabled
[    0.422517] PCI: 0000:01:00.1 reg 10 32bit mmio: [dd100000, dd100fff]
[    0.422695] pci 0000:01:00.2: PXH quirk detected; SHPC device MSI disabled
[    0.422784] pci 0000:01:00.2: PME# supported from D0 D3hot D3cold
[    0.422796] pci 0000:01:00.2: PME# disabled
[    0.422847] PCI: 0000:01:00.3 reg 10 32bit mmio: [dd101000, dd101fff]
[    0.423051] PCI: bridge 0000:00:02.0 io port: [2000, 3fff]
[    0.423066] PCI: bridge 0000:00:02.0 32bit mmio: [dd100000, dd3fffff]
[    0.423195] PCI: 0000:02:03.0 reg 10 io port: [2000, 20ff]
[    0.423226] PCI: 0000:02:03.0 reg 14 64bit mmio: [dd210000, dd21ffff]
[    0.423258] PCI: 0000:02:03.0 reg 1c 64bit mmio: [dd200000, dd20ffff]
[    0.423290] PCI: 0000:02:03.0 reg 30 32bit mmio: [0, fffff]
[    0.423350] pci 0000:02:03.0: supports D1
[    0.423357] pci 0000:02:03.0: supports D2
[    0.423454] PCI: 0000:02:03.1 reg 10 io port: [2400, 24ff]
[    0.423484] PCI: 0000:02:03.1 reg 14 64bit mmio: [dd230000, dd23ffff]
[    0.423513] PCI: 0000:02:03.1 reg 1c 64bit mmio: [dd220000, dd22ffff]
[    0.423543] PCI: 0000:02:03.1 reg 30 32bit mmio: [0, fffff]
[    0.423590] pci 0000:02:03.1: supports D1
[    0.423596] pci 0000:02:03.1: supports D2
[    0.423698] PCI: bridge 0000:01:00.0 io port: [2000, 2fff]
[    0.423711] PCI: bridge 0000:01:00.0 32bit mmio: [dd200000, dd2fffff]
[    0.423843] PCI: 0000:03:02.0 reg 10 64bit mmio: [dd300000, dd31ffff]
[    0.423884] PCI: 0000:03:02.0 reg 20 io port: [3000, 303f]
[    0.423952] pci 0000:03:02.0: PME# supported from D0 D3hot D3cold
[    0.423964] pci 0000:03:02.0: PME# disabled
[    0.424064] PCI: 0000:03:02.1 reg 10 64bit mmio: [dd320000, dd33ffff]
[    0.424105] PCI: 0000:03:02.1 reg 20 io port: [3040, 307f]
[    0.424172] pci 0000:03:02.1: PME# supported from D0 D3hot D3cold
[    0.424186] pci 0000:03:02.1: PME# disabled
[    0.424289] PCI: bridge 0000:01:00.2 io port: [3000, 3fff]
[    0.424303] PCI: bridge 0000:01:00.2 32bit mmio: [dd300000, dd3fffff]
[    0.424553] pci 0000:05:00.0: PXH quirk detected; SHPC device MSI disabled
[    0.424642] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.424656] pci 0000:05:00.0: PME# disabled
[    0.424707] PCI: 0000:05:00.1 reg 10 32bit mmio: [dd400000, dd400fff]
[    0.424890] pci 0000:05:00.2: PXH quirk detected; SHPC device MSI disabled
[    0.424981] pci 0000:05:00.2: PME# supported from D0 D3hot D3cold
[    0.424993] pci 0000:05:00.2: PME# disabled
[    0.425043] PCI: 0000:05:00.3 reg 10 32bit mmio: [dd401000, dd401fff]
[    0.425247] PCI: bridge 0000:00:06.0 32bit mmio: [dd400000, dd5fffff]
[    0.425264] PCI: bridge 0000:00:06.0 64bit mmio pref: [df400000, df7fffff]
[    0.425520] pci 0000:07:01.0: supports D1
[    0.425614] PCI: bridge 0000:05:00.2 32bit mmio: [dd500000, dd5fffff]
[    0.425634] PCI: bridge 0000:05:00.2 64bit mmio pref: [df400000, df7fffff]
[    0.425801] PCI: 0000:08:0e.0 reg 10 32bit mmio: [dd500000, dd500fff]
[    0.425836] PCI: 0000:08:0e.0 reg 18 32bit mmio: [df400000, df7fffff]
[    0.425896] PCI: 0000:08:0e.0 reg 30 32bit mmio: [0, ffff]
[    0.425950] pci 0000:08:0e.0: supports D1
[    0.426023] PCI: bridge 0000:07:01.0 32bit mmio: [dd500000, dd5fffff]
[    0.426044] PCI: bridge 0000:07:01.0 64bit mmio pref: [df400000, df7fffff]
[    0.426172] PCI: 0000:09:01.0 reg 10 32bit mmio: [de000000, deffffff]
[    0.426193] PCI: 0000:09:01.0 reg 14 io port: [4000, 40ff]
[    0.426213] PCI: 0000:09:01.0 reg 18 32bit mmio: [dd600000, dd600fff]
[    0.426267] PCI: 0000:09:01.0 reg 30 32bit mmio: [0, 1ffff]
[    0.426305] pci 0000:09:01.0: supports D1
[    0.426312] pci 0000:09:01.0: supports D2
[    0.426401] pci 0000:00:1e.0: transparent bridge
[    0.426414] PCI: bridge 0000:00:1e.0 io port: [4000, 4fff]
[    0.426429] PCI: bridge 0000:00:1e.0 32bit mmio: [dd600000, deffffff]
[    0.426490] bus 00 -> node 0
[    0.426515] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.428268] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.428745] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0.PXH0._PRT]
[    0.429558] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0.PXH1._PRT]
[    0.430166] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEY0._PRT]
[    0.430641] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEZ0._PRT]
[    0.431115] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEZ0.PXH0._PRT]
[    0.431600] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEZ0.PXH1._PRT]
[    0.432126] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.457313] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.457684] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.458045] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 14 15)
[    0.460333] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.460693] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.461058] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 11 14 15) *0, disabled.
[    0.461421] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.461808] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 *10 11 14 15)
[    0.463313] ACPI: WMI: Mapper loaded
[    0.463326] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.463387] pnp: PnP ACPI init
[    0.463506] ACPI: bus type pnp registered
[    0.477450] pnp: PnP ACPI: found 13 devices
[    0.477450] ACPI: ACPI bus type pnp unregistered
[    0.477450] PnPBIOS: Disabled by ACPI PNP
[    0.477450] SCSI subsystem initialized
[    0.477450] libata version 3.00 loaded.
[    0.480203] PCI: Using ACPI for IRQ routing
[    0.490035] NET: Registered protocol family 8
[    0.490047] NET: Registered protocol family 20
[    0.493569] hpet clockevent registered
[    0.493585] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.493599] hpet0: 3 64-bit timers, 14318180 Hz
[    0.504007] tracer: 772 pages allocated for 65536 entries of 48 bytes
[    0.504014]    actual entries 65620
[    0.508279] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.508294] system 00:01: ioport range 0x800-0x8df has been reserved
[    0.508303] system 00:01: ioport range 0x1000-0x107f has been reserved
[    0.508312] system 00:01: ioport range 0x1180-0x11bf has been reserved
[    0.508321] system 00:01: ioport range 0xca2-0xca3 has been reserved
[    0.508330] system 00:01: ioport range 0xca8-0xcaf has been reserved
[    0.508339] system 00:01: ioport range 0x900-0x90f has been reserved
[    0.508348] system 00:01: ioport range 0xfe00-0xfe00 has been reserved
[    0.508359] system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
[    0.547796] pci 0000:01:00.0: PCI bridge, secondary bus 0000:02
[    0.547810] pci 0000:01:00.0:   IO window: 0x2000-0x2fff
[    0.547828] pci 0000:01:00.0:   MEM window: 0xdd200000-0xdd2fffff
[    0.547843] pci 0000:01:00.0:   PREFETCH window: 0x000000d1000000-0x000000d11fffff
[    0.547866] pci 0000:01:00.2: PCI bridge, secondary bus 0000:03
[    0.547878] pci 0000:01:00.2:   IO window: 0x3000-0x3fff
[    0.547894] pci 0000:01:00.2:   MEM window: 0xdd300000-0xdd3fffff
[    0.547908] pci 0000:01:00.2:   PREFETCH window: disabled
[    0.547926] pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
[    0.547938] pci 0000:00:02.0:   IO window: 0x2000-0x3fff
[    0.547954] pci 0000:00:02.0:   MEM window: 0xdd100000-0xdd3fffff
[    0.547968] pci 0000:00:02.0:   PREFETCH window: 0x000000d1000000-0x000000d11fffff
[    0.547989] pci 0000:00:04.0: PCI bridge, secondary bus 0000:04
[    0.547998] pci 0000:00:04.0:   IO window: disabled
[    0.548013] pci 0000:00:04.0:   MEM window: disabled
[    0.548026] pci 0000:00:04.0:   PREFETCH window: disabled
[    0.548050] pci 0000:05:00.0: PCI bridge, secondary bus 0000:06
[    0.548059] pci 0000:05:00.0:   IO window: disabled
[    0.548074] pci 0000:05:00.0:   MEM window: disabled
[    0.548087] pci 0000:05:00.0:   PREFETCH window: disabled
[    0.548109] pci 0000:07:01.0: PCI bridge, secondary bus 0000:08
[    0.548118] pci 0000:07:01.0:   IO window: disabled
[    0.548134] pci 0000:07:01.0:   MEM window: 0xdd500000-0xdd5fffff
[    0.548149] pci 0000:07:01.0:   PREFETCH window: 0x000000df400000-0x000000df7fffff
[    0.548170] pci 0000:05:00.2: PCI bridge, secondary bus 0000:07
[    0.548179] pci 0000:05:00.2:   IO window: disabled
[    0.548195] pci 0000:05:00.2:   MEM window: 0xdd500000-0xdd5fffff
[    0.548209] pci 0000:05:00.2:   PREFETCH window: 0x000000df400000-0x000000df7fffff
[    0.548230] pci 0000:00:06.0: PCI bridge, secondary bus 0000:05
[    0.548238] pci 0000:00:06.0:   IO window: disabled
[    0.548254] pci 0000:00:06.0:   MEM window: 0xdd400000-0xdd5fffff
[    0.548268] pci 0000:00:06.0:   PREFETCH window: 0x000000df400000-0x000000df7fffff
[    0.548297] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:09
[    0.548316] pci 0000:00:1e.0:   IO window: 0x4000-0x4fff
[    0.548334] pci 0000:00:1e.0:   MEM window: 0xdd600000-0xdeffffff
[    0.548350] pci 0000:00:1e.0:   PREFETCH window: 0x000000d1200000-0x000000d12fffff
[    0.548413] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.548432] pci 0000:00:02.0: setting latency timer to 64
[    0.548461] pci 0000:01:00.0: setting latency timer to 64
[    0.548488] pci 0000:01:00.2: setting latency timer to 64
[    0.548512] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.548527] pci 0000:00:04.0: setting latency timer to 64
[    0.548550] pci 0000:00:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.548565] pci 0000:00:06.0: setting latency timer to 64
[    0.548591] pci 0000:05:00.0: setting latency timer to 64
[    0.548617] pci 0000:05:00.2: setting latency timer to 64
[    0.548653] pci 0000:00:1e.0: setting latency timer to 64
[    0.548667] bus: 00 index 0 io port: [0, ffff]
[    0.548675] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    0.548683] bus: 01 index 0 io port: [2000, 3fff]
[    0.548690] bus: 01 index 1 mmio: [dd100000, dd3fffff]
[    0.548698] bus: 01 index 2 mmio: [d1000000, d11fffff]
[    0.548706] bus: 01 index 3 mmio: [0, 0]
[    0.548712] bus: 02 index 0 io port: [2000, 2fff]
[    0.548720] bus: 02 index 1 mmio: [dd200000, dd2fffff]
[    0.548728] bus: 02 index 2 mmio: [d1000000, d11fffff]
[    0.548735] bus: 02 index 3 mmio: [0, 0]
[    0.548742] bus: 03 index 0 io port: [3000, 3fff]
[    0.548750] bus: 03 index 1 mmio: [dd300000, dd3fffff]
[    0.548758] bus: 03 index 2 mmio: [0, 0]
[    0.548764] bus: 03 index 3 mmio: [0, 0]
[    0.548771] bus: 04 index 0 mmio: [0, 0]
[    0.548777] bus: 04 index 1 mmio: [0, 0]
[    0.548784] bus: 04 index 2 mmio: [0, 0]
[    0.548790] bus: 04 index 3 mmio: [0, 0]
[    0.548797] bus: 05 index 0 mmio: [0, 0]
[    0.548803] bus: 05 index 1 mmio: [dd400000, dd5fffff]
[    0.548811] bus: 05 index 2 mmio: [df400000, df7fffff]
[    0.548819] bus: 05 index 3 mmio: [0, 0]
[    0.548826] bus: 06 index 0 mmio: [0, 0]
[    0.548832] bus: 06 index 1 mmio: [0, 0]
[    0.548839] bus: 06 index 2 mmio: [0, 0]
[    0.548845] bus: 06 index 3 mmio: [0, 0]
[    0.548852] bus: 07 index 0 mmio: [0, 0]
[    0.548858] bus: 07 index 1 mmio: [dd500000, dd5fffff]
[    0.548866] bus: 07 index 2 mmio: [df400000, df7fffff]
[    0.548874] bus: 07 index 3 mmio: [0, 0]
[    0.548880] bus: 08 index 0 mmio: [0, 0]
[    0.548887] bus: 08 index 1 mmio: [dd500000, dd5fffff]
[    0.548895] bus: 08 index 2 mmio: [df400000, df7fffff]
[    0.548903] bus: 08 index 3 mmio: [0, 0]
[    0.548910] bus: 09 index 0 io port: [4000, 4fff]
[    0.548917] bus: 09 index 1 mmio: [dd600000, deffffff]
[    0.548925] bus: 09 index 2 mmio: [d1200000, d12fffff]
[    0.548933] bus: 09 index 3 io port: [0, ffff]
[    0.548940] bus: 09 index 4 mmio: [0, ffffffffffffffff]
[    0.548974] NET: Registered protocol family 2
[    0.560652] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.562613] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.564090] TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
[    0.571311] TCP: Hash tables configured (established 131072 bind 65536)
[    0.571436] TCP reno registered
[    0.573933] NET: Registered protocol family 1
[    0.574917] checking if image is initramfs... it is
[    0.994955] Switched to high resolution mode on CPU 1
[    0.994966] Switched to high resolution mode on CPU 3
[    0.994979] Switched to high resolution mode on CPU 2
[    0.996742] Switched to high resolution mode on CPU 0
[    1.277494] Freeing initrd memory: 6984k freed
[    1.278111] Simple Boot Flag at 0x39 set to 0x1
[    1.285503] audit: initializing netlink socket (disabled)
[    1.285664] type=2000 audit(1225829865.283:1): initialized
[    1.299044] highmem bounce pool size: 64 pages
[    1.299071] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.314778] VFS: Disk quotas dquot_6.5.1
[    1.315336] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.321239] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.322945] fuse init (API version 7.9)
[    1.324235] msgmni has been set to 1624
[    1.326302] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.326391] io scheduler noop registered
[    1.326462] io scheduler cfq registered (default)
[    1.327041] pci 0000:09:01.0: Boot video device
[    1.327893] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    1.327972] pci_express 0000:00:02.0:pcie00: allocate port service
[    1.328201] pci_express 0000:00:02.0:pcie01: allocate port service
[    1.328632] pcieport-driver 0000:00:04.0: setting latency timer to 64
[    1.328707] pci_express 0000:00:04.0:pcie00: allocate port service
[    1.328931] pci_express 0000:00:04.0:pcie01: allocate port service
[    1.329336] pcieport-driver 0000:00:06.0: setting latency timer to 64
[    1.329412] pci_express 0000:00:06.0:pcie00: allocate port service
[    1.329632] pci_express 0000:00:06.0:pcie01: allocate port service
[    1.334138] aer 0000:00:02.0:pcie01: AER service couldn't init device: no _OSC support
[    1.337508] aer 0000:00:04.0:pcie01: AER service couldn't init device: no _OSC support
[    1.340906] aer 0000:00:06.0:pcie01: AER service couldn't init device: no _OSC support
[    1.342874] input: Power Button (FF) as /class/input/input0
[    1.343067] ACPI: Power Button (FF) [PWRF]
[    1.343710] input: Power Button (CM) as /class/input/input1
[    1.343722] ACPI: Power Button (CM) [PWRB]
[    1.346727] processor ACPI0007:00: registered as cooling_device0
[    1.347486] processor ACPI0007:01: registered as cooling_device1
[    1.348257] processor ACPI0007:02: registered as cooling_device2
[    1.349036] processor ACPI0007:03: registered as cooling_device3
[    1.356288] isapnp: Scanning for PnP cards...
[    1.713568] isapnp: No Plug & Play device found
[    1.837632] Non-volatile memory driver v1.2
[    1.837640] Linux agpgart interface v0.103
[    1.837823] [drm] Initialized drm 1.1.0 20060810
[    1.837830] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    1.838291] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.838816] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.840732] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.841406] 00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.849207] brd: module loaded
[    1.852562] loop: module loaded
[    1.852614] Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
[    1.852618] Copyright (c) 1999-2006 Intel Corporation.
[    1.852778] e1000 0000:03:02.0: PCI INT A -> GSI 54 (level, low) -> IRQ 54
[    2.116809] e1000: 0000:03:02.0: e1000_probe: (PCI-X:133MHz:64-bit) 00:30:48:78:2c:7e
[    2.147202] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[    2.147263] e1000 0000:03:02.1: PCI INT B -> GSI 55 (level, low) -> IRQ 55
[    2.410091] e1000: 0000:03:02.1: e1000_probe: (PCI-X:133MHz:64-bit) 00:30:48:78:2c:7f
[    2.440473] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
[    2.440695] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    2.440700] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    2.441302] input: Macintosh mouse button emulation as /class/input/input2
[    2.441574] Driver 'sd' needs updating - please use bus_type methods
[    2.442505] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    2.445232] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.445279] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.450624] mice: PS/2 mouse device common for all mice
[    2.494473] input: AT Translated Set 2 keyboard as /class/input/input3
[    2.513945] EISA: Probing bus 0 at eisa.0
[    2.513974] Cannot allocate resource for EISA slot 1
[    2.513984] Cannot allocate resource for EISA slot 2
[    2.513990] Cannot allocate resource for EISA slot 3
[    2.513995] Cannot allocate resource for EISA slot 4
[    2.514037] EISA: Detected 0 cards.
[    2.514110] cpuidle: using governor ladder
[    2.514118] cpuidle: using governor menu
[    2.514479] Advanced Linux Sound Architecture Driver Version 1.0.17.
[    2.523751] modprobe used greatest stack depth: 2732 bytes left
[    2.524644] ALSA device list:
[    2.524648]   No soundcards found.
[    2.527145] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.527310] TCP cubic registered
[    2.528426] RPC: Registered udp transport module.
[    2.528432] RPC: Registered tcp transport module.
[    2.528946] Using IPI No-Shortcut mode
[    2.531632] Freeing unused kernel memory: 1544k freed
[    2.531770] Write protecting the kernel read-only data: 1496k
[    2.642588] exe used greatest stack depth: 2716 bytes left
[    2.863994] consolechars used greatest stack depth: 2668 bytes left
[    2.963535] usplash[1418]: segfault at c1471 ip 00001471 sp 00000ffa error 15 in zero (deleted)[1000+9f000]
[    2.964465] usplash used greatest stack depth: 2392 bytes left
[    3.135252] input: PS/2 Generic Mouse as /class/input/input4
[    3.978827] arcmsr 0000:08:0e.0: PCI INT A -> GSI 98 (level, low) -> IRQ 64
[    3.990051] ARECA RAID ADAPTER0: FIRMWARE VERSION V1.41 2006-5-24  
[    4.003365] scsi0 : Areca SATA Host Adapter RAID Controller( RAID6 capable)
[    4.003368]  Driver Version 1.20.00.15 2008/02/27
[    4.005732] scsi 0:0:0:0: Direct-Access     ABERDEEN Boot Vol         R001 PQ: 0 ANSI: 3
[    4.006114] scsi 0:0:0:1: Direct-Access     ABERDEEN Ted Data #1      R001 PQ: 0 ANSI: 3
[    4.006431] scsi 0:0:0:2: Direct-Access     ABERDEEN Ted Data #2      R001 PQ: 0 ANSI: 3
[    4.006690] scsi 0:0:0:3: Direct-Access     ABERDEEN Ted Data #3      R001 PQ: 0 ANSI: 3
[    4.010245] scsi 0:0:16:0: Processor         Areca    RAID controller  R001 PQ: 0 ANSI: 0
[    4.011626] sd 0:0:0:0: [sda] 39061504 512-byte hardware sectors (19999 MB)
[    4.011718] sd 0:0:0:0: [sda] Write Protect is off
[    4.011723] sd 0:0:0:0: [sda] Mode Sense: cb 00 00 08
[    4.011875] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.012529] sd 0:0:0:0: [sda] 39061504 512-byte hardware sectors (19999 MB)
[    4.012617] sd 0:0:0:0: [sda] Write Protect is off
[    4.012621] sd 0:0:0:0: [sda] Mode Sense: cb 00 00 08
[    4.012771] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.012805]  sda: sda1 sda2 < sda5 >
[    4.025779] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.027707] sd 0:0:0:1: [sdb] 1464842240 512-byte hardware sectors (749999 MB)
[    4.027800] sd 0:0:0:1: [sdb] Write Protect is off
[    4.027808] sd 0:0:0:1: [sdb] Mode Sense: cb 00 00 08
[    4.027990] sd 0:0:0:1: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.028380] sd 0:0:0:1: [sdb] 1464842240 512-byte hardware sectors (749999 MB)
[    4.028467] sd 0:0:0:1: [sdb] Write Protect is off
[    4.028477] sd 0:0:0:1: [sdb] Mode Sense: cb 00 00 08
[    4.028626] sd 0:0:0:1: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.028636]  sdb: unknown partition table
[    4.029898] sd 0:0:0:1: [sdb] Attached SCSI disk
[    4.031027] sd 0:0:0:2: [sdc] 1464842240 512-byte hardware sectors (749999 MB)
[    4.031127] sd 0:0:0:2: [sdc] Write Protect is off
[    4.031135] sd 0:0:0:2: [sdc] Mode Sense: cb 00 00 08
[    4.031321] sd 0:0:0:2: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.031619] sd 0:0:0:2: [sdc] 1464842240 512-byte hardware sectors (749999 MB)
[    4.031709] sd 0:0:0:2: [sdc] Write Protect is off
[    4.031716] sd 0:0:0:2: [sdc] Mode Sense: cb 00 00 08
[    4.031877] sd 0:0:0:2: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.031887]  sdc: unknown partition table
[    4.033175] sd 0:0:0:2: [sdc] Attached SCSI disk
[    4.034301] sd 0:0:0:3: [sdd] 937496576 512-byte hardware sectors (479998 MB)
[    4.034395] sd 0:0:0:3: [sdd] Write Protect is off
[    4.034402] sd 0:0:0:3: [sdd] Mode Sense: cb 00 00 08
[    4.034561] sd 0:0:0:3: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.034812] sd 0:0:0:3: [sdd] 937496576 512-byte hardware sectors (479998 MB)
[    4.034898] sd 0:0:0:3: [sdd] Write Protect is off
[    4.034904] sd 0:0:0:3: [sdd] Mode Sense: cb 00 00 08
[    4.035045] sd 0:0:0:3: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.035054]  sdd: sdd1 sdd2
[    4.036181] sd 0:0:0:3: [sdd] Attached SCSI disk
[    4.037339] scsi_scan_0 used greatest stack depth: 2016 bytes left
[    4.087879] device-mapper: uevent: version 1.0.3
[    4.088645] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    4.145412] md: linear personality registered for level -1
[    4.158002] md: multipath personality registered for level -4
[    4.168739] md: raid0 personality registered for level 0
[    4.184540] md: raid1 personality registered for level 1
[    4.194377] xor: automatically using best checksumming function: pIII_sse
[    4.210846]    pIII_sse  :  4124.400 MB/sec
[    4.210850] xor: using function: pIII_sse (4124.400 MB/sec)
[    4.212537] async_tx: api initialized (sync-only)
[    4.280881] raid6: int32x1    706 MB/s
[    4.337561] raid6: int32x2    714 MB/s
[    4.394270] raid6: int32x4    667 MB/s
[    4.450925] raid6: int32x8    596 MB/s
[    4.507516] raid6: mmxx1     1804 MB/s
[    4.564188] raid6: mmxx2     2060 MB/s
[    4.620865] raid6: sse1x1    1088 MB/s
[    4.677543] raid6: sse1x2    1911 MB/s
[    4.734196] raid6: sse2x1    1928 MB/s
[    4.790856] raid6: sse2x2    2719 MB/s
[    4.790861] raid6: using algorithm sse2x2 (2719 MB/s)
[    4.790870] md: raid6 personality registered for level 6
[    4.790875] md: raid5 personality registered for level 5
[    4.790881] md: raid4 personality registered for level 4
[    4.834632] md: raid10 personality registered for level 10
[    5.578373] kjournald starting.  Commit interval 5 seconds
[    5.578670] EXT3-fs: mounted filesystem with ordered data mode.
[    6.415671] grep used greatest stack depth: 1964 bytes left
[    6.604761] mount used greatest stack depth: 1916 bytes left
[    9.955252] ifconfig used greatest stack depth: 1884 bytes left
[   10.118786] udevd used greatest stack depth: 1880 bytes left
[   10.494564] e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   10.920332] sshd used greatest stack depth: 1740 bytes left
[   11.046873] NET: Registered protocol family 10
[   11.051332] lo: Disabled Privacy Extensions
[   11.061239] modprobe used greatest stack depth: 1692 bytes left
[   11.961740] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   11.975142] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   12.049216] usbcore: registered new interface driver usbfs
[   12.049659] usbcore: registered new interface driver hub
[   12.107416] usbcore: registered new device driver usb
[   12.131328] USB Universal Host Controller Interface driver v3.0
[   12.131490] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   12.131516] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   12.131529] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   12.134712] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[   12.134807] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001400
[   12.135993] usb usb1: configuration #1 chosen from 1 choice
[   12.136721] hub 1-0:1.0: USB hub found
[   12.136973] hub 1-0:1.0: 2 ports detected
[   12.185853] EDAC MC: Ver: 2.1.0 Oct 10 2008
[   12.246101] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[   12.246109] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.246118] usb usb1: Product: UHCI Host Controller
[   12.246124] usb usb1: Manufacturer: Linux 2.6.27-00071-gcd2e3c6 uhci_hcd
[   12.246130] usb usb1: SerialNumber: 0000:00:1d.0
[   12.246504] EDAC e752x: tolm = d0000, remapbase = 100000, remaplimit = 12c000
[   12.247306] EDAC MC0: Giving out device to 'e752x_edac' 'E7520': DEV 0000:00:00.0
[   12.248210] EDAC PCI0: Giving out device to module 'e752x_edac' controller 'EDAC PCI controller': DEV '0000:00:00.0' (POLLED)
[   12.248295] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   12.248319] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   12.248329] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   12.248489] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[   12.248567] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001420
[   12.249012] usb usb2: configuration #1 chosen from 1 choice
[   12.249194] hub 2-0:1.0: USB hub found
[   12.249227] hub 2-0:1.0: 2 ports detected
[   12.354993] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   12.355002] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.355010] usb usb2: Product: UHCI Host Controller
[   12.355016] usb usb2: Manufacturer: Linux 2.6.27-00071-gcd2e3c6 uhci_hcd
[   12.355022] usb usb2: SerialNumber: 0000:00:1d.1
[   12.355159] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   12.355183] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   12.355194] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   12.355476] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[   12.355560] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001440
[   12.356001] usb usb3: configuration #1 chosen from 1 choice
[   12.356186] hub 3-0:1.0: USB hub found
[   12.356217] hub 3-0:1.0: 2 ports detected
[   12.461645] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   12.461654] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.461661] usb usb3: Product: UHCI Host Controller
[   12.461666] usb usb3: Manufacturer: Linux 2.6.27-00071-gcd2e3c6 uhci_hcd
[   12.461681] usb usb3: SerialNumber: 0000:00:1d.2
[   12.461840] uhci_hcd 0000:00:1d.3: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   12.461869] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[   12.461879] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   12.462116] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[   12.462167] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001460
[   12.462610] usb usb4: configuration #1 chosen from 1 choice
[   12.462795] hub 4-0:1.0: USB hub found
[   12.462828] hub 4-0:1.0: 2 ports detected
[   12.469131] intel_rng: FWH not detected
[   12.548727] iTCO_vendor_support: vendor-support=0
[   12.564804] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[   12.565278] iTCO_wdt: Found a ICH5 or ICH5R TCO device (Version=1, TCOBASE=0x1060)
[   12.565980] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   12.568643] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   12.568651] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.568657] usb usb4: Product: UHCI Host Controller
[   12.568663] usb usb4: Manufacturer: Linux 2.6.27-00071-gcd2e3c6 uhci_hcd
[   12.568669] usb usb4: SerialNumber: 0000:00:1d.3
[   12.570729] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[   12.570763] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   12.570773] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   12.571092] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[   12.575078] ehci_hcd 0000:00:1d.7: debug port 1
[   12.575101] ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
[   12.575155] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xdd001000
[   12.591324] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   12.591969] usb usb5: configuration #1 chosen from 1 choice
[   12.592283] hub 5-0:1.0: USB hub found
[   12.592559] hub 5-0:1.0: 8 ports detected
[   12.695501] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[   12.695509] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.695516] usb usb5: Product: EHCI Host Controller
[   12.695522] usb usb5: Manufacturer: Linux 2.6.27-00071-gcd2e3c6 ehci_hcd
[   12.695527] usb usb5: SerialNumber: 0000:00:1d.7
[   12.719998] ata_piix 0000:00:1f.1: version 2.12
[   12.720045] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   12.720345] ata_piix 0000:00:1f.1: setting latency timer to 64
[   12.722066] scsi1 : ata_piix
[   12.763961] scsi2 : ata_piix
[   12.766780] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x14a0 irq 14
[   12.766791] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x14a8 irq 15
[   13.081784] ata2.00: ATAPI: _NEC DVD+/-RW ND-6650A, 1.23, max UDMA/33
[   13.094916] ata2.00: configured for UDMA/33
[   13.102369] scsi 2:0:0:0: CD-ROM            _NEC     DVD+-RW ND-6650A 1.23 PQ: 0 ANSI: 5
[   13.247875] EDAC e752x: Non-Fatal Error System Bus Non DRAM Lock Error
[   13.247883] EDAC e752x: Non-Fatal Error System Bus Non DRAM Lock Error
[   13.295847] warning: `ntpd' uses 32-bit capabilities (legacy support in use)
[   13.302715] Fusion MPT base driver 3.04.07
[   13.302721] Copyright (c) 1999-2008 LSI Corporation
[   13.441769] input: PC Speaker as /class/input/input5
[   13.452401] Fusion MPT SPI Host driver 3.04.07
[   13.452646] mptspi 0000:02:03.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[   13.453225] mptbase: ioc0: Initiating bringup
[   13.559214] Uniform Multi-Platform E-IDE driver
[   13.571818] Floppy drive(s): fd0 is 1.44M
[   13.582432] parport_pc 00:07: activated
[   13.582450] parport_pc 00:07: reported by Plug and Play ACPI
[   13.582734] parport_pc 00:07: disabled
[   13.588712] FDC 0 is a National Semiconductor PC87306
[   13.752544] Driver 'sr' needs updating - please use bus_type methods
[   13.779954] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[   13.779970] Uniform CD-ROM driver Revision: 3.20
[   13.780601] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   13.838764] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   13.839030] sd 0:0:0:1: Attached scsi generic sg1 type 0
[   13.839195] sd 0:0:0:2: Attached scsi generic sg2 type 0
[   13.839433] sd 0:0:0:3: Attached scsi generic sg3 type 0
[   13.839609] scsi 0:0:16:0: Attached scsi generic sg4 type 3
[   13.839775] sr 2:0:0:0: Attached scsi generic sg5 type 5
[   13.861291] ioc0: LSI53C1030 C0: Capabilities={Initiator}
[   14.227457] scsi3 : ioc0: LSI53C1030 C0, FwRev=01030700h, Ports=1, MaxQ=222, IRQ=28
[   14.833647] mptspi 0000:02:03.1: PCI INT B -> GSI 29 (level, low) -> IRQ 29
[   14.833854] mptbase: ioc1: Initiating bringup
[   15.240027] ioc1: LSI53C1030 C0: Capabilities={Initiator}
[   15.606983] scsi4 : ioc1: LSI53C1030 C0, FwRev=01030700h, Ports=1, MaxQ=222, IRQ=29
[   17.011282] lp: driver loaded but no devices found
[   17.158531] Adding 827308k swap on /dev/sda5.  Priority:-1 extents:1 across:827308k
[   17.483978] EXT3 FS on sda1, internal journal
[   18.178666] kjournald starting.  Commit interval 5 seconds
[   18.179257] EXT3 FS on sdc, internal journal
[   18.179281] EXT3-fs: mounted filesystem with ordered data mode.
[   18.392963] ISO 9660 Extensions: Microsoft Joliet Level 3
[   18.449239] ISO 9660 Extensions: RRIP_1991A
[   20.858494] toshiba_acpi: Unknown parameter `hotkeys_over_acpi'
[   21.423356] eth0: no IPv6 routers present
[   22.355798] ppdev: user-space parallel port driver
[   22.707303] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   22.707316] apm: disabled - APM is not SMP safe.
[   26.311271] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   26.329699] NFSD: starting 90-second grace period
[   28.659672] lsb_release used greatest stack depth: 1608 bytes left
[   31.380578] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   32.103956] NET: Registered protocol family 17
[   32.361698] mtrr: type mismatch for de000000,800000 old: write-back new: write-combining
[   32.393836] mtrr: type mismatch for de000000,800000 old: write-back new: write-combining

--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-2.6.27-04409-ga1aca5d"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.27
# Sat Nov  1 14:03:53 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_MARKERS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
# CONFIG_HAVE_DMA_ATTRS is not set
CONFIG_USE_GENERIC_SMP_HELPERS=y
# CONFIG_HAVE_CLK is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_LSF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN is not set
CONFIG_VMI=y
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_32=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_X86_DS=y
CONFIG_X86_PTRACE_BTS=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_NONFATAL is not set
# CONFIG_X86_MCE_P4THERMAL is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
# CONFIG_X86_RESERVE_LOW_64K is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x100000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
# CONFIG_ACPI_BAY is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_WMI=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=2000
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_ACPI_CPUFREQ_PROC_INTF=y
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
CONFIG_EISA_VLB_PRIMING=y
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
CONFIG_EISA_NAMES=y
CONFIG_MCA=y
CONFIG_MCA_LEGACY=y
CONFIG_MCA_PROC_FS=y
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
# CONFIG_NF_CONNTRACK is not set
CONFIG_NETFILTER_XTABLES=y
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_MATCH_ADDRTYPE is not set
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_TTL is not set
CONFIG_IP_NF_FILTER=y
# CONFIG_IP_NF_TARGET_REJECT is not set
# CONFIG_IP_NF_TARGET_LOG is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
# CONFIG_IP_NF_MANGLE is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_SECURITY is not set
# CONFIG_IP_NF_ARPTABLES is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
# CONFIG_ATM_CLIP_NO_ICMP is not set
# CONFIG_ATM_LANE is not set
# CONFIG_ATM_BR2684 is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_ATM is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_INGRESS is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_PHONET is not set
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_RFKILL=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_LEDS=y
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
CONFIG_PNPBIOS_PROC_FS=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_DEV_XD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_BAY=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_IDEDISK is not set
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
# CONFIG_BLK_DEV_ALI14XX is not set
# CONFIG_BLK_DEV_DTC2278 is not set
# CONFIG_BLK_DEV_HT6560B is not set
# CONFIG_BLK_DEV_QD65XX is not set
# CONFIG_BLK_DEV_UMC8672 is not set
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1542 is not set
# CONFIG_SCSI_AHA1740 is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_IN2000 is not set
CONFIG_SCSI_ARCMSR=y
CONFIG_SCSI_ARCMSR_AER=y
CONFIG_MEGARAID_NEWGEN=y
# CONFIG_MEGARAID_MM is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_FD_MCS is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
# CONFIG_SCSI_IBMMCA is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_NCR_D700 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_NCR_Q720 is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SIM710 is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_ISAPNP is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_LEGACY is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_QDI is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_WINBOND_VLB is not set
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
# CONFIG_MII is not set
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
# CONFIG_EL1 is not set
# CONFIG_EL2 is not set
# CONFIG_ELPLUS is not set
# CONFIG_EL16 is not set
# CONFIG_EL3 is not set
# CONFIG_3C515 is not set
# CONFIG_ELMC is not set
# CONFIG_ELMC_II is not set
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
# CONFIG_LANCE is not set
CONFIG_NET_VENDOR_SMC=y
# CONFIG_WD80x3 is not set
# CONFIG_ULTRAMCA is not set
# CONFIG_ULTRA is not set
# CONFIG_ULTRA32 is not set
# CONFIG_SMC9194 is not set
# CONFIG_ENC28J60 is not set
CONFIG_NET_VENDOR_RACAL=y
# CONFIG_NI52 is not set
# CONFIG_NI65 is not set
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
# CONFIG_AT1700 is not set
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
CONFIG_NET_ISA=y
# CONFIG_E2100 is not set
# CONFIG_EWRK3 is not set
# CONFIG_EEXPRESS is not set
# CONFIG_EEXPRESS_PRO is not set
# CONFIG_HPLAN_PLUS is not set
# CONFIG_HPLAN is not set
# CONFIG_LP486E is not set
# CONFIG_ETH16I is not set
# CONFIG_NE2000 is not set
# CONFIG_ZNET is not set
# CONFIG_SEEQ8005 is not set
# CONFIG_NE2_MCA is not set
# CONFIG_IBMLANA is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_AC3200 is not set
# CONFIG_APRICOT is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_CS89x0 is not set
# CONFIG_EEPRO100 is not set
# CONFIG_E100 is not set
# CONFIG_LNE390 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_NE3210 is not set
# CONFIG_ES3210 is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
CONFIG_NET_POCKET=y
# CONFIG_ATP is not set
# CONFIG_DE600 is not set
# CONFIG_DE620 is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=y
CONFIG_E1000E=y
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_JME is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_ENIC is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_QLGE is not set
# CONFIG_SFC is not set
CONFIG_TR=y
# CONFIG_IBMTR is not set
# CONFIG_IBMOL is not set
# CONFIG_IBMLS is not set
# CONFIG_3C359 is not set
# CONFIG_TMS380TR is not set
# CONFIG_SMCTR is not set

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
# CONFIG_STRIP is not set
# CONFIG_ARLAN is not set
# CONFIG_WAVELAN is not set
CONFIG_WLAN_80211=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_HOSTAP is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
CONFIG_WAN=y
# CONFIG_HDLC is not set
# CONFIG_DLCI is not set
# CONFIG_SBNI is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
CONFIG_HIPPI=y
# CONFIG_ROADRUNNER is not set
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_NET_FC=y
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_ISDN=y
# CONFIG_MISDN is not set
# CONFIG_ISDN_I4L is not set
# CONFIG_ISDN_CAPI is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_GPIO is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_HTCPEN is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_UINPUT=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_ESPSERIAL is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_ISI is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_N_HDLC is not set
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_SX is not set
# CONFIG_RIO is not set
CONFIG_STALDRV=y
# CONFIG_STALLION is not set
# CONFIG_ISTALLION is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=48
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_FOURPORT is not set
# CONFIG_SERIAL_8250_ACCENT is not set
# CONFIG_SERIAL_8250_BOCA is not set
# CONFIG_SERIAL_8250_EXAR_ST16C554 is not set
# CONFIG_SERIAL_8250_HUB6 is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_MCA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=y
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_HELPER_AUTO is not set

#
# I2C Algorithms
#
# CONFIG_I2C_ALGOBIT is not set
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_ISA is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_SCx200_ACB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_AT24 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_TPS65010 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_LM70_LLP is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_AT25 is not set
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_UCB1400_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
CONFIG_DAB=y
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_EFI=y
# CONFIG_FB_IMAC is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
# CONFIG_FB_GEODE_GX is not set
# CONFIG_FB_GEODE_GX1 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
# CONFIG_HID is not set

#
# USB Input Devices
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
# CONFIG_USB_STORAGE is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_ATM is not set
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_AMD76X=y
CONFIG_EDAC_E7XXX=y
CONFIG_EDAC_E752X=y
# CONFIG_EDAC_I82875P is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_RTC_CLASS is not set
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=y
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
# CONFIG_SUNRPC_REGISTER_V4 is not set
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="cp437"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACING=y
# CONFIG_FTRACE is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_SAMPLES=y
# CONFIG_SAMPLE_MARKERS is not set
# CONFIG_SAMPLE_KOBJECT is not set
# CONFIG_SAMPLE_KPROBES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_4KSTACKS=y
CONFIG_DOUBLEFAULT=y
# CONFIG_MMIOTRACE is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=0
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT is not set
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_MANAGER=y
# CONFIG_CRYPTO_GF128MUL is not set
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
# CONFIG_KVM_AMD is not set
CONFIG_KVM_TRACE=y
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=cpuinfo

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 4
model name	: Intel(R) Xeon(TM) CPU 3.00GHz
stepping	: 3
cpu MHz		: 2992.458
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pebs bts pni monitor ds_cpl cid cx16 xtpr
bogomips	: 5987.28
clflush size	: 64
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 15
model		: 4
model name	: Intel(R) Xeon(TM) CPU 3.00GHz
stepping	: 3
cpu MHz		: 2992.458
cache size	: 2048 KB
physical id	: 3
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 6
initial apicid	: 6
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pebs bts pni monitor ds_cpl cid cx16 xtpr
bogomips	: 5987.03
clflush size	: 64
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 15
model		: 4
model name	: Intel(R) Xeon(TM) CPU 3.00GHz
stepping	: 3
cpu MHz		: 2992.458
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pebs bts pni monitor ds_cpl cid cx16 xtpr
bogomips	: 5987.97
clflush size	: 64
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 15
model		: 4
model name	: Intel(R) Xeon(TM) CPU 3.00GHz
stepping	: 3
cpu MHz		: 2992.458
cache size	: 2048 KB
physical id	: 3
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 7
initial apicid	: 7
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pebs bts pni monitor ds_cpl cid cx16 xtpr
bogomips	: 5987.02
clflush size	: 64
power management:


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=timer_list

Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 7635523523754 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1225829866101250164 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f38fdeac>, tick_sched_timer, S:01, tick_nohz_stop_sched_tick, swapper/0
 # expires at 7635532569780 nsecs [in 9046026 nsecs]
 #1: <f38fdeac>, hrtimer_wakeup, S:01, do_nanosleep, cron/7394
 # expires at 7635621838648 nsecs [in 98314894 nsecs]
 #2: <f38fdeac>, it_real_fn, S:01, do_setitimer, ntpd/4193
 # expires at 7636212449786 nsecs [in 688926032 nsecs]
 #3: <f38fdeac>, hrtimer_wakeup, S:01, do_nanosleep, archttp32/5514
 # expires at 7636411579189 nsecs [in 888055435 nsecs]
 #4: <f38fdeac>, it_real_fn, S:01, do_setitimer, uml_switch/6969
 # expires at 7636869844670 nsecs [in 1346320916 nsecs]
 #5: <f38fdeac>, it_real_fn, S:01, do_setitimer, exim4/5765
 # expires at 9023481056430 nsecs [in 1387957532676 nsecs]
 #6: <f38fdeac>, hrtimer_wakeup, S:01, do_nanosleep, atd/7380
 # expires at 10834362737602 nsecs [in 3198839213848 nsecs]
  .expires_next   : 7635532569780 nsecs
  .hres_active    : 1
  .nr_events      : 93621
  .nohz_mode      : 2
  .idle_tick      : 7635412569792 nsecs
  .tick_stopped   : 1
  .idle_jiffies   : 2200623
  .idle_calls     : 183577
  .idle_sleeps    : 113618
  .idle_entrytime : 7635518669382 nsecs
  .idle_waketime  : 7635518655503 nsecs
  .idle_exittime  : 7635411565339 nsecs
  .idle_sleeptime : 7567764966473 nsecs
  .last_jiffies   : 2200655
  .next_jiffies   : 2200660
  .idle_expires   : 7635532569780 nsecs
jiffies: 2200657

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1225829866101250164 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f38fdeac>, tick_sched_timer, S:01, tick_nohz_stop_sched_tick, swapper/0
 # expires at 7635989236401 nsecs [in 465712647 nsecs]
 #1: <f38fdeac>, sched_rt_period_timer, S:01, __enqueue_rt_entity, swapper/1
 # expires at 7636000000000 nsecs [in 476476246 nsecs]
 #2: <f38fdeac>, hrtimer_wakeup, S:01, do_nanosleep, archttp32/6838
 # expires at 7641223908336 nsecs [in 5700384582 nsecs]
  .expires_next   : 7635989236401 nsecs
  .hres_active    : 1
  .nr_events      : 48507
  .nohz_mode      : 2
  .idle_tick      : 7635526319780 nsecs
  .tick_stopped   : 1
  .idle_jiffies   : 2200657
  .idle_calls     : 109275
  .idle_sleeps    : 63558
  .idle_entrytime : 7635523007598 nsecs
  .idle_waketime  : 7635492572554 nsecs
  .idle_exittime  : 7635518438501 nsecs
  .idle_sleeptime : 7601302800759 nsecs
  .last_jiffies   : 2200657
  .next_jiffies   : 2200797
  .idle_expires   : 7635989236401 nsecs
jiffies: 2200657

cpu: 2
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1225829866101250164 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f38fdeac>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 7635526736446 nsecs [in 3212692 nsecs]
 #1: <f38fdeac>, it_real_fn, S:01, do_setitimer, syslogd/5245
 # expires at 7641290257240 nsecs [in 5766733486 nsecs]
  .expires_next   : 7635526736446 nsecs
  .hres_active    : 1
  .nr_events      : 83601
  .nohz_mode      : 2
  .idle_tick      : 7635520069780 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 2200655
  .idle_calls     : 167346
  .idle_sleeps    : 118263
  .idle_entrytime : 7635519297078 nsecs
  .idle_waketime  : 7635519053978 nsecs
  .idle_exittime  : 7635519907360 nsecs
  .idle_sleeptime : 7557221640754 nsecs
  .last_jiffies   : 2200655
  .next_jiffies   : 2200725
  .idle_expires   : 7635749236425 nsecs
jiffies: 2200657

cpu: 3
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1225829866101250164 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f38fdeac>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 7635523819779 nsecs [in 296025 nsecs]
  .expires_next   : 7635523819779 nsecs
  .hres_active    : 1
  .nr_events      : 54329
  .nohz_mode      : 2
  .idle_tick      : 7635367153128 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 2200610
  .idle_calls     : 113302
  .idle_sleeps    : 79670
  .idle_entrytime : 7635520534091 nsecs
  .idle_waketime  : 7635518305589 nsecs
  .idle_exittime  : 7635518346231 nsecs
  .idle_sleeptime : 7590579646482 nsecs
  .last_jiffies   : 2200656
  .next_jiffies   : 2200667
  .idle_expires   : 7635885903078 nsecs
jiffies: 2200657


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   5000
 mult:           61496114
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000000
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   672773570
 min_delta_ns:   1203
 mult:           53552628
 shift:          32
 mode:           3
 next_event:     7635532569780 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   672773570
 min_delta_ns:   1203
 mult:           53552628
 shift:          32
 mode:           3
 next_event:     7635989236401 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   672773570
 min_delta_ns:   1203
 mult:           53552628
 shift:          32
 mode:           3
 next_event:     7635526736446 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   672773570
 min_delta_ns:   1203
 mult:           53552628
 shift:          32
 mode:           3
 next_event:     7635523819779 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bisect.log"

git-bisect start
# bad: [721d5dfe7e516954c501d5e9d0dfab379cf4241a] Merge branch 'for-linus' of git://neil.brown.name/md
git-bisect bad 721d5dfe7e516954c501d5e9d0dfab379cf4241a
# good: [3fa8749e584b55f1180411ab1b51117190bac1e5] Linux 2.6.27
git-bisect good 3fa8749e584b55f1180411ab1b51117190bac1e5
# good: [dbc2bc251e06c83efcc8d39f1e7de12c2b1ff591] hwmon: (dme1737) Be less i2c-centric
git-bisect good dbc2bc251e06c83efcc8d39f1e7de12c2b1ff591
# good: [3b72e4415438538c0967fd1aee930f688ccdf6dd] Merge branch 'for-next' of git://git.o-hand.com/linux-mfd
git-bisect good 3b72e4415438538c0967fd1aee930f688ccdf6dd
# bad: [a3415dc34f4a615a904852e7a9d0cc2877007e9e] Merge branch 'linux-next' of git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6
git-bisect bad a3415dc34f4a615a904852e7a9d0cc2877007e9e
# bad: [a0bfb673dca8a2b4324fe11e678ec6d6a9ad67e0] Merge branch 'linux-next' of git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6
git-bisect bad a0bfb673dca8a2b4324fe11e678ec6d6a9ad67e0
# skip: [dd3a1db900f2a215a7d7dd71b836e149a6cf5fed] genirq: improve include files
git-bisect skip dd3a1db900f2a215a7d7dd71b836e149a6cf5fed
# good: [99ebcf8285df28f32fd2d1c19a7166e70f00309c] Merge branch 'v28-timers-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git-bisect good 99ebcf8285df28f32fd2d1c19a7166e70f00309c
# good: [9e6cad9b1230b5563c4b38335bf1ed0f73c5d74a] dyn_array: remove one panic
git-bisect good 9e6cad9b1230b5563c4b38335bf1ed0f73c5d74a
# good: [bf41a158cacba6ca5fc6407a54e7ad8ce1567e2e] ring-buffer: make reentrant
git-bisect good bf41a158cacba6ca5fc6407a54e7ad8ce1567e2e
# good: [96499871f45b9126157b1a5c512d6e30f1635225] PCI: fix pci_ioremap_bar() on s390
git-bisect good 96499871f45b9126157b1a5c512d6e30f1635225
# good: [98d9c66ab07471006fd7910cb16453581c41a3e7] tracing/fastboot: improve help text
git-bisect good 98d9c66ab07471006fd7910cb16453581c41a3e7
# good: [81608f3c254512b906ab78082ec5966b376aacd5] x86: apic - unify APIC_DIVISOR
git-bisect good 81608f3c254512b906ab78082ec5966b376aacd5
# bad: [a1aca5de08a0cb840a90fb3f729a5940f8d21185] genirq: remove artifacts from sparseirq removal
git-bisect bad a1aca5de08a0cb840a90fb3f729a5940f8d21185
# good: [c6b7674f323622d86316bf7951ad9cae1ce24642] genirq: use inline function for irq_to_desc
git-bisect good c6b7674f323622d86316bf7951ad9cae1ce24642
# good: [ee32c9732244bde4b9b59eeac2814c23e2b71f8d] genirq: remove irq_to_desc_alloc
git-bisect good ee32c9732244bde4b9b59eeac2814c23e2b71f8d
# bad: [d6c88a507ef0b6afdb013cba4e7804ba7324d99a] genirq: revert dynarray
git-bisect bad d6c88a507ef0b6afdb013cba4e7804ba7324d99a

--YZ5djTAD1cGYuMQK--
