Return-Path: <linux-kernel-owner+w=401wt.eu-S934018AbXLMWmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018AbXLMWmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762780AbXLMWmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:42:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759911AbXLMWmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:42:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Petr Tesarik <ptesarik@suse.cz>, Tony Luck <tony.luck@intel.com>,
       Matthew Wilcox <willy@debian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch_ptrace_stop
In-Reply-To: Oleg Nesterov's message of  Thursday, 13 December 2007 20:29:26 +0300 <20071213172926.GA423@tv-sign.ru>
References: <20071213172926.GA423@tv-sign.ru>
X-Windows: putting new limits on productivity.
Message-Id: <20071213224229.ED11226F8D9@magilla.localdomain>
Date: Thu, 13 Dec 2007 14:42:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How is it possible that SIGKILL is blocked?

It is probably not possible here.  It's impossible for normal user threads,
and kernel threads or ones doing something weird inside the kernel can
probably never get here.  But I'm just not trying to rely on any fancy
guarantees here.  In this change I'm being conservative in just matching
the low-level logic that affects get_signal_to_deliver directly.  I'd
prefer to get this in place now, where it's easy to be sure it's correct
vis a vis current behavior.  Later on we can convince ourselves about the
correctness of simplifications to clean the logic up.

> Could you please explain this change in more details?

I'm glad to.  I appreciate the review.

> Currently ptrace_stop() schedules in TASK_TRACED state even if we have a
> pending SIGKILL. With this patch this is still possible, but unless
> arch_ptrace_stop_needed() is true and thus we will check sigkill_pending().

Currently the siglock is always held throughout.  The case this change
addresses is when no SIGKILL was already pending before we took the lock.
Currently, a new SIGKILL cannot come in until we've released the lock,
which is after we've set TASK_TRACED.  The signal's sender will hold the
lock while checking each thread's state, waking up any in TASK_TRACED.

When arch_ptrace_stop_needed() is true, we release the siglock for an
unknown period (might block, etc).  If a SIGKILL is sent there, it becomes
pending while we are in TASK_RUNNING or a normal blocked state.  Next we
finish arch_ptrace_stop() and reacquire the siglock.  Now entering
TASK_TRACED would leave us unkillable because SIGKILL is already pending
and nothing else (except PTRACE_CONT et al) will try to wake us up.

This was tested on ia64 by inserting an explicit sleep in arch_ptrace_stop
to simulate a very long block in a page fault, and then sending SIGKILL in
this interval.  It was verified that this left the thread unkillable, and
that the sigkill_pending() check fixed that.

> Suppose the task was SIGKILL'ed and does ptrace_notify(PTRACE_EVENT_EXIT),
> now the resulting action depends on arch_ptrace_stop_needed().

For a SIGKILL that caused the exit to happen, then that SIGKILL was already
dequeued and is no longer pending by the time we get here, so nothing is
different.  

For a new SIGKILL racing with an exit already in progress, then either it
comes before ptrace_notify(PTRACE_EVENT_EXIT) has taken the siglock, or
after it's released it (in ptrace_stop).  If it comes after ptrace_stop
releases the siglock, then it wakes the thread up from that ptrace stop.
If it comes before ptrace_notify takes the siglock, then the thread stops
anyway with a pending SIGKILL.  (That may be a problem, but it is not new.
We can discuss that case separately.)

The new third possibility is that it comes after ptrace_stop releases the
siglock to call arch_ptrace_stop.  Then the new code will notice the
pending SIGKILL and skip the stop.  The only way this differs from the
SIGKILL having arrived immediately after the stop is that the parent
SIGCHLD/wait notification with CLD_TRAPPED didn't happen.  It's a race for
the parent even to notice that, since exit_code and the queued SIGCHLD's
siginfo_t will very quickly be replaced by the fresh notification sent for
the child's death.

> I don't claim this is wrong, just trying to understand.

I don't claim the logic is now perfect, just that this change is better for
the case it's intended for and not materially worse for others.  We can
certainly do more to clean things up.  But I don't want that complex
subject to delay the fixing and cleaning up of ia64 that this change
enables.


Thanks,
Roland
