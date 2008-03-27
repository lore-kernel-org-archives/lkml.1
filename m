Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbYC0IHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbYC0IHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 04:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbYC0IGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 04:06:49 -0400
Received: from styx.suse.cz ([82.119.242.94]:34893 "EHLO elijah.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755246AbYC0IGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 04:06:46 -0400
Subject: Re: [PATCH] Discard notification signals when a tracer exits
From: Petr Tesarik <ptesarik@suse.cz>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
In-Reply-To: <20080326181724.GA77@tv-sign.ru>
References: <1206455513.17227.4.camel@elijah.suse.cz>
	 <20080325161606.GA93@tv-sign.ru> <1206521337.30244.11.camel@elijah.suse.cz>
	 <20080326181724.GA77@tv-sign.ru>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: SuSE CR
Date: Thu, 27 Mar 2008 09:06:38 +0100
Message-Id: <1206605198.30244.55.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-26 at 21:17 +0300, Oleg Nesterov wrote:
> [...]
> > > If we really need this, _perhaps_ it is better to change do_syscall_trace(),
> > > so that the tracee checks ->ptrace before sending the signal to itself.
> > 
> > You're missing the point. The child _is_ traced before sending the
> > signal. It leaves the notification code in ->exit_code, so that the
> > tracer can fetch it with a call to wait4(). Later, the same field is
> > used to tell the tracee which signal the tracer delivered to it.
> > However, if the tracer dies before it reads (and resets) the value in
> > ->exit_code, the tracee interprets the notification code as the signal
> > to be delivered.
> 
> I see! That is why I suggested to re-check ->ptrace, and if we are not
> ptraced any longer - discard the notification. Even better, we can change
> ptrace_stop() as Roland pointed out.

That's not what you want. It's totally OK if the tracer resumes the
tracee with a signal and immediately exits before the tracee returns
from schedule(), so this approach won't work. Sorry.

> > > But actually, I don't understand what is the problem. Ptracer has full control,
> > > you should not kill it with SIGKILL, this may leave the child in some bad/
> > > inconsistent change. If strace/whatever itself exits without taking care about
> > > its tracees, then we should fix the tracer, not the kernel.
> > 
> > Hm, what if the tracer gets actually killed by the kernel, e.g. by the
> > OOM killer? How would you fix that in userspace?
> 
> I think in that case a user has much worse problems ;)

Well, there are many more cases. What about an admin who forgot a
running strace on a system daemon and then used SAK (SysRq+K) to make
sure the system was sane before logging in?

Anyway, I have a very real bug report from a paying customer, so
whatever their use case, I'm bound to solve it for them. And I always
thought that pushing a fix upstreams is considered "the right
thing" (TM).

> > Anyway, if you really want to have broken behaviour on unexpected tracer
> > exits, then we'd better not change the tracee's state from TASK_TRACED
> > at all. That way it stays hanging in the system and the admin can decide
> > whether they want to shoot it down with a SIGKILL or attach a debugger
> > to it and somehow resume the process. Arranging for a delivery of a
> > non-existent SIGTRAP seems utterly illogical to me.
> 
> No, I don't want to have broken behaviour on unexpected tracer exits,
> but I don't see a "good" way to fix this relatively minor problem.
> 
> But I _personally_ don't like this particular patch, sorry. And please
> note that I said "I can't really judge".

That's perfectly fine. More eyes can see more bugs. My patch was buggy,
indeed, and I don't want to introduce new bugs.

>[...]
> > So, do you think it's a better idea to add a new flag to notify the
> > tracee that its tracer disappeared? That way it can decide how to handle
> > the situation in ptrace_stop(), something along these lines:
> >
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> > @@ -1628,6 +1628,8 @@ ptrace_stop(int exit_code, int c
> >                 do_notify_parent_cldstop(current, CLD_TRAPPED);
> >                 read_unlock(&tasklist_lock);
> >                 schedule();
> > +               if (current->flags & PF_PTRACEORPHAN & clear_code)
> > +                       current->exit_code = 0;
> >         } else {
> >                 /*
> >                  * By the time we got the lock, our tracer went away.
> > 
> > And then replace p->exit_code = 0 in my original patch with something
> > like p->flags |= PF_PTRACEORPHAN. Better?
> 
> This is racy, and we can't modify p->flags, and I don't really understand
> how this can help.

Why is it racy? It's ugly, but where's the race condition? The tracee
cannot get out of schedule() until the tracer lets it go. And it doesn't
let it go, because there can only be one tracer for any given task and
that's the task which is exiting. So AFAICS doing (almost) anything to
the tracee is safe.

To explain how my second patch is different from the previous one - the
tracee now decides whether the signal should be discarded or not, and it
can distinguish the self-induced tracer notification signal from a real
one by looking at the clear_code argument to ptrace_stop().

Regards,
Petr Tesarik

> I am sorry Petr, I have no idea how to fix this, but I don't agree with
> your approach.
> 
> (Yes I know, it is very easy to blame somebody else's code ;)
> 
> Oleg.
> 
