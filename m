Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbZJAILF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbZJAILF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbZJAILC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:11:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:38419 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755960AbZJAIKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:10:49 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 19/19] workqueue: implement concurrency managed workqueue
Date: Thu,  1 Oct 2009 17:09:18 +0900
Message-Id: <1254384558-1018-20-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 08:09:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently each workqueue has its own dedicated worker pool.  This
causes the following problems.

* Works which are dependent on each other can cause a deadlock by
  depending on the same execution resource.  This is bad because this
  type of dependency is quite difficult to find.

* Works which may sleep and take long time to finish need to have
  separate workqueues so that it doesn't block other works.  Similarly
  works which want to be executed in timely manner often need to
  create it custom workqueue too to avoid being blocked by long
  running ones.  This leads to large number of workqueues and thus
  many workers.

* The static one-per-cpu worker isn't good enough for jobs which
  require higher level of concurrency necessiating other worker pool
  mechanism.  slow-work and async are good examples and there are also
  some custom implementations buried in subsystems.

* Combined, the above factors lead to many workqueues with large
  number of dedicated and mostly unused workers.  This also makes work
  processing less optimal as the dedicated workers end up switching
  among themselves costing scheduleing overhead and wasting cache
  footprint for their stacks and as the system gets busy, these
  workers end up competing with each other.

To solve the above issues, this patch implements concurrency-managed
workqueue.

There is single global cpu workqueue (gcwq) for each cpu which serves
all the workqueues.  gcwq maintains single pool of workers which is
shared by all cwqs on the cpu.

gcwq keeps the number of concurrent active workers to minimum but no
less.  As long as there's one or more running workers on the cpu, no
new worker is scheduled so that works can be processed in batch as
much as possible but when the last running worker blocks, gcwq
immediately schedules new worker so that the cpu doesn't sit idle
while there are works to be processed.

gcwq always keeps at least single idle worker around.  When a new
worker is necessary and the worker is the last idle one, the worker
assumes the role of "manager" and manages the worker pool -
ie. creates another worker.  Forward-progress is guaranteed by having
dedicated rescue workers for workqueues which may be necessary while
creating a new worker.  When the manager is having problem creating a
new worker, mayday timer activates and rescue workers are summoned to
the cpu and execute works which may be necessary to create new
workers.

To keep track of which worker is executing which work, gcwq uses a
hash table.  This is necessary as works may be destroyed once it
starts executing and flushing should be implemented by tracking
whether any worker is executing the work.

cpu hotplug implementation is more complex than before because there
are multiple workers and now workqueue is capable of hosting long
erunning works.  cpu offlining is implemented by creating a "trustee"
kthread which runs the gcwq as if the cpu is still online until all
works are drained.  As soon as the trustee takes over the gcwq, cpu
hotunplug operation can proceed without waiting for workqueues to be
drained.  Onlining is the reverse.  If trustee is still trying to
drain the gcwq from the previous offlining, it puts all workers back
to the cpu and let the gcwq run as if cpu has been online the whole
time.

The new implementation has the following benefits.

* Workqueue users no longer have to worry about managing concurrency
  and, in most cases, deadlocks.  The workqueue will manage it
  automatically and unless the deadlock chain involves more than 127
  works, it won't happen.

* There's one single shared pool of workers per cpu and one rescuer
  for each workqueue which requires it, so there are far fewer number
  of kthreads.

* More efficient.  Although it adds considerable amount of code, the
  code added to hot path isn't big and works will be executed on the
  local cpu and in batch as much as possible using minimal number of
  kthreads leading to fewer task switches and lower cache
  footprint. <NEED SOME BACKING NUMBERS>

* As concurrency is no longer a problem, most types of asynchronous
  jobs can be done using generic workqueue and other async mechanisms
  can be removed.

