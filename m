Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZBILpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZBILpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 06:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZBILpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 06:45:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56950 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbZBILpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:45:44 -0500
Date: Mon, 9 Feb 2009 12:45:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: check_timer cleanup
Message-ID: <20090209114520.GE18757@elte.hu>
References: <20090206220716.GA15319@elte.hu> <498D55A4.7000608@kernel.org> <20090207165901.GA32116@elte.hu> <498E6A3C.6020004@kernel.org> <20090209081542.GF24420@elte.hu> <alpine.LFD.1.10.0902091129150.12457@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0902091129150.12457@ftp.linux-mips.org>
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


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> On Mon, 9 Feb 2009, Ingo Molnar wrote:
> 
> > > Impact: remove extra unmask, and pair disable/enable
> > > 
> > > for edge trigger io-apic routing, already unmasked via setup_IO_APIC_irq,
> > > so don't unmask it again.
> > > 
> > > also do call local_irq_disable() between timer_irq_works(), between it does call
> > > local_irq_enable() inside.
> > > also remove not needed apic version reading for 64bit
> > > 
> > > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > > 
> > > ---
> > >  arch/x86/kernel/io_apic.c |   30 ++++++++++++++++++++++--------
> > >  1 file changed, 22 insertions(+), 8 deletions(-)
> > 
> > applied to tip/x86/apic, thanks Yinghai. Maybe this even solves some of the spurious 
> > detection troubles we had in this code.
> 
>  I'll see if I can find time to look into it in details, but it looks 
> dodgy to me.  The thing is setup_timer_IRQ0_pin() is special -- due to 
> line rerouting it may not necessarily be called for an input already set 
> up by setup_IO_APIC_irqs().  I recall keeping this mask set until ready 
> for a reason when doing the cleanup last year -- I think old code actually 
> used to do what the change now reintroduces.  What's the reason of this 
> change?
> 
>  And timer_irq_works() used to restore the local interrupt mask within 
> itself -- perhaps it should be brought back rather than cluttering code 
> with local_irq_disable() calls throughout?
> 
>  What problems are you referring to, Ingo?  Perhaps they should be looked 
> into specifically?

I got a spurious boot failure on a 64-bi testbox:

