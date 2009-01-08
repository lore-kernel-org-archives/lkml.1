Return-Path: <linux-kernel-owner+w=401wt.eu-S1762980AbZAHWU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762980AbZAHWU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZAHWUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:20:47 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:1320 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbZAHWUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:20:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=RoRkq2XqjSQR4bo3UE1eWQZoHZW6Wudx1qYreXxmNCMIWZoD3bSjIPwArGUMmHL8+n
         46yttbwOFL+zqhVf9X6PaqhA8+fK6vEC00XvqVh0RChkVN07TnSGL7aMfdZBXUgz2ZXk
         ++DVlQWWc+x9RbXdQretkArOCRUvGAvOdDsuk=
Message-ID: <49667C36.4080300@gmail.com>
Date: Thu, 08 Jan 2009 14:20:38 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081126)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: torvalds@linux-foundation.org, Pekka Paalanen <pq@iki.fi>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [fix] Too async libata breakage
References: <b6fcc0a0901081202m30be591fse66e7f38477e0c0c@mail.gmail.com>	<20090108221753.78648cd6@daedalus.pq.iki.fi> <20090108125317.648397d2@infradead.org>
In-Reply-To: <20090108125317.648397d2@infradead.org>
Content-Type: multipart/mixed;
 boundary="------------080902080102090504090203"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080902080102090504090203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Arjan van de Ven wrote:
>>> Additional async_synchronize_full() helps and box boot to the end.
>>>       
>
> Hi Linus,
>
> can you add the patch below to your tree? This makes the
> async_synchronize_full() a real absolute async barrier, rather than
> just synchronizing the work scheduled upto the starting point.
> It's a bit too much for some cases (so later on I might introduce the
> softer synchronization again) but it solves some real problems
> for people so this should go into -rc1 please...
>
> >From ca1827b142e41b54c612026b3c0b5d239f21a715 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Thu, 8 Jan 2009 12:35:11 -0800
> Subject: [PATCH] async: make async_synchronize_full() more serializing
>
> turns out that there are real problems with allowing async
> tasks that are scheduled from async tasks to run after
> the async_synchronize_full() returns.
>
> This patch makes the _full more strict and a complete
> synchronization. Later I might need to add back a lighter
> form of synchronization for other uses.. but not right now.
>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  kernel/async.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/async.c b/kernel/async.c
> index 9737338..64cc916 100644
> --- a/kernel/async.c
> +++ b/kernel/async.c
> @@ -206,7 +206,9 @@ EXPORT_SYMBOL_GPL(async_schedule_special);
>  
>  void async_synchronize_full(void)
>  {
> -	async_synchronize_cookie(next_cookie);
> +	do {
> +		async_synchronize_cookie(next_cookie);
> +	} while (!list_empty(&async_running) || !list_empty(&async_pending));
>  }
>  EXPORT_SYMBOL_GPL(async_synchronize_full);
>  
>   
I have to say that ohci/firescope is nice
poof right up: dmesg shows up:
attach is the results.
unfortunantly nothing different than
what the boot screen shows.

<7>[    2.003768] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
<5>[    2.012019] sd 2:0:1:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
<5>[    2.012055] sd 2:0:1:0: Attached scsi generic sg1 type 0
<4>[    2.012270] VFS: Cannot open root device "sda1" or unknown-block(0,0)
<4>[    2.012271] Please append a correct "root=" boot option; here are 
the available partitions:
<4>[    2.012276] 0b00         1048575 sr0 driver: sr
<0>[    2.012279] Kernel panic - not syncing: VFS: Unable to mount root 
fs on unknown-block(0,0)


regards;

Justin P. Mattock

--------------080902080102090504090203
Content-Type: text/plain;
 name="unabletomount"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="unabletomount"

Port 0 (ohci1394) opened, 2 nodes detected
Loaded system.map </home/amy/Desktop/System.map> <1116316> bytes
2 nodes available, local node is: 1
 0: ffc0, uuid: ffe31900 7ed82afe
 1: ffc1, uuid: 805b0600 55720f01 [LOCAL]
