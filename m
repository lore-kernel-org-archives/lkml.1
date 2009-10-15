Return-Path: <linux-kernel-owner+w=401wt.eu-S1762598AbZJOKsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762598AbZJOKsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 06:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbZJOKsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 06:48:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:35010 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758120AbZJOKr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 06:47:58 -0400
Date: Thu, 15 Oct 2009 10:46:24 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] events: Harmonize event field names and print output names
Message-ID: <tip-434a83c3fbb951908a3a52040f7f0e0b8ba00dd0@git.kernel.org>
Git-Commit-ID: 434a83c3fbb951908a3a52040f7f0e0b8ba00dd0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 10:46:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  434a83c3fbb951908a3a52040f7f0e0b8ba00dd0
Gitweb:     http://git.kernel.org/tip/434a83c3fbb951908a3a52040f7f0e0b8ba00dd0
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 15 Oct 2009 11:50:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 12:42:03 +0200

events: Harmonize event field names and print output names

Now that we can filter based on fields via perf record, people
will start using filter expressions and will expect them to
be obvious.

The primary way to see which fields are available is by looking
at the trace output, such as:

  gcc-18676 [000]   343.011728: irq_handler_entry: irq=0 handler=timer
  cc1-18677 [000]   343.012727: irq_handler_entry: irq=0 handler=timer
  cc1-18677 [000]   343.032692: irq_handler_entry: irq=0 handler=timer
  cc1-18677 [000]   343.033690: irq_handler_entry: irq=0 handler=timer
  cc1-18677 [000]   343.034687: irq_handler_entry: irq=0 handler=timer
  cc1-18677 [000]   343.035686: irq_handler_entry: irq=0 handler=timer
  cc1-18677 [000]   343.036684: irq_handler_entry: irq=0 handler=timer

While 'irq==0' filters work, the 'handler==<x>' filter expression
does not work:

  $ perf record -R -f -a -e irq:irq_handler_entry --filter handler=timer sleep 1
   Error: failed to set filter with 22 (Invalid argument)

The problem is that while an 'irq' field exists and is recognized
as a filter field - 'handler' does not exist - its name is 'name'
in the output.

To solve this, we need to synchronize the printout and the field
names, wherever possible.

In cases where the printout prints a non-field, we enclose
that information in square brackets, such as:

  perf-1380  [013]   724.903505: softirq_exit: vec=9 [action=RCU]
  perf-1380  [013]   724.904482: softirq_exit: vec=1 [action=TIMER]

This way users can use filter expressions more intuitively: all
fields that show up as 'primary' (non-bracketed) information is
filterable.

This patch harmonizes the field names for all irq, bkl, power,
sched and timer events.

We might in fact think about dropping the print format bit of
generic tracepoints altogether, and just print the fields that
are being recorded.

Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/bkl.h   |   18 +++++-----
 include/trace/events/irq.h   |    8 ++--
 include/trace/events/power.h |    2 -
 include/trace/events/sched.h |   44 ++++++++++++------------
 include/trace/events/timer.h |   79 ++++++++++++++++++++---------------------
 5 files changed, 74 insertions(+), 77 deletions(-)

