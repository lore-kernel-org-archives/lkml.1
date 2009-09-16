Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbZIPPKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbZIPPKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758969AbZIPPKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:10:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:38997 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757706AbZIPPKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:10:19 -0400
Date: Wed, 16 Sep 2009 15:09:40 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Optimize cgroup vs wakeup a bit
Message-ID: <tip-3b6408942206f940dd538e980e9904e48f4b64f8@git.kernel.org>
Git-Commit-ID: 3b6408942206f940dd538e980e9904e48f4b64f8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 15:09:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b6408942206f940dd538e980e9904e48f4b64f8
Gitweb:     http://git.kernel.org/tip/3b6408942206f940dd538e980e9904e48f4b64f8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Sep 2009 13:44:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Sep 2009 16:44:32 +0200

sched: Optimize cgroup vs wakeup a bit

We don't need to call update_shares() for each domain we iterate,
just got the largets one.

However, we should call it before wake_affine() as well, so that
that can use up-to-date values too.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c          |    7 -------
 kernel/sched_fair.c     |   23 +++++++++--------------
 kernel/sched_features.h |    2 +-
 3 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index af04ede..5049d95 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -376,13 +376,6 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 
 #else
 
-#ifdef CONFIG_SMP
-static int root_task_group_empty(void)
-{
-	return 1;
-}
-#endif
-
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
 static inline struct task_group *task_group(struct task_struct *p)
 {
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index acf16a8..722d392 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1348,7 +1348,7 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
  */
 static int select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
 {
-	struct sched_domain *tmp, *sd = NULL;
+	struct sched_domain *tmp, *shares = NULL, *sd = NULL;
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
@@ -1387,22 +1387,14 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
 				break;
 		}
 
-		switch (sd_flag) {
-		case SD_BALANCE_WAKE:
-			if (!sched_feat(LB_WAKEUP_UPDATE))
-				break;
-		case SD_BALANCE_FORK:
-		case SD_BALANCE_EXEC:
-			if (root_task_group_empty())
-				break;
-			update_shares(tmp);
-		default:
-			break;
-		}
-
 		if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
 		    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
 
+			if (sched_feat(LB_SHARES_UPDATE)) {
+				update_shares(tmp);
+				shares = tmp;
+			}
+
 			if (wake_affine(tmp, p, sync)) {
 				new_cpu = cpu;
 				goto out;
@@ -1417,6 +1409,9 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
 		sd = tmp;
 	}
 
+	if (sd && sd != shares && sched_feat(LB_SHARES_UPDATE))
+		update_shares(sd);
+
 	while (sd) {
 		struct sched_group *group;
 		int weight;
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index fd37567..d5059fd 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -107,7 +107,7 @@ SCHED_FEAT(ARCH_POWER, 0)
 SCHED_FEAT(HRTICK, 0)
 SCHED_FEAT(DOUBLE_TICK, 0)
 SCHED_FEAT(LB_BIAS, 1)
-SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
+SCHED_FEAT(LB_SHARES_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
 
 /*
