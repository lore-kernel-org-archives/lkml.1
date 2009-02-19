Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbZBSOyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbZBSOyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 09:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZBSOx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 09:53:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51709 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbZBSOxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 09:53:51 -0500
Date: Thu, 19 Feb 2009 15:53:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mutex: enable spinning for DEBUG_MUTEX
Message-ID: <20090219145328.GA20029@elte.hu>
References: <1234815510.30178.357.camel@laptop> <20090219112212.GQ2354@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20090219112212.GQ2354@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Ingo Molnar <mingo@elte.hu> wrote:

> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Subject: mutex: enable spinning for DEBUG_MUTEX
> > From: Johannes Weiner <hannes@cmpxchg.org>
> > Date: Thu, 15 Jan 2009 15:57:38 +0100
> > 
> > Spinning with CONFIG_DEBUG_MUTEX is possible but care must 
> > be taken with the debug checks vs. racy access to the lock 
> > owner field.

This commit crashed all my testboxes - 32-bit and 64-bit ones 
alike. One (32-bit) crashlog is below - the hang seems to be 
around this place:

[   45.056031]  [<c0104d6e>] ? common_interrupt+0x2e/0x34
[   45.056031]  [<c019007b>] ? relay_open_buf+0x24d/0x34f
[   45.056031]  [<c0137084>] ? mutex_spin_on_owner+0x8e/0xc1
[   45.056031]  [<c08ae2e5>] ? mutex_lock_nested+0x5e/0x595
[   45.056031]  [<c0166965>] ? trace_hardirqs_on+0xb/0xd
[   45.056031]  [<c017cca4>] ? kprobe_target+0x0/0x15
[   45.056031]  [<c08b452c>] ? register_kprobe+0x19f/0x4f4

Config attached.

	Ingo

