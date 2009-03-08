Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbZCHSzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbZCHSzm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 14:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZCHSzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 14:55:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58471 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbZCHSzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 14:55:31 -0400
Date: Sun, 8 Mar 2009 19:55:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Balazs Scheidler <bazsi@balabit.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: scheduler oddity [bug?]
Message-ID: <20090308185518.GB28169@elte.hu>
References: <1236448069.16726.21.camel@bzorp.balabit> <1236505323.6281.57.camel@marge.simson.net> <1236506309.6972.8.camel@marge.simson.net> <20090308153956.GB19658@elte.hu> <1236529200.7110.16.camel@marge.simson.net> <20090308175255.GA22802@elte.hu> <1236537580.7094.8.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236537580.7094.8.camel@marge.simson.net>
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
> That'll do it for this load.  I'll resume in the a.m., give 
> that some testing, and try to remember all the things I was 
> paranoid about.

btw., there's room for a cleanup + micro-optimization here too: 
it would be nice to change se.last_wakeup and 
se.prev_sum_exec_runtime to be the same variable, 
se.prev_timestamp or so.

That way we can do a simple:

 	update_avg(&p->se.avg_overlap,
		    p->se.sum_exec_runtime - p->se.prev_timestamp);
	p->se.prev_timestamp = 0;

the latter is needed as we rely on the zeroing here:

	kernel/sched.c: if (sleep && p->se.last_wakeup) {


	Ingo
