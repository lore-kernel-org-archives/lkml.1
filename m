Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZDVIzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZDVIzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 04:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbZDVIy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 04:54:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45894 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbZDVIy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 04:54:58 -0400
Date: Wed, 22 Apr 2009 17:53:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] memcg: relax force empty loop
Message-Id: <20090422175323.9660f261.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Andrew Morton pointed out that force_empty() may work too long and
will cause unpleasant delay or dead-lock around page isolation.

This patch rewrites memcg's force_empty to do
  - avoid trylock, just use lock_page_cgroup().
  - When it has worked for a long time, take a rest for a while.

The logic is.
  - move 32 pages at most per one trial.
  - if there are still pages remaining and we have more time, retry.
  - if work time(HZ/10) elapsed, check we should sleep or not.

Concern:
 - this may make rmdir() dramatically slow because this uses
   schedule_timeout() for relaxing.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/page_cgroup.h |    5 --
 mm/memcontrol.c             |   87 +++++++++++++++++++++++++++++++-------------
 2 files changed, 62 insertions(+), 30 deletions(-)

Index: mmotm-2.6.30-Apr21/mm/memcontrol.c
===================================================================
--- mmotm-2.6.30-Apr21.orig/mm/memcontrol.c
+++ mmotm-2.6.30-Apr21/mm/memcontrol.c
@@ -1148,8 +1148,7 @@ static int mem_cgroup_move_account(struc
 	from_mz =  mem_cgroup_zoneinfo(from, nid, zid);
 	to_mz =  mem_cgroup_zoneinfo(to, nid, zid);
 
-	if (!trylock_page_cgroup(pc))
-		return ret;
+	lock_page_cgroup(pc);
 
 	if (!PageCgroupUsed(pc))
 		goto out;
@@ -1807,33 +1806,38 @@ int mem_cgroup_resize_memsw_limit(struct
 }
 
 /*
- * This routine traverse page_cgroup in given list and drop them all.
- * *And* this routine doesn't reclaim page itself, just removes page_cgroup.
+ * This routine moves all accounts to it parents. Returns 0 if the list
+ * comes to be empty. move 256 pages at most in each turn and returns EAGAIN
+ * if time is over.
  */
-static int mem_cgroup_force_empty_list(struct mem_cgroup *mem,
-				int node, int zid, enum lru_list lru)
+#define NR_MOVE_ACCOUNT_THRESH	(32) /* 128kbytes if page size is 4k */
+
+static long mem_cgroup_force_empty_list(struct mem_cgroup *mem, int node,
+					int zid, enum lru_list lru,
+					unsigned long next_wait)
 {
 	struct zone *zone;
 	struct mem_cgroup_per_zone *mz;
 	struct page_cgroup *pc, *busy;
-	unsigned long flags, loop;
+	unsigned long flags, scan, failure;
 	struct list_head *list;
-	int ret = 0;
+	int ret;
 
 	zone = &NODE_DATA(node)->node_zones[zid];
 	mz = mem_cgroup_zoneinfo(mem, node, zid);
 	list = &mz->lists[lru];
 
-	loop = MEM_CGROUP_ZSTAT(mz, lru);
-	/* give some margin against EBUSY etc...*/
-	loop += 256;
+	/* The number of pages to be scanned in this turn */
+retry:
+	scan = NR_MOVE_ACCOUNT_THRESH;
 	busy = NULL;
-	while (loop--) {
-		ret = 0;
+	while (scan--) {
+
 		spin_lock_irqsave(&zone->lru_lock, flags);
 		if (list_empty(list)) {
 			spin_unlock_irqrestore(&zone->lru_lock, flags);
-			break;
+			/* SUCCESS! */
+			return 0;
 		}
 		pc = list_entry(list->prev, struct page_cgroup, lru);
 		if (busy == pc) {
@@ -1845,32 +1849,47 @@ static int mem_cgroup_force_empty_list(s
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
 		ret = mem_cgroup_move_parent(pc, mem, GFP_KERNEL);
+
 		if (ret == -ENOMEM)
-			break;
+			return ret;
 
 		if (ret == -EBUSY || ret == -EINVAL) {
 			/* found lock contention or "pc" is obsolete. */
 			busy = pc;
 			cond_resched();
+			/* EBUSY check is done in other logic, finally */
+			failure++;
 		} else
 			busy = NULL;
 	}
+	/* List is not empty yet....*/
 
-	if (!ret && !list_empty(list))
+	/* Some busy pages ? (needs lru_add_drain() */
+	if (failure)
 		return -EBUSY;
-	return ret;
+
+	/* need to revisit this zone */
+	if (!time_after(jiffies, next_wait))
+		goto retry;
+
+	return -EAGAIN;
 }
 
 /*
  * make mem_cgroup's charge to be 0 if there is no task.
  * This enables deleting this mem_cgroup.
  */
+
+#define FORCE_EMPTY_RELAX_TICK (HZ/20)
+#define FORCE_EMPTY_WORK_TICK (HZ/10)
+
 static int mem_cgroup_force_empty(struct mem_cgroup *mem, bool free_all)
 {
 	int ret;
 	int node, zid, shrink;
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct cgroup *cgrp = mem->css.cgroup;
+	unsigned long next_wait;
 
 	css_get(&mem->css);
 
@@ -1879,6 +1898,10 @@ static int mem_cgroup_force_empty(struct
 	if (free_all)
 		goto try_to_free;
 move_account:
+	/* This is for making all *used* pages to be on LRU. */
+	lru_add_drain_all();
+
+	next_wait = jiffies + FORCE_EMPTY_WORK_TICK;
 	while (mem->res.usage > 0) {
 		ret = -EBUSY;
 		if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
@@ -1886,26 +1909,40 @@ move_account:
 		ret = -EINTR;
 		if (signal_pending(current))
 			goto out;
-		/* This is for making all *used* pages to be on LRU. */
-		lru_add_drain_all();
 		ret = 0;
 		for_each_node_state(node, N_HIGH_MEMORY) {
-			for (zid = 0; !ret && zid < MAX_NR_ZONES; zid++) {
+			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 				enum lru_list l;
 				for_each_lru(l) {
-					ret = mem_cgroup_force_empty_list(mem,
-							node, zid, l);
-					if (ret)
+					ret = mem_cgroup_force_empty_list(
+						mem, node, zid, l, next_wait);
+					if (ret < 0)
 						break;
 				}
 			}
-			if (ret)
+			if (ret < 0)
 				break;
 		}
 		/* it seems parent cgroup doesn't have enough mem */
 		if (ret == -ENOMEM)
 			goto try_to_free;
-		cond_resched();
+		/*
+		 * It seems some page are off-LRU. Give chance to others and
+		 * sleep until flush. This will wait for kevent workq.
+		 */
+		if (ret == -EBUSY)
+			lru_add_drain_all();
+
+		if (cond_resched())
+			next_wait = jiffies + FORCE_EMPTY_WORK_TICK;
+		else if (ret == -EAGAIN || time_after(jiffies, next_wait)) {
+			/* release this cpu for a while. If we could release
+			 * cpu by cond_resched(), we don't come here.
+			 */
+			schedule_timeout(FORCE_EMPTY_RELAX_TICK);
+			next_wait = jiffies + FORCE_EMPTY_WORK_TICK;
+		}
+
 	}
 	ret = 0;
 out:
Index: mmotm-2.6.30-Apr21/include/linux/page_cgroup.h
===================================================================
--- mmotm-2.6.30-Apr21.orig/include/linux/page_cgroup.h
+++ mmotm-2.6.30-Apr21/include/linux/page_cgroup.h
@@ -61,11 +61,6 @@ static inline void lock_page_cgroup(stru
 	bit_spin_lock(PCG_LOCK, &pc->flags);
 }
 
-static inline int trylock_page_cgroup(struct page_cgroup *pc)
-{
-	return bit_spin_trylock(PCG_LOCK, &pc->flags);
-}
-
 static inline void unlock_page_cgroup(struct page_cgroup *pc)
 {
 	bit_spin_unlock(PCG_LOCK, &pc->flags);

