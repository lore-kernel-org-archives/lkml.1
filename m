Return-Path: <linux-kernel-owner+w=401wt.eu-S1758394AbZE0CqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394AbZE0CqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 22:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbZE0CqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 22:46:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbZE0CqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 22:46:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 8/X] ptrace: introduce ptrace_tracer() helper
In-Reply-To: Oleg Nesterov's message of  Tuesday, 26 May 2009 00:39:32 +0200 <20090525223932.GA11508@redhat.com>
References: <20090525000016.GA2239@redhat.com>
	<20090525215903.GA9113@redhat.com>
	<20090525223932.GA11508@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090527024540.177FAFC36B@magilla.sf.frob.com>
Date: Tue, 26 May 2009 19:45:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Introduce ptrace_tracer() (or suggest a better name) to simplify/cleanup
> the code which needs the tracer and checks task_ptrace(). From now nobody
> else uses ->pt_tracer except ptrace_link/ptrace_unlink.

There is nothing really wrong with this.  But I think that this stuff will
get sufficiently reworked again differently later on if it's converted to
use utrace that this incremental cleanup may not really help any.

> Question. Note that ptrace_tracer() is equal to tracehook_tracer_task().
> But I do not understand the future plans for tracehook_tracer_task().
> Should we just use tracehook_tracer_task() ? If yes, how
> ptrace_reparented() can use this helper?

It seems likely that we will rework tracehook_tracer_task() later.
It has three kinds of callers:

1. task_state() for "TracerPid:" line.
   It remains to be seen if we want to make some hookified way that might
   ever have a non-ptrace tracer supply the value here.  This was the main
   original expectation of what tracehook_tracer_task() would do.
2. check_mem_permission()
   I've already suggested to you that I think we want to swallow this
   use as part of the clean-up/replacement of ptrace_may_access().
3. SELinux: selinux_bprm_set_creds(), selinux_setprocattr()
   It makes sure that "PROCESS PTRACE" tracer->tracee avc checks can
   inhibit the transition (exec/setprocattr call).

For each of these, we have yet to hash out whether we will only ever want a
cleaned-up ptrace support here, or if in a future generalized tracing setup
like utrace these should be hooks that some non-ptrace kind of tracer
facility could also supply.  Figuring any piece of all that out is way
beyond the simple data structure cleanup phase.  I don't think we want to
get into any of that quite yet.

> +	parent = ptrace_tracer(tsk);
> +	if (likely(!parent))
>  		parent = tsk->real_parent;

This likely() doesn't buy much anyway, I'd just write the shorter:

	parent = ptrace_tracer(task) ?: tsk->real_parent;

>  static inline int may_ptrace_stop(void)
>  {
> -	if (!likely(task_ptrace(current)))
> +	struct task_struct *tracer = ptrace_tracer(current);
> +
> +	if (!likely(tracer))
>  		return 0;

Is there a particular rationale to checking ptrace_tracer() != NULL vs
task_ptrace() != 0?  Or is it just that they should already be guaranteed
synonymous, and here you have use for the tracer pointer a few lines later?

> +	pid = task_pid_vnr(tracer);
> +	uid = task_uid(tracer);
>  
>  	ptrace_signal_deliver(regs, cookie);
>  
> @@ -1779,8 +1785,8 @@ static int ptrace_signal(int signr, sigi
>  		info->si_signo = signr;
>  		info->si_errno = 0;
>  		info->si_code = SI_USER;
> -		info->si_pid = task_pid_vnr(current->ptrace_task->pt_tracer);
> -		info->si_uid = task_uid(current->ptrace_task->pt_tracer);
> +		info->si_pid = pid;
> +		info->si_uid = uid;

I think the different clean-up I suggested is better for this.  (Move that
logic to resume-time in the tracer context.)  It's an inconsequential nit,
but it feels a little wrong e.g. that you take task_uid(tracer) before the
stop, but the tracer could call setuid() before it does PTRACE_CONT.  The
PTRACE_CONT (or whatever) is the "signal generation event", so that's the
point at which the si_uid value being determined makes most sense to me
because it parallels what a normal signal generation does.


Thanks,
Roland
