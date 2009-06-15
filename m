Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbZFOLOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbZFOLOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 07:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbZFOLOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 07:14:43 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45671 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbZFOLOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 07:14:43 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] vmscan: Fix use of delta in zone_pagecache_reclaimable()
Date: Mon, 15 Jun 2009 12:14:41 +0100
Message-Id: <1245064482-19245-2-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245064482-19245-1-git-send-email-mel@csn.ul.ie>
References: <1245064482-19245-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zone_pagecache_reclaimable() works out how many pages are in a state
that zone_reclaim() can reclaim based on the current zone_reclaim_mode.
As part of this, it calculates a delta to the number of unmapped pages.
The code was meant to check delta would not cause underflows and then apply
it but it got accidentally removed.

This patch properly uses delta. It's excessively paranoid at the moment
because it's impossible to underflow but the current form will make future
patches to zone_pagecache_reclaimable() fixing any other scan-heuristic
breakage easier to read and acts as self-documentation reminding authors
of future patches to consider underflow.

This is a fix to patch
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim.patch
and they should be merged together.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/vmscan.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 026f452..bd8e3ed 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2398,7 +2398,11 @@ static long zone_pagecache_reclaimable(struct zone *zone)
 	if (!(zone_reclaim_mode & RECLAIM_WRITE))
 		delta += zone_page_state(zone, NR_FILE_DIRTY);
 
-	return nr_pagecache_reclaimable;
+	/* Watch for any possible underflows due to delta */
+	if (unlikely(delta > nr_pagecache_reclaimable))
+		delta = nr_pagecache_reclaimable;
+
+	return nr_pagecache_reclaimable - delta;
 }
 
 /*
-- 
1.5.6.5

