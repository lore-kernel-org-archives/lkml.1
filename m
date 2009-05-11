Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbZEKLD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbZEKLD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 07:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbZEKLDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 07:03:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45892 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbZEKLDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 07:03:13 -0400
Date: Mon, 11 May 2009 13:02:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, gorcunov@openvz.org, tglx@linutronix.de,
       eswierk@aristanetworks.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86: read apic ID in the !acpi_lapic case
Message-ID: <20090511110234.GH4648@elte.hu>
References: <49FC85A9.2070702@kernel.org> <tip-4401da6111ac58f94234417427d06a72c4048c74@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-4401da6111ac58f94234417427d06a72c4048c74@git.kernel.org>
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


* tip-bot for Yinghai Lu <yinghai@kernel.org> wrote:

> Commit-ID:  4401da6111ac58f94234417427d06a72c4048c74
> Gitweb:     http://git.kernel.org/tip/4401da6111ac58f94234417427d06a72c4048c74
> Author:     Yinghai Lu <yinghai@kernel.org>
> AuthorDate: Sat, 2 May 2009 10:40:57 -0700
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 11 May 2009 11:29:23 +0200
> 
> x86: read apic ID in the !acpi_lapic case
> 
> Ed found that on 32-bit, boot_cpu_physical_apicid is not read right,
> when the mptable is broken.

-tip testing found that this patch causes a kernel crash:

