Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZHIXdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZHIXdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 19:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZHIXdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 19:33:19 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:30424 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbZHIXdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 19:33:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=lSrCM9zDq1aK1sZhw1mW5f1mU1sJhxANNy8xZ7AETIPugRjH+1OuhkKSVwRUO14dKW
         b/Llnmo4JY5WbJjlfuYBfeO9PjrMo4sirICeWlMDWGPcQaB/M8d7H86jfX4LM+4wFn/4
         vAyBc8IAP7eH8x4o5o5aE22WRKBtIwXV+/Wuc=
Date: Mon, 10 Aug 2009 01:33:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: linux-next: reiserfs lockout with xattr ?
Message-ID: <20090809233302.GD6089@nowhere>
References: <4A79CA90.8080101@free.fr> <20090808002726.GI4999@nowhere> <4A7E9C63.4090400@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A7E9C63.4090400@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 09, 2009 at 11:52:35AM +0200, Laurent Riffard wrote:
> Le 08/08/2009 02:27, Frederic Weisbecker a écrit :
> > On Wed, Aug 05, 2009 at 08:08:16PM +0200, Laurent Riffard wrote:
> >> Hello,
> >>
> >> From times to times, my desktop freezes when I log in the Gnome Desktop. I'm able to switch to a text console, but I can't login. I must reboot using the magic sysrq keys.
> >>
> >> Yesterday, I managed to get some logs of this situation:
> > 
> > 
> > BTW, Im not sure exactly if it happens because of the reiserfs/kill-bkl
> > tree.
> > 
> > Could you please try this tree alone?
> > 
> > You can checkout the git tree in:
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git 
> > 
> > Or you can also apply the whole patch against current -rc5:
> > http://www.kernel.org/pub/linux/kernel/people/frederic/bench-3107/reis_full.diff
> > 
> > Thanks!
> > 
> > Frederic.
> 
> Hello Frederic,
> 
> I gave reiserfs/kill-bkl a try an I got the problem too.
> 
> # git describe
> v2.6.31-rc4-220-g46be1f8
> # git log --pretty=oneline
> 46be1f8ee8d9be0589e41f9684dabd71cd59aa36 kill-the-bkl/reiserfs: release the lock only for first entry in readdir
> 3ef09eac1a55fab1531785b2600e995f250d2f2a kill-the-bkl/reiserfs: move the concurrent tree accesses checks per superblock
> a25771e264f293d954fb9109af312aae424996ef kill-the-bkl/reiserfs: acquire the inode mutex safely
> 02e2142acaa444a106f5ffb4f2731c7050672a95 kill-the-bkl/reiserfs: unlock only when needed in search_by_key
> 93deeaf8d866c7ec10abf3293a88e725c6939d24 kill-the-bkl/reiserfs: use mutex_lock in reiserfs_mutex_lock_safe
> a937464292c5bc82550e5aa66791ebe57083c822 kill-the-bkl/reiserfs: factorize the locking in reiserfs_write_end()
> 2c919b668572c7f4e4e9817ac57b2f426962c6cd kill-the-bkl/reiserfs: reduce number of contentions in search_by_key()
> 369a6ec5aec8621f96283934de9c004443e5026b kill-the-bkl/reiserfs: don't hold the write recursively in reiserfs_lookup()
> 454fa14529bba7454f4dee0c64479ca50fca21f3 kill-the-bkl/reiserfs: lock only once on reiserfs_get_block()
> ...
> 
> Below is the full dmesg.
> 
> Please note I got a "possible circular locking dependency detected" in reiserfs. This warning does happen in linux-next too but it was hidden by another prolem in the log I sent Wednesday.
> 


Thanks a lot for this report. Reiserfs xattrs are definetly paths I
haven't tested deeply.

I'm trying to reproduce these issues and will let you know once I get
a fix.

