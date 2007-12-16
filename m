Return-Path: <linux-kernel-owner+w=401wt.eu-S934390AbXLPQXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934390AbXLPQXP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 11:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbXLPQW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 11:22:59 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:51977 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763646AbXLPQW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 11:22:58 -0500
Date: Sun, 16 Dec 2007 19:24:02 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Petr Tesarik <ptesarik@suse.cz>, Tony Luck <tony.luck@intel.com>,
       Matthew Wilcox <willy@debian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch_ptrace_stop
Message-ID: <20071216162402.GA230@tv-sign.ru>
References: <20071213172926.GA423@tv-sign.ru> <20071213224229.ED11226F8D9@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213224229.ED11226F8D9@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland, I am sorry for delay,

On 12/13, Roland McGrath wrote:
>
> > Currently ptrace_stop() schedules in TASK_TRACED state even if we have a
> > pending SIGKILL. With this patch this is still possible, but unless
> > arch_ptrace_stop_needed() is true and thus we will check sigkill_pending().
>
> Currently the siglock is always held throughout.  The case this change
> addresses is when no SIGKILL was already pending before we took the lock.
> Currently, a new SIGKILL cannot come in until we've released the lock,
> which is after we've set TASK_TRACED.  The signal's sender will hold the
> lock while checking each thread's state, waking up any in TASK_TRACED.
>
> When arch_ptrace_stop_needed() is true, we release the siglock for an
> unknown period (might block, etc).  If a SIGKILL is sent there, it becomes
> pending while we are in TASK_RUNNING or a normal blocked state.  Next we
> finish arch_ptrace_stop() and reacquire the siglock.

Yes, yes, I see.

> Now entering
> TASK_TRACED would leave us unkillable because SIGKILL is already pending
> and nothing else (except PTRACE_CONT et al) will try to wake us up.

But this doesn't differ from the case when SIGKILL was already pending when
we enter ptrace_stop, and arch_ptrace_stop_needed() == false, that was my
point.

Yes, arch_ptrace_stop() can take a long time, might block, etc. But what
about TIF_SYSCALL_TRACE ? The task can recieve SIGKILL while executing the
syscall which can also block and so on, but do_syscall_trace(entryexit == 1)
doesn't check the pending signal.

I should clarify my question. What I can't understand is the subtle dependency
on the result of arch_ptrace_stop_needed(). This means that it is hard to
predict the behaviour.

IOW, can't we

	- ignore the pending SIGKILL (current behaviour)
		-- OR --
	- always check it unconditionally, before setting TASK_TRACED

? This looks a bit more consistent to me.

Please also note "before setting TASK_TRACED" above. With this patch we set
TASK_TRACED under ->siglock, and then change the ->state to TASK_RUNNING if
killed == 1. Minor, but this doesn't look correct, we can fool the tracer
which does ptrace_check_attach().

Oleg.

