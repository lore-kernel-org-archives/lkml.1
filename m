Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbZC2CEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbZC2CEv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 22:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbZC2CEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 22:04:09 -0400
Received: from ozlabs.org ([203.10.76.45]:46558 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbZC2CEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 22:04:04 -0400
CC: Tony Luck <tony.luck@intel.com>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mundt <lethal@linux-sh.org>
CC: "David S. Miller" <davem@davemloft.net>
CC: Ingo Molnar <mingo@redhat.com>
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 29 Mar 2009 00:25:52 +1030
Subject: [PATCH 3/10] cpumask: remove node_to_first_cpu
Cc: linux-mips@linux-mips.org
Message-Id: <20090329020401.920A2DDE9F@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Everyone defines it, and only one person uses it
(arch/mips/sgi-ip27/ip27-nmi.c).  So just open code it there.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-mips@linux-mips.org
---
 arch/ia64/include/asm/topology.h           |    5 -----
 arch/mips/include/asm/mach-ip27/topology.h |    1 -
 arch/mips/sgi-ip27/ip27-nmi.c              |    2 +-
 arch/powerpc/include/asm/topology.h        |    5 -----
 arch/sh/include/asm/topology.h             |    1 -
 arch/sparc/include/asm/topology_64.h       |    5 -----
 arch/x86/include/asm/topology.h            |   12 ------------
 include/asm-generic/topology.h             |    3 ---
 8 files changed, 1 insertion(+), 33 deletions(-)

diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -42,11 +42,6 @@
  * the help of node_distance().
  */
 #define parent_node(nid) (nid)
-
-/*
- * Returns the number of the first CPU on Node 'node'.
- */
-#define node_to_first_cpu(node) (cpumask_first(cpumask_of_node(node)))
 
 /*
  * Determines the node for a given pci bus
diff --git a/arch/mips/include/asm/mach-ip27/topology.h b/arch/mips/include/asm/mach-ip27/topology.h
--- a/arch/mips/include/asm/mach-ip27/topology.h
+++ b/arch/mips/include/asm/mach-ip27/topology.h
@@ -26,7 +26,6 @@ extern struct cpuinfo_ip27 sn_cpu_info[N
 #define parent_node(node)	(node)
 #define node_to_cpumask(node)	(hub_data(node)->h_cpus)
 #define cpumask_of_node(node)	(&hub_data(node)->h_cpus)
-#define node_to_first_cpu(node)	(cpumask_first(cpumask_of_node(node)))
 struct pci_bus;
 extern int pcibus_to_node(struct pci_bus *);
 
diff --git a/arch/mips/sgi-ip27/ip27-nmi.c b/arch/mips/sgi-ip27/ip27-nmi.c
--- a/arch/mips/sgi-ip27/ip27-nmi.c
+++ b/arch/mips/sgi-ip27/ip27-nmi.c
@@ -219,7 +219,7 @@ cont_nmi_dump(void)
 		if (i == 1000) {
 			for_each_online_node(node)
 				if (NODEPDA(node)->dump_count == 0) {
-					cpu = node_to_first_cpu(node);
+					cpu = cpumask_first(cpumask_of_node(node));
 					for (n=0; n < CNODE_NUM_CPUS(node); cpu++, n++) {
 						CPUMASK_SETB(nmied_cpus, cpu);
 						/*
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -23,11 +23,6 @@ static inline cpumask_t node_to_cpumask(
 }
 
 #define cpumask_of_node(node) (&numa_cpumask_lookup_table[node])
-
-static inline int node_to_first_cpu(int node)
-{
-	return cpumask_first(cpumask_of_node(node));
-}
 
 int of_node_to_nid(struct device_node *device);
 
diff --git a/arch/sh/include/asm/topology.h b/arch/sh/include/asm/topology.h
--- a/arch/sh/include/asm/topology.h
+++ b/arch/sh/include/asm/topology.h
@@ -33,7 +33,6 @@
 
 #define node_to_cpumask(node)	((void)node, cpu_online_map)
 #define cpumask_of_node(node)	((void)node, cpu_online_mask)
-#define node_to_first_cpu(node)	((void)(node),0)
 
 #define pcibus_to_node(bus)	((void)(bus), -1)
 #define pcibus_to_cpumask(bus)	(pcibus_to_node(bus) == -1 ? \
diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -27,11 +27,6 @@ static inline cpumask_t node_to_cpumask(
 
 #define node_to_cpumask_ptr_next(v, node)	\
 			   v = &(numa_cpumask_lookup_table[node])
-
-static inline int node_to_first_cpu(int node)
-{
-	return cpumask_first(cpumask_of_node(node));
-}
 
 struct pci_bus;
 #ifdef CONFIG_PCI
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -204,10 +204,6 @@ static inline cpumask_t node_to_cpumask(
 {
 	return cpu_online_map;
 }
-static inline int node_to_first_cpu(int node)
-{
-	return first_cpu(cpu_online_map);
-}
 
 /*
  * Replace default node_to_cpumask_ptr with optimized version
@@ -221,14 +217,6 @@ static inline int node_to_first_cpu(int 
 #endif
 
 #include <asm-generic/topology.h>
-
-#ifdef CONFIG_NUMA
-/* Returns the number of the first CPU on Node 'node'. */
-static inline int node_to_first_cpu(int node)
-{
-	return cpumask_first(cpumask_of_node(node));
-}
-#endif
 
 extern cpumask_t cpu_coregroup_map(int cpu);
 extern const struct cpumask *cpu_coregroup_mask(int cpu);
diff --git a/include/asm-generic/topology.h b/include/asm-generic/topology.h
--- a/include/asm-generic/topology.h
+++ b/include/asm-generic/topology.h
@@ -43,9 +43,6 @@
 #ifndef cpumask_of_node
 #define cpumask_of_node(node)	((void)node, cpu_online_mask)
 #endif
-#ifndef node_to_first_cpu
-#define node_to_first_cpu(node)	((void)(node),0)
-#endif
 #ifndef pcibus_to_node
 #define pcibus_to_node(bus)	((void)(bus), -1)
 #endif

