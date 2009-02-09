Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbZBIUUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbZBIUUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 15:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZBIUT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 15:19:57 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:50880 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751AbZBIUTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 15:19:55 -0500
Subject: Re: [PARAVIRT/x86] BUGFIX: Put a missing paravirt_release_pmd in
	pgd_dtor
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Zach Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Rohit Jain <rjain@vmware.com>, LKML <linux-kernel@vger.kernel.org>,
       tj@kernel.org
In-Reply-To: <20090209121045.GF17782@elte.hu>
References: <1233885731.29693.26.camel@alok-dev1>
	 <498BA0CA.2040603@goop.org> <1233901043.8943.6.camel@alok-dev1>
	 <498BDE1D.8030101@goop.org> <20090206145324.GF18368@elte.hu>
	 <498C6CC9.5050302@goop.org> <1233944975.15269.14.camel@alok-dev1>
	 <20090209121045.GF17782@elte.hu>
Content-Type: multipart/mixed; boundary="=-zbUTkRkldoc3KHCjW5uk"
Organization: VMware INC.
Date: Mon, 09 Feb 2009 12:19:54 -0800
Message-Id: <1234210794.16177.35.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zbUTkRkldoc3KHCjW5uk
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2009-02-09 at 04:10 -0800, Ingo Molnar wrote:

> 
> Applied to tip:x86/urgent, thanks guys!

Thanks Ingo, 

