Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZKBG0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZKBG0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 01:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZKBG0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 01:26:06 -0500
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:51614 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbZKBG0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 01:26:05 -0500
Date: Mon, 2 Nov 2009 11:55:50 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Message-ID: <20091102062550.GA3146@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1256393818-8921-1-git-send-email-fweisbec@gmail.com> <20091026213104.GA8573@in.ibm.com> <c62985530910291207n22b83357s51d9ba88f5f09944@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530910291207n22b83357s51d9ba88f5f09944@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 08:07:15PM +0100, Frederic Weisbecker wrote:
> 2009/10/26 K.Prasad <prasad@linux.vnet.ibm.com>:
> > Outside the specific comments about the implementation here, I think
> > the patchset begets a larger question about hw-breakpoint layer's
> > integration with perf-events.
> >
> > Upon being a witness to the proposed changes and after some exploration
> > of perf_events' functionality, I'm afraid that hw-breakpoint integration
> > with perf doesn't benefit the former as much as originally wished to be
> > (http://lkml.org/lkml/2009/8/26/149).
> >
> > Some of the prevalent concerns (which have been raised in different
> > threads earlier) are:
> >
> > - While kernel-space breakpoints need to reside on every processor
> >  (irrespective of the process in user-space), perf-events' notion of a
> >  counter is always linked to a process context (although there could be
> >  workarounds by making it 'pinned', etc).
> 
> 
> No. A counter (let's talk about an event profiling instance now) is not
> always attached to a single process.
> It is attached to a context. Such contexts are defined by perf as gathering
> a group of tasks or it can be a whole cpu.
> 

Okay.

> The breakpoint API only supports two kind of contexts: one task, or every
> cpus (or per cpu after your last patchset).
> 

Yes, and please see the replies to your concerns below.

> That said, perf events can be enhanced to support the context of a wide counter.
> 
> 
> >
> > - HW Breakpoints register allocation mechanism is 'greedy', which in my
> >  opinion is more suitable for allocating a finite and contended
> >  resource such as debug register while that of perf-events can give
> >  rise to roll-backs (with side-effects such as stray exceptions and
> >  race conditions).
> 
> 
> I don't get your point. The only possible rollback is when we allocate
> a wide breakpoint (then one per cpu).
> If you worry about such races, we can register these breakpoints as
> being disabled
> and enable them once we know the allocation succeeded for every cpu.
> 
> 

Not just stray exceptions, as explained before here:
http://lkml.org/lkml/2009/10/1/76
- Races between the requests (also leading to temporary failure of
  all CPU requests) presenting an unclear picture about free debug
  registers (making it difficult to predict the need for a retry).

> >
> > - Given that the notion of a per-process context for counters is
> >  well-ingrained into the design of perf-events (even system-wide
> >  counters are sometimes implemented through individual syscalls over
> >  nr_cpus as in builtin-stat.c), it requires huge re-design and
> >  user-space changes.
> 
> 
> It doesn't require a huge redesign to support wide perf events.
> 
> 

I contest that :-)...and the sheer amount of code movement, re-design
(including core data structures) in the patchset here:
http://lkml.org/lkml/2009/10/24/53.
And all this with a loss of a well-layered, modular code and a
loss of true system-wide support for bkpt counters!

> > Trying to scoop out the hw-breakpoint layer off its book-keeping/register
> > allocation features only to replace with that of perf-events leads to a
> > poor retrofit. On the other hand, an implementation to enable perf to use
> > hw-breakpoint layer (and its APIs) to profile memory accesses over
> > kernel-space variables (in the context of a process) is very elegant,
> > modular and fits cleanly within the frame-work of the perf-events as a
> > new perf-type (refer http://lkml.org/lkml/2009/10/26/467). A working
> > patchset (under development and containing bugs) is posted for RFC here:
> > http://lkml.org/lkml/2009/10/26/461
> 
> 
> The non-perf based api is fine for ptrace, kgdb and ftrace uses.
> But it is too limited for perf use.
> 
> - It has an ad-hoc context binding (register scheduling) abstraction.
> Perf is able to manage
>   that already: binding to defined group of processes, cpu, etc...
> 

I don't see what's ad-hoc in the scheduling behaviour of the hw-bkpt
layer. Hw-breakpoint layer does the following with respect to register
scheduling:

- User-space breakpoints are always tied to a thread
  (thread_info/task_struct) and are hence
  active when the corresponding thread is scheduled.

- Kernel-space addresses (requests from in-kernel sources) should be
  always active and aren't affected by process context-switches/schedule
  operations. Some of the sophisticated mechanisms for scheduling
  kernel vs user-space breakpoints (such as trapping syscalls to restore
  register context) were pre-empted by the community (as seen here:
  http://lkml.org/lkml/2009/3/11/145).

Any further abstraction required by the end-user (as in the case of
perf) can be well-implemented through the powerful breakpoint
interfaces. For instance - perf-events with its unique requirement
wherein a kernel-space breakpoint need to be active only when a given
process is active. Hardware breakpoint layer handles them quite well
as seen here: http://lkml.org/lkml/2009/10/29/300.

> - It doesn't allow non-pinned events, when a breakpoint is disabled
> (due to context schedule out), it is
>   only virtually disabled, it's slot is not freed.
> 

The <enable><disable>_hw_breakpoint() are designed such. If a user want
the slot to be freed (which is ill-advised for a requirement here) it
can invoke (un)register_kernel_hw_breakpoint() instead (would have very
little overhead for the 1-CPU case without IPIs).

> Basically, the breakpoints are performance monitoring and debug
> events. Something
> that perf can already handle.
> 
> The current breakpoint API does all that in an ad-hoc way
> (debug register scheduling when cpu get up/down, when we context
> switch, etc...).
> It is also not powerful enough to support non-pinned events.
> 
> The only downside I can see in perf events: it does not support wide
> system contexts.
> I don't think it requires a huge redesign. But instead of continuing
> this ad-hoc context-handling
> to cover this hole in perf, why not enhance perf so that it can cover that?

The advantages of having perf-events to use hw-breakpoint layer is
explained here and in many of my previous emails. It entails no loss of
functionality for either perf-events of hw-breakpoints, while allowing
users to harness the power of both.

Thanks,
K.Prasad

