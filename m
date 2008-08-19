Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYHSIfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYHSIfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYHSIe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:34:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56137 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbYHSIe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:34:58 -0400
Date: Tue, 19 Aug 2008 17:40:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       ryov@valinux.co.jp
Subject: [PATCH -mm][preview] memcg: a patch series for next [4/9]
Message-Id: <20080819174049.0d58d90c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080819173721.750d489e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080819173014.17358c17.kamezawa.hiroyu@jp.fujitsu.com>
	<20080819173721.750d489e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making freeing page_cgroup() at mem_cgroup_uncharge() to use lazy manner.

In mem_cgroup_uncharge_common(), we don't free page_cgroup
and just link it to per-cpu free queue.
And remove it later by checking threshold.

This patch is a base patch for freeing page_cgroup by RCU patch.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


---
 mm/memcontrol.c |  120 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 103 insertions(+), 17 deletions(-)

Index: linux-2.6.27-rc1-mm1/mm/memcontrol.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/mm/memcontrol.c
+++ linux-2.6.27-rc1-mm1/mm/memcontrol.c
@@ -167,6 +167,7 @@ struct page_cgroup {
 	struct page *page;
 	struct mem_cgroup *mem_cgroup;
 	unsigned long flags;
+	struct page_cgroup *next;	/* used for Lazy LRU */
 };
 
 /* These 2 flags are unchanged during being used. */
