Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbXKNLUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbXKNLUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbXKNLUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:20:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41247 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbXKNLU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:20:29 -0500
Date: Wed, 14 Nov 2007 12:20:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Matt Mackall <mpm@selenic.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [bug] SLOB crash, 2.6.24-rc2
Message-ID: <20071114112001.GA13870@elte.hu>
References: <200711112058.28043.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <200711112058.28043.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


there's a new SLOB regression - the attached config crashes with:

[   61.245190] rc.sysinit used greatest stack depth: 1680 bytes left
[   61.386859] list_add corruption. prev->next should be next (407d973c), but was 418cf818. (prev=41877098).
[   61.396328] ------------[ cut here ]------------
[   61.400910] kernel BUG at lib/list_debug.c:33!
[   61.405330] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC

looks like memory corruption of some sort and it's reproducible. Picking 
CONFIG_SLUB makes the crash go away. Booting v2.6.23 with the same 
.config works fine.

bisection is difficult due to networking releated Kconfig problems: if i 
put my .24 .config into .23 then the network drivers get lost. (we 
should be more Kconfig-compatible between kernel releases, to ease 
bisection efforts)

(full bootlog and config attached)

	Ingo

--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="crash.log"

[    0.000000] Linux version 2.6.24-rc2 (mingo@dione) (gcc version 4.2.2) #183 Tue Nov 13 19:51:34 CET 2007
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
[    0.000000] using polling idle threads.
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 1023MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f5680
[    0.000000] Entering add_active_range(0, 0, 262128) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   262128
[    0.000000]   HighMem    262128 ->   262128
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   262128
[    0.000000] On node 0 totalpages: 262128
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 2015 pages used for memmap
[    0.000000]   Normal zone: 256017 pages, LIFO batch:31
[    0.000000]   HighMem zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] Using APIC driver default
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000] OEM ID: OEM00000 Product ID: PROD00000000 APIC at: 0xFEE00000
[    0.000000] Processor #0 15:3 APIC version 17
[    0.000000] Processor #1 15:3 APIC version 17
[    0.000000] WARNING: NR_CPUS limit of 1 reached.  Processor ignored.
[    0.000000] I/O APIC #2 Version 17 at 0xFEC00000.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Processors: 1
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260081
[    0.000000] Kernel command line: root=/dev/sda1 console=tty earlyprintk=serial,ttyS0,115200,keep 3 profile=0 debug initcall_debug enforcing=0 apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=2 lapic hpet=disable idle=mwait idle=poll
[    0.000000] kernel profiling enabled (shift: 0)
[    0.000000] debug: sysrq always enabled.
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=408b9000 soft=408b8000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2160.230 MHz processor.
[   12.709369] spurious 8259A interrupt: IRQ7.
[   12.714225] Console: colour VGA+ 80x25
[   12.717797] console [tty0] enabled
[   13.028437] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[   13.036147] ... MAX_LOCKDEP_SUBCLASSES:    8
[   13.040394] ... MAX_LOCK_DEPTH:          30
[   13.044553] ... MAX_LOCKDEP_KEYS:        2048
[   13.048886] ... CLASSHASH_SIZE:           1024
[   13.053306] ... MAX_LOCKDEP_ENTRIES:     8192
[   13.057639] ... MAX_LOCKDEP_CHAINS:      16384
[   13.062058] ... CHAINHASH_SIZE:          8192
[   13.066391]  memory used by lock dependency info: 1024 kB
[   13.071765]  per task-struct memory footprint: 1680 bytes
[   13.077423] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   13.084735] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   13.135019] Memory: 1006080k/1048512k available (5065k kernel code, 41924k reserved, 2555k data, 264k init, 0k highmem)
[   13.145691] virtual kernel memory layout:
[   13.145692]     fixmap  : 0xfffab000 - 0xfffff000   ( 336 kB)
[   13.145693]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   13.145694]     vmalloc : 0x80800000 - 0xff7fe000   (2031 MB)
[   13.145695]     lowmem  : 0x40000000 - 0x7fff0000   (1023 MB)
[   13.145696]       .init : 0x40873000 - 0x408b5000   ( 264 kB)
[   13.145697]       .data : 0x405f2549 - 0x408712a0   (2555 kB)
[   13.145698]       .text : 0x40100000 - 0x405f2549   (5065 kB)
[   13.189711] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   13.277811] Calibrating delay using timer specific routine.. 4324.65 BogoMIPS (lpj=8649306)
[   13.286050] Security Framework initialized
[   13.290084] SELinux:  Disabled at boot.
[   13.293895] Capability LSM initialized
[   13.297624] Mount-cache hash table entries: 512
[   13.302603] CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000 00000001 00000000 00000003 00000000
[   13.313135] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   13.320248] CPU: L2 Cache: 512K (64 bytes/line)
[   13.324755] CPU: After all inits, caps: 178bfbf7 e3d3fbff 00000000 00000410 00000001 00000000 00000003 00000000
[   13.334799] Intel machine check architecture supported.
[   13.340007] Intel machine check reporting enabled on CPU#0.
[   13.345556] Compat vDSO mapped to ffffe000.
[   13.349719] CPU: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[   13.356639] Checking 'hlt' instruction... OK.
[   13.374982] Freeing SMP alternatives: 0k freed
[   13.379487] enabled ExtINT on CPU#0
[   13.382914] ExtINT not setup in hardware but reported by MP table
[   13.389012] ENABLING IO-APIC IRQs
[   13.392211] init IO_APIC IRQs
[   13.395158]  IO-APIC (apicid-pin) 2-0 not connected.
[   13.400163]  IO-APIC (apicid-pin) 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
[   13.408882] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
[   13.454318] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[   13.460015] ...trying to set up timer (IRQ0) through the 8259A ... 
[   13.466082] ..... (found pin 0) ...works.
[   13.509860] number of MP IRQ sources: 17.
[   13.513845] number of IO-APIC #2 registers: 24.
[   13.518352] testing the IO APIC.......................
[   13.523468] IO APIC #2......
[   13.526324] .... register #00: 00000000
[   13.530137] .......    : physical APIC id: 00
[   13.534470] .......    : Delivery Type: 0
[   13.538458] .......    : LTS          : 0
[   13.542444] .... register #01: 00170011
[   13.546257] .......     : max redirection entries: 0017
[   13.551456] .......     : PRQ implemented: 0
[   13.555703] .......     : IO APIC version: 0011
[   13.560209] .... register #02: 00000000
[   13.564022] .......     : arbitration: 00
[   13.568008] .... IRQ redirection table:
[   13.571822]  NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
[   13.577890]  00 001 01  0    0    0   0   0    1    1    31
[   13.583437]  01 001 01  0    0    0   0   0    1    1    39
[   13.588983]  02 000 00  1    0    0   0   0    0    0    00
[   13.594530]  03 001 01  1    1    0   1   0    1    1    41
[   13.600076]  04 001 01  0    0    0   0   0    1    1    49
[   13.605617]  05 001 01  1    1    0   1   0    1    1    51
[   13.611170]  06 001 01  0    0    0   0   0    1    1    59
[   13.616715]  07 001 01  1    0    0   0   0    1    1    61
[   13.622261]  08 001 01  0    0    0   0   0    1    1    69
[   13.627808]  09 001 01  0    0    0   0   0    1    1    71
[   13.633348]  0a 001 01  0    0    0   0   0    1    1    79
[   13.638899]  0b 001 01  1    1    0   1   0    1    1    81
[   13.644447]  0c 001 01  0    0    0   0   0    1    1    89
[   13.649992]  0d 001 01  0    0    0   0   0    1    1    91
[   13.655539]  0e 001 01  0    0    0   0   0    1    1    99
[   13.661081]  0f 001 01  0    0    0   0   0    1    1    A1
[   13.666632]  10 000 00  1    0    0   0   0    0    0    00
[   13.672178]  11 000 00  1    0    0   0   0    0    0    00
[   13.677719]  12 000 00  1    0    0   0   0    0    0    00
[   13.683271]  13 000 00  1    0    0   0   0    0    0    00
[   13.688817]  14 000 00  1    0    0   0   0    0    0    00
[   13.694363]  15 000 00  1    0    0   0   0    0    0    00
[   13.699909]  16 000 00  1    0    0   0   0    0    0    00
[   13.705451]  17 000 00  1    0    0   0   0    0    0    00
[   13.710999] IRQ to pin mappings:
[   13.714206] IRQ0 -> 0:0
[   13.716628] IRQ1 -> 0:1
[   13.719054] IRQ3 -> 0:3
[   13.721481] IRQ4 -> 0:4
[   13.723907] IRQ5 -> 0:5
[   13.726334] IRQ6 -> 0:6
[   13.728760] IRQ7 -> 0:7
[   13.731187] IRQ8 -> 0:8
[   13.733613] IRQ9 -> 0:9
[   13.736039] IRQ10 -> 0:10
[   13.738640] IRQ11 -> 0:11
[   13.741240] IRQ12 -> 0:12
[   13.743839] IRQ13 -> 0:13
[   13.746439] IRQ14 -> 0:14
[   13.749038] IRQ15 -> 0:15
[   13.751639] .................................... done.
[   13.756757] Using local APIC timer interrupts.
[   13.756758] calibrating APIC timer ...
[   13.869803] ... lapic delta = 1350196
[   13.873338] ... PM timer delta = 0
[   13.876717] ..... delta 1350196
[   13.879837] ..... mult: 57986852
[   13.883043] ..... calibration result: 864125
[   13.887290] ..... CPU clock speed is 2160.1256 MHz.
[   13.892143] ..... host bus clock speed is 216.0125 MHz.
[   13.897342] ... verify APIC timer
[   14.008634] ... jiffies delta = 25
[   14.011913] ... jiffies result ok
[   14.015587] khelper used greatest stack depth: 3144 bytes left
[   14.021462] Calling initcall 0x408936eb: init_cpufreq_transition_notifier_list+0x0/0xd()
[   14.029390] initcall 0x408936eb: init_cpufreq_transition_notifier_list+0x0/0xd() returned 0.
[   14.037794] initcall 0x408936eb ran for 0 msecs: init_cpufreq_transition_notifier_list+0x0/0xd()
[   14.047009] Calling initcall 0x40896946: net_ns_init+0x0/0xd0()
[   14.052900] net_namespace: 80 bytes
[   14.056405] initcall 0x40896946: net_ns_init+0x0/0xd0() returned 0.
[   14.062606] initcall 0x40896946 ran for 3 msecs: net_ns_init+0x0/0xd0()
[   14.069194] Calling initcall 0x408780e2: cpufreq_tsc+0x0/0xc()
[   14.074998] initcall 0x408780e2: cpufreq_tsc+0x0/0xc() returned 0.
[   14.081151] initcall 0x408780e2 ran for 0 msecs: cpufreq_tsc+0x0/0xc()
[   14.087653] Calling initcall 0x4087c6c6: reboot_init+0x0/0xd()
[   14.093459] initcall 0x4087c6c6: reboot_init+0x0/0xd() returned 0.
[   14.099612] initcall 0x4087c6c6 ran for 0 msecs: reboot_init+0x0/0xd()
[   14.106109] Calling initcall 0x40881007: print_banner+0x0/0x9()
[   14.112002] Booting paravirtualized kernel on bare hardware
[   14.117551] initcall 0x40881007: print_banner+0x0/0x9() returned 0.
[   14.123791] initcall 0x40881007 ran for 3 msecs: print_banner+0x0/0x9()
[   14.130375] Calling initcall 0x40882703: sysctl_init+0x0/0x19()
[   14.136708] initcall 0x40882703: sysctl_init+0x0/0x19() returned 0.
[   14.142819] initcall 0x40882703 ran for 0 msecs: sysctl_init+0x0/0x19()
[   14.149406] Calling initcall 0x40883253: init_jiffies_clocksource+0x0/0xa()
[   14.156344] initcall 0x40883253: init_jiffies_clocksource+0x0/0xa() returned 0.
[   14.163620] initcall 0x40883253 ran for 0 msecs: init_jiffies_clocksource+0x0/0xa()
[   14.171246] Calling initcall 0x408834e9: pm_init+0x0/0x1e()
[   14.176798] initcall 0x408834e9: pm_init+0x0/0x1e() returned 0.
[   14.182684] initcall 0x408834e9 ran for 0 msecs: pm_init+0x0/0x1e()
[   14.188925] Calling initcall 0x40883de3: ksysfs_init+0x0/0x46()
[   14.194830] initcall 0x40883de3: ksysfs_init+0x0/0x46() returned 0.
[   14.201055] initcall 0x40883de3 ran for 0 msecs: ksysfs_init+0x0/0x46()
[   14.207644] Calling initcall 0x40885bde: filelock_init+0x0/0x2d()
[   14.213708] initcall 0x40885bde: filelock_init+0x0/0x2d() returned 0.
[   14.220123] initcall 0x40885bde ran for 0 msecs: filelock_init+0x0/0x2d()
[   14.226880] Calling initcall 0x408862ff: init_aout_binfmt+0x0/0xa()
[   14.233127] initcall 0x408862ff: init_aout_binfmt+0x0/0xa() returned 0.
[   14.239709] initcall 0x408862ff ran for 0 msecs: init_aout_binfmt+0x0/0xa()
[   14.246639] Calling initcall 0x40886309: init_script_binfmt+0x0/0xa()
[   14.253053] initcall 0x40886309: init_script_binfmt+0x0/0xa() returned 0.
[   14.259814] initcall 0x40886309 ran for 0 msecs: init_script_binfmt+0x0/0xa()
[   14.266918] Calling initcall 0x40886313: init_elf_binfmt+0x0/0xa()
[   14.273071] initcall 0x40886313: init_elf_binfmt+0x0/0xa() returned 0.
[   14.279573] initcall 0x40886313 ran for 0 msecs: init_elf_binfmt+0x0/0xa()
[   14.286416] Calling initcall 0x40887f6a: debugfs_init+0x0/0x39()
[   14.292482] initcall 0x40887f6a: debugfs_init+0x0/0x39() returned 0.
[   14.298722] initcall 0x40887f6a ran for 0 msecs: debugfs_init+0x0/0x39()
[   14.305396] Calling initcall 0x408880f3: securityfs_init+0x0/0x39()
[   14.311709] initcall 0x408880f3: securityfs_init+0x0/0x39() returned 0.
[   14.318222] initcall 0x408880f3 ran for 0 msecs: securityfs_init+0x0/0x39()
[   14.325157] Calling initcall 0x40888c91: random32_init+0x0/0x13()
[   14.331223] initcall 0x40888c91: random32_init+0x0/0x13() returned 0.
[   14.337633] initcall 0x40888c91 ran for 0 msecs: random32_init+0x0/0x13()
[   14.344395] Calling initcall 0x408936f8: cpufreq_core_init+0x0/0x21()
[   14.350806] initcall 0x408936f8: cpufreq_core_init+0x0/0x21() returned 0.
[   14.357565] initcall 0x408936f8 ran for 0 msecs: cpufreq_core_init+0x0/0x21()
[   14.364674] Calling initcall 0x40893776: cpuidle_init+0x0/0x14()
[   14.370659] initcall 0x40893776: cpuidle_init+0x0/0x14() returned 0.
[   14.376977] initcall 0x40893776 ran for 0 msecs: cpuidle_init+0x0/0x14()
[   14.383652] Calling initcall 0x40896826: sock_init+0x0/0x57()
[   14.389417] initcall 0x40896826: sock_init+0x0/0x57() returned 0.
[   14.395439] initcall 0x40896826 ran for 0 msecs: sock_init+0x0/0x57()
[   14.401849] Calling initcall 0x408971b3: netpoll_init+0x0/0x35()
[   14.407829] initcall 0x408971b3: netpoll_init+0x0/0x35() returned 0.
[   14.414155] initcall 0x408971b3 ran for 0 msecs: netpoll_init+0x0/0x35()
[   14.420831] Calling initcall 0x408975ab: netlink_proto_init+0x0/0x10e()
[   14.427441] NET: Registered protocol family 16
[   14.431860] initcall 0x408975ab: netlink_proto_init+0x0/0x10e() returned 0.
[   14.438767] initcall 0x408975ab ran for 3 msecs: netlink_proto_init+0x0/0x10e()
[   14.446046] Calling initcall 0x40888bcd: kobject_uevent_init+0x0/0x50()
[   14.452639] initcall 0x40888bcd: kobject_uevent_init+0x0/0x50() returned 0.
[   14.459568] initcall 0x40888bcd ran for 0 msecs: kobject_uevent_init+0x0/0x50()
[   14.466845] Calling initcall 0x40888dc2: pcibus_class_init+0x0/0xa()
[   14.473262] initcall 0x40888dc2: pcibus_class_init+0x0/0xa() returned 0.
[   14.479855] initcall 0x40888dc2 ran for 0 msecs: pcibus_class_init+0x0/0xa()
[   14.486863] Calling initcall 0x40889246: pci_driver_init+0x0/0xa()
[   14.493104] initcall 0x40889246: pci_driver_init+0x0/0xa() returned 0.
[   14.499527] initcall 0x40889246 ran for 0 msecs: pci_driver_init+0x0/0xa()
[   14.506362] Calling initcall 0x408895f1: lcd_class_init+0x0/0x41()
[   14.512594] initcall 0x408895f1: lcd_class_init+0x0/0x41() returned 0.
[   14.519015] initcall 0x408895f1 ran for 0 msecs: lcd_class_init+0x0/0x41()
[   14.525861] Calling initcall 0x40889632: backlight_class_init+0x0/0x41()
[   14.532608] initcall 0x40889632: backlight_class_init+0x0/0x41() returned 0.
[   14.539566] initcall 0x40889632 ran for 0 msecs: backlight_class_init+0x0/0x41()
[   14.546920] Calling initcall 0x4088af98: video_output_class_init+0x0/0xa()
[   14.553845] initcall 0x4088af98: video_output_class_init+0x0/0xa() returned 0.
[   14.560960] initcall 0x4088af98 ran for 0 msecs: video_output_class_init+0x0/0xa()
[   14.568502] Calling initcall 0x4088b064: tty_class_init+0x0/0x1f()
[   14.574725] initcall 0x4088b064: tty_class_init+0x0/0x1f() returned 0.
[   14.581151] initcall 0x4088b064 ran for 0 msecs: tty_class_init+0x0/0x1f()
[   14.588000] Calling initcall 0x4088bac7: vtconsole_class_init+0x0/0xb1()
[   14.594854] initcall 0x4088bac7: vtconsole_class_init+0x0/0xb1() returned 0.
[   14.601741] initcall 0x4088bac7 ran for 0 msecs: vtconsole_class_init+0x0/0xb1()
[   14.609110] Calling initcall 0x40877fbe: init_pit_clocksource+0x0/0x49()
[   14.615790] initcall 0x40877fbe: init_pit_clocksource+0x0/0x49() returned 0.
[   14.622800] initcall 0x40877fbe ran for 0 msecs: init_pit_clocksource+0x0/0x49()
[   14.630167] Calling initcall 0x4087b495: mtrr_if_init+0x0/0x54()
[   14.636148] initcall 0x4087b495: mtrr_if_init+0x0/0x54() returned 0.
[   14.642472] initcall 0x4087b495 ran for 0 msecs: mtrr_if_init+0x0/0x54()
[   14.649148] Calling initcall 0x4087f675: kdump_buf_page_init+0x0/0x35()
[   14.655734] initcall 0x4087f675: kdump_buf_page_init+0x0/0x35() returned 0.
[   14.662665] initcall 0x4087f675 ran for 0 msecs: kdump_buf_page_init+0x0/0x35()
[   14.669947] Calling initcall 0x4089467d: dmi_id_init+0x0/0x265()
[   14.676140] initcall 0x4089467d: dmi_id_init+0x0/0x265() returned 0.
[   14.682337] initcall 0x4089467d ran for 0 msecs: dmi_id_init+0x0/0x265()
[   14.689013] Calling initcall 0x408948e2: init_cyclone_clocksource+0x0/0x17c()
[   14.696116] initcall 0x408948e2: init_cyclone_clocksource+0x0/0x17c() returned -19.
[   14.703744] initcall 0x408948e2 ran for 0 msecs: init_cyclone_clocksource+0x0/0x17c()
[   14.711544] Calling initcall 0x40895bc3: pci_access_init+0x0/0x2a()
[   14.722364] PCI: PCI BIOS revision 3.00 entry at 0xf21d0, last bus=5
[   14.728590] initcall 0x40895bc3: pci_access_init+0x0/0x2a() returned 0.
[   14.735175] initcall 0x40895bc3 ran for 7 msecs: pci_access_init+0x0/0x2a()
[   14.742107] Calling initcall 0x408777f8: request_standard_resources+0x0/0x2f9()
[   14.749387] Setting up standard PCI resources
[   14.756541] initcall 0x408777f8: request_standard_resources+0x0/0x2f9() returned 0.
[   14.764035] initcall 0x408777f8 ran for 7 msecs: request_standard_resources+0x0/0x2f9()
[   14.772007] Calling initcall 0x40877ef8: topology_init+0x0/0xa()
[   14.778072] initcall 0x40877ef8: topology_init+0x0/0xa() returned 0.
[   14.784331] initcall 0x40877ef8 ran for 0 msecs: topology_init+0x0/0xa()
[   14.790984] Calling initcall 0x4087b220: mtrr_init_finialize+0x0/0x28()
[   14.797571] initcall 0x4087b220: mtrr_init_finialize+0x0/0x28() returned 0.
[   14.804503] initcall 0x4087b220 ran for 0 msecs: mtrr_init_finialize+0x0/0x28()
[   14.811785] Calling initcall 0x4087c701: mca_init+0x0/0x2bd()
[   14.817599] initcall 0x4087c701: mca_init+0x0/0x2bd() returned -19.
[   14.823752] initcall 0x4087c701 ran for 0 msecs: mca_init+0x0/0x2bd()
[   14.830155] Calling initcall 0x40882c7a: param_sysfs_init+0x0/0x13d()
[   14.838040] khelper used greatest stack depth: 3092 bytes left
[   14.856291] initcall 0x40882c7a: param_sysfs_init+0x0/0x13d() returned 0.
[   14.862921] initcall 0x40882c7a ran for 15 msecs: param_sysfs_init+0x0/0x13d()
[   14.870114] Calling initcall 0x40141164: pm_sysrq_init+0x0/0x12()
[   14.876191] initcall 0x40141164: pm_sysrq_init+0x0/0x12() returned 0.
[   14.882593] initcall 0x40141164 ran for 0 msecs: pm_sysrq_init+0x0/0x12()
[   14.889355] Calling initcall 0x408858f4: readahead_init+0x0/0xa()
[   14.895420] initcall 0x408858f4: readahead_init+0x0/0xa() returned 0.
[   14.901832] initcall 0x408858f4 ran for 0 msecs: readahead_init+0x0/0xa()
[   14.908595] Calling initcall 0x408861ce: init_bio+0x0/0xb6()
[   14.914285] initcall 0x408861ce: init_bio+0x0/0xb6() returned 0.
[   14.920207] initcall 0x408861ce ran for 0 msecs: init_bio+0x0/0xb6()
[   14.926530] Calling initcall 0x408888dc: genhd_device_init+0x0/0x4c()
[   14.933002] initcall 0x408888dc: genhd_device_init+0x0/0x4c() returned 0.
[   14.939715] initcall 0x408888dc ran for 0 msecs: genhd_device_init+0x0/0x4c()
[   14.946810] Calling initcall 0x408894f2: fbmem_init+0x0/0x86()
[   14.952748] initcall 0x408894f2: fbmem_init+0x0/0x86() returned 0.
[   14.958768] initcall 0x408894f2 ran for 0 msecs: fbmem_init+0x0/0x86()
[   14.965268] Calling initcall 0x4088b612: misc_init+0x0/0x78()
[   14.971106] initcall 0x4088b612: misc_init+0x0/0x78() returned 0.
[   14.977055] initcall 0x4088b612 ran for 0 msecs: misc_init+0x0/0x78()
[   14.983469] Calling initcall 0x4088f2e5: init_scsi+0x0/0x8c()
[   14.989702] SCSI subsystem initialized
[   14.993325] initcall 0x4088f2e5: init_scsi+0x0/0x8c() returned 0.
[   14.999390] initcall 0x4088f2e5 ran for 3 msecs: init_scsi+0x0/0x8c()
[   15.005800] Calling initcall 0x4088fd88: ata_init+0x0/0x79()
[   15.011522] libata version 3.00 loaded.
[   15.015249] initcall 0x4088fd88: ata_init+0x0/0x79() returned 0.
[   15.021225] initcall 0x4088fd88 ran for 3 msecs: ata_init+0x0/0x79()
[   15.027554] Calling initcall 0x40890000: init_pcmcia_cs+0x0/0x2d()
[   15.033821] initcall 0x40890000: init_pcmcia_cs+0x0/0x2d() returned 0.
[   15.040207] initcall 0x40890000 ran for 0 msecs: init_pcmcia_cs+0x0/0x2d()
[   15.047050] Calling initcall 0x40890115: usb_init+0x0/0x10a()
[   15.053164] usbcore: registered new interface driver usbfs
[   15.058741] usbcore: registered new interface driver hub
[   15.064106] usbcore: registered new device driver usb
[   15.069033] initcall 0x40890115: usb_init+0x0/0x10a() returned 0.
[   15.075095] initcall 0x40890115 ran for 11 msecs: usb_init+0x0/0x10a()
[   15.081594] Calling initcall 0x40890c0b: serio_init+0x0/0x91()
[   15.087562] initcall 0x40890c0b: serio_init+0x0/0x91() returned 0.
[   15.093587] initcall 0x40890c0b ran for 0 msecs: serio_init+0x0/0x91()
[   15.100090] Calling initcall 0x40890efc: gameport_init+0x0/0x91()
[   15.106763] initcall 0x40890efc: gameport_init+0x0/0x91() returned 0.
[   15.113043] initcall 0x40890efc ran for 0 msecs: gameport_init+0x0/0x91()
[   15.119805] Calling initcall 0x4089122e: input_init+0x0/0xf9()
[   15.125743] initcall 0x4089122e: input_init+0x0/0xf9() returned 0.
[   15.131774] initcall 0x4089122e ran for 0 msecs: input_init+0x0/0xf9()
[   15.138261] Calling initcall 0x40891abf: i2c_init+0x0/0x19()
[   15.144106] initcall 0x40891abf: i2c_init+0x0/0x19() returned 0.
[   15.149952] initcall 0x40891abf ran for 0 msecs: i2c_init+0x0/0x19()
[   15.156281] Calling initcall 0x40891b72: power_supply_class_init+0x0/0x25()
[   15.163316] initcall 0x40891b72: power_supply_class_init+0x0/0x25() returned 0.
[   15.170491] initcall 0x40891b72 ran for 0 msecs: power_supply_class_init+0x0/0x25()
[   15.178122] Calling initcall 0x40891b97: hwmon_init+0x0/0x33()
[   15.184034] initcall 0x40891b97: hwmon_init+0x0/0x33() returned 0.
[   15.190076] initcall 0x40891b97 ran for 0 msecs: hwmon_init+0x0/0x33()
[   15.196578] Calling initcall 0x408937ae: leds_init+0x0/0x1f()
[   15.202398] initcall 0x408937ae: leds_init+0x0/0x1f() returned 0.
[   15.208372] initcall 0x408937ae ran for 0 msecs: leds_init+0x0/0x1f()
[   15.214774] Calling initcall 0x408958f3: ac97_bus_init+0x0/0xa()
[   15.220861] initcall 0x408958f3: ac97_bus_init+0x0/0xa() returned 0.
[   15.227081] initcall 0x408958f3 ran for 0 msecs: ac97_bus_init+0x0/0xa()
[   15.233756] Calling initcall 0x40895e78: pci_legacy_init+0x0/0xe3()
[   15.239993] PCI: Probing PCI hardware
[   15.243655] PCI: Probing PCI hardware (bus 00)
[   15.251798] PCI: Transparent bridge - 0000:00:09.0
[   15.261584] initcall 0x40895e78: pci_legacy_init+0x0/0xe3() returned 0.
[   15.268048] initcall 0x40895e78 ran for 19 msecs: pci_legacy_init+0x0/0xe3()
[   15.275068] Calling initcall 0x40896328: pcibios_irq_init+0x0/0x481()
[   15.281737] PCI: Using IRQ router default [10de/005e] at 0000:00:00.0
[   15.288095] PCI->APIC IRQ transform: 0000:00:04.0[A] -> IRQ 3
[   15.293785] PCI->APIC IRQ transform: 0000:00:0a.0[A] -> IRQ 11
[   15.299619] PCI->APIC IRQ transform: 0000:05:07.0[A] -> IRQ 11
[   15.305390] PCI->APIC IRQ transform: 0000:01:00.0[A] -> IRQ 5
[   15.311108] initcall 0x40896328: pcibios_irq_init+0x0/0x481() returned 0.
[   15.317861] initcall 0x40896328 ran for 19 msecs: pcibios_irq_init+0x0/0x481()
[   15.325056] Calling initcall 0x408967a9: pcibios_init+0x0/0x7d()
[   15.384730] initcall 0x408967a9: pcibios_init+0x0/0x7d() returned 0.
[   15.390924] initcall 0x408967a9 ran for 53 msecs: pcibios_init+0x0/0x7d()
[   15.397685] Calling initcall 0x408968ce: proto_init+0x0/0x28()
[   15.403492] initcall 0x408968ce: proto_init+0x0/0x28() returned 0.
[   15.409644] initcall 0x408968ce ran for 0 msecs: proto_init+0x0/0x28()
[   15.416143] Calling initcall 0x40896ba1: net_dev_init+0x0/0x11b()
[   15.422323] initcall 0x40896ba1: net_dev_init+0x0/0x11b() returned 0.
[   15.428637] initcall 0x40896ba1 ran for 0 msecs: net_dev_init+0x0/0x11b()
[   15.435400] Calling initcall 0x40896cf0: neigh_init+0x0/0x79()
[   15.441203] initcall 0x40896cf0: neigh_init+0x0/0x79() returned 0.
[   15.447358] initcall 0x40896cf0 ran for 0 msecs: neigh_init+0x0/0x79()
[   15.453858] Calling initcall 0x408971e8: fib_rules_init+0x0/0x53()
[   15.460010] initcall 0x408971e8: fib_rules_init+0x0/0x53() returned 0.
[   15.466508] initcall 0x408971e8 ran for 0 msecs: fib_rules_init+0x0/0x53()
[   15.473360] Calling initcall 0x408976b9: genl_init+0x0/0xc3()
[   15.491206] initcall 0x408976b9: genl_init+0x0/0xc3() returned 0.
[   15.497146] initcall 0x408976b9 ran for 15 msecs: genl_init+0x0/0xc3()
[   15.503645] Calling initcall 0x40899665: cipso_v4_init+0x0/0x77()
[   15.509725] initcall 0x40899665: cipso_v4_init+0x0/0x77() returned 0.
[   15.516124] initcall 0x40899665 ran for 0 msecs: cipso_v4_init+0x0/0x77()
[   15.522884] Calling initcall 0x40899b68: bt_init+0x0/0x53()
[   15.528427] Bluetooth: Core ver 2.11
[   15.532324] NET: Registered protocol family 31
[   15.536641] Bluetooth: HCI device and connection manager initialized
[   15.542981] Bluetooth: HCI socket layer initialized
[   15.547819] initcall 0x40899b68: bt_init+0x0/0x53() returned 0.
[   15.553710] initcall 0x40899b68 ran for 15 msecs: bt_init+0x0/0x53()
[   15.560036] Calling initcall 0x4089a4ba: wireless_nlevent_init+0x0/0x35()
[   15.566793] initcall 0x4089a4ba: wireless_nlevent_init+0x0/0x35() returned 0.
[   15.573902] initcall 0x4089a4ba ran for 0 msecs: wireless_nlevent_init+0x0/0x35()
[   15.581357] Calling initcall 0x405cdd18: cfg80211_init+0x0/0x38()
[   15.587625] initcall 0x405cdd18: cfg80211_init+0x0/0x38() returned 0.
[   15.593911] initcall 0x405cdd18 ran for 0 msecs: cfg80211_init+0x0/0x38()
[   15.600671] Calling initcall 0x4089a5cc: netlbl_init+0x0/0x70()
[   15.606561] NetLabel: Initializing
[   15.609946] NetLabel:  domain hash size = 128
[   15.614281] NetLabel:  protocols = UNLABELED CIPSOv4
[   15.619288] NetLabel:  unlabeled traffic allowed by default
[   15.624766] initcall 0x4089a5cc: netlbl_init+0x0/0x70() returned 0.
[   15.631000] initcall 0x4089a5cc ran for 15 msecs: netlbl_init+0x0/0x70()
[   15.637675] Calling initcall 0x40883195: clocksource_done_booting+0x0/0xd()
[   15.644606] initcall 0x40883195<6>Time: tsc clocksource has been installed.
[   15.651550] : clocksource_done_booting+0x0/0xd() returned 0.
[   15.657174] initcall 0x40883195 ran for 0 msecs: clocksource_done_booting+0x0/0xd()
[   15.664802] Calling initcall 0x40885b74: init_pipe_fs+0x0/0x3d()
[   15.670818] initcall 0x40885b74: init_pipe_fs+0x0/0x3d() returned 0.
[   15.677107] initcall 0x40885b74 ran for 0 msecs: init_pipe_fs+0x0/0x3d()
[   15.683779] Calling initcall 0x4088afa2: chr_dev_init+0x0/0x97()
[   15.690997] initcall 0x4088afa2: chr_dev_init+0x0/0x97() returned 0.
[   15.697195] initcall 0x4088afa2 ran for 1 msecs: chr_dev_init+0x0/0x97()
[   15.703867] Calling initcall 0x4088edc5: firmware_class_init+0x0/0x63()
[   15.710553] initcall 0x4088edc5: firmware_class_init+0x0/0x63() returned 0.
[   15.717387] initcall 0x4088edc5 ran for 0 msecs: firmware_class_init+0x0/0x63()
[   15.724666] Calling initcall 0x4088efd3: loopback_init+0x0/0xa()
[   15.730971] initcall 0x4088efd3: loopback_init+0x0/0xa() returned 0.
[   15.737171] initcall 0x4088efd3 ran for 0 msecs: loopback_init+0x0/0xa()
[   15.743843] Calling initcall 0x4089002d: init_pcmcia_bus+0x0/0x73()
[   15.750207] initcall 0x4089002d: init_pcmcia_bus+0x0/0x73() returned 0.
[   15.756667] initcall 0x4089002d ran for 0 msecs: init_pcmcia_bus+0x0/0x73()
[   15.763602] Calling initcall 0x40893719: cpufreq_gov_performance_init+0x0/0xa()
[   15.770890] initcall 0x40893719: cpufreq_gov_performance_init+0x0/0xa() returned 0.
[   15.778506] initcall 0x40893719 ran for 0 msecs: cpufreq_gov_performance_init+0x0/0xa()
[   15.786484] Calling initcall 0x40893723: cpufreq_gov_userspace_init+0x0/0xa()
[   15.793586] initcall 0x40893723: cpufreq_gov_userspace_init+0x0/0xa() returned 0.
[   15.801041] initcall 0x40893723 ran for 0 msecs: cpufreq_gov_userspace_init+0x0/0xa()
[   15.808842] Calling initcall 0x40894a5e: ssb_modinit+0x0/0x56()
[   15.814989] initcall 0x40894a5e: ssb_modinit+0x0/0x56() returned 0.
[   15.821103] initcall 0x40894a5e ran for 0 msecs: ssb_modinit+0x0/0x56()
[   15.827688] Calling initcall 0x40895953: pcibios_assign_resources+0x0/0x72()
[   15.834755] PCI: Bridge: 0000:00:09.0
[   15.838355]   IO window: c000-cfff
[   15.841743]   MEM window: da000000-da0fffff
[   15.845897]   PREFETCH window: disabled.
[   15.849803] PCI: Bridge: 0000:00:0b.0
[   15.853430]   IO window: disabled.
[   15.856822]   MEM window: disabled.
[   15.860281]   PREFETCH window: disabled.
[   15.864189] PCI: Bridge: 0000:00:0c.0
[   15.867815]   IO window: disabled.
[   15.871208]   MEM window: disabled.
[   15.874667]   PREFETCH window: disabled.
[   15.878575] PCI: Bridge: 0000:00:0d.0
[   15.882201]   IO window: disabled.
[   15.885593]   MEM window: disabled.
[   15.889055]   PREFETCH window: disabled.
[   15.892963] PCI: Bridge: 0000:00:0e.0
[   15.896588]   IO window: b000-bfff
[   15.899979]   MEM window: d8000000-d9ffffff
[   15.904134]   PREFETCH window: d0000000-d7ffffff
[   15.908761] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   15.915008] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   15.921247] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   15.927487] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   15.933726] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   15.939923] initcall 0x40895953: pcibios_assign_resources+0x0/0x72() returned 0.
[   15.947281] initcall 0x40895953 ran for 100 msecs: pcibios_assign_resources+0x0/0x72()
[   15.955169] Calling initcall 0x40898354: inet_init+0x0/0x2a8()
[   15.960977] NET: Registered protocol family 2
[   16.003289] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   16.010854] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[   16.019611] TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
[   16.031732] TCP: Hash tables configured (established 131072 bind 65536)
[   16.038249] TCP reno registered
[   16.051242] initcall 0x40898354: inet_init+0x0/0x2a8() returned 0.
[   16.057263] initcall 0x40898354 ran for 86 msecs: inet_init+0x0/0x2a8()
[   16.063849] Calling initcall 0x40876107: populate_rootfs+0x0/0x10d()
[   16.070507] initcall 0x40876107: populate_rootfs+0x0/0x10d() returned 0.
[   16.077048] initcall 0x40876107 ran for 0 msecs: populate_rootfs+0x0/0x10d()
[   16.084066] Calling initcall 0x408770ed: i8259A_init_sysfs+0x0/0x19()
[   16.090717] initcall 0x408770ed: i8259A_init_sysfs+0x0/0x19() returned 0.
[   16.097343] initcall 0x408770ed ran for 0 msecs: i8259A_init_sysfs+0x0/0x19()
[   16.104449] Calling initcall 0x408771c8: sbf_init+0x0/0xc7()
[   16.110080] initcall 0x408771c8: sbf_init+0x0/0xc7() returned 0.
[   16.116062] initcall 0x408771c8 ran for 0 msecs: sbf_init+0x0/0xc7()
[   16.122389] Calling initcall 0x40877edf: i8237A_init_sysfs+0x0/0x19()
[   16.128998] initcall 0x40877edf: i8237A_init_sysfs+0x0/0x19() returned 0.
[   16.135648] initcall 0x40877edf ran for 0 msecs: i8237A_init_sysfs+0x0/0x19()
[   16.142737] Calling initcall 0x40878506: cache_sysfs_init+0x0/0x1fd()
[   16.149588] initcall 0x40878506: cache_sysfs_init+0x0/0x1fd() returned 0.
[   16.156238] initcall 0x40878506 ran for 0 msecs: cache_sysfs_init+0x0/0x1fd()
[   16.163330] Calling initcall 0x4087b1c9: thermal_throttle_init_device+0x0/0x57()
[   16.170691] initcall 0x4087b1c9: thermal_throttle_init_device+0x0/0x57() returned 0.
[   16.178404] initcall 0x4087b1c9 ran for 0 msecs: thermal_throttle_init_device+0x0/0x57()
[   16.186469] Calling initcall 0x4087c3d7: eps_init+0x0/0x35()
[   16.192097] initcall 0x4087c3d7: eps_init+0x0/0x35() returned -19.
[   16.198249] initcall 0x4087c3d7 ran for 0 msecs: eps_init+0x0/0x35()
[   16.204578] Calling initcall 0x4087c40c: speedstep_init+0x0/0x19f()
[   16.210816] initcall 0x4087c40c: speedstep_init+0x0/0x19f() returned -19.
[   16.218011] initcall 0x4087c40c ran for 0 msecs: speedstep_init+0x0/0x19f()
[   16.224946] Calling initcall 0x4087c5ab: speedstep_init+0x0/0xa3()
[   16.231094] initcall 0x4087c5ab: speedstep_init+0x0/0xa3() returned -19.
[   16.237769] initcall 0x4087c5ab ran for 0 msecs: speedstep_init+0x0/0xa3()
[   16.244615] Calling initcall 0x4087c9be: msr_init+0x0/0xb7()
[   16.250470] initcall 0x4087c9be: msr_init+0x0/0xb7() returned 0.
[   16.256355] initcall 0x4087c9be ran for 0 msecs: msr_init+0x0/0xb7()
[   16.262647] Calling initcall 0x4087ca75: microcode_init+0x0/0x95()
[   16.269164] microcode: CPU0 not a capable Intel processor
[   16.274441] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   16.281735] initcall 0x4087ca75: microcode_init+0x0/0x95() returned 0.
[   16.288214] initcall 0x4087ca75 ran for 12 msecs: microcode_init+0x0/0x95()
[   16.295145] Calling initcall 0x4087d571: init_lapic_sysfs+0x0/0x29()
[   16.301663] initcall 0x4087d571: init_lapic_sysfs+0x0/0x29() returned 0.
[   16.308224] initcall 0x4087d571 ran for 0 msecs: init_lapic_sysfs+0x0/0x29()
[   16.315229] Calling initcall 0x4087e788: ioapic_init_sysfs+0x0/0xb8()
[   16.321829] initcall 0x4087e788: ioapic_init_sysfs+0x0/0xb8() returned 0.
[   16.328457] initcall 0x4087e788 ran for 0 msecs: ioapic_init_sysfs+0x0/0xb8()
[   16.335566] Calling initcall 0x40880f04: init_vmi_clocksource+0x0/0xe8()
[   16.342237] initcall 0x40880f04: init_vmi_clocksource+0x0/0xe8() returned 0.
[   16.349259] initcall 0x40880f04 ran for 0 msecs: init_vmi_clocksource+0x0/0xe8()
[   16.356625] Calling initcall 0x4088102b: add_pcspkr+0x0/0x31()
[   16.362552] initcall 0x4088102b: add_pcspkr+0x0/0x31() returned 0.
[   16.368582] initcall 0x4088102b ran for 0 msecs: add_pcspkr+0x0/0x31()
[   16.375082] Calling initcall 0x408819bd: aes_init+0x0/0x265()
[   16.380834] initcall 0x408819bd: aes_init+0x0/0x265() returned 0.
[   16.386867] initcall 0x408819bd ran for 0 msecs: aes_init+0x0/0x265()
[   16.393283] Calling initcall 0x40881c22: init+0x0/0xa()
[   16.398481] initcall 0x40881c22: init+0x0/0xa() returned 0.
[   16.404028] initcall 0x40881c22 ran for 0 msecs: init+0x0/0xa()
[   16.409922] Calling initcall 0x40881c67: init_sched_debug_procfs+0x0/0x2a()
[   16.416858] initcall 0x40881c67: init_sched_debug_procfs+0x0/0x2a() returned 0.
[   16.424135] initcall 0x40881c67 ran for 0 msecs: init_sched_debug_procfs+0x0/0x2a()
[   16.431763] Calling initcall 0x408824df: create_proc_profile+0x0/0x3d()
[   16.438346] initcall 0x408824df: create_proc_profile+0x0/0x3d() returned 0.
[   16.445280] initcall 0x408824df ran for 0 msecs: create_proc_profile+0x0/0x3d()
[   16.452559] Calling initcall 0x4088262c: ioresources_init+0x0/0x35()
[   16.458887] initcall 0x4088262c: ioresources_init+0x0/0x35() returned 0.
[   16.465558] initcall 0x4088262c ran for 0 msecs: ioresources_init+0x0/0x35()
[   16.472577] Calling initcall 0x408828b1: uid_cache_init+0x0/0x63()
[   16.478730] initcall 0x408828b1: uid_cache_init+0x0/0x63() returned 0.
[   16.485230] initcall 0x408828b1 ran for 0 msecs: uid_cache_init+0x0/0x63()
[   16.492077] Calling initcall 0x40882db7: init_posix_timers+0x0/0x89()
[   16.498488] initcall 0x40882db7: init_posix_timers+0x0/0x89() returned 0.
[   16.505249] initcall 0x40882db7 ran for 0 msecs: init_posix_timers+0x0/0x89()
[   16.512355] Calling initcall 0x40882e40: init_posix_cpu_timers+0x0/0x9c()
[   16.519112] initcall 0x40882e40: init_posix_cpu_timers+0x0/0x9c() returned 0.
[   16.526219] initcall 0x40882e40 ran for 0 msecs: init_posix_cpu_timers+0x0/0x9c()
[   16.533677] Calling initcall 0x40882fcb: latency_init+0x0/0x1c()
[   16.539658] initcall 0x40882fcb: latency_init+0x0/0x1c() returned 0.
[   16.545977] initcall 0x40882fcb ran for 0 msecs: latency_init+0x0/0x1c()
[   16.552652] Calling initcall 0x40882fe7: nsproxy_cache_init+0x0/0x30()
[   16.559153] initcall 0x40882fe7: nsproxy_cache_init+0x0/0x30() returned 0.
[   16.565995] initcall 0x40882fe7 ran for 0 msecs: nsproxy_cache_init+0x0/0x30()
[   16.573194] Calling initcall 0x40883017: timekeeping_init_device+0x0/0x19()
[   16.580317] initcall 0x40883017: timekeeping_init_device+0x0/0x19() returned 0.
[   16.587474] initcall 0x40883017 ran for 0 msecs: timekeeping_init_device+0x0/0x19()
[   16.595091] Calling initcall 0x408831a2: init_clocksource_sysfs+0x0/0x3f()
[   16.602120] initcall 0x408831a2: init_clocksource_sysfs+0x0/0x3f() returned 0.
[   16.609182] initcall 0x408831a2 ran for 0 msecs: init_clocksource_sysfs+0x0/0x3f()
[   16.616721] Calling initcall 0x4088325d: init_timer_list_procfs+0x0/0x26()
[   16.623568] initcall 0x4088325d: init_timer_list_procfs+0x0/0x26() returned 0.
[   16.630758] initcall 0x4088325d ran for 0 msecs: init_timer_list_procfs+0x0/0x26()
[   16.638300] Calling initcall 0x408833c6: lockdep_proc_init+0x0/0x57()
[   16.644717] initcall 0x408833c6: lockdep_proc_init+0x0/0x57() returned 0.
[   16.651472] initcall 0x408833c6 ran for 0 msecs: lockdep_proc_init+0x0/0x57()
[   16.658579] Calling initcall 0x4088341d: init+0x0/0x91()
[   16.663914] initcall 0x4088341d: init+0x0/0x91() returned 0.
[   16.669498] initcall 0x4088341d ran for 0 msecs: init+0x0/0x91()
[   16.675477] Calling initcall 0x4013f607: init_rttest+0x0/0x108()
[   16.682622] Initializing RT-Tester: OK
[   16.686246] initcall 0x4013f607: init_rttest+0x0/0x108() returned 0.
[   16.692564] initcall 0x4013f607 ran for 4 msecs: init_rttest+0x0/0x108()
[   16.699240] Calling initcall 0x408834ae: proc_dma_init+0x0/0x1c()
[   16.705307] initcall 0x408834ae: proc_dma_init+0x0/0x1c() returned 0.
[   16.711720] initcall 0x408834ae ran for 0 msecs: proc_dma_init+0x0/0x1c()
[   16.718479] Calling initcall 0x408834ca: kallsyms_init+0x0/0x1f()
[   16.724544] initcall 0x408834ca: kallsyms_init+0x0/0x1f() returned 0.
[   16.730956] initcall 0x408834ca ran for 0 msecs: kallsyms_init+0x0/0x1f()
[   16.737718] Calling initcall 0x4088353c: crash_save_vmcoreinfo_init+0x0/0x3fe()
[   16.745006] initcall 0x4088353c: crash_save_vmcoreinfo_init+0x0/0x3fe() returned 0.
[   16.752620] initcall 0x4088353c ran for 0 msecs: crash_save_vmcoreinfo_init+0x0/0x3fe()
[   16.760596] Calling initcall 0x40883507: crash_notes_memory_init+0x0/0x35()
[   16.767527] initcall 0x40883507: crash_notes_memory_init+0x0/0x35() returned 0.
[   16.774806] initcall 0x40883507 ran for 0 msecs: crash_notes_memory_init+0x0/0x35()
[   16.782435] Calling initcall 0x40883b77: ikconfig_init+0x0/0x37()
[   16.788500] initcall 0x40883b77: ikconfig_init+0x0/0x37() returned 0.
[   16.794911] initcall 0x40883b77 ran for 0 msecs: ikconfig_init+0x0/0x37()
[   16.801674] Calling initcall 0x40883c1c: audit_init+0x0/0x11c()
[   16.807564] audit: initializing netlink socket (disabled)
[   16.812972] audit(1194987611.329:1): initialized
[   16.817539] initcall 0x40883c1c: audit_init+0x0/0x11c() returned 0.
[   16.823772] initcall 0x40883c1c ran for 9 msecs: audit_init+0x0/0x11c()
[   16.830359] Calling initcall 0x40883dac: audit_tree_init+0x0/0x37()
[   16.836597] initcall 0x40883dac: audit_tree_init+0x0/0x37() returned 0.
[   16.843184] initcall 0x40883dac ran for 0 msecs: audit_tree_init+0x0/0x37()
[   16.850118] Calling initcall 0x40883f4e: relay_init+0x0/0x3()
[   16.855834] initcall 0x40883f4e: relay_init+0x0/0x3() returned 0.
[   16.861904] initcall 0x40883f4e ran for 0 msecs: relay_init+0x0/0x3()
[   16.868315] Calling initcall 0x40883f51: utsname_sysctl_init+0x0/0xd()
[   16.874839] initcall 0x40883f51: utsname_sysctl_init+0x0/0xd() returned 0.
[   16.881662] initcall 0x40883f51 ran for 0 msecs: utsname_sysctl_init+0x0/0xd()
[   16.888857] Calling initcall 0x408853ef: init_per_zone_pages_min+0x0/0x38()
[   16.895831] initcall 0x408853ef: init_per_zone_pages_min+0x0/0x38() returned 0.
[   16.903065] initcall 0x408853ef ran for 0 msecs: init_per_zone_pages_min+0x0/0x38()
[   16.910694] Calling initcall 0x408858e2: pdflush_init+0x0/0x12()
[   16.916756] initcall 0x408858e2: pdflush_init+0x0/0x12() returned 0.
[   16.922997] initcall 0x408858e2 ran for 0 msecs: pdflush_init+0x0/0x12()
[   16.929673] Calling initcall 0x40885914: kswapd_init+0x0/0xf()
[   16.935513] initcall 0x40885914: kswapd_init+0x0/0xf() returned 0.
[   16.941631] initcall 0x40885914 ran for 0 msecs: kswapd_init+0x0/0xf()
[   16.948131] Calling initcall 0x408859e2: init_emergency_pool+0x0/0x65()
[   16.954716] initcall 0x408859e2: init_emergency_pool+0x0/0x65() returned 0.
[   16.961651] initcall 0x408859e2 ran for 0 msecs: init_emergency_pool+0x0/0x65()
[   16.968933] Calling initcall 0x40885a47: init_tmpfs+0x0/0xbf()
[   16.974783] initcall 0x40885a47: init_tmpfs+0x0/0xbf() returned 0.
[   16.980889] initcall 0x40885a47 ran for 0 msecs: init_tmpfs+0x0/0xbf()
[   16.987389] Calling initcall 0x40885bb1: fasync_init+0x0/0x2d()
[   16.993280] initcall 0x40885bb1: fasync_init+0x0/0x2d() returned 0.
[   16.999522] initcall 0x40885bb1 ran for 0 msecs: fasync_init+0x0/0x2d()
[   17.006107] Calling initcall 0x40886113: aio_setup+0x0/0x72()
[   17.011866] initcall 0x40886113: aio_setup+0x0/0x72() returned 0.
[   17.017894] initcall 0x40886113 ran for 0 msecs: aio_setup+0x0/0x72()
[   17.024306] Calling initcall 0x408862f2: inotify_setup+0x0/0xd()
[   17.030284] initcall 0x408862f2: inotify_setup+0x0/0xd() returned 0.
[   17.036610] initcall 0x408862f2 ran for 0 msecs: inotify_setup+0x0/0xd()
[   17.043285] Calling initcall 0x4088631d: init_mbcache+0x0/0xd()
[   17.049177] initcall 0x4088631d: init_mbcache+0x0/0xd() returned 0.
[   17.055418] initcall 0x4088631d ran for 0 msecs: init_mbcache+0x0/0xd()
[   17.062004] Calling initcall 0x4088632a: dquot_init+0x0/0xdb()
[   17.067808] VFS: Disk quotas dquot_6.5.1
[   17.071758] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   17.078214] initcall 0x4088632a: dquot_init+0x0/0xdb() returned 0.
[   17.084359] initcall 0x4088632a ran for 9 msecs: dquot_init+0x0/0xdb()
[   17.090859] Calling initcall 0x40886405: init_v1_quota_format+0x0/0xa()
[   17.097446] initcall 0x40886405: init_v1_quota_format+0x0/0xa() returned 0.
[   17.104379] initcall 0x40886405 ran for 0 msecs: init_v1_quota_format+0x0/0xa()
[   17.111661] Calling initcall 0x4088640f: init_v2_quota_format+0x0/0xa()
[   17.118244] initcall 0x4088640f: init_v2_quota_format+0x0/0xa() returned 0.
[   17.125181] initcall 0x4088640f ran for 0 msecs: init_v2_quota_format+0x0/0xa()
[   17.132459] Calling initcall 0x40886796: vmcore_init+0x0/0x9c1()
[   17.138437] initcall 0x40886796: vmcore_init+0x0/0x9c1() returned 0.
[   17.144766] initcall 0x40886796 ran for 0 msecs: vmcore_init+0x0/0x9c1()
[   17.151438] Calling initcall 0x40887210: configfs_init+0x0/0xa3()
[   17.157600] initcall 0x40887210: configfs_init+0x0/0xa3() returned 0.
[   17.163917] initcall 0x40887210 ran for 0 msecs: configfs_init+0x0/0xa3()
[   17.170677] Calling initcall 0x408872b3: init_devpts_fs+0x0/0x2e()
[   17.176900] initcall 0x408872b3: init_devpts_fs+0x0/0x2e() returned 0.
[   17.183329] initcall 0x408872b3 ran for 0 msecs: init_devpts_fs+0x0/0x2e()
[   17.190175] Calling initcall 0x408872e1: init_ext3_fs+0x0/0x61()
[   17.196166] initcall 0x408872e1: init_ext3_fs+0x0/0x61() returned 0.
[   17.202479] initcall 0x408872e1 ran for 0 msecs: init_ext3_fs+0x0/0x61()
[   17.209157] Calling initcall 0x40887375: init_ext4_fs+0x0/0x61()
[   17.215139] initcall 0x40887375: init_ext4_fs+0x0/0x61() returned 0.
[   17.221461] initcall 0x40887375 ran for 0 msecs: init_ext4_fs+0x0/0x61()
[   17.228134] Calling initcall 0x40887483: journal_init+0x0/0xc5()
[   17.234554] initcall 0x40887483: journal_init+0x0/0xc5() returned 0.
[   17.240865] initcall 0x40887483 ran for 0 msecs: journal_init+0x0/0xc5()
[   17.247536] Calling initcall 0x408875c2: journal_init+0x0/0xc4()
[   17.253516] initcall 0x408875c2: journal_init+0x0/0xc4() returned 0.
[   17.259843] initcall 0x408875c2 ran for 0 msecs: journal_init+0x0/0xc4()
[   17.266516] Calling initcall 0x40887686: init_ext2_fs+0x0/0x61()
[   17.272497] initcall 0x40887686: init_ext2_fs+0x0/0x61() returned 0.
[   17.278819] initcall 0x40887686 ran for 0 msecs: init_ext2_fs+0x0/0x61()
[   17.285495] Calling initcall 0x4088771a: init_ramfs_fs+0x0/0xa()
[   17.291473] initcall 0x4088771a: init_ramfs_fs+0x0/0xa() returned 0.
[   17.297801] initcall 0x4088771a ran for 0 msecs: init_ramfs_fs+0x0/0xa()
[   17.304474] Calling initcall 0x40887786: init_fat_fs+0x0/0x48()
[   17.310365] initcall 0x40887786: init_fat_fs+0x0/0x48() returned 0.
[   17.316603] initcall 0x40887786 ran for 0 msecs: init_fat_fs+0x0/0x48()
[   17.323192] Calling initcall 0x408877ce: init_vfat_fs+0x0/0xa()
[   17.329083] initcall 0x408877ce: init_vfat_fs+0x0/0xa() returned 0.
[   17.335324] initcall 0x408877ce ran for 0 msecs: init_vfat_fs+0x0/0xa()
[   17.341911] Calling initcall 0x408877d8: init_bfs_fs+0x0/0x51()
[   17.347803] initcall 0x408877d8: init_bfs_fs+0x0/0x51() returned 0.
[   17.354040] initcall 0x408877d8 ran for 0 msecs: init_bfs_fs+0x0/0x51()
[   17.360630] Calling initcall 0x40887829: init_hfsplus_fs+0x0/0x52()
[   17.366868] initcall 0x40887829: init_hfsplus_fs+0x0/0x52() returned 0.
[   17.373455] initcall 0x40887829 ran for 0 msecs: init_hfsplus_fs+0x0/0x52()
[   17.380388] Calling initcall 0x4088787b: init_hfs_fs+0x0/0x52()
[   17.386280] initcall 0x4088787b: init_hfs_fs+0x0/0x52() returned 0.
[   17.392518] initcall 0x4088787b ran for 0 msecs: init_hfs_fs+0x0/0x52()
[   17.399105] Calling initcall 0x408878cd: vxfs_init+0x0/0x52()
[   17.404829] initcall 0x408878cd: vxfs_init+0x0/0x52() returned 0.
[   17.410890] initcall 0x408878cd ran for 0 msecs: vxfs_init+0x0/0x52()
[   17.417306] Calling initcall 0x4088791f: init_nls_cp437+0x0/0xa()
[   17.423378] initcall 0x4088791f: init_nls_cp437+0x0/0xa() returned 0.
[   17.429786] initcall 0x4088791f ran for 0 msecs: init_nls_cp437+0x0/0xa()
[   17.436545] Calling initcall 0x40887929: init_nls_cp737+0x0/0xa()
[   17.442609] initcall 0x40887929: init_nls_cp737+0x0/0xa() returned 0.
[   17.449025] initcall 0x40887929 ran for 0 msecs: init_nls_cp737+0x0/0xa()
[   17.455784] Calling initcall 0x40887933: init_nls_cp775+0x0/0xa()
[   17.461848] initcall 0x40887933: init_nls_cp775+0x0/0xa() returned 0.
[   17.468263] initcall 0x40887933 ran for 0 msecs: init_nls_cp775+0x0/0xa()
[   17.475020] Calling initcall 0x4088793d: init_nls_cp855+0x0/0xa()
[   17.481086] initcall 0x4088793d: init_nls_cp855+0x0/0xa() returned 0.
[   17.487501] initcall 0x4088793d ran for 0 msecs: init_nls_cp855+0x0/0xa()
[   17.494261] Calling initcall 0x40887947: init_nls_cp857+0x0/0xa()
[   17.500326] initcall 0x40887947: init_nls_cp857+0x0/0xa() returned 0.
[   17.506738] initcall 0x40887947 ran for 0 msecs: init_nls_cp857+0x0/0xa()
[   17.513500] Calling initcall 0x40887951: init_nls_cp863+0x0/0xa()
[   17.519564] initcall 0x40887951: init_nls_cp863+0x0/0xa() returned 0.
[   17.525977] initcall 0x40887951 ran for 0 msecs: init_nls_cp863+0x0/0xa()
[   17.532739] Calling initcall 0x4088795b: init_nls_cp864+0x0/0xa()
[   17.538802] initcall 0x4088795b: init_nls_cp864+0x0/0xa() returned 0.
[   17.545219] initcall 0x4088795b ran for 0 msecs: init_nls_cp864+0x0/0xa()
[   17.551978] Calling initcall 0x40887965: init_nls_cp866+0x0/0xa()
[   17.558042] initcall 0x40887965: init_nls_cp866+0x0/0xa() returned 0.
[   17.564455] initcall 0x40887965 ran for 0 msecs: init_nls_cp866+0x0/0xa()
[   17.571216] Calling initcall 0x4088796f: init_nls_cp869+0x0/0xa()
[   17.577281] initcall 0x4088796f: init_nls_cp869+0x0/0xa() returned 0.
[   17.583696] initcall 0x4088796f ran for 0 msecs: init_nls_cp869+0x0/0xa()
[   17.590456] Calling initcall 0x40887979: init_nls_cp874+0x0/0xa()
[   17.596519] initcall 0x40887979: init_nls_cp874+0x0/0xa() returned 0.
[   17.602932] initcall 0x40887979 ran for 0 msecs: init_nls_cp874+0x0/0xa()
[   17.609694] Calling initcall 0x40887983: init_nls_cp949+0x0/0xa()
[   17.615757] initcall 0x40887983: init_nls_cp949+0x0/0xa() returned 0.
[   17.622170] initcall 0x40887983 ran for 0 msecs: init_nls_cp949+0x0/0xa()
[   17.628935] Calling initcall 0x4088798d: init_nls_cp950+0x0/0xa()
[   17.634997] initcall 0x4088798d: init_nls_cp950+0x0/0xa() returned 0.
[   17.641412] initcall 0x4088798d ran for 0 msecs: init_nls_cp950+0x0/0xa()
[   17.648171] Calling initcall 0x40887997: init_nls_cp1250+0x0/0xa()
[   17.654322] initcall 0x40887997: init_nls_cp1250+0x0/0xa() returned 0.
[   17.660825] initcall 0x40887997 ran for 0 msecs: init_nls_cp1250+0x0/0xa()
[   17.667671] Calling initcall 0x408879a1: init_nls_ascii+0x0/0xa()
[   17.673735] initcall 0x408879a1: init_nls_ascii+0x0/0xa() returned 0.
[   17.680149] initcall 0x408879a1 ran for 0 msecs: init_nls_ascii+0x0/0xa()
[   17.686909] Calling initcall 0x408879ab: init_nls_iso8859_6+0x0/0xa()
[   17.693320] initcall 0x408879ab: init_nls_iso8859_6+0x0/0xa() returned 0.
[   17.700081] initcall 0x408879ab ran for 0 msecs: init_nls_iso8859_6+0x0/0xa()
[   17.707191] Calling initcall 0x408879b5: init_nls_cp1255+0x0/0xa()
[   17.713338] initcall 0x408879b5: init_nls_cp1255+0x0/0xa() returned 0.
[   17.719840] initcall 0x408879b5 ran for 0 msecs: init_nls_cp1255+0x0/0xa()
[   17.726686] Calling initcall 0x408879bf: init_nls_iso8859_9+0x0/0xa()
[   17.733097] initcall 0x408879bf: init_nls_iso8859_9+0x0/0xa() returned 0.
[   17.739864] initcall 0x408879bf ran for 0 msecs: init_nls_iso8859_9+0x0/0xa()
[   17.746965] Calling initcall 0x408879c9: init_nls_iso8859_13+0x0/0xa()
[   17.753462] initcall 0x408879c9: init_nls_iso8859_13+0x0/0xa() returned 0.
[   17.760311] initcall 0x408879c9 ran for 0 msecs: init_nls_iso8859_13+0x0/0xa()
[   17.767503] Calling initcall 0x408879d3: init_nls_iso8859_14+0x0/0xa()
[   17.774002] initcall 0x408879d3: init_nls_iso8859_14+0x0/0xa() returned 0.
[   17.780850] initcall 0x408879d3 ran for 0 msecs: init_nls_iso8859_14+0x0/0xa()
[   17.788042] Calling initcall 0x408879dd: init_nls_iso8859_15+0x0/0xa()
[   17.794540] initcall 0x408879dd: init_nls_iso8859_15+0x0/0xa() returned 0.
[   17.801389] initcall 0x408879dd ran for 0 msecs: init_nls_iso8859_15+0x0/0xa()
[   17.808581] Calling initcall 0x408879e7: init_nls_koi8_u+0x0/0xa()
[   17.814732] initcall 0x408879e7: init_nls_koi8_u+0x0/0xa() returned 0.
[   17.821235] initcall 0x408879e7 ran for 0 msecs: init_nls_koi8_u+0x0/0xa()
[   17.828080] Calling initcall 0x408879f1: init_nls_koi8_ru+0x0/0x35()
[   17.834405] initcall 0x408879f1: init_nls_koi8_ru+0x0/0x35() returned 0.
[   17.841079] initcall 0x408879f1 ran for 0 msecs: init_nls_koi8_ru+0x0/0x35()
[   17.848098] Calling initcall 0x40887a26: init_nls_utf8+0x0/0x1a()
[   17.854164] initcall 0x40887a26: init_nls_utf8+0x0/0x1a() returned 0.
[   17.860575] initcall 0x40887a26 ran for 0 msecs: init_nls_utf8+0x0/0x1a()
[   17.867337] Calling initcall 0x40887a73: init_sysv_fs+0x0/0x3f()
[   17.873317] initcall 0x40887a73: init_sysv_fs+0x0/0x3f() returned 0.
[   17.879644] initcall 0x40887a73 ran for 0 msecs: init_sysv_fs+0x0/0x3f()
[   17.886317] Calling initcall 0x40887ab2: init_ntfs_fs+0x0/0x22c()
[   17.892380] NTFS driver 2.1.29 [Flags: R/W DEBUG].
[   17.897164] initcall 0x40887ab2: init_ntfs_fs+0x0/0x22c() returned 0.
[   17.903562] initcall 0x40887ab2 ran for 4 msecs: init_ntfs_fs+0x0/0x22c()
[   17.910322] Calling initcall 0x40887cde: init_efs_fs+0x0/0x5d()
[   17.916212] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[   17.921159] initcall 0x40887cde: init_efs_fs+0x0/0x5d() returned 0.
[   17.927393] initcall 0x40887cde ran for 4 msecs: init_efs_fs+0x0/0x5d()
[   17.933980] Calling initcall 0x40887d3b: init_affs_fs+0x0/0x51()
[   17.939960] initcall 0x40887d3b: init_affs_fs+0x0/0x51() returned 0.
[   17.946284] initcall 0x40887d3b ran for 0 msecs: init_affs_fs+0x0/0x51()
[   17.952961] Calling initcall 0x40887d8c: init_qnx4_fs+0x0/0x61()
[   17.958937] QNX4 filesystem 0.2.3 registered.
[   17.963275] initcall 0x40887d8c: init_qnx4_fs+0x0/0x61() returned 0.
[   17.969598] initcall 0x40887d8c ran for 4 msecs: init_qnx4_fs+0x0/0x61()
[   17.976271] Calling initcall 0x40887ded: init_autofs_fs+0x0/0xa()
[   17.982336] initcall 0x40887ded: init_autofs_fs+0x0/0xa() returned 0.
[   17.988750] initcall 0x40887ded ran for 0 msecs: init_autofs_fs+0x0/0xa()
[   17.995509] Calling initcall 0x40887df7: init_autofs4_fs+0x0/0xa()
[   18.001661] initcall 0x40887df7: init_autofs4_fs+0x0/0xa() returned -16.
[   18.008335] initcall 0x40887df7 ran for 0 msecs: init_autofs4_fs+0x0/0xa()
[   18.015182] initcall at 0x40887df7: init_autofs4_fs+0x0/0xa(): returned with error code -16
[   18.023503] Calling initcall 0x40887e01: init_udf_fs+0x0/0x51()
[   18.029394] initcall 0x40887e01: init_udf_fs+0x0/0x51() returned 0.
[   18.035634] initcall 0x40887e01 ran for 0 msecs: init_udf_fs+0x0/0x51()
[   18.042220] Calling initcall 0x40887f11: init_xfs_fs+0x0/0x59()
[   18.048111] SGI XFS with ACLs, realtime, large block numbers, no debug enabled
[   18.055552] SGI XFS Quota Management subsystem
[   18.059884] initcall 0x40887f11: init_xfs_fs+0x0/0x59() returned 0.
[   18.066110] initcall 0x40887f11 ran for 11 msecs: init_xfs_fs+0x0/0x59()
[   18.072788] Calling initcall 0x40887fa3: ipc_init+0x0/0x12()
[   18.078426] initcall 0x40887fa3: ipc_init+0x0/0x12() returned 0.
[   18.084395] initcall 0x40887fa3 ran for 0 msecs: ipc_init+0x0/0x12()
[   18.090722] Calling initcall 0x408880a9: ipc_sysctl_init+0x0/0xd()
[   18.096919] initcall 0x408880a9: ipc_sysctl_init+0x0/0xd() returned 0.
[   18.103376] initcall 0x408880a9 ran for 0 msecs: ipc_sysctl_init+0x0/0xd()
[   18.110224] Calling initcall 0x408881dd: selinux_nf_ip_init+0x0/0x3b()
[   18.116721] initcall 0x408881dd: selinux_nf_ip_init+0x0/0x3b() returned 0.
[   18.123568] initcall 0x408881dd ran for 0 msecs: selinux_nf_ip_init+0x0/0x3b()
[   18.130762] Calling initcall 0x40888315: init_sel_fs+0x0/0x59()
[   18.136653] initcall 0x40888315: init_sel_fs+0x0/0x59() returned 0.
[   18.142892] initcall 0x40888315 ran for 0 msecs: init_sel_fs+0x0/0x59()
[   18.149481] Calling initcall 0x4088836e: selnl_init+0x0/0x58()
[   18.155292] initcall 0x4088836e: selnl_init+0x0/0x58() returned 0.
[   18.161440] initcall 0x4088836e ran for 0 msecs: selnl_init+0x0/0x58()
[   18.167939] Calling initcall 0x408883c6: sel_netif_init+0x0/0x6c()
[   18.174090] initcall 0x408883c6: sel_netif_init+0x0/0x6c() returned 0.
[   18.180589] initcall 0x408883c6 ran for 0 msecs: sel_netif_init+0x0/0x6c()
[   18.187438] Calling initcall 0x40888432: aurule_init+0x0/0x45()
[   18.193329] initcall 0x40888432: aurule_init+0x0/0x45() returned 0.
[   18.199571] initcall 0x40888432 ran for 0 msecs: aurule_init+0x0/0x45()
[   18.206157] Calling initcall 0x408884f8: crypto_algapi_init+0x0/0x8()
[   18.212569] initcall 0x408884f8: crypto_algapi_init+0x0/0x8() returned 0.
[   18.219329] initcall 0x408884f8 ran for 0 msecs: crypto_algapi_init+0x0/0x8()
[   18.226436] Calling initcall 0x4088851a: cryptomgr_init+0x0/0xa()
[   18.232501] initcall 0x4088851a: cryptomgr_init+0x0/0xa() returned 0.
[   18.238912] initcall 0x4088851a ran for 0 msecs: cryptomgr_init+0x0/0xa()
[   18.245675] Calling initcall 0x40888524: hmac_module_init+0x0/0xa()
[   18.251928] initcall 0x40888524: hmac_module_init+0x0/0xa() returned 0.
[   18.258498] initcall 0x40888524 ran for 0 msecs: hmac_module_init+0x0/0xa()
[   18.265436] Calling initcall 0x4088852e: crypto_xcbc_module_init+0x0/0xa()
[   18.272278] initcall 0x4088852e: crypto_xcbc_module_init+0x0/0xa() returned 0.
[   18.279472] initcall 0x4088852e ran for 0 msecs: crypto_xcbc_module_init+0x0/0xa()
[   18.287012] Calling initcall 0x40888538: init+0x0/0x49()
[   18.292298] initcall 0x40888538: init+0x0/0x49() returned 0.
[   18.297931] initcall 0x40888538 ran for 0 msecs: init+0x0/0x49()
[   18.303911] Calling initcall 0x40888581: init+0x0/0xa()
[   18.309109] initcall 0x40888581: init+0x0/0xa() returned 0.
[   18.314654] initcall 0x40888581 ran for 0 msecs: init+0x0/0xa()
[   18.320547] Calling initcall 0x4088858b: init+0x0/0xa()
[   18.325748] initcall 0x4088858b: init+0x0/0xa() returned 0.
[   18.331729] initcall 0x4088858b ran for 0 msecs: init+0x0/0xa()
[   18.337622] Calling initcall 0x40888595: init+0x0/0xa()
[   18.342820] initcall 0x40888595: init+0x0/0xa() returned 0.
[   18.348365] initcall 0x40888595 ran for 0 msecs: init+0x0/0xa()
[   18.354259] Calling initcall 0x4088859f: init+0x0/0x4e()
[   18.359548] initcall 0x4088859f: init+0x0/0x4e() returned 0.
[   18.365180] initcall 0x4088859f ran for 0 msecs: init+0x0/0x4e()
[   18.371160] Calling initcall 0x408885ed: init+0x0/0x4e()
[   18.376447] initcall 0x408885ed: init+0x0/0x4e() returned 0.
[   18.382077] initcall 0x408885ed ran for 0 msecs: init+0x0/0x4e()
[   18.388058] Calling initcall 0x4088863b: crypto_ecb_module_init+0x0/0xa()
[   18.394816] initcall 0x4088863b: crypto_ecb_module_init+0x0/0xa() returned 0.
[   18.401924] initcall 0x4088863b ran for 0 msecs: crypto_ecb_module_init+0x0/0xa()
[   18.409379] Calling initcall 0x40888645: crypto_cbc_module_init+0x0/0xa()
[   18.416135] initcall 0x40888645: crypto_cbc_module_init+0x0/0xa() returned 0.
[   18.423243] initcall 0x40888645 ran for 0 msecs: crypto_cbc_module_init+0x0/0xa()
[   18.430697] Calling initcall 0x4088864f: crypto_pcbc_module_init+0x0/0xa()
[   18.437541] initcall 0x4088864f: crypto_pcbc_module_init+0x0/0xa() returned 0.
[   18.444732] initcall 0x4088864f ran for 0 msecs: crypto_pcbc_module_init+0x0/0xa()
[   18.452275] Calling initcall 0x40888659: crypto_module_init+0x0/0xa()
[   18.458686] initcall 0x40888659: crypto_module_init+0x0/0xa() returned 0.
[   18.465447] initcall 0x40888659 ran for 0 msecs: crypto_module_init+0x0/0xa()
[   18.472553] Calling initcall 0x40888663: cryptd_init+0x0/0xa0()
[   18.478486] initcall 0x40888663: cryptd_init+0x0/0xa0() returned 0.
[   18.484683] initcall 0x40888663 ran for 0 msecs: cryptd_init+0x0/0xa0()
[   18.491272] Calling initcall 0x40888703: init+0x0/0x2f()
[   18.496558] initcall 0x40888703: init+0x0/0x2f() returned 0.
[   18.502190] initcall 0x40888703 ran for 0 msecs: init+0x0/0x2f()
[   18.508171] Calling initcall 0x40888732: init+0x0/0xa()
[   18.513369] initcall 0x40888732: init+0x0/0xa() returned 0.
[   18.518915] initcall 0x40888732 ran for 0 msecs: init+0x0/0xa()
[   18.524810] Calling initcall 0x4088873c: init+0x0/0xa()
[   18.530009] initcall 0x4088873c: init+0x0/0xa() returned 0.
[   18.535556] initcall 0x4088873c ran for 0 msecs: init+0x0/0xa()
[   18.541449] Calling initcall 0x40888746: init+0x0/0xa()
[   18.546648] initcall 0x40888746: init+0x0/0xa() returned 0.
[   18.552195] initcall 0x40888746 ran for 0 msecs: init+0x0/0xa()
[   18.558088] Calling initcall 0x40888750: arc4_init+0x0/0xa()
[   18.563719] initcall 0x40888750: arc4_init+0x0/0xa() returned 0.
[   18.569701] initcall 0x40888750 ran for 0 msecs: arc4_init+0x0/0xa()
[   18.576027] Calling initcall 0x4088875a: init+0x0/0x4e()
[   18.581314] initcall 0x4088875a: init+0x0/0x4e() returned 0.
[   18.586944] initcall 0x4088875a ran for 0 msecs: init+0x0/0x4e()
[   18.592926] Calling initcall 0x408887a8: seed_init+0x0/0xa()
[   18.598557] initcall 0x408887a8: seed_init+0x0/0xa() returned 0.
[   18.604536] initcall 0x408887a8 ran for 0 msecs: seed_init+0x0/0xa()
[   18.610862] Calling initcall 0x408887b2: init+0x0/0xa()
[   18.616064] initcall 0x408887b2: init+0x0/0xa() returned 0.
[   18.621611] initcall 0x408887b2 ran for 0 msecs: init+0x0/0xa()
[   18.627503] Calling initcall 0x408887bc: michael_mic_init+0x0/0xa()
[   18.633742] initcall 0x408887bc: michael_mic_init+0x0/0xa() returned 0.
[   18.640327] initcall 0x408887bc ran for 0 msecs: michael_mic_init+0x0/0xa()
[   18.647263] Calling initcall 0x40888a63: bsg_init+0x0/0x109()
[   18.653106] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[   18.660396] initcall 0x40888a63: bsg_init+0x0/0x109() returned 0.
[   18.666456] initcall 0x40888a63 ran for 7 msecs: bsg_init+0x0/0x109()
[   18.672873] Calling initcall 0x40888b6c: noop_init+0x0/0xa()
[   18.678512] io scheduler noop registered
[   18.682407] initcall 0x40888b6c: noop_init+0x0/0xa() returned 0.
[   18.688381] initcall 0x40888b6c ran for 3 msecs: noop_init+0x0/0xa()
[   18.694707] Calling initcall 0x40888b76: as_init+0x0/0xa()
[   18.700168] io scheduler anticipatory registered (default)
[   18.705631] initcall 0x40888b76: as_init+0x0/0xa() returned 0.
[   18.711435] initcall 0x40888b76 ran for 5 msecs: as_init+0x0/0xa()
[   18.717588] Calling initcall 0x40888b80: blk_trace_init+0x0/0x4d()
[   18.723739] initcall 0x40888b80: blk_trace_init+0x0/0x4d() returned 0.
[   18.730238] initcall 0x40888b80 ran for 0 msecs: blk_trace_init+0x0/0x4d()
[   18.737089] Calling initcall 0x40888cc4: audit_classes_init+0x0/0x4b()
[   18.743589] initcall 0x40888cc4: audit_classes_init+0x0/0x4b() returned 0.
[   18.750430] initcall 0x40888cc4 ran for 0 msecs: audit_classes_init+0x0/0x4b()
[   18.757628] Calling initcall 0x402e4d57: pci_init+0x0/0x28()
[   18.775919] Boot video device is 0000:01:00.0
[   18.780159] initcall 0x402e4d57: pci_init+0x0/0x28() returned 0.
[   18.786125] initcall 0x402e4d57 ran for 16 msecs: pci_init+0x0/0x28()
[   18.792542] Calling initcall 0x40889281: pci_proc_init+0x0/0x5b()
[   18.798666] initcall 0x40889281: pci_proc_init+0x0/0x5b() returned 0.
[   18.805021] initcall 0x40889281 ran for 0 msecs: pci_proc_init+0x0/0x5b()
[   18.811780] Calling initcall 0x408892dc: pcie_portdrv_init+0x0/0x43()
[   18.818474] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   18.824832] assign_interrupt_mode Found MSI capability
[   18.829853] Allocate Port Service[0000:00:0b.0:pcie00]
[   18.835358] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   18.841726] assign_interrupt_mode Found MSI capability
[   18.846745] Allocate Port Service[0000:00:0c.0:pcie00]
[   18.852240] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   18.858591] assign_interrupt_mode Found MSI capability
[   18.863616] Allocate Port Service[0000:00:0d.0:pcie00]
[   18.869104] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   18.875455] assign_interrupt_mode Found MSI capability
[   18.880482] Allocate Port Service[0000:00:0e.0:pcie00]
[   18.885923] initcall 0x408892dc: pcie_portdrv_init+0x0/0x43() returned 0.
[   18.892554] initcall 0x408892dc ran for 64 msecs: pcie_portdrv_init+0x0/0x43()
[   18.899750] Calling initcall 0x4088931f: aer_service_init+0x0/0x19()
[   18.906177] initcall 0x4088931f: aer_service_init+0x0/0x19() returned 0.
[   18.912750] initcall 0x4088931f ran for 0 msecs: aer_service_init+0x0/0x19()
[   18.919769] Calling initcall 0x40889338: pci_hotplug_init+0x0/0x53()
[   18.926186] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   18.931646] initcall 0x40889338: pci_hotplug_init+0x0/0x53() returned 0.
[   18.938312] initcall 0x40889338 ran for 5 msecs: pci_hotplug_init+0x0/0x53()
[   18.945337] Calling initcall 0x4088938b: dummyphp_init+0x0/0x4f()
[   18.951397] fakephp: Fake PCI Hot Plug Controller Driver
[   18.958621] initcall 0x4088938b: dummyphp_init+0x0/0x4f() returned 0.
[   18.964902] initcall 0x4088938b ran for 6 msecs: dummyphp_init+0x0/0x4f()
[   18.971661] Calling initcall 0x408893da: pcied_init+0x0/0x75()
[   18.977565] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   18.984058] initcall 0x408893da: pcied_init+0x0/0x75() returned 0.
[   18.990230] initcall 0x408893da ran for 6 msecs: pcied_init+0x0/0x75()
[   18.996733] Calling initcall 0x4088944f: shpcd_init+0x0/0x5b()
[   19.002657] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   19.009235] initcall 0x4088944f: shpcd_init+0x0/0x5b() returned 0.
[   19.015382] initcall 0x4088944f ran for 6 msecs: shpcd_init+0x0/0x5b()
[   19.021882] Calling initcall 0x40889673: cr_backlight_init+0x0/0x5f()
[   19.028524] INTEL CARILLO RANCH LPC not found.
[   19.032862] Carillo Ranch Backlight Driver Initialized.
[   19.038047] initcall 0x40889673: cr_backlight_init+0x0/0x5f() returned 0.
[   19.044795] initcall 0x40889673 ran for 9 msecs: cr_backlight_init+0x0/0x5f()
[   19.051901] Calling initcall 0x408896d2: display_class_init+0x0/0x6e()
[   19.058496] initcall 0x408896d2: display_class_init+0x0/0x6e() returned 0.
[   19.065247] initcall 0x408896d2 ran for 0 msecs: display_class_init+0x0/0x6e()
[   19.072440] Calling initcall 0x40889740: cyber2000fb_init+0x0/0xb6()
[   19.078883] initcall 0x40889740: cyber2000fb_init+0x0/0xb6() returned 0.
[   19.085439] initcall 0x40889740 ran for 0 msecs: cyber2000fb_init+0x0/0xb6()
[   19.092459] Calling initcall 0x408897f6: pm2fb_init+0x0/0x129()
[   19.098468] initcall 0x408897f6: pm2fb_init+0x0/0x129() returned 0.
[   19.104589] initcall 0x408897f6 ran for 0 msecs: pm2fb_init+0x0/0x129()
[   19.111177] Calling initcall 0x4088991f: pm3fb_init+0x0/0xe7()
[   19.117100] initcall 0x4088991f: pm3fb_init+0x0/0xe7() returned 0.
[   19.123144] initcall 0x4088991f ran for 0 msecs: pm3fb_init+0x0/0xe7()
[   19.129636] Calling initcall 0x40889a06: matroxfb_init+0x0/0x8a3()
[   19.135906] initcall 0x40889a06: matroxfb_init+0x0/0x8a3() returned 0.
[   19.142285] initcall 0x40889a06 ran for 0 msecs: matroxfb_init+0x0/0x8a3()
[   19.149138] Calling initcall 0x4030c3d7: nvidiafb_init+0x0/0x26e()
[   19.155405] initcall 0x4030c3d7: nvidiafb_init+0x0/0x26e() returned 0.
[   19.161787] initcall 0x4030c3d7 ran for 0 msecs: nvidiafb_init+0x0/0x26e()
[   19.168634] Calling initcall 0x4088a2a9: atyfb_init+0x0/0x1c1()
[   19.174661] initcall 0x4088a2a9: atyfb_init+0x0/0x1c1() returned 0.
[   19.180775] initcall 0x4088a2a9 ran for 0 msecs: atyfb_init+0x0/0x1c1()
[   19.187361] Calling initcall 0x4088a46a: vt8623fb_init+0x0/0x4c()
[   19.193546] initcall 0x4088a46a: vt8623fb_init+0x0/0x4c() returned 0.
[   19.199849] initcall 0x4088a46a ran for 0 msecs: vt8623fb_init+0x0/0x4c()
[   19.206600] Calling initcall 0x4088a4b6: vmlfb_init+0x0/0x82()
[   19.212404] vmlfb: initializing
[   19.215640] initcall 0x4088a4b6: vmlfb_init+0x0/0x82() returned 0.
[   19.221679] initcall 0x4088a4b6 ran for 3 msecs: vmlfb_init+0x0/0x82()
[   19.228178] Calling initcall 0x4088a538: s3fb_init+0x0/0xc1()
[   19.234016] initcall 0x4088a538: s3fb_init+0x0/0xc1() returned 0.
[   19.239973] initcall 0x4088a538 ran for 0 msecs: s3fb_init+0x0/0xc1()
[   19.246377] Calling initcall 0x4088a5f9: arkfb_init+0x0/0x4c()
[   19.252291] initcall 0x4088a5f9: arkfb_init+0x0/0x4c() returned 0.
[   19.258334] initcall 0x4088a5f9 ran for 0 msecs: arkfb_init+0x0/0x4c()
[   19.264839] Calling initcall 0x4088a645: hecubafb_init+0x0/0x6e()
[   19.270899] Use hecubafb_enable to enable the device
[   19.275845] initcall 0x4088a645: hecubafb_init+0x0/0x6e() returned -6.
[   19.282339] initcall 0x4088a645 ran for 4 msecs: hecubafb_init+0x0/0x6e()
[   19.289104] initcall at 0x4088a645: hecubafb_init+0x0/0x6e(): returned with error code -6
[   19.297250] Calling initcall 0x4088a6b3: hgafb_init+0x0/0x44()
[   19.303285] hgafb: HGA card not detected.
[   19.307191] hgafb: probe of hgafb.0 failed with error -22
[   19.312556] initcall 0x4088a6b3: hgafb_init+0x0/0x44() returned 0.
[   19.318694] initcall 0x4088a6b3 ran for 9 msecs: hgafb_init+0x0/0x44()
[   19.325195] Calling initcall 0x4088a9dd: s1d13xxxfb_init+0x0/0x20()
[   19.331538] initcall 0x4088a9dd: s1d13xxxfb_init+0x0/0x20() returned 0.
[   19.338019] initcall 0x4088a9dd ran for 0 msecs: s1d13xxxfb_init+0x0/0x20()
[   19.344958] Calling initcall 0x4031c870: sm501fb_init+0x0/0xa()
[   19.350953] initcall 0x4031c870: sm501fb_init+0x0/0xa() returned 0.
[   19.357088] initcall 0x4031c870 ran for 0 msecs: sm501fb_init+0x0/0xa()
[   19.363673] Calling initcall 0x4088b039: rand_initialize+0x0/0x21()
[   19.369933] initcall 0x4088b039: rand_initialize+0x0/0x21() returned 0.
[   19.376496] initcall 0x4088b039 ran for 0 msecs: rand_initialize+0x0/0x21()
[   19.383431] Calling initcall 0x4088b083: tty_init+0x0/0x1c8()
[   19.396508] initcall 0x4088b083: tty_init+0x0/0x1c8() returned 0.
[   19.402877] initcall 0x4088b083 ran for 7 msecs: tty_init+0x0/0x1c8()
[   19.409450] Calling initcall 0x4088b26e: pty_init+0x0/0x3a4()
[   19.427100] khelper used greatest stack depth: 3004 bytes left
[   19.484907] initcall 0x4088b26e: pty_init+0x0/0x3a4() returned 0.
[   19.490855] initcall 0x4088b26e ran for 66 msecs: pty_init+0x0/0x3a4()
[   19.497357] Calling initcall 0x4088bb98: cy_init+0x0/0xf0()
[   19.502902] Cyclades driver 2.5 (built Nov 13 2007 19:50:53)
[   19.508663] initcall 0x4088bb98: cy_init+0x0/0xf0() returned 0.
[   19.514427] initcall 0x4088bb98 ran for 5 msecs: cy_init+0x0/0xf0()
[   19.520710] Calling initcall 0x4088bc88: specialix_init_module+0x0/0x40a()
[   19.527574] sx: Specialix IO8+ driver v1.11, (c) R.E.Wolff 1997/1998.
[   19.533992] sx: derived from work (c) D.Gorodchanin 1994-1996.
[   19.539798] sx: DTR/RTS pin is always RTS.
[   19.553035] sx0: specialix IO8+ Board at 0x100 not found.
[   19.558329] sx1: specialix IO8+ Board at 0x180 not found.
[   19.563837] sx2: specialix IO8+ Board at 0x250 not found.
[   19.569267] sx3: specialix IO8+ Board at 0x260 not found.
[   19.585242] sx: No specialix IO8+ boards detected.
[   19.590052] initcall 0x4088bc88: specialix_init_module+0x0/0x40a() returned -5.
[   19.597200] initcall 0x4088bc88 ran for 59 msecs: specialix_init_module+0x0/0x40a()
[   19.604828] initcall at 0x4088bc88: specialix_init_module+0x0/0x40a(): returned with error code -5
[   19.613754] Calling initcall 0x4088c092: moxa_init+0x0/0x203()
[   19.619555] MOXA Intellio family driver version 5.1k
[   19.645551] initcall 0x4088c092: moxa_init+0x0/0x203() returned 0.
[   19.651581] initcall 0x4088c092 ran for 24 msecs: moxa_init+0x0/0x203()
[   19.658166] Calling initcall 0x4088c295: mxser_module_init+0x0/0x5bd()
[   19.664664] MOXA Smartio/Industio family driver version 2.0.2
[   19.670516] initcall 0x4088c295: mxser_module_init+0x0/0x5bd() returned 0.
[   19.677231] initcall 0x4088c295 ran for 5 msecs: mxser_module_init+0x0/0x5bd()
[   19.684425] Calling initcall 0x4088c9a6: riscom8_init_module+0x0/0x474()
[   19.691097] rc: SDL RISCom/8 card driver v1.1, (c) D.Gorodchanin 1994-1996.
[   19.703296] rc0: RISCom/8 Board at 0x220 not found.
[   19.708075] rc1: RISCom/8 Board at 0x240 not found.
[   19.713060] rc2: RISCom/8 Board at 0x250 not found.
[   19.717947] rc3: RISCom/8 Board at 0x260 not found.
[   19.728441] rc: No RISCom/8 boards detected.
[   19.732596] initcall 0x4088c9a6: riscom8_init_module+0x0/0x474() returned -5.
[   19.739706] initcall 0x4088c9a6 ran for 39 msecs: riscom8_init_module+0x0/0x474()
[   19.747160] initcall at 0x4088c9a6: riscom8_init_module+0x0/0x474(): returned with error code -5
[   19.755910] Calling initcall 0x4088ce1a: synclink_init+0x0/0x236()
[   19.762061] SyncLink serial driver $Revision: 4.38 $
[   19.790123] SyncLink serial driver $Revision: 4.38 $, tty major#252
[   19.796397] initcall 0x4088ce1a: synclink_init+0x0/0x236() returned 0.
[   19.802766] initcall 0x4088ce1a ran for 32 msecs: synclink_init+0x0/0x236()
[   19.809701] Calling initcall 0x4088d050: synclinkmp_init+0x0/0x169()
[   19.816025] SyncLink MultiPort driver $Revision: 4.38 $
[   19.847255] SyncLink MultiPort driver $Revision: 4.38 $, tty major#251
[   19.853791] initcall 0x4088d050: synclinkmp_init+0x0/0x169() returned 0.
[   19.860335] initcall 0x4088d050 ran for 36 msecs: synclinkmp_init+0x0/0x169()
[   19.867443] Calling initcall 0x4088d1b9: sx_init+0x0/0xd5()
[   19.873203] initcall 0x4088d1b9: sx_init+0x0/0xd5() returned 0.
[   19.878967] initcall 0x4088d1b9 ran for 0 msecs: sx_init+0x0/0xd5()
[   19.885274] Calling initcall 0x4088d28e: nvram_init+0x0/0x79()
[   19.891214] Non-volatile memory driver v1.2
[   19.895276] initcall 0x4088d28e: nvram_init+0x0/0x79() returned 0.
[   19.901424] initcall 0x4088d28e ran for 4 msecs: nvram_init+0x0/0x79()
[   19.907923] Calling initcall 0x4088d307: pc8736x_gpio_init+0x0/0x36c()
[   19.914523] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[   19.921541] platform pc8736x_gpio.0: no device found
[   19.926600] initcall 0x4088d307: pc8736x_gpio_init+0x0/0x36c() returned -19.
[   19.933489] initcall 0x4088d307 ran for 11 msecs: pc8736x_gpio_init+0x0/0x36c()
[   19.940771] Calling initcall 0x4088d673: nsc_gpio_init+0x0/0x13()
[   19.946831] nsc_gpio initializing
[   19.950129] initcall 0x4088d673: nsc_gpio_init+0x0/0x13() returned 0.
[   19.956538] initcall 0x4088d673 ran for 3 msecs: nsc_gpio_init+0x0/0x13()
[   19.963299] Calling initcall 0x4088d686: cs5535_gpio_init+0x0/0x162()
[   19.969713] cs5535_gpio: DIVIL not found
[   19.973615] initcall 0x4088d686: cs5535_gpio_init+0x0/0x162() returned -19.
[   19.980542] initcall 0x4088d686 ran for 3 msecs: cs5535_gpio_init+0x0/0x162()
[   19.987651] Calling initcall 0x4088d7e8: mwave_init+0x0/0x286()
[   19.993549] smapi::smapi_init, ERROR invalid usSmapiID
[   19.998661] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[   20.007934] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[   20.015126] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   20.021365] initcall 0x4088d7e8: mwave_init+0x0/0x286() returned -5.
[   20.027689] initcall 0x4088d7e8 ran for 26 msecs: mwave_init+0x0/0x286()
[   20.034362] initcall at 0x4088d7e8: mwave_init+0x0/0x286(): returned with error code -5
[   20.042334] Calling initcall 0x4088dab4: agp_init+0x0/0x2e()
[   20.047965] Linux agpgart interface v0.102
[   20.052044] initcall 0x4088dab4: agp_init+0x0/0x2e() returned 0.
[   20.058018] initcall 0x4088dab4 ran for 3 msecs: agp_init+0x0/0x2e()
[   20.064346] Calling initcall 0x4088dae2: agp_ati_init+0x0/0x20()
[   20.070458] initcall 0x4088dae2: agp_ati_init+0x0/0x20() returned 0.
[   20.076649] initcall 0x4088dae2 ran for 0 msecs: agp_ati_init+0x0/0x20()
[   20.083325] Calling initcall 0x4088db02: agp_efficeon_init+0x0/0x35()
[   20.089844] initcall 0x4088db02: agp_efficeon_init+0x0/0x35() returned 0.
[   20.096495] initcall 0x4088db02 ran for 0 msecs: agp_efficeon_init+0x0/0x35()
[   20.103604] Calling initcall 0x4088db37: agp_intel_init+0x0/0x20()
[   20.109886] initcall 0x4088db37: agp_intel_init+0x0/0x20() returned 0.
[   20.116265] initcall 0x4088db37 ran for 0 msecs: agp_intel_init+0x0/0x20()
[   20.123102] Calling initcall 0x4088db57: agp_via_init+0x0/0x20()
[   20.129190] initcall 0x4088db57: agp_via_init+0x0/0x20() returned 0.
[   20.135415] initcall 0x4088db57 ran for 0 msecs: agp_via_init+0x0/0x20()
[   20.142081] Calling initcall 0x4088db77: synclink_cs_init+0x0/0x135()
[   20.148492] SyncLink PC Card driver $Revision: 4.34 $
[   20.154448] SyncLink PC Card driver $Revision: 4.34 $, tty major#250
[   20.160676] initcall 0x4088db77: synclink_cs_init+0x0/0x135() returned 0.
[   20.167430] initcall 0x4088db77 ran for 11 msecs: synclink_cs_init+0x0/0x135()
[   20.174623] Calling initcall 0x4088dcac: cmm_init+0x0/0x9e()
[   20.180253] cm4000_cs.c v2.4.0gm6 - All bugs added by Harald Welte
[   20.186611] initcall 0x4088dcac: cmm_init+0x0/0x9e() returned 0.
[   20.192456] initcall 0x4088dcac ran for 6 msecs: cmm_init+0x0/0x9e()
[   20.198781] Calling initcall 0x4088dd4a: ipmi_init_msghandler_mod+0x0/0x8()
[   20.205846] ipmi message handler version 39.1
[   20.210085] initcall 0x4088dd4a: ipmi_init_msghandler_mod+0x0/0x8() returned 0.
[   20.217356] initcall 0x4088dd4a ran for 4 msecs: ipmi_init_msghandler_mod+0x0/0x8()
[   20.224984] Calling initcall 0x40369d05: init_ipmi_si+0x0/0x577()
[   20.231143] IPMI System Interface driver.
[   20.271253] ipmi_si: Unable to find any System Interface(s)
[   20.276697] initcall 0x40369d05: init_ipmi_si+0x0/0x577() returned -19.
[   20.283278] initcall 0x40369d05 ran for 43 msecs: init_ipmi_si+0x0/0x577()
[   20.290125] Calling initcall 0x4036cd5c: ipmi_poweroff_init+0x0/0x7c()
[   20.296622] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[   20.304298] initcall 0x4036cd5c: ipmi_poweroff_init+0x0/0x7c() returned 0.
[   20.311098] initcall 0x4036cd5c ran for 7 msecs: ipmi_poweroff_init+0x0/0x7c()
[   20.318290] Calling initcall 0x4088dd52: init_atmel+0x0/0x162()
[   20.324405] initcall 0x4088dd52: init_atmel+0x0/0x162() returned -19.
[   20.330688] initcall 0x4088dd52 ran for 0 msecs: init_atmel+0x0/0x162()
[   20.337278] Calling initcall 0x4036f51a: i810fb_init+0x0/0x358()
[   20.343364] initcall 0x4036f51a: i810fb_init+0x0/0x358() returned 0.
[   20.349583] initcall 0x4036f51a ran for 0 msecs: i810fb_init+0x0/0x358()
[   20.356256] Calling initcall 0x4088deb4: intelfb_init+0x0/0x520()
[   20.362320] intelfb: intelfb_init
[   20.365620] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets
[   20.375584] intelfb: Version 0.9.4
[   20.378962] intelfb: intelfb_setup
[   20.382344] intelfb: no options
[   20.385614] initcall 0x4088deb4: intelfb_init+0x0/0x520() returned 0.
[   20.391910] initcall 0x4088deb4 ran for 22 msecs: intelfb_init+0x0/0x520()
[   20.398746] Calling initcall 0x4088e776: serial8250_init+0x0/0x111()
[   20.405071] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[   20.667294] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   20.674335] initcall 0x4088e776: serial8250_init+0x0/0x111() returned 0.
[   20.680880] initcall 0x4088e776 ran for 256 msecs: serial8250_init+0x0/0x111()
[   20.688073] Calling initcall 0x4088e887: serial8250_pci_init+0x0/0x11()
[   20.694793] initcall 0x4088e887: serial8250_pci_init+0x0/0x11() returned 0.
[   20.701602] initcall 0x4088e887 ran for 0 msecs: serial8250_pci_init+0x0/0x11()
[   20.708883] Calling initcall 0x4088ec74: mca_init+0x0/0x19()
[   20.714510] initcall 0x4088ec74: mca_init+0x0/0x19() returned -19.
[   20.720663] initcall 0x4088ec74 ran for 0 msecs: mca_init+0x0/0x19()
[   20.726990] Calling initcall 0x4088ee28: sm501_base_init+0x0/0x1b()
[   20.733444] initcall 0x4088ee28: sm501_base_init+0x0/0x1b() returned 0.
[   20.739913] initcall 0x4088ee28 ran for 0 msecs: sm501_base_init+0x0/0x1b()
[   20.746838] Calling initcall 0x4088ee43: e1000_init_module+0x0/0x7c()
[   20.753248] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
[   20.759235] Copyright (c) 1999-2006 Intel Corporation.
[   20.764502] initcall 0x4088ee43: e1000_init_module+0x0/0x7c() returned 0.
[   20.771146] initcall 0x4088ee43 ran for 10 msecs: e1000_init_module+0x0/0x7c()
[   20.778323] Calling initcall 0x4088eebf: e100_init_module+0x0/0x58()
[   20.784646] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[   20.790717] e100: Copyright(c) 1999-2006 Intel Corporation
[   20.796290] initcall 0x4088eebf: e100_init_module+0x0/0x58() returned 0.
[   20.802845] initcall 0x4088eebf ran for 11 msecs: e100_init_module+0x0/0x58()
[   20.809954] Calling initcall 0x4088ef56: net_olddevs_init+0x0/0x7d()
[   20.816281] initcall 0x4088ef56: net_olddevs_init+0x0/0x7d() returned 0.
[   20.822950] initcall 0x4088ef56 ran for 0 msecs: net_olddevs_init+0x0/0x7d()
[   20.829972] Calling initcall 0x4088f045: init_nic+0x0/0x11()
[   20.835740] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[   20.843012] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   21.363817] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
[   21.372070] forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
[   21.379020] initcall 0x4088f045: init_nic+0x0/0x11() returned 0.
[   21.384976] initcall 0x4088f045 ran for 518 msecs: init_nic+0x0/0x11()
[   21.391476] Calling initcall 0x4088f056: rtl8139_init_module+0x0/0x11()
[   21.398186] 8139too Fast Ethernet driver 0.9.28
[   21.403521] eth1: RealTek RTL8139 at 0x80802000, 00:c0:df:03:68:5d, IRQ 11
[   21.410269] eth1:  Identified 8139 chip type 'RTL-8139B'
[   21.415581] initcall 0x4088f056: rtl8139_init_module+0x0/0x11() returned 0.
[   21.422481] initcall 0x4088f056 ran for 16 msecs: rtl8139_init_module+0x0/0x11()
[   21.429849] Calling initcall 0x4088f0d4: mlx4_init+0x0/0x26()
[   21.435728] initcall 0x4088f0d4: mlx4_init+0x0/0x26() returned 0.
[   21.441670] initcall 0x4088f0d4 ran for 0 msecs: mlx4_init+0x0/0x26()
[   21.448084] Calling initcall 0x4088f111: init_netconsole+0x0/0x162()
[   21.454409] console [netcon0] enabled
[   26.467049] NMI watchdog detected lockup on CPU#0 (5000/5000)
[   26.467051] 
[   26.467053] Pid: 1, comm: swapper Not tainted (2.6.24-rc2 #183)
[   26.467055] EIP: 0060:[<40113507>] EFLAGS: 00000006 CPU: 0
[   26.467059] EIP is at early_serial_putc+0x17/0x2b
[   26.467061] EAX: 00000000 EBX: 0000ffc0 ECX: 000003f8 EDX: 000003fd
[   26.467063] ESI: 00000069 EDI: 4011351b EBP: 0000e819 ESP: 7f815f28
[   26.467065]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   26.467067] CR0: 8005003b CR2: fff9b000 CR3: 008b5000 CR4: 000006c0
[   26.467070] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   26.467071] DR6: ffff0ff0 DR7: 00000400
[   26.467073]  [<4011353a>] early_serial_write+0x1f/0x2e
[   26.467076]  [<4011f80e>] __call_console_drivers+0x34/0x40
[   26.467080]  [<4011fa7c>] release_console_sem+0x113/0x1c4
[   26.467083]  [<4088f22c>] init_netconsole+0x11b/0x162
[   26.467086]  [<40131f73>] ktime_get+0xf/0x2b
[   26.467089]  [<40873633>] kernel_init+0xc9/0x242
[   26.467093]  [<4088f111>] init_netconsole+0x0/0x162
[   26.467096]  [<4087356a>] kernel_init+0x0/0x242
[   26.467099]  [<40105a5b>] kernel_thread_helper+0x7/0x10
[   26.467102]  =======================
[   26.467104] NMI watchdog running again ...
[   28.721664] netconsole: network logging started
[   28.726172] initcall 0x4088f111: init_netconsole+0x0/0x162() returned 0.
[   28.732840] initcall 0x4088f111 ran for 6935 msecs: init_netconsole+0x0/0x162()
[   28.740120] Calling initcall 0x4088f273: mac_hid_init+0x0/0x72()
[   28.746303] input: Macintosh mouse button emulation as /class/input/input0
[   28.753093] initcall 0x4088f273: mac_hid_init+0x0/0x72() returned 0.
[   28.759376] initcall 0x4088f273 ran for 6 msecs: mac_hid_init+0x0/0x72()
[   28.766049] Calling initcall 0x4088f532: raid_init+0x0/0xa()
[   28.771784] initcall 0x4088f532: raid_init+0x0/0xa() returned 0.
[   28.777662] initcall 0x4088f532 ran for 0 msecs: raid_init+0x0/0xa()
[   28.783988] Calling initcall 0x4088f53c: spi_transport_init+0x0/0x23()
[   28.790768] initcall 0x4088f53c: spi_transport_init+0x0/0x23() returned 0.
[   28.797490] initcall 0x4088f53c ran for 0 msecs: spi_transport_init+0x0/0x23()
[   28.804686] Calling initcall 0x4088f55f: fc_transport_init+0x0/0x3f()
[   28.811529] initcall 0x4088f55f: fc_transport_init+0x0/0x3f() returned 0.
[   28.818155] initcall 0x4088f55f ran for 0 msecs: fc_transport_init+0x0/0x3f()
[   28.825268] Calling initcall 0x4088f59e: iscsi_transport_init+0x0/0xce()
[   28.831935] Loading iSCSI transport class v2.0-724.
[   28.837212] initcall 0x4088f59e: iscsi_transport_init+0x0/0xce() returned 0.
[   28.844102] initcall 0x4088f59e ran for 5 msecs: iscsi_transport_init+0x0/0xce()
[   28.851474] Calling initcall 0x4088f66c: sas_transport_init+0x0/0x9b()
[   28.858549] initcall 0x4088f66c: sas_transport_init+0x0/0x9b() returned 0.
[   28.865268] initcall 0x4088f66c ran for 0 msecs: sas_transport_init+0x0/0x9b()
[   28.872460] Calling initcall 0x4088f707: sas_class_init+0x0/0x33()
[   28.878612] initcall 0x4088f707: sas_class_init+0x0/0x33() returned 0.
[   28.885112] initcall 0x4088f707 ran for 0 msecs: sas_class_init+0x0/0x33()
[   28.891960] Calling initcall 0x4088f73a: srp_transport_init+0x0/0x2f()
[   28.898653] initcall 0x4088f73a: srp_transport_init+0x0/0x2f() returned 0.
[   28.905375] initcall 0x4088f73a ran for 0 msecs: srp_transport_init+0x0/0x2f()
[   28.912566] Calling initcall 0x4088f85c: init_st+0x0/0x155()
[   28.918199] st: Version 20070203, fixed bufsize 32768, s/g segs 256
[   28.924653] initcall 0x4088f85c: init_st+0x0/0x155() returned 0.
[   28.930504] initcall 0x4088f85c ran for 6 msecs: init_st+0x0/0x155()
[   28.936833] Calling initcall 0x4088fa81: init_osst+0x0/0x11f()
[   28.942636] osst :I: Tape driver with OnStream support version 0.99.4
[   28.942638] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[   28.955934] initcall 0x4088fa81: init_osst+0x0/0x11f() returned 0.
[   28.961953] initcall 0x4088fa81 ran for 12 msecs: init_osst+0x0/0x11f()
[   28.968542] Calling initcall 0x4088fba0: init_sd+0x0/0xad()
[   28.974324] initcall 0x4088fba0: init_sd+0x0/0xad() returned 0.
[   28.980091] initcall 0x4088fba0 ran for 0 msecs: init_sd+0x0/0xad()
[   28.986334] Calling initcall 0x4088fc4d: init_sg+0x0/0x13b()
[   28.992084] initcall 0x4088fc4d: init_sg+0x0/0x13b() returned 0.
[   28.997943] initcall 0x4088fc4d ran for 0 msecs: init_sg+0x0/0x13b()
[   29.004272] Calling initcall 0x4088fe01: ahci_init+0x0/0x11()
[   29.010172] initcall 0x4088fe01: ahci_init+0x0/0x11() returned 0.
[   29.016107] initcall 0x4088fe01 ran for 0 msecs: ahci_init+0x0/0x11()
[   29.022523] Calling initcall 0x4088fe12: k2_sata_init+0x0/0x11()
[   29.028621] initcall 0x4088fe12: k2_sata_init+0x0/0x11() returned 0.
[   29.034825] initcall 0x4088fe12 ran for 0 msecs: k2_sata_init+0x0/0x11()
[   29.041501] Calling initcall 0x4088fe23: piix_init+0x0/0x23()
[   29.047337] initcall 0x4088fe23: piix_init+0x0/0x23() returned 0.
[   29.053288] initcall 0x4088fe23 ran for 0 msecs: piix_init+0x0/0x23()
[   29.059700] Calling initcall 0x4088fe46: pdc_ata_init+0x0/0x11()
[   29.065801] initcall 0x4088fe46: pdc_ata_init+0x0/0x11() returned 0.
[   29.072016] initcall 0x4088fe46 ran for 0 msecs: pdc_ata_init+0x0/0x11()
[   29.078679] Calling initcall 0x4088fe57: qs_ata_init+0x0/0x11()
[   29.084693] initcall 0x4088fe57: qs_ata_init+0x0/0x11() returned 0.
[   29.090809] initcall 0x4088fe57 ran for 0 msecs: qs_ata_init+0x0/0x11()
[   29.097398] Calling initcall 0x4088fe68: sil_init+0x0/0x11()
[   29.103152] initcall 0x4088fe68: sil_init+0x0/0x11() returned 0.
[   29.109011] initcall 0x4088fe68 ran for 0 msecs: sil_init+0x0/0x11()
[   29.115338] Calling initcall 0x4088fe79: uli_init+0x0/0x11()
[   29.121085] initcall 0x4088fe79: uli_init+0x0/0x11() returned 0.
[   29.126960] initcall 0x4088fe79 ran for 0 msecs: uli_init+0x0/0x11()
[   29.133276] Calling initcall 0x4088fe8a: inic_init+0x0/0x11()
[   29.139119] initcall 0x4088fe8a: inic_init+0x0/0x11() returned 0.
[   29.145062] initcall 0x4088fe8a ran for 0 msecs: inic_init+0x0/0x11()
[   29.151475] Calling initcall 0x4088fe9b: ali_init+0x0/0x11()
[   29.157225] initcall 0x4088fe9b: ali_init+0x0/0x11() returned 0.
[   29.163098] initcall 0x4088fe9b ran for 0 msecs: ali_init+0x0/0x11()
[   29.169414] Calling initcall 0x4088feac: amd_init+0x0/0x11()
[   29.175161] pata_amd 0000:00:06.0: version 0.3.9
[   29.179779] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   29.186056] scsi0 : pata_amd
[   29.189009] scsi1 : pata_amd
[   29.191935] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[   29.198771] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[   29.210836] Clocksource tsc unstable (delta = 7296760089 ns)
[   29.218840] Time: pit clocksource has been installed.
[   29.367338] ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
[   29.373482] ata1.00: 488397168 sectors, multi 1: LBA48 
[   29.391271] ata1.00: configured for UDMA/100
[   29.723061] ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
[   29.728956] ata2.01: limited to UDMA/33 due to 40-wire cable
[   29.890987] ata2.01: configured for UDMA/33
[   29.895362] scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
[   29.903954] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[   29.910991] sd 0:0:0:0: [sda] Write Protect is off
[   29.915732] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   29.920822] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   29.930102] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[   29.937141] sd 0:0:0:0: [sda] Write Protect is off
[   29.941885] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   29.946954] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   29.955955]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
[   30.051927] sd 0:0:0:0: [sda] Attached SCSI disk
[   30.056815] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   30.062759] scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
[   30.071333] scsi 1:0:1:0: Attached scsi generic sg1 type 5
[   30.076886] initcall 0x4088feac: amd_init+0x0/0x11() returned 0.
[   30.083200] initcall 0x4088feac ran for 825 msecs: amd_init+0x0/0x11()
[   30.089669] Calling initcall 0x4088febd: artop_init+0x0/0x11()
[   30.095608] initcall 0x4088febd: artop_init+0x0/0x11() returned 0.
[   30.101638] initcall 0x4088febd ran for 0 msecs: artop_init+0x0/0x11()
[   30.108140] Calling initcall 0x4088fece: atiixp_init+0x0/0x11()
[   30.114152] initcall 0x4088fece: atiixp_init+0x0/0x11() returned 0.
[   30.120266] initcall 0x4088fece ran for 0 msecs: atiixp_init+0x0/0x11()
[   30.126859] Calling initcall 0x4088fedf: cmd640_init+0x0/0x11()
[   30.132863] initcall 0x4088fedf: cmd640_init+0x0/0x11() returned 0.
[   30.139001] initcall 0x4088fedf ran for 0 msecs: cmd640_init+0x0/0x11()
[   30.145574] Calling initcall 0x4088fef0: cs5530_init+0x0/0x11()
[   30.151590] initcall 0x4088fef0: cs5530_init+0x0/0x11() returned 0.
[   30.157707] initcall 0x4088fef0 ran for 0 msecs: cs5530_init+0x0/0x11()
[   30.164297] Calling initcall 0x4088ff01: cs5535_init+0x0/0x11()
[   30.170298] initcall 0x4088ff01: cs5535_init+0x0/0x11() returned 0.
[   30.176423] initcall 0x4088ff01 ran for 0 msecs: cs5535_init+0x0/0x11()
[   30.183016] Calling initcall 0x4088ff12: cs5536_init+0x0/0x11()
[   30.189030] initcall 0x4088ff12: cs5536_init+0x0/0x11() returned 0.
[   30.195157] initcall 0x4088ff12 ran for 0 msecs: cs5536_init+0x0/0x11()
[   30.201730] Calling initcall 0x4088ff23: hpt3x2n_init+0x0/0x11()
[   30.207828] initcall 0x4088ff23: hpt3x2n_init+0x0/0x11() returned 0.
[   30.214033] initcall 0x4088ff23 ran for 0 msecs: hpt3x2n_init+0x0/0x11()
[   30.220716] Calling initcall 0x4088ff34: it821x_init+0x0/0x11()
[   30.226726] initcall 0x4088ff34: it821x_init+0x0/0x11() returned 0.
[   30.232843] initcall 0x4088ff34 ran for 0 msecs: it821x_init+0x0/0x11()
[   30.239431] Calling initcall 0x4088ff45: jmicron_init+0x0/0x11()
[   30.245524] initcall 0x4088ff45: jmicron_init+0x0/0x11() returned 0.
[   30.251746] initcall 0x4088ff45 ran for 0 msecs: jmicron_init+0x0/0x11()
[   30.258407] Calling initcall 0x4088ff56: opti_init+0x0/0x11()
[   30.264250] initcall 0x4088ff56: opti_init+0x0/0x11() returned 0.
[   30.270190] initcall 0x4088ff56 ran for 0 msecs: opti_init+0x0/0x11()
[   30.276611] Calling initcall 0x4088ff67: mpiix_init+0x0/0x11()
[   30.282528] initcall 0x4088ff67: mpiix_init+0x0/0x11() returned 0.
[   30.288562] initcall 0x4088ff67 ran for 0 msecs: mpiix_init+0x0/0x11()
[   30.295069] Calling initcall 0x4088ff78: oldpiix_init+0x0/0x11()
[   30.301167] initcall 0x4088ff78: oldpiix_init+0x0/0x11() returned 0.
[   30.307383] initcall 0x4088ff78 ran for 0 msecs: oldpiix_init+0x0/0x11()
[   30.314043] Calling initcall 0x4088ff89: radisys_init+0x0/0x11()
[   30.320140] initcall 0x4088ff89: radisys_init+0x0/0x11() returned 0.
[   30.326346] initcall 0x4088ff89 ran for 0 msecs: radisys_init+0x0/0x11()
[   30.333022] Calling initcall 0x4088ff9a: sc1200_init+0x0/0x11()
[   30.339048] initcall 0x4088ff9a: sc1200_init+0x0/0x11() returned 0.
[   30.345164] initcall 0x4088ff9a ran for 0 msecs: sc1200_init+0x0/0x11()
[   30.351754] Calling initcall 0x4088ffab: serverworks_init+0x0/0x11()
[   30.358198] initcall 0x4088ffab: serverworks_init+0x0/0x11() returned 0.
[   30.364749] initcall 0x4088ffab ran for 0 msecs: serverworks_init+0x0/0x11()
[   30.371772] Calling initcall 0x4088ffbc: sil680_init+0x0/0x11()
[   30.377784] initcall 0x4088ffbc: sil680_init+0x0/0x11() returned 0.
[   30.383913] initcall 0x4088ffbc ran for 0 msecs: sil680_init+0x0/0x11()
[   30.390487] Calling initcall 0x4088ffcd: sl82c105_init+0x0/0x11()
[   30.396684] initcall 0x4088ffcd: sl82c105_init+0x0/0x11() returned 0.
[   30.402978] initcall 0x4088ffcd ran for 0 msecs: sl82c105_init+0x0/0x11()
[   30.409726] Calling initcall 0x4088ffde: triflex_init+0x0/0x11()
[   30.415831] initcall 0x4088ffde: triflex_init+0x0/0x11() returned 0.
[   30.422029] initcall 0x4088ffde ran for 0 msecs: triflex_init+0x0/0x11()
[   30.428712] Calling initcall 0x4088ffef: ata_generic_init+0x0/0x11()
[   30.435159] initcall 0x4088ffef: ata_generic_init+0x0/0x11() returned 0.
[   30.441704] initcall 0x4088ffef ran for 0 msecs: ata_generic_init+0x0/0x11()
[   30.448730] Calling initcall 0x4089010b: nonstatic_sysfs_init+0x0/0xa()
[   30.455316] initcall 0x4089010b: nonstatic_sysfs_init+0x0/0xa() returned 0.
[   30.462240] initcall 0x4089010b ran for 0 msecs: nonstatic_sysfs_init+0x0/0xa()
[   30.469528] Calling initcall 0x403ff7cd: pd6729_module_init+0x0/0x11()
[   30.476146] initcall 0x403ff7cd: pd6729_module_init+0x0/0x11() returned 0.
[   30.482880] initcall 0x403ff7cd ran for 0 msecs: pd6729_module_init+0x0/0x11()
[   30.490061] Calling initcall 0x40890339: mon_init+0x0/0xec()
[   30.495974] initcall 0x40890339: mon_init+0x0/0xec() returned 0.
[   30.501829] initcall 0x40890339 ran for 0 msecs: mon_init+0x0/0xec()
[   30.508160] Calling initcall 0x408904f6: ehci_hcd_init+0x0/0x11()
[   30.514395] PCI: No IRQ known for interrupt pin B of device 0000:00:02.1. Probably buggy MP table.
[   30.523253] ehci_hcd 0000:00:02.1: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.1 setup!
[   30.531685] ehci_hcd 0000:00:02.1: init 0000:00:02.1 fail, -19
[   30.537493] initcall 0x408904f6: ehci_hcd_init+0x0/0x11() returned 0.
[   30.543873] initcall 0x408904f6 ran for 9 msecs: ehci_hcd_init+0x0/0x11()
[   30.550628] Calling initcall 0x40890507: ohci_hcd_mod_init+0x0/0x5f()
[   30.557043] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   30.564652] PCI: No IRQ known for interrupt pin A of device 0000:00:02.0. Probably buggy MP table.
[   30.573507] ohci_hcd 0000:00:02.0: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.0 setup!
[   30.581929] ohci_hcd 0000:00:02.0: init 0000:00:02.0 fail, -19
[   30.587857] initcall 0x40890507: ohci_hcd_mod_init+0x0/0x5f() returned 0.
[   30.594485] initcall 0x40890507 ran for 17 msecs: ohci_hcd_mod_init+0x0/0x5f()
[   30.601681] Calling initcall 0x40890566: uhci_hcd_init+0x0/0x9c()
[   30.607748] USB Universal Host Controller Interface driver v3.0
[   30.613771] initcall 0x40890566: uhci_hcd_init+0x0/0x9c() returned 0.
[   30.620050] initcall 0x40890566 ran for 1 msecs: uhci_hcd_init+0x0/0x9c()
[   30.626818] Calling initcall 0x40890602: sl811h_init+0x0/0x3e()
[   30.632710] sl811: driver sl811-hcd, 19 May 2005
[   30.637442] initcall 0x40890602: sl811h_init+0x0/0x3e() returned 0.
[   30.643568] initcall 0x40890602 ran for 0 msecs: sl811h_init+0x0/0x3e()
[   30.650141] Calling initcall 0x40890640: acm_init+0x0/0xd9()
[   30.655894] usbcore: registered new interface driver cdc_acm
[   30.661438] drivers/usb/class/cdc-acm.c: v0.25:USB Abstract Control Model driver for USB modems and ISDN adapters
[   30.671671] initcall 0x40890640: acm_init+0x0/0xd9() returned 0.
[   30.677631] initcall 0x40890640 ran for 7 msecs: acm_init+0x0/0xd9()
[   30.683960] Calling initcall 0x40890719: usblp_init+0x0/0x11()
[   30.689875] usbcore: registered new interface driver usblp
[   30.695247] initcall 0x40890719: usblp_init+0x0/0x11() returned 0.
[   30.701384] initcall 0x40890719 ran for 3 msecs: usblp_init+0x0/0x11()
[   30.707888] Calling initcall 0x4089072a: usb_stor_init+0x0/0x38()
[   30.713952] Initializing USB Mass Storage driver...
[   30.718921] usbcore: registered new interface driver usb-storage
[   30.724810] USB Mass Storage support registered.
[   30.729413] initcall 0x4089072a: usb_stor_init+0x0/0x38() returned 0.
[   30.735811] initcall 0x4089072a ran for 9 msecs: usb_stor_init+0x0/0x38()
[   30.742565] Calling initcall 0x40890762: adu_init+0x0/0xa2()
[   30.748306] usbcore: registered new interface driver adutux
[   30.753756] drivers/usb/misc/adutux.c: adutux adutux (see www.ontrak.net) v0.0.13
[   30.761213] drivers/usb/misc/adutux.c: adutux is an experimental driver. Use at your own risk
[   30.769703] initcall 0x40890762: adu_init+0x0/0xa2() returned 0.
[   30.775674] initcall 0x40890762 ran for 9 msecs: adu_init+0x0/0xa2()
[   30.781996] Calling initcall 0x40890804: appledisplay_init+0x0/0x54()
[   30.788567] usbcore: registered new interface driver appledisplay
[   30.794542] initcall 0x40890804: appledisplay_init+0x0/0x54() returned 0.
[   30.801288] initcall 0x40890804 ran for 2 msecs: appledisplay_init+0x0/0x54()
[   30.808397] Calling initcall 0x40890858: auerswald_init+0x0/0x36()
[   30.814647] usbcore: registered new interface driver auerswald
[   30.820368] initcall 0x40890858: auerswald_init+0x0/0x36() returned 0.
[   30.826856] initcall 0x40890858 ran for 4 msecs: auerswald_init+0x0/0x36()
[   30.833698] Calling initcall 0x4089088e: emi62_init+0x0/0x2c()
[   30.839619] usbcore: registered new interface driver emi62 - firmware loader
[   30.846547] initcall 0x4089088e: emi62_init+0x0/0x2c() returned 0.
[   30.852687] initcall 0x4089088e ran for 2 msecs: emi62_init+0x0/0x2c()
[   30.859190] Calling initcall 0x408908ba: ftdi_elan_init+0x0/0x134()
[   30.865427] driver ftdi-elan built at 19:51:07 on Nov 13 2007
[   30.871396] usbcore: registered new interface driver ftdi-elan
[   30.877113] initcall 0x408908ba: ftdi_elan_init+0x0/0x134() returned 0.
[   30.883689] initcall 0x408908ba ran for 5 msecs: ftdi_elan_init+0x0/0x134()
[   30.890618] Calling initcall 0x408909ee: ld_usb_init+0x0/0x3a()
[   30.896614] usbcore: registered new interface driver ldusb
[   30.901984] initcall 0x408909ee: ld_usb_init+0x0/0x3a() returned 0.
[   30.908207] initcall 0x408909ee ran for 1 msecs: ld_usb_init+0x0/0x3a()
[   30.914799] Calling initcall 0x40890a28: lego_usb_tower_init+0x0/0x91()
[   30.921484] usbcore: registered new interface driver legousbtower
[   30.927461] drivers/usb/misc/legousbtower.c: LEGO USB Tower Driver v0.96
[   30.934140] initcall 0x40890a28: lego_usb_tower_init+0x0/0x91() returned 0.
[   30.941055] initcall 0x40890a28 ran for 8 msecs: lego_usb_tower_init+0x0/0x91()
[   30.948338] Calling initcall 0x40890ab9: init_phidget+0x0/0x1f()
[   30.954417] initcall 0x40890ab9: init_phidget+0x0/0x1f() returned 0.
[   30.960637] initcall 0x40890ab9 ran for 0 msecs: init_phidget+0x0/0x1f()
[   30.967318] Calling initcall 0x40890ad8: interfacekit_init+0x0/0x3a()
[   30.973831] usbcore: registered new interface driver phidgetkit
[   30.979633] initcall 0x40890ad8: interfacekit_init+0x0/0x3a() returned 0.
[   30.986375] initcall 0x40890ad8 ran for 4 msecs: interfacekit_init+0x0/0x3a()
[   30.993484] Calling initcall 0x40890b12: motorcontrol_init+0x0/0x3a()
[   31.000001] usbcore: registered new interface driver phidgetmotorcontrol
[   31.006585] initcall 0x40890b12: motorcontrol_init+0x0/0x3a() returned 0.
[   31.013330] initcall 0x40890b12 ran for 2 msecs: motorcontrol_init+0x0/0x3a()
[   31.020440] Calling initcall 0x40890b4c: phidget_servo_init+0x0/0x3a()
[   31.027056] usbcore: registered new interface driver phidgetservo
[   31.033034] initcall 0x40890b4c: phidget_servo_init+0x0/0x3a() returned 0.
[   31.039870] initcall 0x40890b4c ran for 1 msecs: phidget_servo_init+0x0/0x3a()
[   31.047065] Calling initcall 0x40890b86: usb_rio_init+0x0/0x35()
[   31.053150] usbcore: registered new interface driver rio500
[   31.058604] drivers/usb/misc/rio500.c: v1.1:USB Rio 500 driver
[   31.064418] initcall 0x40890b86: usb_rio_init+0x0/0x35() returned 0.
[   31.070723] initcall 0x40890b86 ran for 10 msecs: usb_rio_init+0x0/0x35()
[   31.077485] Calling initcall 0x40890bbb: tv_init+0x0/0x50()
[   31.083147] usbcore: registered new interface driver trancevibrator
[   31.089298] drivers/usb/misc/trancevibrator.c: v1.1:PlayStation 2 Trance Vibrator driver
[   31.097366] initcall 0x40890bbb: tv_init+0x0/0x50() returned 0.
[   31.103244] initcall 0x40890bbb ran for 6 msecs: tv_init+0x0/0x50()
[   31.109480] Calling initcall 0x40890c9c: i8042_init+0x0/0xbc()
[   31.118262] serio: i8042 KBD port at 0x60,0x64 irq 1
[   31.123134] serio: i8042 AUX port at 0x60,0x64 irq 12
[   31.128155] initcall 0x40890c9c: i8042_init+0x0/0xbc() returned 0.
[   31.134280] initcall 0x40890c9c ran for 8 msecs: i8042_init+0x0/0xbc()
[   31.140783] Calling initcall 0x40890d58: serport_init+0x0/0x2a()
[   31.147199] initcall 0x40890d58: serport_init+0x0/0x2a() returned 0.
[   31.153513] initcall 0x40890d58 ran for 0 msecs: serport_init+0x0/0x2a()
[   31.160189] Calling initcall 0x40890d82: ct82c710_init+0x0/0x169()
[   31.166355] initcall 0x40890d82: ct82c710_init+0x0/0x169() returned -19.
[   31.173012] initcall 0x40890d82 ran for 0 msecs: ct82c710_init+0x0/0x169()
[   31.179862] Calling initcall 0x40890eeb: serio_raw_init+0x0/0x11()
[   31.186508] initcall 0x40890eeb: serio_raw_init+0x0/0x11() returned 0.
[   31.192884] initcall 0x40890eeb ran for 0 msecs: serio_raw_init+0x0/0x11()
[   31.199733] Calling initcall 0x40890f8d: emu_init+0x0/0x11()
[   31.205489] initcall 0x40890f8d: emu_init+0x0/0x11() returned 0.
[   31.211370] initcall 0x40890f8d ran for 0 msecs: emu_init+0x0/0x11()
[   31.217668] Calling initcall 0x40890f9e: fm801_gp_init+0x0/0x11()
[   31.223856] initcall 0x40890f9e: fm801_gp_init+0x0/0x11() returned 0.
[   31.230145] initcall 0x40890f9e ran for 0 msecs: fm801_gp_init+0x0/0x11()
[   31.236915] Calling initcall 0x40890faf: ns558_init+0x0/0x27f()
[   31.251566] initcall 0x40890faf: ns558_init+0x0/0x27f() returned -19.
[   31.257853] initcall 0x40890faf ran for 8 msecs: ns558_init+0x0/0x27f()
[   31.264443] Calling initcall 0x40891327: mousedev_init+0x0/0x50()
[   31.283009] mice: PS/2 mouse device common for all mice
[   31.288118] initcall 0x40891327: mousedev_init+0x0/0x50() returned 0.
[   31.294517] initcall 0x40891327 ran for 19 msecs: mousedev_init+0x0/0x50()
[   31.301366] Calling initcall 0x40891377: atkbd_init+0x0/0x11()
[   31.307314] initcall 0x40891377: atkbd_init+0x0/0x11() returned 0.
[   31.313342] initcall 0x40891377 ran for 0 msecs: atkbd_init+0x0/0x11()
[   31.319847] Calling initcall 0x40891388: lkkbd_init+0x0/0x11()
[   31.347946] input: AT Translated Set 2 keyboard as /class/input/input1
[   31.373037] initcall 0x40891388: lkkbd_init+0x0/0x11() returned 0.
[   31.379062] initcall 0x40891388 ran for 45 msecs: lkkbd_init+0x0/0x11()
[   31.385644] Calling initcall 0x40891399: xtkbd_init+0x0/0x11()
[   31.391568] initcall 0x40891399: xtkbd_init+0x0/0x11() returned 0.
[   31.397603] initcall 0x40891399 ran for 0 msecs: xtkbd_init+0x0/0x11()
[   31.404106] Calling initcall 0x408913aa: skbd_init+0x0/0x11()
[   31.409941] initcall 0x408913aa: skbd_init+0x0/0x11() returned 0.
[   31.415902] initcall 0x408913aa ran for 0 msecs: skbd_init+0x0/0x11()
[   31.422301] Calling initcall 0x408913bb: a3d_init+0x0/0xf()
[   31.427869] initcall 0x408913bb: a3d_init+0x0/0xf() returned 0.
[   31.433741] initcall 0x408913bb ran for 0 msecs: a3d_init+0x0/0xf()
[   31.439985] Calling initcall 0x408913ca: cobra_init+0x0/0xf()
[   31.445707] initcall 0x408913ca: cobra_init+0x0/0xf() returned 0.
[   31.451769] initcall 0x408913ca ran for 0 msecs: cobra_init+0x0/0xf()
[   31.458179] Calling initcall 0x408913d9: gf2k_init+0x0/0xf()
[   31.463818] initcall 0x408913d9: gf2k_init+0x0/0xf() returned 0.
[   31.469791] initcall 0x408913d9 ran for 0 msecs: gf2k_init+0x0/0xf()
[   31.476121] Calling initcall 0x408913e8: grip_init+0x0/0xf()
[   31.481757] initcall 0x408913e8: grip_init+0x0/0xf() returned 0.
[   31.487735] initcall 0x408913e8 ran for 0 msecs: grip_init+0x0/0xf()
[   31.494057] Calling initcall 0x408913f7: guillemot_init+0x0/0xf()
[   31.500130] initcall 0x408913f7: guillemot_init+0x0/0xf() returned 0.
[   31.506533] initcall 0x408913f7 ran for 0 msecs: guillemot_init+0x0/0xf()
[   31.513295] Calling initcall 0x40891406: interact_init+0x0/0xf()
[   31.519282] initcall 0x40891406: interact_init+0x0/0xf() returned 0.
[   31.525602] initcall 0x40891406 ran for 0 msecs: interact_init+0x0/0xf()
[   31.532278] Calling initcall 0x40891415: joydump_init+0x0/0xf()
[   31.538173] initcall 0x40891415: joydump_init+0x0/0xf() returned 0.
[   31.544405] initcall 0x40891415 ran for 0 msecs: joydump_init+0x0/0xf()
[   31.550996] Calling initcall 0x40891424: twidjoy_init+0x0/0x11()
[   31.558117] initcall 0x40891424: twidjoy_init+0x0/0x11() returned 0.
[   31.564311] initcall 0x40891424 ran for 1 msecs: twidjoy_init+0x0/0x11()
[   31.570990] Calling initcall 0x40891435: warrior_init+0x0/0x11()
[   31.577088] initcall 0x40891435: warrior_init+0x0/0x11() returned 0.
[   31.583358] initcall 0x40891435 ran for 0 msecs: warrior_init+0x0/0x11()
[   31.589965] Calling initcall 0x40891446: usb_acecad_init+0x0/0x35()
[   31.596307] usbcore: registered new interface driver usb_acecad
[   31.602108] drivers/input/tablet/acecad.c: v3.2:USB Acecad Flair tablet driver
[   31.609311] initcall 0x40891446: usb_acecad_init+0x0/0x35() returned 0.
[   31.615880] initcall 0x40891446 ran for 4 msecs: usb_acecad_init+0x0/0x35()
[   31.622815] Calling initcall 0x4089147b: gtco_init+0x0/0x50()
[   31.628634] usbcore: registered new interface driver gtco
[   31.633913] GTCO usb driver version: 2.00.0006initcall 0x4089147b: gtco_init+0x0/0x50() returned 0.
[   31.642918] initcall 0x4089147b ran for 5 msecs: gtco_init+0x0/0x50()
[   31.649327] Calling initcall 0x408914cb: elo_init+0x0/0x11()
[   31.655066] initcall 0x408914cb: elo_init+0x0/0x11() returned 0.
[   31.660941] initcall 0x408914cb ran for 0 msecs: elo_init+0x0/0x11()
[   31.667271] Calling initcall 0x408914dc: fujitsu_init+0x0/0x11()
[   31.673368] initcall 0x408914dc: fujitsu_init+0x0/0x11() returned 0.
[   31.679584] initcall 0x408914dc ran for 0 msecs: fujitsu_init+0x0/0x11()
[   31.686245] Calling initcall 0x408914ed: mk712_init+0x0/0x1b8()
[   31.692142] mk712: device not present
[   31.695791] initcall 0x408914ed: mk712_init+0x0/0x1b8() returned -19.
[   31.702189] initcall 0x408914ed ran for 3 msecs: mk712_init+0x0/0x1b8()
[   31.708785] Calling initcall 0x408916a5: usbtouch_init+0x0/0x11()
[   31.714952] usbcore: registered new interface driver usbtouchscreen
[   31.721107] initcall 0x408916a5: usbtouch_init+0x0/0x11() returned 0.
[   31.727510] initcall 0x408916a5 ran for 2 msecs: usbtouch_init+0x0/0x11()
[   31.734265] Calling initcall 0x408916b6: pm_init+0x0/0x11()
[   31.739927] initcall 0x408916b6: pm_init+0x0/0x11() returned 0.
[   31.745703] initcall 0x408916b6 ran for 0 msecs: pm_init+0x0/0x11()
[   31.751947] Calling initcall 0x408916c7: tr_init+0x0/0x11()
[   31.757602] initcall 0x408916c7: tr_init+0x0/0x11() returned 0.
[   31.763395] initcall 0x408916c7 ran for 0 msecs: tr_init+0x0/0x11()
[   31.769622] Calling initcall 0x408916d8: pcspkr_init+0x0/0xa()
[   31.775720] input: PC Speaker as /class/input/input2
[   31.790807] initcall 0x408916d8: pcspkr_init+0x0/0xa() returned 0.
[   31.796833] initcall 0x408916d8 ran for 14 msecs: pcspkr_init+0x0/0xa()
[   31.803424] Calling initcall 0x40891738: wb_module_init+0x0/0x272()
[   31.809670] wistron_btns: System unknown
[   31.813570] initcall 0x40891738: wb_module_init+0x0/0x272() returned -19.
[   31.820316] initcall 0x40891738 ran for 2 msecs: wb_module_init+0x0/0x272()
[   31.827256] Calling initcall 0x408919aa: usb_keyspan_init+0x0/0x3a()
[   31.833682] usbcore: registered new interface driver keyspan_remote
[   31.839832] initcall 0x408919aa: usb_keyspan_init+0x0/0x3a() returned 0.
[   31.846488] initcall 0x408919aa ran for 4 msecs: usb_keyspan_init+0x0/0x3a()
[   31.853510] Calling initcall 0x408919e4: powermate_init+0x0/0x11()
[   31.859767] usbcore: registered new interface driver powermate
[   31.865484] initcall 0x408919e4: powermate_init+0x0/0x11() returned 0.
[   31.871974] initcall 0x408919e4 ran for 1 msecs: powermate_init+0x0/0x11()
[   31.878822] Calling initcall 0x408919f5: yealink_dev_init+0x0/0x35()
[   31.885247] usbcore: registered new interface driver yealink
[   31.890785] drivers/input/misc/yealink.c: Yealink phone driver:yld-20051230
[   31.897727] initcall 0x408919f5: yealink_dev_init+0x0/0x35() returned 0.
[   31.904377] initcall 0x408919f5 ran for 8 msecs: yealink_dev_init+0x0/0x35()
[   31.911404] Calling initcall 0x40891a2a: uinput_init+0x0/0xa()
[   31.917330] initcall 0x40891a2a: uinput_init+0x0/0xa() returned 0.
[   31.923371] initcall 0x40891a2a ran for 0 msecs: uinput_init+0x0/0xa()
[   31.929859] Calling initcall 0x40891ad8: i2c_savage4_init+0x0/0x11()
[   31.936316] initcall 0x40891ad8: i2c_savage4_init+0x0/0x11() returned 0.
[   31.942870] initcall 0x40891ad8 ran for 0 msecs: i2c_savage4_init+0x0/0x11()
[   31.949877] Calling initcall 0x40891ae9: i2c_sis5595_init+0x0/0x11()
[   31.956328] initcall 0x40891ae9: i2c_sis5595_init+0x0/0x11() returned 0.
[   31.962888] initcall 0x40891ae9 ran for 0 msecs: i2c_sis5595_init+0x0/0x11()
[   31.969896] Calling initcall 0x40891afa: ds1337_init+0x0/0xc()
[   31.975830] initcall 0x40891afa: ds1337_init+0x0/0xc() returned 0.
[   31.981855] initcall 0x40891afa ran for 0 msecs: ds1337_init+0x0/0xc()
[   31.988358] Calling initcall 0x40891b06: ds1374_init+0x0/0xc()
[   31.994272] initcall 0x40891b06: ds1374_init+0x0/0xc() returned 0.
[   32.000311] initcall 0x40891b06 ran for 0 msecs: ds1374_init+0x0/0xc()
[   32.006818] Calling initcall 0x40891b12: ds1682_init+0x0/0xc()
[   32.012734] initcall 0x40891b12: ds1682_init+0x0/0xc() returned 0.
[   32.018786] initcall 0x40891b12 ran for 0 msecs: ds1682_init+0x0/0xc()
[   32.025272] Calling initcall 0x40891b1e: eeprom_init+0x0/0xc()
[   32.031187] initcall 0x40891b1e: eeprom_init+0x0/0xc() returned 0.
[   32.037232] initcall 0x40891b1e ran for 0 msecs: eeprom_init+0x0/0xc()
[   32.043735] Calling initcall 0x40891b2a: pca9539_init+0x0/0xc()
[   32.049735] initcall 0x40891b2a: pca9539_init+0x0/0xc() returned 0.
[   32.055877] initcall 0x40891b2a ran for 0 msecs: pca9539_init+0x0/0xc()
[   32.062451] Calling initcall 0x40891b36: tsl2550_init+0x0/0xc()
[   32.068453] initcall 0x40891b36: tsl2550_init+0x0/0xc() returned 0.
[   32.074580] initcall 0x40891b36 ran for 0 msecs: tsl2550_init+0x0/0xc()
[   32.081170] Calling initcall 0x4044b805: w1_init+0x0/0xfa()
[   32.086716] Driver for 1-wire Dallas network protocol.
[   32.092224] initcall 0x4044b805: w1_init+0x0/0xfa() returned 0.
[   32.097988] initcall 0x4044b805 ran for 5 msecs: w1_init+0x0/0xfa()
[   32.104233] Calling initcall 0x4044cbf0: ds_init+0x0/0x31()
[   32.109895] usbcore: registered new interface driver DS9490R
[   32.115441] initcall 0x4044cbf0: ds_init+0x0/0x31() returned 0.
[   32.121320] initcall 0x4044cbf0 ran for 3 msecs: ds_init+0x0/0x31()
[   32.127563] Calling initcall 0x40891b42: sensors_ds2482_init+0x0/0xc()
[   32.134170] initcall 0x40891b42: sensors_ds2482_init+0x0/0xc() returned 0.
[   32.140905] initcall 0x40891b42 ran for 0 msecs: sensors_ds2482_init+0x0/0xc()
[   32.148101] Calling initcall 0x40891b4e: w1_ds2760_init+0x0/0x24()
[   32.154252] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[   32.163041] initcall 0x40891b4e: w1_ds2760_init+0x0/0x24() returned 0.
[   32.169503] initcall 0x40891b4e ran for 3 msecs: w1_ds2760_init+0x0/0x24()
[   32.176353] Calling initcall 0x40891bca: asb100_init+0x0/0xc()
[   32.182272] initcall 0x40891bca: asb100_init+0x0/0xc() returned 0.
[   32.188305] initcall 0x40891bca ran for 0 msecs: asb100_init+0x0/0xc()
[   32.194811] Calling initcall 0x40891d56: sensors_w83627hf_init+0x0/0x12b()
[   32.201676] initcall 0x40891d56: sensors_w83627hf_init+0x0/0x12b() returned -19.
[   32.209021] initcall 0x40891d56 ran for 0 msecs: sensors_w83627hf_init+0x0/0x12b()
[   32.216563] Calling initcall 0x40891e81: sensors_w83792d_init+0x0/0xc()
[   32.223256] initcall 0x40891e81: sensors_w83792d_init+0x0/0xc() returned 0.
[   32.230077] initcall 0x40891e81 ran for 0 msecs: sensors_w83792d_init+0x0/0xc()
[   32.237365] Calling initcall 0x40891e8d: sensors_w83781d_init+0x0/0x34c()
[   32.244317] initcall 0x40891e8d: sensors_w83781d_init+0x0/0x34c() returned 0.
[   32.251306] initcall 0x40891e8d ran for 0 msecs: sensors_w83781d_init+0x0/0x34c()
[   32.258747] Calling initcall 0x408921d9: sensors_w83791d_init+0x0/0xc()
[   32.265444] initcall 0x408921d9: sensors_w83791d_init+0x0/0xc() returned 0.
[   32.272262] initcall 0x408921d9 ran for 0 msecs: sensors_w83791d_init+0x0/0xc()
[   32.279550] Calling initcall 0x408921e5: sensors_adm1025_init+0x0/0xc()
[   32.286250] initcall 0x408921e5: sensors_adm1025_init+0x0/0xc() returned 0.
[   32.293064] initcall 0x408921e5 ran for 0 msecs: sensors_adm1025_init+0x0/0xc()
[   32.300820] Calling initcall 0x408921f1: sensors_adm1029_init+0x0/0xc()
[   32.307507] initcall 0x408921f1: sensors_adm1029_init+0x0/0xc() returned 0.
[   32.314328] initcall 0x408921f1 ran for 0 msecs: sensors_adm1029_init+0x0/0xc()
[   32.321610] Calling initcall 0x408921fd: sensors_adm9240_init+0x0/0xc()
[   32.328368] initcall 0x408921fd: sensors_adm9240_init+0x0/0xc() returned 0.
[   32.335185] initcall 0x408921fd ran for 0 msecs: sensors_adm9240_init+0x0/0xc()
[   32.342452] Calling initcall 0x40892209: adt7470_init+0x0/0xc()
[   32.348456] initcall 0x40892209: adt7470_init+0x0/0xc() returned 0.
[   32.354583] initcall 0x40892209 ran for 0 msecs: adt7470_init+0x0/0xc()
[   32.361172] Calling initcall 0x40892215: coretemp_init+0x0/0x1a1()
[   32.367329] initcall 0x40892215: coretemp_init+0x0/0x1a1() returned -19.
[   32.373997] initcall 0x40892215 ran for 0 msecs: coretemp_init+0x0/0x1a1()
[   32.380850] Calling initcall 0x40892433: dme1737_init+0x0/0x11a()
[   32.387047] initcall 0x40892433: dme1737_init+0x0/0x11a() returned 0.
[   32.393332] initcall 0x40892433 ran for 0 msecs: dme1737_init+0x0/0x11a()
[   32.400094] Calling initcall 0x4089254d: ds1621_init+0x0/0xc()
[   32.406007] initcall 0x4089254d: ds1621_init+0x0/0xc() returned 0.
[   32.412048] initcall 0x4089254d ran for 0 msecs: ds1621_init+0x0/0xc()
[   32.418550] Calling initcall 0x40892657: f71805f_init+0x0/0x12a()
[   32.424646] initcall 0x40892657: f71805f_init+0x0/0x12a() returned -19.
[   32.431207] initcall 0x40892657 ran for 0 msecs: f71805f_init+0x0/0x12a()
[   32.437962] Calling initcall 0x40892891: f71882fg_init+0x0/0xe5()
[   32.444039] f71882fg: Not a Fintek device
[   32.448034] f71882fg: Not a Fintek device
[   32.452014] initcall 0x40892891: f71882fg_init+0x0/0xe5() returned -19.
[   32.458584] initcall 0x40892891 ran for 7 msecs: f71882fg_init+0x0/0xe5()
[   32.465347] Calling initcall 0x40892976: fschmd_init+0x0/0xc()
[   32.471325] initcall 0x40892976: fschmd_init+0x0/0xc() returned 0.
[   32.477349] initcall 0x40892976 ran for 0 msecs: fschmd_init+0x0/0xc()
[   32.483853] Calling initcall 0x40892982: sensors_gl518sm_init+0x0/0xc()
[   32.490546] initcall 0x40892982: sensors_gl518sm_init+0x0/0xc() returned 0.
[   32.497368] initcall 0x40892982 ran for 0 msecs: sensors_gl518sm_init+0x0/0xc()
[   32.504652] Calling initcall 0x408929ce: hdaps_init+0x0/0x1c2()
[   32.510546] hdaps: supported laptop not found!
[   32.514968] hdaps: driver init failed (ret=-19)!
[   32.519564] initcall 0x408929ce: hdaps_init+0x0/0x1c2() returned -19.
[   32.525967] initcall 0x408929ce ran for 6 msecs: hdaps_init+0x0/0x1c2()
[   32.532557] Calling initcall 0x40892b90: sm_it87_init+0x0/0x228()
[   32.538650] it87: Found IT8712F chip at 0x290, revision 7
[   32.544004] it87: in3 is VCC (+5V)
[   32.547380] it87: in7 is VCCH (+5V Stand-By)
[   32.551920] it87 it87.656: Detected broken BIOS defaults, disabling PWM interface
[   32.559716] initcall 0x40892b90: sm_it87_init+0x0/0x228() returned 0.
[   32.566001] initcall 0x40892b90 ran for 14 msecs: sm_it87_init+0x0/0x228()
[   32.572857] Calling initcall 0x40892db8: k8temp_init+0x0/0x11()
[   32.579135] initcall 0x40892db8: k8temp_init+0x0/0x11() returned 0.
[   32.585242] initcall 0x40892db8 ran for 0 msecs: k8temp_init+0x0/0x11()
[   32.591833] Calling initcall 0x40892dc9: sensors_lm75_init+0x0/0xc()
[   32.598253] initcall 0x40892dc9: sensors_lm75_init+0x0/0xc() returned 0.
[   32.604828] initcall 0x40892dc9 ran for 0 msecs: sensors_lm75_init+0x0/0xc()
[   32.611851] Calling initcall 0x40892dd5: lm93_init+0x0/0xc()
[   32.617581] initcall 0x40892dd5: lm93_init+0x0/0xc() returned 0.
[   32.623473] initcall 0x40892dd5 ran for 0 msecs: lm93_init+0x0/0xc()
[   32.629787] Calling initcall 0x40892de1: sensors_max1619_init+0x0/0xc()
[   32.636500] initcall 0x40892de1: sensors_max1619_init+0x0/0xc() returned 0.
[   32.643319] initcall 0x40892de1 ran for 0 msecs: sensors_max1619_init+0x0/0xc()
[   32.650585] Calling initcall 0x40892ded: sm_smsc47m1_init+0x0/0x1af()
[   32.657010] initcall 0x40892ded: sm_smsc47m1_init+0x0/0x1af() returned -19.
[   32.663935] initcall 0x40892ded ran for 0 msecs: sm_smsc47m1_init+0x0/0x1af()
[   32.671043] Calling initcall 0x40893044: vt1211_init+0x0/0x146()
[   32.677039] initcall 0x40893044: vt1211_init+0x0/0x146() returned -19.
[   32.683521] initcall 0x40893044 ran for 0 msecs: vt1211_init+0x0/0x146()
[   32.690189] Calling initcall 0x4089318a: sm_vt8231_init+0x0/0x11()
[   32.696458] initcall 0x4089318a: sm_vt8231_init+0x0/0x11() returned 0.
[   32.702856] initcall 0x4089318a ran for 0 msecs: sm_vt8231_init+0x0/0x11()
[   32.709688] Calling initcall 0x4089319b: sensors_w83l785ts_init+0x0/0xc()
[   32.716575] initcall 0x4089319b: sensors_w83l785ts_init+0x0/0xc() returned 0.
[   32.723567] initcall 0x4089319b ran for 0 msecs: sensors_w83l785ts_init+0x0/0xc()
[   32.731013] Calling initcall 0x408931a7: vhci_init+0x0/0x59()
[   32.736731] Bluetooth: Virtual HCI driver ver 1.2
[   32.741525] initcall 0x408931a7: vhci_init+0x0/0x59() returned 0.
[   32.747485] initcall 0x408931a7 ran for 0 msecs: vhci_init+0x0/0x59()
[   32.753885] Calling initcall 0x40893200: bpa10x_init+0x0/0x2b()
[   32.759780] Bluetooth: Digianswer Bluetooth USB driver ver 0.9
[   32.765717] usbcore: registered new interface driver bpa10x
[   32.771172] initcall 0x40893200: bpa10x_init+0x0/0x2b() returned 0.
[   32.777397] initcall 0x40893200 ran for 7 msecs: bpa10x_init+0x0/0x2b()
[   32.783987] Calling initcall 0x4089322b: init_bluecard_cs+0x0/0xa()
[   32.790327] initcall 0x4089322b: init_bluecard_cs+0x0/0xa() returned 0.
[   32.796808] initcall 0x4089322b ran for 0 msecs: init_bluecard_cs+0x0/0xa()
[   32.803745] Calling initcall 0x40893235: btusb_init+0x0/0x2b()
[   32.809549] Bluetooth: Generic Bluetooth USB driver ver 0.1
[   32.815224] usbcore: registered new interface driver btusb
[   32.820595] initcall 0x40893235: btusb_init+0x0/0x2b() returned 0.
[   32.826729] initcall 0x40893235 ran for 8 msecs: btusb_init+0x0/0x2b()
[   32.833232] Calling initcall 0x40893260: isdn_init+0x0/0x27e()
[   32.839505] ISDN subsystem Rev: 1.1.2.3/1.1.2.3/1.1.2.2/none/1.1.2.2/1.1.2.2
[   32.846399] initcall 0x40893260: isdn_init+0x0/0x27e() returned 0.
[   32.852546] initcall 0x40893260 ran for 3 msecs: isdn_init+0x0/0x27e()
[   32.859053] Calling initcall 0x408934de: divert_init+0x0/0x59()
[   32.864950] dss1_divert module successfully installed
[   32.869978] initcall 0x408934de: divert_init+0x0/0x59() returned 0.
[   32.876205] initcall 0x408934de ran for 4 msecs: divert_init+0x0/0x59()
[   32.882798] Calling initcall 0x40893537: gigaset_init_module+0x0/0x37()
[   32.889381] gigaset: Hansjoerg Lipp <hjlipp@web.de>, Tilman Schmidt <tilman@imap.cc>, Stefan Eilers
[   32.898400] gigaset: Driver for Gigaset 307x
[   32.902651] initcall 0x40893537: gigaset_init_module+0x0/0x37() returned 0.
[   32.909572] initcall 0x40893537 ran for 8 msecs: gigaset_init_module+0x0/0x37()
[   32.916858] Calling initcall 0x4089356e: ser_gigaset_init+0x0/0xc3()
[   32.923316] initcall 0x4089356e: ser_gigaset_init+0x0/0xc3() returned 0.
[   32.929856] initcall 0x4089356e ran for 0 msecs: ser_gigaset_init+0x0/0xc3()
[   32.936886] Calling initcall 0x4089372d: cpufreq_gov_dbs_init+0x0/0x3f()
[   32.943603] initcall 0x4089372d: cpufreq_gov_dbs_init+0x0/0x3f() returned 0.
[   32.950569] initcall 0x4089372d ran for 0 msecs: cpufreq_gov_dbs_init+0x0/0x3f()
[   32.957938] Calling initcall 0x4089376c: cpufreq_gov_dbs_init+0x0/0xa()
[   32.964530] initcall 0x4089376c: cpufreq_gov_dbs_init+0x0/0xa() returned 0.
[   32.971462] initcall 0x4089376c ran for 0 msecs: cpufreq_gov_dbs_init+0x0/0xa()
[   32.978743] Calling initcall 0x4089379a: init_ladder+0x0/0xa()
[   32.984560] cpuidle: using governor ladder
[   32.988628] initcall 0x4089379a: init_ladder+0x0/0xa() returned 0.
[   32.994773] initcall 0x4089379a ran for 3 msecs: init_ladder+0x0/0xa()
[   33.001268] Calling initcall 0x408937a4: init_menu+0x0/0xa()
[   33.006910] cpuidle: using governor menu
[   33.010813] initcall 0x408937a4: init_menu+0x0/0xa() returned 0.
[   33.016781] initcall 0x408937a4 ran for 3 msecs: init_menu+0x0/0xa()
[   33.023111] Calling initcall 0x408937cd: ib_core_init+0x0/0x3a()
[   33.029216] initcall 0x408937cd: ib_core_init+0x0/0x3a() returned 0.
[   33.035417] initcall 0x408937cd ran for 0 msecs: ib_core_init+0x0/0x3a()
[   33.042085] Calling initcall 0x40893811: ib_mad_init_module+0x0/0x97()
[   33.048592] initcall 0x40893811: ib_mad_init_module+0x0/0x97() returned 0.
[   33.055436] initcall 0x40893811 ran for 0 msecs: ib_mad_init_module+0x0/0x97()
[   33.062624] Calling initcall 0x408938a8: ib_sa_init+0x0/0x7f()
[   33.068488] initcall 0x408938a8: ib_sa_init+0x0/0x7f() returned 0.
[   33.074581] initcall 0x408938a8 ran for 0 msecs: ib_sa_init+0x0/0x7f()
[   33.081084] Calling initcall 0x40893927: ib_cm_init+0x0/0x108()
[   33.087082] initcall 0x40893927: ib_cm_init+0x0/0x108() returned 0.
[   33.093216] initcall 0x40893927 ran for 0 msecs: ib_cm_init+0x0/0x108()
[   33.099806] Calling initcall 0x40893a2f: iw_cm_init+0x0/0x2a()
[   33.105651] initcall 0x40893a2f: iw_cm_init+0x0/0x2a() returned 0.
[   33.111766] initcall 0x40893a2f ran for 0 msecs: iw_cm_init+0x0/0x2a()
[   33.118260] Calling initcall 0x404932fc: addr_init+0x0/0x39()
[   33.124035] initcall 0x404932fc: addr_init+0x0/0x39() returned 0.
[   33.130044] initcall 0x404932fc ran for 0 msecs: addr_init+0x0/0x39()
[   33.136464] Calling initcall 0x40493b21: cma_init+0x0/0xad()
[   33.142181] initcall 0x40493b21: cma_init+0x0/0xad() returned 0.
[   33.148069] initcall 0x40493b21 ran for 0 msecs: cma_init+0x0/0xad()
[   33.154398] Calling initcall 0x40893a59: ib_umad_init+0x0/0xa7()
[   33.160495] initcall 0x40893a59: ib_umad_init+0x0/0xa7() returned 0.
[   33.166701] initcall 0x40893a59 ran for 0 msecs: ib_umad_init+0x0/0xa7()
[   33.173377] Calling initcall 0x40893b00: ib_uverbs_init+0x0/0x126()
[   33.179822] initcall 0x40893b00: ib_uverbs_init+0x0/0x126() returned 0.
[   33.186279] initcall 0x40893b00 ran for 0 msecs: ib_uverbs_init+0x0/0x126()
[   33.193214] Calling initcall 0x40893c26: ib_ucm_init+0x0/0xa2()
[   33.199222] initcall 0x40893c26: ib_ucm_init+0x0/0xa2() returned 0.
[   33.205347] initcall 0x40893c26 ran for 0 msecs: ib_ucm_init+0x0/0xa2()
[   33.211938] Calling initcall 0x40893cc8: ucma_init+0x0/0x44()
[   33.217809] initcall 0x40893cc8: ucma_init+0x0/0x44() returned 0.
[   33.223758] initcall 0x40893cc8 ran for 0 msecs: ucma_init+0x0/0x44()
[   33.230158] Calling initcall 0x40893d0c: mlx4_ib_init+0x0/0xa()
[   33.236072] initcall 0x40893d0c: mlx4_ib_init+0x0/0xa() returned 0.
[   33.242288] initcall 0x40893d0c ran for 0 msecs: mlx4_ib_init+0x0/0xa()
[   33.248876] Calling initcall 0x40893d16: srp_init_module+0x0/0xa7()
[   33.255229] initcall 0x40893d16: srp_init_module+0x0/0xa7() returned 0.
[   33.261702] initcall 0x40893d16 ran for 0 msecs: srp_init_module+0x0/0xa7()
[   33.268641] Calling initcall 0x40893dbd: iser_init+0x0/0x111()
[   33.274687] iscsi: registered transport (iser)
[   33.279014] initcall 0x40893dbd: iser_init+0x0/0x111() returned 0.
[   33.285153] initcall 0x40893dbd ran for 2 msecs: iser_init+0x0/0x111()
[   33.291658] Calling initcall 0x4089450c: dcdrbu_init+0x0/0x122()
[   33.297780] initcall 0x4089450c: dcdrbu_init+0x0/0x122() returned 0.
[   33.303973] initcall 0x4089450c ran for 0 msecs: dcdrbu_init+0x0/0x122()
[   33.310649] Calling initcall 0x4089462e: dcdbas_init+0x0/0x4f()
[   33.316859] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   33.324339] initcall 0x4089462e: dcdbas_init+0x0/0x4f() returned 0.
[   33.330561] initcall 0x4089462e ran for 3 msecs: dcdbas_init+0x0/0x4f()
[   33.337150] Calling initcall 0x40894abe: init_soundcore+0x0/0x51()
[   33.343418] initcall 0x40894abe: init_soundcore+0x0/0x51() returned 0.
[   33.350236] initcall 0x40894abe ran for 0 msecs: init_soundcore+0x0/0x51()
[   33.357082] Calling initcall 0x40894b0f: alsa_sound_init+0x0/0x7d()
[   33.363390] Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Oct 23 06:09:18 2007 UTC).
[   33.372345] initcall 0x40894b0f: alsa_sound_init+0x0/0x7d() returned 0.
[   33.378925] initcall 0x40894b0f ran for 4 msecs: alsa_sound_init+0x0/0x7d()
[   33.385854] Calling initcall 0x40894d12: alsa_hwdep_init+0x0/0x42()
[   33.392115] initcall 0x40894d12: alsa_hwdep_init+0x0/0x42() returned 0.
[   33.398676] initcall 0x40894d12 ran for 0 msecs: alsa_hwdep_init+0x0/0x42()
[   33.405612] Calling initcall 0x40894d54: alsa_timer_init+0x0/0x144()
[   33.412226] initcall 0x40894d54: alsa_timer_init+0x0/0x144() returned 0.
[   33.418781] initcall 0x40894d54 ran for 0 msecs: alsa_timer_init+0x0/0x144()
[   33.425786] Calling initcall 0x40894e98: alsa_pcm_init+0x0/0x49()
[   33.431863] initcall 0x40894e98: alsa_pcm_init+0x0/0x49() returned 0.
[   33.438263] initcall 0x40894e98 ran for 0 msecs: alsa_pcm_init+0x0/0x49()
[   33.445025] Calling initcall 0x40894ee1: snd_mem_init+0x0/0x24()
[   33.451014] initcall 0x40894ee1: snd_mem_init+0x0/0x24() returned 0.
[   33.457331] initcall 0x40894ee1 ran for 0 msecs: snd_mem_init+0x0/0x24()
[   33.464009] Calling initcall 0x40894f05: alsa_rawmidi_init+0x0/0x73()
[   33.470423] initcall 0x40894f05: alsa_rawmidi_init+0x0/0x73() returned 0.
[   33.477177] initcall 0x40894f05 ran for 0 msecs: alsa_rawmidi_init+0x0/0x73()
[   33.484287] Calling initcall 0x40894f78: alsa_mixer_oss_init+0x0/0x29()
[   33.490882] initcall 0x40894f78: alsa_mixer_oss_init+0x0/0x29() returned 0.
[   33.497802] initcall 0x40894f78 ran for 0 msecs: alsa_mixer_oss_init+0x0/0x29()
[   33.505089] Calling initcall 0x40894fa1: alsa_pcm_oss_init+0x0/0x7c()
[   33.511515] initcall 0x40894fa1: alsa_pcm_oss_init+0x0/0x7c() returned 0.
[   33.518251] initcall 0x40894fa1 ran for 0 msecs: alsa_pcm_oss_init+0x0/0x7c()
[   33.525361] Calling initcall 0x4089501d: alsa_ainstr_fm_init+0x0/0x3()
[   33.531865] initcall 0x4089501d: alsa_ainstr_fm_init+0x0/0x3() returned 0.
[   33.538704] initcall 0x4089501d ran for 0 msecs: alsa_ainstr_fm_init+0x0/0x3()
[   33.545899] Calling initcall 0x40895020: alsa_ainstr_simple_init+0x0/0x3()
[   33.552754] initcall 0x40895020: alsa_ainstr_simple_init+0x0/0x3() returned 0.
[   33.559935] initcall 0x40895020 ran for 0 msecs: alsa_ainstr_simple_init+0x0/0x3()
[   33.567485] Calling initcall 0x40895023: alsa_seq_oss_init+0x0/0x150()
[   33.574588] initcall 0x40895023: alsa_seq_oss_init+0x0/0x150() returned 0.
[   33.581310] initcall 0x40895023 ran for 0 msecs: alsa_seq_oss_init+0x0/0x150()
[   33.588506] Calling initcall 0x40895345: alsa_seq_init+0x0/0x33()
[   33.594785] initcall 0x40895345: alsa_seq_init+0x0/0x33() returned 0.
[   33.601068] initcall 0x40895345 ran for 2 msecs: alsa_seq_init+0x0/0x33()
[   33.607831] Calling initcall 0x4089557a: alsa_seq_device_init+0x0/0x4a()
[   33.614509] initcall 0x4089557a: alsa_seq_device_init+0x0/0x4a() returned 0.
[   33.621520] initcall 0x4089557a ran for 0 msecs: alsa_seq_device_init+0x0/0x4a()
[   33.628892] Calling initcall 0x408955c4: alsa_seq_midi_event_init+0x0/0x3()
[   33.635824] initcall 0x408955c4: alsa_seq_midi_event_init+0x0/0x3() returned 0.
[   33.643103] initcall 0x408955c4 ran for 0 msecs: alsa_seq_midi_event_init+0x0/0x3()
[   33.650731] Calling initcall 0x408955c7: alsa_seq_midi_init+0x0/0x24()
[   33.657247] initcall 0x408955c7: alsa_seq_midi_init+0x0/0x24() returned 0.
[   33.664068] initcall 0x408955c7 ran for 0 msecs: alsa_seq_midi_init+0x0/0x24()
[   33.671270] Calling initcall 0x408955eb: alsa_seq_midi_emul_init+0x0/0x3()
[   33.678115] initcall 0x408955eb: alsa_seq_midi_emul_init+0x0/0x3() returned 0.
[   33.685303] initcall 0x408955eb ran for 0 msecs: alsa_seq_midi_emul_init+0x0/0x3()
[   33.692849] Calling initcall 0x408955ee: alsa_seq_instr_init+0x0/0x3()
[   33.699347] initcall 0x408955ee: alsa_seq_instr_init+0x0/0x3() returned 0.
[   33.706185] initcall 0x408955ee ran for 0 msecs: alsa_seq_instr_init+0x0/0x3()
[   33.713387] Calling initcall 0x408955f1: alsa_akm4xxx_module_init+0x0/0x3()
[   33.720318] initcall 0x408955f1: alsa_akm4xxx_module_init+0x0/0x3() returned 0.
[   33.727597] initcall 0x408955f1 ran for 0 msecs: alsa_akm4xxx_module_init+0x0/0x3()
[   33.735226] Calling initcall 0x408955f4: alsa_cs8427_module_init+0x0/0x3()
[   33.742071] initcall 0x408955f4: alsa_cs8427_module_init+0x0/0x3() returned 0.
[   33.749258] initcall 0x408955f4 ran for 0 msecs: alsa_cs8427_module_init+0x0/0x3()
[   33.756805] Calling initcall 0x408955f7: alsa_i2c_init+0x0/0x3()
[   33.762789] initcall 0x408955f7: alsa_i2c_init+0x0/0x3() returned 0.
[   33.769104] initcall 0x408955f7 ran for 0 msecs: alsa_i2c_init+0x0/0x3()
[   33.775781] Calling initcall 0x408955fa: alsa_card_dummy_init+0x0/0x6f()
[   33.784990] initcall 0x408955fa: alsa_card_dummy_init+0x0/0x6f() returned 0.
[   33.791891] initcall 0x408955fa ran for 4 msecs: alsa_card_dummy_init+0x0/0x6f()
[   33.799261] Calling initcall 0x40895669: alsa_card_serial_init+0x0/0x6f()
[   33.806387] no UART detected at 0x1
[   33.810075] initcall 0x40895669: alsa_card_serial_init+0x0/0x6f() returned -19.
[   33.817227] initcall 0x40895669 ran for 3 msecs: alsa_card_serial_init+0x0/0x6f()
[   33.824688] Calling initcall 0x408956d8: alsa_opl3_init+0x0/0x3()
[   33.830757] initcall 0x408956d8: alsa_opl3_init+0x0/0x3() returned 0.
[   33.837159] initcall 0x408956d8 ran for 0 msecs: alsa_opl3_init+0x0/0x3()
[   33.843922] Calling initcall 0x408956db: alsa_opl3_seq_init+0x0/0x14()
[   33.850442] initcall 0x408956db: alsa_opl3_seq_init+0x0/0x14() returned 0.
[   33.857264] initcall 0x408956db ran for 0 msecs: alsa_opl3_seq_init+0x0/0x14()
[   33.864461] Calling initcall 0x408956ef: alsa_mpu401_uart_init+0x0/0x3()
[   33.871135] initcall 0x408956ef: alsa_mpu401_uart_init+0x0/0x3() returned 0.
[   33.878147] initcall 0x408956ef ran for 0 msecs: alsa_mpu401_uart_init+0x0/0x3()
[   33.885522] Calling initcall 0x408956f2: alsa_sb_common_init+0x0/0x3()
[   33.892020] initcall 0x408956f2: alsa_sb_common_init+0x0/0x3() returned 0.
[   33.898866] initcall 0x408956f2 ran for 0 msecs: alsa_sb_common_init+0x0/0x3()
[   33.906055] Calling initcall 0x408956f5: alsa_ad1889_init+0x0/0x11()
[   33.912519] initcall 0x408956f5: alsa_ad1889_init+0x0/0x11() returned 0.
[   33.919098] initcall 0x408956f5 ran for 0 msecs: alsa_ad1889_init+0x0/0x11()
[   33.926082] Calling initcall 0x40895706: alsa_card_als4000_init+0x0/0x11()
[   33.933048] initcall 0x40895706: alsa_card_als4000_init+0x0/0x11() returned 0.
[   33.940118] initcall 0x40895706 ran for 0 msecs: alsa_card_als4000_init+0x0/0x11()
[   33.947667] Calling initcall 0x40895717: alsa_card_atiixp_init+0x0/0x11()
[   33.954546] initcall 0x40895717: alsa_card_atiixp_init+0x0/0x11() returned 0.
[   33.961526] initcall 0x40895717 ran for 0 msecs: alsa_card_atiixp_init+0x0/0x11()
[   33.968986] Calling initcall 0x40895728: alsa_card_bt87x_init+0x0/0x29()
[   33.975780] initcall 0x40895728: alsa_card_bt87x_init+0x0/0x29() returned 0.
[   33.982669] initcall 0x40895728 ran for 0 msecs: alsa_card_bt87x_init+0x0/0x29()
[   33.990038] Calling initcall 0x40895751: alsa_card_cmipci_init+0x0/0x11()
[   33.996929] initcall 0x40895751: alsa_card_cmipci_init+0x0/0x11() returned 0.
[   34.003916] initcall 0x40895751 ran for 0 msecs: alsa_card_cmipci_init+0x0/0x11()
[   34.011363] Calling initcall 0x40895762: alsa_card_ens137x_init+0x0/0x11()
[   34.018331] initcall 0x40895762: alsa_card_ens137x_init+0x0/0x11() returned 0.
[   34.025396] initcall 0x40895762 ran for 0 msecs: alsa_card_ens137x_init+0x0/0x11()
[   34.032941] Calling initcall 0x40895773: alsa_card_es1938_init+0x0/0x11()
[   34.039821] initcall 0x40895773: alsa_card_es1938_init+0x0/0x11() returned 0.
[   34.046814] initcall 0x40895773 ran for 0 msecs: alsa_card_es1938_init+0x0/0x11()
[   34.054253] Calling initcall 0x40895784: alsa_card_es1968_init+0x0/0x11()
[   34.061140] initcall 0x40895784: alsa_card_es1968_init+0x0/0x11() returned 0.
[   34.068117] initcall 0x40895784 ran for 0 msecs: alsa_card_es1968_init+0x0/0x11()
[   34.075579] Calling initcall 0x40895795: alsa_card_intel8x0_init+0x0/0x11()
[   34.082696] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   34.402711] intel8x0_measure_ac97_clock: measured 50474 usecs
[   34.408332] intel8x0: clocking to 46892
[   34.414499] initcall 0x40895795: alsa_card_intel8x0_init+0x0/0x11() returned 0.
[   34.421655] initcall 0x40895795 ran for 314 msecs: alsa_card_intel8x0_init+0x0/0x11()
[   34.429461] Calling initcall 0x408957a6: alsa_card_rme32_init+0x0/0x11()
[   34.436319] initcall 0x408957a6: alsa_card_rme32_init+0x0/0x11() returned 0.
[   34.443289] initcall 0x408957a6 ran for 0 msecs: alsa_card_rme32_init+0x0/0x11()
[   34.450573] Calling initcall 0x408957b7: alsa_card_rme96_init+0x0/0x11()
[   34.457373] initcall 0x408957b7: alsa_card_rme96_init+0x0/0x11() returned 0.
[   34.464262] initcall 0x408957b7 ran for 0 msecs: alsa_card_rme96_init+0x0/0x11()
[   34.471635] Calling initcall 0x408957c8: alsa_ac97_init+0x0/0x3()
[   34.477703] initcall 0x408957c8: alsa_ac97_init+0x0/0x3() returned 0.
[   34.484108] initcall 0x408957c8 ran for 0 msecs: alsa_ac97_init+0x0/0x3()
[   34.490877] Calling initcall 0x408957cb: alsa_card_ca0106_init+0x0/0x11()
[   34.497762] initcall 0x408957cb: alsa_card_ca0106_init+0x0/0x11() returned 0.
[   34.504736] initcall 0x408957cb ran for 0 msecs: alsa_card_ca0106_init+0x0/0x11()
[   34.512193] Calling initcall 0x408957dc: alsa_card_cs46xx_init+0x0/0x11()
[   34.519077] initcall 0x408957dc: alsa_card_cs46xx_init+0x0/0x11() returned 0.
[   34.526051] initcall 0x408957dc ran for 0 msecs: alsa_card_cs46xx_init+0x0/0x11()
[   34.533516] Calling initcall 0x408957ed: alsa_card_echo_init+0x0/0x11()
[   34.540229] initcall 0x408957ed: alsa_card_echo_init+0x0/0x11() returned 0.
[   34.547047] initcall 0x408957ed ran for 0 msecs: alsa_card_echo_init+0x0/0x11()
[   34.554315] Calling initcall 0x408957fe: alsa_card_echo_init+0x0/0x11()
[   34.561101] initcall 0x408957fe: alsa_card_echo_init+0x0/0x11() returned 0.
[   34.567918] initcall 0x408957fe ran for 0 msecs: alsa_card_echo_init+0x0/0x11()
[   34.575190] Calling initcall 0x4089580f: alsa_card_echo_init+0x0/0x11()
[   34.581904] initcall 0x4089580f: alsa_card_echo_init+0x0/0x11() returned 0.
[   34.588711] initcall 0x4089580f ran for 0 msecs: alsa_card_echo_init+0x0/0x11()
[   34.595994] Calling initcall 0x40895820: alsa_card_echo_init+0x0/0x11()
[   34.602716] initcall 0x40895820: alsa_card_echo_init+0x0/0x11() returned 0.
[   34.609518] initcall 0x40895820 ran for 2 msecs: alsa_card_echo_init+0x0/0x11()
[   34.617264] Calling initcall 0x40895831: alsa_card_ice1712_init+0x0/0x11()
[   34.624237] initcall 0x40895831: alsa_card_ice1712_init+0x0/0x11() returned 0.
[   34.631319] initcall 0x40895831 ran for 0 msecs: alsa_card_ice1712_init+0x0/0x11()
[   34.638850] Calling initcall 0x40895842: alsa_ice1712_akm4xxx_module_init+0x0/0x3()
[   34.646476] initcall 0x40895842: alsa_ice1712_akm4xxx_module_init+0x0/0x3() returned 0.
[   34.654441] initcall 0x40895842 ran for 0 msecs: alsa_ice1712_akm4xxx_module_init+0x0/0x3()
[   34.662769] Calling initcall 0x40895845: alsa_card_ice1724_init+0x0/0x11()
[   34.669735] initcall 0x40895845: alsa_card_ice1724_init+0x0/0x11() returned 0.
[   34.676803] initcall 0x40895845 ran for 0 msecs: alsa_card_ice1724_init+0x0/0x11()
[   34.684345] Calling initcall 0x40895856: pcxhr_module_init+0x0/0x11()
[   34.690896] initcall 0x40895856: pcxhr_module_init+0x0/0x11() returned 0.
[   34.697523] initcall 0x40895856 ran for 0 msecs: pcxhr_module_init+0x0/0x11()
[   34.704634] Calling initcall 0x40895867: alsa_card_riptide_init+0x0/0x53()
[   34.711732] initcall 0x40895867: alsa_card_riptide_init+0x0/0x53() returned 0.
[   34.718812] initcall 0x40895867 ran for 0 msecs: alsa_card_riptide_init+0x0/0x53()
[   34.726337] Calling initcall 0x408958ba: alsa_card_hdspm_init+0x0/0x11()
[   34.733197] initcall 0x408958ba: alsa_card_hdspm_init+0x0/0x11() returned 0.
[   34.740088] initcall 0x408958ba ran for 0 msecs: alsa_card_hdspm_init+0x0/0x11()
[   34.747464] Calling initcall 0x408958cb: alsa_card_trident_init+0x0/0x11()
[   34.754431] initcall 0x408958cb: alsa_card_trident_init+0x0/0x11() returned 0.
[   34.761496] initcall 0x408958cb ran for 0 msecs: alsa_card_trident_init+0x0/0x11()
[   34.769043] Calling initcall 0x408958dc: alsa_trident_synth_init+0x0/0x14()
[   34.776001] initcall 0x408958dc: alsa_trident_synth_init+0x0/0x14() returned 0.
[   34.783252] initcall 0x408958dc ran for 0 msecs: alsa_trident_synth_init+0x0/0x14()
[   34.790881] Calling initcall 0x408958f0: alsa_util_mem_init+0x0/0x3()
[   34.797293] initcall 0x408958f0: alsa_util_mem_init+0x0/0x3() returned 0.
[   34.804044] initcall 0x408958f0 ran for 0 msecs: alsa_util_mem_init+0x0/0x3()
[   34.811160] Calling initcall 0x4052eb4b: snd_soc_init+0x0/0x23()
[   34.817134] ASoC version 0.13.1
[   34.820372] initcall 0x4052eb4b: snd_soc_init+0x0/0x23() returned 0.
[   34.826576] initcall 0x4052eb4b ran for 5 msecs: snd_soc_init+0x0/0x23()
[   34.833252] Calling initcall 0x408958fd: alsa_sound_last_init+0x0/0x56()
[   34.839925] ALSA device list:
[   34.842878]   #0: Dummy 1
[   34.845470]   #1: NVidia CK804 with ALC850 at irq 3
[   34.850334] initcall 0x408958fd: alsa_sound_last_init+0x0/0x56() returned 0.
[   34.857343] initcall 0x408958fd ran for 6 msecs: alsa_sound_last_init+0x0/0x56()
[   34.864716] Calling initcall 0x40896e8f: flow_cache_init+0x0/0xf2()
[   34.870960] initcall 0x40896e8f: flow_cache_init+0x0/0xf2() returned 0.
[   34.877535] initcall 0x40896e8f ran for 0 msecs: flow_cache_init+0x0/0xf2()
[   34.884471] Calling initcall 0x40896f81: pg_init+0x0/0x232()
[   34.890103] pktgen v2.69: Packet Generator for packet performance testing.
[   34.897041] initcall 0x40896f81: pg_init+0x0/0x232() returned 0.
[   34.902939] initcall 0x40896f81 ran for 0 msecs: pg_init+0x0/0x232()
[   34.909254] Calling initcall 0x4089723b: llc_init+0x0/0x69()
[   34.914893] initcall 0x4089723b: llc_init+0x0/0x69() returned 0.
[   34.920865] initcall 0x4089723b ran for 0 msecs: llc_init+0x0/0x69()
[   34.927196] Calling initcall 0x40897302: llc2_init+0x0/0xb4()
[   34.933007] NET: Registered protocol family 26
[   34.937343] initcall 0x40897302: llc2_init+0x0/0xb4() returned 0.
[   34.943403] initcall 0x40897302 ran for 2 msecs: llc2_init+0x0/0xb4()
[   34.949810] Calling initcall 0x40897560: snap_init+0x0/0x2b()
[   34.955557] initcall 0x40897560: snap_init+0x0/0x2b() returned 0.
[   34.961597] initcall 0x40897560 ran for 0 msecs: snap_init+0x0/0x2b()
[   34.968013] Calling initcall 0x40897840: nfnetlink_init+0x0/0x62()
[   34.974163] Netfilter messages via NETLINK v0.30.
[   34.978863] initcall 0x40897840: nfnetlink_init+0x0/0x62() returned 0.
[   34.985342] initcall 0x40897840 ran for 3 msecs: nfnetlink_init+0x0/0x62()
[   34.992192] Calling initcall 0x408978a2: nfnetlink_log_init+0x0/0x89()
[   34.998725] initcall 0x408978a2: nfnetlink_log_init+0x0/0x89() returned 0.
[   35.005534] initcall 0x408978a2 ran for 0 msecs: nfnetlink_log_init+0x0/0x89()
[   35.012733] Calling initcall 0x4089792b: xt_init+0x0/0x71()
[   35.018288] initcall 0x4089792b: xt_init+0x0/0x71() returned 0.
[   35.024163] initcall 0x4089792b ran for 0 msecs: xt_init+0x0/0x71()
[   35.030402] Calling initcall 0x4089799c: xt_tcpudp_init+0x0/0xf()
[   35.036497] initcall 0x4089799c: xt_tcpudp_init+0x0/0xf() returned 0.
[   35.042888] initcall 0x4089799c ran for 0 msecs: xt_tcpudp_init+0x0/0xf()
[   35.049644] Calling initcall 0x408979ab: xt_classify_init+0x0/0xf()
[   35.055890] initcall 0x408979ab: xt_classify_init+0x0/0xf() returned 0.
[   35.062467] initcall 0x408979ab ran for 0 msecs: xt_classify_init+0x0/0xf()
[   35.069403] Calling initcall 0x408979ba: xt_mark_init+0x0/0xf()
[   35.075302] initcall 0x408979ba: xt_mark_init+0x0/0xf() returned 0.
[   35.081535] initcall 0x408979ba ran for 0 msecs: xt_mark_init+0x0/0xf()
[   35.088127] Calling initcall 0x408979c9: xt_nflog_init+0x0/0xf()
[   35.094108] initcall 0x408979c9: xt_nflog_init+0x0/0xf() returned 0.
[   35.100425] initcall 0x408979c9 ran for 0 msecs: xt_nflog_init+0x0/0xf()
[   35.107105] Calling initcall 0x408979d8: xt_nfqueue_init+0x0/0xf()
[   35.113260] initcall 0x408979d8: xt_nfqueue_init+0x0/0xf() returned 0.
[   35.119757] initcall 0x408979d8 ran for 0 msecs: xt_nfqueue_init+0x0/0xf()
[   35.126599] Calling initcall 0x408979e7: xt_dccp_init+0x0/0x44()
[   35.132586] initcall 0x408979e7: xt_dccp_init+0x0/0x44() returned 0.
[   35.138909] initcall 0x408979e7 ran for 0 msecs: xt_dccp_init+0x0/0x44()
[   35.145579] Calling initcall 0x40897a2b: xt_dscp_match_init+0x0/0xf()
[   35.151997] initcall 0x40897a2b: xt_dscp_match_init+0x0/0xf() returned 0.
[   35.158754] initcall 0x40897a2b ran for 0 msecs: xt_dscp_match_init+0x0/0xf()
[   35.165857] Calling initcall 0x40897a3a: xt_limit_init+0x0/0xf()
[   35.171843] initcall 0x40897a3a: xt_limit_init+0x0/0xf() returned 0.
[   35.178160] initcall 0x40897a3a ran for 0 msecs: xt_limit_init+0x0/0xf()
[   35.184836] Calling initcall 0x40897a49: xt_mark_init+0x0/0xf()
[   35.190741] initcall 0x40897a49: xt_mark_init+0x0/0xf() returned 0.
[   35.196968] initcall 0x40897a49 ran for 0 msecs: xt_mark_init+0x0/0xf()
[   35.203559] Calling initcall 0x40897a58: xt_multiport_init+0x0/0xf()
[   35.209888] initcall 0x40897a58: xt_multiport_init+0x0/0xf() returned 0.
[   35.216551] initcall 0x40897a58 ran for 0 msecs: xt_multiport_init+0x0/0xf()
[   35.223578] Calling initcall 0x40897a67: xt_physdev_init+0x0/0xf()
[   35.229732] initcall 0x40897a67: xt_physdev_init+0x0/0xf() returned 0.
[   35.236223] initcall 0x40897a67 ran for 0 msecs: xt_physdev_init+0x0/0xf()
[   35.243076] Calling initcall 0x40897a76: xt_pkttype_init+0x0/0xf()
[   35.249231] initcall 0x40897a76: xt_pkttype_init+0x0/0xf() returned 0.
[   35.255731] initcall 0x40897a76 ran for 0 msecs: xt_pkttype_init+0x0/0xf()
[   35.262571] Calling initcall 0x40897a85: xt_quota_init+0x0/0xf()
[   35.268556] initcall 0x40897a85: xt_quota_init+0x0/0xf() returned 0.
[   35.274880] initcall 0x40897a85 ran for 0 msecs: xt_quota_init+0x0/0xf()
[   35.281549] Calling initcall 0x40897a94: xt_statistic_init+0x0/0xf()
[   35.287882] initcall 0x40897a94: xt_statistic_init+0x0/0xf() returned 0.
[   35.294546] initcall 0x40897a94 ran for 0 msecs: xt_statistic_init+0x0/0xf()
[   35.301568] Calling initcall 0x4089889e: ipip_init+0x0/0x8f()
[   35.307289] IPv4 over IPv4 tunneling driver
[   35.312283] initcall 0x4089889e: ipip_init+0x0/0x8f() returned 0.
[   35.318222] initcall 0x4089889e ran for 4 msecs: ipip_init+0x0/0x8f()
[   35.324634] Calling initcall 0x40898966: init_syncookies+0x0/0x12()
[   35.330929] initcall 0x40898966: init_syncookies+0x0/0x12() returned 0.
[   35.337464] initcall 0x40898966 ran for 0 msecs: init_syncookies+0x0/0x12()
[   35.344400] Calling initcall 0x40898978: esp4_init+0x0/0x5d()
[   35.350123] initcall 0x40898978: esp4_init+0x0/0x5d() returned 0.
[   35.356179] initcall 0x40898978 ran for 0 msecs: esp4_init+0x0/0x5d()
[   35.362592] Calling initcall 0x408989d5: xfrm4_beet_init+0x0/0xf()
[   35.368756] initcall 0x408989d5: xfrm4_beet_init+0x0/0xf() returned 0.
[   35.375252] initcall 0x408989d5 ran for 0 msecs: xfrm4_beet_init+0x0/0xf()
[   35.382094] Calling initcall 0x408989e4: tunnel4_init+0x0/0x2d()
[   35.388079] initcall 0x408989e4: tunnel4_init+0x0/0x2d() returned 0.
[   35.394397] initcall 0x408989e4 ran for 0 msecs: tunnel4_init+0x0/0x2d()
[   35.401073] Calling initcall 0x40898a11: xfrm4_tunnel_init+0x0/0xf()
[   35.407405] initcall 0x40898a11: xfrm4_tunnel_init+0x0/0xf() returned 0.
[   35.414069] initcall 0x40898a11 ran for 0 msecs: xfrm4_tunnel_init+0x0/0xf()
[   35.421099] Calling initcall 0x40590b24: ipv4_netfilter_init+0x0/0xa()
[   35.427615] initcall 0x40590b24: ipv4_netfilter_init+0x0/0xa() returned 0.
[   35.434435] initcall 0x40590b24 ran for 0 msecs: ipv4_netfilter_init+0x0/0xa()
[   35.441630] Calling initcall 0x408993ce: arp_tables_init+0x0/0x71()
[   35.447895] arp_tables: (C) 2002 David S. Miller
[   35.452473] initcall 0x408993ce: arp_tables_init+0x0/0x71() returned 0.
[   35.459055] initcall 0x408993ce ran for 4 msecs: arp_tables_init+0x0/0x71()
[   35.465983] Calling initcall 0x4089943f: ip_queue_init+0x0/0x122()
[   35.472185] initcall 0x4089943f: ip_queue_init+0x0/0x122() returned 0.
[   35.478632] initcall 0x4089943f ran for 0 msecs: ip_queue_init+0x0/0x122()
[   35.485480] Calling initcall 0x40899561: inet_diag_init+0x0/0x6b()
[   35.491653] initcall 0x40899561: inet_diag_init+0x0/0x6b() returned 0.
[   35.498130] initcall 0x40899561 ran for 0 msecs: inet_diag_init+0x0/0x6b()
[   35.504987] Calling initcall 0x408995cc: tcp_diag_init+0x0/0xa()
[   35.510980] initcall 0x408995cc: tcp_diag_init+0x0/0xa() returned 0.
[   35.517285] initcall 0x408995cc ran for 0 msecs: tcp_diag_init+0x0/0xa()
[   35.523964] Calling initcall 0x408995d6: cubictcp_register+0x0/0x8f()
[   35.530374] TCP cubic registered
[   35.533590] initcall 0x408995d6: cubictcp_register+0x0/0x8f() returned 0.
[   35.540335] initcall 0x408995d6 ran for 1 msecs: cubictcp_register+0x0/0x8f()
[   35.547448] Calling initcall 0x408998a9: af_unix_init+0x0/0x5c()
[   35.553427] NET: Registered protocol family 1
[   35.557791] initcall 0x408998a9: af_unix_init+0x0/0x5c() returned 0.
[   35.564080] initcall 0x408998a9 ran for 2 msecs: af_unix_init+0x0/0x5c()
[   35.570763] Calling initcall 0x40899905: packet_init+0x0/0x47()
[   35.576653] NET: Registered protocol family 17
[   35.581102] initcall 0x40899905: packet_init+0x0/0x47() returned 0.
[   35.587312] initcall 0x40899905 ran for 0 msecs: packet_init+0x0/0x47()
[   35.593894] Calling initcall 0x4089994c: ipsec_pfkey_init+0x0/0x80()
[   35.600222] NET: Registered protocol family 15
[   35.604668] initcall 0x4089994c: ipsec_pfkey_init+0x0/0x80() returned 0.
[   35.611317] initcall 0x4089994c ran for 0 msecs: ipsec_pfkey_init+0x0/0x80()
[   35.618332] Calling initcall 0x408999cc: br_init+0x0/0xb8()
[   35.623970] Bridge firewalling registered
[   35.627895] initcall 0x408999cc: br_init+0x0/0xb8() returned 0.
[   35.633758] initcall 0x408999cc ran for 3 msecs: br_init+0x0/0xb8()
[   35.640001] Calling initcall 0x40899ca1: econet_proto_init+0x0/0x2b()
[   35.646413] NET: Registered protocol family 19
[   35.651276] initcall 0x40899ca1: econet_proto_init+0x0/0x2b() returned 0.
[   35.658021] initcall 0x40899ca1 ran for 3 msecs: econet_proto_init+0x0/0x2b()
[   35.665136] Calling initcall 0x40899ccc: vlan_proto_init+0x0/0xb8()
[   35.671371] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   35.678137] All bugs added by David S. Miller <davem@redhat.com>
[   35.684142] initcall 0x40899ccc: vlan_proto_init+0x0/0xb8() returned 0.
[   35.690699] initcall 0x40899ccc ran for 8 msecs: vlan_proto_init+0x0/0xb8()
[   35.697628] Calling initcall 0x40899dd6: sctp_init+0x0/0x666()
[   35.708330] SCTP: Hash tables configured (established 32768 bind 29127)
[   35.742719] initcall 0x40899dd6: sctp_init+0x0/0x666() returned 0.
[   35.748741] initcall 0x40899dd6 ran for 33 msecs: sctp_init+0x0/0x666()
[   35.755332] Calling initcall 0x4089a4ef: ieee80211_init+0x0/0x1f()
[   35.761481] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   35.768072] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   35.776397] initcall 0x4089a4ef: ieee80211_init+0x0/0x1f() returned 0.
[   35.782890] initcall 0x4089a4ef ran for 8 msecs: ieee80211_init+0x0/0x1f()
[   35.789731] Calling initcall 0x4089a50e: ieee80211_crypto_init+0x0/0xa()
[   35.796437] ieee80211_crypt: registered algorithm 'NULL'
[   35.801701] initcall 0x4089a50e: ieee80211_crypto_init+0x0/0xa() returned 0.
[   35.808710] initcall 0x4089a50e ran for 1 msecs: ieee80211_crypto_init+0x0/0xa()
[   35.816079] Calling initcall 0x4089a518: ieee80211_crypto_wep_init+0x0/0xa()
[   35.823098] ieee80211_crypt: registered algorithm 'WEP'
[   35.828306] initcall 0x4089a518: ieee80211_crypto_wep_init+0x0/0xa() returned 0.
[   35.835666] initcall 0x4089a518 ran for 4 msecs: ieee80211_crypto_wep_init+0x0/0xa()
[   35.843381] Calling initcall 0x4089a522: ieee80211_crypto_tkip_init+0x0/0xa()
[   35.850485] ieee80211_crypt: registered algorithm 'TKIP'
[   35.855778] initcall 0x4089a522: ieee80211_crypto_tkip_init+0x0/0xa() returned 0.
[   35.863223] initcall 0x4089a522 ran for 4 msecs: ieee80211_crypto_tkip_init+0x0/0xa()
[   35.871026] Calling initcall 0x4089a52c: tipc_init+0x0/0xa0()
[   35.876760] TIPC: Activated (version 1.6.2 compiled Nov 13 2007 19:51:08)
[   35.885713] NET: Registered protocol family 30
[   35.890046] TIPC: Started in single node mode
[   35.894380] initcall 0x4089a52c: tipc_init+0x0/0xa0() returned 0.
[   35.900429] initcall 0x4089a52c ran for 11 msecs: tipc_init+0x0/0xa0()
[   35.906935] Calling initcall 0x4089a63c: init_p9+0x0/0x31()
[   35.912494] Installing 9P2000 support
[   35.916224] initcall 0x4089a63c: init_p9+0x0/0x31() returned 0.
[   35.922008] initcall 0x4089a63c ran for 3 msecs: init_p9+0x0/0x31()
[   35.928254] Calling initcall 0x4087b865: powernow_init+0x0/0x121()
[   35.934409] initcall 0x4087b865: powernow_init+0x0/0x121() returned -19.
[   35.941076] initcall 0x4087b865 ran for 0 msecs: powernow_init+0x0/0x121()
[   35.947927] Calling initcall 0x4087bdca: powernowk8_init+0x0/0x48()
[   35.954165] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ processors (1 cpu cores) (version 2.00.00)
[   35.969448] powernow-k8: BIOS error - no PSB or ACPI _PSS objects
[   35.975430] initcall 0x4087bdca: powernowk8_init+0x0/0x48() returned -19.
[   35.982168] initcall 0x4087bdca ran for 11 msecs: powernowk8_init+0x0/0x48()
[   35.989190] Calling initcall 0x4087c64e: centrino_init+0x0/0x19()
[   35.995261] initcall 0x4087c64e: centrino_init+0x0/0x19() returned -19.
[   36.001843] initcall 0x4087c64e ran for 0 msecs: centrino_init+0x0/0x19()
[   36.008607] Calling initcall 0x4087e0be: init_lapic_nmi_sysfs+0x0/0x2d()
[   36.015555] initcall 0x4087e0be: init_lapic_nmi_sysfs+0x0/0x2d() returned 0.
[   36.022440] initcall 0x4087e0be ran for 0 msecs: init_lapic_nmi_sysfs+0x0/0x2d()
[   36.029809] Calling initcall 0x4087e0eb: check_nmi_watchdog+0x0/0x11c()
[   36.036396] Testing NMI watchdog ... OK.
[   36.139488] initcall 0x4087e0eb: check_nmi_watchdog+0x0/0x11c() returned 0.
[   36.146417] initcall 0x4087e0eb ran for 98 msecs: check_nmi_watchdog+0x0/0x11c()
[   36.153785] Calling initcall 0x4087e306: io_apic_bug_finalize+0x0/0x18()
[   36.160464] initcall 0x4087e306: io_apic_bug_finalize+0x0/0x18() returned 0.
[   36.167483] initcall 0x4087e306 ran for 0 msecs: io_apic_bug_finalize+0x0/0x18()
[   36.174852] Calling initcall 0x4088187d: print_ipi_mode+0x0/0x2c()
[   36.180999] Using IPI Shortcut mode
[   36.184472] initcall 0x4088187d: print_ipi_mode+0x0/0x2c() returned 0.
[   36.190968] initcall 0x4088187d ran for 7 msecs: print_ipi_mode+0x0/0x2c()
[   36.197810] Calling initcall 0x40882135: disable_boot_consoles+0x0/0x3e()
[   36.204574] initcall 0x40882135: disable_boot_consoles+0x0/0x3e() returned 0.
[   36.211679] initcall 0x40882135 ran for 0 msecs: disable_boot_consoles+0x0/0x3e()
[   36.219136] Calling initcall 0x40883f6e: taskstats_init+0x0/0x81()
[   36.225305] registered taskstats version 1
[   36.229366] initcall 0x40883f6e: taskstats_init+0x0/0x81() returned 0.
[   36.235859] initcall 0x40883f6e ran for 2 msecs: taskstats_init+0x0/0x81()
[   36.242707] Calling initcall 0x40888ca4: random32_reseed+0x0/0x20()
[   36.248952] initcall 0x40888ca4: random32_reseed+0x0/0x20() returned 0.
[   36.255531] initcall 0x40888ca4 ran for 0 msecs: random32_reseed+0x0/0x20()
[   36.262459] Calling initcall 0x40889250: pci_sysfs_init+0x0/0x31()
[   36.268790] initcall 0x40889250: pci_sysfs_init+0x0/0x31() returned 0.
[   36.275168] initcall 0x40889250 ran for 0 msecs: pci_sysfs_init+0x0/0x31()
[   36.282010] Calling initcall 0x4088b05a: seqgen_init+0x0/0xa()
[   36.287840] initcall 0x4088b05a: seqgen_init+0x0/0xa() returned 0.
[   36.293967] initcall 0x4088b05a ran for 0 msecs: seqgen_init+0x0/0xa()
[   36.300472] Calling initcall 0x403aeba1: scsi_complete_async_scans+0x0/0xcf()
[   36.307581] initcall 0x403aeba1: scsi_complete_async_scans+0x0/0xcf() returned 0.
[   36.315032] initcall 0x403aeba1 ran for 0 msecs: scsi_complete_async_scans+0x0/0xcf()
[   36.322836] Calling initcall 0x4089812b: tcp_congestion_default+0x0/0xa()
[   36.329593] initcall 0x4089812b: tcp_congestion_default+0x0/0xa() returned 0.
[   36.336693] initcall 0x4089812b ran for 0 msecs: tcp_congestion_default+0x0/0xa()
[   36.344149] Calling initcall 0x40898cda: ip_auto_config+0x0/0x6f4()
[   36.350394] initcall 0x40898cda: ip_auto_config+0x0/0x6f4() returned 0.
[   36.356972] initcall 0x40898cda ran for 0 msecs: ip_auto_config+0x0/0x6f4()
[   36.365470] EXT3-fs: INFO: recovery required on readonly filesystem.
[   36.371705] EXT3-fs: write access will be enabled during recovery.
[   37.156813] kjournald starting.  Commit interval 5 seconds
[   37.162232] EXT3-fs: recovery complete.
[   37.166769] EXT3-fs: mounted filesystem with ordered data mode.
[   37.172603] VFS: Mounted root (ext3 filesystem) readonly.
[   37.178236] Freeing unused kernel memory: 264k freed
[   37.183156] Write protecting the kernel text: 5068k
[   37.187962] Write protecting the kernel read-only data: 1867k
[   37.225986] khelper used greatest stack depth: 2348 bytes left
[   37.866316] mount used greatest stack depth: 1860 bytes left
[   53.848798] eth1: link down
[   57.971788] IPv4 FIB: Using LC-trie version 0.408
[   60.494731] EXT3 FS on sda1, internal journal
[   60.540901] kjournald starting.  Commit interval 5 seconds
[   60.546594] EXT3 FS on sda5, internal journal
[   60.550818] EXT3-fs: mounted filesystem with ordered data mode.
[   61.245190] rc.sysinit used greatest stack depth: 1680 bytes left
[   61.386859] list_add corruption. prev->next should be next (407d973c), but was 418cf818. (prev=41877098).
[   61.396328] ------------[ cut here ]------------
[   61.400910] kernel BUG at lib/list_debug.c:33!
[   61.405330] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[   61.410356] 
[   61.411831] Pid: 1191, comm: rc Not tainted (2.6.24-rc2 #183)
[   61.417550] EIP: 0060:[<402dd7f0>] EFLAGS: 00010012 CPU: 0
[   61.423012] EIP is at __list_add+0x47/0x5a
[   61.427082] EAX: 00000070 EBX: 407d973c ECX: 4011fb14 EDX: 7ccfc000
[   61.433321] ESI: 000001a2 EDI: 41877098 EBP: 7ccd6cbc ESP: 7c505d74
[   61.439562]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   61.444934] Process rc (pid: 1191, ti=7c505000 task=7ccfc000 task.ti=7c505000)
[   61.451953] Stack: 4075bfb7 407d973c 418cf818 41877098 41886ac0 4016476c 00000004 00000050 
[   61.460273]        00000344 00000202 40176992 ffffffff 7f93d340 00000050 000efcf8 40164882 
[   61.468593]        ffffffff 000efcf8 7f88e1c8 42d7e6d8 401aa323 40176b3c 401757b7 000efcf8 
[   61.476912] Call Trace:
[   61.479512]  [<4016476c>] slob_alloc+0x76/0x16c
[   61.484019]  [<40176992>] ifind_fast+0x16/0x85
[   61.488439]  [<40164882>] kmem_cache_alloc_node+0x20/0x4d
[   61.493811]  [<401aa323>] ext3_alloc_inode+0x12/0x46
[   61.498751]  [<40176b3c>] alloc_inode+0x15/0x1fa
[   61.503344]  [<401757b7>] d_alloc+0x174/0x19f
[   61.507676]  [<401772a6>] iget_locked+0x3f/0x111
[   61.512270]  [<401aa056>] ext3_lookup+0x6a/0xe4
[   61.516776]  [<4016cd45>] do_lookup+0xa8/0x145
[   61.521196]  [<4016e74d>] __link_path_walk+0x751/0xb51
[   61.526309]  [<4013b203>] __lock_acquire+0xce1/0xcfd
[   61.531249]  [<4016eb8f>] link_path_walk+0x42/0xaf
[   61.536015]  [<405f154b>] _spin_unlock_irq+0x20/0x2c
[   61.540954]  [<4013a0bf>] trace_hardirqs_on+0x12e/0x16b
[   61.546154]  [<40104e39>] sysenter_past_esp+0xb2/0xc1
[   61.551614]  [<4013a0bf>] trace_hardirqs_on+0x12e/0x16b
[   61.556813]  [<4016ee7c>] do_path_lookup+0x15e/0x1c0
[   61.561754]  [<4016df38>] getname+0x5c/0xaa
[   61.565913]  [<4016f642>] __user_walk_fd+0x2f/0x40
[   61.570680]  [<40165b45>] sys_faccessat+0x99/0x12d
[   61.575446]  [<4013a0bf>] trace_hardirqs_on+0x12e/0x16b
[   61.580645]  [<40104e39>] sysenter_past_esp+0xb2/0xc1
[   61.585672]  [<4013a0bf>] trace_hardirqs_on+0x12e/0x16b
[   61.590871]  [<40165bf8>] sys_access+0x1f/0x23
[   61.595293]  [<40104df2>] sysenter_past_esp+0x6b/0xc1
[   61.600318]  =======================
[   61.603871] Code: 67 bf 75 40 e8 7e 28 e4 ff 0f 0b eb fe 8b 10 39 ca 74 1c 89 54 24 08 89 4c 24 04 89 44 24 0c c7 04 24 b7 bf 75 40 e8 5c 28 e4 ff <0f> 0b eb fe 89 5a 04 89 13 89 43 04 89 18 83 c4 10 5b c3 8b 0a 
[   61.622676] EIP: [<402dd7f0>] __list_add+0x47/0x5a SS:ESP 0068:7c505d74
[   61.629266] BUG: sleeping function called from invalid context at kernel/rwsem.c:20
[   61.636889] in_atomic():0, irqs_disabled():1
[   61.641135] INFO: lockdep is turned off.
[   61.645035] irq event stamp: 16016
[   61.648414] hardirqs last  enabled at (16015): [<4013a236>] debug_check_no_locks_freed+0x13a/0x14e
[   61.657340] hardirqs last disabled at (16016): [<405f15a6>] _spin_lock_irqsave+0x23/0x75
[   61.665400] softirqs last  enabled at (15714): [<4010700b>] do_softirq+0x60/0xdd
[   61.672766] softirqs last disabled at (15703): [<4010700b>] do_softirq+0x60/0xdd
[   61.680133]  [<401323db>] down_read+0x19/0x74
[   61.684466]  [<40131cf7>] hrtimer_try_to_cancel+0x4e/0x56
[   61.689839]  [<401419f5>] acct_collect+0x30/0x13f
[   61.694518]  [<4012211c>] do_exit+0x1c0/0x6aa
[   61.698851]  [<40105f8d>] show_registers+0x150/0x158
[   61.703791]  [<4032c603>] do_unblank_screen+0x2a/0x120
[   61.708904]  [<4010618c>] die+0x1f7/0x1fe
[   61.712891]  [<40106445>] do_invalid_op+0x0/0x8a
[   61.717483]  [<401064c6>] do_invalid_op+0x81/0x8a
[   61.722164]  [<402dd7f0>] __list_add+0x47/0x5a
[   61.726584]  [<4011fb14>] release_console_sem+0x1ab/0x1c4
[   61.731956]  [<40106cfc>] do_nmi+0x81/0x23e
[   61.736116]  [<405f17f2>] error_code+0x6a/0x70
[   61.740535]  [<4011fb14>] release_console_sem+0x1ab/0x1c4
[   61.745908]  [<402dd7f0>] __list_add+0x47/0x5a
[   61.750328]  [<4016476c>] slob_alloc+0x76/0x16c
[   61.754834]  [<40176992>] ifind_fast+0x16/0x85
[   61.759255]  [<40164882>] kmem_cache_alloc_node+0x20/0x4d
[   61.764628]  [<401aa323>] ext3_alloc_inode+0x12/0x46
[   61.769567]  [<40176b3c>] alloc_inode+0x15/0x1fa
[   61.774160]  [<401757b7>] d_alloc+0x174/0x19f
[   61.778493]  [<401772a6>] iget_locked+0x3f/0x111
[   61.783087]  [<401aa056>] ext3_lookup+0x6a/0xe4
[   61.787593]  [<4016cd45>] do_lookup+0xa8/0x145
[   61.792012]  [<4016e74d>] __link_path_walk+0x751/0xb51
[   61.797127]  [<4013b203>] __lock_acquire+0xce1/0xcfd
[   61.802065]  [<4016eb8f>] link_path_walk+0x42/0xaf
[   61.806832]  [<405f154b>] _spin_unlock_irq+0x20/0x2c
[   61.811771]  [<4013a0bf>] trace_hardirqs_on+0x12e/0x16b
[   61.816970]  [<40104e39>] sysenter_past_esp+0xb2/0xc1
[   61.821997]  [<4013a0bf>] trace_hardirqs_on+0x12e/0x16b
[   61.827196]  [<4016ee7c>] do_path_lookup+0x15e/0x1c0
[   61.832138]  [<4016df38>] getname+0x5c/0xaa
[   61.836296]  [<4016f642>] __user_walk_fd+0x2f/0x40
[   61.841063]  [<40165b45>] sys_faccessat+0x99/0x12d
[   61.845829]  [<4013a0bf>] trace_hardirqs_on+0x12e/0x16b
[   61.851029]  [<40104e39>] sysenter_past_esp+0xb2/0xc1
[   61.856056]  [<4013a0bf>] trace_hardirqs_on+0x12e/0x16b
[   61.861254]  [<40165bf8>] sys_access+0x1f/0x23
[   61.865674]  [<40104df2>] sysenter_past_esp+0x6b/0xc1
[   61.870700]  =======================
[   66.916889] NMI watchdog detected lockup on CPU#0 (50000/50000)
[   66.922675] 
[   66.924150] Pid: 1191, comm: rc Tainted: G      D (2.6.24-rc2 #183)
[   66.930389] EIP: 0060:[<402dafb0>] EFLAGS: 00000046 CPU: 0
[   66.935850] EIP is at delay_tsc+0x1/0x3d
[   66.939748] EAX: 00000001 EBX: 407d971c ECX: 00000000 EDX: 00000021
[   66.945988] ESI: 0a35c0ea EDI: 00000001 EBP: 80e27be4 ESP: 7c505b9c
[   66.952227]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   66.957600] CR0: 8005003b CR2: 08103018 CR3: 3f6d0000 CR4: 000006c0
[   66.963840] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   66.970079] DR6: ffff0ff0 DR7: 00000400
[   66.973893]  [<402daf9a>] __delay+0x6/0x7
[   66.977878]  [<402dd3eb>] _raw_spin_lock+0x7e/0xd4
[   66.982645]  [<405f15e8>] _spin_lock_irqsave+0x65/0x75
[   66.987759]  [<401644c2>] slob_free+0x40/0x1ca
[   66.992178]  [<401644c2>] slob_free+0x40/0x1ca
[   66.996597]  [<4015d38f>] remove_vma+0x45/0x4a
[   67.001017]  [<4015d44c>] exit_mmap+0xb8/0xd2
[   67.005351]  [<4011dade>] mmput+0x36/0x6f
[   67.009337]  [<4012215b>] do_exit+0x1ff/0x6aa
[   67.013670]  [<40105f8d>] show_registers+0x150/0x158
[   67.018610]  [<4032c603>] do_unblank_screen+0x2a/0x120
[   67.023722]  [<4010618c>] die+0x1f7/0x1fe
[   67.027709]  [<40106445>] do_invalid_op+0x0/0x8a
[   67.032302]  [<401064c6>] do_invalid_op+0x81/0x8a
[   67.036982]  [<402dd7f0>] __list_add+0x47/0x5a
[   67.041401]  [<4011fb14>] release_console_sem+0x1ab/0x1c4
[   67.046774]  [<40106cfc>] do_nmi+0x81/0x23e
[   67.050935]  [<405f17f2>] error_code+0x6a/0x70
[   67.055354]  [<4011fb14>] release_console_sem+0x1ab/0x1c4
[   67.060727]  [<402dd7f0>] __list_add+0x47/0x5a
[   67.065147]  [<4016476c>] slob_alloc+0x76/0x16c
[   67.069653]  [<40176992>] ifind_fast+0x16/0x85
[   67.074072]  [<40164882>] kmem_cache_alloc_node+0x20/0x4d
[   67.079445]  [<401aa323>] ext3_alloc_inode+0x12/0x46
[   67.084385]  [<40176b3c>] alloc_inode+0x15/0x1fa
[   67.088978]  [<401757b7>] d_alloc+0x174/0x19f
[   67.093311]  [<401772a6>] iget_locked+0x3f/0x111
[   67.097904]  [<401aa056>] ext3_lookup+0x6a/0xe4
[   67.102410]  [<4016cd45>] do_lookup+0xa8/0x145
[   67.106831]  [<4016e74d>] __link_path_walk+0x751/0xb51
[   67.111943]  [<4013b203>] __lock_acquire+0xce1/0xcfd
[   67.116883]  [<4016eb8f>] link_path_walk+0x42/0xaf
[   67.121650]  [<405f154b>] _spin_unlock_irq+0x20/0x2c
[   67.126590]  [<4013a0bf>] trace_hardirqs_on+0x12e/0x16b
[   67.131789]  [<40104e39>] sysenter_past_esp+0xb2/0xc1
[   67.136815]  [<4013a0bf>] trace_hardirqs_on+0x12e/0x16b
[   67.142015]  [<4016ee7c>] do_path_lookup+0x15e/0x1c0
[   67.146954]  [<4016df38>] getname+0x5c/0xaa
[   67.151114]  [<4016f642>] __user_walk_fd+0x2f/0x40
[   67.155881]  [<40165b45>] sys_faccessat+0x99/0x12d
[   67.160647]  [<4013a0bf>] trace_hardirqs_on+0x12e/0x16b
[   67.165846]  [<40104e39>] sysenter_past_esp+0xb2/0xc1
[   67.170873]  [<4013a0bf>] trace_hardirqs_on+0x12e/0x16b
[   67.176072]  [<40165bf8>] sys_access+0x1f/0x23
[   67.180493]  [<40104df2>] sysenter_past_esp+0x6b/0xc1
[   67.185519]  =======================
[   67.189072] NMI watchdog running again ...
[   72.235742] NMI watchdog detected lockup on CPU#0 (50000/50000)
[   72.241533] 
[   72.243006] Pid: 1191, comm: rc Tainted: G      D (2.6.24-rc2 #183)
[   72.249245] EIP: 0060:[<402dd3ed>] EFLAGS: 00000883 CPU: 0
[   72.254706] EIP is at _raw_spin_lock+0x80/0xd4
[   72.259125] EAX: 00000008 EBX: 407d971c ECX: 00000000 EDX: 00000024
[   72.265365] ESI: 146b9588 EDI: 00000001 EBP: 80e27be4 ESP: 7c505ba8
[   72.271604]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   72.276977] CR0: 8005003b CR2: 08103018 CR3: 3f6d0000 CR4: 000006c0
[   72.283217] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   72.289456] DR6: ffff0ff0 DR7: 00000400
[   72.293269]  [<405f15e8>] _spin_lock_irqsave+0x65/0x75
[   72.298382]  [<401644c2>] slob_free+0x40/0x1ca
[   72.302802]  [<401644c2>] slob_free+0x40/0x1ca
[   72.307221]  [<4015d38f>] remove_vma+0x45/0x4a
[   72.311641]  [<4015d44c>] exit_mmap+0xb8/0xd2
[   72.315974]  [<4011dade>] mmput+0x36/0x6f
[   72.319960]  [<4012215b>] do_exit+0x1ff/0x6aa
[   72.324294]  [<40105f8d>] show_registers+0x150/0x158
[   72.329234]  [<4032c603>] do_unblank_screen+0x2a/0x120
[   72.334346]  [<4010618c>] die+0x1f7/0x1fe
[   72.338333]  [<40106445>] do_invalid_op+0x0/0x8a
[   72.342926]  [<401064c6>] do_invalid_op+0x81/0x8a
[   72.347605]  [<402dd7f0>] __list_add+0x47/0x5a
[   72.352026]  [<4011fb14>] release_console_sem+0x1ab/0x1c4
[   72.357399]  [<40106cfc>] do_nmi+0x81/0x23e

