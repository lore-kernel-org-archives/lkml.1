Return-Path: <linux-kernel-owner+w=401wt.eu-S932800AbXF2DAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800AbXF2DAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 23:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765087AbXF2DAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 23:00:25 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1229 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762915AbXF2DAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 23:00:24 -0400
Date: Thu, 28 Jun 2007 23:00:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070627210417.879DC4D05E6@magilla.localdomain>
Message-ID: <Pine.LNX.4.44L0.0706272308330.31168-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Roland McGrath wrote:

> > In theory we should get an exception with both DR_STEP and DR_TRAPn 
> > set, meaning that neither notifier will return NOTIFY_STOP.  But if the 
> > kprobes handler clears DR_STEP in the DR6 image passed to the 
> > hw_breakpoint handler, it should work out better.
> 
> It's since occurred to me that kprobes can and should do:
> 
> 	args->err &= ~(unsigned long) DR_STEP;
> 	if (args->err == 0)
> 		return NOTIFY_STOP;
> 
> This doesn't affect do_debug directly, but it will change the value seen by
> the next notifier.  So if hw_breakpoint_handler is responsible for setting
> vdr6 based on its args->err value, we should win.

Exactly what I had in mind.

> > > vdr6 belongs wholly to hw_breakpoint, no other code refers to it
> > > directly.  hw_breakpoint's notifier sets vdr6 with non-DR_TRAPn bits,
> > > if it's a user-mode exception.  If it's a ptrace exception it also
> > > sets the mapped DR_TRAPn bits.  If it's not a ptrace exception and
> > > only DR_TRAPn bits were newly set, then it returns NOTIFY_STOP.  If
> > > it's a spurious exception from lazy db7 setting, hw_breakpoint just
> > > returns NOTIFY_STOP early.
> > 
> > That sounds not quite right.  To a user-space debugger, a system call
> > should appear as an atomic operation.  If multiple ptrace exceptions
> > occur during a system call, all the relevant DR_TRAPn bits should be
> > set in vdr6 together and all the other ones reset.  How can we arrange
> > that?
> 
> That would be nice.  But it's more than the old code did.  I don't feel any
> strong need to improve the situation when using ptrace.  The old code
> disabled breakpoints after the first hit, so userland would only see the
> first DR_TRAPn bit.  (Even if it didn't, with the blind copying of the
> hardware %db6 value, we now know it would only see one DR_TRAPn bit still
> set after a second exception.)  With my suggestion above, userland would
> only see the last DR_TRAPn bit.  So it's not worse.
> 
> In the ptrace case, we know it's always going to wind up with a signal
> before it finishes and returns to user mode.  So one approach would be in
> e.g. do_notify_resume, do:
> 
> 	if (thread_info_flags & _TIF_DEBUG)
> 		current->thread.hw_breakpoint_info->someflag = 0;
> 
> Then ptrace_triggered could set someflag, and know from it still being set
> on entry that it's a second trigger without getting back to user mode yet
> (and so accumulate bits instead reset old ones).
> 
> But I just would not bother improving ptrace beyond the status quo for a
> corner case noone has cared about in practice so far.  In sensible
> mechanisms of the future, nothing will examine db6 values directly.

Come to think of it, I believe that gdb doesn't check beyond the first 
DR_TRAPn bit it finds set.  I can live with reporting only the last 
hit.

> > There's also the question of whether to send the SIGTRAP.  If
> > extraneous bits are set in DR6 (e.g., because the CPU always sets some
> > extra bits) then we will never get NOTIFY_STOP.  Nevertheless, the
> > signal should not always be sent.
> 
> Yeah.  The current Intel manual describes all the unspecified DR6 bits as
> explicitly reserved and set to 1 (except 0x1000 reserved and 0).  If new
> meanings are assigned in future chips, presumably those will only be
> enabled by some new explicit cr/msr setting.  Those might be enabled by
> some extra module or something, but there is only so much we can do to
> accomodate.  I think the best plan is that notifiers should do:
> 
> 	args->err &= ~bits_i_recognize_as_mine;
> 	if (!(args->err & known_bits))
> 		return NOTIFY_STOP;
> 
> known_bits are the ones we use, plus 0x8000 (DR_SWITCH/BS) and 0x2000 (BD).
> (Those two should be impossible without some strange new kernel bug.)
> Probably should write it as ~DR_STATUS_RESERVED, to parallel existing macros.
> 
> Then we only possibly interfere with a newfangled debug exception flavor
> that occurs in the same one debug exception for an instruction also
> triggering for hw_breakpoint or step.  In the more likely cases of a new
> flavor of exception happening by itself, or the aforementioned strange new
> kernel bugs, we will get to the bottom of do_debug and do the SIGTRAP.
> 
> For this plan, hw_breakpoint_handler also needs not to return NOTIFY_STOP
> as a special case for a ptrace trigger.

That should work well.  But how does the handler know whether a ptrace
trigger occurred?  I can think of several possible ways, none of them
very attractive.  Simply checking the vdr6 value might not work.  The
simplest approach would be to see if the trigger callback address is
equal to ptrace_triggered -- it's a hack but it is reliable.

For that matter, knowing when to set vdr6 is a little tricky.  I guess
it should be set whenever a debug exception occurs in user mode (which
includes both breakpoints and single-step events).  But what about
ptrace triggers while the CPU is in kernel mode?  Should they set the
four DR_TRAPn bits in vdr6 and leave the rest alone?

> > I disagree.  kfree() is documented to return harmlessly when passed a
> > NULL pointer, and lots of places in the kernel have been changed to
> > remove useless tests for NULL before calls to kfree().  This is just
> > another example.
> 
> Ok.  I have no special opinions about that.  I just tend to avoid folding
> miscellaneous changes into a patch adding new code.  It would be better
> form to send first the trivial cleanup patch removing that second condition.

Sounds reasonable.  I'll split it out.

Alan Stern

