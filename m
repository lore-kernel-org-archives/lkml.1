Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbXEMKkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbXEMKkH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 06:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbXEMKj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 06:39:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173AbXEMKjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 06:39:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: Alan Stern's message of  Friday, 11 May 2007 11:25:14 -0400 <Pine.LNX.4.44L0.0705111122110.3383-100000@iolanthe.rowland.org>
X-Shopping-List: (1) Maternity competitors
   (2) Vigorous collision skis
   (3) Imperious uninteresting distinguishers
Message-Id: <20070513103951.413A11F8516@magilla.localdomain>
Date: Sun, 13 May 2007 03:39:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry again about the delay.  

> I trust we are moving closer to a final, usable form.

Indeed, I think it is getting there.

> I think there are probably still a few small things wrong with it.  For
> instance, the RF setting isn't right; I misunderstood the Intel manual.  
> It should get set only when the latest debug interrupt was for an
> instruction breakpoint.

This makes me think about RF a little more.  If you ever set it, there are
some places we need to clear it too.  That is, when the PC is being changed
before returning to user mode, which is in signals and in ptrace.  If the
PC is changing to other than the breakpoint location hit by the handler
that set RF, we need clear RF so that the first instruction at the changed
PC can be a breakpoint hit of its own and not get masked.  In fact, it may
also be necessary to clear RF when freshly setting a new instruction
breakpoint (when RF is set because the stop was not a debug exception at
all), so that it isn't skipped if the PC happens to be right there already.

> Come to think of it, we don't really need modify_user_hw_breakpoint at
> all.  It could be replaced by an {unregister(old); register(new);}
> sequence.  Unless you think there's some pressing reason to keep it, my
> inclination is to do away with it.

I sort of wondered from the beginning why it was there.  The rationale I
can see is to avoid flutter.  That is, when unregistering frees up a slot
for a lower-priority allocation waiting in the wings, and then the new
registration will just displace it again.  The priority list diddling is
wasted work to get back to just how it was before, but more importantly you
don't want to have those callbacks for a momentarily-available slot coming
and going.  I don't know if this can really come up with the current code.

> Hmm...  Maybe I could store a pointer to the DR6 value in args.err instead
> of the value itself...

Ugh.

> As I understand it, setting one of those bits is necessary on the 386 but
> not necessary for later processors.  Should this be controlled by a
> runtime (or compile time) check?  For that matter, do those bits have any
> effect at all on a Pentium?

I've never heard of anyone using them, but I don't know the full story.

> My Intel manual says that the CPU automatically sets the RF bit in the
> EFLAGS image stored on the stack by the debug exception.  Hence the
> handler doesn't have to worry about it.  That's why I removed it from the 
> existing code.

The documentation I have says that RF is set in the trap frame on the stack
(i.e. pt_regs.eflags) by every other kind of exception.  However, for a
debug exception that is due to an instruction breakpoint, RF=0 in the trap
frame and the manual explicitly says that the handler must set the bit so
that iret will resume and execute it rather than hit the breakpoint again.

[later:]
> It also turns out that some CPUs don't automatically set the RF bit in 
> the EFLAGS image on the stack.  Intel recommends that the OS always set 
> that bit whenever a debug exception occurs, so that's what I did.

Is this really "some CPUs"?  Or is it actually always as I described above
(i.e. RF set usually but cleared for an instruction breakpoint hit)?

> If callers want to give up when a kernel breakpoint isn't installed 
> immediately, all they have to do is check the return value from 
> register_kernel_hw_breakpoint and call unregister_kernel_hw_breakpoint.  
> If you really want it, I could add an extra "fail if not installed" 
> argument flag.

The important thing is that there aren't any difficult races (i.e. what you
get with callbacks).  If register with no callback followed by unregister
on seeing "registered but not installed" return value is simple and cheap,
that is fine.

> For user breakpoints, the whole notion is almost meaningless.  Even if the
> breakpoint was allocated a debug register initially, it could get
> displaced by the time the debuggee task next runs.

It's no less meaningful than for a kernel allocation.  In neither case is
there a guarantee you'll keep it forever.  What callers I had in mind want
is a quick answer when the answer is negative at the time of the call, so
they just punt on the complexity of dealing with a positive answer.

> Again, this was referring to existing code which I basically copied 
> without fully understanding.  Does the new code in do_debug do the right 
> thing with regard to TF?

It looks right to me.  That is, it preserves the existing behavior for
kernel-mode traps, and does not touch TF at all for user-mode traps.

> > > +	/* Block kernel breakpoint updates from other CPUs */
> > > +	local_irq_save(flags);
> > 
> > I have a feeling this is more costly than we want, though I don't really
> > know.  It seems to me that things in struct cpu_hw_breakpoint are not
> > really per-CPU, except for bp_task.  They are "current global state",
> > right?
> 
> Not really, since changes to the debug registers on multiple CPUs cannot
> be made simultaneously.  There will be short periods when different CPUs
> have different debug register values.  What if a debug exception occurs
> during one of those periods?

I think it's fine if a CPU getting an exception before it's processed the
IPI looks at changed global state and says "oh, mine was stale", and punts
the hit.  (Or perhaps it transmorgifies its apparent DR# based on the new
global state, if the CPU's old setting corresponds to one of the new
settings.  Probably the changing of settings can just preserve the old DR#
selection in such cases and simplify the situation for the handler doing
the catch-up to just if (old->dr[n] != new->dr[n]) ignore;.)

> Or what if a task switch occurs?

You mean a context switch before the IPI gets in?
switch_to_thread_hw_breakpoint can just install the latest global state.

