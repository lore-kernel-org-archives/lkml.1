Return-Path: <linux-kernel-owner+w=401wt.eu-S1946542AbXBIPym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946542AbXBIPym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946552AbXBIPym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:54:42 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:58301 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1946542AbXBIPyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:54:41 -0500
Date: Fri, 9 Feb 2007 10:54:40 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kwatch: kernel watchpoints using CPU debug registers
In-Reply-To: <20070209102124.1DF3618003C@magilla.sf.frob.com>
Message-ID: <Pine.LNX.4.44L0.0702091044230.4548-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007, Roland McGrath wrote:

> > All right.  However this means thread_struct will have to grow in order to
> > hold each task's debug-register allocations and priorities.  Would that be
> > acceptable?  (This might be a good reason to keep the number of bits
> > down.)
> 
> Well, noone seems to mind the wasted debugreg[5..6] words. ;-) 
> 
> I'm inclined to make thread_struct smaller than it is now by making it
> indirect (debugreg[8] -> one pointer).  It feels like this would be pretty
> safe now that we have TIF_DEBUG anyway.  Already nothing should be looking
> at the field when TIF_DEBUG isn't set.

I had the same thought.

> > Another question: How can a program using the ptrace API ever give up a
> > debug-register allocation?  Disabling the register isn't sufficient; a
> > user program should be able to store a watchpoint address in dr1, enable
> > it in dr7, disable it in dr7, and then re-enable it in the expectation
> > that the address stored in dr1 hasn't been overwritten.  As far as I can
> > see, ptrace-type allocations have to be permanent (until the task exits or
> > execs, or uses some other to-be-determined API to do the de-allocation.)
> 
> I hadn't really thought about this before, but it's pretty straightforward.
> Each allocation is for one of %dr[0-3] and for its associated bits in %dr7.
> %dr0 and bits 0,1,16-19; %dr1 and bits 2,3,20-23; etc.
> %dr7 & (0x000f0003 << N) for %drN, I guess it is.
> ((((1 << DR_CONTROL_SIZE) - 1) << DR_CONTROL_SHIFT) |
>  ((1 << DR_ENABLE_SIZE) - 1)) << N, I should say.
> 
> Each allocation owns those 38 bits (70 bits on x86_64).  When all those
> bits are zero, the allocation is not active and might as well not be there
> (except for whatever semantics you might want to have about an allocation's
> lifetime as distinct from the event of resetting its contents).  

Okay, that makes sense.

> Your question made me think about the %dr6 issue, too, which I also hadn't
> thought about before.  It looks like your patch handles this correctly, but
> it's a subtle point that I think warrants some comments in the code.  When
> userland inserts a watchpoint and it's hit, it gets a SIGTRAP via do_debug
> and eventually looks at dr6 (via ptrace) to see what happened.  Kernel
> watchpoints that come along after the user signal is generated can clobber
> the CPU %dr6 with new hits, but userland should not perceive this.  This
> works out because what userland sees is thread.debugreg[6], the only place
> that sets it is do_debug, and a kwatch hit bails out before changing it.
> Any other new users of the debugreg sharing interface need to be cognizant
> of the %dr6 issue to avoid stepping on old ptrace uses.

Yes.  In fact, the current existing code does not handle dr6 correctly.  
It never clears the register, which means you're likely to get into 
trouble when multiple breakpoints (or watchpoints) are enabled.


Here's another complication -- and this is one I can't figure out any easy
solutions for.  The type of API we've been discussing will work well
enough on UP systems, but what about SMP?  I don't see any value in having
a kernel watchpoint enabled on some CPUs and not others.  But then what
should happen when a debug register is in use by kwatch and a ptrace
request on one CPU usurps it (leaving no other register in which to put
it)?  Not to mention the difficulties of keeping track of everything when
the same kwatch watchpoint is stored in different debug registers on
different CPUs.

It's really quite a tricky matter.  Should a register be allocated to
kwatch only when no user process needs it?  Should we really go about
checking the requirements of every single process whenever a kwatch
allocation request comes in?  What if the processes which need a
particular register aren't running -- should the register then be given to
kwatch?  What if one of those processes then does start running on one
CPU?

Alan Stern

