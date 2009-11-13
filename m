Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbZKMJdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbZKMJdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbZKMJdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:33:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:53368 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007AbZKMJdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:33:13 -0500
Date: Fri, 13 Nov 2009 09:30:51 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091112145610.909723612@chello.nl>
References: <20091112145610.909723612@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: More generic WAKE_AFFINE vs select_idle_sibling()
Message-ID: <tip-fe3bcfe1f6c1fc4ea7706ac2d05e579fd9092682@git.kernel.org>
Git-Commit-ID: fe3bcfe1f6c1fc4ea7706ac2d05e579fd9092682
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe3bcfe1f6c1fc4ea7706ac2d05e579fd9092682
Gitweb:     http://git.kernel.org/tip/fe3bcfe1f6c1fc4ea7706ac2d05e579fd9092682
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 12 Nov 2009 15:55:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Nov 2009 10:09:59 +0100

sched: More generic WAKE_AFFINE vs select_idle_sibling()

Instead of only considering SD_WAKE_AFFINE | SD_PREFER_SIBLING
domains also allow all SD_PREFER_SIBLING domains below a
SD_WAKE_AFFINE domain to change the affinity target.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091112145610.909723612@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   33 ++++++++++++++++-----------------
 1 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a32df15..f28a267 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1333,20 +1333,16 @@ select_idle_sibling(struct task_struct *p, struct sched_domain *sd, int target)
 	 * test in select_task_rq_fair) and the prev_cpu is idle then that's
 	 * always a better target than the current cpu.
 	 */
-	if (target == cpu) {
-		if (!cpu_rq(prev_cpu)->cfs.nr_running)
-			target = prev_cpu;
-	}
+	if (target == cpu && !cpu_rq(prev_cpu)->cfs.nr_running)
+		return prev_cpu;
 
 	/*
 	 * Otherwise, iterate the domain and find an elegible idle cpu.
 	 */
-	if (target == -1 || target == cpu) {
-		for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
-			if (!cpu_rq(i)->cfs.nr_running) {
-				target = i;
-				break;
-			}
+	for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
+		if (!cpu_rq(i)->cfs.nr_running) {
+			target = i;
+			break;
 		}
 	}
 
@@ -1407,7 +1403,12 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 				want_sd = 0;
 		}
 
-		if (want_affine && (tmp->flags & SD_WAKE_AFFINE)) {
+		/*
+		 * While iterating the domains looking for a spanning
+		 * WAKE_AFFINE domain, adjust the affine target to any idle cpu
+		 * in cache sharing domains along the way.
+		 */
+		if (want_affine) {
 			int target = -1;
 
 			/*
@@ -1420,17 +1421,15 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 			/*
 			 * If there's an idle sibling in this domain, make that
 			 * the wake_affine target instead of the current cpu.
-			 *
-			 * XXX: should we possibly do this outside of
-			 * WAKE_AFFINE, in case the shared cache domain is
-			 * smaller than the WAKE_AFFINE domain?
 			 */
 			if (tmp->flags & SD_PREFER_SIBLING)
 				target = select_idle_sibling(p, tmp, target);
 
 			if (target >= 0) {
-				affine_sd = tmp;
-				want_affine = 0;
+				if (tmp->flags & SD_WAKE_AFFINE) {
+					affine_sd = tmp;
+					want_affine = 0;
+				}
 				cpu = target;
 			}
 		}
