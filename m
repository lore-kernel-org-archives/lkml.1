Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbXC2VfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbXC2VfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 17:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbXC2VfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 17:35:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37568 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753160AbXC2VfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 17:35:21 -0400
Date: Thu, 29 Mar 2007 17:35:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070328213951.BCD5B1801C4@magilla.sf.frob.com>
Message-ID: <Pine.LNX.4.44L0.0703291641180.4663-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007, Roland McGrath wrote:

> Sorry I've been slow in responding to your most recent version.
> I fell into a large hole and couldn't get out until I fixed some bugs.

That's okay; the same thing happens to everyone from time to time.


> > No, I'm not confused and neither are you.  I realize there's no functional 
> > difference between the two sets of enable bits, since Linux doesn't use 
> > hardware task-switching.  I just like to keep things neatly separated, 
> > that's all.
> 
> I don't really know what more to say.  I like things neatly separated too,
> most especially between clearly meaningful and misleading yet apparently
> meaningful.  Overloading unrelated hardware bits for no material purpose
> will never make sense to me.

Well, I can change it easily enough.


> > > How would that happen?  This would mean that some user process has been
> > > allowed to enable ioperm for some io port that kernel drivers also send to
> > > from interrupt handlers.  Can that ever happen?
> > 
> > I haven't checked the ioperm code to be certain, but it seems like the 
> > sort of thing somebody might want to do on occasion.
> 
> I checked the ioperm code.  As far as I can tell, if you have CAP_SYS_RAWIO
> then you can use ioperm to enable any port you want, so this will always be
> possible.  (That seems a bit nutty to me, hence my earlier reaction.)

At this stage it's a moot point anyway.


> > > > It gives drivers a way to tell whether or not the breakpoint is currently
> > > > installed without having to do explicit tracking of installed() and 
> > > > uninstalled() callbacks.
> > > 
> > > How could that ever be used that would not be racy and thus buggy?  A
> > > registration call on another CPU could cause a change and callback just
> > > after you fetched the value.
> > 
> > Not if you have interrupts disabled.  Debug register settings are 
> > disseminated from one CPU to the others by means of an IPI.
> 
> But the callback is not per-CPU, it is per-registration.  When a new
> registration displaces an old one, or a deregistration stops displacing
> one, isn't the status change in the data structure and the callback made
> right away, by the thread doing the registration/deregistration call?
> Another CPU with interrupts disabled won't have its breakpoints actually
> change, but the data structure will have changed.  Isn't that right?

Not quite right.  The status change in the data structure isn't made until
after all the IPIs have completed, which won't happen until all the CPUs
have responded.  A CPU with interrupts disabled will therefore delay the
status change as well as the debug-register update, and so the value of
bp->status would remain valid until interrupts were enabled.


> > I also decided against adding a .bits member.  It doesn't really gain very 
> > much; the savings in encoding the breakpoint values is trivial -- one line 
> > of code on i386.  
> 
> I think this is a mistake.  On other machines, there is no need for more
> than one field and .len will go unused.  There is no reason not to encode
> ahead of time.  If it's useful for callers to be able to extract the type
> and length from a struct hw_breakpoint, it's easy to define macros or
> inlines in asm/hw_breakpoint.h that go the other way.

I'm not entirely convinced.

Consider first that the computation involved in encoding .bits is just a
little more complicated than one would like to do at compile time.  (At
least, it is on x86_64.)  Callers would have to do it themselves
dynamically, or else pass len and type as arguments to the
register_hw_breakpoint routines (which would mean an unused argument on
those other machines).  In general it just makes things harder on callers.

The fact the .len would go unused on some architectures shouldn't matter.  
It's just a u8; .len and .type together take up no more space than .bits 
would.

However, if you insist I can still change things over.

> > And it helps to have the original length and type values available for
> > use by the ptrace routines.  
> 
> There's no reason __modify_user_hw_breakpoint can't use an encoded value.
> modify_user_hw_breakpoint can do checking and encoding before taking the lock.

Come to think of it, we don't really need modify_user_hw_breakpoint at
all.  It could be replaced by an {unregister(old); register(new);}
sequence.  Unless you think there's some pressing reason to keep it, my
inclination is to do away with it.


> My review comments below are about your patch of 3/22 (described as
> "actually works with 2.6.21-rc4").
> 
> > -	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
> > -					SIGTRAP) == NOTIFY_STOP)
> > +	args.regs = regs;
> > +	args.str = "debug";
> > +	get_debugreg(args.err, 6);
> > +	set_debugreg(0, 6);	/* DR6 is never cleared by the CPU */
> > +	args.trapnr = error_code;
> > +	args.signr = SIGTRAP;
> > +	if (atomic_notifier_call_chain(&i386die_chain, DIE_DEBUG, &args) ==
> > +			NOTIFY_STOP)
> 
> Put it back using notify_die, just pass dr6 instead of error_code.

I'd like to.  But with notify_die, the DR6 value whose address is passed
to the notifier chain (args.err) is local to an inlined function.  
Modifications to that value made by the callout routines on the chain
would be lost when notify_die returns.

Hmm...  Maybe I could store a pointer to the DR6 value in args.err instead
of the value itself...


> > -#define DR_LOCAL_SLOWDOWN (0x100)   /* Local slow the pipeline */
> > -#define DR_GLOBAL_SLOWDOWN (0x200)  /* Global slow the pipeline */
> > +#define DR_LOCAL_EXACT (0x100)       /* Local slow the pipeline */
> > +#define DR_GLOBAL_EXACT (0x200)      /* Global slow the pipeline */
> 
> Don't mess with these names if there isn't a good reason.
> It's unrelated to the work you're doing.

