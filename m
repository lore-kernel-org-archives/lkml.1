Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbYA3DXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbYA3DXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbYA3DTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 22:19:09 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:49374 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbYA3DSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 22:18:51 -0500
Message-Id: <20080130031521.258552785@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jan 2008 22:15:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 00/22 -v7] mcount and latency tracing utility -v7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[
  version 7  (and hopefully last) of mcount / trace patches:

  changes include:

   Ported to lastest git 0ba6c33bcddc64a54b5f1c25a696c4767dc76292

   Moved the markers around so they would only be armed when used,
   this brings down the overhead dramatically.

   Added printing of the "to" process name in the sched switch output:
    ksoftirq-8     2d..3 120829us+:  8:49:S --> 11:115 group_balance
    group_ba-11    2d..3 120836us!:  11:115:S --> 0:140 <idle>

   Removed notrace to nmi handlers. I've tested it a little with
   NMIs and function trace, and it seems to work fine.

   added "disable" to available_tracers that will unregister all
   tracers when written into current_tracer.

   Ran new benchmarks and got better results! See below.
]

All released version of these patches can be found at:

   http://people.redhat.com/srostedt/tracing/


The following patch series brings to vanilla Linux a bit of the RT kernel
trace facility. This incorporates the "-pg" profiling option of gcc
that will call the "mcount" function for all functions called in
the kernel.

Note: I did investigate using -finstrument-functions but that adds a call
to both start and end of a function. Using mcount only does the
beginning of the function. mcount alone adds ~13% overhead. The
-finstrument-functions added ~19%.  Also it caused me to do tricks with
inline, because it adds the function calls to inline functions as well.

This patch series implements the code for x86 (32 and 64 bit), but
other archs can easily be implemented as well (note: ARM and PPC are
already implemented in -rt)

Some Background:
----------------

A while back, Ingo Molnar and William Lee Irwin III created a latency tracer
to find problem latency areas in the kernel for the RT patch.  This tracer
became a very integral part of the RT kernel in solving where latency hot
spots were.  One of the features that the latency tracer added was a
function trace.  This function tracer would record all functions that
were called (implemented by the gcc "-pg" option) and would show what was
called when interrupts or preemption was turned off.

This feature is also very helpful in normal debugging. So it's been talked
about taking bits and pieces from the RT latency tracer and bring them
to LKML. But no one had the time to do it.

Arnaldo Carvalho de Melo took a crack at it. He pulled out the mcount
as well as part of the tracing code and made it generic from the point
of the tracing code.  I'm not sure why this stopped. Probably because
Arnaldo is a very busy man, and his efforts had to be utilized elsewhere.

While I still maintain my own Logdev utility:

  http://rostedt.homelinux.com/logdev

I came across a need to do the mcount with logdev too. I was successful
but found that it became very dependent on a lot of code. One thing that
I liked about my logdev utility was that it was very non-intrusive, and has
been easy to port from the Linux 2.0 days. I did not want to burden the
logdev patch with the intrusiveness of mcount (not really that intrusive,
it just needs to add a "notrace" annotation to functions in the kernel
that will cause more conflicts in applying patches for me).

Being close to the holidays, I grabbed Arnaldos old patches and started
massaging them into something that could be useful for logdev, and what
I found out (and talking this over with Arnaldo too) that this can
be much more useful for others as well.

The main thing I changed, was that I made the mcount function itself
generic, and not the dependency on the tracing code.  That is I added

register_mcount_function()
 and
clear_mcount_function()

So when ever mcount is enabled and a function is registered that function
is called for all functions in the kernel that is not labeled with the
"notrace" annotation.


The Simple Tracer:
------------------

To show the power of this I also massaged the tracer code that Arnaldo pulled
from the RT patch and made it be a nice example of what can be done
with this.

The function that is registered to mcount has the prototype:

 void func(unsigned long ip, unsigned long parent_ip);

The ip is the address of the function and parent_ip is the address of
the parent function that called it.

