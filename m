Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbXKUQyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbXKUQyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 11:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbXKUQyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 11:54:23 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:36582 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbXKUQyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 11:54:23 -0500
Date: Wed, 21 Nov 2007 08:54:15 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: James Huang <jamesclhuang@yahoo.com>
Cc: linux-kernel@vger.kernel.org, manfred@colorfullife.com,
       dipankar@in.ibm.com
Subject: Re: __rcu_process_callbacks() in Linux 2.6
Message-ID: <20071121165415.GA20130@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <922177.2692.qm@web83824.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <922177.2692.qm@web83824.mail.sp1.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 07:43:09PM -0800, James Huang wrote:
> Please disregard the previous email.
> 
> 
> In the latest Linux 2.6 RCU implementation, __rcu_process_callbacks() is coded as follows: 
> 
> 
> 422 static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
> 423                                        struct rcu_data *rdp)
> 424 {
> 425        if (rdp->curlist && !rcu_batch_before(rcp->completed, rdp->batch)) {
> 426                *rdp->donetail = rdp->curlist;
> 427                rdp->donetail = rdp->curtail;
> 428                rdp->curlist = NULL;
> 429                rdp->curtail = &rdp->curlist;
> 430        }
> 431 
> 432        if (rdp->nxtlist && !rdp->curlist) {
> 433                local_irq_disable();
> 434                rdp->curlist = rdp->nxtlist;
> 435                rdp->curtail = rdp->nxttail;
> 436                rdp->nxtlist = NULL;
> 437                rdp->nxttail = &rdp->nxtlist;
> 438                local_irq_enable();
> 439 
> 440                /*
> 441                  * start the next batch of callbacks
> 442                  */
> 443 
> 444                /* determine batch number */
> 445                rdp->batch = rcp->cur + 1;
> 446                /* see the comment and corresponding wmb() in
> 447                  * the rcu_start_batch()
> 448                  */
> 449                smp_rmb();
> 450 
> 451                if (!rcp->next_pending) {
> 452                        /* and start it/schedule start if it's a new batch */
> 453                        spin_lock(&rcp->lock);
> 454                        rcp->next_pending = 1;
> 455                        rcu_start_batch(rcp);
> 456                        spin_unlock(&rcp->lock);
> 457                }
> 458        }
> 459 
> 460        rcu_check_quiescent_state(rcp, rdp);
> 461        if (rdp->donelist)
> 462                rcu_do_batch(rdp);
> 463 }
> 
> 
> The question is how does the update of rdp->batch at line 445 guarantee to observe the most updated value of rcp->cur??
> The issue is that there is no memory barrier/locking before line 445.
> So I think the following sequence of events in chronological order is possible:
> 
> Assume initially rcp->cur = 100, this current batch value is visible to every CPU, and batch 100 has completed 
> (i.e. rcp->completed = 100, rcp->next_pending = 0,  rcp->cpumask = 0, and for each CPU, rdp->quiescbatch = 100, rdp->qs_pending = 0, rdp->passed_quiesc = 1)


> CPU 0: 
> --------- 
>              call_rcu(): a callback inserted into rdp->nxtlist;                     
> 
>              timer interrupt 
>                 call rcu_pending(), return true  ( ! rdp->curlist && rdp->nxtlist)
>                 call rcu_check_callbacks() 
>                      schedule per CPU rcu_tasklet
> 
>                 __rcu_process_callbacks()
>                            move callbacks from nxtlist to curlist;
>                            rdp->batch = 101
>                            lock rcp->lock
>                            rcp->next_pending = 1
>                            call rcu_start_batch()
>                                  find the current batch has completed and next batch pending;
>                                  rcp->next_pending = 0
>                                  update rcp->cur to 101 and initialize rcp->cpumask;                  <----- time t1
>                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>                            unlock rcp->lock
>                               
> CPU 1:
> ---------  
>              timer interrupt 
>                   call rcu_pending(), return true (asume observing rcp->cur = 101 != rdp->quiescbatch) 
>                   
>                   call rcu_check_callbacks() 
>                        schedule per CPU rcu_tasklet
> 
>                  __rcu_process_callbacks()
>                        call rcu_check_quisecent_state()
>                              find rdp->quiescbatch != rcp->cur
>                              set rdp->qs_pending = 1
>                              set rdp->passed_quiesc = 0
>                              set rdp->quiescbatch = 101 (rcp->cur)
> 
>              Another timer interrupt
>                  call rcu_pending(), return true (rdp->qs_pending == 1)  
>                  call rcu_check_callbacks() 
>                        (assume in user mode)                         <-- time t2  pass quiescent state
>                        ~~~~~~~~~~~~~~~~~~                             ~~~~~~~~~~~~~~~~~~~~~~
>                        rdp->passed_quiesc = 1
>                        schedule per CPU rcu_tasklet
>             
>                  __rcu_process_callbacks()
>                        call rcu_check_quisecent_state()
>                              find rdp->qs_pending == 1 && rdp-> passed_quiesc == 1
>                              set rdp->qs_pending = 0
>                              lock rcp->lock
>                              call cpu_quite()
>                                     clear bit in the rcp->cpumask set up by CPU 0 at time t1
>                                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>                              unlock rcp->lock
> 
> CPU 2:
> ---------  
>              call_rcu(): a callback inserted into rdp->nxtlist;     <--- time t3
>              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>              
>              timer interrupt 
>                  call rcu_pending(), return true ( ! rdp->curlist && rdp->nxtlist)
>                  call rcu_check_callbacks() 
>                       schedule per CPU rcu_tasklet

The tasklet_schedule() code calls test_and_set_bit(), which is an
atomic operation that returns a value.  It therefore implies a memory
barrier, so that if the prior call_rcu() at time t3 "happens after"
CPU 1's quiescent state at time t2 (which, due to locking, must follow
the update to rcp->cur at time t1), then the access to rcp->cur at time
t4 must see the new value of rcp->cur.

This is admittedly a bit subtle and perhaps a bit fragile.  Manfred,
Dipankar, would it be worth putting an explicit memory barrier somewhere
in this sequence, or is there another memory barrier that I forgetting?

							Thanx, Paul

>                  calls __rcu_process_callbacks()
>                      move callbacks from nxtlist to curlist; (including the callback inserted at time t3)
>                      rdp->batch = rcp->cur + 1;                         <--- time t4
>                      ~~~~~~~~~~~~~~~~~~~~
> 
> At time t4, CPU 2 might observe rcp->cpu as 100 and set rdp->batch to 101.
> So CPU 2 essentially started its batch 101 (includes a callback inserted at time t3) after CPU 1 passed its quiescent state (at time t2) for batch 101.
> 
> Isn't this an issue???  Am I missing something?
> Thanks for pointing me to the right direction.
> 
> 
> -- James Huang
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
