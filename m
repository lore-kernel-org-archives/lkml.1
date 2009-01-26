Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbZAZW4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbZAZW4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 17:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZAZW4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 17:56:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56464 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbZAZW4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 17:56:05 -0500
Date: Mon, 26 Jan 2009 23:55:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pawel Dziekonski <dzieko@gmail.com>, Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: CPU scheduler question/problem
Message-ID: <20090126225545.GA1330@elte.hu>
References: <2cd4df870901221334n7e242e79ka961f899c03c70cb@mail.gmail.com> <1232725219.4826.131.camel@laptop> <2cd4df870901260548s2376a01anae0db9707dcfa14@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cd4df870901260548s2376a01anae0db9707dcfa14@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pawel Dziekonski <dzieko@gmail.com> wrote:

> 2009/1/23 Peter Zijlstra <peterz@infradead.org>:
> 
> > The pipe workload you mentioned has would behave that way because pipes
> > 'assume' a produces/consumer behaviour, and thus are more likely to
> > place both tasks on the same cpu -- but will eventually pull them apart
> > if they want to run concurrently.
> >
> > You might enable SCHED_DEBUG=y and try
> >  echo NO_SYNC_WAKEUPS > /debug/sched_features
> 
> Hello,
> 
> that did the trick. Openssl now gets a whole core exclusively and gives 
> full performance.
> 
> Regarding quantum chemistry application -- it is also using pipes for 
> communication between worker processes. Now this app works OK.

Could you please try the fuller fix below too please, does it still do the 
trick and does the scheduler still maximize openssl and your quantum 
chemistry app's throughput?

There should be no need for you to tune anything - the scheduler must get 
such workloads right out of the box.

	Ingo

--------------------------->
>From 08a1c2658637045d207b6fa0c328055e589a4009 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 26 Jan 2009 17:56:17 +0100
Subject: [PATCH] sched: disable sync wakeups

Pawel Dziekonski reported that the openssl benchmark and his
quantum chemistry application both show slowdowns due to the
scheduler under-parallelizing execution.

The reason are pipe wakeups still doing 'sync' wakeups which
overrides the normal buddy wakeup logic - even if waker and
wakee are loosely coupled.

So disable sync wakeups and also fix an inversion of logic
in the buddy wakeup code.

Reported-by: Pawel Dziekonski <dzieko@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c          |    4 ++++
 kernel/sched_fair.c     |    8 +-------
 kernel/sched_features.h |    2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8c2be1e..ce1cfc6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2266,6 +2266,10 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 	if (!sched_feat(SYNC_WAKEUPS))
 		sync = 0;
 
+	if (!sync && (current->se.avg_overlap < sysctl_sched_migration_cost &&
+			    p->se.avg_overlap < sysctl_sched_migration_cost))
+		sync = 1;
+
 #ifdef CONFIG_SMP
 	if (sched_feat(LB_WAKEUP_UPDATE)) {
 		struct sched_domain *sd;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5cc1c16..fd789a2 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1189,10 +1189,6 @@ wake_affine(struct sched_domain *this_sd, struct rq *this_rq,
 	if (!(this_sd->flags & SD_WAKE_AFFINE) || !sched_feat(AFFINE_WAKEUPS))
 		return 0;
 
-	if (sync && (curr->se.avg_overlap > sysctl_sched_migration_cost ||
-			p->se.avg_overlap > sysctl_sched_migration_cost))
-		sync = 0;
-
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
 	 * effect of the currently running task from the load
@@ -1419,9 +1415,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
-	if (sched_feat(WAKEUP_OVERLAP) && (sync ||
-			(se->avg_overlap < sysctl_sched_migration_cost &&
-			 pse->avg_overlap < sysctl_sched_migration_cost))) {
+	if (sched_feat(WAKEUP_OVERLAP) && sync) {
 		resched_task(curr);
 		return;
 	}
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index da5d93b..8134e65 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -4,7 +4,7 @@ SCHED_FEAT(WAKEUP_PREEMPT, 1)
 SCHED_FEAT(START_DEBIT, 1)
 SCHED_FEAT(AFFINE_WAKEUPS, 1)
 SCHED_FEAT(CACHE_HOT_BUDDY, 1)
-SCHED_FEAT(SYNC_WAKEUPS, 1)
+SCHED_FEAT(SYNC_WAKEUPS, 0)
 SCHED_FEAT(HRTICK, 0)
 SCHED_FEAT(DOUBLE_TICK, 0)
 SCHED_FEAT(ASYM_GRAN, 1)
