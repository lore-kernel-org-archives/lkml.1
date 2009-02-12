Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbZBLLwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbZBLLwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 06:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758612AbZBLLv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 06:51:57 -0500
Received: from cmpxchg.org ([85.214.51.133]:37987 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758586AbZBLLv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 06:51:56 -0500
Message-Id: <20090212114416.197688682@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Thu, 12 Feb 2009 12:36:11 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       MinChan Kim <minchan.kim@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <ncunningham-lkml@crca.org.au>,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [patch 2/2] vmscan: clip swap_cluster_max in shrink_all_memory()
References: <20090212113609.351980834@cmpxchg.org>
Content-Disposition: inline; filename=vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shrink_inactive_list() scans in sc->swap_cluster_max chunks until it
hits the scan limit it was passed.

shrink_inactive_list()
{
	do {
		isolate_pages(swap_cluster_max)
		shrink_page_list()
	} while (nr_scanned < max_scan);
}

This assumes that swap_cluster_max is not bigger than the scan limit
because the latter is checked only after at least one iteration.

In shrink_all_memory() sc->swap_cluster_max is initialized to the
overall reclaim goal in the beginning but not decreased while reclaim
is making progress which leads to subsequent calls to
shrink_inactive_list() reclaiming way too much in the one iteration
that is done unconditionally.

Set sc->swap_cluster_max always to the proper goal before doing
  shrink_all_zones()
    shrink_list()
      shrink_inactive_list().

While the current shrink_all_memory() happily reclaims more than
actually requested, this patch fixes it to never exceed the goal:

unpatched
   wanted=10000 reclaimed=13356
   wanted=10000 reclaimed=19711
   wanted=10000 reclaimed=10289
   wanted=10000 reclaimed=17306
   wanted=10000 reclaimed=10700
   wanted=10000 reclaimed=10004
   wanted=10000 reclaimed=13301
   wanted=10000 reclaimed=10976
   wanted=10000 reclaimed=10605
   wanted=10000 reclaimed=10088
   wanted=10000 reclaimed=15000

patched
   wanted=10000 reclaimed=10000
   wanted=10000 reclaimed=9599
   wanted=10000 reclaimed=8476
   wanted=10000 reclaimed=8326
   wanted=10000 reclaimed=10000
   wanted=10000 reclaimed=10000
   wanted=10000 reclaimed=9919
   wanted=10000 reclaimed=10000
   wanted=10000 reclaimed=10000
   wanted=10000 reclaimed=10000
   wanted=10000 reclaimed=10000
   wanted=10000 reclaimed=9624
   wanted=10000 reclaimed=10000
   wanted=10000 reclaimed=10000
   wanted=8500 reclaimed=8092
   wanted=316 reclaimed=316

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: MinChan Kim <minchan.kim@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <ncunningham-lkml@crca.org.au>
Cc: Rik van Riel <riel@redhat.com>
---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2105,7 +2105,6 @@ unsigned long shrink_all_memory(unsigned
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
 		.may_unmap = 0,
-		.swap_cluster_max = nr_pages,
 		.may_writepage = 1,
 		.isolate_pages = isolate_pages_global,
 	};
@@ -2147,6 +2146,7 @@ unsigned long shrink_all_memory(unsigned
 			unsigned long nr_to_scan = nr_pages - sc.nr_reclaimed;
 
 			sc.nr_scanned = 0;
+			sc.swap_cluster_max = nr_to_scan;
 			shrink_all_zones(nr_to_scan, prio, pass, &sc);
 			if (sc.nr_reclaimed >= nr_pages)
 				goto out;


