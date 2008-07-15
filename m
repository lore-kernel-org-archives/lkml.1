Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbYGOO5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbYGOO5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYGOO5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:57:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35219 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbYGOO5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:57:37 -0400
Date: Tue, 15 Jul 2008 10:57:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Jon Masters <jonathan@jonmasters.org>,
       David Teigland <teigland@redhat.com>, John Kacur <jkacur@gmail.com>
Subject: [PATCH] ftrace: ftrace.txt updates
Message-ID: <Pine.LNX.4.58.0807151055070.10606@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch includes ftrace.txt updates that address (mostly) comments from
Andrew Morton. It also includes updates that were suggested by Randy
Dunlap, John Kacur and David Teigland.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 Documentation/ftrace.txt |  305 +++++++++++++++++++++++------------------------
 1 file changed, 152 insertions(+), 153 deletions(-)

Index: linus.git/Documentation/ftrace.txt
===================================================================
--- linus.git.orig/Documentation/ftrace.txt	2008-07-14 18:02:05.000000000 -0400
+++ linus.git/Documentation/ftrace.txt	2008-07-15 10:32:46.000000000 -0400
@@ -4,9 +4,10 @@
 Copyright 2008 Red Hat Inc.
    Author:   Steven Rostedt <srostedt@redhat.com>
   License:   The GNU Free Documentation License, Version 1.2
-Reviewers:   Elias Oltmanns and Randy Dunlap
+Reviewers:   Elias Oltmanns, Randy Dunlap, Andrew Morton,
+	     John Kacur, and David Teigland.

-Writen for: 2.6.26-rc8 linux-2.6-tip.git tip/tracing/ftrace branch
+Written for: 2.6.27-rc1

 Introduction
 ------------
@@ -18,10 +19,11 @@ issues that take place outside of user-s

 Although ftrace is the function tracer, it also includes an
 infrastructure that allows for other types of tracing. Some of the
-tracers that are currently in ftrace is a tracer to trace
+tracers that are currently in ftrace include a tracer to trace
 context switches, the time it takes for a high priority task to
 run after it was woken up, the time interrupts are disabled, and
-more.
+more (ftrace allows for tracer plugins, which means that the list of
+tracers can always grow).


 The File System
@@ -35,6 +37,8 @@ To mount the debugfs system:
   # mkdir /debug
   # mount -t debugfs nodev /debug

+(Note: it is more common to mount at /sys/kernel/debug, but for simplicity
+ this document will use /debug)

 That's it! (assuming that you have ftrace configured into your kernel)

@@ -50,20 +54,19 @@ of ftrace. Here is a list of some of the

   available_tracers : This holds the different types of tracers that
 		have been compiled into the kernel. The tracers
-		listed here can be configured by echoing in their
-		name into current_tracer.
+		listed here can be configured by echoing their name
+		into current_tracer.

   tracing_enabled : This sets or displays whether the current_tracer
 		is activated and tracing or not. Echo 0 into this
-		file to disable the tracer or 1 (or non-zero) to
-		enable it.
+		file to disable the tracer or 1 to enable it.

   trace : This file holds the output of the trace in a human readable
-		format.
+		format (described below).

   latency_trace : This file shows the same trace but the information
 		is organized more to display possible latencies
-		in the system.
+		in the system (described below).

   trace_pipe : The output is the same as the "trace" file but this
 		file is meant to be streamed with live tracing.
@@ -75,7 +78,7 @@ of ftrace. Here is a list of some of the
 		file, it is consumed, and will not be read
 		again with a sequential read. The "trace" and
 		"latency_trace" files are static, and if the
-		tracer isn't adding more data, they will display
+		tracer is not adding more data, they will display
 		the same information every time they are read.

   iter_ctrl : This file lets the user control the amount of data
@@ -92,10 +95,10 @@ of ftrace. Here is a list of some of the

   trace_entries : This sets or displays the number of trace
 		entries each CPU buffer can hold. The tracer buffers
-		are the same size for each CPU, so care must be
-		taken when modifying the trace_entries. The trace
-		buffers are allocated in pages (blocks of memory that
-		the kernel uses for allocation, usually 4 KB in size).
+		are the same size for each CPU. The displayed number
+		is the size of the CPU buffer and not total size. The
+		trace buffers are allocated in pages (blocks of memory
+		that the kernel uses for allocation, usually 4 KB in size).
 		Since each entry is smaller than a page, if the last
 		allocated page has room for more entries than were
 		requested, the rest of the page is used to allocate
