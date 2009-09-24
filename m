Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbZIXGrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbZIXGrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 02:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZIXGrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 02:47:10 -0400
Received: from nskntmtas01p.mx.bigpond.com ([61.9.168.137]:49563 "EHLO
	nskntmtas01p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676AbZIXGrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 02:47:10 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] sched: Set correct normal_prio and prio values in sched_fork()
X-Mercurial-Node: f8f46736fd4e7f090ac020785602b46a86a583ae
Message-Id: <f8f46736fd4e7f090ac0.1253774830@mudlark.pw.nest>
User-Agent: Mercurial-patchbomb/1.3
Date: Thu, 24 Sep 2009 06:47:10 -0000
From: Peter Williams <pwil3058@bigpond.net.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing <linux-kernel@vger.kernel.org>
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at nskntotgx02p.mx.bigpond.com from [121.222.72.47] using ID pwil3058@bigpond.net.au at Thu, 24 Sep 2009 06:47:11 +0000
X-RPD-ScanID: Class unknown; VirusThreatLevel unknown, RefID str=0001.0A150204.4ABB15EF.013E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

normal_prio should be updated if policy changes from RT to SCHED_MORMAL
or if static_prio/nice is changed.  Some paths through sched_fork()
ignore this requirement and may result in normal_prio having an invalid
value.

Fixing this issue allows the call to effective_prio() in
wake_up_new_task() to be removed.

Signed-off-by: Peter Williams <pwil3058@bigpond.net.au>

diff --git a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2515,22 +2515,17 @@ void sched_fork(struct task_struct *p, i
 	__sched_fork(p);
 
 	/*
-	 * Make sure we do not leak PI boosting priority to the child.
-	 */
-	p->prio = current->normal_prio;
-
-	/*
 	 * Revert to default priority/policy on fork if requested.
 	 */
 	if (unlikely(p->sched_reset_on_fork)) {
-		if (p->policy == SCHED_FIFO || p->policy == SCHED_RR)
+		if (p->policy == SCHED_FIFO || p->policy == SCHED_RR) {
 			p->policy = SCHED_NORMAL;
-
-		if (p->normal_prio < DEFAULT_PRIO)
-			p->prio = DEFAULT_PRIO;
+			p->normal_prio = p->static_prio;
+		}
 
 		if (PRIO_TO_NICE(p->static_prio) < 0) {
 			p->static_prio = NICE_TO_PRIO(0);
+			p->normal_prio = p->static_prio;
 			set_load_weight(p);
 		}
 
@@ -2541,6 +2536,11 @@ void sched_fork(struct task_struct *p, i
 		p->sched_reset_on_fork = 0;
 	}
 
+	/*
+	 * Make sure we do not leak PI boosting priority to the child.
+	 */
+	p->prio = current->normal_prio;
+
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
@@ -2581,8 +2581,6 @@ void wake_up_new_task(struct task_struct
 	BUG_ON(p->state != TASK_RUNNING);
 	update_rq_clock(rq);
 
-	p->prio = effective_prio(p);
-
 	if (!p->sched_class->task_new || !current->se.on_rq) {
 		activate_task(rq, p, 0);
 	} else {