--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="crash.log.config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.24-rc2
# Tue Nov 13 19:50:36 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_BOOTPARAM_SUPPORT=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set
# CONFIG_USER_NS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
# CONFIG_CGROUPS is not set
# CONFIG_BOOTPARAM_MAXCPUS_1 is not set
# CONFIG_BOOTPARAM_NOSMP is not set
# CONFIG_FAIR_GROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_LBD=y
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_LSF is not set
CONFIG_BLK_DEV_BSG=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_BOOTPARAM_NO_HZ_OFF is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_BOOTPARAM_HIGHRES_OFF is not set
# CONFIG_SMP is not set
# CONFIG_X86_PC is not set
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
CONFIG_X86_GENERICARCH=y
# CONFIG_X86_ES7000 is not set
# CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN is not set
CONFIG_VMI=y
# CONFIG_LGUEST_GUEST is not set
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
# CONFIG_MCORE2 is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
CONFIG_MK7=y
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_USE_3DNOW=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
# CONFIG_HPET_TIMER is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_NONFATAL is not set
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
CONFIG_VMSPLIT_1G=y
CONFIG_PAGE_OFFSET=0x40000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
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
CONFIG_HIGHPTE=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y
CONFIG_BOOTPARAM_NMI_WATCHDOG_BIT_0=y
CONFIG_BOOTPARAM_NMI_WATCHDOG_BIT_1=y
# CONFIG_BOOTPARAM_NOAPIC is not set
# CONFIG_BOOTPARAM_NOLAPIC is not set
CONFIG_BOOTPARAM_LAPIC=y
CONFIG_BOOTPARAM_HPET_DISABLE=y
CONFIG_BOOTPARAM_IDLE_MWAIT=y
CONFIG_BOOTPARAM_IDLE_POLL=y
# CONFIG_BOOTPARAM_HIGHMEM_512M is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options (ACPI, APM)
#
CONFIG_PM=y
CONFIG_PM_LEGACY=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND_UP_POSSIBLE=y
CONFIG_SUSPEND=y
CONFIG_HIBERNATION_UP_POSSIBLE=y
# CONFIG_ACPI is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
# CONFIG_CPU_FREQ_STAT is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K8=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
CONFIG_X86_E_POWERSAVER=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=y
CONFIG_PCI_GOBIOS=y
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_BIOS=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_MCA=y
CONFIG_MCA_LEGACY=y
# CONFIG_MCA_PROC_FS is not set
# CONFIG_SCx200 is not set
CONFIG_PCCARD=y
CONFIG_PCMCIA_DEBUG=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=y
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_AOUT=y
# CONFIG_BINFMT_MISC is not set

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_ASK_IP_FIB_HASH is not set
CONFIG_IP_FIB_TRIE=y
# CONFIG_IP_FIB_HASH is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE is not set
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IP_VS is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
CONFIG_NETFILTER_NETLINK_LOG=y
# CONFIG_NF_CONNTRACK_ENABLED is not set
# CONFIG_NF_CONNTRACK is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
CONFIG_NETFILTER_XT_MATCH_DCCP=y
CONFIG_NETFILTER_XT_MATCH_DSCP=y
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
CONFIG_NETFILTER_XT_MATCH_MARK=y
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set

