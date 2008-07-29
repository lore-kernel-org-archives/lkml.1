Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbYG2MSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbYG2MSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 08:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756620AbYG2MR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 08:17:59 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:50630 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002AbYG2MR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 08:17:58 -0400
Date: Tue, 29 Jul 2008 16:21:12 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Q: wait_task_inactive() and !CONFIG_SMP && CONFIG_PREEMPT
Message-ID: <20080729122010.GB177@tv-sign.ru>
References: <200807260245.m6Q2jwB4012297@imap1.linux-foundation.org> <20080727121540.GB178@tv-sign.ru> <20080727200551.D3F6A154284@magilla.localdomain> <20080728125704.GA98@tv-sign.ru> <20080728233915.0D00015427E@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728233915.0D00015427E@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28, Roland McGrath wrote:
>
> I can't speak to the kthread case.  I suspect that set_task_cpu() is always
> safe on !SMP PREEMPT, and that's why it's fine.

Yes, kthread_bind() is fine, it changes nothing in *k if !SMP.

> > I refer to this patch of the comment:
> > 
> > 	If a second call a short while later returns the same number, the
> > 	caller can be sure that @p has remained unscheduled the whole time.
> > 
> > The dummy version always returns the same number == 1.
> 
> Right.  For the general case where this is the contract wait_task_inactive
> is expected to meet, it does matter.  I think task_current_syscall() does
> want this checked for the preempted uniprocessor case, for example.
> 
> > So. I think that wait_task_inactive() needs "defined(SMP) || defined(PREEMPT)"
> > and the dummy version should return ->nvcsw too.
> 
> Is this what we want?
> 
> 	#ifdef CONFIG_SMP
> 	extern unsigned long wait_task_inactive(struct task_struct *, long);
> 	#else
> 	static inline unsigned long wait_task_inactive(struct task_struct *p,
> 						       long match_state)
> 	{
> 		unsigned long ret = 0;
> 		if (match_state) {
> 			preempt_disable();
> 			if (p->state == match_state)
> 				ret = (p->nvcsw << 1) | 1;
> 			preempt_enable();
> 		}
> 		return ret;
> 	}
> 	#endif

I dont think this is right.

Firstly, the above always fails if match_state == 0, this is not right.

But more importantly, we can't just check ->state == match_state. And
preempt_disable() buys nothing.

Let's look at task_current_syscall(). The "target" can set, say,
TASK_UNINTERRUPTIBLE many times, do a lot of syscalls, and not once
call schedule().

And the task remains fully preemptible even if it runs in
TASK_UNINTERRUPTIBLE state.


Let's suppose we implement kthread_set_nice() in the same manner
as kthread_bind(),

	kthread_set_nice(struct task_struct *k, long nice)
	{
		wait_task_inactive(k, TASK_UNINTERRUPTIBLE);

		... just change ->prio/static_prio ...
	}

the above is ugly of course, but should be correct correct even
with !SMP && PREEMPT.


I think we need

	#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT)
	extern unsigned long wait_task_inactive(struct task_struct *, long);
	#else
	static inline unsigned long wait_task_inactive(struct task_struct *p,
							long match_state)
	{
		if (match_state && p->state != match_state)
			return 0;
		return p->nvcsw | (LONG_MAX + 1); // the same in sched.c
	}

Oleg.

