Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbZBZHDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbZBZHDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 02:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZBZHDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 02:03:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54449 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbZBZHDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 02:03:40 -0500
Message-ID: <49A63EE0.3030406@cn.fujitsu.com>
Date: Thu, 26 Feb 2009 15:04:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] cpuset: avoid changing cpuset's mems when errno returned
References: <49A63E77.9060603@cn.fujitsu.com>
In-Reply-To: <49A63E77.9060603@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writing to cpuset.mems, cpuset has to update its mems_allowed before
calling update_tasks_nodemask(), but this function might return -ENOMEM.

To avoid this rare case, we allocate the memory before changing mems_allowed,
and then pass to update_tasks_nodemask(). Similar to what update_cpumask()
does.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 01a111f..3202364 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1057,13 +1057,15 @@ static void *cpuset_being_rebound;
  * update_tasks_nodemask - Update the nodemasks of tasks in the cpuset.
  * @cs: the cpuset in which each task's mems_allowed mask needs to be changed
  * @oldmem: old mems_allowed of cpuset cs
+ * @heap: if NULL, defer allocating heap memory to cgroup_scan_tasks()
  *
  * Called with cgroup_mutex held
- * Return 0 if successful, -errno if not.
+ * No return value. It's guaranteed that cgroup_scan_tasks() always returns 0
+ * if @heap != NULL.
  */
-static int update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem)
+static void update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem,
+				 struct ptr_heap *heap)
 {
-	int retval;
 	struct cgroup_scanner scan;
 
 	cpuset_being_rebound = cs;		/* causes mpol_dup() rebind */
@@ -1071,7 +1073,7 @@ static int update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem)
 	scan.cg = cs->css.cgroup;
 	scan.test_task = NULL;
 	scan.process_task = cpuset_change_nodemask;
-	scan.heap = NULL;
+	scan.heap = heap;
 	scan.data = (nodemask_t *)oldmem;
 
 	/*
@@ -1084,12 +1086,10 @@ static int update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem)
 	 * It's ok if we rebind the same mm twice; mpol_rebind_mm()
 	 * is idempotent.  Also migrate pages in each mm to new nodes.
 	 */
-	retval = cgroup_scan_tasks(&scan);
+	cgroup_scan_tasks(&scan);
 
 	/* We're done rebinding vmas to this cpuset's new mems_allowed. */
 	cpuset_being_rebound = NULL;
-
-	return retval;
 }
 
 /*
@@ -1110,6 +1110,7 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 {
 	nodemask_t oldmem;
 	int retval;
+	struct ptr_heap heap;
 
 	/*
 	 * top_cpuset.mems_allowed tracks node_stats[N_HIGH_MEMORY];
@@ -1144,12 +1145,18 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 	if (retval < 0)
 		goto done;
 
+	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
+	if (retval < 0)
+		goto done;
+
 	mutex_lock(&callback_mutex);
 	cs->mems_allowed = trialcs->mems_allowed;
 	cs->mems_generation = cpuset_mems_generation++;
 	mutex_unlock(&callback_mutex);
 
-	retval = update_tasks_nodemask(cs, &oldmem);
+	update_tasks_nodemask(cs, &oldmem, &heap);
+
+	heap_free(&heap);
 done:
 	return retval;
 }
@@ -2002,7 +2009,7 @@ static void scan_for_empty_cpusets(struct cpuset *root)
 			remove_tasks_in_empty_cpuset(cp);
 		else {
 			update_tasks_cpumask(cp, NULL);
-			update_tasks_nodemask(cp, &oldmems);
+			update_tasks_nodemask(cp, &oldmems, NULL);
 		}
 	}
 }
-- 1.5.4.rc3 
