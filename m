Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbZJ2THO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbZJ2THO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbZJ2THN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:07:13 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65341 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616AbZJ2THM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:07:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FrIOXq+6iZrYY++SZHW6fa6kne/+UeH3bV0wDd5hn1eRjyXG/eGCBma0JUywv0TYnA
         fi1Nqu9gaYhumz9jl2c++C7D00oXO1TDBa4SF21ZbNn5pldhtAsguixZhqyNeL6mapKN
         ccGvUlQLeR97DlG48Qp5SIrJqN9HQaX+G/wLI=
MIME-Version: 1.0
In-Reply-To: <20091026213104.GA8573@in.ibm.com>
References: <1256393818-8921-1-git-send-email-fweisbec@gmail.com>
	 <20091026213104.GA8573@in.ibm.com>
Date: Thu, 29 Oct 2009 20:07:15 +0100
Message-ID: <c62985530910291207n22b83357s51d9ba88f5f09944@mail.gmail.com>
Subject: Re: [GIT PULL v2] hw-breakpoints: Rewrite on top of perf events
From: Frederic Weisbecker <fweisbec@gmail.com>
To: prasad@linux.vnet.ibm.com
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/26 K.Prasad <prasad@linux.vnet.ibm.com>:
> Outside the specific comments about the implementation here, I think
> the patchset begets a larger question about hw-breakpoint layer's
> integration with perf-events.
>
> Upon being a witness to the proposed changes and after some exploration
> of perf_events' functionality, I'm afraid that hw-breakpoint integration
> with perf doesn't benefit the former as much as originally wished to be
> (http://lkml.org/lkml/2009/8/26/149).
>
> Some of the prevalent concerns (which have been raised in different
> threads earlier) are:
>
> - While kernel-space breakpoints need to reside on every processor
>  (irrespective of the process in user-space), perf-events' notion of a
>  counter is always linked to a process context (although there could be
>  workarounds by making it 'pinned', etc).


No. A counter (let's talk about an event profiling instance now) is not
always attached to a single process.
It is attached to a context. Such contexts are defined by perf as gathering
a group of tasks or it can be a whole cpu.

The breakpoint API only supports two kind of contexts: one task, or every
cpus (or per cpu after your last patchset).

That said, perf events can be enhanced to support the context of a wide counter.


>
> - HW Breakpoints register allocation mechanism is 'greedy', which in my
>  opinion is more suitable for allocating a finite and contended
>  resource such as debug register while that of perf-events can give
>  rise to roll-backs (with side-effects such as stray exceptions and
>  race conditions).


I don't get your point. The only possible rollback is when we allocate
a wide breakpoint (then one per cpu).
If you worry about such races, we can register these breakpoints as
being disabled
and enable them once we know the allocation succeeded for every cpu.


>
> - Given that the notion of a per-process context for counters is
>  well-ingrained into the design of perf-events (even system-wide
>  counters are sometimes implemented through individual syscalls over
>  nr_cpus as in builtin-stat.c), it requires huge re-design and
>  user-space changes.


It doesn't require a huge redesign to support wide perf events.


> Trying to scoop out the hw-breakpoint layer off its book-keeping/register
> allocation features only to replace with that of perf-events leads to a
> poor retrofit. On the other hand, an implementation to enable perf to use
> hw-breakpoint layer (and its APIs) to profile memory accesses over
> kernel-space variables (in the context of a process) is very elegant,
> modular and fits cleanly within the frame-work of the perf-events as a
> new perf-type (refer http://lkml.org/lkml/2009/10/26/467). A working
> patchset (under development and containing bugs) is posted for RFC here:
> http://lkml.org/lkml/2009/10/26/461


The non-perf based api is fine for ptrace, kgdb and ftrace uses.
But it is too limited for perf use.

- It has an ad-hoc context binding (register scheduling) abstraction.
Perf is able to manage
  that already: binding to defined group of processes, cpu, etc...

- It doesn't allow non-pinned events, when a breakpoint is disabled
(due to context schedule out), it is
  only virtually disabled, it's slot is not freed.

Basically, the breakpoints are performance monitoring and debug
events. Something
that perf can already handle.

The current breakpoint API does all that in an ad-hoc way
(debug register scheduling when cpu get up/down, when we context
switch, etc...).
It is also not powerful enough to support non-pinned events.

The only downside I can see in perf events: it does not support wide
system contexts.
I don't think it requires a huge redesign. But instead of continuing
this ad-hoc context-handling
to cover this hole in perf, why not enhance perf so that it can cover that?
