Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbZEKSJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbZEKSJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZEKSJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:09:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33287 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751531AbZEKSJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:09:47 -0400
Date: Mon, 11 May 2009 14:09:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, <maneesh@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 00/12] Hardware Breakpoint Interfaces
In-Reply-To: <20090511172034.GA8774@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0905111358020.3588-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, K.Prasad wrote:

> > Still, in hw_breakpoint_handler(), perhaps the "if (i >= 
> > hbp_kernel_pos)" path should also check for !bp.  Just to be safe.  In 
> > other words, move the 
> > 
> > +			if (!bp)
> > +				continue;
> > +			rc = NOTIFY_DONE;
> > 
> > lines outside the "if" statement.
> > 
> > 
> 
> I don't see where the out-of-sync situation between hbp_kernel_pos and
> this_hbp_kernel[] can cause problem. Our concern is when an exception
> arises in the small time-window starting at the time when hbp_kernel[]
> is updated in common code and ends when exceptions are disabled through
> the IPI routine arch_update_kernel_hw_breakpoint. Consider these two
> cases now:
> 
> i)register_kernel_hw_breakpoint() - Although hbp_kernel_pos is
> decremented before the IPI, no new exceptions will arise because of the
> same on a CPU where this_hbp_kernel[] is not synced because the physical
> debug registers are not yet set. So, the 'i' in "if (i >= hbp_kernel_pos)"
> cannot belong to the newly registered breakpoint. If it is for the new
> breakpoint, then it is on a CPU where this_hbp_kernel[] is synced with
> hbp_kernel[].
> 
> ii)unregister_kernel_hw_breakpoint() - hbp_kernel_pos is incremented
> after all the IPIs have finished, so hbp_kernel_pos still points to the
> old value whose hbp_kernel[] is NULL. However in "if (i >= hbp_kernel_pos)"
> if 'i' points to the 'pending-delete' breakpoint, then 'bp' is derived
> from this_hbp_kernel[] which contains the old value. The callback
> bp->triggered() is invoked and the exception returns fine.
> 
> Let me know if I am missing any possibility leading to incorrect
> behaviour. 

Your analysis is correct, but to me it feels a little fragile.  Future
changes to the code might cause an unexpected interaction.  Moving that
test won't hurt anything and it will make the handler slightly more
robust.


> > I still think it would be a good idea to avoid freeing any breakpoint
> > structures until you know for certain they aren't needed.  Otherwise
> > you might find that you're unable to allocate memory to re-create a
> > structure that was already present.
> > 
> > Alan Stern
> >
> 
> I agree that we shouldn't free memory temporarily that would be needed
> later, as memory may not be available. However such a situation does not
> arise in ptrace_write_dr7() after the re-write using
> (un)register_user_hw_breakpoint(). kfree(bp) is done when
> i) an existing breakpoint is disabled
> ii) a breakpoint is requested but register_user_hw_breakpoint() routine
> fails for some reasons. Hence the breakpoint structure kzalloc()'ed
> afresh is kfree()'ed.
> iii) In case of modifications to the type of breakpoint (such as
> read<-->write), the breakpoint structure is not de-allocated and this is
> where __modify_user_hw_breakpoint() helps us. There is no opportunity
> window where the breakpoint can be grabbed by other requests when a
> modification is done.
> 
> Let me know if you think there's still some discrepancy here.

Okay.  Let's suppose a single userspace breakpoint has already been
allocated and set up as breakpoint 0.  Now another ptrace call comes
along, in which bp 0 is disabled and bp 1 is requested.  This is your
case (i); the breakpoint structure for bp 0 will be deallocated.  But
maybe something goes wrong with the register_user_hw_breakpoint() call
for bp 1, so we have to restore the old settings.  The code will try to
allocate a new breakpoint structure to hold bp 0; what happens if
that allocation fails?  The user program will know that the write to
DR7 didn't succeed, so it will think the pre-existing breakpoint is
still valid.  But it isn't.

If instead you had avoided deallocated the structure for bp 0 until the 
end, then there would be no need to reallocate it during the restore 
and so the restore would succeed.

Alan Stern

