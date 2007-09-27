Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbXI0PrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbXI0PrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbXI0PrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:47:04 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56017 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbXI0PrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:47:00 -0400
Date: Thu, 27 Sep 2007 08:46:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20070927154652.GE16652@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183412.GC3819@linux.vnet.ibm.com> <20070923173807.GA292@tv-sign.ru> <20070924001509.GG11123@linux.vnet.ibm.com> <20070926151351.GA328@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926151351.GA328@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 07:13:51PM +0400, Oleg Nesterov wrote:
> On 09/23, Paul E. McKenney wrote:
> >
> > On Sun, Sep 23, 2007 at 09:38:07PM +0400, Oleg Nesterov wrote:
> > > Isn't DEFINE_PER_CPU_SHARED_ALIGNED better for rcu_flip_flag and rcu_mb_flag?
> > 
> > Looks like it to me, thank you for the tip!
> > 
> > Hmmm...  Why not the same for rcu_data?  I guess because there is
> > very little sharing?  The only example thus far of sharing would be
> > if rcu_flipctr were to be moved into rcu_data (if an RCU read-side
> > critical section were preempted and then started on some other CPU),
> 
> even if rcu lock/unlock happen on different CPUs, rcu_flipctr is not "shared",
> we remember the index, but not the CPU, we always modify the "local" data.

Ah, good point, and good reason to keep rcu_flipctr separate.

> > > OTOH, I can't understand how it works. With ot without local_irq_save(),
> > > another CPU can do rcu_try_flip_idle() and increment rcu_ctrlblk.completed
> > > at any time, we can see the old value... rcu_try_flip_waitzero() can miss us?
> > > 
> > > OK, GP_STAGES > 1, so rcu_try_flip_waitzero() will actually check both
> > > 0 and 1 lastidx's before synchronize_rcu() succeeds... I doubt very much
> > > my understanding is correct. Apart from this why GP_STAGES > 1 ???
> > 
> > This is indeed one reason.
> 
> Thanks a lot! Actually, this explains most of my questions. I was greatly
> confused even before I started to read the code. Looking at rcu_flipctr[2]
> I wrongly assumed that these 2 counters "belong" to different GPs. When
> I started to understand the reality, I was confused by GP_STAGES == 4 ;)

;-)

> > > > +		 * Disable local interrupts to prevent the grace-period
> > > > +		 * detection state machine from seeing us half-done.
> > > > +		 * NMIs can still occur, of course, and might themselves
> > > > +		 * contain rcu_read_lock().
> > > > +		 */
> > > > +
> > > > +		local_irq_save(oldirq);
> > > 
> > > Could you please tell more, why do we need this cli?
> > > 
> > > It can't "protect" rcu_ctrlblk.completed, and the only change which affects
> > > the state machine is rcu_flipctr[idx]++, so I can't understand the "half-done"
> > > above. (of course, we must disable preemption while changing rcu_flipctr).
> > > 
> > 
> > 	The problem is not with .completed being incremented, but only
> > 	by it (1) being incremented (presumably by some other CPU and
> > 	then (2) having this CPU get a scheduling-clock interrupt, which
> > 	then causes this CPU to prematurely update the rcu_flip_flag.
> > 	This is a problem, because updating rcu_flip_flag is making a
> > 	promise that you won't ever again increment the "old" counter set
> > 	(at least not until the next counter flip).  If the scheduling
> > 	clock interrupt were to happen between the time that we pick
> > 	up the .completed field and the time that we increment our
> > 	counter, we will have broken that promise, and that could cause
> > 	someone to prematurely declare the grace period to be finished
> 
> Thanks!
> 
> > 	The second reason is that cli prohibits preemption.
> 
> yes, this is clear
> 
> > > > +	rcu_ctrlblk.completed++;  /* stands in for rcu_try_flip_g2 */
> > > > +
> > > > +	/*
> > > > +	 * Need a memory barrier so that other CPUs see the new
> > > > +	 * counter value before they see the subsequent change of all
> > > > +	 * the rcu_flip_flag instances to rcu_flipped.
> > > > +	 */
> > > 
> > > Why? Any code sequence which relies on that?
> > 
> > Yep.  If a CPU saw the flip flag set to rcu_flipped before it saw
> > the new value of the counter, it might acknowledge the flip, but
> > then later use the old value of the counter.
> 
> Yes, yes, I see now. We really need this barriers, except I think
> rcu_try_flip_idle() can use wmb. However, I have a bit offtopic question,
> 
> 	// rcu_try_flip_waitzero()
> 	if (A == 0) {
> 		mb();
> 		B == 0;
> 	}
> 
> Do we really need the mb() in this case? How it is possible that STORE
> goes before LOAD? "Obviously", the LOAD should be completed first, no?

Suppose that A was most recently stored by a CPU that shares a store
buffer with this CPU.  Then it is possible that some other CPU sees
the store to B as happening before the store that "A==0" above is
loading from.  This other CPU would naturally conclude that the store
to B must have happened before the load from A.

In more detail, suppose that CPU 0 and 1 share a store buffer, and
that CPU 2 and 3 share a second store buffer.  This happens naturally
if CPUs 0 and 1 are really just different hardware threads within a
single core.

So, suppose the cacheline for A is initially owned by CPUs 2 and 3,
and that the cacheline for B is initially owned by CPUs 0 and 1.
Then consider the following sequence of events:

o	CPU 0 stores zero to A.  This is a cache miss, so the new value
	for A is placed in CPU 0's and 1's store buffer.

o	CPU 1 executes the above code, first loading A.  It sees
	the value of A==0 in the store buffer, and therefore
	stores zero to B, which hits in the cache.  (I am assuming
	that we left out the mb() above).

o	CPU 2 loads from B, which misses the cache, and gets the
	value that CPU 1 stored.  Suppose it checks the value,
	and based on this check, loads A.  The old value of A might
	still be in cache, which would lead CPU 2 to conclude that
	the store to B by CPU 1 must have happened before the store
	to A by CPU 0.

Memory barriers would prevent this confusion.  An intro to store buffers
can be found at http://www.cs.utah.edu/mpv/papers/neiger/fmcad2001.pdf,
FYI.

> > > This looks a bit strange. Is this optimization? Why not
> > > 
> > > 	spin_lock_irqsave(&rdp->lock, flags);
> > > 	rdp = RCU_DATA_ME();
> > 
> > Can't do the above, because I need the pointer before I can lock it.  ;-)
> 
> Oooh... well... I need to think more about your explanation :)

