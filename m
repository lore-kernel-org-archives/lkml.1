Return-Path: <linux-kernel-owner+w=401wt.eu-S1750999AbXCNDBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750999AbXCNDBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 23:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbXCNDBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 23:01:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33881 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbXCNDBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 23:01:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/linus
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: Alan Stern's message of  Tuesday, 13 March 2007 14:56:29 -0400 <Pine.LNX.4.44L0.0703131230540.2509-100000@iolanthe.rowland.org>
X-Shopping-List: (1) Runcible lotion
   (2) Erratic transient breath
   (3) Prestigious transplanted clasps
Message-Id: <20070314030033.16B471801C5@magilla.sf.frob.com>
Date: Tue, 13 Mar 2007 20:00:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, the code could be reworked by moving some of the data from the CPU
> hw-breakpoint info into the thread's info.  I'll see how much simpler it
> ends up being.

I don't quite understand that characterization of the kind of change I'm
advocating.  If the common case path in context switch has really anything
at all more than the example I gave, something is wrong.

> It isn't quite that easy.  Even though the number of user breakpoints may
> not have changed, their identities may have.  So the unlikely case has to
> encompass two possibilities: the number of installable user breakpoints
> has changed, or any user breakpoints have been registered or unregistered.

Why does it matter?  When a new user breakpoint was made the
highest-priority one, it ought to update tdr[0..3] right then before the
registration call returns.  It seems fine to me for it to make an
uninstalled callback right away rather than at the thread's next switch-in.
But even if you wanted to delay it, you could just set active_dr7 to zero
or something so that the unlikely case triggers.

> > For the masks to work as I described, you need to use the same enable bit
> > (or both) for kernel and user allocations.  It really doesn't matter which
> > one you use, since all of Linux is "local" for the sense of the dr7 enable
> > bits (i.e. you should just use DR_GLOBAL_ENABLE).
> 
> This shouldn't be necessary.  So long as DR_GLOBAL_ENABLE always belongs
> to the kernel's part of DR7 and DR_LOCAL_ENABLE always belongs to the
> thread's part there will be no interference between them.

The plan I suggested relies on setting want_dr7 with the enable bits that
do include the ones the kernel uses (for contested slots).  Of course it
works as well to use either bit for this, as long as you're consistent.
But as I've said at least twice already, there is no actual meaning
whatsoever to choosing one enable bit over the other.  It's just confusing
and misleading to have the code make special efforts to set one rather than
the other for different cases.  You talk about them as if they meant
something, which keeps making me wonder if you're confused.  Since the
hardware doesn't care which bit you set, you could overload them to record
a bit and a half of information there if really wanted to, but you're not
even doing that, unless I'm confused.

> Maybe.  I always had in the back of my mind the possibility that there
> might be a user I/O breakpoint set.  It could be triggered by an interrupt
> handler even in the SIGKILL case.  But since we're not supporting I/O
> breakpoints now, that's a moot point.

How would that happen?  This would mean that some user process has been
allowed to enable ioperm for some io port that kernel drivers also send to
from interrupt handlers.  Can that ever happen?

> Actually the code _doesn't_ already know what's there; the chbi area
> doesn't include any storage for the kernel DR7 value.  I figured it was at
> least as easy to read it from the CPU register as to read it from memory.  
> But maybe that's not true; according to my ancient processor manual, moves
> to/from debug registers take many more clock cycles than moves to/from
> memory.

The purpose of the chbi area is to optimize this path.  Make it store
whatever precomputed values are most convenient for the hot paths.  This
path doesn't need num_kbps, it needs kdr7.  So precompute that and do that
one load, instead of a load of chbi->num_bkps we don't otherwise need plus
a load from kdr7_masks that can be avoided altogether on hot paths.

I don't really know about the slowness of reading debug registers, though I
would guess it is slower than most common operations.  But regardless, you
can avoid it because kdr7 is something you need anyway, so you're not
replacing it with a load but letting a load you already had kill two birds.

> No.  If a debugger has removed some user breakpoints since the last time
> the thread ran, the chbi->bps[] entries could still be present.  Likewise
> if the previously-running task had more breakpoints than the current one.

I don't really get why user breakpoints would be in chbi->bps at all.
When a debug trap hits, you can check kdr7 or whatnot to see if it was a
kernel allocation, and otherwise look in current->thbi->bps to find it.

> I don't like using DR_LEN_1, because it would force asm/debugreg.h to be 
> #included by any user of hw_breakpoint.  The raw numerical value should do 
> just as well.

Agreed.  (I just used DR_LEN_1 as shorthand and was not hot on including
asm/debugreg.h in asm/hw_breakpoint.h in the actual version.)

> > On powerpc, the address breakpoint is always for an 8-byte address range.
> 
> So there's no way to trap on accesses to a particular byte within a
> string?

There's no way to tell which of the 8 bytes were accessed, AFAIK.  It's the
same as LEN8 on x86_64 or LEN[42] on i386: some byte in there was accessed.

> Better yet, if type is HW_BREAKPOINT_TYPE_EXECUTE then just ignore the
> caller's len and always use the correct value.

That is probably fine too.

> Since PPC doesn't allow lengths shorter than 8, perhaps on that 
> architecture the bottom bits of the address should silently be cleared.

You're not suggesting this for lengths 2, 4, or 8 on i386/x86_64, and I
don't see the distinction.  In all those cases, any low bits set in the
address are being ignored.  I think it is much better to enforce the
alignment so that callers are told explicitly what their parameteres really
mean.  A caller passing an unaligned address with DR_LEN_4 might be
thinking it will catch the four bytes starting at that unaligned byte,
which is not true.

> It gives drivers a way to tell whether or not the breakpoint is currently 
> installed without having to do explicit tracking of installed() and 
> uninstalled() callbacks.

How could that ever be used that would not be racy and thus buggy?  A
registration call on another CPU could cause a change and callback just
after you fetched the value.

> These changes to the API sound pretty good.  Stay tuned for the next
> version...

You keep rewriting it and I'll keep changing my mind!  
(Just kidding, but fair warning. ;-)
I look forward to it.


Thanks,
Roland
