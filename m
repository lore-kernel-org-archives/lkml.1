Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbYKUKpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbYKUKpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYKUKos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:44:48 -0500
Received: from ozlabs.org ([203.10.76.45]:45219 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbYKUKor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:44:47 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 21 Nov 2008 21:12:13 +1030
Subject: [PATCH 3/8] cpumask: IA64: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
Cc: Tony Luck <tony.luck@intel.com>
Message-Id: <20081121104444.D30D4DDEE3@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: New APIs

The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
return a pointer to a struct cpumask.  Part of removing cpumasks from
the stack.

We can also use the new for_each_cpu_and() to avoid a temporary cpumask,
and a gratuitous test in sn_topology_show.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/include/asm/topology.h    |    7 ++++++-
 arch/ia64/kernel/acpi.c             |    2 +-
 arch/ia64/kernel/iosapic.c          |    7 +++----
 arch/ia64/sn/kernel/sn2/sn_hwperf.c |   27 ++++++++++++---------------
 4 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -34,6 +34,7 @@
  * Returns a bitmask of CPUs on Node 'node'.
  */
 #define node_to_cpumask(node) (node_to_cpu_mask[node])
+#define cpumask_of_node(node) (&node_to_cpu_mask[node])
 
 /*
  * Returns the number of the node containing Node 'nid'.
@@ -45,7 +46,7 @@
 /*
  * Returns the number of the first CPU on Node 'node'.
  */
-#define node_to_first_cpu(node) (first_cpu(node_to_cpumask(node)))
+#define node_to_first_cpu(node) (cpumask_first(cpumask_of_node(node)))
 
 /*
  * Determines the node for a given pci bus
@@ -121,6 +122,10 @@ extern void arch_fix_phys_package_id(int
 					node_to_cpumask(pcibus_to_node(bus)) \
 				)
 
+#define cpumask_of_pcibus(bus)	(pcibus_to_node(bus) == -1 ?		\
+				 cpu_all_mask :				\
+				 cpumask_from_node(pcibus_to_node(bus)))
+
 #include <asm-generic/topology.h>
 
 #endif /* _ASM_IA64_TOPOLOGY_H */
diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -1001,7 +1001,7 @@ acpi_map_iosapic(acpi_handle handle, u32
 	node = pxm_to_node(pxm);
 
 	if (node >= MAX_NUMNODES || !node_online(node) ||
-	    cpus_empty(node_to_cpumask(node)))
+	    cpumask_empty(cpumask_of_node(node)))
 		return AE_OK;
 
 	/* We know a gsi to node mapping! */
diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -695,16 +695,15 @@ get_target_cpu (unsigned int gsi, int ir
 #ifdef CONFIG_NUMA
 	{
 		int num_cpus, cpu_index, iosapic_index, numa_cpu, i = 0;
-		cpumask_t cpu_mask;
+		const struct cpumask *cpu_mask;
 
 		iosapic_index = find_iosapic(gsi);
 		if (iosapic_index < 0 ||
 		    iosapic_lists[iosapic_index].node == MAX_NUMNODES)
 			goto skip_numa_setup;
 
-		cpu_mask = node_to_cpumask(iosapic_lists[iosapic_index].node);
-		cpus_and(cpu_mask, cpu_mask, domain);
-		for_each_cpu_mask(numa_cpu, cpu_mask) {
+		cpu_mask = cpumask_of_node(iosapic_lists[iosapic_index].node);
+		for_each_cpu_and(numa_cpu, cpu_mask, &domain) {
 			if (!cpu_online(numa_cpu))
 				cpu_clear(numa_cpu, cpu_mask);
 		}
diff --git a/arch/ia64/sn/kernel/sn2/sn_hwperf.c b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
--- a/arch/ia64/sn/kernel/sn2/sn_hwperf.c
+++ b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -385,7 +385,6 @@ static int sn_topology_show(struct seq_f
 	int j;
 	const char *slabname;
 	int ordinal;
-	cpumask_t cpumask;
 	char slice;
 	struct cpuinfo_ia64 *c;
 	struct sn_hwperf_port_info *ptdata;
@@ -473,23 +472,21 @@ static int sn_topology_show(struct seq_f
 		 * CPUs on this node, if any
 		 */
 		if (!SN_HWPERF_IS_IONODE(obj)) {
-			cpumask = node_to_cpumask(ordinal);
-			for_each_online_cpu(i) {
-				if (cpu_isset(i, cpumask)) {
-					slice = 'a' + cpuid_to_slice(i);
-					c = cpu_data(i);
-					seq_printf(s, "cpu %d %s%c local"
-						" freq %luMHz, arch ia64",
-						i, obj->location, slice,
-						c->proc_freq / 1000000);
-					for_each_online_cpu(j) {
-						seq_printf(s, j ? ":%d" : ", dist %d",
-							node_distance(
+			for_each_cpu_and(i, cpu_online_mask,
+					 cpumask_of_node(ordinal)) {
+				slice = 'a' + cpuid_to_slice(i);
+				c = cpu_data(i);
+				seq_printf(s, "cpu %d %s%c local"
+					   " freq %luMHz, arch ia64",
+					   i, obj->location, slice,
+					   c->proc_freq / 1000000);
+				for_each_online_cpu(j) {
+					seq_printf(s, j ? ":%d" : ", dist %d",
+						   node_distance(
 						    	cpu_to_node(i),
 						    	cpu_to_node(j)));
-					}
-					seq_putc(s, '\n');
 				}
+				seq_putc(s, '\n');
 			}
 		}
 	}