diff --git a/include/trace/events/bkl.h b/include/trace/events/bkl.h
index 8abd620..1af72dc 100644
--- a/include/trace/events/bkl.h
+++ b/include/trace/events/bkl.h
@@ -13,7 +13,7 @@ TRACE_EVENT(lock_kernel,
 	TP_ARGS(func, file, line),
 
 	TP_STRUCT__entry(
-		__field(	int,		lock_depth		)
+		__field(	int,		depth			)
 		__field_ext(	const char *,	func, FILTER_PTR_STRING	)
 		__field_ext(	const char *,	file, FILTER_PTR_STRING	)
 		__field(	int,		line			)
@@ -21,13 +21,13 @@ TRACE_EVENT(lock_kernel,
 
 	TP_fast_assign(
 		/* We want to record the lock_depth after lock is acquired */
-		__entry->lock_depth = current->lock_depth + 1;
+		__entry->depth = current->lock_depth + 1;
 		__entry->func = func;
 		__entry->file = file;
 		__entry->line = line;
 	),
 
-	TP_printk("depth: %d, %s:%d %s()", __entry->lock_depth,
+	TP_printk("depth=%d file:line=%s:%d func=%s()", __entry->depth,
 		  __entry->file, __entry->line, __entry->func)
 );
 
@@ -38,20 +38,20 @@ TRACE_EVENT(unlock_kernel,
 	TP_ARGS(func, file, line),
 
 	TP_STRUCT__entry(
-		__field(int,		lock_depth)
-		__field(const char *,	func)
-		__field(const char *,	file)
-		__field(int,		line)
+		__field(int,		depth		)
+		__field(const char *,	func		)
+		__field(const char *,	file		)
+		__field(int,		line		)
 	),
 
 	TP_fast_assign(
-		__entry->lock_depth = current->lock_depth;
+		__entry->depth = current->lock_depth;
 		__entry->func = func;
 		__entry->file = file;
 		__entry->line = line;
 	),
 
-	TP_printk("depth: %d, %s:%d %s()", __entry->lock_depth,
+	TP_printk("depth=%d file:line=%s:%d func=%s()", __entry->depth,
 		  __entry->file, __entry->line, __entry->func)
 );
 
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index b89f9db..dcfcd44 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -48,7 +48,7 @@ TRACE_EVENT(irq_handler_entry,
 		__assign_str(name, action->name);
 	),
 
-	TP_printk("irq=%d handler=%s", __entry->irq, __get_str(name))
+	TP_printk("irq=%d name=%s", __entry->irq, __get_str(name))
 );
 
 /**
@@ -78,7 +78,7 @@ TRACE_EVENT(irq_handler_exit,
 		__entry->ret	= ret;
 	),
 
-	TP_printk("irq=%d return=%s",
+	TP_printk("irq=%d ret=%s",
 		  __entry->irq, __entry->ret ? "handled" : "unhandled")
 );
 
@@ -107,7 +107,7 @@ TRACE_EVENT(softirq_entry,
 		__entry->vec = (int)(h - vec);
 	),
 
-	TP_printk("softirq=%d action=%s", __entry->vec,
+	TP_printk("vec=%d [action=%s]", __entry->vec,
 		  show_softirq_name(__entry->vec))
 );
 
@@ -136,7 +136,7 @@ TRACE_EVENT(softirq_exit,
 		__entry->vec = (int)(h - vec);
 	),
 
-	TP_printk("softirq=%d action=%s", __entry->vec,
+	TP_printk("vec=%d [action=%s]", __entry->vec,
 		  show_softirq_name(__entry->vec))
 );
 
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index ea6d579..9bb96e5 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -16,8 +16,6 @@ enum {
 };
 #endif
 
-
-
 TRACE_EVENT(power_start,
 
 	TP_PROTO(unsigned int type, unsigned int state),
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 4069c43..b50b985 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -26,7 +26,7 @@ TRACE_EVENT(sched_kthread_stop,
 		__entry->pid	= t->pid;
 	),
 
-	TP_printk("task %s:%d", __entry->comm, __entry->pid)
+	TP_printk("comm=%s pid=%d", __entry->comm, __entry->pid)
 );
 
 /*
@@ -46,7 +46,7 @@ TRACE_EVENT(sched_kthread_stop_ret,
 		__entry->ret	= ret;
 	),
 
-	TP_printk("ret %d", __entry->ret)
+	TP_printk("ret=%d", __entry->ret)
 );
 
 /*
@@ -73,7 +73,7 @@ TRACE_EVENT(sched_wait_task,
 		__entry->prio	= p->prio;
 	),
 
-	TP_printk("task %s:%d [%d]",
+	TP_printk("comm=%s pid=%d prio=%d",
 		  __entry->comm, __entry->pid, __entry->prio)
 );
 
@@ -94,7 +94,7 @@ TRACE_EVENT(sched_wakeup,
 		__field(	pid_t,	pid			)
 		__field(	int,	prio			)
 		__field(	int,	success			)
-		__field(	int,	cpu			)
+		__field(	int,	target_cpu		)
 	),
 
 	TP_fast_assign(
@@ -102,12 +102,12 @@ TRACE_EVENT(sched_wakeup,
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
 		__entry->success	= success;
-		__entry->cpu		= task_cpu(p);
+		__entry->target_cpu	= task_cpu(p);
 	),
 
-	TP_printk("task %s:%d [%d] success=%d [%03d]",
+	TP_printk("comm=%s pid=%d prio=%d success=%d target_cpu=%03d",
 		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->success, __entry->cpu)
+		  __entry->success, __entry->target_cpu)
 );
 
 /*
@@ -127,7 +127,7 @@ TRACE_EVENT(sched_wakeup_new,
 		__field(	pid_t,	pid			)
 		__field(	int,	prio			)
 		__field(	int,	success			)
-		__field(	int,	cpu			)
+		__field(	int,	target_cpu		)
 	),
 
 	TP_fast_assign(
@@ -135,12 +135,12 @@ TRACE_EVENT(sched_wakeup_new,
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
 		__entry->success	= success;
-		__entry->cpu		= task_cpu(p);
+		__entry->target_cpu	= task_cpu(p);
 	),
 
-	TP_printk("task %s:%d [%d] success=%d [%03d]",
+	TP_printk("comm=%s pid=%d prio=%d success=%d target_cpu=%03d",
 		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->success, __entry->cpu)
+		  __entry->success, __entry->target_cpu)
 );
 
 /*
@@ -176,7 +176,7 @@ TRACE_EVENT(sched_switch,
 		__entry->next_prio	= next->prio;
 	),
 
-	TP_printk("task %s:%d [%d] (%s) ==> %s:%d [%d]",
+	TP_printk("prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s ==> next_comm=%s next_pid=%d next_prio=%d",
 		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
 		__entry->prev_state ?
 		  __print_flags(__entry->prev_state, "|",
@@ -211,7 +211,7 @@ TRACE_EVENT(sched_migrate_task,
 		__entry->dest_cpu	= dest_cpu;
 	),
 
-	TP_printk("task %s:%d [%d] from: %d  to: %d",
+	TP_printk("comm=%s pid=%d prio=%d orig_cpu=%d dest_cpu=%d",
 		  __entry->comm, __entry->pid, __entry->prio,
 		  __entry->orig_cpu, __entry->dest_cpu)
 );
@@ -237,7 +237,7 @@ TRACE_EVENT(sched_process_free,
 		__entry->prio		= p->prio;
 	),
 
-	TP_printk("task %s:%d [%d]",
+	TP_printk("comm=%s pid=%d prio=%d",
 		  __entry->comm, __entry->pid, __entry->prio)
 );
 
@@ -262,7 +262,7 @@ TRACE_EVENT(sched_process_exit,
 		__entry->prio		= p->prio;
 	),
 
-	TP_printk("task %s:%d [%d]",
+	TP_printk("comm=%s pid=%d prio=%d",
 		  __entry->comm, __entry->pid, __entry->prio)
 );
 
@@ -287,7 +287,7 @@ TRACE_EVENT(sched_process_wait,
 		__entry->prio		= current->prio;
 	),
 
-	TP_printk("task %s:%d [%d]",
+	TP_printk("comm=%s pid=%d prio=%d",
 		  __entry->comm, __entry->pid, __entry->prio)
 );
 
@@ -314,7 +314,7 @@ TRACE_EVENT(sched_process_fork,
 		__entry->child_pid	= child->pid;
 	),
 
-	TP_printk("parent %s:%d  child %s:%d",
+	TP_printk("comm=%s pid=%d child_comm=%s child_pid=%d",
 		__entry->parent_comm, __entry->parent_pid,
 		__entry->child_comm, __entry->child_pid)
 );
@@ -340,7 +340,7 @@ TRACE_EVENT(sched_signal_send,
 		__entry->sig	= sig;
 	),
 
-	TP_printk("sig: %d  task %s:%d",
+	TP_printk("sig=%d comm=%s pid=%d",
 		  __entry->sig, __entry->comm, __entry->pid)
 );
 
@@ -374,7 +374,7 @@ TRACE_EVENT(sched_stat_wait,
 		__perf_count(delay);
 	),
 
-	TP_printk("task: %s:%d wait: %Lu [ns]",
+	TP_printk("comm=%s pid=%d delay=%Lu [ns]",
 			__entry->comm, __entry->pid,
 			(unsigned long long)__entry->delay)
 );
@@ -406,7 +406,7 @@ TRACE_EVENT(sched_stat_runtime,
 		__perf_count(runtime);
 	),
 
-	TP_printk("task: %s:%d runtime: %Lu [ns], vruntime: %Lu [ns]",
+	TP_printk("comm=%s pid=%d runtime=%Lu [ns] vruntime=%Lu [ns]",
 			__entry->comm, __entry->pid,
 			(unsigned long long)__entry->runtime,
 			(unsigned long long)__entry->vruntime)
@@ -437,7 +437,7 @@ TRACE_EVENT(sched_stat_sleep,
 		__perf_count(delay);
 	),
 
-	TP_printk("task: %s:%d sleep: %Lu [ns]",
+	TP_printk("comm=%s pid=%d delay=%Lu [ns]",
 			__entry->comm, __entry->pid,
 			(unsigned long long)__entry->delay)
 );
@@ -467,7 +467,7 @@ TRACE_EVENT(sched_stat_iowait,
 		__perf_count(delay);
 	),
 
-	TP_printk("task: %s:%d iowait: %Lu [ns]",
+	TP_printk("comm=%s pid=%d delay=%Lu [ns]",
 			__entry->comm, __entry->pid,
 			(unsigned long long)__entry->delay)
 );
diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 1844c48..e5ce87a 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -26,7 +26,7 @@ TRACE_EVENT(timer_init,
 		__entry->timer	= timer;
 	),
 
-	TP_printk("timer %p", __entry->timer)
+	TP_printk("timer=%p", __entry->timer)
 );
 
 /**
@@ -54,7 +54,7 @@ TRACE_EVENT(timer_start,
 		__entry->now		= jiffies;
 	),
 
-	TP_printk("timer %p: func %pf, expires %lu, timeout %ld",
+	TP_printk("timer=%p function=%pf expires=%lu [timeout=%ld]",
 		  __entry->timer, __entry->function, __entry->expires,
 		  (long)__entry->expires - __entry->now)
 );
@@ -81,7 +81,7 @@ TRACE_EVENT(timer_expire_entry,
 		__entry->now		= jiffies;
 	),
 
-	TP_printk("timer %p: now %lu", __entry->timer, __entry->now)
+	TP_printk("timer=%p now=%lu", __entry->timer, __entry->now)
 );
 
 /**
@@ -108,7 +108,7 @@ TRACE_EVENT(timer_expire_exit,
 		__entry->timer	= timer;
 	),
 
-	TP_printk("timer %p", __entry->timer)
+	TP_printk("timer=%p", __entry->timer)
 );
 
 /**
@@ -129,7 +129,7 @@ TRACE_EVENT(timer_cancel,
 		__entry->timer	= timer;
 	),
 
-	TP_printk("timer %p", __entry->timer)
+	TP_printk("timer=%p", __entry->timer)
 );
 
 /**
@@ -140,24 +140,24 @@ TRACE_EVENT(timer_cancel,
  */
 TRACE_EVENT(hrtimer_init,
 
-	TP_PROTO(struct hrtimer *timer, clockid_t clockid,
+	TP_PROTO(struct hrtimer *hrtimer, clockid_t clockid,
 		 enum hrtimer_mode mode),
 
-	TP_ARGS(timer, clockid, mode),
+	TP_ARGS(hrtimer, clockid, mode),
 
 	TP_STRUCT__entry(
-		__field( void *,		timer		)
+		__field( void *,		hrtimer		)
 		__field( clockid_t,		clockid		)
 		__field( enum hrtimer_mode,	mode		)
 	),
 
 	TP_fast_assign(
-		__entry->timer		= timer;
+		__entry->hrtimer	= hrtimer;
 		__entry->clockid	= clockid;
 		__entry->mode		= mode;
 	),
 
-	TP_printk("hrtimer %p, clockid %s, mode %s", __entry->timer,
+	TP_printk("hrtimer=%p clockid=%s mode=%s", __entry->hrtimer,
 		  __entry->clockid == CLOCK_REALTIME ?
 			"CLOCK_REALTIME" : "CLOCK_MONOTONIC",
 		  __entry->mode == HRTIMER_MODE_ABS ?
@@ -170,26 +170,26 @@ TRACE_EVENT(hrtimer_init,
  */
 TRACE_EVENT(hrtimer_start,
 
-	TP_PROTO(struct hrtimer *timer),
+	TP_PROTO(struct hrtimer *hrtimer),
 
-	TP_ARGS(timer),
+	TP_ARGS(hrtimer),
 
 	TP_STRUCT__entry(
-		__field( void *,	timer		)
+		__field( void *,	hrtimer		)
 		__field( void *,	function	)
 		__field( s64,		expires		)
 		__field( s64,		softexpires	)
 	),
 
 	TP_fast_assign(
-		__entry->timer		= timer;
-		__entry->function	= timer->function;
-		__entry->expires	= hrtimer_get_expires(timer).tv64;
-		__entry->softexpires	= hrtimer_get_softexpires(timer).tv64;
+		__entry->hrtimer	= hrtimer;
+		__entry->function	= hrtimer->function;
+		__entry->expires	= hrtimer_get_expires(hrtimer).tv64;
+		__entry->softexpires	= hrtimer_get_softexpires(hrtimer).tv64;
 	),
 
-	TP_printk("hrtimer %p, func %pf, expires %llu, softexpires %llu",
-		  __entry->timer, __entry->function,
+	TP_printk("hrtimer=%p function=%pf expires=%llu softexpires=%llu",
+		  __entry->hrtimer, __entry->function,
 		  (unsigned long long)ktime_to_ns((ktime_t) {
 				  .tv64 = __entry->expires }),
 		  (unsigned long long)ktime_to_ns((ktime_t) {
@@ -206,23 +206,22 @@ TRACE_EVENT(hrtimer_start,
  */
 TRACE_EVENT(hrtimer_expire_entry,
 
-	TP_PROTO(struct hrtimer *timer, ktime_t *now),
+	TP_PROTO(struct hrtimer *hrtimer, ktime_t *now),
 
-	TP_ARGS(timer, now),
+	TP_ARGS(hrtimer, now),
 
 	TP_STRUCT__entry(
-		__field( void *,	timer	)
+		__field( void *,	hrtimer	)
 		__field( s64,		now	)
 	),
 
 	TP_fast_assign(
-		__entry->timer	= timer;
-		__entry->now	= now->tv64;
+		__entry->hrtimer	= hrtimer;
+		__entry->now		= now->tv64;
 	),
 
-	TP_printk("hrtimer %p, now %llu", __entry->timer,
-		  (unsigned long long)ktime_to_ns((ktime_t) {
-				  .tv64 = __entry->now }))
+	TP_printk("hrtimer=%p now=%llu", __entry->hrtimer,
+		  (unsigned long long)ktime_to_ns((ktime_t) { .tv64 = __entry->now }))
  );
 
 /**
@@ -234,40 +233,40 @@ TRACE_EVENT(hrtimer_expire_entry,
  */
 TRACE_EVENT(hrtimer_expire_exit,
 
-	TP_PROTO(struct hrtimer *timer),
+	TP_PROTO(struct hrtimer *hrtimer),
 
-	TP_ARGS(timer),
+	TP_ARGS(hrtimer),
 
 	TP_STRUCT__entry(
-		__field( void *,	timer	)
+		__field( void *,	hrtimer	)
 	),
 
 	TP_fast_assign(
-		__entry->timer	= timer;
+		__entry->hrtimer	= hrtimer;
 	),
 
-	TP_printk("hrtimer %p", __entry->timer)
+	TP_printk("hrtimer=%p", __entry->hrtimer)
 );
 
 /**
  * hrtimer_cancel - called when the hrtimer is canceled
- * @timer:	pointer to struct hrtimer
+ * @hrtimer:	pointer to struct hrtimer
  */
 TRACE_EVENT(hrtimer_cancel,
 
-	TP_PROTO(struct hrtimer *timer),
+	TP_PROTO(struct hrtimer *hrtimer),
 
-	TP_ARGS(timer),
+	TP_ARGS(hrtimer),
 
 	TP_STRUCT__entry(
-		__field( void *,	timer	)
+		__field( void *,	hrtimer	)
 	),
 
 	TP_fast_assign(
-		__entry->timer	= timer;
+		__entry->hrtimer	= hrtimer;
 	),
 
-	TP_printk("hrtimer %p", __entry->timer)
+	TP_printk("hrtimer=%p", __entry->hrtimer)
 );
 
 /**
@@ -302,7 +301,7 @@ TRACE_EVENT(itimer_state,
 		__entry->interval_usec	= value->it_interval.tv_usec;
 	),
 
-	TP_printk("which %d, expires %lu, it_value %lu.%lu, it_interval %lu.%lu",
+	TP_printk("which=%d expires=%lu it_value=%lu.%lu it_interval=%lu.%lu",
 		  __entry->which, __entry->expires,
 		  __entry->value_sec, __entry->value_usec,
 		  __entry->interval_sec, __entry->interval_usec)
@@ -332,7 +331,7 @@ TRACE_EVENT(itimer_expire,
 		__entry->pid	= pid_nr(pid);
 	),
 
-	    TP_printk("which %d, pid %d, now %lu", __entry->which,
+	    TP_printk("which=%d pid=%d now=%lu", __entry->which,
 		      (int) __entry->pid, __entry->now)
 );
 