[    0.000000] Linux version 2.6.29-rc5-tip (mingo@venus) (gcc version 4.2.2) #208 SMP Thu Feb 19 12:56:31 CET 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] console [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] using polling idle threads.
[    0.000000] DMI 2.3 present.
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x100000
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] 135MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 00000000 - 377fe000
[    0.000000]   bootmap 00008000 - 0000ef00
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 00017e683c]    TEXT DATA BSS ==> [0000100000 - 00017e683c]
[    0.000000]   #4 [00017e7000 - 00017ef000]    INIT_PG_TABLE ==> [00017e7000 - 00017ef000]
[    0.000000]   #5 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
[    0.000000]   #7 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00f4f90] f4f90
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fff0
[    0.000000] On node 0 totalpages: 262031
[    0.000000] free_area_init_node: node 0, pgdat c0dee7e0, node_mem_map c17ef000
[    0.000000]   DMA zone: 52 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3947 pages, LIFO batch:0
[    0.000000]   Normal zone: 2834 pages used for memmap
[    0.000000]   Normal zone: 220396 pages, LIFO batch:31
[    0.000000]   HighMem zone: 442 pages used for memmap
[    0.000000]   HighMem zone: 34360 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000] MPTABLE: OEM ID: OEM00000
[    0.000000] MPTABLE: Product ID: PROD00000000
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Processor #2
[    0.000000] Processor #3
[    0.000000] Bus #0 is PCI   
[    0.000000] Bus #1 is PCI   
[    0.000000] Bus #2 is PCI   
[    0.000000] Bus #3 is PCI   
[    0.000000] Bus #4 is PCI   
[    0.000000] Bus #5 is ISA   
[    0.000000] I/O APIC #4 Version 17 at 0xFEC00000.
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 7d, APIC ID 4, APIC INT 11
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 7f, APIC ID 4, APIC INT 13
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 7e, APIC ID 4, APIC INT 17
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 7d, APIC ID 4, APIC INT 11
[    0.000000] Int: type 0, pol 3, trig 3, bus 01, IRQ 00, APIC ID 4, APIC INT 16
[    0.000000] Int: type 0, pol 3, trig 3, bus 04, IRQ 1c, APIC ID 4, APIC INT 10
[    0.000000] Int: type 0, pol 3, trig 3, bus 04, IRQ 0c, APIC ID 4, APIC INT 13
[    0.000000] Int: type 0, pol 3, trig 3, bus 04, IRQ 10, APIC ID 4, APIC INT 10
[    0.000000] Int: type 0, pol 3, trig 3, bus 03, IRQ 10, APIC ID 4, APIC INT 12
[    0.000000] Int: type 0, pol 3, trig 3, bus 03, IRQ 11, APIC ID 4, APIC INT 12
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 7c, APIC ID 4, APIC INT 10
[    0.000000] Int: type 3, pol 0, trig 0, bus 05, IRQ 00, APIC ID 4, APIC INT 00
[    0.000000] Int: type 0, pol 0, trig 0, bus 05, IRQ 01, APIC ID 4, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 05, IRQ 00, APIC ID 4, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 05, IRQ 03, APIC ID 4, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 05, IRQ 04, APIC ID 4, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 05, IRQ 06, APIC ID 4, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 05, IRQ 07, APIC ID 4, APIC INT 07
[    0.000000] Int: type 0, pol 1, trig 1, bus 05, IRQ 08, APIC ID 4, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 05, IRQ 0d, APIC ID 4, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 05, IRQ 0e, APIC ID 4, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 05, IRQ 0f, APIC ID 4, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, APIC LINT 01
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Processors: 4
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
[    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Allocating 36864 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258703
[    0.000000] Kernel command line: root=/dev/sda3 debug earlyprintk=serial,ttyS0,115200,keep initcall_debug apic=verbose ignore_loglevel highres=0 nmi_watchdog=0 nolapic_timer idle=mwait idle=poll nopat notsc pci=nomsi
[    0.000000] notsc: Kernel compiled with CONFIG_X86_TSC, cannot disable TSC completely.
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:2304 nr_irqs:440
[    0.000000] CPU 0 irqstacks, hard=c10ea000 soft=c10ca000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2378.879 MHz processor.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.000000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.000000] ... CHAINHASH_SIZE:          8192
[    0.000000]  memory used by lock dependency info: 2847 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] allocated 5242560 bytes of page_cgroup
[    0.000000] please try cgroup_disable=memory option if you don't want
[    0.000000] Memory: 1004816k/1048512k available (7895k kernel code, 42980k reserved, 7727k data, 508k init, 139208k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe19000 - 0xfffff000   (1944 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc1048000 - 0xc10c7000   ( 508 kB)
[    0.000000]       .data : 0xc08b5f52 - 0xc1041b90   (7727 kB)
[    0.000000]       .text : 0xc0100000 - 0xc08b5f52   (7895 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.004000] Calibrating delay loop... 3153.92 BogoMIPS (lpj=6307840)
[    0.112000] Security Framework initialized
[    0.116000] SELinux:  Initializing.
[    0.120000] SELinux:  Starting in enforcing mode
[    0.124000] Mount-cache hash table entries: 512
[    0.132001] Initializing cgroup subsys ns
[    0.136001] Initializing cgroup subsys cpuacct
[    0.140001] Initializing cgroup subsys memory
[    0.144001] Initializing cgroup subsys devices
[    0.148001] Initializing cgroup subsys freezer
[    0.152001] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    0.160001] CPU: L2 cache: 512K
[    0.160001] [ds] using Netburst configuration
[    0.164001] CPU: Physical Processor ID: 0
[    0.164001] CPU: Processor Core ID: 0
[    0.168001] WARNING: polling idle and HT enabled, performance may degrade.
[    0.172001] Checking 'hlt' instruction... OK.
[    0.192001] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.196001] ftrace: allocating 19906 entries in 79 pages
[    0.208001] enabled ExtINT on CPU#0
[    0.212001] ExtINT not setup in hardware but reported by MP table
[    0.216001] ENABLING IO-APIC IRQs
[    0.220001] Setting 4 in the phys_id_present_map
[    0.224001] ...changing IO-APIC physical APIC ID to 4 ... ok.
[    0.228001] init IO_APIC IRQs
[    0.228001]  4-0 (apicid-pin) not connected
[    0.236001] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.240001] IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.244001] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    0.248001] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.252001]  4-5 (apicid-pin) not connected
[    0.256001] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.260001] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.264001] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.268001]  4-9 4-10 4-11 4-12 (apicid-pin) not connected
[    0.276001] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.280001] IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.284001] IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.288001]   alloc irq_desc for 16 on cpu 0 node 0
[    0.288001]   alloc kstat_irqs on cpu 0 node 0
[    0.292001] IOAPIC[0]: Set routing entry (4-16 -> 0x49 -> IRQ 16 Mode:1 Active:1)
[    0.296001]   alloc irq_desc for 17 on cpu 0 node 0
[    0.296001]   alloc kstat_irqs on cpu 0 node 0
[    0.300001] IOAPIC[0]: Set routing entry (4-17 -> 0x51 -> IRQ 17 Mode:1 Active:1)
[    0.304001]   alloc irq_desc for 18 on cpu 0 node 0
[    0.304001]   alloc kstat_irqs on cpu 0 node 0
[    0.308001] IOAPIC[0]: Set routing entry (4-18 -> 0x59 -> IRQ 18 Mode:1 Active:1)
[    0.312001]   alloc irq_desc for 19 on cpu 0 node 0
[    0.312001]   alloc kstat_irqs on cpu 0 node 0
[    0.316001] IOAPIC[0]: Set routing entry (4-19 -> 0x61 -> IRQ 19 Mode:1 Active:1)
[    0.320001]  4-20 4-21 (apicid-pin) not connected
[    0.324001]   alloc irq_desc for 22 on cpu 0 node 0
[    0.324001]   alloc kstat_irqs on cpu 0 node 0
[    0.328001] IOAPIC[0]: Set routing entry (4-22 -> 0x69 -> IRQ 22 Mode:1 Active:1)
[    0.332001]   alloc irq_desc for 23 on cpu 0 node 0
[    0.332001]   alloc kstat_irqs on cpu 0 node 0
[    0.336001] IOAPIC[0]: Set routing entry (4-23 -> 0x71 -> IRQ 23 Mode:1 Active:1)
[    0.340001] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.384001] CPU0: Intel(R) XEON(TM) CPU 2.40GHz stepping 04
[    0.392001] Disabling APIC timer
[    0.400001] calling  migration_init+0x0/0x6e @ 1
[    0.404001] initcall migration_init+0x0/0x6e returned 1 after 0 usecs
[    0.408001] initcall migration_init+0x0/0x6e returned with error code 1 
[    0.412001] calling  spawn_ksoftirqd+0x0/0x6a @ 1
[    0.416001] initcall spawn_ksoftirqd+0x0/0x6a returned 0 after 0 usecs
[    0.420001] calling  init_call_single_data+0x0/0x6b @ 1
[    0.424001] initcall init_call_single_data+0x0/0x6b returned 0 after 0 usecs
[    0.428001] calling  spawn_softlockup_task+0x0/0x79 @ 1
[    0.432001] initcall spawn_softlockup_task+0x0/0x79 returned 0 after 0 usecs
[    0.436001] calling  relay_init+0x0/0x11 @ 1
[    0.440001] initcall relay_init+0x0/0x11 returned 0 after 0 usecs
[    0.444001] calling  tracer_alloc_buffers+0x0/0x179 @ 1
[    0.456001] initcall tracer_alloc_buffers+0x0/0x179 returned 0 after 7812 usecs
[    0.460001] calling  perf_counter_init+0x0/0x27 @ 1
[    0.464001] initcall perf_counter_init+0x0/0x27 returned 0 after 0 usecs
[    0.468001] lockdep: fixing up alternatives.
[    0.472001] CPU 1 irqstacks, hard=c10eb000 soft=c10cb000
[    0.476001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] masked ExtINT on CPU#1
[    0.004000] Calibrating delay loop... 3170.30 BogoMIPS (lpj=6340608)
[    0.004000] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    0.004000] CPU: L2 cache: 512K
[    0.004000] [ds] using Netburst configuration
[    0.004000] CPU: Physical Processor ID: 3
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] WARNING: polling idle and HT enabled, performance may degrade.
[    0.596001] CPU1: Intel(R) XEON(TM) CPU 2.40GHz stepping 04
[    0.604001] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.612001] lockdep: fixing up alternatives.
[    0.616001] CPU 2 irqstacks, hard=c10ec000 soft=c10cc000
[    0.620001] Booting processor 2 APIC 0x2 ip 0x6000
[    0.004000] Initializing CPU#2
[    0.004000] masked ExtINT on CPU#2
[    0.004000] Calibrating delay loop... 1585.15 BogoMIPS (lpj=3170304)
[    0.004000] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    0.004000] CPU: L2 cache: 512K
[    0.004000] [ds] using Netburst configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] WARNING: polling idle and HT enabled, performance may degrade.
[    0.736002] CPU2: Intel(R) XEON(TM) CPU 2.40GHz stepping 04
[    0.744002] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.752002] lockdep: fixing up alternatives.
[    0.756002] CPU 3 irqstacks, hard=c10ed000 soft=c10cd000
[    0.760002] Booting processor 3 APIC 0x3 ip 0x6000
[    0.004000] Initializing CPU#3
[    0.004000] masked ExtINT on CPU#3
[    0.004000] Calibrating delay loop... 2342.91 BogoMIPS (lpj=4685824)
[    0.004000] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    0.004000] CPU: L2 cache: 512K
[    0.004000] [ds] using Netburst configuration
[    0.004000] CPU: Physical Processor ID: 3
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] WARNING: polling idle and HT enabled, performance may degrade.
[    0.876002] CPU3: Intel(R) XEON(TM) CPU 2.40GHz stepping 04
[    0.884002] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.888002] Brought up 4 CPUs
[    0.892002] Total of 4 processors activated (10252.28 BogoMIPS).
[    0.896002] device: 'platform': device_add
[    0.900002] PM: Adding info for No Bus:platform
[    0.904002] khelper used greatest stack depth: 2696 bytes left
[    0.904002] bus: 'platform': registered
[    0.904002] Registering sysdev class 'cpu'
[    0.908002] calling  init_cpufreq_transition_notifier_list+0x0/0x18 @ 1
[    0.908002] initcall init_cpufreq_transition_notifier_list+0x0/0x18 returned 0 after 0 usecs
[    0.908002] calling  net_ns_init+0x0/0xd1 @ 1
[    0.908002] net_namespace: 1164 bytes
[    0.908002] initcall net_ns_init+0x0/0xd1 returned 0 after 0 usecs
[    0.908002] calling  cpufreq_tsc+0x0/0x41 @ 1
[    0.908002] initcall cpufreq_tsc+0x0/0x41 returned 0 after 0 usecs
[    0.908002] calling  reboot_init+0x0/0x11 @ 1
[    0.908002] initcall reboot_init+0x0/0x11 returned 0 after 0 usecs
[    0.908002] calling  print_banner+0x0/0xd @ 1
[    0.908002] Booting paravirtualized kernel on bare hardware
[    0.908002] initcall print_banner+0x0/0xd returned 0 after 0 usecs
[    0.908002] calling  init_smp_flush+0x0/0x2f @ 1
[    0.908002] initcall init_smp_flush+0x0/0x2f returned 0 after 0 usecs
[    0.908002] calling  alloc_frozen_cpus+0x0/0x12 @ 1
[    0.908002] initcall alloc_frozen_cpus+0x0/0x12 returned 0 after 0 usecs
[    0.908002] calling  sysctl_init+0x0/0x13 @ 1
[    0.908002] initcall sysctl_init+0x0/0x13 returned 0 after 0 usecs
[    0.908002] calling  ksysfs_init+0x0/0x101 @ 1
[    0.968002] initcall ksysfs_init+0x0/0x101 returned 0 after 58593 usecs
[    0.968002] calling  async_init+0x0/0x96 @ 1
[    0.968002] initcall async_init+0x0/0x96 returned 0 after 0 usecs
[    0.968002] calling  init_jiffies_clocksource+0x0/0xf @ 1
[    0.968002] initcall init_jiffies_clocksource+0x0/0xf returned 0 after 0 usecs
[    0.968002] calling  pm_init+0x0/0x37 @ 1
[    0.968002] initcall pm_init+0x0/0x37 returned 0 after 0 usecs
[    0.968002] calling  filelock_init+0x0/0x27 @ 1
[    0.968002] initcall filelock_init+0x0/0x27 returned 0 after 0 usecs
[    0.968002] calling  init_aout_binfmt+0x0/0xf @ 1
[    0.968002] initcall init_aout_binfmt+0x0/0xf returned 0 after 0 usecs
[    0.968002] calling  init_misc_binfmt+0x0/0x4f @ 1
[    0.968002] initcall init_misc_binfmt+0x0/0x4f returned 0 after 0 usecs
[    0.968002] calling  init_script_binfmt+0x0/0xf @ 1
[    0.968002] initcall init_script_binfmt+0x0/0xf returned 0 after 0 usecs
[    0.968002] calling  init_elf_binfmt+0x0/0xf @ 1
[    0.968002] initcall init_elf_binfmt+0x0/0xf returned 0 after 0 usecs
[    0.968002] calling  debugfs_init+0x0/0x5d @ 1
[    0.968002] initcall debugfs_init+0x0/0x5d returned 0 after 0 usecs
[    0.968002] calling  securityfs_init+0x0/0x5d @ 1
[    0.968002] initcall securityfs_init+0x0/0x5d returned 0 after 0 usecs
[    0.968002] calling  random32_init+0x0/0xbc @ 1
[    0.968002] initcall random32_init+0x0/0xbc returned 0 after 0 usecs
[    0.968002] calling  regulator_init+0x0/0x23 @ 1
[    0.968002] regulator: core version 0.5
[    0.968002] device class 'regulator': registering
[    1.164003] initcall regulator_init+0x0/0x23 returned 0 after 191406 usecs
[    1.168003] calling  cpufreq_core_init+0x0/0x72 @ 1
[    1.172003] initcall cpufreq_core_init+0x0/0x72 returned 0 after 0 usecs
[    1.176003] calling  virtio_init+0x0/0x30 @ 1
[    1.180003] bus: 'virtio': registered
[    1.184003] initcall virtio_init+0x0/0x30 returned 0 after 3906 usecs
[    1.188003] calling  sock_init+0x0/0x65 @ 1
[    1.192003] initcall sock_init+0x0/0x65 returned 0 after 0 usecs
[    1.196003] calling  net_inuse_init+0x0/0x2b @ 1
[    1.200003] initcall net_inuse_init+0x0/0x2b returned 0 after 0 usecs
[    1.204003] calling  netpoll_init+0x0/0x39 @ 1
[    1.208003] initcall netpoll_init+0x0/0x39 returned 0 after 0 usecs
[    1.212003] calling  netlink_proto_init+0x0/0x165 @ 1
[    1.216003] NET: Registered protocol family 16
[    1.224003] initcall netlink_proto_init+0x0/0x165 returned 0 after 7812 usecs
[    1.228003] calling  bdi_class_init+0x0/0x35 @ 1
[    1.236003] device class 'bdi': registering
[    1.240003] initcall bdi_class_init+0x0/0x35 returned 0 after 3906 usecs
[    1.244003] calling  kobject_uevent_init+0x0/0x4b @ 1
[    1.248003] initcall kobject_uevent_init+0x0/0x4b returned 0 after 0 usecs
[    1.252003] calling  gpiolib_sysfs_init+0x0/0x90 @ 1
[    1.256003] device class 'gpio': registering
[    1.260003] initcall gpiolib_sysfs_init+0x0/0x90 returned 0 after 3906 usecs
[    1.264003] calling  pcibus_class_init+0x0/0x14 @ 1
[    1.268003] device class 'pci_bus': registering
[    1.272003] initcall pcibus_class_init+0x0/0x14 returned 0 after 3906 usecs
[    1.276003] calling  pci_driver_init+0x0/0xf @ 1
[    1.280003] bus: 'pci': registered
[    1.284003] initcall pci_driver_init+0x0/0xf returned 0 after 3906 usecs
[    1.288003] calling  backlight_class_init+0x0/0x7c @ 1
[    1.292003] device class 'backlight': registering
[    1.296003] initcall backlight_class_init+0x0/0x7c returned 0 after 3906 usecs
[    1.300003] calling  video_output_class_init+0x0/0x14 @ 1
[    1.304003] device class 'video_output': registering
[    1.308003] initcall video_output_class_init+0x0/0x14 returned 0 after 3906 usecs
[    1.312003] calling  tty_class_init+0x0/0x4e @ 1
[    1.316003] device class 'tty': registering
[    1.320003] initcall tty_class_init+0x0/0x4e returned 0 after 3906 usecs
[    1.324003] calling  vtconsole_class_init+0x0/0x125 @ 1
[    1.328003] device class 'vtconsole': registering
[    1.332003] device: 'vtcon0': device_add
[    1.336003] PM: Adding info for No Bus:vtcon0
[    1.340003] initcall vtconsole_class_init+0x0/0x125 returned 0 after 11718 usecs
[    1.344003] calling  i2c_init+0x0/0x7e @ 1
[    1.348003] bus: 'i2c': registered
[    1.352003] device class 'i2c-adapter': registering
[    1.360003] bus: 'i2c': add driver dummy
[    1.364003] i2c-core: driver [dummy] registered
[    1.368003] initcall i2c_init+0x0/0x7e returned 0 after 19531 usecs
[    1.372003] calling  lguest_devices_init+0x0/0x187 @ 1
[    1.376003] initcall lguest_devices_init+0x0/0x187 returned 0 after 0 usecs
[    1.380003] calling  amd_postcore_init+0x0/0x95 @ 1
[    1.384003] initcall amd_postcore_init+0x0/0x95 returned 0 after 0 usecs
[    1.388003] calling  arch_kdebugfs_init+0x0/0x356 @ 1
[    1.392003] initcall arch_kdebugfs_init+0x0/0x356 returned 0 after 0 usecs
[    1.396003] calling  init_pit_clocksource+0x0/0xaa @ 1
[    1.400003] initcall init_pit_clocksource+0x0/0xaa returned 0 after 0 usecs
[    1.404003] calling  kdump_buf_page_init+0x0/0x6d @ 1
[    1.408003] initcall kdump_buf_page_init+0x0/0x6d returned 0 after 0 usecs
[    1.412003] calling  dmi_id_init+0x0/0x3d0 @ 1
[    1.416003] device class 'dmi': registering
[    1.424003] device: 'id': device_add
[    1.424003] PM: Adding info for No Bus:id
[    1.432003] initcall dmi_id_init+0x0/0x3d0 returned 0 after 15625 usecs
[    1.436003] calling  dma_bus_init+0x0/0x32 @ 1
[    1.440003] device class 'dma': registering
[    1.444003] initcall dma_bus_init+0x0/0x32 returned 0 after 3906 usecs
[    1.448003] calling  dma_channel_table_init+0x0/0x113 @ 1
[    1.452003] initcall dma_channel_table_init+0x0/0x113 returned 0 after 0 usecs
[    1.456003] calling  dca_init+0x0/0x19 @ 1
[    1.460003] dca service started, version 1.8
[    1.464003] device class 'dca': registering
[    1.468003] initcall dca_init+0x0/0x19 returned 0 after 7812 usecs
[    1.472003] calling  pci_arch_init+0x0/0x6a @ 1
[    1.476003] PCI: PCI BIOS revision 2.10 entry at 0xfb3b0, last bus=4
[    1.480003] PCI: Using configuration type 1 for base access
[    1.484003] initcall pci_arch_init+0x0/0x6a returned 0 after 7812 usecs
[    1.488003] calling  topology_init+0x0/0x49 @ 1
[    1.492003] Registering sys device of class 'cpu'
[    1.496003] Registering sys device 'cpu0'
[    1.500003] Registering sys device of class 'cpu'
[    1.504003] Registering sys device 'cpu1'
[    1.508003] Registering sys device of class 'cpu'
[    1.512003] Registering sys device 'cpu2'
[    1.516003] Registering sys device of class 'cpu'
[    1.520003] Registering sys device 'cpu3'
[    1.524003] initcall topology_init+0x0/0x49 returned 0 after 31250 usecs
[    1.528003] calling  mca_init+0x0/0x430 @ 1
[    1.532003] bus: 'MCA': registered
[    1.536003] initcall mca_init+0x0/0x430 returned -19 after 3906 usecs
[    1.540003] calling  param_sysfs_init+0x0/0x27c @ 1
[    1.728004] initcall param_sysfs_init+0x0/0x27c returned 0 after 179687 usecs
[    1.732004] calling  pm_sysrq_init+0x0/0x1b @ 1
[    1.736004] initcall pm_sysrq_init+0x0/0x1b returned 0 after 0 usecs
[    1.740004] calling  readahead_init+0x0/0x3d @ 1
[    1.748004] device: 'default': device_add
[    1.752004] PM: Adding info for No Bus:default
[    1.756004] initcall readahead_init+0x0/0x3d returned 0 after 7812 usecs
[    1.760004] calling  init_bio+0x0/0x101 @ 1
[    1.764004] bio: create slab <bio-0> at 0
[    1.768004] initcall init_bio+0x0/0x101 returned 0 after 3906 usecs
[    1.772004] calling  integrity_init+0x0/0x43 @ 1
[    1.776004] initcall integrity_init+0x0/0x43 returned 0 after 0 usecs
[    1.780004] calling  cryptomgr_init+0x0/0x45 @ 1
[    1.784004] initcall cryptomgr_init+0x0/0x45 returned 0 after 0 usecs
[    1.788004] calling  blk_settings_init+0x0/0x1d @ 1
[    1.792004] initcall blk_settings_init+0x0/0x1d returned 0 after 0 usecs
[    1.796004] calling  blk_ioc_init+0x0/0x24 @ 1
[    1.800004] initcall blk_ioc_init+0x0/0x24 returned 0 after 0 usecs
[    1.804004] calling  blk_softirq_init+0x0/0x6e @ 1
[    1.808004] initcall blk_softirq_init+0x0/0x6e returned 0 after 0 usecs
[    1.812004] calling  genhd_device_init+0x0/0x77 @ 1
[    1.820004] device class 'block': registering
[    1.824004] initcall genhd_device_init+0x0/0x77 returned 0 after 3906 usecs
[    1.828004] calling  blk_dev_integrity_init+0x0/0x24 @ 1
[    1.832004] initcall blk_dev_integrity_init+0x0/0x24 returned 0 after 0 usecs
[    1.836004] calling  gpiolib_debugfs_init+0x0/0x1f @ 1
[    1.840004] initcall gpiolib_debugfs_init+0x0/0x1f returned 0 after 0 usecs
[    1.844004] calling  pca953x_init+0x0/0x11 @ 1
[    1.848004] bus: 'i2c': add driver pca953x
[    1.852004] i2c-core: driver [pca953x] registered
[    1.856004] initcall pca953x_init+0x0/0x11 returned 0 after 7812 usecs
[    1.860004] calling  pci_slot_init+0x0/0x4c @ 1
[    1.864004] initcall pci_slot_init+0x0/0x4c returned 0 after 0 usecs
[    1.868004] calling  pnp_init+0x0/0xf @ 1
[    1.876004] bus: 'pnp': registered
[    1.876004] initcall pnp_init+0x0/0xf returned 0 after 3906 usecs
[    1.880004] calling  misc_init+0x0/0xba @ 1
[    1.884004] device class 'misc': registering
[    1.888004] initcall misc_init+0x0/0xba returned 0 after 3906 usecs
[    1.892004] calling  phy_init+0x0/0x45 @ 1
[    1.896004] device class 'mdio_bus': registering
[    1.900004] bus: 'mdio_bus': registered
[    1.904004] bus: 'mdio_bus': add driver Generic PHY
[    1.908004] initcall phy_init+0x0/0x45 returned 0 after 11718 usecs
[    1.912004] calling  init_scsi+0x0/0xe1 @ 1
[    1.916004] device class 'scsi_host': registering
[    1.924004] bus: 'scsi': registered
[    1.924004] device class 'scsi_device': registering
[    1.928004] SCSI subsystem initialized
[    1.932004] initcall init_scsi+0x0/0xe1 returned 0 after 15625 usecs
[    1.936004] calling  ata_init+0x0/0x39e @ 1
[    1.944004] libata version 3.00 loaded.
[    1.948004] initcall ata_init+0x0/0x39e returned 0 after 7812 usecs
[    1.952004] calling  init_pcmcia_cs+0x0/0x28 @ 1
[    1.956004] device class 'pcmcia_socket': registering
[    1.960004] initcall init_pcmcia_cs+0x0/0x28 returned 0 after 3906 usecs
[    1.964004] calling  usb_init+0x0/0x1e2 @ 1
[    1.968004] bus: 'usb': registered
[    1.972004] device class 'usb_host': registering
[    1.980004] bus: 'usb': add driver usbfs
[    1.984004] usbcore: registered new interface driver usbfs
[    1.988004] device class 'usb_device': registering
[    1.992004] bus: 'usb': add driver hub
[    1.996004] usbcore: registered new interface driver hub
[    2.000004] bus: 'usb': add driver usb
[    2.004004] usbcore: registered new device driver usb
[    2.008004] initcall usb_init+0x0/0x1e2 returned 0 after 39062 usecs
[    2.012004] calling  serio_init+0x0/0xc1 @ 1
[    2.016004] bus: 'serio': registered
[    2.020004] initcall serio_init+0x0/0xc1 returned 0 after 3906 usecs
[    2.024004] calling  gameport_init+0x0/0xc1 @ 1
[    2.028004] bus: 'gameport': registered
[    2.032004] initcall gameport_init+0x0/0xc1 returned 0 after 3906 usecs
[    2.036004] calling  input_init+0x0/0x136 @ 1
[    2.040004] device class 'input': registering
[    2.048004] initcall input_init+0x0/0x136 returned 0 after 7812 usecs
[    2.052004] calling  power_supply_class_init+0x0/0x55 @ 1
[    2.056004] device class 'power_supply': registering
[    2.060004] initcall power_supply_class_init+0x0/0x55 returned 0 after 3906 usecs
[    2.064004] calling  leds_init+0x0/0x5c @ 1
[    2.068004] device class 'leds': registering
[    2.072004] initcall leds_init+0x0/0x5c returned 0 after 3906 usecs
[    2.076004] calling  ac97_bus_init+0x0/0xf @ 1
[    2.080004] bus: 'ac97': registered
[    2.084004] initcall ac97_bus_init+0x0/0xf returned 0 after 3906 usecs
[    2.088004] calling  pci_subsys_init+0x0/0x135 @ 1
[    2.092004] PCI: Probing PCI hardware
[    2.096004] PCI: Probing PCI hardware (bus 00)
[    2.104004] device: 'pci0000:00': device_add
[    2.108004] PM: Adding info for No Bus:pci0000:00
[    2.112004] device: '0000:00': device_add
[    2.116004] PM: Adding info for No Bus:0000:00
[    2.120004] PCI: Scanning bus 0000:00
[    2.124004] pci 0000:00:00.0: found [8086:2531] class 000600 header type 00
[    2.128004] pci 0000:00:00.0: reg 10 32bit mmio: [0xd8000000-0xdbffffff]
[    2.132004] pci 0000:00:01.0: found [8086:2532] class 000604 header type 01
[    2.136004] pci 0000:00:02.0: found [8086:2533] class 000604 header type 01
[    2.140004] pci 0000:00:1e.0: found [8086:244e] class 000604 header type 01
[    2.144004] pci 0000:00:1f.0: found [8086:2440] class 000601 header type 00
[    2.152004] pci 0000:00:1f.1: found [8086:244b] class 000101 header type 00
[    2.156004] pci 0000:00:1f.1: reg 20 io port: [0xf000-0xf00f]
[    2.160004] pci 0000:00:1f.2: found [8086:2442] class 000c03 header type 00
[    2.168004] pci 0000:00:1f.2: reg 20 io port: [0xd000-0xd01f]
[    2.172004] pci 0000:00:1f.3: found [8086:2443] class 000c05 header type 00
[    2.176004] pci 0000:00:1f.3: reg 20 io port: [0x500-0x50f]
[    2.180004] pci 0000:00:1f.4: found [8086:2444] class 000c03 header type 00
[    2.184004] pci 0000:00:1f.4: reg 20 io port: [0xd800-0xd81f]
[    2.188004] pci 0000:00:1f.5: found [8086:2445] class 000401 header type 00
[    2.192004] pci 0000:00:1f.5: reg 10 io port: [0xdc00-0xdcff]
[    2.196004] pci 0000:00:1f.5: reg 14 io port: [0xe000-0xe03f]
[    2.200004] PCI: Fixups for bus 0000:00
[    2.204004] pci 0000:00:01.0: scanning behind bridge, config 010100, pass 0
[    2.208004] PCI: Scanning bus 0000:01
[    2.212005] pci 0000:01:00.0: found [1002:5157] class 000300 header type 00
[    2.216005] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
[    2.220005] pci 0000:01:00.0: reg 14 io port: [0xa000-0xa0ff]
[    2.224005] pci 0000:01:00.0: reg 18 32bit mmio: [0xdd000000-0xdd00ffff]
[    2.228005] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    2.232005] pci 0000:01:00.0: supports D1 D2
[    2.236005] PCI: Fixups for bus 0000:01
[    2.240005] pci 0000:00:01.0: bridge io port: [0xa000-0xafff]
[    2.244005] pci 0000:00:01.0: bridge 32bit mmio: [0xdc000000-0xddffffff]
[    2.248005] pci 0000:00:01.0: bridge 32bit mmio pref: [0xd0000000-0xd7ffffff]
[    2.252005] PCI: Bus scan for 0000:01 returning with max=01
[    2.256005] pci 0000:00:02.0: scanning behind bridge, config 030200, pass 0
[    2.260005] PCI: Scanning bus 0000:02
[    2.264005] pci 0000:02:1f.0: found [8086:1360] class 000604 header type 01
[    2.268005] PCI: Fixups for bus 0000:02
[    2.272005] pci 0000:00:02.0: bridge io port: [0xb000-0xbfff]
[    2.276005] pci 0000:00:02.0: bridge 32bit mmio: [0xde000000-0xdfffffff]
[    2.280005] pci 0000:02:1f.0: scanning behind bridge, config 030302, pass 0
[    2.284005] PCI: Scanning bus 0000:03
[    2.288005] pci 0000:03:00.0: found [8086:1161] class 000800 header type 00
[    2.292005] pci 0000:03:00.0: reg 10 32bit mmio: [0xdf001000-0xdf001fff]
[    2.296005] pci 0000:03:04.0: found [9005:00cf] class 000100 header type 00
[    2.300005] pci 0000:03:04.0: reg 10 io port: [0xb000-0xb0ff]
[    2.304005] pci 0000:03:04.0: reg 14 64bit mmio: [0xdf000000-0xdf000fff]
[    2.308005] pci 0000:03:04.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    2.312005] pci 0000:03:04.1: found [9005:00cf] class 000100 header type 00
[    2.316005] pci 0000:03:04.1: reg 10 io port: [0xb400-0xb4ff]
[    2.320005] pci 0000:03:04.1: reg 14 64bit mmio: [0xdf002000-0xdf002fff]
[    2.324005] pci 0000:03:04.1: reg 30 32bit mmio: [0x000000-0x01ffff]
[    2.328005] PCI: Fixups for bus 0000:03
[    2.332005] pci 0000:02:1f.0: bridge io port: [0xb000-0xbfff]
[    2.336005] pci 0000:02:1f.0: bridge 32bit mmio: [0xde000000-0xdfffffff]
[    2.340005] PCI: Bus scan for 0000:03 returning with max=03
[    2.344005] pci 0000:02:1f.0: scanning behind bridge, config 030302, pass 1
[    2.348005] PCI: Bus scan for 0000:02 returning with max=03
[    2.352005] pci 0000:00:1e.0: scanning behind bridge, config 040400, pass 0
[    2.356005] PCI: Scanning bus 0000:04
[    2.360005] pci 0000:04:03.0: found [8086:1229] class 000200 header type 00
[    2.364005] pci 0000:04:03.0: reg 10 32bit mmio: [0xe1241000-0xe1241fff]
[    2.368005] pci 0000:04:03.0: reg 14 io port: [0xc000-0xc03f]
[    2.372005] pci 0000:04:03.0: reg 18 32bit mmio: [0xe1000000-0xe10fffff]
[    2.376005] pci 0000:04:03.0: reg 30 32bit mmio: [0x000000-0x0fffff]
[    2.380005] pci 0000:04:03.0: supports D1 D2
[    2.384005] pci 0000:04:03.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.388005] pci 0000:04:03.0: PME# disabled
[    2.392005] pci 0000:04:04.0: found [8086:1229] class 000200 header type 00
[    2.396005] pci 0000:04:04.0: reg 10 32bit mmio: [0xe1240000-0xe1240fff]
[    2.400005] pci 0000:04:04.0: reg 14 io port: [0xc400-0xc43f]
[    2.404005] pci 0000:04:04.0: reg 18 32bit mmio: [0xe1100000-0xe11fffff]
[    2.408005] pci 0000:04:04.0: reg 30 32bit mmio: [0x000000-0x0fffff]
[    2.416005] pci 0000:04:04.0: supports D1 D2
[    2.420005] pci 0000:04:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.424005] pci 0000:04:04.0: PME# disabled
[    2.428005] pci 0000:04:07.0: found [8086:100c] class 000200 header type 00
[    2.432005] pci 0000:04:07.0: reg 10 32bit mmio: [0xe1200000-0xe121ffff]
[    2.436005] pci 0000:04:07.0: reg 14 32bit mmio: [0xe1220000-0xe123ffff]
[    2.440005] pci 0000:04:07.0: reg 18 io port: [0xc800-0xc81f]
[    2.444005] pci 0000:04:07.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    2.448005] pci 0000:04:07.0: PME# supported from D0 D3hot D3cold
[    2.452005] pci 0000:04:07.0: PME# disabled
[    2.456005] PCI: Fixups for bus 0000:04
[    2.460005] pci 0000:00:1e.0: bridge io port: [0xc000-0xcfff]
[    2.464005] pci 0000:00:1e.0: bridge 32bit mmio: [0xe0000000-0xe1ffffff]
[    2.468005] PCI: Bus scan for 0000:04 returning with max=04
[    2.472005] pci 0000:00:01.0: scanning behind bridge, config 010100, pass 1
[    2.476005] pci 0000:00:02.0: scanning behind bridge, config 030200, pass 1
[    2.480005] pci 0000:00:1e.0: scanning behind bridge, config 040400, pass 1
[    2.484005] PCI: Bus scan for 0000:00 returning with max=04
[    2.488005] device: '0000:00:00.0': device_add
[    2.492005] bus: 'pci': add device 0000:00:00.0
[    2.496005] PM: Adding info for pci:0000:00:00.0
[    2.500005] device: '0000:00:01.0': device_add
[    2.504005] bus: 'pci': add device 0000:00:01.0
[    2.508005] PM: Adding info for pci:0000:00:01.0
[    2.512005] device: '0000:00:02.0': device_add
[    2.516005] bus: 'pci': add device 0000:00:02.0
[    2.520005] PM: Adding info for pci:0000:00:02.0
[    2.524005] device: '0000:00:1e.0': device_add
[    2.528005] bus: 'pci': add device 0000:00:1e.0
[    2.532005] PM: Adding info for pci:0000:00:1e.0
[    2.536005] device: '0000:00:1f.0': device_add
[    2.540005] bus: 'pci': add device 0000:00:1f.0
[    2.548005] PM: Adding info for pci:0000:00:1f.0
[    2.552005] device: '0000:00:1f.1': device_add
[    2.556005] bus: 'pci': add device 0000:00:1f.1
[    2.560005] PM: Adding info for pci:0000:00:1f.1
[    2.564005] device: '0000:00:1f.2': device_add
[    2.568005] bus: 'pci': add device 0000:00:1f.2
[    2.572005] PM: Adding info for pci:0000:00:1f.2
[    2.576005] device: '0000:00:1f.3': device_add
[    2.580005] bus: 'pci': add device 0000:00:1f.3
[    2.584005] PM: Adding info for pci:0000:00:1f.3
[    2.588005] device: '0000:00:1f.4': device_add
[    2.592005] bus: 'pci': add device 0000:00:1f.4
[    2.596005] PM: Adding info for pci:0000:00:1f.4
[    2.600005] device: '0000:00:1f.5': device_add
[    2.604005] bus: 'pci': add device 0000:00:1f.5
[    2.608005] PM: Adding info for pci:0000:00:1f.5
[    2.612005] device: '0000:01:00.0': device_add
[    2.620005] bus: 'pci': add device 0000:01:00.0
[    2.624005] PM: Adding info for pci:0000:01:00.0
[    2.628005] device: '0000:01': device_add
[    2.632005] PM: Adding info for No Bus:0000:01
[    2.636005] device: '0000:02:1f.0': device_add
[    2.640005] bus: 'pci': add device 0000:02:1f.0
[    2.644005] PM: Adding info for pci:0000:02:1f.0
[    2.648005] device: '0000:03:00.0': device_add
[    2.652005] bus: 'pci': add device 0000:03:00.0
[    2.656005] PM: Adding info for pci:0000:03:00.0
[    2.660005] device: '0000:03:04.0': device_add
[    2.664005] bus: 'pci': add device 0000:03:04.0
[    2.668005] PM: Adding info for pci:0000:03:04.0
[    2.672005] device: '0000:03:04.1': device_add
[    2.676005] bus: 'pci': add device 0000:03:04.1
[    2.680005] PM: Adding info for pci:0000:03:04.1
[    2.684005] device: '0000:03': device_add
[    2.688005] PM: Adding info for No Bus:0000:03
[    2.692005] device: '0000:02': device_add
[    2.696005] PM: Adding info for No Bus:0000:02
[    2.700005] device: '0000:04:03.0': device_add
[    2.704005] bus: 'pci': add device 0000:04:03.0
[    2.708005] PM: Adding info for pci:0000:04:03.0
[    2.712005] device: '0000:04:04.0': device_add
[    2.716005] bus: 'pci': add device 0000:04:04.0
[    2.720005] PM: Adding info for pci:0000:04:04.0
[    2.724005] device: '0000:04:07.0': device_add
[    2.728005] bus: 'pci': add device 0000:04:07.0
[    2.732005] PM: Adding info for pci:0000:04:07.0
[    2.736005] device: '0000:04': device_add
[    2.740005] PM: Adding info for No Bus:0000:04
[    2.748005] pci 0000:00:1f.0: PIIX/ICH IRQ router [8086:2440]
[    2.752005] pci 0000:00:1f.2: PCI->APIC IRQ transform: INT D -> IRQ 19
[    2.756005] pci 0000:00:1f.3: PCI->APIC IRQ transform: INT B -> IRQ 17
[    2.760005] pci 0000:00:1f.4: PCI->APIC IRQ transform: INT C -> IRQ 23
[    2.764005] pci 0000:00:1f.5: PCI->APIC IRQ transform: INT B -> IRQ 17
[    2.768005] pci 0000:01:00.0: PCI->APIC IRQ transform: INT A -> IRQ 22
[    2.772005] pci 0000:03:04.0: PCI->APIC IRQ transform: INT A -> IRQ 18
[    2.776005] pci 0000:03:04.1: PCI->APIC IRQ transform: INT B -> IRQ 18
[    2.780006] pci 0000:04:03.0: PCI->APIC IRQ transform: INT A -> IRQ 19
[    2.784006] pci 0000:04:04.0: PCI->APIC IRQ transform: INT A -> IRQ 16
[    2.788006] pci 0000:04:07.0: PCI->APIC IRQ transform: INT A -> IRQ 16
[    2.792006] initcall pci_subsys_init+0x0/0x135 returned 0 after 683594 usecs
[    2.796006] calling  proto_init+0x0/0xf @ 1
[    2.800006] initcall proto_init+0x0/0xf returned 0 after 0 usecs
[    2.804006] calling  net_dev_init+0x0/0x1c2 @ 1
[    2.808006] device class 'net': registering
[    2.812006] device: 'lo': device_add
[    2.816006] PM: Adding info for No Bus:lo
[    2.824006] initcall net_dev_init+0x0/0x1c2 returned 0 after 15625 usecs
[    2.828006] calling  neigh_init+0x0/0x66 @ 1
[    2.832006] initcall neigh_init+0x0/0x66 returned 0 after 0 usecs
[    2.836006] calling  pktsched_init+0x0/0xa9 @ 1
[    2.840006] initcall pktsched_init+0x0/0xa9 returned 0 after 0 usecs
[    2.844006] calling  tc_filter_init+0x0/0x43 @ 1
[    2.848006] initcall tc_filter_init+0x0/0x43 returned 0 after 0 usecs
[    2.852006] calling  tc_action_init+0x0/0x43 @ 1
[    2.856006] initcall tc_action_init+0x0/0x43 returned 0 after 0 usecs
[    2.860006] calling  genl_init+0x0/0xe7 @ 1
[    2.880006] initcall genl_init+0x0/0xe7 returned 0 after 15625 usecs
[    2.884006] calling  cipso_v4_init+0x0/0x8f @ 1
[    2.888006] initcall cipso_v4_init+0x0/0x8f returned 0 after 0 usecs
[    2.892006] calling  wanrouter_init+0x0/0x50 @ 1
[    2.896006] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
[    2.900006] initcall wanrouter_init+0x0/0x50 returned 0 after 3906 usecs
[    2.904006] calling  wireless_nlevent_init+0x0/0x39 @ 1
[    2.908006] initcall wireless_nlevent_init+0x0/0x39 returned 0 after 0 usecs
[    2.912006] calling  cfg80211_init+0x0/0xa4 @ 1
[    2.916006] device class 'ieee80211': registering
[    2.936006] Registering platform device 'regulatory.0'. Parent at platform
[    2.940006] device: 'regulatory.0': device_add
[    2.944006] bus: 'platform': add device regulatory.0
[    2.948006] PM: Adding info for platform:regulatory.0
[    2.952006] cfg80211: Using static regulatory domain info
[    2.956006] cfg80211: Regulatory domain: US
[    2.960006] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    2.964006] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    2.968006] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    2.972006] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    2.976006] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    2.980006] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    2.984006] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    2.988006] cfg80211: Calling CRDA for country: US
[    2.992006] initcall cfg80211_init+0x0/0xa4 returned 0 after 74218 usecs
[    2.996006] calling  ieee80211_init+0x0/0xc @ 1
[    3.000006] initcall ieee80211_init+0x0/0xc returned 0 after 0 usecs
[    3.004006] calling  netlbl_init+0x0/0xa6 @ 1
[    3.008006] NetLabel: Initializing
[    3.012006] NetLabel:  domain hash size = 128
[    3.016006] NetLabel:  protocols = UNLABELED CIPSOv4
[    3.020006] NetLabel:  unlabeled traffic allowed by default
[    3.024006] initcall netlbl_init+0x0/0xa6 returned 0 after 15625 usecs
[    3.028006] calling  sysctl_init+0x0/0x49 @ 1
[    3.032006] initcall sysctl_init+0x0/0x49 returned 0 after 0 usecs
[    3.036006] calling  pci_iommu_init+0x0/0xc @ 1
[    3.040006] initcall pci_iommu_init+0x0/0xc returned 0 after 0 usecs
[    3.044006] calling  print_all_ICs+0x0/0x4ce @ 1
[    3.048006] 
[    3.048006] printing PIC contents
[    3.052006] ... PIC  IMR: fffb
[    3.052006] ... PIC  IRR: 0001
[    3.056006] ... PIC  ISR: 0000
[    3.056006] ... PIC ELCR: 1e20
[    3.060006] 
[    3.060006] printing local APIC contents on CPU#0/0:
[    3.060006] ... APIC ID:      00000000 (0)
[    3.060006] ... APIC VERSION: 00050014
[    3.060006] ... APIC TASKPRI: 00000000 (00)
[    3.060006] ... APIC PROCPRI: 00000000
[    3.060006] ... APIC LDR: 01000000
[    3.060006] ... APIC DFR: ffffffff
[    3.060006] ... APIC SPIV: 000001ff
[    3.060006] ... APIC ISR field:
[    3.060006] 0123456789abcdef0123456789abcdef
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] ... APIC TMR field:
[    3.060006] 0123456789abcdef0123456789abcdef
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] ... APIC IRR field:
[    3.060006] 0123456789abcdef0123456789abcdef
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000001000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] 00000000000000000000000000000000
[    3.060006] ... APIC ESR: 00000000
[    3.060006] ... APIC ICR: 000008ef
[    3.060006] ... APIC ICR2: 0e000000
[    3.060006] ... APIC LVTT: 000100ef
[    3.060006] ... APIC LVTPC: 00010000
[    3.060006] ... APIC LVT0: 00010700
[    3.060006] ... APIC LVT1: 00000400
[    3.060006] ... APIC LVTERR: 000000fe
[    3.060006] ... APIC TMICT: 00000000
[    3.060006] ... APIC TMCCT: 00000000
[    3.060006] ... APIC TDCR: 00000000
[    3.060006] 
[    3.064006] 
[    3.064006] printing local APIC contents on CPU#1/1:
[    3.068006] ... APIC ID:      01000000 (1)
[    3.068006] ... APIC VERSION: 00050014
[    3.068006] ... APIC TASKPRI: 00000000 (00)
[    3.068006] ... APIC PROCPRI: 00000000
[    3.068006] ... APIC LDR: 02000000
[    3.068006] ... APIC DFR: ffffffff
[    3.068006] ... APIC SPIV: 000001ff
[    3.068006] ... APIC ISR field:
[    3.068006] 0123456789abcdef0123456789abcdef
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] ... APIC TMR field:
[    3.068006] 0123456789abcdef0123456789abcdef
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] ... APIC IRR field:
[    3.068006] 0123456789abcdef0123456789abcdef
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000000000000000000000
[    3.068006] 00000000000000010000000000000000
[    3.068006] ... APIC ESR: 00000000
[    3.068006] ... APIC ICR: 00000000
[    3.068006] ... APIC ICR2: 00000000
[    3.068006] ... APIC LVTT: 000100ef
[    3.068006] ... APIC LVTPC: 00010000
[    3.068006] ... APIC LVT0: 00010700
[    3.068006] ... APIC LVT1: 00010400
[    3.068006] ... APIC LVTERR: 000000fe
[    3.068006] ... APIC TMICT: 00000000
[    3.068006] ... APIC TMCCT: 00000000
[    3.068006] ... APIC TDCR: 00000000
[    3.068006] 
[    3.260006] 
[    3.260006] printing local APIC contents on CPU#2/2:
[    3.264007] ... APIC ID:      02000000 (2)
[    3.264007] ... APIC VERSION: 00050014
[    3.264007] ... APIC TASKPRI: 00000000 (00)
[    3.264007] ... APIC PROCPRI: 00000000
[    3.264007] ... APIC LDR: 04000000
[    3.264007] ... APIC DFR: ffffffff
[    3.264007] ... APIC SPIV: 000001ff
[    3.264007] ... APIC ISR field:
[    3.264007] 0123456789abcdef0123456789abcdef
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] ... APIC TMR field:
[    3.264007] 0123456789abcdef0123456789abcdef
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] ... APIC IRR field:
[    3.264007] 0123456789abcdef0123456789abcdef
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000000000000000000000
[    3.264007] 00000000000000010000000000000000
[    3.264007] ... APIC ESR: 00000000
[    3.264007] ... APIC ICR: 00000000
[    3.264007] ... APIC ICR2: 00000000
[    3.264007] ... APIC LVTT: 000100ef
[    3.264007] ... APIC LVTPC: 00010000
[    3.264007] ... APIC LVT0: 00010700
[    3.264007] ... APIC LVT1: 00010400
[    3.264007] ... APIC LVTERR: 000000fe
[    3.264007] ... APIC TMICT: 00000000
[    3.264007] ... APIC TMCCT: 00000000
[    3.264007] ... APIC TDCR: 00000000
[    3.264007] 
[    3.460007] 
[    3.460007] printing local APIC contents on CPU#3/3:
[    3.464007] ... APIC ID:      03000000 (3)
[    3.464007] ... APIC VERSION: 00050014
[    3.464007] ... APIC TASKPRI: 00000000 (00)
[    3.464007] ... APIC PROCPRI: 00000000
[    3.464007] ... APIC LDR: 08000000
[    3.464007] ... APIC DFR: ffffffff
[    3.464007] ... APIC SPIV: 000001ff
[    3.464007] ... APIC ISR field:
[    3.464007] 0123456789abcdef0123456789abcdef
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] ... APIC TMR field:
[    3.464007] 0123456789abcdef0123456789abcdef
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] ... APIC IRR field:
[    3.464007] 0123456789abcdef0123456789abcdef
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000000000000000000000
[    3.464007] 00000000000000010000000000000000
[    3.464007] ... APIC ESR: 00000000
[    3.464007] ... APIC ICR: 00000000
[    3.464007] ... APIC ICR2: 00000000
[    3.464007] ... APIC LVTT: 000100ef
[    3.464007] ... APIC LVTPC: 00010000
[    3.464007] ... APIC LVT0: 00010700
[    3.464007] ... APIC LVT1: 00010400
[    3.464007] ... APIC LVTERR: 000000fe
[    3.464007] ... APIC TMICT: 00000000
[    3.464007] ... APIC TMCCT: 00000000
[    3.464007] ... APIC TDCR: 00000000
[    3.464007] 
[    3.656007] number of MP IRQ sources: 21.
[    3.660007] number of IO-APIC #4 registers: 24.
[    3.664007] testing the IO APIC.......................
[    3.668007] 
[    3.672007] IO APIC #4......
[    3.672007] .... register #00: 04000000
[    3.676007] .......    : physical APIC id: 04
[    3.680007] .......    : Delivery Type: 0
[    3.684007] .......    : LTS          : 0
[    3.688007] .... register #01: 00178020
[    3.692007] .......     : max redirection entries: 0017
[    3.696007] .......     : PRQ implemented: 1
[    3.700007] .......     : IO APIC version: 0020
[    3.704007] .... register #02: 00000000
[    3.708007] .......     : arbitration: 00
[    3.712007] .... register #03: 00000001
[    3.716007] .......     : Boot DT    : 1
[    3.720007] .... IRQ redirection table:
[    3.724007]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    3.728007]  00 000 1    0    0   0   0    0    0    00
[    3.732007]  01 00F 0    0    0   0   0    1    1    31
[    3.740007]  02 00F 0    0    0   0   0    1    1    30
[    3.744007]  03 00F 0    0    0   0   0    1    1    33
[    3.748007]  04 00F 0    0    0   0   0    1    1    34
[    3.756007]  05 000 1    0    0   0   0    0    0    00
[    3.760007]  06 00F 0    0    0   0   0    1    1    36
[    3.764007]  07 00F 0    0    0   0   0    1    1    37
[    3.772007]  08 00F 0    0    0   0   0    1    1    38
[    3.776007]  09 000 1    0    0   0   0    0    0    00
[    3.780007]  0a 000 1    0    0   0   0    0    0    00
[    3.784007]  0b 000 1    0    0   0   0    0    0    00
[    3.792007]  0c 000 1    0    0   0   0    0    0    00
[    3.796007]  0d 00F 0    0    0   0   0    1    1    3D
[    3.800007]  0e 00F 0    0    0   0   0    1    1    3E
[    3.808007]  0f 00F 0    0    0   0   0    1    1    3F
[    3.812007]  10 00F 1    1    0   1   0    1    1    49
[    3.816007]  11 00F 1    1    0   1   0    1    1    51
[    3.824007]  12 00F 1    1    0   1   0    1    1    59
[    3.828007]  13 00F 1    1    0   1   0    1    1    61
[    3.832007]  14 000 1    0    0   0   0    0    0    00
[    3.836007]  15 000 1    0    0   0   0    0    0    00
[    3.844007]  16 00F 1    1    0   1   0    1    1    69
[    3.848007]  17 00F 1    1    0   1   0    1    1    71
[    3.852007] IRQ to pin mappings:
[    3.856007] IRQ0 -> 0:2
[    3.860007] IRQ1 -> 0:1
[    3.860007] IRQ3 -> 0:3
[    3.864007] IRQ4 -> 0:4
[    3.868007] IRQ6 -> 0:6
[    3.868007] IRQ7 -> 0:7
[    3.872007] IRQ8 -> 0:8
[    3.872007] IRQ13 -> 0:13
[    3.876007] IRQ14 -> 0:14
[    3.880007] IRQ15 -> 0:15
[    3.880007] IRQ16 -> 0:16
[    3.884007] IRQ17 -> 0:17
[    3.888007] IRQ18 -> 0:18
[    3.888007] IRQ19 -> 0:19
[    3.892007] IRQ22 -> 0:22
[    3.896007] IRQ23 -> 0:23
[    3.896007] .................................... done.
[    3.900007] initcall print_all_ICs+0x0/0x4ce returned 0 after 832032 usecs
[    3.904007] calling  init_kmmio+0x0/0x23 @ 1
[    3.908007] initcall init_kmmio+0x0/0x23 returned 0 after 0 usecs
[    3.912007] calling  clocksource_done_booting+0x0/0x11 @ 1
[    3.916007] initcall clocksource_done_booting+0x0/0x11 returned 0 after 0 usecs
[    3.920007] calling  ftrace_init_debugfs+0x0/0xe7 @ 1
[    3.924007] initcall ftrace_init_debugfs+0x0/0xe7 returned 0 after 0 usecs
[    3.928007] calling  rb_init_debugfs+0x0/0x38 @ 1
[    3.932007] initcall rb_init_debugfs+0x0/0x38 returned 0 after 0 usecs
[    3.936007] calling  tracer_init_debugfs+0x0/0x272 @ 1
[    3.940007] initcall tracer_init_debugfs+0x0/0x272 returned 0 after 0 usecs
[    3.944007] calling  all_annotated_branch_stats+0x0/0x27 @ 1
[    3.948007] Warning: could not register all branches stats
[    3.952007] initcall all_annotated_branch_stats+0x0/0x27 returned 1 after 3906 usecs
[    3.956007] initcall all_annotated_branch_stats+0x0/0x27 returned with error code 1 
[    3.960007] calling  init_annotated_branch_stats+0x0/0x27 @ 1
[    3.964007] Warning: could not register annotated branches stats
[    3.968007] initcall init_annotated_branch_stats+0x0/0x27 returned 1 after 3906 usecs
[    3.972007] initcall init_annotated_branch_stats+0x0/0x27 returned with error code 1 
[    3.976008] calling  init_pipe_fs+0x0/0x76 @ 1
[    3.980008] initcall init_pipe_fs+0x0/0x76 returned 0 after 0 usecs
[    3.984008] calling  init_mnt_writers+0x0/0x7d @ 1
[    3.988008] initcall init_mnt_writers+0x0/0x7d returned 0 after 0 usecs
[    3.992008] calling  eventpoll_init+0x0/0x98 @ 1
[    3.996008] initcall eventpoll_init+0x0/0x98 returned 0 after 0 usecs
[    4.000008] calling  anon_inode_init+0x0/0x15b @ 1
[    4.004008] initcall anon_inode_init+0x0/0x15b returned 0 after 0 usecs
[    4.008008] calling  pnpbios_init+0x0/0x46a @ 1
[    4.012008] PnPBIOS: Scanning system for PnP BIOS support...
[    4.020008] PnPBIOS: Found PnP BIOS installation structure at 0xc00fbe20
[    4.024008] PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xbe50, dseg 0xf0000
[    4.028008] device: 'pnp0': device_add
[    4.032008] PM: Adding info for No Bus:pnp0
[    4.036008] device: '00:00': device_add
[    4.040008] bus: 'pnp': add device 00:00
[    4.044008] PM: Adding info for pnp:00:00
[    4.048008] device: '00:01': device_add
[    4.052008] bus: 'pnp': add device 00:01
[    4.056008] PM: Adding info for pnp:00:01
[    4.060008] device: '00:02': device_add
[    4.064008] bus: 'pnp': add device 00:02
[    4.068008] PM: Adding info for pnp:00:02
[    4.072008] device: '00:03': device_add
[    4.076008] bus: 'pnp': add device 00:03
[    4.080008] PM: Adding info for pnp:00:03
[    4.084008] device: '00:04': device_add
[    4.088008] bus: 'pnp': add device 00:04
[    4.092008] PM: Adding info for pnp:00:04
[    4.096008] device: '00:05': device_add
[    4.100008] bus: 'pnp': add device 00:05
[    4.104008] PM: Adding info for pnp:00:05
[    4.112008] device: '00:06': device_add
[    4.116008] bus: 'pnp': add device 00:06
[    4.120008] PM: Adding info for pnp:00:06
[    4.124008] device: '00:07': device_add
[    4.128008] bus: 'pnp': add device 00:07
[    4.132008] PM: Adding info for pnp:00:07
[    4.136008] pnp 00:08: mem resource (0x0-0x9ffff) overlaps 0000:04:03.0 BAR 6 (0x0-0xfffff), disabling
[    4.140008] pnp 00:08: mem resource (0x0-0x9ffff) overlaps 0000:04:04.0 BAR 6 (0x0-0xfffff), disabling
[    4.144008] device: '00:08': device_add
[    4.148008] bus: 'pnp': add device 00:08
[    4.152008] PM: Adding info for pnp:00:08
[    4.160008] pnp 00:09: mem resource (0xf0000-0xf3fff) overlaps 0000:04:03.0 BAR 6 (0x0-0xfffff), disabling
[    4.164008] pnp 00:09: mem resource (0xf4000-0xf7fff) overlaps 0000:04:03.0 BAR 6 (0x0-0xfffff), disabling
[    4.168008] pnp 00:09: mem resource (0xf8000-0xfffff) overlaps 0000:04:03.0 BAR 6 (0x0-0xfffff), disabling
[    4.172008] pnp 00:09: mem resource (0xd5800-0xd7fff) overlaps 0000:04:03.0 BAR 6 (0x0-0xfffff), disabling
[    4.176008] pnp 00:09: mem resource (0xf0000-0xf3fff) overlaps 0000:04:04.0 BAR 6 (0x0-0xfffff), disabling
[    4.180008] pnp 00:09: mem resource (0xf4000-0xf7fff) overlaps 0000:04:04.0 BAR 6 (0x0-0xfffff), disabling
[    4.184008] pnp 00:09: mem resource (0xf8000-0xfffff) overlaps 0000:04:04.0 BAR 6 (0x0-0xfffff), disabling
[    4.188008] pnp 00:09: mem resource (0xd5800-0xd7fff) overlaps 0000:04:04.0 BAR 6 (0x0-0xfffff), disabling
[    4.192008] device: '00:09': device_add
[    4.196008] bus: 'pnp': add device 00:09
[    4.200008] PM: Adding info for pnp:00:09
[    4.204008] device: '00:0a': device_add
[    4.208008] bus: 'pnp': add device 00:0a
[    4.212008] PM: Adding info for pnp:00:0a
[    4.216008] device: '00:0c': device_add
[    4.220008] bus: 'pnp': add device 00:0c
[    4.224008] PM: Adding info for pnp:00:0c
[    4.228008] device: '00:0d': device_add
[    4.232008] bus: 'pnp': add device 00:0d
[    4.236008] PM: Adding info for pnp:00:0d
[    4.240008] device: '00:0f': device_add
[    4.244008] bus: 'pnp': add device 00:0f
[    4.248008] PM: Adding info for pnp:00:0f
[    4.252008] device: '00:10': device_add
[    4.256008] bus: 'pnp': add device 00:10
[    4.260008] PM: Adding info for pnp:00:10
[    4.268008] PnPBIOS: 15 nodes reported by PnP BIOS; 15 recorded by driver
[    4.272008] initcall pnpbios_init+0x0/0x46a returned 0 after 253906 usecs
[    4.276008] calling  pnp_system_init+0x0/0xf @ 1
[    4.280008] bus: 'pnp': add driver system
[    4.284008] bus: 'pnp': driver_probe_device: matched device 00:08 with driver system
[    4.288008] bus: 'pnp': really_probe: probing driver system with device 00:08
[    4.292008] system 00:08: iomem range 0xffb00000-0xffb7ffff has been reserved
[    4.296008] system 00:08: iomem range 0xfff00000-0xffffffff has been reserved
[    4.300008] system 00:08: iomem range 0xfec00000-0xfecfffff has been reserved
[    4.304008] system 00:08: iomem range 0xfee00000-0xfee0ffff has been reserved
[    4.308008] system 00:08: iomem range 0x100000-0xffffff could not be reserved
[    4.312008] driver: '00:08': driver_bound: bound to device 'system'
[    4.316008] bus: 'pnp': really_probe: bound device 00:08 to driver system
[    4.320008] bus: 'pnp': driver_probe_device: matched device 00:09 with driver system
[    4.324008] bus: 'pnp': really_probe: probing driver system with device 00:09
[    4.328008] driver: '00:09': driver_bound: bound to device 'system'
[    4.332008] bus: 'pnp': really_probe: bound device 00:09 to driver system
[    4.336008] initcall pnp_system_init+0x0/0xf returned 0 after 54687 usecs
[    4.340008] calling  chr_dev_init+0x0/0xa7 @ 1
[    4.344008] device class 'mem': registering
[    4.348008] device: 'mem': device_add
[    4.352008] PM: Adding info for No Bus:mem
[    4.356008] device: 'null': device_add
[    4.360008] PM: Adding info for No Bus:null
[    4.368008] device: 'port': device_add
[    4.372008] PM: Adding info for No Bus:port
[    4.376008] device: 'zero': device_add
[    4.380008] PM: Adding info for No Bus:zero
[    4.384008] device: 'full': device_add
[    4.388008] PM: Adding info for No Bus:full
[    4.392008] device: 'random': device_add
[    4.396008] PM: Adding info for No Bus:random
[    4.400008] device: 'urandom': device_add
[    4.404008] PM: Adding info for No Bus:urandom
[    4.408008] device: 'kmsg': device_add
[    4.412008] PM: Adding info for No Bus:kmsg
[    4.416008] device: 'oldmem': device_add
[    4.420008] PM: Adding info for No Bus:oldmem
[    4.424008] initcall chr_dev_init+0x0/0xa7 returned 0 after 78125 usecs
[    4.428008] calling  firmware_class_init+0x0/0x7b @ 1
[    4.432008] device class 'firmware': registering
[    4.436008] initcall firmware_class_init+0x0/0x7b returned 0 after 3906 usecs
[    4.440008] calling  cpufreq_gov_performance_init+0x0/0xf @ 1
[    4.444008] initcall cpufreq_gov_performance_init+0x0/0xf returned 0 after 0 usecs
[    4.448008] calling  ssb_modinit+0x0/0x7d @ 1
[    4.452008] bus: 'ssb': registered
[    4.456008] bus: 'pci': add driver b43-pci-bridge
[    4.460008] initcall ssb_modinit+0x0/0x7d returned 0 after 7812 usecs
[    4.464008] calling  pcibios_assign_resources+0x0/0xa5 @ 1
[    4.468008] pci 0000:01:00.0: BAR 6: got res [0xdc000000-0xdc01ffff] bus [0xdc000000-0xdc01ffff] flags 0x27200
[    4.472008] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    4.476008] pci 0000:00:01.0:   IO window: 0xa000-0xafff
[    4.484008] pci 0000:00:01.0:   MEM window: 0xdc000000-0xddffffff
[    4.488008] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000d7ffffff
[    4.492008] pci 0000:03:04.0: BAR 6: got res [0x50000000-0x5001ffff] bus [0x50000000-0x5001ffff] flags 0x27200
[    4.496008] pci 0000:03:04.1: BAR 6: got res [0x50020000-0x5003ffff] bus [0x50020000-0x5003ffff] flags 0x27200
[    4.500008] pci 0000:02:1f.0: PCI bridge, secondary bus 0000:03
[    4.504008] pci 0000:02:1f.0:   IO window: 0xb000-0xbfff
[    4.508008] pci 0000:02:1f.0:   MEM window: 0xde000000-0xdfffffff
[    4.512008] pci 0000:02:1f.0:   PREFETCH window: 0x00000050000000-0x000000500fffff
[    4.516008] pci 0000:00:02.0: PCI bridge, secondary bus 0000:02
[    4.520008] pci 0000:00:02.0:   IO window: 0xb000-0xbfff
[    4.524008] pci 0000:00:02.0:   MEM window: 0xde000000-0xdfffffff
[    4.528008] pci 0000:00:02.0:   PREFETCH window: 0x00000050000000-0x000000500fffff
[    4.532008] pci 0000:04:03.0: BAR 6: got res [0x50100000-0x501fffff] bus [0x50100000-0x501fffff] flags 0x27200
[    4.536008] pci 0000:04:04.0: BAR 6: got res [0x50200000-0x502fffff] bus [0x50200000-0x502fffff] flags 0x27200
[    4.540008] pci 0000:04:07.0: BAR 6: got res [0x50300000-0x5031ffff] bus [0x50300000-0x5031ffff] flags 0x27200
[    4.544008] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:04
[    4.548008] pci 0000:00:1e.0:   IO window: 0xc000-0xcfff
[    4.552008] pci 0000:00:1e.0:   MEM window: 0xe0000000-0xe1ffffff
[    4.556008] pci 0000:00:1e.0:   PREFETCH window: 0x00000050100000-0x000000503fffff
[    4.560008] pci 0000:02:1f.0: setting latency timer to 64
[    4.564008] pci 0000:00:1e.0: setting latency timer to 64
[    4.568008] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    4.572008] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    4.576008] pci_bus 0000:01: resource 0 io:  [0xa000-0xafff]
[    4.580008] pci_bus 0000:01: resource 1 mem: [0xdc000000-0xddffffff]
[    4.584008] pci_bus 0000:01: resource 2 mem: [0xd0000000-0xd7ffffff]
[    4.588008] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    4.592008] pci_bus 0000:02: resource 0 io:  [0xb000-0xbfff]
[    4.596008] pci_bus 0000:02: resource 1 mem: [0xde000000-0xdfffffff]
[    4.600008] pci_bus 0000:02: resource 2 mem: [0x50000000-0x500fffff]
[    4.604008] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    4.608008] pci_bus 0000:03: resource 0 io:  [0xb000-0xbfff]
[    4.612009] pci_bus 0000:03: resource 1 mem: [0xde000000-0xdfffffff]
[    4.616009] pci_bus 0000:03: resource 2 mem: [0x50000000-0x500fffff]
[    4.620009] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    4.624009] pci_bus 0000:04: resource 0 io:  [0xc000-0xcfff]
[    4.628009] pci_bus 0000:04: resource 1 mem: [0xe0000000-0xe1ffffff]
[    4.632009] pci_bus 0000:04: resource 2 mem: [0x50100000-0x503fffff]
[    4.636009] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
[    4.640009] initcall pcibios_assign_resources+0x0/0xa5 returned 0 after 167969 usecs
[    4.644009] calling  sysctl_core_init+0x0/0x2d @ 1
[    4.648009] initcall sysctl_core_init+0x0/0x2d returned 0 after 0 usecs
[    4.652009] calling  inet_init+0x0/0x27e @ 1
[    4.656009] NET: Registered protocol family 2
[    4.708009] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    4.716009] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    4.720009] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    4.744009] TCP: Hash tables configured (established 131072 bind 65536)
[    4.748009] TCP reno registered
[    4.764009] initcall inet_init+0x0/0x27e returned 0 after 105468 usecs
[    4.768009] calling  af_unix_init+0x0/0x53 @ 1
[    4.772009] NET: Registered protocol family 1
[    4.776009] initcall af_unix_init+0x0/0x53 returned 0 after 3906 usecs
[    4.780009] calling  populate_rootfs+0x0/0xc5 @ 1
[    4.788009] initcall populate_rootfs+0x0/0xc5 returned 0 after 3906 usecs
[    4.792009] calling  i8259A_init_sysfs+0x0/0x2b @ 1
[    4.796009] Registering sysdev class 'i8259'
[    4.800009] Registering sys device of class 'i8259'
[    4.804009] Registering sys device 'i82590'
[    4.808009] initcall i8259A_init_sysfs+0x0/0x2b returned 0 after 11718 usecs
[    4.812009] calling  sbf_init+0x0/0x11f @ 1
[    4.816009] initcall sbf_init+0x0/0x11f returned 0 after 0 usecs
[    4.820009] calling  i8237A_init_sysfs+0x0/0x2b @ 1
[    4.824009] Registering sysdev class 'i8237'
[    4.828009] Registering sys device of class 'i8237'
[    4.832009] Registering sys device 'i82370'
[    4.836009] initcall i8237A_init_sysfs+0x0/0x2b returned 0 after 11718 usecs
[    4.840009] calling  add_rtc_cmos+0x0/0x8a @ 1
[    4.844009] initcall add_rtc_cmos+0x0/0x8a returned 0 after 0 usecs
[    4.848009] calling  cache_sysfs_init+0x0/0x89 @ 1
[    4.852009] initcall cache_sysfs_init+0x0/0x89 returned 0 after 0 usecs
[    4.856009] calling  cpufreq_gx_init+0x0/0x1b4 @ 1
[    4.860009] initcall cpufreq_gx_init+0x0/0x1b4 returned -19 after 0 usecs
[    4.864009] calling  speedstep_init+0x0/0x157 @ 1
[    4.868009] initcall speedstep_init+0x0/0x157 returned -19 after 0 usecs
[    4.872009] calling  msr_init+0x0/0x149 @ 1
[    4.876009] device class 'msr': registering
[    4.880009] device: 'msr0': device_add
[    4.884009] PM: Adding info for No Bus:msr0
[    4.888009] device: 'msr1': device_add
[    4.892009] PM: Adding info for No Bus:msr1
[    4.900009] device: 'msr2': device_add
[    4.904009] PM: Adding info for No Bus:msr2
[    4.908009] device: 'msr3': device_add
[    4.912009] PM: Adding info for No Bus:msr3
[    4.916009] initcall msr_init+0x0/0x149 returned 0 after 39062 usecs
[    4.920009] calling  apm_init+0x0/0x4c1 @ 1
[    4.924009] apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
[    4.928009] apm: disabled - APM is not SMP safe.
[    4.932009] initcall apm_init+0x0/0x4c1 returned -19 after 7812 usecs
[    4.936009] calling  init_lapic_sysfs+0x0/0x44 @ 1
[    4.940009] Registering sysdev class 'lapic'
[    4.944009] Registering sys device of class 'lapic'
[    4.948009] Registering sys device 'lapic0'
[    4.952009] initcall init_lapic_sysfs+0x0/0x44 returned 0 after 11718 usecs
[    4.956009] calling  ioapic_init_sysfs+0x0/0xb9 @ 1
[    4.960009] Registering sysdev class 'ioapic'
[    4.968009] Registering sys device of class 'ioapic'
[    4.972009] Registering sys device 'ioapic0'
[    4.976009] initcall ioapic_init_sysfs+0x0/0xb9 returned 0 after 15625 usecs
[    4.980009] calling  init_vmi_clocksource+0x0/0xf4 @ 1
[    4.984009] initcall init_vmi_clocksource+0x0/0xf4 returned 0 after 0 usecs
[    4.988009] calling  add_pcspkr+0x0/0x45 @ 1
[    4.992009] Registering platform device 'pcspkr'. Parent at platform
[    4.996009] device: 'pcspkr': device_add
[    5.000009] bus: 'platform': add device pcspkr
[    5.004009] PM: Adding info for platform:pcspkr
[    5.008009] initcall add_pcspkr+0x0/0x45 returned 0 after 15625 usecs
[    5.012009] calling  scx200_init+0x0/0x20 @ 1
[    5.016009] scx200: NatSemi SCx200 Driver
[    5.020009] bus: 'pci': add driver scx200
[    5.028009] initcall scx200_init+0x0/0x20 returned 0 after 11718 usecs
[    5.032009] calling  start_periodic_check_for_corruption+0x0/0x4a @ 1
[    5.036009] initcall start_periodic_check_for_corruption+0x0/0x4a returned 0 after 0 usecs
[    5.040009] calling  start_pageattr_test+0x0/0x74 @ 1
[    5.044009] initcall start_pageattr_test+0x0/0x74 returned 0 after 0 usecs
[    5.048009] calling  init+0x0/0xf @ 1
[    5.052009] initcall init+0x0/0xf returned 0 after 0 usecs
[    5.056009] calling  proc_execdomains_init+0x0/0x1c @ 1
[    5.060009] initcall proc_execdomains_init+0x0/0x1c returned 0 after 0 usecs
[    5.068009] calling  ioresources_init+0x0/0x31 @ 1
[    5.072009] initcall ioresources_init+0x0/0x31 returned 0 after 0 usecs
[    5.076009] calling  uid_cache_init+0x0/0x5c @ 1
[    5.080009] initcall uid_cache_init+0x0/0x5c returned 0 after 0 usecs
[    5.084009] calling  init_posix_timers+0x0/0xac @ 1
[    5.088009] initcall init_posix_timers+0x0/0xac returned 0 after 0 usecs
[    5.092009] calling  init_posix_cpu_timers+0x0/0x90 @ 1
[    5.096009] initcall init_posix_cpu_timers+0x0/0x90 returned 0 after 0 usecs
[    5.100009] calling  nsproxy_cache_init+0x0/0x27 @ 1
[    5.104009] initcall nsproxy_cache_init+0x0/0x27 returned 0 after 0 usecs
[    5.108009] calling  create_proc_profile+0x0/0x259 @ 1
[    5.112009] initcall create_proc_profile+0x0/0x259 returned 0 after 0 usecs
[    5.116009] calling  timekeeping_init_device+0x0/0x2b @ 1
[    5.120009] Registering sysdev class 'timekeeping'
[    5.124009] Registering sys device of class 'timekeeping'
[    5.128009] Registering sys device 'timekeeping0'
[    5.132009] initcall timekeeping_init_device+0x0/0x2b returned 0 after 11718 usecs
[    5.136009] calling  init_clocksource_sysfs+0x0/0x6d @ 1
[    5.140009] Registering sysdev class 'clocksource'
[    5.144009] Registering sys device of class 'clocksource'
[    5.148009] Registering sys device 'clocksource0'
[    5.152009] initcall init_clocksource_sysfs+0x0/0x6d returned 0 after 11718 usecs
[    5.156009] calling  init_timer_list_procfs+0x0/0x38 @ 1
[    5.160009] initcall init_timer_list_procfs+0x0/0x38 returned 0 after 0 usecs
[    5.164009] calling  init_tstats_procfs+0x0/0x38 @ 1
[    5.168009] initcall init_tstats_procfs+0x0/0x38 returned 0 after 0 usecs
[    5.172009] calling  lockdep_proc_init+0x0/0x4f @ 1
[    5.176009] initcall lockdep_proc_init+0x0/0x4f returned 0 after 0 usecs
[    5.180009] calling  futex_init+0x0/0x7d @ 1
[    5.184009] initcall futex_init+0x0/0x7d returned 0 after 0 usecs
[    5.188009] calling  proc_dma_init+0x0/0x1c @ 1
[    5.192009] initcall proc_dma_init+0x0/0x1c returned 0 after 0 usecs
[    5.196009] calling  proc_modules_init+0x0/0x1c @ 1
[    5.200009] initcall proc_modules_init+0x0/0x1c returned 0 after 0 usecs
[    5.204009] calling  percpu_modinit+0x0/0xa1 @ 1
[    5.208009] initcall percpu_modinit+0x0/0xa1 returned 0 after 0 usecs
[    5.212009] calling  kallsyms_init+0x0/0x1f @ 1
[    5.216009] initcall kallsyms_init+0x0/0x1f returned 0 after 0 usecs
[    5.220009] calling  pid_namespaces_init+0x0/0x27 @ 1
[    5.224009] initcall pid_namespaces_init+0x0/0x27 returned 0 after 0 usecs
[    5.228009] calling  audit_init+0x0/0x182 @ 1
[    5.232009] audit: initializing netlink socket (disabled)
[    5.236009] type=2000 audit(1235057932.236:1): initialized
[    5.240009] initcall audit_init+0x0/0x182 returned 0 after 7812 usecs
[    5.244009] calling  audit_tree_init+0x0/0x60 @ 1
[    5.248009] initcall audit_tree_init+0x0/0x60 returned 0 after 0 usecs
[    5.252009] calling  init_kprobes+0x0/0x191 @ 1
[    5.288010] Kprobe smoke test started
[    5.356010] ------------[ cut here ]------------
[    5.356010] WARNING: at kernel/lockdep.c:2870 check_flags+0x5c/0x166()
[    5.356010] Hardware name: P4DC6
[    5.356010] Modules linked in:
[    5.356010] Pid: 1, comm: swapper Not tainted 2.6.29-rc5-tip #208
[    5.356010] Call Trace:
[    5.356010]  [<c013cb2e>] warn_slowpath+0x95/0xab
[    5.356010]  [<c0165477>] ? add_lock_to_list+0x74/0xa6
[    5.356010]  [<c016846c>] ? validate_chain+0xa36/0xbef
[    5.356010]  [<c01685d7>] ? validate_chain+0xba1/0xbef
[    5.356010]  [<c0168d37>] ? __lock_acquire+0x712/0x768
[    5.356010]  [<c016525c>] check_flags+0x5c/0x166
[    5.356010]  [<c0168dc1>] lock_acquire+0x34/0x8b
[    5.356010]  [<c08ae2c6>] mutex_lock_nested+0x3f/0x595
[    5.356010]  [<c08b4243>] ? unregister_kretprobes+0x26/0x158
[    5.356010]  [<c08b3248>] ? trampoline_handler+0x12c/0x19e
[    5.356010]  [<c017d2b6>] ? init_test_probes+0x42a/0x5ef
[    5.356010]  [<c08b4243>] unregister_kretprobes+0x26/0x158
[    5.356010]  [<c08b438b>] unregister_kretprobe+0x16/0x18
[    5.356010]  [<c017d2c0>] init_test_probes+0x434/0x5ef
[    5.356010]  [<c1061de5>] init_kprobes+0x187/0x191
[    5.356010]  [<c0166bf6>] ? debug_check_no_locks_freed+0x10d/0x12d
[    5.356010]  [<c016691b>] ? trace_hardirqs_on_caller+0x124/0x163
[    5.356010]  [<c01608ec>] ? jiffies_read+0x8/0x14
[    5.356010]  [<c015edd3>] ? getnstimeofday+0xac/0x137
[    5.356010]  [<c015993e>] ? ktime_get_ts+0x6d/0x72
[    5.356010]  [<c015995b>] ? ktime_get+0x18/0x34
[    5.356010]  [<c1061c5e>] ? init_kprobes+0x0/0x191
[    5.356010]  [<c0101082>] do_one_initcall+0x78/0x1dc
[    5.356010]  [<c02ffec4>] ? number+0x1a0/0x36e
[    5.356010]  [<c0166965>] ? trace_hardirqs_on+0xb/0xd
[    5.356010]  [<c016691b>] ? trace_hardirqs_on_caller+0x124/0x163
[    5.356010]  [<c0301460>] ? vsnprintf+0xacc/0xb52
[    5.356010]  [<c0168d37>] ? __lock_acquire+0x712/0x768
[    5.356010]  [<c0166bef>] ? debug_check_no_locks_freed+0x106/0x12d
[    5.356010]  [<c0168d37>] ? __lock_acquire+0x712/0x768
[    5.356010]  [<c03128a6>] ? _raw_spin_unlock+0x167/0x16f
[    5.356010]  [<c08b0484>] ? _spin_unlock+0x22/0x25
[    5.356010]  [<c022ce36>] ? proc_register+0x208/0x212
[    5.356010]  [<c022cfd2>] ? create_proc_entry+0xae/0xda
[    5.356010]  [<c018e573>] ? init_irq_proc+0x85/0x94
[    5.356010]  [<c10486e2>] kernel_init+0x140/0x1ad
[    5.356010]  [<c10485a2>] ? kernel_init+0x0/0x1ad
[    5.356010]  [<c010515f>] kernel_thread_helper+0x7/0x10
[    5.356010] ---[ end trace a7919e7f17c0a725 ]---
[    5.356010] possible reason: unannotated irqs-off.
[    5.356010] irq event stamp: 222111
[    5.356010] hardirqs last  enabled at (222111): [<c08b0965>] _spin_unlock_irqrestore+0x4d/0x59
[    5.356010] hardirqs last disabled at (222110): [<c08b086b>] _spin_lock_irqsave+0x1f/0x44
[    5.356010] softirqs last  enabled at (221796): [<c01438eb>] __do_softirq+0x182/0x19e
[    5.356010] softirqs last disabled at (221791): [<c0106703>] do_softirq+0x7e/0x16f
[   35.044031] CPA self-test:
[   35.044031]  4k 2046 large 220 gb 0 x 2266[c0000000-f77fd000] miss 0
[   35.152031]  4k 182270 large 44 gb 0 x 182314[c0000000-f77fd000] miss 0
[   35.228031]  4k 182270 large 44 gb 0 x 182314[c0000000-f77fd000] miss 0
[   35.232031] ok.
[   45.056031] INFO: RCU detected CPU 0 stall (t=4294903560/2500 jiffies)
[   45.056031] Pid: 1, comm: swapper Tainted: G        W  2.6.29-rc5-tip #208
[   45.056031] Call Trace:
[   45.056031]  [<c018ef02>] __rcu_pending+0x5b/0x284
[   45.056031]  [<c018f14c>] rcu_pending+0x21/0x4c
[   45.056031]  [<c0149817>] update_process_times+0x30/0x61
[   45.056031]  [<c0162319>] tick_periodic+0x79/0x85
[   45.056031]  [<c0162343>] tick_handle_periodic+0x1e/0x7f
[   45.056031]  [<c0162601>] tick_do_broadcast+0x3f/0x7d
[   45.056031]  [<c01626d3>] tick_do_periodic_broadcast+0x2e/0x3a
[   45.056031]  [<c01626f1>] tick_handle_periodic_broadcast+0x12/0x75
[   45.056031]  [<c0106cfd>] timer_interrupt+0x4d/0x83
[   45.056031]  [<c018ba2a>] handle_IRQ_event+0x33/0x80
[   45.056031]  [<c018dccf>] handle_edge_irq+0x168/0x1bc
[   45.056031]  [<c018db67>] ? handle_edge_irq+0x0/0x1bc
[   45.056031]  <IRQ>  [<c0105fa9>] ? do_IRQ+0x45/0xa6
[   45.056031]  [<c0104d6e>] ? common_interrupt+0x2e/0x34
[   45.056031]  [<c019007b>] ? relay_open_buf+0x24d/0x34f
[   45.056031]  [<c0137084>] ? mutex_spin_on_owner+0x8e/0xc1
[   45.056031]  [<c08ae2e5>] ? mutex_lock_nested+0x5e/0x595
[   45.056031]  [<c0166965>] ? trace_hardirqs_on+0xb/0xd
[   45.056031]  [<c017cca4>] ? kprobe_target+0x0/0x15
[   45.056031]  [<c08b452c>] ? register_kprobe+0x19f/0x4f4
[   45.056031]  [<c08b49fb>] ? register_kretprobe+0x17a/0x1e2
[   45.056031]  [<c08b4a99>] ? register_kretprobes+0x36/0x73
[   45.056031]  [<c017d340>] ? init_test_probes+0x4b4/0x5ef
[   45.056031]  [<c1061de5>] ? init_kprobes+0x187/0x191
[   45.056031]  [<c0166bf6>] ? debug_check_no_locks_freed+0x10d/0x12d
[   45.056031]  [<c016691b>] ? trace_hardirqs_on_caller+0x124/0x163
[   45.056031]  [<c01608ec>] ? jiffies_read+0x8/0x14
[   45.056031]  [<c015edd3>] ? getnstimeofday+0xac/0x137
[   45.056031]  [<c015993e>] ? ktime_get_ts+0x6d/0x72
[   45.056031]  [<c015995b>] ? ktime_get+0x18/0x34
[   45.056031]  [<c1061c5e>] ? init_kprobes+0x0/0x191
[   45.056031]  [<c0101082>] ? do_one_initcall+0x78/0x1dc
[   45.056031]  [<c02ffec4>] ? number+0x1a0/0x36e
[   45.056031]  [<c0166965>] ? trace_hardirqs_on+0xb/0xd
[   45.056031]  [<c016691b>] ? trace_hardirqs_on_caller+0x124/0x163
[   45.056031]  [<c0301460>] ? vsnprintf+0xacc/0xb52
[   45.056031]  [<c0168d37>] ? __lock_acquire+0x712/0x768
[   45.056031]  [<c0166bef>] ? debug_check_no_locks_freed+0x106/0x12d
[   45.056031]  [<c0168d37>] ? __lock_acquire+0x712/0x768
[   45.056031]  [<c03128a6>] ? _raw_spin_unlock+0x167/0x16f
[   45.056031]  [<c08b0484>] ? _spin_unlock+0x22/0x25
[   45.056031]  [<c022ce36>] ? proc_register+0x208/0x212
[   45.056031]  [<c022cfd2>] ? create_proc_entry+0xae/0xda
[   45.056031]  [<c018e573>] ? init_irq_proc+0x85/0x94
[   45.056031]  [<c10486e2>] ? kernel_init+0x140/0x1ad
[   45.056031]  [<c10485a2>] ? kernel_init+0x0/0x1ad
[   45.056031]  [<c010515f>] ? kernel_thread_helper+0x7/0x10
[   75.056031] INFO: RCU detected CPU 0 stall (t=4294911060/10000 jiffies)
[   75.056031] Pid: 1, comm: swapper Tainted: G        W  2.6.29-rc5-tip #208
[   75.056031] Call Trace:
[   75.056031]  [<c018ef02>] __rcu_pending+0x5b/0x284
[   75.056031]  [<c018f14c>] rcu_pending+0x21/0x4c
[   75.056031]  [<c0149817>] update_process_times+0x30/0x61
[   75.056031]  [<c0162319>] tick_periodic+0x79/0x85
[   75.056031]  [<c0162343>] tick_handle_periodic+0x1e/0x7f
[   75.056031]  [<c0162601>] tick_do_broadcast+0x3f/0x7d
[   75.056031]  [<c01626d3>] tick_do_periodic_broadcast+0x2e/0x3a
[   75.056031]  [<c01626f1>] tick_handle_periodic_broadcast+0x12/0x75
[   75.056031]  [<c0106cfd>] timer_interrupt+0x4d/0x83
[   75.056031]  [<c018ba2a>] handle_IRQ_event+0x33/0x80
[   75.056031]  [<c018dccf>] handle_edge_irq+0x168/0x1bc
[   75.056031]  [<c018db67>] ? handle_edge_irq+0x0/0x1bc
[   75.056031]  <IRQ>  [<c0105fa9>] ? do_IRQ+0x45/0xa6
[   75.056031]  [<c0104d6e>] ? common_interrupt+0x2e/0x34
[   75.056031]  [<c01900d8>] ? relay_open_buf+0x2aa/0x34f
[   75.056031]  [<c0137093>] ? mutex_spin_on_owner+0x9d/0xc1
[   75.056031]  [<c08ae2e5>] ? mutex_lock_nested+0x5e/0x595
[   75.056031]  [<c0166965>] ? trace_hardirqs_on+0xb/0xd
[   75.056031]  [<c017cca4>] ? kprobe_target+0x0/0x15
[   75.056031]  [<c08b452c>] ? register_kprobe+0x19f/0x4f4
[   75.056031]  [<c08b49fb>] ? register_kretprobe+0x17a/0x1e2
[   75.056031]  [<c08b4a99>] ? register_kretprobes+0x36/0x73
[   75.056031]  [<c017d340>] ? init_test_probes+0x4b4/0x5ef
[   75.056031]  [<c1061de5>] ? init_kprobes+0x187/0x191
[   75.056031]  [<c0166bf6>] ? debug_check_no_locks_freed+0x10d/0x12d
[   75.056031]  [<c016691b>] ? trace_hardirqs_on_caller+0x124/0x163
[   75.056031]  [<c01608ec>] ? jiffies_read+0x8/0x14
[   75.056031]  [<c015edd3>] ? getnstimeofday+0xac/0x137
[   75.056031]  [<c015993e>] ? ktime_get_ts+0x6d/0x72
[   75.056031]  [<c015995b>] ? ktime_get+0x18/0x34
[   75.056031]  [<c1061c5e>] ? init_kprobes+0x0/0x191
[   75.056031]  [<c0101082>] ? do_one_initcall+0x78/0x1dc
[   75.056031]  [<c02ffec4>] ? number+0x1a0/0x36e
[   75.056031]  [<c0166965>] ? trace_hardirqs_on+0xb/0xd
[   75.056031]  [<c016691b>] ? trace_hardirqs_on_caller+0x124/0x163
[   75.056031]  [<c0301460>] ? vsnprintf+0xacc/0xb52
[   75.056031]  [<c0168d37>] ? __lock_acquire+0x712/0x768
[   75.056031]  [<c0166bef>] ? debug_check_no_locks_freed+0x106/0x12d
[   75.056031]  [<c0168d37>] ? __lock_acquire+0x712/0x768
[   75.056031]  [<c03128a6>] ? _raw_spin_unlock+0x167/0x16f
[   75.056031]  [<c08b0484>] ? _spin_unlock+0x22/0x25
[   75.056031]  [<c022ce36>] ? proc_register+0x208/0x212
[   75.056031]  [<c022cfd2>] ? create_proc_entry+0xae/0xda
[   75.056031]  [<c018e573>] ? init_irq_proc+0x85/0x94
[   75.056031]  [<c10486e2>] ? kernel_init+0x140/0x1ad
[   75.056031]  [<c10485a2>] ? kernel_init+0x0/0x1ad
[   75.056031]  [<c010515f>] ? kernel_thread_helper+0x7/0x10
[  105.468031] INFO: RCU detected CPU 0 stall (t=4294918663/2500 jiffies)
[  105.468031] Pid: 1, comm: swapper Tainted: G        W  2.6.29-rc5-tip #208
[  105.468031] Call Trace:
[  105.468031]  [<c018ef02>] __rcu_pending+0x5b/0x284
[  105.468031]  [<c018f14c>] rcu_pending+0x21/0x4c
[  105.468031]  [<c0149817>] update_process_times+0x30/0x61
[  105.468031]  [<c0162319>] tick_periodic+0x79/0x85
[  105.468031]  [<c0162343>] tick_handle_periodic+0x1e/0x7f
[  105.468031]  [<c0162601>] tick_do_broadcast+0x3f/0x7d
[  105.468031]  [<c01626d3>] tick_do_periodic_broadcast+0x2e/0x3a
[  105.468031]  [<c01626f1>] tick_handle_periodic_broadcast+0x12/0x75
[  105.468031]  [<c0106cfd>] timer_interrupt+0x4d/0x83
[  105.468031]  [<c018ba2a>] handle_IRQ_event+0x33/0x80
[  105.468031]  [<c018dccf>] handle_edge_irq+0x168/0x1bc
[  105.468031]  [<c018db67>] ? handle_edge_irq+0x0/0x1bc
[  105.468031]  <IRQ>  [<c0105fa9>] ? do_IRQ+0x45/0xa6
[  105.468031]  [<c0104d6e>] ? common_interrupt+0x2e/0x34
[  105.468031]  [<c0137093>] ? mutex_spin_on_owner+0x9d/0xc1
[  105.468031]  [<c08ae2e5>] ? mutex_lock_nested+0x5e/0x595
[  105.468031]  [<c013465e>] ? default_wake_function+0x0/0x12
[  105.468031]  [<c08b511c>] ? free_insn_slot+0x1a/0xe4
[  105.468031]  [<c08b2ad6>] ? arch_remove_kprobe+0x21/0x33
[  105.468031]  [<c08b409b>] ? __unregister_kprobe_bottom+0x19/0x4f
[  105.468031]  [<c08b42ae>] ? unregister_kretprobes+0x91/0x158
[  105.468031]  [<c017d3f3>] ? init_test_probes+0x567/0x5ef
[  105.468031]  [<c1061de5>] ? init_kprobes+0x187/0x191
[  105.468031]  [<c0166bf6>] ? debug_check_no_locks_freed+0x10d/0x12d
[  105.468031]  [<c016691b>] ? trace_hardirqs_on_caller+0x124/0x163
[  105.468031]  [<c01608ec>] ? jiffies_read+0x8/0x14
[  105.468031]  [<c015edd3>] ? getnstimeofday+0xac/0x137
[  105.468031]  [<c015993e>] ? ktime_get_ts+0x6d/0x72
[  105.468031]  [<c015995b>] ? ktime_get+0x18/0x34
[  105.468031]  [<c1061c5e>] ? init_kprobes+0x0/0x191
[  105.468031]  [<c0101082>] ? do_one_initcall+0x78/0x1dc
[  105.468031]  [<c02ffec4>] ? number+0x1a0/0x36e
[  105.468031]  [<c0166965>] ? trace_hardirqs_on+0xb/0xd
[  105.468031]  [<c016691b>] ? trace_hardirqs_on_caller+0x124/0x163
[  105.468031]  [<c0301460>] ? vsnprintf+0xacc/0xb52
[  105.468031]  [<c0168d37>] ? __lock_acquire+0x712/0x768
[  105.468031]  [<c0166bef>] ? debug_check_no_locks_freed+0x106/0x12d
[  105.468031]  [<c0168d37>] ? __lock_acquire+0x712/0x768
[  105.468031]  [<c03128a6>] ? _raw_spin_unlock+0x167/0x16f
[  105.468031]  [<c08b0484>] ? _spin_unlock+0x22/0x25
[  105.468031]  [<c022ce36>] ? proc_register+0x208/0x212
[  105.468031]  [<c022cfd2>] ? create_proc_entry+0xae/0xda
[  105.468031]  [<c018e573>] ? init_irq_proc+0x85/0x94
[  105.468031]  [<c10486e2>] ? kernel_init+0x140/0x1ad
[  105.468031]  [<c10485a2>] ? kernel_init+0x0/0x1ad
[  105.468031]  [<c010515f>] ? kernel_thread_helper+0x7/0x10

