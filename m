Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbYKLUa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbYKLUa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbYKLUaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:30:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40365 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbYKLUaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:30:17 -0500
Date: Wed, 12 Nov 2008 21:30:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20081112203002.GA9468@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Balbir Singh (1):
      sched: fix stale value in average load per task

Ingo Molnar (1):
      sched: fix init_idle()'s use of sched_clock()


 kernel/sched.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 50a21f9..c94baf2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1456,6 +1456,8 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 
 	if (rq->nr_running)
 		rq->avg_load_per_task = rq->load.weight / rq->nr_running;
+	else
+		rq->avg_load_per_task = 0;
 
 	return rq->avg_load_per_task;
 }
@@ -5868,6 +5870,8 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
 
+	spin_lock_irqsave(&rq->lock, flags);
+
 	__sched_fork(idle);
 	idle->se.exec_start = sched_clock();
 
@@ -5875,7 +5879,6 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	idle->cpus_allowed = cpumask_of_cpu(cpu);
 	__set_task_cpu(idle, cpu);
 
-	spin_lock_irqsave(&rq->lock, flags);
 	rq->curr = rq->idle = idle;
 #if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
 	idle->oncpu = 1;

