Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbZKBOHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbZKBOHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 09:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbZKBOHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 09:07:13 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:33946 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbZKBOHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 09:07:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=h7IF/vyCSgu9U24spjU6kXFxIGv/NK0Nu/NekCTpcTIr0/dr4LRVOucDa58CVILvhC
         TTEfjImaFl4k4iIytdPcM1iN7b4ueTEzdIUAXlEgRqfPfpsEKXPRreFpm3Tw8fMAPwBH
         2AHqYbKTNDP2py5b/PDoY06vqMjnK+meXzu88=
Date: Mon, 2 Nov 2009 15:07:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
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
Message-ID: <20091102140710.GD4878@nowhere>
References: <1256393818-8921-1-git-send-email-fweisbec@gmail.com> <20091026213104.GA8573@in.ibm.com> <c62985530910291207n22b83357s51d9ba88f5f09944@mail.gmail.com> <20091102062550.GA3146@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091102062550.GA3146@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 11:55:50AM +0530, K.Prasad wrote:
> > I don't get your point. The only possible rollback is when we allocate
> > a wide breakpoint (then one per cpu).
> > If you worry about such races, we can register these breakpoints as
> > being disabled
> > and enable them once we know the allocation succeeded for every cpu.
> > 
> > 
> 
> Not just stray exceptions, as explained before here:
> http://lkml.org/lkml/2009/10/1/76
> - Races between the requests (also leading to temporary failure of
>   all CPU requests) presenting an unclear picture about free debug
>   registers (making it difficult to predict the need for a retry).



Ok. But say we have to set a wide breakpoint.
We can create a disabled set of per cpu breakpoint and then enable
them once we are sure every cpus can host it (we have already reserved a slot
for each of these while registering).

Then this race is not there anymore.

 
> > >
> > > - Given that the notion of a per-process context for counters is
> > >  well-ingrained into the design of perf-events (even system-wide
> > >  counters are sometimes implemented through individual syscalls over
> > >  nr_cpus as in builtin-stat.c), it requires huge re-design and
> > >  user-space changes.
> > 
> > 
> > It doesn't require a huge redesign to support wide perf events.
> > 
> > 
> 
> I contest that :-)...and the sheer amount of code movement, re-design
> (including core data structures) in the patchset here:
> http://lkml.org/lkml/2009/10/24/53.



This is about rebasing the hw-breakpoints on top of another profiling
infrastructure.

So the fact we had to do a lot of changes looks fair.


> And all this with a loss of a well-layered, modular code and a
> loss of true system-wide support for bkpt counters! 


I don't get your point about the loss of a well-layered and modular
code.

We are reusing an existing profiling infrastructure that looks pretty well
layered and modular to me:

The scheduling of per task registers is centralized in the core and not in the
arch like it was done with the hardware breakpoint api. The remaining arch bits
are only a concern of writing these registers.
It is not sane to hook on arch switch_to(), cpu hotplug helpers, kexec, etc...
to do an ad-hoc scheduling of perf task register whereas we already have
a centralized profiling area that can take these decisions.

So, yes indeed it doesn't support the wide contexts yet.

Let's compare that to the tracing area. What if we hadn't the tracepoints
and every tracers put their own tracing callbacks in the area they want to trace.
We would have a proliferation of ad-hoc tracing functions calls.
But we have the tracepoints: a centralized feature that only requires just one
callback somewhere in the kernel where we want to hook up and in which
every tracers can subscribe.
That's more modular and well-layered.

The problem with the lack of a wide context support with perf events is pretty
the same.
The hw-breakpoint api can implement its ad-hoc one. But it means every
other profiling/debug features will lack it and need to implement their
own.

So why not improving a centralized profiling subsystem instead of implementing
an ad-hoc one for every profiling classes that need it?



> > The non-perf based api is fine for ptrace, kgdb and ftrace uses.
> > But it is too limited for perf use.
> > 
> > - It has an ad-hoc context binding (register scheduling) abstraction.
> > Perf is able to manage
> >   that already: binding to defined group of processes, cpu, etc...
> > 
> 
> I don't see what's ad-hoc in the scheduling behaviour of the hw-bkpt
> layer. Hw-breakpoint layer does the following with respect to register
> scheduling:
> 
> - User-space breakpoints are always tied to a thread
>   (thread_info/task_struct) and are hence
>   active when the corresponding thread is scheduled.



This is what is ad-hoc. You need to hook on switch_to, cpu hotplug
and kexec to update the breakpoints registers. And this is something
that would need to be done in every archs. That looks insane considering
the fact we have a core layer that can handle these decisions already.


 
> - Kernel-space addresses (requests from in-kernel sources) should be
>   always active and aren't affected by process context-switches/schedule
>   operations. Some of the sophisticated mechanisms for scheduling
>   kernel vs user-space breakpoints (such as trapping syscalls to restore
>   register context) were pre-empted by the community (as seen here:
>   http://lkml.org/lkml/2009/3/11/145).



Sure. And things have evolved since then. We have a centralized
profiling/event susbsystem now.



> Any further abstraction required by the end-user (as in the case of
> perf) can be well-implemented through the powerful breakpoint
> interfaces. For instance - perf-events with its unique requirement
> wherein a kernel-space breakpoint need to be active only when a given
> process is active. Hardware breakpoint layer handles them quite well
> as seen here: http://lkml.org/lkml/2009/10/29/300.




It logically disables/enables the breakpoints but not physically.
Which means a disabled breakpoint still keeps its slot, making
it unavailable for another event, it i required for non-pinned
events.




> > - It doesn't allow non-pinned events, when a breakpoint is disabled
> > (due to context schedule out), it is
> >   only virtually disabled, it's slot is not freed.
> > 
> 
> The <enable><disable>_hw_breakpoint() are designed such. If a user want
> the slot to be freed (which is ill-advised for a requirement here) it
> can invoke (un)register_kernel_hw_breakpoint() instead (would have very
> little overhead for the 1-CPU case without IPIs).


This adds unnecessary overhead. All we want is to update arch registers
when we schedule in/out an event.

We need to be able to free a slot for non-pinned counter because
an undefined number of events must be able to be time shared
in a single slot (in the worst case).

Calling unregister_kernel_breakpoint() each time we schedule out
a non-pinned counter adds unnecessary overhead. And calling
register_kernel_breakpoint() while enabling one is yet
another unnecessary overhead.

You'd need to check the free slots constraints every time for them.

