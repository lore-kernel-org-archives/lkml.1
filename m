Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbXC1Vk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbXC1Vk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 17:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbXC1Vk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 17:40:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbXC1Vk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 17:40:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: Alan Stern's message of  Wednesday, 14 March 2007 15:11:10 -0400 <Pine.LNX.4.44L0.0703141445240.7723-100000@iolanthe.rowland.org>
Emacs: well, why *shouldn't* you pay property taxes on your editor?
Message-Id: <20070328213951.BCD5B1801C4@magilla.sf.frob.com>
Date: Wed, 28 Mar 2007 14:39:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I've been slow in responding to your most recent version.
I fell into a large hole and couldn't get out until I fixed some bugs.

> No, I'm not confused and neither are you.  I realize there's no functional 
> difference between the two sets of enable bits, since Linux doesn't use 
> hardware task-switching.  I just like to keep things neatly separated, 
> that's all.

I don't really know what more to say.  I like things neatly separated too,
most especially between clearly meaningful and misleading yet apparently
meaningful.  Overloading unrelated hardware bits for no material purpose
will never make sense to me.

> > How would that happen?  This would mean that some user process has been
> > allowed to enable ioperm for some io port that kernel drivers also send to
> > from interrupt handlers.  Can that ever happen?
> 
> I haven't checked the ioperm code to be certain, but it seems like the 
> sort of thing somebody might want to do on occasion.

I checked the ioperm code.  As far as I can tell, if you have CAP_SYS_RAWIO
then you can use ioperm to enable any port you want, so this will always be
possible.  (That seems a bit nutty to me, hence my earlier reaction.)

> > > It gives drivers a way to tell whether or not the breakpoint is currently
> > > installed without having to do explicit tracking of installed() and 
> > > uninstalled() callbacks.
> > 
> > How could that ever be used that would not be racy and thus buggy?  A
> > registration call on another CPU could cause a change and callback just
> > after you fetched the value.
> 
> Not if you have interrupts disabled.  Debug register settings are 
> disseminated from one CPU to the others by means of an IPI.

But the callback is not per-CPU, it is per-registration.  When a new
registration displaces an old one, or a deregistration stops displacing
one, isn't the status change in the data structure and the callback made
right away, by the thread doing the registration/deregistration call?
Another CPU with interrupts disabled won't have its breakpoints actually
change, but the data structure will have changed.  Isn't that right?

> I implemented most of the changes we discussed.  Ignoring the length for 
> execute breakpoints turned out not to be a good idea because it would 
> affect the way ptrace works, so the code verifies it just like any other 
> kind of breakpoint.

I think that's perfectly fine.

> I also decided against adding a .bits member.  It doesn't really gain very 
> much; the savings in encoding the breakpoint values is trivial -- one line 
> of code on i386.  

I think this is a mistake.  On other machines, there is no need for more
than one field and .len will go unused.  There is no reason not to encode
ahead of time.  If it's useful for callers to be able to extract the type
and length from a struct hw_breakpoint, it's easy to define macros or
inlines in asm/hw_breakpoint.h that go the other way.

> And it helps to have the original length and type values available for
> use by the ptrace routines.  

There's no reason __modify_user_hw_breakpoint can't use an encoded value.
modify_user_hw_breakpoint can do checking and encoding before taking the lock.

> In fact, I decided to add a superfluous bit to the type code.  That's to
> help disambiguate between length and type values; it's easy to mix the
> two of them up.

It doesn't hurt to add some constant bits to the API values that you just
mask out (after checking) as part of the encoding convsersion.  In fact,
it's a good way to make sure people are using the right macros.

> Likewise, the length macros don't give the encoded values; that's so
> people can just specify the length directly instead of using the macro.

I object to this.  The purpose of having macros is to give a constrained
set of values that can be used at compile time.  Letting people use literal
numbers is just asking for people to write their calls unportably.  For
machines that support only LEN8, I'd planned to define it to some magic
bit pattern just so it could be checked and rule out cavalier users who
don't pay attention to the macros.

> There's a small question about the value of the error_code argument for 
> send_sigtrap().  The value passed into do_debug() isn't available in
> ptrace_triggered() -- but since it is always 0, that's what I'm using.  
> I'm not sure what it's supposed to mean anyway.

task->thread.trap_no and task->thread.error_code usually store the values
from the hardware trap frame when a trap is turned into a signal (e.g. see
do_trap).  This is the hardware trap number, which is 1 for do_debug.  The
error code is a word of the hardware trap frame whose meaning is specified
differently for each trap number.  For debug traps, it's always zero.
For other kinds of traps, it is sometimes useful to have the value.


My review comments below are about your patch of 3/22 (described as
"actually works with 2.6.21-rc4").

> -	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
> -					SIGTRAP) == NOTIFY_STOP)
> +	args.regs = regs;
> +	args.str = "debug";
> +	get_debugreg(args.err, 6);
> +	set_debugreg(0, 6);	/* DR6 is never cleared by the CPU */
> +	args.trapnr = error_code;
> +	args.signr = SIGTRAP;
> +	if (atomic_notifier_call_chain(&i386die_chain, DIE_DEBUG, &args) ==
> +			NOTIFY_STOP)

