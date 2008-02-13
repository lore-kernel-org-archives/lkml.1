Return-Path: <linux-kernel-owner+w=401wt.eu-S1765948AbYBMSpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765948AbYBMSpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760644AbYBMSpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:45:40 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45813 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753330AbYBMSpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:45:38 -0500
Message-ID: <47B33ACF.5030700@sgi.com>
Date: Wed, 13 Feb 2008 10:45:35 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: 2.6.24 git2/mm1: cpu_to_node mapping to non-existant nodes causing
 boot failure
References: <20080203171634.58ab668b.akpm@linux-foundation.org> <20080213175241.GA327@csn.ul.ie>
In-Reply-To: <20080213175241.GA327@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On (03/02/08 17:16), Andrew Morton didst pronounce:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.24-mm1/
>>
> 
> bl6-13 (4-way x86_64 machine) from test.kernel.org is failing to boot recent
> -mm and mainline trees. I noticed it when testing -mm before rebasing other
> patches but the oops on mainline looks the same. The full console log is
> below but the important difference between a working and non-working kernel
> is the following
> 
> -PERCPU: Allocating 62512 bytes of per cpu data
> -Built 1 zonelists in Node order, mobility grouping on.  Total pages: 255875
> +PERCPU: Allocating 65560 bytes of per cpu data
> +cpu with no node 2, num_online_nodes 1
> +cpu with no node 3, num_online_nodes 1
> +Built 1 zonelists in Node order, mobility grouping on.  Total pages:
> 251257
> 
> "cpu with no node 2" is actually saying that cpu 2 has no node and the
> message is a just misleading. The number of online nodes and cpu mappings
> are not adding up as I got this from a debugging patch

I'll take a closer look though I've not been able to duplicate your
error yet.  It does appear from the message text that the code is
out-of-date.  The latest "setup_per_cpu_areas()" should say:

       "cpu %d has no node, num_online_nodes %d\n",
        i, num_online_nodes());

There are a number of backed up patches in the queue.  I'm resubmitting
the whole set re-based on 2.6.25-rc1 shortly.  (I don't know though, that
any will address this problem.)

Thanks,
Mike

