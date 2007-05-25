Return-Path: <linux-kernel-owner+w=401wt.eu-S1760890AbXEYJV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbXEYJV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 05:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758045AbXEYJVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 05:21:49 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:44662 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbXEYJVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 05:21:48 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Message-Id: <20070525092147.17283.10488.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070525092126.17283.41581.sendpatchset@skynet.skynet.ie>
References: <20070525092126.17283.41581.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 1/5] Fix calculation in move_freepages_block for counting pages
Date: Fri, 25 May 2007 10:21:47 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


move_freepages_block() returns the number of blocks moved. This value is
used to determine if a block of pages should be stolen for the exclusive
use of a migrate type or not. However, the value returned is being used
correctly. This patch fixes the calculation to return the number of base
pages that have been moved.

This should be considered a fix to the patch move-free-pages-between-lists-on-steal.patch

Credit to Andy Whitcroft for spotting the problem.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
---

 page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.22-rc2-mm1-clean/mm/page_alloc.c linux-2.6.22-rc2-mm1-001_fix_movefreepages/mm/page_alloc.c
--- linux-2.6.22-rc2-mm1-clean/mm/page_alloc.c	2007-05-24 10:13:34.000000000 +0100
+++ linux-2.6.22-rc2-mm1-001_fix_movefreepages/mm/page_alloc.c	2007-05-24 16:37:27.000000000 +0100
@@ -728,7 +728,7 @@ int move_freepages(struct zone *zone,
 {
 	struct page *page;
 	unsigned long order;
-	int blocks_moved = 0;
+	int pages_moved = 0;
 
 #ifndef CONFIG_HOLES_IN_ZONE
 	/*
@@ -757,10 +757,10 @@ int move_freepages(struct zone *zone,
 		list_add(&page->lru,
 			&zone->free_area[order].free_list[migratetype]);
 		page += 1 << order;
-		blocks_moved++;
+		pages_moved += 1 << order;
 	}
 
-	return blocks_moved;
+	return pages_moved;
 }
 
 int move_freepages_block(struct zone *zone, struct page *page, int migratetype)
@@ -843,7 +843,7 @@ static struct page *__rmqueue_fallback(s
 								start_migratetype);
 
 				/* Claim the whole block if over half of it is free */
-				if ((pages << current_order) >= (1 << (MAX_ORDER-2)))
+				if (pages >= (1 << (MAX_ORDER-2)))
 					set_pageblock_migratetype(page,
 								start_migratetype);
 