I was about to disagree, but a second look at the Intel documentation
shows that those bits don't have any real name (other than LE and GE,
which is why I changed the macros).

As I understand it, setting one of those bits is necessary on the 386 but
not necessary for later processors.  Should this be controlled by a
runtime (or compile time) check?  For that matter, do those bits have any
effect at all on a Pentium?


> > Execute-breakpoint traps occur before the
> > + * breakpointed instruction runs; all other types of trap occur after the
> > + * memory access has taken place.  
> 
> We need to say something about the restart behavior.  i.e., figure out the
> situation with the x86 RF flag and what the story is on other machines that
> have instruction breakpoint registers.

My Intel manual says that the CPU automatically sets the RF bit in the
EFLAGS image stored on the stack by the debug exception.  Hence the
handler doesn't have to worry about it.  That's why I removed it from the 
existing code.


> > + * Hardware breakpoints are implemented using the CPU's debug registers,
> > + * which are a limited hardware resource.  Requests to register a
> > + * breakpoint will always succeed (provided the parameters are valid),
> 
> I've said before and still maintain that there should be the option to have
> a NULL installed callback and fail immediately if it can't be installed
> right now.  The wording below about installed being NULL is not clear on
> what this means.

Setting a callback pointer to NULL generally means that you don't want or
care about callbacks.  Trying to make it mean something else will only
confuse people.

If callers want to give up when a kernel breakpoint isn't installed 
immediately, all they have to do is check the return value from 
register_kernel_hw_breakpoint and call unregister_kernel_hw_breakpoint.  
If you really want it, I could add an extra "fail if not installed" 
argument flag.

For user breakpoints, the whole notion is almost meaningless.  Even if the
breakpoint was allocated a debug register initially, it could get
displaced by the time the debuggee task next runs.


> > +	Set RF flag bit for execution faults?
> 
> Yes, I don't think you'll ever progress if you haven't set it.  However,
> setting it opens a can of worms.  Once you set it, the bit could leak into
> a signal context, or be seen via ptrace, or stay set when ptrace changes
> the pc, etc.  It requires some investigation.

I mentioned that question because I had removed the existing code, which
didn't seem to be necessary.  I wanted to make sure this was the correct
thing to do.


> > +	TF flag bit for single-step exceptions in kernel space?
> 
> What's the question?  I don't think hw_breakpoint has anything to do with
> TF or single-step at all.

Again, this was referring to existing code which I basically copied 
without fully understanding.  Does the new code in do_debug do the right 
thing with regard to TF?


> > Index: usb-2.6/arch/i386/kernel/hw_breakpoint.c
> 
> Though you've split the header file into generic and i386, I see this is
> all still in the i386 file.  I'd like to see the shareable code (list
> handling, priority stuff, multi-CPU coordination) in a common file.  For
> x86_64, all the machine-specific code is all but identical (literally just
> one bit different), so it might as well actually share the i386 source
> file.  But I'm keen to do the powerpc64 machine-dependent bits as soon as
> your generic code is making it easy enough for me. :-)
> 
> I think the ia64 version will be straightforward too, though I won't do
> that one myself.  A notable difference on these processors (and maybe all
> other ones that have breakpoint registers) is that execute breakpoints and
> data breakpoints are separate disjoint resources.  There may be zero
> execute breakpoint registers or a few, and may be one data breakpoint
> register or a few, but there is no single HB_NUM of how many breakpoint
> slots for any kind whatever.

I'll go through the file and see which parts really can be shared.  It
might end up being less than you think.

Note that doing this would necessarily create a bunch of new public 
symbols.  Routines that I now have declared static wouldn't be able to 
remain that way.


> > +	/* Block kernel breakpoint updates from other CPUs */
> > +	local_irq_save(flags);
> 
> I have a feeling this is more costly than we want, though I don't really
> know.  It seems to me that things in struct cpu_hw_breakpoint are not
> really per-CPU, except for bp_task.  They are "current global state",
> right?

Not really, since changes to the debug registers on multiple CPUs cannot
be made simultaneously.  There will be short periods when different CPUs
have different debug register values.  What if a debug exception occurs
during one of those periods?  Or what if a task switch occurs?

>  So I think it fits well to have the per_cpu struct contain just
> bp_task and a pointer to the current state struct, and use RCU to replace
> that struct when registrations change.  Perhaps rather than actually
> updating other CPU's pointers in the RCU fashion, that would just be done
> by each CPU for itself from the IPI handler that changes the hardware.
> Still, it just requires rcu_read_lock+rcu_dereference at context switch.

See how you like the new implementation in the next version (when it's
ready).  The local_irq_save can be avoided by extending the size of the
RCU critical section.


> > +	/* Mask in the parts of DR7 that refer to the new thread */
> > +	chbi->dr7 = chbi->kdr7 | (~chbi->kdr7_mask & thbi->tdr7);
> > +	set_debugreg(chbi->dr7, 7);
> 
> I'd say it's worth saving the loads here to recompute tdr7 with the
> kernel-used bits masked out and cache it that way, so the fast path 
> looks at only thbi->tdr7|chbi->kdr7.  

Doing it that way would require all the thbi->tdr7 values in all tasks
being debugged to be updated whenever the kdr7_mask value changes.  It's
not impossible, but it could have a high cost in terms of cacheline
contention on SMP systems.  Maybe you don't think that's a big issue.

For that matter, as long as you're going to update thbi->tdr7 with the
kernel bits masked out, why not go ahead and mask in the kernel's kdr7
bits as well?  Then no computation would be needed during task switches 
at all.

Alan Stern

