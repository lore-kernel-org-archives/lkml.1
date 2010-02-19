Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab0BSLTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 06:19:38 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:60351 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab0BSLTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 06:19:35 -0500
Message-ID: <4B7E73BF.5030901@linux.vnet.ibm.com>
Date: Fri, 19 Feb 2010 12:19:27 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, gregkh@novell.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
 due to "e084b - page-allocator: preserve PFN ordering when	__GFP_COLD is
 set"
References: <4B70192C.3070601@linux.vnet.ibm.com> <20100208152131.GC23680@csn.ul.ie> <4B7184B5.6040400@linux.vnet.ibm.com> <20100209175707.GB5098@csn.ul.ie> <4B742C2C.5080305@linux.vnet.ibm.com> <20100212100519.GA29085@laptop> <4B796C6D.80800@linux.vnet.ibm.com> <20100216112517.GE1194@csn.ul.ie> <4B7ACC1E.9080205@linux.vnet.ibm.com> <4B7BBCFC.4090101@linux.vnet.ibm.com> <20100218114310.GC32626@csn.ul.ie> <4B7D664C.20507@linux.vnet.ibm.com>
In-Reply-To: <4B7D664C.20507@linux.vnet.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------010307050305090902090004"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010307050305090902090004
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

Christian Ehrhardt wrote:
> 
> 
> Mel Gorman wrote:
>> On Wed, Feb 17, 2010 at 10:55:08AM +0100, Christian Ehrhardt wrote:
>>> Christian Ehrhardt wrote:
>>>> Mel Gorman wrote:
>>>>> On Mon, Feb 15, 2010 at 04:46:53PM +0100, Christian Ehrhardt wrote:

[...]

>>>>
>>>> PAGES-FREED  fast path   slow path
>>>> GOOD CASE      ~62       ~1.46
>>>> BAD CASE       ~62       ~37
>>> 5f8dcc21 introduced per migrate type pcp lists, is it possible that 
>>> we  run in a scenario where try_to_free frees a lot of pages via, but 
>>> of the  wrong migrate type?
>>
>> It's possible but the window is small. When a threshold is reached on the
>> PCP lists, they get drained to the buddy lists and later picked up again
>> by __rmqueue_fallback(). I had considered the possibility of pages of the
>> wrong type being on the PCP lists which led to the patch "page-allocator:
>> Fallback to other per-cpu lists when the target list is empty and 
>> memory is
>> low" but you reported it made no difference even when fallback was 
>> allowed
>> with high watermarks.
>> [...]
> 
> Today I created rather huge debug logs - I'll spare everyone with too 
> much detail.
> Eventually it comes down to some kind of cat /proc/zoneinfo like output 
> extended to list all things per migrate type too.
> 
>  From that I still think there should be plenty of pages to get the 
> allocation through, as it was suggested by the high amount of pages 
> freed by try_to_free.
> > 
[...]

> More about that tomorrow,

Well tomorrow is now, and I think I got some important new insights.

As mentioned before I realized that a second call still fails most of the time (>99%). Therefore I added a "debugme" parameter to get_page_from_freelist and buffered_rmqueue to see where the allocations exactly fails (patch attached).

Now with debugme active in a second call after it had progress&&!page in direct_reclaim I saw the following repeating pattern in most of the cases:
   get_page_from_freelist - zone loop - current zone 'DMA'
   get_page_from_freelist - watermark check due to !(alloc_flags & ALLOC_NO_WATERMARKS)
   get_page_from_freelist - goto zone_full due to zone_reclaim_mode==0
   get_page_from_freelist - return page '(null)'

Ok - now we at least exactly know why it gets no page.
Remember there are plenty of pages like it was in my zoneinfo like report in the last mail.
I didn't expect that, but actually watermarks are what stops the allocations here.
The zone_watermark_ok check reports that there are not enough pages for the current watermark and
finally it ends with zone_reclaim_mode which is always zero on s390 as we are not CONFIG_NUMA.

Ok remember my scenario - several parallel iozone sequential read processes - theres not much allocation going on except for the page cache read ahead related to that read workload.
The allocations for page cache seem to have no special watermarks selected via their GFP flags and therefore get stalled by congestion_wait - which in consequence of no available writes in flight consumes its full timeout.

As I see significant impacts to the iozone throughput and not only e.g. bad counters in direct_reclaim the congestion_wait stalling seems to be so often/long to stall the application I/O itself.
That means from the time VFS starting a read ahead it seems to stall that page allocation long enough that the data is not ready when the application tries to read it, while it would be if the allocation would be fast enough.

A simple test for this theory was to allow those failing allocations a second chance without watermark restrictions before putting them to sleep for such a long time.

