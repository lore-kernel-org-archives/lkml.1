Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbXLAVE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbXLAVE2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 16:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbXLAVEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 16:04:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46996 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbXLAVEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 16:04:07 -0500
Date: Sat, 1 Dec 2007 22:03:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [bug] cops/atalk hung bootup with 2.6.23-rc4
Message-ID: <20071201210322.GA9080@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


with a random config kernel i'm getting this during bootup:

[   23.061449] cops.c:v0.04 6/7/98 Jay Schulist <jschlst@samba.org>
[   23.067416] lt0: cops at 0x240, IRQ 5, in Tangent mode
[   23.106029] lt0: Bad packet length of 65535 bytes.
[   23.144185] lt0: Bad packet length of 65535 bytes.
[   23.182342] lt0: Bad packet length of 65535 bytes.
[   23.220498] lt0: Bad packet length of 65535 bytes.
[   23.258655] lt0: Bad packet length of 65535 bytes.

ad infinitum, with occasional OOMs:

[  279.437756] swapper: page allocation failure. order:5, mode:0x4020
[  279.443900] Pid: 1, comm: swapper Not tainted 2.6.24-rc3-cfs-v24 #591
[  279.450312]  [<c0165859>] __alloc_pages+0x319/0x3f0
[  279.455165]  [<c0165969>] __get_free_pages+0x39/0x50
[  279.460104]  [<c0743875>] __alloc_skb+0x55/0x120
[  279.464696]  [<c04be006>] cops_rx+0x66/0x290
[  279.468943]  [<c04be979>] cops_interrupt+0x49/0xe0
[  279.473710]  [<c015aae0>] handle_IRQ_event+0x30/0x60
[  279.478649]  [<c015c24d>] handle_fasteoi_irq+0x6d/0xe0
[  279.483762]  [<c0108d0b>] do_IRQ+0x3b/0x70
[  279.487836]  [<c0106b3b>] common_interrupt+0x23/0x28

and a hung bootup. Config and bootlog attached. I guess the core problem 
is that somehow the the cops driver got registered to IRQ5:

[   23.067416] lt0: cops at 0x240, IRQ 5, in Tangent mode

is this an old ISA driver perhaps that should i exclude from this 
randconfig testing?

	Ingo

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="boot.log"

