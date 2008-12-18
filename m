Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752582AbYLRJAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbYLRJAA (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 04:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYLRI7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 03:59:51 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41617 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbYLRI7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 03:59:50 -0500
Date: Thu, 18 Dec 2008 17:58:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "menage@google.com" <menage@google.com>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: [PATCH 2/2] memcg: use css_tryget in memcg
Message-Id: <20081218175850.5bb55f3f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081218175403.40ad184a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081218175403.40ad184a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Use css_tryget() in memcg.
Based on cgroups-add-css_tryget.patch

css_tryget() newly is added and we can know css is alive or not and
get refcnt of css in very safe way.
("alive" here means "rmdir/destroy" is not called.)

This patch replaces css_get() to css_tryget(), where I cannot explain
why css_get() is safe. And removes memcg->obsolete flag.

Changelog (v0) -> (v1):
   - fixed css_ref leak bug at swap-in.

Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: mmotm-2.6.28-Dec17/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Dec17.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Dec17/mm/memcontrol.c
@@ -162,7 +162,6 @@ struct mem_cgroup {
 	 */
 	bool use_hierarchy;
 	unsigned long	last_oom_jiffies;
-	int		obsolete;
 	atomic_t	refcnt;
 
 	unsigned int	swappiness;
@@ -283,6 +282,31 @@ struct mem_cgroup *mem_cgroup_from_task(
 				struct mem_cgroup, css);
 }
 
+static struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
+{
+	struct mem_cgroup *mem = NULL;
+	/*
+	 * Because we have no locks, mm->owner's may be being moved to other
+	 * cgroup. We use css_tryget() here even if this looks
+	 * pessimistic (rather than adding locks here).
+	 */
+	rcu_read_lock();
+	do {
+		mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
+		if (unlikely(!mem))
+			break;
+	} while (!css_tryget(&mem->css));
+	rcu_read_unlock();
+	return mem;
+}
+
+static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
+{
+	if (!mem)
+		return true;
+	return css_is_removed(&mem->css);
+}
+
 /*
  * Following LRU functions are allowed to be used without PCG_LOCK.
  * Operations are called by routine of global LRU independently from memcg.
@@ -617,8 +641,9 @@ mem_cgroup_get_first_node(struct mem_cgr
 {
 	struct cgroup *cgroup;
 	struct mem_cgroup *ret;
-	bool obsolete = (root_mem->last_scanned_child &&
-				root_mem->last_scanned_child->obsolete);
+	bool obsolete;
+
+	obsolete = mem_cgroup_is_obsolete(root_mem->last_scanned_child);
 
 	/*
 	 * Scan all children under the mem_cgroup mem
@@ -706,7 +731,7 @@ static int mem_cgroup_hierarchical_recla
 	next_mem = mem_cgroup_get_first_node(root_mem);
 
 	while (next_mem != root_mem) {
-		if (next_mem->obsolete) {
+		if (mem_cgroup_is_obsolete(next_mem)) {
 			mem_cgroup_put(next_mem);
 			next_mem = mem_cgroup_get_first_node(root_mem);
 			continue;
@@ -762,23 +787,17 @@ static int __mem_cgroup_try_charge(struc
 	 * thread group leader migrates. It's possible that mm is not
 	 * set, if so charge the init_mm (happens for pagecache usage).
 	 */
-	if (likely(!*memcg)) {
-		rcu_read_lock();
-		mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
-		if (unlikely(!mem)) {
-			rcu_read_unlock();
-			return 0;
-		}
-		/*
-		 * For every charge from the cgroup, increment reference count
-		 */
-		css_get(&mem->css);
+	mem = *memcg;
+	if (likely(!mem)) {
+		mem = try_get_mem_cgroup_from_mm(mm);
 		*memcg = mem;
-		rcu_read_unlock();
 	} else {
-		mem = *memcg;
 		css_get(&mem->css);
 	}
+	if (unlikely(!mem))
+		return 0;
+
+	VM_BUG_ON(mem_cgroup_is_obsolete(mem));
 
 	while (1) {
 		int ret;
@@ -1065,12 +1084,19 @@ int mem_cgroup_cache_charge(struct page 
 				MEM_CGROUP_CHARGE_TYPE_SHMEM, NULL);
 }
 
+/*
+ * While swap-in, try_charge -> commit or cancel, the page is locked.
+ * And when try_charge() successfully returns, one refcnt to memcg without
+ * struct page_cgroup is aquired. This refcnt will be cumsumed by
+ * "commit()" or removed by "cancel()"
+ */
 int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 				 struct page *page,
 				 gfp_t mask, struct mem_cgroup **ptr)
 {
 	struct mem_cgroup *mem;
 	swp_entry_t     ent;
+	int ret;
 
 	if (mem_cgroup_disabled())
 		return 0;
@@ -1089,10 +1115,15 @@ int mem_cgroup_try_charge_swapin(struct 
 	ent.val = page_private(page);
 
 	mem = lookup_swap_cgroup(ent);
-	if (!mem || mem->obsolete)
+	if (!mem)
+		goto charge_cur_mm;
+	if (!css_tryget(&mem->css))
 		goto charge_cur_mm;
 	*ptr = mem;
-	return __mem_cgroup_try_charge(NULL, mask, ptr, true);
+	ret = __mem_cgroup_try_charge(NULL, mask, ptr, true);
+	/* drop extra refcnt from tryget */
+	css_put(&mem->css);
+	return ret;
 charge_cur_mm:
 	if (unlikely(!mm))
 		mm = &init_mm;
@@ -1123,13 +1154,18 @@ int mem_cgroup_cache_charge_swapin(struc
 		ent.val = page_private(page);
 		if (do_swap_account) {
 			mem = lookup_swap_cgroup(ent);
-			if (mem && mem->obsolete)
-				mem = NULL;
-			if (mem)
-				mm = NULL;
+			if (mem) {
+				if (css_tryget(&mem->css))
+					mm = NULL; /* charge to recorded */
+				else
+					mem = NULL; /* charge to current */
+			}
 		}
 		ret = mem_cgroup_charge_common(page, mm, mask,
 				MEM_CGROUP_CHARGE_TYPE_SHMEM, mem);
+		/* drop extra refcnt from tryget */
+		if (mem)
+			css_put(&mem->css);
 
 		if (!ret && do_swap_account) {
 			/* avoid double counting */
@@ -1171,7 +1207,6 @@ void mem_cgroup_commit_charge_swapin(str
 		struct mem_cgroup *memcg;
 		memcg = swap_cgroup_record(ent, NULL);
 		if (memcg) {
-			/* If memcg is obsolete, memcg can be != ptr */
 			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
 			mem_cgroup_put(memcg);
 		}
@@ -1414,14 +1449,9 @@ int mem_cgroup_shrink_usage(struct mm_st
 	if (!mm)
 		return 0;
 
-	rcu_read_lock();
-	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
-	if (unlikely(!mem)) {
-		rcu_read_unlock();
+	mem = try_get_mem_cgroup_from_mm(mm);
+	if (unlikely(!mem))
 		return 0;
-	}
-	css_get(&mem->css);
-	rcu_read_unlock();
 
 	do {
 		progress = mem_cgroup_hierarchical_reclaim(mem, gfp_mask, true);
@@ -2079,9 +2109,6 @@ static struct mem_cgroup *mem_cgroup_all
  * the number of reference from swap_cgroup and free mem_cgroup when
  * it goes down to 0.
  *
- * When mem_cgroup is destroyed, mem->obsolete will be set to 0 and
- * entry which points to this memcg will be ignore at swapin.
- *
  * Removal of cgroup itself succeeds regardless of refs from swap.
  */
 
@@ -2167,7 +2194,6 @@ static void mem_cgroup_pre_destroy(struc
 					struct cgroup *cont)
 {
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
-	mem->obsolete = 1;
 	mem_cgroup_force_empty(mem, false);
 }
 

