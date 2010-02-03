Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab0BCJOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:14:40 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57321 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab0BCJOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:14:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JVDvLQlDwbLYriut+WAZVYoGuIhdQEnE2RgGv3XMxtw1MMHsbI+yKXav+8ZlP+xdTW
         sFTxBxB/6vUQLC6vaaVKFxZRnVApa1azUsA+zb8uR1HwC6UxbRjSwnVSdouiban+INYB
         GdiLAGLkvhfSzFX5r6TnidW7rr7E05WYem3j0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [RFC GIT PULL] perf/trace/lock optimization/scalability improvements
Date: Wed,  3 Feb 2010 10:14:24 +0100
Message-Id: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are many things that happen in this patchset, treating
different problems:

- remove most of the string copy overhead in fast path
- open the way for lock class oriented profiling (as
  opposite to lock instance profiling. Both can be useful
  in different ways).
- remove the buffers muliplexing (less contention)
- event injection support
- remove violent lock events recursion (only 2 among 3, the remaining
  one is detailed below).

Some differences, by running:
	perf lock record perf sched pipe -l 100000

Before the patchset:

	Total time: 91.015 [sec]

	     910.157300 usecs/op
		   1098 ops/sec

After this patchset applied:

	Total time: 43.706 [sec]

	     437.062080 usecs/op
		   2288 ops/sec

Although it's actually 50 secs after the very latest patch in this
series. It is supposed to bring more scalability (and I believe it
does on a box with more than two cpus, although I can't test).
But multiplexing the counters had a side effect: perf record has
only one buffer to eat and not 5 * NR_CPUS, which makes its job
a bit easier when we multiplex (at the cost of cpus contention of
course, but on my atom, the scalability gain is not very visible).

And also, after this odd patch:

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 98fd360..254b3d4 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3094,7 +3094,8 @@ static u32 perf_event_tid(struct perf_event *event, struct task_struct *p)
        if (event->parent)
                event = event->parent;
 
-       return task_pid_nr_ns(p, event->ns);
+       return p->pid;
 }

We get:

	Total time: 26.170 [sec]

	     261.707960 usecs/op
		   3821 ops/sec

Ie: 2x faster than this patchset, and more than 3x faster than
tip:/perf/core

This is because task_pid_nr_ns() takes a lock and creates
lock events recursion. We really need to fix that.

You can pull this patchset from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

Thanks.


---

Frederic Weisbecker (11):
      tracing: Add lock_class_init event
      tracing: Introduce TRACE_EVENT_INJECT
      tracing: Inject lock_class_init events on registration
      tracing: Add lock class id in lock_acquire event
      perf: New PERF_EVENT_IOC_INJECT ioctl
      perf: Handle injection ioctl with trace events
      perf: Handle injection iotcl for tracepoints from perf record
      perf/lock: Add support for lock_class_init events
      tracing: Remove the lock name from most lock events
      tracing/perf: Fix lock events recursions in the fast path
      perf lock: Drop the buffers multiplexing dependency


 include/linux/ftrace_event.h       |    6 +-
 include/linux/lockdep.h            |    4 +
 include/linux/perf_event.h         |    6 +
 include/linux/tracepoint.h         |    3 +
 include/trace/define_trace.h       |    6 +
 include/trace/events/lock.h        |   57 ++++--
 include/trace/ftrace.h             |   31 +++-
 kernel/lockdep.c                   |   16 ++
 kernel/perf_event.c                |   47 ++++-
 kernel/trace/trace_event_profile.c |   46 +++--
 kernel/trace/trace_events.c        |    3 +
 tools/perf/builtin-lock.c          |  345 ++++++++++++++++++++++++++++++++----
 tools/perf/builtin-record.c        |    9 +
 13 files changed, 497 insertions(+), 82 deletions(-)
