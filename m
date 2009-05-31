Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbZEaOuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbZEaOuq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758966AbZEaOuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:50:09 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:64422 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758900AbZEaOuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:50:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lw1kQV5wKpZxb1DCjtmxaJMrOyGXjyQMfQczGhysLtH0dMLuMGc1D66+kOYVmdEuME
         +MWlaVZIEcBY3Zc8PSZ7dV9Ev0AkZrAqOe2zRZCwkU1JvdfV99wXFnO4spUHmLApSPpG
         mQDrSlVzcnwF6jcEDjSlnaaLmpIjuxCQ6LPW8=
From: tom.leiming@gmail.com
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 4/8] kernel:lockdep:implement find_usage_*wards by BFS
Date: Sun, 31 May 2009 22:49:21 +0800
Message-Id: <1243781365-26814-5-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1243781365-26814-4-git-send-email-tom.leiming@gmail.com>
References: <yes>
 <1243781365-26814-1-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-2-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-3-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-4-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch uses BFS to implement find_usage_*wards(),which
was originally writen by DFS.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 kernel/lockdep.c |  180 ++++++++++++++++++++++--------------------------------
 1 files changed, 72 insertions(+), 108 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index f740088..94b2f1f 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -963,7 +963,7 @@ exit:
 	return ret;
 }
 
