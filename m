Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbYFEPWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbYFEPWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYFEPV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:21:57 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:46609 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbYFEPV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:21:56 -0400
Date: Thu, 5 Jun 2008 19:23:13 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] schedule: fix TASK_WAKEKILL vs SIGKILL race
Message-ID: <20080605152313.GA203@tv-sign.ru>
References: <20080604170905.GA10273@tv-sign.ru> <20080604173318.GH3549@parisc-linux.org> <20080604180101.GA10295@tv-sign.ru> <20080604195232.GJ3549@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604195232.GJ3549@parisc-linux.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04, Matthew Wilcox wrote:
>
> On Wed, Jun 04, 2008 at 10:01:01PM +0400, Oleg Nesterov wrote:
> > > In my opinion, not checking for TASK_STOPPED or TASK_TRACED previously was
> > > an oversight.  This should be fixed.
> >
> > Perhaps, and the changelog has a special note. But imho we need another patch
> > for that, this is a user-visible change.
>
> It is?

Think about ptrace_notify().

Don't get me wrong. As I said, I think this change would be nice (but I didn't
think thoroughly yet), and it also allows us to cleanup (or fix?) ptrace_stop().
But with another patch, please.

> > > This patch is going to add quite a few cycles to schedule().  Has anyone
> > > done any benchmarks with a schedule-heavy workload?
> >
> > No, I didn't. This patch is bugfix.
>
> But there are other ways to fix the bug if this patch proves to be too
> heavy-weight.

If I knew a better solution, I wouldn't have sent this patch ;)

Yes, we can change all users of TASK_KILLABLE. But personally I think this
would be wrong. I strongly believe this code

	current->state = TASK_KILLABLE;
	schedule();

should work "as expected".

Btw, I don't completely agree with "quite a few cycles". Let's look at the
code again:

	int signal_pending_state(long state, struct task_struct *p)
	{
		if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
			return 0;
		if (!signal_pending(p))
			return 0;

		if (state & TASK_INTERRUPTIBLE)
			return 1;
		if (state & (__TASK_STOPPED | __TASK_TRACED))
			return 0;
		return __fatal_signal_pending(p);
	}

The fast path is "(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)) + signal_pending(p)",
basically the same that we do now. And we can inline this helper to eliminate the
function call.

But yes sure, it does bloat schedule(), and I would be happy to see the better way.
That is why I didn't send this patch immediately, but started with
"Q: down_killable() is racy? or schedule() is not right?".

> > However, I think the new helper can have other users. Not that I have a strong
> > opinion.
>
> I don't think so ...

The only part I strongly disagree with. Imho, __down_common/__mutex_lock_common/etc
should use this helper. What if we add another "interesting" state? Or find another
bug? why should we copy-and-paste this code to yet another something_new_killable() ?

Btw, if we make it inline, __down_common() won't suffer (but otoh, I think that these
_common()'s shouldn't be inline).



So. I can re-send this patch unchanged or with signal_pending_state() inlined,
or I can wait for another solution.

What do you think?

Oleg.

