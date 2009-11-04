Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbZKDOOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbZKDOOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756435AbZKDOOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:14:32 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:38307 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436AbZKDOO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:14:29 -0500
Date: Wed, 4 Nov 2009 19:44:25 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL v2] hw-breakpoints: Rewrite on top of perf events
Message-ID: <20091104141425.GA9510@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1256393818-8921-1-git-send-email-fweisbec@gmail.com> <20091026213104.GA8573@in.ibm.com> <c62985530910291207n22b83357s51d9ba88f5f09944@mail.gmail.com> <20091102062550.GA3146@in.ibm.com> <20091102140710.GD4878@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091102140710.GD4878@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 03:07:14PM +0100, Frederic Weisbecker wrote:
> On Mon, Nov 02, 2009 at 11:55:50AM +0530, K.Prasad wrote:
> > > I don't get your point. The only possible rollback is when we allocate
> > > a wide breakpoint (then one per cpu).
> > > If you worry about such races, we can register these breakpoints as
> > > being disabled
> > > and enable them once we know the allocation succeeded for every cpu.
> > > 
> > > 
> > 
> > Not just stray exceptions, as explained before here:
> > http://lkml.org/lkml/2009/10/1/76
> > - Races between the requests (also leading to temporary failure of
> >   all CPU requests) presenting an unclear picture about free debug
> >   registers (making it difficult to predict the need for a retry).
> 
> 
> 
> Ok. But say we have to set a wide breakpoint.
> We can create a disabled set of per cpu breakpoint and then enable
> them once we are sure every cpus can host it (we have already reserved a slot
> for each of these while registering).
> 
> Then this race is not there anymore.
> 

Let me explain further with an illustration..assume two contenders for
breakpoints say A and B on a machine with 4 CPUs (0-3). Due to several
prior per-CPU requests CPU0 has one free debug register while CPU3 has
none. 'A' asks for a system-wide breakpoint while 'B' requests for a
per-cpu breakpoint on CPU0. Now think of a race between them! If 'A'
begins first, it starts with CPU0 and proceeds by consuming debug
registers on CPUs in ascending order, meanwhile 'B' would return
thinking that its request cannot be serviced. However 'A' would
eventually fail (since there are no free debug registers on CPU3) and
relinquish the debug register on CPU0 also (during rollback), but 'B'
has returned thinking that there are no free debug registers available.
(registering breakpoint requests in disabled state only helps prevent stray
exceptions).

With some book-keeping such races are prevented. Registration requests
would fail with -ENOSPC only if there are genuine users of debug
registers and not because some potential user (who might eventually
rollback) is holding onto the register temporarily.

Such a limitation may not be of immediate worry, but shouldn't be
a reason to throw away a feature that pre-empts such concerns. Are there
any hw-registers managed by perf-events that are more than one (like
debug registers which are 4 in x86) with such peculiar needs?

> > > >
> > > > - Given that the notion of a per-process context for counters is
> > > >  well-ingrained into the design of perf-events (even system-wide
> > > >  counters are sometimes implemented through individual syscalls over
> > > >  nr_cpus as in builtin-stat.c), it requires huge re-design and
> > > >  user-space changes.
> > > 
> > > 
> > > It doesn't require a huge redesign to support wide perf events.
> > > 
> > > 
> > 
> > I contest that :-)...and the sheer amount of code movement, re-design
> > (including core data structures) in the patchset here:
> > http://lkml.org/lkml/2009/10/24/53.
> 
> 
> 
> This is about rebasing the hw-breakpoints on top of another profiling
> infrastructure.
> 
> So the fact we had to do a lot of changes looks fair.
> 
> 
> > And all this with a loss of a well-layered, modular code and a
> > loss of true system-wide support for bkpt counters! 
> 
> 
> I don't get your point about the loss of a well-layered and modular
> code.
> 
> We are reusing an existing profiling infrastructure that looks pretty well
> layered and modular to me:
> 
> The scheduling of per task registers is centralized in the core and not in the
> arch like it was done with the hardware breakpoint api. The remaining arch bits
> are only a concern of writing these registers.
> It is not sane to hook on arch switch_to(), cpu hotplug helpers, kexec, etc...
> to do an ad-hoc scheduling of perf task register whereas we already have
> a centralized profiling area that can take these decisions.
> 
> So, yes indeed it doesn't support the wide contexts yet.
> 

User-space scheduling of breakpoint register is the closest that
comes to what perf-events already does...and that's just about a
single-hook in __switch_to(). Have no delusions about huge
duplication! and no concerns about arch-specific code being littered all
over - writing onto debug registers is a processor-specific activity and
hence the arch-specific invocation.

System-wide breakpoints, cpu hotplug helpers, kexec hooks as you
mentioned have not been implemented for perf-events....and in a way it
is of little help there other than for hw-breakpoints (are there any
hw-registers managed by perf that have residual effect i.e. continue to
generate exceptions like hw-breakpoints?)

> Let's compare that to the tracing area. What if we hadn't the tracepoints
> and every tracers put their own tracing callbacks in the area they want to trace.
> We would have a proliferation of ad-hoc tracing functions calls.
> But we have the tracepoints: a centralized feature that only requires just one
> callback somewhere in the kernel where we want to hook up and in which
> every tracers can subscribe.
> That's more modular and well-layered.
> 

