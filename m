Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbYGKVAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbYGKVAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 17:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYGKU77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:59:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35727 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYGKU75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:59:57 -0400
Date: Fri, 11 Jul 2008 16:59:53 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Elias Oltmanns <eo@nebensachen.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH -v2] ftrace: Documentation
In-Reply-To: <20080711121655.05810822.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0807111546560.25977@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
 <87zlop7bp6.fsf@denkblock.local> <20080710132832.38cc5048.randy.dunlap@oracle.com>
 <Pine.LNX.4.58.0807101956120.7719@gandalf.stny.rr.com>
 <Pine.LNX.4.58.0807102035550.7719@gandalf.stny.rr.com>
 <20080711121655.05810822.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew,

Thank you so much for reading over this. I see you have two types of
comments in this review. One is fixing my general bad use of the English
language (which was greatly needed), and the other is questions on the
implementation of the ftrace tool itself.

This email will skip all the helpful grammar fixes and concentrate on the
questions concerning ftrace. I'll send out a patch later that fixes the
grammar that you suggested.


On Fri, 11 Jul 2008, Andrew Morton wrote:

> > +
> > +The File System
> > +---------------
> > +
> > +Ftrace uses the debugfs file system to hold the control files as well
> > +as the files to display output.
> > +
> > +To mount the debugfs system:
> > +
> > +  # mkdir /debug
> > +  # mount -t debugfs nodev /debug
>
> This should be a reference to the debugfs documentation (rofl?) rather than
> a reimplementation of it.

heh, is this a reference to the lack of debugfs documentation. I don't
feel qualified to creat that document.  Doing a quick search in
Documentation directory seems to point out a lot of "instructions" on
debugfs. Well, it was only three lines, not much of a repeat in text.

> > +  tracing_enabled : This sets or displays whether the current_tracer
> > +		is activated and tracing or not. Echo 0 into this
> > +		file to disable the tracer or 1 (or non-zero) to
> > +		enable it.
>
> kernel should only permit 0 or 1 (IMO).  This is a kernel ABI, not a C
> program.

Sure, not a problem to do that. I always like to have options (hacks) that
give different meanings for different things echo'd in. I haven't
implemented it here, but I kept that option open. Actually, I think I did
that for debugging.

But those are hacks or debugging that I could add when I need them. I'll
write up a patch to handle that.

>
> > +  trace : This file holds the output of the trace in a human readable
> > +		format.
>
> "described below" (I hope)

yep

>
> > +  latency_trace : This file shows the same trace but the information
> > +		is organized more to display possible latencies
> > +		in the system.
>
> ?
>
> > +  trace_pipe : The output is the same as the "trace" file but this
> > +		file is meant to be streamed with live tracing.
>
> We have three slightly munged versions of the same data?  wtf?
>
> Would it not be better to present all the data a single time and perform
> post-processing in userspace?
>
> It's scary, but we _can_ ship userspace code.  getdelays.c has worked well.
> Baby steps.

We had this conversation before. I'll talk more about this down below.

But, trace_pipe acts different than trace. trace_pipe consumes the trace
entries, but trace_pipe doesn't work for the tracers that have a
max_latency (irqsoff, wakeup, etc) (which reminds me, I need to add that
fact to this document).

ftrace has plugins. These tracers here are the ones that are in the
ftrace branch in the linux-tip.git repo.  But we are adding other plugins,
an the trace_pipe was to satisfy them, not these tracers.

>
> > +		Reads from this file will block until new data
> > +		is retrieved. Unlike the "trace" and "latency_trace"
> > +		files, this file is a consumer. This means reading
> > +		from this file causes sequential reads to display
> > +		more current data.
>
> hrm.

dedededdeeeeeeeeee ;-)

>
> > Once data is read from this
> > +		file, it is consumed, and will not be read
> > +		again with a sequential read. The "trace" and
> > +		"latency_trace" files are static, and if the
> > +		tracer isn't adding more data, they will display
> > +		the same information every time they are read.
>
> hrm.  Side note: it is sad that we are learning fundamental design
> decisions ages after the code was put into mainline.  How did this happen?
>
> In a better world we'd have seen this document before coding started!  Or
> at least prior to merging.

Well, the code went through a lot of changes. It started out in the -rt
kernel years ago. But that time it wasn't written for mainline in mind.
Lots of people in the -rt community saw the benefits of the tracer and
asked us to port it to mainline outside of -rt. Everytime I went to write
this document, the code changed. It was a work in progress.


