Return-Path: <linux-kernel-owner+w=401wt.eu-S1757731AbZDQDNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731AbZDQDNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 23:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZDQDM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 23:12:58 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:36666 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZDQDM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 23:12:56 -0400
Date: Fri, 17 Apr 2009 08:42:21 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 00/11] Hardware Breakpoint interfaces
Message-ID: <20090417031221.GA4837@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090407063441.GA17461@in.ibm.com> <Pine.LNX.4.44L0.0904161718090.2909-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904161718090.2909-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 05:19:54PM -0400, Alan Stern wrote:
> On Tue, 7 Apr 2009, K.Prasad wrote:
> 
> > Hi Alan,
> > 	I am sending you the patches with the changes mentioned in the 
> > Changelog below. Please read the patches in conjunction with my replies
> > sent to your previous comments.
> > 
> > Let me know your thoughts on this.
> 
> Sorry to take so long on this... lots of other things keep cropping up.
> 
> Mostly it looks okay; I noticed only a few problems.  Comments inline 
> below.
> 
> Alan Stern
> 
 
Thanks for reviewing it....hope that the code quickly morphs into a form
that is acceptable to most.
 
> > --- arch/x86/include/asm/processor.h.orig
> > +++ arch/x86/include/asm/processor.h
> > @@ -429,8 +430,11 @@ struct thread_struct {
> >  	unsigned long		debugreg1;
> >  	unsigned long		debugreg2;
> >  	unsigned long		debugreg3;
> > +	unsigned long		debugreg[HB_NUM];
> 
> You forgot to get rid of debugreg1 - debugreg3!
> 
>

After the patch re-arrangement, they are removed through "[Patch
06/11]". This is to enable compilation of the main tree after
application of every patch.
 
> > +static int validate_settings(struct hw_breakpoint *bp, struct task_struct *tsk)
> > +{
> > +	int ret;
> > +
> > +	if (!bp)
> > +		return -EINVAL;
> 
> Is this test really needed?
> 

It protects us from any rogue requests which has a NULL bp pointer.
Given that the register_<kernel/user>_hw_breakpoint() interfaces are
exported, I think it keeps the code safe from poorly written modules.

And as I just see, the second parameter 'tsk' to validate_settings is
unused throughout. I will remove it.

> > +
> > +	ret = arch_validate_hwbkpt_settings(bp, tsk);
> > +	if (ret < 0)
> > +		goto err;
> > +
> > +	/* Check that the virtual address is in the proper range */
> > +	if (tsk) {
> > +		if (!arch_check_va_in_userspace(bp->info.address, bp->info.len))
> > +			return -EFAULT;
> > +	} else {
> > +		if (!arch_check_va_in_kernelspace(bp->info.address,
> > +								bp->info.len))
> > +			return -EFAULT;
> > +	}
> > + err:
> > +	return ret;
> > +}
> 
> At this point, almost nothing in the routine is arch-independent.  You
> might as well move everything into the arch-specific code and
> eliminate the validate_settings() routine.
> 

Ok. I will directly invoke arch_validate_hwbkpt_settings() [maybe this
should be called arch_validate_hw_breakpoint()] and move the arch_check_
function call inside arch_validate_.
 
