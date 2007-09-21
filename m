Return-Path: <linux-kernel-owner+w=401wt.eu-S1764649AbXIUWGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764649AbXIUWGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761961AbXIUWGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:06:41 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52918 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761795AbXIUWGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:06:39 -0400
Date: Fri, 21 Sep 2007 15:06:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, bunk@kernel.org, ego@in.ibm.com, oleg@tv-sign.ru
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20070921220628.GB9059@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183412.GC3819@linux.vnet.ibm.com> <20070921144003.GC15697@goodmis.org> <20070921174653.64c15a92@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921174653.64c15a92@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 05:46:53PM +0200, Peter Zijlstra wrote:
> On Fri, 21 Sep 2007 10:40:03 -0400 Steven Rostedt <rostedt@goodmis.org>
> wrote:
>
> > On Mon, Sep 10, 2007 at 11:34:12AM -0700, Paul E. McKenney wrote:
> 
> > Can you have a pointer somewhere that explains these states. And not a
> > "it's in this paper or directory". Either have a short discription here,
> > or specify where exactly to find the information (perhaps a
> > Documentation/RCU/preemptible_states.txt?).
> > 
> > Trying to understand these states has caused me the most agony in
> > reviewing these patches.
> > 
> > > + */
> > > +
> > > +enum rcu_try_flip_states {
> > > +	rcu_try_flip_idle_state,	/* "I" */
> > > +	rcu_try_flip_waitack_state, 	/* "A" */
> > > +	rcu_try_flip_waitzero_state,	/* "Z" */
> > > +	rcu_try_flip_waitmb_state	/* "M" */
> > > +};
> 
> I thought the 4 flip states corresponded to the 4 GP stages, but now
> you confused me. It seems to indeed progress one stage for every 4 flip
> states.

Yes, four flip states per stage, and four stages per grace period:

rcu_try_flip_idle_state:	Stay here if nothing is happening.
				Flip the counter if something starts
				happening.

rcu_try_flip_waitack_state:	Wait here for all CPUs to notice that
				the counter has flipped.  This prevents
				the old set of counters from ever being
				incremented once we leave this state,
				which in turn is necessary because we
				cannot test any individual counter for
				zero -- we can only check the sum.

rcu_try_flip_waitzero_state:	Wait here for the sum of the old
				per-CPU counters to reach zero.

rcu_try_flip_waitmb_state:	Wait here for each of the other
				CPUs to execute a memory barrier.
				This is necessary to ensure that
				these other CPUs really have finished
				executing their RCU read-side
				critical sections, despite their
				CPUs wildly reordering memory.

				This state 

> Hmm, now I have to puzzle how these 4 stages are required by the lock
> and unlock magic.

They are needed to allow memory barriers to be removed from
rcu_read_lock(), to allow for the fact that the stages mean that
grace-period boundaries are now fuzzy, as well as to account for the
fact that each CPU now has its own callback queue.  (Aside: classic RCU
doesn't have memory barriers -- or anything else -- in rcu_read_lock()
and rcu_read_unlock(), but from an implementation viewpoint, the read-side
critical section extends forwards and backwards to the next/previous
context switches, which do have lots of memory barriers.)

Taking the reasons for stages one at a time:

1.	The first stage is needed for generic RCU.  Everyone must
	complete any pre-existing RCU read-side critical sections
	before the grace period can be permitted to complete.  This
	stage corresponds to the "waitlist" and "waittail" in earlier
	RCU implementations.

