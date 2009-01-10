Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbZAJNJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbZAJNJw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 08:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZAJNJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 08:09:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44430 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbZAJNJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 08:09:18 -0500
Date: Sat, 10 Jan 2009 14:07:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017
	ata_sff_hsm_move+0x45e/0x750()
Message-ID: <20090110130745.GA14049@elte.hu>
References: <200901091334.55823.borntraeger@de.ibm.com> <200901101009.13699.borntraeger@de.ibm.com> <20090110104114.633cacd8@lxorguk.ukuu.org.uk> <200901101242.05203.borntraeger@de.ibm.com> <49688B63.5030105@ru.mvista.com> <20090110122130.318cf168@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20090110122130.318cf168@lxorguk.ukuu.org.uk>
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


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> >    That's the typical REQUEST SENSE command with 18-byte data length.
> 
> Which means something has become horribly broken in the core libata 
> stack. An 18 byte inquiry would have 18 bytes as the *last* sg element. 
> That would therefore not trigger the WARN_ON. Someone has passed an sg 
> list that isn't properly terminated perhaps ?
> 
> I wonder if the pad code broke this.

note, one of my testboxes in the -tip testing hw pool (an older HP laptop) 
started triggering this too today:

[    3.834413] PM: Adding info for No Bus:8:0
[    3.835116] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.835237] driver: '0:0:0:0': driver_bound: bound to device 'sd'
[    3.835249] bus: 'scsi': really_probe: bound device 0:0:0:0 to driver sd
[    3.835272] device: '0:0:0:0': device_add
[    3.835374] PM: Adding info for No Bus:0:0:0:0
[    4.112738] ata2.00: ATAPI: QSI DVD-ROM SDR-081, EHA8, max UDMA/33
[    4.120617] ata2.00: configured for UDMA/33
[    4.121275] ------------[ cut here ]------------
[    4.121380] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x3d9/0x840()
[    4.121538] Hardware name: HP OmniBook PC         
[    4.121644] Pid: 0, comm: swapper Not tainted 2.6.28-tip-10029-g20e9954-dirty #3
[    4.121798] Call Trace:
[    4.121912]  [<c013d006>] warn_slowpath+0x86/0xa0
[    4.122030]  [<c012c5ee>] ? complete+0x4e/0x60
[    4.122136]  [<c0133270>] ? default_wake_function+0x10/0x20
[    4.122260]  [<c034e9bd>] ? _raw_spin_unlock+0x5d/0xa0
[    4.122368]  [<c012c5ee>] ? complete+0x4e/0x60
[    4.122490]  [<c06513d3>] ? ata_qc_complete_internal+0x13/0x20
[    4.122602]  [<c064f6ed>] ? __ata_qc_complete+0x6d/0xe0
[    4.122710]  [<c065e0a9>] ? ata_sff_qc_fill_rtf+0x19/0x30
[    4.122817]  [<c065fa07>] ? ata_sff_data_xfer32+0x77/0xd0
[    4.122923]  [<c0660739>] ata_sff_hsm_move+0x3d9/0x840
[    4.123029]  [<c034eb06>] ? _raw_spin_lock+0x46/0x170
[    4.123134]  [<c0660ef9>] ata_sff_interrupt+0x129/0x1e0
[    4.123246]  [<c0171dc0>] handle_IRQ_event+0x30/0x70
[    4.123354]  [<c0173b05>] handle_level_irq+0x75/0xe0
[    4.123459]  [<c0173a90>] ? handle_level_irq+0x0/0xe0
[    4.123562]  <IRQ>  [<c0104607>] ? common_interrupt+0x27/0x2c
[    4.123725]  [<c0120120>] ? native_safe_halt+0x0/0x10
[    4.123830]  [<c012012a>] ? native_safe_halt+0xa/0x10
[    4.123942]  [<c010aaf9>] ? default_idle+0x69/0xa0
[    4.124053]  [<c015f792>] ? tick_nohz_restart_sched_tick+0x32/0x1b0
[    4.124167]  [<c011715f>] ? apm_cpu_idle+0xdf/0x260
[    4.124273]  [<c01027d8>] ? cpu_idle+0x78/0x100
[    4.124379]  [<c034e9bd>] ? _raw_spin_unlock+0x5d/0xa0
[    4.124490]  [<c09a92b3>] ? rest_init+0x53/0x60
[    4.124601]  [<c0e4d82a>] ? start_kernel+0x2ba/0x360
[    4.124709]  [<c0e4d260>] ? unknown_bootoption+0x0/0x210
[    4.124820]  [<c0e4d07c>] ? i386_start_kernel+0x7c/0xb0
[    4.124948] ---[ end trace 83f9033b42a87df9 ]---
[    4.126783] scsi 1:0:0:0: CD-ROM            QSI      DVD-ROM SDR-081  EHA8 PQ: 0 ANSI: 5
[    4.126979] device: 'target1:0:0': device_add
[    4.127040] PM: Adding info for No Bus:target1:0:0
[    4.127057] device: '1:0:0:0': device_add
[    4.127191] bus: 'scsi': add device 1:0:0:0
[    4.127235] PM: Adding info for scsi:1:0:0:0
[    4.127994] bus: 'scsi': driver_probe_device: matched device 1:0:0:0 with driver osst

it did manage to boot up and it appears to limp along. Full bootlog below, 
config attached.

 last-known-good: 9e42d0cf5020aaf217433cad1a224745241d212a
 first-known-bad: 9a100a4464917b5ffff3a8ce1c2758088fd9bb32

Which implicates one of these commits:

a3a798c: Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6
efcb3cf: libata: use WARN_ON_ONCE on hot paths
b2576e1: Merge branch 'linus' into release
0fe40ff: libata: clean up the SFF code for coding style
871af12: libata: Add 32bit PIO support
e427fe0: [libata] ahci: Withdraw IGN_SERR_INTERNAL for SB800 SATA
6ecb6f2: pata_hpt366: reimplement mode programming
b63d395: [libata] pata_hpt3x3: correct _freeze() function declaration
5c18c4d: libata: Add special ata_pio_need_iordy() handling for Compact Flash.
78a7ba4: pata_platform: __pata_platform_remove() shouldn't be in discard section
1564a18: sata_sil24: remove unused sil24_port_multiplier
8522ee2: [libata] ahci: Add SATA GEN3 related messages
2852bcf: ata_piix: save, use saved and restore IOCFG
fc80902: pata_ali: Fix and workaround for FIFO DMA bug
1b2c357: pata_ali: force initialise a few bits
978ff6d: pata_hpt3x3: Workarounds for chipset
ea7e96e: ACPI: remove private acpica headers from driver files

	Ingo

