Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbYFKSst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbYFKSst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbYFKSrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:47:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757882AbYFKSrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:47:16 -0400
Message-Id: <20080611184339.423712202@redhat.com>
References: <20080611184214.605110868@redhat.com>
User-Agent: quilt/0.46-1
Date: Wed, 11 Jun 2008 14:42:24 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH -mm 10/24] more aggressively use lumpy reclaim
Content-Disposition: inline; filename=vmscan-more-aggressively-use-lumpy-reclaim.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

During an AIM7 run on a 16GB system, fork started failing around
32000 threads, despite the system having plenty of free swap and
15GB of pageable memory.  This was on x86-64, so 8k stacks.

If a higher order allocation fails, we can either:
- keep evicting pages off the end of the LRUs and hope that
  we eventually create a contiguous region; this is somewhat
  unlikely if the system is under enough stress by new
  allocations
- after trying normal eviction for a bit, use lumpy reclaim

This patch switches the system to lumpy reclaim if the VM
is having trouble freeing enough pages, using the same
threshold for detection as used by pageout congestion wait.

Signed-off-by: Rik van Riel <riel@redhat.com>

---
 mm/vmscan.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

Index: linux-2.6.26-rc5-mm2/mm/vmscan.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/vmscan.c	2008-06-10 13:40:19.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/vmscan.c	2008-06-10 13:41:25.000000000 -0400
@@ -875,7 +875,8 @@ int isolate_lru_page(struct page *page)
  * of reclaimed pages
  */
 static unsigned long shrink_inactive_list(unsigned long max_scan,
-			struct zone *zone, struct scan_control *sc, int file)
+			struct zone *zone, struct scan_control *sc,
+			int priority, int file)
 {
 	LIST_HEAD(page_list);
 	struct pagevec pvec;
@@ -893,8 +894,19 @@ static unsigned long shrink_inactive_lis
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
@@ -1175,7 +1187,7 @@ static unsigned long shrink_list(enum lr
 		shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}
-	return shrink_inactive_list(nr_to_scan, zone, sc, file);
+	return shrink_inactive_list(nr_to_scan, zone, sc, priority, file);
 }
 
 /*

-- 
All Rights Reversed

