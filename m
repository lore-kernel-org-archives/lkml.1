Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbZIWGcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbZIWGcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 02:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbZIWGcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 02:32:50 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:58009 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbZIWGcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 02:32:50 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] sched: Make sure task has correct sched_class after
 policy change
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing <linux-kernel@vger.kernel.org>
In-Reply-To: <e286470be617e07797b7.1253672517@mudlark.pw.nest>
References: <e286470be617e07797b7.1253672517@mudlark.pw.nest>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 08:32:59 +0200
Message-Id: <1253687579.7695.89.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 02:21 +0000, Peter Williams wrote:
> From the code in rt_mutex_setprio(), it is evident that the intention
> is that task's with a RT 'prio' value as a consequence of receiving a PI
> boost also have their 'sched_class' field set to '&rt_sched_class'.
> However, the code in __setscheduler() could result in this intention
> being frustrated.
> 
> This patch fixes this problem.
> 
> Signed-off-by: Peter Williams <pwil3058@bigpond.net.au>

I think you're right, but the problem seems to be that it sets
sched_class based on policy, which seems fragile in the face of PI.

How about the alternative below?

---
 kernel/sched.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 91843ba..753a52c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6129,23 +6129,14 @@ __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 {
 	BUG_ON(p->se.on_rq);
 
-	p->policy = policy;
-	switch (p->policy) {
-	case SCHED_NORMAL:
-	case SCHED_BATCH:
-	case SCHED_IDLE:
-		p->sched_class = &fair_sched_class;
-		break;
-	case SCHED_FIFO:
-	case SCHED_RR:
-		p->sched_class = &rt_sched_class;
-		break;
-	}
-
 	p->rt_priority = prio;
 	p->normal_prio = normal_prio(p);
 	/* we are holding p->pi_lock already */
 	p->prio = rt_mutex_getprio(p);
+	if (rt_prio(p->prio))
+		p->sched_class = &rt_sched_class;
+	else
+		p->sched_class = &fair_sched_class;
 	set_load_weight(p);
 }
 


