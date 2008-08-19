Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbYHSIiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbYHSIiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbYHSIiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:38:03 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42962 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbYHSIh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:37:59 -0400
Date: Tue, 19 Aug 2008 17:44:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       ryov@valinux.co.jp
Subject: [PATCH -mm][preview] memcg: a patch series for next [8/9]
Message-Id: <20080819174404.80dd5102.kamezawa.hiroyu@jp.fujitsu.com>
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

Very experimental...

mem+swap controller prototype.

This patch adds CONFIG_CGROUP_MEM_RES_CTLR_SWAP as memory resource
controller's swap extension.

When enabling this, memory resource controller will have 2 limits.

 - memory.limit_in_bytes .... limit for pages
 - memory.memsw_limit_in_bytes .... limit for pages + swaps.

Following is (easy) accounting state transion after this patch.

   pages   swaps    pages_total   memsw_total
    +1       -           +1           +1        new page allocation.
    -1      +1           -1           -         swap out.
    +1      -1            0           -         swap in (*).
    -       -1           -            -1        swap_free.

At swap-out, swp_entry will be charged against the cgroup of the page.
At swap-in, the page will be charged when it's mapped.
(Maybe accounting at read_swap() will be beautiful but we can avoid some of
 error handling to delay accounting until mem_cgroup_charge().)

The charge against swap_entry will be uncharged when swap_entry is freed.

The parameter res.swaps just includes swaps not-on swap cache.
So, this doesn't show real usage of swp_entry just shows swp_entry on disk.

This patch doesn't include codes for control files.

TODO:
  - clean up. and add comments.
  - support vm_swap_full() under cgroup.
  - find easier-to-understand protocol....
  - check force_empty....(maybe buggy)
  - support page migration.
  - test!!

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 include/linux/swap.h  |   32 +++-
 init/Kconfig          |   12 +
 kernel/power/swsusp.c |    2 
 mm/memcontrol.c       |  387 +++++++++++++++++++++++++++++++++++++++++++++-----
 mm/shmem.c            |    2 
 mm/swap_state.c       |    9 -
 mm/swapfile.c         |   54 ++++++
 7 files changed, 453 insertions(+), 45 deletions(-)

