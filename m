Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbZETRxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbZETRxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 13:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbZETRxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 13:53:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52527 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753825AbZETRxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 13:53:45 -0400
Date: Wed, 20 May 2009 13:53:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Patch 1/2] Improvements and minor fixes to HW Breakpoint
 interface
In-Reply-To: <20090520164505.GA7646@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0905201353160.4044-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009, K.Prasad wrote:

> Thanks. I am pasting the hw_breakpoint_handler() function completely
> below (as opposed to patch form which may be difficult to follow). Upon
> your consent with the changes, I intend to send a consolidated patchset
> to Ingo (merging the patches over hw_breakpoint.c) for inclusion in -tip
> tree.
> 
> I have also moved the "(*dr6_p) &= ~(DR_TRAP0 << i)" before the "if (!bp)"
> check.
> 
> /*
>  * Handle debug exception notifications.
>  *
>  * Return value is either NOTIFY_STOP or NOTIFY_DONE as explained below.
>  *
>  * NOTIFY_DONE returned if one of the following conditions is true.
>  * i) When the causative address is from user-space and the exception
>  * is a valid one, i.e. not triggered as a result of lazy debug register
>  * switching
>  * ii) When there are more bits than trap<n> set in DR6 register (such
>  * as BD, BS or BT) indicating that more than one debug condition is
>  * met and requires some more action in do_debug().
>  *
>  * NOTIFY_STOP returned for all other cases
>  *
>  */
> int __kprobes hw_breakpoint_handler(struct die_args *args)
> {
> 	int i, cpu, rc = NOTIFY_STOP;
> 	struct hw_breakpoint *bp;
> 	unsigned long dr7, dr6;
> 	unsigned long *dr6_p;
> 
> 	/* The DR6 value is pointed by args->err */
> 	dr6_p = (unsigned long *)ERR_PTR(args->err);
> 	dr6 = *dr6_p;
> 
> 	/* Do an early return if no trap bits are set in DR6 */
> 	if ((dr6 & DR_TRAP_BITS) == 0)
> 		return NOTIFY_DONE;
> 
> 	/* Lazy debug register switching */
> 	if (!test_tsk_thread_flag(current, TIF_DEBUG))
> 		arch_uninstall_thread_hw_breakpoint();
> 
> 	get_debugreg(dr7, 7);
> 	/* Disable breakpoints during exception handling */
> 	set_debugreg(0UL, 7);
> 	/*
> 	 * Assert that local interrupts are disabled
> 	 * Reset the DRn bits in the virtualized register value.
> 	 * The ptrace trigger routine will add in whatever is needed.
> 	 */
> 	current->thread.debugreg6 &= ~DR_TRAP_BITS;
> 	cpu = get_cpu();
> 
> 	/* Handle all the breakpoints that were triggered */
> 	for (i = 0; i < HBP_NUM; ++i) {
> 		if (likely(!(dr6 & (DR_TRAP0 << i))))
> 			continue;
> 		/*
> 		 * Find the corresponding hw_breakpoint structure and
> 		 * invoke its triggered callback.
> 		 */
> 		if (i >= hbp_kernel_pos)
> 			bp = per_cpu(this_hbp_kernel[i], cpu);
> 		else {
> 			bp = current->thread.hbp[i];
> 			if (bp)
> 				rc = NOTIFY_DONE;
> 		}
> 
> 		/*
> 		 * Reset the 'i'th TRAP bit in dr6 to denote completion of
> 		 * exception handling
> 		 */
> 		(*dr6_p) &= ~(DR_TRAP0 << i);
> 		/*
> 		 * bp can be NULL due to lazy debug register switching
> 		 * or due to the delay between updates of hbp_kernel_pos
> 		 * and this_hbp_kernel.
> 		 */
> 		if (!bp)
> 			continue;
> 
> 		(bp->triggered)(bp, args->regs);
> 	}
> 	if (dr6 & (~DR_TRAP_BITS))
> 		rc = NOTIFY_DONE;
> 
> 	set_debugreg(dr7, 7);
> 	put_cpu_no_resched();
> 	return rc;
> }

This looks okay.

Alan Stern