#
# IP: Netfilter Configuration
#
CONFIG_IP_NF_QUEUE=y
# CONFIG_IP_NF_IPTABLES is not set
CONFIG_IP_NF_ARPTABLES=y
# CONFIG_IP_NF_ARPFILTER is not set
# CONFIG_IP_NF_ARP_MANGLE is not set

#
# Bridge: Netfilter Configuration
#
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_HMAC_NONE=y
# CONFIG_SCTP_HMAC_SHA1 is not set
# CONFIG_SCTP_HMAC_MD5 is not set
CONFIG_TIPC=y
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_ZONES=3
CONFIG_TIPC_CLUSTERS=1
CONFIG_TIPC_NODES=255
CONFIG_TIPC_SLAVE_NODES=0
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
# CONFIG_TIPC_DEBUG is not set
# CONFIG_ATM is not set
CONFIG_BRIDGE=y
CONFIG_VLAN_8021Q=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_ECONET=y
# CONFIG_ECONET_AUNUDP is not set
# CONFIG_ECONET_NATIVE is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
# CONFIG_BT_L2CAP is not set
# CONFIG_BT_SCO is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIUSB is not set
CONFIG_BT_HCIBTUSB=y
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
CONFIG_BT_HCIBPA10X=y
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
# CONFIG_BT_HCIBT3C is not set
CONFIG_BT_HCIBLUECARD=y
# CONFIG_BT_HCIBTUART is not set
CONFIG_BT_HCIVHCI=y
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y