Index: linux-2.6.27-rc1-mm1/mm/memcontrol.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/mm/memcontrol.c
+++ linux-2.6.27-rc1-mm1/mm/memcontrol.c
@@ -117,8 +117,10 @@ struct mem_cgroup_lru_info {
  * a feature that will be implemented much later in the future.
  */
 struct mem_counter {
-	unsigned long   pages_limit;
+	unsigned long   pages_limit;	/* limit for amount of pages. */
+	unsigned long   memsw_limit;	/* limit for amount of pages + swaps */
 	unsigned long   pages;
+	unsigned long	swaps;
 	unsigned long   failcnt;
 	unsigned long   max_usage;
 	spinlock_t	lock;
@@ -141,6 +143,11 @@ struct mem_cgroup {
 	 * statistics.
 	 */
 	struct mem_cgroup_stat stat;
+	/*
+	 * swap
+	 */
+	spinlock_t	swap_list_lock;
+	struct list_head	swap_list;
 };
 static struct mem_cgroup init_mem_cgroup;
 
@@ -176,6 +183,46 @@ struct mem_cgroup_lazy_lru {
 
 DEFINE_PER_CPU(struct mem_cgroup_lazy_lru, memcg_lazy_lru);
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+/*
+ * For swap management.
+ */
+DEFINE_SPINLOCK(memcg_swap_control_lock);
+RADIX_TREE(memcg_swap_control, GFP_KERNEL);
+
+struct swap_cgroup {
+	swp_entry_t	entry;
+	unsigned long		flags;
+	struct mem_cgroup	*mem_cgroup;
+	struct list_head	list;
+};
+
+/* for flags */
+enum {
+	SWAP_CG_FLAG_ACCOUNTED,
+	NR_SWAP_CG_FLAGS,
+};
+
+static inline int swap_accounted(struct swap_cgroup *sc)
+{
+	return test_bit(SWAP_CG_FLAG_ACCOUNTED, &sc->flags);
+}
+
+static inline void set_swap_accounted(struct swap_cgroup *sc)
+{
+	set_bit(SWAP_CG_FLAG_ACCOUNTED, &sc->flags);
+}
+
+static inline void clear_swap_accounted(struct swap_cgroup *sc)
+{
+	clear_bit(SWAP_CG_FLAG_ACCOUNTED, &sc->flags);
+}
+
+#define do_account_swap	(1)
+#else
+#define	do_account_swap	(0)
+#endif
+
 
 static inline void page_cgroup_set_bit(struct page_cgroup *pc, int flag)
 {
@@ -211,6 +258,7 @@ static enum zone_type page_cgroup_zid(st
 enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
 	MEM_CGROUP_CHARGE_TYPE_MAPPED,
+	MEM_CGROUP_CHARGE_TYPE_SWAPOUT,
 	MEM_CGROUP_CHARGE_TYPE_FORCE,	/* used by force_empty */
 };
 
@@ -313,7 +361,9 @@ static void mem_counter_init(struct mem_
 	spin_lock_init(&memcg->res.lock);
 	memcg->res.pages = 0;
 	memcg->res.pages_limit = ~0UL;
+	memcg->res.memsw_limit = ~0UL;
 	memcg->res.failcnt = 0;
+	memcg->res.swaps = 0;
 }
 
 static int mem_counter_charge(struct mem_cgroup *memcg, long num)
@@ -321,16 +371,22 @@ static int mem_counter_charge(struct mem
 	unsigned long flags;
 
 	spin_lock_irqsave(&memcg->res.lock, flags);
-	if (memcg->res.pages + num > memcg->res.pages_limit) {
-		memcg->res.failcnt++;
-		spin_unlock_irqrestore(&memcg->res.lock, flags);
-		return -EBUSY;
-	}
+	if (memcg->res.pages + num > memcg->res.pages_limit)
+		goto busy;
+	if (do_account_swap
+	    && (memcg->res.pages + memcg->res.swaps + num
+			> memcg->res.memsw_limit))
+		goto busy;
 	memcg->res.pages += num;
 	if (memcg->res.pages > memcg->res.max_usage)
 		memcg->res.max_usage = memcg->res.pages;
 	spin_unlock_irqrestore(&memcg->res.lock, flags);
 	return 0;
+busy:
+	memcg->res.failcnt++;
+	spin_unlock_irqrestore(&memcg->res.lock, flags);
+	return -EBUSY;
+
 }
 
 static inline void mem_counter_uncharge(struct mem_cgroup *memcg, long num)
@@ -343,6 +399,30 @@ static inline void mem_counter_uncharge(
 	spin_unlock_irqrestore(&memcg->res.lock, flags);
 }
 
+/*
+ * Convert the charge from page to swap. (no change in total)
+ * charge value is always "1".
+ */
+static inline void
+mem_counter_recharge_swapout(struct mem_cgroup *memcg)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&memcg->res.lock, flags);
+	memcg->res.swaps += 1;
+	memcg->res.pages -= 1;
+	spin_unlock_irqrestore(&memcg->res.lock, flags);
+}
+
+static inline void
+mem_counter_uncharge_swap(struct mem_cgroup *memcg, long num)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&memcg->res.lock, flags);
+	memcg->res.swaps -= num;
+	spin_unlock_irqrestore(&memcg->res.lock, flags);
+}
+
 static int mem_counter_set_pages_limit(struct mem_cgroup *memcg,
 		unsigned long lim)
 {
@@ -372,6 +452,18 @@ static int __mem_counter_check_under_lim
 	return ret;
 }
 
