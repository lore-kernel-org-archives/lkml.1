Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbZIPKVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbZIPKVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757985AbZIPKVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:21:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:46387 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757624AbZIPKU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:20:56 -0400
Date: Wed, 16 Sep 2009 10:20:37 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add TASK_WAKING
Message-ID: <tip-e9c8431185d6c406887190519f6dbdd112641686@git.kernel.org>
Git-Commit-ID: e9c8431185d6c406887190519f6dbdd112641686
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:20:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9c8431185d6c406887190519f6dbdd112641686
Gitweb:     http://git.kernel.org/tip/e9c8431185d6c406887190519f6dbdd112641686
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 15 Sep 2009 14:43:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:01:05 +0200

sched: Add TASK_WAKING

We're going to want to drop rq->lock in try_to_wake_up() for a
longer period of time, however we also want to deal with concurrent
waking of the same task, which is currently handled by holding
rq->lock.

So introduce a new TASK state, namely TASK_WAKING, which indicates
someone is already waking the task (other wakers will fail p->state
& state).

We also keep preemption disabled over the whole ttwu().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h |    1 +
 kernel/sched.c        |   31 +++++++++++++++----------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5d3c990..3b0ca66 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -190,6 +190,7 @@ extern unsigned long long time_sync_thresh;
 /* in tsk->state again */
 #define TASK_DEAD		64
 #define TASK_WAKEKILL		128
+#define TASK_WAKING		256
 
 /* Convenience macros for the sake of set_task_state */
 #define TASK_KILLABLE		(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
diff --git a/kernel/sched.c b/kernel/sched.c
index 32b7a81..fc6fda8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2310,7 +2310,6 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 {
 	int cpu, orig_cpu, this_cpu, success = 0;
 	unsigned long flags;
-	long old_state;
 	struct rq *rq;
 
 	if (!sched_feat(SYNC_WAKEUPS))
@@ -2332,11 +2331,12 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 	}
 #endif
 
+	this_cpu = get_cpu();
+
 	smp_wmb();
 	rq = task_rq_lock(p, &flags);
 	update_rq_clock(rq);
-	old_state = p->state;
-	if (!(old_state & state))
+	if (!(p->state & state))
 		goto out;
 
 	if (p->se.on_rq)
@@ -2344,27 +2344,25 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 
 	cpu = task_cpu(p);
 	orig_cpu = cpu;
-	this_cpu = smp_processor_id();
 
 #ifdef CONFIG_SMP
 	if (unlikely(task_running(rq, p)))
 		goto out_activate;
 
+	/*
+	 * In order to handle concurrent wakeups and release the rq->lock
+	 * we put the task in TASK_WAKING state.
+	 */
+	p->state = TASK_WAKING;
+	task_rq_unlock(rq, &flags);
+
 	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, sync);
-	if (cpu != orig_cpu) {
+	if (cpu != orig_cpu)
 		set_task_cpu(p, cpu);
-		task_rq_unlock(rq, &flags);
-		/* might preempt at this point */
-		rq = task_rq_lock(p, &flags);
-		old_state = p->state;
-		if (!(old_state & state))
-			goto out;
-		if (p->se.on_rq)
-			goto out_running;
 
-		this_cpu = smp_processor_id();
-		cpu = task_cpu(p);
-	}
+	rq = task_rq_lock(p, &flags);
+	WARN_ON(p->state != TASK_WAKING);
+	cpu = task_cpu(p);
 
 #ifdef CONFIG_SCHEDSTATS
 	schedstat_inc(rq, ttwu_count);
@@ -2422,6 +2420,7 @@ out_running:
 #endif
 out:
 	task_rq_unlock(rq, &flags);
+	put_cpu();
 
 	return success;
 }
