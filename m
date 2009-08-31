Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZHaD0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZHaD0n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 23:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbZHaD0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 23:26:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:39627 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbZHaD0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 23:26:36 -0400
Message-ID: <4A9B4286.7000401@kernel.org>
Date: Mon, 31 Aug 2009 12:24:54 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, jeff@garzik.org, dhowells@redhat.com
Subject: [very-early-draft-unsplit PATCH] workqueue: implement global cpu
 workqueue
References: <1251364122-9592-1-git-send-email-jens.axboe@oracle.com> <4A967DD7.20603@kernel.org> <20090827124927.GJ12579@kernel.dk> <4A96830F.9040805@kernel.org> <20090827184939.GK12579@kernel.dk> <4A9780EF.1030102@kernel.org> <20090828070641.GR12579@kernel.dk>
In-Reply-To: <20090828070641.GR12579@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 03:25:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, here's the early version which finally builds.  It's a rather
huge patch and contains a large number of known and unknown bugs and
doesn't actually convert any users but it should be enough to show the
basic idea and how each area of the problem space is solved.

I'll post a proper cleaned-up and hopefully working version in several
days.

Thanks.

SERIOUSLY_BROKEN_AND_NOT_SIGNED_OFF_BY_ANYONE
---
 include/linux/kthread.h      |    1
 include/linux/sched.h        |    3
 include/linux/stop_machine.h |    6
 include/linux/workqueue.h    |   52 -
 init/main.c                  |    2
 kernel/kthread.c             |    7
 kernel/sched.c               |   14
 kernel/sched_fair.c          |   58 -
 kernel/sched_idletask.c      |    1
 kernel/sched_rt.c            |    1
 kernel/sched_workqueue.c     |   53 +
 kernel/sched_workqueue.h     |    5
 kernel/stop_machine.c        |  151 +++
 kernel/workqueue.c           | 1738 +++++++++++++++++++++++++++++++++----------
 14 files changed, 1655 insertions(+), 437 deletions(-)

Index: work/include/linux/stop_machine.h
===================================================================
--- work.orig/include/linux/stop_machine.h
+++ work/include/linux/stop_machine.h
@@ -53,6 +53,11 @@ int stop_machine_create(void);
  */
 void stop_machine_destroy(void);

