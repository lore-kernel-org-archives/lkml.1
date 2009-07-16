Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbZGPDho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbZGPDho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 23:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbZGPDhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 23:37:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56771 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757328AbZGPDhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 23:37:42 -0400
Date: Wed, 15 Jul 2009 23:36:59 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH -mm] throttle direct reclaim when too many pages are
 isolated already (v2)
Message-ID: <20090715233659.50fe1c4c@bree.surriel.com>
In-Reply-To: <20090715194820.237a4d77.akpm@linux-foundation.org>
References: <20090715223854.7548740a@bree.surriel.com>
	<20090715194820.237a4d77.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When way too many processes go into direct reclaim, it is possible
for all of the pages to be taken off the LRU.  One result of this
is that the next process in the page reclaim code thinks there are
no reclaimable pages left and triggers an out of memory kill.

One solution to this problem is to never let so many processes into
the page reclaim path that the entire LRU is emptied.  Limiting the
system to only having half of each inactive list isolated for
reclaim should be safe.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
v2: fix the bugs pointed out by Andrew Morton

This patch goes on top of Kosaki's "Account the number of isolated pages"
patch series.

 mm/vmscan.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

Index: mmotm/mm/vmscan.c
===================================================================
--- mmotm.orig/mm/vmscan.c	2009-07-15 22:32:35.000000000 -0400
+++ mmotm/mm/vmscan.c	2009-07-15 23:26:37.000000000 -0400
@@ -1035,6 +1035,27 @@ int isolate_lru_page(struct page *page)
 }
 
 /*
+ * Are there way too many processes in the direct reclaim path already?
+ */
+static int too_many_isolated(struct zone *zone, int file)
+{
+	unsigned long inactive, isolated;
+
+	if (current_is_kswapd())
+		return 0;
+
+	if (file) {
+		inactive = zone_page_state(zone, NR_INACTIVE_FILE);
+		isolated = zone_page_state(zone, NR_ISOLATED_FILE);
+	} else {
+		inactive = zone_page_state(zone, NR_INACTIVE_ANON);
+		isolated = zone_page_state(zone, NR_ISOLATED_ANON);
+	}
+
+	return isolated > inactive;
+}
+
+/*
  * shrink_inactive_list() is a helper for shrink_zone().  It returns the number
  * of reclaimed pages
  */
@@ -1049,6 +1070,14 @@ static unsigned long shrink_inactive_lis
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 	int lumpy_reclaim = 0;
 
+	while (unlikely(too_many_isolated(zone, file))) {
+		/* We are about to die and free our memory. Return now. */
+		if (fatal_signal_pending(current))
+			return SWAP_CLUSTER_MAX;
+
+		congestion_wait(WRITE, HZ/10);
+	}
+
 	/*
 	 * If we need a large contiguous chunk of memory, or have
 	 * trouble getting a small set of contiguous pages, we
