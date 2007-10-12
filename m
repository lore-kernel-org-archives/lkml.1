Return-Path: <linux-kernel-owner+w=401wt.eu-S1760290AbXJLHfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbXJLHfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 03:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758551AbXJLHfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 03:35:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41533 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbXJLHfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 03:35:18 -0400
Date: Fri, 12 Oct 2007 16:37:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: [BUGFIX][PATCH][ for -mm] bugfix for memory cgroup controller [3/5]
 add helper function for assigning cgroup to page
Message-Id: <20071012163725.59825017.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071012163412.2f1ca1ea.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071012163412.2f1ca1ea.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds following functions.
   - clear_page_cgroup(page, pc)
   - page_cgroup_assign_new_page_group(page, pc)

Mainly for cleanup.

A manner "check page->cgroup again after lock_page_cgroup()" is
implemented in straight way.

Chnagelog v2 -> v3:
  * adjusted to 2.6.23-mm1
Changelog v1 -> v2:
  * added necessary comments.

Note:
  - a comment in mem_cgroup_uncharge() will be removed by force-empty patch

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



 mm/memcontrol.c |  100 ++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 73 insertions(+), 27 deletions(-)

Index: devel-2.6.23-mm1/mm/memcontrol.c
===================================================================
--- devel-2.6.23-mm1.orig/mm/memcontrol.c
+++ devel-2.6.23-mm1/mm/memcontrol.c
@@ -162,6 +162,48 @@ static void __always_inline unlock_page_
 	bit_spin_unlock(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
 }
 
+/*
+ * Tie new page_cgroup to struct page under lock_page_cgroup()
+ * This can fail if the page has been tied to a page_cgroup.
+ * If success, returns 0.
+ */
+static inline int
+page_cgroup_assign_new_page_cgroup(struct page *page, struct page_cgroup *pc)
+{
+	int ret = 0;
+
+	lock_page_cgroup(page);
+	if (!page_get_page_cgroup(page))
+		page_assign_page_cgroup(page, pc);
+	else /* A page is tied to other pc. */
+		ret = 1;
+	unlock_page_cgroup(page);
+	return ret;
+}
+
+/*
+ * Clear page->page_cgroup member under lock_page_cgroup().
+ * If given "pc" value is different from one page->page_cgroup,
+ * page->cgroup is not cleared.
+ * Returns a value of page->page_cgroup at lock taken.
+ * A can can detect failure of clearing by following
+ *  clear_page_cgroup(page, pc) == pc
+ */
+
+static inline struct page_cgroup *
+clear_page_cgroup(struct page *page, struct page_cgroup *pc)
+{
+	struct page_cgroup *ret;
+	/* lock and clear */
+	lock_page_cgroup(page);
+	ret = page_get_page_cgroup(page);
+	if (likely(ret == pc))
+		page_assign_page_cgroup(page, NULL);
+	unlock_page_cgroup(page);
+	return ret;
+}
+
+
 static void __mem_cgroup_move_lists(struct page_cgroup *pc, bool active)
 {
 	if (active)
@@ -270,7 +312,7 @@ int mem_cgroup_charge(struct page *page,
 				gfp_t gfp_mask)
 {
 	struct mem_cgroup *mem;
-	struct page_cgroup *pc, *race_pc;
+	struct page_cgroup *pc;
 	unsigned long flags;
 	unsigned long nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 
@@ -364,24 +406,20 @@ noreclaim:
 		goto free_pc;
 	}
 
-	lock_page_cgroup(page);
-	/*
-	 * Check if somebody else beat us to allocating the page_cgroup
-	 */
-	race_pc = page_get_page_cgroup(page);
-	if (race_pc) {
-		kfree(pc);
-		pc = race_pc;
-		atomic_inc(&pc->ref_cnt);
-		res_counter_uncharge(&mem->res, PAGE_SIZE);
-		css_put(&mem->css);
-		goto done;
-	}
-
 	atomic_set(&pc->ref_cnt, 1);
 	pc->mem_cgroup = mem;
 	pc->page = page;
-	page_assign_page_cgroup(page, pc);
+	if (page_cgroup_assign_new_page_cgroup(page, pc)) {
+		/*
+		 * an another charge is added to this page already.
+		 * we do take lock_page_cgroup(page) again and read
+		 * page->cgroup, increment refcnt.... just retry is OK.
+		 */
+		res_counter_uncharge(&mem->res, PAGE_SIZE);
+		css_put(&mem->css);
+		kfree(pc);
+		goto retry;
+	}
 
 	spin_lock_irqsave(&mem->lru_lock, flags);
 	list_add(&pc->lru, &mem->active_list);
@@ -432,17 +470,25 @@ void mem_cgroup_uncharge(struct page_cgr
 
 	if (atomic_dec_and_test(&pc->ref_cnt)) {
 		page = pc->page;
-		lock_page_cgroup(page);
-		mem = pc->mem_cgroup;
-		css_put(&mem->css);
-		page_assign_page_cgroup(page, NULL);
-		unlock_page_cgroup(page);
-		res_counter_uncharge(&mem->res, PAGE_SIZE);
-
- 		spin_lock_irqsave(&mem->lru_lock, flags);
- 		list_del_init(&pc->lru);
- 		spin_unlock_irqrestore(&mem->lru_lock, flags);
-		kfree(pc);
+		/*
+		 * get page->cgroup and clear it under lock.
+		 */
+		if (clear_page_cgroup(page, pc) == pc) {
+			mem = pc->mem_cgroup;
+			css_put(&mem->css);
+			res_counter_uncharge(&mem->res, PAGE_SIZE);
+			spin_lock_irqsave(&mem->lru_lock, flags);
+			list_del_init(&pc->lru);
+			spin_unlock_irqrestore(&mem->lru_lock, flags);
+			kfree(pc);
+		} else {
+			/*
+			 * Note:This will be removed when force-empty patch is
+			 * applied. just show warning here.
+			 */
+			printk(KERN_ERR "Race in mem_cgroup_uncharge() ?");
+			dump_stack();
+		}
 	}
 }
 

