Return-Path: <linux-kernel-owner+w=401wt.eu-S1759743AbZJHTHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743AbZJHTHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 15:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbZJHTHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 15:07:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59397 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759379AbZJHTHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 15:07:15 -0400
Date: Thu, 8 Oct 2009 21:06:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20091008190617.GA7817@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

Sigh ... this now looks a bit large for -rc3, due to the RCU cleanups. 
When i queued it up in -rc1 it looked acceptable :-/ Should we redo it 
again to extract the cleanups from the fixes (which cause most of the 
diffstat increase)?

 Thanks,

	Ingo

------------------>
Aaro Koskinen (1):
      panic: Fix panic message visibility by calling bust_spinlocks(0) before dying

Anton Blanchard (1):
      futex: Fix typo in FUTEX_WAIT/WAKE_BITSET_PRIVATE definitions

Darren Hart (1):
      futex: fix requeue_pi key imbalance

Paul E. McKenney (10):
      rcu: Clean up code based on review feedback from Josh Triplett
      rcu: Clean up code based on review feedback from Josh Triplett, part 2
      rcu: Clean up code to address Ingo's checkpatch feedback
      rcu: Fix rcu_lock_map build failure on CONFIG_PROVE_LOCKING=y
      rcu: Clean up code based on review feedback from Josh Triplett, part 3
      rcu: Clean up code based on review feedback from Josh Triplett, part 4
      rcu: Replace the rcu_barrier enum with pointer to call_rcu*() function
      rcu: Move rcu_barrier() to rcutree
      rcu: Make hot-unplugged CPU relinquish its own RCU callbacks
      rcu: Place root rcu_node structure in separate lockdep class

Peter Zijlstra (1):
      futex: Nullify robust lists after cleanup

Thomas Gleixner (2):
      futex: Fix locking imbalance
      futex: Move exit_pi_state() call to release_mm()


 include/linux/futex.h    |    4 +-
 include/linux/rcupdate.h |   18 ++-
 include/linux/rcutree.h  |   13 +-
 init/main.c              |    1 -
 kernel/exit.c            |    2 -
 kernel/fork.c            |   10 +-
 kernel/futex.c           |    3 +-
 kernel/panic.c           |    3 +-
 kernel/rcupdate.c        |  140 +-------------------
 kernel/rcutorture.c      |    4 +-
 kernel/rcutree.c         |  330 ++++++++++++++++++++++++++++++----------------
 kernel/rcutree.h         |   86 ++++++++++--
 kernel/rcutree_plugin.h  |  103 +++++++++++----
 kernel/rcutree_trace.c   |   14 +-
 14 files changed, 410 insertions(+), 321 deletions(-)

diff --git a/include/linux/futex.h b/include/linux/futex.h
index 34956c8..78b92ec 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -38,8 +38,8 @@ union ktime;
 #define FUTEX_LOCK_PI_PRIVATE	(FUTEX_LOCK_PI | FUTEX_PRIVATE_FLAG)
 #define FUTEX_UNLOCK_PI_PRIVATE	(FUTEX_UNLOCK_PI | FUTEX_PRIVATE_FLAG)
 #define FUTEX_TRYLOCK_PI_PRIVATE (FUTEX_TRYLOCK_PI | FUTEX_PRIVATE_FLAG)
-#define FUTEX_WAIT_BITSET_PRIVATE	(FUTEX_WAIT_BITS | FUTEX_PRIVATE_FLAG)
-#define FUTEX_WAKE_BITSET_PRIVATE	(FUTEX_WAKE_BITS | FUTEX_PRIVATE_FLAG)
+#define FUTEX_WAIT_BITSET_PRIVATE	(FUTEX_WAIT_BITSET | FUTEX_PRIVATE_FLAG)
+#define FUTEX_WAKE_BITSET_PRIVATE	(FUTEX_WAKE_BITSET | FUTEX_PRIVATE_FLAG)
 #define FUTEX_WAIT_REQUEUE_PI_PRIVATE	(FUTEX_WAIT_REQUEUE_PI | \
 					 FUTEX_PRIVATE_FLAG)
 #define FUTEX_CMP_REQUEUE_PI_PRIVATE	(FUTEX_CMP_REQUEUE_PI | \
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 6fe0363..3ebd0b7 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -77,7 +77,7 @@ extern int rcu_scheduler_active;
 #error "Unknown RCU implementation specified to kernel configuration"
 #endif
 
-#define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
+#define RCU_HEAD_INIT	{ .next = NULL, .func = NULL }
 #define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
 #define INIT_RCU_HEAD(ptr) do { \
        (ptr)->next = NULL; (ptr)->func = NULL; \
@@ -129,12 +129,6 @@ static inline void rcu_read_lock(void)
 	rcu_read_acquire();
 }
 
-/**
- * rcu_read_unlock - marks the end of an RCU read-side critical section.
- *
- * See rcu_read_lock() for more information.
- */
-
 /*
  * So where is rcu_write_lock()?  It does not exist, as there is no
  * way for writers to lock out RCU readers.  This is a feature, not
@@ -144,6 +138,12 @@ static inline void rcu_read_lock(void)
  * used as well.  RCU does not care how the writers keep out of each
  * others' way, as long as they do so.
  */
+
+/**
+ * rcu_read_unlock - marks the end of an RCU read-side critical section.
+ *
+ * See rcu_read_lock() for more information.
+ */
 static inline void rcu_read_unlock(void)
 {
 	rcu_read_release();
@@ -196,6 +196,8 @@ static inline void rcu_read_lock_sched(void)
 	__acquire(RCU_SCHED);
 	rcu_read_acquire();
 }
+
+/* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
 static inline notrace void rcu_read_lock_sched_notrace(void)
 {
 	preempt_disable_notrace();
@@ -213,6 +215,8 @@ static inline void rcu_read_unlock_sched(void)
 	__release(RCU_SCHED);
 	preempt_enable();
 }
+
+/* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
 static inline notrace void rcu_read_unlock_sched_notrace(void)
 {
 	__release(RCU_SCHED);
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 3768277..46e9ab3 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -30,10 +30,14 @@
 #ifndef __LINUX_RCUTREE_H
 #define __LINUX_RCUTREE_H
 
+struct notifier_block;
+
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
-
+extern int rcu_cpu_notify(struct notifier_block *self,
+			  unsigned long action, void *hcpu);
 extern int rcu_needs_cpu(int cpu);
+extern int rcu_expedited_torture_stats(char *page);
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
@@ -85,16 +89,11 @@ static inline void synchronize_rcu_bh_expedited(void)
 
 extern void __rcu_init(void);
 extern void rcu_check_callbacks(int cpu, int user);
-extern void rcu_restart_cpu(int cpu);
 
 extern long rcu_batches_completed(void);
 extern long rcu_batches_completed_bh(void);
 extern long rcu_batches_completed_sched(void);
 
-static inline void rcu_init_sched(void)
-{
-}
-
 #ifdef CONFIG_NO_HZ
 void rcu_enter_nohz(void);
 void rcu_exit_nohz(void);
@@ -107,7 +106,7 @@ static inline void rcu_exit_nohz(void)
 }
 #endif /* CONFIG_NO_HZ */
 
