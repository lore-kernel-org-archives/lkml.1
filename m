Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbZEFOie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbZEFOie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759386AbZEFOiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:38:19 -0400
Received: from relay2.sgi.com ([192.48.179.30]:36148 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760143AbZEFOiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:38:18 -0400
Date: Wed, 6 May 2009 09:38:15 -0500
From: Jack Steiner <steiner@sgi.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>, alex.shi@intel.com,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Fix early panic issue on machines with memless node
Message-ID: <20090506143815.GA16852@sgi.com>
References: <1241493327.27664.17.camel@ymzhang> <alpine.DEB.2.00.0905042026010.29856@chino.kir.corp.google.com> <20090505163608.GA20385@sgi.com> <alpine.DEB.2.00.0905051250510.20021@chino.kir.corp.google.com> <20090505202730.GA9831@sgi.com> <1241587192.27664.56.camel@ymzhang>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241587192.27664.56.camel@ymzhang>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 01:19:52PM +0800, Zhang, Yanmin wrote: > On Tue, 2009-05-05 at 15:27 -0500, Jack Steiner wrote:
> > On Tue, May 05, 2009 at 12:52:54PM -0700, David Rientjes wrote:
> > > On Tue, 5 May 2009, Jack Steiner wrote:
> > > 
> > > > I was able to duplicate your original problem. Your patch below solves the
> > > > problem. AFAICT, it causes no new reqgressions to the various configurations
> > > > that I'm testing. (I'll add the "mem=2G" to my configs that I test).
> > > > 
> > > 
> > > Great, it would be helpful to catch these problems before 2.6.30 is 
> > > released.  I've passed my patch along to Ingo.
> > > 
> > > > However, I see a new regression that was not present a couple of weeks ago.
> > > > Configurations that have nodes with cpus and no memory panic during
> > > > boot. This occurs both with and without your patch and is not related to "mem=".
> > > > 
> > > > I need to isolate the problem but here is the stack trace. :
> > > > 	Pid: 0, comm: swapper Not tainted 2.6.30-rc4-next-20090505-medusa #12
> > > > 	Call Trace:
> > > > 	 [<ffffffff806b919e>] early_idt_handler+0x5e/0x71
> > > > 	 [<ffffffff802920fe>] ? build_zonelists_node+0x4c/0x8d
> > > > 	 [<ffffffff8029333f>] __build_all_zonelists+0x1ae/0x55a
> > > > 	 [<ffffffff80293932>] build_all_zonelists+0x1b5/0x263
> > > > 	 [<ffffffff806b9b6e>] start_kernel+0x17a/0x3c5
> > > > 	 [<ffffffff806b9140>] ? early_idt_handler+0x0/0x71
> > > > 	 [<ffffffff806b92a7>] x86_64_start_reservations+0xae/0xb2
> > > > 	 [<ffffffff806b93fd>] x86_64_start_kernel+0x152/0x161
> > > > 
> > > 
> > > Please post your .config since it apparently differs from x86_64 defconfig 
> > > judging by my debugging symbols and also the full output of the panic.
> > 
> > I suspect I mislead you when I mentioned "configurations". I did not mean
> > the .config file. I use a more-or-less standard .config file.
> > 
> > I do much of my testing on a system simulator. Using a simulator config file,
> > I specify the system configuration such as number of nodes, sockets per node,
> > cpus per socket, memory per socket, address map, boot options, etc. This
> > makes it easy to quickly test a lot of strange (but real) configurations.
> > 
> > The configuration above that is failing is a 2-socket Nehelem blade that has no
> > memory on socket 0. All memory is located on socket 1.  The panic is caused by a
> > null dereference of NODE_DATA(0).
> > 
> > Still looking....
> It seems in function setup_node_bootmem:
> 
>         if (!end)
>                 return;
> 
> stops the initialization of node_data[nodeid]. Later on panic when build_zonelists
> dereference ???NODE_DATA(0).
> 
> Although a node is memoryless, but mostly it has small blocks of memory, so function
> acpi_scan_nodes marks them offline. However, if getting node info in
> acpi_numa_processor_affinity_init. the node might have no any memory, and ???acpi_scan_nodes
> doesn't mark it offline.

How _should_ a node without memory be treated??

For example, consider a Nehelem board with:
	- 2 sockets
	- all memory is located on socket 1 (socket 0 has no memory)

