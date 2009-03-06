Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbZCFKjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbZCFKjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbZCFKjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:39:06 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59120 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbZCFKjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:39:03 -0500
Date: Fri, 6 Mar 2009 19:37:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 2/3] memcg sotlimit logic (Yet Another One)
Message-Id: <20090306193740.168d1001.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090306193438.8084837d.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090306092323.21063.93169.sendpatchset@localhost.localdomain>
	<20090306185440.66b92ca3.kamezawa.hiroyu@jp.fujitsu.com>
	<20090306193438.8084837d.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Patch for Mem cgroup softlimit (2/3)

This patch implements the core logic.

Memory cgroups with softlimit are linked to list of there own priority.
Balance_pgdat() scan it and try to remove pages.
Scanning status is recorded per node (means per kswapd) and cgroups
on the same softlimit level is scanned in round-robin manner.

If no softlimit hits, returns NULL.

balance_pgdat() work as following.
  1. at start, reset status and start scanning from the lowest priority.
     (= SOFTLIMIT_MAX_PRIORITY = 3)
  2. if priority is 0, ignore softlimit.
  2. Scan list of the priority and get victim.
  3. If no victim on the list, decrement priority (goto 2.)

the number fo scanning under softlimit is limited by balance_pgdat()
w.r.t scanning priority and target.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: mmotm-2.6.29-Mar3/mm/memcontrol.c
===================================================================
--- mmotm-2.6.29-Mar3.orig/mm/memcontrol.c
+++ mmotm-2.6.29-Mar3/mm/memcontrol.c
@@ -599,6 +599,21 @@ unsigned long mem_cgroup_zone_nr_pages(s
 	return MEM_CGROUP_ZSTAT(mz, lru);
 }
 
