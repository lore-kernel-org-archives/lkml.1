Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbZGROXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbZGROXm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZGROXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:23:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:53974 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbZGROXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:23:35 -0400
Date: Sat, 18 Jul 2009 14:23:00 GMT
From: tip-bot for Ming Lei <tom.leiming@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, tom.leiming@gmail.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, tom.leiming@gmail.com,
       mingo@elte.hu
In-Reply-To: <1246201486-7308-2-git-send-email-tom.leiming@gmail.com>
References: <1246201486-7308-2-git-send-email-tom.leiming@gmail.com>
Subject: [tip:core/locking] lockdep: Print the shortest dependency chain if finding a circle
Message-ID: <tip-404918949c3fb1b0138e4a281d4e7e72e5b348bb@git.kernel.org>
Git-Commit-ID: 404918949c3fb1b0138e4a281d4e7e72e5b348bb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 14:23:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  404918949c3fb1b0138e4a281d4e7e72e5b348bb
Gitweb:     http://git.kernel.org/tip/404918949c3fb1b0138e4a281d4e7e72e5b348bb
Author:     Ming Lei <tom.leiming@gmail.com>
AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 16:02:51 +0200

lockdep: Print the shortest dependency chain if finding a circle

Currently lockdep will print the 1st circle detected if it
exists when acquiring a new (next) lock.

This patch prints the shortest path from the next lock to be
acquired to the previous held lock if a circle is found.

The patch still uses the current method to check circle, and
once the circle is found, breadth-first search algorithem is
used to compute the shortest path from the next lock to the
previous lock in the forward lock dependency graph.

Printing the shortest path will shorten the dependency chain,
and make troubleshooting for possible circular locking easier.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1246201486-7308-2-git-send-email-tom.leiming@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/lockdep.h    |    6 ++
 kernel/lockdep.c           |  115 ++++++++++++++++++++++++++++++++++++++++----
 kernel/lockdep_internals.h |   83 +++++++++++++++++++++++++++++++
 3 files changed, 195 insertions(+), 9 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index b25d1b5..9ec026f 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -149,6 +149,12 @@ struct lock_list {
 	struct lock_class		*class;
 	struct stack_trace		trace;
 	int				distance;
+
+	/*The parent field is used to implement breadth-first search,and
+	 *the bit 0 is reused to indicate if the lock has been accessed
+	 *in BFS.
+	 */
+	struct lock_list		*parent;
 };
 
 /*
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 8bbeef9..93dc70d 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -897,6 +897,79 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
 	return 1;
 }
 
+static struct circular_queue  lock_cq;
+static int __search_shortest_path(struct lock_list *source_entry,
+				struct lock_class *target,
+				struct lock_list **target_entry,
+				int forward)
+{
+	struct lock_list *entry;
+	struct circular_queue *cq = &lock_cq;
+	int ret = 1;
+
+	__cq_init(cq);
+
+	mark_lock_accessed(source_entry, NULL);
+	if (source_entry->class == target) {
+		*target_entry = source_entry;
+		ret = 0;
+		goto exit;
+	}
+
+	__cq_enqueue(cq, (unsigned long)source_entry);
+
+	while (!__cq_empty(cq)) {
+		struct lock_list *lock;
+		struct list_head *head;
+
+		__cq_dequeue(cq, (unsigned long *)&lock);
+
+		if (!lock->class) {
+			ret = -2;
+			goto exit;
+		}
+
+		if (forward)
+			head = &lock->class->locks_after;
+		else
+			head = &lock->class->locks_before;
+
+		list_for_each_entry(entry, head, entry) {
+			if (!lock_accessed(entry)) {
+				mark_lock_accessed(entry, lock);
+				if (entry->class == target) {
+					*target_entry = entry;
+					ret = 0;
+					goto exit;
+				}
+
+				if (__cq_enqueue(cq, (unsigned long)entry)) {
+					ret = -1;
+					goto exit;
+				}
+			}
+		}
+	}
+exit:
+	return ret;
+}
+
+static inline int __search_forward_shortest_path(struct lock_list *src_entry,
+				struct lock_class *target,
+				struct lock_list **target_entry)
+{
+	return __search_shortest_path(src_entry, target, target_entry, 1);
+
+}
+
+static inline int __search_backward_shortest_path(struct lock_list *src_entry,
+				struct lock_class *target,
+				struct lock_list **target_entry)
+{
+	return __search_shortest_path(src_entry, target, target_entry, 0);
+
+}
+
 /*
  * Recursive, forwards-direction lock-dependency checking, used for
  * both noncyclic checking and for hardirq-unsafe/softirq-unsafe
@@ -934,7 +1007,7 @@ print_circular_bug_header(struct lock_list *entry, unsigned int depth)
 {
 	struct task_struct *curr = current;
 
-	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
+	if (debug_locks_silent)
 		return 0;
 
 	printk("\n=======================================================\n");
@@ -954,19 +1027,41 @@ print_circular_bug_header(struct lock_list *entry, unsigned int depth)
 	return 0;
 }
 
-static noinline int print_circular_bug_tail(void)
+static noinline int print_circular_bug(void)
 {
 	struct task_struct *curr = current;
 	struct lock_list this;
+	struct lock_list *target;
+	struct lock_list *parent;
+	int result;
+	unsigned long depth;
 
-	if (debug_locks_silent)
+	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
 	this.class = hlock_class(check_source);
 	if (!save_trace(&this.trace))
 		return 0;
 
-	print_circular_bug_entry(&this, 0);
+	result = __search_forward_shortest_path(&this,
+						hlock_class(check_target),
+						&target);
+	if (result) {
+		printk("\n%s:search shortest path failed:%d\n", __func__,
+			result);
+		return 0;
+	}
+
+	depth = get_lock_depth(target);
+
+	print_circular_bug_header(target, depth);
+
+	parent = get_lock_parent(target);
+
+	while (parent) {
+		print_circular_bug_entry(parent, --depth);
+		parent = get_lock_parent(parent);
+	}
 
 	printk("\nother info that might help us debug this:\n\n");
 	lockdep_print_held_locks(curr);
@@ -1072,14 +1167,15 @@ check_noncircular(struct lock_class *source, unsigned int depth)
 	 */
 	list_for_each_entry(entry, &source->locks_after, entry) {
 		if (entry->class == hlock_class(check_target))
-			return print_circular_bug_header(entry, depth+1);
+			return 2;
 		debug_atomic_inc(&nr_cyclic_checks);
-		if (!check_noncircular(entry->class, depth+1))
-			return print_circular_bug_entry(entry, depth+1);
+		if (check_noncircular(entry->class, depth+1) == 2)
+			return 2;
 	}
 	return 1;
 }
 
