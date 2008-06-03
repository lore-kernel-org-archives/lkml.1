Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYFCMbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYFCMbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 08:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYFCMbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 08:31:39 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:39558 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbYFCMbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 08:31:39 -0400
Date: Tue, 3 Jun 2008 16:33:09 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Q: down_killable() is racy? or schedule() is not right?
Message-ID: <20080603123309.GA472@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just noticed we have generic semaphores, a couple of questions.

	down():

		spin_lock_irqsave(&sem->lock, flags);
		...
		__down(sem);

Why _irqsave ? we must not do down() with irqs disabled, and of course
__down() restores/clears irqs unconditionally.


Another question,

	__down_common(TASK_KILLABLE):

			if (state == TASK_KILLABLE && fatal_signal_pending(task))
				goto interrupted;

			/* --- WINDOW --- */

			__set_task_state(task, TASK_KILLABLE);
			schedule_timeout(timeout);

This looks racy. If SIGKILL comes in the WINDOW above, the event is lost.
The task will wait for up() or timeout with the fatal signal pending, and
it is not possible to wakeup it via kill() again.

This is easy to fix, but I wonder if we should change schedule() instead.
Note that __down_common() does 2 checks,

		if (state == TASK_INTERRUPTIBLE && signal_pending(task))
			goto interrupted;
		if (state == TASK_KILLABLE && fatal_signal_pending(task))
			goto interrupted;

they look very symmetrical, but the first one is OK, and the second is racy.
Also, I think we have the similar issues with lock_page_killable().

How about something like

	int signal_pending_state(struct task_struct *tsk)
	{
		if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
			return 0;
		if (signal_pending(tsk))
			return 0;

		return (state & TASK_INTERRUPTIBLE) ||
			__fatal_signal_pending(tsk);
	}

now,

	--- kernel/sched.c
	+++ kernel/sched.c
	@@ -4510,8 +4510,7 @@ need_resched_nonpreemptible:
		clear_tsk_need_resched(prev);
	 
		if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
	-		if (unlikely((prev->state & TASK_INTERRUPTIBLE) &&
	-				signal_pending(prev))) {
	+		if (unlikely(signal_pending_state(prev))) {
				prev->state = TASK_RUNNING;
			} else {
				deactivate_task(rq, prev, 1);

Thoughts?

Oleg.

