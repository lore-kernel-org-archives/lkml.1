Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYFCM7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYFCM7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 08:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbYFCM67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 08:58:59 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:50822 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbYFCM66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 08:58:58 -0400
Date: Tue, 3 Jun 2008 06:58:42 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: down_killable() is racy? or schedule() is not right?
Message-ID: <20080603125842.GB8434@parisc-linux.org>
References: <20080603123309.GA472@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603123309.GA472@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 04:33:09PM +0400, Oleg Nesterov wrote:
> I just noticed we have generic semaphores, a couple of questions.
> 
> 	down():
> 
> 		spin_lock_irqsave(&sem->lock, flags);
> 		...
> 		__down(sem);
> 
> Why _irqsave ? we must not do down() with irqs disabled, and of course
> __down() restores/clears irqs unconditionally.

How about reading the fine comments?

I would paste it, but Debian has fucked up my X copy and paste.  Line 13
of kernel/semaphore.c.

> 	__down_common(TASK_KILLABLE):
> 
> 			if (state == TASK_KILLABLE && fatal_signal_pending(task))
> 				goto interrupted;
> 
> 			/* --- WINDOW --- */
> 
> 			__set_task_state(task, TASK_KILLABLE);
> 			schedule_timeout(timeout);
> 
> This looks racy. If SIGKILL comes in the WINDOW above, the event is lost.
> The task will wait for up() or timeout with the fatal signal pending, and
> it is not possible to wakeup it via kill() again.

Hmmm.  I think you're right.  But mutex.c has the same problem, then.
The wait_event_* macros get this right -- they set the task state before
they check for a signal.

> This is easy to fix, but I wonder if we should change schedule() instead.
> Note that __down_common() does 2 checks,
> 
> 		if (state == TASK_INTERRUPTIBLE && signal_pending(task))
> 			goto interrupted;
> 		if (state == TASK_KILLABLE && fatal_signal_pending(task))
> 			goto interrupted;
> 
> they look very symmetrical, but the first one is OK, and the second is racy.

Oh, because of the special casing in sched.c.  Why not just move the
__set_task_state before the checks for signals pending?  We'd have to
reset to TASK_RUNNING at the 'interrupted:' label, but that's OK.

> Also, I think we have the similar issues with lock_page_killable().

I don't think so because __wait_on_bit_lock sets the state before
checking the 'action' (sync_page_killable).

> How about something like
> 
> 	int signal_pending_state(struct task_struct *tsk)
> 	{
> 		if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
> 			return 0;
> 		if (signal_pending(tsk))
> 			return 0;
> 
> 		return (state & TASK_INTERRUPTIBLE) ||
> 			__fatal_signal_pending(tsk);
> 	}
> 
> now,
> 
> 	--- kernel/sched.c
> 	+++ kernel/sched.c
> 	@@ -4510,8 +4510,7 @@ need_resched_nonpreemptible:
> 		clear_tsk_need_resched(prev);
> 	 
> 		if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
> 	-		if (unlikely((prev->state & TASK_INTERRUPTIBLE) &&
> 	-				signal_pending(prev))) {
> 	+		if (unlikely(signal_pending_state(prev))) {
> 				prev->state = TASK_RUNNING;
> 			} else {
> 				deactivate_task(rq, prev, 1);
> 
> Thoughts?

That might be worth doing anyway, but I'd leave that up to Ingo.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
