Return-Path: <linux-kernel-owner+w=401wt.eu-S1761551AbZC0FO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761551AbZC0FO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 01:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758779AbZC0FN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 01:13:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41043 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759521AbZC0FN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 01:13:56 -0400
Date: Fri, 27 Mar 2009 14:12:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [RFC][PATCH 7/8] memcg soft limit LRU reorder
Message-Id: <20090327141225.1e483acd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch adds a function to change the LRU order of pages in global LRU
under control of memcg's victim of soft limit.

FILE and ANON victim is divided and LRU rotation will be done independently.
(memcg which only includes FILE cache or ANON can exists.)

The routine finds specfied number of pages from memcg's LRU and
move it to top of global LRU. They will be the first target of shrink_xxx_list.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |   15 +++++++++++
 mm/memcontrol.c            |   60 +++++++++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c                |   18 ++++++++++++-
 3 files changed, 92 insertions(+), 1 deletion(-)

Index: mmotm-2.6.29-Mar23/include/linux/memcontrol.h
===================================================================
--- mmotm-2.6.29-Mar23.orig/include/linux/memcontrol.h
+++ mmotm-2.6.29-Mar23/include/linux/memcontrol.h
@@ -117,6 +117,9 @@ static inline bool mem_cgroup_disabled(v
 
 extern bool mem_cgroup_oom_called(struct task_struct *task);
 
+void mem_cgroup_soft_limit_reorder_lru(struct zone *zone,
+			       unsigned long nr_to_scan, enum lru_list l);
+int mem_cgroup_soft_limit_inactive_anon_is_low(struct zone *zone);
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
@@ -264,6 +267,18 @@ mem_cgroup_print_oom_info(struct mem_cgr
 {
 }
 
+static inline void
+mem_cgroup_soft_limit_reorder_lru(struct zone *zone, unsigned long nr_to_scan,
+				  enum lru_list lru);
+{
+}
+
+static inline
+int mem_cgroup_soft_limit_inactive_anon_is_low(struct zone *zone)
+{
+	return 0;
+}
+
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
Index: mmotm-2.6.29-Mar23/mm/memcontrol.c
===================================================================
--- mmotm-2.6.29-Mar23.orig/mm/memcontrol.c
+++ mmotm-2.6.29-Mar23/mm/memcontrol.c
@@ -1175,6 +1175,66 @@ static struct mem_cgroup *get_soft_limit
 	return ret;
 }
 
+/*
+ * zone->lru and memcg's lru is synchronous under zone->lock.
+ * This tries to rotate pages in specfied LRU.
+ */
+void mem_cgroup_soft_limit_reorder_lru(struct zone *zone,
+				      unsigned long nr_to_scan,
+				      enum lru_list l)
+{
+	struct mem_cgroup *mem;
+	struct mem_cgroup_per_zone *mz;
+	int nid, zid, file;
+	unsigned long scan, flags;
+	struct list_head *src;
+	LIST_HEAD(found);
+	struct page_cgroup *pc;
+	struct page *page;
+
+	nid = zone->zone_pgdat->node_id;
+	zid = zone_idx(zone);
+
+	file = is_file_lru(l);
+
+	mem = get_soft_limit_victim(zone, file);
+	if (!mem)
+		return;
+	mz = mem_cgroup_zoneinfo(mem, nid, zid);
+	src = &mz->lists[l];
+	scan = 0;
+
+	/* Find at most nr_to_scan pages from local LRU */
+	spin_lock_irqsave(&zone->lru_lock, flags);
+	list_for_each_entry_reverse(pc, src, lru) {
+		if (scan >= nr_to_scan)
+			break;
+		/* We don't check Used bit */
+		page = pc->page;
+		/* Can happen ? */
+		if (unlikely(!PageLRU(page)))
+			continue;
+		/* This page is on (the same) LRU */
+		list_move(&page->lru, &found);
+		scan++;
+	}
+	/* vmscan searches pages from lru->prev. link this to lru->prev. */
+	list_splice_tail(&found, &zone->lru[l].list);
+	spin_unlock_irqrestore(&zone->lru_lock, flags);
+}
+
+/* Returns 1 if soft limit is active && memcg's zone's status is that */
+int mem_cgroup_soft_limit_inactive_anon_is_low(struct zone *zone)
+{
+	struct soft_limit_cache *slc;
+	int ret = 0;
+
+	slc = &get_cpu_var(soft_limit_cache);
+	if (slc->mem[0])
+		ret = mem_cgroup_inactive_anon_is_low(slc->mem[SL_ANON], zone);
+	put_cpu_var(soft_limit_cache);
+	return ret;
+}
 
 static void softlimitq_init(void)
 {
Index: mmotm-2.6.29-Mar23/mm/vmscan.c
===================================================================
--- mmotm-2.6.29-Mar23.orig/mm/vmscan.c
+++ mmotm-2.6.29-Mar23/mm/vmscan.c
@@ -1060,6 +1060,13 @@ static unsigned long shrink_inactive_lis
 	pagevec_init(&pvec, 1);
 
 	lru_add_drain();
+	if (scanning_global_lru(sc)) {
+		enum lru_list l = LRU_INACTIVE_ANON;
+		if (file)
+			l = LRU_INACTIVE_FILE;
+		mem_cgroup_soft_limit_reorder_lru(zone, max_scan, l);
+	}
+
 	spin_lock_irq(&zone->lru_lock);
 	do {
 		struct page *page;
@@ -1227,6 +1234,13 @@ static void shrink_active_list(unsigned 
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
 	lru_add_drain();
+	if (scanning_global_lru(sc)) {
+		enum lru_list l = LRU_ACTIVE_ANON;
+		if (file)
+			l = LRU_ACTIVE_FILE;
+		mem_cgroup_soft_limit_reorder_lru(zone, nr_pages, l);
+	}
+
 	spin_lock_irq(&zone->lru_lock);
 	pgmoved = sc->isolate_pages(nr_pages, &l_hold, &pgscanned, sc->order,
 					ISOLATE_ACTIVE, zone,
@@ -1322,7 +1336,9 @@ static int inactive_anon_is_low_global(s
 
 	if (inactive * zone->inactive_ratio < active)
 		return 1;
-
+	/* check soft limit vicitm's status */
+	if (mem_cgroup_soft_limit_inactive_anon_is_low(zone))
+		return 1;
 	return 0;
 }
 