> > +
> > +  trace_entries : This sets or displays the number of trace
> > +		entries each CPU buffer can hold. The tracer buffers
> > +		are the same size for each CPU, so care must be
> > +		taken when modifying the trace_entries.
>
> I don't understand "A, so care must be taken when B".  Why must care be
> taken?  What might happen if I was careless?  How do I take care?  Type
> slowly?  ;)

Actually I never finished my thought there. I should remove that "take
care" comment out completely.

> > +
> > +  tracing_cpumask : This is a mask that lets the user only trace
> > +		on specified CPUS. The format is a hex string
> > +		representing the CPUS.
>
> Why is this feature useful?  (I'd have asked this prior to merging, if I'd
> known it existed!)

I can't comment on this. I didn't write that code, I just added it to
the document because I saw it existed. This was added by Ingo and Thomas,
without much description to why. I think it allows you to limit which
CPUS to perform the trace on.

>
> > +  set_ftrace_filter : When dynamic ftrace is configured in, the
>
> I guess we'll learn later what "dynamic" ftrace is.

yep ;-)

>
> > +		code is dynamically modified to disable calling
> > +		of the function profiler (mcount).
>
> What does "dynamically modified" mean here?  text rewriting?

Yes.

>
> > +  preemptirqsoff - Similar to irqsoff and preemptoff, but traces and
> > +		 records the largest time irqs and/or preemption is
> > +		 disabled.
>
> s/time/time for which/
>
> This interface has a strange mix of wordsruntogether and
> words_separated_by_underscores.  Oh well - another consequence of
> post-facto changelogging.

I should make sched_switch to schedswitch and that way we have the files
having underscores and the tracers without them. Or should I add
underscores to all of them?

>
> > +  wakeup - Traces and records the max latency that it takes for
> > +		the highest priority task to get scheduled after
> > +		it has been woken up.
> > +
> > +  none - This is not a tracer. To remove all tracers from tracing
> > +		simply echo "none" into current_tracer.
>
> Does the system then run at full performance levels?

I should probably document that each of the above tracers have their own
configuration option, with the exception of preemptirqsoff which is turned
on if both preemptoff and irqsoff is on.  The reason I say this is that
the tracing of the irqsoff and preemption off has a slight overhead
(although implementing them with markers and the like might help).

But setting "none" with just sched_switch ftrace (wih dynamic ftracing)
and wakeup configured in brings the system back to full performance level.


> > +
> > +Here's an example of the output format of the file "trace"
> > +
> > +                             --------
> > +# tracer: ftrace
> > +#
> > +#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
> > +#              | |      |          |         |
> > +            bash-4251  [01] 10152.583854: path_put <-path_walk
> > +            bash-4251  [01] 10152.583855: dput <-path_put
> > +            bash-4251  [01] 10152.583855: _atomic_dec_and_lock <-dput
> > +                             --------
>
> pids are no longer unique system-wide, and any part of the kernel ABI which
> exports them to userspace is, basically, broken.  Oh well.

What should be used instead?  Of course we're not using a kernel ABI, we
are using an API (text based ;-) But more on that later.

>
> > +priority that is usually displayed by user-space tools. Zero represents
> > +the highest priority (99). Prio 100 starts the "nice" priorities with
> > +100 being equal to nice -20 and 139 being nice 19. The prio "140" is
> > +reserved for the idle task which is the lowest priority thread (pid 0).
>
> Would it not be better to convert these back into their userland
> representation or userland presentation?

Yes. I've thought about doing that, and I had already documented to a
customer what the prios were, so I was hesitant about making the change.
It would be easy to do. I think it would be better in the long run to
make all priorities outputed to match user space. Perhaps I'll do the "ps"
thing and have nice levels positive and RT priorities negative.

