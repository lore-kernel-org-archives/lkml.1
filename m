Return-Path: <linux-kernel-owner+w=401wt.eu-S1754981Ab0ANBfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab0ANBfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 20:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351Ab0ANBfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 20:35:08 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40886 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0ANBfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 20:35:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Huang Shijie <shijie8@gmail.com>
Subject: [resend][PATCH] mm: Restore zone->all_unreclaimable to independence word
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100114103332.D71B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 Jan 2010 10:35:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e815af95 (change all_unreclaimable zone member to flags) chage
all_unreclaimable member to bit flag. but It have undesireble side
effect.
free_one_page() is one of most hot path in linux kernel and increasing
atomic ops in it can reduce kernel performance a bit.

Thus, this patch revert such commit partially. at least
all_unreclaimable shouldn't share memory word with other zone flags.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/mmzone.h |    7 +------
 mm/page_alloc.c        |    6 +++---
 mm/vmscan.c            |   20 ++++++++------------
 mm/vmstat.c            |    2 +-
 4 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 30fe668..4f0c6f1 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -341,6 +341,7 @@ struct zone {
 
 	unsigned long		pages_scanned;	   /* since last reclaim */
 	unsigned long		flags;		   /* zone flags, see below */
+	int                     all_unreclaimable; /* All pages pinned */
 
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
@@ -425,7 +426,6 @@ struct zone {
 } ____cacheline_internodealigned_in_smp;
 
 typedef enum {
-	ZONE_ALL_UNRECLAIMABLE,		/* all pages pinned */
 	ZONE_RECLAIM_LOCKED,		/* prevents concurrent reclaim */
 	ZONE_OOM_LOCKED,		/* zone is in OOM killer zonelist */
 } zone_flags_t;
@@ -445,11 +445,6 @@ static inline void zone_clear_flag(struct zone *zone, zone_flags_t flag)
 	clear_bit(flag, &zone->flags);
 }
 
-static inline int zone_is_all_unreclaimable(const struct zone *zone)
-{
-	return test_bit(ZONE_ALL_UNRECLAIMABLE, &zone->flags);
-}
-
 static inline int zone_is_reclaim_locked(const struct zone *zone)
 {
 	return test_bit(ZONE_RECLAIM_LOCKED, &zone->flags);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4e9f5cc..19a5b0e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -530,7 +530,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	int batch_free = 0;
 
 	spin_lock(&zone->lock);
-	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
+	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
 	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
@@ -567,7 +567,7 @@ static void free_one_page(struct zone *zone, struct page *page, int order,
 				int migratetype)
 {
 	spin_lock(&zone->lock);
-	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
+	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
 	__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
@@ -2270,7 +2270,7 @@ void show_free_areas(void)
 			K(zone_page_state(zone, NR_BOUNCE)),
 			K(zone_page_state(zone, NR_WRITEBACK_TEMP)),
 			zone->pages_scanned,
-			(zone_is_all_unreclaimable(zone) ? "yes" : "no")
+			(zone->all_unreclaimable ? "yes" : "no")
 			);
 		printk("lowmem_reserve[]:");
 		for (i = 0; i < MAX_NR_ZONES; i++)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 885207a..8057d36 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1694,8 +1694,7 @@ static void shrink_zones(int priority, struct zonelist *zonelist,
 				continue;
 			note_zone_scanning_priority(zone, priority);
 
-			if (zone_is_all_unreclaimable(zone) &&
-						priority != DEF_PRIORITY)
+			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;	/* Let kswapd poll it */
 			sc->all_unreclaimable = 0;
 		} else {
@@ -2009,8 +2008,7 @@ loop_again:
 			if (!populated_zone(zone))
 				continue;
 
-			if (zone_is_all_unreclaimable(zone) &&
-			    priority != DEF_PRIORITY)
+			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;
 
 			/*
@@ -2053,8 +2051,7 @@ loop_again:
 			if (!populated_zone(zone))
 				continue;
 
-			if (zone_is_all_unreclaimable(zone) &&
-					priority != DEF_PRIORITY)
+			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;
 
 			if (!zone_watermark_ok(zone, order,
@@ -2084,12 +2081,11 @@ loop_again:
 						lru_pages);
 			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
-			if (zone_is_all_unreclaimable(zone))
+			if (zone->all_unreclaimable)
 				continue;
-			if (nr_slab == 0 && zone->pages_scanned >=
-					(zone_reclaimable_pages(zone) * 6))
-					zone_set_flag(zone,
-						      ZONE_ALL_UNRECLAIMABLE);
+			if (nr_slab == 0 &&
+			    zone->pages_scanned >= (zone_reclaimable_pages(zone) * 6))
+				zone->all_unreclaimable = 1;
 			/*
 			 * If we've done a decent amount of scanning and
 			 * the reclaim ratio is low, start doing writepage
@@ -2612,7 +2608,7 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	    zone_page_state(zone, NR_SLAB_RECLAIMABLE) <= zone->min_slab_pages)
 		return ZONE_RECLAIM_FULL;
 
-	if (zone_is_all_unreclaimable(zone))
+	if (zone->all_unreclaimable)
 		return ZONE_RECLAIM_FULL;
 
 	/*
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 6051fba..8175c64 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -761,7 +761,7 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 		   "\n  prev_priority:     %i"
 		   "\n  start_pfn:         %lu"
 		   "\n  inactive_ratio:    %u",
-			   zone_is_all_unreclaimable(zone),
+		   zone->all_unreclaimable,
 		   zone->prev_priority,
 		   zone->zone_start_pfn,
 		   zone->inactive_ratio);
-- 
1.6.5.2