--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

# head: 094d519a
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.29-rc5
# Thu Feb 19 12:38:23 2009
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
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
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
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
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_KTIME_SCALAR=y
CONFIG_BOOTPARAM_SUPPORT_WANTED=y
CONFIG_BOOTPARAM_SUPPORT=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
# CONFIG_BROKEN_BOOT_ALLOWED4 is not set
CONFIG_BROKEN_BOOT_EUROPE=y
CONFIG_BROKEN_BOOT_TITAN=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
CONFIG_CLASSIC_RCU=y
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_IKCONFIG=m
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=21
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
CONFIG_MM_OWNER=y
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
# CONFIG_UID16 is not set
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
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
CONFIG_PERF_COUNTERS=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_PCI_QUIRKS is not set
# CONFIG_SLUB_DEBUG is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_IBS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=m
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_BOOTPARAM_NO_HZ_OFF is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_BOOTPARAM_HIGHRES_OFF=y
CONFIG_SMP_SUPPORT=y
CONFIG_SPARSE_IRQ=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_ELAN is not set
CONFIG_X86_RDC321X=y
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
CONFIG_VMI=y
CONFIG_KVM_CLOCK=y
# CONFIG_KVM_GUEST is not set
CONFIG_LGUEST_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_PARAVIRT_DEBUG=y
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
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_CYRIX_32 is not set
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_32=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_X86_DS=y
CONFIG_X86_PTRACE_BTS=y
# CONFIG_HPET_TIMER is not set
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=m
CONFIG_I8K=m
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=m
# CONFIG_UP_WANTED_1 is not set
CONFIG_SMP=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_UNEVICTABLE_LRU is not set
CONFIG_MMU_NOTIFIER=y
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
# CONFIG_X86_RESERVE_LOW_64K is not set
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x100000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
# CONFIG_ACPI is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
CONFIG_APM_DO_ENABLE=y
CONFIG_APM_CPU_IDLE=y
CONFIG_APM_DISPLAY_BLANK=y
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
# CONFIG_CPU_FREQ_STAT is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_GX_SUSPMOD=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=m
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
CONFIG_X86_E_POWERSAVER=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
# CONFIG_CPU_IDLE is not set
CONFIG_BOOTPARAM_NMI_WATCHDOG_BIT_0=y
CONFIG_BOOTPARAM_NOLAPIC_TIMER=y
# CONFIG_BOOTPARAM_LAPIC is not set
# CONFIG_BOOTPARAM_HPET_DISABLE is not set
CONFIG_BOOTPARAM_IDLE_MWAIT=y
CONFIG_BOOTPARAM_IDLE_POLL=y
# CONFIG_BOOTPARAM_HIGHMEM_512M is not set
CONFIG_BOOTPARAM_NOPAT=y
CONFIG_BOOTPARAM_NOTSC=y
CONFIG_BOOTPARAM_PCI_NOMSI=y

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
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
CONFIG_PCI_DEBUG=y
CONFIG_PCI_STUB=m
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_MCA=y
# CONFIG_MCA_LEGACY is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=m
# CONFIG_OLPC is not set
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
# CONFIG_YENTA_TOSHIBA is not set
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=m
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
CONFIG_HOTPLUG_PCI_IBM=y
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_ARPD=y
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_MULTIPLE_TABLES is not set
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_PIMSM_V2 is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
# CONFIG_NF_CONNTRACK_EVENTS is not set
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
CONFIG_NF_CONNTRACK_H323=m
# CONFIG_NF_CONNTRACK_IRC is not set
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT=y
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_VS=y
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
# CONFIG_IP_VS_PROTO_UDP is not set
CONFIG_IP_VS_PROTO_AH_ESP=y
# CONFIG_IP_VS_PROTO_ESP is not set
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
# CONFIG_IP_VS_WRR is not set
CONFIG_IP_VS_LC=y
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=y
CONFIG_IP_VS_SED=y
CONFIG_IP_VS_NQ=y

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=y

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_NF_CONNTRACK_IPV4 is not set
# CONFIG_IP_NF_QUEUE is not set
# CONFIG_IP_NF_IPTABLES is not set
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
# CONFIG_IP6_NF_MATCH_EUI64 is not set
CONFIG_IP6_NF_MATCH_FRAG=m
# CONFIG_IP6_NF_MATCH_OPTS is not set
# CONFIG_IP6_NF_MATCH_HL is not set
# CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
# CONFIG_IP6_NF_MATCH_MH is not set
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_TARGET_LOG is not set
# CONFIG_IP6_NF_FILTER is not set
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
CONFIG_ATM_CLIP_NO_ICMP=y
# CONFIG_ATM_LANE is not set
CONFIG_ATM_BR2684=m
CONFIG_ATM_BR2684_IPFILTER=y
# CONFIG_BRIDGE is not set
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=m
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=m
# CONFIG_ECONET is not set
CONFIG_WAN_ROUTER=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
# CONFIG_NET_SCH_ATM is not set
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_INGRESS=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=y
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
CONFIG_NET_ACT_GACT=m
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_NAT=m
# CONFIG_NET_ACT_PEDIT is not set
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_NET_TCPPROBE=m
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=y
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
CONFIG_6PACK=y
CONFIG_BPQETHER=m
CONFIG_SCC=y
CONFIG_SCC_DELAY=y
CONFIG_SCC_TRXECHO=y
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=m
CONFIG_YAM=y
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
# CONFIG_ACTISYS_DONGLE is not set
# CONFIG_TEKRAM_DONGLE is not set
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
# CONFIG_WINBOND_FIR is not set
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=m
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=m
# CONFIG_VIA_FIR is not set
CONFIG_MCS_FIR=m
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_PHONET is not set
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_NL80211=y
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
CONFIG_MAC80211=y

