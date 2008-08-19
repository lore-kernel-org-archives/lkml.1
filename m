Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbYHSIgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbYHSIgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbYHSIgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:36:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48215 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbYHSIgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:36:41 -0400
Date: Tue, 19 Aug 2008 17:42:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       ryov@valinux.co.jp
Subject: [PATCH -mm][preview] memcg: a patch series for next [6/9]
Message-Id: <20080819174248.1bc13b69.kamezawa.hiroyu@jp.fujitsu.com>
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

Experimental !!

This patch just removes lock_page_cgroup().
By RCU, it seems unnecessary....

Why it's safe without lock_page_cgroup().

Anon pages:
* pages are chareged/uncharged only when first-mapped/last-unmapped.
  page_mapcount() handles that.
   (at uncharge, pte_lock() is always held in racy case.)

Swap pages:
  About SwapCache, there will be race.
  mem_cgroup_charge() is moved under lock_page().

File pages: (not Shmem)
* pages are charged/uncharged only when it's added/removed to radix-tree.
  In this case, PageLock() is always held.

Install Page:
  Is it worth to charge driver's map page ? which is (maybe) not on LRU.
  Is it targe resource of memcg ? I think no.
  I removed charge/uncharge from install_page().

freeing page_cgroup is done under RCU.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 include/linux/mm_types.h |    2 -
 mm/memcontrol.c          |   86 ++++++-----------------------------------------
 mm/memory.c              |   17 +++------
 3 files changed, 19 insertions(+), 86 deletions(-)

Index: linux-2.6.27-rc1-mm1/include/linux/mm_types.h
===================================================================
--- linux-2.6.27-rc1-mm1.orig/include/linux/mm_types.h
+++ linux-2.6.27-rc1-mm1/include/linux/mm_types.h
@@ -93,7 +93,7 @@ struct page {
 					   not kmapped, ie. highmem) */
 #endif /* WANT_PAGE_VIRTUAL */
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
-	unsigned long page_cgroup;
+	struct page_cgroup *page_cgroup;
 #endif
 
 #ifdef CONFIG_KMEMCHECK
Index: linux-2.6.27-rc1-mm1/mm/memcontrol.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/mm/memcontrol.c
+++ linux-2.6.27-rc1-mm1/mm/memcontrol.c
@@ -145,20 +145,6 @@ struct mem_cgroup {
 static struct mem_cgroup init_mem_cgroup;
 
 /*
- * We use the lower bit of the page->page_cgroup pointer as a bit spin
- * lock.  We need to ensure that page->page_cgroup is at least two
- * byte aligned (based on comments from Nick Piggin).  But since
- * bit_spin_lock doesn't actually set that lock bit in a non-debug
- * uniprocessor kernel, we should avoid setting it here too.
- */
-#define PAGE_CGROUP_LOCK_BIT 	0x0
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-#define PAGE_CGROUP_LOCK 	(1 << PAGE_CGROUP_LOCK_BIT)
-#else
-#define PAGE_CGROUP_LOCK	0x0
-#endif
-
-/*
  * A page_cgroup page is associated with every page descriptor. The
  * page_cgroup helps us identify information about the cgroup
  */
@@ -308,35 +294,14 @@ struct mem_cgroup *mem_cgroup_from_task(
 				struct mem_cgroup, css);
 }
 