I gave the tip tree a spin today and hit this bug.

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<(null)>] (null)
*pdpt = 0000000000839001 *pde = 0000000000c97067 *pte = 0000000000000163
Oops: 0000 [#1] SMP
last sysfs file:
Modules linked in:

Pid: 1, comm: swapper Not tainted (2.6.29-rc4-tip #18) VMware Virtual
Platform
EIP: 0062:[<00000000>] EFLAGS: 00010293 CPU: 0
EIP is at 0x0
EAX: 00000001 EBX: 00006000 ECX: c077ed00 EDX: 00006000
ESI: 00000001 EDI: 00000001 EBP: ef04cf40 ESP: ef04cf1c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 006a
Process swapper (pid: 1, ti=ef04c000 task=ef050000 task.ti=ef04c000)
Stack:
 c0644e52 00000000 ef04cf24 ef04cf24 c064468d c0886dc0 00000000 c0702aea
 ef055480 00000001 00000101 dead4ead ffffffff ffffffff c08af530 00000000
 c0709715 ef04cf60 ef04cf60 00000001 00000000 00000000 dead4ead ffffffff
Call Trace:
 [<c0644e52>] ? native_cpu_up+0x2de/0x45b
 [<c064468d>] ? do_fork_idle+0x0/0x19
 [<c0645c5e>] ? _cpu_up+0x88/0xe8
 [<c0645d20>] ? cpu_up+0x42/0x4e
 [<c07e7462>] ? kernel_init+0x99/0x14b
 [<c07e73c9>] ? kernel_init+0x0/0x14b
 [<c040375f>] ? kernel_thread_helper+0x7/0x10
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 006a:ef04cf1c


This happens with out the fix too. So was wondering if there is any
other known bug in the tip tree. 
Also note that i synced to the mainline tree (29-rc4) and that works
fine. So this only exists in tip.
I will debug this later today, but if anyone has any ideas about this
bug do let me know. 

And ya i also had to apply this patch to get tip to compile. 
--
commit 22142120d931329efa53920739c74e7043bb2cb2
Author: Tejun Heo <tj@kernel.org>
Date:   Mon Feb 9 22:17:39 2009 +0900

    x86: fix math_emu register frame access

introduced the build error i assume.

Index: linux-tip-master/arch/x86/kernel/traps.c
===================================================================
--- linux-tip-master.orig/arch/x86/kernel/traps.c	2009-02-09 10:00:56.000000000 -0800
+++ linux-tip-master/arch/x86/kernel/traps.c	2009-02-09 10:11:29.000000000 -0800
@@ -900,7 +900,7 @@
 EXPORT_SYMBOL_GPL(math_state_restore);
 
 #ifndef CONFIG_MATH_EMULATION
-void math_emulate(struct math_emu_info *info)
+asmlinkage void math_emulate(struct math_emu_info *info)
 {
 	printk(KERN_EMERG
 		"math-emulation not enabled and no coprocessor found.\n");


--=-zbUTkRkldoc3KHCjW5uk
Content-Disposition: attachment; filename=serial-tip-failed
Content-Type: text/plain; name=serial-tip-failed; charset=UTF-8
Content-Transfer-Encoding: 7bit

Linux version 2.6.29-rc4-tip (akataria@alok-dev1) (gcc version 4.1.2 20070626 (Red Hat 4.1.2-14)) #18 SMP Mon Feb 9 10:13:59 PST 2009
VMI: Found VMware, Inc. Hypervisor OPROM, API version 3.0, ROM version 1.0
Reserving virtual address space above 0xfc000000
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
 BIOS-e820: 00000000000dc000 - 00000000000e0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fef0000 (usable)
 BIOS-e820: 000000003fef0000 - 000000003feff000 (ACPI data)
 BIOS-e820: 000000003feff000 - 000000003ff00000 (ACPI NVS)
 BIOS-e820: 000000003ff00000 - 0000000040000000 (usable)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
DMI present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
last_pfn = 0x40000 max_arch_pfn = 0x1000000
x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
RAMDISK: 37deb000 - 37fef561
Allocated new RAMDISK: 00100000 - 00304561
Move RAMDISK from 0000000037deb000 - 0000000037fef560 to 00100000 - 00304560
ACPI: RSDP 000F6A30, 0024 (r2 PTLTD )
ACPI: XSDT 3FEF0178, 004C (r1 INTEL  440BX     6040000 VMW   1324272)
ACPI: FACP 3FEFEE98, 00F4 (r4 INTEL  440BX     6040000 PTL     F4240)
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT 3FEF038E, EB0A (r1 PTLTD  Custom    6040000 MSFT  3000001)
ACPI: FACS 3FEFFFC0, 0040
ACPI: BOOT 3FEF0366, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: APIC 3FEF0308, 005E (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: MCFG 3FEF02CC, 003C (r1 PTLTD  $PCITBL$  6040000  LTP        1)
ACPI: SRAT 3FEF01FC, 00D0 (r2 VMWARE MEMPLUG   6040000 VMW         1)
264MB HIGHMEM available.
759MB LOWMEM available.
  mapped low ram: 0 - 2f7fe000
  low ram: 00000000 - 2f7fe000
  bootmap 00013000 - 00018f00
(9 early reservations) ==> bootmem [0000000000 - 002f7fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000400000 - 0000c9629c]    TEXT DATA BSS ==> [0000400000 - 0000c9629c]
  #4 [0000c97000 - 0000ca2000]    INIT_PG_TABLE ==> [0000c97000 - 0000ca2000]
  #5 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #6 [0000010000 - 0000013000]          PGTABLE ==> [0000010000 - 0000013000]
  #7 [0000100000 - 0000304561]      NEW RAMDISK ==> [0000100000 - 0000304561]
  #8 [0000013000 - 0000019000]          BOOTMAP ==> [0000013000 - 0000019000]
found SMP MP-table at [c00f6aa0] 000f6aa0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x0002f7fe
  HighMem  0x0002f7fe -> 0x00040000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0003fef0
    0: 0x0003ff00 -> 0x00040000
ACPI: PM-Timer IO Port: 0x1008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Allocating 36864 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258686
Kernel command line: ro root=LABEL=/ selinux=0  console=ttyS0  
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
NR_IRQS:1280
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1866.692 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 2335 kB
 per task-struct memory footprint: 1152 bytes
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1022324k/1048576k available (2354k kernel code, 25240k reserved, 1626k data, 328k init, 270280k highmem)
virtual kernel memory layout:
    fixmap  : 0xfbc58000 - 0xfbfff000   (3740 kB)
    pkmap   : 0xfb800000 - 0xfba00000   (2048 kB)
    vmalloc : 0xefffe000 - 0xfb7fe000   ( 184 MB)
    lowmem  : 0xc0000000 - 0xef7fe000   ( 759 MB)
      .init : 0xc07e7000 - 0xc0839000   ( 328 kB)
      .data : 0xc064cad9 - 0xc07e3660   (1626 kB)
      .text : 0xc0400000 - 0xc064cad9   (2354 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
vmi: registering clock event vmi-timer. mult=7829473 shift=22
Calibrating delay loop (skipped), value calculated using timer frequency.. 3733.38 BogoMIPS (lpj=1866692)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
[ds] using Core 2/Atom configuration
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Intel Performance Monitoring support detected.
... version:         2
... num counters:    2
... bit width:       40
... value mask:      000000ffffffffff
... mask length:     7
... fixed counters:  0
... counter mask:    0000000000000003
ACPI: Core revision 20081204
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU            5120  @ 1.86GHz stepping 0b
lockdep: fixing up alternatives.
Booting processor 1 APIC 0x1 ip 0x6000
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<(null)>] (null)
*pdpt = 0000000000839001 *pde = 0000000000c97067 *pte = 0000000000000163 
Oops: 0000 [#1] SMP 
last sysfs file: 
Modules linked in:

Pid: 1, comm: swapper Not tainted (2.6.29-rc4-tip #18) VMware Virtual Platform
EIP: 0062:[<00000000>] EFLAGS: 00010293 CPU: 0
EIP is at 0x0
EAX: 00000001 EBX: 00006000 ECX: c077ed00 EDX: 00006000
ESI: 00000001 EDI: 00000001 EBP: ef04cf40 ESP: ef04cf1c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 006a
Process swapper (pid: 1, ti=ef04c000 task=ef050000 task.ti=ef04c000)
Stack:
 c0644e52 00000000 ef04cf24 ef04cf24 c064468d c0886dc0 00000000 c0702aea
 ef055480 00000001 00000101 dead4ead ffffffff ffffffff c08af530 00000000
 c0709715 ef04cf60 ef04cf60 00000001 00000000 00000000 dead4ead ffffffff
Call Trace:
 [<c0644e52>] ? native_cpu_up+0x2de/0x45b
 [<c064468d>] ? do_fork_idle+0x0/0x19
 [<c0645c5e>] ? _cpu_up+0x88/0xe8
 [<c0645d20>] ? cpu_up+0x42/0x4e
 [<c07e7462>] ? kernel_init+0x99/0x14b
 [<c07e73c9>] ? kernel_init+0x0/0x14b
 [<c040375f>] ? kernel_thread_helper+0x7/0x10
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 006a:ef04cf1c
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D    2.6.29-rc4-tip #18
Call Trace:
 [<c042d6f1>] ? panic+0x3e/0xf4
 [<c042fe96>] ? do_exit+0x5f/0x647
 [<c064a0e1>] ? oops_end+0x9a/0x9e
 [<c041990a>] ? no_context+0x244/0x25d
 [<c064b027>] ? do_page_fault+0xd0/0x233
 [<c064af57>] ? do_page_fault+0x0/0x233
 [<c0419b16>] ? bad_area_nosemaphore+0xa/0xc
 [<c0649767>] ? error_code+0x77/0x7c
 [<c044007b>] ? hrtimer_forward+0x32/0x126
 [<c0644e52>] ? native_cpu_up+0x2de/0x45b
 [<c064468d>] ? do_fork_idle+0x0/0x19
 [<c0645c5e>] ? _cpu_up+0x88/0xe8
 [<c0645d20>] ? cpu_up+0x42/0x4e
 [<c07e7462>] ? kernel_init+0x99/0x14b
 [<c07e73c9>] ? kernel_init+0x0/0x14b
 [<c040375f>] ? kernel_thread_helper+0x7/0x10

--=-zbUTkRkldoc3KHCjW5uk--

