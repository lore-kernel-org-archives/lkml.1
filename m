Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849Ab0CMQgs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 11:36:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55309 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932862Ab0CMQgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 11:36:46 -0500
Date: Sat, 13 Mar 2010 17:35:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20100313163556.GA14263@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
FUJITA Tomonori (1):
      x86/gart: Unexport gart_iommu_aperture

Luca Barbieri (1):
      locking: Make sparse work with inline spinlocks and rwlocks

Paul E. McKenney (13):
      rcu: Fix holdoff for accelerated GPs for last non-dynticked CPU
      rcu: Make task_subsys_state() RCU-lockdep checks handle boot-time use
      sched, rcu: Fix rcu_dereference() for RCU-lockdep
      rcu: Use wrapper function instead of exporting tasklist_lock
      rcu, cgroup: Relax the check in task_subsys_state() as early boot is now handled by lockdep-RCU
      rcu: Add control variables to lockdep_rcu_dereference() diagnostics
      rcu: Make rcu_read_lock_sched_held() handle !PREEMPT
      rcu: Suppress __mpol_dup() false positive from RCU lockdep
      rcu, ftrace: Fix RCU lockdep splat in ftrace_perf_buf_prepare()
      rcu: Suppress RCU lockdep warnings during early boot
      ftrace: Replace read_barrier_depends() with rcu_dereference_raw()
      rcu: Increase RCU CPU stall timeouts if PROVE_RCU
      x86/mce: Fix RCU lockdep splats

Thomas Gleixner (1):
      futex: Protect pid lookup in compat code with RCU


 arch/x86/kernel/aperture_64.c      |    1 -
 arch/x86/kernel/cpu/mcheck/mce.c   |   11 ++++++--
 include/linux/cred.h               |    2 +-
 include/linux/rcupdate.h           |   45 ++++++++++++++++++++++++++++-------
 include/linux/rwlock.h             |   20 ++++++++--------
 include/linux/sched.h              |    4 +++
 include/linux/spinlock.h           |   13 ++++++----
 include/trace/ftrace.h             |    4 +-
 kernel/exit.c                      |    2 +-
 kernel/fork.c                      |    9 ++++++-
 kernel/futex_compat.c              |    6 ++--
 kernel/lockdep.c                   |    1 +
 kernel/pid.c                       |    4 ++-
 kernel/rcutree.h                   |   21 ++++++++++++----
 kernel/rcutree_plugin.h            |    8 ++++--
 kernel/sched_fair.c                |    2 +-
 kernel/trace/ftrace.c              |   22 ++++++++++-------
 kernel/trace/trace_event_profile.c |    4 +-
 mm/mempolicy.c                     |    2 +
 19 files changed, 123 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index f147a95..3704997 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -31,7 +31,6 @@
 #include <asm/x86_init.h>
 
 int gart_iommu_aperture;
-EXPORT_SYMBOL_GPL(gart_iommu_aperture);
 int gart_iommu_aperture_disabled __initdata;
 int gart_iommu_aperture_allowed __initdata;
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a8aacd4..4442e9e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -46,6 +46,11 @@
 
 #include "mce-internal.h"
 
+#define rcu_dereference_check_mce(p) \
+	rcu_dereference_check((p), \
+			      rcu_read_lock_sched_held() || \
+			      lockdep_is_held(&mce_read_mutex))
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/mce.h>
 
