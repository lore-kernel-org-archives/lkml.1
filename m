Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbYGNOdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbYGNOdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 10:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYGNOdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 10:33:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35198 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbYGNOdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 10:33:00 -0400
Date: Mon, 14 Jul 2008 16:32:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core/locking for v2.6.27
Message-ID: <20080714143240.GA19002@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core/locking git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/locking

Thanks,

	Ingo

------------------>
Huang, Ying (3):
      lockdep: output lock_class key instead of address for forward dependency output
      lockdep: add lock_class information to lock_chain and output it
      lockdep: add lock_class information to lock_chain and output it

Ingo Molnar (2):
      lockdep: fix ftrace irq tracing false positive
      lockdep: fix kernel/fork.c warning

Jeremy Kerr (1):
      mutex-debug: check mutex magic before owner

Li Zefan (1):
      lockdep: remove duplicate definition of STATIC_LOCKDEP_MAP_INIT

Oleg Nesterov (1):
      __mutex_lock_common: use signal_pending_state()


 include/linux/lockdep.h    |   11 +----
 kernel/fork.c              |    2 +-
 kernel/lockdep.c           |   47 +++++++++++++++++++--
 kernel/lockdep_internals.h |    6 +++
 kernel/lockdep_proc.c      |   97 +++++++++++++++++++++++++++++++++++++++++++-
 kernel/mutex-debug.c       |    2 +-
 kernel/mutex.c             |    5 +--
 7 files changed, 151 insertions(+), 19 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 4c4d236..2486eb4 100644
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
@@ -276,14 +279,6 @@ extern void lockdep_init_map(struct lockdep_map *lock, const char *name,
 				 (lock)->dep_map.key, sub)
 
 /*
- * To initialize a lockdep_map statically use this macro.
- * Note that _name must not be NULL.
- */
-#define STATIC_LOCKDEP_MAP_INIT(_name, _key) \
-	{ .name = (_name), .key = (void *)(_key), }
-
-
-/*
  * Acquire a lock.
  *
  * Values for "read":
diff --git a/kernel/fork.c b/kernel/fork.c
index 19908b2..cdb1f82 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -909,7 +909,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	rt_mutex_init_task(p);
 
-#ifdef CONFIG_TRACE_IRQFLAGS
+#ifdef CONFIG_PROVE_LOCKING
 	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 81a4e4a..fc5d5aa 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1458,7 +1458,14 @@ out_bug:
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
@@ -1466,10 +1473,15 @@ static struct lock_chain lock_chains[MAX_LOCKDEP_CHAINS];
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
@@ -1517,6 +1529,32 @@ cache_hit:
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
@@ -1538,7 +1576,7 @@ static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
 	 * graph_lock for us)
 	 */
 	if (!hlock->trylock && (hlock->check == 2) &&
-			lookup_chain_cache(chain_key, hlock->class)) {
+	    lookup_chain_cache(curr, hlock, chain_key)) {
 		/*
 		 * Check whether last held lock:
 		 *
@@ -2650,7 +2688,8 @@ __lock_release(struct lockdep_map *lock, int nested, unsigned long ip)
  */
 static void check_flags(unsigned long flags)
 {
-#if defined(CONFIG_DEBUG_LOCKDEP) && defined(CONFIG_TRACE_IRQFLAGS)
+#if defined(CONFIG_PROVE_LOCKING) && defined(CONFIG_DEBUG_LOCKDEP) && \
+    defined(CONFIG_TRACE_IRQFLAGS)
 	if (!debug_locks)
 		return;
 
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 8ce09bc..c3600a0 100644
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
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index dc5d296..9b0e940 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -139,7 +139,7 @@ static int l_show(struct seq_file *m, void *v)
 
 	list_for_each_entry(entry, &class->locks_after, entry) {
 		if (entry->distance == 1) {
-			seq_printf(m, " -> [%p] ", entry->class);
+			seq_printf(m, " -> [%p] ", entry->class->key);
 			print_name(m, entry->class);
 			seq_puts(m, "\n");
 		}
@@ -178,6 +178,95 @@ static const struct file_operations proc_lockdep_operations = {
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
@@ -294,6 +383,8 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 #ifdef CONFIG_PROVE_LOCKING
 	seq_printf(m, " dependency chains:             %11lu [max: %lu]\n",
 			nr_lock_chains, MAX_LOCKDEP_CHAINS);
+	seq_printf(m, " dependency chain hlocks:       %11d [max: %lu]\n",
+			nr_chain_hlocks, MAX_LOCKDEP_CHAIN_HLOCKS);
 #endif
 
 #ifdef CONFIG_TRACE_IRQFLAGS
@@ -661,6 +752,10 @@ static const struct file_operations proc_lock_stat_operations = {
 static int __init lockdep_proc_init(void)
 {
 	proc_create("lockdep", S_IRUSR, NULL, &proc_lockdep_operations);
+#ifdef CONFIG_PROVE_LOCKING
+	proc_create("lockdep_chains", S_IRUSR, NULL,
+		    &proc_lockdep_chains_operations);
+#endif
 	proc_create("lockdep_stats", S_IRUSR, NULL,
 		    &proc_lockdep_stats_operations);
 
diff --git a/kernel/mutex-debug.c b/kernel/mutex-debug.c
index 3aaa06c..1d94160 100644
--- a/kernel/mutex-debug.c
+++ b/kernel/mutex-debug.c
@@ -79,8 +79,8 @@ void debug_mutex_unlock(struct mutex *lock)
 	if (unlikely(!debug_locks))
 		return;
 
-	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
+	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
 	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
 }
diff --git a/kernel/mutex.c b/kernel/mutex.c
index d046a34..bcdc9ac 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -165,10 +165,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * got a signal? (This code gets eliminated in the
 		 * TASK_UNINTERRUPTIBLE case.)
 		 */
-		if (unlikely((state == TASK_INTERRUPTIBLE &&
-					signal_pending(task)) ||
-			      (state == TASK_KILLABLE &&
-					fatal_signal_pending(task)))) {
+		if (unlikely(signal_pending_state(state, task))) {
 			mutex_remove_waiter(lock, &waiter,
 					    task_thread_info(task));
 			mutex_release(&lock->dep_map, 1, ip);
