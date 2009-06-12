Return-Path: <linux-kernel-owner+w=401wt.eu-S1759588AbZFLN36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588AbZFLN36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763339AbZFLNZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:25:59 -0400
Received: from ozlabs.org ([203.10.76.45]:54989 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763143AbZFLNZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:25:57 -0400
CC: Richard Henderson <rth@twiddle.net>
CC: Tony Luck <tony.luck@intel.com>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mundt <lethal@linux-sh.org>
CC: "David S. Miller" <davem@davemloft.net>
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:31:04 +0930
Subject: [PATCH 5/17] cpumask: remove obsolete node_to_cpumask now everyone uses cpumask_of_node
Message-Id: <20090612132558.84625DDDA0@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/alpha/include/asm/topology.h          |   17 -----------------
 arch/ia64/include/asm/topology.h           |    1 -
 arch/mips/include/asm/mach-ip27/topology.h |    1 -
 arch/mips/sgi-ip27/ip27-memory.c           |    2 +-
 arch/powerpc/include/asm/topology.h        |    5 -----
 arch/sh/include/asm/topology.h             |    1 -
 arch/sparc/include/asm/topology_64.h       |   14 --------------
 include/asm-generic/topology.h             |   17 -----------------
 8 files changed, 1 insertion(+), 57 deletions(-)

diff --git a/arch/alpha/include/asm/topology.h b/arch/alpha/include/asm/topology.h
--- a/arch/alpha/include/asm/topology.h
+++ b/arch/alpha/include/asm/topology.h
@@ -22,23 +22,6 @@ static inline int cpu_to_node(int cpu)
 	return node;
 }
 
-static inline cpumask_t node_to_cpumask(int node)
-{
-	cpumask_t node_cpu_mask = CPU_MASK_NONE;
-	int cpu;
-
-	for_each_online_cpu(cpu) {
-		if (cpu_to_node(cpu) == node)
-			cpu_set(cpu, node_cpu_mask);
-	}
-
-#ifdef DEBUG_NUMA
-	printk("node %d: cpu_mask: %016lx\n", node, node_cpu_mask);
-#endif
-
-	return node_cpu_mask;
-}
-
 extern struct cpumask node_to_cpumask_map[];
 /* FIXME: This is dumb, recalculating every time.  But simple. */
 static const struct cpumask *cpumask_of_node(int node)
diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -33,7 +33,6 @@
 /*
  * Returns a bitmask of CPUs on Node 'node'.
  */
-#define node_to_cpumask(node) (node_to_cpu_mask[node])
 #define cpumask_of_node(node) (&node_to_cpu_mask[node])
 
 /*
diff --git a/arch/mips/include/asm/mach-ip27/topology.h b/arch/mips/include/asm/mach-ip27/topology.h
--- a/arch/mips/include/asm/mach-ip27/topology.h
+++ b/arch/mips/include/asm/mach-ip27/topology.h
@@ -24,7 +24,6 @@ extern struct cpuinfo_ip27 sn_cpu_info[N
 
 #define cpu_to_node(cpu)	(sn_cpu_info[(cpu)].p_nodeid)
 #define parent_node(node)	(node)
-#define node_to_cpumask(node)	(hub_data(node)->h_cpus)
 #define cpumask_of_node(node)	(&hub_data(node)->h_cpus)
 struct pci_bus;
 extern int pcibus_to_node(struct pci_bus *);
diff --git a/arch/mips/sgi-ip27/ip27-memory.c b/arch/mips/sgi-ip27/ip27-memory.c
--- a/arch/mips/sgi-ip27/ip27-memory.c
+++ b/arch/mips/sgi-ip27/ip27-memory.c
@@ -421,7 +421,7 @@ static void __init node_mem_init(cnodeid
 
 /*
  * A node with nothing.  We use it to avoid any special casing in
- * node_to_cpumask
+ * cpumask_of_node
  */
 static struct node_data null_node = {
 	.hub = {
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -17,11 +17,6 @@ static inline int cpu_to_node(int cpu)
 
 #define parent_node(node)	(node)
 
-static inline cpumask_t node_to_cpumask(int node)
-{
-	return numa_cpumask_lookup_table[node];
-}
-
 #define cpumask_of_node(node) (&numa_cpumask_lookup_table[node])
 
 int of_node_to_nid(struct device_node *device);
diff --git a/arch/sh/include/asm/topology.h b/arch/sh/include/asm/topology.h
--- a/arch/sh/include/asm/topology.h
+++ b/arch/sh/include/asm/topology.h
@@ -31,7 +31,6 @@
 #define cpu_to_node(cpu)	((void)(cpu),0)
 #define parent_node(node)	((void)(node),0)
 
-#define node_to_cpumask(node)	((void)node, cpu_online_map)
 #define cpumask_of_node(node)	((void)node, cpu_online_mask)
 
 #define pcibus_to_node(bus)	((void)(bus), -1)
diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -12,22 +12,8 @@ static inline int cpu_to_node(int cpu)
 
 #define parent_node(node)	(node)
 
-static inline cpumask_t node_to_cpumask(int node)
-{
-	return numa_cpumask_lookup_table[node];
-}
 #define cpumask_of_node(node) (&numa_cpumask_lookup_table[node])
 
-/*
- * Returns a pointer to the cpumask of CPUs on Node 'node'.
- * Deprecated: use "const struct cpumask *mask = cpumask_of_node(node)"
- */
-#define node_to_cpumask_ptr(v, node)		\
-		cpumask_t *v = &(numa_cpumask_lookup_table[node])
-
-#define node_to_cpumask_ptr_next(v, node)	\
-			   v = &(numa_cpumask_lookup_table[node])
-
 struct pci_bus;
 #ifdef CONFIG_PCI
 extern int pcibus_to_node(struct pci_bus *pbus);
diff --git a/include/asm-generic/topology.h b/include/asm-generic/topology.h
--- a/include/asm-generic/topology.h
+++ b/include/asm-generic/topology.h
@@ -37,9 +37,6 @@
 #ifndef parent_node
 #define parent_node(node)	((void)(node),0)
 #endif
-#ifndef node_to_cpumask
-#define node_to_cpumask(node)	((void)node, cpu_online_map)
-#endif
 #ifndef cpumask_of_node
 #define cpumask_of_node(node)	((void)node, cpu_online_mask)
 #endif
@@ -55,18 +52,4 @@
 
 #endif	/* CONFIG_NUMA */
 
-/*
- * returns pointer to cpumask for specified node
- * Deprecated: use "const struct cpumask *mask = cpumask_of_node(node)"
- */
-#ifndef node_to_cpumask_ptr
-
-#define	node_to_cpumask_ptr(v, node) 					\
-		cpumask_t _##v = node_to_cpumask(node);			\
-		const cpumask_t *v = &_##v
-
-#define node_to_cpumask_ptr_next(v, node)				\
-			  _##v = node_to_cpumask(node)
-#endif
-
 #endif /* _ASM_GENERIC_TOPOLOGY_H */

