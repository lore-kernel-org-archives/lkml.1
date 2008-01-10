Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbYAJTWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbYAJTWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYAJTWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:22:06 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:56724 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbYAJTWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:22:04 -0500
Date: Thu, 10 Jan 2008 11:27:31 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: cleanup setup_node_zones called by paging_init v4
In-reply-to: <200801091234.49003.yinghai.lu@sun.com>
To: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200801101127.31961.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801081934.33964.yinghai.lu@sun.com>
 <Pine.LNX.4.64.0801091117430.11317@schroedinger.engr.sgi.com>
 <200801091234.49003.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check the one against to x86.git mm

[PATCH] x86_64: cleanup setup_node_zones called by paging_init v4

setup_node_zones calcuates some variables but only use them when FLAT_NODE_MEM_MAP is set

so change the MACRO postion to avoid calculating.

also change it to static, and rename it to flat_setup_node_zones

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 8482314..551e359 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -233,8 +233,9 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 	node_set_online(nodeid);
 }
 
+#ifdef CONFIG_FLAT_NODE_MEM_MAP
 /* Initialize final allocator for a zone */
-void __init setup_node_zones(int nodeid)
+static void __init flat_setup_node_zones(int nodeid)
 {
 	unsigned long start_pfn, end_pfn, memmapsize, limit;
 
@@ -250,14 +251,16 @@ void __init setup_node_zones(int nodeid)
 	 */
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
+#else
+#define flat_setup_node_zones(i) do {} while (0)
+#endif
 
 /*
  * There are unfortunately some poorly designed mainboards around that
@@ -581,7 +584,7 @@ void __init paging_init(void)
 	sparse_init();
 
 	for_each_online_node(i)
-		setup_node_zones(i);
+		flat_setup_node_zones(i);
 
 	free_area_init_nodes(max_zone_pfns);
 }
