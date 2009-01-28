Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbZA1A1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbZA1A1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 19:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbZA1A1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 19:27:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:15516 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbZA1A1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 19:27:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=X7Fhw9yDNlEZDv840bKNFPjnTu+sLKhXFE7Agwuc0auQArsOmPXif4DzImmkBDUrs6
         CSaOVeg6/o23D1Wb1d/DEzpyMt7u4Y86fX+fNSPqV+9099GxZtRzEDH8WU4E+YrWwupC
         18hpVCOSk1wLzjdesPIPPkxbZfdU9BPSPIhfo=
Date: Wed, 28 Jan 2009 01:27:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, fweisbec@gmail.com
Subject: [RFC v2][PATCH] create workqueue threads only when needed
Message-ID: <20090128002714.GA5086@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking at the statistics from the workqueue tracer, I've been suprised by the
number of useless workqueues I had:

 CPU  INSERTED  EXECUTED   NAME
 |      |         |          |

  *      0          0       kpsmoused
  *      0          0       ata_aux
  *      0          0       cqueue
  *      0          0       kacpi_notify
  *      0          0       kacpid
  *    998        998       khelper
  *      0          0       cpuset

  1      0          0       hda0/1
  1     42         42       reiserfs/1
  1      0          0       scsi_tgtd/1
  1      0          0       aio/1
  1      0          0       ata/1
  1    193        193       kblockd/1
  1      0          0       kintegrityd/1
  1      4          4       work_on_cpu/1
  1   1244       1244       events/1

  0      0          0       hda0/0
  0     63         63       reiserfs/0
  0      0          0       scsi_tgtd/0
  0      0          0       aio/0
  0      0          0       ata/0
  0    188        188       kblockd/0
  0      0          0       kintegrityd/0
  0     16         16       work_on_cpu/0
  0   1360       1360       events/0


All of the workqueues with 0 work inserted do nothing. 
For several reasons:

_ Unneeded built drivers for my system that create workqueue(s) when they init
_ Services which need their own workqueue, for several reasons, but who receive
  very rare jobs (often never)
_ ...?

And the result of git-grep create_singlethread_workqueue is even more surprising.

So I've started a patch which creates the workqueues by default without thread except
the kevents one.
They will have their thread created and started only when these workqueues will receive a
first work to do. This is performed by submitting a task's creation work to the kevent workqueues
which are always there, and are the only one which have their thread started on creation.

The result after this patch:

# CPU  INSERTED  EXECUTED   NAME
# |      |         |          |

  *    999       1000       khelper

  1      5          6       reiserfs/1
  1      0          2       work_on_cpu/1
  1     86         87       kblockd/1
  1     14         16       work_on_cpu/1
  1    149        149       events/1

  0     15         16       reiserfs/0
  0     85         86       kblockd/0
  0    146        146       events/0


Dropping 16 useless kernel threads in my system.

The workqueues created without thread at start are called "shadowed" whereas the others
like keventd are called "unshadowed".

Tested successfully, even after an hibernation.

Changelog in v2:

_ Fix problems pointed out by Oleg Nesterov, Ingo molnar and Alasdair G Kergon
_ Changes the names of structures/functions to bring the notion of "shadowed" workqueues
_ Fix the race when two works can concurrently create a thread for a same cpu workqueue
_ Fix the race when a work is pending to create a thread for a workqueue whereas this one
  is concurrently on cleanup.
_ If we fail to create a thread for a shadowed workqueue, retry in 1 sec (and warn!)


Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/workqueue.h |   44 +++++++------
 kernel/workqueue.c        |  154 ++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 162 insertions(+), 36 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 3cd51e5..7aba6b3 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -162,33 +162,35 @@ struct execute_work {
 extern struct workqueue_struct *
 __create_workqueue_key(const char *name, int singlethread,
 		       int freezeable, int rt, struct lock_class_key *key,
-		       const char *lock_name);
+		       const char *lock_name, bool shadowed);
 
 #ifdef CONFIG_LOCKDEP
