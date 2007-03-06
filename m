Return-Path: <linux-kernel-owner+w=401wt.eu-S965926AbXCFPX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965926AbXCFPX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 10:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965928AbXCFPX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 10:23:57 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45903 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965926AbXCFPX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 10:23:56 -0500
Date: Tue, 6 Mar 2007 10:23:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070306031308.D78891800E5@magilla.sf.frob.com>
Message-ID: <Pine.LNX.4.44L0.0703061015100.3401-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007, Roland McGrath wrote:

> > The actual guarantee I need is that nobody will switch_to() the task while
> > my routines are running.
> 
> You can't get that.  It can always be woken for SIGKILL (which is a good
> thing).  What you are guaranteed is that if it does, it will never return
> to user mode.  So it has to be ok for switching in to use the bits in any
> intermediate state you might get them, meaning any possible garbage state
> is harmful only to user mode or is otherwise recoverable (worst case
> perhaps the exception handler has to know to ignore some traps).  This is
> already true with ptrace and ->thread.debugreg, as well as the normal user
> registers.  In your case, if you wanted to be paranoid you could clear
> TIF_DEBUG before you touch anything, and set it again only after you're
> done (with memory barriers as needed).

Guess I'll have to take that approach.  The new additions to __switch_to() 
follow a linked list, and obviously it's not safe to do that while the 
list is being updated.  (No, I'm not about to start using RCU for this!)


> > If someone really needs to do that, they can always put their own call to
> > (un)register_kernel_hwbkpt() at the entry(exit) to the complex subsystems.  
> > Or perhaps it should be a job for systemtap, which would use hwbkpt to do
> > the actual work.
> 
> But you don't have an option to avoid interrupting other CPUs to update,
> which is not necessary or desireable for this usage.  That's what I was
> referring to.  If it's not trivial to add, it isn't needed now.

I see your point.  If you want to monitor a certain location in kernel
space but only while in the context of a specific task, the new framework
doesn't provide any way of doing it.  One approach could be to use a
regular kernel breakpoint and return immediately if the task of interest
isn't the current one.  Beyond that, let's punt.


> > Which implies that do_debug needs to decide whether or not to issue 
> > SIGTRAP.  Presumably the condition will be that any of the DR_STEP or 
> > DR_TRAPn bits remain set after the notifier chain has run.  This means the 
> > kprobes code will have to be modified to clear DR_STEP in args->err.
> 
> Yeah, I guess that's right.  It should still return NOTIFY_STOP when
> args->err has no other bits set, so notifiers aren't called with zero.

In practice that might not work.  On my machine, at least, reads of DR6
return ones in all the reserved bit positions.

Alan Stern