NOT_SIGNED_OFF_YET
---
 include/linux/workqueue.h |    7 +-
 kernel/workqueue.c        | 1566 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 1378 insertions(+), 195 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 351466d..9dbdbc2 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -182,6 +182,7 @@ struct execute_work {
 
 enum {
 	WQ_FREEZEABLE		= 1 << 0, /* freeze during suspend */
+	WQ_RESCUER		= 1 << 1, /* has an rescue worker */
 };
 
 extern struct workqueue_struct *
@@ -208,11 +209,11 @@ __create_workqueue_key(const char *name, unsigned int flags,
 #endif
 
 #define create_workqueue(name)					\
-	__create_workqueue((name), 0)
+	__create_workqueue((name), WQ_RESCUER)
 #define create_freezeable_workqueue(name)			\
-	__create_workqueue((name), WQ_FREEZEABLE)
+	__create_workqueue((name), WQ_FREEZEABLE | WQ_RESCUER)
 #define create_singlethread_workqueue(name)			\
-	__create_workqueue((name), 0)
+	__create_workqueue((name), WQ_RESCUER)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 097da97..67cb3a1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -29,19 +29,72 @@
 #include <linux/kthread.h>
 #include <linux/hardirq.h>
 #include <linux/mempolicy.h>
-#include <linux/freezer.h>
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
+#include <linux/wait.h>
 
 #include "sched_workqueue.h"
 
+enum {
+	/* worker flags */
+	WORKER_STARTED		= 1 << 0,	/* started */
+	WORKER_DIE		= 1 << 1,	/* die die die */
+	WORKER_IDLE		= 1 << 2,	/* is idle */
+	WORKER_MANAGER		= 1 << 3,	/* I'm the manager */
+	WORKER_RESCUER		= 1 << 4,	/* I'm a rescuer */
+	WORKER_ROGUE		= 1 << 5,	/* not bound to any cpu */
+
+	WORKER_IGN_RUNNING	= WORKER_IDLE | WORKER_MANAGER | WORKER_ROGUE,
+
+	/* global_cwq flags */
+	GCWQ_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
+	GCWQ_MANAGING_WORKERS	= 1 << 1,	/* managing workers */
+	GCWQ_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
+
+	/* gcwq->trustee_state */
+	TRUSTEE_START		= 0,		/* start */
+	TRUSTEE_IN_CHARGE	= 1,		/* trustee in charge of gcwq */
+	TRUSTEE_BUTCHER		= 2,		/* butcher workers */
+	TRUSTEE_RELEASE		= 3,		/* release workers */
+	TRUSTEE_DONE		= 4,		/* trustee is done */
+
+	MAX_CPU_WORKERS_ORDER	= 7,		/* 128 */
+	MAX_WORKERS_PER_CPU	= 1 << MAX_CPU_WORKERS_ORDER,
+
+	BUSY_WORKER_HASH_ORDER	= 4,		/* 16 pointers */
+	BUSY_WORKER_HASH_SIZE	= 1 << BUSY_WORKER_HASH_ORDER,
+	BUSY_WORKER_HASH_MASK	= BUSY_WORKER_HASH_SIZE - 1,
+
+	MAX_IDLE_WORKERS_RATIO	= 4,		/* 1/4 of busy can be idle */
+	IDLE_WORKER_TIMEOUT	= 300 * HZ,	/* keep idle ones for 5 mins */
+
+	MAYDAY_INITIAL_TIMEOUT	= HZ / 100,	/* call for help after 10ms */
+	MAYDAY_INTERVAL		= HZ / 10,	/* and then every 100ms */
+	CREATE_COOLDOWN		= HZ,		/* time to breath after fail */
+	TRUSTEE_COOLDOWN	= HZ / 10,	/* for trustee draining */
+
+	/*
+	 * Rescue workers are used only on emergencies and shared by
+	 * all cpus.  Give -20.
+	 */
+	RESCUER_NICE_LEVEL	= -20,
+};
+
 /*
  * Structure fields follow one of the following exclusion rules.
  *
  * I: Set during initialization and read-only afterwards.
  *
- * L: cwq->lock protected.  Access with cwq->lock held.
+ * P: Preemption protected.  Disabling preemption is enough and should
+ *    only be modified and accessed from the local cpu.
+ *
+ * L: gcwq->lock protected.  Access with gcwq->lock held.
+ *
+ * X: During normal operation, modification requires gcwq->lock and
+ *    should be done only from local cpu.  Either disabling preemption
+ *    on local cpu or grabbing gcwq->lock is enough for read access.
+ *    While trustee is in charge, it's identical to L.
  *
  * W: workqueue_lock protected.
  *
@@ -50,14 +103,56 @@
  *    be removed).
  */
 
-struct cpu_workqueue_struct;
+struct global_cwq;
 
+/*
+ * The poor guys doing the actual heavy lifting.  All on-duty workers
+ * are either serving the manager role, on idle list or on busy hash.
+ */
 struct worker {
+	/* on idle list while idle, on busy hash table while busy */
+	union {
+		struct list_head	entry;	/* L: while idle */
+		struct hlist_node	hentry;	/* L: while busy */
+	};
+
 	struct work_struct	*current_work;	/* L: work being processed */
 	struct list_head	scheduled;	/* L: scheduled works */
 	struct task_struct	*task;		/* I: worker task */
-	struct cpu_workqueue_struct *cwq;	/* I: the associated cwq */
-};
+	struct global_cwq	*gcwq;		/* I: the associated gcwq */
+	unsigned long		last_active;	/* L: last active timestamp */
+	/* 64 bytes boundary on 64bit, 32 on 32bit */
+	bool			running;	/* ?: is this worker running? */
+	unsigned int		flags;		/* ?: flags */
+} ____cacheline_aligned_in_smp;
+
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
+	/* workers are chained either in the idle_list or busy_hash */
+	struct list_head	idle_list;	/* ?: list of idle workers */
+	struct hlist_head	busy_hash[BUSY_WORKER_HASH_SIZE];
+						/* L: hash of busy workers */
+
+	struct timer_list	idle_timer;	/* L: worker idle timeout */
+	struct timer_list	mayday_timer;	/* L: SOS timer for dworkers */
+
+	struct task_struct	*trustee;	/* L: for gcwq shutdown */
+	unsigned int		trustee_state;	/* L: trustee state */
+	wait_queue_head_t	trustee_wait;	/* trustee wait */
+	struct worker		*first_idle;	/* L: first idle worker */
+} ____cacheline_aligned_in_smp;
 
 /*
  * The per-CPU workqueue.  The lower WORK_STRUCT_FLAG_BITS of
@@ -65,14 +160,7 @@ struct worker {
  * aligned at two's power of the number of flag bits.
  */
 struct cpu_workqueue_struct {
-
-	spinlock_t lock;
-
-	struct list_head worklist;
-	wait_queue_head_t more_work;
-	unsigned int		cpu;
-	struct worker		*worker;
-
+	struct global_cwq	*gcwq;		/* I: the associated gcwq */
 	struct list_head	*cur_worklist;	/* L: current worklist */
 	int			nr_in_flight;	/* L: nr of in_flight works */
 	unsigned int		flush_color;	/* L: current flush color */
@@ -94,6 +182,9 @@ struct workqueue_struct {
 	atomic_t		nr_cwqs_to_flush; /* flush in progress */
 	struct completion	*flush_done;	/* flush done */
 
+	cpumask_var_t		mayday_mask;	/* cpus requesting rescue */
+	struct worker		*rescuer;	/* I: rescue worker */
+
 	const char		*name;		/* I: workqueue name */
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map	lockdep_map;
@@ -105,8 +196,27 @@ static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
 static bool workqueue_frozen;
 
+/*
+ * The almighty global cpu workqueues.  nr_running is the only field
+ * which is expected to be used frequently by other cpus by
+ * try_to_wake_up() which ends up incrementing it.  Put it in a
+ * separate cacheline.
+ */
+static DEFINE_PER_CPU(struct global_cwq, global_cwq);
+static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t, gcwq_nr_running);
+
 static int worker_thread(void *__worker);
 
+static struct global_cwq *get_gcwq(unsigned int cpu)
+{
+	return &per_cpu(global_cwq, cpu);
+}
+
+static atomic_t *get_gcwq_nr_running(unsigned int cpu)
+{
+	return &per_cpu(gcwq_nr_running, cpu);
+}
+
 static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
 					    struct workqueue_struct *wq)
 {
@@ -133,6 +243,106 @@ static inline struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 }
 
 /*
+ * Policy functions.  These define the policies on how the global
+ * worker pool is managed.  Unless noted otherwise, these functions
+ * assume that they're being called with gcwq->lock held.
+ */
+
+/*
+ * Need to wake up a worker?  Called from anything but currently
+ * running workers.
+ */
+static bool need_more_worker(struct global_cwq *gcwq)
+{
+	atomic_t *nr_running = get_gcwq_nr_running(gcwq->cpu);
+
+	return !list_empty(&gcwq->worklist) && !atomic_read(nr_running);
+}
+
+/* Can I start working?  Called from busy but !running workers. */
+static bool may_start_working(struct global_cwq *gcwq)
+{
+	return gcwq->nr_idle;
+}
+
+/* Do I need to keep working?  Called from currently running workers. */
+static bool keep_working(struct global_cwq *gcwq)
+{
+	atomic_t *nr_running = get_gcwq_nr_running(gcwq->cpu);
+
+	return !list_empty(&gcwq->worklist) && atomic_read(nr_running) <= 1;
+}
+
+/* Do we need a new worker?  Called from manager. */
+static bool need_to_create_worker(struct global_cwq *gcwq)
+{
+	return need_more_worker(gcwq) && !may_start_working(gcwq);
+}
+
+/* Do I need to be the manager? */
+static bool need_to_manage_workers(struct global_cwq *gcwq)
+{
+	return need_to_create_worker(gcwq) || gcwq->flags & GCWQ_MANAGE_WORKERS;
+}
+
+/* Do we have too many workers and should some go away? */
+static bool too_many_workers(struct global_cwq *gcwq)
+{
+	bool managing = gcwq->flags & GCWQ_MANAGING_WORKERS;
+	int nr_idle = gcwq->nr_idle + managing; /* manager is considered idle */
+	int nr_busy = gcwq->nr_workers - nr_idle;
+
+	return nr_idle > 2 && (nr_idle - 2) * MAX_IDLE_WORKERS_RATIO >= nr_busy;
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
+ * Wake up the first idle worker of @gcwq.
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
+ * sched_wake_up_worker - wake up an idle worker from a scheduler callback
+ * @gcwq: gcwq to wake worker for
+ *
+ * Wake up the first idle worker of @gcwq.
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
  * Scheduler callbacks.  These functions are called during schedule()
  * with rq lock held.  Don't try to acquire any lock and only access
  * fields which are safe with preemption disabled from local cpu.
@@ -141,29 +351,144 @@ static inline struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 /* called when a worker task wakes up from sleep */
 void sched_workqueue_worker_wakeup(struct task_struct *task)
 {
+	struct worker *worker = kthread_data(task);
+	struct global_cwq *gcwq = worker->gcwq;
+	atomic_t *nr_running = get_gcwq_nr_running(gcwq->cpu);
+
+	if (unlikely(worker->flags & WORKER_IGN_RUNNING))
+		return;
+
+	if (likely(!worker->running)) {
+		worker->running = true;
+		atomic_inc(nr_running);
+	}
 }
 
 /* called when a worker task goes into sleep */
 void sched_workqueue_worker_sleep(struct task_struct *task)
 {
+	struct worker *worker = kthread_data(task);
+	struct global_cwq *gcwq = worker->gcwq;
+	atomic_t *nr_running = get_gcwq_nr_running(gcwq->cpu);
+
+	if (unlikely(worker->flags & WORKER_IGN_RUNNING))
+		return;
+
+	/* this can only happen on the local cpu */
+	BUG_ON(gcwq->cpu != raw_smp_processor_id());
+
+	if (likely(worker->running)) {
+		worker->running = false;
+		/*
+		 * The counterpart of the following dec_and_test,
+		 * implied mb, worklist not empty test sequence is in
+		 * insert_work().  Please read comment there.
+		 */
+		if (atomic_dec_and_test(nr_running) &&
+		    !list_empty(&gcwq->worklist))
+			sched_wake_up_worker(gcwq);
+	}
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
+	/* simple shift and fold hash, do we need something better? */
+	v >>= base_shift;
+	v += v >> BUSY_WORKER_HASH_ORDER;
+	v &= BUSY_WORKER_HASH_MASK;
+
+	return &gcwq->busy_hash[v];
 }
 
 /**
- * insert_work - insert a work into cwq
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
+{
+	return __find_worker_executing_work(gcwq, busy_worker_head(gcwq, work),
+					    work);
+}
+
+/**
+ * insert_work - insert a work into gcwq
  * @cwq: cwq @work belongs to
  * @work: work to insert
  * @head: insertion point
  * @extra_flags: extra WORK_STRUCT_* flags to set
  *
- * Insert @work into @cwq after @head.
+ * Insert @work which belongs to @cwq into @gcwq after @head.
+ * @extra_flags is ORd to WORK_STRUCT flags.
  *
  * CONTEXT:
- * spin_lock_irq(cwq->lock).
+ * spin_lock_irq(gcwq->lock).
  */
 static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head,
 			unsigned int extra_flags)
 {
+	struct global_cwq *gcwq = cwq->gcwq;
+
 	cwq->nr_in_flight++;
 
 	/* we own @work, set data and link */
@@ -176,19 +501,29 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 	smp_wmb();
 
 	list_add_tail(&work->entry, head);
-	wake_up(&cwq->more_work);
+
+	/*
+	 * Ensure either sched_workqueue_worker_sleep() sees the above
+	 * list_add_tail() or we see zero nr_running to avoid workers
+	 * lying around lazily while there are works to be processed.
+	 */
+	smp_mb();
+
+	if (!atomic_read(get_gcwq_nr_running(gcwq->cpu)))
+		wake_up_worker(gcwq);
 }
 
 static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
 	struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+	struct global_cwq *gcwq = cwq->gcwq;
 	unsigned long flags;
 
-	spin_lock_irqsave(&cwq->lock, flags);
+	spin_lock_irqsave(&gcwq->lock, flags);
 	BUG_ON(!list_empty(&work->entry));
 	insert_work(cwq, work, cwq->cur_worklist, 0);
