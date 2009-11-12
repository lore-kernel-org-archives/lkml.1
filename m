Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbZKLPTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbZKLPTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbZKLPTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:19:53 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:24647 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbZKLPTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:19:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DW7XrCAHcM5E09bW19MDMdMi79m0wnLosxsJ+DbsXi7JVT53+E2fp4VPNjkm1wAzki
         oqqyRSdym1+zvU/3Zv814RIQBLJLx7MVviB/DYNlfdGXdLxpBdtBh4uyOSJvpgoIjAhI
         s/1+Ps1Jnse85m+2T+vl8ZNQlNvaUOJnCoSJw=
Date: Thu, 12 Nov 2009 16:19:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 5/7] hw-breakpoints: Rewrite the hw-breakpoints layer
	on top of perf events
Message-ID: <20091112151947.GC5237@nowhere>
References: <1257474542-6648-1-git-send-email-fweisbec@gmail.com> <1257474542-6648-6-git-send-email-fweisbec@gmail.com> <20091108173107.GB4465@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108173107.GB4465@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 11:01:07PM +0530, K.Prasad wrote:
> >  #include <asm/smpboot_hooks.h>
> > @@ -328,7 +327,6 @@ notrace static void __cpuinit start_secondary(void *unused)
> >  	x86_cpuinit.setup_percpu_clockev();
> > 
> >  	wmb();
> > -	load_debug_registers();
> >  	cpu_idle();
> >  }
> >
> 
> So, will the breakpoint values be stored in per-cpu variables and be
> restored when a cpu (from the list of for_each_possible_cpu) eventually
> turns online due to cpu-hotplug or resume from hibernate (as originally
> done by load_debug_registers())?



Yep. Perf has callbacks that handle that.


> 
> A few more observations....
> 
> int reserve_bp_slot(struct perf_event *bp)
> {
> ...
> ....
> 	if (!bp->attr.pinned) {
> 		/*
> 		 * If there are already flexible counters here,
> 		 * there is at least one slot reserved for all
> 		 * of them. Just join the party.
> 		 *
> 		 * Otherwise, check there is at least one free slot
> 		 */
> 		if (!slots.flexible && slots.pinned == HBP_NUM) {
> 			ret = -ENOSPC;
> 			goto end;
> 		}
> 
> 	/* Flexible counters need to keep at least one slot */
> 	} else if (slots.pinned + (!!slots.flexible) == HBP_NUM) {
> 		ret = -ENOSPC;
> 		goto end;
> 	}
> ..
> ...
> }
> 
> It appears that you're reserving one slot for the non-pinned breakpoint
> requests, which I'm afraid wouldn't play well with PPC64 (having one
> DABR).



I don't understand what you mean. PPC64 has only one DABR, or...?



> Even with x86, I can't understand why we should allow the use of
> only 3 registers for ptrace requests (which are all pinned) on every
> system even if perf-events will never be used on them.
> 


Oh I see.

I'm not reserving any register for non-pinned events if none are
registered.
The fact is non-pinned registers can be round-robined. So we need
at least register for all of them.
So the constraint here is: if I want to register a non-pinned breakpoint,
I need to check if we have a free register left, in this case, reserve it.

But if we don't have any non-pinned breakpoint in use, the
four registers are all usable for ptrace or any other
pinned breakpoints.



> int __register_perf_hw_breakpoint(struct perf_event *bp)
> {
> ..
> ...
> 	if (!bp->attr.disabled)
> 		ret = arch_validate_hwbkpt_settings(bp, bp->ctx->task);
> 
> 	return ret;
> }
> 
> Can't the arch_validate_() check be done unconditionally?


Perhaps, yeah. I did that because when ptrace writes in an address
register, it creates a breakpoint stub, registered but disabled until
it is activated through a write in dr7. This is to reserve the
breakpoint until we activate it.

But now I'm not sure this is neede. If we register the
breakpoint later, only when dr7 is set to enable it, even if we
refuse the request, gdb handles it and reports the error.


> struct perf_event *
> modify_user_hw_breakpoint(struct perf_event *bp,
> 			  unsigned long addr,
> 			  int len,
> 			  int type,
> 			  perf_callback_t triggered,
> 			  struct task_struct *tsk,
> 			  bool active)
> {
> 	/*
> 	 * FIXME: do it without unregistering
> 	 * - We don't want to lose our slot
> 	 * - If the new bp is incorrect, don't lose the older one
> 	 */
> 	unregister_hw_breakpoint(bp);
> 
> 	return register_user_hw_breakpoint(addr, len, type, triggered,
> 					   tsk, active);
> }
> 
> Given that modify_user_hw_breakpoint() is used by ptrace, there's a risk
> of breaking/changing ptrace's behaviour i.e. new ptrace failure
> scenarios (while modifying DR0-DR3) which may not be acceptable to
> user-space applications. I presume that you intend to address the FIXME
> during the next few iterations itself...


Sure.


> 
> void arch_uninstall_hw_breakpoint(struct perf_event *bp)
> {
> ...
> ....
> 	dr7 = &__get_cpu_var(dr7);
> 	*dr7 &= ~encode_dr7(i, info->len, info->type);
> 
> 	set_debugreg(*dr7, 7);
> }
> 
> The &= ~encode_dr7 would unset the GE flag in DR7 (encoded as
> DR_GLOBAL_SLOWDOWN) which, I think is unintended.



Oh right. I'll fix this.


 
> struct pmu perf_ops_bp = {
>         .enable         = arch_install_hw_breakpoint,
>         .disable        = arch_uninstall_hw_breakpoint,
>         .read           = hw_breakpoint_pmu_read,
>         .unthrottle     = hw_breakpoint_pmu_unthrottle
> };
> 
> So the enable/disable points to those routines that clear the debug
> register off its breakpoint values but still don't seem to release the
> slot (even temporarily)....i.e. nr_bp_flexible is unchanged


nr_bp_flexible and others are just logical constructs that keep
track of the breakpoints registered (ie: that can be scheduled in
at any time).

But they have nothing related to the registers themselves.
The registers are used by the enable/disable callback.
On enable time, we seek a free register and bind to it,
on disable, we release the register we were using.
All that is handled by perf internally that schedules the
events depending on the contexts.


> Will perf-events automatically re-use the disabled slot for breakpoint
> requests from other perf-event instances?


Yeah.
We have a per cpu array[4] of perf events, those keep
track of the breakpoints in use.
The below is called when a breakpoint is scheduled out
by perf:

void arch_uninstall_hw_breakpoint(struct perf_event *bp)
{
	[...]
	for (i = 0; i < HBP_NUM; i++) {
		struct perf_event **slot = &__get_cpu_var(bp_per_reg[i]);

		if (*slot == bp) {
			*slot = NULL;	<---- here, we release the slot
			break;
		}
	}
	[...]
}

And when it is scheduled in:

int arch_install_hw_breakpoint(struct perf_event *bp)
{
	for (i = 0; i < HBP_NUM; i++) {
		struct perf_event **slot = &__get_cpu_var(bp_per_reg[i]);

		if (!*slot) {
			*slot = bp; <-- here we bind to a free slot
			break;
		}
	}
}


Thanks for your reviews!

