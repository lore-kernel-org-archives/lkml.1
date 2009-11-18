Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbZKRBGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbZKRBGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 20:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756754AbZKRBGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 20:06:37 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:48918 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575AbZKRBGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 20:06:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=weZNiBsAUZkIb7m6NFPEA9J1qmOKdO/1fmJqS329TKcaCg0P5lQdUzT9Oj/GHRNUHm
         eilqHuz/aWI4lMw0dGaAMNKCV7ZI7V2SbsBX1VEe387YFUxnmKsk3PxP23kWk/F8A5JH
         pJqDkZjGyLHnX7ERXa/SsfVMyaoInz499+Isk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 1/2] lockdep: Include recursive read-locks dependencies in the tree
Date: Wed, 18 Nov 2009 02:06:37 +0100
Message-Id: <1258506398-5151-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1258506398-5151-1-git-send-email-fweisbec@gmail.com>
References: <1258506398-5151-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, recursive read locks are checked in two ways:

- walk through the locks held by the current task and check possible
  deadlock.

- if the recursive read lock is not already present in the lock held
  by the current task, check its dependencies against the tree.

But this recursive read lock will never be added to the tree of
dependencies. It means that the following sequence:

A = rwlock (Ar: taken as read recursive, Aw: taken as write)
B = normal lock

 Ar -> B
 B  -> Aw

won't ever be detected as a lock inversion.
This patch fixes it by inserting the recursive read locks into the
tree of dependencies and enhancing the circular checks (check the
class and the read attribute collision).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ming Lei <tom.leiming@gmail.com>
---
 include/linux/lockdep.h |    1 +
 kernel/lockdep.c        |   84 +++++++++++++++++++++++++++--------------------
 2 files changed, 49 insertions(+), 36 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 9ccf0e2..db24aa0 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -149,6 +149,7 @@ struct lock_list {
 	struct lock_class		*class;
 	struct stack_trace		trace;
 	int				distance;
+	int				read;
 
 	/*
 	 * The parent field is used to implement breadth-first search, and the
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index f5dcd36..a6f7440 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -818,8 +818,8 @@ static struct lock_list *alloc_list_entry(void)
 /*
  * Add a new dependency to the head of the list:
  */
-static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
-			    struct list_head *head, unsigned long ip, int distance)
+static int add_lock_to_list(struct held_lock *this, struct list_head *head,
+			    unsigned long ip, int distance)
 {
 	struct lock_list *entry;
 	/*
@@ -833,8 +833,9 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
 	if (!save_trace(&entry->trace))
 		return 0;
 
-	entry->class = this;
+	entry->class = hlock_class(this);
 	entry->distance = distance;
+	entry->read = this->read;
 	/*
 	 * Since we never remove from the dependency list, the list can
 	 * be walked lockless by other CPUs, it's only allocation
@@ -1087,9 +1088,34 @@ print_circular_bug_header(struct lock_list *entry, unsigned int depth,
 	return 0;
 }
 
-static inline int class_equal(struct lock_list *entry, void *data)
+static inline int lock_match(struct lock_list *entry, void *data)
 {
-	return entry->class == data;
+	struct held_lock *hl = data;
+
+	/* First eliminate class mismatch */
+	if (entry->class != hlock_class(hl))
+		return 0;
+
+	/*
+	 * If one of those is a write lock, whatever sequence
+	 * we have would be a deadlock
+	 */
+	if (!entry->read || !hl->read)
+		return 1;
+
+	/*
+	 * If the dependency to test is either read -> read-recursive
+	 * or read-recursive -> read-recursive, this won't lead to a
+	 * deadlock
+	 */
+	if (entry->read == 2)
+		return 0;
+
+	/*
+	 * If the dependency to test is either read-recursive -> read
+	 * or read -> read, this would be a deadlock
+	 */
+	return 1;
 }
 
 static noinline int print_circular_bug(struct lock_list *this,
@@ -1201,14 +1227,14 @@ unsigned long lockdep_count_backward_deps(struct lock_class *class)
  * lead to <target>. Print an error and return 0 if it does.
  */
 static noinline int
-check_noncircular(struct lock_list *root, struct lock_class *target,
+check_noncircular(struct lock_list *root, struct held_lock *target,
 		struct lock_list **target_entry)
 {
 	int result;
 
 	debug_atomic_inc(&nr_cyclic_checks);
 
-	result = __bfs_forwards(root, target, class_equal, target_entry);
+	result = __bfs_forwards(root, target, lock_match, target_entry);
 
 	return result;
 }
@@ -1654,7 +1680,9 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 */
 	this.class = hlock_class(next);
 	this.parent = NULL;
-	ret = check_noncircular(&this, hlock_class(prev), &target_entry);
+	this.read = next->read;
+
+	ret = check_noncircular(&this, prev, &target_entry);
 	if (unlikely(!ret))
 		return print_circular_bug(&this, target_entry, next, prev);
 	else if (unlikely(ret < 0))
@@ -1664,16 +1692,6 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 		return 0;
 
 	/*
-	 * For recursive read-locks we do all the dependency checks,
-	 * but we dont store read-triggered dependencies (only
-	 * write-triggered dependencies). This ensures that only the
-	 * write-side dependencies matter, and that if for example a
-	 * write-lock never takes any other locks, then the reads are
-	 * equivalent to a NOP.
-	 */
-	if (next->read == 2 || prev->read == 2)
-		return 1;
-	/*
 	 * Is the <prev> -> <next> dependency already present?
 	 *
 	 * (this may occur even though this is a new chain: consider
@@ -1693,15 +1711,13 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 * Ok, all validations passed, add the new lock
 	 * to the previous lock's dependency list:
 	 */
-	ret = add_lock_to_list(hlock_class(prev), hlock_class(next),
-			       &hlock_class(prev)->locks_after,
+	ret = add_lock_to_list(next, &hlock_class(prev)->locks_after,
 			       next->acquire_ip, distance);
 
 	if (!ret)
 		return 0;
 
-	ret = add_lock_to_list(hlock_class(next), hlock_class(prev),
-			       &hlock_class(next)->locks_before,
+	ret = add_lock_to_list(prev, &hlock_class(next)->locks_before,
 			       next->acquire_ip, distance);
 	if (!ret)
 		return 0;
@@ -1752,22 +1768,18 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
 	for (;;) {
 		int distance = curr->lockdep_depth - depth + 1;
 		hlock = curr->held_locks + depth-1;
+
+		if (!check_prev_add(curr, hlock, next, distance))
+			return 0;
 		/*
-		 * Only non-recursive-read entries get new dependencies
-		 * added:
+		 * Stop after the first non-trylock entry,
+		 * as non-trylock entries have added their
+		 * own direct dependencies already, so this
+		 * lock is connected to them indirectly:
 		 */
-		if (hlock->read != 2) {
-			if (!check_prev_add(curr, hlock, next, distance))
-				return 0;
-			/*
-			 * Stop after the first non-trylock entry,
-			 * as non-trylock entries have added their
-			 * own direct dependencies already, so this
-			 * lock is connected to them indirectly:
-			 */
-			if (!hlock->trylock)
-				break;
-		}
+		if (!hlock->trylock)
+			break;
+
 		depth--;
 		/*
 		 * End of lock-stack?
-- 
1.6.2.3

