Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbZLMVvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbZLMVvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 16:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbZLMVut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 16:50:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47499 "HELO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754410AbZLMVup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 16:50:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/6] perf session: Pass the perf_session to the event handling operations
Date: Sun, 13 Dec 2009 19:50:24 -0200
Message-Id: <1260741029-4430-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

They will need it to get the right threads list, etc.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c  |    2 +-
 tools/perf/builtin-kmem.c      |    2 +-
 tools/perf/builtin-record.c    |   11 +++++++----
 tools/perf/builtin-report.c    |    9 ++++-----
 tools/perf/builtin-sched.c     |    6 ++++--
 tools/perf/builtin-timechart.c |   13 +++++--------
 tools/perf/builtin-top.c       |   28 +++++++++++++++++-----------
 tools/perf/builtin-trace.c     |   23 ++++++++++-------------
 tools/perf/util/data_map.c     |   27 ++++++++++++++-------------
 tools/perf/util/data_map.h     |    5 ++++-
 tools/perf/util/event.c        |   37 +++++++++++++++++++++++--------------
 tools/perf/util/event.h        |   19 +++++++++++++------
 12 files changed, 103 insertions(+), 79 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 21a78d3..2e418b9 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -132,7 +132,7 @@ static int hist_entry__add(struct addr_location *al, u64 count)
 	return 0;
 }
 
-static int process_sample_event(event_t *event)
+static int process_sample_event(event_t *event, struct perf_session *session __used)
 {
 	struct addr_location al;
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 2071d24..101b268 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -312,7 +312,7 @@ process_raw_event(event_t *raw_event __used, void *data,
 	}
 }
 
-static int process_sample_event(event_t *event)
+static int process_sample_event(event_t *event, struct perf_session *session __used)
 {
 	struct sample_data data;
 	struct thread *thread;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4decbd1..b7e15a1 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -123,7 +123,8 @@ static void write_event(event_t *buf, size_t size)
 	write_output(buf, size);
 }
 
-static int process_synthesized_event(event_t *event)
+static int process_synthesized_event(event_t *event,
+				     struct perf_session *self __used)
 {
 	write_event(event, event->header.size);
 	return 0;
@@ -488,9 +489,10 @@ static int __cmd_record(int argc, const char **argv)
 	}
 
 	if (!system_wide)
-		event__synthesize_thread(pid, process_synthesized_event);
+		event__synthesize_thread(pid, process_synthesized_event,
+					 session);
 	else
-		event__synthesize_threads(process_synthesized_event);
+		event__synthesize_threads(process_synthesized_event, session);
 
 	if (target_pid == -1 && argc) {
 		pid = fork();
@@ -510,7 +512,8 @@ static int __cmd_record(int argc, const char **argv)
 			 */
 			usleep(1000);
 			event__synthesize_thread(pid,
-						 process_synthesized_event);
+						 process_synthesized_event,
+						 session);
 		}
 
 		child_pid = pid;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index e2ec49a..dcd8fed 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -53,8 +53,6 @@ static int		exclude_other = 1;
 
 static char		callchain_default_opt[] = "fractal,0.5";
 
-static struct perf_session *session;
-
 static u64		sample_type;
 
 struct symbol_conf	symbol_conf;
@@ -604,7 +602,7 @@ static int validate_chain(struct ip_callchain *chain, event_t *event)
 	return 0;
 }
 
-static int process_sample_event(event_t *event)
+static int process_sample_event(event_t *event, struct perf_session *session __used)
 {
 	struct sample_data data;
 	int cpumode;
@@ -683,7 +681,7 @@ static int process_sample_event(event_t *event)
 	return 0;
 }
 
-static int process_comm_event(event_t *event)
+static int process_comm_event(event_t *event, struct perf_session *session __used)
 {
 	struct thread *thread = threads__findnew(event->comm.pid);
 
@@ -698,7 +696,7 @@ static int process_comm_event(event_t *event)
 	return 0;
 }
 
