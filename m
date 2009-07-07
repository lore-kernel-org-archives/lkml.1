Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZGGJrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZGGJrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 05:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZGGJrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 05:47:15 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36422 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbZGGJrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 05:47:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 1/2] vmscan don't isolate too many pages
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <20090707182947.0C6D.A69D9226@jp.fujitsu.com>
References: <20090707182947.0C6D.A69D9226@jp.fujitsu.com>
Message-Id: <20090707184034.0C70.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  7 Jul 2009 18:47:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] vmscan don't isolate too many pages

If the system have plenty threads or processes, concurrent reclaim can
isolate very much pages.

And if other processes isolate _all_ pages on lru, the reclaimer can't find
any reclaimable page and it makes accidental OOM.

The solusion is, we should restrict maximum number of isolated pages.
(this patch use inactive_page/2)


FAQ
-------
Q: Why do you compared zone accumulate pages, not individual zone pages?
A: If we check individual zone, #-of-reclaimer is restricted by smallest zone.
   it mean decreasing the performance of the system having small dma zone.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/page_alloc.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1721,6 +1721,28 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	return alloc_flags;
 }
 
+static bool too_many_isolated(struct zonelist *zonelist,
+			      enum zone_type high_zoneidx, nodemask_t *nodemask)
+{
+	unsigned long nr_inactive = 0;
+	unsigned long nr_isolated = 0;
+	struct zoneref *z;
+	struct zone *zone;
+
+	for_each_zone_zonelist_nodemask(zone, z, zonelist,
+					high_zoneidx, nodemask) {
+		if (!populated_zone(zone))
+			continue;
+
+		nr_inactive += zone_page_state(zone, NR_INACTIVE_ANON);
+		nr_inactive += zone_page_state(zone, NR_INACTIVE_FILE);
+		nr_isolated += zone_page_state(zone, NR_ISOLATED_ANON);
+		nr_isolated += zone_page_state(zone, NR_ISOLATED_FILE);
+	}
+
+	return nr_isolated > nr_inactive;
+}
+
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
@@ -1789,6 +1811,11 @@ rebalance:
 	if (p->flags & PF_MEMALLOC)
 		goto nopage;
 
+	if (too_many_isolated(gfp_mask, zonelist, high_zoneidx, nodemask)) {
+		schedule_timeout_uninterruptible(HZ/10);
+		goto restart;
+	}
+
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,


