Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbZDPVUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbZDPVUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 17:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZDPVT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 17:19:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54772 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753362AbZDPVT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 17:19:56 -0400
Date: Thu, 16 Apr 2009 17:19:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, <maneesh@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 00/11] Hardware Breakpoint interfaces
In-Reply-To: <20090407063441.GA17461@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0904161718090.2909-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, K.Prasad wrote:

> Hi Alan,
> 	I am sending you the patches with the changes mentioned in the 
> Changelog below. Please read the patches in conjunction with my replies
> sent to your previous comments.
> 
> Let me know your thoughts on this.

Sorry to take so long on this... lots of other things keep cropping up.

Mostly it looks okay; I noticed only a few problems.  Comments inline 
below.

Alan Stern



> --- arch/x86/include/asm/processor.h.orig
> +++ arch/x86/include/asm/processor.h
> @@ -429,8 +430,11 @@ struct thread_struct {
>  	unsigned long		debugreg1;
>  	unsigned long		debugreg2;
>  	unsigned long		debugreg3;
> +	unsigned long		debugreg[HB_NUM];

You forgot to get rid of debugreg1 - debugreg3!


> +static int validate_settings(struct hw_breakpoint *bp, struct task_struct *tsk)
> +{
> +	int ret;
> +
> +	if (!bp)
> +		return -EINVAL;

Is this test really needed?

> +
> +	ret = arch_validate_hwbkpt_settings(bp, tsk);
> +	if (ret < 0)
> +		goto err;
> +
> +	/* Check that the virtual address is in the proper range */
> +	if (tsk) {
> +		if (!arch_check_va_in_userspace(bp->info.address, bp->info.len))
> +			return -EFAULT;
> +	} else {
> +		if (!arch_check_va_in_kernelspace(bp->info.address,
> +								bp->info.len))
> +			return -EFAULT;
> +	}
> + err:
> +	return ret;
> +}

At this point, almost nothing in the routine is arch-independent.  You
might as well move everything into the arch-specific code and
eliminate the validate_settings() routine.


> +void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp)
> +{
> +	int i, j;
> +
> +	mutex_lock(&hw_breakpoint_mutex);
> +
> +	/* Find the 'bp' in our list of breakpoints for kernel */
> +	for (i = hbp_kernel_pos; i < HB_NUM; i++)
> +		if (bp == hbp_kernel[i])
> +			break;
> +
> +	/* Check if we did not find a match for 'bp'. If so return early */
> +	if (i == HB_NUM) {
> +		mutex_unlock(&hw_breakpoint_mutex);
> +		return;
> +	}
> +
> +	/*
> +	 * We'll shift the breakpoints one-level above to compact if
> +	 * unregistration creates a hole
> +	 */
> +	for (j = i; j > hbp_kernel_pos; j--)
> +		hbp_kernel[j] = hbp_kernel[j-1];
> +
> +	hbp_kernel[hbp_kernel_pos] = 0;

s/0/NULL/

> +	on_each_cpu(arch_update_kernel_hw_breakpoints, NULL, 0);
> +	hbp_kernel_pos++;

Don't you want to increment hbp_kernel_pos _before_ calling
on_each_cpu()?  Otherwise you're telling the other CPUs to install an
empty breakpoint.


> +/* Unmasked kernel DR7 value */
> +static unsigned long kdr7;
> +static const unsigned long	kdr7_masks[HB_NUM] = {
> +	0xffff00ff,	/* Same for 3, 2, 1, 0 */
> +	0xfff000fc,	/* Same for 3, 2, 1 */
> +	0xff0000f0,	/* Same for 3, 2 */
> +	0xf00f00c0	/* LEN3, R/W3, G3, L3 */
> +};

It looks like you took out the first line of assignments.  Isn't
kdr7_masks supposed to contain HB_NUM + 1 elements?  Not to mention
that reordering the lines has mixed up the comments.


> +void arch_update_kernel_hw_breakpoints(void *unused)
> +{
> +	struct hw_breakpoint *bp;
> +	unsigned long dr7;
> +	int i;
> +
> +	/* Check if there is nothing to update */
> +	if (hbp_kernel_pos == HB_NUM)
> +		return;

This is wrong; you have to set DR7 to 0 first.  Might as well leave
out this test and just go through the whole routine.  The "for" loop
will be skipped entirely if hbp_kernel_pos == HB_NUM, so you don't
save much by returning early.

Ah, now I see this is why you removed a line from kdr7_masks.

> +
> +	get_debugreg(dr7, 7);
> +
> +	/* Don't allow debug exceptions while we update the registers */
> +	set_debugreg(0UL, 7);
> +
> +	/* Clear all kernel-space bits in kdr7 and dr7 before we set them */
> +	kdr7 &= ~kdr7_masks[hbp_kernel_pos];
> +	dr7 &= ~kdr7_masks[hbp_kernel_pos];
> +
> +	for (i = hbp_kernel_pos; i < HB_NUM; i++) {
> +		bp = hbp_kernel[i];
> +		if (bp) {
> +			kdr7 |= encode_dr7(i, bp->info.len, bp->info.type);
> +			set_debugreg(hbp_kernel[i]->info.address, i);
> +		}
> +	}
> +
> +	dr7 |= kdr7;
> +
> +	/* No need to set DR6 */
> +	set_debugreg(dr7, 7);
> +}


> +int __kprobes hw_breakpoint_handler(struct die_args *args)
> +{
> +	int i, rc = NOTIFY_STOP;
> +	struct hw_breakpoint *bp;
> +	/* The DR6 value is stored in args->err */
> +	unsigned long dr7, dr6 = args->err;
> +
> +	/*
> +	 * We are here because BT, BS or BD bit is set and no trap bits are set
> +	 * in dr6 register. Do an early return
> +	 */

I don't like such comments.  It says that BT, BS, or BD is set, but
they don't necessarily have to be.  You should say:

	/* Do an early return if no trap bits are set in DR6 */

> +	if ((dr6 & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) == 0)
> +		return NOTIFY_DONE;
> +
> +	get_debugreg(dr7, 7);
> +
> +	/* Disable breakpoints during exception handling */
> +	set_debugreg(0UL, 7);
> +	/*
> +	 * Assert that local interrupts are disabled
> +	 * Reset the DRn bits in the virtualized register value.
> +	 * The ptrace trigger routine will add in whatever is needed.
> +	 */
> +	current->thread.debugreg6 &= ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3);
> +
> +	/* Lazy debug register switching */
> +	if (per_cpu(last_debugged_task, get_cpu()) != current) {
> +		switch_to_none_hw_breakpoint();
> +		put_cpu_no_resched();
> +	}

Once again, the get_debugreg and set_debugreg statements above should
go here instead.

> +
> +	/* Handle all the breakpoints that were triggered */
> +	for (i = 0; i < HB_NUM; ++i) {
> +		if (likely(!(dr6 & (DR_TRAP0 << i))))
> +			continue;
> +		/*
> +		 * Find the corresponding hw_breakpoint structure and
> +		 * invoke its triggered callback.
> +		 */
> +		if (i >= hbp_kernel_pos)
> +			bp = hbp_kernel[i];
> +		else {
> +			bp = current->thread.hbp[i];
> +			if (!bp) {
> +				/* False alarm due to lazy DR switching */
> +				continue;
> +			}
> +		}
> +		(bp->triggered)(bp, args->regs);
> +		/*
> +		 * We have more work to do (send signals) if the breakpoint is
> +		 * triggered due to user-space address, or if exceptions other
> +		 * than breakpoint (such as single-stepping) are triggered.
> +		 */
> +		if (arch_check_va_in_userspace(bp->info.address, bp->info.len))
> +			rc = NOTIFY_DONE;

This comment and test are more complicated than they need to be.  Just
put "rc = NOTIFY_DONE" (with a comment) in the "else" clause above.

> +	}
> +	if (dr6 & ~(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3))
> +		rc = NOTIFY_DONE;
> +	set_debugreg(dr7, 7);
> +	return rc;
> +}


>  dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>  {
>  	struct task_struct *tsk = current;
> -	unsigned long condition;
> +	unsigned long dr6;
>  	int si_code;
>  
> -	get_debugreg(condition, 6);
> +	get_debugreg(dr6, 6);
> +	set_debugreg(0, 6);	/* DR6 may or may not be cleared by the CPU */
>  
>  	/* Catch kmemcheck conditions first of all! */
> -	if (condition & DR_STEP && kmemcheck_trap(regs))
> +	if ((dr6 & DR_STEP && kmemcheck_trap(regs)) &&
> +		!(dr6 & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)))
>  		return;

Should this test go before the "set_debugreg(0, 6)" statement?

