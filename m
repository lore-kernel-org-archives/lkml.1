Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbZETOER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbZETOER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 10:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbZETOEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 10:04:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59850 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752557AbZETOEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 10:04:08 -0400
Date: Wed, 20 May 2009 10:04:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Patch 1/2] Improvements and minor fixes to HW Breakpoint
 interface
In-Reply-To: <20090520105535.GA17181@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0905200951030.2914-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009, K.Prasad wrote:

> --- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/hw_breakpoint.c
> +++ linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
> @@ -296,6 +296,19 @@ void arch_flush_thread_hw_breakpoint(str
>  
>  /*
>   * Handle debug exception notifications.
> + *
> + * Return value is either NOTIFY_STOP or NOTIFY_DONE as explained below.
> + *
> + * NOTIFY_DONE returned if one of the following conditions is true.
> + * i) When the causative address is from user-space and the exception
> + * is a valid one i.e. not triggered a result of lazy debug register
--------------------^----^  missing ',' characters
---------------------------------------^ missing "as"

> + * switching
> + * ii) When there are more bits than trap<n> set in DR6 register (such
> + * as BD, BS or BT) indicating that more than one debug condition is
> + * met and requires some more action in do_debug().
> + *
> + * NOTIFY_STOP returned for all other cases
> + *
>   */
>  int __kprobes hw_breakpoint_handler(struct die_args *args)
>  {
> @@ -346,8 +359,10 @@ int __kprobes hw_breakpoint_handler(stru
>  		 * or due to the delay between updates of hbp_kernel_pos
>  		 * and this_hbp_kernel.
>  		 */
> -		if (!bp)
> +		if (!bp) {
> +			rc = NOTIFY_STOP;
>  			continue;
> +		}
>  
>  		(bp->triggered)(bp, args->regs);

This is the same mistake as before.  If rc had previously been set to 
NOTIFY_DONE then you will unconditionally change it back to 
NOTIFY_STOP.  You should make the code do what the comment says, set rc
to NOTIFY_DONE when a non-NULL user breakpoint occurs:

		if (i >= hbp_kernel_pos) {
			bp = per_cpu(this_hbp_kernel[i], cpu);
		} else {
			bp = current->thread.hbp[i];
			if (bp)
				rc = NOTIFY_DONE;
		}
		/*
		 * bp can be NULL due to lazy debug register switching
		 * or due to the delay between updates of hbp_kernel_pos
		 * and this_hbp_kernel.
		 */
		if (!bp)
			continue;

		(bp->triggered)(bp, args->regs);


The rest of the changes are okay.

Alan Stern

