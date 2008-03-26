Return-Path: <linux-kernel-owner+w=401wt.eu-S1759447AbYCZSMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447AbYCZSMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbYCZSMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:12:13 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58707 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070AbYCZSML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:12:11 -0400
Date: Wed, 26 Mar 2008 21:17:24 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] Discard notification signals when a tracer exits
Message-ID: <20080326181724.GA77@tv-sign.ru>
References: <1206455513.17227.4.camel@elijah.suse.cz> <20080325161606.GA93@tv-sign.ru> <1206521337.30244.11.camel@elijah.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206521337.30244.11.camel@elijah.suse.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26, Petr Tesarik wrote:
>
> On Tue, 2008-03-25 at 19:16 +0300, Oleg Nesterov wrote:
> > This patch needs Roland's opinion. I can't really judge, but I
> > have some (perhaps wrong) doubts.
> > 
> > On 03/25, Petr Tesarik wrote:
> > >
> > > --- a/kernel/exit.c
> > > +++ b/kernel/exit.c
> > > @@ -642,8 +642,10 @@ reparent_thread(struct task_struct *p, s
> > >  			/*
> > >  			 * If it was at a trace stop, turn it into
> > >  			 * a normal stop since it's no longer being
> > > -			 * traced.
> > > +			 * traced.  Cancel the notification signal,
> > > +			 * or the tracee may get a SIGTRAP.
> > >  			 */
> > > +			p->exit_code = 0;
> > >  			ptrace_untrace(p);
> > >  		}
> > >  	}
> > > @@ -713,6 +715,10 @@ static void forget_original_parent(struc
> > >  			p->real_parent = reaper;
> > >  			reparent_thread(p, father, 0);
> > >  		} else {
> > > +			/* cancel the notification signal at a trace stop */
> > > +			if (p->state == TASK_TRACED)
> > > +				p->exit_code = 0;
> > 
> > This reduce the likelihood that the tracee will be SIGTRAP'ed, but doesn't
> > solve the problem, no?
> > 
> > Suppose that the tracee does send_sigtrap(current) in do_syscall_trace()
> > and then ptracer exits. Or ptracer wakes up the TASK_TRACED tracee without
> > clearing its ->exit_code and then you kill(ptracer, SIGKILL).
> 
> If the ptracer wakes up the tracee, then it is no longer in the state
> TASK_TRACED.

Exactly. I meant this patch can't help in that case, the problem is "wider".

> > If we really need this, _perhaps_ it is better to change do_syscall_trace(),
> > so that the tracee checks ->ptrace before sending the signal to itself.
> 
> You're missing the point. The child _is_ traced before sending the
> signal. It leaves the notification code in ->exit_code, so that the
> tracer can fetch it with a call to wait4(). Later, the same field is
> used to tell the tracee which signal the tracer delivered to it.
> However, if the tracer dies before it reads (and resets) the value in
> ->exit_code, the tracee interprets the notification code as the signal
> to be delivered.

I see! That is why I suggested to re-check ->ptrace, and if we are not
ptraced any longer - discard the notification. Even better, we can change
ptrace_stop() as Roland pointed out.

> > But actually, I don't understand what is the problem. Ptracer has full control,
> > you should not kill it with SIGKILL, this may leave the child in some bad/
> > inconsistent change. If strace/whatever itself exits without taking care about
> > its tracees, then we should fix the tracer, not the kernel.
> 
> Hm, what if the tracer gets actually killed by the kernel, e.g. by the
> OOM killer? How would you fix that in userspace?

I think in that case a user has much worse problems ;)

> Anyway, if you really want to have broken behaviour on unexpected tracer
> exits, then we'd better not change the tracee's state from TASK_TRACED
> at all. That way it stays hanging in the system and the admin can decide
> whether they want to shoot it down with a SIGKILL or attach a debugger
> to it and somehow resume the process. Arranging for a delivery of a
> non-existent SIGTRAP seems utterly illogical to me.

No, I don't want to have broken behaviour on unexpected tracer exits,
but I don't see a "good" way to fix this relatively minor problem.

But I _personally_ don't like this particular patch, sorry. And please
note that I said "I can't really judge".

> > Additional note. Suppose that the tracee dequeues the "good" signal, notices
> > PT_PTRACED and calls ptrace_stop(). We set TASK_TRACED under ->siglock, without
> > holding tasklist_lock. At this moment you kill strace, it clears ->exit_code.
> > The tracee notices it is not traced any longer and returns to get_signal_to_deliver().
> > Since ->exit_code is cleared, the "right" signal is lost.
> 
> Yes, you're right. My patch only works OK in the ptrace_notify() case,
> not when it is called from get_signal_to_deliver().

And this means the patch is buggy, that was my point. Actually I think
it has other problems.

> So, do you think it's a better idea to add a new flag to notify the
> tracee that its tracer disappeared? That way it can decide how to handle
> the situation in ptrace_stop(), something along these lines:
>
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1628,6 +1628,8 @@ ptrace_stop(int exit_code, int c
>                 do_notify_parent_cldstop(current, CLD_TRAPPED);
>                 read_unlock(&tasklist_lock);
>                 schedule();
> +               if (current->flags & PF_PTRACEORPHAN & clear_code)
> +                       current->exit_code = 0;
>         } else {
>                 /*
>                  * By the time we got the lock, our tracer went away.
> 
> And then replace p->exit_code = 0 in my original patch with something
> like p->flags |= PF_PTRACEORPHAN. Better?

This is racy, and we can't modify p->flags, and I don't really understand
how this can help.

I am sorry Petr, I have no idea how to fix this, but I don't agree with
your approach.

(Yes I know, it is very easy to blame somebody else's code ;)

Oleg.

