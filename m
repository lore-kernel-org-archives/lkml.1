Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbZCMPqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbZCMPqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 11:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbZCMPqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 11:46:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:48347 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbZCMPq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 11:46:26 -0400
Subject: Re: [tip:x86/mtrr] x86: more MTRR debug printouts
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: mingo@redhat.com
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, yinghai@kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <1236958403.2646.1.camel@ht.satnam>
References: <49B9BA5A.40108@kernel.org>
	 <tip-8ad9790588ee2e69118b2b294ddab6f3f0379ad9@git.kernel.org>
	 <1236958403.2646.1.camel@ht.satnam>
Content-Type: multipart/mixed; boundary="=-tOfTf3byOS0vZgxEWcX+"
Date: Fri, 13 Mar 2009 21:15:21 +0530
Message-Id: <1236959121.2646.3.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tOfTf3byOS0vZgxEWcX+
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2009-03-13 at 21:03 +0530, Jaswinder Singh Rajput wrote:
> On Fri, 2009-03-13 at 02:34 +0000, Yinghai Lu wrote:
> > Commit-ID:  8ad9790588ee2e69118b2b294ddab6f3f0379ad9
> > Gitweb:     http://git.kernel.org/tip/8ad9790588ee2e69118b2b294ddab6f3f0379ad9
> > Author:     Yinghai Lu <yinghai@kernel.org>
> > AuthorDate: Thu, 12 Mar 2009 18:43:54 -0700
> > Commit:     Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 13 Mar 2009 02:52:18 +0100
> > 
> > x86: more MTRR debug printouts
> > 
> > Impact: improve MTRR debugging messages
> > 
> > There's still inefficiencies suspected with the MTRR sanitizing
> > code, so make sure we get all the info we need from a dmesg.
> > 
> > - Remove unneeded mtrr_show
> > 
> >  (It will only printout one time by first cpu, so it is no big deal.)
> > 
> > - Also print out directly from get_mtrr, because it doesn't update mtrr_state.
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > LKML-Reference: <49B9BA5A.40108@kernel.org>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > 
> >  		*base = 0;
> > @@ -407,6 +410,10 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
> >  	*size = -mask_lo;
> >  	*base = base_hi << (32 - PAGE_SHIFT) | base_lo >> PAGE_SHIFT;
> >  	*type = base_lo & 0xff;
> > +
> > +	printk(KERN_DEBUG "  get_mtrr: cpu%d reg%02d base=%010lx size=%010lx %s\n",
> > +			smp_processor_id(), reg, *base, *size,
> > +			mtrr_attrib_to_str(*type & 0xff));
> >  }
> >  
> 
> This leads to:
> 
> Kernel failure message 1:
> BUG: using smp_processor_id() in preemptible [00000000] code: Xorg/1983
> caller is generic_get_mtrr+0x12a/0x146
> Pid: 1983, comm: Xorg Not tainted 2.6.29-rc8-tip #81 SMP PREEMPT Fri Mar
> 13 20:43:36 IST 2009
> Call Trace:
>  [<c0412cc3>] ? printk+0x14/0x16
>  [<c02357e3>] debug_smp_processor_id+0xbb/0xd4
>  [<c010f0c3>] generic_get_mtrr+0x12a/0x146
>  [<c010e351>] mtrr_add_page+0x154/0x332
>  [<c010e7b1>] mtrr_file_add+0x72/0x86
>  [<c010e9e0>] mtrr_ioctl+0x21b/0x309
>  [<c01bc07d>] proc_reg_unlocked_ioctl+0x67/0xb2
>  [<c010e7c5>] ? mtrr_ioctl+0x0/0x309
>  [<c01bc016>] ? proc_reg_unlocked_ioctl+0x0/0xb2
>  [<c0194101>] vfs_ioctl+0x27/0x6e
>  [<c0194680>] do_vfs_ioctl+0x46f/0x4a9
>  [<c017bfa5>] ? do_mmap_pgoff+0x1e3/0x22e
>  [<c01898b0>] ? fget_light+0x40/0x130
>  [<c01946ee>] sys_ioctl+0x34/0x61
>  [<c0102c73>] sysenter_do_call+0x12/0x25
> 

This is beautiful dmesg:

[    0.000000] Linux version 2.6.29-rc8-tip (jaswinder@ht.satnam) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #81 SMP PREEMPT Fri Mar 13 20:43:36 IST 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ff2fc00 (usable)
[    0.000000]  BIOS-e820: 000000003ff2fc00 - 000000003ff30000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ff30000 - 000000003ff40000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ff40000 - 000000003fff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff0000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fecf0000 - 00000000fecf1000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] last_pfn = 0x3ff2f max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-0FFFF write-back
[    0.000000]   10000-1FFFF write-back
[    0.000000]   20000-2FFFF write-back
[    0.000000]   30000-3FFFF write-back
[    0.000000]   40000-4FFFF write-back
[    0.000000]   50000-5FFFF write-back
[    0.000000]   60000-6FFFF write-back
[    0.000000]   70000-7FFFF write-back
[    0.000000]   80000-83FFF write-back
[    0.000000]   84000-87FFF write-back
[    0.000000]   88000-8BFFF write-back
[    0.000000]   8C000-8FFFF write-back
[    0.000000]   90000-93FFF write-back
[    0.000000]   94000-97FFF write-back
[    0.000000]   98000-9BFFF write-back
[    0.000000]   9C000-9FFFF write-back
[    0.000000]   A0000-A3FFF uncachable
[    0.000000]   A4000-A7FFF uncachable
[    0.000000]   A8000-ABFFF uncachable
[    0.000000]   AC000-AFFFF uncachable
[    0.000000]   B0000-B3FFF uncachable
[    0.000000]   B4000-B7FFF uncachable
[    0.000000]   B8000-BBFFF uncachable
[    0.000000]   BC000-BFFFF uncachable
[    0.000000]   C0000-C0FFF uncachable
[    0.000000]   C1000-C1FFF uncachable
[    0.000000]   C2000-C2FFF uncachable
[    0.000000]   C3000-C3FFF uncachable
[    0.000000]   C4000-C4FFF uncachable
[    0.000000]   C5000-C5FFF uncachable
[    0.000000]   C6000-C6FFF uncachable
[    0.000000]   C7000-C7FFF uncachable
[    0.000000]   C8000-C8FFF uncachable
[    0.000000]   C9000-C9FFF uncachable
[    0.000000]   CA000-CAFFF uncachable
[    0.000000]   CB000-CBFFF uncachable
[    0.000000]   CC000-CCFFF uncachable
[    0.000000]   CD000-CDFFF uncachable
[    0.000000]   CE000-CEFFF uncachable
[    0.000000]   CF000-CFFFF uncachable
[    0.000000]   D0000-D0FFF uncachable
[    0.000000]   D1000-D1FFF uncachable
[    0.000000]   D2000-D2FFF uncachable
[    0.000000]   D3000-D3FFF uncachable
[    0.000000]   D4000-D4FFF uncachable
[    0.000000]   D5000-D5FFF uncachable
[    0.000000]   D6000-D6FFF uncachable
[    0.000000]   D7000-D7FFF uncachable
[    0.000000]   D8000-D8FFF uncachable
[    0.000000]   D9000-D9FFF uncachable
[    0.000000]   DA000-DAFFF uncachable
[    0.000000]   DB000-DBFFF uncachable
[    0.000000]   DC000-DCFFF uncachable
[    0.000000]   DD000-DDFFF uncachable
[    0.000000]   DE000-DEFFF uncachable
[    0.000000]   DF000-DFFFF uncachable
[    0.000000]   E0000-E0FFF uncachable
[    0.000000]   E1000-E1FFF uncachable
[    0.000000]   E2000-E2FFF uncachable
[    0.000000]   E3000-E3FFF uncachable
[    0.000000]   E4000-E4FFF uncachable
[    0.000000]   E5000-E5FFF uncachable
[    0.000000]   E6000-E6FFF uncachable
[    0.000000]   E7000-E7FFF uncachable
[    0.000000]   E8000-E8FFF uncachable
[    0.000000]   E9000-E9FFF uncachable
[    0.000000]   EA000-EAFFF uncachable
[    0.000000]   EB000-EBFFF uncachable
[    0.000000]   EC000-ECFFF uncachable
[    0.000000]   ED000-EDFFF uncachable
[    0.000000]   EE000-EEFFF uncachable
[    0.000000]   EF000-EFFFF uncachable
[    0.000000]   F0000-F0FFF write-protect
[    0.000000]   F1000-F1FFF write-protect
[    0.000000]   F2000-F2FFF write-protect
[    0.000000]   F3000-F3FFF write-protect
[    0.000000]   F4000-F4FFF write-protect
[    0.000000]   F5000-F5FFF write-protect
[    0.000000]   F6000-F6FFF write-protect
[    0.000000]   F7000-F7FFF write-protect
[    0.000000]   F8000-F8FFF write-protect
[    0.000000]   F9000-F9FFF write-protect
[    0.000000]   FA000-FAFFF write-protect
[    0.000000]   FB000-FBFFF write-protect
[    0.000000]   FC000-FCFFF write-protect
[    0.000000]   FD000-FDFFF write-protect
[    0.000000]   FE000-FEFFF write-protect
[    0.000000]   FF000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]    1 disabled
[    0.000000]    2 disabled
[    0.000000]    3 disabled
[    0.000000]    4 disabled
[    0.000000]    5 disabled
[    0.000000]    6 disabled
[    0.000000]    7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000]   get_mtrr: cpu0 reg00 base=0000000000 size=0000040000 write-back
[    0.000000] Warning only 895MB will be used.
[    0.000000] Use a HIGHMEM enabled kernel.
[    0.000000] init_memory_mapping: 0000000000000000-0000000037f4d000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037c00000 page 2M
[    0.000000]  0037c00000 - 0037f4d000 page 4k
[    0.000000] kernel direct mapping tables up to 37f4d000 @ 7000-c000
[    0.000000] RAMDISK: 37ce3000 - 37fefe69
[    0.000000] Allocated new RAMDISK: 0063d000 - 00949e69
[    0.000000] Move RAMDISK from 0000000037ce3000 - 0000000037fefe68 to 0063d000 - 00949e68
[    0.000000] ACPI: RSDP 000F61E0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 3FF30000, 0038 (r1 INTEL  D865GBF  20040122 MSFT       97)
[    0.000000] ACPI: FACP 3FF30200, 0081 (r2 INTEL  D865GBF  20040122 MSFT       97)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT 3FF30370, 4231 (r1 INTEL  D865GBF         1 MSFT  100000D)
[    0.000000] ACPI: FACS 3FF40000, 0040
[    0.000000] ACPI: APIC 3FF30300, 0068 (r1 INTEL  D865GBF  20040122 MSFT       97)
[    0.000000] ACPI: ASF! 3FF345B0, 0099 (r16 LEGEND I865PASF        1 MSFT  100000D)
[    0.000000] ACPI: TCPA 3FF34649, 0034 (r1 INTEL  TBLOEMID        1 MSFT       97)
[    0.000000] ACPI: WDDT 3FF3467D, 0040 (r1 INTEL  OEMWDDT         1 MSFT  100000D)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 895MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37f4d000
[    0.000000]   low ram: 0 - 37f4d000
[    0.000000]   node 0 low ram: 00000000 - 37f4d000
[    0.000000]   node 0 bootmap 00008000 - 0000efec
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 0037f4d000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 0000639430]    TEXT DATA BSS ==> [0000100000 - 0000639430]
[    0.000000]   #4 [000063a000 - 000063d000]    INIT_PG_TABLE ==> [000063a000 - 000063d000]
[    0.000000]   #5 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
[    0.000000]   #7 [000063d000 - 0000949e69]      NEW RAMDISK ==> [000063d000 - 0000949e69]
[    0.000000]   #8 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
[    0.000000] found SMP MP-table at [c00ff780] ff780
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00037f4d
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00037f4d
[    0.000000] On node 0 totalpages: 229100
[    0.000000] free_area_init_node: node 0, pgdat c0541b00, node_mem_map c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 1759 pages used for memmap
[    0.000000]   Normal zone: 223342 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:becf0000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 13 pages at c1704000, static data 29852 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 227309
[    0.000000] Kernel command line: ro root=UUID=35775984-13c0-4e65-a754-6a2bfc5ce451 rhgb selinux=0 pause_on_oops=10000
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:512
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] TSC: PIT calibration matches PMTIMER. 1 loops
[    0.000000] Detected 2793.182 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000999] Memory: 899652k/916788k available (3163k kernel code, 16648k reserved, 1405k data, 320k init, 0k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
[    0.000999]     vmalloc : 0xf874d000 - 0xfff4d000   ( 120 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf7f4d000   ( 895 MB)
[    0.000999]       .init : 0xc057e000 - 0xc05ce000   ( 320 kB)
[    0.000999]       .data : 0xc0416e1c - 0xc05762fc   (1405 kB)
[    0.000999]       .text : 0xc0100000 - 0xc0416e1c   (3163 kB)
[    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.001010] Calibrating delay loop (skipped), value calculated using timer frequency.. 5586.36 BogoMIPS (lpj=2793182)
[    0.001270] Mount-cache hash table entries: 512
[    0.001540] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.001644] CPU: L2 cache: 1024K
[    0.001709] CPU: Physical Processor ID: 0
[    0.001775] CPU: Processor Core ID: 0
[    0.002007] using mwait in idle threads.
[    0.002088] Checking 'hlt' instruction... OK.
[    0.006556] Freeing SMP alternatives: 15k freed
[    0.006635] ACPI: Core revision 20081204
[    0.017482] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.017557] ftrace: allocating 14947 entries in 30 pages
[    0.019410] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.029496] CPU0: Intel(R) Pentium(R) 4 CPU 2.80GHz stepping 03
[    0.029999] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 5585.28 BogoMIPS (lpj=2792641)
[    0.000999] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.000999] CPU: L2 cache: 1024K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 0
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.101013] CPU1: Intel(R) Pentium(R) 4 CPU 2.80GHz stepping 03
[    0.101702] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.102059] Brought up 2 CPUs
[    0.102129] Total of 2 processors activated (11171.64 BogoMIPS).
[    0.103044] CPU0 attaching sched-domain:
[    0.103050]  domain 0: span 0-1 level SIBLING
[    0.103055]   groups: 0 1
[    0.103065] CPU1 attaching sched-domain:
[    0.103069]  domain 0: span 0-1 level SIBLING
[    0.103074]   groups: 1 0
[    0.103631] net_namespace: 892 bytes
[    0.103818] NET: Registered protocol family 16
[    0.104899] ACPI: bus type pci registered
[    0.106872] PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=2
[    0.106950] PCI: Using configuration type 1 for base access
[    0.116420] bio: create slab <bio-0> at 0
[    0.117854] ACPI: EC: Look up EC in DSDT
[    0.127470] ACPI: Interpreter enabled
[    0.127539] ACPI: (supports S0 S5)
[    0.127684] ACPI: Using IOAPIC for interrupt routing
[    0.139826] ACPI: No dock devices found.
[    0.139928] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.140139] pci 0000:00:00.0: reg 10 32bit mmio: [0xf8000000-0xfbffffff]
[    0.140300] pci 0000:00:1d.0: reg 20 io port: [0xcc00-0xcc1f]
[    0.140362] pci 0000:00:1d.1: reg 20 io port: [0xd000-0xd01f]
[    0.140428] pci 0000:00:1d.2: reg 20 io port: [0xd400-0xd41f]
[    0.140490] pci 0000:00:1d.3: reg 20 io port: [0xd800-0xd81f]
[    0.140561] pci 0000:00:1d.7: reg 10 32bit mmio: [0xffaffc00-0xffafffff]
[    0.140629] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.140703] pci 0000:00:1d.7: PME# disabled
[    0.140872] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
[    0.140978] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH4 GPIO
[    0.141057] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    0.141067] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    0.141076] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    0.141085] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    0.141094] pci 0000:00:1f.1: reg 20 io port: [0xffa0-0xffaf]
[    0.141104] pci 0000:00:1f.1: reg 24 32bit mmio: [0x000000-0x0003ff]
[    0.141140] pci 0000:00:1f.2: reg 10 io port: [0xec00-0xec07]
[    0.141149] pci 0000:00:1f.2: reg 14 io port: [0xe800-0xe803]
[    0.141158] pci 0000:00:1f.2: reg 18 io port: [0xe400-0xe407]
[    0.141166] pci 0000:00:1f.2: reg 1c io port: [0xe000-0xe003]
[    0.141175] pci 0000:00:1f.2: reg 20 io port: [0xdc00-0xdc0f]
[    0.141235] pci 0000:00:1f.3: reg 20 io port: [0xc800-0xc81f]
[    0.141299] pci 0000:00:1f.5: reg 18 32bit mmio: [0xffaff800-0xffaff9ff]
[    0.141309] pci 0000:00:1f.5: reg 1c 32bit mmio: [0xffaff400-0xffaff4ff]
[    0.141345] pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
[    0.141418] pci 0000:00:1f.5: PME# disabled
[    0.141529] pci 0000:01:00.0: reg 10 32bit mmio: [0xe0000000-0xefffffff]
[    0.141538] pci 0000:01:00.0: reg 14 io port: [0xa800-0xa8ff]
[    0.141546] pci 0000:01:00.0: reg 18 32bit mmio: [0xff8f0000-0xff8fffff]
[    0.141567] pci 0000:01:00.0: reg 30 32bit mmio: [0xff8c0000-0xff8dffff]
[    0.141593] pci 0000:01:00.0: supports D1 D2
[    0.141638] pci 0000:00:01.0: bridge io port: [0xa000-0xafff]
[    0.141644] pci 0000:00:01.0: bridge 32bit mmio: [0xff800000-0xff8fffff]
[    0.141650] pci 0000:00:01.0: bridge 32bit mmio pref: [0xd6b00000-0xf6afffff]
[    0.141693] pci 0000:02:02.0: reg 10 io port: [0xb800-0xb8ff]
[    0.141703] pci 0000:02:02.0: reg 14 32bit mmio: [0xff9ffc00-0xff9ffcff]
[    0.141731] pci 0000:02:02.0: reg 30 32bit mmio: [0xff9c0000-0xff9dffff]
[    0.141754] pci 0000:02:02.0: supports D1 D2
[    0.141758] pci 0000:02:02.0: PME# supported from D1 D2 D3hot D3cold
[    0.141831] pci 0000:02:02.0: PME# disabled
[    0.142010] pci 0000:00:1e.0: transparent bridge
[    0.142082] pci 0000:00:1e.0: bridge io port: [0xb000-0xbfff]
[    0.142089] pci 0000:00:1e.0: bridge 32bit mmio: [0xff900000-0xff9fffff]
[    0.142108] pci_bus 0000:00: on NUMA node 0
[    0.142117] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.142232] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.142308] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.147132] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.147876] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
[    0.148629] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.149399] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.150163] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.150969] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.151767] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.152602] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    0.153349] ACPI: Power Resource [URP1] (off)
[    0.153482] ACPI: Power Resource [FDDP] (off)
[    0.153602] ACPI: Power Resource [LPTP] (off)
[    0.154580] usbcore: registered new interface driver usbfs
[    0.154798] usbcore: registered new interface driver hub
[    0.154987] usbcore: registered new device driver usb
[    0.155542] PCI: Using ACPI for IRQ routing
[    0.160172] Warning: could not register annotated branches stats
[    0.164014] pnp: PnP ACPI init
[    0.164095] ACPI: bus type pnp registered
[    0.170284] pnp: PnP ACPI: found 14 devices
[    0.170353] ACPI: ACPI bus type pnp unregistered
[    0.170442] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[    0.170523] system 00:0c: ioport range 0x400-0x47f has been reserved
[    0.170595] system 00:0c: ioport range 0x680-0x6ff has been reserved
[    0.170667] system 00:0c: ioport range 0x500-0x53f has been reserved
[    0.170739] system 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.170814] system 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.170888] system 00:0c: iomem range 0xfed20000-0xfed9ffff has been reserved
[    0.170974] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.171058] system 00:0d: iomem range 0xc0000-0xdffff could not be reserved
[    0.171131] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[    0.171204] system 00:0d: iomem range 0x100000-0x3fffffff could not be reserved
[    0.206784] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.206857] pci 0000:00:01.0:   IO window: 0xa000-0xafff
[    0.206931] pci 0000:00:01.0:   MEM window: 0xff800000-0xff8fffff
[    0.207013] pci 0000:00:01.0:   PREFETCH window: 0x000000d6b00000-0x000000f6afffff
[    0.207117] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
[    0.207189] pci 0000:00:1e.0:   IO window: 0xb000-0xbfff
[    0.207262] pci 0000:00:1e.0:   MEM window: 0xff900000-0xff9fffff
[    0.207335] pci 0000:00:1e.0:   PREFETCH window: 0x00000050000000-0x000000500fffff
[    0.207451] pci 0000:00:1e.0: setting latency timer to 64
[    0.207459] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.207464] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.207468] pci_bus 0000:01: resource 0 io:  [0xa000-0xafff]
[    0.207472] pci_bus 0000:01: resource 1 mem: [0xff800000-0xff8fffff]
[    0.207477] pci_bus 0000:01: resource 2 mem: [0xd6b00000-0xf6afffff]
[    0.207481] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.207485] pci_bus 0000:02: resource 0 io:  [0xb000-0xbfff]
[    0.207490] pci_bus 0000:02: resource 1 mem: [0xff900000-0xff9fffff]
[    0.207494] pci_bus 0000:02: resource 2 mem: [0x50000000-0x500fffff]
[    0.207498] pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
[    0.207503] pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffff]
[    0.207581] NET: Registered protocol family 2
[    0.219052] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.219362] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.220122] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.220672] TCP: Hash tables configured (established 131072 bind 65536)
[    0.220744] TCP reno registered
[    0.223114] NET: Registered protocol family 1
[    0.223279] Unpacking initramfs... done
[    0.368226] Freeing initrd memory: 3123k freed
[    0.372885] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.374075] JFS: nTxBlock = 7053, nTxLock = 56430
[    0.378762] msgmni has been set to 1763
[    0.378858] io scheduler noop registered
[    0.378930] io scheduler anticipatory registered
[    0.379010] io scheduler deadline registered
[    0.379130] io scheduler cfq registered (default)
[    0.379324] pci 0000:01:00.0: Boot video device
[    0.379730] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.379800] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.382998] input: Power Button (FF) as /class/input/input0
[    0.383073] ACPI: Power Button (FF) [PWRF]
[    0.383330] input: Sleep Button (CM) as /class/input/input1
[    0.383407] ACPI: Sleep Button (CM) [SLPB]
[    0.383983] processor ACPI_CPU:00: registered as cooling_device0
[    0.384058] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.384367] processor ACPI_CPU:01: registered as cooling_device1
[    0.384444] ACPI: Processor [CPU2] (supports 8 throttling states)
[    0.402158] Real Time Clock Driver v1.12b
[    0.402312] Non-volatile memory driver v1.3
[    0.402450] intel_rng: Firmware space is locked read-only. If you can't or
[    0.402453] intel_rng: don't want to disable this in firmware setup, and if
[    0.402454] intel_rng: you are certain that your system has a functional
[    0.402456] intel_rng: RNG, try using the 'no_fwh_detect' option.
[    0.402729] Linux agpgart interface v0.103
[    0.402926] agpgart-intel 0000:00:00.0: Intel 865 Chipset
[    0.406257] agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0xf8000000
[    0.406511] [drm] Initialized drm 1.1.0 20060810
[    0.407144] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.407246]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[    0.407253]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[    0.407909] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[    0.408701] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.656995] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.657889] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.659870] loop: module loaded
[    0.660133] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k6-NAPI
[    0.660204] e100: Copyright(c) 1999-2006 Intel Corporation
[    0.660697] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.660788] r8169 0000:02:02.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.660901] r8169 0000:02:02.0: no PCI Express capability
[    0.661179] r8169 0000:02:02.0: MAC address found in EEPROM: 00:14:d1:16:46:5e
[    0.661468] eth0: RTL8169sb/8110sb at 0xf8b9ec00, 00:14:d1:16:46:5e, XID 10000000 IRQ 17
[    0.662153] Linux video capture interface: v2.00
[    0.662292] gspca: main v2.4.0 registered
[    0.662442] usbcore: registered new interface driver ov519
[    0.662514] ov519: registered
[    0.663227] Uniform Multi-Platform E-IDE driver
[    0.663477] piix 0000:00:1f.1: IDE controller (0x8086:0x24db rev 0x02)
[    0.663555] pci 0000:00:1f.1: enabling device (0005 -> 0007)
[    0.663631] pci 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.663723] piix 0000:00:1f.1: not 100% native mode: will probe irqs later
[    0.663854]     ide0: BM-DMA at 0xffa0-0xffa7
[    0.663933]     ide1: BM-DMA at 0xffa8-0xffaf
[    0.664005] Probing IDE interface ide0...
[    0.706801] Switched to high resolution mode on CPU 1
[    0.706894] Switched to high resolution mode on CPU 0
[    0.928399] hda: SAMSUNG SP0802N, ATA DISK drive
[    1.540365] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    1.540438] hda: UDMA/100 mode selected
[    1.540567] Probing IDE interface ide1...
[    2.212398] hdc: DVD RW DRU-820A, ATAPI CD/DVD-ROM drive
[    2.926399] hdd: HL-DT-ST GCE-8525B, ATAPI CD/DVD-ROM drive
[    2.977363] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    2.978265] hdc: host side 80-wire cable detection failed, limiting max speed to UDMA33
[    2.978365] hdc: UDMA/33 mode selected
[    2.979332] hdd: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    2.979421] hdd: UDMA/33 mode selected
[    2.979631] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    2.979774] ide1 at 0x170-0x177,0x376 on irq 15
[    2.980835] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    2.981022] ide-gd driver 1.18
[    2.981122] hda: max request size: 512KiB
[    2.993093] hda: 156368016 sectors (80060 MB) w/2048KiB Cache, CHS=16383/255/63
[    2.993479] hda: cache flushes supported
[    2.993605]  hda: hda1 hda2 hda3 hda4 < hda5 >
[    3.014657] ide-cd driver 5.00
[    3.019754] ide-cd: hdc: ATAPI 40X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
[    3.020063] Uniform CD-ROM driver Revision: 3.20
[    3.028216] ide-cd: hdd: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache
[    3.034610] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.034721] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    3.034815] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.034822] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.035015] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    3.039039] ehci_hcd 0000:00:1d.7: debug port 1
[    3.039114] ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
[    3.039136] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xffaffc00
[    3.049014] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.049284] usb usb1: configuration #1 chosen from 1 choice
[    3.049466] hub 1-0:1.0: USB hub found
[    3.049545] hub 1-0:1.0: 8 ports detected
[    3.050131] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.050290] uhci_hcd: USB Universal Host Controller Interface driver
[    3.050408] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.050487] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.050492] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.050654] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.050783] uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000cc00
[    3.051049] usb usb2: configuration #1 chosen from 1 choice
[    3.051227] hub 2-0:1.0: USB hub found
[    3.051308] hub 2-0:1.0: 2 ports detected
[    3.051720] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.051798] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.051803] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.051964] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    3.052114] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d000
[    3.052379] usb usb3: configuration #1 chosen from 1 choice
[    3.052558] hub 3-0:1.0: USB hub found
[    3.052637] hub 3-0:1.0: 2 ports detected
[    3.053068] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.053147] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.053153] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.053330] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    3.053457] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d400
[    3.053708] usb usb4: configuration #1 chosen from 1 choice
[    3.053888] hub 4-0:1.0: USB hub found
[    3.053965] hub 4-0:1.0: 2 ports detected
[    3.054383] uhci_hcd 0000:00:1d.3: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.054467] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    3.054472] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    3.054633] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    3.054754] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000d800
[    3.055056] usb usb5: configuration #1 chosen from 1 choice
[    3.055233] hub 5-0:1.0: USB hub found
[    3.055317] hub 5-0:1.0: 2 ports detected
[    3.055904] usbcore: registered new interface driver libusual
[    3.056183] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    3.059236] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.059316] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.059510] mice: PS/2 mouse device common for all mice
[    3.067493] input: PC Speaker as /class/input/input2
[    3.075260] i2c /dev entries driver
[    3.075510] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.092604] input: AT Translated Set 2 keyboard as /class/input/input3
[    3.102212] cpuidle: using governor ladder
[    3.105390] usbcore: registered new interface driver hiddev
[    3.105556] usbcore: registered new interface driver usbhid
[    3.105629] usbhid: v2.6:USB HID core driver
[    3.105820] Advanced Linux Sound Architecture Driver Version 1.0.18a.
[    3.107819] Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.107954] Intel ICH 0000:00:1f.5: setting latency timer to 64
[    3.423013] intel8x0_measure_ac97_clock: measured 51220 usecs
[    3.423085] intel8x0: clocking to 48000
[    3.425114] ALSA device list:
[    3.425181]   #0: Intel ICH5 with AD1985 at irq 17
[    3.425412] oprofile: using NMI interrupt.
[    3.425567] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.425638] TCP cubic registered
[    3.425703] Initializing XFRM netlink socket
[    3.425880] NET: Registered protocol family 10
[    3.426297] IPv6 over IPv4 tunneling driver
[    3.426615] NET: Registered protocol family 17
[    3.426690] NET: Registered protocol family 15
[    3.426886] p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
[    3.426963] Using IPI Shortcut mode
[    3.427577] Freeing unused kernel memory: 320k freed
[    3.428082] Write protecting the kernel text: 3164k
[    3.428198] Write protecting the kernel read-only data: 1032k
[    3.761815] input: ImPS/2 Generic Wheel Mouse as /class/input/input4
[    4.247697] EXT3-fs: mounted filesystem with ordered data mode.
[    4.248025] kjournald starting.  Commit interval 5 seconds
[    6.704730] udevd version 127 started
[    9.733389] EXT3 FS on hda3, internal journal
[    9.842033] kjournald starting.  Commit interval 5 seconds
[    9.842102] EXT3 FS on hda2, internal journal
[    9.842112] EXT3-fs: mounted filesystem with ordered data mode.
[    9.854364] kjournald starting.  Commit interval 5 seconds
[    9.854428] EXT3 FS on hda1, internal journal
[    9.854436] EXT3-fs: mounted filesystem with ordered data mode.
[   11.033076] Adding 2096440k swap on /dev/hda5.  Priority:-1 extents:1 across:2096440k 
[   11.572917] microcode: CPU0 updated from revision 0x7 to 0xc, date = 2005-04-21 
[   26.335880] r8169: eth0: link up
[   30.485729] BUG: using smp_processor_id() in preemptible [00000000] code: Xorg/1983
[   30.485743] caller is generic_get_mtrr+0x12a/0x146
[   30.485750] Pid: 1983, comm: Xorg Not tainted 2.6.29-rc8-tip #81 SMP PREEMPT Fri Mar 13 20:43:36 IST 2009
[   30.485755] Call Trace:
[   30.485765]  [<c0412cc3>] ? printk+0x14/0x16
[   30.485775]  [<c02357e3>] debug_smp_processor_id+0xbb/0xd4
[   30.485781]  [<c010f0c3>] generic_get_mtrr+0x12a/0x146
[   30.485789]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.485796]  [<c010e96f>] mtrr_ioctl+0x1aa/0x309
[   30.485804]  [<c01bc07d>] proc_reg_unlocked_ioctl+0x67/0xb2
[   30.485810]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.485816]  [<c010e7c5>] ? mtrr_ioctl+0x0/0x309
[   30.485823]  [<c01bc016>] ? proc_reg_unlocked_ioctl+0x0/0xb2
[   30.485830]  [<c0194101>] vfs_ioctl+0x27/0x6e
[   30.485836]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.485842]  [<c0194680>] do_vfs_ioctl+0x46f/0x4a9
[   30.485850]  [<c01898b0>] ? fget_light+0x40/0x130
[   30.485856]  [<c01946ee>] sys_ioctl+0x34/0x61
[   30.485862]  [<c0102c73>] sysenter_do_call+0x12/0x25
[   30.485868]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.485874]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   30.485881] BUG: using smp_processor_id() in preemptible [00000000] code: Xorg/1983
[   30.485887] caller is generic_get_mtrr+0x12a/0x146
[   30.485892] Pid: 1983, comm: Xorg Not tainted 2.6.29-rc8-tip #81 SMP PREEMPT Fri Mar 13 20:43:36 IST 2009
[   30.485896] Call Trace:
[   30.485902]  [<c0412cc3>] ? printk+0x14/0x16
[   30.485909]  [<c02357e3>] debug_smp_processor_id+0xbb/0xd4
[   30.485916]  [<c010f0c3>] generic_get_mtrr+0x12a/0x146
[   30.485922]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.485928]  [<c010e96f>] mtrr_ioctl+0x1aa/0x309
[   30.485935]  [<c01bc07d>] proc_reg_unlocked_ioctl+0x67/0xb2
[   30.485941]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.485947]  [<c010e7c5>] ? mtrr_ioctl+0x0/0x309
[   30.485954]  [<c01bc016>] ? proc_reg_unlocked_ioctl+0x0/0xb2
[   30.485960]  [<c0194101>] vfs_ioctl+0x27/0x6e
[   30.485966]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.485972]  [<c0194680>] do_vfs_ioctl+0x46f/0x4a9
[   30.485978]  [<c01898b0>] ? fget_light+0x40/0x130
[   30.485985]  [<c01946ee>] sys_ioctl+0x34/0x61
[   30.485990]  [<c0102c73>] sysenter_do_call+0x12/0x25
[   30.485997]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.486004]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   30.486079] BUG: using smp_processor_id() in preemptible [00000000] code: Xorg/1983
[   30.486086] caller is generic_get_mtrr+0x12a/0x146
[   30.486091] Pid: 1983, comm: Xorg Not tainted 2.6.29-rc8-tip #81 SMP PREEMPT Fri Mar 13 20:43:36 IST 2009
[   30.486095] Call Trace:
[   30.486101]  [<c0412cc3>] ? printk+0x14/0x16
[   30.486107]  [<c02357e3>] debug_smp_processor_id+0xbb/0xd4
[   30.486114]  [<c010f0c3>] generic_get_mtrr+0x12a/0x146
[   30.486120]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.486125]  [<c010e96f>] mtrr_ioctl+0x1aa/0x309
[   30.486132]  [<c01bc07d>] proc_reg_unlocked_ioctl+0x67/0xb2
[   30.486138]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.486144]  [<c010e7c5>] ? mtrr_ioctl+0x0/0x309
[   30.486149]  [<c01bc016>] ? proc_reg_unlocked_ioctl+0x0/0xb2
[   30.486155]  [<c0194101>] vfs_ioctl+0x27/0x6e
[   30.486161]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.486167]  [<c0194680>] do_vfs_ioctl+0x46f/0x4a9
[   30.486173]  [<c017bfa5>] ? do_mmap_pgoff+0x1e3/0x22e
[   30.486179]  [<c01898b0>] ? fget_light+0x40/0x130
[   30.486185]  [<c01946ee>] sys_ioctl+0x34/0x61
[   30.486190]  [<c0102c73>] sysenter_do_call+0x12/0x25
[   30.486196]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.486201]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   30.486207] BUG: using smp_processor_id() in preemptible [00000000] code: Xorg/1983
[   30.486212] caller is generic_get_mtrr+0x12a/0x146
[   30.486217] Pid: 1983, comm: Xorg Not tainted 2.6.29-rc8-tip #81 SMP PREEMPT Fri Mar 13 20:43:36 IST 2009
[   30.486220] Call Trace:
[   30.486226]  [<c0412cc3>] ? printk+0x14/0x16
[   30.486232]  [<c02357e3>] debug_smp_processor_id+0xbb/0xd4
[   30.486239]  [<c010f0c3>] generic_get_mtrr+0x12a/0x146
[   30.486245]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.486269]  [<c010e96f>] mtrr_ioctl+0x1aa/0x309
[   30.486277]  [<c01bc07d>] proc_reg_unlocked_ioctl+0x67/0xb2
[   30.486283]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.486289]  [<c010e7c5>] ? mtrr_ioctl+0x0/0x309
[   30.486295]  [<c01bc016>] ? proc_reg_unlocked_ioctl+0x0/0xb2
[   30.486301]  [<c0194101>] vfs_ioctl+0x27/0x6e
[   30.486307]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.486313]  [<c0194680>] do_vfs_ioctl+0x46f/0x4a9
[   30.486319]  [<c017bfa5>] ? do_mmap_pgoff+0x1e3/0x22e
[   30.486325]  [<c01898b0>] ? fget_light+0x40/0x130
[   30.486331]  [<c01946ee>] sys_ioctl+0x34/0x61
[   30.486336]  [<c0102c73>] sysenter_do_call+0x12/0x25
[   30.486342]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.486348]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   30.497625] BUG: using smp_processor_id() in preemptible [00000000] code: Xorg/1983
[   30.497635] caller is generic_get_mtrr+0x12a/0x146
[   30.497641] Pid: 1983, comm: Xorg Not tainted 2.6.29-rc8-tip #81 SMP PREEMPT Fri Mar 13 20:43:36 IST 2009
[   30.497645] Call Trace:
[   30.497653]  [<c0412cc3>] ? printk+0x14/0x16
[   30.497661]  [<c02357e3>] debug_smp_processor_id+0xbb/0xd4
[   30.497667]  [<c010f0c3>] generic_get_mtrr+0x12a/0x146
[   30.497674]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.497680]  [<c010e96f>] mtrr_ioctl+0x1aa/0x309
[   30.497687]  [<c01bc07d>] proc_reg_unlocked_ioctl+0x67/0xb2
[   30.497694]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.497700]  [<c010e7c5>] ? mtrr_ioctl+0x0/0x309
[   30.497706]  [<c01bc016>] ? proc_reg_unlocked_ioctl+0x0/0xb2
[   30.497712]  [<c0194101>] vfs_ioctl+0x27/0x6e
[   30.497718]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.497724]  [<c0194680>] do_vfs_ioctl+0x46f/0x4a9
[   30.497731]  [<c017bfa5>] ? do_mmap_pgoff+0x1e3/0x22e
[   30.497738]  [<c01898b0>] ? fget_light+0x40/0x130
[   30.497743]  [<c01946ee>] sys_ioctl+0x34/0x61
[   30.497749]  [<c0102c73>] sysenter_do_call+0x12/0x25
[   30.497755]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.497761]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   30.497767] BUG: using smp_processor_id() in preemptible [00000000] code: Xorg/1983
[   30.497773] caller is generic_get_mtrr+0x12a/0x146
[   30.497778] Pid: 1983, comm: Xorg Not tainted 2.6.29-rc8-tip #81 SMP PREEMPT Fri Mar 13 20:43:36 IST 2009
[   30.497781] Call Trace:
[   30.497787]  [<c0412cc3>] ? printk+0x14/0x16
[   30.497794]  [<c02357e3>] debug_smp_processor_id+0xbb/0xd4
[   30.497801]  [<c010f0c3>] generic_get_mtrr+0x12a/0x146
[   30.497807]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.497813]  [<c010e96f>] mtrr_ioctl+0x1aa/0x309
[   30.497819]  [<c01bc07d>] proc_reg_unlocked_ioctl+0x67/0xb2
[   30.497825]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.497831]  [<c010e7c5>] ? mtrr_ioctl+0x0/0x309
[   30.497837]  [<c01bc016>] ? proc_reg_unlocked_ioctl+0x0/0xb2
[   30.497843]  [<c0194101>] vfs_ioctl+0x27/0x6e
[   30.497849]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.497855]  [<c0194680>] do_vfs_ioctl+0x46f/0x4a9
[   30.497861]  [<c017bfa5>] ? do_mmap_pgoff+0x1e3/0x22e
[   30.497867]  [<c01898b0>] ? fget_light+0x40/0x130
[   30.497873]  [<c01946ee>] sys_ioctl+0x34/0x61
[   30.497879]  [<c0102c73>] sysenter_do_call+0x12/0x25
[   30.497885]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.497890]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   30.510925]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   30.510932]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   30.510938]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   30.510943]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   30.511707]   get_mtrr: cpu1 reg02 base=00000e0000 size=0000010000 write-combining
[   30.512242]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   30.512249]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   30.512277]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   30.512282]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   30.513125]   get_mtrr: cpu1 reg02 base=00000e0000 size=0000010000 write-combining
[   30.679779] BUG: using smp_processor_id() in preemptible [00000000] code: Xorg/1983
[   30.679793] caller is generic_get_mtrr+0x12a/0x146
[   30.679800] Pid: 1983, comm: Xorg Not tainted 2.6.29-rc8-tip #81 SMP PREEMPT Fri Mar 13 20:43:36 IST 2009
[   30.679805] Call Trace:
[   30.679814]  [<c0412cc3>] ? printk+0x14/0x16
[   30.679823]  [<c02357e3>] debug_smp_processor_id+0xbb/0xd4
[   30.679830]  [<c010f0c3>] generic_get_mtrr+0x12a/0x146
[   30.679837]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.679844]  [<c010e96f>] mtrr_ioctl+0x1aa/0x309
[   30.679852]  [<c01bc07d>] proc_reg_unlocked_ioctl+0x67/0xb2
[   30.679858]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.679864]  [<c010e7c5>] ? mtrr_ioctl+0x0/0x309
[   30.679870]  [<c01bc016>] ? proc_reg_unlocked_ioctl+0x0/0xb2
[   30.679877]  [<c0194101>] vfs_ioctl+0x27/0x6e
[   30.679883]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.679889]  [<c0194680>] do_vfs_ioctl+0x46f/0x4a9
[   30.679896]  [<c017bfa5>] ? do_mmap_pgoff+0x1e3/0x22e
[   30.679903]  [<c01898b0>] ? fget_light+0x40/0x130
[   30.679909]  [<c01946ee>] sys_ioctl+0x34/0x61
[   30.679915]  [<c0102c73>] sysenter_do_call+0x12/0x25
[   30.679921]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.679927]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   30.679934] BUG: using smp_processor_id() in preemptible [00000000] code: Xorg/1983
[   30.679940] caller is generic_get_mtrr+0x12a/0x146
[   30.679945] Pid: 1983, comm: Xorg Not tainted 2.6.29-rc8-tip #81 SMP PREEMPT Fri Mar 13 20:43:36 IST 2009
[   30.679949] Call Trace:
[   30.679955]  [<c0412cc3>] ? printk+0x14/0x16
[   30.679961]  [<c02357e3>] debug_smp_processor_id+0xbb/0xd4
[   30.679968]  [<c010f0c3>] generic_get_mtrr+0x12a/0x146
[   30.679974]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.679980]  [<c010e96f>] mtrr_ioctl+0x1aa/0x309
[   30.679987]  [<c01bc07d>] proc_reg_unlocked_ioctl+0x67/0xb2
[   30.679993]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.679999]  [<c010e7c5>] ? mtrr_ioctl+0x0/0x309
[   30.680011]  [<c01bc016>] ? proc_reg_unlocked_ioctl+0x0/0xb2
[   30.680018]  [<c0194101>] vfs_ioctl+0x27/0x6e
[   30.680024]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.680030]  [<c0194680>] do_vfs_ioctl+0x46f/0x4a9
[   30.680036]  [<c017bfa5>] ? do_mmap_pgoff+0x1e3/0x22e
[   30.680042]  [<c01898b0>] ? fget_light+0x40/0x130
[   30.680048]  [<c01946ee>] sys_ioctl+0x34/0x61
[   30.680053]  [<c0102c73>] sysenter_do_call+0x12/0x25
[   30.680059]  [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
[   30.680065]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   30.687611] BUG: using smp_processor_id() in preemptible [00000000] code: Xorg/1983
[   30.687621] caller is generic_get_mtrr+0x12a/0x146
[   30.687627] Pid: 1983, comm: Xorg Not tainted 2.6.29-rc8-tip #81 SMP PREEMPT Fri Mar 13 20:43:36 IST 2009
[   30.687631] Call Trace:
[   30.687639]  [<c0412cc3>] ? printk+0x14/0x16
[   30.687648]  [<c02357e3>] debug_smp_processor_id+0xbb/0xd4
[   30.687654]  [<c010f0c3>] generic_get_mtrr+0x12a/0x146
[   30.687661]  [<c010e351>] mtrr_add_page+0x154/0x332
[   30.687667]  [<c010e7b1>] mtrr_file_add+0x72/0x86
[   30.687673]  [<c010e9e0>] mtrr_ioctl+0x21b/0x309
[   30.687680]  [<c01bc07d>] proc_reg_unlocked_ioctl+0x67/0xb2
[   30.687687]  [<c010e7c5>] ? mtrr_ioctl+0x0/0x309
[   30.687693]  [<c01bc016>] ? proc_reg_unlocked_ioctl+0x0/0xb2
[   30.687700]  [<c0194101>] vfs_ioctl+0x27/0x6e
[   30.687706]  [<c0194680>] do_vfs_ioctl+0x46f/0x4a9
[   30.687713]  [<c017bfa5>] ? do_mmap_pgoff+0x1e3/0x22e
[   30.687719]  [<c01898b0>] ? fget_light+0x40/0x130
[   30.687725]  [<c01946ee>] sys_ioctl+0x34/0x61
[   30.687732]  [<c0102c73>] sysenter_do_call+0x12/0x25
[   30.687737]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   30.687742] BUG: using smp_processor_id() in preemptible [00000000] code: Xorg/1983
[   30.687748] caller is generic_get_mtrr+0x12a/0x146
[   30.687752] Pid: 1983, comm: Xorg Not tainted 2.6.29-rc8-tip #81 SMP PREEMPT Fri Mar 13 20:43:36 IST 2009
[   30.687756] Call Trace:
[   30.687762]  [<c0412cc3>] ? printk+0x14/0x16
[   30.687769]  [<c02357e3>] debug_smp_processor_id+0xbb/0xd4
[   30.687778]  [<c010f0c3>] generic_get_mtrr+0x12a/0x146
[   30.687785]  [<c010e351>] mtrr_add_page+0x154/0x332
[   30.687791]  [<c010e7b1>] mtrr_file_add+0x72/0x86
[   30.687797]  [<c010e9e0>] mtrr_ioctl+0x21b/0x309
[   30.687803]  [<c01bc07d>] proc_reg_unlocked_ioctl+0x67/0xb2
[   30.687809]  [<c010e7c5>] ? mtrr_ioctl+0x0/0x309
[   30.687815]  [<c01bc016>] ? proc_reg_unlocked_ioctl+0x0/0xb2
[   30.687821]  [<c0194101>] vfs_ioctl+0x27/0x6e
[   30.687826]  [<c0194680>] do_vfs_ioctl+0x46f/0x4a9
[   30.687832]  [<c017bfa5>] ? do_mmap_pgoff+0x1e3/0x22e
[   30.687838]  [<c01898b0>] ? fget_light+0x40/0x130
[   30.687844]  [<c01946ee>] sys_ioctl+0x34/0x61
[   30.687850]  [<c0102c73>] sysenter_do_call+0x12/0x25
[   30.687855]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   30.687862]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   30.687867]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   30.693116]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   30.693125]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   30.693131]   get_mtrr: cpu1 reg02 base=00000e0000 size=0000008000 write-combining
[   30.765455]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   30.765462]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   30.765468]   get_mtrr: cpu1 reg02 base=00000e0000 size=0000008000 write-combining
[   30.765975]   get_mtrr: cpu1 reg02 base=00000e0000 size=0000010000 write-combining
[   30.766093]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   30.766100]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   30.766105]   get_mtrr: cpu1 reg02 base=00000e0000 size=0000010000 write-combining
[   30.766140]   get_mtrr: cpu1 reg02 base=00000e0000 size=0000010000 write-combining
[   30.766201]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   30.766206]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   30.766211]   get_mtrr: cpu1 reg02 base=00000e0000 size=0000010000 write-combining
[   30.767166] agpgart-intel 0000:00:00.0: AGP 3.0 bridge
[   30.767195] agpgart-intel 0000:00:00.0: putting AGP V3 device into 8x mode
[   30.767267] pci 0000:01:00.0: putting AGP V3 device into 8x mode
[   30.993633] [drm] Setting GART location based on new memory map
[   30.993645] [drm] Loading R200 Microcode
[   30.993684] [drm] writeback test succeeded in 1 usecs
[   36.596010] eth0: no IPv6 routers present