+static int __mem_counter_check_under_memsw_limit(struct mem_cgroup *memcg)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&memcg->res.lock, flags);
+	if (memcg->res.pages + memcg->res.swaps < memcg->res.memsw_limit)
+		ret = 1;
+	spin_unlock_irqrestore(&memcg->res.lock, flags);
+	return ret;
+}
+
 static void __mem_cgroup_remove_list(struct mem_cgroup_per_zone *mz,
 			struct page_cgroup *pc)
 {
@@ -467,16 +559,156 @@ void mem_cgroup_move_lists(struct page *
 	rcu_read_lock();
 	pc = page_get_page_cgroup(page);
 	if (pc) {
-		if (!page_cgroup_test_bit(pc, PAGE_CG_FLAG_OBSOLETE)) {
-			mz = page_cgroup_zoneinfo(pc);
-			spin_lock_irqsave(&mz->lru_lock, flags);
-			__mem_cgroup_move_lists(pc, lru);
-			spin_unlock_irqrestore(&mz->lru_lock, flags);
+		mz = page_cgroup_zoneinfo(pc);
+		spin_lock_irqsave(&mz->lru_lock, flags);
+		__mem_cgroup_move_lists(pc, lru);
+		spin_unlock_irqrestore(&mz->lru_lock, flags);
+	}
+	rcu_read_unlock();
+}
+
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+/*
+ * Create a space for remember swap_entry.
+ * Called from get_swap_page().
+ */
+int cgroup_precharge_swap_ent(swp_entry_t entry, gfp_t mask)
+{
+	struct swap_cgroup *sc;
+	unsigned long flags;
+	int error = -ENOMEM;
+
+	sc = kmalloc(sizeof(*sc), mask);
+	if (!sc)
+		return error;
+	error = radix_tree_preload(mask);
+	if (error)
+		return error;
+	sc->entry = entry;
+	sc->mem_cgroup = NULL;
+	INIT_LIST_HEAD(&sc->list);
+	spin_lock_irqsave(&memcg_swap_control_lock, flags);
+	error = radix_tree_insert(&memcg_swap_control, entry.val, sc);
+	spin_unlock_irqrestore(&memcg_swap_control_lock, flags);
+
+	if (error) {
+		if (error == -EEXIST)
+			error = 0;
+		kfree(sc);
+	}
+	return error;
+}
+
+/*
+ * This function will never cause memory allocation.
+ * called from add_to_swap_cache().
+ */
+void cgroup_commit_swap_owner(struct page *page, swp_entry_t entry)
+{
+	struct swap_cgroup *sc;
+	unsigned long flags;
+
+	rcu_read_lock();
+	spin_lock_irqsave(&memcg_swap_control_lock, flags);
+	sc = radix_tree_lookup(&memcg_swap_control, entry.val);
+	/*
+	 * There are 2 cases:
+	 * Swap-In: we do nothing. In this case, sc->mem_cgroup is not NULL.
+	 * Swap-out: we marks sc->mem_cgroup to be page->mem_cgroup.
+	 *
+	 */
+	VM_BUG_ON(!sc);
+	if (!sc->mem_cgroup) {
+		struct page_cgroup *pc;
+		pc  = page_get_page_cgroup(page);
+		if (pc && !page_cgroup_test_bit(pc, PAGE_CG_FLAG_OBSOLETE)) {
+			struct mem_cgroup *memcg = pc->mem_cgroup;
+			sc->mem_cgroup = memcg;
+			sc->flags = 0;
+			spin_lock(&memcg->swap_list_lock);
+			list_add(&sc->list, &memcg->swap_list);
+			spin_unlock(&memcg->swap_list_lock);
+			css_get(&memcg->css);
 		}
 	}
+	spin_unlock_irqrestore(&memcg_swap_control_lock, flags);
+	rcu_read_unlock();
+}
+
+static struct swap_cgroup *mem_cgroup_lookup_swap(swp_entry_t entry)
+{
+	struct swap_cgroup *sc;
+
+	rcu_read_lock();
+	sc = radix_tree_lookup(&memcg_swap_control, entry.val);
 	rcu_read_unlock();
+
+	return sc;
 }
 
+static struct mem_cgroup *lookup_memcg_from_swap(swp_entry_t entry)
+{
+	struct swap_cgroup *sc;
+	sc = mem_cgroup_lookup_swap(entry);
+	if (sc)
+		return sc->mem_cgroup;
+	/* never reach here ? */
+	WARN_ON("lookup_memcg_from_swap returns NULL");
+	return NULL;
+}
+
+static void swap_cgroup_uncharge_swap(struct mem_cgroup *mem, swp_entry_t entry)
+{
+	struct swap_cgroup *sc;
+
+	sc = mem_cgroup_lookup_swap(entry);
+	BUG_ON(!sc);
+
+	if (!swap_accounted(sc))
+		return;
+	mem_counter_uncharge_swap(mem, 1);
+	clear_swap_accounted(sc);
+}
+
+static void swap_cgroup_delete_swap(swp_entry_t entry)
+{
+	struct swap_cgroup *sc;
+	struct mem_cgroup *memcg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&memcg_swap_control_lock, flags);
+	sc = radix_tree_delete(&memcg_swap_control, entry.val);
+	spin_unlock_irqrestore(&memcg_swap_control_lock, flags);
+
+	if (sc) {
+		memcg = sc->mem_cgroup;
+		spin_lock_irqsave(&memcg->swap_list_lock, flags);
+		list_del(&sc->list);
+		spin_unlock_irqrestore(&memcg->swap_list_lock, flags);
+		if (swap_accounted(sc))
+			mem_counter_uncharge_swap(memcg, 1);
+		css_put(&memcg->css);
+		kfree(sc);
+	}
+	return;
+}
+#else
+
+static struct mem_cgroup *lookup_memcg_from_swap(swp_entry_t entry)
+{
+	return NULL;
+}
+static void swap_cgroup_uncharge_swap(struct mem_cgroup *mem, swp_entry_t val)
+{
+	return;
+}
+static void swap_cgroup_delete_swap(swp_entry_t val)
+{
+	return;
+}
+
+#endif
+
 /*
  * Calculate mapped_ratio under memory controller. This will be used in
  * vmscan.c for deteremining we have to reclaim mapped pages.
@@ -566,8 +798,6 @@ unsigned long mem_cgroup_isolate_pages(u
 		if (unlikely(!PageLRU(page)))
 			continue;
 
-		if (page_cgroup_test_bit(pc, PAGE_CG_FLAG_OBSOLETE))
-			continue;
 		/*
 		 * TODO: play better with lumpy reclaim, grabbing anything.
 		 */
@@ -735,21 +965,33 @@ static int mem_cgroup_charge_common(stru
 	}
 
 	while (mem_counter_charge(mem, 1)) {
+		int progress;
+
 		if (!(gfp_mask & __GFP_WAIT))
 			goto out;
 
-		if (try_to_free_mem_cgroup_pages(mem, gfp_mask))
-			continue;
-
-		/*
-		 * try_to_free_mem_cgroup_pages() might not give us a full
-		 * picture of reclaim. Some pages are reclaimed and might be
-		 * moved to swap cache or just unmapped from the cgroup.
-		 * Check the limit again to see if the reclaim reduced the
-		 * current usage of the cgroup before giving up
-		 */
-		if (__mem_counter_check_under_limit(mem))
-			continue;
+		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask);
+		if (do_account_swap) {
+			/* When we hit memsw_limit, success of
+			   try_to_free_page() doesn't mean we can go ahead. */
+			if (progress
+			    && __mem_counter_check_under_memsw_limit(mem))
+				continue;
+		} else {
+			if (progress)
+				continue;
+			/*
+		 	 * try_to_free_mem_cgroup_pages() might not give us a
+		 	 * full picture of reclaim. Some pages are reclaimed
+			 * and might be moved to swap cache or just unmapped
+			 * from moved to swap cache or just unmapped from the
+		 	 * cgroup.
+		 	 * Check the limit again to see if the reclaim reduced
+			 * the current usage of the cgroup before giving up.
+		 	 */
+			if (__mem_counter_check_under_limit(mem))
+				continue;
+		}
 
 		if (!nr_retries--) {
 			mem_cgroup_out_of_memory(mem, gfp_mask);
@@ -782,6 +1024,11 @@ static int mem_cgroup_charge_common(stru
 	__mem_cgroup_add_list(mz, pc);
 	spin_unlock_irqrestore(&mz->lru_lock, flags);
 
+	if (do_account_swap && PageSwapCache(page)) {
+		swp_entry_t entry = { .val = page_private(page) };
+		swap_cgroup_uncharge_swap(mem, entry);
+	}
+
 	return 0;
 out:
 	css_put(&mem->css);
@@ -792,6 +1039,8 @@ err:
 
 int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
 {
+	struct mem_cgroup *memcg = NULL;
+
 	if (mem_cgroup_subsys.disabled)
 		return 0;
 
@@ -806,13 +1055,23 @@ int mem_cgroup_charge(struct page *page,
 		return 0;
 	if (unlikely(!mm))
 		mm = &init_mm;
+
+	if (do_account_swap && PageSwapCache(page)) {
+		swp_entry_t entry = { .val = page_private(page) };
+		/* swap cache can have valid page->page_cgroup */
+		if (page->mapping && page_get_page_cgroup(page))
+			return 0;
+		memcg = lookup_memcg_from_swap(entry);
+	}
+
 	return mem_cgroup_charge_common(page, mm, gfp_mask,
-				MEM_CGROUP_CHARGE_TYPE_MAPPED, NULL);
+				MEM_CGROUP_CHARGE_TYPE_MAPPED, memcg);
 }
 
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
+	struct mem_cgroup *memcg = NULL;
 	if (mem_cgroup_subsys.disabled)
 		return 0;
 
@@ -835,25 +1094,33 @@ int mem_cgroup_cache_charge(struct page 
 			return 0;
 		}
 	}
+	if (do_account_swap && PageSwapCache(page)) {
+		swp_entry_t entry = { .val = page_private(page) };
+		/* swap cache can have valid page->page_cgroup */
+		if (page->mapping && page_get_page_cgroup(page))
+			return 0;
+		memcg = lookup_memcg_from_swap(entry);
+	}
 
 	if (unlikely(!mm))
 		mm = &init_mm;
 
 	return mem_cgroup_charge_common(page, mm, gfp_mask,
-				MEM_CGROUP_CHARGE_TYPE_CACHE, NULL);
+				MEM_CGROUP_CHARGE_TYPE_CACHE, memcg);
 }
 
 /*
  * uncharge if !page_mapped(page)
  */
