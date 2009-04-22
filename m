Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbZDVN5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbZDVN5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 09:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbZDVNxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:53:41 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43863 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945AbZDVNxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:53:36 -0400
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
Subject: [PATCH 09/22] Calculate the alloc_flags for allocation only once
Date: Wed, 22 Apr 2009 14:53:14 +0100
Message-Id: <1240408407-21848-10-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out the mapping between GFP and alloc_flags only once. Once factored
out, it only needs to be calculated once but some care must be taken.

[neilb@suse.de says]
As the test:

-       if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
-                       && !in_interrupt()) {
-               if (!(gfp_mask & __GFP_NOMEMALLOC)) {

has been replaced with a slightly weaker one:

+       if (alloc_flags & ALLOC_NO_WATERMARKS) {

Without care, this would allow recursion into the allocator via direct
reclaim. This patch ensures we do not recurse when PF_MEMALLOC is set
but TF_MEMDIE callers are now allowed to directly reclaim where they
would have been prevented in the past.

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/page_alloc.c |   94 +++++++++++++++++++++++++++++-------------------------
 1 files changed, 50 insertions(+), 44 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index eb1548c..0d23795 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1577,15 +1577,6 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	return page;
 }
 
-static inline int
-is_allocation_high_priority(struct task_struct *p, gfp_t gfp_mask)
-{
-	if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
-			&& !in_interrupt())
-		return 1;
-	return 0;
-}
-
 /*
  * This is called in the allocator slow-path if the allocation request is of
  * sufficient urgency to ignore watermarks and take other desperate measures
@@ -1621,6 +1612,42 @@ void wake_all_kswapd(unsigned int order, struct zonelist *zonelist,
 		wakeup_kswapd(zone, order);
 }
 
+static inline int
+gfp_to_alloc_flags(gfp_t gfp_mask)
+{
+	struct task_struct *p = current;
+	int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
+	const gfp_t wait = gfp_mask & __GFP_WAIT;
+
+	/*
+	 * The caller may dip into page reserves a bit more if the caller
+	 * cannot run direct reclaim, or if the caller has realtime scheduling
+	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
+	 * set both ALLOC_HARDER (!wait) and ALLOC_HIGH (__GFP_HIGH).
+	 */
+	if (gfp_mask & __GFP_HIGH)
+		alloc_flags |= ALLOC_HIGH;
+
+	if (!wait) {
+		alloc_flags |= ALLOC_HARDER;
+		/*
+		 * Ignore cpuset if GFP_ATOMIC (!wait) rather than fail alloc.
+		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
+		 */
+		alloc_flags &= ~ALLOC_CPUSET;
+	} else if (unlikely(rt_task(p)))
+		alloc_flags |= ALLOC_HARDER;
+
+	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
+		if (!in_interrupt() &&
+		    ((p->flags & PF_MEMALLOC) ||
+		     unlikely(test_thread_flag(TIF_MEMDIE))))
+			alloc_flags |= ALLOC_NO_WATERMARKS;
+	}
+
+	return alloc_flags;
+}
+
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
@@ -1651,56 +1678,35 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * OK, we're below the kswapd watermark and have kicked background
 	 * reclaim. Now things get more complex, so set up alloc_flags according
 	 * to how we want to proceed.
-	 *
-	 * The caller may dip into page reserves a bit more if the caller
-	 * cannot run direct reclaim, or if the caller has realtime scheduling
-	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
-	 * set both ALLOC_HARDER (!wait) and ALLOC_HIGH (__GFP_HIGH).
 	 */
-	alloc_flags = ALLOC_WMARK_MIN;
-	if ((unlikely(rt_task(p)) && !in_interrupt()) || !wait)
-		alloc_flags |= ALLOC_HARDER;
-	if (gfp_mask & __GFP_HIGH)
-		alloc_flags |= ALLOC_HIGH;
-	if (wait)
-		alloc_flags |= ALLOC_CPUSET;
+	alloc_flags = gfp_to_alloc_flags(gfp_mask);
 
 restart:
-	/*
-	 * Go through the zonelist again. Let __GFP_HIGH and allocations
-	 * coming from realtime tasks go deeper into reserves.
-	 *
-	 * This is the last chance, in general, before the goto nopage.
-	 * Ignore cpuset if GFP_ATOMIC (!wait) rather than fail alloc.
-	 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
-	 */
+	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
-						high_zoneidx, alloc_flags,
-						preferred_zone,
-						migratetype);
+			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
+			preferred_zone, migratetype);
 	if (page)
 		goto got_pg;
 
 rebalance:
 	/* Allocate without watermarks if the context allows */
-	if (is_allocation_high_priority(p, gfp_mask)) {
-		/* Do not dip into emergency reserves if specified */
-		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
-			page = __alloc_pages_high_priority(gfp_mask, order,
-				zonelist, high_zoneidx, nodemask, preferred_zone,
-				migratetype);
-			if (page)
-				goto got_pg;
-		}
-
-		/* Ensure no recursion into the allocator */
-		goto nopage;
+	if (alloc_flags & ALLOC_NO_WATERMARKS) {
+		page = __alloc_pages_high_priority(gfp_mask, order,
+				zonelist, high_zoneidx, nodemask,
+				preferred_zone, migratetype);
+		if (page)
+			goto got_pg;
 	}
 
 	/* Atomic allocations - we can't balance anything */
 	if (!wait)
 		goto nopage;
 
+	/* Avoid recursion of direct reclaim */
+	if (p->flags & PF_MEMALLOC)
+		goto nopage;
+
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,
-- 
1.5.6.5