looking for log: #591 SMP Sat Dec 1 21:35:31 CET 2007
[    0.000000] Linux version 2.6.24-rc3-cfs-v24 (mingo@dione) (gcc version 4.2.2) #591 SMP Sat Dec 1 21:35:31 CET 2007
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
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f5680
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   262128
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   262128
[    0.000000] DMI 2.3 present.
[    0.000000] Using APIC driver default
[    0.000000] ACPI: RSDP 000F76F0, 0014 (r0 Nvidia)
[    0.000000] ACPI: RSDT 3FFF3040, 0034 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: FACP 3FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: DSDT 3FFF3180, 6264 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
[    0.000000] ACPI: FACS 3FFF0000, 0040
[    0.000000] ACPI: SRAT 3FFF9500, 00A0 (r1 AMD    HAMMER          1 AMD         1)
[    0.000000] ACPI: MCFG 3FFF9600, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: APIC 3FFF9440, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000] OEM ID: OEM00000 Product ID: PROD00000000 APIC at: 0xFEE00000
[    0.000000] Processor #0 15:3 APIC version 17
[    0.000000] Processor #1 15:3 APIC version 17
[    0.000000] I/O APIC #2 Version 17 at 0xFEC00000.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Processors: 2
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260081
[    0.000000] Kernel command line: root=/dev/sda1 console=tty earlyprintk=serial,ttyS0,115200,keep 3 profile=0 debug initcall_debug enforcing=0 apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nolapic idle=mwait
[    0.000000] kernel profiling enabled (shift: 0)
[    0.000000] debug: sysrq always enabled.
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2160.230 MHz processor.
[   12.749070] spurious 8259A interrupt: IRQ7.
[   12.753873] Console: colour VGA+ 80x25
[   12.757446] console [tty0] enabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.24-rc3-cfs-v24 (mingo@dione) (gcc version 4.2.2) #591 SMP Sat Dec 1 21:35:31 CET 2007
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
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f5680
[    0.000000] Entering add_active_range(0, 0, 262128) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   262128
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   262128
[    0.000000] On node 0 totalpages: 262128
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 255 pages used for memmap
[    0.000000]   HighMem zone: 32497 pages, LIFO batch:7
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] Using APIC driver default
[    0.000000] ACPI: RSDP 000F76F0, 0014 (r0 Nvidia)
[    0.000000] ACPI: RSDT 3FFF3040, 0034 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: FACP 3FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: DSDT 3FFF3180, 6264 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
[    0.000000] ACPI: FACS 3FFF0000, 0040
[    0.000000] ACPI: SRAT 3FFF9500, 00A0 (r1 AMD    HAMMER          1 AMD         1)
[    0.000000] ACPI: MCFG 3FFF9600, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: APIC 3FFF9440, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000] OEM ID: OEM00000 Product ID: PROD00000000 APIC at: 0xFEE00000
[    0.000000] Processor #0 15:3 APIC version 17
[    0.000000] Processor #1 15:3 APIC version 17
[    0.000000] I/O APIC #2 Version 17 at 0xFEC00000.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Processors: 2
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260081
[    0.000000] Kernel command line: root=/dev/sda1 console=tty earlyprintk=serial,ttyS0,115200,keep 3 profile=0 debug initcall_debug enforcing=0 apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nolapic idle=mwait
[    0.000000] kernel profiling enabled (shift: 0)
[    0.000000] debug: sysrq always enabled.
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2160.230 MHz processor.
[   12.749070] spurious 8259A interrupt: IRQ7.
[   12.753873] Console: colour VGA+ 80x25
[   12.757446] console [tty0] enabled
[   13.129138] ------------------------
[   13.132689] | Locking API testsuite:
[   13.136242] ----------------------------------------------------------------------------
[   13.144301]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[   13.152361]   --------------------------------------------------------------------------
[   13.160421]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
[   13.168479]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
[   13.176539]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
[   13.184598]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
[   13.192658]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[   13.200718]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[   13.208776]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[   13.216837]                     double unlock:failed|failed|failed|  ok  |failed|failed|
[   13.224896]                   initialize held:failed|failed|failed|failed|failed|failed|
[   13.232955]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   13.241015]   --------------------------------------------------------------------------
[   13.249074]               recursive read-lock:             |  ok  |             |failed|
[   13.257134]            recursive read-lock #2:             |  ok  |             |failed|
[   13.265193]             mixed read-write-lock:             |failed|             |failed|
[   13.273253]             mixed write-read-lock:             |failed|             |failed|
[   13.281313]   --------------------------------------------------------------------------
[   13.289371]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[   13.295611]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[   13.301851]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[   13.308091]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[   13.314330]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[   13.320570]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
[   13.326809]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[   13.333050]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[   13.339289]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[   13.345528]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[   13.351768]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[   13.358007]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[   13.364247]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[   13.370487]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[   13.376726]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[   13.382966]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[   13.389205]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[   13.395445]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[   13.401685]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[   13.407924]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[   13.414164]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[   13.420403]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[   13.426643]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[   13.432883]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[   13.439122]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[   13.445362]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[   13.451602]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[   13.457842]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[   13.464081]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[   13.470321]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[   13.476560]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[   13.482800]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[   13.489039]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[   13.495279]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[   13.501518]       hard-irq lock-inversion/123:failed|failed|  ok  |
[   13.507758]       soft-irq lock-inversion/123:failed|failed|  ok  |
[   13.513997]       hard-irq lock-inversion/132:failed|failed|  ok  |
[   13.520237]       soft-irq lock-inversion/132:failed|failed|  ok  |
[   13.526477]       hard-irq lock-inversion/213:failed|failed|  ok  |
[   13.532716]       soft-irq lock-inversion/213:failed|failed|  ok  |
[   13.538956]       hard-irq lock-inversion/231:failed|failed|  ok  |
[   13.545196]       soft-irq lock-inversion/231:failed|failed|  ok  |
[   13.551435]       hard-irq lock-inversion/312:failed|failed|  ok  |
[   13.557675]       soft-irq lock-inversion/312:failed|failed|  ok  |
[   13.563914]       hard-irq lock-inversion/321:failed|failed|  ok  |
[   13.570154]       soft-irq lock-inversion/321:failed|failed|  ok  |
[   13.576394]       hard-irq read-recursion/123:  ok  |
[   13.581420]       soft-irq read-recursion/123:  ok  |
[   13.586446]       hard-irq read-recursion/132:  ok  |
[   13.591473]       soft-irq read-recursion/132:  ok  |
[   13.596498]       hard-irq read-recursion/213:  ok  |
[   13.601526]       soft-irq read-recursion/213:  ok  |
[   13.606551]       hard-irq read-recursion/231:  ok  |
[   13.611578]       soft-irq read-recursion/231:  ok  |
[   13.616605]       hard-irq read-recursion/312:  ok  |
[   13.621630]       soft-irq read-recursion/312:  ok  |
[   13.626657]       hard-irq read-recursion/321:  ok  |
[   13.631684]       soft-irq read-recursion/321:  ok  |
[   13.636710] --------------------------------------------------------
[   13.643036] 144 out of 218 testcases failed, as expected. |
[   13.648583] ----------------------------------------------------
[   13.654858] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   13.662075] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   13.704863] Memory: 994312k/1048512k available (7632k kernel code, 53588k reserved, 3506k data, 552k init, 131008k highmem)
[   13.715836] virtual kernel memory layout:
[   13.715837]     fixmap  : 0xffc53000 - 0xfffff000   (3760 kB)
[   13.715838]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   13.715839]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   13.715840]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   13.715841]       .init : 0xc0bed000 - 0xc0c77000   ( 552 kB)
[   13.715842]       .data : 0xc0874327 - 0xc0be0cac   (3506 kB)
[   13.715843]       .text : 0xc0100000 - 0xc0874327   (7632 kB)
[   13.759856] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   13.768360] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[   13.859294] Calibrating delay using timer specific routine.. 4323.19 BogoMIPS (lpj=7203510)
[   13.867509] Security Framework initialized
[   13.871562] SELinux:  Disabled at boot.
[   13.875373] Capability LSM initialized
[   13.879109] Mount-cache hash table entries: 512
[   13.883726] CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000 00000001 00000000 00000003 00000000
[   13.894260] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   13.901369] CPU: L2 Cache: 512K (64 bytes/line)
[   13.905877] CPU 0(2) -> Core 0
[   13.908909] CPU: After all inits, caps: 178bfbf7 e3d3fbff 00000000 00000410 00000001 00000000 00000003 00000000
[   13.918961] Compat vDSO mapped to ffffe000.
[   13.923125] Checking 'hlt' instruction... OK.
[   13.940932] Freeing SMP alternatives: 33k freed
[   13.945321] ACPI: Core revision 20070126
[   13.951507] ACPI: setting ELCR to 0200 (from 0828)
[   13.957586] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[   13.964476] enabled ExtINT on CPU#0
[   13.967953] Booting processor 1/1 ip 2000
[   13.981918] Initializing CPU#1
[   13.982877] masked ExtINT on CPU#1
[   14.065868] Calibrating delay using timer specific routine.. 4321.16 BogoMIPS (lpj=7200259)
[   14.065874] CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000 00000001 00000000 00000003 00000000
[   14.065880] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   14.065882] CPU: L2 Cache: 512K (64 bytes/line)
[   14.065884] CPU 1(2) -> Core 1
[   14.065885] CPU: After all inits, caps: 178bfbf7 e3d3fbff 00000000 00000410 00000001 00000000 00000003 00000000
[   14.065994] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[   14.122992] Total of 2 processors activated (8645.35 BogoMIPS).
[   14.128922] ExtINT not setup in hardware but reported by MP table
[   14.135020] ENABLING IO-APIC IRQs
[   14.138232] init IO_APIC IRQs
[   14.141179]  IO-APIC (apicid-pin) 2-0 not connected.
[   14.146164]  IO-APIC (apicid-pin) 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
[   14.154903] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
[   14.193605] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[   14.199279] ...trying to set up timer (IRQ0) through the 8259A ... 
[   14.205346] ..... (found pin 0) ...works.
[   14.242385] number of MP IRQ sources: 17.
[   14.246373] number of IO-APIC #2 registers: 24.
[   14.250878] testing the IO APIC.......................
[   14.255994] IO APIC #2......
[   14.258851] .... register #00: 00000000
[   14.262665] .......    : physical APIC id: 00
[   14.266998] .......    : Delivery Type: 0
[   14.270985] .......    : LTS          : 0
[   14.274971] .... register #01: 00170011
[   14.278784] .......     : max redirection entries: 0017
[   14.283984] .......     : PRQ implemented: 0
[   14.288230] .......     : IO APIC version: 0011
[   14.292736] .... register #02: 00000000
[   14.296550] .......     : arbitration: 00
[   14.300536] .... IRQ redirection table:
[   14.304349]  NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
[   14.310418]  00 001 01  0    0    0   0   0    1    1    31
[   14.315963]  01 001 01  0    0    0   0   0    1    1    39
[   14.321510]  02 000 00  1    0    0   0   0    0    0    00
[   14.327056]  03 001 01  1    1    0   1   0    1    1    41
[   14.332602]  04 001 01  0    0    0   0   0    1    1    49
[   14.338149]  05 001 01  1    1    0   1   0    1    1    51
[   14.343695]  06 001 01  0    0    0   0   0    1    1    59
[   14.349241]  07 001 01  1    0    0   0   0    1    1    61
[   14.354788]  08 001 01  0    0    0   0   0    1    1    69
[   14.360334]  09 001 01  0    0    0   0   0    1    1    71
[   14.365879]  0a 001 01  0    0    0   0   0    1    1    79
[   14.371426]  0b 001 01  1    1    0   1   0    1    1    81
[   14.376973]  0c 001 01  0    0    0   0   0    1    1    89
[   14.382518]  0d 001 01  0    0    0   0   0    1    1    91
[   14.388066]  0e 001 01  0    0    0   0   0    1    1    99
[   14.393612]  0f 001 01  0    0    0   0   0    1    1    A1
[   14.399157]  10 000 00  1    0    0   0   0    0    0    00
[   14.404705]  11 000 00  1    0    0   0   0    0    0    00
[   14.410251]  12 000 00  1    0    0   0   0    0    0    00
[   14.415796]  13 000 00  1    0    0   0   0    0    0    00
[   14.421344]  14 000 00  1    0    0   0   0    0    0    00
[   14.426889]  15 000 00  1    0    0   0   0    0    0    00
[   14.432435]  16 000 00  1    0    0   0   0    0    0    00
[   14.437983]  17 000 00  1    0    0   0   0    0    0    00
[   14.443527] IRQ to pin mappings:
[   14.446733] IRQ0 -> 0:0
[   14.449158] IRQ1 -> 0:1
[   14.451585] IRQ3 -> 0:3
[   14.454011] IRQ4 -> 0:4
[   14.456439] IRQ5 -> 0:5
[   14.458864] IRQ6 -> 0:6
[   14.461291] IRQ7 -> 0:7
[   14.463718] IRQ8 -> 0:8
[   14.466144] IRQ9 -> 0:9
[   14.468570] IRQ10 -> 0:10
[   14.471170] IRQ11 -> 0:11
[   14.473770] IRQ12 -> 0:12
[   14.476370] IRQ13 -> 0:13
[   14.478970] IRQ14 -> 0:14
[   14.481570] IRQ15 -> 0:15
[   14.484171] .................................... done.
[   14.489284] Using local APIC timer interrupts.
[   14.489285] calibrating APIC timer ...
[   14.602529] ... lapic delta = 1350030
[   14.606041] ... PM timer delta = 357929
[   14.609855] ... PM timer result ok
[   14.613235] ..... delta 1350030
[   14.616354] ..... mult: 57987127
[   14.619560] ..... calibration result: 720016
[   14.623807] ..... CPU clock speed is 2160.0878 MHz.
[   14.628661] ..... host bus clock speed is 216.0088 MHz.
[   14.633944] Brought up 2 CPUs
[   14.636836] CPU0 attaching sched-domain:
[   14.640710]  domain 0: span 00000003
[   14.644261]   groups: 00000001 00000002
[   14.648072] CPU1 attaching sched-domain:
[   14.651974]  domain 0: span 00000003
[   14.655525]   groups: 00000002 00000001
[   14.659536] Calling initcall 0xc0c27270: init_cpufreq_transition_notifier_list+0x0/0x10()
[   14.667554] initcall 0xc0c27270: init_cpufreq_transition_notifier_list+0x0/0x10() returned 0.
[   14.676047] initcall 0xc0c27270 ran for 0 msecs: init_cpufreq_transition_notifier_list+0x0/0x10()
[   14.684887] Calling initcall 0xc0c2acd0: net_ns_init+0x0/0x180()
[   14.690866] net_namespace: 64 bytes
[   14.694335] initcall 0xc0c2acd0: net_ns_init+0x0/0x180() returned 0.
[   14.700659] initcall 0xc0c2acd0 ran for 3 msecs: net_ns_init+0x0/0x180()
[   14.707332] Calling initcall 0xc0bf3b00: cpufreq_tsc+0x0/0x10()
[   14.713224] initcall 0xc0bf3b00: cpufreq_tsc+0x0/0x10() returned 0.
[   14.719463] initcall 0xc0bf3b00 ran for 0 msecs: cpufreq_tsc+0x0/0x10()
[   14.726050] Calling initcall 0xc0bfa8a0: reboot_init+0x0/0x10()
[   14.731945] initcall 0xc0bfa8a0: reboot_init+0x0/0x10() returned 0.
[   14.738184] initcall 0xc0bfa8a0 ran for 0 msecs: reboot_init+0x0/0x10()
[   14.744770] Calling initcall 0xc0c01230: print_banner+0x0/0x10()
[   14.750749] Booting paravirtualized kernel on bare hardware
[   14.756296] initcall 0xc0c01230: print_banner+0x0/0x10() returned 0.
[   14.762621] initcall 0xc0c01230 ran for 3 msecs: print_banner+0x0/0x10()
[   14.769295] Calling initcall 0xc0c036c0: sysctl_init+0x0/0x20()
[   14.775470] initcall 0xc0c036c0: sysctl_init+0x0/0x20() returned 0.
[   14.781575] initcall 0xc0c036c0 ran for 0 msecs: sysctl_init+0x0/0x20()
[   14.788162] Calling initcall 0xc0c04350: init_jiffies_clocksource+0x0/0x10()
[   14.795181] initcall 0xc0c04350: init_jiffies_clocksource+0x0/0x10() returned 0.
[   14.802545] initcall 0xc0c04350 ran for 0 msecs: init_jiffies_clocksource+0x0/0x10()
[   14.810259] Calling initcall 0xc0c04750: pm_init+0x0/0x20()
[   14.815807] initcall 0xc0c04750: pm_init+0x0/0x20() returned 0.
[   14.821699] initcall 0xc0c04750 ran for 0 msecs: pm_init+0x0/0x20()
[   14.827939] Calling initcall 0xc0c053f0: ksysfs_init+0x0/0x50()
[   14.833864] initcall 0xc0c053f0: ksysfs_init+0x0/0x50() returned 0.
[   14.840070] initcall 0xc0c053f0 ran for 3 msecs: ksysfs_init+0x0/0x50()
[   14.846656] Calling initcall 0xc0c07e90: filelock_init+0x0/0x30()
[   14.852723] initcall 0xc0c07e90: filelock_init+0x0/0x30() returned 0.
[   14.859136] initcall 0xc0c07e90 ran for 0 msecs: filelock_init+0x0/0x30()
[   14.865896] Calling initcall 0xc0c088c0: init_aout_binfmt+0x0/0x10()
[   14.872222] initcall 0xc0c088c0: init_aout_binfmt+0x0/0x10() returned 0.
[   14.878894] initcall 0xc0c088c0 ran for 0 msecs: init_aout_binfmt+0x0/0x10()
[   14.885914] Calling initcall 0xc0c088d0: init_misc_binfmt+0x0/0x40()
[   14.892242] initcall 0xc0c088d0: init_misc_binfmt+0x0/0x40() returned 0.
[   14.898913] initcall 0xc0c088d0 ran for 0 msecs: init_misc_binfmt+0x0/0x40()
[   14.905933] Calling initcall 0xc0c08910: init_script_binfmt+0x0/0x10()
[   14.912432] initcall 0xc0c08910: init_script_binfmt+0x0/0x10() returned 0.
[   14.919278] initcall 0xc0c08910 ran for 0 msecs: init_script_binfmt+0x0/0x10()
[   14.926473] Calling initcall 0xc0c08920: init_elf_binfmt+0x0/0x10()
[   14.932710] initcall 0xc0c08920: init_elf_binfmt+0x0/0x10() returned 0.
[   14.939297] initcall 0xc0c08920 ran for 0 msecs: init_elf_binfmt+0x0/0x10()
[   14.946231] Calling initcall 0xc0c0a950: securityfs_init+0x0/0x40()
[   14.952493] initcall 0xc0c0a950: securityfs_init+0x0/0x40() returned 0.
[   14.959055] initcall 0xc0c0a950 ran for 0 msecs: securityfs_init+0x0/0x40()
[   14.965990] Calling initcall 0xc0c0b860: random32_init+0x0/0x50()
[   14.972055] initcall 0xc0c0b860: random32_init+0x0/0x50() returned 0.
[   14.978468] initcall 0xc0c0b860 ran for 0 msecs: random32_init+0x0/0x50()
[   14.985228] Calling initcall 0xc0c27280: cpufreq_core_init+0x0/0x60()
[   14.991640] initcall 0xc0c27280: cpufreq_core_init+0x0/0x60() returned 0.
[   14.998400] initcall 0xc0c27280 ran for 0 msecs: cpufreq_core_init+0x0/0x60()
[   15.005923] Calling initcall 0xc072b470: virtio_init+0x0/0x30()
[   15.011843] initcall 0xc072b470: virtio_init+0x0/0x30() returned 0.
[   15.018059] initcall 0xc072b470 ran for 0 msecs: virtio_init+0x0/0x30()
[   15.024643] Calling initcall 0xc0c2ab80: sock_init+0x0/0x60()
[   15.030378] initcall 0xc0c2ab80: sock_init+0x0/0x60() returned 0.
[   15.036427] initcall 0xc0c2ab80 ran for 0 msecs: sock_init+0x0/0x60()
[   15.042840] Calling initcall 0xc0c2b4b0: netpoll_init+0x0/0x30()
[   15.048819] initcall 0xc0c2b4b0: netpoll_init+0x0/0x30() returned 0.
[   15.055145] initcall 0xc0c2b4b0 ran for 0 msecs: netpoll_init+0x0/0x30()
[   15.061820] Calling initcall 0xc0c2bdb0: netlink_proto_init+0x0/0x130()
[   15.068410] NET: Registered protocol family 16
[   15.072835] initcall 0xc0c2bdb0: netlink_proto_init+0x0/0x130() returned 0.
[   15.079757] initcall 0xc0c2bdb0 ran for 3 msecs: netlink_proto_init+0x0/0x130()
[   15.087037] Calling initcall 0xc0c010f0: geode_southbridge_init+0x0/0xd0()
[   15.093885] initcall 0xc0c010f0: geode_southbridge_init+0x0/0xd0() returned -19.
[   15.101251] initcall 0xc0c010f0 ran for 0 msecs: geode_southbridge_init+0x0/0xd0()
[   15.108790] Calling initcall 0xc0c0b730: kobject_uevent_init+0x0/0x60()
[   15.115376] initcall 0xc0c0b730: kobject_uevent_init+0x0/0x60() returned 0.
[   15.122308] initcall 0xc0c0b730 ran for 0 msecs: kobject_uevent_init+0x0/0x60()
[   15.129589] Calling initcall 0xc0c0ba80: pcibus_class_init+0x0/0x10()
[   15.136031] initcall 0xc0c0ba80: pcibus_class_init+0x0/0x10() returned 0.
[   15.142760] initcall 0xc0c0ba80 ran for 0 msecs: pcibus_class_init+0x0/0x10()
[   15.149866] Calling initcall 0xc0c0c0c0: pci_driver_init+0x0/0x10()
[   15.156133] initcall 0xc0c0c0c0: pci_driver_init+0x0/0x10() returned 0.
[   15.162692] initcall 0xc0c0c0c0 ran for 0 msecs: pci_driver_init+0x0/0x10()
[   15.169625] Calling initcall 0xc0c0c450: lcd_class_init+0x0/0x50()
[   15.175801] initcall 0xc0c0c450: lcd_class_init+0x0/0x50() returned 0.
[   15.182278] initcall 0xc0c0c450 ran for 0 msecs: lcd_class_init+0x0/0x50()
[   15.189125] Calling initcall 0xc0c0c4a0: backlight_class_init+0x0/0x50()
[   15.195820] initcall 0xc0c0c4a0: backlight_class_init+0x0/0x50() returned 0.
[   15.202816] initcall 0xc0c0c4a0 ran for 0 msecs: backlight_class_init+0x0/0x50()
[   15.210183] Calling initcall 0xc0c0c4f0: video_output_class_init+0x0/0xa()
[   15.217051] initcall 0xc0c0c4f0: video_output_class_init+0x0/0xa() returned 0.
[   15.224223] initcall 0xc0c0c4f0 ran for 0 msecs: video_output_class_init+0x0/0xa()
[   15.231762] Calling initcall 0xc0c0e790: tty_class_init+0x0/0x20()
[   15.237937] initcall 0xc0c0e790: tty_class_init+0x0/0x20() returned 0.
[   15.244417] initcall 0xc0c0e790 ran for 0 msecs: tty_class_init+0x0/0x20()
[   15.251261] Calling initcall 0xc0c0f430: vtconsole_class_init+0x0/0xd0()
[   15.257986] initcall 0xc0c0f430: vtconsole_class_init+0x0/0xd0() returned 0.
[   15.264956] initcall 0xc0c0f430 ran for 0 msecs: vtconsole_class_init+0x0/0xd0()
[   15.272320] Calling initcall 0xc0c26570: eisa_init+0x0/0x30()
[   15.278064] EISA bus registered
[   15.281161] initcall 0xc0c26570: eisa_init+0x0/0x30() returned 0.
[   15.287226] initcall 0xc0c26570 ran for 3 msecs: eisa_init+0x0/0x30()
[   15.293637] Calling initcall 0xc0c26c50: lguest_devices_init+0x0/0x130()
[   15.300310] initcall 0xc0c26c50: lguest_devices_init+0x0/0x130() returned 0.
[   15.307331] initcall 0xc0c26c50 ran for 0 msecs: lguest_devices_init+0x0/0x130()
[   15.314697] Calling initcall 0xc0bf3970: init_pit_clocksource+0x0/0x90()
[   15.321369] initcall 0xc0bf3970: init_pit_clocksource+0x0/0x90() returned 0.
[   15.328389] initcall 0xc0bf3970 ran for 0 msecs: init_pit_clocksource+0x0/0x90()
[   15.335756] Calling initcall 0xc0bfa7c0: ffh_cstate_init+0x0/0x30()
[   15.341994] initcall 0xc0bfa7c0: ffh_cstate_init+0x0/0x30() returned -1.
[   15.348667] initcall 0xc0bfa7c0 ran for 0 msecs: ffh_cstate_init+0x0/0x30()
[   15.355601] initcall at 0xc0bfa7c0: ffh_cstate_init+0x0/0x30(): returned with error code -1
[   15.363921] Calling initcall 0xc0c0c3f0: acpi_pci_init+0x0/0x40()
[   15.369986] ACPI: bus type pci registered
[   15.373973] initcall 0xc0c0c3f0: acpi_pci_init+0x0/0x40() returned 0.
[   15.380386] initcall 0xc0c0c3f0 ran for 3 msecs: acpi_pci_init+0x0/0x40()
[   15.387145] Calling initcall 0xc0c0d187: init_acpi_device_notify+0x0/0x3f()
[   15.394077] initcall 0xc0c0d187: init_acpi_device_notify+0x0/0x3f() returned 0.
[   15.401359] initcall 0xc0c0d187 ran for 0 msecs: init_acpi_device_notify+0x0/0x3f()
[   15.408985] Calling initcall 0xc0c28720: init_cyclone_clocksource+0x0/0x1c0()
[   15.416089] initcall 0xc0c28720: init_cyclone_clocksource+0x0/0x1c0() returned -19.
[   15.423716] initcall 0xc0c28720 ran for 0 msecs: init_cyclone_clocksource+0x0/0x1c0()
[   15.431517] Calling initcall 0xc0c28f60: pci_access_init+0x0/0x50()
[   15.442337] PCI: PCI BIOS revision 3.00 entry at 0xf21d0, last bus=5
[   15.448536] PCI: Using configuration type 1
[   15.452697] initcall 0xc0c28f60: pci_access_init+0x0/0x50() returned 0.
[   15.459281] initcall 0xc0c28f60 ran for 9 msecs: pci_access_init+0x0/0x50()
[   15.466214] Calling initcall 0xc0bf1ce0: request_standard_resources+0x0/0xa0()
[   15.473408] Setting up standard PCI resources
[   15.480535] initcall 0xc0bf1ce0: request_standard_resources+0x0/0xa0() returned 0.
[   15.487942] initcall 0xc0bf1ce0 ran for 6 msecs: request_standard_resources+0x0/0xa0()
[   15.495828] Calling initcall 0xc0bf3850: topology_init+0x0/0x30()
[   15.501945] initcall 0xc0bf3850: topology_init+0x0/0x30() returned 0.
[   15.508306] initcall 0xc0bf3850 ran for 0 msecs: topology_init+0x0/0x30()
[   15.515067] Calling initcall 0xc0bfa8e0: mca_init+0x0/0x320()
[   15.520813] initcall 0xc0bfa8e0: mca_init+0x0/0x320() returned -19.
[   15.527024] initcall 0xc0bfa8e0 ran for 0 msecs: mca_init+0x0/0x320()
[   15.533437] Calling initcall 0xc0c03d70: param_sysfs_init+0x0/0x190()
[   15.544618] initcall 0xc0c03d70: param_sysfs_init+0x0/0x190() returned 0.
[   15.551306] initcall 0xc0c03d70 ran for 6 msecs: param_sysfs_init+0x0/0x190()
[   15.558414] Calling initcall 0xc014b7f0: pm_sysrq_init+0x0/0x20()
[   15.564420] initcall 0xc014b7f0: pm_sysrq_init+0x0/0x20() returned 0.
[   15.570888] initcall 0xc014b7f0 ran for 0 msecs: pm_sysrq_init+0x0/0x20()
[   15.577593] Calling initcall 0xc0c074e0: readahead_init+0x0/0x10()
[   15.583748] initcall 0xc0c074e0: readahead_init+0x0/0x10() returned 0.
[   15.590244] initcall 0xc0c074e0 ran for 0 msecs: readahead_init+0x0/0x10()
[   15.597091] Calling initcall 0xc0c085b0: init_bio+0x0/0x100()
[   15.602825] initcall 0xc0c085b0: init_bio+0x0/0x100() returned 0.
[   15.608876] initcall 0xc0c085b0 ran for 0 msecs: init_bio+0x0/0x100()
[   15.615290] Calling initcall 0xc0c0b540: genhd_device_init+0x0/0x60()
[   15.621736] initcall 0xc0c0b540: genhd_device_init+0x0/0x60() returned 0.
[   15.628461] initcall 0xc0c0b540 ran for 0 msecs: genhd_device_init+0x0/0x60()
[   15.635570] Calling initcall 0xc0c0cede: acpi_init+0x0/0x1b5()
[   15.642047] ACPI: EC: Look up EC in DSDT
[   15.651830] ACPI: Interpreter enabled
[   15.655346] ACPI: (supports S0 S5)
[   15.658723] ACPI: Using PIC for interrupt routing
[   15.663448] PCI: MCFG configuration 0: base 3758096384 segment 0 buses 0 - 255
[   15.676046] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[   15.683025] PCI: Using MMCONFIG
[   15.686163] PCI: No mmconfig possible on device 00:18
[   15.691481] initcall 0xc0c0cede: acpi_init+0x0/0x1b5() returned 0.
[   15.697506] initcall 0xc0c0cede ran for 34 msecs: acpi_init+0x0/0x1b5()
[   15.704092] Calling initcall 0xc0c0d1c6: acpi_scan_init+0x0/0xec()
[   15.718923] initcall 0xc0c0d1c6: acpi_scan_init+0x0/0xec() returned 0.
[   15.725297] initcall 0xc0c0d1c6 ran for 9 msecs: acpi_scan_init+0x0/0xec()
[   15.732144] Calling initcall 0xc0c0d2b2: acpi_ec_init+0x0/0x51()
[   15.738176] initcall 0xc0c0d2b2: acpi_ec_init+0x0/0x51() returned 0.
[   15.744504] initcall 0xc0c0d2b2 ran for 0 msecs: acpi_ec_init+0x0/0x51()
[   15.751124] Calling initcall 0xc0c0d4a7: acpi_pci_root_init+0x0/0x21()
[   15.757658] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   15.762430] PCI: Scanning bus 0000:00
[   15.766048] PCI: Found 0000:00:00.0 [10de/005e] 000580 00
[   15.771423] PCI: Found 0000:00:01.0 [10de/0050] 000601 00
[   15.776788] PCI: Found 0000:00:01.1 [10de/0052] 000c05 00
[   15.782166] PCI: Found 0000:00:02.0 [10de/005a] 000c03 00
[   15.787536] PCI: Found 0000:00:02.1 [10de/005b] 000c03 00
[   15.792914] PCI: Found 0000:00:04.0 [10de/0059] 000401 00
[   15.798282] PCI: Found 0000:00:06.0 [10de/0053] 000101 00
[   15.803653] PCI: Found 0000:00:09.0 [10de/005c] 000604 01
[   15.809021] PCI: Found 0000:00:0a.0 [10de/0057] 000680 00
[   15.814402] PCI: Found 0000:00:0b.0 [10de/005d] 000604 01
[   15.819769] PCI: Found 0000:00:0c.0 [10de/005d] 000604 01
[   15.825141] PCI: Found 0000:00:0d.0 [10de/005d] 000604 01
[   15.830513] PCI: Found 0000:00:0e.0 [10de/005d] 000604 01
[   15.835894] PCI: Found 0000:00:18.0 [1022/1100] 000600 00
[   15.841259] PCI: Calling quirk c073a360 for 0000:00:18.0
[   15.846540] PCI: Found 0000:00:18.1 [1022/1101] 000600 00
[   15.851917] PCI: Calling quirk c073a360 for 0000:00:18.1
[   15.857199] PCI: Found 0000:00:18.2 [1022/1102] 000600 00
[   15.862576] PCI: Calling quirk c073a360 for 0000:00:18.2
[   15.867858] PCI: Found 0000:00:18.3 [1022/1103] 000600 00
[   15.873235] PCI: Calling quirk c073a360 for 0000:00:18.3
[   15.878522] PCI: Fixups for bus 0000:00
[   15.882329] PCI: Scanning behind PCI bridge 0000:00:09.0, config 050500, pass 0
[   15.889645] PCI: Scanning bus 0000:05
[   15.893264] PCI: Found 0000:05:07.0 [10ec/8139] 000200 00
[   15.898662] PCI: Fixups for bus 0000:05
[   15.902433] PCI: Transparent bridge - 0000:00:09.0
[   15.907201] PCI: Bus scan for 0000:05 returning with max=05
[   15.912747] PCI: Scanning behind PCI bridge 0000:00:0b.0, config 040400, pass 0
[   15.920055] PCI: Scanning bus 0000:04
[   15.923692] PCI: Fixups for bus 0000:04
[   15.927484] PCI: Bus scan for 0000:04 returning with max=04
[   15.933026] PCI: Scanning behind PCI bridge 0000:00:0c.0, config 030300, pass 0
[   15.940334] PCI: Scanning bus 0000:03
[   15.943971] PCI: Fixups for bus 0000:03
[   15.947762] PCI: Bus scan for 0000:03 returning with max=03
[   15.953306] PCI: Scanning behind PCI bridge 0000:00:0d.0, config 020200, pass 0
[   15.960613] PCI: Scanning bus 0000:02
[   15.964249] PCI: Fixups for bus 0000:02
[   15.968041] PCI: Bus scan for 0000:02 returning with max=02
[   15.973584] PCI: Scanning behind PCI bridge 0000:00:0e.0, config 010100, pass 0
[   15.980896] PCI: Scanning bus 0000:01
[   15.984954] PCI: Found 0000:01:00.0 [1002/5b60] 000300 00
[   15.990345] PCI: Found 0000:01:00.1 [1002/5b70] 000380 00
[   15.995732] PCI: Fixups for bus 0000:01
[   15.999506] PCI: Bus scan for 0000:01 returning with max=01
[   16.005050] PCI: Scanning behind PCI bridge 0000:00:09.0, config 050500, pass 1
[   16.012330] PCI: Scanning behind PCI bridge 0000:00:0b.0, config 040400, pass 1
[   16.019612] PCI: Scanning behind PCI bridge 0000:00:0c.0, config 030300, pass 1
[   16.026891] PCI: Scanning behind PCI bridge 0000:00:0d.0, config 020200, pass 1
[   16.034170] PCI: Scanning behind PCI bridge 0000:00:0e.0, config 010100, pass 1
[   16.041450] PCI: Bus scan for 0000:00 returning with max=05
[   16.046999] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   16.053118] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[   16.112595] initcall 0xc0c0d4a7: acpi_pci_root_init+0x0/0x21() returned 0.
[   16.119311] initcall 0xc0c0d4a7 ran for 228 msecs: acpi_pci_root_init+0x0/0x21()
[   16.126677] Calling initcall 0xc0c0d582: acpi_pci_link_init+0x0/0x3f()
[   16.133326] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[   16.141491] ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[   16.148524] ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[   16.155560] ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[   16.163725] ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[   16.171886] ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[   16.180042] ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[   16.188206] ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[   16.195243] ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 9 10 11 12 14 15)
[   16.202283] ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[   16.210446] ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[   16.218607] ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[   16.226770] ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[   16.234940] ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[   16.243103] ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[   16.251268] ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[   16.259450] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[   16.265720] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
[   16.271985] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
[   16.278251] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[   16.284464] ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
[   16.290589] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
[   16.297641] ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
[   16.304694] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0, disabled.
[   16.311740] ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0, disabled.
[   16.318794] ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
[   16.325848] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
[   16.332895] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
[   16.339948] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[   16.347010] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
[   16.354062] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
[   16.361116] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[   16.368047] initcall 0xc0c0d582: acpi_pci_link_init+0x0/0x3f() returned 0.
[   16.374850] initcall 0xc0c0d582 ran for 203 msecs: acpi_pci_link_init+0x0/0x3f()
[   16.382216] Calling initcall 0xc0c0d63c: acpi_power_init+0x0/0x65()
[   16.388502] initcall 0xc0c0d63c: acpi_power_init+0x0/0x65() returned 0.
[   16.395040] initcall 0xc0c0d63c ran for 0 msecs: acpi_power_init+0x0/0x65()
[   16.401975] Calling initcall 0xc0c0de17: acpi_system_init+0x0/0x171()
[   16.408419] initcall 0xc0c0de17: acpi_system_init+0x0/0x171() returned 0.
[   16.415146] initcall 0xc0c0de17 ran for 0 msecs: acpi_system_init+0x0/0x171()
[   16.422253] Calling initcall 0xc0c0dff3: acpi_cm_sbs_init+0x0/0xd()
[   16.428492] initcall 0xc0c0dff3: acpi_cm_sbs_init+0x0/0xd() returned 0.
[   16.435078] initcall 0xc0c0dff3 ran for 0 msecs: acpi_cm_sbs_init+0x0/0xd()
[   16.442012] Calling initcall 0xc0c0e000: pnp_init+0x0/0x20()
[   16.447644] Linux Plug and Play Support v0.97 (c) Adam Belay
[   16.453307] initcall 0xc0c0e000: pnp_init+0x0/0x20() returned 0.
[   16.459256] initcall 0xc0c0e000 ran for 3 msecs: pnp_init+0x0/0x20()
[   16.465583] Calling initcall 0xc0c0e220: pnpacpi_init+0x0/0x90()
[   16.471562] pnp: PnP ACPI init
[   16.474602] ACPI: bus type pnp registered
[   16.483371] pnpacpi: exceeded the max number of mem resources: 12
[   16.489316] pnpacpi: exceeded the max number of mem resources: 12
[   16.495440] pnp: PnP ACPI: found 16 devices
[   16.499539] ACPI: ACPI bus type pnp unregistered
[   16.504168] initcall 0xc0c0e220: pnpacpi_init+0x0/0x90() returned 0.
[   16.510457] initcall 0xc0c0e220 ran for 22 msecs: pnpacpi_init+0x0/0x90()
[   16.517216] Calling initcall 0xc0c0eea0: misc_init+0x0/0x80()
[   16.522966] initcall 0xc0c0eea0: misc_init+0x0/0x80() returned 0.
[   16.529001] initcall 0xc0c0eea0 ran for 0 msecs: misc_init+0x0/0x80()
[   16.535416] Calling initcall 0xc03dfad0: cn_init+0x0/0xd0()
[   16.540996] initcall 0xc03dfad0: cn_init+0x0/0xd0() returned 0.
[   16.546853] initcall 0xc03dfad0 ran for 0 msecs: cn_init+0x0/0xd0()
[   16.553093] Calling initcall 0xc0c11aa0: tifm_init+0x0/0x70()
[   16.558878] initcall 0xc0c11aa0: tifm_init+0x0/0x70() returned 0.
[   16.564879] initcall 0xc0c11aa0 ran for 0 msecs: tifm_init+0x0/0x70()
[   16.571293] Calling initcall 0xc0c12fe0: phy_init+0x0/0x30()
[   16.576982] initcall 0xc0c12fe0: phy_init+0x0/0x30() returned 0.
[   16.582905] initcall 0xc0c12fe0 ran for 3 msecs: phy_init+0x0/0x30()
[   16.589231] Calling initcall 0xc0c18f60: init_dvbdev+0x0/0xd0()
[   16.595150] initcall 0xc0c18f60: init_dvbdev+0x0/0xd0() returned 0.
[   16.601369] initcall 0xc0c18f60 ran for 0 msecs: init_dvbdev+0x0/0xd0()
[   16.607950] Calling initcall 0xc0c193a0: init_scsi+0x0/0x90()
[   16.613804] SCSI subsystem initialized
[   16.617406] initcall 0xc0c193a0: init_scsi+0x0/0x90() returned 0.
[   16.623471] initcall 0xc0c193a0 ran for 3 msecs: init_scsi+0x0/0x90()
[   16.629883] Calling initcall 0xc0c21470: ata_init+0x0/0x80()
[   16.635552] libata version 3.00 loaded.
[   16.639331] initcall 0xc0c21470: ata_init+0x0/0x80() returned 0.
[   16.645310] initcall 0xc0c21470 ran for 3 msecs: ata_init+0x0/0x80()
[   16.651637] Calling initcall 0xc0c22140: init_pcmcia_cs+0x0/0x30()
[   16.657814] initcall 0xc0c22140: init_pcmcia_cs+0x0/0x30() returned 0.
[   16.664289] initcall 0xc0c22140 ran for 0 msecs: init_pcmcia_cs+0x0/0x30()
[   16.671136] Calling initcall 0xc0c224c0: usb_init+0x0/0x100()
[   16.676946] usbcore: registered new interface driver usbfs
[   16.682374] usbcore: registered new interface driver hub
[   16.687647] usbcore: registered new device driver usb
[   16.692635] initcall 0xc0c224c0: usb_init+0x0/0x100() returned 0.
[   16.698693] initcall 0xc0c224c0 ran for 12 msecs: usb_init+0x0/0x100()
[   16.705193] Calling initcall 0xc0c23f60: serio_init+0x0/0xb0()
[   16.711036] initcall 0xc0c23f60: serio_init+0x0/0xb0() returned 0.
[   16.717159] initcall 0xc0c23f60 ran for 0 msecs: serio_init+0x0/0xb0()
[   16.723652] Calling initcall 0xc0c24420: gameport_init+0x0/0xb0()
[   16.729755] initcall 0xc0c24420: gameport_init+0x0/0xb0() returned 0.
[   16.736130] initcall 0xc0c24420 ran for 0 msecs: gameport_init+0x0/0xb0()
[   16.742890] Calling initcall 0xc0c24820: input_init+0x0/0x100()
[   16.748814] initcall 0xc0c24820: input_init+0x0/0x100() returned 0.
[   16.755022] initcall 0xc0c24820 ran for 0 msecs: input_init+0x0/0x100()
[   16.761610] Calling initcall 0xc0c24e50: power_supply_class_init+0x0/0x30()
[   16.768566] initcall 0xc0c24e50: power_supply_class_init+0x0/0x30() returned 0.
[   16.775821] initcall 0xc0c24e50 ran for 0 msecs: power_supply_class_init+0x0/0x30()
[   16.783447] Calling initcall 0xc0c24e80: hwmon_init+0x0/0x40()
[   16.789277] initcall 0xc0c24e80: hwmon_init+0x0/0x40() returned 0.
[   16.795406] initcall 0xc0c24e80 ran for 0 msecs: hwmon_init+0x0/0x40()
[   16.801907] Calling initcall 0xc0c27390: leds_init+0x0/0x20()
[   16.807650] initcall 0xc0c27390: leds_init+0x0/0x20() returned 0.
[   16.813696] initcall 0xc0c27390 ran for 0 msecs: leds_init+0x0/0x20()
[   16.820104] Calling initcall 0xc0c29f00: pci_acpi_init+0x0/0xb0()
[   16.826171] PCI: Using ACPI for IRQ routing
[   16.830335] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   16.838564] initcall 0xc0c29f00: pci_acpi_init+0x0/0xb0() returned 0.
[   16.844977] initcall 0xc0c29f00 ran for 6 msecs: pci_acpi_init+0x0/0xb0()
[   16.851737] Calling initcall 0xc0c29fb0: pci_legacy_init+0x0/0x100()
[   16.858062] initcall 0xc0c29fb0: pci_legacy_init+0x0/0x100() returned 0.
[   16.864736] initcall 0xc0c29fb0 ran for 0 msecs: pci_legacy_init+0x0/0x100()
[   16.871756] Calling initcall 0xc0c2a5d0: pcibios_irq_init+0x0/0x510()
[   16.878168] initcall 0xc0c2a5d0: pcibios_irq_init+0x0/0x510() returned 0.
[   16.884928] initcall 0xc0c2a5d0 ran for 0 msecs: pcibios_irq_init+0x0/0x510()
[   16.892035] Calling initcall 0xc0c2aae0: pcibios_init+0x0/0xa0()
[   16.951462] initcall 0xc0c2aae0: pcibios_init+0x0/0xa0() returned 0.
[   16.957655] initcall 0xc0c2aae0 ran for 50 msecs: pcibios_init+0x0/0xa0()
[   16.964414] Calling initcall 0xc0c2ac40: proto_init+0x0/0x30()
[   16.970221] initcall 0xc0c2ac40: proto_init+0x0/0x30() returned 0.
[   16.976372] initcall 0xc0c2ac40 ran for 0 msecs: proto_init+0x0/0x30()
[   16.982872] Calling initcall 0xc0c2b030: net_dev_init+0x0/0x120()
[   16.988973] initcall 0xc0c2b030: net_dev_init+0x0/0x120() returned 0.
[   16.995352] initcall 0xc0c2b030 ran for 0 msecs: net_dev_init+0x0/0x120()
[   17.002113] Calling initcall 0xc0c2b1a0: neigh_init+0x0/0x80()
[   17.007917] initcall 0xc0c2b1a0: neigh_init+0x0/0x80() returned 0.
[   17.014071] initcall 0xc0c2b1a0 ran for 0 msecs: neigh_init+0x0/0x80()
[   17.020571] Calling initcall 0xc0c2b4e0: fib_rules_init+0x0/0x60()
[   17.026723] initcall 0xc0c2b4e0: fib_rules_init+0x0/0x60() returned 0.
[   17.033222] initcall 0xc0c2b4e0 ran for 0 msecs: fib_rules_init+0x0/0x60()
[   17.040068] Calling initcall 0xc0c2b950: pktsched_init+0x0/0xd0()
[   17.046137] initcall 0xc0c2b950: pktsched_init+0x0/0xd0() returned 0.
[   17.052548] initcall 0xc0c2b950 ran for 0 msecs: pktsched_init+0x0/0xd0()
[   17.059307] Calling initcall 0xc0c2ba30: tc_filter_init+0x0/0x60()
[   17.065461] initcall 0xc0c2ba30: tc_filter_init+0x0/0x60() returned 0.
[   17.071960] initcall 0xc0c2ba30 ran for 0 msecs: tc_filter_init+0x0/0x60()
[   17.078807] Calling initcall 0xc0c2ba90: tc_action_init+0x0/0x60()
[   17.084959] initcall 0xc0c2ba90: tc_action_init+0x0/0x60() returned 0.
[   17.091458] initcall 0xc0c2ba90 ran for 0 msecs: tc_action_init+0x0/0x60()
[   17.098305] Calling initcall 0xc0c2bee0: genl_init+0x0/0xd0()
[   17.116881] initcall 0xc0c2bee0: genl_init+0x0/0xd0() returned 0.
[   17.123220] initcall 0xc0c2bee0 ran for 12 msecs: genl_init+0x0/0xd0()
[   17.129719] Calling initcall 0xc0c2d720: cipso_v4_init+0x0/0x60()
[   17.135787] initcall 0xc0c2d720: cipso_v4_init+0x0/0x60() returned 0.
[   17.142199] initcall 0xc0c2d720 ran for 0 msecs: cipso_v4_init+0x0/0x60()
[   17.148959] Calling initcall 0xc0c2e5e0: irda_init+0x0/0x90()
[   17.154688] NET: Registered protocol family 23
[   17.159125] initcall 0xc0c2e5e0: irda_init+0x0/0x90() returned 0.
[   17.165164] initcall 0xc0c2e5e0 ran for 3 msecs: irda_init+0x0/0x90()
[   17.171578] Calling initcall 0xc0c2e960: atm_init+0x0/0xc0()
[   17.177210] NET: Registered protocol family 8
[   17.181544] NET: Registered protocol family 20
[   17.185995] initcall 0xc0c2e960: atm_init+0x0/0xc0() returned 0.
[   17.191942] initcall 0xc0c2e960 ran for 6 msecs: atm_init+0x0/0xc0()
[   17.198270] Calling initcall 0xc0c2f860: wireless_nlevent_init+0x0/0x30()
[   17.205028] initcall 0xc0c2f860: wireless_nlevent_init+0x0/0x30() returned 0.
[   17.212134] initcall 0xc0c2f860 ran for 0 msecs: wireless_nlevent_init+0x0/0x30()
[   17.219588] Calling initcall 0xc0849bd0: cfg80211_init+0x0/0x40()
[   17.225679] initcall 0xc0849bd0: cfg80211_init+0x0/0x40() returned 0.
[   17.232066] initcall 0xc0849bd0 ran for 0 msecs: cfg80211_init+0x0/0x40()
[   17.238827] Calling initcall 0xc0c2f890: ieee80211_init+0x0/0x60()
[   17.244980] initcall 0xc0c2f890: ieee80211_init+0x0/0x60() returned 0.
[   17.251478] initcall 0xc0c2f890 ran for 0 msecs: ieee80211_init+0x0/0x60()
[   17.258326] Calling initcall 0xc0c2f9d0: netlbl_init+0x0/0x80()
[   17.264218] NetLabel: Initializing
[   17.267599] NetLabel:  domain hash size = 128
[   17.271931] NetLabel:  protocols = UNLABELED CIPSOv4
[   17.276888] NetLabel:  unlabeled traffic allowed by default
[   17.282419] initcall 0xc0c2f9d0: netlbl_init+0x0/0x80() returned 0.
[   17.288656] initcall 0xc0c2f9d0 ran for 12 msecs: netlbl_init+0x0/0x80()
[   17.295330] Calling initcall 0xc0c2fa50: rfkill_init+0x0/0x50()
[   17.301251] initcall 0xc0c2fa50: rfkill_init+0x0/0x50() returned 0.
[   17.307465] initcall 0xc0c2fa50 ran for 0 msecs: rfkill_init+0x0/0x50()
[   17.314049] Calling initcall 0xc0c04260: clocksource_done_booting+0x0/0x10()
[   17.321068] initcall 0xc0c04260: clocksource_done_booting+0x0/0x10() returned 0.
[   17.328433] initcall 0xc0c04260 ran for 0 msecs: clocksource_done_booting+0x0/0x10()
[   17.336147] Calling initcall 0xc0c07e10: init_pipe_fs+0x0/0x50()
[   17.342133] initcall 0xc0c07e10: init_pipe_fs+0x0/0x50() returned 0.
[   17.348452] initcall 0xc0c07e10 ran for 0 msecs: init_pipe_fs+0x0/0x50()
[   17.355126] Calling initcall 0xc0c08740: eventpoll_init+0x0/0x90()
[   17.361281] initcall 0xc0c08740: eventpoll_init+0x0/0x90() returned 0.
[   17.367778] initcall 0xc0c08740 ran for 0 msecs: eventpoll_init+0x0/0x90()
[   17.374625] Calling initcall 0xc0c087d0: anon_inode_init+0x0/0xf0()
[   17.380867] initcall 0xc0c087d0: anon_inode_init+0x0/0xf0() returned 0.
[   17.387451] initcall 0xc0c087d0 ran for 0 msecs: anon_inode_init+0x0/0xf0()
[   17.394384] Calling initcall 0xc0c0df88: acpi_event_init+0x0/0x6b()
[   17.413507] initcall 0xc0c0df88: acpi_event_init+0x0/0x6b() returned 0.
[   17.419957] initcall 0xc0c0df88 ran for 12 msecs: acpi_event_init+0x0/0x6b()
[   17.426977] Calling initcall 0xc0c0e120: pnp_system_init+0x0/0x10()
[   17.433247] system 00:01: ioport range 0x4000-0x407f has been reserved
[   17.439718] system 00:01: ioport range 0x4080-0x40ff has been reserved
[   17.446217] system 00:01: ioport range 0x4400-0x447f has been reserved
[   17.452717] system 00:01: ioport range 0x4480-0x44ff has been reserved
[   17.459216] system 00:01: ioport range 0x4800-0x487f has been reserved
[   17.465715] system 00:01: ioport range 0x4880-0x48ff has been reserved
[   17.472218] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[   17.478542] system 00:02: ioport range 0x800-0x805 has been reserved
[   17.484868] system 00:02: ioport range 0x290-0x297 has been reserved
[   17.491200] system 00:0e: iomem range 0xe0000000-0xefffffff could not be reserved
[   17.498649] system 00:0f: iomem range 0xf0000-0xf3fff could not be reserved
[   17.505579] system 00:0f: iomem range 0xf4000-0xf7fff could not be reserved
[   17.512512] system 00:0f: iomem range 0xf8000-0xfbfff could not be reserved
[   17.519445] system 00:0f: iomem range 0xfc000-0xfffff could not be reserved
[   17.526378] system 00:0f: iomem range 0x3fff0000-0x3fffffff could not be reserved
[   17.533831] system 00:0f: iomem range 0xffff0000-0xffffffff could not be reserved
[   17.541284] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[   17.547870] system 00:0f: iomem range 0x100000-0x3ffeffff could not be reserved
[   17.555150] system 00:0f: iomem range 0xfec00000-0xfec00fff could not be reserved
[   17.562603] system 00:0f: iomem range 0xfee00000-0xfeefffff could not be reserved
[   17.570056] system 00:0f: iomem range 0xfefff000-0xfeffffff could not be reserved
[   17.577509] system 00:0f: iomem range 0xfff80000-0xfff80fff could not be reserved
[   17.584963] initcall 0xc0c0e120: pnp_system_init+0x0/0x10() returned 0.
[   17.591546] initcall 0xc0c0e120 ran for 69 msecs: pnp_system_init+0x0/0x10()
[   17.598567] Calling initcall 0xc0c0e670: chr_dev_init+0x0/0xe0()
[   17.604837] initcall 0xc0c0e670: chr_dev_init+0x0/0xe0() returned 0.
[   17.611031] initcall 0xc0c0e670 ran for 0 msecs: chr_dev_init+0x0/0xe0()
[   17.617701] Calling initcall 0xc0c11520: firmware_class_init+0x0/0x70()
[   17.624312] initcall 0xc0c11520: firmware_class_init+0x0/0x70() returned 0.
[   17.631243] initcall 0xc0c11520 ran for 0 msecs: firmware_class_init+0x0/0x70()
[   17.638500] Calling initcall 0xc0c13290: loopback_init+0x0/0x10()
[   17.644631] initcall 0xc0c13290: loopback_init+0x0/0x10() returned 0.
[   17.650981] initcall 0xc0c13290 ran for 0 msecs: loopback_init+0x0/0x10()
[   17.657739] Calling initcall 0xc0c27360: cpufreq_gov_performance_init+0x0/0x10()
[   17.665104] initcall 0xc0c27360: cpufreq_gov_performance_init+0x0/0x10() returned 0.
[   17.672817] initcall 0xc0c27360 ran for 0 msecs: cpufreq_gov_performance_init+0x0/0x10()
[   17.680876] Calling initcall 0xc0c27380: cpufreq_gov_userspace_init+0x0/0x10()
[   17.688070] initcall 0xc0c27380: cpufreq_gov_userspace_init+0x0/0x10() returned 0.
[   17.695609] initcall 0xc0c27380 ran for 0 msecs: cpufreq_gov_userspace_init+0x0/0x10()
[   17.703496] Calling initcall 0xc0c288f0: init_acpi_pm_clocksource+0x0/0x1b0()
[   17.740613] initcall 0xc0c288f0: init_acpi_pm_clocksource+0x0/0x1b0()<6>Time: acpi_pm clocksource has been installed.
[   17.751066] Switched to NOHz mode on CPU #0
[   17.750991] Switched to NOHz mode on CPU #1
[   17.759381]  returned 0.
[   17.761893] initcall 0xc0c288f0 ran for 28 msecs: init_acpi_pm_clocksource+0x0/0x1b0()
[   17.769779] Calling initcall 0xc0c28bf0: ssb_modinit+0x0/0x80()
[   17.775738] initcall 0xc0c28bf0: ssb_modinit+0x0/0x80() returned 0.
[   17.781905] initcall 0xc0c28bf0 ran for 0 msecs: ssb_modinit+0x0/0x80()
[   17.788499] Calling initcall 0xc0c28c80: pcibios_assign_resources+0x0/0x80()
[   17.795523] PCI: Bridge: 0000:00:09.0
[   17.799157]   IO window: c000-cfff
[   17.802537]   MEM window: da000000-da0fffff
[   17.806697]   PREFETCH window: disabled.
[   17.810598] PCI: Bridge: 0000:00:0b.0
[   17.814236]   IO window: disabled.
[   17.817617]   MEM window: disabled.
[   17.821082]   PREFETCH window: disabled.
[   17.824982] PCI: Bridge: 0000:00:0c.0
[   17.828621]   IO window: disabled.
[   17.832002]   MEM window: disabled.
[   17.835468]   PREFETCH window: disabled.
[   17.839368] PCI: Bridge: 0000:00:0d.0
[   17.843007]   IO window: disabled.
[   17.846387]   MEM window: disabled.
[   17.849854]   PREFETCH window: disabled.
[   17.853757]   got res [d8000000:d801ffff] bus [d8000000:d801ffff] flags 2200 for BAR 6 of 0000:01:00.0
[   17.863026] PCI: Bridge: 0000:00:0e.0
[   17.866666]   IO window: b000-bfff
[   17.870047]   MEM window: d8000000-d9ffffff
[   17.874206]   PREFETCH window: d0000000-d7ffffff
[   17.878803] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   17.885045] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   17.891281] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   17.897521] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   17.903761] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   17.909999] initcall 0xc0c28c80: pcibios_assign_resources+0x0/0x80() returned 0.
[   17.917363] initcall 0xc0c28c80 ran for 109 msecs: pcibios_assign_resources+0x0/0x80()
[   17.925249] Calling initcall 0xc0c2cd00: inet_init+0x0/0x310()
[   17.931058] NET: Registered protocol family 2
[   17.970400] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   17.977664] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[   17.985570] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   17.992364] TCP: Hash tables configured (established 131072 bind 65536)
[   17.998824] TCP reno registered
[   18.010318] initcall 0xc0c2cd00: inet_init+0x0/0x310() returned 0.
[   18.016342] initcall 0xc0c2cd00 ran for 75 msecs: inet_init+0x0/0x310()
[   18.022928] Calling initcall 0xc0bf0860: populate_rootfs+0x0/0x150()
[   18.029355] initcall 0xc0bf0860: populate_rootfs+0x0/0x150() returned 0.
[   18.035927] initcall 0xc0bf0860 ran for 0 msecs: populate_rootfs+0x0/0x150()
[   18.042946] Calling initcall 0xc0bf2420: i8259A_init_sysfs+0x0/0x20()
[   18.049458] initcall 0xc0bf2420: i8259A_init_sysfs+0x0/0x20() returned 0.
[   18.056119] initcall 0xc0bf2420 ran for 0 msecs: i8259A_init_sysfs+0x0/0x20()
[   18.063225] Calling initcall 0xc0bf2560: sbf_init+0x0/0xd0()
[   18.068861] initcall 0xc0bf2560: sbf_init+0x0/0xd0() returned 0.
[   18.074837] initcall 0xc0bf2560 ran for 0 msecs: sbf_init+0x0/0xd0()
[   18.081170] Calling initcall 0xc0bf3810: i8237A_init_sysfs+0x0/0x20()
[   18.087635] initcall 0xc0bf3810: i8237A_init_sysfs+0x0/0x20() returned 0.
[   18.094348] initcall 0xc0bf3810 ran for 0 msecs: i8237A_init_sysfs+0x0/0x20()
[   18.101448] Calling initcall 0xc0bf4130: cache_sysfs_init+0x0/0x3f0()
[   18.108104] initcall 0xc0bf4130: cache_sysfs_init+0x0/0x3f0() returned 0.
[   18.114736] initcall 0xc0bf4130 ran for 0 msecs: cache_sysfs_init+0x0/0x3f0()
[   18.121846] Calling initcall 0xc0bf98a0: longrun_init+0x0/0x30()
[   18.127825] initcall 0xc0bf98a0: longrun_init+0x0/0x30() returned -19.
[   18.134325] initcall 0xc0bf98a0 ran for 0 msecs: longrun_init+0x0/0x30()
[   18.140998] Calling initcall 0xc0bf98d0: cpufreq_gx_init+0x0/0x140()
[   18.147323] initcall 0xc0bf98d0: cpufreq_gx_init+0x0/0x140() returned -19.
[   18.154170] initcall 0xc0bf98d0 ran for 0 msecs: cpufreq_gx_init+0x0/0x140()
[   18.161191] Calling initcall 0xc0bf9ae0: nforce2_init+0x0/0x80()
[   18.167586] cpufreq: No nForce2 chipset.
[   18.171487] initcall 0xc0bf9ae0: nforce2_init+0x0/0x80() returned -19.
[   18.177985] initcall 0xc0bf9ae0 ran for 3 msecs: nforce2_init+0x0/0x80()
[   18.184658] Calling initcall 0xc0bfac00: msr_init+0x0/0x110()
[   18.190503] initcall 0xc0bfac00: msr_init+0x0/0x110() returned 0.
[   18.196440] initcall 0xc0bfac00 ran for 0 msecs: msr_init+0x0/0x110()
[   18.202852] Calling initcall 0xc0bfd480: init_lapic_sysfs+0x0/0x30()
[   18.209249] initcall 0xc0bfd480: init_lapic_sysfs+0x0/0x30() returned 0.
[   18.215852] initcall 0xc0bfd480 ran for 0 msecs: init_lapic_sysfs+0x0/0x30()
[   18.222871] Calling initcall 0xc0bffc10: ioapic_init_sysfs+0x0/0xe0()
[   18.229354] initcall 0xc0bffc10: ioapic_init_sysfs+0x0/0xe0() returned 0.
[   18.236044] initcall 0xc0bffc10 ran for 0 msecs: ioapic_init_sysfs+0x0/0xe0()
[   18.243150] Calling initcall 0xc0c01260: add_pcspkr+0x0/0x60()
[   18.249002] initcall 0xc0c01260: add_pcspkr+0x0/0x60() returned 0.
[   18.255110] initcall 0xc0c01260 ran for 0 msecs: add_pcspkr+0x0/0x60()
[   18.261613] Calling initcall 0xc0c012c0: scx200_init+0x0/0x30()
[   18.267503] scx200: NatSemi SCx200 Driver
[   18.271538] initcall 0xc0c012c0: scx200_init+0x0/0x30() returned 0.
[   18.277733] initcall 0xc0c012c0 ran for 3 msecs: scx200_init+0x0/0x30()
[   18.284319] Calling initcall 0xc0c01e40: aes_init+0x0/0x340()
[   18.290052] initcall 0xc0c01e40: aes_init+0x0/0x340() returned 0.
[   18.296100] initcall 0xc0c01e40 ran for 0 msecs: aes_init+0x0/0x340()
[   18.302513] Calling initcall 0xc0c02560: init_sched_debug_procfs+0x0/0x30()
[   18.309452] initcall 0xc0c02560: init_sched_debug_procfs+0x0/0x30() returned 0.
[   18.316726] initcall 0xc0c02560 ran for 0 msecs: init_sched_debug_procfs+0x0/0x30()
[   18.324356] Calling initcall 0xc0c032b0: create_proc_profile+0x0/0x1a0()
[   18.331038] initcall 0xc0c032b0: create_proc_profile+0x0/0x1a0() returned 0.
[   18.338049] initcall 0xc0c032b0 ran for 0 msecs: create_proc_profile+0x0/0x1a0()
[   18.345414] Calling initcall 0xc0c035d0: ioresources_init+0x0/0x40()
[   18.351740] initcall 0xc0c035d0: ioresources_init+0x0/0x40() returned 0.
[   18.358409] initcall 0xc0c035d0 ran for 0 msecs: ioresources_init+0x0/0x40()
[   18.365433] Calling initcall 0xc0c038a0: uid_cache_init+0x0/0x80()
[   18.371590] initcall 0xc0c038a0: uid_cache_init+0x0/0x80() returned 0.
[   18.378081] initcall 0xc0c038a0 ran for 0 msecs: uid_cache_init+0x0/0x80()
[   18.384933] Calling initcall 0xc0c03f00: init_posix_timers+0x0/0x90()
[   18.391346] initcall 0xc0c03f00: init_posix_timers+0x0/0x90() returned 0.
[   18.398101] initcall 0xc0c03f00 ran for 0 msecs: init_posix_timers+0x0/0x90()
[   18.405211] Calling initcall 0xc0c03f90: init_posix_cpu_timers+0x0/0xa0()
[   18.411970] initcall 0xc0c03f90: init_posix_cpu_timers+0x0/0xa0() returned 0.
[   18.419072] initcall 0xc0c03f90 ran for 0 msecs: init_posix_cpu_timers+0x0/0xa0()
[   18.426525] Calling initcall 0xc0c04080: latency_init+0x0/0x20()
[   18.432508] initcall 0xc0c04080: latency_init+0x0/0x20() returned 0.
[   18.438831] initcall 0xc0c04080 ran for 0 msecs: latency_init+0x0/0x20()
[   18.445508] Calling initcall 0xc0c040a0: nsproxy_cache_init+0x0/0x40()
[   18.452007] initcall 0xc0c040a0: nsproxy_cache_init+0x0/0x40() returned 0.
[   18.458850] initcall 0xc0c040a0 ran for 0 msecs: nsproxy_cache_init+0x0/0x40()
[   18.466047] Calling initcall 0xc0c040e0: timekeeping_init_device+0x0/0x20()
[   18.473045] initcall 0xc0c040e0: timekeeping_init_device+0x0/0x20() returned 0.
[   18.480260] initcall 0xc0c040e0 ran for 0 msecs: timekeeping_init_device+0x0/0x20()
[   18.487885] Calling initcall 0xc0c04270: init_clocksource_sysfs+0x0/0x40()
[   18.494796] initcall 0xc0c04270: init_clocksource_sysfs+0x0/0x40() returned 0.
[   18.501921] initcall 0xc0c04270 ran for 0 msecs: init_clocksource_sysfs+0x0/0x40()
[   18.509464] Calling initcall 0xc0c04360: init_timer_list_procfs+0x0/0x30()
[   18.516310] initcall 0xc0c04360: init_timer_list_procfs+0x0/0x30() returned 0.
[   18.523499] initcall 0xc0c04360 ran for 0 msecs: init_timer_list_procfs+0x0/0x30()
[   18.531043] Calling initcall 0xc0c043f0: init+0x0/0xe0()
[   18.536347] initcall 0xc0c043f0: init+0x0/0xe0() returned 0.
[   18.541958] initcall 0xc0c043f0 ran for 0 msecs: init+0x0/0xe0()
[   18.547942] Calling initcall 0xc014a2a0: init_rttest+0x0/0x110()
[   18.554413] Initializing RT-Tester: OK
[   18.558014] initcall 0xc014a2a0: init_rttest+0x0/0x110() returned 0.
[   18.564338] initcall 0xc014a2a0 ran for 3 msecs: init_rttest+0x0/0x110()
[   18.571011] Calling initcall 0xc0c044d0: proc_dma_init+0x0/0x20()
[   18.577076] initcall 0xc0c044d0: proc_dma_init+0x0/0x20() returned 0.
[   18.583486] initcall 0xc0c044d0 ran for 0 msecs: proc_dma_init+0x0/0x20()
[   18.590250] Calling initcall 0xc0c04730: kallsyms_init+0x0/0x20()
[   18.596315] initcall 0xc0c04730: kallsyms_init+0x0/0x20() returned 0.
[   18.602724] initcall 0xc0c04730 ran for 0 msecs: kallsyms_init+0x0/0x20()
[   18.609485] Calling initcall 0xc0c047b0: crash_save_vmcoreinfo_init+0x0/0x400()
[   18.616778] initcall 0xc0c047b0: crash_save_vmcoreinfo_init+0x0/0x400() returned 0.
[   18.624395] initcall 0xc0c047b0 ran for 0 msecs: crash_save_vmcoreinfo_init+0x0/0x400()
[   18.632367] Calling initcall 0xc0c04770: crash_notes_memory_init+0x0/0x40()
[   18.639299] initcall 0xc0c04770: crash_notes_memory_init+0x0/0x40() returned 0.
[   18.646576] initcall 0xc0c04770 ran for 0 msecs: crash_notes_memory_init+0x0/0x40()
[   18.654205] Calling initcall 0xc0c05150: ikconfig_init+0x0/0x40()
[   18.660275] initcall 0xc0c05150: ikconfig_init+0x0/0x40() returned 0.
[   18.666681] initcall 0xc0c05150 ran for 0 msecs: ikconfig_init+0x0/0x40()
[   18.673441] Calling initcall 0xc0c05200: audit_init+0x0/0x130()
[   18.679335] audit: initializing netlink socket (disabled)
[   18.684725] audit(1196549257.236:1): initialized
[   18.689306] initcall 0xc0c05200: audit_init+0x0/0x130() returned 0.
[   18.695539] initcall 0xc0c05200 ran for 9 msecs: audit_init+0x0/0x130()
[   18.702129] Calling initcall 0xc0c053b0: audit_tree_init+0x0/0x40()
[   18.708368] initcall 0xc0c053b0: audit_tree_init+0x0/0x40() returned 0.
[   18.714951] initcall 0xc0c053b0 ran for 0 msecs: audit_tree_init+0x0/0x40()
[   18.721888] Calling initcall 0xc0c054a0: relay_init+0x0/0x10()
[   18.727693] initcall 0xc0c054a0: relay_init+0x0/0x10() returned 0.
[   18.733848] initcall 0xc0c054a0 ran for 0 msecs: relay_init+0x0/0x10()
[   18.740346] Calling initcall 0xc0c054b0: utsname_sysctl_init+0x0/0x10()
[   18.746949] initcall 0xc0c054b0: utsname_sysctl_init+0x0/0x10() returned 0.
[   18.753866] initcall 0xc0c054b0 ran for 0 msecs: utsname_sysctl_init+0x0/0x10()
[   18.761146] Calling initcall 0xc0c06680: init_per_zone_pages_min+0x0/0x60()
[   18.768118] initcall 0xc0c06680: init_per_zone_pages_min+0x0/0x60() returned 0.
[   18.775353] initcall 0xc0c06680 ran for 0 msecs: init_per_zone_pages_min+0x0/0x60()
[   18.782984] Calling initcall 0xc0c074d0: pdflush_init+0x0/0x10()
[   18.789007] initcall 0xc0c074d0: pdflush_init+0x0/0x10() returned 0.
[   18.795286] initcall 0xc0c074d0 ran for 0 msecs: pdflush_init+0x0/0x10()
[   18.801962] Calling initcall 0xc0c07510: kswapd_init+0x0/0x10()
[   18.807883] initcall 0xc0c07510: kswapd_init+0x0/0x10() returned 0.
[   18.814096] initcall 0xc0c07510 ran for 0 msecs: kswapd_init+0x0/0x10()
[   18.820682] Calling initcall 0xc0c07570: setup_vmstat+0x0/0x40()
[   18.826662] initcall 0xc0c07570: setup_vmstat+0x0/0x40() returned 0.
[   18.832984] initcall 0xc0c07570 ran for 0 msecs: setup_vmstat+0x0/0x40()
[   18.839656] Calling initcall 0xc0c07740: init_emergency_pool+0x0/0x70()
[   18.846312] highmem bounce pool size: 64 pages
[   18.850669] initcall 0xc0c07740: init_emergency_pool+0x0/0x70() returned 0.
[   18.857599] initcall 0xc0c07740 ran for 4 msecs: init_emergency_pool+0x0/0x70()
[   18.864879] Calling initcall 0xc0c077b0: init_tmpfs+0x0/0xd0()
[   18.870696] initcall 0xc0c077b0: init_tmpfs+0x0/0xd0() returned 0.
[   18.876834] initcall 0xc0c077b0 ran for 0 msecs: init_tmpfs+0x0/0xd0()
[   18.883334] Calling initcall 0xc0c079e0: slab_sysfs_init+0x0/0xd0()
[   18.891813] initcall 0xc0c079e0: slab_sysfs_init+0x0/0xd0() returned 0.
[   18.898265] initcall 0xc0c079e0 ran for 2 msecs: slab_sysfs_init+0x0/0xd0()
[   18.905202] Calling initcall 0xc0c07e60: fasync_init+0x0/0x30()
[   18.911099] initcall 0xc0c07e60: fasync_init+0x0/0x30() returned 0.
[   18.917335] initcall 0xc0c07e60 ran for 0 msecs: fasync_init+0x0/0x30()
[   18.923921] Calling initcall 0xc0c084e0: aio_setup+0x0/0x80()
[   18.929693] initcall 0xc0c084e0: aio_setup+0x0/0x80() returned 0.
[   18.935703] initcall 0xc0c084e0 ran for 0 msecs: aio_setup+0x0/0x80()
[   18.942116] Calling initcall 0xc0c08730: inotify_setup+0x0/0x10()
[   18.948186] initcall 0xc0c08730: inotify_setup+0x0/0x10() returned 0.
[   18.954599] initcall 0xc0c08730 ran for 0 msecs: inotify_setup+0x0/0x10()
[   18.961360] Calling initcall 0xc0c08930: init_mbcache+0x0/0x10()
[   18.967338] initcall 0xc0c08930: init_mbcache+0x0/0x10() returned 0.
[   18.973665] initcall 0xc0c08930 ran for 0 msecs: init_mbcache+0x0/0x10()
[   18.980338] Calling initcall 0xc0c08dd0: configfs_init+0x0/0xd0()
[   18.986497] initcall 0xc0c08dd0: configfs_init+0x0/0xd0() returned 0.
[   18.992812] initcall 0xc0c08dd0 ran for 0 msecs: configfs_init+0x0/0xd0()
[   18.999573] Calling initcall 0xc0c08ea0: init_devpts_fs+0x0/0x30()
[   19.005734] initcall 0xc0c08ea0: init_devpts_fs+0x0/0x30() returned 0.
[   19.012225] initcall 0xc0c08ea0 ran for 0 msecs: init_devpts_fs+0x0/0x30()
[   19.019076] Calling initcall 0xc0c08ed0: init_dlm+0x0/0x90()
[   19.024854] DLM (built Dec  1 2007 21:34:35) installed
[   19.029842] initcall 0xc0c08ed0: init_dlm+0x0/0x90() returned 0.
[   19.035814] initcall 0xc0c08ed0 ran for 4 msecs: init_dlm+0x0/0x90()
[   19.042140] Calling initcall 0xc0c08f60: init_reiserfs_fs+0x0/0x80()
[   19.048524] initcall 0xc0c08f60: init_reiserfs_fs+0x0/0x80() returned 0.
[   19.055139] initcall 0xc0c08f60 ran for 0 msecs: init_reiserfs_fs+0x0/0x80()
[   19.062164] Calling initcall 0xc0c08fe0: init_ext3_fs+0x0/0x70()
[   19.068249] initcall 0xc0c08fe0: init_ext3_fs+0x0/0x70() returned 0.
[   19.074469] initcall 0xc0c08fe0 ran for 0 msecs: init_ext3_fs+0x0/0x70()
[   19.081142] Calling initcall 0xc0c09090: init_ext4_fs+0x0/0x70()
[   19.087179] initcall 0xc0c09090: init_ext4_fs+0x0/0x70() returned 0.
[   19.093444] initcall 0xc0c09090 ran for 0 msecs: init_ext4_fs+0x0/0x70()
[   19.100117] Calling initcall 0xc0c091c0: journal_init+0x0/0xb0()
[   19.106218] initcall 0xc0c091c0: journal_init+0x0/0xb0() returned 0.
[   19.112423] initcall 0xc0c091c0 ran for 0 msecs: journal_init+0x0/0xb0()
[   19.119095] Calling initcall 0xc0c092f0: journal_init+0x0/0xd0()
[   19.125093] initcall 0xc0c092f0: journal_init+0x0/0xd0() returned 0.
[   19.131401] initcall 0xc0c092f0 ran for 0 msecs: journal_init+0x0/0xd0()
[   19.138078] Calling initcall 0xc0c093c0: init_ext2_fs+0x0/0x60()
[   19.144109] initcall 0xc0c093c0: init_ext2_fs+0x0/0x60() returned 0.
[   19.150385] initcall 0xc0c093c0 ran for 0 msecs: init_ext2_fs+0x0/0x60()
[   19.157057] Calling initcall 0xc0c09420: init_cramfs_fs+0x0/0x30()
[   19.163218] initcall 0xc0c09420: init_cramfs_fs+0x0/0x30() returned 0.
[   19.169705] initcall 0xc0c09420 ran for 0 msecs: init_cramfs_fs+0x0/0x30()
[   19.176551] Calling initcall 0xc0c09450: init_ramfs_fs+0x0/0x10()
[   19.182622] initcall 0xc0c09450: init_ramfs_fs+0x0/0x10() returned 0.
[   19.189031] initcall 0xc0c09450 ran for 0 msecs: init_ramfs_fs+0x0/0x10()
[   19.195790] Calling initcall 0xc0c094e0: init_fat_fs+0x0/0x50()
[   19.202205] initcall 0xc0c094e0: init_fat_fs+0x0/0x50() returned 0.
[   19.208339] initcall 0xc0c094e0 ran for 0 msecs: init_fat_fs+0x0/0x50()
[   19.214929] Calling initcall 0xc0c09530: init_msdos_fs+0x0/0x10()
[   19.220996] initcall 0xc0c09530: init_msdos_fs+0x0/0x10() returned 0.
[   19.227409] initcall 0xc0c09530 ran for 0 msecs: init_msdos_fs+0x0/0x10()
[   19.234168] Calling initcall 0xc0c09540: init_iso9660_fs+0x0/0x70()
[   19.240462] initcall 0xc0c09540: init_iso9660_fs+0x0/0x70() returned 0.
[   19.246995] initcall 0xc0c09540 ran for 0 msecs: init_iso9660_fs+0x0/0x70()
[   19.253927] Calling initcall 0xc0c095d0: init_hfs_fs+0x0/0x70()
[   19.259874] initcall 0xc0c095d0: init_hfs_fs+0x0/0x70() returned 0.
[   19.266055] initcall 0xc0c095d0 ran for 0 msecs: init_hfs_fs+0x0/0x70()
[   19.272641] Calling initcall 0xc0c09640: init_nfsd+0x0/0xa0()
[   19.278363] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   19.284773] initcall 0xc0c09640: init_nfsd+0x0/0xa0() returned 0.
[   19.290758] initcall 0xc0c09640 ran for 6 msecs: init_nfsd+0x0/0xa0()
[   19.297172] Calling initcall 0xc0c096e0: init_nlm+0x0/0x20()
[   19.302813] initcall 0xc0c096e0: init_nlm+0x0/0x20() returned 0.
[   19.308780] initcall 0xc0c096e0 ran for 0 msecs: init_nlm+0x0/0x20()
[   19.315110] Calling initcall 0xc0c09700: init_nls_cp437+0x0/0x10()
[   19.321262] initcall 0xc0c09700: init_nls_cp437+0x0/0x10() returned 0.
[   19.327763] initcall 0xc0c09700 ran for 0 msecs: init_nls_cp437+0x0/0x10()
[   19.334608] Calling initcall 0xc0c09710: init_nls_cp737+0x0/0x10()
[   19.340761] initcall 0xc0c09710: init_nls_cp737+0x0/0x10() returned 0.
[   19.347262] initcall 0xc0c09710 ran for 0 msecs: init_nls_cp737+0x0/0x10()
[   19.354107] Calling initcall 0xc0c09720: init_nls_cp855+0x0/0x10()
[   19.360263] initcall 0xc0c09720: init_nls_cp855+0x0/0x10() returned 0.
[   19.366756] initcall 0xc0c09720 ran for 0 msecs: init_nls_cp855+0x0/0x10()
[   19.373606] Calling initcall 0xc0c09730: init_nls_cp857+0x0/0x10()
[   19.379758] initcall 0xc0c09730: init_nls_cp857+0x0/0x10() returned 0.
[   19.386255] initcall 0xc0c09730 ran for 0 msecs: init_nls_cp857+0x0/0x10()
[   19.393100] Calling initcall 0xc0c09740: init_nls_cp860+0x0/0x10()
[   19.399256] initcall 0xc0c09740: init_nls_cp860+0x0/0x10() returned 0.
[   19.405753] initcall 0xc0c09740 ran for 0 msecs: init_nls_cp860+0x0/0x10()
[   19.412600] Calling initcall 0xc0c09750: init_nls_cp861+0x0/0x10()
[   19.418755] initcall 0xc0c09750: init_nls_cp861+0x0/0x10() returned 0.
[   19.425252] initcall 0xc0c09750 ran for 0 msecs: init_nls_cp861+0x0/0x10()
[   19.432102] Calling initcall 0xc0c09760: init_nls_cp862+0x0/0x10()
[   19.438254] initcall 0xc0c09760: init_nls_cp862+0x0/0x10() returned 0.
[   19.444751] initcall 0xc0c09760 ran for 0 msecs: init_nls_cp862+0x0/0x10()
[   19.451602] Calling initcall 0xc0c09770: init_nls_cp863+0x0/0x10()
[   19.457753] initcall 0xc0c09770: init_nls_cp863+0x0/0x10() returned 0.
[   19.464254] initcall 0xc0c09770 ran for 0 msecs: init_nls_cp863+0x0/0x10()
[   19.471100] Calling initcall 0xc0c09780: init_nls_cp865+0x0/0x10()
[   19.477252] initcall 0xc0c09780: init_nls_cp865+0x0/0x10() returned 0.
[   19.483752] initcall 0xc0c09780 ran for 0 msecs: init_nls_cp865+0x0/0x10()
[   19.490599] Calling initcall 0xc0c09790: init_nls_cp866+0x0/0x10()
[   19.496751] initcall 0xc0c09790: init_nls_cp866+0x0/0x10() returned 0.
[   19.503247] initcall 0xc0c09790 ran for 0 msecs: init_nls_cp866+0x0/0x10()
[   19.510093] Calling initcall 0xc0c097a0: init_nls_cp869+0x0/0x10()
[   19.516249] initcall 0xc0c097a0: init_nls_cp869+0x0/0x10() returned 0.
[   19.522746] initcall 0xc0c097a0 ran for 0 msecs: init_nls_cp869+0x0/0x10()
[   19.529592] Calling initcall 0xc0c097b0: init_nls_cp874+0x0/0x10()
[   19.535748] initcall 0xc0c097b0: init_nls_cp874+0x0/0x10() returned 0.
[   19.542245] initcall 0xc0c097b0 ran for 0 msecs: init_nls_cp874+0x0/0x10()
[   19.549095] Calling initcall 0xc0c097c0: init_nls_cp932+0x0/0x10()
[   19.555247] initcall 0xc0c097c0: init_nls_cp932+0x0/0x10() returned 0.
[   19.561744] initcall 0xc0c097c0 ran for 0 msecs: init_nls_cp932+0x0/0x10()
[   19.568594] Calling initcall 0xc0c097d0: init_nls_euc_jp+0x0/0x40()
[   19.574833] initcall 0xc0c097d0: init_nls_euc_jp+0x0/0x40() returned 0.
[   19.581416] initcall 0xc0c097d0 ran for 0 msecs: init_nls_euc_jp+0x0/0x40()
[   19.588352] Calling initcall 0xc0c09810: init_nls_cp936+0x0/0x10()
[   19.594505] initcall 0xc0c09810: init_nls_cp936+0x0/0x10() returned 0.
[   19.601005] initcall 0xc0c09810 ran for 0 msecs: init_nls_cp936+0x0/0x10()
[   19.607851] Calling initcall 0xc0c09820: init_nls_iso8859_2+0x0/0x10()
[   19.614350] initcall 0xc0c09820: init_nls_iso8859_2+0x0/0x10() returned 0.
[   19.621198] initcall 0xc0c09820 ran for 0 msecs: init_nls_iso8859_2+0x0/0x10()
[   19.628390] Calling initcall 0xc0c09830: init_nls_iso8859_4+0x0/0x10()
[   19.634888] initcall 0xc0c09830: init_nls_iso8859_4+0x0/0x10() returned 0.
[   19.641732] initcall 0xc0c09830 ran for 0 msecs: init_nls_iso8859_4+0x0/0x10()
[   19.648929] Calling initcall 0xc0c09840: init_nls_iso8859_6+0x0/0x10()
[   19.655427] initcall 0xc0c09840: init_nls_iso8859_6+0x0/0x10() returned 0.
[   19.662271] initcall 0xc0c09840 ran for 0 msecs: init_nls_iso8859_6+0x0/0x10()
[   19.669467] Calling initcall 0xc0c09850: init_nls_iso8859_7+0x0/0x10()
[   19.675966] initcall 0xc0c09850: init_nls_iso8859_7+0x0/0x10() returned 0.
[   19.682809] initcall 0xc0c09850 ran for 0 msecs: init_nls_iso8859_7+0x0/0x10()
[   19.690002] Calling initcall 0xc0c09860: init_nls_iso8859_9+0x0/0x10()
[   19.696505] initcall 0xc0c09860: init_nls_iso8859_9+0x0/0x10() returned 0.
[   19.703348] initcall 0xc0c09860 ran for 0 msecs: init_nls_iso8859_9+0x0/0x10()
[   19.710545] Calling initcall 0xc0c09870: init_nls_iso8859_13+0x0/0x10()
[   19.717130] initcall 0xc0c09870: init_nls_iso8859_13+0x0/0x10() returned 0.
[   19.724064] initcall 0xc0c09870 ran for 0 msecs: init_nls_iso8859_13+0x0/0x10()
[   19.731344] Calling initcall 0xc0c09880: init_nls_koi8_r+0x0/0x10()
[   19.737582] initcall 0xc0c09880: init_nls_koi8_r+0x0/0x10() returned 0.
[   19.744170] initcall 0xc0c09880 ran for 0 msecs: init_nls_koi8_r+0x0/0x10()
[   19.751103] Calling initcall 0xc0c09890: init_nls_koi8_u+0x0/0x10()
[   19.757341] initcall 0xc0c09890: init_nls_koi8_u+0x0/0x10() returned 0.
[   19.763928] initcall 0xc0c09890 ran for 0 msecs: init_nls_koi8_u+0x0/0x10()
[   19.770862] Calling initcall 0xc0c098a0: init_nls_koi8_ru+0x0/0x40()
[   19.777187] initcall 0xc0c098a0: init_nls_koi8_ru+0x0/0x40() returned 0.
[   19.783860] initcall 0xc0c098a0 ran for 0 msecs: init_nls_koi8_ru+0x0/0x40()
[   19.790880] Calling initcall 0xc0c098e0: init_nls_utf8+0x0/0x30()
[   19.796950] initcall 0xc0c098e0: init_nls_utf8+0x0/0x30() returned 0.
[   19.803355] initcall 0xc0c098e0 ran for 0 msecs: init_nls_utf8+0x0/0x30()
[   19.810114] Calling initcall 0xc0c09950: init_sysv_fs+0x0/0x50()
[   19.816153] initcall 0xc0c09950: init_sysv_fs+0x0/0x50() returned 0.
[   19.822420] initcall 0xc0c09950 ran for 0 msecs: init_sysv_fs+0x0/0x50()
[   19.829093] Calling initcall 0xc0c099a0: init_smb_fs+0x0/0x70()
[   19.835049] initcall 0xc0c099a0: init_smb_fs+0x0/0x70() returned 0.
[   19.841230] initcall 0xc0c099a0 ran for 0 msecs: init_smb_fs+0x0/0x70()
[   19.847816] Calling initcall 0xc0c09a10: init_cifs+0x0/0x500()
[   19.853817] initcall 0xc0c09a10: init_cifs+0x0/0x500() returned 0.
[   19.859841] initcall 0xc0c09a10 ran for 0 msecs: init_cifs+0x0/0x500()
[   19.866340] Calling initcall 0xc0c09f10: init_ncp_fs+0x0/0x60()
[   19.872292] initcall 0xc0c09f10: init_ncp_fs+0x0/0x60() returned 0.
[   19.878472] initcall 0xc0c09f10 ran for 0 msecs: init_ncp_fs+0x0/0x60()
[   19.885063] Calling initcall 0xc0c09f70: init_hpfs_fs+0x0/0x60()
[   19.891094] initcall 0xc0c09f70: init_hpfs_fs+0x0/0x60() returned 0.
[   19.897369] initcall 0xc0c09f70 ran for 0 msecs: init_hpfs_fs+0x0/0x60()
[   19.904042] Calling initcall 0xc0c09fd0: init_ntfs_fs+0x0/0x270()
[   19.910106] NTFS driver 2.1.29 [Flags: R/W DEBUG].
[   19.915005] initcall 0xc0c09fd0: init_ntfs_fs+0x0/0x270() returned 0.
[   19.921288] initcall 0xc0c09fd0 ran for 4 msecs: init_ntfs_fs+0x0/0x270()
[   19.928048] Calling initcall 0xc0c0a240: init_ufs_fs+0x0/0x60()
[   19.933991] initcall 0xc0c0a240: init_ufs_fs+0x0/0x60() returned 0.
[   19.940175] initcall 0xc0c0a240 ran for 0 msecs: init_ufs_fs+0x0/0x60()
[   19.946762] Calling initcall 0xc0c0a2a0: init_efs_fs+0x0/0x70()
[   19.952656] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[   19.957656] initcall 0xc0c0a2a0: init_efs_fs+0x0/0x70() returned 0.
[   19.963839] initcall 0xc0c0a2a0 ran for 4 msecs: init_efs_fs+0x0/0x70()
[   19.970425] Calling initcall 0xc0c0a310: init_romfs_fs+0x0/0x60()
[   19.976541] initcall 0xc0c0a310: init_romfs_fs+0x0/0x60() returned 0.
[   19.982899] initcall 0xc0c0a310 ran for 0 msecs: init_romfs_fs+0x0/0x60()
[   19.989659] Calling initcall 0xc0c0a370: init_qnx4_fs+0x0/0x70()
[   19.995693] QNX4 filesystem 0.2.3 registered.
[   19.999979] initcall 0xc0c0a370: init_qnx4_fs+0x0/0x70() returned 0.
[   20.006298] initcall 0xc0c0a370 ran for 4 msecs: init_qnx4_fs+0x0/0x70()
[   20.012971] Calling initcall 0xc0c0a3e0: init_udf_fs+0x0/0x60()
[   20.018919] initcall 0xc0c0a3e0: init_udf_fs+0x0/0x60() returned 0.
[   20.025103] initcall 0xc0c0a3e0 ran for 0 msecs: init_udf_fs+0x0/0x60()
[   20.031694] Calling initcall 0xc0c0a650: init_befs_fs+0x0/0x80()
[   20.037671] BeFS version: 0.9.3
[   20.040856] initcall 0xc0c0a650: init_befs_fs+0x0/0x80() returned 0.
[   20.047120] initcall 0xc0c0a650 ran for 3 msecs: init_befs_fs+0x0/0x80()
[   20.053793] Calling initcall 0xc0c0a6d0: init_mqueue_fs+0x0/0xc0()
[   20.060009] initcall 0xc0c0a6d0: init_mqueue_fs+0x0/0xc0() returned 0.
[   20.066441] initcall 0xc0c0a6d0 ran for 0 msecs: init_mqueue_fs+0x0/0xc0()
[   20.073287] Calling initcall 0xc0c0a8d0: key_proc_init+0x0/0x30()
[   20.079357] initcall 0xc0c0a8d0: key_proc_init+0x0/0x30() returned 0.
[   20.085766] initcall 0xc0c0a8d0 ran for 0 msecs: key_proc_init+0x0/0x30()
[   20.092526] Calling initcall 0xc0c0aa70: selinux_nf_ip_init+0x0/0x40()
[   20.099028] initcall 0xc0c0aa70: selinux_nf_ip_init+0x0/0x40() returned 0.
[   20.105871] initcall 0xc0c0aa70 ran for 0 msecs: selinux_nf_ip_init+0x0/0x40()
[   20.113065] Calling initcall 0xc0c0ac00: init_sel_fs+0x0/0x60()
[   20.118961] initcall 0xc0c0ac00: init_sel_fs+0x0/0x60() returned 0.
[   20.125197] initcall 0xc0c0ac00 ran for 0 msecs: init_sel_fs+0x0/0x60()
[   20.131788] Calling initcall 0xc0c0ac60: selnl_init+0x0/0x60()
[   20.137595] initcall 0xc0c0ac60: selnl_init+0x0/0x60() returned 0.
[   20.143747] initcall 0xc0c0ac60 ran for 0 msecs: selnl_init+0x0/0x60()
[   20.150246] Calling initcall 0xc0c0acc0: sel_netif_init+0x0/0x80()
[   20.156398] initcall 0xc0c0acc0: sel_netif_init+0x0/0x80() returned 0.
[   20.162895] initcall 0xc0c0acc0 ran for 0 msecs: sel_netif_init+0x0/0x80()
[   20.169741] Calling initcall 0xc0c0ad40: aurule_init+0x0/0x50()
[   20.175637] initcall 0xc0c0ad40: aurule_init+0x0/0x50() returned 0.
[   20.181873] initcall 0xc0c0ad40 ran for 0 msecs: aurule_init+0x0/0x50()
[   20.188464] Calling initcall 0xc0c0ae20: crypto_algapi_init+0x0/0x10()
[   20.194963] initcall 0xc0c0ae20: crypto_algapi_init+0x0/0x10() returned 0.
[   20.201805] initcall 0xc0c0ae20 ran for 0 msecs: crypto_algapi_init+0x0/0x10()
[   20.209003] Calling initcall 0xc0c0ae50: cryptomgr_init+0x0/0x10()
[   20.215155] initcall 0xc0c0ae50: cryptomgr_init+0x0/0x10() returned 0.
[   20.221651] initcall 0xc0c0ae50 ran for 0 msecs: cryptomgr_init+0x0/0x10()
[   20.228502] Calling initcall 0xc0c0ae60: hmac_module_init+0x0/0x10()
[   20.234828] initcall 0xc0c0ae60: hmac_module_init+0x0/0x10() returned 0.
[   20.241497] initcall 0xc0c0ae60 ran for 0 msecs: hmac_module_init+0x0/0x10()
[   20.248520] Calling initcall 0xc0c0ae70: init+0x0/0x50()
[   20.253807] initcall 0xc0c0ae70: init+0x0/0x50() returned 0.
[   20.259435] initcall 0xc0c0ae70 ran for 0 msecs: init+0x0/0x50()
[   20.265415] Calling initcall 0xc0c0aec0: init+0x0/0x10()
[   20.270705] initcall 0xc0c0aec0: init+0x0/0x10() returned 0.
[   20.276334] initcall 0xc0c0aec0 ran for 0 msecs: init+0x0/0x10()
[   20.282314] Calling initcall 0xc0c0aed0: init+0x0/0x10()
[   20.287604] initcall 0xc0c0aed0: init+0x0/0x10() returned 0.
[   20.293233] initcall 0xc0c0aed0 ran for 0 msecs: init+0x0/0x10()
[   20.299629] Calling initcall 0xc0c0aee0: init+0x0/0x40()
[   20.304919] initcall 0xc0c0aee0: init+0x0/0x40() returned 0.
[   20.310552] initcall 0xc0c0aee0 ran for 0 msecs: init+0x0/0x40()
[   20.316528] Calling initcall 0xc0c0af20: init+0x0/0x60()
[   20.321818] initcall 0xc0c0af20: init+0x0/0x60() returned 0.
[   20.327452] initcall 0xc0c0af20 ran for 0 msecs: init+0x0/0x60()
[   20.333427] Calling initcall 0xc0c0af80: crypto_ecb_module_init+0x0/0x10()
[   20.340281] initcall 0xc0c0af80: crypto_ecb_module_init+0x0/0x10() returned 0.
[   20.347470] initcall 0xc0c0af80 ran for 0 msecs: crypto_ecb_module_init+0x0/0x10()
[   20.355010] Calling initcall 0xc0c0af90: crypto_cbc_module_init+0x0/0x10()
[   20.361855] initcall 0xc0c0af90: crypto_cbc_module_init+0x0/0x10() returned 0.
[   20.369044] initcall 0xc0c0af90 ran for 0 msecs: crypto_cbc_module_init+0x0/0x10()
[   20.376584] Calling initcall 0xc0c0afa0: crypto_pcbc_module_init+0x0/0x10()
[   20.383534] initcall 0xc0c0afa0: crypto_pcbc_module_init+0x0/0x10() returned 0.
[   20.390801] initcall 0xc0c0afa0 ran for 0 msecs: crypto_pcbc_module_init+0x0/0x10()
[   20.398427] Calling initcall 0xc0c0afb0: init+0x0/0x40()
[   20.403713] initcall 0xc0c0afb0: init+0x0/0x40() returned 0.
[   20.409342] initcall 0xc0c0afb0 ran for 0 msecs: init+0x0/0x40()
[   20.415321] Calling initcall 0xc0c0aff0: init+0x0/0x10()
[   20.420611] initcall 0xc0c0aff0: init+0x0/0x10() returned 0.
[   20.426241] initcall 0xc0c0aff0 ran for 0 msecs: init+0x0/0x10()
[   20.432221] Calling initcall 0xc0c0b000: init+0x0/0x10()
[   20.437510] initcall 0xc0c0b000: init+0x0/0x10() returned 0.
[   20.443139] initcall 0xc0c0b000 ran for 0 msecs: init+0x0/0x10()
[   20.449119] Calling initcall 0xc0c0b010: init+0x0/0x10()
[   20.454409] initcall 0xc0c0b010: init+0x0/0x10() returned 0.
[   20.460038] initcall 0xc0c0b010 ran for 0 msecs: init+0x0/0x10()
[   20.466018] Calling initcall 0xc0c0b020: init+0x0/0x40()
[   20.471308] initcall 0xc0c0b020: init+0x0/0x40() returned 0.
[   20.476942] initcall 0xc0c0b020 ran for 0 msecs: init+0x0/0x40()
[   20.482917] Calling initcall 0xc0c0b060: aes_init+0x0/0x330()
[   20.488655] initcall 0xc0c0b060: aes_init+0x0/0x330() returned 0.
[   20.494708] initcall 0xc0c0b060 ran for 0 msecs: aes_init+0x0/0x330()
[   20.501121] Calling initcall 0xc0c0b390: init+0x0/0x10()
[   20.506406] initcall 0xc0c0b390: init+0x0/0x10() returned 0.
[   20.512035] initcall 0xc0c0b390 ran for 0 msecs: init+0x0/0x10()
[   20.518019] Calling initcall 0xc0c0b3a0: arc4_init+0x0/0x10()
[   20.523738] initcall 0xc0c0b3a0: arc4_init+0x0/0x10() returned 0.
[   20.529801] initcall 0xc0c0b3a0 ran for 0 msecs: arc4_init+0x0/0x10()
[   20.536214] Calling initcall 0xc0c0b3b0: init+0x0/0x10()
[   20.541503] initcall 0xc0c0b3b0: init+0x0/0x10() returned 0.
[   20.547138] initcall 0xc0c0b3b0 ran for 0 msecs: init+0x0/0x10()
[   20.553113] Calling initcall 0xc0c0b3c0: init+0x0/0x10()
[   20.558403] initcall 0xc0c0b3c0: init+0x0/0x10() returned 0.
[   20.564036] initcall 0xc0c0b3c0 ran for 0 msecs: init+0x0/0x10()
[   20.570011] Calling initcall 0xc0c0b3d0: init+0x0/0x10()
[   20.575301] initcall 0xc0c0b3d0: init+0x0/0x10() returned 0.
[   20.580935] initcall 0xc0c0b3d0 ran for 0 msecs: init+0x0/0x10()
[   20.586915] Calling initcall 0xc0c0b3e0: crypto_authenc_module_init+0x0/0x10()
[   20.594107] initcall 0xc0c0b3e0: crypto_authenc_module_init+0x0/0x10() returned 0.
[   20.601643] initcall 0xc0c0b3e0 ran for 0 msecs: crypto_authenc_module_init+0x0/0x10()
[   20.609533] Calling initcall 0xc0c0b710: noop_init+0x0/0x10()
[   20.615251] io scheduler noop registered (default)
[   20.620021] initcall 0xc0c0b710: noop_init+0x0/0x10() returned 0.
[   20.626081] initcall 0xc0c0b710 ran for 4 msecs: noop_init+0x0/0x10()
[   20.632495] Calling initcall 0xc0c0b720: as_init+0x0/0x10()
[   20.638043] io scheduler anticipatory registered
[   20.642639] initcall 0xc0c0b720: as_init+0x0/0x10() returned 0.
[   20.648527] initcall 0xc0c0b720 ran for 4 msecs: as_init+0x0/0x10()
[   20.654771] Calling initcall 0xc0c0b930: audit_classes_init+0x0/0x50()
[   20.661270] initcall 0xc0c0b930: audit_classes_init+0x0/0x50() returned 0.
[   20.668112] initcall 0xc0c0b930 ran for 0 msecs: audit_classes_init+0x0/0x50()
[   20.675309] Calling initcall 0xc0372b60: pci_init+0x0/0x30()
[   20.680941] PCI: Calling quirk c0375950 for 0000:00:00.0
[   20.686229] PCI: Calling quirk c0694c10 for 0000:00:00.0
[   20.691516] PCI: Calling quirk c073a7c0 for 0000:00:00.0
[   20.696802] PCI: Calling quirk c0375950 for 0000:00:01.0
[   20.702088] PCI: Calling quirk c0694c10 for 0000:00:01.0
[   20.707374] PCI: Calling quirk c073a7c0 for 0000:00:01.0
[   20.712661] PCI: Calling quirk c0375950 for 0000:00:01.1
[   20.717947] PCI: Calling quirk c0694c10 for 0000:00:01.1
[   20.723233] PCI: Calling quirk c073a7c0 for 0000:00:01.1
[   20.728520] PCI: Calling quirk c0375950 for 0000:00:02.0
[   20.733806] PCI: Calling quirk c0694c10 for 0000:00:02.0
[   20.751693] PCI: Calling quirk c073a7c0 for 0000:00:02.0
[   20.756861] PCI: Calling quirk c0375950 for 0000:00:02.1
[   20.762144] PCI: Calling quirk c0694c10 for 0000:00:02.1
[   20.767439] PCI: Calling quirk c073a7c0 for 0000:00:02.1
[   20.772718] PCI: Calling quirk c0375950 for 0000:00:04.0
[   20.778003] PCI: Calling quirk c0694c10 for 0000:00:04.0
[   20.783289] PCI: Calling quirk c073a7c0 for 0000:00:04.0
[   20.788576] PCI: Calling quirk c0375950 for 0000:00:06.0
[   20.793862] PCI: Calling quirk c0694c10 for 0000:00:06.0
[   20.799148] PCI: Calling quirk c073a7c0 for 0000:00:06.0
[   20.804434] PCI: Calling quirk c0375950 for 0000:00:09.0
[   20.809721] PCI: Calling quirk c0694c10 for 0000:00:09.0
[   20.815007] PCI: Calling quirk c073a7c0 for 0000:00:09.0
[   20.820293] PCI: Calling quirk c0375950 for 0000:00:0a.0
[   20.825580] PCI: Calling quirk c0694c10 for 0000:00:0a.0
[   20.830867] PCI: Calling quirk c073a7c0 for 0000:00:0a.0
[   20.836153] PCI: Calling quirk c0374850 for 0000:00:0b.0
[   20.841440] PCI: Linking AER extended capability on 0000:00:0b.0
[   20.847418] PCI: Calling quirk c0375950 for 0000:00:0b.0
[   20.852705] PCI: Calling quirk c0694c10 for 0000:00:0b.0
[   20.857991] PCI: Calling quirk c073a7c0 for 0000:00:0b.0
[   20.863278] PCI: Calling quirk c0374850 for 0000:00:0c.0
[   20.868565] PCI: Linking AER extended capability on 0000:00:0c.0
[   20.874544] PCI: Calling quirk c0375950 for 0000:00:0c.0
[   20.879830] PCI: Calling quirk c0694c10 for 0000:00:0c.0
[   20.885116] PCI: Calling quirk c073a7c0 for 0000:00:0c.0
[   20.890402] PCI: Calling quirk c0374850 for 0000:00:0d.0
[   20.895690] PCI: Linking AER extended capability on 0000:00:0d.0
[   20.901669] PCI: Calling quirk c0375950 for 0000:00:0d.0
[   20.906955] PCI: Calling quirk c0694c10 for 0000:00:0d.0
[   20.912241] PCI: Calling quirk c073a7c0 for 0000:00:0d.0
[   20.917528] PCI: Calling quirk c0374850 for 0000:00:0e.0
[   20.922814] PCI: Linking AER extended capability on 0000:00:0e.0
[   20.928794] PCI: Calling quirk c0375950 for 0000:00:0e.0
[   20.934080] PCI: Calling quirk c0694c10 for 0000:00:0e.0
[   20.939365] PCI: Calling quirk c073a7c0 for 0000:00:0e.0
[   20.944653] PCI: Calling quirk c0375950 for 0000:00:18.0
[   20.949939] PCI: Calling quirk c0694c10 for 0000:00:18.0
[   20.955225] PCI: Calling quirk c073a7c0 for 0000:00:18.0
[   20.960512] PCI: Calling quirk c0375950 for 0000:00:18.1
[   20.965798] PCI: Calling quirk c0694c10 for 0000:00:18.1
[   20.971084] PCI: Calling quirk c073a7c0 for 0000:00:18.1
[   20.976371] PCI: Calling quirk c0375950 for 0000:00:18.2
[   20.981657] PCI: Calling quirk c0694c10 for 0000:00:18.2
[   20.986943] PCI: Calling quirk c073a7c0 for 0000:00:18.2
[   20.992230] PCI: Calling quirk c0375950 for 0000:00:18.3
[   20.997516] PCI: Calling quirk c0694c10 for 0000:00:18.3
[   21.002802] PCI: Calling quirk c073a7c0 for 0000:00:18.3
[   21.008088] PCI: Calling quirk c0375950 for 0000:05:07.0
[   21.013374] PCI: Calling quirk c0694c10 for 0000:05:07.0
[   21.018661] PCI: Calling quirk c073a7c0 for 0000:05:07.0
[   21.023948] PCI: Calling quirk c0375950 for 0000:01:00.0
[   21.029234] PCI: Calling quirk c0694c10 for 0000:01:00.0
[   21.034520] PCI: Calling quirk c073a7c0 for 0000:01:00.0
[   21.039808] Boot video device is 0000:01:00.0
[   21.044140] PCI: Calling quirk c0375950 for 0000:01:00.1
[   21.049425] PCI: Calling quirk c0694c10 for 0000:01:00.1
[   21.054713] PCI: Calling quirk c073a7c0 for 0000:01:00.1
[   21.060000] initcall 0xc0372b60: pci_init+0x0/0x30() returned 0.
[   21.065974] initcall 0xc0372b60 ran for 361 msecs: pci_init+0x0/0x30()
[   21.072473] Calling initcall 0xc0c0c120: pci_proc_init+0x0/0x70()
[   21.078561] initcall 0xc0c0c120: pci_proc_init+0x0/0x70() returned 0.
[   21.084952] initcall 0xc0c0c120 ran for 0 msecs: pci_proc_init+0x0/0x70()
[   21.091716] Calling initcall 0xc0c0c190: pcie_portdrv_init+0x0/0x50()
[   21.098224] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   21.104383] assign_interrupt_mode Found MSI capability
[   21.109482] Allocate Port Service[0000:00:0b.0:pcie00]
[   21.114636] Allocate Port Service[0000:00:0b.0:pcie03]
[   21.119773] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   21.125960] assign_interrupt_mode Found MSI capability
[   21.131061] Allocate Port Service[0000:00:0c.0:pcie00]
[   21.136216] Allocate Port Service[0000:00:0c.0:pcie03]
[   21.141354] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   21.147538] assign_interrupt_mode Found MSI capability
[   21.152639] Allocate Port Service[0000:00:0d.0:pcie00]
[   21.157791] Allocate Port Service[0000:00:0d.0:pcie03]
[   21.162929] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   21.169117] assign_interrupt_mode Found MSI capability
[   21.174219] Allocate Port Service[0000:00:0e.0:pcie00]
[   21.179369] Allocate Port Service[0000:00:0e.0:pcie03]
[   21.184507] initcall 0xc0c0c190: pcie_portdrv_init+0x0/0x50() returned 0.
[   21.191204] initcall 0xc0c0c190 ran for 82 msecs: pcie_portdrv_init+0x0/0x50()
[   21.198396] Calling initcall 0xc0c0c1e0: aer_service_init+0x0/0x20()
[   21.204758] initcall 0xc0c0c1e0: aer_service_init+0x0/0x20() returned 0.
[   21.211395] initcall 0xc0c0c1e0 ran for 0 msecs: aer_service_init+0x0/0x20()
[   21.218415] Calling initcall 0xc0c0c200: pci_hotplug_init+0x0/0xa0()
[   21.224771] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   21.230290] initcall 0xc0c0c200: pci_hotplug_init+0x0/0xa0() returned 0.
[   21.236961] initcall 0xc0c0c200 ran for 5 msecs: pci_hotplug_init+0x0/0xa0()
[   21.243980] Calling initcall 0xc0c0c2b0: zt5550_init+0x0/0x80()
[   21.249870] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[   21.256674] initcall 0xc0c0c2b0: zt5550_init+0x0/0x80() returned 0.
[   21.262868] initcall 0xc0c0c2b0 ran for 6 msecs: zt5550_init+0x0/0x80()
[   21.269454] Calling initcall 0xc0c0c330: shpcd_init+0x0/0x60()
[   21.275301] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   21.282392] initcall 0xc0c0c330: shpcd_init+0x0/0x60() returned 0.
[   21.288537] initcall 0xc0c0c330 ran for 6 msecs: shpcd_init+0x0/0x60()
[   21.295041] Calling initcall 0xc0c0c87d: acpi_reserve_resources+0x0/0xc4()
[   21.301888] initcall 0xc0c0c87d: acpi_reserve_resources+0x0/0xc4() returned 0.
[   21.309076] initcall 0xc0c0c87d ran for 0 msecs: acpi_reserve_resources+0x0/0xc4()
[   21.316616] Calling initcall 0xc0c0d3e8: acpi_ac_init+0x0/0x39()
[   21.322663] initcall 0xc0c0d3e8: acpi_ac_init+0x0/0x39() returned 0.
[   21.328921] initcall 0xc0c0d3e8 ran for 0 msecs: acpi_ac_init+0x0/0x39()
[   21.335599] Calling initcall 0xc0c0d421: acpi_battery_init+0x0/0x39()
[   21.342060] initcall 0xc0c0d421: acpi_battery_init+0x0/0x39() returned 0.
[   21.348767] initcall 0xc0c0d421 ran for 0 msecs: acpi_battery_init+0x0/0x39()
[   21.355877] Calling initcall 0xc0c0d45a: acpi_button_init+0x0/0x4d()
[   21.362313] input: Power Button (FF) as /class/input/input0
[   21.367752] ACPI: Power Button (FF) [PWRF]
[   21.371885] input: Power Button (CM) as /class/input/input1
[   21.377370] ACPI: Power Button (CM) [PWRB]
[   21.381460] initcall 0xc0c0d45a: acpi_button_init+0x0/0x4d() returned 0.
[   21.388111] initcall 0xc0c0d45a ran for 18 msecs: acpi_button_init+0x0/0x4d()
[   21.395221] Calling initcall 0xc0c0d555: irqrouter_init_sysfs+0x0/0x2d()
[   21.401958] initcall 0xc0c0d555: irqrouter_init_sysfs+0x0/0x2d() returned 0.
[   21.408910] initcall 0xc0c0d555 ran for 0 msecs: irqrouter_init_sysfs+0x0/0x2d()
[   21.416280] Calling initcall 0xc0c0dbcc: acpi_processor_init+0x0/0x96()
[   21.422948] initcall 0xc0c0dbcc: acpi_processor_init+0x0/0x96() returned 0.
[   21.429795] initcall 0xc0c0dbcc ran for 0 msecs: acpi_processor_init+0x0/0x96()
[   21.437079] Calling initcall 0xc0c0dddc: acpi_container_init+0x0/0x3b()
[   21.447004] initcall 0xc0c0dddc: acpi_container_init+0x0/0x3b() returned 0.
[   21.453805] initcall 0xc0c0dddc ran for 3 msecs: acpi_container_init+0x0/0x3b()
[   21.461084] Calling initcall 0xc0c0e750: rand_initialize+0x0/0x30()
[   21.467335] initcall 0xc0c0e750: rand_initialize+0x0/0x30() returned 0.
[   21.473910] initcall 0xc0c0e750 ran for 0 msecs: rand_initialize+0x0/0x30()
[   21.480842] Calling initcall 0xc0c0e7b0: tty_init+0x0/0x1f0()
[   21.513564] initcall 0xc0c0e7b0: tty_init+0x0/0x1f0() returned 0.
[   21.519497] initcall 0xc0c0e7b0 ran for 25 msecs: tty_init+0x0/0x1f0()
[   21.525997] Calling initcall 0xc0c0e9d0: pty_init+0x0/0x4d0()
[   21.556505] initcall 0xc0c0e9d0: pty_init+0x0/0x4d0() returned 0.
[   21.562438] initcall 0xc0c0e9d0 ran for 23 msecs: pty_init+0x0/0x4d0()
[   21.568937] Calling initcall 0xc0c0f570: init+0x0/0x10()
[   21.574269] initcall 0xc0c0f570: init+0x0/0x10() returned 0.
[   21.579856] initcall 0xc0c0f570 ran for 0 msecs: init+0x0/0x10()
[   21.585836] Calling initcall 0xc0c0f5a0: raw_init+0x0/0xd0()
[   21.591547] initcall 0xc0c0f5a0: raw_init+0x0/0xd0() returned 0.
[   21.597453] initcall 0xc0c0f5a0 ran for 0 msecs: raw_init+0x0/0xd0()
[   21.603780] Calling initcall 0xc0c0f670: dtlk_init+0x0/0x1a0()
[   21.609595] DoubleTalk PC - not found
[   21.613229] initcall 0xc0c0f670: dtlk_init+0x0/0x1a0() returned -19.
[   21.619547] initcall 0xc0c0f670 ran for 3 msecs: dtlk_init+0x0/0x1a0()
[   21.626046] Calling initcall 0xc0c0f810: r3964_init+0x0/0x40()
[   21.631855] r3964: Philips r3964 Driver $Revision: 1.10 $
[   21.637233] initcall 0xc0c0f810: r3964_init+0x0/0x40() returned 0.
[   21.643379] initcall 0xc0c0f810 ran for 5 msecs: r3964_init+0x0/0x40()
[   21.649878] Calling initcall 0xc0c0f890: rtc_init+0x0/0xa0()
[   21.655561] Real Time Clock Driver v1.12ac
[   21.659592] initcall 0xc0c0f890: rtc_init+0x0/0xa0() returned 0.
[   21.665564] initcall 0xc0c0f890 ran for 3 msecs: rtc_init+0x0/0xa0()
[   21.671896] Calling initcall 0xc0c0f930: hpet_init+0x0/0x60()
[   21.677725] initcall 0xc0c0f930: hpet_init+0x0/0x60() returned 0.
[   21.683682] initcall 0xc0c0f930 ran for 0 msecs: hpet_init+0x0/0x60()
[   21.690090] Calling initcall 0xc0c0f990: nvram_init+0x0/0x80()
[   21.695937] Non-volatile memory driver v1.2
[   21.700063] initcall 0xc0c0f990: nvram_init+0x0/0x80() returned 0.
[   21.706208] initcall 0xc0c0f990 ran for 3 msecs: nvram_init+0x0/0x80()
[   21.712708] Calling initcall 0xc0c0fa10: mod_init+0x0/0x200()
[   21.718438] initcall 0xc0c0fa10: mod_init+0x0/0x200() returned -19.
[   21.724671] initcall 0xc0c0fa10 ran for 0 msecs: mod_init+0x0/0x200()
[   21.731085] Calling initcall 0xc0c0fd00: mod_init+0x0/0x60()
[   21.736717] initcall 0xc0c0fd00: mod_init+0x0/0x60() returned -19.
[   21.742867] initcall 0xc0c0fd00 ran for 0 msecs: mod_init+0x0/0x60()
[   21.749192] Calling initcall 0xc0c0fd60: scx200_gpio_init+0x0/0x140()
[   21.755607] scx200_gpio: no SCx200 gpio present
[   21.760117] initcall 0xc0c0fd60: scx200_gpio_init+0x0/0x140() returned -19.
[   21.767049] initcall 0xc0c0fd60 ran for 4 msecs: scx200_gpio_init+0x0/0x140()
[   21.774156] Calling initcall 0xc0c0fea0: nsc_gpio_init+0x0/0x20()
[   21.780223] nsc_gpio initializing
[   21.783512] initcall 0xc0c0fea0: nsc_gpio_init+0x0/0x20() returned 0.
[   21.789923] initcall 0xc0c0fea0 ran for 3 msecs: nsc_gpio_init+0x0/0x20()
[   21.796683] Calling initcall 0xc0c0fec0: cs5535_gpio_init+0x0/0x1a0()
[   21.803098] cs5535_gpio: DIVIL not found
[   21.807002] initcall 0xc0c0fec0: cs5535_gpio_init+0x0/0x1a0() returned -19.
[   21.813933] initcall 0xc0c0fec0 ran for 3 msecs: cs5535_gpio_init+0x0/0x1a0()
[   21.821039] Calling initcall 0xc0c10060: tlclk_init+0x0/0x1c0()
[   21.826936] telclk_interrup = 0xf non-mcpbl0010 hw.
[   21.831787] initcall 0xc0c10060: tlclk_init+0x0/0x1c0() returned -6.
[   21.838111] initcall 0xc0c10060 ran for 4 msecs: tlclk_init+0x0/0x1c0()
[   21.844698] initcall at 0xc0c10060: tlclk_init+0x0/0x1c0(): returned with error code -6
[   21.852670] Calling initcall 0xc0c10220: mwave_init+0x0/0x340()
[   21.858566] smapi::smapi_init, ERROR invalid usSmapiID
[   21.863677] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[   21.872949] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[   21.880142] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   21.886384] initcall 0xc0c10220: mwave_init+0x0/0x340() returned -5.
[   21.892704] initcall 0xc0c10220 ran for 26 msecs: mwave_init+0x0/0x340()
[   21.899376] initcall at 0xc0c10220: mwave_init+0x0/0x340(): returned with error code -5
[   21.907353] Calling initcall 0xc0c10560: drm_core_init+0x0/0x140()
[   21.913550] [drm] Initialized drm 1.1.0 20060810
[   21.918102] initcall 0xc0c10560: drm_core_init+0x0/0x140() returned 0.
[   21.924599] initcall 0xc0c10560 ran for 4 msecs: drm_core_init+0x0/0x140()
[   21.931445] Calling initcall 0xc0c106a0: tdfx_init+0x0/0x10()
[   21.937165] initcall 0xc0c106a0: tdfx_init+0x0/0x10() returned 0.
[   21.943227] initcall 0xc0c106a0 ran for 0 msecs: tdfx_init+0x0/0x10()
[   21.949640] Calling initcall 0xc0c106b0: mga_init+0x0/0x20()
[   21.955277] initcall 0xc0c106b0: mga_init+0x0/0x20() returned 0.
[   21.961257] initcall 0xc0c106b0 ran for 0 msecs: mga_init+0x0/0x20()
[   21.967583] Calling initcall 0xc0c106d0: savage_init+0x0/0x20()
[   21.973478] initcall 0xc0c106d0: savage_init+0x0/0x20() returned 0.
[   21.979711] initcall 0xc0c106d0 ran for 0 msecs: savage_init+0x0/0x20()
[   21.986297] Calling initcall 0xc0c106f0: via_init+0x0/0x20()
[   21.991939] initcall 0xc0c106f0: via_init+0x0/0x20() returned 0.
[   21.997915] initcall 0xc0c106f0 ran for 0 msecs: via_init+0x0/0x20()
[   22.004241] Calling initcall 0xc0c107d0: hangcheck_init+0x0/0xb0()
[   22.010392] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[   22.019320] Hangcheck: Using get_cycles().
[   22.023395] initcall 0xc0c107d0: hangcheck_init+0x0/0xb0() returned 0.
[   22.029889] initcall 0xc0c107d0 ran for 12 msecs: hangcheck_init+0x0/0xb0()
[   22.036821] Calling initcall 0xc0c10880: cn_proc_init+0x0/0x40()
[   22.042805] initcall 0xc0c10880: cn_proc_init+0x0/0x40() returned 0.
[   22.049127] initcall 0xc0c10880 ran for 0 msecs: cn_proc_init+0x0/0x40()
[   22.055800] Calling initcall 0xc0c10d50: serial8250_init+0x0/0x120()
[   22.062128] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled[   22.070043] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   22.076190] initcall 0xc0c10d50: serial8250_init+0x0/0x120() returned 0.
[   22.082734] initcall 0xc0c10d50 ran for 13 msecs: serial8250_init+0x0/0x120()
[   22.089840] Calling initcall 0xc0c10e70: serial8250_pnp_init+0x0/0x10()
[   22.096648] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   22.102177] initcall 0xc0c10e70: serial8250_pnp_init+0x0/0x10() returned 0.
[   22.109001] initcall 0xc0c10e70 ran for 5 msecs: serial8250_pnp_init+0x0/0x10()
[   22.116285] Calling initcall 0xc0c10e80: serial8250_pci_init+0x0/0x20()
[   22.122923] initcall 0xc0c10e80: serial8250_pci_init+0x0/0x20() returned 0.
[   22.129800] initcall 0xc0c10e80 ran for 0 msecs: serial8250_pci_init+0x0/0x20()
[   22.137083] Calling initcall 0xc0c11310: mca_init+0x0/0x20()
[   22.142716] initcall 0xc0c11310: mca_init+0x0/0x20() returned -19.
[   22.148866] initcall 0xc0c11310 ran for 0 msecs: mca_init+0x0/0x20()
[   22.155195] Calling initcall 0xc0c114e0: isa_bus_init+0x0/0x40()
[   22.161218] initcall 0xc0c114e0: isa_bus_init+0x0/0x40() returned 0.
[   22.167502] initcall 0xc0c114e0 ran for 0 msecs: isa_bus_init+0x0/0x40()
[   22.174174] Calling initcall 0xc0c11590: topology_sysfs_init+0x0/0x50()
[   22.180763] initcall 0xc0c11590: topology_sysfs_init+0x0/0x50() returned 0.
[   22.187694] initcall 0xc0c11590 ran for 0 msecs: topology_sysfs_init+0x0/0x50()
[   22.194973] Calling initcall 0xc0c115e0: cciss_init+0x0/0x30()
[   22.200777] HP CISS Driver (v 3.6.14)
[   22.204460] initcall 0xc0c115e0: cciss_init+0x0/0x30() returned 0.
[   22.210573] initcall 0xc0c115e0 ran for 3 msecs: cciss_init+0x0/0x30()
[   22.217072] Calling initcall 0xc0c11610: pkt_init+0x0/0x160()
[   22.222869] initcall 0xc0c11610: pkt_init+0x0/0x160() returned 0.
[   22.228854] initcall 0xc0c11610 ran for 0 msecs: pkt_init+0x0/0x160()
[   22.235271] Calling initcall 0xc0c11770: init+0x0/0x10()
[   22.240593] initcall 0xc0c11770: init+0x0/0x10() returned 0.
[   22.246186] initcall 0xc0c11770 ran for 0 msecs: init+0x0/0x10()
[   22.252165] Calling initcall 0xc0c11780: ub_init+0x0/0x80()
[   22.257752] usbcore: registered new interface driver ub
[   22.262920] initcall 0xc0c11780: ub_init+0x0/0x80() returned 0.
[   22.268804] initcall 0xc0c11780 ran for 4 msecs: ub_init+0x0/0x80()
[   22.275048] Calling initcall 0xc0c11800: asus_laptop_init+0x0/0x2a0()
[   22.281546] initcall 0xc0c11800: asus_laptop_init+0x0/0x2a0() returned -19.
[   22.288390] initcall 0xc0c11800 ran for 0 msecs: asus_laptop_init+0x0/0x2a0()
[   22.295501] Calling initcall 0xc03fd5f0: ioc4_init+0x0/0x20()
[   22.301258] initcall 0xc03fd5f0: ioc4_init+0x0/0x20() returned 0.
[   22.307287] initcall 0xc03fd5f0 ran for 0 msecs: ioc4_init+0x0/0x20()
[   22.313700] Calling initcall 0xc0c11b10: fujitsu_init+0x0/0x150()
[   22.319927] fujitsu-laptop: driver 0.3 successfully loaded.
[   22.325349] initcall 0xc0c11b10: fujitsu_init+0x0/0x150() returned 0.
[   22.331755] initcall 0xc0c11b10 ran for 5 msecs: fujitsu_init+0x0/0x150()
[   22.338518] Calling initcall 0xc0c11c60: e1000_init_module+0x0/0x90()
[   22.344930] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
[   22.351345] Copyright (c) 1999-2006 Intel Corporation.
[   22.356502] initcall 0xc0c11c60: e1000_init_module+0x0/0x90() returned 0.
[   22.363213] initcall 0xc0c11c60 ran for 11 msecs: e1000_init_module+0x0/0x90()
[   22.370826] Calling initcall 0xc0c11cf0: e1000_init_module+0x0/0x50()
[   22.377237] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
[   22.382872] e1000e: Copyright (c) 1999-2007 Intel Corporation.
[   22.388719] initcall 0xc0c11cf0: e1000_init_module+0x0/0x50() returned 0.
[   22.395433] initcall 0xc0c11cf0 ran for 10 msecs: e1000_init_module+0x0/0x50()
[   22.402631] Calling initcall 0xc0c11d40: ipg_init_module+0x0/0x20()
[   22.408910] initcall 0xc0c11d40: ipg_init_module+0x0/0x20() returned 0.
[   22.415452] initcall 0xc0c11d40 ran for 0 msecs: ipg_init_module+0x0/0x20()
[   22.422389] Calling initcall 0xc0c11d60: bonding_init+0x0/0x9e0()
[   22.428454] Ethernet Channel Bonding Driver: v3.2.1 (October 15, 2007)
[   22.434957] bonding: Warning: either miimon or arp_interval and arp_ip_target module parameters must be specified, otherwise bonding will not detect link failures! see bonding.txt for details.
[   22.452278] initcall 0xc0c11d60: bonding_init+0x0/0x9e0() returned 0.
[   22.458558] initcall 0xc0c11d60 ran for 22 msecs: bonding_init+0x0/0x9e0()
[   22.465408] Calling initcall 0xc0c12740: atl1_init_module+0x0/0x20()
[   22.471773] initcall 0xc0c12740: atl1_init_module+0x0/0x20() returned 0.
[   22.478403] initcall 0xc0c12740 ran for 0 msecs: atl1_init_module+0x0/0x20()
[   22.485427] Calling initcall 0xc0c12760: happy_meal_probe+0x0/0x20()
[   22.491791] initcall 0xc0c12760: happy_meal_probe+0x0/0x20() returned 0.
[   22.498422] initcall 0xc0c12760 ran for 0 msecs: happy_meal_probe+0x0/0x20()
[   22.505446] Calling initcall 0xc0c12780: vortex_init+0x0/0xf0()
[   22.511412] initcall 0xc0c12780: vortex_init+0x0/0xf0() returned 0.
[   22.517578] initcall 0xc0c12780 ran for 0 msecs: vortex_init+0x0/0xf0()
[   22.524164] Calling initcall 0xc0c12930: typhoon_init+0x0/0x20()
[   22.530182] initcall 0xc0c12930: typhoon_init+0x0/0x20() returned 0.
[   22.536466] initcall 0xc0c12930 ran for 0 msecs: typhoon_init+0x0/0x20()
[   22.543139] Calling initcall 0xc0c12950: ne2k_pci_init+0x0/0x20()
[   22.549248] initcall 0xc0c12950: ne2k_pci_init+0x0/0x20() returned 0.
[   22.555618] initcall 0xc0c12950 ran for 0 msecs: ne2k_pci_init+0x0/0x20()
[   22.562382] Calling initcall 0xc0c12970: pcnet32_init_module+0x0/0x130()
[   22.569052] pcnet32.c:v1.34 14.Aug.2007 tsbogend@alpha.franken.de
[   22.575162] initcall 0xc0c12970: pcnet32_init_module+0x0/0x130() returned 0.
[   22.582137] initcall 0xc0c12970 ran for 5 msecs: pcnet32_init_module+0x0/0x130()
[   22.589507] Calling initcall 0xc0c12aa0: e100_init_module+0x0/0x60()
[   22.595831] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[   22.601900] e100: Copyright(c) 1999-2006 Intel Corporation
[   22.607402] initcall 0xc0c12aa0: e100_init_module+0x0/0x60() returned 0.
[   22.614033] initcall 0xc0c12aa0 ran for 11 msecs: e100_init_module+0x0/0x60()
[   22.621139] Calling initcall 0xc0c12b00: tlan_probe+0x0/0x350()
[   22.627033] ThunderLAN driver v1.15
[   22.630552] TLAN: 0 devices installed, PCI: 0  EISA: 0
[   22.635652] initcall 0xc0c12b00: tlan_probe+0x0/0x350() returned -19.
[   22.642019] initcall 0xc0c12b00 ran for 8 msecs: tlan_probe+0x0/0x350()
[   22.648610] Calling initcall 0xc0c12e50: epic_init+0x0/0x20()
[   22.654368] initcall 0xc0c12e50: epic_init+0x0/0x20() returned 0.
[   22.660396] initcall 0xc0c12e50 ran for 0 msecs: epic_init+0x0/0x20()
[   22.666804] Calling initcall 0xc0c12e70: sis900_init_module+0x0/0x20()
[   22.673346] initcall 0xc0c12e70: sis900_init_module+0x0/0x20() returned 0.
[   22.680151] initcall 0xc0c12e70 ran for 0 msecs: sis900_init_module+0x0/0x20()
[   22.687348] Calling initcall 0xc0c12e90: natsemi_init_mod+0x0/0x20()
[   22.693720] initcall 0xc0c12e90: natsemi_init_mod+0x0/0x20() returned 0.
[   22.700347] initcall 0xc0c12e90 ran for 0 msecs: natsemi_init_mod+0x0/0x20()
[   22.707366] Calling initcall 0xc0c12eb0: ns83820_init+0x0/0x30()
[   22.713344] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[   22.720146] initcall 0xc0c12eb0: ns83820_init+0x0/0x30() returned 0.
[   22.726428] initcall 0xc0c12eb0 ran for 6 msecs: ns83820_init+0x0/0x30()
[   22.733100] Calling initcall 0xc0c12ee0: fealnx_init+0x0/0x20()
[   22.739036] initcall 0xc0c12ee0: fealnx_init+0x0/0x20() returned 0.
[   22.745233] initcall 0xc0c12ee0 ran for 0 msecs: fealnx_init+0x0/0x20()
[   22.751823] Calling initcall 0xc0c12f00: tg3_init+0x0/0x20()
[   22.757505] initcall 0xc0c12f00: tg3_init+0x0/0x20() returned 0.
[   22.763432] initcall 0xc0c12f00 ran for 0 msecs: tg3_init+0x0/0x20()
[   22.769758] Calling initcall 0xc0c12f20: sky2_init_module+0x0/0x20()
[   22.776129] initcall 0xc0c12f20: sky2_init_module+0x0/0x20() returned 0.
[   22.782757] initcall 0xc0c12f20 ran for 0 msecs: sky2_init_module+0x0/0x20()
[   22.789777] Calling initcall 0xc0c12f40: skge_init+0x0/0x30()
[   22.795498] sk98lin: driver has been replaced by the skge driver and is scheduled for removal
[   22.804035] initcall 0xc0c12f40: skge_init+0x0/0x30() returned 0.
[   22.810055] initcall 0xc0c12f40 ran for 8 msecs: skge_init+0x0/0x30()
[   22.816468] Calling initcall 0xc0c12f70: rhine_init+0x0/0x70()
[   22.822319] initcall 0xc0c12f70: rhine_init+0x0/0x70() returned 0.
[   22.828428] initcall 0xc0c12f70 ran for 0 msecs: rhine_init+0x0/0x70()
[   22.834932] Calling initcall 0xc0c13020: marvell_init+0x0/0x60()
[   22.841081] initcall 0xc0c13020: marvell_init+0x0/0x60() returned 0.
[   22.847281] initcall 0xc0c13020 ran for 0 msecs: marvell_init+0x0/0x60()
[   22.853954] Calling initcall 0xc0c13080: cicada_init+0x0/0x40()
[   22.859914] initcall 0xc0c13080: cicada_init+0x0/0x40() returned 0.
[   22.866082] initcall 0xc0c13080 ran for 0 msecs: cicada_init+0x0/0x40()
[   22.872668] Calling initcall 0xc0c130c0: qs6612_init+0x0/0x10()
[   22.878598] initcall 0xc0c130c0: qs6612_init+0x0/0x10() returned 0.
[   22.884800] initcall 0xc0c130c0 ran for 0 msecs: qs6612_init+0x0/0x10()
[   22.891392] Calling initcall 0xc0c130d0: ip175c_init+0x0/0x10()
[   22.897318] initcall 0xc0c130d0: ip175c_init+0x0/0x10() returned 0.
[   22.903520] initcall 0xc0c130d0 ran for 0 msecs: ip175c_init+0x0/0x10()
[   22.910105] Calling initcall 0xc0c130e0: sundance_init+0x0/0x20()
[   22.916214] initcall 0xc0c130e0: sundance_init+0x0/0x20() returned 0.
[   22.922585] initcall 0xc0c130e0 ran for 0 msecs: sundance_init+0x0/0x20()
[   22.929345] Calling initcall 0xc0c13160: net_olddevs_init+0x0/0x130()
[   22.935780] cs89x0:cs89x0_probe(0x0)
[   22.939317] PP_addr at 300[a]: 0xffff
[   22.942956] eth0: incorrect signature at 300[c]: 0xffff!=0x630E
[   22.948849] PP_addr at 320[a]: 0xffff
[   22.952488] eth0: incorrect signature at 320[c]: 0xffff!=0x630E
[   22.958382] PP_addr at 340[a]: 0xffff
[   22.962022] eth0: incorrect signature at 340[c]: 0xffff!=0x630E
[   22.967914] PP_addr at 360[a]: 0xffff
[   22.971555] eth0: incorrect signature at 360[c]: 0xffff!=0x630E
[   22.977447] PP_addr at 200[a]: 0xffff
[   22.981087] eth0: incorrect signature at 200[c]: 0xffff!=0x630E
[   22.986979] PP_addr at 220[a]: 0xffff
[   22.990619] eth0: incorrect signature at 220[c]: 0xffff!=0x630E
[   22.996512] PP_addr at 240[a]: 0xffff
[   23.000152] eth0: incorrect signature at 240[c]: 0xffff!=0x630E
[   23.006045] PP_addr at 260[a]: 0xffff
[   23.009685] eth0: incorrect signature at 260[c]: 0xffff!=0x630E
[   23.015577] PP_addr at 280[a]: 0xffff
[   23.019218] eth0: incorrect signature at 280[c]: 0xffff!=0x630E
[   23.025111] PP_addr at 2a0[a]: 0xffff
[   23.028753] eth0: incorrect signature at 2a0[c]: 0xffff!=0x630E
[   23.034644] PP_addr at 2c0[a]: 0xffff
[   23.038286] eth0: incorrect signature at 2c0[c]: 0xffff!=0x630E
[   23.044176] PP_addr at 2e0[a]: 0xffff
[   23.047818] eth0: incorrect signature at 2e0[c]: 0xffff!=0x630E
[   23.053708] cs89x0: no cs8900 or cs8920 detected.  Be sure to disable PnP with SETUP
[   23.061449] cops.c:v0.04 6/7/98 Jay Schulist <jschlst@samba.org>
[   23.067416] lt0: cops at 0x240, IRQ 5, in Tangent mode
[   23.106029] lt0: Bad packet length of 65535 bytes.
[   23.144185] lt0: Bad packet length of 65535 bytes.
[   23.182342] lt0: Bad packet length of 65535 bytes.
[   23.220498] lt0: Bad packet length of 65535 bytes.
[   23.258655] lt0: Bad packet length of 65535 bytes.
[   23.296811] lt0: Bad packet length of 65535 bytes.
[   23.334969] lt0: Bad packet length of 65535 bytes.
[   23.373125] lt0: Bad packet length of 65535 bytes.
[   23.411283] lt0: Bad packet length of 65535 bytes.
[   23.449439] lt0: Bad packet length of 65535 bytes.
[   23.487596] lt0: Bad packet length of 65535 bytes.
[   23.525753] lt0: Bad packet length of 65535 bytes.

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.24-rc3-cfs-v24
# Sat Dec  1 21:34:12 2007
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
CONFIG_BOOTPARAM_SUPPORT=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_NS is not set
CONFIG_CPUSETS=y
# CONFIG_BOOTPARAM_MAXCPUS_1 is not set
# CONFIG_BOOTPARAM_NOSMP is not set
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_FAIR_USER_SCHED=y
# CONFIG_FAIR_CGROUP_SCHED is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_PROC_PID_CPUSET is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
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
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_BOOTPARAM_NO_HZ_OFF is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_BOOTPARAM_HIGHRES_OFF is not set
CONFIG_SMP=y
# CONFIG_X86_PC is not set
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
CONFIG_X86_GENERICARCH=y
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN is not set
# CONFIG_VMI is not set
CONFIG_LGUEST_GUEST=y
CONFIG_X86_CYCLONE_TIMER=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
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
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
CONFIG_MGEODE_LX=y
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_USE_3DNOW=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_HPET_TIMER is not set
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
# CONFIG_PREEMPT_BKL is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_HIGHPTE is not set
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
CONFIG_EFI=y
CONFIG_IRQBALANCE=y
CONFIG_BOOT_IOREMAP=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_BOOTPARAM_NMI_WATCHDOG_BIT_1 is not set
# CONFIG_BOOTPARAM_NOAPIC is not set
CONFIG_BOOTPARAM_NOLAPIC=y
# CONFIG_BOOTPARAM_LAPIC is not set
# CONFIG_BOOTPARAM_HPET_DISABLE is not set
CONFIG_BOOTPARAM_IDLE_MWAIT=y
# CONFIG_BOOTPARAM_IDLE_POLL is not set
# CONFIG_BOOTPARAM_HIGHMEM_512M is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_SUSPEND_SMP_POSSIBLE=y
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATION_SMP_POSSIBLE=y
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_THERMAL is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_POWERNOW_K8_ACPI=y
CONFIG_X86_GX_SUSPMOD=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=y
CONFIG_X86_LONGRUN=y
CONFIG_X86_LONGHAUL=y
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_LEGACY is not set
CONFIG_PCI_DEBUG=y
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_PCI_EISA is not set
CONFIG_EISA_NAMES=y
CONFIG_MCA=y
# CONFIG_MCA_LEGACY is not set
CONFIG_SCx200=y
# CONFIG_SCx200HR_TIMER is not set
# CONFIG_GEODE_MFGPT_TIMER is not set
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PCMCIA_PROBE=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
CONFIG_HOTPLUG_PCI_SHPC=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IP_VS is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
# CONFIG_NF_CONNTRACK_ENABLED is not set
# CONFIG_NF_CONNTRACK is not set
# CONFIG_NETFILTER_XTABLES is not set