;-)

> > > If this is possible, can't we move the code doing "s/rcu_flipped/rcu_flip_seen/"
> > > from __rcu_advance_callbacks() to rcu_check_mb() to unify the "acks" ?
> > 
> > I believe that we cannot safely do this.  The rcu_flipped-to-rcu_flip_seen
> > transition has to be synchronized to the moving of the callbacks --
> > either that or we need more GP_STAGES.
> 
> Hmm. Still can't understand.

Callbacks would be able to be injected into a grace period after it
started.

Or are you arguing that as long as interrupts remain disabled between
the two events, no harm done?

> Suppose that we are doing call_rcu(), and __rcu_advance_callbacks() sees
> rdp->completed == rcu_ctrlblk.completed but rcu_flip_flag = rcu_flipped
> (say, another CPU does rcu_try_flip_idle() in between).
> 
> We ack the flip, call_rcu() enables irqs, the timer interrupt calls
> __rcu_advance_callbacks() again and moves the callbacks.
> 
> So, it is still possible that "move callbacks" and "ack the flip" happen
> out of order. But why this is bad?
> 
> This can't "speedup" the moving of our callbacks from next to done lists.
> Yes, RCU state machine can switch to the next state/stage, but this looks
> safe to me.

Ah -- you are in fact arguing that interrupts remain disabled throughout.
I would still rather that the rcu_flip_seen transition be adjacent
to the callback movement in the code.  My fear is that the connection
might be lost otherwise...  "Oh, but we can just momentarily enable
interrupts here!"

> Help!
> 
> The last question, rcu_check_callbacks does
> 
> 	if (rcu_ctrlblk.completed == rdp->completed)
> 		rcu_try_flip();
> 
> Could you clarify the check above? Afaics this is just optimization,
> technically it is correct to rcu_try_flip() at any time, even if ->completed
> are not synchronized. Most probably in that case rcu_try_flip_waitack() will
> fail, but nothing bad can happen, yes?

>From a conceptual viewpoint, if this CPU hasn't caught up with the
last grace-period stage, it has no business trying to push forward to
the next stage.  So this might (or might not) happen to work with this
particular implementation, it needs to stay as is.  We need this code
to be robust enough to optimize the grace-period latencies, right?

> > > > +	}
> > > > +	sched_setaffinity(0, oldmask);
> > > > +}
> > > 
> > > Well, this is not correct... but doesn't matter because of the next patch.
> > 
> > Well, the next patch is made unnecessary because of upcoming changes
> > to hotplug.  So, what do I have messed up?
> 
> oldmask could be obsolete now. Suppose that the admin moves that task to some
> cpuset or just changes its ->cpus_allowed while it does synchronize_sched().

Ah, good point...

> I think there is another problem. It would be nice to eliminate taking the global
> sched_hotcpu_mutex in sched_setaffinity() (I think without CONFIG_HOTPLUG_CPU
> it is not needed right now). In that case sched_setaffinity(0, cpumask_of_cpu(cpu))
> can in fact return on the "wrong" CPU != cpu if another thread changes our affinity
> in parallel, and this breaks synchronize_sched().
> 
> 
> Can't we do something different? Suppose that we changed migration_thread(),
> something like (roughly)
> 
> 	-	__migrate_task(req->task, cpu, req->dest_cpu);
> 	+	if (req->task)
> 	+		__migrate_task(req->task, cpu, req->dest_cpu);
> 	+	else
> 	+		schedule(); // unneeded, mb() is enough?
> 	
> 		complete(&req->done);
> 
> Now,
> 	void synchronize_sched(void)
> 	{
> 		struct migration_req req;
> 
> 		req->task = NULL;
> 		init_completion(&req.done);
> 
> 		for_each_online_cpu(cpu) {
> 			struct rq *rq = cpu_rq(cpu);
> 			int online;
> 
> 			spin_lock_irq(&rq->lock);
> 			online = cpu_online(cpu); // HOTPLUG_CPU
> 			if (online) {
> 				list_add(&req->list, &rq->migration_queue);
> 				req.done.done = 0;
> 			}
> 			spin_unlock_irq(&rq->lock);
> 
> 			if (online) {
> 				wake_up_process(rq->migration_thread);
> 				wait_for_completion(&req.done);
> 			}
> 		}
> 	}
> 
> Alternatively, we can use schedule_on_each_cpu(), but it has other disadvantages.
> 
> Thoughts?

Some people are calling for eliminating synchronize_sched() altogether,
but there are a few uses that would be hard to get rid of.

I need to think about your approach above.  It looks like you are
leveraging the migration tasks, but I am concerned about concurrent
hotplug events.  But either way, I do like the idea of communicating
with other tasks that actually do the context switches on behalf
of synchronize_sched().

						Thanx, Paul
