Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbZEHHon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbZEHHon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 03:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755752AbZEHHod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 03:44:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:37621 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911AbZEHHoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 03:44:32 -0400
Message-ID: <4A03E285.6020000@kernel.org>
Date: Fri, 08 May 2009 00:43:01 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@sgi.com>, David Rientjes <rientjes@google.com>
Subject: [PATCH] x86: fix node_possible_map logic
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


recently there are some changes to about meaning of node_possible_map

and it is some strange:
the node without memory would be set in node_possible_map
but some node with less NODE_MIN_SIZE will be kicked out of node_possible_map.

try to fix it by adding strict_setup_node_bootmem.
also remove unparse_node.

so result will be:
1. cpu_to_node will return online node only (nearest one)
2. apicid_to_node still return the node that could be not online but is set
   in node_possible_map.
3. node_possible_map will include nodes that mem on it are less NODE_MIN_SIZE

[ Impact: get node_possible_map right ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/numa_64.h |    5 +++++
 arch/x86/mm/numa_64.c          |    7 +++++++
 arch/x86/mm/srat_64.c          |   29 ++---------------------------
 3 files changed, 14 insertions(+), 27 deletions(-)

Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -38,10 +38,6 @@ static int num_node_memblks __initdata;
 static struct bootnode node_memblk_range[NR_NODE_MEMBLKS] __initdata;
 static int memblk_nodeid[NR_NODE_MEMBLKS] __initdata;
 
-/* Too small nodes confuse the VM badly. Usually they result
-   from BIOS bugs. */
-#define NODE_MIN_SIZE (4*1024*1024)
-
 static __init int setup_node(int pxm)
 {
 	return acpi_map_pxm_to_node(pxm);
@@ -357,17 +353,6 @@ static int __init nodes_cover_memory(con
 	return 1;
 }
 
-static void __init unparse_node(int node)
-{
-	int i;
-	node_clear(node, nodes_parsed);
-	node_clear(node, cpu_nodes_parsed);
-	for (i = 0; i < MAX_LOCAL_APIC; i++) {
-		if (apicid_to_node[i] == node)
-			apicid_to_node[i] = NUMA_NO_NODE;
-	}
-}
-
 void __init acpi_numa_arch_fixup(void) {}
 
 /* Use the information discovered above to actually set up the nodes. */
@@ -379,18 +364,8 @@ int __init acpi_scan_nodes(unsigned long
 		return -1;
 
 	/* First clean up the node list */
-	for (i = 0; i < MAX_NUMNODES; i++) {
+	for (i = 0; i < MAX_NUMNODES; i++)
 		cutoff_node(i, start, end);
-		/*
-		 * don't confuse VM with a node that doesn't have the
-		 * minimum memory.
-		 */
-		if (nodes[i].end &&
-			(nodes[i].end - nodes[i].start) < NODE_MIN_SIZE) {
-			unparse_node(i);
-			node_set_offline(i);
-		}
-	}
 
 	if (!nodes_cover_memory(nodes)) {
 		bad_srat();
@@ -423,7 +398,7 @@ int __init acpi_scan_nodes(unsigned long
 
 		if (node == NUMA_NO_NODE)
 			continue;
-		if (!node_isset(node, node_possible_map))
+		if (!node_online(node))
 			numa_clear_node(i);
 	}
 	numa_init_array();
Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -191,6 +191,13 @@ void __init setup_node_bootmem(int nodei
 	if (!end)
 		return;
 
+	/*
+	 * don't confuse VM with a node that doesn't have the
+	 * minimum memory.
+	 */
+	if (end && (end - start) < NODE_MIN_SIZE)
+		return;
+
 	start = roundup(start, ZONE_ALIGN);
 
 	printk(KERN_INFO "Bootmem setup node %d %016lx-%016lx\n", nodeid,
Index: linux-2.6/arch/x86/include/asm/numa_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/numa_64.h
+++ linux-2.6/arch/x86/include/asm/numa_64.h
@@ -32,6 +32,11 @@ extern void __cpuinit numa_set_node(int
 extern void __cpuinit numa_clear_node(int cpu);
 extern void __cpuinit numa_add_cpu(int cpu);
 extern void __cpuinit numa_remove_cpu(int cpu);
+
+/* Too small nodes confuse the VM badly. Usually they result
+   from BIOS bugs. */
+#define NODE_MIN_SIZE (4*1024*1024)
+
 #else
 static inline void init_cpu_to_node(void)		{ }
 static inline void numa_set_node(int cpu, int node)	{ }
