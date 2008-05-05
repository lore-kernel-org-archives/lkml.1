Return-Path: <linux-kernel-owner+w=401wt.eu-S1761290AbYEEW7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290AbYEEW7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbYEEW6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:58:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53931 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760396AbYEEW6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:58:37 -0400
Date: Tue, 6 May 2008 00:58:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20080505225823.GA24204@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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


Linus, please pull the latest scheduler fixes git tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-fixes.git for-linus

this tree got booted up ~10 times on x86. Thanks,

	Ingo

------------------>
Andrew Morton (1):
      sched: add debug checks to idle functions

David Simner (1):
      sched: fix sched_info_switch not being called according to documentation

Gregory Haskins (2):
      sched: fix RT task-wakeup logic
      sched: fix SCHED_FAIR wake-idle logic error

Harvey Harrison (2):
      sched: make rt_sched_class, idle_sched_class static
      sched: add statics, don't return void expressions

Heiko Carstens (1):
      sched: fix missing locking in sched_domains code

Ingo Molnar (4):
      sched: remove old sched doc
      sched: make clock sync tunable by architecture code
      sched: fix cpu clock
      sched, x86: add HAVE_UNSTABLE_SCHED_CLOCK

Miao Xie (1):
      sched: fair-group: fix a Div0 error of the fair group scheduler

Mike Galbraith (1):
      sched: fix debugging

Parag Warudkar (1):
      sched: default to n for GROUP_SCHED and FAIR_GROUP_SCHED

Peter Zijlstra (4):
      sched: fix normalized sleeper
      sched: optimize calc_delta_mine()
      sched: fix hrtick_start_fair and CPU-Hotplug
      sched: add optional support for CONFIG_HAVE_UNSTABLE_SCHED_CLOCK

 Documentation/scheduler/sched-design.txt |  165 ---------------
 arch/x86/Kconfig                         |    1 +
 include/linux/sched.h                    |   38 ++++-
 init/Kconfig                             |   11 +-
 init/main.c                              |    1 +
 kernel/Makefile                          |    2 +-
 kernel/sched.c                           |  323 ++++++++++++------------------
 kernel/sched_clock.c                     |  236 ++++++++++++++++++++++
 kernel/sched_debug.c                     |    7 -
 kernel/sched_fair.c                      |   39 +---
 kernel/sched_idletask.c                  |    2 +-
 kernel/sched_rt.c                        |    9 +-
 12 files changed, 428 insertions(+), 406 deletions(-)
 delete mode 100644 Documentation/scheduler/sched-design.txt
 create mode 100644 kernel/sched_clock.c

