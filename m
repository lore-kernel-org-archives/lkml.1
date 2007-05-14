Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbXENPmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbXENPmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 11:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbXENPmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 11:42:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38100 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755447AbXENPmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 11:42:20 -0400
Date: Mon, 14 May 2007 11:42:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070513103951.413A11F8516@magilla.localdomain>
Message-ID: <Pine.LNX.4.44L0.0705141026170.3283-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007, Roland McGrath wrote:

> This makes me think about RF a little more.  If you ever set it, there are
> some places we need to clear it too.  That is, when the PC is being changed
> before returning to user mode, which is in signals and in ptrace.  If the
> PC is changing to other than the breakpoint location hit by the handler
> that set RF, we need clear RF so that the first instruction at the changed
> PC can be a breakpoint hit of its own and not get masked.  In fact, it may
> also be necessary to clear RF when freshly setting a new instruction
> breakpoint (when RF is set because the stop was not a debug exception at
> all), so that it isn't skipped if the PC happens to be right there already.

It seems to me that signal handlers must run with a copy of the original
EFLAGS stored on the stack.  Otherwise, when the handler returned the
former context wouldn't be fully restored.  But I don't know enough about
the signal handling code to see how to turn off RF in the stored EFLAGS
image.

Also, what if the signal handler was entered as a result of encountering 
an instruction breakpoint?  In that case you would want to keep RF on to 
prevent an infinite loop.

You're right about wanting to clear RF when changing the PC via ptrace or
when setting a new execution breakpoint (provided the new breakpoint's
address is equal to the current PC value).

Do you know how gdb handles instruction breakpoints, and in particular, 
how it resumes execution after a breakpoint?


> > Come to think of it, we don't really need modify_user_hw_breakpoint at
> > all.  It could be replaced by an {unregister(old); register(new);}
> > sequence.  Unless you think there's some pressing reason to keep it, my
> > inclination is to do away with it.
> 
> I sort of wondered from the beginning why it was there.  The rationale I
> can see is to avoid flutter.  That is, when unregistering frees up a slot
> for a lower-priority allocation waiting in the wings, and then the new
> registration will just displace it again.  The priority list diddling is
> wasted work to get back to just how it was before, but more importantly you
> don't want to have those callbacks for a momentarily-available slot coming
> and going.  I don't know if this can really come up with the current code.

That may be what I originally had in mind; I no longer remember.

But it doesn't matter.  We're up against an API incompatibility here.  
gdb doesn't allow you to modify breakpoints; it forces you to delete the
old one and add a new one.  It's only an artifact of the x86 architecture
that gdb implements this by reusing debug registers.  So even if the 
modify_user_hw_breakpoint() routine were kept, gdb wouldn't really want to 
make use of it.

Under the circumstances I think we should just leave it out.


> > As I understand it, setting one of those bits is necessary on the 386 but
> > not necessary for later processors.  Should this be controlled by a
> > runtime (or compile time) check?  For that matter, do those bits have any
> > effect at all on a Pentium?
> 
> I've never heard of anyone using them, but I don't know the full story.

On the 386, either GE or LE had to be set for DR breakpoints to work 
properly.  Later on (I don't remember if it was in the 486 or the Pentium) 
this restriction was removed.  I don't know whether those bits do anything 
at all on modern CPUs.


> The documentation I have says that RF is set in the trap frame on the stack
> (i.e. pt_regs.eflags) by every other kind of exception.  However, for a
> debug exception that is due to an instruction breakpoint, RF=0 in the trap
> frame and the manual explicitly says that the handler must set the bit so
> that iret will resume and execute it rather than hit the breakpoint again.
> 
> [later:]
> > It also turns out that some CPUs don't automatically set the RF bit in 
> > the EFLAGS image on the stack.  Intel recommends that the OS always set 
> > that bit whenever a debug exception occurs, so that's what I did.
> 
> Is this really "some CPUs"?  Or is it actually always as I described above
> (i.e. RF set usually but cleared for an instruction breakpoint hit)?

My 80386 Programmer's Reference Manual says:

	... an instruction-address breakpoint exception is a fault.

And:

	When it detects a fault, the processor automatically sets
	RF in the flags image that it pushes onto the stack.

And:

	The processor automatically sets RF in the EFLAGS image
	on the stack before entry into any fault handler.  Upon
	entry into the fault handler for instruction address
	breakpoints, for example, RF is set in the EFLAGS image
	on the stack...

That seems to be pretty clear.  So the behavior can vary according to the 
processor type.


> > If callers want to give up when a kernel breakpoint isn't installed 
> > immediately, all they have to do is check the return value from 
> > register_kernel_hw_breakpoint and call unregister_kernel_hw_breakpoint.  
> > If you really want it, I could add an extra "fail if not installed" 
> > argument flag.
> 
> The important thing is that there aren't any difficult races (i.e. what you
> get with callbacks).  If register with no callback followed by unregister
> on seeing "registered but not installed" return value is simple and cheap,
> that is fine.

