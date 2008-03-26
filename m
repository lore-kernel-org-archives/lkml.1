Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbYCZJNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbYCZJNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 05:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYCZJNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 05:13:23 -0400
Received: from styx.suse.cz ([82.119.242.94]:57598 "EHLO elijah.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753275AbYCZJNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 05:13:21 -0400
Subject: Re: [PATCH] Discard notification signals when a tracer exits
From: Petr Tesarik <ptesarik@suse.cz>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
In-Reply-To: <20080325163316.GA176@tv-sign.ru>
References: <1206455513.17227.4.camel@elijah.suse.cz>
	 <20080325161606.GA93@tv-sign.ru>  <20080325163316.GA176@tv-sign.ru>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: SuSE CR
Date: Wed, 26 Mar 2008 10:13:18 +0100
Message-Id: <1206522798.30244.32.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-25 at 19:33 +0300, Oleg Nesterov wrote:
> On 03/25, Oleg Nesterov wrote:
> >
> > This patch needs Roland's opinion. I can't really judge, but I
> > have some (perhaps wrong) doubts.
> > 
> > On 03/25, Petr Tesarik wrote:
> > >
> > > When a tracer exits without detaching from the traced process, the
> > > tracee may be at a tracer notification stop and will thus interpret
> > > the value in task->exit_code (SIGTRAP | 0x80) as the signal to be
> > > delivered.
> > > 
> > > This patch fixes the problem by clearing exit_code when detaching
> > > the traced process from a dying tracer.
> > > 
> > > Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> > > 
> > > ---
> > >  exit.c |    8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
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
> > 
> > If we really need this, _perhaps_ it is better to change do_syscall_trace(),
> > so that the tracee checks ->ptrace before sending the signal to itself.
> > 
> > 
> > But actually, I don't understand what is the problem. Ptracer has full control,
> > you should not kill it with SIGKILL, this may leave the child in some bad/
> > inconsistent change.
> 
> Additional note. Suppose that the tracee dequeues the "good" signal, notices
> PT_PTRACED and calls ptrace_stop(). We set TASK_TRACED under ->siglock, without
> holding tasklist_lock. At this moment you kill strace, it clears ->exit_code.
> The tracee notices it is not traced any longer and returns to get_signal_to_deliver().
> Since ->exit_code is cleared, the "right" signal is lost.

Yes, you're right. My patch only works OK in the ptrace_notify() case,
not when it is called from get_signal_to_deliver().

So, do you think it's a better idea to add a new flag to notify the
tracee that its tracer disappeared? That way it can decide how to handle
the situation in ptrace_stop(), something along these lines:

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1628,6 +1628,8 @@ ptrace_stop(int exit_code, int c
 		do_notify_parent_cldstop(current, CLD_TRAPPED);
 		read_unlock(&tasklist_lock);
 		schedule();
+		if (current->flags & PF_PTRACEORPHAN & clear_code)
+			current->exit_code = 0;
 	} else {
 		/*
 		 * By the time we got the lock, our tracer went away.

And then replace p->exit_code = 0 in my original patch with something
like p->flags |= PF_PTRACEORPHAN. Better?

Cheers,
Petr Tesarik

> So I think this patch adds a race. In some sense (yes I am biased) this is
> even worse than the problem this patch tries to solve, because this race
> is unlikely and is hard to trigger/debug, and it could be easily unnoticed.
> 
> Oleg.
> 