#
# Wireless
#
CONFIG_CFG80211=y
# CONFIG_NL80211 is not set
CONFIG_WIRELESS_EXT=y
# CONFIG_MAC80211 is not set
CONFIG_IEEE80211=y
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=y
# CONFIG_IEEE80211_CRYPT_CCMP is not set
CONFIG_IEEE80211_CRYPT_TKIP=y
# CONFIG_IEEE80211_SOFTMAC is not set
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
# CONFIG_NET_9P_FD is not set
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
# CONFIG_CONNECTOR is not set
# CONFIG_PARPORT is not set
# CONFIG_BLK_DEV is not set
# CONFIG_MISC_DEVICES is not set

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
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_LIBSAS_DEBUG=y
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_SATA_AHCI=y
CONFIG_SATA_SVW=y
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
CONFIG_SATA_QSTOR=y
CONFIG_SATA_PROMISE=y
# CONFIG_SATA_SX4 is not set
CONFIG_SATA_SIL=y
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
CONFIG_SATA_ULI=y
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
CONFIG_SATA_INIC162X=y
CONFIG_PATA_ALI=y
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=y
CONFIG_PATA_ATIIXP=y
CONFIG_PATA_CMD640_PCI=y
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
CONFIG_PATA_CS5530=y
CONFIG_PATA_CS5535=y
CONFIG_PATA_CS5536=y
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
CONFIG_PATA_HPT3X2N=y
# CONFIG_PATA_HPT3X3 is not set
CONFIG_PATA_IT821X=y
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_JMICRON=y
CONFIG_PATA_TRIFLEX=y
# CONFIG_PATA_MARVELL is not set
CONFIG_PATA_MPIIX=y
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OPTI=y
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
CONFIG_PATA_RADISYS=y
# CONFIG_PATA_RZ1000 is not set
CONFIG_PATA_SC1200=y
CONFIG_PATA_SERVERWORKS=y
# CONFIG_PATA_PDC2027X is not set
CONFIG_PATA_SIL680=y
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
CONFIG_PATA_WINBOND=y
# CONFIG_PATA_PLATFORM is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
# CONFIG_NETDEVICES is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_NET_PCI=y
CONFIG_FORCEDETH=y
CONFIG_E100=y
CONFIG_8139TOO=y
CONFIG_E1000=y
CONFIG_MLX4_CORE=y
CONFIG_NETCONSOLE=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
# CONFIG_ISDN_PPP is not set
CONFIG_ISDN_AUDIO=y
# CONFIG_ISDN_TTY_FAX is not set

