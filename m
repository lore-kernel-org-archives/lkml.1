Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYK3LBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYK3LBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 06:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbYK3LBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 06:01:04 -0500
Received: from fgwmail2.fujitsu.co.jp ([164.71.1.135]:43425 "EHLO
	fgwmail2.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYK3LBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 06:01:03 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: [PATCH 06/09] make get_scan_ratio() to memcg awareness
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081130193502.8145.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081130193502.8145.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081130195953.8157.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sun, 30 Nov 2008 20:00:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make mem_cgroup_zone_nr_pages() memcgroup aware and get_scan_ratio() too.
this patch doesn't have any functional change.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    7 +++++++
 mm/memcontrol.c            |   11 +++++++++++
 mm/vmscan.c                |   19 +++++++++++++------
 3 files changed, 31 insertions(+), 6 deletions(-)

Index: b/include/linux/memcontrol.h
===================================================================
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -96,6 +96,9 @@ struct zone_reclaim_stat *mem_cgroup_get
 						      struct zone *zone);
 struct zone_reclaim_stat*
 mem_cgroup_get_reclaim_stat_by_page(struct page *page);
+unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
+				       struct zone *zone,
+				       enum lru_list lru);
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
@@ -266,6 +269,10 @@ mem_cgroup_get_reclaim_stat_by_page(stru
 	return NULL;
 }
 
+static inline unsigned long
+mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg, struct zone *zone,
+			 enum lru_list lru);
+
 
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
Index: b/mm/memcontrol.c
===================================================================
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -465,6 +465,17 @@ struct zone_reclaim_stat *mem_cgroup_get
 	return &mz->reclaim_stat;
 }
 
+unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
+				       struct zone *zone,
+				       enum lru_list lru)
+{
+	int nid = zone->zone_pgdat->node_id;
+	int zid = zone_idx(zone);
+	struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(memcg, nid, zid);
+
+	return MEM_CGROUP_ZSTAT(mz, lru);
+}
+
 
 unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -143,6 +143,9 @@ static struct zone_reclaim_stat *get_rec
 static unsigned long zone_nr_pages(struct zone *zone, struct scan_control *sc,
 				   enum lru_list lru)
 {
+	if (!scan_global_lru(sc))
+		return mem_cgroup_zone_nr_pages(sc->mem_cgroup, zone, lru);
+
 	return zone_page_state(zone, NR_LRU_BASE + lru);
 }
 
@@ -1446,13 +1449,16 @@ static void get_scan_ratio(struct zone *
 		zone_nr_pages(zone, sc, LRU_INACTIVE_ANON);
 	file  = zone_nr_pages(zone, sc, LRU_ACTIVE_FILE) +
 		zone_nr_pages(zone, sc, LRU_INACTIVE_FILE);
-	free  = zone_page_state(zone, NR_FREE_PAGES);
 
-	/* If we have very few page cache pages, force-scan anon pages. */
-	if (unlikely(file + free <= zone->pages_high)) {
-		percent[0] = 100;
-		percent[1] = 0;
-		return;
+	if (scan_global_lru(sc)) {
+		free  = zone_page_state(zone, NR_FREE_PAGES);
+		/* If we have very few page cache pages,
+		   force-scan anon pages. */
+		if (unlikely(file + free <= zone->pages_high)) {
+			percent[0] = 100;
+			percent[1] = 0;
+			return;
+		}
 	}
 
 	/*
@@ -1527,6 +1533,7 @@ static void shrink_zone(int priority, st
 				scan >>= priority;
 				scan = (scan * percent[file]) / 100;
 			}
+
 			zone->lru[l].nr_scan += scan;
 			nr[l] = zone->lru[l].nr_scan;
 			if (nr[l] >= sc->swap_cluster_max)