diff --git a/Documentation/scheduler/sched-design.txt b/Documentation/scheduler/sched-design.txt
deleted file mode 100644
index 1605bf0..0000000
--- a/Documentation/scheduler/sched-design.txt
+++ /dev/null
@@ -1,165 +0,0 @@
-		   Goals, Design and Implementation of the
-		      new ultra-scalable O(1) scheduler
-
-
-  This is an edited version of an email Ingo Molnar sent to
-  lkml on 4 Jan 2002.  It describes the goals, design, and
-  implementation of Ingo's new ultra-scalable O(1) scheduler.
-  Last Updated: 18 April 2002.
-
-
-Goal
-====
-
-The main goal of the new scheduler is to keep all the good things we know
-and love about the current Linux scheduler:
-
- - good interactive performance even during high load: if the user
-   types or clicks then the system must react instantly and must execute
-   the user tasks smoothly, even during considerable background load.
-
- - good scheduling/wakeup performance with 1-2 runnable processes.
-
- - fairness: no process should stay without any timeslice for any
-   unreasonable amount of time. No process should get an unjustly high
-   amount of CPU time.
-
- - priorities: less important tasks can be started with lower priority,
-   more important tasks with higher priority.
-
- - SMP efficiency: no CPU should stay idle if there is work to do.
-
- - SMP affinity: processes which run on one CPU should stay affine to
-   that CPU. Processes should not bounce between CPUs too frequently.
-
- - plus additional scheduler features: RT scheduling, CPU binding.
-
-and the goal is also to add a few new things:
-
- - fully O(1) scheduling. Are you tired of the recalculation loop
-   blowing the L1 cache away every now and then? Do you think the goodness
-   loop is taking a bit too long to finish if there are lots of runnable
-   processes? This new scheduler takes no prisoners: wakeup(), schedule(),
-   the timer interrupt are all O(1) algorithms. There is no recalculation
-   loop. There is no goodness loop either.
-
- - 'perfect' SMP scalability. With the new scheduler there is no 'big'
-   runqueue_lock anymore - it's all per-CPU runqueues and locks - two
-   tasks on two separate CPUs can wake up, schedule and context-switch
-   completely in parallel, without any interlocking. All
-   scheduling-relevant data is structured for maximum scalability.
-
- - better SMP affinity. The old scheduler has a particular weakness that
-   causes the random bouncing of tasks between CPUs if/when higher
-   priority/interactive tasks, this was observed and reported by many
-   people. The reason is that the timeslice recalculation loop first needs
-   every currently running task to consume its timeslice. But when this
-   happens on eg. an 8-way system, then this property starves an
-   increasing number of CPUs from executing any process. Once the last
-   task that has a timeslice left has finished using up that timeslice,
-   the recalculation loop is triggered and other CPUs can start executing
-   tasks again - after having idled around for a number of timer ticks.
-   The more CPUs, the worse this effect.
-
-   Furthermore, this same effect causes the bouncing effect as well:
-   whenever there is such a 'timeslice squeeze' of the global runqueue,
-   idle processors start executing tasks which are not affine to that CPU.
-   (because the affine tasks have finished off their timeslices already.)
-
-   The new scheduler solves this problem by distributing timeslices on a
-   per-CPU basis, without having any global synchronization or
-   recalculation.
-
- - batch scheduling. A significant proportion of computing-intensive tasks
-   benefit from batch-scheduling, where timeslices are long and processes
-   are roundrobin scheduled. The new scheduler does such batch-scheduling
-   of the lowest priority tasks - so nice +19 jobs will get
-   'batch-scheduled' automatically. With this scheduler, nice +19 jobs are
-   in essence SCHED_IDLE, from an interactiveness point of view.
-
- - handle extreme loads more smoothly, without breakdown and scheduling
-   storms.
-
- - O(1) RT scheduling. For those RT folks who are paranoid about the
-   O(nr_running) property of the goodness loop and the recalculation loop.
-
- - run fork()ed children before the parent. Andrea has pointed out the
-   advantages of this a few months ago, but patches for this feature
-   do not work with the old scheduler as well as they should,
-   because idle processes often steal the new child before the fork()ing
-   CPU gets to execute it.
-
-
-Design
-======
-
-The core of the new scheduler contains the following mechanisms:
-
- - *two* priority-ordered 'priority arrays' per CPU. There is an 'active'
-   array and an 'expired' array. The active array contains all tasks that
-   are affine to this CPU and have timeslices left. The expired array
-   contains all tasks which have used up their timeslices - but this array
-   is kept sorted as well. The active and expired array is not accessed
-   directly, it's accessed through two pointers in the per-CPU runqueue
-   structure. If all active tasks are used up then we 'switch' the two
-   pointers and from now on the ready-to-go (former-) expired array is the
-   active array - and the empty active array serves as the new collector
-   for expired tasks.
-
- - there is a 64-bit bitmap cache for array indices. Finding the highest
-   priority task is thus a matter of two x86 BSFL bit-search instructions.
-
-the split-array solution enables us to have an arbitrary number of active
-and expired tasks, and the recalculation of timeslices can be done
-immediately when the timeslice expires. Because the arrays are always
-access through the pointers in the runqueue, switching the two arrays can
-be done very quickly.
-
-this is a hybride priority-list approach coupled with roundrobin
-scheduling and the array-switch method of distributing timeslices.
-
- - there is a per-task 'load estimator'.
-
-one of the toughest things to get right is good interactive feel during
-heavy system load. While playing with various scheduler variants i found
-that the best interactive feel is achieved not by 'boosting' interactive
-tasks, but by 'punishing' tasks that want to use more CPU time than there
-is available. This method is also much easier to do in an O(1) fashion.
-
-to establish the actual 'load' the task contributes to the system, a
-complex-looking but pretty accurate method is used: there is a 4-entry
-'history' ringbuffer of the task's activities during the last 4 seconds.
-This ringbuffer is operated without much overhead. The entries tell the
-scheduler a pretty accurate load-history of the task: has it used up more
-CPU time or less during the past N seconds. [the size '4' and the interval
-of 4x 1 seconds was found by lots of experimentation - this part is
-flexible and can be changed in both directions.]
-
-the penalty a task gets for generating more load than the CPU can handle
-is a priority decrease - there is a maximum amount to this penalty
-relative to their static priority, so even fully CPU-bound tasks will
-observe each other's priorities, and will share the CPU accordingly.
-
-the SMP load-balancer can be extended/switched with additional parallel
-computing and cache hierarchy concepts: NUMA scheduling, multi-core CPUs
-can be supported easily by changing the load-balancer. Right now it's
-tuned for my SMP systems.
-
-i skipped the prev->mm == next->mm advantage - no workload i know of shows
-any sensitivity to this. It can be added back by sacrificing O(1)
-schedule() [the current and one-lower priority list can be searched for a
-that->mm == current->mm condition], but costs a fair number of cycles
-during a number of important workloads, so i wanted to avoid this as much
-as possible.
-
-- the SMP idle-task startup code was still racy and the new scheduler
-triggered this. So i streamlined the idle-setup code a bit. We do not call
-into schedule() before all processors have started up fully and all idle
-threads are in place.
-
-- the patch also cleans up a number of aspects of sched.c - moves code
-into other areas of the kernel where it's appropriate, and simplifies
-certain code paths and data constructs. As a result, the new scheduler's
-code is smaller than the old one.
-
-	Ingo
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 845ea2b..bbcafaa 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -18,6 +18,7 @@ config X86_64
 ### Arch settings
 config X86
 	def_bool y
+	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 03c2380..0c35b03 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -158,6 +158,8 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 }
 #endif
 