@@ -158,7 +163,7 @@ void mce_log(struct mce *mce)
 	mce->finished = 0;
 	wmb();
 	for (;;) {
-		entry = rcu_dereference(mcelog.next);
+		entry = rcu_dereference_check_mce(mcelog.next);
 		for (;;) {
 			/*
 			 * When the buffer fills up discard new entries.
@@ -1500,7 +1505,7 @@ static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 		return -ENOMEM;
 
 	mutex_lock(&mce_read_mutex);
-	next = rcu_dereference(mcelog.next);
+	next = rcu_dereference_check_mce(mcelog.next);
 
 	/* Only supports full reads right now */
 	if (*off != 0 || usize < MCE_LOG_LEN*sizeof(struct mce)) {
@@ -1565,7 +1570,7 @@ timeout:
 static unsigned int mce_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &mce_wait, wait);
-	if (rcu_dereference(mcelog.next))
+	if (rcu_dereference_check_mce(mcelog.next))
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 4db09f8..52507c3 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -280,7 +280,7 @@ static inline void put_cred(const struct cred *_cred)
  * task or by holding tasklist_lock to prevent it from being unlinked.
  */
 #define __task_cred(task) \
-	((const struct cred *)(rcu_dereference_check((task)->real_cred, rcu_read_lock_held() || lockdep_is_held(&tasklist_lock))))
+	((const struct cred *)(rcu_dereference_check((task)->real_cred, rcu_read_lock_held() || lockdep_tasklist_lock_is_held())))
 
 /**
  * get_task_cred - Get another task's objective credentials
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index c843736..75921b8 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -97,6 +97,11 @@ extern struct lockdep_map rcu_sched_lock_map;
 # define rcu_read_release_sched() \
 		lock_release(&rcu_sched_lock_map, 1, _THIS_IP_)
 
+static inline int debug_lockdep_rcu_enabled(void)
+{
+	return likely(rcu_scheduler_active && debug_locks);
+}
+
 /**
  * rcu_read_lock_held - might we be in RCU read-side critical section?
  *
@@ -104,12 +109,14 @@ extern struct lockdep_map rcu_sched_lock_map;
  * an RCU read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
  * this assumes we are in an RCU read-side critical section unless it can
  * prove otherwise.
+ *
+ * Check rcu_scheduler_active to prevent false positives during boot.
  */
 static inline int rcu_read_lock_held(void)
 {
-	if (debug_locks)
-		return lock_is_held(&rcu_lock_map);
-	return 1;
+	if (!debug_lockdep_rcu_enabled())
+		return 1;
+	return lock_is_held(&rcu_lock_map);
 }
 
 /**
@@ -119,12 +126,14 @@ static inline int rcu_read_lock_held(void)
  * an RCU-bh read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
  * this assumes we are in an RCU-bh read-side critical section unless it can
  * prove otherwise.
+ *
+ * Check rcu_scheduler_active to prevent false positives during boot.
  */
 static inline int rcu_read_lock_bh_held(void)
 {
-	if (debug_locks)
-		return lock_is_held(&rcu_bh_lock_map);
-	return 1;
+	if (!debug_lockdep_rcu_enabled())
+		return 1;
+	return lock_is_held(&rcu_bh_lock_map);
 }
 
 /**
@@ -135,15 +144,26 @@ static inline int rcu_read_lock_bh_held(void)
  * this assumes we are in an RCU-sched read-side critical section unless it
  * can prove otherwise.  Note that disabling of preemption (including
  * disabling irqs) counts as an RCU-sched read-side critical section.
+ *
+ * Check rcu_scheduler_active to prevent false positives during boot.
  */
+#ifdef CONFIG_PREEMPT
 static inline int rcu_read_lock_sched_held(void)
 {
 	int lockdep_opinion = 0;
 
+	if (!debug_lockdep_rcu_enabled())
+		return 1;
 	if (debug_locks)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
-	return lockdep_opinion || preempt_count() != 0 || !rcu_scheduler_active;
+	return lockdep_opinion || preempt_count() != 0;
+}
+#else /* #ifdef CONFIG_PREEMPT */
+static inline int rcu_read_lock_sched_held(void)
+{
+	return 1;
 }
+#endif /* #else #ifdef CONFIG_PREEMPT */
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
@@ -164,10 +184,17 @@ static inline int rcu_read_lock_bh_held(void)
 	return 1;
 }
 
+#ifdef CONFIG_PREEMPT
 static inline int rcu_read_lock_sched_held(void)
 {
-	return preempt_count() != 0 || !rcu_scheduler_active;
+	return !rcu_scheduler_active || preempt_count() != 0;
+}
+#else /* #ifdef CONFIG_PREEMPT */
+static inline int rcu_read_lock_sched_held(void)
+{
+	return 1;
 }
+#endif /* #else #ifdef CONFIG_PREEMPT */
 
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
@@ -184,7 +211,7 @@ static inline int rcu_read_lock_sched_held(void)
  */
 #define rcu_dereference_check(p, c) \
 	({ \
-		if (debug_locks && !(c)) \
+		if (debug_lockdep_rcu_enabled() && !(c)) \
 			lockdep_rcu_dereference(__FILE__, __LINE__); \
 		rcu_dereference_raw(p); \
 	})
diff --git a/include/linux/rwlock.h b/include/linux/rwlock.h
index 71e0b00..bc2994e 100644
--- a/include/linux/rwlock.h
+++ b/include/linux/rwlock.h
@@ -29,25 +29,25 @@ do {								\
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK
- extern void do_raw_read_lock(rwlock_t *lock);
+ extern void do_raw_read_lock(rwlock_t *lock) __acquires(lock);
 #define do_raw_read_lock_flags(lock, flags) do_raw_read_lock(lock)
  extern int do_raw_read_trylock(rwlock_t *lock);
- extern void do_raw_read_unlock(rwlock_t *lock);
- extern void do_raw_write_lock(rwlock_t *lock);
+ extern void do_raw_read_unlock(rwlock_t *lock) __releases(lock);
+ extern void do_raw_write_lock(rwlock_t *lock) __acquires(lock);
 #define do_raw_write_lock_flags(lock, flags) do_raw_write_lock(lock)
  extern int do_raw_write_trylock(rwlock_t *lock);
- extern void do_raw_write_unlock(rwlock_t *lock);
+ extern void do_raw_write_unlock(rwlock_t *lock) __releases(lock);
 #else
-# define do_raw_read_lock(rwlock)	arch_read_lock(&(rwlock)->raw_lock)
+# define do_raw_read_lock(rwlock)	do {__acquire(lock); arch_read_lock(&(rwlock)->raw_lock); } while (0)
 # define do_raw_read_lock_flags(lock, flags) \
-		arch_read_lock_flags(&(lock)->raw_lock, *(flags))
+		do {__acquire(lock); arch_read_lock_flags(&(lock)->raw_lock, *(flags)); } while (0)
 # define do_raw_read_trylock(rwlock)	arch_read_trylock(&(rwlock)->raw_lock)
-# define do_raw_read_unlock(rwlock)	arch_read_unlock(&(rwlock)->raw_lock)
-# define do_raw_write_lock(rwlock)	arch_write_lock(&(rwlock)->raw_lock)
+# define do_raw_read_unlock(rwlock)	do {arch_read_unlock(&(rwlock)->raw_lock); __release(lock); } while (0)
+# define do_raw_write_lock(rwlock)	do {__acquire(lock); arch_write_lock(&(rwlock)->raw_lock); } while (0)
 # define do_raw_write_lock_flags(lock, flags) \
-		arch_write_lock_flags(&(lock)->raw_lock, *(flags))
+		do {__acquire(lock); arch_write_lock_flags(&(lock)->raw_lock, *(flags)); } while (0)
 # define do_raw_write_trylock(rwlock)	arch_write_trylock(&(rwlock)->raw_lock)
-# define do_raw_write_unlock(rwlock)	arch_write_unlock(&(rwlock)->raw_lock)
+# define do_raw_write_unlock(rwlock)	do {arch_write_unlock(&(rwlock)->raw_lock); __release(lock); } while (0)
 #endif
 
 #define read_can_lock(rwlock)		arch_read_can_lock(&(rwlock)->raw_lock)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0eef87b..a47af20 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -258,6 +258,10 @@ extern spinlock_t mmlist_lock;
 
 struct task_struct;
 
+#ifdef CONFIG_PROVE_RCU
+extern int lockdep_tasklist_lock_is_held(void);
+#endif /* #ifdef CONFIG_PROVE_RCU */
+
 extern void sched_init(void);
 extern void sched_init_smp(void);
 extern asmlinkage void schedule_tail(struct task_struct *prev);
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 8608821..89fac6a 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -128,19 +128,21 @@ static inline void smp_mb__after_lock(void) { smp_mb(); }
 #define raw_spin_unlock_wait(lock)	arch_spin_unlock_wait(&(lock)->raw_lock)
 
 #ifdef CONFIG_DEBUG_SPINLOCK
- extern void do_raw_spin_lock(raw_spinlock_t *lock);
+ extern void do_raw_spin_lock(raw_spinlock_t *lock) __acquires(lock);
 #define do_raw_spin_lock_flags(lock, flags) do_raw_spin_lock(lock)
  extern int do_raw_spin_trylock(raw_spinlock_t *lock);
- extern void do_raw_spin_unlock(raw_spinlock_t *lock);
+ extern void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock);
 #else
-static inline void do_raw_spin_lock(raw_spinlock_t *lock)
+static inline void do_raw_spin_lock(raw_spinlock_t *lock) __acquires(lock)
 {
+	__acquire(lock);
 	arch_spin_lock(&lock->raw_lock);
 }
 
 static inline void
-do_raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long *flags)
+do_raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long *flags) __acquires(lock)
 {
+	__acquire(lock);
 	arch_spin_lock_flags(&lock->raw_lock, *flags);
 }
 
