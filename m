Return-Path: <linux-kernel-owner+w=401wt.eu-S932716AbXCNTLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716AbXCNTLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932808AbXCNTLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:11:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47537 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932716AbXCNTLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:11:12 -0400
Date: Wed, 14 Mar 2007 15:11:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070314030033.16B471801C5@magilla.sf.frob.com>
Message-ID: <Pine.LNX.4.44L0.0703141445240.7723-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007, Roland McGrath wrote:

> > Yes, the code could be reworked by moving some of the data from the CPU
> > hw-breakpoint info into the thread's info.  I'll see how much simpler it
> > ends up being.
> 
> I don't quite understand that characterization of the kind of change I'm
> advocating.

It's easy to explain: Your sample code had a tdr[] array in the thread's
hw_breakpoint area and my patch did not; adding it amounts to moving some
of the data from the CPU's info into the thread's info.

> > It isn't quite that easy.  Even though the number of user breakpoints may
> > not have changed, their identities may have.  So the unlikely case has to
> > encompass two possibilities: the number of installable user breakpoints
> > has changed, or any user breakpoints have been registered or unregistered.
> 
> Why does it matter?  When a new user breakpoint was made the
> highest-priority one, it ought to update tdr[0..3] right then before the
> registration call returns.  It seems fine to me for it to make an
> uninstalled callback right away rather than at the thread's next switch-in.
> But even if you wanted to delay it, you could just set active_dr7 to zero
> or something so that the unlikely case triggers.

That's basically what I intend to do.  Although instead of keeping track 
of an active_dr7, I'll keep track of num_kbps as of the last time the 
thread ran.  The unlikely case can be triggered by setting the value to 
-1.

> The plan I suggested relies on setting want_dr7 with the enable bits that
> do include the ones the kernel uses (for contested slots).  Of course it
> works as well to use either bit for this, as long as you're consistent.

With my scheme it won't matter.  You'll see.

> But as I've said at least twice already, there is no actual meaning
> whatsoever to choosing one enable bit over the other.  It's just confusing
> and misleading to have the code make special efforts to set one rather than
> the other for different cases.  You talk about them as if they meant
> something, which keeps making me wonder if you're confused.  Since the
> hardware doesn't care which bit you set, you could overload them to record
> a bit and a half of information there if really wanted to, but you're not
> even doing that, unless I'm confused.

No, I'm not confused and neither are you.  I realize there's no functional 
difference between the two sets of enable bits, since Linux doesn't use 
hardware task-switching.  I just like to keep things neatly separated, 
that's all.


> > Maybe.  I always had in the back of my mind the possibility that there
> > might be a user I/O breakpoint set.  It could be triggered by an interrupt
> > handler even in the SIGKILL case.  But since we're not supporting I/O
> > breakpoints now, that's a moot point.
> 
> How would that happen?  This would mean that some user process has been
> allowed to enable ioperm for some io port that kernel drivers also send to
> from interrupt handlers.  Can that ever happen?

I haven't checked the ioperm code to be certain, but it seems like the 
sort of thing somebody might want to do on occasion.

Another aspect perhaps worth mentioning is that user breakpoints are 
active only when the task is running.  Hence breakpoints for user data 
affected by AIO operations won't necessarily be triggered; with async I/O 
the transfers can occur while a different task is running.  Of course 
there's nothing new about this; the same has been true for ptrace all 
along.


> > Actually the code _doesn't_ already know what's there; the chbi area
> > doesn't include any storage for the kernel DR7 value.  I figured it was at
> > least as easy to read it from the CPU register as to read it from memory.  
> > But maybe that's not true; according to my ancient processor manual, moves
> > to/from debug registers take many more clock cycles than moves to/from
> > memory.
> 
> The purpose of the chbi area is to optimize this path.  Make it store
> whatever precomputed values are most convenient for the hot paths.  This
> path doesn't need num_kbps, it needs kdr7.  So precompute that and do that
> one load, instead of a load of chbi->num_bkps we don't otherwise need plus
> a load from kdr7_masks that can be avoided altogether on hot paths.

I will endeavor to optimize switch_to_thread_hw_breakpoint.  However it 
will turn out that the hot patch really does to use chbi->num_kbps and 
chbi->kdr7_mask.  Again, you'll see...


> > No.  If a debugger has removed some user breakpoints since the last time
> > the thread ran, the chbi->bps[] entries could still be present.  Likewise
> > if the previously-running task had more breakpoints than the current one.
> 
> I don't really get why user breakpoints would be in chbi->bps at all.
> When a debug trap hits, you can check kdr7 or whatnot to see if it was a
> kernel allocation, and otherwise look in current->thbi->bps to find it.

You're right; I'll do it that way.


> > Since PPC doesn't allow lengths shorter than 8, perhaps on that 
> > architecture the bottom bits of the address should silently be cleared.
> 
> You're not suggesting this for lengths 2, 4, or 8 on i386/x86_64, and I
> don't see the distinction.  In all those cases, any low bits set in the
> address are being ignored.  I think it is much better to enforce the
> alignment so that callers are told explicitly what their parameteres really
> mean.  A caller passing an unaligned address with DR_LEN_4 might be
> thinking it will catch the four bytes starting at that unaligned byte,
> which is not true.

Okay, I'll check the address bits.


> > It gives drivers a way to tell whether or not the breakpoint is currently 
> > installed without having to do explicit tracking of installed() and 
> > uninstalled() callbacks.
> 
> How could that ever be used that would not be racy and thus buggy?  A
> registration call on another CPU could cause a change and callback just
> after you fetched the value.

Not if you have interrupts disabled.  Debug register settings are 
disseminated from one CPU to the others by means of an IPI.

Alan Stern

