Return-Path: <linux-kernel-owner+w=401wt.eu-S1760989AbXIUPrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760989AbXIUPrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 11:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759331AbXIUPrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 11:47:03 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:48906 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757815AbXIUPrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 11:47:00 -0400
Date: Fri, 21 Sep 2007 17:46:53 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, bunk@kernel.org, ego@in.ibm.com, oleg@tv-sign.ru
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20070921174653.64c15a92@twins>
In-Reply-To: <20070921144003.GC15697@goodmis.org>
References: <20070910183004.GA3299@linux.vnet.ibm.com>
	<20070910183412.GC3819@linux.vnet.ibm.com>
	<20070921144003.GC15697@goodmis.org>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 10:40:03 -0400 Steven Rostedt <rostedt@goodmis.org>
wrote:

> On Mon, Sep 10, 2007 at 11:34:12AM -0700, Paul E. McKenney wrote:


> Can you have a pointer somewhere that explains these states. And not a
> "it's in this paper or directory". Either have a short discription here,
> or specify where exactly to find the information (perhaps a
> Documentation/RCU/preemptible_states.txt?).
> 
> Trying to understand these states has caused me the most agony in
> reviewing these patches.
> 
> > + */
> > +
> > +enum rcu_try_flip_states {
> > +	rcu_try_flip_idle_state,	/* "I" */
> > +	rcu_try_flip_waitack_state, 	/* "A" */
> > +	rcu_try_flip_waitzero_state,	/* "Z" */
> > +	rcu_try_flip_waitmb_state	/* "M" */
> > +};

I thought the 4 flip states corresponded to the 4 GP stages, but now
you confused me. It seems to indeed progress one stage for every 4 flip
states.

Hmm, now I have to puzzle how these 4 stages are required by the lock
and unlock magic.

> > +/*
> > + * Return the number of RCU batches processed thus far.  Useful for debug
> > + * and statistics.  The _bh variant is identical to straight RCU.
> > + */
> 
> If they are identical, then why the separation?

I guess a smaller RCU domain makes for quicker grace periods.
 
> > +void __rcu_read_lock(void)
> > +{
> > +	int idx;
> > +	struct task_struct *me = current;
> 
> Nitpick, but other places in the kernel usually use "t" or "p" as a
> variable to assign current to.  It's just that "me" thows me off a
> little while reviewing this.  But this is just a nitpick, so do as you
> will.

struct task_struct *curr = current;

is also not uncommon.
 
> > +	int nesting;
> > +
> > +	nesting = ORDERED_WRT_IRQ(me->rcu_read_lock_nesting);
> > +	if (nesting != 0) {
> > +
> > +		/* An earlier rcu_read_lock() covers us, just count it. */
> > +
> > +		me->rcu_read_lock_nesting = nesting + 1;
> > +
> > +	} else {
> > +		unsigned long oldirq;
> 
> > +
> > +		/*
> > +		 * Disable local interrupts to prevent the grace-period
> > +		 * detection state machine from seeing us half-done.
> > +		 * NMIs can still occur, of course, and might themselves
> > +		 * contain rcu_read_lock().
> > +		 */
> > +
> > +		local_irq_save(oldirq);
> 
> Isn't the GP detection done via a tasklet/softirq. So wouldn't a
> local_bh_disable be sufficient here? You already cover NMIs, which would
> also handle normal interrupts.

This is also my understanding, but I think this disable is an
'optimization' in that it avoids the regular IRQs from jumping through
these hoops outlined below.

> > +
> > +		/*
> > +		 * Outermost nesting of rcu_read_lock(), so increment
> > +		 * the current counter for the current CPU.  Use volatile
> > +		 * casts to prevent the compiler from reordering.
> > +		 */
> > +
> > +		idx = ORDERED_WRT_IRQ(rcu_ctrlblk.completed) & 0x1;
> > +		smp_read_barrier_depends();  /* @@@@ might be unneeded */
> > +		ORDERED_WRT_IRQ(__get_cpu_var(rcu_flipctr)[idx])++;
> > +
> > +		/*
> > +		 * Now that the per-CPU counter has been incremented, we
> > +		 * are protected from races with rcu_read_lock() invoked
> > +		 * from NMI handlers on this CPU.  We can therefore safely
> > +		 * increment the nesting counter, relieving further NMIs
> > +		 * of the need to increment the per-CPU counter.
> > +		 */
> > +
> > +		ORDERED_WRT_IRQ(me->rcu_read_lock_nesting) = nesting + 1;
> > +
> > +		/*
> > +		 * Now that we have preventing any NMIs from storing
> > +		 * to the ->rcu_flipctr_idx, we can safely use it to
> > +		 * remember which counter to decrement in the matching
> > +		 * rcu_read_unlock().
> > +		 */
> > +
> > +		ORDERED_WRT_IRQ(me->rcu_flipctr_idx) = idx;
> > +		local_irq_restore(oldirq);
> > +	}
> > +}

> > +/*
> > + * Attempt a single flip of the counters.  Remember, a single flip does
> > + * -not- constitute a grace period.  Instead, the interval between
> > + * at least three consecutive flips is a grace period.
> > + *
> > + * If anyone is nuts enough to run this CONFIG_PREEMPT_RCU implementation
> 
> Oh, come now! It's not "nuts" to use this ;-)
> 
> > + * on a large SMP, they might want to use a hierarchical organization of
> > + * the per-CPU-counter pairs.
> > + */

Its the large SMP case that's nuts, and on that I have to agree with
Paul, its not really large SMP friendly.


