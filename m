Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbXKUD1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbXKUD1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 22:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbXKUD1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 22:27:14 -0500
Received: from web83822.mail.sp1.yahoo.com ([69.147.85.107]:37446 "HELO
	web83822.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752173AbXKUD1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 22:27:13 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2007 22:27:13 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=iUpbT4n2idm3M35vJTFu4NUuAmeSq6KQqfy8LY905QG/Tum0TveNIrJ8TSkOLcPQLiU67JXTE/XmTBGrv24kfgfd8U4Fey/EgLPLBbyUNXky5nnsDmxfNY6B/nOKK6gmn2HcJHnvntmrTS4pD8gOLuOeSEIKI3FsjVPs2a/2iyo=;
X-YMail-OSG: wykatqcVM1nPOdldkuDSg2JXaoch211ESE88UOjcLv9qXbi7DsKaGF41hIisSwhvxA--
X-Mailer: YahooMailRC/818.27 YahooMailWebService/0.7.152
Date: Tue, 20 Nov 2007 19:20:32 -0800 (PST)
From: James Huang <jamesclhuang@yahoo.com>
Subject: __rcu_process_callbacks() in Linux 2.6
To: linux-kernel@vger.kernel.org
Cc: jamesclhuang@yahoo.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <758494.32456.qm@web83822.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In the latest Linux 2.6 RCU implementation, __rcu_process_callbacks() is coded as follows: 


422 static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
423                                        struct rcu_data *rdp)
424 {
425        if (rdp->curlist && !rcu_batch_before(rcp->completed, rdp->batch)) {
426                *rdp->donetail = rdp->curlist;
427                rdp->donetail = rdp->curtail;
428                rdp->curlist = NULL;
429                rdp->curtail = &rdp->curlist;
430        }
431 
432        if (rdp->nxtlist && !rdp->curlist) {
433                local_irq_disable();
434                rdp->curlist = rdp->nxtlist;
435                rdp->curtail = rdp->nxttail;
436                rdp->nxtlist = NULL;
437                rdp->nxttail = &rdp->nxtlist;
438                local_irq_enable();
439 
440                /*
441                  * start the next batch of callbacks
442                  */
443 
444                /* determine batch number */
445                rdp->batch = rcp->cur + 1;
446                /* see the comment and corresponding wmb() in
447                  * the rcu_start_batch()
448                  */
449                smp_rmb();
450 
451                if (!rcp->next_pending) {
452                        /* and start it/schedule start if it's a new batch */
453                        spin_lock(&rcp->lock);
454                        rcp->next_pending = 1;
455                        rcu_start_batch(rcp);
456                        spin_unlock(&rcp->lock);
457                }
458        }
459 
460        rcu_check_quiescent_state(rcp, rdp);
461        if (rdp->donelist)
462                rcu_do_batch(rdp);
463 }


The question is how does the update of rdp->batch at line 445 guarantee to observe the most updated value of rcp->cur??
The issue is that there is no memory barrier/locking before line 445.
So I think the following sequence of events in chronological order is possible:

Assume initially rcp->cur = 100, this current batch value is visible to every CPU, and batch 100 has completed.
 
 
CPU 0: 
--------- 
             call_rcu(): a callback inserted into rdp->nxtlist;                     
 
             timer interrupt 
                call rcu_pending(), return true  ( ! rdp->curlist && rdp->nxtlist)
                call rcu_check_callbacks() 
                     schedule per CPU rcu_tasklet
 
                __rcu_process_callbacks()
                           move callbacks from nxtlist to curlist;
                           rdp->batch = 101
                           lock rcp->lock
                           rcp->next_pending = 1
                           call rcu_start_batch()
                                 find the current batch has completed and next batch pending;
                                 rcp->next_pending = 0
                                 update rcp->cur to 101 and initialize rcp->cpumask;                  <----- time t1
                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                           unlock rcp->lock
                              
CPU 1:
---------  
             timer interrupt 
                  call rcu_pending(), return true (asume observing rcp->cur = 101 != rdp->quiescbatch) 
                  
                  call rcu_check_callbacks() 
                       schedule per CPU rcu_tasklet
 
                 __rcu_process_callbacks()
                       call rcu_check_quisecent_state()
                             find rdp->quiescbatch != rcp->cur
                             set rdp->qs_pending = 1
                             set rdp->passed_quiesc = 0
                             set rdp->quiescbatch = 101 (rcp->cur)
 
             Another timer interrupt
                 call rcu_pending(), return true (rdp->qs_pending == 1)  
                 call rcu_check_callbacks() 
                       (assume in user mode)                         <-- time t2  pass quiescent state
                       ~~~~~~~~~~~~~~~~~~                           ~~~~~~~~~~~~~~~~~~~~~~
                       rdp->passed_quiesc = 1
                       schedule per CPU rcu_tasklet
            
                 __rcu_process_callbacks()
                       call rcu_check_quisecent_state()
                             find rdp->qs_pending == 1 && rdp-> passed_quiesc == 1
                             set rdp->qs_pending = 0
                             lock rcp->lock
                             call cpu_quite()
                                    clear bit in the rcp->cpumask set up by CPU 0 at time t1
                                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                             unlock rcp->lock

CPU 2:
---------  
             call_rcu(): a callback inserted into rdp->nxtlist;     <--- time t3
             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
             
             timer interrupt 
                 call rcu_pending(), return true ( ! rdp->curlist && rdp->nxtlist)
                 call rcu_check_callbacks() 
                      schedule per CPU rcu_tasklet
                                
                 calls __rcu_process_callbacks()
                     move callbacks from nxtlist to curlist; (including the callback inserted at time t3)
                     rdp->batch = rcp->cur + 1;                         <--- time t4
                     ~~~~~~~~~~~~~~~~~~~~

At time t4, CPU 2 might observe rcp->cpu as 100 and set rdp->batch to 101.
So CPU 2 essentially started its batch 101 (includes a callback inserted at time t3) after CPU 1 passed its quiescent state (at time t2) for batch 101.

Isn't this an issue???  Am I missing something?
Thanks for pointing me to the right direction.


-- James Huang
