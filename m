Return-Path: <linux-kernel-owner+w=401wt.eu-S1762304AbZDCIQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762304AbZDCIQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 04:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761937AbZDCIQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 04:16:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47582 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761842AbZDCIQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 04:16:28 -0400
Date: Fri, 3 Apr 2009 17:14:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [RFC][PATCH 6/9] active inactive ratio for private
Message-Id: <20090403171457.4a7ab4e1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090403170835.a2d6cbc3.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090403170835.a2d6cbc3.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Current memcg's active/inactive ratio calclation ignores zone.
(It's designed for reducing usage of memcg and not for recovering
 from  memory shortage.)

But softlimit should take care of zone, later.

Changelog v1->v2:
 - fixed buggy argument in mem_cgroup_inactive_anon_is_low

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |   26 ++++++++++++++++++++------
 mm/vmscan.c                |    2 +-
 3 files changed, 23 insertions(+), 9 deletions(-)

Index: softlimit-test2/mm/memcontrol.c
===================================================================
--- softlimit-test2.orig/mm/memcontrol.c
+++ softlimit-test2/mm/memcontrol.c
@@ -564,15 +564,28 @@ void mem_cgroup_record_reclaim_priority(
 	spin_unlock(&mem->reclaim_param_lock);
 }
 
-static int calc_inactive_ratio(struct mem_cgroup *memcg, unsigned long *present_pages)
+static int calc_inactive_ratio(struct mem_cgroup *memcg,
+			       unsigned long *present_pages,
+			       struct zone *z)
 {
 	unsigned long active;
 	unsigned long inactive;
 	unsigned long gb;
 	unsigned long inactive_ratio;
 
-	inactive = mem_cgroup_get_local_zonestat(memcg, LRU_INACTIVE_ANON);
-	active = mem_cgroup_get_local_zonestat(memcg, LRU_ACTIVE_ANON);
+	if (!z) {
+		inactive = mem_cgroup_get_local_zonestat(memcg,
+							 LRU_INACTIVE_ANON);
+		active = mem_cgroup_get_local_zonestat(memcg, LRU_ACTIVE_ANON);
+	} else {
+		int nid = z->zone_pgdat->node_id;
+		int zid = zone_idx(z);
+		struct mem_cgroup_per_zone *mz;
+
+		mz = mem_cgroup_zoneinfo(memcg, nid, zid);
+		inactive = MEM_CGROUP_ZSTAT(mz, LRU_INACTIVE_ANON);
+		active = MEM_CGROUP_ZSTAT(mz, LRU_ACTIVE_ANON);
+	}
 
 	gb = (inactive + active) >> (30 - PAGE_SHIFT);
 	if (gb)
@@ -588,14 +601,14 @@ static int calc_inactive_ratio(struct me
 	return inactive_ratio;
 }
 
-int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg)
+int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *z)
 {
 	unsigned long active;
 	unsigned long inactive;
 	unsigned long present_pages[2];
 	unsigned long inactive_ratio;
 
-	inactive_ratio = calc_inactive_ratio(memcg, present_pages);
+	inactive_ratio = calc_inactive_ratio(memcg, present_pages, z);
 
 	inactive = present_pages[0];
 	active = present_pages[1];
@@ -2366,7 +2379,8 @@ static int mem_control_stat_show(struct 
 
 
 #ifdef CONFIG_DEBUG_VM
-	cb->fill(cb, "inactive_ratio", calc_inactive_ratio(mem_cont, NULL));
+	cb->fill(cb, "inactive_ratio",
+			calc_inactive_ratio(mem_cont, NULL, NULL));
 
 	{
 		int nid, zid;
Index: softlimit-test2/include/linux/memcontrol.h
===================================================================
--- softlimit-test2.orig/include/linux/memcontrol.h
+++ softlimit-test2/include/linux/memcontrol.h
@@ -93,7 +93,7 @@ extern void mem_cgroup_note_reclaim_prio
 							int priority);
 extern void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem,
 							int priority);
-int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg);
+int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *z);
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
 				       struct zone *zone,
 				       enum lru_list lru);
@@ -234,7 +234,7 @@ static inline bool mem_cgroup_oom_called
 }
 
 static inline int
-mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg)
+mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *z)
 {
 	return 1;
 }
Index: softlimit-test2/mm/vmscan.c
===================================================================
--- softlimit-test2.orig/mm/vmscan.c
+++ softlimit-test2/mm/vmscan.c
@@ -1347,7 +1347,7 @@ static int inactive_anon_is_low(struct z
 	if (scanning_global_lru(sc))
 		low = inactive_anon_is_low_global(zone);
 	else
-		low = mem_cgroup_inactive_anon_is_low(sc->mem_cgroup);
+		low = mem_cgroup_inactive_anon_is_low(sc->mem_cgroup, NULL);
 	return low;
 }
 