-static inline int __bfs_forward(struct lock_list *src_entry,
+static inline int __bfs_forwards(struct lock_list *src_entry,
 			void *data,
 			int (*match)(struct lock_list *entry, void *data),
 			struct lock_list **target_entry)
@@ -972,7 +972,7 @@ static inline int __bfs_forward(struct lock_list *src_entry,
 
 }
 
-static inline int __bfs_backward(struct lock_list *src_entry,
+static inline int __bfs_backwards(struct lock_list *src_entry,
 			void *data,
 			int (*match)(struct lock_list *entry, void *data),
 			struct lock_list **target_entry)
@@ -1085,18 +1085,6 @@ static int noinline print_bfs_bug(int ret)
 	return 0;
 }
 
-#define RECURSION_LIMIT 40
-
-static int noinline print_infinite_recursion_bug(void)
-{
-	if (!debug_locks_off_graph_unlock())
-		return 0;
-
-	WARN_ON(1);
-
-	return 0;
-}
-
 unsigned long __lockdep_count_forward_deps(struct lock_class *class,
 					   unsigned int depth)
 {
@@ -1170,7 +1158,7 @@ check_noncircular(struct lock_list *root, struct lock_class *target,
 
 	debug_atomic_inc(&nr_cyclic_checks);
 
-	result = __bfs_forward(root, target, class_equal, target_entry);
+	result = __bfs_forwards(root, target, class_equal, target_entry);
 
 	return result;
 }
@@ -1181,101 +1169,70 @@ check_noncircular(struct lock_list *root, struct lock_class *target,
  * proving that two subgraphs can be connected by a new dependency
  * without creating any illegal irq-safe -> irq-unsafe lock dependency.
  */
-static enum lock_usage_bit find_usage_bit;
 static struct lock_class *forwards_match, *backwards_match;
 
+
+#define   BFS_PROCESS_RET(ret)	do { \
+					if (ret < 0) \
+						return print_bfs_bug(ret); \
+					if (ret == 1) \
+						return 1; \
+				} while (0)
+
+static inline int usage_match(struct lock_list *entry, void *bit)
+{
+	return entry->class->usage_mask & (1 << (enum lock_usage_bit)bit);
+}
+
+
+
 /*
  * Find a node in the forwards-direction dependency sub-graph starting
- * at <source> that matches <find_usage_bit>.
+ * at @root->class that matches @bit.
  *
- * Return 2 if such a node exists in the subgraph, and put that node
- * into <forwards_match>.
+ * Return 0 if such a node exists in the subgraph, and put that node
+ * into *@target_entry.
  *
- * Return 1 otherwise and keep <forwards_match> unchanged.
- * Return 0 on error.
+ * Return 1 otherwise and keep *@target_entry unchanged.
+ * Return <0 on error.
  */
-static noinline int
-find_usage_forwards(struct lock_class *source, unsigned int depth)
+static int
+find_usage_forwards(struct lock_list *root, enum lock_usage_bit bit,
+			struct lock_list **target_entry)
 {
-	struct lock_list *entry;
-	int ret;
-
-	if (lockdep_dependency_visit(source, depth))
-		return 1;
-
-	if (depth > max_recursion_depth)
-		max_recursion_depth = depth;
-	if (depth >= RECURSION_LIMIT)
-		return print_infinite_recursion_bug();
+	int result;
 
 	debug_atomic_inc(&nr_find_usage_forwards_checks);
-	if (source->usage_mask & (1 << find_usage_bit)) {
-		forwards_match = source;
-		return 2;
-	}
 
-	/*
-	 * Check this lock's dependency list:
-	 */
-	list_for_each_entry(entry, &source->locks_after, entry) {
-		debug_atomic_inc(&nr_find_usage_forwards_recursions);
-		ret = find_usage_forwards(entry->class, depth+1);
-		if (ret == 2 || ret == 0)
-			return ret;
-	}
-	return 1;
+	result = __bfs_forwards(root, (void *)bit, usage_match, target_entry);
+
+	return result;
 }
 
 /*
  * Find a node in the backwards-direction dependency sub-graph starting
- * at <source> that matches <find_usage_bit>.
+ * at @root->class that matches @bit.
  *
- * Return 2 if such a node exists in the subgraph, and put that node
- * into <backwards_match>.
+ * Return 0 if such a node exists in the subgraph, and put that node
+ * into *@target_entry.
  *
- * Return 1 otherwise and keep <backwards_match> unchanged.
- * Return 0 on error.
+ * Return 1 otherwise and keep *@target_entry unchanged.
+ * Return <0 on error.
  */
-static noinline int
-find_usage_backwards(struct lock_class *source, unsigned int depth)
+static int
+find_usage_backwards(struct lock_list *root, enum lock_usage_bit bit,
+			struct lock_list **target_entry)
 {
-	struct lock_list *entry;
-	int ret;
-
-	if (lockdep_dependency_visit(source, depth))
-		return 1;
-
-	if (!__raw_spin_is_locked(&lockdep_lock))
-		return DEBUG_LOCKS_WARN_ON(1);
-
-	if (depth > max_recursion_depth)
-		max_recursion_depth = depth;
-	if (depth >= RECURSION_LIMIT)
-		return print_infinite_recursion_bug();
+	int result;
 
 	debug_atomic_inc(&nr_find_usage_backwards_checks);
-	if (source->usage_mask & (1 << find_usage_bit)) {
-		backwards_match = source;
-		return 2;
-	}
 
-	if (!source && debug_locks_off_graph_unlock()) {
-		WARN_ON(1);
-		return 0;
-	}
+	result = __bfs_backwards(root, (void *)bit, usage_match, target_entry);
 
-	/*
-	 * Check this lock's dependency list:
-	 */
-	list_for_each_entry(entry, &source->locks_before, entry) {
-		debug_atomic_inc(&nr_find_usage_backwards_recursions);
-		ret = find_usage_backwards(entry->class, depth+1);
-		if (ret == 2 || ret == 0)
-			return ret;
-	}
-	return 1;
+	return result;
 }
 
+
 static int
 print_bad_irq_dependency(struct task_struct *curr,
 			 struct held_lock *prev,
@@ -1343,18 +1300,21 @@ check_usage(struct task_struct *curr, struct held_lock *prev,
 	    enum lock_usage_bit bit_forwards, const char *irqclass)
 {
 	int ret;
+	struct lock_list this;
+	struct lock_list *uninitialized_var(target_entry);
+
+	this.parent = NULL;
+
+	this.class = hlock_class(prev);
+	ret = find_usage_backwards(&this, bit_backwards, &target_entry);
+	BFS_PROCESS_RET(ret);
+	backwards_match = target_entry->class;
+
+	this.class = hlock_class(next);
+	ret = find_usage_forwards(&this, bit_forwards, &target_entry);
+	BFS_PROCESS_RET(ret);
+	forwards_match = target_entry->class;
 
-	find_usage_bit = bit_backwards;
-	/* fills in <backwards_match> */
-	ret = find_usage_backwards(hlock_class(prev), 0);
-	if (!ret || ret == 1)
-		return ret;
-
-	find_usage_bit = bit_forwards;
-	ret = find_usage_forwards(hlock_class(next), 0);
-	if (!ret || ret == 1)
-		return ret;
-	/* ret == 2 */
 	return print_bad_irq_dependency(curr, prev, next,
 			bit_backwards, bit_forwards, irqclass);
 }
@@ -2029,14 +1989,16 @@ check_usage_forwards(struct task_struct *curr, struct held_lock *this,
 		     enum lock_usage_bit bit, const char *irqclass)
 {
 	int ret;
+	struct lock_list root;
+	struct lock_list *uninitialized_var(target_entry);
 
-	find_usage_bit = bit;
-	/* fills in <forwards_match> */
-	ret = find_usage_forwards(hlock_class(this), 0);
-	if (!ret || ret == 1)
-		return ret;
+	root.parent = NULL;
+	root.class = hlock_class(this);
+	ret = find_usage_forwards(&root, bit, &target_entry);
+	BFS_PROCESS_RET(ret);
 
-	return print_irq_inversion_bug(curr, forwards_match, this, 1, irqclass);
+	return print_irq_inversion_bug(curr, target_entry->class,
+					this, 1, irqclass);
 }
 
 /*
@@ -2048,14 +2010,16 @@ check_usage_backwards(struct task_struct *curr, struct held_lock *this,
 		      enum lock_usage_bit bit, const char *irqclass)
 {
 	int ret;
+	struct lock_list root;
+	struct lock_list *uninitialized_var(target_entry);
 
-	find_usage_bit = bit;
-	/* fills in <backwards_match> */
-	ret = find_usage_backwards(hlock_class(this), 0);
-	if (!ret || ret == 1)
-		return ret;
+	root.parent = NULL;
+	root.class = hlock_class(this);
+	ret = find_usage_backwards(&root, bit, &target_entry);
+	BFS_PROCESS_RET(ret);
 
-	return print_irq_inversion_bug(curr, backwards_match, this, 0, irqclass);
+	return print_irq_inversion_bug(curr, target_entry->class,
+					this, 1, irqclass);
 }
 
 void print_irqtrace_events(struct task_struct *curr)
-- 
1.6.0.GIT

