Return-Path: <linux-kernel-owner+w=401wt.eu-S1757657AbZBVXTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbZBVXTr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbZBVXQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:16:30 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39466 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096AbZBVXQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:16:25 -0500
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
Subject: [PATCH 09/20] Calculate the preferred zone for allocation only once
Date: Sun, 22 Feb 2009 23:17:18 +0000
Message-Id: <1235344649-18265-10-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
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
index eaa0ab7..bd7b2c6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1395,24 +1395,19 @@ static void zlc_mark_zone_full(struct zonelist *zonelist, struct zoneref *z)
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
 	int alloc_cpuset = 0;
 
-	(void)first_zones_zonelist(zonelist, high_zoneidx, nodemask,
-							&preferred_zone);
-	if (!preferred_zone)
-		return NULL;
-
 	classzone_idx = zone_idx(preferred_zone);
-
 	VM_BUG_ON(order >= MAX_ORDER);
 
 #ifdef CONFIG_CPUSETS
@@ -1513,7 +1508,7 @@ should_alloc_retry(gfp_t gfp_mask, unsigned int order,
 struct page *
 __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask)
+	nodemask_t *nodemask, struct zone *preferred_zone)
 {
 	struct page *page;
 
@@ -1530,7 +1525,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	 */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask,
 		order, zonelist, high_zoneidx,
-		ALLOC_WMARK_HIGH|ALLOC_CPUSET);
+		ALLOC_WMARK_HIGH|ALLOC_CPUSET,
+		preferred_zone);
 	if (page)
 		goto out;
 
@@ -1550,7 +1546,8 @@ out:
 struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, int alloc_flags, unsigned long *did_some_progress)
+	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
+	unsigned long *did_some_progress)
 {
 	struct page *page = NULL;
 	struct reclaim_state reclaim_state;
@@ -1581,7 +1578,8 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 
 	if (likely(*did_some_progress))
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
-					zonelist, high_zoneidx, alloc_flags);
+					zonelist, high_zoneidx,
+					alloc_flags, preferred_zone);
 	return page;
 }
 
@@ -1602,13 +1600,14 @@ static inline int is_allocation_high_priority(struct task_struct *p,
 struct page *
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
@@ -1630,7 +1629,7 @@ void wake_all_kswapd(unsigned int order, struct zonelist *zonelist, enum zone_ty
 static struct page * noinline
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask)
+	nodemask_t *nodemask, struct zone *preferred_zone)
 {
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 	struct page *page = NULL;
@@ -1680,14 +1679,15 @@ restart:
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
 
@@ -1699,7 +1699,8 @@ restart:
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,
 					nodemask,
-					alloc_flags, &did_some_progress);
+					alloc_flags, preferred_zone,
+					&did_some_progress);
 	if (page)
 		goto got_pg;
 
@@ -1711,7 +1712,7 @@ restart:
 		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
 			page = __alloc_pages_may_oom(gfp_mask, order,
 					zonelist, high_zoneidx,
-					nodemask);
+					nodemask, preferred_zone);
 			if (page)
 				goto got_pg;
 
@@ -1748,6 +1749,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 			struct zonelist *zonelist, nodemask_t *nodemask)
 {
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
+	struct zone *preferred_zone;
 	struct page *page;
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
@@ -1763,11 +1765,20 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
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

