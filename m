Return-Path: <linux-kernel-owner+w=401wt.eu-S1764715AbXF1QCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764715AbXF1QCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 12:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758778AbXF1QB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 12:01:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53565 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399AbXF1QB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 12:01:57 -0400
Date: Thu, 28 Jun 2007 18:00:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070628160001.GA15495@elte.hu>
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628143850.GA11780@ms2.inr.ac.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Kuznetsov <kuznet@ms2.inr.ac.ru> wrote:

> > the context-switch argument i'll believe if i see numbers. You'll 
> > probably need in excess of tens of thousands of irqs/sec to even be 
> > able to measure its overhead. (workqueues are driven by nice kernel 
> > threads so there's no TLB overhead, etc.)
> 
> It was authors of the patch who were supposed to give some numbers, at 
> least one or two, just to prove the concept. :-)

sure enough! But it was not me who claimed that 'workqueues are slow'.

firstly, i'm not here at all to tell people what tools to use. I'm not 
trying to 'force' people away from a perfectly logical technological 
choice. I am just wondering out loud whether this particular tool, in 
its current usage pattern, makes much technological sense. My claim is: 
it could very well be that it doesnt make _much_ sense, and in that case 
we should provide a non-intrusive migration path away in terms of a 
compatible API wrapper to a saner (albeit by virtue of trying to emulate 
an existing API, slower) mechanism. The examples cited so far had the 
tasklet as an intermediary towards a softirq - what's the technological 
point in such a splitup?

> According to my measurements (maybe, wrong) on 2.5GHz P4 tasklet 
> schedule and execution eats ~300ns, workqueue eats ~4usec. On my 
> 1.8GHz PM notebook (UP kernel), the numbers are 170ns and 1.2usec.

I find the 4usecs cost on a P4 interesting and a bit too high - how did 
you measure it? (any test-patch for it i could try?) But i think even 
your current numbers partly prove my point: with 1.2 usecs and 10,000 
irqs/sec the cost is 1.2 msecs/sec, or 0.1%. And 10K irqs/sec themselves 
will eat up much more CPU time than that already.

> Formally looking awful, this result is positive: tasklets are almost 
> never used in hot paths. I am sure only about one such place: acenic 
> driver uses tasklet to refill rx queue. This generates not more than 
> 3000 tasklet schedules per second. Even on P4 it pure workqueue 
> schedule will eat ~1% of bare cpu ticks.

... and the irq cost itself will eat 5-10% of bare CPU ticks already.

> > ... workqueues are also possibly much more scalable
> 
> I cannot figure out - scale in what direction? :-)

workqueues can be per-cpu - for tasklets to be per-cpu you have to 
open-code them into per-cpu like rcu-tasklets did (which in essence 
turns them into more expensive softirqs).

> >						 (percpu workqueues
> > are easy without changing anything in your code but the call where 
> > you create the workqueue).
> 
> I do not see how it is related to scalability. And the statement does 
> not even make sense. The patch already uses per-cpu workqueue for 
> tasklets, otherwise it would be a disaster: guaranteed cpu 
> non-locality.

my argument was: workqueues are more scalable than tasklets in general.

Just look at the tasklet_disable() logic. We basically have a per-cpu 
list of tasklets that we poll in tasklet_action:

 static void tasklet_action(struct softirq_action *a)
 {
        [...]
        while (list) {
                struct tasklet_struct *t = list;

                list = list->next;

                if (tasklet_trylock(t)) {

and if the trylock fails, we just continue to meet this activated 
tasklet again and again, in this nice linear list.

this happens to work in practice because 1) tasklets are used quite 
rarely! 2) tasklet_disable() is done realtively rarely and nobody truly 
runs tons of the same devices (which depend on a tasklet) on the same 
box, but still it's quite an unhealthy approach. Every time i look at 
the tasklet code it hurts - having fundamental stuff like that in the 
heart of Linux ;-)

also, the "be afraid of the hardirq or the process context" mantra is 
overblown as well. If something is too heavy for a hardirq, _it's too 
heavy for a tasklet too_. Most hardirqs are (or should be) running with 
interrupts enabled, which makes their difference to softirqs miniscule. 

The most scalable workloads dont involve any (or many) softirq middlemen 
at all: you queue work straight from the hardirq context to the target 
process context. And that's what you want to do _anyway_, because you 
want to create as little locally cached data for the hardirq context, as 
the target task could easily be on another CPU. (this is generally true 
for things like block IO, but it's also true for things like network 
IO.)

the most scalable solution would be _for the network adapter to figure 
out the target CPU for the packet_. Not many (if any) such adapters 
exist at the moment. (as it would involve allocating NR_CPUs irqs to 
that adapter alone.)

> Tasklet is single thread by definition and purpose. Those a few places 
> where people used tasklets to do per-cpu jobs (RCU f.e.) exist just 
> because they had troubles with allocating new softirq. [...]

no. The following tale is the true and only history of the RCU tasklet 
;-) The RCU guys first used a tasklet, then noticed its bad scalability 
(a particular VFS-intense benchmark regressed because only a single CPU 
would do RCU completion on an 8-way box) so they switched it to a 
per-cpu tasklet - without realizing that a per-cpu tasklet is in essence 
a softirq. I pointed it out to them (years down the road ...) then the 
"convert rcu-tasklet to softirq" patch was born.

> > the only remaining argument is latency:
> 
> You could set realtime prioriry by default, not a poor nice -5. If 
> some network adapters were killed just because I run some task with 
> nice --22, it would be just ridiculous.

there are only 20 negative nice levels ;-) And i dont really get the 
'you might kill the network adapter' argument, because the opposite is 
true just as much: tasklets from a totally uninteresting network adapter 
can kill your latency-sensitive application too.

So providing more flexibility in the prioritization of the work that 
goes on in the system (as long as it has no other drawbacks) can not be 
wrong. The "but you will shoot yourself in the foot" argument is really 
backwards in that context.

Tasklets are called 'task'-lets for a reason: they are poorly scheduled, 
inflexible tasks. They were written in an age when we didnt have 
workqueues, we didnt have kthreads and real men thought they wanted to 
do all their TCP/IP processing in softirq context [ am i heading down 
the road towards a showdown with DaveM here? ;-) ].

Now ... you (and Jeff, and others) are right and workqueues could be too 
slow for some of the cases (i said before that i'd be surprised if it 
were more than 1-2), in which case my argument changes to what i 
outlined above: if you want good scalability, dont use middlemen :-) 
Figure out the target task as early as possible and let it do as much of 
the remaining work as possible. _Increasing_ the amount of cached 
context (by doing delayed processing in tasklets or even softirqs on the 
same CPU where the hardirq arrived) only increases the cross-CPU cost. 
Keeping stuff in a softirq only makes (some) sense as long as you have 
no target task at all (routing, filtering, etc.).

	Ingo