(Btw, if you're still running this tree, you should update with the
latest patch I just pushed, it's a very important fix).

Thanks,

Frederic.
 
> Inspecting /boot/System.map-2.6.31-rc4-00220-g46be1f8
> Cannot find map file.
> Loaded 42779 symbols from 68 modules.
> [    0.000000] Linux version 2.6.31-rc4-00220-g46be1f8 (laurent@calimero) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #233 SMP PREEMPT Sat Aug 8 23:20:02 CEST 2009
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   AMD AuthenticAMD
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
> [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000003bef0000 (usable)
> [    0.000000]  BIOS-e820: 000000003bef0000 - 000000003bef3000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000003bef3000 - 000000003bf00000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000003c000000 - 0000000040000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f2000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> [    0.000000] DMI 2.4 present.
> [    0.000000] last_pfn = 0x3bef0 max_arch_pfn = 0x1000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-C7FFF write-protect
> [    0.000000]   C8000-EFFFF uncachable
> [    0.000000]   F0000-FFFFF write-through
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0000000000 mask FFE0000000 write-back
> [    0.000000]   1 base 0020000000 mask FFF0000000 write-back
> [    0.000000]   2 base 0030000000 mask FFF8000000 write-back
> [    0.000000]   3 base 0038000000 mask FFFC000000 write-back
> [    0.000000]   4 base 003BF00000 mask FFFFF00000 uncachable
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] initial memory mapped : 0 - 00e00000
> [    0.000000] init_memory_mapping: 0000000000000000-00000000379fe000
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000]  0000000000 - 0000200000 page 4k
> [    0.000000]  0000200000 - 0037800000 page 2M
> [    0.000000]  0037800000 - 00379fe000 page 4k
> [    0.000000] kernel direct mapping tables up to 379fe000 @ 7000-d000
> [    0.000000] RAMDISK: 37c1d000 - 37fef20d
> [    0.000000] Allocated new RAMDISK: 00a33000 - 00e0520d
> [    0.000000] Move RAMDISK from 0000000037c1d000 - 0000000037fef20c to 00a33000 - 00e0520c
> [    0.000000] ACPI: RSDP 000f6340 00014 (v00 GBT   )
> [    0.000000] ACPI: RSDT 3bef3000 00038 (v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
> [    0.000000] ACPI: FACP 3bef3040 00074 (v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
> [    0.000000] ACPI: DSDT 3bef30c0 05272 (v01 GBT    NVDAACPI 00001000 MSFT 03000000)
> [    0.000000] ACPI: FACS 3bef1800 00040
> [    0.000000] ACPI: SSDT 3bef8400 0028A (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
> [    0.000000] ACPI: HPET 3bef86c0 00038 (v01 GBT    NVDAACPI 42302E31 NVDA 00000098)
> [    0.000000] ACPI: MCFG 3bef8700 0003C (v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
> [    0.000000] ACPI: APIC 3bef8340 0008E (v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] 68MB HIGHMEM available.
> [    0.000000] 889MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 379fe000
> [    0.000000]   low ram: 0 - 379fe000
> [    0.000000]   node 0 low ram: 00000000 - 379fe000
> [    0.000000]   node 0 bootmap 00009000 - 0000ff40
> [    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00379fe000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
> [    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
> [    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
> [    0.000000]   #3 [0000200000 - 0000a2a224]    TEXT DATA BSS ==> [0000200000 - 0000a2a224]
> [    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved ==> [000009f400 - 0000100000]
> [    0.000000]   #5 [0000a2b000 - 0000a320f6]              BRK ==> [0000a2b000 - 0000a320f6]
> [    0.000000]   #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
> [    0.000000]   #7 [0000a33000 - 0000e0520d]      NEW RAMDISK ==> [0000a33000 - 0000e0520d]
> [    0.000000]   #8 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 0000010000]
> [    0.000000] found SMP MP-table at [c00f4970] f4970
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000000 -> 0x00001000
> [    0.000000]   Normal   0x00001000 -> 0x000379fe
> [    0.000000]   HighMem  0x000379fe -> 0x0003bef0
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[2] active PFN ranges
> [    0.000000]     0: 0x00000000 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x0003bef0
> [    0.000000] On node 0 totalpages: 245391
> [    0.000000] free_area_init_node: node 0, pgdat c04ddb80, node_mem_map c1000000
> [    0.000000]   DMA zone: 52 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3947 pages, LIFO batch:0
> [    0.000000]   Normal zone: 2841 pages used for memmap
> [    0.000000]   Normal zone: 220901 pages, LIFO batch:31
> [    0.000000]   HighMem zone: 225 pages used for memmap
> [    0.000000]   HighMem zone: 17425 pages, LIFO batch:3
> [    0.000000] Using APIC driver default
> [    0.000000] Detected use of extended apic ids on hypertransport bus
> [    0.000000] ACPI: PM-Timer IO Port: 0x1008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ14 used by override.
> [    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfeff0000
> [    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 24
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
> [    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
> [    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:b0000000)
> [    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 13 pages at c1c3b000, static data 30468 bytes
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 242273
> [    0.000000] Kernel command line: root=/dev/mapper/vglinux1-lv_ubuntu2 ro locale=fr_FR vga=795 resume=/dev/mapper/vglinux1-lvswap 
> [    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Enabling fast FPU save and restore... done.
> [    0.000000] Enabling unmasked SIMD FPU exception support... done.
> [    0.000000] Initializing CPU#0
> [    0.000000] Initializing HighMem for node 0 (000379fe:0003bef0)
> [    0.000000] Memory: 955460k/981952k available (1902k kernel code, 25868k reserved, 1068k data, 304k init, 70600k highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xfff1e000 - 0xfffff000   ( 900 kB)
> [    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
> [    0.000000]     vmalloc : 0xf81fe000 - 0xff9fe000   ( 120 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xf79fe000   ( 889 MB)
> [    0.000000]       .init : 0xc04eb000 - 0xc0537000   ( 304 kB)
> [    0.000000]       .data : 0xc03db869 - 0xc04e68b0   (1068 kB)
> [    0.000000]       .text : 0xc0200000 - 0xc03db869   (1902 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] Preemptible RCU implementation.
> [    0.000000] NR_IRQS:2304 nr_irqs:440
> [    0.000000] CPU 0 irqstacks, hard=c1c3b000 soft=c1c3c000
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2599.813 MHz processor.
> [    0.000035] spurious 8259A interrupt: IRQ7.
> [    0.000355] Console: colour dummy device 80x25
> [    0.000369] console [tty0] enabled
> [    0.001303] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.001315] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.001323] ... MAX_LOCK_DEPTH:          48
> [    0.001331] ... MAX_LOCKDEP_KEYS:        8191
> [    0.001338] ... CLASSHASH_SIZE:          4096
> [    0.001345] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.001353] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.001361] ... CHAINHASH_SIZE:          16384
> [    0.001369]  memory used by lock dependency info: 3487 kB
> [    0.001378]  per task-struct memory footprint: 1152 bytes
> [    0.001427] kmemleak: Early log buffer exceeded
> [    0.001435] kmemleak: Kernel memory leak detector disabled
> [    0.001684] hpet clockevent registered
> [    0.001693] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    0.001709] Calibrating delay loop (skipped), value calculated using timer frequency.. 5199.62 BogoMIPS (lpj=10399252)
> [    0.001967] Mount-cache hash table entries: 512
> [    0.002854] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.002867] CPU: L2 Cache: 512K (64 bytes/line)
> [    0.002876] CPU: Physical Processor ID: 0
> [    0.002883] CPU: Processor Core ID: 0
> [    0.002892] mce: CPU supports 5 MCE banks
> [    0.002907] using C1E aware idle routine
> [    0.002929] Checking 'hlt' instruction... OK.
> [    0.016697] ACPI: Core revision 20090521
> [    0.028585] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.069489] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
> [    0.072001] lockdep: fixing up alternatives.
> [    0.072001] CPU 1 irqstacks, hard=c1c4b000 soft=c1c4c000
> [    0.072001] Booting processor 1 APIC 0x1 ip 0x6000
> [    0.004000] Initializing CPU#1
> [    0.004000] Calibrating delay using timer specific routine.. 5200.05 BogoMIPS (lpj=10400112)
> [    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
> [    0.004000] CPU: Physical Processor ID: 0
> [    0.004000] CPU: Processor Core ID: 1
> [    0.004000] mce: CPU supports 5 MCE banks
> [    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
> [    0.156555] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
> [    0.156680] Brought up 2 CPUs
> [    0.156686] Total of 2 processors activated (10399.68 BogoMIPS).
> [    0.156857] khelper used greatest stack depth: 2964 bytes left
> [    0.156857] Booting paravirtualized kernel on bare hardware
> [    0.156857] NET: Registered protocol family 16
> [    0.156857] khelper used greatest stack depth: 2728 bytes left
> [    0.160066] ACPI: bus type pci registered
> [    0.160099] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 31
> [    0.160099] PCI: MCFG area at f0000000 reserved in E820
> [    0.160099] PCI: Using MMCONFIG for extended config space
> [    0.160103] PCI: Using configuration type 1 for base access
> [    0.164234] bio: create slab <bio-0> at 0
> [    0.168811] ACPI: EC: Look up EC in DSDT
> [    0.183271] ACPI: Interpreter enabled
> [    0.183284] ACPI: (supports S0 S3 S4 S5)
> [    0.183359] ACPI: Using IOAPIC for interrupt routing
> [    0.204444] ACPI: No dock devices found.
> [    0.204591] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.204718] pci 0000:00:01.1: reg 10 io port: [0xc800-0xc83f]
> [    0.204718] pci 0000:00:01.1: reg 20 io port: [0x1c00-0x1c3f]
> [    0.204718] pci 0000:00:01.1: reg 24 io port: [0x1c40-0x1c7f]
> [    0.204718] pci 0000:00:01.1: PME# supported from D3hot D3cold
> [    0.204718] pci 0000:00:01.1: PME# disabled
> [    0.204718] pci 0000:00:02.0: reg 10 32bit mmio: [0xf700a000-0xf700afff]
> [    0.204718] pci 0000:00:02.0: supports D1 D2
> [    0.204718] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.204718] pci 0000:00:02.0: PME# disabled
> [    0.204718] pci 0000:00:02.1: reg 10 32bit mmio: [0xf700b000-0xf700b0ff]
> [    0.204718] pci 0000:00:02.1: supports D1 D2
> [    0.204718] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.204718] pci 0000:00:02.1: PME# disabled
> [    0.204718] pci 0000:00:04.0: reg 10 32bit mmio: [0xf700c000-0xf700cfff]
> [    0.204718] pci 0000:00:04.0: supports D1 D2
> [    0.204718] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.204718] pci 0000:00:04.0: PME# disabled
> [    0.204739] pci 0000:00:04.1: reg 10 32bit mmio: [0xf7009000-0xf70090ff]
> [    0.204777] pci 0000:00:04.1: supports D1 D2
> [    0.204780] pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.204791] pci 0000:00:04.1: PME# disabled
> [    0.204845] pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
> [    0.204900] pci 0000:00:07.0: reg 10 32bit mmio: [0xf7000000-0xf7003fff]
> [    0.204939] pci 0000:00:07.0: PME# supported from D3hot D3cold
> [    0.204950] pci 0000:00:07.0: PME# disabled
> [    0.205047] pci 0000:00:09.0: reg 10 io port: [0x9f0-0x9f7]
> [    0.205052] pci 0000:00:09.0: reg 14 io port: [0xbf0-0xbf3]
> [    0.205057] pci 0000:00:09.0: reg 18 io port: [0x970-0x977]
> [    0.205062] pci 0000:00:09.0: reg 1c io port: [0xb70-0xb73]
> [    0.205067] pci 0000:00:09.0: reg 20 io port: [0xdc00-0xdc0f]
> [    0.205072] pci 0000:00:09.0: reg 24 32bit mmio: [0xf7004000-0xf7005fff]
> [    0.205140] pci 0000:00:0a.0: reg 10 32bit mmio: [0xf7006000-0xf7006fff]
> [    0.205145] pci 0000:00:0a.0: reg 14 io port: [0xe000-0xe007]
> [    0.205150] pci 0000:00:0a.0: reg 18 32bit mmio: [0xf7007000-0xf70070ff]
> [    0.205156] pci 0000:00:0a.0: reg 1c 32bit mmio: [0xf7008000-0xf700800f]
> [    0.205185] pci 0000:00:0a.0: supports D1 D2
> [    0.205187] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.205200] pci 0000:00:0a.0: PME# disabled
> [    0.205252] pci 0000:00:12.0: reg 10 32bit mmio: [0xf2000000-0xf2ffffff]
> [    0.205259] pci 0000:00:12.0: reg 14 64bit mmio: [0xe0000000-0xefffffff]
> [    0.205266] pci 0000:00:12.0: reg 1c 64bit mmio: [0xf5000000-0xf5ffffff]
> [    0.205273] pci 0000:00:12.0: reg 30 32bit mmio: [0x000000-0x01ffff]
> [    0.205472] pci 0000:01:07.0: reg 10 io port: [0xa000-0xa007]
> [    0.205479] pci 0000:01:07.0: reg 14 io port: [0xa400-0xa403]
> [    0.205485] pci 0000:01:07.0: reg 18 io port: [0xa800-0xa807]
> [    0.205492] pci 0000:01:07.0: reg 1c io port: [0xac00-0xac03]
> [    0.205499] pci 0000:01:07.0: reg 20 io port: [0xb000-0xb00f]
> [    0.205506] pci 0000:01:07.0: reg 24 32bit mmio: [0xf4000000-0xf40000ff]
> [    0.205512] pci 0000:01:07.0: reg 30 32bit mmio: [0x000000-0x07ffff]
> [    0.205530] pci 0000:01:07.0: supports D1 D2
> [    0.205567] pci 0000:00:08.0: transparent bridge
> [    0.205577] pci 0000:00:08.0: bridge io port: [0xa000-0xbfff]
> [    0.205581] pci 0000:00:08.0: bridge 32bit mmio: [0xf3000000-0xf4ffffff]
> [    0.205589] pci_bus 0000:00: on NUMA node 0
> [    0.205595] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.206297] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
> [    0.272452] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> [    0.272452] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 *10 11 14 15)
> [    0.272616] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> [    0.272807] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> [    0.272998] ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> [    0.273190] ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> [    0.273397] ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> [    0.273588] ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> [    0.273779] ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> [    0.273974] ACPI: PCI Interrupt Link [LIGP] (IRQs 5 7 9 10 *11 14 15)
> [    0.274165] ACPI: PCI Interrupt Link [LUBA] (IRQs *5 7 9 10 11 14 15)
> [    0.274355] ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 9 *10 11 14 15)
> [    0.274546] ACPI: PCI Interrupt Link [LU1B] (IRQs 5 7 9 10 *11 14 15)
> [    0.274737] ACPI: PCI Interrupt Link [LU2B] (IRQs *5 7 9 10 11 14 15)
> [    0.274928] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 10 11 14 *15)
> [    0.276016] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 *10 11 14 15)
> [    0.276205] ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> [    0.276399] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 10 *11 14 15)
> [    0.276586] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
> [    0.276781] ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 10 *11 14 15)
> [    0.277070] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
> [    0.277350] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
> [    0.277628] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
> [    0.277913] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
> [    0.278192] ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
> [    0.278472] ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
> [    0.278750] ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0, disabled.
> [    0.279030] ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
> [    0.279309] ACPI: PCI Interrupt Link [AIGP] (IRQs 20 21 22 23) *0
> [    0.279591] ACPI: PCI Interrupt Link [AUBA] (IRQs 20 21 22 23) *0
> [    0.279871] ACPI: PCI Interrupt Link [AUB2] (IRQs 20 21 22 23) *0
> [    0.280171] ACPI: PCI Interrupt Link [AU1B] (IRQs 20 21 22 23) *0
> [    0.280452] ACPI: PCI Interrupt Link [AU2B] (IRQs 20 21 22 23) *0
> [    0.280734] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
> [    0.281014] ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
> [    0.281297] ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
> [    0.281577] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
> [    0.281858] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
> [    0.282141] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
> [    0.282425] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
> [    0.282516] PCI: Using ACPI for IRQ routing
> [    0.316046] hpet0: at MMIO 0xfeff0000, IRQs 2, 8, 31
> [    0.316060] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
> [    0.324022] Switched to NOHz mode on CPU #0
> [    0.324674] Switched to NOHz mode on CPU #1
> [    0.352033] pnp: PnP ACPI init
> [    0.352071] ACPI: bus type pnp registered
> [    0.360028] pnp: PnP ACPI: found 14 devices
> [    0.360038] ACPI: ACPI bus type pnp unregistered
> [    0.360061] system 00:01: ioport range 0x1000-0x107f has been reserved
> [    0.360073] system 00:01: ioport range 0x1080-0x10ff has been reserved
> [    0.360084] system 00:01: ioport range 0x1400-0x147f has been reserved
> [    0.360096] system 00:01: ioport range 0x1480-0x14ff has been reserved
> [    0.360108] system 00:01: ioport range 0x1800-0x187f has been reserved
> [    0.360119] system 00:01: ioport range 0x1880-0x18ff has been reserved
> [    0.360132] system 00:01: iomem range 0xfefe0000-0xfefe01ff has been reserved
> [    0.360144] system 00:01: iomem range 0xfefe1000-0xfefe10ff has been reserved
> [    0.360157] system 00:01: iomem range 0x3c000000-0x3fffffff has been reserved
> [    0.360177] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
> [    0.360188] system 00:02: ioport range 0x800-0x87f has been reserved
> [    0.360199] system 00:02: ioport range 0x295-0x314 has been reserved
> [    0.360211] system 00:02: ioport range 0x290-0x294 has been reserved
> [    0.360232] system 00:0c: iomem range 0xf0000000-0xf1ffffff has been reserved
> [    0.360250] system 00:0d: iomem range 0xd4600-0xd7fff has been reserved
> [    0.360262] system 00:0d: iomem range 0xf0000-0xf7fff could not be reserved
> [    0.360274] system 00:0d: iomem range 0xf8000-0xfbfff could not be reserved
> [    0.360287] system 00:0d: iomem range 0xfc000-0xfffff could not be reserved
> [    0.360299] system 00:0d: iomem range 0x3bef0000-0x3befffff could not be reserved
> [    0.360312] system 00:0d: iomem range 0xffff0000-0xffffffff has been reserved
> [    0.360325] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
> [    0.360337] system 00:0d: iomem range 0x100000-0x3beeffff could not be reserved
> [    0.360350] system 00:0d: iomem range 0xfec00000-0xfec00fff could not be reserved
> [    0.360364] system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
> [    0.396174] pci 0000:00:08.0: PCI bridge, secondary bus 0000:01
> [    0.396184] pci 0000:00:08.0:   IO window: 0xa000-0xbfff
> [    0.396195] pci 0000:00:08.0:   MEM window: 0xf3000000-0xf4ffffff
> [    0.396207] pci 0000:00:08.0:   PREFETCH window: 0x40000000-0x400fffff
> [    0.396225] pci 0000:00:08.0: setting latency timer to 64
> [    0.396230] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
> [    0.396233] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
> [    0.396236] pci_bus 0000:01: resource 0 io:  [0xa000-0xbfff]
> [    0.396238] pci_bus 0000:01: resource 1 mem: [0xf3000000-0xf4ffffff]
> [    0.396241] pci_bus 0000:01: resource 2 pref mem [0x40000000-0x400fffff]
> [    0.396244] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
> [    0.396246] pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]
> [    0.396386] NET: Registered protocol family 2
> [    0.396636] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.397410] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.398232] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
> [    0.402685] TCP: Hash tables configured (established 131072 bind 65536)
> [    0.402735] TCP reno registered
> [    0.402981] NET: Registered protocol family 1
> [    0.403433] Unpacking initramfs...
> [    0.530861] Freeing initrd memory: 3912k freed
> [    0.537695] highmem bounce pool size: 64 pages
> [    0.540410] msgmni has been set to 1736
> [    0.540973] alg: No test for stdrng (krng)
> [    0.541021] io scheduler noop registered
> [    0.541032] io scheduler anticipatory registered
> [    0.541040] io scheduler deadline registered
> [    0.541084] io scheduler cfq registered (default)
> [    0.541288] pci 0000:00:00.0: Found enabled HT MSI Mapping
> [    0.541363] pci 0000:00:00.0: Found enabled HT MSI Mapping
> [    0.541448] pci 0000:00:00.0: Found enabled HT MSI Mapping
> [    0.541541] pci 0000:00:00.0: Found enabled HT MSI Mapping
> [    0.541557] pci 0000:00:12.0: Boot video device
> [    0.542847] vesafb: framebuffer at 0xe0000000, mapped to 0xf8280000, using 10240k, total 65536k
> [    0.542860] vesafb: mode is 1280x1024x32, linelength=5120, pages=0
> [    0.542870] vesafb: protected mode interface info at c000:cfb0
> [    0.542880] vesafb: pmi: set display start = c00ccfe6, set palette = c00cd050
> [    0.542891] vesafb: pmi: ports = b4c3 b503 ba03 c003 c103 c403 c503 c603 c703 c803 c903 cc03 ce03 cf03 d003 d103 d203 d303 d403 d503 da03 ff03 
> [    0.542931] vesafb: scrolling: redraw
> [    0.542939] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
> [    0.567384] Console: switching to colour frame buffer device 160x64
> [    0.589272] fb0: VESA VGA frame buffer device
> [    0.605509] Linux agpgart interface v0.103
> [    0.606169] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> [    0.606340] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
> [    0.606649] Platform driver 'i8042' needs updating - please use dev_pm_ops
> [    0.607127] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.607824] mice: PS/2 mouse device common for all mice
> [    0.608480] cpuidle: using governor ladder
> [    0.608595] cpuidle: using governor menu
> [    0.609217] TCP cubic registered
> [    0.609333] Using IPI No-Shortcut mode
> [    0.628179] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> [    0.628840] BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
> [    0.629547] Freeing unused kernel memory: 304k freed
> [    0.630044] Write protecting the kernel text: 1904k
> [    0.630254] Write protecting the kernel read-only data: 904k
> [    0.650339] all_generic_ide used greatest stack depth: 2696 bytes left
> [    0.702111] setfont used greatest stack depth: 2364 bytes left
> [    0.776645] device-mapper: uevent: version 1.0.3
> [    0.777042] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
> [    0.797742] SCSI subsystem initialized
> [    0.810945] libata version 3.00 loaded.
> [    0.812808] pata_amd 0000:00:06.0: version 0.4.1
> [    0.812993] pata_amd 0000:00:06.0: setting latency timer to 64
> [    0.813142] scsi0 : pata_amd
> [    0.813766] scsi1 : pata_amd
> [    0.815336] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
> [    0.815530] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
> [    0.984468] ata1.00: HPA detected: current 78163247, native 78165360
> [    0.984654] ata1.00: ATA-5: ST340016A, 3.75, max UDMA/100
> [    0.984804] ata1.00: 78163247 sectors, multi 16: LBA 
> [    0.984971] ata1.01: ATAPI: HL-DT-ST DVDRAM GSA-4165B, DL05, max UDMA/33
> [    0.985176] ata1: nv_mode_filter: 0x3f39f&0x3f01f->0x3f01f, BIOS=0x3f000 (0xc6c00000) ACPI=0x3f01f (20:60:0x1f)
> [    0.985181] ata1: nv_mode_filter: 0x739f&0x701f->0x701f, BIOS=0x7000 (0xc6c00000) ACPI=0x701f (20:60:0x1f)
> [    1.000405] ata1.00: configured for UDMA/100
> [    1.016243] ata1.01: configured for UDMA/33
> [    1.019216] scsi 0:0:0:0: Direct-Access     ATA      ST340016A        3.75 PQ: 0 ANSI: 5
> [    1.030276] scsi 0:0:1:0: CD-ROM            HL-DT-ST DVDRAM GSA-4165B DL05 PQ: 0 ANSI: 5
> [    1.037494] ata2: port disabled. ignoring.
> [    1.037611] modprobe used greatest stack depth: 2316 bytes left
> [    1.049124] pata_sil680 0000:01:07.0: version 0.4.9
> [    1.049662] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
> [    1.056681]   alloc irq_desc for 17 on node -1
> [    1.056684]   alloc kstat_irqs on node -1
> [    1.056694] pata_sil680 0000:01:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
> [    1.063889] sil680: 133MHz clock.
> [    1.071309] scsi2 : pata_sil680
> [    1.078820] scsi3 : pata_sil680
> [    1.086103] ata3: PATA max UDMA/133 cmd 0xa000 ctl 0xa400 bmdma 0xb000 irq 17
> [    1.093378] ata4: PATA max UDMA/133 cmd 0xa800 ctl 0xac00 bmdma 0xb008 irq 17
> [    1.272510] ata3.01: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
> [    1.279687] ata3.01: 160086528 sectors, multi 16: LBA 
> [    1.300389] ata3.01: configured for UDMA/133
> [    1.307760] scsi 2:0:1:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
> [    1.530325] ata4.01: ATA-7: MAXTOR STM3802110A, 3.AAJ, max UDMA/100
> [    1.537813] ata4.01: 156301488 sectors, multi 16: LBA48 
> [    1.605149] ata4.01: configured for UDMA/100
> [    1.628136] scsi 3:0:1:0: Direct-Access     ATA      MAXTOR STM380211 3.AA PQ: 0 ANSI: 5
> [    1.642568] sd 0:0:0:0: [sda] 78163247 512-byte logical blocks: (40.0 GB/37.2 GiB)
> [    1.650477] sd 0:0:0:0: [sda] Write Protect is off
> [    1.658358] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.658399] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.666833]  sda:
> [    1.667297] sd 2:0:1:0: [sdb] 160086528 512-byte logical blocks: (81.9 GB/76.3 GiB)
> [    1.681593]  sda1 sda2 sda3 <
> [    1.683170] sd 2:0:1:0: [sdb] Write Protect is off
> [    1.692125]  sda5
> [    1.698980] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> [    1.706771] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.711948]  sda6 sda7 >
> [    1.722957]  sdb:
> [    1.723281] sd 3:0:1:0: [sdc] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
> [    1.726805]  sdb1 sdb2 <
> [    1.739230] sd 3:0:1:0: [sdc] Write Protect is off
> [    1.741025] sd 0:0:0:0: [sda] Attached SCSI disk
> [    1.743611]  sdb5 sdb6 >
> [    1.770620] sd 3:0:1:0: [sdc] Mode Sense: 00 3a 00 00
> [    1.770664] sd 3:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.771412] sd 2:0:1:0: [sdb] Attached SCSI disk
> [    1.786574]  sdc: sdc1 sdc2 < sdc5 >
> [    1.826821] sd 3:0:1:0: [sdc] Attached SCSI disk
> [    1.857553] fuse init (API version 7.12)
> [    1.893007] md: linear personality registered for level -1
> [    1.907682] md: raid0 personality registered for level 0
> [    1.920615] md: raid1 personality registered for level 1
> [    1.941772] md: raid10 personality registered for level 10
> [    2.136927] scsi_id used greatest stack depth: 2228 bytes left
> [    2.157047] scsi_id used greatest stack depth: 2192 bytes left
> [    2.254433] vol_id used greatest stack depth: 2116 bytes left
> [    2.443896] md: bind<sdc5>
> [    2.550107] md: bind<sdb6>
> [    2.607666] raid1: raid set md127 active with 2 out of 2 mirrors
> [    2.630132] md127: bitmap initialized from disk: read 11/11 pages, set 532 bits
> [    2.632911] md: bind<sdc1>
> [    2.645769] created bitmap (161 pages) for device md127
> [    2.679534] mdadm used greatest stack depth: 1964 bytes left
> [    2.690216]  md127: unknown partition table
> [    2.866970] md: bind<sda1>
> [    2.885029] raid1: raid set md0 active with 2 out of 2 mirrors
> [    2.905003] md0: bitmap initialized from disk: read 1/1 pages, set 2 bits
> [    2.912574] created bitmap (6 pages) for device md0
> [    2.945103]  md0:
> [   10.536943] EXT3-fs: mounted filesystem with writeback data mode.
> [   10.544270] kjournald starting.  Commit interval 5 seconds
> [   12.238787] grep used greatest stack depth: 1940 bytes left
> [   22.423153] udev: starting version 141
> [   22.686495] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
> [   22.706567] rtc_cmos 00:05: RTC can wake from S4
> [   22.712983] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
> [   22.719268] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
> [   22.755912] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
> [   22.763246] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
> [   22.772829]   alloc irq_desc for 23 on node -1
> [   22.772832]   alloc kstat_irqs on node -1
> [   22.772867] forcedeth 0000:00:0a.0: PCI INT A -> Link[APCH] -> GSI 23 (level, low) -> IRQ 23
> [   22.778250] input: PC Speaker as /devices/platform/pcspkr/input/input1
> [   22.785706] forcedeth 0000:00:0a.0: setting latency timer to 64
> [   22.788623] parport_pc 00:0a: reported by Plug and Play ACPI
> [   22.796190] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
> [   22.813139] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [   22.820321] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [   22.823722] Platform driver 'floppy' needs updating - please use dev_pm_ops
> [   22.823871] Floppy drive(s): fd0 is 1.44M
> [   22.828293] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [   22.828365] scsi 0:0:1:0: Attached scsi generic sg1 type 5
> [   22.828438] sd 2:0:1:0: Attached scsi generic sg2 type 0
> [   22.828509] sd 3:0:1:0: Attached scsi generic sg3 type 0
> [   22.838074] processor LNXCPU:00: registered as cooling_device0
> [   22.838196] processor LNXCPU:01: registered as cooling_device1
> [   22.848080] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> [   22.848170] ACPI: Power Button [PWRF]
> [   22.848321] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
> [   22.848435] ACPI: Power Button [PWRB]
> [   22.867749] usbcore: registered new interface driver usbfs
> [   22.867913] usbcore: registered new interface driver hub
> [   22.879118] usbcore: registered new device driver usb
> [   22.880660] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [   22.941558] FDC 0 is a post-1991 82077
> [   22.992672] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
> [   22.999570] Uniform CD-ROM driver Revision: 3.20
> [   23.006898] sr 0:0:1:0: Attached scsi CD-ROM sr0
> [   23.112007] Platform driver 'serial8250' needs updating - please use dev_pm_ops
> [   23.209664] cdrom_id used greatest stack depth: 1864 bytes left
> [   23.306737] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:1f:d0:53:49:ae
> [   23.313735] forcedeth 0000:00:0a.0: highdma pwrctl mgmt gbit lnktim msi desc-v3
> [   23.321262] ahci 0000:00:09.0: version 3.0
> [   23.321831] ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
> [   23.329158]   alloc irq_desc for 22 on node -1
> [   23.329161]   alloc kstat_irqs on node -1
> [   23.329170] ahci 0000:00:09.0: PCI INT A -> Link[APSI] -> GSI 22 (level, low) -> IRQ 22
> [   23.338717]   alloc irq_desc for 24 on node -1
> [   23.338722]   alloc kstat_irqs on node -1
> [   23.338734] ahci 0000:00:09.0: irq 24 for MSI/MSI-X
> [   23.339084] ahci 0000:00:09.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
> [   23.347538] ahci 0000:00:09.0: flags: 64bit ncq sntf led clo pmp pio 
> [   23.354899] ahci 0000:00:09.0: setting latency timer to 64
> [   23.356478] scsi4 : ahci
> [   23.364024] scsi5 : ahci
> [   23.371924] scsi6 : ahci
> [   23.379699] scsi7 : ahci
> [   23.387279] ata5: SATA max UDMA/133 abar m8192@0xf7004000 port 0xf7004100 irq 24
> [   23.395361] ata6: SATA max UDMA/133 abar m8192@0xf7004000 port 0xf7004180 irq 24
> [   23.402519] ata7: SATA max UDMA/133 abar m8192@0xf7004000 port 0xf7004200 irq 24
> [   23.409747] ata8: SATA max UDMA/133 abar m8192@0xf7004000 port 0xf7004280 irq 24
> [   23.418300] ACPI: PCI Interrupt Link [AUB2] enabled at IRQ 21
> [   23.425678]   alloc irq_desc for 21 on node -1
> [   23.425682]   alloc kstat_irqs on node -1
> [   23.425695] ehci_hcd 0000:00:02.1: PCI INT B -> Link[AUB2] -> GSI 21 (level, low) -> IRQ 21
> [   23.432915] ehci_hcd 0000:00:02.1: setting latency timer to 64
> [   23.432919] ehci_hcd 0000:00:02.1: EHCI Host Controller
> [   23.440889] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
> [   23.448296] ehci_hcd 0000:00:02.1: debug port 1
> [   23.455482] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
> [   23.455511] ehci_hcd 0000:00:02.1: irq 21, io mem 0xf700b000
> [   23.473493] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
> [   23.481934] usb usb1: configuration #1 chosen from 1 choice
> [   23.489678] hub 1-0:1.0: USB hub found
> [   23.496960] hub 1-0:1.0: 5 ports detected
> [   23.505768] ACPI: PCI Interrupt Link [AU2B] disabled and referenced, BIOS bug
> [   23.513842] ACPI: PCI Interrupt Link [AU2B] enabled at IRQ 20
> [   23.521351]   alloc irq_desc for 20 on node -1
> [   23.521354]   alloc kstat_irqs on node -1
> [   23.521364] ehci_hcd 0000:00:04.1: PCI INT B -> Link[AU2B] -> GSI 20 (level, low) -> IRQ 20
> [   23.529152] ehci_hcd 0000:00:04.1: setting latency timer to 64
> [   23.529156] ehci_hcd 0000:00:04.1: EHCI Host Controller
> [   23.536893] ehci_hcd 0000:00:04.1: new USB bus registered, assigned bus number 2
> [   23.544656] ehci_hcd 0000:00:04.1: debug port 1
> [   23.552592] ehci_hcd 0000:00:04.1: cache line size of 64 is not supported
> [   23.552625] ehci_hcd 0000:00:04.1: irq 20, io mem 0xf7009000
> [   23.569481] ehci_hcd 0000:00:04.1: USB 2.0 started, EHCI 1.00
> [   23.577225] usb usb2: configuration #1 chosen from 1 choice
> [   23.584970] hub 2-0:1.0: USB hub found
> [   23.592576] hub 2-0:1.0: 5 ports detected
> [   23.646352] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [   23.655063] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [   23.663122] ACPI: PCI Interrupt Link [AUBA] enabled at IRQ 23
> [   23.670777] ohci_hcd 0000:00:02.0: PCI INT A -> Link[AUBA] -> GSI 23 (level, low) -> IRQ 23
> [   23.678337] ohci_hcd 0000:00:02.0: setting latency timer to 64
> [   23.678341] ohci_hcd 0000:00:02.0: OHCI Host Controller
> [   23.685726] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 3
> [   23.693131] ohci_hcd 0000:00:02.0: irq 23, io mem 0xf700a000
> [   23.755955] usb usb3: configuration #1 chosen from 1 choice
> [   23.763433] hub 3-0:1.0: USB hub found
> [   23.771986] hub 3-0:1.0: 5 ports detected
> [   23.779153] ata5: SATA link down (SStatus 0 SControl 300)
> [   23.786605] ata7: SATA link down (SStatus 0 SControl 300)
> [   23.789630] ata8: SATA link down (SStatus 0 SControl 300)
> [   23.801313] ata6: SATA link down (SStatus 0 SControl 300)
> [   23.809515] ACPI: PCI Interrupt Link [AU1B] enabled at IRQ 22
> [   23.812522]   alloc irq_desc for 25 on node -1
> [   23.812527]   alloc kstat_irqs on node -1
> [   23.812568] forcedeth 0000:00:0a.0: irq 25 for MSI/MSI-X
> [   23.812928] eth0: no link during initialization.
> [   23.823945] ohci_hcd 0000:00:04.0: PCI INT A -> Link[AU1B] -> GSI 22 (level, low) -> IRQ 22
> [   23.832197] ohci_hcd 0000:00:04.0: setting latency timer to 64
> [   23.832203] ohci_hcd 0000:00:04.0: OHCI Host Controller
> [   23.839353] ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus number 4
> [   23.846445] ohci_hcd 0000:00:04.0: irq 22, io mem 0xf700c000
> [   23.907804] usb usb4: configuration #1 chosen from 1 choice
> [   23.915151] hub 4-0:1.0: USB hub found
> [   23.922263] hub 4-0:1.0: 5 ports detected
> [   23.953366] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 21
> [   23.960892] HDA Intel 0000:00:07.0: PCI INT A -> Link[AAZA] -> GSI 21 (level, low) -> IRQ 21
> [   23.968338] HDA Intel 0000:00:07.0: setting latency timer to 64
> [   23.969530] usb 2-2: new high speed USB device using ehci_hcd and address 3
> [   24.110044] usb 2-2: configuration #1 chosen from 1 choice
> [   24.117472] hub 2-2:1.0: USB hub found
> [   24.125597] hub 2-2:1.0: 4 ports detected
> [   24.212352] NET: Registered protocol family 10
> [   24.222910] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   24.309529] usb 4-1: new low speed USB device using ohci_hcd and address 2
> [   24.455200] eth0: link up.
> [   24.462407] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   24.528776] usb 4-1: configuration #1 chosen from 1 choice
> [   24.610604] usb 2-2.4: new full speed USB device using ehci_hcd and address 4
> [   24.714771] usb 2-2.4: configuration #1 chosen from 1 choice
> [   24.726185] input: PS/2+USB Mouse as /devices/pci0000:00/0000:00:04.0/usb4/4-1/4-1:1.0/input/input4
> [   24.733663] generic-usb 0003:04F3:0210.0001: input: USB HID v1.11 Mouse [PS/2+USB Mouse] on usb-0000:00:04.0-1/input0
> [   24.741230] usbcore: registered new interface driver usbhid
> [   24.748709] usbhid: v2.6:USB HID core driver
> [   24.787900] usbcore: registered new interface driver usbserial
> [   24.796102] usbserial: USB Serial Driver core
> [   24.812633] USB Serial support registered for pl2303
> [   24.820232] pl2303 2-2.4:1.0: pl2303 converter detected
> [   24.832373] usb 2-2.4: pl2303 converter now attached to ttyUSB0
> [   24.840047] usbcore: registered new interface driver pl2303
> [   24.847650] pl2303: Prolific PL2303 USB to serial adaptor driver
> [   25.251987] it87: Found IT8716F chip at 0x290, revision 3
> [   26.214910] EXT3 FS on dm-5, internal journal
> [   27.098375] kjournald starting.  Commit interval 5 seconds
> [   27.149517] EXT3 FS on md0, internal journal
> [   27.149529] EXT3-fs: mounted filesystem with writeback data mode.
> [   27.242858] REISERFS (device dm-0): found reiserfs format "3.6" with standard journal
> [   27.242974] REISERFS (device dm-0): using ordered data mode
> [   27.248134] REISERFS (device dm-0): journal params: device dm-0, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> [   27.248804] REISERFS (device dm-0): checking transaction log (dm-0)
> [   27.388800] REISERFS (device dm-0): Using r5 hash to sort names
> [   27.706662] kjournald starting.  Commit interval 5 seconds
> [   27.706675] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
> [   27.811221] EXT3 FS on dm-10, internal journal
> [   27.811231] EXT3-fs: mounted filesystem with writeback data mode.
> [   27.895472] REISERFS (device sda6): found reiserfs format "3.6" with standard journal
> [   27.895548] REISERFS (device sda6): using ordered data mode
> [   27.903754] REISERFS (device sda6): journal params: device sda6, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> [   27.904373] REISERFS (device sda6): checking transaction log (sda6)
> [   27.933186] REISERFS (device sda6): Using r5 hash to sort names
> [   28.309711] Unable to find swap-space signature
> [   28.878010] ttyS1: LSR safety check engaged!
> [   28.879270] ttyS1: LSR safety check engaged!
> [   31.208587] pktcdvd: writer pktcdvd0 mapped to sr0
> [   32.839497] ttyS1: LSR safety check engaged!
> [   33.549103] lp0: using parport0 (interrupt-driven).
> [   35.446212] eth0: no IPv6 routers present
> [   39.578996] aplay used greatest stack depth: 1604 bytes left
> [  224.539384] bash used greatest stack depth: 1464 bytes left
> [  244.015238] 
> [  244.015240] =======================================================
> [  244.015244] [ INFO: possible circular locking dependency detected ]
> [  244.015247] 2.6.31-rc4-00220-g46be1f8 #233
> [  244.015249] -------------------------------------------------------
> [  244.015251] gdm/3771 is trying to acquire lock:
> [  244.015253]  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<f9ec2066>] reiserfs_write_lock+0x1f/0x2e [reiserfs]
> [  244.015274] 
> [  244.015275] but task is already holding lock:
> [  244.015277]  (&sb->s_type->i_mutex_key#9/3){+.+.+.}, at: [<f9ec113b>] open_xa_dir+0xff/0x18a [reiserfs]
> [  244.015292] 
> [  244.015293] which lock already depends on the new lock.
> [  244.015294] 
> [  244.015296] 
> [  244.015296] the existing dependency chain (in reverse order) is:
> [  244.015298] 
> [  244.015299] -> #1 (&sb->s_type->i_mutex_key#9/3){+.+.+.}:
> [  244.015304]        [<c0245741>] __lock_acquire+0x98a/0xafa
> [  244.015310]        [<c0245904>] lock_acquire+0x53/0x75
> [  244.015313]        [<c03d9684>] __mutex_lock_common+0x3e/0x3ca
> [  244.015318]        [<c03d9a99>] mutex_lock_nested+0x29/0x31
> [  244.015321]        [<f9ec107f>] open_xa_dir+0x43/0x18a [reiserfs]
> [  244.015334]        [<f9ec17f9>] reiserfs_for_each_xattr+0x57/0x1df [reiserfs]
> [  244.015346]        [<f9ec19d4>] reiserfs_delete_xattrs+0x13/0x40 [reiserfs]
> [  244.015359]        [<f9ead3e0>] reiserfs_delete_inode+0x41/0xb9 [reiserfs]
> [  244.015370]        [<c028aa5d>] generic_delete_inode+0x79/0xf1
> [  244.015375]        [<c028aae7>] generic_drop_inode+0x12/0x18d
> [  244.015378]        [<c0289e3b>] iput+0x4b/0x4e
> [  244.015381]        [<c0284448>] do_unlinkat+0xc3/0x107
> [  244.015385]        [<c028449c>] sys_unlink+0x10/0x12
> [  244.015388]        [<c0203228>] sysenter_do_call+0x12/0x3c
> [  244.015392]        [<ffffffff>] 0xffffffff
> [  244.015413] 
> [  244.015414] -> #0 (&REISERFS_SB(s)->lock){+.+.+.}:
> [  244.015417]        [<c0245653>] __lock_acquire+0x89c/0xafa
> [  244.015421]        [<c0245904>] lock_acquire+0x53/0x75
> [  244.015424]        [<c03d9684>] __mutex_lock_common+0x3e/0x3ca
> [  244.015427]        [<c03d9a99>] mutex_lock_nested+0x29/0x31
> [  244.015431]        [<f9ec2066>] reiserfs_write_lock+0x1f/0x2e [reiserfs]
> [  244.015443]        [<f9eb7bbe>] search_by_key+0x19c/0x736 [reiserfs]
> [  244.015456]        [<f9ea6ee2>] search_by_entry_key+0x17/0x198 [reiserfs]
> [  244.015467]        [<f9ea70c1>] reiserfs_find_entry+0x5e/0x21c [reiserfs]
> [  244.015477]        [<f9ea76f6>] reiserfs_lookup+0x6f/0xf7 [reiserfs]
> [  244.015488]        [<c0281ee3>] __lookup_hash+0xa4/0xbe
> [  244.015492]        [<c028396b>] lookup_one_len+0x8e/0x9d
> [  244.015495]        [<f9ec114d>] open_xa_dir+0x111/0x18a [reiserfs]
> [  244.015507]        [<f9ec17f9>] reiserfs_for_each_xattr+0x57/0x1df [reiserfs]
> [  244.015520]        [<f9ec19d4>] reiserfs_delete_xattrs+0x13/0x40 [reiserfs]
> [  244.015532]        [<f9ead3e0>] reiserfs_delete_inode+0x41/0xb9 [reiserfs]
> [  244.015543]        [<c028aa5d>] generic_delete_inode+0x79/0xf1
> [  244.015547]        [<c028aae7>] generic_drop_inode+0x12/0x18d
> [  244.015550]        [<c0289e3b>] iput+0x4b/0x4e
> [  244.015553]        [<c0284448>] do_unlinkat+0xc3/0x107
> [  244.015556]        [<c028449c>] sys_unlink+0x10/0x12
> [  244.015560]        [<c0203228>] sysenter_do_call+0x12/0x3c
> [  244.015563]        [<ffffffff>] 0xffffffff
> [  244.015569] 
> [  244.015569] other info that might help us debug this:
> [  244.015570] 
> [  244.015572] 1 lock held by gdm/3771:
> [  244.015574]  #0:  (&sb->s_type->i_mutex_key#9/3){+.+.+.}, at: [<f9ec113b>] open_xa_dir+0xff/0x18a [reiserfs]
> [  244.015590] 
> [  244.015591] stack backtrace:
> [  244.015594] Pid: 3771, comm: gdm Not tainted 2.6.31-rc4-00220-g46be1f8 #233
> [  244.015596] Call Trace:
> [  244.015599]  [<c03d86ec>] ? printk+0xf/0x13
> [  244.015602]  [<c0244af3>] print_circular_bug_tail+0x5d/0x68
> [  244.015606]  [<c0245653>] __lock_acquire+0x89c/0xafa
> [  244.015610]  [<c0245904>] lock_acquire+0x53/0x75
> [  244.015622]  [<f9ec2066>] ? reiserfs_write_lock+0x1f/0x2e [reiserfs]
> [  244.015625]  [<c03d9684>] __mutex_lock_common+0x3e/0x3ca
> [  244.015638]  [<f9ec2066>] ? reiserfs_write_lock+0x1f/0x2e [reiserfs]
> [  244.015641]  [<c03d9a99>] mutex_lock_nested+0x29/0x31
> [  244.015654]  [<f9ec2066>] ? reiserfs_write_lock+0x1f/0x2e [reiserfs]
> [  244.015666]  [<f9ec2066>] reiserfs_write_lock+0x1f/0x2e [reiserfs]
> [  244.015678]  [<f9eb7bbe>] search_by_key+0x19c/0x736 [reiserfs]
> [  244.015682]  [<c0244578>] ? trace_hardirqs_on_caller+0x103/0x124
> [  244.015686]  [<c024a477>] ? __module_text_address+0xb/0x48
> [  244.015690]  [<c024a5f2>] ? is_module_text_address+0x34/0x45
> [  244.015693]  [<c0236092>] ? __kernel_text_address+0x55/0x5b
> [  244.015696]  [<c0206793>] ? print_context_stack+0x83/0x94
> [  244.015707]  [<f9ea6ee2>] search_by_entry_key+0x17/0x198 [reiserfs]
> [  244.015711]  [<c0205aa3>] ? dump_trace+0x78/0xa5
> [  244.015722]  [<f9ea70c1>] reiserfs_find_entry+0x5e/0x21c [reiserfs]
> [  244.015725]  [<c0243963>] ? save_trace+0x37/0x82
> [  244.015728]  [<c0243a0d>] ? add_lock_to_list+0x5f/0x91
> [  244.015731]  [<c0245703>] ? __lock_acquire+0x94c/0xafa
> [  244.015742]  [<f9ea76f6>] reiserfs_lookup+0x6f/0xf7 [reiserfs]
> [  244.015747]  [<c0281ee3>] __lookup_hash+0xa4/0xbe
> [  244.015750]  [<c028396b>] lookup_one_len+0x8e/0x9d
> [  244.015762]  [<f9ec114d>] open_xa_dir+0x111/0x18a [reiserfs]
> [  244.015775]  [<f9ec17f9>] reiserfs_for_each_xattr+0x57/0x1df [reiserfs]
> [  244.015787]  [<f9ec1f52>] ? delete_one_xattr+0x0/0x96 [reiserfs]
> [  244.015800]  [<f9ec19d4>] reiserfs_delete_xattrs+0x13/0x40 [reiserfs]
> [  244.015811]  [<f9ead3e0>] reiserfs_delete_inode+0x41/0xb9 [reiserfs]
> [  244.015822]  [<f9ead39f>] ? reiserfs_delete_inode+0x0/0xb9 [reiserfs]
> [  244.015826]  [<c028aa5d>] generic_delete_inode+0x79/0xf1
> [  244.015829]  [<c028aae7>] generic_drop_inode+0x12/0x18d
> [  244.015832]  [<c0289e3b>] iput+0x4b/0x4e
> [  244.015835]  [<c0284448>] do_unlinkat+0xc3/0x107
> [  244.015840]  [<c026bdc3>] ? do_munmap+0x21c/0x237
> [  244.015843]  [<c0203261>] ? sysenter_exit+0xf/0x1a
> [  244.015846]  [<c0244578>] ? trace_hardirqs_on_caller+0x103/0x124
> [  244.015849]  [<c028449c>] sys_unlink+0x10/0x12
> [  244.015852]  [<c0203228>] sysenter_do_call+0x12/0x3c
> [  279.041404] SysRq : Show Blocked State
> [  279.045392]   task                PC stack   pid father
> [  279.045392] pdflush       D c04be160  2408   236      2 0x00000000
> [  279.045392]  f74d9e8c 00000046 000003e9 c04be160 00000000 00000000 c1aeb6e8 c05361c0
> [  279.045392]  c05361c0 c053328c c1a90068 f757c1f0 f757c384 c1c421c0 00000000 00000000
> [  279.045392]  f74d9f64 f74d9e7c 00000246 00000000 f757c384 ffffd493 00000000 f9ec2066
> [  279.045392] Call Trace:
> [  279.045392]  [<f9ec2066>] ? reiserfs_write_lock+0x1f/0x2e [reiserfs]
> [  279.045392]  [<c03d987f>] __mutex_lock_common+0x239/0x3ca
> [  279.045392]  [<c03d9a99>] mutex_lock_nested+0x29/0x31
> [  279.045392]  [<f9ec2066>] ? reiserfs_write_lock+0x1f/0x2e [reiserfs]
> [  279.045392]  [<f9ec2066>] reiserfs_write_lock+0x1f/0x2e [reiserfs]
> [  279.045392]  [<f9eb16f8>] reiserfs_sync_fs+0x12/0x51 [reiserfs]
> [  279.045392]  [<c027cd1a>] ? sync_supers+0x40/0x8e
> [  279.045392]  [<c03d9cff>] ? down_read+0x2a/0x3e
> [  279.045392]  [<f9eb1744>] reiserfs_write_super+0xd/0xf [reiserfs]
> [  279.045392]  [<c027cd2e>] sync_supers+0x54/0x8e
> [  279.045392]  [<c025c50e>] wb_kupdate+0x26/0xed
> [  279.045392]  [<c02445a4>] ? trace_hardirqs_on+0xb/0xd
> [  279.045392]  [<c025d0cd>] ? pdflush+0x0/0x1c4
> [  279.045392]  [<c025d1d2>] pdflush+0x105/0x1c4
> [  279.045392]  [<c025c4e8>] ? wb_kupdate+0x0/0xed
> [  279.045392]  [<c02378a5>] kthread+0x69/0x6e
> [  279.045392]  [<c023783c>] ? kthread+0x0/0x6e
> [  279.045392]  [<c0203d8b>] kernel_thread_helper+0x7/0x10
> [  279.045392] bash          D c04be160  2476  4334   4276 0x00000000
> [  279.045392]  f5305f18 00000046 0000000a c04be160 00000000 f5305f20 c025b81c c05361c0
> [  279.045392]  c05361c0 c053328c c04de700 f6f9f230 f6f9f3c4 c1c421c0 00000000 00000000
> [  279.045392]  f72993d4 f5305f08 00000246 00000000 f6f9f3c4 ffffe02b 00000000 c02860c9
> [  279.045392] Call Trace:
> [  279.045392]  [<c025b81c>] ? __alloc_pages_nodemask+0xec/0x417
> [  279.045392]  [<c02860c9>] ? vfs_readdir+0x34/0x82
> [  279.045392]  [<c03d987f>] __mutex_lock_common+0x239/0x3ca
> [  279.045392]  [<c03d9a69>] mutex_lock_killable_nested+0x29/0x30
> [  279.045392]  [<c02860c9>] ? vfs_readdir+0x34/0x82
> [  279.045392]  [<c02860c9>] vfs_readdir+0x34/0x82
> [  279.045392]  [<c0285e54>] ? filldir64+0x0/0xcd
> [  279.045392]  [<c028617a>] sys_getdents64+0x63/0xa0
> [  279.045392]  [<c0203228>] sysenter_do_call+0x12/0x3c
> [  279.045392] gconfd-2      D f53e12b0  1624  4669      1 0x00000000
> [  279.045392]  f50a7cfc 00000046 f6bf5530 f53e12b0 00000000 f7299a74 f6bf5530 c05361c0
> [  279.045392]  c05361c0 f50a7d68 f50a7d34 f6bf5530 f6bf56c4 c1c521c0 00000001 f7299784
> [  279.045392]  f7288b40 f50a7cec 00000246 00000000 f6bf56c4 00000000 00000000 f9ec113b
> [  279.045392] Call Trace:
> [  279.045392]  [<f9ec113b>] ? open_xa_dir+0xff/0x18a [reiserfs]
> [  279.045392]  [<c03d987f>] __mutex_lock_common+0x239/0x3ca
> [  279.045392]  [<c03d9a99>] mutex_lock_nested+0x29/0x31
> [  279.045392]  [<f9ec113b>] ? open_xa_dir+0xff/0x18a [reiserfs]
> [  279.045392]  [<f9ec113b>] open_xa_dir+0xff/0x18a [reiserfs]
> [  279.045392]  [<c02445a4>] ? trace_hardirqs_on+0xb/0xd
> [  279.045392]  [<f9ec17f9>] reiserfs_for_each_xattr+0x57/0x1df [reiserfs]
> [  279.045392]  [<f9ec1f52>] ? delete_one_xattr+0x0/0x96 [reiserfs]
> [  279.045392]  [<f9ec2066>] ? reiserfs_write_lock+0x1f/0x2e [reiserfs]
> [  279.045392]  [<f9ec19d4>] reiserfs_delete_xattrs+0x13/0x40 [reiserfs]
> [  279.045392]  [<f9ead3e0>] reiserfs_delete_inode+0x41/0xb9 [reiserfs]
> [  279.045392]  [<f9ead39f>] ? reiserfs_delete_inode+0x0/0xb9 [reiserfs]
> [  279.045392]  [<c028aa5d>] generic_delete_inode+0x79/0xf1
> [  279.045392]  [<c028aae7>] generic_drop_inode+0x12/0x18d
> [  279.045392]  [<c0289e3b>] iput+0x4b/0x4e
> [  279.045392]  [<c0287b16>] dentry_iput+0x9c/0xb7
> [  279.045392]  [<c0287bd2>] d_kill+0x2d/0x47
> [  279.501457]  [<c028940e>] dput+0x10e/0x117
> [  279.501457]  [<c0284314>] sys_renameat+0x176/0x1d3
> [  279.501457]  [<c028d13e>] ? mntput_no_expire+0x19/0xad
> [  279.501457]  [<c0284383>] sys_rename+0x12/0x14
> [  279.501457]  [<c0203228>] sysenter_do_call+0x12/0x3c
> [  279.501457] gnome-panel   D f7477230  1996  4718   4453 0x00000000
> [  279.501457]  ee82cd74 00000046 00000092 f7477230 000000c1 ee82cd48 00000000 c05361c0
> [  279.501457]  c05361c0 c053328c 000000c1 f53ea170 f53ea304 c1c521c0 00000001 00000000
> [  279.501457]  ee82ce6c ee82cd64 00000246 00000000 f53ea304 ffffd322 00000000 f9ec202b
> [  279.501457] Call Trace:
> [  279.501457]  [<f9ec202b>] ? reiserfs_write_lock_once+0x1f/0x3b [reiserfs]
> [  279.501457]  [<c03d987f>] __mutex_lock_common+0x239/0x3ca
> [  279.501457]  [<c03d9a99>] mutex_lock_nested+0x29/0x31
> [  279.501457]  [<f9ec202b>] ? reiserfs_write_lock_once+0x1f/0x3b [reiserfs]
> [  279.501457]  [<f9ec202b>] reiserfs_write_lock_once+0x1f/0x3b [reiserfs]
> [  279.501457]  [<f9ea76ce>] reiserfs_lookup+0x47/0xf7 [reiserfs]
> [  279.501457]  [<c03c9970>] ? unix_stream_recvmsg+0x3f9/0x413
> [  279.501457]  [<c0281dcf>] do_lookup+0xb4/0x124
> [  279.501457]  [<c0282583>] __link_path_walk+0x33b/0x6ce
> [  279.501457]  [<c0282ad7>] path_walk+0x50/0xa5
> [  279.501457]  [<c0282eb1>] do_path_lookup+0x21/0x42
> [  279.501457]  [<c028491c>] user_path_at+0x3c/0x67
> [  279.501457]  [<c0275ddd>] ? kmem_cache_alloc+0x11b/0x153
> [  279.501457]  [<c023bc4a>] ? prepare_creds+0x2b/0x72
> [  279.501457]  [<c027a933>] sys_faccessat+0x90/0x14a
> [  279.501457]  [<c027a9fd>] sys_access+0x10/0x12
> [  279.501457]  [<c0203228>] sysenter_do_call+0x12/0x3c
> [  279.501457] trackerd      D f7477230  1692  4728   4453 0x00000000
> [  279.501457]  ee8c3ce0 00000046 f68aa940 f7477230 c02445a4 ee8c3c88 c03da6c6 c05361c0
> [  279.501457]  c05361c0 c053328c 00000000 f52c20b0 f52c2244 c1c521c0 00000001 00000000
> [  279.501457]  00000062 ee8c3cd0 00000246 00000000 f52c2244 ffffd2da 00000000 f9ec202b
> [  279.501457] Call Trace:
> [  279.501457]  [<c02445a4>] ? trace_hardirqs_on+0xb/0xd
> [  279.501457]  [<c03da6c6>] ? _spin_unlock_irq+0x43/0x4f
> [  279.501457]  [<f9ec202b>] ? reiserfs_write_lock_once+0x1f/0x3b [reiserfs]
> [  279.501457]  [<c03d987f>] __mutex_lock_common+0x239/0x3ca
> [  279.501457]  [<c03d9a99>] mutex_lock_nested+0x29/0x31
> [  279.501457]  [<f9ec202b>] ? reiserfs_write_lock_once+0x1f/0x3b [reiserfs]
> [  279.501457]  [<f9ec202b>] reiserfs_write_lock_once+0x1f/0x3b [reiserfs]
> [  279.501457]  [<f9eaae91>] reiserfs_write_end+0xea/0x241 [reiserfs]
> [  279.501457]  [<c021d8f1>] ? kunmap_atomic+0x58/0x70
> [  279.501457]  [<c0257ac9>] generic_file_buffered_write+0x136/0x256
> [  279.501457]  [<c0258003>] __generic_file_aio_write_nolock+0x250/0x278
> [  279.501457]  [<c0258809>] generic_file_aio_write+0x69/0xbd
> [  279.501457]  [<c027b497>] do_sync_write+0xab/0xe9
> [  279.501457]  [<c0265f3f>] ? might_fault+0x86/0x88
> [  279.501457]  [<c0237af7>] ? autoremove_wake_function+0x0/0x33
> [  279.501457]  [<f9ead8ac>] reiserfs_file_write+0x6e/0x77 [reiserfs]
> [  279.501457]  [<f9ead83e>] ? reiserfs_file_write+0x0/0x77 [reiserfs]
> [  279.501457]  [<c027bc75>] vfs_write+0x7c/0xad
> [  279.501457]  [<c027bd3f>] sys_write+0x3b/0x60
> [  279.501457]  [<c0203228>] sysenter_do_call+0x12/0x3c
> [  279.501457] xdg-user-dirs D f7477230  1796  4740   4453 0x00000000
> [  279.501457]  ee977a84 00000046 c1c521c0 f7477230 c02445a4 ee977a30 c03da600 c05361c0
> [  279.501457]  c05361c0 c053328c f82335bb f645cc30 f645cdc4 c1c521c0 00000001 00000000
> [  279.501457]  00000001 ee977a74 00000246 00000000 f645cdc4 ffffd2da 00000000 f9ec2066
> [  279.501457] Call Trace:
> [  279.501457]  [<c02445a4>] ? trace_hardirqs_on+0xb/0xd
> [  279.501457]  [<c03da600>] ? _read_unlock_irqrestore+0x5f/0x6c
> [  279.501457]  [<f82335bb>] ? dm_get_table+0x2e/0x35 [dm_mod]
> [  279.501457]  [<f9ec2066>] ? reiserfs_write_lock+0x1f/0x2e [reiserfs]
> [  279.501457]  [<c03d987f>] __mutex_lock_common+0x239/0x3ca
> [  279.501457]  [<c03d9a99>] mutex_lock_nested+0x29/0x31
> [  279.501457]  [<f9ec2066>] ? reiserfs_write_lock+0x1f/0x2e [reiserfs]
> [  279.501457]  [<f9ec2066>] reiserfs_write_lock+0x1f/0x2e [reiserfs]
> [  279.501457]  [<f9eb7bbe>] search_by_key+0x19c/0x736 [reiserfs]
> [  279.501457]  [<c02445a4>] ? trace_hardirqs_on+0xb/0xd
> [  279.501457]  [<c03d94ed>] ? __mutex_unlock_slowpath+0x112/0x121
> [  279.501457]  [<c03d9504>] ? mutex_unlock+0x8/0xa
> [  279.501457]  [<f9ebd564>] ? do_journal_end+0xa30/0xc0a [reiserfs]
> [  279.501457]  [<f9ea6ee2>] search_by_entry_key+0x17/0x198 [reiserfs]
> [  279.501457]  [<f9ea70c1>] reiserfs_find_entry+0x5e/0x21c [reiserfs]
> [  279.501457]  [<c03d9504>] ? mutex_unlock+0x8/0xa
> [  279.501457]  [<f9ec20ca>] ? reiserfs_write_unlock+0x55/0x5a [reiserfs]
> [  279.501457]  [<f9ea76f6>] reiserfs_lookup+0x6f/0xf7 [reiserfs]
> [  279.501457]  [<c0281ee3>] __lookup_hash+0xa4/0xbe
> [  279.501457]  [<c028396b>] lookup_one_len+0x8e/0x9d
> [  279.501457]  [<f9ec114d>] open_xa_dir+0x111/0x18a [reiserfs]
> [  279.501457]  [<c02445a4>] ? trace_hardirqs_on+0xb/0xd
> [  279.501457]  [<f9ec17f9>] reiserfs_for_each_xattr+0x57/0x1df [reiserfs]
> [  279.501457]  [<f9ec1f52>] ? delete_one_xattr+0x0/0x96 [reiserfs]
> [  279.501457]  [<f9ec2066>] ? reiserfs_write_lock+0x1f/0x2e [reiserfs]
> [  279.501457]  [<f9ec19d4>] reiserfs_delete_xattrs+0x13/0x40 [reiserfs]
> [  279.501457]  [<f9ead3e0>] reiserfs_delete_inode+0x41/0xb9 [reiserfs]
> [  279.501457]  [<f9ead39f>] ? reiserfs_delete_inode+0x0/0xb9 [reiserfs]
> [  279.501457]  [<c028aa5d>] generic_delete_inode+0x79/0xf1
> [  279.501457]  [<c028aae7>] generic_drop_inode+0x12/0x18d
> [  279.501457]  [<c0289e3b>] iput+0x4b/0x4e
> [  279.501457]  [<c0287b16>] dentry_iput+0x9c/0xb7
> [  279.501457]  [<c0287bd2>] d_kill+0x2d/0x47
> [  279.501457]  [<c028940e>] dput+0x10e/0x117
> [  279.501457]  [<c0284314>] sys_renameat+0x176/0x1d3
> [  279.501457]  [<c02445a4>] ? trace_hardirqs_on+0xb/0xd
> [  279.501457]  [<c02753a9>] ? __cache_free+0x22f/0x371
> [  279.501457]  [<c02755b8>] ? kmem_cache_free+0x33/0x5c
> [  279.501457]  [<c026b19e>] ? remove_vma+0x50/0x56
> [  279.501457]  [<c026bdc3>] ? do_munmap+0x21c/0x237
> [  279.501457]  [<c0284383>] sys_rename+0x12/0x14
> [  279.501457]  [<c0203228>] sysenter_do_call+0x12/0x3c
> [  361.097011] Warning: dev (tty1) tty->count(6) != #fd's(5) in tty_release_dev
> [  393.659198] pktcdvd: writer pktcdvd0 unmapped
> 
> ~~
> laurent