Comparing this to tracepoints isn't apt here. My limited knowledge
doesn't quickly provide me with an alternate analogy (how about kprobes
+ perf-events integration?...no, even that isn't close).

> The problem with the lack of a wide context support with perf events is pretty
> the same.
> The hw-breakpoint api can implement its ad-hoc one. But it means every
> other profiling/debug features will lack it and need to implement their
> own.
> 

Can you cite the need for such features in general perf-events
architecture with examples other than hw-breakpoints? In my opinion, if there
had been a need, perf-events would have included them already (perf top
is the only need that comes close to wanting system-wide support but
even there, it is happy by making one syscall per-cpu).

Integrating the features required by hw-breakpoints with perf-events
(with apologies for the out-of-context examples) like mixing oil with
water, proverbial chalk-and-cheese....they stay together but are
immiscible.

Citing some examples from your patchset, look at the addition of
'callback' function pointer or the addition of length, type fields in
perf_event_attr. Do you find generic use-cases for them in perf-events
(outside hw-breakpoints)? Merging structures to create a generic one,
but only to be used for a specific use-case (hw-breakpoint) doesn't
sound like a good idea, and speculating on future use-cases (not current
ones) have never been welcomed.

> So why not improving a centralized profiling subsystem instead of implementing
> an ad-hoc one for every profiling classes that need it?
> 
>
> 
> > > The non-perf based api is fine for ptrace, kgdb and ftrace uses.
> > > But it is too limited for perf use.
> > > 
> > > - It has an ad-hoc context binding (register scheduling) abstraction.
> > > Perf is able to manage
> > >   that already: binding to defined group of processes, cpu, etc...
> > > 
> > 
> > I don't see what's ad-hoc in the scheduling behaviour of the hw-bkpt
> > layer. Hw-breakpoint layer does the following with respect to register
> > scheduling:
> > 
> > - User-space breakpoints are always tied to a thread
> >   (thread_info/task_struct) and are hence
> >   active when the corresponding thread is scheduled.
> 
> 
> 
> This is what is ad-hoc. You need to hook on switch_to, cpu hotplug
> and kexec to update the breakpoints registers. And this is something
> that would need to be done in every archs. That looks insane considering
> the fact we have a core layer that can handle these decisions already.
> 
> 

As explained above.

> 
> > - Kernel-space addresses (requests from in-kernel sources) should be
> >   always active and aren't affected by process context-switches/schedule
> >   operations. Some of the sophisticated mechanisms for scheduling
> >   kernel vs user-space breakpoints (such as trapping syscalls to restore
> >   register context) were pre-empted by the community (as seen here:
> >   http://lkml.org/lkml/2009/3/11/145).
> 
> 
> Sure. And things have evolved since then. We have a centralized
> profiling/event susbsystem now.
> 
> 
> > Any further abstraction required by the end-user (as in the case of
> > perf) can be well-implemented through the powerful breakpoint
> > interfaces. For instance - perf-events with its unique requirement
> > wherein a kernel-space breakpoint need to be active only when a given
> > process is active. Hardware breakpoint layer handles them quite well
> > as seen here: http://lkml.org/lkml/2009/10/29/300.
> 
> 
> It logically disables/enables the breakpoints but not physically.
> Which means a disabled breakpoint still keeps its slot, making
> it unavailable for another event, it i required for non-pinned
> events.
> 
> > > - It doesn't allow non-pinned events, when a breakpoint is disabled
> > > (due to context schedule out), it is
> > >   only virtually disabled, it's slot is not freed.
> > > 
> > 
> > The <enable><disable>_hw_breakpoint() are designed such. If a user want
> > the slot to be freed (which is ill-advised for a requirement here) it
> > can invoke (un)register_kernel_hw_breakpoint() instead (would have very
> > little overhead for the 1-CPU case without IPIs).
> 
> 
> This adds unnecessary overhead. All we want is to update arch registers
> when we schedule in/out an event.
> 
> We need to be able to free a slot for non-pinned counter because
> an undefined number of events must be able to be time shared
> in a single slot (in the worst case).
> 
> Calling unregister_kernel_breakpoint() each time we schedule out
> a non-pinned counter adds unnecessary overhead. And calling
> register_kernel_breakpoint() while enabling one is yet
> another unnecessary overhead.
> 
> You'd need to check the free slots constraints every time for them.
>

As I told you register/unregister combination is to be used, and I can
get you some numbers about its overhead if that is of concern to you.
It is the IPI constitues a large overhead (not needed for a 1-cpu request),
and not the book-keeping work. A more elegant way would be to use the
modify_kernel_hw_breakpoint() (interface submitted in one of my previous
patches) to simply change the breakpoint address/type/len.

I don't see anything that is required by the perf-event that the
hw-breakpoint layer doesn't provide.

I shall re-state these views in a response to Ingo's mail (that talks about
concerns of duplicate code)...meanwhile I think I should begin
reviewing your patchset (for perf-integration) lest the community insist
that approach.

Thanks,
K.Prasad

