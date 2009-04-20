Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbZDTWXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbZDTWXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818AbZDTWU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:20:26 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37290 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756476AbZDTWUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:20:20 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 08/25] Calculate the preferred zone for allocation only once
Date: Mon, 20 Apr 2009 23:19:54 +0100
Message-Id: <1240266011-11140-9-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_page_from_freelist() can be called multiple times for an allocation.
Part of this calculates the preferred_zone which is the first usable
zone in the zonelist. This patch calculates preferred_zone once.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |   53 ++++++++++++++++++++++++++++++++---------------------
 1 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3613ba4..b27bcde 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1396,24 +1396,19 @@ static void zlc_mark_zone_full(struct zonelist *zonelist, struct zoneref *z)
  */
 static struct page *
 get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
-		struct zonelist *zonelist, int high_zoneidx, int alloc_flags)
+		struct zonelist *zonelist, int high_zoneidx, int alloc_flags,
+		struct zone *preferred_zone)
 {
 	struct zoneref *z;
 	struct page *page = NULL;
 	int classzone_idx;
-	struct zone *zone, *preferred_zone;
+	struct zone *zone;
 	nodemask_t *allowednodes = NULL;/* zonelist_cache approximation */
 	int zlc_active = 0;		/* set if using zonelist_cache */
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
 	int zonelist_filter = 0;
 
-	(void)first_zones_zonelist(zonelist, high_zoneidx, nodemask,
-							&preferred_zone);
-	if (!preferred_zone)
-		return NULL;
-
 	classzone_idx = zone_idx(preferred_zone);
-
 	VM_BUG_ON(order >= MAX_ORDER);
 
 	/* Determine in advance if the zonelist needs filtering */
@@ -1518,7 +1513,7 @@ should_alloc_retry(gfp_t gfp_mask, unsigned int order,
 static inline struct page *
 __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask)
+	nodemask_t *nodemask, struct zone *preferred_zone)
 {
 	struct page *page;
 
@@ -1535,7 +1530,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	 */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask,
 		order, zonelist, high_zoneidx,
-		ALLOC_WMARK_HIGH|ALLOC_CPUSET);
+		ALLOC_WMARK_HIGH|ALLOC_CPUSET,
+		preferred_zone);
 	if (page)
 		goto out;
 
@@ -1555,7 +1551,8 @@ out:
 static inline struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, int alloc_flags, unsigned long *did_some_progress)
+	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
+	unsigned long *did_some_progress)
 {
 	struct page *page = NULL;
 	struct reclaim_state reclaim_state;
@@ -1587,7 +1584,8 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 
 	if (likely(*did_some_progress))
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
-					zonelist, high_zoneidx, alloc_flags);
+					zonelist, high_zoneidx,
+					alloc_flags, preferred_zone);
 	return page;
 }
 
@@ -1608,13 +1606,14 @@ is_allocation_high_priority(struct task_struct *p, gfp_t gfp_mask)
 static inline struct page *
 __alloc_pages_high_priority(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask)
+	nodemask_t *nodemask, struct zone *preferred_zone)
 {
 	struct page *page;
 
 	do {
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
-			zonelist, high_zoneidx, ALLOC_NO_WATERMARKS);
+			zonelist, high_zoneidx, ALLOC_NO_WATERMARKS,
+			preferred_zone);
 
 		if (!page && gfp_mask & __GFP_NOFAIL)
 			congestion_wait(WRITE, HZ/50);
@@ -1637,7 +1636,7 @@ void wake_all_kswapd(unsigned int order, struct zonelist *zonelist,
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask)
+	nodemask_t *nodemask, struct zone *preferred_zone)
 {
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 	struct page *page = NULL;
@@ -1687,14 +1686,15 @@ restart:
 	 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
 	 */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
-						high_zoneidx, alloc_flags);
+						high_zoneidx, alloc_flags,
+						preferred_zone);
 	if (page)
 		goto got_pg;
 
 	/* Allocate without watermarks if the context allows */
 	if (is_allocation_high_priority(p, gfp_mask))
 		page = __alloc_pages_high_priority(gfp_mask, order,
-			zonelist, high_zoneidx, nodemask);
+			zonelist, high_zoneidx, nodemask, preferred_zone);
 	if (page)
 		goto got_pg;
 
@@ -1706,7 +1706,8 @@ restart:
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,
 					nodemask,
-					alloc_flags, &did_some_progress);
+					alloc_flags, preferred_zone,
+					&did_some_progress);
 	if (page)
 		goto got_pg;
 
@@ -1718,7 +1719,7 @@ restart:
 		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
 			page = __alloc_pages_may_oom(gfp_mask, order,
 					zonelist, high_zoneidx,
-					nodemask);
+					nodemask, preferred_zone);
 			if (page)
 				goto got_pg;
 
@@ -1755,6 +1756,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 			struct zonelist *zonelist, nodemask_t *nodemask)
 {
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
+	struct zone *preferred_zone;
 	struct page *page;
 
 	lockdep_trace_alloc(gfp_mask);
@@ -1772,11 +1774,20 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 	if (unlikely(!zonelist->_zonerefs->zone))
 		return NULL;
 
+	/* The preferred zone is used for statistics later */
+	(void)first_zones_zonelist(zonelist, high_zoneidx, nodemask,
+							&preferred_zone);
+	if (!preferred_zone)
+		return NULL;
+
+	/* First allocation attempt */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
-			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET);
+			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET,
+			preferred_zone);
 	if (unlikely(!page))
 		page = __alloc_pages_slowpath(gfp_mask, order,
-				zonelist, high_zoneidx, nodemask);
+				zonelist, high_zoneidx, nodemask,
+				preferred_zone);
 
 	return page;
 }
-- 
1.5.6.5

