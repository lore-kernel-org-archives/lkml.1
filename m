Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbZEKMlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbZEKMlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbZEKMj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:39:57 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:60982 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758282AbZEKMj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:39:56 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC/PATCH PATCH 6/6] lockdep: Consider the rw_state of lock while
	validating the chain.
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul E McKenney <paulmck@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 11 May 2009 18:09:56 +0530
Message-ID: <20090511123956.31159.19663.stgit@sofia.in.ibm.com>
In-Reply-To: <20090511122936.31159.44531.stgit@sofia.in.ibm.com>
References: <20090511122936.31159.44531.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, while validating a particular dependency chain, we check if by
following the the locks_after list of current lock A, we can reach one of the
previous locks in the current chain.

i.e, if current chain is : A --> B -->C,
then starting from C -->locks_after, can we reach B.

However, if there are dependency chains:

	C--> D --> Rlock(E)

	Rlock(E) --> A,

where E is a Recursive Read lock, this chain cannot cause a deadlock because
of the recursive nature of E.

However, if the dependency chain was
	Wlock(E) --> A,
it would have caused a deadlock.

We solve this problem by defining conflicting states of each lock where

	Conflict(WRITE)		= WRITE, READ, RECURSIVE_READ
	Conflict(READ)		= WRITE, READ
	Conflict(RECURSIVE_READ)= WRITE