-------------------->
[    0.000000] Linux version 2.6.28-tip-10029-g20e9954-dirty (mingo@mazsi) (gcc version 4.2.2) #3 SMP Sat Jan 10 13:49:31 CET 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] PAT WC disabled due to known CPU erratum.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8400 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
[    0.000000]  BIOS-e820: 000000001fff0000 - 000000001ffffc00 (ACPI data)
[    0.000000]  BIOS-e820: 000000001ffffc00 - 0000000020000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working it around.
[    0.000000] last_pfn = 0x1fff0 max_arch_pfn = 0x100000
[    0.000000] kernel direct mapping tables up to 1fff0000 @ 10000-16000
[    0.000000] RAMDISK: 1fd4d000 - 1ffdfef8
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 511MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1fff0000
[    0.000000]   low ram: 00000000 - 1fff0000
[    0.000000]   bootmap 00012000 - 00016000
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 001fff0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 0001401954]    TEXT DATA BSS ==> [0000100000 - 0001401954]
[    0.000000]   #4 [001fd4d000 - 001ffdfef8]          RAMDISK ==> [001fd4d000 - 001ffdfef8]
[    0.000000]   #5 [0001402000 - 0001409000]    INIT_PG_TABLE ==> [0001402000 - 0001409000]
[    0.000000]   #6 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #7 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #8 [0000012000 - 0000016000]          BOOTMAP ==> [0000012000 - 0000016000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001fff0
[    0.000000]   HighMem  0x0001fff0 -> 0x0001fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001fff0
[    0.000000] On node 0 totalpages: 130943
[    0.000000] free_area_init_node: node 0, pgdat c0e1e640, node_mem_map c1409340
[    0.000000]   DMA zone: 52 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3931 pages, LIFO batch:0
[    0.000000]   Normal zone: 1612 pages used for memmap
[    0.000000]   Normal zone: 125348 pages, LIFO batch:31
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e9000
[    0.000000] PM: Registered nosave memory: 00000000000e9000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 30000000 (gap: 20000000:dff80000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Allocating 45056 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129279
[    0.000000] Kernel command line: 
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c0ef5000 soft=c0eed000
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] TSC: Using PIT calibration value
[    0.000000] Detected 738.822 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.004000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.004000] ... MAX_LOCK_DEPTH:          48
[    0.004000] ... MAX_LOCKDEP_KEYS:        8191
[    0.004000] ... CLASSHASH_SIZE:          4096
[    0.004000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.004000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.004000] ... CHAINHASH_SIZE:          8192
[    0.004000]  memory used by lock dependency info: 2335 kB
[    0.004000]  per task-struct memory footprint: 1152 bytes
[    0.004000] ------------------------
[    0.004000] | Locking API testsuite:
[    0.004000] ----------------------------------------------------------------------------
[    0.004000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.004000]   --------------------------------------------------------------------------
[    0.004000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]   --------------------------------------------------------------------------
[    0.004000]               recursive read-lock:             |  ok  |             |failed|
[    0.004000]            recursive read-lock #2:             |  ok  |             |failed|
[    0.004000]             mixed read-write-lock:             |failed|             |failed|
[    0.004000]             mixed write-read-lock:             |failed|             |failed|
[    0.004000]   --------------------------------------------------------------------------
[    0.004000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.004000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.004000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.004000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.004000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[    0.004000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
[    0.004000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.004000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.004000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.004000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.004000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.004000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.004000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.004000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.004000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.004000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.004000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.004000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.004000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.004000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.004000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.004000]       soft-irq lock-inversion/321:failed|failed|  ok  |
[    0.004000]       hard-irq read-recursion/123:  ok  |
[    0.004000]       soft-irq read-recursion/123:  ok  |
[    0.004000]       hard-irq read-recursion/132:  ok  |
[    0.004000]       soft-irq read-recursion/132:  ok  |
[    0.004000]       hard-irq read-recursion/213:  ok  |
[    0.004000]       soft-irq read-recursion/213:  ok  |
[    0.004000]       hard-irq read-recursion/231:  ok  |
[    0.004000]       soft-irq read-recursion/231:  ok  |
[    0.004000]       hard-irq read-recursion/312:  ok  |
[    0.004000]       soft-irq read-recursion/312:  ok  |
[    0.004000]       hard-irq read-recursion/321:  ok  |
[    0.004000]       soft-irq read-recursion/321:  ok  |
[    0.004000] --------------------------------------------------------
[    0.004000] 133 out of 218 testcases failed, as expected. |
[    0.004000] ----------------------------------------------------
[    0.004000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.004000] Memory: 494256k/524224k available (9280k kernel code, 29332k reserved, 4301k data, 628k init, 0k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xffee1000 - 0xfffff000   (1144 kB)
[    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.004000]     vmalloc : 0xe07f0000 - 0xff7fe000   ( 496 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
[    0.004000]       .init : 0xc0e4d000 - 0xc0eea000   ( 628 kB)
[    0.004000]       .data : 0xc0a102c0 - 0xc0e43824   (4301 kB)
[    0.004000]       .text : 0xc0100000 - 0xc0a102c0   (9280 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.004000] SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.004041] Calibrating delay loop (skipped), value calculated using timer frequency.. 1477.64 BogoMIPS (lpj=2955288)
[    0.004452] Security Framework initialized
[    0.004782] Mount-cache hash table entries: 512
[    0.006575] CPU: L1 I cache: 16K, L1 D cache: 16K
[    0.006726] CPU: L2 cache: 256K
[    0.006904] Checking 'hlt' instruction... OK.
[    0.022350] SMP alternatives: switching to UP code
[    1.160176] Freeing SMP alternatives: 29k freed
[    1.160317] ftrace: converting mcount calls to 0f 1f 44 00 00
[    1.160449] ftrace: allocating 23916 entries in 94 pages
[    1.169618] weird, boot CPU (#0) not listed by the BIOS.
[    1.169753] SMP motherboard not detected.
[    1.169855] Local APIC not detected. Using dummy APIC emulation.
[    1.169961] SMP disabled
[    1.184891] Brought up 1 CPUs
[    1.185028] Total of 1 processors activated (1477.64 BogoMIPS).
[    1.185327] CPU0 attaching NULL sched-domain.
[    1.186431] device: 'platform': device_add
[    1.186549] PM: Adding info for No Bus:platform
[    1.187632] khelper used greatest stack depth: 3248 bytes left
[    1.188132] bus: 'platform': registered
[    1.188160] Registering sysdev class 'cpu'
[    1.189674] net_namespace: 696 bytes
[    1.190194] Booting paravirtualized kernel on bare hardware
[    1.191935] xor: automatically using best checksumming function: pIII_sse
[    1.212017]    pIII_sse  :  1491.000 MB/sec
[    1.212120] xor: using function: pIII_sse (1491.000 MB/sec)
[    1.212236] regulator: core version 0.5
[    1.212332] device class 'regulator': registering
[    1.212938] Time: 13:50:57  Date: 01/10/09
[    1.213702] bus: 'virtio': registered
[    1.214180] NET: Registered protocol family 16
[    1.214439] device class 'bdi': registering
[    1.215439] device class 'gpio': registering
[    1.216291] device class 'pci_bus': registering
[    1.217638] bus: 'pci': registered
[    1.217653] device class 'lcd': registering
[    1.218201] device class 'backlight': registering
[    1.218747] device class 'video_output': registering
[    1.219279] device class 'tty': registering
[    1.219846] device class 'vtconsole': registering
[    1.220720] device: 'vtcon0': device_add
[    1.220861] PM: Adding info for No Bus:vtcon0
[    1.222150] bus: 'spi': registered
[    1.222160] device class 'spi_master': registering
[    1.222787] khelper used greatest stack depth: 3184 bytes left
[    1.223654] bus: 'i2c': registered
[    1.223664] device class 'i2c-adapter': registering
[    1.224258] bus: 'i2c': add driver dummy
[    1.224896] i2c-core: driver [dummy] registered
[    1.225097] device class 'dmi': registering
[    1.225753] device: 'id': device_add
[    1.225966] PM: Adding info for No Bus:id
[    1.226705] device class 'dma': registering
[    1.227380] dca service started, version 1.4
[    1.227501] device class 'dca': registering
[    1.231497] PCI: PCI BIOS revision 2.10 entry at 0xfd980, last bus=1
[    1.231624] PCI: Using configuration type 1 for base access
[    1.231764] Registering sys device of class 'cpu'
[    1.231814] Registering sys device 'cpu0'
[    1.233241] bus: 'MCA': registered
[    1.710918] device: 'default': device_add
[    1.711009] PM: Adding info for No Bus:default
[    1.711778] bio: create slab <bio-0> at 0
[    1.712535] device class 'block': registering
[    1.713001] bus: 'spi': add driver max7301
[    1.713790] bus: 'i2c': add driver max732x
[    1.714394] i2c-core: driver [max732x] registered
[    1.714412] bus: 'spi': add driver mcp23s08
[    1.715019] bus: 'i2c': add driver pca953x
[    1.715623] i2c-core: driver [pca953x] registered
[    1.715641] bus: 'i2c': add driver pcf857x
[    1.716939] i2c-core: driver [pcf857x] registered
[    1.716962] bus: 'platform': add driver twl4030_gpio
[    1.717744] device class 'graphics': registering
[    1.718316] bus: 'platform': add driver bq24022
[    1.718970] bus: 'platform': remove driver bq24022
[    1.719526] driver: 'bq24022': driver_release
[    1.719577] device class 'misc': registering
[    1.720845] bus: 'i2c': add driver twl4030
[    1.721503] khelper used greatest stack depth: 3180 bytes left
[    1.721752] i2c-core: driver [twl4030] registered
[    1.721767] device class 'mdio_bus': registering
[    1.722970] bus: 'mdio_bus': registered
[    1.722983] bus: 'mdio_bus': add driver Generic PHY
[    1.723570] device class 'dvb': registering
[    1.726052] device class 'scsi_host': registering
[    1.727731] bus: 'scsi': registered
[    1.727744] device class 'scsi_device': registering
[    1.728650] SCSI subsystem initialized
[    1.729316] libata version 3.00 loaded.
[    1.729328] device class 'pcmcia_socket': registering
[    1.730105] bus: 'platform': add driver twl4030_usb
[    1.731605] bus: 'usb': registered
[    1.731621] device class 'usb_host': registering
[    1.733339] bus: 'usb': add driver usbfs
[    1.734054] usbcore: registered new interface driver usbfs
[    1.734212] bus: 'usb': add driver hub
[    1.734790] usbcore: registered new interface driver hub
[    1.735135] bus: 'usb': add driver usb
[    1.735832] usbcore: registered new device driver usb
[    1.736691] bus: 'serio': registered
[    1.736911] device class 'input': registering
[    1.737729] device class 'rtc': registering
[    1.738401] device class 'power_supply': registering
[    1.739012] device class 'hwmon': registering
[    1.739612] device class 'thermal': registering
[    1.741078] device class 'leds': registering
[    1.741743] PCI: Probing PCI hardware
[    1.741948] PCI: Probing PCI hardware (bus 00)
[    1.741993] device: 'pci0000:00': device_add
[    1.742052] PM: Adding info for No Bus:pci0000:00
[    1.742067] device: '0000:00': device_add
[    1.742146] PM: Adding info for No Bus:0000:00
[    1.742923] pci 0000:00:00.0: reg 10 32bit mmio: [0xf8000000-0xfbffffff]
[    1.743380] pci 0000:00:07.1: reg 20 io port: [0x1c20-0x1c2f]
[    1.743535] pci 0000:00:07.2: reg 20 io port: [0x1c00-0x1c1f]
[    1.743723] pci 0000:00:07.3: quirk: region 8000-803f claimed by PIIX4 ACPI
[    1.743843] pci 0000:00:07.3: quirk: region 2180-218f claimed by PIIX4 SMB
[    1.743967] pci 0000:00:07.3: PIIX4 devres E PIO at 0378-037f
[    1.744042] pci 0000:00:07.3: PIIX4 devres I PIO at 0398-0399
[    1.744263] pci 0000:00:0a.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    1.744316] pci 0000:00:0a.0: supports D1 D2
[    1.744324] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.744439] pci 0000:00:0a.0: PME# disabled
[    1.744632] pci 0000:00:0a.1: reg 10 32bit mmio: [0x000000-0x000fff]
[    1.744683] pci 0000:00:0a.1: supports D1 D2
[    1.744691] pci 0000:00:0a.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.744805] pci 0000:00:0a.1: PME# disabled
[    1.745014] pci 0000:00:0b.0: reg 10 io port: [0x1000-0x10ff]
[    1.745035] pci 0000:00:0b.0: reg 14 32bit mmio: [0xf4002400-0xf400247f]
[    1.745056] pci 0000:00:0b.0: reg 18 32bit mmio: [0xf4002000-0xf400207f]
[    1.745110] pci 0000:00:0b.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    1.745160] pci 0000:00:0b.0: supports D1 D2
[    1.745168] pci 0000:00:0b.0: PME# supported from D1 D2 D3hot D3cold
[    1.745280] pci 0000:00:0b.0: PME# disabled
[    1.745470] pci 0000:00:0b.1: reg 10 io port: [0x1400-0x14ff]
[    1.745491] pci 0000:00:0b.1: reg 14 32bit mmio: [0xf4002c00-0xf4002cff]
[    1.745512] pci 0000:00:0b.1: reg 18 32bit mmio: [0xf4002800-0xf400287f]
[    1.745606] pci 0000:00:0b.1: supports D2
[    1.745614] pci 0000:00:0b.1: PME# supported from D2 D3hot D3cold
[    1.745724] pci 0000:00:0b.1: PME# disabled
[    1.745934] pci 0000:00:0d.0: reg 10 io port: [0x1800-0x18ff]
[    1.745957] pci 0000:00:0d.0: reg 14 32bit mmio: [0xf4000000-0xf4001fff]
[    1.746066] pci 0000:00:0d.0: supports D1 D2
[    1.746074] pci 0000:00:0d.0: PME# supported from D1 D2 D3hot
[    1.746186] pci 0000:00:0d.0: PME# disabled
[    1.746472] pci 0000:01:00.0: reg 10 32bit mmio: [0xf5000000-0xf5ffffff]
[    1.746494] pci 0000:01:00.0: reg 14 io port: [0x9000-0x90ff]
[    1.746515] pci 0000:01:00.0: reg 18 32bit mmio: [0xf4100000-0xf4100fff]
[    1.746569] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    1.746635] pci 0000:01:00.0: supports D1 D2
[    1.746755] pci 0000:00:01.0: bridge io port: [0x9000-0x9fff]
[    1.746769] pci 0000:00:01.0: bridge 32bit mmio: [0xf4100000-0xf5ffffff]
[    1.746970] device: '0000:00:00.0': device_add
[    1.747010] bus: 'pci': add device 0000:00:00.0
[    1.747178] PM: Adding info for pci:0000:00:00.0
[    1.748720] device: '0000:00:01.0': device_add
[    1.748782] bus: 'pci': add device 0000:00:01.0
[    1.748921] PM: Adding info for pci:0000:00:01.0
[    1.749620] device: '0000:00:07.0': device_add
[    1.749659] bus: 'pci': add device 0000:00:07.0
[    1.749823] PM: Adding info for pci:0000:00:07.0
[    1.750388] device: '0000:00:07.1': device_add
[    1.750451] bus: 'pci': add device 0000:00:07.1
[    1.750585] PM: Adding info for pci:0000:00:07.1
[    1.751175] device: '0000:00:07.2': device_add
[    1.751213] bus: 'pci': add device 0000:00:07.2
[    1.751349] PM: Adding info for pci:0000:00:07.2
[    1.751903] device: '0000:00:07.3': device_add
[    1.752098] bus: 'pci': add device 0000:00:07.3
[    1.752236] PM: Adding info for pci:0000:00:07.3
[    1.752833] device: '0000:00:0a.0': device_add
[    1.752870] bus: 'pci': add device 0000:00:0a.0
[    1.753006] PM: Adding info for pci:0000:00:0a.0
[    1.753571] device: '0000:00:0a.1': device_add
[    1.753609] bus: 'pci': add device 0000:00:0a.1
[    1.753774] PM: Adding info for pci:0000:00:0a.1
[    1.754342] device: '0000:00:0b.0': device_add
[    1.754379] bus: 'pci': add device 0000:00:0b.0
[    1.754515] PM: Adding info for pci:0000:00:0b.0
[    1.755067] device: '0000:00:0b.1': device_add
[    1.755104] bus: 'pci': add device 0000:00:0b.1
[    1.755270] PM: Adding info for pci:0000:00:0b.1
[    1.755831] device: '0000:00:0d.0': device_add
[    1.755869] bus: 'pci': add device 0000:00:0d.0
[    1.756818] PM: Adding info for pci:0000:00:0d.0
[    1.757564] device: '0000:01:00.0': device_add
[    1.757612] bus: 'pci': add device 0000:01:00.0
[    1.757788] PM: Adding info for pci:0000:01:00.0
[    1.758397] device: '0000:01': device_add
[    1.758524] PM: Adding info for No Bus:0000:01
[    1.759143] device: '0000:02': device_add
[    1.759232] PM: Adding info for No Bus:0000:02
[    1.759820] device: '0000:06': device_add
[    1.759906] PM: Adding info for No Bus:0000:06
[    1.760970] pci 0000:00:07.0: PIIX/ICH IRQ router [8086:7110]
[    1.761309] PCI: setting IRQ 10 as level-triggered
[    1.761319] pci 0000:00:0a.0: found PCI INT A -> IRQ 10
[    1.761528] pci 0000:00:0a.0: sharing IRQ 10 with 0000:00:0b.0
[    1.761646] pci 0000:00:0a.0: sharing IRQ 10 with 0000:00:0b.1
[    1.761803] pci 0000:00:0a.1: found PCI INT B -> IRQ 10
[    1.762046] pci 0000:00:0a.1: sharing IRQ 10 with 0000:01:00.0
[    1.762661] device class 'net': registering
[    1.763485] device: 'lo': device_add
[    1.763896] PM: Adding info for No Bus:lo
[    1.765731] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
[    1.765731] Bluetooth: Core ver 2.14
[    1.765731] device class 'bluetooth': registering
[    1.768576] NET: Registered protocol family 31
[    1.768690] Bluetooth: HCI device and connection manager initialized
[    1.768905] Bluetooth: HCI socket layer initialized
[    1.769009] NET: Registered protocol family 8
[    1.769108] NET: Registered protocol family 20
[    1.769293] device class 'atm': registering
[    1.771004] device class 'mem': registering
[    1.771700] device: 'mem': device_add
[    1.771787] PM: Adding info for No Bus:mem
[    1.772731] device: 'kmem': device_add
[    1.772812] PM: Adding info for No Bus:kmem
[    1.773380] device: 'null': device_add
[    1.773483] PM: Adding info for No Bus:null
[    1.774047] device: 'port': device_add
[    1.774122] PM: Adding info for No Bus:port
[    1.774684] device: 'zero': device_add
[    1.774760] PM: Adding info for No Bus:zero
[    1.775369] device: 'full': device_add
[    1.775445] PM: Adding info for No Bus:full
[    1.776069] device: 'random': device_add
[    1.776148] PM: Adding info for No Bus:random
[    1.776717] device: 'urandom': device_add
[    1.776797] PM: Adding info for No Bus:urandom
[    1.777340] device: 'kmsg': device_add
[    1.777446] PM: Adding info for No Bus:kmsg
[    1.778016] device class 'firmware': registering
[    1.779232] bus: 'pcmcia': registered
[    1.780155] bus: 'ssb': registered
[    1.780625] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    1.780753] pci 0000:00:01.0:   IO window: 0x9000-0x9fff
[    1.780865] pci 0000:00:01.0:   MEM window: 0xf4100000-0xf5ffffff
[    1.780979] pci 0000:00:01.0:   PREFETCH window: 0x00000040000000-0x000000400fffff
[    1.781147] pci 0000:00:0a.0: CardBus bridge, secondary bus 0000:02
[    1.781252] pci 0000:00:0a.0:   IO window: 0x002000-0x0020ff
[    1.781362] pci 0000:00:0a.0:   IO window: 0x002400-0x0024ff
[    1.781473] pci 0000:00:0a.0:   PREFETCH window: 0x30000000-0x33ffffff
[    1.781586] pci 0000:00:0a.0:   MEM window: 0x34000000-0x37ffffff
[    1.781698] pci 0000:00:0a.1: CardBus bridge, secondary bus 0000:06
[    1.781803] pci 0000:00:0a.1:   IO window: 0x002800-0x0028ff
[    1.781911] pci 0000:00:0a.1:   IO window: 0x002c00-0x002cff
[    1.782022] pci 0000:00:0a.1:   PREFETCH window: 0x38000000-0x3bffffff
[    1.782135] pci 0000:00:0a.1:   MEM window: 0x3c000000-0x3fffffff
[    1.782285] pci 0000:00:0a.0: found PCI INT A -> IRQ 10
[    1.782533] pci 0000:00:0a.0: sharing IRQ 10 with 0000:00:0b.0
[    1.782657] pci 0000:00:0a.0: sharing IRQ 10 with 0000:00:0b.1
[    1.782814] pci 0000:00:0a.0: setting latency timer to 64
[    1.782840] pci 0000:00:0a.1: found PCI INT B -> IRQ 10
[    1.783126] pci 0000:00:0a.1: sharing IRQ 10 with 0000:01:00.0
[    1.783250] pci 0000:00:0a.1: setting latency timer to 64
[    1.783266] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    1.783275] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    1.783285] pci_bus 0000:01: resource 0 io:  [0x9000-0x9fff]
[    1.783294] pci_bus 0000:01: resource 1 mem: [0xf4100000-0xf5ffffff]
[    1.783303] pci_bus 0000:01: resource 2 mem: [0x40000000-0x400fffff]
[    1.783311] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    1.783320] pci_bus 0000:02: resource 0 io:  [0x2000-0x20ff]
[    1.783329] pci_bus 0000:02: resource 1 io:  [0x2400-0x24ff]
[    1.783338] pci_bus 0000:02: resource 2 mem: [0x30000000-0x33ffffff]
[    1.783347] pci_bus 0000:02: resource 3 mem: [0x34000000-0x37ffffff]
[    1.783356] pci_bus 0000:06: resource 0 io:  [0x2800-0x28ff]
[    1.783365] pci_bus 0000:06: resource 1 io:  [0x2c00-0x2cff]
[    1.783374] pci_bus 0000:06: resource 2 mem: [0x38000000-0x3bffffff]
[    1.783383] pci_bus 0000:06: resource 3 mem: [0x3c000000-0x3fffffff]
[    1.783645] NET: Registered protocol family 2
[    1.786368] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    1.789372] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    1.790380] TCP bind hash table entries: 16384 (order: 7, 524288 bytes)
[    1.794068] TCP: Hash tables configured (established 16384 bind 16384)
[    1.794335] TCP reno registered
[    1.795632] NET: Registered protocol family 1
[    1.797439] checking if image is initramfs... it is
[    2.328009] Freeing initrd memory: 2635k freed
[    2.328263] Registering sysdev class 'i8259'
[    2.329368] khelper used greatest stack depth: 3160 bytes left
[    2.329654] Registering sys device of class 'i8259'
[    2.329696] Registering sys device 'i82590'
[    2.330356] Registering sysdev class 'i8237'
[    2.330957] Registering sys device of class 'i8237'
[    2.330987] Registering sys device 'i82370'
[    2.331615] Registering platform device 'rtc_cmos'. Parent at platform
[    2.331627] device: 'rtc_cmos': device_add
[    2.331671] bus: 'platform': add device rtc_cmos
[    2.331736] PM: Adding info for platform:rtc_cmos
[    2.332428] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    2.332630] device class 'msr': registering
[    2.333287] device: 'msr0': device_add
[    2.333373] PM: Adding info for No Bus:msr0
[    2.334093] device class 'cpuid': registering
[    2.334741] device: 'cpu0': device_add
[    2.334821] PM: Adding info for No Bus:cpu0
[    2.335553] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[    2.336020] device: 'apm_bios': device_add
[    2.336214] PM: Adding info for No Bus:apm_bios
[    2.337828] Registering sysdev class 'ioapic'
[    2.338470] Registering platform device 'pcspkr'. Parent at platform
[    2.338482] device: 'pcspkr': device_add
[    2.338517] bus: 'platform': add device pcspkr
[    2.338577] PM: Adding info for platform:pcspkr
[    2.339168] scx200: NatSemi SCx200 Driver
[    2.339286] bus: 'pci': add driver scx200
[    2.340033] microcode: no support for this CPU vendor
[    2.341190] Registering sysdev class 'timekeeping'
[    2.341918] Registering sys device of class 'timekeeping'
[    2.341948] Registering sys device 'timekeeping0'
[    2.342498] Registering sysdev class 'clocksource'
[    2.343192] Registering sys device of class 'clocksource'
[    2.343225] Registering sys device 'clocksource0'
[    2.343950] Registering sysdev class 'rttest'
[    2.346727] Registering sys device of class 'rttest'
[    2.346785] Registering sys device 'rttest0'
[    2.347626] Registering sys device of class 'rttest'
[    2.347656] Registering sys device 'rttest1'
[    2.348571] Registering sys device of class 'rttest'
[    2.348603] Registering sys device 'rttest2'
[    2.349412] Registering sys device of class 'rttest'
[    2.349440] Registering sys device 'rttest3'
[    2.350361] Registering sys device of class 'rttest'
[    2.350394] Registering sys device 'rttest4'
[    2.351193] Registering sys device of class 'rttest'
[    2.351225] Registering sys device 'rttest5'
[    2.352410] Registering sys device of class 'rttest'
[    2.352456] Registering sys device 'rttest6'
[    2.353464] Registering sys device of class 'rttest'
[    2.353499] Registering sys device 'rttest7'
[    2.354110] Initializing RT-Tester: OK
[    2.354301] device: 'snapshot': device_add
[    2.354395] PM: Adding info for No Bus:snapshot
[    2.452145] VFS: Disk quotas dquot_6.5.2
[    2.453690] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.458167] device: 'dlm-control': device_add
[    2.458269] PM: Adding info for No Bus:dlm-control
[    2.458955] device: 'dlm-monitor': device_add
[    2.459040] PM: Adding info for No Bus:dlm-monitor
[    2.459721] device: 'dlm_plock': device_add
[    2.459805] PM: Adding info for No Bus:dlm_plock
[    2.460468] DLM (built Jan 10 2009 13:28:42) installed
[    2.484899] NTFS driver 2.1.29 [Flags: R/W].
[    2.491987] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    2.497034] QNX4 filesystem 0.2.3 registered.
[    2.497182] device: 'autofs': device_add
[    2.497296] PM: Adding info for No Bus:autofs
[    2.497965] fuse init (API version 7.11)
[    2.500248] device: 'fuse': device_add
[    2.500341] PM: Adding info for No Bus:fuse
[    2.502107] msgmni has been set to 970
[    2.505624] cryptomgr_test used greatest stack depth: 2112 bytes left
[    2.519533] alg: No test for stdrng (krng)
[    2.520039] alg: No test for stdrng (ansi_cprng)
[    2.521324] async_tx: api initialized (async)
[    2.521651] io scheduler noop registered
[    2.521753] io scheduler deadline registered
[    2.524394] io scheduler cfq registered (default)
[    2.533445] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.533644] pci 0000:00:07.2: uhci_check_and_reset_hc: legsup = 0x2000
[    2.533653] pci 0000:00:07.2: Performing full reset
[    2.533776] pci 0000:01:00.0: Boot video device
[    2.535261] bus: 'pci_express': registered
[    2.535279] bus: 'pci': add driver pcieport-driver
[    2.535322] bus: 'pci': driver_probe_device: matched device 0000:00:01.0 with driver pcieport-driver
[    2.535334] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:01.0
[    2.536342] bus: 'pci_express': add driver aer
[    2.536967] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.537088] bus: 'pci': add driver shpchp
[    2.537129] bus: 'pci': driver_probe_device: matched device 0000:00:01.0 with driver shpchp
[    2.537139] bus: 'pci': really_probe: probing driver shpchp with device 0000:00:01.0
[    2.537888] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    2.538003] fakephp: Fake PCI Hot Plug Controller Driver
[    2.543763] bus: 'spi': add driver ltv350qv
[    2.544444] bus: 'platform': add driver platform-lcd
[    2.545068] bus: 'platform': add driver generic-bl
[    2.545722] bus: 'platform': add driver progear-bl
[    2.546394] Registering platform device 'progear-bl'. Parent at platform
[    2.546405] device: 'progear-bl': device_add
[    2.546448] bus: 'platform': add device progear-bl
[    2.546514] PM: Adding info for platform:progear-bl
[    2.547122] bus: 'platform': driver_probe_device: matched device progear-bl with driver progear-bl
[    2.547135] bus: 'platform': really_probe: probing driver progear-bl with device progear-bl
[    2.547198] ALI M7101 PMU not found.
[    2.547368] bus: 'platform': add driver cr_backlight
[    2.548027] Registering platform device 'cr_backlight'. Parent at platform
[    2.548039] device: 'cr_backlight': device_add
[    2.548386] bus: 'platform': add device cr_backlight
[    2.548480] PM: Adding info for platform:cr_backlight
[    2.549135] bus: 'platform': driver_probe_device: matched device cr_backlight with driver cr_backlight
[    2.549149] bus: 'platform': really_probe: probing driver cr_backlight with device cr_backlight
[    2.549214] INTEL CARILLO RANCH LPC not found.
[    2.549376] Carillo Ranch Backlight Driver Initialized.
[    2.549498] bus: 'pci': add driver CyberPro
[    2.550191] bus: 'pci': add driver pm2fb
[    2.550862] bus: 'pci': add driver pm3fb
[    2.551507] bus: 'pci': add driver matroxfb
[    2.552215] bus: 'pci': add driver rivafb
[    2.552892] bus: 'pci': add driver atyfb
[    2.553619] bus: 'pci': add driver aty128fb
[    2.554449] bus: 'pci': add driver sisfb
[    2.555107] bus: 'pci': add driver savagefb
[    2.555796] bus: 'pci': add driver neofb
[    2.557488] bus: 'pci': add driver tdfxfb
[    2.558208] bus: 'pci': add driver imsttfb
[    2.558869] vmlfb: initializing
[    2.558884] bus: 'pci': add driver vmlfb
[    2.559580] Could not find Carillo Ranch MCH device.
[    2.559711] bus: 'pci': add driver s3fb
[    2.560482] bus: 'platform': add driver hecubafb
[    2.561119] bus: 'platform': add driver hgafb
[    2.561782] Registering platform device 'hgafb.0'. Parent at platform
[    2.561793] device: 'hgafb.0': device_add
[    2.561833] bus: 'platform': add device hgafb.0
[    2.561899] PM: Adding info for platform:hgafb.0
[    2.562483] bus: 'platform': driver_probe_device: matched device hgafb.0 with driver hgafb
[    2.562495] bus: 'platform': really_probe: probing driver hgafb with device hgafb.0
[    2.562587] hgafb: HGA card not detected.
[    2.562755] hgafb: probe of hgafb.0 failed with error -22
[    2.562883] bus: 'pci': add driver sstfb
[    2.563590] bus: 'platform': add driver tmio-fb
[    2.565244] bus: 'platform': add driver metronomefb
[    2.566052] bus: 'pci': add driver carminefb
[    2.566722] bus: 'platform': add driver uvesafb
[    2.567360] Registering platform device 'uvesafb.0'. Parent at platform
[    2.567372] device: 'uvesafb.0': device_add
[    2.567411] bus: 'platform': add device uvesafb.0
[    2.567476] PM: Adding info for platform:uvesafb.0
[    2.568168] bus: 'platform': driver_probe_device: matched device uvesafb.0 with driver uvesafb
[    2.568181] bus: 'platform': really_probe: probing driver uvesafb with device uvesafb.0
[    2.569231] uvesafb: failed to execute /sbin/v86d
[    2.569351] uvesafb: make sure that the v86d helper is installed and executable
[    2.569533] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    2.569649] uvesafb: vbe_init() failed with -22
[    2.569849] uvesafb: probe of uvesafb.0 failed with error -22
[    2.569992] bus: 'platform': add driver reg-virt-consumer
[    2.570709] bus: 'platform': add driver wm8400-regulator
[    2.571515] device: 'tty': device_add
[    2.571608] PM: Adding info for No Bus:tty
[    2.573356] device: 'console': device_add
[    2.573494] PM: Adding info for No Bus:console
[    2.574262] device: 'tty0': device_add
[    2.574345] PM: Adding info for No Bus:tty0
[    2.574960] device class 'vc': registering
[    2.575587] device: 'vcs': device_add
[    2.575669] PM: Adding info for No Bus:vcs
[    2.576422] device: 'vcsa': device_add
[    2.576504] PM: Adding info for No Bus:vcsa
[    2.577253] device: 'tty1': device_add
[    2.577342] PM: Adding info for No Bus:tty1
[    2.577966] device: 'tty2': device_add
[    2.578045] PM: Adding info for No Bus:tty2
[    2.578626] device: 'tty3': device_add
[    2.578732] PM: Adding info for No Bus:tty3
[    2.579326] device: 'tty4': device_add
[    2.579402] PM: Adding info for No Bus:tty4
[    2.581103] device: 'tty5': device_add
[    2.581230] PM: Adding info for No Bus:tty5
[    2.582102] device: 'tty6': device_add
[    2.582226] PM: Adding info for No Bus:tty6
[    2.582831] device: 'tty7': device_add
[    2.582910] PM: Adding info for No Bus:tty7
[    2.583488] device: 'tty8': device_add
[    2.583570] PM: Adding info for No Bus:tty8
[    2.584938] device: 'tty9': device_add
[    2.585053] PM: Adding info for No Bus:tty9
[    2.585785] device: 'tty10': device_add
[    2.585900] PM: Adding info for No Bus:tty10
[    2.586531] device: 'tty11': device_add
[    2.586612] PM: Adding info for No Bus:tty11
[    2.587210] device: 'tty12': device_add
[    2.587290] PM: Adding info for No Bus:tty12
[    2.587875] device: 'tty13': device_add
[    2.587957] PM: Adding info for No Bus:tty13
[    2.588648] device: 'tty14': device_add
[    2.588733] PM: Adding info for No Bus:tty14
[    2.589381] device: 'tty15': device_add
[    2.589470] PM: Adding info for No Bus:tty15
[    2.590071] device: 'tty16': device_add
[    2.590185] PM: Adding info for No Bus:tty16
[    2.590784] device: 'tty17': device_add
[    2.590868] PM: Adding info for No Bus:tty17
[    2.591491] device: 'tty18': device_add
[    2.591577] PM: Adding info for No Bus:tty18
[    2.592827] device: 'tty19': device_add
[    2.592940] PM: Adding info for No Bus:tty19
[    2.593650] device: 'tty20': device_add
[    2.593740] PM: Adding info for No Bus:tty20
[    2.594346] device: 'tty21': device_add
[    2.594433] PM: Adding info for No Bus:tty21
[    2.595009] device: 'tty22': device_add
[    2.595096] PM: Adding info for No Bus:tty22
[    2.595675] device: 'tty23': device_add
[    2.595792] PM: Adding info for No Bus:tty23
[    2.596462] device: 'tty24': device_add
[    2.596589] PM: Adding info for No Bus:tty24
[    2.597189] device: 'tty25': device_add
[    2.597280] PM: Adding info for No Bus:tty25
[    2.597887] device: 'tty26': device_add
[    2.597975] PM: Adding info for No Bus:tty26
[    2.598580] device: 'tty27': device_add
[    2.598701] PM: Adding info for No Bus:tty27
[    2.599356] device: 'tty28': device_add
[    2.599451] PM: Adding info for No Bus:tty28
[    2.601069] device: 'tty29': device_add
[    2.601245] PM: Adding info for No Bus:tty29
[    2.602005] device: 'tty30': device_add
[    2.602108] PM: Adding info for No Bus:tty30
[    2.602716] device: 'tty31': device_add
[    2.602806] PM: Adding info for No Bus:tty31
[    2.603386] device: 'tty32': device_add
[    2.603476] PM: Adding info for No Bus:tty32
[    2.604063] device: 'tty33': device_add
[    2.604225] PM: Adding info for No Bus:tty33
[    2.604831] device: 'tty34': device_add
[    2.604928] PM: Adding info for No Bus:tty34
[    2.605506] device: 'tty35': device_add
[    2.605599] PM: Adding info for No Bus:tty35
[    2.606193] device: 'tty36': device_add
[    2.606317] PM: Adding info for No Bus:tty36
[    2.607015] device: 'tty37': device_add
[    2.607127] PM: Adding info for No Bus:tty37
[    2.607716] device: 'tty38': device_add
[    2.607811] PM: Adding info for No Bus:tty38
[    2.609360] device: 'tty39': device_add
[    2.609497] PM: Adding info for No Bus:tty39
[    2.610173] device: 'tty40': device_add
[    2.610271] PM: Adding info for No Bus:tty40
[    2.610853] device: 'tty41': device_add
[    2.610949] PM: Adding info for No Bus:tty41
[    2.611525] device: 'tty42': device_add
[    2.611651] PM: Adding info for No Bus:tty42
[    2.612419] device: 'tty43': device_add
[    2.612562] PM: Adding info for No Bus:tty43
[    2.613204] device: 'tty44': device_add
[    2.613296] PM: Adding info for No Bus:tty44
[    2.613899] device: 'tty45': device_add
[    2.613995] PM: Adding info for No Bus:tty45
[    2.614613] device: 'tty46': device_add
[    2.614795] PM: Adding info for No Bus:tty46
[    2.615397] device: 'tty47': device_add
[    2.615524] PM: Adding info for No Bus:tty47
[    2.617052] device: 'tty48': device_add
[    2.617197] PM: Adding info for No Bus:tty48
[    2.618013] device: 'tty49': device_add
[    2.618157] PM: Adding info for No Bus:tty49
[    2.618794] device: 'tty50': device_add
[    2.618891] PM: Adding info for No Bus:tty50
[    2.619500] device: 'tty51': device_add
[    2.619593] PM: Adding info for No Bus:tty51
[    2.621147] device: 'tty52': device_add
[    2.621307] PM: Adding info for No Bus:tty52
[    2.622039] device: 'tty53': device_add
[    2.622146] PM: Adding info for No Bus:tty53
[    2.622761] device: 'tty54': device_add
[    2.622858] PM: Adding info for No Bus:tty54
[    2.623464] device: 'tty55': device_add
[    2.623562] PM: Adding info for No Bus:tty55
[    2.624245] device: 'tty56': device_add
[    2.624381] PM: Adding info for No Bus:tty56
[    2.625067] device: 'tty57': device_add
[    2.625172] PM: Adding info for No Bus:tty57
[    2.625776] device: 'tty58': device_add
[    2.625876] PM: Adding info for No Bus:tty58
[    2.626474] device: 'tty59': device_add
[    2.626577] PM: Adding info for No Bus:tty59
[    2.627164] device: 'tty60': device_add
[    2.627266] PM: Adding info for No Bus:tty60
[    2.627889] device: 'tty61': device_add
[    2.628030] PM: Adding info for No Bus:tty61
[    2.629689] device: 'tty62': device_add
[    2.629857] PM: Adding info for No Bus:tty62
[    2.630490] device: 'tty63': device_add
[    2.630595] PM: Adding info for No Bus:tty63
[    2.631686] device: 'ptyp0': device_add
[    2.631813] PM: Adding info for No Bus:ptyp0
[    2.632589] device: 'ptyp1': device_add
[    2.632698] PM: Adding info for No Bus:ptyp1
[    2.633311] device: 'ptyp2': device_add
[    2.633409] PM: Adding info for No Bus:ptyp2
[    2.634055] device: 'ptyp3': device_add
[    2.634158] PM: Adding info for No Bus:ptyp3
[    2.634755] device: 'ptyp4': device_add
[    2.634858] PM: Adding info for No Bus:ptyp4
[    2.635448] device: 'ptyp5': device_add
[    2.635577] PM: Adding info for No Bus:ptyp5
[    2.636899] device: 'ptyp6': device_add
[    2.637048] PM: Adding info for No Bus:ptyp6
[    2.637740] device: 'ptyp7': device_add
[    2.637848] PM: Adding info for No Bus:ptyp7
[    2.638425] device: 'ptyp8': device_add
[    2.638527] PM: Adding info for No Bus:ptyp8
[    2.639127] device: 'ptyp9': device_add
[    2.639230] PM: Adding info for No Bus:ptyp9
[    2.639809] device: 'ptypa': device_add
[    2.639915] PM: Adding info for No Bus:ptypa
[    2.640572] device: 'ptypb': device_add
[    2.640716] PM: Adding info for No Bus:ptypb
[    2.641318] device: 'ptypc': device_add
[    2.641420] PM: Adding info for No Bus:ptypc
[    2.642027] device: 'ptypd': device_add
[    2.642137] PM: Adding info for No Bus:ptypd
[    2.642783] device: 'ptype': device_add
[    2.642900] PM: Adding info for No Bus:ptype
[    2.643671] device: 'ptypf': device_add
[    2.643842] PM: Adding info for No Bus:ptypf
[    2.645446] device: 'ptyq0': device_add
[    2.645610] PM: Adding info for No Bus:ptyq0
[    2.646330] device: 'ptyq1': device_add
[    2.646452] PM: Adding info for No Bus:ptyq1
[    2.647057] device: 'ptyq2': device_add
[    2.647200] PM: Adding info for No Bus:ptyq2
[    2.647799] device: 'ptyq3': device_add
[    2.647908] PM: Adding info for No Bus:ptyq3
[    2.648604] device: 'ptyq4': device_add
[    2.648723] PM: Adding info for No Bus:ptyq4
[    2.649343] device: 'ptyq5': device_add
[    2.649452] PM: Adding info for No Bus:ptyq5
[    2.650063] device: 'ptyq6': device_add
[    2.650172] PM: Adding info for No Bus:ptyq6
[    2.650782] device: 'ptyq7': device_add
[    2.650891] PM: Adding info for No Bus:ptyq7
[    2.651491] device: 'ptyq8': device_add
[    2.651634] PM: Adding info for No Bus:ptyq8
[    2.653484] device: 'ptyq9': device_add
[    2.653673] PM: Adding info for No Bus:ptyq9
[    2.654434] device: 'ptyqa': device_add
[    2.654558] PM: Adding info for No Bus:ptyqa
[    2.655170] device: 'ptyqb': device_add
[    2.655322] PM: Adding info for No Bus:ptyqb
[    2.655955] device: 'ptyqc': device_add
[    2.656074] PM: Adding info for No Bus:ptyqc
[    2.657655] device: 'ptyqd': device_add
[    2.657828] PM: Adding info for No Bus:ptyqd
[    2.658448] device: 'ptyqe': device_add
[    2.658569] PM: Adding info for No Bus:ptyqe
[    2.659233] device: 'ptyqf': device_add
[    2.659385] PM: Adding info for No Bus:ptyqf
[    2.660002] device: 'ptyr0': device_add
[    2.660195] PM: Adding info for No Bus:ptyr0
[    2.660835] device: 'ptyr1': device_add
[    2.660986] PM: Adding info for No Bus:ptyr1
[    2.661598] device: 'ptyr2': device_add
[    2.661721] PM: Adding info for No Bus:ptyr2
[    2.662333] device: 'ptyr3': device_add
[    2.662450] PM: Adding info for No Bus:ptyr3
[    2.663056] device: 'ptyr4': device_add
[    2.663174] PM: Adding info for No Bus:ptyr4
[    2.663790] device: 'ptyr5': device_add
[    2.663912] PM: Adding info for No Bus:ptyr5
[    2.665257] device: 'ptyr6': device_add
[    2.665452] PM: Adding info for No Bus:ptyr6
[    2.666102] device: 'ptyr7': device_add
[    2.666225] PM: Adding info for No Bus:ptyr7
[    2.666837] device: 'ptyr8': device_add
[    2.666956] PM: Adding info for No Bus:ptyr8
[    2.667572] device: 'ptyr9': device_add
[    2.667693] PM: Adding info for No Bus:ptyr9
[    2.668376] device: 'ptyra': device_add
[    2.668503] PM: Adding info for No Bus:ptyra
[    2.669127] device: 'ptyrb': device_add
[    2.669246] PM: Adding info for No Bus:ptyrb
[    2.669891] device: 'ptyrc': device_add
[    2.670045] PM: Adding info for No Bus:ptyrc
[    2.670740] device: 'ptyrd': device_add
[    2.670871] PM: Adding info for No Bus:ptyrd
[    2.671506] device: 'ptyre': device_add
[    2.671633] PM: Adding info for No Bus:ptyre
[    2.673088] device: 'ptyrf': device_add
[    2.673280] PM: Adding info for No Bus:ptyrf
[    2.673973] device: 'ptys0': device_add
[    2.674102] PM: Adding info for No Bus:ptys0
[    2.674714] device: 'ptys1': device_add
[    2.674839] PM: Adding info for No Bus:ptys1
[    2.675447] device: 'ptys2': device_add
[    2.675579] PM: Adding info for No Bus:ptys2
[    2.676236] device: 'ptys3': device_add
[    2.676407] PM: Adding info for No Bus:ptys3
[    2.677038] device: 'ptys4': device_add
[    2.677202] PM: Adding info for No Bus:ptys4
[    2.677807] device: 'ptys5': device_add
[    2.677936] PM: Adding info for No Bus:ptys5
[    2.678530] device: 'ptys6': device_add
[    2.678654] PM: Adding info for No Bus:ptys6
[    2.679313] device: 'ptys7': device_add
[    2.679448] PM: Adding info for No Bus:ptys7
[    2.681082] device: 'ptys8': device_add
[    2.681318] PM: Adding info for No Bus:ptys8
[    2.682076] device: 'ptys9': device_add
[    2.682256] PM: Adding info for No Bus:ptys9
[    2.682877] device: 'ptysa': device_add
[    2.683015] PM: Adding info for No Bus:ptysa
[    2.683680] device: 'ptysb': device_add
[    2.683827] PM: Adding info for No Bus:ptysb
[    2.684521] device: 'ptysc': device_add
[    2.684665] PM: Adding info for No Bus:ptysc
[    2.685282] device: 'ptysd': device_add
[    2.685414] PM: Adding info for No Bus:ptysd
[    2.686037] device: 'ptyse': device_add
[    2.686171] PM: Adding info for No Bus:ptyse
[    2.686770] device: 'ptysf': device_add
[    2.686907] PM: Adding info for No Bus:ptysf
[    2.687512] device: 'ptyt0': device_add
[    2.687679] PM: Adding info for No Bus:ptyt0
[    2.689550] device: 'ptyt1': device_add
[    2.689773] PM: Adding info for No Bus:ptyt1
[    2.690495] device: 'ptyt2': device_add
[    2.690634] PM: Adding info for No Bus:ptyt2
[    2.691250] device: 'ptyt3': device_add
[    2.691382] PM: Adding info for No Bus:ptyt3
[    2.691996] device: 'ptyt4': device_add
[    2.692194] PM: Adding info for No Bus:ptyt4
[    2.692829] device: 'ptyt5': device_add
[    2.692966] PM: Adding info for No Bus:ptyt5
[    2.693577] device: 'ptyt6': device_add
[    2.693774] PM: Adding info for No Bus:ptyt6
[    2.694413] device: 'ptyt7': device_add
[    2.694551] PM: Adding info for No Bus:ptyt7
[    2.695152] device: 'ptyt8': device_add
[    2.695284] PM: Adding info for No Bus:ptyt8
[    2.695959] device: 'ptyt9': device_add
[    2.696874] PM: Adding info for No Bus:ptyt9
[    2.697639] device: 'ptyta': device_add
[    2.697837] PM: Adding info for No Bus:ptyta
[    2.698456] device: 'ptytb': device_add
[    2.698598] PM: Adding info for No Bus:ptytb
[    2.699195] device: 'ptytc': device_add
[    2.699338] PM: Adding info for No Bus:ptytc
[    2.699943] device: 'ptytd': device_add
[    2.700191] PM: Adding info for No Bus:ptytd
[    2.700842] device: 'ptyte': device_add
[    2.700985] PM: Adding info for No Bus:ptyte
[    2.701608] device: 'ptytf': device_add
[    2.701751] PM: Adding info for No Bus:ptytf
[    2.702365] device: 'ptyu0': device_add
[    2.702508] PM: Adding info for No Bus:ptyu0
[    2.703117] device: 'ptyu1': device_add
[    2.703254] PM: Adding info for No Bus:ptyu1
[    2.703867] device: 'ptyu2': device_add
[    2.704010] PM: Adding info for No Bus:ptyu2
[    2.705610] device: 'ptyu3': device_add
[    2.705839] PM: Adding info for No Bus:ptyu3
[    2.706466] device: 'ptyu4': device_add
[    2.706649] PM: Adding info for No Bus:ptyu4
[    2.707253] device: 'ptyu5': device_add
[    2.707398] PM: Adding info for No Bus:ptyu5
[    2.708007] device: 'ptyu6': device_add
[    2.708225] PM: Adding info for No Bus:ptyu6
[    2.708894] device: 'ptyu7': device_add
[    2.709055] PM: Adding info for No Bus:ptyu7
[    2.709688] device: 'ptyu8': device_add
[    2.709869] PM: Adding info for No Bus:ptyu8
[    2.710489] device: 'ptyu9': device_add
[    2.710639] PM: Adding info for No Bus:ptyu9
[    2.711245] device: 'ptyua': device_add
[    2.711424] PM: Adding info for No Bus:ptyua
[    2.712929] device: 'ptyub': device_add
[    2.713198] PM: Adding info for No Bus:ptyub
[    2.713989] device: 'ptyuc': device_add
[    2.714159] PM: Adding info for No Bus:ptyuc
[    2.714782] device: 'ptyud': device_add
[    2.714929] PM: Adding info for No Bus:ptyud
[    2.715540] device: 'ptyue': device_add
[    2.715686] PM: Adding info for No Bus:ptyue
[    2.716376] device: 'ptyuf': device_add
[    2.716534] PM: Adding info for No Bus:ptyuf
[    2.717167] device: 'ptyv0': device_add
[    2.717319] PM: Adding info for No Bus:ptyv0
[    2.717942] device: 'ptyv1': device_add
[    2.718126] PM: Adding info for No Bus:ptyv1
[    2.718755] device: 'ptyv2': device_add
[    2.718905] PM: Adding info for No Bus:ptyv2
[    2.719515] device: 'ptyv3': device_add
[    2.719661] PM: Adding info for No Bus:ptyv3
[    2.721324] device: 'ptyv4': device_add
[    2.721564] PM: Adding info for No Bus:ptyv4
[    2.722329] device: 'ptyv5': device_add
[    2.722498] PM: Adding info for No Bus:ptyv5
[    2.723126] device: 'ptyv6': device_add
[    2.723276] PM: Adding info for No Bus:ptyv6
[    2.723993] device: 'ptyv7': device_add
[    2.724305] PM: Adding info for No Bus:ptyv7
[    2.724959] device: 'ptyv8': device_add
[    2.725121] PM: Adding info for No Bus:ptyv8
[    2.725738] device: 'ptyv9': device_add
[    2.725893] PM: Adding info for No Bus:ptyv9
[    2.726491] device: 'ptyva': device_add
[    2.726677] PM: Adding info for No Bus:ptyva
[    2.727289] device: 'ptyvb': device_add
[    2.727445] PM: Adding info for No Bus:ptyvb
[    2.728043] device: 'ptyvc': device_add
[    2.729037] PM: Adding info for No Bus:ptyvc
[    2.729846] device: 'ptyvd': device_add
[    2.730032] PM: Adding info for No Bus:ptyvd
[    2.730661] device: 'ptyve': device_add
[    2.730853] PM: Adding info for No Bus:ptyve
[    2.731462] device: 'ptyvf': device_add
[    2.731620] PM: Adding info for No Bus:ptyvf
[    2.732303] device: 'ptyw0': device_add
[    2.732473] PM: Adding info for No Bus:ptyw0
[    2.733111] device: 'ptyw1': device_add
[    2.733267] PM: Adding info for No Bus:ptyw1
[    2.733885] device: 'ptyw2': device_add
[    2.734041] PM: Adding info for No Bus:ptyw2
[    2.734711] device: 'ptyw3': device_add
[    2.734889] PM: Adding info for No Bus:ptyw3
[    2.735514] device: 'ptyw4': device_add
[    2.735704] PM: Adding info for No Bus:ptyw4
[    2.737270] device: 'ptyw5': device_add
[    2.737518] PM: Adding info for No Bus:ptyw5
[    2.738214] device: 'ptyw6': device_add
[    2.738380] PM: Adding info for No Bus:ptyw6
[    2.739012] device: 'ptyw7': device_add
[    2.739183] PM: Adding info for No Bus:ptyw7
[    2.739799] device: 'ptyw8': device_add
[    2.739959] PM: Adding info for No Bus:ptyw8
[    2.740671] device: 'ptyw9': device_add
[    2.740846] PM: Adding info for No Bus:ptyw9
[    2.741469] device: 'ptywa': device_add
[    2.741628] PM: Adding info for No Bus:ptywa
[    2.742246] device: 'ptywb': device_add
[    2.742507] PM: Adding info for No Bus:ptywb
[    2.743148] device: 'ptywc': device_add
[    2.743350] PM: Adding info for No Bus:ptywc
[    2.743994] device: 'ptywd': device_add
[    2.745305] PM: Adding info for No Bus:ptywd
[    2.746097] device: 'ptywe': device_add
[    2.746291] PM: Adding info for No Bus:ptywe
[    2.746906] device: 'ptywf': device_add
[    2.747071] PM: Adding info for No Bus:ptywf
[    2.747768] device: 'ptyx0': device_add
[    2.747964] PM: Adding info for No Bus:ptyx0
[    2.748710] device: 'ptyx1': device_add
[    2.748897] PM: Adding info for No Bus:ptyx1
[    2.749517] device: 'ptyx2': device_add
[    2.749720] PM: Adding info for No Bus:ptyx2
[    2.750348] device: 'ptyx3': device_add
[    2.750515] PM: Adding info for No Bus:ptyx3
[    2.751113] device: 'ptyx4': device_add
[    2.751277] PM: Adding info for No Bus:ptyx4
[    2.751895] device: 'ptyx5': device_add
[    2.752052] PM: Adding info for No Bus:ptyx5
[    2.753701] device: 'ptyx6': device_add
[    2.753949] PM: Adding info for No Bus:ptyx6
[    2.754599] device: 'ptyx7': device_add
[    2.754775] PM: Adding info for No Bus:ptyx7
[    2.755402] device: 'ptyx8': device_add
[    2.755598] PM: Adding info for No Bus:ptyx8
[    2.756298] device: 'ptyx9': device_add
[    2.756491] PM: Adding info for No Bus:ptyx9
[    2.757126] device: 'ptyxa': device_add
[    2.757294] PM: Adding info for No Bus:ptyxa
[    2.757949] device: 'ptyxb': device_add
[    2.758121] PM: Adding info for No Bus:ptyxb
[    2.758761] device: 'ptyxc': device_add
[    2.758931] PM: Adding info for No Bus:ptyxc
[    2.759556] device: 'ptyxd': device_add
[    2.759721] PM: Adding info for No Bus:ptyxd
[    2.761186] device: 'ptyxe': device_add
[    2.761442] PM: Adding info for No Bus:ptyxe
[    2.762187] device: 'ptyxf': device_add
[    2.762444] PM: Adding info for No Bus:ptyxf
[    2.763096] device: 'ptyy0': device_add
[    2.763274] PM: Adding info for No Bus:ptyy0
[    2.763894] device: 'ptyy1': device_add
[    2.764065] PM: Adding info for No Bus:ptyy1
[    2.764793] device: 'ptyy2': device_add
[    2.764976] PM: Adding info for No Bus:ptyy2
[    2.765613] device: 'ptyy3': device_add
[    2.765782] PM: Adding info for No Bus:ptyy3
[    2.766400] device: 'ptyy4': device_add
[    2.766567] PM: Adding info for No Bus:ptyy4
[    2.767179] device: 'ptyy5': device_add
[    2.767385] PM: Adding info for No Bus:ptyy5
[    2.768021] device: 'ptyy6': device_add
[    2.769206] PM: Adding info for No Bus:ptyy6
[    2.769987] device: 'ptyy7': device_add
[    2.770205] PM: Adding info for No Bus:ptyy7
[    2.770844] device: 'ptyy8': device_add
[    2.771029] PM: Adding info for No Bus:ptyy8
[    2.771741] device: 'ptyy9': device_add
[    2.771954] PM: Adding info for No Bus:ptyy9
[    2.772667] device: 'ptyya': device_add
[    2.772855] PM: Adding info for No Bus:ptyya
[    2.773499] device: 'ptyyb': device_add
[    2.773720] PM: Adding info for No Bus:ptyyb
[    2.774355] device: 'ptyyc': device_add
[    2.774579] PM: Adding info for No Bus:ptyyc
[    2.775260] device: 'ptyyd': device_add
[    2.775449] PM: Adding info for No Bus:ptyyd
[    2.776068] device: 'ptyye': device_add
[    2.777173] PM: Adding info for No Bus:ptyye
[    2.777986] device: 'ptyyf': device_add
[    2.778188] PM: Adding info for No Bus:ptyyf
[    2.778814] device: 'ptyz0': device_add
[    2.778993] PM: Adding info for No Bus:ptyz0
[    2.779630] device: 'ptyz1': device_add
[    2.779845] PM: Adding info for No Bus:ptyz1
[    2.780578] device: 'ptyz2': device_add
[    2.780802] PM: Adding info for No Bus:ptyz2
[    2.781452] device: 'ptyz3': device_add
[    2.781639] PM: Adding info for No Bus:ptyz3
[    2.782290] device: 'ptyz4': device_add
[    2.782475] PM: Adding info for No Bus:ptyz4
[    2.783121] device: 'ptyz5': device_add
[    2.783311] PM: Adding info for No Bus:ptyz5
[    2.783982] device: 'ptyz6': device_add
[    2.784969] PM: Adding info for No Bus:ptyz6
[    2.785736] device: 'ptyz7': device_add
[    2.785981] PM: Adding info for No Bus:ptyz7
[    2.786633] device: 'ptyz8': device_add
[    2.786823] PM: Adding info for No Bus:ptyz8
[    2.787467] device: 'ptyz9': device_add
[    2.787691] PM: Adding info for No Bus:ptyz9
[    2.788413] device: 'ptyza': device_add
[    2.788618] PM: Adding info for No Bus:ptyza
[    2.789329] device: 'ptyzb': device_add
[    2.789520] PM: Adding info for No Bus:ptyzb
[    2.790167] device: 'ptyzc': device_add
[    2.790350] PM: Adding info for No Bus:ptyzc
[    2.790989] device: 'ptyzd': device_add
[    2.791176] PM: Adding info for No Bus:ptyzd
[    2.791793] device: 'ptyze': device_add
[    2.791985] PM: Adding info for No Bus:ptyze
[    2.793681] device: 'ptyzf': device_add
[    2.793983] PM: Adding info for No Bus:ptyzf
[    2.794650] device: 'ptya0': device_add
[    2.794882] PM: Adding info for No Bus:ptya0
[    2.795522] device: 'ptya1': device_add
[    2.795712] PM: Adding info for No Bus:ptya1
[    2.796513] device: 'ptya2': device_add
[    2.796754] PM: Adding info for No Bus:ptya2
[    2.797387] device: 'ptya3': device_add
[    2.797615] PM: Adding info for No Bus:ptya3
[    2.798280] device: 'ptya4': device_add
[    2.798483] PM: Adding info for No Bus:ptya4
[    2.799120] device: 'ptya5': device_add
[    2.799316] PM: Adding info for No Bus:ptya5
[    2.799936] device: 'ptya6': device_add
[    2.800934] PM: Adding info for No Bus:ptya6
[    2.801735] device: 'ptya7': device_add
[    2.802006] PM: Adding info for No Bus:ptya7
[    2.802675] device: 'ptya8': device_add
[    2.802868] PM: Adding info for No Bus:ptya8
[    2.803572] device: 'ptya9': device_add
[    2.803785] PM: Adding info for No Bus:ptya9
[    2.804505] device: 'ptyaa': device_add
[    2.804716] PM: Adding info for No Bus:ptyaa
[    2.805355] device: 'ptyab': device_add
[    2.805546] PM: Adding info for No Bus:ptyab
[    2.806179] device: 'ptyac': device_add
[    2.806381] PM: Adding info for No Bus:ptyac
[    2.807017] device: 'ptyad': device_add
[    2.807250] PM: Adding info for No Bus:ptyad
[    2.807894] device: 'ptyae': device_add
[    2.808094] PM: Adding info for No Bus:ptyae
[    2.809589] device: 'ptyaf': device_add
[    2.809887] PM: Adding info for No Bus:ptyaf
[    2.810549] device: 'ptyb0': device_add
[    2.810749] PM: Adding info for No Bus:ptyb0
[    2.811370] device: 'ptyb1': device_add
[    2.811569] PM: Adding info for No Bus:ptyb1
[    2.812263] device: 'ptyb2': device_add
[    2.812477] PM: Adding info for No Bus:ptyb2
[    2.813119] device: 'ptyb3': device_add
[    2.813357] PM: Adding info for No Bus:ptyb3
[    2.813997] device: 'ptyb4': device_add
[    2.814202] PM: Adding info for No Bus:ptyb4
[    2.814853] device: 'ptyb5': device_add
[    2.815056] PM: Adding info for No Bus:ptyb5
[    2.815706] device: 'ptyb6': device_add
[    2.815947] PM: Adding info for No Bus:ptyb6
[    2.817640] device: 'ptyb7': device_add
[    2.817985] PM: Adding info for No Bus:ptyb7
[    2.818670] device: 'ptyb8': device_add
[    2.818879] PM: Adding info for No Bus:ptyb8
[    2.819506] device: 'ptyb9': device_add
[    2.819712] PM: Adding info for No Bus:ptyb9
[    2.820514] device: 'ptyba': device_add
[    2.820819] PM: Adding info for No Bus:ptyba
[    2.821470] device: 'ptybb': device_add
[    2.821681] PM: Adding info for No Bus:ptybb
[    2.822314] device: 'ptybc': device_add
[    2.822517] PM: Adding info for No Bus:ptybc
[    2.823151] device: 'ptybd': device_add
[    2.823355] PM: Adding info for No Bus:ptybd
[    2.823992] device: 'ptybe': device_add
[    2.825000] PM: Adding info for No Bus:ptybe
[    2.825794] device: 'ptybf': device_add
[    2.826066] PM: Adding info for No Bus:ptybf
[    2.826725] device: 'ptyc0': device_add
[    2.826966] PM: Adding info for No Bus:ptyc0
[    2.827608] device: 'ptyc1': device_add
[    2.827811] PM: Adding info for No Bus:ptyc1
[    2.828545] device: 'ptyc2': device_add
[    2.828766] PM: Adding info for No Bus:ptyc2
[    2.829412] device: 'ptyc3': device_add
[    2.829618] PM: Adding info for No Bus:ptyc3
[    2.830250] device: 'ptyc4': device_add
[    2.830456] PM: Adding info for No Bus:ptyc4
[    2.831134] device: 'ptyc5': device_add
[    2.831356] PM: Adding info for No Bus:ptyc5
[    2.831992] device: 'ptyc6': device_add
[    2.832998] PM: Adding info for No Bus:ptyc6
[    2.833814] device: 'ptyc7': device_add
[    2.834130] PM: Adding info for No Bus:ptyc7
[    2.834784] device: 'ptyc8': device_add
[    2.835052] PM: Adding info for No Bus:ptyc8
[    2.835701] device: 'ptyc9': device_add
[    2.835912] PM: Adding info for No Bus:ptyc9
[    2.836647] device: 'ptyca': device_add
[    2.836866] PM: Adding info for No Bus:ptyca
[    2.837520] device: 'ptycb': device_add
[    2.837761] PM: Adding info for No Bus:ptycb
[    2.838441] device: 'ptycc': device_add
[    2.838669] PM: Adding info for No Bus:ptycc
[    2.839301] device: 'ptycd': device_add
[    2.839508] PM: Adding info for No Bus:ptycd
[    2.841016] device: 'ptyce': device_add
[    2.841399] PM: Adding info for No Bus:ptyce
[    2.842198] device: 'ptycf': device_add
[    2.842432] PM: Adding info for No Bus:ptycf
[    2.843091] device: 'ptyd0': device_add
[    2.843298] PM: Adding info for No Bus:ptyd0
[    2.843945] device: 'ptyd1': device_add
[    2.844219] PM: Adding info for No Bus:ptyd1
[    2.844978] device: 'ptyd2': device_add
[    2.845248] PM: Adding info for No Bus:ptyd2
[    2.845961] device: 'ptyd3': device_add
[    2.846185] PM: Adding info for No Bus:ptyd3
[    2.846824] device: 'ptyd4': device_add
[    2.847069] PM: Adding info for No Bus:ptyd4
[    2.847703] device: 'ptyd5': device_add
[    2.847936] PM: Adding info for No Bus:ptyd5
[    2.849490] device: 'ptyd6': device_add
[    2.849827] PM: Adding info for No Bus:ptyd6
[    2.850504] device: 'ptyd7': device_add
[    2.850728] PM: Adding info for No Bus:ptyd7
[    2.851393] device: 'ptyd8': device_add
[    2.851622] PM: Adding info for No Bus:ptyd8
[    2.852356] device: 'ptyd9': device_add
[    2.852598] PM: Adding info for No Bus:ptyd9
[    2.853269] device: 'ptyda': device_add
[    2.853538] PM: Adding info for No Bus:ptyda
[    2.854190] device: 'ptydb': device_add
[    2.854453] PM: Adding info for No Bus:ptydb
[    2.855107] device: 'ptydc': device_add
[    2.855323] PM: Adding info for No Bus:ptydc
[    2.855973] device: 'ptydd': device_add
[    2.857035] PM: Adding info for No Bus:ptydd
[    2.857845] device: 'ptyde': device_add
[    2.858141] PM: Adding info for No Bus:ptyde
[    2.858800] device: 'ptydf': device_add
[    2.859029] PM: Adding info for No Bus:ptydf
[    2.859675] device: 'ptye0': device_add
[    2.859899] PM: Adding info for No Bus:ptye0
[    2.860693] device: 'ptye1': device_add
[    2.860997] PM: Adding info for No Bus:ptye1
[    2.861645] device: 'ptye2': device_add
[    2.861881] PM: Adding info for No Bus:ptye2
[    2.862521] device: 'ptye3': device_add
[    2.862743] PM: Adding info for No Bus:ptye3
[    2.863425] device: 'ptye4': device_add
[    2.863659] PM: Adding info for No Bus:ptye4
[    2.865251] device: 'ptye5': device_add
[    2.865601] PM: Adding info for No Bus:ptye5
[    2.866334] device: 'ptye6': device_add
[    2.866578] PM: Adding info for No Bus:ptye6
[    2.867241] device: 'ptye7': device_add
[    2.867476] PM: Adding info for No Bus:ptye7
[    2.868192] device: 'ptye8': device_add
[    2.868481] PM: Adding info for No Bus:ptye8
[    2.869242] device: 'ptye9': device_add
[    2.869530] PM: Adding info for No Bus:ptye9
[    2.870176] device: 'ptyea': device_add
[    2.870407] PM: Adding info for No Bus:ptyea
[    2.871052] device: 'ptyeb': device_add
[    2.871285] PM: Adding info for No Bus:ptyeb
[    2.871926] device: 'ptyec': device_add
[    2.872977] PM: Adding info for No Bus:ptyec
[    2.873765] device: 'ptyed': device_add
[    2.874101] PM: Adding info for No Bus:ptyed
[    2.874769] device: 'ptyee': device_add
[    2.875031] PM: Adding info for No Bus:ptyee
[    2.875759] device: 'ptyef': device_add
[    2.876019] PM: Adding info for No Bus:ptyef
[    2.876833] device: 'ttyp0': device_add
[    2.877088] PM: Adding info for No Bus:ttyp0
[    2.877763] device: 'ttyp1': device_add
[    2.877991] PM: Adding info for No Bus:ttyp1
[    2.878637] device: 'ttyp2': device_add
[    2.878853] PM: Adding info for No Bus:ttyp2
[    2.879488] device: 'ttyp3': device_add
[    2.879707] PM: Adding info for No Bus:ttyp3
[    2.881236] device: 'ttyp4': device_add
[    2.881595] PM: Adding info for No Bus:ttyp4
[    2.882337] device: 'ttyp5': device_add
[    2.882610] PM: Adding info for No Bus:ttyp5
[    2.883275] device: 'ttyp6': device_add
[    2.883512] PM: Adding info for No Bus:ttyp6
[    2.884240] device: 'ttyp7': device_add
[    2.884480] PM: Adding info for No Bus:ttyp7
[    2.885159] device: 'ttyp8': device_add
[    2.885379] PM: Adding info for No Bus:ttyp8
[    2.886038] device: 'ttyp9': device_add
[    2.886337] PM: Adding info for No Bus:ttyp9
[    2.886991] device: 'ttypa': device_add
[    2.887253] PM: Adding info for No Bus:ttypa
[    2.887928] device: 'ttypb': device_add
[    2.889046] PM: Adding info for No Bus:ttypb
[    2.889831] device: 'ttypc': device_add
[    2.890173] PM: Adding info for No Bus:ttypc
[    2.890901] device: 'ttypd': device_add
[    2.891158] PM: Adding info for No Bus:ttypd
[    2.891818] device: 'ttype': device_add
[    2.892045] PM: Adding info for No Bus:ttype
[    2.892786] device: 'ttypf': device_add
[    2.893071] PM: Adding info for No Bus:ttypf
[    2.893839] device: 'ttyq0': device_add
[    2.894127] PM: Adding info for No Bus:ttyq0
[    2.894786] device: 'ttyq1': device_add
[    2.895021] PM: Adding info for No Bus:ttyq1
[    2.895659] device: 'ttyq2': device_add
[    2.895921] PM: Adding info for No Bus:ttyq2
[    2.897485] device: 'ttyq3': device_add
[    2.897853] PM: Adding info for No Bus:ttyq3
[    2.898554] device: 'ttyq4': device_add
[    2.898791] PM: Adding info for No Bus:ttyq4
[    2.899457] device: 'ttyq5': device_add
[    2.899691] PM: Adding info for No Bus:ttyq5
[    2.900425] device: 'ttyq6': device_add
[    2.900674] PM: Adding info for No Bus:ttyq6
[    2.901345] device: 'ttyq7': device_add
[    2.901578] PM: Adding info for No Bus:ttyq7
[    2.902233] device: 'ttyq8': device_add
[    2.902468] PM: Adding info for No Bus:ttyq8
[    2.903115] device: 'ttyq9': device_add
[    2.903387] PM: Adding info for No Bus:ttyq9
[    2.904044] device: 'ttyqa': device_add
[    2.905105] PM: Adding info for No Bus:ttyqa
[    2.905974] device: 'ttyqb': device_add
[    2.906287] PM: Adding info for No Bus:ttyqb
[    2.906968] device: 'ttyqc': device_add
[    2.907215] PM: Adding info for No Bus:ttyqc
[    2.907862] device: 'ttyqd': device_add
[    2.908092] PM: Adding info for No Bus:ttyqd
[    2.908822] device: 'ttyqe': device_add
[    2.909084] PM: Adding info for No Bus:ttyqe
[    2.909754] device: 'ttyqf': device_add
[    2.910016] PM: Adding info for No Bus:ttyqf
[    2.913418] device: 'ttyr0': device_add
[    2.913806] PM: Adding info for No Bus:ttyr0
[    2.914504] device: 'ttyr1': device_add
[    2.914797] PM: Adding info for No Bus:ttyr1
[    2.915476] device: 'ttyr2': device_add
[    2.915719] PM: Adding info for No Bus:ttyr2
[    2.916441] device: 'ttyr3': device_add
[    2.916695] PM: Adding info for No Bus:ttyr3
[    2.917366] device: 'ttyr4': device_add
[    2.917604] PM: Adding info for No Bus:ttyr4
[    2.918273] device: 'ttyr5': device_add
[    2.918512] PM: Adding info for No Bus:ttyr5
[    2.919168] device: 'ttyr6': device_add
[    2.919445] PM: Adding info for No Bus:ttyr6
[    2.920829] device: 'ttyr7': device_add
[    2.921207] PM: Adding info for No Bus:ttyr7
[    2.922011] device: 'ttyr8': device_add
[    2.922269] PM: Adding info for No Bus:ttyr8
[    2.922997] device: 'ttyr9': device_add
[    2.923260] PM: Adding info for No Bus:ttyr9
[    2.923913] device: 'ttyra': device_add
[    2.924241] PM: Adding info for No Bus:ttyra
[    2.924924] device: 'ttyrb': device_add
[    2.925194] PM: Adding info for No Bus:ttyrb
[    2.925853] device: 'ttyrc': device_add
[    2.926133] PM: Adding info for No Bus:ttyrc
[    2.926806] device: 'ttyrd': device_add
[    2.927071] PM: Adding info for No Bus:ttyrd
[    2.927741] device: 'ttyre': device_add
[    2.927990] PM: Adding info for No Bus:ttyre
[    2.929268] device: 'ttyrf': device_add
[    2.929630] PM: Adding info for No Bus:ttyrf
[    2.930307] device: 'ttys0': device_add
[    2.930567] PM: Adding info for No Bus:ttys0
[    2.931224] device: 'ttys1': device_add
[    2.931480] PM: Adding info for No Bus:ttys1
[    2.932211] device: 'ttys2': device_add
[    2.932482] PM: Adding info for No Bus:ttys2
[    2.933171] device: 'ttys3': device_add
[    2.933503] PM: Adding info for No Bus:ttys3
[    2.934171] device: 'ttys4': device_add
[    2.934442] PM: Adding info for No Bus:ttys4
[    2.935144] device: 'ttys5': device_add
[    2.935410] PM: Adding info for No Bus:ttys5
[    2.936084] device: 'ttys6': device_add
[    2.937218] PM: Adding info for No Bus:ttys6
[    2.938088] device: 'ttys7': device_add
[    2.938409] PM: Adding info for No Bus:ttys7
[    2.939089] device: 'ttys8': device_add
[    2.939352] PM: Adding info for No Bus:ttys8
[    2.940020] device: 'ttys9': device_add
[    2.940365] PM: Adding info for No Bus:ttys9
[    2.941041] device: 'ttysa': device_add
[    2.941343] PM: Adding info for No Bus:ttysa
[    2.942022] device: 'ttysb': device_add
[    2.942282] PM: Adding info for No Bus:ttysb
[    2.942945] device: 'ttysc': device_add
[    2.943199] PM: Adding info for No Bus:ttysc
[    2.943862] device: 'ttysd': device_add
[    2.945066] PM: Adding info for No Bus:ttysd
[    2.945885] device: 'ttyse': device_add
[    2.946294] PM: Adding info for No Bus:ttyse
[    2.946977] device: 'ttysf': device_add
[    2.947250] PM: Adding info for No Bus:ttysf
[    2.947907] device: 'ttyt0': device_add
[    2.948284] PM: Adding info for No Bus:ttyt0
[    2.948961] device: 'ttyt1': device_add
[    2.949246] PM: Adding info for No Bus:ttyt1
[    2.949890] device: 'ttyt2': device_add
[    2.950152] PM: Adding info for No Bus:ttyt2
[    2.950931] device: 'ttyt3': device_add
[    2.951269] PM: Adding info for No Bus:ttyt3
[    2.951920] device: 'ttyt4': device_add
[    2.952963] PM: Adding info for No Bus:ttyt4
[    2.953824] device: 'ttyt5': device_add
[    2.954249] PM: Adding info for No Bus:ttyt5
[    2.954932] device: 'ttyt6': device_add
[    2.955219] PM: Adding info for No Bus:ttyt6
[    2.955883] device: 'ttyt7': device_add
[    2.956277] PM: Adding info for No Bus:ttyt7
[    2.956962] device: 'ttyt8': device_add
[    2.957246] PM: Adding info for No Bus:ttyt8
[    2.957923] device: 'ttyt9': device_add
[    2.958194] PM: Adding info for No Bus:ttyt9
[    2.958859] device: 'ttyta': device_add
[    2.959134] PM: Adding info for No Bus:ttyta
[    2.959858] device: 'ttytb': device_add
[    2.960829] PM: Adding info for No Bus:ttytb
[    2.961591] device: 'ttytc': device_add
[    2.961983] PM: Adding info for No Bus:ttytc
[    2.962642] device: 'ttytd': device_add
[    2.962954] PM: Adding info for No Bus:ttytd
[    2.963618] device: 'ttyte': device_add
[    2.963896] PM: Adding info for No Bus:ttyte
[    2.964652] device: 'ttytf': device_add
[    2.964954] PM: Adding info for No Bus:ttytf
[    2.965621] device: 'ttyu0': device_add
[    2.965901] PM: Adding info for No Bus:ttyu0
[    2.966584] device: 'ttyu1': device_add
[    2.966859] PM: Adding info for No Bus:ttyu1
[    2.967533] device: 'ttyu2': device_add
[    2.967806] PM: Adding info for No Bus:ttyu2
[    2.969317] device: 'ttyu3': device_add
[    2.969753] PM: Adding info for No Bus:ttyu3
[    2.970474] device: 'ttyu4': device_add
[    2.970804] PM: Adding info for No Bus:ttyu4
[    2.971501] device: 'ttyu5': device_add
[    2.971790] PM: Adding info for No Bus:ttyu5
[    2.972550] device: 'ttyu6': device_add
[    2.972851] PM: Adding info for No Bus:ttyu6
[    2.973538] device: 'ttyu7': device_add
[    2.973827] PM: Adding info for No Bus:ttyu7
[    2.974487] device: 'ttyu8': device_add
[    2.974820] PM: Adding info for No Bus:ttyu8
[    2.975499] device: 'ttyu9': device_add
[    2.975786] PM: Adding info for No Bus:ttyu9
[    2.977178] device: 'ttyua': device_add
[    2.977633] PM: Adding info for No Bus:ttyua
[    2.978361] device: 'ttyub': device_add
[    2.978695] PM: Adding info for No Bus:ttyub
[    2.979368] device: 'ttyuc': device_add
[    2.979660] PM: Adding info for No Bus:ttyuc
[    2.980404] device: 'ttyud': device_add
[    2.980714] PM: Adding info for No Bus:ttyud
[    2.981398] device: 'ttyue': device_add
[    2.981686] PM: Adding info for No Bus:ttyue
[    2.982354] device: 'ttyuf': device_add
[    2.982647] PM: Adding info for No Bus:ttyuf
[    2.983339] device: 'ttyv0': device_add
[    2.983628] PM: Adding info for No Bus:ttyv0
[    2.985183] device: 'ttyv1': device_add
[    2.985658] PM: Adding info for No Bus:ttyv1
[    2.986405] device: 'ttyv2': device_add
[    2.986709] PM: Adding info for No Bus:ttyv2
[    2.987391] device: 'ttyv3': device_add
[    2.987678] PM: Adding info for No Bus:ttyv3
[    2.988439] device: 'ttyv4': device_add
[    2.988739] PM: Adding info for No Bus:ttyv4
[    2.989420] device: 'ttyv5': device_add
[    2.989707] PM: Adding info for No Bus:ttyv5
[    2.990359] device: 'ttyv6': device_add
[    2.990646] PM: Adding info for No Bus:ttyv6
[    2.991310] device: 'ttyv7': device_add
[    2.991599] PM: Adding info for No Bus:ttyv7
[    2.992987] device: 'ttyv8': device_add
[    2.993462] PM: Adding info for No Bus:ttyv8
[    2.994220] device: 'ttyv9': device_add
[    2.994532] PM: Adding info for No Bus:ttyv9
[    2.995227] device: 'ttyva': device_add
[    2.995573] PM: Adding info for No Bus:ttyva
[    2.996328] device: 'ttyvb': device_add
[    2.996653] PM: Adding info for No Bus:ttyvb
[    2.997342] device: 'ttyvc': device_add
[    2.997638] PM: Adding info for No Bus:ttyvc
[    2.998326] device: 'ttyvd': device_add
[    2.998621] PM: Adding info for No Bus:ttyvd
[    2.999296] device: 'ttyve': device_add
[    2.999622] PM: Adding info for No Bus:ttyve
[    3.001327] device: 'ttyvf': device_add
[    3.001809] PM: Adding info for No Bus:ttyvf
[    3.002545] device: 'ttyw0': device_add
[    3.002859] PM: Adding info for No Bus:ttyw0
[    3.003550] device: 'ttyw1': device_add
[    3.003852] PM: Adding info for No Bus:ttyw1
[    3.004599] device: 'ttyw2': device_add
[    3.004916] PM: Adding info for No Bus:ttyw2
[    3.005585] device: 'ttyw3': device_add
[    3.005879] PM: Adding info for No Bus:ttyw3
[    3.006656] device: 'ttyw4': device_add
[    3.007031] PM: Adding info for No Bus:ttyw4
[    3.007706] device: 'ttyw5': device_add
[    3.008061] PM: Adding info for No Bus:ttyw5
[    3.009530] device: 'ttyw6': device_add
[    3.009989] PM: Adding info for No Bus:ttyw6
[    3.010677] device: 'ttyw7': device_add
[    3.010994] PM: Adding info for No Bus:ttyw7
[    3.011651] device: 'ttyw8': device_add
[    3.011960] PM: Adding info for No Bus:ttyw8
[    3.012712] device: 'ttyw9': device_add
[    3.013045] PM: Adding info for No Bus:ttyw9
[    3.013726] device: 'ttywa': device_add
[    3.014038] PM: Adding info for No Bus:ttywa
[    3.014706] device: 'ttywb': device_add
[    3.015048] PM: Adding info for No Bus:ttywb
[    3.015729] device: 'ttywc': device_add
[    3.016099] PM: Adding info for No Bus:ttywc
[    3.017600] device: 'ttywd': device_add
[    3.018080] PM: Adding info for No Bus:ttywd
[    3.018796] device: 'ttywe': device_add
[    3.019118] PM: Adding info for No Bus:ttywe
[    3.019809] device: 'ttywf': device_add
[    3.020194] PM: Adding info for No Bus:ttywf
[    3.020907] device: 'ttyx0': device_add
[    3.021239] PM: Adding info for No Bus:ttyx0
[    3.021927] device: 'ttyx1': device_add
[    3.022252] PM: Adding info for No Bus:ttyx1
[    3.022926] device: 'ttyx2': device_add
[    3.023287] PM: Adding info for No Bus:ttyx2
[    3.023981] device: 'ttyx3': device_add
[    3.025048] PM: Adding info for No Bus:ttyx3
[    3.025850] device: 'ttyx4': device_add
[    3.026241] PM: Adding info for No Bus:ttyx4
[    3.026939] device: 'ttyx5': device_add
[    3.027276] PM: Adding info for No Bus:ttyx5
[    3.027939] device: 'ttyx6': device_add
[    3.028358] PM: Adding info for No Bus:ttyx6
[    3.029045] device: 'ttyx7': device_add
[    3.029388] PM: Adding info for No Bus:ttyx7
[    3.030081] device: 'ttyx8': device_add
[    3.030443] PM: Adding info for No Bus:ttyx8
[    3.031124] device: 'ttyx9': device_add
[    3.031463] PM: Adding info for No Bus:ttyx9
[    3.033058] device: 'ttyxa': device_add
[    3.033568] PM: Adding info for No Bus:ttyxa
[    3.034436] device: 'ttyxb': device_add
[    3.034812] PM: Adding info for No Bus:ttyxb
[    3.035501] device: 'ttyxc': device_add
[    3.035834] PM: Adding info for No Bus:ttyxc
[    3.036595] device: 'ttyxd': device_add
[    3.036951] PM: Adding info for No Bus:ttyxd
[    3.037636] device: 'ttyxe': device_add
[    3.038017] PM: Adding info for No Bus:ttyxe
[    3.038693] device: 'ttyxf': device_add
[    3.039070] PM: Adding info for No Bus:ttyxf
[    3.039873] device: 'ttyy0': device_add
[    3.041092] PM: Adding info for No Bus:ttyy0
[    3.041908] device: 'ttyy1': device_add
[    3.042346] PM: Adding info for No Bus:ttyy1
[    3.043061] device: 'ttyy2': device_add
[    3.043415] PM: Adding info for No Bus:ttyy2
[    3.044097] device: 'ttyy3': device_add
[    3.044542] PM: Adding info for No Bus:ttyy3
[    3.045243] device: 'ttyy4': device_add
[    3.045586] PM: Adding info for No Bus:ttyy4
[    3.046274] device: 'ttyy5': device_add
[    3.046608] PM: Adding info for No Bus:ttyy5
[    3.047297] device: 'ttyy6': device_add
[    3.047663] PM: Adding info for No Bus:ttyy6
[    3.049040] device: 'ttyy7': device_add
[    3.049595] PM: Adding info for No Bus:ttyy7
[    3.050329] device: 'ttyy8': device_add
[    3.050709] PM: Adding info for No Bus:ttyy8
[    3.051456] device: 'ttyy9': device_add
[    3.051843] PM: Adding info for No Bus:ttyy9
[    3.052625] device: 'ttyya': device_add
[    3.052991] PM: Adding info for No Bus:ttyya
[    3.053686] device: 'ttyyb': device_add
[    3.054068] PM: Adding info for No Bus:ttyyb
[    3.054765] device: 'ttyyc': device_add
[    3.055155] PM: Adding info for No Bus:ttyyc
[    3.055867] device: 'ttyyd': device_add
[    3.056949] PM: Adding info for No Bus:ttyyd
[    3.057762] device: 'ttyye': device_add
[    3.058225] PM: Adding info for No Bus:ttyye
[    3.058928] device: 'ttyyf': device_add
[    3.059292] PM: Adding info for No Bus:ttyyf
[    3.059983] device: 'ttyz0': device_add
[    3.060431] PM: Adding info for No Bus:ttyz0
[    3.061149] device: 'ttyz1': device_add
[    3.061559] PM: Adding info for No Bus:ttyz1
[    3.062254] device: 'ttyz2': device_add
[    3.062610] PM: Adding info for No Bus:ttyz2
[    3.063299] device: 'ttyz3': device_add
[    3.063693] PM: Adding info for No Bus:ttyz3
[    3.065280] device: 'ttyz4': device_add
[    3.065785] PM: Adding info for No Bus:ttyz4
[    3.066512] device: 'ttyz5': device_add
[    3.066876] PM: Adding info for No Bus:ttyz5
[    3.067571] device: 'ttyz6': device_add
[    3.067933] PM: Adding info for No Bus:ttyz6
[    3.068762] device: 'ttyz7': device_add
[    3.069161] PM: Adding info for No Bus:ttyz7
[    3.069855] device: 'ttyz8': device_add
[    3.070219] PM: Adding info for No Bus:ttyz8
[    3.070907] device: 'ttyz9': device_add
[    3.071308] PM: Adding info for No Bus:ttyz9
[    3.072097] device: 'ttyza': device_add
[    3.073387] PM: Adding info for No Bus:ttyza
[    3.074226] device: 'ttyzb': device_add
[    3.074629] PM: Adding info for No Bus:ttyzb
[    3.075357] device: 'ttyzc': device_add
[    3.075738] PM: Adding info for No Bus:ttyzc
[    3.076512] device: 'ttyzd': device_add
[    3.076902] PM: Adding info for No Bus:ttyzd
[    3.077591] device: 'ttyze': device_add
[    3.077957] PM: Adding info for No Bus:ttyze
[    3.078646] device: 'ttyzf': device_add
[    3.079013] PM: Adding info for No Bus:ttyzf
[    3.079705] device: 'ttya0': device_add
[    3.080110] PM: Adding info for No Bus:ttya0
[    3.081481] device: 'ttya1': device_add
[    3.081970] PM: Adding info for No Bus:ttya1
[    3.082682] device: 'ttya2': device_add
[    3.083056] PM: Adding info for No Bus:ttya2
[    3.083755] device: 'ttya3': device_add
[    3.084254] PM: Adding info for No Bus:ttya3
[    3.084963] device: 'ttya4': device_add
[    3.085353] PM: Adding info for No Bus:ttya4
[    3.086105] device: 'ttya5': device_add
[    3.086509] PM: Adding info for No Bus:ttya5
[    3.087195] device: 'ttya6': device_add
[    3.087601] PM: Adding info for No Bus:ttya6
[    3.088928] device: 'ttya7': device_add
[    3.089449] PM: Adding info for No Bus:ttya7
[    3.090221] device: 'ttya8': device_add
[    3.090603] PM: Adding info for No Bus:ttya8
[    3.091306] device: 'ttya9': device_add
[    3.091689] PM: Adding info for No Bus:ttya9
[    3.092453] device: 'ttyaa': device_add
[    3.092863] PM: Adding info for No Bus:ttyaa
[    3.093556] device: 'ttyab': device_add
[    3.093937] PM: Adding info for No Bus:ttyab
[    3.094618] device: 'ttyac': device_add
[    3.094996] PM: Adding info for No Bus:ttyac
[    3.095693] device: 'ttyad': device_add
[    3.096102] PM: Adding info for No Bus:ttyad
[    3.097814] device: 'ttyae': device_add
[    3.098350] PM: Adding info for No Bus:ttyae
[    3.099063] device: 'ttyaf': device_add
[    3.099453] PM: Adding info for No Bus:ttyaf
[    3.100221] device: 'ttyb0': device_add
[    3.100629] PM: Adding info for No Bus:ttyb0
[    3.101357] device: 'ttyb1': device_add
[    3.101744] PM: Adding info for No Bus:ttyb1
[    3.102439] device: 'ttyb2': device_add
[    3.102823] PM: Adding info for No Bus:ttyb2
[    3.103586] device: 'ttyb3': device_add
[    3.103984] PM: Adding info for No Bus:ttyb3
[    3.105545] device: 'ttyb4': device_add
[    3.106152] PM: Adding info for No Bus:ttyb4
[    3.106902] device: 'ttyb5': device_add
[    3.107363] PM: Adding info for No Bus:ttyb5
[    3.108065] device: 'ttyb6': device_add
[    3.108564] PM: Adding info for No Bus:ttyb6
[    3.109281] device: 'ttyb7': device_add
[    3.109683] PM: Adding info for No Bus:ttyb7
[    3.110376] device: 'ttyb8': device_add
[    3.110767] PM: Adding info for No Bus:ttyb8
[    3.111476] device: 'ttyb9': device_add
[    3.111874] PM: Adding info for No Bus:ttyb9
[    3.113339] device: 'ttyba': device_add
[    3.113920] PM: Adding info for No Bus:ttyba
[    3.114672] device: 'ttybb': device_add
[    3.115076] PM: Adding info for No Bus:ttybb
[    3.115785] device: 'ttybc': device_add
[    3.116271] PM: Adding info for No Bus:ttybc
[    3.116998] device: 'ttybd': device_add
[    3.117410] PM: Adding info for No Bus:ttybd
[    3.118119] device: 'ttybe': device_add
[    3.118519] PM: Adding info for No Bus:ttybe
[    3.119229] device: 'ttybf': device_add
[    3.119624] PM: Adding info for No Bus:ttybf
[    3.120983] device: 'ttyc0': device_add
[    3.121501] PM: Adding info for No Bus:ttyc0
[    3.122308] device: 'ttyc1': device_add
[    3.122784] PM: Adding info for No Bus:ttyc1
[    3.123488] device: 'ttyc2': device_add
[    3.123895] PM: Adding info for No Bus:ttyc2
[    3.124683] device: 'ttyc3': device_add
[    3.125107] PM: Adding info for No Bus:ttyc3
[    3.125819] device: 'ttyc4': device_add
[    3.126230] PM: Adding info for No Bus:ttyc4
[    3.126938] device: 'ttyc5': device_add
[    3.127349] PM: Adding info for No Bus:ttyc5
[    3.128047] device: 'ttyc6': device_add
[    3.129421] PM: Adding info for No Bus:ttyc6
[    3.130263] device: 'ttyc7': device_add
[    3.130779] PM: Adding info for No Bus:ttyc7
[    3.131507] device: 'ttyc8': device_add
[    3.131942] PM: Adding info for No Bus:ttyc8
[    3.132732] device: 'ttyc9': device_add
[    3.133168] PM: Adding info for No Bus:ttyc9
[    3.133871] device: 'ttyca': device_add
[    3.134277] PM: Adding info for No Bus:ttyca
[    3.134971] device: 'ttycb': device_add
[    3.135411] PM: Adding info for No Bus:ttycb
[    3.136809] device: 'ttycc': device_add
[    3.137387] PM: Adding info for No Bus:ttycc
[    3.138173] device: 'ttycd': device_add
[    3.138608] PM: Adding info for No Bus:ttycd
[    3.139338] device: 'ttyce': device_add
[    3.139799] PM: Adding info for No Bus:ttyce
[    3.140647] device: 'ttycf': device_add
[    3.141117] PM: Adding info for No Bus:ttycf
[    3.141826] device: 'ttyd0': device_add
[    3.142240] PM: Adding info for No Bus:ttyd0
[    3.142935] device: 'ttyd1': device_add
[    3.143346] PM: Adding info for No Bus:ttyd1
[    3.144049] device: 'ttyd2': device_add
[    3.145147] PM: Adding info for No Bus:ttyd2
[    3.145934] device: 'ttyd3': device_add
[    3.146390] PM: Adding info for No Bus:ttyd3
[    3.147090] device: 'ttyd4': device_add
[    3.147548] PM: Adding info for No Bus:ttyd4
[    3.148323] device: 'ttyd5': device_add
[    3.148777] PM: Adding info for No Bus:ttyd5
[    3.149492] device: 'ttyd6': device_add
[    3.149922] PM: Adding info for No Bus:ttyd6
[    3.150634] device: 'ttyd7': device_add
[    3.151058] PM: Adding info for No Bus:ttyd7
[    3.151771] device: 'ttyd8': device_add
[    3.152835] PM: Adding info for No Bus:ttyd8
[    3.153610] device: 'ttyd9': device_add
[    3.154124] PM: Adding info for No Bus:ttyd9
[    3.154847] device: 'ttyda': device_add
[    3.155315] PM: Adding info for No Bus:ttyda
[    3.156021] device: 'ttydb': device_add
[    3.156580] PM: Adding info for No Bus:ttydb
[    3.157301] device: 'ttydc': device_add
[    3.157748] PM: Adding info for No Bus:ttydc
[    3.158506] device: 'ttydd': device_add
[    3.158958] PM: Adding info for No Bus:ttydd
[    3.159652] device: 'ttyde': device_add
[    3.160071] PM: Adding info for No Bus:ttyde
[    3.161411] device: 'ttydf': device_add
[    3.161970] PM: Adding info for No Bus:ttydf
[    3.162672] device: 'ttye0': device_add
[    3.163114] PM: Adding info for No Bus:ttye0
[    3.163828] device: 'ttye1': device_add
[    3.164344] PM: Adding info for No Bus:ttye1
[    3.165058] device: 'ttye2': device_add
[    3.165556] PM: Adding info for No Bus:ttye2
[    3.166271] device: 'ttye3': device_add
[    3.166716] PM: Adding info for No Bus:ttye3
[    3.167411] device: 'ttye4': device_add
[    3.167848] PM: Adding info for No Bus:ttye4
[    3.169463] device: 'ttye5': device_add
[    3.170105] PM: Adding info for No Bus:ttye5
[    3.170840] device: 'ttye6': device_add
[    3.171293] PM: Adding info for No Bus:ttye6
[    3.172022] device: 'ttye7': device_add
[    3.172569] PM: Adding info for No Bus:ttye7
[    3.173286] device: 'ttye8': device_add
[    3.173773] PM: Adding info for No Bus:ttye8
[    3.174476] device: 'ttye9': device_add
[    3.174934] PM: Adding info for No Bus:ttye9
[    3.175647] device: 'ttyea': device_add
[    3.176090] PM: Adding info for No Bus:ttyea
[    3.177536] device: 'ttyeb': device_add
[    3.178130] PM: Adding info for No Bus:ttyeb
[    3.178868] device: 'ttyec': device_add
[    3.179378] PM: Adding info for No Bus:ttyec
[    3.180087] device: 'ttyed': device_add
[    3.180644] PM: Adding info for No Bus:ttyed
[    3.181376] device: 'ttyee': device_add
[    3.181829] PM: Adding info for No Bus:ttyee
[    3.182551] device: 'ttyef': device_add
[    3.183043] PM: Adding info for No Bus:ttyef
[    3.183984] device: 'ptmx': device_add
[    3.185159] PM: Adding info for No Bus:ptmx
[    3.186061] Initializing Nozomi driver 2.1d (build date: Jan 10 2009 13:32:38)
[    3.186306] bus: 'pci': add driver nozomi
[    3.187048] bus: 'virtio': add driver virtio_console
[    3.187689] device class 'raw': registering
[    3.188413] device: 'rawctl': device_add
[    3.188721] PM: Adding info for No Bus:rawctl
[    3.189537] device class 'printer': registering
[    3.190230] lp: driver loaded but no devices found
[    3.190349] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    3.190484] ac.o: No PCI boards found.
[    3.190580] ac.o: For an ISA board you must supply memory and irq parameters.
[    3.190689] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    3.190800] toshiba: not a supported Toshiba laptop
[    3.190937] device class 'ppdev': registering
[    3.191558] ppdev: user-space parallel port driver
[    3.191666] scx200_gpio: no SCx200 gpio present
[    3.191765] nsc_gpio initializing
[    3.191772] Linux agpgart interface v0.103
[    3.191882] bus: 'pci': add driver agpgart-ali
[    3.193536] bus: 'pci': add driver agpgart-amdk7
[    3.194228] bus: 'pci': add driver agpgart-amd64
[    3.194954] bus: 'pci': add driver agpgart-intel
[    3.194999] bus: 'pci': driver_probe_device: matched device 0000:00:00.0 with driver agpgart-intel
[    3.195010] bus: 'pci': really_probe: probing driver agpgart-intel with device 0000:00:00.0
[    3.195073] agpgart-intel 0000:00:00.0: Intel 440BX Chipset
[    3.201297] device: 'agpgart': device_add
[    3.201731] PM: Adding info for No Bus:agpgart
[    3.202664] agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0xf8000000
[    3.202792] driver: '0000:00:00.0': driver_bound: bound to device 'agpgart-intel'
[    3.202805] bus: 'pci': really_probe: bound device 0000:00:00.0 to driver agpgart-intel
[    3.203508] bus: 'pci': add driver agpgart-sis
[    3.204251] bus: 'pci': add driver agpgart-serverworks
[    3.204927] bus: 'pci': add driver agpgart-via
[    3.205608] ipwireless 1.1 by Stephen Blackheath, Ben Martel, Jiri Kosina and David Sterba
[    3.205815] bus: 'pcmcia': add driver ipwireless
[    3.206459] SyncLink PC Card driver $Revision: 4.34 $
[    3.206570] bus: 'pcmcia': add driver synclink_cs
[    3.207259] device: 'ttySLP0': device_add
[    3.207957] PM: Adding info for No Bus:ttySLP0
[    3.209468] device: 'ttySLP1': device_add
[    3.210073] PM: Adding info for No Bus:ttySLP1
[    3.210834] device: 'ttySLP2': device_add
[    3.211297] PM: Adding info for No Bus:ttySLP2
[    3.212079] device: 'ttySLP3': device_add
[    3.212654] PM: Adding info for No Bus:ttySLP3
[    3.213397] SyncLink PC Card driver $Revision: 4.34 $, tty major#250
[    3.213521] cm4000_cs.c v2.4.0gm6 - All bugs added by Harald Welte
[    3.213629] device class 'cardman_4000': registering
[    3.214312] bus: 'pcmcia': add driver cm4000_cs
[    3.214948] OMNIKEY CardMan 4040 v1.1.0gm5 - All bugs added by Harald Welte
[    3.215070] device class 'cardman_4040': registering
[    3.215730] bus: 'pcmcia': add driver cm4040_cs
[    3.216833] device class 'drm': registering
[    3.217508] [drm] Initialized drm 1.1.0 20060810
[    3.218687] bus: 'pci': add driver i810fb
[    3.219373] intelfb: intelfb_init
[    3.219383] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
[    3.219556] intelfb: Version 0.9.6
[    3.219654] intelfb: intelfb_setup
[    3.219660] intelfb: no options
[    3.219674] bus: 'pci': add driver intelfb
[    3.220414] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.220634] Registering platform device 'serial8250'. Parent at platform
[    3.220645] device: 'serial8250': device_add
[    3.220714] bus: 'platform': add device serial8250
[    3.220777] PM: Adding info for platform:serial8250
[    3.221739] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.221879] device: 'ttyS0': device_add
[    3.222594] PM: Adding info for No Bus:ttyS0
[    3.223607] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    3.223754] device: 'ttyS1': device_add
[    3.225237] PM: Adding info for No Bus:ttyS1
[    3.226144] device: 'ttyS2': device_add
[    3.226778] PM: Adding info for No Bus:ttyS2
[    3.227584] device: 'ttyS3': device_add
[    3.228106] PM: Adding info for No Bus:ttyS3
[    3.228947] bus: 'platform': add driver serial8250
[    3.229011] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[    3.229023] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[    3.229086] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[    3.229098] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[    3.229729] bus: 'pci': add driver serial
[    3.230560] bus: 'pcmcia': add driver serial_cs
[    3.231394] bus: 'platform': add driver ax88796-pp
[    3.233791] device: 'ram0': device_add
[    3.233939] PM: Adding info for No Bus:ram0
[    3.234936] device: '1:0': device_add
[    3.235055] PM: Adding info for No Bus:1:0
[    3.235822] device: 'ram1': device_add
[    3.235942] PM: Adding info for No Bus:ram1
[    3.236724] device: '1:1': device_add
[    3.236808] PM: Adding info for No Bus:1:1
[    3.237487] device: 'ram2': device_add
[    3.237697] PM: Adding info for No Bus:ram2
[    3.238350] device: '1:2': device_add
[    3.238472] PM: Adding info for No Bus:1:2
[    3.239183] device: 'ram3': device_add
[    3.239300] PM: Adding info for No Bus:ram3
[    3.239950] device: '1:3': device_add
[    3.240026] PM: Adding info for No Bus:1:3
[    3.241377] device: 'ram4': device_add
[    3.241534] PM: Adding info for No Bus:ram4
[    3.242212] device: '1:4': device_add
[    3.242322] PM: Adding info for No Bus:1:4
[    3.242991] device: 'ram5': device_add
[    3.243106] PM: Adding info for No Bus:ram5
[    3.243759] device: '1:5': device_add
[    3.243834] PM: Adding info for No Bus:1:5
[    3.244619] device: 'ram6': device_add
[    3.244771] PM: Adding info for No Bus:ram6
[    3.245440] device: '1:6': device_add
[    3.245518] PM: Adding info for No Bus:1:6
[    3.246217] device: 'ram7': device_add
[    3.246334] PM: Adding info for No Bus:ram7
[    3.246985] device: '1:7': device_add
[    3.247063] PM: Adding info for No Bus:1:7
[    3.247720] device: 'ram8': device_add
[    3.247867] PM: Adding info for No Bus:ram8
[    3.249278] device: '1:8': device_add
[    3.249376] PM: Adding info for No Bus:1:8
[    3.250125] device: 'ram9': device_add
[    3.250255] PM: Adding info for No Bus:ram9
[    3.250892] device: '1:9': device_add
[    3.250972] PM: Adding info for No Bus:1:9
[    3.251607] device: 'ram10': device_add
[    3.251757] PM: Adding info for No Bus:ram10
[    3.252475] device: '1:10': device_add
[    3.252557] PM: Adding info for No Bus:1:10
[    3.253294] device: 'ram11': device_add
[    3.253419] PM: Adding info for No Bus:ram11
[    3.254063] device: '1:11': device_add
[    3.254170] PM: Adding info for No Bus:1:11
[    3.254836] device: 'ram12': device_add
[    3.254959] PM: Adding info for No Bus:ram12
[    3.255655] device: '1:12': device_add
[    3.255739] PM: Adding info for No Bus:1:12
[    3.257522] device: 'ram13': device_add
[    3.257672] PM: Adding info for No Bus:ram13
[    3.258411] device: '1:13': device_add
[    3.258530] PM: Adding info for No Bus:1:13
[    3.259198] device: 'ram14': device_add
[    3.259323] PM: Adding info for No Bus:ram14
[    3.259952] device: '1:14': device_add
[    3.260035] PM: Adding info for No Bus:1:14
[    3.260763] device: 'ram15': device_add
[    3.260892] PM: Adding info for No Bus:ram15
[    3.261582] device: '1:15': device_add
[    3.261664] PM: Adding info for No Bus:1:15
[    3.262381] brd: module loaded
[    3.262501] Compaq SMART2 Driver (v 2.6.0)
[    3.262617] bus: 'pci': add driver cpqarray
[    3.263452] bus: 'pci': remove driver cpqarray
[    3.264063] driver: 'cpqarray': driver_release
[    3.264098] bus: 'pci': add driver DAC960
[    3.265769] device: 'dac960_gam': device_add
[    3.266180] PM: Adding info for No Bus:dac960_gam
[    3.266958] bus: 'pci': add driver umem
[    3.267677] MM: desc_per_page = 128
[    3.269615] nbd: registered device at major 43
[    3.269746] device: 'nbd0': device_add
[    3.269902] PM: Adding info for No Bus:nbd0
[    3.271090] device: '43:0': device_add
[    3.271176] PM: Adding info for No Bus:43:0
[    3.271914] device: 'nbd1': device_add
[    3.272041] PM: Adding info for No Bus:nbd1
[    3.274159] device: '43:1': device_add
[    3.274251] PM: Adding info for No Bus:43:1
[    3.274966] device: 'nbd2': device_add
[    3.275098] PM: Adding info for No Bus:nbd2
[    3.275915] device: '43:2': device_add
[    3.275990] PM: Adding info for No Bus:43:2
[    3.276758] device: 'nbd3': device_add
[    3.276884] PM: Adding info for No Bus:nbd3
[    3.277693] device: '43:3': device_add
[    3.277770] PM: Adding info for No Bus:43:3
[    3.278407] device: 'nbd4': device_add
[    3.278534] PM: Adding info for No Bus:nbd4
[    3.279334] device: '43:4': device_add
[    3.279412] PM: Adding info for No Bus:43:4
[    3.281239] device: 'nbd5': device_add
[    3.281397] PM: Adding info for No Bus:nbd5
[    3.282390] device: '43:5': device_add
[    3.282472] PM: Adding info for No Bus:43:5
[    3.283150] device: 'nbd6': device_add
[    3.283276] PM: Adding info for No Bus:nbd6
[    3.284085] device: '43:6': device_add
[    3.284226] PM: Adding info for No Bus:43:6
[    3.284910] device: 'nbd7': device_add
[    3.285040] PM: Adding info for No Bus:nbd7
[    3.285845] device: '43:7': device_add
[    3.285923] PM: Adding info for No Bus:43:7
[    3.286652] device: 'nbd8': device_add
[    3.286782] PM: Adding info for No Bus:nbd8
[    3.287752] device: '43:8': device_add
[    3.287837] PM: Adding info for No Bus:43:8
[    3.289240] device: 'nbd9': device_add
[    3.289385] PM: Adding info for No Bus:nbd9
[    3.290270] device: '43:9': device_add
[    3.290377] PM: Adding info for No Bus:43:9
[    3.291073] device: 'nbd10': device_add
[    3.291201] PM: Adding info for No Bus:nbd10
[    3.291986] device: '43:10': device_add
[    3.292095] PM: Adding info for No Bus:43:10
[    3.292840] device: 'nbd11': device_add
[    3.292977] PM: Adding info for No Bus:nbd11
[    3.293782] device: '43:11': device_add
[    3.293892] PM: Adding info for No Bus:43:11
[    3.294650] device: 'nbd12': device_add
[    3.294793] PM: Adding info for No Bus:nbd12
[    3.295593] device: '43:12': device_add
[    3.295708] PM: Adding info for No Bus:43:12
[    3.297181] device: 'nbd13': device_add
[    3.297335] PM: Adding info for No Bus:nbd13
[    3.298225] device: '43:13': device_add
[    3.298312] PM: Adding info for No Bus:43:13
[    3.298984] device: 'nbd14': device_add
[    3.299177] PM: Adding info for No Bus:nbd14
[    3.300099] device: '43:14': device_add
[    3.300245] PM: Adding info for No Bus:43:14
[    3.300979] device: 'nbd15': device_add
[    3.301140] PM: Adding info for No Bus:nbd15
[    3.301955] device: '43:15': device_add
[    3.302039] PM: Adding info for No Bus:43:15
[    3.302722] bus: 'virtio': add driver virtio_blk
[    3.303374] bus: 'pci': add driver sx8
[    3.304110] bus: 'usb': add driver ub
[    3.305576] usbcore: registered new interface driver ub
[    3.306926] bus: 'platform': add driver pasic3
[    3.307699] bus: 'platform': remove driver pasic3
[    3.308370] driver: 'pasic3': driver_release
[    3.308400] bus: 'i2c': add driver WM8400
[    3.309052] i2c-core: driver [WM8400] registered
[    3.309072] bus: 'i2c': add driver da903x
[    3.309724] i2c-core: driver [da903x] registered
[    3.309738] Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
[    3.309856] Copyright (c) 1999-2006 Intel Corporation.
[    3.309973] bus: 'pci': add driver e1000
[    3.310647] Intel(R) Gigabit Ethernet Network Driver - version 1.2.45-k2
[    3.310764] Copyright (c) 2008 Intel Corporation.
[    3.310873] bus: 'pci': add driver igb
[    3.311530] bus: 'pci': add driver Sundance Technology IPG Triple-Speed Ethernet
[    3.312945] Ethernet Channel Bonding Driver: v3.5.0 (November 4, 2008)
[    3.313077] bonding: Warning: either miimon or arp_interval and arp_ip_target module parameters must be specified, otherwise bonding will not detect link failures! see bonding.txt for details.
[    3.313882] device: 'bond0': device_add
[    3.314295] PM: Adding info for No Bus:bond0
[    3.317395] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    3.317520] Copyright (c) 2007 Atheros Corporation.
[    3.317642] bus: 'pci': add driver atl2
[    3.318523] jme: JMicron JMC250 gigabit ethernet driver version 1.0.3
[    3.318649] bus: 'pci': add driver jme
[    3.319334] bus: 'pci': add driver hme
[    3.319990] bus: 'pci': add driver gem
[    3.321474] bus: 'pci': add driver cassini
[    3.322167] bus: 'pci': add driver 3c59x
[    3.322231] bus: 'pci': driver_probe_device: matched device 0000:00:0b.0 with driver 3c59x
[    3.322242] bus: 'pci': really_probe: probing driver 3c59x with device 0000:00:0b.0
[    3.322318] 3c59x 0000:00:0b.0: found PCI INT A -> IRQ 10
[    3.322534] 3c59x 0000:00:0b.0: sharing IRQ 10 with 0000:00:0a.0
[    3.322682] 3c59x 0000:00:0b.0: sharing IRQ 10 with 0000:00:0b.1
[    3.322903] 3c59x: Donald Becker and others.
[    3.323048] 0000:00:0b.0: 3Com PCI 3c556 Laptop Tornado at e07f6400.
[    3.345046] eth0 (3c59x): not using net_device_ops yet
[    3.345168] device: 'eth0': device_add
[    3.345582] PM: Adding info for No Bus:eth0
[    3.348477] driver: '0000:00:0b.0': driver_bound: bound to device '3c59x'
[    3.348494] bus: 'pci': really_probe: bound device 0000:00:0b.0 to driver 3c59x
[    3.349226] bus: 'pci': add driver typhoon
[    3.349943] bus: 'pci': add driver ne2k-pci
[    3.350599] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k6-NAPI
[    3.350720] e100: Copyright(c) 1999-2006 Intel Corporation
[    3.350836] bus: 'pci': add driver e100
[    3.351512] ThunderLAN driver v1.15a
[    3.351624] bus: 'pci': add driver tlan
[    3.352912] TLAN: 0 devices installed, PCI: 0  EISA: 0
[    3.353092] bus: 'pci': remove driver tlan
[    3.353762] driver: 'tlan': driver_release
[    3.353805] bus: 'pci': add driver smsc9420
[    3.354510] bus: 'pci': add driver sis900
[    3.355178] bus: 'pci': add driver r6040
[    3.355856] bus: 'pci': add driver natsemi
[    3.356749] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[    3.356887] bus: 'pci': add driver ns83820
[    3.357603] bus: 'pci': add driver fealnx
[    3.358276] bus: 'pci': add driver tg3
[    3.359007] bus: 'pci': add driver via-rhine
[    3.359656] bus: 'pci': add driver via-velocity
[    3.360642] bus: 'mdio_bus': add driver Marvell 88E1101
[    3.361329] bus: 'mdio_bus': add driver Marvell 88E1112
[    3.361954] bus: 'mdio_bus': add driver Marvell 88E1111
[    3.362569] bus: 'mdio_bus': add driver Marvell 88E1118
[    3.363206] bus: 'mdio_bus': add driver Marvell 88E1145
[    3.363830] bus: 'mdio_bus': add driver Marvell 88E1240
[    3.364503] bus: 'mdio_bus': add driver Davicom DM9161E
[    3.365170] bus: 'mdio_bus': add driver Davicom DM9161A
[    3.365933] bus: 'mdio_bus': add driver Davicom DM9131
[    3.366675] bus: 'mdio_bus': add driver Cicada Cis8204
[    3.367288] bus: 'mdio_bus': add driver Cicada Cis8201
[    3.367883] bus: 'mdio_bus': add driver LXT970
[    3.369399] bus: 'mdio_bus': add driver LXT971
[    3.370109] bus: 'mdio_bus': add driver QS6612
[    3.370758] bus: 'mdio_bus': add driver SMSC LAN83C185
[    3.371387] bus: 'mdio_bus': add driver SMSC LAN8187
[    3.372001] bus: 'mdio_bus': add driver SMSC LAN8700
[    3.372711] bus: 'mdio_bus': add driver SMSC LAN911x Internal PHY
[    3.373346] bus: 'mdio_bus': add driver Broadcom BCM5411
[    3.373990] bus: 'mdio_bus': add driver Broadcom BCM5421
[    3.374590] bus: 'mdio_bus': add driver Broadcom BCM5461
[    3.375253] bus: 'mdio_bus': add driver Broadcom BCM5464
[    3.375910] bus: 'mdio_bus': add driver Broadcom BCM5481
[    3.377637] bus: 'mdio_bus': add driver Broadcom BCM5482
[    3.378345] bus: 'mdio_bus': add driver Broadcom BCM50610
[    3.379033] bus: 'mdio_bus': add driver Broadcom BCM57780
[    3.379666] bus: 'mdio_bus': add driver ICPlus IP175C
[    3.380364] bus: 'mdio_bus': add driver RTL821x Gigabit Ethernet
[    3.381014] Registering platform device 'Fixed MDIO bus.0'. Parent at platform
[    3.381027] device: 'Fixed MDIO bus.0': device_add
[    3.381069] bus: 'platform': add device Fixed MDIO bus.0
[    3.381137] PM: Adding info for platform:Fixed MDIO bus.0
[    3.381764] device: '0': device_add
[    3.381888] PM: Adding info for No Bus:0
[    3.382622] Fixed MDIO Bus: probed
[    3.382753] bus: 'mdio_bus': add driver NatSemi DP83865
[    3.383446] bus: 'pci': add driver sundance
[    3.385430] D-Link DE-620 pocket adapter not identified in the printer port
[    3.385688] bus: 'pci': add driver b44
[    3.386692] bus: 'ssb': add driver b44
[    3.387333] bus: 'pci': add driver forcedeth
[    3.388022] bus: 'pci': add driver qla3xxx
[    3.389928] PPP generic driver version 2.4.2
[    3.390084] device class 'ppp': registering
[    3.390760] device: 'ppp': device_add
[    3.391161] PM: Adding info for No Bus:ppp
[    3.392007] PPP Deflate Compression module registered
[    3.392131] NET: Registered protocol family 24
[    3.393013] device: 'dummy0': device_add
[    3.393402] PM: Adding info for No Bus:dummy0
[    3.396129] eth%d: D-Link DE-600 pocket adapter: not at I/O 0x378.
[    3.396458] bus: 'pci': add driver 8139cp
[    3.397267] bus: 'pci': add driver 8139too
[    3.397935] Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[    3.398157] device: 'eql': device_add
[    3.398534] PM: Adding info for No Bus:eql
[    3.401669] bus: 'pci': add driver amd8111e
[    3.402534] bus: 'spi': add driver enc28j60
[    3.403176] bus: 'pci': add driver 3c359
[    3.403849] arcnet loaded.
[    3.403963] arcnet: raw mode (`r') encapsulation support loaded.
[    3.404084] bus: 'pcmcia': add driver 3c589_cs
[    3.404813] bus: 'pcmcia': add driver fmvj18x_cs
[    3.405640] bus: 'pcmcia': add driver pcnet_cs
[    3.406326] bus: 'pcmcia': add driver xirc2ps_cs
[    3.406985] bus: 'pcmcia': add driver axnet_cs
[    3.407609] bus: 'usb': add driver catc
[    3.408786] usbcore: registered new interface driver catc
[    3.408931] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[    3.409044] bus: 'usb': add driver kaweth
[    3.409777] usbcore: registered new interface driver kaweth
[    3.409906] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    3.410067] bus: 'usb': add driver pegasus
[    3.410687] usbcore: registered new interface driver pegasus
[    3.410808] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
[    3.410921] bus: 'usb': add driver rtl8150
[    3.411527] usbcore: registered new interface driver rtl8150
[    3.411652] STRIP: Version 1.3A-STUART.CHESHIRE (unlimited channels)
[    3.411821] bus: 'pcmcia': add driver netwave_cs
[    3.412558] bus: 'pcmcia': add driver wavelan_cs
[    3.413230] bus: 'pci': add driver xircom_cb
[    3.413962] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    3.414099] bus: 'pci': add driver dmfe
[    3.414815] bus: 'pci': add driver de2104x
[    3.415495] bus: 'pci': add driver tulip
[    3.416166] bus: 'pci': add driver de4x5
[    3.417503] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    3.417655] bus: 'pci': add driver uli526x
[    3.418338] AX.25: 6pack driver, Revision: 0.3.0
[    3.418502] AX.25: bpqether driver version 004
[    3.418606] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    3.418611] baycom_ser_fdx: version 0.10 compiled 13:44:03 Jan 10 2009
[    3.418870] bcsf0 (): not using net_device_ops yet
[    3.418983] device: 'bcsf0': device_add
[    3.419379] PM: Adding info for No Bus:bcsf0
[    3.422342] bcsf1 (): not using net_device_ops yet
[    3.422462] device: 'bcsf1': device_add
[    3.422849] PM: Adding info for No Bus:bcsf1
[    3.426670] bcsf2 (): not using net_device_ops yet
[    3.426804] device: 'bcsf2': device_add
[    3.427213] PM: Adding info for No Bus:bcsf2
[    3.430648] bcsf3 (): not using net_device_ops yet
[    3.430777] device: 'bcsf3': device_add
[    3.431182] PM: Adding info for No Bus:bcsf3
[    3.435246] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    3.435378] hdlcdrv: version 0.8 compiled 13:44:05 Jan 10 2009
[    3.435486] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    3.435491] baycom_ser_hdx: version 0.10 compiled 13:44:07 Jan 10 2009
[    3.435766] bcsh0 (): not using net_device_ops yet
[    3.435875] device: 'bcsh0': device_add
[    3.436349] PM: Adding info for No Bus:bcsh0
[    3.439730] bcsh1 (): not using net_device_ops yet
[    3.439847] device: 'bcsh1': device_add
[    3.440260] PM: Adding info for No Bus:bcsh1
[    3.443635] bcsh2 (): not using net_device_ops yet
[    3.443751] device: 'bcsh2': device_add
[    3.444631] PM: Adding info for No Bus:bcsh2
[    3.448136] bcsh3 (): not using net_device_ops yet
[    3.448302] device: 'bcsh3': device_add
[    3.448727] PM: Adding info for No Bus:bcsh3
[    3.452645] baycom_par: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    3.452655] baycom_par: version 0.9 compiled 13:44:09 Jan 10 2009
[    3.452925] bcp0 (): not using net_device_ops yet
[    3.453033] device: 'bcp0': device_add
[    3.453416] PM: Adding info for No Bus:bcp0
[    3.457268] bcp1 (): not using net_device_ops yet
[    3.457386] device: 'bcp1': device_add
[    3.457766] PM: Adding info for No Bus:bcp1
[    3.462078] bcp2 (): not using net_device_ops yet
[    3.462204] device: 'bcp2': device_add
[    3.462596] PM: Adding info for No Bus:bcp2
[    3.466574] bcp3 (): not using net_device_ops yet
[    3.466687] device: 'bcp3': device_add
[    3.467070] PM: Adding info for No Bus:bcp3
[    3.471310] baycom_epp: (C) 1998-2000 Thomas Sailer, HB9JNX/AE4WA
[    3.471322] baycom_epp: version 0.7 compiled 13:44:10 Jan 10 2009
[    3.471591] bce0 (): not using net_device_ops yet
[    3.471699] device: 'bce0': device_add
[    3.472085] PM: Adding info for No Bus:bce0
[    3.476365] bce1 (): not using net_device_ops yet
[    3.476483] device: 'bce1': device_add
[    3.476869] PM: Adding info for No Bus:bce1
[    3.481375] bce2 (): not using net_device_ops yet
[    3.481490] device: 'bce2': device_add
[    3.481881] PM: Adding info for No Bus:bce2
[    3.486312] bce3 (): not using net_device_ops yet
[    3.486427] device: 'bce3': device_add
[    3.486845] PM: Adding info for No Bus:bce3
[    3.491548] console [netcon0] enabled
[    3.491665] netconsole: network logging started
[    3.491772] bus: 'virtio': add driver virtio_net
[    3.492525] Linux video capture interface: v2.00
[    3.492647] device class 'video4linux': registering
[    3.493265] bus: 'i2c': add driver tuner'
[    3.493907] i2c-core: driver [tuner'] registered
[    3.493925] bus: 'i2c': add driver tuner
[    3.494581] i2c-core: driver [tuner] registered
[    3.494597] bttv: driver version 0.9.17 loaded
[    3.494706] bttv: using 8 buffers with 2080k (520 pages) each for capture
[    3.494813] bttv: Host bridge needs ETBF enabled.
[    3.495610] bus: 'bttv-sub': registered
[    3.495649] bus: 'pci': add driver bttv
[    3.496617] bus: 'i2c': add driver ir-kbd-i2c
[    3.497266] i2c-core: driver [ir-kbd-i2c] registered
[    3.497288] bus: 'i2c': add driver tvaudio'
[    3.497910] i2c-core: driver [tvaudio'] registered
[    3.497929] bus: 'i2c': add driver tvaudio
[    3.498555] i2c-core: driver [tvaudio] registered
[    3.498575] bus: 'i2c': add driver tda7432'
[    3.499188] i2c-core: driver [tda7432'] registered
[    3.499206] bus: 'i2c': add driver tda7432
[    3.499847] i2c-core: driver [tda7432] registered
[    3.499869] bus: 'i2c': add driver tda9875'
[    3.500552] i2c-core: driver [tda9875'] registered
[    3.500572] bus: 'i2c': add driver tda9875
[    3.501200] i2c-core: driver [tda9875] registered
[    3.501222] bus: 'i2c': add driver saa5246a'
[    3.501839] i2c-core: driver [saa5246a'] registered
[    3.501858] bus: 'i2c': add driver saa5246a
[    3.502533] i2c-core: driver [saa5246a] registered
[    3.502556] bus: 'i2c': add driver saa5249'
[    3.503177] i2c-core: driver [saa5249'] registered
[    3.503196] bus: 'i2c': add driver saa5249
[    3.503823] i2c-core: driver [saa5249] registered
[    3.503837] Colour QuickCam for Video4Linux v0.05
[    3.503969] bus: 'i2c': add driver saa7110'
[    3.504846] i2c-core: driver [saa7110'] registered
[    3.504867] bus: 'i2c': add driver saa7110
[    3.505533] i2c-core: driver [saa7110] registered
[    3.505555] bus: 'i2c': add driver saa7115'
[    3.506158] i2c-core: driver [saa7115'] registered
[    3.506179] bus: 'i2c': add driver saa7115
[    3.506781] i2c-core: driver [saa7115] registered
[    3.506803] bus: 'i2c': add driver saa717x
[    3.507498] i2c-core: driver [saa717x] registered
[    3.507523] bus: 'i2c': add driver saa7127
[    3.508450] i2c-core: driver [saa7127] registered
[    3.508481] bus: 'i2c': add driver adv7175'
[    3.509159] i2c-core: driver [adv7175'] registered
[    3.509180] bus: 'i2c': add driver adv7175
[    3.509789] i2c-core: driver [adv7175] registered
[    3.509812] bus: 'i2c': add driver bt856'
[    3.510447] i2c-core: driver [bt856'] registered
[    3.510469] bus: 'i2c': add driver bt856
[    3.511069] i2c-core: driver [bt856] registered
[    3.511092] bus: 'i2c': add driver ks0127'
[    3.511709] i2c-core: driver [ks0127'] registered
[    3.511730] bus: 'i2c': add driver ks0127
[    3.513256] i2c-core: driver [ks0127] registered
[    3.513282] Zoran MJPEG board driver version 0.9.5
[    3.513439] No known MJPEG cards found.
[    3.513541] Linux video codec intermediate layer: v0.2
[    3.513744] bus: 'pci': add driver stradis
[    3.514595] V4L-Driver for Vision CPiA based cameras v1.2.3
[    3.514712] Since in-kernel colorspace conversion is not allowed, it is disabled by default now. Users should fix the applications in case they don't work without conversion reenabled by setting the 'colorspace_conv' module parameter to 1
[    3.515046] USB driver for Vision CPiA based cameras v1.2.3
[    3.515160] bus: 'usb': add driver cpia
[    3.515797] usbcore: registered new interface driver cpia
[    3.515922] saa7130/34: v4l2 driver version 0.2.14 loaded
[    3.516048] bus: 'pci': add driver saa7134
[    3.517065] bus: 'i2c': add driver saa6752hs'
[    3.517733] i2c-core: driver [saa6752hs'] registered
[    3.517757] bus: 'i2c': add driver saa6752hs
[    3.518381] i2c-core: driver [saa6752hs] registered
[    3.518405] bus: 'i2c': add driver msp3400'
[    3.519069] i2c-core: driver [msp3400'] registered
[    3.519091] bus: 'i2c': add driver msp3400
[    3.519750] i2c-core: driver [msp3400] registered
[    3.519774] bus: 'i2c': add driver cs5345
[    3.521392] i2c-core: driver [cs5345] registered
[    3.521433] bus: 'i2c': add driver cs53l32a'
[    3.522170] i2c-core: driver [cs53l32a'] registered
[    3.522194] bus: 'i2c': add driver cs53l32a
[    3.522831] i2c-core: driver [cs53l32a] registered
[    3.522855] bus: 'i2c': add driver m52790
[    3.523498] i2c-core: driver [m52790] registered
[    3.523523] bus: 'i2c': add driver wm8775'
[    3.524149] i2c-core: driver [wm8775'] registered
[    3.524170] bus: 'i2c': add driver wm8775
[    3.524915] i2c-core: driver [wm8775] registered
[    3.524939] bus: 'i2c': add driver wm8739
[    3.525591] i2c-core: driver [wm8739] registered
[    3.525614] bus: 'i2c': add driver vp27smpx
[    3.526259] i2c-core: driver [vp27smpx] registered
[    3.526275] cpia2: V4L-Driver for Vision CPiA2 based cameras v2.0.0
[    3.526407] bus: 'usb': add driver cpia2
[    3.527039] usbcore: registered new interface driver cpia2
[    3.527164] saa7146: register extension 'hexium gemini'.
[    3.527299] bus: 'pci': add driver hexium gemini
[    3.528063] bus: 'i2c': add driver cx25840'
[    3.529764] i2c-core: driver [cx25840'] registered
[    3.529803] bus: 'i2c': add driver cx25840
[    3.530508] i2c-core: driver [cx25840] registered
[    3.530536] bus: 'i2c': add driver upd64031a
[    3.531165] i2c-core: driver [upd64031a] registered
[    3.531192] bus: 'i2c': add driver upd64083
[    3.531812] i2c-core: driver [upd64083] registered
[    3.531826] Marvell M88ALP01 'CAFE' Camera Controller version 2
[    3.532023] bus: 'pci': add driver cafe1000-ccic
[    3.532838] OmniVision ov7670 sensor driver, at your service
[    3.532968] bus: 'i2c': add driver ov7670
[    3.533595] i2c-core: driver [ov7670] registered
[    3.533610] ivtv: Start initialization, version 1.4.0
[    3.533735] bus: 'pci': add driver ivtv
[    3.534402] ivtv: End initialization
[    3.534523] ivtvfb:  no cards found
[    3.534619] cx18:  Start initialization, version 1.0.4
[    3.534735] bus: 'pci': add driver cx18
[    3.535522] cx18:  End initialization
[    3.535634] cx23885 driver version 0.0.1 loaded
[    3.535753] bus: 'pci': add driver cx23885
[    3.538475] bus: 'soc-camera': registered
[    3.538494] bus: 'soc-camera': add driver camera
[    3.539147] bus: 'i2c': add driver mt9m001
[    3.539823] i2c-core: driver [mt9m001] registered
[    3.539849] bus: 'i2c': add driver mt9m111
[    3.541405] i2c-core: driver [mt9m111] registered
[    3.541446] bus: 'i2c': add driver mt9t031
[    3.542191] i2c-core: driver [mt9t031] registered
[    3.542218] bus: 'i2c': add driver ov772x
[    3.542838] i2c-core: driver [ov772x] registered
[    3.542862] bus: 'platform': add driver soc_camera_platform
[    3.543497] bus: 'i2c': add driver tw9910
[    3.544142] i2c-core: driver [tw9910] registered
[    3.544155] au0828 driver loaded
[    3.544337] bus: 'usb': add driver au0828
[    3.545007] usbcore: registered new interface driver au0828
[    3.545166] bus: 'pci': add driver radio-maxiradio
[    3.545886] bus: 'usb': add driver dsbr100
[    3.546518] usbcore: registered new interface driver dsbr100
[    3.546650] dsbr100: v0.44:D-Link DSB-R100 USB FM radio driver
[    3.546755] USB radio driver for Si470x FM Radio Receivers, Version 1.0.8
[    3.546870] bus: 'usb': add driver radio-si470x
[    3.547500] usbcore: registered new interface driver radio-si470x
[    3.547632] bus: 'usb': add driver radio-mr800
[    3.548809] usbcore: registered new interface driver radio-mr800
[    3.548952] radio_mr800: version 0.01 AverMedia MR 800 USB FM radio driver
[    3.549084] bus: 'i2c': add driver radio-tea5764
[    3.549812] i2c-core: driver [radio-tea5764] registered
[    3.549826] radio_tea5764: v0.01: A driver for the TEA5764 radio chip for EZX Phones.
[    3.549991] bt878: AUDIO driver version 0.0.0 loaded
[    3.550124] bus: 'pci': add driver bt878
[    3.550857] bus: 'bttv-sub': add driver dvb-bt8xx
[    3.551516] device: 'input0': device_add
[    3.551712] PM: Adding info for No Bus:input0
[    3.552853] input: Macintosh mouse button emulation as /class/input/input0
[    3.553339] device class 'raid_devices': registering
[    3.554056] device class 'spi_transport': registering
[    3.554849] device class 'spi_host': registering
[    3.555499] device class 'fc_host': registering
[    3.556149] device class 'fc_vports': registering
[    3.557952] device class 'fc_remote_ports': registering
[    3.558590] device class 'fc_transport': registering
[    3.559199] device class 'sas_host': registering
[    3.559864] device class 'sas_phy': registering
[    3.560553] device class 'sas_port': registering
[    3.561144] device class 'sas_device': registering
[    3.561737] device class 'sas_end_device': registering
[    3.562315] device class 'sas_expander': registering
[    3.562905] device class 'srp_host': registering
[    3.563616] device class 'srp_remote_ports': registering
[    3.565106] bus: 'pci': add driver aic7xxx
[    3.566103] osst :I: Tape driver with OnStream support version 0.99.4
[    3.566111] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    3.566339] device class 'onstream_tape': registering
[    3.566997] Driver 'osst' needs updating - please use bus_type methods
[    3.567116] bus: 'scsi': add driver osst
[    3.567800] device class 'scsi_disk': registering
[    3.568474] Driver 'sd' needs updating - please use bus_type methods
[    3.568593] bus: 'scsi': add driver sd
[    3.569222] SCSI Media Changer driver v0.25 
[    3.569333] device class 'scsi_changer': registering
[    3.569986] Driver 'ch' needs updating - please use bus_type methods
[    3.570103] bus: 'scsi': add driver ch
[    3.570765] bus: 'pci': add driver ahci
[    3.571539] bus: 'pci': add driver sata_svw
[    3.573041] bus: 'pci': add driver ata_piix
[    3.573186] bus: 'pci': driver_probe_device: matched device 0000:00:07.1 with driver ata_piix
[    3.573198] bus: 'pci': really_probe: probing driver ata_piix with device 0000:00:07.1
[    3.573244] ata_piix 0000:00:07.1: version 2.12
[    3.574343] scsi0 : ata_piix
[    3.577162] device: 'host0': device_add
[    3.577227] PM: Adding info for No Bus:host0
[    3.577244] device: 'host0': device_add
[    3.577446] PM: Adding info for No Bus:host0
[    3.578603] scsi1 : ata_piix
[    3.578734] device: 'host1': device_add
[    3.578801] PM: Adding info for No Bus:host1
[    3.578815] device: 'host1': device_add
[    3.578991] PM: Adding info for No Bus:host1
[    3.579744] ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x1c20 irq 14
[    3.579861] ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x1c28 irq 15
[    3.744978] ata1.00: ATA-5: IC25N020ATCS04-0, CA2OA71A, max UDMA/100
[    3.745110] ata1.00: 39070080 sectors, multi 16: LBA 
[    3.760835] ata1.00: configured for UDMA/33
[    3.762158] scsi 0:0:0:0: Direct-Access     ATA      IC25N020ATCS04-0 CA2O PQ: 0 ANSI: 5
[    3.762345] device: 'target0:0:0': device_add
[    3.762421] PM: Adding info for No Bus:target0:0:0
[    3.762442] device: '0:0:0:0': device_add
[    3.762614] bus: 'scsi': add device 0:0:0:0
[    3.762670] PM: Adding info for scsi:0:0:0:0
[    3.763546] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver osst
[    3.763559] bus: 'scsi': really_probe: probing driver osst with device 0:0:0:0
[    3.763644] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver sd
[    3.763655] bus: 'scsi': really_probe: probing driver sd with device 0:0:0:0
[    3.763905] device: '0:0:0:0': device_add
[    3.764040] PM: Adding info for No Bus:0:0:0:0
[    3.765289] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors: (20.0 GB/18.6 GiB)
[    3.765623] sd 0:0:0:0: [sda] Write Protect is off
[    3.765729] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.766032] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.766215] device: 'sda': device_add
[    3.766448] PM: Adding info for No Bus:sda
[    3.767039] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors: (20.0 GB/18.6 GiB)
[    3.767365] sd 0:0:0:0: [sda] Write Protect is off
[    3.767469] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.767789] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.767967]  sda: sda1 sda2
[    3.831524] device: 'sda1': device_add
[    3.831746] PM: Adding info for No Bus:sda1
[    3.831803] device: 'sda2': device_add
[    3.831973] PM: Adding info for No Bus:sda2
[    3.834316] device: '8:0': device_add
[    3.834413] PM: Adding info for No Bus:8:0
[    3.835116] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.835237] driver: '0:0:0:0': driver_bound: bound to device 'sd'
[    3.835249] bus: 'scsi': really_probe: bound device 0:0:0:0 to driver sd
[    3.835272] device: '0:0:0:0': device_add
[    3.835374] PM: Adding info for No Bus:0:0:0:0
[    4.112738] ata2.00: ATAPI: QSI DVD-ROM SDR-081, EHA8, max UDMA/33
[    4.120617] ata2.00: configured for UDMA/33
[    4.121275] ------------[ cut here ]------------
[    4.121380] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x3d9/0x840()
[    4.121538] Hardware name: HP OmniBook PC         
[    4.121644] Pid: 0, comm: swapper Not tainted 2.6.28-tip-10029-g20e9954-dirty #3
[    4.121798] Call Trace:
[    4.121912]  [<c013d006>] warn_slowpath+0x86/0xa0
[    4.122030]  [<c012c5ee>] ? complete+0x4e/0x60
[    4.122136]  [<c0133270>] ? default_wake_function+0x10/0x20
[    4.122260]  [<c034e9bd>] ? _raw_spin_unlock+0x5d/0xa0
[    4.122368]  [<c012c5ee>] ? complete+0x4e/0x60
[    4.122490]  [<c06513d3>] ? ata_qc_complete_internal+0x13/0x20
[    4.122602]  [<c064f6ed>] ? __ata_qc_complete+0x6d/0xe0
[    4.122710]  [<c065e0a9>] ? ata_sff_qc_fill_rtf+0x19/0x30
[    4.122817]  [<c065fa07>] ? ata_sff_data_xfer32+0x77/0xd0
[    4.122923]  [<c0660739>] ata_sff_hsm_move+0x3d9/0x840
[    4.123029]  [<c034eb06>] ? _raw_spin_lock+0x46/0x170
[    4.123134]  [<c0660ef9>] ata_sff_interrupt+0x129/0x1e0
[    4.123246]  [<c0171dc0>] handle_IRQ_event+0x30/0x70
[    4.123354]  [<c0173b05>] handle_level_irq+0x75/0xe0
[    4.123459]  [<c0173a90>] ? handle_level_irq+0x0/0xe0
[    4.123562]  <IRQ>  [<c0104607>] ? common_interrupt+0x27/0x2c
[    4.123725]  [<c0120120>] ? native_safe_halt+0x0/0x10
[    4.123830]  [<c012012a>] ? native_safe_halt+0xa/0x10
[    4.123942]  [<c010aaf9>] ? default_idle+0x69/0xa0
[    4.124053]  [<c015f792>] ? tick_nohz_restart_sched_tick+0x32/0x1b0
[    4.124167]  [<c011715f>] ? apm_cpu_idle+0xdf/0x260
[    4.124273]  [<c01027d8>] ? cpu_idle+0x78/0x100
[    4.124379]  [<c034e9bd>] ? _raw_spin_unlock+0x5d/0xa0
[    4.124490]  [<c09a92b3>] ? rest_init+0x53/0x60
[    4.124601]  [<c0e4d82a>] ? start_kernel+0x2ba/0x360
[    4.124709]  [<c0e4d260>] ? unknown_bootoption+0x0/0x210
[    4.124820]  [<c0e4d07c>] ? i386_start_kernel+0x7c/0xb0
[    4.124948] ---[ end trace 83f9033b42a87df9 ]---
[    4.126783] scsi 1:0:0:0: CD-ROM            QSI      DVD-ROM SDR-081  EHA8 PQ: 0 ANSI: 5
[    4.126979] device: 'target1:0:0': device_add
[    4.127040] PM: Adding info for No Bus:target1:0:0
[    4.127057] device: '1:0:0:0': device_add
[    4.127191] bus: 'scsi': add device 1:0:0:0
[    4.127235] PM: Adding info for scsi:1:0:0:0
[    4.127994] bus: 'scsi': driver_probe_device: matched device 1:0:0:0 with driver osst
[    4.128007] bus: 'scsi': really_probe: probing driver osst with device 1:0:0:0
[    4.128083] bus: 'scsi': driver_probe_device: matched device 1:0:0:0 with driver sd
[    4.128093] bus: 'scsi': really_probe: probing driver sd with device 1:0:0:0
[    4.128152] bus: 'scsi': driver_probe_device: matched device 1:0:0:0 with driver ch
[    4.128161] bus: 'scsi': really_probe: probing driver ch with device 1:0:0:0
[    4.128223] device: '1:0:0:0': device_add
[    4.128340] PM: Adding info for No Bus:1:0:0:0
[    4.128952] driver: '0000:00:07.1': driver_bound: bound to device 'ata_piix'
[    4.128966] bus: 'pci': really_probe: bound device 0000:00:07.1 to driver ata_piix
[    4.129567] bus: 'pci': add driver sata_promise
[    4.130216] bus: 'pci': add driver sata_qstor
[    4.130811] bus: 'pci': add driver sata_sil
[    4.131391] bus: 'pci': add driver sata_sil24
[    4.131985] bus: 'pci': add driver sata_via
[    4.132641] bus: 'pci': add driver sata_vsc
[    4.133293] bus: 'pci': add driver sata_sx4
[    4.133907] bus: 'pci': add driver sata_nv
[    4.134526] bus: 'pci': add driver sata_inic162x
[    4.135146] bus: 'pci': add driver pdc_adma
[    4.135786] bus: 'pci': add driver pata_ali
[    4.136546] bus: 'pci': add driver pata_amd
[    4.137187] bus: 'pci': add driver pata_artop
[    4.137815] bus: 'pci': add driver pata_atiixp
[    4.138443] bus: 'pci': add driver pata_cmd64x
[    4.139096] bus: 'pci': add driver pata_cs5520
[    4.139694] bus: 'pci': add driver cs5535
[    4.140445] bus: 'pci': add driver pata_cs5536
[    4.141155] bus: 'pci': add driver pata_cypress
[    4.141923] bus: 'pci': add driver pata_efar
[    4.142572] bus: 'pci': add driver pata_hpt37x
[    4.143165] bus: 'pci': add driver pata_hpt3x2n
[    4.143813] bus: 'pci': add driver pata_hpt3x3
[    4.144878] bus: 'pci': add driver pata_it821x
[    4.145639] bus: 'pci': add driver pata_it8213
[    4.146257] bus: 'pci': add driver pata_jmicron
[    4.146854] bus: 'pci': add driver pata_netcell
[    4.147449] bus: 'pci': add driver pata_opti
[    4.148052] bus: 'pci': add driver pata_optidma
[    4.148715] bus: 'pci': add driver pata_marvell
[    4.149323] bus: 'pci': add driver pata_mpiix
[    4.149926] bus: 'pci': add driver pata_oldpiix
[    4.150764] bus: 'pcmcia': add driver pata_pcmcia
[    4.151397] bus: 'pci': add driver pata_pdc202xx_old
[    4.152026] bus: 'pci': add driver pata_rz1000
[    4.153694] bus: 'pci': add driver sc1200
[    4.154439] bus: 'pci': add driver pata_serverworks
[    4.155056] bus: 'pci': add driver pata_sil680
[    4.155680] bus: 'pci': add driver pata_via
[    4.156383] bus: 'pci': add driver pata_sl82c105
[    4.157032] bus: 'pci': add driver pata_triflex
[    4.157675] bus: 'pci': add driver ata_generic
[    4.158286] I2O subsystem v1.325
[    4.158402] i2o: max drivers = 8
[    4.160136] bus: 'i2o': registered
[    4.161394] bus: 'i2o': add driver exec-osm
[    4.162224] bus: 'pci': add driver PCI_I2O
[    4.162914] I2O Configuration OSM v1.323
[    4.163037] bus: 'i2o': add driver config-osm
[    4.163614] device: 'i2octl': device_add
[    4.164007] PM: Adding info for No Bus:i2octl
[    4.164676] I2O Bus Adapter OSM v1.317
[    4.164794] bus: 'i2o': add driver bus-osm
[    4.165333] I2O ProcFS OSM v1.316
[    4.165438] bus: 'i2o': add driver proc-osm
[    4.166025] Fusion MPT base driver 3.04.07
[    4.166129] Copyright (c) 1999-2008 LSI Corporation
[    4.166274] Fusion MPT SPI Host driver 3.04.07
[    4.166434] bus: 'pci': add driver mptspi
[    4.167108] Fusion MPT FC Host driver 3.04.07
[    4.167314] bus: 'pci': add driver mptfc
[    4.167935] Fusion MPT SAS Host driver 3.04.07
[    4.168139] bus: 'pci': add driver mptsas
[    4.171324] bus: 'firewire': registered
[    4.171415] bus: 'pci': add driver firewire_ohci
[    4.172367] bus: 'firewire': add driver sbp2
[    4.172993] device class 'spidev': registering
[    4.173554] bus: 'spi': add driver spidev
[    4.174081] bus: 'spi': add driver tle62x0
[    4.174719] bus: 'pci': add driver pd6729
[    4.175402] bus: 'pci': add driver i82092aa
[    4.176029] device class 'aoe': registering
[    4.177235] device: 'err': device_add
[    4.177634] PM: Adding info for No Bus:err
[    4.178235] device: 'discover': device_add
[    4.178481] PM: Adding info for No Bus:discover
[    4.179076] device: 'interfaces': device_add
[    4.179273] PM: Adding info for No Bus:interfaces
[    4.179852] device: 'revalidate': device_add
[    4.180044] PM: Adding info for No Bus:revalidate
[    4.180701] device: 'flush': device_add
[    4.180915] PM: Adding info for No Bus:flush
[    4.182424] aoe: AoE v47 initialised.
[    4.183045] device class 'uwb_rc': registering
[    4.183694] bus: 'usb': add driver hwa-rc
[    4.184259] usbcore: registered new interface driver hwa-rc
[    4.184777] bus: 'platform': add driver gpio-vbus
[    4.185419] bus: 'platform': remove driver gpio-vbus
[    4.185917] driver: 'gpio-vbus': driver_release
[    4.185967] device class 'usbmon': registering
[    4.186622] device: 'usbmon0': device_add
[    4.186991] PM: Adding info for No Bus:usbmon0
[    4.187766] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.187891] ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
[    4.187986] bus: 'pci': add driver ehci_hcd
[    4.188826] bus: 'platform': add driver oxu210hp-hcd
[    4.189370] 116x: driver isp116x-hcd, 03 Nov 2005
[    4.189486] bus: 'platform': add driver isp116x-hcd
[    4.190040] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.190154] ohci_hcd: block sizes: ed 64 td 64
[    4.190232] bus: 'pci': add driver ohci_hcd
[    4.190861] uhci_hcd: USB Universal Host Controller Interface driver
[    4.192054] bus: 'pci': add driver uhci_hcd
[    4.192137] bus: 'pci': driver_probe_device: matched device 0000:00:07.2 with driver uhci_hcd
[    4.192148] bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:07.2
[    4.192215] uhci_hcd 0000:00:07.2: found PCI INT D -> IRQ 10
[    4.193220] uhci_hcd 0000:00:07.2: UHCI Host Controller
[    4.193384] device: 'usb_host1': device_add
[    4.193461] PM: Adding info for No Bus:usb_host1
[    4.194353] device: 'usbmon1': device_add
[    4.194780] PM: Adding info for No Bus:usbmon1
[    4.195429] uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
[    4.195624] uhci_hcd 0000:00:07.2: detected 2 ports
[    4.195732] uhci_hcd 0000:00:07.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.195741] uhci_hcd 0000:00:07.2: Performing full reset
[    4.195816] uhci_hcd 0000:00:07.2: irq 10, io base 0x00001c00
[    4.196339] usb usb1: default language 0x0409
[    4.196442] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    4.196553] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.196707] usb usb1: Product: UHCI Host Controller
[    4.196809] usb usb1: Manufacturer: Linux 2.6.28-tip-10029-g20e9954-dirty uhci_hcd
[    4.196964] usb usb1: SerialNumber: 0000:00:07.2
[    4.197065] device: 'usb1': device_add
[    4.197517] bus: 'usb': add device usb1
[    4.197564] PM: Adding info for usb:usb1
[    4.197689] usb usb1: uevent
[    4.198341] bus: 'usb': driver_probe_device: matched device usb1 with driver usb
[    4.198353] bus: 'usb': really_probe: probing driver usb with device usb1
[    4.198391] usb usb1: usb_probe_device
[    4.198402] usb usb1: configuration #1 chosen from 1 choice
[    4.198572] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.198582] device: '1-0:1.0': device_add
[    4.198651] bus: 'usb': add device 1-0:1.0
[    4.198693] PM: Adding info for usb:1-0:1.0
[    4.198751] usb 1-0:1.0: uevent
[    4.199263] bus: 'usb': driver_probe_device: matched device 1-0:1.0 with driver hub
[    4.199274] bus: 'usb': really_probe: probing driver hub with device 1-0:1.0
[    4.199306] hub 1-0:1.0: usb_probe_interface
[    4.199315] hub 1-0:1.0: usb_probe_interface - got id
[    4.199325] hub 1-0:1.0: USB hub found
[    4.199503] hub 1-0:1.0: 2 ports detected
[    4.199601] hub 1-0:1.0: standalone hub
[    4.199608] hub 1-0:1.0: no power switching (usb 1.0)
[    4.199616] hub 1-0:1.0: individual port over-current protection
[    4.199625] hub 1-0:1.0: power on to power good time: 2ms
[    4.199672] hub 1-0:1.0: local power source is good
[    4.199685] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.199732] driver: '1-0:1.0': driver_bound: bound to device 'hub'
[    4.199744] bus: 'usb': really_probe: bound device 1-0:1.0 to driver hub
[    4.199765] device class 'usb_endpoint': registering
[    4.201212] device: 'usbdev1.1_ep81': device_add
[    4.201693] PM: Adding info for No Bus:usbdev1.1_ep81
[    4.202435] driver: 'usb1': driver_bound: bound to device 'usb'
[    4.202448] bus: 'usb': really_probe: bound device usb1 to driver usb
[    4.202486] device: 'usbdev1.1_ep00': device_add
[    4.202782] PM: Adding info for No Bus:usbdev1.1_ep00
[    4.203440] driver: '0000:00:07.2': driver_bound: bound to device 'uhci_hcd'
[    4.203453] bus: 'pci': really_probe: bound device 0000:00:07.2 to driver uhci_hcd
[    4.204000] r8a66597_hcd: driver r8a66597_hcd, 10 Apr 2008
[    4.204134] bus: 'platform': add driver r8a66597_hcd
[    4.206629] bus: 'pci': add driver isp1760
[    4.207324] bus: 'usb': add driver hwa-hc
[    4.207859] usbcore: registered new interface driver hwa-hc
[    4.207997] bus: 'platform': add driver c67x00
[    4.209665] bus: 'usb': add driver wusb-cbaf
[    4.210349] usbcore: registered new interface driver wusb-cbaf
[    4.210521] bus: 'usb': add driver cdc_acm
[    4.211073] usbcore: registered new interface driver cdc_acm
[    4.211194] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
[    4.211359] bus: 'usb': add driver cdc_wdm
[    4.211944] usbcore: registered new interface driver cdc_wdm
[    4.212065] Initializing USB Mass Storage driver...
[    4.212176] bus: 'usb': add driver usb-storage
[    4.212834] usbcore: registered new interface driver usb-storage
[    4.212957] USB Mass Storage support registered.
[    4.213070] bus: 'usb': add driver libusual
[    4.213623] usbcore: registered new interface driver libusual
[    4.213745] drivers/usb/misc/adutux.c :  adu_init : enter 
[    4.213759] bus: 'usb': add driver adutux
[    4.214436] usbcore: registered new interface driver adutux
[    4.214566] adutux adutux (see www.ontrak.net) v0.0.13
[    4.214668] adutux is an experimental driver. Use at your own risk
[    4.214777] drivers/usb/misc/adutux.c :  adu_init : leave, return value 0 
[    4.214998] bus: 'usb': add driver appledisplay
[    4.215616] usbcore: registered new interface driver appledisplay
[    4.215752] bus: 'usb': add driver berry_charge
[    4.216960] usbcore: registered new interface driver berry_charge
[    4.217122] bus: 'usb': add driver cypress_cy7c63
[    4.217763] usbcore: registered new interface driver cypress_cy7c63
[    4.217898] bus: 'usb': add driver cytherm
[    4.218475] usbcore: registered new interface driver cytherm
[    4.218593] cytherm: v1.0:Cypress USB Thermometer driver
[    4.218703] bus: 'usb': add driver emi26 - firmware loader
[    4.219278] usbcore: registered new interface driver emi26 - firmware loader
[    4.219407] driver ftdi-elan built at 13:47:57 on Jan 10 2009
[    4.220060] bus: 'usb': add driver ftdi-elan
[    4.220754] usbcore: registered new interface driver ftdi-elan
[    4.220883] idmouse: 0.6:Siemens ID Mouse FingerTIP Sensor Driver
[    4.220999] bus: 'usb': add driver idmouse
[    4.221565] usbcore: registered new interface driver idmouse
[    4.221694] bus: 'usb': add driver iowarrior
[    4.222230] usbcore: registered new interface driver iowarrior
[    4.222357] bus: 'usb': add driver isight_firmware
[    4.223068] usbcore: registered new interface driver isight_firmware
[    4.223211] bus: 'usb': add driver usblcd
[    4.223776] usbcore: registered new interface driver usblcd
[    4.223907] bus: 'usb': add driver usbled
[    4.225340] usbcore: registered new interface driver usbled
[    4.225496] drivers/usb/misc/legousbtower.c: lego_usb_tower_init: enter
[    4.225521] bus: 'usb': add driver legousbtower
[    4.226165] usbcore: registered new interface driver legousbtower
[    4.226291] legousbtower: v0.96:LEGO USB Tower Driver
[    4.226394] drivers/usb/misc/legousbtower.c: lego_usb_tower_init: leave, return value 0
[    4.226413] bus: 'usb': add driver rio500
[    4.226953] usbcore: registered new interface driver rio500
[    4.227073] rio500: v1.1:USB Rio 500 driver
[    4.227182] bus: 'usb': add driver trancevibrator
[    4.227721] usbcore: registered new interface driver trancevibrator
[    4.227844] trancevibrator: v1.1:PlayStation 2 Trance Vibrator driver
[    4.227960] bus: 'usb': add driver uss720
[    4.228592] usbcore: registered new interface driver uss720
[    4.228715] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
[    4.228877] uss720: NOTE: this is a special purpose driver to allow nonstandard
[    4.229032] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
[    4.229185] uss720: If you just want to connect to a printer, use usblp instead
[    4.229350] bus: 'usb': add driver usbsevseg
[    4.229900] usbcore: registered new interface driver usbsevseg
[    4.230031] bus: 'usb': add driver vstusb
[    4.230594] usbcore: registered new interface driver vstusb
[    4.230794] bus: 'platform': add driver i8042
[    4.231360] Registering platform device 'i8042'. Parent at platform
[    4.231373] device: 'i8042': device_add
[    4.231409] bus: 'platform': add device i8042
[    4.231467] PM: Adding info for platform:i8042
[    4.232026] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[    4.232040] bus: 'platform': really_probe: probing driver i8042 with device i8042
[    4.239808] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.239956] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.240097] driver: 'i8042': driver_bound: bound to device 'i8042'
[    4.240110] bus: 'platform': really_probe: bound device i8042 to driver i8042
[    4.240134] parkbd: no such parport
[    4.240350] bus: 'pci': add driver pcips2
[    4.240692] device: 'serio0': device_add
[    4.240727] bus: 'serio': add device serio0
[    4.240796] PM: Adding info for serio:serio0
[    4.241704] bus: 'serio': add driver serio_raw
[    4.242433] device: 'serio1': device_add
[    4.242467] bus: 'serio': add device serio1
[    4.242532] PM: Adding info for serio:serio1
[    4.242917] device: 'mice': device_add
[    4.243338] PM: Adding info for No Bus:mice
[    4.245699] device: 'mouse0': device_add
[    4.246120] PM: Adding info for No Bus:mouse0
[    4.246865] mice: PS/2 mouse device common for all mice
[    4.247284] evbug.c: Connected device: input0 (Macintosh mouse button emulation at unknown)
[    4.247312] bus: 'serio': add driver atkbd
[    4.247883] bus: 'serio': add driver sunkbd
[    4.248045] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[    4.248057] bus: 'serio': really_probe: probing driver atkbd with device serio0
[    4.248692] bus: 'serio': add driver xtkbd
[    4.249252] bus: 'serio': add driver newtonkbd
[    4.249802] bus: 'serio': add driver stowaway
[    4.250530] bus: 'platform': add driver gpio-keys
[    4.251128] bus: 'spi': add driver ads7846
[    4.251754] bus: 'serio': add driver elo
[    4.252385] bus: 'serio': add driver fujitsu_ts
[    4.252950] bus: 'serio': add driver mtouch
[    4.253503] mk712: device not present
[    4.253645] bus: 'usb': add driver usbtouchscreen
[    4.254236] usbcore: registered new interface driver usbtouchscreen
[    4.254363] bus: 'serio': add driver penmountlpc
[    4.254972] bus: 'serio': add driver touchright
[    4.255550] bus: 'serio': add driver touchwin
[    4.256165] bus: 'i2c': add driver tsc2007
[    4.256797] i2c-core: driver [tsc2007] registered
[    4.256823] bus: 'platform': add driver da9034-touch
[    4.257397] bus: 'platform': add driver pcspkr
[    4.257435] bus: 'platform': driver_probe_device: matched device pcspkr with driver pcspkr
[    4.257446] bus: 'platform': really_probe: probing driver pcspkr with device pcspkr
[    4.257522] device: 'input1': device_add
[    4.257732] PM: Adding info for No Bus:input1
[    4.258346] input: PC Speaker as /class/input/input1
[    4.259902] evbug.c: Connected device: input1 (PC Speaker at isa0061/input0)
[    4.259928] driver: 'pcspkr': driver_bound: bound to device 'pcspkr'
[    4.259940] bus: 'platform': really_probe: bound device pcspkr to driver pcspkr
[    4.260780] wistron_btns: System unknown
[    4.260922] bus: 'usb': add driver ati_remote
[    4.261567] usbcore: registered new interface driver ati_remote
[    4.261692] ati_remote: 2.2.1:ATI/X10 RF USB Remote Control
[    4.261808] bus: 'usb': add driver keyspan_remote
[    4.262363] usbcore: registered new interface driver keyspan_remote
[    4.262503] device: 'uinput': device_add
[    4.262895] PM: Adding info for No Bus:uinput
[    4.263908] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    4.264046] bus: 'platform': add driver rtc-ds1286
[    4.264879] bus: 'spi': add driver rtc-ds1305
[    4.265476] bus: 'i2c': add driver rtc-ds1307
[    4.266043] i2c-core: driver [rtc-ds1307] registered
[    4.266069] bus: 'i2c': add driver rtc-ds1374
[    4.266602] i2c-core: driver [rtc-ds1374] registered
[    4.266619] bus: 'spi': add driver rtc-ds1390
[    4.267158] bus: 'platform': add driver ds1511
[    4.267715] bus: 'platform': add driver rtc-ds1553
[    4.268390] bus: 'i2c': add driver rtc-ds1672
[    4.269033] i2c-core: driver [rtc-ds1672] registered
[    4.269057] bus: 'platform': add driver rtc-ds1742
[    4.269623] bus: 'i2c': add driver rtc-fm3130
[    4.270190] i2c-core: driver [rtc-fm3130] registered
[    4.270219] bus: 'i2c': add driver rtc-isl1208
[    4.270777] i2c-core: driver [rtc-isl1208] registered
[    4.270799] bus: 'platform': add driver rtc-m48t35
[    4.271368] bus: 'platform': add driver rtc-m48t59
[    4.271999] bus: 'platform': add driver rtc-m48t86
[    4.272646] bus: 'platform': add driver rtc-bq4802
[    4.273242] bus: 'spi': add driver rtc-max6902
[    4.273805] bus: 'i2c': add driver rtc-pcf8563
[    4.274509] i2c-core: driver [rtc-pcf8563] registered
[    4.274542] bus: 'i2c': add driver pcf8583
[    4.275096] i2c-core: driver [pcf8583] registered
[    4.275116] bus: 'spi': add driver rtc-r9701
[    4.275652] bus: 'spi': add driver rtc-rs5c348
[    4.276430] bus: 'i2c': add driver rtc-rx8581
[    4.277001] i2c-core: driver [rtc-rx8581] registered
[    4.277031] bus: 'i2c': add driver rtc-s35390a
[    4.277566] i2c-core: driver [rtc-s35390a] registered
[    4.277593] bus: 'platform': add driver stk17ta8
[    4.278231] bus: 'platform': add driver rtc-test
[    4.279009] Registering platform device 'rtc-test.0'. Parent at platform
[    4.279023] device: 'rtc-test.0': device_add
[    4.279067] bus: 'platform': add device rtc-test.0
[    4.279125] PM: Adding info for platform:rtc-test.0
[    4.279819] bus: 'platform': driver_probe_device: matched device rtc-test.0 with driver rtc-test
[    4.279832] bus: 'platform': really_probe: probing driver rtc-test with device rtc-test.0
[    4.279924] device: 'rtc0': device_add
[    4.281069] PM: Adding info for No Bus:rtc0
[    4.281885] test: dev (254:0)
[    4.281940] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    4.282076] driver: 'rtc-test.0': driver_bound: bound to device 'rtc-test'
[    4.282088] bus: 'platform': really_probe: bound device rtc-test.0 to driver rtc-test
[    4.282108] Registering platform device 'rtc-test.1'. Parent at platform
[    4.282117] device: 'rtc-test.1': device_add
[    4.282153] bus: 'platform': add device rtc-test.1
[    4.282240] PM: Adding info for platform:rtc-test.1
[    4.282904] bus: 'platform': driver_probe_device: matched device rtc-test.1 with driver rtc-test
[    4.282918] bus: 'platform': really_probe: probing driver rtc-test with device rtc-test.1
[    4.282983] device: 'rtc1': device_add
[    4.283363] PM: Adding info for No Bus:rtc1
[    4.283984] test: dev (254:1)
[    4.283993] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    4.284123] driver: 'rtc-test.1': driver_bound: bound to device 'rtc-test'
[    4.284134] bus: 'platform': really_probe: bound device rtc-test.1 to driver rtc-test
[    4.284172] bus: 'platform': add driver twl4030_rtc
[    4.284827] bus: 'platform': add driver v3020
[    4.285425] bus: 'i2c': add driver rtc-x1205
[    4.286004] i2c-core: driver [rtc-x1205] registered
[    4.286072] bus: 'pci': add driver ali1563_smbus
[    4.286751] bus: 'pci': add driver ali15x3_smbus
[    4.287378] bus: 'pci': add driver amd756_smbus
[    4.288042] bus: 'pci': add driver amd8111_smbus2
[    4.289669] bus: 'pci': add driver isch_smbus
[    4.290057] device: 'input2': device_add
[    4.290231] PM: Adding info for No Bus:input2
[    4.291119] bus: 'pci': add driver nForce2_smbus
[    4.291885] input: AT Translated Set 2 keyboard as /class/input/input2
[    4.292197] bus: 'pci': add driver piix4_smbus
[    4.292266] bus: 'pci': driver_probe_device: matched device 0000:00:07.3 with driver piix4_smbus
[    4.292338] bus: 'pci': really_probe: probing driver piix4_smbus with device 0000:00:07.3
[    4.292403] piix4_smbus 0000:00:07.3: Using Interrupt SMI# for SMBus.
[    4.292416] piix4_smbus 0000:00:07.3: SMBus Host Controller at 0x2180, revision 0
[    4.292622] device: 'i2c-0': device_add
[    4.292732] PM: Adding info for No Bus:i2c-0
[    4.293369] i2c-adapter i2c-0: adapter [SMBus PIIX4 adapter at 2180] registered
[    4.293465] driver: '0000:00:07.3': driver_bound: bound to device 'piix4_smbus'
[    4.293476] bus: 'pci': really_probe: bound device 0000:00:07.3 to driver piix4_smbus
[    4.294102] bus: 'pci': add driver sis5595_smbus
[    4.294743] bus: 'pci': add driver sis96x_smbus
[    4.295379] bus: 'pci': add driver vt586b_smbus
[    4.295970] i2c-parport: adapter type unspecified
[    4.296085] i2c-parport-light: adapter type unspecified
[    4.296196] bus: 'serio': add driver taos-evm
[    4.297366] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.298022] bus: 'usb': add driver i2c-tiny-usb
[    4.298647] usbcore: registered new interface driver i2c-tiny-usb
[    4.298796] bus: 'platform': add driver i2c-pca-platform
[    4.299389] scx200_i2c: NatSemi SCx200 I2C Driver
[    4.299400] scx200_i2c: no SCx200 gpio pins available
[    4.299536] bus: 'i2c': add driver ds1682
[    4.300116] i2c-core: driver [ds1682] registered
[    4.300148] bus: 'i2c': add driver at24
[    4.300816] i2c-core: driver [at24] registered
[    4.300848] bus: 'i2c': add driver eeprom
[    4.301396] i2c-core: driver [eeprom] registered
[    4.301421] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x50
[    4.301455] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=a0, DAT0=04, DAT1=00
[    4.303714] evbug.c: Connected device: input2 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[    4.303747] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    4.303760] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[    4.303779] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[    4.303788] bus: 'serio': really_probe: probing driver atkbd with device serio1
[    4.308353] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=a0, DAT0=04, DAT1=00
[    4.308388] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=a0, DAT0=04, DAT1=00
[    4.316330] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=a0, DAT0=04, DAT1=00
[    4.316344] i2c-adapter i2c-0: Creating eeprom at 0x50
[    4.316375] device: '0-0050': device_add
[    4.316413] bus: 'i2c': add device 0-0050
[    4.316469] PM: Adding info for i2c:0-0050
[    4.316531] i2c 0-0050: uevent
[    4.317313] bus: 'i2c': driver_probe_device: matched device 0-0050 with driver eeprom
[    4.317327] bus: 'i2c': really_probe: probing driver eeprom with device 0-0050
[    4.317359] eeprom 0-0050: probe
[    4.317382] driver: '0-0050': driver_bound: bound to device 'eeprom'
[    4.317393] bus: 'i2c': really_probe: bound device 0-0050 to driver eeprom
[    4.317409] i2c-adapter i2c-0: client [eeprom] registered with bus id 0-0050
[    4.317421] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x51
[    4.317452] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=a2, DAT0=04, DAT1=00
[    4.324312] i2c-adapter i2c-0: Error: no response!
[    4.324341] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=a2, DAT0=04, DAT1=00
[    4.324352] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x52
[    4.324382] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=a4, DAT0=04, DAT1=00
[    4.332308] i2c-adapter i2c-0: Error: no response!
[    4.332337] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=a4, DAT0=04, DAT1=00
[    4.332348] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x53
[    4.332376] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=a6, DAT0=04, DAT1=00
[    4.340309] i2c-adapter i2c-0: Error: no response!
[    4.340338] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=a6, DAT0=04, DAT1=00
[    4.340349] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x54
[    4.340377] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=a8, DAT0=04, DAT1=00
[    4.348312] i2c-adapter i2c-0: Error: no response!
[    4.348341] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=a8, DAT0=04, DAT1=00
[    4.348351] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x55
[    4.348380] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=aa, DAT0=04, DAT1=00
[    4.356320] i2c-adapter i2c-0: Error: no response!
[    4.356348] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=aa, DAT0=04, DAT1=00
[    4.356359] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x56
[    4.356388] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=ac, DAT0=04, DAT1=00
[    4.364312] i2c-adapter i2c-0: Error: no response!
[    4.364341] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=ac, DAT0=04, DAT1=00
[    4.364352] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x57
[    4.364380] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=ae, DAT0=04, DAT1=00
[    4.372313] i2c-adapter i2c-0: Error: no response!
[    4.372342] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=ae, DAT0=04, DAT1=00
[    4.372397] bus: 'i2c': add driver max6875
[    4.373048] i2c-core: driver [max6875] registered
[    4.373093] bus: 'i2c': add driver pcf8591
[    4.373654] i2c-core: driver [pcf8591] registered
[    4.373677] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x48
[    4.373710] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=90, DAT0=04, DAT1=00
[    4.380316] i2c-adapter i2c-0: Error: no response!
[    4.380347] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=90, DAT0=04, DAT1=00
[    4.380358] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x49
[    4.380388] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=92, DAT0=04, DAT1=00
[    4.388315] i2c-adapter i2c-0: Error: no response!
[    4.388344] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=92, DAT0=04, DAT1=00
[    4.388355] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4a
[    4.388383] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=94, DAT0=04, DAT1=00
[    4.396316] i2c-adapter i2c-0: Error: no response!
[    4.396345] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=94, DAT0=04, DAT1=00
[    4.396356] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4b
[    4.396384] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=96, DAT0=04, DAT1=00
[    4.404317] i2c-adapter i2c-0: Error: no response!
[    4.404346] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=96, DAT0=04, DAT1=00
[    4.404357] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
[    4.404385] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=98, DAT0=04, DAT1=00
[    4.412318] i2c-adapter i2c-0: Error: no response!
[    4.412347] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=98, DAT0=04, DAT1=00
[    4.412358] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4d
[    4.412386] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=9a, DAT0=04, DAT1=00
[    4.420319] i2c-adapter i2c-0: Error: no response!
[    4.420348] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=9a, DAT0=04, DAT1=00
[    4.420359] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
[    4.420387] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=9c, DAT0=04, DAT1=00
[    4.428320] i2c-adapter i2c-0: Error: no response!
[    4.428349] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=9c, DAT0=04, DAT1=00
[    4.428360] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4f
[    4.428388] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=9e, DAT0=04, DAT1=00
[    4.436321] i2c-adapter i2c-0: Error: no response!
[    4.436350] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=9e, DAT0=04, DAT1=00
[    4.436368] Driver for 1-wire Dallas network protocol.
[    4.437079] bus: 'w1': registered
[    4.437090] bus: 'w1': add driver w1_master_driver
[    4.437599] bus: 'w1': add driver w1_slave_driver
[    4.438186] bus: 'pci': add driver matrox_w1
[    4.438846] bus: 'platform': add driver w1-gpio
[    4.439474] bus: 'platform': remove driver w1-gpio
[    4.439977] driver: 'w1-gpio': driver_release
[    4.440002] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[    4.440194] bus: 'platform': add driver pda-power
[    4.440833] bus: 'platform': add driver ds2760-battery
[    4.441468] bus: 'i2c': add driver bq27200-battery
[    4.442035] i2c-core: driver [bq27200-battery] registered
[    4.442062] bus: 'platform': add driver da903x-battery
[    4.442658] bus: 'i2c': add driver asb100
[    4.443225] i2c-core: driver [asb100] registered
[    4.443250] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.443284] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.448330] i2c-adapter i2c-0: Error: no response!
[    4.448363] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.448420] bus: 'i2c': add driver w83792d
[    4.449120] i2c-core: driver [w83792d] registered
[    4.449145] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[    4.449179] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.456326] i2c-adapter i2c-0: Error: no response!
[    4.456355] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.456367] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.456396] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.464325] i2c-adapter i2c-0: Error: no response!
[    4.464353] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.464364] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[    4.464392] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.472325] i2c-adapter i2c-0: Error: no response!
[    4.472354] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.472365] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
[    4.472393] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5e, DAT0=04, DAT1=00
[    4.480327] i2c-adapter i2c-0: Error: no response!
[    4.480355] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5e, DAT0=04, DAT1=00
[    4.480395] bus: 'i2c': add driver w83793
[    4.480955] i2c-core: driver [w83793] registered
[    4.480977] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[    4.481008] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.488330] i2c-adapter i2c-0: Error: no response!
[    4.488359] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.488370] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.488399] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.496328] i2c-adapter i2c-0: Error: no response!
[    4.496357] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.496368] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[    4.496396] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.504329] i2c-adapter i2c-0: Error: no response!
[    4.504358] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.504368] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
[    4.504397] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5e, DAT0=04, DAT1=00
[    4.512330] i2c-adapter i2c-0: Error: no response!
[    4.512359] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5e, DAT0=04, DAT1=00
[    4.512396] bus: 'i2c': add driver w83781d
[    4.512933] i2c-core: driver [w83781d] registered
[    4.512956] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x28
[    4.512987] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=50, DAT0=04, DAT1=00
[    4.520334] i2c-adapter i2c-0: Error: no response!
[    4.520363] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=50, DAT0=04, DAT1=00
[    4.520374] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
[    4.520403] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=52, DAT0=04, DAT1=00
[    4.528332] i2c-adapter i2c-0: Error: no response!
[    4.528361] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=52, DAT0=04, DAT1=00
[    4.528371] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
[    4.528400] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=54, DAT0=04, DAT1=00
[    4.536333] i2c-adapter i2c-0: Error: no response!
[    4.536362] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=54, DAT0=04, DAT1=00
[    4.536372] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
[    4.536401] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=56, DAT0=04, DAT1=00
[    4.544334] i2c-adapter i2c-0: Error: no response!
[    4.544363] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=56, DAT0=04, DAT1=00
[    4.544373] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[    4.544402] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.552335] i2c-adapter i2c-0: Error: no response!
[    4.552363] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.552374] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.552403] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.560336] i2c-adapter i2c-0: Error: no response!
[    4.560364] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.560375] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[    4.560404] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.568337] i2c-adapter i2c-0: Error: no response!
[    4.568365] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.568376] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
[    4.568404] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5e, DAT0=04, DAT1=00
[    4.576338] i2c-adapter i2c-0: Error: no response!
[    4.576370] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5e, DAT0=04, DAT1=00
[    4.576408] bus: 'i2c': add driver w83791d
[    4.576953] i2c-core: driver [w83791d] registered
[    4.576974] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[    4.577005] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.584342] i2c-adapter i2c-0: Error: no response!
[    4.584371] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.584382] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.584411] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.592340] i2c-adapter i2c-0: Error: no response!
[    4.592369] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.592379] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[    4.592410] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.600341] i2c-adapter i2c-0: Error: no response!
[    4.600369] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.600380] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
[    4.600408] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5e, DAT0=04, DAT1=00
[    4.608342] i2c-adapter i2c-0: Error: no response!
[    4.608370] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5e, DAT0=04, DAT1=00
[    4.608413] bus: 'i2c': add driver ad7414
[    4.609005] i2c-core: driver [ad7414] registered
[    4.609037] bus: 'i2c': add driver ad7418
[    4.609581] i2c-core: driver [ad7418] registered
[    4.609603] bus: 'spi': add driver adcxx1s
[    4.610163] bus: 'spi': add driver adcxx2s
[    4.610678] bus: 'spi': add driver adcxx4s
[    4.611198] bus: 'spi': add driver adcxx8s
[    4.611762] bus: 'i2c': add driver adm1021
[    4.612391] i2c-core: driver [adm1021] registered
[    4.612419] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x18
[    4.612454] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=30, DAT0=04, DAT1=00
[    4.620349] i2c-adapter i2c-0: Error: no response!
[    4.620380] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=30, DAT0=04, DAT1=00
[    4.620392] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x19
[    4.620422] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=32, DAT0=04, DAT1=00
[    4.628345] i2c-adapter i2c-0: Error: no response!
[    4.628373] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=32, DAT0=04, DAT1=00
[    4.628384] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x1a
[    4.628412] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=34, DAT0=04, DAT1=00
[    4.636345] i2c-adapter i2c-0: Error: no response!
[    4.636374] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=34, DAT0=04, DAT1=00
[    4.636385] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
[    4.636413] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=52, DAT0=04, DAT1=00
[    4.644346] i2c-adapter i2c-0: Error: no response!
[    4.644375] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=52, DAT0=04, DAT1=00
[    4.644386] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
[    4.644414] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=54, DAT0=04, DAT1=00
[    4.652347] i2c-adapter i2c-0: Error: no response!
[    4.652376] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=54, DAT0=04, DAT1=00
[    4.652387] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
[    4.652415] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=56, DAT0=04, DAT1=00
[    4.660348] i2c-adapter i2c-0: Error: no response!
[    4.660377] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=56, DAT0=04, DAT1=00
[    4.660387] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
[    4.660416] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=98, DAT0=04, DAT1=00
[    4.668349] i2c-adapter i2c-0: Error: no response!
[    4.668378] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=98, DAT0=04, DAT1=00
[    4.668388] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4d
[    4.668417] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=9a, DAT0=04, DAT1=00
[    4.676350] i2c-adapter i2c-0: Error: no response!
[    4.676379] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=9a, DAT0=04, DAT1=00
[    4.676389] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
[    4.676418] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=9c, DAT0=04, DAT1=00
[    4.684351] i2c-adapter i2c-0: Error: no response!
[    4.684380] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=9c, DAT0=04, DAT1=00
[    4.684430] bus: 'i2c': add driver adm1025
[    4.685085] i2c-core: driver [adm1025] registered
[    4.685110] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[    4.685141] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.692355] i2c-adapter i2c-0: Error: no response!
[    4.692385] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.692396] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.692424] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.700353] i2c-adapter i2c-0: Error: no response!
[    4.700382] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.700392] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[    4.700421] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.708354] i2c-adapter i2c-0: Error: no response!
[    4.708383] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.708424] bus: 'i2c': add driver adm1029
[    4.708978] i2c-core: driver [adm1029] registered
[    4.709002] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x28
[    4.709033] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=50, DAT0=04, DAT1=00
[    4.716357] i2c-adapter i2c-0: Error: no response!
[    4.716386] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=50, DAT0=04, DAT1=00
[    4.716397] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
[    4.716426] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=52, DAT0=04, DAT1=00
[    4.724371] i2c-adapter i2c-0: Error: no response!
[    4.724400] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=52, DAT0=04, DAT1=00
[    4.724411] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
[    4.724439] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=54, DAT0=04, DAT1=00
[    4.732357] i2c-adapter i2c-0: Error: no response!
[    4.732386] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=54, DAT0=04, DAT1=00
[    4.732396] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
[    4.732425] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=56, DAT0=04, DAT1=00
[    4.740358] i2c-adapter i2c-0: Error: no response!
[    4.740387] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=56, DAT0=04, DAT1=00
[    4.740397] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[    4.740426] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.748358] i2c-adapter i2c-0: Error: no response!
[    4.748388] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.748398] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.748426] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.756359] i2c-adapter i2c-0: Error: no response!
[    4.756388] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.756399] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[    4.756427] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.764360] i2c-adapter i2c-0: Error: no response!
[    4.764389] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.764400] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
[    4.764428] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5e, DAT0=04, DAT1=00
[    4.772365] i2c-adapter i2c-0: Error: no response!
[    4.772393] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5e, DAT0=04, DAT1=00
[    4.772434] bus: 'i2c': add driver adm1031
[    4.772986] i2c-core: driver [adm1031] registered
[    4.773010] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[    4.773041] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.780365] i2c-adapter i2c-0: Error: no response!
[    4.780394] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.780405] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.780434] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.788363] i2c-adapter i2c-0: Error: no response!
[    4.788392] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.788403] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[    4.788431] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.796364] i2c-adapter i2c-0: Error: no response!
[    4.796393] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.796433] bus: 'i2c': add driver ads7828
[    4.796974] i2c-core: driver [ads7828] registered
[    4.796998] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x48
[    4.797028] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=90, DAT0=04, DAT1=00
[    4.804367] i2c-adapter i2c-0: Error: no response!
[    4.804397] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=90, DAT0=04, DAT1=00
[    4.804408] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x49
[    4.804437] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=92, DAT0=04, DAT1=00
[    4.812366] i2c-adapter i2c-0: Error: no response!
[    4.812395] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=92, DAT0=04, DAT1=00
[    4.812406] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4a
[    4.812434] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=94, DAT0=04, DAT1=00
[    4.820367] i2c-adapter i2c-0: Error: no response!
[    4.820396] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=94, DAT0=04, DAT1=00
[    4.820407] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4b
[    4.820435] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=96, DAT0=04, DAT1=00
[    4.828368] i2c-adapter i2c-0: Error: no response!
[    4.828397] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=96, DAT0=04, DAT1=00
[    4.828437] bus: 'i2c': add driver adt7462
[    4.828983] i2c-core: driver [adt7462] registered
[    4.829007] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x58
[    4.829038] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=b0, DAT0=04, DAT1=00
[    4.836373] i2c-adapter i2c-0: Error: no response!
[    4.836402] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=b0, DAT0=04, DAT1=00
[    4.836413] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x5c
[    4.836443] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=b8, DAT0=04, DAT1=00
[    4.844370] i2c-adapter i2c-0: Error: no response!
[    4.844399] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=b8, DAT0=04, DAT1=00
[    4.844437] bus: 'i2c': add driver adt7470
[    4.844977] i2c-core: driver [adt7470] registered
[    4.845000] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[    4.845030] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.852373] i2c-adapter i2c-0: Error: no response!
[    4.852403] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.852413] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[    4.852442] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.860372] i2c-adapter i2c-0: Error: no response!
[    4.860403] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.860414] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
[    4.860442] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5e, DAT0=04, DAT1=00
[    4.868373] i2c-adapter i2c-0: Error: no response!
[    4.868402] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5e, DAT0=04, DAT1=00
[    4.868444] applesmc: supported laptop not found!
[    4.868558] applesmc: driver init failed (ret=-19)!
[    4.868676] bus: 'platform': add driver coretemp
[    4.869288] bus: 'platform': remove driver coretemp
[    4.869815] driver: 'coretemp': driver_release
[    4.869865] bus: 'i2c': add driver dme1737
[    4.870424] i2c-core: driver [dme1737] registered
[    4.870450] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[    4.870482] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.876377] i2c-adapter i2c-0: Error: no response!
[    4.876408] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.876419] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.876449] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.884375] i2c-adapter i2c-0: Error: no response!
[    4.884404] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.884415] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[    4.884443] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.892376] i2c-adapter i2c-0: Error: no response!
[    4.892405] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.892433] f71882fg: Not a Fintek device
[    4.892543] f71882fg: Not a Fintek device
[    4.892668] bus: 'i2c': add driver f75375
[    4.893294] i2c-core: driver [f75375] registered
[    4.893319] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.893350] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.900379] i2c-adapter i2c-0: Error: no response!
[    4.900409] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.900420] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[    4.900448] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.908378] i2c-adapter i2c-0: Error: no response!
[    4.908407] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    4.908449] bus: 'i2c': add driver fscher
[    4.908995] i2c-core: driver [fscher] registered
[    4.909019] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x73
[    4.909049] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=e6, DAT0=04, DAT1=00
[    4.916381] i2c-adapter i2c-0: Error: no response!
[    4.916411] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=e6, DAT0=04, DAT1=00
[    4.916450] bus: 'i2c': add driver fscpos
[    4.916989] i2c-core: driver [fscpos] registered
[    4.917011] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x73
[    4.917041] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=e6, DAT0=04, DAT1=00
[    4.924382] i2c-adapter i2c-0: Error: no response!
[    4.924411] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=e6, DAT0=04, DAT1=00
[    4.924449] bus: 'i2c': add driver gl520sm
[    4.924999] i2c-core: driver [gl520sm] registered
[    4.925022] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[    4.925052] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.932383] i2c-adapter i2c-0: Error: no response!
[    4.932412] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    4.932424] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[    4.932452] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.940382] i2c-adapter i2c-0: Error: no response!
[    4.940410] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    4.940457] hdaps: supported laptop not found!
[    4.940567] hdaps: driver init failed (ret=-19)!
[    4.940683] bus: 'platform': add driver i5k_amb
[    4.941253] Registering platform device 'i5k_amb.0'. Parent at platform
[    4.941265] device: 'i5k_amb.0': device_add
[    4.941304] bus: 'platform': add device i5k_amb.0
[    4.941360] PM: Adding info for platform:i5k_amb.0
[    4.941906] bus: 'platform': driver_probe_device: matched device i5k_amb.0 with driver i5k_amb
[    4.941919] bus: 'platform': really_probe: probing driver i5k_amb with device i5k_amb.0
[    4.942105] bus: 'pci': add driver k8temp
[    4.942784] bus: 'i2c': add driver lm63
[    4.943357] i2c-core: driver [lm63] registered
[    4.943382] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
[    4.943415] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=98, DAT0=04, DAT1=00
[    4.948387] i2c-adapter i2c-0: Error: no response!
[    4.948417] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=98, DAT0=04, DAT1=00
[    4.948462] bus: 'i2c': add driver lm77
[    4.949063] i2c-core: driver [lm77] registered
[    4.949088] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x48
[    4.949120] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=90, DAT0=04, DAT1=00
[    4.956386] i2c-adapter i2c-0: Error: no response!
[    4.956415] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=90, DAT0=04, DAT1=00
[    4.956426] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x49
[    4.956455] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=92, DAT0=04, DAT1=00
[    4.964385] i2c-adapter i2c-0: Error: no response!
[    4.964413] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=92, DAT0=04, DAT1=00
[    4.964424] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4a
[    4.964453] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=94, DAT0=04, DAT1=00
[    4.972385] i2c-adapter i2c-0: Error: no response!
[    4.972415] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=94, DAT0=04, DAT1=00
[    4.972425] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4b
[    4.972453] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=96, DAT0=04, DAT1=00
[    4.980387] i2c-adapter i2c-0: Error: no response!
[    4.980415] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=96, DAT0=04, DAT1=00
[    4.980489] bus: 'i2c': add driver lm78
[    4.981041] i2c-core: driver [lm78] registered
[    4.981065] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x28
[    4.981097] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=50, DAT0=04, DAT1=00
[    4.988389] i2c-adapter i2c-0: Error: no response!
[    4.988419] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=50, DAT0=04, DAT1=00
[    4.988430] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
[    4.988458] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=52, DAT0=04, DAT1=00
[    4.996388] i2c-adapter i2c-0: Error: no response!
[    4.996417] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=52, DAT0=04, DAT1=00
[    4.996428] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
[    4.996456] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=54, DAT0=04, DAT1=00
[    5.004423] i2c-adapter i2c-0: Error: no response!
[    5.004452] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=54, DAT0=04, DAT1=00
[    5.004463] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
[    5.004492] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=56, DAT0=04, DAT1=00
[    5.012390] i2c-adapter i2c-0: Error: no response!
[    5.012419] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=56, DAT0=04, DAT1=00
[    5.012430] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[    5.012458] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    5.020391] i2c-adapter i2c-0: Error: no response!
[    5.020420] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    5.020431] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[    5.020459] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    5.028392] i2c-adapter i2c-0: Error: no response!
[    5.028421] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    5.028432] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[    5.028460] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    5.036393] i2c-adapter i2c-0: Error: no response!
[    5.036421] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    5.036432] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
[    5.036461] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5e, DAT0=04, DAT1=00
[    5.044394] i2c-adapter i2c-0: Error: no response!
[    5.044423] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5e, DAT0=04, DAT1=00
[    5.044465] bus: 'i2c': add driver lm80
[    5.045050] i2c-core: driver [lm80] registered
[    5.045073] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x28
[    5.045104] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=50, DAT0=04, DAT1=00
[    5.052397] i2c-adapter i2c-0: Error: no response!
[    5.052427] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=50, DAT0=04, DAT1=00
[    5.052438] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
[    5.052466] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=52, DAT0=04, DAT1=00
[    5.060396] i2c-adapter i2c-0: Error: no response!
[    5.060425] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=52, DAT0=04, DAT1=00
[    5.060436] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
[    5.060464] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=54, DAT0=04, DAT1=00
[    5.068397] i2c-adapter i2c-0: Error: no response!
[    5.068426] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=54, DAT0=04, DAT1=00
[    5.068437] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
[    5.068465] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=56, DAT0=04, DAT1=00
[    5.076398] i2c-adapter i2c-0: Error: no response!
[    5.076427] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=56, DAT0=04, DAT1=00
[    5.076438] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[    5.076466] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    5.084399] i2c-adapter i2c-0: Error: no response!
[    5.084428] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    5.084439] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[    5.084467] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    5.092400] i2c-adapter i2c-0: Error: no response!
[    5.092429] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    5.092439] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[    5.092468] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    5.100401] i2c-adapter i2c-0: Error: no response!
[    5.100430] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    5.100441] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
[    5.100469] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5e, DAT0=04, DAT1=00
[    5.108402] i2c-adapter i2c-0: Error: no response!
[    5.108431] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5e, DAT0=04, DAT1=00
[    5.108471] bus: 'i2c': add driver lm83
[    5.109020] i2c-core: driver [lm83] registered
[    5.109043] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x18
[    5.109073] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=30, DAT0=04, DAT1=00
[    5.116405] i2c-adapter i2c-0: Error: no response!
[    5.116435] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=30, DAT0=04, DAT1=00
[    5.116446] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x19
[    5.116474] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=32, DAT0=04, DAT1=00
[    5.124404] i2c-adapter i2c-0: Error: no response!
[    5.124433] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=32, DAT0=04, DAT1=00
[    5.124443] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x1a
[    5.124472] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=34, DAT0=04, DAT1=00
[    5.132405] i2c-adapter i2c-0: Error: no response!
[    5.132434] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=34, DAT0=04, DAT1=00
[    5.132444] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
[    5.132473] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=52, DAT0=04, DAT1=00
[    5.140406] i2c-adapter i2c-0: Error: no response!
[    5.140435] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=52, DAT0=04, DAT1=00
[    5.140445] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
[    5.140474] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=54, DAT0=04, DAT1=00
[    5.148407] i2c-adapter i2c-0: Error: no response!
[    5.148436] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=54, DAT0=04, DAT1=00
[    5.148446] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
[    5.148475] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=56, DAT0=04, DAT1=00
[    5.156408] i2c-adapter i2c-0: Error: no response!
[    5.156437] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=56, DAT0=04, DAT1=00
[    5.156447] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
[    5.156476] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=98, DAT0=04, DAT1=00
[    5.164409] i2c-adapter i2c-0: Error: no response!
[    5.164438] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=98, DAT0=04, DAT1=00
[    5.164448] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4d
[    5.164476] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=9a, DAT0=04, DAT1=00
[    5.172410] i2c-adapter i2c-0: Error: no response!
[    5.172438] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=9a, DAT0=04, DAT1=00
[    5.172449] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
[    5.172478] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=9c, DAT0=04, DAT1=00
[    5.180411] i2c-adapter i2c-0: Error: no response!
[    5.180440] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=9c, DAT0=04, DAT1=00
[    5.180482] bus: 'i2c': add driver lm87
[    5.181031] i2c-core: driver [lm87] registered
[    5.181053] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[    5.181086] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    5.188414] i2c-adapter i2c-0: Error: no response!
[    5.188443] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    5.188454] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[    5.188482] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    5.196413] i2c-adapter i2c-0: Error: no response!
[    5.196441] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    5.196452] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[    5.196480] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    5.204413] i2c-adapter i2c-0: Error: no response!
[    5.204443] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    5.204483] bus: 'i2c': add driver lm90
[    5.205028] i2c-core: driver [lm90] registered
[    5.205052] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x18
[    5.205083] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=30, DAT0=04, DAT1=00
[    5.212416] i2c-adapter i2c-0: Error: no response!
[    5.212446] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=30, DAT0=04, DAT1=00
[    5.212457] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x19
[    5.212485] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=32, DAT0=04, DAT1=00
[    5.220416] i2c-adapter i2c-0: Error: no response!
[    5.220444] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=32, DAT0=04, DAT1=00
[    5.220455] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x1a
[    5.220483] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=34, DAT0=04, DAT1=00
[    5.228417] i2c-adapter i2c-0: Error: no response!
[    5.228445] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=34, DAT0=04, DAT1=00
[    5.228456] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
[    5.228484] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=52, DAT0=04, DAT1=00
[    5.236418] i2c-adapter i2c-0: Error: no response!
[    5.236446] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=52, DAT0=04, DAT1=00
[    5.236457] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
[    5.236485] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=54, DAT0=04, DAT1=00
[    5.244418] i2c-adapter i2c-0: Error: no response!
[    5.244447] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=54, DAT0=04, DAT1=00
[    5.244458] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
[    5.244486] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=56, DAT0=04, DAT1=00
[    5.252419] i2c-adapter i2c-0: Error: no response!
[    5.252448] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=56, DAT0=04, DAT1=00
[    5.252459] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
[    5.252487] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=98, DAT0=04, DAT1=00
[    5.260421] i2c-adapter i2c-0: Error: no response!
[    5.260449] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=98, DAT0=04, DAT1=00
[    5.260460] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4d
[    5.260488] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=9a, DAT0=04, DAT1=00
[    5.268421] i2c-adapter i2c-0: Error: no response!
[    5.268450] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=9a, DAT0=04, DAT1=00
[    5.268461] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
[    5.268489] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=9c, DAT0=04, DAT1=00
[    5.276422] i2c-adapter i2c-0: Error: no response!
[    5.276451] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=9c, DAT0=04, DAT1=00
[    5.276493] bus: 'i2c': add driver ltc4245
[    5.277040] i2c-core: driver [ltc4245] registered
[    5.277077] bus: 'spi': add driver max1111
[    5.277624] bus: 'i2c': add driver max1619
[    5.278174] i2c-core: driver [max1619] registered
[    5.278198] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x18
[    5.278231] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=30, DAT0=04, DAT1=00
[    5.284427] i2c-adapter i2c-0: Error: no response!
[    5.284458] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=30, DAT0=04, DAT1=00
[    5.284469] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x19
[    5.284498] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=32, DAT0=04, DAT1=00
[    5.292424] i2c-adapter i2c-0: Error: no response!
[    5.292453] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=32, DAT0=04, DAT1=00
[    5.292464] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x1a
[    5.292492] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=34, DAT0=04, DAT1=00
[    5.300425] i2c-adapter i2c-0: Error: no response!
[    5.300454] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=34, DAT0=04, DAT1=00
[    5.300465] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
[    5.300493] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=52, DAT0=04, DAT1=00
[    5.308426] i2c-adapter i2c-0: Error: no response!
[    5.308455] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=52, DAT0=04, DAT1=00
[    5.308466] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
[    5.308494] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=54, DAT0=04, DAT1=00
[    5.316427] i2c-adapter i2c-0: Error: no response!
[    5.316456] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=54, DAT0=04, DAT1=00
[    5.316467] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
[    5.316495] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=56, DAT0=04, DAT1=00
[    5.324428] i2c-adapter i2c-0: Error: no response!
[    5.324457] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=56, DAT0=04, DAT1=00
[    5.324468] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
[    5.324496] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=98, DAT0=04, DAT1=00
[    5.332429] i2c-adapter i2c-0: Error: no response!
[    5.332457] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=98, DAT0=04, DAT1=00
[    5.332468] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4d
[    5.332497] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=9a, DAT0=04, DAT1=00
[    5.340430] i2c-adapter i2c-0: Error: no response!
[    5.340459] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=9a, DAT0=04, DAT1=00
[    5.340470] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
[    5.340498] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=9c, DAT0=04, DAT1=00
[    5.348432] i2c-adapter i2c-0: Error: no response!
[    5.348461] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=9c, DAT0=04, DAT1=00
[    5.348506] bus: 'i2c': add driver max6650
[    5.349112] i2c-core: driver [max6650] registered
[    5.349136] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x1b
[    5.349167] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=36, DAT0=04, DAT1=00
[    5.356443] i2c-adapter i2c-0: Error: no response!
[    5.356473] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=36, DAT0=04, DAT1=00
[    5.356484] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x1f
[    5.356513] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=3e, DAT0=04, DAT1=00
[    5.360436] usb usb1: suspend_rh (auto-stop)
[    5.364434] i2c-adapter i2c-0: Error: no response!
[    5.364463] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=3e, DAT0=04, DAT1=00
[    5.364473] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x48
[    5.364502] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=90, DAT0=04, DAT1=00
[    5.372434] i2c-adapter i2c-0: Error: no response!
[    5.372463] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=90, DAT0=04, DAT1=00
[    5.372473] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4b
[    5.372502] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=96, DAT0=04, DAT1=00
[    5.380435] i2c-adapter i2c-0: Error: no response!
[    5.380464] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=96, DAT0=04, DAT1=00
[    5.380488] pc87360: PC8736x not detected, module not inserted.
[    5.380666] bus: 'pci': add driver sis5595
[    5.381377] bus: 'i2c': add driver thmc50
[    5.381923] i2c-core: driver [thmc50] registered
[    5.381948] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[    5.381980] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    5.388438] i2c-adapter i2c-0: Error: no response!
[    5.388470] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=58, DAT0=04, DAT1=00
[    5.388481] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[    5.388510] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    5.396437] i2c-adapter i2c-0: Error: no response!
[    5.396466] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5a, DAT0=04, DAT1=00
[    5.396476] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[    5.396505] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    5.404438] i2c-adapter i2c-0: Error: no response!
[    5.404466] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    5.404525] bus: 'pci': add driver via686a
[    5.405186] bus: 'pci': add driver vt8231
[    5.405833] bus: 'i2c': add driver w83l785ts
[    5.406401] i2c-core: driver [w83l785ts] registered
[    5.406425] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[    5.406457] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    5.412441] i2c-adapter i2c-0: Error: no response!
[    5.412472] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    5.412516] bus: 'i2c': add driver w83l786ng
[    5.413108] i2c-core: driver [w83l786ng] registered
[    5.413131] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[    5.413162] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    5.420443] i2c-adapter i2c-0: Error: no response!
[    5.420472] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5c, DAT0=04, DAT1=00
[    5.420483] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
[    5.420511] i2c-adapter i2c-0: Transaction (pre): CNT=00, CMD=11, ADD=5e, DAT0=04, DAT1=00
[    5.428441] i2c-adapter i2c-0: Error: no response!
[    5.428469] i2c-adapter i2c-0: Transaction (post): CNT=00, CMD=11, ADD=5e, DAT0=04, DAT1=00
[    5.428487] Linux telephony interface: v1.00
[    5.428620] md: linear personality registered for level -1
[    5.428727] md: raid1 personality registered for level 1
[    5.428835] md: raid10 personality registered for level 10
[    5.496522] raid6: int32x1    233 MB/s
[    5.564593] raid6: int32x2    224 MB/s
[    5.632609] raid6: int32x4    203 MB/s
[    5.700786] raid6: int32x8    188 MB/s
[    5.768531] raid6: mmxx1      664 MB/s
[    5.836480] raid6: mmxx2      838 MB/s
[    5.904578] raid6: sse1x1     560 MB/s
[    5.972549] raid6: sse1x2     841 MB/s
[    5.972649] raid6: using algorithm sse1x2 (841 MB/s)
[    5.972761] md: raid6 personality registered for level 6
[    5.972864] md: raid5 personality registered for level 5
[    5.972965] md: raid4 personality registered for level 4
[    5.973068] md: faulty personality registered for level -5
[    5.977739] device-mapper: uevent: version 1.0.3
[    5.979052] device: 'device-mapper': device_add
[    5.979460] PM: Adding info for No Bus:device-mapper
[    5.980037] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    5.983813] device-mapper: multipath: version 1.0.5 loaded
[    5.983943] device-mapper: multipath round-robin: version 1.0.0 loaded
[    5.987323] Bluetooth: Virtual HCI driver ver 1.2
[    5.987463] device: 'vhci': device_add
[    5.987839] PM: Adding info for No Bus:vhci
[    5.988482] Bluetooth: HCI UART driver ver 2.2
[    5.988643] Bluetooth: HCI H4 protocol initialized
[    5.988749] Bluetooth: HCI BCSP protocol initialized
[    5.988852] Bluetooth: Broadcom Blutonium firmware driver ver 1.2
[    5.988976] bus: 'usb': add driver bcm203x
[    5.989591] usbcore: registered new interface driver bcm203x
[    5.989727] bus: 'pcmcia': add driver bt3c_cs
[    5.990272] bus: 'pcmcia': add driver bluecard_cs
[    5.990798] bus: 'pcmcia': add driver btuart_cs
[    5.998514] ISDN subsystem Rev: 1.1.2.3/1.1.2.3/1.1.2.2/1.1.2.3/none/1.1.2.2
[    5.998902] PPP BSD Compression module registered
[    5.999095] dss1_divert module successfully installed
[    5.999207] HiSax: Linux Driver for passive ISDN cards
[    5.999309] HiSax: Version 3.5 (kernel)
[    5.999409] HiSax: Layer1 Revision 2.46.2.5
[    5.999507] HiSax: Layer2 Revision 2.30.2.4
[    5.999604] HiSax: TeiMgr Revision 2.20.2.3
[    5.999701] HiSax: Layer3 Revision 2.22.2.3
[    5.999800] HiSax: LinkLayer Revision 2.59.2.4
[    5.999989] HiSax: Total 1 card defined
[    6.000165] HiSax: Card 1 Protocol EDSS1 Id=HiSax (0)
[    6.000271] Gazel: Driver Revision 2.19.2.4
[    6.000370] Gazel: ISA PnP card automatic recognition
[    6.000559] Gazel: Card ISA R647/R648 found
[    6.000667] Gazel: config irq:15 isac:0x8180  cfg:0xC180
[    6.000769] Gazel: hscx A:0x180  hscx B:0x4180
[    6.000904] Gazel: io ports 0x2180-0x2190 already in use
[    6.001109] HiSax: Card Gazel not installed !
[    6.001230] bus: 'pcmcia': add driver avma1_cs
[    6.002165] bus: 'pcmcia': add driver teles_cs
[    6.002756] hisax_st5481: ST5481 USB ISDN driver $Revision: 2.4.2.3 $
[    6.002959] bus: 'usb': add driver st5481_usb
[    6.003604] usbcore: registered new interface driver st5481_usb
[    6.003805] lguest: mapped switcher at ffc00000
[    6.003945] device: 'lguest': device_add
[    6.004332] PM: Adding info for No Bus:lguest
[    6.005120] bus: 'i2c': add driver pca9532
[    6.005838] i2c-core: driver [pca9532] registered
[    6.005872] bus: 'platform': add driver leds-gpio
[    6.006449] Registering platform device 'dell_rbu'. Parent at platform
[    6.006460] device: 'dell_rbu': device_add
[    6.006497] bus: 'platform': add device dell_rbu
[    6.006554] PM: Adding info for platform:dell_rbu
[    6.007127] No iBFT detected.
[    6.007293] bus: 'pci': add driver ioatdma
[    6.008976] bus: 'hid': registered
[    6.009000] device class 'hidraw': registering
[    6.009875] bus: 'hid': add driver a4tech
[    6.010453] bus: 'hid': add driver apple
[    6.010988] bus: 'hid': add driver belkin
[    6.011516] bus: 'hid': add driver cherry
[    6.012029] bus: 'hid': add driver chicony
[    6.012608] bus: 'hid': add driver cypress
[    6.013166] bus: 'hid': add driver ezkey
[    6.013767] bus: 'hid': add driver gyration
[    6.014484] bus: 'hid': add driver logitech
[    6.015059] bus: 'hid': add driver microsoft
[    6.015595] bus: 'hid': add driver monterey
[    6.016136] bus: 'hid': add driver ntrig
[    6.017243] bus: 'hid': add driver pantherlord
[    6.017855] bus: 'hid': add driver petalynx
[    6.018401] bus: 'hid': add driver samsung
[    6.018929] bus: 'hid': add driver sony
[    6.019450] bus: 'hid': add driver sunplus
[    6.019965] bus: 'hid': add driver thrustmaster
[    6.020542] bus: 'hid': add driver topseed
[    6.021099] bus: 'hid': add driver generic-usb
[    6.021751] bus: 'usb': add driver hiddev
[    6.022319] usbcore: registered new interface driver hiddev
[    6.022466] bus: 'usb': add driver usbhid
[    6.023168] usbcore: registered new interface driver usbhid
[    6.023306] usbhid: v2.6:USB HID core driver
[    6.023424] bus: 'usb': add driver usbmouse
[    6.024013] usbcore: registered new interface driver usbmouse
[    6.024136] usbmouse: v1.6:USB HID Boot Protocol mouse driver
[    6.024255] device: 'virtio-pci': device_add
[    6.024302] PM: Adding info for No Bus:virtio-pci
[    6.024369] bus: 'pci': add driver virtio-pci
[    6.026027] bus: 'virtio': add driver virtio_balloon
[    6.026611] device class 'sound': registering
[    6.027367] Advanced Linux Sound Architecture Driver Version 1.0.18a.
[    6.027553] device: 'timer': device_add
[    6.027961] PM: Adding info for No Bus:timer
[    6.030397] bus: 'usb': add driver snd-usb-usx2y
[    6.031143] usbcore: registered new interface driver snd-usb-usx2y
[    6.031299] bus: 'usb': add driver snd-usb-us122l
[    6.031892] usbcore: registered new interface driver snd-usb-us122l
[    6.032030] bus: 'usb': add driver snd-usb-caiaq
[    6.032639] usbcore: registered new interface driver snd-usb-caiaq
[    6.032779] bus: 'pcmcia': add driver snd-vxpocket
[    6.033336] bus: 'pcmcia': add driver snd-pdaudiocf
[    6.033868] ALSA device list:
[    6.033972]   No soundcards found.
[    6.034069] oprofile: using timer interrupt.
[    6.035169] pktgen v2.70: Packet Generator for packet performance testing.
[    6.036240] NET: Registered protocol family 26
[    6.041135] IPv4 over IPv4 tunneling driver
[    6.041368] device: 'tunl0': device_add
[    6.041686] PM: Adding info for No Bus:tunl0
[    6.045256] GRE over IPv4 tunneling driver
[    6.045441] device: 'gre0': device_add
[    6.045740] PM: Adding info for No Bus:gre0
[    6.049889] TCP bic registered
[    6.050004] TCP westwood registered
[    6.050101] TCP hybla registered
[    6.050199] TCP veno registered
[    6.050296] TCP lp registered
[    6.050396] NET: Registered protocol family 17
[    6.050563] NET: Registered protocol family 15
[    6.050715] bus: 'platform': add driver dsa
[    6.052407] NET: Registered protocol family 4
[    6.055001] NET: Registered protocol family 9
[    6.055115] X.25 for Linux Version 0.2
[    6.055680] rose0 (): not using net_device_ops yet
[    6.055792] device: 'rose0': device_add
[    6.056107] PM: Adding info for No Bus:rose0
[    6.059873] rose1 (): not using net_device_ops yet
[    6.059996] device: 'rose1': device_add
[    6.060296] PM: Adding info for No Bus:rose1
[    6.064054] rose2 (): not using net_device_ops yet
[    6.064172] device: 'rose2': device_add
[    6.064471] PM: Adding info for No Bus:rose2
[    6.068326] rose3 (): not using net_device_ops yet
[    6.068449] device: 'rose3': device_add
[    6.068831] PM: Adding info for No Bus:rose3
[    6.072761] rose4 (): not using net_device_ops yet
[    6.072878] device: 'rose4': device_add
[    6.073186] PM: Adding info for No Bus:rose4
[    6.077322] rose5 (): not using net_device_ops yet
[    6.077442] device: 'rose5': device_add
[    6.077756] PM: Adding info for No Bus:rose5
[    6.081759] rose6 (): not using net_device_ops yet
[    6.081874] device: 'rose6': device_add
[    6.082180] PM: Adding info for No Bus:rose6
[    6.086482] rose7 (): not using net_device_ops yet
[    6.086603] device: 'rose7': device_add
[    6.086924] PM: Adding info for No Bus:rose7
[    6.091131] rose8 (): not using net_device_ops yet
[    6.091247] device: 'rose8': device_add
[    6.091613] PM: Adding info for No Bus:rose8
[    6.096048] rose9 (): not using net_device_ops yet
[    6.096169] device: 'rose9': device_add
[    6.096549] PM: Adding info for No Bus:rose9
[    6.100869] NET: Registered protocol family 11
[    6.101843] NET: Registered protocol family 3
[    6.102115] Bluetooth: L2CAP ver 2.11
[    6.102213] Bluetooth: L2CAP socket layer initialized
[    6.102323] Bluetooth: SCO (Voice Link) ver 0.6
[    6.102425] Bluetooth: SCO socket layer initialized
[    6.102776] Bluetooth: RFCOMM socket layer initialized
[    6.102971] Bluetooth: RFCOMM TTY layer initialized
[    6.103075] Bluetooth: RFCOMM ver 1.10
[    6.103173] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    6.103277] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    6.103393] bus: 'hid': add driver generic-bluetooth
[    6.104193] lec.c: Jan 10 2009 13:34:55 initialized
[    6.104304] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    6.109471] DECnet: Routing cache hash table of 1024 buckets, 32Kbytes
[    6.110735] NET: Registered protocol family 12
[    6.111920] NET: Registered protocol family 19
[    6.112113] NET: Registered protocol family 35
[    6.114539] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    6.114665] All bugs added by David S. Miller <davem@redhat.com>
[    6.126982] CCID: Activated CCID 2 (TCP-like)
[    6.129391] CCID: Activated CCID 3 (TCP-Friendly Rate Control)
[    6.136755] SCTP: Hash tables configured (established 4096 bind 4096)
[    6.140904] sctp_init_sock(sk: deb74000)
[    6.140998] TIPC: Activated (version 1.6.4 compiled Jan 10 2009 13:41:46)
[    6.145443] NET: Registered protocol family 30
[    6.145570] TIPC: Started in single node mode
[    6.145682] IO APIC resources could be not be allocated.
[    6.145821] Using IPI No-Shortcut mode
[    6.145965] device: 'cpu_dma_latency': device_add
[    6.146368] PM: Adding info for No Bus:cpu_dma_latency
[    6.147029] device: 'network_latency': device_add
[    6.147278] PM: Adding info for No Bus:network_latency
[    6.147929] device: 'network_throughput': device_add
[    6.148149] PM: Adding info for No Bus:network_throughput
[    6.149412]   Magic number: 9:883:836
[    6.149744] tty ptyu2: hash matches
[    6.149909] saa7134 ALSA driver for DMA sound loaded
[    6.150010] saa7134 ALSA: no saa7134 cards found
[    6.150132] rtc-test rtc-test.0: setting system clock to 2009-01-10 13:51:01 UTC (1231595461)
[    6.150295] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    6.150400] EDD information not available.
[    6.154149] Freeing unused kernel memory: 628k freed
[    6.154665] device: 'vcs1': device_add
[    6.155077] PM: Adding info for No Bus:vcs1
[    6.155967] device: 'vcsa1': device_add
[    6.156252] PM: Adding info for No Bus:vcsa1
[    6.816669] hub 1-0:1.0: hub_suspend
[    6.816722] usb usb1: bus auto-suspend
[    6.816732] usb usb1: suspend_rh
[   13.182179] kjournald starting.  Commit interval 5 seconds
[   13.182361] EXT3-fs: mounted filesystem with ordered data mode.
[   14.065135] device: 'vcs1': device_unregister
[   14.065155] PM: Removing info for No Bus:vcs1
[   14.065728] device: 'vcs1': device_create_release
[   14.065750] device: 'vcsa1': device_unregister
[   14.065756] PM: Removing info for No Bus:vcsa1
[   14.065977] device: 'vcsa1': device_create_release
[   14.066290] device: 'vcs1': device_add
[   14.066487] PM: Adding info for No Bus:vcs1
[   14.066615] device: 'vcsa1': device_add
[   14.066717] PM: Adding info for No Bus:vcsa1
[   16.310572] awk used greatest stack depth: 1456 bytes left
[   22.209247] usb usb1: uevent
[   22.209484] usb 1-0:1.0: uevent
[   35.579758] EXT3 FS on sda1, internal journal
[   37.635481] Adding 1050832k swap on /dev/sda2.  Priority:-1 extents:1 across:1050832k 
[   50.638920] warning: `dbus-daemon' uses deprecated v2 capabilities in a way that may be insecure.
[   51.936510] usb usb1: usb auto-resume
[   51.936538] usb usb1: wakeup_rh
[   51.974084] hub 1-0:1.0: hub_resume
[   51.974675] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   52.982253] usb usb1: suspend_rh (auto-stop)
[   53.284792] ip used greatest stack depth: 1452 bytes left
[   54.822448] hub 1-0:1.0: hub_suspend
[   54.822500] usb usb1: bus auto-suspend
[   54.822511] usb usb1: suspend_rh
[   61.697271] cupsd used greatest stack depth: 1140 bytes left
[   62.866975] eth0:  setting full-duplex.
[   62.869327] bpq0 (): not using net_device_ops yet
[   62.869356] device: 'bpq0': device_add
[   62.869706] PM: Adding info for No Bus:bpq0
[   68.611483] device: 'vcs6': device_add
[   68.611923] PM: Adding info for No Bus:vcs6
[   68.612225] device: 'vcsa6': device_add
[   68.612351] PM: Adding info for No Bus:vcsa6
[   68.616430] device: 'vcs5': device_add
[   68.616860] PM: Adding info for No Bus:vcs5
[   68.617029] device: 'vcsa5': device_add
[   68.617141] PM: Adding info for No Bus:vcsa5
[   68.639552] device: 'vcs2': device_add
[   68.639993] PM: Adding info for No Bus:vcs2
[   68.640246] device: 'vcsa2': device_add
[   68.640413] PM: Adding info for No Bus:vcsa2
[   68.653426] device: 'vcs3': device_add
[   68.653864] PM: Adding info for No Bus:vcs3
[   68.654029] device: 'vcsa3': device_add
[   68.654139] PM: Adding info for No Bus:vcsa3
[   68.655526] device: 'vcs3': device_unregister
[   68.655541] PM: Removing info for No Bus:vcs3
[   68.656135] device: 'vcs3': device_create_release
[   68.656163] device: 'vcsa3': device_unregister
[   68.656169] PM: Removing info for No Bus:vcsa3
[   68.656419] device: 'vcsa3': device_create_release
[   68.667758] device: 'vcs4': device_add
[   68.668349] PM: Adding info for No Bus:vcs4
[   68.668546] device: 'vcsa4': device_add
[   68.668678] PM: Adding info for No Bus:vcsa4
[   68.670974] device: 'vcs4': device_unregister
[   68.670988] PM: Removing info for No Bus:vcs4
[   68.671477] device: 'vcs4': device_create_release
[   68.671505] device: 'vcsa4': device_unregister
[   68.671511] PM: Removing info for No Bus:vcsa4
[   68.671753] device: 'vcsa4': device_create_release
[   68.672015] device: 'vcs4': device_add
[   68.672314] PM: Adding info for No Bus:vcs4
[   68.672439] device: 'vcsa4': device_add
[   68.672548] PM: Adding info for No Bus:vcsa4
[   68.700480] device: 'vcs6': device_unregister
[   68.700500] PM: Removing info for No Bus:vcs6
[   68.701073] device: 'vcs6': device_create_release
[   68.701099] device: 'vcsa6': device_unregister
[   68.701105] PM: Removing info for No Bus:vcsa6
[   68.701331] device: 'vcsa6': device_create_release
[   68.701627] device: 'vcs6': device_add
[   68.701836] PM: Adding info for No Bus:vcs6
[   68.701961] device: 'vcsa6': device_add
[   68.702073] PM: Adding info for No Bus:vcsa6
[   68.705938] device: 'vcs5': device_unregister
[   68.705956] PM: Removing info for No Bus:vcs5
[   68.706504] device: 'vcs5': device_create_release
[   68.706528] device: 'vcsa5': device_unregister
[   68.706534] PM: Removing info for No Bus:vcsa5
[   68.706767] device: 'vcsa5': device_create_release
[   68.707009] device: 'vcs5': device_add
[   68.707213] PM: Adding info for No Bus:vcs5
[   68.707336] device: 'vcsa5': device_add
[   68.707448] PM: Adding info for No Bus:vcsa5
[   68.712359] device: 'vcs2': device_unregister
[   68.712373] PM: Removing info for No Bus:vcs2
[   68.712925] device: 'vcs2': device_create_release
[   68.712948] device: 'vcsa2': device_unregister
[   68.712954] PM: Removing info for No Bus:vcsa2
[   68.713180] device: 'vcsa2': device_create_release
[   68.713443] device: 'vcs3': device_add
[   68.713653] PM: Adding info for No Bus:vcs3
[   68.713815] device: 'vcsa3': device_add
[   68.713937] PM: Adding info for No Bus:vcsa3
[   68.714186] device: 'vcs2': device_add
[   68.714326] PM: Adding info for No Bus:vcs2
[   68.714463] device: 'vcsa2': device_add
[   68.714577] PM: Adding info for No Bus:vcsa2
[   70.955151] device: 'vcs7': device_add
[   70.955592] PM: Adding info for No Bus:vcs7
[   70.955782] device: 'vcsa7': device_add
[   70.955934] PM: Adding info for No Bus:vcsa7
[   75.561985] evbug.c: Event. Dev: input2, Type: 20, Code: 0, Value: 500

