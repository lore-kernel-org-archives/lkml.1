Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbZELOFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbZELOFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 10:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbZELOFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 10:05:34 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:60392 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbZELOFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 10:05:33 -0400
Date: Tue, 12 May 2009 19:35:25 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 00/12] Hardware Breakpoint Interfaces
Message-ID: <20090512140525.GA6033@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090511172034.GA8774@in.ibm.com> <Pine.LNX.4.44L0.0905111358020.3588-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0905111358020.3588-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 02:09:48PM -0400, Alan Stern wrote:
> On Mon, 11 May 2009, K.Prasad wrote:
> 
> > > Still, in hw_breakpoint_handler(), perhaps the "if (i >= 
> > > hbp_kernel_pos)" path should also check for !bp.  Just to be safe.  In 
> > > other words, move the 
> > > 
> > > +			if (!bp)
> > > +				continue;
> > > +			rc = NOTIFY_DONE;
> > > 
> > > lines outside the "if" statement.
> > > 
> > > 
> > 
> > I don't see where the out-of-sync situation between hbp_kernel_pos and
> > this_hbp_kernel[] can cause problem. Our concern is when an exception
> > arises in the small time-window starting at the time when hbp_kernel[]
> > is updated in common code and ends when exceptions are disabled through
> > the IPI routine arch_update_kernel_hw_breakpoint. Consider these two
> > cases now:
> > 
> > i)register_kernel_hw_breakpoint() - Although hbp_kernel_pos is
> > decremented before the IPI, no new exceptions will arise because of the
> > same on a CPU where this_hbp_kernel[] is not synced because the physical
> > debug registers are not yet set. So, the 'i' in "if (i >= hbp_kernel_pos)"
> > cannot belong to the newly registered breakpoint. If it is for the new
> > breakpoint, then it is on a CPU where this_hbp_kernel[] is synced with
> > hbp_kernel[].
> > 
> > ii)unregister_kernel_hw_breakpoint() - hbp_kernel_pos is incremented
> > after all the IPIs have finished, so hbp_kernel_pos still points to the
> > old value whose hbp_kernel[] is NULL. However in "if (i >= hbp_kernel_pos)"
> > if 'i' points to the 'pending-delete' breakpoint, then 'bp' is derived
> > from this_hbp_kernel[] which contains the old value. The callback
> > bp->triggered() is invoked and the exception returns fine.
> > 
> > Let me know if I am missing any possibility leading to incorrect
> > behaviour. 
> 
> Your analysis is correct, but to me it feels a little fragile.  Future
> changes to the code might cause an unexpected interaction.  Moving that
> test won't hurt anything and it will make the handler slightly more
> robust.
> 
>

I agree it keeps the code much safer. Here's the relevant code-snippet:

		if (i >= hbp_kernel_pos)
			bp = per_cpu(this_hbp_kernel[i], cpu);
		else {
			bp = current->thread.hbp[i];
			rc = NOTIFY_DONE;
		}
		/*
		 * bp can be NULL due to lazy debug register switching
		 * for
		 * user-space requests or the exception was triggered in
		 * the
		 * mismatch window when 'hbp_kernel_pos' and
		 * 'this_hbp_kernel[]'
		 * are out-of-sync
		 */
		if (!bp)
			continue;