-static inline int page_cgroup_locked(struct page *page)
-{
-	return bit_spin_is_locked(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
-}
-
 static void page_assign_page_cgroup(struct page *page, struct page_cgroup *pc)
 {
-	VM_BUG_ON(!page_cgroup_locked(page));
-	page->page_cgroup = ((unsigned long)pc | PAGE_CGROUP_LOCK);
+	rcu_assign_pointer(page->page_cgroup, pc);
 }
 
 struct page_cgroup *page_get_page_cgroup(struct page *page)
 {
-	return (struct page_cgroup *) (page->page_cgroup & ~PAGE_CGROUP_LOCK);
-}
-
-static void lock_page_cgroup(struct page *page)
-{
-	bit_spin_lock(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
-}
-
-static int try_lock_page_cgroup(struct page *page)
-{
-	return bit_spin_trylock(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
-}
-
-static void unlock_page_cgroup(struct page *page)
-{
-	bit_spin_unlock(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
+	return rcu_dereference(page->page_cgroup);
 }
 
 /*
@@ -499,16 +464,7 @@ void mem_cgroup_move_lists(struct page *
 	if (mem_cgroup_subsys.disabled)
 		return;
 
-	/*
-	 * We cannot lock_page_cgroup while holding zone's lru_lock,
-	 * because other holders of lock_page_cgroup can be interrupted
-	 * with an attempt to rotate_reclaimable_page.  But we cannot
-	 * safely get to page_cgroup without it, so just try_lock it:
-	 * mem_cgroup_isolate_pages allows for page left on wrong list.
-	 */
-	if (!try_lock_page_cgroup(page))
-		return;
-
+	rcu_read_lock();
 	pc = page_get_page_cgroup(page);
 	if (pc) {
 		if (!page_cgroup_test_bit(pc, PAGE_CG_FLAG_OBSOLETE)) {
@@ -518,7 +474,7 @@ void mem_cgroup_move_lists(struct page *
 			spin_unlock_irqrestore(&mz->lru_lock, flags);
 		}
 	}
-	unlock_page_cgroup(page);
+	rcu_read_unlock();
 }
 
 /*
@@ -815,24 +771,13 @@ static int mem_cgroup_charge_common(stru
 	} else
 		__page_cgroup_set_bit(pc, PAGE_CG_FLAG_ACTIVE);
 
-	lock_page_cgroup(page);
-	if (unlikely(page_get_page_cgroup(page))) {
-		unlock_page_cgroup(page);
-		mem_counter_uncharge(mem, 1);
-		css_put(&mem->css);
-		kmem_cache_free(page_cgroup_cache, pc);
-		goto done;
-	}
+	VM_BUG_ON(page->page_cgroup);
 	page_assign_page_cgroup(page, pc);
-
 	mz = page_cgroup_zoneinfo(pc);
 	spin_lock_irqsave(&mz->lru_lock, flags);
 	__mem_cgroup_add_list(mz, pc);
 	spin_unlock_irqrestore(&mz->lru_lock, flags);
 
-	unlock_page_cgroup(page);
-
-done:
 	return 0;
 out:
 	css_put(&mem->css);
@@ -874,20 +819,17 @@ int mem_cgroup_cache_charge(struct page 
 	 *
 	 * For GFP_NOWAIT case, the page may be pre-charged before calling
 	 * add_to_page_cache(). (See shmem.c) check it here and avoid to call
-	 * charge twice. (It works but has to pay a bit larger cost.)
+	 * charge twice.
 	 */
 	if (!(gfp_mask & __GFP_WAIT)) {
 		struct page_cgroup *pc;
 
-		lock_page_cgroup(page);
 		pc = page_get_page_cgroup(page);
 		if (pc) {
 			VM_BUG_ON(pc->page != page);
 			VM_BUG_ON(!pc->mem_cgroup);
-			unlock_page_cgroup(page);
 			return 0;
 		}
-		unlock_page_cgroup(page);
 	}
 
 	if (unlikely(!mm))
@@ -912,29 +854,25 @@ __mem_cgroup_uncharge_common(struct page
 	/*
 	 * Check if our page_cgroup is valid
 	 */
-	lock_page_cgroup(page);
 	pc = page_get_page_cgroup(page);
 	if (unlikely(!pc))
-		goto unlock;
+		goto out;
 
 	VM_BUG_ON(pc->page != page);
+	VM_BUG_ON(page_cgroup_test_bit(pc, PAGE_CG_FLAG_OBSOLETE));
 
 	if ((ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
 	    && (page_cgroup_test_bit(pc, PAGE_CG_FLAG_CACHE)
 		|| page_mapped(page)))
-		goto unlock;
+		goto out;
 
 	mem = pc->mem_cgroup;
-	prefetch(mem);
 	page_cgroup_set_bit(pc, PAGE_CG_FLAG_OBSOLETE);
 	page_assign_page_cgroup(page, NULL);
-	unlock_page_cgroup(page);
 	mem_counter_uncharge(mem, 1);
 	mem_cgroup_drop_lru(pc);
-
+out:
 	return;
-unlock:
-	unlock_page_cgroup(page);
 }
 
 void mem_cgroup_uncharge_page(struct page *page)
@@ -962,7 +900,7 @@ int mem_cgroup_prepare_migration(struct 
 	if (mem_cgroup_subsys.disabled)
 		return 0;
 
-	lock_page_cgroup(page);
+	rcu_read_lock();
 	pc = page_get_page_cgroup(page);
 	if (pc) {
 		mem = pc->mem_cgroup;
@@ -970,7 +908,7 @@ int mem_cgroup_prepare_migration(struct 
 		if (page_cgroup_test_bit(pc, PAGE_CG_FLAG_CACHE))
 			ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	}
-	unlock_page_cgroup(page);
+	rcu_read_unlock();
 	if (mem) {
 		ret = mem_cgroup_charge_common(newpage, NULL, GFP_KERNEL,
 			ctype, mem);
Index: linux-2.6.27-rc1-mm1/mm/memory.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/mm/memory.c
+++ linux-2.6.27-rc1-mm1/mm/memory.c
@@ -1325,18 +1325,14 @@ static int insert_page(struct vm_area_st
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	retval = mem_cgroup_charge(page, mm, GFP_KERNEL);
-	if (retval)
-		goto out;
-
 	retval = -EINVAL;
 	if (PageAnon(page))
-		goto out_uncharge;
+		goto out;
 	retval = -ENOMEM;
 	flush_dcache_page(page);
 	pte = get_locked_pte(mm, addr, &ptl);
 	if (!pte)
-		goto out_uncharge;
+		goto out;
 	retval = -EBUSY;
 	if (!pte_none(*pte))
 		goto out_unlock;
@@ -1352,8 +1348,6 @@ static int insert_page(struct vm_area_st
 	return retval;
 out_unlock:
 	pte_unmap_unlock(pte, ptl);
-out_uncharge:
-	mem_cgroup_uncharge_page(page);
 out:
 	return retval;
 }
@@ -2328,15 +2322,16 @@ static int do_swap_page(struct mm_struct
 		count_vm_event(PGMAJFAULT);
 	}
 
+	lock_page(page);
+	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
+
 	if (mem_cgroup_charge(page, mm, GFP_KERNEL)) {
-		delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 		ret = VM_FAULT_OOM;
+		unlock_page(page);
 		goto out;
 	}
 
 	mark_page_accessed(page);
-	lock_page(page);
-	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 
 	/*
 	 * Back out if somebody else already faulted in this pte.

