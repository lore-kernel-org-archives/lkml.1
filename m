Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbZF1PHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbZF1PHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 11:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757849AbZF1PG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 11:06:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:55103 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793AbZF1PG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 11:06:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KAOXVwhG5a6EDu5xGxbpJB4Zn0/pzA4K5icDbVGSWnSNSc623xpnobNkgRMQAah6ZZ
         rqDTtrmaD6r8JaeXWx5EQOtubWyNHtf69mFcUI2ajEdBD3azatmfQW2GVUV2QW+6ivYd
         FO7mmpjBCs2ztsGhPa4MtfxtuNJHd9fH+VNqQ=
From: tom.leiming@gmail.com
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       Ming Lei <tom.leiming@gmail.com>
Subject: [RESEND PATCH 10/11] BFS cleanup
Date: Sun, 28 Jun 2009 23:04:45 +0800
Message-Id: <1246201486-7308-11-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1246201486-7308-10-git-send-email-tom.leiming@gmail.com>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-2-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-3-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-4-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-5-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-6-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-7-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-8-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-9-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-10-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h    |    7 +-
 kernel/lockdep.c           |  232 +++++++++++++++++++++++++++-----------------
 kernel/lockdep_internals.h |   97 +------------------
 3 files changed, 147 insertions(+), 189 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 9ec026f..12aabfc 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -58,7 +58,6 @@ struct lock_class {
 
 	struct lockdep_subclass_key	*key;
 	unsigned int			subclass;
-	unsigned int			dep_gen_id;
 
 	/*
 	 * IRQ/softirq usage tracking bits:
@@ -150,9 +149,9 @@ struct lock_list {
 	struct stack_trace		trace;
 	int				distance;
 
-	/*The parent field is used to implement breadth-first search,and
-	 *the bit 0 is reused to indicate if the lock has been accessed
-	 *in BFS.
+	/*
+	 * The parent field is used to implement breadth-first search, and the
+	 * bit 0 is reused to indicate if the lock has been accessed in BFS.
 	 */
 	struct lock_list		*parent;
 };
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index b20f08b..09a141f 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -43,6 +43,7 @@
 #include <linux/ftrace.h>
 #include <linux/stringify.h>
 #include <linux/bitops.h>
+
 #include <asm/sections.h>
 
 #include "lockdep_internals.h"
@@ -118,7 +119,7 @@ static inline int debug_locks_off_graph_unlock(void)
 static int lockdep_initialized;
 
 unsigned long nr_list_entries;