Our BIOS currently builds the SRAT with:
	- cpus in socket 0 in promimity domain 0
	- cpus in socket 1 in promimity domain 1
	- all memory is in promimity domain 1

Should this be a valid configuration? This is not a corner case that is
unlikely to occur. We actually have these types of configurations.


> 
> The logic is confusing with patch dc09855191809. Could you revert it to retest?
> 

I reverted dc09855191809.  AFAICT, the results are identical.


PROM>> 
PROM>> Fake PROM Config: cpus 2 (0 disabled), nodes 2, sockets 2, MB 256
PROM>>    socket 0, lsocket 0, blade 0, nasid 0, mem 0, cpumap 0x1, disabled 0x0
PROM>>    socket 1, lsocket 0, blade 1, nasid 4, mem 256, cpumap 0x1, disabled 0x0
PROM>> 
PROM>> SGI UV X86_64 FakeProm Version 1.00. Built 14:04:20 May  1 2009
PROM>>     Hub            : UV
PROM>>     Blades         : 2
PROM>>     Sockets        : 2
PROM>>     Cpus           : 2
PROM>>       disabled     : 0
PROM>>     Nodes          : 2
PROM>>       M value      : 37
PROM>>       N value      : 7
PROM>>     NodeMode       : 0 (node)
PROM>>     APICMode       : 1 (x2apic-UV)
PROM>>     efi_enabled    : 1
PROM>>     nasid0_present : 1
PROM>>     noded0_split   : 0
PROM>>     Total Memory   : 268435456 (256 MB)
PROM>>     Superpages     : 0 per-blade
PROM>>     Bootline       : root=/dev/hda2 init=/bin/bash console=ttyS0,38400n8 fprom lpj=10000 nohpet loglevel=8 iommu=off dma32_size=4096

