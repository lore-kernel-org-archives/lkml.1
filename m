Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbYG3EpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbYG3EpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 00:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYG3EpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 00:45:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41664
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751050AbYG3EpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 00:45:07 -0400
Date: Tue, 29 Jul 2008 21:45:03 -0700 (PDT)
Message-Id: <20080729.214503.126934382.davem@davemloft.net>
To: mingo@elte.hu
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: combinatorial explosion in lockdep
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080728.174415.154327359.davem@davemloft.net>
References: <20080728.161318.38361710.davem@davemloft.net>
	<20080728235133.GA7956@elte.hu>
	<20080728.174415.154327359.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 28 Jul 2008 17:44:15 -0700 (PDT)

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 29 Jul 2008 01:51:33 +0200
> 
> > Any chance to get the "cat /proc/lockdep*" output, so that we could see 
> > and check the expected behavior of the full graph?
> 
> /proc/lockdep loops forever in count_forward_deps() :-)
> 
> I was able to capture a copy of lockdep_chains:
> 
> http://vger.kernel.org/~davem/lockdep_chains.bz2

As a followup I dumped the full backwards search graph once the cost
got up to about (1 * 1024 * 1024) checks or so.

I didn't find any loops, but it is clear that the cost is huge because
of the runqueue lock double-locking, without the generation count
patch I posted the other day.

For example, if you start with the first runqueue lock you search one
entry:

	1

Next, if you start with the second runqueue lock you search two
entries:

	2, 1

Next, if you start with the third runqueue lock you search
4 entries:

	3, 2, 1, 1

And the next series is:

	4, 3, 2, 1, 1, 2, 1, 1

and so on and so forth.  So the cost of a full backwards graph
traversal for N cpus is on the order of "1 << (N - 1)".  So with just
32 cpus the cost is on the order of a few billions of checks.

And then you have to factor in all of those runqueue locks's backwards
graphs that don't involve other runqueue locks (on my machine each
such sub-graph is about 200 locks deep).

Here is an updated version of my patch to solve this problem.  The only
unnice bit is that I had to move the procfs dep counting code into
lockdep.c and run it under the lockdep_lock.  This is the only way to
safely employ the dependency generation ID marking algorithm the
short-circuiting uses.

If we can agree on this as a fix, it should definitely be backported
and submitted for -stable :-)

----------------------------------------

lockdep: Fix combinatorial explosion in lock subgraph traversal.

When we traverse the graph, either forwards or backwards, we
are interested in whether a certain property exists somewhere
in a node reachable in the graph.

Therefore it is never necessary to traverse through a node more
than once to get a correct answer to the given query.

Take advantage of this property using a global ID counter so that we
need not clear all the markers in all the lock_class entries before
doing a traversal.  A new ID is choosen when we start to traverse, and
we continue through a lock_class only if it's ID hasn't been marked
with the new value yet.

This short-circuiting is essential especially for high CPU count
systems.  The scheduler has a runqueue per cpu, and needs to take
two runqueue locks at a time, which leads to long chains of
backwards and forwards subgraphs from these runqueue lock nodes.
Without the short-circuit implemented here, a graph traversal on
a runqueue lock can take up to (1 << (N - 1)) checks on a system
with N cpus.

