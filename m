Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638Ab0ATQkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab0ATQkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 11:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601Ab0ATQkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 11:40:18 -0500
Received: from mga05.intel.com ([192.55.52.89]:39194 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751237Ab0ATQkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 11:40:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,308,1262592000"; 
   d="scan'208";a="532923507"
Message-ID: <4B5731E2.4040207@linux.intel.com>
Date: Thu, 21 Jan 2010 00:40:02 +0800
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
References: <4B501C4D.4080907@linux.intel.com> <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com> <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com> <alpine.DEB.2.00.1001180231430.20677@chino.kir.corp.google.com> <4B5592B1.9030800@linux.intel.com> <alpine.DEB.2.00.1001191513010.24223@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1001191513010.24223@chino.kir.corp.google.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Tue, 19 Jan 2010, Haicheng Li wrote:
>> David, per my understanding, your concern should be like, with this fix, if
>> 3rd or 4th entry of Node0 has no address range, then Node0 won't be recoverd
>> with oldnode and won't be cleared in nodes_parsed. But how is it handled by
>> old code?
>>
>
> It's not evident with your machine because you do not have two SRAT
> entries for the same node id, one without ACPI_SRAT_MEM_HOT_PLUGGABLE and
> other with ACPI_SRAT_MEM_HOT_PLUGGABLE.
>
> The old code would preserve the address range for the former in oldnode
> and then reset its data in the struct bootnode since nodes_parsed has a
> bit set for that node.  That's needed by later code that I've mentioned:
> acpi_get_nodes(), specifically, which breaks with your patch in addition
> to nodes_cover_memory() and e820_register_active_regions().
>
> Only when the previous oldnode entry does not have a valid address range,
> meaning it is [0, 0), does the bit get cleared in nodes_parsed.

Understood, the old code is meant to make nodes_parsed _NEVER_ include the node whose memory regions
are all hotpluggable.

>> - it recovers node with oldnode as long as current entry is HOT_PLUGGABLE. so
>> it handles the recover issue. but I think following patch can simply fix it as
>> well.
>>
>
> If it's not ACPI_SRAT_MEM_HOT_PLUGGABLE, we know the address range is
> already valid given the sanity checks that it has successfully passed
> through in acpi_numa_memory_affinity_init(), so we require no further
> checking.  However, your patch will not reset the previous address range
> when a ACPI_SRAT_MEM_HOT_PLUGGABLE entry is found for the same address
> range and you're leaving the bit set in nodes_parsed.

I see. the precondition is that nodes_parsed should not include such hotpluggable node, then such
data of hotpluggable mem should be kept in nodes_add[] other than in nodes[].

>>> cpu_nodes_parsed handles nodes without memory, there's no reason why a bit
>>> should be set in nodes_parsed if its corresponding node does not have a
>>> valid address range.
>> For a node has _NOT_ either CPU or Memory like Node1, cpu_nodes_parsed cannot
>> handle it.
>>
>
> It most certainly can since its sole purpose is to include memoryless
> nodes in node_possible_map.  It has no other use case that would break as
> the result of adding hotpluggable nodes, hence the reason I suggested
> renaming it no_mem_nodes_parsed.

Yeah, so the key point is who should keep hotpluggable nodes, cpu_nodes_parsed or nodes_parsed?
Actually now I agree with you on this, let cpu_nodes_parsed keep hotpluggable nodes since it won't
break any old code. Originally my patch wanna let nodes_parsed keep hotpluggable nodes, which would
make things complex.

but name "no_mem_nodes_parsed" seems convoluted too because (from code logic) this nodemask is
usually based on CPU/APIC Affinity Structure.
How about rename cpu_nodes_parsed as "rest_nodes_parsed" (comparing with "mem_nodes_parsed), since
it handles
   - nodes with CPU on
   - nodes with hotpluggable memory region
?

>>> We have a reasonable expectation that nodes_parsed represents memory nodes
>>> given its use for e820_register_active_regions() and nodes_cover_memory() as
>>> well as acpi_get_nodes() for NUMA emulation, for example, which would be
>>> broken with this patch.  See dc0985519.
>>>
>> either nodes_cover_memory() or e820_register_active_regions() or
>> acpi_get_nodes(), they all have node-addr-range check code, if the
>> node-addr-range is invalid, they won't be harmed.
>>
>
> Wrong, acpi_get_nodes() does not have such a check it only iterates over
> nodes_parsed.  In other words, you'd be starting a new requirement for
> nodes_parsed with your patch: it would now be necessary to check for a
> valid (non-zero) address range for each set bit.  Instead, I'm suggesting
> the nodes_parsed represents only nodes with valid memory, which is a
> reasonable expectation given the semantics of both it and cpu_nodes_parsed
> to handle their memoryless counterparts.

agreed. In term of this, using nodes_parsed to represent only nodes with valid memory can make
things simple.

> In other words, the following should easily fix the issue without breaking
> the existing logic that preserves the old address range for node ids that
> have SRAT entries both with and without ACPI_SRAT_MEM_HOT_PLUGGABLE.
> Could you give it a try?

of course, it fixes the issue because node_possible_map now includes hotpluggable node, and then
nr_node_ids becomes equal to maximum of possible nodes on the motherboard;).

let's add more changes to fix naming issue as well since it's too confusing for people to understand
the code logic. how about below patch?
---
  arch/x86/mm/srat_64.c |   39 +++++++++++++++++++++++++--------------
  1 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index a271241..aebbdd4 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -27,8 +27,17 @@ int acpi_numa __initdata;

  static struct acpi_table_slit *acpi_slit;

-static nodemask_t nodes_parsed __initdata;
-static nodemask_t cpu_nodes_parsed __initdata;
+/* mem_nodes_parsed:
+ *  - nodes with memory on
+ *
+ * rest_nodes_parsed:
+ *  - nodes with CPU on
+ *  - nodes with hotpluggable memory region
+ *
+ * We union these two nodemasks to get node_possible_map.
+ */
+static nodemask_t mem_nodes_parsed __initdata;
+static nodemask_t rest_nodes_parsed __initdata;
  static struct bootnode nodes[MAX_NUMNODES] __initdata;
  static struct bootnode nodes_add[MAX_NUMNODES];

@@ -134,7 +143,7 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)

  	apic_id = pa->apic_id;
  	apicid_to_node[apic_id] = node;
