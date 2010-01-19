Return-Path: <linux-kernel-owner+w=401wt.eu-S932153Ab0ASLIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab0ASLIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 06:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906Ab0ASLIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 06:08:41 -0500
Received: from mga10.intel.com ([192.55.52.92]:22317 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756105Ab0ASLIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 06:08:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,300,1262592000"; 
   d="scan'208";a="765419182"
Message-ID: <4B5592B1.9030800@linux.intel.com>
Date: Tue, 19 Jan 2010 19:08:33 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm/srat_64.c: nodes_parsed should include all nodes
 detected by ACPI.
References: <4B501C4D.4080907@linux.intel.com> <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com> <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com> <alpine.DEB.2.00.1001180231430.20677@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1001180231430.20677@chino.kir.corp.google.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave & Yinghai,

Thanks for the review, and see my reply below.

David Rientjes wrote:
> On Sun, 17 Jan 2010, Yinghai Lu wrote:
> 
>>> There're a couple of issues with this patch:
>>>
>>> - it breaks CONFIG_MEMORY_HOTPLUG_SPARSE kernels when the SRAT reports
>>>  more than one entry for a single node id and the later entry does not
>>>  specify an address range, and
>> not sure this one.
>>
> The old code would preserve the address range from the preceding SRAT 
> entry for that node to pass to e820_register_active_regions() when 
> CONFIG_MEMORY_HOTPLUG_SPARSE is enabled, this patch incorrectly clears 
> that data.

To fully understand what could happen with old code, I write a debug patch like following:
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index dbb5381..f7118d1 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -290,6 +290,8 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)

  	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
  	       start, end);
+	printk(KERN_INFO "SRAT: Node %u oldnode: %lx-%lx\n", node,
+	       oldnode.start, oldnode.end);
  	e820_register_active_regions(node, start >> PAGE_SHIFT,
  				     end >> PAGE_SHIFT);

@@ -297,8 +299,10 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
  		update_nodes_add(node, start, end);
  		/* restore nodes[node] */
  		*nd = oldnode;
-		if ((nd->start | nd->end) == 0)
+		if ((nd->start | nd->end) == 0) {
  			node_clear(node, nodes_parsed);
+			printk("node-clear: %u\n", node);
+		}
  	}

  	node_memblk_range[num_node_memblks].start = start;


Then on a system with Node0 on, but Node1 off (both cpu and memory are off), the booting log is like:
[    0.000000] SRAT: Node 0 PXM 0 0-80000000
[    0.000000] SRAT: Node 0 oldnode: 0-0
[    0.000000] SRAT: Node 0 PXM 0 100000000-280000000
[    0.000000] SRAT: Node 0 oldnode: 0-80000000
[    0.000000] SRAT: Node 0 PXM 0 300000000-2300000000
[    0.000000] SRAT: Node 0 oldnode: 0-280000000
[    0.000000] SRAT: hot plug zone found 300000000 - 2300000000
[    0.000000] SRAT: Node 0 PXM 0 2300000000-4300000000
[    0.000000] SRAT: Node 0 oldnode: 0-280000000
[    0.000000] SRAT: hot plug zone found 300000000 - 4300000000

[    0.000000] SRAT: Node 1 PXM 1 4300000000-6300000000
[    0.000000] SRAT: Node 1 oldnode: 0-0
[    0.000000] SRAT: hot plug zone found 4300000000 - 6300000000
[    0.000000] node-clear: 1
[    0.000000] SRAT: Node 1 PXM 1 6300000000-8300000000
[    0.000000] SRAT: Node 1 oldnode: 0-0
[    0.000000] SRAT: hot plug zone found 4300000000 - 8300000000
[    0.000000] node-clear: 1

David, per my understanding, your concern should be like, with this fix, if 3rd or 4th entry of 
Node0 has no address range, then Node0 won't be recoverd with oldnode and won't be cleared in 
nodes_parsed. But how is it handled by old code?

- it recovers node with oldnode as long as current entry is HOT_PLUGGABLE. so it handles the recover 
issue. but I think following patch can simply fix it as well.

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index dbb5381..fdf067f 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -281,7 +281,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
  	if (!node_test_and_set(node, nodes_parsed)) {
  		nd->start = start;
  		nd->end = end;
-	} else {
+	} else if ((nd->start | nd->end) != 0) {
  		if (start < nd->start)
  			nd->start = start;
  		if (nd->end < end)

- as Node1 log shows, node_clear(node, nodes_parsed) can be executed only when either the 1st entry 
of the node is HOT_PLUGGABLE or all preceding entries have no address range plus current entry 
itself is HOT_PLUGGABLE. as a result, even Node1 has a valid address range, since its 1st entry is 
HOT_PLUGGABLE, the old code still recovers it with initial node value (i.e. zeroed) as well as 
clears Node1 from nodes_parsed. Isn't it a buggy logic?

>>> - carrying the bit for the node over in nodes_parsed is inappropriate
>>>  since other x86 code depends on that map including only nodes with
>>>  memory such as e820_register_active_regions() and nodes_cover_memory().
>> assume if e820 is right, even srat table have a range for hot plug
>> aka the e820 have hole already. then e820_register_active_regions()
>> and nodes_cover_memory
>> should be ok even bootnode have some pre reserved range.
>>
> 
> cpu_nodes_parsed handles nodes without memory, there's no reason why a bit 
> should be set in nodes_parsed if its corresponding node does not have a 
> valid address range.  

For a node has _NOT_ either CPU or Memory like Node1, cpu_nodes_parsed cannot handle it.

> We have a reasonable expectation that nodes_parsed 
> represents memory nodes given its use for e820_register_active_regions() 
> and nodes_cover_memory() as well as acpi_get_nodes() for NUMA emulation, 
> for example, which would be broken with this patch.  See dc0985519.
> 

either nodes_cover_memory() or e820_register_active_regions() or acpi_get_nodes(), they all have 
node-addr-range check code, if the node-addr-range is invalid, they won't be harmed.

What should nodes_parsed be? I think it's reasonable to include all the nodes reported by SRAT 
Memory Affinity Structure. Besides, also needs above small fix for recovery issue.
