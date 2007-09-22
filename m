Return-Path: <linux-kernel-owner+w=401wt.eu-S1757666AbXIVBP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666AbXIVBP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 21:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbXIVBPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 21:15:14 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:35278 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbXIVBPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 21:15:11 -0400
Date: Fri, 21 Sep 2007 21:15:03 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, oleg@tv-sign.ru
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
In-Reply-To: <20070922002607.GI9059@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.58.0709212044200.4791@gandalf.stny.rr.com>
References: <20070910183004.GA3299@linux.vnet.ibm.com>
 <20070910183412.GC3819@linux.vnet.ibm.com> <20070921144003.GC15697@goodmis.org>
 <20070922002607.GI9059@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 21 Sep 2007, Paul E. McKenney wrote:

> On Fri, Sep 21, 2007 at 10:40:03AM -0400, Steven Rostedt wrote:
> > On Mon, Sep 10, 2007 at 11:34:12AM -0700, Paul E. McKenney wrote:
>
> Covering the pieces that weren't in Peter's reply.  ;-)
>
> And thank you -very- much for the careful and thorough review!!!
>
> > >  #endif /* __KERNEL__ */
> > >  #endif /* __LINUX_RCUCLASSIC_H */
> > > diff -urpNa -X dontdiff linux-2.6.22-b-fixbarriers/include/linux/rcupdate.h linux-2.6.22-c-preemptrcu/include/linux/rcupdate.h
> > > --- linux-2.6.22-b-fixbarriers/include/linux/rcupdate.h	2007-07-19 14:02:36.000000000 -0700
> > > +++ linux-2.6.22-c-preemptrcu/include/linux/rcupdate.h	2007-08-22 15:21:06.000000000 -0700
> > > @@ -52,7 +52,11 @@ struct rcu_head {
> > >  	void (*func)(struct rcu_head *head);
> > >  };
> > >
> > > +#ifdef CONFIG_CLASSIC_RCU
> > >  #include <linux/rcuclassic.h>
> > > +#else /* #ifdef CONFIG_CLASSIC_RCU */
> > > +#include <linux/rcupreempt.h>
> > > +#endif /* #else #ifdef CONFIG_CLASSIC_RCU */
> >
> > A bit extreme on the comments here.
>
> My fingers do this without any help from the rest of me, but I suppose
> it is a bit of overkill in this case.

Heck, why stop the overkill here, the whole patch is overkill ;-)

> > > +
> > > +#define GP_STAGES 4
> >
> > I take it that GP stand for "grace period". Might want to state that
> > here. /* Grace period stages */  When I was looking at this code at 1am,
> > I kept asking myself "what's this GP?" (General Protection??). But
> > that's what happens when looking at code like this after midnight ;-)
>
> Good point, will add a comment.  You did get it right, "grace period".

Thanks, so many places in the kernel have acronyms that are just suppose
to be "obvious". I hate them, because they make me feel so stupid when I
don't know what they are. After I find out, I usually slap my forehead and
say "duh!". My mind is set on reading code, not deciphering TLAs.


> >
> > Can you have a pointer somewhere that explains these states. And not a
> > "it's in this paper or directory". Either have a short discription here,
> > or specify where exactly to find the information (perhaps a
> > Documentation/RCU/preemptible_states.txt?).
> >
> > Trying to understand these states has caused me the most agony in
> > reviewing these patches.
>
> Good point, perhaps a comment block above the enum giving a short
> description of the purpose of each state.  Maybe more detail in
> Documentation/RCU as well, as you suggest above.

That would be great.

> > > +
> > > +/*
> > > + * Return the number of RCU batches processed thus far.  Useful for debug
> > > + * and statistics.  The _bh variant is identical to straight RCU.
> > > + */
> >
> > If they are identical, then why the separation?
>
> I apologize for the repetition in this email.
>
> I apologize for the repetition in this email.
>
> I apologize for the repetition in this email.
>
> Yep, will fix with either #define or static inline, as you suggested
> in a later email.

you're starting to sound like me ;-)

> > > +	struct task_struct *me = current;
> >
> > Nitpick, but other places in the kernel usually use "t" or "p" as a
> > variable to assign current to.  It's just that "me" thows me off a
> > little while reviewing this.  But this is just a nitpick, so do as you
> > will.
>
> Fair enough, as discussed earlier.

Who's on first, What's on second, and I-dont-know is on third.

> > > +		unsigned long oldirq;
> >
> > Nitpick, "flags" is usually used for saving irq state.
>
> A later patch in the series fixes these -- I believe I got all of them.
> (The priority-boost patch, IIRC.)

