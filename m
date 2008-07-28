Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116AbYG1XkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbYG1XkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 19:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYG1Xju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 19:39:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbYG1Xjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 19:39:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Q: wait_task_inactive() and !CONFIG_SMP && CONFIG_PREEMPT
In-Reply-To: Oleg Nesterov's message of  Monday, 28 July 2008 16:57:04 +0400 <20080728125704.GA98@tv-sign.ru>
References: <200807260245.m6Q2jwB4012297@imap1.linux-foundation.org>
	<20080727121540.GB178@tv-sign.ru>
	<20080727200551.D3F6A154284@magilla.localdomain>
	<20080728125704.GA98@tv-sign.ru>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080728233915.0D00015427E@magilla.localdomain>
Date: Mon, 28 Jul 2008 16:39:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If it is preempted by the parent which does ptrace_check_attach(),
> wait_task_inactive() must wait until the child leaves the runqueue,
> but the dummy version just returns success.

I see your point.

> sys_ptrace() continues assuming that the child sleeps in TASK_TRACED,
> while it fact it is running, despite its ->state == TASK_TRACED.

For ptrace, the only real expectation has ever been that it's no longer on
the physical CPU, i.e. we are not racing with context switch itself.  On a
uniprocessor, this can of course never happen.

The historical picture is that the preemption issue wasn't thought about
much.  ptrace has always used lock_kernel(), and mostly this implied
disabling preemption anyway (there was CONFIG_PREEMPT_BKL for a while).
So it's moot there.

Even if preemption were an issue for ptrace, it's not a problem.  All that
matters is that the tracee is not going to run any code that changes the
thread machine state ptrace accesses (pt_regs, thread.foo, etc).  If ptrace
gets preempted, the tracee gets switched in, gets switched back out, and
the ptrace-calling thread switched back in, there is no problem.  All the
flutter on the kernel memory ptrace might touch took place during the
context switches themselves, and every byte was back in the same place
between when ptrace got preempted and when it resumed its next instruction.

I can't speak to the kthread case.  I suspect that set_task_cpu() is always
safe on !SMP PREEMPT, and that's why it's fine.  But I'm not really sure.

> I refer to this patch of the comment:
> 
> 	If a second call a short while later returns the same number, the
> 	caller can be sure that @p has remained unscheduled the whole time.
> 
> The dummy version always returns the same number == 1.

Right.  For the general case where this is the contract wait_task_inactive
is expected to meet, it does matter.  I think task_current_syscall() does
want this checked for the preempted uniprocessor case, for example.

> So. I think that wait_task_inactive() needs "defined(SMP) || defined(PREEMPT)"
> and the dummy version should return ->nvcsw too.

Is this what we want?

	#ifdef CONFIG_SMP
	extern unsigned long wait_task_inactive(struct task_struct *, long);
	#else
	static inline unsigned long wait_task_inactive(struct task_struct *p,
						       long match_state)
	{
		unsigned long ret = 0;
		if (match_state) {
			preempt_disable();
			if (p->state == match_state)
				ret = (p->nvcsw << 1) | 1;
			preempt_enable();
		}
		return ret;
	}
	#endif


Thanks,
Roland
