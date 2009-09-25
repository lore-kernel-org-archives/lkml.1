Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbZIYWVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbZIYWVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZIYWUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:20:20 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58683 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbZIYWUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:20:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=aiipS0DAvrMSO+NElMOfz/lrquHwWzcA8DH3Prj1sMSpm2DMTaPVzc2vPyb83sy+C
	1dRbJG7sdAbZLZ6Gdlz8g==
Date: Fri, 25 Sep 2009 15:20:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
cc: Yinghai Lu <yinghai@kernel.org>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Ankita Garg <ankita@in.ibm.com>, Len Brown <len.brown@intel.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 2/4] x86: export k8 physical topology
In-Reply-To: <alpine.DEB.1.00.0909251517440.14754@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0909251518400.14754@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0909251517440.14754@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To eventually interleave emulated nodes over physical nodes, we need to
know the physical topology of the machine without actually registering
it.  This does the k8 node setup in two parts: detection and
registration.  NUMA emulation can then used the physical topology
detected to setup the address ranges of emulated nodes accordingly.  If
emulation isn't used, the k8 nodes are registered as normal.

Two formals are added to the x86 NUMA setup functions: `acpi' and `k8'.
These represent whether ACPI or K8 NUMA has been detected; both cannot be
true at the same time.  This specifies to the NUMA emulation code whether
an underlying physical NUMA topology exists and which interface to use.

This patch deals solely with separating the k8 setup path into
Northbridge detection and registration steps and leaves the ACPI changes
for a subsequent patch.  The `acpi' formal is added here, however, to
avoid touching all the header files again in the next patch.

This approach also ensures emulated nodes will not span physical nodes so
the true memory latency is not misrepresented.

k8_get_nodes() may now be used to export the k8 physical topology of the
machine for NUMA emulation.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Ankita Garg <ankita@in.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
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
