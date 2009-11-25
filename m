Return-Path: <linux-kernel-owner+w=401wt.eu-S934539AbZKYEjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934539AbZKYEjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 23:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934499AbZKYEjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 23:39:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43139 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934502AbZKYEjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 23:39:08 -0500
Message-Id: <20091125043912.958647085@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 24 Nov 2009 23:38:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] [PATCH 3/3] tracing: Convert some sched trace events to DEFINE_EVENT and _PRINT
References: <20091125043811.603607335@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Convert-some-sched-trace-events-to-DEFINE_EV.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Converting some of the scheduler trace events to use the
TRACE_EVENT_TEMPLATE, DEFINE_EVENT and DEFINE_EVENT_PRINT helped to
save some space:

$ size kernel/sched.o-*
   text	   data	    bss	    dec	    hex	filename
  79299	   6776	   2520	  88595	  15a13	kernel/sched.o-notrace
 101941	  11896	   2584	 116421	  1c6c5	kernel/sched.o-templ
 104779	  11896	   2584	 119259	  1d1db	kernel/sched.o-trace

sched.o-notrace is without any tracepoints compiled
sched.o-templ is with this patch
sched.o-trace is the tracepoints before this patch

The trace events converted to DEFINE_EVENT:

sched_wakeup, sched_wakeup_new, sched_process_free, sched_process_exit,
and sched_stat_wait.

The trace events converted to DEFINE_EVENT_PRINT:

sched_stat_sleep and sched_stat_iowait.

