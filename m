Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbZJHTCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbZJHTCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 15:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbZJHTCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 15:02:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38607 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbZJHTCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 15:02:15 -0400
Date: Thu, 8 Oct 2009 21:01:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] scheduler fix
Message-ID: <20091008190128.GA28607@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0046]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Peter Williams (1):
      sched: Set correct normal_prio and prio values in sched_fork()


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
