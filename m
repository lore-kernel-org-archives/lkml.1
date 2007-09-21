Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbXIUW5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbXIUW5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764073AbXIUWpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:45:09 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50103 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932630AbXIUWpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:45:06 -0400
Date: Fri, 21 Sep 2007 15:44:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, bunk@kernel.org, ego@in.ibm.com, oleg@tv-sign.ru
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20070921224459.GD9059@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183412.GC3819@linux.vnet.ibm.com> <20070921144003.GC15697@goodmis.org> <20070921174653.64c15a92@twins> <20070921223112.GG15697@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921223112.GG15697@goodmis.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 06:31:12PM -0400, Steven Rostedt wrote:
> On Fri, Sep 21, 2007 at 05:46:53PM +0200, Peter Zijlstra wrote:
> > On Fri, 21 Sep 2007 10:40:03 -0400 Steven Rostedt <rostedt@goodmis.org>
> > wrote:
> > 
> > > On Mon, Sep 10, 2007 at 11:34:12AM -0700, Paul E. McKenney wrote:
> > 
> > 
> > > Can you have a pointer somewhere that explains these states. And not a
> > > "it's in this paper or directory". Either have a short discription here,
> > > or specify where exactly to find the information (perhaps a
> > > Documentation/RCU/preemptible_states.txt?).
> > > 
> > > Trying to understand these states has caused me the most agony in
> > > reviewing these patches.
> > > 
> > > > + */
> > > > +
> > > > +enum rcu_try_flip_states {
> > > > +	rcu_try_flip_idle_state,	/* "I" */
> > > > +	rcu_try_flip_waitack_state, 	/* "A" */
> > > > +	rcu_try_flip_waitzero_state,	/* "Z" */
> > > > +	rcu_try_flip_waitmb_state	/* "M" */
> > > > +};
> > 
> > I thought the 4 flip states corresponded to the 4 GP stages, but now
> > you confused me. It seems to indeed progress one stage for every 4 flip
> > states.
> 
> I'm still confused ;-)

If you do a synchronize_rcu() it might well have to wait through the
following sequence of states:

Stage 0: (might have to wait through part of this to get out of "next" queue)
	rcu_try_flip_idle_state,	/* "I" */
	rcu_try_flip_waitack_state, 	/* "A" */
	rcu_try_flip_waitzero_state,	/* "Z" */
	rcu_try_flip_waitmb_state	/* "M" */
Stage 1:
	rcu_try_flip_idle_state,	/* "I" */
	rcu_try_flip_waitack_state, 	/* "A" */
	rcu_try_flip_waitzero_state,	/* "Z" */
	rcu_try_flip_waitmb_state	/* "M" */
Stage 2:
	rcu_try_flip_idle_state,	/* "I" */
	rcu_try_flip_waitack_state, 	/* "A" */
	rcu_try_flip_waitzero_state,	/* "Z" */
	rcu_try_flip_waitmb_state	/* "M" */
Stage 3:
	rcu_try_flip_idle_state,	/* "I" */
	rcu_try_flip_waitack_state, 	/* "A" */
	rcu_try_flip_waitzero_state,	/* "Z" */
	rcu_try_flip_waitmb_state	/* "M" */
Stage 4:
	rcu_try_flip_idle_state,	/* "I" */
	rcu_try_flip_waitack_state, 	/* "A" */
	rcu_try_flip_waitzero_state,	/* "Z" */
	rcu_try_flip_waitmb_state	/* "M" */

So yes, grace periods do indeed have some latency.

> > Hmm, now I have to puzzle how these 4 stages are required by the lock
> > and unlock magic.
> > 
> > > > +/*
> > > > + * Return the number of RCU batches processed thus far.  Useful for debug
> > > > + * and statistics.  The _bh variant is identical to straight RCU.
> > > > + */
> > > 
> > > If they are identical, then why the separation?
> > 
> > I guess a smaller RCU domain makes for quicker grace periods.
> 
> No, I mean that both the rcu_batches_completed and
> rcu_batches_completed_bh are identical. Perhaps we can just put in a
> 
> #define rcu_batches_completed_bh rcu_batches_completed
> 
> in rcupreempt.h.  In rcuclassic, they are different. But no need to have
> two identical functions in the preempt version. A macro should do.

Ah!!!  Good point, #define does make sense here.

