Return-Path: <linux-kernel-owner+w=401wt.eu-S1761463AbYFDR7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761463AbYFDR7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbYFDR7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:59:35 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:59201 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbYFDR7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:59:34 -0400
Date: Wed, 4 Jun 2008 22:01:01 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] schedule: fix TASK_WAKEKILL vs SIGKILL race
Message-ID: <20080604180101.GA10295@tv-sign.ru>
References: <20080604170905.GA10273@tv-sign.ru> <20080604173318.GH3549@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604173318.GH3549@parisc-linux.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04, Matthew Wilcox wrote:
>
> On Wed, Jun 04, 2008 at 09:09:05PM +0400, Oleg Nesterov wrote:
> > Note this "__TASK_STOPPED | __TASK_TRACED" check in signal_pending_state().
> > Probably it would be better to remove it, but this will change the current
> > behaviour and thus needs a separate discussion.
>
> We're changing the behaviour anyway.  Let's have the discussion and get
> it right.
>
> In my opinion, not checking for TASK_STOPPED or TASK_TRACED previously was
> an oversight.  This should be fixed.

Perhaps, and the changelog has a special note. But imho we need another patch
for that, this is a user-visible change.

> > +int signal_pending_state(long state, struct task_struct *p)
> > +{
> > +	if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
> > +		return 0;
> > +	if (!signal_pending(p))
> > +		return 0;
> > +
> > +	if (state & TASK_INTERRUPTIBLE)
> > +		return 1;
> > +	if (state & (__TASK_STOPPED | __TASK_TRACED))
> > +		return 0;
>
> Just deleting the above two lines should do it?

Yes.

> >  	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
> > -		if (unlikely((prev->state & TASK_INTERRUPTIBLE) &&
> > -				signal_pending(prev))) {
> > +		if (unlikely(signal_pending_state(prev->state, prev)))
> >  			prev->state = TASK_RUNNING;
> > -		} else {
> > +		else
> >  			deactivate_task(rq, prev, 1);
> > -		}
> 
> Getting rid of the extra braces is against CodingStyle:
> 
>   Do not unnecessarily use braces where a single statement will do.
> 
>   if (condition)
>           action();
> 
>   This does not apply if one branch of a conditional statement is a single
>   statement. Use braces in both branches.
> 
>   if (condition) {
>           do_this();
>           do_that();
>   } else {
>           otherwise();
>   }

With this patch the code is

		if (unlikely(signal_pending_state(prev->state, prev)))
			prev->state = TASK_RUNNING;
		else
			deactivate_task(rq, prev, 1);

> This patch is going to add quite a few cycles to schedule().  Has anyone
> done any benchmarks with a schedule-heavy workload?

No, I didn't. This patch is bugfix.

> I don't think signal_pending_state() should be in signal.c, just put it
> in sched.c along with its only caller.  That way, gcc can choose to
> inline it if that's more efficient.

Perhaps you are right. In that case it doesn't need the "long state" argument.

However, I think the new helper can have other users. Not that I have a strong
opinion.

Oleg.

