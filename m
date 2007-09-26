Return-Path: <linux-kernel-owner+w=401wt.eu-S1760565AbXIZPKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565AbXIZPKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbXIZPJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:09:58 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:37705 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408AbXIZPJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:09:57 -0400
Date: Wed, 26 Sep 2007 19:13:51 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20070926151351.GA328@tv-sign.ru>
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183412.GC3819@linux.vnet.ibm.com> <20070923173807.GA292@tv-sign.ru> <20070924001509.GG11123@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924001509.GG11123@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23, Paul E. McKenney wrote:
>
> On Sun, Sep 23, 2007 at 09:38:07PM +0400, Oleg Nesterov wrote:
> > Isn't DEFINE_PER_CPU_SHARED_ALIGNED better for rcu_flip_flag and rcu_mb_flag?
> 
> Looks like it to me, thank you for the tip!
> 
> Hmmm...  Why not the same for rcu_data?  I guess because there is
> very little sharing?  The only example thus far of sharing would be
> if rcu_flipctr were to be moved into rcu_data (if an RCU read-side
> critical section were preempted and then started on some other CPU),

even if rcu lock/unlock happen on different CPUs, rcu_flipctr is not "shared",
we remember the index, but not the CPU, we always modify the "local" data.

> > OTOH, I can't understand how it works. With ot without local_irq_save(),
> > another CPU can do rcu_try_flip_idle() and increment rcu_ctrlblk.completed
> > at any time, we can see the old value... rcu_try_flip_waitzero() can miss us?
> > 
> > OK, GP_STAGES > 1, so rcu_try_flip_waitzero() will actually check both
> > 0 and 1 lastidx's before synchronize_rcu() succeeds... I doubt very much
> > my understanding is correct. Apart from this why GP_STAGES > 1 ???
> 
> This is indeed one reason.

Thanks a lot! Actually, this explains most of my questions. I was greatly
confused even before I started to read the code. Looking at rcu_flipctr[2]
I wrongly assumed that these 2 counters "belong" to different GPs. When
I started to understand the reality, I was confused by GP_STAGES == 4 ;)

> > > +		 * Disable local interrupts to prevent the grace-period
> > > +		 * detection state machine from seeing us half-done.
> > > +		 * NMIs can still occur, of course, and might themselves
> > > +		 * contain rcu_read_lock().
> > > +		 */
> > > +
> > > +		local_irq_save(oldirq);
> > 
> > Could you please tell more, why do we need this cli?
> > 
> > It can't "protect" rcu_ctrlblk.completed, and the only change which affects
> > the state machine is rcu_flipctr[idx]++, so I can't understand the "half-done"
> > above. (of course, we must disable preemption while changing rcu_flipctr).
> > 
> 
> 	The problem is not with .completed being incremented, but only
> 	by it (1) being incremented (presumably by some other CPU and
> 	then (2) having this CPU get a scheduling-clock interrupt, which
> 	then causes this CPU to prematurely update the rcu_flip_flag.
> 	This is a problem, because updating rcu_flip_flag is making a
> 	promise that you won't ever again increment the "old" counter set
> 	(at least not until the next counter flip).  If the scheduling
> 	clock interrupt were to happen between the time that we pick
> 	up the .completed field and the time that we increment our
> 	counter, we will have broken that promise, and that could cause
> 	someone to prematurely declare the grace period to be finished

Thanks!

> 	The second reason is that cli prohibits preemption.

yes, this is clear

> > > +	rcu_ctrlblk.completed++;  /* stands in for rcu_try_flip_g2 */
> > > +
> > > +	/*
> > > +	 * Need a memory barrier so that other CPUs see the new
> > > +	 * counter value before they see the subsequent change of all
> > > +	 * the rcu_flip_flag instances to rcu_flipped.
> > > +	 */
> > 
> > Why? Any code sequence which relies on that?
> 
> Yep.  If a CPU saw the flip flag set to rcu_flipped before it saw
> the new value of the counter, it might acknowledge the flip, but
> then later use the old value of the counter.

Yes, yes, I see now. We really need this barriers, except I think
rcu_try_flip_idle() can use wmb. However, I have a bit offtopic question,

	// rcu_try_flip_waitzero()
	if (A == 0) {
		mb();
		B == 0;
	}

Do we really need the mb() in this case? How it is possible that STORE
goes before LOAD? "Obviously", the LOAD should be completed first, no?

> > This looks a bit strange. Is this optimization? Why not
> > 
> > 	spin_lock_irqsave(&rdp->lock, flags);
> > 	rdp = RCU_DATA_ME();
> 
> Can't do the above, because I need the pointer before I can lock it.  ;-)

Oooh... well... I need to think more about your explanation :)

