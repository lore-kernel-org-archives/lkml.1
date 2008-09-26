Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbYIZKnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbYIZKnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 06:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbYIZKnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 06:43:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36598 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbYIZKnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 06:43:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Paul Mundt <lethal@linux-sh.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH] [RFC] tracehook: Hook in syscall tracing markers.
In-Reply-To: Paul Mundt's message of  Sunday, 21 September 2008 11:16:30 +0900 <20080921021630.GA6443@linux-sh.org>
References: <20080921021630.GA6443@linux-sh.org>
X-Zippy-Says: World War Three can be averted by adherence to a strictly enforced
    dress code!
Message-Id: <20080926104234.F271B1541FA@magilla.localdomain>
Date: Fri, 26 Sep 2008 03:42:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I've been slow in catching up on email threads after last week.

As to the arguments, the asm/syscall.h interface is there for that
(see the asm-generic/syscall.h comments).  A tracepoint that passes
the regs argument through makes those easy to use.  (Actually, it's
always the same as task_pt_regs(current), but since it's on hand in
an argument register anyway, might as well use it.)  

Of course these are the generic "up to 6 register values that make up
syscall args", and nothing "generic" inside the kernel addresses the
subject of what the actual C types of each syscall's arguments are.
That is one benefit you get from specific tracepoints inside specific
calls--another is specificity of call, though at the expense of
specificity of which thread gets traced.  I think that whole subject is
beyond the scope of what we mean by "a global syscall tracepoint", which
I think is all we're talking about here.

As Frank mentioned, the main problem to be solved here is how to arrange
that all threads gets into tracehook_report_syscall_entry/exit to begin
with, i.e. keep TIF_SYSCALL_TRACE set or equivalent.

I think adding TIF_KERNEL_TRACE is just a lousy idea.  It does
constitute touching the asm of each arch by hand in subtle ways.  On
some machines, there isn't a free bit in the range that's needed to
act equivalent to TIF_SYSCALL_TRACE.  So I suspect Mathieu has some
arch patches "without changing anything of the assembly code except
adding one flag to the tested flags" for an arch or two that in fact
change the assembly code so it won't work (or won't even assemble).

After CONFIG_ARCH_TRACEHOOK, I really think we want--and can
have--exactly zero changes anywhere in assembly code related to this.

Every arch already implements two ways to get someplace hookable for
every syscall: TIF_SYSCALL_TRACE and TIF_SYSCALL_AUDIT.  That's enough.

Currently TIF_SYSCALL_TRACE is only used by ptrace, which does no other
bookkeeping to remember whether it set the flag.  It's trivial to make
ptrace not clear TIF_SYSCALL_TRACE when global tracing is enabled.  It's
also trivial to set it on every thread to enable global tracing, and
then start new threads with it set.  That leaves only some corner cases
about when you disable global tracing.  It wouldn't be so hard to fiddle
with ptrace bookkeeping so you can get the bit cleared correctly without
either spurious syscall tracing reports or breaking PTRACE_SYSCALL
operations already in flight.  (Incidentally, under utrace there is
already bookkeeping such that it's completely trivial to make it lazily
clear TIF_SYSCALL_TRACE after global tracing has been disabled and
interact with utrace/ptrace right.)

Back on the arguments, it's worth mentioning to be complete on the
record: The asm/syscall.h approach (extracting via pt_regs) is quite
cheap (inlined away to a word copy) on almost all machines, but is more
costly on ia64 (perhaps significantly so).  On ia64, it may make a real
performance difference to have a tracepoint of some kind that passes the
arguments directly in its signature.  Conversely, on other machines
these several arguments vs the one struct pt_regs * could well clutter
up the generated code around a tracepoint.

The audit hooks take direct syscall argument register value parameters
in this way, though only four of the possibly six argument registers.
This ties into the alternative of using TIF_SYSCALL_AUDIT instead.  With
a differently-placed tracepoint (in auditsc.c), this could work either
with or without an actual audit context.  On another tangent, if you
were to enable a normal audit context, this also gets you audit_getname,
which gets obliquely towards part of the "syscall arguments with types"
puzzle.  Another caveat is that the audit path is not where a tracepoint
probe function can change the syscall args/# on entry or result on exit,
which only tracehook_report_syscall_entry/exit can safely do.


Thanks,
Roland
