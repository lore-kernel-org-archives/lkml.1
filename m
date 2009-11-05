Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbZKELC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbZKELC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 06:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZKELCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 06:02:55 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:36069 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbZKELCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 06:02:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MZmkx+EYhY+1TPTU1TNkclC7bGgmNabGQLMgjsKJSKY3HFlrRGg5uvH4hjO56JJFK5
         KB1klCCm2sBMyu5kP2iAO3aBPr1QmHXRaaZBUrJnlsndwnMan2wlQbt4GhjlhtL02PcH
         aAe6jHojVYm4nZ1i2huZg/Mxh0E7mh3R1FyF8=
Date: Thu, 5 Nov 2009 12:02:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL v2] hw-breakpoints: Rewrite on top of perf events
Message-ID: <20091105110255.GA4877@nowhere>
References: <1256393818-8921-1-git-send-email-fweisbec@gmail.com> <20091026213104.GA8573@in.ibm.com> <c62985530910291207n22b83357s51d9ba88f5f09944@mail.gmail.com> <20091102062550.GA3146@in.ibm.com> <20091102140710.GD4878@nowhere> <20091104141425.GA9510@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104141425.GA9510@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 07:44:25PM +0530, K.Prasad wrote:
> Let me explain further with an illustration..assume two contenders for
> breakpoints say A and B on a machine with 4 CPUs (0-3). Due to several
> prior per-CPU requests CPU0 has one free debug register while CPU3 has
> none. 'A' asks for a system-wide breakpoint while 'B' requests for a
> per-cpu breakpoint on CPU0. Now think of a race between them! If 'A'
> begins first, it starts with CPU0 and proceeds by consuming debug
> registers on CPUs in ascending order, meanwhile 'B' would return
> thinking that its request cannot be serviced. However 'A' would
> eventually fail (since there are no free debug registers on CPU3) and
> relinquish the debug register on CPU0 also (during rollback), but 'B'
> has returned thinking that there are no free debug registers available.
> (registering breakpoint requests in disabled state only helps prevent stray
> exceptions).
> 
> With some book-keeping such races are prevented. Registration requests
> would fail with -ENOSPC only if there are genuine users of debug
> registers and not because some potential user (who might eventually
> rollback) is holding onto the register temporarily.


True. But such race would only happen in case of concurrent launching
of perf and the ksym_tracer or kgdb in parallel.

I can't figure out such situation to happen easily.
But if that's really a worry, we can lock the register_breakpoint_*
path (or implement wide perf events).

 
> Such a limitation may not be of immediate worry, but shouldn't be
> a reason to throw away a feature that pre-empts such concerns. 



When you migrate a feature on top of another subsystem, it happens
you can lose something. If the migration induces nice new features
then sometimes it's worth the migration and add some code to break
the loss.

But if the loss is about such a tiny tight race that is unlikely
to happen in the real world (and doesn't imply crash or something
bad like that) then it's not necessary worth the effort.


> Are there
> any hw-registers managed by perf-events that are more than one (like
> debug registers which are 4 in x86) with such peculiar needs?


Perhaps. I don't know. If so, we may want to migrate the plural pmu
constraints from hw_breakpoint.c to perf_event.c.

That said this is likely to happen because we don't need registers for that.
Any profiling/tracing/debugging unit based on multiple sources and bound
to tunable contexts may fit into that scheme.
Hardware registers are just a subset of what can be considered as a
a source of "performance monitoring unit".

And perf event has been extended enough to expand the possible
sources to "Event monitoring unit", so the possibilities are broad.



> User-space scheduling of breakpoint register is the closest that
> comes to what perf-events already does...and that's just about a
> single-hook in __switch_to(). Have no delusions about huge
> duplication! and no concerns about arch-specific code being littered all
> over - writing onto debug registers is a processor-specific activity and
> hence the arch-specific invocation.



That's because it's so close to perf event context scheduling that
we want to unify it.

This is not only a single hook in __switch_to():

- This is a context bound ressource scheduling decision made from arch
  in spite of the existing optimized mechanisms implemented in a core
  profiling subsystem.

- This is a single hook in __switch_to() in x86. Now multiply that
  by $(ls arch/ | wc -l) = 26 (-1 because of arch/Kconfig)
  Also, expand that to cpu hotplug hooks, kexec hooks, etc...
  And also include the free_thread hooks.

- If we have a ptrace breakpoint, the scheduling decision is made
  by the hw_breakpoint API. Otherwise it's made by perf.
  Why should we maintain two versions of the scheduling decision?

