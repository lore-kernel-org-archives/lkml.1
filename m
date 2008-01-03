Return-Path: <linux-kernel-owner+w=401wt.eu-S1759175AbYACRqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbYACRqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbYACRqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:46:15 -0500
Received: from ns2.suse.de ([195.135.220.15]:56354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbYACRqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:46:14 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103646.181089000@suse.de>
In-Reply-To: <20080103646.181089000@suse.de>
To: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/3] Convert lockdep to use arch_early_alloc() if available for its large arrays
Message-Id: <20080103174613.5CA5D14DDD@wotan.suse.de>
Date: Thu,  3 Jan 2008 18:46:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The static arrays in lockdep can be quite big. Upto several megabytes. 
We ran into problems with 64bit kernels becoming so big that the kernel
image overlapped into the 16MB area reserved for a kdump kernel.

This patch converts lockdep to use arch_early_alloc() if available
to avoid this problem.

Cc: peterz@infradead.org

Signed-off-by: Andi Kleen <ak@suse.de>

---
 kernel/lockdep.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

Index: linux/kernel/lockdep.c
===================================================================
--- linux.orig/kernel/lockdep.c
+++ linux/kernel/lockdep.c
@@ -109,7 +109,7 @@ static inline int debug_locks_off_graph_
 static int lockdep_initialized;
 
 unsigned long nr_list_entries;
-static struct lock_list list_entries[MAX_LOCKDEP_ENTRIES];
+static struct lock_list *list_entries;
 
 /*
  * All data structures here are protected by the global debug_lock.
@@ -118,7 +118,7 @@ static struct lock_list list_entries[MAX
  * get freed - this significantly simplifies the debugging code.
  */
 unsigned long nr_lock_classes;
-static struct lock_class lock_classes[MAX_LOCKDEP_KEYS];
+static struct lock_class *lock_classes;
 
 #ifdef CONFIG_LOCK_STAT
 static DEFINE_PER_CPU(struct lock_class_stats[MAX_LOCKDEP_KEYS], lock_stats);
@@ -257,7 +257,7 @@ static struct list_head classhash_table[
 #define __chainhashfn(chain)	hash_long(chain, CHAINHASH_BITS)
 #define chainhashentry(chain)	(chainhash_table + __chainhashfn((chain)))
 
-static struct list_head chainhash_table[CHAINHASH_SIZE];
+static struct list_head *chainhash_table;
 
 /*
  * The hash key of the lock dependency chains is a hash itself too:
@@ -332,7 +332,7 @@ static int verbose(struct lock_class *cl
  * addresses. Protected by the graph_lock.
  */
 unsigned long nr_stack_trace_entries;
-static unsigned long stack_trace[MAX_STACK_TRACE_ENTRIES];
+static unsigned long *stack_trace;
 
 static int save_trace(struct stack_trace *trace)
 {
@@ -1454,7 +1454,7 @@ out_bug:
 }
 
 unsigned long nr_lock_chains;
-static struct lock_chain lock_chains[MAX_LOCKDEP_CHAINS];
+static struct lock_chain *lock_chains;
 
 /*
  * Look up a dependency chain. If the key is not present yet then
@@ -3010,6 +3010,27 @@ out_restore:
 	raw_local_irq_restore(flags);
 }
 
+/*
+ * The large arrays can bloat the kernel image too much causing problems
+ * because it needs an continuous area in memory. Allocate them
+ * using a special allocator if possible. This is before bootmem and only
+ * works on some architectures.
+ */
+
+#ifndef ARCH_HAS_EARLY_ALLOC
+#define LARGEVAR(x,y) { static typeof(*x) __ ## x[y];  x = __ ## x; }
+#else
+#define LARGEVAR(x,y) x = arch_early_alloc(sizeof(*x) * y)
+#endif
+
+void lockdep_init_mem(void)
+{
+	LARGEVAR(stack_trace, MAX_STACK_TRACE_ENTRIES);
+	LARGEVAR(list_entries, MAX_LOCKDEP_ENTRIES);
+	LARGEVAR(lock_chains, MAX_LOCKDEP_CHAINS);
+	LARGEVAR(lock_classes, MAX_LOCKDEP_KEYS);
+	LARGEVAR(chainhash_table, CHAINHASH_SIZE);
+}
 void lockdep_init(void)
 {
 	int i;
@@ -3023,6 +3044,8 @@ void lockdep_init(void)
 	if (lockdep_initialized)
 		return;
 
+	lockdep_init_mem();
+
 	for (i = 0; i < CLASSHASH_SIZE; i++)
 		INIT_LIST_HEAD(classhash_table + i);
 