-	spin_unlock_irqrestore(&cwq->lock, flags);
+	spin_unlock_irqrestore(&gcwq->lock, flags);
 }
 
 /**
@@ -300,22 +635,77 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
+/**
+ * worker_enter_idle - enter idle state
+ * @worker: worker which is entering idle state
+ *
+ * @worker is entering idle state.  Update stats and idle timer if
+ * necessary.
+ *
+ * LOCKING:
+ * spin_lock_irq(gcwq->lock).
+ */
+static void worker_enter_idle(struct worker *worker)
+{
+	struct global_cwq *gcwq = worker->gcwq;
+
+	BUG_ON(worker->flags & WORKER_IDLE);
+	BUG_ON(!list_empty(&worker->entry) &&
+	       (worker->hentry.next || worker->hentry.pprev));
+
+	worker->flags |= WORKER_IDLE;
+	gcwq->nr_idle++;
+	worker->last_active = jiffies;
+
+	/* idle_list is LIFO */
+	list_add(&worker->entry, &gcwq->idle_list);
+
+	if (likely(!(worker->flags & WORKER_ROGUE))) {
+		if (too_many_workers(gcwq) && !timer_pending(&gcwq->idle_timer))
+			mod_timer(&gcwq->idle_timer,
+				  jiffies + IDLE_WORKER_TIMEOUT);
+	} else
+		wake_up_all(&gcwq->trustee_wait);
+}
+
+/**
+ * worker_leave_idle - leave idle state
+ * @worker: worker which is leaving idle state
+ *
+ * @worker is leaving idle state.  Update stats.
+ *
+ * LOCKING:
+ * spin_lock_irq(gcwq->lock).
+ */
+static void worker_leave_idle(struct worker *worker)
+{
+	struct global_cwq *gcwq = worker->gcwq;
+
+	BUG_ON(!(worker->flags & WORKER_IDLE));
+	worker->flags &= ~WORKER_IDLE;
+	gcwq->nr_idle--;
+	list_del_init(&worker->entry);
+}
+
 static struct worker *alloc_worker(void)
 {
 	struct worker *worker;
 
 	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
-	if (worker)
+	if (worker) {
+		INIT_LIST_HEAD(&worker->entry);
 		INIT_LIST_HEAD(&worker->scheduled);
+		/* on creation a worker is not idle */
+	}
 	return worker;
 }
 
 /**
  * create_worker - create a new workqueue worker
- * @cwq: cwq the new worker will belong to
+ * @gcwq: gcwq the new worker will belong to
  * @bind: whether to set affinity to @cpu or not
  *
- * Create a new worker which is bound to @cwq.  The returned worker
+ * Create a new worker which is bound to @gcwq.  The returned worker
  * can be started by calling start_worker() or destroyed using
  * destroy_worker().
  *
@@ -325,23 +715,30 @@ static struct worker *alloc_worker(void)
  * RETURNS:
  * Pointer to the newly created worker.
  */
-static struct worker *create_worker(struct cpu_workqueue_struct *cwq, bool bind)
+static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
 {
-	struct worker *worker;
+	struct worker *worker = NULL;
 
 	worker = alloc_worker();
 	if (!worker)
 		goto fail;
 
-	worker->cwq = cwq;
+	worker->gcwq = gcwq;
 
 	worker->task = kthread_create(worker_thread, worker, "kworker/%u",
-				      cwq->cpu);
+				      gcwq->cpu);
 	if (IS_ERR(worker->task))
 		goto fail;
 
+	/*
+	 * A rogue worker will become a regular one if CPU comes
+	 * online later on.  Make sure every worker has
+	 * PF_THREAD_BOUND set.
+	 */
 	if (bind)
-		kthread_bind(worker->task, cwq->cpu);
+		kthread_bind(worker->task, gcwq->cpu);
+	else
+		worker->task->flags |= PF_THREAD_BOUND;
 
 	return worker;
 fail:
@@ -353,13 +750,16 @@ fail:
  * start_worker - start a newly created worker
  * @worker: worker to start
  *
- * Start @worker.
+ * Make the gcwq aware of @worker and start it.
  *
  * CONTEXT:
- * spin_lock_irq(cwq->lock).
+ * spin_lock_irq(gcwq->lock).
  */
 static void start_worker(struct worker *worker)
 {
+	worker->flags |= WORKER_STARTED;
+	worker->gcwq->nr_workers++;
+	worker_enter_idle(worker);
 	wake_up_process(worker->task);
 }
 
@@ -367,16 +767,263 @@ static void start_worker(struct worker *worker)
  * destroy_worker - destroy a workqueue worker
  * @worker: worker to be destroyed
  *
