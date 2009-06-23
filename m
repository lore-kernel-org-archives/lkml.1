Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbZFWHMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbZFWHMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZFWHLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:11:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57937 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbZFWHLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:11:52 -0400
Date: Tue, 23 Jun 2009 16:10:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 2/2] memcg: wakeup rmdir waiter if necessary
Message-Id: <20090623161019.503c1916.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090623160720.36230fa2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090623160720.36230fa2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

mem_cgroup's pre_destroy() handler tries to reduce its resource usage to 0.
But in some case, a charge comes after pre_destroy and rmdir() never finishes
because the caller of rmdir() sleeps.

This patch wakes up the caller of rmdir() and let it call pre_destroy(), again.

Note: Making pre_destroy() synchrounous is a way, but it will require
some synchronization...as global lock. A method this patch uses is
"do asynchronous and check if necessary". Maybe this works better than global
synchronization if properly commented.

Reported-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/cgroup.h |    7 +++++++
 kernel/cgroup.c        |    5 ++---
 mm/memcontrol.c        |   17 +++++++++++++++++
 3 files changed, 26 insertions(+), 3 deletions(-)

Index: fix-rmdir-cgroup/include/linux/cgroup.h
===================================================================
--- fix-rmdir-cgroup.orig/include/linux/cgroup.h
+++ fix-rmdir-cgroup/include/linux/cgroup.h
@@ -365,6 +365,13 @@ int cgroup_task_count(const struct cgrou
 /* Return true if cgrp is a descendant of the task's cgroup */
 int cgroup_is_descendant(const struct cgroup *cgrp, struct task_struct *task);
 
+void __cgroup_wakeup_rmdir_waiters(void);
+static inline void cgroup_wakeup_rmdir_waiters(const struct cgroup *cgrp)
+{
+	if (unlikely(test_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags)))
+		__cgroup_wakeup_rmdir_waiters();
+}
+
 /*
  * Control Group subsystem type.
  * See Documentation/cgroups/cgroups.txt for details
Index: fix-rmdir-cgroup/kernel/cgroup.c
===================================================================
--- fix-rmdir-cgroup.orig/kernel/cgroup.c
+++ fix-rmdir-cgroup/kernel/cgroup.c
@@ -755,10 +755,9 @@ static void cgroup_d_remove_dir(struct d
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
Index: fix-rmdir-cgroup/mm/memcontrol.c
===================================================================
--- fix-rmdir-cgroup.orig/mm/memcontrol.c
+++ fix-rmdir-cgroup/mm/memcontrol.c
@@ -1428,6 +1428,7 @@ __mem_cgroup_commit_charge_swapin(struct
 		return;
 	if (!ptr)
 		return;
+	css_get(&ptr->css);
 	pc = lookup_page_cgroup(page);
 	mem_cgroup_lru_del_before_commit_swapcache(page);
 	__mem_cgroup_commit_charge(ptr, pc, ctype);
@@ -1457,6 +1458,13 @@ __mem_cgroup_commit_charge_swapin(struct
 		}
 		rcu_read_unlock();
 	}
+	/*
+	 * At swapin, we may charge against cgroup which has no tasks. Such
+	 * cgroups can be removed by rmdir(). If we do charge after
+	 * pre_destroy(), we should call pre_destroy(), again.
+	 */
+	cgroup_wakeup_rmdir_waiters(ptr->css.cgroup);
+	css_put(&ptr->css);
 }
 
 void mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr)
@@ -1663,6 +1671,7 @@ void mem_cgroup_end_migration(struct mem
 	if (!mem)
 		return;
 
+	css_get(&mem->css);
 	/* at migration success, oldpage->mapping is NULL. */
 	if (oldpage->mapping) {
 		target = oldpage;
@@ -1702,6 +1711,14 @@ void mem_cgroup_end_migration(struct mem
 	 */
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
 		mem_cgroup_uncharge_page(target);
+
+	/*
+	 * At migration, we may charge against cgroup which has no tasks. Such
+	 * cgroups can be removed by rmdir(). If we do charge after
+	 * pre_destroy(), we should call pre_destroy(), again.
+	 */
+	cgroup_wakeup_rmdir_waiters(mem->css.cgroup);
+	css_put(&mem->css);
 }
 
 /*

