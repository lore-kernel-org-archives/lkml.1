Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbZJZVbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbZJZVbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbZJZVbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:31:08 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:57697 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbZJZVbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:31:07 -0400
Date: Tue, 27 Oct 2009 03:01:04 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL v2] hw-breakpoints: Rewrite on top of perf events
Message-ID: <20091026213104.GA8573@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1256393818-8921-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256393818-8921-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 24, 2009 at 04:16:52PM +0200, Frederic Weisbecker wrote:
> Hi all,
> 
> This is the v2 of the hw-breakpoints API rewrite on top of perf events.
> You can find the previous version here:
> http://lwn.net/Articles/351922/
> 
> Changes in v2:
>     
>     - Follow the perf "event " rename
>     - The ptrace regression have been fixed (ptrace breakpoint perf events
>       weren't released when a task ended)
>     - Drop the struct hw_breakpoint and store generic fields in
>       perf_event_attr.
>     - Separate core and arch specific headers, drop
>       asm-generic/hw_breakpoint.h and create linux/hw_breakpoint.h
>     - Use new generic len/type for breakpoint
>     - Handle off case: when breakpoints api is not supported by an arch
>     - Use proper in-kernel perf api provided by Arjan.
> 
> There are still a lot of things that need to be cleaned, simplified,
> improved (ptrace side, the bp api, etc....) I guess these things can
> be done incrementally if you agree.
> 
> I've also tried to get an arch-independent api. Generic fields for
> breakpoints are stored in perf_event_attr structure (type, len, addr).
> This needs to be discussed and improved before it becomes a perf
> userspace ABI. We need to find a generic enough structure to host
> the breakpoints parameters, something that can better fit to most arch
> (handling breakpoint ranges in powerpc, etc...).
>

Outside the specific comments about the implementation here, I think
the patchset begets a larger question about hw-breakpoint layer's
integration with perf-events.

Upon being a witness to the proposed changes and after some exploration
of perf_events' functionality, I'm afraid that hw-breakpoint integration
with perf doesn't benefit the former as much as originally wished to be
(http://lkml.org/lkml/2009/8/26/149).

Some of the prevalent concerns (which have been raised in different
threads earlier) are:

- While kernel-space breakpoints need to reside on every processor
  (irrespective of the process in user-space), perf-events' notion of a
  counter is always linked to a process context (although there could be
  workarounds by making it 'pinned', etc).

- HW Breakpoints register allocation mechanism is 'greedy', which in my
  opinion is more suitable for allocating a finite and contended
  resource such as debug register while that of perf-events can give
  rise to roll-backs (with side-effects such as stray exceptions and
  race conditions).

- Given that the notion of a per-process context for counters is
  well-ingrained into the design of perf-events (even system-wide
  counters are sometimes implemented through individual syscalls over
  nr_cpus as in builtin-stat.c), it requires huge re-design and
  user-space changes.

Trying to scoop out the hw-breakpoint layer off its book-keeping/register
allocation features only to replace with that of perf-events leads to a
poor retrofit. On the other hand, an implementation to enable perf to use
hw-breakpoint layer (and its APIs) to profile memory accesses over
kernel-space variables (in the context of a process) is very elegant,
modular and fits cleanly within the frame-work of the perf-events as a
new perf-type (refer http://lkml.org/lkml/2009/10/26/467). A working
patchset (under development and containing bugs) is posted for RFC here:
http://lkml.org/lkml/2009/10/26/461

It is my opinion that enhancing perf-layer to profile memory accesses
through hw-breakpoint layer should be preferred over merging them.

Thanks,
K.Prasad