-/* A context switch is a grace period for rcutree. */
+/* A context switch is a grace period for RCU-sched and RCU-bh. */
 static inline int rcu_blocking_is_gp(void)
 {
 	return num_online_cpus() == 1;
diff --git a/init/main.c b/init/main.c
index 34971be..833d675 100644
--- a/init/main.c
+++ b/init/main.c
@@ -782,7 +782,6 @@ static void __init do_initcalls(void)
  */
 static void __init do_basic_setup(void)
 {
-	rcu_init_sched(); /* needed by module_init stage. */
 	init_workqueues();
 	cpuset_init_smp();
 	usermodehelper_init();
diff --git a/kernel/exit.c b/kernel/exit.c
index ae5d866..bc2b1fd 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -989,8 +989,6 @@ NORET_TYPE void do_exit(long code)
 	tsk->mempolicy = NULL;
 #endif
 #ifdef CONFIG_FUTEX
-	if (unlikely(!list_empty(&tsk->pi_state_list)))
-		exit_pi_state_list(tsk);
 	if (unlikely(current->pi_state_cache))
 		kfree(current->pi_state_cache);
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index bfee931..341965b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -543,12 +543,18 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 
 	/* Get rid of any futexes when releasing the mm */
 #ifdef CONFIG_FUTEX
-	if (unlikely(tsk->robust_list))
+	if (unlikely(tsk->robust_list)) {
 		exit_robust_list(tsk);
+		tsk->robust_list = NULL;
+	}
 #ifdef CONFIG_COMPAT
-	if (unlikely(tsk->compat_robust_list))
+	if (unlikely(tsk->compat_robust_list)) {
 		compat_exit_robust_list(tsk);
+		tsk->compat_robust_list = NULL;
+	}
 #endif
+	if (unlikely(!list_empty(&tsk->pi_state_list)))
+		exit_pi_state_list(tsk);
 #endif
 
 	/* Get rid of any cached register state */
diff --git a/kernel/futex.c b/kernel/futex.c
index 463af2e..c3bb2fc 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -916,8 +916,8 @@ retry:
 	hb1 = hash_futex(&key1);
 	hb2 = hash_futex(&key2);
 
-	double_lock_hb(hb1, hb2);
 retry_private:
+	double_lock_hb(hb1, hb2);
 	op_ret = futex_atomic_op_inuser(op, uaddr2);
 	if (unlikely(op_ret < 0)) {
 
@@ -2111,7 +2111,6 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 		 * Unqueue the futex_q and determine which it was.
 		 */
 		plist_del(&q->list, &q->list.plist);
-		drop_futex_key_refs(&q->key);
 
 		if (timeout && !timeout->task)
 			ret = -ETIMEDOUT;
diff --git a/kernel/panic.c b/kernel/panic.c
index 512ab73..bc4dcb6 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -90,6 +90,8 @@ NORET_TYPE void panic(const char * fmt, ...)
 
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
+	bust_spinlocks(0);
+
 	if (!panic_blink)
 		panic_blink = no_blink;
 
@@ -136,7 +138,6 @@ NORET_TYPE void panic(const char * fmt, ...)
 		mdelay(1);
 		i++;
 	}
-	bust_spinlocks(0);
 }
 
 EXPORT_SYMBOL(panic);
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 37ac454..4001833 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -46,22 +46,15 @@
 #include <linux/module.h>
 #include <linux/kernel_stat.h>
 
-enum rcu_barrier {
-	RCU_BARRIER_STD,
-	RCU_BARRIER_BH,
-	RCU_BARRIER_SCHED,
-};
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static struct lock_class_key rcu_lock_key;
+struct lockdep_map rcu_lock_map =
+	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock", &rcu_lock_key);
+EXPORT_SYMBOL_GPL(rcu_lock_map);
+#endif
 
-static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
-static atomic_t rcu_barrier_cpu_count;
-static DEFINE_MUTEX(rcu_barrier_mutex);
-static struct completion rcu_barrier_completion;
 int rcu_scheduler_active __read_mostly;
 
-static atomic_t rcu_migrate_type_count = ATOMIC_INIT(0);
-static struct rcu_head rcu_migrate_head[3];
-static DECLARE_WAIT_QUEUE_HEAD(rcu_migrate_wq);
-
 /*
  * Awaken the corresponding synchronize_rcu() instance now that a
  * grace period has elapsed.
@@ -164,129 +157,10 @@ void synchronize_rcu_bh(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
-static void rcu_barrier_callback(struct rcu_head *notused)
-{
-	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
-		complete(&rcu_barrier_completion);
-}
-
-/*
- * Called with preemption disabled, and from cross-cpu IRQ context.
- */
-static void rcu_barrier_func(void *type)
-{
-	int cpu = smp_processor_id();
-	struct rcu_head *head = &per_cpu(rcu_barrier_head, cpu);
-
-	atomic_inc(&rcu_barrier_cpu_count);
-	switch ((enum rcu_barrier)type) {
-	case RCU_BARRIER_STD:
-		call_rcu(head, rcu_barrier_callback);
-		break;
-	case RCU_BARRIER_BH:
-		call_rcu_bh(head, rcu_barrier_callback);
-		break;
-	case RCU_BARRIER_SCHED:
-		call_rcu_sched(head, rcu_barrier_callback);
-		break;
-	}
-}
-
-static inline void wait_migrated_callbacks(void)
-{
-	wait_event(rcu_migrate_wq, !atomic_read(&rcu_migrate_type_count));
-	smp_mb(); /* In case we didn't sleep. */
-}
-
-/*
- * Orchestrate the specified type of RCU barrier, waiting for all
- * RCU callbacks of the specified type to complete.
- */
-static void _rcu_barrier(enum rcu_barrier type)
-{
-	BUG_ON(in_interrupt());
-	/* Take cpucontrol mutex to protect against CPU hotplug */
-	mutex_lock(&rcu_barrier_mutex);
-	init_completion(&rcu_barrier_completion);
-	/*
-	 * Initialize rcu_barrier_cpu_count to 1, then invoke
-	 * rcu_barrier_func() on each CPU, so that each CPU also has
-	 * incremented rcu_barrier_cpu_count.  Only then is it safe to
-	 * decrement rcu_barrier_cpu_count -- otherwise the first CPU
-	 * might complete its grace period before all of the other CPUs
-	 * did their increment, causing this function to return too
-	 * early.
-	 */
-	atomic_set(&rcu_barrier_cpu_count, 1);
-	on_each_cpu(rcu_barrier_func, (void *)type, 1);
-	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
-		complete(&rcu_barrier_completion);
-	wait_for_completion(&rcu_barrier_completion);
-	mutex_unlock(&rcu_barrier_mutex);
-	wait_migrated_callbacks();
-}
-
-/**
- * rcu_barrier - Wait until all in-flight call_rcu() callbacks complete.
- */
-void rcu_barrier(void)
-{
-	_rcu_barrier(RCU_BARRIER_STD);
-}
-EXPORT_SYMBOL_GPL(rcu_barrier);
-
-/**
- * rcu_barrier_bh - Wait until all in-flight call_rcu_bh() callbacks complete.
- */
-void rcu_barrier_bh(void)
-{
-	_rcu_barrier(RCU_BARRIER_BH);
-}
-EXPORT_SYMBOL_GPL(rcu_barrier_bh);
-
-/**
- * rcu_barrier_sched - Wait for in-flight call_rcu_sched() callbacks.
- */
-void rcu_barrier_sched(void)
-{
-	_rcu_barrier(RCU_BARRIER_SCHED);
-}
-EXPORT_SYMBOL_GPL(rcu_barrier_sched);
-
-static void rcu_migrate_callback(struct rcu_head *notused)
-{
-	if (atomic_dec_and_test(&rcu_migrate_type_count))
-		wake_up(&rcu_migrate_wq);
-}
-
-extern int rcu_cpu_notify(struct notifier_block *self,
-			  unsigned long action, void *hcpu);
-
 static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
 		unsigned long action, void *hcpu)
 {
-	rcu_cpu_notify(self, action, hcpu);
-	if (action == CPU_DYING) {
-		/*
-		 * preempt_disable() in on_each_cpu() prevents stop_machine(),
-		 * so when "on_each_cpu(rcu_barrier_func, (void *)type, 1);"
-		 * returns, all online cpus have queued rcu_barrier_func(),
-		 * and the dead cpu(if it exist) queues rcu_migrate_callback()s.
-		 *
-		 * These callbacks ensure _rcu_barrier() waits for all
-		 * RCU callbacks of the specified type to complete.
-		 */
-		atomic_set(&rcu_migrate_type_count, 3);
-		call_rcu_bh(rcu_migrate_head, rcu_migrate_callback);
-		call_rcu_sched(rcu_migrate_head + 1, rcu_migrate_callback);
-		call_rcu(rcu_migrate_head + 2, rcu_migrate_callback);
-	} else if (action == CPU_DOWN_PREPARE) {
-		/* Don't need to wait until next removal operation. */
-		/* rcu_migrate_head is protected by cpu_add_remove_lock */
-		wait_migrated_callbacks();
-	}
-
-	return NOTIFY_OK;
+	return rcu_cpu_notify(self, action, hcpu);
 }
 
 void __init rcu_init(void)
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 233768f..697c0a0 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -606,8 +606,6 @@ static struct rcu_torture_ops sched_ops_sync = {
 	.name		= "sched_sync"
 };
 
