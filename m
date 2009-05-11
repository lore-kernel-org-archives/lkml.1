Return-Path: <linux-kernel-owner+w=401wt.eu-S1758559AbZEKMkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559AbZEKMkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757450AbZEKMjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:39:49 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:44849 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132AbZEKMjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:39:48 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC/PATCH PATCH 5/6] lockdep: Maintain rw_state entries in locklist
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul E McKenney <paulmck@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 11 May 2009 18:09:51 +0530
Message-ID: <20090511123951.31159.1211.stgit@sofia.in.ibm.com>
In-Reply-To: <20090511122936.31159.44531.stgit@sofia.in.ibm.com>
References: <20090511122936.31159.44531.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dependencies are currently maintained using a structure named locklist.
For a dependency A --> B, it saves B's lock_class in an entry that would be
linked to A's locks_after list.

Enhance this infrastructure to save the read/write states of A and B for each
dependency. Also, rename a variable in locklist to reflect it's usage better.

Also change the parameter list to add_lock_to_list() to allow us record the r/w values for
the two locks involved in a dependency.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 include/linux/lockdep.h |   16 ++++++++++++++
 kernel/lockdep.c        |   52 ++++++++++++++++++++++++++++++-----------------
 kernel/lockdep_proc.c   |    4 ++--
 3 files changed, 50 insertions(+), 22 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 98cb434..d5c246f 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -141,14 +141,28 @@ struct lockdep_map {
 };
 
 /*
+ * lock_list: List of the other locks taken before or after a particular lock.
+ *
+ * @entry -	List head linking this particular entry to the
+ *		lock_after/lock_before list of a particular lock.
+ * @dep_class - lock_class of the lock which is involved in a dependency with
+ *		 the lock to which this entry is linked to.
+ * @this_lock_rw_state - The read/write state of the lock to which this
+ *			 dependency entry belongs to.
+ * @dep_lock_rw_state - The read/write state of the lock with the lock class
+ *			dep_class in this particular dependecy involvement.
+ *
+ *
  * Every lock has a list of other locks that were taken after it.
  * We only grow the list, never remove from it:
  */
 struct lock_list {
 	struct list_head		entry;
-	struct lock_class		*class;
+	struct lock_class		*dep_class;
 	struct stack_trace		trace;
 	int				distance;
+	unsigned int			this_lock_rw_state:3;
+	unsigned int			dep_lock_rw_state:3;
 };
 
 /*
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index c644af8..e3134f0 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -590,10 +590,10 @@ print_lock_dependencies(struct lock_class *class, int depth)
 	print_lock_class_header(class, depth);
 
 	list_for_each_entry(entry, &class->locks_after, entry) {
-		if (DEBUG_LOCKS_WARN_ON(!entry->class))
+		if (DEBUG_LOCKS_WARN_ON(!entry->dep_class))
 			return;
 
-		print_lock_dependencies(entry->class, depth + 1);
+		print_lock_dependencies(entry->dep_class, depth + 1);
 
 		printk("%*s ... acquired at:\n",depth,"");
 		print_stack_trace(&entry->trace, 2);
@@ -866,10 +866,13 @@ static struct lock_list *alloc_list_entry(void)
 /*
  * Add a new dependency to the head of the list:
  */
-static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
-			    struct list_head *head, unsigned long ip, int distance)
+static int add_lock_to_list(struct held_lock *this_hlock,
+			    struct held_lock *dep_hlock,
+			    struct list_head *head, unsigned long ip,
+			    int distance)
 {
 	struct lock_list *entry;
+	struct lock_class *dep_class = hlock_class(dep_hlock);
 	/*
 	 * Lock not present yet - get a new dependency struct and
 	 * add it to the list:
@@ -881,8 +884,10 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
 	if (!save_trace(&entry->trace))
 		return 0;
 
-	entry->class = this;
+	entry->dep_class = dep_class;
 	entry->distance = distance;
+	entry->this_lock_rw_state = this_hlock->rw_state;
+	entry->dep_lock_rw_state = dep_hlock->rw_state;
 	/*
 	 * Since we never remove from the dependency list, the list can
 	 * be walked lockless by other CPUs, it's only allocation
@@ -916,7 +921,7 @@ print_circular_bug_entry(struct lock_list *target, unsigned int depth)
 	if (debug_locks_silent)
 		return 0;
 	printk("\n-> #%u", depth);
-	print_lock_name(target->class);
+	print_lock_name(target->dep_class);
 	printk(":\n");
 	print_stack_trace(&target->trace, 6);
 
@@ -960,7 +965,7 @@ static noinline int print_circular_bug_tail(void)
 	if (debug_locks_silent)
 		return 0;
 
-	this.class = hlock_class(check_source);
+	this.dep_class = hlock_class(check_source);
 	if (!save_trace(&this.trace))
 		return 0;
 
@@ -1000,7 +1005,8 @@ unsigned long __lockdep_count_forward_deps(struct lock_class *class,
 	 * Recurse this class's dependency list:
 	 */
 	list_for_each_entry(entry, &class->locks_after, entry)
-		ret += __lockdep_count_forward_deps(entry->class, depth + 1);
+		ret += __lockdep_count_forward_deps(entry->dep_class,
+								depth + 1);
 
 	return ret;
 }