kernel buffer at phys 5d3090 len 262144
<5>[    0.000000] Linux version 2.6.28-07485-g9e42d0c (root@unix) (gcc version 4.3.3 20081217 (prerelease) (Ubuntu 4.3.2-2ubuntu9) ) #8 SMP Thu Jan 8 12:39:28 P    ST 2009
<4>[    0.000000] KERNEL supported cpus:
<4>[    0.000000]   Intel GenuineIntel
<4>[    0.000000]   AMD AuthenticAMD
<4>[    0.000000]   NSC Geode by NSC
<4>[    0.000000]   Cyrix CyrixInstead
<4>[    0.000000]   Centaur CentaurHauls
<4>[    0.000000]   Transmeta GenuineTMx86
<4>[    0.000000]   Transmeta TransmetaCPU
<4>[    0.000000]   UMC UMC UMC UMC
<6>[    0.000000] BIOS-provided physical RAM map:
<6>[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
<6>[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
<6>[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f0ea000 (usable)
<6>[    0.000000]  BIOS-e820: 000000003f0ea000 - 000000003f2eb000 (ACPI NVS)
<6>[    0.000000]  BIOS-e820: 000000003f2eb000 - 000000003febe000 (ACPI data)
<6>[    0.000000]  BIOS-e820: 000000003febe000 - 000000003feef000 (ACPI NVS)
<6>[    0.000000]  BIOS-e820: 000000003feef000 - 000000003ff00000 (ACPI data)
<6>[    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
<6>[    0.000000] DMI 2.4 present.
<6>[    0.000000] last_pfn = 0x3f0ea max_arch_pfn = 0x100000
<6>[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
<7>[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-d000
<6>[    0.000000] init_ohci1394_dma: initializing OHCI-1394 at 0c:03.0
<6>[    0.000000] init_ohci1394_dma: finished initializing OHCI DMA
<4>[    0.000000] ACPI: RSDP 000FE020, 0024 (r2 APPLE )
<4>[    0.000000] ACPI: XSDT 3FEFD1C0, 0074 (r1 APPLE   Apple00       A5       1000013)
<4>[    0.000000] ACPI: FACP 3FEFB000, 00F4 (r3 APPLE   Apple00       A5 Loki       5F)
<4>[    0.000000] ACPI: DSDT 3FEF0000, 48D1 (r1 APPLE  MacBookP    20002 INTL 20050309)
<4>[    0.000000] ACPI: FACS 3FEC0000, 0040
<4>[    0.000000] ACPI: HPET 3FEFA000, 0038 (r1 APPLE   Apple00        1 Loki       5F)
<4>[    0.000000] ACPI: APIC 3FEF9000, 0068 (r1 APPLE   Apple00        1 Loki       5F)
<4>[    0.000000] ACPI: MCFG 3FEF8000, 003C (r1 APPLE   Apple00        1 Loki       5F)
<4>[    0.000000] ACPI: ASF! 3FEF7000, 00A0 (r32 APPLE   Apple00        1 Loki       5F)
<4>[    0.000000] ACPI: SBST 3FEF6000, 0030 (r1 APPLE   Apple00        1 Loki       5F)
<4>[    0.000000] ACPI: ECDT 3FEF5000, 0053 (r1 APPLE   Apple00        1 Loki       5F)
<4>[    0.000000] ACPI: SSDT 3FEEF000, 04DC (r1 APPLE     CpuPm     3000 INTL 20050309)
<4>[    0.000000] ACPI: SSDT 3FEBD000, 064F (r1 SataRe  SataPri     1000 INTL 20050309)
<4>[    0.000000] ACPI: SSDT 3FEBC000, 069C (r1 SataRe  SataSec     1000 INTL 20050309)
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<5>[    0.000000] 120MB HIGHMEM available.
<5>[    0.000000] 887MB LOWMEM available.
<6>[    0.000000]   mapped low ram: 0 - 377fe000
<6>[    0.000000]   low ram: 00000000 - 377fe000
<6>[    0.000000]   bootmap 00009000 - 0000ff00
<6>[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 00377fe000]
<6>[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
<6>[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
<6>[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
<6>[    0.000000]   #3 [0000100000 - 0000669210]    TEXT DATA BSS ==> [0000100000 - 0000669210]
<6>[    0.000000]   #4 [000066a000 - 000066d000]    INIT_PG_TABLE ==> [000066a000 - 000066d000]
<6>[    0.000000]   #5 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
<6>[    0.000000]   #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
<6>[    0.000000]   #7 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 0000010000]
<4>[    0.000000] Zone PFN ranges:
<4>[    0.000000]   DMA      0x00000000 -> 0x00001000
<4>[    0.000000]   Normal   0x00001000 -> 0x000377fe
<4>[    0.000000]   HighMem  0x000377fe -> 0x0003f0ea
<4>[    0.000000] Movable zone start PFN for each node
<4>[    0.000000] early_node_map[2] active PFN ranges
<4>[    0.000000]     0: 0x00000000 -> 0x0000009f
<4>[    0.000000]     0: 0x00000100 -> 0x0003f0ea
<7>[    0.000000] On node 0 totalpages: 258185
<7>[    0.000000] free_area_init_node: node 0, pgdat c053bb40, node_mem_map c1000000
<7>[    0.000000]   DMA zone: 32 pages used for memmap
<7>[    0.000000]   DMA zone: 0 pages reserved
<7>[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
<7>[    0.000000]   Normal zone: 1744 pages used for memmap
<7>[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
<7>[    0.000000]   HighMem zone: 242 pages used for memmap
<7>[    0.000000]   HighMem zone: 30714 pages, LIFO batch:7
<6>[    0.000000] Using APIC driver default
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x408
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
<6>[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
<6>[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
<7>[    0.000000] ACPI: IRQ0 used by override.
<7>[    0.000000] ACPI: IRQ2 used by override.
<7>[    0.000000] ACPI: IRQ9 used by override.
<4>[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
<6>[    0.000000] Using ACPI (MADT) for SMP configuration information
<6>[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
<6>[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
<6>[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
<6>[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
<6>[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
<6>[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:b0000000)
<6>[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
<6>[    0.000000] PERCPU: Allocating 40960 bytes of per cpu data
<4>[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 256167
<5>[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.28-07485-g9e42d0c root=/dev/sda1 vga=790 debug pnpacpi=off pci=routeirq acpi_osi=Darwin audi    t=1 selinux=1 ohci1394_dma=early enforcing=0
<6>[    0.000000] ACPI: Added _OSI(Darwin)
<6>[    0.000000] audit: enabled (after initialization)
<6>[    0.000000] Enabling fast FPU save and restore... done.
<6>[    0.000000] Enabling unmasked SIMD FPU exception support... done.
<6>[    0.000000] Initializing CPU#0
<4>[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
<6>[    0.000000] Extended CMOS year: 2000
<4>[    0.000000] TSC: Unable to calibrate against PIT
<6>[    0.000000] TSC: using PMTIMER reference calibration
<4>[    0.000000] Detected 2161.192 MHz processor.
<4>[    0.010000] Console: colour dummy device 80x25
<6>[    0.010000] console [tty0] enabled
<6>[    0.010000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
<6>[    0.010000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
<6>[    0.010000] Memory: 1017788k/1033128k available (2967k kernel code, 14592k reserved, 1458k data, 404k init, 123824k highmem)
<6>[    0.010000] virtual kernel memory layout:
<6>[    0.010000]     fixmap  : 0xfff9e000 - 0xfffff000   ( 388 kB)
<6>[    0.010000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
<6>[    0.010000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
<6>[    0.010000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
<6>[    0.010000]       .init : 0xc055a000 - 0xc05bf000   ( 404 kB)
<6>[    0.010000]       .data : 0xc03e5e9e - 0xc05529c4   (1458 kB)
<6>[    0.010000]       .text : 0xc0100000 - 0xc03e5e9e   (2967 kB)
<6>[    0.010000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
<6>[    0.010000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
<7>[    0.010000] hpet clockevent registered
<6>[    0.010000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
<6>[    0.010000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4322.38 BogoMIPS (lpj=21611920)
<6>[    0.010000] Security Framework initialized
<6>[    0.010000] SELinux:  Initializing.
<7>[    0.010000] SELinux:  Starting in permissive mode
<6>[    0.010000] Failure registering Root Plug module with the kernel
<4>[    0.010000] Mount-cache hash table entries: 512
<6>[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
<6>[    0.010000] CPU: L2 cache: 4096K
<6>[    0.010000] [ds] using core 2 configuration
<6>[    0.010000] CPU: Physical Processor ID: 0
<6>[    0.010000] CPU: Processor Core ID: 0
<6>[    0.010000] Intel machine check architecture supported.
<6>[    0.010000] Intel machine check reporting enabled on CPU#0.
<6>[    0.010000] using mwait in idle threads.
<6>[    0.010000] Checking 'hlt' instruction... OK.
<6>[    0.041108] ACPI: Core revision 20080926
<6>[    0.061495] ftrace: converting mcount calls to 0f 1f 44 00 00
<6>[    0.061503] ftrace: allocating 15022 entries in 59 pages
<7>[    0.067559]   alloc irq_2_pin on cpu 0 node 0
<7>[    0.067569]   alloc irq_2_pin on cpu 0 node 0
<7>[    0.067575]   alloc irq_2_pin on cpu 0 node 0
<7>[    0.067581]   alloc irq_2_pin on cpu 0 node 0
<7>[    0.067587]   alloc irq_2_pin on cpu 0 node 0
<7>[    0.067593]   alloc irq_2_pin on cpu 0 node 0
<7>[    0.067599]   alloc irq_2_pin on cpu 0 node 0
<7>[    0.067604]   alloc irq_2_pin on cpu 0 node 0
<7>[    0.067610]   alloc irq_2_pin on cpu 0 node 0
<7>[    0.067616]   alloc irq_2_pin on cpu 0 node 0
<7>[    0.067622]   alloc irq_2_pin on cpu 0 node 0
<7>[    0.067628]   alloc irq_2_pin on cpu 0 node 0
<7>[    0.067634]   alloc irq_2_pin on cpu 0 node 0
<7>[    0.067640]   alloc irq_2_pin on cpu 0 node 0
<7>[    0.067646]   alloc irq_2_pin on cpu 0 node 0
<6>[    0.067803] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>[    0.167822] CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
<6>[    0.170000] Testing tracer nop: PASSED
<6>[    0.170000] Booting processor 1 APIC 0x1 ip 0x6000

<6>[    0.010000] Initializing CPU#1
<6>[    0.010000] Calibrating delay using timer specific routine.. 4322.51 BogoMIPS (lpj=21612591)
<6>[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
<6>[    0.010000] CPU: L2 cache: 4096K
<6>[    0.010000] [ds] using core 2 configuration
<6>[    0.010000] CPU: Physical Processor ID: 0
<6>[    0.010000] CPU: Processor Core ID: 1
<6>[    0.010000] Intel machine check architecture supported.
<6>[    0.010000] Intel machine check reporting enabled on CPU#1.
<6>[    0.010000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
<6>[    0.321762] CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
<6>[    0.321798] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
<6>[    0.330032] Brought up 2 CPUs
<6>[    0.330037] Total of 2 processors activated (8644.90 BogoMIPS).
<7>[    0.330105] CPU0 attaching sched-domain:
<7>[    0.330109]  domain 0: span 0-1 level MC
<7>[    0.330113]   groups: 0 1
<7>[    0.330120] CPU1 attaching sched-domain:
<7>[    0.330124]  domain 0: span 0-1 level MC
<7>[    0.330127]   groups: 1 0
<6>[    0.330215] net_namespace: 800 bytes
<6>[    0.330215] Booting paravirtualized kernel on bare hardware
<6>[    0.330328] NET: Registered protocol family 16
<6>[    0.330328] EISA bus registered
<6>[    0.330328] ACPI: bus type pci registered
<6>[    0.330328] PCI: Using configuration type 1 for base access
<4>[    0.340108] bio: create slab <bio-0> at 0
<6>[    0.341226] ACPI: EC: EC description table is found, configuring boot EC
<6>[    0.341477] ACPI: EC: non-query interrupt received, switching to interrupt mode
<6>[    0.355446] ACPI: Interpreter enabled
<6>[    0.355453] ACPI: (supports S0 S3 S4 S5)
<6>[    0.355528] ACPI: Using IOAPIC for interrupt routing
<6>[    0.371513] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
<6>[    0.371513] ACPI: EC: driver started in interrupt mode
<6>[    0.371513] ACPI: No dock devices found.
<6>[    0.371513] ACPI: PCI Root Bridge [PCI0] (0000:00)
<6>[    0.371513] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
<6>[    0.371513] pci 0000:00:01.0: PME# disabled
<7>[    0.371513] pci 0000:00:07.0: reg 10 32bit mmio: [0x50404000-0x50404fff]
<7>[    0.371513] pci 0000:00:1b.0: reg 10 64bit mmio: [0x50400000-0x50403fff]
<6>[    0.371513] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
<6>[    0.371513] pci 0000:00:1b.0: PME# disabled
<6>[    0.371513] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
<6>[    0.371513] pci 0000:00:1c.0: PME# disabled
<6>[    0.371513] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
<6>[    0.371513] pci 0000:00:1c.1: PME# disabled
<6>[    0.371513] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
<6>[    0.371513] pci 0000:00:1c.2: PME# disabled
<7>[    0.371513] pci 0000:00:1d.0: reg 20 io port: [0x4080-0x409f]
<7>[    0.371513] pci 0000:00:1d.1: reg 20 io port: [0x4060-0x407f]
<7>[    0.371513] pci 0000:00:1d.2: reg 20 io port: [0x4040-0x405f]
<7>[    0.371513] pci 0000:00:1d.3: reg 20 io port: [0x4020-0x403f]
<7>[    0.371513] pci 0000:00:1d.7: reg 10 32bit mmio: [0x50405400-0x504057ff]
<6>[    0.371513] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
<6>[    0.371513] pci 0000:00:1d.7: PME# disabled
<6>[    0.371513] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
<6>[    0.371513] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
<6>[    0.371513] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
<6>[    0.371513] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 000f)
<6>[    0.371513] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0300 (mask 001f)
<7>[    0.371513] pci 0000:00:1f.1: reg 10 io port: [0x40d8-0x40df]
<7>[    0.371513] pci 0000:00:1f.1: reg 14 io port: [0x40ec-0x40ef]
<7>[    0.371513] pci 0000:00:1f.1: reg 18 io port: [0x40d0-0x40d7]
<7>[    0.371513] pci 0000:00:1f.1: reg 1c io port: [0x40e8-0x40eb]
<7>[    0.371513] pci 0000:00:1f.1: reg 20 io port: [0x40b0-0x40bf]
<7>[    0.371513] pci 0000:00:1f.2: reg 10 io port: [0x40c8-0x40cf]
<7>[    0.371513] pci 0000:00:1f.2: reg 14 io port: [0x40e4-0x40e7]
<7>[    0.371513] pci 0000:00:1f.2: reg 18 io port: [0x40c0-0x40c7]
<7>[    0.371513] pci 0000:00:1f.2: reg 1c io port: [0x40e0-0x40e3]
<7>[    0.371513] pci 0000:00:1f.2: reg 20 io port: [0x40a0-0x40af]
<7>[    0.371513] pci 0000:00:1f.2: reg 24 32bit mmio: [0x50405000-0x504053ff]
<6>[    0.371513] pci 0000:00:1f.2: PME# supported from D3hot
<6>[    0.371513] pci 0000:00:1f.2: PME# disabled
<7>[    0.371578] pci 0000:00:1f.3: reg 20 io port: [0xefa0-0xefbf]
<7>[    0.371656] pci 0000:01:00.0: reg 10 32bit mmio: [0x40000000-0x47ffffff]
<7>[    0.371666] pci 0000:01:00.0: reg 14 io port: [0x3000-0x30ff]
<7>[    0.371677] pci 0000:01:00.0: reg 18 32bit mmio: [0x50300000-0x5030ffff]
<7>[    0.371699] pci 0000:01:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
<7>[    0.371731] pci 0000:01:00.0: supports D1 D2
<7>[    0.371793] pci 0000:00:01.0: bridge io port: [0x3000-0x3fff]
<7>[    0.371798] pci 0000:00:01.0: bridge 32bit mmio: [0x50300000-0x503fffff]
<7>[    0.371806] pci 0000:00:01.0: bridge 64bit mmio pref: [0x40000000-0x47ffffff]
<7>[    0.371888] pci 0000:02:00.0: reg 10 64bit mmio: [0x50200000-0x50203fff]
<7>[    0.371901] pci 0000:02:00.0: reg 18 io port: [0x2000-0x20ff]
<7>[    0.371939] pci 0000:02:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
<7>[    0.371998] pci 0000:02:00.0: supports D1 D2
<6>[    0.372001] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
<6>[    0.372010] pci 0000:02:00.0: PME# disabled
<7>[    0.372077] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
<7>[    0.372084] pci 0000:00:1c.0: bridge 32bit mmio: [0x50200000-0x502fffff]
<7>[    0.372164] pci 0000:03:00.0: reg 10 64bit mmio: [0x50100000-0x5010ffff]
<7>[    0.372261] pci 0000:03:00.0: supports D1
<6>[    0.372264] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
<6>[    0.372272] pci 0000:03:00.0: PME# disabled
<7>[    0.372352] pci 0000:00:1c.1: bridge 32bit mmio: [0x50100000-0x501fffff]
<7>[    0.372422] pci 0000:00:1c.2: bridge io port: [0x1000-0x1fff]
<7>[    0.372429] pci 0000:00:1c.2: bridge 32bit mmio: [0x4c100000-0x500fffff]
<7>[    0.372439] pci 0000:00:1c.2: bridge 64bit mmio pref: [0x48000000-0x4bffffff]
<7>[    0.372498] pci 0000:0c:03.0: reg 10 32bit mmio: [0x4c004000-0x4c0047ff]
<7>[    0.372510] pci 0000:0c:03.0: reg 14 32bit mmio: [0x4c000000-0x4c003fff]
<7>[    0.372578] pci 0000:0c:03.0: supports D1 D2
<6>[    0.372582] pci 0000:0c:03.0: PME# supported from D0 D1 D2 D3hot
<6>[    0.372589] pci 0000:0c:03.0: PME# disabled
<6>[    0.372653] pci 0000:00:1e.0: transparent bridge
<7>[    0.372663] pci 0000:00:1e.0: bridge 32bit mmio: [0x4c000000-0x4c0fffff]
<7>[    0.372701] pci_bus 0000:00: on NUMA node 0
<7>[    0.372715] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
<7>[    0.381727] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
<7>[    0.382333] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
<7>[    0.382924] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
<7>[    0.383509] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
<7>[    0.384122] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]

<6>[    0.401127] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
<6>[    0.401127] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
<6>[    0.401127] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
<6>[    0.401127] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
<6>[    0.401401] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
<6>[    0.401691] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
<6>[    0.410042] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
<6>[    0.410328] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
<5>[    0.410446] SCSI subsystem initialized
<7>[    0.410446] libata version 3.00 loaded.
<6>[    0.410446] usbcore: registered new interface driver usbfs
<6>[    0.410446] usbcore: registered new interface driver hub
<6>[    0.410446] usbcore: registered new device driver usb
<6>[    0.410446] PCI: Using ACPI for IRQ routing
<6>[    0.410446] PCI: Routing PCI interrupts for all devices because "pci=routeirq" specified
<7>[    0.410446]   alloc irq_2_pin on cpu 0 node 0
<6>[    0.410446] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<6>[    0.410446] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<7>[    0.410446]   alloc irq_2_pin on cpu 0 node 0
<6>[    0.410446] pci 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
<7>[    0.410446]   alloc irq_2_pin on cpu 0 node 0
<6>[    0.410446] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
<6>[    0.410446] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
<7>[    0.410446]   alloc irq_2_pin on cpu 0 node 0
<6>[    0.410446] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
<7>[    0.410446]   alloc irq_2_pin on cpu 0 node 0
<6>[    0.410446] pci 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
<7>[    0.410446]   alloc irq_2_pin on cpu 0 node 0
<6>[    0.410446] pci 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
<6>[    0.410446] pci 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
<6>[    0.410446] pci 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
<6>[    0.410446] pci 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
<6>[    0.410446] pci 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
<6>[    0.410446] pci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
<6>[    0.410446] pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
<6>[    0.410446] vendor=8086 device=27a1
<6>[    0.410446] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<6>[    0.410446] vendor=8086 device=27d0
<6>[    0.410446] pci 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<6>[    0.410446] vendor=8086 device=27d2
<6>[    0.410446] pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
<6>[    0.410446] vendor=8086 device=2448
<6>[    0.410446] pci 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
<6>[    0.440090] cfg80211: Using static regulatory domain info
<6>[    0.440090] cfg80211: Regulatory domain: US
<6>[    0.440090]       (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
<6>[    0.440090]       (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
<6>[    0.440090]       (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
<6>[    0.440090]       (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
<6>[    0.440090]       (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
<6>[    0.440090]       (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
<6>[    0.440090]       (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
<6>[    0.440093] cfg80211: Calling CRDA for country: US
<6>[    0.440122] NetLabel: Initializing
<6>[    0.440122] NetLabel:  domain hash size = 128
<6>[    0.440122] NetLabel:  protocols = UNLABELED CIPSOv4
<6>[    0.440141] NetLabel:  unlabeled traffic allowed by default
<6>[    0.440155] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
<6>[    0.440162] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
<6>[    0.470029] pnp: PnP ACPI: disabled
<7>[    0.501835] Switched to high resolution mode on CPU 1
<6>[    0.505920] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
<6>[    0.505927] pci 0000:00:01.0:   IO window: 0x3000-0x3fff
<6>[    0.505934] pci 0000:00:01.0:   MEM window: 0x50300000-0x503fffff
<6>[    0.505939] pci 0000:00:01.0:   PREFETCH window: 0x00000040000000-0x00000047ffffff
<6>[    0.505949] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
<6>[    0.505955] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
<6>[    0.505963] pci 0000:00:1c.0:   MEM window: 0x50200000-0x502fffff
<6>[    0.505970] pci 0000:00:1c.0:   PREFETCH window: 0x00000050500000-0x000000505fffff
<6>[    0.505981] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
<6>[    0.505985] pci 0000:00:1c.1:   IO window: disabled
<6>[    0.505993] pci 0000:00:1c.1:   MEM window: 0x50100000-0x501fffff
<6>[    0.506000] pci 0000:00:1c.1:   PREFETCH window: disabled
<6>[    0.506009] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
<6>[    0.506015] pci 0000:00:1c.2:   IO window: 0x1000-0x1fff
<6>[    0.506023] pci 0000:00:1c.2:   MEM window: 0x4c100000-0x500fffff
<6>[    0.506030] pci 0000:00:1c.2:   PREFETCH window: 0x00000048000000-0x0000004bffffff
<6>[    0.506041] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0c
<6>[    0.506045] pci 0000:00:1e.0:   IO window: disabled
<6>[    0.506053] pci 0000:00:1e.0:   MEM window: 0x4c000000-0x4c0fffff
<6>[    0.506060] pci 0000:00:1e.0:   PREFETCH window: disabled
<6>[    0.506073] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<7>[    0.506080] pci 0000:00:01.0: setting latency timer to 64
<6>[    0.506087] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
<7>[    0.506094] pci 0000:00:1c.0: setting latency timer to 64
<6>[    0.506102] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
<7>[    0.506109] pci 0000:00:1c.1: setting latency timer to 64
<6>[    0.506117] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
<7>[    0.506124] pci 0000:00:1c.2: setting latency timer to 64
<7>[    0.510005] Switched to high resolution mode on CPU 0
<6>[    0.510565] pci 0000:00:1e.0: power state changed by ACPI to D0
<7>[    0.510575] pci 0000:00:1e.0: setting latency timer to 64
<7>[    0.510581] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
<7>[    0.510585] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
<7>[    0.510590] pci_bus 0000:01: resource 0 io:  [0x3000-0x3fff]
<7>[    0.510594] pci_bus 0000:01: resource 1 mem: [0x50300000-0x503fffff]
<7>[    0.510598] pci_bus 0000:01: resource 2 mem: [0x40000000-0x47ffffff]
<7>[    0.510602] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
<7>[    0.510606] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
<7>[    0.510610] pci_bus 0000:02: resource 1 mem: [0x50200000-0x502fffff]
<7>[    0.510614] pci_bus 0000:02: resource 2 mem: [0x50500000-0x505fffff]
<7>[    0.510618] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
<7>[    0.510622] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
<7>[    0.510625] pci_bus 0000:03: resource 1 mem: [0x50100000-0x501fffff]
<7>[    0.510630] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
<7>[    0.510633] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
<7>[    0.510637] pci_bus 0000:04: resource 0 io:  [0x1000-0x1fff]
<7>[    0.510641] pci_bus 0000:04: resource 1 mem: [0x4c100000-0x500fffff]
<7>[    0.510645] pci_bus 0000:04: resource 2 mem: [0x48000000-0x4bffffff]
<7>[    0.510649] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
<7>[    0.510653] pci_bus 0000:0c: resource 0 mem: [0x0-0x0]
<7>[    0.510657] pci_bus 0000:0c: resource 1 mem: [0x4c000000-0x4c0fffff]
<7>[    0.510661] pci_bus 0000:0c: resource 2 mem: [0x0-0x0]
<7>[    0.510665] pci_bus 0000:0c: resource 3 io:  [0x00-0xffff]
<7>[    0.510669] pci_bus 0000:0c: resource 4 mem: [0x000000-0xffffffff]
<6>[    0.510703] NET: Registered protocol family 2
<6>[    0.540086] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
<6>[    0.540446] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
<6>[    0.540892] TCP bind hash table entries: 65536 (order: 8, 1310720 bytes)
<6>[    0.541444] TCP: Hash tables configured (established 131072 bind 65536)
<6>[    0.541448] TCP reno registered
<6>[    0.550162] NET: Registered protocol family 1
<6>[    0.551235] platform rtc_cmos: registered platform RTC device (no PNP device found)
<6>[    0.553515] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
<4>[    0.555130] Initializing RT-Tester: OK
<6>[    0.555260] audit: initializing netlink socket (enabled)
<5>[    0.555326] type=2000 audit(1231452424.550:1): initialized
<6>[    0.558603] Testing tracer sched_switch:  PASSED
<6>[    0.660046] Testing tracer function: PASSED
<6>[    0.790733] Testing dynamic ftrace:  PASSED
<6>[    1.030057] Testing tracer irqsoff:  PASSED
<6>[    1.040311] Testing tracer wakeup:  PASSED
<4>[    1.370271] highmem bounce pool size: 64 pages
<6>[    1.370280] HugeTLB registered 4 MB page size, pre-allocated 0 pages

<6>[    1.388770] fuse init (API version 7.11)
<6>[    1.389459] msgmni has been set to 1746
<7>[    1.389725] SELinux:  Registering netfilter hooks
<6>[    1.390618] alg: No test for stdrng (krng)
<6>[    1.390637] io scheduler noop registered
<6>[    1.391023] io scheduler cfq registered (default)
<7>[    1.391175] pci 0000:01:00.0: Boot video device
<6>[    1.391859] vesafb: framebuffer at 0x40000000, mapped to 0xf8100000, using 3072k, total 16384k
<6>[    1.391866] vesafb: mode is 1024x768x16, linelength=2048, pages=9
<6>[    1.391870] vesafb: protected mode interface info at c000:ad0c
<6>[    1.391874] vesafb: pmi: set display start = c00cad94, set palette = c00cae50
<6>[    1.391878] vesafb: scrolling: redraw
<6>[    1.391882] vesafb: Truecolor: size=0:5:5:5, shift=0:10:5:0

<4>[    1.416203] Console: switching to colour frame buffer device 128x48

<6>[    1.438376] fb0: VESA VGA frame buffer device

<6>[    1.454068] loop: module loaded
<6>[    1.454220] Linux video capture interface: v2.00
<6>[    1.454707] input: Macintosh mouse button emulation as /class/input/input0

<4>[    1.455368] Driver 'sd' needs updating - please use bus_type methods
<4>[    1.455772] Driver 'sr' needs updating - please use bus_type methods
<7>[    1.456457] ata_piix 0000:00:1f.1: version 2.12
<6>[    1.456763] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
<6>[    1.457061] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
<7>[    1.457433] ata_piix 0000:00:1f.1: setting latency timer to 64
<6>[    1.457800] scsi0 : ata_piix
<6>[    1.458503] scsi1 : ata_piix
<6>[    1.460671] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
<6>[    1.460992] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
<6>[    1.461330] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
<6>[    1.461735] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]

<7>[    1.620022] ata_piix 0000:00:1f.2: setting latency timer to 64

<6>[    1.631577] scsi2 : ata_piix

<6>[    1.639319] scsi3 : ata_piix
<6>[    1.643111] ata1.00: ATAPI: MATSHITADVD-R   UJ-857D, KCV9, max UDMA/66

<6>[    1.658409] ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 0x40a0 irq 19

<6>[    1.666169] ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 0x40a8 irq 19
<6>[    1.674201] usbcore: registered new interface driver usblcd

<6>[    1.682008] usbcore: registered new interface driver usbled
<6>[    1.683043] ata1.00: configured for UDMA/66

<6>[    1.698370] PNP: No PS/2 controller found. Probing ports directly.

<3>[    1.707143] i8042.c: No controller found.

<5>[    1.714972] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857D  KCV9 PQ: 0 ANSI: 5
<6>[    1.723852] mice: PS/2 mouse device common for all mice

<6>[    1.733181] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com

<6>[    1.741522] EDAC MC: Ver: 2.1.0 Jan  8 2009
<6>[    1.750382] cpuidle: using governor ladder

<6>[    1.758683] cpuidle: using governor menu
<4>[    1.758700] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
<6>[    1.758704] Uniform CD-ROM driver Revision: 3.20

<7>[    1.783949] sr 0:0:0:0: Attached scsi CD-ROM sr0
<6>[    1.786169] usbcore: registered new interface driver hiddev
<6>[    1.786289] usbcore: registered new interface driver usbhid
<6>[    1.786293] usbhid: v2.6:USB HID core driver
<6>[    1.786432] Advanced Linux Sound Architecture Driver Version 1.0.18a.
<6>[    1.786565] ALSA device list:
<6>[    1.786566]   No soundcards found.
<6>[    1.786784] oprofile: using NMI interrupt.
<6>[    1.787063] IPVS: Registered protocols (TCP, AH, ESP)
<6>[    1.787249] IPVS: Connection hash table configured (size=4096, memory=32Kbytes)
<6>[    1.787274] IPVS: ipvs loaded.
<6>[    1.787612] Initializing XFRM netlink socket
<6>[    1.787639] NET: Registered protocol family 17
<6>[    1.787646] NET: Registered protocol family 15
<6>[    1.787681] Using IPI No-Shortcut mode

<5>[    1.902173] sr 0:0:0:0: Attached scsi generic sg0 type 5

<6>[    1.925157] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100

<6>[    1.933027] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)

<6>[    1.970534] ata3.01: configured for UDMA/100

<5>[    1.978581] scsi 2:0:1:0: Direct-Access     ATA      FUJITSU MHW2120B 0081 PQ: 0 ANSI: 5

<5>[    1.987177] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
<5>[    1.995576] sd 2:0:1:0: [sda] Write Protect is off

<7>[    2.003768] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
<5>[    2.012019] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
<5>[    2.012055] sd 2:0:1:0: Attached scsi generic sg1 type 0
<4>[    2.012270] VFS: Cannot open root device "sda1" or unknown-block(0,0)
<4>[    2.012271] Please append a correct "root=" boot option; here are the available partitions:
<4>[    2.012276] 0b00         1048575 sr0 driver: sr
<0>[    2.012279] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)



--------------080902080102090504090203--