-static int process_read_event(event_t *event)
+static int process_read_event(event_t *event, struct perf_session *session __used)
 {
 	struct perf_event_attr *attr;
 
@@ -766,6 +764,7 @@ static int __cmd_report(void)
 {
 	struct thread *idle;
 	int ret;
+	struct perf_session *session;
 
 	session = perf_session__new(input_name, O_RDONLY, force);
 	if (session == NULL)
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 65021fe..48ab283 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1594,7 +1594,8 @@ process_raw_event(event_t *raw_event __used, void *data,
 		process_sched_migrate_task_event(data, event, cpu, timestamp, thread);
 }
 
-static int process_sample_event(event_t *event)
+static int process_sample_event(event_t *event,
+				struct perf_session *session __used)
 {
 	struct sample_data data;
 	struct thread *thread;
@@ -1632,7 +1633,8 @@ static int process_sample_event(event_t *event)
 	return 0;
 }
 
-static int process_lost_event(event_t *event __used)
+static int process_lost_event(event_t *event __used,
+			      struct perf_session *session __used)
 {
 	nr_lost_chunks++;
 	nr_lost_events += event->lost.lost;
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 759dd2b..db6caae 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -281,21 +281,19 @@ static int cpus_cstate_state[MAX_CPUS];
 static u64 cpus_pstate_start_times[MAX_CPUS];
 static u64 cpus_pstate_state[MAX_CPUS];
 
-static int
-process_comm_event(event_t *event)
+static int process_comm_event(event_t *event, struct perf_session *session __used)
 {
 	pid_set_comm(event->comm.pid, event->comm.comm);
 	return 0;
 }
-static int
-process_fork_event(event_t *event)
+
+static int process_fork_event(event_t *event, struct perf_session *session __used)
 {
 	pid_fork(event->fork.pid, event->fork.ppid, event->fork.time);
 	return 0;
 }
 
-static int
-process_exit_event(event_t *event)
+static int process_exit_event(event_t *event, struct perf_session *session __used)
 {
 	pid_exit(event->fork.pid, event->fork.time);
 	return 0;
@@ -594,8 +592,7 @@ static u64 sample_time(event_t *event)
  * We first queue all events, sorted backwards by insertion.
  * The order will get flipped later.
  */
-static int
-queue_sample_event(event_t *event)
+static int queue_sample_event(event_t *event, struct perf_session *session __used)
 {
 	struct sample_wrapper *copy, *prev;
 	int size;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e0a374d..b13f426 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -965,14 +965,14 @@ static void event__process_sample(const event_t *self, int counter)
 	}
 }
 
-static int event__process(event_t *event)
+static int event__process(event_t *event, struct perf_session *session)
 {
 	switch (event->header.type) {
 	case PERF_RECORD_COMM:
-		event__process_comm(event);
+		event__process_comm(event, session);
 		break;
 	case PERF_RECORD_MMAP:
-		event__process_mmap(event);
+		event__process_mmap(event, session);
 		break;
 	default:
 		break;
@@ -999,7 +999,8 @@ static unsigned int mmap_read_head(struct mmap_data *md)
 	return head;
 }
 
-static void mmap_read_counter(struct mmap_data *md)
+static void perf_session__mmap_read_counter(struct perf_session *self,
+					    struct mmap_data *md)
 {
 	unsigned int head = mmap_read_head(md);
 	unsigned int old = md->prev;
@@ -1054,7 +1055,7 @@ static void mmap_read_counter(struct mmap_data *md)
 		if (event->header.type == PERF_RECORD_SAMPLE)
 			event__process_sample(event, md->counter);
 		else
-			event__process(event);
+			event__process(event, self);
 		old += size;
 	}
 
@@ -1064,13 +1065,13 @@ static void mmap_read_counter(struct mmap_data *md)
 static struct pollfd event_array[MAX_NR_CPUS * MAX_COUNTERS];
 static struct mmap_data mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 
-static void mmap_read(void)
+static void perf_session__mmap_read(struct perf_session *self)
 {
 	int i, counter;
 
 	for (i = 0; i < nr_cpus; i++) {
 		for (counter = 0; counter < nr_counters; counter++)
-			mmap_read_counter(&mmap_array[i][counter]);
+			perf_session__mmap_read_counter(self, &mmap_array[i][counter]);
 	}
 }
 
@@ -1155,11 +1156,16 @@ static int __cmd_top(void)
 	pthread_t thread;
 	int i, counter;
 	int ret;
+	/*
+	 * XXX perf_session__new should allow passing a O_MMAP, so that all this
+	 * mmap reading, etc is encapsulated in it.
+	 */
+	struct perf_session *session = NULL;
 
 	if (target_pid != -1)
-		event__synthesize_thread(target_pid, event__process);
+		event__synthesize_thread(target_pid, event__process, session);
 	else
-		event__synthesize_threads(event__process);
+		event__synthesize_threads(event__process, session);
 
 	for (i = 0; i < nr_cpus; i++) {
 		group_fd = -1;
@@ -1170,7 +1176,7 @@ static int __cmd_top(void)
 	/* Wait for a minimal set of events before starting the snapshot */
 	poll(event_array, nr_poll, 100);
 
-	mmap_read();
+	perf_session__mmap_read(session);
 
 	if (pthread_create(&thread, NULL, display_thread, NULL)) {
 		printf("Could not create display thread.\n");
@@ -1190,7 +1196,7 @@ static int __cmd_top(void)
 	while (1) {
 		int hits = samples;
 
-		mmap_read();
+		perf_session__mmap_read(session);
 
 		if (hits == samples)
 			ret = poll(event_array, nr_poll, 100);
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 0756664..3057e1d 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -62,10 +62,9 @@ static int cleanup_scripting(void)
 
 static char const		*input_name = "perf.data";
 
-static struct perf_session 	*session;
 static u64			sample_type;
 
-static int process_sample_event(event_t *event)
+static int process_sample_event(event_t *event, struct perf_session *session __used)
 {
 	struct sample_data data;
 	struct thread *thread;
@@ -125,20 +124,12 @@ static struct perf_file_handler file_handler = {
 	.sample_type_check	= sample_type_check,
 };
 
-static int __cmd_trace(void)
+static int __cmd_trace(struct perf_session *session)
 {
-	int err;
-
-	session = perf_session__new(input_name, O_RDONLY, 0);
-	if (session == NULL)
-		return -ENOMEM;
-
 	register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
-	err = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
-	perf_session__delete(session);
-	return err;
+	return perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
 }
 
 struct script_spec {
@@ -313,6 +304,7 @@ static const struct option options[] = {
 int cmd_trace(int argc, const char **argv, const char *prefix __used)
 {
 	int err;
+	struct perf_session *session;
 
 	symbol__init(0);
 
@@ -330,6 +322,10 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 
 	setup_pager();
 
+	session = perf_session__new(input_name, O_RDONLY, 0);
+	if (session == NULL)
+		return -ENOMEM;
+
 	if (generate_script_lang) {
 		struct stat perf_stat;
 
@@ -367,8 +363,9 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 			goto out;
 	}
 
-	err = __cmd_trace();
+	err = __cmd_trace(session);
 
+	perf_session__delete(session);
 	cleanup_scripting();
 out:
 	return err;
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index 6d46dda..22bcdfe 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -8,7 +8,8 @@ static struct perf_file_handler *curr_handler;
 static unsigned long	mmap_window = 32;
 static char		__cwd[PATH_MAX];
 
-static int process_event_stub(event_t *event __used)
+static int process_event_stub(event_t *event __used,
+			      struct perf_session *session __used)
 {
 	dump_printf(": unhandled!\n");
 	return 0;
@@ -61,8 +62,8 @@ void event__print_totals(void)
 			event__name[i], event__total[i]);
 }
 
-static int
-process_event(event_t *event, unsigned long offset, unsigned long head)
+static int process_event(event_t *event, struct perf_session *session,
+			 unsigned long offset, unsigned long head)
 {
 	trace_event(event);
 
@@ -77,23 +78,23 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
-		return curr_handler->process_sample_event(event);
+		return curr_handler->process_sample_event(event, session);
 	case PERF_RECORD_MMAP:
-		return curr_handler->process_mmap_event(event);
+		return curr_handler->process_mmap_event(event, session);
 	case PERF_RECORD_COMM:
-		return curr_handler->process_comm_event(event);
+		return curr_handler->process_comm_event(event, session);
 	case PERF_RECORD_FORK:
-		return curr_handler->process_fork_event(event);
+		return curr_handler->process_fork_event(event, session);
 	case PERF_RECORD_EXIT:
-		return curr_handler->process_exit_event(event);
+		return curr_handler->process_exit_event(event, session);
 	case PERF_RECORD_LOST:
-		return curr_handler->process_lost_event(event);
+		return curr_handler->process_lost_event(event, session);
 	case PERF_RECORD_READ:
-		return curr_handler->process_read_event(event);
+		return curr_handler->process_read_event(event, session);
 	case PERF_RECORD_THROTTLE:
-		return curr_handler->process_throttle_event(event);
+		return curr_handler->process_throttle_event(event, session);
 	case PERF_RECORD_UNTHROTTLE:
-		return curr_handler->process_unthrottle_event(event);
+		return curr_handler->process_unthrottle_event(event, session);
 	default:
 		curr_handler->total_unknown++;
 		return -1;
@@ -209,7 +210,7 @@ more:
 			(void *)(long)event->header.size,
 			event->header.type);
 
-	if (!size || process_event(event, offset, head) < 0) {
+	if (!size || process_event(event, self, offset, head) < 0) {
 
 		dump_printf("%p [%p]: skipping unknown header type: %d\n",
 			(void *)(offset + head),
diff --git a/tools/perf/util/data_map.h b/tools/perf/util/data_map.h
index 98c5b82..6d4ae52 100644
--- a/tools/perf/util/data_map.h
+++ b/tools/perf/util/data_map.h
@@ -5,7 +5,10 @@
 #include "header.h"
 #include "session.h"
 
-typedef int (*event_type_handler_t)(event_t *);
+struct perf_session;
+
+typedef int (*event_type_handler_t)(event_t *self,
+				    struct perf_session *session);
 
 struct perf_file_handler {
 	event_type_handler_t	process_sample_event;
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index ba0de90..e2c4895 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -5,7 +5,9 @@
 #include "thread.h"
 
 static pid_t event__synthesize_comm(pid_t pid, int full,
-				    int (*process)(event_t *event))
+				    int (*process)(event_t *event,
+						   struct perf_session *session),
+				    struct perf_session *session)
 {
 	event_t ev;
 	char filename[PATH_MAX];
@@ -54,7 +56,7 @@ out_race:
 	if (!full) {
 		ev.comm.tid = pid;
 
-		process(&ev);
+		process(&ev, session);
 		goto out_fclose;
 	}
 
@@ -72,7 +74,7 @@ out_race:
 
 		ev.comm.tid = pid;
 
-		process(&ev);
+		process(&ev, session);
 	}
 	closedir(tasks);
 
@@ -86,7 +88,9 @@ out_failure:
 }
 
 static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
-					 int (*process)(event_t *event))
+					 int (*process)(event_t *event,
+							struct perf_session *session),
+					 struct perf_session *session)
 {
 	char filename[PATH_MAX];
 	FILE *fp;
@@ -141,7 +145,7 @@ static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
 			ev.mmap.pid = tgid;
 			ev.mmap.tid = pid;
 
-			process(&ev);
+			process(&ev, session);
 		}
 	}
 
@@ -149,15 +153,20 @@ static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
 	return 0;
 }
 
-int event__synthesize_thread(pid_t pid, int (*process)(event_t *event))
+int event__synthesize_thread(pid_t pid,
+			     int (*process)(event_t *event,
+					    struct perf_session *session),
+			     struct perf_session *session)
 {
-	pid_t tgid = event__synthesize_comm(pid, 1, process);
+	pid_t tgid = event__synthesize_comm(pid, 1, process, session);
 	if (tgid == -1)
 		return -1;
-	return event__synthesize_mmap_events(pid, tgid, process);
+	return event__synthesize_mmap_events(pid, tgid, process, session);
 }
 
-void event__synthesize_threads(int (*process)(event_t *event))
+void event__synthesize_threads(int (*process)(event_t *event,
+					      struct perf_session *session),
+			       struct perf_session *session)
 {
 	DIR *proc;
 	struct dirent dirent, *next;
@@ -171,7 +180,7 @@ void event__synthesize_threads(int (*process)(event_t *event))
 		if (*end) /* only interested in proper numerical dirents */
 			continue;
 
-		event__synthesize_thread(pid, process);
+		event__synthesize_thread(pid, process, session);
 	}
 
 	closedir(proc);
@@ -182,7 +191,7 @@ int  event__cwdlen;
 
 struct events_stats event__stats;
 
-int event__process_comm(event_t *self)
+int event__process_comm(event_t *self, struct perf_session *session __used)
 {
 	struct thread *thread = threads__findnew(self->comm.pid);
 
@@ -196,14 +205,14 @@ int event__process_comm(event_t *self)
 	return 0;
 }
 
-int event__process_lost(event_t *self)
+int event__process_lost(event_t *self, struct perf_session *session __used)
 {
 	dump_printf(": id:%Ld: lost:%Ld\n", self->lost.id, self->lost.lost);
 	event__stats.lost += self->lost.lost;
 	return 0;
 }
 
-int event__process_mmap(event_t *self)
+int event__process_mmap(event_t *self, struct perf_session *session __used)
 {
 	struct thread *thread = threads__findnew(self->mmap.pid);
 	struct map *map = map__new(&self->mmap, MAP__FUNCTION,
@@ -224,7 +233,7 @@ int event__process_mmap(event_t *self)
 	return 0;
 }
 
-int event__process_task(event_t *self)
+int event__process_task(event_t *self, struct perf_session *session __used)
 {
 	struct thread *thread = threads__findnew(self->fork.pid);
 	struct thread *parent = threads__findnew(self->fork.ppid);
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 51a96c2..6b6429b 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -156,18 +156,25 @@ struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
 void map__fixup_start(struct map *self);
 void map__fixup_end(struct map *self);
 
-int event__synthesize_thread(pid_t pid, int (*process)(event_t *event));
-void event__synthesize_threads(int (*process)(event_t *event));
+struct perf_session;
+
+int event__synthesize_thread(pid_t pid,
+			     int (*process)(event_t *event,
+					    struct perf_session *session),
+			     struct perf_session *session);
+void event__synthesize_threads(int (*process)(event_t *event,
+					      struct perf_session *session),
+			       struct perf_session *session);
 
 extern char *event__cwd;
 extern int  event__cwdlen;
 extern struct events_stats event__stats;
 extern unsigned long event__total[PERF_RECORD_MAX];
 
-int event__process_comm(event_t *self);
-int event__process_lost(event_t *self);
-int event__process_mmap(event_t *self);
-int event__process_task(event_t *self);
+int event__process_comm(event_t *self, struct perf_session *session);
+int event__process_lost(event_t *self, struct perf_session *session);
+int event__process_mmap(event_t *self, struct perf_session *session);
+int event__process_task(event_t *self, struct perf_session *session);
 
 struct addr_location;
 int event__preprocess_sample(const event_t *self, struct addr_location *al,
-- 
1.6.2.5

