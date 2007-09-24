Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbXIXAPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbXIXAPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 20:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbXIXAPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 20:15:19 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43505 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525AbXIXAPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 20:15:16 -0400
Date: Sun, 23 Sep 2007 17:15:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20070924001509.GG11123@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183412.GC3819@linux.vnet.ibm.com> <20070923173807.GA292@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070923173807.GA292@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2007 at 09:38:07PM +0400, Oleg Nesterov wrote:
> On 09/10, Paul E. McKenney wrote:
> >
> > Work in progress, not for inclusion.
> 
> Impressive work! a couple of random newbie's questions...

Thank you for the kind words, and most especially for the careful review!!!

And Oleg, I don't think you qualify as a newbie anymore.  ;-)

> > --- linux-2.6.22-b-fixbarriers/include/linux/rcupdate.h	2007-07-19 14:02:36.000000000 -0700
> > +++ linux-2.6.22-c-preemptrcu/include/linux/rcupdate.h	2007-08-22 15:21:06.000000000 -0700
> >
> >  extern void rcu_check_callbacks(int cpu, int user);
> 
> Also superfluously declared in rcuclassic.h and in rcupreempt.h

Definitely are two of them in rcupdate.h, good eyes!  The ones in
rcuclassic.h and rcupreempt.h, by the time all the patches are
applied, are for rcu_check_callbacks_rt().  However, this, along
with the other _rt() cross-calls from rcuclassic.c to rcupreempt.c,
will go away when the merge with upcoming hotplug patches is complete.

> > --- linux-2.6.22-b-fixbarriers/include/linux/rcupreempt.h	1969-12-31 16:00:00.000000000 -0800
> > +++ linux-2.6.22-c-preemptrcu/include/linux/rcupreempt.h	2007-08-22 15:21:06.000000000 -0700
> > +
> > +#define __rcu_read_lock_nesting()	(current->rcu_read_lock_nesting)
> 
> unused?

It would seem so!  Will remove it.

> > diff -urpNa -X dontdiff linux-2.6.22-b-fixbarriers/kernel/rcupreempt.c linux-2.6.22-c-preemptrcu/kernel/rcupreempt.c
> > --- linux-2.6.22-b-fixbarriers/kernel/rcupreempt.c	1969-12-31 16:00:00.000000000 -0800
> > +++ linux-2.6.22-c-preemptrcu/kernel/rcupreempt.c	2007-08-22 15:35:19.000000000 -0700
> >
> > +static DEFINE_PER_CPU(struct rcu_data, rcu_data);
> > +static struct rcu_ctrlblk rcu_ctrlblk = {
> > +	.fliplock = SPIN_LOCK_UNLOCKED,
> > +	.completed = 0,
> > +};
> > static DEFINE_PER_CPU(int [2], rcu_flipctr) = { 0, 0 };
> 
> Just curious, any reason why rcu_flipctr can't live in rcu_data ? Similarly,
> rcu_try_flip_state can be a member of rcu_ctrlblk, it is even protected by
> rcu_ctrlblk.fliplock

In the case of rcu_flipctr, this is historical -- the implementation in
-rt has only one rcu_data, rather than one per CPU.  I cannot think of
a problem with placing it in rcu_data right off-hand, will look it over
carefully and see.

Good point on rcu_try_flip_state!!!

> Isn't DEFINE_PER_CPU_SHARED_ALIGNED better for rcu_flip_flag and rcu_mb_flag?

Looks like it to me, thank you for the tip!

Hmmm...  Why not the same for rcu_data?  I guess because there is
very little sharing?  The only example thus far of sharing would be
if rcu_flipctr were to be moved into rcu_data (if an RCU read-side
critical section were preempted and then started on some other CPU),
though I will need to check more carefully.

Of course, if we start having CPUs access each others' rcu_data structures
to make RCU more power-friendly in dynticks situations, then maybe there
would be more reason to use DEFINE_PER_CPU_SHARED_ALIGNED for rcu_data.

Thoughts?

