Return-Path: <linux-kernel-owner+w=401wt.eu-S933617AbXDAQDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbXDAQDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 12:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933605AbXDAQDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 12:03:48 -0400
Received: from haxent.com ([65.99.219.155]:2926 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933599AbXDAQDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 12:03:36 -0400
Message-Id: <20070401160312.511846000@haxent.com.br>
References: <20070401155810.277757000@haxent.com.br>
User-Agent: quilt/0.46-1
Date: Sun, 01 Apr 2007 12:58:21 -0300
From: davi@haxent.com.br
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 11/12] pollfs: asynchronous workqueue
Content-Disposition: inline; filename=pollfs-async-workqueue.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Asynchronously run work items.

If the worker thread blocks while the kernel executes the work function
call a new worker thread is created (if one is not available) to handle
the remaining workqueue items.

Various errors and resource limitations are not yet handled.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>
---

Index: linux-2.6/include/linux/workqueue.h
===================================================================
--- linux-2.6.orig/include/linux/workqueue.h
+++ linux-2.6/include/linux/workqueue.h
@@ -25,7 +25,8 @@ struct work_struct {
 	atomic_long_t data;
 #define WORK_STRUCT_PENDING 0		/* T if work item pending execution */
 #define WORK_STRUCT_NOAUTOREL 1		/* F if work item automatically released on exec */
-#define WORK_STRUCT_FLAG_MASK (3UL)
+#define WORK_STRUCT_ASYNC 2		/* T if work item can be executed asynchronously */
+#define WORK_STRUCT_FLAG_MASK (7UL)
 #define WORK_STRUCT_WQ_DATA_MASK (~WORK_STRUCT_FLAG_MASK)
 	struct list_head entry;
 	work_func_t func;
@@ -171,6 +172,7 @@ extern int FASTCALL(queue_work(struct wo
 extern int FASTCALL(queue_delayed_work(struct workqueue_struct *wq, struct delayed_work *work, unsigned long delay));
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	struct delayed_work *work, unsigned long delay);
+extern int FASTCALL(queue_async_work(struct workqueue_struct *wq, struct work_struct *work));
 extern void FASTCALL(flush_workqueue(struct workqueue_struct *wq));
 
 extern int FASTCALL(schedule_work(struct work_struct *work));
Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c
+++ linux-2.6/kernel/workqueue.c
@@ -14,6 +14,7 @@
  *   Theodore Ts'o <tytso@mit.edu>
  *
  * Made to use alloc_percpu by Christoph Lameter <clameter@sgi.com>.
+ * Asynchronous workqueue by Davi E. M. Arnaut <davi.arnaut@gmail.com>
  */
 
 #include <linux/module.h>
@@ -60,6 +61,8 @@ struct cpu_workqueue_struct {
 	int run_depth;		/* Detect run_workqueue() recursion depth */
 
 	int freezeable;		/* Freeze the thread during suspend */
+
+	struct list_head threadlist;
 } ____cacheline_aligned;
 
 /*
@@ -297,9 +300,27 @@ int queue_delayed_work_on(int cpu, struc
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
+/**
+ * queue_async_work - queue an asynchronous work on a workqueue
+ * @wq: workqueue to use
+ * @work: work to queue
+ *
+ * Returns 0 if @work was already on a queue, non-zero otherwise.
+ *
+ * We queue the work to the CPU it was submitted, but there is no
+ * guarantee that it will be processed by that CPU.
+ */
+int fastcall queue_async_work(struct workqueue_struct *wq, struct work_struct *work)
+{
+	set_bit(WORK_STRUCT_ASYNC, work_data_bits(work));
+
+	return queue_work(wq, work);
+}
+EXPORT_SYMBOL_GPL(queue_async_work);
+
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
-	unsigned long flags;
+	unsigned long flags, async;
 
 	/*
 	 * Keep taking off work from the queue until
@@ -324,8 +345,18 @@ static void run_workqueue(struct cpu_wor
 		BUG_ON(get_wq_data(work) != cwq);
 		if (!test_bit(WORK_STRUCT_NOAUTOREL, work_data_bits(work)))
 			work_release(work);
+
+		async = test_bit(WORK_STRUCT_ASYNC, work_data_bits(work));
+		if (unlikely(async))
+			current->cwq = cwq;
+
 		f(work);
 
+		if (current->cwq)
+			current->cwq = NULL;
+		else if (async)
+			async++;
+
 		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
 			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
 					"%s/0x%08x/%d\n",
@@ -340,6 +371,17 @@ static void run_workqueue(struct cpu_wor
 		spin_lock_irqsave(&cwq->lock, flags);
 		cwq->remove_sequence++;
 		wake_up(&cwq->work_done);
+
+		if (async > 1) {
+			if (cwq->thread) {
+				list_add_tail(&current->cwq_entry, &cwq->threadlist);
+				spin_unlock_irqrestore(&cwq->lock, flags);
+				schedule();
+				spin_lock_irqsave(&cwq->lock, flags);
+			}
+			else
+				cwq->thread = current;
+		}
 	}
 	cwq->run_depth--;
 	spin_unlock_irqrestore(&cwq->lock, flags);
@@ -467,6 +509,7 @@ static struct task_struct *create_workqu
 	cwq->remove_sequence = 0;
 	cwq->freezeable = freezeable;
 	INIT_LIST_HEAD(&cwq->worklist);
+	INIT_LIST_HEAD(&cwq->threadlist);
 	init_waitqueue_head(&cwq->more_work);
 	init_waitqueue_head(&cwq->work_done);
 
@@ -534,15 +577,19 @@ static void cleanup_workqueue_thread(str
 {
 	struct cpu_workqueue_struct *cwq;
 	unsigned long flags;
-	struct task_struct *p;
+	struct task_struct *p, *tmp;
+	LIST_HEAD(threadlist);
 
 	cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 	spin_lock_irqsave(&cwq->lock, flags);
 	p = cwq->thread;
 	cwq->thread = NULL;
+	list_splice_init(&cwq->threadlist, &threadlist);
 	spin_unlock_irqrestore(&cwq->lock, flags);
 	if (p)
 		kthread_stop(p);
+	list_for_each_entry_safe(p, tmp, &threadlist, cwq_entry)
+		kthread_stop(p);
 }
 
 /**
@@ -811,6 +858,68 @@ static int __devinit workqueue_cpu_callb
 	return NOTIFY_OK;
 }
 
+static void create_cpu_worker(struct cpu_workqueue_struct *cwq)
+{
+	unsigned long flags;
+	struct task_struct *p;
+	struct workqueue_struct *wq = cwq->wq;
+	int cpu = first_cpu(current->cpus_allowed);
+
+	mutex_lock(&workqueue_mutex);
+	if (is_single_threaded(wq))
+		p = kthread_create(worker_thread, cwq, "%s", wq->name);
+	else
+		p = kthread_create(worker_thread, cwq, "%s/%d", wq->name, cpu);
+
+	if (IS_ERR(p))
+		/* oh well, there isn't much we can do anyway. */
+		goto unlock;
+
+	kthread_bind(p, cpu);
+
+	spin_lock_irqsave(&cwq->lock, flags);
+	if (!cwq->thread)
+		wake_up_process(p);
+	else
+		list_add_tail(&p->cwq_entry, &cwq->threadlist);
+	spin_unlock_irqrestore(&cwq->lock, flags);
+
+unlock:
+	mutex_unlock(&workqueue_mutex);
+}
+
+static inline void wake_up_cpu_worker(struct cpu_workqueue_struct *cwq)
+{
+	struct task_struct *worker = list_entry(cwq->threadlist.next,
+						struct task_struct, cwq_entry);
+
+	list_del_init(cwq->threadlist.next);
+
+	cwq->thread = worker;
+
+	wake_up_process(worker);
+}
+
+void schedule_workqueue(struct task_struct *task)
+{
+	struct cpu_workqueue_struct *cwq = task->cwq;
+	unsigned long flags;
+
+	task->cwq = NULL;
+
+	spin_lock_irqsave(&cwq->lock, flags);
+	if (cwq->thread == task) {
+		if (!list_empty(&cwq->threadlist))
+			wake_up_cpu_worker(cwq);
+		else
+			task = cwq->thread = NULL;
+	}
+	spin_unlock_irqrestore(&cwq->lock, flags);
+
+	if (!task)
+		create_cpu_worker(cwq);
+}
+
 void init_workqueues(void)
 {
 	singlethread_cpu = first_cpu(cpu_possible_map);
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -843,6 +843,9 @@ struct task_struct {
 
 	struct mm_struct *mm, *active_mm;
 
+	/* (asynchronous) cpu workqueue */
+	void *cwq;
+	struct list_head cwq_entry;
 /* task state */
 	struct linux_binfmt *binfmt;
 	long exit_state;
@@ -1409,6 +1412,7 @@ extern int disallow_signal(int);
 extern int do_execve(char *, char __user * __user *, char __user * __user *, struct pt_regs *);
 extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
 struct task_struct *fork_idle(int);
+extern void schedule_workqueue(struct task_struct *);
 
 extern void set_task_comm(struct task_struct *tsk, char *from);
 extern void get_task_comm(char *to, struct task_struct *tsk);
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3305,6 +3305,12 @@ asmlinkage void __sched schedule(void)
 	}
 	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
 
+	/* asynchronous queue worker */
+	if (unlikely(current->cwq))
+		/* only if it's a voluntary sleep */
+		if (!(preempt_count() & PREEMPT_ACTIVE) && current->state != TASK_RUNNING)
+			schedule_workqueue(current);
+
 need_resched:
 	preempt_disable();
 	prev = current;
Index: linux-2.6/include/linux/init_task.h
===================================================================
--- linux-2.6.orig/include/linux/init_task.h
+++ linux-2.6/include/linux/init_task.h
@@ -112,6 +112,7 @@ extern struct group_info init_groups;
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
 	.ptrace_children= LIST_HEAD_INIT(tsk.ptrace_children),		\
 	.ptrace_list	= LIST_HEAD_INIT(tsk.ptrace_list),		\
+	.cwq_entry	= LIST_HEAD_INIT(tsk.cwq_entry),		\
 	.real_parent	= &tsk,						\
 	.parent		= &tsk,						\
 	.children	= LIST_HEAD_INIT(tsk.children),			\
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -1173,6 +1173,7 @@ static struct task_struct *copy_process(
 	INIT_LIST_HEAD(&p->thread_group);
 	INIT_LIST_HEAD(&p->ptrace_children);
 	INIT_LIST_HEAD(&p->ptrace_list);
+	INIT_LIST_HEAD(&p->cwq_entry);
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);

-- 
