Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbZGROXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbZGROXo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZGROXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:23:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:53984 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZGROXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:23:39 -0400
Date: Sat, 18 Jul 2009 14:23:12 GMT
From: tip-bot for Ming Lei <tom.leiming@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, tom.leiming@gmail.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, tom.leiming@gmail.com,
       mingo@elte.hu
In-Reply-To: <1246201486-7308-3-git-send-email-tom.leiming@gmail.com>
References: <1246201486-7308-3-git-send-email-tom.leiming@gmail.com>
Subject: [tip:core/locking] lockdep: Improve implementation of BFS
Message-ID: <tip-4b397a0578ade0fda66e53578cabf1890fb9dee4@git.kernel.org>
Git-Commit-ID: 4b397a0578ade0fda66e53578cabf1890fb9dee4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 14:23:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b397a0578ade0fda66e53578cabf1890fb9dee4
Gitweb:     http://git.kernel.org/tip/4b397a0578ade0fda66e53578cabf1890fb9dee4
Author:     Ming Lei <tom.leiming@gmail.com>
AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 16:02:52 +0200

lockdep: Improve implementation of BFS

1,replace %MAX_CIRCULAR_QUE_SIZE with &(MAX_CIRCULAR_QUE_SIZE-1)
since we define MAX_CIRCULAR_QUE_SIZE as power of 2;

2,use bitmap to mark if a lock is accessed in BFS in order to
clear it quickly, because we may search a graph many times.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1246201486-7308-3-git-send-email-tom.leiming@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep.c           |   23 ++++++++++++++++-------
 kernel/lockdep_internals.h |   35 +++++++++++++++++++++++------------
 2 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 93dc70d..5dcca26 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -42,7 +42,7 @@
 #include <linux/hash.h>
 #include <linux/ftrace.h>
 #include <linux/stringify.h>
-
+#include <linux/bitops.h>
 #include <asm/sections.h>
 
 #include "lockdep_internals.h"
@@ -118,7 +118,7 @@ static inline int debug_locks_off_graph_unlock(void)
 static int lockdep_initialized;
 
 unsigned long nr_list_entries;
-static struct lock_list list_entries[MAX_LOCKDEP_ENTRIES];
+struct lock_list list_entries[MAX_LOCKDEP_ENTRIES];
 
 /*
  * All data structures here are protected by the global debug_lock.
@@ -897,30 +897,38 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
 	return 1;
 }
 
+unsigned long bfs_accessed[BITS_TO_LONGS(MAX_LOCKDEP_ENTRIES)];
 static struct circular_queue  lock_cq;
+
 static int __search_shortest_path(struct lock_list *source_entry,
 				struct lock_class *target,
 				struct lock_list **target_entry,
 				int forward)
 {
 	struct lock_list *entry;
+	struct list_head *head;
 	struct circular_queue *cq = &lock_cq;
 	int ret = 1;
 
-	__cq_init(cq);
-
-	mark_lock_accessed(source_entry, NULL);
 	if (source_entry->class == target) {
 		*target_entry = source_entry;
 		ret = 0;
 		goto exit;
 	}
 
+	if (forward)
+		head = &source_entry->class->locks_after;
+	else
+		head = &source_entry->class->locks_before;
+
+	if (list_empty(head))
+		goto exit;
+
+	__cq_init(cq);
 	__cq_enqueue(cq, (unsigned long)source_entry);
 
 	while (!__cq_empty(cq)) {
 		struct lock_list *lock;
-		struct list_head *head;
 
 		__cq_dequeue(cq, (unsigned long *)&lock);
 
@@ -1040,6 +1048,7 @@ static noinline int print_circular_bug(void)
 		return 0;
 
 	this.class = hlock_class(check_source);
+	this.parent = NULL;
 	if (!save_trace(&this.trace))
 		return 0;
 
@@ -1580,10 +1589,10 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 */
 	check_source = next;
 	check_target = prev;
+
 	if (check_noncircular(hlock_class(next), 0) == 2)
 		return print_circular_bug();
 
