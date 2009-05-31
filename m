Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbZEaOu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbZEaOu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759161AbZEaOuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:50:18 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:45632 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759174AbZEaOuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:50:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lndAAIfkqWnHx8EV8tQfgrFVEyb0Qs2J4zwSXzX5jL5/pQ1/GMZeTFjwn++behFWe7
         PSJnl7xIhEiZ6KQIbsWZvia0Oobag8GQiF7fBoJ9gJ+NuFfpvpp3tptCd5cdjg+qpAB1
         qPerFaeaCf/lWhmCYXlu4+mEcxIVdI1XSii7w=
From: tom.leiming@gmail.com
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 5/8] kernel:lockdep:introduce print_shortest_lock_dependencies
Date: Sun, 31 May 2009 22:49:22 +0800
Message-Id: <1243781365-26814-6-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1243781365-26814-5-git-send-email-tom.leiming@gmail.com>
References: <yes>
 <1243781365-26814-1-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-2-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-3-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-4-git-send-email-tom.leiming@gmail.com>
 <1243781365-26814-5-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Since the shortest lock dependencies' path may be obtained by BFS,
we print the shortest one by print_shortest_lock_dependencies().

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 kernel/lockdep.c           |   93 +++++++++++++++++++++++++++++++------------
 kernel/lockdep_internals.h |    4 +-
 2 files changed, 69 insertions(+), 28 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 94b2f1f..d839994 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -576,6 +576,36 @@ static void print_lock_class_header(struct lock_class *class, int depth)
 }
 
 /*
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
+/*
  * printk all lock dependencies starting at <entry>:
  */
 static void __used
@@ -992,7 +1022,7 @@ static inline int __bfs_backwards(struct lock_list *src_entry,
  * has been detected):
  */
 static noinline int
