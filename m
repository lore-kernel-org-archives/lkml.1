Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbZGWTWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbZGWTWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbZGWTWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:22:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48192 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbZGWTVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:21:13 -0400
Message-Id: <20090723191957.815237696@chello.nl>
References: <20090723191642.780643661@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 21:16:55 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 13/13] sched: wait, sleep and iowait accounting tracepoints
Content-Disposition: inline; filename=sched-stat-perf.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XXX: split in two

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
 include/trace/events/sched.h |   78 +++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_fair.c          |   49 +++++++++++++++++----------
 2 files changed, 110 insertions(+), 17 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -538,6 +538,11 @@ update_stats_wait_end(struct cfs_rq *cfs
 	schedstat_set(se->wait_sum, se->wait_sum +
 			rq_of(cfs_rq)->clock - se->wait_start);
 	schedstat_set(se->wait_start, 0);
+
+	if (entity_is_task(se)) {
+		trace_sched_acct_wait(task_of(se),
+			rq_of(cfs_rq)->clock - se->wait_start);
+	}
 }
 
 static inline void
@@ -611,9 +616,13 @@ account_entity_dequeue(struct cfs_rq *cf
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 #ifdef CONFIG_SCHEDSTATS
+	struct task_struct *tsk = NULL;
+
+	if (entity_is_task(se))
+		tsk = task_of(se);
+
 	if (se->sleep_start) {
 		u64 delta = rq_of(cfs_rq)->clock - se->sleep_start;
-		struct task_struct *tsk = task_of(se);
 
 		if ((s64)delta < 0)
 			delta = 0;
@@ -624,11 +633,13 @@ static void enqueue_sleeper(struct cfs_r
 		se->sleep_start = 0;
 		se->sum_sleep_runtime += delta;
 
-		account_scheduler_latency(tsk, delta >> 10, 1);
+		if (tsk) {
+			account_scheduler_latency(tsk, delta >> 10, 1);
+			trace_sched_acct_sleep(tsk, delta);
+		}
 	}
 	if (se->block_start) {
 		u64 delta = rq_of(cfs_rq)->clock - se->block_start;
-		struct task_struct *tsk = task_of(se);
 
 		if ((s64)delta < 0)
 			delta = 0;
@@ -639,22 +650,26 @@ static void enqueue_sleeper(struct cfs_r
 		se->block_start = 0;
 		se->sum_sleep_runtime += delta;
 
-		if (tsk->in_iowait) {
-			se->iowait_sum += delta;
-			se->iowait_count++;
-		}
-
-		/*
-		 * Blocking time is in units of nanosecs, so shift by 20 to
-		 * get a milliseconds-range estimation of the amount of
-		 * time that the task spent sleeping:
-		 */
-		if (unlikely(prof_on == SLEEP_PROFILING)) {
+		if (tsk) {
+			if (tsk->in_iowait) {
+				se->iowait_sum += delta;
+				se->iowait_count++;
+				if (tsk)
+					trace_sched_acct_iowait(tsk, delta);
+			}
 
-			profile_hits(SLEEP_PROFILING, (void *)get_wchan(tsk),
-				     delta >> 20);
+			/*
+			 * Blocking time is in units of nanosecs, so shift by
+			 * 20 to get a milliseconds-range estimation of the
+			 * amount of time that the task spent sleeping:
+			 */
+			if (unlikely(prof_on == SLEEP_PROFILING)) {
+				profile_hits(SLEEP_PROFILING,
+						(void *)get_wchan(tsk),
+						delta >> 20);
+			}
+			account_scheduler_latency(tsk, delta >> 10, 0);
 		}
-		account_scheduler_latency(tsk, delta >> 10, 0);
 	}
 #endif
 }
Index: linux-2.6/include/trace/events/sched.h
===================================================================
--- linux-2.6.orig/include/trace/events/sched.h
+++ linux-2.6/include/trace/events/sched.h
@@ -340,6 +340,84 @@ TRACE_EVENT(sched_signal_send,
 		  __entry->sig, __entry->comm, __entry->pid)
 );
 
+TRACE_EVENT(sched_acct_wait,
+
+	TP_PROTO(struct task_struct *tsk, u64 delta),
+
+	TP_ARGS(tsk, delta),
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
+		__entry->delay	= delta;
+	)
+	TP_perf_assign(
+		__perf_count(delta);
+	),
+
+	TP_printk("task: %s:%d wait: %Lu",
+			__entry->comm, __entry->pid,
+			(unsigned long long)__entry->delay)
+);
+
+TRACE_EVENT(sched_acct_sleep,
+
+	TP_PROTO(struct task_struct *tsk, u64 delta),
+
+	TP_ARGS(tsk, delta),
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
+		__entry->delay	= delta;
+	)
+	TP_perf_assign(
+		__perf_count(delta);
+	),
+
+	TP_printk("task: %s:%d sleep: %Lu",
+			__entry->comm, __entry->pid,
+			(unsigned long long)__entry->delay)
+);
+
+TRACE_EVENT(sched_acct_iowait,
+
+	TP_PROTO(struct task_struct *tsk, u64 delta),
+
+	TP_ARGS(tsk, delta),
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
+		__entry->delay	= delta;
+	)
+	TP_perf_assign(
+		__perf_count(delta);
+	),
+
+	TP_printk("task: %s:%d iowait: %Lu",
+			__entry->comm, __entry->pid,
+			(unsigned long long)__entry->delay)
+);
+
 #endif /* _TRACE_SCHED_H */
 
 /* This part must be outside protection */

-- 