#
# ISDN feature submodules
#
# CONFIG_ISDN_DRV_LOOP is not set
CONFIG_ISDN_DIVERSION=y

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
# CONFIG_ISDN_DRV_HISAX is not set

#
# Active cards
#
CONFIG_ISDN_DRV_GIGASET=y
# CONFIG_GIGASET_BASE is not set
# CONFIG_GIGASET_M105 is not set
CONFIG_GIGASET_M101=y
CONFIG_GIGASET_DEBUG=y
CONFIG_GIGASET_UNDOCREQ=y
# CONFIG_ISDN_CAPI is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
# CONFIG_TABLET_USB_AIPTEK is not set
CONFIG_TABLET_USB_GTCO=y
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_UCB1400 is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
CONFIG_TOUCHSCREEN_USB_3M=y
# CONFIG_TOUCHSCREEN_USB_ITM is not set
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
# CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
# CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_UINPUT=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=y
# CONFIG_CYZ_INTR is not set
# CONFIG_DIGIEPCA is not set
CONFIG_MOXA_INTELLIO=y
# CONFIG_MOXA_SMARTIO is not set
CONFIG_MOXA_SMARTIO_NEW=y
# CONFIG_ISI is not set
CONFIG_SYNCLINK=y
CONFIG_SYNCLINKMP=y
# CONFIG_SYNCLINK_GT is not set
# CONFIG_N_HDLC is not set
CONFIG_RISCOM8=y
CONFIG_SPECIALIX=y
CONFIG_SPECIALIX_RTSCTS=y
CONFIG_SX=y
# CONFIG_RIO is not set
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
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
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
# CONFIG_CARDMAN_4040 is not set
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_CS5535_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_ATMEL=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_CHARDEV is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
CONFIG_I2C_SAVAGE4=y
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set

