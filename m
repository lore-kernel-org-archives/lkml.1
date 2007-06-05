Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbXFECKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbXFECKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 22:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762754AbXFECK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 22:10:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:52138 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762636AbXFECKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 22:10:22 -0400
Subject: Re: [PATCH/RFC] signal races/bugs, losing TIF_SIGPENDING and other
	woes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <alpine.LFD.0.98.0706041831400.23741@woody.linux-foundation.org>
References: <1181006711.31677.97.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706041831400.23741@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 12:10:13 +1000
Message-Id: <1181009413.31677.117.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > 
> >  - something calls recalc_sigpending_tsk() on thread A (for example,
> >    something try to sends it S2 which is blocked). There is no longer
> >    an active signal and thus TIF_SIGPENDING is cleared on thread A
> 
> I agree. That's unquestionably a bug. We should *never* clear sigpending 
> for somebody else.
> 
> I have to say, your patch looks pretty ugly though. It also looks like 
> it's rife to be subtly buggy (ie somebody calls "recalc_sigpending_tsk()" 
> with "current" and doesn't realize the subtle rule.

Yeah. Also, I think we have done a mistake in our analysis.

We don't actually call recalc_sigpending_tsk() when sending a signal to
some other task, we just set the flag... so I need to recheck my theory
here about recalc_sigpending_tsk being called for somebody else...
Something is doing it somewhere it seems (we are losing the
TIF_SIGPENDING bit) but I'll need to cook up a repro case to track
exactly where.

However, there is still something wrong imho with actually passing it a
task if it should really only ever be called on current... What are we
saving by passing this task around rather than using "current" ? It's
expensive to get to current on some archs ? The only somewhat legic case
I can see is the exit.c code ... though that could cause the scenario
I've explained, I suppose it's fair to say that we're going to exit so
it doesn't matter anyway.

Another case I see is force_sig_info() which is dodgy... it -firsts-
unblocks, then recalc_sigpending_and_wake() the target, -then- sends the
signal... so there might be a small window there where we could clear
TIF_SIGPENDING....

That leaves us to these:

 - There's a bug somewhere, maybe the force_sig_info thing above, maybe
some other path I haven't quite found yet, that can cause syscalls to
return -ERESTARTSYS. I need to make a reprocase to verify we get the
right fix.

 - We should still, I think, make sure that we never clear anybody but
ourselve's TIF_SIGPENDING as a general good thing to do, to make the
whole thing "robust" (and fix the potential issue with force_sig_info).

 - However, I'm not sure about your patch. The problem is, can't things
like force_sig_info() be called from an interrupt ? Thus I think using
the value of current inside recalc_sigpending_tsk might not be the best
approach... I was trying to make sure we really only do it when we are
in a known code path where current can be relied upon.

 - I still think there's something wrong with dequeue_signal() being
potentially called with a task different than current by signalfd, since
__dequeue_signal() (among others) mucks around with current regardless.
I'd love to just make signalfd's read() only do anything if current ==
ctx->tsk and remove the task argument from dequeue_signal... that would
fix it nicely too no ?

> I also wonder if we should just remove the "clear_tsk_thread_flag()" thing 
> *entirely*, and do it only in the do_sigal() path. THAT, however, is a 
> much bigger change. This one-liner seems the trivial and most obvious 
> patch.

I've been thinking about that too (in fact, doing it in
get_signal_to_deliver()), but there are some issues with kernel theads
ending up with TIF_SIGPENDING set forever.

I think the right thing is that dequeue_signal() is the one who needs to
do it, and dequeue_signal() should never be allowed on anything but
current. But that means fixing signalfd.

Cheers,
Ben.


