Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbZLMVv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbZLMVv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 16:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbZLMVuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 16:50:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:45633 "HELO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754403AbZLMVuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 16:50:44 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 5/6] perf session: Move the global threads list to perf_session
Date: Sun, 13 Dec 2009 19:50:28 -0200
Message-Id: <1260741029-4430-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1260741029-4430-1-git-send-email-acme@infradead.org>
References: <1260741029-4430-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we can process two perf.data files.

We still need to add a O_MMAP mode for perf_session so that we can do
all the mmap stuff in it.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    6 ++--
 tools/perf/builtin-kmem.c     |    4 +-
 tools/perf/builtin-report.c   |   10 +++---
 tools/perf/builtin-sched.c    |   68 ++++++++++++++++++++++++----------------
 tools/perf/builtin-top.c      |   19 +++++++----
 tools/perf/builtin-trace.c    |    4 +-
 tools/perf/util/data_map.c    |    4 +-
 tools/perf/util/event.c       |   18 +++++-----
 tools/perf/util/event.h       |    4 +-
 tools/perf/util/session.c     |    4 ++-
 tools/perf/util/session.h     |    5 +++
 tools/perf/util/thread.c      |   22 ++++++-------
 tools/perf/util/thread.h      |    4 +-
 13 files changed, 98 insertions(+), 74 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index a931b13..795f865 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -131,14 +131,14 @@ static int hist_entry__add(struct addr_location *al, u64 count)
 	return 0;
 }
 
