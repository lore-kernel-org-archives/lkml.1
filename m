Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968577Ab0B0Qb0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:31:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37579 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968550Ab0B0QbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:31:24 -0500
Date: Sat, 27 Feb 2010 17:31:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/numa changes for v2.6.24
Message-ID: <20100227163113.GA9742@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-numa-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-numa-for-linus

 Thanks,

	Ingo

------------------>
David Rientjes (3):
      x86, numa: Fix numa emulation calculation of big nodes
      x86, numa: Add fixed node size option for numa emulation
      x86, numa: Remove configurable node size support for numa emulation

Haicheng Li (1):
      x86, acpi: Map hotadded cpu to correct node.


 Documentation/x86/x86_64/boot-options.txt |   20 +--
 arch/x86/include/asm/mmzone_64.h          |    6 -
 arch/x86/include/asm/numa_64.h            |    5 +
 arch/x86/kernel/acpi/boot.c               |   21 +++
 arch/x86/mm/numa_64.c                     |  235 ++++++++++++----------------
 5 files changed, 134 insertions(+), 153 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 29a6ff8..7fbbaf8 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -166,19 +166,13 @@ NUMA
 
   numa=noacpi   Don't parse the SRAT table for NUMA setup
 
-  numa=fake=CMDLINE
-		If a number, fakes CMDLINE nodes and ignores NUMA setup of the
-		actual machine.  Otherwise, system memory is configured
-		depending on the sizes and coefficients listed.  For example:
-			numa=fake=2*512,1024,4*256,*128
-		gives two 512M nodes, a 1024M node, four 256M nodes, and the
-		rest split into 128M chunks.  If the last character of CMDLINE
-		is a *, the remaining memory is divided up equally among its
-		coefficient:
-			numa=fake=2*512,2*
-		gives two 512M nodes and the rest split into two nodes.
-		Otherwise, the remaining system RAM is allocated to an
-		additional node.
+  numa=fake=<size>[MG]
+		If given as a memory unit, fills all system RAM with nodes of
+		size interleaved over physical nodes.
+
+  numa=fake=<N>
+		If given as an integer, fills all system RAM with N fake nodes
+		interleaved over physical nodes.
 
 ACPI
 
diff --git a/arch/x86/include/asm/mmzone_64.h b/arch/x86/include/asm/mmzone_64.h
index a29f48c..288b96f 100644
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
index c4ae822..823e070 100644
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
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 036d28a..7db15e1 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -49,6 +49,7 @@ EXPORT_SYMBOL(acpi_disabled);
 
 #ifdef	CONFIG_X86_64
 # include <asm/proto.h>
+# include <asm/numa_64.h>
 #endif				/* X86 */
 
 #define BAD_MADT_ENTRY(entry, end) (					    \
@@ -482,6 +483,25 @@ int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
  */
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 
+static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
+{
+#ifdef CONFIG_ACPI_NUMA
+	int nid;
+
+	nid = acpi_get_node(handle);
+	if (nid == -1 || !node_online(nid))
+		return;
+#ifdef CONFIG_X86_64
+	apicid_to_node[physid] = nid;
+	numa_set_node(cpu, nid);
+#else /* CONFIG_X86_32 */
+	apicid_2_node[physid] = nid;
+	cpu_to_node_map[cpu] = nid;
+#endif
+
+#endif
+}
+
 static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
 {
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
@@ -540,6 +560,7 @@ static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
 	}
 
 	cpu = cpumask_first(new_map);
