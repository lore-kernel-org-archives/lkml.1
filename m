Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbZIYWUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbZIYWUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbZIYWUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:20:24 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58686 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbZIYWUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:20:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=QVfTEQ2jkmCAt3hVtMsc9f8CCCsqSTt+ZQYTl1K841w6g5vhscG/VdAj4+2OleAK3
	qe1U4TCDe7KU/dxII5iWw==
Date: Fri, 25 Sep 2009 15:20:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
cc: Yinghai Lu <yinghai@kernel.org>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Ankita Garg <ankita@in.ibm.com>, Len Brown <len.brown@intel.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 4/4] x86: interleave emulated nodes over physical nodes
In-Reply-To: <alpine.DEB.1.00.0909251517440.14754@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0909251519150.14754@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0909251517440.14754@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add interleaved NUMA emulation support

This patch interleaves emulated nodes over the system's physical nodes.
This is required for interleave optimizations since mempolicies, for
example, operate by iterating over a nodemask and act without knowledge
of node distances.  It can also be used for testing memory latencies and
NUMA bugs in the kernel.

There're a couple of ways to do this:

 - divide the number of emulated nodes by the number of physical nodes
   and allocate the result on each physical node, or

 - allocate each successive emulated node on a different physical node
   until all memory is exhausted.

The disadvantage of the first option is, depending on the asymmetry in
node capacities of each physical node, emulated nodes may substantially
differ in size on a particular physical node compared to another.

The disadvantage of the second option is, also depending on the asymmetry
in node capacities of each physical node, there may be more emulated
nodes allocated on a single physical node as another.

This patch implements the second option; we sacrifice the possibility
that we may have slightly more emulated nodes on a particular physical
node compared to another in lieu of node size asymmetry.

 [ Note that "node capacity" of a physical node is not only a function of
   its addressable range, but also is affected by subtracting out the
   amount of reserved memory over that range.  NUMA emulation only deals
   with available, non-reserved memory quantities. ]

We ensure there is at least a minimal amount of available memory
allocated to each node.  We also make sure that at least this amount of
available memory is available in ZONE_DMA32 for any node that includes
both ZONE_DMA32 and ZONE_NORMAL.

This patch also cleans the emulation code up by no longer passing the
statically allocated struct bootnode array among the various functions.
This init.data array is not allocated on the stack since it may be very
large and thus it may be accessed at file scope.

The WARN_ON() for nodes_cover_memory() when faking proximity domains is
removed since it relies on successive nodes always having greater start
addresses than previous nodes; with interleaving this is no longer always
true.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Ankita Garg <ankita@in.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/mm/numa_64.c |  211 ++++++++++++++++++++++++++++++++++++++++++------
 arch/x86/mm/srat_64.c |    1 -
 2 files changed, 184 insertions(+), 28 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -306,8 +306,71 @@ void __init numa_init_array(void)
 
 #ifdef CONFIG_NUMA_EMU
 /* Numa emulation */
+static struct bootnode nodes[MAX_NUMNODES] __initdata;
+static struct bootnode physnodes[MAX_NUMNODES] __initdata;
 static char *cmdline __initdata;
 
