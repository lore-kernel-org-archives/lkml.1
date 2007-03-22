Return-Path: <linux-kernel-owner+w=401wt.eu-S1030383AbXCVKKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030383AbXCVKKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 06:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030396AbXCVKKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 06:10:32 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:25008 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030391AbXCVKKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 06:10:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:Subject:Content-Type;
  b=LRbhLxQ4duwejNNMebDAvvISA/ztTe3dGd8/iE8dq3qKxwbtpP+LzmVho1dGrRNe2KLyvy4Fo/Zfy90X0Z1Wp+bYUUj1Y9FD4i0MZfKX6z6OVxF7yKcyKXC+9J3CIIRvS1wb/TA98i/X0ipl2FWKacgAW7R4A0u2MRWdems7wlM=  ;
X-YMail-OSG: XFTV_J8VM1kzq8.woflei4vnVkFsY3Qr6KBqQD0VnXlUU9QFYDQYvtoN92zNTyrAPX.9wm3pX8SxeXVtD5TzAhUMy7gEHhEesx8kqGHPZWaYMKWs9v_f2iThgexETbIcqN546Q86SwFt35g-
Message-ID: <460255FE.3080602@yahoo.com.au>
Date: Thu, 22 Mar 2007 21:10:06 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [patch] 2.6.21-rc4 nicksched v32
Content-Type: multipart/mixed;
 boundary="------------010403070800080307020307"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010403070800080307020307
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Considering the recent attention on CPU schedulers, so here is an updated
version of my scheduler against 2.6.21-rc4. I often run it on my own
desktop here here and it works well for me, no guarantees! I would be
happy if anyone was interested in testing it :)

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.

--------------010403070800080307020307
Content-Type: text/plain;
 name="nicksched.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nicksched.patch"

Forward port of nicksched to 2.6.21-rc4. Can't find my old design/description
document for it, but it is yet another scheduler. Focus is on simplicity and
fairness.

This one tends to require X to be reniced to -10 or so for best results
(renice -10 `pidof X`).

Timeslices get scaled by /proc/sys/kernel/base_timeslice. If you have bad
interactivity you could try lowering this and see if it helps.

 fs/proc/array.c           |   12
 include/linux/init_task.h |    7
 include/linux/sched.h     |   34 -
 include/linux/sysctl.h    |    1
 kernel/sched.c            | 1122 +++++++++++++++++-----------------------------
 kernel/sysctl.c           |   16
 mm/oom_kill.c             |    7
 7 files changed, 476 insertions(+), 723 deletions(-)