-
 	if (!check_prev_add_irq(curr, prev, next))
 		return 0;
 
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 6f48d37..c2f6594 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -137,23 +137,28 @@ extern atomic_t nr_find_usage_backwards_recursions;
 # define debug_atomic_read(ptr)		0
 #endif
 
+
+extern unsigned long nr_list_entries;
+extern struct lock_list list_entries[MAX_LOCKDEP_ENTRIES];
+extern unsigned long bfs_accessed[];
+
+/*For good efficiency of modular, we use power of 2*/
+#define  MAX_CIRCULAR_QUE_SIZE	    4096UL
+
 /* The circular_queue and helpers is used to implement the
  * breadth-first search(BFS)algorithem, by which we can build
  * the shortest path from the next lock to be acquired to the
  * previous held lock if there is a circular between them.
  * */
-#define  MAX_CIRCULAR_QUE_SIZE	    4096UL
 struct circular_queue{
 	unsigned long element[MAX_CIRCULAR_QUE_SIZE];
 	unsigned int  front, rear;
 };
 
-#define LOCK_ACCESSED 		1UL
-#define LOCK_ACCESSED_MASK	(~LOCK_ACCESSED)
-
 static inline void __cq_init(struct circular_queue *cq)
 {
 	cq->front = cq->rear = 0;
+	bitmap_zero(bfs_accessed, MAX_LOCKDEP_ENTRIES);
 }
 
 static inline int __cq_empty(struct circular_queue *cq)
@@ -163,7 +168,7 @@ static inline int __cq_empty(struct circular_queue *cq)
 
 static inline int __cq_full(struct circular_queue *cq)
 {
-	return ((cq->rear + 1)%MAX_CIRCULAR_QUE_SIZE)  == cq->front;
+	return ((cq->rear + 1)&(MAX_CIRCULAR_QUE_SIZE-1))  == cq->front;
 }
 
 static inline int __cq_enqueue(struct circular_queue *cq, unsigned long elem)
@@ -172,7 +177,7 @@ static inline int __cq_enqueue(struct circular_queue *cq, unsigned long elem)
 		return -1;
 
 	cq->element[cq->rear] = elem;
-	cq->rear = (cq->rear + 1)%MAX_CIRCULAR_QUE_SIZE;
+	cq->rear = (cq->rear + 1)&(MAX_CIRCULAR_QUE_SIZE-1);
 	return 0;
 }
 
@@ -182,30 +187,36 @@ static inline int __cq_dequeue(struct circular_queue *cq, unsigned long *elem)
 		return -1;
 
 	*elem = cq->element[cq->front];
-	cq->front = (cq->front + 1)%MAX_CIRCULAR_QUE_SIZE;
+	cq->front = (cq->front + 1)&(MAX_CIRCULAR_QUE_SIZE-1);
 	return 0;
 }
 
 static inline int __cq_get_elem_count(struct circular_queue *cq)
 {
-	return (cq->rear - cq->front)%MAX_CIRCULAR_QUE_SIZE;
+	return (cq->rear - cq->front)&(MAX_CIRCULAR_QUE_SIZE-1);
 }
 
 static inline void mark_lock_accessed(struct lock_list *lock,
 					struct lock_list *parent)
 {
-	lock->parent = (void *) parent + LOCK_ACCESSED;
+	unsigned long nr;
+	nr = lock - list_entries;
+	WARN_ON(nr >= nr_list_entries);
+	lock->parent = parent;
+	set_bit(nr, bfs_accessed);
 }
 
 static inline unsigned long lock_accessed(struct lock_list *lock)
 {
-	return (unsigned long)lock->parent & LOCK_ACCESSED;
+	unsigned long nr;
+	nr = lock - list_entries;
+	WARN_ON(nr >= nr_list_entries);
+	return test_bit(nr, bfs_accessed);
 }
 
 static inline struct lock_list *get_lock_parent(struct lock_list *child)
 {
-	return (struct lock_list *)
-		((unsigned long)child->parent & LOCK_ACCESSED_MASK);
+	return child->parent;
 }
 
 static inline unsigned long get_lock_depth(struct lock_list *child)