> > > > +void __rcu_read_lock(void)
> > > > +{
> > > > +	int idx;
> > > > +	struct task_struct *me = current;
> > > 
> > > Nitpick, but other places in the kernel usually use "t" or "p" as a
> > > variable to assign current to.  It's just that "me" thows me off a
> > > little while reviewing this.  But this is just a nitpick, so do as you
> > > will.
> > 
> > struct task_struct *curr = current;
> > 
> > is also not uncommon.
> 
> True, but the "me" confused me. Since that task struct is not me ;-)

Well, who is it, then?  ;-)

> > > > +	int nesting;
> > > > +
> > > > +	nesting = ORDERED_WRT_IRQ(me->rcu_read_lock_nesting);
> > > > +	if (nesting != 0) {
> > > > +
> > > > +		/* An earlier rcu_read_lock() covers us, just count it. */
> > > > +
> > > > +		me->rcu_read_lock_nesting = nesting + 1;
> > > > +
> > > > +	} else {
> > > > +		unsigned long oldirq;
> > > 
> > > > +
> > > > +		/*
> > > > +		 * Disable local interrupts to prevent the grace-period
> > > > +		 * detection state machine from seeing us half-done.
> > > > +		 * NMIs can still occur, of course, and might themselves
> > > > +		 * contain rcu_read_lock().
> > > > +		 */
> > > > +
> > > > +		local_irq_save(oldirq);
> > > 
> > > Isn't the GP detection done via a tasklet/softirq. So wouldn't a
> > > local_bh_disable be sufficient here? You already cover NMIs, which would
> > > also handle normal interrupts.
> > 
> > This is also my understanding, but I think this disable is an
> > 'optimization' in that it avoids the regular IRQs from jumping through
> > these hoops outlined below.
> 
> But isn't disabling irqs slower than doing a local_bh_disable? So the
> majority of times (where irqs will not happen) we have this overhead.

The current code absolutely must exclude the scheduling-clock hardirq
handler.

> > > > +		/*
> > > > +		 * Outermost nesting of rcu_read_lock(), so increment
> > > > +		 * the current counter for the current CPU.  Use volatile
> > > > +		 * casts to prevent the compiler from reordering.
> > > > +		 */
> > > > +
> > > > +		idx = ORDERED_WRT_IRQ(rcu_ctrlblk.completed) & 0x1;
> > > > +		smp_read_barrier_depends();  /* @@@@ might be unneeded */
> > > > +		ORDERED_WRT_IRQ(__get_cpu_var(rcu_flipctr)[idx])++;
> > > > +
> > > > +		/*
> > > > +		 * Now that the per-CPU counter has been incremented, we
> > > > +		 * are protected from races with rcu_read_lock() invoked
> > > > +		 * from NMI handlers on this CPU.  We can therefore safely
> > > > +		 * increment the nesting counter, relieving further NMIs
> > > > +		 * of the need to increment the per-CPU counter.
> > > > +		 */
> > > > +
> > > > +		ORDERED_WRT_IRQ(me->rcu_read_lock_nesting) = nesting + 1;
> > > > +
> > > > +		/*
> > > > +		 * Now that we have preventing any NMIs from storing
> > > > +		 * to the ->rcu_flipctr_idx, we can safely use it to
> > > > +		 * remember which counter to decrement in the matching
> > > > +		 * rcu_read_unlock().
> > > > +		 */
> > > > +
> > > > +		ORDERED_WRT_IRQ(me->rcu_flipctr_idx) = idx;
> > > > +		local_irq_restore(oldirq);
> > > > +	}
> > > > +}
> > 
> > > > +/*
> > > > + * Attempt a single flip of the counters.  Remember, a single flip does
> > > > + * -not- constitute a grace period.  Instead, the interval between
> > > > + * at least three consecutive flips is a grace period.
> > > > + *
> > > > + * If anyone is nuts enough to run this CONFIG_PREEMPT_RCU implementation
> > > 
> > > Oh, come now! It's not "nuts" to use this ;-)
> > > 
> > > > + * on a large SMP, they might want to use a hierarchical organization of
> > > > + * the per-CPU-counter pairs.
> > > > + */
> > 
> > Its the large SMP case that's nuts, and on that I have to agree with
> > Paul, its not really large SMP friendly.
> 
> Hmm, that could be true. But on large SMP systems, you usually have a
> large amounts of memory, so hopefully a really long synchronize_rcu
> would not be a problem.

Somewhere in the range from 64 to a few hundred CPUs, the global lock
protecting the try_flip state machine would start sucking air pretty
badly.  But the real problem is synchronize_sched(), which loops through
all the CPUs --  this would likely cause problems at a few tens of
CPUs, perhaps as early as 10-20.

						Thanx, Paul