-extern int rcu_expedited_torture_stats(char *page);
-
 static struct rcu_torture_ops sched_expedited_ops = {
 	.init		= rcu_sync_torture_init,
 	.cleanup	= NULL,
@@ -650,7 +648,7 @@ rcu_torture_writer(void *arg)
 		old_rp = rcu_torture_current;
 		rp->rtort_mbtest = 1;
 		rcu_assign_pointer(rcu_torture_current, rp);
-		smp_wmb();
+		smp_wmb(); /* Mods to old_rp must follow rcu_assign_pointer() */
 		if (old_rp) {
 			i = old_rp->rtort_pipe_count;
 			if (i > RCU_TORTURE_PIPE_LEN)
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 52b06f6..705f02a 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -49,13 +49,6 @@
 
 #include "rcutree.h"
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-static struct lock_class_key rcu_lock_key;
-struct lockdep_map rcu_lock_map =
-	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock", &rcu_lock_key);
-EXPORT_SYMBOL_GPL(rcu_lock_map);
-#endif
-
 /* Data structures. */
 
 #define RCU_STATE_INITIALIZER(name) { \
@@ -70,6 +63,9 @@ EXPORT_SYMBOL_GPL(rcu_lock_map);
 	.gpnum = -300, \
 	.completed = -300, \
 	.onofflock = __SPIN_LOCK_UNLOCKED(&name.onofflock), \
+	.orphan_cbs_list = NULL, \
+	.orphan_cbs_tail = &name.orphan_cbs_list, \
+	.orphan_qlen = 0, \
 	.fqslock = __SPIN_LOCK_UNLOCKED(&name.fqslock), \
 	.n_force_qs = 0, \
 	.n_force_qs_ngp = 0, \
@@ -81,24 +77,16 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
-extern long rcu_batches_completed_sched(void);
-static struct rcu_node *rcu_get_root(struct rcu_state *rsp);
-static void cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp,
-			  struct rcu_node *rnp, unsigned long flags);
-static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags);
-#ifdef CONFIG_HOTPLUG_CPU
-static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp);
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
-static void __rcu_process_callbacks(struct rcu_state *rsp,
-				    struct rcu_data *rdp);
-static void __call_rcu(struct rcu_head *head,
-		       void (*func)(struct rcu_head *rcu),
-		       struct rcu_state *rsp);
-static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp);
-static void __cpuinit rcu_init_percpu_data(int cpu, struct rcu_state *rsp,
-					   int preemptable);
 
-#include "rcutree_plugin.h"
+/*
+ * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
+ * permit this function to be invoked without holding the root rcu_node
+ * structure's ->lock, but of course results can be subject to change.
+ */
+static int rcu_gp_in_progress(struct rcu_state *rsp)
+{
+	return ACCESS_ONCE(rsp->completed) != ACCESS_ONCE(rsp->gpnum);
+}
 
 /*
  * Note a quiescent state.  Because we do not need to know
@@ -137,6 +125,10 @@ static int blimit = 10;		/* Maximum callbacks per softirq. */
 static int qhimark = 10000;	/* If this many pending, ignore blimit. */
 static int qlowmark = 100;	/* Once only this many pending, use blimit. */
 
+module_param(blimit, int, 0);
+module_param(qhimark, int, 0);
+module_param(qlowmark, int, 0);
+
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
 static int rcu_pending(int cpu);
 
@@ -173,9 +165,7 @@ cpu_has_callbacks_ready_to_invoke(struct rcu_data *rdp)
 static int
 cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	/* ACCESS_ONCE() because we are accessing outside of lock. */
