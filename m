Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbXCMS4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbXCMS4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 14:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932583AbXCMS4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 14:56:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50397 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932260AbXCMS4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 14:56:31 -0400
Date: Tue, 13 Mar 2007 14:56:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070313080150.7C9061801C5@magilla.sf.frob.com>
Message-ID: <Pine.LNX.4.44L0.0703131230540.2509-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007, Roland McGrath wrote:

> > At that moment D, running on CPU 1, decides to unregister a breakpoint in
> > T.  Clearing TIF_DEBUG now doesn't do any good -- it's too late; CPU 0 has
> > already tested it.  CPU 1 goes in and alters the user breakpoint data,
> > maybe even deallocating a breakpoint structure that CPU 0 is about to
> > read.  Not a good situation.
> 
> You make it sound like a really good case for RCU. ;-)
> 
> > No way to tell when a task being debugged is started up by anything other 
> > than its debugger?  Hmmm, in that case maybe it would be better to use 
> > RCU.  It won't add much overhead to anything but the code for registering 
> > and unregistering user breakpoints.
> 
> Indeed, it is for this sort of thing.

Well, if I have to use it then I will.

>  Still, it feels like a bit too much
> is going on in switch_to_thread_hw_breakpoint for the common case.
> It seems to me it ought to be something as simple as this:
> 
> 	if (unlikely((thbi->want_dr7 &~ chbi->kdr7) != thbi->active_tdr7) {
> 		/* Need to make some installed or uninstalled callbacks.  */
> 		if (thbi->active_tdr7 & chbi->kdr7)
> 			uninstalled callbacks;
> 		else
> 			installed callbacks;
> 		recompute active_dr7, want_dr7;
> 	}
> 
> 	switch (thbi->active_bkpts) {
> 	case 4:
> 		set_debugreg(0, thbi->tdr[0]);
> 	case 3:
> 		set_debugreg(1, thbi->tdr[1]);
> 	case 2:
> 		set_debugreg(2, thbi->tdr[2]);
> 	case 1:
> 		set_debugreg(3, thbi->tdr[3]);
> 	}
> 	set_debugreg(7, chbi->kdr7 | thbi->active_tdr7);

Yes, the code could be reworked by moving some of the data from the CPU
hw-breakpoint info into the thread's info.  I'll see how much simpler it
ends up being.

> Only in the unlikely case do you need to worry about synchronization,
> whether it's RCU or spin locks or whatever.  The idea is that breakpoint
> installation when doing the fancy stuff would reduce it to "the four
> breakpoints I would like, in order" (tdr[3] containing the highest-priority
> one), and dr7 masks describing what dr7 you were using last time you were
> running (active_tdr7), and that plus the enable bits you would like to have
> set (want_dr7).  The unlikely case is when the number of kernel debugregs
> consumed changed since the last time you switched in, so you go recompute
> active_tdr7.  (Put the body of that if in another function.)

It isn't quite that easy.  Even though the number of user breakpoints may
not have changed, their identities may have.  So the unlikely case has to
encompass two possibilities: the number of installable user breakpoints
has changed, or any user breakpoints have been registered or unregistered.

> For the masks to work as I described, you need to use the same enable bit
> (or both) for kernel and user allocations.  It really doesn't matter which
> one you use, since all of Linux is "local" for the sense of the dr7 enable
> bits (i.e. you should just use DR_GLOBAL_ENABLE).

This shouldn't be necessary.  So long as DR_GLOBAL_ENABLE always belongs
to the kernel's part of DR7 and DR_LOCAL_ENABLE always belongs to the
thread's part there will be no interference between them.

> It's perfectly safe to access all this stuff while it might be getting
> overwritten, and worst case you switch in some user breakpoints you didn't
> want.  That only happens in the SIGKILL case, when you never hit user mode
> again and don't care.

Maybe.  I always had in the back of my mind the possibility that there
might be a user I/O breakpoint set.  It could be triggered by an interrupt
handler even in the SIGKILL case.  But since we're not supporting I/O
breakpoints now, that's a moot point.

