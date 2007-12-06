Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbXLFQVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbXLFQVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbXLFQVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:21:30 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:40979 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbXLFQV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:21:29 -0500
Date: Thu, 6 Dec 2007 19:22:07 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix group stop with exit race
Message-ID: <20071206162207.GA7378@tv-sign.ru>
References: <20071205173028.GA3745@tv-sign.ru> <Pine.LNX.4.64.0712051704590.6288@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712051704590.6288@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05, Davide Libenzi wrote:
>
> On Wed, 5 Dec 2007, Oleg Nesterov wrote:
>
> > do_signal_stop() counts all sub-thread and sets ->group_stop_count accordingly.
> > Every thread should decrement ->group_stop_count and stop, the last one should
> > notify the parent.
> >
> > However a sub-thread can exit before it notices the signal_pending(), or it may
> > be somewhere in do_exit() already. In that case the group stop never finishes
> > properly.
> >
> > Note: this is a minimal fix, we can add some optimizations later. Say we can
> > return quickly if thread_group_empty(). Also, we can move some signal related
> > code from exit_notify() to exit_signals().
> >
> > Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
>
> Looks OK for me, even though we're doing more work on the exit path. OTOH
> I don't see a non-racy way of doing it w/out grabbing the lock. Did you
> try to bench how much this change costs?

Yes, you are right, this unconditional spin_lock() is not good, especially for
exit_group/exec.

But please look at the next patch I am sending, it removes the pessimization
almost completely.

The only difference: when there is no group exit in progress, we are doing

	spin_lock_irq(siglock);
	if (!signal_pending()) {
		unlock and return
	}

while the current code does

	if (!signal_pending())
		return;
	spin_lock_irq(siglock);
	...

It would be nice to measure the difference, but I can't invent the test-case.

I tested (just in case) 100000 fork+exit 's

	perl -e 'fork ? wait : exit for 1 .. 100_000'

with and without the patch, and didn't notice any difference as expected.

> Acked-by: Davide Libenzi <davidel@xmailserver.org>

Thanks for looking at this!

Oleg.