-print_circular_bug_entry(struct lock_list *target, unsigned int depth)
+print_circular_bug_entry(struct lock_list *target, int depth)
 {
 	if (debug_locks_silent)
 		return 0;
@@ -1047,7 +1077,7 @@ static noinline int print_circular_bug(struct lock_list *this,
 {
 	struct task_struct *curr = current;
 	struct lock_list *parent;
-	unsigned long depth;
+	int depth;
 
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
@@ -1169,7 +1199,6 @@ check_noncircular(struct lock_list *root, struct lock_class *target,
  * proving that two subgraphs can be connected by a new dependency
  * without creating any illegal irq-safe -> irq-unsafe lock dependency.
  */
-static struct lock_class *forwards_match, *backwards_match;
 
 
 #define   BFS_PROCESS_RET(ret)	do { \
@@ -1235,6 +1264,10 @@ find_usage_backwards(struct lock_list *root, enum lock_usage_bit bit,
 
 static int
 print_bad_irq_dependency(struct task_struct *curr,
+			 struct lock_list *prev_root,
+			 struct lock_list *next_root,
+			 struct lock_list *backwards_entry,
+			 struct lock_list *forwards_entry,
 			 struct held_lock *prev,
 			 struct held_lock *next,
 			 enum lock_usage_bit bit1,
@@ -1267,26 +1300,32 @@ print_bad_irq_dependency(struct task_struct *curr,
 
 	printk("\nbut this new dependency connects a %s-irq-safe lock:\n",
 		irqclass);
-	print_lock_name(backwards_match);
+	print_lock_name(backwards_entry->class);
 	printk("\n... which became %s-irq-safe at:\n", irqclass);
 
-	print_stack_trace(backwards_match->usage_traces + bit1, 1);
+	print_stack_trace(backwards_entry->class->usage_traces + bit1, 1);
 
 	printk("\nto a %s-irq-unsafe lock:\n", irqclass);
-	print_lock_name(forwards_match);
+	print_lock_name(forwards_entry->class);
 	printk("\n... which became %s-irq-unsafe at:\n", irqclass);
 	printk("...");
 
-	print_stack_trace(forwards_match->usage_traces + bit2, 1);
+	print_stack_trace(forwards_entry->class->usage_traces + bit2, 1);
 
 	printk("\nother info that might help us debug this:\n\n");
 	lockdep_print_held_locks(curr);
 
-	printk("\nthe %s-irq-safe lock's dependencies:\n", irqclass);
-	print_lock_dependencies(backwards_match, 0);
+	printk("\nthe dependencies between %s-irq-safe lock", irqclass);
+	printk(" and the holding lock:\n");
+	if (!save_trace(&prev_root->trace))
+		return 0;
+	print_shortest_lock_dependencies(backwards_entry, prev_root);
 
-	printk("\nthe %s-irq-unsafe lock's dependencies:\n", irqclass);
-	print_lock_dependencies(forwards_match, 0);
+	printk("\nthe dependencies between the lock to be acquired");
+	printk(" and %s-irq-unsafe lock:\n", irqclass);
+	if (!save_trace(&next_root->trace))
+		return 0;
+	print_shortest_lock_dependencies(forwards_entry, next_root);
 
 	printk("\nstack backtrace:\n");
 	dump_stack();
@@ -1300,22 +1339,24 @@ check_usage(struct task_struct *curr, struct held_lock *prev,
 	    enum lock_usage_bit bit_forwards, const char *irqclass)
 {
 	int ret;
-	struct lock_list this;
+	struct lock_list this, that;
 	struct lock_list *uninitialized_var(target_entry);
+	struct lock_list *uninitialized_var(target_entry1);
 
 	this.parent = NULL;
 
 	this.class = hlock_class(prev);
 	ret = find_usage_backwards(&this, bit_backwards, &target_entry);
 	BFS_PROCESS_RET(ret);
-	backwards_match = target_entry->class;
 
-	this.class = hlock_class(next);
-	ret = find_usage_forwards(&this, bit_forwards, &target_entry);
+	that.parent = NULL;
+	that.class = hlock_class(next);
+	ret = find_usage_forwards(&that, bit_forwards, &target_entry1);
 	BFS_PROCESS_RET(ret);
-	forwards_match = target_entry->class;
 
-	return print_bad_irq_dependency(curr, prev, next,
+	return print_bad_irq_dependency(curr, &this, &that,
+			target_entry, target_entry1,
+			prev, next,
 			bit_backwards, bit_forwards, irqclass);
 }
 
@@ -1944,7 +1985,8 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
  * print irq inversion bug:
  */
 static int
-print_irq_inversion_bug(struct task_struct *curr, struct lock_class *other,
+print_irq_inversion_bug(struct task_struct *curr,
+			struct lock_list *root, struct lock_list *other,
 			struct held_lock *this, int forwards,
 			const char *irqclass)
 {
@@ -1962,17 +2004,16 @@ print_irq_inversion_bug(struct task_struct *curr, struct lock_class *other,
 		printk("but this lock took another, %s-unsafe lock in the past:\n", irqclass);
 	else
 		printk("but this lock was taken by another, %s-safe lock in the past:\n", irqclass);
-	print_lock_name(other);
+	print_lock_name(other->class);
 	printk("\n\nand interrupts could create inverse lock ordering between them.\n\n");
 
 	printk("\nother info that might help us debug this:\n");
 	lockdep_print_held_locks(curr);
 
-	printk("\nthe first lock's dependencies:\n");
-	print_lock_dependencies(hlock_class(this), 0);
-
-	printk("\nthe second lock's dependencies:\n");
-	print_lock_dependencies(other, 0);
+	printk("\nthe shortest dependencies between 2nd lock and 1st lock:\n");
+	if (!save_trace(&root->trace))
+		return 0;
+	print_shortest_lock_dependencies(other, root);
 
 	printk("\nstack backtrace:\n");
 	dump_stack();
@@ -1997,7 +2038,7 @@ check_usage_forwards(struct task_struct *curr, struct held_lock *this,
 	ret = find_usage_forwards(&root, bit, &target_entry);
 	BFS_PROCESS_RET(ret);
 
-	return print_irq_inversion_bug(curr, target_entry->class,
+	return print_irq_inversion_bug(curr, &root, target_entry,
 					this, 1, irqclass);
 }
 
@@ -2018,7 +2059,7 @@ check_usage_backwards(struct task_struct *curr, struct held_lock *this,
 	ret = find_usage_backwards(&root, bit, &target_entry);
 	BFS_PROCESS_RET(ret);
 
-	return print_irq_inversion_bug(curr, target_entry->class,
+	return print_irq_inversion_bug(curr, &root, target_entry,
 					this, 1, irqclass);
 }
 
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index c2f6594..b115aaa 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -219,9 +219,9 @@ static inline struct lock_list *get_lock_parent(struct lock_list *child)
 	return child->parent;
 }
 
-static inline unsigned long get_lock_depth(struct lock_list *child)
+static inline int get_lock_depth(struct lock_list *child)
 {
-	unsigned long depth = 0;
+	int depth = 0;
 	struct lock_list *parent;
 
 	while ((parent = get_lock_parent(child))) {
-- 
1.6.0.GIT

