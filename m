Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829Ab0ASXau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab0ASXau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 18:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234Ab0ASXat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 18:30:49 -0500
Received: from smtp-out.google.com ([216.239.44.51]:3908 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab0ASXas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 18:30:48 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=unGwX6nAgU6VDG0MojvA8PUofiHqjUJcI6j/nlCmNDn9JQiaY6PfytqOTAwM5wzz+
	k720RkEPUsq9Je7EbgUTg==
Date: Tue, 19 Jan 2010 15:30:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Haicheng Li <haicheng.li@linux.intel.com>
cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm/srat_64.c: nodes_parsed should include all nodes
 detected by ACPI.
In-Reply-To: <4B5592B1.9030800@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1001191513010.24223@chino.kir.corp.google.com>
References: <4B501C4D.4080907@linux.intel.com> <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com> <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com> <alpine.DEB.2.00.1001180231430.20677@chino.kir.corp.google.com>
 <4B5592B1.9030800@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jan 2010, Haicheng Li wrote:

> > The old code would preserve the address range from the preceding SRAT entry
> > for that node to pass to e820_register_active_regions() when
> > CONFIG_MEMORY_HOTPLUG_SPARSE is enabled, this patch incorrectly clears that
> > data.
> 
> To fully understand what could happen with old code, I write a debug patch
> like following:
> diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
> index dbb5381..f7118d1 100644
> --- a/arch/x86/mm/srat_64.c
> +++ b/arch/x86/mm/srat_64.c
> @@ -290,6 +290,8 @@ acpi_numa_memory_affinity_init(struct
> acpi_srat_mem_affinity *ma)
> 
>  	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
>  	       start, end);
> +	printk(KERN_INFO "SRAT: Node %u oldnode: %lx-%lx\n", node,
> +	       oldnode.start, oldnode.end);
>  	e820_register_active_regions(node, start >> PAGE_SHIFT,
>  				     end >> PAGE_SHIFT);
> 
> @@ -297,8 +299,10 @@ acpi_numa_memory_affinity_init(struct
> acpi_srat_mem_affinity *ma)
>  		update_nodes_add(node, start, end);
>  		/* restore nodes[node] */
>  		*nd = oldnode;
> -		if ((nd->start | nd->end) == 0)
> +		if ((nd->start | nd->end) == 0) {
>  			node_clear(node, nodes_parsed);
> +			printk("node-clear: %u\n", node);
> +		}
>  	}
> 
>  	node_memblk_range[num_node_memblks].start = start;
> 
> 
> Then on a system with Node0 on, but Node1 off (both cpu and memory are off),
> the booting log is like:
> [    0.000000] SRAT: Node 0 PXM 0 0-80000000
> [    0.000000] SRAT: Node 0 oldnode: 0-0
> [    0.000000] SRAT: Node 0 PXM 0 100000000-280000000
> [    0.000000] SRAT: Node 0 oldnode: 0-80000000
> [    0.000000] SRAT: Node 0 PXM 0 300000000-2300000000
> [    0.000000] SRAT: Node 0 oldnode: 0-280000000
> [    0.000000] SRAT: hot plug zone found 300000000 - 2300000000
> [    0.000000] SRAT: Node 0 PXM 0 2300000000-4300000000
> [    0.000000] SRAT: Node 0 oldnode: 0-280000000
> [    0.000000] SRAT: hot plug zone found 300000000 - 4300000000
> 
> [    0.000000] SRAT: Node 1 PXM 1 4300000000-6300000000
> [    0.000000] SRAT: Node 1 oldnode: 0-0
> [    0.000000] SRAT: hot plug zone found 4300000000 - 6300000000
> [    0.000000] node-clear: 1
> [    0.000000] SRAT: Node 1 PXM 1 6300000000-8300000000
> [    0.000000] SRAT: Node 1 oldnode: 0-0
> [    0.000000] SRAT: hot plug zone found 4300000000 - 8300000000
> [    0.000000] node-clear: 1
> 
> David, per my understanding, your concern should be like, with this fix, if
> 3rd or 4th entry of Node0 has no address range, then Node0 won't be recoverd
> with oldnode and won't be cleared in nodes_parsed. But how is it handled by
> old code?
> 

It's not evident with your machine because you do not have two SRAT 
entries for the same node id, one without ACPI_SRAT_MEM_HOT_PLUGGABLE and 
other with ACPI_SRAT_MEM_HOT_PLUGGABLE.

The old code would preserve the address range for the former in oldnode 
and then reset its data in the struct bootnode since nodes_parsed has a 
bit set for that node.  That's needed by later code that I've mentioned: 
acpi_get_nodes(), specifically, which breaks with your patch in addition 
to nodes_cover_memory() and e820_register_active_regions().

Only when the previous oldnode entry does not have a valid address range, 
meaning it is [0, 0), does the bit get cleared in nodes_parsed.

> - it recovers node with oldnode as long as current entry is HOT_PLUGGABLE. so
> it handles the recover issue. but I think following patch can simply fix it as
> well.
> 

If it's not ACPI_SRAT_MEM_HOT_PLUGGABLE, we know the address range is 
already valid given the sanity checks that it has successfully passed 
through in acpi_numa_memory_affinity_init(), so we require no further 
checking.  However, your patch will not reset the previous address range 
when a ACPI_SRAT_MEM_HOT_PLUGGABLE entry is found for the same address 
range and you're leaving the bit set in nodes_parsed.

> > cpu_nodes_parsed handles nodes without memory, there's no reason why a bit
> > should be set in nodes_parsed if its corresponding node does not have a
> > valid address range.  
> 
> For a node has _NOT_ either CPU or Memory like Node1, cpu_nodes_parsed cannot
> handle it.
> 

It most certainly can since its sole purpose is to include memoryless 
nodes in node_possible_map.  It has no other use case that would break as 
the result of adding hotpluggable nodes, hence the reason I suggested 
renaming it no_mem_nodes_parsed.

> > We have a reasonable expectation that nodes_parsed represents memory nodes
> > given its use for e820_register_active_regions() and nodes_cover_memory() as
> > well as acpi_get_nodes() for NUMA emulation, for example, which would be
> > broken with this patch.  See dc0985519.
> > 
> 
> either nodes_cover_memory() or e820_register_active_regions() or
> acpi_get_nodes(), they all have node-addr-range check code, if the
> node-addr-range is invalid, they won't be harmed.
> 

Wrong, acpi_get_nodes() does not have such a check it only iterates over 
nodes_parsed.  In other words, you'd be starting a new requirement for 
nodes_parsed with your patch: it would now be necessary to check for a 
valid (non-zero) address range for each set bit.  Instead, I'm suggesting 
the nodes_parsed represents only nodes with valid memory, which is a 
reasonable expectation given the semantics of both it and cpu_nodes_parsed 
to handle their memoryless counterparts.

In other words, the following should easily fix the issue without breaking 
the existing logic that preserves the old address range for node ids that 
have SRAT entries both with and without ACPI_SRAT_MEM_HOT_PLUGGABLE.  
Could you give it a try?
---
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -229,9 +229,11 @@ update_nodes_add(int node, unsigned long start, unsigned long end)
 			printk(KERN_ERR "SRAT: Hotplug zone not continuous. Partly ignored\n");
 	}
 
-	if (changed)
+	if (changed) {
 		printk(KERN_INFO "SRAT: hot plug zone found %Lx - %Lx\n",
 				 nd->start, nd->end);
+		node_set(node, cpu_nodes_parsed);
+	}
 }
 
 /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
