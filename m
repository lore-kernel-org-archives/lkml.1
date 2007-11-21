Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbXKUV0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbXKUV0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 16:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbXKUVZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 16:25:51 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:57865 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbXKUVZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 16:25:49 -0500
Date: Wed, 21 Nov 2007 13:25:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: James Huang <jamesclhuang@yahoo.com>
Cc: linux-kernel@vger.kernel.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, james.huang@watchguard.com
Subject: Re: __rcu_process_callbacks() in Linux 2.6
Message-ID: <20071121212547.GD9092@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <477946.24133.qm@web83814.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477946.24133.qm@web83814.mail.sp1.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 11:57:29AM -0800, James Huang wrote:
> Paul,
> 
>        I am not sure I understand your answer about using test_and_set_bit() in tasklet_schedule() as a 
> memory barrier in this case.
> 
>        Yes, tasklet_schedule() includes a test_and_set_bit(TASKLET_STATE_SCHED, &t->state) on a tasklet, but 
> in this case the tasklet is a per CPU tasklet.

Memory barriers are memory barriers, regardless of what type of data
is being processed.

>        According to documentation/atomic_ops.txt, atomic op that returns a value has the semantics of 
> "explicit memory barriers performed before and after the operation".  

And test_and_set_bit() does return a value, namely the value of the
affected bit before the operation.  Therefore, any correct implementation
for a CONFIG_SMP build must include memory barriers before and after.
Extracting the relevant passage from Documentation/atomic_ops.txt
between the pair of dashed lines:

------------------------------------------------------------------------

	int test_and_set_bit(unsigned long nr, volatile unsigned long *addr);
	int test_and_clear_bit(unsigned long nr, volatile unsigned long *addr);
	int test_and_change_bit(unsigned long nr, volatile unsigned long *addr);

Like the above, except that these routines return a boolean which
indicates whether the changed bit was set _BEFORE_ the atomic bit
operation.

WARNING! It is incredibly important that the value be a boolean,
ie. "0" or "1".  Do not try to be fancy and save a few instructions by
declaring the above to return "long" and just returning something like
"old_val & mask" because that will not work.

For one thing, this return value gets truncated to int in many code
paths using these interfaces, so on 64-bit if the bit is set in the
upper 32-bits then testers will never see that.

One great example of where this problem crops up are the thread_info
flag operations.  Routines such as test_and_set_ti_thread_flag() chop
the return value into an int.  There are other places where things
like this occur as well.

These routines, like the atomic_t counter operations returning values,
require explicit memory barrier semantics around their execution.  All
memory operations before the atomic bit operation call must be made
visible globally before the atomic bit operation is made visible.
Likewise, the atomic bit operation must be visible globally before any
subsequent memory operation is made visible.  For example:

	obj->dead = 1;
	if (test_and_set_bit(0, &obj->flags))
		/* ... */;
	obj->killed = 1;

The implementation of test_and_set_bit() must guarantee that
"obj->dead = 1;" is visible to cpus before the atomic memory operation
done by test_and_set_bit() becomes visible.  Likewise, the atomic
memory operation done by test_and_set_bit() must become visible before
"obj->killed = 1;" is visible.

------------------------------------------------------------------------

> If I understand it correctly, this means that, for exmaple,
> 
>            atomic_t aa = ATOMIC_INIT(0);
>            int X = 1;
>            int Y = 2;
>  CPU 0:
>           update X=100;
>           atomc_inc_return(&aa);
>           update Y=200;

But, yes, atomic_inc_return() does indeed force ordering.

> Then CPU 1 will always see X=100 before it sees the new value of aa (1), and CPU 1 wil always 
> see the new value of aa (1) before it sees Y=200.

Yep.  And CPU 1 will also see any preceding unrelated assignment
prior to the new value of aa as well.  And it is not just preceding
stores.  See the sentence from Documentation/atomic_ops.txt:

	All memory operations before the atomic bit operation call must
	be made visible globally before the atomic bit operation is
	made visible.

Both stores -and- loads.

> This ordering semantics does not apply to the scenario in our discussion.
> For one thing, the rcu tasklet is a per CPU tasklet.  So obviously no other CPU's will even read its t->state.    
> 
> Am I still missing something?

