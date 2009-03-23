Return-Path: <linux-kernel-owner+w=401wt.eu-S1760279AbZCWRdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279AbZCWRdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 13:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbZCWRd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 13:33:26 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:51750 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757268AbZCWRdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 13:33:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAPxfx0lMQW1W/2dsb2JhbACBUNE2g34G
Date: Mon, 23 Mar 2009 13:33:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@google.com>,
       utrace-devel@redhat.com, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [RFC][PATCH 1/2] tracing/ftrace: syscall tracing infrastructure
Message-ID: <20090323173315.GG24084@Krystal>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <1236401580-5758-2-git-send-email-fweisbec@gmail.com> <49BEAA5A.4030708@redhat.com> <20090316201526.GE8393@nowhere> <49BEB8C4.2010606@redhat.com> <20090316214526.GA15119@Krystal> <20090317052442.GA32674@redhat.com> <20090317160029.GD10092@Krystal> <20090319103434.CBE69FC3AB@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090319103434.CBE69FC3AB@magilla.sf.frob.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:15:54 up 23 days, 13:42,  1 user,  load average: 0.86, 0.84,
	0.80
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

* Roland McGrath (roland@redhat.com) wrote:
> The utrace API itself is not a good fit for global tracing, since its
> purpose is tracing and control of individual user threads.  There is
> no reason to allocate its per-task data structures when you are going
> to treat all tasks the same anyway.  The points that I think are being
> missed are about the possibilities of overloading TIF_SYSCALL_TRACE.
> 
> It's true that ptrace uses TIF_SYSCALL_TRACE as a flag for whether you are
> in the middle of a PTRACE_SYSCALL, so it can be confused by setting it for 
> other purposes on a task that is also ptrace'd (but not with PTRACE_SYSCALL).
> Until we are able to do away with these parts of the old ptrace innards,
> you can't overload TIF_SYSCALL_TRACE without perturbing ptrace behavior.
> 

Yes, this is why I went with a different thread flag in my
TIF_KERNEL_TRACE implementation.

> The utrace code does not have this problem.  It keeps its own state bits,
> so for it, TIF_SYSCALL_TRACE means exactly "the task will call
> tracehook_report_syscall_*" and no more.  To use TIF_SYSCALL_TRACE for
> another purpose, just set it on all the tasks you like (and/or set it on
> new tasks in fork.c) and add your code (tracepoints, whatever) to
> tracehook_report_syscall_* alongside the calls there into utrace.  There is
> exactly one place in utrace code that clears TIF_SYSCALL_TRACE, and you
> just add "&& !global_syscall_tracing_enabled" to the condition there.  You
> don't need to bother clearing TIF_SYSCALL_TRACE on any task when you're
> done.  If your "global_syscall_tracing_enabled" (or whatever it is) is
> clear, each task will lazily fall into utrace at its next syscall
> entry/exit and then utrace will reset TIF_SYSCALL_TRACE when it finds no
> reason left to have it on.

I wonder how racy enabling system-wide tracing and disabling utrace
tracing on a specific thread would be ? How do you ensure that the
global tracing flag and per-thread flags are updated consistently ?