+	acpi_map_cpu2node(handle, cpu, physid);
 
 	*pcpu = cpu;
 	retval = 0;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 83bbc70..3307ea8 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -427,7 +427,7 @@ static int __init split_nodes_interleave(u64 addr, u64 max_addr,
 	 * Calculate the number of big nodes that can be allocated as a result
 	 * of consolidating the remainder.
 	 */
-	big = ((size & ~FAKE_NODE_MIN_HASH_MASK) & nr_nodes) /
+	big = ((size & ~FAKE_NODE_MIN_HASH_MASK) * nr_nodes) /
 		FAKE_NODE_MIN_SIZE;
 
 	size &= FAKE_NODE_MIN_HASH_MASK;
@@ -502,77 +502,99 @@ static int __init split_nodes_interleave(u64 addr, u64 max_addr,
 }
 
 /*
- * Splits num_nodes nodes up equally starting at node_start.  The return value
- * is the number of nodes split up and addr is adjusted to be at the end of the
- * last node allocated.
+ * Returns the end address of a node so that there is at least `size' amount of
+ * non-reserved memory or `max_addr' is reached.
  */
-static int __init split_nodes_equally(u64 *addr, u64 max_addr, int node_start,
-				      int num_nodes)
+static u64 __init find_end_of_node(u64 start, u64 max_addr, u64 size)
 {
-	unsigned int big;
-	u64 size;
-	int i;
-
-	if (num_nodes <= 0)
-		return -1;
-	if (num_nodes > MAX_NUMNODES)
-		num_nodes = MAX_NUMNODES;
-	size = (max_addr - *addr - e820_hole_size(*addr, max_addr)) /
-	       num_nodes;
-	/*
-	 * Calculate the number of big nodes that can be allocated as a result
-	 * of consolidating the leftovers.
-	 */
-	big = ((size & ~FAKE_NODE_MIN_HASH_MASK) * num_nodes) /
-	      FAKE_NODE_MIN_SIZE;
-
-	/* Round down to nearest FAKE_NODE_MIN_SIZE. */
-	size &= FAKE_NODE_MIN_HASH_MASK;
-	if (!size) {
-		printk(KERN_ERR "Not enough memory for each node.  "
-		       "NUMA emulation disabled.\n");
-		return -1;
-	}
-
-	for (i = node_start; i < num_nodes + node_start; i++) {
-		u64 end = *addr + size;
+	u64 end = start + size;
 
-		if (i < big)
-			end += FAKE_NODE_MIN_SIZE;
-		/*
-		 * The final node can have the remaining system RAM.  Other
-		 * nodes receive roughly the same amount of available pages.
-		 */
-		if (i == num_nodes + node_start - 1)
+	while (end - start - e820_hole_size(start, end) < size) {
+		end += FAKE_NODE_MIN_SIZE;
+		if (end > max_addr) {
 			end = max_addr;
-		else
-			while (end - *addr - e820_hole_size(*addr, end) <
-			       size) {
-				end += FAKE_NODE_MIN_SIZE;
-				if (end > max_addr) {
-					end = max_addr;
-					break;
-				}
-			}
-		if (setup_node_range(i, addr, end - *addr, max_addr) < 0)
 			break;
+		}
 	}
-	return i - node_start + 1;
+	return end;
 }
 
 /*
- * Splits the remaining system RAM into chunks of size.  The remaining memory is
- * always assigned to a final node and can be asymmetric.  Returns the number of
- * nodes split.
+ * Sets up fake nodes of `size' interleaved over physical nodes ranging from
+ * `addr' to `max_addr'.  The return value is the number of nodes allocated.
  */
-static int __init split_nodes_by_size(u64 *addr, u64 max_addr, int node_start,
-				      u64 size)
+static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
 {
-	int i = node_start;
-	size = (size << 20) & FAKE_NODE_MIN_HASH_MASK;
-	while (!setup_node_range(i++, addr, size, max_addr))
-		;
-	return i - node_start;
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
 }
 
 /*
@@ -582,87 +604,32 @@ static int __init split_nodes_by_size(u64 *addr, u64 max_addr, int node_start,
 static int __init numa_emulation(unsigned long start_pfn,
 			unsigned long last_pfn, int acpi, int k8)
 {
-	u64 size, addr = start_pfn << PAGE_SHIFT;
+	u64 addr = start_pfn << PAGE_SHIFT;
 	u64 max_addr = last_pfn << PAGE_SHIFT;
-	int num_nodes = 0, num = 0, coeff_flag, coeff = -1, i;
 	int num_phys_nodes;
+	int num_nodes;
+	int i;
 
 	num_phys_nodes = setup_physnodes(addr, max_addr, acpi, k8);
 	/*
-	 * If the numa=fake command-line is just a single number N, split the
-	 * system RAM into N fake nodes.
+	 * If the numa=fake command-line contains a 'M' or 'G', it represents
+	 * the fixed node size.  Otherwise, if it is just a single number N,
+	 * split the system RAM into N fake nodes.
 	 */
-	if (!strchr(cmdline, '*') && !strchr(cmdline, ',')) {
-		long n = simple_strtol(cmdline, NULL, 0);
-
-		num_nodes = split_nodes_interleave(addr, max_addr,
-							num_phys_nodes, n);
-		if (num_nodes < 0)
-			return num_nodes;
-		goto out;
-	}
+	if (strchr(cmdline, 'M') || strchr(cmdline, 'G')) {
+		u64 size;
 
-	/* Parse the command line. */
-	for (coeff_flag = 0; ; cmdline++) {
-		if (*cmdline && isdigit(*cmdline)) {
-			num = num * 10 + *cmdline - '0';
-			continue;
-		}
-		if (*cmdline == '*') {
-			if (num > 0)
-				coeff = num;
-			coeff_flag = 1;
-		}
-		if (!*cmdline || *cmdline == ',') {
-			if (!coeff_flag)
-				coeff = 1;
-			/*
-			 * Round down to the nearest FAKE_NODE_MIN_SIZE.
-			 * Command-line coefficients are in megabytes.
-			 */
-			size = ((u64)num << 20) & FAKE_NODE_MIN_HASH_MASK;
-			if (size)
-				for (i = 0; i < coeff; i++, num_nodes++)
-					if (setup_node_range(num_nodes, &addr,
-						size, max_addr) < 0)
-						goto done;
-			if (!*cmdline)
-				break;
-			coeff_flag = 0;
-			coeff = -1;
-		}
-		num = 0;
-	}
-done:
-	if (!num_nodes)
-		return -1;
-	/* Fill remainder of system RAM, if appropriate. */
-	if (addr < max_addr) {
-		if (coeff_flag && coeff < 0) {
-			/* Split remaining nodes into num-sized chunks */
-			num_nodes += split_nodes_by_size(&addr, max_addr,
-							 num_nodes, num);
-			goto out;
-		}
-		switch (*(cmdline - 1)) {
-		case '*':
-			/* Split remaining nodes into coeff chunks */
-			if (coeff <= 0)
-				break;
-			num_nodes += split_nodes_equally(&addr, max_addr,
-							 num_nodes, coeff);
-			break;
-		case ',':
-			/* Do not allocate remaining system RAM */
-			break;
-		default:
-			/* Give one final node */
-			setup_node_range(num_nodes, &addr, max_addr - addr,
-					 max_addr);
-			num_nodes++;
-		}
+		size = memparse(cmdline, &cmdline);
+		num_nodes = split_nodes_size_interleave(addr, max_addr, size);
+	} else {
+		unsigned long n;
+
+		n = simple_strtoul(cmdline, NULL, 0);
+		num_nodes = split_nodes_interleave(addr, max_addr, num_phys_nodes, n);
 	}
-out:
+
+	if (num_nodes < 0)
+		return num_nodes;
 	memnode_shift = compute_hash_shift(nodes, num_nodes, NULL);
 	if (memnode_shift < 0) {
 		memnode_shift = 0;
