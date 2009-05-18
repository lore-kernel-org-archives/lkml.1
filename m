Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbZERHkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbZERHkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbZERHkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:40:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:48952 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222AbZERHkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:40:32 -0400
Date: Mon, 18 May 2009 07:40:05 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A0C49BE.6080800@kernel.org>
References: <4A0C49BE.6080800@kernel.org>
Subject: [tip:x86/mm] x86, mm: Fix node_possible_map logic
Message-ID: <tip-7c43769a9776141ec23ca81a1bdd5a9c0512f165@git.kernel.org>
Git-Commit-ID: 7c43769a9776141ec23ca81a1bdd5a9c0512f165
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 18 May 2009 07:40:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7c43769a9776141ec23ca81a1bdd5a9c0512f165
Gitweb:     http://git.kernel.org/tip/7c43769a9776141ec23ca81a1bdd5a9c0512f165
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 15 May 2009 13:59:37 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 May 2009 09:21:04 +0200

x86, mm: Fix node_possible_map logic

Recently there were some changes to the meaning of node_possible_map,
and it is quite strange:

- the node without memory would be set in node_possible_map
- but some node with less NODE_MIN_SIZE will be kicked out of node_possible_map.

fix it by adding strict_setup_node_bootmem().

Also, remove unparse_node().

so result will be:

1. cpu_to_node() will return online node only (nearest one)
2. apicid_to_node() still returns the node that could be not online but is set
   in node_possible_map.
3. node_possible_map will include nodes that mem on it are less NODE_MIN_SIZE

v2: after move_cpus_to_node change.

[ Impact: get node_possible_map right ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Tested-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <4A0C49BE.6080800@kernel.org>
[ v3: various small cleanups and comment clarifications ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/numa_64.h |    7 +++++++
 arch/x86/mm/numa_64.c          |   13 ++++++++++---
 arch/x86/mm/srat_64.c          |   29 ++---------------------------
 3 files changed, 19 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 7feff06..c4ae822 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -24,6 +24,13 @@ extern void setup_node_bootmem(int nodeid, unsigned long start,
 			       unsigned long end);
 
 #ifdef CONFIG_NUMA
+/*
+ * Too small node sizes may confuse the VM badly. Usually they
+ * result from BIOS bugs. So dont recognize nodes as standalone
+ * NUMA entities that have less than this amount of RAM listed:
+ */
+#define NODE_MIN_SIZE (4*1024*1024)
+
 extern void __init init_cpu_to_node(void);
 extern void __cpuinit numa_set_node(int cpu, int node);
 extern void __cpuinit numa_clear_node(int cpu);
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index a6a93c3..459913b 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -179,18 +179,25 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 }
 
 /* Initialize bootmem allocator for a node */
-void __init setup_node_bootmem(int nodeid, unsigned long start,
-			       unsigned long end)
+void __init
+setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 {
 	unsigned long start_pfn, last_pfn, bootmap_pages, bootmap_size;
+	const int pgdat_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
 	unsigned long bootmap_start, nodedata_phys;
 	void *bootmap;
-	const int pgdat_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
 	int nid;
 
 	if (!end)
 		return;
 
+	/*
+	 * Don't confuse VM with a node that doesn't have the
+	 * minimum amount of memory:
+	 */
+	if (end && (end - start) < NODE_MIN_SIZE)
+		return;
+
 	start = roundup(start, ZONE_ALIGN);
 
 	printk(KERN_INFO "Bootmem setup node %d %016lx-%016lx\n", nodeid,
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index b0dbbd4..2dfcbf9 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -36,10 +36,6 @@ static int num_node_memblks __initdata;
 static struct bootnode node_memblk_range[NR_NODE_MEMBLKS] __initdata;
 static int memblk_nodeid[NR_NODE_MEMBLKS] __initdata;
 
-/* Too small nodes confuse the VM badly. Usually they result
-   from BIOS bugs. */
-#define NODE_MIN_SIZE (4*1024*1024)
-
 static __init int setup_node(int pxm)
 {
 	return acpi_map_pxm_to_node(pxm);
@@ -338,17 +334,6 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
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
@@ -360,18 +345,8 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
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
@@ -404,7 +379,7 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 
 		if (node == NUMA_NO_NODE)
 			continue;
-		if (!node_isset(node, node_possible_map))
+		if (!node_online(node))
 			numa_clear_node(i);
 	}
 	numa_init_array();
