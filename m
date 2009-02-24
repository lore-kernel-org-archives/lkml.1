Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbZBXTfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbZBXTfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 14:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbZBXTez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 14:34:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33580 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbZBXTey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 14:34:54 -0500
Message-Id: <20090224193344.638329210@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 24 Feb 2009 14:33:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 0/4][RFC] event tracer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is still RFC, do not pull.

This patch set gives the ability to add a format string and args to
a trace point declaration. Then it gives a tracer an opportunity to
override the header macro and use the default trace format to trace
the object.

For example (and used in this patch series), the sched tracepoint
declarations are moved from include/trace/sched.h to
include/trace/sched_event_types.h, and instead of using the macro
DECLARE_TRACE we use DECLARE_TRACE_FMT. The first three arguments
are the same, but it adds 2 more arguments. A printf format and
arguments.

The new trace/sched.h file contains:

  #include <linux/sched.h>
  #include <linux/tracepoint.h>

  #include <trace/sched_event_types.h>

The sched_event_types.h file has:

 DECLARE_TRACE_FMT(sched_kthread_stop,
        TPPROTO(struct task_struct *t),
                  TPARGS(t),
                   "task %s:%d", TPARGS(t->comm, t->pid));

The tracepoint.h defines DECLARE_TRACE_FMT as:

 #define DECLARE_TRACE_FMT(name, proto, args, fmt, fmt_args) \
        DECLARE_TRACE(name, TPPROTO(proto), TPARGS(args))


But in kernel/trace/events.c we have:

 /* trace/<type>.h here */
 #include <trace/sched.h>

 #include "trace_events.h"

 /* trace/<type>_event_types.h here */
 #include <trace/sched_event_types.h>

The trace_events.h redefines the DECLARE_TRACE_FMT and makes a hook
for to automate adding event points.

To add event points, convert to the DECLARE_TRACE_FMT, add your default
printf format, and then add to events.c, the <type>.h and <type>_event_types.h
as described. Then your trace points will appear in the event tracer.

Next I'll convert the rest of the tracepoints that are already defined
to this format.


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: rfc/event_tracer


Steven Rostedt (4):
      tracing: add event trace infrastructure
      tracing: add DECLARE_TRACE_FMT to tracepoint.h
      tracing: add schedule events to event trace
      tracing: make event directory structure

----
 include/asm-generic/vmlinux.lds.h |   11 +-
 include/linux/tracepoint.h        |    3 +
 include/trace/sched.h             |   49 +-----
 include/trace/sched_event_types.h |   74 +++++++
 kernel/trace/Kconfig              |    9 +
 kernel/trace/Makefile             |    2 +
 kernel/trace/events.c             |   13 ++
 kernel/trace/trace_events.c       |  407 +++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_events.h       |   52 +++++
 9 files changed, 571 insertions(+), 49 deletions(-)
-- 
