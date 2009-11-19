Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbZKSRLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbZKSRLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZKSRLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:11:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42853 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbZKSRLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:11:01 -0500
Message-Id: <20091119171107.059136550@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 19 Nov 2009 12:10:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] [PATCH 4/4] tracing: Convert some sched trace events to DEFINE_EVENT and _PRINT
References: <20091119171003.929771398@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Convert-some-sched-trace-events-to-DEFINE_EV.patch
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
index 4069c43..f31b43c 100644
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
 		  __entry->success, __entry->cpu)
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
-		__field(	int,	cpu			)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
-		__entry->pid		= p->pid;
-		__entry->prio		= p->prio;
-		__entry->success	= success;
-		__entry->cpu		= task_cpu(p);
-	),
-
-	TP_printk("task %s:%d [%d] success=%d [%03d]",
-		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->success, __entry->cpu)
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
-	TP_printk("task %s:%d [%d]",
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
-	TP_printk("task: %s:%d sleep: %Lu [ns]",
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
-	TP_printk("task: %s:%d iowait: %Lu [ns]",
-			__entry->comm, __entry->pid,
-			(unsigned long long)__entry->delay)
-);
-
 #endif /* _TRACE_SCHED_H */
 
 /* This part must be outside protection */
-- 
1.6.5


