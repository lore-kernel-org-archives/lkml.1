Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbZKVMID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbZKVMID (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:08:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbZKVMIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:08:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:40860 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754338AbZKVMH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:07:59 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+pQ4NKHkypQ8LjuZxSorBQ2JNM+PQhbrBcPy94aw
	AD0SB7X4Ghunrk
Subject: [patch] sched: improve tick time missed wakeup preempt protection
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Nov 2009 13:08:02 +0100
Message-Id: <1258891682.14325.31.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: improve tick time missed wakeup preempt protection

f685ceac provides protection from tasks just missing wakeup preemption, and then
having to wait a full slice.  However, it offers this protection to tasks which
have no business receiving the benefit, namely SCHED_BATCH and SCHED_IDLE.  It
also treats all tasks equally, which obviously isn't true.  Exclude tasks of
other than SCHED_NORMAL class, and scale minimum runtime before a tick time
preemption by the difference in task weights, after which, we can just use the
standard wakeup preempt vruntime delta test, sysctl_sched_wakeup_granularity.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched_fair.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -830,17 +830,23 @@ check_preempt_tick(struct cfs_rq *cfs_rq
 	 * narrow margin doesn't have to wait for a full slice.
 	 * This also mitigates buddy induced latencies under load.
 	 */
-	if (!sched_feat(WAKEUP_PREEMPT))
+	if (!sched_feat(WAKEUP_PREEMPT) || cfs_rq->nr_running < 2)
 		return;
-
-	if (delta_exec < sysctl_sched_min_granularity)
-		return;
-
-	if (cfs_rq->nr_running > 1) {
+	else  {
 		struct sched_entity *se = __pick_next_entity(cfs_rq);
+		unsigned long min = sysctl_sched_min_granularity;
 		s64 delta = curr->vruntime - se->vruntime;
 
-		if (delta > ideal_runtime)
+		if (task_of(se)->policy != SCHED_NORMAL)
+			return;
+		if (delta < 0)
+			return;
+		if (curr->load.weight != se->load.weight)
+			min = calc_delta_mine(min, curr->load.weight, &se->load);
+		if (delta_exec < min)
+			return;
+
+		if (delta > sysctl_sched_wakeup_granularity)
 			resched_task(rq_of(cfs_rq)->curr);
 	}
 }