-#define __create_workqueue(name, singlethread, freezeable, rt)	\
-({								\
-	static struct lock_class_key __key;			\
-	const char *__lock_name;				\
-								\
-	if (__builtin_constant_p(name))				\
-		__lock_name = (name);				\
-	else							\
-		__lock_name = #name;				\
-								\
-	__create_workqueue_key((name), (singlethread),		\
-			       (freezeable), (rt), &__key,	\
-			       __lock_name);			\
+#define __create_workqueue(name, singlethread, freezeable, rt, shadowed) \
+({									    \
+	static struct lock_class_key __key;				    \
+	const char *__lock_name;					    \
+									    \
+	if (__builtin_constant_p(name))					    \
+		__lock_name = (name);					    \
+	else								    \
+		__lock_name = #name;					    \
+									    \
+	__create_workqueue_key((name), (singlethread),			    \
+			       (freezeable), (rt), &__key,		    \
+			       __lock_name, shadowed);			    \
 })
 #else
-#define __create_workqueue(name, singlethread, freezeable, rt)	\
-	__create_workqueue_key((name), (singlethread), (freezeable), (rt), \
-			       NULL, NULL)
+#define __create_workqueue(name, singlethread, freezeable, rt, shadowed) \
+	__create_workqueue_key((name), (singlethread), (freezeable), (rt),  \
+			       NULL, NULL, shadowed)
 #endif
 
-#define create_workqueue(name) __create_workqueue((name), 0, 0, 0)
-#define create_rt_workqueue(name) __create_workqueue((name), 0, 0, 1)
-#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1, 0)
-#define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0, 0)
+#define create_workqueue(name) __create_workqueue((name), 0, 0, 0, 1)
+#define create_rt_workqueue(name) __create_workqueue((name), 0, 0, 1, 0)
+#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1, 0, 0)
+#define create_singlethread_workqueue(name)			\
+				__create_workqueue((name), 1, 0, 0, 1)
+#define create_kevents(name) __create_workqueue((name), 0, 0, 0, 0)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e53ee18..6e0a38e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -49,6 +49,8 @@ struct cpu_workqueue_struct {
 
 	struct workqueue_struct *wq;
 	struct task_struct *thread;
+	atomic_t unshadowed; /* 1 if the thread creation is pending or done */
+	wait_queue_head_t thread_creation;
 
 	int run_depth;		/* Detect run_workqueue() recursion depth */
 } ____cacheline_aligned;
@@ -69,6 +71,17 @@ struct workqueue_struct {
 #endif
 };
 
+/*
+ * This structure embeeds a work to create the thread of a given cpu workqueue
+ * Most of the cpu workqueues (except keventd) are created "shadowed", which
+ * means their thread will be created when the first work comes to them,
+ * making the cpu workqueue "unshadowed".
+ */
+struct workqueue_shadow {
+	struct cpu_workqueue_struct *cwq;
+	struct delayed_work work;
+};
+
 /* Serializes the accesses to the list of workqueues. */
 static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
@@ -126,12 +139,46 @@ struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
 }
 