2.	An additional stage is needed due to the fact that memory reordering
	can cause an RCU read-side critical section's rcu_dereference()
	to be executed before the rcu_read_lock() -- no memory barriers!

	This can result in the following sequence of events:

	o	rcu_dereference() from CPU 0.

	o	list_del_rcu() from CPU 1.

	o	call_rcu() from CPU 1.

	o	counter flip from CPU 2.

	o	rcu_read_lock() from CPU 0 (delayed due to memory reordering).

		CPU 0 increments the new counter, not the old one that
		its rcu_dereference() is associated with.

	o	All CPUs acknowledge the counter flip.

	o	CPU 2 discovers that the old counters sum to zero (because
		CPU 0 has incremented its new counter).

	o	All CPUs do their memory barriers.

	o	CPU 1's callback is invoked, destroying the memory still
		being used by CPU 0.

	An additional pass through the state machine fixes this problem.

	Note that the read-after-write misordering can happen on x86,
	as well as on s390.

3.	An additional stage is also needed due to the fact that each CPU
	has its own set of callback queues.  This means that callbacks
	that were registered quite some time after the most recent counter
	flip can make it into the current round of the state machine,
	as follows:

	o	CPU 0 flips the counter.

	o	CPU 1 does an rcu_read_lock() followed by an rcu_dereference().
		CPU 1 of course uses the new value of the counter.

	o	CPU 2 does a list_del_rcu() on the element that CPU 1
		did the rcu_dereference on.

	o	CPU 2 does a call_rcu(), placing the callback on
		its local queue.

	o	CPU 2 gets its scheduling-clock interrupt, and acknowledges
		the counter flip, also moving its "next" list (which
		contains the new callback) to the "wait" list.

	o	The old counters sum to zero, and everyone does a memory
		barrier, and the callback is invoked.  Too bad that CPU 0
		is still using the data element just freed!

	(And yes, I do understand that this scenario is incompatible
	with the previous scenario.  But the point of these scenarios
	is to demonstrate that a given effect can result in failure,
	not to show all possible misfortunes that the effect can cause.
	If you wish to try to convince me that the two causes underlying
	these symptoms cannot be combined to create a failure spanning
	two full flip intervals, then the task before you is to prove
	that there is no such scenario.)

	This scenario can happen even on sequentially consistent
	machines.

4.	An additional stage is needed due to the fact that different
	CPUs can disagree as to when the counter flip happened.  This
	effect is in some way similar to #3, but can (and did) happen
	even when there is only one global callback queue.  

	I believe that this can happen even on sequentially consistent
	machines, but am not 100% certain of this.

So, four mechanisms for going bad mapped to four states in the grace-period
pipeline.  It is quite possible that a more-complex state machine would
require fewer stages, but then again it might not end up being any faster
overall.  :-/  It is also quite possible that one or another of the
additional stages covers more than one of the above mechanisms.  So,
we know just from the above scenarios that at least two stages are
required, and the most that they can possibly require is four stages.
I have looked very hard for other underlying sources of badness, and
am quite sure that I have them covered (famous last words).

I will rerun with GP_STAGES==3 on POWER to double-check -- it is entirely
possible that the last such run preceded some bug removal.

On the other hand, there are most definitely relatively straightforward
ways to speed things up on uniprocessor machines, for example,
skipping the acknowledgement and memory-barrier states, short-circuiting
synchronize_rcu() and friends, and so on.  But I need to avoid premature
optimization here -- one thing at a time.

> > > +/*
> > > + * Return the number of RCU batches processed thus far.  Useful for debug
> > > + * and statistics.  The _bh variant is identical to straight RCU.
> > > + */
> > 
> > If they are identical, then why the separation?
> 
> I guess a smaller RCU domain makes for quicker grace periods.

We have to remain API-compatible with classic RCU, where the separate
grace-period types are absolutely required if the networking stack is
to hold up against certain types of DOS attacks.  Networking uses
call_rcu_bh(), which has quiescent states at any point in the code
that interrupts are enabled.

It might well be possible to fuse the _bh variant into the classic variant
for CONFIG_PREEMPT (as opposed to CONFIG_PREEMPT_RT) kernels, but as far
as I know, no one has tried this.  And there is little motivation to try,
from what I can see.

