Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbZCKLOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbZCKLOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 07:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbZCKLOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 07:14:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:51391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbZCKLOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 07:14:39 -0400
Date: Wed, 11 Mar 2009 11:14:06 GMT
From: Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236709131.25234.576.camel@laptop>
References: <1236709131.25234.576.camel@laptop>
Subject: [tip:sched/core] sched: add avg_overlap decay
Message-ID: <tip-df1c99d416500da8d26a4d78777467c53ee7689e@git.kernel.org>
Git-Commit-ID: df1c99d416500da8d26a4d78777467c53ee7689e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Mar 2009 11:14:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df1c99d416500da8d26a4d78777467c53ee7689e
Gitweb:     http://git.kernel.org/tip/df1c99d416500da8d26a4d78777467c53ee7689e
Author:     "Mike Galbraith" <efault@gmx.de>
AuthorDate: Tue, 10 Mar 2009 19:08:11 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 11 Mar 2009 11:31:50 +0100

sched: add avg_overlap decay

Impact: more precise avg_overlap metric - better load-balancing

avg_overlap is used to measure the runtime overlap of the waker and
wakee.

However, when a process changes behaviour, eg a pipe becomes
un-congested and we don't need to go to sleep after a wakeup
for a while, the avg_overlap value grows stale.

When running we use the avg runtime between preemption as a
measure for avg_overlap since the amount of runtime can be
correlated to cache footprint.

The longer we run, the less likely we'll be wanting to be
migrated to another CPU.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1236709131.25234.576.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index af5cd1b..2f28351 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4620,6 +4620,28 @@ static inline void schedule_debug(struct task_struct *prev)
 #endif
 }
 
+static void put_prev_task(struct rq *rq, struct task_struct *prev)
+{
+	if (prev->state == TASK_RUNNING) {
+		u64 runtime = prev->se.sum_exec_runtime;
+
+		runtime -= prev->se.prev_sum_exec_runtime;
+		runtime = min_t(u64, runtime, 2*sysctl_sched_migration_cost);
+
+		/*
+		 * In order to avoid avg_overlap growing stale when we are
+		 * indeed overlapping and hence not getting put to sleep, grow
+		 * the avg_overlap on preemption.
+		 *
+		 * We use the average preemption runtime because that
+		 * correlates to the amount of cache footprint a task can
+		 * build up.
+		 */
+		update_avg(&prev->se.avg_overlap, runtime);
+	}
+	prev->sched_class->put_prev_task(rq, prev);
+}
+
 /*
  * Pick up the highest-prio task:
  */
@@ -4698,7 +4720,7 @@ need_resched_nonpreemptible:
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
 
-	prev->sched_class->put_prev_task(rq, prev);
+	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
 
 	if (likely(prev != next)) {
