Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab0BITfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:35:10 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:54614 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab0BITdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:33:53 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 09 Feb 2010 11:32:21 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/35] x86: call early_res_to_bootmem one time
In-reply-to: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265743966-17065-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simplify setup_node_mem, do use bootmem from other node.
instead just find_e820_area in early_node_mem.

so we can keep the boundary between early_res and boot mem more clear.
and only call civertion one time instead of for all nodes.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/setup.c |    1 +
 arch/x86/mm/init_32.c   |    1 -
 arch/x86/mm/init_64.c   |    3 +-
 arch/x86/mm/numa_64.c   |   62 +++++++++++++++-------------------------------
 4 files changed, 22 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 3499b4f..48cadbb 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -967,6 +967,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	initmem_init(0, max_pfn, acpi, k8);
+	early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
 
 #ifdef CONFIG_X86_64
 	/*
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 9a0c258..2dccde0 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -764,7 +764,6 @@ static unsigned long __init setup_node_bootmem(int nodeid,
 	printk(KERN_INFO "  node %d bootmap %08lx - %08lx\n",
 		 nodeid, bootmap, bootmap + bootmap_size);
 	free_bootmem_with_active_regions(nodeid, end_pfn);
-	early_res_to_bootmem(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
 
 	return bootmap + bootmap_size;
 }
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 69ddfbd..a15abaa 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -579,13 +579,12 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 				 PAGE_SIZE);
 	if (bootmap == -1L)
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
+	reserve_early(bootmap, bootmap + bootmap_size, "BOOTMAP");
 	/* don't touch min_low_pfn */
 	bootmap_size = init_bootmem_node(NODE_DATA(0), bootmap >> PAGE_SHIFT,
 					 0, end_pfn);
 	e820_register_active_regions(0, start_pfn, end_pfn);
 	free_bootmem_with_active_regions(0, end_pfn);
-	early_res_to_bootmem(0, end_pfn<<PAGE_SHIFT);
-	reserve_bootmem(bootmap, bootmap_size, BOOTMEM_DEFAULT);
 }
 #endif
 
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 83bbc70..3232148 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -164,18 +164,21 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 				    unsigned long align)
 {
 	unsigned long mem = find_e820_area(start, end, size, align);
-	void *ptr;
 
 	if (mem != -1L)
 		return __va(mem);
 
-	ptr = __alloc_bootmem_nopanic(size, align, __pa(MAX_DMA_ADDRESS));
-	if (ptr == NULL) {
-		printk(KERN_ERR "Cannot find %lu bytes in node %d\n",
+
+	start = __pa(MAX_DMA_ADDRESS);
+	end = max_low_pfn_mapped << PAGE_SHIFT;
+	mem = find_e820_area(start, end, size, align);
+	if (mem != -1L)
+		return __va(mem);
+
+	printk(KERN_ERR "Cannot find %lu bytes in node %d\n",
 		       size, nodeid);
-		return NULL;
-	}
-	return ptr;
+
+	return NULL;
 }
 
 /* Initialize bootmem allocator for a node */
@@ -211,8 +214,12 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 	if (node_data[nodeid] == NULL)
 		return;
 	nodedata_phys = __pa(node_data[nodeid]);
+	reserve_early(nodedata_phys, nodedata_phys + pgdat_size, "NODE_DATA");
 	printk(KERN_INFO "  NODE_DATA [%016lx - %016lx]\n", nodedata_phys,
 		nodedata_phys + pgdat_size - 1);
+	nid = phys_to_nid(nodedata_phys);
+	if (nid != nodeid)
+		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nodeid, nid);
 
 	memset(NODE_DATA(nodeid), 0, sizeof(pg_data_t));
 	NODE_DATA(nodeid)->bdata = &bootmem_node_data[nodeid];
@@ -227,11 +234,7 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 	 * of alloc_bootmem, that could clash with reserved range
 	 */
 	bootmap_pages = bootmem_bootmap_pages(last_pfn - start_pfn);
-	nid = phys_to_nid(nodedata_phys);
-	if (nid == nodeid)
-		bootmap_start = roundup(nodedata_phys + pgdat_size, PAGE_SIZE);
-	else
-		bootmap_start = roundup(start, PAGE_SIZE);
+	bootmap_start = roundup(nodedata_phys + pgdat_size, PAGE_SIZE);
 	/*
 	 * SMP_CACHE_BYTES could be enough, but init_bootmem_node like
 	 * to use that to align to PAGE_SIZE
@@ -239,18 +242,13 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 	bootmap = early_node_mem(nodeid, bootmap_start, end,
 				 bootmap_pages<<PAGE_SHIFT, PAGE_SIZE);
 	if (bootmap == NULL)  {
-		if (nodedata_phys < start || nodedata_phys >= end) {
-			/*
-			 * only need to free it if it is from other node
-			 * bootmem
-			 */
-			if (nid != nodeid)
-				free_bootmem(nodedata_phys, pgdat_size);
-		}
+		free_early(nodedata_phys, nodedata_phys + pgdat_size);
 		node_data[nodeid] = NULL;
 		return;
 	}
 	bootmap_start = __pa(bootmap);
+	reserve_early(bootmap_start, bootmap_start+(bootmap_pages<<PAGE_SHIFT),
+			"BOOTMAP");
 
 	bootmap_size = init_bootmem_node(NODE_DATA(nodeid),
 					 bootmap_start >> PAGE_SHIFT,
@@ -259,31 +257,11 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 	printk(KERN_INFO "  bootmap [%016lx -  %016lx] pages %lx\n",
 		 bootmap_start, bootmap_start + bootmap_size - 1,
 		 bootmap_pages);
-
-	free_bootmem_with_active_regions(nodeid, end);
-
-	/*
-	 * convert early reserve to bootmem reserve earlier
-	 * otherwise early_node_mem could use early reserved mem
-	 * on previous node
-	 */
-	early_res_to_bootmem(start, end);
-
-	/*
-	 * in some case early_node_mem could use alloc_bootmem
-	 * to get range on other node, don't reserve that again
-	 */
-	if (nid != nodeid)
-		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nodeid, nid);
-	else
-		reserve_bootmem_node(NODE_DATA(nodeid), nodedata_phys,
-					pgdat_size, BOOTMEM_DEFAULT);
 	nid = phys_to_nid(bootmap_start);
 	if (nid != nodeid)
 		printk(KERN_INFO "    bootmap(%d) on node %d\n", nodeid, nid);
-	else
-		reserve_bootmem_node(NODE_DATA(nodeid), bootmap_start,
-				 bootmap_pages<<PAGE_SHIFT, BOOTMEM_DEFAULT);
+
+	free_bootmem_with_active_regions(nodeid, end);
 
 	node_set_online(nodeid);
 }
-- 
1.6.4.2