#
# Miscellaneous I2C Chip support
#
CONFIG_SENSORS_DS1337=y
CONFIG_SENSORS_DS1374=y
CONFIG_DS1682=y
CONFIG_SENSORS_EEPROM=y
# CONFIG_SENSORS_PCF8574 is not set
CONFIG_SENSORS_PCA9539=y
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
CONFIG_SENSORS_TSL2550=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_I2C_DEBUG_CHIP=y

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
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
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_SM501=y

#
# Multimedia devices
#
# CONFIG_DVB_CORE is not set
CONFIG_DAB=y
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
CONFIG_AGP_ATI=y
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=y
# CONFIG_DRM is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
# CONFIG_FB_ARC is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_HECUBA=y
CONFIG_FB_HGA=y
# CONFIG_FB_HGA_ACCEL is not set
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I810=y
CONFIG_FB_I810_GTF=y
# CONFIG_FB_I810_I2C is not set
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
CONFIG_FB_INTEL=y
CONFIG_FB_INTEL_DEBUG=y
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
# CONFIG_FB_MATROX_I2C is not set
# CONFIG_FB_MATROX_MULTIHEAD is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=y
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_GEODE is not set
CONFIG_FB_SM501=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=y

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
# CONFIG_VIDEO_SELECT is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y

#
# Sound
#
CONFIG_SOUND=y

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_DETECT is not set
# CONFIG_SND_PCM_XRUN_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DUMMY=y
# CONFIG_SND_VIRMIDI is not set
CONFIG_SND_SERIAL_U16550=y
# CONFIG_SND_MPU401 is not set
CONFIG_SND_SB_COMMON=y

