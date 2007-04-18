Return-Path: <linux-kernel-owner+w=401wt.eu-S2992856AbXDRQqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992856AbXDRQqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 12:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992857AbXDRQqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 12:46:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51334 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992856AbXDRQqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 12:46:49 -0400
Date: Wed, 18 Apr 2007 18:46:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Hesse <mail@earthworm.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, suspend2-devel@lists.suspend2.net
Subject: Re: CFS and suspend2: hang in atomic copy (was: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS])
Message-ID: <20070418164621.GA30744@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704181759.03559.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704181759.03559.mail@earthworm.de>
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


* Christian Hesse <mail@earthworm.de> wrote:

> Hi Ingo and all,
> 
> On Friday 13 April 2007, Ingo Molnar wrote:
> > as usual, any sort of feedback, bugreports, fixes and suggestions are
> > more than welcome,
> 
> I just gave CFS a try on my system. From a user's point of view it 
> looks good so far. Thanks for your work.

you are welcome!

> However I found a problem: When trying to suspend a system patched 
> with suspend2 2.2.9.11 it hangs with "doing atomic copy". Pressing the 
> ESC key results in a message that it tries to abort suspend, but then 
> still hangs.

i took a quick look at suspend2 and it makes some use of yield(). 
There's a bug in CFS's yield code, i've attached a patch that should fix 
it, does it make any difference to the hang?

	Ingo

Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -264,15 +264,26 @@ static void dequeue_task_fair(struct rq 
 
 /*
  * sched_yield() support is very simple via the rbtree, we just
- * dequeue and enqueue the task, which causes the task to
- * roundrobin to the end of the tree:
+ * dequeue the task and move it to the rightmost position, which
+ * causes the task to roundrobin to the end of the tree.
  */
 static void requeue_task_fair(struct rq *rq, struct task_struct *p)
 {
 	dequeue_task_fair(rq, p);
 	p->on_rq = 0;
-	enqueue_task_fair(rq, p);
+	/*
+	 * Temporarily insert at the last position of the tree:
+	 */
+	p->fair_key = LLONG_MAX;
+	__enqueue_task_fair(rq, p);
 	p->on_rq = 1;
+
+	/*
+	 * Update the key to the real value, so that when all other
+	 * tasks from before the rightmost position have executed,
+	 * this task is picked up again:
+	 */
+	p->fair_key = rq->fair_clock - p->wait_runtime + p->nice_offset;
 }
 
 /*
@@ -380,7 +391,10 @@ static void task_tick_fair(struct rq *rq
 	 * Dequeue and enqueue the task to update its
 	 * position within the tree:
 	 */
-	requeue_task_fair(rq, curr);
+	dequeue_task_fair(rq, curr);
+	curr->on_rq = 0;
+	enqueue_task_fair(rq, curr);
+	curr->on_rq = 1;
 
 	/*
 	 * Reschedule if another task tops the current one.