I also wonder about added performance impact caused by the
tracehook_report_syscall_* call. Ideally, system-wide syscall tracing
should call directly into a tracing callback, write to the trace
buffers, and return. With utrace, we would have to call an intermediate
callback, which would then call our tracer, then test utrace flags to
check if utrace should be called, and then return. Function calls are
quite costly nowadays :(

> 
> I'm not really going to delve into utrace internals in this thread.  Please
> raise those questions in review of the utrace patches when current code is
> actually posted, where they belong.  Here I'll just mention the relevant
> things that relate to the underlying issue you raised about synchronization.
> As thoroughly documented, utrace_set_events() is a quick, asynchronous call
> that itself makes no guarantees about how quickly a running task will start
> to report the newly-requested events.  For purposes relevant here, it just
> sets TIF_SYSCALL_TRACE and nothing else.  In utrace, if you want synchronous
> assurance that a task misses no events you ask for, then you must first use
> utrace_control (et al) to stop it and synchronize.  That is not something
> that makes much sense at all for a "flip on global tracing" operation, which
> is not generally especially synchronous with anything else.  If you want
> best effort that a task will pick up newly-requested events Real Soon Now,
> you can use utrace_control with just UTRACE_REPORT.  For purposes relevant
> here, this just does set_notify_resume().  That will send an IPI if the task
> is running, and then it will start noticing before it returns to user mode.
> So:
> 	set_tsk_thread_flag(task, TIF_SYSCALL_TRACE);
> 	set_notify_resume(task);
> is what I would expect you to do on each task if you want to quickly get it
> to start hitting tracehook_report_syscall_*.  (I'm a bit dubious that there
> is really any need to speed it up with set_notify_resume, but that's just me.)


Ideally, when we start tracing, setting the flag can be asynchronous,
but we need to have a way to figure out when tracing is actually active
(e.g. rcu quiescent state). So this can be seen as synchronous
activation. Stopping all tasks does not really make much sense for
system-wide tracing, especially if there are alternatives.

> 
> Finally, some broader points about TIF_SYSCALL_TRACE that I think
> have been overlooked.  The key special feature of TIF_SYSCALL_TRACE
> is that it gets you to a place where full user_regset access is
> available.  Debuggers need this to read (and write) the full user
> register state arbitrarily, which they also need to do user
> backtraces and the like.  If you do not need user_regset to work,
> then you don't need to be on this (slowest) code path.

LTTng had userspace backtraces on syscall entry and irq entry a while
ago, and this way particularly useful. But I agree than if this is not
needed, we should go for the warm path.

> 
> If you are only interested in reading syscall arguments and results
> (or even in changing syscall results in exit tracing) then you do
> not need user_regset and you do not need to take the slowest syscall
> path.  (If you are doing backtraces but already rely on full kernel
> stack unwinding to do it, you also do not need user_regset.)  From
> anywhere inside the kernel, you can use the asm/syscall.h calls to
> read syscall args, whichever entry path the task took.
> 
> The other mechanism to hook into every syscall entry/exit is
> TIF_SYSCALL_AUDIT.  On some machines (like x86), this takes a third,
> "warm" code path that is faster than the TIF_SYSCALL_TRACE path
> (though obviously still off the fastest direct code path).  It can
> be faster precisely because it doesn't need to allow for user_regset
> access, nor for modification of syscall arguments in entry tracing.
> For normal read-only tracing of just the actual syscall details,
> it has all you need.
> 
> Unfortunately the arch code all looks like:
> 
> 	if (unlikely(current->audit_context))
> 		 audit_syscall_{entry,exit}(...);
> 
> So we need to change that to:
> 
> 	if (unlikely(test_thread_flag(TIF_SYSCALL_AUDIT)))
> 		 audit_syscall_{entry,exit}(...);
> 
> But that is pretty easy to get right, even doing it blind on arch's
> you can't test.  Far better than adding new asm hackery for each arch
> that's almost identical to TIF_SYSCALL_TRACE or TIF_SYSCALL_AUDIT (and
> finding out that some are fresh out of TIF bits in the range that
> their asm code can handle).
> 
> TIF_SYSCALL_AUDIT is only set when allocating audit_context, and its
> paths already have !context tests so overloading is harmless today.
> (Whereas with TIF_SYSCALL_TRACE, you have to wait for later ptrace
> cleanups or write off using ptrace simultaneously.)
> 
> Then you can do the lazy disable in audit_syscall_{entry,exit} with:
> 
> 	if (unlikely(!context)) {
> 		if (unlikely(!global_syscall_tracing_enabled))
> 			clear_thread_flag(TIF_SYSCALL_AUDIT);
> 		return;
> 	}
> 
> Plus add there your tracepoint or whatnot.
> 
> Unless you really plan to use user_regset in your tracepoints, then
> I think this is a better plan for global syscall tracing than either
> fiddling with TIF_SYSCALL_TRACE or adding new arch asm requirements.
> (IMHO, the latter is the worst idea on the table.)
> 

Thanks for this thorough review of TIF flags. Hrm, racing with other
pieces of infrastructure is never fun, and given we might want to save
the userspace stack in some probes, I think it could be a good idea to
go with our own flag.

Mathieu

> 
> Thanks,
> Roland

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
