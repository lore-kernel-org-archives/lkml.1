Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbZF3JES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbZF3JES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 05:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZF3JEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 05:04:07 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60071 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbZF3JEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 05:04:05 -0400
Date: Tue, 30 Jun 2009 18:02:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>
Subject: [PATCH 1/2] fix cgroup rmdir hang v3
Message-Id: <20090630180234.c7e44c27.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090630180109.f137c10e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090630180109.f137c10e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

After commit: cgroup: fix frequent -EBUSY at rmdir
	      ec64f51545fffbc4cb968f0cea56341a4b07e85a
cgroup's rmdir (especially against memcg) doesn't return -EBUSY
by temporal ref counts. That commit expects all refs after pre_destroy()
is temporary but...it wasn't. Then, rmdir can wait permanently.
This patch tries to fix that and change followings.

 - set CGRP_WAIT_ON_RMDIR flag before pre_destroy().
 - clear CGRP_WAIT_ON_RMDIR flag when the subsys finds racy case.
   if there are sleeping ones, wakes them up.
 - rmdir() sleeps only when CGRP_WAIT_ON_RMDIR flag is set.

Changelog v3->v4:
  - rewrite/add comments.
  - rename cgroup_wakeup_rmdir_waiters() to cgroup_wakeup_rmdir_waiter().
Changelog v2->v3:
  - removed retry_rmdir() callback.
  - make use of CGRP_WAIT_ON_RMDIR flag more.

Tested-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reported-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/cgroup.h |   13 +++++++++++++
 kernel/cgroup.c        |   44 ++++++++++++++++++++++++++------------------
 mm/memcontrol.c        |   25 +++++++++++++++++++++++--
 3 files changed, 62 insertions(+), 20 deletions(-)

Index: mmotm-2.6.31-Jun25/include/linux/cgroup.h
===================================================================
--- mmotm-2.6.31-Jun25.orig/include/linux/cgroup.h
+++ mmotm-2.6.31-Jun25/include/linux/cgroup.h
@@ -366,6 +366,19 @@ int cgroup_task_count(const struct cgrou
 int cgroup_is_descendant(const struct cgroup *cgrp, struct task_struct *task);
 
 /*
+ * Allow to use CGRP_WAIT_ON_RMDIR flag to check race with rmdir() for subsys.
+ * Subsys can call this function if it's necessary to call pre_destroy() again
+ * because it adds not-temporary refs to css after or while pre_destroy().
+ * The caller of this function should use css_tryget(), too.
+ */
+void __cgroup_wakeup_rmdir_waiters(void);
+static inline void cgroup_wakeup_rmdir_waiter(struct cgroup *cgrp)
+{
+	if (unlikely(test_and_clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags)))
+		__cgroup_wakeup_rmdir_waiters();
+}
+
+/*
  * Control Group subsystem type.
  * See Documentation/cgroups/cgroups.txt for details
  */
