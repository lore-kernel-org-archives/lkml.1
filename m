Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbXCUOoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbXCUOoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 10:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbXCUOoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 10:44:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38399 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752930AbXCUOoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 10:44:37 -0400
Date: Wed, 21 Mar 2007 09:43:59 -0600
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] hotplug cpu: move tasks in empty cpusets to parent
Message-ID: <460152BF.mailxTH118POA@eag09.americas.sgi.com>
User-Agent: nail 11.4 8/29/04
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: cpw@sgi.com (Cliff Wickman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Submission #2: after style changes recommended by Randy Dunlap


This patch corrects a situation that occurs when one disables all the cpus
in a cpuset.

At that point, any tasks in that cpuset are incorrectly moved.
(Disabling all cpus in a cpuset caused it to inherit the cpus
 of its parent, which may overlap its exclusive sibling.)

Such tasks should be moved to the parent of their current cpuset. Or if the
parent cpuset has no cpus, to its parent, etc.

And the empty cpuset should be removed (if it is flagged notify_on_release).

This patch contains the added complexity of taking care not to do memory
allocation while holding the cpusets callback_mutex. And it makes use of the
"cpuset_release_agent" to do the cpuset removals.

It might be simpler to use a separate thread or workqueue. But such code
has not yet been written.

Diffed against 2.6.20-rc6

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 kernel/cpuset.c |  200 ++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 180 insertions(+), 20 deletions(-)

Index: morton.070205/kernel/cpuset.c
===================================================================
--- morton.070205.orig/kernel/cpuset.c
+++ morton.070205/kernel/cpuset.c
@@ -112,6 +112,12 @@ typedef enum {
 	CS_SPREAD_SLAB,
 } cpuset_flagbits_t;
 
+struct path_list_element {
+	struct list_head list;
+	struct cpuset *cs;
+	char *path;
+};
+
 /* convenient tests for these bits */
 static inline int is_cpu_exclusive(const struct cpuset *cs)
 {
@@ -498,7 +504,7 @@ static int cpuset_path(const struct cpus
  * the time manage_mutex is held.
  */
 
-static void cpuset_release_agent(const char *pathbuf)
+static void cpuset_release_agent(const char *pathbuf, int releasepath)
 {
 	char *argv[3], *envp[3];
 	int i;
@@ -518,7 +524,8 @@ static void cpuset_release_agent(const c
 	envp[i] = NULL;
 
 	call_usermodehelper(argv[0], argv, envp, 0);
-	kfree(pathbuf);
+	if (releasepath)
+		kfree(pathbuf);
 }
 
 /*
@@ -1364,7 +1371,7 @@ static ssize_t cpuset_common_file_write(
 		retval = nbytes;
 out2:
 	mutex_unlock(&manage_mutex);
-	cpuset_release_agent(pathbuf);
+	cpuset_release_agent(pathbuf, 1);
 out1:
 	kfree(buffer);
 	return retval;
@@ -1990,7 +1997,7 @@ static int cpuset_rmdir(struct inode *un
 	if (list_empty(&parent->children))
 		check_for_release(parent, &pathbuf);
 	mutex_unlock(&manage_mutex);
-	cpuset_release_agent(pathbuf);
+	cpuset_release_agent(pathbuf, 1);
 	return 0;
 }
 
@@ -2053,13 +2060,33 @@ out:
 }
 
 /*
+ * move every task that is a member of cpuset "from" to cpuset "to"
+ */
+static void move_member_tasks_to_cpuset(struct cpuset *from, struct cpuset *to)
+{
+	int moved=0;
+	struct task_struct *g, *tsk;
+
+	read_lock(&tasklist_lock);
+	do_each_thread(g, tsk) {
+		if (tsk->cpuset == from) {
+			moved++;
+			task_lock(tsk);
+			tsk->cpuset = to;
+			task_unlock(tsk);
+		}
+	} while_each_thread(g, tsk);
+	read_unlock(&tasklist_lock);
+	atomic_add(moved, &to->count);
+	atomic_set(&from->count, 0);
+}
+
+/*
  * If common_cpu_mem_hotplug_unplug(), below, unplugs any CPUs
  * or memory nodes, we need to walk over the cpuset hierarchy,
  * removing that CPU or node from all cpusets.  If this removes the
- * last CPU or node from a cpuset, then the guarantee_online_cpus()
- * or guarantee_online_mems() code will use that emptied cpusets
- * parent online CPUs or nodes.  Cpusets that were already empty of
- * CPUs or nodes are left empty.
+ * last CPU or node from a cpuset, then move the tasks in the empty cpuset
+ * to its next-highest non-empty parent.  And remove the empty cpuset.
  *
  * This routine is intentionally inefficient in a couple of regards.
  * It will check all cpusets in a subtree even if the top cpuset of
@@ -2070,20 +2097,104 @@ out:
  *
  * Call with both manage_mutex and callback_mutex held.
  *
+ * Takes tasklist_lock, and task_lock() for cpuset members that are
+ * moved to another cpuset.
+ *
+ * Recursive, on depth of cpuset subtree.
+ */
+
+static void remove_tasks_in_empty_cpusets_in_subtree(
+				const struct cpuset *cur,
+				struct list_head *empty_list,
+				struct path_list_element **ple_array,
+				int *ple_availp, int ple_count)
+{
+	int npids, ple_used=0;
+	struct cpuset *c, *parent;
+	struct path_list_element *ple;
+
+	/* If a cpuset's mems or cpus are empty, move its tasks to its parent */
+	list_for_each_entry(c, &cur->children, sibling) {
+		remove_tasks_in_empty_cpusets_in_subtree(c, empty_list,
+					ple_array, ple_availp, ple_count);
+		/*
+		 * If it has no online cpus or no online mems, move its tasks
+		 * to its next-highest non-empty parent and remove it.
+		 * Remove it even if it has children, as its children are a
+		 * subset of cpus and nodes, so they are empty too.
+		 * The removal is conditional on whether it is
+		 * notify-on-release.
+		 */
+		if (cpus_empty(c->cpus_allowed) ||
+		   nodes_empty(c->mems_allowed)) {
+			char *path = NULL;
+			/*
+			 * Find its next-highest non-empty parent, (top cpuset
+			 * has online cpus, so can't be empty).
+			 */
+			parent = c->parent;
+			while (parent && cpus_empty(parent->cpus_allowed))
+				parent = parent->parent;
+			npids = atomic_read(&c->count);
+			/* c->count is the number of tasks using the cpuset */
+			if (npids)
+				/* move member tasks to the parent cpuset */
+				move_member_tasks_to_cpuset(c, parent);
+
+			/*
+			 * sanity check that we're not over-running
+			 * the array
+			 */
+			if (++ple_used > ple_count)
+				return;
+			ple = ple_array[(*ple_availp)++];
+			path = (char *)ple + sizeof(struct path_list_element);
+			if (cpuset_path(c, path,
+				PAGE_SIZE-sizeof(struct path_list_element)) < 0)
+				path = NULL;
+			if (path != NULL) {
+				/*
+				 * add path to list of cpusets to remove
+				 * (list includes cpusets that are not
+				 *  notify-on-release)
+				 */
+				ple->path = path;
+				ple->cs = c;
+				/*
+				 * since we're walking "up" the tree, list
+				 * any empty cpusets we find on the tail of
+				 * the list (later==higher; start with lower)
+				 */
+				list_add_tail(&ple->list, empty_list);
+			}
+		}
+	}
+}
+
+/*
+ * Walk the specified cpuset subtree and remove any offline cpus from
+ * each cpuset.
+ *
+ * Count the number of empty cpusets.
+ *
+ * Call with both manage_mutex and callback_mutex held so
+ * that this function can modify cpus_allowed and mems_allowed.
+ *
  * Recursive, on depth of cpuset subtree.
  */
 
-static void guarantee_online_cpus_mems_in_subtree(const struct cpuset *cur)
+static void remove_offlines_count_emptys(const struct cpuset *cur, int *count)
 {
 	struct cpuset *c;
 
-	/* Each of our child cpusets mems must be online */
 	list_for_each_entry(c, &cur->children, sibling) {
-		guarantee_online_cpus_mems_in_subtree(c);
-		if (!cpus_empty(c->cpus_allowed))
-			guarantee_online_cpus(c, &c->cpus_allowed);
-		if (!nodes_empty(c->mems_allowed))
-			guarantee_online_mems(c, &c->mems_allowed);
+		remove_offlines_count_emptys(c, count);
+		/* Remove offline cpus and mems from this cpuset. */
+		cpus_and(c->cpus_allowed, c->cpus_allowed, cpu_online_map);
+		nodes_and(c->mems_allowed, c->mems_allowed, node_online_map);
+		if (cpus_empty(c->cpus_allowed) ||
+		   nodes_empty(c->mems_allowed))
+			(*count)++;
 	}
 }
 
@@ -2095,7 +2206,7 @@ static void guarantee_online_cpus_mems_i
  * To ensure that we don't remove a CPU or node from the top cpuset
  * that is currently in use by a child cpuset (which would violate
  * the rule that cpusets must be subsets of their parent), we first
- * call the recursive routine guarantee_online_cpus_mems_in_subtree().
+ * call the recursive routine remove_tasks_in_empty_cpusets_in_subtree().
  *
  * Since there are two callers of this routine, one for CPU hotplug
  * events and one for memory node hotplug events, we could have coded
@@ -2105,15 +2216,64 @@ static void guarantee_online_cpus_mems_i
 
 static void common_cpu_mem_hotplug_unplug(void)
 {
+	int i, empty_count=0, ple_avail=0;
+	struct list_head empty_cpuset_list;
+	struct path_list_element *ple, **ple_array=NULL;
+
 	mutex_lock(&manage_mutex);
-	mutex_lock(&callback_mutex);
 
-	guarantee_online_cpus_mems_in_subtree(&top_cpuset);
+	mutex_lock(&callback_mutex);
 	top_cpuset.cpus_allowed = cpu_online_map;
 	top_cpuset.mems_allowed = node_online_map;
-
+	remove_offlines_count_emptys(&top_cpuset, &empty_count);
 	mutex_unlock(&callback_mutex);
+
+	if (empty_count) {
+		/*
+		 * allocate the control structures needed for a list of
+		 * cpuset paths to free. (allocation must be done without
+		 * holding callback_mutex)
+		 */
+		ple_array = kmalloc
+		   (empty_count*sizeof(struct empty_cpuset_list *), GFP_KERNEL);
+		if (!ple_array)
+			return;
+		for (i = 0; i < empty_count; i++) {
+			ple = kmalloc(PAGE_SIZE, GFP_KERNEL);
+			/*
+			 * the space for the path itself immediately follows
+			 * the path_list_element structure (we have a full page)
+			 */
+			if (!ple)
+				return;
+			ple_array[i]= ple;
+		}
+		INIT_LIST_HEAD(&empty_cpuset_list);
+
+		mutex_lock(&callback_mutex);
+		remove_tasks_in_empty_cpusets_in_subtree(&top_cpuset,
+			&empty_cpuset_list, ple_array, &ple_avail, empty_count);
+		mutex_unlock(&callback_mutex);
+	}
+
 	mutex_unlock(&manage_mutex);
+
+	if (empty_count) {
+		/*
+		 * Free each cpuset on the list.
+		 * (but only if it is notify-on-release)
+		 */
+		list_for_each_entry(ple, &empty_cpuset_list, list) {
+			if (notify_on_release(ple->cs))
+				cpuset_release_agent(ple->path, 0);
+		}
+		/* remove the control structures */
+		for (i = 0; i < empty_count; i++) {
+			kfree(ple_array[i]);
+		}
+		kfree(ple_array);
+	}
+	return;
 }
 
 /*
@@ -2259,7 +2419,7 @@ void cpuset_exit(struct task_struct *tsk
 		if (atomic_dec_and_test(&cs->count))
 			check_for_release(cs, &pathbuf);
 		mutex_unlock(&manage_mutex);
-		cpuset_release_agent(pathbuf);
+		cpuset_release_agent(pathbuf, 1);
 	} else {
 		atomic_dec(&cs->count);
 	}
