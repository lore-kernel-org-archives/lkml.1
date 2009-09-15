Return-Path: <linux-kernel-owner+w=401wt.eu-S1752487AbZIOJgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbZIOJgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbZIOJgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:36:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:57420 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbZIOJgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:36:14 -0400
Date: Tue, 15 Sep 2009 09:35:39 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf_counter, sched: Add sched_stat_runtime tracepoint
Message-ID: <tip-f977bb4937857994312fff4f9c2cad336a36a932@git.kernel.org>
Git-Commit-ID: f977bb4937857994312fff4f9c2cad336a36a932
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:35:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f977bb4937857994312fff4f9c2cad336a36a932
Gitweb:     http://git.kernel.org/tip/f977bb4937857994312fff4f9c2cad336a36a932
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 13 Sep 2009 18:15:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 13 Sep 2009 18:17:28 +0200

perf_counter, sched: Add sched_stat_runtime tracepoint

This allows more precise tracking of how the scheduler accounts
(and acts upon) a task having spent N nanoseconds of CPU time.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/trace/events/sched.h |   33 +++++++++++++++++++++++++++++++++
 kernel/sched_fair.c          |    1 +
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index b48f1ad..4069c43 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -380,6 +380,39 @@ TRACE_EVENT(sched_stat_wait,
 );
 
 /*
+ * Tracepoint for accounting runtime (time the task is executing
+ * on a CPU).
+ */
+TRACE_EVENT(sched_stat_runtime,
+
+	TP_PROTO(struct task_struct *tsk, u64 runtime, u64 vruntime),
+
+	TP_ARGS(tsk, runtime, vruntime),
+
+	TP_STRUCT__entry(
+		__array( char,	comm,	TASK_COMM_LEN	)
+		__field( pid_t,	pid			)
+		__field( u64,	runtime			)
+		__field( u64,	vruntime			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid		= tsk->pid;
+		__entry->runtime	= runtime;
+		__entry->vruntime	= vruntime;
+	)
+	TP_perf_assign(
+		__perf_count(runtime);
+	),
+
+	TP_printk("task: %s:%d runtime: %Lu [ns], vruntime: %Lu [ns]",
+			__entry->comm, __entry->pid,
+			(unsigned long long)__entry->runtime,
+			(unsigned long long)__entry->vruntime)
+);
+
+/*
  * Tracepoint for accounting sleep time (time the task is not runnable,
  * including iowait, see below).
  */
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index aa7f841..a097e90 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -513,6 +513,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	if (entity_is_task(curr)) {
 		struct task_struct *curtask = task_of(curr);
 
+		trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
 		cpuacct_charge(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
 	}
