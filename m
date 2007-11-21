Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbXKUT5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbXKUT5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 14:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756337AbXKUT5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 14:57:34 -0500
Received: from web83814.mail.sp1.yahoo.com ([69.147.85.91]:31236 "HELO
	web83814.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756314AbXKUT5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 14:57:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=ilf0ACOVWFWBlpDswDzE1zL3niZMT78rs4tRYu9tUebaTlQ/sx07xghbnHIba4Wq/rDTcGVtdYjeVR3LQK06S7mJMaPIjk0S1HOsHLi97OlTHu1PJPxMHman1GYejuHKc+b1cHze4cfqSU/XTec8LoXMBBf39Qras9odbltfWq0=;
X-Mailer: YahooMailRC/818.27 YahooMailWebService/0.7.152
Date: Wed, 21 Nov 2007 11:57:29 -0800 (PST)
From: James Huang <jamesclhuang@yahoo.com>
Subject: Re: __rcu_process_callbacks() in Linux 2.6
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, james.huang@watchguard.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <477946.24133.qm@web83814.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

       I am not sure I understand your answer about using test_and_set_bit() in tasklet_schedule() as a 
memory barrier in this case.
 
       Yes, tasklet_schedule() includes a test_and_set_bit(TASKLET_STATE_SCHED, &t->state) on a tasklet, but 
in this case the tasklet is a per CPU tasklet.
 
       According to documentation/atomic_ops.txt, atomic op that returns a value has the semantics of 
"explicit memory barriers performed before and after the operation".  
If I understand it correctly, this means that, for exmaple,
 
           atomic_t aa = ATOMIC_INIT(0);
           int X = 1;
           int Y = 2;
 
 CPU 0:
          update X=100;
          atomc_inc_return(&aa);
          update Y=200;
 
Then CPU 1 will always see X=100 before it sees the new value of aa (1), and CPU 1 wil always 
see the new value of aa (1) before it sees Y=200.
 
This ordering semantics does not apply to the scenario in our discussion.
For one thing, the rcu tasklet is a per CPU tasklet.  So obviously no other CPU's will even read its t->state.    
 
Am I still missing something?
By the way, which tasklet_schedule() are you referring to in your previous email? 
Is it the one called by CPU 0, CPU 1, or CPU 2?
 

Thanks,
James Huang



----- Original Message ----
From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
To: James Huang <jamesclhuang@yahoo.com>
Cc: linux-kernel@vger.kernel.org; manfred@colorfullife.com; dipankar@in.ibm.com
Sent: Wednesday, November 21, 2007 8:54:15 AM
Subject: Re: __rcu_process_callbacks() in Linux 2.6

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
>                call rcu_pending(), return true  ( ! rdp->curlist && rdp->nxtlist)
>                call rcu_check_callbacks() 
>                      schedule per CPU rcu_tasklet
> 
>                __rcu_process_callbacks()
>                            move callbacks from nxtlist to curlist;
>                            rdp->batch = 101
>                            lock rcp->lock
>                            rcp->next_pending = 1
>                            call rcu_start_batch()
>                                  find the current batch has completed and next batch pending;
>                                  rcp->next_pending = 0
>                                  update rcp->cur to 101 and initialize rcp->cpumask;                  <----- time t1
>                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>                            unlock rcp->lock
>                              
> CPU 1:
> ---------  
>              timer interrupt 
>                  call rcu_pending(), return true (asume observing rcp->cur = 101 != rdp->quiescbatch) 
>                  
>                  call rcu_check_callbacks() 
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
>                        (assume in user mode)                        <-- time t2  pass quiescent state
>                        ~~~~~~~~~~~~~~~~~~                            ~~~~~~~~~~~~~~~~~~~~~~
>                        rdp->passed_quiesc = 1
>                        schedule per CPU rcu_tasklet
>            
>                  __rcu_process_callbacks()
>                        call rcu_check_quisecent_state()
>                              find rdp->qs_pending == 1 && rdp-> passed_quiesc == 1
>                              set rdp->qs_pending = 0
>                              lock rcp->lock
>                              call cpu_quite()
>                                    clear bit in the rcp->cpumask set up by CPU 0 at time t1
>                                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>                              unlock rcp->lock
> 
> CPU 2:
> ---------  
>              call_rcu(): a callback inserted into rdp->nxtlist;    <--- time t3
>              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>              
>              timer interrupt 
>                  call rcu_pending(), return true ( ! rdp->curlist && rdp->nxtlist)
>                  call rcu_check_callbacks() 
>                      schedule per CPU rcu_tasklet

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
>                      rdp->batch = rcp->cur + 1;                        <--- time t4
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