#
# Rate control algorithm selection
#
# CONFIG_MAC80211_RC_PID is not set
# CONFIG_MAC80211_RC_MINSTREL is not set
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
# CONFIG_MAC80211_RC_DEFAULT_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT=""
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT=y
# CONFIG_MAC80211_NOINLINE is not set
CONFIG_MAC80211_VERBOSE_DEBUG=y
CONFIG_MAC80211_HT_DEBUG=y
CONFIG_MAC80211_TKIP_DEBUG=y
CONFIG_MAC80211_IBSS_DEBUG=y
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
# CONFIG_MAC80211_VERBOSE_MPL_DEBUG is not set
CONFIG_MAC80211_DEBUG_COUNTERS=y
CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG=y
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y

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
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
CONFIG_PNPBIOS_PROC_FS=y
# CONFIG_PNPACPI is not set
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_DEV_XD=y
CONFIG_BLK_CPQ_DA=y
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_UB=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
# CONFIG_VIRTIO_BLK is not set
CONFIG_BLK_DEV_HD=y
# CONFIG_MISC_DEVICES is not set
# CONFIG_DELL_LAPTOP is not set
CONFIG_EEPROM_93CX6=y
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SAS_LIBSAS_DEBUG=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
# CONFIG_SCSI_CXGB3_ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
# CONFIG_SCSI_3W_9XXX is not set
CONFIG_SCSI_7000FASST=m
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AHA152X=m
CONFIG_SCSI_AHA1542=y
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=1000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=m
CONFIG_SCSI_IN2000=y
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=m
CONFIG_SCSI_FLASHPOINT=y
CONFIG_LIBFC=y
# CONFIG_FCOE is not set
# CONFIG_SCSI_DMX3191D is not set
CONFIG_SCSI_DTC3280=m
CONFIG_SCSI_EATA=y
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
# CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_GDTH=m
CONFIG_SCSI_GENERIC_NCR5380=y
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
# CONFIG_SCSI_GENERIC_NCR53C400 is not set
# CONFIG_SCSI_IBMMCA is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_MVSAS=m
# CONFIG_SCSI_NCR53C406A is not set
CONFIG_SCSI_NCR_D700=y
CONFIG_SCSI_STEX=y
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_NCR_Q720=m
CONFIG_SCSI_NCR53C8XX_DEFAULT_TAGS=8
CONFIG_SCSI_NCR53C8XX_MAX_TAGS=32
CONFIG_SCSI_NCR53C8XX_SYNC=20
CONFIG_SCSI_PAS16=m
# CONFIG_SCSI_QLOGIC_FAS is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=m
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_SIM710=y
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
CONFIG_SCSI_U14_34F=y
# CONFIG_SCSI_U14_34F_TAGGED_QUEUE is not set
CONFIG_SCSI_U14_34F_LINKED_COMMANDS=y
CONFIG_SCSI_U14_34F_MAX_TAGS=8
# CONFIG_SCSI_ULTRASTOR is not set
CONFIG_SCSI_NSP32=m
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=m
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=y
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SX4=m
# CONFIG_SATA_SIL is not set
CONFIG_SATA_SIS=y
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=y
CONFIG_SATA_VITESSE=m
CONFIG_SATA_INIC162X=m
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=y
CONFIG_PATA_ATIIXP=y
CONFIG_PATA_CMD640_PCI=y
CONFIG_PATA_CMD64X=m
CONFIG_PATA_CS5520=m
# CONFIG_PATA_CS5530 is not set
CONFIG_PATA_CS5535=y
CONFIG_PATA_CS5536=y
# CONFIG_PATA_CYPRESS is not set
CONFIG_PATA_EFAR=m
CONFIG_ATA_GENERIC=m
CONFIG_PATA_HPT366=y
# CONFIG_PATA_HPT37X is not set
CONFIG_PATA_HPT3X2N=m
# CONFIG_PATA_HPT3X3 is not set
CONFIG_PATA_ISAPNP=m
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_JMICRON=m
# CONFIG_PATA_LEGACY is not set
CONFIG_PATA_TRIFLEX=y
# CONFIG_PATA_MARVELL is not set
CONFIG_PATA_MPIIX=y
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=y
CONFIG_PATA_NS87410=m
CONFIG_PATA_NS87415=y
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_OPTIDMA=m
CONFIG_PATA_PDC_OLD=y
CONFIG_PATA_QDI=y
CONFIG_PATA_RADISYS=y
CONFIG_PATA_RZ1000=y
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=y
CONFIG_PATA_VIA=y
# CONFIG_PATA_WINBOND is not set
CONFIG_PATA_WINBOND_VLB=y
CONFIG_PATA_PLATFORM=y
# CONFIG_PATA_SCH is not set
# CONFIG_MD is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=m
# CONFIG_IEEE1394_OHCI1394 is not set
CONFIG_IEEE1394_PCILYNX=m
CONFIG_IEEE1394_SBP2=m
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_ETH1394 is not set
CONFIG_IEEE1394_RAWIO=m
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
CONFIG_DUMMY=m
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=m
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=m
CONFIG_ARCNET_COM90xx=m
CONFIG_ARCNET_COM90xxIO=m
# CONFIG_ARCNET_RIM_I is not set
# CONFIG_ARCNET_COM20020 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
CONFIG_ICPLUS_PHY=m
# CONFIG_REALTEK_PHY is not set
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
CONFIG_SUNGEM=y
CONFIG_CASSINI=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_EL1=y
# CONFIG_EL2 is not set
CONFIG_ELPLUS=y
CONFIG_EL16=y
CONFIG_EL3=y
CONFIG_3C515=m
CONFIG_VORTEX=y
# CONFIG_TYPHOON is not set
CONFIG_LANCE=y
# CONFIG_NET_VENDOR_SMC is not set
CONFIG_NET_VENDOR_RACAL=y
CONFIG_NI52=m
# CONFIG_NI65 is not set
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_TULIP=m
CONFIG_TULIP_MWI=y
CONFIG_TULIP_MMIO=y
CONFIG_TULIP_NAPI=y
# CONFIG_TULIP_NAPI_HW_MITIGATION is not set
CONFIG_DE4X5=m
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
CONFIG_ULI526X=y
# CONFIG_PCMCIA_XIRCOM is not set
# CONFIG_AT1700 is not set
CONFIG_DEPCA=m
CONFIG_HP100=m
CONFIG_NET_ISA=y
# CONFIG_E2100 is not set
CONFIG_EWRK3=y
CONFIG_EEXPRESS=y
CONFIG_EEXPRESS_PRO=y
# CONFIG_HPLAN is not set
# CONFIG_LP486E is not set
CONFIG_ETH16I=m
CONFIG_NE2000=m
CONFIG_ZNET=y
CONFIG_SEEQ8005=m
CONFIG_IBMLANA=m
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_AMD8111_ETH=y
CONFIG_ADAPTEC_STARFIRE=y
# CONFIG_AC3200 is not set
# CONFIG_APRICOT is not set
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
CONFIG_FORCEDETH_NAPI=y
CONFIG_CS89x0=m
CONFIG_E100=y
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
CONFIG_NE2K_PCI=m
CONFIG_8139CP=m
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R6040=m
CONFIG_SIS900=y
CONFIG_EPIC100=y
CONFIG_SMSC9420=y
# CONFIG_SUNDANCE is not set
CONFIG_TLAN=m
CONFIG_VIA_RHINE=m
CONFIG_VIA_RHINE_MMIO=y
CONFIG_SC92031=m
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
CONFIG_DL2K=y
CONFIG_E1000=m
CONFIG_E1000E=y
CONFIG_IP1000=m
CONFIG_IGB=m
CONFIG_IGB_LRO=y
CONFIG_IGB_DCA=y
CONFIG_NS83820=m
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=y
CONFIG_SIS190=m
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=y
CONFIG_TIGON3=y
CONFIG_BNX2=y
CONFIG_QLA3XXX=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
# CONFIG_JME is not set
CONFIG_NETDEV_10000=y
CONFIG_CHELSIO_T1=m
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3_DEPENDS=y
CONFIG_CHELSIO_T3=y
CONFIG_ENIC=m
CONFIG_IXGBE=y
CONFIG_IXGBE_DCA=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGB=y
# CONFIG_S2IO is not set
CONFIG_MYRI10GE=m
CONFIG_MYRI10GE_DCA=y
# CONFIG_NIU is not set
CONFIG_MLX4_EN=m
CONFIG_MLX4_CORE=m
# CONFIG_MLX4_DEBUG is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
CONFIG_QLGE=m
# CONFIG_SFC is not set
CONFIG_TR=m
# CONFIG_IBMTR is not set
CONFIG_IBMOL=m
CONFIG_IBMLS=m
CONFIG_3C359=m
CONFIG_TMS380TR=m
CONFIG_TMSPCI=m
# CONFIG_SKISA is not set
CONFIG_PROTEON=m
# CONFIG_ABYSS is not set
CONFIG_MADGEMC=m
CONFIG_SMCTR=m

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_LIBERTAS is not set
CONFIG_LIBERTAS_THINFIRM=y
# CONFIG_LIBERTAS_THINFIRM_USB is not set
CONFIG_AIRO=y
# CONFIG_HERMES is not set
CONFIG_ATMEL=m
CONFIG_PCI_ATMEL=m
CONFIG_PRISM54=m
# CONFIG_USB_ZD1201 is not set
CONFIG_USB_NET_RNDIS_WLAN=m
CONFIG_RTL8180=y
# CONFIG_RTL8187 is not set
CONFIG_ADM8211=y
CONFIG_MAC80211_HWSIM=y
CONFIG_P54_COMMON=m
# CONFIG_P54_USB is not set
CONFIG_P54_PCI=m
CONFIG_ATH5K=y
# CONFIG_ATH5K_DEBUG is not set
CONFIG_ATH9K=m
CONFIG_ATH9K_DEBUG=y
# CONFIG_IPW2100 is not set
CONFIG_IPW2200=m
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
# CONFIG_IPW2200_QOS is not set
CONFIG_IPW2200_DEBUG=y
CONFIG_LIBIPW=m
# CONFIG_LIBIPW_DEBUG is not set
CONFIG_IWLWIFI=y
CONFIG_IWLCORE=y
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_IWLWIFI_RFKILL is not set
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWLWIFI_DEBUGFS=y
CONFIG_IWLAGN=m
# CONFIG_IWLAGN_SPECTRUM_MEASUREMENT is not set
# CONFIG_IWLAGN_LEDS is not set
CONFIG_IWL4965=y
# CONFIG_IWL5000 is not set
# CONFIG_IWL3945 is not set
# CONFIG_HOSTAP is not set
CONFIG_B43=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PIO=y
CONFIG_B43_LEDS=y
CONFIG_B43_DEBUG=y
CONFIG_B43_FORCE_PIO=y
CONFIG_B43LEGACY=m
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_RFKILL=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_ZD1211RW=m
CONFIG_ZD1211RW_DEBUG=y

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_SDIO=m
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
# CONFIG_USB_NET_PLUSB is not set
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
# CONFIG_USB_NET_CDC_SUBSET is not set
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_HSO=m
CONFIG_WAN=y
CONFIG_HOSTESS_SV11=m
CONFIG_COSA=m
CONFIG_LANMEDIA=y
CONFIG_SEALEVEL_4021=m
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
CONFIG_PCI200SYN=y
CONFIG_WANXL=y
# CONFIG_PC300TOO is not set
CONFIG_N2=y
# CONFIG_C101 is not set
CONFIG_FARSYNC=y
CONFIG_DSCC4=m
# CONFIG_DSCC4_PCISYNC is not set
CONFIG_DSCC4_PCI_RST=y
# CONFIG_DLCI is not set
CONFIG_WAN_ROUTER_DRIVERS=y
CONFIG_CYCLADES_SYNC=y
# CONFIG_CYCLOMX_X25 is not set
CONFIG_SBNI=m
CONFIG_SBNI_MULTILINE=y
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=m
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
CONFIG_ATM_ENI_DEBUG=y
CONFIG_ATM_ENI_TUNE_BURST=y
# CONFIG_ATM_ENI_BURST_TX_16W is not set
# CONFIG_ATM_ENI_BURST_TX_8W is not set
# CONFIG_ATM_ENI_BURST_TX_4W is not set
CONFIG_ATM_ENI_BURST_TX_2W=y
CONFIG_ATM_ENI_BURST_RX_16W=y
CONFIG_ATM_ENI_BURST_RX_8W=y
CONFIG_ATM_ENI_BURST_RX_4W=y
# CONFIG_ATM_ENI_BURST_RX_2W is not set
# CONFIG_ATM_FIRESTREAM is not set
CONFIG_ATM_ZATM=m
CONFIG_ATM_ZATM_DEBUG=y
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
CONFIG_ATM_AMBASSADOR=m
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
# CONFIG_ATM_HORIZON is not set
CONFIG_ATM_IA=m
CONFIG_ATM_IA_DEBUG=y
CONFIG_ATM_FORE200E=m
CONFIG_ATM_FORE200E_USE_TASKLET=y
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
CONFIG_SKFP=y
CONFIG_HIPPI=y
# CONFIG_ROADRUNNER is not set
CONFIG_PPP=y
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_ASYNC=m
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_PPP_DEFLATE=y
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_MPPE is not set
CONFIG_PPPOE=y
# CONFIG_PPPOATM is not set
CONFIG_PPPOL2TP=y
CONFIG_SLIP=y
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=y
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=y
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=y
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=y
CONFIG_ISDN_CAPI_CAPIFS_BOOL=y
CONFIG_ISDN_CAPI_CAPIFS=y

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1ISA=y
# CONFIG_ISDN_DRV_AVMB1_B1PCI is not set
CONFIG_ISDN_DRV_AVMB1_T1ISA=m
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=m
# CONFIG_ISDN_DRV_AVMB1_T1PCI is not set
# CONFIG_ISDN_DRV_AVMB1_C4 is not set
CONFIG_CAPI_EICON=y
# CONFIG_ISDN_DIVAS is not set
CONFIG_PHONE=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_GPIO=y
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_INPORT=m
# CONFIG_MOUSE_ATIXL is not set
CONFIG_MOUSE_LOGIBM=y
# CONFIG_MOUSE_PC110PAD is not set
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=m
# CONFIG_JOYSTICK_IFORCE_USB is not set
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
CONFIG_TABLET_USB_AIPTEK=y
# CONFIG_TABLET_USB_GTCO is not set
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_GUNZE=m
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_MTOUCH=m
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_HTCPEN=y
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_UCB1400 is not set
CONFIG_TOUCHSCREEN_WM97XX=m
CONFIG_TOUCHSCREEN_WM9705=y
CONFIG_TOUCHSCREEN_WM9712=y
CONFIG_TOUCHSCREEN_WM9713=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
CONFIG_TOUCHSCREEN_USB_3M=y
# CONFIG_TOUCHSCREEN_USB_ITM is not set
# CONFIG_TOUCHSCREEN_USB_ETURBO is not set
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
# CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC2007=m
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=m
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_DEVKMEM is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_COMPUTONE=y
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
CONFIG_DIGIEPCA=y
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=y
CONFIG_ISI=m
# CONFIG_SYNCLINK is not set
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
CONFIG_N_HDLC=m
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
CONFIG_SX=m
CONFIG_RIO=m
CONFIG_RIO_OLDPCI=y
# CONFIG_STALDRV is not set
CONFIG_NOZOMI=m

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=m
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_FOURPORT is not set
CONFIG_SERIAL_8250_ACCENT=y
# CONFIG_SERIAL_8250_BOCA is not set
# CONFIG_SERIAL_8250_EXAR_ST16C554 is not set
# CONFIG_SERIAL_8250_HUB6 is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_MCA=m

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=m
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_NVRAM is not set
CONFIG_DTLK=m
CONFIG_R3964=y
CONFIG_APPLICOM=y
# CONFIG_SONYPI is not set
CONFIG_MWAVE=m
# CONFIG_SCx200_GPIO is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=m
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_OCORES=m
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=y
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
CONFIG_I2C_VOODOO3=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set
CONFIG_SCx200_ACB=y

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=y
CONFIG_SENSORS_PCF8591=m
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_I2C_DEBUG_CHIP=y
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO expanders:
#

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCF857X=m

