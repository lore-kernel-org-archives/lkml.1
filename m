Return-Path: <linux-kernel-owner+w=401wt.eu-S1763511AbXEWIrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763511AbXEWIrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 04:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbXEWIrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 04:47:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757277AbXEWIro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 04:47:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: Alan Stern's message of  Wednesday, 16 May 2007 15:03:20 -0400 <Pine.LNX.4.44L0.0705151150320.3192-100000@iolanthe.rowland.org>
Emacs: an inspiring example of form following function... to Hell.
Message-Id: <20070523084710.997A11F8511@magilla.localdomain>
Date: Wed, 23 May 2007 01:47:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > This does not happen in reality.  Breakpoints can only be set by the
> > debugger, not by the program itself.  The debugger should always eat the trap.
> 
> Hmmm.  I put in a little extra code to account for the possibility that
> a program might want to set hardware breakpoints in itself.  Should
> this be removed?

Do you just mean a register_hw_breakpoint call made on current?  That
certainly ought to work.  That's still "the debugger", i.e. in utracespeak
the tracing engine.  My point was that there will never be a facility
intended for a program to use hw_breakpoint to generate a signal that gets
delivered to a handler in the vanilla way.  There's always some "outside"
agent who asked for the breakpoint and who is responsible for responding to
the traps it causes, never the program itself so as it would make sense for
it to actually see the signal in the end.

> > I guess my main objection to having .type and .len is the false implied
> > documentation of their presence and names, leading to people thinking they
> > can look at those values.  In fact, they are machine-specific and
> > implementation-specific bits of no intrinsic use to anyone else.
> 
> The fact that they are machine-specific and implementation-specific 
> doesn't necessarily make them of no use.  See the driver below.

The code in bp_show is exactly the kind of wrong I want to prevent.  When I
say they are machine-specific and implementation-specific, I mean there is
no specified part of the interface to which you can presume they correspond
directly.  The powerpc implementation will not have any field that is set
to HW_BREAKPOINT_LEN_8 and may well have none set to the type macros
either.  If you want to have some machine-specific macros or inlines to
yield the HW_BREAKPOINT_* values for a struct hw_breakpoint, then fine.

> Allow me to rephrase: When a debug exception occurs, the real DR6 value
> should be copied to vdr6, except that kprobes should adjust DR_STEP and
> hw_breakpoint should adjust the DR_TRAPn bits appropriately.  There's
> some question about what value the debug exception handler should write
> back to DR6, if anything.  

Agreed.

> As for what users expect of the low four bits, you are definitely 
> wrong.  My tests with gdb show that it relies on the CPU to clear those 
> bits whenever a data breakpoint is hit; it doesn't clear them itself 
> and it doesn't work properly if the kernel keeps virtualized versions 
> of them set.  That's on a Pentium 4 and on an AMD Duron.

Ok.  We were both going on what the manual said and I was assuming that
some chip had actually behaved that way and thus that's what users expect.

> 	Values written back to DR6 were retained in the register until 
> 	the next debug exception occurred.

Ok.  This behavior is invisible anyway.

> 	When the exception handler read DR6, the 0xffff0ff0 bits were
> 	set every time.  The 0x00001000 bit was never set, even if it
> 	had been turned on before the exception occurred.

Ok.  That is not really surprising.

> 	No matter what values were stored in the low four bits
> 	beforehand, when the exception occurred DR6 had only the
> 	bit for the debug register which was triggered.

Ok.  This makes the users' expectations make sense.  Maybe we can get the
Intel and AMD people to change the manual not to be misleading about this
(it says something terse about "never clears" and without more details I
read it as "never clears any bit, ever").  

What about DR_STEP?  i.e., if DR_STEP was set from a single-step and then
there was a DR_TRAPn debug exception, is DR_STEP still set?  If DR_TRAPn
was set and then you single-step, is DR_TRAPn cleared?

