Return-Path: <linux-kernel-owner+w=401wt.eu-S932385AbZJELss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbZJELss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 07:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932336AbZJELss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 07:48:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:56795 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223AbZJELsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 07:48:46 -0400
Date: Mon, 5 Oct 2009 11:47:37 GMT
From: tip-bot for Peter Williams <pwil3058@bigpond.net.au>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, pwil3058@bigpond.net.au,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       pwil3058@bigpond.net.au, mingo@elte.hu
In-Reply-To: <f8f46736fd4e7f090ac0.1253774830@mudlark.pw.nest>
References: <f8f46736fd4e7f090ac0.1253774830@mudlark.pw.nest>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Set correct normal_prio and prio values in sched_fork()
Message-ID: <tip-f83f9ac2632732bd1678150b5a03d152f912fe72@git.kernel.org>
Git-Commit-ID: f83f9ac2632732bd1678150b5a03d152f912fe72
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 05 Oct 2009 11:47:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f83f9ac2632732bd1678150b5a03d152f912fe72
Gitweb:     http://git.kernel.org/tip/f83f9ac2632732bd1678150b5a03d152f912fe72
Author:     Peter Williams <pwil3058@bigpond.net.au>
AuthorDate: Thu, 24 Sep 2009 06:47:10 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Oct 2009 13:42:20 +0200

sched: Set correct normal_prio and prio values in sched_fork()

normal_prio should be updated if policy changes from RT to
SCHED_MORMAL or if static_prio/nice is changed.

Some paths through sched_fork() ignore this requirement and may
result in normal_prio having an invalid value.

Fixing this issue allows the call to effective_prio() in
wake_up_new_task() to be removed.

Signed-off-by: Peter Williams <pwil3058@bigpond.net.au>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <f8f46736fd4e7f090ac0.1253774830@mudlark.pw.nest>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1535f38..76c0e96 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2515,22 +2515,17 @@ void sched_fork(struct task_struct *p, int clone_flags)
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
 
@@ -2541,6 +2536,11 @@ void sched_fork(struct task_struct *p, int clone_flags)
 		p->sched_reset_on_fork = 0;
 	}
 
+	/*
+	 * Make sure we do not leak PI boosting priority to the child.
+	 */
+	p->prio = current->normal_prio;
+
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
@@ -2581,8 +2581,6 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	BUG_ON(p->state != TASK_RUNNING);
 	update_rq_clock(rq);
 
-	p->prio = effective_prio(p);
-
 	if (!p->sched_class->task_new || !current->se.on_rq) {
 		activate_task(rq, p, 0);
 	} else {