I suppose you might register a breakpoint and find that it isn't installed 
immediately, but then it could get installed and actually trigger before 
you managed to unregister it.  Does that count as a "difficult race"?  
Presumably the work done by the trigger callback would get ignored.


> > > > +	/* Block kernel breakpoint updates from other CPUs */
> > > > +	local_irq_save(flags);
> > > 
> > > I have a feeling this is more costly than we want, though I don't really
> > > know.  It seems to me that things in struct cpu_hw_breakpoint are not
> > > really per-CPU, except for bp_task.  They are "current global state",
> > > right?
> > 
> > Not really, since changes to the debug registers on multiple CPUs cannot
> > be made simultaneously.  There will be short periods when different CPUs
> > have different debug register values.  What if a debug exception occurs
> > during one of those periods?
> 
> I think it's fine if a CPU getting an exception before it's processed the
> IPI looks at changed global state and says "oh, mine was stale", and punts
> the hit.  (Or perhaps it transmorgifies its apparent DR# based on the new
> global state, if the CPU's old setting corresponds to one of the new
> settings.  Probably the changing of settings can just preserve the old DR#
> selection in such cases and simplify the situation for the handler doing
> the catch-up to just if (old->dr[n] != new->dr[n]) ignore;.)

Punting isn't acceptable, not if the bp in question was present both 
before and after the IPI.  I'd rather transmogrify it as you described, 
awkward though that may be.

Maybe it doesn't have to be so bad.  If there were _two_ global copies of
the kernel bp settings, one for the old pre-IPI state and one for the new,
then the handler could simply look up the DR# in the appropriate copy.  
This would remove the need to store the settings in the per-CPU area.


> > Here's the latest take on the hw_breakpoint patch.  I adopted most of your
> > suggestions.  There still isn't a .bits member, but or'ing the .len and
> > .type members together will give you essentially the same thing; both of
> > those values are now completely encoded.
> 
> I'd still prefer to have a single machine-dependent field and not have .len.

It's a relatively minor issue.  On machines with fixed-length breakpoints, 
the .len field can be ignored.  Conversely, leaving it out would require 
using bitmasks to extract the type and length values from a combined .bits 
field.  I don't see any advantage.


> I'm not entirely sanguine about an 8-bit gennum.  For the kernel
> settings, it's going to be fine--there won't be 256 updates before all
> the CPUs process their IPIs.  But for the thbi->gennum comparison, a
> thread might very well not have run for days, while there have been
> many more updates than that, and its gennum%256 matching the current
> one or not is just luck.  

Ah, you haven't understood the purpose of the gennum.  In fact 8 bits 
isn't too small -- far from it!  It's too _large_; a single bit would 
suffice.  I made it an 8-bit value just because that was easier.

Here's the idea.  thbi->gennum is at all times either equal to the current 
gennum value or is set to -1.  That's what notify_all_threads() does; it 
sets thbi->gennum to -1 in all tasks currently being debugged whenever a 
change to the kernel breakpoints occurs.  My assumption is that almost all 
of the time there will be very few debuggees.

The main use of gennum is with chbi->gennum, which is at all times equal
to the current gennum value or the previous one (if the CPU hasn't yet
received the update IPI).  Hence chbi->gennum needs to distinguish between
only two values: current or previous.

Note that CPUs can never lag behind by more than one update.  The 
hw_breakpoint_mutex doesn't get released until every CPU has acknowledged 
receipt of the IPI.


> You may need some memory barriers around the switching/restart stuff.
> In fact, I think it would be better not to delve into reinventing the
> low-level bits there at all.  Instead use read_seqcount_retry there
> (linux/seqlock.h).  Using that read_seqcount_begin's value as the
> number to compare in thbi would also give a 32-bit sequence number.
> 
> I don't see why notify_all_threads ever needs to be used.  The sequence
> number changed, so the next switch in will always update.  I guess
> that's how you were avoiding the untrustworthy 8-bit sequence number
> issue.  But I think it's better to do the whole thing with seqcount and
> rely on 32-bit sequence numbers being good enough to let thread updates
> be entirely lazy.

