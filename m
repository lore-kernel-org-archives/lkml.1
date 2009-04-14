Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZDNApu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZDNApu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 20:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbZDNApH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 20:45:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:10831 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726AbZDNApC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 20:45:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,182,1239001200"; 
   d="scan'208";a="447614565"
Subject: Re: 2.6.30-rc1 regression: boot hang due to commit
	ff69f2bba67bd45514923aaedbf40fe351787c59
From: yakui_zhao <yakui.zhao@intel.com>
To: Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: "Shi, Alex" <alex.shi@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Brown, Len" <len.brown@intel.com>
In-Reply-To: <20090413161101.0b3fc6f7@neptune.home>
References: <20090413161101.0b3fc6f7@neptune.home>
Content-Type: text/plain; charset=utf-8
Organization: Intel Open Source Technology Center
Date: Tue, 14 Apr 2009 08:46:08 +0800
Message-Id: <1239669968.5564.51.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-13 at 22:11 +0800, Bruno Prémont wrote:
> Hi All,
> 
> I bisected a boot-hang on Acer TravelMate 66x laptop and ended on
> commit ff69f2bba67bd45514923aaedbf40fe351787c59.
Will you please add the boot option of "initcall_debug" and attach the
screenshot where it hangs?
   
It will be great if you can file a new bug at
http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
and attach the output of acpidump?
Thanks.
> 
> >    acpi: fix of pmtimer overflow that make Cx states time incorrect
> >
> >    We found Cx states time abnormal in our some of machines which
> >    have 16 LCPUs, the C0 take too many time while system is really
> >    idle when kernel enabled tickless and highres.  powertop output is
> >    below:
> >
> >         PowerTOP version 1.9       (C) 2007 Intel Corporation
> >
> >    Cn                Avg residency       P-states (frequencies)
> >    C0 (cpu running)        (40.5%)         2.53 Ghz     0.0%
> >    C1                0.0ms ( 0.0%)         2.53 Ghz     0.0%
> >    C2              128.8ms (59.5%)         2.40 Ghz     0.0%
> >                                            1.60 Ghz   100.0%
> >
> >    Wakeups-from-idle per second :  4.7     interval: 20.0s
> >    no ACPI power usage estimate available
> >
> >    Top causes for wakeups:
> >      41.4% ( 24.9)       <interrupt> : extra timer interrupt
> >      20.2% ( 12.2)     <kernel core> : usb_hcd_poll_rh_status
> >    (rh_timer_func)
> >
> >    After tacking detailed for this issue, Yakui and I find it is due
> >    to 24 bit PM timer overflows when some of cpu sleep more than 4
> >    seconds. With tickless kernel, the CPU want to sleep as much as
> >    possible when system idle.  But the Cx sleep time are recorded by
> >    pmtimer which length is determined by BIOS.  The current Cx time
> >    was gotten in the following function from
> >    driver/acpi/processor_idle.c:
> >
> >    static inline u32 ticks_elapsed(u32 t1, u32 t2)
> >    {
> >           if (t2 >= t1)
> >                   return (t2 - t1);
> >           else if (!(acpi_gbl_FADT.flags & ACPI_FADT_32BIT_TIMER))
> >                   return (((0x00FFFFFF - t1) + t2) & 0x00FFFFFF);
> >           else
> >                   return ((0xFFFFFFFF - t1) + t2);
> >    }
> >
> >    If pmtimer is 24 bits and it take 5 seconds from t1 to t2, in above
> >    function, just about 1 seconds ticks was recorded.  So the Cx time
> >    will be reduced about 4 seconds.  and this is why we see above
> >    powertop output.
> >
> >    To resolve this problem, Yakui and I use ktime_get() to record the
> >    Cx states time instead of PM timer as the following patch. the
> >    patch was tested with i386/x86_64 modes on several platforms.
> 
> 
> Reverting just that commit gets the system to boot (current linus tree as of commit
>   commit   b0cbc861a3c05e634520b049b5cc27ad6febb51f
>   Author:  Linus Torvalds <torvalds@linux-foundation.org>
>   Date:    Sat Apr 11 12:45:20 2009 -0700
>   Subject: Revert "ACPI battery: fix async boot oops"
> 
> 
> 
> With above commit the boot process hangs at
> [    0.640995] Marking TSC unstable due to TSC halts in idle
> [    0.643771] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
> or
> [    0.640995] Marking TSC unstable due to TSC halts in idle
> 
> (which one of both depends on the bisection stage)
> 
> Bruno
> 
> A complete boot log with above commit reverted follows below:
> [    0.000000] Linux version 2.6.30-rc1 (kbuild@neptune) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.2)) #1 Mon Apr 13 15:24:43 CEST 2009
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   NSC Geode by NSC
> [    0.000000]   Cyrix CyrixInstead
> [    0.000000]   Centaur CentaurHauls
> [    0.000000]   Transmeta GenuineTMx86
> [    0.000000]   Transmeta TransmetaCPU
> [    0.000000]   UMC UMC UMC UMC
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000ce000 - 00000000000d0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000001dee0000 (usable)
> [    0.000000]  BIOS-e820: 000000001dee0000 - 000000001deec000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000001deec000 - 000000001df00000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000001df00000 - 0000000020000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec10000 - 00000000fec20000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fffffc00 - 0000000100000000 (reserved)
> [    0.000000] DMI present.
> [    0.000000] last_pfn = 0x1dee0 max_arch_pfn = 0x100000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-C7FFF write-protect
> [    0.000000]   C8000-EFFFF uncachable
> [    0.000000]   F0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask FE0000000 write-back
> [    0.000000]   1 base 01DF00000 mask FFFF00000 uncachable
> [    0.000000]   2 base 01E000000 mask FFE000000 uncachable
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] PAT not supported by CPU.
> [    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] modified physical RAM map:
> [    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
> [    0.000000]  modified: 0000000000001000 - 0000000000010000 (reserved)
> [    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
> [    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
> [    0.000000]  modified: 00000000000ce000 - 00000000000d0000 (reserved)
> [    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  modified: 0000000000100000 - 000000001dee0000 (usable)
> [    0.000000]  modified: 000000001dee0000 - 000000001deec000 (ACPI data)
> [    0.000000]  modified: 000000001deec000 - 000000001df00000 (ACPI NVS)
> [    0.000000]  modified: 000000001df00000 - 0000000020000000 (reserved)
> [    0.000000]  modified: 00000000fec10000 - 00000000fec20000 (reserved)
> [    0.000000]  modified: 00000000ff800000 - 00000000ffc00000 (reserved)
> [    0.000000]  modified: 00000000fffffc00 - 0000000100000000 (reserved)
> [    0.000000] init_memory_mapping: 0000000000000000-000000001dee0000
> [    0.000000]  0000000000 - 0000400000 page 4k
> [    0.000000]  0000400000 - 001dc00000 page 2M
> [    0.000000]  001dc00000 - 001dee0000 page 4k
> [    0.000000] kernel direct mapping tables up to 1dee0000 @ 10000-15000
> [    0.000000] ACPI: RSDP 000f6050 00014 (v00 ACER  )
> [    0.000000] ACPI: RSDT 1dee5a39 00030 (v01 ACER   Wagtail  20020114  LTP 00000000)
> [    0.000000] ACPI: FACP 1deebf2c 00074 (v01 ACER   Wagtail  20020114 PTL  00000050)
> [    0.000000] ACPI: DSDT 1dee5a69 064C3 (v01 ACER   Wagtail  20020114 MSFT 0100000E)
> [    0.000000] ACPI: FACS 1defcfc0 00040
> [    0.000000] ACPI: HPET 1deebfa0 00038 (v01 ACER   Wagtail  20020114 PTL  00000000)
> [    0.000000] ACPI: BOOT 1deebfd8 00028 (v01 ACER   Wagtail  20020114  LTP 00000001)
> [    0.000000] 478MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 1dee0000
> [    0.000000]   low ram: 0 - 1dee0000
> [    0.000000]   node 0 low ram: 00000000 - 1dee0000
> [    0.000000]   node 0 bootmap 00011000 - 00014bdc
> [    0.000000] (6 early reservations) ==> bootmem [0000000000 - 001dee0000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
> [    0.000000]   #1 [0000100000 - 0000558df0]    TEXT DATA BSS ==> [0000100000 - 0000558df0]
> [    0.000000]   #2 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
> [    0.000000]   #3 [0000559000 - 000055b198]              BRK ==> [0000559000 - 000055b198]
> [    0.000000]   #4 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
> [    0.000000]   #5 [0000011000 - 0000015000]          BOOTMAP ==> [0000011000 - 0000015000]
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000000 -> 0x00001000
> [    0.000000]   Normal   0x00001000 -> 0x0001dee0
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[3] active PFN ranges
> [    0.000000]     0: 0x00000000 -> 0x00000001
> [    0.000000]     0: 0x00000010 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x0001dee0
> [    0.000000] On node 0 totalpages: 122480
> [    0.000000] free_area_init_node: node 0, pgdat c0494d80, node_mem_map c1000000
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3952 pages, LIFO batch:0
> [    0.000000]   Normal zone: 926 pages used for memmap
> [    0.000000]   Normal zone: 117570 pages, LIFO batch:31
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0x1008
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0x0 is invalid
> [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
> [    0.000000] nr_irqs_gsi: 16
> [    0.000000] Allocating PCI resources starting at 30000000 (gap: 20000000:dec10000)
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 121522
> [    0.000000] Kernel command line: hpet=force BOOT_IMAGE=2.6.30-git ro root=806 softlevel=default video=vesafb:1400x1050-32
> [    0.000000] Enabling fast FPU save and restore... done.
> [    0.000000] Enabling unmasked SIMD FPU exception support... done.
> [    0.000000] Initializing CPU#0
> [    0.000000] NR_IRQS:288
> [    0.000000] CPU 0 irqstacks, hard=c0496000 soft=c0497000
> [    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 1495.136 MHz processor.
> [    0.010000] Console: colour dummy device 80x25
> [    0.010000] console [tty0] enabled
> [    0.010000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.010000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.010000] Memory: 480952k/490368k available (2515k kernel code, 8736k reserved, 1193k data, 288k init, 0k highmem)
> [    0.010000] virtual kernel memory layout:
> [    0.010000]     fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
> [    0.010000]     vmalloc : 0xde6e0000 - 0xfffa8000   ( 536 MB)
> [    0.010000]     lowmem  : 0xc0000000 - 0xddee0000   ( 478 MB)
> [    0.010000]       .init : 0xc04a1000 - 0xc04e9000   ( 288 kB)
> [    0.010000]       .data : 0xc0374c08 - 0xc049f278   (1193 kB)
> [    0.010000]       .text : 0xc0100000 - 0xc0374c08   (2515 kB)
> [    0.010000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.010000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> [    0.010009] Calibrating delay loop (skipped), value calculated using timer frequency.. 2990.27 BogoMIPS (lpj=14951360)
> [    0.010040] Mount-cache hash table entries: 512
> [    0.010190] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.010200] CPU: L2 cache: 1024K
> [    0.010206] [ds] using Pentium M configuration
> [    0.010211] [ds] pebs not available
> [    0.010219] Intel machine check architecture supported.
> [    0.010227] Intel machine check reporting enabled on CPU#0.
> [    0.010239] CPU: Intel(R) Pentium(R) M processor 1500MHz stepping 05
> [    0.010250] Checking 'hlt' instruction... OK.
> [    0.050402] ACPI: Core revision 20090320
> [    0.062937] ACPI: setting ELCR to 0200 (from 0c00)
> [    0.070181] net_namespace: 724 bytes
> [    0.070415] khelper used greatest stack depth: 3440 bytes left
> [    0.070464] Time: 15:28:07  Date: 04/13/09
> [    0.070523] NET: Registered protocol family 16
> [    0.070659] ACPI: bus type pci registered
> [    0.071947] PCI: PCI BIOS revision 2.10 entry at 0xfd742, last bus=2
> [    0.071955] PCI: Using configuration type 1 for base access
> [    0.072693] bio: create slab <bio-0> at 0
> [    0.073608] ACPI: EC: Look up EC in DSDT
> [    0.080200] ACPI: EC: non-query interrupt received, switching to interrupt mode
> [    0.080252] khelper used greatest stack depth: 2992 bytes left
> [    0.100182] ACPI: Interpreter enabled
> [    0.100205] ACPI: (supports S0 S3 S5)
> [    0.100233] ACPI: Using PIC for interrupt routing
> [    0.109162] ACPI: EC: GPE = 0x1d, I/O: command/status = 0x66, data = 0x62
> [    0.109176] ACPI: EC: driver started in interrupt mode
> [    0.109268] ACPI: Power Resource [PFN0] (off)
> [    0.109326] ACPI: Power Resource [PFN1] (off)
> [    0.110342] ACPI: ACPI Dock Station Driver: 1 docks/bays found
> [    0.110366] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.110513] pci 0000:00:02.0: reg 10 32bit mmio: [0xe8000000-0xefffffff]
> [    0.110520] pci 0000:00:02.0: reg 14 32bit mmio: [0xe0000000-0xe007ffff]
> [    0.110526] pci 0000:00:02.0: reg 18 io port: [0x1800-0x1807]
> [    0.110545] pci 0000:00:02.0: supports D1
> [    0.110563] pci 0000:00:02.1: reg 10 32bit mmio: [0xf0000000-0xf7ffffff]
> [    0.110569] pci 0000:00:02.1: reg 14 32bit mmio: [0xe0080000-0xe00fffff]
> [    0.110590] pci 0000:00:02.1: supports D1
> [    0.110657] pci 0000:00:1d.0: reg 20 io port: [0x1820-0x183f]
> [    0.110705] pci 0000:00:1d.1: reg 20 io port: [0x1840-0x185f]
> [    0.110752] pci 0000:00:1d.2: reg 20 io port: [0x1860-0x187f]
> [    0.110805] pci 0000:00:1d.7: reg 10 32bit mmio: [0xe0100000-0xe01003ff]
> [    0.110857] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.110867] pci 0000:00:1d.7: PME# disabled
> [    0.110947] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
> [    0.110955] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
> [    0.110965] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH4 GPIO
> [    0.110992] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
> [    0.110999] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
> [    0.111006] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
> [    0.111013] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
> [    0.111021] pci 0000:00:1f.1: reg 20 io port: [0x1810-0x181f]
> [    0.111028] pci 0000:00:1f.1: reg 24 32bit mmio: [0x000000-0x0003ff]
> [    0.111074] pci 0000:00:1f.3: reg 20 io port: [0x1880-0x189f]
> [    0.111114] pci 0000:00:1f.5: reg 10 io port: [0x1c00-0x1cff]
> [    0.111121] pci 0000:00:1f.5: reg 14 io port: [0x18c0-0x18ff]
> [    0.111128] pci 0000:00:1f.5: reg 18 32bit mmio: [0xe0100c00-0xe0100dff]
> [    0.111135] pci 0000:00:1f.5: reg 1c 32bit mmio: [0xe0100800-0xe01008ff]
> [    0.111162] pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
> [    0.111170] pci 0000:00:1f.5: PME# disabled
> [    0.111200] pci 0000:00:1f.6: reg 10 io port: [0x2400-0x24ff]
> [    0.111207] pci 0000:00:1f.6: reg 14 io port: [0x2000-0x207f]
> [    0.111240] pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
> [    0.111249] pci 0000:00:1f.6: PME# disabled
> [    0.111287] pci 0000:02:02.0: reg 10 32bit mmio: [0xe0204000-0xe0205fff]
> [    0.111323] pci 0000:02:02.0: supports D1 D2
> [    0.111326] pci 0000:02:02.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.111335] pci 0000:02:02.0: PME# disabled
> [    0.111367] pci 0000:02:04.0: reg 10 32bit mmio: [0xe0206000-0xe0206fff]
> [    0.111434] pci 0000:02:06.0: reg 10 32bit mmio: [0xe0207000-0xe0207fff]
> [    0.111451] pci 0000:02:06.0: supports D1 D2
> [    0.111454] pci 0000:02:06.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.111463] pci 0000:02:06.0: PME# disabled
> [    0.111495] pci 0000:02:06.1: reg 10 32bit mmio: [0xe0208000-0xe0208fff]
> [    0.111513] pci 0000:02:06.1: supports D1 D2
> [    0.111516] pci 0000:02:06.1: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.111525] pci 0000:02:06.1: PME# disabled
> [    0.111562] pci 0000:02:07.0: reg 10 32bit mmio: [0xe0209000-0xe02097ff]
> [    0.111570] pci 0000:02:07.0: reg 14 32bit mmio: [0xe0200000-0xe0203fff]
> [    0.111605] pci 0000:02:07.0: supports D1 D2
> [    0.111608] pci 0000:02:07.0: PME# supported from D0 D1 D2 D3hot
> [    0.111617] pci 0000:02:07.0: PME# disabled
> [    0.111649] pci 0000:00:1e.0: transparent bridge
> [    0.111657] pci 0000:00:1e.0: bridge io port: [0x3000-0x3fff]
> [    0.111662] pci 0000:00:1e.0: bridge 32bit mmio: [0xe0200000-0xe07fffff]
> [    0.111701] pci_bus 0000:00: on NUMA node 0
> [    0.111709] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.111917] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
> [    0.115782] ACPI: PCI Interrupt Link [LNKA] (IRQs *11)
> [    0.115944] ACPI: PCI Interrupt Link [LNKB] (IRQs *10)
> [    0.116108] ACPI: PCI Interrupt Link [LNKC] (IRQs *10)
> [    0.116266] ACPI: PCI Interrupt Link [LNKD] (IRQs 10) *11
> [    0.116429] ACPI: PCI Interrupt Link [LNKE] (IRQs 10) *11
> [    0.116587] ACPI: PCI Interrupt Link [LNKF] (IRQs 10) *0, disabled.
> [    0.116746] ACPI: PCI Interrupt Link [LNKG] (IRQs 11) *0, disabled.
> [    0.116905] ACPI: PCI Interrupt Link [LNKH] (IRQs *10)
> [    0.117134] SCSI subsystem initialized
> [    0.118964] libata version 3.00 loaded.
> [    0.119177] ACPI: WMI: Mapper loaded
> [    0.119190] PCI: Using ACPI for IRQ routing
> [    0.119303] Expanded resource reserved due to conflict with Adapter ROM
> [    0.119628] hpet clockevent registered
> [    0.119633] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    0.119645] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [    0.119656] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> [    0.120867] pnp: PnP ACPI init
> [    0.120898] ACPI: bus type pnp registered
> [    0.126594] pnp: PnP ACPI: found 9 devices
> [    0.126605] ACPI: ACPI bus type pnp unregistered
> [    0.126629] system 00:04: ioport range 0x600-0x60f has been reserved
> [    0.126638] system 00:04: ioport range 0x700-0x70f has been reserved
> [    0.126646] system 00:04: ioport range 0x800-0x80f has been reserved
> [    0.126654] system 00:04: ioport range 0x1000-0x107f has been reserved
> [    0.126662] system 00:04: ioport range 0x1180-0x11bf has been reserved
> [    0.126670] system 00:04: ioport range 0x1c0-0x1cf has been reserved
> [    0.126679] system 00:04: ioport range 0xfe00-0xfe00 has been reserved
> [    0.126688] system 00:04: ioport range 0x4d0-0x4d1 has been reserved
> [    0.126696] system 00:04: ioport range 0x610-0x61f has been reserved
> [    0.126705] system 00:04: iomem range 0xfec10000-0xfec1ffff has been reserved
> [    0.126714] system 00:04: iomem range 0xff800000-0xffbfffff has been reserved
> [    0.126723] system 00:04: iomem range 0xfff00000-0xffffffff could not be reserved
> [    0.126733] system 00:04: iomem range 0x0-0x9ffff could not be reserved
> [    0.126742] system 00:04: iomem range 0xe0000-0xfffff could not be reserved
> [    0.161561] pci 0000:02:06.0: CardBus bridge, secondary bus 0000:03
> [    0.161570] pci 0000:02:06.0:   IO window: 0x003000-0x0030ff
> [    0.161579] pci 0000:02:06.0:   IO window: 0x003400-0x0034ff
> [    0.161587] pci 0000:02:06.0:   PREFETCH window: 0x30000000-0x33ffffff
> [    0.161597] pci 0000:02:06.0:   MEM window: 0x3c000000-0x3fffffff
> [    0.161606] pci 0000:02:06.1: CardBus bridge, secondary bus 0000:07
> [    0.161613] pci 0000:02:06.1:   IO window: 0x003800-0x0038ff
> [    0.161622] pci 0000:02:06.1:   IO window: 0x003c00-0x003cff
> [    0.161631] pci 0000:02:06.1:   PREFETCH window: 0x34000000-0x37ffffff
> [    0.161640] pci 0000:02:06.1:   MEM window: 0x40000000-0x43ffffff
> [    0.161649] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
> [    0.161657] pci 0000:00:1e.0:   IO window: 0x3000-0x3fff
> [    0.161666] pci 0000:00:1e.0:   MEM window: 0xe0200000-0xe07fffff
> [    0.161675] pci 0000:00:1e.0:   PREFETCH window: 0x00000030000000-0x00000037ffffff
> [    0.161698] pci 0000:00:1e.0: setting latency timer to 64
> [    0.161951] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
> [    0.161960] PCI: setting IRQ 10 as level-triggered
> [    0.161967] pci 0000:02:06.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
> [    0.161983] pci 0000:02:06.1: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
> [    0.161997] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
> [    0.162001] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
> [    0.162005] pci_bus 0000:02: resource 0 io:  [0x3000-0x3fff]
> [    0.162009] pci_bus 0000:02: resource 1 mem: [0xe0200000-0xe07fffff]
> [    0.162012] pci_bus 0000:02: resource 2 mem: [0x30000000-0x37ffffff]
> [    0.162016] pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
> [    0.162020] pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffff]
> [    0.162024] pci_bus 0000:03: resource 0 io:  [0x3000-0x30ff]
> [    0.162027] pci_bus 0000:03: resource 1 io:  [0x3400-0x34ff]
> [    0.162031] pci_bus 0000:03: resource 2 mem: [0x30000000-0x33ffffff]
> [    0.162035] pci_bus 0000:03: resource 3 mem: [0x3c000000-0x3fffffff]
> [    0.162038] pci_bus 0000:07: resource 0 io:  [0x3800-0x38ff]
> [    0.162042] pci_bus 0000:07: resource 1 io:  [0x3c00-0x3cff]
> [    0.162045] pci_bus 0000:07: resource 2 mem: [0x34000000-0x37ffffff]
> [    0.162049] pci_bus 0000:07: resource 3 mem: [0x40000000-0x43ffffff]
> [    0.162101] NET: Registered protocol family 2
> [    0.162233] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
> [    0.162589] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
> [    0.162728] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
> [    0.162802] TCP: Hash tables configured (established 16384 bind 16384)
> [    0.162810] TCP reno registered
> [    0.162880] NET: Registered protocol family 1
> [    0.162945] Simple Boot Flag at 0x37 set to 0x1
> [    0.162972] Machine check exception polling timer started.
> [    0.163010] Scanning for low memory corruption every 60 seconds
> [    0.166982] msgmni has been set to 939
> [    0.167121] io scheduler noop registered
> [    0.167146] io scheduler cfq registered (default)
> [    0.167172] pci 0000:00:02.0: Boot video device
> [    0.167558] vesafb: framebuffer at 0xe8000000, mapped to 0xde780000, using 5120k, total 32576k
> [    0.167570] vesafb: mode is 1280x1024x16, linelength=2560, pages=11
> [    0.167577] vesafb: scrolling: redraw
> [    0.167584] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
> [    0.202073] Console: switching to colour frame buffer device 160x64
> [    0.232735] fb0: VESA VGA frame buffer device
> [    0.235243] ACPI: AC Adapter [ACAD] (on-line)
> [    0.235543] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    0.235853] ACPI: Power Button (FF) [PWRF]
> [    0.236091] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
> [    0.236839] ACPI: Lid Switch [LID]
> [    0.237045] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
> [    0.237385] ACPI: Sleep Button (CM) [SLPB]
> [    0.237764] fan PNP0C0B:00: registered as cooling_device0
> [    0.237981] ACPI: Fan [FAN0] (off)
> [    0.238286] fan PNP0C0B:01: registered as cooling_device1
> [    0.238502] ACPI: Fan [FAN1] (off)
> [    0.239031] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02/input/input3
> [    0.239380] ACPI: Video Device [AGP] (multi-head: yes  rom: yes  post: no)
> [    0.239726] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> [    0.240030] processor ACPI_CPU:00: registered as cooling_device2
> [    0.242070] thermal LNXTHERM:01: registered as thermal_zone0
> [    0.242312] ACPI: Thermal Zone [THRM] (50 C)
> [    0.242513] isapnp: Scanning for PnP cards...
> [    0.555301] isapnp: No Plug & Play device found
> [    0.556993] Linux agpgart interface v0.103
> [    0.557179] agpgart-intel 0000:00:00.0: Intel 855GM Chipset
> [    0.558119] agpgart-intel 0000:00:00.0: detected 32636K stolen memory
> [    0.559812] agpgart-intel 0000:00:00.0: AGP aperture is 128M @ 0xe8000000
> [    0.560196] [drm] Initialized drm 1.1.0 20060810
> [    0.560417] pci 0000:00:02.0: power state changed by ACPI to D0
> [    0.560941] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
> [    0.561171] PCI: setting IRQ 11 as level-triggered
> [    0.561178] pci 0000:00:02.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
> [    0.561493] pci 0000:00:02.0: setting latency timer to 64
> [    0.565905] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [    0.566099] Driver 'sd' needs updating - please use bus_type methods
> [    0.566168] Driver 'sr' needs updating - please use bus_type methods
> [    0.568546] ata_piix 0000:00:1f.1: version 2.12
> [    0.568581] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
> [    0.570928] ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
> [    0.573211] ata_piix 0000:00:1f.1: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
> [    0.575522] ata_piix 0000:00:1f.1: setting latency timer to 64
> [    0.579593] ACPI: Battery Slot [BAT1] (battery absent)
> [    0.582109] scsi0 : ata_piix
> [    0.584579] ACPI: Battery Slot [BAT2] (battery absent)
> [    0.586902] scsi1 : ata_piix
> [    0.590688] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
> [    0.592928] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
> [    0.595267] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOU2] at 0x60,0x64 irq 1,12
> [    0.600379] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.602595] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    0.604874] mice: PS/2 mouse device common for all mice
> [    0.607530] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
> [    0.609761] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
> [    0.612081] cpuidle: using governor ladder
> [    0.614366] cpuidle: using governor menu
> [    0.616574] Netfilter messages via NETLINK v0.30.
> [    0.619312] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    0.621548] Switched to high resolution mode on CPU 0
> [    0.621586] TCP cubic registered
> [    0.623952] NET: Registered protocol family 10
> [    0.626994] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [    0.629177] NET: Registered protocol family 17
> [    0.631491] Using IPI Shortcut mode
> [    0.633886]   Magic number: 5:480:487
> [    0.636119] rtc_cmos 00:01: setting system clock to 2009-04-13 15:28:07 UTC (1239636487)
> [    0.640995] Marking TSC unstable due to TSC halts in idle
> [    0.643771] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
> [    0.770944] ata1.00: ATA-6: FUJITSU MHT2060AH, 006C, max UDMA/100
> [    0.773151] ata1.00: 117210240 sectors, multi 16: LBA
> [    0.810884] ata1.00: configured for UDMA/100
> [    0.813178] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHT2060A 006C PQ: 0 ANSI: 5
> [    0.815473] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    0.817702] sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors: (60.0 GB/55.8 GiB)
> [    0.820109] sd 0:0:0:0: [sda] Write Protect is off
> [    0.822294] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    0.822322] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    0.824649]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
> [    0.941364] sd 0:0:0:0: [sda] Attached SCSI disk
> [    0.980409] ata2.01: NODEV after polling detection
> [    1.000855] ata2.00: ATAPI: UJDA740 DVD/CDRW, 1.20, max UDMA/33
> [    1.040877] ata2.00: configured for UDMA/33
> [    1.049739] scsi 1:0:0:0: CD-ROM            MATSHITA UJDA740 DVD/CDRW 1.20 PQ: 0 ANSI: 5
> [    1.061620] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
> [    1.066696] Uniform CD-ROM driver Revision: 3.20
> [    1.071952] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [    1.072086] sr 1:0:0:0: Attached scsi generic sg1 type 5
> [    1.110201] Clocksource tsc unstable (delta = -401116411 ns)
> [    1.229329] Synaptics Touchpad, model: 1, fw: 5.8, id: 0x9d48b1, caps: 0x904713/0x4006
> [    1.267734] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input5
> [    1.306148] REISERFS (device sda6): found reiserfs format "3.6" with standard journal
> [    1.311555] REISERFS (device sda6): using ordered data mode
> [    1.323594] REISERFS (device sda6): journal params: device sda6, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> [    1.335520] REISERFS (device sda6): checking transaction log (sda6)
> [    1.384724] REISERFS (device sda6): Using r5 hash to sort names
> [    1.390330] VFS: Mounted root (reiserfs filesystem) readonly on device 8:6.
> [    1.395893] Freeing unused kernel memory: 288k freed
> [    1.940044] async/0 used greatest stack depth: 2440 bytes left
> [    2.070039] async/1 used greatest stack depth: 2216 bytes left
> [    2.923033] cat used greatest stack depth: 1664 bytes left
> [    2.982499] init-early.sh used greatest stack depth: 1464 bytes left
> [    5.271495] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
> [    5.271505] i801_smbus 0000:00:1f.3: PCI INT B -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
> [    5.279644] NET: Registered protocol family 23
> [    5.280095] usbcore: registered new interface driver usbfs
> [    5.280123] usbcore: registered new interface driver hub
> [    5.280153] usbcore: registered new device driver usb
> [    5.322023] uhci_hcd: USB Universal Host Controller Interface driver
> [    5.322107] uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
> [    5.322121] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    5.322126] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    5.322184] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
> [    5.322212] uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001820
> [    5.322265] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.322269] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.322273] usb usb1: Product: UHCI Host Controller
> [    5.322276] usb usb1: Manufacturer: Linux 2.6.30-rc1 uhci_hcd
> [    5.322279] usb usb1: SerialNumber: 0000:00:1d.0
> [    5.322381] usb usb1: configuration #1 chosen from 1 choice
> [    5.322420] hub 1-0:1.0: USB hub found
> [    5.322428] hub 1-0:1.0: 2 ports detected
> [    5.322866] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
> [    5.322872] uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 10 (level, low) -> IRQ 10
> [    5.322879] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    5.322883] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    5.322915] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
> [    5.322937] uhci_hcd 0000:00:1d.1: irq 10, io base 0x00001840
> [    5.322974] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.322978] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.322981] usb usb2: Product: UHCI Host Controller
> [    5.322984] usb usb2: Manufacturer: Linux 2.6.30-rc1 uhci_hcd
> [    5.322987] usb usb2: SerialNumber: 0000:00:1d.1
> [    5.323047] usb usb2: configuration #1 chosen from 1 choice
> [    5.323083] hub 2-0:1.0: USB hub found
> [    5.323091] hub 2-0:1.0: 2 ports detected
> [    5.323187] uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
> [    5.323194] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    5.323198] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    5.323223] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
> [    5.323243] uhci_hcd 0000:00:1d.2: irq 10, io base 0x00001860
> [    5.323278] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.323282] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.323285] usb usb3: Product: UHCI Host Controller
> [    5.323288] usb usb3: Manufacturer: Linux 2.6.30-rc1 uhci_hcd
> [    5.323291] usb usb3: SerialNumber: 0000:00:1d.2
> [    5.323355] usb usb3: configuration #1 chosen from 1 choice
> [    5.323389] hub 3-0:1.0: USB hub found
> [    5.323396] hub 3-0:1.0: 2 ports detected
> [    5.338799] input: PC Speaker as /devices/platform/pcspkr/input/input6
> [    5.417641] nsc-ircc, chip->init
> [    5.417653] nsc-ircc, Found chip at base=0x04e
> [    5.417678] nsc-ircc, driver loaded (Dag Brattli)
> [    5.418466] IrDA: Registered device irda0
> [    5.418526] nsc-ircc, Found dongle: HP HSDL-1100/HSDL-2100
> [    5.419124] b44 0000:02:02.0: PCI INT A -> Link[LNKD] -> GSI 10 (level, low) -> IRQ 10
> [    5.456913] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    5.456919] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
> [    5.457342] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
> [    5.457351] ehci_hcd 0000:00:1d.7: PCI INT D -> Link[LNKH] -> GSI 10 (level, low) -> IRQ 10
> [    5.457378] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    5.457384] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    5.457441] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
> [    5.461350] ehci_hcd 0000:00:1d.7: debug port 1
> [    5.461358] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
> [    5.467726] ehci_hcd 0000:00:1d.7: irq 10, io mem 0xe0100000
> [    5.493273] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    5.493345] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
> [    5.493350] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.493355] usb usb4: Product: EHCI Host Controller
> [    5.493359] usb usb4: Manufacturer: Linux 2.6.30-rc1 ehci_hcd
> [    5.493432] usb usb4: SerialNumber: 0000:00:1d.7
> [    5.493599] usb usb4: configuration #1 chosen from 1 choice
> [    5.493654] hub 4-0:1.0: USB hub found
> [    5.493668] hub 4-0:1.0: 6 ports detected
> [    5.530179] ssb: Sonics Silicon Backplane found on PCI device 0000:02:02.0
> [    5.530224] b44.c:v2.0
> [    5.571133] eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 00:c0:9f:2d:03:9d
> [    5.576184] udev: renamed network interface eth0 to lan
> [    6.100042] usb 3-2: new full speed USB device using uhci_hcd and address 2
> [    6.281478] usb 3-2: New USB device found, idVendor=0451, idProduct=2036
> [    6.281491] usb 3-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> [    6.281501] usb 3-2: Product: General Purpose USB Hub
> [    6.281715] usb 3-2: configuration #1 chosen from 1 choice
> [    6.294574] Intel ICH 0000:00:1f.5: PCI INT B -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
> [    6.294646] Intel ICH 0000:00:1f.5: setting latency timer to 64
> [    6.299187] hub 3-2:1.0: USB hub found
> [    6.300146] hub 3-2:1.0: 3 ports detected
> [    6.581092] usb 3-2.3: new full speed USB device using uhci_hcd and address 3
> [    6.719062] usb 3-2.3: New USB device found, idVendor=0483, idProduct=1307
> [    6.719072] usb 3-2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    6.719081] usb 3-2.3: Product: USB Mass Storage Device
> [    6.719089] usb 3-2.3: Manufacturer: Generic
> [    6.719096] usb 3-2.3: SerialNumber: ABCDEF0123456789
> [    6.719319] usb 3-2.3: configuration #1 chosen from 1 choice
> [    6.783281] Initializing USB Mass Storage driver...
> [    6.783492] scsi2 : SCSI emulation for USB Mass Storage devices
> [    6.783920] usbcore: registered new interface driver usb-storage
> [    6.783930] USB Mass Storage support registered.
> [    6.785786] usb-storage: device found at 3
> [    6.785794] usb-storage: waiting for device to settle before scanning
> [    7.160045] intel8x0_measure_ac97_clock: measured 59888 usecs
> [    7.160054] intel8x0: clocking to 48000
> [    7.848365] loop: module loaded
> [   11.781298] usb-storage: device scan complete
> [   11.784293] scsi 2:0:0:0: Direct-Access     Generic  Flash R/W        2002 PQ: 0 ANSI: 2
> [   11.785083] sd 2:0:0:0: Attached scsi generic sg2 type 0
> [   11.790473] sd 2:0:0:0: [sdb] Attached SCSI removable disk
> [   14.463597] SGI XFS with ACLs, security attributes, no debug enabled
> [   14.472073] SGI XFS Quota Management subsystem
> [   14.540909] XFS mounting filesystem sda9
> [   14.658893] Ending clean XFS mount for filesystem: sda9
> [   14.683846] REISERFS (device sda10): found reiserfs format "3.6" with standard journal
> [   14.683891] REISERFS (device sda10): using ordered data mode
> [   14.701317] REISERFS (device sda10): journal params: device sda10, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> [   14.702434] REISERFS (device sda10): checking transaction log (sda10)
> [   14.745925] REISERFS (device sda10): Using r5 hash to sort names
> [   14.766035] REISERFS (device sda7): found reiserfs format "3.6" with standard journal
> [   14.766076] REISERFS (device sda7): using ordered data mode
> [   14.775663] REISERFS (device sda7): journal params: device sda7, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> [   14.776643] REISERFS (device sda7): checking transaction log (sda7)
> [   14.820843] REISERFS (device sda7): Using r5 hash to sort names
> [   14.860513] REISERFS (device sda8): found reiserfs format "3.6" with standard journal
> [   14.860555] REISERFS (device sda8): using ordered data mode
> [   14.875822] REISERFS (device sda8): journal params: device sda8, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> [   14.876741] REISERFS (device sda8): checking transaction log (sda8)
> [   14.923066] REISERFS (device sda8): Using r5 hash to sort names
> [   15.052737] XFS mounting filesystem loop0
> [   15.220713] Ending clean XFS mount for filesystem: loop0
> [   15.293966] mount used greatest stack depth: 1432 bytes left
> [   17.682682] Adding 1004020k swap on /dev/sda5.  Priority:-1 extents:1 across:1004020k
> [   18.834675] ADDRCONF(NETDEV_UP): lan: link is not ready
> [   18.985292] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
> [   18.985297] All bugs added by David S. Miller <davem@redhat.com>
> [   19.022449] ADDRCONF(NETDEV_UP): lan.658: link is not ready
> [   22.040180] b44: lan: Link is up at 100 Mbps, full duplex.
> [   22.040190] b44: lan: Flow control is off for TX and off for RX.
> [   22.040362] ADDRCONF(NETDEV_CHANGE): lan: link becomes ready
> [   22.041386] ADDRCONF(NETDEV_CHANGE): lan.658: link becomes ready
> [   31.131607] RPC: Registered udp transport module.
> [   31.131617] RPC: Registered tcp transport module.
> [   31.417577] svc: failed to register lockdv1 RPC service (errno 97).
> [   31.421659] mount.nfs used greatest stack depth: 1240 bytes left
> [   31.681518] squashfs: version 4.0 (2009/01/31) Phillip Lougher
> [   32.330037] lan.658: no IPv6 routers present

