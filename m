Return-Path: <linux-kernel-owner+w=401wt.eu-S1755651AbZDXLrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbZDXLrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 07:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZDXLrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 07:47:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59409 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbZDXLrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:47:09 -0400
Message-ID: <49F1A69B.9070206@cn.fujitsu.com>
Date: Fri, 24 Apr 2009 19:46:35 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/4] workqueue_trace: Separate worklet_insertion into worklet_enqueue
 and worklet_enqueue_delayed
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49E8282A.6010004@cn.fujitsu.com> <49E82CA7.2040606@cn.fujitsu.com> <20090417134557.GA23493@elte.hu> <49F1A59B.3080206@cn.fujitsu.com>
In-Reply-To: <49F1A59B.3080206@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To get more information about delayed work.
Suggest by Ingo Molnar <mingo@elte.hu>
> i'd suggest the following complete set of events instead:
> TRACE_EVENT(worklet_enqueue              /* NEW */
> TRACE_EVENT(worklet_enqueue_delayed      /* NEW */
> i'd suggest a 'cpu' parameter to the enqueue events, to allow the
> mapping of the _on(..cpu) variants too.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 include/trace/events/workqueue.h |   54 ++++++++++++++++++++++++++++++++-----
 kernel/trace/trace_workqueue.c   |   41 +++++++++++++++++++---------
 kernel/workqueue.c               |   19 ++++++++++---
 3 files changed, 88 insertions(+), 26 deletions(-)

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index fb35cc7..e4c74f2 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -8,26 +8,64 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM workqueue
 
-TRACE_EVENT(worklet_insertion,
+TRACE_EVENT(worklet_enqueue,
 
-	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
+	TP_PROTO(
+		struct task_struct *wq_thread,
+		struct work_struct *work,
+		int cpu
+	),
 
-	TP_ARGS(wq_thread, work),
+	TP_ARGS(wq_thread, work, cpu),
 
 	TP_STRUCT__entry(
-		__array(char,		thread_comm,	TASK_COMM_LEN)
-		__field(pid_t,		thread_pid)
-		__field(work_func_t,	func)
+		__array(char,			thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,			thread_pid)
+		__field(work_func_t,		func)
+		__field(int,			cpu)
 	),
 
 	TP_fast_assign(
 		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
 		__entry->thread_pid	= wq_thread->pid;
 		__entry->func		= work->func;
+		__entry->cpu		= cpu;
+	),
+
+	TP_printk("thread=%s:%d func=%pF cpu=%d", __entry->thread_comm,
+		__entry->thread_pid, __entry->func, __entry->cpu)
+);
+
+TRACE_EVENT(worklet_enqueue_delayed,
+
+	TP_PROTO(
+		struct task_struct *wq_thread,
+		struct work_struct *work,
+		int cpu,
+		unsigned long delay
+	),
+
+	TP_ARGS(wq_thread, work, cpu, delay),
+
+	TP_STRUCT__entry(
+		__array(char,			thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,			thread_pid)
+		__field(work_func_t,		func)
+		__field(int,			cpu)
+		__field(unsigned long,		delay)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+		__entry->func		= work->func;
+		__entry->cpu		= cpu;
+		__entry->delay		= delay;
 	),
 
-	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
-		__entry->thread_pid, __entry->func)
+	TP_printk("thread=%s:%d func=%pF cpu=%d delay=%lu",
+		__entry->thread_comm, __entry->thread_pid, __entry->func,
+		__entry->cpu, __entry->delay)
 );
 
 TRACE_EVENT(worklet_execute,
diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index e3e1218..69ae4aa 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -57,7 +57,7 @@ static DEFINE_PER_CPU(struct workqueue_global_stats, all_workqueue_stat);
  * Update record when insert a work into workqueue
  * Caller need to hold cpu_workqueue_stats spin_lock
  */
-int do_worklet_insertion(struct cpu_workqueue_stats *cws,
+int do_worklet_enqueue(struct cpu_workqueue_stats *cws,
 			 struct work_struct *work)
 {
 	struct workfunc_stats *wfstat;
@@ -85,26 +85,34 @@ found:
 	return 0;
 }
 
-/* Insertion of a work */
+/* Enqueue of a work */
 static void
-probe_worklet_insertion(struct task_struct *wq_thread,
-			  struct work_struct *work)
+probe_worklet_enqueue(struct task_struct *wq_thread, struct work_struct *work,
+		      int cpu)
 {
-	int cpu = cpumask_first(&wq_thread->cpus_allowed);
+	int wqcpu = cpumask_first(&wq_thread->cpus_allowed);
 	struct cpu_workqueue_stats *node;
 	unsigned long flags;
 
-	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
-	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list) {
+	spin_lock_irqsave(&workqueue_cpu_stat(wqcpu)->lock, flags);
+	list_for_each_entry(node, &workqueue_cpu_stat(wqcpu)->list, list) {
 		if (node->pid == wq_thread->pid) {
 			/* we ignore error of do_worklet_insertion */
-			do_worklet_insertion(node, work);
+			do_worklet_enqueue(node, work);
 			goto found;
 		}
 	}
 	pr_debug("trace_workqueue: entry not found\n");
 found:
-	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
+	spin_unlock_irqrestore(&workqueue_cpu_stat(wqcpu)->lock, flags);
+}
+
+static void
+probe_worklet_enqueue_delayed(struct task_struct *wq_thread,
+			      struct work_struct *work, int cpu,
+			      unsigned long delay)
+{
+	probe_worklet_enqueue(wq_thread, work, cpu);
 }
 
 /* Execution of a work */
@@ -368,13 +376,18 @@ int __init trace_workqueue_early_init(void)
 {
 	int ret, cpu;
 
-	ret = register_trace_worklet_insertion(probe_worklet_insertion);
+	ret = register_trace_worklet_enqueue(probe_worklet_enqueue);
 	if (ret)
 		goto out;
 
+	ret = register_trace_worklet_enqueue_delayed(
+		probe_worklet_enqueue_delayed);
+	if (ret)
+		goto no_enqueue;
+
 	ret = register_trace_worklet_execute(probe_worklet_execute);
 	if (ret)
-		goto no_insertion;
+		goto no_enqueue_delayed;
 
 	ret = register_trace_workqueue_creation(probe_workqueue_creation);
 	if (ret)
@@ -395,8 +408,10 @@ no_creation:
 	unregister_trace_workqueue_creation(probe_workqueue_creation);
 no_handler_entry:
 	unregister_trace_worklet_execute(probe_worklet_execute);
-no_insertion:
-	unregister_trace_worklet_insertion(probe_worklet_insertion);
+no_enqueue_delayed:
+	unregister_trace_worklet_enqueue_delayed(probe_worklet_enqueue_delayed);
+no_enqueue:
+	unregister_trace_worklet_enqueue(probe_worklet_enqueue);
 out:
 	pr_warning("trace_workqueue: unable to trace workqueues\n");
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a3c9848..0cc14b9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -128,8 +128,6 @@ struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head)
 {
-	trace_worklet_insertion(cwq->thread, work);
-
 	set_wq_data(work, cwq);
 	/*
 	 * Ensure that we get the right work->data if we see the
@@ -188,8 +186,12 @@ queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
 	int ret = 0;
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
+		struct cpu_workqueue_struct *cwq;
+
 		BUG_ON(!list_empty(&work->entry));
-		__queue_work(wq_per_cpu(wq, cpu), work);
+		cwq = wq_per_cpu(wq, cpu);
+		__queue_work(cwq, work);
+		trace_worklet_enqueue(cwq->thread, work, cpu);
 		ret = 1;
 	}
 	return ret;
@@ -251,10 +253,17 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
 
-		if (unlikely(cpu >= 0))
+		if (unlikely(cpu >= 0)) {
 			add_timer_on(timer, cpu);
-		else
+			trace_worklet_enqueue_delayed(
+				wq_per_cpu(wq, cpu)->thread, work, cpu, delay);
+		} else {
 			add_timer(timer);
+			trace_worklet_enqueue_delayed(
+				wq_per_cpu(wq, raw_smp_processor_id())->thread,
+				work, cpu, delay);
+		}
+
 		ret = 1;
 	}
 	return ret;
-- 
1.5.5.3


