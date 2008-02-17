Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbYBQNvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbYBQNvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 08:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbYBQNvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 08:51:12 -0500
Received: from www.tglx.de ([62.245.132.106]:51439 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbYBQNvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 08:51:11 -0500
Date: Sun, 17 Feb 2008 14:50:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: reenable support for system without on node0
In-Reply-To: <200802170202.21629.yinghai.lu@sun.com>
Message-ID: <alpine.LFD.1.00.0802171449310.7583@apollo.tec.linutronix.de>
References: <200802170202.21629.yinghai.lu@sun.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008, Yinghai Lu wrote:

Applied. Thanks,

	 tglx

> 
> one system doesn't have RAM for node0 installed.
> 
> SRAT: PXM 0 -> APIC 0 -> Node 0
> SRAT: PXM 0 -> APIC 1 -> Node 0
> SRAT: PXM 1 -> APIC 2 -> Node 1
> SRAT: PXM 1 -> APIC 3 -> Node 1
> SRAT: Node 1 PXM 1 0-a0000
> SRAT: Node 1 PXM 1 0-dd000000
> SRAT: Node 1 PXM 1 0-123000000
> ACPI: SLIT: nodes = 2
>  10 13
>  13 10
> mapped APIC to ffffffffff5fb000 (        fee00000)
> Bootmem setup node 1 0000000000000000-0000000123000000
>   NODE_DATA [000000000000e000 - 0000000000014fff]
>   bootmap [0000000000015000 -  00000000000395ff] pages 25
> Could not find start_pfn for node 0
> Pid: 0, comm: swapper Not tainted 2.6.24-smp-g5a514e21-dirty #14
> 
> Call Trace:
>  [<ffffffff80bab498>] free_area_init_node+0x22/0x381
>  [<ffffffff8045ffc5>] generic_swap+0x0/0x17
>  [<ffffffff80bab0cc>] find_zone_movable_pfns_for_nodes+0x54/0x271
>  [<ffffffff80baba5f>] free_area_init_nodes+0x239/0x287
>  [<ffffffff80ba6311>] paging_init+0x46/0x4c
>  [<ffffffff80b9dda5>] setup_arch+0x3c3/0x44e
>  [<ffffffff80b978be>] start_kernel+0x6f/0x2c7
>  [<ffffffff80b971cc>] _sinittext+0x1cc/0x1d3
> 
> the
> Could not find start_pfn for node 0
> should not there, because node 0 is not online.
> 
> in mm/page_alloc.c
> 
>         /*
>          * Array of node states.
>          */
>         nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
>                 [N_POSSIBLE] = NODE_MASK_ALL,
>                 [N_ONLINE] = { { [0] = 1UL } },
>         #ifndef CONFIG_NUMA
>                 [N_NORMAL_MEMORY] = { { [0] = 1UL } },
>         #ifdef CONFIG_HIGHMEM
>                 [N_HIGH_MEMORY] = { { [0] = 1UL } },
>         #endif
>                 [N_CPU] = { { [0] = 1UL } },
>         #endif  /* NUMA */
>         };
>         EXPORT_SYMBOL(node_states);
> 
> this patch will clear node_online_map at first.
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 
> diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
> index 1aecc65..59898fb 100644
> --- a/arch/x86/mm/numa_64.c
> +++ b/arch/x86/mm/numa_64.c
> @@ -494,11 +494,13 @@ void __init numa_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
>  	int i;
>  
>  	nodes_clear(node_possible_map);
> +	nodes_clear(node_online_map);
>  
>  #ifdef CONFIG_NUMA_EMU
>  	if (cmdline && !numa_emulation(start_pfn, end_pfn))
>  		return;
>  	nodes_clear(node_possible_map);
> +	nodes_clear(node_online_map);
>  #endif
>  
>  #ifdef CONFIG_ACPI_NUMA
> @@ -506,6 +508,7 @@ void __init numa_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
>  					  end_pfn << PAGE_SHIFT))
>  		return;
>  	nodes_clear(node_possible_map);
> +	nodes_clear(node_online_map);
>  #endif
>  
>  #ifdef CONFIG_K8_NUMA
> @@ -513,6 +516,7 @@ void __init numa_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
>  					end_pfn<<PAGE_SHIFT))
>  		return;
>  	nodes_clear(node_possible_map);
> +	nodes_clear(node_online_map);
>  #endif
>  	printk(KERN_INFO "%s\n",
>  	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
> @@ -524,7 +528,6 @@ void __init numa_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
>  	memnode_shift = 63;
>  	memnodemap = memnode.embedded_map;
>  	memnodemap[0] = 0;
> -	nodes_clear(node_online_map);
>  	node_set_online(0);
>  	node_set(0, node_possible_map);
>  	for (i = 0; i < NR_CPUS; i++)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