+/**
+ * init_stop_machine: initialize stop_machine during boot
+ */
+void init_stop_machine(void);
+
 #else

 static inline int stop_machine(int (*fn)(void *), void *data,
@@ -67,6 +72,7 @@ static inline int stop_machine(int (*fn)

 static inline int stop_machine_create(void) { return 0; }
 static inline void stop_machine_destroy(void) { }
+static inline void init_stop_machine(void) { }

 #endif /* CONFIG_SMP */
 #endif /* _LINUX_STOP_MACHINE */
Index: work/init/main.c
===================================================================
--- work.orig/init/main.c
+++ work/init/main.c
@@ -35,6 +35,7 @@
 #include <linux/security.h>
 #include <linux/smp.h>
 #include <linux/workqueue.h>
+#include <linux/stop_machine.h>
 #include <linux/profile.h>
 #include <linux/rcupdate.h>
 #include <linux/moduleparam.h>
@@ -807,6 +808,7 @@ static void __init do_basic_setup(void)
 {
 	rcu_init_sched(); /* needed by module_init stage. */
 	init_workqueues();
+	init_stop_machine();
 	cpuset_init_smp();
 	usermodehelper_init();
 	driver_init();
Index: work/kernel/stop_machine.c
===================================================================
--- work.orig/kernel/stop_machine.c
+++ work/kernel/stop_machine.c
@@ -25,6 +25,8 @@ enum stopmachine_state {
 	STOPMACHINE_RUN,
 	/* Exit */
 	STOPMACHINE_EXIT,
+	/* Done */
+	STOPMACHINE_DONE,
 };
 static enum stopmachine_state state;

@@ -42,10 +44,9 @@ static DEFINE_MUTEX(lock);
 static DEFINE_MUTEX(setup_lock);
 /* Users of stop_machine. */
 static int refcount;
-static struct workqueue_struct *stop_machine_wq;
+static struct task_struct **stop_machine_threads;
 static struct stop_machine_data active, idle;
 static const struct cpumask *active_cpus;
-static void *stop_machine_work;

 static void set_state(enum stopmachine_state newstate)
 {
@@ -63,14 +64,31 @@ static void ack_state(void)
 }

 /* This is the actual function which stops the CPU. It runs
- * in the context of a dedicated stopmachine workqueue. */
-static void stop_cpu(struct work_struct *unused)
+ * on dedicated per-cpu kthreads. */
+static int stop_cpu(void *unused)
 {
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
-	struct stop_machine_data *smdata = &idle;
+	struct stop_machine_data *smdata;
 	int cpu = smp_processor_id();
 	int err;

+repeat:
+	/* Wait for __stop_machine() to initiate */
+	while (true) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		/* <- kthread_stop() and __stop_machine()::smp_wmb() */
+		if (kthread_should_stop()) {
+			__set_current_state(TASK_RUNNING);
+			return 0;
+		}
+		if (state == STOPMACHINE_PREPARE)
+			break;
+		schedule();
+	}
+	smp_rmb();	/* <- __stop_machine()::set_state() */
+
+	/* Okay, let's go */
+	smdata = &idle;
 	if (!active_cpus) {
 		if (cpu == cpumask_first(cpu_online_mask))
 			smdata = &active;
@@ -104,6 +122,7 @@ static void stop_cpu(struct work_struct
 	} while (curstate != STOPMACHINE_EXIT);

 	local_irq_enable();
+	goto repeat;
 }

 /* Callback for CPUs which aren't supposed to do anything. */
@@ -112,46 +131,122 @@ static int chill(void *unused)
 	return 0;
 }

+static int create_stop_machine_thread(unsigned int cpu)
+{
+	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+	struct task_struct **pp = per_cpu_ptr(stop_machine_threads, cpu);
+	struct task_struct *p;
+
+	if (*pp)
+		return -EBUSY;
+
+	p = kthread_create(stop_cpu, NULL, "kstop/%u", cpu);
+	if (IS_ERR(p))
+		return PTR_ERR(p);
+
+	sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
+	*pp = p;
+	return 0;
+}
+
+/* Should be called with cpu hotplug disabled and setup_lock held */
+static void kill_stop_machine_threads(void)
+{
+	unsigned int cpu;
+
+	if (!stop_machine_threads)
+		return;
+
+	for_each_online_cpu(cpu) {
+		struct task_struct *p = *per_cpu_ptr(stop_machine_threads, cpu);
+		if (p)
+			kthread_stop(p);
+	}
+	free_percpu(stop_machine_threads);
+	stop_machine_threads = NULL;
+}
+
 int stop_machine_create(void)
 {
+	unsigned int cpu;
+
+	get_online_cpus();
 	mutex_lock(&setup_lock);
 	if (refcount)
 		goto done;
-	stop_machine_wq = create_rt_workqueue("kstop");
-	if (!stop_machine_wq)
-		goto err_out;
-	stop_machine_work = alloc_percpu(struct work_struct);
-	if (!stop_machine_work)
+
+	stop_machine_threads = alloc_percpu(struct task_struct *);
+	if (!stop_machine_threads)
 		goto err_out;
+
+	/*
+	 * cpu hotplug is disabled, create only for online cpus,
+	 * cpu_callback() will handle cpu hot [un]plugs.
+	 */
+	for_each_online_cpu(cpu) {
+		if (create_stop_machine_thread(cpu))
+			goto err_out;
+		kthread_bind(*per_cpu_ptr(stop_machine_threads, cpu), cpu);
+	}
 done:
 	refcount++;
 	mutex_unlock(&setup_lock);
+	put_online_cpus();
 	return 0;

 err_out:
-	if (stop_machine_wq)
-		destroy_workqueue(stop_machine_wq);
+	kill_stop_machine_threads();
 	mutex_unlock(&setup_lock);
+	put_online_cpus();
 	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(stop_machine_create);

 void stop_machine_destroy(void)
 {
+	get_online_cpus();
 	mutex_lock(&setup_lock);
-	refcount--;
-	if (refcount)
-		goto done;
-	destroy_workqueue(stop_machine_wq);
-	free_percpu(stop_machine_work);
-done:
+	if (!--refcount)
+		kill_stop_machine_threads();
 	mutex_unlock(&setup_lock);
+	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(stop_machine_destroy);

+static int __cpuinit stop_machine_cpu_callback(struct notifier_block *nfb,
+					       unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+	struct task_struct **pp = per_cpu_ptr(stop_machine_threads, cpu);
+
+	/* Hotplug exclusion is enough, no need to worry about setup_lock */
+	if (!stop_machine_threads)
+		return NOTIFY_OK;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+		if (create_stop_machine_thread(cpu)) {
+			printk(KERN_ERR "failed to create stop machine "
+			       "thread for %u\n", cpu);
+			return NOTIFY_BAD;
+		}
+		break;
+
+	case CPU_ONLINE:
+		kthread_bind(*pp, cpu);
+		break;
+
+	case CPU_UP_CANCELED:
+	case CPU_POST_DEAD:
+		kthread_stop(*pp);
+		*pp = NULL;
+		break;
+	}
+	return NOTIFY_OK;
+}
+
 int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 {
-	struct work_struct *sm_work;
 	int i, ret;

 	/* Set up initial state. */
@@ -164,19 +259,18 @@ int __stop_machine(int (*fn)(void *), vo
 	idle.fn = chill;
 	idle.data = NULL;

-	set_state(STOPMACHINE_PREPARE);
+	set_state(STOPMACHINE_PREPARE);	/* -> stop_cpu()::smp_rmb() */
+	smp_wmb();			/* -> stop_cpu()::set_current_state() */

 	/* Schedule the stop_cpu work on all cpus: hold this CPU so one
 	 * doesn't hit this CPU until we're ready. */
 	get_cpu();
-	for_each_online_cpu(i) {
-		sm_work = per_cpu_ptr(stop_machine_work, i);
-		INIT_WORK(sm_work, stop_cpu);
-		queue_work_on(i, stop_machine_wq, sm_work);
-	}
+	for_each_online_cpu(i)
+		wake_up_process(*per_cpu_ptr(stop_machine_threads, i));
 	/* This will release the thread on our CPU. */
 	put_cpu();
-	flush_workqueue(stop_machine_wq);
+	while (state < STOPMACHINE_DONE)
+		yield();
 	ret = active.fnret;
 	mutex_unlock(&lock);
 	return ret;
@@ -197,3 +291,8 @@ int stop_machine(int (*fn)(void *), void
 	return ret;
 }
 EXPORT_SYMBOL_GPL(stop_machine);
+
+void __init init_stop_machine(void)
+{
+	hotcpu_notifier(stop_machine_cpu_callback, 0);
+}
Index: work/include/linux/workqueue.h
===================================================================
--- work.orig/include/linux/workqueue.h
+++ work/include/linux/workqueue.h
@@ -22,11 +22,28 @@ typedef void (*work_func_t)(struct work_
  */
 #define work_data_bits(work) ((unsigned long *)(&(work)->data))

+enum {
+	WORK_STRUCT_PENDING_BIT	= 0,	/* work item is pending execution */
+	WORK_STRUCT_COLOR_BIT	= 1,	/* color for workqueue flushing */
+	WORK_STRUCT_LINKED_BIT	= 2,	/* next work is linked to this one */
+
+	WORK_STRUCT_PENDING	= 1 << WORK_STRUCT_PENDING_BIT,
+	WORK_STRUCT_COLOR	= 1 << WORK_STRUCT_COLOR_BIT,
+	WORK_STRUCT_LINKED	= 1 << WORK_STRUCT_LINKED_BIT,
+
+	/*
+	 * Reserve 3bits off of cwq pointer.  This is enough and
+	 * provides acceptable alignment on both 32 and 64bit
+	 * machines.
+	 */
+	WORK_STRUCT_FLAG_BITS	= 3,
+
+	WORK_STRUCT_FLAG_MASK	= (1UL << WORK_STRUCT_FLAG_BITS) - 1,
+	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
+};
+
 struct work_struct {
 	atomic_long_t data;
-#define WORK_STRUCT_PENDING 0		/* T if work item pending execution */
-#define WORK_STRUCT_FLAG_MASK (3UL)
-#define WORK_STRUCT_WQ_DATA_MASK (~WORK_STRUCT_FLAG_MASK)
 	struct list_head entry;
 	work_func_t func;
 #ifdef CONFIG_LOCKDEP
@@ -163,14 +180,17 @@ struct execute_work {
 #define work_clear_pending(work) \
 	clear_bit(WORK_STRUCT_PENDING, work_data_bits(work))

+enum {
+	WQ_FREEZEABLE		= 1 << 0, /* freeze during suspend */
+	WQ_EMERGENCY_WORKER	= 1 << 1, /* has an emergency worker */
+};

 extern struct workqueue_struct *
-__create_workqueue_key(const char *name, int singlethread,
-		       int freezeable, int rt, struct lock_class_key *key,
-		       const char *lock_name);
+__create_workqueue_key(const char *name, unsigned int flags,
+		       struct lock_class_key *key, const char *lock_name);

 #ifdef CONFIG_LOCKDEP
-#define __create_workqueue(name, singlethread, freezeable, rt)	\
+#define __create_workqueue(name, flags)				\
 ({								\
 	static struct lock_class_key __key;			\
 	const char *__lock_name;				\
@@ -180,20 +200,20 @@ __create_workqueue_key(const char *name,
 	else							\
 		__lock_name = #name;				\
 								\
-	__create_workqueue_key((name), (singlethread),		\
-			       (freezeable), (rt), &__key,	\
+	__create_workqueue_key((name), (flags), &__key,		\
 			       __lock_name);			\
 })
 #else
-#define __create_workqueue(name, singlethread, freezeable, rt)	\
-	__create_workqueue_key((name), (singlethread), (freezeable), (rt), \
-			       NULL, NULL)
+#define __create_workqueue(name, flags)				\
+	__create_workqueue_key((name), (flags), NULL, NULL)
 #endif

-#define create_workqueue(name) __create_workqueue((name), 0, 0, 0)
-#define create_rt_workqueue(name) __create_workqueue((name), 0, 0, 1)
-#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1, 0)
-#define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0, 0)
+#define create_workqueue(name)					\
+	__create_workqueue((name), WQ_EMERGENCY_WORKER)
+#define create_freezeable_workqueue(name)			\
+	__create_workqueue((name), WQ_FREEZEABLE | WQ_EMERGENCY_WORKER)
+#define create_singlethread_workqueue(name)			\
+	__create_workqueue((name), WQ_EMERGENCY_WORKER)

 extern void destroy_workqueue(struct workqueue_struct *wq);

Index: work/kernel/workqueue.c
===================================================================
--- work.orig/kernel/workqueue.c
+++ work/kernel/workqueue.c
@@ -29,77 +29,176 @@
 #include <linux/kthread.h>
 #include <linux/hardirq.h>
 #include <linux/mempolicy.h>
-#include <linux/freezer.h>
+#include <linux/freezer.h>		// freezer not implemented yet
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
+#include <linux/wait.h>
 #define CREATE_TRACE_POINTS
-#include <trace/events/workqueue.h>
+#include <trace/events/workqueue.h>	// tracer not implemented yet
+
+#include "sched_workqueue.h"
+
+enum {
+	/* worker state flags */
+	WORKER_STA_IDLE		= 1 << 0,	/* is idle */
+	WORKER_STA_RUNNING	= 1 << 1,	/* busy && TASK_RUNNING */
+	WORKER_STA_ROGUE	= 1 << 2,	/* don't try to track RUNNING */
+
+	/* worker request flags */
+	WORKER_REQ_DIE		= 1 << 1,	/* die die die */
+
+	/* global_cwq flags */
+	GCWQ_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
+	GCWQ_MANAGING_WORKERS	= 1 << 1,	/* managing workers */
+
+	/* gcwq->trustee_state */
+	TRUSTEE_NONE		= 0,
+	TRUSTEE_IN_CHARGE	= 1,
+	TRUSTEE_DRAIN		= 2,
+	TRUSTEE_CANCEL		= 3,
+	TRUSTEE_RELEASE		= 4,
+	TRUSTEE_DONE		= 5,
+
+	MAX_CPU_WORKERS_ORDER	= 7,		/* 128 */
+	MAX_WORKERS_PER_CPU	= 1 << MAX_CPU_WORKERS_ORDER,
+
+	BUSY_WORKER_HASH_ORDER	= MAX_CPU_WORKERS_ORDER - 3, /* 16 pointers */
+	BUSY_WORKER_HASH_SIZE	= 1 << BUSY_WORKER_HASH_ORDER,
+	BUSY_WORKER_HASH_MASK	= BUSY_WORKER_HASH_SIZE - 1,
+
+	MAX_IDLE_WORKERS_RATIO	= 4,		/* 1/4 of busy can be idle */
+	IDLE_WORKER_TIMEOUT	= 180 * HZ,	/* keep idle ones for 3 mins */
+
+	MAYDAY_INTERVAL		= 2 * HZ,	/* call for help every 2 secs */
+	CREATE_COOLDOWN		= 5 * HZ,	/* time to breath after fail */
+
+	WORKER_NICE_LEVEL	= -5,		/* bump it up, I mean, down? */
+	EMERGENCY_NICE_LEVEL	= -20,		/* EMERGENCY! */
+};
+
+struct work_notifier {
+	struct list_head	entry;
+	struct completion	*notify;
+};

 /*
- * The per-CPU workqueue (if single thread, we always use the first
- * possible cpu).
+ * Structure fields follow one of the following exclusion rules.
+ *
+ * I: Set during initialization and read-only afterwards.
+ *
+ * P: Preemption protected.  Disabling preemption is enough and should
+ *    only be modified and accessed from the local cpu.
+ *
+ * L: gcwq->lock protected.  Access with gcw->lock held.
+ *
+ * M: Modification requires gcwq->lock and should be done only from
+ *    local cpu.  Disabling preemption is enough to read from local
+ *    cpu.
+ *
+ * D: Don't care.
  */
-struct cpu_workqueue_struct {

-	spinlock_t lock;
+struct global_cwq;
+
+/*
+ * The poor guys doing the actual heavy lifting.
+ */
+struct worker {
+	/* on idle list while idle, on busy hash table while busy */
+	union {
+		struct hlist_node	hentry;	/* L: while idle */
+		struct list_head	entry;	/* L: while busy */
+	};

-	struct list_head worklist;
-	wait_queue_head_t more_work;
-	struct work_struct *current_work;
+	struct work_struct	*current_work;	/* L: work being processed */
+	struct list_head	scheduled;	/* L: scheduled works */
+	struct task_struct	*task;		/* I: worker task */
+	struct global_cwq	*gcwq;		/* I: the associated gcwq */
+	unsigned int		state;		/* P: WORKER_STA_* flags */
+	unsigned int		req_flags;	/* L: requests from outside */
+	unsigned long		last_active;	/* L: last active timestamp */
+};

-	struct workqueue_struct *wq;
-	struct task_struct *thread;
-} ____cacheline_aligned;
+/*
+ * Global per-cpu workqueue.  There's one and only one for each cpu
+ * and all works are queued and processed here regardless of their
+ * target workqueues.
+ */
+struct global_cwq {
+	spinlock_t		lock;		/* the gcwq lock */
+	struct list_head	worklist;	/* L: list of pending works */
+	unsigned int		cpu;		/* I: the associated cpu */
+	unsigned int		flags;		/* L: GCWQ_* flags */
+
+	int			nr_workers;	/* L: total number of workers */
+	int			nr_idle;	/* L: currently idle ones */
+
+	/* track concurrency, used by scheduler callbacks */
+	int			nr_running;	/* P: currently running ones */
+
+	/* workers are chained either in the idle_list or busy_hash */
+	struct list_head	idle_list;	/* M: list of idle workers */
+	struct hlist_head	busy_hash[BUSY_WORKER_HASH_SIZE];
+						/* L: hash of busy workers */
+
+	struct timer_list	idle_timer;	/* L: worker idle timeout */
+	struct timer_list	mayday_timer;	/* L: SOS timer for dworkers */
+
+	struct task_struct	*trustee;	/* L: for gcwq shutdown */
+	int			trustee_state;	/* L: trustee state */
+	int			trustee_target;	/* L: trustee target state */
+	wait_queue_head_t	trustee_wait;	/* D: trustee wait */
+	struct work_struct	trustee_reap;	/* D: grim reaper for trustee */
+};
+
+/*
+ * The per-CPU workqueue.  The lower WORK_STRUCT_FLAG_BITS of
+ * work_struct->data are used for flags and thus cwqs need to be
+ * aligned at two's power of the bits.
+ */
+struct cpu_workqueue_struct {
+	struct global_cwq	*gcwq;		/* I: the associated gcwq */
+	int			nr_in_flight;	/* L: nr of in_flight works */
+	unsigned int		flush_color;	/* L: current flush color */
+	int			flush_cnt;	/* L: in-progress flush count */
+	struct workqueue_struct *wq;		/* I: the owning workqueue */
+} __attribute__((aligned(1 << WORK_STRUCT_FLAG_BITS)));

 /*
  * The externally visible workqueue abstraction is an array of
  * per-CPU workqueues:
  */
 struct workqueue_struct {
-	struct cpu_workqueue_struct *cpu_wq;
-	struct list_head list;
-	const char *name;
-	int singlethread;
-	int freezeable;		/* Freeze threads during suspend */
-	int rt;
+	unsigned int		flags;		/* I: WQ_* flags */
+	struct cpu_workqueue_struct *cpu_wq;	/* I: cwq's */
+
+	struct mutex		flush_mutex;	/* single flush at a time */
+	atomic_t		nr_cwqs_to_flush; /* flush in progress */
+	struct completion	*flush_done;	/* flush done */
+
+	cpumask_var_t		mayday_mask;	/* cpus requesting rescue */
+	struct worker		*emergency;	/* I: emergency worker */
+
+	const char		*name;		/* I: workqueue name */
 #ifdef CONFIG_LOCKDEP
-	struct lockdep_map lockdep_map;
+	struct lockdep_map	lockdep_map;
 #endif
 };

-/* Serializes the accesses to the list of workqueues. */
-static DEFINE_SPINLOCK(workqueue_lock);
-static LIST_HEAD(workqueues);
+/* the almighty global cpu workqueues */
+static DEFINE_PER_CPU(struct global_cwq, global_cwq);

-static int singlethread_cpu __read_mostly;
-static const struct cpumask *cpu_singlethread_map __read_mostly;
-/*
- * _cpu_down() first removes CPU from cpu_online_map, then CPU_DEAD
- * flushes cwq->worklist. This means that flush_workqueue/wait_on_work
- * which comes in between can't use for_each_online_cpu(). We could
- * use cpu_possible_map, the cpumask below is more a documentation
- * than optimization.
- */
-static cpumask_var_t cpu_populated_map __read_mostly;
-
-/* If it's single threaded, it isn't in the list of workqueues. */
-static inline int is_wq_single_threaded(struct workqueue_struct *wq)
-{
-	return wq->singlethread;
-}
+static int worker_thread(void *__worker);

-static const struct cpumask *wq_cpu_map(struct workqueue_struct *wq)
+static struct global_cwq *get_gcwq(unsigned int cpu)
 {
-	return is_wq_single_threaded(wq)
-		? cpu_singlethread_map : cpu_populated_map;
+	return &per_cpu(global_cwq, cpu);
 }

-static
-struct cpu_workqueue_struct *wq_per_cpu(struct workqueue_struct *wq, int cpu)
+static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
+					    struct workqueue_struct *wq)
 {
-	if (unlikely(is_wq_single_threaded(wq)))
-		cpu = singlethread_cpu;
 	return per_cpu_ptr(wq->cpu_wq, cpu);
 }

@@ -108,46 +207,295 @@ struct cpu_workqueue_struct *wq_per_cpu(
  * - Must *only* be called if the pending flag is set
  */
 static inline void set_wq_data(struct work_struct *work,
-				struct cpu_workqueue_struct *cwq)
+			       struct cpu_workqueue_struct *cwq,
+			       unsigned long flags)
 {
-	unsigned long new;
-
 	BUG_ON(!work_pending(work));
+	BUG_ON((unsigned long)cwq & WORK_STRUCT_FLAG_MASK);

-	new = (unsigned long) cwq | (1UL << WORK_STRUCT_PENDING);
-	new |= WORK_STRUCT_FLAG_MASK & *work_data_bits(work);
-	atomic_long_set(&work->data, new);
+	atomic_long_set(&work->data, (unsigned long)cwq | flags);
 }

-static inline
-struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
+static inline struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 {
 	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
 }

-static void insert_work(struct cpu_workqueue_struct *cwq,
-			struct work_struct *work, struct list_head *head)
+/*
+ * Policy functions.  The following functions defines the policies on
+ * how the global worker pool is managed.  Unless noted otherwise,
+ * these functions assume that they're being called with gcwq->lock
+ * held.
+ */
+
+/* Do we need a new worker?  Called from manager. */
+static bool need_new_worker(struct global_cwq *gcwq)
+{
+	return !list_empty(&gcwq->worklist) && !gcwq->nr_idle;
+}
+
+/* Do we have too many workers and some should go away? */
+static bool too_many_workers(struct global_cwq *gcwq)
+{
+	bool managing = gcwq->flags & GCWQ_MANAGING_WORKERS;
+	int nr_idle = gcwq->nr_idle + managing; /* manager is considered idle */
+	int nr_busy = gcwq->nr_workers - nr_idle;
+
+	return nr_idle > 1 && (nr_idle - 1) * MAX_IDLE_WORKERS_RATIO >= nr_busy;
+}
+
+/* Do I need to be the manager?  Called from manager candidates. */
+static bool need_to_manage_workers(struct global_cwq *gcwq)
+{
+	return (need_new_worker(gcwq) || gcwq->flags & GCWQ_MANAGE_WORKERS) &&
+		!(gcwq->flags & GCWQ_MANAGING_WORKERS);
+}
+
+/*
+ * Does a worker need to keep working?  Called from workers, scheduler
+ * callbacks or someone queueing a work.  @max_running determines how
+ * many concurrent workers are allowed.
+ */
+static bool worker_keep_busy(struct global_cwq *gcwq, int max_running)
+{
+	/* keep busy if there's work and nothing else is running */
+	return !list_empty(&gcwq->worklist) && gcwq->nr_running <= max_running;
+}
+
+/*
+ * Wake up functions.
+ */
+
+/* Return the first worker.  Safe with preemption disabled */
+static struct worker *first_worker(struct global_cwq *gcwq)
+{
+	if (unlikely(list_empty(&gcwq->idle_list)))
+		return NULL;
+
+	return list_first_entry(&gcwq->idle_list, struct worker, entry);
+}
+
+/**
+ * wake_up_worker - wake up an idle worker
+ * @gcwq: gcwq to wake worker for
+ *
+ * Wake the first idle worker of @gcwq.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock).
+ */
+static void wake_up_worker(struct global_cwq *gcwq)
+{
+	struct worker *worker = first_worker(gcwq);
+
+	if (likely(worker))
+		wake_up_process(worker->task);
+}
+
+/**
+ * sched_wake_up_worker - wake up an idle worker
+ * @gcwq: gcwq to wake worker for
+ *
+ * Wake the first idle worker of @gcwq.
+ *
+ * CONTEXT:
+ * Scheduler callback.  DO NOT call from anywhere else.
+ */
+static void sched_wake_up_worker(struct global_cwq *gcwq)
+{
+	struct worker *worker = first_worker(gcwq);
+
+	if (likely(worker))
+		sched_workqueue_wake_up_process(worker->task);
+}
+
+/*
+ * Scheduler callbacks.  These functions are called during schedule()
+ * with rq lock held.  Don't try to acquire any lock and only access
+ * fields which are safe with preemption disabled from local cpu.
+ */
+
+/* called when a worker task @task wakes up from sleep */
+void sched_workqueue_worker_wakeup(struct task_struct *task)
+{
+	struct worker *worker = kthread_data(task);
+	struct global_cwq *gcwq = worker->gcwq;
+
+	if (unlikely(worker->state & (WORKER_STA_IDLE | WORKER_STA_ROGUE)))
+		return;
+
+	if (likely(!(worker->state & WORKER_STA_RUNNING))) {
+		worker->state |= WORKER_STA_RUNNING;
+		gcwq->nr_running++;
+	}
+}
+
+/* called when a worker task @task goes into sleep */
+void sched_workqueue_worker_sleep(struct task_struct *task)
+{
+	struct worker *worker = kthread_data(task);
+	struct global_cwq *gcwq = worker->gcwq;
+
+	if (unlikely(worker->state & (WORKER_STA_IDLE | WORKER_STA_ROGUE)))
+		return;
+
+	if (likely(worker->state & WORKER_STA_RUNNING)) {
+		worker->state &= ~WORKER_STA_RUNNING;
+		gcwq->nr_running--;
+	}
+
+	if (worker_keep_busy(gcwq, 0))
+		sched_wake_up_worker(gcwq);
+}
+
+/* called when a worker task @task gets preempted */
+void sched_workqueue_worker_preempted(struct task_struct *task)
+{
+	struct worker *worker = kthread_data(task);
+	struct global_cwq *gcwq = worker->gcwq;
+
+	if (unlikely(worker->state & (WORKER_STA_IDLE | WORKER_STA_ROGUE)))
+		return;
+
+	/*
+	 * We're gonna be scheduled out but still accounted as
+	 * running.  Call worker_keep_busy() with @max_running of 1.
+	 * This will allow one extra worker to be scheduled on
+	 * preemption so that one cpu hog doesn't stall the whole
+	 * queue.  I'm not sure whether this is a worthy optimization
+	 * yet.  Maybe we're better off with just bumping up the
+	 * priority of workers.
+	 */
+	if (worker_keep_busy(gcwq, 1))
+		sched_wake_up_worker(gcwq);
+}
+
+/**
+ * busy_worker_head - return the busy hash head for a work
+ * @gcwq: gcwq of interest
+ * @work: work to be hashed
+ *
+ * Return hash head of @gcwq for @work.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock).
+ *
+ * RETURNS:
+ * Pointer to the hash head.
+ */
+static struct hlist_head *busy_worker_head(struct global_cwq *gcwq,
+					   struct work_struct *work)
+{
+	const int base_shift = ilog2(sizeof(struct work_struct));
+	unsigned long v = (unsigned long)work;
+
+	v >>= base_shift;
+	v += v >> BUSY_WORKER_HASH_ORDER;
+	v &= BUSY_WORKER_HASH_MASK;
+
+	return &gcwq->busy_hash[v];
+}
+
+/**
+ * __find_worker_executing_work - find worker which is executing a work
+ * @gcwq: gcwq of interest
+ * @bwh: hash head as returned by busy_worker_head()
+ * @work: work to find worker for
+ *
+ * Find a worker which is executing @work on @gcwq.  @bwh should be
+ * the hash head obtained by calling busy_worker_head() with the same
+ * work.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock).
+ *
+ * RETURNS:
+ * Pointer to worker which is executing @work if found, NULL
+ * otherwise.
+ */
+static struct worker *__find_worker_executing_work(struct global_cwq *gcwq,
+						   struct hlist_head *bwh,
+						   struct work_struct *work)
+{
+	struct worker *worker;
+	struct hlist_node *tmp;
+
+	hlist_for_each_entry(worker, tmp, bwh, hentry)
+		if (worker->current_work == work)
+			return worker;
+	return NULL;
+}
+
+/**
+ * find_worker_executing_work - find worker which is executing a work
+ * @gcwq: gcwq of interest
+ * @work: work to find worker for
+ *
+ * Find a worker which is executing @work on @gcwq.  This function is
+ * identical to __find_worker_executing_work() except that this
+ * function calculates @bwh itself.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock).
+ *
+ * RETURNS:
+ * Pointer to worker which is executing @work if found, NULL
+ * otherwise.
+ */
+static struct worker *find_worker_executing_work(struct global_cwq *gcwq,
+						 struct work_struct *work)
 {
-	trace_workqueue_insertion(cwq->thread, work);
+	return __find_worker_executing_work(gcwq, busy_worker_head(gcwq, work),
+					    work);
+}
+
+/**
+ * insert_work - insert a work into gcwq
+ * @gcwq: target gcwq
+ * @cwq: cwq @work belongs to
+ * @work: work to insert
+ * @head: insertion point
+ * @extra_flags: extra WORK_STRUCT_* flags to set
+ *
+ * Insert @work which belongs to @cwq into @gcwq after @head.
+ * @extra_flags is ORd to WORK_STRUCT flags.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock).
+ */
+static void insert_work(struct global_cwq *gcwq,
+			struct cpu_workqueue_struct *cwq,
+			struct work_struct *work, struct list_head *head,
+			unsigned int extra_flags)
+{
+	cwq->nr_in_flight++;
+
+	/* we own @work, set data and link */
+	set_wq_data(work, cwq,
+		    WORK_STRUCT_PENDING | cwq->flush_color | extra_flags);

-	set_wq_data(work, cwq);
 	/*
 	 * Ensure that we get the right work->data if we see the
 	 * result of list_add() below, see try_to_grab_pending().
 	 */
 	smp_wmb();
 	list_add_tail(&work->entry, head);
-	wake_up(&cwq->more_work);
+
+	if (worker_keep_busy(gcwq, 0))
+		wake_up_worker(gcwq);
 }

-static void __queue_work(struct cpu_workqueue_struct *cwq,
+static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
+	struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+	struct global_cwq *gcwq = cwq->gcwq;
 	unsigned long flags;

-	spin_lock_irqsave(&cwq->lock, flags);
-	insert_work(cwq, work, &cwq->worklist);
-	spin_unlock_irqrestore(&cwq->lock, flags);
+	spin_lock_irqsave(&gcwq->lock, flags);
+	BUG_ON(!list_empty(&work->entry));
+	insert_work(gcwq, cwq, work, &gcwq->worklist, 0);
+	spin_unlock_irqrestore(&gcwq->lock, flags);
 }

 /**
@@ -187,9 +535,8 @@ queue_work_on(int cpu, struct workqueue_
 {
 	int ret = 0;

-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
-		BUG_ON(!list_empty(&work->entry));
-		__queue_work(wq_per_cpu(wq, cpu), work);
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
+		__queue_work(cpu, wq, work);
 		ret = 1;
 	}
 	return ret;
@@ -200,9 +547,8 @@ static void delayed_work_timer_fn(unsign
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
 	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
-	struct workqueue_struct *wq = cwq->wq;

-	__queue_work(wq_per_cpu(wq, smp_processor_id()), &dwork->work);
+	__queue_work(smp_processor_id(), cwq->wq, &dwork->work);
 }

 /**
@@ -239,14 +585,15 @@ int queue_delayed_work_on(int cpu, struc
 	struct timer_list *timer = &dwork->timer;
 	struct work_struct *work = &dwork->work;

-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));

 		timer_stats_timer_set_start_info(&dwork->timer);

 		/* This stores cwq for the moment, for the timer_fn */
-		set_wq_data(work, wq_per_cpu(wq, raw_smp_processor_id()));
+		set_wq_data(work, get_cwq(raw_smp_processor_id(), wq),
+			    WORK_STRUCT_PENDING);
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
@@ -261,123 +608,560 @@ int queue_delayed_work_on(int cpu, struc
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);

-static void run_workqueue(struct cpu_workqueue_struct *cwq)
+/**
+ * worker_enter_idle - enter idle state
+ * @gcwq: gcwq worker belongs to
+ * @worker: worker which is entering idle state
+ *
+ * @worker is entering idle state.  Update stats and idle timer if
+ * necessary.
+ *
+ * LOCKING:
+ * spin_lock_irq(gcwq->lock).
+ */
+static void worker_enter_idle(struct global_cwq *gcwq, struct worker *worker)
 {
-	spin_lock_irq(&cwq->lock);
-	while (!list_empty(&cwq->worklist)) {
-		struct work_struct *work = list_entry(cwq->worklist.next,
-						struct work_struct, entry);
-		work_func_t f = work->func;
-#ifdef CONFIG_LOCKDEP
-		/*
-		 * It is permissible to free the struct work_struct
-		 * from inside the function that is called from it,
-		 * this we need to take into account for lockdep too.
-		 * To avoid bogus "held lock freed" warnings as well
-		 * as problems when looking into work->lockdep_map,
-		 * make a copy and use that here.
-		 */
-		struct lockdep_map lockdep_map = work->lockdep_map;
-#endif
-		trace_workqueue_execution(cwq->thread, work);
-		cwq->current_work = work;
-		list_del_init(cwq->worklist.next);
-		spin_unlock_irq(&cwq->lock);
+	BUG_ON(worker->state & WORKER_STA_IDLE);
+	BUG_ON(!list_empty(&worker->entry));
+
+	if (worker->state & WORKER_STA_RUNNING) {
+		worker->state &= ~WORKER_STA_RUNNING;
+		gcwq->nr_running--;
+	}
+
+	worker->state |= WORKER_STA_IDLE;
+	gcwq->nr_idle++;
+	worker->last_active = jiffies;
+
+	/* idle_list is LIFO */
+	list_add(&worker->entry, &gcwq->idle_list);
+
+	if (likely(!(worker->state & WORKER_STA_ROGUE))) {
+		if (too_many_workers(gcwq) && !timer_pending(&gcwq->idle_timer))
+			mod_timer(&gcwq->idle_timer,
+				  jiffies + IDLE_WORKER_TIMEOUT);
+	} else
+		wake_up_all(&gcwq->trustee_wait);
+}
+
+/**
+ * worker_leave_idle - leave idle state
+ * @gcwq: gcwq worker belongs to
+ * @worker: worker which is leaving idle state
+ *
+ * @worker is leaving idle state.  Update stats.
+ *
+ * LOCKING:
+ * spin_lock_irq(gcwq->lock).
+ */
+static void worker_leave_idle(struct global_cwq *gcwq, struct worker *worker)
+{
+	BUG_ON(!(worker->state & WORKER_STA_IDLE));
+	worker->state &= ~WORKER_STA_IDLE;
+	gcwq->nr_idle--;
+
+	if (likely(!(worker->state & WORKER_STA_ROGUE))) {
+		worker->state |= WORKER_STA_RUNNING;
+		gcwq->nr_running++;
+	}
+
+	list_del_init(&worker->entry);
+}
+
+static struct worker *alloc_worker(void)
+{
+	struct worker *worker;
+
+	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
+	if (!worker)
+		return NULL;
+
+	INIT_LIST_HEAD(&worker->entry);
+	INIT_LIST_HEAD(&worker->scheduled);
+	/* on creation a worker is not idle */
+	return worker;
+}
+
+/**
+ * create_worker - create a new workqueue worker
+ * @gcwq: gcwq the new worker will belong to
+ * @bind: whether to set affinity to @cpu or not
+ *
+ * Create a new worker which is bound to @gcwq.  Please note that this
+ * function doesn't adjust any stats.  Attaching it to its gcwq is the
+ * caller's responsibility.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock) which is released and regrabbed.  Does
+ * GFP_KERNEL allocations.
+ *
+ * RETURNS:
+ * Pointer to the newly created worker
+ */
+static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
+{
+	struct worker *worker;
+
+	spin_unlock_irq(&gcwq->lock);
+
+	worker = alloc_worker();
+	if (!worker)
+		return NULL;
+
+	worker->gcwq = gcwq;
+
+	worker->task = kthread_create(worker_thread, worker, "kworker/%u",
+				      gcwq->cpu);
+	if (IS_ERR(worker->task)) {
+		kfree(worker);
+		return NULL;
+	}
+
+	if (bind)
+		kthread_bind(worker->task, gcwq->cpu);
+
+	spin_lock_irq(&gcwq->lock);
+	gcwq->nr_workers++;
+	worker_enter_idle(gcwq, worker);
+
+	return worker;
+}
+
+static bool send_mayday(struct work_struct *work)
+{
+	struct cpu_workqueue_struct *cwq = get_wq_data(work);
+	struct workqueue_struct *wq = cwq->wq;
+
+	if (!(wq->flags & WQ_EMERGENCY_WORKER))
+		return false;
+
+	/* mayday mayday mayday */
+	if (!cpumask_test_and_set_cpu(cwq->gcwq->cpu, wq->mayday_mask))
+		wake_up_process(wq->emergency->task);
+	return true;
+}

-		BUG_ON(get_wq_data(work) != cwq);
-		work_clear_pending(work);
-		lock_map_acquire(&cwq->wq->lockdep_map);
-		lock_map_acquire(&lockdep_map);
-		f(work);
-		lock_map_release(&lockdep_map);
-		lock_map_release(&cwq->wq->lockdep_map);
+/**
+ * destroy_worker - destroy a workqueue worker
+ * @worker: worker to be destroyed
+ *
+ * Destroy @worker and adjust @gcwq stats accordingly.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock) which is released and regrabbed.
+ */
+static void destroy_worker(struct worker *worker)
+{
+	struct global_cwq *gcwq = worker->gcwq;
+
+	/* sanity check frenzy */
+	BUG_ON(worker->current_work);
+	BUG_ON(!list_empty(&worker->scheduled));
+	BUG_ON(!(worker->state & WORKER_STA_IDLE));
+	BUG_ON(worker->state & WORKER_STA_RUNNING);
+	BUG_ON(worker->req_flags);
+
+	gcwq->nr_workers--;
+	gcwq->nr_idle--;
+	list_del_init(&worker->entry);
+	worker->req_flags |= WORKER_REQ_DIE;
+
+	spin_unlock_irq(&gcwq->lock);
+
+	kthread_stop(worker->task);
+	kfree(worker);
+
+	spin_lock_irq(&gcwq->lock);
+}
+
+static void idle_worker_timeout(unsigned long __gcwq)
+{
+	struct global_cwq *gcwq = (void *)__gcwq;
+
+	spin_lock_irq(&gcwq->lock);
+
+	if (too_many_workers(gcwq)) {
+		struct worker *worker;
+		unsigned long expires;

-		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
-			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
-					"%s/0x%08x/%d\n",
-					current->comm, preempt_count(),
-				       	task_pid_nr(current));
-			printk(KERN_ERR "    last function: ");
-			print_symbol("%s\n", (unsigned long)f);
-			debug_show_held_locks(current);
-			dump_stack();
+		/* idle_list is kept in LIFO order, check the last one */
+		worker = list_entry(gcwq->idle_list.prev, struct worker, entry);
+		expires = worker->last_active + IDLE_WORKER_TIMEOUT;
+
+		if (time_before(jiffies, expires))
+			mod_timer(&gcwq->idle_timer, expires);
+		else {
+			/* it's been idle for too long, wake up manager */
+			gcwq->flags |= GCWQ_MANAGE_WORKERS;
+			wake_up_worker(gcwq);
 		}
+	}
+
+	spin_unlock_irq(&gcwq->lock);
+}

-		spin_lock_irq(&cwq->lock);
-		cwq->current_work = NULL;
+static void gcwq_mayday_timeout(unsigned long __gcwq)
+{
+	struct global_cwq *gcwq = (void *)__gcwq;
+	struct work_struct *work;
+
+	spin_lock_irq(&gcwq->lock);
+
+	if (need_new_worker(gcwq)) {
+		/*
+		 * We've been trying to create a new worker but
+		 * haven't been successful for more than
+		 * MAYDAY_INTERVAL.  We might be hitting an allocation
+		 * deadlock.  Send distress calls to emergency
+		 * workers.
+		 */
+		list_for_each_entry(work, &gcwq->worklist, entry)
+			send_mayday(work);
 	}
-	spin_unlock_irq(&cwq->lock);
+
+	spin_unlock_irq(&gcwq->lock);
+
+	mod_timer(&gcwq->mayday_timer, jiffies + MAYDAY_INTERVAL);
 }

-static int worker_thread(void *__cwq)
+/**
+ * maybe_create_worker - create a new worker if necessary
+ * @gcwq: gcwq to create a new worker for
+ *
+ * Create a new worker for @gcwq if necessary.  @gcwq is guaranteed to
+ * have at least one idle worker on return from this function.  If
+ * creating a new worker takes longer than MAYDAY_INTERVAL, mayday is
+ * sent to all emergency workers with works scheduled on @gcwq to
+ * resolve possible allocation deadlock.
+ *
+ * LOCKING:
+ * spin_lock_irq(gcwq->lock) which may be released and regrabbed
+ * multiple times.
+ */
+static void maybe_create_worker(struct global_cwq *gcwq)
 {
-	struct cpu_workqueue_struct *cwq = __cwq;
-	DEFINE_WAIT(wait);
+	if (!need_new_worker(gcwq))
+		return;

-	if (cwq->wq->freezeable)
-		set_freezable();
+	/* if we don't make any progress in MAYDAY_INTERVAL, call for help */
+	mod_timer(&gcwq->mayday_timer, jiffies + MAYDAY_INTERVAL);

-	set_user_nice(current, -5);
+	do {
+		if (gcwq->nr_workers >= MAX_WORKERS_PER_CPU) {
+			if (printk_ratelimit())
+				printk(KERN_WARNING "workqueue: too many "
+				       "workers (%d) on cpu %d, can't create "
+				       "new ones\n",
+				       gcwq->nr_workers, gcwq->cpu);
+			goto cooldown;
+		}
+
+		if (create_worker(gcwq, true)) {
+			BUG_ON(need_new_worker(gcwq));
+			break;
+		}

-	for (;;) {
-		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
-		if (!freezing(current) &&
-		    !kthread_should_stop() &&
-		    list_empty(&cwq->worklist))
-			schedule();
-		finish_wait(&cwq->more_work, &wait);
+		if (!need_new_worker(gcwq))
+			break;
+	cooldown:
+		spin_unlock_irq(&gcwq->lock);
+		schedule_timeout(CREATE_COOLDOWN);
+		spin_lock_irq(&gcwq->lock);
+	} while (need_new_worker(gcwq));

-		try_to_freeze();
+	del_timer_sync(&gcwq->mayday_timer);
+}

-		if (kthread_should_stop())
+/**
+ * maybe_destroy_worker - destroy workers which have been idle for a while
+ * @gcwq: gcwq to destroy workers for
+ *
+ * Destroy @gcwq workers which have been idle for longer than
+ * IDLE_WORKER_TIMEOUT.
+ *
+ * LOCKING:
+ * spin_lock_irq(gcwq->lock) which may be released and regrabbed
+ * multiple times.
+ */
+static void maybe_destroy_workers(struct global_cwq *gcwq)
+{
+	while (too_many_workers(gcwq)) {
+		struct worker *worker;
+		unsigned long expires;
+
+		worker = list_entry(gcwq->idle_list.prev, struct worker, entry);
+		expires = worker->last_active + IDLE_WORKER_TIMEOUT;
+
+		if (time_before(jiffies, expires)) {
+			mod_timer(&gcwq->idle_timer, expires);
 			break;
+		}

-		run_workqueue(cwq);
+		destroy_worker(worker);
 	}
-
-	return 0;
 }

-struct wq_barrier {
-	struct work_struct	work;
-	struct completion	done;
-};
+static void manage_workers(struct global_cwq *gcwq)
+{
+	BUG_ON(gcwq->flags & GCWQ_MANAGING_WORKERS);

-static void wq_barrier_func(struct work_struct *work)
+	gcwq->flags &= ~GCWQ_MANAGE_WORKERS;
+	gcwq->flags |= GCWQ_MANAGING_WORKERS;
+
+	/*
+	 * Destroy and then create so that one idle worker is
+	 * guaranteed on return.
+	 */
+	maybe_destroy_workers(gcwq);
+	maybe_create_worker(gcwq);
+
+	gcwq->flags &= ~GCWQ_MANAGING_WORKERS;
+
+	if (unlikely(gcwq->trustee))
+		wake_up_all(&gcwq->trustee_wait);
+}
+
+static void schedule_work_to_worker(struct global_cwq *gcwq,
+				    struct worker *worker,
+				    struct work_struct *work,
+				    struct work_struct **nextp)
 {
-	struct wq_barrier *barr = container_of(work, struct wq_barrier, work);
-	complete(&barr->done);
+	struct work_struct *n;
+
+ 	list_for_each_entry_safe_continue(work, n, &gcwq->worklist, entry) {
+		list_move_tail(&work->entry, &worker->scheduled);
+		if (!(*work_data_bits(work) & WORK_STRUCT_LINKED)) {
+			work = n;
+			break;
+		}
+	}
+
+	/*
+	 * If we're already inside safe list traversal and have moved
+	 * multiple works to the scheduled queue, the next position
+	 * needs to be updated.
+	 */
+	if (nextp)
+		*nextp = work;
 }

-static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
-			struct wq_barrier *barr, struct list_head *head)
+static void process_one_work(struct worker *worker, struct work_struct *work)
 {
-	INIT_WORK(&barr->work, wq_barrier_func);
-	__set_bit(WORK_STRUCT_PENDING, work_data_bits(&barr->work));
+	struct cpu_workqueue_struct *cwq = get_wq_data(work);
+	struct global_cwq *gcwq = cwq->gcwq;
+	struct hlist_head *bwh = busy_worker_head(gcwq, work);
+	work_func_t f = work->func;
+	unsigned int work_color;
+	struct worker *collision;
+#ifdef CONFIG_LOCKDEP
+	/*
+	 * It is permissible to free the struct work_struct
+	 * from inside the function that is called from it,
+	 * this we need to take into account for lockdep too.
+	 * To avoid bogus "held lock freed" warnings as well
+	 * as problems when looking into work->lockdep_map,
+	 * make a copy and use that here.
+	 */
+	struct lockdep_map lockdep_map = work->lockdep_map;
+#endif
+	/*
+	 * A single work shouldn't be executed concurrently by
+	 * multiple workers on a single cpu.  Check whether anyone is
+	 * already processing the work.  If so, defer the work to the
+	 * currently executing one.
+	 */
+	collision = __find_worker_executing_work(gcwq, bwh, work);
+	if (unlikely(collision)) {
+		schedule_work_to_worker(gcwq, collision, work, NULL);
+		return;
+	}

-	init_completion(&barr->done);
+	/* claim and process */
+	hlist_add_head(&worker->hentry, bwh);
+	worker->current_work = work;
+	work_color = *work_data_bits(work) & WORK_STRUCT_COLOR;
+	list_del_init(&work->entry);
+
+	spin_unlock_irq(&gcwq->lock);

-	insert_work(cwq, &barr->work, head);
+	work_clear_pending(work);
+	lock_map_acquire(&cwq->wq->lockdep_map);
+	lock_map_acquire(&lockdep_map);
+	f(work);
+	lock_map_release(&lockdep_map);
+	lock_map_release(&cwq->wq->lockdep_map);
+
+	if (unlikely(in_atomic()) || lockdep_depth(current) > 0) {
+		printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
+		       "%s/0x%08x/%d\n",
+		       current->comm, preempt_count(),
+		       task_pid_nr(current));
+		printk(KERN_ERR "    last function: ");
+		print_symbol("%s\n", (unsigned long)f);
+		debug_show_held_locks(current);
+		dump_stack();
+	}
+
+	spin_lock_irq(&gcwq->lock);
+
+	/* we're done with it, release */
+	hlist_del_init(&worker->hentry);
+	worker->current_work = NULL;
+	cwq->nr_in_flight--;
+
+	if (unlikely(cwq->flush_cnt)) {
+		if (work_color ^ cwq->flush_color && !--cwq->flush_cnt &&
+		    atomic_dec_and_test(&cwq->wq->nr_cwqs_to_flush))
+			complete(cwq->wq->flush_done);
+	}
 }

-static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
+static void process_scheduled_works(struct global_cwq *gcwq,
+				    struct worker *worker)
 {
-	int active = 0;
-	struct wq_barrier barr;
+	while (!list_empty(&worker->scheduled)) {
+		struct work_struct *work = list_first_entry(&worker->scheduled,
+						struct work_struct, entry);
+		process_one_work(worker, work);
+	}
+}
+
+/**
+ * worker_thread - the worker thread function
+ * @__worker: self
+ *
+ * The gcwq worker thread function.  There's a single dynamic pool of
+ * these per each cpu.  These workers process all works regardless of
+ * their specific target workqueue.  The only exception is works which
+ * are issued to workqueues with an attached emergency worker which
+ * will be explained in emergency_thread().
+ */
+static int worker_thread(void *__worker)
+{
+	struct worker *worker = worker;
+	struct global_cwq *gcwq = worker->gcwq;
+	struct sched_param sched_param = { .sched_priority = 0 };
+
+	/* set workqueue scheduler */
+	worker->task->flags |= PF_WORKQUEUE;
+	sched_setscheduler_nocheck(worker->task, SCHED_NORMAL, &sched_param);
+
+	set_user_nice(current, WORKER_NICE_LEVEL);
+woke_up:
+	spin_lock_irq(&gcwq->lock);
+
+	/* DIE can be set only while we're idle, checking here is enough */
+	if (worker->req_flags & WORKER_REQ_DIE) {
+		spin_unlock_irq(&gcwq->lock);
+		return 0;
+	}
+
+	worker_leave_idle(gcwq, worker);
+repeat:
+	/*
+	 * We just left idle.  The first thing to do is making sure
+	 * the worker pool has at least one idle worker.  Play the
+	 * manager if necessary.
+	 */
+	if (unlikely(need_to_manage_workers(gcwq)))
+		manage_workers(gcwq);
+
+	/*
+	 * When control reaches this point, we're guaranteed to have
+	 * at least one idle worker or that someone else has already
+	 * assumed the manager role.
+	 */
+	while (worker_keep_busy(gcwq, 1)) {
+		struct work_struct *work = list_first_entry(&gcwq->worklist,
+						struct work_struct, entry);

-	WARN_ON(cwq->thread == current);
+		if (likely(!(*work_data_bits(work) & WORK_STRUCT_LINKED))) {
+			/* optimization path, not strictly necessary */
+			BUG_ON(!list_empty(&worker->scheduled));
+			process_one_work(worker, work);
+		} else
+			schedule_work_to_worker(gcwq, worker, work, NULL);
+
+		if (unlikely(!list_empty(&worker->scheduled)))
+			process_scheduled_works(gcwq, worker);

-	spin_lock_irq(&cwq->lock);
-	if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
-		insert_wq_barrier(cwq, &barr, &cwq->worklist);
-		active = 1;
 	}
-	spin_unlock_irq(&cwq->lock);

-	if (active)
-		wait_for_completion(&barr.done);
+	/* this might have changed while we were running works */
+	if (unlikely(need_to_manage_workers(gcwq)))
+		goto repeat;
+
+	/*
+	 * gcwq->lock is held and there's no work to process and no
+	 * need to manage, sleep.  Workers are woken up only while
+	 * holding gcwq->lock or from local cpu, so setting the
+	 * current state before releasing gcwq->lock is enough to
+	 * prevent losing any event.
+	 */
+	worker_enter_idle(gcwq, worker);
+	__set_current_state(TASK_INTERRUPTIBLE);
+	spin_unlock_irq(&gcwq->lock);
+	schedule();
+	goto woke_up;
+}
+
+/**
+ * emergency_thread - the emergency worker thread function
+ * @__wq: the associated workqueue
+ *
+ * Workqueue emergency worker thread function.  There's one emergency
+ * thread for each workqueue which has WQ_EMERGENCY_WORKER set.
+ *
+ * Regular work processing on a gcwq may block trying to create a new
+ * worker which depends on GFP_KERNEL allocation which has slight
+ * chance of developing into deadlock if some works currently on the
+ * same queue need to be processed to finish the GFP_KERNEL
+ * allocation.  This is the problem emergency worker solves.
+ *
+ * When such condition is possible, the gcwq summons emergency workers
+ * of all workqueues which have works queued on the gcwq and let them
+ * process those works so that allocation can succeed and forward
+ * progress can be guaranteed.
+ *
+ * This should happen *VERY* rarely.
+ */
+static int emergency_thread(void *__wq)
+{
+	struct workqueue_struct *wq = __wq;
+	struct worker *worker = wq->emergency;
+	unsigned int cpu;

-	return active;
+	set_user_nice(current, EMERGENCY_NICE_LEVEL);
+repeat:
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	if (kthread_should_stop())
+		return 0;
+
+	for_each_cpu(cpu, wq->mayday_mask) {
+		struct global_cwq *gcwq = get_gcwq(cpu);
+		struct work_struct *work, *n;
+
+		__set_current_state(TASK_RUNNING);
+		cpumask_clear_cpu(cpu, wq->mayday_mask);
+
+		spin_lock_irq(&gcwq->lock);
+
+		/* don't matter for emergency workers but set them anyway */
+		worker->state = WORKER_STA_RUNNING;
+
+		/* slurp in all works issued via this workqueue */
+		list_for_each_entry_safe(work, n, &gcwq->worklist, entry)
+			schedule_work_to_worker(gcwq, worker, work, &n);
+
+		process_scheduled_works(gcwq, worker);
+
+		worker->state = WORKER_STA_IDLE;
+		spin_unlock_irq(&gcwq->lock);
+	}
+
+	schedule();
+	goto repeat;
 }

 /**
@@ -395,17 +1179,98 @@ static int flush_cpu_workqueue(struct cp
  */
 void flush_workqueue(struct workqueue_struct *wq)
 {
-	const struct cpumask *cpu_map = wq_cpu_map(wq);
-	int cpu;
+	DECLARE_COMPLETION_ONSTACK(flush_done);
+	bool wait = false;
+	unsigned int cpu;

-	might_sleep();
 	lock_map_acquire(&wq->lockdep_map);
 	lock_map_release(&wq->lockdep_map);
-	for_each_cpu(cpu, cpu_map)
-		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
+
+	/* only single flush can be in progress at any given time */
+	mutex_lock(&wq->flush_mutex);
+
+	BUG_ON(atomic_read(&wq->nr_cwqs_to_flush) || wq->flush_done);
+
+	wq->flush_done = &flush_done;
+
+	for_each_possible_cpu(cpu) {
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		struct global_cwq *gcwq = cwq->gcwq;
+
+		spin_lock_irq(&gcwq->lock);
+
+		BUG_ON(cwq->flush_cnt);
+
+		cwq->flush_color ^= WORK_STRUCT_COLOR;
+		cwq->flush_cnt = cwq->nr_in_flight;
+
+		if (cwq->flush_cnt) {
+			atomic_inc(&wq->nr_cwqs_to_flush);
+			wait = true;
+		}
+
+		spin_unlock_irq(&gcwq->lock);
+	}
+
+	if (wait)
+		wait_for_completion(&flush_done);
+
+	wq->flush_done = NULL;
+
+	mutex_unlock(&wq->flush_mutex);
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);

+struct wq_barrier {
+	struct work_struct	work;
+	struct completion	done;
+};
+
+static void wq_barrier_func(struct work_struct *work)
+{
+	struct wq_barrier *barr = container_of(work, struct wq_barrier, work);
+	complete(&barr->done);
+}
+
+/**
+ * insert_wq_barrier - insert a barrier work
+ * @barr: wq_barrier to insert
+ * @target: target work to attach @barr to
+ * @worker: worker currently executing @target, NULL if @target is not executing
+ *
+ * @barr is linked to @target such that @barr is completed only after
+ * @target finishes execution.  Please note that the ordering
+ * guarantee is observed only with respect to @target and on the local
+ * cpu.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock).
+ */
+static void insert_wq_barrier(struct wq_barrier *barr,
+			      struct work_struct *target, struct worker *worker)
+{
+	struct cpu_workqueue_struct *cwq = get_wq_data(target);
+	struct list_head *head;
+	unsigned int linked = 0;
+
+	INIT_WORK(&barr->work, wq_barrier_func);
+	init_completion(&barr->done);
+
+	/*
+	 * If @target is currently being executed, schedule the
+	 * barrier to the worker; otherwise, put it after @target.
+	 */
+	if (worker)
+		head = &worker->scheduled;
+	else {
+		head = target->entry.next;
+		/* there can already be other linked works, inherit the flag */
+		linked = *work_data_bits(target) & WORK_STRUCT_LINKED;
+	}
+
+	insert_work(cwq->gcwq, cwq, &barr->work, head, linked);
+}
+
 /**
  * flush_work - block until a work_struct's callback has terminated
  * @work: the work which is to be flushed
@@ -418,20 +1283,21 @@ EXPORT_SYMBOL_GPL(flush_workqueue);
  */
 int flush_work(struct work_struct *work)
 {
+	struct worker *worker = NULL;
 	struct cpu_workqueue_struct *cwq;
-	struct list_head *prev;
+	struct global_cwq *gcwq;
 	struct wq_barrier barr;

 	might_sleep();
 	cwq = get_wq_data(work);
 	if (!cwq)
 		return 0;
+	gcwq = cwq->gcwq;

 	lock_map_acquire(&cwq->wq->lockdep_map);
 	lock_map_release(&cwq->wq->lockdep_map);

-	prev = NULL;
-	spin_lock_irq(&cwq->lock);
+	spin_lock_irq(&gcwq->lock);
 	if (!list_empty(&work->entry)) {
 		/*
 		 * See the comment near try_to_grab_pending()->smp_rmb().
@@ -439,21 +1305,20 @@ int flush_work(struct work_struct *work)
 		 */
 		smp_rmb();
 		if (unlikely(cwq != get_wq_data(work)))
-			goto out;
-		prev = &work->entry;
+			goto already_gone;
 	} else {
-		if (cwq->current_work != work)
-			goto out;
-		prev = &cwq->worklist;
-	}
-	insert_wq_barrier(cwq, &barr, prev->next);
-out:
-	spin_unlock_irq(&cwq->lock);
-	if (!prev)
-		return 0;
+		worker = find_worker_executing_work(gcwq, work);
+		if (!worker)
+			goto already_gone;
+	}

+	insert_wq_barrier(&barr, work, worker);
+	spin_unlock_irq(&gcwq->lock);
 	wait_for_completion(&barr.done);
 	return 1;
+already_gone:
+	spin_unlock_irq(&gcwq->lock);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(flush_work);

@@ -463,10 +1328,11 @@ EXPORT_SYMBOL_GPL(flush_work);
  */
 static int try_to_grab_pending(struct work_struct *work)
 {
+	struct global_cwq *gcwq;
 	struct cpu_workqueue_struct *cwq;
 	int ret = -1;

-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work)))
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work)))
 		return 0;

 	/*
@@ -477,8 +1343,9 @@ static int try_to_grab_pending(struct wo
 	cwq = get_wq_data(work);
 	if (!cwq)
 		return ret;
+	gcwq = cwq->gcwq;

-	spin_lock_irq(&cwq->lock);
+	spin_lock_irq(&gcwq->lock);
 	if (!list_empty(&work->entry)) {
 		/*
 		 * This work is queued, but perhaps we locked the wrong cwq.
@@ -491,7 +1358,7 @@ static int try_to_grab_pending(struct wo
 			ret = 1;
 		}
 	}
-	spin_unlock_irq(&cwq->lock);
+	spin_unlock_irq(&gcwq->lock);

 	return ret;
 }
@@ -499,17 +1366,19 @@ static int try_to_grab_pending(struct wo
 static void wait_on_cpu_work(struct cpu_workqueue_struct *cwq,
 				struct work_struct *work)
 {
+	struct global_cwq *gcwq = cwq->gcwq;
 	struct wq_barrier barr;
-	int running = 0;
+	struct worker *worker;

-	spin_lock_irq(&cwq->lock);
-	if (unlikely(cwq->current_work == work)) {
-		insert_wq_barrier(cwq, &barr, cwq->worklist.next);
-		running = 1;
-	}
-	spin_unlock_irq(&cwq->lock);
+	spin_lock_irq(&gcwq->lock);
+
+	worker = find_worker_executing_work(gcwq, work);
+	if (unlikely(worker))
+		insert_wq_barrier(&barr, work, worker);

-	if (unlikely(running))
+	spin_unlock_irq(&gcwq->lock);
+
+	if (unlikely(worker))
 		wait_for_completion(&barr.done);
 }

@@ -517,7 +1386,6 @@ static void wait_on_work(struct work_str
 {
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
-	const struct cpumask *cpu_map;
 	int cpu;

 	might_sleep();
@@ -530,10 +1398,9 @@ static void wait_on_work(struct work_str
 		return;

 	wq = cwq->wq;
-	cpu_map = wq_cpu_map(wq);

-	for_each_cpu(cpu, cpu_map)
-		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
+	for_each_possible_cpu(cpu)
+		wait_on_cpu_work(get_cwq(cpu, wq), work);
 }

 static int __cancel_work_timer(struct work_struct *work,
@@ -723,165 +1590,66 @@ int keventd_up(void)

 int current_is_keventd(void)
 {
-	struct cpu_workqueue_struct *cwq;
-	int cpu = raw_smp_processor_id(); /* preempt-safe: keventd is per-cpu */
-	int ret = 0;
-
-	BUG_ON(!keventd_wq);
-
-	cwq = per_cpu_ptr(keventd_wq->cpu_wq, cpu);
-	if (current == cwq->thread)
-		ret = 1;
-
-	return ret;
-
-}
-
-static struct cpu_workqueue_struct *
-init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
-{
-	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-
-	cwq->wq = wq;
-	spin_lock_init(&cwq->lock);
-	INIT_LIST_HEAD(&cwq->worklist);
-	init_waitqueue_head(&cwq->more_work);
-
-	return cwq;
-}
-
-static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
-{
-	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
-	struct workqueue_struct *wq = cwq->wq;
-	const char *fmt = is_wq_single_threaded(wq) ? "%s" : "%s/%d";
-	struct task_struct *p;
-
-	p = kthread_create(worker_thread, cwq, fmt, wq->name, cpu);
-	/*
-	 * Nobody can add the work_struct to this cwq,
-	 *	if (caller is __create_workqueue)
-	 *		nobody should see this wq
-	 *	else // caller is CPU_UP_PREPARE
-	 *		cpu is not on cpu_online_map
-	 * so we can abort safely.
-	 */
-	if (IS_ERR(p))
-		return PTR_ERR(p);
-	if (cwq->wq->rt)
-		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
-	cwq->thread = p;
-
-	trace_workqueue_creation(cwq->thread, cpu);
-
-	return 0;
-}
-
-static void start_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
-{
-	struct task_struct *p = cwq->thread;
-
-	if (p != NULL) {
-		if (cpu >= 0)
-			kthread_bind(p, cpu);
-		wake_up_process(p);
-	}
+	return (bool)(current->flags & PF_WORKQUEUE);
 }

 struct workqueue_struct *__create_workqueue_key(const char *name,
-						int singlethread,
-						int freezeable,
-						int rt,
+						unsigned int flags,
 						struct lock_class_key *key,
 						const char *lock_name)
 {
-	struct workqueue_struct *wq;
-	struct cpu_workqueue_struct *cwq;
-	int err = 0, cpu;
+	struct workqueue_struct *wq = NULL;
+	struct cpu_workqueue_struct *cwq = NULL;
+	struct worker *emergency = NULL;
+	unsigned int cpu;

 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
 	if (!wq)
-		return NULL;
+		goto err;

 	wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
-	if (!wq->cpu_wq) {
-		kfree(wq);
-		return NULL;
-	}
+	if (!wq->cpu_wq)
+		goto err;

+	wq->flags = flags;
+	mutex_init(&wq->flush_mutex);
+	atomic_set(&wq->nr_cwqs_to_flush, 0);
 	wq->name = name;
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
-	wq->singlethread = singlethread;
-	wq->freezeable = freezeable;
-	wq->rt = rt;
-	INIT_LIST_HEAD(&wq->list);
-
-	if (singlethread) {
-		cwq = init_cpu_workqueue(wq, singlethread_cpu);
-		err = create_workqueue_thread(cwq, singlethread_cpu);
-		start_workqueue_thread(cwq, -1);
-	} else {
-		cpu_maps_update_begin();
-		/*
-		 * We must place this wq on list even if the code below fails.
-		 * cpu_down(cpu) can remove cpu from cpu_populated_map before
-		 * destroy_workqueue() takes the lock, in that case we leak
-		 * cwq[cpu]->thread.
-		 */
-		spin_lock(&workqueue_lock);
-		list_add(&wq->list, &workqueues);
-		spin_unlock(&workqueue_lock);
-		/*
-		 * We must initialize cwqs for each possible cpu even if we
-		 * are going to call destroy_workqueue() finally. Otherwise
-		 * cpu_up() can hit the uninitialized cwq once we drop the
-		 * lock.
-		 */
-		for_each_possible_cpu(cpu) {
-			cwq = init_cpu_workqueue(wq, cpu);
-			if (err || !cpu_online(cpu))
-				continue;
-			err = create_workqueue_thread(cwq, cpu);
-			start_workqueue_thread(cwq, cpu);
-		}
-		cpu_maps_update_done();
-	}

-	if (err) {
-		destroy_workqueue(wq);
-		wq = NULL;
+	for_each_possible_cpu(cpu) {
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+
+		cwq->gcwq = get_gcwq(cpu);
+		cwq->wq = wq;
 	}
-	return wq;
-}
-EXPORT_SYMBOL_GPL(__create_workqueue_key);

-static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
-{
-	/*
-	 * Our caller is either destroy_workqueue() or CPU_POST_DEAD,
-	 * cpu_add_remove_lock protects cwq->thread.
-	 */
-	if (cwq->thread == NULL)
-		return;
+	if (flags & WQ_EMERGENCY_WORKER) {
+		if (!alloc_cpumask_var(&wq->mayday_mask, GFP_KERNEL))
+			goto err;
+
+		emergency = alloc_worker();
+		if (!emergency)
+			goto err;
+
+		emergency->task = kthread_create(emergency_thread, wq,
+						 "%s", name);
+		if (IS_ERR(emergency->task))
+			goto err;

-	lock_map_acquire(&cwq->wq->lockdep_map);
-	lock_map_release(&cwq->wq->lockdep_map);
+		wq->emergency = emergency;
+	}

-	flush_cpu_workqueue(cwq);
-	/*
-	 * If the caller is CPU_POST_DEAD and cwq->worklist was not empty,
-	 * a concurrent flush_workqueue() can insert a barrier after us.
-	 * However, in that case run_workqueue() won't return and check
-	 * kthread_should_stop() until it flushes all work_struct's.
-	 * When ->worklist becomes empty it is safe to exit because no
-	 * more work_structs can be queued on this cwq: flush_workqueue
-	 * checks list_empty(), and a "normal" queue_work() can't use
-	 * a dead CPU.
-	 */
-	trace_workqueue_destruction(cwq->thread);
-	kthread_stop(cwq->thread);
-	cwq->thread = NULL;
+	return wq;
+err:
+	if (wq)
+		free_cpumask_var(wq->mayday_mask);
+	kfree(wq);
+	kfree(cwq);
+	kfree(emergency);
+	return NULL;
 }
+EXPORT_SYMBOL_GPL(__create_workqueue_key);

 /**
  * destroy_workqueue - safely terminate a workqueue
@@ -891,70 +1659,273 @@ static void cleanup_workqueue_thread(str
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
-	const struct cpumask *cpu_map = wq_cpu_map(wq);
-	int cpu;
+	unsigned int cpu;
+
+	flush_workqueue(wq);

-	cpu_maps_update_begin();
-	spin_lock(&workqueue_lock);
-	list_del(&wq->list);
-	spin_unlock(&workqueue_lock);
-
-	for_each_cpu(cpu, cpu_map)
-		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
- 	cpu_maps_update_done();
+	/* sanity check */
+	for_each_possible_cpu(cpu) {
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		BUG_ON(cwq->nr_in_flight);
+	}
+
+	if (wq->flags & WQ_EMERGENCY_WORKER) {
+		kthread_stop(wq->emergency->task);
+		free_cpumask_var(wq->mayday_mask);
+	}

 	free_percpu(wq->cpu_wq);
 	kfree(wq);
 }
 EXPORT_SYMBOL_GPL(destroy_workqueue);

+static void set_trustee_target_state(struct global_cwq *gcwq, int target_state)
+{
+	if (gcwq->trustee_target != target_state) {
+		gcwq->trustee_target = target_state;
+		wake_up_all(&gcwq->trustee_wait);
+	}
+}
+
+static void wait_trustee_state(struct global_cwq *gcwq, int target_state)
+{
+	set_trustee_target_state(gcwq, target_state);
+
+	if (gcwq->trustee_state != gcwq->trustee_target) {
+		spin_unlock_irq(&gcwq->lock);
+		__wait_event(gcwq->trustee_wait,
+			     gcwq->trustee_state == TRUSTEE_DONE ||
+			     gcwq->trustee_state == gcwq->trustee_target);
+		spin_lock_irq(&gcwq->lock);
+	}
+}
+
+#define trustee_wait_event_timeout(cond, timeout) ({			\
+	long __ret = (timeout);						\
+	while (!(cond) && gcwq->trustee_target != TRUSTEE_CANCEL) {	\
+		spin_unlock_irq(&gcwq->lock);				\
+		__wait_event_timeout(gcwq->trustee_wait, (cond) ||	\
+				gcwq->trustee_target == TRUSTEE_CANCEL,	\
+				__ret);					\
+		spin_lock_irq(&gcwq->lock);				\
+	}								\
+	gcwq->trustee_target == TRUSTEE_CANCEL ? -1 : (__ret);		\
+})
+
+#define trustee_wait_event(cond) ({					\
+	long __ret1;							\
+	__ret1 = trustee_wait_event_timeout(cond, MAX_SCHEDULE_TIMEOUT);\
+	__ret1 < 0 ? -1 : 0;						\
+})
+
+static int __devinit trustee_state_reached(struct global_cwq *gcwq, int state)
+{
+	gcwq->trustee_state = state;
+	wake_up_all(&gcwq->trustee_wait);
+	return trustee_wait_event(gcwq->trustee_state != gcwq->trustee_target);
+}
+
+static bool __devinit trustee_unset_rogue(struct worker *worker)
+{
+	struct global_cwq *gcwq = worker->gcwq;
+
+	if (!(worker->state & WORKER_STA_ROGUE))
+		return false;
+
+	spin_unlock_irq(&gcwq->lock);
+	BUG_ON(set_cpus_allowed_ptr(worker->task, get_cpu_mask(gcwq->cpu)));
+	spin_lock_irq(&gcwq->lock);
+	worker->state &= ~WORKER_STA_ROGUE;
+	return true;
+}
+
+static void __devinit trustee_reap_workfn(struct work_struct *work)
+{
+	struct global_cwq *gcwq =
+		container_of(work, struct global_cwq, trustee_reap);
+
+	kthread_stop(gcwq->trustee);
+}
+
+static int __devinit trustee_thread(void *__gcwq)
+{
+	struct global_cwq *gcwq = __gcwq;
+	struct worker *worker;
+	struct work_struct *work;
+	int next_state, i;
+
+	spin_lock_irq(&gcwq->lock);
+repeat:
+	next_state = gcwq->trustee_target;
+	switch (next_state) {
+	case TRUSTEE_IN_CHARGE:
+		/*
+		 * Claim the manager position.  Trustee can't be
+		 * cancelled at this point.
+		 */
+		BUG_ON(gcwq->cpu != smp_processor_id());
+		BUG_ON(trustee_wait_event(
+				!(gcwq->flags & GCWQ_MANAGING_WORKERS)) < 0);
+		gcwq->flags |= GCWQ_MANAGING_WORKERS;
+
+		/* make all workers ROGUE */
+		list_for_each_entry(worker, &gcwq->idle_list, entry)
+			worker->state |= WORKER_STA_ROGUE;
+
+		for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++) {
+			struct hlist_head *head = &gcwq->busy_hash[i];
+			struct hlist_node *pos;
+
+			hlist_for_each_entry(worker, pos, head, hentry) {
+				if (worker->state & WORKER_STA_RUNNING) {
+					worker->state &= ~WORKER_STA_RUNNING;
+					gcwq->nr_running--;
+				}
+				worker->state |= WORKER_STA_ROGUE;
+			}
+		}
+		WARN_ON(gcwq->nr_running);
+		del_timer_sync(&gcwq->idle_timer);
+		break;
+
+	case TRUSTEE_DRAIN:
+		/* the original cpu is dead, try draining any left work */
+		while (!list_empty(&gcwq->worklist)) {
+			int nr_works = 0;
+
+			list_for_each_entry(work, &gcwq->worklist, entry) {
+				send_mayday(work);
+				nr_works++;
+			}
+
+			list_for_each_entry(worker, &gcwq->idle_list, entry) {
+				if (!nr_works--)
+					break;
+				wake_up_process(worker->task);
+			}
+
+			if (trustee_wait_event_timeout(false, HZ) < 0)
+				break;
+
+			if (need_new_worker(gcwq)) {
+				worker = create_worker(gcwq, false);
+				if (worker) {
+					worker->state |= WORKER_STA_ROGUE;
+					wake_up_process(worker->task);
+				}
+			}
+		}
+
+		/* clean up idle workers */
+		while (gcwq->nr_workers) {
+			while (!list_empty(&gcwq->idle_list)) {
+				worker = list_first_entry(&gcwq->idle_list,
+							  struct worker, entry);
+				destroy_worker(worker);
+			}
+
+			if (trustee_wait_event(
+					!list_empty(&gcwq->idle_list)) < 0)
+				break;
+		}
+
+		if (gcwq->nr_workers)
+			next_state = TRUSTEE_CANCEL;
+		else
+			next_state = TRUSTEE_DONE;
+		break;
+
+	case TRUSTEE_RELEASE:
+	recheck:
+		list_for_each_entry(worker, &gcwq->idle_list, entry)
+			if (trustee_unset_rogue(worker))
+				goto recheck;
+
+		for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++) {
+			struct hlist_head *head = &gcwq->busy_hash[i];
+			struct hlist_node *pos;
+
+			hlist_for_each_entry(worker, pos, head, hentry)
+				if (trustee_unset_rogue(worker))
+					goto recheck;
+		}
+
+		next_state = TRUSTEE_DONE;
+		break;
+	}
+	if (gcwq->trustee_state != TRUSTEE_DONE) {
+		trustee_state_reached(gcwq, next_state);
+		goto repeat;
+	}
+
+	spin_unlock_irq(&gcwq->lock);
+	schedule_work(&gcwq->trustee_reap);
+	spin_lock_irq(&gcwq->lock);
+	trustee_state_reached(gcwq, TRUSTEE_DONE);
+	spin_unlock_irq(&gcwq->lock);
+
+	return 0;
+}
+
 static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 						unsigned long action,
 						void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
