Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbXI1S6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbXI1S6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXI1S6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:58:06 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42060 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbXI1S6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:58:03 -0400
Date: Fri, 28 Sep 2007 11:57:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20070928185759.GC9153@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183412.GC3819@linux.vnet.ibm.com> <20070923173807.GA292@tv-sign.ru> <20070924001509.GG11123@linux.vnet.ibm.com> <20070926151351.GA328@tv-sign.ru> <20070927154652.GE16652@linux.vnet.ibm.com> <20070928144714.GA397@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928144714.GA397@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 06:47:14PM +0400, Oleg Nesterov wrote:
> On 09/27, Paul E. McKenney wrote:
> >
> > On Wed, Sep 26, 2007 at 07:13:51PM +0400, Oleg Nesterov wrote:
> > > 
> > > Yes, yes, I see now. We really need this barriers, except I think
> > > rcu_try_flip_idle() can use wmb. However, I have a bit offtopic question,
> > > 
> > > 	// rcu_try_flip_waitzero()
> > > 	if (A == 0) {
> > > 		mb();
> > > 		B == 0;
> > > 	}
> > > 
> > > Do we really need the mb() in this case? How it is possible that STORE
> > > goes before LOAD? "Obviously", the LOAD should be completed first, no?
> > 
> > Suppose that A was most recently stored by a CPU that shares a store
> > buffer with this CPU.  Then it is possible that some other CPU sees
> > the store to B as happening before the store that "A==0" above is
> > loading from.  This other CPU would naturally conclude that the store
> > to B must have happened before the load from A.
> 
> Ah, I was confused by the comment,
> 
> 	smp_mb();  /* Don't call for memory barriers before we see zero. */
> 	                                             ^^^^^^^^^^^^^^^^^^
> So, in fact, we need this barrier to make sure that _other_ CPUs see these
> changes in order, thanks. Of course, _we_ already saw zero.

Fair point!

Perhaps: "Ensure that all CPUs see their rcu_mb_flag -after- the
rcu_flipctrs sum to zero" or some such?

> But in that particular case this doesn't matter, rcu_try_flip_waitzero()
> is the only function which reads the "non-local" per_cpu(rcu_flipctr), so
> it doesn't really need the barrier? (besides, it is always called under
> fliplock).

The final rcu_read_unlock() that zeroed the sum was -not- under fliplock,
so we cannot necessarily rely on locking to trivialize all of this.

> > In more detail, suppose that CPU 0 and 1 share a store buffer, and
> > that CPU 2 and 3 share a second store buffer.  This happens naturally
> > if CPUs 0 and 1 are really just different hardware threads within a
> > single core.
> > 
> > So, suppose the cacheline for A is initially owned by CPUs 2 and 3,
> > and that the cacheline for B is initially owned by CPUs 0 and 1.
> > Then consider the following sequence of events:
> > 
> > o	CPU 0 stores zero to A.  This is a cache miss, so the new value
> > 	for A is placed in CPU 0's and 1's store buffer.
> > 
> > o	CPU 1 executes the above code, first loading A.  It sees
> > 	the value of A==0 in the store buffer, and therefore
> > 	stores zero to B, which hits in the cache.  (I am assuming
> > 	that we left out the mb() above).
> > 
> > o	CPU 2 loads from B, which misses the cache, and gets the
> > 	value that CPU 1 stored.  Suppose it checks the value,
> > 	and based on this check, loads A.  The old value of A might
> > 	still be in cache, which would lead CPU 2 to conclude that
> > 	the store to B by CPU 1 must have happened before the store
> > 	to A by CPU 0.
> > 
> > Memory barriers would prevent this confusion.
> 
> Thanks a lot!!! This fills another gap in my understanding.

Glad it helped!  ;-)

