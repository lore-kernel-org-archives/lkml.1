Return-Path: <linux-kernel-owner+w=401wt.eu-S1751026AbZH0FzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751026AbZH0FzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 01:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZH0FzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 01:55:15 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48002 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbZH0FzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 01:55:14 -0400
Date: Thu, 27 Aug 2009 11:25:08 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch 3/3] HW-BKPT: Enable/disable the breakpoints when still
	registered
Message-ID: <20090827055507.GA7756@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20090826200840.118253312@linux.vnet.ibm.com> <20090826201506.GD12766@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826201506.GD12766@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 01:45:06AM +0530, K.Prasad wrote:

...

>  struct hw_breakpoint {
> +	/*
> +	 * Denotes if a breakpoint is currently enabled in physical debug
> +	 * registers. Not to be set directly by the end-user. Must be
> +	 * operated through enable_hw_breakpoint() API only.
> +	 */
> +	unsigned int enabled;

bool?

...

> +void enable_hw_breakpoint(struct hw_breakpoint *bp, struct task_struct *tsk,
> +							unsigned int enabled)
> +{
> +	int i;
> +	struct thread_struct *thread = &(tsk->thread);
> +
> +	spin_lock_bh(&hw_breakpoint_lock);
> +
> +	bp->enabled = enabled;
> +	/* Enable/Disable the kernel-space breakpoint */
> +	if (!tsk) {
> +		if (cpumask_test_cpu(smp_processor_id(), bp->cpumask))
> +			arch_update_kernel_hw_breakpoint(NULL);
> +		smp_call_function_many(bp->cpumask,
> +				arch_update_kernel_hw_breakpoint, NULL, 1);
> +		goto out;
> +	}
> +
> +	/* Enable/disable the user-space breakpoint */
> +	for (i = 0; i < hbp_kernel_pos; i++) {
> +		if (thread->hbp[i] != bp)
> +			continue;
> +		arch_update_user_hw_breakpoint(i, tsk);
> +		if (tsk == current)
> +			arch_install_thread_hw_breakpoint(tsk);
> +		break;
> +	}
> +out:
> +	spin_unlock_bh(&hw_breakpoint_lock);
> +}
> +EXPORT_SYMBOL_GPL(enable_hw_breakpoint);

Not sure if its cleaner to have enable_hw_breakpoint() and
disable_hw_breakpoint() rather than one overloaded call.

Ananth
