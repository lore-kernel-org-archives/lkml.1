Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbYBTMxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbYBTMxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 07:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYBTMx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 07:53:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33391 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYBTMx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 07:53:26 -0500
Subject: Re: Problem with /proc/sys/vm/lowmem_reserve_ratio
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Larry Woodman <lwoodman@redhat.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <20080219155535.bf317d19.akpm@linux-foundation.org>
References: <47BB4BB5.20709@redhat.com>
	 <20080219155535.bf317d19.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 13:53:14 +0100
Message-Id: <1203511994.6243.44.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-19 at 15:55 -0800, Andrew Morton wrote:
> On Tue, 19 Feb 2008 16:35:49 -0500 Larry Woodman <lwoodman@redhat.com> wrote:
> 
> > balance_pgdat() calls zone_watermark_ok() three times, the first call
> > passes a zero(0) in as the 4th argument.  This 4th argument is the
> > classzone_idx which is used as the index into the zone->lowmem_reserve[] 
> > array. 
> > Since setup_per_zone_lowmem_reserve()
> > always sets the zone->lowmem_reserve[0] = 0(because there is nothing
> > below the DMA zone), zone_watermark_ok() will not consider the
> > lowmem_reserve pages when zero is passed as the 4th arg.   The
> > 4th argument must be "i" or balance_pgdat wont even get into the main loop
> > when lowmem_reserve_ratio is lowered.
> > 
> > -------------------------------------------------------------------------
> > --- linux-2.6.24.noarch/mm/vmscan.c.orig        2008-02-13
> > 11:14:55.000000000 -0500
> > +++ linux-2.6.24.noarch/mm/vmscan.c     2008-02-13 11:15:02.000000000
> > -0500
> > @@ -1375,7 +1375,7 @@ loop_again:
> >                                continue;
> > 
> >                        if (!zone_watermark_ok(zone, order, 
> > zone->pages_high,
> > 
> > -                                              0, 0)) {
> > +                                              i, 0)) {
> >                                end_zone = i;
> >                                break;
> 
> Yes, thanks, this is in my things-to-worry-about-when-i-get-home bucket. 
> We should find the changeset which added this and work out if for some
> reason it was intentional.


commit e0e1723229b6f96922d10bb932f94d899132b462
Author: nickpiggin <nickpiggin>
Date:   Tue Jan 4 04:14:42 2005 +0000

    [PATCH] mm: teach kswapd about higher order areas
    
    Teach kswapd to free memory on behalf of higher order allocators.  This
    could be important for higher order atomic allocations because they
    otherwise have no means to free the memory themselves.
    
    Signed-off-by: Nick Piggin <nickpiggin@yahoo.com.au>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>
    
    BKrev: 41da1832E5flzqtNXq5m70WxihpcMw

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 2fd19fa..e048bbc 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -264,8 +264,9 @@ typedef struct pglist_data {
 					     range, including holes */
 	int node_id;
 	struct pglist_data *pgdat_next;
-	wait_queue_head_t       kswapd_wait;
+	wait_queue_head_t kswapd_wait;
 	struct task_struct *kswapd;
+	int kswapd_max_order;
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
@@ -279,7 +280,7 @@ void __get_zone_counts(unsigned long *active, unsigned long *inactive,
 void get_zone_counts(unsigned long *active, unsigned long *inactive,
 			unsigned long *free);
 void build_all_zonelists(void);
-void wakeup_kswapd(struct zone *zone);
+void wakeup_kswapd(struct zone *zone, int order);
 int zone_watermark_ok(struct zone *z, int order, unsigned long mark,
 		int alloc_type, int can_try_harder, int gfp_high);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bb11a6d..1f264ba 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -677,7 +677,7 @@ __alloc_pages(unsigned int gfp_mask, unsigned int order,
 	}
 
 	for (i = 0; (z = zones[i]) != NULL; i++)
-		wakeup_kswapd(z);
+		wakeup_kswapd(z, order);
 
 	/*
 	 * Go through the zonelist again. Let __GFP_HIGH and allocations
@@ -1516,6 +1516,7 @@ static void __init free_area_init_core(struct pglist_data *pgdat,
 
 	pgdat->nr_zones = 0;
 	init_waitqueue_head(&pgdat->kswapd_wait);
+	pgdat->kswapd_max_order = 0;
 	
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index aa074e5..1062a30 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -968,7 +968,7 @@ out:
  * the page allocator fallback scheme to ensure that aging of pages is balanced
  * across the zones.
  */
-static int balance_pgdat(pg_data_t *pgdat, int nr_pages)
+static int balance_pgdat(pg_data_t *pgdat, int nr_pages, int order)
 {
 	int to_free = nr_pages;
 	int all_zones_ok;
@@ -1014,7 +1014,8 @@ loop_again:
 						priority != DEF_PRIORITY)
 					continue;
 
-				if (zone->free_pages <= zone->pages_high) {
+				if (!zone_watermark_ok(zone, order,
+						zone->pages_high, 0, 0, 0)) {
 					end_zone = i;
 					goto scan;
 				}
@@ -1049,7 +1050,8 @@ scan:
 				continue;
 
 			if (nr_pages == 0) {	/* Not software suspend */
-				if (zone->free_pages <= zone->pages_high)
+				if (!zone_watermark_ok(zone, order,
+						zone->pages_high, end_zone, 0, 0))
 					all_zones_ok = 0;
 			}
 			zone->temp_priority = priority;
@@ -1127,6 +1129,7 @@ out:
  */
 static int kswapd(void *p)
 {
+	unsigned long order;
 	pg_data_t *pgdat = (pg_data_t*)p;
 	struct task_struct *tsk = current;
 	DEFINE_WAIT(wait);
@@ -1155,14 +1158,28 @@ static int kswapd(void *p)
 	 */
 	tsk->flags |= PF_MEMALLOC|PF_KSWAPD;
 
+	order = 0;
 	for ( ; ; ) {
+		unsigned long new_order;
 		if (current->flags & PF_FREEZE)
 			refrigerator(PF_FREEZE);
+
 		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
-		schedule();
+		new_order = pgdat->kswapd_max_order;
+		pgdat->kswapd_max_order = 0;
+		if (order < new_order) {
+			/*
+			 * Don't sleep if someone wants a larger 'order'
+			 * allocation
+			 */
+			order = new_order;
+		} else {
+			schedule();
+			order = pgdat->kswapd_max_order;
+		}
 		finish_wait(&pgdat->kswapd_wait, &wait);
 
-		balance_pgdat(pgdat, 0);
+		balance_pgdat(pgdat, 0, order);
 	}
 	return 0;
 }
@@ -1170,12 +1187,18 @@ static int kswapd(void *p)
 /*
  * A zone is low on free memory, so wake its kswapd task to service it.
  */
-void wakeup_kswapd(struct zone *zone)
+void wakeup_kswapd(struct zone *zone, int order)
 {
+	pg_data_t *pgdat;
+
 	if (zone->present_pages == 0)
 		return;
-	if (zone->free_pages > zone->pages_low)
+
+	pgdat = zone->zone_pgdat;
+	if (zone_watermark_ok(zone, order, zone->pages_low, 0, 0, 0))
 		return;
+	if (pgdat->kswapd_max_order < order)
+		pgdat->kswapd_max_order = order;
 	if (!waitqueue_active(&zone->zone_pgdat->kswapd_wait))
 		return;
 	wake_up_interruptible(&zone->zone_pgdat->kswapd_wait);
@@ -1198,7 +1221,7 @@ int shrink_all_memory(int nr_pages)
 	current->reclaim_state = &reclaim_state;
 	for_each_pgdat(pgdat) {
 		int freed;
-		freed = balance_pgdat(pgdat, nr_to_free);
+		freed = balance_pgdat(pgdat, nr_to_free, 0);
 		ret += freed;
 		nr_to_free -= freed;
 		if (nr_to_free <= 0)


