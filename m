Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbZIOJbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbZIOJbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbZIOJb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:31:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:49207 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbZIOJbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:31:23 -0400
Date: Tue, 15 Sep 2009 09:30:40 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf: Add 'perf sched' tool
Message-ID: <tip-0a02ad9331dd4db56c29c60db2e99c4daaad8a48@git.kernel.org>
Git-Commit-ID: 0a02ad9331dd4db56c29c60db2e99c4daaad8a48
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:30:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a02ad9331dd4db56c29c60db2e99c4daaad8a48
Gitweb:     http://git.kernel.org/tip/0a02ad9331dd4db56c29c60db2e99c4daaad8a48
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 11 Sep 2009 12:12:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 13 Sep 2009 10:22:36 +0200

perf: Add 'perf sched' tool

This turn-key tool allows scheduler measurements to be
conducted and the results be displayed numerically.

First baby step towards that goal: clone the new command off of
perf trace.

Fix a few other details along the way:

 - add (minimal) perf trace documentation

 - reorder a few places

 - list perf trace in the mainporcelain list as well
   as it's a very useful utility.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Documentation/perf-sched.txt |   25 +++
 tools/perf/Documentation/perf-trace.txt |   25 +++
 tools/perf/Makefile                     |    1 +
 tools/perf/builtin-sched.c              |  297 +++++++++++++++++++++++++++++++
 tools/perf/builtin.h                    |    5 +-
 tools/perf/command-list.txt             |    2 +
 tools/perf/perf.c                       |    1 +
 7 files changed, 354 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-sched.txt b/tools/perf/Documentation/perf-sched.txt