#
# PCI devices
#
CONFIG_SND_AD1889=y
# CONFIG_SND_ALS300 is not set
CONFIG_SND_ALS4000=y
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
CONFIG_SND_ATIIXP_MODEM=y
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=y
CONFIG_SND_BT87X_OVERCLOCK=y
CONFIG_SND_CA0106=y
CONFIG_SND_CMIPCI=y
# CONFIG_SND_CS4281 is not set
CONFIG_SND_CS46XX=y
CONFIG_SND_CS46XX_NEW_DSP=y
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
CONFIG_SND_GINA20=y
CONFIG_SND_LAYLA20=y
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
CONFIG_SND_MIA=y
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
CONFIG_SND_INDIGODJ=y
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
CONFIG_SND_ENS1371=y
CONFIG_SND_ES1938=y
CONFIG_SND_ES1968=y
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
CONFIG_SND_HDSPM=y
CONFIG_SND_ICE1712=y
CONFIG_SND_ICE1724=y
CONFIG_SND_INTEL8X0=y
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=y
CONFIG_SND_RIPTIDE=y
CONFIG_SND_RME32=y
CONFIG_SND_RME96=y
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
CONFIG_SND_TRIDENT=y
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_AC97_POWER_SAVE is not set

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# PCMCIA devices
#
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set

