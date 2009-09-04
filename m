Return-Path: <linux-kernel-owner+w=401wt.eu-S934185AbZIEABY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934185AbZIEABY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934138AbZIEABW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:01:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62175 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933947AbZIEABT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:01:19 -0400
Message-Id: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 00/18] tracing/ring-buffer: fixes for latency tracer [2.6.32]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

I can port these over to -rt if you want, or you could just
add them yourself. I know the spinlocks need to be converted to atomic.
Just let me know if you want me to do it.

Ingo,

This patch series started out fixing a single bug that Arnaldo ran into
with the -rt patch series. I've hit it too and wrote a patch to solve it.
Unfortunately the patch was racey and error prone and would crash easily
in Arnaldo's setup.

The problem was with the wakeup latency tracer. When it was developed,
it controlled what went into the ring buffer. But now that we have
events, which can write into the ring buffer at anytime unless they are
disabled. When a max latency is encountered, the buffers are swapped
and the running ring buffer is reset. But if a commit is happening
at this time, it will be corrupted.

Luckily the ring buffer is robust enough to detect this and instead of
crashing the kernel, it safely disables the ring buffer and outputs
a back trace. But this does not help the developer that wants the trace.

Talking with Thomas Gleixner, we both agreed that resetting the ring
buffer on the fly was dangerous. Instead we should insert a marker and
use that as the start of the trace.

I thought this would be an easy change, but after a week of debugging,
fixing bugs just to create two new ones for every one I fixed, this
was not as easy as I thought.

The problem was that you can not write a marker in a buffer that is
not on the same CPU as the writer. I tried to add flags to make the
ring buffer reset itself when a new write happens on that CPU but
that just proved to be even more racey.

Finally (something I should have realized from day 1, not 4 days later)
I realized I already had a marker. The latency tracers always record
the timestamp of when the trace began. I can simply ignore any trace
event that happened before that timestamp. This ended up working out
very well. The code is quite simple and solid.

But this journey through the marker bits was not all in vain. I actually
came across several outstanding bugs in both the tracer and the ring buffer.
Nothing major, but enough to be fixed.

Not just the latency tracers could cause a corruption, but the reset
of the ring buffers by the switching of plugins could also cause it.
All resets must synchronize the disabling of the ring buffers with any
current writers.

Next I found that the swapping of the buffers with the wakeup tracer
was causing issues. The events would use the trace_array variable *tr
to access the buffers. tr->buffer to reserve space on the buffer
and then tr->buffer to commit it. The problem is that the wakeup
tracer swaps the tr->buffer with the max_tr.buffer. The commit can
happen on another buffer than what it started with. This again would
be detected by the ring buffer and would shut it down. The solution
here was to change the API to the writing of ftrace to pass in
the buffer directly and not the trace_array. Thus the events would pass
in the same buffer for both the reserve and the commit. It's OK
to update the max_tr on the wakeup tracer.

The irqsoff trace posed a different problem. It does not swap the
buffers, but it swaps a per cpu buffer within the buffer. This
can be done because the irqsoff tracer only records per cpu and does
not record the events of other cpus. But if a latency is detected
in the middle of a commit (commits can be preempted by interrupts) then
we can not swap the buffer. This is a tougher problem and I currently
do not have solution since it would require a copy of one buffer to the
other. Perhaps in the future. But instead of just failing, I added a
print into the buffer to notify the users that this has occurred.
They will now see:

# tracer: irqsoff
#
# irqsoff latency trace v1.1.5 on 2.6.31-rc5
# --------------------------------------------------------------------
# latency: 151 us, #1/1, CPU#3 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
#    -----------------
#    | task: -4328 (uid:0 nice:0 policy:0 rt_prio:0)
#    -----------------
#  => started at: save_args
#  => ended at:   __do_softirq
#
#
#                  _------=> CPU#            
#                 / _-----=> irqs-off        
#                | / _----=> need-resched    
#                || / _---=> hardirq/softirq 
#                ||| / _--=> preempt-depth   
#                |||| /                      
#                |||||     delay             
#  cmd     pid   ||||| time  |   caller      
#     \   /      |||||   \   |   /           
    bash-4328    3d.s5  167us : update_max_tr_single: Failed to swap buffers due to commit in progress

Which is better than a wrong trace. It still shows the max latency and the
start and stop points. Note, this run had lockdep enabled with locking
events on, which spews a lot of events after a latency has been hit
(the 167 entry with respect to the 151 max). This should not be too big of
a deal since it took a while loop of constant resettng of the max latency
and greping for this failure to hit it.

Because the irqsoff tracer swaps the internal ring buffer cpus,
a check needs to be added in the recording to handle this. Because this
check is only needed for swapping the internal buffers, and the irqsoff
(and preemptoff) tracer is the only user. I only do this if they
are configured (keep the overhead down).

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Steven Rostedt (18):
      ring-buffer: do not reset while in a commit
      ring-buffer: do not swap buffers during a commit
      ring-buffer: remove unnecessary cpu_relax
      ring-buffer: fix ring_buffer_read crossing pages
      ring-buffer: remove ring_buffer_event_discard
      ring-buffer: do not count discarded events
      ring-buffer: disable all cpu buffers when one finds a problem
      tracing: print out start and stop in latency traces
      tracing: disable update max tracer while reading trace
      tracing: disable buffers and synchronize_sched before resetting
      tracing: remove users of tracing_reset
      tracing: use timestamp to determine start of latency traces
      tracing: make tracing_reset safe for external use
      tracing: pass around ring buffer instead of tracer
      tracing: add trace_array_printk for internal tracers to use
      tracing: report error in trace if we fail to swap latency buffer
      ring-buffer: check for swapped buffers in start of committing
      ring-buffer: only enable ring_buffer_swap_cpu when needed

----
 include/linux/ftrace_event.h         |   15 ++-
 include/linux/ring_buffer.h          |   23 +--
 include/trace/ftrace.h               |   15 ++-
 kernel/trace/Kconfig                 |    8 +
 kernel/trace/blktrace.c              |   12 +-
 kernel/trace/kmemtrace.c             |    4 +-
 kernel/trace/ring_buffer.c           |  172 +++++++++++++-------
 kernel/trace/trace.c                 |  297 ++++++++++++++++++++++++----------
 kernel/trace/trace.h                 |   26 ++--
 kernel/trace/trace_boot.c            |   16 +-
 kernel/trace/trace_events.c          |    6 +-
 kernel/trace/trace_functions_graph.c |   14 +-
 kernel/trace/trace_irqsoff.c         |    3 +-
 kernel/trace/trace_mmiotrace.c       |   10 +-
 kernel/trace/trace_power.c           |   22 ++-
 kernel/trace/trace_sched_switch.c    |   18 ++-
 kernel/trace/trace_sched_wakeup.c    |    7 +-
 kernel/trace/trace_syscalls.c        |   18 ++-
 18 files changed, 444 insertions(+), 242 deletions(-)
-- 
