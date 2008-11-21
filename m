Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbYKUKq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbYKUKq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbYKUKoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:44:54 -0500
Received: from ozlabs.org ([203.10.76.45]:45232 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbYKUKow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:44:52 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 21 Nov 2008 21:12:13 +1030
Subject: [PATCH 8/8] cpumask: x86: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
Message-Id: <20081121104450.5AB09DDEE8@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: New APIs

The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
return a pointer to a struct cpumask.  Part of removing cpumasks from
the stack.

Also makes __pcibus_to_node take a const pointer.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/pci.h      |   10 ++++++++--
 arch/x86/include/asm/topology.h |   35 +++++++++++++++++++++++------------
 arch/x86/kernel/setup_percpu.c  |    8 ++++----
 3 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -98,9 +98,9 @@ static inline void early_quirks(void) { 
 
 #ifdef CONFIG_NUMA
 /* Returns the node based on pci bus */
-static inline int __pcibus_to_node(struct pci_bus *bus)
+static inline int __pcibus_to_node(const struct pci_bus *bus)
 {
-	struct pci_sysdata *sd = bus->sysdata;
+	const struct pci_sysdata *sd = bus->sysdata;
 
 	return sd->node;
 }
@@ -109,6 +109,12 @@ static inline cpumask_t __pcibus_to_cpum
 {
 	return node_to_cpumask(__pcibus_to_node(bus));
 }
+
+static inline const struct cpumask *
+cpumask_of_pcibus(const struct pci_bus *bus)
+{
+	return cpumask_of_node(__pcibus_to_node(bus));
+}
 #endif
 
 #endif /* _ASM_X86_PCI_H */
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -61,11 +61,17 @@ static inline int cpu_to_node(int cpu)
  *
  * Side note: this function creates the returned cpumask on the stack
  * so with a high NR_CPUS count, excessive stack space is used.  The
- * node_to_cpumask_ptr function should be used whenever possible.
+ * cpumask_of_node function should be used whenever possible.
  */
 static inline cpumask_t node_to_cpumask(int node)
 {
 	return node_to_cpumask_map[node];
+}
+
+/* Returns a bitmask of CPUs on Node 'node'. */
+static inline const struct cpumask *cpumask_of_node(int node)
+{
+	return &node_to_cpumask_map[node];
 }
 
 #else /* CONFIG_X86_64 */
@@ -82,7 +88,7 @@ DECLARE_EARLY_PER_CPU(int, x86_cpu_to_no
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 extern int cpu_to_node(int cpu);
 extern int early_cpu_to_node(int cpu);
-extern const cpumask_t *_node_to_cpumask_ptr(int node);
+extern const cpumask_t *cpumask_of_node(int node);
 extern cpumask_t node_to_cpumask(int node);
 
 #else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
@@ -103,7 +109,7 @@ static inline int early_cpu_to_node(int 
 }
 
 /* Returns a pointer to the cpumask of CPUs on Node 'node'. */
-static inline const cpumask_t *_node_to_cpumask_ptr(int node)
+static inline const cpumask_t *cpumask_of_node(int node)
 {
 	return &node_to_cpumask_map[node];
 }
@@ -116,12 +122,15 @@ static inline cpumask_t node_to_cpumask(
 
 #endif /* !CONFIG_DEBUG_PER_CPU_MAPS */
 
-/* Replace default node_to_cpumask_ptr with optimized version */
+/*
+ * Replace default node_to_cpumask_ptr with optimized version
+ * Deprecated: use "const struct cpumask *mask = cpumask_of_node(node)"
+ */
 #define node_to_cpumask_ptr(v, node)		\
-		const cpumask_t *v = _node_to_cpumask_ptr(node)
+		const cpumask_t *v = cpumask_of_node(node)
 
 #define node_to_cpumask_ptr_next(v, node)	\
-			   v = _node_to_cpumask_ptr(node)
+			   v = cpumask_of_node(node)
 
 #endif /* CONFIG_X86_64 */
 
@@ -187,7 +196,7 @@ extern int __node_distance(int, int);
 #define	cpu_to_node(cpu)	0
 #define	early_cpu_to_node(cpu)	0
 
-static inline const cpumask_t *_node_to_cpumask_ptr(int node)
+static inline const cpumask_t *cpumask_of_node(int node)
 {
 	return &cpu_online_map;
 }
@@ -200,12 +209,15 @@ static inline int node_to_first_cpu(int 
 	return first_cpu(cpu_online_map);
 }
 
-/* Replace default node_to_cpumask_ptr with optimized version */
+/*
+ * Replace default node_to_cpumask_ptr with optimized version
+ * Deprecated: use "const struct cpumask *mask = cpumask_of_node(node)"
+ */
 #define node_to_cpumask_ptr(v, node)		\
-		const cpumask_t *v = _node_to_cpumask_ptr(node)
+		const cpumask_t *v = cpumask_of_node(node)
 
 #define node_to_cpumask_ptr_next(v, node)	\
-			   v = _node_to_cpumask_ptr(node)
+			   v = cpumask_of_node(node)
 #endif
 
 #include <asm-generic/topology.h>
@@ -214,8 +226,7 @@ static inline int node_to_first_cpu(int 
 /* Returns the number of the first CPU on Node 'node'. */
 static inline int node_to_first_cpu(int node)
 {
-	node_to_cpumask_ptr(mask, node);
-	return first_cpu(*mask);
+	return cpumask_first(cpumask_of_node(node));
 }
 #endif
 
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -334,25 +334,25 @@ static const cpumask_t cpu_mask_none;
 /*
  * Returns a pointer to the bitmask of CPUs on Node 'node'.
  */
-const cpumask_t *_node_to_cpumask_ptr(int node)
+const cpumask_t *cpumask_of_node(int node)
 {
 	if (node_to_cpumask_map == NULL) {
 		printk(KERN_WARNING
-			"_node_to_cpumask_ptr(%d): no node_to_cpumask_map!\n",
+			"cpumask_of_node(%d): no node_to_cpumask_map!\n",
 			node);
 		dump_stack();
 		return (const cpumask_t *)&cpu_online_map;
 	}
 	if (node >= nr_node_ids) {
 		printk(KERN_WARNING
-			"_node_to_cpumask_ptr(%d): node > nr_node_ids(%d)\n",
+			"cpumask_of_node(%d): node > nr_node_ids(%d)\n",
 			node, nr_node_ids);
 		dump_stack();
 		return &cpu_mask_none;
 	}
 	return &node_to_cpumask_map[node];
 }
-EXPORT_SYMBOL(_node_to_cpumask_ptr);
+EXPORT_SYMBOL(cpumask_of_node);
 
 /*
  * Returns a bitmask of CPUs on Node 'node'.