@@ -112,20 +115,19 @@ of ftrace. Here is a list of some of the
 		on specified CPUS. The format is a hex string
 		representing the CPUS.

-  set_ftrace_filter : When dynamic ftrace is configured in, the
-		code is dynamically modified to disable calling
-		of the function profiler (mcount). This lets
-		tracing be configured in with practically no overhead
-		in performance.  This also has a side effect of
-		enabling or disabling specific functions to be
-		traced.  Echoing in names of functions into this
-		file will limit the trace to only these functions.
-
-  set_ftrace_notrace: This has the opposite effect that
-		set_ftrace_filter has. Any function that is added
-		here will not be traced. If a function exists
-		in both set_ftrace_filter and set_ftrace_notrace,
-		the function will _not_ be traced.
+  set_ftrace_filter : When dynamic ftrace is configured in (see the
+		section below "dynamic ftrace"), the code is dynamically
+		modified (code text rewrite) to disable calling of the
+		function profiler (mcount). This lets tracing be configured
+		in with practically no overhead in performance.  This also
+		has a side effect of enabling or disabling specific functions
+		to be traced. Echoing names of functions into this file
+		will limit the trace to only those functions.
+
+  set_ftrace_notrace: This has an effect opposite to that of
+		set_ftrace_filter. Any function that is added here will not
+		be traced. If a function exists in both set_ftrace_filter
+		and set_ftrace_notrace,	the function will _not_ be traced.

   available_filter_functions : When a function is encountered the first
 		time by the dynamic tracer, it is recorded and
@@ -133,32 +135,31 @@ of ftrace. Here is a list of some of the
 		lists the functions that have been recorded
 		by the dynamic tracer and these functions can
 		be used to set the ftrace filter by the above
-		"set_ftrace_filter" file.
+		"set_ftrace_filter" file. (See the section "dynamic ftrace"
+		below for more details).


 The Tracers
 -----------

-Here are the list of current tracers that can be configured.
+Here is the list of current tracers that may be configured.

   ftrace - function tracer that uses mcount to trace all functions.
-		It is possible to filter out which functions that are
-		to be traced when dynamic ftrace is configured in.

   sched_switch - traces the context switches between tasks.

-  irqsoff - traces the areas that disable interrupts and saves off
+  irqsoff - traces the areas that disable interrupts and saves
   		the trace with the longest max latency.
 		See tracing_max_latency.  When a new max is recorded,
 		it replaces the old trace. It is best to view this
-		trace with the latency_trace file.
+		trace via the latency_trace file.

-  preemptoff - Similar to irqsoff but traces and records the time
-		preemption is disabled.
+  preemptoff - Similar to irqsoff but traces and records the amount of
+		time for which preemption is disabled.

   preemptirqsoff - Similar to irqsoff and preemptoff, but traces and
-		 records the largest time irqs and/or preemption is
-		 disabled.
+		 records the largest time for which irqs and/or preemption
+		 is disabled.

   wakeup - Traces and records the max latency that it takes for
 		the highest priority task to get scheduled after
@@ -171,13 +172,13 @@ Here are the list of current tracers tha
 Examples of using the tracer
 ----------------------------

-Here are typical examples of using the tracers with only controlling
-them with the debugfs interface (without using any user-land utilities).
+Here are typical examples of using the tracers when controlling them only
+with the debugfs interface (without using any user-land utilities).

 Output format:
 --------------

-Here's an example of the output format of the file "trace"
+Here is an example of the output format of the file "trace"

                              --------
 # tracer: ftrace
@@ -189,14 +190,15 @@ Here's an example of the output format o
             bash-4251  [01] 10152.583855: _atomic_dec_and_lock <-dput
                              --------

-A header is printed with the trace that is represented. In this case
-the tracer is "ftrace". Then a header showing the format. Task name
-"bash", the task PID "4251", the CPU that it was running on
+A header is printed with the tracer name that is represented by the trace.
+In this case the tracer is "ftrace". Then a header showing the format. Task
+name "bash", the task PID "4251", the CPU that it was running on
 "01", the timestamp in <secs>.<usecs> format, the function name that was
 traced "path_put" and the parent function that called this function
-"path_walk".
+"path_walk". The timestamp is the time at which the function was
+entered.

