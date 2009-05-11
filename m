Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbZEKRxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbZEKRxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbZEKRxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:53:17 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42302 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753021AbZEKRxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:53:16 -0400
Date: Mon, 11 May 2009 12:53:12 -0500
From: Jack Steiner <steiner@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86: fix node_possible_map logic -v2
Message-ID: <20090511175312.GA27905@sgi.com>
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0527CB.4020807@kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 11:50:51PM -0700, Yinghai Lu wrote:
> 
> recently there are some changes to about meaning of node_possible_map
> 
> and it is some strange:
> the node without memory would be set in node_possible_map
> but some node with less NODE_MIN_SIZE will be kicked out of node_possible_map.
> 
> try to fix it by adding strict_setup_node_bootmem.
> also remove unparse_node.

I still see the same panic. Entry 0 of the node_data array is NULL &
it is dereferenced building the zonelists.

I'm sure that you are way ahead of me in diagnosing this problem but
this is a regression from previous behavior. Fpor example, in 2.6.27, node_data
is created for both nodes but node 0 contains no memory:

	(2.7.27)
	<6>SRAT: PXM 0 -> APIC 0 -> Node 0
	<6>SRAT: PXM 1 -> APIC 128 -> Node 1
	<6>SRAT: Node 1 PXM 1 0-fff6c000
	<7>NUMA: Using 63 for the hash shift.
	<6>Bootmem setup node 0 0000000000000000-0000000000000000
	<3>Cannot find 212992 bytes in node 0
	<6>Bootmem setup node 1 0000000000000000-0000000010000000
	<6>  NODE_DATA [000000000139be80 - 00000000013cfe7f]
	<6>  bootmap [00000000013d0000 -  00000000013d1fff] pages 2
	<6>(7 early reservations) ==> bootmem [0000000000 - 0010000000]
	<6>  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
	<6>  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
	<6>  #2 [0000200000 - 000139be38]    TEXT DATA BSS ==> [0000200000 - 000139be38]
	<6>  #3 [000009f000 - 00000e0900]    BIOS reserved ==> [000009f000 - 00000e0900]
	<6>  #4 [00000e0a68 - 0000100000]    BIOS reserved ==> [00000e0a68 - 0000100000]
	<6>  #5 [00000e0900 - 00000e0a68]       EFI memmap ==> [00000e0900 - 00000e0a68]
	<6>  #6 [0000001000 - 0000001030]        ACPI SLIT ==> [0000001000 - 0000001030]
	<6>Bootmem setup node 0 0000000000000000-0000000000000000
	<6>  NODE_DATA [00000000013d2000 - 0000000001405fff]
	<6>  bootmap [0000000000000000 -  ffffffffffffffff] pages 0
	<6>(7 early reservations) ==> bootmem [0000000000 - 0000000000]
	<6>  #0 [0000000000 - 0000001000]   BIOS data page
	<6>  #1 [0000006000 - 0000008000]       TRAMPOLINE
	<6>  #2 [0000200000 - 000139be38]    TEXT DATA BSS
	<6>  #3 [000009f000 - 00000e0900]    BIOS reserved
	<6>  #4 [00000e0a68 - 0000100000]    BIOS reserved
	<6>  #5 [00000e0900 - 00000e0a68]       EFI memmap
	<6>  #6 [0000001000 - 0000001030]        ACPI SLIT
	<6>    NODE_DATA(0) on node 1
	<6>    bootmap(0) on node 1
	<7> [ffffe20000000000-ffffe200003fffff] PMD -> [ffff880001600000-ffff8800019fffff] on node 1
	<4>Zone PFN ranges:
	<4>  DMA      0x00000000 -> 0x00001000
	<4>  DMA32    0x00001000 -> 0x00100000
	<4>  Normal   0x00100000 -> 0x00100000
	<4>Movable zone start PFN for each node
	<4>early_node_map[2] active PFN ranges
	<4>    1: 0x00000000 -> 0x00000006
	<4>    1: 0x00000200 -> 0x00010000
	<4>Could not find start_pfn for node 0
	<7>On node 0 totalpages: 0
	<7>On node 1 totalpages: 65030
	<7>  DMA zone: 3427 pages, LIFO batch:0
	<7>  DMA32 zone: 60480 pages, LIFO batch:15

I have not seen any problems running on 2.6.27 using nodes that have no memory.


Do we have a clear and unambiguous definition of what a node really is?
In this case, is a board (socket) with cpus, a unique PXM but no memory
considered a node. Even though it has no memory, it is a node (depending on the
definition of "node") for purposes such as scheduling. The memoryless node also
has local IO buses that want to direct interrupts to node-local cpus.



