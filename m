Return-Path: <linux-kernel-owner+w=401wt.eu-S1752480AbZH1TGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbZH1TGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZH1TGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:06:07 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:48656 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZH1TGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:06:05 -0400
Date: Sat, 29 Aug 2009 00:36:01 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch 3/3] HW-BKPT: Enable/disable the breakpoints when still
	registered
Message-ID: <20090828190601.GA10501@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090826200840.118253312@linux.vnet.ibm.com> <20090826201506.GD12766@in.ibm.com> <20090827055507.GA7756@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827055507.GA7756@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 11:25:08AM +0530, Ananth N Mavinakayanahalli wrote:
> On Thu, Aug 27, 2009 at 01:45:06AM +0530, K.Prasad wrote:
> 
> ...
> 
> >  struct hw_breakpoint {
> > +	/*
> > +	 * Denotes if a breakpoint is currently enabled in physical debug
> > +	 * registers. Not to be set directly by the end-user. Must be
> > +	 * operated through enable_hw_breakpoint() API only.
> > +	 */
> > +	unsigned int enabled;
> 
> bool?
> 
> ...
> 

A 'bool' data-type doesn't really provide advantages in terms of the
bytes consumed as far as I can see...leaving it as 'unsigned int' would
allow any positive integer to be considered as a 'enable' request.

However considering the change due to the second comment, and for the
fact that the data-type is more intuitive I'll change them to 'bool'.

> > +void enable_hw_breakpoint(struct hw_breakpoint *bp, struct task_struct *tsk,
> > +							unsigned int enabled)
> > +{
> > +	int i;
> > +	struct thread_struct *thread = &(tsk->thread);
> > +
> > +	spin_lock_bh(&hw_breakpoint_lock);
> > +
> > +	bp->enabled = enabled;
> > +	/* Enable/Disable the kernel-space breakpoint */
> > +	if (!tsk) {
> > +		if (cpumask_test_cpu(smp_processor_id(), bp->cpumask))
> > +			arch_update_kernel_hw_breakpoint(NULL);
> > +		smp_call_function_many(bp->cpumask,
> > +				arch_update_kernel_hw_breakpoint, NULL, 1);
> > +		goto out;
> > +	}
> > +
> > +	/* Enable/disable the user-space breakpoint */
> > +	for (i = 0; i < hbp_kernel_pos; i++) {
> > +		if (thread->hbp[i] != bp)
> > +			continue;
> > +		arch_update_user_hw_breakpoint(i, tsk);
> > +		if (tsk == current)
> > +			arch_install_thread_hw_breakpoint(tsk);
> > +		break;
> > +	}
> > +out:
> > +	spin_unlock_bh(&hw_breakpoint_lock);
> > +}
> > +EXPORT_SYMBOL_GPL(enable_hw_breakpoint);
> 
> Not sure if its cleaner to have enable_hw_breakpoint() and
> disable_hw_breakpoint() rather than one overloaded call.
> 

The plan was to have two separate interfaces at first, but then it
turned out that the code was largely similar...tempting them to be
clubbed together.

But after looking at 'struct pmu' (whose callbacks are intended to map
to these interfaces), I see that two distinct interfaces would be
better (there's a enable/disable callback in struct pmu too).

I shall post a new version of this patch including more changes.

Thanks,
K.Prasad

