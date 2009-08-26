Return-Path: <linux-kernel-owner+w=401wt.eu-S1751218AbZHZEJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbZHZEJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 00:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbZHZEJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 00:09:52 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:47074 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZHZEJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 00:09:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L9p3iQ0kEuWidusffaySII0Fj9vvGZExVMB1Gi/YqEoHldRWuQ2aMQm8jMCCE0THNd
         KQKPtmDJdE3B1LF/so1DCWMYYaXvOqDjpp+DVbsk5Isan1dRz+XQmvYnaJFgywQ8Bg+V
         6OjMS8oQ0CAtnni1uASa0MlfrzW32uUFgcVFQ=
Date: Wed, 26 Aug 2009 06:09:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch 2/2] HW-BKPT: Allow kernel breakpoints to be modified
	through a new API
Message-ID: <20090826040917.GC6245@nowhere>
References: <20090825201310.268198183@linux.vnet.ibm.com> <20090825202159.GC1166@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825202159.GC1166@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 01:51:59AM +0530, K.Prasad wrote:
> Introduce modify_kernel_hw_breakpoint() API that can quickly change the
> characteristics (such as address, length, type but not cpumask) of a
> kernel-space breakpoint without having to unregister first and then
> re-register it.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>


Hmm... You will hate me but... While looking more closely
at the pmu management in perf, I realize I've made a mistake by requesting
this functionnality.

struct pmu are built of some callbacks, especially enable() and disable().
These callbacks are called by perf when a task/group is sched in/out.

The breakpoint API then doesn't need to be able to live-modify breakpoint
properties.
Instead, what we need is a way to disarm/rearm a bp without actually unregister
it (we don't want to lose its slot until it gets rearmed).

So eventually we need two callbacks: 

- disable_kernel_breakpoint() that just disarm the breakpoint in the
  hardware level without unregistering it in the software level.
  When a profiled task group is sched out, the counter becomes
  inactive, waiting to be sched in later, that's why the bp
  must still be registered at this time (but inactive).

- enable_kernel_breakpoint() that rearms it

Your first patch that handles the per cpu breakpoints + these two callbacks
are the only thing we need for the perf integration.

Once we get that, it's up to perf to handle the enable/disable for
its own needs. Of course we already have the per task breakpoints
that could handle that, but it looks easier and better to let perf
decide whenever it needs the pmu to be bound or not.

So, I'm sorry but we won't need this one patch (but we still need
the first). And you can also forget about the breakpoint inheritance
across clone() calls, hardware register rewrite on schedule() only while
switching to separate task groups (although that could enhance/optimize
this API).
These things are already handled by perf.

I should have looked more closely into the PMUs before requesting
you this patch. My bad...

Thanks,
Frederic.

> ---
>  include/asm-generic/hw_breakpoint.h |    2 +
>  kernel/hw_breakpoint.c              |   49 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 51 insertions(+)
> 
> Index: linux-2.6-tip.hbkpt/include/asm-generic/hw_breakpoint.h
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/include/asm-generic/hw_breakpoint.h
> +++ linux-2.6-tip.hbkpt/include/asm-generic/hw_breakpoint.h
> @@ -133,6 +133,8 @@ extern void unregister_user_hw_breakpoin
>   * Kernel breakpoints are not associated with any particular thread.
>   */
>  extern int register_kernel_hw_breakpoint(struct hw_breakpoint *bp);
> +extern int modify_kernel_hw_breakpoint(struct hw_breakpoint *old_bp,
> +					struct hw_breakpoint *new_bp);
>  extern void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp);
>  
>  extern unsigned int hbp_kernel_pos;
> Index: linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/kernel/hw_breakpoint.c
> +++ linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
> @@ -362,6 +362,55 @@ err_ret:
>  }
>  EXPORT_SYMBOL_GPL(register_kernel_hw_breakpoint);
>  
> +/**
> + * modify_kernel_hw_breakpoint - modify characteristics of a previously registered breakpoint request
> + * @old_bp: pointer to the registered breakpoint structure
> + * @new_bp: pointer to the breakpoint structure that replaces @old_bp
> + *
> + */
> +int modify_kernel_hw_breakpoint(struct hw_breakpoint *old_bp,
> +				   struct hw_breakpoint *new_bp)
> +{
> +	int i, rc;
> +	unsigned int cpu;
> +	const cpumask_t *new_cpumask = new_bp->cpumask;
> +
> +	/* Default to ALL CPUs if cpumask is not specified */
> +	if (!new_cpumask)
> +		new_cpumask = new_bp->cpumask = cpu_possible_mask;
> +	/*
> +	 * The user cannot modify the cpumask of the registered breakpoint
> +	 * It requires non-trivial amount of code and new data-structures to
> +	 * allow a change in cpumask value. The user must instead 'unregister'
> +	 * and re-register a new breakpoint if 'cpumask' should be changed
> +	 */
> +	if (!cpumask_equal(old_bp->cpumask, new_cpumask))
> +		return -EINVAL;
> +
> +	rc = arch_validate_hwbkpt_settings(new_bp, NULL);
> +	if (rc)
> +		return rc;
> +
> +	spin_lock_bh(&hw_breakpoint_lock);
> +	for_each_cpu(cpu, new_cpumask) {
> +		for (i = HBP_NUM-1; i >= hbp_kernel_pos; i--) {
> +			if (per_cpu(this_hbp_kernel[i], cpu) == old_bp) {
> +				per_cpu(this_hbp_kernel[i], cpu) = new_bp;
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (cpumask_test_cpu(smp_processor_id(), new_cpumask))
> +		arch_update_kernel_hw_breakpoint(NULL);
> +	smp_call_function_many(new_cpumask,
> +				arch_update_kernel_hw_breakpoint, NULL, 1);
> +
> +	spin_unlock_bh(&hw_breakpoint_lock);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(modify_kernel_hw_breakpoint);
> +
>  /* Removes breakpoint structure from the per-cpu breakpoint data-structure */
>  static void remove_each_cpu_kernel_hbp(void *bp_param)
>  {
> 

