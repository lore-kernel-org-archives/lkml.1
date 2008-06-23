Return-Path: <linux-kernel-owner+w=401wt.eu-S1757672AbYFWDRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbYFWDRk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 23:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbYFWDRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 23:17:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:35631 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbYFWDRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 23:17:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,687,1204531200"; 
   d="scan'208";a="1140992"
Subject: [PATCH -v2] lockdep: add lock_class information to lock_chain and
	output it
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 23 Jun 2008 11:20:54 +0800
Message-Id: <1214191255.23863.2.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 23 Jun 2008 03:17:24.0294 (UTC) FILETIME=[A8171660:01C8D4DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch records array of lock_class into lock_chain, and export
lock_chain information via /proc/lockdep_chains.

It is based on x86/master branch of git-x86 tree, and has been tested
on x86_64 platform.


ChangeLog:

v2:

- Enclosing proc file system related code into CONFIG_PROVE_LOCKING.

- Fix nr_chain_hlocks update code.


Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 include/linux/lockdep.h    |    3 +
 kernel/lockdep.c           |   44 +++++++++++++++++++-
 kernel/lockdep_internals.h |    6 ++
 kernel/lockdep_proc.c      |   95 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 145 insertions(+), 3 deletions(-)

--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1463,7 +1463,14 @@ out_bug:
 }
 
 unsigned long nr_lock_chains;
-static struct lock_chain lock_chains[MAX_LOCKDEP_CHAINS];
+struct lock_chain lock_chains[MAX_LOCKDEP_CHAINS];
+int nr_chain_hlocks;
+static u16 chain_hlocks[MAX_LOCKDEP_CHAIN_HLOCKS];
+
+struct lock_class *lock_chain_get_class(struct lock_chain *chain, int i)
+{
+	return lock_classes + chain_hlocks[chain->base + i];
+}
 
 /*
  * Look up a dependency chain. If the key is not present yet then
@@ -1471,10 +1478,15 @@ static struct lock_chain lock_chains[MAX
  * validated. If the key is already hashed, return 0.
  * (On return with 1 graph_lock is held.)
  */
-static inline int lookup_chain_cache(u64 chain_key, struct lock_class *class)
+static inline int lookup_chain_cache(struct task_struct *curr,
+				     struct held_lock *hlock,
+				     u64 chain_key)
 {
+	struct lock_class *class = hlock->class;
 	struct list_head *hash_head = chainhashentry(chain_key);
 	struct lock_chain *chain;
+	struct held_lock *hlock_curr, *hlock_next;
+	int i, j, n, cn;
 
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return 0;
@@ -1522,6 +1534,32 @@ cache_hit:
 	}
 	chain = lock_chains + nr_lock_chains++;
 	chain->chain_key = chain_key;
+	chain->irq_context = hlock->irq_context;
+	/* Find the first held_lock of current chain */
+	hlock_next = hlock;
+	for (i = curr->lockdep_depth - 1; i >= 0; i--) {
+		hlock_curr = curr->held_locks + i;
+		if (hlock_curr->irq_context != hlock_next->irq_context)
+			break;
+		hlock_next = hlock;
+	}
+	i++;
+	chain->depth = curr->lockdep_depth + 1 - i;
+	cn = nr_chain_hlocks;
+	while (cn + chain->depth <= MAX_LOCKDEP_CHAIN_HLOCKS) {
+		n = cmpxchg(&nr_chain_hlocks, cn, cn + chain->depth);
+		if (n == cn)
+			break;
+		cn = n;
+	}
+	if (likely(cn + chain->depth <= MAX_LOCKDEP_CHAIN_HLOCKS)) {
+		chain->base = cn;
+		for (j = 0; j < chain->depth - 1; j++, i++) {
+			int lock_id = curr->held_locks[i].class - lock_classes;
+			chain_hlocks[chain->base + j] = lock_id;
+		}
+		chain_hlocks[chain->base + j] = class - lock_classes;
+	}
 	list_add_tail_rcu(&chain->entry, hash_head);
 	debug_atomic_inc(&chain_lookup_misses);
 	inc_chains();
@@ -1543,7 +1581,7 @@ static int validate_chain(struct task_st
 	 * graph_lock for us)
 	 */
 	if (!hlock->trylock && (hlock->check == 2) &&
-			lookup_chain_cache(chain_key, hlock->class)) {
+	    lookup_chain_cache(curr, hlock, chain_key)) {
 		/*
 		 * Check whether last held lock:
 		 *
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -182,6 +182,9 @@ struct lock_list {
  * We record lock dependency chains, so that we can cache them:
  */
 struct lock_chain {
+	u8				irq_context;
+	u8				depth;
+	u16				base;
 	struct list_head		entry;
 	u64				chain_key;
 };
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -178,6 +178,95 @@ static const struct file_operations proc
 	.release	= seq_release,
 };
 