+extern unsigned long long time_sync_thresh;
+
 /*
  * Task state bitmask. NOTE! These bits are also
  * encoded in fs/proc/array.c: get_task_state().
@@ -1551,6 +1553,35 @@ static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 
 extern unsigned long long sched_clock(void);
 
+#ifndef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
+static inline void sched_clock_init(void)
+{
+}
+
+static inline u64 sched_clock_cpu(int cpu)
+{
+	return sched_clock();
+}
+
+static inline void sched_clock_tick(void)
+{
+}
+
+static inline void sched_clock_idle_sleep_event(void)
+{
+}
+
+static inline void sched_clock_idle_wakeup_event(u64 delta_ns)
+{
+}
+#else
+extern void sched_clock_init(void);
+extern u64 sched_clock_cpu(int cpu);
+extern void sched_clock_tick(void);
+extern void sched_clock_idle_sleep_event(void);
+extern void sched_clock_idle_wakeup_event(u64 delta_ns);
+#endif
+
 /*
  * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
  * clock constructed from sched_clock():
@@ -1977,6 +2008,11 @@ static inline void clear_tsk_need_resched(struct task_struct *tsk)
 	clear_tsk_thread_flag(tsk,TIF_NEED_RESCHED);
 }
 
+static inline int test_tsk_need_resched(struct task_struct *tsk)
+{
+	return unlikely(test_tsk_thread_flag(tsk,TIF_NEED_RESCHED));
+}
+
 static inline int signal_pending(struct task_struct *p)
 {
 	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
@@ -1991,7 +2027,7 @@ static inline int fatal_signal_pending(struct task_struct *p)
 
 static inline int need_resched(void)
 {
-	return unlikely(test_thread_flag(TIF_NEED_RESCHED));
+	return unlikely(test_tsk_need_resched(current));
 }
 
 /*
diff --git a/init/Kconfig b/init/Kconfig
index f0e62e5..4c33316 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -316,9 +316,16 @@ config CPUSETS
 
 	  Say N if unsure.
 
+#
+# Architectures with an unreliable sched_clock() should select this:
+#
+config HAVE_UNSTABLE_SCHED_CLOCK
+	bool
+
 config GROUP_SCHED
 	bool "Group CPU scheduler"
-	default y
+	depends on EXPERIMENTAL
+	default n
 	help
 	  This feature lets CPU scheduler recognize task groups and control CPU
 	  bandwidth allocation to such task groups.
@@ -326,7 +333,7 @@ config GROUP_SCHED
 config FAIR_GROUP_SCHED
 	bool "Group scheduling for SCHED_OTHER"
 	depends on GROUP_SCHED
-	default y
+	default GROUP_SCHED
 
 config RT_GROUP_SCHED
 	bool "Group scheduling for SCHED_RR/FIFO"
diff --git a/init/main.c b/init/main.c
index a87d4ca..ddada7a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -602,6 +602,7 @@ asmlinkage void __init start_kernel(void)
 	softirq_init();
 	timekeeping_init();
 	time_init();
+	sched_clock_init();
 	profile_init();
 	if (!irqs_disabled())
 		printk("start_kernel(): bug: interrupts were enabled early\n");
diff --git a/kernel/Makefile b/kernel/Makefile
index 188c432..1c9938a 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
-	    notifier.o ksysfs.o pm_qos_params.o
+	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o
 
 obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
diff --git a/kernel/sched.c b/kernel/sched.c
index 34bcc5b..58fb8af 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -75,16 +75,6 @@
 #include <asm/irq_regs.h>
 
 /*
- * Scheduler clock - returns current time in nanosec units.
- * This is default implementation.
- * Architectures and sub-architectures can override this.
- */
-unsigned long long __attribute__((weak)) sched_clock(void)
-{
-	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
-}
-
-/*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
  * and back.
@@ -242,6 +232,12 @@ static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
 }
 #endif
 
+/*
+ * sched_domains_mutex serializes calls to arch_init_sched_domains,
+ * detach_destroy_domains and partition_sched_domains.
+ */
+static DEFINE_MUTEX(sched_domains_mutex);
+
 #ifdef CONFIG_GROUP_SCHED
 
 #include <linux/cgroup.h>
@@ -308,9 +304,6 @@ static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
  */
 static DEFINE_SPINLOCK(task_group_lock);
 
-/* doms_cur_mutex serializes access to doms_cur[] array */
-static DEFINE_MUTEX(doms_cur_mutex);
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_USER_SCHED
 # define INIT_TASK_GROUP_LOAD	(2*NICE_0_LOAD)
@@ -318,7 +311,13 @@ static DEFINE_MUTEX(doms_cur_mutex);
 # define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
 #endif
 
+/*
+ * A weight of 0, 1 or ULONG_MAX can cause arithmetics problems.
+ * (The default weight is 1024 - so there's no practical
+ *  limitation from this.)
+ */
 #define MIN_SHARES	2
+#define MAX_SHARES	(ULONG_MAX - 1)
 
 static int init_task_group_load = INIT_TASK_GROUP_LOAD;
 #endif
@@ -358,21 +357,9 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 #endif
 }
 
-static inline void lock_doms_cur(void)
-{
-	mutex_lock(&doms_cur_mutex);
-}
-
-static inline void unlock_doms_cur(void)
-{
-	mutex_unlock(&doms_cur_mutex);
-}
-
 #else
 
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
-static inline void lock_doms_cur(void) { }
-static inline void unlock_doms_cur(void) { }
 
 #endif	/* CONFIG_GROUP_SCHED */
 
@@ -560,13 +547,7 @@ struct rq {
 	unsigned long next_balance;
 	struct mm_struct *prev_mm;
 
-	u64 clock, prev_clock_raw;
-	s64 clock_max_delta;
-
-	unsigned int clock_warps, clock_overflows, clock_underflows;
-	u64 idle_clock;
-	unsigned int clock_deep_idle_events;
-	u64 tick_timestamp;
+	u64 clock;
 
 	atomic_t nr_iowait;
 
@@ -631,82 +612,6 @@ static inline int cpu_of(struct rq *rq)
 #endif
 }
 