PROM>> Memory Map:
PROM>>    blade 0, nasid 0: 0x0 - 0x6000: socket 1, pxm 1, RAM
PROM>>    blade 0, nasid 0: 0x6000 - 0xb0000: socket 1, pxm 1, CODE
PROM>>    blade 0, nasid 0: 0xb0000 - 0x200000 (2MB): socket 1, pxm 1, DATA
PROM>>    blade 1, nasid 4: 0x200000 (2MB) - 0x10000000 (256MB): socket 1, pxm 1, RAM
PROM>>    blade 0, nasid 0: 0x80000000 (2GB) - 0x90000000 (2GB + 256MB): socket 1, pxm 1, MMIO
PROM>>    blade 0, nasid 0: 0xf0000000 (3GB + 768MB) - 0xfc000000 (3GB + 960MB): socket 1, pxm 1, MMIO
PROM>>    blade 0, nasid 0: 0xfed1c000 (3GB + 1005MB + 114688) - 0xfed20000 (3GB + 1005MB + 131072): socket 1, pxm 1, MMIO
PROM>>    blade 0, nasid 0: 0xfff60000 (3GB + 1023MB + 393216) - 0xfff6c000 (3GB + 1023MB + 442368): socket 1, pxm 1, MMIO
PROM>>    blade 0, nasid 0: 0xfe000000000 (15TB + 896GB) - 0xfe018000000 (15TB + 896GB + 384MB): socket 0, pxm 255, MMR
PROM>> MMR BASE 0xfe000000000
PROM>> GRU BASE 0xdf800000000
PROM>> M-value: 37 (128GB)
PROM>> E820 Map: 0x00000000000c12d0
PROM>>      0: 0x0 - 0x6000: type 1
PROM>>      1: 0x6000 - 0x200000 (2MB): type 2
PROM>>      2: 0x200000 (2MB) - 0x10000000 (256MB): type 1
PROM>>      3: 0x80000000 (2GB) - 0x90000000 (2GB + 256MB): type 2
PROM>>      4: 0xf0000000 (3GB + 768MB) - 0xfc000000 (3GB + 960MB): type 2
PROM>>      5: 0xfed1c000 (3GB + 1005MB + 114688) - 0xfed20000 (3GB + 1005MB + 131072): type 2
PROM>>      6: 0xfff60000 (3GB + 1023MB + 393216) - 0xfff6c000 (3GB + 1023MB + 442368): type 2
PROM>>      7: 0xfe000000000 (15TB + 896GB) - 0xfe018000000 (15TB + 896GB + 384MB): type 2
PROM>> Build ACPI tables
PROM>>   RSDP at 0x00000000000e0200
PROM>>   XSDT at 0x00000000000e0240
PROM>>   DSDT at 0x00000000000e02a0
PROM>>   MADT at 0x00000000000e02e0 (0xa0)
PROM>>     sapic: cpu 0, socket 0, lcpu 0, proc_id 0x0, id 0x00, eid 0x00, apicid 0x0000, 
PROM>>     sapic: cpu 1, socket 1, lcpu 0, proc_id 0x1, id 0x00, eid 0x80, apicid 0x0080, 
PROM>>     io_apic: id 8, base 0, entries 24, prq 0, arb 0
PROM>>     io_apic: id 9, base 24, entries 24, prq 1, arb 9
PROM>>     lapic_nmi: acpi_id 0, flags 0x5, lint 1
PROM>>     lapic_nmi: acpi_id 1, flags 0x5, lint 1
PROM>>     int_src_ovr: bus 0, bus_irq 0, global_irq 2, flags 5
PROM>>     int_src_ovr: bus 0, bus_irq 9, global_irq 9, flags 13
PROM>>   SRAT at 0x00000000000e0380
PROM>>     Memory:
PROM>>       blade 0, soc 1: paddr 0x0 - 0xfff6c000 (3GB + 1023MB + 442368), pxm 1
PROM>>     Processor at 00000000000e03d8:
PROM>>       soc 0, lcpu 0: sapicid 0x0000, pxm 0
PROM>>       soc 1, lcpu 0: sapicid 0x0080, pxm 1
PROM>>   SLIT at 0x00000000000e05e0, dim 2
PROM>>       10  21
PROM>>       21  10
PROM>>   FADT at 0x00000000000e06a0
PROM>>   FACS at 0x00000000000e07a0
PROM>>   DMAR at 0x00000000000e0860
PROM>> Memmap (EFI):
PROM>>   0000000000000000 - 0000000000006000:       24 kb, RAM   (0x0 - 0x6000)
PROM>>   0000000000006000 - 00000000000b0000:      680 kb, CODE  (0x6000 - 0xb0000)
PROM>>   00000000000b0000 - 0000000000200000:     1344 kb, DATA  (0xb0000 - 0x200000 (2MB))
PROM>>   0000000000200000 - 0000000010000000:      254 MB, RAM   (0x200000 (2MB) - 0x10000000 (256MB))
PROM>>   0000000080000000 - 0000000090000000:      256 MB, MMIO  (0x80000000 (2GB) - 0x90000000 (2GB + 256MB))
PROM>>   00000000f0000000 - 00000000fc000000:      192 MB, MMIO  (0xf0000000 (3GB + 768MB) - 0xfc000000 (3GB + 960MB))
PROM>>   00000000fed1c000 - 00000000fed20000:       16 kb, MMIO  (0xfed1c000 (3GB + 1005MB + 114688) - 0xfed20000 (3GB + 1005MB + 131072))
PROM>>   00000000fff60000 - 00000000fff6c000:       48 kb, MMIO  (0xfff60000 (3GB + 1023MB + 393216) - 0xfff6c000 (3GB + 1023MB + 442368))
PROM>>   00000fe000000000 - 00000fe018000000:      384 MB, MMR   (0xfe000000000 (15TB + 896GB) - 0xfe018000000 (15TB + 896GB + 384MB))
PROM>> Total memory: 0x10000000 (268435456) bytes, 256 MB, 0 GB
PROM>> Set x2apic APICID: pcpu 0, val 0x0 -> 0x0
PROM>> init_local_mmrs: cpu 0, apicid 0x0000, nasid 0x0
PROM>> BAU GB: nasid 0, paddr 0x1e0000
PROM>> Set x2apic APICID: pcpu 1, val 0x0 -> 0x80
PROM>> init_local_mmrs: cpu 1, apicid 0x0080, nasid 0x4
PROM>> BAU GB: nasid 4, paddr 0x1e4000
<6>Initializing cgroup subsys cpuset
<6>Initializing cgroup subsys cpu
<5>Linux version 2.6.30-rc4-next-20090505-medusa (steiner@alcatraz.americas.sgi.com) (gcc version 4.2.4) #41 SMP Wed May 6 08:21:07 CDT 2009
<6>Command line: root=/dev/hda2 init=/bin/bash console=ttyS0,38400n8 fprom lpj=10000 nohpet loglevel=8 iommu=off dma32_size=4096
<6>KERNEL supported cpus:
<6>  Intel GenuineIntel
<6>  AMD AuthenticAMD
<6>  Centaur CentaurHauls
<6>BIOS-provided physical RAM map:
<6> BIOS-e820: 0000000000000000 - 0000000000006000 (usable)
<6> BIOS-e820: 0000000000006000 - 0000000000200000 (reserved)
<6> BIOS-e820: 0000000000200000 - 0000000010000000 (usable)
<6> BIOS-e820: 0000000080000000 - 0000000090000000 (reserved)
<6> BIOS-e820: 00000000f0000000 - 00000000fc000000 (reserved)
<6> BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
<6> BIOS-e820: 00000000fff60000 - 00000000fff6c000 (reserved)
<6> BIOS-e820: 00000fe000000000 - 00000fe018000000 (reserved)
<6>EFI v1.00 by SGI 
<6> ACPI 2.0=0xe0200  UVsystab=0xe08c0 
<6>EFI: mem00: type=7, attr=0x8, range=[0x0000000000000000-0x0000000000006000) (0MB)
<6>EFI: mem01: type=5, attr=0x8000000000001000, range=[0x0000000000006000-0x00000000000b0000) (0MB)
<6>EFI: mem02: type=6, attr=0x8000000000000008, range=[0x00000000000b0000-0x0000000000200000) (1MB)
<6>EFI: mem03: type=7, attr=0x8, range=[0x0000000000200000-0x0000000010000000) (254MB)
<6>EFI: mem04: type=6, attr=0x8000000000000001, range=[0x0000000080000000-0x0000000090000000) (256MB)
<6>EFI: mem05: type=6, attr=0x8000000000000001, range=[0x00000000f0000000-0x00000000fc000000) (192MB)
<6>EFI: mem06: type=6, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
<6>EFI: mem07: type=6, attr=0x8000000000000001, range=[0x00000000fff60000-0x00000000fff6c000) (0MB)
<6>EFI: mem08: type=11, attr=0x8000000000000001, range=[0x00000fe000000000-0x00000fe018000000) (384MB)
<6>DMI not present or invalid.
<6>last_pfn = 0x10000 max_arch_pfn = 0x100000000
<7>MTRR default type: write-back
<7>MTRR fixed ranges enabled:
<7>  00000-FFFFF write-back
<7>MTRR variable ranges enabled:
<7>  0 base 0   F0000000 mask FFF F0000000 uncachable
<7>  1 base E0  00000000 mask FF0 00000000 uncachable
<7>  2 base F0  00000000 mask FF0 00000000 uncachable
<7>  3 base F00 00000000 mask FF0000000000 uncachable
<7>  4 disabled
<7>  5 disabled
<7>  6 disabled
<7>  7 disabled
<6>x86 PAT enabled: cpu 0, old 0x606060606060606, new 0x7010600070106
<6>x2apic enabled by BIOS, switching to x2apic ops
<6>init_memory_mapping: 0000000000000000-0000000010000000
<7> 0000000000 - 0010000000 page 2M
<7>kernel direct mapping tables up to 10000000 @ 936000-938000
<4>ACPI: RSDP 00000000000e0200 00024 (v02       )
<4>ACPI: XSDT 00000000000e0240 00054 (v01    SGI      UVX 00010001 FPRM 00000001)
<4>ACPI: APIC 00000000000e02e0 00086 (v01    SGI      UVX 00010001 FPRM 00000001)
<4>ACPI: SRAT 00000000000e0380 00078 (v01    SGI      UVX 00010001 FPRM 00000001)
<4>ACPI: SLIT 00000000000e05e0 00030 (v01    SGI      UVX 00010001 FPRM 00000001)
<4>ACPI: MCFG 00000000000e0640 0004C (v01    SGI      UVX 00010001 FPRM 00000001)
<4>ACPI: FACP 00000000000e06a0 000F4 (v03    SGI      UVX 00030001 FPRM 00000001)
<4>ACPI: DSDT 00000000000e02a0 00030 (v01    SGI      UVX 00010001 FPRM 00000001)
<4>ACPI: FACS 00000000000e07a0 00040
<4>ACPI: DMAR 00000000000e0860 0004C (v01    SGI      UVX 00010001 FPRM 00000001)
<7>ACPI: Local APIC address 0xfee00000
<6>Setting APIC routing to cluster x2apic.
<6>SRAT: PXM 0 -> APIC 0 -> Node 0
<6>SRAT: PXM 1 -> APIC 128 -> Node 1
<6>SRAT: Node 1 PXM 1 0-fff6c000
<7>NUMA: Using 63 for the hash shift.
<6>Bootmem setup node 1 0000000000000000-0000000010000000
<6>  NODE_DATA [0000000000935a80 - 0000000000969a7f]
<6>  bootmap [000000000096a000 -  000000000096bfff] pages 2
<6>(7 early reservations) ==> bootmem [0000000000 - 0010000000]
<6>  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
<6>  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
<6>  #2 [0000200000 - 0000935a5c]    TEXT DATA BSS ==> [0000200000 - 0000935a5c]
<6>  #3 [000009f000 - 00000e0900]    BIOS reserved ==> [000009f000 - 00000e0900]
<6>  #4 [00000e0a68 - 0000100000]    BIOS reserved ==> [00000e0a68 - 0000100000]
<6>  #5 [00000e0900 - 00000e0a68]       EFI memmap ==> [00000e0900 - 00000e0a68]
<6>  #6 [0000001000 - 0000001030]        ACPI SLIT ==> [0000001000 - 0000001030]
<7> [ffffe20000000000-ffffe200003fffff] PMD -> [ffff880001200000-ffff8800015fffff] on node 1
<4>Zone PFN ranges:
<4>  DMA      0x00000000 -> 0x00001000
<4>  DMA32    0x00001000 -> 0x00100000
<4>  Normal   0x00100000 -> 0x00100000
<4>Movable zone start PFN for each node
<4>early_node_map[2] active PFN ranges
<4>    1: 0x00000000 -> 0x00000006
<4>    1: 0x00000200 -> 0x00010000
<7>On node 1 totalpages: 65030
<7>  DMA zone: 56 pages used for memmap
<7>  DMA zone: 1944 pages reserved
<7>  DMA zone: 1590 pages, LIFO batch:0
<7>  DMA32 zone: 840 pages used for memmap
<7>  DMA32 zone: 60600 pages, LIFO batch:15
<6>ACPI: PM-Timer IO Port: 0x1008
<7>ACPI: Local APIC address 0xfee00000
<6>Setting APIC routing to cluster x2apic.
<6>ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x00] enabled)
<6>ACPI: LSAPIC (acpi_id[0x01] lsapic_id[0x00] lsapic_eid[0x80] enabled)
<6>ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
<6>ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
<6>ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
<6>IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23
<6>ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
<6>IOAPIC[1]: apic_id 9, version 0, address 0xfec80000, GSI 24-24
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
<7>ACPI: IRQ0 used by override.
<7>ACPI: IRQ2 used by override.
<7>ACPI: IRQ9 used by override.
<6>Using ACPI (MADT) for SMP configuration information
<6>SMP: Allowing 2 CPUs, 0 hotplug CPUs
<7>nr_irqs_gsi: 25
<6>PM: Registered nosave memory: 0000000000006000 - 0000000000200000
<6>Allocating PCI resources starting at 18000000 (gap: 10000000:70000000)
<6>NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:2
<6>PERCPU: Embedded 26 pages at ffff880001005000, static data 76384 bytes
<4>Pid: 0, comm: swapper Not tainted 2.6.30-rc4-next-20090505-medusa #41
<4>Call Trace:
<4> [<ffffffff806b919e>] early_idt_handler+0x5e/0x71
<4> [<ffffffff802920e1>] ? build_zonelists_node+0x2f/0x70
<4> [<ffffffff80232241>] ? __node_distance+0x59/0x70
<4> [<ffffffff80293322>] __build_all_zonelists+0x1ae/0x55a
<4> [<ffffffff80293915>] build_all_zonelists+0x1b5/0x263
<4> [<ffffffff806b9b6e>] start_kernel+0x17a/0x3c5
<4> [<ffffffff806b9140>] ? early_idt_handler+0x0/0x71
<4> [<ffffffff806b92a7>] x86_64_start_reservations+0xae/0xb2
<4> [<ffffffff806b93fd>] x86_64_start_kernel+0x152/0x161
<4>RIP build_zonelists_node+0x2f/0x70
