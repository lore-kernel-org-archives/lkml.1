Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbZEKLhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbZEKLhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 07:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZEKLgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 07:36:50 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:46355 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbZEKLgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 07:36:49 -0400
Date: Mon, 11 May 2009 17:06:44 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 00/12] Hardware Breakpoint Interfaces
Message-ID: <20090511113644.GB26721@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090424061338.GA23812@in.ibm.com> <Pine.LNX.4.44L0.0905041650300.6437-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0905041650300.6437-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 04:55:03PM -0400, Alan Stern wrote:
> On Fri, 24 Apr 2009, K.Prasad wrote:
> 
> > Hi Alan,
> > 	The following patches contain the changes mentioned below and is based
> > on commit 335a1e07e2281795064b909aa75e3071609abd0e of -tip tree.
> > 
> > The changes to passing of DR6 register value in traps.c is separated into
> > [Patch 12/12]. kprobes and HW breakpoints have been found to work fine after 
> > the changes on an x86 box.
> > 
> > Kindly let me know what you think of the changes.
> 
> They look pretty good.  However some of the older stuff still needs 
> more work.
> 
> > --- /dev/null
> > +++ arch/x86/include/asm/hw_breakpoint.h
> 
> > +void arch_install_thread_hw_breakpoint(struct task_struct *tsk);
> > +void arch_uninstall_thread_hw_breakpoint(void);
> > +void arch_install_kernel_hw_breakpoint(void *);
> 
> This routine doesn't exist, but maybe it should.  See below...
> 
> 

Hi Alan,
	Thank you for the comments. I discovered a few locking related
issues in the code and had to fix them before I could send the patch
with your suggestions applied, and hence the delay.

Please find responses to your comments inline, while more changes
accompany the patch sent separately.