#
# IP: Netfilter Configuration
#
CONFIG_IP_NF_QUEUE=y
# CONFIG_IP_NF_IPTABLES is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# DECnet: Netfilter Configuration
#
# CONFIG_DECNET_NF_GRABULATOR is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_MSG is not set
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=y
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=y
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_LTPC=y
CONFIG_COPS=y
# CONFIG_COPS_DAYNA is not set
CONFIG_COPS_TANGENT=y
CONFIG_IPDDP=y
# CONFIG_IPDDP_ENCAP is not set
# CONFIG_IPDDP_DECAP is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_ATM=y
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_RR is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=y
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_INGRESS is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=y
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_CLS_POLICE=y
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
CONFIG_NETROM=y
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
CONFIG_6PACK=y
# CONFIG_BPQETHER is not set
# CONFIG_SCC is not set
# CONFIG_BAYCOM_SER_FDX is not set
CONFIG_BAYCOM_SER_HDX=y
CONFIG_YAM=y
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=y
# CONFIG_KS959_DONGLE is not set

#
# Old SIR device drivers
#

#
# Old Serial dongle support
#

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
CONFIG_SIGMATEL_FIR=y
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
# CONFIG_TOSHIBA_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=y
# CONFIG_MCS_FIR is not set
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y

#
# Wireless
#
CONFIG_CFG80211=y
# CONFIG_NL80211 is not set
CONFIG_WIRELESS_EXT=y
CONFIG_MAC80211=y
CONFIG_MAC80211_RCSIMPLE=y
# CONFIG_MAC80211_DEBUG is not set
CONFIG_IEEE80211=y
CONFIG_IEEE80211_DEBUG=y
CONFIG_IEEE80211_CRYPT_WEP=y
CONFIG_IEEE80211_CRYPT_CCMP=y
# CONFIG_IEEE80211_CRYPT_TKIP is not set
# CONFIG_IEEE80211_SOFTMAC is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
CONFIG_NET_9P=y
CONFIG_NET_9P_FD=y
# CONFIG_NET_9P_VIRTIO is not set
CONFIG_NET_9P_DEBUG=y

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
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
# CONFIG_BLK_CPQ_DA is not set
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_UB=y
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_EEPROM_93CX6=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ASUS_LAPTOP=y
CONFIG_FUJITSU_LAPTOP=y
# CONFIG_MSI_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_7000FASST is not set
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AHA152X=y
CONFIG_SCSI_AHA1542=y
CONFIG_SCSI_AHA1740=y
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_IN2000=y
CONFIG_SCSI_ARCMSR=y
# CONFIG_SCSI_ARCMSR_AER is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
# CONFIG_MEGARAID_MAILBOX is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
CONFIG_SCSI_DMX3191D=y
# CONFIG_SCSI_DTC3280 is not set
CONFIG_SCSI_EATA=y
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
# CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
CONFIG_SCSI_EATA_MAX_TAGS=16
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GENERIC_NCR5380=y
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
CONFIG_SCSI_GENERIC_NCR53C400=y
# CONFIG_SCSI_IBMMCA is not set
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=y
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_NCR53C406A=y
CONFIG_SCSI_NCR_D700=y
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=y
# CONFIG_SCSI_IPR_TRACE is not set
CONFIG_SCSI_IPR_DUMP=y
CONFIG_SCSI_NCR_Q720=y
CONFIG_SCSI_NCR53C8XX_DEFAULT_TAGS=8
CONFIG_SCSI_NCR53C8XX_MAX_TAGS=32
CONFIG_SCSI_NCR53C8XX_SYNC=20
CONFIG_SCSI_PAS16=y
# CONFIG_SCSI_PSI240I is not set
CONFIG_SCSI_QLOGIC_FAS=y
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_SEAGATE=y
CONFIG_SCSI_SIM710=y
CONFIG_SCSI_SYM53C416=y
# CONFIG_SCSI_DC395x is not set
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_T128=y
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
CONFIG_SCSI_NSP32=y
CONFIG_SCSI_SRP=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SVW=y
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
# CONFIG_SATA_PROMISE is not set
CONFIG_SATA_SX4=y
CONFIG_SATA_SIL=y
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=y
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_PATA_ACPI=y
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=y
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_CMD64X=y
CONFIG_PATA_CS5520=y
CONFIG_PATA_CS5530=y
CONFIG_PATA_CS5535=y
CONFIG_PATA_CS5536=y
# CONFIG_PATA_CYPRESS is not set
CONFIG_PATA_EFAR=y
CONFIG_ATA_GENERIC=y
CONFIG_PATA_HPT366=y
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
CONFIG_PATA_HPT3X3=y
CONFIG_PATA_HPT3X3_DMA=y
CONFIG_PATA_IT821X=y
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_PATA_TRIFLEX=y
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_NS87415=y
CONFIG_PATA_OPTI=y
CONFIG_PATA_OPTIDMA=y
CONFIG_PATA_PDC_OLD=y
# CONFIG_PATA_QDI is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SERVERWORKS=y
CONFIG_PATA_PDC2027X=y
CONFIG_PATA_SIL680=y
# CONFIG_PATA_SIS is not set
CONFIG_PATA_VIA=y
CONFIG_PATA_WINBOND=y
CONFIG_PATA_WINBOND_VLB=y
# CONFIG_MD is not set
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
CONFIG_FUSION_FC=y
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
# CONFIG_FUSION_LAN is not set
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
# CONFIG_FIREWIRE_SBP2 is not set
CONFIG_IEEE1394=y

