Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbYAISZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbYAISZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 13:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbYAISZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 13:25:47 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:43567 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbYAISZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 13:25:46 -0500
Date: Wed, 09 Jan 2008 10:30:40 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: cleanup setup_node_zones called by paging_init v2
In-reply-to: <Pine.LNX.4.64.0801090947570.10163@schroedinger.engr.sgi.com>
To: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200801091030.40545.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801081934.33964.yinghai.lu@sun.com>
 <Pine.LNX.4.64.0801090947570.10163@schroedinger.engr.sgi.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: cleanup setup_node_zones called by paging_init v2

setup_node_zones calcuates some variable but only use them when FLAT_NODE_MEM_MAP is set

so change the MACRO postion to avoid calculating.

also change it to static

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -229,8 +229,9 @@ void __init setup_node_bootmem(int nodei
 	node_set_online(nodeid);
 } 
 
+#ifdef CONFIG_FLAT_NODE_MEM_MAP
 /* Initialize final allocator for a zone */
-void __init setup_node_zones(int nodeid)
+static void __init setup_node_zones(int nodeid)
 { 
 	unsigned long start_pfn, end_pfn, memmapsize, limit;
 
@@ -244,14 +245,14 @@ void __init setup_node_zones(int nodeid)
 	   memory. */
 	memmapsize = sizeof(struct page) * (end_pfn-start_pfn);
 	limit = end_pfn << PAGE_SHIFT;
-#ifdef CONFIG_FLAT_NODE_MEM_MAP
+
 	NODE_DATA(nodeid)->node_mem_map = 
 		__alloc_bootmem_core(NODE_DATA(nodeid)->bdata, 
 				memmapsize, SMP_CACHE_BYTES, 
 				round_down(limit - memmapsize, PAGE_SIZE), 
 				limit);
-#endif
 } 
+#endif
 
 void __init numa_init_array(void)
 {
@@ -570,9 +571,11 @@ void __init paging_init(void)
 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
 
+#ifdef CONFIG_FLAT_NODE_MEM_MAP
 	for_each_online_node(i) {
 		setup_node_zones(i); 
 	}
+#endif
 
 	free_area_init_nodes(max_zone_pfns);
 } 

