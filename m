Return-Path: <linux-kernel-owner+w=401wt.eu-S933889AbXCFDNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889AbXCFDNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 22:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933890AbXCFDNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 22:13:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933889AbXCFDNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 22:13:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: Alan Stern's message of  Monday, 5 March 2007 12:25:23 -0500 <Pine.LNX.4.44L0.0703051118200.3401-100000@iolanthe.rowland.org>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20070306031308.D78891800E5@magilla.sf.frob.com>
Date: Mon,  5 Mar 2007 19:13:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Presumably you mean that hw-breakpoint.c shouldn't do anything at all on
> single-step exceptions.  

Right.

> So far I've been developing under 2.6.21-rc, which doesn't have utrace.
> But eventually this will be submitted by way of -mm, which does.  The
> easiest approach would be to make the whole thing conditional on
> CONFIG_UTRACE.

That is fine with me.

> The actual guarantee I need is that nobody will switch_to() the task while
> my routines are running.

You can't get that.  It can always be woken for SIGKILL (which is a good
thing).  What you are guaranteed is that if it does, it will never return
to user mode.  So it has to be ok for switching in to use the bits in any
intermediate state you might get them, meaning any possible garbage state
is harmful only to user mode or is otherwise recoverable (worst case
perhaps the exception handler has to know to ignore some traps).  This is
already true with ptrace and ->thread.debugreg, as well as the normal user
registers.  In your case, if you wanted to be paranoid you could clear
TIF_DEBUG before you touch anything, and set it again only after you're
done (with memory barriers as needed).

> If someone really needs to do that, they can always put their own call to
> (un)register_kernel_hwbkpt() at the entry(exit) to the complex subsystems.  
> Or perhaps it should be a job for systemtap, which would use hwbkpt to do
> the actual work.

But you don't have an option to avoid interrupting other CPUs to update,
which is not necessary or desireable for this usage.  That's what I was
referring to.  If it's not trivial to add, it isn't needed now.

> Not nearly as hot as switch_to()!  But I'll do it.

That's why it's got a cheap TIF_DEBUG check with unlikely().

> That may be so, but the only way to access that part of the state is via
> ptrace.  Think of it this way: The debug register settings really should
> not be part of the thread's virtual state.  If we had some other, more
> logical API for managing breakpoints in a task then ptrace_bps[] wouldn't
> be necessary at all (other than for backward compatibility perhaps).

As things are in utrace, there will continue to be a utrace method of
setting the (virtual) "raw" debugregs, even if ptrace per se is not involved.
(So all I'm saying really is I'm on a personal campaign against the letter P.)

OTOH, your point is well taken.  Once your stuff is integrated, there is no
real reason that thread-virtualized "raw" debug registers need to be
accessible via utrace_regset.  Perhaps I should drop it.  Then those calls
will be used purely by ptrace compatibility and can be #ifdef CONFIG_PTRACE.

> Which implies that do_debug needs to decide whether or not to issue 
> SIGTRAP.  Presumably the condition will be that any of the DR_STEP or 
> DR_TRAPn bits remain set after the notifier chain has run.  This means the 
> kprobes code will have to be modified to clear DR_STEP in args->err.

Yeah, I guess that's right.  It should still return NOTIFY_STOP when
args->err has no other bits set, so notifiers aren't called with zero.


Thanks,
Roland