Yes, that was the idea.  However seqcounts may work better in conjunction
with this idea of keeping a global copy of both the old and the new kernel
breakpoints.  I'll look into it.


> It looks to me like there is quite a lot to be shared.  Of course the
> code can refer to constants like HB_NUM, they just have to be defined
> per machine.  The dr7 stuff can all be a couple of simple arch_foo
> hooks, which will be empty on other machines.  All of the list-managing
> logic, the prio stuff, etc., would be bad to copy.
> 
> The two flavors could probably be accomodated cleanly with an
> HB_TYPES_NUM macro that's 1 on x86 and 2 on ia64, and is used in loops
> around some of the calls.  I'm not suggesting you try to figure out
> that code structure ahead of time.  But I don't think it will be a big
> barrier to code sharing.

Hmmm, maybe.  Those loops would end up looking messy.


> > It turns out that on some processors the CPU does reset DR6 sometimes.  
> > Intel's documentation is wonderfully vague: "Certain debug exceptions may
> > clear bits 0-3."  And it appears that gdb relies on this behavior; it
> > distinguishes correctly among multiple breakpoints on a vanilla kernel but
> > not under the previous version of hw_breakpoint.
> 
> So it sounds like maybe the real behavior is that any dr[0-3]-induced
> exception resets the DR_TRAP[0-3] bits to just the new hit, but not the
> other bits (i.e. just DR_STEP in practice).  Is that part true on all CPUs?

No.  The 80386 manual says:

	Note that the bits of DR6 are never cleared by the processor.

It's important to bear in mind that not all x86 CPUs are made by Intel, 
and of those that are, not all are Pentium 4's.  This appears to be an 
area of high variability so we should be as conservative as possible.

> > I decided the safest course was to have do_debug() clear tsk->thread.vdr6
> > whenever any of the four breakpoint bits is set in the real DR6.  More
> > sophisticated behavior would be possible at the cost of adding an extra
> > flag to tsk->thread.
> 
> I'm not sure what you have in mind using a new thread flag.  To be
> consistent with existing (and machine) behavior, shouldn't that be clear
> only all the low (DR_TRAP[0-3]) bits when one of those bits is set?

I could do that.  I don't know what happens to DR_STEP; a quick test might 
be worthwhile.


> I'd like to see this concretely working on x86_64 as well as i386.
> That should be a simple matter of the new header file and the makefile
> patches to share the code.  I can test on x86_64 if you can't.
> 
> Do you have some simple test cases prepared?  That is, some simple
> modules using the generic kernel hw_breakpoint support to readily
> report working or not working on basic functionality.  I'd like to have
> something we can agree on as the baseline smoke test for trying the
> patches, and for new machine ports.

I'll put together a simple test module for kernel breakpoints.  It's 
already possible to test user breakpoints just by running gdb.

> I also want to get this machine-independent code sharing going for
> real.  I'd like to have powerpc working as the non-x86 demonstration
> before we declare things in good shape.  I don't expect you to write
> any powerpc support, but I hope I can get you to do the arch code
> separation to make the way for it.  If you'll take a crack at it, I'll
> fill in and test the powerpc bits and I think we'll get something very
> satisfactory ironed out pretty fast.  
> 
> So consider the powerpc64 situation and imagine how you would do the
> implementation for it, and I think you'll find a lot of the code you've
> written is naturally shared for it.  It's a bit of a degenerate case,
> because HB_NUM is 1, but that needn't really matter.  There are only
> data address breakpoints of length 8 with an aligned address, so the
> only control info aside from the address is r/w bits.  There is no
> separate control register.  The control bits are stored in the low bits
> of the register whose high bits are the high bits of the aligned
> address.  (I think other machines store their control bits the same
> way.)  So in fact, not only is there no need for .len, but .type is
> actually just bits that could be stored directly in address.va (if
> noone expected to look at that for the address, or they used an
> accessor that masks off the low bits).  But there are bits to spare
> there next to .priority, so keeping them separate doesn't hurt.  What's
> important is that the chbi->dabr and thbi->dabr fields are stored in
> fully-encoded form for quick switching.

I'll see what I can do.

In this situation you don't need to worry about how .type and .len are 
stored.  On powerpc64 we can have a special thbi->dabr field analogous to 
the thbi->tdr7 field on x86.  All precomputed and ready for quick 
switching.

Even if HB_NUM were larger than 1, we could still store two copies of the 
address value (the second copy with the low-order type bits set).

Alan Stern