Yep -- the test_and_set_bit() operation has no clue who else might or
might not be reading t->state.  Besides, tasklets need not be allocated
on a per-CPU basis, and therefore tasklet_schedule() must be prepared
to deal with other CPUs concurrently manipulating t->state, for example,
via the tasklet_disable() interface.

Another thing that might help is to fill in the RCU read-side critical
section that CPU 2 would have to execute (after all the stuff you currently
have it executing), along with the RCU update that would need to precede
CPU 2's call_rcu() call.  I have done this in your example code below.

Note that in order for a failure to occur, CPU 1 must reach /* A */
before CPU 2 reaches /* B */.

One key point is that tasklet_schedule()'s memory ordering affects this
preceding code for CPU 2.  The second key point is that acquiring and
releasing a lock acts as a barrier as well (though a limited one).

The result is that CPU 2 must see CPU 1's update to rcp->cur in the
case that CPU 1 makes it to /* A */ before CPU 2 makes it to /* B */.

> By the way, which tasklet_schedule() are you referring to in your previous email? 
> Is it the one called by CPU 0, CPU 1, or CPU 2?

The one called by CPU 2 that appears immediately before my response below.

All that aside, unless Manfred, Dipankar, or whomever can point out
some other ordering constraint that I have missed, this one is messy
enough that an additional explicit memory barrier might be in order.

Manfred?  Dipankar?

> Thanks,
> James Huang
> 
> 
> 
> ----- Original Message ----
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> To: James Huang <jamesclhuang@yahoo.com>
> Cc: linux-kernel@vger.kernel.org; manfred@colorfullife.com; dipankar@in.ibm.com
> Sent: Wednesday, November 21, 2007 8:54:15 AM
> Subject: Re: __rcu_process_callbacks() in Linux 2.6
> 
> On Tue, Nov 20, 2007 at 07:43:09PM -0800, James Huang wrote:
> > Please disregard the previous email.
> > 
> > 
> > In the latest Linux 2.6 RCU implementation, __rcu_process_callbacks() is coded as follows: 
> > 
> > 
> > 422 static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
> > 423                                        struct rcu_data *rdp)
> > 424 {
> > 425        if (rdp->curlist && !rcu_batch_before(rcp->completed, rdp->batch)) {
> > 426                *rdp->donetail = rdp->curlist;
> > 427                rdp->donetail = rdp->curtail;
> > 428                rdp->curlist = NULL;
> > 429                rdp->curtail = &rdp->curlist;
> > 430        }
> > 431 
> > 432        if (rdp->nxtlist && !rdp->curlist) {
> > 433                local_irq_disable();
> > 434                rdp->curlist = rdp->nxtlist;
> > 435                rdp->curtail = rdp->nxttail;
> > 436                rdp->nxtlist = NULL;
> > 437                rdp->nxttail = &rdp->nxtlist;
> > 438                local_irq_enable();
> > 439 
> > 440                /*
> > 441                  * start the next batch of callbacks
> > 442                  */
> > 443 
> > 444                /* determine batch number */
> > 445                rdp->batch = rcp->cur + 1;
> > 446                /* see the comment and corresponding wmb() in
> > 447                  * the rcu_start_batch()
> > 448                  */
> > 449                smp_rmb();
> > 450 
> > 451                if (!rcp->next_pending) {
> > 452                        /* and start it/schedule start if it's a new batch */
> > 453                        spin_lock(&rcp->lock);
> > 454                        rcp->next_pending = 1;
> > 455                        rcu_start_batch(rcp);
> > 456                        spin_unlock(&rcp->lock);
> > 457                }
> > 458        }
> > 459 
> > 460        rcu_check_quiescent_state(rcp, rdp);
> > 461        if (rdp->donelist)
> > 462                rcu_do_batch(rdp);
> > 463 }
> > 
> > 
> > The question is how does the update of rdp->batch at line 445 guarantee to observe the most updated value of rcp->cur??
> > The issue is that there is no memory barrier/locking before line 445.
> > So I think the following sequence of events in chronological order is possible:
> > 
> > Assume initially rcp->cur = 100, this current batch value is visible to every CPU, and batch 100 has completed 
> > (i.e. rcp->completed = 100, rcp->next_pending = 0,  rcp->cpumask = 0, and for each CPU, rdp->quiescbatch = 100, rdp->qs_pending = 0, rdp->passed_quiesc = 1)
> 
> 
> > CPU 0: 
> > --------- 
> >              call_rcu(): a callback inserted into rdp->nxtlist;                    
> > 
> >              timer interrupt 
> >                call rcu_pending(), return true  ( ! rdp->curlist && rdp->nxtlist)
> >                call rcu_check_callbacks() 
> >                      schedule per CPU rcu_tasklet
> > 
> >                __rcu_process_callbacks()
> >                            move callbacks from nxtlist to curlist;
> >                            rdp->batch = 101
> >                            lock rcp->lock
> >                            rcp->next_pending = 1
> >                            call rcu_start_batch()
> >                                  find the current batch has completed and next batch pending;
> >                                  rcp->next_pending = 0
> >                                  update rcp->cur to 101 and initialize rcp->cpumask;                  <----- time t1
> >                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >                            unlock rcp->lock
> >                              
> > CPU 1:
> > ---------  
> >              timer interrupt 
> >                  call rcu_pending(), return true (asume observing rcp->cur = 101 != rdp->quiescbatch) 
> >                  
> >                  call rcu_check_callbacks() 
> >                        schedule per CPU rcu_tasklet
> > 
> >                  __rcu_process_callbacks()
> >                        call rcu_check_quisecent_state()
> >                              find rdp->quiescbatch != rcp->cur
> >                              set rdp->qs_pending = 1
> >                              set rdp->passed_quiesc = 0
> >                              set rdp->quiescbatch = 101 (rcp->cur)
> > 
> >              Another timer interrupt
> >                  call rcu_pending(), return true (rdp->qs_pending == 1)  
> >                  call rcu_check_callbacks() 
> >                        (assume in user mode)                        <-- time t2  pass quiescent state
> >                        ~~~~~~~~~~~~~~~~~~                            ~~~~~~~~~~~~~~~~~~~~~~
> >                        rdp->passed_quiesc = 1
> >                        schedule per CPU rcu_tasklet
> >            
> >                  __rcu_process_callbacks()
> >                        call rcu_check_quisecent_state()
> >                              find rdp->qs_pending == 1 && rdp-> passed_quiesc == 1
> >                              set rdp->qs_pending = 0
> >                              lock rcp->lock
> >                              call cpu_quite()
> >                                    clear bit in the rcp->cpumask set up by CPU 0 at time t1
> >                                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >                              unlock rcp->lock

		rcu_read_lock();
		p = rcu_dereference(RCU_protected_pointer);
		/* A */
		/* do something time-consuming with p */
		rcu_read_unlock();

