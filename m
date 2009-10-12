Return-Path: <linux-kernel-owner+w=401wt.eu-S933210AbZJLVdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210AbZJLVdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933192AbZJLVdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:33:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:60219 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313AbZJLVdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:33:17 -0400
Date: Mon, 12 Oct 2009 21:31:54 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, andreas.herrmann3@amd.com, ankita@in.ibm.com,
       balbir@linux.vnet.ibm.com, tglx@linutronix.de, rientjes@google.com,
       mingo@elte.hu, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, andreas.herrmann3@amd.com, ankita@in.ibm.com,
       balbir@linux.vnet.ibm.com, tglx@linutronix.de, rientjes@google.com,
       mingo@elte.hu, len.brown@intel.com
In-Reply-To: <alpine.DEB.1.00.0909251518400.14754@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0909251518400.14754@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Export k8 physical topology
Message-ID: <tip-8ee2debce32412118cf8c239e0026ace56ea1425@git.kernel.org>
Git-Commit-ID: 8ee2debce32412118cf8c239e0026ace56ea1425
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 21:31:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ee2debce32412118cf8c239e0026ace56ea1425
Gitweb:     http://git.kernel.org/tip/8ee2debce32412118cf8c239e0026ace56ea1425
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Fri, 25 Sep 2009 15:20:00 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Oct 2009 22:56:45 +0200

x86: Export k8 physical topology

To eventually interleave emulated nodes over physical nodes, we
need to know the physical topology of the machine without actually
registering it.  This does the k8 node setup in two parts:
detection and registration.  NUMA emulation can then used the
physical topology detected to setup the address ranges of emulated
nodes accordingly.  If emulation isn't used, the k8 nodes are
registered as normal.

Two formals are added to the x86 NUMA setup functions: `acpi' and
`k8'. These represent whether ACPI or K8 NUMA has been detected;
both cannot be true at the same time.  This specifies to the NUMA
emulation code whether an underlying physical NUMA topology exists
and which interface to use.