> OK, the last (I promise :) off-topic question. When CPU 0 and 1 share a
> store buffer, the situation is simple, we can replace "CPU 0 stores" with
> "CPU 1 stores". But what if CPU 0 is equally "far" from CPUs 1 and 2?
> 
> Suppose that CPU 1 does
> 
> 	wmb();
> 	B = 0
> 
> Can we assume that CPU 2 doing
> 
> 	if (B == 0) {
> 		rmb();
> 
> must see all invalidations from CPU 0 which were seen by CPU 1 before wmb() ?

Yes.  CPU 2 saw something following CPU 1's wmb(), so any of CPU 2's
reads following its rmb() must therefore see all of CPU 1's stores
preceding the wmb().

> > > > > If this is possible, can't we move the code doing "s/rcu_flipped/rcu_flip_seen/"
> > > > > from __rcu_advance_callbacks() to rcu_check_mb() to unify the "acks" ?
> > > > 
> > > > I believe that we cannot safely do this.  The rcu_flipped-to-rcu_flip_seen
> > > > transition has to be synchronized to the moving of the callbacks --
> > > > either that or we need more GP_STAGES.
> > > 
> > > Hmm. Still can't understand.
> > 
> > Callbacks would be able to be injected into a grace period after it
> > started.
> 
> Yes, but this is _exactly_ what the current code does in the scenario below,
> 
> > Or are you arguing that as long as interrupts remain disabled between
> > the two events, no harm done?
> 
> no,
> 
> > > Suppose that we are doing call_rcu(), and __rcu_advance_callbacks() sees
> > > rdp->completed == rcu_ctrlblk.completed but rcu_flip_flag = rcu_flipped
> > > (say, another CPU does rcu_try_flip_idle() in between).
> > > 
> > > We ack the flip, call_rcu() enables irqs, the timer interrupt calls
> > > __rcu_advance_callbacks() again and moves the callbacks.
> > > 
> > > So, it is still possible that "move callbacks" and "ack the flip" happen
> > > out of order. But why this is bad?
> 
> Look, what happens is
> 
> 	// call_rcu()
> 	rcu_flip_flag = rcu_flipped
> 	insert the new callback
> 	// timer irq
> 	move the callbacks (the new one goes to wait[0])
> 
> But I still can't understand why this is bad,
> 
> > > This can't "speedup" the moving of our callbacks from next to done lists.
> > > Yes, RCU state machine can switch to the next state/stage, but this looks
> > > safe to me.
> 
> Before this callback will be flushed, we need 2 rdp->completed != rcu_ctrlblk.completed
> further events, we can't miss rcu_read_lock() section, no?
> 
> > > Help!
> 
> Please :)

Quite possibly my paranoia -- need to think about this some more.

Guess I need to expand the code-level portion of the document to cover
the grace-period side.  That would force me either to get my explanation
into shape or admit that you are correct, as the case might be.  ;-)

> > > 	if (rcu_ctrlblk.completed == rdp->completed)
> > > 		rcu_try_flip();
> > > 
> > > Could you clarify the check above? Afaics this is just optimization,
> > > technically it is correct to rcu_try_flip() at any time, even if ->completed
> > > are not synchronized. Most probably in that case rcu_try_flip_waitack() will
> > > fail, but nothing bad can happen, yes?
> > 
> > >From a conceptual viewpoint, if this CPU hasn't caught up with the
> > last grace-period stage, it has no business trying to push forward to
> > the next stage.  So this might (or might not) happen to work with this
> > particular implementation, it needs to stay as is.  We need this code
> > to be robust enough to optimize the grace-period latencies, right?
> 
> Yes, yes. I just wanted to be sure I didn't miss some other subtle reason.
> 
> > > 	void synchronize_sched(void)
> > > 	{
> > > 		struct migration_req req;
> > > 
> > > 		req->task = NULL;
> > > 		init_completion(&req.done);
> > > 
> > > 		for_each_online_cpu(cpu) {
> > > 			struct rq *rq = cpu_rq(cpu);
> > > 			int online;
> > > 
> > > 			spin_lock_irq(&rq->lock);
> > > 			online = cpu_online(cpu); // HOTPLUG_CPU
> > > 			if (online) {
> > > 				list_add(&req->list, &rq->migration_queue);
> > > 				req.done.done = 0;
> > > 			}
> > > 			spin_unlock_irq(&rq->lock);
> > > 
> > > 			if (online) {
> > > 				wake_up_process(rq->migration_thread);
> > > 				wait_for_completion(&req.done);
> > > 			}
> > > 		}
> > > 	}
> > > 
> > 
> > I need to think about your approach above.  It looks like you are
> > leveraging the migration tasks, but I am concerned about concurrent
> > hotplug events.
> 
> I hope this is OK, note that migration_call(CPU_DEAD) flushes ->migration_queue,
> if we take rq->lock after that we must see !cpu_online(cpu). CPU_UP event is not
> interesting for us, we can miss it.
> 
> Hmm... but wake_up_process() should be moved under spin_lock().

The other approach would be to simply have a separate thread for this
purpose.  Batching would amortize the overhead (a single trip around the
CPUs could satisfy an arbitrarily large number of synchronize_sched()
requests).

						Thanx, Paul