-struct lock_list list_entries[MAX_LOCKDEP_ENTRIES];
+static struct lock_list list_entries[MAX_LOCKDEP_ENTRIES];
 
 /*
  * All data structures here are protected by the global debug_lock.
@@ -390,19 +391,6 @@ unsigned int nr_process_chains;
 unsigned int max_lockdep_depth;
 unsigned int max_recursion_depth;
 
-static unsigned int lockdep_dependency_gen_id;
-
-static bool lockdep_dependency_visit(struct lock_class *source,
-				     unsigned int depth)
-{
-	if (!depth)
-		lockdep_dependency_gen_id++;
-	if (source->dep_gen_id == lockdep_dependency_gen_id)
-		return true;
-	source->dep_gen_id = lockdep_dependency_gen_id;
-	return false;
-}
-
 #ifdef CONFIG_DEBUG_LOCKDEP
 /*
  * We cannot printk in early bootup code. Not even early_printk()
@@ -575,64 +563,6 @@ static void print_lock_class_header(struct lock_class *class, int depth)
 	print_ip_sym((unsigned long)class->key);
 }
 
-/*
- * printk the shortest lock dependencies from @start to @end in reverse order:
- */
-static void __used
-print_shortest_lock_dependencies(struct lock_list *leaf,
-				struct lock_list *root)
-{
-	struct lock_list *entry = leaf;
-	int depth;
-
-	/*compute depth from generated tree by BFS*/
-	depth = get_lock_depth(leaf);
-
-	do {
-		print_lock_class_header(entry->class, depth);
-		printk("%*s ... acquired at:\n", depth, "");
-		print_stack_trace(&entry->trace, 2);
-		printk("\n");
-
-		if (depth == 0 && (entry != root)) {
-			printk("lockdep:%s bad BFS generated tree\n", __func__);
-			break;
-		}
-
-		entry = get_lock_parent(entry);
-		depth--;
-	} while (entry && (depth >= 0));
-
-	return;
-}
-/*
- * printk all lock dependencies starting at <entry>:
- */
-static void __used
-print_lock_dependencies(struct lock_class *class, int depth)
-{
-	struct lock_list *entry;
-
-	if (lockdep_dependency_visit(class, depth))
-		return;
-
-	if (DEBUG_LOCKS_WARN_ON(depth >= 20))
-		return;
-
-	print_lock_class_header(class, depth);
-
-	list_for_each_entry(entry, &class->locks_after, entry) {
-		if (DEBUG_LOCKS_WARN_ON(!entry->class))
-			return;
-
-		print_lock_dependencies(entry->class, depth + 1);
-
-		printk("%*s ... acquired at:\n",depth,"");
-		print_stack_trace(&entry->trace, 2);
-		printk("\n");
-	}
-}
-
 static void print_kernel_version(void)
 {
 	printk("%s %.*s\n", init_utsname()->release,
@@ -927,14 +857,106 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
 	return 1;
 }
 
-unsigned long bfs_accessed[BITS_TO_LONGS(MAX_LOCKDEP_ENTRIES)];
-static struct circular_queue  lock_cq;
+/*For good efficiency of modular, we use power of 2*/
+#define MAX_CIRCULAR_QUEUE_SIZE		4096UL
+#define CQ_MASK				(MAX_CIRCULAR_QUEUE_SIZE-1)
+
+/* The circular_queue and helpers is used to implement the
+ * breadth-first search(BFS)algorithem, by which we can build
+ * the shortest path from the next lock to be acquired to the
+ * previous held lock if there is a circular between them.
+ * */
+struct circular_queue {
+	unsigned long element[MAX_CIRCULAR_QUEUE_SIZE];
+	unsigned int  front, rear;
+};
+
+static struct circular_queue lock_cq;
+static unsigned long bfs_accessed[BITS_TO_LONGS(MAX_LOCKDEP_ENTRIES)];
+
 unsigned int max_bfs_queue_depth;
+
+static inline void __cq_init(struct circular_queue *cq)
+{
+	cq->front = cq->rear = 0;
+	bitmap_zero(bfs_accessed, MAX_LOCKDEP_ENTRIES);
+}
+
+static inline int __cq_empty(struct circular_queue *cq)
+{
+	return (cq->front == cq->rear);
+}
+
+static inline int __cq_full(struct circular_queue *cq)
+{
+	return ((cq->rear + 1) & CQ_MASK) == cq->front;
+}
+
+static inline int __cq_enqueue(struct circular_queue *cq, unsigned long elem)
+{
+	if (__cq_full(cq))
+		return -1;
+
+	cq->element[cq->rear] = elem;
+	cq->rear = (cq->rear + 1) & CQ_MASK;
+	return 0;
+}
+
+static inline int __cq_dequeue(struct circular_queue *cq, unsigned long *elem)
+{
+	if (__cq_empty(cq))
+		return -1;
+
+	*elem = cq->element[cq->front];
+	cq->front = (cq->front + 1) & CQ_MASK;
+	return 0;
+}
+
+static inline unsigned int  __cq_get_elem_count(struct circular_queue *cq)
+{
+	return (cq->rear - cq->front) & CQ_MASK;
+}
+
+static inline void mark_lock_accessed(struct lock_list *lock,
+					struct lock_list *parent)
+{
+	unsigned long nr;
+	nr = lock - list_entries;
+	WARN_ON(nr >= nr_list_entries);
+	lock->parent = parent;
+	set_bit(nr, bfs_accessed);
+}
+
+static inline unsigned long lock_accessed(struct lock_list *lock)
+{
+	unsigned long nr;
+	nr = lock - list_entries;
+	WARN_ON(nr >= nr_list_entries);
+	return test_bit(nr, bfs_accessed);
+}
+
+static inline struct lock_list *get_lock_parent(struct lock_list *child)
+{
+	return child->parent;
+}
+
+static inline int get_lock_depth(struct lock_list *child)
+{
+	int depth = 0;
+	struct lock_list *parent;
+
+	while ((parent = get_lock_parent(child))) {
+		child = parent;
+		depth++;
+	}
+	return depth;
+}
+
 static int __bfs(struct lock_list *source_entry,
-			void *data,
-			int (*match)(struct lock_list *entry, void *data),
-			struct lock_list **target_entry,
-			int forward)
+		 void *data,
+		 int (*match)(struct lock_list *entry, void *data),
+		 struct lock_list **target_entry,
+		 int forward)
 {
 	struct lock_list *entry;
 	struct list_head *head;
@@ -1202,14 +1224,6 @@ check_noncircular(struct lock_list *root, struct lock_class *target,
  * without creating any illegal irq-safe -> irq-unsafe lock dependency.
  */
 
-
-#define   BFS_PROCESS_RET(ret)	do { \
-					if (ret < 0) \
-						return print_bfs_bug(ret); \
-					if (ret == 1) \
-						return 1; \
-				} while (0)
-
 static inline int usage_match(struct lock_list *entry, void *bit)
 {
 	return entry->class->usage_mask & (1 << (enum lock_usage_bit)bit);
@@ -1236,6 +1250,8 @@ find_usage_forwards(struct lock_list *root, enum lock_usage_bit bit,
 	debug_atomic_inc(&nr_find_usage_forwards_checks);
 
 	result = __bfs_forwards(root, (void *)bit, usage_match, target_entry);
+	if (result < 0)
+		return print_bfs_bug(result);
 
 	return result;
 }
@@ -1259,10 +1275,42 @@ find_usage_backwards(struct lock_list *root, enum lock_usage_bit bit,
 	debug_atomic_inc(&nr_find_usage_backwards_checks);
 
 	result = __bfs_backwards(root, (void *)bit, usage_match, target_entry);
+	if (result < 0)
+		return print_bfs_bug(result);
 
 	return result;
 }
 
+/*
+ * printk the shortest lock dependencies from @start to @end in reverse order:
+ */
+static void __used
+print_shortest_lock_dependencies(struct lock_list *leaf,
+				struct lock_list *root)
+{
+	struct lock_list *entry = leaf;
+	int depth;
+
+	/*compute depth from generated tree by BFS*/
+	depth = get_lock_depth(leaf);
+
+	do {
+		print_lock_class_header(entry->class, depth);
+		printk("%*s ... acquired at:\n", depth, "");
+		print_stack_trace(&entry->trace, 2);
+		printk("\n");
+
+		if (depth == 0 && (entry != root)) {
+			printk("lockdep:%s bad BFS generated tree\n", __func__);
+			break;
+		}
+
+		entry = get_lock_parent(entry);
+		depth--;
+	} while (entry && (depth >= 0));
+
+	return;
+}
 
 static int
 print_bad_irq_dependency(struct task_struct *curr,
@@ -1349,12 +1397,14 @@ check_usage(struct task_struct *curr, struct held_lock *prev,
 
 	this.class = hlock_class(prev);
 	ret = find_usage_backwards(&this, bit_backwards, &target_entry);
-	BFS_PROCESS_RET(ret);
+	if (!ret || ret == 1)
+		return ret;
 
 	that.parent = NULL;
 	that.class = hlock_class(next);
 	ret = find_usage_forwards(&that, bit_forwards, &target_entry1);
-	BFS_PROCESS_RET(ret);
+	if (!ret || ret == 1)
+		return ret;
 
 	return print_bad_irq_dependency(curr, &this, &that,
 			target_entry, target_entry1,
@@ -2038,7 +2088,8 @@ check_usage_forwards(struct task_struct *curr, struct held_lock *this,
 	root.parent = NULL;
 	root.class = hlock_class(this);
 	ret = find_usage_forwards(&root, bit, &target_entry);
-	BFS_PROCESS_RET(ret);
+	if (!ret || ret == 1)
+		return ret;
 
 	return print_irq_inversion_bug(curr, &root, target_entry,
 					this, 1, irqclass);
@@ -2059,7 +2110,8 @@ check_usage_backwards(struct task_struct *curr, struct held_lock *this,
 	root.parent = NULL;
 	root.class = hlock_class(this);
 	ret = find_usage_backwards(&root, bit, &target_entry);
-	BFS_PROCESS_RET(ret);
+	if (!ret || ret == 1)
+		return ret;
 
 	return print_irq_inversion_bug(curr, &root, target_entry,
 					this, 1, irqclass);
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 6baa880..a2ee95a 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -91,6 +91,8 @@ extern unsigned int nr_process_chains;
 extern unsigned int max_lockdep_depth;
 extern unsigned int max_recursion_depth;
 
+extern unsigned int max_bfs_queue_depth;
+
 #ifdef CONFIG_PROVE_LOCKING
 extern unsigned long lockdep_count_forward_deps(struct lock_class *);
 extern unsigned long lockdep_count_backward_deps(struct lock_class *);
@@ -136,98 +138,3 @@ extern atomic_t nr_find_usage_backwards_recursions;
 # define debug_atomic_dec(ptr)		do { } while (0)
 # define debug_atomic_read(ptr)		0
 #endif
-
-
-extern unsigned int max_bfs_queue_depth;
-extern unsigned long nr_list_entries;
-extern struct lock_list list_entries[MAX_LOCKDEP_ENTRIES];
-extern unsigned long bfs_accessed[];
-
-/*For good efficiency of modular, we use power of 2*/
-#define  MAX_CIRCULAR_QUE_SIZE	    4096UL
-
-/* The circular_queue and helpers is used to implement the
- * breadth-first search(BFS)algorithem, by which we can build
- * the shortest path from the next lock to be acquired to the
- * previous held lock if there is a circular between them.
- * */
-struct circular_queue{
-	unsigned long element[MAX_CIRCULAR_QUE_SIZE];
-	unsigned int  front, rear;
-};
-
-static inline void __cq_init(struct circular_queue *cq)
-{
-	cq->front = cq->rear = 0;
-	bitmap_zero(bfs_accessed, MAX_LOCKDEP_ENTRIES);
-}
-
-static inline int __cq_empty(struct circular_queue *cq)
-{
-	return (cq->front == cq->rear);
-}
-
-static inline int __cq_full(struct circular_queue *cq)
-{
-	return ((cq->rear + 1)&(MAX_CIRCULAR_QUE_SIZE-1))  == cq->front;
-}
-
-static inline int __cq_enqueue(struct circular_queue *cq, unsigned long elem)
-{
-	if (__cq_full(cq))
-		return -1;
-
-	cq->element[cq->rear] = elem;
-	cq->rear = (cq->rear + 1)&(MAX_CIRCULAR_QUE_SIZE-1);
-	return 0;
-}
-
-static inline int __cq_dequeue(struct circular_queue *cq, unsigned long *elem)
-{
-	if (__cq_empty(cq))
-		return -1;
-
-	*elem = cq->element[cq->front];
-	cq->front = (cq->front + 1)&(MAX_CIRCULAR_QUE_SIZE-1);
-	return 0;
-}
-
-static inline unsigned int  __cq_get_elem_count(struct circular_queue *cq)
-{
-	return (cq->rear - cq->front)&(MAX_CIRCULAR_QUE_SIZE-1);
-}
-
-static inline void mark_lock_accessed(struct lock_list *lock,
-					struct lock_list *parent)
-{
-	unsigned long nr;
-	nr = lock - list_entries;
-	WARN_ON(nr >= nr_list_entries);
-	lock->parent = parent;
-	set_bit(nr, bfs_accessed);
-}
-
-static inline unsigned long lock_accessed(struct lock_list *lock)
-{
-	unsigned long nr;
-	nr = lock - list_entries;
-	WARN_ON(nr >= nr_list_entries);
-	return test_bit(nr, bfs_accessed);
-}
-
-static inline struct lock_list *get_lock_parent(struct lock_list *child)
-{
-	return child->parent;
-}
-
-static inline int get_lock_depth(struct lock_list *child)
-{
-	int depth = 0;
-	struct lock_list *parent;
-
-	while ((parent = get_lock_parent(child))) {
-		child = parent;
-		depth++;
-	}
-	return depth;
-}
-- 
1.6.0.GIT

