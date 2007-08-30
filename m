Return-Path: <linux-kernel-owner+w=401wt.eu-S1758977AbXH3JMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977AbXH3JMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 05:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbXH3JMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 05:12:32 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:43687 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941AbXH3JMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 05:12:31 -0400
Date: Thu, 30 Aug 2007 13:12:54 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Aleksandar Dezelin <dezelin@gmail.com>, linux-kernel@vger.kernel.org,
       mingo <mingo@redhat.com>
Subject: Re: Possible kernel lock in semaphore's __down()
Message-ID: <20070830091254.GA303@tv-sign.ru>
References: <1188424371.8853.9.camel@synaptical> <1188458165.6112.19.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188458165.6112.19.camel@twins>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(just in case Peter's explanation was too concise)

On 08/30, Peter Zijlstra wrote:
>
> On Wed, 2007-08-29 at 23:52 +0200, Aleksandar Dezelin wrote:
> > Hi!
> > 
> > I'm a newbie here on the list and also as a "kernel hacker". There's a
> > bug reported in bugzilla (Bug 7927), cite:
> > 
> > 
> > > In the function __down
> > >  
> > > fastcall void __sched __down(struct semaphore * sem)
> > > {
> > >  struct task_struct *tsk = current;
> > >  DECLARE_WAITQUEUE(wait, tsk);
> > >  unsigned long flags;
> > >  
> > >  tsk->state = TASK_UNINTERRUPTIBLE;
> > >  spin_lock_irqsave(&sem->wait.lock, flags);
> > >  add_wait_queue_exclusive_locked(&sem->wait, &wait);
> > >  ...
> > > }
> > >  
> > > 
> > > From this code fragment, it sets the tsk->state to TASK_UNINTERRUPTIBLE before 
> > > gets the spinlock. Assume at that moment, a interrupt ocuur and and after the 
> > > interrupt handle ends, an other process is scheduled to run (assume the kernel 
> > > is preemptalbe). In this case, the previous process ( its state has set to 
> > > TASK_UNINTERRUPTIBLE) has been picked off the run queue,
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
please see below,

>                                                               and it has not yet add 
> > > to the wait queue( sem->wait ), so it may be never waited up forever. 
> > > 
> > 
> > I have marked it as rejected as as I can see at the time this function is called,
> > it is guaranteed that ret_from_intr() will not call schedule() on return from an 
> > interrupt handler to either kernel space or user space because of the call 
> > to macro might_sleep() in semaphore's down(). Am I wrong?

No, ret_from_intr() still can schedule(). Actually it does preempt_schedule_irq()
which sets PREEMPT_ACTIVE.

And, as Peter explained,

> I think the reported meant interrupt driven involuntary preemption. So
> ret_from_intr() is not the right place to look. But afaict you're still
> right, see how preempt_schedule*() adds PREEMPT_ACTIVE to the
> preempt_count, and how that makes the scheduler ignore the task state.

this is OK, because in this case schedule() doesn't remove the task from
run queue even if its state is TASK_UNINTERRUPTIBLE,

		if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
			...
			deactivate_task();
		}

note the "!(preempt_count() & PREEMPT_ACTIVE))" check. So the task is still
runnable, we don't need to wake it, it will get CPU eventually.

Oleg.