+static int __init setup_physnodes(unsigned long start, unsigned long end,
+					int acpi, int k8)
+{
+	int nr_nodes = 0;
+	int ret = 0;
+	int i;
+
+#ifdef CONFIG_ACPI_NUMA
+	if (acpi)
+		nr_nodes = acpi_get_nodes(physnodes);
+#endif
+#ifdef CONFIG_K8_NUMA
+	if (k8)
+		nr_nodes = k8_get_nodes(physnodes);
+#endif
+	/*
+	 * Basic sanity checking on the physical node map: there may be errors
+	 * if the SRAT or K8 incorrectly reported the topology or the mem=
+	 * kernel parameter is used.
+	 */
+	for (i = 0; i < nr_nodes; i++) {
+		if (physnodes[i].start == physnodes[i].end)
+			continue;
+		if (physnodes[i].start > end) {
+			physnodes[i].end = physnodes[i].start;
+			continue;
+		}
+		if (physnodes[i].end < start) {
+			physnodes[i].start = physnodes[i].end;
+			continue;
+		}
+		if (physnodes[i].start < start)
+			physnodes[i].start = start;
+		if (physnodes[i].end > end)
+			physnodes[i].end = end;
+	}
+
+	/*
+	 * Remove all nodes that have no memory or were truncated because of the
+	 * limited address range.
+	 */
+	for (i = 0; i < nr_nodes; i++) {
+		if (physnodes[i].start == physnodes[i].end)
+			continue;
+		physnodes[ret].start = physnodes[i].start;
+		physnodes[ret].end = physnodes[i].end;
+		ret++;
+	}
+
+	/*
+	 * If no physical topology was detected, a single node is faked to cover
+	 * the entire address space.
+	 */
+	if (!ret) {
+		physnodes[ret].start = start;
+		physnodes[ret].end = end;
+		ret = 1;
+	}
+	return ret;
+}
+
 /*
  * Setups up nid to range from addr to addr + size.  If the end
  * boundary is greater than max_addr, then max_addr is used instead.
@@ -315,11 +378,9 @@ static char *cmdline __initdata;
  * allocation past addr and -1 otherwise.  addr is adjusted to be at
  * the end of the node.
  */