--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.28
# Sat Jan 10 14:09:42 2009
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
CONFIG_X86_SMP=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
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
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set

#
# Control Group support
#
# CONFIG_CGROUPS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_STRIP_GENERATED=y
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
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_IBS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_BLK_DEV_BSG is not set
CONFIG_BLK_DEV_INTEGRITY=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_CLASSIC_RCU=y
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_RDC321X=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
CONFIG_VMI=y
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_LGUEST_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_MEMTEST=y
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
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
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
# CONFIG_HPET_TIMER is not set
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
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
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
CONFIG_CMDLINE_OVERRIDE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
# CONFIG_ACPI is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
CONFIG_APM_DO_ENABLE=y
CONFIG_APM_CPU_IDLE=y
# CONFIG_APM_DISPLAY_BLANK is not set
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_CPU_IDLE is not set

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
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_MCA=y
# CONFIG_MCA_LEGACY is not set
CONFIG_SCx200=y
# CONFIG_SCx200HR_TIMER is not set
CONFIG_OLPC=y
CONFIG_K8_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=y
# CONFIG_HOTPLUG_PCI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_NET_NS=y
CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE=y
# CONFIG_NET_IPGRE_BROADCAST is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_PIMSM_V1 is not set
# CONFIG_IP_PIMSM_V2 is not set
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
# CONFIG_TCP_CONG_CUBIC is not set
CONFIG_TCP_CONG_WESTWOOD=y
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
CONFIG_TCP_CONG_HYBLA=y
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_TIPC=y
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_ZONES=3
CONFIG_TIPC_CLUSTERS=1
CONFIG_TIPC_NODES=255
CONFIG_TIPC_SLAVE_NODES=0
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
CONFIG_TIPC_DEBUG=y
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=y
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_STP=y
CONFIG_GARP=y
# CONFIG_BRIDGE is not set
CONFIG_NET_DSA=y
# CONFIG_NET_DSA_TAG_DSA is not set
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
CONFIG_ECONET=y
CONFIG_ECONET_AUNUDP=y
# CONFIG_ECONET_NATIVE is not set
CONFIG_WAN_ROUTER=y
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
# CONFIG_NETROM is not set
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
CONFIG_6PACK=y
CONFIG_BPQETHER=y
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=y
CONFIG_BAYCOM_PAR=y
CONFIG_BAYCOM_EPP=y
# CONFIG_YAM is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_L2CAP=y
CONFIG_BT_SCO=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=y
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_LL is not set
CONFIG_BT_HCIBCM203X=y
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
CONFIG_BT_HCIBT3C=y
CONFIG_BT_HCIBLUECARD=y
CONFIG_BT_HCIBTUART=y
CONFIG_BT_HCIVHCI=y
# CONFIG_AF_RXRPC is not set
CONFIG_PHONET=y
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_WIRELESS_EXT=y
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
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
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_CPQ_DA=y
# CONFIG_BLK_CPQ_CISS_DA is not set
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_UB=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_SCSI_DH is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=y
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
CONFIG_SATA_PROMISE=y
CONFIG_SATA_SX4=y
CONFIG_SATA_SIL=y
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=y
CONFIG_SATA_VITESSE=y
CONFIG_SATA_INIC162X=y
CONFIG_PATA_ALI=y
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=y
CONFIG_PATA_ATIIXP=y
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_CMD64X=y
CONFIG_PATA_CS5520=y
# CONFIG_PATA_CS5530 is not set
CONFIG_PATA_CS5535=y
CONFIG_PATA_CS5536=y
CONFIG_PATA_CYPRESS=y
CONFIG_PATA_EFAR=y
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_HPT366 is not set
CONFIG_PATA_HPT37X=y
CONFIG_PATA_HPT3X2N=y
CONFIG_PATA_HPT3X3=y
CONFIG_PATA_HPT3X3_DMA=y
CONFIG_PATA_IT821X=y
CONFIG_PATA_IT8213=y
CONFIG_PATA_JMICRON=y
CONFIG_PATA_TRIFLEX=y
CONFIG_PATA_MARVELL=y
CONFIG_PATA_MPIIX=y
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_NETCELL=y
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OPTI=y
CONFIG_PATA_OPTIDMA=y
CONFIG_PATA_PCMCIA=y
CONFIG_PATA_PDC_OLD=y
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RZ1000=y
CONFIG_PATA_SC1200=y
CONFIG_PATA_SERVERWORKS=y
# CONFIG_PATA_PDC2027X is not set
CONFIG_PATA_SIL680=y
# CONFIG_PATA_SIS is not set
CONFIG_PATA_VIA=y
CONFIG_PATA_WINBOND=y
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
CONFIG_MD_LINEAR=y
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_RAID5_RESHAPE=y
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_ZERO is not set
CONFIG_DM_MULTIPATH=y
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
# CONFIG_FUSION_LAN is not set
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=y
# CONFIG_IEEE1394 is not set
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=y
# CONFIG_I2O_BLOCK is not set
# CONFIG_I2O_SCSI is not set
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_DUMMY=y
CONFIG_BONDING=y
CONFIG_MACVLAN=y
CONFIG_EQUALIZER=y
# CONFIG_TUN is not set
# CONFIG_VETH is not set
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
# CONFIG_ARCNET_1051 is not set
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
# CONFIG_ARCNET_COM90xx is not set
# CONFIG_ARCNET_COM90xxIO is not set
# CONFIG_ARCNET_RIM_I is not set
# CONFIG_ARCNET_COM20020 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
CONFIG_CASSINI=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_EL3=y
CONFIG_VORTEX=y
CONFIG_TYPHOON=y
CONFIG_NET_VENDOR_SMC=y
CONFIG_ULTRAMCA=y
CONFIG_ENC28J60=y
# CONFIG_ENC28J60_WRITEVERIFY is not set
CONFIG_NET_TULIP=y
CONFIG_DE2104X=y
CONFIG_TULIP=y
CONFIG_TULIP_MWI=y
CONFIG_TULIP_MMIO=y
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
CONFIG_DE4X5=y
# CONFIG_WINBOND_840 is not set
CONFIG_DM9102=y
CONFIG_ULI526X=y
CONFIG_PCMCIA_XIRCOM=y
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
CONFIG_IBMLANA=y
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
CONFIG_AMD8111_ETH=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
CONFIG_FORCEDETH_NAPI=y
CONFIG_E100=y
CONFIG_FEALNX=y
CONFIG_NATSEMI=y
CONFIG_NE2K_PCI=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R6040=y
CONFIG_SIS900=y
# CONFIG_EPIC100 is not set
CONFIG_SMSC9420=y
CONFIG_SUNDANCE=y
CONFIG_SUNDANCE_MMIO=y
CONFIG_TLAN=y
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
# CONFIG_SC92031 is not set
CONFIG_NET_POCKET=y
# CONFIG_ATP is not set
CONFIG_DE600=y
CONFIG_DE620=y
CONFIG_ATL2=y
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=y
# CONFIG_E1000E is not set
CONFIG_IP1000=y
CONFIG_IGB=y
CONFIG_IGB_LRO=y
# CONFIG_IGB_DCA is not set
CONFIG_NS83820=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_VIA_VELOCITY=y
CONFIG_TIGON3=y
# CONFIG_BNX2 is not set
CONFIG_QLA3XXX=y
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
CONFIG_JME=y
# CONFIG_NETDEV_10000 is not set
CONFIG_TR=y
CONFIG_IBMTR=y
# CONFIG_IBMOL is not set
# CONFIG_IBMLS is not set
CONFIG_3C359=y
# CONFIG_TMS380TR is not set

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
CONFIG_STRIP=y
CONFIG_PCMCIA_WAVELAN=y
CONFIG_PCMCIA_NETWAVE=y
# CONFIG_WLAN_80211 is not set
# CONFIG_IWLWIFI_LEDS is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
# CONFIG_USB_USBNET is not set
CONFIG_NET_PCMCIA=y
CONFIG_PCMCIA_3C589=y
# CONFIG_PCMCIA_3C574 is not set
CONFIG_PCMCIA_FMVJ18X=y
CONFIG_PCMCIA_PCNET=y
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_PCMCIA_SMC91C92 is not set
CONFIG_PCMCIA_XIRC2PS=y
CONFIG_PCMCIA_AXNET=y
# CONFIG_WAN is not set
# CONFIG_ATM_DRIVERS is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=y
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_PPP_DEFLATE=y
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_MPPE is not set
CONFIG_PPPOE=y
CONFIG_PPPOATM=y
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=y
CONFIG_ISDN=y
# CONFIG_MISDN is not set
CONFIG_ISDN_I4L=y
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
# CONFIG_IPPP_FILTER is not set
CONFIG_ISDN_PPP_BSDCOMP=y
# CONFIG_ISDN_AUDIO is not set
CONFIG_ISDN_X25=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=y

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=y

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
CONFIG_DE_AOC=y
CONFIG_HISAX_NO_SENDCOMPLETE=y
# CONFIG_HISAX_NO_LLC is not set
CONFIG_HISAX_NO_KEYPAD=y
CONFIG_HISAX_1TR6=y
# CONFIG_HISAX_NI1 is not set
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_3=y
CONFIG_HISAX_S0BOX=y
# CONFIG_HISAX_FRITZPCI is not set
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
CONFIG_HISAX_DIEHLDIVA=y
# CONFIG_HISAX_SEDLBAUER is not set
# CONFIG_HISAX_NICCY is not set
CONFIG_HISAX_GAZEL=y
CONFIG_HISAX_HFC_SX=y
CONFIG_HISAX_DEBUG=y