#
# PCI GPIO expanders:
#

#
# SPI GPIO expanders:
#
CONFIG_W1=m
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=m
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_BQ27x00=m
CONFIG_CHARGER_PCF50633=m
# CONFIG_HWMON is not set
CONFIG_THERMAL=m
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
CONFIG_SC520_WDT=y
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=m
CONFIG_SC1200_WDT=m
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=m
CONFIG_RDC321X_WDT=m
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
CONFIG_SBC7240_WDT=m
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=y
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=m
# CONFIG_MIXCOMWD is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_HTC_PASIC3 is not set
CONFIG_UCB1400_CORE=y
CONFIG_TPS65010=m
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_PCF50633=m
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=m
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_BQ24022=m
CONFIG_REGULATOR_PCF50633=m

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
# CONFIG_VIDEO_ALLOW_V4L1 is not set
# CONFIG_VIDEO_V4L1_COMPAT is not set
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMIZE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9875=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_SAA6588=m
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_CAFE_CCIC=m
CONFIG_SOC_CAMERA=m
CONFIG_SOC_CAMERA_MT9M001=m
# CONFIG_MT9M001_PCA9536_SWITCH is not set
CONFIG_SOC_CAMERA_MT9M111=m
# CONFIG_SOC_CAMERA_MT9T031 is not set
# CONFIG_SOC_CAMERA_MT9V022 is not set
CONFIG_SOC_CAMERA_TW9910=m
CONFIG_SOC_CAMERA_PLATFORM=m
CONFIG_SOC_CAMERA_OV772X=m
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
# CONFIG_USB_STV06XX is not set
# CONFIG_USB_GSPCA_CONEX is not set
CONFIG_USB_GSPCA_ETOMS=m
# CONFIG_USB_GSPCA_FINEPIX is not set
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7311=m
# CONFIG_USB_GSPCA_SONIXB is not set
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
# CONFIG_USB_GSPCA_SPCA505 is not set
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
# CONFIG_USB_GSPCA_STK014 is not set
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DEBUGIFC=y
# CONFIG_VIDEO_EM28XX is not set
CONFIG_VIDEO_USBVISION=m
CONFIG_USB_ET61X251=m
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_ZC0301 is not set
CONFIG_USB_ZR364XX=m
# CONFIG_USB_STKWEBCAM is not set
CONFIG_USB_S2255=m
# CONFIG_RADIO_ADAPTERS is not set
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_DRM=m
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_MGA=m
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=m
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PROGEAR=y
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
# CONFIG_SND_PCM_OSS_PLUGINS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_OPL4_LIB=y
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=m
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_WSS_LIB=y
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB8_DSP=m
CONFIG_SND_SB16_DSP=y
CONFIG_SND_ISA=y
CONFIG_SND_ADLIB=y
CONFIG_SND_AD1816A=y
CONFIG_SND_AD1848=y
CONFIG_SND_ALS100=y
CONFIG_SND_AZT2320=y
CONFIG_SND_CMI8330=y
# CONFIG_SND_CS4231 is not set
CONFIG_SND_CS4232=y
CONFIG_SND_CS4236=y
CONFIG_SND_DT019X=y
CONFIG_SND_ES968=m
CONFIG_SND_ES1688=y
CONFIG_SND_ES18XX=m
# CONFIG_SND_SC6000 is not set
CONFIG_SND_GUSCLASSIC=m
CONFIG_SND_GUSEXTREME=y
# CONFIG_SND_GUSMAX is not set
CONFIG_SND_INTERWAVE=m
# CONFIG_SND_INTERWAVE_STB is not set
CONFIG_SND_OPL3SA2=y
# CONFIG_SND_OPTI92X_AD1848 is not set
# CONFIG_SND_OPTI92X_CS4231 is not set
# CONFIG_SND_OPTI93X is not set
CONFIG_SND_MIRO=y
CONFIG_SND_SB8=m
CONFIG_SND_SB16=m
CONFIG_SND_SBAWE=m
# CONFIG_SND_SB16_CSP is not set
CONFIG_SND_SGALAXY=m
# CONFIG_SND_SSCAPE is not set
CONFIG_SND_WAVEFRONT=y
CONFIG_SND_WAVEFRONT_FIRMWARE_IN_KERNEL=y
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=y
CONFIG_SND_ALS300=y
CONFIG_SND_ALS4000=m
# CONFIG_SND_ALI5451 is not set
CONFIG_SND_ATIIXP=m
# CONFIG_SND_ATIIXP_MODEM is not set
CONFIG_SND_AU8810=y
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=y
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=y
CONFIG_SND_BT87X_OVERCLOCK=y
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=y
CONFIG_SND_OXYGEN_LIB=y
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
CONFIG_SND_CS5530=m
CONFIG_SND_CS5535AUDIO=y
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
CONFIG_SND_DARLA24=y
CONFIG_SND_GINA24=y
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=y
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
CONFIG_SND_INDIGOIO=m
# CONFIG_SND_INDIGODJ is not set
CONFIG_SND_EMU10K1=y
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=y
CONFIG_SND_FM801=m
# CONFIG_SND_HDA_INTEL is not set
CONFIG_SND_HDSP=y
CONFIG_SND_HDSPM=m
CONFIG_SND_HIFIER=y
CONFIG_SND_ICE1712=m
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=y
# CONFIG_SND_INTEL8X0M is not set
CONFIG_SND_KORG1212=m
CONFIG_SND_MAESTRO3=m
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
CONFIG_SND_RIPTIDE=y
CONFIG_SND_RME32=y
# CONFIG_SND_RME96 is not set
CONFIG_SND_RME9652=y
CONFIG_SND_SIS7019=m
CONFIG_SND_SONICVIBES=y
# CONFIG_SND_TRIDENT is not set
CONFIG_SND_VIA82XX=y
CONFIG_SND_VIA82XX_MODEM=y
CONFIG_SND_VIRTUOSO=y
# CONFIG_SND_VX222 is not set
CONFIG_SND_YMFPCI=y
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
CONFIG_SND_USB_USX2Y=y
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=y
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y
# CONFIG_HID_SUPPORT is not set
CONFIG_USB_MOUSE=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_SSB=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=m
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_HWA_HCD=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=m
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
# CONFIG_USB_STORAGE is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
# CONFIG_USB_SERIAL_GENERIC is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP2101=m
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
# CONFIG_USB_SERIAL_KEYSPAN_MPR is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
# CONFIG_USB_SERIAL_KEYSPAN_USA18X is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
# CONFIG_USB_SERIAL_KEYSPAN_USA49WLC is not set
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_MOS7720 is not set
CONFIG_USB_SERIAL_MOS7840=m
# CONFIG_USB_SERIAL_MOTOROLA is not set
CONFIG_USB_SERIAL_NAVMAN=m
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
# CONFIG_USB_SERIAL_SAFE is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=m
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=y
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=y
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=m
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_PHIDGET=m
# CONFIG_USB_PHIDGETKIT is not set
# CONFIG_USB_PHIDGETMOTORCONTROL is not set
CONFIG_USB_PHIDGETSERVO=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=m
# CONFIG_USB_SISUSBVGA_CON is not set
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_VST=m
# CONFIG_USB_ATM is not set

