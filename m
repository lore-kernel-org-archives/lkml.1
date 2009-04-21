Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbZDUFW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbZDUFW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 01:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbZDUFWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 01:22:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34147 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbZDUFWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 01:22:37 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andy Whitcroft <apw@shadowen.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [PATCH] low order lumpy reclaim also should use PAGEOUT_IO_SYNC.
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090421142056.F127.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 14:22:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] low order lumpy reclaim also should use PAGEOUT_IO_SYNC.

commit 33c120ed2843090e2bd316de1588b8bf8b96cbde (more aggressively use lumpy reclaim)
change lumpy reclaim using condition. but it isn't enough change.

lumpy reclaim don't only mean isolate neighber page, but also do pageout as synchronous.
this patch does it.

Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1049,6 +1049,19 @@ static unsigned long shrink_inactive_lis
 	unsigned long nr_scanned = 0;
 	unsigned long nr_reclaimed = 0;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
+	int lumpy_reclaim = 0;
+
+	/*
+	 * If we need a large contiguous chunk of memory, or have
+	 * trouble getting a small set of contiguous pages, we
+	 * will reclaim both active and inactive pages.
+	 *
+	 * We use the same threshold as pageout congestion_wait below.
+	 */
+	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
+		lumpy_reclaim = 1;
+	else if (sc->order && priority < DEF_PRIORITY - 2)
+		lumpy_reclaim = 1;
 
 	pagevec_init(&pvec, 1);
 
@@ -1061,19 +1074,7 @@ static unsigned long shrink_inactive_lis
 		unsigned long nr_freed;
 		unsigned long nr_active;
 		unsigned int count[NR_LRU_LISTS] = { 0, };
-		int mode = ISOLATE_INACTIVE;
-
-		/*
-		 * If we need a large contiguous chunk of memory, or have
-		 * trouble getting a small set of contiguous pages, we
-		 * will reclaim both active and inactive pages.
-		 *
-		 * We use the same threshold as pageout congestion_wait below.
-		 */
-		if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
-			mode = ISOLATE_BOTH;
-		else if (sc->order && priority < DEF_PRIORITY - 2)
-			mode = ISOLATE_BOTH;
+		int mode = lumpy_reclaim ? ISOLATE_BOTH : ISOLATE_INACTIVE;
 
 		nr_taken = sc->isolate_pages(sc->swap_cluster_max,
 			     &page_list, &nr_scan, sc->order, mode,
@@ -1110,7 +1111,7 @@ static unsigned long shrink_inactive_lis
 		 * but that should be acceptable to the caller
 		 */
 		if (nr_freed < nr_taken && !current_is_kswapd() &&
-					sc->order > PAGE_ALLOC_COSTLY_ORDER) {
+		    lumpy_reclaim) {
 			congestion_wait(WRITE, HZ/10);
 
 			/*


