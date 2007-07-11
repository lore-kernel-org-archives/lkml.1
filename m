Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbXGKG7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbXGKG7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 02:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbXGKG7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 02:59:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbXGKG7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 02:59:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: Alan Stern's message of  Thursday, 28 June 2007 23:00:22 -0400 <Pine.LNX.4.44L0.0706272308330.31168-100000@netrider.rowland.org>
X-Zippy-Says: Yow!  Legally-imposed CULTURE-reduction is CABBAGE-BRAINED!
Message-Id: <20070711065942.5728A4D0489@magilla.localdomain>
Date: Tue, 10 Jul 2007 23:59:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> That should work well.  But how does the handler know whether a ptrace
> trigger occurred?  I can think of several possible ways, none of them
> very attractive.  Simply checking the vdr6 value might not work.  The
> simplest approach would be to see if the trigger callback address is
> equal to ptrace_triggered -- it's a hack but it is reliable.

That's what I did in the powerpc code.  You might recall I originally
argued for not using a regular hw_breakpoint struct and callback for ptrace
at all.  (I still think it could wind up pretty clean and tight to have it
purely a special case using its own data structures without a struct
hw_breakpoint.  Only the priority stuff has to do something special to
treat ptrace-in-use as a registration with the right priority.)

> For that matter, knowing when to set vdr6 is a little tricky.  I guess
> it should be set whenever a debug exception occurs in user mode (which
> includes both breakpoints and single-step events).  But what about
> ptrace triggers while the CPU is in kernel mode?  Should they set the
> four DR_TRAPn bits in vdr6 and leave the rest alone?

When do_debug sets TIF_SINGLESTEP, it will lead to a SIGTRAP on the way
back to user mode.  The idea is that it should appear to user mode like the
syscall was any hardware instruction that got the step trap.  So it follows
(and matches existing behavior) to set DR_STEP in vdr6 in this case too.

> I don't.  I used TIF_DEBUG because it was already there and it was 
> atomic.  But setting hw_breakpoint_info is equally atomic, so there's 
> no reason to keep TIF_DEBUG.

I would not remove TIF_DEBUG where it exists now.  It was added on x86 and
x86_64 as an optimization so the common case tests and decides not to call
__switch_to_xtra with one instruction.  Don't lose that optimization.

> > The num_installed/num_kbps stuff feels a little hokey when it's really a
> > flag because the maximum number is one.  It seems like I could make it
> > tighter with some more finesse in the arch-specific hook options, so that
> > chbi and thbi each just store dabr, dabr!=0 means "mine gets installed",
> > and the switch in is just chbi->dabr?:thbi->dabr or something like that.
> 
> You certainly can do that in the hook routines.  But the generic code
> still needs to use num_installed (which doesn't get used very much) and
> num_kbps.

What I meant is using some arch hooks instead of those fields in the
generic code.  On machines where there is a count to keep, they would just
be trivial accessors (could be one-line macros).  On powerpc, they would be
implemented slightly differently and return 1 or 0.

> > Some uses might be happy with trigger-before, but I don't see much benefit.
> 
> Other than ptrace backward-compatibility.

Right, I wasn't suggesting losing that.

> I never have either.  Possibly you might want to change the value just 
> before the read, based on the address of the code doing the reading.  
> But I've never heard of anyone doing that.

Ah, that's a thought.  Ok.  I was already tending towards flexibility to
let someone do that if they wanted to (on trigger-before machines).

> > 	int hw_breakpoint_triggers_before(struct hw_breakpoint *);
> > 	int hw_breakpoint_can_resume(struct hw_breakpoint *);
> > 
> > or perhaps taking (unsigned int type) instead, in <asm-cpu/hw_breakpoint.h>.
> > i.e. for x86:
> > 
> > #define hw_breakpoint_triggers_before(type) ((type) == HW_BREAKPOINT_EXECUTE)
> > #define hw_breakpoint_can_resume(type) 	    1
> > 
> > and powerpc:
> > 
> > #define hw_breakpoint_triggers_before(any)	1
> > #define hw_breakpoint_can_resume(any)		0
> 
> I prefer the second alternative.  For the first, you'd have to register 
> the breakpoint before knowing how it will behave!

Yes, I was sort of thinking it up while I typed there.

> In general that sounds good.  But do we really want the register call
> to fail if extra handlers are defined?  That approach makes portable
> drivers harder to write.  Maybe it would be better to fail only if all
> of the arch-supported handler alternatives are NULL.

My rationale is that judiciously rejecting impossible settings in fact
makes it easier to write (correct) portable drivers.  If you set a callback
function that will never be called, you are confused and are going to have
the logic go wrong in your code.  If you can't get started while under the
delusion that your function is going to be called, then you won't waste all
that time on subtle debugging trying to figure out why it's not getting called.

> > We'd still want hw_breakpoint_can_resume to tell whether you can return
> > from a pre_handler and continue with no a post_handler, without needing to
> > unregister the breakpoint.  That's true on ia64, while on powerpc you
> > either have to clear the breakpoint or request the post_handler stepping logic.
> 
> Unregistering the breakpoint isn't good on SMP systems, since it would
> be unregistered on all CPUs.  I think it would better to require all
> arch's to support the stepping logic.

I don't disagree.  But the point is that on ia64 there is a case where no
stepping is required, so there is no reason the arch hooks shouldn't
indicate to users that this usage pattern is available.  Also,
realistically the single-step to post-handler part of the implementation
will come last for each arch, and flexible users can do interesting things
with partial support if they have the information on what the
implementation supports.

> Going over the code, I remembered that TIF_DEBUG really does mean moree
> than just hw_breakpoint_info != NULL.  It means that the thread
> actually has some breakpoints registered.

Ok.

> Why keep the hw_breakpoint_info structure if there are no registered 
> breakpoints?  I did it so that the virtualized DR[0-3] values would 
> remain intact.

Ok.  Whenever all the virtual bits are zero you can free it.  That is
probably worth doing for the case when ptrace is never used, but some other
exciting new facility comes in and uses watchpoints for a while and then
goes away.

> For other processors that have only one debug register, this won't matter
> so much.  But of course there are references to TIF_DEBUG in the
> arch-independent code.  Do you think there would be any problem about
> reserving a bit for TIF_DEBUG in the other architectures?

In my powerpc patch I made those conditional and that seems fine.  I think
that having a TIF_DEBUG is an arch-specific choice, and each arch should
decide whether it is advantageous.  


Thanks,
Roland
