Return-Path: <linux-kernel-owner+w=401wt.eu-S1760210AbXIUPVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210AbXIUPVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 11:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbXIUPUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 11:20:55 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:62943 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbXIUPUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 11:20:54 -0400
Date: Fri, 21 Sep 2007 11:20:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, oleg@tv-sign.ru, srostedt@redhat.com
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20070921152048.GF15697@goodmis.org>
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183412.GC3819@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910183412.GC3819@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 11:34:12AM -0700, Paul E. McKenney wrote:
> +
> +/*
> + * PREEMPT_RCU data structures.
> + */
> +
> +#define GP_STAGES 4
> +struct rcu_data {
> +	spinlock_t	lock;		/* Protect rcu_data fields. */
> +	long		completed;	/* Number of last completed batch. */
> +	int		waitlistcount;
> +	struct tasklet_struct rcu_tasklet;
> +	struct rcu_head *nextlist;
> +	struct rcu_head **nexttail;
> +	struct rcu_head *waitlist[GP_STAGES];
> +	struct rcu_head **waittail[GP_STAGES];
> +	struct rcu_head *donelist;
> +	struct rcu_head **donetail;
> +#ifdef CONFIG_RCU_TRACE
> +	struct rcupreempt_trace trace;
> +#endif /* #ifdef CONFIG_RCU_TRACE */
> +};
> +struct rcu_ctrlblk {
> +	spinlock_t	fliplock;	/* Protect state-machine transitions. */
> +	long		completed;	/* Number of last completed batch. */
> +};
> +static DEFINE_PER_CPU(struct rcu_data, rcu_data);
> +static struct rcu_ctrlblk rcu_ctrlblk = {
> +	.fliplock = SPIN_LOCK_UNLOCKED,
> +	.completed = 0,
> +};
> +static DEFINE_PER_CPU(int [2], rcu_flipctr) = { 0, 0 };
> +
> +/*
> + * States for rcu_try_flip() and friends.
> + */
> +
> +enum rcu_try_flip_states {
> +	rcu_try_flip_idle_state,	/* "I" */
> +	rcu_try_flip_waitack_state, 	/* "A" */
> +	rcu_try_flip_waitzero_state,	/* "Z" */
> +	rcu_try_flip_waitmb_state	/* "M" */
> +};
> +static enum rcu_try_flip_states rcu_try_flip_state = rcu_try_flip_idle_state;
> +#ifdef CONFIG_RCU_TRACE
> +static char *rcu_try_flip_state_names[] =
> +	{ "idle", "waitack", "waitzero", "waitmb" };
> +#endif /* #ifdef CONFIG_RCU_TRACE */

[snip]

> +/*
> + * If a global counter flip has occurred since the last time that we
> + * advanced callbacks, advance them.  Hardware interrupts must be
> + * disabled when calling this function.
> + */
> +static void __rcu_advance_callbacks(struct rcu_data *rdp)
> +{
> +	int cpu;
> +	int i;
> +	int wlc = 0;
> +
> +	if (rdp->completed != rcu_ctrlblk.completed) {
> +		if (rdp->waitlist[GP_STAGES - 1] != NULL) {
> +			*rdp->donetail = rdp->waitlist[GP_STAGES - 1];
> +			rdp->donetail = rdp->waittail[GP_STAGES - 1];
> +			RCU_TRACE_RDP(rcupreempt_trace_move2done, rdp);
> +		}
> +		for (i = GP_STAGES - 2; i >= 0; i--) {
> +			if (rdp->waitlist[i] != NULL) {
> +				rdp->waitlist[i + 1] = rdp->waitlist[i];
> +				rdp->waittail[i + 1] = rdp->waittail[i];
> +				wlc++;
> +			} else {
> +				rdp->waitlist[i + 1] = NULL;
> +				rdp->waittail[i + 1] =
> +					&rdp->waitlist[i + 1];
> +			}
> +		}
> +		if (rdp->nextlist != NULL) {
> +			rdp->waitlist[0] = rdp->nextlist;
> +			rdp->waittail[0] = rdp->nexttail;
> +			wlc++;
> +			rdp->nextlist = NULL;
> +			rdp->nexttail = &rdp->nextlist;
> +			RCU_TRACE_RDP(rcupreempt_trace_move2wait, rdp);
> +		} else {
> +			rdp->waitlist[0] = NULL;
> +			rdp->waittail[0] = &rdp->waitlist[0];
> +		}
> +		rdp->waitlistcount = wlc;
> +		rdp->completed = rcu_ctrlblk.completed;
> +	}
> +
> +	/*
> +	 * Check to see if this CPU needs to report that it has seen
> +	 * the most recent counter flip, thereby declaring that all
> +	 * subsequent rcu_read_lock() invocations will respect this flip.
> +	 */
> +
> +	cpu = raw_smp_processor_id();
> +	if (per_cpu(rcu_flip_flag, cpu) == rcu_flipped) {
> +		smp_mb();  /* Subsequent counter accesses must see new value */
> +		per_cpu(rcu_flip_flag, cpu) = rcu_flip_seen;
> +		smp_mb();  /* Subsequent RCU read-side critical sections */
> +			   /*  seen -after- acknowledgement. */
> +	}
> +}

[snip]

> +/*
> + * Attempt a single flip of the counters.  Remember, a single flip does
> + * -not- constitute a grace period.  Instead, the interval between
> + * at least three consecutive flips is a grace period.
> + *
> + * If anyone is nuts enough to run this CONFIG_PREEMPT_RCU implementation
> + * on a large SMP, they might want to use a hierarchical organization of
> + * the per-CPU-counter pairs.
> + */
> +static void rcu_try_flip(void)
> +{
> +	unsigned long oldirq;
> +
> +	RCU_TRACE_ME(rcupreempt_trace_try_flip_1);
> +	if (unlikely(!spin_trylock_irqsave(&rcu_ctrlblk.fliplock, oldirq))) {
> +		RCU_TRACE_ME(rcupreempt_trace_try_flip_e1);
> +		return;
> +	}
> +
> +	/*
> +	 * Take the next transition(s) through the RCU grace-period
> +	 * flip-counter state machine.
> +	 */
> +
> +	switch (rcu_try_flip_state) {
> +	case rcu_try_flip_idle_state:
> +		if (rcu_try_flip_idle())
> +			rcu_try_flip_state = rcu_try_flip_waitack_state;
> +		break;
> +	case rcu_try_flip_waitack_state:
> +		if (rcu_try_flip_waitack())
> +			rcu_try_flip_state = rcu_try_flip_waitzero_state;
> +		break;
> +	case rcu_try_flip_waitzero_state:
> +		if (rcu_try_flip_waitzero())
> +			rcu_try_flip_state = rcu_try_flip_waitmb_state;
> +		break;
> +	case rcu_try_flip_waitmb_state:
> +		if (rcu_try_flip_waitmb())
> +			rcu_try_flip_state = rcu_try_flip_idle_state;
> +	}
> +	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, oldirq);
> +}

Paul,

Looking further into this, I still think this is a bit of overkill. We
go through 20 states from call_rcu to list->func().

On call_rcu we put our stuff on the next list. Before we move stuff from
next to wait, we need to go through 4 states. So we have

next -> 4 states -> wait[0] -> 4 states -> wait[1] -> 4 states ->
wait[2] -> 4 states -> wait[3] -> 4 states -> done.

That's 20 states that we go through from the time we add our function to
the list to the time it actually gets called. Do we really need the 4
wait lists?

Seems a bit overkill to me.

What am I missing?

-- Steve

