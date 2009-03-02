Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZCBUbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZCBUbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZCBUa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:30:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35940 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZCBUa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:30:27 -0500
Message-Id: <20090302203023.917737787@goodmis.org>
References: <20090302202925.364437449@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 02 Mar 2009 15:29:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/7] tracing: add TRACE_FIELD_SPECIAL to record complex entries
Content-Disposition: inline; filename=0001-tracing-add-TRACE_FIELD_SPECIAL-to-record-complex-e.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Tom Zanussi pointed out that the simple TRACE_FIELD was not enough to
record trace data that required memcpy. This patch addresses this issue
by adding a TRACE_FIELD_SPECIAL. The format is similar to TRACE_FIELD
but looks like so:

  TRACE_FIELD_SPECIAL(type_item, item, cmd)

What TRACE_FIELD gave was:

  TRACE_FIELD(type, item, assign)

The TRACE_FIELD would be used in declaring a structure:

  struct {
	type	item;
  };

And later assign it via:

  entry->item = assign;

What TRACE_FIELD_SPECIAL gives us is:

In the declaration of the structure:

  struct {
	type_item;
  };

And the assignment:

  cmd;

This change log will explain the one example used in the patch:

 TRACE_EVENT_FORMAT(sched_switch,
	TPPROTO(struct rq *rq, struct task_struct *prev,
		struct task_struct *next),
	TPARGS(rq, prev, next),
	TPFMT("task %s:%d ==> %s:%d",
	      prev->comm, prev->pid, next->comm, next->pid),
	TRACE_STRUCT(
		TRACE_FIELD(pid_t, prev_pid, prev->pid)
		TRACE_FIELD(int, prev_prio, prev->prio)
		TRACE_FIELD_SPECIAL(char next_comm[TASK_COMM_LEN],
				    next_comm,
				    TPCMD(memcpy(TRACE_ENTRY->next_comm,
						 next->comm,
						 TASK_COMM_LEN)))
		TRACE_FIELD(pid_t, next_pid, next->pid)
		TRACE_FIELD(int, next_prio, next->prio)
	),
	TPRAWFMT("prev %d:%d ==> next %s:%d:%d")
	);

 The struct will be create as:

  struct {
	pid_t		prev_pid;
	int		prev_prio;
	char next_comm[TASK_COMM_LEN];
	pid_t		next_pid;
	int		next_prio;
  };

Note the TRACE_ENTRY in the cmd part of TRACE_SPECIAL. TRACE_ENTRY will
be set by the tracer to point to the structure inside the trace buffer.

  entry->prev_pid	= prev->pid;
  entry->prev_prio	= prev->prio;
  memcpy(entry->next_comm, next->comm, TASK_COMM_LEN);
  entry->next_pid	= next->pid;
  entry->next_prio	= next->prio

Reported-by: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/trace/sched_event_types.h   |    7 ++++++-
 kernel/trace/trace_events_stage_1.h |    2 ++
 kernel/trace/trace_events_stage_2.h |    4 ++++
 kernel/trace/trace_events_stage_3.h |   14 ++++++++++++++
 4 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/include/trace/sched_event_types.h b/include/trace/sched_event_types.h
index ba059c1..a6de5c1 100644
--- a/include/trace/sched_event_types.h
+++ b/include/trace/sched_event_types.h
@@ -71,10 +71,15 @@ TRACE_EVENT_FORMAT(sched_switch,
 	TRACE_STRUCT(
 		TRACE_FIELD(pid_t, prev_pid, prev->pid)
 		TRACE_FIELD(int, prev_prio, prev->prio)
+		TRACE_FIELD_SPECIAL(char next_comm[TASK_COMM_LEN],
+				    next_comm,
+				    TPCMD(memcpy(TRACE_ENTRY->next_comm,
+						 next->comm,
+						 TASK_COMM_LEN)))
 		TRACE_FIELD(pid_t, next_pid, next->pid)
 		TRACE_FIELD(int, next_prio, next->prio)
 	),
-	TPRAWFMT("prev %d:%d ==> next %d:%d")
+	TPRAWFMT("prev %d:%d ==> next %s:%d:%d")
 	);
 
 TRACE_EVENT_FORMAT(sched_migrate_task,
diff --git a/kernel/trace/trace_events_stage_1.h b/kernel/trace/trace_events_stage_1.h
index fd3bf93..3830a73 100644
--- a/kernel/trace/trace_events_stage_1.h
+++ b/kernel/trace/trace_events_stage_1.h
@@ -30,5 +30,7 @@
 
 #define TRACE_FIELD(type, item, assign) \
 	type item;
+#define TRACE_FIELD_SPECIAL(type_item, item, cmd) \
+	type_item;
 
 #include <trace/trace_event_types.h>
diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
index 3eaaef5..dc79fe3 100644
--- a/kernel/trace/trace_events_stage_2.h
+++ b/kernel/trace/trace_events_stage_2.h
@@ -39,6 +39,10 @@
 #define TRACE_FIELD(type, item, assign) \
 	field->item,
 
+#undef TRACE_FIELD_SPECIAL
+#define TRACE_FIELD_SPECIAL(type_item, item, cmd) \
+	field->item,
+
 
 #undef TPRAWFMT
 #define TPRAWFMT(args...)	args
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index 7a161c4..2ab65e9 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -147,6 +147,20 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #define TRACE_FIELD(type, item, assign)\
 	entry->item = assign;
 
+#undef TRACE_FIELD
+#define TRACE_FIELD(type, item, assign)\
+	entry->item = assign;
+
+#undef TPCMD
+#define TPCMD(cmd...)	cmd
+
+#undef TRACE_ENTRY
+#define TRACE_ENTRY	entry
+
+#undef TRACE_FIELD_SPECIAL
+#define TRACE_FIELD_SPECIAL(type_item, item, cmd) \
+	cmd;
+
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
 _TRACE_FORMAT(call, PARAMS(proto), PARAMS(args), PARAMS(fmt))		\
-- 
1.5.6.5

-- 