> > If this is possible, can't we move the code doing "s/rcu_flipped/rcu_flip_seen/"
> > from __rcu_advance_callbacks() to rcu_check_mb() to unify the "acks" ?
> 
> I believe that we cannot safely do this.  The rcu_flipped-to-rcu_flip_seen
> transition has to be synchronized to the moving of the callbacks --
> either that or we need more GP_STAGES.

Hmm. Still can't understand.

Suppose that we are doing call_rcu(), and __rcu_advance_callbacks() sees
rdp->completed == rcu_ctrlblk.completed but rcu_flip_flag = rcu_flipped
(say, another CPU does rcu_try_flip_idle() in between).

We ack the flip, call_rcu() enables irqs, the timer interrupt calls
__rcu_advance_callbacks() again and moves the callbacks.

So, it is still possible that "move callbacks" and "ack the flip" happen
out of order. But why this is bad?

This can't "speedup" the moving of our callbacks from next to done lists.
Yes, RCU state machine can switch to the next state/stage, but this looks
safe to me.

Help!

The last question, rcu_check_callbacks does

	if (rcu_ctrlblk.completed == rdp->completed)
		rcu_try_flip();

Could you clarify the check above? Afaics this is just optimization,
technically it is correct to rcu_try_flip() at any time, even if ->completed
are not synchronized. Most probably in that case rcu_try_flip_waitack() will
fail, but nothing bad can happen, yes?

> > > +	}
> > > +	sched_setaffinity(0, oldmask);
> > > +}
> > 
> > Well, this is not correct... but doesn't matter because of the next patch.
> 
> Well, the next patch is made unnecessary because of upcoming changes
> to hotplug.  So, what do I have messed up?

oldmask could be obsolete now. Suppose that the admin moves that task to some
cpuset or just changes its ->cpus_allowed while it does synchronize_sched().

I think there is another problem. It would be nice to eliminate taking the global
sched_hotcpu_mutex in sched_setaffinity() (I think without CONFIG_HOTPLUG_CPU
it is not needed right now). In that case sched_setaffinity(0, cpumask_of_cpu(cpu))
can in fact return on the "wrong" CPU != cpu if another thread changes our affinity
in parallel, and this breaks synchronize_sched().


Can't we do something different? Suppose that we changed migration_thread(),
something like (roughly)

	-	__migrate_task(req->task, cpu, req->dest_cpu);
	+	if (req->task)
	+		__migrate_task(req->task, cpu, req->dest_cpu);
	+	else
	+		schedule(); // unneeded, mb() is enough?
	
		complete(&req->done);

Now,
	void synchronize_sched(void)
	{
		struct migration_req req;

		req->task = NULL;
		init_completion(&req.done);

		for_each_online_cpu(cpu) {
			struct rq *rq = cpu_rq(cpu);
			int online;

			spin_lock_irq(&rq->lock);
			online = cpu_online(cpu); // HOTPLUG_CPU
			if (online) {
				list_add(&req->list, &rq->migration_queue);
				req.done.done = 0;
			}
			spin_unlock_irq(&rq->lock);

			if (online) {
				wake_up_process(rq->migration_thread);
				wait_for_completion(&req.done);
			}
		}
	}

Alternatively, we can use schedule_on_each_cpu(), but it has other disadvantages.

Thoughts?

Oleg.

