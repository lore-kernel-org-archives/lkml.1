Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab0CKSco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:32:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:40883 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379Ab0CKScg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:32:36 -0500
Date: Thu, 11 Mar 2010 18:32:01 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1268301369.6785.36.camel@marge.simson.net>
References: <1268301369.6785.36.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix select_idle_sibling()
Message-ID: <tip-8b911acdf08477c059d1c36c21113ab1696c612b@git.kernel.org>
Git-Commit-ID: 8b911acdf08477c059d1c36c21113ab1696c612b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 18:32:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b911acdf08477c059d1c36c21113ab1696c612b
Gitweb:     http://git.kernel.org/tip/8b911acdf08477c059d1c36c21113ab1696c612b
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 11 Mar 2010 17:17:16 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 18:32:51 +0100

sched: Fix select_idle_sibling()

Don't bother with selection when the current cpu is idle.  Recent load
balancing changes also make it no longer necessary to check wake_affine()
success before returning the selected sibling, so we now always use it.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268301369.6785.36.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index d19df5b..0008cc4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1439,7 +1439,7 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
-	int want_affine = 0;
+	int want_affine = 0, cpu_idle = !current->pid;
 	int want_sd = 1;
 	int sync = wake_flags & WF_SYNC;
 
@@ -1497,13 +1497,15 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 			 * If there's an idle sibling in this domain, make that
 			 * the wake_affine target instead of the current cpu.
 			 */
-			if (tmp->flags & SD_SHARE_PKG_RESOURCES)
+			if (!cpu_idle && tmp->flags & SD_SHARE_PKG_RESOURCES)
 				target = select_idle_sibling(p, tmp, target);
 
 			if (target >= 0) {
 				if (tmp->flags & SD_WAKE_AFFINE) {
 					affine_sd = tmp;
 					want_affine = 0;
+					if (target != cpu)
+						cpu_idle = 1;
 				}
 				cpu = target;
 			}
@@ -1519,6 +1521,7 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 			sd = tmp;
 	}
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	if (sched_feat(LB_SHARES_UPDATE)) {
 		/*
 		 * Pick the largest domain to update shares over
@@ -1532,9 +1535,12 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 		if (tmp)
 			update_shares(tmp);
 	}
+#endif
 
-	if (affine_sd && wake_affine(affine_sd, p, sync))
-		return cpu;
+	if (affine_sd) {
+		if (cpu_idle || cpu == prev_cpu || wake_affine(affine_sd, p, sync))
+			return cpu;
+	}
 
 	while (sd) {
 		int load_idx = sd->forkexec_idx;