-The sched_switch tracer also includes tracing of task wake ups and
+The sched_switch tracer also includes tracing of task wakeups and
 context switches.

      ksoftirqd/1-7     [01]  1453.070013:      7:115:R   +  2916:115:S
@@ -206,7 +208,7 @@ context switches.
      kondemand/1-2916  [01]  1453.070013:   2916:115:S ==>     7:115:R
      ksoftirqd/1-7     [01]  1453.070013:      7:115:S ==>     0:140:R

-Wake ups are represented by a "+" and the context switches show
+Wake ups are represented by a "+" and the context switches are shown as
 "==>".  The format is:

  Context switches:
@@ -221,7 +223,7 @@ Wake ups are represented by a "+" and th

   <pid>:<prio>:<state>    +  <pid>:<prio>:<state>

-The prio is the internal kernel priority, which is inverse to the
+The prio is the internal kernel priority, which is the inverse of the
 priority that is usually displayed by user-space tools. Zero represents
 the highest priority (99). Prio 100 starts the "nice" priorities with
 100 being equal to nice -20 and 139 being nice 19. The prio "140" is
@@ -232,7 +234,7 @@ Latency trace format
 --------------------

 For traces that display latency times, the latency_trace file gives
-a bit more information to see why a latency happened. Here's a typical
+somewhat more information to see why a latency happened. Here is a typical
 trace.

 # tracer: irqsoff
@@ -260,21 +262,20 @@ irqsoff latency trace v1.1.5 on 2.6.26-r
   <idle>-0     0d.s1   98us : trace_hardirqs_on (do_softirq)


-vim:ft=help