Index: linux-2.6-git/mm/page_alloc.c
===================================================================
--- linux-2.6-git.orig/mm/page_alloc.c  2010-02-19 09:53:14.000000000 +0100
+++ linux-2.6-git/mm/page_alloc.c       2010-02-19 09:56:26.000000000 +0100
@@ -1954,7 +1954,22 @@

        if (should_alloc_retry(gfp_mask, order, pages_reclaimed)) {
                /* Wait for some write requests to complete then retry */
-               congestion_wait(BLK_RW_ASYNC, HZ/50);
+               /*
+                * If it gets here try it without watermarks before going
+                * to sleep.
+                *
+                * This will end up in alloc_high_priority and if that fails
+                * once more direct_reclaim but this time without watermark
+                * checks.
+                *
+                * FIXME: that is just for verification - a real fix needs to
+                * ensure e.g. page cache allocations don't drain all pages
+                * under watermark
+                */
+               if (!(alloc_flags & ALLOC_NO_WATERMARKS))
+                       alloc_flags &= ALLOC_NO_WATERMARKS;
+               else
+                       congestion_wait(BLK_RW_ASYNC, HZ/50);
                goto rebalance;
        }


This fixes all issues I have, but as stated in the FIXME it is unfortunately no fix for the real world.

Unfortunately even now knowing the place of the issue so well I don't see the connection to the commits e084b+5f8dcc21 - I couldn't find something but did they change the accounting somewhere or e.g. changed the timing/order of watermark updates and allocations?

Eventually it might come down to a discussion of allocation priorities and we might even keep them as is and accept this issue - I still would prefer a good second chance implementation, other page cache allocation flags or something else that explicitly solves this issue.
Mel's patch that replaces congestion_wait with a wait for the zone watermarks becoming available again is definitely a step in the right direction and should go into upstream and the long term support branches.



-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 

--------------010307050305090902090004
Content-Type: text/x-patch;
 name="perf-count-page-alloc-fail-page-debugchain.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="perf-count-page-alloc-fail-page-debugchain.diff"

Index: linux-2.6-git/mm/page_alloc.c
===================================================================
--- linux-2.6-git.orig/mm/page_alloc.c	2010-02-18 15:58:20.000000000 +0100
+++ linux-2.6-git/mm/page_alloc.c	2010-02-18 16:53:19.000000000 +0100
@@ -1179,7 +1179,7 @@
 static inline
 struct page *buffered_rmqueue(struct zone *preferred_zone,
 			struct zone *zone, int order, gfp_t gfp_flags,
-			int migratetype)
+			int migratetype, int debugme)
 {
 	unsigned long flags;
 	struct page *page;
@@ -1195,14 +1195,19 @@
 		pcp = &zone_pcp(zone, cpu)->pcp;
 		list = &pcp->lists[migratetype];
 		local_irq_save(flags);
+		if (debugme) printk(KERN_INFO"%s - got list %p for migratetype %d\n", __func__, list, migratetype);
 		if (list_empty(list)) {
+			if (debugme) printk(KERN_INFO"%s - list was empty - go for rmqueue_bulk\n", __func__);
 			pcp->count += rmqueue_bulk(zone, 0,
 					pcp->batch, list,
 					migratetype, cold);
-			if (unlikely(list_empty(list)))
+			if (unlikely(list_empty(list))) {
+				if (debugme) printk(KERN_INFO"%s - list still empty after rmqueue_bulk\n", __func__);
 				goto failed;
+			}
 		}
 
+		if (debugme) printk(KERN_INFO"%s - list has pages - I'm irq save on one cpu and take one\n", __func__);
 		if (cold)
 			page = list_entry(list->prev, struct page, lru);
 		else
@@ -1238,8 +1243,10 @@
 	put_cpu();
 
 	VM_BUG_ON(bad_range(zone, page));
-	if (prep_new_page(page, order, gfp_flags))
+	if (prep_new_page(page, order, gfp_flags)) {
+		if (debugme) printk(KERN_INFO"%s - prep_new_page triggered - goto again\n", __func__);
 		goto again;
+	}
 	return page;
 
 failed:
@@ -1515,7 +1522,7 @@
 static struct page *
 get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 		struct zonelist *zonelist, int high_zoneidx, int alloc_flags,
-		struct zone *preferred_zone, int migratetype)
+		struct zone *preferred_zone, int migratetype, int debugme)
 {
 	struct zoneref *z;
 	struct page *page = NULL;
@@ -1533,45 +1540,61 @@
 	 */
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						high_zoneidx, nodemask) {
+		if (debugme) printk(KERN_INFO"%s - zone loop - current zone '%s'\n", __func__, zone->name);
 		if (NUMA_BUILD && zlc_active &&
-			!zlc_zone_worth_trying(zonelist, z, allowednodes))
+			!zlc_zone_worth_trying(zonelist, z, allowednodes)) {
+				if (debugme) printk(KERN_INFO"%s - skip due to NUMA_BUILD && zlc_active\n", __func__);
 				continue;
+		}
 		if ((alloc_flags & ALLOC_CPUSET) &&
-			!cpuset_zone_allowed_softwall(zone, gfp_mask))
+			!cpuset_zone_allowed_softwall(zone, gfp_mask)) {
+				if (debugme) printk(KERN_INFO"%s - skip due to ALLOC_CPUSET && !allowed_softwall\n", __func__);
 				goto try_next_zone;
+		}
 
 		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
 		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
 			unsigned long mark;
 			int ret;
 