-static void
+static int
 __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 {
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem;
+	int ret = 0;
 
 	if (mem_cgroup_subsys.disabled)
-		return;
+		return 0;
 
 	/*
 	 * Check if our page_cgroup is valid
@@ -865,18 +1132,23 @@ __mem_cgroup_uncharge_common(struct page
 	VM_BUG_ON(pc->page != page);
 	VM_BUG_ON(page_cgroup_test_bit(pc, PAGE_CG_FLAG_OBSOLETE));
 
-	if ((ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
-	    && (page_cgroup_test_bit(pc, PAGE_CG_FLAG_CACHE)
-		|| page_mapped(page)))
+	if (likely(ctype != MEM_CGROUP_CHARGE_TYPE_FORCE))
+		if (PageSwapCache(page) || page_mapped(page) ||
+			(page->mapping && !PageAnon(page)))
 		goto out;
-
+	ret = 1;
 	mem = pc->mem_cgroup;
 	page_cgroup_set_bit(pc, PAGE_CG_FLAG_OBSOLETE);
 	page_assign_page_cgroup(page, NULL);
-	mem_counter_uncharge(mem, 1);
+
+	if (ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT) {
+		 /* swap is not accouned but drop swap-cache. */
+		mem_counter_recharge_swapout(mem);
+	 } else
+		mem_counter_uncharge(mem, 1);
 	mem_cgroup_drop_lru(pc);
 out:
