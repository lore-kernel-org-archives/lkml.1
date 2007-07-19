Return-Path: <linux-kernel-owner+w=401wt.eu-S937649AbXGSKVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937649AbXGSKVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762794AbXGSJ4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:56:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759932AbXGSJzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:38 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: rientjes@google.com, ak@suse.de, lenb@kernel.org, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [45/58] x86_64: fake pxm-to-node mapping for fake numa
Message-Id: <20070719095531.C4DFE14E05@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: David Rientjes <rientjes@google.com>

For NUMA emulation, our SLIT should represent the true NUMA topology of the
system but our proximity domain to node ID mapping needs to reflect the
emulated state.

When NUMA emulation has successfully setup fake nodes on the system, a new
function, acpi_fake_nodes() is called.  This function determines the proximity
domain (_PXM) for each true node found on the system.  It then finds which
emulated nodes have been allocated on this true node as determined by its
starting address.  The node ID to PXM mapping is changed so that each fake
node ID points to the PXM of the true node that it is located on.

If the machine failed to register a SLIT, then we assume there is no special
requirement for emulated node affinity so we use the default LOCAL_DISTANCE,
which is newly exported to this code, as our measurement if the emulated nodes
appear in the same PXM.  Otherwise, we use REMOTE_DISTANCE.

PXM_INVAL and NID_INVAL are also exported to the ACPI header file so that we
can compare node_to_pxm() results in generic code (in this case, the SRAT
code).

Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/mm/numa.c     |    1 
 arch/x86_64/mm/srat.c     |   76 ++++++++++++++++++++++++++++++++++++++++++++--
 drivers/acpi/numa.c       |   11 ++++--
 include/acpi/acpi_numa.h  |    1 
 include/asm-x86_64/acpi.h |   11 ++++++
 include/linux/acpi.h      |    3 +
 6 files changed, 96 insertions(+), 7 deletions(-)

Index: linux/arch/x86_64/mm/numa.c
===================================================================
--- linux.orig/arch/x86_64/mm/numa.c
+++ linux/arch/x86_64/mm/numa.c
@@ -484,6 +484,7 @@ out:
 						nodes[i].end >> PAGE_SHIFT);
  		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	}
+	acpi_fake_nodes(nodes, num_nodes);
  	numa_init_array();
  	return 0;
 }
