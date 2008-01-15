Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbYAOUyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbYAOUyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbYAOUum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:50:42 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:56898 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbYAOUuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:50:32 -0500
Message-Id: <20080115204907.838227723@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 15:49:07 -0500
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
       Jan Kiszka <jan.kiszka@siemens.com>
Subject: [RFC PATCH 00/30 v3] mcount and latency tracing utility -v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[
  version 3 of mcount patches:

  changes include:

  Made mcount be able to register more than one function to call.
  If only one function is registered, then it is called directly.
  If more than one is registered, then a loop function is called
  to call all registered functions.

  Add schedule context switch tracing.

  Added preemption off tracing.

  Removed recording of command line of task at each trace, and
  placed it into the scheduling trace, or at time of max
  preemption off.

  Renamed irqs off files to preempt prefixes.

 Suggested by Jan Kiszka:
  cleaned up calls to mcount (following glibc more)

  always call mcount_trace_function directly from assembly

 Suggested by Sam Ravnborg:

   Created CONFIG_HAVE_MCOUNT to be selected by archs
   instead of each are defining a new config option.

   Added time keeping fixes by John Stultz
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

Only one function may be registered at a time. If another function is
registered, it will simply override what ever was there previously.

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

fn_trace_ctrl
  echo 1 to this enables mcount tracing (if mcount_enabled is set)
  echo 0 to disable the function trace tracing.

function_trace
  Outputs the function trace in latency_trace format.

preempt_fn_trace_ctrl
  echo 1 to enable function tracing in critical sections timings
  echo 0 to disable

preempt_trace
  Outputs the critical section latency

preempt_thresh
  echo a number (in usecs) into this to record all traces that are
  greater than threshold.

iter_ctrl
  echo "symonly" to not show the instruction pointers in the trace
  echo "nosymonly" to disable symonly.
  echo "verbose" for verbose output from latency format.
  echo "noverbose" to disable verbose ouput.
  cat iter_ctrl to see the current settings.

preempt_max_latency
  Holds the current max critical latency.
  echo 0 to reset and start tracing.

trace
  simple output format of the function trace code.


Overhead:
---------

Note that having mcount compiled in seems to show a little overhead.

Here's 3 runs of hackbench 50 without the patches:
Time: 2.137
Time: 2.283
Time: 2.245

 Avg: 2.221

and here's 3 runs with the patches (without tracing on):
Time: 2.738
Time: 2.469
Time: 2.388

  Avg: 2.531

So it is a 13% overhead when enabled (according to hackbench).

But full tracing can cause a bit more problems:

# hackbench 50
Time: 113.350

  113.350!!!!!

But this is tracing *every* function call!


Future:
-------
The way the mcount hook is done here, other utilities can easily add their
own functions. Just care needs to be made not to call anything that is not
marked with notrace, or you will crash the box with recursion. But
even the simple tracer adds a "disabled" feature so in case it happens
to call something that is not marked with notrace, it is a safety net
not to kill the box.

I was originally going to use the relay system to record the data, but
that had a chance of calling functions not marked with notrace. But, if
for example LTTng wanted to use this, it could disable tracing on a CPU
when doing the calls, and this will protect from recusion.

SystemTap:
----------
One thing that Arnaldo and I discussed last year was using systemtap to
add hooks into the kernel to start and stop tracing.  kprobes is too
heavy to do on all funtion calls, but it would be perfect to add to
non hot paths to start the tracer and stop the tracer.

So when debugging the kernel, instead of recompiling with printks
or other markers, you could simply use systemtap to place a trace start
and stop locations and trace the problem areas to see what is happening.


Latency Tracing:
----------------

We can also add trace points to record the time the highest priority task
needs to wait before running. This too is currently done in the RT patch.


These are just some of the ideas we have with this. And we are sure others
could come up with more.

These patches are for the underlining work. We'll see what happens next.