@@ -1030,7 +1036,8 @@ unsigned long __lockdep_count_backward_deps(struct lock_class *class,
 	 * Recurse this class's dependency list:
 	 */
 	list_for_each_entry(entry, &class->locks_before, entry)
-		ret += __lockdep_count_backward_deps(entry->class, depth + 1);
+		ret += __lockdep_count_backward_deps(entry->dep_class,
+								depth + 1);
 
 	return ret;
 }
@@ -1069,10 +1076,10 @@ check_noncircular(struct lock_class *source, unsigned int depth)
 	 * Check this lock's dependency list:
 	 */
 	list_for_each_entry(entry, &source->locks_after, entry) {
-		if (entry->class == hlock_class(check_target))
+		if (entry->dep_class == hlock_class(check_target))
 			return print_circular_bug_header(entry, depth+1);
 		debug_atomic_inc(&nr_cyclic_checks);
-		if (!check_noncircular(entry->class, depth+1))
+		if (!check_noncircular(entry->dep_class, depth+1))
 			return print_circular_bug_entry(entry, depth+1);
 	}
 	return 1;
@@ -1122,7 +1129,7 @@ find_usage_forwards(struct lock_class *source, unsigned int depth)
 	 */
 	list_for_each_entry(entry, &source->locks_after, entry) {
 		debug_atomic_inc(&nr_find_usage_forwards_recursions);
-		ret = find_usage_forwards(entry->class, depth+1);
+		ret = find_usage_forwards(entry->dep_class, depth+1);
 		if (ret == 2 || ret == 0)
 			return ret;
 	}
@@ -1172,7 +1179,7 @@ find_usage_backwards(struct lock_class *source, unsigned int depth)
 	 */
 	list_for_each_entry(entry, &source->locks_before, entry) {
 		debug_atomic_inc(&nr_find_usage_backwards_recursions);
-		ret = find_usage_backwards(entry->class, depth+1);
+		ret = find_usage_backwards(entry->dep_class, depth+1);
 		if (ret == 2 || ret == 0)
 			return ret;
 	}
@@ -1507,26 +1514,33 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 *  L2 added to its dependency list, due to the first chain.)
 	 */
 	list_for_each_entry(entry, &hlock_class(prev)->locks_after, entry) {
-		if (entry->class == hlock_class(next)) {
+		if (entry->dep_class == hlock_class(next)) {
 			if (distance == 1)
 				entry->distance = 1;
+			entry->this_lock_rw_state |= prev->rw_state;
+			entry->dep_lock_rw_state |= next->rw_state;
 			return 2;
 		}
 	}
 
+	list_for_each_entry(entry, &hlock_class(next)->locks_before, entry) {
+		if (entry->dep_class == hlock_class(prev)) {
+			entry->this_lock_rw_state |= next->rw_state;
+			entry->dep_lock_rw_state |= prev->rw_state;
+		}
+	}
+
 	/*
 	 * Ok, all validations passed, add the new lock
 	 * to the previous lock's dependency list:
 	 */
-	ret = add_lock_to_list(hlock_class(prev), hlock_class(next),
-			       &hlock_class(prev)->locks_after,
+	ret = add_lock_to_list(prev, next, &hlock_class(prev)->locks_after,
 			       next->acquire_ip, distance);
 
 	if (!ret)
 		return 0;
 
-	ret = add_lock_to_list(hlock_class(next), hlock_class(prev),
-			       &hlock_class(next)->locks_before,
+	ret = add_lock_to_list(next, prev, &hlock_class(next)->locks_before,
 			       next->acquire_ip, distance);
 	if (!ret)
 		return 0;
@@ -3215,7 +3229,7 @@ static void zap_class(struct lock_class *class)
 	 * involved in:
 	 */
 	for (i = 0; i < nr_list_entries; i++) {
-		if (list_entries[i].class == class)
+		if (list_entries[i].dep_class == class)
 			list_del_rcu(&list_entries[i].entry);
 	}
 	/*
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index d7135aa..da4880f 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -109,8 +109,8 @@ static int l_show(struct seq_file *m, void *v)
 
 	list_for_each_entry(entry, &class->locks_after, entry) {
 		if (entry->distance == 1) {
-			seq_printf(m, " -> [%p] ", entry->class->key);
-			print_name(m, entry->class);
+			seq_printf(m, " -> [%p] ", entry->dep_class->key);
+			print_name(m, entry->dep_class);
 			seq_puts(m, "\n");
 		}
 	}

