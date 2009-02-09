Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbZBIDMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbZBIDMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 22:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbZBIDMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 22:12:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39781 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbZBIDMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 22:12:22 -0500
Date: Mon, 9 Feb 2009 04:09:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ptrace_untrace: fix the SIGNAL_STOP_STOPPED check
Message-ID: <20090209030953.GA30787@redhat.com>
References: <20090208184730.GA27086@redhat.com> <20090209015029.45AA7FC330@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209015029.45AA7FC330@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08, Roland McGrath wrote:
>
> Yes, I believe this is correct.  It matches the flip side of the
> bookkeeping where we adjust group_stop_count when going into TASK_TRACED
> (ptrace_stop).  I think it warrants a comment with your change, saying that
> treating group_stop_count as "we should be already stopped" is consistent
> with decrementing an active group_stop_count when we enter TASK_TRACED.

Yes, I tried to make the comment, but failed.

Because we have another case. The group stop is in progress, and some
thread T does do_signal_stop()->finish_stop(). It is TASK_STOPPED.
Now we do PTRACE_ATTACH + PTRACE_DETACH. And the second sys_ptrace()
changes T->state to TASK_TRACED.

And. It it also possible that we ptrace the single sub-thread, then
the group stop starts. The first thread which enters do_signal_stop()
will not count the TASK_TRACED child, so it should stay stopped.

> > 	- if the process/thread was traced, SIGNAL_STOP_STOPPED
> > 	  does not necessary means this thread group is stopped.
> >
> > 	- ptrace breaks the bookkeeping of ->group_stop_count.
>
> SIGNAL_STOP_STOPPED is only set when all live threads in the group are in
> either TASK_TRACED or TASK_STOPPED.  PTRACE_DETACH respects this and this
> it stopped.  However, PTRACE_CONT et al (ptrace_resume) do not respect it
> and can resume an individual thread regardless of SIGNAL_STOP_STOPPED.
> That's what you mean here, right?

Yes. (and of course, we don't even need threads to hit this problem).

> > (the comment above ptrace_untrace() doesn't look exactly right too).
>
> How so?

Perhaps this is just my misunderstanding, but

	/*
	 * Turn a tracing stop into a normal stop now, since with no tracer there
	 * would be no way to wake it up with SIGCONT or SIGKILL.

This looks as if we always do /TRACED/STOPPED/ unconditionally.

	                                                           If there was a
	 * signal sent that would resume the child, but didn't because it was in
	 * TASK_TRACED, resume it now.

No, we resume it not because it may have signals, and we don't even check
it has pending signals.

	 * Requires that irqs be disabled.
	 */

this is correct ;)

Oleg.

