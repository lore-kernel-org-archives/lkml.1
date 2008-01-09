Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbYAID3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbYAID3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbYAID3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:29:13 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:57216 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYAID3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:29:12 -0500
Date: Tue, 08 Jan 2008 19:34:33 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: cleanup setup_node_zones called by paging_init
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200801081934.33964.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: cleanup setup_node_zones called by paging_init

setup_node_zones calcuates some variable but only use them when FLAT_NODE_MEM_MAP is set

so change the MACRO postion to avoid calculating.

also change it to static

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -227,15 +227,16 @@ void __init setup_node_bootmem(int nodei
 	srat_reserve_add_area(nodeid);
 #endif
 	node_set_online(nodeid);
-} 
+}
 
+#ifdef CONFIG_FLAT_NODE_MEM_MAP
 /* Initialize final allocator for a zone */
-void __init setup_node_zones(int nodeid)
-{ 
+static void __init setup_node_zones(int nodeid)
+{
 	unsigned long start_pfn, end_pfn, memmapsize, limit;
 
- 	start_pfn = node_start_pfn(nodeid);
- 	end_pfn = node_end_pfn(nodeid);
+	start_pfn = node_start_pfn(nodeid);
+	end_pfn = node_end_pfn(nodeid);
 
 	Dprintk(KERN_INFO "Setting up memmap for node %d %lx-%lx\n",
 		nodeid, start_pfn, end_pfn);
@@ -244,14 +245,13 @@ void __init setup_node_zones(int nodeid)
 	   memory. */
 	memmapsize = sizeof(struct page) * (end_pfn-start_pfn);
 	limit = end_pfn << PAGE_SHIFT;
-#ifdef CONFIG_FLAT_NODE_MEM_MAP
-	NODE_DATA(nodeid)->node_mem_map = 
-		__alloc_bootmem_core(NODE_DATA(nodeid)->bdata, 
-				memmapsize, SMP_CACHE_BYTES, 
-				round_down(limit - memmapsize, PAGE_SIZE), 
+	NODE_DATA(nodeid)->node_mem_map =
+		__alloc_bootmem_core(NODE_DATA(nodeid)->bdata,
+				memmapsize, SMP_CACHE_BYTES,
+				round_down(limit - memmapsize, PAGE_SIZE),
 				limit);
+}
 #endif
-} 
 
 void __init numa_init_array(void)
 {
@@ -570,9 +570,11 @@ void __init paging_init(void)
 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
 
+#ifdef CONFIG_FLAT_NODE_MEM_MAP
 	for_each_online_node(i) {
-		setup_node_zones(i); 
+		setup_node_zones(i);
 	}
+#endif
 
 	free_area_init_nodes(max_zone_pfns);
 } 
