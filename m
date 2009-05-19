Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbZESSJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbZESSJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 14:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZESSJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 14:09:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56456 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754030AbZESSJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 14:09:12 -0400
Date: Tue, 19 May 2009 14:09:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Patch 1/2] Improvements and minor fixes to HW Breakpoint
 interface
In-Reply-To: <20090519162459.GB26009@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0905191351380.10557-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009, K.Prasad wrote:

> This patch brings a couple of changes to the HW Breakpoint infrastructure:
> 
> - Set/clear TIF_DEBUG task flag in <un>register_user_hw_breakpoint()
>   instead of being done by users of this interface (such as ptrace).
> 
> - Modify return code of hw_breakpoint_handler() to NOTIFY_STOP if
>   triggered due to lazy debug register switching.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  arch/x86/kernel/hw_breakpoint.c |    4 +++-
>  arch/x86/kernel/ptrace.c        |    4 +---
>  kernel/hw_breakpoint.c          |   16 +++++++++++++---
>  3 files changed, 17 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/hw_breakpoint.c
> +++ linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
> @@ -346,8 +346,10 @@ int __kprobes hw_breakpoint_handler(stru
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
>  		/*

This doesn't look right.  You want to return NOTIFY_DONE if any
breakpoints were triggered or any non-breakpoint bits were set in DR6,
right?  Otherwise return NOTIFY_STOP.  So this code should be:

		if (!bp)
			continue;

		rc = NOTIFY_DONE;
		(bp->triggered)(bp, args->regs);

and take out the "rc = NOTIFY_DONE" line in the i < hbp_kernel_pos 
case earlier.

It also would be a good idea to add a comment near the start of the
function explaining the return value (just paraphrase what I wrote
above).


> Index: linux-2.6-tip.hbkpt/arch/x86/kernel/ptrace.c
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/ptrace.c
> +++ linux-2.6-tip.hbkpt/arch/x86/kernel/ptrace.c
> @@ -530,9 +530,7 @@ restore:
>  				bp->info.len = len;
>  				bp->info.type = type;
>  				rc = register_user_hw_breakpoint(tsk, bp);
> -				if (!rc)
> -					set_tsk_thread_flag(tsk, TIF_DEBUG);
> -				else
> +				if (rc)
>  					kfree(bp);
>  			}
>  		} else
> Index: linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/kernel/hw_breakpoint.c
> +++ linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
> @@ -233,6 +233,8 @@ int register_user_hw_breakpoint(struct t
>  			break;
>  		}
>  	}
> +	if (!rc)
> +		set_tsk_thread_flag(tsk, TIF_DEBUG);
>  
>  	spin_unlock_bh(&hw_breakpoint_lock);
>  	return rc;
> @@ -272,15 +274,23 @@ void unregister_user_hw_breakpoint(struc
>  						struct hw_breakpoint *bp)
>  {
>  	struct thread_struct *thread = &(tsk->thread);
> -	int i;
> +	int i, pos = -1, clear_tsk_debug_counter = 0;

I think "hbp_counter" would be a better name.  It's up to you.

>  
>  	spin_lock_bh(&hw_breakpoint_lock);
>  	for (i = 0; i < hbp_kernel_pos; i++) {
> +		if (thread->hbp[i])
> +			clear_tsk_debug_counter++;
>  		if (bp == thread->hbp[i]) {
> -			__unregister_user_hw_breakpoint(i, tsk);
> -			break;
> +			clear_tsk_debug_counter--;
> +			pos = i;
>  		}
>  	}
> +	if (pos >= 0)
> +		__unregister_user_hw_breakpoint(pos, tsk);
> +
> +	if (!clear_tsk_debug_counter)
> +		clear_tsk_thread_flag(tsk, TIF_DEBUG);

This logic could be rearranged a little:

	for (i = 0; i < hbp_kernel_pos; i++) {
		if (thread->hbp[i])
			clear_tsk_debug_counter++;
		if (bp == thread->hbp[i])
			pos = i;
	}
	if (pos >= 0) {
		__unregister_user_hw_breakpoint(pos, tsk);
		clear_tsk_debug_counter--;
	}
	if (!clear_tsk_debug_counter)
		clear_tsk_thread_flag(tsk, TIF_DEBUG);

Not a big deal; this way is a little more robust in case two 
thread->hbp[] entries somehow contain the same pointer.

> +
>  	spin_unlock_bh(&hw_breakpoint_lock);
>  }
>  EXPORT_SYMBOL_GPL(unregister_user_hw_breakpoint);

Alan Stern