The x86_64 version has the assembly call the registered function directly
to save having to do a double function call.

To enable mcount, a sysctl is added:

   /proc/sys/kernel/mcount_enabled

Once mcount is enabled, when a function is registed, it will be called by
all functions. The tracer in this patch series shows how this is done.
It adds a directory in the debugfs, called mctracer. With a ctrl file that
will allow the user have the tracer register its function.  Note, the order
of enabling mcount and registering a function is not important, but both
must be done to initiate the tracing. That is, you can disable tracing
by either disabling mcount or by clearing the registered function.

When one function is registered, it is called directly from the mcount
assembly. If more than one function is registered, a "loop" function
is called that calls all the registered functions.

Here's a simple example of the tracer output:

CPU 2: hackbench:11867 preempt_schedule+0xc/0x84 <-- avc_has_perm_noaudit+0x45d/0x52c
CPU 1: hackbench:12052 selinux_file_permission+0x10/0x11c <-- security_file_permission+0x16/0x18
CPU 3: hackbench:12017 update_curr+0xe/0x8b <-- put_prev_task_fair+0x24/0x4c
CPU 2: hackbench:11867 avc_audit+0x16/0x9e3 <-- avc_has_perm+0x51/0x63
CPU 0: hackbench:12019 socket_has_perm+0x16/0x7c <-- selinux_socket_sendmsg+0x27/0x3e
CPU 1: hackbench:12052 file_has_perm+0x16/0xbb <-- selinux_file_permission+0x104/0x11c

This is formated like:

 CPU <CPU#>: <task-comm>:<task-pid> <function> <-- <parent-function>


Latency Tracer Format:
----------------------

The format used by the RT patch is a bit more complex. It is designed to
record a lot of information quickly and dump out a lot too.

There's two versions of the format. Verbose and non-vebose.

verbose:

preemption latency trace v1.1.5 on 2.6.24-rc7-tst
--------------------------------------------------------------------
 latency: 89 us, #3/3, CPU#1 | (M:desktop VP:0, KP:0, SP:0 HP:0 #P:4)
    -----------------
    | task: kjournald-600 (uid:0 nice:-5 policy:0 rt_prio:0)
    -----------------
 => started at: _spin_lock_irqsave+0x2a/0x63 <c06310d2>
 => ended at:   _spin_unlock_irqrestore+0x32/0x41 <c0631245>

       kjournald   600 1 1 00000000 00000000 [397408f1] 0.003ms (+0.079ms): _spin_lock_irqsave+0x2a/0x63 <c06310d2> (scsi_dispatch_cmd+0x155/0x234 [scsi_mod] <f8867c19>)
       kjournald   600 1 1 00000000 00000001 [39740940] 0.081ms (+0.005ms): _spin_unlock_irqrestore+0x32/0x41 <c0631245> (scsi_dispatch_cmd+0x1be/0x234 [scsi_mod] <f8867c82>)
       kjournald   600 1 1 00000000 00000002 [39740945] 0.087ms (+0.000ms): trace_hardirqs_on_caller+0x74/0x86 <c0508bdc> (_spin_unlock_irqrestore+0x32/0x41 <c0631245>)


non-verbose:

preemption latency trace v1.1.5 on 2.6.24-rc7-tst
--------------------------------------------------------------------
 latency: 89 us, #3/3, CPU#2 | (M:desktop VP:0, KP:0, SP:0 HP:0 #P:4)
    -----------------
    | task: kjournald-600 (uid:0 nice:-5 policy:0 rt_prio:0)
    -----------------
 => started at: _spin_lock_irqsave+0x2a/0x63 <c06310d2>
 => ended at:   _spin_unlock_irqrestore+0x32/0x41 <c0631245>

                 _------=> CPU#            
                / _-----=> irqs-off        
               | / _----=> need-resched    
               || / _---=> hardirq/softirq 
               ||| / _--=> preempt-depth   
               |||| /                      
               |||||     delay             
   cmd     pid ||||| time  |   caller      
      \   /    |||||   \   |   /           
