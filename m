Return-Path: <linux-kernel-owner+w=401wt.eu-S1763724AbYBOCC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763724AbYBOCC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 21:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbYBOCCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 21:02:17 -0500
Received: from gir.skynet.ie ([193.1.99.77]:33773 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823AbYBOCCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 21:02:14 -0500
Date: Fri, 15 Feb 2008 02:02:09 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: 2.6.24 git2/mm1: cpu_to_node mapping to non-existant nodes causing boot failure
Message-ID: <20080215020208.GA6500@csn.ul.ie>
References: <20080203171634.58ab668b.akpm@linux-foundation.org> <20080213175241.GA327@csn.ul.ie> <47B33ACF.5030700@sgi.com> <20080214201727.GC30841@csn.ul.ie> <47B4A774.7050509@sgi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <47B4A774.7050509@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline

On (14/02/08 12:41), Mike Travis didst pronounce:
> Mel Gorman wrote:
> > On (13/02/08 10:45), Mike Travis didst pronounce:
> >> Mel Gorman wrote:
> >>> On (03/02/08 17:16), Andrew Morton didst pronounce:
> >>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.24-mm1/
> >>>>
> >>> bl6-13 (4-way x86_64 machine) from test.kernel.org is failing to boot recent
> >>> -mm and mainline trees. I noticed it when testing -mm before rebasing other
> >>> patches but the oops on mainline looks the same. The full console log is
> >>> below but the important difference between a working and non-working kernel
> >>> is the following
> >>>
> >>> -PERCPU: Allocating 62512 bytes of per cpu data
> >>> -Built 1 zonelists in Node order, mobility grouping on.  Total pages: 255875
> >>> +PERCPU: Allocating 65560 bytes of per cpu data
> >>> +cpu with no node 2, num_online_nodes 1
> >>> +cpu with no node 3, num_online_nodes 1
> >>> +Built 1 zonelists in Node order, mobility grouping on.  Total pages:
> >>> 251257
> >>>
> >>> "cpu with no node 2" is actually saying that cpu 2 has no node and the
> >>> message is a just misleading. The number of online nodes and cpu mappings
> >>> are not adding up as I got this from a debugging patch
> >> I'll take a closer look though I've not been able to duplicate your
> >> error yet.  It does appear from the message text that the code is
> >> out-of-date.  The latest "setup_per_cpu_areas()" should say:
> >>
> >>        "cpu %d has no node, num_online_nodes %d\n",
> >>         i, num_online_nodes());
> >>
> >> There are a number of backed up patches in the queue.  I'm resubmitting
> >> the whole set re-based on 2.6.25-rc1 shortly.  (I don't know though, that
> >> any will address this problem.)
> >>
> > 
> > According to git-bisect, the problem patch is below. It doesn't back out
> > cleanly so I haven't verified for sure the bisect is correct yet.
> 
> This might make sense.  This code is in preparation for the extended
> apic's available on the new processors.  I've tested the code with
> our simulator (with no errors) and I'm setting up to test on a real
> machine that has multiple numa nodes.  I wonder if maybe BIOS is not
> providing correct node data, or the ACPI parsing is in error?  You
> might try adding "apic=debug" to the boot command line.
> 

I tried this, but the dmesg complained about a malformed option. I'll
check out why tomorrow but it didn't appear particularly helpful.

> For the short term, we can remove this patch if it's causing the
> problem.  A more complete patch will be available soon that contains
> the entire set of x2apic changes.
> 

If you send me patches to apply on top of 2.6.25-rc1, I'll give them a spin
on the machine in question. Reverting didn't work out very well as there are
too many collisions with patches that were applied later. I eventually got
the machine booting but it only succeeds because it only brings up one core
on each processor.  The patch, which is pretty brain damaged is below in case
it helps you guess what the real problem is. dmesg logs are attached of the
vanilla failure with acpi=debug and the log with the patch applied showing
"__cpu_up: bad cpu 1" and "__cpu_up: bad cpu3" (i.e. the second cores of
each machine).