#
# HiSax PCMCIA card service modules
#
# CONFIG_HISAX_ELSA_CS is not set
CONFIG_HISAX_AVM_A1_CS=y
CONFIG_HISAX_TELES_CS=y

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=y
# CONFIG_HISAX_HFCUSB is not set
# CONFIG_HISAX_HFC4S8S is not set
CONFIG_HISAX_HDLC=y

#
# Active cards
#
# CONFIG_ISDN_DRV_GIGASET is not set
# CONFIG_ISDN_CAPI is not set
CONFIG_PHONE=y
# CONFIG_PHONE_IXJ is not set

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
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
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
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_GPIO=y
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_DA9034=y
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_WISTRON_BTNS=y
CONFIG_INPUT_ATI_REMOTE=y
# CONFIG_INPUT_ATI_REMOTE2 is not set
CONFIG_INPUT_KEYSPAN_REMOTE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
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
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_MCA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
CONFIG_SONYPI=y

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
CONFIG_IPWIRELESS=y
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
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
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=y
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=y
CONFIG_AT24=y
CONFIG_SENSORS_EEPROM=y
CONFIG_SENSORS_PCF8591=y
CONFIG_SENSORS_MAX6875=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_I2C_DEBUG_CORE=y
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
# CONFIG_I2C_DEBUG_CHIP is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_LM70_LLP=y