> > +# tracer: irqsoff
> > +#
> > +irqsoff latency trace v1.1.5 on 2.6.26-rc8
> > +--------------------------------------------------------------------
> > + latency: 97 us, #3/3, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> > +    -----------------
> > +    | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
> > +    -----------------
> > + => started at: apic_timer_interrupt
> > + => ended at:   do_softirq
> > +
> > +#                _------=> CPU#
> > +#               / _-----=> irqs-off
> > +#              | / _----=> need-resched
> > +#              || / _---=> hardirq/softirq
> > +#              ||| / _--=> preempt-depth
> > +#              |||| /
> > +#              |||||     delay
> > +#  cmd     pid ||||| time  |   caller
> > +#     \   /    |||||   \   |   /
> > +  <idle>-0     0d..1    0us+: trace_hardirqs_off_thunk (apic_timer_interrupt)
> > +  <idle>-0     0d.s.   97us : __do_softirq (do_softirq)
> > +  <idle>-0     0d.s1   98us : trace_hardirqs_on (do_softirq)
>
> The kernel prints all that stuff out of a debugfs file?
>
> What have we done? :(

This is very helpful on embedded systems.

>
> > +
> > +vim:ft=help
>
> What's this?

A relic. When I first started rewriting the -rt patch lantency tracer to
aim it at mainline, Ingo suggested that I should keep the output format
the same, since there are lots of tools that parse this information (for
the -rt patch). One of the things that Ingo had was this "vim" command.
I'd be happy to nuke it.

> > +
> > +  apic_timer_interrupt is where the interrupts were disabled.
> > +  do_softirq is where they were enabled again.
> > +
> > +The next lines after the header are the trace itself. The header
> > +explains which is which.
> > +
> > +  cmd: The name of the process in the trace.
> > +
> > +  pid: The PID of that process.
>
> :(

What should we use?

>
> > +	latency_trace file is relative to the start of the trace.
> > +
> > +  delay: This is just to help catch your eye a bit better. And
> > +	needs to be fixed to be only relative to the same CPU.
>
> eh?

We use the latency tracer part for finding bad latencies. One thing that
helps the human eye catch bad areas is this little notation.

>
> > +	The marks are determined by the difference between this
> > +	current trace and the next trace.
> > +	 '!' - greater than preempt_mark_thresh (default 100)
> > +	 '+' - greater than 1 microsecond
> > +	 ' ' - less than or equal to 1 microsecond.
> > +
> > +  The rest is the same as the 'trace' file.
> > +
> > +

[...]

> > +
> > +  raw - This will display raw numbers. This option is best for use with
> > +	user applications that can translate the raw numbers better than
> > +	having it done in the kernel.
>
> ooh, does this mean that we get to delete all the other interfaces?
>
> I mean, honestly, all this pretty-printing and post-processing could and
> should have been done in userspace.  As much as poss.  We suck.

Funny, I never have used this option. But yes, it helps for userspace
to use it.  I can write code to parse this out. ftrace is used a lot
on embedded systems and having it where we don't need user land to display
the trace has been beneficial to users of this tool.

If you are suggesting that the kernel comes with its own user land app
(in scripts/ ?) to handle all the new tracers, then maybe it would be
OK.

A lot of this code has also been designed around my logdev tracer which
I've been porting since the 2.1 days. I plan on adding one of logdev's
features to ftrace too. The "dump log on crash".  I could have a kdump
kernel read the logs too, but this gets even more complex because of
the way the ftrace buffers are allocated. We use the page structure to
link list all the ftrace buffers together. Parsing out the page structures
to read the ftrace buffer from kdump would be very difficult (but not
impossible). Having the ftrace dump to printk on a crash could be very
informative. At least have that until we come up with a way to get
the data after booting kdump.


>
> > +  hex - Similar to raw, but the numbers will be in a hexadecimal format.
>
> Does really this need to exist?  Again, it is the sort of thing which would
> have needed justification during the pre-merge review.  But afaik it was
> jammed into the tree without knowledge or comment.
>
> There are lessons here.

I haven't used this feature either, and not sure why it is there.

>
> > +  bin - This will print out the formats in raw binary.
>
> I don't understand this.

"raw" is ASCII hexidecimal output, where as "bin" is actual binary.

>
> > +  block - TBD (needs update)
> > +
> > +  stacktrace - This is one of the options that changes the trace itself.
> > +		When a trace is recorded, so is the stack of functions.
> > +		This allows for back traces of trace sites.
>
> ?

Ah, I need to document this. This is a cool feature. At certain locations
this tracer will trace the stack back trace.  I've toyed with this feature
so I didn't know enough to document it.


> > +first followed by the next task or task waking up. The format for both
> > +of these is PID:KERNEL-PRIO:TASK-STATE. Remember that the KERNEL-PRIO
> > +is the inverse of the actual priority with zero (0) being the highest
> > +priority and the nice values starting at 100 (nice -20). Below is
> > +a quick chart to map the kernel priority to user land priorities.
> > +
> > +  Kernel priority: 0 to 99    ==> user RT priority 99 to 0
> > +  Kernel priority: 100 to 139 ==> user nice -20 to 19
> > +  Kernel priority: 140        ==> idle task priority
> > +
> > +The task states are:
> > +
> > + R - running : wants to run, may not actually be running
> > + S - sleep   : process is waiting to be woken up (handles signals)
> > + D - deep sleep : process must be woken up (ignores signals)
>
> "uninterruptible sleep", please.  no need to invent new (and hence
> unfamilar) terms!

This is my own ignorance.  I didn't know the best way to say it. Why do
we use 'D' for "uninterruptible sleep"? I don't see a 'D' in there? But
"deep sleep" is more obvious. OK, I'll shut up and change it to
"uniterruptible sleep".


>
> > + T - stopped : process suspended
> > + t - traced  : process is being traced (with something like gdb)
> > + Z - zombie  : process waiting to be cleaned up
> > + X - unknown
> > +
> > +
> > +ftrace_enabled
> > +--------------
> > +
> > +The following tracers give different output depending on whether
> > +or not the sysctl ftrace_enabled is set. To set ftrace_enabled,
> > +one can either use the sysctl function or set it via the proc
> > +file system interface.
> > +
> > +  sysctl kernel.ftrace_enabled=1
> > +
> > + or
> > +
> > +  echo 1 > /proc/sys/kernel/ftrace_enabled
> > +
> > +To disable ftrace_enabled simply replace the '1' with '0' in
> > +the above commands.
> > +
> > +When ftrace_enabled is set the tracers will also record the functions
> > +that are within the trace. The descriptions of the tracers
> > +will also show an example with ftrace enabled.
>
> What are "the following tracers" here?

They are "irqsoff" "preemptoff" "preemptirqsoff" "wakeup" "sched_switch"
etc. Oh, I should state that?

> > +    -----------------
> > +    | task: bash-4269 (uid:0 nice:0 policy:0 rt_prio:0)
> > +    -----------------
> > + => started at: copy_page_range
> > + => ended at:   copy_page_range
> > +
> > +#                _------=> CPU#
> > +#               / _-----=> irqs-off
> > +#              | / _----=> need-resched
> > +#              || / _---=> hardirq/softirq
> > +#              ||| / _--=> preempt-depth
> > +#              |||| /
> > +#              |||||     delay
> > +#  cmd     pid ||||| time  |   caller
> > +#     \   /    |||||   \   |   /
> > +    bash-4269  1...1    0us+: _spin_lock (copy_page_range)
> > +    bash-4269  1...1    7us : _spin_unlock (copy_page_range)
> > +    bash-4269  1...2    7us : trace_preempt_on (copy_page_range)
>
> istr writing stuff which does this in 1999 ;)

Why didn't you add it to the kernel then? ;-)

>
> > +
> > +vim:ft=help
>
> ?

Bah!

>
> > +Here we see that that we had a latency of 6 microsecs (which is
> > +very good). The spin_lock in copy_page_range disabled interrupts.
>
> spin_lock disables interrutps?

Hmm, that trace is tracing preemption off :-?  Either a bug in my code, or
a cut and paste error.

[...]

> > +
> > +Note: It is sometimes better to enable or disable tracing directly from
> > +a program, because the buffer may be overflowed by the echo commands
> > +before you get to the point you want to trace.
>
> What does this mean?

It means we do a hula dance around the memory buffers. ;-)

