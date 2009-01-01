Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbZAAOwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbZAAOwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 09:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009AbZAAOwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 09:52:35 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56344 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbZAAOwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 09:52:34 -0500
Date: Thu, 1 Jan 2009 23:52:02 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH] mm: stop kswapd's infinite loop at high order allocation take2
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, wassim dagash <wassim.dagash@gmail.com>
In-Reply-To: <20081231215934.1296.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081231115332.GB20534@csn.ul.ie> <20081231215934.1296.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20090101021240.A057.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >                 /*
> >                  * Fragmentation may mean that the system cannot be
> >                  * rebalanced for high-order allocations in all zones.
> >                  * At this point, if nr_reclaimed < SWAP_CLUSTER_MAX,
> >                  * it means the zones have been fully scanned and are still
> >                  * not balanced. For high-order allocations, there is 
> >                  * little point trying all over again as kswapd may
> >                  * infinite loop.
> >                  *
> >                  * Instead, recheck all watermarks at order-0 as they
> >                  * are the most important. If watermarks are ok, kswapd will go
> >                  * back to sleep. High-order users can still direct reclaim
> >                  * if they wish.
> >                  */
> > 
> > ?
> 
> Excellent. I strongly like this and I hope merge it to my patch.
> I'll resend new patch.

Done.



==
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] mm: kswapd stop infinite loop at high order allocation

Wassim Dagash reported following kswapd infinite loop problem.

  kswapd runs in some infinite loop trying to swap until order 10 of zone
  highmem is OK.... kswapd will continue to try to balance order 10 of zone
  highmem forever (or until someone release a very large chunk of highmem).

For non order-0 allocations, the system may never be balanced due to
fragmentation but kswapd should not infinitely loop as a result. 

Instead, recheck all watermarks at order-0 as they are the most important. 
If watermarks are ok, kswapd will go back to sleep. 


Reported-by: wassim dagash <wassim.dagash@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>,
---
 mm/vmscan.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c	2008-12-25 08:26:37.000000000 +0900
+++ b/mm/vmscan.c	2009-01-01 01:56:02.000000000 +0900
@@ -1872,6 +1872,23 @@ out:
 
 		try_to_freeze();
 
+		/*
+		 * Fragmentation may mean that the system cannot be
+		 * rebalanced for high-order allocations in all zones.
+		 * At this point, if nr_reclaimed < SWAP_CLUSTER_MAX,
+		 * it means the zones have been fully scanned and are still
+		 * not balanced. For high-order allocations, there is
+		 * little point trying all over again as kswapd may
+		 * infinite loop.
+		 *
+		 * Instead, recheck all watermarks at order-0 as they
+		 * are the most important. If watermarks are ok, kswapd will go
+		 * back to sleep. High-order users can still direct reclaim
+		 * if they wish.
+		 */
+		if (nr_reclaimed < SWAP_CLUSTER_MAX)
+			order = sc.order = 0;
+
 		goto loop_again;
 	}
 



