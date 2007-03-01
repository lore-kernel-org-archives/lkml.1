Return-Path: <linux-kernel-owner+w=401wt.eu-S964840AbXCAKGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964840AbXCAKGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 05:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964831AbXCAKGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 05:06:37 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:57129 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964798AbXCAKGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 05:06:32 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Message-Id: <20070301100630.29753.64743.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070301100229.29753.86342.sendpatchset@skynet.skynet.ie>
References: <20070301100229.29753.86342.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 12/12] Be more agressive about stealing when MIGRATE_RECLAIMABLE allocations fallback
Date: Thu,  1 Mar 2007 10:06:30 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


MIGRATE_RECLAIMABLE allocations tend to be very bursty in nature like
when updatedb starts. It is likely this will occur in situations where
MAX_ORDER blocks of pages are not free. This means that updatedb can scatter
MIGRATE_RECLAIMABLE pages throughout the address space. This patch is more
agressive about stealing blocks of pages for MIGRATE_RECLAIMABLE.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---

 page_alloc.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.20-mm2-011_biasplacement/mm/page_alloc.c linux-2.6.20-mm2-012_grabbyreclaim/mm/page_alloc.c
--- linux-2.6.20-mm2-011_biasplacement/mm/page_alloc.c	2007-02-20 18:52:18.000000000 +0000
+++ linux-2.6.20-mm2-012_grabbyreclaim/mm/page_alloc.c	2007-02-20 18:54:35.000000000 +0000
@@ -806,11 +806,23 @@ retry:
 
 			/*
 			 * If breaking a large block of pages, move all free
-			 * pages to the preferred allocation list
+			 * pages to the preferred allocation list. If falling
+			 * back for a reclaimable kernel allocation, be more
+			 * agressive about taking ownership of free pages
 			 */
-			if (unlikely(current_order >= MAX_ORDER / 2)) {
+			if (unlikely(current_order >= MAX_ORDER / 2) ||
+					start_migratetype == MIGRATE_RECLAIMABLE) {
+				unsigned long pages;
+				pages = move_freepages_block(zone, page,
+								start_migratetype);
+
+				/* Claim the whole block if over half of it is free */
+				if ((pages << current_order) >= (1 << (MAX_ORDER-2)) &&
+						migratetype != MIGRATE_HIGHATOMIC)
+					set_pageblock_migratetype(page,
+								start_migratetype);
+
 				migratetype = start_migratetype;
-				move_freepages_block(zone, page, migratetype);
 			}
 
 			/* Remove the page from the freelists */