new file mode 100644
index 0000000..056320e
--- /dev/null
+++ b/tools/perf/Documentation/perf-sched.txt
@@ -0,0 +1,25 @@
+perf-sched(1)
+==============
+
+NAME
+----
+perf-sched - Read perf.data (created by perf record) and display sched output
+
+SYNOPSIS
+--------
+[verse]
+'perf sched' [-i <file> | --input=file] symbol_name
+
+DESCRIPTION
+-----------
+This command reads the input file and displays the latencies recorded.
+
+OPTIONS
+-------
+-D::
+--dump-raw-trace=::
+        Display verbose dump of the sched data.
+
+SEE ALSO
+--------
+linkperf:perf-record[1]
diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
new file mode 100644
index 0000000..41ed753
--- /dev/null
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -0,0 +1,25 @@
+perf-trace(1)
+==============
+
+NAME
+----
+perf-trace - Read perf.data (created by perf record) and display trace output
+
+SYNOPSIS
+--------
+[verse]
+'perf trace' [-i <file> | --input=file] symbol_name
+
+DESCRIPTION
+-----------
+This command reads the input file and displays the trace recorded.
+
+OPTIONS
+-------
+-D::
+--dump-raw-trace=::
+        Display verbose dump of the trace data.
+
+SEE ALSO
+--------
+linkperf:perf-record[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9f8d207..2cb8cc3 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -376,6 +376,7 @@ LIB_OBJS += util/trace-event-info.o
 
 BUILTIN_OBJS += builtin-annotate.o
 BUILTIN_OBJS += builtin-help.o
+BUILTIN_OBJS += builtin-sched.o
 BUILTIN_OBJS += builtin-list.o
 BUILTIN_OBJS += builtin-record.o
 BUILTIN_OBJS += builtin-report.o
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
new file mode 100644
index 0000000..60228d9
--- /dev/null
+++ b/tools/perf/builtin-sched.c
@@ -0,0 +1,297 @@
+#include "builtin.h"
+
+#include "util/util.h"
+#include "util/cache.h"
+#include "util/symbol.h"
+#include "util/thread.h"
+#include "util/header.h"
+
+#include "util/parse-options.h"
+
+#include "perf.h"
+#include "util/debug.h"
+
+#include "util/trace-event.h"
+
+static char		const *input_name = "perf.data";
+static int		input;
+static unsigned long	page_size;
+static unsigned long	mmap_window = 32;
+
+static unsigned long	total = 0;
+static unsigned long	total_comm = 0;
+
+static struct rb_root	threads;
+static struct thread	*last_match;
+
+static struct perf_header *header;
+static u64		sample_type;
+
+
+static int
+process_comm_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	struct thread *thread;
+
+	thread = threads__findnew(event->comm.pid, &threads, &last_match);
+
+	dump_printf("%p [%p]: PERF_EVENT_COMM: %s:%d\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->comm.comm, event->comm.pid);
+
+	if (thread == NULL ||
+	    thread__set_comm(thread, event->comm.comm)) {
+		dump_printf("problem processing PERF_EVENT_COMM, skipping event.\n");
+		return -1;
+	}
+	total_comm++;
+
+	return 0;
+}
+
+static int
+process_sample_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	char level;
+	int show = 0;
+	struct dso *dso = NULL;
+	struct thread *thread;
+	u64 ip = event->ip.ip;
+	u64 timestamp = -1;
+	u32 cpu = -1;
+	u64 period = 1;
+	void *more_data = event->ip.__more_data;
+	int cpumode;
+
+	thread = threads__findnew(event->ip.pid, &threads, &last_match);
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
+	dump_printf("%p [%p]: PERF_EVENT_SAMPLE (IP, %d): %d/%d: %p period: %Ld\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->header.misc,
+		event->ip.pid, event->ip.tid,
+		(void *)(long)ip,
+		(long long)period);
+
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+
+	if (thread == NULL) {
+		eprintf("problem processing %d event, skipping it.\n",
+			event->header.type);
+		return -1;
+	}
+
+	cpumode = event->header.misc & PERF_EVENT_MISC_CPUMODE_MASK;
+
+	if (cpumode == PERF_EVENT_MISC_KERNEL) {
+		show = SHOW_KERNEL;
+		level = 'k';
+
+		dso = kernel_dso;
+
+		dump_printf(" ...... dso: %s\n", dso->name);
+
+	} else if (cpumode == PERF_EVENT_MISC_USER) {
+
+		show = SHOW_USER;
+		level = '.';
+
+	} else {
+		show = SHOW_HV;
+		level = 'H';
+
+		dso = hypervisor_dso;
+
+		dump_printf(" ...... dso: [hypervisor]\n");
+	}
+
+	if (sample_type & PERF_SAMPLE_RAW) {
+		struct {
+			u32 size;
+			char data[0];
+		} *raw = more_data;
+
+		/*
+		 * FIXME: better resolve from pid from the struct trace_entry
+		 * field, although it should be the same than this perf
+		 * event pid
+		 */
+		print_event(cpu, raw->data, raw->size, timestamp, thread->comm);
+	}
+	total += period;
+
+	return 0;
+}
+
+static int
+process_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	trace_event(event);
+
+	switch (event->header.type) {
+	case PERF_EVENT_MMAP ... PERF_EVENT_LOST:
+		return 0;
+
+	case PERF_EVENT_COMM:
+		return process_comm_event(event, offset, head);
+
+	case PERF_EVENT_EXIT ... PERF_EVENT_READ:
+		return 0;
+
+	case PERF_EVENT_SAMPLE:
+		return process_sample_event(event, offset, head);
+
+	case PERF_EVENT_MAX:
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static int __cmd_sched(void)
+{
+	int ret, rc = EXIT_FAILURE;
+	unsigned long offset = 0;
+	unsigned long head = 0;
+	struct stat perf_stat;
+	event_t *event;
+	uint32_t size;
+	char *buf;
+
+	trace_report();
+	register_idle_thread(&threads, &last_match);
+
+	input = open(input_name, O_RDONLY);
+	if (input < 0) {
+		perror("failed to open file");
+		exit(-1);
+	}
+
+	ret = fstat(input, &perf_stat);
+	if (ret < 0) {
+		perror("failed to stat file");
+		exit(-1);
+	}
+
+	if (!perf_stat.st_size) {
+		fprintf(stderr, "zero-sized file, nothing to do!\n");
+		exit(0);
+	}
+	header = perf_header__read(input);
+	head = header->data_offset;
+	sample_type = perf_header__sample_type(header);
+
+	if (!(sample_type & PERF_SAMPLE_RAW))
+		die("No trace sample to read. Did you call perf record "
+		    "without -R?");
+
+	if (load_kernel() < 0) {
+		perror("failed to load kernel symbols");
+		return EXIT_FAILURE;
+	}
+
+remap:
+	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
+			   MAP_SHARED, input, offset);
+	if (buf == MAP_FAILED) {
+		perror("failed to mmap file");
+		exit(-1);
+	}
+
+more:
+	event = (event_t *)(buf + head);
+
+	size = event->header.size;
+	if (!size)
+		size = 8;
+
+	if (head + event->header.size >= page_size * mmap_window) {
+		unsigned long shift = page_size * (head / page_size);
+		int res;
+
+		res = munmap(buf, page_size * mmap_window);
+		assert(res == 0);
+
+		offset += shift;
+		head -= shift;
+		goto remap;
+	}
+
+	size = event->header.size;
+
+
+	if (!size || process_event(event, offset, head) < 0) {
+
+		/*
+		 * assume we lost track of the stream, check alignment, and
+		 * increment a single u64 in the hope to catch on again 'soon'.
+		 */
+
+		if (unlikely(head & 7))
+			head &= ~7ULL;
+
+		size = 8;
+	}
+
+	head += size;
+
+	if (offset + head < (unsigned long)perf_stat.st_size)
+		goto more;
+
+	rc = EXIT_SUCCESS;
+	close(input);
+
+	return rc;
+}
+
+static const char * const annotate_usage[] = {
+	"perf trace [<options>] <command>",
+	NULL
+};
+
+static const struct option options[] = {
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_END()
+};
+
+int cmd_sched(int argc, const char **argv, const char *prefix __used)
+{
+	symbol__init();
+	page_size = getpagesize();
+
+	argc = parse_options(argc, argv, options, annotate_usage, 0);
+	if (argc) {
+		/*
+		 * Special case: if there's an argument left then assume tha
+		 * it's a symbol filter:
+		 */
+		if (argc > 1)
+			usage_with_options(annotate_usage, options);
+	}
+
+
+	setup_pager();
+
+	return __cmd_sched();
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 3a63e41..b09cadb 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -16,12 +16,13 @@ extern int check_pager_config(const char *cmd);
 
 extern int cmd_annotate(int argc, const char **argv, const char *prefix);
 extern int cmd_help(int argc, const char **argv, const char *prefix);
+extern int cmd_sched(int argc, const char **argv, const char *prefix);
+extern int cmd_list(int argc, const char **argv, const char *prefix);
 extern int cmd_record(int argc, const char **argv, const char *prefix);
 extern int cmd_report(int argc, const char **argv, const char *prefix);
 extern int cmd_stat(int argc, const char **argv, const char *prefix);
 extern int cmd_top(int argc, const char **argv, const char *prefix);
-extern int cmd_version(int argc, const char **argv, const char *prefix);
-extern int cmd_list(int argc, const char **argv, const char *prefix);
 extern int cmd_trace(int argc, const char **argv, const char *prefix);
+extern int cmd_version(int argc, const char **argv, const char *prefix);
 
 #endif
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index eebce30..3133c74 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -4,7 +4,9 @@
 #
 perf-annotate			mainporcelain common
 perf-list			mainporcelain common
+perf-sched			mainporcelain common
 perf-record			mainporcelain common
 perf-report			mainporcelain common
 perf-stat			mainporcelain common
 perf-top			mainporcelain common
+perf-trace			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index fe4589d..c972d1c 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -293,6 +293,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "annotate", cmd_annotate, 0 },
 		{ "version", cmd_version, 0 },
 		{ "trace", cmd_trace, 0 },
+		{ "sched", cmd_sched, 0 },
 	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
