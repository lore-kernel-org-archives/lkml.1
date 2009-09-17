Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbZIQIzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbZIQIzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 04:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbZIQIzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 04:55:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:39711 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531AbZIQIzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 04:55:19 -0400
Date: Thu, 17 Sep 2009 08:54:49 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix SD_POWERSAVING_BALANCE|SD_PREFER_LOCAL vs SD_WAKE_AFFINE
Message-ID: <tip-29cd8bae396583a2ee9a3340db8c5102acf9f6fd@git.kernel.org>
Git-Commit-ID: 29cd8bae396583a2ee9a3340db8c5102acf9f6fd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 08:54:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29cd8bae396583a2ee9a3340db8c5102acf9f6fd
Gitweb:     http://git.kernel.org/tip/29cd8bae396583a2ee9a3340db8c5102acf9f6fd
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 17 Sep 2009 09:01:14 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Sep 2009 10:40:31 +0200

sched: Fix SD_POWERSAVING_BALANCE|SD_PREFER_LOCAL vs SD_WAKE_AFFINE

The SD_POWERSAVING_BALANCE|SD_PREFER_LOCAL code can break out of
the domain iteration early, making us miss the SD_WAKE_AFFINE bits.

Fix this by continuing iteration until there is no need for a
larger domain.

This also cleans up the cgroup stuff a bit, but not having two
update_shares() invocations.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c |   42 +++++++++++++++++++++++++++---------------
 1 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ffee827..10d218a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1333,11 +1333,12 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
  */
 static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 {
-	struct sched_domain *tmp, *shares = NULL, *sd = NULL;
+	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
 	int want_affine = 0;
+	int want_sd = 1;
 	int sync = wake_flags & WF_SYNC;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
@@ -1369,33 +1370,44 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 				nr_running /= 2;
 
 			if (nr_running < capacity)
-				break;
+				want_sd = 0;
 		}
 
 		if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
 		    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
 
-			if (sched_feat(LB_SHARES_UPDATE)) {
-				update_shares(tmp);
-				shares = tmp;
-			}
-
-			if (wake_affine(tmp, p, sync)) {
-				new_cpu = cpu;
-				goto out;
-			}
-
+			affine_sd = tmp;
 			want_affine = 0;
 		}
 
+		if (!want_sd && !want_affine)
+			break;
+
 		if (!(tmp->flags & sd_flag))
 			continue;
 
-		sd = tmp;
+		if (want_sd)
+			sd = tmp;
+	}
+
+	if (sched_feat(LB_SHARES_UPDATE)) {
+		/*
+		 * Pick the largest domain to update shares over
+		 */
+		tmp = sd;
+		if (affine_sd && (!tmp ||
+				  cpumask_weight(sched_domain_span(affine_sd)) >
+				  cpumask_weight(sched_domain_span(sd))))
+			tmp = affine_sd;
+
+		if (tmp)
+			update_shares(tmp);
 	}
 
-	if (sd && sd != shares && sched_feat(LB_SHARES_UPDATE))
-		update_shares(sd);
+	if (affine_sd && wake_affine(affine_sd, p, sync)) {
+		new_cpu = cpu;
+		goto out;
+	}
 
 	while (sd) {
 		int load_idx = sd->forkexec_idx;
