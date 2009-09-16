Return-Path: <linux-kernel-owner+w=401wt.eu-S1757615AbZIPKUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbZIPKUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757539AbZIPKUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:20:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:46377 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616AbZIPKUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:20:47 -0400
Date: Wed, 16 Sep 2009 10:20:24 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Hook sched_balance_self() into sched_class::select_task_rq()
Message-ID: <tip-5f3edc1b1ead6d9bd45a85c551f44eff8fe76b9f@git.kernel.org>
Git-Commit-ID: 5f3edc1b1ead6d9bd45a85c551f44eff8fe76b9f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:20:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f3edc1b1ead6d9bd45a85c551f44eff8fe76b9f
Gitweb:     http://git.kernel.org/tip/5f3edc1b1ead6d9bd45a85c551f44eff8fe76b9f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 10 Sep 2009 13:42:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:01:04 +0200

sched: Hook sched_balance_self() into sched_class::select_task_rq()

Rather ugly patch to fully place the sched_balance_self() code
inside the fair class.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h   |    3 ++-
 kernel/sched.c          |   14 +++++++-------
 kernel/sched_fair.c     |    7 ++++++-
 kernel/sched_idletask.c |    2 +-
 kernel/sched_rt.c       |    5 ++++-
 5 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f3d74bd..5d3c990 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -811,6 +811,7 @@ enum cpu_idle_type {
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
 #define SD_WAKE_IDLE_FAR	0x0800	/* Gain latency sacrificing cache hit */
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
+#define SD_BALANCE_WAKE		0x2000  /* Balance on wakeup */
 
 enum powersavings_balance_level {
 	POWERSAVINGS_BALANCE_NONE = 0,  /* No power saving load balance */
@@ -1032,7 +1033,7 @@ struct sched_class {
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
-	int  (*select_task_rq)(struct task_struct *p, int sync);
+	int  (*select_task_rq)(struct task_struct *p, int flag, int sync);
 
 	unsigned long (*load_balance) (struct rq *this_rq, int this_cpu,
 			struct rq *busiest, unsigned long max_load_move,
diff --git a/kernel/sched.c b/kernel/sched.c
index 60400a2..32b7a81 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2350,7 +2350,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 	if (unlikely(task_running(rq, p)))
 		goto out_activate;
 
-	cpu = p->sched_class->select_task_rq(p, sync);
+	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, sync);
 	if (cpu != orig_cpu) {
 		set_task_cpu(p, cpu);
 		task_rq_unlock(rq, &flags);
@@ -2525,11 +2525,6 @@ void sched_fork(struct task_struct *p, int clone_flags)
 
 	__sched_fork(p);
 
-#ifdef CONFIG_SMP
-	cpu = sched_balance_self(cpu, SD_BALANCE_FORK);
-#endif
-	set_task_cpu(p, cpu);
-
 	/*
 	 * Make sure we do not leak PI boosting priority to the child.
 	 */
@@ -2560,6 +2555,11 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
+#ifdef CONFIG_SMP
+	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
+#endif
+	set_task_cpu(p, cpu);
+
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
@@ -3114,7 +3114,7 @@ out:
 void sched_exec(void)
 {
 	int new_cpu, this_cpu = get_cpu();
-	new_cpu = sched_balance_self(this_cpu, SD_BALANCE_EXEC);
+	new_cpu = current->sched_class->select_task_rq(current, SD_BALANCE_EXEC, 0);
 	put_cpu();
 	if (new_cpu != this_cpu)
 		sched_migrate_task(current, new_cpu);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a82d71d..f2eb5b9 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1300,7 +1300,9 @@ wake_affine(struct sched_domain *this_sd, struct rq *this_rq,
 	return 0;
 }
 
-static int select_task_rq_fair(struct task_struct *p, int sync)
+static int sched_balance_self(int cpu, int flag);
+
+static int select_task_rq_fair(struct task_struct *p, int flag, int sync)
 {
 	struct sched_domain *sd, *this_sd = NULL;
 	int prev_cpu, this_cpu, new_cpu;
@@ -1314,6 +1316,9 @@ static int select_task_rq_fair(struct task_struct *p, int sync)
 	this_rq		= cpu_rq(this_cpu);
 	new_cpu		= prev_cpu;
 
+	if (flag != SD_BALANCE_WAKE)
+		return sched_balance_self(this_cpu, flag);
+
 	/*
 	 * 'this_sd' is the first domain that both
 	 * this_cpu and prev_cpu are present in:
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 499672c..99b2f03 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -6,7 +6,7 @@
  */
 
 #ifdef CONFIG_SMP
-static int select_task_rq_idle(struct task_struct *p, int sync)
+static int select_task_rq_idle(struct task_struct *p, int flag, int sync)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 2eb4bd6..4383808 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -938,10 +938,13 @@ static void yield_task_rt(struct rq *rq)
 #ifdef CONFIG_SMP
 static int find_lowest_rq(struct task_struct *task);
 
-static int select_task_rq_rt(struct task_struct *p, int sync)
+static int select_task_rq_rt(struct task_struct *p, int flag, int sync)
 {
 	struct rq *rq = task_rq(p);
 
+	if (flag != SD_BALANCE_WAKE)
+		return smp_processor_id();
+
 	/*
 	 * If the current task is an RT task, then
 	 * try to see if we can wake this RT task up on another