[    0.280000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.296000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.296000] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.296000] ..... (found apic 0 pin 2) ...
[    0.308000] ....... failed.
[    0.308000] ...trying to set up timer as Virtual Wire IRQ...
[    0.324000] ..... failed.
[    0.324000] ...trying to set up timer as ExtINT IRQ...
[    0.340000] ..... failed :(.
[    0.340000] Kernel panic - not syncing: IO-APIC + timer doesn't work!  Boot with apic=debug and send a report.  Then try booting with the 'noapic' option.

Not reproducible. Full bootlog below.

	Ingo

--------------------------->
[    0.000000] Linux version 2.6.29-rc3-tip-01885-gf21daa4d-dirty (mingo@rhea) (gcc version 4.2.3) #3 SMP Fri Feb 6 22:08:25 CET 2009
[    0.000000] Command line: root=/dev/sda3 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty 3 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled highres=0 nmi_watchdog=0 nolapic_timer hpet=disable idle=mwait idle=poll highmem=512m nopat notsc pci=nomsi
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ffa0000 (usable)
[    0.000000]  BIOS-e820: 000000007ffa0000 - 000000007ffae000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ffae000 - 000000007ffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
[    0.000000] console [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] using polling idle threads.
[    0.000000] DMI 2.3 present.
[    0.000000] last_pfn = 0x7ffa0 max_arch_pfn = 0x100000000
[    0.000000] init_memory_mapping: 0000000000000000-000000007ffa0000
[    0.000000]  0000000000 - 007fe00000 page 2M
[    0.000000]  007fe00000 - 007ffa0000 page 4k
[    0.000000] kernel direct mapping tables up to 7ffa0000 @ 8000-c000
[    0.000000] last_map_addr: 7ffa0000 end: 7ffa0000
[    0.000000] ACPI: RSDP 000FACD0, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT 7FFA0100, 0044 (r1 A M I  OEMXSDT  10000630 MSFT       97)
[    0.000000] ACPI: FACP 7FFA0290, 00F4 (r3 A M I  OEMFACP  10000630 MSFT       97)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT 7FFA0410, 8318 (r1  A0227 A0227000        0 INTL  2002026)
[    0.000000] ACPI: FACS 7FFAE000, 0040
[    0.000000] ACPI: APIC 7FFA0390, 0080 (r1 A M I  OEMAPIC  10000630 MSFT       97)
[    0.000000] ACPI: OEMB 7FFAE040, 0066 (r1 A M I  AMI_OEM  10000630 MSFT       97)
[    0.000000] ACPI: MCFG 7FFA8730, 003C (r1 A M I  OEMMCFG  10000630 MSFT       97)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007ffa0000
[    0.000000] Bootmem setup node 0 0000000000000000-000000007ffa0000
[    0.000000]   NODE_DATA [0000000000001000 - 0000000000004fff]
[    0.000000]   bootmap [000000000000a000 -  0000000000019ff7] pages 10
[    0.000000] (5 early reservations) ==> bootmem [0000000000 - 007ffa0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0001866aac]    TEXT DATA BSS ==> [0000200000 - 0001866aac]
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #4 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007ffa0
[    0.000000] On node 0 totalpages: 524095
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 101 pages reserved
[    0.000000]   DMA zone: 3842 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7111 pages used for memmap
[    0.000000]   DMA32 zone: 512985 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] mapped APIC to ffffffffff5fc000 (fee00000)
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:7fb80000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Allocating 77824 bytes of per cpu data
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 516827
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda3 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty 3 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled highres=0 nmi_watchdog=0 nolapic_timer hpet=disable idle=mwait idle=poll highmem=512m nopat notsc pci=nomsi
[    0.000000] kernel profiling enabled (shift: 0)
[    0.000000] debug: sysrq always enabled.
[    0.000000] notsc: Kernel compiled with CONFIG_X86_TSC, cannot disable TSC completely.
[    0.000000] Initializing CPU#0
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:288
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3456.484 MHz processor.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console handover: boot [earlyser0] -> real [tty0]
[    0.000000] console [ttyS0] enabled
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 1996352k/2096768k available (11972k kernel code, 388k absent, 100028k reserved, 7281k data, 796k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.004000] Calibrating delay loop... 1724.41 BogoMIPS (lpj=3448832)
[    0.100000] Security Framework initialized
[    0.104000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.112000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.120000] Mount-cache hash table entries: 256
[    0.124000] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.128000] CPU: L2 cache: 2048K
[    0.132000] CPU 0/0x0 -> Node 0
[    0.136000] CPU: CPU feature monitor disabled due to lack of CPUID level 0x5
[    0.140000] CPU: Physical Processor ID: 0
[    0.144000] CPU: Processor Core ID: 0
[    0.152000] ACPI: Core revision 20081204
[    0.196000] Setting APIC routing to flat
[    0.200000] enabled ExtINT on CPU#0
[    0.200000] ENABLING IO-APIC IRQs
[    0.204000] init IO_APIC IRQs
[    0.208000]  2-0 (apicid-pin) not connected
[    0.212000] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.216000] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.220000] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    0.224000] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.228000] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
[    0.232000] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.236000] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.240000] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.244000] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
[    0.248000] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.252000] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
[    0.256000] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.260000] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.264000] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.268000] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.272000]  2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
[    0.280000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.296000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.296000] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.296000] ..... (found apic 0 pin 2) ...
[    0.308000] ....... failed.
[    0.308000] ...trying to set up timer as Virtual Wire IRQ...
[    0.324000] ..... failed.
[    0.324000] ...trying to set up timer as ExtINT IRQ...
[    0.340000] ..... failed :(.
[    0.340000] Kernel panic - not syncing: IO-APIC + timer doesn't work!  Boot with apic=debug and send a report.  Then try booting with the 'noapic' option.
[    0.340000] 
[    0.340000] Pid: 1, comm: swapper Not tainted 2.6.29-rc3-tip-01885-gf21daa4d-dirty #3
[    0.340000] Call Trace:
[    0.340000]  [<ffffffff8023da04>] panic+0xa0/0x157
[    0.340000]  [<ffffffff802239b4>] ? default_spin_lock_flags+0x9/0xd
[    0.340000]  [<ffffffff80502c33>] ? delay_loop+0x23/0x2a
[    0.340000]  [<ffffffff80502c55>] ? __delay+0xa/0xc
[    0.340000]  [<ffffffff80502c93>] ? __const_udelay+0x3c/0x3e
[    0.340000]  [<ffffffff814f0ec6>] setup_IO_APIC+0x7a6/0x7ec
[    0.340000]  [<ffffffff802239b4>] ? default_spin_lock_flags+0x9/0xd
[    0.340000]  [<ffffffff8021e377>] ? clear_IO_APIC_pin+0x64/0x6c
[    0.340000]  [<ffffffff814ee410>] native_smp_prepare_cpus+0x263/0x2ce
[    0.340000]  [<ffffffff814e7807>] kernel_init+0x5f/0x18c
[    0.340000]  [<ffffffff8020d04a>] child_rip+0xa/0x20
[    0.340000]  [<ffffffff814e77a8>] ? kernel_init+0x0/0x18c
[    0.340000]  [<ffffffff8020d040>] ? child_rip+0x0/0x20
[    0.340000] ------------[ cut here ]------------
[    0.340000] WARNING: at kernel/smp.c:329 smp_call_function_many+0x3e/0x1fe()
[    0.340000] Hardware name: System Product Name
[    0.340000] Pid: 1, comm: swapper Not tainted 2.6.29-rc3-tip-01885-gf21daa4d-dirty #3
[    0.340000] Call Trace:
[    0.340000]  [<ffffffff8023d936>] warn_slowpath+0xce/0xed
[    0.340000]  [<ffffffff8020d040>] ? child_rip+0x0/0x20
[    0.340000]  [<ffffffff802239b4>] ? default_spin_lock_flags+0x9/0xd
[    0.340000]  [<ffffffff8020f9d6>] ? printk_address+0x2c/0x2e
[    0.340000]  [<ffffffff8020fddf>] ? print_trace_address+0x30/0x39
[    0.340000]  [<ffffffff8024e4b4>] ? __kernel_text_address+0x9/0x13
[    0.340000]  [<ffffffff8020fe64>] ? print_context_stack+0x4a/0xb6
[    0.340000]  [<ffffffff802239b4>] ? default_spin_lock_flags+0x9/0xd
[    0.340000]  [<ffffffff8020eef7>] ? dump_trace+0x267/0x276
[    0.340000]  [<ffffffff80dad773>] ? mutex_trylock+0x19/0x39
[    0.340000]  [<ffffffff8025e90e>] ? crash_kexec+0xe8/0xf2
[    0.340000]  [<ffffffff802239b4>] ? default_spin_lock_flags+0x9/0xd
[    0.340000]  [<ffffffff8025c83f>] smp_call_function_many+0x3e/0x1fe
[    0.340000]  [<ffffffff80212d5a>] ? stop_this_cpu+0x0/0x2b
[    0.340000]  [<ffffffff8023e09e>] ? release_console_sem+0x1ab/0x1b7
[    0.340000]  [<ffffffff8025ca1f>] smp_call_function+0x20/0x24
[    0.340000]  [<ffffffff8021c621>] native_smp_send_stop+0x22/0x45
[    0.340000]  [<ffffffff8023da18>] panic+0xb4/0x157
[    0.340000]  [<ffffffff802239b4>] ? default_spin_lock_flags+0x9/0xd
[    0.340000]  [<ffffffff80502c33>] ? delay_loop+0x23/0x2a
[    0.340000]  [<ffffffff80502c55>] ? __delay+0xa/0xc
[    0.340000]  [<ffffffff80502c93>] ? __const_udelay+0x3c/0x3e
[    0.340000]  [<ffffffff814f0ec6>] setup_IO_APIC+0x7a6/0x7ec
[    0.340000]  [<ffffffff802239b4>] ? default_spin_lock_flags+0x9/0xd
[    0.340000]  [<ffffffff8021e377>] ? clear_IO_APIC_pin+0x64/0x6c
[    0.340000]  [<ffffffff814ee410>] native_smp_prepare_cpus+0x263/0x2ce
[    0.340000]  [<ffffffff814e7807>] kernel_init+0x5f/0x18c
[    0.340000]  [<ffffffff8020d04a>] child_rip+0xa/0x20
[    0.340000]  [<ffffffff814e77a8>] ? kernel_init+0x0/0x18c
[    0.340000]  [<ffffffff8020d040>] ? child_rip+0x0/0x20
[    0.340000] ---[ end trace a7919e7f17c0a725 ]---