diff -ru linux-2.6/arch/x86/kernel/genapic_64.c linux-2.6-working/arch/x86/kernel/genapic_64.c
--- linux-2.6/arch/x86/kernel/genapic_64.c	2008-02-14 16:32:55.000000000 -0600
+++ linux-2.6-working/arch/x86/kernel/genapic_64.c	2008-02-14 15:46:18.000000000 -0600
@@ -25,10 +25,10 @@
 #endif
 
 /* which logical CPU number maps to which CPU (physical APIC ID) */
-u16 x86_cpu_to_apicid_init[NR_CPUS] __initdata
+u8 x86_cpu_to_apicid_init[NR_CPUS] __initdata
 					= { [0 ... NR_CPUS-1] = BAD_APICID };
 void *x86_cpu_to_apicid_early_ptr;
-DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
+DEFINE_PER_CPU(u8, x86_cpu_to_apicid) = BAD_APICID;
 EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 
 struct genapic __read_mostly *genapic = &apic_flat;
diff -ru linux-2.6/arch/x86/kernel/mpparse_64.c linux-2.6-working/arch/x86/kernel/mpparse_64.c
--- linux-2.6/arch/x86/kernel/mpparse_64.c	2008-02-14 16:32:55.000000000 -0600
+++ linux-2.6-working/arch/x86/kernel/mpparse_64.c	2008-02-14 15:45:44.000000000 -0600
@@ -67,7 +67,7 @@
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map = PHYSID_MASK_NONE;
 
-u16 x86_bios_cpu_apicid_init[NR_CPUS] __initdata
+u8 x86_bios_cpu_apicid_init[NR_CPUS] __initdata
 				= { [0 ... NR_CPUS-1] = BAD_APICID };
 void *x86_bios_cpu_apicid_early_ptr;
 DEFINE_PER_CPU(u16, x86_bios_cpu_apicid) = BAD_APICID;
diff -ru linux-2.6/include/asm-x86/smp_64.h linux-2.6-working/include/asm-x86/smp_64.h
--- linux-2.6/include/asm-x86/smp_64.h	2008-02-14 16:33:04.000000000 -0600
+++ linux-2.6-working/include/asm-x86/smp_64.h	2008-02-14 15:43:01.000000000 -0600
@@ -26,15 +26,16 @@
 extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
 				  void *info, int wait);
 
-extern u16 __initdata x86_cpu_to_apicid_init[];
-extern u16 __initdata x86_bios_cpu_apicid_init[];
+extern u8 __initdata x86_cpu_to_apicid_init[];
+extern u8 __initdata x86_bios_cpu_apicid_init[];
 extern void *x86_cpu_to_apicid_early_ptr;
 extern void *x86_bios_cpu_apicid_early_ptr;
+DECLARE_PER_CPU(u8, x86_cpu_to_apicid); /* physical ID */
+extern u8 bios_cpu_apicid[];
 
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_t, cpu_core_map);
 DECLARE_PER_CPU(u16, cpu_llc_id);
-DECLARE_PER_CPU(u16, x86_cpu_to_apicid);
 DECLARE_PER_CPU(u16, x86_bios_cpu_apicid);
 
 static inline int cpu_present_to_apicid(int mps_cpu)

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: attachment; filename="bl613_2.6.24-mm1_acpidebug.txt"

Linux version 2.6.24-mm1-autokern1 (root@bl6-13.ltc.austin.ibm.com) (gcc version 4.1.1 20060525 (Red Hat 4.1.1-1)) #1 SMP Thu Feb 14 18:26:36 CST 2008
Command line: ro root=/dev/VolGroup00/LogVol00 console=tty0 console=ttyS1,19200 selinux=no autobench_args: root=/dev/mapper/VolGroup00-LogVol00 ABAT:1203036811 loglevel=8 acpi=debug
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
 BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ffcddc0 (usable)
 BIOS-e820: 000000003ffcddc0 - 000000003ffd0000 (ACPI data)
 BIOS-e820: 000000003ffd0000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Malformed early option 'loglevel'
