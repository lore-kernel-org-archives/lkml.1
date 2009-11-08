Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZKHRbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZKHRbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbZKHRbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:31:20 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:48039 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbZKHRbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:31:19 -0500
Date: Sun, 8 Nov 2009 23:01:07 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Message-ID: <20091108173107.GB4465@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1257474542-6648-1-git-send-email-fweisbec@gmail.com> <1257474542-6648-6-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257474542-6648-6-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  #include <asm/smpboot_hooks.h>
> @@ -328,7 +327,6 @@ notrace static void __cpuinit start_secondary(void *unused)
>  	x86_cpuinit.setup_percpu_clockev();
> 
>  	wmb();
> -	load_debug_registers();
>  	cpu_idle();
>  }
>

So, will the breakpoint values be stored in per-cpu variables and be
restored when a cpu (from the list of for_each_possible_cpu) eventually
turns online due to cpu-hotplug or resume from hibernate (as originally
done by load_debug_registers())?

A few more observations....

int reserve_bp_slot(struct perf_event *bp)
{
...
....
	if (!bp->attr.pinned) {
		/*
		 * If there are already flexible counters here,
		 * there is at least one slot reserved for all
		 * of them. Just join the party.
		 *
		 * Otherwise, check there is at least one free slot
		 */
		if (!slots.flexible && slots.pinned == HBP_NUM) {
			ret = -ENOSPC;
			goto end;
		}

	/* Flexible counters need to keep at least one slot */
	} else if (slots.pinned + (!!slots.flexible) == HBP_NUM) {
		ret = -ENOSPC;
		goto end;
	}
..
...
}

It appears that you're reserving one slot for the non-pinned breakpoint
requests, which I'm afraid wouldn't play well with PPC64 (having one
DABR). Even with x86, I can't understand why we should allow the use of
only 3 registers for ptrace requests (which are all pinned) on every
system even if perf-events will never be used on them.


int __register_perf_hw_breakpoint(struct perf_event *bp)
{
..
...
	if (!bp->attr.disabled)
		ret = arch_validate_hwbkpt_settings(bp, bp->ctx->task);

	return ret;
}

Can't the arch_validate_() check be done unconditionally?

struct perf_event *
modify_user_hw_breakpoint(struct perf_event *bp,
			  unsigned long addr,
			  int len,
			  int type,
			  perf_callback_t triggered,
			  struct task_struct *tsk,
			  bool active)
{
	/*
	 * FIXME: do it without unregistering
	 * - We don't want to lose our slot
	 * - If the new bp is incorrect, don't lose the older one
	 */
	unregister_hw_breakpoint(bp);

	return register_user_hw_breakpoint(addr, len, type, triggered,
					   tsk, active);
}

Given that modify_user_hw_breakpoint() is used by ptrace, there's a risk
of breaking/changing ptrace's behaviour i.e. new ptrace failure
scenarios (while modifying DR0-DR3) which may not be acceptable to
user-space applications. I presume that you intend to address the FIXME
during the next few iterations itself...

void arch_uninstall_hw_breakpoint(struct perf_event *bp)
{
...
....
	dr7 = &__get_cpu_var(dr7);
	*dr7 &= ~encode_dr7(i, info->len, info->type);

	set_debugreg(*dr7, 7);
}

The &= ~encode_dr7 would unset the GE flag in DR7 (encoded as
DR_GLOBAL_SLOWDOWN) which, I think is unintended.

struct pmu perf_ops_bp = {
        .enable         = arch_install_hw_breakpoint,
        .disable        = arch_uninstall_hw_breakpoint,
        .read           = hw_breakpoint_pmu_read,
        .unthrottle     = hw_breakpoint_pmu_unthrottle
};

So the enable/disable points to those routines that clear the debug
register off its breakpoint values but still don't seem to release the
slot (even temporarily)....i.e. nr_bp_flexible is unchanged
Will perf-events automatically re-use the disabled slot for breakpoint
requests from other perf-event instances?

Thanks,
K.Prasad

