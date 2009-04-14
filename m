Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbZDNR1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbZDNR1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbZDNR0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:26:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62362 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbZDNR0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:26:43 -0400
Message-Id: <20090414172337.280621613@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 14 Apr 2009 13:23:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: [PATCH 0/8] [GIT PULL] TRACE_EVENT for modules
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This is the long awaited TRACE_EVENT for modules patch series.

Not only does it allow for modules to use the TRACE_EVENT infrastructure,
but it also cleans up the way TRACE_EVENTS are used in core kernel code.

Some of the clean ups are:

Removal of the two headers per trace system. No need to have
include/trace/sched.h and include/linux/sched_event_types.h
All the changes go into include/trace/sched.h. But note that how that
file is made is important. One could look at the sched.h file, or
skb.h, lockdep.h and kmem.h as an example.

Another clean up is that I got rid of the need to add these files
into include/trace/trace_events.h and include/trace/trace_event_types.h.
Those files have been deleted.

Another clean up is that we do not need to do the DEFINE_TRACE(name)
for every TRACE_EVENT (or TRACE_FORMAT and DECLARE_TRACE) in the
include/trace/ header. One only needs to define a CREATE_TRACE_POINTS
in one C file to do the work for them:

#define CREATE_TRACE_POINTS
#inlude <trace/sched.h>

That will do the DEFINE_TRACE for every defined trace item in sched.h.

I also removed the trace_events_stage_X.h files and combined them
into a include/trace/ftrace.h file.

I made sure that each stage did not break the code. Well, I tested
kmem at each level. kmem seems to be the most complex of the trace events.

At the end I made a module and tested it out as well. I even removed
the module as the trace was running. Note, if you remove the file
and view the trace, you will get something like:

           <...>-4197  [002]   205.524992: Unknown type 47
           <...>-4197  [002]   206.523325: Unknown type 47
           <...>-4197  [002]   207.521665: Unknown type 47
           <...>-4197  [002]   208.520118: Unknown type 47

The unknown type will appear. This is because the format to print the
string is in the module itself. When the code is removed, ftrace has
no way of knowing how to print that string out. But if you had a user
space tool that read the format file first, it could still parse the binary
data just fine.

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Steven Rostedt (8):
      tracing: consolidate trace and trace_event headers
      tracing: create automated trace defines
      tracing: make trace_seq operations available for core kernel
      tracing/events: move declarations from trace directory to core include
      tracing/events: move the ftrace event tracing code to core
      tracing/events: convert event call sites to use a link list
      tracing/events: add export symbols for trace events in modules
      tracing/events: add support for modules to TRACE_EVENT

----
 include/linux/ftrace_event.h        |  150 +++++++++++
 include/linux/module.h              |    4 +
 include/linux/trace_seq.h           |   91 +++++++
 include/linux/tracepoint.h          |    9 +-
 include/trace/define_trace.h        |   79 ++++++
 include/trace/ftrace.h              |  493 +++++++++++++++++++++++++++++++++++
 include/trace/irq.h                 |   56 ++++-
 include/trace/irq_event_types.h     |   55 ----
 include/trace/kmem.h                |  189 +++++++++++++-
 include/trace/lockdep.h             |   55 ++++-
 include/trace/lockdep_event_types.h |   57 ----
 include/trace/sched.h               |  336 +++++++++++++++++++++++-
 include/trace/sched_event_types.h   |  337 ------------------------
 include/trace/skb.h                 |   39 +++-
 include/trace/skb_event_types.h     |   38 ---
 include/trace/trace_event_types.h   |    7 -
 include/trace/trace_events.h        |    7 -
 kernel/exit.c                       |    4 -
 kernel/fork.c                       |    2 -
 kernel/irq/handle.c                 |    7 +-
 kernel/kthread.c                    |    3 -
 kernel/lockdep.c                    |   12 +-
 kernel/module.c                     |    7 +
 kernel/sched.c                      |   10 +-
 kernel/signal.c                     |    2 -
 kernel/softirq.c                    |    3 -
 kernel/trace/Makefile               |    1 -
 kernel/trace/events.c               |   14 -
 kernel/trace/trace.c                |    3 +
 kernel/trace/trace.h                |  148 +----------
 kernel/trace/trace_event_profile.c  |    4 +-
 kernel/trace/trace_events.c         |  170 +++++++++----
 kernel/trace/trace_events_filter.c  |   10 +-
 kernel/trace/trace_events_stage_1.h |   39 ---
 kernel/trace/trace_events_stage_2.h |  170 ------------
 kernel/trace/trace_events_stage_3.h |  279 --------------------
 kernel/trace/trace_output.c         |    3 +
 kernel/trace/trace_output.h         |   30 +--
 mm/util.c                           |   11 +-
 net/core/net-traces.c               |    4 +-
 40 files changed, 1648 insertions(+), 1290 deletions(-)
-- 
