Return-Path: <linux-kernel-owner+w=401wt.eu-S965980AbXEGQf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965980AbXEGQf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 12:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965971AbXEGQfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 12:35:24 -0400
Received: from smtp-out.google.com ([216.239.45.13]:23786 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965944AbXEGQfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 12:35:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=bLkM1v7W0gs6qSAUSCyiRwTzvaSRo6JEY0+UZsPqwd2K6ByKY84fgNuaBVXm/uLbT
	QEJw5guUk/91DpJ8h/qUA==
Date: Mon, 7 May 2007 09:35:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <ak@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: [patch 3/4] x86_64 slit: fake pxm-to-node mapping for fake numa
In-Reply-To: <Pine.LNX.4.64.0705070029570.1899@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0705070030170.1899@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705070028560.1899@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705070029570.1899@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For NUMA emulation, our SLIT should represent the true NUMA topology of
the system but our proximity domain to node ID mapping needs to reflect
the emulated state.

When NUMA emulation has successfully setup fake nodes on the system, a
new function, acpi_fake_nodes() is called.  This function determines the
proximity domain (_PXM) for each true node found on the system.  It then
finds which emulated nodes have been allocated on this true node as
determined by its starting address.  The node ID to PXM mapping is
changed so that each fake node ID points to the PXM of the true node that
it is located on.

If the machine failed to register a SLIT, then we assume there is no
special requirement for emulated node affinity so we use the default
LOCAL_DISTANCE, which is newly exported to this code, as our measurement.

PXM_INVAL and NID_INVAL are also exported to the ACPI header file so that
we can compare node_to_pxm() results in generic code (in this case, the
SRAT code).

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86_64/mm/numa.c     |    3 ++
 arch/x86_64/mm/srat.c     |   67 +++++++++++++++++++++++++++++++++++++++++++--
 drivers/acpi/numa.c       |   11 +++++---
 include/acpi/acpi_numa.h  |    1 +
 include/asm-x86_64/acpi.h |    6 ++++
 include/linux/acpi.h      |    3 ++
 6 files changed, 84 insertions(+), 7 deletions(-)

diff --git a/arch/x86_64/mm/numa.c b/arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c
+++ b/arch/x86_64/mm/numa.c
@@ -476,6 +476,9 @@ out:
 						nodes[i].end >> PAGE_SHIFT);
  		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	}
+#ifdef CONFIG_ACPI_NUMA
+	acpi_fake_nodes(nodes, num_nodes);
+#endif
  	numa_init_array();
  	return 0;
 }
diff --git a/arch/x86_64/mm/srat.c b/arch/x86_64/mm/srat.c
--- a/arch/x86_64/mm/srat.c
+++ b/arch/x86_64/mm/srat.c
@@ -350,7 +350,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 
 /* Sanity check to catch more bad SRATs (they are amazingly common).
    Make sure the PXMs cover all memory. */
-static int nodes_cover_memory(void)
+static __init int nodes_cover_memory(const struct bootnode *nodes)
 {
 	int i;
 	unsigned long pxmram, e820ram;
@@ -406,7 +406,7 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 		}
 	}
 
-	if (!nodes_cover_memory()) {
+	if (!nodes_cover_memory(nodes)) {
 		disable_srat();
 		return -1;
 	}
@@ -440,6 +440,62 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 	return 0;
 }
 
