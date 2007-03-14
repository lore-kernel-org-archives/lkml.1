Return-Path: <linux-kernel-owner+w=401wt.eu-S932787AbXCNTKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbXCNTKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932805AbXCNTKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:10:10 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:46085 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787AbXCNTKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:10:09 -0400
Date: Wed, 14 Mar 2007 19:10:05 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Avoid unsafe use of struct pages in move_freepages when CONFIG_HOLES_IN_ZONE is set
Message-ID: <20070314191005.GA21733@skynet.ie>
References: <20070307201915.4d579113.akpm@linux-foundation.org> <200703141052.19792.bjorn.helgaas@hp.com> <20070314172141.GA17891@skynet.ie> <200703141236.09599.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200703141236.09599.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In the majority of situations, mem_map is guaranteed to be valid within
a MAX_ORDER_NR_PAGES block of pages. However, when CONFIG_HOLES_IN_ZONE
is set, there is no guarantee that mem_map exists for the entire block.
This means that when checking struct pages around a known valid page, there
is no guarantee they are valid. 

move_freepages() operates on a MAX_ORDER_NR_PAGES range of pages based on
a known valid page retrieved from the free lists. However, a bug check is
unsafe when CONFIG_HOLES_IN_ZONE is set and pfn_valid() is called too late.

This patch disables the bug check when CONFIG_HOLES_IN_ZONE and checks
pfn_valid() earlier before calling PageBuddy(). It applies on top of
move-free-pages-between-lists-on-steal-fix-2.patch from Yasunori Goto in -mm.

Credit to Bjorn Helgaas for reporting this bug and testing.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>

 page_alloc.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc3-mm2-goto/mm/page_alloc.c linux-2.6.21-rc3-mm2-zone_holes_ia64_fix/mm/page_alloc.c
--- linux-2.6.21-rc3-mm2-goto/mm/page_alloc.c	2007-03-14 16:07:23.000000000 +0000
+++ linux-2.6.21-rc3-mm2-zone_holes_ia64_fix/mm/page_alloc.c	2007-03-14 18:51:41.000000000 +0000
@@ -707,13 +707,18 @@ int move_freepages(struct zone *zone,
 	unsigned long order;
 	int blocks_moved = 0;
 
+#ifndef CONFIG_HOLES_IN_ZONE
+	/*
+	 * page_zone is not safe to call in this context when
+	 * CONFIG_HOLES_IN_ZONE is set. This bug check is probably redundant
+	 * anyway as we check zone boundaries in move_freepages_block().
+	 * Remove at a later date when no bug reports exist related to
+	 * CONFIG_PAGE_GROUP_BY_MOBILITY
+	 */
 	BUG_ON(page_zone(start_page) != page_zone(end_page - 1));
+#endif
 
 	for (page = start_page; page < end_page;) {
-		if (!PageBuddy(page)) {
-			page++;
-			continue;
-		}
 #ifdef CONFIG_HOLES_IN_ZONE
 		if (!pfn_valid(page_to_pfn(page))) {
 			page++;
@@ -721,6 +726,11 @@ int move_freepages(struct zone *zone,
 		}
 #endif
 
+		if (!PageBuddy(page)) {
+			page++;
+			continue;
+		}
+
 		order = page_order(page);
 		list_del(&page->lru);
 		list_add(&page->lru,