+unsigned long
+mem_cgroup_evictable_usage(struct mem_cgroup *memcg, int nid, int zid)
+{
+	unsigned long total = 0;
+	struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(memcg, nid, zid);
+
+	if (nr_swap_pages) {
+		total += MEM_CGROUP_ZSTAT(mz, LRU_INACTIVE_ANON);
+		total += MEM_CGROUP_ZSTAT(mz, LRU_ACTIVE_ANON);
+	}
+	total +=  MEM_CGROUP_ZSTAT(mz, LRU_INACTIVE_FILE);
+	total +=  MEM_CGROUP_ZSTAT(mz, LRU_ACTIVE_FILE);
+	return total;
+}
+
 struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
 						      struct zone *zone)
 {
@@ -1583,6 +1598,134 @@ static void softlimit_del_list(struct me
 	up_write(&softlimit_sem);
 }
 
+static bool mem_cgroup_hit_softlimit(struct mem_cgroup *mem)
+{
+	struct mem_cgroup *governor = mem->min_softlimit_governor;
+	u64 usage;
+
+	usage = res_counter_read_u64(&governor->res, RES_USAGE);
+	return (usage > governor->softlimit);
+}
+
+/*
+ * Softlimit Handler. Softlimit is called by kswapd() and kswapd exists per
+ * node. Then, control structs for softlimit exists per node.
+ * Only user of this struct is kswapd. No lock is necessary.
+ */
+struct softlimit_control {
+	int prio;
+	struct mem_cgroup *iter[SOFTLIMIT_MAX_PRIO];
+};
+struct softlimit_control softlimit_ctrl[MAX_NUMNODES][MAX_NR_ZONES];
+
+/*
+ * Called when balance_pgdat() enters new turn and reset priority
+ * information recorded.
+ */
+void mem_cgroup_start_softlimit_reclaim(int nid)
+{
+	int zid;
+
+	for (zid = 0; zid < MAX_NR_ZONES; zid++)
+		softlimit_ctrl[nid][zid].prio = SOFTLIMIT_MAX_PRIO - 1;
+}
+/*
+ * Seatch victim in specified priority level. If not found, retruns NULL.
+ * For implemnting round-robin, list_for_each_entry_from() is used.
+ */
+struct mem_cgroup *__mem_cgroup_get_vicitm_prio(int nid, int zid,
+				struct mem_cgroup *start, int prio)
+{
+	struct list_head *list = &softlimit_head.list[prio];
+	struct mem_cgroup *mem, *ret;
+	int loop = 0;
+
+	if (!start && list_empty(list))
+		return NULL;
+
+	if (!start) /* start from the head of list */
+		start = list_entry(list->next,
+				   struct mem_cgroup, softlimit_list);
+	mem = start;
+	ret = NULL;
+retry:  /* round robin */
+	list_for_each_entry_from(mem, list, softlimit_list) {
+		if (loop == 1 && mem == start)
+			break;
+		if (!css_tryget(&mem->css))
+			continue;
+		if (mem_cgroup_hit_softlimit(mem) &&
+		    mem_cgroup_evictable_usage(mem, nid, zid)) {
+			ret = mem;
+			break;
+		}
+		css_put(&mem->css);
+	}
+	if (!ret && loop++ == 0) {
+		/* restart from the head of list */
+		mem = list_entry(list->next,
+				 struct mem_cgroup, softlimit_list);
+		goto retry;
+	}
+	return ret;
+}
+
+struct mem_cgroup *mem_cgroup_get_victim(int nid, int zid)
+{
+	struct softlimit_control *slc = &softlimit_ctrl[nid][zid];
+	struct mem_cgroup *mem, *ret;
+	int prio;
+	ret = NULL;
+
+	/* before enter round-robin, check it's worth to try or not. */
+	if (slc->prio == 0)
+		return NULL;
+	prio = slc->prio;
+	/* Try read-lock */
+	if (!down_read_trylock(&softlimit_sem))
+		return NULL;
+new_prio:
+	/* At first check start point marker */
+	mem = slc->iter[prio];
+	if (mem) {
+		if (css_is_removed(&mem->css) ||
+		    mem->softlimit_priority != prio) {
+			mem_cgroup_put(mem);
+		}
+	}
+	slc->iter[prio] = NULL;
+	ret = __mem_cgroup_get_vicitm_prio(nid, zid, mem, prio);
+	if (mem) {
+		mem_cgroup_put(mem);
+		mem = NULL;
+	}
+	if (!ret) {
+		prio--;
+		if (prio > 0)
+			goto new_prio;
+	}
+	if (ret) { /* Remember the "next" position */
+		prio = ret->softlimit_priority;
+		if (ret->softlimit_list.next != &softlimit_head.list[prio]) {
+			mem = list_entry(ret->softlimit_list.next,
+					 struct mem_cgroup, softlimit_list);
+			slc->iter[prio] = mem;
+			mem_cgroup_get(mem);
+		} else
+			slc->iter[prio] = NULL;
+	} else {
+		/* We have no candidates. ignore softlimit in this turn */
+		slc->prio = 0;
+	}
+	up_read(&softlimit_sem);
+	return ret;
+}
+
+void mem_cgroup_put_victim(struct mem_cgroup *mem)
+{
+	if (mem)
+		mem_cgroup_put(mem);
+}
 
 /*
  * Before starting migration, account PAGE_SIZE to mem_cgroup that the old
Index: mmotm-2.6.29-Mar3/include/linux/memcontrol.h
===================================================================
--- mmotm-2.6.29-Mar3.orig/include/linux/memcontrol.h
+++ mmotm-2.6.29-Mar3/include/linux/memcontrol.h
@@ -117,6 +117,10 @@ static inline bool mem_cgroup_disabled(v
 
 extern bool mem_cgroup_oom_called(struct task_struct *task);
 
+extern void mem_cgroup_start_softlimit_reclaim(int nid);
+extern struct mem_cgroup *mem_cgroup_get_victim(int nid, int zid);
+extern void mem_cgroup_put_vicitm(struct mem_cgroup *mem);
+
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
@@ -264,6 +268,20 @@ mem_cgroup_print_oom_info(struct mem_cgr
 {
 }
 
+
+static void mem_cgroup_start_softlimit_reclaim(int nid)
+{
+}
+
+static struct mem_cgroup *mem_cgroup_get_vicitm(int nid, int zid)
+{
+	return NULL;
+}
+
+static void mem_cgroup_put_vicitm(struct mem_cgroup *mem)
+{
+}
+
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
Index: mmotm-2.6.29-Mar3/mm/vmscan.c
===================================================================
--- mmotm-2.6.29-Mar3.orig/mm/vmscan.c
+++ mmotm-2.6.29-Mar3/mm/vmscan.c
@@ -1733,6 +1733,39 @@ unsigned long try_to_free_mem_cgroup_pag
 }
 #endif
 
+#define SOFTLIMIT_SCAN_MAX (512)
+void shrink_zone_softlimit(struct scan_control *sc, struct zone *zone,
+			   int order, int priority, int target, int end_zone)
+{
+	struct mem_cgroup *mem;
+	int nid = zone->zone_pgdat->node_id;
+	int zid = zone_idx(zone);
+	int scan = SWAP_CLUSTER_MAX;
+
+	scan <<= (DEF_PRIORITY - priority);
+	if (scan > (target * 2))
+		scan = target * 2;
+retry:
+	mem = mem_cgroup_get_victim(nid, zid);
+	if (!mem)
+		return;
+
+	sc->nr_scanned = 0;
+	sc->mem_cgroup = mem;
+	sc->isolate_pages = mem_cgroup_isolate_pages;
+
+	shrink_zone(priority, zone, sc);
+	sc->mem_cgroup = NULL;
+	sc->isolate_pages = isolate_pages_global;
+	if (zone_watermark_ok(zone, order, target, end_zone, 0))
+		return;
+	scan -= sc->nr_scanned;
+	/* We should avoid too much scanning against this priority level */
+	if (scan > 0)
+		goto retry;
+	return;
+}
+
 /*
  * For kswapd, balance_pgdat() will work across all this node's zones until
  * they are all at pages_high.
@@ -1776,6 +1809,7 @@ static unsigned long balance_pgdat(pg_da
 	 */
 	int temp_priority[MAX_NR_ZONES];
 
+	mem_cgroup_start_softlimit_reclaim(pgdat->node_id);
 loop_again:
 	total_scanned = 0;
 	sc.nr_reclaimed = 0;
@@ -1856,6 +1890,11 @@ loop_again:
 					       end_zone, 0))
 				all_zones_ok = 0;
 			temp_priority[i] = priority;
+
+			/* try soft limit of memory cgroup */
+			shrink_zone_softlimit(&sc, zone, order, priority,
+				      8 * zone->pages_high, end_zone);
+
 			sc.nr_scanned = 0;
 			note_zone_scanning_priority(zone, priority);
 			/*