> 
> Online nodes
>  o 0
> CPU <-> node mappings (cpu_to_node)
>  o CPU 0 -> 0
>  o CPU 1 -> 0
>  o CPU 2 -> 1
>  o CPU 3 -> 1
> 
> As the failing code in __alloc_pages() is;
> 
> restart:
>         z = zonelist->zones;  /* the list of zones suitable for gfp_mask */
>         if (unlikely(*z == NULL)) {
> 
> it implies that an attempt is been made to use an uninitialised zonelist.
> 
> If I bodge cpu_to_node() to returning 0,the machine boots but I didn't
> see an obvious candidate in origin.patch for the root-cause when I looked
> around. I'll bisect this in the morning if this is not a known problem
> and no one suggests a possibility.

The 
> 
> Linux version 2.6.24-mm1-autokern1 (root@bl6-13.ltc.austin.ibm.com) (gcc version 4.1.1 20060525 (Red Hat 4.1.1-1)) #1 SMP Wed Feb 13 08:15:47 CST 2008
> Command line: ro root=/dev/VolGroup00/LogVol00 console=tty0 console=ttyS1,19200 selinux=no autobench_args: root=/dev/mapper/VolGroup00-LogVol00 ABAT:1202913709 earlyprintk=serial,ttyS1,19200
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
>  BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000003ffcddc0 (usable)
>  BIOS-e820: 000000003ffcddc0 - 000000003ffd0000 (ACPI data)
>  BIOS-e820: 000000003ffd0000 - 0000000040000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> console [earlyser0] enabled
> end_pfn_map = 1048576
> kernel direct mapping tables up to 100000000 @ 8000-d000
> DMI 2.3 present.
> ACPI: RSDP 000FDFC0, 0014 (r0 IBM   )
> ACPI: RSDT 3FFCFF80, 0034 (r1 IBM    SERBLADE     1000 IBM  45444F43)
> ACPI: FACP 3FFCFEC0, 0084 (r2 IBM    SERBLADE     1000 IBM  45444F43)
> ACPI: DSDT 3FFCDDC0, 1EA6 (r1 IBM    SERBLADE     1000 INTL  2002025)
> ACPI: FACS 3FFCFCC0, 0040
> ACPI: APIC 3FFCFE00, 009C (r1 IBM    SERBLADE     1000 IBM  45444F43)
> ACPI: SRAT 3FFCFD40, 0098 (r1 IBM    SERBLADE     1000 IBM  45444F43)
> ACPI: HPET 3FFCFD00, 0038 (r1 IBM    SERBLADE     1000 IBM  45444F43)
> SRAT: PXM 0 -> APIC 0 -> Node 0
> SRAT: PXM 0 -> APIC 1 -> Node 0
> SRAT: PXM 1 -> APIC 2 -> Node 1
> SRAT: PXM 1 -> APIC 3 -> Node 1
> SRAT: Node 0 PXM 0 0-40000000
> Bootmem setup node 0 0000000000000000-000000003ffcd000
> early res: 0 [0-fff] BIOS data page
> early res: 1 [6000-7fff] SMP_TRAMPOLINE
> early res: 2 [200000-9e87ef] TEXT DATA BSS
> early res: 3 [37e5f000-37fef981] RAMDISK
> early res: 4 [9d400-a03ff] EBDA
> early res: 5 [8000-afff] PGTABLE
> Zone PFN ranges:
>   DMA             0 ->     4096
>   DMA32        4096 ->  1048576
>   Normal    1048576 ->  1048576
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0:        0 ->      157
>     0:      256 ->   262093
> Detected use of extended apic ids on hypertransport bus
> Detected use of extended apic ids on hypertransport bus
> ACPI: PM-Timer IO Port: 0x2208
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> Processor #0 (Bootup-CPU)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> Processor #1
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> Processor #2
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
> Processor #3
> ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
> ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 14, address 0xfec00000, GSI 0-23
> ACPI: IOAPIC (id[0x0d] address[0xfec10000] gsi_base[24])
> IOAPIC[1]: apic_id 13, address 0xfec10000, GSI 24-27
> ACPI: IOAPIC (id[0x0c] address[0xfec20000] gsi_base[48])
> IOAPIC[2]: apic_id 12, address 0xfec20000, GSI 48-51
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 low level)
> Setting APIC routing to flat
> ACPI: HPET id: 0x10228203 base: 0xfecff000
> Using ACPI (MADT) for SMP configuration information
> Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
> SMP: Allowing 4 CPUs, 0 hotplug CPUs
> PERCPU: Allocating 65560 bytes of per cpu data
> cpu with no node 2, num_online_nodes 1
> cpu with no node 3, num_online_nodes 1
> Built 1 zonelists in Node order, mobility grouping on.  Total pages: 251257
> Policy zone: DMA32
> Kernel command line: ro root=/dev/VolGroup00/LogVol00 console=tty0 console=ttyS1,19200 selinux=no autobench_args: root=/dev/mapper/VolGroup00-LogVol00 ABAT:1202913709 earlyprintk=serial,ttyS1,19200
> Initializing CPU#0
> PID hash table entries: 4096 (order: 12, 32768 bytes)
> TSC calibrated against PM_TIMER
> Marking TSC unstable due to TSCs unsynchronized
> time.c: Detected 1993.782 MHz processor.
> Console: colour VGA+ 80x25
> console [tty0] enabled
> Linux version 2.6.24-mm1-autokern1 (root@bl6-13.ltc.austin.ibm.com) (gcc version 4.1.1 20060525 (Red Hat 4.1.1-1)) #1 SMP Wed Feb 13 08:15:47 CST 2008
> Command line: ro root=/dev/VolGroup00/LogVol00 console=tty0 console=ttyS1,19200 selinux=no autobench_args: root=/dev/mapper/VolGroup00-LogVol00 ABAT:1202913709 earlyprintk=serial,ttyS1,19200
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
>  BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000003ffcddc0 (usable)
>  BIOS-e820: 000000003ffcddc0 - 000000003ffd0000 (ACPI data)
>  BIOS-e820: 000000003ffd0000 - 0000000040000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> console [earlyser0] enabled
> end_pfn_map = 1048576
> DMI 2.3 present.
> ACPI: RSDP 000FDFC0, 0014 (r0 IBM   )
> ACPI: RSDT 3FFCFF80, 0034 (r1 IBM    SERBLADE     1000 IBM  45444F43)
> ACPI: FACP 3FFCFEC0, 0084 (r2 IBM    SERBLADE     1000 IBM  45444F43)
> ACPI: DSDT 3FFCDDC0, 1EA6 (r1 IBM    SERBLADE     1000 INTL  2002025)
> ACPI: FACS 3FFCFCC0, 0040
> ACPI: APIC 3FFCFE00, 009C (r1 IBM    SERBLADE     1000 IBM  45444F43)
> ACPI: SRAT 3FFCFD40, 0098 (r1 IBM    SERBLADE     1000 IBM  45444F43)
> ACPI: HPET 3FFCFD00, 0038 (r1 IBM    SERBLADE     1000 IBM  45444F43)
> SRAT: PXM 0 -> APIC 0 -> Node 0
> SRAT: PXM 0 -> APIC 1 -> Node 0
> SRAT: PXM 1 -> APIC 2 -> Node 1
> SRAT: PXM 1 -> APIC 3 -> Node 1
> SRAT: Node 0 PXM 0 0-40000000
> Bootmem setup node 0 0000000000000000-000000003ffcd000
> early res: 0 [0-fff] BIOS data page
> early res: 1 [6000-7fff] SMP_TRAMPOLINE
> early res: 2 [200000-9e87ef] TEXT DATA BSS
> early res: 3 [37e5f000-37fef981] RAMDISK
> early res: 4 [9d400-a03ff] EBDA
> early res: 5 [8000-afff] PGTABLE
> Zone PFN ranges:
>   DMA             0 ->     4096
>   DMA32        4096 ->  1048576
>   Normal    1048576 ->  1048576
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0:        0 ->      157
>     0:      256 ->   262093
> Detected use of extended apic ids on hypertransport bus
> Detected use of extended apic ids on hypertransport bus
> ACPI: PM-Timer IO Port: 0x2208
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> Processor #0 (Bootup-CPU)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> Processor #1
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> Processor #2
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
> Processor #3
> ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
> ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 14, address 0xfec00000, GSI 0-23
> ACPI: IOAPIC (id[0x0d] address[0xfec10000] gsi_base[24])
> IOAPIC[1]: apic_id 13, address 0xfec10000, GSI 24-27
> ACPI: IOAPIC (id[0x0c] address[0xfec20000] gsi_base[48])
> IOAPIC[2]: apic_id 12, address 0xfec20000, GSI 48-51
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 low level)
> Setting APIC routing to flat
> ACPI: HPET id: 0x10228203 base: 0xfecff000
> Using ACPI (MADT) for SMP configuration information
> Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
> SMP: Allowing 4 CPUs, 0 hotplug CPUs
> PERCPU: Allocating 65560 bytes of per cpu data
> cpu with no node 2, num_online_nodes 1
> cpu with no node 3, num_online_nodes 1
> Built 1 zonelists in Node order, mobility grouping on.  Total pages: 251257
> Policy zone: DMA32
> Kernel command line: ro root=/dev/VolGroup00/LogVol00 console=tty0 console=ttyS1,19200 selinux=no autobench_args: root=/dev/mapper/VolGroup00-LogVol00 ABAT:1202913709 earlyprintk=serial,ttyS1,19200
> Initializing CPU#0
> PID hash table entries: 4096 (order: 12, 32768 bytes)
> TSC calibrated against PM_TIMER
> Marking TSC unstable due to TSCs unsynchronized
> time.c: Detected 1993.782 MHz processor.
> Console: colour VGA+ 80x25
> console [tty0] enabled
> Checking aperture...
> Node 0: aperture @ dc000000 size 64 MB
> Node 1: aperture @ dc000000 size 64 MB
> Memory: 1002980k/1048372k available (3034k kernel code, 44996k reserved, 1474k data, 392k init)
> Calibrating delay using timer specific routine.. 3991.54 BogoMIPS (lpj=7983093)
> Security Framework initialized
> SELinux:  Disabled at boot.
> Capability LSM initialized
> Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
> Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
> Mount-cache hash table entries: 256
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 1024K (64 bytes/line)
> CPU 0/0 -> Node 0
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> ACPI: Core revision 20070126
> Using local APIC timer interrupts.
> Detected 12.461 MHz APIC timer.
> Booting processor 1/4 APIC 0x1
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 3987.60 BogoMIPS (lpj=7975207)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 1024K (64 bytes/line)
> CPU 1/1 -> Node 0
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 1
> Dual Core AMD Opteron(tm) Processor 270 stepping 02
> BUG: unable to handle kernel paging request at 0000000000007358
> IP: [<ffffffff8026911a>] __alloc_pages+0x4f/0x3a9
> PGD 0 
> Oops: 0000 [1] SMP 
> last sysfs file: 
> CPU 0 
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.24-mm1-autokern1 #1
> RIP: 0010:[<ffffffff8026911a>]  [<ffffffff8026911a>] __alloc_pages+0x4f/0x3a9
> RSP: 0000:ffff81003fa2fc20  EFLAGS: 00010246
> RAX: 0000000000007358 RBX: 00000000000412d0 RCX: 0000000000000006
> RDX: 0000000000000010 RSI: 0000000000000605 RDI: ffffffff805a679a
> RBP: 00000000000412d0 R08: 0000000000000000 R09: ffff81003fa2d060
> R10: 0000000000000000 R11: ffff81003f8030c0 R12: 0000000000007350
> R13: 0000000000000000 R14: ffff81003fa29340 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffffffff80668000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000007358 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff81003fa2e000, task ffff81003fa2d060)
> Stack:  00000001ffffffff 0000001000000001 ffff81003fa2d060 0000000000007358
>  00000000000000d0 ffff81000000fa70 0000000000000000 ffffffff80242cd4
>  ffff81003fa2fe98 00000000000412d0 ffff81003f801080 0000000000000040
> Call Trace:
>  [<ffffffff80242cd4>] ? __kernel_text_address+0x9/0x26
>  [<ffffffff802859a9>] ? kmem_getpages+0xc6/0x196
>  [<ffffffff80285d2a>] ? cache_grow+0xa6/0x218
>  [<ffffffff802860ea>] ? ____cache_alloc_node+0xd3/0x121
>  [<ffffffff80285c2c>] ? kmem_cache_alloc_node+0x10e/0x13e
>  [<ffffffff804ee3ff>] ? cpuup_callback+0x8d/0x316
>  [<ffffffff804f348d>] ? notifier_call_chain+0x29/0x56
>  [<ffffffff804eda75>] ? _cpu_up+0x68/0x101
>  [<ffffffff804edb62>] ? cpu_up+0x54/0x61
>  [<ffffffff8089e63e>] ? kernel_init+0xbf/0x2ef
>  [<ffffffff804f1149>] ? _spin_unlock_irq+0x9/0xc
>  [<ffffffff8020cbe8>] ? child_rip+0xa/0x12
>  [<ffffffff8035ecf0>] ? acpi_ds_init_one_object+0x0/0x7c
>  [<ffffffff8089e57f>] ? kernel_init+0x0/0x2ef
>  [<ffffffff8020cbde>] ? child_rip+0x0/0x12
> 
> 
> Code: 48 89 44 24 10 89 54 24 0c 74 16 be 05 06 00 00 48 c7 c7 9a 67 5a 80 e8 99 05 fc ff e8 ae 68 28 00 49 8d 44 24 08 48 89 44 24 18 <49> 83 7c 24 08 00 0f 84 fa 02 00 00 89 ea b9 44 00 00 00 44 89 
> RIP  [<ffffffff8026911a>] __alloc_pages+0x4f/0x3a9
>  RSP <ffff81003fa2fc20>
> CR2: 0000000000007358
> ---[ end trace 4eaa2a86a8e2da22 ]---
> Kernel panic - not syncing: Attempted to kill init!
> 
> 

