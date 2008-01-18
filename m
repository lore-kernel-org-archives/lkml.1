Return-Path: <linux-kernel-owner+w=401wt.eu-S932665AbYARWnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665AbYARWnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762191AbYARWnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:43:04 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63651 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761983AbYARWnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:43:03 -0500
Date: Fri, 18 Jan 2008 14:48:42 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: only support sparsemem fix
In-reply-to: <Pine.LNX.4.64.0801141147520.8300@schroedinger.engr.sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <200801181448.42472.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801081934.33964.yinghai.lu@sun.com>
 <200801120326.25688.yinghai.lu@sun.com>
 <Pine.LNX.4.64.0801141147520.8300@schroedinger.engr.sgi.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: only support sparsemem fix

sparsemem is only one supported, so could remove FLAT_NODE_MEM related, that is
only needed !SPARSEMEM

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>

--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -240,35 +240,6 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 	node_set_online(nodeid);
 }
 
-#ifdef CONFIG_FLAT_NODE_MEM_MAP
-/* Initialize final allocator for a zone */
-static void __init flat_setup_node_zones(int nodeid)
-{
-	unsigned long start_pfn, end_pfn, memmapsize, limit;
-
-	start_pfn = node_start_pfn(nodeid);
-	end_pfn = node_end_pfn(nodeid);
-
-	Dprintk(KERN_INFO "Setting up memmap for node %d %lx-%lx\n",
-		nodeid, start_pfn, end_pfn);
-
-	/*
-	 * Try to allocate mem_map at end to not fill up precious <4GB
-	 * memory.
-	 */
-	memmapsize = sizeof(struct page) * (end_pfn-start_pfn);
-	limit = end_pfn << PAGE_SHIFT;
-
-	NODE_DATA(nodeid)->node_mem_map =
-		__alloc_bootmem_core(NODE_DATA(nodeid)->bdata,
-				     memmapsize, SMP_CACHE_BYTES,
-				     round_down(limit - memmapsize, PAGE_SIZE),
-				     limit);
-}
-#else
-#define flat_setup_node_zones(i) do {} while (0)
-#endif
-
 /*
  * There are unfortunately some poorly designed mainboards around that
  * only connect memory to a single CPU. This breaks the 1:1 cpu->node
@@ -600,9 +571,6 @@ void __init paging_init(void)
 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
 
-	for_each_online_node(i)
-		flat_setup_node_zones(i);
-
 	free_area_init_nodes(max_zone_pfns);
 }
 
