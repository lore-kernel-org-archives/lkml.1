Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbZETQpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbZETQpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 12:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbZETQpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 12:45:12 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:53698 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbZETQpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 12:45:11 -0400
Date: Wed, 20 May 2009 22:15:05 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Patch 1/2] Improvements and minor fixes to HW Breakpoint
	interface
Message-ID: <20090520164505.GA7646@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090520105535.GA17181@in.ibm.com> <Pine.LNX.4.44L0.0905200951030.2914-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0905200951030.2914-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 10:04:09AM -0400, Alan Stern wrote:
> On Wed, 20 May 2009, K.Prasad wrote:
> 
> > --- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/hw_breakpoint.c
> > +++ linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
> > @@ -296,6 +296,19 @@ void arch_flush_thread_hw_breakpoint(str
> >  
> >  /*
> >   * Handle debug exception notifications.
> > + *
> > + * Return value is either NOTIFY_STOP or NOTIFY_DONE as explained below.
> > + *
> > + * NOTIFY_DONE returned if one of the following conditions is true.
> > + * i) When the causative address is from user-space and the exception
> > + * is a valid one i.e. not triggered a result of lazy debug register
> --------------------^----^  missing ',' characters
> ---------------------------------------^ missing "as"
> 
> > + * switching
> > + * ii) When there are more bits than trap<n> set in DR6 register (such
> > + * as BD, BS or BT) indicating that more than one debug condition is
> > + * met and requires some more action in do_debug().
> > + *
> > + * NOTIFY_STOP returned for all other cases
> > + *
> >   */
> >  int __kprobes hw_breakpoint_handler(struct die_args *args)
> >  {
> > @@ -346,8 +359,10 @@ int __kprobes hw_breakpoint_handler(stru
> >  		 * or due to the delay between updates of hbp_kernel_pos
> >  		 * and this_hbp_kernel.
> >  		 */
> > -		if (!bp)
> > +		if (!bp) {
> > +			rc = NOTIFY_STOP;
> >  			continue;
> > +		}
> >  
> >  		(bp->triggered)(bp, args->regs);
> 
> This is the same mistake as before.  If rc had previously been set to 
> NOTIFY_DONE then you will unconditionally change it back to 
> NOTIFY_STOP.  You should make the code do what the comment says, set rc
> to NOTIFY_DONE when a non-NULL user breakpoint occurs:
> 
> 		if (i >= hbp_kernel_pos) {
> 			bp = per_cpu(this_hbp_kernel[i], cpu);
> 		} else {
> 			bp = current->thread.hbp[i];
> 			if (bp)
> 				rc = NOTIFY_DONE;
> 		}
> 		/*
> 		 * bp can be NULL due to lazy debug register switching
> 		 * or due to the delay between updates of hbp_kernel_pos
> 		 * and this_hbp_kernel.
> 		 */
> 		if (!bp)
> 			continue;
> 
> 		(bp->triggered)(bp, args->regs);
> 
> 
> The rest of the changes are okay.
> 
> Alan Stern
>

Thanks. I am pasting the hw_breakpoint_handler() function completely
below (as opposed to patch form which may be difficult to follow). Upon
your consent with the changes, I intend to send a consolidated patchset
to Ingo (merging the patches over hw_breakpoint.c) for inclusion in -tip
tree.

I have also moved the "(*dr6_p) &= ~(DR_TRAP0 << i)" before the "if (!bp)"
check.

/*
 * Handle debug exception notifications.
 *
 * Return value is either NOTIFY_STOP or NOTIFY_DONE as explained below.
 *
 * NOTIFY_DONE returned if one of the following conditions is true.
 * i) When the causative address is from user-space and the exception
 * is a valid one, i.e. not triggered as a result of lazy debug register
 * switching
 * ii) When there are more bits than trap<n> set in DR6 register (such
 * as BD, BS or BT) indicating that more than one debug condition is
 * met and requires some more action in do_debug().
 *
 * NOTIFY_STOP returned for all other cases
 *
 */
int __kprobes hw_breakpoint_handler(struct die_args *args)
{
	int i, cpu, rc = NOTIFY_STOP;
	struct hw_breakpoint *bp;
	unsigned long dr7, dr6;
	unsigned long *dr6_p;

	/* The DR6 value is pointed by args->err */
	dr6_p = (unsigned long *)ERR_PTR(args->err);
	dr6 = *dr6_p;

	/* Do an early return if no trap bits are set in DR6 */
	if ((dr6 & DR_TRAP_BITS) == 0)
		return NOTIFY_DONE;

	/* Lazy debug register switching */
	if (!test_tsk_thread_flag(current, TIF_DEBUG))
		arch_uninstall_thread_hw_breakpoint();

	get_debugreg(dr7, 7);
	/* Disable breakpoints during exception handling */
	set_debugreg(0UL, 7);
	/*
	 * Assert that local interrupts are disabled
	 * Reset the DRn bits in the virtualized register value.
	 * The ptrace trigger routine will add in whatever is needed.
	 */
	current->thread.debugreg6 &= ~DR_TRAP_BITS;
	cpu = get_cpu();

	/* Handle all the breakpoints that were triggered */
	for (i = 0; i < HBP_NUM; ++i) {
		if (likely(!(dr6 & (DR_TRAP0 << i))))
			continue;
		/*
		 * Find the corresponding hw_breakpoint structure and
		 * invoke its triggered callback.
		 */
		if (i >= hbp_kernel_pos)
			bp = per_cpu(this_hbp_kernel[i], cpu);
		else {
			bp = current->thread.hbp[i];
			if (bp)
				rc = NOTIFY_DONE;
		}

		/*
		 * Reset the 'i'th TRAP bit in dr6 to denote completion of
		 * exception handling
		 */
		(*dr6_p) &= ~(DR_TRAP0 << i);
		/*
		 * bp can be NULL due to lazy debug register switching
		 * or due to the delay between updates of hbp_kernel_pos
		 * and this_hbp_kernel.
		 */
		if (!bp)
			continue;

		(bp->triggered)(bp, args->regs);
	}
	if (dr6 & (~DR_TRAP_BITS))
		rc = NOTIFY_DONE;

	set_debugreg(dr7, 7);
	put_cpu_no_resched();
	return rc;
}

Thanks,
K.Prasad