> > +void switch_to_thread_hw_breakpoint(struct task_struct *tsk)
> [...]
> > +	/* Keep the DR7 bits that refer to kernel breakpoints */
> > +	get_debugreg(dr7, 7);
> > +	dr7 &= kdr7_masks[chbi->num_kbps];
> 
> I don't understand what this part is for.  Why fetch dr7 from the CPU?  You
> already know what's there.  All you need is the current dr7 bits belonging
> to kernel allocations, i.e. a chbi->kdr7 mask.

Actually the code _doesn't_ already know what's there; the chbi area
doesn't include any storage for the kernel DR7 value.  I figured it was at
least as easy to read it from the CPU register as to read it from memory.  
But maybe that's not true; according to my ancient processor manual, moves
to/from debug registers take many more clock cycles than moves to/from
memory.

> > +	if (tsk && test_tsk_thread_flag(tsk, TIF_DEBUG)) {
> 
> switch_to_thread_hw_breakpoint is on the context switch path.  On that
> path, this test can never be false.  The context switch path should not
> have any unnecessary conditionals.  If you want to share code with some
> other places that now call switch_to_thread_hw_breakpoint, they can share a
> common inline for part of the guts.

Okay.  That test was for situations when it's necessary to install only 
the kernel's debug registers, with no thread registers.  It can easily 
be made into a separate routine.

> > +		set_debugreg(dr7, 7);	/* Disable user bps while switching */
> 
> What is this for?  The kernel's dr7 bits are already set.  Why does it
> matter if bits enabling user breakpoints are set too?  No user breakpoint
> can be hit on this CPU before this function returns.

I was being overly cautious.  If interrupts were enabled then it might be 
possible to trip a user I/O breakpoint.  But since they aren't, that code 
isn't needed.

> > +	/* Clear any remaining stale bp pointers */
> > +	while (--i >= chbi->num_kbps)
> > +		chbi->bps[i] = NULL;
> 
> Why is this done here?  This can be done when the kernel allocations are
> installed/uninstalled.

No.  If a debugger has removed some user breakpoints since the last time
the thread ran, the chbi->bps[] entries could still be present.  Likewise
if the previously-running task had more breakpoints than the current one.

Of course it doesn't actually hurt to have stale pointers lying around;
they refer to breakpoints which aren't enabled.  So clearing them isn't
really necessary.

> > @@ -15,6 +15,7 @@ struct die_args {
> >  	long err;
> >  	int trapnr;
> >  	int signr;
> > +	int ret;
> >  };
> 
> I don't understand why you added this at all.
> 
> >  fastcall void __kprobes do_debug(struct pt_regs * regs, long error_code)
> [...]
> > +	if ((args.err & (DR_STEP|DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) ||
> > +			args.ret)
> > +		send_sigtrap(tsk, regs, error_code);
> 
> The args.err test is fine.  A notifier that wants the SIGTRAP sent should
> just leave the appropriate DR_* bit set rather than clear it.
> 
> In hw_breakpoint_handler, you could just change:
> 
> 		if (i >= chbi->num_kbps)
> 			data->ret = 1;
> to:
> 
> 		if (i < chbi->num_kbps)
> 			data->err &= ~(DR_TRAP0 << i);

This proposed change is wrong.  Remember that ptrace breakpoints are 
virtualized; they are assigned to different debug registers from what the 
debugger thinks.  That's why I added args.ret.

> But really I think you might as well just have the triggered callback call
> send_sigtrap itself.  That's fine for ptrace_triggered.  When I get to a
> utrace-based layer on this, it can either send the signal itself in the
> same way, or do something else better if I have another option by then.

This sounds like a better solution.


> After all that fun x86 implementation detail, now I have some comments
> about the interface.  I took a gander at what implementing hw_breakpoint on
> powerpc would be like, and it looks pretty simple.  It gave me some more
> detailed thoughts about making the source API more uniformly convenient
> across machines.
> 
> Firstly, everything but a few #define's should be in a shared file.  First
> I was thinking linux/hw_breakpoint.h, but now I think it should be
> asm-generic/hw_breakpoint.h and asm-{i386,x86_64,...}/hw_breakpoint.h do:
> 
> 	#define HW_BREAKPOINT_...
> 	#include <asm-generic/hw_breakpoint.h>
> 
> That way, asm/hw_breakpoint.h is what modules #include, and that file is
> just absent on machines without the support (as opposed to a
> linux/hw_breakpoint.h that's there but not always useful).
> 
> > +struct hw_breakpoint {
> [...]
> > +	void		*address;
> 
> You might actually want to write this:
> 
> 	union {
> 		void *kernel;
> 		void __user *user;
> 		unsigned long va;
> 	} address;
> 
> Setting the address uses the appropriate pointer.  Turning it into a debug
> register value uses va.  This helps maintain discipline of using __user, so
> that kernel analysis tools can reliably cite use of user or kernel
> addresses as right or wrong.
> 
> > +	u8		len;
> > +	u8		type;
> 
> I don't think we actually want to expose these as fields in this way at all.
> Instead, just a single field of machine-format bits, and then "encoding"
> for dr7 values is just:
> 
> 	dr7 |= bp->bits << hwnum;
> 
> This field is not set by the user directly, but by the registration call.
> It takes type and len arguments, validates and combines them.  There is no
> need for encoding really, just validation and use the hardware bits in the
> asm/hw_breakpoint.h constants with standard names:
> 
> #define HW_BREAKPOINT_LEN1	DR_LEN_1
> ...

I don't like using DR_LEN_1, because it would force asm/debugreg.h to be 
#included by any user of hw_breakpoint.  The raw numerical value should do 
just as well.

> On powerpc, the address breakpoint is always for an 8-byte address range.

So there's no way to trap on accesses to a particular byte within a
string?

> Also, it has distinct bits for breaking on loads and breaking on stores,
> but no hardware instruction breakpoint is supported.
> So it would define:
> 
> #define HW_BREAKPOINT_LEN8		0xc001d00d
> #define HW_BREAKPOINT_TYPE_READ		1
> #define HW_BREAKPOINT_TYPE_WRITE	2
> #define HW_BREAKPOINT_TYPE_RW		3
> 
> Using two args in the registration calls lets it do validation simply with:
> 
> 	if (len != HW_BREAKPOINT_LEN8 || (type &~ 3))
> 		return -EINVAL;
> 	bp->bits = type;
> 
> while still verifying that an explicit length is used by the caller.
> The validation is also simple on x86, and then:
> 
> 	bp->bits = ((len | type) << DR_CONTROL_SHIFT) | 2;

Not quite that simple, but close to it.  (len | type) ends up being
shifted by 4*drnum whereas the enable bit gets shifted by 2*drnum (where
drnum is the debug register assigned to the breakpoint), so they can't be
stored together.  But the enable bit doesn't need to be present in
bp->bits; it is implied.

> This source interface lets a module use #ifdef HW_BREAKPOINT_* to figure
> out what's available without needing any specific machine knowledge.
> Also, HW_BREAKPOINT_TYPE_EXECUTE should have HW_BREAKPOINT_LEN_EXECUTE
> that is the required argument for that type, so callers don't have to
> encode the machine knowedlge of using LEN1 for execute.

Better yet, if type is HW_BREAKPOINT_TYPE_EXECUTE then just ignore the
caller's len and always use the correct value.

> The definition of "breakpoint length" on all the machines (whether a single
> length is available or more) seems to be that the breakpoint address has to
> be aligned to the length and what it catches is any access to any byte
> within that range.  i.e., the length means a mask of low bits cleared from
> an address before it's compared the the breakpoint address.  (On powerpc,
> the low three bits of the register are used as flags, so only the high bits
> of the address are even stored.)
> 
> The hw_breakpoint documentation should make this definition more explicit,
> and it probably ought to enforce the alignment of the address specified.

Since PPC doesn't allow lengths shorter than 8, perhaps on that 
architecture the bottom bits of the address should silently be cleared.

> > +#define HW_BREAKPOINT_IO	0x2	/* trigger on I/O space access */
> 
> Let's not define a name for this while we are not really supporting it.
> 
> > +/* HW breakpoint status values */
> > +#define HW_BREAKPOINT_REGISTERED	1
> > +#define HW_BREAKPOINT_INSTALLED		2
> 
> This doesn't really need to be public outside of hw_breakpoint.c, does it?

It gives drivers a way to tell whether or not the breakpoint is currently 
installed without having to do explicit tracking of installed() and 
uninstalled() callbacks.

These changes to the API sound pretty good.  Stay tuned for the next
version...

Alan Stern