-#ifdef CONFIG_NO_HZ
-static inline bool nohz_on(int cpu)
-{
-	return tick_get_tick_sched(cpu)->nohz_mode != NOHZ_MODE_INACTIVE;
-}
-
-static inline u64 max_skipped_ticks(struct rq *rq)
-{
-	return nohz_on(cpu_of(rq)) ? jiffies - rq->last_tick_seen + 2 : 1;
-}
-
-static inline void update_last_tick_seen(struct rq *rq)
-{
-	rq->last_tick_seen = jiffies;
-}
-#else
-static inline u64 max_skipped_ticks(struct rq *rq)
-{
-	return 1;
-}
-
-static inline void update_last_tick_seen(struct rq *rq)
-{
-}
-#endif
-
-/*
- * Update the per-runqueue clock, as finegrained as the platform can give
- * us, but without assuming monotonicity, etc.:
- */
-static void __update_rq_clock(struct rq *rq)
-{
-	u64 prev_raw = rq->prev_clock_raw;
-	u64 now = sched_clock();
-	s64 delta = now - prev_raw;
-	u64 clock = rq->clock;
-
-#ifdef CONFIG_SCHED_DEBUG
-	WARN_ON_ONCE(cpu_of(rq) != smp_processor_id());
-#endif
-	/*
-	 * Protect against sched_clock() occasionally going backwards:
-	 */
-	if (unlikely(delta < 0)) {
-		clock++;
-		rq->clock_warps++;
-	} else {
-		/*
-		 * Catch too large forward jumps too:
-		 */
-		u64 max_jump = max_skipped_ticks(rq) * TICK_NSEC;
-		u64 max_time = rq->tick_timestamp + max_jump;
-
-		if (unlikely(clock + delta > max_time)) {
-			if (clock < max_time)
-				clock = max_time;
-			else
-				clock++;
-			rq->clock_overflows++;
-		} else {
-			if (unlikely(delta > rq->clock_max_delta))
-				rq->clock_max_delta = delta;
-			clock += delta;
-		}
-	}
-
-	rq->prev_clock_raw = now;
-	rq->clock = clock;
-}
-
-static void update_rq_clock(struct rq *rq)
-{
-	if (likely(smp_processor_id() == cpu_of(rq)))
-		__update_rq_clock(rq);
-}
-
 /*
  * The domain tree (rq->sd) is protected by RCU's quiescent state transition.
  * See detach_destroy_domains: synchronize_sched for details.
@@ -722,6 +627,11 @@ static void update_rq_clock(struct rq *rq)
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 
+static inline void update_rq_clock(struct rq *rq)
+{
+	rq->clock = sched_clock_cpu(cpu_of(rq));
+}
+
 /*
  * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
  */
@@ -757,14 +667,14 @@ const_debug unsigned int sysctl_sched_features =
 #define SCHED_FEAT(name, enabled)	\
 	#name ,
 
-__read_mostly char *sched_feat_names[] = {
+static __read_mostly char *sched_feat_names[] = {
 #include "sched_features.h"
 	NULL
 };
 
 #undef SCHED_FEAT
 
-int sched_feat_open(struct inode *inode, struct file *filp)
+static int sched_feat_open(struct inode *inode, struct file *filp)
 {
 	filp->private_data = inode->i_private;
 	return 0;
@@ -899,7 +809,7 @@ static inline u64 global_rt_runtime(void)
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
 }
 
-static const unsigned long long time_sync_thresh = 100000;
+unsigned long long time_sync_thresh = 100000;
 
 static DEFINE_PER_CPU(unsigned long long, time_offset);
 static DEFINE_PER_CPU(unsigned long long, prev_cpu_time);
@@ -913,11 +823,14 @@ static DEFINE_PER_CPU(unsigned long long, prev_cpu_time);
 static DEFINE_SPINLOCK(time_sync_lock);
 static unsigned long long prev_global_time;
 
-static unsigned long long __sync_cpu_clock(cycles_t time, int cpu)
+static unsigned long long __sync_cpu_clock(unsigned long long time, int cpu)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&time_sync_lock, flags);
+	/*
+	 * We want this inlined, to not get tracer function calls
+	 * in this critical section:
+	 */
+	spin_acquire(&time_sync_lock.dep_map, 0, 0, _THIS_IP_);
+	__raw_spin_lock(&time_sync_lock.raw_lock);
 
 	if (time < prev_global_time) {
 		per_cpu(time_offset, cpu) += prev_global_time - time;
@@ -926,7 +839,8 @@ static unsigned long long __sync_cpu_clock(cycles_t time, int cpu)
 		prev_global_time = time;
 	}
 
-	spin_unlock_irqrestore(&time_sync_lock, flags);
+	__raw_spin_unlock(&time_sync_lock.raw_lock);
+	spin_release(&time_sync_lock.dep_map, 1, _THIS_IP_);
 
 	return time;
 }