#
# System on Chip audio support
#
CONFIG_SND_SOC=y

#
# SoC Audio support for SuperH
#

#
# Open Sound System
#
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_TRIDENT is not set
CONFIG_AC97_BUS=y
# CONFIG_HID_SUPPORT is not set
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
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_SPLIT_ISO is not set
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_SSB=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_CS is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
CONFIG_USB_STORAGE_ISD200=y
# CONFIG_USB_STORAGE_DPCM is not set
CONFIG_USB_STORAGE_USBAT=y
# CONFIG_USB_STORAGE_SDDR09 is not set
CONFIG_USB_STORAGE_SDDR55=y
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
CONFIG_USB_MON=y

#
# USB port drivers
#

#
# USB Serial Converter support
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_AUERSWALD=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_PHIDGET=y
CONFIG_USB_PHIDGETKIT=y
CONFIG_USB_PHIDGETMOTORCONTROL=y
CONFIG_USB_PHIDGETSERVO=y
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#

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
CONFIG_MLX4_INFINIBAND=y
CONFIG_INFINIBAND_SRP=y
CONFIG_INFINIBAND_ISER=y
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_VIRTUALIZATION is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4DEV_FS=y
CONFIG_EXT4DEV_FS_XATTR=y
CONFIG_EXT4DEV_FS_POSIX_ACL=y
CONFIG_EXT4DEV_FS_SECURITY=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_SECURITY is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_DNOTIFY is not set
CONFIG_AUTOFS_FS=y
CONFIG_AUTOFS4_FS=y
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
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
# CONFIG_CRAMFS is not set
CONFIG_VXFS_FS=y
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set
CONFIG_INSTRUMENTATION=y
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
# CONFIG_MARKERS is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_FRAME_POINTER is not set
# CONFIG_FORCED_INLINING is not set
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_SAMPLES is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_RODATA=y
CONFIG_4KSTACKS=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_CAPABILITIES=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
# CONFIG_SECURITY_SELINUX_DEVELOP is not set
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ABLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_PCBC=y
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_AES is not set
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_AUTHENC is not set
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
# CONFIG_LIBCRC32C is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y
CONFIG_FORCE_MINIMAL_CONFIG=y

--envbJBWh7q8WU6mo--
