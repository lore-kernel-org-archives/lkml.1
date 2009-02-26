Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbZBZHDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbZBZHDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 02:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbZBZHDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 02:03:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55758 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbZBZHDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 02:03:15 -0500
Message-ID: <49A63EC7.2000702@cn.fujitsu.com>
Date: Thu, 26 Feb 2009 15:03:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] cpuset: rewrite update_tasks_nodemask()
References: <49A63E77.9060603@cn.fujitsu.com>
In-Reply-To: <49A63E77.9060603@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses cgroup_scan_tasks() to rebind tasks' vmas to new cpuset's
mems_allowed.

Not only simplify the code largely, but also avoid allocating an array
to hold mm pointers of all the tasks in the cpuset. This array can be big
(size > PAGESIZE) if we have lots of tasks in that cpuset, thus has a
chance to fail the allocation when under memory stress.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |  109 ++++++++++++++++++++-----------------------------------
 1 files changed, 39 insertions(+), 70 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 20c2db2..01a111f 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1026,6 +1026,31 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
 	mutex_unlock(&callback_mutex);
 }
 
+/*
+ * Rebind task's vmas to cpuset's new mems_allowed, and migrate pages to new
+ * nodes if memory_migrate flag is set. Called with cgroup_mutex held.
+ */
+static void cpuset_change_nodemask(struct task_struct *p,
+				   struct cgroup_scanner *scan)
+{
+	struct mm_struct *mm;
+	struct cpuset *cs;
+	int migrate;
+	const nodemask_t *oldmem = scan->data;
+
+	mm = get_task_mm(p);
+	if (!mm)
+		return;
+
+	cs = cgroup_cs(scan->cg);
+	migrate = is_memory_migrate(cs);
+
+	mpol_rebind_mm(mm, &cs->mems_allowed);
+	if (migrate)
+		cpuset_migrate_mm(mm, oldmem, &cs->mems_allowed);
+	mmput(mm);
+}
+
 static void *cpuset_being_rebound;
 
 /**
@@ -1038,88 +1063,32 @@ static void *cpuset_being_rebound;
  */
 static int update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem)
 {
-	struct task_struct *p;
-	struct mm_struct **mmarray;
-	int i, n, ntasks;
-	int migrate;
-	int fudge;
-	struct cgroup_iter it;
 	int retval;
+	struct cgroup_scanner scan;
 
 	cpuset_being_rebound = cs;		/* causes mpol_dup() rebind */
 
-	fudge = 10;				/* spare mmarray[] slots */
-	fudge += cpumask_weight(cs->cpus_allowed);/* imagine 1 fork-bomb/cpu */
-	retval = -ENOMEM;
-
-	/*
-	 * Allocate mmarray[] to hold mm reference for each task
-	 * in cpuset cs.  Can't kmalloc GFP_KERNEL while holding
-	 * tasklist_lock.  We could use GFP_ATOMIC, but with a
-	 * few more lines of code, we can retry until we get a big
-	 * enough mmarray[] w/o using GFP_ATOMIC.
-	 */
-	while (1) {
-		ntasks = cgroup_task_count(cs->css.cgroup);  /* guess */
-		ntasks += fudge;
-		mmarray = kmalloc(ntasks * sizeof(*mmarray), GFP_KERNEL);
-		if (!mmarray)
-			goto done;
-		read_lock(&tasklist_lock);		/* block fork */
-		if (cgroup_task_count(cs->css.cgroup) <= ntasks)
-			break;				/* got enough */
-		read_unlock(&tasklist_lock);		/* try again */
-		kfree(mmarray);
-	}
-
-	n = 0;
-
-	/* Load up mmarray[] with mm reference for each task in cpuset. */
-	cgroup_iter_start(cs->css.cgroup, &it);
-	while ((p = cgroup_iter_next(cs->css.cgroup, &it))) {
-		struct mm_struct *mm;
-
-		if (n >= ntasks) {
-			printk(KERN_WARNING
-				"Cpuset mempolicy rebind incomplete.\n");
-			break;
-		}
-		mm = get_task_mm(p);
-		if (!mm)
-			continue;
-		mmarray[n++] = mm;
-	}
-	cgroup_iter_end(cs->css.cgroup, &it);
-	read_unlock(&tasklist_lock);
+	scan.cg = cs->css.cgroup;
+	scan.test_task = NULL;
+	scan.process_task = cpuset_change_nodemask;
+	scan.heap = NULL;
+	scan.data = (nodemask_t *)oldmem;
 
 	/*
-	 * Now that we've dropped the tasklist spinlock, we can
-	 * rebind the vma mempolicies of each mm in mmarray[] to their
-	 * new cpuset, and release that mm.  The mpol_rebind_mm()
-	 * call takes mmap_sem, which we couldn't take while holding
-	 * tasklist_lock.  Forks can happen again now - the mpol_dup()
-	 * cpuset_being_rebound check will catch such forks, and rebind
-	 * their vma mempolicies too.  Because we still hold the global
-	 * cgroup_mutex, we know that no other rebind effort will
-	 * be contending for the global variable cpuset_being_rebound.
+	 * The mpol_rebind_mm() call takes mmap_sem, which we couldn't
+	 * take while holding tasklist_lock.  Forks can happen - the
+	 * mpol_dup() cpuset_being_rebound check will catch such forks,
+	 * and rebind their vma mempolicies too.  Because we still hold
+	 * the global cgroup_mutex, we know that no other rebind effort
+	 * will be contending for the global variable cpuset_being_rebound.
 	 * It's ok if we rebind the same mm twice; mpol_rebind_mm()
 	 * is idempotent.  Also migrate pages in each mm to new nodes.
 	 */
-	migrate = is_memory_migrate(cs);
-	for (i = 0; i < n; i++) {
-		struct mm_struct *mm = mmarray[i];
-
-		mpol_rebind_mm(mm, &cs->mems_allowed);
-		if (migrate)
-			cpuset_migrate_mm(mm, oldmem, &cs->mems_allowed);
-		mmput(mm);
-	}
+	retval = cgroup_scan_tasks(&scan);
 
 	/* We're done rebinding vmas to this cpuset's new mems_allowed. */
-	kfree(mmarray);
 	cpuset_being_rebound = NULL;
-	retval = 0;
-done:
+
 	return retval;
 }
 
-- 1.5.4.rc3 