+#ifdef CONFIG_NUMA_EMU
+static int __init find_node_by_addr(const struct bootnode *nodes,
+				    unsigned char num_nodes, unsigned long addr)
+{
+	int ret = NUMA_NO_NODE;
+	int i;
+
+	for (i = 0; i < num_nodes; i++) {
+		/*
+		 * Find all the emulated nodes that appear on this real node.
+		 * For the sake of simplicity, we only use a fake node's
+		 * starting address to determine which real node it appears on.
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
+ * environment.  For each real NUMA node, we find which emulated nodes are
+ * allocated on it and create PXM to NID mappings for those fake nodes which
+ * mirror the locality of the real node they appear on.  SLIT will now
+ * represent the correct distances between emulated nodes as a result of the
+ * real topology.
+ */
+void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
+{
+	int i;
+
+	printk(KERN_INFO "Faking PXM affinity for fake nodes on real "
+			 "topology.\n");
+	for_each_node_mask(i, nodes_parsed) {
+		int nid, pxm;
+
+		pxm = node_to_pxm(i);
+		if (pxm == PXM_INVAL)
+			continue;
+		nid = find_node_by_addr(fake_nodes, num_nodes, nodes[i].start);
+		if (nid == NUMA_NO_NODE)
+			continue;
+		__acpi_map_pxm_to_node(pxm, nid);
+	}
+
+	nodes_clear(nodes_parsed);
+	for (i = 0; i < MAX_NUMNODES; i++)
+		if (fake_nodes[i].start != fake_nodes[i].end)
+			node_set(i, nodes_parsed);
+	WARN_ON(!nodes_cover_memory(fake_nodes));
+}
+#endif /* CONFIG_NUMA_EMU */
+
 void __init srat_reserve_add_area(int nodeid)
 {
 	if (found_add_area && nodes_add[nodeid].end) {
@@ -463,8 +519,13 @@ int __node_distance(int a, int b)
 {
 	int index;
 
-	if (!acpi_slit)
+	if (!acpi_slit) {
+#ifdef CONFIG_NUMA_EMU
+		return LOCAL_DISTANCE;
+#else
 		return a == b ? LOCAL_DISTANCE : REMOTE_DISTANCE;
+#endif
+	}
 	index = acpi_slit->locality_count * node_to_pxm(a);
 	return acpi_slit->entry[index + node_to_pxm(b)];
 }
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -36,8 +36,6 @@
 ACPI_MODULE_NAME("numa");
 
 static nodemask_t nodes_found_map = NODE_MASK_NONE;
-#define PXM_INVAL	-1
-#define NID_INVAL	-1
 
 /* maps to convert between proximity domain and logical node ID */
 static int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS]
@@ -59,6 +57,12 @@ int __cpuinit node_to_pxm(int node)
 	return node_to_pxm_map[node];
 }
 
+void __cpuinit __acpi_map_pxm_to_node(int pxm, int node)
+{
+	pxm_to_node_map[pxm] = node;
+	node_to_pxm_map[node] = pxm;
+}
+
 int __cpuinit acpi_map_pxm_to_node(int pxm)
 {
 	int node = pxm_to_node_map[pxm];
@@ -67,8 +71,7 @@ int __cpuinit acpi_map_pxm_to_node(int pxm)
 		if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
 			return NID_INVAL;
 		node = first_unset_node(nodes_found_map);
-		pxm_to_node_map[pxm] = node;
-		node_to_pxm_map[node] = pxm;
+		__acpi_map_pxm_to_node(pxm, node);
 		node_set(node, nodes_found_map);
 	}
 
diff --git a/include/acpi/acpi_numa.h b/include/acpi/acpi_numa.h
--- a/include/acpi/acpi_numa.h
+++ b/include/acpi/acpi_numa.h
@@ -13,6 +13,7 @@
 
 extern int __cpuinit pxm_to_node(int);
 extern int __cpuinit node_to_pxm(int);
+extern void __cpuinit __acpi_map_pxm_to_node(int, int);
 extern int __cpuinit acpi_map_pxm_to_node(int);
 extern void __cpuinit acpi_unmap_pxm_to_node(int);
 
diff --git a/include/asm-x86_64/acpi.h b/include/asm-x86_64/acpi.h
--- a/include/asm-x86_64/acpi.h
+++ b/include/asm-x86_64/acpi.h
@@ -29,6 +29,9 @@
 #ifdef __KERNEL__
 
 #include <acpi/pdc_intel.h>
+#ifdef CONFIG_NUMA_EMU
+#include <asm/numa.h>
+#endif
 
 #define COMPILER_DEPENDENT_INT64   long long
 #define COMPILER_DEPENDENT_UINT64  unsigned long long
@@ -118,6 +121,9 @@ static inline void acpi_disable_pci(void) { }
 
 extern int acpi_numa;
 extern int acpi_scan_nodes(unsigned long start, unsigned long end);
+#ifdef CONFIG_NUMA_EMU
+extern void acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes);
+#endif
 #define NR_NODE_MEMBLKS (MAX_NUMNODES*2)
 
 #ifdef CONFIG_ACPI_SLEEP
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -230,6 +230,9 @@ extern int acpi_paddr_to_node(u64 start_addr, u64 size);
 
 extern int pnpacpi_disabled;
 
+#define PXM_INVAL	(-1)
+#define NID_INVAL	(-1)
+
 #else	/* CONFIG_ACPI */
 
 static inline int acpi_boot_init(void)