+			if (debugme) printk(KERN_INFO"%s - watermark check due to !(alloc_flags & ALLOC_NO_WATERMARKS)\n", __func__);
+
 			mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
 			if (zone_watermark_ok(zone, order, mark,
-				    classzone_idx, alloc_flags))
+				    classzone_idx, alloc_flags)) {
+				if (debugme) printk(KERN_INFO"%s - goto this_zone due to zone_watermark_ok\n", __func__);
 				goto try_this_zone;
+			}
 
-			if (zone_reclaim_mode == 0)
+			if (zone_reclaim_mode == 0) {
+				if (debugme) printk(KERN_INFO"%s - goto zone_full due to zone_reclaim_mode==0\n", __func__);
 				goto this_zone_full;
+			}
 
 			ret = zone_reclaim(zone, gfp_mask, order);
 			switch (ret) {
 			case ZONE_RECLAIM_NOSCAN:
 				/* did not scan */
+				if (debugme) printk(KERN_INFO"%s - goto next_zone due to ZONE_RECLAIM_NOSCAN\n", __func__);
 				goto try_next_zone;
 			case ZONE_RECLAIM_FULL:
 				/* scanned but unreclaimable */
+				if (debugme) printk(KERN_INFO"%s - goto zone_full due to ZONE_RECLAIM_FULL\n", __func__);
 				goto this_zone_full;
 			default:
 				/* did we reclaim enough */
 				if (!zone_watermark_ok(zone, order, mark,
-						classzone_idx, alloc_flags))
+						classzone_idx, alloc_flags)) {
+					if (debugme) printk(KERN_INFO"%s - goto zone_full due to !zone_watermark_ok\n", __func__);
 					goto this_zone_full;
+				}
 			}
 		}
 
 try_this_zone:
+		if (debugme) printk(KERN_INFO"%s - reach buffered_rmqueue for zone '%s'\n", __func__, zone->name);
 		page = buffered_rmqueue(preferred_zone, zone, order,
-						gfp_mask, migratetype);
+						gfp_mask, migratetype, debugme);
 		if (page)
 			break;
 this_zone_full:
@@ -1594,6 +1617,8 @@
 		zlc_active = 0;
 		goto zonelist_scan;
 	}
+
+	if (debugme) printk(KERN_INFO"%s - return page '%p'\n", __func__, page);
 	return page;
 }
 
@@ -1655,7 +1680,7 @@
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask,
 		order, zonelist, high_zoneidx,
 		ALLOC_WMARK_HIGH|ALLOC_CPUSET,
-		preferred_zone, migratetype);
+		preferred_zone, migratetype,0);
 	if (page)
 		goto out;
 
@@ -1979,7 +2004,7 @@
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,
 					alloc_flags, preferred_zone,
-					migratetype);
+					migratetype, 0);
 	t4 = get_clock();
 
 	perf_count_pages_direct_reclaim++;
@@ -1994,11 +2019,12 @@
 		perf_count_direct_reclaim_slow_sum_progress += *did_some_progress;
 		perf_count_direct_reclaim_slow_sum_order += order;
 
-		perf_count_page_stats(nodemask, zonelist, high_zoneidx, preferred_zone, migratetype, *did_some_progress, gfp_mask, order);
+		// perf_count_page_stats(nodemask, zonelist, high_zoneidx, preferred_zone, migratetype, *did_some_progress, gfp_mask, order);
+		// We know stats look good but even second alloc fail (might be racy) - call get_page_from_freelist with debug instead
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,
 					alloc_flags, preferred_zone,
-					migratetype);
+					migratetype, 1);
 		if (!page)
 			printk(KERN_DEBUG"second get_page_from_freelist fail\n");
 		else
@@ -2032,7 +2058,7 @@
 	do {
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
 			zonelist, high_zoneidx, ALLOC_NO_WATERMARKS,
-			preferred_zone, migratetype);
+			preferred_zone, migratetype,0);
 
 		if (!page && gfp_mask & __GFP_NOFAIL) {
 			perf_count_call_congestion_wait_from_alloc_pages_high_priority++;
@@ -2142,7 +2168,7 @@
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
-			preferred_zone, migratetype);
+			preferred_zone, migratetype,0);
 	if (page)
 		goto got_pg;
 
@@ -2268,7 +2294,7 @@
 	/* First allocation attempt */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
 			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET,
-			preferred_zone, migratetype);
+			preferred_zone, migratetype,0);
 	if (unlikely(!page))
 		page = __alloc_pages_slowpath(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,

--------------010307050305090902090004--