> 	If the handler wrote back any of BS, BT, or BD to DR6, then
> 	the system misbehaved.  I don't know exactly what happened,
> 	but my shell process ended and the debug handler got called
> 	over and over again (as if stuck in a loop) for several
> 	seconds.

Yowza.  That is really surprising.

> In light of these results, the best approach appears to be either to 
> leave DR6 alone or to set it to 0.

Agreed.  I suspect clearing it to zero is the right thing (given what the
hardware manuals say), even if it appears that DR_STEP and DR_TRAPn do
reset each other on the chips we have on hand.

> Below is a patch containing a driver meant for testing kernel hardware 
> breakpoints.  Instructions are in the comments at the top.  You can 
> build the driver by typing "make M=bptest" at the top level.

Thanks.

> The patch also adjust the Alt-SysRq-P handler to print out the debug 
> register values along with all the other stuff.

I think you should post that little patch (and equivalent for x86_64) by
itself.  There's no reason that shouldn't go right in.

> I took a look at seqlock.h.  It turns out not to be a good match for my 
> requirements; the header file specifically says that it won't work with 
> data that contains pointers.

There is no black magic about that, it's just saying that seqlock/seqcount
does not do any implicit synchronization with your data structure
management.  If the pointers in question are protected by RCU, there is no
problem (if your read_seqcount_retry loop is inside rcu_read_lock).  Since
the caller supplies the pointers, not requiring them to be freed by RCU
would be simplest for callers.  So what seems natural to me is to have a
simple unsigned long kdr[4] array that's updated by register/unregister
calls (while they hold the mutex to exclude each other).

> The "switching"/"restart" stuff doesn't need memory barriers because
> all the communication is between two routines on the same CPU.  Nor are 
> memory barriers needed in the rest of the code for the kernel 
> breakpoint updates; the IPI mechanism already provides its own.

Ok.  I thought we were talking about using seqlock to safely read from a
single global data set that's updated in place.  I can't really see why
anything but bp_task actually needs to be per-cpu.

> A memory barrier is necessary to avoid chaos if another CPU should
> happen to update the kernel breakpoint settings at the same time.  If
> you can suggest a way around it, please do.

The natural thing to me would be to just use the same seqcount-based update
style from a global kdr[4] here.

> 	Take care of the DR7 calculations;

Call it a generic "make it go after setting each debug register".
For most other machines this will be a no-op.

> 	Do address limit verification (see whether a pointer
> 	lies in user space or kernel space).

This is probably always < TASK_SIZE_OF (or TASK_SIZE #ifndef),
but it is probably right to make it an arch macro.

> 	Dumping the debug registers while creating an aout-type
> 	core image;

Ha.  Probably noone else has that arcane bit of compatibility to do, in fact.

> 	All the legacy ptrace stuff;

Right.  There is nothing in common about this except for needing something
(so maybe an arch-defined struct inside the struct thread_hw_breakpoint).

> Does all that sound about right?  

It does.

> How should this be arranged so that it can build okay on all platforms,
> even ones where the low-level support code hasn't been written?  Maybe 
> an arch-dependent CONFIG_HW_BREAKPOINT option?

I am no authority on kconfig, so seek other advice.  

What kprobes does is a separate "config KPROBES" in each arch/foo/Kconfig.
This means that the details and help text must be given separately for each
one.  This is a bug or a feature, depending on whether you dislike
repeating the same help text in several places and having it drift and not
stay uniformly maintained, or you want to include different arch-specific
details in the text.

The other option I see is one central:

config HW_BREAKPOINT
	depends on X86 || X86_64 || ...
	...

AIUI, with this, arch/foo/Kconfig can still have just the lines:

config HW_BREAKPOINT
	depends on !FOOBAR

when the FOOBAR submodel of the foo arch does not have the hardware
support, or for whatever reason an arch adds more constraints to the
generically-defined config option.

The latter one is what I would do, but I might get corrected if I did.


Thanks,
Roland