- * Destroy @worker.
+ * Destroy @worker and adjust @gcwq stats accordingly.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock) which is released and regrabbed.
  */
 static void destroy_worker(struct worker *worker)
 {
+	struct global_cwq *gcwq = worker->gcwq;
+
 	/* sanity check frenzy */
 	BUG_ON(worker->current_work);
 	BUG_ON(!list_empty(&worker->scheduled));
+	BUG_ON(worker->running);
+
+	if (worker->flags & WORKER_STARTED)
+		gcwq->nr_workers--;
+	if (worker->flags & WORKER_IDLE)
+		gcwq->nr_idle--;
+
+	list_del_init(&worker->entry);
+	worker->flags |= WORKER_DIE;
+
+	spin_unlock_irq(&gcwq->lock);
 
 	kthread_stop(worker->task);
 	kfree(worker);
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
+
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
+		}
+	}
+
+	spin_unlock_irq(&gcwq->lock);
+}
+
+static bool send_mayday(struct work_struct *work)
+{
+	struct cpu_workqueue_struct *cwq = get_wq_data(work);
+	struct workqueue_struct *wq = cwq->wq;
+
+	if (!(wq->flags & WQ_RESCUER))
+		return false;
+
+	/* mayday mayday mayday */
+	if (!cpumask_test_and_set_cpu(cwq->gcwq->cpu, wq->mayday_mask))
+		wake_up_process(wq->rescuer->task);
+	return true;
+}
+
+static void gcwq_mayday_timeout(unsigned long __gcwq)
+{
+	struct global_cwq *gcwq = (void *)__gcwq;
+	struct work_struct *work;
+
+	spin_lock_irq(&gcwq->lock);
+
+	if (need_to_create_worker(gcwq)) {
+		/*
+		 * We've been trying to create a new worker but
+		 * haven't been successful.  We might be hitting an
+		 * allocation deadlock.  Send distress calls to
+		 * rescuers.
+		 */
+		list_for_each_entry(work, &gcwq->worklist, entry)
+			send_mayday(work);
+	}
+
+	spin_unlock_irq(&gcwq->lock);
+
+	mod_timer(&gcwq->mayday_timer, jiffies + MAYDAY_INTERVAL);
+}
+
+/**
+ * maybe_create_worker - create a new worker if necessary
+ * @gcwq: gcwq to create a new worker for
+ *
+ * Create a new worker for @gcwq if necessary.  @gcwq is guaranteed to
+ * have at least one idle worker on return from this function.  If
+ * creating a new worker takes longer than MAYDAY_INTERVAL, mayday is
+ * sent to all rescuers with works scheduled on @gcwq to resolve
+ * possible allocation deadlock.
+ *
+ * On return, need_to_create_worker() is guaranteed to be false and
+ * may_start_working() true.
+ *
+ * LOCKING:
+ * spin_lock_irq(gcwq->lock) which may be released and regrabbed
+ * multiple times.  Does GFP_KERNEL allocations.  Called only from
+ * manager.
+ *
+ * RETURNS:
+ * false if no action was taken and gcwq->lock stayed locked, true
+ * otherwise.
+ */
+static bool maybe_create_worker(struct global_cwq *gcwq)
+{
+	if (!need_to_create_worker(gcwq))
+		return false;
+restart:
+	/* if we don't make progress in MAYDAY_INITIAL_TIMEOUT, call for help */
+	mod_timer(&gcwq->mayday_timer, jiffies + MAYDAY_INITIAL_TIMEOUT);
+
+	while (true) {
+		struct worker *worker;
+
+		if (gcwq->nr_workers >= MAX_WORKERS_PER_CPU) {
+			if (printk_ratelimit())
+				printk(KERN_WARNING "workqueue: too many "
+				       "workers (%d) on cpu %d, can't create "
+				       "new ones\n",
+				       gcwq->nr_workers, gcwq->cpu);
+			goto cooldown;
+		}
+
+		spin_unlock_irq(&gcwq->lock);
+
+		worker = create_worker(gcwq, true);
+		if (worker) {
+			del_timer_sync(&gcwq->mayday_timer);
+			spin_lock_irq(&gcwq->lock);
+			start_worker(worker);
+			BUG_ON(need_to_create_worker(gcwq));
+			return true;
+		}
+
+		if (!need_to_create_worker(gcwq))
+			break;
+	cooldown:
+		spin_unlock_irq(&gcwq->lock);
+		__set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(CREATE_COOLDOWN);
+		spin_lock_irq(&gcwq->lock);
+		if (!need_to_create_worker(gcwq))
+			break;
+	}
+
+	spin_unlock_irq(&gcwq->lock);
+	del_timer_sync(&gcwq->mayday_timer);
+	spin_lock_irq(&gcwq->lock);
+	if (need_to_create_worker(gcwq))
+		goto restart;
+	return true;
+}
+
+/**
+ * maybe_destroy_worker - destroy workers which have been idle for a while
+ * @gcwq: gcwq to destroy workers for
+ *
+ * Destroy @gcwq workers which have been idle for longer than
+ * IDLE_WORKER_TIMEOUT.
+ *
+ * LOCKING:
+ * spin_lock_irq(gcwq->lock) which may be released and regrabbed
+ * multiple times.  Called only from manager.
+ *
+ * RETURNS:
+ * false if no action was taken and gcwq->lock stayed locked, true
+ * otherwise.
+ */
+static bool maybe_destroy_workers(struct global_cwq *gcwq)
+{
+	bool ret = false;
+
+	while (too_many_workers(gcwq)) {
+		struct worker *worker;
+		unsigned long expires;
+
+		worker = list_entry(gcwq->idle_list.prev, struct worker, entry);
+		expires = worker->last_active + IDLE_WORKER_TIMEOUT;
+
+		if (time_before(jiffies, expires)) {
+			mod_timer(&gcwq->idle_timer, expires);
+			break;
+		}
+
+		destroy_worker(worker);
+		ret = true;
+	}
+
+	return ret;
+}
+
+/**
+ * manage_workers - manage worker pool
+ * @worker: self
+ *
+ * Assume the manager role and manage gcwq worker pool @worker belongs
+ * to.  At any given time, there can be only zero or one manager per
+ * gcwq.  The exclusion is handled automatically by this function.
+ *
+ * The caller can safely start processing works on false return.  On
+ * true return, it's guaranteed that need_to_create_worker() is false
+ * and may_start_working() is true.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock) which may be released and regrabbed
+ * multiple times.  Does GFP_KERNEL allocations.
+ *
+ * RETURNS:
+ * false if no action was taken and gcwq->lock stayed locked, true if
+ * some action was taken.
+ */
+static bool manage_workers(struct worker *worker)
+{
+	struct global_cwq *gcwq = worker->gcwq;
+	bool ret = false;
+
+	if (gcwq->flags & GCWQ_MANAGING_WORKERS)
+		return ret;
+
+	gcwq->flags &= ~GCWQ_MANAGE_WORKERS;
+	gcwq->flags |= GCWQ_MANAGING_WORKERS;
+
+	/* manager should never be accounted as running */
+	BUG_ON(worker->running);
+	worker->flags |= WORKER_MANAGER;
+
+	/*
+	 * Destroy and then create so that may_start_working() is true
+	 * on return.
+	 */
+	ret |= maybe_destroy_workers(gcwq);
+	ret |= maybe_create_worker(gcwq);
+
+	gcwq->flags &= ~GCWQ_MANAGING_WORKERS;
+	worker->flags &= ~WORKER_MANAGER;
+	BUG_ON(worker->running);
+
+	/*
+	 * The trustee might be waiting to take over the manager
+	 * position, tell it we're done.
+	 */
+	if (unlikely(gcwq->trustee))
+		wake_up_all(&gcwq->trustee_wait);
+
+	return ret;
 }
 
 /**
@@ -394,7 +1041,7 @@ static void destroy_worker(struct worker *worker)
  * be nested inside outer list_for_each_entry_safe().
  *
  * CONTEXT:
- * spin_lock_irq(cwq->lock).
+ * spin_lock_irq(gcwq->lock).
  */
 static void schedule_work_to_worker(struct worker *worker,
 				    struct work_struct *work,
@@ -431,7 +1078,7 @@ static void schedule_work_to_worker(struct worker *worker,
  * decrement nr_in_flight of its cwq and handle workqueue flushing.
  *
  * CONTEXT:
- * spin_lock_irq(cwq->lock).
+ * spin_lock_irq(gcwq->lock).
  */
 static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq,
 				 unsigned int work_color)
@@ -456,13 +1103,16 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq,
  * call this function to process a work.
  *
  * CONTEXT:
- * spin_lock_irq(cwq->lock) which is released and regrabbed.
+ * spin_lock_irq(gcwq->lock) which is released and regrabbed.
  */
 static void process_one_work(struct worker *worker, struct work_struct *work)
 {
-	struct cpu_workqueue_struct *cwq = worker->cwq;
+	struct cpu_workqueue_struct *cwq = get_wq_data(work);
+	struct global_cwq *gcwq = cwq->gcwq;
+	struct hlist_head *bwh = busy_worker_head(gcwq, work);
 	work_func_t f = work->func;
 	unsigned int work_color;
+	struct worker *collision;
 #ifdef CONFIG_LOCKDEP
 	/*
 	 * It is permissible to free the struct work_struct from
@@ -473,14 +1123,26 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 	 */
 	struct lockdep_map lockdep_map = work->lockdep_map;
 #endif
+	/*
+	 * A single work shouldn't be executed concurrently by
+	 * multiple workers on a single cpu.  Check whether anyone is
+	 * already processing the work.  If so, defer the work to the
+	 * currently executing one.
+	 */
+	collision = __find_worker_executing_work(gcwq, bwh, work);
+	if (unlikely(collision)) {
+		schedule_work_to_worker(collision, work, NULL);
+		return;
+	}
+
 	/* claim and process */
+	hlist_add_head(&worker->hentry, bwh);
 	worker->current_work = work;
 	work_color = *work_data_bits(work) & WORK_STRUCT_COLOR;
 	list_del_init(&work->entry);
 
-	spin_unlock_irq(&cwq->lock);
+	spin_unlock_irq(&gcwq->lock);
 
-	BUG_ON(get_wq_data(work) != cwq);
 	work_clear_pending(work);
 	lock_map_acquire(&cwq->wq->lockdep_map);
 	lock_map_acquire(&lockdep_map);
@@ -498,9 +1160,10 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 		dump_stack();
 	}
 
-	spin_lock_irq(&cwq->lock);
+	spin_lock_irq(&gcwq->lock);
 
 	/* we're done with it, release */
+	hlist_del_init(&worker->hentry);
 	worker->current_work = NULL;
 	cwq_dec_nr_in_flight(cwq, work_color);
 }
@@ -514,7 +1177,7 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
  * fetches a work from the top and executes it.
  *
  * CONTEXT:
- * spin_lock_irq(cwq->lock) which may be released and regrabbed
+ * spin_lock_irq(gcwq->lock) which may be released and regrabbed
  * multiple times.
  */
 static void process_scheduled_works(struct worker *worker)
@@ -530,36 +1193,60 @@ static void process_scheduled_works(struct worker *worker)
  * worker_thread - the worker thread function
  * @__worker: self
  *