@@ -149,9 +151,10 @@ static inline int do_raw_spin_trylock(raw_spinlock_t *lock)
 	return arch_spin_trylock(&(lock)->raw_lock);
 }
 
-static inline void do_raw_spin_unlock(raw_spinlock_t *lock)
+static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
 {
 	arch_spin_unlock(&lock->raw_lock);
+	__release(lock);
 }
 #endif
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 0804cd5..601ad77 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -699,9 +699,9 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
  *	__cpu = smp_processor_id();
  *
  *	if (in_nmi())
- *		trace_buf = rcu_dereference(perf_trace_buf_nmi);
+ *		trace_buf = rcu_dereference_sched(perf_trace_buf_nmi);
  *	else
- *		trace_buf = rcu_dereference(perf_trace_buf);
+ *		trace_buf = rcu_dereference_sched(perf_trace_buf);
  *
  *	if (!trace_buf)
  *		goto end;
diff --git a/kernel/exit.c b/kernel/exit.c
index 45ed043..fed3a4d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -87,7 +87,7 @@ static void __exit_signal(struct task_struct *tsk)
 
 	sighand = rcu_dereference_check(tsk->sighand,
 					rcu_read_lock_held() ||
-					lockdep_is_held(&tasklist_lock));
+					lockdep_tasklist_lock_is_held());
 	spin_lock(&sighand->siglock);
 
 	posix_cpu_timers_exit(tsk);