#
# Subsystem Options
#
# CONFIG_IEEE1394_VERBOSEDEBUG is not set

#
# Controllers
#

#
# Texas Instruments PCILynx requires I2C
#
CONFIG_IEEE1394_OHCI1394=y

#
# Protocols
#
# CONFIG_IEEE1394_VIDEO1394 is not set
CONFIG_IEEE1394_SBP2=y
CONFIG_IEEE1394_SBP2_PHYS_DMA=y
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_ETH1394 is not set
# CONFIG_IEEE1394_DV1394 is not set
# CONFIG_IEEE1394_RAWIO is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
CONFIG_IFB=y
CONFIG_DUMMY=y
CONFIG_BONDING=y
# CONFIG_MACVLAN is not set
CONFIG_EQUALIZER=y
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
CONFIG_IP1000=y
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
CONFIG_ICPLUS_PHY=y
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=y
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
CONFIG_EL1=y
# CONFIG_EL2 is not set
CONFIG_ELPLUS=y
# CONFIG_EL16 is not set
# CONFIG_EL3 is not set
# CONFIG_3C515 is not set
CONFIG_VORTEX=y
CONFIG_TYPHOON=y
# CONFIG_LANCE is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_NET_VENDOR_RACAL is not set
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
CONFIG_DM9102=y
# CONFIG_ULI526X is not set
CONFIG_PCMCIA_XIRCOM=y
# CONFIG_AT1700 is not set
CONFIG_DEPCA=y
# CONFIG_HP100 is not set
# CONFIG_NET_ISA is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=y
# CONFIG_PCNET32_NAPI is not set
CONFIG_AMD8111_ETH=y
CONFIG_AMD8111E_NAPI=y
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_AC3200 is not set
CONFIG_APRICOT=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
CONFIG_FORCEDETH_NAPI=y
CONFIG_CS89x0=y
# CONFIG_EEPRO100 is not set
CONFIG_E100=y
# CONFIG_LNE390 is not set
CONFIG_FEALNX=y
CONFIG_NATSEMI=y
CONFIG_NE2K_PCI=y
# CONFIG_NE3210 is not set
# CONFIG_ES3210 is not set
CONFIG_8139CP=y
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=y
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_SIS900=y
CONFIG_EPIC100=y
CONFIG_SUNDANCE=y
CONFIG_SUNDANCE_MMIO=y
CONFIG_TLAN=y
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
CONFIG_VIA_RHINE_NAPI=y
# CONFIG_SC92031 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=y
CONFIG_E1000_NAPI=y
# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
CONFIG_E1000E=y
CONFIG_NS83820=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=y
# CONFIG_R8169_NAPI is not set
# CONFIG_R8169_VLAN is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=y
CONFIG_SK98LIN=y
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
# CONFIG_BNX2 is not set
CONFIG_QLA3XXX=y
CONFIG_ATL1=y
# CONFIG_NETDEV_10000 is not set
CONFIG_TR=y
CONFIG_IBMTR=y
# CONFIG_IBMOL is not set
# CONFIG_IBMLS is not set
CONFIG_3C359=y
CONFIG_TMS380TR=y
# CONFIG_TMSPCI is not set
# CONFIG_SKISA is not set
CONFIG_PROTEON=y
# CONFIG_ABYSS is not set
# CONFIG_MADGEMC is not set
# CONFIG_SMCTR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
CONFIG_IPW2100=y
# CONFIG_IPW2100_MONITOR is not set
# CONFIG_IPW2100_DEBUG is not set
CONFIG_IPW2200=y
# CONFIG_IPW2200_MONITOR is not set
CONFIG_IPW2200_QOS=y
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBERTAS=y
CONFIG_LIBERTAS_USB=y
CONFIG_LIBERTAS_DEBUG=y
CONFIG_AIRO=y
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=y
CONFIG_RTL8187=y
CONFIG_ADM8211=y
CONFIG_P54_COMMON=y
# CONFIG_P54_USB is not set
CONFIG_P54_PCI=y
CONFIG_IWLWIFI=y
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLWIFI_SENSITIVITY is not set
# CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT is not set
CONFIG_IWLWIFI_QOS=y
CONFIG_HOSTAP=y
# CONFIG_HOSTAP_FIRMWARE is not set
CONFIG_HOSTAP_PLX=y
# CONFIG_HOSTAP_PCI is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
CONFIG_RT2X00=y
CONFIG_RT2X00_LIB=y
CONFIG_RT2X00_LIB_PCI=y
CONFIG_RT2X00_LIB_RFKILL=y
CONFIG_RT2400PCI=y
CONFIG_RT2400PCI_RFKILL=y
# CONFIG_RT2500PCI is not set
# CONFIG_RT61PCI is not set
# CONFIG_RT2500USB is not set
# CONFIG_RT73USB is not set
CONFIG_RT2X00_DEBUG=y

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
CONFIG_ATM_TCP=y
CONFIG_ATM_LANAI=y
# CONFIG_ATM_ENI is not set
CONFIG_ATM_FIRESTREAM=y
# CONFIG_ATM_ZATM is not set
CONFIG_ATM_NICSTAR=y
CONFIG_ATM_NICSTAR_USE_SUNI=y
CONFIG_ATM_NICSTAR_USE_IDT77105=y
CONFIG_ATM_IDT77252=y
CONFIG_ATM_IDT77252_DEBUG=y
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
# CONFIG_ATM_AMBASSADOR is not set
CONFIG_ATM_HORIZON=y
CONFIG_ATM_HORIZON_DEBUG=y
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E_MAYBE is not set
CONFIG_ATM_HE=y
CONFIG_ATM_HE_USE_SUNI=y
# CONFIG_FDDI is not set
CONFIG_HIPPI=y
# CONFIG_ROADRUNNER is not set
# CONFIG_PPP is not set
CONFIG_SLIP=y
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_NET_FC=y
CONFIG_SHAPER=y
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

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
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_INPORT is not set
CONFIG_MOUSE_LOGIBM=y
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_UCB1400 is not set
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
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_MCA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_HW_RANDOM_VIA=y
CONFIG_NVRAM=y
CONFIG_RTC=y
CONFIG_DTLK=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=y
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
CONFIG_CS5535_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_RTC_IRQ=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
# CONFIG_I2C is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_HDAPS=y
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
CONFIG_DVB_CORE=y
CONFIG_DVB_CAPTURE_DRIVERS=y
CONFIG_DVB_TTUSB_DEC=y
CONFIG_DVB_CINERGYT2=y
CONFIG_DVB_CINERGYT2_TUNING=y
CONFIG_DVB_CINERGYT2_STREAM_URB_COUNT=32
CONFIG_DVB_CINERGYT2_STREAM_BUF_SIZE=512
CONFIG_DVB_CINERGYT2_QUERY_INTERVAL=250
CONFIG_DVB_CINERGYT2_ENABLE_RC_INPUT_DEVICE=y
CONFIG_DVB_CINERGYT2_RC_QUERY_INTERVAL=50

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
CONFIG_DVB_FE_CUSTOMISE=y

