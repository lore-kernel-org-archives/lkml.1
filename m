Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0BHTcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 14:32:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59619 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499Ab0BHTcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 14:32:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: 2.6.33-rc7-next-20100208: recursive locking in __driver_attach()
Date: Mon, 8 Feb 2010 20:32:58 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
References: <20100208185429.GA4765@x200>
In-Reply-To: <20100208185429.GA4765@x200>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002082032.58482.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I guess sysfs lockdep annotations strike again ...

On Monday 08 February 2010, Alexey Dobriyan wrote:
> [    0.571254] =============================================
> [    0.571254] [ INFO: possible recursive locking detected ]
> [    0.571254] 2.6.33-rc7-next-20100208 #1
> [    0.571254] ---------------------------------------------
> [    0.571254] swapper/1 is trying to acquire lock:
> [    0.571254]  (&dev->mutex){+.+...}, at: [<ffffffff81275941>] __driver_attach+0x61/0xa0
> [    0.571254] 
> [    0.571254] but task is already holding lock:
> [    0.571254]  (&dev->mutex){+.+...}, at: [<ffffffff81275933>] __driver_attach+0x53/0xa0
> [    0.571254] 
> [    0.571254] other info that might help us debug this:
> [    0.571254] 1 lock held by swapper/1:
> [    0.571254]  #0:  (&dev->mutex){+.+...}, at: [<ffffffff81275933>] __driver_attach+0x53/0xa0
> [    0.571311] 
> [    0.571311] stack backtrace:
> [    0.571375] Pid: 1, comm: swapper Not tainted 2.6.33-rc7-next-20100208 #1
> [    0.571411] Call Trace:
> [    0.571447]  [<ffffffff81068060>] __lock_acquire+0x1080/0x1d00
> [    0.571484]  [<ffffffff8110fb7d>] ? sysfs_find_dirent+0x2d/0x40
> [    0.571521]  [<ffffffff8110ffbf>] ? __sysfs_add_one+0x1f/0xe0
> [    0.571558]  [<ffffffff81068d3c>] lock_acquire+0x5c/0x80
> [    0.571594]  [<ffffffff81275941>] ? __driver_attach+0x61/0xa0
> [    0.571631]  [<ffffffff81275941>] ? __driver_attach+0x61/0xa0
> [    0.571670]  [<ffffffff8138126c>] mutex_lock_nested+0x5c/0x3a0
> [    0.571707]  [<ffffffff81275941>] ? __driver_attach+0x61/0xa0
> [    0.571743]  [<ffffffff81274420>] ? klist_devices_put+0x0/0x10
> [    0.571781]  [<ffffffff81275941>] __driver_attach+0x61/0xa0
> [    0.571817]  [<ffffffff812758e0>] ? __driver_attach+0x0/0xa0
> [    0.571854]  [<ffffffff81274f08>] bus_for_each_dev+0x68/0x90
> [    0.571890]  [<ffffffff8127562c>] driver_attach+0x1c/0x20
> [    0.571927]  [<ffffffff8127467c>] bus_add_driver+0xbc/0x260
> [    0.571965]  [<ffffffff816910bf>] ? acpi_pci_root_init+0x0/0x28
> [    0.572002]  [<ffffffff81275c7c>] driver_register+0x7c/0x160
> [    0.572039]  [<ffffffff816910bf>] ? acpi_pci_root_init+0x0/0x28
> [    0.572077]  [<ffffffff8118b165>] acpi_bus_register_driver+0x3e/0x41
> [    0.572115]  [<ffffffff816910d8>] acpi_pci_root_init+0x19/0x28
> [    0.572153]  [<ffffffff810001d8>] do_one_initcall+0x38/0x190
> [    0.572190]  [<ffffffff81675695>] kernel_init+0x1a2/0x223
> [    0.572228]  [<ffffffff81003314>] kernel_thread_helper+0x4/0x10
> [    0.572265]  [<ffffffff81383580>] ? restore_args+0x0/0x30
> [    0.572301]  [<ffffffff816754f3>] ? kernel_init+0x0/0x223
> [    0.572338]  [<ffffffff81003310>] ? kernel_thread_helper+0x0/0x10
> 
> 
> [    0.000000] Linux version 2.6.33-rc7-next-20100208 (ad@core2) (gcc version 4.3.4 (Gentoo 4.3.4 p1.0, pie-10.1.5) ) #1 SMP PREEMPT Mon Feb 8 20:47:57 EET 2010
> [    0.000000] Command line: root=/dev/sda1 ignore_loglevel netconsole=@192.168.1.3/eth0,9353@192.168.1.2/00:1b:38:af:22:49
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
> [    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bff80000 (usable)
> [    0.000000]  BIOS-e820: 00000000bff80000 - 00000000bff8e000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bff8e000 - 00000000bffe0000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bffe0000 - 00000000c0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI 2.4 present.
> [    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
> [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> [    0.000000] No AGP bridge found
> [    0.000000] last_pfn = 0xbff80 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-DFFFF write-protect
> [    0.000000]   E0000-EFFFF write-through
> [    0.000000]   F0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask F80000000 write-back
> [    0.000000]   1 base 080000000 mask FC0000000 write-back
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] initial memory mapped : 0 - 20000000
> [    0.000000] init_memory_mapping: 0000000000000000-00000000bff80000
> [    0.000000]  0000000000 - 00bff80000 page 4k
> [    0.000000] kernel direct mapping tables up to bff80000 @ 100000-704000
> [    0.000000] ACPI: RSDP 00000000000fbe10 00024 (v02 ACPIAM)
> [    0.000000] ACPI: XSDT 00000000bff80100 00054 (v01 A_M_I_ OEMXSDT  04000807 MSFT 00000097)
> [    0.000000] ACPI: FACP 00000000bff80290 000F4 (v03 A_M_I_ OEMFACP  04000807 MSFT 00000097)
> [    0.000000] ACPI: DSDT 00000000bff80440 0A05A (v01  A0905 A0905002 00000002 INTL 20060113)
> [    0.000000] ACPI: FACS 00000000bff8e000 00040
> [    0.000000] ACPI: APIC 00000000bff80390 0006C (v01 A_M_I_ OEMAPIC  04000807 MSFT 00000097)
> [    0.000000] ACPI: MCFG 00000000bff80400 0003C (v01 A_M_I_ OEMMCFG  04000807 MSFT 00000097)
> [    0.000000] ACPI: OEMB 00000000bff8e040 00081 (v01 A_M_I_ AMI_OEM  04000807 MSFT 00000097)
> [    0.000000] ACPI: HPET 00000000bff8a4a0 00038 (v01 A_M_I_ OEMHPET  04000807 MSFT 00000097)
> [    0.000000] ACPI: OSFR 00000000bff8a4e0 000B0 (v01 A_M_I_ OEMOSFR  04000807 MSFT 00000097)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] (6 early reservations) ==> bootmem [0000000000 - 00bff80000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
> [    0.000000]   #1 [0001000000 - 0002016dc0]    TEXT DATA BSS ==> [0001000000 - 0002016dc0]
> [    0.000000]   #2 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
> [    0.000000]   #3 [0002017000 - 0002017278]              BRK ==> [0002017000 - 0002017278]
> [    0.000000]   #4 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
> [    0.000000]   #5 [0000100000 - 0000702000]          PGTABLE ==> [0000100000 - 0000702000]
> [    0.000000]  [ffffea0000000000-ffffea00029fffff] PMD -> [ffff880002600000-ffff880004ffffff] on node 0
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000001 -> 0x00001000
> [    0.000000]   DMA32    0x00001000 -> 0x00100000
> [    0.000000]   Normal   0x00100000 -> 0x00100000
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[2] active PFN ranges
> [    0.000000]     0: 0x00000001 -> 0x0000009e
> [    0.000000]     0: 0x00000100 -> 0x000bff80
> [    0.000000] On node 0 totalpages: 786205
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 1638 pages reserved
> [    0.000000]   DMA zone: 2303 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 10695 pages used for memmap
> [    0.000000]   DMA32 zone: 771513 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
> [    0.000000] 4 Processors exceeds NR_CPUS limit of 2
> [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 24
> [    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
> [    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 24 pages/cpu @ffff880002200000 s75752 r0 d22552 u1048576
> [    0.000000] pcpu-alloc: s75752 r0 d22552 u1048576 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 773816
> [    0.000000] Kernel command line: root=/dev/sda1 ignore_loglevel netconsole=@192.168.1.3/eth0,9353@192.168.1.2/00:1b:38:af:22:49
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Memory: 3072508k/3145216k available (3609k kernel code, 396k absent, 72312k reserved, 2922k data, 452k init)
> [    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] NR_IRQS:320
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 5855 kB
> [    0.000000]  per task-struct memory footprint: 1920 bytes
> [    0.000000] ODEBUG: 6 of 6 active objects replaced
> [    0.000000] hpet clockevent registered
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2138.104 MHz processor.
> [    0.010019] Calibrating delay loop (skipped), value calculated using timer frequency.. 4276.20 BogoMIPS (lpj=21381040)
> [    0.010192] Mount-cache hash table entries: 256
> [    0.011030] CPU: Physical Processor ID: 0
> [    0.011065] CPU: Processor Core ID: 0
> [    0.011100] mce: CPU supports 6 MCE banks
> [    0.011140] CPU0: Thermal monitoring enabled (TM2)
> [    0.011178] using mwait in idle threads.
> [    0.011212] Performance Events: Core2 events, Intel PMU driver.
> [    0.011307] ... version:                2
> [    0.011341] ... bit width:              40
> [    0.011375] ... generic registers:      2
> [    0.011409] ... value mask:             000000ffffffffff
> [    0.011444] ... max period:             000000007fffffff
> [    0.011479] ... fixed-purpose events:   3
> [    0.011513] ... event mask:             0000000700000003
> [    0.011573] debug: unmapping init memory ffffffff816d3000..ffffffff816d9000
> [    0.011631] ACPI: Core revision 20100121
> [    0.050185] Setting APIC routing to flat
> [    0.050574] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.156217] CPU0: Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 02
> [    0.210014] lockdep: fixing up alternatives.
> [    0.210188] Booting Node   0, Processors  #1 Ok.
> [    0.380051] Brought up 2 CPUs
> [    0.380088] Total of 2 processors activated (8552.58 BogoMIPS).
> [    0.380646] khelper used greatest stack depth: 5512 bytes left
> [    0.380646] NET: Registered protocol family 16
> [    0.380646] ACPI: bus type pci registered
> [    0.380646] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
> [    0.380646] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
> [    0.440885] PCI: Using configuration type 1 for base access
> [    0.450339] bio: create slab <bio-0> at 0
> [    0.465849] ACPI: EC: Look up EC in DSDT
> [    0.472691] ACPI: Executed 1 blocks of module-level executable AML code
> [    0.523481] ACPI: Interpreter enabled
> [    0.523516] ACPI: (supports S0 S5)
> [    0.523646] ACPI: Using IOAPIC for interrupt routing
> [    0.540283] khelper used greatest stack depth: 5160 bytes left
> [    0.571254] 
> [    0.571254] =============================================
> [    0.571254] [ INFO: possible recursive locking detected ]
> [    0.571254] 2.6.33-rc7-next-20100208 #1
> [    0.571254] ---------------------------------------------
> [    0.571254] swapper/1 is trying to acquire lock:
> [    0.571254]  (&dev->mutex){+.+...}, at: [<ffffffff81275941>] __driver_attach+0x61/0xa0
> [    0.571254] 
> [    0.571254] but task is already holding lock:
> [    0.571254]  (&dev->mutex){+.+...}, at: [<ffffffff81275933>] __driver_attach+0x53/0xa0
> [    0.571254] 
> [    0.571254] other info that might help us debug this:
> [    0.571254] 1 lock held by swapper/1:
> [    0.571254]  #0:  (&dev->mutex){+.+...}, at: [<ffffffff81275933>] __driver_attach+0x53/0xa0
> [    0.571311] 
> [    0.571311] stack backtrace:
> [    0.571375] Pid: 1, comm: swapper Not tainted 2.6.33-rc7-next-20100208 #1
> [    0.571411] Call Trace:
> [    0.571447]  [<ffffffff81068060>] __lock_acquire+0x1080/0x1d00
> [    0.571484]  [<ffffffff8110fb7d>] ? sysfs_find_dirent+0x2d/0x40
> [    0.571521]  [<ffffffff8110ffbf>] ? __sysfs_add_one+0x1f/0xe0
> [    0.571558]  [<ffffffff81068d3c>] lock_acquire+0x5c/0x80
> [    0.571594]  [<ffffffff81275941>] ? __driver_attach+0x61/0xa0
> [    0.571631]  [<ffffffff81275941>] ? __driver_attach+0x61/0xa0
> [    0.571670]  [<ffffffff8138126c>] mutex_lock_nested+0x5c/0x3a0
> [    0.571707]  [<ffffffff81275941>] ? __driver_attach+0x61/0xa0
> [    0.571743]  [<ffffffff81274420>] ? klist_devices_put+0x0/0x10
> [    0.571781]  [<ffffffff81275941>] __driver_attach+0x61/0xa0
> [    0.571817]  [<ffffffff812758e0>] ? __driver_attach+0x0/0xa0
> [    0.571854]  [<ffffffff81274f08>] bus_for_each_dev+0x68/0x90
> [    0.571890]  [<ffffffff8127562c>] driver_attach+0x1c/0x20
> [    0.571927]  [<ffffffff8127467c>] bus_add_driver+0xbc/0x260
> [    0.571965]  [<ffffffff816910bf>] ? acpi_pci_root_init+0x0/0x28
> [    0.572002]  [<ffffffff81275c7c>] driver_register+0x7c/0x160
> [    0.572039]  [<ffffffff816910bf>] ? acpi_pci_root_init+0x0/0x28
> [    0.572077]  [<ffffffff8118b165>] acpi_bus_register_driver+0x3e/0x41
> [    0.572115]  [<ffffffff816910d8>] acpi_pci_root_init+0x19/0x28
> [    0.572153]  [<ffffffff810001d8>] do_one_initcall+0x38/0x190
> [    0.572190]  [<ffffffff81675695>] kernel_init+0x1a2/0x223
> [    0.572228]  [<ffffffff81003314>] kernel_thread_helper+0x4/0x10
> [    0.572265]  [<ffffffff81383580>] ? restore_args+0x0/0x30
> [    0.572301]  [<ffffffff816754f3>] ? kernel_init+0x0/0x223
> [    0.572338]  [<ffffffff81003310>] ? kernel_thread_helper+0x0/0x10
> [    0.572729] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.572861] pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
> [    0.572861] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
> [    0.572861] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
> [    0.572861] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
> [    0.572861] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
> [    0.572861] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xffffffff] (ignored)
> [    0.572861] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [    0.572861] pci 0000:00:01.0: PME# disabled
> [    0.572861] pci 0000:00:1a.0: reg 20: [io  0xa800-0xa81f]
> [    0.572861] pci 0000:00:1a.1: reg 20: [io  0xa880-0xa89f]
> [    0.572861] pci 0000:00:1a.2: reg 20: [io  0xac00-0xac1f]
> [    0.572861] pci 0000:00:1a.7: reg 10: [mem 0xfe7ffc00-0xfe7fffff]
> [    0.572861] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
> [    0.572861] pci 0000:00:1a.7: PME# disabled
> [    0.572861] pci 0000:00:1b.0: reg 10: [mem 0xfe7f8000-0xfe7fbfff 64bit]
> [    0.572861] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.572861] pci 0000:00:1b.0: PME# disabled
> [    0.572861] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.572861] pci 0000:00:1c.0: PME# disabled
> [    0.572861] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> [    0.572861] pci 0000:00:1c.2: PME# disabled
> [    0.572861] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
> [    0.572861] pci 0000:00:1c.4: PME# disabled
> [    0.572861] pci 0000:00:1d.0: reg 20: [io  0xa080-0xa09f]
> [    0.572861] pci 0000:00:1d.1: reg 20: [io  0xa400-0xa41f]
> [    0.572861] pci 0000:00:1d.2: reg 20: [io  0xa480-0xa49f]
> [    0.580002] pci 0000:00:1d.7: reg 10: [mem 0xfe7ff800-0xfe7ffbff]
> [    0.580200] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.580240] pci 0000:00:1d.7: PME# disabled
> [    0.580408] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
> [    0.580452] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH6 GPIO
> [    0.580491] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
> [    0.580596] pci 0000:00:1f.2: reg 10: [io  0x9c00-0x9c07]
> [    0.580636] pci 0000:00:1f.2: reg 14: [io  0x9880-0x9883]
> [    0.580676] pci 0000:00:1f.2: reg 18: [io  0x9800-0x9807]
> [    0.580715] pci 0000:00:1f.2: reg 1c: [io  0x9480-0x9483]
> [    0.580755] pci 0000:00:1f.2: reg 20: [io  0x9400-0x941f]
> [    0.580794] pci 0000:00:1f.2: reg 24: [mem 0xfe7fe800-0xfe7fefff]
> [    0.580864] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.580901] pci 0000:00:1f.2: PME# disabled
> [    0.580968] pci 0000:00:1f.3: reg 10: [mem 0xfe7ff400-0xfe7ff4ff 64bit]
> [    0.581017] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
> [    0.581129] pci 0000:01:00.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
> [    0.581170] pci 0000:01:00.0: reg 14: [io  0xb000-0xb0ff]
> [    0.581210] pci 0000:01:00.0: reg 18: [mem 0xfe8e0000-0xfe8effff]
> [    0.581261] pci 0000:01:00.0: reg 30: [mem 0xfe8c0000-0xfe8dffff pref]
> [    0.581318] pci 0000:01:00.0: supports D1 D2
> [    0.581391] pci 0000:01:00.1: reg 10: [mem 0xfe8f0000-0xfe8fffff]
> [    0.581469] pci 0000:01:00.1: supports D1 D2
> [    0.581518] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> [    0.581570] pci 0000:00:01.0: PCI bridge to [bus 01-01]
> [    0.581607] pci 0000:00:01.0:   bridge window [io  0xb000-0xbfff]
> [    0.581644] pci 0000:00:01.0:   bridge window [mem 0xfe800000-0xfe8fffff]
> [    0.581684] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
> [    0.581772] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
> [    0.581816] pci 0000:00:1c.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
> [    0.581946] pci 0000:03:00.0: reg 10: [mem 0xfeafc000-0xfeafffff 64bit]
> [    0.581989] pci 0000:03:00.0: reg 18: [io  0xd800-0xd8ff]
> [    0.582051] pci 0000:03:00.0: reg 30: [mem 0xfeac0000-0xfeadffff pref]
> [    0.582129] pci 0000:03:00.0: supports D1 D2
> [    0.582164] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.582203] pci 0000:03:00.0: PME# disabled
> [    0.600022] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
> [    0.600065] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
> [    0.600107] pci 0000:00:1c.2:   bridge window [mem 0xfea00000-0xfeafffff]
> [    0.600256] pci 0000:02:00.0: reg 10: [io  0xcc00-0xcc07]
> [    0.600299] pci 0000:02:00.0: reg 14: [io  0xc880-0xc883]
> [    0.600342] pci 0000:02:00.0: reg 18: [io  0xc800-0xc807]
> [    0.600385] pci 0000:02:00.0: reg 1c: [io  0xc480-0xc483]
> [    0.600427] pci 0000:02:00.0: reg 20: [io  0xc400-0xc40f]
> [    0.600478] pci 0000:02:00.0: reg 30: [mem 0xfe9f0000-0xfe9fffff pref]
> [    0.600565] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> [    0.600618] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
> [    0.600655] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
> [    0.600693] pci 0000:00:1c.4:   bridge window [mem 0xfe900000-0xfe9fffff]
> [    0.600792] pci 0000:05:03.0: reg 10: [mem 0xfebff800-0xfebfffff]
> [    0.600834] pci 0000:05:03.0: reg 14: [io  0xec00-0xec7f]
> [    0.600915] pci 0000:05:03.0: supports D2
> [    0.600950] pci 0000:05:03.0: PME# supported from D2 D3hot D3cold
> [    0.600988] pci 0000:05:03.0: PME# disabled
> [    0.601069] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
> [    0.601108] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
> [    0.601146] pci 0000:00:1e.0:   bridge window [mem 0xfeb00000-0xfebfffff]
> [    0.601208] pci_bus 0000:00: on NUMA node 0
> [    0.601248] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.602567] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
> [    0.602891] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
> [    0.603630] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
> [    0.603950] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
> [    0.604278] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
> [    0.672633] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> [    0.672633] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> [    0.672633] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
> [    0.672633] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *4 5 6 7 10 11 12 14 15)
> [    0.672782] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [    0.673464] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> [    0.674087] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
> [    0.674710] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
> [    0.675187] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.675187] vgaarb: loaded
> [    0.680268] SCSI subsystem initialized
> [    0.700262] libata version 3.00 loaded.
> [    0.700364] usbcore: registered new interface driver usbfs
> [    0.700364] usbcore: registered new interface driver hub
> [    0.700364] usbcore: registered new device driver usb
> [    0.700364] PCI: Using ACPI for IRQ routing
> [    0.700364] PCI: pci_cache_line_size set to 64 bytes
> [    0.700364] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
> [    0.710085] Switching to clocksource tsc
> [    0.710167] pnp: PnP ACPI init
> [    0.710213] ACPI: bus type pnp registered
> [    0.720467] pnp: PnP ACPI: found 15 devices
> [    0.720503] ACPI: ACPI bus type pnp unregistered
> [    0.720564] system 00:01: [mem 0xfed14000-0xfed19fff] has been reserved
> [    0.720610] system 00:06: [io  0x0290-0x0297] has been reserved
> [    0.720655] system 00:07: [io  0x04d0-0x04d1] has been reserved
> [    0.720693] system 00:07: [io  0x0800-0x087f] has been reserved
> [    0.720730] system 00:07: [io  0x0480-0x04bf] has been reserved
> [    0.720768] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.720806] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
> [    0.720844] system 00:07: [mem 0xfed50000-0xfed8ffff] has been reserved
> [    0.720882] system 00:07: [mem 0xffa00000-0xffafffff] has been reserved
> [    0.720921] system 00:07: [mem 0xffb00000-0xffbfffff] has been reserved
> [    0.720967] system 00:07: [mem 0xffe00000-0xffefffff] has been reserved
> [    0.721006] system 00:07: [mem 0xfff00000-0xfffffffe] has been reserved
> [    0.721052] system 00:0a: [mem 0xffc00000-0xffdfffff] has been reserved
> [    0.721105] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
> [    0.721144] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
> [    0.721189] system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
> [    0.721593] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
> [    0.721632] system 00:0e: [mem 0x000c0000-0x000cffff] has been reserved
> [    0.721673] system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
> [    0.721714] system 00:0e: [mem 0x00100000-0xbfffffff] could not be reserved
> [    0.727664] pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc03fffff]
> [    0.727705] pci 0000:00:1c.2: BAR 9: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
> [    0.727749] pci 0000:00:1c.4: BAR 9: assigned [mem 0xc0600000-0xc07fffff 64bit pref]
> [    0.727793] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
> [    0.727831] pci 0000:00:01.0: PCI bridge to [bus 01-01]
> [    0.727867] pci 0000:00:01.0:   bridge window [io  0xb000-0xbfff]
> [    0.727906] pci 0000:00:01.0:   bridge window [mem 0xfe800000-0xfe8fffff]
> [    0.727944] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
> [    0.727988] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
> [    0.728024] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
> [    0.728063] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc03fffff]
> [    0.728102] pci 0000:00:1c.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
> [    0.728147] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
> [    0.728183] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
> [    0.728222] pci 0000:00:1c.2:   bridge window [mem 0xfea00000-0xfeafffff]
> [    0.728261] pci 0000:00:1c.2:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
> [    0.728307] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
> [    0.728343] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
> [    0.728382] pci 0000:00:1c.4:   bridge window [mem 0xfe900000-0xfe9fffff]
> [    0.728421] pci 0000:00:1c.4:   bridge window [mem 0xc0600000-0xc07fffff 64bit pref]
> [    0.728466] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
> [    0.728502] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
> [    0.728541] pci 0000:00:1e.0:   bridge window [mem 0xfeb00000-0xfebfffff]
> [    0.728580] pci 0000:00:1e.0:   bridge window [mem pref disabled]
> [    0.728631] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.728669] pci 0000:00:01.0: setting latency timer to 64
> [    0.728710] pci 0000:00:1c.0: enabling device (0106 -> 0107)
> [    0.728750] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    0.728789] pci 0000:00:1c.0: setting latency timer to 64
> [    0.728832] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    0.728871] pci 0000:00:1c.2: setting latency timer to 64
> [    0.728912] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    0.728951] pci 0000:00:1c.4: setting latency timer to 64
> [    0.728991] pci 0000:00:1e.0: setting latency timer to 64
> [    0.729028] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
> [    0.729064] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
> [    0.729101] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
> [    0.729137] pci_bus 0000:01: resource 1 [mem 0xfe800000-0xfe8fffff]
> [    0.729173] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
> [    0.729214] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
> [    0.729250] pci_bus 0000:04: resource 1 [mem 0xc0000000-0xc03fffff]
> [    0.729286] pci_bus 0000:04: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
> [    0.729327] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
> [    0.729362] pci_bus 0000:03: resource 1 [mem 0xfea00000-0xfeafffff]
> [    0.729399] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
> [    0.729440] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
> [    0.729475] pci_bus 0000:02: resource 1 [mem 0xfe900000-0xfe9fffff]
> [    0.729512] pci_bus 0000:02: resource 2 [mem 0xc0600000-0xc07fffff 64bit pref]
> [    0.729553] pci_bus 0000:05: resource 0 [io  0xe000-0xefff]
> [    0.729588] pci_bus 0000:05: resource 1 [mem 0xfeb00000-0xfebfffff]
> [    0.729624] pci_bus 0000:05: resource 3 [io  0x0000-0xffff]
> [    0.729660] pci_bus 0000:05: resource 4 [mem 0x00000000-0xffffffffffffffff]
> [    0.729740] NET: Registered protocol family 2
> [    0.729891] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.730590] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
> [    0.733028] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
> [    0.735150] TCP: Hash tables configured (established 262144 bind 65536)
> [    0.735189] TCP reno registered
> [    0.735233] UDP hash table entries: 2048 (order: 6, 262144 bytes)
> [    0.735422] UDP-Lite hash table entries: 2048 (order: 6, 262144 bytes)
> [    0.735761] NET: Registered protocol family 1
> [    0.736043] pci 0000:01:00.0: Boot video device
> [    0.736101] PCI: CLS 32 bytes, default 64
> [    0.738449] microcode: CPU0 sig=0x6f2, pf=0x1, revision=0x5a
> [    0.738495] microcode: CPU1 sig=0x6f2, pf=0x1, revision=0x5a
> [    0.738655] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    0.753544] msgmni has been set to 6000
> [    0.753643] io scheduler noop registered
> [    0.753958] io scheduler cfq registered (default)
> [    0.754369] pcieport 0000:00:01.0: setting latency timer to 64
> [    0.754440] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
> [    0.754735] pcieport 0000:00:1c.0: setting latency timer to 64
> [    0.754810] pcieport 0000:00:1c.0: irq 25 for MSI/MSI-X
> [    0.755243] pcieport 0000:00:1c.2: setting latency timer to 64
> [    0.755318] pcieport 0000:00:1c.2: irq 26 for MSI/MSI-X
> [    0.755748] pcieport 0000:00:1c.4: setting latency timer to 64
> [    0.755822] pcieport 0000:00:1c.4: irq 27 for MSI/MSI-X
> [    0.758121] ACPI: SSDT 00000000bff8e0d0 001D2 (v01    AMI   CPU1PM 00000001 INTL 20060113)
> [    0.760855] ACPI: SSDT 00000000bff8e2b0 00143 (v01    AMI   CPU2PM 00000001 INTL 20060113)
> [    0.773164] Real Time Clock Driver v1.12b
> [    0.773311] [drm] Initialized drm 1.1.0 20060810
> [    0.773454] [drm] radeon defaulting to kernel modesetting.
> [    0.773490] [drm] radeon kernel modesetting enabled.
> [    0.773589] radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.773629] radeon 0000:01:00.0: setting latency timer to 64
> [    0.777029] [drm] radeon: Initializing kernel modesetting.
> [    0.777201] [drm] register mmio base: 0xFE8E0000
> [    0.777236] [drm] register mmio size: 65536
> [    0.777540] [drm] GPU reset succeed (RBBM_STATUS=0x00000140)
> [    0.777583] [drm] Generation 2 PCI interface, using max accessible memory
> [    0.777620] [drm] radeon: VRAM 128M
> [    0.777653] [drm] radeon: VRAM from 0x00000000 to 0x07FFFFFF
> [    0.777689] [drm] radeon: GTT 512M
> [    0.777722] [drm] radeon: GTT from 0x20000000 to 0x3FFFFFFF
> [    0.777801] radeon 0000:01:00.0: irq 28 for MSI/MSI-X
> [    0.777840] [drm] radeon: using MSI.
> [    0.777919] [drm] radeon: irq initialized.
> [    0.778609] [drm] Detected VRAM RAM=128M, BAR=128M
> [    0.778648] [drm] RAM width 64bits DDR
> [    0.778781] [TTM] Zone  kernel: Available graphics memory: 1536254 kiB.
> [    0.778844] [drm] radeon: 128M of VRAM memory ready
> [    0.778880] [drm] radeon: 512M of GTT memory ready.
> [    0.778915] [drm] GART: num cpu pages 131072, num gpu pages 131072
> [    0.779580] [drm] radeon: 1 quad pipes, 1 Z pipes initialized.
> [    0.779770] [drm] PCIE GART of 512M enabled (table at 0x00040000).
> [    0.779831] [drm] radeon: cp idle (0x10000C03)
> [    0.780065] [drm] Loading R300 Microcode
> [    0.780103] platform radeon_cp.0: firmware: using built-in firmware radeon/R300_cp.bin
> [    0.780604] [drm] radeon: ring at 0x0000000020000000
> [    0.780658] [drm] ring test succeeded in 1 usecs
> [    0.781000] [drm] radeon: ib pool ready.
> [    0.781043] [drm] ib test succeeded in 0 usecs
> [    0.781178] [drm] DFP table revision: 4
> [    0.781651] [drm] Default TV standard: NTSC
> [    0.781686] [drm] 27.000000000 MHz TV ref clk
> [    0.781724] [drm] Default TV standard: NTSC
> [    0.781758] [drm] 27.000000000 MHz TV ref clk
> [    0.782007] [drm] Radeon Display Connectors
> [    0.782041] [drm] Connector 0:
> [    0.782074] [drm]   DVI-I
> [    0.782107] [drm]   HPD1
> [    0.782140] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
> [    0.782175] [drm]   Encoders:
> [    0.782208] [drm]     CRT1: INTERNAL_DAC1
> [    0.782242] [drm]     DFP1: INTERNAL_TMDS1
> [    0.782276] [drm] Connector 1:
> [    0.782309] [drm]   S-video
> [    0.782341] [drm]   Encoders:
> [    0.782374] [drm]     TV1: INTERNAL_DAC2
> [    0.798372] No connectors reported connected with modes
> [    0.798419] [drm] Initialized radeon 2.0.0 20080528 for 0000:01:00.0 on minor 0
> [    0.799149] ahci 0000:00:1f.2: version 3.0
> [    0.799203] ahci 0000:00:1f.2: PCI INT B -> GSI 22 (level, low) -> IRQ 22
> [    0.799288] ahci 0000:00:1f.2: irq 29 for MSI/MSI-X
> [    0.799392] ahci: SSS flag set, parallel bus scan disabled
> [    0.799457] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
> [    0.799500] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ccc ems sxs 
> [    0.799546] ahci 0000:00:1f.2: setting latency timer to 64
> [    0.890097] scsi0 : ahci
> [    0.890805] scsi1 : ahci
> [    0.891127] scsi2 : ahci
> [    0.891467] scsi3 : ahci
> [    0.891790] scsi4 : ahci
> [    0.892122] scsi5 : ahci
> [    0.893193] ata1: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fe900 irq 29
> [    0.893236] ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 29
> [    0.893278] ata3: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 29
> [    0.893321] ata4: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fea80 irq 29
> [    0.893362] ata5: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7feb00 irq 29
> [    0.893404] ata6: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7feb80 irq 29
> [    0.893634] pata_jmicron 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.894079] pata_jmicron 0000:02:00.0: setting latency timer to 64
> [    0.894213] scsi6 : pata_jmicron
> [    0.894527] scsi7 : pata_jmicron
> [    0.898880] ata7: PATA max UDMA/100 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 16
> [    0.898918] ata8: PATA max UDMA/100 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 16
> [    0.899108] sky2 driver version 1.26
> [    0.899196] sky2 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [    0.899244] sky2 0000:03:00.0: setting latency timer to 64
> [    0.899315] sky2 0000:03:00.0: Yukon-2 EC Ultra chip revision 3
> [    0.899450] sky2 0000:03:00.0: irq 30 for MSI/MSI-X
> [    0.899974] sky2 eth0: addr 00:22:15:87:07:fc
> [    0.900136] netconsole: local port 6665
> [    0.900171] netconsole: local IP 192.168.1.3
> [    0.900205] netconsole: interface eth0
> [    0.900239] netconsole: remote port 9353
> [    0.900273] netconsole: remote IP 192.168.1.2
> [    0.900307] netconsole: remote ethernet address 00:1b:38:af:22:49
> [    0.900346] netconsole: device eth0 not up yet, forcing it
> [    0.905186] sky2 eth0: enabling interface
> [    1.182624] ata7.01: ATAPI: _NEC DV-5800C, D9S2, max UDMA/33
> [    1.183428] ata7.01: configured for UDMA/33
> [    1.240044] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    1.286440] ata1.00: ATA-7: ST3500630AS, 3.AAK, max UDMA/133
> [    1.286480] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    1.344760] ata1.00: configured for UDMA/133
> [    1.360312] scsi 0:0:0:0: Direct-Access     ATA      ST3500630AS      3.AA PQ: 0 ANSI: 5
> [    1.360975] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
> [    1.361178] sd 0:0:0:0: [sda] Write Protect is off
> [    1.361214] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.361315] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.361734]  sda: sda1 sda2
> [    1.385432] sd 0:0:0:0: [sda] Attached SCSI disk
> [    2.112539] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    2.153726] ata2.00: ATA-7: ST3160811AS, 3.AAE, max UDMA/133
> [    2.153767] ata2.00: 312581808 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    2.212044] ata2.00: configured for UDMA/133
> [    2.232712] scsi 1:0:0:0: Direct-Access     ATA      ST3160811AS      3.AA PQ: 0 ANSI: 5
> [    2.233271] sd 1:0:0:0: [sdb] 312581808 512-byte logical blocks: (160 GB/149 GiB)
> [    2.233498] sd 1:0:0:0: [sdb] Write Protect is off
> [    2.233534] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    2.233655] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    2.234057]  sdb: unknown partition table
> [    2.260717] sd 1:0:0:0: [sdb] Attached SCSI disk
> [    2.586780] sky2 eth0: Link is up at 100 Mbps, full duplex, flow control rx
> [    2.669146] console [netcon0] enabled
> [    2.669185] netconsole: network logging started
> [    2.669256] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    2.669335] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    2.669402] ehci_hcd 0000:00:1a.7: setting latency timer to 64
> [    2.669444] ehci_hcd 0000:00:1a.7: EHCI Host Controller
> [    2.669496] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
> [    2.669593] ehci_hcd 0000:00:1a.7: debug port 1
> [    2.673519] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
> [    2.673598] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfe7ffc00
> [    2.690047] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
> [    2.690176] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    2.690223] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    2.690285] usb usb1: Product: EHCI Host Controller
> [    2.690324] usb usb1: Manufacturer: Linux 2.6.33-rc7-next-20100208 ehci_hcd
> [    2.690365] usb usb1: SerialNumber: 0000:00:1a.7
> [    2.690766] hub 1-0:1.0: USB hub found
> [    2.690819] hub 1-0:1.0: 6 ports detected
> [    2.690998] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    2.691060] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    2.691103] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    2.691156] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
> [    2.691252] ehci_hcd 0000:00:1d.7: debug port 1
> [    2.695184] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
> [    2.695256] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe7ff800
> [    2.712553] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    2.712694] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    2.712742] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    2.712801] usb usb2: Product: EHCI Host Controller
> [    2.712841] usb usb2: Manufacturer: Linux 2.6.33-rc7-next-20100208 ehci_hcd
> [    2.712882] usb usb2: SerialNumber: 0000:00:1d.7
> [    2.713229] hub 2-0:1.0: USB hub found
> [    2.713281] hub 2-0:1.0: 6 ports detected
> [    2.713534] uhci_hcd: USB Universal Host Controller Interface driver
> [    2.713772] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    2.713823] uhci_hcd 0000:00:1a.0: setting latency timer to 64
> [    2.713865] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [    2.713913] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
> [    2.713989] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000a800
> [    2.714140] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    2.714182] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    2.714227] usb usb3: Product: UHCI Host Controller
> [    2.714267] usb usb3: Manufacturer: Linux 2.6.33-rc7-next-20100208 uhci_hcd
> [    2.714323] usb usb3: SerialNumber: 0000:00:1a.0
> [    2.714762] hub 3-0:1.0: USB hub found
> [    2.714815] hub 3-0:1.0: 2 ports detected
> [    2.714964] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [    2.715014] uhci_hcd 0000:00:1a.1: setting latency timer to 64
> [    2.715055] uhci_hcd 0000:00:1a.1: UHCI Host Controller
> [    2.715107] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
> [    2.715554] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000a880
> [    2.715696] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    2.715738] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    2.715783] usb usb4: Product: UHCI Host Controller
> [    2.715826] usb usb4: Manufacturer: Linux 2.6.33-rc7-next-20100208 uhci_hcd
> [    2.715870] usb usb4: SerialNumber: 0000:00:1a.1
> [    2.716217] hub 4-0:1.0: USB hub found
> [    2.716269] hub 4-0:1.0: 2 ports detected
> [    2.716411] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    2.716461] uhci_hcd 0000:00:1a.2: setting latency timer to 64
> [    2.716502] uhci_hcd 0000:00:1a.2: UHCI Host Controller
> [    2.716551] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
> [    2.716643] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000ac00
> [    2.716837] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    2.716880] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    2.716926] usb usb5: Product: UHCI Host Controller
> [    2.716965] usb usb5: Manufacturer: Linux 2.6.33-rc7-next-20100208 uhci_hcd
> [    2.717006] usb usb5: SerialNumber: 0000:00:1a.2
> [    2.717357] hub 5-0:1.0: USB hub found
> [    2.717418] hub 5-0:1.0: 2 ports detected
> [    2.717561] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    2.717611] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    2.717652] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    2.717700] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
> [    2.717779] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000a080
> [    2.717935] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
> [    2.717977] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    2.718023] usb usb6: Product: UHCI Host Controller
> [    2.718062] usb usb6: Manufacturer: Linux 2.6.33-rc7-next-20100208 uhci_hcd
> [    2.718103] usb usb6: SerialNumber: 0000:00:1d.0
> [    2.718453] hub 6-0:1.0: USB hub found
> [    2.718505] hub 6-0:1.0: 2 ports detected
> [    2.718648] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    2.718738] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    2.718780] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    2.718833] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
> [    2.718926] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000a400
> [    2.719070] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
> [    2.719113] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    2.719158] usb usb7: Product: UHCI Host Controller
> [    2.719197] usb usb7: Manufacturer: Linux 2.6.33-rc7-next-20100208 uhci_hcd
> [    2.719238] usb usb7: SerialNumber: 0000:00:1d.1
> [    2.719589] hub 7-0:1.0: USB hub found
> [    2.719640] hub 7-0:1.0: 2 ports detected
> [    2.719792] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    2.719842] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    2.719883] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    2.719932] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
> [    2.720012] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000a480
> [    2.720158] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
> [    2.720200] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    2.720246] usb usb8: Product: UHCI Host Controller
> [    2.720285] usb usb8: Manufacturer: Linux 2.6.33-rc7-next-20100208 uhci_hcd
> [    2.720327] usb usb8: SerialNumber: 0000:00:1d.2
> [    2.720722] hub 8-0:1.0: USB hub found
> [    2.720774] hub 8-0:1.0: 2 ports detected
> [    2.721244] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> [    2.721285] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
> [    2.722100] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    2.722474] mice: PS/2 mouse device common for all mice
> [    2.722653] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    2.722702] ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region SMRG [0x400-0x40f]
> [    2.722750] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    2.723203] coretemp coretemp.0: Using relative temperature scale!
> [    2.723505] coretemp coretemp.1: Using relative temperature scale!
> [    2.723669] EDAC MC: Ver: 2.1.0 Feb  8 2010
> [    2.724937] EDAC MC0: Giving out device to 'x38_edac' 'x38': DEV 0000:00:00.0
> [    2.725092] cpuidle: using governor ladder
> [    2.725132] cpuidle: using governor menu
> [    2.728471] usbcore: registered new interface driver hiddev
> [    2.728618] usbcore: registered new interface driver usbhid
> [    2.728659] usbhid: USB HID core driver
> [    2.728990] TCP cubic registered
> [    2.729029] NET: Registered protocol family 17
> [    2.980028] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    3.020957] ata3.00: ATA-7: ST3250620AS, 3.AAE, max UDMA/133
> [    3.021005] ata3.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    3.079281] ata3.00: configured for UDMA/133
> [    3.090240] scsi 2:0:0:0: Direct-Access     ATA      ST3250620AS      3.AA PQ: 0 ANSI: 5
> [    3.090932] sd 2:0:0:0: [sdc] 488397168 512-byte logical blocks: (250 GB/232 GiB)
> [    3.091215] sd 2:0:0:0: [sdc] Write Protect is off
> [    3.091261] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    3.091393] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    3.091932]  sdc: sdc1 sdc2 < sdc5 >
> [    3.142038] sd 2:0:0:0: [sdc] Attached SCSI disk
> [    3.250023] usb 8-2: new low speed USB device using uhci_hcd and address 2
> [    3.440023] ata4: SATA link down (SStatus 0 SControl 300)
> [    3.579152] usb 8-2: New USB device found, idVendor=046d, idProduct=c30e
> [    3.579200] usb 8-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    3.579247] usb 8-2: Product: HID compliant keyboard
> [    3.579291] usb 8-2: Manufacturer: Logitech
> [    3.652762] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input0
> [    3.653188] generic-usb 0003:046D:C30E.0001: input,hidraw0: USB HID v1.10 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:1d.2-2/input0
> [    3.781424] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.1/input/input1
> [    3.781820] generic-usb 0003:046D:C30E.0002: input,hidraw1: USB HID v1.10 Device [Logitech HID compliant keyboard] on usb-0000:00:1d.2-2/input1
> [    3.810025] ata5: SATA link down (SStatus 0 SControl 300)
> [    4.090031] async/0 used greatest stack depth: 5032 bytes left
> [    4.091117] async/2 used greatest stack depth: 4920 bytes left
> [    4.182521] ata6: SATA link down (SStatus 0 SControl 300)
> [    4.202904] scsi 6:0:1:0: CD-ROM            _NEC     DV-5800C         D9S2 PQ: 0 ANSI: 5
> [    4.205209] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
> [    4.205259] Uniform CD-ROM driver Revision: 3.20
> [    4.205742] sr 6:0:1:0: Attached scsi CD-ROM sr0
> [    4.384853] EXT3-fs (sda1): mounted filesystem with ordered data mode
> [    4.385003] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
> [    4.385097] debug: unmapping init memory ffffffff81662000..ffffffff816d3000
> [    4.385178] Write protecting the kernel read-only data: 6144k
> [    4.385362] debug: unmapping init memory ffff88000138c000..ffff880001400000
> [    4.385443] debug: unmapping init memory ffff88000153c000..ffff880001600000
> [    4.385584] kjournald starting.  Commit interval 5 seconds
> [    5.200029] async/6 used greatest stack depth: 4696 bytes left
> [    5.302977] stty used greatest stack depth: 3704 bytes left
> [    5.702355] mknod used greatest stack depth: 3600 bytes left
> [    6.025799] udev: starting version 146
> [    6.237165] modprobe used greatest stack depth: 2832 bytes left
> [    7.067348] EXT3-fs (sda1): using internal journal
> [    7.243834] EXT2-fs (sdb): warning: mounting unchecked fs, running e2fsck is recommended
> [    7.290175] Adding 8388600k swap on /dev/sda2.  Priority:-1 extents:1 across:8388600k 