Put it back using notify_die, just pass dr6 instead of error_code.

> -#define DR_LOCAL_SLOWDOWN (0x100)   /* Local slow the pipeline */
> -#define DR_GLOBAL_SLOWDOWN (0x200)  /* Global slow the pipeline */
> +#define DR_LOCAL_EXACT (0x100)       /* Local slow the pipeline */
> +#define DR_GLOBAL_EXACT (0x200)      /* Global slow the pipeline */

Don't mess with these names if there isn't a good reason.
It's unrelated to the work you're doing.

> +
> +/*
> + * HW breakpoint additions
> + */
> +
> +#include <asm/hw_breakpoint.h>
> +#include <linux/spinlock.h>

Put all this inside #ifdef __KERNEL__.

> + * Appropriate macros are defined in include/asm/hw_breakpoint.h.
> + * Execute breakpoints must have @len equal to the special value
> + * %HW_BREAKPOINT_LEN_EXECUTE.

This should be more explicit about it being machine-dependent what subset
of the macros will be defined.

> Execute-breakpoint traps occur before the
> + * breakpointed instruction runs; all other types of trap occur after the
> + * memory access has taken place.  

We need to say something about the restart behavior.  i.e., figure out the
situation with the x86 RF flag and what the story is on other machines that
have instruction breakpoint registers.

> + * Hardware breakpoints are implemented using the CPU's debug registers,
> + * which are a limited hardware resource.  Requests to register a
> + * breakpoint will always succeed (provided the parameters are valid),

I've said before and still maintain that there should be the option to have
a NULL installed callback and fail immediately if it can't be installed
right now.  The wording below about installed being NULL is not clear on
what this means.

> +/* QUESTIONS
> +
> +	Error code in ptrace_triggered?

Zero is right.

> +	Set RF flag bit for execution faults?

Yes, I don't think you'll ever progress if you haven't set it.  However,
setting it opens a can of worms.  Once you set it, the bit could leak into
a signal context, or be seen via ptrace, or stay set when ptrace changes
the pc, etc.  It requires some investigation.

> +	TF flag bit for single-step exceptions in kernel space?

What's the question?  I don't think hw_breakpoint has anything to do with
TF or single-step at all.

> +	CPU hotplug, kexec, etc?

Using register_cpu_notifier in an __init function seems to be what
everything else does, or you can hack __cpu_up directly.  For kexec,
clearing dr7 in machine_kexec seems like a good idea.

> Index: usb-2.6/arch/i386/kernel/hw_breakpoint.c

Though you've split the header file into generic and i386, I see this is
all still in the i386 file.  I'd like to see the shareable code (list
handling, priority stuff, multi-CPU coordination) in a common file.  For
x86_64, all the machine-specific code is all but identical (literally just
one bit different), so it might as well actually share the i386 source
file.  But I'm keen to do the powerpc64 machine-dependent bits as soon as
your generic code is making it easy enough for me. :-)

I think the ia64 version will be straightforward too, though I won't do
that one myself.  A notable difference on these processors (and maybe all
other ones that have breakpoint registers) is that execute breakpoints and
data breakpoints are separate disjoint resources.  There may be zero
execute breakpoint registers or a few, and may be one data breakpoint
register or a few, but there is no single HB_NUM of how many breakpoint
slots for any kind whatever.

> +#include <asm-generic/percpu.h>

Surely this should be <asm/percpu.h>.

> +	/* Block kernel breakpoint updates from other CPUs */
> +	local_irq_save(flags);

I have a feeling this is more costly than we want, though I don't really
know.  It seems to me that things in struct cpu_hw_breakpoint are not
really per-CPU, except for bp_task.  They are "current global state",
right?  So I think it fits well to have the per_cpu struct contain just
bp_task and a pointer to the current state struct, and use RCU to replace
that struct when registrations change.  Perhaps rather than actually
updating other CPU's pointers in the RCU fashion, that would just be done
by each CPU for itself from the IPI handler that changes the hardware.
Still, it just requires rcu_read_lock+rcu_dereference at context switch.

> +	switch (chbi->num_kbps) {

Doesn't this unnecessarily do all four settings in a thread that only uses
one?  The old code did that too, but now it seems easy enough to cache the
number of active thread breakpoints and switch on that. 

> +	/* Mask in the parts of DR7 that refer to the new thread */
> +	chbi->dr7 = chbi->kdr7 | (~chbi->kdr7_mask & thbi->tdr7);
> +	set_debugreg(chbi->dr7, 7);

I'd say it's worth saving the loads here to recompute tdr7 with the
kernel-used bits masked out and cache it that way, so the fast path 
looks at only thbi->tdr7|chbi->kdr7.  

It does not seem necessary to cache the dr7 value.  Save the store.

	set_debugreg(chbi->kdr7 | thbi->tdr7, 7);

The only use of the saved value is in hw_breakpoint_handler,
which can juse use chbi->kdr7 | thbi->tdr7.


Thanks,
Roland
