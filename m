Return-Path: <linux-kernel-owner+w=401wt.eu-S1030920AbXDSKSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030920AbXDSKSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 06:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030925AbXDSKSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 06:18:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35984 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030920AbXDSKSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 06:18:52 -0400
Date: Thu, 19 Apr 2007 12:18:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Esben Nielsen <nielsen.esben@googlemail.com>
Cc: Christian Hesse <mail@earthworm.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, suspend2-devel@lists.suspend2.net
Subject: Re: CFS and suspend2: hang in atomic copy (was: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS])
Message-ID: <20070419101823.GA4574@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704181759.03559.mail@earthworm.de> <20070418164621.GA30744@elte.hu> <Pine.LNX.4.64.0704191117530.8557@frodo.shire> <20070419101131.GB32274@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419101131.GB32274@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > I think a better approach would be to keep track of the rightmost 
> > entry, set the key to the rightmost's key +1 and then simply insert 
> > it there.
> 
> yeah. I had that implemented at a stage but was trying to be too 
> clever for my own good ;-)

i have fixed it via the patch below. (I'm using rb_last() because that 
way the normal scheduling codepaths are not burdened with the 
maintainance of a rightmost entry.)

	Ingo

---
 kernel/sched.c      |    3 ++-
 kernel/sched_fair.c |   24 +++++++++++++-----------
 2 files changed, 15 insertions(+), 12 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -3806,7 +3806,8 @@ asmlinkage long sys_sched_yield(void)
 	schedstat_inc(rq, yld_cnt);
 	if (rq->nr_running == 1)
 		schedstat_inc(rq, yld_act_empty);
-	current->sched_class->yield_task(rq, current);
+	else
+		current->sched_class->yield_task(rq, current);
 
 	/*
 	 * Since we are going to call schedule() anyway, there's
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -275,21 +275,23 @@ static void dequeue_task_fair(struct rq 
  */
 static void yield_task_fair(struct rq *rq, struct task_struct *p)
 {
+	struct rb_node *entry;
+	struct task_struct *last;
+
 	dequeue_task_fair(rq, p);
 	p->on_rq = 0;
+
 	/*
-	 * Temporarily insert at the last position of the tree:
+	 * Temporarily insert at the last position of the tree.
+	 * The key will be updated back to (near) its old value
+	 * when the task gets scheduled.
 	 */
-	p->fair_key = LLONG_MAX;
+	entry = rb_last(&rq->tasks_timeline);
+	last = rb_entry(entry, struct task_struct, run_node);
+
+	p->fair_key = last->fair_key + 1;
 	__enqueue_task_fair(rq, p);
 	p->on_rq = 1;
-
-	/*
-	 * Update the key to the real value, so that when all other
-	 * tasks from before the rightmost position have executed,
-	 * this task is picked up again:
-	 */
-	p->fair_key = rq->fair_clock - p->wait_runtime + p->nice_offset;
 }
 
 /*
