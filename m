Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZIYWUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZIYWUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbZIYWUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:20:16 -0400
Received: from smtp-out.google.com ([216.239.45.13]:46622 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbZIYWUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:20:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=WYxWUCMEIS743Dq2NV1hRNxxsakvYFfPjnT5G6iYjr5f4f4QoLhadguX7tCXHd5BT
	OeC8GpxfW/qxP0il2v+6Q==
Date: Fri, 25 Sep 2009 15:20:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
cc: Yinghai Lu <yinghai@kernel.org>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Ankita Garg <ankita@in.ibm.com>, Len Brown <len.brown@intel.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 3/4] x86: export srat physical topology
In-Reply-To: <alpine.DEB.1.00.0909251517440.14754@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0909251518580.14754@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0909251517440.14754@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the counterpart to "x86: export k8 physical topology" for SRAT.
It is not as invasive because the acpi code already seperates node setup
into detection and registration steps, with the exception of registering
e820 active regions in acpi_numa_memory_affinity_init().  This is now
moved to acpi_scan_nodes() if NUMA emulation is disabled or deferred.

acpi_numa_init() now returns a value which specifies whether an
underlying SRAT was located.  If so, that topology can be used by the
emulation code to interleave emulated nodes over physical nodes or to
register the nodes for ACPI.

acpi_get_nodes() may now be used to export the srat physical topology of
the machine for NUMA emulation.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Ankita Garg <ankita@in.ibm.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/include/asm/acpi.h |    1 +
 arch/x86/kernel/setup.c     |    5 +++--
 arch/x86/mm/numa_64.c       |    4 ++--
 arch/x86/mm/srat_64.c       |   28 +++++++++++++++++++++-------
 drivers/acpi/numa.c         |   10 ++++++----
 5 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
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
