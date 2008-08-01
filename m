Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbYHAB2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbYHAB2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 21:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYHAB2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 21:28:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbYHAB2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 21:28:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Q: wait_task_inactive() and !CONFIG_SMP && CONFIG_PREEMPT
In-Reply-To: Oleg Nesterov's message of  Tuesday, 29 July 2008 16:21:12 +0400 <20080729122010.GB177@tv-sign.ru>
References: <200807260245.m6Q2jwB4012297@imap1.linux-foundation.org>
	<20080727121540.GB178@tv-sign.ru>
	<20080727200551.D3F6A154284@magilla.localdomain>
	<20080728125704.GA98@tv-sign.ru>
	<20080728233915.0D00015427E@magilla.localdomain>
	<20080729122010.GB177@tv-sign.ru>
Emacs: Lovecraft was an optimist.
Message-Id: <20080801012747.7E17F15427E@magilla.localdomain>
Date: Thu, 31 Jul 2008 18:27:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I dont think this is right.
> 
> Firstly, the above always fails if match_state == 0, this is not right.

A call with 0 is the "legacy case", where the return value is 0 and nothing
but the traditional wait_task_inactive behavior is expected.  On UP, this
was a nop before and still is.

Anyway, this is moot since we are soon to have no callers that pass 0.

> But more importantly, we can't just check ->state == match_state. And
> preempt_disable() buys nothing.

It ensures that the samples of ->state and ->nvcsw both came while the
target could never have run in between.  Without it, a preemption after the
->state check could mean the ->nvcsw value we use is from a later block in
a different state than the one intended.

> Let's look at task_current_syscall(). The "target" can set, say,
> TASK_UNINTERRUPTIBLE many times, do a lot of syscalls, and not once
> call schedule().
> 
> And the task remains fully preemptible even if it runs in
> TASK_UNINTERRUPTIBLE state.

One of us is missing something basic.  We are on the only CPU.  If target
does *anything*, it means we got preempted, then target switched in, did
things, and then called schedule (including via preemption)--so that we
could possibly be running again now afterwards.  That schedule call bumped
the counter after we sampled it.  The second call done for "is it still
blocked afterwards?" will see a different count and abort.  Am I confused?

Ah, I think it was me who was missing something when I let you talk me into
checking only ->nvcsw.  It really should be ->nivcsw + ->nvcsw as I had it
originally (| LONG_MIN as you've done, a good trick).  That makes what I
just said true in the preemption case.  This bit:

	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {

will not hit, so switch_count = &prev->nivcsw; remains from before.
This is why it was nivcsw + nvcsw to begin with.

What am I missing here?


Thanks,
Roland