This patch deals solely with separating the k8 setup path into
Northbridge detection and registration steps and leaves the ACPI
changes for a subsequent patch.  The `acpi' formal is added here,
however, to avoid touching all the header files again in the next
patch.

This approach also ensures emulated nodes will not span physical
nodes so the true memory latency is not misrepresented.

k8_get_nodes() may now be used to export the k8 physical topology
of the machine for NUMA emulation.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Ankita Garg <ankita@in.ibm.com>
Cc: Len Brown <len.brown@intel.com>
LKML-Reference: <alpine.DEB.1.00.0909251518400.14754@chino.kir.corp.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/k8.h         |    4 ++-
 arch/x86/include/asm/page_types.h |    3 +-
 arch/x86/kernel/setup.c           |   10 ++++++-
 arch/x86/mm/init_32.c             |    4 +-
 arch/x86/mm/init_64.c             |    3 +-
 arch/x86/mm/k8topology_64.c       |   52 +++++++++++++++++++++++++++---------
 arch/x86/mm/numa_32.c             |    4 +-
 arch/x86/mm/numa_64.c             |    6 ++--
 8 files changed, 62 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
index c2d1f3b..c092f72 100644
--- a/arch/x86/include/asm/k8.h
+++ b/arch/x86/include/asm/k8.h
@@ -10,7 +10,9 @@ extern struct pci_dev **k8_northbridges;
 extern int num_k8_northbridges;
 extern int cache_k8_northbridges(void);
 extern void k8_flush_garts(void);
-extern int k8_scan_nodes(unsigned long start, unsigned long end);
+extern int k8_get_nodes(struct bootnode *nodes);
+extern int k8_numa_init(unsigned long start_pfn, unsigned long end_pfn);
+extern int k8_scan_nodes(void);
 
 #ifdef CONFIG_K8_NB
 static inline struct pci_dev *node_to_k8_nb_misc(int node)
diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 6473f5c..642fe34 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -49,7 +49,8 @@ extern unsigned long max_pfn_mapped;
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
-extern void initmem_init(unsigned long start_pfn, unsigned long end_pfn);
+extern void initmem_init(unsigned long start_pfn, unsigned long end_pfn,
+				int acpi, int k8);
 extern void free_initmem(void);
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e09f0e2..fda0032 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -106,6 +106,7 @@
 #include <asm/percpu.h>
 #include <asm/topology.h>
 #include <asm/apicdef.h>
+#include <asm/k8.h>
 #ifdef CONFIG_X86_64
 #include <asm/numa_64.h>
 #endif
@@ -691,6 +692,9 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 
 void __init setup_arch(char **cmdline_p)
 {
+	int acpi = 0;
+	int k8 = 0;
+
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
@@ -937,7 +941,11 @@ void __init setup_arch(char **cmdline_p)
 	acpi_numa_init();
 #endif
 
-	initmem_init(0, max_pfn);
+#ifdef CONFIG_K8_NUMA
+	k8 = !k8_numa_init(0, max_pfn);
+#endif
+
+	initmem_init(0, max_pfn, acpi, k8);
 
 #ifdef CONFIG_ACPI_SLEEP
 	/*
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 30938c1..5e32b07 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -703,8 +703,8 @@ void __init find_low_pfn_range(void)
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-void __init initmem_init(unsigned long start_pfn,
-				  unsigned long end_pfn)
+void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
+				int acpi, int k8)
 {
 #ifdef CONFIG_HIGHMEM
 	highstart_pfn = highend_pfn = max_pfn;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 5a4398a..c20d30b 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -568,7 +568,8 @@ kernel_physical_mapping_init(unsigned long start,
 }
 
 #ifndef CONFIG_NUMA
-void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn)
+void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
+				int acpi, int k8)
 {
 	unsigned long bootmap_size, bootmap;
 
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index a81561a..b9e2dbf 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -24,6 +24,9 @@
 #include <asm/apic.h>
 #include <asm/k8.h>
 
+static struct bootnode __initdata nodes[8];
+static nodemask_t __initdata nodes_parsed = NODE_MASK_NONE;
+
 static __init int find_northbridge(void)
 {
 	int num;
@@ -76,12 +79,26 @@ static __init void early_get_boot_cpu_id(void)
 	early_init_lapic_mapping();
 }
 
-int __init k8_scan_nodes(unsigned long start, unsigned long end)
+int __init k8_get_nodes(struct bootnode *physnodes)
 {
-	unsigned numnodes, cores, bits, apicid_base;
+	int i;
+	int ret = 0;
+
+	for_each_node_mask(i, nodes_parsed) {
+		physnodes[ret].start = nodes[i].start;
+		physnodes[ret].end = nodes[i].end;
+		ret++;
+	}
+	return ret;
+}
+
+int __init k8_numa_init(unsigned long start_pfn, unsigned long end_pfn)
+{
+	unsigned long start = PFN_PHYS(start_pfn);
+	unsigned long end = PFN_PHYS(end_pfn);
+	unsigned numnodes;
 	unsigned long prevbase;
-	struct bootnode nodes[8];
-	int i, j, nb, found = 0;
+	int i, nb, found = 0;
 	u32 nodeid, reg;
 
 	if (!early_pci_allowed())
@@ -98,9 +115,8 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 	if (numnodes <= 1)
 		return -1;
 
-	pr_info("Number of nodes %d\n", numnodes);
+	pr_info("Number of physical nodes %d\n", numnodes);
 
-	memset(&nodes, 0, sizeof(nodes));
 	prevbase = 0;
 	for (i = 0; i < 8; i++) {
 		unsigned long base, limit;
@@ -130,7 +146,7 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 			       nodeid, (base >> 8) & 3, (limit >> 8) & 3);
 			return -1;
 		}
-		if (node_isset(nodeid, node_possible_map)) {
+		if (node_isset(nodeid, nodes_parsed)) {
 			pr_info("Node %d already present, skipping\n",
 				nodeid);
 			continue;
@@ -141,8 +157,8 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 		limit |= (1<<24)-1;
 		limit++;
 
-		if (limit > max_pfn << PAGE_SHIFT)
-			limit = max_pfn << PAGE_SHIFT;
+		if (limit > end)
+			limit = end;
 		if (limit <= base)
 			continue;
 
@@ -180,12 +196,23 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 
 		prevbase = base;
 
-		node_set(nodeid, node_possible_map);
+		node_set(nodeid, nodes_parsed);
 	}
 
 	if (!found)
 		return -1;
+	return 0;
+}
 
+int __init k8_scan_nodes(void)
+{
+	unsigned int bits;
+	unsigned int cores;
+	unsigned int apicid_base;
+	int i;
+
+	BUG_ON(nodes_empty(nodes_parsed));
+	node_possible_map = nodes_parsed;
 	memnode_shift = compute_hash_shift(nodes, 8, NULL);
 	if (memnode_shift < 0) {
 		pr_err("No NUMA node hash function found. Contact maintainer\n");
@@ -204,9 +231,8 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 		apicid_base = boot_cpu_physical_apicid;
 	}
 
-	for (i = 0; i < 8; i++) {
-		if (nodes[i].start == nodes[i].end)
-			continue;
+	for_each_node_mask(i, node_possible_map) {
+		int j;
 
 		e820_register_active_regions(i,
 				nodes[i].start >> PAGE_SHIFT,
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index d253006..b20760c 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -347,8 +347,8 @@ static void init_remap_allocator(int nid)
 		(ulong) node_remap_end_vaddr[nid]);
 }
 
-void __init initmem_init(unsigned long start_pfn,
-				  unsigned long end_pfn)
+void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
+				int acpi, int k8)
 {
 	int nid;
 	long kva_target_pfn;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 459913b..dad5f42 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -524,7 +524,8 @@ out:
 }
 #endif /* CONFIG_NUMA_EMU */
 
-void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn)
+void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
+				int acpi, int k8)
 {
 	int i;
 
@@ -547,8 +548,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn)
 #endif
 
 #ifdef CONFIG_K8_NUMA
-	if (!numa_off && !k8_scan_nodes(start_pfn<<PAGE_SHIFT,
-					last_pfn<<PAGE_SHIFT))
+	if (!numa_off && k8 && !k8_scan_nodes())
 		return;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