OK

>
> > > +
> > > +		/*
> > > +		 * Disable local interrupts to prevent the grace-period
> > > +		 * detection state machine from seeing us half-done.
> > > +		 * NMIs can still occur, of course, and might themselves
> > > +		 * contain rcu_read_lock().
> > > +		 */
> > > +
> > > +		local_irq_save(oldirq);
> >
> > Isn't the GP detection done via a tasklet/softirq. So wouldn't a
> > local_bh_disable be sufficient here? You already cover NMIs, which would
> > also handle normal interrupts.
>
> We beat this into the ground in other email.

Nothing like kicking a dead horse on LKML ;-)

> > > +
> > > +		/*
> > > +		 * It is now safe to decrement this task's nesting count.
> > > +		 * NMIs that occur after this statement will route their
> > > +		 * rcu_read_lock() calls through this "else" clause, and
> > > +		 * will thus start incrementing the per-CPU coutner on
> >
> > s/coutner/counter/
>
> wlli fxi!!!

snousd oogd

> > > +
> > > +/*
> > > + * Attempt a single flip of the counters.  Remember, a single flip does
> > > + * -not- constitute a grace period.  Instead, the interval between
> > > + * at least three consecutive flips is a grace period.
> > > + *
> > > + * If anyone is nuts enough to run this CONFIG_PREEMPT_RCU implementation
> >
> > Oh, come now! It's not "nuts" to use this ;-)
>
> ;-)

Although working with RCU may drive one nuts.

> > > +	/*
> > > +	 * Take the next transition(s) through the RCU grace-period
> > > +	 * flip-counter state machine.
> > > +	 */
> > > +
> > > +	switch (rcu_try_flip_state) {
> > > +	case rcu_try_flip_idle_state:
> > > +		if (rcu_try_flip_idle())
> > > +			rcu_try_flip_state = rcu_try_flip_waitack_state;
> >
> > Just trying to understand all this. Here at flip_idle, only a CPU with
> > no pending RCU calls will flip it. Then all the cpus flags will be set
> > to rcu_flipped, and the ctrl.completed counter is incremented.
>
> s/no pending RCU calls/at least one pending RCU call/, but otherwise
> spot on.
>
> So if the RCU grace-period machinery is idle, the first CPU to take
> a scheduling-clock interrupt after having posted an RCU callback will
> get things going.

I said 'no' becaues of this:

+rcu_try_flip_idle(void)
+{
+       int cpu;
+
+       RCU_TRACE_ME(rcupreempt_trace_try_flip_i1);
+       if (!rcu_pending(smp_processor_id())) {
+               RCU_TRACE_ME(rcupreempt_trace_try_flip_ie1);
+               return 0;
+       }

But now I'm a bit more confused. :-/

Looking at the caller in kernel/timer.c I see

	if (rcu_pending(cpu))
		rcu_check_callbacks(cpu, user_tick);

And rcu_check_callbacks is the caller of rcu_try_flip. The confusion is
that we call this when we have a pending rcu, but if we have a pending
rcu, we won't flip the counter ??



>
> > When a CPU calls process_callbacks, it would then move all it's
> > callbacks to the next list (next -> wait[GP...] -> done), and set it's
> > unique completed counter to completed. So no more moving up the lists
> > will be done. It also will set it's state flag to rcu_flip_seen. Even if
> > the cpu doesn't have any RCU callbacks, the state would be in
> > rcu_try_flip_waitack_state so we go to the next switch case for a
> > rcu_try_flip call.
>
> Yep.  The wait-for-acknowledgement cycle is there to handle rcu_read_lock()
> invocations on other CPUs that executed concurrently with the counter
> increment in rcu_try_flip_idle().
>
> > Also the filp counter has been flipped so that all new rcu_read_locks
> > will increment the cpus "other" index. We just need to wait for the
> > index of the previous counters to reach zero.
>
> Yep.  Note that rcu_read_lock() might well be able to use its local
> .completed counter rather than the global one in rcu_ctrlblk, but
> (1) it is not clear that the reduction in cache misses would outweigh
> the per-CPU access overhead given that rcu_read_lock() happens a -lot-
> more often than does a counter flip and (2) doing this could well require
> cranking up GP_STAGES.
>
> > > +		break;
> > > +	case rcu_try_flip_waitack_state:
> > > +		if (rcu_try_flip_waitack())
> >
> > Now, we just wait to see if all the cpus have called process_callbacks
> > and now have the flag rcu_flip_seen set. So all the cpus have pushed
> > their callbacks up to the next queue.
>
> Yep!  More importantly, we know that no CPU will ever increment the
> "old" set of counters.
>
> > > +			rcu_try_flip_state = rcu_try_flip_waitzero_state;
> > > +		break;
> > > +	case rcu_try_flip_waitzero_state:
> > > +		if (rcu_try_flip_waitzero())
> >
> > Now this is where we wait for the sum of all the CPUs counters to reach
> > zero. The reason for the sum is that the task may have been preempted
> > and migrated to another CPU and decremented that counter. So the one CPU
> > counter would be 1 and the other would be -1. But the sum is still zero.
>
> Yep!
>
> > Is there a chance that overflow of a counter (although probably very
> > very unlikely) would cause any problems?
>
> The only way it could cause a problem would be if there was ever
> more than 4,294,967,296 outstanding rcu_read_lock() calls.  I believe
> that lockdep screams if it sees more than 30 nested locks within a
> single task, so for systems that support no more than 100M tasks, we
> should be OK.  It might sometime be necessary to make this be a long
> rather than an int.  Should we just do that now and be done with it?

Sure, why not. More and more and more overkill!!!

(rostedt hears in his head the Monty Python "Spam" song).

>
> > Also, all the CPUs have their "check_mb" set.
> >
> > > +			rcu_try_flip_state = rcu_try_flip_waitmb_state;
> > > +		break;
> > > +	case rcu_try_flip_waitmb_state:
> > > +		if (rcu_try_flip_waitmb())
> >
> > I have to admit that this seems a bit of an overkill, but I guess you
> > know what you are doing.  After going through three states, we still
> > need to do a memory barrier on each CPU?
>
> Yep.  Because there are no memory barriers in rcu_read_unlock(), the
> CPU is free to reorder the contents of the RCU read-side critical section
> to follow the counter decrement.  This means that this CPU would still
> be referencing RCU-protected data after it had told the world that it
> was no longer doing so.  Forcing a memory barrier on each CPU guarantees
> that if we see the memory-barrier acknowledge, we also see any prior
> RCU read-side critical section.

And this seem reasonable to me that this would be enough to satisfy a
grace period. But the CPU moving around the rcu_read_(un)lock's around.

Are we sure that adding all these grace periods stages is better than just
biting the bullet and put in a memory barrier?

>
> > > +			rcu_try_flip_state = rcu_try_flip_idle_state;
> >
> > Finally we are back to the original state and we start the process all
> > over.
>
> Yep!
>
> > Is this analysis correct?
>
> Other than noted above, yes.
>
> > > +
> > > +/*
> > > + * Needed by dynticks, to make sure all RCU processing has finished
> > > + * when we go idle:
> >
> > Didn't we have a discussion that this is no longer true? Or was it taken
> > out of Dynamic ticks before. I don't see any users of it.

Need to kick tglx or jstultz on this.

>
> Might be safe to ditch it, then.  I was afraid that there was a patch
> out there somewhere still relying on it.
>


> >
> > OK, that's all I have on this patch (will take a bit of a break before
> > reviewing your other patches).  But I will say that RCU has grown quite
> > a bit, and is looking very good.
>
> Glad you like it, and thank you again for the careful and thorough review.

I'm scared to do the preempt portion %^O

>
> > Basically, what I'm saying is "Great work, Paul!".  This is looking
> > good. Seems that we just need a little bit better explanation for those
> > that are not up at the IQ level of you.  I can write something up after
> > this all gets finalized. Sort of a rcu-design.txt, that really tries to
> > explain it to the simpleton's like me ;-)
>
> I do greatly appreciate the compliments, especially coming from someone
> like yourself, but it is also true that I have been implementing and
> using RCU in various forms for longer than some Linux-community members
> (not many, but a few) have been alive, and programming since 1972 or so.
> Lots and lots of practice!

`72, I was 4.

>
> Hmmm...  I started programming about the same time that I started
> jogging consistently.  Never realized that before.

Well, I hope you keep doing both for a long time to come.

>
> I am thinking in terms of getting an improved discussion of RCU design and
> use out there -- after all, the fifth anniversary of RCU's addition to
> the kernel is coming right up.  This does deserve better documentation,
> especially given that for several depressing weeks near the beginning
> of 2005 I believed that a realtime-friendly RCU might not be possible.

That is definitely an accomplishment. And I know as well as you do that it
happened because of a lot of people sharing ideas. Some good, some bad,
but all helpful for heathy development!

-- Steve

