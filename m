Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbZGYGER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbZGYGER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 02:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbZGYGEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 02:04:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:53818 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbZGYGEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 02:04:07 -0400
Subject: Re: [PATCH] sched: Provide iowait counters
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
In-Reply-To: <20090724220423.11828b85.akpm@linux-foundation.org>
References: <4A64B813.1080506@linux.intel.com>
	 <20090724212220.afa278ee.akpm@linux-foundation.org>
	 <4A6A8AFE.1010608@linux.intel.com>
	 <20090724214006.7380c3b4.akpm@linux-foundation.org>
	 <4A6A8E96.7050509@linux.intel.com>
	 <20090724220423.11828b85.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 25 Jul 2009 08:05:46 +0200
Message-Id: <1248501946.6987.146.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-24 at 22:04 -0700, Andrew Morton wrote:
> 
> > > See include/linux/sched.h's definition of task_delay_info - u64
> > > blkio_delay is in nanoseconds.  It uses
> > > do_posix_clock_monotonic_gettime() internally.
> > 
> > looks like it does.. to bad we don't expose that data in
> a /proc/<pid>/delay or something field
> > like we do with the scheduler info...
> > 
> 
> I thought we did deliver a few of the taskstats counters via procfs,
> but maybe I dreamed it.  It would have been a rather bad thing to do.
> 
> taskstats has a large advantage over /proc-based things: it delivers a
> packet to the monitoring process(es) when the monitored task exits.
> So
> with no polling at all it is possible to gather all that information
> about the just-completed task.  This isn't possible with /proc.
> 
> There's a patch on the list now to teach taskstats to emit a packet at
> fork- and exit-time too.
> 
> The monitored task can be polled at any time during its execution
> also,
> like /proc files.
> 
> Please consider switching whatever-you're-working-on over to use
> taskstats rather than adding (duplicative) things to /proc (which
> require CONFIG_SCHED_DEBUG, btw).
> 
> If there's stuff missing from taskstats then we can add it - it's
> versioned and upgradeable and is a better interface.  It's better
> to make taskstats stronger than it is to add /proc/pid fields,
> methinks.

The below exposes the information to ftrace and perf counters, it uses
the scheduler accounting (which is often much cheaper than
do_posix_clock_monotonic_gettime, and more 'accurate' in the sense that
its what the scheduler itself uses).

This allows profiling tasks based on iowait time, for example, something
not possible with taskstats afaik.

Maybe there's a use for taskstats still, maybe not.

---
Subject: sched: wait, sleep and iowait accounting tracepoints
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Jul 23 20:13:26 CEST 2009

Add 3 schedstat tracepoints to help account for wait-time, sleep-time
and iowait-time.

They can also be used as a perf-counter source to profile tasks on
these clocks.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 include/trace/events/sched.h |   95 +++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_fair.c          |   10 ++++
 2 files changed, 104 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -546,6 +546,11 @@ update_stats_wait_end(struct cfs_rq *cfs
 	schedstat_set(se->wait_sum, se->wait_sum +
 			rq_of(cfs_rq)->clock - se->wait_start);
 	schedstat_set(se->wait_start, 0);
+
+	if (entity_is_task(se)) {
+		trace_sched_stat_wait(task_of(se),
+			rq_of(cfs_rq)->clock - se->wait_start);
+	}
 }
 
 static inline void
@@ -636,8 +641,10 @@ static void enqueue_sleeper(struct cfs_r
 		se->sleep_start = 0;
 		se->sum_sleep_runtime += delta;
 
-		if (tsk)
+		if (tsk) {
 			account_scheduler_latency(tsk, delta >> 10, 1);
+			trace_sched_stat_sleep(tsk, delta);
+		}
 	}
 	if (se->block_start) {
 		u64 delta = rq_of(cfs_rq)->clock - se->block_start;
@@ -655,6 +662,7 @@ static void enqueue_sleeper(struct cfs_r
 			if (tsk->in_iowait) {
 				se->iowait_sum += delta;
 				se->iowait_count++;
+				trace_sched_stat_iowait(tsk, delta);
 			}
 
 			/*
Index: linux-2.6/include/trace/events/sched.h
===================================================================
--- linux-2.6.orig/include/trace/events/sched.h
+++ linux-2.6/include/trace/events/sched.h
@@ -340,6 +340,101 @@ TRACE_EVENT(sched_signal_send,
 		  __entry->sig, __entry->comm, __entry->pid)
 );
 
+/*
+ * XXX the below sched_stat tracepoints only apply to SCHED_OTHER/BATCH/IDLE
+ *     adding sched_stat support to SCHED_FIFO/RR would be welcome.
+ */
+
+/*
+ * Tracepoint for accounting wait time (time the task is runnable
+ * but not actually running due to scheduler contention).
+ */
+TRACE_EVENT(sched_stat_wait,
+
+	TP_PROTO(struct task_struct *tsk, u64 delay),
+
+	TP_ARGS(tsk, delay),
+
+	TP_STRUCT__entry(
+		__array( char,	comm,	TASK_COMM_LEN	)
+		__field( pid_t,	pid			)
+		__field( u64,	delay			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid	= tsk->pid;
+		__entry->delay	= delay;
+	)
+	TP_perf_assign(
+		__perf_count(delay);
+	),
+
+	TP_printk("task: %s:%d wait: %Lu [ns]",
+			__entry->comm, __entry->pid,
+			(unsigned long long)__entry->delay)
+);
+
+/*
+ * Tracepoint for accounting sleep time (time the task is not runnable,
+ * including iowait, see below).
+ */
+TRACE_EVENT(sched_stat_sleep,
+
+	TP_PROTO(struct task_struct *tsk, u64 delay),
+
+	TP_ARGS(tsk, delay),
+
+	TP_STRUCT__entry(
+		__array( char,	comm,	TASK_COMM_LEN	)
+		__field( pid_t,	pid			)
+		__field( u64,	delay			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid	= tsk->pid;
+		__entry->delay	= delay;
+	)
+	TP_perf_assign(
+		__perf_count(delay);
+	),
+
+	TP_printk("task: %s:%d sleep: %Lu [ns]",
+			__entry->comm, __entry->pid,
+			(unsigned long long)__entry->delay)
+);
+
+/*
+ * Tracepoint for accounting iowait time (time the task is not runnable
+ * due to waiting on IO to complete).
+ */
+TRACE_EVENT(sched_stat_iowait,
+
+	TP_PROTO(struct task_struct *tsk, u64 delay),
+
+	TP_ARGS(tsk, delay),
+
+	TP_STRUCT__entry(
+		__array( char,	comm,	TASK_COMM_LEN	)
+		__field( pid_t,	pid			)
+		__field( u64,	delay			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid	= tsk->pid;
+		__entry->delay	= delay;
+	)
+	TP_perf_assign(
+		__perf_count(delay);
+	),
+
+	TP_printk("task: %s:%d iowait: %Lu [ns]",
+			__entry->comm, __entry->pid,
+			(unsigned long long)__entry->delay)
+);
+
 #endif /* _TRACE_SCHED_H */
 
 /* This part must be outside protection */