@@ -934,8 +848,6 @@ static unsigned long long __sync_cpu_clock(cycles_t time, int cpu)
 static unsigned long long __cpu_clock(int cpu)
 {
 	unsigned long long now;
-	unsigned long flags;
-	struct rq *rq;
 
 	/*
 	 * Only call sched_clock() if the scheduler has already been
@@ -944,11 +856,7 @@ static unsigned long long __cpu_clock(int cpu)
 	if (unlikely(!scheduler_running))
 		return 0;
 
-	local_irq_save(flags);
-	rq = cpu_rq(cpu);
-	update_rq_clock(rq);
-	now = rq->clock;
-	local_irq_restore(flags);
+	now = sched_clock_cpu(cpu);
 
 	return now;
 }
@@ -960,13 +868,18 @@ static unsigned long long __cpu_clock(int cpu)
 unsigned long long cpu_clock(int cpu)
 {
 	unsigned long long prev_cpu_time, time, delta_time;
+	unsigned long flags;
 
+	local_irq_save(flags);
 	prev_cpu_time = per_cpu(prev_cpu_time, cpu);
 	time = __cpu_clock(cpu) + per_cpu(time_offset, cpu);
 	delta_time = time-prev_cpu_time;
 
-	if (unlikely(delta_time > time_sync_thresh))
+	if (unlikely(delta_time > time_sync_thresh)) {
 		time = __sync_cpu_clock(time, cpu);
+		per_cpu(prev_cpu_time, cpu) = time;
+	}
+	local_irq_restore(flags);
 
 	return time;
 }
@@ -1117,43 +1030,6 @@ static struct rq *this_rq_lock(void)
 	return rq;
 }
 
-/*
- * We are going deep-idle (irqs are disabled):
- */
-void sched_clock_idle_sleep_event(void)
-{
-	struct rq *rq = cpu_rq(smp_processor_id());
-
-	spin_lock(&rq->lock);
-	__update_rq_clock(rq);
-	spin_unlock(&rq->lock);
-	rq->clock_deep_idle_events++;
-}
-EXPORT_SYMBOL_GPL(sched_clock_idle_sleep_event);
-
-/*
- * We just idled delta nanoseconds (called with irqs disabled):
- */
-void sched_clock_idle_wakeup_event(u64 delta_ns)
-{
-	struct rq *rq = cpu_rq(smp_processor_id());
-	u64 now = sched_clock();
-
-	rq->idle_clock += delta_ns;
-	/*
-	 * Override the previous timestamp and ignore all
-	 * sched_clock() deltas that occured while we idled,
-	 * and use the PM-provided delta_ns to advance the
-	 * rq clock:
-	 */
-	spin_lock(&rq->lock);
-	rq->prev_clock_raw = now;
-	rq->clock += delta_ns;
-	spin_unlock(&rq->lock);
-	touch_softlockup_watchdog();
-}
-EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
-
 static void __resched_task(struct task_struct *p, int tif_bit);
 
 static inline void resched_task(struct task_struct *p)
@@ -1189,6 +1065,7 @@ static inline void resched_rq(struct rq *rq)
 enum {
 	HRTICK_SET,		/* re-programm hrtick_timer */
 	HRTICK_RESET,		/* not a new slice */
+	HRTICK_BLOCK,		/* stop hrtick operations */
 };
 
 /*
@@ -1200,6 +1077,8 @@ static inline int hrtick_enabled(struct rq *rq)
 {
 	if (!sched_feat(HRTICK))
 		return 0;
+	if (unlikely(test_bit(HRTICK_BLOCK, &rq->hrtick_flags)))
+		return 0;
 	return hrtimer_is_hres_active(&rq->hrtick_timer);
 }
 
@@ -1275,14 +1154,70 @@ static enum hrtimer_restart hrtick(struct hrtimer *timer)
 	WARN_ON_ONCE(cpu_of(rq) != smp_processor_id());
 
 	spin_lock(&rq->lock);
-	__update_rq_clock(rq);
+	update_rq_clock(rq);
 	rq->curr->sched_class->task_tick(rq, rq->curr, 1);
 	spin_unlock(&rq->lock);
 
 	return HRTIMER_NORESTART;
 }
 
-static inline void init_rq_hrtick(struct rq *rq)
+static void hotplug_hrtick_disable(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
+	rq->hrtick_flags = 0;
+	__set_bit(HRTICK_BLOCK, &rq->hrtick_flags);
+	spin_unlock_irqrestore(&rq->lock, flags);
+
+	hrtick_clear(rq);
+}
+
+static void hotplug_hrtick_enable(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
+	__clear_bit(HRTICK_BLOCK, &rq->hrtick_flags);
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
+
+static int
+hotplug_hrtick(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
+	int cpu = (int)(long)hcpu;
+
+	switch (action) {
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		hotplug_hrtick_disable(cpu);
+		return NOTIFY_OK;
+
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		hotplug_hrtick_enable(cpu);
+		return NOTIFY_OK;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static void init_hrtick(void)
+{
+	hotcpu_notifier(hotplug_hrtick, 0);
+}
+
+static void init_rq_hrtick(struct rq *rq)
 {
 	rq->hrtick_flags = 0;
 	hrtimer_init(&rq->hrtick_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
@@ -1319,6 +1254,10 @@ static inline void init_rq_hrtick(struct rq *rq)
 void hrtick_resched(void)
 {
 }
+
+static inline void init_hrtick(void)
+{
+}
 #endif
 
 /*
@@ -1438,8 +1377,8 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 {
 	u64 tmp;
 
-	if (unlikely(!lw->inv_weight))
-		lw->inv_weight = (WMULT_CONST-lw->weight/2) / (lw->weight+1);
+	if (!lw->inv_weight)
+		lw->inv_weight = 1 + (WMULT_CONST-lw->weight/2)/(lw->weight+1);
 
 	tmp = (u64)delta_exec * weight;
 	/*
@@ -1748,6 +1687,8 @@ __update_group_shares_cpu(struct task_group *tg, struct sched_domain *sd,
 
 	if (shares < MIN_SHARES)
 		shares = MIN_SHARES;
+	else if (shares > MAX_SHARES)
+		shares = MAX_SHARES;
 
 	__set_se_shares(tg->se[tcpu], shares);
 }
@@ -4339,8 +4280,10 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	struct rq *rq = this_rq();
 	cputime64_t tmp;
 
-	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0))
-		return account_guest_time(p, cputime);
+	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
+		account_guest_time(p, cputime);
+		return;
+	}
 
 	p->stime = cputime_add(p->stime, cputime);
 
@@ -4404,19 +4347,11 @@ void scheduler_tick(void)
 	int cpu = smp_processor_id();
 	struct rq *rq = cpu_rq(cpu);
 	struct task_struct *curr = rq->curr;
-	u64 next_tick = rq->tick_timestamp + TICK_NSEC;
+
+	sched_clock_tick();
 
 	spin_lock(&rq->lock);
-	__update_rq_clock(rq);
-	/*
-	 * Let rq->clock advance by at least TICK_NSEC:
-	 */
-	if (unlikely(rq->clock < next_tick)) {
-		rq->clock = next_tick;
-		rq->clock_underflows++;
-	}
-	rq->tick_timestamp = rq->clock;
-	update_last_tick_seen(rq);
+	update_rq_clock(rq);
 	update_cpu_load(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
 	spin_unlock(&rq->lock);
@@ -4570,7 +4505,7 @@ need_resched_nonpreemptible:
 	 * Do the rq-clock update outside the rq lock:
 	 */
 	local_irq_disable();
-	__update_rq_clock(rq);
+	update_rq_clock(rq);
 	spin_lock(&rq->lock);
 	clear_tsk_need_resched(prev);
 
@@ -4595,9 +4530,9 @@ need_resched_nonpreemptible:
 	prev->sched_class->put_prev_task(rq, prev);
 	next = pick_next_task(rq, prev);
 
-	sched_info_switch(prev, next);
-
 	if (likely(prev != next)) {
+		sched_info_switch(prev, next);
+
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;
@@ -7755,7 +7690,7 @@ void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
 {
 	int i, j;
 
-	lock_doms_cur();
+	mutex_lock(&sched_domains_mutex);
 
 	/* always unregister in case we don't destroy any domains */
 	unregister_sched_domain_sysctl();
@@ -7804,7 +7739,7 @@ match2:
 
 	register_sched_domain_sysctl();
 
-	unlock_doms_cur();
+	mutex_unlock(&sched_domains_mutex);
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
@@ -7813,8 +7748,10 @@ int arch_reinit_sched_domains(void)
 	int err;
 
 	get_online_cpus();
+	mutex_lock(&sched_domains_mutex);
 	detach_destroy_domains(&cpu_online_map);
 	err = arch_init_sched_domains(&cpu_online_map);
+	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();
 
 	return err;
@@ -7932,13 +7869,16 @@ void __init sched_init_smp(void)
 	BUG_ON(sched_group_nodes_bycpu == NULL);
 #endif
 	get_online_cpus();
+	mutex_lock(&sched_domains_mutex);
 	arch_init_sched_domains(&cpu_online_map);
 	cpus_andnot(non_isolated_cpus, cpu_possible_map, cpu_isolated_map);
 	if (cpus_empty(non_isolated_cpus))
 		cpu_set(smp_processor_id(), non_isolated_cpus);
+	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();
 	/* XXX: Theoretical race here - CPU may be hotplugged now */
 	hotcpu_notifier(update_sched_domains, 0);
+	init_hrtick();
 
 	/* Move init over to a non-isolated CPU */
 	if (set_cpus_allowed_ptr(current, &non_isolated_cpus) < 0)
@@ -8025,7 +7965,7 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 
 	se->my_q = cfs_rq;
 	se->load.weight = tg->shares;
-	se->load.inv_weight = div64_u64(1ULL<<32, se->load.weight);
+	se->load.inv_weight = 0;
 	se->parent = parent;
 }
 #endif
@@ -8149,8 +8089,6 @@ void __init sched_init(void)
 		spin_lock_init(&rq->lock);
 		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
 		rq->nr_running = 0;
-		rq->clock = 1;
-		update_last_tick_seen(rq);
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -8294,6 +8232,7 @@ EXPORT_SYMBOL(__might_sleep);
 static void normalize_task(struct rq *rq, struct task_struct *p)
 {
 	int on_rq;
+
 	update_rq_clock(rq);
 	on_rq = p->se.on_rq;
 	if (on_rq)
@@ -8325,7 +8264,6 @@ void normalize_rt_tasks(void)
 		p->se.sleep_start		= 0;
 		p->se.block_start		= 0;
 #endif
-		task_rq(p)->clock		= 0;
 
 		if (!rt_task(p)) {
 			/*
@@ -8692,7 +8630,7 @@ static void __set_se_shares(struct sched_entity *se, unsigned long shares)
 		dequeue_entity(cfs_rq, se, 0);
 
 	se->load.weight = shares;
-	se->load.inv_weight = div64_u64((1ULL<<32), shares);
+	se->load.inv_weight = 0;
 
 	if (on_rq)
 		enqueue_entity(cfs_rq, se, 0);
@@ -8722,13 +8660,10 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 	if (!tg->se[0])
 		return -EINVAL;
 
-	/*
-	 * A weight of 0 or 1 can cause arithmetics problems.
-	 * (The default weight is 1024 - so there's no practical
-	 *  limitation from this.)
-	 */
 	if (shares < MIN_SHARES)
 		shares = MIN_SHARES;
+	else if (shares > MAX_SHARES)
+		shares = MAX_SHARES;
 
 	mutex_lock(&shares_mutex);
 	if (tg->shares == shares)
@@ -8753,7 +8688,7 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 		 * force a rebalance
 		 */
 		cfs_rq_set_shares(tg->cfs_rq[i], 0);
-		set_se_shares(tg->se[i], shares/nr_cpu_ids);
+		set_se_shares(tg->se[i], shares);
 	}
 
 	/*
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
new file mode 100644
index 0000000..9c597e3
--- /dev/null
+++ b/kernel/sched_clock.c
@@ -0,0 +1,236 @@
+/*
+ * sched_clock for unstable cpu clocks
+ *
+ *  Copyright (C) 2008 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *
+ * Based on code by:
+ *   Ingo Molnar <mingo@redhat.com>
+ *   Guillaume Chazarain <guichaz@gmail.com>
+ *
+ * Create a semi stable clock from a mixture of other events, including:
+ *  - gtod
+ *  - jiffies
+ *  - sched_clock()
+ *  - explicit idle events
+ *
+ * We use gtod as base and the unstable clock deltas. The deltas are filtered,
+ * making it monotonic and keeping it within an expected window.  This window
+ * is set up using jiffies.
+ *
+ * Furthermore, explicit sleep and wakeup hooks allow us to account for time
+ * that is otherwise invisible (TSC gets stopped).
+ *
+ * The clock: sched_clock_cpu() is monotonic per cpu, and should be somewhat
+ * consistent between cpus (never more than 1 jiffies difference).
+ */
+#include <linux/sched.h>
+#include <linux/percpu.h>
+#include <linux/spinlock.h>
+#include <linux/ktime.h>
+#include <linux/module.h>
+
+
+#ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
+
+struct sched_clock_data {
+	/*
+	 * Raw spinlock - this is a special case: this might be called
+	 * from within instrumentation code so we dont want to do any
+	 * instrumentation ourselves.
+	 */
+	raw_spinlock_t		lock;
+
+	unsigned long		prev_jiffies;
+	u64			prev_raw;
+	u64			tick_raw;
+	u64			tick_gtod;
+	u64			clock;
+};
+
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_clock_data, sched_clock_data);
+
+static inline struct sched_clock_data *this_scd(void)
+{
+	return &__get_cpu_var(sched_clock_data);
+}
+
+static inline struct sched_clock_data *cpu_sdc(int cpu)
+{
+	return &per_cpu(sched_clock_data, cpu);
+}
+
+void sched_clock_init(void)
+{
+	u64 ktime_now = ktime_to_ns(ktime_get());
+	u64 now = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct sched_clock_data *scd = cpu_sdc(cpu);
+
+		scd->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+		scd->prev_jiffies = jiffies;
+		scd->prev_raw = now;
+		scd->tick_raw = now;
+		scd->tick_gtod = ktime_now;
+		scd->clock = ktime_now;
+	}
+}
+
+/*
+ * update the percpu scd from the raw @now value
+ *
+ *  - filter out backward motion
+ *  - use jiffies to generate a min,max window to clip the raw values
+ */
+static void __update_sched_clock(struct sched_clock_data *scd, u64 now)
+{
+	unsigned long now_jiffies = jiffies;
+	long delta_jiffies = now_jiffies - scd->prev_jiffies;
+	u64 clock = scd->clock;
+	u64 min_clock, max_clock;
+	s64 delta = now - scd->prev_raw;
+
+	WARN_ON_ONCE(!irqs_disabled());
+	min_clock = scd->tick_gtod + delta_jiffies * TICK_NSEC;
+
+	if (unlikely(delta < 0)) {
+		clock++;
+		goto out;
+	}
+
+	max_clock = min_clock + TICK_NSEC;
+
+	if (unlikely(clock + delta > max_clock)) {
+		if (clock < max_clock)
+			clock = max_clock;
+		else
+			clock++;
+	} else {
+		clock += delta;
+	}
+
+ out:
+	if (unlikely(clock < min_clock))
+		clock = min_clock;
+
+	scd->prev_raw = now;
+	scd->prev_jiffies = now_jiffies;
+	scd->clock = clock;
+}
+
+static void lock_double_clock(struct sched_clock_data *data1,
+				struct sched_clock_data *data2)
+{
+	if (data1 < data2) {
+		__raw_spin_lock(&data1->lock);
+		__raw_spin_lock(&data2->lock);
+	} else {
+		__raw_spin_lock(&data2->lock);
+		__raw_spin_lock(&data1->lock);
+	}
+}
+
+u64 sched_clock_cpu(int cpu)
+{
+	struct sched_clock_data *scd = cpu_sdc(cpu);
+	u64 now, clock;
+
+	WARN_ON_ONCE(!irqs_disabled());
+	now = sched_clock();
+
+	if (cpu != raw_smp_processor_id()) {
+		/*
+		 * in order to update a remote cpu's clock based on our
+		 * unstable raw time rebase it against:
+		 *   tick_raw		(offset between raw counters)
+		 *   tick_gotd          (tick offset between cpus)
+		 */
+		struct sched_clock_data *my_scd = this_scd();
+
+		lock_double_clock(scd, my_scd);
+
+		now -= my_scd->tick_raw;
+		now += scd->tick_raw;
+
+		now -= my_scd->tick_gtod;
+		now += scd->tick_gtod;
+
+		__raw_spin_unlock(&my_scd->lock);
+	} else {
+		__raw_spin_lock(&scd->lock);
+	}
+
+	__update_sched_clock(scd, now);
+	clock = scd->clock;
+
+	__raw_spin_unlock(&scd->lock);
+
+	return clock;
+}
+
+void sched_clock_tick(void)
+{
+	struct sched_clock_data *scd = this_scd();
+	u64 now, now_gtod;
+
+	WARN_ON_ONCE(!irqs_disabled());
+
+	now = sched_clock();
+	now_gtod = ktime_to_ns(ktime_get());
+
+	__raw_spin_lock(&scd->lock);
+	__update_sched_clock(scd, now);
+	/*
+	 * update tick_gtod after __update_sched_clock() because that will
+	 * already observe 1 new jiffy; adding a new tick_gtod to that would
+	 * increase the clock 2 jiffies.
+	 */
+	scd->tick_raw = now;
+	scd->tick_gtod = now_gtod;
+	__raw_spin_unlock(&scd->lock);
+}
+
+/*
+ * We are going deep-idle (irqs are disabled):
+ */
+void sched_clock_idle_sleep_event(void)
+{
+	sched_clock_cpu(smp_processor_id());
+}
+EXPORT_SYMBOL_GPL(sched_clock_idle_sleep_event);
+
+/*
+ * We just idled delta nanoseconds (called with irqs disabled):
+ */
+void sched_clock_idle_wakeup_event(u64 delta_ns)
+{
+	struct sched_clock_data *scd = this_scd();
+	u64 now = sched_clock();
+
+	/*
+	 * Override the previous timestamp and ignore all
+	 * sched_clock() deltas that occured while we idled,
+	 * and use the PM-provided delta_ns to advance the
+	 * rq clock:
+	 */
+	__raw_spin_lock(&scd->lock);
+	scd->prev_raw = now;
+	scd->clock += delta_ns;
+	__raw_spin_unlock(&scd->lock);
+
+	touch_softlockup_watchdog();
+}
+EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
+
+#endif
+
+/*
+ * Scheduler clock - returns current time in nanosec units.
+ * This is default implementation.
+ * Architectures and sub-architectures can override this.
+ */
+unsigned long long __attribute__((weak)) sched_clock(void)
+{
+	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
+}
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 6b4a125..5f06118 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -204,13 +204,6 @@ static void print_cpu(struct seq_file *m, int cpu)
 	PN(next_balance);
 	P(curr->pid);
 	PN(clock);
-	PN(idle_clock);
-	PN(prev_clock_raw);
-	P(clock_warps);
-	P(clock_overflows);
-	P(clock_underflows);
-	P(clock_deep_idle_events);
-	PN(clock_max_delta);
 	P(cpu_load[0]);
 	P(cpu_load[1]);
 	P(cpu_load[2]);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 89fa32b..c863663 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -682,6 +682,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
+	account_entity_enqueue(cfs_rq, se);
 
 	if (wakeup) {
 		place_entity(cfs_rq, se, 0);
@@ -692,7 +693,6 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
 	check_spread(cfs_rq, se);
 	if (se != cfs_rq->curr)
 		__enqueue_entity(cfs_rq, se);
-	account_entity_enqueue(cfs_rq, se);
 }
 
 static void update_avg(u64 *avg, u64 sample)
@@ -841,8 +841,10 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	 * queued ticks are scheduled to match the slice, so don't bother
 	 * validating it and just reschedule.
 	 */
-	if (queued)
-		return resched_task(rq_of(cfs_rq)->curr);
+	if (queued) {
+		resched_task(rq_of(cfs_rq)->curr);
+		return;
+	}
 	/*
 	 * don't let the period tick interfere with the hrtick preemption
 	 */
@@ -957,7 +959,7 @@ static void yield_task_fair(struct rq *rq)
 		return;
 
 	if (likely(!sysctl_sched_compat_yield) && curr->policy != SCHED_BATCH) {
-		__update_rq_clock(rq);
+		update_rq_clock(rq);
 		/*
 		 * Update run-time statistics of the 'current'.
 		 */
@@ -1007,7 +1009,7 @@ static int wake_idle(int cpu, struct task_struct *p)
 	 * sibling runqueue info. This will avoid the checks and cache miss
 	 * penalities associated with that.
 	 */
-	if (idle_cpu(cpu) || cpu_rq(cpu)->nr_running > 1)
+	if (idle_cpu(cpu) || cpu_rq(cpu)->cfs.nr_running > 1)
 		return cpu;
 
 	for_each_domain(cpu, sd) {
@@ -1611,30 +1613,6 @@ static const struct sched_class fair_sched_class = {
 };
 
 #ifdef CONFIG_SCHED_DEBUG
-static void
-print_cfs_rq_tasks(struct seq_file *m, struct cfs_rq *cfs_rq, int depth)
-{
-	struct sched_entity *se;
-
-	if (!cfs_rq)
-		return;
-
-	list_for_each_entry_rcu(se, &cfs_rq->tasks, group_node) {
-		int i;
-
-		for (i = depth; i; i--)
-			seq_puts(m, "  ");
-
-		seq_printf(m, "%lu %s %lu\n",
-				se->load.weight,
-				entity_is_task(se) ? "T" : "G",
-				calc_delta_weight(SCHED_LOAD_SCALE, se)
-				);
-		if (!entity_is_task(se))
-			print_cfs_rq_tasks(m, group_cfs_rq(se), depth + 1);
-	}
-}
-
 static void print_cfs_stats(struct seq_file *m, int cpu)
 {
 	struct cfs_rq *cfs_rq;
@@ -1642,9 +1620,6 @@ static void print_cfs_stats(struct seq_file *m, int cpu)
 	rcu_read_lock();
 	for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
 		print_cfs_rq(m, cpu, cfs_rq);
-
-	seq_printf(m, "\nWeight tree:\n");
-	print_cfs_rq_tasks(m, &cpu_rq(cpu)->cfs, 1);
 	rcu_read_unlock();
 }
 #endif
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 2bcafa3..3a4f92d 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -99,7 +99,7 @@ static void prio_changed_idle(struct rq *rq, struct task_struct *p,
 /*
  * Simple, special scheduling class for the per-CPU idle tasks:
  */
-const struct sched_class idle_sched_class = {
+static const struct sched_class idle_sched_class = {
 	/* .next is NULL */
 	/* no enqueue/yield_task for idle tasks */
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index c2730a5..060e87b 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1098,11 +1098,14 @@ static void post_schedule_rt(struct rq *rq)
 	}
 }
 
-
+/*
+ * If we are not running and we are not going to reschedule soon, we should
+ * try to push tasks away now
+ */
 static void task_wake_up_rt(struct rq *rq, struct task_struct *p)
 {
 	if (!task_running(rq, p) &&
-	    (p->prio >= rq->rt.highest_prio) &&
+	    !test_tsk_need_resched(rq->curr) &&
 	    rq->rt.overloaded)
 		push_rt_tasks(rq);
 }
@@ -1309,7 +1312,7 @@ static void set_curr_task_rt(struct rq *rq)
 	p->se.exec_start = rq->clock;
 }
 
-const struct sched_class rt_sched_class = {
+static const struct sched_class rt_sched_class = {
 	.next			= &fair_sched_class,
 	.enqueue_task		= enqueue_task_rt,
 	.dequeue_task		= dequeue_task_rt,
