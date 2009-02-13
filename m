Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbZBMARG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbZBMARG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 19:17:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757876AbZBMAQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 19:16:52 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:52293 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbZBMAQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 19:16:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=mwNbfbWJWZu5SSmV+KG0CA0X1pAb1w9nUt4pqmlch1i0tNg7Qf6oIrtXvyfu8khvnl
         kdttx/Zozj2wx5r6A932M3qrm6X/1TJpJ/EVxRDN9rNTlqfTBDpYhN7ABw8crJz3w9Pl
         UBFS8YNDYhhZcgn9s/Ami61OC7KQBza2zSc6g=
Date: Fri, 13 Feb 2009 09:16:15 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       MinChan Kim <minchan.kim@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <ncunningham-lkml@crca.org.au>,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [patch 2/2 v2] vmscan: clip swap_cluster_max in shrink_all_memory()
Message-Id: <20090213091615.28e6a689.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I just remaked this patch based on my first patch '[patch 1/2] shrink_all_memory(): use sc.nr_reclaimed' due to hunk.
Notice that original patch is written by Hannes. 
I just inserted reviewed-by of me and acked-by of Nigel and Rafael.

---
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, MinChan Kim <minchan.kim@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Nigel Cunningham <ncunningham-lkml@crca.org.au>, Rik van Riel <riel@redhat.com>
Subject: [patch 2/2] vmscan: clip swap_cluster_max in shrink_all_memory()
Date: Thu, 12 Feb 2009 12:36:11 +0100
User-Agent: quilt/0.47-1
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
Reviewed-by: MinChan Kim <minchan.kim@gmail.com>
Acked-by: Nigel Cunningham <ncunningham@crca.org.au>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>


---
 mm/vmscan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 172e394..ed329c4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2114,7 +2114,6 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
 		.may_unmap = 0,
-		.swap_cluster_max = nr_pages,
 		.may_writepage = 1,
 		.isolate_pages = isolate_pages_global,
 	};
@@ -2156,6 +2155,7 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
 			unsigned long nr_to_scan = nr_pages - sc.nr_reclaimed;
 
 			sc.nr_scanned = 0;
+			sc.swap_cluster_max = nr_to_scan;
 			shrink_all_zones(nr_to_scan, prio, pass, &sc);
 			if (sc.nr_reclaimed >= nr_pages) 
 				goto out;
-- 
1.5.4.3



-- 
Kinds Regards
MinChan Kim