- * The cwq worker thread function.
+ * The gcwq worker thread function.  There's a single dynamic pool of
+ * these per each cpu.  These workers process all works regardless of
+ * their specific target workqueue.  The only exception is works which
+ * belong to workqueues with a rescuer which will be explained in
+ * rescuer_thread().
  */
 static int worker_thread(void *__worker)
 {
 	struct worker *worker = __worker;
-	struct cpu_workqueue_struct *cwq = worker->cwq;
-	DEFINE_WAIT(wait);
-
-	/* set workqueue scheduler */
-	switch_sched_workqueue(current, true);
-
-	if (cwq->wq->flags & WQ_FREEZEABLE)
-		set_freezable();
+	struct global_cwq *gcwq = worker->gcwq;
+	atomic_t *nr_running = get_gcwq_nr_running(gcwq->cpu);
+
+	/* set workqueue scheduler and adjust nice level */
+	switch_sched_workqueue(worker->task, true);
+woke_up:
+	spin_lock_irq(&gcwq->lock);
+
+	/* DIE can be set only while we're idle, checking here is enough */
+	if (worker->flags & WORKER_DIE) {
+		spin_unlock_irq(&gcwq->lock);
+		switch_sched_workqueue(worker->task, false);
+		return 0;
+	}
 
-	for (;;) {
-		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
-		if (!freezing(current) &&
-		    !kthread_should_stop() &&
-		    list_empty(&cwq->worklist))
-			schedule();
-		finish_wait(&cwq->more_work, &wait);
+	worker_leave_idle(worker);
+repeat:
+	if (need_more_worker(gcwq)) {
+		if (unlikely(!may_start_working(gcwq)) &&
+		    manage_workers(worker))
+			goto repeat;
 
-		if (kthread_should_stop())
-			break;
+		/*
+		 * ->scheduled list can only be filled while a worker
+		 * is preparing to process a work or actually
+		 * processing it.  Make sure nobody diddled with it
+		 * while I was sleeping.  Also, nobody should have set
+		 * running till this point.
+		 */
+		BUG_ON(!list_empty(&worker->scheduled));
+		BUG_ON(worker->running);
 
-		spin_lock_irq(&cwq->lock);
+		/*
+		 * When control reaches this point, we're guaranteed
+		 * to have at least one idle worker or that someone
+		 * else has already assumed the manager role.
+		 */
+		if (likely(!(worker->flags & WORKER_IGN_RUNNING))) {
+			worker->running = true;
+			atomic_inc(nr_running);
+		}
 
-		while (!list_empty(&cwq->worklist)) {
+		do {
 			struct work_struct *work =
-				list_first_entry(&cwq->worklist,
+				list_first_entry(&gcwq->worklist,
 						 struct work_struct, entry);
 
 			if (likely(!(*work_data_bits(work) &
@@ -572,12 +1259,145 @@ static int worker_thread(void *__worker)
 				schedule_work_to_worker(worker, work, NULL);
 				process_scheduled_works(worker);
 			}
+		} while (keep_working(gcwq));
+
+		if (likely(worker->running)) {
+			worker->running = false;
+			atomic_dec(nr_running);
 		}
+	}
+
+	if (unlikely(need_to_manage_workers(gcwq)) && manage_workers(worker))
+		goto repeat;
+
+	/*
+	 * gcwq->lock is held and there's no work to process and no
+	 * need to manage, sleep.  Workers are woken up only while
+	 * holding gcwq->lock or from local cpu, so setting the
+	 * current state before releasing gcwq->lock is enough to
+	 * prevent losing any event.
+	 */
+	worker_enter_idle(worker);
+	__set_current_state(TASK_INTERRUPTIBLE);
+	spin_unlock_irq(&gcwq->lock);
+	schedule();
+	goto woke_up;
+}
+
+/**
+ * worker_maybe_bind_and_lock - bind worker to its cpu if possible and lock gcwq
+ * @worker: target worker
+ *
+ * Works which are scheduled while the cpu is online must at least be
+ * scheduled to a worker which is bound to the cpu so that if they are
+ * flushed from cpu callbacks while cpu is going down, they are
+ * guaranteed to execute on the cpu.
+ *
+ * This function is to be used to bind rescuers and new rogue workers
+ * to the target cpu and may race with cpu going down or coming
+ * online.  kthread_bind() can't be used because it may put the worker
+ * to already dead cpu and force_cpus_allowed_ptr() can't be used
+ * verbatim as it's best effort and blocking and gcwq may be
+ * [dis]associated in the meantime.
+ *
+ * This function tries force_cpus_allowed_ptr() and locks gcwq and
+ * verifies the binding against GCWQ_DISASSOCIATED which is set during
+ * CPU_DYING and cleared during CPU_ONLINE, so if the worker enters
+ * idle state or fetches works without dropping lock, it can guarantee
+ * the scheduling requirement described in the first paragraph.
+ *
+ * CONTEXT:
+ * Might sleep.  Called without any lock but returns with gcwq->lock
+ * held.
+ */
+static void worker_maybe_bind_and_lock(struct worker *worker)
+{
+	struct global_cwq *gcwq = worker->gcwq;
+	struct task_struct *task = worker->task;
 
-		spin_unlock_irq(&cwq->lock);
+	while (true) {
+		/*
+		 * The following call may fail, succeed or succeed
+		 * without actually migrating the task to the cpu if
+		 * it races with cpu hotunplug operation.  Verify
+		 * against GCWQ_DISASSOCIATED.
+		 */
+		force_cpus_allowed_ptr(task, get_cpu_mask(gcwq->cpu));
+
+		spin_lock_irq(&gcwq->lock);
+		if (gcwq->flags & GCWQ_DISASSOCIATED)
+			return;
+		if (task_cpu(task) == gcwq->cpu &&
+		    cpumask_equal(&current->cpus_allowed,
+				  get_cpu_mask(gcwq->cpu)))
+			return;
+		spin_unlock_irq(&gcwq->lock);
+
+		/* CPU has come up inbetween, retry migration */
+		cpu_relax();
 	}
+}
 
-	return 0;
+/**
+ * rescuer_thread - the rescuer thread function
+ * @__wq: the associated workqueue
+ *
+ * Workqueue rescuer thread function.  There's one rescuer for each
+ * workqueue which has WQ_RESCUER set.
+ *
+ * Regular work processing on a gcwq may block trying to create a new
+ * worker which uses GFP_KERNEL allocation which has slight chance of
+ * developing into deadlock if some works currently on the same queue
+ * need to be processed to satisfy the GFP_KERNEL allocation.  This is
+ * the problem rescuer solves.
+ *
+ * When such condition is possible, the gcwq summons rescuers of all
+ * workqueues which have works queued on the gcwq and let them process
+ * those works so that forward progress can be guaranteed.
+ *
+ * This should happen rarely.
+ */
+static int rescuer_thread(void *__wq)
+{
+	struct workqueue_struct *wq = __wq;
+	struct worker *rescuer = wq->rescuer;
+	unsigned int cpu;
+
+	rescuer->flags |= WORKER_RESCUER;
+	set_user_nice(current, RESCUER_NICE_LEVEL);
+repeat:
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	if (kthread_should_stop())
+		return 0;
+
+	for_each_cpu(cpu, wq->mayday_mask) {
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		struct global_cwq *gcwq = cwq->gcwq;
+		struct work_struct *work, *n;
+
+		__set_current_state(TASK_RUNNING);
+		cpumask_clear_cpu(cpu, wq->mayday_mask);
+
+		/* migrate to the target cpu if possible */
+		rescuer->gcwq = gcwq;
+		worker_maybe_bind_and_lock(rescuer);
+
+		/*
+		 * Slurp in all works issued via this workqueue and
+		 * process'em.
+		 */
+		BUG_ON(!list_empty(&rescuer->scheduled));
+		list_for_each_entry_safe(work, n, &gcwq->worklist, entry)
+			if (get_wq_data(work) == cwq)
+				schedule_work_to_worker(rescuer, work, &n);
+
+		process_scheduled_works(rescuer);
+		spin_unlock_irq(&gcwq->lock);
+	}
+
+	schedule();
+	goto repeat;
 }
 
 struct wq_barrier {
@@ -609,7 +1429,7 @@ static void wq_barrier_func(struct work_struct *work)
  * after a work with LINKED flag set.
  *
  * CONTEXT:
- * spin_lock_irq(cwq->lock).
+ * spin_lock_irq(gcwq->lock).
  */
 static void insert_wq_barrier(struct wq_barrier *barr,
 			      struct work_struct *target, struct worker *worker)
@@ -668,8 +1488,9 @@ void flush_workqueue(struct workqueue_struct *wq)
 
 	for_each_possible_cpu(cpu) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		struct global_cwq *gcwq = cwq->gcwq;
 
-		spin_lock_irq(&cwq->lock);
+		spin_lock_irq(&gcwq->lock);
 
 		BUG_ON(cwq->flush_cnt);
 
@@ -681,7 +1502,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 			wait = true;
 		}
 
-		spin_unlock_irq(&cwq->lock);
+		spin_unlock_irq(&gcwq->lock);
 	}
 
 	if (wait)
@@ -707,17 +1528,19 @@ int flush_work(struct work_struct *work)
 {
 	struct worker *worker = NULL;
 	struct cpu_workqueue_struct *cwq;
+	struct global_cwq *gcwq;
 	struct wq_barrier barr;
 
 	might_sleep();
 	cwq = get_wq_data(work);
 	if (!cwq)
 		return 0;
+	gcwq = cwq->gcwq;
 
 	lock_map_acquire(&cwq->wq->lockdep_map);
 	lock_map_release(&cwq->wq->lockdep_map);
 
-	spin_lock_irq(&cwq->lock);
+	spin_lock_irq(&gcwq->lock);
 	if (!list_empty(&work->entry)) {
 		/*
 		 * See the comment near try_to_grab_pending()->smp_rmb().
@@ -727,18 +1550,17 @@ int flush_work(struct work_struct *work)
 		if (unlikely(cwq != get_wq_data(work)))
 			goto already_gone;
 	} else {
-		if (cwq->worker && cwq->worker->current_work == work)
-			worker = cwq->worker;
+		worker = find_worker_executing_work(gcwq, work);
 		if (!worker)
 			goto already_gone;
 	}
 
 	insert_wq_barrier(&barr, work, worker);
-	spin_unlock_irq(&cwq->lock);
+	spin_unlock_irq(&gcwq->lock);
 	wait_for_completion(&barr.done);
 	return 1;
 already_gone:
-	spin_unlock_irq(&cwq->lock);
+	spin_unlock_irq(&gcwq->lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(flush_work);
@@ -749,6 +1571,7 @@ EXPORT_SYMBOL_GPL(flush_work);
  */
 static int try_to_grab_pending(struct work_struct *work)
 {
+	struct global_cwq *gcwq;
 	struct cpu_workqueue_struct *cwq;
 	int ret = -1;
 
@@ -763,8 +1586,9 @@ static int try_to_grab_pending(struct work_struct *work)
 	cwq = get_wq_data(work);
 	if (!cwq)
 		return ret;
+	gcwq = cwq->gcwq;
 
-	spin_lock_irq(&cwq->lock);
+	spin_lock_irq(&gcwq->lock);
 	if (!list_empty(&work->entry)) {
 		/*
 		 * This work is queued, but perhaps we locked the wrong cwq.
@@ -779,7 +1603,7 @@ static int try_to_grab_pending(struct work_struct *work)
 			ret = 1;
 		}
 	}
-	spin_unlock_irq(&cwq->lock);
+	spin_unlock_irq(&gcwq->lock);
 
 	return ret;
 }
@@ -787,18 +1611,17 @@ static int try_to_grab_pending(struct work_struct *work)
 static void wait_on_cpu_work(struct cpu_workqueue_struct *cwq,
 				struct work_struct *work)
 {
+	struct global_cwq *gcwq = cwq->gcwq;
 	struct wq_barrier barr;
 	struct worker *worker;
 
-	spin_lock_irq(&cwq->lock);
+	spin_lock_irq(&gcwq->lock);
 
-	worker = NULL;
-	if (unlikely(cwq->worker && cwq->worker->current_work == work)) {
-		worker = cwq->worker;
+	worker = find_worker_executing_work(gcwq, work);
+	if (unlikely(worker))
 		insert_wq_barrier(&barr, work, worker);
-	}
 
-	spin_unlock_irq(&cwq->lock);
+	spin_unlock_irq(&gcwq->lock);
 
 	if (unlikely(worker))
 		wait_for_completion(&barr.done);
@@ -1026,7 +1849,6 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 						const char *lock_name)
 {
 	struct workqueue_struct *wq;
-	bool failed = false;
 	unsigned int cpu;
 
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
@@ -1044,58 +1866,55 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	INIT_LIST_HEAD(&wq->list);
 
-	cpu_maps_update_begin();
-	/*
-	 * We must place this wq on list even if the code below fails.
-	 * cpu_down(cpu) can remove cpu from cpu_populated_map before
-	 * destroy_workqueue() takes the lock, in that case we leak
-	 * cwq[cpu]->thread.
-	 */
-	spin_lock(&workqueue_lock);
-	list_add(&wq->list, &workqueues);
 	for_each_possible_cpu(cpu) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		struct global_cwq *gcwq = get_gcwq(cpu);
 
-		if (workqueue_frozen && wq->flags & WQ_FREEZEABLE)
-			cwq->cur_worklist = &cwq->frozen_works;
-		else
-			cwq->cur_worklist = &cwq->worklist;
-	}
-	spin_unlock(&workqueue_lock);
-	/*
-	 * We must initialize cwqs for each possible cpu even if we
-	 * are going to call destroy_workqueue() finally. Otherwise
-	 * cpu_up() can hit the uninitialized cwq once we drop the
-	 * lock.
-	 */
-	for_each_possible_cpu(cpu) {
-		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
-
-		cwq->cpu = cpu;
+		BUG_ON((unsigned long)cwq & WORK_STRUCT_FLAG_MASK);
+		cwq->gcwq = gcwq;
+		cwq->cur_worklist = &gcwq->worklist;
 		cwq->wq = wq;
-		spin_lock_init(&cwq->lock);
-		INIT_LIST_HEAD(&cwq->worklist);
-		init_waitqueue_head(&cwq->more_work);
 		INIT_LIST_HEAD(&cwq->frozen_works);
-
-		if (failed || !cpu_online(cpu))
-			continue;
-		cwq->worker = create_worker(cwq, true);
-		if (cwq->worker)
-			start_worker(cwq->worker);
-		else
-			failed = true;
 	}
-	cpu_maps_update_done();
 
-	if (failed) {
-		destroy_workqueue(wq);
-		wq = NULL;
+	if (flags & WQ_RESCUER) {
+		struct worker *rescuer;
+
+		if (!alloc_cpumask_var(&wq->mayday_mask, GFP_KERNEL))
+			goto err;
+
+		wq->rescuer = rescuer = alloc_worker();
+		if (!rescuer)
+			goto err;
+
+		rescuer->task = kthread_create(rescuer_thread, wq, "%s", name);
+		if (IS_ERR(rescuer->task))
+			goto err;
+
+		wq->rescuer = rescuer;
+		rescuer->task->flags |= PF_THREAD_BOUND;
+		wake_up_process(rescuer->task);
 	}
+
+	/*
+	 * Works can't be queued before we return.  Add to workqueue
+	 * list and set cur_worklist to frozen_works if frozen.
+	 */
+	spin_lock(&workqueue_lock);
+	list_add(&wq->list, &workqueues);
+	if (workqueue_frozen && wq->flags & WQ_FREEZEABLE)
+		for_each_possible_cpu(cpu) {
+			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+			cwq->cur_worklist = &cwq->frozen_works;
+		}
+	spin_unlock(&workqueue_lock);
+
 	return wq;
 err:
 	if (wq) {
 		free_percpu(wq->cpu_wq);
+		free_cpumask_var(wq->mayday_mask);
+		kfree(wq->rescuer);
 		kfree(wq);
 	}
 	return NULL;
@@ -1110,9 +1929,7 @@ EXPORT_SYMBOL_GPL(__create_workqueue_key);
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
-	int cpu;
-
-	cpu_maps_update_begin();
+	unsigned int cpu;
 
 	flush_workqueue(wq);
 
@@ -1124,70 +1941,400 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
+	/* sanity check */
 	for_each_possible_cpu(cpu) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
-
-		/* cpu_add_remove_lock protects cwq->thread */
-		if (cwq->worker) {
-			destroy_worker(cwq->worker);
-			cwq->worker = NULL;
-		}
 		BUG_ON(cwq->nr_in_flight);
 		BUG_ON(!list_empty(&cwq->frozen_works));
 	}
 
- 	cpu_maps_update_done();
+	if (wq->flags & WQ_RESCUER) {
+		kthread_stop(wq->rescuer->task);
+		free_cpumask_var(wq->mayday_mask);
+	}
 
 	free_percpu(wq->cpu_wq);
 	kfree(wq);
 }
 EXPORT_SYMBOL_GPL(destroy_workqueue);
 
-static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
-						unsigned long action,
-						void *hcpu)
+/*
+ * CPU hotplug.
+ *
+ * There are two challenges in supporting CPU hotplug.  Firstly, there
+ * are a lot of assumptions on strong associations among work, cwq and
+ * gcwq which make migrating pending and scheduled works very
+ * difficult to implement without impacting hot paths.  Secondly,
+ * gcwqs serve mix of short, long and very long running works making
+ * blocked draining impractical.
+ *
+ * This is solved by allowing a gcwq to be detached from CPU, running
+ * it with unbound (rogue) workers and allowing it to be reattached
+ * later if the cpu comes back online.  A separate thread is created
+ * to govern a gcwq in such state and is called the trustee of the
+ * gcwq.
+ *
+ * Trustee states and their descriptions.
+ *
+ * START	Command state used on startup.  On CPU_DOWN_PREPARE, a
+ *		new trustee is started with this state.
+ *
+ * IN_CHARGE	Once started, trustee will enter this state after
+ *		assuming the manager role and making all existing
+ *		workers rogue.  DOWN_PREPARE waits for trustee to
+ *		enter this state.  After reaching IN_CHARGE, trustee
+ *		tries to execute the pending worklist until it's empty
+ *		and the state is set to BUTCHER, or the state is set
+ *		to RELEASE.
+ *
+ * BUTCHER	Command state which is set by the cpu callback after
+ *		the cpu has went down.  Once this state is set trustee
+ *		knows that there will be no new works on the worklist
+ *		and once the worklist is empty it can proceed to
+ *		killing idle workers.
+ *
+ * RELEASE	Command state which is set by the cpu callback if the
+ *		cpu down has been canceled or it has come online
+ *		again.  After recognizing this state, trustee stops
+ *		trying to drain or butcher and clears ROGUE, rebinds
+ *		all remaining workers back to the cpu and releases
+ *		manager role.
+ *
+ * DONE		Trustee will enter this state after BUTCHER or RELEASE
+ *		is complete.
+ *
+ *          trustee                 CPU                draining
+ *         took over                down               complete
+ * START -----------> IN_CHARGE -----------> BUTCHER -----------> DONE
+ *                        |                     |                  ^
+ *                        | CPU is back online  v   return workers |
+ *                         ----------------> RELEASE --------------
+ */
+
+#define for_each_busy_worker(worker, i, pos, gcwq)			\
+	for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)			\
+		hlist_for_each_entry(worker, pos, &gcwq->busy_hash[i], hentry) \
+			if (!(worker->flags & WORKER_RESCUER))
+
+/**
+ * trustee_wait_event_timeout - timed event wait for trustee
+ * @cond: condition to wait for
+ * @timeout: timeout in jiffies
+ *
+ * wait_event_timeout() for trustee to use.  Handles locking and
+ * checks for RELEASE request.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock) which may be released and regrabbed
+ * multiple times.  To be used by trustee.
+ *
+ * RETURNS:
+ * Positive indicating left time if @cond is satisfied, 0 if timed
+ * out, -1 if canceled.
+ */
+#define trustee_wait_event_timeout(cond, timeout) ({			\
+	long __ret = (timeout);						\
+	while (!((cond) || (gcwq->trustee_state == TRUSTEE_RELEASE)) &&	\
+	       __ret) {							\
+		spin_unlock_irq(&gcwq->lock);				\
+		__wait_event_timeout(gcwq->trustee_wait, (cond) ||	\
+			(gcwq->trustee_state == TRUSTEE_RELEASE),	\
+			__ret);						\
+		spin_lock_irq(&gcwq->lock);				\
+	}								\
+	gcwq->trustee_state == TRUSTEE_RELEASE ? -1 : (__ret);		\
+})
+
+/**
+ * trustee_wait_event - event wait for trustee
+ * @cond: condition to wait for
+ *
+ * wait_event() for trustee to use.  Automatically handles locking and
+ * checks for CANCEL request.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock) which may be released and regrabbed
+ * multiple times.  To be used by trustee.
+ *
+ * RETURNS:
+ * 0 if @cond is satisfied, -1 if canceled.
+ */
+#define trustee_wait_event(cond) ({					\
+	long __ret1;							\
+	__ret1 = trustee_wait_event_timeout(cond, MAX_SCHEDULE_TIMEOUT);\
+	__ret1 < 0 ? -1 : 0;						\
+})
+
+static bool __cpuinit trustee_unset_rogue(struct worker *worker)
 {
-	unsigned int cpu = (unsigned long)hcpu;
-	struct cpu_workqueue_struct *cwq;
-	struct workqueue_struct *wq;
-	int ret = NOTIFY_OK;
+	struct global_cwq *gcwq = worker->gcwq;
 
-	action &= ~CPU_TASKS_FROZEN;
+	if (!(worker->flags & WORKER_ROGUE))
+		return false;
+
+	spin_unlock_irq(&gcwq->lock);
+	BUG_ON(force_cpus_allowed_ptr(worker->task, get_cpu_mask(gcwq->cpu)));
+	spin_lock_irq(&gcwq->lock);
+	worker->flags &= ~WORKER_ROGUE;
+	return true;
+}
+
+static int __cpuinit trustee_thread(void *__gcwq)
+{
+	struct global_cwq *gcwq = __gcwq;
+	atomic_t *nr_running = get_gcwq_nr_running(gcwq->cpu);
+	struct worker *worker;
+	struct work_struct *work;
+	struct hlist_node *pos;
+	int i;
+
+	BUG_ON(gcwq->cpu != smp_processor_id());
+
+	spin_lock_irq(&gcwq->lock);
+	/*
+	 * Claim the manager position and make all workers rogue.
+	 * Trustee must be bound to the target cpu and can't be
+	 * cancelled.
+	 */
+	BUG_ON(gcwq->cpu != smp_processor_id());
+	BUG_ON(trustee_wait_event(!(gcwq->flags & GCWQ_MANAGING_WORKERS)) < 0);
+	gcwq->flags |= GCWQ_MANAGING_WORKERS;
+
+	list_for_each_entry(worker, &gcwq->idle_list, entry)
+		worker->flags |= WORKER_ROGUE;
+
+	for_each_busy_worker(worker, i, pos, gcwq)
+		worker->flags |= WORKER_ROGUE;
+
+	/*
+	 * Call schedule() so that we cross rq->lock and thus can
+	 * guarantee sched callbacks see the rogue flag.  This is
+	 * necessary as scheduler callbacks may be invoked from other
+	 * cpus.
+	 */
+	spin_unlock_irq(&gcwq->lock);
+	schedule();
+	spin_lock_irq(&gcwq->lock);
+
+	/*
+	 * Sched callbacks are disabled now.  Clear running and adjust
+	 * nr_running accordingly.  After this, gcwq->nr_running stays
+	 * zero and need_more_worker() and keep_working() are always
+	 * true as long as the worklist is not empty.
+	 */
+	for_each_busy_worker(worker, i, pos, gcwq)
+		if (worker->running) {
+			worker->running = false;
+			atomic_dec(nr_running);
+		}
+	WARN_ON(atomic_read(nr_running));
+
+	spin_unlock_irq(&gcwq->lock);
+	del_timer_sync(&gcwq->idle_timer);
+	spin_lock_irq(&gcwq->lock);
+
+	/*
+	 * We're now in charge.  Notify and proceed to drain.  We need
+	 * to keep the gcwq running during the whole CPU down
+	 * procedure as other cpu hotunplug callbacks may need to
+	 * flush currently running tasks.
+	 */
+	gcwq->trustee_state = TRUSTEE_IN_CHARGE;
+	wake_up_all(&gcwq->trustee_wait);
+
+	/*
+	 * The original cpu is in the process of dying and may go away
+	 * anytime now.  When that happens, we and all workers would
+	 * be migrated to other cpus.  Try draining any left work.  We
+	 * want to get it over with ASAP - spam rescuers, wake up as
+	 * many idlers as necessary and create new ones till the
+	 * worklist is empty.
+	 */
+	while (!list_empty(&gcwq->worklist) ||
+	       gcwq->trustee_state == TRUSTEE_IN_CHARGE) {
+		int nr_works = 0;
 
-undo:
-	list_for_each_entry(wq, &workqueues, list) {
-		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+		list_for_each_entry(work, &gcwq->worklist, entry) {
+			send_mayday(work);
+			nr_works++;
+		}
 
-		switch (action) {
-		case CPU_UP_PREPARE:
-			cwq->worker = create_worker(cwq, false);
-			if (cwq->worker)
+		list_for_each_entry(worker, &gcwq->idle_list, entry) {
+			if (!nr_works--)
 				break;
-			printk(KERN_ERR "workqueue [%s] for %i failed\n",
-				wq->name, cpu);
-			action = CPU_UP_CANCELED;
-			ret = NOTIFY_BAD;
-			goto undo;
-
-		case CPU_ONLINE:
-			kthread_bind(cwq->worker->task, cpu);
-			start_worker(cwq->worker);
+			wake_up_process(worker->task);
+		}
+
+		if (need_to_create_worker(gcwq) &&
+		    gcwq->nr_workers < MAX_WORKERS_PER_CPU) {
+			spin_unlock_irq(&gcwq->lock);
+			worker = create_worker(gcwq, false);
+			if (worker) {
+				worker_maybe_bind_and_lock(worker);
+				worker->flags |= WORKER_ROGUE;
+				start_worker(worker);
+			} else
+				spin_lock_irq(&gcwq->lock);
+		}
+
+		/* give a breather */
+		if (trustee_wait_event_timeout(false, TRUSTEE_COOLDOWN) < 0)
 			break;
+	}
 
-		case CPU_UP_CANCELED:
-			start_worker(cwq->worker);
-		case CPU_POST_DEAD:
-			flush_workqueue(wq);
-			/* cpu_add_remove_lock protects cwq->thread */
-			if (cwq->worker) {
-				destroy_worker(cwq->worker);
-				cwq->worker = NULL;
-			}
+	/*
+	 * Either all works have been scheduled and cpu is down, or
+	 * cpu down has already been canceled.  Wait for and butcher
+	 * all workers till we're canceled.
+	 */
+	while (gcwq->nr_workers) {
+		if (trustee_wait_event(!list_empty(&gcwq->idle_list)) < 0)
 			break;
+
+		while (!list_empty(&gcwq->idle_list)) {
+			worker = list_first_entry(&gcwq->idle_list,
+						  struct worker, entry);
+			destroy_worker(worker);
 		}
 	}
 
-	return ret;
+	/*
+	 * At this point, either draining has completed and no worker
+	 * is left, or cpu down has been canceled or the cpu is being
+	 * brought back up.  Clear ROGUE from and rebind all left
+	 * workers.  Unsetting ROGUE and rebinding require dropping
+	 * gcwq->lock.  Restart loop after each successful release.
+	 */
+recheck:
+	list_for_each_entry(worker, &gcwq->idle_list, entry)
+		if (trustee_unset_rogue(worker))
+			goto recheck;
+
+	for_each_busy_worker(worker, i, pos, gcwq)
+		if (trustee_unset_rogue(worker))
+			goto recheck;
+
+	/* relinquish manager role */
+	gcwq->flags &= ~GCWQ_MANAGING_WORKERS;
+
+	/* notify completion */
+	gcwq->trustee = NULL;
+	gcwq->trustee_state = TRUSTEE_DONE;
+	wake_up_all(&gcwq->trustee_wait);
+	spin_unlock_irq(&gcwq->lock);
+	return 0;
+}
+
+/**
+ * wait_trustee_state - wait for trustee to enter the specified state
+ * @gcwq: gcwq the trustee of interest belongs to
+ * @state: target state to wait for
+ *
+ * Wait for the trustee to reach @state.  DONE is already matched.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock) which may be released and regrabbed
+ * multiple times.  To be used by cpu_callback.
+ */
+static void __cpuinit wait_trustee_state(struct global_cwq *gcwq, int state)
+{
+	if (!(gcwq->trustee_state == state ||
+	      gcwq->trustee_state == TRUSTEE_DONE)) {
+		spin_unlock_irq(&gcwq->lock);
+		__wait_event(gcwq->trustee_wait,
+			     gcwq->trustee_state == state ||
+			     gcwq->trustee_state == TRUSTEE_DONE);
+		spin_lock_irq(&gcwq->lock);
+	}
+}
+
+static int __cpuinit workqueue_cpu_callback(struct notifier_block *nfb,
+						unsigned long action,
+						void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+	struct global_cwq *gcwq = get_gcwq(cpu);
+	struct task_struct *new_trustee = NULL;
+	struct worker *uninitialized_var(new_worker);
+
+	action &= ~CPU_TASKS_FROZEN;
+
+	switch (action) {
+	case CPU_DOWN_PREPARE:
+		new_trustee = kthread_create(trustee_thread, gcwq,
+					     "workqueue_trustee/%d\n", cpu);
+		if (IS_ERR(new_trustee))
+			return NOTIFY_BAD;
+		kthread_bind(new_trustee, cpu);
+		/* fall through */
+	case CPU_UP_PREPARE:
+		BUG_ON(gcwq->first_idle);
+		new_worker = create_worker(gcwq, false);
+		if (!new_worker) {
+			if (new_trustee)
+				kthread_stop(new_trustee);
+			return NOTIFY_BAD;
+		}
+	}
+
+	spin_lock_irq(&gcwq->lock);
+
+	switch (action) {
+	case CPU_DOWN_PREPARE:
+		/* initialize trustee and tell it to acquire the gcwq */
+		BUG_ON(gcwq->trustee || gcwq->trustee_state != TRUSTEE_DONE);
+		gcwq->trustee = new_trustee;
+		gcwq->trustee_state = TRUSTEE_START;
+		wake_up_process(gcwq->trustee);
+		wait_trustee_state(gcwq, TRUSTEE_IN_CHARGE);
+		/* fall through */
+	case CPU_UP_PREPARE:
+		BUG_ON(gcwq->first_idle);
+		gcwq->first_idle = new_worker;
+		break;
+
+	case CPU_DYING:
+		/*
+		 * Before this, the trustee and all workers must have
+		 * stayed on the cpu.  After this, they'll all be
+		 * diasporas.
+		 */
+		gcwq->flags |= GCWQ_DISASSOCIATED;
+		break;
+
+	case CPU_POST_DEAD:
+		gcwq->trustee_state = TRUSTEE_BUTCHER;
+		/* fall through */
+	case CPU_UP_CANCELED:
+		destroy_worker(gcwq->first_idle);
+		gcwq->first_idle = NULL;
+		break;
+
+	case CPU_DOWN_FAILED:
+	case CPU_ONLINE:
+		gcwq->flags &= ~GCWQ_DISASSOCIATED;
+		if (gcwq->trustee_state != TRUSTEE_DONE) {
+			gcwq->trustee_state = TRUSTEE_RELEASE;
+			wake_up_process(gcwq->trustee);
+			wait_trustee_state(gcwq, TRUSTEE_DONE);
+		}
+		/*
+		 * Trustee is done and there might be no worker left.
+		 * Put the first_idle in and request a real manager to
+		 * take a look.
+		 */
+		spin_unlock_irq(&gcwq->lock);
+		kthread_bind(gcwq->first_idle->task, cpu);
+		spin_lock_irq(&gcwq->lock);
+		gcwq->flags |= GCWQ_MANAGE_WORKERS;
+		start_worker(gcwq->first_idle);
+		gcwq->first_idle = NULL;
+		break;
+	}
+
+	spin_unlock_irq(&gcwq->lock);
+
+	return NOTIFY_OK;
 }
 
 #ifdef CONFIG_SMP
@@ -1243,10 +2390,10 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
  *
  * Start freezing workqueues.  After this function returns, all
  * freezeable workqueues will queue new works to their frozen_works
- * list instead of the cwq ones.
+ * list instead of the gcwq ones.
  *
  * CONTEXT:
- * Grabs and releases workqueue_lock and cwq->lock's.
+ * Grabs and releases workqueue_lock and gcwq->lock's.
  */
 void freeze_workqueues_begin(void)
 {
@@ -1259,21 +2406,22 @@ void freeze_workqueues_begin(void)
 	workqueue_frozen = true;
 
 	for_each_possible_cpu(cpu) {
+		struct global_cwq *gcwq = get_gcwq(cpu);
+
+		spin_lock_irq(&gcwq->lock);
+
 		list_for_each_entry(wq, &workqueues, list) {
 			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 
 			if (!(wq->flags & WQ_FREEZEABLE))
 				continue;
 
-			spin_lock_irq(&cwq->lock);
-
-			BUG_ON(cwq->cur_worklist != &cwq->worklist);
+			BUG_ON(cwq->cur_worklist != &gcwq->worklist);
 			BUG_ON(!list_empty(&cwq->frozen_works));
 
 			cwq->cur_worklist = &cwq->frozen_works;
-
-			spin_unlock_irq(&cwq->lock);
 		}
+		spin_unlock_irq(&gcwq->lock);
 	}
 	spin_unlock(&workqueue_lock);
 }
@@ -1302,6 +2450,10 @@ bool freeze_workqueues_busy(void)
 	BUG_ON(!workqueue_frozen);
 
 	for_each_possible_cpu(cpu) {
+		struct global_cwq *gcwq = get_gcwq(cpu);
+
+		spin_lock_irq(&gcwq->lock);
+
 		list_for_each_entry(wq, &workqueues, list) {
 			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 			struct work_struct *work;
@@ -1310,22 +2462,19 @@ bool freeze_workqueues_busy(void)
 			if (!(wq->flags & WQ_FREEZEABLE))
 				continue;
 
-			spin_lock_irq(&cwq->lock);
-
 			BUG_ON(cwq->cur_worklist != &cwq->frozen_works);
 
 			nr_in_flight = cwq->nr_in_flight;
 			list_for_each_entry(work, &cwq->frozen_works, entry)
 				nr_in_flight--;
 
-			spin_unlock_irq(&cwq->lock);
-
 			BUG_ON(nr_in_flight < 0);
 			if (nr_in_flight) {
 				busy = true;
 				break;
 			}
 		}
+		spin_unlock_irq(&gcwq->lock);
 		if (busy)
 			break;
 	}
@@ -1337,10 +2486,10 @@ bool freeze_workqueues_busy(void)
  * thaw_workqueues - thaw workqueues
  *
  * Thaw workqueues.  Normal queueing is restored and all collected
- * frozen works are transferred to their respective cwq worklists.
+ * frozen works are transferred to their respective gcwq worklists.
  *
  * CONTEXT:
- * Grabs and releases workqueue_lock and cwq->lock's.
+ * Grabs and releases workqueue_lock and gcwq->lock's.
  */
 void thaw_workqueues(void)
 {
@@ -1355,25 +2504,28 @@ void thaw_workqueues(void)
 	workqueue_frozen = false;
 
 	for_each_possible_cpu(cpu) {
+		struct global_cwq *gcwq = get_gcwq(cpu);
+
+		spin_lock_irq(&gcwq->lock);
+
 		list_for_each_entry(wq, &workqueues, list) {
 			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 
 			if (!(wq->flags & WQ_FREEZEABLE))
 				continue;
 
-			spin_lock_irq(&cwq->lock);
-
 			/* switch to normal work queueing */
 			BUG_ON(cwq->cur_worklist != &cwq->frozen_works);
-			cwq->cur_worklist = &cwq->worklist;
+			cwq->cur_worklist = &gcwq->worklist;
 
-			/* transfer frozen tasks to cwq worklist */
-			list_splice_tail(&cwq->frozen_works, &cwq->worklist);
+			/* transfer frozen tasks to gcwq worklist */
+			list_splice_tail(&cwq->frozen_works, &gcwq->worklist);
 			INIT_LIST_HEAD(&cwq->frozen_works);
-			wake_up(&cwq->more_work);
-
-			spin_unlock_irq(&cwq->lock);
 		}
+
+		wake_up_worker(gcwq);
+
+		spin_unlock_irq(&gcwq->lock);
 	}
 out_unlock:
 	spin_unlock(&workqueue_lock);
@@ -1382,16 +2534,46 @@ out_unlock:
 
 void __init init_workqueues(void)
 {
-	/*
-	 * cwqs are forced aligned according to WORK_STRUCT_FLAG_BITS.
-	 * Make sure that the alignment isn't lower than that of
-	 * unsigned long long in case this code survives for longer
-	 * than twenty years.  :-P
-	 */
-	BUILD_BUG_ON(__alignof__(struct cpu_workqueue_struct) <
-		     __alignof__(unsigned long long));
+	unsigned int cpu;
+	int i;
 
 	hotcpu_notifier(workqueue_cpu_callback, 0);
-	keventd_wq = create_workqueue("events");
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
+		init_waitqueue_head(&gcwq->trustee_wait);
+	}
+
+	/* create the initial worker */
+	for_each_online_cpu(cpu) {
+		struct global_cwq *gcwq = get_gcwq(cpu);
+		struct worker *worker;
+
+		worker = create_worker(gcwq, true);
+		BUG_ON(!worker);
+		spin_lock_irq(&gcwq->lock);
+		start_worker(worker);
+		spin_unlock_irq(&gcwq->lock);
+	}
+
+	keventd_wq = __create_workqueue("events", 0);
 	BUG_ON(!keventd_wq);
 }
-- 
1.6.4.2