diff --git a/kernel/fork.c b/kernel/fork.c
index 17bbf09..8691c54 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -86,7 +86,14 @@ int max_threads;		/* tunable limit on nr_threads */
 DEFINE_PER_CPU(unsigned long, process_counts) = 0;
 
 __cacheline_aligned DEFINE_RWLOCK(tasklist_lock);  /* outer */
-EXPORT_SYMBOL_GPL(tasklist_lock);
+
+#ifdef CONFIG_PROVE_RCU
+int lockdep_tasklist_lock_is_held(void)
+{
+	return lockdep_is_held(&tasklist_lock);
+}
+EXPORT_SYMBOL_GPL(lockdep_tasklist_lock_is_held);
+#endif /* #ifdef CONFIG_PROVE_RCU */
 
 int nr_processes(void)
 {
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 2357165..d49afb2 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -146,7 +146,7 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 		struct task_struct *p;
 
 		ret = -ESRCH;
-		read_lock(&tasklist_lock);
+		rcu_read_lock();
 		p = find_task_by_vpid(pid);
 		if (!p)
 			goto err_unlock;
@@ -157,7 +157,7 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 		    !capable(CAP_SYS_PTRACE))
 			goto err_unlock;
 		head = p->compat_robust_list;
-		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 	}
 
 	if (put_user(sizeof(*head), len_ptr))
@@ -165,7 +165,7 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 	return put_user(ptr_to_compat(head), head_ptr);
 
 err_unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	return ret;
 }
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 0c30d04..681bc2e 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3822,6 +3822,7 @@ void lockdep_rcu_dereference(const char *file, const int line)
 	printk("%s:%d invoked rcu_dereference_check() without protection!\n",
 			file, line);
 	printk("\nother info that might help us debug this:\n\n");
+	printk("\nrcu_scheduler_active = %d, debug_locks = %d\n", rcu_scheduler_active, debug_locks);
 	lockdep_print_held_locks(curr);
 	printk("\nstack backtrace:\n");
 	dump_stack();