kjournal-600   1d...    3us+: _spin_lock_irqsave+0x2a/0x63 <c06310d2> (scsi_dispatch_cmd+0x155/0x234 [scsi_mod] <f8867c19>)
kjournal-600   1d...   81us+: _spin_unlock_irqrestore+0x32/0x41 <c0631245> (scsi_dispatch_cmd+0x1be/0x234 [scsi_mod] <f8867c82>)
kjournal-600   1d...   87us : trace_hardirqs_on_caller+0x74/0x86 <c0508bdc> (_spin_unlock_irqrestore+0x32/0x41 <c0631245>)


Debug FS:
---------

Although enabling and disabling mcount is done through the sysctl:

/proc/sys/kernel/mcount_enabled

The rest of the tracing uses debugfs.

/debugfs/tracing

Here's the available files:

 available_tracers
  Lists the tracers that are compiled into the kernel and can be
  echoed into current_tracer

 current_tracer
   Shows the current tracer that is registered. On bootup this is
   blank. To set a new tracer, simply echo into this file the name
   found in available_tracers. To unregister all tracers, echo
   "disable" into this file.

   e.g.

     echo wakeup > /debugfs/tracing/current_tracer

 trace_ctrl
   echo 1 to enable the current tracer.
   echo 0 to disable it.

    Note, the function trace also needs mcount_enabled set,
    otherwise it will not record.

 latency_trace
   Outputs the current trace in latency_trace format.

 tracing_thresh
   echo a number (in usecs) into this to record all traces that are
   greater than threshold. Only matters for those traces that use
   a max threshold (preemptoff irqsoff and wakeup)

 iter_ctrl
   echo "symonly" to not show the instruction pointers in the trace
   echo "nosymonly" to disable symonly.
   echo "verbose" for verbose output from latency format.
   echo "noverbose" to disable verbose ouput.
   cat iter_ctrl to see the current settings.

 tracing_max_latency
   Holds the current max critical latency.
   echo 0 to reset and start tracing.
   Only holds for those tracers that use a max setting.
   (preemptoff irqsoff and wakeup)

 trace
   simple output format of the current trace.

 latency_hist/
   This is a directory of histograms (when configured)
   This directory holds histograms for preemption off, irqs off,
   preemption and/or irqs off, and wakeup timings.
   (all numbers are in usecs)

Trace tool:
-----------

 The trace_cmd.c found at
   http://people.redhat.com/srostedt/tracing/trace-cmd.c

 This tool will set up the tracer and allow you to run a program
 and trace it. (must be root)

  e.g.

   # ./trace-cmd -f echo hi
   # cat /debug/tracing/latency_trace | grep echo | head
    echo-4240  1d..1 1076us : ret_from_fork+0x6/0x1c (schedule_tail+0x9/0x5e)
    echo-4240  1d..1 1077us : schedule_tail+0x1e/0x5e (finish_task_switch+0xb/0x61)
    echo-4240  1d..1 1078us : finish_task_switch+0x24/0x61 (_spin_unlock_irq+0x8/0x40)
    echo-4240  1...1 1079us : _spin_unlock_irq+0x27/0x40 (sub_preempt_count+0xd/0x104)
    echo-4240  1...1 1080us+: sub_preempt_count+0x8d/0x104 (in_lock_functions+0x8/0x2c)
    echo-4240  1d... 1082us : error_code+0x72/0x78 (do_page_fault+0xe/0x7c0)
    echo-4240  1d... 1083us : do_page_fault+0x35b/0x7c0 (add_preempt_count+0xc/0x10f)
    echo-4240  1d..1 1085us : add_preempt_count+0x53/0x10f (in_lock_functions+0x8/0x2c)
    echo-4240  1d..1 1086us : do_page_fault+0x38f/0x7c0 (sub_preempt_count+0xd/0x104)
    echo-4240  1d..1 1087us : sub_preempt_count+0x8d/0x104 (in_lock_functions+0x8/0x2c)


  The available switches are:

    -s - context switch tracing
    -p - preemption off tracing
    -i - interrupts off tracing
    -b - both interrupts off and preemption off tracing
    -w - wakeup timings
    -e - event tracing
    -f - function trace

  Only -f (function trace) may be enabled with the other tracers,
  since most the other tracers also have a function trace version
  if mcount is enabled (yes -f will enable mcount).


