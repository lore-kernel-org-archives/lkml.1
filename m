Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZBICpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZBICpS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 21:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbZBICpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 21:45:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52498 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754AbZBICpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 21:45:03 -0500
Date: Mon, 9 Feb 2009 03:42:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ptrace_untrace: use wake_up_process() instead of
	bogus signal_wake_up()
Message-ID: <20090209024236.GB28280@redhat.com>
References: <20090208184727.GA27081@redhat.com> <20090209013804.C99B3FC330@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209013804.C99B3FC330@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08, Roland McGrath wrote:
>
> > Both ptrace_stop() and do_signal_stop() pathes always take ->siglock and
> > do recalc_sigpending() after wakeup.
>
> Yes, that's true.  But so what?  Why is this a reason to introduce yet
> another unconditional (i.e. wrong) wake_up_process?  signal_wake_up does
> the job fine, i.e. it calls wake_up_state the right way.

We are holding ->siglock, and task->state is TASK_TRACED. We can not do
the "wrong" wakeup, afaics.

And even if we forget about the unneeded TIF_SIGPENDING/kick_process,
personally I can't agree that signal_wake_up() uses wake_up_state()
more "correctly". This doesn't matter of course, but TASK_INTERRUPTIBLE
(and to some extent TASK_WAKEKILL) has nothing to do here, imho.

Of course, the tracee can already spin for ->siglock in TASK_RUNNING
when we do wake_up_process(), but this is true for signal_wake_up()
as well, and this is fine.

> For exactly the
> reasons you cited, setting TIF_SIGPENDING is both superfluous and
> harmless--its effects will happen upon resume whether it was set or not.
> So what's wrong with signal_wake_up?

Because it complicates the understanding of this code. I spent a lot
of time trying to understand this signal_wake_up().

Perhaps this is just me. But when you see the code which does something,
it is always good to understand the reason, otherwise the code at least
looks wrong.

Or, at least we can add the comment

		/*
		 * there are no reasons for signal_wake_up(), we could
		 * use wake_up_state() or wake_up_process() instead.
		 */
		signal_wake_up(child, 1);

Oleg.