> > +void __rcu_read_lock(void)
> > +{
> > +	int idx;
> > +	struct task_struct *me = current;
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
> Could you please tell more, why do we need this cli?
> 
> It can't "protect" rcu_ctrlblk.completed, and the only change which affects
> the state machine is rcu_flipctr[idx]++, so I can't understand the "half-done"
> above. (of course, we must disable preemption while changing rcu_flipctr).
> 
> Hmm... this was already discussed... from another message:
> 
> 	> Critical portions of the GP protection happen in the scheduler-clock
> 	> interrupt, which is a hardirq.  For example, the .completed counter
> 	> is always incremented in hardirq context, and we cannot tolerate a
> 	> .completed increment in this code.  Allowing such an increment would
> 	> defeat the counter-acknowledge state in the state machine.
> 
> Still can't understand, please help! .completed could be incremented by
> another CPU, why rcu_check_callbacks() running on _this_ CPU is so special?

Yeah, I guess my explanation -was- a bit lacking...  When I re-read it, it
didn't even help -me- much!  ;-)

I am putting together better documentation, but in the meantime, let me
try again...

	The problem is not with .completed being incremented, but only
	by it (1) being incremented (presumably by some other CPU and
	then (2) having this CPU get a scheduling-clock interrupt, which
	then causes this CPU to prematurely update the rcu_flip_flag.
	This is a problem, because updating rcu_flip_flag is making a
	promise that you won't ever again increment the "old" counter set
	(at least not until the next counter flip).  If the scheduling
	clock interrupt were to happen between the time that we pick
	up the .completed field and the time that we increment our
	counter, we will have broken that promise, and that could cause
	someone to prematurely declare the grace period to be finished
	(as in before our RCU read-side critical section completes).
	The problem occurs if we end up incrementing our counter just
	after the grace-period state machine has found the sum of the
	now-old counters to be zero.  (This probably requires a diagram,
	and one is in the works.)

	But that is not the only reason for the cli...

	The second reason is that cli prohibits preemption.  If we were
	preempted during this code sequence, we might end up running on
	some other CPU, but still having a reference to the original
	CPU's counter.  If the original CPU happened to be doing another
	rcu_read_lock() or rcu_read_unlock() just as we started running,
	then someone's increment or decrement might get lost.  We could
	of course prevent with with preempt_disable() instead of cli.

	There might well be another reason or two, but that is what
	I can come up with at the moment.  ;-)

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
> 
> Isn't it "obvious" that this barrier is not needed? rcu_flipctr could be
> change only by this CPU, regardless of the actual value of idx, we can't
> read the "wrong" value of rcu_flipctr[idx], no?

I suspect that you are correct.

> OTOH, I can't understand how it works. With ot without local_irq_save(),
> another CPU can do rcu_try_flip_idle() and increment rcu_ctrlblk.completed
> at any time, we can see the old value... rcu_try_flip_waitzero() can miss us?
> 
> OK, GP_STAGES > 1, so rcu_try_flip_waitzero() will actually check both
> 0 and 1 lastidx's before synchronize_rcu() succeeds... I doubt very much
> my understanding is correct. Apart from this why GP_STAGES > 1 ???

This is indeed one reason.  I am adding you to my list of people to send
early versions of the document to.

> Well, I think this code is just too tricky for me! Will try to read again
> after sleep ;)

Yeah, it needs better documentation...

