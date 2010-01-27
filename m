Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157Ab0A0K2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0A0K2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 05:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756Ab0A0K2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 05:28:43 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:43781 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab0A0K2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 05:28:42 -0500
Date: Wed, 27 Jan 2010 15:58:26 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC Patch 2/2][Bugfix][x86][hw-breakpoint] Fix return-code to
	notifier chain in hw_breakpoint_handler
Message-ID: <20100127102826.GA3460@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20091226175533.149765731@linux.vnet.ibm.com> <20091226182833.GC9494@in.ibm.com> <20100125221101.GE5087@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100125221101.GE5087@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 11:11:04PM +0100, Frederic Weisbecker wrote:
> On Sat, Dec 26, 2009 at 11:58:33PM +0530, K.Prasad wrote:
> > The hw-breakpoint handler will return NOTIFY_DONE for user-space breakpoints
> > to generate SIGTRAP signal (and not for kernel-space addresses). 
> 
> 
> Please tell a bit more in your changelogs. It took me some time
> to guess whether this is a fix or not.
> 

Sorry about that...will add a descriptive changelog.

> And this is not a fix but an optimization because SIGTRAP
> is only sent if needed.
> 
> Here is what happens in do_debug() after handling the
> breakpoint:
> 
> 	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS))
> 		send_sigtrap(tsk, regs, error_code, si_code);
> 
> This can only happen if we took the ptrace handler path.
>

Agreed...signals are prevented as above...except that the notifier
semantics aren't properly used (NOTIFY_DONE vs NOTIFY_STOP).

> Also:
> 
> 
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > ---
> >  arch/x86/kernel/hw_breakpoint.c |    9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6-tip/arch/x86/kernel/hw_breakpoint.c
> > ===================================================================
> > --- linux-2.6-tip.orig/arch/x86/kernel/hw_breakpoint.c
> > +++ linux-2.6-tip/arch/x86/kernel/hw_breakpoint.c
> > @@ -502,8 +502,6 @@ static int __kprobes hw_breakpoint_handl
> >  		rcu_read_lock();
> >  
> >  		bp = per_cpu(bp_per_reg[i], cpu);
> > -		if (bp)
> > -			rc = NOTIFY_DONE;
> >  		/*
> >  		 * Reset the 'i'th TRAP bit in dr6 to denote completion of
> >  		 * exception handling
> > @@ -517,6 +515,13 @@ static int __kprobes hw_breakpoint_handl
> >  			rcu_read_unlock();
> >  			break;
> >  		}
> > +		/*
> > +		 * Further processing in do_debug() is needed for a) user-space
> > +		 * breakpoints (to generate signals) and b) when the system has
> > +		 * taken exception due to multiple causes
> > +		 */
> > +		if (bp->attr.bp_addr < TASK_SIZE)
> > +			rc = NOTIFY_DONE;
> 
> Is that < TASK_SIZE an accurate check? We want support for
> userspace breakpoints on perf tools later, and those don't want
> signals.
> 

Well, signal generation for user-space breakpoints happened
unconditionally for 'historical' reasons (guess that Alan Stern's
original patch had it that way).

We could change that into a 'ptrace-only' signal generation now.

> We do this cleanup in the beginning of the breakpoint handler:
> 
> 	current->thread.debugreg6 &= ~DR_TRAP_BITS;
> 
> And from ptrace.c:ptrace_triggered():
> 
> 	thread->debugreg6 |= (DR_TRAP0 << i);
> 
> This is called on perf_bp_event().
> Instead of checking if this is a userspace thread, we should actually
> check if this is a ptrace breakpoint by looking at this
> in the end of hw_breakpoint_handler().
> 
> 	current->thread.debugreg6 & DR_TRAP_BITS
> 
> Only ptrace breakpoints require signals.
>

Yes, this does look like a clean way to limit signals to those requests
that are interested (I was looking at round-about ways like doing a
lookup based on callback functions).

I will send the next version of the patch with the above changes.

Thanks,
K.Prasad