#
# OTG and related infrastructure
#
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=m
CONFIG_UWB_WLP=y
# CONFIG_UWB_I1480U is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_UNSAFE_RESUME=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_ALIX2=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_AMD76X=y
CONFIG_EDAC_E7XXX=m
# CONFIG_EDAC_E752X is not set
CONFIG_EDAC_I82875P=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=y
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
# CONFIG_EDAC_I82860 is not set
CONFIG_EDAC_R82600=y
# CONFIG_EDAC_I5000 is not set
CONFIG_EDAC_I5100=y
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=m
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_V3020=m
CONFIG_RTC_DRV_PCF50633=m

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=y
# CONFIG_UIO is not set
CONFIG_X86_PLATFORM_DEVICES=y

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y

#
# File systems
#
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=m
CONFIG_OCFS2_FS=m
# CONFIG_OCFS2_FS_O2CB is not set
# CONFIG_OCFS2_FS_USERSPACE_CLUSTER is not set
# CONFIG_OCFS2_FS_STATS is not set
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_OCFS2_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS is not set
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=m
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=m
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
# CONFIG_ACORN_PARTITION_EESOX is not set
# CONFIG_ACORN_PARTITION_ICS is not set
CONFIG_ACORN_PARTITION_ADFS=y
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ALLOW_WARNINGS=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_KPROBES_SANITY_TEST=y
CONFIG_BACKTRACE_SELF_TEST=m
# CONFIG_LKDTM is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
CONFIG_FAIL_IO_TIMEOUT=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_HW_BRANCH_TRACER=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_TRACING=y

