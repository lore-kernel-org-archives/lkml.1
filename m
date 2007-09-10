Return-Path: <linux-kernel-owner+w=401wt.eu-S932660AbXIJLYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660AbXIJLYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 07:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932382AbXIJLXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 07:23:16 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44726 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933324AbXIJLXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 07:23:14 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Message-Id: <20070910112312.3097.83731.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070910112011.3097.8438.sendpatchset@skynet.skynet.ie>
References: <20070910112011.3097.8438.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 9/13] Do not group pages by mobility type on low memory systems
Date: Mon, 10 Sep 2007 12:23:12 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Do not group pages by mobility type on low memory systems

Where there are fewer than one pageblock in the system per mobility
type mixing is inevitable and any attempt to prevent it will fail
in a costly manner. This patch checks the size of vm_total_pages in
build_all_zonelists(). If there are not enough areas,  mobility is effectivly
disabled by considering all allocations as the same type (UNMOVABLE).
This is achived via a __read_mostly flag.

This patch removes any need to disable grouping pages by mobility at
compile time.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc5-008-move-free-pages-between-lists-on-steal/mm/page_alloc.c linux-2.6.23-rc5-009-do-not-group-pages-by-mobility-type-on-low-memory-systems/mm/page_alloc.c
--- linux-2.6.23-rc5-008-move-free-pages-between-lists-on-steal/mm/page_alloc.c	2007-09-02 16:21:09.000000000 +0100
+++ linux-2.6.23-rc5-009-do-not-group-pages-by-mobility-type-on-low-memory-systems/mm/page_alloc.c	2007-09-02 16:21:30.000000000 +0100
@@ -154,8 +154,13 @@ int nr_node_ids __read_mostly = MAX_NUMN
 EXPORT_SYMBOL(nr_node_ids);
 #endif
 
+int page_group_by_mobility_disabled __read_mostly;
+
 static inline int get_pageblock_migratetype(struct page *page)
 {
+	if (unlikely(page_group_by_mobility_disabled))
+		return MIGRATE_UNMOVABLE;
+
 	return get_pageblock_flags_group(page, PB_migrate, PB_migrate_end);
 }
 
@@ -169,6 +174,10 @@ static inline int allocflags_to_migratet
 {
 	WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
 
+	if (unlikely(page_group_by_mobility_disabled))
+		return MIGRATE_UNMOVABLE;
+
+	/* Cluster based on mobility */
 	return (((gfp_flags & __GFP_MOVABLE) != 0) << 1) |
 		((gfp_flags & __GFP_RECLAIMABLE) != 0);
 }
@@ -2294,9 +2303,23 @@ void build_all_zonelists(void)
 		/* cpuset refresh routine should be here */
 	}
 	vm_total_pages = nr_free_pagecache_pages();
-	printk("Built %i zonelists in %s order.  Total pages: %ld\n",
+	/*
+	 * Disable grouping by mobility if the number of pages in the
+	 * system is too low to allow the mechanism to work. It would be
+	 * more accurate, but expensive to check per-zone. This check is
+	 * made on memory-hotadd so a system can start with mobility
+	 * disabled and enable it later
+	 */
+	if (vm_total_pages < (pageblock_nr_pages * MIGRATE_TYPES))
+		page_group_by_mobility_disabled = 1;
+	else
+		page_group_by_mobility_disabled = 0;
+
+	printk("Built %i zonelists in %s order, mobility grouping %s.  "
+		"Total pages: %ld\n",
 			num_online_nodes(),
 			zonelist_order_name[current_zonelist_order],
+			page_group_by_mobility_disabled ? "off" : "on",
 			vm_total_pages);
 #ifdef CONFIG_NUMA
 	printk("Policy zone: %s\n", zone_names[policy_zone]);
