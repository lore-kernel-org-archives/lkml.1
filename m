Return-Path: <linux-kernel-owner+w=401wt.eu-S1761111AbXHAA1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761111AbXHAA1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 20:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbXHAA0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 20:26:54 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:56554
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754819AbXHAA0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 20:26:53 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ghaskins@novell.com
Date: Tue, 31 Jul 2007 20:26:30 -0400
Message-ID: <20070801002407.4973.54778.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following workqueue related patch is a port of the original VFCIPI PI
patch I submitted earlier.  There is still more work to be done to add the
"schedule_on_cpu()" type behavior, and even more if we want to use this as
part of KVM.  But for now, this patch can stand alone so I thought I would
get it out there.

------------------------------------------------------------------

Mainline workqueues treat all requests the same.  This patch prioritizes
requests in the queue based on the callers current rt_priority.  It also
adds a priority-inheritance feature to avoid inversion.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/workqueue.h |    2 
 kernel/workqueue.c        |  198 +++++++++++++++++++++++++++++++++------------
 2 files changed, 149 insertions(+), 51 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 925d898..ae740b6 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -28,6 +28,7 @@ struct work_struct {
 #define WORK_STRUCT_WQ_DATA_MASK (~WORK_STRUCT_FLAG_MASK)
 	struct list_head entry;
 	work_func_t func;
+	int prio;
 };
 
 #define WORK_DATA_INIT()	ATOMIC_LONG_INIT(0)
@@ -81,6 +82,7 @@ struct execute_work {
 		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
 		INIT_LIST_HEAD(&(_work)->entry);			\
 		PREPARE_WORK((_work), (_func));				\
+                (_work)->prio = -1;                                     \
 	} while (0)
 
 #define INIT_DELAYED_WORK(_work, _func)				\
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e339c80..ecd5e01 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -14,6 +14,8 @@
  *   Theodore Ts'o <tytso@mit.edu>
  *
  * Made to use alloc_percpu by Christoph Lameter <clameter@sgi.com>.
+ *
+ * RT-queues and PI by Gregory Haskins <ghaskins@novell.com>
  */
 
 #include <linux/module.h>
@@ -36,6 +38,13 @@
 
 #include <asm/uaccess.h>
 
+/* Note: prio_array inspiration credit goes to the RT scheduler...*/
+struct prio_array {
+	DECLARE_BITMAP(bitmap, MAX_RT_PRIO+1); /* +1 bit for delimiter */
+	unsigned long	 count;
+	struct list_head queue[MAX_RT_PRIO];
+};
+
 /*
  * The per-CPU workqueue (if single thread, we always use the first
  * possible cpu).
@@ -45,6 +54,7 @@ struct cpu_workqueue_struct {
 	spinlock_t lock;
 
 	struct list_head worklist;
+	struct prio_array rt_worklist;
 	wait_queue_head_t more_work;
 	struct work_struct *current_work;
 
@@ -52,6 +62,7 @@ struct cpu_workqueue_struct {
 	struct task_struct *thread;
 
 	int run_depth;		/* Detect run_workqueue() recursion depth */
+	int prio;               /* -1 = normal priority, 0-99 = RT priority */
 } ____cacheline_aligned;
 
 /*
@@ -82,6 +93,94 @@ static cpumask_t cpu_singlethread_map __read_mostly;
  */
 static cpumask_t cpu_populated_map __read_mostly;
 
+/*
+ * ----------------------------------------
+ * prio_array
+ * ----------------------------------------
+ */
+static void prio_array_init(struct prio_array *array)
+{
+	int i;
+
+	memset(array->bitmap, 0, sizeof(array->bitmap));
+	array->count = 0;
+	
+	for (i=0; i<MAX_RT_PRIO; i++)
+		INIT_LIST_HEAD(&array->queue[i]);
+}
+
+static struct work_struct* prio_array_dequeue(struct prio_array *array)
+{
+	struct list_head   *head;
+	struct work_struct *work;
+	int		    idx;
+	
+	if (!array->count)
+		return NULL;
+	
+	idx = sched_find_first_bit(array->bitmap);
+	
+	head = array->queue + idx;
+	
+	/* If we got here, there better be something in the list */
+	BUG_ON(!head);
+	BUG_ON(list_empty(head));
+	
+	work = list_first_entry(head, struct work_struct, entry);
+	BUG_ON(!work);
+	
+	list_del_init(&work->entry);
+	array->count--;
+	
+	if (list_empty(head))
+		__clear_bit(idx, &array->bitmap);
+	
+	return work;
+}
+
+static void prio_array_enqueue(struct prio_array *array,
+			       struct work_struct *work,
+			       int prio, int tail)
+{
+	struct list_head *head;
+
+	BUG_ON(prio < 0);
+	BUG_ON(prio > MAX_RT_PRIO);
+
+	head = array->queue + prio;
+
+	if (tail)
+		list_add_tail(&work->entry, head);
+	else
+		list_add(&work->entry, head);
+
+	__set_bit(prio, &array->bitmap);
+	array->count++;
+}
+
+#define CWQ_DEFAULT_PRIO 1
+
+/* Assumes lock is held */
+static void wq_task_setprio(struct cpu_workqueue_struct *cwq, int prio)
+{
+	struct sched_param param = { 0, };
+	pid_t              pid   = cwq->thread->pid;
+
+	if (prio < CWQ_DEFAULT_PRIO)
+		prio = CWQ_DEFAULT_PRIO;
+
+	if (cwq->prio != prio) {
+		if (prio != -1) {
+			param.sched_priority = prio;
+			sys_sched_setscheduler(pid, SCHED_FIFO, &param);
+		} else {
+			sys_sched_setscheduler(pid, SCHED_NORMAL, &param);
+		}
+
+		cwq->prio = prio;
+	}
+}
+
 /* If it's single threaded, it isn't in the list of workqueues. */
 static inline int is_single_threaded(struct workqueue_struct *wq)
 {
@@ -133,10 +232,22 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 	 * result of list_add() below, see try_to_grab_pending().
 	 */
 	smp_wmb();
-	if (tail)
-		list_add_tail(&work->entry, &cwq->worklist);
-	else
-		list_add(&work->entry, &cwq->worklist);
+	if (rt_task(current)) {
+		work->prio = current->rt_priority;
+		prio_array_enqueue(&cwq->rt_worklist, work, work->prio, tail);
+
+		/* Priority inheritance on the kthread */
+		if (cwq->prio < work->prio)
+			wq_task_setprio(cwq, work->prio);
+	} else {
+		work->prio = -1;
+		if (tail)
+			list_add_tail(&work->entry, &cwq->worklist);
+		else
+			list_add(&work->entry, &cwq->worklist);
+
+	}
+
 	wake_up(&cwq->more_work);
 }
 
