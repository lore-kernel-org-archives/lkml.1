Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbXH3HQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbXH3HQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 03:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbXH3HQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 03:16:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46175 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbXH3HQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 03:16:12 -0400
Subject: Re: Possible kernel lock in semaphore's __down()
From: Peter Zijlstra <peterz@infradead.org>
To: Aleksandar Dezelin <dezelin@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo <mingo@redhat.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <1188424371.8853.9.camel@synaptical>
References: <1188424371.8853.9.camel@synaptical>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 09:16:05 +0200
Message-Id: <1188458165.6112.19.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-29 at 23:52 +0200, Aleksandar Dezelin wrote:
> Hi!
> 
> I'm a newbie here on the list and also as a "kernel hacker". There's a
> bug reported in bugzilla (Bug 7927), cite:
> 
> 
> > In the function __down
> >  
> > fastcall void __sched __down(struct semaphore * sem)
> > {
> >  struct task_struct *tsk = current;
> >  DECLARE_WAITQUEUE(wait, tsk);
> >  unsigned long flags;
> >  
> >  tsk->state = TASK_UNINTERRUPTIBLE;
> >  spin_lock_irqsave(&sem->wait.lock, flags);
> >  add_wait_queue_exclusive_locked(&sem->wait, &wait);
> >  ...
> > }
> >  
> > 
> > From this code fragment, it sets the tsk->state to TASK_UNINTERRUPTIBLE before 
> > gets the spinlock. Assume at that moment, a interrupt ocuur and and after the 
> > interrupt handle ends, an other process is scheduled to run (assume the kernel 
> > is preemptalbe). In this case, the previous process ( its state has set to 
> > TASK_UNINTERRUPTIBLE) has been picked off the run queue, and it has not yet add 
> > to the wait queue( sem->wait ), so it may be never waited up forever. 
> > 
> 
> I have marked it as rejected as as I can see at the time this function is called,
> it is guaranteed that ret_from_intr() will not call schedule() on return from an 
> interrupt handler to either kernel space or user space because of the call 
> to macro might_sleep() in semaphore's down(). Am I wrong?

I think the reported meant interrupt driven involuntary preemption. So
ret_from_intr() is not the right place to look. But afaict you're still
right, see how preempt_schedule*() adds PREEMPT_ACTIVE to the
preempt_count, and how that makes the scheduler ignore the task state.