#
# DVB-S (satellite) frontends
#

#
# DVB-T (terrestrial) frontends
#

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#

#
# Tuners/PLL support
#

#
# Miscellaneous devices
#
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_DRM=y
CONFIG_DRM_TDFX=y
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_VIDEO_SELECT is not set
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_USB_HIDINPUT_POWERBOOK=y
CONFIG_HID_FF=y
# CONFIG_HID_PID is not set
CONFIG_LOGITECH_FF=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_ZEROPLUS_FF=y
# CONFIG_USB_HIDDEV is not set
CONFIG_USB_MOUSE=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
CONFIG_USB_PERSIST=y
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_SPLIT_ISO=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_SL811_HCD=y
CONFIG_USB_R8A66597_HCD=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
# CONFIG_USB_STORAGE_DATAFAB is not set
CONFIG_USB_STORAGE_FREECOM=y
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_DPCM=y
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
CONFIG_USB_STORAGE_SDDR55=y
# CONFIG_USB_STORAGE_JUMPSHOT is not set
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
# CONFIG_USB_MICROTEK is not set
CONFIG_USB_MON=y

#
# USB port drivers
#

#
# USB Serial Converter support
#
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=y
# CONFIG_USB_SERIAL_AIRPRIME is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
# CONFIG_USB_SERIAL_CP2101 is not set
CONFIG_USB_SERIAL_CYPRESS_M8=y
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=y
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=y
CONFIG_USB_SERIAL_KOBIL_SCT=y
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_HP4X is not set
CONFIG_USB_SERIAL_SAFE=y
CONFIG_USB_SERIAL_SAFE_PADDED=y
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
CONFIG_USB_SERIAL_XIRCOM=y
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=y
# CONFIG_USB_SERIAL_DEBUG is not set
CONFIG_USB_EZUSB=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y

