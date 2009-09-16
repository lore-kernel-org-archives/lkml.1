Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbZIPKYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbZIPKYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758668AbZIPKYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:24:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:46633 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705AbZIPKYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:24:17 -0400
Date: Wed, 16 Sep 2009 10:23:49 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Rename select_task_rq() argument
Message-ID: <tip-0763a660a84220cc3900fd32abdd7ad109e2278d@git.kernel.org>
Git-Commit-ID: 0763a660a84220cc3900fd32abdd7ad109e2278d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:23:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0763a660a84220cc3900fd32abdd7ad109e2278d
Gitweb:     http://git.kernel.org/tip/0763a660a84220cc3900fd32abdd7ad109e2278d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 14 Sep 2009 19:37:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:51:29 +0200

sched: Rename select_task_rq() argument

In order to be able to rename the sync argument, we need to rename
the current flag argument.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h   |    2 +-
 kernel/sched_fair.c     |   14 +++++++-------
 kernel/sched_idletask.c |    2 +-
 kernel/sched_rt.c       |    4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index fc4c0f9..5c116f0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1037,7 +1037,7 @@ struct sched_class {
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
-	int  (*select_task_rq)(struct task_struct *p, int flag, int sync);
+	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int sync);
 
 	unsigned long (*load_balance) (struct rq *this_rq, int this_cpu,
 			struct rq *busiest, unsigned long max_load_move,
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 1959356..b554e63 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1331,7 +1331,7 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
  *
  * preempt must be disabled.
  */
-static int select_task_rq_fair(struct task_struct *p, int flag, int sync)
+static int select_task_rq_fair(struct task_struct *p, int sd_flag, int sync)
 {
 	struct sched_domain *tmp, *sd = NULL;
 	int cpu = smp_processor_id();
@@ -1339,7 +1339,7 @@ static int select_task_rq_fair(struct task_struct *p, int flag, int sync)
 	int new_cpu = cpu;
 	int want_affine = 0;
 
-	if (flag & SD_BALANCE_WAKE) {
+	if (sd_flag & SD_BALANCE_WAKE) {
 		if (sched_feat(AFFINE_WAKEUPS))
 			want_affine = 1;
 		new_cpu = prev_cpu;
@@ -1368,7 +1368,7 @@ static int select_task_rq_fair(struct task_struct *p, int flag, int sync)
 				break;
 		}
 
-		switch (flag) {
+		switch (sd_flag) {
 		case SD_BALANCE_WAKE:
 			if (!sched_feat(LB_WAKEUP_UPDATE))
 				break;
@@ -1392,7 +1392,7 @@ static int select_task_rq_fair(struct task_struct *p, int flag, int sync)
 			want_affine = 0;
 		}
 
-		if (!(tmp->flags & flag))
+		if (!(tmp->flags & sd_flag))
 			continue;
 
 		sd = tmp;
@@ -1402,12 +1402,12 @@ static int select_task_rq_fair(struct task_struct *p, int flag, int sync)
 		struct sched_group *group;
 		int weight;
 
-		if (!(sd->flags & flag)) {
+		if (!(sd->flags & sd_flag)) {
 			sd = sd->child;
 			continue;
 		}
 
-		group = find_idlest_group(sd, p, cpu, flag);
+		group = find_idlest_group(sd, p, cpu, sd_flag);
 		if (!group) {
 			sd = sd->child;
 			continue;
@@ -1427,7 +1427,7 @@ static int select_task_rq_fair(struct task_struct *p, int flag, int sync)
 		for_each_domain(cpu, tmp) {
 			if (weight <= cpumask_weight(sched_domain_span(tmp)))
 				break;
-			if (tmp->flags & flag)
+			if (tmp->flags & sd_flag)
 				sd = tmp;
 		}
 		/* while loop will break here if sd == NULL */
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 99b2f03..9ff7697 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -6,7 +6,7 @@
  */
 
 #ifdef CONFIG_SMP
-static int select_task_rq_idle(struct task_struct *p, int flag, int sync)
+static int select_task_rq_idle(struct task_struct *p, int sd_flag, int sync)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 4383808..97c53f3 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -938,11 +938,11 @@ static void yield_task_rt(struct rq *rq)
 #ifdef CONFIG_SMP
 static int find_lowest_rq(struct task_struct *task);
 
-static int select_task_rq_rt(struct task_struct *p, int flag, int sync)
+static int select_task_rq_rt(struct task_struct *p, int sd_flag, int sync)
 {
 	struct rq *rq = task_rq(p);
 
-	if (flag != SD_BALANCE_WAKE)
+	if (sd_flag != SD_BALANCE_WAKE)
 		return smp_processor_id();
 
 	/*
