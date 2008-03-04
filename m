Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbYCDXF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbYCDXF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933916AbYCDXCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:02:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933978AbYCDXCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:02:32 -0500
Message-Id: <20080304225227.395329993@redhat.com>
References: <20080304225157.573336066@redhat.com>
User-Agent: quilt/0.46-1
Date: Tue, 04 Mar 2008 17:52:07 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [patch 10/20] more aggressively use lumpy reclaim
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

Index: linux-2.6.25-rc3-mm1/mm/vmscan.c
===================================================================
--- linux-2.6.25-rc3-mm1.orig/mm/vmscan.c	2008-03-04 15:46:01.000000000 -0500
+++ linux-2.6.25-rc3-mm1/mm/vmscan.c	2008-03-04 15:46:47.000000000 -0500
@@ -874,7 +874,8 @@ int isolate_lru_page(struct page *page)
  * of reclaimed pages
  */
 static unsigned long shrink_inactive_list(unsigned long max_scan,
-			struct zone *zone, struct scan_control *sc, int file)
+			struct zone *zone, struct scan_control *sc,
+			int priority, int file)
 {
 	LIST_HEAD(page_list);
 	struct pagevec pvec;
@@ -892,8 +893,19 @@ static unsigned long shrink_inactive_lis
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