-	return;
+	return ret;
 }
 
 void mem_cgroup_uncharge_page(struct page *page)
@@ -890,7 +1162,50 @@ void mem_cgroup_uncharge_cache_page(stru
 	VM_BUG_ON(page->mapping);
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE);
 }
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+/*
+ * This function is called from __delete_from_swap_cache.
+ * The function will be called under following case.
+ * 1. swap out memory by vmscan.
+ * 2. discard shmem's swp_entry at shmem's swap-in.
+ * 3. discard anonymous memory which was swap-cache.
+ */
+
+void mem_cgroup_uncharge_swap_cache(struct page *page, swp_entry_t entry)
+{
+	struct page_cgroup *pc;
+	struct swap_cgroup *sc;
+	enum charge_type ctype = MEM_CGROUP_CHARGE_TYPE_SWAPOUT;
+
+	sc = mem_cgroup_lookup_swap(entry);
+
+	BUG_ON(!sc);
+	BUG_ON(PageSwapCache(page));
+
+	if (swap_accounted(sc)) {
+		pc = page_get_page_cgroup(page);
+		if (pc) {
+			/* never reach here...just for debug */
+			printk("%d need to uncharge page ???", __LINE__);
+			ctype = MEM_CGROUP_CHARGE_TYPE_MAPPED;
+			__mem_cgroup_uncharge_common(page, ctype);
+		}
+		return;
+	}
+
+	if (__mem_cgroup_uncharge_common(page, ctype))
+		set_swap_accounted(sc);
+}
+
+/*
+ * Called when swap is freed.
+ */
+void mem_cgroup_uncharge_swap(swp_entry_t entry)
+{
+	swap_cgroup_delete_swap(entry);
+}
 
