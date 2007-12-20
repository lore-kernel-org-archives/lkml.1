Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbXLTSyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbXLTSyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbXLTSyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:54:24 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34663 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948AbXLTSyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:54:23 -0500
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 21 Dec 2007 00:23:58 +0530
Message-Id: <20071220185358.3248.25416.sendpatchset@balbir-laptop>
Subject: [RFC] [PATCH] Memory controller remove control_type feature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Based on the discussion at http://lkml.org/lkml/2007/12/20/383, it was
felt that control_type might not be a good thing to implement right away.
We can add this flexibility at a later point when required.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/linux/memcontrol.h |    6 --
 mm/memcontrol.c            |   91 ++++++++-------------------------------------
 2 files changed, 18 insertions(+), 79 deletions(-)

diff -puN mm/memcontrol.c~memory-controller-no-more-control-type mm/memcontrol.c
--- linux-2.6.24-rc5/mm/memcontrol.c~memory-controller-no-more-control-type	2007-12-20 22:37:17.000000000 +0530
+++ linux-2.6.24-rc5-balbir/mm/memcontrol.c	2007-12-20 23:50:47.000000000 +0530
@@ -131,7 +131,6 @@ struct mem_cgroup {
 	 */
 	struct mem_cgroup_lru_info info;
 
-	unsigned long control_type;	/* control RSS or RSS+Pagecache */
 	int	prev_priority;	/* for recording reclaim priority */
 	/*
 	 * statistics.
@@ -718,24 +717,17 @@ int mem_cgroup_cache_charge(struct page 
 				gfp_t gfp_mask)
 {
 	int ret = 0;
-	struct mem_cgroup *mem;
 	if (!mm)
 		mm = &init_mm;
 
-	rcu_read_lock();
-	mem = rcu_dereference(mm->mem_cgroup);
-	css_get(&mem->css);
-	rcu_read_unlock();
-	if (mem->control_type == MEM_CGROUP_TYPE_ALL)
-		ret = mem_cgroup_charge_common(page, mm, gfp_mask,
+	ret = mem_cgroup_charge_common(page, mm, gfp_mask,
 				MEM_CGROUP_CHARGE_TYPE_CACHE);
-	css_put(&mem->css);
 	return ret;
 }
 
 /*
  * Uncharging is always a welcome operation, we never complain, simply
- * uncharge.
+ * uncharge. This routine should be called with lock_page_cgroup held
  */
 void mem_cgroup_uncharge(struct page_cgroup *pc)
 {
@@ -745,8 +737,7 @@ void mem_cgroup_uncharge(struct page_cgr
 	unsigned long flags;
 
 	/*
-	 * This can handle cases when a page is not charged at all and we
-	 * are switching between handling the control_type.
+	 * Check if our page_cgroup is valid
 	 */
 	if (!pc)
 		return;
@@ -758,6 +749,7 @@ void mem_cgroup_uncharge(struct page_cgr
 		 * get page->cgroup and clear it under lock.
 		 * force_empty can drop page->cgroup without checking refcnt.
 		 */
+		unlock_page_cgroup(page);
 		if (clear_page_cgroup(page, pc) == pc) {
 			mem = pc->mem_cgroup;
 			css_put(&mem->css);
@@ -767,9 +759,17 @@ void mem_cgroup_uncharge(struct page_cgr
 			spin_unlock_irqrestore(&mz->lru_lock, flags);
 			kfree(pc);
 		}
+		lock_page_cgroup(page);
 	}
 }
 
+void mem_cgroup_uncharge_page(struct page *page)
+{
+	lock_page_cgroup(page);
+	mem_cgroup_uncharge(page_get_page_cgroup(page));
+	unlock_page_cgroup(page);
+}
+
 /*
  * Returns non-zero if a page (under migration) has valid page_cgroup member.
  * Refcnt of page_cgroup is incremented.
@@ -789,8 +789,12 @@ int mem_cgroup_prepare_migration(struct 
 
 void mem_cgroup_end_migration(struct page *page)
 {
-	struct page_cgroup *pc = page_get_page_cgroup(page);
+	struct page_cgroup *pc;
+
+	lock_page_cgroup(page);
+	pc = page_get_page_cgroup(page);
 	mem_cgroup_uncharge(pc);
+	unlock_page_cgroup(page);
 }
 /*
  * We know both *page* and *newpage* are now not-on-LRU and Pg_locked.
@@ -945,61 +949,6 @@ static ssize_t mem_cgroup_write(struct c
 				mem_cgroup_write_strategy);
 }
 
-static ssize_t mem_control_type_write(struct cgroup *cont,
-			struct cftype *cft, struct file *file,
-			const char __user *userbuf,
-			size_t nbytes, loff_t *pos)
-{
-	int ret;
-	char *buf, *end;
-	unsigned long tmp;
-	struct mem_cgroup *mem;
-
-	mem = mem_cgroup_from_cont(cont);
-	buf = kmalloc(nbytes + 1, GFP_KERNEL);
-	ret = -ENOMEM;
-	if (buf == NULL)
-		goto out;
-
-	buf[nbytes] = 0;
-	ret = -EFAULT;
-	if (copy_from_user(buf, userbuf, nbytes))
-		goto out_free;
-
-	ret = -EINVAL;
-	tmp = simple_strtoul(buf, &end, 10);
-	if (*end != '\0')
-		goto out_free;
-
-	if (tmp <= MEM_CGROUP_TYPE_UNSPEC || tmp >= MEM_CGROUP_TYPE_MAX)
-		goto out_free;
-
-	mem->control_type = tmp;
-	ret = nbytes;
-out_free:
-	kfree(buf);
-out:
-	return ret;
-}
-
-static ssize_t mem_control_type_read(struct cgroup *cont,
-				struct cftype *cft,
-				struct file *file, char __user *userbuf,
-				size_t nbytes, loff_t *ppos)
-{
-	unsigned long val;
-	char buf[64], *s;
-	struct mem_cgroup *mem;
-
-	mem = mem_cgroup_from_cont(cont);
-	s = buf;
-	val = mem->control_type;
-	s += sprintf(s, "%lu\n", val);
-	return simple_read_from_buffer((void __user *)userbuf, nbytes,
-			ppos, buf, s - buf);
-}
-
-
 static ssize_t mem_force_empty_write(struct cgroup *cont,
 				struct cftype *cft, struct file *file,
 				const char __user *userbuf,
@@ -1098,11 +1047,6 @@ static struct cftype mem_cgroup_files[] 
 		.read = mem_cgroup_read,
 	},
 	{
-		.name = "control_type",
-		.write = mem_control_type_write,
-		.read = mem_control_type_read,
-	},
-	{
 		.name = "force_empty",
 		.write = mem_force_empty_write,
 		.read = mem_force_empty_read,
@@ -1170,7 +1114,6 @@ mem_cgroup_create(struct cgroup_subsys *
 
 	res_counter_init(&mem->res);
 
-	mem->control_type = MEM_CGROUP_TYPE_ALL;
 	memset(&mem->info, 0, sizeof(mem->info));
 
 	for_each_node_state(node, N_POSSIBLE)
diff -puN include/linux/memcontrol.h~memory-controller-no-more-control-type include/linux/memcontrol.h
--- linux-2.6.24-rc5/include/linux/memcontrol.h~memory-controller-no-more-control-type	2007-12-20 22:37:17.000000000 +0530
+++ linux-2.6.24-rc5-balbir/include/linux/memcontrol.h	2007-12-20 22:40:00.000000000 +0530
@@ -35,6 +35,7 @@ extern struct page_cgroup *page_get_page
 extern int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask);
 extern void mem_cgroup_uncharge(struct page_cgroup *pc);
+extern void mem_cgroup_uncharge_page(struct page *page);
 extern void mem_cgroup_move_lists(struct page_cgroup *pc, bool active);
 extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
@@ -52,11 +53,6 @@ static inline struct mem_cgroup *mm_cgro
 	return rcu_dereference(mm->mem_cgroup);
 }
 
-static inline void mem_cgroup_uncharge_page(struct page *page)
-{
-	mem_cgroup_uncharge(page_get_page_cgroup(page));
-}
-
 extern int mem_cgroup_prepare_migration(struct page *page);
 extern void mem_cgroup_end_migration(struct page *page);
 extern void mem_cgroup_page_migration(struct page *page, struct page *newpage);
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