--=-tOfTf3byOS0vZgxEWcX+
Content-Disposition: attachment; filename="config-2.6.29-rc8-tip"
Content-Type: text/plain; name="config-2.6.29-rc8-tip"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.29-rc8
# Fri Mar 13 19:58:31 2009
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
CONFIG_CLASSIC_RCU=y
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUPS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
CONFIG_INITRAMFS_COMPRESSION_NONE=y
# CONFIG_INITRAMFS_COMPRESSION_GZIP is not set
# CONFIG_INITRAMFS_COMPRESSION_BZIP2 is not set
# CONFIG_INITRAMFS_COMPRESSION_LZMA is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
CONFIG_PERF_COUNTERS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_IBS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_SPARSE_IRQ is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
CONFIG_MPENTIUM4=y
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_32=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_X86_DS=y
CONFIG_X86_PTRACE_BTS=y
# CONFIG_HPET_TIMER is not set
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_CPU_DEBUG=m
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
# CONFIG_X86_PAE is not set
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=y
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
# CONFIG_NF_CONNTRACK is not set
CONFIG_NETFILTER_XTABLES=y
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_MATCH_ADDRTYPE is not set
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_TTL is not set
# CONFIG_IP_NF_FILTER is not set
# CONFIG_IP_NF_TARGET_LOG is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
# CONFIG_IP_NF_MANGLE is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_IP6_NF_QUEUE is not set
# CONFIG_IP6_NF_IPTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_PHONET is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
CONFIG_WIRELESS_OLD_REGULATORY=y
# CONFIG_WIRELESS_EXT is not set
# CONFIG_LIB80211 is not set
# CONFIG_MAC80211 is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set

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
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=y
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=y
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_ENC28J60 is not set
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
CONFIG_E100=y
CONFIG_FEALNX=y
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=y
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set
# CONFIG_IWLWIFI_LEDS is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_ISI is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_N_HDLC is not set
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_SX is not set
# CONFIG_RIO is not set
# CONFIG_STALDRV is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_CONSOLE is not set
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=y
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_SCx200_ACB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=y

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
# CONFIG_SPI_TLE62X0 is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
# CONFIG_MEDIA_ATTACH is not set
CONFIG_MEDIA_TUNER=y
# CONFIG_MEDIA_TUNER_CUSTOMIZE is not set
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_USB_VIDEO_CLASS is not set
CONFIG_USB_GSPCA=y
# CONFIG_USB_M5602 is not set
# CONFIG_USB_STV06XX is not set
# CONFIG_USB_GSPCA_CONEX is not set
# CONFIG_USB_GSPCA_ETOMS is not set
# CONFIG_USB_GSPCA_FINEPIX is not set
# CONFIG_USB_GSPCA_MARS is not set
CONFIG_USB_GSPCA_OV519=y
# CONFIG_USB_GSPCA_OV534 is not set
# CONFIG_USB_GSPCA_PAC207 is not set
# CONFIG_USB_GSPCA_PAC7311 is not set
# CONFIG_USB_GSPCA_SONIXB is not set
# CONFIG_USB_GSPCA_SONIXJ is not set
# CONFIG_USB_GSPCA_SPCA500 is not set
# CONFIG_USB_GSPCA_SPCA501 is not set
# CONFIG_USB_GSPCA_SPCA505 is not set
# CONFIG_USB_GSPCA_SPCA506 is not set
# CONFIG_USB_GSPCA_SPCA508 is not set
# CONFIG_USB_GSPCA_SPCA561 is not set
# CONFIG_USB_GSPCA_STK014 is not set
# CONFIG_USB_GSPCA_SUNPLUS is not set
# CONFIG_USB_GSPCA_T613 is not set
# CONFIG_USB_GSPCA_TV8532 is not set
# CONFIG_USB_GSPCA_VC032X is not set
# CONFIG_USB_GSPCA_ZC3XX is not set
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_VICAM is not set
# CONFIG_USB_IBMCAM is not set
# CONFIG_USB_KONICAWC is not set
# CONFIG_USB_QUICKCAM_MESSENGER is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_VIDEO_OVCAMCHIP is not set
# CONFIG_USB_OV511 is not set
# CONFIG_USB_SE401 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_STV680 is not set
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_PWC is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
# CONFIG_RADIO_ADAPTERS is not set
# CONFIG_DAB is not set

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
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
CONFIG_DRM_I810=y
CONFIG_DRM_I830=y
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

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
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_RTCTIMER=y
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_AC97_POWER_SAVE is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=y
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
CONFIG_SND_SOC=y
CONFIG_SND_SOC_I2C_AND_SPI=y
# CONFIG_SND_SOC_ALL_CODECS is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_COMPAT=y
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_EZKEY=y
CONFIG_HID_GYRATION=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_TOPSEED=y
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set

#
# OTG and related infrastructure
#
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_IDE_DISK=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_AUTOFS_FS=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ALLOW_WARNINGS=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_HW_BRANCH_TRACER=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y

#
# Tracers
#
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
# CONFIG_EVENT_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BOOT_TRACER=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_POWER_TRACER is not set
# CONFIG_STACK_TRACER is not set
CONFIG_HW_BRANCH_TRACER=y
# CONFIG_KMEMTRACE is not set
# CONFIG_WORKQUEUE_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_4KSTACKS is not set
CONFIG_DOUBLEFAULT=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
# CONFIG_CRYPTO_MANAGER is not set
# CONFIG_CRYPTO_MANAGER2 is not set
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_T10DIF is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--=-tOfTf3byOS0vZgxEWcX+--

