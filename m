Return-Path: <linux-kernel-owner+w=401wt.eu-S932847AbXF2Dg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbXF2Dg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 23:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765283AbXF2Dgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 23:36:47 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1649 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1765087AbXF2Dgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 23:36:46 -0400
Date: Thu, 28 Jun 2007 23:36:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070628023100.E46AB4D05E6@magilla.localdomain>
Message-ID: <Pine.LNX.4.44L0.0706282300280.27792-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Roland McGrath wrote:

> I did the first crack at a powerpc port.  I'd appreciate your comments on
> this patch.  It should not be incorporated, isn't finished, probably breaks
> ptrace, etc.  I'm posting it now just to get any thoughts you have raised
> by seeing the second machine share the intended arch-independent code.

I'll go over it in detail and get back to you later.

> I just translated your implementation to powerpc terms without thinking
> about it much.  If you see anything that you aren't sure is right, please
> tell me and don't presume there is some powerpc-specific reason it's
> different.  More likely I just didn't think it through.
> 
> In the first battle just to make it compile, the only issue was that you
> assume every machine has TIF_DEBUG, which is in fact an implementation
> detail chosen lately by i386 and x86_64.  AFAIK the only reason for it
> there is just to make a cheap test of multiple bits in the hot path
> deciding to call __switch_to_xtra.  Do you rely on it meaning something
> more precise than just being a shorthand for hw_breakpoint_info!=NULL?

I don't.  I used TIF_DEBUG because it was already there and it was 
atomic.  But setting hw_breakpoint_info is equally atomic, so there's 
no reason to keep TIF_DEBUG.

> Incidentally, I think it would be nice if kernel/hw_breakpoint.c itself had
> all the #include's for everything it uses directly.  arch hw_breakpoint.c
> files probably only need <asm/hw_breakpoint.h> and one or two others to
> define what they need before #include "../../../kernel/hw_breakpoint.c".

Okay.

> The num_installed/num_kbps stuff feels a little hokey when it's really a
> flag because the maximum number is one.  It seems like I could make it
> tighter with some more finesse in the arch-specific hook options, so that
> chbi and thbi each just store dabr, dabr!=0 means "mine gets installed",
> and the switch in is just chbi->dabr?:thbi->dabr or something like that.

You certainly can do that in the hook routines.  But the generic code
still needs to use num_installed (which doesn't get used very much) and
num_kbps.

> As we get more machines, more cleanups along these lines will probably make
> sense.  (Also, before the next person not me or you tries a port, we could
> use for the generic hw_breakpoint.c to get some comments at the top making
> explicit what the arch file is expected to define in its types, etc.)

Good idea.  Splitting the code into two pieces made it considerably 
more opaque.

> With just the included change to the generic code for the TIF_DEBUG, this
> kind of works.  That is, it doesn't break everything else and I can use
> bptest, sort of.  I didn't even try ptrace, I probably broke that.
> 
> It works enough to make clear the main new wrinkle.  On powerpc, the data
> breakpoint exception is a fault before the instruction executes, not a trap
> after it.  The load/store will not complete until the breakpoint is cleared.
> With this patch, you can use bptest to generate a tight loop of bp0 triggers.

A nice new way to hang your machine!  :-)

> For ptrace compatibility, userland already expects to deal with this.  gdb
> has it as per-machine implementation options how ptrace watchpoints behave,
> and for powerpc it knows to remove the watchpoint, step, and reinsert it.
> 
> One approach for hw_breakpoint is just to expose in asm/hw_breakpoint.h
> some standard macros saying how things behave, and caveat emptor.  But I
> don't like that much.  I think things will just wind up being confused and
> inadvertently unportable if the important semantics vary too much between
> machines.  The point of the whole facility is to make watchpoints easy to
> use, after all.

Agreed.

> Some uses might be happy with trigger-before, but I don't see much benefit.

Other than ptrace backward-compatibility.

> For writing, the trigger function can look at the memory before it's
> changed.  But you could just as well have recorded the old value before
> setting the breakpoint, as you have to for trigger-after--and to see both
> old and new values you then need to single-step to get the new value, which
> trigger-after handles with a single exception.  For reading, the trigger
> function can change the memory before it's read.  But likewise, you could
> just as well have changed it before setting the breakpoint--you know noone
> will have read the new value until your trigger anyway.  (I have never used
> a read-triggered breakpoint, so I'm rather vague on those use scenarios.)

I never have either.  Possibly you might want to change the value just 
before the read, based on the address of the code doing the reading.  
But I've never heard of anyone doing that.

> The third machine whose manual I have handy is ia64.  It has instruction
> and data breakpoints that are both trigger-before.  It has processor flags
> similar to x86's RF for both, to ignore one or both breakpoint flavor for
> one instruction.  That makes it cheap to continue past the breakpoint since
> you don't have to clear and reset it.  But for getting new values from
> data-write breakpoints, it still requires a single-step and second stop,
> like powerpc.  (Incidentally ia64 has another interesting feature, which I
> think the generic code accomodates nicely as an upward-compatible addition
> just by changing the len arg in the register and arch_* calls to unsigned long,
> and adding an arch_validate_len that can short-circuit the generic length
> and alignment check.)
> 
> So, I'd like your thoughts on the whole situation.  The starting point we
> can do without anything else is:
> 
> 	int hw_breakpoint_triggers_before(struct hw_breakpoint *);
> 	int hw_breakpoint_can_resume(struct hw_breakpoint *);
> 
> or perhaps taking (unsigned int type) instead, in <asm-cpu/hw_breakpoint.h>.
> i.e. for x86:
> 
> #define hw_breakpoint_triggers_before(type) ((type) == HW_BREAKPOINT_EXECUTE)
> #define hw_breakpoint_can_resume(type) 	    1
> 
> and powerpc:
> 
> #define hw_breakpoint_triggers_before(any)	1
> #define hw_breakpoint_can_resume(any)		0

I prefer the second alternative.  For the first, you'd have to register 
the breakpoint before knowing how it will behave!

> For powerpc at least (and I figure for ia64 too) it seems easy enough to
> implement disable-step-enable to turn it into trigger-after.  But it is
> costly and hairy if one doesn't care.  So now I'm thinking to somewhat
> follow the kprobes model, and have pre and post trigger handler options.
> i.e.
> 
> 	int hw_breakpoint_pre_handle_type(unsigned type);
> 	int hw_breakpoint_post_handle_type(unsigned type);
> 
> and in struct hw_breakpoint (replacing trigger):
> 
> 	int	(*pre_handler)(struct hw_breakpoint *, struct pt_regs *);
> 	void	(*post_handler)(struct hw_breakpoint *, struct pt_regs *);
> 
> The pre_handler returns zero if it wants the post_handler to run.  On x86,
> register would return -EINVAL if pre_handler is not NULL and type is not
> EXECUTE (i.e. pre_handle_type returns false).  It also fails if
> post_handler is not NULL and post_handle_type returns false, meaning the
> arch code doesn't want to deal with step-over-and-trigger.

In general that sounds good.  But do we really want the register call
to fail if extra handlers are defined?  That approach makes portable
drivers harder to write.  Maybe it would be better to fail only if all
of the arch-supported handler alternatives are NULL.

> We'd still want hw_breakpoint_can_resume to tell whether you can return
> from a pre_handler and continue with no a post_handler, without needing to
> unregister the breakpoint.  That's true on ia64, while on powerpc you
> either have to clear the breakpoint or request the post_handler stepping logic.

Unregistering the breakpoint isn't good on SMP systems, since it would
be unregistered on all CPUs.  I think it would better to require all
arch's to support the stepping logic.

Alan Stern