Thus, while traversing the locks_after chain of a particular lock A, we traverse
through only those entries in the chain where the state of the lock A in the
entry conflicts with the state of the lock A with which we started the
traversal.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 include/linux/lockdep.h |   20 ++++++++++++++++
 kernel/lockdep.c        |   60 +++++++++++++++++++++++++++++------------------
 2 files changed, 57 insertions(+), 23 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index d5c246f..83d92a6 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -326,6 +326,26 @@ extern void lockdep_init_map(struct lockdep_map *lock, const char *name,
 #define is_first_rec_read(state)	(state & STATE_FIRST_RECURSIVE_READ)
 
 /*
+ * Conflicting states:
+ * - A Recursive read conflicts only with a write.
+ * - A Non-recursive read can conflict with a non-recursive read and write.
+ * - A Write conflicts with Write, simple read and recursive read.
+ */
+
+#define get_rec_read_conflict(state)		\
+	((((is_write(state)) << (_RR_ - _W_))) & STATE_RECURSIVE_READ)
+
+#define get_simple_read_conflict(state)		\
+	(((((is_write(state)) << (_R_ - _W_))) | (is_simple_read(state))) \
+							& STATE_READ)
+#define get_write_conflict(state)	STATE_WRITE
+
+#define get_lock_conflict_states(state)		\
+	(get_rec_read_conflict(state) |	\
+	get_simple_read_conflict(state) |	\
+	get_write_conflict(state))
+
+/*
  * Acquire a lock.
  *
  * Values for "rw_state":
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index e3134f0..19936a5 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1060,7 +1060,8 @@ unsigned long lockdep_count_backward_deps(struct lock_class *class)
  * lead to <target>. Print an error and return 0 if it does.
  */
 static noinline int
-check_noncircular(struct lock_class *source, unsigned int depth)
+check_noncircular(struct lock_class *source, unsigned int depth,
+					unsigned int conflict_state)
 {
 	struct lock_list *entry;
 
@@ -1076,10 +1077,13 @@ check_noncircular(struct lock_class *source, unsigned int depth)
 	 * Check this lock's dependency list:
 	 */
 	list_for_each_entry(entry, &source->locks_after, entry) {
+		if (!(entry->this_lock_rw_state & conflict_state))
+			continue;
 		if (entry->dep_class == hlock_class(check_target))
 			return print_circular_bug_header(entry, depth+1);
 		debug_atomic_inc(&nr_cyclic_checks);
-		if (!check_noncircular(entry->dep_class, depth+1))
+		if (!check_noncircular(entry->dep_class, depth+1,
+			get_lock_conflict_states(entry->dep_lock_rw_state)))
 			return print_circular_bug_entry(entry, depth+1);
 	}
 	return 1;
@@ -1105,7 +1109,8 @@ static struct lock_class *forwards_match, *backwards_match;
  * Return 0 on error.
  */
 static noinline int
-find_usage_forwards(struct lock_class *source, unsigned int depth)
+find_usage_forwards(struct lock_class *source, unsigned int depth,
+						unsigned int conflict_states)
 {
 	struct lock_list *entry;
 	int ret;
@@ -1129,7 +1134,10 @@ find_usage_forwards(struct lock_class *source, unsigned int depth)
 	 */
 	list_for_each_entry(entry, &source->locks_after, entry) {
 		debug_atomic_inc(&nr_find_usage_forwards_recursions);
-		ret = find_usage_forwards(entry->dep_class, depth+1);
+		if (!(entry->this_lock_rw_state & conflict_states))
+			continue;
+		ret = find_usage_forwards(entry->dep_class, depth+1,
+			get_lock_conflict_states(entry->dep_lock_rw_state));
 		if (ret == 2 || ret == 0)
 			return ret;
 	}
@@ -1147,7 +1155,8 @@ find_usage_forwards(struct lock_class *source, unsigned int depth)
  * Return 0 on error.
  */
 static noinline int
-find_usage_backwards(struct lock_class *source, unsigned int depth)
+find_usage_backwards(struct lock_class *source, unsigned int depth,
+						unsigned int conflict_states)
 {
 	struct lock_list *entry;
 	int ret;
@@ -1179,7 +1188,10 @@ find_usage_backwards(struct lock_class *source, unsigned int depth)
 	 */
 	list_for_each_entry(entry, &source->locks_before, entry) {
 		debug_atomic_inc(&nr_find_usage_backwards_recursions);
-		ret = find_usage_backwards(entry->dep_class, depth+1);
+		if (!(entry->this_lock_rw_state & conflict_states))
+			continue;
+		ret = find_usage_backwards(entry->dep_class, depth+1,
+			get_lock_conflict_states(entry->dep_lock_rw_state));
 		if (ret == 2 || ret == 0)
 			return ret;
 	}
@@ -1256,12 +1268,14 @@ check_usage(struct task_struct *curr, struct held_lock *prev,
 
 	find_usage_bit = bit_backwards;
 	/* fills in <backwards_match> */
-	ret = find_usage_backwards(hlock_class(prev), 0);
+	ret = find_usage_backwards(hlock_class(prev), 0,
+			get_lock_conflict_states(prev->rw_state));
 	if (!ret || ret == 1)
 		return ret;
 
 	find_usage_bit = bit_forwards;
-	ret = find_usage_forwards(hlock_class(next), 0);
+	ret = find_usage_forwards(hlock_class(next), 0,
+			get_lock_conflict_states(next->rw_state));
 	if (!ret || ret == 1)
 		return ret;
 	/* ret == 2 */
@@ -1489,23 +1503,14 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 */
 	check_source = next;
 	check_target = prev;
-	if (!(check_noncircular(hlock_class(next), 0)))
+	if (!(check_noncircular(hlock_class(next), 0,
+		get_lock_conflict_states(next->rw_state))))
 		return print_circular_bug_tail();
 
 	if (!check_prev_add_irq(curr, prev, next))
 		return 0;
 
 	/*
-	 * For recursive read-locks we do all the dependency checks,
-	 * but we dont store read-triggered dependencies (only
-	 * write-triggered dependencies). This ensures that only the
-	 * write-side dependencies matter, and that if for example a
-	 * write-lock never takes any other locks, then the reads are
-	 * equivalent to a NOP.
-	 */
-	if (is_rec_read(next->rw_state))
-		return 1;
-	/*
 	 * Is the <prev> -> <next> dependency already present?
 	 *
 	 * (this may occur even though this is a new chain: consider
@@ -1595,7 +1600,8 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
 		 * Only non-recursive-read entries get new dependencies
 		 * added:
 		 */
-		if (!is_rec_read(hlock->rw_state)) {
+		if (!is_rec_read(hlock->rw_state) ||
+				is_first_rec_read(hlock->rw_state)) {
 			if (!check_prev_add(curr, hlock, next, distance))
 				return 0;
 			/*
@@ -1767,9 +1773,15 @@ static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
 
 		if (!ret)
 			return 0;
+
+		if (ret != 2 && is_rec_read(hlock->rw_state))
+			hlock->rw_state |= STATE_FIRST_RECURSIVE_READ;
+
+
 		/*
 		 * Add dependency only if this lock is not the head
-		 * of the chain, and if it's not a secondary read-lock:
+		 * of the chain, and if it's not the first instance of
+		 * the recursive read-lock:
 		 */
 		if (!chain_head && ret != 2)
 			if (!check_prevs_add(curr, hlock))
@@ -1940,7 +1952,8 @@ check_usage_forwards(struct task_struct *curr, struct held_lock *this,
 
 	find_usage_bit = bit;
 	/* fills in <forwards_match> */
-	ret = find_usage_forwards(hlock_class(this), 0);
+	ret = find_usage_forwards(hlock_class(this), 0,
+			get_lock_conflict_states(this->rw_state));
 	if (!ret || ret == 1)
 		return ret;
 
@@ -1959,7 +1972,8 @@ check_usage_backwards(struct task_struct *curr, struct held_lock *this,
 
 	find_usage_bit = bit;
 	/* fills in <backwards_match> */
-	ret = find_usage_backwards(hlock_class(this), 0);
+	ret = find_usage_backwards(hlock_class(this), 0,
+			get_lock_conflict_states(this->rw_state));
 	if (!ret || ret == 1)
 		return ret;
 

