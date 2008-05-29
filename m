Return-Path: <linux-kernel-owner+w=401wt.eu-S1758989AbYE2UZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989AbYE2UZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 16:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbYE2UZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 16:25:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbYE2UZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 16:25:03 -0400
Message-Id: <20080529202312.740944082@redhat.com>
References: <20080529202246.322317334@redhat.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 16:22:57 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH -mm 11/12] more aggressively use lumpy reclaim
Content-Disposition: inline; filename=lumpy-reclaim-lower-order.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

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

---
 mm/vmscan.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

Index: linux-2.6.26-rc2-mm1/mm/vmscan.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/mm/vmscan.c	2008-05-28 12:14:34.000000000 -0400
+++ linux-2.6.26-rc2-mm1/mm/vmscan.c	2008-05-28 12:14:43.000000000 -0400
@@ -857,7 +857,8 @@ int isolate_lru_page(struct page *page)
  * of reclaimed pages
  */
 static unsigned long shrink_inactive_list(unsigned long max_scan,
-			struct zone *zone, struct scan_control *sc, int file)
+			struct zone *zone, struct scan_control *sc,
+			int priority, int file)
 {
 	LIST_HEAD(page_list);
 	struct pagevec pvec;
@@ -875,8 +876,19 @@ static unsigned long shrink_inactive_lis
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
@@ -1171,7 +1183,7 @@ static unsigned long shrink_list(enum lr
 		shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}
-	return shrink_inactive_list(nr_to_scan, zone, sc, file);
+	return shrink_inactive_list(nr_to_scan, zone, sc, priority, file);
 }
 
 /*

-- 
All Rights Reversed