+#endif
 /*
  * Before starting migration, account against new page.
  */
@@ -1321,6 +1636,8 @@ mem_cgroup_create(struct cgroup_subsys *
 		if (alloc_mem_cgroup_per_zone_info(mem, node))
 			goto free_out;
 
+	spin_lock_init(&mem->swap_list_lock);
+	INIT_LIST_HEAD(&mem->swap_list);
 	return &mem->css;
 free_out:
 	for_each_node_state(node, N_POSSIBLE)
Index: linux-2.6.27-rc1-mm1/include/linux/swap.h
===================================================================
--- linux-2.6.27-rc1-mm1.orig/include/linux/swap.h
+++ linux-2.6.27-rc1-mm1/include/linux/swap.h
@@ -295,8 +295,8 @@ extern struct page *swapin_readahead(swp
 /* linux/mm/swapfile.c */
 extern long total_swap_pages;
 extern void si_swapinfo(struct sysinfo *);
-extern swp_entry_t get_swap_page(void);
-extern swp_entry_t get_swap_page_of_type(int);
+extern swp_entry_t get_swap_page(gfp_t);
+extern swp_entry_t get_swap_page_of_type(int, gfp_t);
 extern int swap_duplicate(swp_entry_t);
 extern int valid_swaphandles(swp_entry_t, unsigned long *);
 extern void swap_free(swp_entry_t);
@@ -332,6 +332,34 @@ static inline void disable_swap_token(vo
 	put_swap_token(swap_token_mm);
 }
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+extern int cgroup_precharge_swap_ent(swp_entry_t entry, gfp_t mask);
+/* All below functions never fail. */
+extern void cgroup_commit_swap_owner(struct page *page, swp_entry_t entry);
+extern void mem_cgroup_uncharge_swap_cache(struct page *page,
+		swp_entry_t entry);
+extern void mem_cgroup_uncharge_swap(swp_entry_t entry);
+
+#else
+
+static int cgroup_precharge_swap_ent(swp_entry_t entry, gfp_mask mask) {
+	return 0;
+}
+
+static void cgroup_commit_swap_owner(struct page *page, swp_entry_t entry)
+{
+}
+
+static void mem_cgroup_uncharge_swap_cache(struct page *page,
+		swp_entry_t entry)
+{
+}
+
+static void mem_cgroup_uncharge_swap(swp_entry_t entry)
+{
+}
+#endif /*  CONFIG_CGROUP_MEM_RES_CTLR_SWAP */
+
 #else /* CONFIG_SWAP */
 
 #define total_swap_pages			0
Index: linux-2.6.27-rc1-mm1/mm/swap_state.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/mm/swap_state.c
+++ linux-2.6.27-rc1-mm1/mm/swap_state.c
@@ -99,6 +99,8 @@ int add_to_swap_cache(struct page *page,
 			page_cache_release(page);
 		}
 	}
+	if (!error)
+		cgroup_commit_swap_owner(page, entry);
 	return error;
 }
 
