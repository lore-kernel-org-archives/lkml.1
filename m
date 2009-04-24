Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbZDXLqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbZDXLqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 07:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbZDXLqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 07:46:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63049 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbZDXLqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:46:19 -0400
Message-ID: <49F1A66B.1050909@cn.fujitsu.com>
Date: Fri, 24 Apr 2009 19:45:47 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/4] workqueue_tracepoint: Change tracepoint name to fit worklet
 and workqueue lifecycle
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49E8282A.6010004@cn.fujitsu.com> <49E82CA7.2040606@cn.fujitsu.com> <20090417134557.GA23493@elte.hu> <49F1A59B.3080206@cn.fujitsu.com>
In-Reply-To: <49F1A59B.3080206@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change list:
  workqueue_insertion->worklet_insertion
  workqueue_handler_entry->worklet_execute
  workqueue_handler_exit->worklet_complete

Tracepoint list after change:
  worklet_insertion
  worklet_execute
  worklet_complete
  worklet_cancel
  workqueue_creation
  workqueue_flush
  workqueue_destruction

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 include/trace/events/workqueue.h |    6 +++---
 kernel/trace/trace_workqueue.c   |   21 ++++++++++-----------
 kernel/workqueue.c               |    6 +++---
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index 2e77e84..fb35cc7 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -8,7 +8,7 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM workqueue
 
-TRACE_EVENT(workqueue_insertion,
+TRACE_EVENT(worklet_insertion,
 
 	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
 
@@ -30,7 +30,7 @@ TRACE_EVENT(workqueue_insertion,
 		__entry->thread_pid, __entry->func)
 );
 
-TRACE_EVENT(workqueue_handler_entry,
+TRACE_EVENT(worklet_execute,
 
 	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
 
@@ -55,7 +55,7 @@ TRACE_EVENT(workqueue_handler_entry,
 );
 
 /* Declare work as void *, because we can't use work->... in after f(work) */
-TRACE_EVENT(workqueue_handler_exit,
+TRACE_EVENT(worklet_complete,
 	TP_PROTO(struct task_struct *wq_thread, void *work),
 
 	TP_ARGS(wq_thread, work),
diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 8d26db6..e3e1218 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -57,8 +57,8 @@ static DEFINE_PER_CPU(struct workqueue_global_stats, all_workqueue_stat);
  * Update record when insert a work into workqueue
  * Caller need to hold cpu_workqueue_stats spin_lock
  */
-int do_workqueue_insertion(struct cpu_workqueue_stats *cws,
-			   struct work_struct *work)
+int do_worklet_insertion(struct cpu_workqueue_stats *cws,
+			 struct work_struct *work)
 {
 	struct workfunc_stats *wfstat;
 
@@ -87,7 +87,7 @@ found:
 
 /* Insertion of a work */
 static void
-probe_workqueue_insertion(struct task_struct *wq_thread,
+probe_worklet_insertion(struct task_struct *wq_thread,
 			  struct work_struct *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
@@ -97,8 +97,8 @@ probe_workqueue_insertion(struct task_struct *wq_thread,
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
 	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list) {
 		if (node->pid == wq_thread->pid) {
-			/* we ignore error of do_workqueue_insertion */
-			do_workqueue_insertion(node, work);
+			/* we ignore error of do_worklet_insertion */
+			do_worklet_insertion(node, work);
 			goto found;
 		}
 	}
@@ -109,8 +109,7 @@ found:
 
 /* Execution of a work */
 static void
-probe_workqueue_entry(struct task_struct *wq_thread,
-			  struct work_struct *work)
+probe_worklet_execute(struct task_struct *wq_thread, struct work_struct *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
 	struct cpu_workqueue_stats *node;
@@ -369,11 +368,11 @@ int __init trace_workqueue_early_init(void)
 {
 	int ret, cpu;
 
-	ret = register_trace_workqueue_insertion(probe_workqueue_insertion);
+	ret = register_trace_worklet_insertion(probe_worklet_insertion);
 	if (ret)
 		goto out;
 
-	ret = register_trace_workqueue_handler_entry(probe_workqueue_entry);
+	ret = register_trace_worklet_execute(probe_worklet_execute);
 	if (ret)
 		goto no_insertion;
 
@@ -395,9 +394,9 @@ int __init trace_workqueue_early_init(void)
 no_creation:
 	unregister_trace_workqueue_creation(probe_workqueue_creation);
 no_handler_entry:
-	unregister_trace_workqueue_handler_entry(probe_workqueue_entry);
+	unregister_trace_worklet_execute(probe_worklet_execute);
 no_insertion:
-	unregister_trace_workqueue_insertion(probe_workqueue_insertion);
+	unregister_trace_worklet_insertion(probe_worklet_insertion);
 out:
 	pr_warning("trace_workqueue: unable to trace workqueues\n");
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 99a81ba..a3c9848 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -128,7 +128,7 @@ struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head)
 {
-	trace_workqueue_insertion(cwq->thread, work);
+	trace_worklet_insertion(cwq->thread, work);
 
 	set_wq_data(work, cwq);
 	/*
@@ -287,9 +287,9 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 		work_clear_pending(work);
 		lock_map_acquire(&cwq->wq->lockdep_map);
 		lock_map_acquire(&lockdep_map);
-		trace_workqueue_handler_entry(cwq->thread, work);
+		trace_worklet_execute(cwq->thread, work);
 		f(work);
-		trace_workqueue_handler_exit(cwq->thread, work);
+		trace_worklet_complete(cwq->thread, work);
 		lock_map_release(&lockdep_map);
 		lock_map_release(&cwq->wq->lockdep_map);
 
-- 
1.5.5.3