> > +static int
> > +rcu_try_flip_idle(void)
> > +{
> > +	int cpu;
> > +
> > +	RCU_TRACE_ME(rcupreempt_trace_try_flip_i1);
> > +	if (!rcu_pending(smp_processor_id())) {
> > +		RCU_TRACE_ME(rcupreempt_trace_try_flip_ie1);
> > +		return 0;
> > +	}
> > +
> > +	/*
> > +	 * Do the flip.
> > +	 */
> > +
> > +	RCU_TRACE_ME(rcupreempt_trace_try_flip_g1);
> > +	rcu_ctrlblk.completed++;  /* stands in for rcu_try_flip_g2 */
> > +
> > +	/*
> > +	 * Need a memory barrier so that other CPUs see the new
> > +	 * counter value before they see the subsequent change of all
> > +	 * the rcu_flip_flag instances to rcu_flipped.
> > +	 */
> 
> Why? Any code sequence which relies on that?

Yep.  If a CPU saw the flip flag set to rcu_flipped before it saw
the new value of the counter, it might acknowledge the flip, but
then later use the old value of the counter.  It might then end up
incrementing the old counter after some other CPU had concluded
that the sum is zero, which could result in premature detection
of a grace-period.

> For example, rcu_check_callbacks does
> 
> 	if (rcu_ctrlblk.completed == rdp->completed)
> 		rcu_try_flip();
> 
> it is possible that the timer interrupt calls rcu_check_callbacks()
> exactly because rcu_pending() sees rcu_flipped, but without rmb() in
> between we can see the old value of rcu_ctrlblk.completed.
> 
> This is not a problem because rcu_try_flip() needs rcu_ctrlblk.fliplock,
> so rcu_try_flip() will see the new state != rcu_try_flip_idle_state, but
> I can't understand any mb() in rcu_try_flip_xxx().

OK, your point is that I am not taking the locks into account when
determining what memory barriers to use.  You are quite correct, I was
being conservative given that this is not a fast path of any sort.
Nonetheless, I will review this -- no point in any unneeded memory
barriers.  Though a comment will be required in any case, as someone
will no doubt want to remove the locking at some point...

> > +static void rcu_process_callbacks(struct softirq_action *unused)
> > +{
> > +	unsigned long flags;
> > +	struct rcu_head *next, *list;
> > +	struct rcu_data *rdp = RCU_DATA_ME();
> > +
> > +	spin_lock_irqsave(&rdp->lock, flags);
> > +	list = rdp->donelist;
> > +	if (list == NULL) {
> > +		spin_unlock_irqrestore(&rdp->lock, flags);
> > +		return;
> > +	}
> 
> Do we really need this fastpath? It is not needed for the correctness,
> and this case is very unlikely (in fact I think it is not possible:
> rcu_check_callbacks() (triggers RCU_SOFTIRQ) is called with irqs disabled).

Could happen in -rt, where softirq is in process context.  And can't
softirq be pushed to process context in mainline?  Used to be, checking...
Yep, there still is a ksoftirqd().

The stats would come out slightly different if this optimization were
removed, but shouldn't be a problem -- easy to put the RCU_TRACE_RDP()
under an "if".

Will think through whether or not this is worth the extra code, good
eyes!

> > +void fastcall call_rcu(struct rcu_head *head,
> > +				void (*func)(struct rcu_head *rcu))
> > +{
> > +	unsigned long oldirq;
> > +	struct rcu_data *rdp;
> > +
> > +	head->func = func;
> > +	head->next = NULL;
> > +	local_irq_save(oldirq);
> > +	rdp = RCU_DATA_ME();
> > +	spin_lock(&rdp->lock);
> 
> This looks a bit strange. Is this optimization? Why not
> 
> 	spin_lock_irqsave(&rdp->lock, flags);
> 	rdp = RCU_DATA_ME();
> 	...

Can't do the above, because I need the pointer before I can lock it.  ;-)

> ? RCU_DATA_ME() is cheap, but spin_lock() under local_irq_save() spins
> without preemption.
> 
> Actually, why do we need rcu_data->lock ? Looks like local_irq_save()
> should be enough, no? perhaps some -rt reasons ?

We need to retain the ability to manipulate other CPU's rcu_data structures
in order to make dynticks work better and also to handle impending OOM.
So I kept all the rcu_data manipulations under its lock.  However, as you
say, there would be no cross-CPU accesses except in cases of low-power
state and OOM, so lock contention should not be an issue.

Seem reasonable?

> > +	__rcu_advance_callbacks(rdp);
> 
> Any reason this func can't do rcu_check_mb() as well?

Can't think of any, and it might speed up the grace period in some cases.
Though the call in rcu_process_callbacks() needs to stay there as well,
otherwise a CPU that never did call_rcu() might never do the needed
rcu_check_mb().

> If this is possible, can't we move the code doing "s/rcu_flipped/rcu_flip_seen/"
> from __rcu_advance_callbacks() to rcu_check_mb() to unify the "acks" ?

I believe that we cannot safely do this.  The rcu_flipped-to-rcu_flip_seen
transition has to be synchronized to the moving of the callbacks --
either that or we need more GP_STAGES.

> > +void __synchronize_sched(void)
> > +{
> > +	cpumask_t oldmask;
> > +	int cpu;
> > +
> > +	if (sched_getaffinity(0, &oldmask) < 0)
> > +		oldmask = cpu_possible_map;
> > +	for_each_online_cpu(cpu) {
> > +		sched_setaffinity(0, cpumask_of_cpu(cpu));
> > +		schedule();
> 
> This "schedule()" is not needed, any time sched_setaffinity() returns on another
> CPU we already forced preemption of the previously active task on that CPU.

OK, harmless but added overhead, then.

> > +	}
> > +	sched_setaffinity(0, oldmask);
> > +}
> 
> Well, this is not correct... but doesn't matter because of the next patch.

Well, the next patch is made unnecessary because of upcoming changes
to hotplug.  So, what do I have messed up?

> But could you explain how it can deadlock (according to the changelog of
> the next patch) ?

Might not anymore.  It used to be that the CPU hotplug path did a
synchronize_sched() holding the hotplug lock, and that sched_setaffinity()
in turn attempted to acquire the hotplug lock.  This came to light when
I proposed a similar set of patches for -mm early this year.

And with Gautham Shah's new hotplug patches, this problem goes away.
But these are not in 2.6.22, so I had to pull in the classic RCU
implementation to get a working synchronize_sched().

							Thanx, Paul