> Here's the latest take on the hw_breakpoint patch.  I adopted most of your
> suggestions.  There still isn't a .bits member, but or'ing the .len and
> .type members together will give you essentially the same thing; both of
> those values are now completely encoded.

I'd still prefer to have a single machine-dependent field and not have .len.

> The hot path in switch_to_thread_hw_breakpoint() should now be very fast.  
> There's a minimal amount of additional activity needed to deal with kernel
> breakpoint updates that might arrive in the middle of a context switch.

It looks promising.  

I'm not entirely sanguine about an 8-bit gennum.  For the kernel
settings, it's going to be fine--there won't be 256 updates before all
the CPUs process their IPIs.  But for the thbi->gennum comparison, a
thread might very well not have run for days, while there have been
many more updates than that, and its gennum%256 matching the current
one or not is just luck.  

You may need some memory barriers around the switching/restart stuff.
In fact, I think it would be better not to delve into reinventing the
low-level bits there at all.  Instead use read_seqcount_retry there
(linux/seqlock.h).  Using that read_seqcount_begin's value as the
number to compare in thbi would also give a 32-bit sequence number.

I don't see why notify_all_threads ever needs to be used.  The sequence
number changed, so the next switch in will always update.  I guess
that's how you were avoiding the untrustworthy 8-bit sequence number
issue.  But I think it's better to do the whole thing with seqcount and
rely on 32-bit sequence numbers being good enough to let thread updates
be entirely lazy.

> I'll go through the file and see which parts really can be shared.  It
> might end up being less than you think.
> 
> Note that doing this would necessarily create a bunch of new public 
> symbols.  Routines that I now have declared static wouldn't be able to 
> remain that way.
[later:]
> I didn't try to split hw_breakpoint.c apart into sharable and non-sharable
> pieces.  At this stage it's not entirely clear which routines would have
> to go on each side.  For example, processors with separate sets of debug
> registers for execute and data breakpoints would require a substantial
> change to the existing code.  Probably all the lists and arrays would have
> to be duplicated, with one copy for execute breakpoints and one for data
> breakpoints.
>
> If you eliminate all routines that refer to HB_NUM or dr7, that really 
> doesn't leave much sharable code.  The routines which qualify tend to be 
> relatively short; I think the largest one is flush_thread_hw_breakpoint().

It looks to me like there is quite a lot to be shared.  Of course the
code can refer to constants like HB_NUM, they just have to be defined
per machine.  The dr7 stuff can all be a couple of simple arch_foo
hooks, which will be empty on other machines.  All of the list-managing
logic, the prio stuff, etc., would be bad to copy.

The two flavors could probably be accomodated cleanly with an
HB_TYPES_NUM macro that's 1 on x86 and 2 on ia64, and is used in loops
around some of the calls.  I'm not suggesting you try to figure out
that code structure ahead of time.  But I don't think it will be a big
barrier to code sharing.

> It turns out that on some processors the CPU does reset DR6 sometimes.  
> Intel's documentation is wonderfully vague: "Certain debug exceptions may
> clear bits 0-3."  And it appears that gdb relies on this behavior; it
> distinguishes correctly among multiple breakpoints on a vanilla kernel but
> not under the previous version of hw_breakpoint.

So it sounds like maybe the real behavior is that any dr[0-3]-induced
exception resets the DR_TRAP[0-3] bits to just the new hit, but not the
other bits (i.e. just DR_STEP in practice).  Is that part true on all CPUs?

> I decided the safest course was to have do_debug() clear tsk->thread.vdr6
> whenever any of the four breakpoint bits is set in the real DR6.  More
> sophisticated behavior would be possible at the cost of adding an extra
> flag to tsk->thread.

I'm not sure what you have in mind using a new thread flag.  To be
consistent with existing (and machine) behavior, shouldn't that be clear
only all the low (DR_TRAP[0-3]) bits when one of those bits is set?

> Finally, I put in a couple of #ifdef's to make the same source work under 
> both i386 and x86_64, although I haven't tried building it.  You might 
> want to check and make sure that part of validate_settings() is correct.

That looks fine.

I'd like to see this concretely working on x86_64 as well as i386.
That should be a simple matter of the new header file and the makefile
patches to share the code.  I can test on x86_64 if you can't.

Do you have some simple test cases prepared?  That is, some simple
modules using the generic kernel hw_breakpoint support to readily
report working or not working on basic functionality.  I'd like to have
something we can agree on as the baseline smoke test for trying the
patches, and for new machine ports.

I also want to get this machine-independent code sharing going for
real.  I'd like to have powerpc working as the non-x86 demonstration
before we declare things in good shape.  I don't expect you to write
any powerpc support, but I hope I can get you to do the arch code
separation to make the way for it.  If you'll take a crack at it, I'll
fill in and test the powerpc bits and I think we'll get something very
satisfactory ironed out pretty fast.  

So consider the powerpc64 situation and imagine how you would do the
implementation for it, and I think you'll find a lot of the code you've
written is naturally shared for it.  It's a bit of a degenerate case,
because HB_NUM is 1, but that needn't really matter.  There are only
data address breakpoints of length 8 with an aligned address, so the
only control info aside from the address is r/w bits.  There is no
separate control register.  The control bits are stored in the low bits
of the register whose high bits are the high bits of the aligned
address.  (I think other machines store their control bits the same
way.)  So in fact, not only is there no need for .len, but .type is
actually just bits that could be stored directly in address.va (if
noone expected to look at that for the address, or they used an
accessor that masks off the low bits).  But there are bits to spare
there next to .priority, so keeping them separate doesn't hurt.  What's
important is that the chbi->dabr and thbi->dabr fields are stored in
fully-encoded form for quick switching.


Thanks,
Roland
