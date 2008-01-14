Return-Path: <linux-kernel-owner+w=401wt.eu-S1752219AbYANGmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbYANGmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 01:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbYANGlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 01:41:53 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57967 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754085AbYANGlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 01:41:51 -0500
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Lee.Schermerhorn@hp.com, Cliff Wickman <cpw@sgi.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>,
       Christoph Lameter <clameter@sgi.com>, Paul Jackson <pj@sgi.com>
Date: Sun, 13 Jan 2008 22:41:49 -0800
Message-Id: <20080114064149.2782.69951.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH 2/3] hotplug cpu move tasks in empty cpusets to parent various other fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

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
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Paul Menage <menage@google.com>

---

Andrew - this collides with Paul Menage's recent patch:
	[PATCH] Update comments in cpuset.c
  If you don't want to futz with the collisions, then feel
  free to kick one of these back at us to deal with. -pj


 kernel/cpuset.c |   53 +++++++++++++++++++++--------------------------------
 1 file changed, 21 insertions(+), 32 deletions(-)

--- 2.6.24-rc6-mm1.orig/kernel/cpuset.c	2008-01-12 23:19:21.357921853 -0800
+++ 2.6.24-rc6-mm1/kernel/cpuset.c	2008-01-12 23:21:08.571542697 -0800
@@ -167,7 +167,7 @@ static inline int is_spread_slab(const s
  * number, and avoid having to lock and reload mems_allowed unless
  * the cpuset they're using changes generation.
  *
- * A single, global generation is needed because attach_task() could
+ * A single, global generation is needed because cpuset_attach() could
  * reattach a task to a different cpuset, which must not have its
  * generation numbers aliased with those of that tasks previous cpuset.
  *
@@ -218,7 +218,7 @@ static struct cpuset top_cpuset = {
  * Any task can increment and decrement the count field without lock.
  * So in general, code holding manage_mutex or callback_mutex can't rely
  * on the count field not changing.  However, if the count goes to
- * zero, then only attach_task(), which holds both mutexes, can
+ * zero, then only cpuset_attach(), which holds both mutexes, can
  * increment it again.  Because a count of zero means that no tasks
  * are currently attached, therefore there is no way a task attached
  * to that cpuset can fork (the other way to increment the count).
@@ -255,18 +255,18 @@ static struct cpuset top_cpuset = {
  *
  *	The task_lock() exception
  *
- * The need for this exception arises from the action of attach_task(),
+ * The need for this exception arises from the action of cpuset_attach(),
  * which overwrites one tasks cpuset pointer with another.  It does
  * so using both mutexes, however there are several performance
  * critical places that need to reference task->cpuset without the
  * expense of grabbing a system global mutex.  Therefore except as
- * noted below, when dereferencing or, as in attach_task(), modifying
+ * noted below, when dereferencing or, as in cpuset_attach(), modifying
  * a tasks cpuset pointer we use task_lock(), which acts on a spinlock
  * (task->alloc_lock) already in the task_struct routinely used for
  * such matters.
  *
  * P.S.  One more locking exception.  RCU is used to guard the
- * update of a tasks cpuset pointer by attach_task() and the
+ * update of a tasks cpuset pointer by cpuset_attach() and the
  * access of task->cpuset->mems_generation via that pointer in
  * the routine cpuset_update_task_memory_state().
  */
@@ -368,7 +368,7 @@ static void guarantee_online_mems(const 
  *
  * Reading current->cpuset->mems_generation doesn't need task_lock
  * to guard the current->cpuset derefence, because it is guarded
- * from concurrent freeing of current->cpuset by attach_task(),
+ * from concurrent freeing of current->cpuset by cpuset_attach(),
  * using RCU.
  *
  * The rcu_dereference() is technically probably not needed,
@@ -790,7 +790,7 @@ static int update_cpumask(struct cpuset 
 	trialcs = *cs;
 
 	/*
-	 * An empty cpus_allowed is ok if there are no tasks in the cpuset.
+	 * An empty cpus_allowed is ok only if the cpuset has no tasks.
 	 * Since cpulist_parse() fails on an empty mask, we special case
 	 * that parsing.  The validate_change() call ensures that cpusets
 	 * with tasks have cpus.
@@ -847,7 +847,7 @@ static int update_cpumask(struct cpuset 
  *    so that the migration code can allocate pages on these nodes.
  *
  *    Call holding manage_mutex, so our current->cpuset won't change
- *    during this call, as manage_mutex holds off any attach_task()
+ *    during this call, as manage_mutex holds off any cpuset_attach()
  *    calls.  Therefore we don't need to take task_lock around the
  *    call to guarantee_online_mems(), as we know no one is changing
  *    our tasks cpuset.
@@ -1700,8 +1700,8 @@ void cpuset_do_move_task(struct task_str
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
@@ -1728,18 +1728,18 @@ static void move_member_tasks_to_cpuset(
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
 
@@ -1748,14 +1748,8 @@ static void remove_tasks_in_empty_cpuset
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
@@ -1764,10 +1758,6 @@ static void remove_tasks_in_empty_cpuset
  * Walk the specified cpuset subtree and look for empty cpusets.
  * The tasks of such cpuset must be moved to a parent cpuset.
  *
- * Note that such a notify_on_release cpuset must have had, at some time,
- * member tasks or cpuset descendants and cpus and memory, before it can
- * be a candidate for release.
- *
  * Called with manage_mutex held.  We take callback_mutex to modify
  * cpus_allowed and mems_allowed.
  *
@@ -1803,8 +1793,8 @@ static void scan_for_empty_cpusets(const
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
@@ -1812,7 +1802,6 @@ static void scan_for_empty_cpusets(const
 		}
 	}
 	mutex_unlock(&callback_mutex);
-	return;
 }
 
 /*
@@ -2246,7 +2235,7 @@ void __cpuset_memory_pressure_bump(void)
  *  - Used for /proc/<pid>/cpuset.
  *  - No need to task_lock(tsk) on this tsk->cpuset reference, as it
  *    doesn't really matter if tsk->cpuset changes after we read it,
- *    and we take manage_mutex, keeping attach_task() from changing it
+ *    and we take manage_mutex, keeping cpuset_attach() from changing it
  *    anyway.  No need to check that tsk->cpuset != NULL, thanks to
  *    the_top_cpuset_hack in cpuset_exit(), which sets an exiting tasks
  *    cpuset to top_cpuset.

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
