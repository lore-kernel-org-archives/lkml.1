Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab0CKJ4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:56:20 -0500
Received: from mail.gmx.net ([213.165.64.20]:47515 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755285Ab0CKJ4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:56:18 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/50gF4H6v5KrPlVbQk5nIBOxjgXPT+nQX5TUGfyb
	8ukjqhyx/TzNRE
Subject: Re: [patch 6/12] sched: fix select_idle_sibling()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1268300950.6785.27.camel@marge.simson.net>
References: <1268300950.6785.27.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 11 Mar 2010 10:56:09 +0100
Message-Id: <1268301369.6785.36.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: fix select_idle_sibling()

Don't bother with selection when the current cpu is idle.  Recent load
balancing changes also make it no longer necessary to check wake_affine()
success before returning the selected sibling, so we now always use it.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched_fair.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1438,7 +1438,7 @@ static int select_task_rq_fair(struct ta
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
-	int want_affine = 0;
+	int want_affine = 0, cpu_idle = !current->pid;
 	int want_sd = 1;
 	int sync = wake_flags & WF_SYNC;
 
@@ -1496,13 +1496,15 @@ static int select_task_rq_fair(struct ta
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
@@ -1518,6 +1520,7 @@ static int select_task_rq_fair(struct ta
 			sd = tmp;
 	}
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	if (sched_feat(LB_SHARES_UPDATE)) {
 		/*
 		 * Pick the largest domain to update shares over
@@ -1531,9 +1534,12 @@ static int select_task_rq_fair(struct ta
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