> 
> so result will be:
> 1. cpu_to_node will return online node only (nearest one)
> 2. apicid_to_node still return the node that could be not online but is set
>    in node_possible_map.
> 3. node_possible_map will include nodes that mem on it are less NODE_MIN_SIZE
> 
> v2: after move_cpus_to_node change.
> 
> [ Impact: get node_possible_map right ]
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/numa_64.h |    4 ++++
>  arch/x86/mm/numa_64.c          |    7 +++++++
>  arch/x86/mm/srat_64.c          |   29 ++---------------------------
>  3 files changed, 13 insertions(+), 27 deletions(-)
> 
> Index: linux-2.6/arch/x86/mm/srat_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/srat_64.c
> +++ linux-2.6/arch/x86/mm/srat_64.c
> @@ -36,10 +36,6 @@ static int num_node_memblks __initdata;
>  static struct bootnode node_memblk_range[NR_NODE_MEMBLKS] __initdata;
>  static int memblk_nodeid[NR_NODE_MEMBLKS] __initdata;
>  
> -/* Too small nodes confuse the VM badly. Usually they result
> -   from BIOS bugs. */
> -#define NODE_MIN_SIZE (4*1024*1024)
> -
>  static __init int setup_node(int pxm)
>  {
>  	return acpi_map_pxm_to_node(pxm);
> @@ -338,17 +334,6 @@ static int __init nodes_cover_memory(con
>  	return 1;
>  }
>  
> -static void __init unparse_node(int node)
> -{
> -	int i;
> -	node_clear(node, nodes_parsed);
> -	node_clear(node, cpu_nodes_parsed);
> -	for (i = 0; i < MAX_LOCAL_APIC; i++) {
> -		if (apicid_to_node[i] == node)
> -			apicid_to_node[i] = NUMA_NO_NODE;
> -	}
> -}
> -
>  void __init acpi_numa_arch_fixup(void) {}
>  
>  /* Use the information discovered above to actually set up the nodes. */
> @@ -360,18 +345,8 @@ int __init acpi_scan_nodes(unsigned long
>  		return -1;
>  
>  	/* First clean up the node list */
> -	for (i = 0; i < MAX_NUMNODES; i++) {
> +	for (i = 0; i < MAX_NUMNODES; i++)
>  		cutoff_node(i, start, end);
> -		/*
> -		 * don't confuse VM with a node that doesn't have the
> -		 * minimum memory.
> -		 */
> -		if (nodes[i].end &&
> -			(nodes[i].end - nodes[i].start) < NODE_MIN_SIZE) {
> -			unparse_node(i);
> -			node_set_offline(i);
> -		}
> -	}
>  
>  	if (!nodes_cover_memory(nodes)) {
>  		bad_srat();
> @@ -404,7 +379,7 @@ int __init acpi_scan_nodes(unsigned long
>  
>  		if (node == NUMA_NO_NODE)
>  			continue;
> -		if (!node_isset(node, node_possible_map))
> +		if (!node_online(node))
>  			numa_clear_node(i);
>  	}
>  	numa_init_array();
> Index: linux-2.6/arch/x86/mm/numa_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/numa_64.c
> +++ linux-2.6/arch/x86/mm/numa_64.c
> @@ -192,6 +192,13 @@ void __init setup_node_bootmem(int nodei
>  	if (!end)
>  		return;
>  
> +	/*
> +	 * don't confuse VM with a node that doesn't have the
> +	 * minimum memory.
> +	 */
> +	if (end && (end - start) < NODE_MIN_SIZE)
> +		return;
> +
>  	start = roundup(start, ZONE_ALIGN);
>  
>  	printk(KERN_INFO "Bootmem setup node %d %016lx-%016lx\n", nodeid,
> Index: linux-2.6/arch/x86/include/asm/numa_64.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/numa_64.h
> +++ linux-2.6/arch/x86/include/asm/numa_64.h
> @@ -24,6 +24,10 @@ extern void setup_node_bootmem(int nodei
>  			       unsigned long end);
>  
>  #ifdef CONFIG_NUMA
> +/* Too small nodes confuse the VM badly. Usually they result
> +   from BIOS bugs. */
> +#define NODE_MIN_SIZE (4*1024*1024)
> +
>  extern void __init init_cpu_to_node(void);
>  extern void numa_set_node(int cpu, int node);
>  extern void numa_clear_node(int cpu);
