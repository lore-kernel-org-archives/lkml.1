Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbYJRPWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbYJRPWF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 11:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYJRPVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 11:21:55 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2321 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751468AbYJRPVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 11:21:54 -0400
Date: Sat, 18 Oct 2008 11:21:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <jason.wessel@windriver.com>, <avi@qumranet.com>,
       <richardj_moore@uk.ibm.com>
Subject: Re: [RFC Patch 3/9] Modifying generic debug exception to use virtual
 debug registers
In-Reply-To: <20081017232430.9F48C1544CB@magilla.localdomain>
Message-ID: <Pine.LNX.4.44L0.0810181106100.1469-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008, Roland McGrath wrote:

> Current Intel manuals say, "Certain debug exceptions may clear bits 0-3.
> The remaining cntents of the DR6 register are never cleared by the processor."
> 
> Your experiments told us that "certain debug exceptions" includes at least
> the data breakpoint hits.  I assume that what it really means is all the
> exceptions that set one of those four bits, i.e. ones due to DR[0-3] use.
> Perhaps someone from Intel can clarify exactly what it means.
> 
> > So this means that do_debug shouldn't modify the four low bits in vdr6.  
> [...]
> 
> Right.
> 
> > I don't know how we should handle the BT (debug trap) and BS 
> > (single-step exception) bits.  Maybe the kprobes code can take care of 
> > them.
> 
> BT is for task switch with TSS.T set.  I don't think that can ever happen
> in Linux, since we don't use hardware task-switching.  If at all, maybe in
> vm86 mode.  I don't think there's a way to do it just from user_ldt.
> 
> I think BS (DR_STEP) should get set in vdr6 only when a SIGTRAP is
> generated for the exception.  It should never get cleared by the system,
> only by PTRACE_POKEUSR.  That is consistent with what we get now, AFAICT.
> 
> I don't think kprobes should "take care of" DR_STEP.  It should eat a
> DR_STEP that it's responsible for, and leave any others alone.  i.e.,
> CONFIG_KPROBE=n must not break the normal bookkeeping.
> 
> IIRC there can be one do_debug trap that's for both a breakpoint register
> hit and a single-step (TF), with DR_STEP plus DR_TRAPn both set at once.
> To handle that too, I think this will work:
> 
> do_debug does:
>  
> 	get_debugreg(condition, 6);
> 	set_debugreg(0, 6);
> 
> Make sure the hw_breakpoint notifier is before the kprobes notifier.
> hw_breakpoint is responsible for the low 4 bits of vdr6 and leaves its
> other bits alone.  It returns NOTIFY_STOP iff both this hit is not a ptrace
> hit and hardware %db6 (args->err) has no other nonreserved bits set.

Ah yes, it's coming back to me now.  The handler routines see the
original hardware DR6 contents in args->err.  They want to turn off the
bits corresponding to events they take care of, leaving the remaining
bits intact.  When the notifier chain is finished, any bits still left
in args->err have to be acted on by do_debug, by or'ing them into vdr6.

The problem is that, owing to the way the code is structured, this 
can't be done.  args->err is local to notify_die, so any changes made 
to its value are not available in do_debug.

> kprobes stays as it, returns NOTIFY_STOP iff it's swallowing the step.
> do_debug stays mostly the same, replace:
> 
> 	tsk->thread.debugreg6 = condition;
> 
> with:
> 
> 	tsk->thread.vdr6 &= DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3;
> 	tsk->thread.vdr6 |= condition & ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3);

No, this can't be right.  Or if it is, it's just by coincidence.  What 
we really want to do is:

	tsk->thread.vdr6 |= args->err;

after notify_die() returns.  Unfortunately this is impossible unless we 
change things around.  For example, instead of passing condition as an 
argument to notify_die(), we could pass (long) &condition and change 
the notifier routines to use (* (unsigned *) (args->err)) instead of 
args->err.

> > kprobes stays as it, returns NOTIFY_STOP iff it's swallowing the step.
>
> Oops, I think this breaks if there was also a ptrace db[0-3] hit in the
> same exception.  In that case, kprobes would need to not return NOTIFY_STOP
> when it otherwise would, if thread.vdr6 has low bits set.

What should happen is kprobes returns NOTIFY_STOP if there are no 
unreserved bits still set in args->err -- or (* (unsigned *) 
(args->err)) -- when it is ready to return.

Alan Stern

