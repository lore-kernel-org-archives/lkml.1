Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbZIBHBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbZIBHBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 03:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbZIBHBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 03:01:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:59167 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708AbZIBHBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 03:01:34 -0400
Date: Wed, 2 Sep 2009 07:01:00 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       arjan@linux.intel.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
       arjan@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add wait, sleep and iowait accounting tracepoints
Message-ID: <tip-0486aef5e10a6b2f83c16cff1ff1b13ba5375ca9@git.kernel.org>
Git-Commit-ID: 0486aef5e10a6b2f83c16cff1ff1b13ba5375ca9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 02 Sep 2009 07:01:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0486aef5e10a6b2f83c16cff1ff1b13ba5375ca9
Gitweb:     http://git.kernel.org/tip/0486aef5e10a6b2f83c16cff1ff1b13ba5375ca9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 23 Jul 2009 20:13:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Sep 2009 08:44:09 +0200

sched: Add wait, sleep and iowait accounting tracepoints

Add 3 schedstat tracepoints to help account for wait-time,
sleep-time and iowait-time.

They can also be used as a perf-counter source to profile tasks
on these clocks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/trace/events/sched.h |   95 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_fair.c          |   10 ++++-
 2 files changed, 104 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 8949bb7..a4c369e 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
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
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 471fa28..0e4d6c5 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -546,6 +546,11 @@ update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
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
@@ -636,8 +641,10 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
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
@@ -655,6 +662,7 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 			if (tsk->in_iowait) {
 				se->iowait_sum += delta;
 				se->iowait_count++;
+				trace_sched_stat_iowait(tsk, delta);
 			}
 
 			/*
