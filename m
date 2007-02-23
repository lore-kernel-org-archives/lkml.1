Return-Path: <linux-kernel-owner+w=401wt.eu-S933138AbXBWQzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138AbXBWQzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 11:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933148AbXBWQzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 11:55:05 -0500
Received: from firewall.rowland.harvard.edu ([140.247.233.35]:28673 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S933138AbXBWQzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 11:55:03 -0500
Date: Fri, 23 Feb 2007 11:55:01 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kwatch: kernel watchpoints using CPU debug registers
In-Reply-To: <20070223021903.41B5D1800E4@magilla.sf.frob.com>
Message-ID: <Pine.LNX.4.44L0.0702231137190.6241-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007, Roland McGrath wrote:

> > Yes, you are wrong -- although perhaps you shouldn't be.
> > 
> > The current version of do_debug() clears dr7 when a debug interrupt is 
> > fielded.  As a result, if a system call touches two watchpoint addresses 
> > in userspace only the first access will be noticed.
> 
> Ah, I see.  I think it would indeed be nice to fix this.
> 
> > This is probably a bug in do_debug().  It would be better to disable each
> > individual userspace watchpoint as it is triggered (or even not to disable
> > it at all).  dr7 would be restored when the SIGTRAP is delivered.  (But
> > what if the user is blocking or ignoring SIGTRAP?)
> 
> The user blocking or ignoring it doesn't come up, because it's a
> force_sig_info call.  However, a debugger will indeed swallow the signal
> through ptrace/utrace means.  In ptrace, the dr7 is always going to get
> reset because there will always be a context switch out and back in that
> does it.  But with utrace it's now possible to swallow the signal and keep
> going without a context switch (e.g. a breakpoint that is just doing
> logging but not stopping).  So perhaps we should have a TIF_RESTORE_DR7
> that goes into _TIF_WORK_MASK and gets handled in do_notify_resume
> (or maybe it's TIF_HWBKPT).

I think the best approach will be not to reset dr7 at all.  Then there 
won't be any need to worry about restoring it.  Leaving a userspace 
watchpoint enabled while running in the kernel ought not to matter; a 
system call shouldn't touch any address in userspace more than once or 
twice.

> > I've worked out a plan for implementing combined user/kernel mode
> > breakpoints and watchpoints (call them "debugpoints" as a catch-all
> > term).  It should work transparently with ptrace and should accomodate
> > whatever scheme utrace decides to adopt.  There won't need to be a
> > separate kwatch facility on top of it; the new combined facility will
> > handle debugpoints in both userspace and kernelspace.
> 
> That sounds great.  I'm not thrilled with the name "debugpoint", I have to
> tell you.  The hardware documentation calls all these things "breakpoints",
> and I think "data breakpoint" and "instruction breakpoint" are pretty good
> terms.  How about "hwbkpt" for the facility API?

Okay, I'll change the name.

> The one caveat I have here is that I don't want ptrace (via utrace) to have
> to supply the usual structure.  I probably only think this because it would
> be a pain for the ptrace/utrace implementation to find a place to stick it.
> But I have a rationalization.  The old ptrace interface, and the
> utrace_regset for debugregs, is not really a "debugpoint user" in the sense
> you're defining it.  It's an access to the "raw" debugregs as part of the
> thread's virtual CPU context.  You can use ptrace to set a watchpoint, then
> detach ptrace, and the thread will get a SIGTRAP later though there is no
> remnant at that point of the debugger interface that made it come about.
> For the degenerate case of medium-high priority with no handler callbacks
> (that should instead be an error at registration time if no slot is free),
> you shouldn't really need any per-caller storage (there can only be one
> such caller per slot).  

My idea was to put 4 hwbkpt structures in thread_struct, so they would
always be available for use by ptrace.  However it turned out not to be
feasible to replace the debugreg array with something more sophisticated,
because of conflicting declarations and problems with the ordering of
#includes.  So instead I have been forced to replace debugreg[] with a
pointer to a structure which can be allocated as needed.

This raises the possibility that a PTRACE syscall might fail because the 
allocation fails.  Hopefully that won't be an issue?

Alan Stern