-	struct cpu_workqueue_struct *cwq;
-	struct workqueue_struct *wq;
+	struct global_cwq *gcwq = get_gcwq(cpu);
+	struct task_struct *trustee = NULL;
 	int ret = NOTIFY_OK;

 	action &= ~CPU_TASKS_FROZEN;

-	switch (action) {
-	case CPU_UP_PREPARE:
-		cpumask_set_cpu(cpu, cpu_populated_map);
+	if (action == CPU_DOWN_PREPARE) {
+		trustee = kthread_create(trustee_thread, gcwq,
+					 "workqueue_trustee/%d\n", cpu);
+		if (IS_ERR(trustee))
+			return NOTIFY_BAD;
 	}
-undo:
-	list_for_each_entry(wq, &workqueues, list) {
-		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-
-		switch (action) {
-		case CPU_UP_PREPARE:
-			if (!create_workqueue_thread(cwq, cpu))
-				break;
-			printk(KERN_ERR "workqueue [%s] for %i failed\n",
-				wq->name, cpu);
-			action = CPU_UP_CANCELED;
-			ret = NOTIFY_BAD;
-			goto undo;

-		case CPU_ONLINE:
-			start_workqueue_thread(cwq, cpu);
-			break;
+	spin_lock_irq(&gcwq->lock);

-		case CPU_UP_CANCELED:
-			start_workqueue_thread(cwq, -1);
-		case CPU_POST_DEAD:
-			cleanup_workqueue_thread(cwq);
-			break;
+	switch (action) {
+	case CPU_UP_PREPARE:
+		wait_trustee_state(gcwq, TRUSTEE_CANCEL);
+		if (gcwq->trustee_state == TRUSTEE_DONE) {
+			/* create the first worker */
+			BUG_ON(gcwq->nr_workers);
+			if (!create_worker(gcwq, true))
+				ret = NOTIFY_BAD;
 		}
-	}
+		break;

-	switch (action) {
 	case CPU_UP_CANCELED:
-	case CPU_POST_DEAD:
-		cpumask_clear_cpu(cpu, cpu_populated_map);
+		wait_trustee_state(gcwq, TRUSTEE_DRAIN);
+		break;
+
+	case CPU_ONLINE:
+		wait_trustee_state(gcwq, TRUSTEE_RELEASE);
+		wake_up_worker(gcwq);
+		break;
+
+	case CPU_DOWN_PREPARE:
+		BUG_ON(gcwq->trustee || gcwq->trustee_state != TRUSTEE_DONE);
+		gcwq->trustee = current;
+		gcwq->trustee_state = TRUSTEE_NONE;
+		gcwq->trustee_target = TRUSTEE_NONE;
+		wake_up_process(trustee);
+		wait_trustee_state(gcwq, TRUSTEE_IN_CHARGE);
+		break;
+
+	case CPU_DOWN_FAILED:
+		wait_trustee_state(gcwq, TRUSTEE_RELEASE);
+		break;
+
+	case CPU_DEAD:
+		set_trustee_target_state(gcwq, TRUSTEE_DRAIN);
+		break;
 	}

+	spin_unlock_irq(&gcwq->lock);
 	return ret;
 }

@@ -1007,12 +1978,41 @@ EXPORT_SYMBOL_GPL(work_on_cpu);

 void __init init_workqueues(void)
 {
-	alloc_cpumask_var(&cpu_populated_map, GFP_KERNEL);
+	unsigned int cpu;
+	int i;

-	cpumask_copy(cpu_populated_map, cpu_online_mask);
-	singlethread_cpu = cpumask_first(cpu_possible_mask);
-	cpu_singlethread_map = cpumask_of(singlethread_cpu);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
+
+	/* initialize gcwqs */
+	for_each_possible_cpu(cpu) {
+		struct global_cwq *gcwq = get_gcwq(cpu);
+
+		spin_lock_init(&gcwq->lock);
+		INIT_LIST_HEAD(&gcwq->worklist);
+		gcwq->cpu = cpu;
+
+		INIT_LIST_HEAD(&gcwq->idle_list);
+		for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)
+			INIT_HLIST_HEAD(&gcwq->busy_hash[i]);
+
+		init_timer_deferrable(&gcwq->idle_timer);
+		gcwq->idle_timer.function = idle_worker_timeout;
+		gcwq->idle_timer.data = (unsigned long)gcwq;
+
+		setup_timer(&gcwq->mayday_timer, gcwq_mayday_timeout,
+			    (unsigned long)gcwq);
+
+		gcwq->trustee_state = TRUSTEE_DONE;
+		gcwq->trustee_target = TRUSTEE_DONE;
+		init_waitqueue_head(&gcwq->trustee_wait);
+		INIT_WORK(&gcwq->trustee_reap, trustee_reap_workfn);
+
+		/* create the first worker */
+		spin_lock_irq(&gcwq->lock);
+		BUG_ON(!create_worker(gcwq, true));
+		spin_unlock_irq(&gcwq->lock);
+	}
+
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
 }
Index: work/kernel/sched.c
===================================================================
--- work.orig/kernel/sched.c
+++ work/kernel/sched.c
@@ -1732,10 +1732,13 @@ static void cfs_rq_set_shares(struct cfs

 static void calc_load_account_active(struct rq *this_rq);

+#define sched_class_equal(a, b)		((a)->identity == (b)->identity)
+
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
 #include "sched_rt.c"
+#include "sched_workqueue.c"
 #ifdef CONFIG_SCHED_DEBUG
 # include "sched_debug.c"
 #endif
@@ -1906,7 +1909,7 @@ static inline void check_class_changed(s
 				       const struct sched_class *prev_class,
 				       int oldprio, int running)
 {
-	if (prev_class != p->sched_class) {
+	if (!sched_class_equal(prev_class, p->sched_class)) {
 		if (prev_class->switched_from)
 			prev_class->switched_from(rq, p, running);
 		p->sched_class->switched_to(rq, p, running);
@@ -1938,7 +1941,7 @@ task_hot(struct task_struct *p, u64 now,
 			 &p->se == cfs_rq_of(&p->se)->last))
 		return 1;

-	if (p->sched_class != &fair_sched_class)
+	if (!sched_class_equal(p->sched_class, &fair_sched_class))
 		return 0;

 	if (sysctl_sched_migration_cost == -1)
@@ -6085,7 +6088,10 @@ __setscheduler(struct rq *rq, struct tas
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
 	case SCHED_IDLE:
-		p->sched_class = &fair_sched_class;
+		if (p->flags & PF_WORKQUEUE)
+			p->sched_class = &workqueue_sched_class;
+		else
+			p->sched_class = &fair_sched_class;
 		break;
 	case SCHED_FIFO:
 	case SCHED_RR:
@@ -10230,7 +10236,7 @@ cpu_cgroup_can_attach(struct cgroup_subs
 		return -EINVAL;
 #else
 	/* We don't support RT-tasks being in separate groups */
-	if (tsk->sched_class != &fair_sched_class)
+	if (!sched_class_equal(tsk->sched_class, &fair_sched_class))
 		return -EINVAL;
 #endif

Index: work/kernel/sched_fair.c
===================================================================
--- work.orig/kernel/sched_fair.c
+++ work/kernel/sched_fair.c
@@ -934,7 +934,7 @@ static void hrtick_update(struct rq *rq)
 {
 	struct task_struct *curr = rq->curr;

-	if (curr->sched_class != &fair_sched_class)
+	if (!sched_class_equal(curr->sched_class, &fair_sched_class))
 		return;

 	if (cfs_rq_of(&curr->se)->nr_running < sched_nr_latency)
@@ -1450,7 +1450,7 @@ static void check_preempt_wakeup(struct
 		return;
 	}

-	if (unlikely(p->sched_class != &fair_sched_class))
+	if (unlikely(!sched_class_equal(p->sched_class, &fair_sched_class)))
 		return;

 	if (unlikely(se == pse))
@@ -1799,34 +1799,48 @@ static void moved_group_fair(struct task
 /*
  * All the scheduling class methods:
  */
-static const struct sched_class fair_sched_class = {
-	.next			= &idle_sched_class,
-	.enqueue_task		= enqueue_task_fair,
-	.dequeue_task		= dequeue_task_fair,
-	.yield_task		= yield_task_fair,
-
-	.check_preempt_curr	= check_preempt_wakeup,
-
-	.pick_next_task		= pick_next_task_fair,
-	.put_prev_task		= put_prev_task_fair,
+#define FAIR_SCHED_CLASS_INIT_BASE			\
+	.identity		= &fair_sched_class,	\
+	.next			= &idle_sched_class,	\
+	.enqueue_task		= enqueue_task_fair,	\
+	.dequeue_task		= dequeue_task_fair,	\
+	.yield_task		= yield_task_fair,	\
+							\
+	.check_preempt_curr	= check_preempt_wakeup,	\
+							\
+	.pick_next_task		= pick_next_task_fair,	\
+	.put_prev_task		= put_prev_task_fair,	\
+							\
+	.set_curr_task          = set_curr_task_fair,	\
+	.task_tick		= task_tick_fair,	\
+	.task_new		= task_new_fair,	\
+							\
+	.prio_changed		= prio_changed_fair,	\
+	.switched_to		= switched_to_fair,

 #ifdef CONFIG_SMP
-	.select_task_rq		= select_task_rq_fair,
-
-	.load_balance		= load_balance_fair,
+#define FAIR_SCHED_CLASS_INIT_SMP			\
+	.select_task_rq		= select_task_rq_fair,	\
+	.load_balance		= load_balance_fair,	\
 	.move_one_task		= move_one_task_fair,
+#else
+#define FAIR_SCHED_CLASS_INIT_SMP
 #endif

-	.set_curr_task          = set_curr_task_fair,
-	.task_tick		= task_tick_fair,
-	.task_new		= task_new_fair,
-
-	.prio_changed		= prio_changed_fair,
-	.switched_to		= switched_to_fair,
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
+#define FAIR_SCHED_CLASS_INIT_GROUP			\
 	.moved_group		= moved_group_fair,
+#else
+#define FAIR_SCHED_CLASS_INIT_GROUP
 #endif
+
+#define FAIR_SCHED_CLASS_INIT				\
+	FAIR_SCHED_CLASS_INIT_BASE			\
+	FAIR_SCHED_CLASS_INIT_SMP			\
+	FAIR_SCHED_CLASS_INIT_GROUP
+
+static const struct sched_class fair_sched_class = {
+	FAIR_SCHED_CLASS_INIT
 };

 #ifdef CONFIG_SCHED_DEBUG
Index: work/include/linux/sched.h
===================================================================
--- work.orig/include/linux/sched.h
+++ work/include/linux/sched.h
@@ -1023,6 +1023,7 @@ struct sched_domain;

 struct sched_class {
 	const struct sched_class *next;
+	const struct sched_class *identity;

 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
@@ -1694,6 +1695,7 @@ extern cputime_t task_gtime(struct task_
 #define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
 #define PF_THREAD_BOUND	0x04000000	/* Thread bound to specific cpu */
+#define PF_WORKQUEUE	0x08000000	/* I'm a workqueue worker */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
 #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
@@ -1865,6 +1867,7 @@ extern int idle_cpu(int cpu);
 extern int sched_setscheduler(struct task_struct *, int, struct sched_param *);
 extern int sched_setscheduler_nocheck(struct task_struct *, int,
 				      struct sched_param *);
+extern void sched_setscheduler_workqueue(struct task_struct *p);
 extern struct task_struct *idle_task(int cpu);
 extern struct task_struct *curr_task(int cpu);
 extern void set_curr_task(int cpu, struct task_struct *p);
Index: work/kernel/sched_idletask.c
===================================================================
--- work.orig/kernel/sched_idletask.c
+++ work/kernel/sched_idletask.c
@@ -101,6 +101,7 @@ static void prio_changed_idle(struct rq
  * Simple, special scheduling class for the per-CPU idle tasks:
  */
 static const struct sched_class idle_sched_class = {
+	.identity		= &idle_sched_class,
 	/* .next is NULL */
 	/* no enqueue/yield_task for idle tasks */

Index: work/kernel/sched_rt.c
===================================================================
--- work.orig/kernel/sched_rt.c
+++ work/kernel/sched_rt.c
@@ -1739,6 +1739,7 @@ static void set_curr_task_rt(struct rq *
 }

 static const struct sched_class rt_sched_class = {
+	.identity		= &rt_sched_class,
 	.next			= &fair_sched_class,
 	.enqueue_task		= enqueue_task_rt,
 	.dequeue_task		= dequeue_task_rt,
Index: work/kernel/sched_workqueue.c
===================================================================
--- /dev/null
+++ work/kernel/sched_workqueue.c
@@ -0,0 +1,53 @@
+#include "sched_workqueue.h"
+
+static void enqueue_task_wq(struct rq *rq, struct task_struct *p, int wakeup)
+{
+	if (wakeup)
+		sched_workqueue_worker_wakeup(p);
+
+	return enqueue_task_fair(rq, p, wakeup);
+}
+
+static void dequeue_task_wq(struct rq *rq, struct task_struct *p, int sleep)
+{
+	if (sleep)
+		sched_workqueue_worker_sleep(p);
+
+	return dequeue_task_fair(rq, p, sleep);
+}
+
+static void put_prev_task_wq(struct rq *rq, struct task_struct *prev)
+{
+	if (prev->se.on_rq)
+		sched_workqueue_worker_preempted(prev);
+
+	return put_prev_task_fair(rq, prev);
+}
+
+static const struct sched_class workqueue_sched_class = {
+	FAIR_SCHED_CLASS_INIT
+	.enqueue_task		= enqueue_task_wq,
+	.dequeue_task		= dequeue_task_wq,
+	.put_prev_task		= put_prev_task_wq,
+};
+
+bool sched_workqueue_wake_up_process(struct task_struct *p)
+{
+	struct rq *rq = this_rq();
+	bool success = false;
+
+	if (!p->se.on_rq) {
+		schedstat_inc(p, se.nr_wakeups);
+		schedstat_inc(p, se.nr_wakeups_local);
+		activate_task(rq, p, 1);
+		success = true;
+	}
+
+	trace_sched_wakeup(rq, p, success);
+	p->state = TASK_RUNNING;
+#ifdef CONFIG_SMP
+	if (p->sched_class->task_wake_up)
+		p->sched_class->task_wake_up(rq, p);
+#endif
+	return success;
+}
Index: work/include/linux/kthread.h
===================================================================
--- work.orig/include/linux/kthread.h
+++ work/include/linux/kthread.h
@@ -30,6 +30,7 @@ struct task_struct *kthread_create(int (
 void kthread_bind(struct task_struct *k, unsigned int cpu);
 int kthread_stop(struct task_struct *k);
 int kthread_should_stop(void);
+void *kthread_data(struct task_struct *k);

 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
Index: work/kernel/kthread.c
===================================================================
--- work.orig/kernel/kthread.c
+++ work/kernel/kthread.c
@@ -37,6 +37,7 @@ struct kthread_create_info

 struct kthread {
 	int should_stop;
+	void *data;
 	struct completion exited;
 };

@@ -56,6 +57,11 @@ int kthread_should_stop(void)
 }
 EXPORT_SYMBOL(kthread_should_stop);

+void *kthread_data(struct task_struct *task)
+{
+	return to_kthread(current)->data;
+}
+
 static int kthread(void *_create)
 {
 	/* Copy data: it's on kthread's stack */
@@ -66,6 +72,7 @@ static int kthread(void *_create)
 	int ret;

 	self.should_stop = 0;
+	self.data = data;
 	init_completion(&self.exited);
 	current->vfork_done = &self.exited;

Index: work/kernel/sched_workqueue.h
===================================================================
--- /dev/null
+++ work/kernel/sched_workqueue.h
@@ -0,0 +1,5 @@
+void sched_workqueue_worker_wakeup(struct task_struct *task);
+void sched_workqueue_worker_sleep(struct task_struct *task);
+void sched_workqueue_worker_preempted(struct task_struct *task);
+
+bool sched_workqueue_wake_up_process(struct task_struct *p);
