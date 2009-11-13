Return-Path: <linux-kernel-owner+w=401wt.eu-S932099AbZKMJbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbZKMJbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755007AbZKMJbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:31:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:33496 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbZKMJa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:30:58 -0500
Date: Fri, 13 Nov 2009 09:30:35 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091112145610.832503781@chello.nl>
References: <20091112145610.832503781@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Cleanup select_task_rq_fair()
Message-ID: <tip-a50bde5130f65733142b32975616427d0ea50856@git.kernel.org>
Git-Commit-ID: a50bde5130f65733142b32975616427d0ea50856
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a50bde5130f65733142b32975616427d0ea50856
Gitweb:     http://git.kernel.org/tip/a50bde5130f65733142b32975616427d0ea50856
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 12 Nov 2009 15:55:28 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Nov 2009 10:09:58 +0100

sched: Cleanup select_task_rq_fair()

Clean up the new affine to idle sibling bits while trying to
grok them. Should not have any function differences.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091112145610.832503781@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   73 +++++++++++++++++++++++++++++++++++---------------
 1 files changed, 51 insertions(+), 22 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e4d4483..a32df15 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1319,6 +1319,41 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 }
 
 /*
+ * Try and locate an idle CPU in the sched_domain.
+ */
+static int
+select_idle_sibling(struct task_struct *p, struct sched_domain *sd, int target)
+{
+	int cpu = smp_processor_id();
+	int prev_cpu = task_cpu(p);
+	int i;
+
+	/*
+	 * If this domain spans both cpu and prev_cpu (see the SD_WAKE_AFFINE
+	 * test in select_task_rq_fair) and the prev_cpu is idle then that's
+	 * always a better target than the current cpu.
+	 */
+	if (target == cpu) {
+		if (!cpu_rq(prev_cpu)->cfs.nr_running)
+			target = prev_cpu;
+	}
+
+	/*
+	 * Otherwise, iterate the domain and find an elegible idle cpu.
+	 */
+	if (target == -1 || target == cpu) {
+		for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
+			if (!cpu_rq(i)->cfs.nr_running) {
+				target = i;
+				break;
+			}
+		}
+	}
+
+	return target;
+}
+
+/*
  * sched_balance_self: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
  * SD_BALANCE_EXEC.
@@ -1373,36 +1408,30 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 		}
 
 		if (want_affine && (tmp->flags & SD_WAKE_AFFINE)) {
-			int candidate = -1, i;
+			int target = -1;
 
+			/*
+			 * If both cpu and prev_cpu are part of this domain,
+			 * cpu is a valid SD_WAKE_AFFINE target.
+			 */
 			if (cpumask_test_cpu(prev_cpu, sched_domain_span(tmp)))
-				candidate = cpu;
+				target = cpu;
 
 			/*
-			 * Check for an idle shared cache.
+			 * If there's an idle sibling in this domain, make that
+			 * the wake_affine target instead of the current cpu.
+			 *
+			 * XXX: should we possibly do this outside of
+			 * WAKE_AFFINE, in case the shared cache domain is
+			 * smaller than the WAKE_AFFINE domain?
 			 */
-			if (tmp->flags & SD_PREFER_SIBLING) {
-				if (candidate == cpu) {
-					if (!cpu_rq(prev_cpu)->cfs.nr_running)
-						candidate = prev_cpu;
-				}
-
-				if (candidate == -1 || candidate == cpu) {
-					for_each_cpu(i, sched_domain_span(tmp)) {
-						if (!cpumask_test_cpu(i, &p->cpus_allowed))
-							continue;
-						if (!cpu_rq(i)->cfs.nr_running) {
-							candidate = i;
-							break;
-						}
-					}
-				}
-			}
+			if (tmp->flags & SD_PREFER_SIBLING)
+				target = select_idle_sibling(p, tmp, target);
 
-			if (candidate >= 0) {
+			if (target >= 0) {
 				affine_sd = tmp;
 				want_affine = 0;
-				cpu = candidate;
+				cpu = target;
 			}
 		}
 
