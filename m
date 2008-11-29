Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbYK2Tvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbYK2Tvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 14:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYK2Tvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 14:51:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39679 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbYK2Tvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 14:51:37 -0500
Date: Sat, 29 Nov 2008 20:50:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/1] sched: prevent divide by zero error in
	cpu_avg_load_per_task
Message-ID: <20081129195059.GA26646@elte.hu>
References: <20081127020423.460116740@goodmis.org> <20081127020554.533035163@goodmis.org> <alpine.LFD.2.00.0811291107400.24125@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811291107400.24125@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 26 Nov 2008, Steven Rostedt wrote:
> >  {
> >  	struct rq *rq = cpu_rq(cpu);
> > +	unsigned long nr_running = rq->nr_running;
> >  
> > -	if (rq->nr_running)
> > -		rq->avg_load_per_task = rq->load.weight / rq->nr_running;
> > +	if (nr_running)
> > +		rq->avg_load_per_task = rq->load.weight / nr_running;
> >  	else
> >  		rq->avg_load_per_task = 0;
> 
> I don't think this necessarily fixes it.
> 
> There's nothing that keeps gcc from deciding not to reload 
> rq->nr_running.
> 
> Of course, in _practice_, I don't think gcc ever will (if it decides 
> that it will spill, gcc is likely going to decide that it will 
> literally spill the local variable to the stack rather than decide to 
> reload off the pointer), but it's a valid compiler optimization, and it 
> even has a name (rematerialization).
> 
> So I suspect that your patch does fix the bug, but it still leaves the 
> fairly unlikely _potential_ for it to re-appear at some point.
> 
> We have ACCESS_ONCE() as a macro to guarantee that the compiler doesn't 
> rematerialize a pointer access. That also would clarify the fact that 
> we access something unsafe outside a lock.

Okay - i've queued up the fix below, to be on the safe side.

	Ingo

---------------->
>From af6d596fd603219b054c1c90fb16672a9fd441bd Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 29 Nov 2008 20:45:15 +0100
Subject: [PATCH] sched: prevent divide by zero error in cpu_avg_load_per_task, update

Regarding the bug addressed in:

  4cd4262: sched: prevent divide by zero error in cpu_avg_load_per_task

Linus points out that the fix is not complete:

> There's nothing that keeps gcc from deciding not to reload
> rq->nr_running.
>
> Of course, in _practice_, I don't think gcc ever will (if it decides
> that it will spill, gcc is likely going to decide that it will
> literally spill the local variable to the stack rather than decide to
> reload off the pointer), but it's a valid compiler optimization, and
> it even has a name (rematerialization).
>
> So I suspect that your patch does fix the bug, but it still leaves the
> fairly unlikely _potential_ for it to re-appear at some point.
>
> We have ACCESS_ONCE() as a macro to guarantee that the compiler
> doesn't rematerialize a pointer access. That also would clarify
> the fact that we access something unsafe outside a lock.

So make sure our nr_running value is immutable and cannot change
after we check it for nonzero.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 700aa9a..b7480fb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1453,7 +1453,7 @@ static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
 static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-	unsigned long nr_running = rq->nr_running;
+	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
 
 	if (nr_running)
 		rq->avg_load_per_task = rq->load.weight / nr_running;
