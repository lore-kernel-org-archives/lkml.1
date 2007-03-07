Return-Path: <linux-kernel-owner+w=401wt.eu-S1422978AbXCGTLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422978AbXCGTLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422630AbXCGTLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:11:06 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35266 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965563AbXCGTLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:11:03 -0500
Date: Wed, 7 Mar 2007 14:11:00 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070307034932.09F5A1801C4@magilla.sf.frob.com>
Message-ID: <Pine.LNX.4.44L0.0703071127530.6624-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Roland McGrath wrote:

> > > Yeah, I guess that's right.  It should still return NOTIFY_STOP when
> > > args->err has no other bits set, so notifiers aren't called with zero.
> > 
> > In practice that might not work.  On my machine, at least, reads of DR6
> > return ones in all the reserved bit positions.
> 
> Does that mean asm("mov %1,%%dr6; mov %%dr6,%0" : "=r" (mask) : "r" (0)); 
> puts in mask the set of reserved bits?  We could collect that value at CPU
> startup and mask it off args->err, then OR it back into vdr6.

That sounds like a rather fragile approach to avoiding a minimal amount of 
work.  Debug exceptions don't occur very often, and when they do it won't 
matter too much if we go through some extra notifier-chain callouts.


Back to a previous topic:

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

It turns out that this won't work correctly unless I use something
stronger, like a spinlock or RCU.  Either one seems like overkill.

Is there any way to find out from within the
switch_to_thread_hw_breakpoint routine whether the task is in this unusual
state?  (By which I mean the task is being debugged and the debugger
hasn't told it to start running.)  Would (tsk->exit_code == SIGKILL) work?  
If not, can we add a TIF_DEBUG_STOPPED flag?  Or should I just go with a 
spinlock?

Is SIGKILL the only way this can happen?

In a similar vein, I need a reliable way to know whether a task has gone 
through exit_thread().  If it has, then its hw_breakpoint area has been 
deallocated and a new one must not be allocated.  Will (tsk->flags & 
PF_EXITING) always be true once that happens?

Alan Stern