-	node_set(node, cpu_nodes_parsed);
+	node_set(node, rest_nodes_parsed);
  	acpi_numa = 1;
  	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
  	       pxm, apic_id, node);
@@ -168,7 +177,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
  	else
  		apic_id = pa->apic_id;
  	apicid_to_node[apic_id] = node;
-	node_set(node, cpu_nodes_parsed);
+	node_set(node, rest_nodes_parsed);
  	acpi_numa = 1;
  	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u\n",
  	       pxm, apic_id, node);
@@ -229,9 +238,11 @@ update_nodes_add(int node, unsigned long start, unsigned long end)
  			printk(KERN_ERR "SRAT: Hotplug zone not continuous. Partly ignored\n");
  	}

-	if (changed)
+	if (changed) {
+		node_set(node, rest_nodes_parsed);
  		printk(KERN_INFO "SRAT: hot plug zone found %Lx - %Lx\n",
  				 nd->start, nd->end);
+	}
  }

  /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
@@ -278,7 +289,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
  	}
  	nd = &nodes[node];
  	oldnode = *nd;
-	if (!node_test_and_set(node, nodes_parsed)) {
+	if (!node_test_and_set(node, mem_nodes_parsed)) {
  		nd->start = start;
  		nd->end = end;
  	} else {
@@ -296,7 +307,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
  		/* restore nodes[node] */
  		*nd = oldnode;
  		if ((nd->start | nd->end) == 0)
-			node_clear(node, nodes_parsed);
+			node_clear(node, mem_nodes_parsed);
  	}

  	node_memblk_range[num_node_memblks].start = start;
@@ -313,7 +324,7 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
  	unsigned long pxmram, e820ram;

  	pxmram = 0;
-	for_each_node_mask(i, nodes_parsed) {
+	for_each_node_mask(i, mem_nodes_parsed) {
  		unsigned long s = nodes[i].start >> PAGE_SHIFT;
  		unsigned long e = nodes[i].end >> PAGE_SHIFT;
  		pxmram += e - s;
@@ -341,7 +352,7 @@ int __init acpi_get_nodes(struct bootnode *physnodes)
  	int i;
  	int ret = 0;

-	for_each_node_mask(i, nodes_parsed) {
+	for_each_node_mask(i, mem_nodes_parsed) {
  		physnodes[ret].start = nodes[i].start;
  		physnodes[ret].end = nodes[i].end;
  		ret++;
@@ -370,7 +381,7 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
  		return -1;
  	}

-	for_each_node_mask(i, nodes_parsed)
+	for_each_node_mask(i, mem_nodes_parsed)
  		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
  						nodes[i].end >> PAGE_SHIFT);
  	/* for out of order entries in SRAT */
@@ -381,7 +392,7 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
  	}

  	/* Account for nodes with cpus and no memory */
-	nodes_or(node_possible_map, nodes_parsed, cpu_nodes_parsed);
+	nodes_or(node_possible_map, mem_nodes_parsed, rest_nodes_parsed);

  	/* Finally register nodes */
  	for_each_node_mask(i, node_possible_map)
@@ -416,7 +427,7 @@ static int __init find_node_by_addr(unsigned long addr)
  	int ret = NUMA_NO_NODE;
  	int i;

-	for_each_node_mask(i, nodes_parsed) {
+	for_each_node_mask(i, mem_nodes_parsed) {
  		/*
  		 * Find the real node that this emulated node appears on.  For
  		 * the sake of simplicity, we only use a real node's starting
@@ -466,10 +477,10 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
  		__acpi_map_pxm_to_node(fake_node_to_pxm_map[i], i);
  	memcpy(apicid_to_node, fake_apicid_to_node, sizeof(apicid_to_node));

-	nodes_clear(nodes_parsed);
+	nodes_clear(mem_nodes_parsed);
  	for (i = 0; i < num_nodes; i++)
  		if (fake_nodes[i].start != fake_nodes[i].end)
-			node_set(i, nodes_parsed);
+			node_set(i, mem_nodes_parsed);
  }

  static int null_slit_node_compare(int a, int b)
-- 
1.5.4.4