Index: linux/arch/x86_64/mm/srat.c
===================================================================
--- linux.orig/arch/x86_64/mm/srat.c
+++ linux/arch/x86_64/mm/srat.c
@@ -350,7 +350,7 @@ acpi_numa_memory_affinity_init(struct ac
 
 /* Sanity check to catch more bad SRATs (they are amazingly common).
    Make sure the PXMs cover all memory. */
-static int nodes_cover_memory(void)
+static int __init nodes_cover_memory(const struct bootnode *nodes)
 {
 	int i;
 	unsigned long pxmram, e820ram;
@@ -406,7 +406,7 @@ int __init acpi_scan_nodes(unsigned long
 		}
 	}
 
-	if (!nodes_cover_memory()) {
+	if (!nodes_cover_memory(nodes)) {
 		bad_srat();
 		return -1;
 	}
@@ -440,6 +440,75 @@ int __init acpi_scan_nodes(unsigned long
 	return 0;
 }
 
+#ifdef CONFIG_NUMA_EMU
+static int __init find_node_by_addr(unsigned long addr)
+{
+	int ret = NUMA_NO_NODE;
+	int i;
+
+	for_each_node_mask(i, nodes_parsed) {
+		/*
+		 * Find the real node that this emulated node appears on.  For
+		 * the sake of simplicity, we only use a real node's starting
+		 * address to determine which emulated node it appears on.
+		 */
+		if (addr >= nodes[i].start && addr < nodes[i].end) {
+			ret = i;
+			break;
+		}
+	}
+	return i;
+}
+
+/*
+ * In NUMA emulation, we need to setup proximity domain (_PXM) to node ID
+ * mappings that respect the real ACPI topology but reflect our emulated
+ * environment.  For each emulated node, we find which real node it appears on
+ * and create PXM to NID mappings for those fake nodes which mirror that
+ * locality.  SLIT will now represent the correct distances between emulated
+ * nodes as a result of the real topology.
+ */
+void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
+{
+	int i;
+	int fake_node_to_pxm_map[MAX_NUMNODES] = {
+		[0 ... MAX_NUMNODES-1] = PXM_INVAL
+	};
+
+	printk(KERN_INFO "Faking PXM affinity for fake nodes on real "
+			 "topology.\n");
+	for (i = 0; i < num_nodes; i++) {
+		int nid, pxm;
+
+		nid = find_node_by_addr(fake_nodes[i].start);
+		if (nid == NUMA_NO_NODE)
+			continue;
+		pxm = node_to_pxm(nid);
+		if (pxm == PXM_INVAL)
+			continue;
+		fake_node_to_pxm_map[i] = pxm;
+	}
+	for (i = 0; i < num_nodes; i++)
+		__acpi_map_pxm_to_node(fake_node_to_pxm_map[i], i);
+
+	nodes_clear(nodes_parsed);
+	for (i = 0; i < num_nodes; i++)
+		if (fake_nodes[i].start != fake_nodes[i].end)
+			node_set(i, nodes_parsed);
+	WARN_ON(!nodes_cover_memory(fake_nodes));
+}
+
+static int null_slit_node_compare(int a, int b)
+{
+	return node_to_pxm(a) == node_to_pxm(b);
+}
+#else
+static int null_slit_node_compare(int a, int b)
+{
+	return a == b;
+}
+#endif /* CONFIG_NUMA_EMU */
+
 void __init srat_reserve_add_area(int nodeid)
 {
 	if (found_add_area && nodes_add[nodeid].end) {
@@ -464,7 +533,8 @@ int __node_distance(int a, int b)
 	int index;
 
 	if (!acpi_slit)
-		return a == b ? LOCAL_DISTANCE : REMOTE_DISTANCE;
+		return null_slit_node_compare(a, b) ? LOCAL_DISTANCE :
+						      REMOTE_DISTANCE;
 	index = acpi_slit->locality_count * node_to_pxm(a);
 	return acpi_slit->entry[index + node_to_pxm(b)];
 }
Index: linux/drivers/acpi/numa.c
===================================================================
--- linux.orig/drivers/acpi/numa.c
+++ linux/drivers/acpi/numa.c
@@ -36,8 +36,6 @@
 ACPI_MODULE_NAME("numa");
 
 static nodemask_t nodes_found_map = NODE_MASK_NONE;
-#define PXM_INVAL	-1
-#define NID_INVAL	-1
 
 /* maps to convert between proximity domain and logical node ID */
 static int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS]
@@ -59,6 +57,12 @@ int node_to_pxm(int node)
 	return node_to_pxm_map[node];
 }
 
+void __acpi_map_pxm_to_node(int pxm, int node)
+{
+	pxm_to_node_map[pxm] = node;
+	node_to_pxm_map[node] = pxm;
+}
+
 int acpi_map_pxm_to_node(int pxm)
 {
 	int node = pxm_to_node_map[pxm];
@@ -67,8 +71,7 @@ int acpi_map_pxm_to_node(int pxm)
 		if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
 			return NID_INVAL;
 		node = first_unset_node(nodes_found_map);
-		pxm_to_node_map[pxm] = node;
-		node_to_pxm_map[node] = pxm;
+		__acpi_map_pxm_to_node(pxm, node);
 		node_set(node, nodes_found_map);
 	}
 
Index: linux/include/acpi/acpi_numa.h
===================================================================
--- linux.orig/include/acpi/acpi_numa.h
+++ linux/include/acpi/acpi_numa.h
@@ -13,6 +13,7 @@
 
 extern int pxm_to_node(int);
 extern int node_to_pxm(int);
+extern void __acpi_map_pxm_to_node(int, int);
 extern int acpi_map_pxm_to_node(int);
 extern void __cpuinit acpi_unmap_pxm_to_node(int);
 
Index: linux/include/asm-x86_64/acpi.h
===================================================================
--- linux.orig/include/asm-x86_64/acpi.h
+++ linux/include/asm-x86_64/acpi.h
@@ -29,6 +29,7 @@
 #ifdef __KERNEL__
 
 #include <acpi/pdc_intel.h>
+#include <asm/numa.h>
 
 #define COMPILER_DEPENDENT_INT64   long long
 #define COMPILER_DEPENDENT_UINT64  unsigned long long
@@ -141,6 +142,16 @@ extern int acpi_pci_disabled;
 extern int acpi_skip_timer_override;
 extern int acpi_use_timer_override;
 
+#ifdef CONFIG_ACPI_NUMA
+extern void __init acpi_fake_nodes(const struct bootnode *fake_nodes,
+				   int num_nodes);
+#else
+static inline void acpi_fake_nodes(const struct bootnode *fake_nodes,
+				   int num_nodes)
+{
+}
+#endif
+
 #endif /*__KERNEL__*/
 
 #endif /*_ASM_ACPI_H*/
Index: linux/include/linux/acpi.h
===================================================================
--- linux.orig/include/linux/acpi.h
+++ linux/include/linux/acpi.h
@@ -231,6 +231,9 @@ extern int acpi_paddr_to_node(u64 start_
 
 extern int pnpacpi_disabled;
 
+#define PXM_INVAL	(-1)
+#define NID_INVAL	(-1)
+
 #else	/* CONFIG_ACPI */
 
 static inline int acpi_boot_init(void)
