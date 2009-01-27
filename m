Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbZA0AR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbZA0AR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 19:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbZA0ARS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 19:17:18 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:35578 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbZA0ARR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 19:17:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=I3cro35PnQrgiZyqhWtnFNqO+BTHD2BYyrddC8t3vKjwRnv4IiSJMdTCH6Q1hACmdf
         2sJBVXM8uU3gpmuFPy20304tYbpqXGxTx9k3A8da3W/VUfkqDuhDttqfwlP/bG+piH4e
         bNpPELsazgxIVqpJ9JpQiXHAN98zoWflGXhlc=
Date: Tue, 27 Jan 2009 01:17:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: [RFC][PATCH] create workqueue threads only when needed
Message-ID: <20090127001708.GA4815@nowhere>
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
(Yes the inserted values are not synced with the executed one because
the tracers looses the first events. I just rewrote some parts to make it work
with this patch).
I guess I will update this tracer to display the "shadow workqueues" which have no
threads too.

I hadn't any problems until now with this patch but I think it needs more testing,
like with cpu hotplug, and some renaming for its functions and structures...
And I would like to receive some comments and feelings before continuing. So this
is just an RFC :-)

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/workqueue.h |   44 +++++++++++----------
 kernel/workqueue.c        |   95 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 106 insertions(+), 33 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 3cd51e5..c4283c5 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -162,33 +162,35 @@ struct execute_work {
 extern struct workqueue_struct *
 __create_workqueue_key(const char *name, int singlethread,
 		       int freezeable, int rt, struct lock_class_key *key,
-		       const char *lock_name);
+		       const char *lock_name, bool when_needed);
 
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
+#define __create_workqueue(name, singlethread, freezeable, rt, when_needed) \
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
+			       __lock_name, when_needed);		    \
 })
 #else
-#define __create_workqueue(name, singlethread, freezeable, rt)	\
-	__create_workqueue_key((name), (singlethread), (freezeable), (rt), \
-			       NULL, NULL)
+#define __create_workqueue(name, singlethread, freezeable, rt, when_needed) \
+	__create_workqueue_key((name), (singlethread), (freezeable), (rt),  \
+			       NULL, NULL, when_needed)
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
index e53ee18..430cb5a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -69,6 +69,12 @@ struct workqueue_struct {
 #endif
 };
 
+
+struct late_workqueue_creation_data {
+	struct cpu_workqueue_struct *cwq;
+	struct work_struct work;
+};
+
 /* Serializes the accesses to the list of workqueues. */
 static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
@@ -126,12 +132,34 @@ struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
 }
 
+static void create_wq_thread_late_work(struct work_struct *work);
+
+/* Called when a first work is inserted on a workqueue */
+static void create_wq_thread_late(struct cpu_workqueue_struct *cwq)
+{
+	struct late_workqueue_creation_data *l;
+
+	/*
+	 * The work can be inserted whatever is the context.
+	 * But such atomic allocation will be rare and freed soon.
+	 */
+	l = kmalloc(sizeof(*l), GFP_ATOMIC);
+	if (!l) {
+		WARN_ON_ONCE(1);
+		return;
+	}
+	INIT_WORK(&l->work, create_wq_thread_late_work);
+	l->cwq = cwq;
+	schedule_work(&l->work);
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
@@ -148,6 +176,9 @@ static void __queue_work(struct cpu_workqueue_struct *cwq,
 {
 	unsigned long flags;
 
+	if (!cwq->thread)
+		create_wq_thread_late(cwq);
+
 	spin_lock_irqsave(&cwq->lock, flags);
 	insert_work(cwq, work, &cwq->worklist);
 	spin_unlock_irqrestore(&cwq->lock, flags);
@@ -291,7 +322,9 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
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
@@ -387,6 +420,8 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
 	} else {
 		struct wq_barrier barr;
 
+		if (!cwq->thread)
+			create_wq_thread_late(cwq);
 		active = 0;
 		spin_lock_irq(&cwq->lock);
 		if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
@@ -796,7 +831,8 @@ static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
 	cwq->thread = p;
 
-	trace_workqueue_creation(cwq->thread, cpu);
+	trace_workqueue_creation(cwq->thread, wq->singlethread ?
+					      SINGLETHREAD_CPU : cpu);
 
 	return 0;
 }
@@ -812,12 +848,34 @@ static void start_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 	}
 }
 
