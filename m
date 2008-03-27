Return-Path: <linux-kernel-owner+w=401wt.eu-S1759007AbYC0Np0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbYC0Np0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 09:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbYC0NpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 09:45:13 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:48376 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbYC0NpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 09:45:11 -0400
Date: Thu, 27 Mar 2008 16:44:54 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] Discard notification signals when a tracer exits
Message-ID: <20080327134454.GA83@tv-sign.ru>
References: <1206455513.17227.4.camel@elijah.suse.cz> <20080325161606.GA93@tv-sign.ru> <1206521337.30244.11.camel@elijah.suse.cz> <20080326181724.GA77@tv-sign.ru> <1206605198.30244.55.camel@elijah.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206605198.30244.55.camel@elijah.suse.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27, Petr Tesarik wrote:
>
> On Wed, 2008-03-26 at 21:17 +0300, Oleg Nesterov wrote:
> > [...]
> > > > If we really need this, _perhaps_ it is better to change do_syscall_trace(),
> > > > so that the tracee checks ->ptrace before sending the signal to itself.
> > > 
> > > You're missing the point. The child _is_ traced before sending the
> > > signal. It leaves the notification code in ->exit_code, so that the
> > > tracer can fetch it with a call to wait4(). Later, the same field is
> > > used to tell the tracee which signal the tracer delivered to it.
> > > However, if the tracer dies before it reads (and resets) the value in
> > > ->exit_code, the tracee interprets the notification code as the signal
> > > to be delivered.
> > 
> > I see! That is why I suggested to re-check ->ptrace, and if we are not
> > ptraced any longer - discard the notification. Even better, we can change
> > ptrace_stop() as Roland pointed out.
> 
> That's not what you want. It's totally OK if the tracer resumes the
> tracee with a signal and immediately exits before the tracee returns
> from schedule(), so this approach won't work. Sorry.

You misunderstood. I didn't claim this approach is right, but I think
it is better if we desperately need to fix this problem. Yes the tracee
can lost the right SIGTRAP, this is obvious. But this can happen with
your patch as well, the kernel just can't know what should we do with
SIGTRAP in ->exit_code.

In short, I (roughly) meant

	ptrace_stop:
		...
		// return path
		spin_lock_irq(->siglock);
		current->last_siginfo = NULL;

		// can be false positive
		if (!->ptrace && (->exit_code & 7f) == SIGTRAP)
			->exit_code = 0;

		...

Yes, this is not right too. (and yes, ptrace_stop() is much better than
do_syscall_trace() I suggested originally).

> Anyway, I have a very real bug report from a paying customer, so
> whatever their use case, I'm bound to solve it for them.

Just curious: what is the bug report? Why do they want to SIGKILL strace?

> And I always
> thought that pushing a fix upstreams is considered "the right
> thing" (TM).

Once again: of course I agree it would be nice to fix the problem if we
had a clean fix.

Yes I think this problem is _relatively_ minor, and I don't really think
it is BUG. But I am not maintainer or expert, just my personal opinion.
I jumped into discussion only because I don't agree with the patch, not
because I think we should not fix this.

(btw, I think that maintainer has already give a good summary ;)

> > > --- a/kernel/signal.c
> > > +++ b/kernel/signal.c
> > > @@ -1628,6 +1628,8 @@ ptrace_stop(int exit_code, int c
> > >                 do_notify_parent_cldstop(current, CLD_TRAPPED);
> > >                 read_unlock(&tasklist_lock);
> > >                 schedule();
> > > +               if (current->flags & PF_PTRACEORPHAN & clear_code)
> > > +                       current->exit_code = 0;
> > >         } else {
> > >                 /*
> > >                  * By the time we got the lock, our tracer went away.
> > > 
> > > And then replace p->exit_code = 0 in my original patch with something
> > > like p->flags |= PF_PTRACEORPHAN. Better?
> > 
> > This is racy, and we can't modify p->flags, and I don't really understand
> > how this can help.
> 
> Why is it racy? It's ugly, but where's the race condition? The tracee
> cannot get out of schedule() until the tracer lets it go. And it doesn't
> let it go, because there can only be one tracer for any given task and
> that's the task which is exiting. So AFAICS doing (almost) anything to
> the tracee is safe.

SIGKILL can wake up the tracee, it could be TASK_RUNNING when the tracer
plays with its flag, this is wrong.

But there are other problems. It is racy because TASK_TRACED doesn't
necessary mean the tracee sleeps in TASK_TRACED state, it is possible
that the tracee is running and waits for tasklist_lock() in ptrace_stop.
As a very minimum, we should clear PF_PTRACEORPHAN.

More. Suppose that we set PF_PTRACEORPHAN, and then ptrace_untrace()
changes TASK_TRACED to TASK_STOPPED. Another tracer attaches to the
poor tracee, ptrace_check_attach() changes TASK_STOPPED to TASK_TRACED.
When the new tracer wakes up the tracee, it will see PF_PTRACEORPHAN
and clear ->exit_code.

Oleg.

