Return-Path: <linux-kernel-owner+w=401wt.eu-S1750708AbXBWCTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750708AbXBWCTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 21:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714AbXBWCTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 21:19:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbXBWCTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 21:19:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kwatch: kernel watchpoints using CPU debug registers
In-Reply-To: Alan Stern's message of  Wednesday, 21 February 2007 15:35:13 -0500 <Pine.LNX.4.44L0.0702211458250.3435-100000@iolanthe.rowland.org>
X-Shopping-List: (1) Propitious toothpicks
   (2) Frenetic proportions
   (3) Persistent raisin proteins
   (4) Omniscient wind collisions
   (5) Dyspeptic snowbulb caution
Message-Id: <20070223021903.41B5D1800E4@magilla.sf.frob.com>
Date: Thu, 22 Feb 2007 18:19:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, you are wrong -- although perhaps you shouldn't be.
> 
> The current version of do_debug() clears dr7 when a debug interrupt is 
> fielded.  As a result, if a system call touches two watchpoint addresses 
> in userspace only the first access will be noticed.

Ah, I see.  I think it would indeed be nice to fix this.

> This is probably a bug in do_debug().  It would be better to disable each
> individual userspace watchpoint as it is triggered (or even not to disable
> it at all).  dr7 would be restored when the SIGTRAP is delivered.  (But
> what if the user is blocking or ignoring SIGTRAP?)

The user blocking or ignoring it doesn't come up, because it's a
force_sig_info call.  However, a debugger will indeed swallow the signal
through ptrace/utrace means.  In ptrace, the dr7 is always going to get
reset because there will always be a context switch out and back in that
does it.  But with utrace it's now possible to swallow the signal and keep
going without a context switch (e.g. a breakpoint that is just doing
logging but not stopping).  So perhaps we should have a TIF_RESTORE_DR7
that goes into _TIF_WORK_MASK and gets handled in do_notify_resume
(or maybe it's TIF_HWBKPT).

You should not actually need to disable user watchpoints, because in data
watchpoints the exception comes after the instruction completes.  Only for
instruction watchpoints does the exception come before the instruction
executes, and no user watchpoints can be in the address range containing
kernel code.  

SIGTRAP both doesn't queue, and doesn't give %dr6 values in its siginfo_t.
All user watchpoints will be handled via the signal; this is the only way
ptrace can report them, and is also the utrace way of doing things.
do_debug can happen inside kernel code, and tracing of user-level tasks can
only safely do anything at the point just before returning to user mode,
where signals are handled.  So, getting to send_sigtrap in do_debug is
enough to say "one or more user debug exceptions happened".  The %dr6 value
that collects in the thread state to be seen by ptrace, or by utrace-based
things using your new facility, needs to collect all the %dr6 bits that
were set by the hardware and weren't consumed by kernel-level tracing.  An
eventual utrace-based thing might in fact have some other way to tie in so
that the event details could just be in some call made by do_debug and not
recorded in the thread's virtual %dr6 value.  But at least for ptrace, they
should collect there if it becomes possible for more than one exception to
happen while in kernel mode or in a single user instruction.  (A single
instruction can cause multiple exceptions at the hardware level.)

> I've worked out a plan for implementing combined user/kernel mode
> breakpoints and watchpoints (call them "debugpoints" as a catch-all
> term).  It should work transparently with ptrace and should accomodate
> whatever scheme utrace decides to adopt.  There won't need to be a
> separate kwatch facility on top of it; the new combined facility will
> handle debugpoints in both userspace and kernelspace.

That sounds great.  I'm not thrilled with the name "debugpoint", I have to
tell you.  The hardware documentation calls all these things "breakpoints",
and I think "data breakpoint" and "instruction breakpoint" are pretty good
terms.  How about "hwbkpt" for the facility API?

> To work with ptrace, the new scheme will completely virtualize the debug
> registers.  So for example, a ptrace call might request a debugpoint in
> dr0, but it could end up that the physical register used is really dr2
> instead.  The various bits in dr6 and dr7 will be mapped in such a way
> that the entire procedure is transparent to the user.  Debugpoints 
> registered in kernelspace or by utrace won't care, of course.

I think that's a fine idea.  

The one caveat I have here is that I don't want ptrace (via utrace) to have
to supply the usual structure.  I probably only think this because it would
be a pain for the ptrace/utrace implementation to find a place to stick it.
But I have a rationalization.  The old ptrace interface, and the
utrace_regset for debugregs, is not really a "debugpoint user" in the sense
you're defining it.  It's an access to the "raw" debugregs as part of the
thread's virtual CPU context.  You can use ptrace to set a watchpoint, then
detach ptrace, and the thread will get a SIGTRAP later though there is no
remnant at that point of the debugger interface that made it come about.
For the degenerate case of medium-high priority with no handler callbacks
(that should instead be an error at registration time if no slot is free),
you shouldn't really need any per-caller storage (there can only be one
such caller per slot).  

> There are two things I am uncertain about: vm86 mode and kprobes.  I don't
> know anything about how either of them works.  

I know about kprobes.  I don't know about vm86, but I can read the code.


Thanks,
Roland