+static void create_wq_thread_late_work(struct work_struct *work)
+{
+	struct late_workqueue_creation_data *l;
+	struct cpu_workqueue_struct *cwq;
+	int cpu = smp_processor_id();
+	int err = 0;
+
+	l = container_of(work, struct late_workqueue_creation_data, work);
+	cwq = l->cwq;
+
+	if (is_wq_single_threaded(cwq->wq)) {
+		err = create_workqueue_thread(cwq, singlethread_cpu);
+		start_workqueue_thread(cwq, -1);
+	} else {
+		err = create_workqueue_thread(cwq, cpu);
+		start_workqueue_thread(cwq, cpu);
+	}
+	WARN_ON_ONCE(err);
+	kfree(l);
+}
+
 struct workqueue_struct *__create_workqueue_key(const char *name,
 						int singlethread,
 						int freezeable,
 						int rt,
 						struct lock_class_key *key,
-						const char *lock_name)
+						const char *lock_name,
+						bool when_needed)
 {
 	struct workqueue_struct *wq;
 	struct cpu_workqueue_struct *cwq;
@@ -842,8 +900,10 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 
 	if (singlethread) {
 		cwq = init_cpu_workqueue(wq, singlethread_cpu);
-		err = create_workqueue_thread(cwq, singlethread_cpu);
-		start_workqueue_thread(cwq, -1);
+		if (!when_needed) {
+			err = create_workqueue_thread(cwq, singlethread_cpu);
+			start_workqueue_thread(cwq, -1);
+		}
 	} else {
 		cpu_maps_update_begin();
 		/*
@@ -865,8 +925,11 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 			cwq = init_cpu_workqueue(wq, cpu);
 			if (err || !cpu_online(cpu))
 				continue;
-			err = create_workqueue_thread(cwq, cpu);
-			start_workqueue_thread(cwq, cpu);
+
+			if (!when_needed) {
+				err = create_workqueue_thread(cwq, cpu);
+				start_workqueue_thread(cwq, cpu);
+			}
 		}
 		cpu_maps_update_done();
 	}
@@ -904,9 +967,12 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 	 * checks list_empty(), and a "normal" queue_work() can't use
 	 * a dead CPU.
 	 */
-	trace_workqueue_destruction(cwq->thread);
-	kthread_stop(cwq->thread);
-	cwq->thread = NULL;
+
+	if (cwq->thread) {
+		trace_workqueue_destruction(cwq->thread, cwq->wq->singlethread);
+		kthread_stop(cwq->thread);
+		cwq->thread = NULL;
+	}
 }
 
 /**
@@ -955,6 +1021,9 @@ undo:
 
 		switch (action) {
 		case CPU_UP_PREPARE:
+			/* Will be created during the first work insertion */
+			if (wq != keventd_wq)
+				break;
 			if (!create_workqueue_thread(cwq, cpu))
 				break;
 			printk(KERN_ERR "workqueue [%s] for %i failed\n",
@@ -964,6 +1033,8 @@ undo:
 			goto undo;
 
 		case CPU_ONLINE:
+			if (wq != keventd_wq)
+				break;
 			start_workqueue_thread(cwq, cpu);
 			break;
 
@@ -1033,7 +1104,7 @@ void __init init_workqueues(void)
 	singlethread_cpu = cpumask_first(cpu_possible_mask);
 	cpu_singlethread_map = cpumask_of(singlethread_cpu);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
-	keventd_wq = create_workqueue("events");
+	keventd_wq = create_kevents("events");
 	BUG_ON(!keventd_wq);
 #ifdef CONFIG_SMP
 	work_on_cpu_wq = create_workqueue("work_on_cpu");



