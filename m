Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbZCSKhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbZCSKhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 06:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZCSKho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 06:37:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbZCSKhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 06:37:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@google.com>,
       utrace-devel@redhat.com, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [RFC][PATCH 1/2] tracing/ftrace: syscall tracing infrastructure
In-Reply-To: Mathieu Desnoyers's message of  Tuesday, 17 March 2009 12:00:29 -0400 <20090317160029.GD10092@Krystal>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com>
	<1236401580-5758-2-git-send-email-fweisbec@gmail.com>
	<49BEAA5A.4030708@redhat.com>
	<20090316201526.GE8393@nowhere>
	<49BEB8C4.2010606@redhat.com>
	<20090316214526.GA15119@Krystal>
	<20090317052442.GA32674@redhat.com>
	<20090317160029.GD10092@Krystal>
X-Windows: even not doing anything would have been better than nothing.
Message-Id: <20090319103434.CBE69FC3AB@magilla.sf.frob.com>
Date: Thu, 19 Mar 2009 03:34:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The utrace API itself is not a good fit for global tracing, since its
purpose is tracing and control of individual user threads.  There is
no reason to allocate its per-task data structures when you are going
to treat all tasks the same anyway.  The points that I think are being
missed are about the possibilities of overloading TIF_SYSCALL_TRACE.

It's true that ptrace uses TIF_SYSCALL_TRACE as a flag for whether you are
in the middle of a PTRACE_SYSCALL, so it can be confused by setting it for 
other purposes on a task that is also ptrace'd (but not with PTRACE_SYSCALL).
Until we are able to do away with these parts of the old ptrace innards,
you can't overload TIF_SYSCALL_TRACE without perturbing ptrace behavior.

The utrace code does not have this problem.  It keeps its own state bits,
so for it, TIF_SYSCALL_TRACE means exactly "the task will call
tracehook_report_syscall_*" and no more.  To use TIF_SYSCALL_TRACE for
another purpose, just set it on all the tasks you like (and/or set it on
new tasks in fork.c) and add your code (tracepoints, whatever) to
tracehook_report_syscall_* alongside the calls there into utrace.  There is
exactly one place in utrace code that clears TIF_SYSCALL_TRACE, and you
just add "&& !global_syscall_tracing_enabled" to the condition there.  You
don't need to bother clearing TIF_SYSCALL_TRACE on any task when you're
done.  If your "global_syscall_tracing_enabled" (or whatever it is) is
clear, each task will lazily fall into utrace at its next syscall
entry/exit and then utrace will reset TIF_SYSCALL_TRACE when it finds no
reason left to have it on.

I'm not really going to delve into utrace internals in this thread.  Please
raise those questions in review of the utrace patches when current code is
actually posted, where they belong.  Here I'll just mention the relevant
things that relate to the underlying issue you raised about synchronization.
As thoroughly documented, utrace_set_events() is a quick, asynchronous call
that itself makes no guarantees about how quickly a running task will start
to report the newly-requested events.  For purposes relevant here, it just
sets TIF_SYSCALL_TRACE and nothing else.  In utrace, if you want synchronous
assurance that a task misses no events you ask for, then you must first use
utrace_control (et al) to stop it and synchronize.  That is not something
that makes much sense at all for a "flip on global tracing" operation, which
is not generally especially synchronous with anything else.  If you want
best effort that a task will pick up newly-requested events Real Soon Now,
you can use utrace_control with just UTRACE_REPORT.  For purposes relevant
here, this just does set_notify_resume().  That will send an IPI if the task
is running, and then it will start noticing before it returns to user mode.
So:
	set_tsk_thread_flag(task, TIF_SYSCALL_TRACE);
	set_notify_resume(task);
is what I would expect you to do on each task if you want to quickly get it
to start hitting tracehook_report_syscall_*.  (I'm a bit dubious that there
is really any need to speed it up with set_notify_resume, but that's just me.)

Finally, some broader points about TIF_SYSCALL_TRACE that I think
have been overlooked.  The key special feature of TIF_SYSCALL_TRACE
is that it gets you to a place where full user_regset access is
available.  Debuggers need this to read (and write) the full user
register state arbitrarily, which they also need to do user
backtraces and the like.  If you do not need user_regset to work,
then you don't need to be on this (slowest) code path.

If you are only interested in reading syscall arguments and results
(or even in changing syscall results in exit tracing) then you do
not need user_regset and you do not need to take the slowest syscall
path.  (If you are doing backtraces but already rely on full kernel
stack unwinding to do it, you also do not need user_regset.)  From
anywhere inside the kernel, you can use the asm/syscall.h calls to
read syscall args, whichever entry path the task took.

The other mechanism to hook into every syscall entry/exit is
TIF_SYSCALL_AUDIT.  On some machines (like x86), this takes a third,
"warm" code path that is faster than the TIF_SYSCALL_TRACE path
(though obviously still off the fastest direct code path).  It can
be faster precisely because it doesn't need to allow for user_regset
access, nor for modification of syscall arguments in entry tracing.
For normal read-only tracing of just the actual syscall details,
it has all you need.

Unfortunately the arch code all looks like:

	if (unlikely(current->audit_context))
		 audit_syscall_{entry,exit}(...);

So we need to change that to:

	if (unlikely(test_thread_flag(TIF_SYSCALL_AUDIT)))
		 audit_syscall_{entry,exit}(...);

But that is pretty easy to get right, even doing it blind on arch's
you can't test.  Far better than adding new asm hackery for each arch
that's almost identical to TIF_SYSCALL_TRACE or TIF_SYSCALL_AUDIT (and
finding out that some are fresh out of TIF bits in the range that
their asm code can handle).

TIF_SYSCALL_AUDIT is only set when allocating audit_context, and its
paths already have !context tests so overloading is harmless today.
(Whereas with TIF_SYSCALL_TRACE, you have to wait for later ptrace
cleanups or write off using ptrace simultaneously.)

Then you can do the lazy disable in audit_syscall_{entry,exit} with:

	if (unlikely(!context)) {
		if (unlikely(!global_syscall_tracing_enabled))
			clear_thread_flag(TIF_SYSCALL_AUDIT);
		return;
	}

Plus add there your tracepoint or whatnot.

Unless you really plan to use user_regset in your tracepoints, then
I think this is a better plan for global syscall tracing than either
fiddling with TIF_SYSCALL_TRACE or adding new arch asm requirements.
(IMHO, the latter is the worst idea on the table.)


Thanks,
Roland
