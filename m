Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYFCQMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYFCQMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 12:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYFCQLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 12:11:55 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51438 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbYFCQLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:11:54 -0400
Date: Tue, 3 Jun 2008 20:13:38 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: down_killable() is racy? or schedule() is not right?
Message-ID: <20080603161338.GA736@tv-sign.ru>
References: <20080603123309.GA472@tv-sign.ru> <20080603125842.GB8434@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603125842.GB8434@parisc-linux.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, Matthew Wilcox wrote:
>
> On Tue, Jun 03, 2008 at 04:33:09PM +0400, Oleg Nesterov wrote:
> > 
> > Why _irqsave ? we must not do down() with irqs disabled, and of course
> > __down() restores/clears irqs unconditionally.
> 
> How about reading the fine comments?

Thanks,

> I would paste it, but Debian has fucked up my X copy and paste.  Line 13
> of kernel/semaphore.c.
> 
> > 	__down_common(TASK_KILLABLE):
> > 
> > 			if (state == TASK_KILLABLE && fatal_signal_pending(task))
> > 				goto interrupted;
> > 
> > 			/* --- WINDOW --- */
> > 
> > 			__set_task_state(task, TASK_KILLABLE);
> > 			schedule_timeout(timeout);
> > 
> > This looks racy. If SIGKILL comes in the WINDOW above, the event is lost.
> > The task will wait for up() or timeout with the fatal signal pending, and
> > it is not possible to wakeup it via kill() again.
> 
> Hmmm.  I think you're right.  But mutex.c has the same problem, then.

and do_wait_for_common()

> > This is easy to fix, but I wonder if we should change schedule() instead.
> > Note that __down_common() does 2 checks,
> > 
> > 		if (state == TASK_INTERRUPTIBLE && signal_pending(task))
> > 			goto interrupted;
> > 		if (state == TASK_KILLABLE && fatal_signal_pending(task))
> > 			goto interrupted;
> > 
> > they look very symmetrical, but the first one is OK, and the second is racy.
> 
> Oh, because of the special casing in sched.c.  Why not just move the
> __set_task_state before the checks for signals pending?

Yes sure, this all is fixeable (we need set_task_state() of course).

But please compare

	current->state = TASK_INTERRUPTIBLE;
	schedule();
and
	current->state = TASK_KILLABLE;
	schedule();

it seems to me that it is not nice they behave "differently".

> > Also, I think we have the similar issues with lock_page_killable().
>
> I don't think so because __wait_on_bit_lock sets the state before
> checking the 'action' (sync_page_killable).

You are right.

> > 	int signal_pending_state(struct task_struct *tsk)
> > 	{
> > 		if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
> > 			return 0;
> > 		if (signal_pending(tsk))
> > 			return 0;
> > 
> > 		return (state & TASK_INTERRUPTIBLE) ||
> > 			__fatal_signal_pending(tsk);
> > 	}
> > 
> > now,
> > 
> > 	--- kernel/sched.c
> > 	+++ kernel/sched.c
> > 	@@ -4510,8 +4510,7 @@ need_resched_nonpreemptible:
> > 		clear_tsk_need_resched(prev);
> > 	 
> > 		if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
> > 	-		if (unlikely((prev->state & TASK_INTERRUPTIBLE) &&
> > 	-				signal_pending(prev))) {
> > 	+		if (unlikely(signal_pending_state(prev))) {
> > 				prev->state = TASK_RUNNING;
> > 			} else {
> > 				deactivate_task(rq, prev, 1);
> > 
> > Thoughts?
> 
> That might be worth doing anyway, but I'd leave that up to Ingo.

Yes, we need Ingo's opinion ;)

Oleg.

