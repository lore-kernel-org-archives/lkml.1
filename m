Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab0BOVnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:43:41 -0500
Received: from smtp-out.google.com ([216.239.44.51]:13489 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab0BOVnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:43:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=NzOnnuHyOOIe6yL06KT0KuLFknKuQA7YAoa6dsPbrCT39OPoyUabVxjsbBy/LYkCF
	gibT2TuJffDnjdRnXYRZA==
Date: Mon, 15 Feb 2010 13:43:30 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 2/3] x86: add fixed node size option for numa emulation
In-Reply-To: <alpine.DEB.2.00.1002151342230.26927@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1002151342510.26927@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151342230.26927@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

numa=fake=N specifies the number of fake nodes, N, to partition the
system into and then allocates them by interleaving over physical nodes.
This requires knowledge of the system capacity when attempting to
allocate nodes of a certain size: either very large nodes to benchmark
scalability of code that operates on individual nodes, or very small
nodes to find bugs in the VM.

This patch introduces numa=fake=<size>[MG] so it is possible to specify
the size of each node to allocate.  When used, nodes of the size
specified will be allocated and interleaved over the set of physical
nodes.

FAKE_NODE_MIN_SIZE was also moved to the more-appropriate
include/asm/numa_64.h.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/x86/x86_64/boot-options.txt |    4 +
 arch/x86/include/asm/mmzone_64.h          |    6 --
 arch/x86/include/asm/numa_64.h            |    5 +
 arch/x86/mm/numa_64.c                     |  117 +++++++++++++++++++++++++++--
 4 files changed, 118 insertions(+), 14 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -166,6 +166,10 @@ NUMA
 
   numa=noacpi   Don't parse the SRAT table for NUMA setup
 
+  numa=fake=<size>[MG]
+		If given as a memory unit, fills all system RAM with nodes of
+		size interleaved over physical nodes.
+
   numa=fake=CMDLINE
 		If a number, fakes CMDLINE nodes and ignores NUMA setup of the
 		actual machine.  Otherwise, system memory is configured
diff --git a/arch/x86/include/asm/mmzone_64.h b/arch/x86/include/asm/mmzone_64.h
--- a/arch/x86/include/asm/mmzone_64.h
+++ b/arch/x86/include/asm/mmzone_64.h
@@ -39,11 +39,5 @@ static inline __attribute__((pure)) int phys_to_nid(unsigned long addr)
 #define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
 #define node_end_pfn(nid)       (NODE_DATA(nid)->node_start_pfn +	\
 				 NODE_DATA(nid)->node_spanned_pages)
-
-#ifdef CONFIG_NUMA_EMU
-#define FAKE_NODE_MIN_SIZE	(64 * 1024 * 1024)
-#define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
-#endif
-
 #endif
 #endif /* _ASM_X86_MMZONE_64_H */
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -36,6 +36,11 @@ extern void __cpuinit numa_set_node(int cpu, int node);
 extern void __cpuinit numa_clear_node(int cpu);
 extern void __cpuinit numa_add_cpu(int cpu);
 extern void __cpuinit numa_remove_cpu(int cpu);
+
+#ifdef CONFIG_NUMA_EMU
+#define FAKE_NODE_MIN_SIZE	((u64)64 << 20)
+#define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
+#endif /* CONFIG_NUMA_EMU */
 #else
 static inline void init_cpu_to_node(void)		{ }
 static inline void numa_set_node(int cpu, int node)	{ }
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -502,6 +502,102 @@ static int __init split_nodes_interleave(u64 addr, u64 max_addr,
 }
 
 /*
+ * Returns the end address of a node so that there is at least `size' amount of
+ * non-reserved memory or `max_addr' is reached.
+ */
+static u64 __init find_end_of_node(u64 start, u64 max_addr, u64 size)
+{
+	u64 end = start + size;
+
+	while (end - start - e820_hole_size(start, end) < size) {
+		end += FAKE_NODE_MIN_SIZE;
+		if (end > max_addr) {
+			end = max_addr;
+			break;
+		}
+	}
+	return end;
+}
+
+/*
+ * Sets up fake nodes of `size' interleaved over physical nodes ranging from
+ * `addr' to `max_addr'.  The return value is the number of nodes allocated.
+ */
+static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
+{
+	nodemask_t physnode_mask = NODE_MASK_NONE;
+	u64 min_size;
+	int ret = 0;
+	int i;
+
+	if (!size)
+		return -1;
+	/*
+	 * The limit on emulated nodes is MAX_NUMNODES, so the size per node is
+	 * increased accordingly if the requested size is too small.  This
+	 * creates a uniform distribution of node sizes across the entire
+	 * machine (but not necessarily over physical nodes).
+	 */
+	min_size = (max_addr - addr - e820_hole_size(addr, max_addr)) /
+						MAX_NUMNODES;
+	min_size = max(min_size, FAKE_NODE_MIN_SIZE);
+	if ((min_size & FAKE_NODE_MIN_HASH_MASK) < min_size)
+		min_size = (min_size + FAKE_NODE_MIN_SIZE) &
+						FAKE_NODE_MIN_HASH_MASK;
+	if (size < min_size) {
+		pr_err("Fake node size %LuMB too small, increasing to %LuMB\n",
+			size >> 20, min_size >> 20);
+		size = min_size;
+	}
+	size &= FAKE_NODE_MIN_HASH_MASK;
+
+	for (i = 0; i < MAX_NUMNODES; i++)
+		if (physnodes[i].start != physnodes[i].end)
+			node_set(i, physnode_mask);
+	/*
+	 * Fill physical nodes with fake nodes of size until there is no memory
+	 * left on any of them.
+	 */
+	while (nodes_weight(physnode_mask)) {
+		for_each_node_mask(i, physnode_mask) {
+			u64 dma32_end = MAX_DMA32_PFN << PAGE_SHIFT;
+			u64 end;
+
+			end = find_end_of_node(physnodes[i].start,
+						physnodes[i].end, size);
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
+			 * Setup the fake node that will be allocated as bootmem
+			 * later.  If setup_node_range() returns non-zero, there
+			 * is no more memory available on this physical node.
+			 */
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
@@ -546,14 +642,7 @@ static int __init split_nodes_equally(u64 *addr, u64 max_addr, int node_start,
 		if (i == num_nodes + node_start - 1)
 			end = max_addr;
 		else
-			while (end - *addr - e820_hole_size(*addr, end) <
-			       size) {
-				end += FAKE_NODE_MIN_SIZE;
-				if (end > max_addr) {
-					end = max_addr;
-					break;
-				}
-			}
+			end = find_end_of_node(*addr, max_addr, size);
 		if (setup_node_range(i, addr, end - *addr, max_addr) < 0)
 			break;
 	}
@@ -589,6 +678,18 @@ static int __init numa_emulation(unsigned long start_pfn,
 
 	num_phys_nodes = setup_physnodes(addr, max_addr, acpi, k8);
 	/*
+	 * If the numa=fake command-line contains a 'M' or 'G', it represents
+	 * the fixed node size.
+	 */
+	if (strchr(cmdline, 'M') || strchr(cmdline, 'G')) {
+		size = memparse(cmdline, &cmdline);
+		num_nodes = split_nodes_size_interleave(addr, max_addr, size);
+		if (num_nodes < 0)
+			return num_nodes;
+		goto out;
+	}
+
+	/*
 	 * If the numa=fake command-line is just a single number N, split the
 	 * system RAM into N fake nodes.
 	 */
