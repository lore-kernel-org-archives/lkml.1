Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbZCWBP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbZCWBP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 21:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756332AbZCWBPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 21:15:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55999 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbZCWBPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 21:15:17 -0400
Date: Mon, 23 Mar 2009 10:13:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>, mel@csn.ul.ie,
       riel@redhat.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix vmscan to take care of nodemask
Message-Id: <20090323101348.07b9c761.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090323100356.e980d266.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090323100356.e980d266.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kosaki pointed out it's not necessary to initialize struct member value by NULL.
Remvoed it. 

Regards,
-Kame
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

try_to_free_pages() scans zonelist but don't take care of nodemask which is
given to alloc_pages_nodemask(). This makes try_to_free_pages() less effective.

Changelog: v1 -> v2
  - removed unnecessary nodemask=NULL initialization.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: mmotm-2.6.29-Mar21/mm/vmscan.c
===================================================================
--- mmotm-2.6.29-Mar21.orig/mm/vmscan.c
+++ mmotm-2.6.29-Mar21/mm/vmscan.c
@@ -79,6 +79,9 @@ struct scan_control {
 	/* Which cgroup do we reclaim from */
 	struct mem_cgroup *mem_cgroup;
 
+	/* Nodemask */
+	nodemask_t	*nodemask;
+
 	/* Pluggable isolate pages callback */
 	unsigned long (*isolate_pages)(unsigned long nr, struct list_head *dst,
 			unsigned long *scanned, int order, int mode,
@@ -1544,7 +1547,9 @@ static void shrink_zones(int priority, s
 	struct zone *zone;
 
 	sc->all_unreclaimable = 1;
-	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
+	/* Note: sc->nodemask==NULL means scan all node */
+	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
+					sc->nodemask) {
 		if (!populated_zone(zone))
 			continue;
 		/*
@@ -1689,7 +1694,7 @@ out:
 }
 
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
-								gfp_t gfp_mask)
+				gfp_t gfp_mask, nodemask_t *nodemask)
 {
 	struct scan_control sc = {
 		.gfp_mask = gfp_mask,
@@ -1700,6 +1705,7 @@ unsigned long try_to_free_pages(struct z
 		.order = order,
 		.mem_cgroup = NULL,
 		.isolate_pages = isolate_pages_global,
+		.nodemask = nodemask,
 	};
 
 	return do_try_to_free_pages(zonelist, &sc);
Index: mmotm-2.6.29-Mar21/include/linux/swap.h
===================================================================
--- mmotm-2.6.29-Mar21.orig/include/linux/swap.h
+++ mmotm-2.6.29-Mar21/include/linux/swap.h
@@ -213,7 +213,7 @@ static inline void lru_cache_add_active_
 
 /* linux/mm/vmscan.c */
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
-					gfp_t gfp_mask);
+					gfp_t gfp_mask, nodemask_t *mask);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
 						  gfp_t gfp_mask, bool noswap,
 						  unsigned int swappiness);
Index: mmotm-2.6.29-Mar21/mm/page_alloc.c
===================================================================
--- mmotm-2.6.29-Mar21.orig/mm/page_alloc.c
+++ mmotm-2.6.29-Mar21/mm/page_alloc.c
@@ -1598,7 +1598,8 @@ nofail_alloc:
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
-	did_some_progress = try_to_free_pages(zonelist, order, gfp_mask);
+	did_some_progress = try_to_free_pages(zonelist, order,
+						gfp_mask, nodemask);
 
 	p->reclaim_state = NULL;
 	lockdep_clear_current_reclaim_state();
Index: mmotm-2.6.29-Mar21/fs/buffer.c
===================================================================
--- mmotm-2.6.29-Mar21.orig/fs/buffer.c
+++ mmotm-2.6.29-Mar21/fs/buffer.c
@@ -476,7 +476,7 @@ static void free_more_memory(void)
 						&zone);
 		if (zone)
 			try_to_free_pages(node_zonelist(nid, GFP_NOFS), 0,
-						GFP_NOFS);
+						GFP_NOFS, NULL);
 	}
 }
 