+static void workqueue_unshadow_work(struct work_struct *work);
+
+/*
+ * Called when a first work is inserted on a workqueue.
+ * Insert a work to kevent to create a thread for the given cwq
+ */
+static void workqueue_unshadow(struct cpu_workqueue_struct *cwq)
+{
+	struct workqueue_shadow *ws;
+
+	/* Prevent from concurrent unshadowing */
+	if (unlikely(atomic_inc_return(&cwq->unshadowed) != 1))
+		goto already_unshadowed;
+
+	/*
+	 * The work can be inserted whatever is the context.
+	 * But such atomic allocation will be rare and freed soon.
+	 */
+	ws = kmalloc(sizeof(*ws), GFP_ATOMIC);
+	if (!ws) {
+		WARN_ON_ONCE(1);
+		goto already_unshadowed;
+	}
+	INIT_DELAYED_WORK(&ws->work, workqueue_unshadow_work);
+	ws->cwq = cwq;
+	schedule_delayed_work(&ws->work, 0);
+
+	return;
+
+already_unshadowed:
+	atomic_dec(&cwq->unshadowed);
+}
+
+
 DEFINE_TRACE(workqueue_insertion);
 
 static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head)
 {
-	trace_workqueue_insertion(cwq->thread, work);
+	trace_workqueue_insertion(cwq->thread, work, cwq->wq->singlethread);
 
 	set_wq_data(work, cwq);
 	/*
@@ -148,6 +195,9 @@ static void __queue_work(struct cpu_workqueue_struct *cwq,
 {
 	unsigned long flags;
 
+	if (unlikely(!cwq->thread))
+		workqueue_unshadow(cwq);
+
 	spin_lock_irqsave(&cwq->lock, flags);
 	insert_work(cwq, work, &cwq->worklist);
 	spin_unlock_irqrestore(&cwq->lock, flags);
@@ -291,7 +341,9 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 		 */
 		struct lockdep_map lockdep_map = work->lockdep_map;
 #endif
-		trace_workqueue_execution(cwq->thread, work);
+		struct workqueue_struct *wq = cwq->wq;
+
+		trace_workqueue_execution(cwq->thread, work, wq->singlethread);
 		cwq->current_work = work;
 		list_del_init(cwq->worklist.next);
 		spin_unlock_irq(&cwq->lock);
@@ -387,6 +439,9 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
 	} else {
 		struct wq_barrier barr;
 
+		if (unlikely(!cwq->thread))
+			workqueue_unshadow(cwq);
+
 		active = 0;
 		spin_lock_irq(&cwq->lock);
 		if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
@@ -759,6 +814,11 @@ int current_is_keventd(void)
 
 }
 
+static inline void init_unshadowed_state(struct cpu_workqueue_struct *cwq)
+{
+	atomic_set(&cwq->unshadowed, 1);
+}
+
 static struct cpu_workqueue_struct *
 init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 {
@@ -768,6 +828,7 @@ init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 	spin_lock_init(&cwq->lock);
 	INIT_LIST_HEAD(&cwq->worklist);
 	init_waitqueue_head(&cwq->more_work);
+	init_waitqueue_head(&cwq->thread_creation);
 
 	return cwq;
 }
@@ -796,7 +857,8 @@ static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
 	cwq->thread = p;
 
-	trace_workqueue_creation(cwq->thread, cpu);
+	trace_workqueue_creation(cwq->thread, wq->singlethread ?
+					      SINGLETHREAD_CPU : cpu);
 
 	return 0;
 }
@@ -812,12 +874,45 @@ static void start_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 	}
 }
 