Malformed early option 'acpi'
Entering add_active_range(0, 0, 157) 0 entries of 3200 used
Entering add_active_range(0, 256, 262093) 1 entries of 3200 used
end_pfn_map = 1048576
DMI 2.3 present.
ACPI: RSDP 000FDFC0, 0014 (r0 IBM   )
ACPI: RSDT 3FFCFF80, 0034 (r1 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: FACP 3FFCFEC0, 0084 (r2 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: DSDT 3FFCDDC0, 1EA6 (r1 IBM    SERBLADE     1000 INTL  2002025)
ACPI: FACS 3FFCFCC0, 0040
ACPI: APIC 3FFCFE00, 009C (r1 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: SRAT 3FFCFD40, 0098 (r1 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: HPET 3FFCFD00, 0038 (r1 IBM    SERBLADE     1000 IBM  45444F43)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-40000000
Entering add_active_range(0, 0, 157) 0 entries of 3200 used
Entering add_active_range(0, 256, 262093) 1 entries of 3200 used
NUMA: Using 63 for the hash shift.
Bootmem setup node 0 0000000000000000-000000003ffcd000
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-a0566f] TEXT DATA BSS
early res: 3 [37e5f000-37fef97b] RAMDISK
early res: 4 [9d400-a03ff] EBDA
early res: 5 [8000-afff] PGTABLE
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001400000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810001c00000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002000000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002200000 on node 0
 [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002600000 on node 0
 [ffffe20001000000-ffffe200011fffff] PMD ->ffff810002800000 on node 0
 [ffffe20001200000-ffffe200013fffff] PMD ->ffff810002c00000 on node 0
 [ffffe20001400000-ffffe200015fffff] PMD ->ffff810002e00000 on node 0
 [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003200000 on node 0
 [ffffe20001800000-ffffe200019fffff] PMD ->ffff810003400000 on node 0
 [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810003800000 on node 0
 [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810003a00000 on node 0
 [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810003e00000 on node 0
 [ffffe20002000000-ffffe200021fffff] PMD ->ffff810004000000 on node 0
sizeof(struct page) = 136
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      157
    0:      256 ->   262093
On node 0 totalpages: 261994
  DMA zone: 136 pages used for memmap
  DMA zone: 2064 pages reserved
  DMA zone: 1797 pages, LIFO batch:0
  DMA32 zone: 8566 pages used for memmap
  DMA32 zone: 249431 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x2208
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 14, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x0d] address[0xfec10000] gsi_base[24])
IOAPIC[1]: apic_id 13, address 0xfec10000, GSI 24-27
ACPI: IOAPIC (id[0x0c] address[0xfec20000] gsi_base[48])
IOAPIC[2]: apic_id 12, address 0xfec20000, GSI 48-51
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ11 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x10228203 base: 0xfecff000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 65560 bytes of per cpu data
cpu with no node 2, num_online_nodes 1
cpu with no node 3, num_online_nodes 1
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 251228
Policy zone: DMA32
Kernel command line: ro root=/dev/VolGroup00/LogVol00 console=tty0 console=ttyS1,19200 selinux=no autobench_args: root=/dev/mapper/VolGroup00-LogVol00 ABAT:1203036811 loglevel=8 acpi=debug
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 1993.777 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS1] enabled
Checking aperture...
Node 0: aperture @ dc000000 size 64 MB
Node 1: aperture @ dc000000 size 64 MB
Memory: 1002864k/1048372k available (3149k kernel code, 45112k reserved, 1470k data, 396k init)
hpet clockevent registered
Calibrating delay using timer specific routine.. 3991.61 BogoMIPS (lpj=7983231)
Security Framework initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 12461103
Detected 12.461 MHz APIC timer.
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3987.60 BogoMIPS (lpj=7975215)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Dual Core AMD Opteron(tm) Processor 270 stepping 02
BUG: unable to handle kernel paging request at 0000000000007358
IP: [<ffffffff8026ceec>] __alloc_pages+0x4f/0x403
PGD 0 
Oops: 0000 [1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.24-mm1-autokern1 #1
RIP: 0010:[<ffffffff8026ceec>]  [<ffffffff8026ceec>] __alloc_pages+0x4f/0x403
RSP: 0000:ffff81003fa2fbc0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000000412d0 RCX: 0000000000007358
RDX: 0000000000000010 RSI: 0000000000000605 RDI: ffffffff805c3375
RBP: ffff81003fa2fc30 R08: 0000000000000000 R09: ffff81003fa2d060
R10: ffff81000000b000 R11: 000412d000000010 R12: 00000000000412d0
R13: 0000000000007350 R14: 0000000000000000 R15: ffff81003fa29340
FS:  0000000000000000(0000) GS:ffffffff80684000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000007358 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81003fa2e000, task ffff81003fa2d060)
Stack:  000000100000c5c8 ffffffff00000000 ffff81003fa2d060 0000000000007358
 000000003fa2fd60 0000000000000000 00000000000000d0 ffff81000000fa70
 0000000000000000 00000000000412d0 ffff81003f801080 0000000000000040
Call Trace:
 [<ffffffff8028ab2c>] kmem_getpages+0xd5/0x1ad
 [<ffffffff8028aed0>] cache_grow+0xa8/0x222
 [<ffffffff8028b2d8>] ____cache_alloc_node+0xff/0x125
 [<ffffffff8028adcf>] kmem_cache_alloc_node+0x114/0x144
 [<ffffffff8050ac1c>] cpuup_callback+0x8e/0x331
 [<ffffffff8050ffa6>] notifier_call_chain+0x33/0x65
 [<ffffffff8024a061>] __raw_notifier_call_chain+0x9/0xb
 [<ffffffff8050a269>] _cpu_up+0x6c/0x103
 [<ffffffff8050a357>] cpu_up+0x57/0x67
 [<ffffffff808ba689>] kernel_init+0xc5/0x2fe
 [<ffffffff8020cd88>] child_rip+0xa/0x12
 [<ffffffff8036d814>] ? acpi_ds_init_one_object+0x0/0x88
 [<ffffffff808ba5c4>] ? kernel_init+0x0/0x2fe
 [<ffffffff8020cd7e>] ? child_rip+0x0/0x12


Code: 00 83 e2 10 48 89 45 a0 89 55 94 74 16 be 05 06 00 00 48 c7 c7 75 33 5c 80 e8 cf db fb ff e8 4e f3 29 00 49 8d 4d 08 48 89 4d a8 <49> 83 7d 08 00 0f 84 39 03 00 00 44 89 e0 b9 44 00 00 00 4c 89 
RIP  [<ffffffff8026ceec>] __alloc_pages+0x4f/0x403
 RSP <ffff81003fa2fbc0>
CR2: 0000000000007358
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill init!


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: attachment; filename="bl613_2.6.24-mm1_patched.txt"

Linux version 2.6.24-mm1-autokern1 (root@bl6-13.ltc.austin.ibm.com) (gcc version 4.1.1 20060525 (Red Hat 4.1.1-1)) #1 SMP Thu Feb 14 17:38:43 CST 2008
Command line: ro root=/dev/VolGroup00/LogVol00 console=tty0 console=ttyS1,19200 selinux=no autobench_args: root=/dev/mapper/VolGroup00-LogVol00 ABAT:1203033940 loglevel=8
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
 BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ffcddc0 (usable)
 BIOS-e820: 000000003ffcddc0 - 000000003ffd0000 (ACPI data)
 BIOS-e820: 000000003ffd0000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Malformed early option 'loglevel'
Entering add_active_range(0, 0, 157) 0 entries of 3200 used
Entering add_active_range(0, 256, 262093) 1 entries of 3200 used
end_pfn_map = 1048576
DMI 2.3 present.
ACPI: RSDP 000FDFC0, 0014 (r0 IBM   )
ACPI: RSDT 3FFCFF80, 0034 (r1 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: FACP 3FFCFEC0, 0084 (r2 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: DSDT 3FFCDDC0, 1EA6 (r1 IBM    SERBLADE     1000 INTL  2002025)
ACPI: FACS 3FFCFCC0, 0040
ACPI: APIC 3FFCFE00, 009C (r1 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: SRAT 3FFCFD40, 0098 (r1 IBM    SERBLADE     1000 IBM  45444F43)
ACPI: HPET 3FFCFD00, 0038 (r1 IBM    SERBLADE     1000 IBM  45444F43)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-40000000
Entering add_active_range(0, 0, 157) 0 entries of 3200 used
Entering add_active_range(0, 256, 262093) 1 entries of 3200 used
NUMA: Using 63 for the hash shift.
Bootmem setup node 0 0000000000000000-000000003ffcd000
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-a0566f] TEXT DATA BSS
early res: 3 [37e5f000-37fef97f] RAMDISK
early res: 4 [9d400-a03ff] EBDA
early res: 5 [8000-afff] PGTABLE
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001400000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810001c00000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002000000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002200000 on node 0
 [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002600000 on node 0
 [ffffe20001000000-ffffe200011fffff] PMD ->ffff810002800000 on node 0
 [ffffe20001200000-ffffe200013fffff] PMD ->ffff810002c00000 on node 0
 [ffffe20001400000-ffffe200015fffff] PMD ->ffff810002e00000 on node 0
 [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003200000 on node 0
 [ffffe20001800000-ffffe200019fffff] PMD ->ffff810003400000 on node 0
 [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810003800000 on node 0
 [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810003a00000 on node 0
 [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810003e00000 on node 0
 [ffffe20002000000-ffffe200021fffff] PMD ->ffff810004000000 on node 0
sizeof(struct page) = 136
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      157
    0:      256 ->   262093
On node 0 totalpages: 261994
  DMA zone: 136 pages used for memmap
  DMA zone: 2064 pages reserved
  DMA zone: 1797 pages, LIFO batch:0
  DMA32 zone: 8566 pages used for memmap
  DMA32 zone: 249431 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x2208
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 14, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x0d] address[0xfec10000] gsi_base[24])
IOAPIC[1]: apic_id 13, address 0xfec10000, GSI 24-27
ACPI: IOAPIC (id[0x0c] address[0xfec20000] gsi_base[48])
IOAPIC[2]: apic_id 12, address 0xfec20000, GSI 48-51
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ11 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x10228203 base: 0xfecff000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 65560 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 251228
Policy zone: DMA32
Kernel command line: ro root=/dev/VolGroup00/LogVol00 console=tty0 console=ttyS1,19200 selinux=no autobench_args: root=/dev/mapper/VolGroup00-LogVol00 ABAT:1203033940 loglevel=8
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 1993.788 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS1] enabled
Checking aperture...
Node 0: aperture @ dc000000 size 64 MB
Node 1: aperture @ dc000000 size 64 MB
Memory: 1002864k/1048372k available (3149k kernel code, 45112k reserved, 1471k data, 396k init)
hpet clockevent registered
Calibrating delay using timer specific routine.. 3991.59 BogoMIPS (lpj=7983185)
Security Framework initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 12461170
Detected 12.461 MHz APIC timer.
__cpu_up: bad cpu 1
Booting processor 2/4 APIC 0x1
Initializing CPU#2
Calibrating delay using timer specific routine.. 3987.60 BogoMIPS (lpj=7975213)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Dual Core AMD Opteron(tm) Processor 270 stepping 02
__cpu_up: bad cpu 3
Brought up 2 CPUs
CPU0 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000005
  groups: 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000001 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000004
  domain 1: span 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000005
   groups: 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000005
CPU2 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000005
  groups: 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000004 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000001
  domain 1: span 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000005
   groups: 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000005
net_namespace: 1056 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LP00] (IRQs *10)
ACPI: PCI Interrupt Link [LP01] (IRQs *7)
ACPI: PCI Interrupt Link [LP02] (IRQs *9)
ACPI: PCI Interrupt Link [LP03] (IRQs *5)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
hpet0: at MMIO 0xfecff000, IRQs 2, 8, 1
hpet0: 3 32-bit timers, 14318180 Hz
Time: hpet clocksource has been installed.
system 00:01: ioport range 0x510-0x517 has been reserved
system 00:01: ioport range 0x504-0x507 has been reserved
system 00:01: ioport range 0x500-0x503 has been reserved
system 00:01: ioport range 0x520-0x53f has been reserved
system 00:01: ioport range 0x540-0x547 has been reserved
system 00:01: ioport range 0x460-0x461 has been reserved
system 00:0b: ioport range 0x400-0x47f could not be reserved
system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
system 00:0b: ioport range 0x540-0x55f could not be reserved
system 00:0b: ioport range 0x580-0x5ff has been reserved
system 00:0b: ioport range 0xca8-0xca8 has been reserved
system 00:0b: ioport range 0xcac-0xcac has been reserved
system 00:0b: ioport range 0xcb0-0xcb0 has been reserved
system 00:0b: ioport range 0xcb4-0xcb4 has been reserved
system 00:0b: ioport range 0xcc0-0xcdf has been reserved
system 00:0b: iomem range 0xfec00000-0xffffffff could not be reserved
PCI: Bridge: 0000:00:06.0
  IO window: 3000-3fff
  MEM window: 0xfd000000-0xfeafffff
  PREFETCH window: 0x00000000f0000000-0x00000000fcffffff
PCI: Bridge: 0000:00:0a.0
  IO window: 4000-4fff
  MEM window: 0xee000000-0xefffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0b.0
  IO window: 5000-ffff
  MEM window: disabled.
  PREFETCH window: disabled.
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 1602k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1203012607.688:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:0a.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
pci 0000:00:0b.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
pci 0000:01:04.0: Boot video device
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: ACPI0007:02 is registered as cooling_device0
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: ACPI0007:03 is registered as cooling_device1
ACPI: Processor [CPU0] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
hpet_resources: 0xfecff000 is busy
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
erial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:03: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
tg3.c:v3.87 (December 20, 2007)
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 24 (level, low) -> IRQ 24
eth0: Tigon3 [partno(BCM95704A41) rev 2100 PHY(serdes)] (PCIX:100MHz:64-bit) 1000Base-SX Ethernet 00:11:25:75:af:6e
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] WireSpeed[0] TSOcap[0]
eth0: dma_rwctrl[769f4000] dma_mask[64-bit]
ACPI: PCI Interrupt 0000:02:01.1[B] -> GSI 25 (level, low) -> IRQ 25
eth1: Tigon3 [partno(BCM95704A41) rev 2100 PHY(serdes)] (PCIX:100MHz:64-bit) 1000Base-SX Ethernet 00:11:25:75:af:6f
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
eth1: dma_rwctrl[769f4000] dma_mask[64-bit]
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
Probing IDE interface ide1...
ide2: I/O resource 0x0-0x7 not free.
ide2: ports already in use, skipping probe
ide3: I/O resource 0x0-0x7 not free.
ide3: ports already in use, skipping probe
ide4: I/O resource 0x0-0x7 not free.
ide4: ports already in use, skipping probe
ide5: I/O resource 0x0-0x7 not free.
ide5: ports already in use, skipping probe
ide6: I/O resource 0x0-0x7 not free.
ide6: ports already in use, skipping probe
ide7: I/O resource 0x0-0x7 not free.
ide7: ports already in use, skipping probe
ide8: I/O resource 0x0-0x7 not free.
ide8: ports already in use, skipping probe
ide9: I/O resource 0x0-0x7 not free.
ide9: ports already in use, skipping probe
ide-floppy driver 1.00
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 26 (level, low) -> IRQ 26
mptbase: ioc0: Initiating bringup
ioc0: LSI53C1030 C0: Capabilities={Initiator}
scsi0 : ioc0: LSI53C1030 C0, FwRev=01032700h, Ports=1, MaxQ=222, IRQ=26
scsi 0:0:0:0: Direct-Access     IBM-ESXS ST973401LC    FN B41D PQ: 0 ANSI: 4
 target0:0:0: Beginning Domain Validation
 target0:0:0: Ending Domain Validation
 target0:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU RTI WRFLOW PCOMP (6.25 ns, offset 63)
sd 0:0:0:0: [sda] 143374000 512-byte hardware sectors (73407 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: b3 00 10 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 0:0:0:0: [sda] 143374000 512-byte hardware sectors (73407 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: b3 00 10 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
Fusion MPT FC Host driver 3.04.06
Fusion MPT SAS Host driver 3.04.06
Fusion MPT misc device (ioctl) driver 3.04.06
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
Fusion MPT LAN driver 3.04.06
mptlan: ioc0: PortNum=0, ProtocolFlags=08h (Itlb)
mptlan: ioc0: Hmmm... LAN protocol seems to be disabled on this adapter port!
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:01:00.0[D] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:01:00.0: OHCI Host Controller
ohci_hcd 0000:01:00.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:01:00.0: irq 19, io mem 0xfeaff000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
ACPI: PCI Interrupt 0000:01:00.1[D] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:01:00.1: OHCI Host Controller
ohci_hcd 0000:01:00.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:01:00.1: irq 19, io mem 0xfeafe000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
USB Universal Host Controller Interface driver v3.0
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 1 Dual Core AMD Opteron(tm) Processor 270 processors (2 cpu cores) (version 2.20.00)
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
Freeing unused kernel memory: 396k freed
Write protecting the kernel read-only data: 1128k
Red Hat nash version 5.0.32 starting
Mounting proc filesystem
Mounting sysfs filesystem
Creating /dev
Creating initial device nodes
Setting up hotplug.
Creating block device nodes.
Making device-mapper control node
Scanning logical volumes
  Reading all physical volumes.  This may take a while...
  Found volume group "VolGroup00" using metadata type lvm2
Activating logical volumes
  4 logical volume(s) in volume group "VolGroup00" now active
Creating root device.
Mounting root filesystem.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Setting up other filesystems.
Setting up new root fs
no fstab.sys, mounting internal defaults
Switching to new root and running init.
unmounting old /dev
unmounting old /proc
unmounting old /sys
INIT: version 2.86 booting
                Welcome to Fedora Core
                Press 'I' to enter interactive startup.
Setting clock  (localtime): Thu Feb 14 18:10:27 CST 2008 [  OK  ]
Starting udev: [  OK  ]
Setting hostname bl6-13.ltc.austin.ibm.com:  [  OK  ]
Setting up Logical Volume Management:   4 logical volume(s) in volume group "VolGroup00" now active
[  OK  ]
Checking filesystems
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/VolGroup00/LogVol00 
/dev/VolGroup00/LogVol00: clean, 415267/7929856 files, 7058281/7929856 blocks
[/sbin/fsck.ext3 (1) -- /boot] fsck.ext3 -a /dev/sda1 
/boot: clean, 136/512512 files, 100080/512064 blocks
[  OK  ]
Remounting root filesystem in read-write mode:  [  OK  ]
Mounting local filesystems:  [  OK  ]
Enabling local filesystem quotas:  [  OK  ]
Enabling swap space:  [  OK  ]
INIT: Entering runlevel: 3
Entering non-interactive startup
Starting readahead_early:  Starting background readahead: [  OK  ]
[  OK  ]
FATAL: Error inserting acpi_cpufreq (/lib/modules/2.6.24-mm1-autokern1/kernel/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.ko): No such device
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth1:  udevd-event[1486]: wait_for_sysfs: waiting for '/sys/devices/platform/parport_pc.956/bus' failed
udevd-event[1487]: wait_for_sysfs: waiting for '/sys/devices/platform/parport_pc.888/bus' failed
udevd-event[1488]: wait_for_sysfs: waiting for '/sys/devices/platform/parport_pc.632/bus' failed
[  OK  ]
Starting system logger: [  OK  ]
Starting kernel logger: [  OK  ]
Starting irqbalance: [  OK  ]
Starting portmap: [  OK  ]
Starting NFS statd: [  OK  ]
Starting RPC idmapd: [  OK  ]
Starting kdump:  No kdump kernel image found.[WARNING]
Tried to locate /boot/vmlinux--kdump[  OK  ]
Starting system message bus: [  OK  ]
Starting Bluetooth services:[  OK  ][  OK  ]
Mounting other filesystems:  [  OK  ]
Starting hidd: [  OK  ]
Starting automount: [  OK  ]
Starting smartd: [  OK  ]
Starting acpi daemon: [  OK  ]
Starting hpiod: [  OK  ]
Starting hpssd: [  OK  ]
Starting cups: [  OK  ]
Starting sshd: [  OK  ]
Starting sendmail: [  OK  ]
Starting sm-client: [  OK  ]
Starting console mouse services: [  OK  ]
Starting crond: [  OK  ]
Starting xfs: [  OK  ]
Starting anacron: [  OK  ]
Starting atd: [  OK  ]
Starting Avahi daemon: [  OK  ]
Starting cups-config-daemon: [  OK  ]
Starting HAL daemon: [  OK  ]

Fedora Core release 5 (Bordeaux)
Kernel 2.6.24-mm1-autokern1 on an x86_64

bl6-13.ltc.austin.ibm.com login: -- 0:conmux-control -- time-stamp -- Feb/14/08 16:10:17 --
(bot:conmon-payload) disconnected


--LZvS9be/3tNcYl/X--
