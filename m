Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbXD0GSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbXD0GSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 02:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbXD0GSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 02:18:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38173 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbXD0GSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 02:18:15 -0400
Date: Fri, 27 Apr 2007 15:17:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com
Subject: [PATCH] change global zonelist order v4 [2/2] auto configuration
Message-Id: <20070427151722.dfd142b1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070427144530.ae42ee25.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070427144530.ae42ee25.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add auto zone ordering configuration.

This function will select ZONE_ORDER_NODE when

- There are only ZONE_DMA or ZONE_DMA32.
(or) size of (ZONE_DMA/DMA32) > (System Total Memory)/2
(or) Assume Node(A)
	* Node (A)'s total memory > System Total Memory/num_of_node+1
	(and) Node (A)'s ZONE_DMA/DMA32 occupies 60% of Node(A)'s memory.

otherwise, ZONE_ORDER_ZONE is selected.

Note: a user can specifiy this ordering from boot option.

Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/page_alloc.c |   44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

Index: linux-2.6.21-rc7-mm2/mm/page_alloc.c
===================================================================
--- linux-2.6.21-rc7-mm2.orig/mm/page_alloc.c	2007-04-27 15:39:49.000000000 +0900
+++ linux-2.6.21-rc7-mm2/mm/page_alloc.c	2007-04-27 15:55:51.000000000 +0900
@@ -2211,8 +2211,50 @@
 
 static int estimate_zonelist_order(void)
 {
-	/* dummy, just select node order. */
-	return ZONELIST_ORDER_NODE;
+	int nid, zone_type;
+	unsigned long low_kmem_size,total_size;
+	struct zone *z;
+	int average_size;
+	/* ZONE_DMA and ZONE_DMA32 can be very small area in the sytem.
+	   If they are really small and used heavily,
+	   the system can fall into OOM very easily.
+	   This function detect ZONE_DMA/DMA32 size and confgigure
+	   zone ordering */
+	/* Is there ZONE_NORMAL ? (ex. ppc has only DMA zone..) */
+	low_kmem_size = 0;
+	total_size = 0;
+	for_each_online_node(nid) {
+		for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
+			z = &NODE_DATA(nid)->node_zones[zone_type];
+			if (populated_zone(z)) {
+				if (zone_type < ZONE_NORMAL)
+					low_kmem_size += z->present_pages;
+				total_size += z->present_pages;
+			}
+		}
+	}
+	if (!low_kmem_size ||  /* there is no DMA area. */
+	    !low_kmem_size > total_size/2) /* DMA/DMA32 is big. */
+		return ZONELIST_ORDER_NODE;
+	/* look into each node's config. where all processes starts... */
+	/* average size..a bit smaller than real average size */
+	average_size = total_size / (num_online_nodes() + 1);
+	for_each_online_node(nid) {
+		low_kmem_size = 0;
+		total_size = 0;
+		for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
+			z = &NODE_DATA(nid)->node_zones[zone_type];
+			if (populated_zone(z)) {
+				if (zone_type < ZONE_NORMAL)
+					low_kmem_size += z->present_pages;
+				total_size += z->present_pages;
+			}
+		}
+		if (total_size > average_size && /* ignore unbalanced node */
+		    low_kmem_size > total_size * 60/100)
+			return ZONELIST_ORDER_NODE;
+	}
+	return ZONELIST_ORDER_ZONE;
 }
 
 

