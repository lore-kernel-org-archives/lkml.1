Return-Path: <linux-kernel-owner+w=401wt.eu-S1764290AbYHAV1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764290AbYHAV1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760711AbYHAVXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:23:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111AbYHAVXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:23:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: Q: wait_task_inactive() and !CONFIG_SMP && CONFIG_PREEMPT
In-Reply-To: Oleg Nesterov's message of  Friday, 1 August 2008 15:49:54 +0400 <20080801114954.GA76@tv-sign.ru>
References: <200807260245.m6Q2jwB4012297@imap1.linux-foundation.org>
	<20080727121540.GB178@tv-sign.ru>
	<20080727200551.D3F6A154284@magilla.localdomain>
	<20080728125704.GA98@tv-sign.ru>
	<20080728233915.0D00015427E@magilla.localdomain>
	<20080729122010.GB177@tv-sign.ru>
	<20080801012747.7E17F15427E@magilla.localdomain>
	<20080801114954.GA76@tv-sign.ru>
X-Windows: graphics hacking :: Roman numerals : sqrt (pi)
Message-Id: <20080801212254.F3E0C154252@magilla.localdomain>
Date: Fri,  1 Aug 2008 14:22:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This means we can't use wait_task_inactive(p) unless we know p->state
> is already != TASK_RUNNING. OK, the current callers assume exactly this.

Correct.

> But perhaps we should change the state checks from "==" to "&", note
> that pfm_task_incompatible() checks task_is_stopped_or_traced().

No, the intent is "not changed at all", not "in some acceptable state".  So
the caller should sample ->state, decide that value is ok, and pass that
same value in.  Then wait_task_inactive succeeds only if exactly that value
stayed in place and the target got off the CPU.  (If it came out and went
back into the exact same state before we got into wait_task_inactive, we
don't really care.  The callers have outside means to know that either is
good enough for their purposes, or is impossible.)

> I meant, it buys nothing because the task can set its state == TASK_RUNNING
> right after preempt_enable(), because the task can be runnable despite
> the fact its state is (say) TASK_UNINTERRUPTIBLE.

Right, but we don't care about that.  The predicate really is "says
expected ->state, and is off the CPU", not "... and is not runnable".

> I think we misunderstood each other. I never said the _current_ callers have
> problems (except the dummy version can't just return 1 of course).

Callers like the current ones are the only reasons we have this function.
Its only purpose is to meet those needs.  If those requirements are not as
strong as a "generic" specification of what the function does, then we can
just change the specification.

> I proposed to synchronize 2 implementations to avoid the possible problems,
> and personally I still dislike the fact that !SMP version has the very
> different behaviour.

It's only "very different" if what you call its "behavior" is an abstract
specification based on what the SMP version happens to do, rather than
saying "its behavior" is just to meet the guarantees I set out earlier.
Meeting those guarantees is what the function is for.  So it should do the
cheapest thing to satisfies them in each configuration.

> But yes, if we only want to "fix" the current callers, we can make the !SMP
> version
[...]
> 		int ret = 0;

unsigned long

> 
> 		preempt_disable();
> 		if (!match_state || p->state == match_state)
> 			ret = (p->nvcsw + p->nivcsw) | LONG_MIN;
> 		preempt_enable();

In the !match_state case (nearly moot now anyway), there's no need to set
the return value.  Callers passing 0 never expected a return value.

> This is fine on SMP, afaics.
> 
> More precisely, this is fine if wait_task_inactive(p) returns success only
> when p->se.on_rq == 0, we shouldn't worry about preemption (nivcsw) at all.

Ok.  I was looking at the !SMP PREEMPT context when I said that.  I don't
dispute your rationale about the SMP case; it relies on scheduler innards
that I don't know at all well.


Thanks,
Roland