[    1.208000] initcall pci_iommu_init+0x0/0x11 returned 0 after 0 usecs
[    1.212000] calling  print_all_ICs+0x0/0x62a @ 1
[    1.216000] 
[    1.216000] printing PIC contents
[    1.220000] ... PIC  IMR: fffa
[    1.220000] ... PIC  IRR: 0000
[    1.224000] ... PIC  ISR: 0000
[    1.228000] ... PIC ELCR: 0828
[    1.232000] BUG: unable to handle kernel paging request at ffffb020
[    1.232000] IP: [<78417d5c>] native_apic_mem_read+0x15/0x19
[    1.232000] *pde = 010ef067 *pte = 00000000 
[    1.232000] Oops: 0000 [#1] PREEMPT 
[    1.232000] last sysfs file: 
[    1.232000] Modules linked in:
[    1.232000] 
[    1.232000] Pid: 1, comm: swapper Not tainted (2.6.30-rc5-tip #40847) System Product Name
[    1.232000] EIP: 0060:[<78417d5c>] EFLAGS: 00010046 CPU: 0
[    1.232000] EIP is at native_apic_mem_read+0x15/0x19
[    1.232000] EAX: ffffb020 EBX: 00000000 ECX: 00000000 EDX: fffff000
[    1.232000] ESI: 00000000 EDI: 7908c52e EBP: 9786fd38 ESP: 9786fd38
[    1.232000]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    1.232000] Process swapper (pid: 1, ti=9786e000 task=97870000 task.ti=9786e000)
[    1.232000] Stack:
[    1.232000]  9786fd40 78416e0d 9786fd48 78416fad 9786fd64 7908c55f 00000001 00000000
[    1.232000]  00000000 00000000 7908c52e 9786fd78 784671bf 00000001 00000000 00000000
[    1.232000]  9786fdac 7908ca42 00000001 9786fda0 784551ad 00000001 00000000 487ab0fc
[    1.232000] Call Trace:
[    1.232000]  [<78416e0d>] ? read_apic_id+0x19/0x24
[    1.232000]  [<78416fad>] ? hard_smp_processor_id+0xd/0xf
[    1.232000]  [<7908c55f>] ? print_local_APIC+0x31/0x3c7
[    1.232000]  [<7908c52e>] ? print_local_APIC+0x0/0x3c7
[    1.232000]  [<784671bf>] ? smp_call_function_single+0x5b/0x64
[    1.232000]  [<7908ca42>] ? print_all_ICs+0x14d/0x62a
[    1.232000]  [<784551ad>] ? ktime_get+0x16/0x34
[    1.232000]  [<7908c8f5>] ? print_all_ICs+0x0/0x62a
[    1.232000]  [<7908c8f5>] ? print_all_ICs+0x0/0x62a
[    1.232000]  [<7840107f>] ? _stext+0x7f/0x1f2
[    1.232000]  [<786c2658>] ? put_dec+0x44/0x137
[    1.232000]  [<784afae4>] ? page_count+0x22/0x3f
[    1.232000]  [<784b1c0a>] ? get_page_from_freelist+0x51f/0x6b0
[    1.232000]  [<786c2658>] ? put_dec+0x44/0x137
[    1.232000]  [<784dcbee>] ? check_object+0x207/0x252
[    1.232000]  [<786bb54f>] ? ida_get_new_above+0x2b0/0x2ca
[    1.232000]  [<784dd5c5>] ? __slab_free+0x11a/0x4af
[    1.232000]  [<784df012>] ? kmem_cache_free+0xce/0x163
[    1.232000]  [<786bb54f>] ? ida_get_new_above+0x2b0/0x2ca
[    1.232000]  [<786bb54f>] ? ida_get_new_above+0x2b0/0x2ca
[    1.232000]  [<786bb75f>] ? ida_pre_get+0x13/0x18b
[    1.232000]  [<7853f384>] ? proc_register+0x32a/0x34e
[    1.232000]  [<7853f5bd>] ? create_proc_entry+0xf0/0x119
[    1.232000]  [<7847e0bc>] ? register_irq_proc+0x87/0xbb
[    1.232000]  [<7908251b>] ? kernel_init+0x8d/0x10a
[    1.232000]  [<7908248e>] ? kernel_init+0x0/0x10a
[    1.232000]  [<78403ee7>] ? kernel_thread_helper+0x7/0x10
[    1.232000] Code: 44 00 00 89 d1 8b 15 08 8b de 78 8d 84 10 00 c0 ff ff 89 08 5d c3 55 89 e5 0f 1f 44 00 00 8b 15 08 8b de 78 8d 84 10 00 c0 ff ff <8b> 00 5d c3 55 89 e5 0f 1f 44 00 00 89 c2 eb 02 f3 90 8b 02 85 
[    1.232000] EIP: [<78417d5c>] native_apic_mem_read+0x15/0x19 SS:ESP 0068:9786fd38
[    1.232000] CR2: 00000000ffffb020
[    1.232000] ---[ end trace a7919e7f17c0a725 ]---
[    1.232000] Kernel panic - not syncing: Fatal exception

	Ingo

[    0.000000] Linux version 2.6.30-rc5-tip (mingo@sirius) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #40847 PREEMPT Mon May 11 12:34:41 CEST 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] CPU: vendor_id 'AuthenticAMD' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
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
[    0.000000] MPS support code is not built-in.
[    0.000000] Using acpi=off or acpi=noirq or pci=noacpi may have problem
[    0.000000] DMI 2.3 present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x100000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  modified: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  modified: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 01800000
[    0.000000] init_memory_mapping: 0000000000000000-000000001fff0000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 001fc00000 page 2M
[    0.000000]  001fc00000 - 001fff0000 page 4k
[    0.000000] kernel direct mapping tables up to 1fff0000 @ 10000-15000
[    0.000000] 512MB HIGHMEM available.
[    0.000000] 511MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1fff0000
[    0.000000]   low ram: 0 - 1fff0000
[    0.000000]   node 0 low ram: 00000000 - 1fff0000
[    0.000000]   node 0 bootmap 00011000 - 00015000
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 001fff0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000400000 - 000122fcd8]    TEXT DATA BSS ==> [0000400000 - 000122fcd8]
[    0.000000]   #2 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #3 [0001230000 - 0001236149]              BRK ==> [0001230000 - 0001236149]
[    0.000000]   #4 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
[    0.000000]   #5 [0000011000 - 0000015000]          BOOTMAP ==> [0000011000 - 0000015000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001fff0
[    0.000000]   HighMem  0x0001fff0 -> 0x0003fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fff0
[    0.000000] On node 0 totalpages: 262015
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 992 pages used for memmap
[    0.000000]   Normal zone: 125968 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1024 pages used for memmap
[    0.000000]   HighMem zone: 130048 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] APIC: disable apic facility
[    0.000000] nr_irqs_gsi: 16
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259967
[    0.000000] Kernel command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200,keep console=tty debug initcall_debug enforcing=0 apic=verbose ignore_loglevel sysrq_always_enabled selinux=0 nmi_watchdog=0 3 panic=1 maxcpus=1 nosmp noapic idle=mwait highmem=512m notsc acpi=off
[    0.000000] debug: sysrq always enabled.
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] NR_IRQS:2304 nr_irqs:256
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Initializing HighMem for node 0 (0001fff0:0003fff0)
[    0.000000] Memory: 1024056k/1048512k available (7392k kernel code, 23240k reserved, 5404k data, 424k init, 524288k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffab000 - 0xfffff000   ( 336 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x987f0000 - 0xff7fe000   (1648 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x97ff0000   ( 511 MB)
[    0.000000]       .init : 0x79082000 - 0x790ec000   ( 424 kB)
[    0.000000]       .data : 0x78b3826a - 0x7907f518   (5404 kB)
[    0.000000]       .text : 0x78400000 - 0x78b3826a   (7392 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.004000] Calibrating delay loop... 2007.04 BogoMIPS (lpj=4014080)
[    0.092000] Security Framework initialized
[    0.096000] SELinux:  Initializing.
[    0.100000] SELinux:  Starting in permissive mode
[    0.104000] Mount-cache hash table entries: 512
[    0.108000] Initializing cgroup subsys debug
[    0.112000] Initializing cgroup subsys ns
[    0.112000] Initializing cgroup subsys cpuacct
[    0.116000] Initializing cgroup subsys freezer
[    0.120000] CPU: AuthenticAMD AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.128000] Checking 'hlt' instruction... OK.
[    0.148000] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.152000] ftrace: allocating 24037 entries in 48 pages
[    0.164000] Failed to register trace ftrace module notifier
[    0.168000] calling  spawn_ksoftirqd+0x0/0x5a @ 1
[    0.172000] initcall spawn_ksoftirqd+0x0/0x5a returned 0 after 0 usecs
[    0.176000] calling  relay_init+0x0/0x7 @ 1
[    0.180000] initcall relay_init+0x0/0x7 returned 0 after 0 usecs
[    0.184000] calling  tracer_alloc_buffers+0x0/0x144 @ 1
[    0.188000] initcall tracer_alloc_buffers+0x0/0x144 returned 0 after 0 usecs
[    0.192000] calling  init_trace_printk+0x0/0xf @ 1
[    0.196000] initcall init_trace_printk+0x0/0xf returned 0 after 0 usecs
[    0.200000] calling  trace_workqueue_early_init+0x0/0x106 @ 1
[    0.204000] initcall trace_workqueue_early_init+0x0/0x106 returned 0 after 0 usecs
[    0.208000] Apic disabled
[    0.212000] calling  net_ns_init+0x0/0x188 @ 1
[    0.216000] net_namespace: 1000 bytes
[    0.220000] initcall net_ns_init+0x0/0x188 returned 0 after 3906 usecs
[    0.224000] calling  reboot_init+0x0/0x11 @ 1
[    0.228000] initcall reboot_init+0x0/0x11 returned 0 after 0 usecs
[    0.232000] calling  init_lapic_sysfs+0x0/0x5d @ 1
[    0.236000] initcall init_lapic_sysfs+0x0/0x5d returned 0 after 0 usecs
[    0.240000] calling  sysctl_init+0x0/0x28 @ 1
[    0.244000] initcall sysctl_init+0x0/0x28 returned 0 after 0 usecs
[    0.248000] calling  ksysfs_init+0x0/0x12c @ 1
[    0.252000] initcall ksysfs_init+0x0/0x12c returned 0 after 0 usecs
[    0.256000] calling  async_init+0x0/0xa7 @ 1
[    0.260000] initcall async_init+0x0/0xa7 returned 0 after 0 usecs
[    0.264000] calling  init_jiffies_clocksource+0x0/0xf @ 1
[    0.268000] initcall init_jiffies_clocksource+0x0/0xf returned 0 after 0 usecs
[    0.272000] calling  pm_init+0x0/0x43 @ 1
[    0.276000] initcall pm_init+0x0/0x43 returned 0 after 0 usecs
[    0.280000] calling  filelock_init+0x0/0x27 @ 1
[    0.284000] initcall filelock_init+0x0/0x27 returned 0 after 0 usecs
[    0.288000] calling  init_script_binfmt+0x0/0x11 @ 1
[    0.292000] initcall init_script_binfmt+0x0/0x11 returned 0 after 0 usecs
[    0.296000] calling  init_elf_binfmt+0x0/0x11 @ 1
[    0.300000] initcall init_elf_binfmt+0x0/0x11 returned 0 after 0 usecs
[    0.304000] calling  debugfs_init+0x0/0x76 @ 1
[    0.308000] initcall debugfs_init+0x0/0x76 returned 0 after 0 usecs
[    0.312000] calling  securityfs_init+0x0/0x6d @ 1
[    0.316000] initcall securityfs_init+0x0/0x6d returned 0 after 0 usecs
[    0.320000] calling  random32_init+0x0/0x7f @ 1
[    0.324000] initcall random32_init+0x0/0x7f returned 0 after 0 usecs
[    0.328000] calling  cpuidle_init+0x0/0x35 @ 1
[    0.332000] initcall cpuidle_init+0x0/0x35 returned 0 after 0 usecs
[    0.336000] calling  virtio_init+0x0/0x3a @ 1
[    0.340000] initcall virtio_init+0x0/0x3a returned 0 after 0 usecs
[    0.344000] calling  sock_init+0x0/0x69 @ 1
[    0.348000] initcall sock_init+0x0/0x69 returned 0 after 0 usecs
[    0.352000] calling  netpoll_init+0x0/0x25 @ 1
[    0.356000] initcall netpoll_init+0x0/0x25 returned 0 after 0 usecs
[    0.360000] calling  netlink_proto_init+0x0/0x16b @ 1
[    0.364000] NET: Registered protocol family 16
[    0.368000] initcall netlink_proto_init+0x0/0x16b returned 0 after 3906 usecs
[    0.372000] calling  olpc_init+0x0/0x154 @ 1
[    0.376000] initcall olpc_init+0x0/0x154 returned 0 after 0 usecs
[    0.380000] calling  bdi_class_init+0x0/0x35 @ 1
[    0.384000] initcall bdi_class_init+0x0/0x35 returned 0 after 0 usecs
[    0.388000] calling  kobject_uevent_init+0x0/0x64 @ 1
[    0.392000] initcall kobject_uevent_init+0x0/0x64 returned 0 after 0 usecs
[    0.396000] calling  pcibus_class_init+0x0/0x14 @ 1
[    0.400000] initcall pcibus_class_init+0x0/0x14 returned 0 after 0 usecs
[    0.404000] calling  pci_driver_init+0x0/0xf @ 1
[    0.408000] initcall pci_driver_init+0x0/0xf returned 0 after 0 usecs
[    0.412000] calling  backlight_class_init+0x0/0x7f @ 1
[    0.416000] initcall backlight_class_init+0x0/0x7f returned 0 after 0 usecs
[    0.420000] calling  tty_class_init+0x0/0x4f @ 1
[    0.424000] initcall tty_class_init+0x0/0x4f returned 0 after 0 usecs
[    0.428000] calling  vtconsole_class_init+0x0/0x10f @ 1
[    0.432000] initcall vtconsole_class_init+0x0/0x10f returned 0 after 0 usecs
[    0.436000] calling  amd_postcore_init+0x0/0x5d @ 1
[    0.440000] initcall amd_postcore_init+0x0/0x5d returned 0 after 0 usecs
[    0.444000] calling  arch_kdebugfs_init+0x0/0x32 @ 1
[    0.448000] initcall arch_kdebugfs_init+0x0/0x32 returned 0 after 0 usecs
[    0.452000] calling  init_pit_clocksource+0x0/0xb1 @ 1
[    0.456000] initcall init_pit_clocksource+0x0/0xb1 returned 0 after 0 usecs
[    0.460000] calling  ffh_cstate_init+0x0/0x10b @ 1
[    0.464000] initcall ffh_cstate_init+0x0/0x10b returned -1 after 0 usecs
[    0.468000] initcall ffh_cstate_init+0x0/0x10b returned with error code -1 
[    0.472000] calling  kdump_buf_page_init+0x0/0x109 @ 1
[    0.476000] initcall kdump_buf_page_init+0x0/0x109 returned 0 after 0 usecs
[    0.480000] calling  acpi_pci_init+0x0/0x90 @ 1
[    0.484000] initcall acpi_pci_init+0x0/0x90 returned 0 after 0 usecs
[    0.488000] calling  dmi_id_init+0x0/0x47d @ 1
[    0.492000] initcall dmi_id_init+0x0/0x47d returned 0 after 0 usecs
[    0.496000] calling  pci_arch_init+0x0/0x99 @ 1
[    0.504000] PCI: PCI BIOS revision 3.00 entry at 0xf21d0, last bus=5
[    0.508000] PCI: Using configuration type 1 for base access
[    0.512000] initcall pci_arch_init+0x0/0x99 returned 0 after 11718 usecs
[    0.516000] calling  topology_init+0x0/0x13 @ 1
[    0.520000] initcall topology_init+0x0/0x13 returned 0 after 0 usecs
[    0.528000] calling  mca_init+0x0/0x42f @ 1
[    0.532000] initcall mca_init+0x0/0x42f returned -19 after 0 usecs
[    0.536000] calling  param_sysfs_init+0x0/0x339 @ 1
[    0.572000] initcall param_sysfs_init+0x0/0x339 returned 0 after 31250 usecs
[    0.576000] calling  pm_sysrq_init+0x0/0x1b @ 1
[    0.580000] initcall pm_sysrq_init+0x0/0x1b returned 0 after 0 usecs
[    0.584000] calling  init_slow_work+0x0/0x59 @ 1
[    0.588000] initcall init_slow_work+0x0/0x59 returned 0 after 0 usecs
[    0.592000] calling  default_bdi_init+0x0/0x45 @ 1
[    0.596000] initcall default_bdi_init+0x0/0x45 returned 0 after 0 usecs
[    0.600000] calling  init_bio+0x0/0x111 @ 1
[    0.604000] bio: create slab <bio-0> at 0
[    0.608000] initcall init_bio+0x0/0x111 returned 0 after 3906 usecs
[    0.612000] calling  cryptomgr_init+0x0/0x59 @ 1
[    0.616000] initcall cryptomgr_init+0x0/0x59 returned 0 after 0 usecs
[    0.620000] calling  blk_settings_init+0x0/0x1d @ 1
[    0.624000] initcall blk_settings_init+0x0/0x1d returned 0 after 0 usecs
[    0.628000] calling  blk_ioc_init+0x0/0x24 @ 1
[    0.632000] initcall blk_ioc_init+0x0/0x24 returned 0 after 0 usecs
[    0.636000] calling  blk_softirq_init+0x0/0x2a @ 1
[    0.640000] initcall blk_softirq_init+0x0/0x2a returned 0 after 0 usecs
[    0.644000] calling  genhd_device_init+0x0/0x78 @ 1
[    0.648000] initcall genhd_device_init+0x0/0x78 returned 0 after 0 usecs
[    0.652000] calling  pci_slot_init+0x0/0x54 @ 1
[    0.656000] initcall pci_slot_init+0x0/0x54 returned 0 after 0 usecs
[    0.660000] calling  acpi_init+0x0/0x343 @ 1
[    0.664000] ACPI: Interpreter disabled.
[    0.668000] initcall acpi_init+0x0/0x343 returned -19 after 3906 usecs
[    0.672000] calling  dock_init+0x0/0xad @ 1
[    0.676000] initcall dock_init+0x0/0xad returned 0 after 0 usecs
[    0.680000] calling  acpi_pci_root_init+0x0/0x4d @ 1
[    0.684000] initcall acpi_pci_root_init+0x0/0x4d returned 0 after 0 usecs
[    0.688000] calling  acpi_pci_link_init+0x0/0x8d @ 1
[    0.692000] initcall acpi_pci_link_init+0x0/0x8d returned 0 after 0 usecs
[    0.696000] calling  pnp_init+0x0/0xf @ 1
[    0.700000] initcall pnp_init+0x0/0xf returned 0 after 0 usecs
[    0.704000] calling  misc_init+0x0/0xc1 @ 1
[    0.708000] initcall misc_init+0x0/0xc1 returned 0 after 0 usecs
[    0.712000] calling  cn_init+0x0/0x116 @ 1
[    0.716000] initcall cn_init+0x0/0x116 returned 0 after 0 usecs
[    0.720000] calling  init_scsi+0x0/0x11b @ 1
[    0.728000] SCSI subsystem initialized
[    0.732000] initcall init_scsi+0x0/0x11b returned 0 after 7812 usecs
[    0.736000] calling  ata_init+0x0/0x42a @ 1
[    0.740000] libata version 3.00 loaded.
[    0.744000] initcall ata_init+0x0/0x42a returned 0 after 3906 usecs
[    0.748000] calling  phy_init+0x0/0x55 @ 1
[    0.752000] initcall phy_init+0x0/0x55 returned 0 after 0 usecs
[    0.756000] calling  nop_usb_xceiv_init+0x0/0xf @ 1
[    0.764000] initcall nop_usb_xceiv_init+0x0/0xf returned 0 after 3906 usecs
[    0.768000] calling  usb_init+0x0/0x216 @ 1
[    0.772000] usbcore: registered new interface driver usbfs
[    0.776000] usbcore: registered new interface driver hub
[    0.780000] usbcore: registered new device driver usb
[    0.784000] initcall usb_init+0x0/0x216 returned 0 after 11718 usecs
[    0.788000] calling  serio_init+0x0/0xd6 @ 1
[    0.792000] initcall serio_init+0x0/0xd6 returned 0 after 0 usecs
[    0.796000] calling  input_init+0x0/0x197 @ 1
[    0.800000] initcall input_init+0x0/0x197 returned 0 after 0 usecs
[    0.804000] calling  rtc_init+0x0/0x7c @ 1
[    0.808000] initcall rtc_init+0x0/0x7c returned 0 after 0 usecs
[    0.812000] calling  init_dvbdev+0x0/0x10b @ 1
[    0.816000] initcall init_dvbdev+0x0/0x10b returned 0 after 0 usecs
[    0.820000] calling  power_supply_class_init+0x0/0x56 @ 1
[    0.824000] initcall power_supply_class_init+0x0/0x56 returned 0 after 0 usecs
[    0.828000] calling  hwmon_init+0x0/0x5c @ 1
[    0.832000] initcall hwmon_init+0x0/0x5c returned 0 after 0 usecs
[    0.836000] calling  thermal_init+0x0/0x48 @ 1
[    0.840000] initcall thermal_init+0x0/0x48 returned 0 after 0 usecs
[    0.844000] calling  leds_init+0x0/0x5d @ 1
[    0.848000] initcall leds_init+0x0/0x5d returned 0 after 0 usecs
[    0.852000] calling  acpi_wmi_init+0x0/0x79 @ 1
[    0.856000] initcall acpi_wmi_init+0x0/0x79 returned -19 after 0 usecs
[    0.860000] calling  pci_subsys_init+0x0/0x177 @ 1
[    0.864000] PCI: Probing PCI hardware
[    0.868000] PCI: Probing PCI hardware (bus 00)
[    0.876000] HPET not enabled in BIOS. You might try hpet=force boot option
[    0.880000] pci 0000:00:01.1: reg 10 io port: [0xdc00-0xdc1f]
[    0.884000] pci 0000:00:01.1: reg 20 io port: [0x4c00-0x4c3f]
[    0.888000] pci 0000:00:01.1: reg 24 io port: [0x4c40-0x4c7f]
[    0.892000] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.896000] pci 0000:00:01.1: PME# disabled
[    0.900000] pci 0000:00:02.0: reg 10 32bit mmio: [0xda102000-0xda102fff]
[    0.904000] pci 0000:00:02.0: supports D1 D2
[    0.908000] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.912000] pci 0000:00:02.0: PME# disabled
[    0.916000] pci 0000:00:02.1: reg 10 32bit mmio: [0xfeb00000-0xfeb000ff]
[    0.920000] pci 0000:00:02.1: supports D1 D2
[    0.924000] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.928000] pci 0000:00:02.1: PME# disabled
[    0.932000] pci 0000:00:04.0: reg 10 io port: [0xd400-0xd4ff]
[    0.936000] pci 0000:00:04.0: reg 14 io port: [0xd800-0xd8ff]
[    0.940000] pci 0000:00:04.0: reg 18 32bit mmio: [0xda101000-0xda101fff]
[    0.944000] pci 0000:00:04.0: supports D1 D2
[    0.948000] pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
[    0.952000] pci 0000:00:0a.0: reg 10 32bit mmio: [0xda100000-0xda100fff]
[    0.956000] pci 0000:00:0a.0: reg 14 io port: [0xd000-0xd007]
[    0.960000] pci 0000:00:0a.0: supports D1 D2
[    0.964000] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.968000] pci 0000:00:0a.0: PME# disabled
[    0.972000] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.976000] pci 0000:00:0b.0: PME# disabled
[    0.980000] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.984000] pci 0000:00:0c.0: PME# disabled
[    0.988000] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.992000] pci 0000:00:0d.0: PME# disabled
[    0.996000] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.000000] pci 0000:00:0e.0: PME# disabled
[    1.008000] pci 0000:05:07.0: reg 10 io port: [0xc000-0xc0ff]
[    1.012000] pci 0000:05:07.0: reg 14 32bit mmio: [0xda000000-0xda0000ff]
[    1.016000] pci 0000:05:07.0: supports D1 D2
[    1.020000] pci 0000:05:07.0: PME# supported from D1 D2 D3hot
[    1.024000] pci 0000:05:07.0: PME# disabled
[    1.028000] pci 0000:00:09.0: transparent bridge
[    1.032000] pci 0000:00:09.0: bridge io port: [0xc000-0xcfff]
[    1.036000] pci 0000:00:09.0: bridge 32bit mmio: [0xda000000-0xda0fffff]
[    1.040000] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
[    1.044000] pci 0000:01:00.0: reg 14 io port: [0xb000-0xb0ff]
[    1.048000] pci 0000:01:00.0: reg 18 32bit mmio: [0xd9000000-0xd900ffff]
[    1.052000] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    1.056000] pci 0000:01:00.0: supports D1 D2
[    1.060000] pci 0000:01:00.1: reg 10 32bit mmio: [0xd9010000-0xd901ffff]
[    1.064000] pci 0000:01:00.1: supports D1 D2
[    1.068000] pci 0000:00:0e.0: bridge io port: [0xb000-0xbfff]
[    1.072000] pci 0000:00:0e.0: bridge 32bit mmio: [0xd8000000-0xd9ffffff]
[    1.076000] pci 0000:00:0e.0: bridge 64bit mmio pref: [0xd0000000-0xd7ffffff]
[    1.088000] pci 0000:00:00.0: default IRQ router [10de:005e]
[    1.092000] initcall pci_subsys_init+0x0/0x177 returned 0 after 222656 usecs
[    1.096000] calling  proto_init+0x0/0xf @ 1
[    1.100000] initcall proto_init+0x0/0xf returned 0 after 0 usecs
[    1.104000] calling  net_dev_init+0x0/0x1ba @ 1
[    1.108000] initcall net_dev_init+0x0/0x1ba returned 0 after 0 usecs
[    1.112000] calling  neigh_init+0x0/0x66 @ 1
[    1.116000] initcall neigh_init+0x0/0x66 returned 0 after 0 usecs
[    1.120000] calling  fib_rules_init+0x0/0xc1 @ 1
[    1.124000] initcall fib_rules_init+0x0/0xc1 returned 0 after 0 usecs
[    1.128000] calling  genl_init+0x0/0x107 @ 1
[    1.132000] initcall genl_init+0x0/0x107 returned 0 after 0 usecs
[    1.136000] calling  cipso_v4_init+0x0/0x83 @ 1
[    1.140000] initcall cipso_v4_init+0x0/0x83 returned 0 after 0 usecs
[    1.144000] calling  irda_init+0x0/0xc4 @ 1
[    1.148000] NET: Registered protocol family 23
[    1.152000] initcall irda_init+0x0/0xc4 returned 0 after 3906 usecs
[    1.156000] calling  wireless_nlevent_init+0x0/0x25 @ 1
[    1.160000] initcall wireless_nlevent_init+0x0/0x25 returned 0 after 0 usecs
[    1.164000] calling  netlbl_init+0x0/0xd0 @ 1
[    1.168000] NetLabel: Initializing
[    1.172000] NetLabel:  domain hash size = 128
[    1.176000] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.180000] NetLabel:  unlabeled traffic allowed by default
[    1.184000] initcall netlbl_init+0x0/0xd0 returned 0 after 15625 usecs
[    1.188000] calling  rfkill_init+0x0/0x89 @ 1
[    1.192000] initcall rfkill_init+0x0/0x89 returned 0 after 0 usecs
[    1.196000] calling  sysctl_init+0x0/0x51 @ 1
[    1.200000] initcall sysctl_init+0x0/0x51 returned 0 after 0 usecs
[    1.204000] calling  pci_iommu_init+0x0/0x11 @ 1
[    1.208000] initcall pci_iommu_init+0x0/0x11 returned 0 after 0 usecs
[    1.212000] calling  print_all_ICs+0x0/0x62a @ 1
[    1.216000] 
[    1.216000] printing PIC contents
[    1.220000] ... PIC  IMR: fffa
[    1.220000] ... PIC  IRR: 0000
[    1.224000] ... PIC  ISR: 0000
[    1.228000] ... PIC ELCR: 0828
[    1.232000] BUG: unable to handle kernel paging request at ffffb020
[    1.232000] IP: [<78417d5c>] native_apic_mem_read+0x15/0x19
[    1.232000] *pde = 010ef067 *pte = 00000000 
[    1.232000] Oops: 0000 [#1] PREEMPT 
[    1.232000] last sysfs file: 
[    1.232000] Modules linked in:
[    1.232000] 
[    1.232000] Pid: 1, comm: swapper Not tainted (2.6.30-rc5-tip #40847) System Product Name
[    1.232000] EIP: 0060:[<78417d5c>] EFLAGS: 00010046 CPU: 0
[    1.232000] EIP is at native_apic_mem_read+0x15/0x19
[    1.232000] EAX: ffffb020 EBX: 00000000 ECX: 00000000 EDX: fffff000
[    1.232000] ESI: 00000000 EDI: 7908c52e EBP: 9786fd38 ESP: 9786fd38
[    1.232000]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    1.232000] Process swapper (pid: 1, ti=9786e000 task=97870000 task.ti=9786e000)
[    1.232000] Stack:
[    1.232000]  9786fd40 78416e0d 9786fd48 78416fad 9786fd64 7908c55f 00000001 00000000
[    1.232000]  00000000 00000000 7908c52e 9786fd78 784671bf 00000001 00000000 00000000
[    1.232000]  9786fdac 7908ca42 00000001 9786fda0 784551ad 00000001 00000000 487ab0fc
[    1.232000] Call Trace:
[    1.232000]  [<78416e0d>] ? read_apic_id+0x19/0x24
[    1.232000]  [<78416fad>] ? hard_smp_processor_id+0xd/0xf
[    1.232000]  [<7908c55f>] ? print_local_APIC+0x31/0x3c7
[    1.232000]  [<7908c52e>] ? print_local_APIC+0x0/0x3c7
[    1.232000]  [<784671bf>] ? smp_call_function_single+0x5b/0x64
[    1.232000]  [<7908ca42>] ? print_all_ICs+0x14d/0x62a
[    1.232000]  [<784551ad>] ? ktime_get+0x16/0x34
[    1.232000]  [<7908c8f5>] ? print_all_ICs+0x0/0x62a
[    1.232000]  [<7908c8f5>] ? print_all_ICs+0x0/0x62a
[    1.232000]  [<7840107f>] ? _stext+0x7f/0x1f2
[    1.232000]  [<786c2658>] ? put_dec+0x44/0x137
[    1.232000]  [<784afae4>] ? page_count+0x22/0x3f
[    1.232000]  [<784b1c0a>] ? get_page_from_freelist+0x51f/0x6b0
[    1.232000]  [<786c2658>] ? put_dec+0x44/0x137
[    1.232000]  [<784dcbee>] ? check_object+0x207/0x252
[    1.232000]  [<786bb54f>] ? ida_get_new_above+0x2b0/0x2ca
[    1.232000]  [<784dd5c5>] ? __slab_free+0x11a/0x4af
[    1.232000]  [<784df012>] ? kmem_cache_free+0xce/0x163
[    1.232000]  [<786bb54f>] ? ida_get_new_above+0x2b0/0x2ca
[    1.232000]  [<786bb54f>] ? ida_get_new_above+0x2b0/0x2ca
[    1.232000]  [<786bb75f>] ? ida_pre_get+0x13/0x18b
[    1.232000]  [<7853f384>] ? proc_register+0x32a/0x34e
[    1.232000]  [<7853f5bd>] ? create_proc_entry+0xf0/0x119
[    1.232000]  [<7847e0bc>] ? register_irq_proc+0x87/0xbb
[    1.232000]  [<7908251b>] ? kernel_init+0x8d/0x10a
[    1.232000]  [<7908248e>] ? kernel_init+0x0/0x10a
[    1.232000]  [<78403ee7>] ? kernel_thread_helper+0x7/0x10
[    1.232000] Code: 44 00 00 89 d1 8b 15 08 8b de 78 8d 84 10 00 c0 ff ff 89 08 5d c3 55 89 e5 0f 1f 44 00 00 8b 15 08 8b de 78 8d 84 10 00 c0 ff ff <8b> 00 5d c3 55 89 e5 0f 1f 44 00 00 89 c2 eb 02 f3 90 8b 02 85 
[    1.232000] EIP: [<78417d5c>] native_apic_mem_read+0x15/0x19 SS:ESP 0068:9786fd38
[    1.232000] CR2: 00000000ffffb020
[    1.232000] ---[ end trace a7919e7f17c0a725 ]---
[    1.232000] Kernel panic - not syncing: Fatal exception