> > > I still think it would be a good idea to avoid freeing any breakpoint
> > > structures until you know for certain they aren't needed.  Otherwise
> > > you might find that you're unable to allocate memory to re-create a
> > > structure that was already present.
> > > 
> > > Alan Stern
> > >
> > 
> > I agree that we shouldn't free memory temporarily that would be needed
> > later, as memory may not be available. However such a situation does not
> > arise in ptrace_write_dr7() after the re-write using
> > (un)register_user_hw_breakpoint(). kfree(bp) is done when
> > i) an existing breakpoint is disabled
> > ii) a breakpoint is requested but register_user_hw_breakpoint() routine
> > fails for some reasons. Hence the breakpoint structure kzalloc()'ed
> > afresh is kfree()'ed.
> > iii) In case of modifications to the type of breakpoint (such as
> > read<-->write), the breakpoint structure is not de-allocated and this is
> > where __modify_user_hw_breakpoint() helps us. There is no opportunity
> > window where the breakpoint can be grabbed by other requests when a
> > modification is done.
> > 
> > Let me know if you think there's still some discrepancy here.
> 
> Okay.  Let's suppose a single userspace breakpoint has already been
> allocated and set up as breakpoint 0.  Now another ptrace call comes
> along, in which bp 0 is disabled and bp 1 is requested.  This is your
> case (i); the breakpoint structure for bp 0 will be deallocated.  But
> maybe something goes wrong with the register_user_hw_breakpoint() call
> for bp 1, so we have to restore the old settings.  The code will try to
> allocate a new breakpoint structure to hold bp 0; what happens if
> that allocation fails?  The user program will know that the write to
> DR7 didn't succeed, so it will think the pre-existing breakpoint is
> still valid.  But it isn't.
> 
> If instead you had avoided deallocated the structure for bp 0 until the 
> end, then there would be no need to reallocate it during the restore 
> and so the restore would succeed.
> 
> Alan Stern

Thanks for explaining the case so well, I did not foresee it! The
ptrace_write_dr7() is modified to perform changes in two-passes. The first
one will effect all register/modify operations while the second one will
unregister. One issue that I see in this method is if/when virtual debug
registers are implemented, we may incorrectly deny a register request
for want of physical debug registers (because they have not been free-ed
through an earlier unregister operation). Let me know if you think it
can be done better. Here's the new ptrace_write_dr7():


static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
{
	struct thread_struct *thread = &(tsk->thread);
	unsigned long old_dr7 = thread->debugreg7;
	int i, rc = 0;
	int enabled, second_pass_reqd = 1;
	unsigned len, type;
	struct hw_breakpoint *bp;

	data &= ~DR_CONTROL_RESERVED;
restore:
	/*
	 * Loop through all the hardware breakpoints, making the
	 * appropriate changes to each.
	 */
	for (i = 0; i < HB_NUM; i++) {
		enabled = decode_dr7(data, i, &len, &type);
		bp = thread->hbp[i];

		if (!enabled) {
			if (bp) {
				/* Don't unregister the breakpoints right-away,
				 * unless all register_user_hw_breakpoint()
				 * requests have succeeded. This prevents
				 * any window of opportunity for debug
				 * register grabbing by other users.
				 */
				if (second_pass_reqd)
					continue;
				unregister_user_hw_breakpoint(tsk, bp);
				kfree(bp);
			}
			continue;
		}

		if (!bp) {
			rc = -ENOMEM;
			bp = kzalloc(sizeof(struct hw_breakpoint), GFP_KERNEL);
			if (bp) {
				bp->info.address = thread->debugreg[i];
				bp->triggered = ptrace_triggered;
				bp->info.len = len;
				bp->info.type = type;
				rc = register_user_hw_breakpoint(tsk, bp);
				if (!rc)
					set_tsk_thread_flag(tsk, TIF_DEBUG);
				else
					kfree(bp);
			}
		} else {
			spin_lock_bh(&hw_breakpoint_lock);
			rc = __modify_user_hw_breakpoint(i, tsk, bp);
			spin_unlock_bh(&hw_breakpoint_lock);
		}

		if (rc)
			break;
	}

	/* If anything above failed, restore the original settings */
	if (rc < 0) {
		data = old_dr7;
		second_pass_reqd = 0;
		goto restore;
	}
	if (second_pass_reqd) {
		/* Enter the second-pass after disabling 'second_pass_reqd' */
		second_pass_reqd = 0;
		goto restore;
	}
	return rc;
}

I will repost the patchset along with the changes explained above.

Thanks,
K.Prasad