@@ -254,8 +365,30 @@ static void leak_check(void *func)
 	dump_stack();
 }
 
+static struct work_struct* cwq_dequeue(struct cpu_workqueue_struct *cwq)
+{
+	struct work_struct *work;
+	
+	/* First check the RT items */
+	work = prio_array_dequeue(&cwq->rt_worklist);
+	if (!work) {
+		/* If nothing is found there, check the normal queue */
+		if (!list_empty(&cwq->worklist)) {
+			work = list_first_entry(&cwq->worklist,
+						struct work_struct,
+						entry);
+			BUG_ON(!work);
+			list_del_init(&work->entry);
+		}
+	}
+
+	return work;
+}
+
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
+	struct work_struct *work;
+
 	spin_lock_irq(&cwq->lock);
 	cwq->run_depth++;
 	if (cwq->run_depth > 3) {
@@ -264,13 +397,12 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 			__FUNCTION__, cwq->run_depth);
 		dump_stack();
 	}
-	while (!list_empty(&cwq->worklist)) {
-		struct work_struct *work = list_entry(cwq->worklist.next,
-						struct work_struct, entry);
+	while ((work = cwq_dequeue(cwq))) {
 		work_func_t f = work->func;
 
+		wq_task_setprio(cwq, work->prio);
 		cwq->current_work = work;
-		list_del_init(cwq->worklist.next);
+
 		spin_unlock_irq(&cwq->lock);
 
 		BUG_ON(get_wq_data(work) != cwq);
@@ -283,6 +415,10 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 		spin_lock_irq(&cwq->lock);
 		cwq->current_work = NULL;
 	}
+
+	/* Make sure we are back to normal priority before sleeping */
+	wq_task_setprio(cwq, -1);
+
 	cwq->run_depth--;
 	spin_unlock_irq(&cwq->lock);
 }
@@ -295,7 +431,7 @@ static int worker_thread(void *__cwq)
 	if (!cwq->wq->freezeable)
 		current->flags |= PF_NOFREEZE;
 
-	set_user_nice(current, -5);
+	wq_task_setprio(cwq, -1);
 
 	for (;;) {
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
@@ -691,7 +827,9 @@ init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 	cwq->wq = wq;
 	spin_lock_init(&cwq->lock);
 	INIT_LIST_HEAD(&cwq->worklist);
+	prio_array_init(&cwq->rt_worklist);
 	init_waitqueue_head(&cwq->more_work);
+	cwq->prio = -1;
 
 	return cwq;
 }
@@ -803,47 +941,6 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 	cwq->thread = NULL;
 }
 
-void set_workqueue_thread_prio(struct workqueue_struct *wq, int cpu,
-			       int policy, int rt_priority, int nice)
-{
-	struct sched_param param = { .sched_priority = rt_priority };
-	struct cpu_workqueue_struct *cwq;
-	mm_segment_t oldfs = get_fs();
-	struct task_struct *p;
-	unsigned long flags;
-	int ret;
-
-	cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-	spin_lock_irqsave(&cwq->lock, flags);
-	p = cwq->thread;
-	spin_unlock_irqrestore(&cwq->lock, flags);
-
-	set_user_nice(p, nice);
-
-	set_fs(KERNEL_DS);
-	ret = sys_sched_setscheduler(p->pid, policy, &param);
-	set_fs(oldfs);
-
-	WARN_ON(ret);
-}
-
- void set_workqueue_prio(struct workqueue_struct *wq, int policy,
-			int rt_priority, int nice)
-{
-	int cpu;
-
-	/* We don't need the distraction of CPUs appearing and vanishing. */
-	mutex_lock(&workqueue_mutex);
-	if (is_single_threaded(wq))
-		set_workqueue_thread_prio(wq, 0, policy, rt_priority, nice);
-	else {
-		for_each_online_cpu(cpu)
-			set_workqueue_thread_prio(wq, cpu, policy,
-						  rt_priority, nice);
-	}
-	mutex_unlock(&workqueue_mutex);
-}
-
 /**
  * destroy_workqueue - safely terminate a workqueue
  * @wq: target workqueue
@@ -926,5 +1023,4 @@ void __init init_workqueues(void)
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
-	set_workqueue_prio(keventd_wq, SCHED_FIFO, 1, -20);
 }