@@ -174,6 +175,21 @@ struct page_cgroup {
 #define PAGE_CG_FLAG_FILE	   (1)   /* page is file system backed */
 #define PAGE_CG_FLAG_ACTIVE    	   (2)       /* page is active in this cgroup */
 #define PAGE_CG_FLAG_UNEVICTABLE   (3)     /* page is unevictableable */
+#define PAGE_CG_FLAG_OBSOLETE  	   (4)     /* page is unevictableable */
+
+#define MEMCG_LRU_THRESH	(16)
+
+/*
+ * per-cpu slot for freeing page_cgroup in lazy way.
+ */
+
+struct mem_cgroup_lazy_lru {
+	int count;
+	struct page_cgroup *next;
+};
+
+DEFINE_PER_CPU(struct mem_cgroup_lazy_lru, memcg_lazy_lru);
+
 
 static inline void page_cgroup_set_bit(struct page_cgroup *pc, int flag)
 {
@@ -495,10 +511,12 @@ void mem_cgroup_move_lists(struct page *
 
 	pc = page_get_page_cgroup(page);
 	if (pc) {
-		mz = page_cgroup_zoneinfo(pc);
-		spin_lock_irqsave(&mz->lru_lock, flags);
-		__mem_cgroup_move_lists(pc, lru);
-		spin_unlock_irqrestore(&mz->lru_lock, flags);
+		if (!page_cgroup_test_bit(pc, PAGE_CG_FLAG_OBSOLETE)) {
+			mz = page_cgroup_zoneinfo(pc);
+			spin_lock_irqsave(&mz->lru_lock, flags);
+			__mem_cgroup_move_lists(pc, lru);
+			spin_unlock_irqrestore(&mz->lru_lock, flags);
+		}
 	}
 	unlock_page_cgroup(page);
 }
@@ -592,6 +610,8 @@ unsigned long mem_cgroup_isolate_pages(u
 		if (unlikely(!PageLRU(page)))
 			continue;
 
+		if (page_cgroup_test_bit(pc, PAGE_CG_FLAG_OBSOLETE))
+			continue;
 		/*
 		 * TODO: play better with lumpy reclaim, grabbing anything.
 		 */
@@ -618,6 +638,75 @@ unsigned long mem_cgroup_isolate_pages(u
 	return nr_taken;
 }
 
+void __mem_cgroup_drop_lru(void)
+{
+	struct mem_cgroup *memcg;
+	struct page_cgroup *pc, *next;
+	struct mem_cgroup_per_zone *mz, *page_mz;
+	struct mem_cgroup_lazy_lru *mll;
+	unsigned long flags;
+
+	mll = &get_cpu_var(memcg_lazy_lru);
+	next = mll->next;
+	mll->next = NULL;
+	mll->count = 0;
+	put_cpu_var(memcg_lazy_lru);
+
+	mz = NULL;
+
+	local_irq_save(flags);
+	while (next) {
+		pc = next;
+		next = pc->next;
+		prefetch(next);
+		page_mz = page_cgroup_zoneinfo(pc);
+		memcg = pc->mem_cgroup;
+		if (page_mz != mz) {
+			if (mz)
+				spin_unlock(&mz->lru_lock);
+			mz = page_mz;
+			spin_lock(&mz->lru_lock);
+		}
+		__mem_cgroup_remove_list(mz, pc);
+		css_put(&memcg->css);
+		kmem_cache_free(page_cgroup_cache, pc);
+	}
+	if (mz)
+		spin_unlock(&mz->lru_lock);
+	local_irq_restore(flags);
+
+	return;
+}
+
+static void mem_cgroup_drop_lru(struct page_cgroup *pc)
+{
+	int count;
+	struct mem_cgroup_lazy_lru *mll;
+
+	mll = &get_cpu_var(memcg_lazy_lru);
+	pc->next = mll->next;
+	mll->next = pc;
+	count = ++mll->count;
+	put_cpu_var(memcg_lazy_lru);
+
+	if (count >= MEMCG_LRU_THRESH)
+		__mem_cgroup_drop_lru();
+}
+
+
+static DEFINE_MUTEX(memcg_force_drain_mutex);
+static void mem_cgroup_local_force_drain(struct work_struct *work)
+{
+	__mem_cgroup_drop_lru();
+}
+
+static void mem_cgroup_all_force_drain(struct mem_cgroup *memcg)
+{
+	mutex_lock(&memcg_force_drain_mutex);
+	schedule_on_each_cpu(mem_cgroup_local_force_drain);
+	mutex_unlock(&memcg_force_drain_mutex);
+}
+
 /*
  * Charge the memory controller for page usage.
  * Return
@@ -629,10 +718,10 @@ static int mem_cgroup_charge_common(stru
 				struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *mem;
+	struct mem_cgroup_per_zone *mz;
 	struct page_cgroup *pc;
-	unsigned long flags;
 	unsigned long nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
-	struct mem_cgroup_per_zone *mz;
+	unsigned long flags;
 
 	pc = kmem_cache_alloc(page_cgroup_cache, gfp_mask);
 	if (unlikely(pc == NULL))
@@ -683,6 +772,7 @@ static int mem_cgroup_charge_common(stru
 	pc->mem_cgroup = mem;
 	pc->page = page;
 	pc->flags = 0;
+	pc->next = NULL;
 	/*
 	 * If a page is accounted as a page cache, insert to inactive list.
 	 * If anon, insert to active list.
@@ -712,6 +802,7 @@ static int mem_cgroup_charge_common(stru
 	spin_unlock_irqrestore(&mz->lru_lock, flags);
 
 	unlock_page_cgroup(page);
+
 done:
 	return 0;
 out:
@@ -785,8 +876,6 @@ __mem_cgroup_uncharge_common(struct page
 {
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem;
-	struct mem_cgroup_per_zone *mz;
-	unsigned long flags;
 
 	if (mem_cgroup_subsys.disabled)
 		return;
@@ -806,19 +895,14 @@ __mem_cgroup_uncharge_common(struct page
 		|| page_mapped(page)))
 		goto unlock;
 
-	mz = page_cgroup_zoneinfo(pc);
-	spin_lock_irqsave(&mz->lru_lock, flags);
-	__mem_cgroup_remove_list(mz, pc);
-	spin_unlock_irqrestore(&mz->lru_lock, flags);
-
+	mem = pc->mem_cgroup;
+	prefetch(mem);
+	page_cgroup_set_bit(pc, PAGE_CG_FLAG_OBSOLETE);
 	page_assign_page_cgroup(page, NULL);
 	unlock_page_cgroup(page);
-
-	mem = pc->mem_cgroup;
 	mem_counter_uncharge(mem, 1);
-	css_put(&mem->css);
+	mem_cgroup_drop_lru(pc);
 
-	kmem_cache_free(page_cgroup_cache, pc);
 	return;
 unlock:
 	unlock_page_cgroup(page);
@@ -1011,6 +1095,7 @@ static int mem_cgroup_force_empty(struct
 			}
 	}
 	ret = 0;
+	mem_cgroup_all_force_drain(mem);
 out:
 	css_put(&mem->css);
 	return ret;
@@ -1212,6 +1297,7 @@ static int alloc_mem_cgroup_per_zone_inf
 		for_each_lru(l)
 			INIT_LIST_HEAD(&mz->lists[l]);
 	}
+
 	return 0;
 }
 