@@ -108,14 +110,17 @@ int add_to_swap_cache(struct page *page,
  */
 void __delete_from_swap_cache(struct page *page)
 {
+	swp_entry_t entry = { .val = page_private(page) };
+
 	BUG_ON(!PageLocked(page));
 	BUG_ON(!PageSwapCache(page));
 	BUG_ON(PageWriteback(page));
 	BUG_ON(PagePrivate(page));
 
-	radix_tree_delete(&swapper_space.page_tree, page_private(page));
+	radix_tree_delete(&swapper_space.page_tree, entry.val);
 	set_page_private(page, 0);
 	ClearPageSwapCache(page);
+	mem_cgroup_uncharge_swap_cache(page, entry);
 	total_swapcache_pages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	INC_CACHE_INFO(del_total);
@@ -138,7 +143,7 @@ int add_to_swap(struct page * page, gfp_
 	BUG_ON(!PageUptodate(page));
 
 	for (;;) {
-		entry = get_swap_page();
+		entry = get_swap_page(gfp_mask);
 		if (!entry.val)
 			return 0;
 
Index: linux-2.6.27-rc1-mm1/mm/shmem.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/mm/shmem.c
+++ linux-2.6.27-rc1-mm1/mm/shmem.c
@@ -1023,7 +1023,7 @@ static int shmem_writepage(struct page *
 	 * want to check if there's a redundant swappage to be discarded.
 	 */
 	if (wbc->for_reclaim)
-		swap = get_swap_page();
+		swap = get_swap_page(GFP_ATOMIC);
 	else
 		swap.val = 0;
 
Index: linux-2.6.27-rc1-mm1/kernel/power/swsusp.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/kernel/power/swsusp.c
+++ linux-2.6.27-rc1-mm1/kernel/power/swsusp.c
@@ -127,7 +127,7 @@ sector_t alloc_swapdev_block(int swap)
 {
 	unsigned long offset;
 
-	offset = swp_offset(get_swap_page_of_type(swap));
+	offset = swp_offset(get_swap_page_of_type(swap), GFP_KERNEL);
 	if (offset) {
 		if (swsusp_extents_insert(offset))
 			swap_free(swp_entry(swap, offset));
Index: linux-2.6.27-rc1-mm1/mm/swapfile.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/mm/swapfile.c
+++ linux-2.6.27-rc1-mm1/mm/swapfile.c
@@ -173,7 +173,7 @@ no_page:
 	return 0;
 }
 
-swp_entry_t get_swap_page(void)
+swp_entry_t __get_swap_page(void)
 {
 	struct swap_info_struct *si;
 	pgoff_t offset;
@@ -214,7 +214,7 @@ noswap:
 	return (swp_entry_t) {0};
 }
 
-swp_entry_t get_swap_page_of_type(int type)
+swp_entry_t __get_swap_page_of_type(int type)
 {
 	struct swap_info_struct *si;
 	pgoff_t offset;
@@ -233,6 +233,48 @@ swp_entry_t get_swap_page_of_type(int ty
 	spin_unlock(&swap_lock);
 	return (swp_entry_t) {0};
 }
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+swp_entry_t get_swap_page(gfp_t mask)
+{
+	swp_entry_t ret;
+	int error;
+
+	ret = __get_swap_page();
+	if (!ret.val)
+		return (swp_entry_t){0};
+	error = cgroup_precharge_swap_ent(ret, mask);
+	if (error) {
+		swap_free(ret);
+		return (swp_entry_t){0};
+	}
+	return ret;
+}
+swp_entry_t get_swap_page_of_type(int type, gfp_t mask)
+{
+	swp_entry_t ret;
+	int error;
+
+	ret = __get_swap_page_of_type(type);
+	if (!ret.val)
+		return (swp_entry_t){0};
+
+	error = cgroup_precharge_swap_ent(ret, mask);
+	if (error) {
+		swap_free(ret);
+		return (swp_entry_t){0};
+	}
+	return ret;
+}
+#else
+swp_entry_t get_swap_page(gfp_t mask)
+{
+	return __get_swap_page();
+}
+swp_entry_t get_swap_page_of_type(int type, gfp_t mask)
+{
+	return __get_swap_page_of_type(type);
+}
+#endif
 
 static struct swap_info_struct * swap_info_get(swp_entry_t entry)
 {
@@ -270,8 +312,9 @@ out:
 	return NULL;
 }	
 
-static int swap_entry_free(struct swap_info_struct *p, unsigned long offset)
+static int swap_entry_free(struct swap_info_struct *p, swp_entry_t entry)
 {
+	unsigned long offset = swp_offset(entry);
 	int count = p->swap_map[offset];
 
 	if (count < SWAP_MAP_MAX) {
@@ -286,6 +329,7 @@ static int swap_entry_free(struct swap_i
 				swap_list.next = p - swap_info;
 			nr_swap_pages++;
 			p->inuse_pages--;
+			mem_cgroup_uncharge_swap(entry);
 		}
 	}
 	return count;
@@ -301,7 +345,7 @@ void swap_free(swp_entry_t entry)
 
 	p = swap_info_get(entry);
 	if (p) {
-		swap_entry_free(p, swp_offset(entry));
+		swap_entry_free(p, entry);
 		spin_unlock(&swap_lock);
 	}
 }
@@ -420,7 +464,7 @@ void free_swap_and_cache(swp_entry_t ent
 
 	p = swap_info_get(entry);
 	if (p) {
-		if (swap_entry_free(p, swp_offset(entry)) == 1) {
+		if (swap_entry_free(p, entry) == 1) {
 			page = find_get_page(&swapper_space, entry.val);
 			if (page && unlikely(TestSetPageLocked(page))) {
 				page_cache_release(page);
Index: linux-2.6.27-rc1-mm1/init/Kconfig
===================================================================
--- linux-2.6.27-rc1-mm1.orig/init/Kconfig
+++ linux-2.6.27-rc1-mm1/init/Kconfig
@@ -408,6 +408,18 @@ config CGROUP_MEM_RES_CTLR
 	  This config option also selects MM_OWNER config option, which
 	  could in turn add some fork/exit overhead.
 
+config CGROUP_MEM_RES_CTLR_SWAP
+	bool "Memory Resource Contoller Swap extention"
+	depends on CGROUP_MEM_RES_CTLR
+	help
+	  Provides resource accounting for swap. Enabling this, memory
+	  resource controller has 2 limit value. "limit" means the limit
+	  of amount of pages. "memsw_limit" means the limit for sum of
+	  amount of pages and amount of swaps. When you don't want to allow
+	  excessive use of swap under memory resource controller, enable this.
+	  But this extension will use some amount of memory for internal
+	  information  accounting and memory for the kernel will be consumed.
+
 config CGROUP_MEMRLIMIT_CTLR
 	bool "Memory resource limit controls for cgroups"
 	depends on CGROUPS && RESOURCE_COUNTERS && MMU

