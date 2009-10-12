Return-Path: <linux-kernel-owner+w=401wt.eu-S933229AbZJLVdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229AbZJLVdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933171AbZJLVdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:33:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:60237 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933102AbZJLVdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:33:43 -0400
Date: Mon, 12 Oct 2009 21:32:10 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, andreas.herrmann3@amd.com, ankita@in.ibm.com,
       balbir@linux.vnet.ibm.com, tglx@linutronix.de, rientjes@google.com,
       mingo@elte.hu, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, andreas.herrmann3@amd.com, ankita@in.ibm.com,
       balbir@linux.vnet.ibm.com, tglx@linutronix.de, rientjes@google.com,
       mingo@elte.hu, len.brown@intel.com
In-Reply-To: <alpine.DEB.1.00.0909251518580.14754@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0909251518580.14754@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Export srat physical topology
Message-ID: <tip-8716273caef7f55f39fe4fc6c69c5f9f197f41f1@git.kernel.org>
Git-Commit-ID: 8716273caef7f55f39fe4fc6c69c5f9f197f41f1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 21:32:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8716273caef7f55f39fe4fc6c69c5f9f197f41f1
Gitweb:     http://git.kernel.org/tip/8716273caef7f55f39fe4fc6c69c5f9f197f41f1
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Fri, 25 Sep 2009 15:20:04 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Oct 2009 22:56:46 +0200

x86: Export srat physical topology

This is the counterpart to "x86: export k8 physical topology" for
SRAT. It is not as invasive because the acpi code already seperates
node setup into detection and registration steps, with the
exception of registering e820 active regions in
acpi_numa_memory_affinity_init().  This is now moved to
acpi_scan_nodes() if NUMA emulation is disabled or deferred.

acpi_numa_init() now returns a value which specifies whether an
underlying SRAT was located.  If so, that topology can be used by
the emulation code to interleave emulated nodes over physical nodes
or to register the nodes for ACPI.

acpi_get_nodes() may now be used to export the srat physical
topology of the machine for NUMA emulation.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Ankita Garg <ankita@in.ibm.com>
Cc: Len Brown <len.brown@intel.com>
LKML-Reference: <alpine.DEB.1.00.0909251518580.14754@chino.kir.corp.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/acpi.h |    1 +
 arch/x86/kernel/setup.c     |    5 +++--
 arch/x86/mm/numa_64.c       |    4 ++--
 arch/x86/mm/srat_64.c       |   28 +++++++++++++++++++++-------
 drivers/acpi/numa.c         |   10 ++++++----
 5 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 4518dc5..e3d4a0d 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -158,6 +158,7 @@ struct bootnode;
 
 #ifdef CONFIG_ACPI_NUMA
 extern int acpi_numa;
+extern int acpi_get_nodes(struct bootnode *physnodes);
 extern int acpi_scan_nodes(unsigned long start, unsigned long end);
 #define NR_NODE_MEMBLKS (MAX_NUMNODES*2)
 extern void acpi_fake_nodes(const struct bootnode *fake_nodes,
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index fda0032..f891419 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -938,11 +938,12 @@ void __init setup_arch(char **cmdline_p)
 	/*
 	 * Parse SRAT to discover nodes.
 	 */
-	acpi_numa_init();
+	acpi = acpi_numa_init();
 #endif
 
 #ifdef CONFIG_K8_NUMA
-	k8 = !k8_numa_init(0, max_pfn);
+	if (!acpi)
+		k8 = !k8_numa_init(0, max_pfn);
 #endif
 
 	initmem_init(0, max_pfn, acpi, k8);
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index dad5f42..d1a3d94 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -540,8 +540,8 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 #endif
 
 #ifdef CONFIG_ACPI_NUMA
-	if (!numa_off && !acpi_scan_nodes(start_pfn << PAGE_SHIFT,
-					  last_pfn << PAGE_SHIFT))
+	if (!numa_off && acpi && !acpi_scan_nodes(start_pfn << PAGE_SHIFT,
+						  last_pfn << PAGE_SHIFT))
 		return;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index dbb5381..891cbe6 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -290,8 +290,6 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 
 	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
 	       start, end);
-	e820_register_active_regions(node, start >> PAGE_SHIFT,
-				     end >> PAGE_SHIFT);
 
 	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
 		update_nodes_add(node, start, end);
@@ -338,6 +336,19 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
 
 void __init acpi_numa_arch_fixup(void) {}
 
+int __init acpi_get_nodes(struct bootnode *physnodes)
+{
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
 /* Use the information discovered above to actually set up the nodes. */
 int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 {
@@ -350,11 +361,6 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 	for (i = 0; i < MAX_NUMNODES; i++)
 		cutoff_node(i, start, end);
 
-	if (!nodes_cover_memory(nodes)) {
-		bad_srat();
-		return -1;
-	}
-
 	memnode_shift = compute_hash_shift(node_memblk_range, num_node_memblks,
 					   memblk_nodeid);
 	if (memnode_shift < 0) {
@@ -364,6 +370,14 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 		return -1;
 	}
 
+	for_each_node_mask(i, nodes_parsed)
+		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
+						nodes[i].end >> PAGE_SHIFT);
+	if (!nodes_cover_memory(nodes)) {
+		bad_srat();
+		return -1;
+	}
+
 	/* Account for nodes with cpus and no memory */
 	nodes_or(node_possible_map, nodes_parsed, cpu_nodes_parsed);
 
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 202dd0c..2be2fb6 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -283,22 +283,24 @@ acpi_table_parse_srat(enum acpi_srat_type id,
 
 int __init acpi_numa_init(void)
 {
+	int ret = 0;
+
 	/* SRAT: Static Resource Affinity Table */
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
 				      acpi_parse_x2apic_affinity, NR_CPUS);
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
 				      acpi_parse_processor_affinity, NR_CPUS);
-		acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
-				      acpi_parse_memory_affinity,
-				      NR_NODE_MEMBLKS);
+		ret = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
+					    acpi_parse_memory_affinity,
+					    NR_NODE_MEMBLKS);
 	}
 
 	/* SLIT: System Locality Information Table */
 	acpi_table_parse(ACPI_SIG_SLIT, acpi_parse_slit);
 
 	acpi_numa_arch_fixup();
-	return 0;
+	return ret;
 }
 
 int acpi_get_pxm(acpi_handle h)