-static int __init setup_node_range(int nid, struct bootnode *nodes, u64 *addr,
-				   u64 size, u64 max_addr)
+static int __init setup_node_range(int nid, u64 *addr, u64 size, u64 max_addr)
 {
 	int ret = 0;
-
 	nodes[nid].start = *addr;
 	*addr += size;
 	if (*addr >= max_addr) {
@@ -335,12 +396,111 @@ static int __init setup_node_range(int nid, struct bootnode *nodes, u64 *addr,
 }
 
 /*
+ * Sets up nr_nodes fake nodes interleaved over physical nodes ranging from addr
+ * to max_addr.  The return value is the number of nodes allocated.
+ */
+static int __init split_nodes_interleave(u64 addr, u64 max_addr,
+						int nr_phys_nodes, int nr_nodes)
+{
+	nodemask_t physnode_mask = NODE_MASK_NONE;
+	u64 size;
+	int big;
+	int ret = 0;
+	int i;
+
+	if (nr_nodes <= 0)
+		return -1;
+	if (nr_nodes > MAX_NUMNODES) {
+		pr_info("numa=fake=%d too large, reducing to %d\n",
+			nr_nodes, MAX_NUMNODES);
+		nr_nodes = MAX_NUMNODES;
+	}
+
+	size = (max_addr - addr - e820_hole_size(addr, max_addr)) / nr_nodes;
+	/*
+	 * Calculate the number of big nodes that can be allocated as a result
+	 * of consolidating the remainder.
+	 */
+	big = ((size & ~FAKE_NODE_MIN_HASH_MASK) & nr_nodes) /
+		FAKE_NODE_MIN_SIZE;
+
+	size &= FAKE_NODE_MIN_HASH_MASK;
+	if (!size) {
+		pr_err("Not enough memory for each node.  "
+			"NUMA emulation disabled.\n");
+		return -1;
+	}
+
+	for (i = 0; i < nr_phys_nodes; i++)
+		if (physnodes[i].start != physnodes[i].end)
+			node_set(i, physnode_mask);
+
+	/*
+	 * Continue to fill physical nodes with fake nodes until there is no
+	 * memory left on any of them.
+	 */
+	while (nodes_weight(physnode_mask)) {
+		for_each_node_mask(i, physnode_mask) {
+			u64 end = physnodes[i].start + size;
+			u64 dma32_end = PFN_PHYS(MAX_DMA32_PFN);
+
+			if (ret < big)
+				end += FAKE_NODE_MIN_SIZE;
+
+			/*
+			 * Continue to add memory to this fake node if its
+			 * non-reserved memory is less than the per-node size.
+			 */
+			while (end - physnodes[i].start -
+				e820_hole_size(physnodes[i].start, end) < size) {
+				end += FAKE_NODE_MIN_SIZE;
+				if (end > physnodes[i].end) {
+					end = physnodes[i].end;
+					break;
+				}
+			}
+
+			/*
+			 * If there won't be at least FAKE_NODE_MIN_SIZE of
+			 * non-reserved memory in ZONE_DMA32 for the next node,
+			 * this one must extend to the boundary.
+			 */
+			if (end < dma32_end && dma32_end - end -
+			    e820_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
+				end = dma32_end;
+
+			/*
+			 * If there won't be enough non-reserved memory for the
+			 * next node, this one must extend to the end of the
+			 * physical node.
+			 */
+			if (physnodes[i].end - end -
+			    e820_hole_size(end, physnodes[i].end) < size)
+				end = physnodes[i].end;
+
+			/*
+			 * Avoid allocating more nodes than requested, which can
+			 * happen as a result of rounding down each node's size
+			 * to FAKE_NODE_MIN_SIZE.
+			 */
+			if (nodes_weight(physnode_mask) + ret >= nr_nodes)
+				end = physnodes[i].end;
+
+			if (setup_node_range(ret++, &physnodes[i].start,
+						end - physnodes[i].start,
+						physnodes[i].end) < 0)
+				node_clear(i, physnode_mask);
+		}
+	}
+	return ret;
+}
+
+/*
  * Splits num_nodes nodes up equally starting at node_start.  The return value
  * is the number of nodes split up and addr is adjusted to be at the end of the
  * last node allocated.
  */
-static int __init split_nodes_equally(struct bootnode *nodes, u64 *addr,
-				      u64 max_addr, int node_start,
+static int __init split_nodes_equally(u64 *addr, u64 max_addr, int node_start,
 				      int num_nodes)
 {
 	unsigned int big;
@@ -388,7 +548,7 @@ static int __init split_nodes_equally(struct bootnode *nodes, u64 *addr,
 					break;
 				}
 			}
-		if (setup_node_range(i, nodes, addr, end - *addr, max_addr) < 0)
+		if (setup_node_range(i, addr, end - *addr, max_addr) < 0)
 			break;
 	}
 	return i - node_start + 1;
@@ -399,12 +559,12 @@ static int __init split_nodes_equally(struct bootnode *nodes, u64 *addr,
  * always assigned to a final node and can be asymmetric.  Returns the number of
  * nodes split.
  */
-static int __init split_nodes_by_size(struct bootnode *nodes, u64 *addr,
-				      u64 max_addr, int node_start, u64 size)
+static int __init split_nodes_by_size(u64 *addr, u64 max_addr, int node_start,
+				      u64 size)
 {
 	int i = node_start;
 	size = (size << 20) & FAKE_NODE_MIN_HASH_MASK;
-	while (!setup_node_range(i++, nodes, addr, size, max_addr))
+	while (!setup_node_range(i++, addr, size, max_addr))
 		;
 	return i - node_start;
 }
@@ -413,15 +573,15 @@ static int __init split_nodes_by_size(struct bootnode *nodes, u64 *addr,
  * Sets up the system RAM area from start_pfn to last_pfn according to the
  * numa=fake command-line option.
  */
-static struct bootnode nodes[MAX_NUMNODES] __initdata;
-
-static int __init numa_emulation(unsigned long start_pfn, unsigned long last_pfn)
+static int __init numa_emulation(unsigned long start_pfn,
+			unsigned long last_pfn, int acpi, int k8)
 {
 	u64 size, addr = start_pfn << PAGE_SHIFT;
 	u64 max_addr = last_pfn << PAGE_SHIFT;
 	int num_nodes = 0, num = 0, coeff_flag, coeff = -1, i;
+	int num_phys_nodes;
 
-	memset(&nodes, 0, sizeof(nodes));
+	num_phys_nodes = setup_physnodes(addr, max_addr, acpi, k8);
 	/*
 	 * If the numa=fake command-line is just a single number N, split the
 	 * system RAM into N fake nodes.
@@ -429,7 +589,8 @@ static int __init numa_emulation(unsigned long start_pfn, unsigned long last_pfn
 	if (!strchr(cmdline, '*') && !strchr(cmdline, ',')) {
 		long n = simple_strtol(cmdline, NULL, 0);
 
-		num_nodes = split_nodes_equally(nodes, &addr, max_addr, 0, n);
+		num_nodes = split_nodes_interleave(addr, max_addr,
+							num_phys_nodes, n);
 		if (num_nodes < 0)
 			return num_nodes;
 		goto out;
@@ -456,8 +617,8 @@ static int __init numa_emulation(unsigned long start_pfn, unsigned long last_pfn
 			size = ((u64)num << 20) & FAKE_NODE_MIN_HASH_MASK;
 			if (size)
 				for (i = 0; i < coeff; i++, num_nodes++)
-					if (setup_node_range(num_nodes, nodes,
-						&addr, size, max_addr) < 0)
+					if (setup_node_range(num_nodes, &addr,
+						size, max_addr) < 0)
 						goto done;
 			if (!*cmdline)
 				break;
@@ -473,7 +634,7 @@ done:
 	if (addr < max_addr) {
 		if (coeff_flag && coeff < 0) {
 			/* Split remaining nodes into num-sized chunks */
-			num_nodes += split_nodes_by_size(nodes, &addr, max_addr,
+			num_nodes += split_nodes_by_size(&addr, max_addr,
 							 num_nodes, num);
 			goto out;
 		}
@@ -482,7 +643,7 @@ done:
 			/* Split remaining nodes into coeff chunks */
 			if (coeff <= 0)
 				break;
-			num_nodes += split_nodes_equally(nodes, &addr, max_addr,
+			num_nodes += split_nodes_equally(&addr, max_addr,
 							 num_nodes, coeff);
 			break;
 		case ',':
@@ -490,8 +651,8 @@ done:
 			break;
 		default:
 			/* Give one final node */
-			setup_node_range(num_nodes, nodes, &addr,
-					 max_addr - addr, max_addr);
+			setup_node_range(num_nodes, &addr, max_addr - addr,
+					 max_addr);
 			num_nodes++;
 		}
 	}
@@ -505,14 +666,10 @@ out:
 	}
 
 	/*
-	 * We need to vacate all active ranges that may have been registered by
-	 * SRAT and set acpi_numa to -1 so that srat_disabled() always returns
-	 * true.  NUMA emulation has succeeded so we will not scan ACPI nodes.
+	 * We need to vacate all active ranges that may have been registered for
+	 * the e820 memory map.
 	 */
 	remove_all_active_ranges();
-#ifdef CONFIG_ACPI_NUMA
-	acpi_numa = -1;
-#endif
 	for_each_node_mask(i, node_possible_map) {
 		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
@@ -533,7 +690,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 	nodes_clear(node_online_map);
 
 #ifdef CONFIG_NUMA_EMU
-	if (cmdline && !numa_emulation(start_pfn, last_pfn))
+	if (cmdline && !numa_emulation(start_pfn, last_pfn, acpi, k8))
 		return;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -468,7 +468,6 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 	for (i = 0; i < num_nodes; i++)
 		if (fake_nodes[i].start != fake_nodes[i].end)
 			node_set(i, nodes_parsed);
-	WARN_ON(!nodes_cover_memory(fake_nodes));
 }
 
 static int null_slit_node_compare(int a, int b)