For anything more than 16 cpus or so, lockdep will eventually bring
the machine to a complete standstill.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 2486eb4..1bfdc30 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -89,6 +89,7 @@ struct lock_class {
 
 	struct lockdep_subclass_key	*key;
 	unsigned int			subclass;
+	unsigned int			dep_gen_id;
 
 	/*
 	 * IRQ/softirq usage tracking bits:
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index d38a643..6999e64 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -372,6 +372,19 @@ unsigned int nr_process_chains;
 unsigned int max_lockdep_depth;
 unsigned int max_recursion_depth;
 
+static unsigned int lockdep_dependency_gen_id;
+
+static bool lockdep_dependency_visit(struct lock_class *source,
+				     unsigned int depth)
+{
+	if (!depth)
+		lockdep_dependency_gen_id++;
+	if (source->dep_gen_id == lockdep_dependency_gen_id)
+		return true;
+	source->dep_gen_id = lockdep_dependency_gen_id;
+	return false;
+}
+
 #ifdef CONFIG_DEBUG_LOCKDEP
 /*
  * We cannot printk in early bootup code. Not even early_printk()
@@ -558,6 +571,9 @@ static void print_lock_dependencies(struct lock_class *class, int depth)
 {
 	struct lock_list *entry;
 
+	if (lockdep_dependency_visit(class, depth))
+		return;
+
 	if (DEBUG_LOCKS_WARN_ON(depth >= 20))
 		return;
 
@@ -959,6 +975,67 @@ static int noinline print_infinite_recursion_bug(void)
 	return 0;
 }
 
+unsigned long __lockdep_count_forward_deps(struct lock_class *class,
+					   unsigned int depth)
+{
+	struct lock_list *entry;
+	unsigned long ret = 1;
+
+	if (lockdep_dependency_visit(class, depth))
+		return 0;
+
+	/*
+	 * Recurse this class's dependency list:
+	 */
+	list_for_each_entry(entry, &class->locks_after, entry)
+		ret += __lockdep_count_forward_deps(entry->class, depth + 1);
+
+	return ret;
+}
+
+unsigned long lockdep_count_forward_deps(struct lock_class *class)
+{
+	unsigned long ret, flags;
+
+	local_irq_save(flags);
+	__raw_spin_lock(&lockdep_lock);
+	ret = __lockdep_count_forward_deps(class, 0);
+	__raw_spin_unlock(&lockdep_lock);
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+unsigned long __lockdep_count_backward_deps(struct lock_class *class,
+					    unsigned int depth)
+{
+	struct lock_list *entry;
+	unsigned long ret = 1;
+
+	if (lockdep_dependency_visit(class, depth))
+		return 0;
+	/*
+	 * Recurse this class's dependency list:
+	 */
+	list_for_each_entry(entry, &class->locks_before, entry)
+		ret += __lockdep_count_backward_deps(entry->class, depth + 1);
+
+	return ret;
+}
+
+unsigned long lockdep_count_backward_deps(struct lock_class *class)
+{
+	unsigned long ret, flags;
+
+	local_irq_save(flags);
+	__raw_spin_lock(&lockdep_lock);
+	ret = __lockdep_count_backward_deps(class, 0);
+	__raw_spin_unlock(&lockdep_lock);
+	local_irq_restore(flags);
+
+	return ret;
+}
+
 /*
  * Prove that the dependency graph starting at <entry> can not
  * lead to <target>. Print an error and return 0 if it does.
@@ -968,6 +1045,9 @@ check_noncircular(struct lock_class *source, unsigned int depth)
 {
 	struct lock_list *entry;
 
+	if (lockdep_dependency_visit(source, depth))
+		return 1;
+
 	debug_atomic_inc(&nr_cyclic_check_recursions);
 	if (depth > max_recursion_depth)
 		max_recursion_depth = depth;
@@ -1011,6 +1091,9 @@ find_usage_forwards(struct lock_class *source, unsigned int depth)
 	struct lock_list *entry;
 	int ret;
 
+	if (lockdep_dependency_visit(source, depth))
+		return 1;
+
 	if (depth > max_recursion_depth)
 		max_recursion_depth = depth;
 	if (depth >= RECURSION_LIMIT)
@@ -1050,6 +1133,9 @@ find_usage_backwards(struct lock_class *source, unsigned int depth)
 	struct lock_list *entry;
 	int ret;
 
+	if (lockdep_dependency_visit(source, depth))
+		return 1;
+
 	if (!__raw_spin_is_locked(&lockdep_lock))
 		return DEBUG_LOCKS_WARN_ON(1);
 
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index c3600a0..68d44ec 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -53,6 +53,9 @@ extern unsigned int nr_process_chains;
 extern unsigned int max_lockdep_depth;
 extern unsigned int max_recursion_depth;
 
+extern unsigned long lockdep_count_forward_deps(struct lock_class *);
+extern unsigned long lockdep_count_backward_deps(struct lock_class *);
+
 #ifdef CONFIG_DEBUG_LOCKDEP
 /*
  * Various lockdep statistics:
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 9b0e940..6252ff7 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -63,34 +63,6 @@ static void l_stop(struct seq_file *m, void *v)
 {
 }
 
-static unsigned long count_forward_deps(struct lock_class *class)
-{
-	struct lock_list *entry;
-	unsigned long ret = 1;
-
-	/*
-	 * Recurse this class's dependency list:
-	 */
-	list_for_each_entry(entry, &class->locks_after, entry)
-		ret += count_forward_deps(entry->class);
-
-	return ret;
-}
-
-static unsigned long count_backward_deps(struct lock_class *class)
-{
-	struct lock_list *entry;
-	unsigned long ret = 1;
-
-	/*
-	 * Recurse this class's dependency list:
-	 */
-	list_for_each_entry(entry, &class->locks_before, entry)
-		ret += count_backward_deps(entry->class);
-
-	return ret;
-}
-
 static void print_name(struct seq_file *m, struct lock_class *class)
 {
 	char str[128];
@@ -124,10 +96,10 @@ static int l_show(struct seq_file *m, void *v)
 #ifdef CONFIG_DEBUG_LOCKDEP
 	seq_printf(m, " OPS:%8ld", class->ops);
 #endif
-	nr_forward_deps = count_forward_deps(class);
+	nr_forward_deps = lockdep_count_forward_deps(class);
 	seq_printf(m, " FD:%5ld", nr_forward_deps);
 
-	nr_backward_deps = count_backward_deps(class);
+	nr_backward_deps = lockdep_count_backward_deps(class);
 	seq_printf(m, " BD:%5ld", nr_backward_deps);
 
 	get_usage_chars(class, &c1, &c2, &c3, &c4);
@@ -350,7 +322,7 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 		if (class->usage_mask & LOCKF_ENABLED_HARDIRQS_READ)
 			nr_hardirq_read_unsafe++;
 
-		sum_forward_deps += count_forward_deps(class);
+		sum_forward_deps += lockdep_count_forward_deps(class);
 	}
 #ifdef CONFIG_DEBUG_LOCKDEP
 	DEBUG_LOCKS_WARN_ON(debug_atomic_read(&nr_unused_locks) != nr_unused);