#
# SPI Protocol Masters
#
# CONFIG_SPI_AT25 is not set
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
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
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_TWL4030=y

#
# PCI GPIO expanders:
#

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=y
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_OLPC=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_DA9030=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7473 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHER=y
CONFIG_SENSORS_FSCPOS=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_HDAPS=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_HWMON_DEBUG_CHIP=y
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_SM501 is not set
CONFIG_HTC_PASIC3=y
# CONFIG_TPS65010 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_BQ24022=y
CONFIG_REGULATOR_WM8400=y
# CONFIG_REGULATOR_DA903X is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=y
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_CUSTOMIZE=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_DVB=y
CONFIG_VIDEO_BTCX=y
CONFIG_VIDEO_IR=y
CONFIG_VIDEO_TVEEPROM=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=y
CONFIG_VIDEO_TVAUDIO=y
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_TDA9875=y
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_M52790=y
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_KS0127=y
CONFIG_VIDEO_OV7670=y
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y
CONFIG_VIDEO_CX2341X=y
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_ADV7175=y
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_BT848=y
CONFIG_VIDEO_BT848_DVB=y
# CONFIG_VIDEO_SAA6588 is not set
CONFIG_VIDEO_BWQCAM=y
CONFIG_VIDEO_CQCAM=y
# CONFIG_VIDEO_W9966 is not set
CONFIG_VIDEO_CPIA=y
# CONFIG_VIDEO_CPIA_PP is not set
CONFIG_VIDEO_CPIA_USB=y
CONFIG_VIDEO_CPIA2=y
CONFIG_VIDEO_SAA5246A=y
CONFIG_VIDEO_SAA5249=y
CONFIG_VIDEO_STRADIS=y
CONFIG_VIDEO_ZORAN=y
# CONFIG_VIDEO_ZORAN_DC30 is not set
CONFIG_VIDEO_ZORAN_ZR36060=y
# CONFIG_VIDEO_ZORAN_BUZ is not set
CONFIG_VIDEO_ZORAN_DC10=y
# CONFIG_VIDEO_ZORAN_LML33 is not set
# CONFIG_VIDEO_ZORAN_LML33R10 is not set
CONFIG_VIDEO_ZORAN_AVS6EYES=y
CONFIG_VIDEO_SAA7134=y
CONFIG_VIDEO_SAA7134_ALSA=y
# CONFIG_VIDEO_SAA7134_DVB is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
CONFIG_VIDEO_HEXIUM_GEMINI=y
# CONFIG_VIDEO_CX88 is not set
CONFIG_VIDEO_CX23885=y
CONFIG_VIDEO_AU0828=y
CONFIG_VIDEO_IVTV=y
CONFIG_VIDEO_FB_IVTV=y
CONFIG_VIDEO_CX18=y
CONFIG_VIDEO_CAFE_CCIC=y
CONFIG_SOC_CAMERA=y
CONFIG_SOC_CAMERA_MT9M001=y
CONFIG_MT9M001_PCA9536_SWITCH=y
CONFIG_SOC_CAMERA_MT9M111=y
CONFIG_SOC_CAMERA_MT9T031=y
# CONFIG_SOC_CAMERA_MT9V022 is not set
CONFIG_SOC_CAMERA_TW9910=y
CONFIG_SOC_CAMERA_PLATFORM=y
CONFIG_SOC_CAMERA_OV772X=y
# CONFIG_V4L_USB_DRIVERS is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_GEMTEK_PCI is not set
CONFIG_RADIO_MAXIRADIO=y
# CONFIG_RADIO_MAESTRO is not set
CONFIG_USB_DSBR=y
CONFIG_USB_SI470X=y
CONFIG_USB_MR800=y
CONFIG_RADIO_TEA5764=y
# CONFIG_RADIO_TEA5764_XTAL is not set
CONFIG_DVB_DYNAMIC_MINORS=y
# CONFIG_DVB_CAPTURE_DRIVERS is not set
CONFIG_DVB_BT8XX=y
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB7000P=y
CONFIG_DVB_TDA10048=y
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=y
CONFIG_DVB_S5H1411=y
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
# CONFIG_AGP_ATI is not set
CONFIG_AGP_AMD=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=y
CONFIG_DRM_TDFX=y
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
# CONFIG_FB_HGA_ACCEL is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I810=y
CONFIG_FB_I810_GTF=y
CONFIG_FB_I810_I2C=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_INTEL=y
CONFIG_FB_INTEL_DEBUG=y
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_MATROX_MULTIHEAD=y
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=y
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
# CONFIG_FB_SIS_315 is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_LTV350QV=y
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PROGEAR=y
CONFIG_BACKLIGHT_CARILLO_RANCH=y
# CONFIG_BACKLIGHT_DA903X is not set
CONFIG_BACKLIGHT_MBP_NVIDIA=y
CONFIG_BACKLIGHT_SAHARA=y

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
# CONFIG_FRAMEBUFFER_CONSOLE is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=y
# CONFIG_SND_PCM_OSS_PLUGINS is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VX_LIB=y
# CONFIG_SND_DRIVERS is not set
# CONFIG_SND_PCI is not set
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
CONFIG_SND_USB_USX2Y=y
CONFIG_SND_USB_CAIAQ=y
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=y
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=y
CONFIG_SND_PDAUDIOCF=y
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_OSS is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_COMPAT=y
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_EZKEY=y
CONFIG_HID_GYRATION=y
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_TOPSEED=y
CONFIG_THRUSTMASTER_FF=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=y
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_BERRY_CHARGE=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
# CONFIG_USB_PHIDGET is not set
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_VST=y
# CONFIG_USB_ATM is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_TWL4030_USB=y
CONFIG_UWB=y
CONFIG_UWB_HWA=y
# CONFIG_UWB_WHCI is not set
# CONFIG_UWB_WLP is not set
# CONFIG_UWB_I1480U is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_NET48XX=y
# CONFIG_LEDS_WRAP is not set
# CONFIG_LEDS_ALIX2 is not set
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_DA903X is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_TWL4030=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T94 is not set
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
# CONFIG_RTC_DRV_DS3234 is not set

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_V3020=y

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
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4DEV_COMPAT=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_GENERIC_ACL=y

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
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
CONFIG_ROMFS_FS=y
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_HW_BRANCH_TRACER=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y

#
# Tracers
#
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_BOOT_TRACER=y
# CONFIG_TRACE_BRANCH_PROFILING is not set
CONFIG_POWER_TRACER=y
CONFIG_STACK_TRACER=y
CONFIG_HW_BRANCH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
CONFIG_DYNAMIC_PRINTK_DEBUG=y
CONFIG_SAMPLES=y
CONFIG_SAMPLE_KOBJECT=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
# CONFIG_KGDB_TESTS is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_4KSTACKS=y
CONFIG_DOUBLEFAULT=y
CONFIG_MMIOTRACE=y
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
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
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
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_LGUEST=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y

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
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
# CONFIG_CPUMASK_OFFSTACK is not set

--1yeeQ81UyVL57Vl7--
