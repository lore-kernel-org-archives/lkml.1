Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZELOz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZELOz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 10:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbZELOzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 10:55:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33097 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751163AbZELOzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 10:55:13 -0400
Date: Tue, 12 May 2009 10:55:10 -0400 (EDT)
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
In-Reply-To: <20090512140525.GA6033@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0905121035280.2824-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009, K.Prasad wrote:

> I agree it keeps the code much safer. Here's the relevant code-snippet:
> 
> 		if (i >= hbp_kernel_pos)
> 			bp = per_cpu(this_hbp_kernel[i], cpu);
> 		else {
> 			bp = current->thread.hbp[i];
> 			rc = NOTIFY_DONE;
> 		}
> 		/*
> 		 * bp can be NULL due to lazy debug register switching
> 		 * for
> 		 * user-space requests or the exception was triggered in
> 		 * the
> 		 * mismatch window when 'hbp_kernel_pos' and
> 		 * 'this_hbp_kernel[]'
> 		 * are out-of-sync
> 		 */

The comment could be a little more grammatical and more succinct.  For 
example:

		/*
		 * bp can be NULL due to lazy debug register switching
		 * or to the delay between updates of hbp_kernel_pos 
		 * and this_hbp_kernel.
		 */

> > Okay.  Let's suppose a single userspace breakpoint has already been
> > allocated and set up as breakpoint 0.  Now another ptrace call comes
> > along, in which bp 0 is disabled and bp 1 is requested.  This is your
> > case (i); the breakpoint structure for bp 0 will be deallocated.  But
> > maybe something goes wrong with the register_user_hw_breakpoint() call
> > for bp 1, so we have to restore the old settings.  The code will try to
> > allocate a new breakpoint structure to hold bp 0; what happens if
> > that allocation fails?  The user program will know that the write to
> > DR7 didn't succeed, so it will think the pre-existing breakpoint is
> > still valid.  But it isn't.
> > 
> > If instead you had avoided deallocated the structure for bp 0 until the 
> > end, then there would be no need to reallocate it during the restore 
> > and so the restore would succeed.
> > 
> > Alan Stern
> 
> Thanks for explaining the case so well, I did not foresee it! The
> ptrace_write_dr7() is modified to perform changes in two-passes. The first
> one will effect all register/modify operations while the second one will
> unregister. One issue that I see in this method is if/when virtual debug
> registers are implemented, we may incorrectly deny a register request
> for want of physical debug registers (because they have not been free-ed
> through an earlier unregister operation). Let me know if you think it
> can be done better. Here's the new ptrace_write_dr7():
> 
> 
> static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
> {
> 	struct thread_struct *thread = &(tsk->thread);
> 	unsigned long old_dr7 = thread->debugreg7;
> 	int i, rc = 0;
> 	int enabled, second_pass_reqd = 1;
> 	unsigned len, type;
> 	struct hw_breakpoint *bp;
> 
> 	data &= ~DR_CONTROL_RESERVED;
> restore:
> 	/*
> 	 * Loop through all the hardware breakpoints, making the
> 	 * appropriate changes to each.
> 	 */
> 	for (i = 0; i < HB_NUM; i++) {
> 		enabled = decode_dr7(data, i, &len, &type);
> 		bp = thread->hbp[i];
> 
> 		if (!enabled) {
> 			if (bp) {
> 				/* Don't unregister the breakpoints right-away,
> 				 * unless all register_user_hw_breakpoint()
> 				 * requests have succeeded. This prevents
> 				 * any window of opportunity for debug
> 				 * register grabbing by other users.
> 				 */
> 				if (second_pass_reqd)
> 					continue;
> 				unregister_user_hw_breakpoint(tsk, bp);
> 				kfree(bp);
> 			}
> 			continue;
> 		}
> 
> 		if (!bp) {
> 			rc = -ENOMEM;
> 			bp = kzalloc(sizeof(struct hw_breakpoint), GFP_KERNEL);
> 			if (bp) {
> 				bp->info.address = thread->debugreg[i];
> 				bp->triggered = ptrace_triggered;
> 				bp->info.len = len;
> 				bp->info.type = type;
> 				rc = register_user_hw_breakpoint(tsk, bp);
> 				if (!rc)
> 					set_tsk_thread_flag(tsk, TIF_DEBUG);
> 				else
> 					kfree(bp);
> 			}
> 		} else {
> 			spin_lock_bh(&hw_breakpoint_lock);
> 			rc = __modify_user_hw_breakpoint(i, tsk, bp);
> 			spin_unlock_bh(&hw_breakpoint_lock);

With these changes, __register_user_hw_breakpoint() and 
__unregister_user_hw_breakpoint() no longer need to be separate 
routines.  Similarly, __modify_user_hw_breakpoint() can be renamed 
without the "__" prefix, and it can acquire the spinlock instead of 
making the caller do the locking.

Then hw_breakpoint_lock can be made static.  There's no need to lock it 
in ptrace_get_debugreg() any more.

> 		}
> 
> 		if (rc)
> 			break;
> 	}
> 
> 	/* If anything above failed, restore the original settings */
> 	if (rc < 0) {
> 		data = old_dr7;
> 		second_pass_reqd = 0;
> 		goto restore;
> 	}
> 	if (second_pass_reqd) {
> 		/* Enter the second-pass after disabling 'second_pass_reqd' */
> 		second_pass_reqd = 0;
> 		goto restore;
> 	}
> 	return rc;
> }
> 
> I will repost the patchset along with the changes explained above.

I think it would be less confusing if you change the name
"second_pass_reqd" to just "second_pass", setting it to 0 the first
time through and 1 the second time.  So at the end:

	/*
	 * Make a second pass to free the remaining unused breakpoints
	 * or to restore the original breakpoints if an error occurred.
	 */
	if (!second_pass) {
		second_pass = 1;
		if (rc < 0)
			data = old_dr7;
		goto restore;
	}

Also, you need to be more careful about the value of rc.  The error 
code you return should be the error that caused the first pass to fail.  
Errors or successes during the second pass shouldn't overwrite that 
value.

Alan Stern