OK, that needs to be rewritten. It is basically saying that ftrace uses a
ring buffer and if the buffer size is not big enough, running the echo
commands may overflow the buffers before you get any useful information.

[...]

>
> > +virtually no overhead when function tracing is disabled. The way
> > +this works is the mcount function call (placed at the start of
> > +every kernel function, produced by the -pg switch in gcc), starts
> > +of pointing to a simple return.
>
> So some config option enabled -pg?

Yes, FTRACE does. I should add here what each of the config options do
and what is affected by them.

[..]

> > +Perhaps you are doing some audio recording and this activity might
> > +cause skips in the playback. There is an interface to disable
> > +and enable the ftraced kernel thread.
>
> Oh.  Is the term "ftraced" the name of a kernel thread?  I'd been thinking
> it referred to "something which is being ftraced".

hehe, duly noted.

[..]


> > +the size of the internal trace buffers. The number listed
> > +is the number of entries that can be recorded per CPU. To know
> > +the full size, multiply the number of possible CPUS with the
> > +number of entries.
>
> How do I know the number of possible CPUs?  Within an order of magnitude?
> Is it in dmesg, perhaps?

Good question?  I used NR_CPUS, I would like to change this to be online
CPUS but small steps first.  Is NR_CPUS exported somewhere?


>
> > + # cat /debug/tracing/trace_entries
> > +65620
> > +
> > +Note, to modify this, you must have tracing completely disabled. To do that,
> > +echo "none" into the current_tracer.
>
> What happens if I forgot?

It fails with a -EINVAL.  I got burnt by that too when demonstarting this
to someone. But it doesn't crash the system ;-)


Oh well, I hope it wasn't too painful for you.

-- Steve