Index: mmotm-2.6.31-Jun25/kernel/cgroup.c
===================================================================
--- mmotm-2.6.31-Jun25.orig/kernel/cgroup.c
+++ mmotm-2.6.31-Jun25/kernel/cgroup.c
@@ -734,14 +734,13 @@ static void cgroup_d_remove_dir(struct d
  * reference to css->refcnt. In general, this refcnt is expected to goes down
  * to zero, soon.
  *
- * CGRP_WAIT_ON_RMDIR flag is modified under cgroup's inode->i_mutex;
+ * CGRP_WAIT_ON_RMDIR flag is set under cgroup's inode->i_mutex;
  */
 DECLARE_WAIT_QUEUE_HEAD(cgroup_rmdir_waitq);
 
-static void cgroup_wakeup_rmdir_waiters(const struct cgroup *cgrp)
+void __cgroup_wakeup_rmdir_waiters(void)
 {
-	if (unlikely(test_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags)))
-		wake_up_all(&cgroup_rmdir_waitq);
+	wake_up_all(&cgroup_rmdir_waitq);
 }
 
 static int rebind_subsystems(struct cgroupfs_root *root,
@@ -1357,7 +1356,7 @@ int cgroup_attach_task(struct cgroup *cg
 	 * wake up rmdir() waiter. the rmdir should fail since the cgroup
 	 * is no longer empty.
 	 */
-	cgroup_wakeup_rmdir_waiters(cgrp);
+	cgroup_wakeup_rmdir_waiter(cgrp);
 	return 0;
 }
 
@@ -2696,33 +2695,42 @@ again:
 	mutex_unlock(&cgroup_mutex);
 
 	/*
+	 * In general, subsystem has no css->refcnt after pre_destroy(). But
+	 * in racy cases, subsystem may have to get css->refcnt after
+	 * pre_destroy() and it makes rmdir return with -EBUSY. This sometimes
+	 * make rmdir return -EBUSY too often. To avoid that, we use waitqueue
+	 * for cgroup's rmdir. CGRP_WAIT_ON_RMDIR is for synchronizing rmdir
+	 * and subsystem's reference count handling. Please see css_get/put
+	 * and css_tryget() and cgroup_wakeup_rmdir_waiter() implementation.
+	 */
+	set_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
+
+	/*
 	 * Call pre_destroy handlers of subsys. Notify subsystems
 	 * that rmdir() request comes.
 	 */
 	ret = cgroup_call_pre_destroy(cgrp);
-	if (ret)
+	if (ret) {
+		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
 		return ret;
+	}
 
 	mutex_lock(&cgroup_mutex);
 	parent = cgrp->parent;
 	if (atomic_read(&cgrp->count) || !list_empty(&cgrp->children)) {
+		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
 		mutex_unlock(&cgroup_mutex);
 		return -EBUSY;
 	}
-	/*
-	 * css_put/get is provided for subsys to grab refcnt to css. In typical
-	 * case, subsystem has no reference after pre_destroy(). But, under
-	 * hierarchy management, some *temporal* refcnt can be hold.
-	 * To avoid returning -EBUSY to a user, waitqueue is used. If subsys
-	 * is really busy, it should return -EBUSY at pre_destroy(). wake_up
-	 * is called when css_put() is called and refcnt goes down to 0.
-	 */
-	set_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
 	prepare_to_wait(&cgroup_rmdir_waitq, &wait, TASK_INTERRUPTIBLE);
-
 	if (!cgroup_clear_css_refs(cgrp)) {
 		mutex_unlock(&cgroup_mutex);
-		schedule();
+		/*
+		 * Because someone may call cgroup_wakeup_rmdir_waiter() before
+		 * prepare_to_wait(), we need to check this flag.
+		 */
+		if (test_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags))
+			schedule();
 		finish_wait(&cgroup_rmdir_waitq, &wait);
 		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
 		if (signal_pending(current))
@@ -3294,7 +3302,7 @@ void __css_put(struct cgroup_subsys_stat
 			set_bit(CGRP_RELEASABLE, &cgrp->flags);
 			check_for_release(cgrp);
 		}
-		cgroup_wakeup_rmdir_waiters(cgrp);
+		cgroup_wakeup_rmdir_waiter(cgrp);
 	}
 	rcu_read_unlock();
 }
Index: mmotm-2.6.31-Jun25/mm/memcontrol.c
===================================================================
--- mmotm-2.6.31-Jun25.orig/mm/memcontrol.c
+++ mmotm-2.6.31-Jun25/mm/memcontrol.c
@@ -1234,6 +1234,12 @@ static int mem_cgroup_move_account(struc
 	ret = 0;
 out:
 	unlock_page_cgroup(pc);
+	/*
+	 * We charges against "to" which may not have any tasks. Then, "to"
+	 * can be under rmdir(). But in current implementation, caller of
+	 * this function is just force_empty() and it's garanteed that
+	 * "to" is never removed. So, we don't check rmdir status here.
+	 */
 	return ret;
 }
 
@@ -1455,6 +1461,7 @@ __mem_cgroup_commit_charge_swapin(struct
 		return;
 	if (!ptr)
 		return;
+	css_get(&ptr->css);
 	pc = lookup_page_cgroup(page);
 	mem_cgroup_lru_del_before_commit_swapcache(page);
 	__mem_cgroup_commit_charge(ptr, pc, ctype);
@@ -1484,7 +1491,13 @@ __mem_cgroup_commit_charge_swapin(struct
 		}
 		rcu_read_unlock();
 	}
-	/* add this page(page_cgroup) to the LRU we want. */
+	/*
+	 * At swapin, we may charge account against cgroup which has no tasks.
+	 * So, rmdir()->pre_destroy() can be called while we do this charge.
+	 * In that case, we need to call pre_destroy() again. check it here.
+	 */
+	cgroup_wakeup_rmdir_waiter(ptr->css.cgroup);
+	css_put(&ptr->css);
 
 }
 
@@ -1691,7 +1704,7 @@ void mem_cgroup_end_migration(struct mem
 
 	if (!mem)
 		return;
-
+	css_get(&mem->css);
 	/* at migration success, oldpage->mapping is NULL. */
 	if (oldpage->mapping) {
 		target = oldpage;
@@ -1731,6 +1744,14 @@ void mem_cgroup_end_migration(struct mem
 	 */
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
 		mem_cgroup_uncharge_page(target);
+	/*
+	 * At migration, we may charge account against cgroup which has no tasks
+	 * So, rmdir()->pre_destroy() can be called while we do this charge.
+	 * In that case, we need to call pre_destroy() again. check it here.
+	 */
+	cgroup_wakeup_rmdir_waiter(mem->css.cgroup);
+	css_put(&mem->css);
+
 }
 
 /*

