Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbXJHMoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbXJHMoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 08:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbXJHMny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 08:43:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57307 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbXJHMnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 08:43:53 -0400
Date: Mon, 8 Oct 2007 14:43:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/6] scheduler: Protect important kernel threads
	against normalize_rt
Message-ID: <20071008124350.GA5779@elte.hu>
References: <200710071059.126674000@suse.de> <20071007205958.7D8C41474B@wotan.suse.de> <20071008115142.GE22199@elte.hu> <200710081433.34845.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710081433.34845.ak@suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> softlockup is the same. Just think about it.
> 
> If you ever renormalize it and then run a fifo thread it will starve 
> and then eventually kill the box.
> 
> And starving CPU unplug is also equally bad.

yeah, agreed. I ended up doing the change below.

	Ingo

------------------->
Subject: sched: do not normalize kernel threads via SysRq-N
From: Ingo Molnar <mingo@elte.hu>

do not normalize kernel threads via SysRq-N: the migration threads,
softlockup threads, etc. might be essential for the system to
function properly. So only zap user tasks.

pointed out by Andi Kleen.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -362,15 +362,6 @@ static inline int cpu_of(struct rq *rq)
 #endif
 }
 
-static inline int is_migration_thread(struct task_struct *p, struct rq *rq)
-{
-#ifdef CONFIG_SMP
-	return p == rq->migration_thread;
-#else
-	return 0;
-#endif
-}
-
 /*
  * Update the per-runqueue clock, as finegrained as the platform can give
  * us, but without assuming monotonicity, etc.:
@@ -6557,6 +6548,12 @@ void normalize_rt_tasks(void)
 
 	read_lock_irq(&tasklist_lock);
 	do_each_thread(g, p) {
+		/*
+		 * Only normalize user tasks:
+		 */
+		if (!p->mm)
+			continue;
+
 		p->se.exec_start		= 0;
 #ifdef CONFIG_SCHEDSTATS
 		p->se.wait_start		= 0;
@@ -6578,8 +6575,7 @@ void normalize_rt_tasks(void)
 		spin_lock_irqsave(&p->pi_lock, flags);
 		rq = __task_rq_lock(p);
 
-		if (!is_migration_thread(p, rq))
-			normalize_task(rq, p);
+		normalize_task(rq, p);
 
 		__task_rq_unlock(rq);
 		spin_unlock_irqrestore(&p->pi_lock, flags);
