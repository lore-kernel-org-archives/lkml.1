Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbYHALqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbYHALqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 07:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYHALqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 07:46:23 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:55691 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757249AbYHALqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 07:46:20 -0400
Date: Fri, 1 Aug 2008 15:49:54 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: Q: wait_task_inactive() and !CONFIG_SMP && CONFIG_PREEMPT
Message-ID: <20080801114954.GA76@tv-sign.ru>
References: <200807260245.m6Q2jwB4012297@imap1.linux-foundation.org> <20080727121540.GB178@tv-sign.ru> <20080727200551.D3F6A154284@magilla.localdomain> <20080728125704.GA98@tv-sign.ru> <20080728233915.0D00015427E@magilla.localdomain> <20080729122010.GB177@tv-sign.ru> <20080801012747.7E17F15427E@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801012747.7E17F15427E@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Roland McGrath wrote:
>
> > I dont think this is right.
> > 
> > Firstly, the above always fails if match_state == 0, this is not right.
>
> A call with 0 is the "legacy case", where the return value is 0 and nothing
> but the traditional wait_task_inactive behavior is expected.  On UP, this
> was a nop before and still is.
>
> Anyway, this is moot since we are soon to have no callers that pass 0.

This means we can't use wait_task_inactive(p) unless we know p->state
is already != TASK_RUNNING. OK, the current callers assume exactly this.

But perhaps we should change the state checks from "==" to "&", note
that pfm_task_incompatible() checks task_is_stopped_or_traced().

> > But more importantly, we can't just check ->state == match_state. And
> > preempt_disable() buys nothing.
> 
> It ensures that the samples of ->state and ->nvcsw both came while the
> target could never have run in between.  Without it, a preemption after the
> ->state check could mean the ->nvcsw value we use is from a later block in
> a different state than the one intended.

I meant, it buys nothing because the task can set its state == TASK_RUNNING
right after preempt_enable(), because the task can be runnable despite
the fact its state is (say) TASK_UNINTERRUPTIBLE.

Please see below.

> > Let's look at task_current_syscall(). The "target" can set, say,
> > TASK_UNINTERRUPTIBLE many times, do a lot of syscalls, and not once
> > call schedule().
> > 
> > And the task remains fully preemptible even if it runs in
> > TASK_UNINTERRUPTIBLE state.
> 
> One of us is missing something basic.  We are on the only CPU.  If target
> does *anything*, it means we got preempted, then target switched in, did
> things, and then called schedule (including via preemption)--so that we
> could possibly be running again now afterwards.  That schedule call bumped
> the counter after we sampled it.  The second call done for "is it still
> blocked afterwards?" will see a different count and abort.  Am I confused?

I think we misunderstood each other. I never said the _current_ callers have
problems (except the dummy version can't just return 1 of course).

I proposed to synchronize 2 implementations to avoid the possible problems,
and personally I still dislike the fact that !SMP version has the very
different behaviour.

But yes, if we only want to "fix" the current callers, we can make the !SMP
version

	static inline unsigned long wait_task_inactive(struct task_struct *p,
						       long match_state)
	{
		int ret = 0;

		preempt_disable();
		if (!match_state || p->state == match_state)
			ret = (p->nvcsw + p->nivcsw) | LONG_MIN;
		preempt_enable();

		return ret;
	}

> Ah, I think it was me who was missing something when I let you talk me into
> checking only ->nvcsw.  It really should be ->nivcsw + ->nvcsw as I had it
> originally (| LONG_MIN as you've done, a good trick).  That makes what I
> just said true in the preemption case.  This bit:
>
> 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
>
> will not hit, so switch_count = &prev->nivcsw; remains from before.
> This is why it was nivcsw + nvcsw to begin with.

This is fine on SMP, afaics.

More precisely, this is fine if wait_task_inactive(p) returns success only
when p->se.on_rq == 0, we shouldn't worry about preemption (nivcsw) at all.

Let's forget about the overflow, and suppose that 2 subsequent calls return
the same ->nvcsw. Every time the task leaves the runqueue (so that !.on_rq
becomes true), shedule() bumps its ->nvcsw. If the task was scheduled in
between we must notice this, because the second success means the task
was deactivate_task()'ed again.

We shouldn't look at nivcsw at all. While the task is deactivated, its
nivcsw/nvcsw can't be changed. If it is scheduled again, it must increment
->nvcsw before wait_task_inactive() can return success.

(Dmitry cc'ed to check my understanding).

Oleg.

