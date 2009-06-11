Return-Path: <linux-kernel-owner+w=401wt.eu-S1763053AbZFKLtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763053AbZFKLtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761682AbZFKLtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:49:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39229 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbZFKLtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:49:09 -0400
Date: Thu, 11 Jun 2009 13:48:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hannes@cmpxchg.org, mpm@selenic.com,
       npiggin@suse.de, yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early boot SLAB for 2.6.31
Message-ID: <20090611114814.GB13391@elte.hu>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain> <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain> <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI> <20090611113512.GA6971@elte.hu> <20090611114032.GA8856@elte.hu> <20090611114203.GA13391@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611114203.GA13391@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Hm, with this pulled on a testbox i'm still getting:
> > 
> > [    0.000000] Experimental hierarchical RCU init done.
> > [    0.000000] NR_IRQS:4352 nr_irqs:256
> > [    0.000000] ------------[ cut here ]------------
> > [    0.000000] WARNING: at mm/bootmem.c:537 alloc_arch_preferred_bootmem+0x40/0x7e()
> 
> Another testbox crashed on bootup. I'm collecting a serial log 
> from it - config attached meanwhile.

We have a hard crash in the WP-protect code:

[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...BUG: Int 14: CR2 ffcff000
[    0.000000]      EDI 00000188  ESI 00000ac7  EBP c17eaf9c  ESP c17eaf8c
[    0.000000]      EBX 000014e0  EDX 0000000e  ECX 01856067  EAX 00000001
[    0.000000]      err 00000003  EIP c10135b1   CS 00000060  flg 00010002
[    0.000000] Stack: c17eafa8 c17fd410 c16747bc c17eafc4 c17fd7e5 000011fd f8616000 c18237cc
[    0.000000]        00099800 c17bb000 c17eafec c17f1668 000001c5 c17f1322 c166e039 c1822bf0
[    0.000000]        c166e033 c153a014 c18237cc 00020800 c17eaff8 c17f106a 00020800 01ba5003
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.30-tip-02161-g7a74539-dirty #52203
[    0.000000] Call Trace:
[    0.000000]  [<c15357c2>] ? printk+0x14/0x16
[    0.000000]  [<c10135b1>] ? do_test_wp_bit+0x19/0x23
[    0.000000]  [<c17fd410>] ? test_wp_bit+0x26/0x64
[    0.000000]  [<c17fd7e5>] ? mem_init+0x1ba/0x1d8
[    0.000000]  [<c17f1668>] ? start_kernel+0x164/0x2f7
[    0.000000]  [<c17f1322>] ? unknown_bootoption+0x0/0x19c
[    0.000000]  [<c17f106a>] ? __init_begin+0x6a/0x6f

(full bootlog attached)

Just a quick analysis from the place we crash (without looking into 
any details): the WP test is the first time we really make use of 
the MMU during bootup - crashes there are often a sign of messed up 
pagetables, which is easy if the bootmem allocator is changed.

These patches needs more work.

	Ingo

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30-tip-02161-g7a74539-dirty (mingo@sirius) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #52203 SMP Thu Jun 11 13:37:22 CEST 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] console [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] DMI 2.3 present.
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x100000
[    0.000000] Warning only 894MB will be used.
[    0.000000] Use a HIGHMEM enabled kernel.
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] init_memory_mapping: 0000000000000000-0000000037e16000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037c00000 page 2M
[    0.000000]  0037c00000 - 0037e16000 page 4k
[    0.000000] kernel direct mapping tables up to 37e16000 @ 7000-c000
[    0.000000] ACPI: RSDP 000f76f0 00014 (v00 Nvidia)
[    0.000000] ACPI: RSDT 3fff3040 00034 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 3fff30c0 00074 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 3fff3180 06264 (v01 NVIDIA AWRDACPI 00001000 MSFT 0100000E)
[    0.000000] ACPI: FACS 3fff0000 00040
[    0.000000] ACPI: SRAT 3fff9500 000A0 (v01 AMD    HAMMER   00000001 AMD  00000001)
[    0.000000] ACPI: MCFG 3fff9600 0003C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC 3fff9440 0007C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 894MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37e16000
[    0.000000]   low ram: 0 - 37e16000
[    0.000000]   node 0 low ram: 00000000 - 37e16000
[    0.000000]   node 0 bootmap 00008000 - 0000efc4
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0037e16000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 0001a04b14]    TEXT DATA BSS ==> [0001000000 - 0001a04b14]
[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #5 [0001a05000 - 0001a0c149]              BRK ==> [0001a05000 - 0001a0c149]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
[    0.000000]   #7 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00037e16
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00037e16
[    0.000000] On node 0 totalpages: 228789
[    0.000000] free_area_init_node: node 0, pgdat c17b2340, node_mem_map c1a0d000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 1757 pages used for memmap
[    0.000000]   Normal zone: 223033 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
[    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 16 pages at c2111000, static data 41948 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 227000
[    0.000000] Kernel command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200,keep console=tty debug initcall_debug enforcing=0 apic=verbose ignore_loglevel sysrq_always_enabled selinux=0 nmi_watchdog=0 3 panic=1
[    0.000000] debug: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 896604k/915544k available (5344k kernel code, 18420k reserved, 2759k data, 392k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe18000 - 0xfffff000   (1948 kB)
[    0.000000]     vmalloc : 0xf8616000 - 0xffe16000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7e16000   ( 894 MB)
[    0.000000]       .init : 0xc17f1000 - 0xc1853000   ( 392 kB)
[    0.000000]       .data : 0xc1538001 - 0xc17e9c20   (2759 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1538001   (5344 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...BUG: Int 14: CR2 ffcff000
[    0.000000]      EDI 00000188  ESI 00000ac7  EBP c17eaf9c  ESP c17eaf8c
[    0.000000]      EBX 000014e0  EDX 0000000e  ECX 01856067  EAX 00000001
[    0.000000]      err 00000003  EIP c10135b1   CS 00000060  flg 00010002
[    0.000000] Stack: c17eafa8 c17fd410 c16747bc c17eafc4 c17fd7e5 000011fd f8616000 c18237cc
[    0.000000]        00099800 c17bb000 c17eafec c17f1668 000001c5 c17f1322 c166e039 c1822bf0
[    0.000000]        c166e033 c153a014 c18237cc 00020800 c17eaff8 c17f106a 00020800 01ba5003
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.30-tip-02161-g7a74539-dirty #52203
[    0.000000] Call Trace:
[    0.000000]  [<c15357c2>] ? printk+0x14/0x16
[    0.000000]  [<c10135b1>] ? do_test_wp_bit+0x19/0x23
[    0.000000]  [<c17fd410>] ? test_wp_bit+0x26/0x64
[    0.000000]  [<c17fd7e5>] ? mem_init+0x1ba/0x1d8
[    0.000000]  [<c17f1668>] ? start_kernel+0x164/0x2f7
[    0.000000]  [<c17f1322>] ? unknown_bootoption+0x0/0x19c
[    0.000000]  [<c17f106a>] ? __init_begin+0x6a/0x6f
[    0.000000] BUG: Int 14: CR2 (null)
[    0.000000]      EDI 00000188  ESI 00000ac7  EBP c17eaf9c  ESP c17eaf50
[    0.000000]      EBX 000014e0  EDX 0000000e  ECX c17eaf58  EAX (null)
[    0.000000]      err 00000002  EIP c100033a   CS 00000060  flg 00010046
[    0.000000] Stack: c1766036 0000000e ffcff000 00000188 00000ac7 c17eaf9c c17eaf8c 000014e0
[    0.000000]        0000000e 01856067 00000001 00000003 c10135b1 00000060 00010002 c17eafa8
[    0.000000]        c17fd410 c16747bc c17eafc4 c17fd7e5 000011fd f8616000 c18237cc 00099800
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.30-tip-02161-g7a74539-dirty #52203
[    0.000000] Call Trace:
[    0.000000]  [<c15357c2>] ? printk+0x14/0x16
[    0.000000]  [<c10135b1>] ? do_test_wp_bit+0x19/0x23
[    0.000000]  [<c17fd410>] ? test_wp_bit+0x26/0x64
[    0.000000]  [<c17fd7e5>] ? mem_init+0x1ba/0x1d8
[    0.000000]  [<c17f1668>] ? start_kernel+0x164/0x2f7
[    0.000000]  [<c17f1322>] ? unknown_bootoption+0x0/0x19c
[    0.000000]  [<c17f106a>] ? __init_begin+0x6a/0x6f


