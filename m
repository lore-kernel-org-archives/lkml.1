Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbXENVZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbXENVZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbXENVZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:25:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbXENVZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:25:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: Alan Stern's message of  Monday, 14 May 2007 11:42:17 -0400 <Pine.LNX.4.44L0.0705141026170.3283-100000@iolanthe.rowland.org>
X-Shopping-List: (1) Prurient rectum floats
   (2) Telepathic aluminum carnations
   (3) Ridiculous convulsions
Message-Id: <20070514212509.EC8261F84C7@magilla.localdomain>
Date: Mon, 14 May 2007 14:25:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It seems to me that signal handlers must run with a copy of the original
> EFLAGS stored on the stack.

Of course.  I'm talking about how the registers get changed to set up the
signal handler to start running, not how the interrupted registers are
saved on the user stack.  There is no issue with the stored eflags image;
the "privileged" flags like RF are ignored by sigreturn anyway.

> Also, what if the signal handler was entered as a result of encountering 
> an instruction breakpoint?  

This does not happen in reality.  Breakpoints can only be set by the
debugger, not by the program itself.  The debugger should always eat the trap.

> You're right about wanting to clear RF when changing the PC via ptrace or
> when setting a new execution breakpoint (provided the new breakpoint's
> address is equal to the current PC value).

Starting a signal handler is "warping the PC" equivalent to changing it via
ptrace for purposes of this discussion.  In case the new PC is the site of
another breakpoint, RF must be clear.

> Do you know how gdb handles instruction breakpoints, and in particular, 
> how it resumes execution after a breakpoint?

AFAICT it never actually uses hardware instruction breakpoints, only data
watchpoints.  I wouldn't be surprised if noone has ever really used
instruction breakpoint settings in x86 hardware debug registers on Linux.
(Frankly, I don't much expect them to start either.  This level of detail
about instruction breakpoints is largely academic.  I am a stickler for
getting the details right if we're going to allow using them at all.  
But I think really everyone only cares about data watchpoints.)

> But it doesn't matter.  We're up against an API incompatibility here.  

That's a red herring.  gdb is the compatibility case, not the real API user.

> Under the circumstances I think we should just leave it out.

That is fine.  If the flutter issue comes up, we can address it later.

> On the 386, either GE or LE had to be set for DR breakpoints to work 
> properly.  Later on (I don't remember if it was in the 486 or the Pentium) 
> this restriction was removed.  I don't know whether those bits do anything 
> at all on modern CPUs.

I'm moderately sure they do nothing on modern CPUs.  Intel says they're
ignored as of Pentium, but recommends setting both bits if you care at all.
In practice, I don't think we'll ever hear about the inexactness on a
pre-Pentium processor from not setting the bits.  But I'd follow the Intel
manual and set both.

> My 80386 Programmer's Reference Manual says:

The earlier quote I gave was from an AMD64 manual.  A 1995 Intel manual I
have says, "All Intel Architecture processors manage the RF flag as follows,"
and proceeds to give the "all faults except instruction breakpoint" behavior
I quoted from the AMD manual earlier.  Hence I sincerely doubt that this
varies among Intel and AMD processors.  Someone else will have to help us
know about other makers' processors.  So far I have no reason to suspect that
any processor behaves differently (aside from generic cynicism ;-).

> I suppose you might register a breakpoint and find that it isn't installed 
> immediately, but then it could get installed and actually trigger before 
> you managed to unregister it.  Does that count as a "difficult race"?  

Yes, that is really the kind of thing I had in mind.  For user breakpoints it
shouldn't be an issue, since the thread shouldn't have been let run in between.

> Presumably the work done by the trigger callback would get ignored.

That is in the "difficult race" category to ensure.  I would not presume.

> Maybe it doesn't have to be so bad.  If there were _two_ global copies of
> the kernel bp settings, one for the old pre-IPI state and one for the new,
> then the handler could simply look up the DR# in the appropriate copy.  
> This would remove the need to store the settings in the per-CPU area.

I think that is what I suggested an iteration or two ago.  Installing new
state means making a fresh data structure and installing a pointer to it,
leaving the old (immutable) one to be freed by RCU.

> It's a relatively minor issue.  On machines with fixed-length breakpoints, 
> the .len field can be ignored.  Conversely, leaving it out would require 
> using bitmasks to extract the type and length values from a combined .bits 
> field.  I don't see any advantage.

I guess my main objection to having .type and .len is the false implied
documentation of their presence and names, leading to people thinking they
can look at those values.  In fact, they are machine-specific and
implementation-specific bits of no intrinsic use to anyone else.

> Ah, you haven't understood the purpose of the gennum.  In fact 8 bits 
> isn't too small -- far from it!  It's too _large_; a single bit would 
> suffice.  I made it an 8-bit value just because that was easier.

If it's actually a flag, then treating it any other way is just confusing.
I can't see how it's easier for anyone.

> Note that CPUs can never lag behind by more than one update.  The 
> hw_breakpoint_mutex doesn't get released until every CPU has acknowledged 
> receipt of the IPI.

Then it really is just a flag for all uses, and there's no reason at all to
call it a number.

> Yes, that was the idea.  However seqcounts may work better in conjunction
> with this idea of keeping a global copy of both the old and the new kernel
> breakpoints.  I'll look into it.

I think that is going to be the clean and sane approach.
Hand-rolling your low-level synchronization code is always questionable.

> > So it sounds like maybe the real behavior is that any dr[0-3]-induced
> > exception resets the DR_TRAP[0-3] bits to just the new hit, but not the
> > other bits (i.e. just DR_STEP in practice).  Is that part true on all CPUs?
> 
> No.  The 80386 manual says:
> 
> 	Note that the bits of DR6 are never cleared by the processor.
> 
> It's important to bear in mind that not all x86 CPUs are made by Intel, 
> and of those that are, not all are Pentium 4's.  This appears to be an 
> area of high variability so we should be as conservative as possible.

That line from the manual is what we were both going on originally, and
then you described the conflicting behavior.  I was trying to ascertain
whether chips really do vary, or if the manual was just inaccurate about
the single common way it actually behaves.  I take it you have in fact
observed different behaviors on different chips?

There are two possible kinds of "conservative" here.  To be conservative
with respect to the existing behavior on a given chip, whatever that may
be, we should never clear %dr6 completely, and instead should always
mirror its bits to vdr7, only mapping the low four bits around to present
the virtualized order.  The only bits we'd ever clear in hardware are
those DR_TRAPn bits corresponding to the registers allocated to non-ptrace
uses, and kprobes should clear DR_STEP.  And note that when vdr6 is
changed by ptrace, we should reset the hardware %dr6 accordingly, to match
existing kernel behavior should users change debugreg[6] via ptrace.

To be conservative in the sense of reliable user-level behavior despite
chip oddities would be a little different.  Firstly, I think we should
mirror all the "extra" bits from hardware to vdr7 blindly, i.e. everything
but DR_STEP and DR_TRAPn.  That way if any chip comes along that sets new
bits for new features or whatnot, users can at least see the new hardware
bits via ptrace before hw_breakpoint gets updated to support them more
directly.  For the low four bits, I think what users expect is that no
bits are ever implicitly cleared, so they accumulate to say which drN has
hit since the last time ptrace was used to clear vdr6.

> Even if HB_NUM were larger than 1, we could still store two copies of the 
> address value (the second copy with the low-order type bits set).

There's no reason to waste another word when you only need two bits and
already have spare space for a machine implementation field (i.e. where .type
is now).


Thanks,
Roland