> > --- /dev/null
> > +++ kernel/hw_breakpoint.c
> 
> > +int register_kernel_hw_breakpoint(struct hw_breakpoint *bp)
> > +{
> > +	int rc;
> > +
> > +	rc = arch_validate_hwbkpt_settings(bp, NULL);
> > +	if (rc)
> > +		return rc;
> > +
> > +	spin_lock(&hw_breakpoint_lock);
> > +
> > +	rc = -EINVAL;
> > +	/* Check if we are over-committing */
> > +	if ((hbp_kernel_pos > 0) && (!hbp_user_refcount[hbp_kernel_pos-1])) {
> > +		hbp_kernel_pos--;
> > +		hbp_kernel[hbp_kernel_pos] = bp;
> > +		on_each_cpu(arch_update_kernel_hw_breakpoints, NULL, 0);
> 
> You shouldn't call on_each_cpu() while holding a spinlock.  The same
> thing happens in unregister_kernel_hw_breakpoint().
> 

First, on_each_cpu() will now be changed to return only after all
functions invoked through IPIs have returned (by changing @wait
parameter to 1). This is required to prevent side effects of
incrementing hbp_kernel_pos after on_each_cpu() in
unregister_kernel_hw_breakpoint() [hbp_kernel_pos is still incremented
after IPI and I will explain it below].

on_each_cpu() isn't a blocking call (despite @wait being set to 1, which
does a busy wait through cpu_relax()) and should be safe to invoke
inside a spin_lock() context. I would like to know if you think
otherwise.

> > +		rc = 0;
> > +	}
> > +
> > +	spin_unlock(&hw_breakpoint_lock);
> > +	return rc;
> > +}
> > +EXPORT_SYMBOL_GPL(register_kernel_hw_breakpoint);
> > +
> > +/**
> > + * unregister_kernel_hw_breakpoint - unregister a HW breakpoint for kernel space
> > + * @bp: the breakpoint structure to unregister
> > + *
> > + * Uninstalls and unregisters @bp.
> > + */
> > +void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp)
> > +{
> > +	int i, j;
> > +
> > +	spin_lock(&hw_breakpoint_lock);
> > +
> > +	/* Find the 'bp' in our list of breakpoints for kernel */
> > +	for (i = hbp_kernel_pos; i < HB_NUM; i++)
> > +		if (bp == hbp_kernel[i])
> > +			break;
> > +
> > +	/* Check if we did not find a match for 'bp'. If so return early */
> > +	if (i == HB_NUM) {
> > +		spin_unlock(&hw_breakpoint_lock);
> > +		return;
> > +	}
> > +
> > +	/*
> > +	 * We'll shift the breakpoints one-level above to compact if
> > +	 * unregistration creates a hole
> > +	 */
> > +	for (j = i; j > hbp_kernel_pos; j--)
> > +		hbp_kernel[j] = hbp_kernel[j-1];
> 
> What happens if a kernel breakpoint is triggered on another CPU while
> this loop is running?  Or what happens if the breakpoint being removed
> is triggered on another CPU before on_each_cpu() is called below?
> 
> Basically, it's impossible to change the kernel breakpoints 
> simultaneously on all CPUs.  That means you somehow have to keep both 
> the old set and the new set around until all the CPUs are updated.
> 

I must admit that the code did not handle the above scenario. I am
adding a per-cpu instance of 'hbp_kernel[]' called 'this_hbp_kernel[]'.
The breakpoint handler would use the per-cpu instance which will remain
valid throughout the execution of the handler. The per-cpu instance will
be updated with hbp_kernel[] values in arch_update_kernel_hw_breakpoint().
[This necessitates hbp_kernel_pos increment to happen after the IPI call
in unregister_kernel code].

> > +
> > +	hbp_kernel[hbp_kernel_pos] = NULL;
> > +	on_each_cpu(arch_update_kernel_hw_breakpoints, NULL, 0);
> > +	hbp_kernel_pos++;
> > +
> > +	spin_unlock(&hw_breakpoint_lock);
> > +}
> 
> 
> > --- /dev/null
> > +++ arch/x86/kernel/hw_breakpoint.c
> 
> > +/* Unmasked kernel DR7 value */
> > +static unsigned long kdr7;
> > +static const unsigned long	kdr7_masks[HB_NUM + 1] = {
> > +	0xffff00ff,	/* LEN3, R/W3, G3, L3 */
> > +	0xfff000fc,	/* Same for 3, 2 */
> > +	0xff0000f0,	/* Same for 3, 2, 1 */
> > +	0xf00f00c0,	/* Same for 3, 2, 1, 0 */
> > +	0x00000000      /* Dummy mask used when 'pos' is HB_NUM */
> > +};
> 
> These comments are completely messed up.  The comment on the first
> line, "LEN3, R/W3, G3, L3", actually applies to the fourth value,
> 0xf00f00c0.  Likewise for the others.
> 
> In the end this may not matter...
> 
> 

The kdr7_masks[] are now removed as a result of the code re-write you
suggested below!!