-
-This shows that the current tracer is "irqsoff" tracing the time
-interrupts are disabled. It gives the trace version and the kernel
-this was executed on (2.6.26-rc8). Then it displays the max latency
-in microsecs (97 us). The number of trace entries displayed
-by the total number recorded (both are three: #3/3). The type of
+This shows that the current tracer is "irqsoff" tracing the time for which
+interrupts were disabled. It gives the trace version and the version
+of the kernel upon which this was executed on (2.6.26-rc8). Then it displays
+the max latency in microsecs (97 us). The number of trace entries displayed
+and the total number recorded (both are three: #3/3). The type of
 preemption that was used (PREEMPT). VP, KP, SP, and HP are always zero
-and reserved for later use. #P is the number of online CPUS (#P:2).
+and are reserved for later use. #P is the number of online CPUS (#P:2).

-The task is the process that was running when the latency happened.
+The task is the process that was running when the latency occurred.
 (swapper pid: 0).

-The start and stop that caused the latencies:
+The start and stop (the functions in which the interrupts were disabled and
+enabled respectively) that caused the latencies:

   apic_timer_interrupt is where the interrupts were disabled.
   do_softirq is where they were enabled again.
@@ -286,14 +287,14 @@ explains which is which.

   pid: The PID of that process.

-  CPU#: The CPU that the process was running on.
+  CPU#: The CPU which the process was running on.

   irqs-off: 'd' interrupts are disabled. '.' otherwise.

   need-resched: 'N' task need_resched is set, '.' otherwise.

   hardirq/softirq:
-	'H' - hard irq happened inside a softirq.
+	'H' - hard irq occurred inside a softirq.
 	'h' - hard irq is running
 	's' - soft irq is running
 	'.' - normal context.
@@ -303,7 +304,7 @@ explains which is which.
 The above is mostly meaningful for kernel developers.

   time: This differs from the trace file output. The trace file output
-	included an absolute timestamp. The timestamp used by the
+	includes an absolute timestamp. The timestamp used by the
 	latency_trace file is relative to the start of the trace.

   delay: This is just to help catch your eye a bit better. And
@@ -385,7 +386,7 @@ Here are the available options:
 sched_switch
 ------------

-This tracer simply records schedule switches. Here's an example
+This tracer simply records schedule switches. Here is an example
 of how to use it.

  # echo sched_switch > /debug/tracing/current_tracer
@@ -421,8 +422,8 @@ the name of the trace and points to the
 is a misnomer since here it represents the wake ups and context
 switches.

-The sched_switch only lists the wake ups (represented with '+')
-and context switches ('==>') with the previous task or current
+The sched_switch file only lists the wake ups (represented with '+')
+and context switches ('==>') with the previous task or current task
 first followed by the next task or task waking up. The format for both
 of these is PID:KERNEL-PRIO:TASK-STATE. Remember that the KERNEL-PRIO
 is the inverse of the actual priority with zero (0) being the highest
@@ -437,7 +438,8 @@ The task states are:

  R - running : wants to run, may not actually be running
  S - sleep   : process is waiting to be woken up (handles signals)
- D - deep sleep : process must be woken up (ignores signals)
+ D - disk sleep (uninterruptible sleep) : process must be woken up
+					(ignores signals)
  T - stopped : process suspended
  t - traced  : process is being traced (with something like gdb)
  Z - zombie  : process waiting to be cleaned up
@@ -447,8 +449,8 @@ The task states are:
 ftrace_enabled
 --------------

-The following tracers give different output depending on whether
-or not the sysctl ftrace_enabled is set. To set ftrace_enabled,
+The following tracers (listed below) give different output depending
+on whether or not the sysctl ftrace_enabled is set. To set ftrace_enabled,
 one can either use the sysctl function or set it via the proc
 file system interface.

@@ -475,13 +477,12 @@ interrupt from triggering or the mouse i
 kernel know of a new mouse event. The result is a latency with the
 reaction time.

-The irqsoff tracer tracks the time interrupts are disabled to the time
-they are re-enabled. When a new maximum latency is hit, it saves off
-the trace so that it may be retrieved at a later time. Every time a
-new maximum in reached, the old saved trace is discarded and the new
-trace is saved.
+The irqsoff tracer tracks the time for which interrupts are disabled.
+When a new maximum latency is hit, the tracer saves the trace leading up
+to that latency point so that every time a new maximum is reached, the old
+saved trace is discarded and the new trace is saved.

-To reset the maximum, echo 0 into tracing_max_latency. Here's an
+To reset the maximum, echo 0 into tracing_max_latency. Here is an
 example:

  # echo irqsoff > /debug/tracing/current_tracer
@@ -493,14 +494,14 @@ example:
  # cat /debug/tracing/latency_trace
 # tracer: irqsoff
 #
-irqsoff latency trace v1.1.5 on 2.6.26-rc8
+irqsoff latency trace v1.1.5 on 2.6.26
 --------------------------------------------------------------------
- latency: 6 us, #3/3, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
+ latency: 12 us, #3/3, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
     -----------------
-    | task: bash-4269 (uid:0 nice:0 policy:0 rt_prio:0)
+    | task: bash-3730 (uid:0 nice:0 policy:0 rt_prio:0)
     -----------------
- => started at: copy_page_range
- => ended at:   copy_page_range
+ => started at: sys_setpgid
+ => ended at:   sys_setpgid

 #                _------=> CPU#
 #               / _-----=> irqs-off
@@ -511,21 +512,19 @@ irqsoff latency trace v1.1.5 on 2.6.26-r
 #              |||||     delay
 #  cmd     pid ||||| time  |   caller
 #     \   /    |||||   \   |   /
-    bash-4269  1...1    0us+: _spin_lock (copy_page_range)
-    bash-4269  1...1    7us : _spin_unlock (copy_page_range)
-    bash-4269  1...2    7us : trace_preempt_on (copy_page_range)
+    bash-3730  1d...    0us : _write_lock_irq (sys_setpgid)
+    bash-3730  1d..1    1us+: _write_unlock_irq (sys_setpgid)
+    bash-3730  1d..2   14us : trace_hardirqs_on (sys_setpgid)


-vim:ft=help
+Here we see that that we had a latency of 12 microsecs (which is
+very good). The _write_lock_irq in sys_setpgid disabled interrupts.
+The difference between the 12 and the displayed timestamp 14us occurred
+because the clock was incremented between the time of recording the max
+latency and the time of recording the function that had that latency.

-Here we see that that we had a latency of 6 microsecs (which is
-very good). The spin_lock in copy_page_range disabled interrupts.
-The difference between the 6 and the displayed timestamp 7us is
-because the clock must have incremented between the time of recording
-the max latency and recording the function that had that latency.
-
-Note the above had ftrace_enabled not set. If we set the ftrace_enabled,
-we get a much larger output:
+Note the above example had ftrace_enabled not set. If we set the
+ftrace_enabled, we get a much larger output:

 # tracer: irqsoff
 #
@@ -571,12 +570,10 @@ irqsoff latency trace v1.1.5 on 2.6.26-r
       ls-4339  0d..2   51us : trace_hardirqs_on (__alloc_pages_internal)


-vim:ft=help
-

 Here we traced a 50 microsecond latency. But we also see all the
 functions that were called during that time. Note that by enabling
-function tracing, we endure an added overhead. This overhead may
+function tracing, we incur an added overhead. This overhead may
 extend the latency times. But nevertheless, this trace has provided
 some very helpful debugging information.

@@ -590,8 +587,9 @@ for preemption to be enabled again befor
 priority task.

 The preemptoff tracer traces the places that disable preemption.
-Like the irqsoff, it records the maximum latency that preemption
-was disabled. The control of preemptoff is much like the irqsoff.
+Like the irqsoff tracer, it records the maximum latency for which preemption
+was disabled. The control of preemptoff tracer is much like the irqsoff
+tracer.

  # echo preemptoff > /debug/tracing/current_tracer
  # echo 0 > /debug/tracing/tracing_max_latency
@@ -625,8 +623,6 @@ preemptoff latency trace v1.1.5 on 2.6.2
     sshd-4261  0d.s1   30us : trace_preempt_on (__do_softirq)


-vim:ft=help
-
 This has some more changes. Preemption was disabled when an interrupt
 came in (notice the 'h'), and was enabled while doing a softirq.
 (notice the 's'). But we also see that interrupts have been disabled
@@ -694,16 +690,16 @@ The above is an example of the preemptof
 set. Here we see that interrupts were disabled the entire time.
 The irq_enter code lets us know that we entered an interrupt 'h'.
 Before that, the functions being traced still show that it is not
-in an interrupt, but we can see by the functions themselves that
+in an interrupt, but we can see from the functions themselves that
 this is not the case.

-Notice that the __do_softirq when called doesn't have a preempt_count.
-It may seem that we missed a preempt enabled. What really happened
-is that the preempt count is held on the threads stack and we
+Notice that __do_softirq when called does not have a preempt_count.
+It may seem that we missed a preempt enabling. What really happened
+is that the preempt count is held on the thread's stack and we
 switched to the softirq stack (4K stacks in effect). The code
 does not copy the preempt count, but because interrupts are disabled,
-we don't need to worry about it. Having a tracer like this is good
-to let people know what really happens inside the kernel.
+we do not need to worry about it. Having a tracer like this is good
+for letting people know what really happens inside the kernel.


 preemptirqsoff
@@ -713,7 +709,7 @@ Knowing the locations that have interrup
 disabled for the longest times is helpful. But sometimes we would
 like to know when either preemption and/or interrupts are disabled.

-The following code:
+Consider the following code:

     local_irq_disable();
     call_function_with_irqs_off();
@@ -769,12 +765,10 @@ preemptirqsoff latency trace v1.1.5 on 2
       ls-4860  0d.s1  294us : trace_preempt_on (__do_softirq)


-vim:ft=help
-

 The trace_hardirqs_off_thunk is called from assembly on x86 when
 interrupts are disabled in the assembly code. Without the function
-tracing, we don't know if interrupts were enabled within the preemption
+tracing, we do not know if interrupts were enabled within the preemption
 points. We do see that it started with preemption enabled.

 Here is a trace with ftrace_enabled set:
@@ -865,19 +859,19 @@ preemptirqsoff latency trace v1.1.5 on 2

 This is a very interesting trace. It started with the preemption of
 the ls task. We see that the task had the "need_resched" bit set
-with the 'N' in the trace.  Interrupts are disabled in the spin_lock
-and the trace started. We see that a schedule took place to run
+via the 'N' in the trace.  Interrupts were disabled before the spin_lock
+at the beginning of the trace. We see that a schedule took place to run
 sshd.  When the interrupts were enabled, we took an interrupt.
 On return from the interrupt handler, the softirq ran. We took another
-interrupt while running the softirq as we see with the capital 'H'.
+interrupt while running the softirq as we see from the capital 'H'.


 wakeup
 ------

-In Real-Time environment it is very important to know the wakeup
-time it takes for the highest priority task that wakes up to the
-time it executes. This is also known as "schedule latency".
+In a Real-Time environment it is very important to know the wakeup
+time it takes for the highest priority task that is woken up to the
+time that it executes. This is also known as "schedule latency".
 I stress the point that this is about RT tasks. It is also important
 to know the scheduling latency of non-RT tasks, but the average
 schedule latency is better for non-RT tasks. Tools like
@@ -926,8 +920,6 @@ wakeup latency trace v1.1.5 on 2.6.26-rc
   <idle>-0     1d..4    4us : schedule (cpu_idle)


-vim:ft=help
-

 Running this on an idle system, we see that it only took 4 microseconds
 to perform the task switch.  Note, since the trace marker in the
@@ -996,15 +988,15 @@ ksoftirq-7     1d..6   49us : sub_preemp
 ksoftirq-7     1d..4   50us : schedule (__cond_resched)

 The interrupt went off while running ksoftirqd. This task runs at
-SCHED_OTHER. Why didn't we see the 'N' set early? This may be
+SCHED_OTHER. Why did not we see the 'N' set early? This may be
 a harmless bug with x86_32 and 4K stacks. On x86_32 with 4K stacks
-configured, the interrupt and softirq runs with their own stack.
+configured, the interrupt and softirq run with their own stack.
 Some information is held on the top of the task's stack (need_resched
 and preempt_count are both stored there). The setting of the NEED_RESCHED
 bit is done directly to the task's stack, but the reading of the
 NEED_RESCHED is done by looking at the current stack, which in this case
 is the stack for the hard interrupt. This hides the fact that NEED_RESCHED
-has been set. We don't see the 'N' until we switch back to the task's
+has been set. We do not see the 'N' until we switch back to the task's
 assigned stack.

 ftrace
@@ -1044,14 +1036,14 @@ this tracer is a nop.
 [...]


-Note: It is sometimes better to enable or disable tracing directly from
-a program, because the buffer may be overflowed by the echo commands
-before you get to the point you want to trace. It is also easier to
-stop the tracing at the point that you hit the part that you are
-interested in. Since the ftrace buffer is a ring buffer with the
-oldest data being overwritten, usually it is sufficient to start the
-tracer with an echo command but have you code stop it. Something
-like the following is usually appropriate for this.
+Note: ftrace uses ring buffers to store the above entries. The newest data
+may overwrite the oldest data. Sometimes using echo to stop the trace
+is not sufficient because the tracing could have overwritten the data
+that you wanted to record. For this reason, it is sometimes better to
+disable tracing directly from a program. This allows you to stop the
+tracing at the point that you hit the part that you are interested in.
+To disable the tracing directly from a C program, something like following
+code snippet can be used:

 int trace_fd;
 [...]
@@ -1060,20 +1052,26 @@ int main(int argc, char *argv[]) {
 	trace_fd = open("/debug/tracing/tracing_enabled", O_WRONLY);
 	[...]
 	if (condition_hit()) {
-	write(trace_fd, "0", 1);
+		write(trace_fd, "0", 1);
 	}
 	[...]
 }

+Note: Here we hard coded the path name. The debugfs mount is not
+guaranteed to be at /debug (and is more commonly at /sys/kernel/debug).
+For simple one time traces, the above is sufficent. For anything else,
+a search through /proc/mounts may be needed to find where the debugfs
+file-system is mounted.

 dynamic ftrace
 --------------

-If CONFIG_DYNAMIC_FTRACE is set, then the system will run with
+If CONFIG_DYNAMIC_FTRACE is set, the system will run with
 virtually no overhead when function tracing is disabled. The way
 this works is the mcount function call (placed at the start of
 every kernel function, produced by the -pg switch in gcc), starts
-of pointing to a simple return.
+of pointing to a simple return. (Enabling FTRACE will include the
+-pg switch in the compiling of the kernel.)

 When dynamic ftrace is initialized, it calls kstop_machine to make
 the machine act like a uniprocessor so that it can freely modify code
@@ -1086,15 +1084,15 @@ Later on the ftraced kernel thread is aw
 kstop_machine if new functions have been recorded. The ftraced thread
 will change all calls to mcount to "nop".  Just calling mcount
 and having mcount return has shown a 10% overhead. By converting
-it to a nop, there is no recordable overhead to the system.
+it to a nop, there is no measurable overhead to the system.

 One special side-effect to the recording of the functions being
-traced, is that we can now selectively choose which functions we
-want to trace and which ones we want the mcount calls to remain as
+traced is that we can now selectively choose which functions we
+wish to trace and which ones we want the mcount calls to remain as
 nops.

 Two files are used, one for enabling and one for disabling the tracing
-of recorded functions. They are:
+of specified functions. They are:

   set_ftrace_filter

@@ -1116,7 +1114,7 @@ pick_next_task_fair
 mutex_lock
 [...]

-If I'm only interested in sys_nanosleep and hrtimer_interrupt:
+If I am only interested in sys_nanosleep and hrtimer_interrupt:

  # echo sys_nanosleep hrtimer_interrupt \
 		> /debug/tracing/set_ftrace_filter
@@ -1133,21 +1131,21 @@ If I'm only interested in sys_nanosleep
           usleep-4134  [00]  1317.070111: sys_nanosleep <-syscall_call
           <idle>-0     [00]  1317.070115: hrtimer_interrupt <-smp_apic_timer_interrupt

-To see what functions are being traced, you can cat the file:
+To see which functions are being traced, you can cat the file:

  # cat /debug/tracing/set_ftrace_filter
 hrtimer_interrupt
 sys_nanosleep


-Perhaps this isn't enough. The filters also allow simple wild cards.
+Perhaps this is not enough. The filters also allow simple wild cards.
 Only the following are currently available

   <match>*  - will match functions that begin with <match>
   *<match>  - will match functions that end with <match>
   *<match>* - will match functions that have <match> in it

-Thats all the wild cards that are allowed.
+These are the only wild cards which are supported.

   <match>*<match> will not work.

@@ -1258,15 +1256,15 @@ calls that need to be converted into nop
 it simply goes back to sleep. But if there are some, it will call
 kstop_machine to convert the calls to nops.

-There may be a case that you do not want this added latency.
+There may be a case in which you do not want this added latency.
 Perhaps you are doing some audio recording and this activity might
 cause skips in the playback. There is an interface to disable
-and enable the ftraced kernel thread.
+and enable the "ftraced" kernel thread.

  # echo 0 > /debug/tracing/ftraced_enabled

-This will disable the calling of the kstop_machine to update the
-mcount calls to nops. Remember that there's a large overhead
+This will disable the calling of kstop_machine to update the
+mcount calls to nops. Remember that there is a large overhead
 to calling mcount. Without this kernel thread, that overhead will
 exist.

@@ -1282,8 +1280,8 @@ that uses ftrace function recording.
 trace_pipe
 ----------

-The trace_pipe outputs the same as trace, but the effect on the
-tracing is different. Every read from trace_pipe is consumed.
+The trace_pipe outputs the same content as the trace file, but the effect
+on the tracing is different. Every read from trace_pipe is consumed.
 This means that subsequent reads will be different. The trace
 is live.

@@ -1313,7 +1311,7 @@ is live.
             bash-4043  [00] 41.267111: select_task_rq_rt <-try_to_wake_up


-Note, reading the trace_pipe will block until more input is added.
+Note, reading the trace_pipe file will block until more input is added.
 By changing the tracer, trace_pipe will issue an EOF. We needed
 to set the ftrace tracer _before_ cating the trace_pipe file.

@@ -1322,7 +1320,7 @@ trace entries
 -------------

 Having too much or not enough data can be troublesome in diagnosing
-some issue in the kernel. The file trace_entries is used to modify
+an issue in the kernel. The file trace_entries is used to modify
 the size of the internal trace buffers. The number listed
 is the number of entries that can be recorded per CPU. To know
 the full size, multiply the number of possible CPUS with the
@@ -1332,7 +1330,8 @@ number of entries.
 65620

 Note, to modify this, you must have tracing completely disabled. To do that,
-echo "none" into the current_tracer.
+echo "none" into the current_tracer. If the current_tracer is not set
+to "none", an EINVAL error will be returned.

  # echo none > /debug/tracing/current_tracer
  # echo 100000 > /debug/tracing/trace_entries
@@ -1341,18 +1340,18 @@ echo "none" into the current_tracer.


 Notice that we echoed in 100,000 but the size is 100,045. The entries
-are held by individual pages. It allocates the number of pages it takes
+are held in individual pages. It allocates the number of pages it takes
 to fulfill the request. If more entries may fit on the last page
-it will add them.
+then they will be added.

  # echo 1 > /debug/tracing/trace_entries
  # cat /debug/tracing/trace_entries
 85

-This shows us that 85 entries can fit on a single page.
+This shows us that 85 entries can fit in a single page.

-The number of pages that will be allocated is a percentage of available
-memory. Allocating too much will produce an error.
+The number of pages which will be allocated is limited to a percentage
+of available memory. Allocating too much will produce an error.

  # echo 1000000000000 > /debug/tracing/trace_entries
 -bash: echo: write error: Cannot allocate memory
