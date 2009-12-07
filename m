Return-Path: <linux-kernel-owner+w=401wt.eu-S933275AbZLGDe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbZLGDe7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933134AbZLGDez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:34:55 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:64426 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933135AbZLGDes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:34:48 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] perf lock: New subcommand "lock" to perf for analyzing lock statistics
Date: Mon,  7 Dec 2009 12:34:44 +0900
Message-Id: <1260156884-8474-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091115022135.GA5427@nowhere>
References: <20091115022135.GA5427@nowhere>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new subcommand "lock" to perf for analyzing lock usage statistics.
Current perf lock is very primitive. This cannot provide the minimum functions.
Of course I continue to working on this.
But too big patch is not good thing for you, so I post this.

And I found some important problem, so I'd like to ask your opinion.
For another issue, this patch depends on the previous one.
The previous one is very dirty and temporary, I cannot sign on it, so I cannot sign on this too...

First, it seems that current locks (spinlock, rwlock, mutex) has no numeric ID.
So we can't treat rq->lock on CPU 0 and rq->lock on CPU 1 as different things.
Symbol name of locks cannot be complete ID.
This is the result of current ugly data structure for lock_stat
(data structure for stat per lock in builtin-lock.c).
Hash table will solve the problem of speed,
but it is not a radical solution.
I understand it is hard to implement numeric IDs for locks,
but it is required seriously, do you have some ideas?

Second, there's a lot of lack of information from trace events.
For example, current lock event subsystem cannot provide the time between
lock_acquired and lock_release.
But this time is already measured in lockdep, and we can obtain it
from /proc/lock_stat.
But /proc/lock_stat provides information from boot time only.
So I have to modify wide area of kernel including lockdep, may I do this?

