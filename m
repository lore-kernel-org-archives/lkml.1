Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbYBDRlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbYBDRlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 12:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbYBDRkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 12:40:53 -0500
Received: from relay1.sgi.com ([192.48.171.29]:57545 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756606AbYBDRkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 12:40:52 -0500
Date: Mon, 04 Feb 2008 11:40:51 -0600
To: linux-kernel@vger.kernel.org
Cc: pj@sgi.com, clameter@sgi.com, rientjes@google.com, menage@google.com,
       cpw@sgi.com, Lee.Schermerhorn@hp.com, akpm@osdl.org
Subject: [PATCH 2/4 v2] hotplug cpu move tasks in empty cpusets to parent
 various other fixes
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080204174051.ACC3F1FE109@attica.americas.sgi.com>
From: cpw@sgi.com (Cliff Wickman)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Various minor formatting and comment tweaks to Cliff Wickman's
[PATCH_3_of_3]_cpusets__update_cpumask_revision.patch

I had had "iff", meaning "if and only if" in a comment.
However, except for ancient mathematicians, the abbreviation
"iff" was a tad too cryptic.  Cliff changed it to "if",
presumably figuring that the "iff" was a typo.  However, it
was the "only if" half of the conjunction that was most
interesting.  Reword to emphasis the "only if" aspect.

The locking comment for remove_tasks_in_empty_cpuset() was wrong;
it said callback_mutex had to be held on entry.  The opposite
is true.

Several mentions of attach_task() in comments needed to be
changed to cgroup_attach_task().

A comment about notify_on_release was no longer relevant,
as the line of code it had commented, namely:
	set_bit(CS_RELEASED_RESOURCE, &parent->flags);
is no longer present in that place in the cpuset.c code.

Similarly a comment about notify_on_release before the
scan_for_empty_cpusets() routine was no longer relevant.

Removed extra parentheses and unnecessary return statement.

Renamed attach_task() to cpuset_attach() in various comments.

Removed comment about not needing memory migration, as it
seems the migration is done anyway, via the cpuset_attach()
callback from cgroup_attach_task().

Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Cliff Wickman <cpw@sgi.com>

---

 kernel/cpuset.c |   41 +++++++++++++++--------------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

Index: linux-2.6/kernel/cpuset.c
===================================================================
--- linux-2.6.orig/kernel/cpuset.c
+++ linux-2.6/kernel/cpuset.c
@@ -752,7 +752,7 @@ static int update_cpumask(struct cpuset 
 	trialcs = *cs;
 
 	/*
-	 * An empty cpus_allowed is ok if there are no tasks in the cpuset.
+	 * An empty cpus_allowed is ok only if the cpuset has no tasks.
 	 * Since cpulist_parse() fails on an empty mask, we special case
 	 * that parsing.  The validate_change() call ensures that cpusets
 	 * with tasks have cpus.
@@ -809,7 +809,7 @@ static int update_cpumask(struct cpuset 
  *    so that the migration code can allocate pages on these nodes.
  *
  *    Call holding cgroup_mutex, so current's cpuset won't change
- *    during this call, as cgroup_mutex holds off any attach_task()
+ *    during this call, as manage_mutex holds off any cpuset_attach()
  *    calls.  Therefore we don't need to take task_lock around the
  *    call to guarantee_online_mems(), as we know no one is changing
  *    our task's cpuset.
@@ -1661,8 +1661,8 @@ void cpuset_do_move_task(struct task_str
  * @from: cpuset in which the tasks currently reside
  * @to: cpuset to which the tasks will be moved
  *
- * Called with manage_sem held
- * callback_mutex must not be held, as attach_task() will take it.
+ * Called with cgroup_mutex held
+ * callback_mutex must not be held, as cpuset_attach() will take it.
  *
  * The cgroup_scan_tasks() function will scan all the tasks in a cgroup,
  * calling callback functions for each.
@@ -1689,18 +1689,18 @@ static void move_member_tasks_to_cpuset(
  * last CPU or node from a cpuset, then move the tasks in the empty
  * cpuset to its next-highest non-empty parent.
  *
- * The parent cpuset has some superset of the 'mems' nodes that the
- * newly empty cpuset held, so no migration of memory is necessary.
- *
- * Called with both manage_sem and callback_sem held
+ * Called with cgroup_mutex held
+ * callback_mutex must not be held, as cpuset_attach() will take it.
  */
 static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
 {
 	struct cpuset *parent;
 
-	/* the cgroup's css_sets list is in use if there are tasks
-	   in the cpuset; the list is empty if there are none;
-	   the cs->css.refcnt seems always 0 */
+	/*
+	 * The cgroup's css_sets list is in use if there are tasks
+	 * in the cpuset; the list is empty if there are none;
+	 * the cs->css.refcnt seems always 0.
+	 */
 	if (list_empty(&cs->css.cgroup->css_sets))
 		return;
 
@@ -1709,14 +1709,8 @@ static void remove_tasks_in_empty_cpuset
 	 * has online cpus, so can't be empty).
 	 */
 	parent = cs->parent;
-	while (cpus_empty(parent->cpus_allowed)) {
-		/*
-		 * this empty cpuset should now be considered to
-		 * have been used, and therefore eligible for
-		 * release when empty (if it is notify_on_release)
-		 */
+	while (cpus_empty(parent->cpus_allowed))
 		parent = parent->parent;
-	}
 
 	move_member_tasks_to_cpuset(cs, parent);
 }
@@ -1725,10 +1719,6 @@ static void remove_tasks_in_empty_cpuset
  * Walk the specified cpuset subtree and look for empty cpusets.
  * The tasks of such cpuset must be moved to a parent cpuset.
  *
- * Note that such a notify_on_release cpuset must have had, at some time,
- * member tasks or cpuset descendants and cpus and memory, before it can
- * be a candidate for release.
- *
  * Called with cgroup_mutex held.  We take callback_mutex to modify
  * cpus_allowed and mems_allowed.
  *
@@ -1764,8 +1754,8 @@ static void scan_for_empty_cpusets(const
 		cpus_and(cp->cpus_allowed, cp->cpus_allowed, cpu_online_map);
 		nodes_and(cp->mems_allowed, cp->mems_allowed,
 						node_states[N_HIGH_MEMORY]);
-		if ((cpus_empty(cp->cpus_allowed) ||
-		     nodes_empty(cp->mems_allowed))) {
+		if (cpus_empty(cp->cpus_allowed) ||
+		     nodes_empty(cp->mems_allowed)) {
 			/* Move tasks from the empty cpuset to a parent */
 			mutex_unlock(&callback_mutex);
 			remove_tasks_in_empty_cpuset(cp);
@@ -1773,7 +1763,6 @@ static void scan_for_empty_cpusets(const
 		}
 	}
 	mutex_unlock(&callback_mutex);
-	return;
 }
 
 /*
@@ -2207,7 +2196,7 @@ void __cpuset_memory_pressure_bump(void)
  *  - Used for /proc/<pid>/cpuset.
  *  - No need to task_lock(tsk) on this tsk->cpuset reference, as it
  *    doesn't really matter if tsk->cpuset changes after we read it,
- *    and we take cgroup_mutex, keeping attach_task() from changing it
+ *    and we take cgroup_mutex, keeping cpuset_attach() from changing it
  *    anyway.
  */
 static int proc_cpuset_show(struct seq_file *m, void *unused_v)
