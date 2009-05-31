Return-Path: <linux-kernel-owner+w=401wt.eu-S1759173AbZEaOu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173AbZEaOu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758376AbZEaOt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:49:59 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:64422 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758918AbZEaOt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:49:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mxkFjLsy8ZPtjk1j10LtnJO/0vr2rMURSzxsG9Fv1pqmlFMVfC63CRtRgNqqTH/GGQ
         AEQlQNJG8JleaOvj/JKDmR+ODToLBx2fogSFGaHtMdN1GYaLAcfe52tD7DwddRAv3sIn
         IX5y2liDyxexBg8HJSjrFetxCVR8yF2fyUlb8=
From: tom.leiming@gmail.com
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 3/8] kernel:lockdep:implement check_noncircular() by BFS
Date: Sun, 31 May 2009 22:49:20 +0800
Message-Id: <1243781365-26814-4-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1243781365-26814-3-git-send-email-tom.leiming@gmail.com>
References: <yes>
 <1243781365-26814-1-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-2-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-3-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch uses BFS to implement check_noncircular() and
prints the generated shortest circle if exists.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 kernel/lockdep.c |   89 ++++++++++++++++++++++-------------------------------
 1 files changed, 37 insertions(+), 52 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index ce6d09e..f740088 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -985,12 +985,7 @@ static inline int __bfs_backward(struct lock_list *src_entry,
  * Recursive, forwards-direction lock-dependency checking, used for
  * both noncyclic checking and for hardirq-unsafe/softirq-unsafe
  * checking.
- *
- * (to keep the stackframe of the recursive functions small we
- *  use these global variables, and we also mark various helper
- *  functions as noinline.)
  */
-static struct held_lock *check_source, *check_target;
 
 /*
  * Print a dependency chain entry (this is only done when a deadlock
@@ -1014,7 +1009,9 @@ print_circular_bug_entry(struct lock_list *target, unsigned int depth)
  * header first:
  */
 static noinline int
-print_circular_bug_header(struct lock_list *entry, unsigned int depth)
+print_circular_bug_header(struct lock_list *entry, unsigned int depth,
+			struct held_lock *check_src,
+			struct held_lock *check_tgt)
 {
 	struct task_struct *curr = current;
 
@@ -1027,9 +1024,9 @@ print_circular_bug_header(struct lock_list *entry, unsigned int depth)
 	printk(  "-------------------------------------------------------\n");
 	printk("%s/%d is trying to acquire lock:\n",
 		curr->comm, task_pid_nr(curr));
-	print_lock(check_source);
+	print_lock(check_src);
 	printk("\nbut task is already holding lock:\n");
-	print_lock(check_target);
+	print_lock(check_tgt);
 	printk("\nwhich lock already depends on the new lock.\n\n");
 	printk("\nthe existing dependency chain (in reverse order) is:\n");
 
@@ -1043,36 +1040,24 @@ static inline int class_equal(struct lock_list *entry, void *data)
 	return entry->class == data;
 }
 
-static noinline int print_circular_bug(void)
+static noinline int print_circular_bug(struct lock_list *this,
+				struct lock_list *target,
+				struct held_lock *check_src,
+				struct held_lock *check_tgt)
 {
 	struct task_struct *curr = current;
-	struct lock_list this;
-	struct lock_list *target;
 	struct lock_list *parent;
-	int result;
 	unsigned long depth;
 
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
-	this.class = hlock_class(check_source);
-	this.parent = NULL;
-	if (!save_trace(&this.trace))
+	if (!save_trace(&this->trace))
 		return 0;
 
-	result = __bfs_forward(&this,
-			hlock_class(check_target),
-			class_equal,
-			&target);
-	if (result) {
-		printk("\n%s:search shortest path failed:%d\n", __func__,
-			result);
-		return 0;
-	}
-
 	depth = get_lock_depth(target);
 
-	print_circular_bug_header(target, depth);
+	print_circular_bug_header(target, depth, check_src, check_tgt);
 
 	parent = get_lock_parent(target);
 
@@ -1090,6 +1075,16 @@ static noinline int print_circular_bug(void)
 	return 0;
 }
 
+static int noinline print_bfs_bug(int ret)
+{
+	if (!debug_locks_off_graph_unlock())
+		return 0;
+
+	WARN(1, "lockdep bfs error:%d\n", ret);
+
+	return 0;
+}
+
 #define RECURSION_LIMIT 40
 
 static int noinline print_infinite_recursion_bug(void)
@@ -1168,31 +1163,17 @@ unsigned long lockdep_count_backward_deps(struct lock_class *class)
  * lead to <target>. Print an error and return 0 if it does.
  */
 static noinline int
-check_noncircular(struct lock_class *source, unsigned int depth)
+check_noncircular(struct lock_list *root, struct lock_class *target,
+		struct lock_list **target_entry)
 {
-	struct lock_list *entry;
+	int result;
 
-	if (lockdep_dependency_visit(source, depth))
-		return 1;
+	debug_atomic_inc(&nr_cyclic_checks);
 
-	debug_atomic_inc(&nr_cyclic_check_recursions);
-	if (depth > max_recursion_depth)
-		max_recursion_depth = depth;
-	if (depth >= RECURSION_LIMIT)
-		return print_infinite_recursion_bug();
-	/*
-	 * Check this lock's dependency list:
-	 */
-	list_for_each_entry(entry, &source->locks_after, entry) {
-		if (entry->class == hlock_class(check_target))
-			return 2;
-		debug_atomic_inc(&nr_cyclic_checks);
-		if (check_noncircular(entry->class, depth+1) == 2)
-			return 2;
-	}
-	return 1;
-}
+	result = __bfs_forward(root, target, class_equal, target_entry);
 
+	return result;
+}
 
 #if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_PROVE_LOCKING)
 /*
@@ -1586,6 +1567,8 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 {
 	struct lock_list *entry;
 	int ret;
+	struct lock_list this;
+	struct lock_list *uninitialized_var(target_entry);
 
 	/*
 	 * Prove that the new <prev> -> <next> dependency would not
@@ -1596,11 +1579,13 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 * We are using global variables to control the recursion, to
 	 * keep the stackframe size of the recursive functions low:
 	 */
-	check_source = next;
-	check_target = prev;
-
-	if (check_noncircular(hlock_class(next), 0) == 2)
-		return print_circular_bug();
+	this.class = hlock_class(next);
+	this.parent = NULL;
+	ret = check_noncircular(&this, hlock_class(prev), &target_entry);
+	if (unlikely(!ret))
+		return print_circular_bug(&this, target_entry, next, prev);
+	else if (unlikely(ret < 0))
+		return print_bfs_bug(ret);
 
 	if (!check_prev_add_irq(curr, prev, next))
 		return 0;
-- 
1.6.0.GIT