This is a matter of maintainabilty.

 
> System-wide breakpoints, cpu hotplug helpers, kexec hooks as you
> mentioned have not been implemented for perf-events....and in a way it
> is of little help there other than for hw-breakpoints (are there any
> hw-registers managed by perf that have residual effect i.e. continue to
> generate exceptions like hw-breakpoints?)



System wide events are not supported by perf because of a
design decision for scalability ends.

Each event is bound to a private buffer (inherited to task
childs in the case of task bound counters).
If we have an event that can trigger from every cpu, we can
have multiple concurrent writes in the same buffer and the
profiling would suffer from such contention if we have a
lot of events from several cpus.

Having cpu bound events drop this contention as the events don't
fight against other cpus.

(It the case of task bound events, the contention is there, but
in the window of a task group only).

We manage a wide profiling using a collection of per cpu events,
it scales way much better.

We could also implement the wide context if that becomes wanted but
it should be used by knowing that it won't scale for high frequency
events in SMP.

Concerning cpu hotplug helpers, it is implemented by perf events
(perf_event_{exit/init}_cpu() notifiers).

Kexec is a corner case, but we might want to add a kexec callback
to the pmu structure if needed.

Concerning residual effects of lazy breakpoint registers switching
I don't how the migration to perf brings any problem.

 
> Comparing this to tracepoints isn't apt here. My limited knowledge
> doesn't quickly provide me with an alternate analogy (how about kprobes
> + perf-events integration?...no, even that isn't close).



Why isn't the tracepoint analogy apt?

It's basically the same.

Say you have func1(), a function in which several subsystems want
to hook:


func1()
{
	// do something cool
	subsys1_hook();
	subsys2_hook();
	subsys3_hook();
	etc...
}

Instead of that, we can use tracepoint, so that we can zap all
these hooks and only provide one that will dispatch to the subsys:

func1()
{
	trace_func1() -> will dispatch to subsys1_hook(), subsys2_hook() etc..
}

The current situation with hw breakpoints and perf is somehow the same.
Hw breakpoint is hooking at arch __switch_to(), cpu_hotplug thing, etc...

But perf too. And perf can act as a dispatcher there. It already
hooks on the scheduler events and cpu hotplug and can take
centralized decisions from these hooks, such as toggling pmus,
and hardware breakpoints can fit there.

 
> Can you cite the need for such features in general perf-events
> architecture with examples other than hw-breakpoints? In my opinion, if there
> had been a need, perf-events would have included them already (perf top
> is the only need that comes close to wanting system-wide support but
> even there, it is happy by making one syscall per-cpu).



It is happy doing so because it scales.


 
> Integrating the features required by hw-breakpoints with perf-events
> (with apologies for the out-of-context examples) like mixing oil with
> water, proverbial chalk-and-cheese....they stay together but are
> immiscible.
>
> Citing some examples from your patchset, look at the addition of
> 'callback' function pointer or the addition of length, type fields in
> perf_event_attr. Do you find generic use-cases for them in perf-events
> (outside hw-breakpoints)? Merging structures to create a generic one,
> but only to be used for a specific use-case (hw-breakpoint) doesn't
> sound like a good idea, and speculating on future use-cases (not current
> ones) have never been welcomed.



We need to give the parameters for this specific event. The current
struct perf_event_attr is not sufficient for that.
It needs to grow if needed to host new needs for new events. That's
why it has a field for its size, that's why it has reserved fields,
I don't see where is the problem with that. Nothing in the breakpoint
API can help about that either. We still need a suitable userspace
gate to define a breakpoint.

And while at it, we reuse it for in-kernel uses.

If you look at the struct hw_perf_event, you'll find a protean
structure, considering the union inside, so that it can fit the needs
for two different type of events.


> As I told you register/unregister combination is to be used, and I can
> get you some numbers about its overhead if that is of concern to you.
> It is the IPI constitues a large overhead (not needed for a 1-cpu request),
> and not the book-keeping work. A more elegant way would be to use the
> modify_kernel_hw_breakpoint() (interface submitted in one of my previous
> patches) to simply change the breakpoint address/type/len.



And btw the IPI that binds an event to a cpu is another example of
something already managed by perf.

My real concern is about the fact that the hw-breakpoint api
would act as an unnecessary midlayer there.
Perf is already able to talk directly to the pmu to enable/disable it,
which in practice is just a write to the debug registers.

Why should we encumber with such midlayer?

