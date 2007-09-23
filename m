Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbXIWReV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbXIWReV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 13:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbXIWReN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 13:34:13 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:43947 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbXIWReL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 13:34:11 -0400
Date: Sun, 23 Sep 2007 21:38:07 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20070923173807.GA292@tv-sign.ru>
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183412.GC3819@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910183412.GC3819@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10, Paul E. McKenney wrote:
>
> Work in progress, not for inclusion.

Impressive work! a couple of random newbie's questions...

> --- linux-2.6.22-b-fixbarriers/include/linux/rcupdate.h	2007-07-19 14:02:36.000000000 -0700
> +++ linux-2.6.22-c-preemptrcu/include/linux/rcupdate.h	2007-08-22 15:21:06.000000000 -0700
>
>  extern void rcu_check_callbacks(int cpu, int user);

Also superfluously declared in rcuclassic.h and in rcupreempt.h

> --- linux-2.6.22-b-fixbarriers/include/linux/rcupreempt.h	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.22-c-preemptrcu/include/linux/rcupreempt.h	2007-08-22 15:21:06.000000000 -0700
> +
> +#define __rcu_read_lock_nesting()	(current->rcu_read_lock_nesting)

unused?

> diff -urpNa -X dontdiff linux-2.6.22-b-fixbarriers/kernel/rcupreempt.c linux-2.6.22-c-preemptrcu/kernel/rcupreempt.c
> --- linux-2.6.22-b-fixbarriers/kernel/rcupreempt.c	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.22-c-preemptrcu/kernel/rcupreempt.c	2007-08-22 15:35:19.000000000 -0700
>
> +static DEFINE_PER_CPU(struct rcu_data, rcu_data);
> +static struct rcu_ctrlblk rcu_ctrlblk = {
> +	.fliplock = SPIN_LOCK_UNLOCKED,
> +	.completed = 0,
> +};
> static DEFINE_PER_CPU(int [2], rcu_flipctr) = { 0, 0 };

Just curious, any reason why rcu_flipctr can't live in rcu_data ? Similarly,
rcu_try_flip_state can be a member of rcu_ctrlblk, it is even protected by
rcu_ctrlblk.fliplock

Isn't DEFINE_PER_CPU_SHARED_ALIGNED better for rcu_flip_flag and rcu_mb_flag?