> > +void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp)
> > +{
> > +	int i, j;
> > +
> > +	mutex_lock(&hw_breakpoint_mutex);
> > +
> > +	/* Find the 'bp' in our list of breakpoints for kernel */
> > +	for (i = hbp_kernel_pos; i < HB_NUM; i++)
> > +		if (bp == hbp_kernel[i])
> > +			break;
> > +
> > +	/* Check if we did not find a match for 'bp'. If so return early */
> > +	if (i == HB_NUM) {
> > +		mutex_unlock(&hw_breakpoint_mutex);
> > +		return;
> > +	}
> > +
> > +	/*
> > +	 * We'll shift the breakpoints one-level above to compact if
> > +	 * unregistration creates a hole
> > +	 */
> > +	for (j = i; j > hbp_kernel_pos; j--)
> > +		hbp_kernel[j] = hbp_kernel[j-1];
> > +
> > +	hbp_kernel[hbp_kernel_pos] = 0;
> 
> s/0/NULL/
> 

Ok.

> > +	on_each_cpu(arch_update_kernel_hw_breakpoints, NULL, 0);
> > +	hbp_kernel_pos++;
> 
> Don't you want to increment hbp_kernel_pos _before_ calling
> on_each_cpu()?  Otherwise you're telling the other CPUs to install an
> empty breakpoint.
> 

Incrementing hbp_kernel_pos after arch_update_kernel_hw_breakpoints()
during unregister_kernel_ is of the following significance:

- The 'pos' numbered debug register is reset to 0 through the code 
  "set_debugreg(hbp_kernel[i]->info.address, i)" where 'i' ranges from
  hbp_kernel_pos to HB_NUM. This is necessary during unregister operation.

- The following statements would reset the bits corresponding to
  unregistered breakpoint only then.
	kdr7 &= ~kdr7_masks[hbp_kernel_pos];
	dr7 &= ~kdr7_masks[hbp_kernel_pos];

- Helps keep the arch_update_kernel_hw_breakpoints() code generic enough
  to be invoked during register and unregister operations.


> > +/* Unmasked kernel DR7 value */
> > +static unsigned long kdr7;
> > +static const unsigned long	kdr7_masks[HB_NUM] = {
> > +	0xffff00ff,	/* Same for 3, 2, 1, 0 */
> > +	0xfff000fc,	/* Same for 3, 2, 1 */
> > +	0xff0000f0,	/* Same for 3, 2 */
> > +	0xf00f00c0	/* LEN3, R/W3, G3, L3 */
> > +};
> 
> It looks like you took out the first line of assignments.  Isn't
> kdr7_masks supposed to contain HB_NUM + 1 elements?  Not to mention
> that reordering the lines has mixed up the comments.
> 

The kdr7_masks array is slightly different from your implementation
earlier.

The element zero in the array is 0xffff00ff, which has all bits
corresponding to DRs 0, 1, 2 and 3 'set', and hence the comment.
 
> > +void arch_update_kernel_hw_breakpoints(void *unused)
> > +{
> > +	struct hw_breakpoint *bp;
> > +	unsigned long dr7;
> > +	int i;
> > +
> > +	/* Check if there is nothing to update */
> > +	if (hbp_kernel_pos == HB_NUM)
> > +		return;
> 
> This is wrong; you have to set DR7 to 0 first.  Might as well leave
> out this test and just go through the whole routine.  The "for" loop
> will be skipped entirely if hbp_kernel_pos == HB_NUM, so you don't
> save much by returning early.
> 
> Ah, now I see this is why you removed a line from kdr7_masks.
> 

This check is added to help the load_debug_registers() call during
boot-time which is when hbp_kernel_pos = HB_NUM. If we don't return
early, then assignments such as  these "kdr7 &= ~kdr7_masks[hbp_kernel_pos];"
will cause array-out-of-bounds. Otherwise we have to circumvent it by
adding a dummy HB_NUM element in kdr7_masks[] array. I would prefer
retaining the "if (hbp_kernel_pos == HB_NUM)" check instead.

> > +
> > +	get_debugreg(dr7, 7);
> > +
> > +	/* Don't allow debug exceptions while we update the registers */
> > +	set_debugreg(0UL, 7);
> > +
> > +	/* Clear all kernel-space bits in kdr7 and dr7 before we set them */
> > +	kdr7 &= ~kdr7_masks[hbp_kernel_pos];
> > +	dr7 &= ~kdr7_masks[hbp_kernel_pos];
> > +
> > +	for (i = hbp_kernel_pos; i < HB_NUM; i++) {
> > +		bp = hbp_kernel[i];
> > +		if (bp) {
> > +			kdr7 |= encode_dr7(i, bp->info.len, bp->info.type);
> > +			set_debugreg(hbp_kernel[i]->info.address, i);
> > +		}
> > +	}
> > +
> > +	dr7 |= kdr7;
> > +
> > +	/* No need to set DR6 */
> > +	set_debugreg(dr7, 7);
> > +}
> 
> 
> > +int __kprobes hw_breakpoint_handler(struct die_args *args)
> > +{
> > +	int i, rc = NOTIFY_STOP;
> > +	struct hw_breakpoint *bp;
> > +	/* The DR6 value is stored in args->err */
> > +	unsigned long dr7, dr6 = args->err;
> > +
> > +	/*
> > +	 * We are here because BT, BS or BD bit is set and no trap bits are set
> > +	 * in dr6 register. Do an early return
> > +	 */
> 
> I don't like such comments.  It says that BT, BS, or BD is set, but
> they don't necessarily have to be.  You should say:
> 
> 	/* Do an early return if no trap bits are set in DR6 */
> 

Since we enter hw_breakpoint_handler() code only if DIE_DEBUG (and not
say DIE_INT3), one or more of these bits would be 'set' when we are in
hw_breakpoint_handler() - BS, BT, BD or Trap bits, and hence the comment.

> > +	if ((dr6 & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) == 0)
> > +		return NOTIFY_DONE;
> > +
> > +	get_debugreg(dr7, 7);
> > +
> > +	/* Disable breakpoints during exception handling */
> > +	set_debugreg(0UL, 7);
> > +	/*
> > +	 * Assert that local interrupts are disabled
> > +	 * Reset the DRn bits in the virtualized register value.
> > +	 * The ptrace trigger routine will add in whatever is needed.
> > +	 */
> > +	current->thread.debugreg6 &= ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3);
> > +
> > +	/* Lazy debug register switching */
> > +	if (per_cpu(last_debugged_task, get_cpu()) != current) {
> > +		switch_to_none_hw_breakpoint();
> > +		put_cpu_no_resched();
> > +	}
> 
> Once again, the get_debugreg and set_debugreg statements above should
> go here instead.
> 

I understood that you don't want to enable *any* breakpoints - even
kernel-space ones when we are in hw_breakpoint_handler() thereby making
it safer. I will change the code in the following iteration of patch.

> > +
> > +	/* Handle all the breakpoints that were triggered */
> > +	for (i = 0; i < HB_NUM; ++i) {
> > +		if (likely(!(dr6 & (DR_TRAP0 << i))))
> > +			continue;
> > +		/*
> > +		 * Find the corresponding hw_breakpoint structure and
> > +		 * invoke its triggered callback.
> > +		 */
> > +		if (i >= hbp_kernel_pos)
> > +			bp = hbp_kernel[i];
> > +		else {
> > +			bp = current->thread.hbp[i];
> > +			if (!bp) {
> > +				/* False alarm due to lazy DR switching */
> > +				continue;
> > +			}
> > +		}
> > +		(bp->triggered)(bp, args->regs);
> > +		/*
> > +		 * We have more work to do (send signals) if the breakpoint is
> > +		 * triggered due to user-space address, or if exceptions other
> > +		 * than breakpoint (such as single-stepping) are triggered.
> > +		 */
> > +		if (arch_check_va_in_userspace(bp->info.address, bp->info.len))
> > +			rc = NOTIFY_DONE;
> 
> This comment and test are more complicated than they need to be.  Just
> put "rc = NOTIFY_DONE" (with a comment) in the "else" clause above.
> 

Yes, that's much simpler and avoids a double-check. Will do it.

> > +	}
> > +	if (dr6 & ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3))
> > +		rc = NOTIFY_DONE;
> > +	set_debugreg(dr7, 7);
> > +	return rc;
> > +}
> 
> 
> >  dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
> >  {
> >  	struct task_struct *tsk = current;
> > -	unsigned long condition;
> > +	unsigned long dr6;
> >  	int si_code;
> >  
> > -	get_debugreg(condition, 6);
> > +	get_debugreg(dr6, 6);
> > +	set_debugreg(0, 6);	/* DR6 may or may not be cleared by the CPU */
> >  
> >  	/* Catch kmemcheck conditions first of all! */
> > -	if (condition & DR_STEP && kmemcheck_trap(regs))
> > +	if ((dr6 & DR_STEP && kmemcheck_trap(regs)) &&
> > +		!(dr6 & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)))
> >  		return;
> 
> Should this test go before the "set_debugreg(0, 6)" statement?
> 

Either way, it doesn't affect the function "kmemcheck_trap()". I don't
find it reading directly from DR6 anywhere.

On a related node, a patch that modifies dr6 to be passed by reference
to the notifier calls will be included in the next iteration.

Let me know, upon receiving the patch, if you still think that such a
change i.e. resetting bits in dr6 after handling of the corresponding 
breakpoint needs to be done.

Thanks,
K.Prasad

