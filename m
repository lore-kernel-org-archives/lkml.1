Return-Path: <linux-kernel-owner+w=401wt.eu-S1761635AbZLJTh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761635AbZLJTh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761623AbZLJThY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:37:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:59295 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761620AbZLJThV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:37:21 -0500
Date: Thu, 10 Dec 2009 19:36:32 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Remove forced2_migrations stats
Message-ID: <tip-b9889ed1ddeca5a3f3569c8de7354e9e97d803ae@git.kernel.org>
Git-Commit-ID: b9889ed1ddeca5a3f3569c8de7354e9e97d803ae
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9889ed1ddeca5a3f3569c8de7354e9e97d803ae
Gitweb:     http://git.kernel.org/tip/b9889ed1ddeca5a3f3569c8de7354e9e97d803ae
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 10 Dec 2009 20:32:39 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Dec 2009 20:32:39 +0100

sched: Remove forced2_migrations stats

This build warning:

 kernel/sched.c: In function 'set_task_cpu':
 kernel/sched.c:2070: warning: unused variable 'old_rq'

Made me realize that the forced2_migrations stat looks pretty
pointless (and a misnomer) - remove it.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    1 -
 kernel/sched.c        |    6 ------
 kernel/sched_debug.c  |    2 --
 3 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ee9f200..87b89a8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1174,7 +1174,6 @@ struct sched_entity {
 	u64			nr_failed_migrations_running;
 	u64			nr_failed_migrations_hot;
 	u64			nr_forced_migrations;
-	u64			nr_forced2_migrations;
 
 	u64			nr_wakeups;
 	u64			nr_wakeups_sync;
diff --git a/kernel/sched.c b/kernel/sched.c
index 36cc05a..bc68037 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2067,7 +2067,6 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
 	int old_cpu = task_cpu(p);
-	struct rq *old_rq = cpu_rq(old_cpu);
 	struct cfs_rq *old_cfsrq = task_cfs_rq(p),
 		      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
 
@@ -2075,10 +2074,6 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 
 	if (old_cpu != new_cpu) {
 		p->se.nr_migrations++;
-#ifdef CONFIG_SCHEDSTATS
-		if (task_hot(p, old_rq->clock, NULL))
-			schedstat_inc(p, se.nr_forced2_migrations);
-#endif
 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS,
 				     1, 1, NULL, 0);
 	}
@@ -2521,7 +2516,6 @@ static void __sched_fork(struct task_struct *p)
 	p->se.nr_failed_migrations_running	= 0;
 	p->se.nr_failed_migrations_hot		= 0;
 	p->se.nr_forced_migrations		= 0;
-	p->se.nr_forced2_migrations		= 0;
 
 	p->se.nr_wakeups			= 0;
 	p->se.nr_wakeups_sync			= 0;
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 0fc5287..5ae24fc 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -432,7 +432,6 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	P(se.nr_failed_migrations_running);
 	P(se.nr_failed_migrations_hot);
 	P(se.nr_forced_migrations);
-	P(se.nr_forced2_migrations);
 	P(se.nr_wakeups);
 	P(se.nr_wakeups_sync);
 	P(se.nr_wakeups_migrate);
@@ -508,7 +507,6 @@ void proc_sched_set_task(struct task_struct *p)
 	p->se.nr_failed_migrations_running	= 0;
 	p->se.nr_failed_migrations_hot		= 0;
 	p->se.nr_forced_migrations		= 0;
-	p->se.nr_forced2_migrations		= 0;
 	p->se.nr_wakeups			= 0;
 	p->se.nr_wakeups_sync			= 0;
 	p->se.nr_wakeups_migrate		= 0;
