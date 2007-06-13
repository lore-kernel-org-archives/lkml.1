Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbXFMWx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbXFMWx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 18:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXFMWxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 18:53:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216AbXFMWxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 18:53:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel internal errnos
In-Reply-To: Oleg Nesterov's message of  Wednesday, 13 June 2007 19:15:30 +0400 <20070613151530.GA232@tv-sign.ru>
X-Windows: you'd better sit down.
Message-Id: <20070613225307.A1C3B4D059F@magilla.localdomain>
Date: Wed, 13 Jun 2007 15:53:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This breaks cancel_freezing(). Somehow we should clear TIF_SIGPENDING for
> kernel threads. Otherwise we may have subtle failures if try_to_freeze_tasks()
> fails.

Ok.

> Also, whith this change do_sigaction()->recalc_sigpending_and_wake() doesn't
> make sense any longer, yes?

Yes.  As we discussed at the time, it was my idea of the most conservative
fix to make it recalc_sigpending_and_wake there instead of just dropping
the recalc_sigpending_tsk call.  That is, any subtle perturbations of
behavior from a place where TIF_SIGPENDING had been cleared before and now
no longer would be; either would be correct, but applications do not always
limit themselves to relying on the stated guarantees.  But that was before
considering the -ERESTART* issue, which made me realize that we must rule
out clearing someone else's TIF_SIGPENDING across the board to prevent that
other class of actual bugs.  So now there is no reason whatsoever to keep
the call in do_sigaction.

> In theory, flush_signals(t) needs a similar change. However, it is always
> called with t == current. Perhaps it makes sense to make it flush_signals(void) ?
> Do you see any valid usage of flush_signals(t) when t != current ?

I can't really imagine one, no.  In fact, I don't think flush_signals is
something that really makes sense to have exported and used in the way that
it is.

> (Actually, imho the same is true for dequeue_signal(). Except for signalfd.c
>  dequeue_signal() should operate on current. Perhaps it would be a bit cleaner
>  to have dequeue_signal_tsk(tsk) and dequeue_signal(void), the latter does
>  recalc_sigpending).

I would be happier if none of these things were exported as they are now
nor called directly from anywhere but the core signals code and kthread
setup code.  If signalfd is a new core thing, it should be integrated well
with the signals code, rearranging internal calls as necessary to make that
clean.

The kernel thread uses of flush_signals seem to be just the simplified
variant of how kernel threads use dequeue_signal.  If all you want is to
wake up an interruptible wait, you don't actually need to queue a signal.
You just need to set TIF_SIGPENDING on your kernel thread.  With the recent
changes you can rely on no other thread ever clearing it, so it just needs
to clear it after waking up.  We can support that with a simplified
interface so callers just use:

	if (kthread_interrupted())
		... bail out ...;

and:

	kthread_interrupt(my_kthread);

Similarly, dequeue_signal is used by kernel threads just to get the signal
number and siginfo_t they were sent.  I don't know how many of these uses
actually care what the signal was, or if it's ever a signal sent by some
normal kill call instead of an internal wakeup.  Perhaps all they need is:

	if (kthread_interrupted(&info)) {
		... pay attention to info.si_signo et al ...
	}

and perhaps:

	kthread_interrupt(my_kthread, &info);

with NULL arguments for the simplified semantics of the first example.
This would get kernel thread code out of the business of knowing directly
about the siglock and all.


Thanks,
Roland
