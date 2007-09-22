Return-Path: <linux-kernel-owner+w=401wt.eu-S1760705AbXIVDR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705AbXIVDR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 23:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbXIVDRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 23:17:17 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:53530 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbXIVDRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 23:17:16 -0400
Date: Fri, 21 Sep 2007 23:15:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>, a.p.zijlstra@chello.nl,
       bunk@kernel.org, ego@in.ibm.com, oleg@tv-sign.ru
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
In-Reply-To: <20070922015324.GN9059@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.58.0709212257150.6217@gandalf.stny.rr.com>
References: <20070910183004.GA3299@linux.vnet.ibm.com>
 <20070910183412.GC3819@linux.vnet.ibm.com> <20070921144003.GC15697@goodmis.org>
 <20070922002607.GI9059@linux.vnet.ibm.com> <Pine.LNX.4.58.0709212044200.4791@gandalf.stny.rr.com>
 <20070922015324.GN9059@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[took off Ingo, because he has my ISP blacklisted, and I'm tired of
getting those return mail messages. He can read LKML or you can re-CC
him. Sad since this is a topic he should be reading. ]

--
On Fri, 21 Sep 2007, Paul E. McKenney wrote:

> On Fri, Sep 21, 2007 at 09:15:03PM -0400, Steven Rostedt wrote:
> > On Fri, 21 Sep 2007, Paul E. McKenney wrote:
> > > On Fri, Sep 21, 2007 at 10:40:03AM -0400, Steven Rostedt wrote:
> > > > On Mon, Sep 10, 2007 at 11:34:12AM -0700, Paul E. McKenney wrote:
>
> [ . . . ]
>
> > > > > +	/*
> > > > > +	 * Take the next transition(s) through the RCU grace-period
> > > > > +	 * flip-counter state machine.
> > > > > +	 */
> > > > > +
> > > > > +	switch (rcu_try_flip_state) {
> > > > > +	case rcu_try_flip_idle_state:
> > > > > +		if (rcu_try_flip_idle())
> > > > > +			rcu_try_flip_state = rcu_try_flip_waitack_state;
> > > >
> > > > Just trying to understand all this. Here at flip_idle, only a CPU with
> > > > no pending RCU calls will flip it. Then all the cpus flags will be set
> > > > to rcu_flipped, and the ctrl.completed counter is incremented.
> > >
> > > s/no pending RCU calls/at least one pending RCU call/, but otherwise
> > > spot on.
> > >
> > > So if the RCU grace-period machinery is idle, the first CPU to take
> > > a scheduling-clock interrupt after having posted an RCU callback will
> > > get things going.
> >
> > I said 'no' becaues of this:
> >
> > +rcu_try_flip_idle(void)
> > +{
> > +       int cpu;
> > +
> > +       RCU_TRACE_ME(rcupreempt_trace_try_flip_i1);
> > +       if (!rcu_pending(smp_processor_id())) {
> > +               RCU_TRACE_ME(rcupreempt_trace_try_flip_ie1);
> > +               return 0;
> > +       }
> >
> > But now I'm a bit more confused. :-/
> >
> > Looking at the caller in kernel/timer.c I see
> >
> > 	if (rcu_pending(cpu))
> > 		rcu_check_callbacks(cpu, user_tick);
> >
> > And rcu_check_callbacks is the caller of rcu_try_flip. The confusion is
> > that we call this when we have a pending rcu, but if we have a pending
> > rcu, we won't flip the counter ??
>
> We don't enter unless there is something for RCU to do (might be a
> pending callback, for example, but might also be needing to acknowledge
> a counter flip).  If, by the time we get to rcu_try_flip_idle(), there
> is no longer anything to do (!rcu_pending()), we bail.
>
> So a given CPU kicks the state machine out of idle only if it -still-
> has something to do once it gets to rcu_try_flip_idle(), right?
>

Now I can slap my forehead!  Duh, I wasn't seeing that ! in front of the
rcu_pending condition in the rcu_try_flip_idle.  We only flip if we do
indeed have something pending. I need some sleep. I also need to
re-evaluate some of my analysis of that code. But it doesn't change my
opinion of the stages.

> >
> > Are we sure that adding all these grace periods stages is better than just
> > biting the bullet and put in a memory barrier?
>
> Good question.  I believe so, because the extra stages don't require
> much additional processing, and because the ratio of rcu_read_lock()
> calls to the number of grace periods is extremely high.  But, if I
> can prove it is safe, I will certainly decrease GP_STAGES or otherwise
> optimize the state machine.

But until others besides yourself understand that state machine (doesn't
really need to be me) I would be worried about applying it without
barriers.  The barriers may add a bit of overhead, but it adds some
confidence in the code.  I'm arguing that we have barriers in there until
there's a fine understanding of why we fail with 3 stages and not 4.
Perhaps you don't have a box with enough cpus to fail at 4.

I don't know how the higher ups in the kernel command line feel, but I
think that memory barriers on critical sections are justified. But if you
can show a proof that adding extra stages is sufficient to deal with
CPUS moving memory writes around, then so be it. But I'm still not
convinced that these extra stages are really solving the bug instead of
just making it much less likely to happen.

Ingo praised this code since it had several years of testing in the RT
tree. But that version has barriers, so this new verison without the
barriers has not had that "run it through the grinder" feeling to it.

>
> [ . . . ]
>
> > > > OK, that's all I have on this patch (will take a bit of a break before
> > > > reviewing your other patches).  But I will say that RCU has grown quite
> > > > a bit, and is looking very good.
> > >
> > > Glad you like it, and thank you again for the careful and thorough review.
> >
> > I'm scared to do the preempt portion %^O
>
> Ummm...  This -was- the preempt portion.  ;-)

hehe, I do need sleep I meant the boosting portion.

>
> > > > Basically, what I'm saying is "Great work, Paul!".  This is looking
> > > > good. Seems that we just need a little bit better explanation for those
> > > > that are not up at the IQ level of you.  I can write something up after
> > > > this all gets finalized. Sort of a rcu-design.txt, that really tries to
> > > > explain it to the simpleton's like me ;-)
> > >
> > > I do greatly appreciate the compliments, especially coming from someone
> > > like yourself, but it is also true that I have been implementing and
> > > using RCU in various forms for longer than some Linux-community members
> > > (not many, but a few) have been alive, and programming since 1972 or so.
> > > Lots and lots of practice!
> >
> > `72, I was 4.
>
> What, and you weren't programming yet???  ;-)

I think I was working a Turing Machine with my A-B-C blocks.

>
> > > Hmmm...  I started programming about the same time that I started
> > > jogging consistently.  Never realized that before.
> >
> > Well, I hope you keep doing both for a long time to come.
>
> Me too!  ;-)
>
> > > I am thinking in terms of getting an improved discussion of RCU design and
> > > use out there -- after all, the fifth anniversary of RCU's addition to
> > > the kernel is coming right up.  This does deserve better documentation,
> > > especially given that for several depressing weeks near the beginning
> > > of 2005 I believed that a realtime-friendly RCU might not be possible.
> >
> > That is definitely an accomplishment. And I know as well as you do that it
> > happened because of a lot of people sharing ideas. Some good, some bad,
> > but all helpful for heathy development!
>
> Indeed!  The current version is quite a bit different than my early-2005
> posting (which relied on locks!), and a -lot- of people had a hand in
> making it what it is today.

True.

-- Steve

