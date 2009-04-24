Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbZDXLoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbZDXLoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 07:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbZDXLoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 07:44:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54778 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbZDXLoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:44:22 -0400
Message-ID: <49F1A5F6.4080100@cn.fujitsu.com>
Date: Fri, 24 Apr 2009 19:43:50 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Zhaolei <zhaolei@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/4] workqueue_tracepoint: introduce workqueue_handler_exit
 tracepoint and rename workqueue_execution to workqueue_handler_entry
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49E8282A.6010004@cn.fujitsu.com> <49E82CA7.2040606@cn.fujitsu.com> <20090417134557.GA23493@elte.hu> <49F1A59B.3080206@cn.fujitsu.com>
In-Reply-To: <49F1A59B.3080206@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Entry/exit handler pair is useful common tracepoint technique.
It can mesure handler consumption time.

Then, workqueue also handler-exit tracepoint and rename execution to
handler-entry.

Changlog:
v1: From KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    introduce workqueue_handler_exit tracepoint
    rename workqueue_execution to workqueue_handler_entry
v2: From Zhao Lei <zhaolei@cn.fujitsu.com>
    Declare workqueue_handler_exit's work argument as void *, for we can't
    access its contents.
    Add workqueue_handler_entry's &work_struct back to TP_printk, to used as
    'key' for workqueue_handler_entry/exit pair.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki@jp.fujitsu.com>
---
 include/trace/events/workqueue.h |   36 ++++++++++++++++++++++++++++++------
 kernel/trace/trace_workqueue.c   |   10 +++++-----
 kernel/workqueue.c               |    3 ++-
 3 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index 035f1bf..36f4939 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -30,26 +30,50 @@ TRACE_EVENT(workqueue_insertion,
 		__entry->thread_pid, __entry->func)
 );
 
-TRACE_EVENT(workqueue_execution,
+TRACE_EVENT(workqueue_handler_entry,
 
 	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
 
 	TP_ARGS(wq_thread, work),
 
 	TP_STRUCT__entry(
-		__array(char,		thread_comm,	TASK_COMM_LEN)
-		__field(pid_t,		thread_pid)
-		__field(work_func_t,	func)
+		__array(char,			thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,			thread_pid)
+		__field(struct work_struct *,	work)
+		__field(work_func_t,		func)
 	),
 
 	TP_fast_assign(
 		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
 		__entry->thread_pid	= wq_thread->pid;
+		__entry->work		= work;
 		__entry->func		= work->func;
 	),
 
-	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
-		__entry->thread_pid, __entry->func)
+	TP_printk("thread=%s:%d work=%p func=%pF", __entry->thread_comm,
+		__entry->thread_pid, __entry->work, __entry->func)
+);
+
+/* Declare work as void *, because we can't use work->... in after f(work) */
+TRACE_EVENT(workqueue_handler_exit,
+	TP_PROTO(struct task_struct *wq_thread, void *work),
+
+	TP_ARGS(wq_thread, work),
+
+	TP_STRUCT__entry(
+		__array(char,	thread_comm, TASK_COMM_LEN)
+		__field(pid_t,	thread_pid)
+		__field(void *,	work)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+		__entry->work		= work;
+	),
+
+	TP_printk("thread=%s:%d work=%p", __entry->thread_comm,
+		  __entry->thread_pid, __entry->work)
 );
 
 /* Trace the creation of one workqueue thread on a cpu */
diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 7c632b9..8d26db6 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -109,7 +109,7 @@ found:
 
 /* Execution of a work */
 static void
-probe_workqueue_execution(struct task_struct *wq_thread,
+probe_workqueue_entry(struct task_struct *wq_thread,
 			  struct work_struct *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
@@ -373,13 +373,13 @@ int __init trace_workqueue_early_init(void)
 	if (ret)
 		goto out;
 
-	ret = register_trace_workqueue_execution(probe_workqueue_execution);
+	ret = register_trace_workqueue_handler_entry(probe_workqueue_entry);
 	if (ret)
 		goto no_insertion;
 
 	ret = register_trace_workqueue_creation(probe_workqueue_creation);
 	if (ret)
-		goto no_execution;
+		goto no_handler_entry;
 
 	ret = register_trace_workqueue_destruction(probe_workqueue_destruction);
 	if (ret)
@@ -394,8 +394,8 @@ int __init trace_workqueue_early_init(void)
 
 no_creation:
 	unregister_trace_workqueue_creation(probe_workqueue_creation);
-no_execution:
-	unregister_trace_workqueue_execution(probe_workqueue_execution);
+no_handler_entry:
+	unregister_trace_workqueue_handler_entry(probe_workqueue_entry);
 no_insertion:
 	unregister_trace_workqueue_insertion(probe_workqueue_insertion);
 out:
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0668795..fbcdfa2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -279,7 +279,6 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 		 */
 		struct lockdep_map lockdep_map = work->lockdep_map;
 #endif
-		trace_workqueue_execution(cwq->thread, work);
 		cwq->current_work = work;
 		list_del_init(cwq->worklist.next);
 		spin_unlock_irq(&cwq->lock);
@@ -288,7 +287,9 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 		work_clear_pending(work);
 		lock_map_acquire(&cwq->wq->lockdep_map);
 		lock_map_acquire(&lockdep_map);
+		trace_workqueue_handler_entry(cwq->thread, work);
 		f(work);
+		trace_workqueue_handler_exit(cwq->thread, work);
 		lock_map_release(&lockdep_map);
 		lock_map_release(&cwq->wq->lockdep_map);
 
-- 
1.5.5.3


