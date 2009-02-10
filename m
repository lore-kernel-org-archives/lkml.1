Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbZBJViV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbZBJViV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 16:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbZBJViN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 16:38:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51331 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573AbZBJViM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:38:12 -0500
Date: Tue, 10 Feb 2009 22:35:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ptrace_untrace: use wake_up_process() instead of
	bogus signal_wake_up()
Message-ID: <20090210213505.GA4257@redhat.com>
References: <20090208184727.GA27081@redhat.com> <20090209013804.C99B3FC330@magilla.sf.frob.com> <20090209024236.GB28280@redhat.com> <20090209034255.E95A7FC330@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209034255.E95A7FC330@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have already asked Andrew to ignore this series.

But since I am a bore...

On 02/08, Roland McGrath wrote:
> > We are holding ->siglock, and task->state is TASK_TRACED. We can not do
> > the "wrong" wakeup, afaics.
>
> I guess that's true with the siglock.  But you'd be wrong to think that
> this sort of detailed thinking is why wake_up_process() appears *anywhere
> at all* in ptrace-related code.  I'm really quite sure that it's the
> aforementioned (ancient) lack of detailed thinking about it that led to
> wake_up_process() appearing originally--so any use of it reminds us of that
> dubious past.

Yes, wake_up_process() is not always right. But without ->siglock
signal_wake_up() is not "safe" too if we want to wake up the
TRACED/STOPPED task.

If we change ptrace_resume() to use signal_wake_up(), we won't fix
this minor problem. Fortunately, this is really minor, if the task
is not TASK_TRACED any longer - it must be dying.

> > Because it complicates the understanding of this code. I spent a lot
> > of time trying to understand this signal_wake_up().
> >
> > Perhaps this is just me. But when you see the code which does something,
> > it is always good to understand the reason, otherwise the code at least
> > looks wrong.
>
> I had presumed most people interpret it the way I do: it does
> signal_wake_up(,1), meaning "whatever it is that works right for SIGKILL or
> SIGCONT", which it seems intuitive to think is right for this case too.
> You don't have to think about exactly what is always exactly right for this
> case, because it makes sense to think that this is like the wakeup that
> SIGCONT would do.

No, SIGCONT uses wake_up_state(), not signal_wake_up(). Because unless
we have a handler for SIGCONT, we don't need to set TIF_SIGPENDING.
And I think this is right, and this is also right for ptrace_untrace().

So, in fact SIGCONT votes for this patch ;)

As for SIGKILL. Of course we should set TIF_SIGPENDING when we send
the signal, SIGKILL or any other. Yes, complete_signal() checks
sig == SIGKILL to figure out the correct mask. But ptrace_untrace()
already knows it.

> To me, it takes much more thought to be convinced that
> wake_up_process() without other considerations is correct here--because it
> looks like such a scary, unconditional thing, whereas normally that is
> wrapped up inside calls that handle appropriate bookkeeping--signal_wake_up()
> being one of those.

We have the rule: if we see the task in TASK_TRACED/STOPPED state
under ->siglock, it can do nothing except sleep or spin for ->siglock.
IOW, it can't "escape" from TRACED/STOPPED state even if it is already
TASK_RUNNING. do_wait() depends on this.

To me, signal_wake_up() means: we do have a reason for TIF_SIGPENDING,
otherwise the task can wrongly return to userspace without noticing
a signal (or pseudo signal). (and we call it with resume == 1, because
we can't pass the mask which is "exactly correct").


I strongly believe the code should be simplified as much as possible,
to simplify the understanding of the details. I spent more than 2 days
trying to understand whats going on with the bug-report which I wasn't
able to reproduce (it was actually the problem in glibc). It looked as
if the ptraced task can miss SIGKILL if it races with detach. When
I read this code I was really puzzled by this signal_wake_up().
I thought that perhaps it adresses some signal related problem which
I am not aware of, and perhaps the lost SIGKILL actually "belongs"
to this problem. It took me a lot of time to convince myself this
signal_wake_up() is just unneeded, and I should dig somewhere else.


That said. I agree this is harmless, and the matter of taste.
I don't think I can convince you, let's forget this patch.

Oleg.