-static int process_sample_event(event_t *event, struct perf_session *session __used)
+static int process_sample_event(event_t *event, struct perf_session *session)
 {
 	struct addr_location al;
 
 	dump_printf("(IP, %d): %d: %p\n", event->header.misc,
 		    event->ip.pid, (void *)(long)event->ip.ip);
 
-	if (event__preprocess_sample(event, &al, symbol_filter) < 0) {
+	if (event__preprocess_sample(event, session, &al, symbol_filter) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
@@ -479,7 +479,7 @@ static int __cmd_annotate(void)
 	}
 
 	if (verbose > 3)
-		threads__fprintf(stdout);
+		perf_session__fprintf(session, stdout);
 
 	if (verbose > 2)
 		dsos__fprintf(stdout);
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 237155f..de19495 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -311,7 +311,7 @@ process_raw_event(event_t *raw_event __used, void *data,
 	}
 }
 
-static int process_sample_event(event_t *event, struct perf_session *session __used)
+static int process_sample_event(event_t *event, struct perf_session *session)
 {
 	struct sample_data data;
 	struct thread *thread;
@@ -329,7 +329,7 @@ static int process_sample_event(event_t *event, struct perf_session *session __u
 		(void *)(long)data.ip,
 		(long long)data.period);
 
-	thread = threads__findnew(event->ip.pid);
+	thread = perf_session__findnew(session, event->ip.pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 26b9478..efa8147 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -600,7 +600,7 @@ static int validate_chain(struct ip_callchain *chain, event_t *event)
 	return 0;
 }
 
-static int process_sample_event(event_t *event, struct perf_session *session __used)
+static int process_sample_event(event_t *event, struct perf_session *session)
 {
 	struct sample_data data;
 	int cpumode;
@@ -636,7 +636,7 @@ static int process_sample_event(event_t *event, struct perf_session *session __u
 		}
 	}
 
-	thread = threads__findnew(data.pid);
+	thread = perf_session__findnew(session, data.pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			event->header.type);
@@ -679,9 +679,9 @@ static int process_sample_event(event_t *event, struct perf_session *session __u
 	return 0;
 }
 
-static int process_comm_event(event_t *event, struct perf_session *session __used)
+static int process_comm_event(event_t *event, struct perf_session *session)
 {
-	struct thread *thread = threads__findnew(event->comm.pid);
+	struct thread *thread = perf_session__findnew(session, event->comm.pid);
 
 	dump_printf(": %s:%d\n", event->comm.comm, event->comm.pid);
 
@@ -780,7 +780,7 @@ static int __cmd_report(void)
 	}
 
 	if (verbose > 3)
-		threads__fprintf(stdout);
+		perf_session__fprintf(session, stdout);
 
 	if (verbose > 2)
 		dsos__fprintf(stdout);
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 1e4e508..8d58d9e 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -730,18 +730,21 @@ struct trace_migrate_task_event {
 
 struct trace_sched_handler {
 	void (*switch_event)(struct trace_switch_event *,
+			     struct perf_session *,
 			     struct event *,
 			     int cpu,
 			     u64 timestamp,
 			     struct thread *thread);
 
 	void (*runtime_event)(struct trace_runtime_event *,
+			      struct perf_session *,
 			      struct event *,
 			      int cpu,
 			      u64 timestamp,
 			      struct thread *thread);
 
 	void (*wakeup_event)(struct trace_wakeup_event *,
+			     struct perf_session *,
 			     struct event *,
 			     int cpu,
 			     u64 timestamp,
@@ -754,6 +757,7 @@ struct trace_sched_handler {
 			   struct thread *thread);
 
 	void (*migrate_task_event)(struct trace_migrate_task_event *,
+			   struct perf_session *session,
 			   struct event *,
 			   int cpu,
 			   u64 timestamp,
@@ -763,6 +767,7 @@ struct trace_sched_handler {
 
 static void
 replay_wakeup_event(struct trace_wakeup_event *wakeup_event,
+		    struct perf_session *session __used,
 		    struct event *event,
 		    int cpu __used,
 		    u64 timestamp __used,
@@ -789,6 +794,7 @@ static u64 cpu_last_switched[MAX_CPUS];
 
 static void
 replay_switch_event(struct trace_switch_event *switch_event,
+		    struct perf_session *session __used,
 		    struct event *event,
 		    int cpu,
 		    u64 timestamp,
@@ -1022,6 +1028,7 @@ add_sched_in_event(struct work_atoms *atoms, u64 timestamp)
 
 static void
 latency_switch_event(struct trace_switch_event *switch_event,
+		     struct perf_session *session,
 		     struct event *event __used,
 		     int cpu,
 		     u64 timestamp,
@@ -1045,8 +1052,8 @@ latency_switch_event(struct trace_switch_event *switch_event,
 		die("hm, delta: %Ld < 0 ?\n", delta);
 
 
-	sched_out = threads__findnew(switch_event->prev_pid);
-	sched_in = threads__findnew(switch_event->next_pid);
+	sched_out = perf_session__findnew(session, switch_event->prev_pid);
+	sched_in = perf_session__findnew(session, switch_event->next_pid);
 
 	out_events = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
 	if (!out_events) {
@@ -1074,12 +1081,13 @@ latency_switch_event(struct trace_switch_event *switch_event,
 
 static void
 latency_runtime_event(struct trace_runtime_event *runtime_event,
+		     struct perf_session *session,
 		     struct event *event __used,
 		     int cpu,
 		     u64 timestamp,
 		     struct thread *this_thread __used)
 {
-	struct thread *thread = threads__findnew(runtime_event->pid);
+	struct thread *thread = perf_session__findnew(session, runtime_event->pid);
 	struct work_atoms *atoms = thread_atoms_search(&atom_root, thread, &cmp_pid);
 
 	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
@@ -1096,6 +1104,7 @@ latency_runtime_event(struct trace_runtime_event *runtime_event,
 
 static void
 latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
+		     struct perf_session *session,
 		     struct event *__event __used,
 		     int cpu __used,
 		     u64 timestamp,
@@ -1109,7 +1118,7 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 	if (!wakeup_event->success)
 		return;
 
-	wakee = threads__findnew(wakeup_event->pid);
+	wakee = perf_session__findnew(session, wakeup_event->pid);
 	atoms = thread_atoms_search(&atom_root, wakee, &cmp_pid);
 	if (!atoms) {
 		thread_atoms_insert(wakee);
@@ -1143,6 +1152,7 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 
 static void
 latency_migrate_task_event(struct trace_migrate_task_event *migrate_task_event,
+		     struct perf_session *session,
 		     struct event *__event __used,
 		     int cpu __used,
 		     u64 timestamp,
@@ -1158,7 +1168,7 @@ latency_migrate_task_event(struct trace_migrate_task_event *migrate_task_event,
 	if (profile_cpu == -1)
 		return;
 
-	migrant = threads__findnew(migrate_task_event->pid);
+	migrant = perf_session__findnew(session, migrate_task_event->pid);
 	atoms = thread_atoms_search(&atom_root, migrant, &cmp_pid);
 	if (!atoms) {
 		thread_atoms_insert(migrant);
@@ -1353,7 +1363,7 @@ static void sort_lat(void)
 static struct trace_sched_handler *trace_handler;
 
 static void
-process_sched_wakeup_event(void *data,
+process_sched_wakeup_event(void *data, struct perf_session *session,
 			   struct event *event,
 			   int cpu __used,
 			   u64 timestamp __used,
@@ -1370,7 +1380,8 @@ process_sched_wakeup_event(void *data,
 	FILL_FIELD(wakeup_event, cpu, event, data);
 
 	if (trace_handler->wakeup_event)
-		trace_handler->wakeup_event(&wakeup_event, event, cpu, timestamp, thread);
+		trace_handler->wakeup_event(&wakeup_event, session, event,
+					    cpu, timestamp, thread);
 }
 
 /*
@@ -1388,6 +1399,7 @@ static char next_shortname2 = '0';
 
 static void
 map_switch_event(struct trace_switch_event *switch_event,
+		 struct perf_session *session,
 		 struct event *event __used,
 		 int this_cpu,
 		 u64 timestamp,
@@ -1415,8 +1427,8 @@ map_switch_event(struct trace_switch_event *switch_event,
 		die("hm, delta: %Ld < 0 ?\n", delta);
 
 
-	sched_out = threads__findnew(switch_event->prev_pid);
-	sched_in = threads__findnew(switch_event->next_pid);
+	sched_out = perf_session__findnew(session, switch_event->prev_pid);
+	sched_in = perf_session__findnew(session, switch_event->next_pid);
 
 	curr_thread[this_cpu] = sched_in;
 
@@ -1466,7 +1478,7 @@ map_switch_event(struct trace_switch_event *switch_event,
 
 
 static void
-process_sched_switch_event(void *data,
+process_sched_switch_event(void *data, struct perf_session *session,
 			   struct event *event,
 			   int this_cpu,
 			   u64 timestamp __used,
@@ -1493,13 +1505,14 @@ process_sched_switch_event(void *data,
 			nr_context_switch_bugs++;
 	}
 	if (trace_handler->switch_event)
-		trace_handler->switch_event(&switch_event, event, this_cpu, timestamp, thread);
+		trace_handler->switch_event(&switch_event, session, event,
+					    this_cpu, timestamp, thread);
 
 	curr_pid[this_cpu] = switch_event.next_pid;
 }
 
 static void
-process_sched_runtime_event(void *data,
+process_sched_runtime_event(void *data, struct perf_session *session,
 			   struct event *event,
 			   int cpu __used,
 			   u64 timestamp __used,
@@ -1513,7 +1526,7 @@ process_sched_runtime_event(void *data,
 	FILL_FIELD(runtime_event, vruntime, event, data);
 
 	if (trace_handler->runtime_event)
-		trace_handler->runtime_event(&runtime_event, event, cpu, timestamp, thread);
+		trace_handler->runtime_event(&runtime_event, session, event, cpu, timestamp, thread);
 }
 
 static void
@@ -1533,7 +1546,8 @@ process_sched_fork_event(void *data,
 	FILL_FIELD(fork_event, child_pid, event, data);
 
 	if (trace_handler->fork_event)
-		trace_handler->fork_event(&fork_event, event, cpu, timestamp, thread);
+		trace_handler->fork_event(&fork_event, event,
+					  cpu, timestamp, thread);
 }
 
 static void
@@ -1547,7 +1561,7 @@ process_sched_exit_event(struct event *event,
 }
 
 static void
-process_sched_migrate_task_event(void *data,
+process_sched_migrate_task_event(void *data, struct perf_session *session,
 			   struct event *event,
 			   int cpu __used,
 			   u64 timestamp __used,
@@ -1563,12 +1577,13 @@ process_sched_migrate_task_event(void *data,
 	FILL_FIELD(migrate_task_event, cpu, event, data);
 
 	if (trace_handler->migrate_task_event)
-		trace_handler->migrate_task_event(&migrate_task_event, event, cpu, timestamp, thread);
+		trace_handler->migrate_task_event(&migrate_task_event, session,
+						 event, cpu, timestamp, thread);
 }
 
 static void
-process_raw_event(event_t *raw_event __used, void *data,
-		  int cpu, u64 timestamp, struct thread *thread)
+process_raw_event(event_t *raw_event __used, struct perf_session *session,
+		  void *data, int cpu, u64 timestamp, struct thread *thread)
 {
 	struct event *event;
 	int type;
@@ -1578,23 +1593,22 @@ process_raw_event(event_t *raw_event __used, void *data,
 	event = trace_find_event(type);
 
 	if (!strcmp(event->name, "sched_switch"))
-		process_sched_switch_event(data, event, cpu, timestamp, thread);
+		process_sched_switch_event(data, session, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_stat_runtime"))
-		process_sched_runtime_event(data, event, cpu, timestamp, thread);
+		process_sched_runtime_event(data, session, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_wakeup"))
-		process_sched_wakeup_event(data, event, cpu, timestamp, thread);
+		process_sched_wakeup_event(data, session, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_wakeup_new"))
-		process_sched_wakeup_event(data, event, cpu, timestamp, thread);
+		process_sched_wakeup_event(data, session, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_process_fork"))
 		process_sched_fork_event(data, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_process_exit"))
 		process_sched_exit_event(event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_migrate_task"))
-		process_sched_migrate_task_event(data, event, cpu, timestamp, thread);
+		process_sched_migrate_task_event(data, session, event, cpu, timestamp, thread);
 }
 
-static int process_sample_event(event_t *event,
-				struct perf_session *session __used)
+static int process_sample_event(event_t *event, struct perf_session *session)
 {
 	struct sample_data data;
 	struct thread *thread;
@@ -1615,7 +1629,7 @@ static int process_sample_event(event_t *event,
 		(void *)(long)data.ip,
 		(long long)data.period);
 
-	thread = threads__findnew(data.pid);
+	thread = perf_session__findnew(session, data.pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
@@ -1627,7 +1641,7 @@ static int process_sample_event(event_t *event,
 	if (profile_cpu != -1 && profile_cpu != (int)data.cpu)
 		return 0;
 
-	process_raw_event(event, data.raw_data, data.cpu, data.time, thread);
+	process_raw_event(event, session, data.raw_data, data.cpu, data.time, thread);
 
 	return 0;
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b13f426..0f7a4da 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -20,8 +20,9 @@
 
 #include "perf.h"
 
-#include "util/symbol.h"
 #include "util/color.h"
+#include "util/session.h"
+#include "util/symbol.h"
 #include "util/thread.h"
 #include "util/util.h"
 #include <linux/rbtree.h>
@@ -926,7 +927,8 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 	return 0;
 }
 
-static void event__process_sample(const event_t *self, int counter)
+static void event__process_sample(const event_t *self,
+				 struct perf_session *session, int counter)
 {
 	u64 ip = self->ip.ip;
 	struct sym_entry *syme;
@@ -946,7 +948,7 @@ static void event__process_sample(const event_t *self, int counter)
 		return;
 	}
 
-	if (event__preprocess_sample(self, &al, symbol_filter) < 0 ||
+	if (event__preprocess_sample(self, session, &al, symbol_filter) < 0 ||
 	    al.sym == NULL)
 		return;
 
@@ -1053,7 +1055,7 @@ static void perf_session__mmap_read_counter(struct perf_session *self,
 		}
 
 		if (event->header.type == PERF_RECORD_SAMPLE)
-			event__process_sample(event, md->counter);
+			event__process_sample(event, self, md->counter);
 		else
 			event__process(event, self);
 		old += size;
@@ -1157,10 +1159,13 @@ static int __cmd_top(void)
 	int i, counter;
 	int ret;
 	/*
-	 * XXX perf_session__new should allow passing a O_MMAP, so that all this
-	 * mmap reading, etc is encapsulated in it.
+	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
+	 * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
 	 */
-	struct perf_session *session = NULL;
+	struct perf_session *session = perf_session__new(NULL, O_WRONLY, false);
+
+	if (session == NULL)
+		return -ENOMEM;
 
 	if (target_pid != -1)
 		event__synthesize_thread(target_pid, event__process, session);
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index b7eb3fc..d765323 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -63,7 +63,7 @@ static char const		*input_name = "perf.data";
 
 static u64			sample_type;
 
-static int process_sample_event(event_t *event, struct perf_session *session __used)
+static int process_sample_event(event_t *event, struct perf_session *session)
 {
 	struct sample_data data;
 	struct thread *thread;
@@ -81,7 +81,7 @@ static int process_sample_event(event_t *event, struct perf_session *session __u
 		(void *)(long)data.ip,
 		(long long)data.period);
 
-	thread = threads__findnew(event->ip.pid);
+	thread = perf_session__findnew(session, event->ip.pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index ba2eb2c..44dea21 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -125,9 +125,9 @@ out:
 	return err;
 }
 
-static struct thread *perf_session__register_idle_thread(struct perf_session *self __used)
+static struct thread *perf_session__register_idle_thread(struct perf_session *self)
 {
-	struct thread *thread = threads__findnew(0);
+	struct thread *thread = perf_session__findnew(self, 0);
 
 	if (!thread || thread__set_comm(thread, "swapper")) {
 		pr_err("problem inserting idle task.\n");
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 40d8d84..2d09c29 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -189,9 +189,9 @@ void event__synthesize_threads(int (*process)(event_t *event,
 
 struct events_stats event__stats;
 
-int event__process_comm(event_t *self, struct perf_session *session __used)
+int event__process_comm(event_t *self, struct perf_session *session)
 {
-	struct thread *thread = threads__findnew(self->comm.pid);
+	struct thread *thread = perf_session__findnew(session, self->comm.pid);
 
 	dump_printf(": %s:%d\n", self->comm.comm, self->comm.pid);
 
@@ -212,7 +212,7 @@ int event__process_lost(event_t *self, struct perf_session *session __used)
 
 int event__process_mmap(event_t *self, struct perf_session *session)
 {
-	struct thread *thread = threads__findnew(self->mmap.pid);
+	struct thread *thread = perf_session__findnew(session, self->mmap.pid);
 	struct map *map = map__new(&self->mmap, MAP__FUNCTION,
 				   session->cwd, session->cwdlen);
 
@@ -231,10 +231,10 @@ int event__process_mmap(event_t *self, struct perf_session *session)
 	return 0;
 }
 
-int event__process_task(event_t *self, struct perf_session *session __used)
+int event__process_task(event_t *self, struct perf_session *session)
 {
-	struct thread *thread = threads__findnew(self->fork.pid);
-	struct thread *parent = threads__findnew(self->fork.ppid);
+	struct thread *thread = perf_session__findnew(session, self->fork.pid);
+	struct thread *parent = perf_session__findnew(session, self->fork.ppid);
 
 	dump_printf("(%d:%d):(%d:%d)\n", self->fork.pid, self->fork.tid,
 		    self->fork.ppid, self->fork.ptid);
@@ -300,11 +300,11 @@ try_again:
 	}
 }
 
-int event__preprocess_sample(const event_t *self, struct addr_location *al,
-			     symbol_filter_t filter)
+int event__preprocess_sample(const event_t *self, struct perf_session *session,
+			     struct addr_location *al, symbol_filter_t filter)
 {
 	u8 cpumode = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = threads__findnew(self->ip.pid);
+	struct thread *thread = perf_session__findnew(session, self->ip.pid);
 
 	if (thread == NULL)
 		return -1;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 6b6429b..bb09025 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -177,8 +177,8 @@ int event__process_mmap(event_t *self, struct perf_session *session);
 int event__process_task(event_t *self, struct perf_session *session);
 
 struct addr_location;
-int event__preprocess_sample(const event_t *self, struct addr_location *al,
-			     symbol_filter_t filter);
+int event__preprocess_sample(const event_t *self, struct perf_session *session,
+			     struct addr_location *al, symbol_filter_t filter);
 int event__parse_sample(event_t *event, u64 type, struct sample_data *data);
 
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 534a877..09836a5 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -51,7 +51,7 @@ out_close:
 struct perf_session *perf_session__new(const char *filename, int mode,
 				       bool force)
 {
-	size_t len = strlen(filename) + 1;
+	size_t len = filename ? strlen(filename) + 1 : 0;
 	struct perf_session *self = zalloc(sizeof(*self) + len);
 
 	if (self == NULL)
@@ -61,6 +61,8 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 		goto out_delete;
 
 	memcpy(self->filename, filename, len);
+	self->threads = RB_ROOT;
+	self->last_match = NULL;
 	self->mmap_window = 32;
 	self->cwd = NULL;
 	self->cwdlen = 0;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 1e0da9c..1dbef7c 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -3,11 +3,16 @@
 
 #include "event.h"
 #include "header.h"
+#include <linux/rbtree.h>
+
+struct thread;
 
 struct perf_session {
 	struct perf_header	header;
 	unsigned long		size;
 	unsigned long		mmap_window;
+	struct rb_root		threads;
+	struct thread		*last_match;
 	int			fd;
 	int			cwdlen;
 	char			*cwd;
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 5c0ab14..634b7f7 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -2,13 +2,11 @@
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
+#include "session.h"
 #include "thread.h"
 #include "util.h"
 #include "debug.h"
 
-static struct rb_root threads;
-static struct thread *last_match;
-
 void map_groups__init(struct map_groups *self)
 {
 	int i;
@@ -122,9 +120,9 @@ static size_t thread__fprintf(struct thread *self, FILE *fp)
 	       map_groups__fprintf(&self->mg, fp);
 }
 
-struct thread *threads__findnew(pid_t pid)
+struct thread *perf_session__findnew(struct perf_session *self, pid_t pid)
 {
-	struct rb_node **p = &threads.rb_node;
+	struct rb_node **p = &self->threads.rb_node;
 	struct rb_node *parent = NULL;
 	struct thread *th;
 
@@ -133,15 +131,15 @@ struct thread *threads__findnew(pid_t pid)
 	 * so most of the time we dont have to look up
 	 * the full rbtree:
 	 */
-	if (last_match && last_match->pid == pid)
-		return last_match;
+	if (self->last_match && self->last_match->pid == pid)
+		return self->last_match;
 
 	while (*p != NULL) {
 		parent = *p;
 		th = rb_entry(parent, struct thread, rb_node);
 
 		if (th->pid == pid) {
-			last_match = th;
+			self->last_match = th;
 			return th;
 		}
 
@@ -154,8 +152,8 @@ struct thread *threads__findnew(pid_t pid)
 	th = thread__new(pid);
 	if (th != NULL) {
 		rb_link_node(&th->rb_node, parent, p);
-		rb_insert_color(&th->rb_node, &threads);
-		last_match = th;
+		rb_insert_color(&th->rb_node, &self->threads);
+		self->last_match = th;
 	}
 
 	return th;
@@ -269,12 +267,12 @@ int thread__fork(struct thread *self, struct thread *parent)
 	return 0;
 }
 
-size_t threads__fprintf(FILE *fp)
+size_t perf_session__fprintf(struct perf_session *self, FILE *fp)
 {
 	size_t ret = 0;
 	struct rb_node *nd;
 
-	for (nd = rb_first(&threads); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&self->threads); nd; nd = rb_next(nd)) {
 		struct thread *pos = rb_entry(nd, struct thread, rb_node);
 
 		ret += thread__fprintf(pos, fp);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 2e35e1f..e93abf2 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -23,11 +23,11 @@ struct thread {
 void map_groups__init(struct map_groups *self);
 int thread__set_comm(struct thread *self, const char *comm);
 int thread__comm_len(struct thread *self);
-struct thread *threads__findnew(pid_t pid);
+struct thread *perf_session__findnew(struct perf_session *self, pid_t pid);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
 size_t map_groups__fprintf_maps(struct map_groups *self, FILE *fp);
-size_t threads__fprintf(FILE *fp);
+size_t perf_session__fprintf(struct perf_session *self, FILE *fp);
 
 void maps__insert(struct rb_root *maps, struct map *map);
 struct map *maps__find(struct rb_root *maps, u64 addr);
-- 
1.6.2.5