Third, siginificant overhead :-(

% perf bench sched messaging                      # Without perf lock rec

     Total time: 0.436 [sec]

% sudo ./perf lock rec perf bench sched messaging # With perf lock rec

     Total time: 4.677 [sec]
[ perf record: Woken up 0 times to write data ]
[ perf record: Captured and wrote 106.065 MB perf.data (~4634063 samples) ]

Over 10 times! No one can ignore this...

This is example of using perf lock prof:
% sudo ./perf lock prof          # Outputs in pager
 ------------------------------------------------------------------------------------------
  Lock                           |   Acquired   | Max wait ns | Min wait ns | Total wait ns |
 --------------------------------------------------------------------------------------------
                        &q->lock            30             0             0               0
                      &ctx->lock          3912             0             0               0
                     event_mutex             2             0             0               0
                &newf->file_lock          1008             0             0               0
                     dcache_lock           444             0             0               0
                 &dentry->d_lock          1164             0             0               0
                     &ctx->mutex             2             0             0               0
        &child->perf_event_mutex             2             0             0               0
             &event->child_mutex            18             0             0               0
                      &f->f_lock             2             0             0               0
              &event->mmap_mutex             2             0             0               0
        &sb->s_type->i_mutex_key           259             0             0               0
                 &sem->wait_lock         27205             0             0               0
       &(&ip->i_iolock)->mr_lock           130             0             0               0
         &(&ip->i_lock)->mr_lock          6376             0             0               0
              &parent->list_lock          9149          7367           146          527013
        &inode->i_data.tree_lock         12175             0             0               0
     &inode->i_data.private_lock          6097             0             0               0

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>
---
 tools/perf/Makefile       |    1 +
 tools/perf/builtin-lock.c |  449 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin.h      |    1 +
 tools/perf/perf.c         |    1 +
 4 files changed, 452 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/builtin-lock.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 23ec660..28b0258 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -437,6 +437,7 @@ BUILTIN_OBJS += builtin-top.o
 BUILTIN_OBJS += builtin-trace.o
 BUILTIN_OBJS += builtin-probe.o
 BUILTIN_OBJS += builtin-kmem.o
+BUILTIN_OBJS += builtin-lock.o
 
 PERFLIBS = $(LIB_FILE)
 
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
new file mode 100644
index 0000000..d81ba3f
--- /dev/null
+++ b/tools/perf/builtin-lock.c
@@ -0,0 +1,449 @@
+#include "builtin.h"
+#include "perf.h"
+
+#include "util/util.h"
+#include "util/cache.h"
+#include "util/symbol.h"
+#include "util/thread.h"
+#include "util/header.h"
+
+#include "util/parse-options.h"
+#include "util/trace-event.h"
+
+#include "util/debug.h"
+#include "util/data_map.h"
+
+#include <sys/types.h>
+#include <sys/prctl.h>
+
+#include <semaphore.h>
+#include <pthread.h>
+#include <math.h>
+
+#include <limits.h>
+
+/*
+ * FIXME and TODO:
+ * At least, hash table should be used here.
+ * Ideally, numeric ID for each lock instance is desired.
+ */
+struct lock_stat {
+	char *name;		       /* for strcpy(), we cannot use const */
+
+	unsigned int nr_acquired;
+	unsigned int nr_contended;
+	/* nr_contended - nr_acquired == immediate availability */
+
+	/* these times are in nano sec. */
+	u64 wait_time_total;
+	u64 wait_time_min;
+	u64 wait_time_max;
+};
+
+static struct lock_stat lock_stat_sentinel = {
+	.name = NULL,
+};
+
+static struct lock_stat **lock_stats;
+
+static void lock_stats_init(void)
+{
+	lock_stats = zalloc(sizeof(struct lock_stat *));
+	if (!lock_stats)
+		die("memory allocation failed\n");
+	lock_stats[0] = zalloc(sizeof(struct lock_stat));
+	if (!lock_stats[0])
+		die("memory allocation failed\n");
+	lock_stats[0] = &lock_stat_sentinel;
+}
+
+static struct lock_stat *lock_stat_findnew(const char *name)
+{
+	int i, new;
+
+	for (i = 0; lock_stats[i]->name; i++) {
+		if (!strcmp(lock_stats[i]->name, name))
+			return lock_stats[i];
+	}
+
+	new = i;
+	lock_stats = xrealloc(lock_stats,
+			      sizeof(struct lock_stats *) * (i + 2));
+	lock_stats[new] = calloc(sizeof(struct lock_stat), 1);
+	if (!lock_stats[new])
+		die("memory allocation failed\n");
+	lock_stats[new]->name = calloc(sizeof(char), strlen(name) + 1);
+	if (!lock_stats[new]->name)
+		die("memory allocation failed\n");
+	strcpy(lock_stats[new]->name, name);
+	lock_stats[new]->wait_time_min = ULLONG_MAX;
+
+	lock_stats[i + 1] = &lock_stat_sentinel;
+	return lock_stats[new];
+}
+
+static char	        	const *input_name = "perf.data";
+
+static struct perf_header	*header;
+static u64			sample_type;
+
+static int			profile_cpu = -1;
+
+struct raw_event_sample {
+	u32 size;
+	char data[0];
+};
+
+struct trace_acquire_event {
+	const char *name;
+};
+
+struct trace_acquired_event {
+	const char *name;
+	u64 wait_time;		       /* in nano sec. */
+};
+
+struct trace_contended_event {
+	const char *name;
+};
+
+struct trace_release_event {
+	const char *name;
+};
+
+struct trace_lock_handler {
+	void (*acquire_event)(struct trace_acquire_event *,
+			      struct event *,
+			      int cpu,
+			      u64 timestamp,
+			      struct thread *thread);
+
+	void (*acquired_event)(struct trace_acquired_event *,
+			       struct event *,
+			       int cpu,
+			       u64 timestamp,
+			       struct thread *thread);
+
+	void (*contended_event)(struct trace_contended_event *,
+				struct event *,
+				int cpu,
+				u64 timestamp,
+				struct thread *thread);
+
+	void (*release_event)(struct trace_release_event *,
+			      struct event *,
+			      int cpu,
+			      u64 timestamp,
+			      struct thread *thread);
+};
+
+static void prof_lock_acquire_event(struct trace_acquire_event *acquire_event __used,
+			struct event *__event __used,
+			int cpu __used,
+			u64 timestamp __used,
+			struct thread *thread __used)
+{
+}
+
+static void prof_lock_acquired_event(struct trace_acquired_event *acquired_event,
+			 struct event *__event __used,
+			 int cpu __used,
+			 u64 timestamp __used,
+			 struct thread *thread __used)
+{
+	struct lock_stat *st;
+
+	st = lock_stat_findnew(acquired_event->name);
+	st->nr_acquired++;
+
+	if (acquired_event->wait_time != 0) {
+		st->wait_time_total += acquired_event->wait_time;
+		if (st->wait_time_max < acquired_event->wait_time)
+			st->wait_time_max = acquired_event->wait_time;
+		else if (st->wait_time_min > acquired_event->wait_time)
+			st->wait_time_min = acquired_event->wait_time;
+	}
+}
+
+static void prof_lock_contended_event(struct trace_contended_event *contended_event,
+			  struct event *__event __used,
+			  int cpu __used,
+			  u64 timestamp __used,
+			  struct thread *thread __used)
+{
+	struct lock_stat *st;
+
+	st = lock_stat_findnew(contended_event->name);
+	st->nr_contended++;
+}
+
+static void prof_lock_release_event(struct trace_release_event *release_event __used,
+			struct event *__event __used,
+			int cpu __used,
+			u64 timestamp __used,
+			struct thread *thread __used)
+{
+}
+
+/* lock oriented handlers */
+/* TODO: handlers for CPU oriented, thread oriented */
+static struct trace_lock_handler prof_lock_ops  = {
+	.acquire_event		= prof_lock_acquire_event,
+	.acquired_event		= prof_lock_acquired_event,
+	.contended_event	= prof_lock_contended_event,
+	.release_event		= prof_lock_release_event,
+};
+
+static struct trace_lock_handler *trace_handler;
+
+static void
+process_lock_acquire_event(struct raw_event_sample *raw __used,
+			   struct event *event __used,
+			   int cpu __used,
+			   u64 timestamp __used,
+			   struct thread *thread __used)
+{
+}
+
+static void
+process_lock_acquired_event(struct raw_event_sample *raw __used,
+			    struct event *event __used,
+			    int cpu __used,
+			    u64 timestamp __used,
+			    struct thread *thread __used)
+{
+	struct trace_acquired_event acquired_event;
+
+	acquired_event.name = (char *)raw_field_ptr(event, "name", raw->data);
+	acquired_event.wait_time =
+		(unsigned long)raw_field_value(event, "wait_usec", raw->data)
+		* 1000;
+	acquired_event.wait_time +=
+		(unsigned long)raw_field_value(event,
+					      "wait_nsec_rem", raw->data);
+
+	if (trace_handler->acquire_event) {
+		trace_handler->acquired_event(&acquired_event,
+					     event, cpu, timestamp, thread);
+	}
+}
+
+static void
+process_lock_contended_event(struct raw_event_sample *raw __used,
+			     struct event *event __used,
+			     int cpu __used,
+			     u64 timestamp __used,
+			     struct thread *thread __used)
+{
+}
+
+static void
+process_lock_release_event(struct raw_event_sample *raw __used,
+			   struct event *event __used,
+			   int cpu __used,
+			   u64 timestamp __used,
+			   struct thread *thread __used)
+{
+}
+
+static void
+process_raw_event(event_t *raw_event __used, void *more_data,
+		  int cpu, u64 timestamp, struct thread *thread)
+{
+	struct raw_event_sample *raw = more_data;
+	struct event *event;
+	int type;
+
+	type = trace_parse_common_type(raw->data);
+	event = trace_find_event(type);
+
+	if (!strcmp(event->name, "lock_acquire"))
+		process_lock_acquire_event(raw, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "lock_acquired"))
+		process_lock_acquired_event(raw, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "lock_contended"))
+		process_lock_contended_event(raw, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "lock_release"))
+		process_lock_release_event(raw, event, cpu, timestamp, thread);
+}
+
+static int process_sample_event(event_t *event)
+{
+	struct thread *thread;
+	u64 ip = event->ip.ip;
+	u64 timestamp = -1;
+	u32 cpu = -1;
+	u64 period = 1;
+	void *more_data = event->ip.__more_data;
+
+	thread = threads__findnew(event->ip.pid);
+
+	if (!(sample_type & PERF_SAMPLE_RAW))
+		return 0;
+
+	if (sample_type & PERF_SAMPLE_TIME) {
+		timestamp = *(u64 *)more_data;
+		more_data += sizeof(u64);
+	}
+
+	if (sample_type & PERF_SAMPLE_CPU) {
+		cpu = *(u32 *)more_data;
+		more_data += sizeof(u32);
+		more_data += sizeof(u32); /* reserved */
+	}
+
+	if (sample_type & PERF_SAMPLE_PERIOD) {
+		period = *(u64 *)more_data;
+		more_data += sizeof(u64);
+	}
+
+	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
+		event->header.misc,
+		event->ip.pid, event->ip.tid,
+		(void *)(long)ip,
+		(long long)period);
+
+	if (thread == NULL) {
+		pr_debug("problem processing %d event, skipping it.\n",
+			 event->header.type);
+		return -1;
+	}
+
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+
+	if (profile_cpu != -1 && profile_cpu != (int) cpu)
+		return 0;
+
+	process_raw_event(event, more_data, cpu, timestamp, thread);
+
+	return 0;
+}
+
+static int sample_type_check(u64 type)
+{
+	sample_type = type;
+
+	if (!(sample_type & PERF_SAMPLE_RAW)) {
+		fprintf(stderr,
+			"No trace sample to read. Did you call perf record "
+			"without -R?");
+		return -1;
+	}
+
+	return 0;
+}
+
+/* TODO: various way to print */
+static void print_result(void)
+{
+	int i;
+
+	/* FIXME: formatting output is very rough */
+	printf("\n ------------------------------------------------------------------------------------------\n");
+	printf("  Lock                           |   Acquired   | Max wait ns | Min wait ns | Total wait ns |\n");
+	printf(" --------------------------------------------------------------------------------------------\n");
+
+	for (i = 0; lock_stats[i]->name; i++) {
+		printf("%32s %13u %13llu %13llu %15llu\n",
+		       lock_stats[i]->name,
+		       lock_stats[i]->nr_acquired,
+		       lock_stats[i]->wait_time_max,
+		       lock_stats[i]->wait_time_min == ULLONG_MAX ?
+		       0 : lock_stats[i]->wait_time_min,
+		       lock_stats[i]->wait_time_total);
+	}
+}
+
+static struct perf_file_handler file_handler = {
+	.process_sample_event	= process_sample_event,
+	.sample_type_check	= sample_type_check,
+};
+
+static int read_events(void)
+{
+	register_idle_thread();
+	register_perf_file_handler(&file_handler);
+
+	return mmap_dispatch_perf_file(&header, input_name, 0, 0,
+				       &event__cwdlen, &event__cwd);
+}
+
+static void __cmd_prof(void)
+{
+	setup_pager();
+	lock_stats_init();
+	read_events();
+	print_result();
+}
+
+static const char * const lock_usage[] = {
+	"perf lock [<options>] {record|trace|prof}",
+	NULL
+};
+
+static const struct option lock_options[] = {
+	OPT_STRING('i', "input", &input_name, "file",
+		    "input file name"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_END()
+};
+
+static const char *record_args[] = {
+	"record",
+	"-a",
+	"-R",
+	"-M",
+	"-f",
+	"-m", "1024",
+	"-c", "1",
+	"-e", "lock:lock_acquire:r",
+	"-e", "lock:lock_acquired:r",
+	"-e", "lock:lock_contended:r",
+	"-e", "lock:lock_release:r",
+};
+
+static int __cmd_record(int argc, const char **argv)
+{
+	unsigned int rec_argc, i, j;
+	const char **rec_argv;
+
+	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+
+	for (i = 0; i < ARRAY_SIZE(record_args); i++)
+		rec_argv[i] = strdup(record_args[i]);
+
+	for (j = 1; j < (unsigned int)argc; j++, i++)
+		rec_argv[i] = argv[j];
+
+	BUG_ON(i != rec_argc);
+
+	return cmd_record(i, rec_argv, NULL);
+}
+
+int cmd_lock(int argc, const char **argv, const char *prefix __used)
+{
+	symbol__init(0);
+
+	argc = parse_options(argc, argv, lock_options, lock_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (!argc)
+		usage_with_options(lock_usage, lock_options);
+
+	if (!strncmp(argv[0], "rec", 3)) {
+		return __cmd_record(argc, argv);
+	} else if (!strncmp(argv[0], "prof", 4)) {
+		trace_handler = &prof_lock_ops;
+		__cmd_prof();
+	} else if (!strcmp(argv[0], "trace")) {
+		/* Aliased to 'perf trace' */
+		return cmd_trace(argc, argv, prefix);
+	} else {
+		usage_with_options(lock_usage, lock_options);
+	}
+
+	return 0;
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index a3d8bf6..aeaa710 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -29,5 +29,6 @@ extern int cmd_trace(int argc, const char **argv, const char *prefix);
 extern int cmd_version(int argc, const char **argv, const char *prefix);
 extern int cmd_probe(int argc, const char **argv, const char *prefix);
 extern int cmd_kmem(int argc, const char **argv, const char *prefix);
+extern int cmd_lock(int argc, const char **argv, const char *prefix);
 
 #endif
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index cf64049..f100e4b 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -300,6 +300,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "sched",	cmd_sched,	0 },
 		{ "probe",	cmd_probe,	0 },
 		{ "kmem",	cmd_kmem,	0 },
+		{ "lock",	cmd_lock,	0 },
 	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
-- 
1.6.5.2