-	return *rdp->nxttail[RCU_DONE_TAIL] &&
-	       ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum);
+	return *rdp->nxttail[RCU_DONE_TAIL] && !rcu_gp_in_progress(rsp);
 }
 
 /*
@@ -369,7 +359,7 @@ static long dyntick_recall_completed(struct rcu_state *rsp)
 /*
  * Snapshot the specified CPU's dynticks counter so that we can later
  * credit them with an implicit quiescent state.  Return 1 if this CPU
- * is already in a quiescent state courtesy of dynticks idle mode.
+ * is in dynticks idle mode, which is an extended quiescent state.
  */
 static int dyntick_save_progress_counter(struct rcu_data *rdp)
 {
@@ -475,30 +465,34 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	long delta;
 	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root(rsp);
-	struct rcu_node *rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
-	struct rcu_node *rnp_end = &rsp->node[NUM_RCU_NODES];
 
 	/* Only let one CPU complain about others per time interval. */
 
 	spin_lock_irqsave(&rnp->lock, flags);
 	delta = jiffies - rsp->jiffies_stall;
-	if (delta < RCU_STALL_RAT_DELAY || rsp->gpnum == rsp->completed) {
+	if (delta < RCU_STALL_RAT_DELAY || !rcu_gp_in_progress(rsp)) {
 		spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
 	rsp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
+
+	/*
+	 * Now rat on any tasks that got kicked up to the root rcu_node
+	 * due to CPU offlining.
+	 */
+	rcu_print_task_stall(rnp);
 	spin_unlock_irqrestore(&rnp->lock, flags);
 
 	/* OK, time to rat on our buddy... */
 
 	printk(KERN_ERR "INFO: RCU detected CPU stalls:");
-	for (; rnp_cur < rnp_end; rnp_cur++) {
+	rcu_for_each_leaf_node(rsp, rnp) {
 		rcu_print_task_stall(rnp);
-		if (rnp_cur->qsmask == 0)
+		if (rnp->qsmask == 0)
 			continue;
-		for (cpu = 0; cpu <= rnp_cur->grphi - rnp_cur->grplo; cpu++)
-			if (rnp_cur->qsmask & (1UL << cpu))
-				printk(" %d", rnp_cur->grplo + cpu);
+		for (cpu = 0; cpu <= rnp->grphi - rnp->grplo; cpu++)
+			if (rnp->qsmask & (1UL << cpu))
+				printk(" %d", rnp->grplo + cpu);
 	}
 	printk(" (detected by %d, t=%ld jiffies)\n",
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
@@ -537,8 +531,7 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 		/* We haven't checked in, so go dump stack. */
 		print_cpu_stall(rsp);
 
-	} else if (rsp->gpnum != rsp->completed &&
-		   delta >= RCU_STALL_RAT_DELAY) {
+	} else if (rcu_gp_in_progress(rsp) && delta >= RCU_STALL_RAT_DELAY) {
 
 		/* They had two time units to dump stack, so complain. */
 		print_other_cpu_stall(rsp);
@@ -617,9 +610,15 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	note_new_gpnum(rsp, rdp);
 
 	/*
-	 * Because we are first, we know that all our callbacks will
-	 * be covered by this upcoming grace period, even the ones
-	 * that were registered arbitrarily recently.
+	 * Because this CPU just now started the new grace period, we know
+	 * that all of its callbacks will be covered by this upcoming grace
+	 * period, even the ones that were registered arbitrarily recently.
+	 * Therefore, advance all outstanding callbacks to RCU_WAIT_TAIL.
+	 *
+	 * Other CPUs cannot be sure exactly when the grace period started.
+	 * Therefore, their recently registered callbacks must pass through
+	 * an additional RCU_NEXT_READY stage, so that they will be handled
+	 * by the next RCU grace period.
 	 */
 	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
 	rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
@@ -657,7 +656,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	 * one corresponding to this CPU, due to the fact that we have
 	 * irqs disabled.
 	 */
-	for (rnp = &rsp->node[0]; rnp < &rsp->node[NUM_RCU_NODES]; rnp++) {
+	rcu_for_each_node_breadth_first(rsp, rnp) {
 		spin_lock(&rnp->lock);	/* irqs already disabled. */
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
@@ -703,9 +702,9 @@ rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
  * hold rnp->lock, as required by rcu_start_gp(), which will release it.
  */
 static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags)
-	__releases(rnp->lock)
+	__releases(rcu_get_root(rsp)->lock)
 {
-	WARN_ON_ONCE(rsp->completed == rsp->gpnum);
+	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 	rsp->completed = rsp->gpnum;
 	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
@@ -842,17 +841,63 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 #ifdef CONFIG_HOTPLUG_CPU
 
 /*
+ * Move a dying CPU's RCU callbacks to the ->orphan_cbs_list for the
+ * specified flavor of RCU.  The callbacks will be adopted by the next
+ * _rcu_barrier() invocation or by the CPU_DEAD notifier, whichever
+ * comes first.  Because this is invoked from the CPU_DYING notifier,
+ * irqs are already disabled.
+ */
+static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
+{
+	int i;
+	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
+
+	if (rdp->nxtlist == NULL)
+		return;  /* irqs disabled, so comparison is stable. */
+	spin_lock(&rsp->onofflock);  /* irqs already disabled. */
+	*rsp->orphan_cbs_tail = rdp->nxtlist;
+	rsp->orphan_cbs_tail = rdp->nxttail[RCU_NEXT_TAIL];
+	rdp->nxtlist = NULL;
+	for (i = 0; i < RCU_NEXT_SIZE; i++)
+		rdp->nxttail[i] = &rdp->nxtlist;
+	rsp->orphan_qlen += rdp->qlen;
+	rdp->qlen = 0;
+	spin_unlock(&rsp->onofflock);  /* irqs remain disabled. */
+}
+
+/*
+ * Adopt previously orphaned RCU callbacks.
+ */
+static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
+{
+	unsigned long flags;
+	struct rcu_data *rdp;
+
+	spin_lock_irqsave(&rsp->onofflock, flags);
+	rdp = rsp->rda[smp_processor_id()];
+	if (rsp->orphan_cbs_list == NULL) {
+		spin_unlock_irqrestore(&rsp->onofflock, flags);
+		return;
+	}
+	*rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_cbs_list;
+	rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_cbs_tail;
+	rdp->qlen += rsp->orphan_qlen;
+	rsp->orphan_cbs_list = NULL;
+	rsp->orphan_cbs_tail = &rsp->orphan_cbs_list;
+	rsp->orphan_qlen = 0;
+	spin_unlock_irqrestore(&rsp->onofflock, flags);
+}
+
+/*
  * Remove the outgoing CPU from the bitmasks in the rcu_node hierarchy
  * and move all callbacks from the outgoing CPU to the current one.
  */
 static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 {
-	int i;
 	unsigned long flags;
 	long lastcomp;
 	unsigned long mask;
 	struct rcu_data *rdp = rsp->rda[cpu];
-	struct rcu_data *rdp_me;
 	struct rcu_node *rnp;
 
 	/* Exclude any attempts to start a new grace period. */
@@ -875,32 +920,9 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	} while (rnp != NULL);
 	lastcomp = rsp->completed;
 
-	spin_unlock(&rsp->onofflock);		/* irqs remain disabled. */
+	spin_unlock_irqrestore(&rsp->onofflock, flags);
 
-	/*
-	 * Move callbacks from the outgoing CPU to the running CPU.
-	 * Note that the outgoing CPU is now quiscent, so it is now
-	 * (uncharacteristically) safe to access its rcu_data structure.
-	 * Note also that we must carefully retain the order of the
-	 * outgoing CPU's callbacks in order for rcu_barrier() to work
-	 * correctly.  Finally, note that we start all the callbacks
-	 * afresh, even those that have passed through a grace period
-	 * and are therefore ready to invoke.  The theory is that hotplug
-	 * events are rare, and that if they are frequent enough to
-	 * indefinitely delay callbacks, you have far worse things to
-	 * be worrying about.
-	 */
-	rdp_me = rsp->rda[smp_processor_id()];
-	if (rdp->nxtlist != NULL) {
-		*rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
-		rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
-		rdp->nxtlist = NULL;
-		for (i = 0; i < RCU_NEXT_SIZE; i++)
-			rdp->nxttail[i] = &rdp->nxtlist;
-		rdp_me->qlen += rdp->qlen;
-		rdp->qlen = 0;
-	}
-	local_irq_restore(flags);
+	rcu_adopt_orphan_cbs(rsp);
 }
 
 /*
@@ -918,6 +940,14 @@ static void rcu_offline_cpu(int cpu)
 
 #else /* #ifdef CONFIG_HOTPLUG_CPU */
 
+static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
+{
+}
+
+static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
+{
+}
+
 static void rcu_offline_cpu(int cpu)
 {
 }
@@ -1050,33 +1080,32 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
 	int cpu;
 	unsigned long flags;
 	unsigned long mask;
-	struct rcu_node *rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
-	struct rcu_node *rnp_end = &rsp->node[NUM_RCU_NODES];
+	struct rcu_node *rnp;
 
-	for (; rnp_cur < rnp_end; rnp_cur++) {
+	rcu_for_each_leaf_node(rsp, rnp) {
 		mask = 0;
-		spin_lock_irqsave(&rnp_cur->lock, flags);
+		spin_lock_irqsave(&rnp->lock, flags);
 		if (rsp->completed != lastcomp) {
-			spin_unlock_irqrestore(&rnp_cur->lock, flags);
+			spin_unlock_irqrestore(&rnp->lock, flags);
 			return 1;
 		}
-		if (rnp_cur->qsmask == 0) {
-			spin_unlock_irqrestore(&rnp_cur->lock, flags);
+		if (rnp->qsmask == 0) {
+			spin_unlock_irqrestore(&rnp->lock, flags);
 			continue;
 		}
-		cpu = rnp_cur->grplo;
+		cpu = rnp->grplo;
 		bit = 1;
-		for (; cpu <= rnp_cur->grphi; cpu++, bit <<= 1) {
-			if ((rnp_cur->qsmask & bit) != 0 && f(rsp->rda[cpu]))
+		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
+			if ((rnp->qsmask & bit) != 0 && f(rsp->rda[cpu]))
 				mask |= bit;
 		}
 		if (mask != 0 && rsp->completed == lastcomp) {
 
-			/* cpu_quiet_msk() releases rnp_cur->lock. */
-			cpu_quiet_msk(mask, rsp, rnp_cur, flags);
+			/* cpu_quiet_msk() releases rnp->lock. */
+			cpu_quiet_msk(mask, rsp, rnp, flags);
 			continue;
 		}
-		spin_unlock_irqrestore(&rnp_cur->lock, flags);
+		spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 	return 0;
 }
@@ -1092,7 +1121,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	struct rcu_node *rnp = rcu_get_root(rsp);
 	u8 signaled;
 
-	if (ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum))
+	if (!rcu_gp_in_progress(rsp))
 		return;  /* No grace period in progress, nothing to force. */
 	if (!spin_trylock_irqsave(&rsp->fqslock, flags)) {
 		rsp->n_force_qs_lh++; /* Inexact, can lose counts.  Tough! */
@@ -1251,7 +1280,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
 
 	/* Start a new grace period if one not already started. */
-	if (ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum)) {
+	if (!rcu_gp_in_progress(rsp)) {
 		unsigned long nestflag;
 		struct rcu_node *rnp_root = rcu_get_root(rsp);
 
@@ -1331,7 +1360,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 
 	/* Has an RCU GP gone long enough to send resched IPIs &c? */
-	if (ACCESS_ONCE(rsp->completed) != ACCESS_ONCE(rsp->gpnum) &&
+	if (rcu_gp_in_progress(rsp) &&
 	    ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)) {
 		rdp->n_rp_need_fqs++;
 		return 1;
@@ -1368,6 +1397,82 @@ int rcu_needs_cpu(int cpu)
 	       rcu_preempt_needs_cpu(cpu);
 }
 
+static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
+static atomic_t rcu_barrier_cpu_count;
+static DEFINE_MUTEX(rcu_barrier_mutex);
+static struct completion rcu_barrier_completion;
+
+static void rcu_barrier_callback(struct rcu_head *notused)
+{
+	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
+		complete(&rcu_barrier_completion);
+}
+
+/*
+ * Called with preemption disabled, and from cross-cpu IRQ context.
+ */
+static void rcu_barrier_func(void *type)
+{
+	int cpu = smp_processor_id();
+	struct rcu_head *head = &per_cpu(rcu_barrier_head, cpu);
+	void (*call_rcu_func)(struct rcu_head *head,
+			      void (*func)(struct rcu_head *head));
+
+	atomic_inc(&rcu_barrier_cpu_count);
+	call_rcu_func = type;
+	call_rcu_func(head, rcu_barrier_callback);
+}
+
+/*
+ * Orchestrate the specified type of RCU barrier, waiting for all
+ * RCU callbacks of the specified type to complete.
+ */
+static void _rcu_barrier(struct rcu_state *rsp,
+			 void (*call_rcu_func)(struct rcu_head *head,
+					       void (*func)(struct rcu_head *head)))
+{
+	BUG_ON(in_interrupt());
+	/* Take mutex to serialize concurrent rcu_barrier() requests. */
+	mutex_lock(&rcu_barrier_mutex);
+	init_completion(&rcu_barrier_completion);
+	/*
+	 * Initialize rcu_barrier_cpu_count to 1, then invoke
+	 * rcu_barrier_func() on each CPU, so that each CPU also has
+	 * incremented rcu_barrier_cpu_count.  Only then is it safe to
+	 * decrement rcu_barrier_cpu_count -- otherwise the first CPU
+	 * might complete its grace period before all of the other CPUs
+	 * did their increment, causing this function to return too
+	 * early.
+	 */
+	atomic_set(&rcu_barrier_cpu_count, 1);
+	preempt_disable(); /* stop CPU_DYING from filling orphan_cbs_list */
+	rcu_adopt_orphan_cbs(rsp);
+	on_each_cpu(rcu_barrier_func, (void *)call_rcu_func, 1);
+	preempt_enable(); /* CPU_DYING can again fill orphan_cbs_list */
+	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
+		complete(&rcu_barrier_completion);
+	wait_for_completion(&rcu_barrier_completion);
+	mutex_unlock(&rcu_barrier_mutex);
+}
+
+/**
+ * rcu_barrier_bh - Wait until all in-flight call_rcu_bh() callbacks complete.
+ */
+void rcu_barrier_bh(void)
+{
+	_rcu_barrier(&rcu_bh_state, call_rcu_bh);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier_bh);
+
+/**
+ * rcu_barrier_sched - Wait for in-flight call_rcu_sched() callbacks.
+ */
+void rcu_barrier_sched(void)
+{
+	_rcu_barrier(&rcu_sched_state, call_rcu_sched);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier_sched);
+
 /*
  * Do boot-time initialization of a CPU's per-CPU RCU data.
  */
@@ -1464,6 +1569,22 @@ int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	case CPU_UP_PREPARE_FROZEN:
 		rcu_online_cpu(cpu);
 		break;
+	case CPU_DYING:
+	case CPU_DYING_FROZEN:
+		/*
+		 * preempt_disable() in _rcu_barrier() prevents stop_machine(),
+		 * so when "on_each_cpu(rcu_barrier_func, (void *)type, 1);"
+		 * returns, all online cpus have queued rcu_barrier_func().
+		 * The dying CPU clears its cpu_online_mask bit and
+		 * moves all of its RCU callbacks to ->orphan_cbs_list
+		 * in the context of stop_machine(), so subsequent calls
+		 * to _rcu_barrier() will adopt these callbacks and only
+		 * then queue rcu_barrier_func() on all remaining CPUs.
+		 */
+		rcu_send_cbs_to_orphanage(&rcu_bh_state);
+		rcu_send_cbs_to_orphanage(&rcu_sched_state);
+		rcu_preempt_send_cbs_to_orphanage();
+		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 	case CPU_UP_CANCELED:
@@ -1526,7 +1647,8 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 		cpustride *= rsp->levelspread[i];
 		rnp = rsp->level[i];
 		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
-			spin_lock_init(&rnp->lock);
+			if (rnp != rcu_get_root(rsp))
+				spin_lock_init(&rnp->lock);
 			rnp->gpnum = 0;
 			rnp->qsmask = 0;
 			rnp->qsmaskinit = 0;
@@ -1549,6 +1671,7 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 			INIT_LIST_HEAD(&rnp->blocked_tasks[1]);
 		}
 	}
+	spin_lock_init(&rcu_get_root(rsp)->lock);
 }
 
 /*
@@ -1558,6 +1681,10 @@ static void __init rcu_init_one(struct rcu_state *rsp)
  */
 #define RCU_INIT_FLAVOR(rsp, rcu_data) \
 do { \
+	int i; \
+	int j; \
+	struct rcu_node *rnp; \
+	\
 	rcu_init_one(rsp); \
 	rnp = (rsp)->level[NUM_RCU_LVLS - 1]; \
 	j = 0; \
@@ -1570,31 +1697,8 @@ do { \
 	} \
 } while (0)
 
-#ifdef CONFIG_TREE_PREEMPT_RCU
-
-void __init __rcu_init_preempt(void)
-{
-	int i;			/* All used by RCU_INIT_FLAVOR(). */
-	int j;
-	struct rcu_node *rnp;
-
-	RCU_INIT_FLAVOR(&rcu_preempt_state, rcu_preempt_data);
-}
-
-#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-
-void __init __rcu_init_preempt(void)
-{
-}
-
-#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
-
 void __init __rcu_init(void)
 {
-	int i;			/* All used by RCU_INIT_FLAVOR(). */
-	int j;
-	struct rcu_node *rnp;
-
 	rcu_bootup_announce();
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
@@ -1605,6 +1709,4 @@ void __init __rcu_init(void)
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
-module_param(blimit, int, 0);
-module_param(qhimark, int, 0);
-module_param(qlowmark, int, 0);
+#include "rcutree_plugin.h"
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 8e8287a..b40ac57 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -48,14 +48,14 @@
 #elif NR_CPUS <= RCU_FANOUT_SQ
 #  define NUM_RCU_LVLS	      2
 #  define NUM_RCU_LVL_0	      1
-#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT - 1) / RCU_FANOUT)
+#  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT)
 #  define NUM_RCU_LVL_2	      (NR_CPUS)
 #  define NUM_RCU_LVL_3	      0
 #elif NR_CPUS <= RCU_FANOUT_CUBE
 #  define NUM_RCU_LVLS	      3
 #  define NUM_RCU_LVL_0	      1
-#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT_SQ - 1) / RCU_FANOUT_SQ)
-#  define NUM_RCU_LVL_2	      (((NR_CPUS) + (RCU_FANOUT) - 1) / (RCU_FANOUT))
+#  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_SQ)
+#  define NUM_RCU_LVL_2	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT)
 #  define NUM_RCU_LVL_3	      NR_CPUS
 #else
 # error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
@@ -79,15 +79,21 @@ struct rcu_dynticks {
  * Definition for node within the RCU grace-period-detection hierarchy.
  */
 struct rcu_node {
-	spinlock_t lock;
+	spinlock_t lock;	/* Root rcu_node's lock protects some */
+				/*  rcu_state fields as well as following. */
 	long	gpnum;		/* Current grace period for this node. */
 				/*  This will either be equal to or one */
 				/*  behind the root rcu_node's gpnum. */
 	unsigned long qsmask;	/* CPUs or groups that need to switch in */
 				/*  order for current grace period to proceed.*/
+				/*  In leaf rcu_node, each bit corresponds to */
+				/*  an rcu_data structure, otherwise, each */
+				/*  bit corresponds to a child rcu_node */
+				/*  structure. */
 	unsigned long qsmaskinit;
 				/* Per-GP initialization for qsmask. */
 	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
+				/*  Only one bit will be set in this mask. */
 	int	grplo;		/* lowest-numbered CPU or group here. */
 	int	grphi;		/* highest-numbered CPU or group here. */
 	u8	grpnum;		/* CPU/group number for next level up. */
@@ -95,8 +101,23 @@ struct rcu_node {
 	struct rcu_node *parent;
 	struct list_head blocked_tasks[2];
 				/* Tasks blocked in RCU read-side critsect. */
+				/*  Grace period number (->gpnum) x blocked */
+				/*  by tasks on the (x & 0x1) element of the */
+				/*  blocked_tasks[] array. */
 } ____cacheline_internodealigned_in_smp;
 
+/*
+ * Do a full breadth-first scan of the rcu_node structures for the
+ * specified rcu_state structure.
+ */
+#define rcu_for_each_node_breadth_first(rsp, rnp) \
+	for ((rnp) = &(rsp)->node[0]; \
+	     (rnp) < &(rsp)->node[NUM_RCU_NODES]; (rnp)++)
+
+#define rcu_for_each_leaf_node(rsp, rnp) \
+	for ((rnp) = (rsp)->level[NUM_RCU_LVLS - 1]; \
+	     (rnp) < &(rsp)->node[NUM_RCU_NODES]; (rnp)++)
+
 /* Index values for nxttail array in struct rcu_data. */
 #define RCU_DONE_TAIL		0	/* Also RCU_WAIT head. */
 #define RCU_WAIT_TAIL		1	/* Also RCU_NEXT_READY head. */
@@ -126,19 +147,22 @@ struct rcu_data {
 	 * Any of the partitions might be empty, in which case the
 	 * pointer to that partition will be equal to the pointer for
 	 * the following partition.  When the list is empty, all of
-	 * the nxttail elements point to nxtlist, which is NULL.
+	 * the nxttail elements point to the ->nxtlist pointer itself,
+	 * which in that case is NULL.
 	 *
-	 * [*nxttail[RCU_NEXT_READY_TAIL], NULL = *nxttail[RCU_NEXT_TAIL]):
-	 *	Entries that might have arrived after current GP ended
-	 * [*nxttail[RCU_WAIT_TAIL], *nxttail[RCU_NEXT_READY_TAIL]):
-	 *	Entries known to have arrived before current GP ended
-	 * [*nxttail[RCU_DONE_TAIL], *nxttail[RCU_WAIT_TAIL]):
-	 *	Entries that batch # <= ->completed - 1: waiting for current GP
 	 * [nxtlist, *nxttail[RCU_DONE_TAIL]):
 	 *	Entries that batch # <= ->completed
 	 *	The grace period for these entries has completed, and
 	 *	the other grace-period-completed entries may be moved
 	 *	here temporarily in rcu_process_callbacks().
+	 * [*nxttail[RCU_DONE_TAIL], *nxttail[RCU_WAIT_TAIL]):
+	 *	Entries that batch # <= ->completed - 1: waiting for current GP
+	 * [*nxttail[RCU_WAIT_TAIL], *nxttail[RCU_NEXT_READY_TAIL]):
+	 *	Entries known to have arrived before current GP ended
+	 * [*nxttail[RCU_NEXT_READY_TAIL], *nxttail[RCU_NEXT_TAIL]):
+	 *	Entries that might have arrived after current GP ended
+	 *	Note that the value of *nxttail[RCU_NEXT_TAIL] will
+	 *	always be NULL, as this is the end of the list.
 	 */
 	struct rcu_head *nxtlist;
 	struct rcu_head **nxttail[RCU_NEXT_SIZE];
@@ -216,8 +240,19 @@ struct rcu_state {
 						/* Force QS state. */
 	long	gpnum;				/* Current gp number. */
 	long	completed;			/* # of last completed gp. */
+
+	/* End  of fields guarded by root rcu_node's lock. */
+
 	spinlock_t onofflock;			/* exclude on/offline and */
-						/*  starting new GP. */
+						/*  starting new GP.  Also */
+						/*  protects the following */
+						/*  orphan_cbs fields. */
+	struct rcu_head *orphan_cbs_list;	/* list of rcu_head structs */
+						/*  orphaned by all CPUs in */
+						/*  a given leaf rcu_node */
+						/*  going offline. */
+	struct rcu_head **orphan_cbs_tail;	/* And tail pointer. */
+	long orphan_qlen;			/* Number of orphaned cbs. */
 	spinlock_t fqslock;			/* Only one task forcing */
 						/*  quiescent states. */
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
@@ -255,5 +290,30 @@ extern struct rcu_state rcu_preempt_state;
 DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
-#endif /* #ifdef RCU_TREE_NONCORE */
+#else /* #ifdef RCU_TREE_NONCORE */
+
+/* Forward declarations for rcutree_plugin.h */
+static inline void rcu_bootup_announce(void);
+long rcu_batches_completed(void);
+static void rcu_preempt_note_context_switch(int cpu);
+static int rcu_preempted_readers(struct rcu_node *rnp);
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+static void rcu_print_task_stall(struct rcu_node *rnp);
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
+#ifdef CONFIG_HOTPLUG_CPU
+static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
+				      struct rcu_node *rnp,
+				      struct rcu_data *rdp);
+static void rcu_preempt_offline_cpu(int cpu);
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+static void rcu_preempt_check_callbacks(int cpu);
+static void rcu_preempt_process_callbacks(void);
+void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
+static int rcu_preempt_pending(int cpu);
+static int rcu_preempt_needs_cpu(int cpu);
+static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
+static void rcu_preempt_send_cbs_to_orphanage(void);
+static void __init __rcu_init_preempt(void);
 
+#endif /* #else #ifdef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 1cee04f..c0cb783 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -150,6 +150,16 @@ void __rcu_read_lock(void)
 }
 EXPORT_SYMBOL_GPL(__rcu_read_lock);
 
+/*
+ * Check for preempted RCU readers blocking the current grace period
+ * for the specified rcu_node structure.  If the caller needs a reliable
+ * answer, it must hold the rcu_node's ->lock.
+ */
+static int rcu_preempted_readers(struct rcu_node *rnp)
+{
+	return !list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]);
+}
+
 static void rcu_read_unlock_special(struct task_struct *t)
 {
 	int empty;
@@ -196,7 +206,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 				break;
 			spin_unlock(&rnp->lock);  /* irqs remain disabled. */
 		}
-		empty = list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]);
+		empty = !rcu_preempted_readers(rnp);
 		list_del_init(&t->rcu_node_entry);
 		t->rcu_blocked_node = NULL;
 
@@ -207,7 +217,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		 * drop rnp->lock and restore irq.
 		 */
 		if (!empty && rnp->qsmask == 0 &&
-		    list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1])) {
+		    !rcu_preempted_readers(rnp)) {
 			struct rcu_node *rnp_p;
 
 			if (rnp->parent == NULL) {
@@ -257,12 +267,12 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
 {
 	unsigned long flags;
 	struct list_head *lp;
-	int phase = rnp->gpnum & 0x1;
+	int phase;
 	struct task_struct *t;
 
-	if (!list_empty(&rnp->blocked_tasks[phase])) {
+	if (rcu_preempted_readers(rnp)) {
 		spin_lock_irqsave(&rnp->lock, flags);
-		phase = rnp->gpnum & 0x1; /* re-read under lock. */
+		phase = rnp->gpnum & 0x1;
 		lp = &rnp->blocked_tasks[phase];
 		list_for_each_entry(t, lp, rcu_node_entry)
 			printk(" P%d", t->pid);
@@ -281,20 +291,10 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
  */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 {
-	WARN_ON_ONCE(!list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]));
+	WARN_ON_ONCE(rcu_preempted_readers(rnp));
 	WARN_ON_ONCE(rnp->qsmask);
 }
 
-/*
- * Check for preempted RCU readers for the specified rcu_node structure.
- * If the caller needs a reliable answer, it must hold the rcu_node's
- * >lock.
- */
-static int rcu_preempted_readers(struct rcu_node *rnp)
-{
-	return !list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]);
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 
 /*
@@ -410,6 +410,15 @@ static int rcu_preempt_needs_cpu(int cpu)
 	return !!per_cpu(rcu_preempt_data, cpu).nxtlist;
 }
 
+/**
+ * rcu_barrier - Wait until all in-flight call_rcu() callbacks complete.
+ */
+void rcu_barrier(void)
+{
+	_rcu_barrier(&rcu_preempt_state, call_rcu);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier);
+
 /*
  * Initialize preemptable RCU's per-CPU data.
  */
@@ -419,6 +428,22 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 }
 
 /*
+ * Move preemptable RCU's callbacks to ->orphan_cbs_list.
+ */
+static void rcu_preempt_send_cbs_to_orphanage(void)
+{
+	rcu_send_cbs_to_orphanage(&rcu_preempt_state);
+}
+
+/*
+ * Initialize preemptable RCU's state structures.
+ */
+static void __init __rcu_init_preempt(void)
+{
+	RCU_INIT_FLAVOR(&rcu_preempt_state, rcu_preempt_data);
+}
+
+/*
  * Check for a task exiting while in a preemptable-RCU read-side
  * critical section, clean up if so.  No need to issue warnings,
  * as debug_check_no_locks_held() already does this if lockdep
@@ -461,6 +486,15 @@ static void rcu_preempt_note_context_switch(int cpu)
 {
 }
 
+/*
+ * Because preemptable RCU does not exist, there are never any preempted
+ * RCU readers.
+ */
+static int rcu_preempted_readers(struct rcu_node *rnp)
+{
+	return 0;
+}
+
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
 /*
@@ -483,15 +517,6 @@ static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 	WARN_ON_ONCE(rnp->qsmask);
 }
 
-/*
- * Because preemptable RCU does not exist, there are never any preempted
- * RCU readers.
- */
-static int rcu_preempted_readers(struct rcu_node *rnp)
-{
-	return 0;
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 
 /*
@@ -518,7 +543,7 @@ static void rcu_preempt_offline_cpu(int cpu)
  * Because preemptable RCU does not exist, it never has any callbacks
  * to check.
  */
-void rcu_preempt_check_callbacks(int cpu)
+static void rcu_preempt_check_callbacks(int cpu)
 {
 }
 
@@ -526,7 +551,7 @@ void rcu_preempt_check_callbacks(int cpu)
  * Because preemptable RCU does not exist, it never has any callbacks
  * to process.
  */
-void rcu_preempt_process_callbacks(void)
+static void rcu_preempt_process_callbacks(void)
 {
 }
 
@@ -556,6 +581,16 @@ static int rcu_preempt_needs_cpu(int cpu)
 }
 
 /*
+ * Because preemptable RCU does not exist, rcu_barrier() is just
+ * another name for rcu_barrier_sched().
+ */
+void rcu_barrier(void)
+{
+	rcu_barrier_sched();
+}
+EXPORT_SYMBOL_GPL(rcu_barrier);
+
+/*
  * Because preemptable RCU does not exist, there is no per-CPU
  * data to initialize.
  */
@@ -563,4 +598,18 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 {
 }
 
+/*
+ * Because there is no preemptable RCU, there are no callbacks to move.
+ */
+static void rcu_preempt_send_cbs_to_orphanage(void)
+{
+}
+
+/*
+ * Because preemptable RCU does not exist, it need not be initialized.
+ */
+static void __init __rcu_init_preempt(void)
+{
+}
+
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index c89f5e9..4b31c77 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -93,7 +93,7 @@ static int rcudata_open(struct inode *inode, struct file *file)
 	return single_open(file, show_rcudata, NULL);
 }
 
-static struct file_operations rcudata_fops = {
+static const struct file_operations rcudata_fops = {
 	.owner = THIS_MODULE,
 	.open = rcudata_open,
 	.read = seq_read,
@@ -145,7 +145,7 @@ static int rcudata_csv_open(struct inode *inode, struct file *file)
 	return single_open(file, show_rcudata_csv, NULL);
 }
 
-static struct file_operations rcudata_csv_fops = {
+static const struct file_operations rcudata_csv_fops = {
 	.owner = THIS_MODULE,
 	.open = rcudata_csv_open,
 	.read = seq_read,
@@ -159,13 +159,13 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 	struct rcu_node *rnp;
 
 	seq_printf(m, "c=%ld g=%ld s=%d jfq=%ld j=%x "
-	              "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu\n",
+		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld\n",
 		   rsp->completed, rsp->gpnum, rsp->signaled,
 		   (long)(rsp->jiffies_force_qs - jiffies),
 		   (int)(jiffies & 0xffff),
 		   rsp->n_force_qs, rsp->n_force_qs_ngp,
 		   rsp->n_force_qs - rsp->n_force_qs_ngp,
-		   rsp->n_force_qs_lh);
+		   rsp->n_force_qs_lh, rsp->orphan_qlen);
 	for (rnp = &rsp->node[0]; rnp - &rsp->node[0] < NUM_RCU_NODES; rnp++) {
 		if (rnp->level != level) {
 			seq_puts(m, "\n");
@@ -196,7 +196,7 @@ static int rcuhier_open(struct inode *inode, struct file *file)
 	return single_open(file, show_rcuhier, NULL);
 }
 
-static struct file_operations rcuhier_fops = {
+static const struct file_operations rcuhier_fops = {
 	.owner = THIS_MODULE,
 	.open = rcuhier_open,
 	.read = seq_read,
@@ -222,7 +222,7 @@ static int rcugp_open(struct inode *inode, struct file *file)
 	return single_open(file, show_rcugp, NULL);
 }
 
-static struct file_operations rcugp_fops = {
+static const struct file_operations rcugp_fops = {
 	.owner = THIS_MODULE,
 	.open = rcugp_open,
 	.read = seq_read,
@@ -276,7 +276,7 @@ static int rcu_pending_open(struct inode *inode, struct file *file)
 	return single_open(file, show_rcu_pending, NULL);
 }
 
-static struct file_operations rcu_pending_fops = {
+static const struct file_operations rcu_pending_fops = {
 	.owner = THIS_MODULE,
 	.open = rcu_pending_open,
 	.read = seq_read,
