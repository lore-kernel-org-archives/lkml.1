Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbZCIIHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbZCIIHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 04:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZCIIHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 04:07:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57382 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbZCIIHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 04:07:30 -0400
Date: Mon, 9 Mar 2009 09:07:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Balazs Scheidler <bazsi@balabit.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Willy Tarreau <w@1wt.eu>
Subject: Re: [patch] Re: scheduler oddity [bug?]
Message-ID: <20090309080714.GB24904@elte.hu>
References: <1236448069.16726.21.camel@bzorp.balabit> <1236505323.6281.57.camel@marge.simson.net> <1236506309.6972.8.camel@marge.simson.net> <20090308153956.GB19658@elte.hu> <1236529200.7110.16.camel@marge.simson.net> <20090308175255.GA22802@elte.hu> <1236585731.6118.24.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236585731.6118.24.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> On Sun, 2009-03-08 at 18:52 +0100, Ingo Molnar wrote:
> > * Mike Galbraith <efault@gmx.de> wrote:
> > 
> > > On Sun, 2009-03-08 at 16:39 +0100, Ingo Molnar wrote:
> > > > * Mike Galbraith <efault@gmx.de> wrote:
> > > > 
> > > > > The problem with your particular testcase is that while one 
> > > > > half has an avg_overlap (what we use as affinity hint for 
> > > > > synchronous wakeups) which triggers the affinity hint, the 
> > > > > other half has avg_overlap of zero, what it was born with, so 
> > > > > despite significant execution overlap, the scheduler treats 
> > > > > them as if they were truly synchronous tasks.
> > > > 
> > > > hm, why does it stay on zero?
> > > 
> > > Wakeup preemption.  Presuming here: heavy task wakes light 
> > > task, is preempted, light task stuffs data into pipe, heavy 
> > > task doesn't block, so no avg_overlap is ever computed.  The 
> > > heavy task uses 100% CPU.
> > > 
> > > Running as SCHED_BATCH (virgin source), it becomes sane.
> > 
> > ah.
> > 
> > I'd argue then that time spent on the rq preempted _should_ 
> > count in avg_overlap statistics. I.e. couldnt we do something 
> > like ... your patch? :)
> > 
> > > >     if (sleep && p->se.last_wakeup) {
> > > >             update_avg(&p->se.avg_overlap,
> > > >                        p->se.sum_exec_runtime - p->se.last_wakeup);
> > > >             p->se.last_wakeup = 0;
> > > > -   }
> > > > +   } else if (p->se.avg_overlap < limit && runtime >= limit)
> > > > +           update_avg(&p->se.avg_overlap, runtime);
> > 
> > Just done unconditionally, i.e. something like:
> > 
> > 	if (sleep) {
> > 		runtime = p->se.sum_exec_runtime - p->se.last_wakeup;
> > 		p->se.last_wakeup = 0;
> > 	} else {
> > 		runtime = p->se.sum_exec_runtime - p->se.prev_sum_exec_runtime;
> > 	}
> > 
> > 	update_avg(&p->se.avg_overlap, runtime);
> > 
> > ?
> 
> OK, I've not seen any problem indications yet, so find patchlet below.
> 
> However! Balazs has stated that this problem is _not_ present in .git,
> and that..
> 
> 	commit 38736f475071b80b66be28af7b44c854073699cc
> 	Author: Gautham R Shenoy <ego@in.ibm.com>
> 	Date:   Sat Sep 6 14:50:23 2008 +0530
> 
> ..is what fixed it.  Willy Tarreau verified this as being the case on
> his HW as well.  It is present in .git with my HW.
> 
> I see it as a problem, but it's your call.  Dunno if I'd apply it or
> hold back, given these conflicting reports.

I think we still want it - as the purpose of the overlap metric 
is to measure reality. If preemption causes overlap in execution 
we should not ignore that.

The fact that your hw triggers it currently is enough of a 
justification. Gautham's change to load-balancing might have 
shifted the preemption and migration characteristics on his box 
just enough to not trigger this - but it does not 'fix' the 
problem per se.

Peter, what do you think?

	Ingo
