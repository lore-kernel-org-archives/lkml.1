Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbYICHfC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbYICHfC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 03:35:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYICHex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 03:34:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65045 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbYICHew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 03:34:52 -0400
Message-ID: <48BE3DE1.6030801@cn.fujitsu.com>
Date: Wed, 03 Sep 2008 15:33:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpuset: avoid changing cpuset's cpus when -errno returned
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the patch:

commit 0b2f630a28d53b5a2082a5275bc3334b10373508
Author: Miao Xie <miaox@cn.fujitsu.com>
Date:   Fri Jul 25 01:47:21 2008 -0700

    cpusets: restructure the function update_cpumask() and update_nodemask()

It might happen that 'echo 0 > /cpuset/sub/cpus' returns failure but 'cpus'
has been changed, because cpus was changed before calling heap_init() which
may return -ENOMEM.

This patch restores the orginal behavior.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |   32 ++++++++++++++------------------
 1 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index d5ab79c..817f8ac 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -774,36 +774,27 @@ static void cpuset_change_cpumask(struct task_struct *tsk,
 /**
  * update_tasks_cpumask - Update the cpumasks of tasks in the cpuset.
  * @cs: the cpuset in which each task's cpus_allowed mask needs to be changed
+ * @heap: if NULL, defer allocating heap memory to cgroup_scan_tasks()
  *
  * Called with cgroup_mutex held
  *
  * The cgroup_scan_tasks() function will scan all the tasks in a cgroup,
  * calling callback functions for each.
  *
- * Return 0 if successful, -errno if not.
+ * Always return 0 if @heap != NULL, may return -errno if @heap == NULL
  */
-static int update_tasks_cpumask(struct cpuset *cs)
+static int update_tasks_cpumask(struct cpuset *cs, struct ptr_heap *heap)
 {
 	struct cgroup_scanner scan;
-	struct ptr_heap heap;
 	int retval;
 
-	/*
-	 * cgroup_scan_tasks() will initialize heap->gt for us.
-	 * heap_init() is still needed here for we should not change
-	 * cs->cpus_allowed when heap_init() fails.
-	 */
-	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
-	if (retval)
-		return retval;
-
 	scan.cg = cs->css.cgroup;
 	scan.test_task = cpuset_test_cpumask;
 	scan.process_task = cpuset_change_cpumask;
-	scan.heap = &heap;
+	scan.heap = heap;
 	retval = cgroup_scan_tasks(&scan);
+	BUG_ON(heap != NULL && retval);
 
-	heap_free(&heap);
 	return retval;
 }
 
@@ -814,6 +805,7 @@ static int update_tasks_cpumask(struct cpuset *cs)
  */
 static int update_cpumask(struct cpuset *cs, const char *buf)
 {
+	struct ptr_heap heap;
 	struct cpuset trialcs;
 	int retval;
 	int is_load_balanced;
@@ -848,6 +840,10 @@ static int update_cpumask(struct cpuset *cs, const char *buf)
 	if (cpus_equal(cs->cpus_allowed, trialcs.cpus_allowed))
 		return 0;
 
+	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
+	if (retval)
+		return retval;
+
 	is_load_balanced = is_sched_load_balance(&trialcs);
 
 	mutex_lock(&callback_mutex);
@@ -858,9 +854,9 @@ static int update_cpumask(struct cpuset *cs, const char *buf)
 	 * Scan tasks in the cpuset, and update the cpumasks of any
 	 * that need an update.
 	 */
-	retval = update_tasks_cpumask(cs);
-	if (retval < 0)
-		return retval;
+	update_tasks_cpumask(cs, &heap);
+
+	heap_free(&heap);
 
 	if (is_load_balanced)
 		rebuild_sched_domains();
@@ -1896,7 +1892,7 @@ static void scan_for_empty_cpusets(const struct cpuset *root)
 		     nodes_empty(cp->mems_allowed))
 			remove_tasks_in_empty_cpuset(cp);
 		else {
-			update_tasks_cpumask(cp);
+			update_tasks_cpumask(cp, NULL);
 			update_tasks_nodemask(cp, &oldmems);
 		}
 	}
-- 
1.5.4.rc3