Overhead:
---------

Note that having mcount compiled in seems to show a little overhead.

Here's the new runs: Running "hackbench 50" 10 times each.

Without any of the patches:
  Avg: 4.1953 secs

With Event tracer, wakeup timings, context switch compiled in
but all turned off (marker overhead only).
  Avg: 4.2649 (1.66%)

Same config but event tracer registered but not enabled:
  Avg: 4.2717 (1.82%)

Event tracer enabled:
  Avg: 4.3249 (3.09%)

Wakeup registed but not enabled:
  Avg: 4.2942 (2.36%)

Wakeup enabled:
  Avg: 4.3124 (2.79%)

sched_switch registered but not enabled:
  Avg: 4.3118 (2.78%)

sched_switch enabled:
  Avg: 4.2552 (1.43%) /* seems to be in the noise */


Preempt off timings configured:
  preempt not enabled:
    Avg: 4.6768 (11.48%)

  preempt enabled:
    Avg: 9.1784 (118.78%) /* expected */

Irqs off timings configured:
  irqsoff not enabled:
    Avg: 4.7744 (13.80%)

  irqsoff enabled:
    Avg: 10.3651 (147.04%)

preempt off and irqs off configured:
  everything not enabled:
    Avg: 5.0823 (21.14%)

  irqsoff enabled:
    Avg: 16.0194 (281.84%)

  preemptoff enabled:
    Avg: 9.8112 (133.86%)

  preemptirqsoff enabled:
    Avg: 15.9543 (280.29%)

Mcount and function trace configured:

  mcount not enabled:
    4.8638 (15.93%) /* note - I removed a bit of notrace
                         which can increase this number */

  mcount enabled:
    6.2816 (49.74%)

  mcount and function tracing enabled:
    25.2035 (500.76%)  /* this may seem big, but this is down
                          from 113 secs! (2590%) */

Wakeup histogram configured (always on):
  Avg: 4.268 (1.73%)

irqs off histogram configured (always on):
  Avg: 6.9054 (64.60%)

preempt off histogram configured (always on):
  Avg: 5.8953 (40.52%)

irqs and preempt off histograms configured (always on):
  Avg: 14.808 (252.85%)

For full output of the above numbers see:
  http://people.redhat.com/srostedt/tracing/hack-results.cal

Wakeup timings, event trace and context switch tracing adds virtually no
overhead when configured.  The interrupt and preemption off, as well
as mcount does, and should only be in debugging kernels.

Future:
-------
The way the mcount hook is done here, other utilities can easily add their
own functions. Just care needs to be made not to call anything that is not
marked with notrace, or you will crash the box with recursion. But
even the simple tracer adds a "disabled" feature so in case it happens
to call something that is not marked with notrace, it is a safety net
not to kill the box.

I plan on looking into converting lockdep to use markers so that lockdep
and the preempt and irqs off tracers can be run time enabled without
adding much overhead when configured in.

SystemTap:
----------
One thing that Arnaldo and I discussed last year was using systemtap to
add hooks into the kernel to start and stop tracing.  kprobes is too
heavy to do on all funtion calls, but it would be perfect to add to
non hot paths to start the tracer and stop the tracer.

So when debugging the kernel, instead of recompiling with printks
or other markers, you could simply use systemtap to place a trace start
and stop locations and trace the problem areas to see what is happening.



These are just some of the ideas we have with this. And we are sure others
could come up with more.

These patches are for the underlining work. We'll see what happens next.




