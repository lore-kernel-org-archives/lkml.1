Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbZBVXUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbZBVXUE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:20:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZBVXQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:16:31 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39487 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035AbZBVXQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:16:26 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: [PATCH 10/20] Calculate the migratetype for allocation only once
Date: Sun, 22 Feb 2009 23:17:19 +0000
Message-Id: <1235344649-18265-11-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GFP mask is converted into a migratetype when deciding which pagelist to
take a page from. However, it is happening multiple times per
allocation, at least once per zone traversed. Calculate it once.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |   43 ++++++++++++++++++++++++++-----------------
 1 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bd7b2c6..d0d8c07 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1068,13 +1068,13 @@ void split_page(struct page *page, unsigned int order)
  * or two.
  */
 static struct page *buffered_rmqueue(struct zone *preferred_zone,
-			struct zone *zone, int order, gfp_t gfp_flags)
+			struct zone *zone, int order, gfp_t gfp_flags,
+			int migratetype)
 {
 	unsigned long flags;
 	struct page *page;
 	int cold = !!(gfp_flags & __GFP_COLD);
 	int cpu;
-	int migratetype = allocflags_to_migratetype(gfp_flags);
 
 again:
 	cpu  = get_cpu();
@@ -1396,7 +1396,7 @@ static void zlc_mark_zone_full(struct zonelist *zonelist, struct zoneref *z)
 static struct page *
 get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 		struct zonelist *zonelist, int high_zoneidx, int alloc_flags,
-		struct zone *preferred_zone)
+		struct zone *preferred_zone, int migratetype)
 {
 	struct zoneref *z;
 	struct page *page = NULL;
@@ -1446,7 +1446,8 @@ zonelist_scan:
 			}
 		}
 
-		page = buffered_rmqueue(preferred_zone, zone, order, gfp_mask);
+		page = buffered_rmqueue(preferred_zone, zone, order,
+						gfp_mask, migratetype);
 		if (page)
 			break;
 this_zone_full:
@@ -1508,7 +1509,8 @@ should_alloc_retry(gfp_t gfp_mask, unsigned int order,
 struct page *
 __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, struct zone *preferred_zone)
+	nodemask_t *nodemask, struct zone *preferred_zone,
+	int migratetype)
 {
 	struct page *page;
 
@@ -1526,7 +1528,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask,
 		order, zonelist, high_zoneidx,
 		ALLOC_WMARK_HIGH|ALLOC_CPUSET,
-		preferred_zone);
+		preferred_zone, migratetype);
 	if (page)
 		goto out;
 
@@ -1547,7 +1549,7 @@ struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	unsigned long *did_some_progress)
+	int migratetype, unsigned long *did_some_progress)
 {
 	struct page *page = NULL;
 	struct reclaim_state reclaim_state;
@@ -1579,7 +1581,8 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	if (likely(*did_some_progress))
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,
-					alloc_flags, preferred_zone);
+					alloc_flags, preferred_zone,
+					migratetype);
 	return page;
 }
 
@@ -1600,14 +1603,15 @@ static inline int is_allocation_high_priority(struct task_struct *p,
 struct page *
 __alloc_pages_high_priority(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, struct zone *preferred_zone)
+	nodemask_t *nodemask, struct zone *preferred_zone,
+	int migratetype)
 {
 	struct page *page;
 
 	do {
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
 			zonelist, high_zoneidx, ALLOC_NO_WATERMARKS,
-			preferred_zone);
+			preferred_zone, migratetype);
 
 		if (!page && gfp_mask & __GFP_NOFAIL)
 			congestion_wait(WRITE, HZ/50);
@@ -1629,7 +1633,8 @@ void wake_all_kswapd(unsigned int order, struct zonelist *zonelist, enum zone_ty
 static struct page * noinline
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, struct zone *preferred_zone)
+	nodemask_t *nodemask, struct zone *preferred_zone,
+	int migratetype)
 {
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 	struct page *page = NULL;
@@ -1680,14 +1685,16 @@ restart:
 	 */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 						high_zoneidx, alloc_flags,
-						preferred_zone);
+						preferred_zone,
+						migratetype);
 	if (page)
 		goto got_pg;
 
 	/* Allocate without watermarks if the context allows */
 	if (is_allocation_high_priority(p, gfp_mask))
 		page = __alloc_pages_high_priority(gfp_mask, order,
-			zonelist, high_zoneidx, nodemask, preferred_zone);
+			zonelist, high_zoneidx, nodemask, preferred_zone,
+			migratetype);
 	if (page)
 		goto got_pg;
 
@@ -1700,7 +1707,7 @@ restart:
 					zonelist, high_zoneidx,
 					nodemask,
 					alloc_flags, preferred_zone,
-					&did_some_progress);
+					migratetype, &did_some_progress);
 	if (page)
 		goto got_pg;
 
@@ -1712,7 +1719,8 @@ restart:
 		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
 			page = __alloc_pages_may_oom(gfp_mask, order,
 					zonelist, high_zoneidx,
-					nodemask, preferred_zone);
+					nodemask, preferred_zone,
+					migratetype);
 			if (page)
 				goto got_pg;
 
@@ -1751,6 +1759,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
 	struct zone *preferred_zone;
 	struct page *page;
+	int migratetype = allocflags_to_migratetype(gfp_mask);
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
@@ -1774,11 +1783,11 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 	/* First allocation attempt */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
 			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET,
-			preferred_zone);
+			preferred_zone, migratetype);
 	if (unlikely(!page))
 		page = __alloc_pages_slowpath(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,
-				preferred_zone);
+				preferred_zone, migratetype);
 
 	return page;
 }
-- 
1.5.6.5