> +void __rcu_read_lock(void)
> +{
> +	int idx;
> +	struct task_struct *me = current;
> +	int nesting;
> +
> +	nesting = ORDERED_WRT_IRQ(me->rcu_read_lock_nesting);
> +	if (nesting != 0) {
> +
> +		/* An earlier rcu_read_lock() covers us, just count it. */
> +
> +		me->rcu_read_lock_nesting = nesting + 1;
> +
> +	} else {
> +		unsigned long oldirq;
> +
> +		/*
> +		 * Disable local interrupts to prevent the grace-period
> +		 * detection state machine from seeing us half-done.
> +		 * NMIs can still occur, of course, and might themselves
> +		 * contain rcu_read_lock().
> +		 */
> +
> +		local_irq_save(oldirq);

Could you please tell more, why do we need this cli?

It can't "protect" rcu_ctrlblk.completed, and the only change which affects
the state machine is rcu_flipctr[idx]++, so I can't understand the "half-done"
above. (of course, we must disable preemption while changing rcu_flipctr).

Hmm... this was already discussed... from another message:

	> Critical portions of the GP protection happen in the scheduler-clock
	> interrupt, which is a hardirq.  For example, the .completed counter
	> is always incremented in hardirq context, and we cannot tolerate a
	> .completed increment in this code.  Allowing such an increment would
	> defeat the counter-acknowledge state in the state machine.

Still can't understand, please help! .completed could be incremented by
another CPU, why rcu_check_callbacks() running on _this_ CPU is so special?

> +
> +		/*
> +		 * Outermost nesting of rcu_read_lock(), so increment
> +		 * the current counter for the current CPU.  Use volatile
> +		 * casts to prevent the compiler from reordering.
> +		 */
> +
> +		idx = ORDERED_WRT_IRQ(rcu_ctrlblk.completed) & 0x1;
> +		smp_read_barrier_depends();  /* @@@@ might be unneeded */
> +		ORDERED_WRT_IRQ(__get_cpu_var(rcu_flipctr)[idx])++;

Isn't it "obvious" that this barrier is not needed? rcu_flipctr could be
change only by this CPU, regardless of the actual value of idx, we can't
read the "wrong" value of rcu_flipctr[idx], no?

OTOH, I can't understand how it works. With ot without local_irq_save(),
another CPU can do rcu_try_flip_idle() and increment rcu_ctrlblk.completed
at any time, we can see the old value... rcu_try_flip_waitzero() can miss us?

OK, GP_STAGES > 1, so rcu_try_flip_waitzero() will actually check both
0 and 1 lastidx's before synchronize_rcu() succeeds... I doubt very much
my understanding is correct. Apart from this why GP_STAGES > 1 ???

Well, I think this code is just too tricky for me! Will try to read again
after sleep ;)

> +static int
> +rcu_try_flip_idle(void)
> +{
> +	int cpu;
> +
> +	RCU_TRACE_ME(rcupreempt_trace_try_flip_i1);
> +	if (!rcu_pending(smp_processor_id())) {
> +		RCU_TRACE_ME(rcupreempt_trace_try_flip_ie1);
> +		return 0;
> +	}
> +
> +	/*
> +	 * Do the flip.
> +	 */
> +
> +	RCU_TRACE_ME(rcupreempt_trace_try_flip_g1);
> +	rcu_ctrlblk.completed++;  /* stands in for rcu_try_flip_g2 */
> +
> +	/*
> +	 * Need a memory barrier so that other CPUs see the new
> +	 * counter value before they see the subsequent change of all
> +	 * the rcu_flip_flag instances to rcu_flipped.
> +	 */

Why? Any code sequence which relies on that?

For example, rcu_check_callbacks does

	if (rcu_ctrlblk.completed == rdp->completed)
		rcu_try_flip();

it is possible that the timer interrupt calls rcu_check_callbacks()
exactly because rcu_pending() sees rcu_flipped, but without rmb() in
between we can see the old value of rcu_ctrlblk.completed.

This is not a problem because rcu_try_flip() needs rcu_ctrlblk.fliplock,
so rcu_try_flip() will see the new state != rcu_try_flip_idle_state, but
I can't understand any mb() in rcu_try_flip_xxx().

> +static void rcu_process_callbacks(struct softirq_action *unused)
> +{
> +	unsigned long flags;
> +	struct rcu_head *next, *list;
> +	struct rcu_data *rdp = RCU_DATA_ME();
> +
> +	spin_lock_irqsave(&rdp->lock, flags);
> +	list = rdp->donelist;
> +	if (list == NULL) {
> +		spin_unlock_irqrestore(&rdp->lock, flags);
> +		return;
> +	}

Do we really need this fastpath? It is not needed for the correctness,
and this case is very unlikely (in fact I think it is not possible:
rcu_check_callbacks() (triggers RCU_SOFTIRQ) is called with irqs disabled).

> +void fastcall call_rcu(struct rcu_head *head,
> +				void (*func)(struct rcu_head *rcu))
> +{
> +	unsigned long oldirq;
> +	struct rcu_data *rdp;
> +
> +	head->func = func;
> +	head->next = NULL;
> +	local_irq_save(oldirq);
> +	rdp = RCU_DATA_ME();
> +	spin_lock(&rdp->lock);

This looks a bit strange. Is this optimization? Why not

	spin_lock_irqsave(&rdp->lock, flags);
	rdp = RCU_DATA_ME();
	...

? RCU_DATA_ME() is cheap, but spin_lock() under local_irq_save() spins
without preemption.

Actually, why do we need rcu_data->lock ? Looks like local_irq_save()
should be enough, no? perhaps some -rt reasons ?

> +	__rcu_advance_callbacks(rdp);

Any reason this func can't do rcu_check_mb() as well?

If this is possible, can't we move the code doing "s/rcu_flipped/rcu_flip_seen/"
from __rcu_advance_callbacks() to rcu_check_mb() to unify the "acks" ?

> +void __synchronize_sched(void)
> +{
> +	cpumask_t oldmask;
> +	int cpu;
> +
> +	if (sched_getaffinity(0, &oldmask) < 0)
> +		oldmask = cpu_possible_map;
> +	for_each_online_cpu(cpu) {
> +		sched_setaffinity(0, cpumask_of_cpu(cpu));
> +		schedule();

This "schedule()" is not needed, any time sched_setaffinity() returns on another
CPU we already forced preemption of the previously active task on that CPU.

> +	}
> +	sched_setaffinity(0, oldmask);
> +}

Well, this is not correct... but doesn't matter because of the next patch.

But could you explain how it can deadlock (according to the changelog of
the next patch) ?

Thanks!

Oleg.