diff --git a/kernel/pid.c b/kernel/pid.c
index b08e697..b606440 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -367,7 +367,9 @@ struct task_struct *pid_task(struct pid *pid, enum pid_type type)
 	struct task_struct *result = NULL;
 	if (pid) {
 		struct hlist_node *first;
-		first = rcu_dereference_check(pid->tasks[type].first, rcu_read_lock_held() || lockdep_is_held(&tasklist_lock));
+		first = rcu_dereference_check(pid->tasks[type].first,
+					      rcu_read_lock_held() ||
+					      lockdep_tasklist_lock_is_held());
 		if (first)
 			result = hlist_entry(first, struct task_struct, pids[(type)].node);
 	}
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 1439eb5..4a525a3 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -246,12 +246,21 @@ struct rcu_data {
 
 #define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-#define RCU_SECONDS_TILL_STALL_CHECK   (10 * HZ)  /* for rsp->jiffies_stall */
-#define RCU_SECONDS_TILL_STALL_RECHECK (30 * HZ)  /* for rsp->jiffies_stall */
-#define RCU_STALL_RAT_DELAY		2	  /* Allow other CPUs time */
-						  /*  to take at least one */
-						  /*  scheduling clock irq */
-						  /*  before ratting on them. */
+
+#ifdef CONFIG_PROVE_RCU
+#define RCU_STALL_DELAY_DELTA	       (5 * HZ)
+#else
+#define RCU_STALL_DELAY_DELTA	       0
+#endif
+
+#define RCU_SECONDS_TILL_STALL_CHECK   (10 * HZ + RCU_STALL_DELAY_DELTA)
+						/* for rsp->jiffies_stall */
+#define RCU_SECONDS_TILL_STALL_RECHECK (30 * HZ + RCU_STALL_DELAY_DELTA)
+						/* for rsp->jiffies_stall */
+#define RCU_STALL_RAT_DELAY		2	/* Allow other CPUs time */
+						/*  to take at least one */
+						/*  scheduling clock irq */
+						/*  before ratting on them. */
 
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 464ad2c..79b53bd 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1010,6 +1010,10 @@ int rcu_needs_cpu(int cpu)
 	int c = 0;
 	int thatcpu;
 
+	/* Check for being in the holdoff period. */
+	if (per_cpu(rcu_dyntick_holdoff, cpu) == jiffies)
+		return rcu_needs_cpu_quick_check(cpu);
+
 	/* Don't bother unless we are the last non-dyntick-idle CPU. */
 	for_each_cpu_not(thatcpu, nohz_cpu_mask)
 		if (thatcpu != cpu) {
@@ -1041,10 +1045,8 @@ int rcu_needs_cpu(int cpu)
 	}
 
 	/* If RCU callbacks are still pending, RCU still needs this CPU. */
-	if (c) {
+	if (c)
 		raise_softirq(RCU_SOFTIRQ);
-		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
-	}
 	return c;
 }
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3e1fd96..5a5ea2c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3476,7 +3476,7 @@ static void run_rebalance_domains(struct softirq_action *h)
 
 static inline int on_null_domain(int cpu)
 {
-	return !rcu_dereference(cpu_rq(cpu)->sd);
+	return !rcu_dereference_sched(cpu_rq(cpu)->sd);
 }
 
 /*
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8378357..8c5adc0 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -27,6 +27,7 @@
 #include <linux/ctype.h>
 #include <linux/list.h>
 #include <linux/hash.h>
+#include <linux/rcupdate.h>
 
 #include <trace/events/sched.h>
 
@@ -88,18 +89,22 @@ ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
 static int ftrace_set_func(unsigned long *array, int *idx, char *buffer);
 #endif
 
+/*
+ * Traverse the ftrace_list, invoking all entries.  The reason that we
+ * can use rcu_dereference_raw() is that elements removed from this list
+ * are simply leaked, so there is no need to interact with a grace-period
+ * mechanism.  The rcu_dereference_raw() calls are needed to handle
+ * concurrent insertions into the ftrace_list.
+ *
+ * Silly Alpha and silly pointer-speculation compiler optimizations!
+ */
 static void ftrace_list_func(unsigned long ip, unsigned long parent_ip)
 {
-	struct ftrace_ops *op = ftrace_list;
-
-	/* in case someone actually ports this to alpha! */
-	read_barrier_depends();
+	struct ftrace_ops *op = rcu_dereference_raw(ftrace_list); /*see above*/
 
 	while (op != &ftrace_list_end) {
-		/* silly alpha */
-		read_barrier_depends();
 		op->func(ip, parent_ip);
-		op = op->next;
+		op = rcu_dereference_raw(op->next); /*see above*/
 	};
 }
 
@@ -154,8 +159,7 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	 * the ops->next pointer is valid before another CPU sees
 	 * the ops pointer included into the ftrace_list.
 	 */
-	smp_wmb();
-	ftrace_list = ops;
+	rcu_assign_pointer(ftrace_list, ops);
 
 	if (ftrace_enabled) {
 		ftrace_func_t func;
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index f0d6930..c1cc3ab 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -138,9 +138,9 @@ __kprobes void *ftrace_perf_buf_prepare(int size, unsigned short type,
 	cpu = smp_processor_id();
 
 	if (in_nmi())
-		trace_buf = rcu_dereference(perf_trace_buf_nmi);
+		trace_buf = rcu_dereference_sched(perf_trace_buf_nmi);
 	else
-		trace_buf = rcu_dereference(perf_trace_buf);
+		trace_buf = rcu_dereference_sched(perf_trace_buf);
 
 	if (!trace_buf)
 		goto err;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 290fb5b..3cec080 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1730,10 +1730,12 @@ struct mempolicy *__mpol_dup(struct mempolicy *old)
 
 	if (!new)
 		return ERR_PTR(-ENOMEM);
+	rcu_read_lock();
 	if (current_cpuset_is_being_rebound()) {
 		nodemask_t mems = cpuset_mems_allowed(current);
 		mpol_rebind_policy(old, &mems);
 	}
+	rcu_read_unlock();
 	*new = *old;
 	atomic_set(&new->refcnt, 1);
 	return new;
