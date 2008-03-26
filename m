Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbYCZItS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbYCZItS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 04:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYCZItF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 04:49:05 -0400
Received: from styx.suse.cz ([82.119.242.94]:47564 "EHLO elijah.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750937AbYCZItD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 04:49:03 -0400
Subject: Re: [PATCH] Discard notification signals when a tracer exits
From: Petr Tesarik <ptesarik@suse.cz>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
In-Reply-To: <20080325161606.GA93@tv-sign.ru>
References: <1206455513.17227.4.camel@elijah.suse.cz>
	 <20080325161606.GA93@tv-sign.ru>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: SuSE CR
Date: Wed, 26 Mar 2008 09:48:57 +0100
Message-Id: <1206521337.30244.11.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-25 at 19:16 +0300, Oleg Nesterov wrote:
> This patch needs Roland's opinion. I can't really judge, but I
> have some (perhaps wrong) doubts.
> 
> On 03/25, Petr Tesarik wrote:
> >
> > When a tracer exits without detaching from the traced process, the
> > tracee may be at a tracer notification stop and will thus interpret
> > the value in task->exit_code (SIGTRAP | 0x80) as the signal to be
> > delivered.
> > 
> > This patch fixes the problem by clearing exit_code when detaching
> > the traced process from a dying tracer.
> > 
> > Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> > 
> > ---
> >  exit.c |    8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -642,8 +642,10 @@ reparent_thread(struct task_struct *p, s
> >  			/*
> >  			 * If it was at a trace stop, turn it into
> >  			 * a normal stop since it's no longer being
> > -			 * traced.
> > +			 * traced.  Cancel the notification signal,
> > +			 * or the tracee may get a SIGTRAP.
> >  			 */
> > +			p->exit_code = 0;
> >  			ptrace_untrace(p);
> >  		}
> >  	}
> > @@ -713,6 +715,10 @@ static void forget_original_parent(struc
> >  			p->real_parent = reaper;
> >  			reparent_thread(p, father, 0);
> >  		} else {
> > +			/* cancel the notification signal at a trace stop */
> > +			if (p->state == TASK_TRACED)
> > +				p->exit_code = 0;
> 
> This reduce the likelihood that the tracee will be SIGTRAP'ed, but doesn't
> solve the problem, no?
> 
> Suppose that the tracee does send_sigtrap(current) in do_syscall_trace()
> and then ptracer exits. Or ptracer wakes up the TASK_TRACED tracee without
> clearing its ->exit_code and then you kill(ptracer, SIGKILL).

If the ptracer wakes up the tracee, then it is no longer in the state
TASK_TRACED.

> If we really need this, _perhaps_ it is better to change do_syscall_trace(),
> so that the tracee checks ->ptrace before sending the signal to itself.

You're missing the point. The child _is_ traced before sending the
signal. It leaves the notification code in ->exit_code, so that the
tracer can fetch it with a call to wait4(). Later, the same field is
used to tell the tracee which signal the tracer delivered to it.
However, if the tracer dies before it reads (and resets) the value in
->exit_code, the tracee interprets the notification code as the signal
to be delivered.

> But actually, I don't understand what is the problem. Ptracer has full control,
> you should not kill it with SIGKILL, this may leave the child in some bad/
> inconsistent change. If strace/whatever itself exits without taking care about
> its tracees, then we should fix the tracer, not the kernel.

Hm, what if the tracer gets actually killed by the kernel, e.g. by the
OOM killer? How would you fix that in userspace?

Anyway, if you really want to have broken behaviour on unexpected tracer
exits, then we'd better not change the tracee's state from TASK_TRACED
at all. That way it stays hanging in the system and the admin can decide
whether they want to shoot it down with a SIGKILL or attach a debugger
to it and somehow resume the process. Arranging for a delivery of a
non-existent SIGTRAP seems utterly illogical to me.

Cheers,
Petr Tesarik

