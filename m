Return-Path: <linux-kernel-owner+w=401wt.eu-S1751806AbXDWUd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbXDWUd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 16:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbXDWUd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 16:33:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32921 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbXDWUd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 16:33:57 -0400
Date: Mon, 23 Apr 2007 22:33:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070423203317.GA26668@elte.hu>
References: <20070420140457.GA14017@elte.hu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org> <20070423013429.GB25162@wotan.suse.de> <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org> <20070423191143.GA16849@elte.hu> <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > The "give scheduler money" transaction can be both an "implicit 
> > transaction" (for example when writing to UNIX domain sockets or 
> > blocking on a pipe, etc.), or it could be an "explicit transaction": 
> > sched_yield_to(). This latter i've already implemented for CFS, but 
> > it's much less useful than the really significant implicit ones, the 
> > ones which will help X.
> 
> Yes. It would be wonderful to get it working automatically, so please 
> say something about the implementation..

i agree that the devil will be in the details, but so far it's really 
simple. I'll put all this into separate helper functions so that places 
can just use it in a natural way. The existing yield-to bit is this:

static void
yield_task_fair(struct rq *rq, struct task_struct *p, struct task_struct *p_to)
{
        struct rb_node *curr, *next, *first;
        struct task_struct *p_next;

        /*
         * yield-to support: if we are on the same runqueue then
         * give half of our wait_runtime (if it's positive) to the other task:
         */
        if (p_to && p->wait_runtime > 0) {
                p->wait_runtime >>= 1;
                p_to->wait_runtime += p->wait_runtime;
        }

the above is the basic expression of: "charge a positive bank balance". 

(we obviously dont want to allow people to 'share' their loans with 
others ;), nor do we want to allow a net negative balance. CFS is really 
brutally cold-hearted, it has a strict 'no loans' policy - the easiest 
economic way to manage 'inflation', besides the basic act of not 
printing new money, ever.)

[note, due to the nanoseconds unit there's no rounding loss to worry 
about.]

that's all. No runqueue locking, no wakeup decisions even! [Note: see 
detail #1 below for cases where we need to touch the tree]. Really 
low-overhead. Accumulated 'new money' will be acted upon in the next 
schedule() call or in the next scheduler tick, whichever comes sooner. 
Note that in most cases when tasks communicate there will be a natural 
schedule() anyway, which drives this.

p->wait_runtime is also very finegrained: it is in nanoseconds, so a 
task can 'pay' at arbitrary granularity in essence, and there is in 
essence zero 'small coin overhead' and 'conversion loss' in this money 
system. (as you might remember, sharing p->timeslice had inherent 
rounding and sharing problems due to its low jiffy resolution)

detail #1: for decoupled workloads where there is no direct sleep/wake 
coupling between worker and producer, there should also be a way to 
update a task's position in the fairness tree, if it accumulates 
significant amount of new p->wait_runtime. I think this can be done by 
making this an extra field: p->new_wait_runtime, which gets picked up by 
the task if it runs, or which gets propagated into the task's tree 
position if the p->new_wait_runtime value goes above the 
sched_granularity_ns value. But it would work pretty well even without 
this, the server will take advantage of the p->new_wait_runtime 
immediately when it runs, so as long as enough clients 'feed' it with 
money, it will always have enough to keep going.

detail #2: changes to p->wait_runtime are totally lockless, as long as 
they are 64-bit atomic. So the above code is a bit naive on 32-bit 
systems, but no locking is needed otherwise, other than having a stable 
reference to a task structure. (i designed CFS for 64-bit systems)

detail #3: i suspect i should rename p->wait_runtime to a more intuitive 
name - perhaps p->right_to_run? I want to avoid calling it p->timeslice 
because it's not really a timeslice, it's the thing you earned, the 
'timeslice' is a totally locally decided property that has no direct 
connection to this physical resource. I also dont want to call it 
p->cpu_credit, because it is _not_ a credit system: every positive value 
there has been earned the hard way: by 'working' for the system via 
waiting on the runqueue - scaled down to the 'expected fair runtime' - 
i.e. roughly scaled down by 1/rq->nr_running.

detail #3: the scheduler is also a charity: when it has no other work 
left it will let tasks execute "for free" ;-) But otherwise, in any sort 
of saturated market situation CFS is very much a cold hearted 
capitalist.

about the 50% rule: it was a totally arbitrary case for yield_to(), and 
in other cases it should rather be: "give me _all_ the money you have, 
i'll make it work for you as much as i can". And the receiver should 
also perhaps record the amount of 'money' it got from the client, and 
_give back_ any unused proportion of it. (only where easily doable, in 
1:1 task relationships) I.e.:

        p_to->wait_runtime = p->wait_runtime;
	p->wait_runtime = 0;

	schedule();

the former two lines put into a sched_pay(p) API perhaps?

> The "perfect" situation would be that when somebody goes to sleep, any 
> extra points it had could be given to whoever it woke up last. Note 
> that for something like X, it means that the points are 100% 
> ephemeral: it gets points when a client sends it a request, but it 
> would *lose* the points again when it sends the reply!

yeah, exactly. X could even attempt to explicitly manage some of those 
payments it received: it already has an internal automatic notion of 
'expensive clients' (which do large X requests).

> There are subtle semantics with these kinds of things: especially if 
> the scheduling points are only awarded when a process goes to sleep, 
> if X is busy and continues to use the CPU (for another client), it 
> wouldn't give any scheduling points back to clients and they really do 
> accumulate with the server. Which again sounds like it would be 
> exactly the right thing (both in the sense that the server that runs 
> more gets more points, but also in the sense that we *only* give 
> points at actual scheduling events).

yeah. Not only would it cause accumulation of 'money', that money would 
buy it lower latencies as well: with more p->wait_runtime X will get on 
the CPU faster. So it's a basic "work batching" mechanism.

> But how do you actually *give/track* points? [...]

tracking: these points are all hard-earned and their sum in the system 
has a maximum. I.e. any point you 'give' to X was something you already 
earned and it's something that the scheduler would have given CPU time 
for in the near future. So as long as the transaction is balanced (the 
total sum does not change), this does not create any unfairness 
anywhere.

giving: it can be done lockless (64-bit atomic, they are nanoseconds). 
'Collecting' p->new_wait_runtime up to sched_granularity_ns will also 
make sure this field is the only typical impact that clients have on the 
server - the tree position will only be recalculated at a frequency 
determined by sched_granularity_ns.

> [...] A simple "last woken up by this process" thing that triggers 
> when it goes to sleep? It might work, but on the other hand, 
> especially with more complex things (and networking tends to be pretty 
> complex) the actual wakeup may be done by a software irq. Do we just 
> say "it ran within the context of X, so we assume X was the one that 
> caused it?" It probably would work, but we've generally tried very 
> hard to avoid accessing "current" from interrupt context, including 
> bh's..

i'd concentrate on specific synchronous instances first, where we know 
the producer and the consumer.

Later on we could attach "money" to localhost network packets for 
example, to 'spread' fairness into more complex parts of the system. 
(Note that such 'money' could even be passed along with a _physical_ 
packet, for example in a cluster - so it makes lots of sense on both the 
small and the large scale.) I'd not directly attach 'money' to softirqs, 
i'd attach it to the _object of work_: the packet, the workqueue entry, 
the IO request, etc., etc.

	Ingo
