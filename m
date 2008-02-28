Return-Path: <linux-kernel-owner+w=401wt.eu-S1762681AbYB1Tsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762681AbYB1Tsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763319AbYB1TmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:42:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763304AbYB1TmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:42:03 -0500
Message-Id: <20080228192928.954667833@redhat.com>
References: <20080228192908.126720629@redhat.com>
User-Agent: quilt/0.46-1
Date: Thu, 28 Feb 2008 14:29:19 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org
Subject: [patch 11/21] (NEW) more aggressively use lumpy reclaim
Content-Disposition: inline; filename=lumpy-reclaim-lower-order.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During an AIM7 run on a 16GB system, fork started failing around
32000 threads, despite the system having plenty of free swap and
15GB of pageable memory.

If normal pageout does not result in contiguous free pages for
kernel stacks, fall back to lumpy reclaim instead of failing fork
or doing excessive pageout IO.

I do not know whether this change is needed due to the extreme
stress test or because the inactive list is a smaller fraction
of system memory on huge systems.

Signed-off-by: Rik van Riel <riel@redhat.com>

Index: linux-2.6.25-rc2-mm1/mm/vmscan.c
===================================================================
--- linux-2.6.25-rc2-mm1.orig/mm/vmscan.c	2008-02-28 00:29:46.000000000 -0500
+++ linux-2.6.25-rc2-mm1/mm/vmscan.c	2008-02-28 00:29:55.000000000 -0500
@@ -870,7 +870,8 @@ int isolate_lru_page(struct page *page)
  * of reclaimed pages
  */
 static unsigned long shrink_inactive_list(unsigned long max_scan,
-			struct zone *zone, struct scan_control *sc, int file)
+			struct zone *zone, struct scan_control *sc,
+			int priority, int file)
 {
 	LIST_HEAD(page_list);
 	struct pagevec pvec;
@@ -888,8 +889,19 @@ static unsigned long shrink_inactive_lis
 		unsigned long nr_freed;
 		unsigned long nr_active;
 		unsigned int count[NR_LRU_LISTS] = { 0, };
-		int mode = (sc->order > PAGE_ALLOC_COSTLY_ORDER) ?
-					ISOLATE_BOTH : ISOLATE_INACTIVE;
+		int mode = ISOLATE_INACTIVE;
+
+		/*
+		 * If we need a large contiguous chunk of memory, or have
+		 * trouble getting a small set of contiguous pages, we
+		 * will reclaim both active and inactive pages.
+		 *
+		 * We use the same threshold as pageout congestion_wait below.
+		 */
+		if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
+			mode = ISOLATE_BOTH;
+		else if (sc->order && priority < DEF_PRIORITY - 2)
+			mode = ISOLATE_BOTH;
 
 		nr_taken = sc->isolate_pages(sc->swap_cluster_max,
 			     &page_list, &nr_scan, sc->order, mode,
@@ -1178,7 +1190,7 @@ static unsigned long shrink_list(enum lr
 		shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}
-	return shrink_inactive_list(nr_to_scan, zone, sc, file);
+	return shrink_inactive_list(nr_to_scan, zone, sc, priority, file);
 }
 
 /*

-- 
All Rights Reversed