+static void workqueue_unshadow_work(struct work_struct *work)
+{
+	struct workqueue_shadow *l;
+	struct delayed_work *delayed;
+	struct cpu_workqueue_struct *cwq;
+	int cpu = smp_processor_id();
+	int err = 0;
+
+	delayed = container_of(work, struct delayed_work, work);
+	l = container_of(delayed, struct workqueue_shadow, work);
+	cwq = l->cwq;
+
+	if (is_wq_single_threaded(cwq->wq)) {
+		err = create_workqueue_thread(cwq, singlethread_cpu);
+		start_workqueue_thread(cwq, -1);
+	} else {
+		err = create_workqueue_thread(cwq, cpu);
+		start_workqueue_thread(cwq, cpu);
+	}
+
+	/* If we can't create the thread, retry 1 sec later */
+	if (err) {
+		WARN_ON_ONCE(err);
+		PREPARE_DELAYED_WORK(delayed, workqueue_unshadow_work);
+		schedule_delayed_work(delayed, HZ);
+		return;
+	}
+
+	kfree(l);
+	wake_up(&cwq->thread_creation);
+}
+
 struct workqueue_struct *__create_workqueue_key(const char *name,
 						int singlethread,
 						int freezeable,
 						int rt,
 						struct lock_class_key *key,
-						const char *lock_name)
+						const char *lock_name,
+						bool shadowed)
 {
 	struct workqueue_struct *wq;
 	struct cpu_workqueue_struct *cwq;
@@ -842,8 +937,12 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 
 	if (singlethread) {
 		cwq = init_cpu_workqueue(wq, singlethread_cpu);
-		err = create_workqueue_thread(cwq, singlethread_cpu);
-		start_workqueue_thread(cwq, -1);
+		if (!shadowed) {
+			err = create_workqueue_thread(cwq, singlethread_cpu);
+			start_workqueue_thread(cwq, -1);
+			if (!err)
+				init_unshadowed_state(cwq);
+		}
 	} else {
 		cpu_maps_update_begin();
 		/*
@@ -863,10 +962,14 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 		 */
 		for_each_possible_cpu(cpu) {
 			cwq = init_cpu_workqueue(wq, cpu);
-			if (err || !cpu_online(cpu))
+			if (err || !cpu_online(cpu) || shadowed)
 				continue;
+
 			err = create_workqueue_thread(cwq, cpu);
 			start_workqueue_thread(cwq, cpu);
+			if (!err)
+				init_unshadowed_state(cwq);
+
 		}
 		cpu_maps_update_done();
 	}
@@ -883,12 +986,25 @@ DEFINE_TRACE(workqueue_destruction);
 
 static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 {
+	DEFINE_WAIT(wait);
+	long timeout = 0;
+	int unshadowed = atomic_read(&cwq->unshadowed);
+
+	/* Shadowed => no thread has been created */
+	if (!unshadowed)
+		return;
+
 	/*
-	 * Our caller is either destroy_workqueue() or CPU_POST_DEAD,
-	 * cpu_add_remove_lock protects cwq->thread.
+	 * If it's unshadowed, we want to ensure the thread creation
+	 * has been completed.
 	 */
-	if (cwq->thread == NULL)
-		return;
+	prepare_to_wait(&cwq->thread_creation, &wait, TASK_UNINTERRUPTIBLE);
+	if (!cwq->thread)
+		timeout = schedule_timeout_interruptible(HZ * 3);
+	finish_wait(&cwq->thread_creation, &wait);
+
+	/* We waited for 3 seconds, this is likely a soft lockup */
+	WARN_ON(timeout);
 
 	lock_map_acquire(&cwq->wq->lockdep_map);
 	lock_map_release(&cwq->wq->lockdep_map);
@@ -904,9 +1020,12 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 	 * checks list_empty(), and a "normal" queue_work() can't use
 	 * a dead CPU.
 	 */
-	trace_workqueue_destruction(cwq->thread);
-	kthread_stop(cwq->thread);
-	cwq->thread = NULL;
+
+	if (!timeout) {
+		trace_workqueue_destruction(cwq->thread, cwq->wq->singlethread);
+		kthread_stop(cwq->thread);
+		cwq->thread = NULL;
+	}
 }
 
 /**
@@ -955,6 +1074,9 @@ undo:
 
 		switch (action) {
 		case CPU_UP_PREPARE:
+			/* Will be created during the first work insertion */
+			if (!atomic_read(&cwq->unshadowed))
+				break;
 			if (!create_workqueue_thread(cwq, cpu))
 				break;
 			printk(KERN_ERR "workqueue [%s] for %i failed\n",
@@ -964,6 +1086,8 @@ undo:
 			goto undo;
 
 		case CPU_ONLINE:
+			if (!atomic_read(&cwq->unshadowed))
+				break;
 			start_workqueue_thread(cwq, cpu);
 			break;
 
@@ -1033,7 +1157,7 @@ void __init init_workqueues(void)
 	singlethread_cpu = cpumask_first(cpu_possible_mask);
 	cpu_singlethread_map = cpumask_of(singlethread_cpu);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
-	keventd_wq = create_workqueue("events");
+	keventd_wq = create_kevents("events");
 	BUG_ON(!keventd_wq);
 #ifdef CONFIG_SMP
 	work_on_cpu_wq = create_workqueue("work_on_cpu");