+#ifdef CONFIG_PROVE_LOCKING
+static void *lc_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct lock_chain *chain;
+
+	(*pos)++;
+
+	if (v == SEQ_START_TOKEN)
+		chain = m->private;
+	else {
+		chain = v;
+
+		if (*pos < nr_lock_chains)
+			chain = lock_chains + *pos;
+		else
+			chain = NULL;
+	}
+
+	return chain;
+}
+
+static void *lc_start(struct seq_file *m, loff_t *pos)
+{
+	if (*pos == 0)
+		return SEQ_START_TOKEN;
+
+	if (*pos < nr_lock_chains)
+		return lock_chains + *pos;
+
+	return NULL;
+}
+
+static void lc_stop(struct seq_file *m, void *v)
+{
+}
+
+static int lc_show(struct seq_file *m, void *v)
+{
+	struct lock_chain *chain = v;
+	struct lock_class *class;
+	int i;
+
+	if (v == SEQ_START_TOKEN) {
+		seq_printf(m, "all lock chains:\n");
+		return 0;
+	}
+
+	seq_printf(m, "irq_context: %d\n", chain->irq_context);
+
+	for (i = 0; i < chain->depth; i++) {
+		class = lock_chain_get_class(chain, i);
+		seq_printf(m, "[%p] ", class->key);
+		print_name(m, class);
+		seq_puts(m, "\n");
+	}
+	seq_puts(m, "\n");
+
+	return 0;
+}
+
+static const struct seq_operations lockdep_chains_ops = {
+	.start	= lc_start,
+	.next	= lc_next,
+	.stop	= lc_stop,
+	.show	= lc_show,
+};
+
+static int lockdep_chains_open(struct inode *inode, struct file *file)
+{
+	int res = seq_open(file, &lockdep_chains_ops);
+	if (!res) {
+		struct seq_file *m = file->private_data;
+
+		if (nr_lock_chains)
+			m->private = lock_chains;
+		else
+			m->private = NULL;
+	}
+	return res;
+}
+
+static const struct file_operations proc_lockdep_chains_operations = {
+	.open		= lockdep_chains_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+#endif /* CONFIG_PROVE_LOCKING */
+
 static void lockdep_stats_debug_show(struct seq_file *m)
 {
 #ifdef CONFIG_DEBUG_LOCKDEP
@@ -294,6 +383,8 @@ static int lockdep_stats_show(struct seq
 #ifdef CONFIG_PROVE_LOCKING
 	seq_printf(m, " dependency chains:             %11lu [max: %lu]\n",
 			nr_lock_chains, MAX_LOCKDEP_CHAINS);
+	seq_printf(m, " dependency chain hlocks:       %11d [max: %lu]\n",
+			nr_chain_hlocks, MAX_LOCKDEP_CHAIN_HLOCKS);
 #endif
 
 #ifdef CONFIG_TRACE_IRQFLAGS
@@ -661,6 +752,10 @@ static const struct file_operations proc
 static int __init lockdep_proc_init(void)
 {
 	proc_create("lockdep", S_IRUSR, NULL, &proc_lockdep_operations);
+#ifdef CONFIG_PROVE_LOCKING
+	proc_create("lockdep_chains", S_IRUSR, NULL,
+		    &proc_lockdep_chains_operations);
+#endif
 	proc_create("lockdep_stats", S_IRUSR, NULL,
 		    &proc_lockdep_stats_operations);
 
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -23,6 +23,8 @@
 #define MAX_LOCKDEP_CHAINS_BITS	14
 #define MAX_LOCKDEP_CHAINS	(1UL << MAX_LOCKDEP_CHAINS_BITS)
 
+#define MAX_LOCKDEP_CHAIN_HLOCKS (MAX_LOCKDEP_CHAINS*5)
+
 /*
  * Stack-trace: tightly packed array of stack backtrace
  * addresses. Protected by the hash_lock.
@@ -30,15 +32,19 @@
 #define MAX_STACK_TRACE_ENTRIES	262144UL
 
 extern struct list_head all_lock_classes;
+extern struct lock_chain lock_chains[];
 
 extern void
 get_usage_chars(struct lock_class *class, char *c1, char *c2, char *c3, char *c4);
 
 extern const char * __get_key_name(struct lockdep_subclass_key *key, char *str);
 
+struct lock_class *lock_chain_get_class(struct lock_chain *chain, int i);
+
 extern unsigned long nr_lock_classes;
 extern unsigned long nr_list_entries;
 extern unsigned long nr_lock_chains;
+extern int nr_chain_hlocks;
 extern unsigned long nr_stack_trace_entries;
 
 extern unsigned int nr_hardirq_chains;