> > > +void __rcu_read_lock(void)
> > > +{
> > > +	int idx;
> > > +	struct task_struct *me = current;
> > 
> > Nitpick, but other places in the kernel usually use "t" or "p" as a
> > variable to assign current to.  It's just that "me" thows me off a
> > little while reviewing this.  But this is just a nitpick, so do as you
> > will.
> 
> struct task_struct *curr = current;
> 
> is also not uncommon.

OK, good point either way.

> > > +	int nesting;
> > > +
> > > +	nesting = ORDERED_WRT_IRQ(me->rcu_read_lock_nesting);
> > > +	if (nesting != 0) {
> > > +
> > > +		/* An earlier rcu_read_lock() covers us, just count it. */
> > > +
> > > +		me->rcu_read_lock_nesting = nesting + 1;
> > > +
> > > +	} else {
> > > +		unsigned long oldirq;
> > 
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
> This is also my understanding, but I think this disable is an
> 'optimization' in that it avoids the regular IRQs from jumping through
> these hoops outlined below.

Critical portions of the GP protection happen in the scheduler-clock
interrupt, which is a hardirq.  For example, the .completed counter
is always incremented in hardirq context, and we cannot tolerate a
.completed increment in this code.  Allowing such an increment would
defeat the counter-acknowledge state in the state machine.

There are ways to avoid the interrupt disabling, but all the ones
that I am aware of thus far have grace-period-latency consequences.

> > > +
> > > +		/*
> > > +		 * Outermost nesting of rcu_read_lock(), so increment
> > > +		 * the current counter for the current CPU.  Use volatile
> > > +		 * casts to prevent the compiler from reordering.
> > > +		 */
> > > +
> > > +		idx = ORDERED_WRT_IRQ(rcu_ctrlblk.completed) & 0x1;
> > > +		smp_read_barrier_depends();  /* @@@@ might be unneeded */
> > > +		ORDERED_WRT_IRQ(__get_cpu_var(rcu_flipctr)[idx])++;
> > > +
> > > +		/*
> > > +		 * Now that the per-CPU counter has been incremented, we
> > > +		 * are protected from races with rcu_read_lock() invoked
> > > +		 * from NMI handlers on this CPU.  We can therefore safely
> > > +		 * increment the nesting counter, relieving further NMIs
> > > +		 * of the need to increment the per-CPU counter.
> > > +		 */
> > > +
> > > +		ORDERED_WRT_IRQ(me->rcu_read_lock_nesting) = nesting + 1;
> > > +
> > > +		/*
> > > +		 * Now that we have preventing any NMIs from storing
> > > +		 * to the ->rcu_flipctr_idx, we can safely use it to
> > > +		 * remember which counter to decrement in the matching
> > > +		 * rcu_read_unlock().
> > > +		 */
> > > +
> > > +		ORDERED_WRT_IRQ(me->rcu_flipctr_idx) = idx;
> > > +		local_irq_restore(oldirq);
> > > +	}
> > > +}
> 
> > > +/*
> > > + * Attempt a single flip of the counters.  Remember, a single flip does
> > > + * -not- constitute a grace period.  Instead, the interval between
> > > + * at least three consecutive flips is a grace period.
> > > + *
> > > + * If anyone is nuts enough to run this CONFIG_PREEMPT_RCU implementation
> > 
> > Oh, come now! It's not "nuts" to use this ;-)

Hey!!!  If it wasn't nuts, I probably wouldn't be working on it!!!  ;-)

> > > + * on a large SMP, they might want to use a hierarchical organization of
> > > + * the per-CPU-counter pairs.
> > > + */
> 
> Its the large SMP case that's nuts, and on that I have to agree with
> Paul, its not really large SMP friendly.

Yeah, the current implementation of synchronize_sched() is a really bad
idea on a 4096-CPU system, and probably much smaller.  The base RCU
implementation is now probably good to several tens of CPUs, perhaps
even to a couple hundred.  In contrast, the implementation currently
in -rt might start choking pretty badly much earlier due to the single
global callback queue.

						Thanx, Paul