Index: linux-2.6/fs/proc/array.c
===================================================================
--- linux-2.6.orig/fs/proc/array.c	2007-03-22 20:44:00.000000000 +1100
+++ linux-2.6/fs/proc/array.c	2007-03-22 20:44:20.000000000 +1100
@@ -165,7 +165,13 @@ static inline char * task_state(struct t
 	rcu_read_lock();
 	buffer += sprintf(buffer,
 		"State:\t%s\n"
-		"SleepAVG:\t%lu%%\n"
+		"timeslice:\t%d\n"
+		"usedslice:\t%d\n"
+		"arrayseq:\t%lu\n"
+		"staticprio:\t%u\n"
+		"prio:\t%u\n"
+		"sleep_time:\t%lu\n"
+		"total_time:\t%lu\n"
 		"Tgid:\t%d\n"
 		"Pid:\t%d\n"
 		"PPid:\t%d\n"
@@ -173,7 +179,9 @@ static inline char * task_state(struct t
 		"Uid:\t%d\t%d\t%d\t%d\n"
 		"Gid:\t%d\t%d\t%d\t%d\n",
 		get_task_state(p),
-		(p->sleep_avg/1024)*100/(1020000000/1024),
+		get_task_timeslice(p), p->used_slice, p->array_sequence,
+		p->static_prio, p->prio,
+		p->sleep_time, p->total_time,
 	       	p->tgid, p->pid,
 	       	pid_alive(p) ? rcu_dereference(p->real_parent)->tgid : 0,
 		pid_alive(p) && p->ptrace ? rcu_dereference(p->parent)->pid : 0,
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h	2007-03-22 20:44:00.000000000 +1100
+++ linux-2.6/include/linux/sched.h	2007-03-22 20:45:18.000000000 +1100
@@ -523,7 +523,7 @@ struct signal_struct {
 #define MAX_USER_RT_PRIO	100
 #define MAX_RT_PRIO		MAX_USER_RT_PRIO
 
-#define MAX_PRIO		(MAX_RT_PRIO + 40)
+#define MAX_PRIO		(MAX_RT_PRIO + 59)
 
 #define rt_prio(prio)		unlikely((prio) < MAX_RT_PRIO)
 #define rt_task(p)		rt_prio((p)->prio)
@@ -788,24 +788,16 @@ struct mempolicy;
 struct pipe_inode_info;
 struct uts_namespace;
 
-enum sleep_type {
-	SLEEP_NORMAL,
-	SLEEP_NONINTERACTIVE,
-	SLEEP_INTERACTIVE,
-	SLEEP_INTERRUPTED,
-};
-
 struct prio_array;
 
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	struct thread_info *thread_info;
 	atomic_t usage;
+	int lock_depth;		/* BKL lock depth */
 	unsigned long flags;	/* per process flags, defined below */
 	unsigned long ptrace;
 
-	int lock_depth;		/* BKL lock depth */
-
 #ifdef CONFIG_SMP
 #ifdef __ARCH_WANT_UNLOCKED_CTXSW
 	int oncpu;
@@ -813,27 +805,29 @@ struct task_struct {
 #endif
 	int load_weight;	/* for niceness load balancing purposes */
 	int prio, static_prio, normal_prio;
+	int used_slice, over_slice;
 	struct list_head run_list;
 	struct prio_array *array;
+	unsigned long array_sequence;
 
-	unsigned short ioprio;
-#ifdef CONFIG_BLK_DEV_IO_TRACE
-	unsigned int btrace_seq;
-#endif
-	unsigned long sleep_avg;
 	unsigned long long timestamp, last_ran;
 	unsigned long long sched_time; /* sched_clock time spent running */
-	enum sleep_type sleep_type;
+	unsigned long total_time, sleep_time;
+
+	struct list_head tasks;
+	struct mm_struct *mm, *active_mm;
 
 	unsigned long policy;
 	cpumask_t cpus_allowed;
-	unsigned int time_slice, first_time_slice;
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
 #endif
 
-	struct list_head tasks;
+	unsigned short ioprio;
+#ifdef CONFIG_BLK_DEV_IO_TRACE
+	unsigned int btrace_seq;
+#endif
 	/*
 	 * ptrace_list/ptrace_children forms the list of my children
 	 * that were stolen by a ptracer.
@@ -841,8 +835,6 @@ struct task_struct {
 	struct list_head ptrace_children;
 	struct list_head ptrace_list;
 
-	struct mm_struct *mm, *active_mm;
-
 /* task state */
 	struct linux_binfmt *binfmt;
 	long exit_state;
@@ -1199,6 +1191,8 @@ extern unsigned long long sched_clock(vo
 extern unsigned long long
 current_sched_time(const struct task_struct *current_task);
 
+extern int get_task_timeslice(struct task_struct *t);
+
 /* sched_exec is called by processes performing an exec */
 #ifdef CONFIG_SMP
 extern void sched_exec(void);
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c	2007-03-22 20:44:00.000000000 +1100
+++ linux-2.6/kernel/sched.c	2007-03-22 20:48:52.000000000 +1100
@@ -71,129 +71,68 @@ unsigned long long __attribute__((weak))
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
  * and back.
  */
-#define NICE_TO_PRIO(nice)	(MAX_RT_PRIO + (nice) + 20)
-#define PRIO_TO_NICE(prio)	((prio) - MAX_RT_PRIO - 20)
 #define TASK_NICE(p)		PRIO_TO_NICE((p)->static_prio)
+#define NICE_TO_PRIO(nice)    (MAX_RT_PRIO + (nice) + 30)
+#define PRIO_TO_NICE(prio)    ((prio) - MAX_RT_PRIO - 30)
 
 /*
  * 'User priority' is the nice value converted to something we
  * can work with better when scaling various scheduler parameters,
- * it's a [ 0 ... 39 ] range.
+ * it's a [ 0 ... 58 ] range.
  */
 #define USER_PRIO(p)		((p)-MAX_RT_PRIO)
-#define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
 #define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
 
+#define US_TO_JIFFIES(x)      ((x) * HZ / 1000000)
+#define JIFFIES_TO_US(x)      ((x) * 1000000 / HZ)
+
 /*
- * Some helpers for converting nanosecond timing to jiffy resolution
+ * MIN_TIMESLICE is the timeslice that a minimum priority process gets if there
+ * is a maximum priority process runnable. MAX_TIMESLICE is derived from the
+ * formula in task_timeslice. It cannot be changed here. It is the timesilce
+ * that the maximum priority process will get. Larger timeslices are attainable
+ * by low priority processes however.
  */
-#define NS_TO_JIFFIES(TIME)	((TIME) / (1000000000 / HZ))
-#define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
+int sched_base_timeslice = 300;
+int sched_min_base = 10;
+int sched_max_base = 10000;
+
+#define MIN_TIMESLICE		1
+#define RT_TIMESLICE		(50 * 1000 / HZ)                /* 50ms */
+#define BASE_TIMESLICE		(sched_base_timeslice)
+
+/* Maximum amount of history that will be used to calculate priority */
+#define MAX_SLEEP_SHIFT		18
+#define MAX_SLEEP		(1UL << MAX_SLEEP_SHIFT)        /* ~0.25s */
 
 /*
- * These are the 'tuning knobs' of the scheduler:
+ * Maximum effect that 1 block of activity (run/sleep/etc) can have. This is
+ * will moderate dicard freak events (eg. SIGSTOP)
  *
- * Minimum timeslice is 5 msecs (or 1 jiffy, whichever is larger),
- * default timeslice is 100 msecs, maximum timeslice is 800 msecs.
- * Timeslices get refilled after they expire.
  */
-#define MIN_TIMESLICE		max(5 * HZ / 1000, 1)
-#define DEF_TIMESLICE		(100 * HZ / 1000)
-#define ON_RUNQUEUE_WEIGHT	 30
-#define CHILD_PENALTY		 95
-#define PARENT_PENALTY		100
-#define EXIT_WEIGHT		  3
-#define PRIO_BONUS_RATIO	 25
-#define MAX_BONUS		(MAX_USER_PRIO * PRIO_BONUS_RATIO / 100)
-#define INTERACTIVE_DELTA	  2
-#define MAX_SLEEP_AVG		(DEF_TIMESLICE * MAX_BONUS)
-#define STARVATION_LIMIT	(MAX_SLEEP_AVG)
-#define NS_MAX_SLEEP_AVG	(JIFFIES_TO_NS(MAX_SLEEP_AVG))
+#define MAX_SLEEP_AFFECT	(MAX_SLEEP/4)
 
 /*
- * If a task is 'interactive' then we reinsert it in the active
- * array after it has expired its current timeslice. (it will not
- * continue to run immediately, it will still roundrobin with
- * other interactive tasks.)
- *
- * This part scales the interactivity limit depending on niceness.
- *
- * We scale it linearly, offset by the INTERACTIVE_DELTA delta.
- * Here are a few examples of different nice levels:
- *
- *  TASK_INTERACTIVE(-20): [1,1,1,1,1,1,1,1,1,0,0]
- *  TASK_INTERACTIVE(-10): [1,1,1,1,1,1,1,0,0,0,0]
- *  TASK_INTERACTIVE(  0): [1,1,1,1,0,0,0,0,0,0,0]
- *  TASK_INTERACTIVE( 10): [1,1,0,0,0,0,0,0,0,0,0]
- *  TASK_INTERACTIVE( 19): [0,0,0,0,0,0,0,0,0,0,0]
- *
- * (the X axis represents the possible -5 ... 0 ... +5 dynamic
- *  priority range a task can explore, a value of '1' means the
- *  task is rated interactive.)
- *
- * Ie. nice +19 tasks can never get 'interactive' enough to be
- * reinserted into the active array. And only heavily CPU-hog nice -20
- * tasks will be expired. Default nice 0 tasks are somewhere between,
- * it takes some effort for them to get interactive, but it's not
- * too hard.
+ * The amount of history can be decreased (on fork for example). This puts a
+ * lower bound on it.
  */
+#define MIN_HISTORY		(MAX_SLEEP/8)
+#define FORKED_TS_MAX		(US_TO_JIFFIES(10000) ?: 1)
 
-#define CURRENT_BONUS(p) \
-	(NS_TO_JIFFIES((p)->sleep_avg) * MAX_BONUS / \
-		MAX_SLEEP_AVG)
-
-#define GRANULARITY	(10 * HZ / 1000 ? : 1)
-
-#ifdef CONFIG_SMP
-#define TIMESLICE_GRANULARITY(p)	(GRANULARITY * \
-		(1 << (((MAX_BONUS - CURRENT_BONUS(p)) ? : 1) - 1)) * \
-			num_online_cpus())
-#else
-#define TIMESLICE_GRANULARITY(p)	(GRANULARITY * \
-		(1 << (((MAX_BONUS - CURRENT_BONUS(p)) ? : 1) - 1)))
-#endif
-
-#define SCALE(v1,v1_max,v2_max) \
-	(v1) * (v2_max) / (v1_max)
-
-#define DELTA(p) \
-	(SCALE(TASK_NICE(p) + 20, 40, MAX_BONUS) - 20 * MAX_BONUS / 40 + \
-		INTERACTIVE_DELTA)
-
-#define TASK_INTERACTIVE(p) \
-	((p)->prio <= (p)->static_prio - DELTA(p))
-
-#define INTERACTIVE_SLEEP(p) \
-	(JIFFIES_TO_NS(MAX_SLEEP_AVG * \
-		(MAX_BONUS / 2 + DELTA((p)) + 1) / MAX_BONUS - 1))
-
-#define TASK_PREEMPTS_CURR(p, rq) \
-	((p)->prio < (rq)->curr->prio)
-
-#define SCALE_PRIO(x, prio) \
-	max(x * (MAX_PRIO - prio) / (MAX_USER_PRIO / 2), MIN_TIMESLICE)
-
-static unsigned int static_prio_timeslice(int static_prio)
-{
-	if (static_prio < NICE_TO_PRIO(0))
-		return SCALE_PRIO(DEF_TIMESLICE * 4, static_prio);
-	else
-		return SCALE_PRIO(DEF_TIMESLICE, static_prio);
-}
+/*
+ * SLEEP_FACTOR is a fixed point factor used to scale history tracking things.
+ * In particular: total_time, sleep_time, sleep_avg.
+ */
+#define SLEEP_FACTOR		1024
 
 /*
- * task_timeslice() scales user-nice values [ -20 ... 0 ... 19 ]
- * to time slice values: [800ms ... 100ms ... 5ms]
- *
- * The higher a thread's priority, the bigger timeslices
- * it gets during one round of execution. But even the lowest
- * priority thread gets MIN_TIMESLICE worth of execution time.
+ * The scheduler classifies a process as performing one of the following
+ * activities
  */
+#define STIME_SLEEP           1       /* Sleeping */
+#define STIME_RUN             2       /* Using CPU */
 
-static inline unsigned int task_timeslice(struct task_struct *p)
-{
-	return static_prio_timeslice(p->static_prio);
-}
+#define TASK_PREEMPTS_CURR(p, rq)     ((p)->prio < (rq)->curr->prio)
 
 /*
  * These are the runqueue data structures:
@@ -224,6 +163,7 @@ struct rq {
 #ifdef CONFIG_SMP
 	unsigned long cpu_load[3];
 #endif
+	unsigned long array_sequence;
 	unsigned long long nr_switches;
 
 	/*
@@ -234,15 +174,13 @@ struct rq {
 	 */
 	unsigned long nr_uninterruptible;
 
-	unsigned long expired_timestamp;
-	/* Cached timestamp set by update_cpu_clock() */
-	unsigned long long most_recent_timestamp;
 	struct task_struct *curr, *idle;
 	unsigned long next_balance;
 	struct mm_struct *prev_mm;
-	struct prio_array *active, *expired, arrays[2];
-	int best_expired_prio;
 	atomic_t nr_iowait;
+	int min_expired_prio;
+	struct prio_array *active, *expired, arrays[2];
+//	struct list_head quotient_queue[10];
 
 #ifdef CONFIG_SMP
 	struct sched_domain *sd;
@@ -261,9 +199,6 @@ struct rq {
 	struct sched_info rq_sched_info;
 
 	/* sys_sched_yield() stats */
-	unsigned long yld_exp_empty;
-	unsigned long yld_act_empty;
-	unsigned long yld_both_empty;
 	unsigned long yld_cnt;
 
 	/* schedule() stats */
@@ -411,9 +346,8 @@ static struct rq *task_rq_lock(struct ta
 	struct rq *rq;
 
 repeat_lock_task:
-	local_irq_save(*flags);
 	rq = task_rq(p);
-	spin_lock(&rq->lock);
+	spin_lock_irqsave(&rq->lock, *flags);
 	if (unlikely(rq != task_rq(p))) {
 		spin_unlock_irqrestore(&rq->lock, *flags);
 		goto repeat_lock_task;
@@ -456,8 +390,8 @@ static int show_schedstat(struct seq_fil
 		/* runqueue-specific stats */
 		seq_printf(seq,
 		    "cpu%d %lu %lu %lu %lu %lu %lu %lu %lu %lu %lu %lu %lu",
-		    cpu, rq->yld_both_empty,
-		    rq->yld_act_empty, rq->yld_exp_empty, rq->yld_cnt,
+		    cpu,
+		    0UL, 0UL, 0UL, rq->yld_cnt,
 		    rq->sched_switch, rq->sched_cnt, rq->sched_goidle,
 		    rq->ttwu_cnt, rq->ttwu_local,
 		    rq->rq_sched_info.cpu_time,
@@ -561,21 +495,6 @@ rq_sched_info_depart(struct rq *rq, unsi
 # define schedstat_add(rq, field, amt)	do { } while (0)
 #endif
 
-/*
- * this_rq_lock - lock this runqueue and disable interrupts.
- */
-static inline struct rq *this_rq_lock(void)
-	__acquires(rq->lock)
-{
-	struct rq *rq;
-
-	local_irq_disable();
-	rq = this_rq();
-	spin_lock(&rq->lock);
-
-	return rq;
-}
-
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 /*
  * Called when a process is dequeued from the active array and given
@@ -682,6 +601,12 @@ sched_info_switch(struct task_struct *pr
 #define sched_info_switch(t, next)	do { } while (0)
 #endif /* CONFIG_SCHEDSTATS || CONFIG_TASK_DELAY_ACCT */
 
+static inline void update_min_expired_prio(struct task_struct *p, struct rq *rq)
+{
+	if (!rt_task(p) && p->static_prio < rq->min_expired_prio)
+		rq->min_expired_prio = p->static_prio;
+}
+
 /*
  * Adding/removing a task to/from a priority array:
  */
@@ -695,22 +620,15 @@ static void dequeue_task(struct task_str
 
 static void enqueue_task(struct task_struct *p, struct prio_array *array)
 {
+	struct list_head *entry = array->queue + p->prio;
+
 	sched_info_queued(p);
-	list_add_tail(&p->run_list, array->queue + p->prio);
+	list_add_tail(&p->run_list, entry);
 	__set_bit(p->prio, array->bitmap);
 	array->nr_active++;
 	p->array = array;
 }
 
-/*
- * Put task to the end of the run list without the overhead of dequeue
- * followed by enqueue.
- */
-static void requeue_task(struct task_struct *p, struct prio_array *array)
-{
-	list_move_tail(&p->run_list, array->queue + p->prio);
-}
-
 static inline void
 enqueue_task_head(struct task_struct *p, struct prio_array *array)
 {
@@ -721,35 +639,6 @@ enqueue_task_head(struct task_struct *p,
 }
 
 /*
- * __normal_prio - return the priority that is based on the static
- * priority but is modified by bonuses/penalties.
- *
- * We scale the actual sleep average [0 .... MAX_SLEEP_AVG]
- * into the -5 ... 0 ... +5 bonus/penalty range.
- *
- * We use 25% of the full 0...39 priority range so that:
- *
- * 1) nice +19 interactive tasks do not preempt nice 0 CPU hogs.
- * 2) nice -20 CPU hogs do not get preempted by nice 0 tasks.
- *
- * Both properties are important to certain workloads.
- */
-
-static inline int __normal_prio(struct task_struct *p)
-{
-	int bonus, prio;
-
-	bonus = CURRENT_BONUS(p) - MAX_BONUS / 2;
-
-	prio = p->static_prio - bonus;
-	if (prio < MAX_RT_PRIO)
-		prio = MAX_RT_PRIO;
-	if (prio > MAX_PRIO-1)
-		prio = MAX_PRIO-1;
-	return prio;
-}
-
-/*
  * To aid in avoiding the subversion of "niceness" due to uneven distribution
  * of tasks with abnormal "nice" values across CPUs the contribution that
  * each task makes to its run queue's load is weighted according to its
@@ -758,12 +647,17 @@ static inline int __normal_prio(struct t
  * slice expiry etc.
  */
 
+static int static_prio_timeslice(unsigned int prio)
+{
+	return BASE_TIMESLICE; /* XXX: fixme for smpnice */
+}
+
 /*
- * Assume: static_prio_timeslice(NICE_TO_PRIO(0)) == DEF_TIMESLICE
+ * Assume: static_prio_timeslice(NICE_TO_PRIO(0)) == BASE_TIMESLICE
  * If static_prio_timeslice() is ever changed to break this assumption then
  * this code will need modification
  */
-#define TIME_SLICE_NICE_ZERO DEF_TIMESLICE
+#define TIME_SLICE_NICE_ZERO BASE_TIMESLICE
 #define LOAD_WEIGHT(lp) \
 	(((lp) * SCHED_LOAD_SCALE) / TIME_SLICE_NICE_ZERO)
 #define PRIO_TO_LOAD_WEIGHT(prio) \
@@ -813,134 +707,153 @@ static inline void dec_nr_running(struct
 	dec_raw_weighted_load(rq, p);
 }
 
+
+static inline long long sched_clock_us(void)
+{
+	return ((unsigned long long)jiffies) << (20 - SHIFT_HZ);
+}
+
 /*
- * Calculate the expected normal priority: i.e. priority
- * without taking RT-inheritance into account. Might be
- * boosted by interactivity modifiers. Changes upon fork,
- * setprio syscalls, and whenever the interactivity
- * estimator recalculates.
+ * add_task_time updates a task p after time of doing the specified @type
+ * of activity. See STIME_*. This is used for priority calculation.
  */
-static inline int normal_prio(struct task_struct *p)
+static void add_task_time(struct task_struct *p,
+				unsigned long long time, unsigned long type)
 {
-	int prio;
+	unsigned long ratio;
+	unsigned long long tmp;
+	unsigned long t;
 
-	if (has_rt_policy(p))
-		prio = MAX_RT_PRIO-1 - p->rt_priority;
-	else
-		prio = __normal_prio(p);
-	return prio;
+	if (!time)
+		return;
+
+	t = time;
+	if (type == STIME_SLEEP) {
+		unsigned long fac;
+		fac = USER_PRIO(p->static_prio); /* 0..39 */
+		fac = fac + 12; /* 12..41 */
+		if (time > MAX_SLEEP_AFFECT*8)
+			t = MAX_SLEEP_AFFECT*8;
+		t = (t * fac) / 32;
+		t = (t + 7) / 8;
+	} else {
+		if (time > MAX_SLEEP)
+			t = MAX_SLEEP;
+	}
+
+	ratio = MAX_SLEEP - t;
+	tmp = (unsigned long long)ratio*p->total_time + MAX_SLEEP/2;
+	tmp >>= MAX_SLEEP_SHIFT;
+	p->total_time = (unsigned long)tmp;
+
+	tmp = (unsigned long long)ratio*p->sleep_time + MAX_SLEEP/2;
+	tmp >>= MAX_SLEEP_SHIFT;
+	p->sleep_time = (unsigned long)tmp;
+
+	p->total_time += t;
+	if (type == STIME_SLEEP)
+		p->sleep_time += t;
 }
 
-/*
- * Calculate the current priority, i.e. the priority
- * taken into account by the scheduler. This value might
- * be boosted by RT tasks, or might be boosted by
- * interactivity modifiers. Will be RT if the task got
- * RT-boosted. If not then it returns p->normal_prio.
- */
-static int effective_prio(struct task_struct *p)
-{
-	p->normal_prio = normal_prio(p);
-	/*
-	 * If we are RT tasks or we were boosted to RT priority,
-	 * keep the priority unchanged. Otherwise, update priority
-	 * to the normal priority:
-	 */
-	if (!rt_prio(p->prio))
-		return p->normal_prio;
-	return p->prio;
+static inline unsigned long task_sleep_avg(struct task_struct *p)
+{
+	return (SLEEP_FACTOR * p->sleep_time) / (p->total_time + 1);
 }
 
 /*
- * __activate_task - move a task to the runqueue.
+ * The higher a thread's priority, the bigger timeslices
+ * it gets during one round of execution. But even the lowest
+ * priority thread gets MIN_TIMESLICE worth of execution time.
+ *
+ * Timeslices are scaled, so if only low priority processes are running,
+ * they will all get long timeslices.
  */
-static void __activate_task(struct task_struct *p, struct rq *rq)
+static int task_timeslice(struct task_struct *p, struct rq *rq)
 {
-	struct prio_array *target = rq->active;
+	unsigned int prio, delta, scale, ts;
 
-	if (batch_task(p))
-		target = rq->expired;
-	enqueue_task(p, target);
-	inc_nr_running(p, rq);
+	if (rt_task(p))
+		return RT_TIMESLICE;
+
+	/* prio is 10..49 */
+	prio = USER_PRIO(p->static_prio) - 10 + 9;
+
+	ts = prio * 1024;	/* 10240..50176 */
+
+	/* delta is 3..42 (delta-3 <= prio-9) */
+	delta = p->static_prio - min(rq->min_expired_prio, p->static_prio) + 3;
+
+	scale = delta*delta;	/* 9..1764 */
+
+	ts = ts / scale;	/* 1137..(28..5575) */
+
+	/* a nice 0 task has ts (29*29/9) here. scale to BASE_TIMESLICE */
+	ts = ts * BASE_TIMESLICE / (29*1024/9);
+
+	ts = msecs_to_jiffies(ts);
+	if (unlikely(ts == 0))
+		ts = 1;
+
+	return ts;
 }
 
-/*
- * __activate_idle_task - move idle task to the _front_ of runqueue.
- */
-static inline void __activate_idle_task(struct task_struct *p, struct rq *rq)
+int get_task_timeslice(struct task_struct *p)
 {
-	enqueue_task_head(p, rq->active);
-	inc_nr_running(p, rq);
+	int ts;
+	struct rq *rq;
+	unsigned long flags;
+	rq = task_rq_lock(p, &flags);
+	ts = task_timeslice(p, rq);
+	task_rq_unlock(rq, &flags);
+
+	return ts;
 }
 
 /*
- * Recalculate p->normal_prio and p->prio after having slept,
- * updating the sleep-average too:
+ * task_priority: calculates a task's priority based on previous running
+ * history (see add_task_time). The priority is just a simple linear function
+ * based on sleep_avg and static_prio.
  */
-static int recalc_task_prio(struct task_struct *p, unsigned long long now)
+static int task_priority(struct task_struct *p)
 {
-	/* Caller must always ensure 'now >= p->timestamp' */
-	unsigned long sleep_time = now - p->timestamp;
+	unsigned long sleep_avg;
+	int bonus, prio;
 
-	if (batch_task(p))
-		sleep_time = 0;
+	if (rt_prio(p->prio))
+		return p->prio;
 
-	if (likely(sleep_time > 0)) {
-		/*
-		 * This ceiling is set to the lowest priority that would allow
-		 * a task to be reinserted into the active array on timeslice
-		 * completion.
-		 */
-		unsigned long ceiling = INTERACTIVE_SLEEP(p);
+	sleep_avg = task_sleep_avg(p);
 
-		if (p->mm && sleep_time > ceiling && p->sleep_avg < ceiling) {
-			/*
-			 * Prevents user tasks from achieving best priority
-			 * with one single large enough sleep.
-			 */
-			p->sleep_avg = ceiling;
-			/*
-			 * Using INTERACTIVE_SLEEP() as a ceiling places a
-			 * nice(0) task 1ms sleep away from promotion, and
-			 * gives it 700ms to round-robin with no chance of
-			 * being demoted.  This is more than generous, so
-			 * mark this sleep as non-interactive to prevent the
-			 * on-runqueue bonus logic from intervening should
-			 * this task not receive cpu immediately.
-			 */
-			p->sleep_type = SLEEP_NONINTERACTIVE;
-		} else {
-			/*
-			 * Tasks waking from uninterruptible sleep are
-			 * limited in their sleep_avg rise as they
-			 * are likely to be waiting on I/O
-			 */
-			if (p->sleep_type == SLEEP_NONINTERACTIVE && p->mm) {
-				if (p->sleep_avg >= ceiling)
-					sleep_time = 0;
-				else if (p->sleep_avg + sleep_time >=
-					 ceiling) {
-						p->sleep_avg = ceiling;
-						sleep_time = 0;
-				}
-			}
+	prio = USER_PRIO(p->static_prio) + 10;
+	bonus = (((MAX_USER_PRIO + 1) / 3) * sleep_avg + (SLEEP_FACTOR / 2))
+					/ SLEEP_FACTOR;
+	prio = MAX_RT_PRIO + prio - bonus;
 
-			/*
-			 * This code gives a bonus to interactive tasks.
-			 *
-			 * The boost works by updating the 'average sleep time'
-			 * value here, based on ->timestamp. The more time a
-			 * task spends sleeping, the higher the average gets -
-			 * and the higher the priority boost gets as well.
-			 */
-			p->sleep_avg += sleep_time;
+	if (prio < MAX_RT_PRIO)
+		return MAX_RT_PRIO;
+	if (prio > MAX_PRIO-1)
+		return MAX_PRIO-1;
 
-		}
-		if (p->sleep_avg > NS_MAX_SLEEP_AVG)
-			p->sleep_avg = NS_MAX_SLEEP_AVG;
-	}
+	return prio;
+}
 
-	return effective_prio(p);
+/*
+ * __activate_task - move a task to the runqueue.
+ */
+static inline void __activate_task(struct task_struct *p, struct rq *rq,
+					struct prio_array *array)
+{
+	enqueue_task(p, array);
+	rq->nr_running++;
+}
+
+/*
+ * __activate_idle_task - move idle task to the _front_ of runqueue.
+ */
+static inline void __activate_idle_task(struct task_struct *p, struct rq *rq)
+{
+	enqueue_task_head(p, rq->active);
+	inc_nr_running(p, rq);
 }
 
 /*
@@ -951,20 +864,14 @@ static int recalc_task_prio(struct task_
  */
 static void activate_task(struct task_struct *p, struct rq *rq, int local)
 {
-	unsigned long long now;
+	unsigned long long now, sleep;
+	struct prio_array *array;
 
+	array = rq->active;
 	if (rt_task(p))
 		goto out;
 
-	now = sched_clock();
-#ifdef CONFIG_SMP
-	if (!local) {
-		/* Compensate for drifting sched_clock */
-		struct rq *this_rq = this_rq();
-		now = (now - this_rq->most_recent_timestamp)
-			+ rq->most_recent_timestamp;
-	}
-#endif
+	now = sched_clock_us();
 
 	/*
 	 * Sleep time is in units of nanosecs, so shift by 20 to get a
@@ -976,41 +883,34 @@ static void activate_task(struct task_st
 			profile_hits(SLEEP_PROFILING, (void *)get_wchan(p),
 				     (now - p->timestamp) >> 20);
 	}
-
-	p->prio = recalc_task_prio(p, now);
-
 	/*
-	 * This checks to make sure it's not an uninterruptible task
-	 * that is now waking up.
+	 * If we have slept through an active/expired array switch, restart
+	 * our timeslice too.
 	 */
-	if (p->sleep_type == SLEEP_NORMAL) {
-		/*
-		 * Tasks which were woken up by interrupts (ie. hw events)
-		 * are most likely of interactive nature. So we give them
-		 * the credit of extending their sleep time to the period
-		 * of time they spend on the runqueue, waiting for execution
-		 * on a CPU, first time around:
-		 */
-		if (in_interrupt())
-			p->sleep_type = SLEEP_INTERRUPTED;
-		else {
-			/*
-			 * Normal first-time wakeups get a credit too for
-			 * on-runqueue time, but it will be weighted down:
-			 */
-			p->sleep_type = SLEEP_INTERACTIVE;
-		}
-	}
+	sleep = now - p->timestamp;
 	p->timestamp = now;
+	add_task_time(p, sleep, STIME_SLEEP);
+	p->prio = task_priority(p);
+
+	if (rq->array_sequence != p->array_sequence) {
+		p->used_slice = 0;
+		p->over_slice = 0;
+	} else if (unlikely(p->used_slice == -1)) {
+		array = rq->expired;
+		p->used_slice = 0;
+		update_min_expired_prio(p, rq);
+	}
+
 out:
-	__activate_task(p, rq);
+	__activate_task(p, rq, array);
 }
 
 /*
  * deactivate_task - remove a task from the runqueue.
  */
-static void deactivate_task(struct task_struct *p, struct rq *rq)
+static inline void deactivate_task(struct task_struct *p, struct rq *rq)
 {
+	p->array_sequence = rq->array_sequence;
 	dec_nr_running(p, rq);
 	dequeue_task(p, p->array);
 	p->array = NULL;
@@ -1508,10 +1408,12 @@ static int try_to_wake_up(struct task_st
 out_set_cpu:
 	new_cpu = wake_idle(new_cpu, p);
 	if (new_cpu != cpu) {
+		int seq_delta = p->array_sequence - rq->array_sequence;
 		set_task_cpu(p, new_cpu);
 		task_rq_unlock(rq, &flags);
 		/* might preempt at this point */
 		rq = task_rq_lock(p, &flags);
+		p->array_sequence = rq->array_sequence + seq_delta;
 		old_state = p->state;
 		if (!(old_state & state))
 			goto out;
@@ -1524,33 +1426,9 @@ out_set_cpu:
 
 out_activate:
 #endif /* CONFIG_SMP */
-	if (old_state == TASK_UNINTERRUPTIBLE) {
+	if (old_state == TASK_UNINTERRUPTIBLE)
 		rq->nr_uninterruptible--;
-		/*
-		 * Tasks on involuntary sleep don't earn
-		 * sleep_avg beyond just interactive state.
-		 */
-		p->sleep_type = SLEEP_NONINTERACTIVE;
-	} else
-
-	/*
-	 * Tasks that have marked their sleep as noninteractive get
-	 * woken up with their sleep average not weighted in an
-	 * interactive way.
-	 */
-		if (old_state & TASK_NONINTERACTIVE)
-			p->sleep_type = SLEEP_NONINTERACTIVE;
-
-
 	activate_task(p, rq, cpu == this_cpu);
-	/*
-	 * Sync wakeups (i.e. those types of wakeups where the waker
-	 * has indicated that it will leave the CPU in short order)
-	 * don't trigger a preemption, if the woken up task will run on
-	 * this cpu. (in this case the 'I will reschedule' promise of
-	 * the waker guarantees that the freshly woken up task is going
-	 * to be considered on this CPU.)
-	 */
 	if (!sync || cpu != this_cpu) {
 		if (TASK_PREEMPTS_CURR(p, rq))
 			resched_task(rq->curr);
@@ -1584,6 +1462,9 @@ static void task_running_tick(struct rq 
  */
 void fastcall sched_fork(struct task_struct *p, int clone_flags)
 {
+	unsigned long sleep_avg;
+	struct rq *rq;
+	struct task_struct *cur;
 	int cpu = get_cpu();
 
 #ifdef CONFIG_SMP
@@ -1617,31 +1498,47 @@ void fastcall sched_fork(struct task_str
 	/* Want to start with kernel preemption disabled. */
 	task_thread_info(p)->preempt_count = 1;
 #endif
-	/*
-	 * Share the timeslice between parent and child, thus the
-	 * total amount of pending timeslices in the system doesn't change,
-	 * resulting in more scheduling fairness.
-	 */
+	p->timestamp = sched_clock_us();
+	p->used_slice = 0;
+	p->over_slice = 0;
+	if (rt_task(p))
+		goto out;
+
+	rq = this_rq();
+	cur = current;
+
+	/* Get MIN_HISTORY of history with a bit less sleep_avg than parent. */
+	sleep_avg = task_sleep_avg(cur);
+	sleep_avg -= sleep_avg >> 2;
+	p->total_time = MIN_HISTORY;
+	p->sleep_time = MIN_HISTORY * sleep_avg / SLEEP_FACTOR;
+
+	p->prio = p->normal_prio = task_priority(p);
+
+	/* Parent loses sleep time the child took */
+	cur->sleep_time -= min(cur->sleep_time/4, p->sleep_time);
+
 	local_irq_disable();
-	p->time_slice = (current->time_slice + 1) >> 1;
-	/*
-	 * The remainder of the first timeslice might be recovered by
-	 * the parent if the child exits early enough.
-	 */
-	p->first_time_slice = 1;
-	current->time_slice >>= 1;
-	p->timestamp = sched_clock();
-	if (unlikely(!current->time_slice)) {
-		/*
-		 * This case is rare, it happens when the parent has only
-		 * a single jiffy left from its timeslice. Taking the
-		 * runqueue lock is not a problem.
-		 */
-		current->time_slice = 1;
-		task_running_tick(cpu_rq(cpu), current);
+	if (unlikely(cur->used_slice == -1 || cur == rq->idle))
+		p->used_slice = -1;
+	else {
+		int ts = task_timeslice(p, rq);
+		int child_ts = min_t(int, ts/4, FORKED_TS_MAX);
+
+		if (child_ts == 0) {
+			p->used_slice = -1;
+		} else {
+			p->used_slice = ts - child_ts;
+			cur->used_slice += child_ts;
+			if (cur->used_slice >= task_timeslice(p, rq)) {
+				cur->used_slice = -1;
+				set_need_resched();
+			}
+		}
 	}
 	local_irq_enable();
-	put_cpu();
+out:
+  	put_cpu();
 }
 
 /*
@@ -1653,108 +1550,55 @@ void fastcall sched_fork(struct task_str
  */
 void fastcall wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 {
-	struct rq *rq, *this_rq;
 	unsigned long flags;
 	int this_cpu, cpu;
+	struct rq *rq;
+	struct prio_array *array;
+	struct task_struct *cur;
+
+	cpu = task_cpu(p);
 
 	rq = task_rq_lock(p, &flags);
 	BUG_ON(p->state != TASK_RUNNING);
 	this_cpu = smp_processor_id();
-	cpu = task_cpu(p);
-
-	/*
-	 * We decrease the sleep average of forking parents
-	 * and children as well, to keep max-interactive tasks
-	 * from forking tasks that are max-interactive. The parent
-	 * (current) is done further down, under its lock.
-	 */
-	p->sleep_avg = JIFFIES_TO_NS(CURRENT_BONUS(p) *
-		CHILD_PENALTY / 100 * MAX_SLEEP_AVG / MAX_BONUS);
 
-	p->prio = effective_prio(p);
+	array = rq->active;
+	if (unlikely(p->used_slice == -1)) {
+		array = rq->expired;
+		p->used_slice = 0;
+		update_min_expired_prio(p, rq);
+	}
 
+	cur = current;
 	if (likely(cpu == this_cpu)) {
-		if (!(clone_flags & CLONE_VM)) {
+		if (!rt_task(p) && !rt_task(cur) &&
+			!(clone_flags & CLONE_VM) && (array == rq->active)) {
 			/*
 			 * The VM isn't cloned, so we're in a good position to
 			 * do child-runs-first in anticipation of an exec. This
 			 * usually avoids a lot of COW overhead.
 			 */
-			if (unlikely(!current->array))
-				__activate_task(p, rq);
-			else {
-				p->prio = current->prio;
-				p->normal_prio = current->normal_prio;
-				list_add_tail(&p->run_list, &current->run_list);
-				p->array = current->array;
-				p->array->nr_active++;
-				inc_nr_running(p, rq);
-			}
 			set_need_resched();
-		} else
-			/* Run child last */
-			__activate_task(p, rq);
-		/*
-		 * We skip the following code due to cpu == this_cpu
-	 	 *
-		 *   task_rq_unlock(rq, &flags);
-		 *   this_rq = task_rq_lock(current, &flags);
-		 */
-		this_rq = rq;
-	} else {
-		this_rq = cpu_rq(this_cpu);
+			p->prio = cur->prio;
+			list_add_tail(&p->run_list, &cur->run_list);
+			p->array = cur->array;
+			p->array->nr_active++;
+			rq->nr_running++;
+			goto child_queued;
+		}
+	}
+	__activate_task(p, rq, array);
 
-		/*
-		 * Not the local CPU - must adjust timestamp. This should
-		 * get optimised away in the !CONFIG_SMP case.
-		 */
-		p->timestamp = (p->timestamp - this_rq->most_recent_timestamp)
-					+ rq->most_recent_timestamp;
-		__activate_task(p, rq);
-		if (TASK_PREEMPTS_CURR(p, rq))
-			resched_task(rq->curr);
+	/* This catches RT tasks and remote SMP tasks */
+	if (TASK_PREEMPTS_CURR(p, rq))
+		resched_task(rq->curr);
 
-		/*
-		 * Parent and child are on different CPUs, now get the
-		 * parent runqueue to update the parent's ->sleep_avg:
-		 */
-		task_rq_unlock(rq, &flags);
-		this_rq = task_rq_lock(current, &flags);
-	}
-	current->sleep_avg = JIFFIES_TO_NS(CURRENT_BONUS(current) *
-		PARENT_PENALTY / 100 * MAX_SLEEP_AVG / MAX_BONUS);
-	task_rq_unlock(this_rq, &flags);
+child_queued:
+	task_rq_unlock(rq, &flags);
 }
 
-/*
- * Potentially available exiting-child timeslices are
- * retrieved here - this way the parent does not get
- * penalized for creating too many threads.
- *
- * (this cannot be used to 'generate' timeslices
- * artificially, because any timeslice recovered here
- * was given away by the parent in the first place.)
- */
 void fastcall sched_exit(struct task_struct *p)
 {
-	unsigned long flags;
-	struct rq *rq;
-
-	/*
-	 * If the child was a (relative-) CPU hog then decrease
-	 * the sleep_avg of the parent as well.
-	 */
-	rq = task_rq_lock(p->parent, &flags);
-	if (p->first_time_slice && task_cpu(p) == task_cpu(p->parent)) {
-		p->parent->time_slice += p->time_slice;
-		if (unlikely(p->parent->time_slice > task_timeslice(p)))
-			p->parent->time_slice = task_timeslice(p);
-	}
-	if (p->sleep_avg < p->parent->sleep_avg)
-		p->parent->sleep_avg = p->parent->sleep_avg /
-		(EXIT_WEIGHT + 1) * EXIT_WEIGHT + p->sleep_avg /
-		(EXIT_WEIGHT + 1);
-	task_rq_unlock(rq, &flags);
 }
 
 /**
@@ -1831,6 +1675,7 @@ static inline void finish_task_switch(st
 asmlinkage void schedule_tail(struct task_struct *prev)
 	__releases(rq->lock)
 {
+	struct task_struct *cur;
 	struct rq *rq = this_rq();
 
 	finish_task_switch(rq, prev);
@@ -1838,8 +1683,9 @@ asmlinkage void schedule_tail(struct tas
 	/* In this case, finish_task_switch does not reenable preemption */
 	preempt_enable();
 #endif
-	if (current->set_child_tid)
-		put_user(current->pid, current->set_child_tid);
+	cur = current;
+	if (cur->set_child_tid)
+		put_user(cur->pid, cur->set_child_tid);
 }
 
 /*
@@ -1979,19 +1825,19 @@ static void double_rq_lock(struct rq *rq
 	__acquires(rq1->lock)
 	__acquires(rq2->lock)
 {
+	spinlock_t *l1, *l2;
+
 	BUG_ON(!irqs_disabled());
-	if (rq1 == rq2) {
-		spin_lock(&rq1->lock);
-		__acquire(rq2->lock);	/* Fake it out ;) */
-	} else {
-		if (rq1 < rq2) {
-			spin_lock(&rq1->lock);
-			spin_lock(&rq2->lock);
-		} else {
-			spin_lock(&rq2->lock);
-			spin_lock(&rq1->lock);
-		}
+
+	l1 = &rq1->lock;
+	l2 = &rq2->lock;
+	if (rq1 > rq2) {
+		l1 = l2;
+		l2 = &rq1->lock;
 	}
+
+	spin_lock(l1);
+	spin_lock(l2);
 }
 
 /*
@@ -2005,10 +1851,7 @@ static void double_rq_unlock(struct rq *
 	__releases(rq2->lock)
 {
 	spin_unlock(&rq1->lock);
-	if (rq1 != rq2)
-		spin_unlock(&rq2->lock);
-	else
-		__release(rq2->lock);
+	spin_unlock(&rq2->lock);
 }
 
 /*
@@ -2045,9 +1888,12 @@ static void sched_migrate_task(struct ta
 	struct migration_req req;
 	unsigned long flags;
 	struct rq *rq;
+	int cpu;
 
 	rq = task_rq_lock(p, &flags);
+	cpu = task_cpu(p);
 	if (!cpu_isset(dest_cpu, p->cpus_allowed)
+	    || cpu == dest_cpu
 	    || unlikely(cpu_is_offline(dest_cpu)))
 		goto out;
 
@@ -2094,8 +1940,10 @@ static void pull_task(struct rq *src_rq,
 	set_task_cpu(p, this_cpu);
 	inc_nr_running(p, this_rq);
 	enqueue_task(p, this_array);
-	p->timestamp = (p->timestamp - src_rq->most_recent_timestamp)
-				+ this_rq->most_recent_timestamp;
+
+	if (this_array == this_rq->expired)
+		update_min_expired_prio(p, this_rq);
+
 	/*
 	 * Note that idle threads have a prio of MAX_PRIO, for this test
 	 * to be always true for them.
@@ -2110,7 +1958,7 @@ static void pull_task(struct rq *src_rq,
 static
 int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 		     struct sched_domain *sd, enum idle_type idle,
-		     int *all_pinned)
+		     int *all_pinned, unsigned long long now)
 {
 	/*
 	 * We do not migrate tasks that are:
@@ -2133,18 +1981,18 @@ int can_migrate_task(struct task_struct 
 
 	if (sd->nr_balance_failed > sd->cache_nice_tries) {
 #ifdef CONFIG_SCHEDSTATS
-		if (task_hot(p, rq->most_recent_timestamp, sd))
+		if (task_hot(p, now, sd))
 			schedstat_inc(sd, lb_hot_gained[idle]);
 #endif
 		return 1;
 	}
 
-	if (task_hot(p, rq->most_recent_timestamp, sd))
+	if (task_hot(p, now, sd))
 		return 0;
 	return 1;
 }
 
-#define rq_best_prio(rq) min((rq)->curr->prio, (rq)->best_expired_prio)
+#define rq_best_prio(rq) min((rq)->curr->prio, (rq)->min_expired_prio)
 
 /*
  * move_tasks tries to move up to max_nr_move tasks and max_load_move weighted
@@ -2164,12 +2012,14 @@ static int move_tasks(struct rq *this_rq
 	struct list_head *head, *curr;
 	struct task_struct *tmp;
 	long rem_load_move;
+	unsigned long long now;
 
 	if (max_nr_move == 0 || max_load_move == 0)
 		goto out;
 
 	rem_load_move = max_load_move;
 	pinned = 1;
+	now = sched_clock_us();
 	this_best_prio = rq_best_prio(this_rq);
 	best_prio = rq_best_prio(busiest);
 	/*
@@ -2228,7 +2078,7 @@ skip_queue:
 	if (skip_for_load && idx < this_best_prio)
 		skip_for_load = !best_prio_seen && idx == best_prio;
 	if (skip_for_load ||
-	    !can_migrate_task(tmp, busiest, this_cpu, sd, idle, &pinned)) {
+	    !can_migrate_task(tmp, busiest, this_cpu, sd, idle, &pinned, now)) {
 
 		best_prio_seen |= idx == best_prio;
 		if (curr != head)
@@ -2289,6 +2139,8 @@ find_busiest_group(struct sched_domain *
 	struct sched_group *group_min = NULL, *group_leader = NULL;
 #endif
 
+	prefetch(group);
+
 	max_load = this_load = total_load = total_pwr = 0;
 	busiest_load_per_task = busiest_nr_running = 0;
 	this_load_per_task = this_nr_running = 0;
@@ -2306,6 +2158,8 @@ find_busiest_group(struct sched_domain *
 		unsigned int balance_cpu = -1, first_idle_cpu = 0;
 		unsigned long sum_nr_running, sum_weighted_load;
 
+		prefetch(group->next);
+
 		local_group = cpu_isset(this_cpu, group->cpumask);
 
 		if (local_group)
@@ -3018,7 +2872,7 @@ static inline void
 update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long long now)
 {
 	p->sched_time += now - p->last_ran;
-	p->last_ran = rq->most_recent_timestamp = now;
+	p->last_ran = now;
 }
 
 /*
@@ -3031,34 +2885,13 @@ unsigned long long current_sched_time(co
 	unsigned long flags;
 
 	local_irq_save(flags);
-	ns = p->sched_time + sched_clock() - p->last_ran;
+	ns = p->sched_time + sched_clock_us() - p->last_ran;
 	local_irq_restore(flags);
 
 	return ns;
 }
 
 /*
- * We place interactive tasks back into the active array, if possible.
- *
- * To guarantee that this does not starve expired tasks we ignore the
- * interactivity of a task if the first expired task had to wait more
- * than a 'reasonable' amount of time. This deadline timeout is
- * load-dependent, as the frequency of array switched decreases with
- * increasing number of running tasks. We also ignore the interactivity
- * if a better static_prio task has expired:
- */
-static inline int expired_starving(struct rq *rq)
-{
-	if (rq->curr->static_prio > rq->best_expired_prio)
-		return 1;
-	if (!STARVATION_LIMIT || !rq->expired_timestamp)
-		return 0;
-	if (jiffies - rq->expired_timestamp > STARVATION_LIMIT * rq->nr_running)
-		return 1;
-	return 0;
-}
-
-/*
  * Account user cpu time to a process.
  * @p: the process that the cpu time gets accounted to
  * @hardirq_offset: the offset to subtract from hardirq_count()
@@ -3133,77 +2966,26 @@ void account_steal_time(struct task_stru
 
 static void task_running_tick(struct rq *rq, struct task_struct *p)
 {
-	if (p->array != rq->active) {
-		/* Task has expired but was not scheduled yet */
-		set_tsk_need_resched(p);
+	int allowed;
+	int ts;
+
+	/* Task might have expired already, but not scheduled off yet */
+	if (unlikely(p->used_slice == -1))
 		return;
-	}
-	spin_lock(&rq->lock);
-	/*
-	 * The task was running during this tick - update the
-	 * time slice counter. Note: we do not update a thread's
-	 * priority until it either goes to sleep or uses up its
-	 * timeslice. This makes it possible for interactive tasks
-	 * to use up their timeslices at their highest priority levels.
-	 */
-	if (rt_task(p)) {
-		/*
-		 * RR tasks need a special form of timeslice management.
-		 * FIFO tasks have no timeslices.
-		 */
-		if ((p->policy == SCHED_RR) && !--p->time_slice) {
-			p->time_slice = task_timeslice(p);
-			p->first_time_slice = 0;
-			set_tsk_need_resched(p);
 
-			/* put it at the end of the queue: */
-			requeue_task(p, rq->active);
-		}
-		goto out_unlock;
-	}
-	if (!--p->time_slice) {
-		dequeue_task(p, rq->active);
-		set_tsk_need_resched(p);
-		p->prio = effective_prio(p);
-		p->time_slice = task_timeslice(p);
-		p->first_time_slice = 0;
-
-		if (!rq->expired_timestamp)
-			rq->expired_timestamp = jiffies;
-		if (!TASK_INTERACTIVE(p) || expired_starving(rq)) {
-			enqueue_task(p, rq->expired);
-			if (p->static_prio < rq->best_expired_prio)
-				rq->best_expired_prio = p->static_prio;
-		} else
-			enqueue_task(p, rq->active);
-	} else {
-		/*
-		 * Prevent a too long timeslice allowing a task to monopolize
-		 * the CPU. We do this by splitting up the timeslice into
-		 * smaller pieces.
-		 *
-		 * Note: this does not mean the task's timeslices expire or
-		 * get lost in any way, they just might be preempted by
-		 * another task of equal priority. (one with higher
-		 * priority would have preempted this task already.) We
-		 * requeue this task to the end of the list on this priority
-		 * level, which is in essence a round-robin of tasks with
-		 * equal priority.
-		 *
-		 * This only applies to tasks in the interactive
-		 * delta range with at least TIMESLICE_GRANULARITY to requeue.
-		 */
-		if (TASK_INTERACTIVE(p) && !((task_timeslice(p) -
-			p->time_slice) % TIMESLICE_GRANULARITY(p)) &&
-			(p->time_slice >= TIMESLICE_GRANULARITY(p)) &&
-			(p->array == rq->active)) {
+	/* SCHED_FIFO tasks have no timeslice */
+	if (unlikely(p->policy == SCHED_FIFO))
+		return;
 
-			requeue_task(p, rq->active);
-			set_tsk_need_resched(p);
-		}
+	/* p was running during this tick. Update its time slice counter. */
+	p->used_slice++;
+	ts = task_timeslice(p, rq);
+	allowed = ts - min(p->over_slice, ts >> 1);
+	if (unlikely(p->used_slice >= allowed)) {
+		p->over_slice = allowed - p->used_slice;
+		p->used_slice = -1;
+		set_tsk_need_resched(p);
 	}
-out_unlock:
-	spin_unlock(&rq->lock);
 }
 
 /*
@@ -3215,7 +2997,7 @@ out_unlock:
  */
 void scheduler_tick(void)
 {
-	unsigned long long now = sched_clock();
+	unsigned long long now = sched_clock_us();
 	struct task_struct *p = current;
 	int cpu = smp_processor_id();
 	struct rq *rq = cpu_rq(cpu);
@@ -3269,12 +3051,6 @@ EXPORT_SYMBOL(sub_preempt_count);
 
 #endif
 
-static inline int interactive_sleep(enum sleep_type sleep_type)
-{
-	return (sleep_type == SLEEP_INTERACTIVE ||
-		sleep_type == SLEEP_INTERRUPTED);
-}
-
 /*
  * schedule() is the main scheduler function.
  */
@@ -3285,56 +3061,46 @@ asmlinkage void __sched schedule(void)
 	struct list_head *queue;
 	unsigned long long now;
 	unsigned long run_time;
-	int cpu, idx, new_prio;
+	int cpu, idx;
 	long *switch_count;
 	struct rq *rq;
 
+	prev = current;
+	prefetch(prev);
+
+	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
+
 	/*
 	 * Test if we are atomic.  Since do_exit() needs to call into
 	 * schedule() atomically, we ignore that path for now.
 	 * Otherwise, whine if we are scheduling when we should not be.
 	 */
-	if (unlikely(in_atomic() && !current->exit_state)) {
-		printk(KERN_ERR "BUG: scheduling while atomic: "
-			"%s/0x%08x/%d\n",
-			current->comm, preempt_count(), current->pid);
-		debug_show_held_locks(current);
-		if (irqs_disabled())
-			print_irqtrace_events(current);
-		dump_stack();
+	if (unlikely(in_atomic())) {
+		if (unlikely(!current->exit_state)) {
+			printk(KERN_ERR "BUG: scheduling while atomic: "
+				"%s/0x%08x/%d\n",
+				current->comm, preempt_count(), current->pid);
+			debug_show_held_locks(current);
+			if (irqs_disabled())
+				print_irqtrace_events(current);
+			dump_stack();
+		}
 	}
 	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
 
-need_resched:
 	preempt_disable();
-	prev = current;
-	release_kernel_lock(prev);
-need_resched_nonpreemptible:
 	rq = this_rq();
+	prefetchw(rq);
+need_resched:
+	cpu = smp_processor_id();
+	release_kernel_lock(prev);
 
-	/*
-	 * The idle thread is not allowed to schedule!
-	 * Remove this check after it has been exercised a bit.
-	 */
-	if (unlikely(prev == rq->idle) && prev->state != TASK_RUNNING) {
-		printk(KERN_ERR "bad: scheduling from the idle thread!\n");
-		dump_stack();
-	}
-
+need_resched_nobkl:
 	schedstat_inc(rq, sched_cnt);
-	now = sched_clock();
-	if (likely((long long)(now - prev->timestamp) < NS_MAX_SLEEP_AVG)) {
-		run_time = now - prev->timestamp;
-		if (unlikely((long long)(now - prev->timestamp) < 0))
-			run_time = 0;
-	} else
-		run_time = NS_MAX_SLEEP_AVG;
-
-	/*
-	 * Tasks charged proportionately less run_time at high sleep_avg to
-	 * delay them losing their interactive status
-	 */
-	run_time /= (CURRENT_BONUS(prev) ? : 1);
+	now = sched_clock_us();
+	run_time = now - prev->timestamp;
+	prev->timestamp = prev->last_ran = now;
+	add_task_time(prev, run_time, STIME_RUN);
 
 	spin_lock_irq(&rq->lock);
 
@@ -3342,24 +3108,42 @@ need_resched_nonpreemptible:
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		switch_count = &prev->nvcsw;
 		if (unlikely((prev->state & TASK_INTERRUPTIBLE) &&
-				unlikely(signal_pending(prev))))
+				unlikely(signal_pending(prev)))) {
 			prev->state = TASK_RUNNING;
-		else {
+		} else {
 			if (prev->state == TASK_UNINTERRUPTIBLE)
 				rq->nr_uninterruptible++;
 			deactivate_task(prev, rq);
+			goto no_check_expired;
 		}
 	}
 
-	cpu = smp_processor_id();
-	if (unlikely(!rq->nr_running)) {
+	if (unlikely(prev->used_slice == -1)) {
+		dequeue_task(prev, prev->array);
+		/* SCHED_FIFO can come in here too, from sched_yield */
+		array = rq->active;
+		if (!rt_task(prev)) {
+			array = rq->expired;
+			prev->prio = task_priority(prev);
+			update_min_expired_prio(prev, rq);
+		}
+		enqueue_task(prev, array);
+		prev->used_slice = 0;
+		goto no_check_idle;
+	}
+no_check_expired:
+
+	if (!rq->nr_running) {
+		rq->min_expired_prio = MAX_PRIO;
+		rq->array_sequence++;
 		idle_balance(cpu, rq);
 		if (!rq->nr_running) {
+			schedstat_inc(rq, sched_goidle);
 			next = rq->idle;
-			rq->expired_timestamp = 0;
 			goto switch_tasks;
 		}
 	}
+no_check_idle:
 
 	array = rq->active;
 	if (unlikely(!array->nr_active)) {
@@ -3370,72 +3154,55 @@ need_resched_nonpreemptible:
 		rq->active = rq->expired;
 		rq->expired = array;
 		array = rq->active;
-		rq->expired_timestamp = 0;
-		rq->best_expired_prio = MAX_PRIO;
+		rq->array_sequence++;
+		rq->min_expired_prio = MAX_PRIO;
 	}
 
 	idx = sched_find_first_bit(array->bitmap);
 	queue = array->queue + idx;
 	next = list_entry(queue->next, struct task_struct, run_list);
 
-	if (!rt_task(next) && interactive_sleep(next->sleep_type)) {
-		unsigned long long delta = now - next->timestamp;
-		if (unlikely((long long)(now - next->timestamp) < 0))
-			delta = 0;
-
-		if (next->sleep_type == SLEEP_INTERACTIVE)
-			delta = delta * (ON_RUNQUEUE_WEIGHT * 128 / 100) / 128;
-
-		array = next->array;
-		new_prio = recalc_task_prio(next, next->timestamp + delta);
-
-		if (unlikely(next->prio != new_prio)) {
-			dequeue_task(next, array);
-			next->prio = new_prio;
-			enqueue_task(next, array);
-		}
-	}
-	next->sleep_type = SLEEP_NORMAL;
 switch_tasks:
-	if (next == rq->idle)
-		schedstat_inc(rq, sched_goidle);
+	prefetch(&next->mm);
 	prefetch(next);
 	prefetch_stack(next);
 	clear_tsk_need_resched(prev);
-	rcu_qsctr_inc(task_cpu(prev));
+	rcu_qsctr_inc(cpu);
 
 	update_cpu_clock(prev, rq, now);
 
-	prev->sleep_avg -= run_time;
-	if ((long)prev->sleep_avg <= 0)
-		prev->sleep_avg = 0;
-	prev->timestamp = prev->last_ran = now;
-
 	sched_info_switch(prev, next);
 	if (likely(prev != next)) {
+		struct task_struct *from;
+
+		prefetch(next->mm);
+		prefetch(next->thread_info);
+
 		next->timestamp = next->last_ran = now;
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;
 
 		prepare_task_switch(rq, next);
-		prev = context_switch(rq, prev, next);
-		barrier();
+		from = context_switch(rq, prev, next);
 		/*
 		 * this_rq must be evaluated again because prev may have moved
 		 * CPUs since it called schedule(), thus the 'rq' on its stack
 		 * frame will be invalid.
 		 */
-		finish_task_switch(this_rq(), prev);
+		rq = this_rq();
+		finish_task_switch(rq, from);
 	} else
 		spin_unlock_irq(&rq->lock);
 
-	prev = current;
 	if (unlikely(reacquire_kernel_lock(prev) < 0))
-		goto need_resched_nonpreemptible;
+		goto need_resched_nobkl;
 	preempt_enable_no_resched();
-	if (unlikely(test_thread_flag(TIF_NEED_RESCHED)))
+	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) {
+		preempt_disable();
+		rq = this_rq();
 		goto need_resched;
+	}
 }
 EXPORT_SYMBOL(schedule);
 
@@ -3916,7 +3683,7 @@ void set_user_nice(struct task_struct *p
 	p->static_prio = NICE_TO_PRIO(nice);
 	set_load_weight(p);
 	old_prio = p->prio;
-	p->prio = effective_prio(p);
+	p->prio = task_priority(p);
 	delta = p->prio - old_prio;
 
 	if (array) {
@@ -4047,14 +3814,9 @@ static void __setscheduler(struct task_s
 
 	p->policy = policy;
 	p->rt_priority = prio;
-	p->normal_prio = normal_prio(p);
+	p->normal_prio = task_priority(p);
 	/* we are holding p->pi_lock already */
 	p->prio = rt_mutex_getprio(p);
-	/*
-	 * SCHED_BATCH tasks are treated as perpetual CPU hogs:
-	 */
-	if (policy == SCHED_BATCH)
-		p->sleep_avg = 0;
 	set_load_weight(p);
 }
 
@@ -4149,8 +3911,11 @@ recheck:
 		deactivate_task(p, rq);
 	oldprio = p->prio;
 	__setscheduler(p, policy, param->sched_priority);
+	if (policy == SCHED_FIFO || policy == SCHED_RR)
+		p->used_slice = 0;
+
 	if (array) {
-		__activate_task(p, rq);
+		__activate_task(p, rq, rq->active);
 		/*
 		 * Reschedule if we are currently running on this runqueue and
 		 * our priority decreased, or if we are not currently running on
@@ -4438,46 +4203,13 @@ asmlinkage long sys_sched_getaffinity(pi
  */
 asmlinkage long sys_sched_yield(void)
 {
-	struct rq *rq = this_rq_lock();
-	struct prio_array *array = current->array, *target = rq->expired;
-
-	schedstat_inc(rq, yld_cnt);
-	/*
-	 * We implement yielding by moving the task into the expired
-	 * queue.
-	 *
-	 * (special rule: RT tasks will just roundrobin in the active
-	 *  array.)
-	 */
-	if (rt_task(current))
-		target = rq->active;
-
-	if (array->nr_active == 1) {
-		schedstat_inc(rq, yld_act_empty);
-		if (!rq->expired->nr_active)
-			schedstat_inc(rq, yld_both_empty);
-	} else if (!rq->expired->nr_active)
-		schedstat_inc(rq, yld_exp_empty);
-
-	if (array != target) {
-		dequeue_task(current, array);
-		enqueue_task(current, target);
-	} else
-		/*
-		 * requeue_task is cheaper so perform that if possible.
-		 */
-		requeue_task(current, array);
-
-	/*
-	 * Since we are going to call schedule() anyway, there's
-	 * no need to preempt or enable interrupts:
-	 */
-	__release(rq->lock);
-	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
-	_raw_spin_unlock(&rq->lock);
-	preempt_enable_no_resched();
-
-	schedule();
+	local_irq_disable();
+#ifdef CONFIG_SCHEDSTATS
+	schedstat_inc(this_rq(), yld_cnt);
+#endif
+	current->used_slice = -1;
+	set_need_resched();
+	local_irq_enable();
 
 	return 0;
 }
@@ -4566,6 +4298,15 @@ void __sched yield(void)
 {
 	set_current_state(TASK_RUNNING);
 	sys_sched_yield();
+	/*
+	 * Kernel-space yield won't follow the schedule upon
+	 * return from syscall path. Unless preempt is enabled,
+	 * however in that case, preempt_schedule doesn't drop
+	 * the bkl, which is needed in some paths.
+	 *
+	 * Must call schedule() here.
+	 */
+	schedule();
 }
 EXPORT_SYMBOL(yield);
 
@@ -4662,6 +4403,8 @@ long sys_sched_rr_get_interval(pid_t pid
 	struct task_struct *p;
 	int retval = -EINVAL;
 	struct timespec t;
+	unsigned long flags;
+	struct rq *rq;
 
 	if (pid < 0)
 		goto out_nounlock;
@@ -4676,8 +4419,10 @@ long sys_sched_rr_get_interval(pid_t pid
 	if (retval)
 		goto out_unlock;
 
+	rq = task_rq_lock(p, &flags);
 	jiffies_to_timespec(p->policy == SCHED_FIFO ?
-				0 : task_timeslice(p), &t);
+				0 : task_timeslice(p, rq), &t);
+	task_rq_unlock(rq, &flags);
 	read_unlock(&tasklist_lock);
 	retval = copy_to_user(interval, &t, sizeof(t)) ? -EFAULT : 0;
 out_nounlock:
@@ -4805,11 +4550,12 @@ void __cpuinit init_idle(struct task_str
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
 
-	idle->timestamp = sched_clock();
-	idle->sleep_avg = 0;
+	idle->timestamp = sched_clock_us();
 	idle->array = NULL;
 	idle->prio = idle->normal_prio = MAX_PRIO;
 	idle->state = TASK_RUNNING;
+	idle->used_slice = 0;
+	idle->over_slice = 0;
 	idle->cpus_allowed = cpumask_of_cpu(cpu);
 	set_task_cpu(idle, cpu);
 
@@ -4928,16 +4674,8 @@ static int __migrate_task(struct task_st
 
 	set_task_cpu(p, dest_cpu);
 	if (p->array) {
-		/*
-		 * Sync timestamp with rq_dest's before activating.
-		 * The same thing could be achieved by doing this step
-		 * afterwards, and pretending it was a local activate.
-		 * This way is cleaner and logically correct.
-		 */
-		p->timestamp = p->timestamp - rq_src->most_recent_timestamp
-				+ rq_dest->most_recent_timestamp;
 		deactivate_task(p, rq_src);
-		__activate_task(p, rq_dest);
+		activate_task(p, rq_dest, 0);
 		if (TASK_PREEMPTS_CURR(p, rq_dest))
 			resched_task(rq_dest->curr);
 	}
@@ -6771,7 +6509,7 @@ void __init sched_init(void)
 		rq->nr_running = 0;
 		rq->active = rq->arrays;
 		rq->expired = rq->arrays + 1;
-		rq->best_expired_prio = MAX_PRIO;
+		rq->min_expired_prio = MAX_PRIO;
 
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
@@ -6791,7 +6529,7 @@ void __init sched_init(void)
 				INIT_LIST_HEAD(array->queue + k);
 				__clear_bit(k, array->bitmap);
 			}
-			// delimiter for bitsearch
+			/* delimiter for bitsearch */
 			__set_bit(MAX_PRIO, array->bitmap);
 		}
 	}
@@ -6864,10 +6602,10 @@ void normalize_rt_tasks(void)
 
 		array = p->array;
 		if (array)
-			deactivate_task(p, task_rq(p));
+			deactivate_task(p, rq);
 		__setscheduler(p, SCHED_NORMAL, 0);
 		if (array) {
-			__activate_task(p, task_rq(p));
+			__activate_task(p, rq, array);
 			resched_task(rq->curr);
 		}
 
Index: linux-2.6/mm/oom_kill.c
===================================================================
--- linux-2.6.orig/mm/oom_kill.c	2007-03-22 20:44:00.000000000 +1100
+++ linux-2.6/mm/oom_kill.c	2007-03-22 20:44:17.000000000 +1100
@@ -287,11 +287,10 @@ static void __oom_kill_task(struct task_
 		printk(KERN_ERR "Killed process %d (%s)\n", p->pid, p->comm);
 
 	/*
-	 * We give our sacrificial lamb high priority and access to
-	 * all the memory it needs. That way it should be able to
-	 * exit() and clear out its resources quickly...
+	 * We give our sacrificial lamb access to all the memory it needs.
+	 * That way it should be able to exit() and clear out its resources
+	 * quickly...
 	 */
-	p->time_slice = HZ;
 	set_tsk_thread_flag(p, TIF_MEMDIE);
 
 	force_sig(SIGKILL, p);
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c	2007-03-22 20:44:00.000000000 +1100
+++ linux-2.6/kernel/sysctl.c	2007-03-22 20:44:17.000000000 +1100
@@ -76,6 +76,9 @@ extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
+extern int sched_base_timeslice;
+extern int sched_min_base;
+extern int sched_max_base;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
@@ -603,7 +606,17 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
-
+	{
+		.ctl_name	= KERN_SCHED_TIMESLICE,
+		.procname	= "base_timeslice",
+		.data		= &sched_base_timeslice,
+		.maxlen		= sizeof (sched_base_timeslice),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &sched_min_base,
+		.extra2		= &sched_max_base,
+	},
 	{ .ctl_name = 0 }
 };
 
@@ -859,6 +872,7 @@ static ctl_table vm_table[] = {
 		.extra1		= &zero,
 	},
 #endif
+
 	{ .ctl_name = 0 }
 };
 
Index: linux-2.6/include/linux/init_task.h
===================================================================
--- linux-2.6.orig/include/linux/init_task.h	2007-03-22 20:44:00.000000000 +1100
+++ linux-2.6/include/linux/init_task.h	2007-03-22 20:44:17.000000000 +1100
@@ -99,16 +99,15 @@ extern struct group_info init_groups;
 	.usage		= ATOMIC_INIT(2),				\
 	.flags		= 0,						\
 	.lock_depth	= -1,						\
-	.prio		= MAX_PRIO-20,					\
-	.static_prio	= MAX_PRIO-20,					\
-	.normal_prio	= MAX_PRIO-20,					\
+	.prio		= MAX_PRIO-29,					\
+	.static_prio	= MAX_PRIO-29,					\
+	.normal_prio	= MAX_PRIO-29,					\
 	.policy		= SCHED_NORMAL,					\
 	.cpus_allowed	= CPU_MASK_ALL,					\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
 	.run_list	= LIST_HEAD_INIT(tsk.run_list),			\
 	.ioprio		= 0,						\
-	.time_slice	= HZ,						\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
 	.ptrace_children= LIST_HEAD_INIT(tsk.ptrace_children),		\
 	.ptrace_list	= LIST_HEAD_INIT(tsk.ptrace_list),		\
Index: linux-2.6/include/linux/sysctl.h
===================================================================
--- linux-2.6.orig/include/linux/sysctl.h	2007-03-22 20:44:00.000000000 +1100
+++ linux-2.6/include/linux/sysctl.h	2007-03-22 20:44:17.000000000 +1100
@@ -165,6 +165,7 @@ enum
 	KERN_MAX_LOCK_DEPTH=74,
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_SCHED_TIMESLICE=77, /* int: base timeslice for scheduler */
 };
 
 

--------------010403070800080307020307--
Send instant messages to your online friends http://au.messenger.yahoo.com 