#
# USB DSL modem support
#
# CONFIG_USB_ATM is not set

#
# USB Gadget Support
#
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
CONFIG_USB_GADGET_SELECTED=y
# CONFIG_USB_GADGET_AMD5536UDC is not set
# CONFIG_USB_GADGET_ATMEL_USBA is not set
# CONFIG_USB_GADGET_FSL_USB2 is not set
# CONFIG_USB_GADGET_NET2280 is not set
# CONFIG_USB_GADGET_PXA2XX is not set
# CONFIG_USB_GADGET_M66592 is not set
# CONFIG_USB_GADGET_GOKU is not set
# CONFIG_USB_GADGET_LH7A40X is not set
# CONFIG_USB_GADGET_OMAP is not set
# CONFIG_USB_GADGET_S3C2410 is not set
# CONFIG_USB_GADGET_AT91 is not set
CONFIG_USB_GADGET_DUMMY_HCD=y
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_ZERO=y
# CONFIG_USB_ETH is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FILE_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_MMC is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_NET48XX=y
CONFIG_LEDS_WRAP=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_AMSO1100 is not set
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_IPOIB is not set
# CONFIG_INFINIBAND_SRP is not set
CONFIG_INFINIBAND_ISER=y
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
# CONFIG_KVM_AMD is not set
CONFIG_LGUEST=y