+
 #if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_PROVE_LOCKING)
 /*
  * Forwards and backwards subgraph searching, for the purposes of
@@ -1484,8 +1580,9 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 */
 	check_source = next;
 	check_target = prev;
-	if (!(check_noncircular(hlock_class(next), 0)))
-		return print_circular_bug_tail();
+	if (check_noncircular(hlock_class(next), 0) == 2)
+		return print_circular_bug();
+
 
 	if (!check_prev_add_irq(curr, prev, next))
 		return 0;
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 699a2ac..6f48d37 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -136,3 +136,86 @@ extern atomic_t nr_find_usage_backwards_recursions;
 # define debug_atomic_dec(ptr)		do { } while (0)
 # define debug_atomic_read(ptr)		0
 #endif
+
+/* The circular_queue and helpers is used to implement the
+ * breadth-first search(BFS)algorithem, by which we can build
+ * the shortest path from the next lock to be acquired to the
+ * previous held lock if there is a circular between them.
+ * */
+#define  MAX_CIRCULAR_QUE_SIZE	    4096UL
+struct circular_queue{
+	unsigned long element[MAX_CIRCULAR_QUE_SIZE];
+	unsigned int  front, rear;
+};
+
+#define LOCK_ACCESSED 		1UL
+#define LOCK_ACCESSED_MASK	(~LOCK_ACCESSED)
+
+static inline void __cq_init(struct circular_queue *cq)
+{
+	cq->front = cq->rear = 0;
+}
+
+static inline int __cq_empty(struct circular_queue *cq)
+{
+	return (cq->front == cq->rear);
+}
+
+static inline int __cq_full(struct circular_queue *cq)
+{
+	return ((cq->rear + 1)%MAX_CIRCULAR_QUE_SIZE)  == cq->front;
+}
+
+static inline int __cq_enqueue(struct circular_queue *cq, unsigned long elem)
+{
+	if (__cq_full(cq))
+		return -1;
+
+	cq->element[cq->rear] = elem;
+	cq->rear = (cq->rear + 1)%MAX_CIRCULAR_QUE_SIZE;
+	return 0;
+}
+
+static inline int __cq_dequeue(struct circular_queue *cq, unsigned long *elem)
+{
+	if (__cq_empty(cq))
+		return -1;
+
+	*elem = cq->element[cq->front];
+	cq->front = (cq->front + 1)%MAX_CIRCULAR_QUE_SIZE;
+	return 0;
+}
+
+static inline int __cq_get_elem_count(struct circular_queue *cq)
+{
+	return (cq->rear - cq->front)%MAX_CIRCULAR_QUE_SIZE;
+}
+
+static inline void mark_lock_accessed(struct lock_list *lock,
+					struct lock_list *parent)
+{
+	lock->parent = (void *) parent + LOCK_ACCESSED;
+}
+
+static inline unsigned long lock_accessed(struct lock_list *lock)
+{
+	return (unsigned long)lock->parent & LOCK_ACCESSED;
+}
+
+static inline struct lock_list *get_lock_parent(struct lock_list *child)
+{
+	return (struct lock_list *)
+		((unsigned long)child->parent & LOCK_ACCESSED_MASK);
+}
+
+static inline unsigned long get_lock_depth(struct lock_list *child)
+{
+	unsigned long depth = 0;
+	struct lock_list *parent;
+
+	while ((parent = get_lock_parent(child))) {
+		child = parent;
+		depth++;
+	}
+	return depth;
+}
