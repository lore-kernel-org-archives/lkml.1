Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZESVGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZESVGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 17:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbZESVGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 17:06:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44897 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496AbZESVGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 17:06:11 -0400
Date: Tue, 19 May 2009 17:03:51 -0400
Message-Id: <fa1a662e2906d9666f1ea4043b16a5ad49d5e37e.1242763826.git.jbaron@redhat.com>
In-Reply-To: <cover.1242763826.git.jbaron@redhat.com>
References: <cover.1242763826.git.jbaron@redhat.com>
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: [PATCH 2/3] tracepoints: convert scheduler tracepoints to 'tracepoint_call' api
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Convert the scheduler tracepoints to the new 'tracepoint_call' api.


Signed-off-by: Jason Baron <jbaron@redhat.com>


---
 kernel/exit.c    |    6 +++---
 kernel/fork.c    |    2 +-
 kernel/kthread.c |    4 ++--
 kernel/sched.c   |   10 +++++-----
 kernel/signal.c  |    2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 700d110..5bd103f 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -157,7 +157,7 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
 #ifdef CONFIG_PERF_COUNTERS
 	WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
 #endif
-	trace_sched_process_free(tsk);
+	tracepoint_call(sched_process_free, tsk);
 	put_task_struct(tsk);
 }
 
@@ -964,7 +964,7 @@ NORET_TYPE void do_exit(long code)
 
 	if (group_dead)
 		acct_process();
-	trace_sched_process_exit(tsk);
+	tracepoint_call(sched_process_exit, tsk);
 
 	exit_sem(tsk);
 	exit_files(tsk);
@@ -1580,7 +1580,7 @@ static long do_wait(enum pid_type type, struct pid *pid, int options,
 	struct task_struct *tsk;
 	int retval;
 
-	trace_sched_process_wait(pid);
+	tracepoint_call(sched_process_wait, pid);
 
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
diff --git a/kernel/fork.c b/kernel/fork.c
index 60a473e..2f718ae 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1396,7 +1396,7 @@ long do_fork(unsigned long clone_flags,
 	if (!IS_ERR(p)) {
 		struct completion vfork;
 
-		trace_sched_process_fork(current, p);
+		tracepoint_call(sched_process_fork, current, p);
 
 		nr = task_pid_vnr(p);
 
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 41c88fe..28ecded 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -204,7 +204,7 @@ int kthread_stop(struct task_struct *k)
 	/* It could exit after stop_info.k set, but before wake_up_process. */
 	get_task_struct(k);
 
-	trace_sched_kthread_stop(k);
+	tracepoint_call(sched_kthread_stop, k);
 
 	/* Must init completion *before* thread sees kthread_stop_info.k */
 	init_completion(&kthread_stop_info.done);
@@ -221,7 +221,7 @@ int kthread_stop(struct task_struct *k)
 	ret = kthread_stop_info.err;
 	mutex_unlock(&kthread_stop_lock);
 
-	trace_sched_kthread_stop_ret(ret);
+	tracepoint_call(sched_kthread_stop_ret, ret);
 
 	return ret;
 }
diff --git a/kernel/sched.c b/kernel/sched.c
index c036590..28c0f16 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1962,7 +1962,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 
 	clock_offset = old_rq->clock - new_rq->clock;
 
-	trace_sched_migrate_task(p, new_cpu);
+	tracepoint_call(sched_migrate_task, p, new_cpu);
 
 #ifdef CONFIG_SCHEDSTATS
 	if (p->se.wait_start)
@@ -2119,7 +2119,7 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * just go back and repeat.
 		 */
 		rq = task_rq_lock(p, &flags);
-		trace_sched_wait_task(rq, p);
+		tracepoint_call(sched_wait_task, rq, p);
 		running = task_running(rq, p);
 		on_rq = p->se.on_rq;
 		ncsw = 0;
@@ -2515,7 +2515,7 @@ out_activate:
 	}
 
 out_running:
-	trace_sched_wakeup(rq, p, success);
+	tracepoint_call(sched_wakeup, rq, p, success);
 	check_preempt_curr(rq, p, sync);
 
 	p->state = TASK_RUNNING;
@@ -2662,7 +2662,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 		p->sched_class->task_new(rq, p);
 		inc_nr_running(rq);
 	}
-	trace_sched_wakeup_new(rq, p, 1);
+	tracepoint_call(sched_wakeup_new, rq, p, 1);
 	check_preempt_curr(rq, p, 0);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_wake_up)
@@ -2842,7 +2842,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
-	trace_sched_switch(rq, prev, next);
+	tracepoint_call(sched_switch, rq, prev, next);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
diff --git a/kernel/signal.c b/kernel/signal.c
index dba6ae9..19596c1 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -828,7 +828,7 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 	struct sigpending *pending;
 	struct sigqueue *q;
 
-	trace_sched_signal_send(sig, t);
+	tracepoint_call(sched_signal_send, sig, t);
 
 	assert_spin_locked(&t->sighand->siglock);
 
-- 
1.6.0.6