#
# Userspace I/O
#
# CONFIG_UIO is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EFI_VARS is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4DEV_FS=y
CONFIG_EXT4DEV_FS_XATTR=y
# CONFIG_EXT4DEV_FS_POSIX_ACL is not set
CONFIG_EXT4DEV_FS_SECURITY=y
CONFIG_JBD=y
CONFIG_JBD2=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_INOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_QUOTA is not set
# CONFIG_DNOTIFY is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
# CONFIG_HFSPLUS_FS is not set
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
CONFIG_CRAMFS=y
# CONFIG_VXFS_FS is not set
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
CONFIG_NFSD=y
# CONFIG_NFSD_V3 is not set
# CONFIG_NFSD_TCP is not set
CONFIG_LOCKD=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
# CONFIG_SUNRPC_XPRT_RDMA is not set
# CONFIG_SUNRPC_BIND34 is not set
# CONFIG_RPCSEC_GSS_KRB5 is not set
# CONFIG_RPCSEC_GSS_SPKM3 is not set
CONFIG_SMB_FS=y
# CONFIG_SMB_NLS_DEFAULT is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
CONFIG_NCP_FS=y
# CONFIG_NCPFS_PACKET_SIGNING is not set
# CONFIG_NCPFS_IOCTL_LOCKING is not set
CONFIG_NCPFS_STRONG=y
# CONFIG_NCPFS_NFS_NS is not set
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set
# CONFIG_9P_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y
CONFIG_INSTRUMENTATION=y
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
# CONFIG_MARKERS is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
# CONFIG_DEBUG_SPINLOCK is not set
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_FRAME_POINTER is not set
CONFIG_FORCED_INLINING=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
CONFIG_SAMPLES=y
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_PAGEALLOC=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_4KSTACKS is not set
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_CAPABILITIES=y
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
# CONFIG_SECURITY_SELINUX_DEVELOP is not set
# CONFIG_SECURITY_SELINUX_AVC_STATS is not set
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_PCBC=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_XTS is not set
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_586 is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_HW is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_FORCE_MINIMAL_CONFIG=y
CONFIG_X86_32_ALWAYS_ON=y

--TB36FDmn/VVEgNH/--