> > 
> > CPU 2:
> > ---------  

		q1 = kmalloc(...);
		initialize_it(q1);
		q = RCU_protected_pointer;
		/* B */
		rcu_assign_pointer(RCU_protected_pointer, q1);

> >              call_rcu(): a callback inserted into rdp->nxtlist;    <--- time t3
> >              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >              
> >              timer interrupt 
> >                  call rcu_pending(), return true ( ! rdp->curlist && rdp->nxtlist)
> >                  call rcu_check_callbacks() 
> >                      schedule per CPU rcu_tasklet
> 
> The tasklet_schedule() code calls test_and_set_bit(), which is an
> atomic operation that returns a value.  It therefore implies a memory
> barrier, so that if the prior call_rcu() at time t3 "happens after"
> CPU 1's quiescent state at time t2 (which, due to locking, must follow
> the update to rcp->cur at time t1), then the access to rcp->cur at time
> t4 must see the new value of rcp->cur.
> 
> This is admittedly a bit subtle and perhaps a bit fragile.  Manfred,
> Dipankar, would it be worth putting an explicit memory barrier somewhere
> in this sequence, or is there another memory barrier that I forgetting?
> 
>                             Thanx, Paul
> 
> >                  calls __rcu_process_callbacks()
> >                      move callbacks from nxtlist to curlist; (including the callback inserted at time t3)
> >                      rdp->batch = rcp->cur + 1;                        <--- time t4
> >                      ~~~~~~~~~~~~~~~~~~~~
> > 
> > At time t4, CPU 2 might observe rcp->cpu as 100 and set rdp->batch to 101.
> > So CPU 2 essentially started its batch 101 (includes a callback inserted at time t3) after CPU 1 passed its quiescent state (at time t2) for batch 101.
> > 
> > Isn't this an issue???  Am I missing something?
> > Thanks for pointing me to the right direction.

							Thanx, Paul