> > +void arch_update_kernel_hw_breakpoints(void *unused)
> > +{
> > +	struct hw_breakpoint *bp;
> > +	unsigned long dr7;
> > +	int i;
> > +
> > +	get_debugreg(dr7, 7);
> > +	/* Don't allow debug exceptions while we update the registers */
> > +	set_debugreg(0UL, 7);
> > +
> > +	/* Clear all kernel-space bits in kdr7 and dr7 before we set them */
> > +	kdr7 &= ~kdr7_masks[hbp_kernel_pos];
> > +	dr7 &= ~kdr7_masks[hbp_kernel_pos];
> 
> You probably should use current->thread.debugreg7 and eliminate the
> dr7 variable entirely.  That also means you can get rid of kdr7_masks, 
> and it means you can increment hpb_kernel_pos before doing the 
> on_each_cpu() call.
> 

It's a nice optimisation. I've included your suggestion.

> > +
> > +	for (i = hbp_kernel_pos; i < HB_NUM; i++) {
> > +		bp = hbp_kernel[i];
> > +		if (bp) {
> > +			kdr7 |= encode_dr7(i, bp->info.len, bp->info.type);
> > +			set_debugreg(hbp_kernel[i]->info.address, i);
> > +		}
> > +	}
> 
> Another problem: kdr7 is a global variable, and here you've got every
> CPU recomputing it whenever a kernel breakpoint is added or removed.
> It should be computed just once, before the on_each_cpu() call.
> 

If kdr7 needs to be updated only once, it has to be kept outside the IPI
through the use of a wrapper routine (in arch/x86/kernel/hw_breakpoint.c
as it is arch-specific). This would mean one more function call in
(un)register_kernel_<> routines taking the code back to one of its previous
designs. In a trade-off between code-brevity and efficiency, the present one
chose the former keeping in mind some of the comments received during the
early stages of this patch.

> > +
> > +	dr7 |= kdr7;
> > +
> > +	/* No need to set DR6 */
> > +	set_debugreg(dr7, 7);
> > +}
> 
> 
> > --- arch/x86/kernel/ptrace.c.orig
> > +++ arch/x86/kernel/ptrace.c
> 
> > +static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
> > +{
> > +	struct thread_struct *thread = &(tsk->thread);
> > +	unsigned long old_dr7 = thread->debugreg7;
> > +	int i, rc = 0;
> > +	int enabled;
> > +	unsigned len, type;
> > +	struct hw_breakpoint *bp;
> > +	/*
> > +	 * We want to use allocated memory inside a spinlock and we use the
> > +	 * trick below
> > +	 */
> > +	int temp_mem_used = 0;
> > +	void *temp_mem = kzalloc(sizeof(struct hw_breakpoint), GFP_KERNEL);
> > +	if (!temp_mem)
> > +		temp_mem_used = -ENOMEM;
> 
> I don't think this is a good idea...
> 

I agree that it turned out to be wrong. ptrace is now modified to use
the (un)register_user_hw_breakpoint() interfaces directly and not the
worker routines, thereby avoiding all this complexity. Please find the
changes in the new patch.

> > +restore:
> > +	/*
> > +	 * Loop through all the hardware breakpoints, making the
> > +	 * appropriate changes to each.
> > +	 */
> > +	spin_lock(&hw_breakpoint_lock);
> > +
> > +	for (i = 0; i < HB_NUM; i++) {
> > +		enabled = decode_dr7(data, i, &len, &type);
> > +		bp = thread->hbp[i];
> > +
> > +		if (!enabled) {
> > +			if (bp) {
> > +				__unregister_user_hw_breakpoint(i, tsk);
> > +				kfree(bp);
> > +			}
> > +			continue;
> > +		}
> > +
> > +		if (!bp) {
> > +			rc = -ENOMEM;
> > +			if (temp_mem_used != -ENOMEM) {
> > +				bp = temp_mem;
> 
> What happens if several new breakpoints are present at the same time?
> You'd end up using the same memory for all of them.
> 
> > +				bp->info.address = thread->debugreg[i];
> > +				bp->triggered = ptrace_triggered;
> > +				bp->info.len = len;
> > +				bp->info.type = type;
> > +				temp_mem_used = 1;
> > +				rc = __register_user_hw_breakpoint(i, tsk, bp);
> > +				if (!rc)
> > +					set_tsk_thread_flag(tsk, TIF_DEBUG);
> > +				else
> > +					kfree(bp);
> > +			}
> > +		} else
> > +			rc = __modify_user_hw_breakpoint(i, tsk, bp);
> > +
> > +		if (rc)
> > +			break;
> > + 	}
> > +	spin_unlock(&hw_breakpoint_lock);
> > +
> > +	/* If anything above failed, restore the original settings */
> > +	if (rc < 0) {
> > +		data = old_dr7;
> > +		goto restore;
> 
> And now if something went wrong, you have already freed the memory
> holding the original breakpoint structures.  It would be better to
> keep them around until you know they aren't going to be needed.
> 
> Alan Stern
> 

Thanks again for your comments.

-- K.Prasad

