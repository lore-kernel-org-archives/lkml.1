Return-Path: <linux-kernel-owner+w=401wt.eu-S1030234AbXBZNbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030234AbXBZNbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 08:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030240AbXBZNbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 08:31:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45161 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030234AbXBZNbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 08:31:46 -0500
Date: Mon, 26 Feb 2007 14:25:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: tglx@linutronix.de,
       Michal Piotrowski <michal.k.k.piotrowski@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] sched: fix SMT scheduler bug
Message-ID: <20070226132515.GA17601@elte.hu>
References: <6bffcb0e0702201437o66db38d5j3066eb3c9951a270@mail.gmail.com> <1172072023.25076.64.camel@localhost.localdomain> <6bffcb0e0702210738p687ca1bdt2c568d7ed5904fff@mail.gmail.com> <1172088044.25076.125.camel@localhost.localdomain> <45DCF644.9040009@googlemail.com> <45DD756D.3040006@googlemail.com> <20070223060802.GA8562@elte.hu> <6bffcb0e0702241445v562be44y5ddac6d6abdb5131@mail.gmail.com> <1172397209.25076.365.camel@localhost.localdomain> <6bffcb0e0702260501q214c3ac8xedee578e4e29a5be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0702260501q214c3ac8xedee578e4e29a5be@mail.gmail.com>
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


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Ok, I think that this is a SMT scheduler problem.
> 
> System works fine for fifteen hours.

hmmm. I think it's this piece of smt-nice code in sched.c:

        if (dependent_sleeper(cpu, rq, next))
                next = rq->idle;

this will skip to run this HT CPU if the sibling CPU is running a task 
that is more important. And dependent_sleeper() doesnt skip kernel 
threads such as ksoftirqd:

        /* kernel/rt threads do not participate in dependent sleeping */
        if (!p->mm || rt_task(p))
                return 0;

but ... what if the highest-prio thread is a user-space task /and/ there 
is ksoftirqd also queued, which is now delayed? We schedule the idle 
task instead of processing softirqs. Ouch!

To test this theory, could you turn the SMT scheduler back on but also 
apply the patch below. Does it still work fine?

	Ingo

---------------------->
Subject: [patch] sched: fix SMT scheduler bug
From: Ingo Molnar <mingo@elte.hu>

the SMT scheduler incorrectly skips kernel threads even if they
are runnable (but they are preempted by a higher-prio user-space
task which got SMT-delayed by an even higher-priority task
running on a sibling CPU).

fix this for now by only doing the SMT-nice optimization if
the to-be-delayed task is the only runnable task. (This should
cover most of the real-life cases anyway.)

this bug has been in the SMT scheduler since 2.6.17 or so, but has
only been noticed now by the active check in the dynticks code.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -3537,7 +3537,7 @@ need_resched_nonpreemptible:
 		}
 	}
 	next->sleep_type = SLEEP_NORMAL;
-	if (dependent_sleeper(cpu, rq, next))
+	if (rq->nr_running == 1 && dependent_sleeper(cpu, rq, next))
 		next = rq->idle;
 switch_tasks:
 	if (next == rq->idle)