Note, since the TRACE_EVENT_TEMPLATE always uses a print, the
sched_stat_wait print format is defined in the template and this
template is used by sched_stat_sleep and sched_stat_iowait. But the
later two override the print format.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/sched.h |  170 +++++++++++++-----------------------------
 1 files changed, 52 insertions(+), 118 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index b50b985..238f74b 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -83,7 +83,7 @@ TRACE_EVENT(sched_wait_task,
  * (NOTE: the 'rq' argument is not used by generic trace events,
  *        but used by the latency tracer plugin. )
  */
-TRACE_EVENT(sched_wakeup,
+TRACE_EVENT_TEMPLATE(sched_wakeup_template,
 
 	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
 
@@ -110,38 +110,19 @@ TRACE_EVENT(sched_wakeup,
 		  __entry->success, __entry->target_cpu)
 );
 
+DEFINE_EVENT(sched_wakeup_template, sched_wakeup,
+	     TP_PROTO(struct rq *rq, struct task_struct *p, int success),
+	     TP_ARGS(rq, p, success));
+
 /*
  * Tracepoint for waking up a new task:
  *
  * (NOTE: the 'rq' argument is not used by generic trace events,
  *        but used by the latency tracer plugin. )
  */
-TRACE_EVENT(sched_wakeup_new,
-
-	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
-
-	TP_ARGS(rq, p, success),
-
-	TP_STRUCT__entry(
-		__array(	char,	comm,	TASK_COMM_LEN	)
-		__field(	pid_t,	pid			)
-		__field(	int,	prio			)
-		__field(	int,	success			)
-		__field(	int,	target_cpu		)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
-		__entry->pid		= p->pid;
-		__entry->prio		= p->prio;
-		__entry->success	= success;
-		__entry->target_cpu	= task_cpu(p);
-	),
-
-	TP_printk("comm=%s pid=%d prio=%d success=%d target_cpu=%03d",
-		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->success, __entry->target_cpu)
-);
+DEFINE_EVENT(sched_wakeup_template, sched_wakeup_new,
+	     TP_PROTO(struct rq *rq, struct task_struct *p, int success),
+	     TP_ARGS(rq, p, success));
 
 /*
  * Tracepoint for task switches, performed by the scheduler:
@@ -216,10 +197,7 @@ TRACE_EVENT(sched_migrate_task,
 		  __entry->orig_cpu, __entry->dest_cpu)
 );
 
-/*
- * Tracepoint for freeing a task:
- */
-TRACE_EVENT(sched_process_free,
+TRACE_EVENT_TEMPLATE(sched_process_template,
 
 	TP_PROTO(struct task_struct *p),
 
@@ -242,29 +220,19 @@ TRACE_EVENT(sched_process_free,
 );
 
 /*
- * Tracepoint for a task exiting:
+ * Tracepoint for freeing a task:
  */
-TRACE_EVENT(sched_process_exit,
-
-	TP_PROTO(struct task_struct *p),
+DEFINE_EVENT(sched_process_template, sched_process_free,
+	     TP_PROTO(struct task_struct *p),
+	     TP_ARGS(p));
+	     
 
-	TP_ARGS(p),
-
-	TP_STRUCT__entry(
-		__array(	char,	comm,	TASK_COMM_LEN	)
-		__field(	pid_t,	pid			)
-		__field(	int,	prio			)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
-		__entry->pid		= p->pid;
-		__entry->prio		= p->prio;
-	),
-
-	TP_printk("comm=%s pid=%d prio=%d",
-		  __entry->comm, __entry->pid, __entry->prio)
-);
+/*
+ * Tracepoint for a task exiting:
+ */
+DEFINE_EVENT(sched_process_template, sched_process_exit,
+	     TP_PROTO(struct task_struct *p),
+	     TP_ARGS(p));
 
 /*
  * Tracepoint for a waiting task:
@@ -348,12 +316,7 @@ TRACE_EVENT(sched_signal_send,
  * XXX the below sched_stat tracepoints only apply to SCHED_OTHER/BATCH/IDLE
  *     adding sched_stat support to SCHED_FIFO/RR would be welcome.
  */
-
-/*
- * Tracepoint for accounting wait time (time the task is runnable
- * but not actually running due to scheduler contention).
- */
-TRACE_EVENT(sched_stat_wait,
+TRACE_EVENT_TEMPLATE(sched_stat_template,
 
 	TP_PROTO(struct task_struct *tsk, u64 delay),
 
@@ -379,6 +342,37 @@ TRACE_EVENT(sched_stat_wait,
 			(unsigned long long)__entry->delay)
 );
 
+
+/*
+ * Tracepoint for accounting wait time (time the task is runnable
+ * but not actually running due to scheduler contention).
+ */
+DEFINE_EVENT(sched_stat_template, sched_stat_wait,
+	     TP_PROTO(struct task_struct *tsk, u64 delay),
+	     TP_ARGS(tsk, delay));
+
+/*
+ * Tracepoint for accounting sleep time (time the task is not runnable,
+ * including iowait, see below).
+ */
+DEFINE_EVENT_PRINT(sched_stat_template, sched_stat_sleep,
+		   TP_PROTO(struct task_struct *tsk, u64 delay),
+		   TP_ARGS(tsk, delay),
+		   TP_printk("task: %s:%d sleep: %Lu [ns]",
+			     __entry->comm, __entry->pid,
+			     (unsigned long long)__entry->delay));
+
+/*
+ * Tracepoint for accounting iowait time (time the task is not runnable
+ * due to waiting on IO to complete).
+ */
+DEFINE_EVENT_PRINT(sched_stat_template, sched_stat_iowait,
+		   TP_PROTO(struct task_struct *tsk, u64 delay),
+		   TP_ARGS(tsk, delay),
+		   TP_printk("task: %s:%d iowait: %Lu [ns]",
+			     __entry->comm, __entry->pid,
+			     (unsigned long long)__entry->delay));
+
 /*
  * Tracepoint for accounting runtime (time the task is executing
  * on a CPU).
@@ -412,66 +406,6 @@ TRACE_EVENT(sched_stat_runtime,
 			(unsigned long long)__entry->vruntime)
 );
 
-/*
- * Tracepoint for accounting sleep time (time the task is not runnable,
- * including iowait, see below).
- */
-TRACE_EVENT(sched_stat_sleep,
-
-	TP_PROTO(struct task_struct *tsk, u64 delay),
-
-	TP_ARGS(tsk, delay),
-
-	TP_STRUCT__entry(
-		__array( char,	comm,	TASK_COMM_LEN	)
-		__field( pid_t,	pid			)
-		__field( u64,	delay			)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
-		__entry->pid	= tsk->pid;
-		__entry->delay	= delay;
-	)
-	TP_perf_assign(
-		__perf_count(delay);
-	),
-
-	TP_printk("comm=%s pid=%d delay=%Lu [ns]",
-			__entry->comm, __entry->pid,
-			(unsigned long long)__entry->delay)
-);
-
-/*
- * Tracepoint for accounting iowait time (time the task is not runnable
- * due to waiting on IO to complete).
- */
-TRACE_EVENT(sched_stat_iowait,
-
-	TP_PROTO(struct task_struct *tsk, u64 delay),
-
-	TP_ARGS(tsk, delay),
-
-	TP_STRUCT__entry(
-		__array( char,	comm,	TASK_COMM_LEN	)
-		__field( pid_t,	pid			)
-		__field( u64,	delay			)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
-		__entry->pid	= tsk->pid;
-		__entry->delay	= delay;
-	)
-	TP_perf_assign(
-		__perf_count(delay);
-	),
-
-	TP_printk("comm=%s pid=%d delay=%Lu [ns]",
-			__entry->comm, __entry->pid,
-			(unsigned long long)__entry->delay)
-);
-
 #endif /* _TRACE_SCHED_H */
 
 /* This part must be outside protection */
-- 
1.6.5


