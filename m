Return-Path: <linux-kernel-owner+w=401wt.eu-S1750934AbZIFEUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934AbZIFEUK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 00:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750724AbZIFEUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 00:20:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39270 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbZIFEUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 00:20:08 -0400
Date: Sun, 6 Sep 2009 06:19:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 00/18] tracing/ring-buffer: fixes for latency tracer
	[2.6.32]
Message-ID: <20090906041946.GA18071@elte.hu>
References: <20090904235527.520961911@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904235527.520961911@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Finally (something I should have realized from day 1, not 4 days 
> later) I realized I already had a marker. The latency tracers 
> always record the timestamp of when the trace began. I can simply 
> ignore any trace event that happened before that timestamp. This 
> ended up working out very well. The code is quite simple and 
> solid.

Yes - that trick came from the original latency tracer and i added 
it for that purpose.

The flip side is that if there's anything wrong with timestamps 
(and this does happen frequently as well) we suddenly have an empty 
trace and no explanation about what happened.

>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Steven Rostedt (18):
>       ring-buffer: do not reset while in a commit
>       ring-buffer: do not swap buffers during a commit
>       ring-buffer: remove unnecessary cpu_relax
>       ring-buffer: fix ring_buffer_read crossing pages
>       ring-buffer: remove ring_buffer_event_discard
>       ring-buffer: do not count discarded events
>       ring-buffer: disable all cpu buffers when one finds a problem
>       tracing: print out start and stop in latency traces
>       tracing: disable update max tracer while reading trace
>       tracing: disable buffers and synchronize_sched before resetting
>       tracing: remove users of tracing_reset
>       tracing: use timestamp to determine start of latency traces
>       tracing: make tracing_reset safe for external use
>       tracing: pass around ring buffer instead of tracer
>       tracing: add trace_array_printk for internal tracers to use
>       tracing: report error in trace if we fail to swap latency buffer
>       ring-buffer: check for swapped buffers in start of committing
>       ring-buffer: only enable ring_buffer_swap_cpu when needed
> 
> ----
>  include/linux/ftrace_event.h         |   15 ++-
>  include/linux/ring_buffer.h          |   23 +--
>  include/trace/ftrace.h               |   15 ++-
>  kernel/trace/Kconfig                 |    8 +
>  kernel/trace/blktrace.c              |   12 +-
>  kernel/trace/kmemtrace.c             |    4 +-
>  kernel/trace/ring_buffer.c           |  172 +++++++++++++-------
>  kernel/trace/trace.c                 |  297 ++++++++++++++++++++++++----------
>  kernel/trace/trace.h                 |   26 ++--
>  kernel/trace/trace_boot.c            |   16 +-
>  kernel/trace/trace_events.c          |    6 +-
>  kernel/trace/trace_functions_graph.c |   14 +-
>  kernel/trace/trace_irqsoff.c         |    3 +-
>  kernel/trace/trace_mmiotrace.c       |   10 +-
>  kernel/trace/trace_power.c           |   22 ++-
>  kernel/trace/trace_sched_switch.c    |   18 ++-
>  kernel/trace/trace_sched_wakeup.c    |    7 +-
>  kernel/trace/trace_syscalls.c        |   18 ++-
>  18 files changed, 444 insertions(+), 242 deletions(-)

Pulled, thanks a lot Steve!

We should also think about how to expose the function tracer, and 
in particular latency tracing functionality, via perf.

The most natural approach would be to expose it as a 'generic 
event' - and simply stream function tracing events as they happen.

The latency tracer itself could be exposed either as a generic 
event, or as a software counter. The difference there is that it 
needs a per counter 'max latency' state that controls whether a new 
trace is sent down the pipe.

This would allow very flexible tooling: for example one could do a 
dump of the maximum latency a particular workflow experiences [in a 
scheduling invariant manner] - without having to trace the full 
system. I.e. individual apps could be validated separately and 
latency impact on individual apps could be tracked more accurately 
as well.

(beyond the other usecases such as tracking cache-miss rates in 
addition to latencies - this would allow the observation of 
worst-case cachemisses correlating with large latencies, etc.)

Steve, Frederic, does any of you have interest (and time ;-) to 
look into that? It should probably have its own tooling variant, 
not be part of 'perf trace' per se (which is the generic tracing 
tool).
 
'perf latencytrace' or so - because latency tracing has its own 
special needs (for the same reason do we have a separate latency 
tracer ftrace plugin).

	Ingo
