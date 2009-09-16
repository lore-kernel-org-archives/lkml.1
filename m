Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbZIPPK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbZIPPK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759223AbZIPPKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:10:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:39002 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759124AbZIPPKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:10:21 -0400
Date: Wed, 16 Sep 2009 15:09:54 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Clean up the load_idx selection in select_task_rq_fair
Message-ID: <tip-5158f4e4428c6b8d52796b3b460e95796123a114@git.kernel.org>
Git-Commit-ID: 5158f4e4428c6b8d52796b3b460e95796123a114
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 15:09:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5158f4e4428c6b8d52796b3b460e95796123a114
Gitweb:     http://git.kernel.org/tip/5158f4e4428c6b8d52796b3b460e95796123a114
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Sep 2009 13:46:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Sep 2009 16:44:32 +0200

sched: Clean up the load_idx selection in select_task_rq_fair

Clean up the code a little.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c |   27 ++++++++-------------------
 1 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 722d392..aeff40e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1248,26 +1248,11 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
  */
 static struct sched_group *
 find_idlest_group(struct sched_domain *sd, struct task_struct *p,
-		  int this_cpu, int flag)
+		  int this_cpu, int load_idx)
 {
 	struct sched_group *idlest = NULL, *this = NULL, *group = sd->groups;
 	unsigned long min_load = ULONG_MAX, this_load = 0;
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
-	int load_idx = 0;
-
-	switch (flag) {
-	case SD_BALANCE_FORK:
-	case SD_BALANCE_EXEC:
-		load_idx = sd->forkexec_idx;
-		break;
-
-	case SD_BALANCE_WAKE:
-		load_idx = sd->wake_idx;
-		break;
-
-	default:
-		break;
-	}
 
 	do {
 		unsigned long load, avg_load;
@@ -1346,14 +1331,14 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
  *
  * preempt must be disabled.
  */
-static int select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
+static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 {
 	struct sched_domain *tmp, *shares = NULL, *sd = NULL;
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
 	int want_affine = 0;
-	int sync = flags & WF_SYNC;
+	int sync = wake_flags & WF_SYNC;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
 		if (sched_feat(AFFINE_WAKEUPS))
@@ -1413,6 +1398,7 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
 		update_shares(sd);
 
 	while (sd) {
+		int load_idx = sd->forkexec_idx;
 		struct sched_group *group;
 		int weight;
 
@@ -1421,7 +1407,10 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
 			continue;
 		}
 
-		group = find_idlest_group(sd, p, cpu, sd_flag);
+		if (sd_flag & SD_BALANCE_WAKE)
+			load_idx = sd->wake_idx;
+
+		group = find_idlest_group(sd, p, cpu, load_idx);
 		if (!group) {
 			sd = sd->child;
 			continue;
