Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbZEENNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbZEENNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbZEENNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:13:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:26378 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbZEENNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:13:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,297,1239001200"; 
   d="scan'208";a="139323169"
Date: Tue, 5 May 2009 21:09:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmscan: ZVC updates in shrink_active_list() can be
	done once
Message-ID: <20090505130923.GA25145@localhost>
References: <20090504234455.GA6324@localhost> <20090505123350.GA19060@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505123350.GA19060@cmpxchg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 08:33:50PM +0800, Johannes Weiner wrote:
> On Tue, May 05, 2009 at 07:44:55AM +0800, Wu Fengguang wrote:
> > This effectively lifts the unit of nr_inactive_* and pgdeactivate updates
> > from PAGEVEC_SIZE=14 to SWAP_CLUSTER_MAX=32.
> 
> For __zone_reclaim() it will be >= SWAP_CLUSTER_MAX, depending on the
> allocation order.

Thanks for pointing out this. Changelog updated accordingly.

I'd expect its impact to be negletable, because 1024 pages are
not extraordinary large.  But sure, that's much larger than 125 pages
- the maximum zone stats update threshold(zone_pcp->stat_threshold).

Thanks,
Fengguang
---
vmscan: ZVC updates in shrink_active_list() can be done once

This effectively lifts the unit of updates to nr_inactive_* and pgdeactivate
from PAGEVEC_SIZE=14 to SWAP_CLUSTER_MAX=32, or MAX_ORDER_NR_PAGES=1024 for
reclaim_zone().

CC: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/vmscan.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- linux.orig/mm/vmscan.c
+++ linux/mm/vmscan.c
@@ -1228,7 +1228,6 @@ static void shrink_active_list(unsigned 
 			struct scan_control *sc, int priority, int file)
 {
 	unsigned long pgmoved;
-	int pgdeactivate = 0;
 	unsigned long pgscanned;
 	LIST_HEAD(l_hold);	/* The pages which were snipped off */
 	LIST_HEAD(l_inactive);
@@ -1257,7 +1256,7 @@ static void shrink_active_list(unsigned 
 		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
 	spin_unlock_irq(&zone->lru_lock);
 
-	pgmoved = 0;
+	pgmoved = 0;  /* count referenced (mapping) mapped pages */
 	while (!list_empty(&l_hold)) {
 		cond_resched();
 		page = lru_to_page(&l_hold);
@@ -1291,7 +1290,7 @@ static void shrink_active_list(unsigned 
 	 */
 	reclaim_stat->recent_rotated[!!file] += pgmoved;
 
-	pgmoved = 0;
+	pgmoved = 0;  /* count pages moved to inactive list */
 	while (!list_empty(&l_inactive)) {
 		page = lru_to_page(&l_inactive);
 		prefetchw_prev_lru_page(page, &l_inactive, flags);
@@ -1304,10 +1303,7 @@ static void shrink_active_list(unsigned 
 		mem_cgroup_add_lru_list(page, lru);
 		pgmoved++;
 		if (!pagevec_add(&pvec, page)) {
-			__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
 			spin_unlock_irq(&zone->lru_lock);
-			pgdeactivate += pgmoved;
-			pgmoved = 0;
 			if (buffer_heads_over_limit)
 				pagevec_strip(&pvec);
 			__pagevec_release(&pvec);
@@ -1315,9 +1311,8 @@ static void shrink_active_list(unsigned 
 		}
 	}
 	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
-	pgdeactivate += pgmoved;
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
-	__count_vm_events(PGDEACTIVATE, pgdeactivate);
+	__count_vm_events(PGDEACTIVATE, pgmoved);
 	spin_unlock_irq(&zone->lru_lock);
 	if (buffer_heads_over_limit)
 		pagevec_strip(&pvec);
