Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbYHPN6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbYHPN6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 09:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbYHPN55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 09:57:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53592 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbYHPN54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 09:57:56 -0400
Date: Sat, 16 Aug 2008 15:57:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core kernel fixes for v2.6.27
Message-ID: <20080816135743.GA9268@elte.hu>
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

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

Thanks,

	Ingo

------------------>
Andrew Morton (1):
      lockdep: spin_lock_nest_lock(), checkpatch fixes

Arjan van de Ven (1):
      lockdep: use WARN() in kernel/lockdep.c

Ingo Molnar (1):
      lockdep: build fix

Stephen Hemminger (1):
      lockdep: fix build if CONFIG_PROVE_LOCKING not defined


 kernel/lockdep.c           |    6 ++----
 kernel/lockdep_internals.h |   13 +++++++++++++
 kernel/lockdep_proc.c      |   12 ++++++------
 kernel/spinlock.c          |    3 ---
 4 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 1aa91fd..77fa776 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1759,11 +1759,10 @@ static void check_chain_key(struct task_struct *curr)
 		hlock = curr->held_locks + i;
 		if (chain_key != hlock->prev_chain_key) {
 			debug_locks_off();
-			printk("hm#1, depth: %u [%u], %016Lx != %016Lx\n",
+			WARN(1, "hm#1, depth: %u [%u], %016Lx != %016Lx\n",
 				curr->lockdep_depth, i,
 				(unsigned long long)chain_key,
 				(unsigned long long)hlock->prev_chain_key);
-			WARN_ON(1);
 			return;
 		}
 		id = hlock->class_idx - 1;
@@ -1778,11 +1777,10 @@ static void check_chain_key(struct task_struct *curr)
 	}
 	if (chain_key != curr->curr_chain_key) {
 		debug_locks_off();
-		printk("hm#2, depth: %u [%u], %016Lx != %016Lx\n",
+		WARN(1, "hm#2, depth: %u [%u], %016Lx != %016Lx\n",
 			curr->lockdep_depth, i,
 			(unsigned long long)chain_key,
 			(unsigned long long)curr->curr_chain_key);
-		WARN_ON(1);
 	}
 #endif
 }
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 55db193..56b1969 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -50,8 +50,21 @@ extern unsigned int nr_process_chains;
 extern unsigned int max_lockdep_depth;
 extern unsigned int max_recursion_depth;
 
+#ifdef CONFIG_PROVE_LOCKING
 extern unsigned long lockdep_count_forward_deps(struct lock_class *);
 extern unsigned long lockdep_count_backward_deps(struct lock_class *);
+#else
+static inline unsigned long
+lockdep_count_forward_deps(struct lock_class *class)
+{
+	return 0;
+}
+static inline unsigned long
+lockdep_count_backward_deps(struct lock_class *class)
+{
+	return 0;
+}
+#endif
 
 #ifdef CONFIG_DEBUG_LOCKDEP
 /*
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index fa19aee..4b194d3 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -82,7 +82,6 @@ static void print_name(struct seq_file *m, struct lock_class *class)
 
 static int l_show(struct seq_file *m, void *v)
 {
-	unsigned long nr_forward_deps, nr_backward_deps;
 	struct lock_class *class = v;
 	struct lock_list *entry;
 	char c1, c2, c3, c4;
@@ -96,11 +95,10 @@ static int l_show(struct seq_file *m, void *v)
 #ifdef CONFIG_DEBUG_LOCKDEP
 	seq_printf(m, " OPS:%8ld", class->ops);
 #endif
-	nr_forward_deps = lockdep_count_forward_deps(class);
-	seq_printf(m, " FD:%5ld", nr_forward_deps);
-
-	nr_backward_deps = lockdep_count_backward_deps(class);
-	seq_printf(m, " BD:%5ld", nr_backward_deps);
+#ifdef CONFIG_PROVE_LOCKING
+	seq_printf(m, " FD:%5ld", lockdep_count_forward_deps(class));
+	seq_printf(m, " BD:%5ld", lockdep_count_backward_deps(class));
+#endif
 
 	get_usage_chars(class, &c1, &c2, &c3, &c4);
 	seq_printf(m, " %c%c%c%c", c1, c2, c3, c4);
@@ -325,7 +323,9 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 		if (class->usage_mask & LOCKF_ENABLED_HARDIRQS_READ)
 			nr_hardirq_read_unsafe++;
 
+#ifdef CONFIG_PROVE_LOCKING
 		sum_forward_deps += lockdep_count_forward_deps(class);
+#endif
 	}
 #ifdef CONFIG_DEBUG_LOCKDEP
 	DEBUG_LOCKS_WARN_ON(debug_atomic_read(&nr_unused_locks) != nr_unused);
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index 44baeea..29ab207 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -290,7 +290,6 @@ void __lockfunc _spin_lock_nested(spinlock_t *lock, int subclass)
 	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
-
 EXPORT_SYMBOL(_spin_lock_nested);
 
 unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock, int subclass)
@@ -312,7 +311,6 @@ unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock, int subclas
 #endif
 	return flags;
 }
-
 EXPORT_SYMBOL(_spin_lock_irqsave_nested);
 
 void __lockfunc _spin_lock_nest_lock(spinlock_t *lock,
@@ -322,7 +320,6 @@ void __lockfunc _spin_lock_nest_lock(spinlock_t *lock,
 	spin_acquire_nest(&lock->dep_map, 0, 0, nest_lock, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
-
 EXPORT_SYMBOL(_spin_lock_nest_lock);
 
 #endif