#
# Tracers
#
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_BOOT_TRACER=y
CONFIG_TRACE_BRANCH_PROFILING=y
CONFIG_PROFILE_ALL_BRANCHES=y
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_POWER_TRACER=y
CONFIG_STACK_TRACER=y
# CONFIG_HW_BRANCH_TRACER is not set
CONFIG_KMEMTRACE=y
# CONFIG_WORKQUEUE_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
CONFIG_MMIOTRACE_TEST=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DYNAMIC_PRINTK_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
# CONFIG_KGDB_SERIAL_CONSOLE is not set
CONFIG_KGDB_TESTS=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_NX_TEST=m
CONFIG_4KSTACKS=y
CONFIG_DOUBLEFAULT=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
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
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_SELINUX_DISABLE is not set
# CONFIG_SECURITY_SELINUX_DEVELOP is not set
# CONFIG_SECURITY_SELINUX_AVC_STATS is not set
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
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
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_CRYPTO_DEV_GEODE is not set
CONFIG_CRYPTO_DEV_HIFN_795X=y
# CONFIG_CRYPTO_DEV_HIFN_795X_RNG is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
CONFIG_KVM_TRACE=y
# CONFIG_LGUEST is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=m
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=m
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_FORCE_SUCCESSFUL_BUILD=y
CONFIG_FORCE_MINIMAL_CONFIG=y
CONFIG_FORCE_MINIMAL_CONFIG_PHYS=y
CONFIG_X86_32_ALWAYS_ON=y

--9amGYk9869ThD9tj--
