Return-Path: <linux-kernel-owner+w=401wt.eu-S932618AbZJHPN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618AbZJHPN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 11:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932560AbZJHPN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 11:13:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:39873 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932342AbZJHPNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 11:13:55 -0400
Date: Thu, 8 Oct 2009 15:12:41 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       arjan@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
       arjan@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091007104729.GD5043@nowhere>
References: <20091007104729.GD5043@nowhere>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Unify perf.data mapping and events handling
Message-ID: <tip-016e92fbc9ef33689cf654f343a94383d43235e7@git.kernel.org>
Git-Commit-ID: 016e92fbc9ef33689cf654f343a94383d43235e7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 08 Oct 2009 15:12:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  016e92fbc9ef33689cf654f343a94383d43235e7
Gitweb:     http://git.kernel.org/tip/016e92fbc9ef33689cf654f343a94383d43235e7
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 7 Oct 2009 12:47:31 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 8 Oct 2009 16:56:32 +0200

perf tools: Unify perf.data mapping and events handling

This librarizes the perf.data file mapping and handling in various
perf tools, roughly reducing the amount of code and fixing the
places that mmap from beginning of the file whereas we want to mmap
from the beginning of the data, leading to page fault because the
mmap window is too small since the trace info are written in the
file too.

TODO:

 - convert perf timechart too

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arjan van de Ven <arjan@infradead.org>
LKML-Reference: <20091007104729.GD5043@nowhere>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile         |    2 +
 tools/perf/builtin-report.c |  211 +++++++----------------------------------
 tools/perf/builtin-sched.c  |  140 +++++----------------------
 tools/perf/builtin-trace.c  |  129 ++++---------------------
 tools/perf/util/data_map.c  |  222 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/data_map.h  |   31 ++++++
 6 files changed, 334 insertions(+), 401 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5a42996..495eb6d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -342,6 +342,7 @@ LIB_H += util/values.h
 LIB_H += util/sort.h
 LIB_H += util/hist.h
 LIB_H += util/thread.h
+LIB_H += util/data_map.h
 
 LIB_OBJS += util/abspath.o
 LIB_OBJS += util/alias.o
@@ -378,6 +379,7 @@ LIB_OBJS += util/trace-event-info.o
 LIB_OBJS += util/svghelper.o
 LIB_OBJS += util/sort.o
 LIB_OBJS += util/hist.o
+LIB_OBJS += util/data_map.o
 
 BUILTIN_OBJS += builtin-annotate.o
 BUILTIN_OBJS += builtin-help.o
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 12f8c86..87c4582 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -26,6 +26,7 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
+#include "util/data_map.h"
 #include "util/thread.h"
 #include "util/sort.h"
 #include "util/hist.h"
@@ -37,7 +38,6 @@ static char		*dso_list_str, *comm_list_str, *sym_list_str,
 static struct strlist	*dso_list, *comm_list, *sym_list;
 
 static int		force;
-static int		input;
 
 static int		full_paths;
 static int		show_nr_samples;
@@ -48,15 +48,11 @@ static struct perf_read_values	show_threads_values;
 static char		default_pretty_printing_style[] = "normal";
 static char		*pretty_printing_style = default_pretty_printing_style;
 
-static unsigned long	page_size;
-static unsigned long	mmap_window = 32;
-
 static int		exclude_other = 1;
 
 static char		callchain_default_opt[] = "fractal,0.5";
 
-static char		__cwd[PATH_MAX];
-static char		*cwd = __cwd;
+static char		*cwd;
 static int		cwdlen;
 
 static struct rb_root	threads;
@@ -815,208 +811,71 @@ process_read_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
-static int
-process_event(event_t *event, unsigned long offset, unsigned long head)
-{
-	trace_event(event);
-
-	switch (event->header.type) {
-	case PERF_RECORD_SAMPLE:
-		return process_sample_event(event, offset, head);
-
-	case PERF_RECORD_MMAP:
-		return process_mmap_event(event, offset, head);
-
-	case PERF_RECORD_COMM:
-		return process_comm_event(event, offset, head);
-
-	case PERF_RECORD_FORK:
-	case PERF_RECORD_EXIT:
-		return process_task_event(event, offset, head);
-
-	case PERF_RECORD_LOST:
-		return process_lost_event(event, offset, head);
-
-	case PERF_RECORD_READ:
-		return process_read_event(event, offset, head);
-
-	/*
-	 * We dont process them right now but they are fine:
-	 */
-
-	case PERF_RECORD_THROTTLE:
-	case PERF_RECORD_UNTHROTTLE:
-		return 0;
-
-	default:
-		return -1;
-	}
-
-	return 0;
-}
-
-static int __cmd_report(void)
+static int sample_type_check(u64 type)
 {
-	int ret, rc = EXIT_FAILURE;
-	unsigned long offset = 0;
-	unsigned long head, shift;
-	struct stat input_stat;
-	struct thread *idle;
-	event_t *event;
-	uint32_t size;
-	char *buf;
-
-	idle = register_idle_thread(&threads, &last_match);
-	thread__comm_adjust(idle);
-
-	if (show_threads)
-		perf_read_values_init(&show_threads_values);
-
-	input = open(input_name, O_RDONLY);
-	if (input < 0) {
-		fprintf(stderr, " failed to open file: %s", input_name);
-		if (!strcmp(input_name, "perf.data"))
-			fprintf(stderr, "  (try 'perf record' first)");
-		fprintf(stderr, "\n");
-		exit(-1);
-	}
-
-	ret = fstat(input, &input_stat);
-	if (ret < 0) {
-		perror("failed to stat file");
-		exit(-1);
-	}
-
-	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
-		fprintf(stderr, "file: %s not owned by current user or root\n", input_name);
-		exit(-1);
-	}
-
-	if (!input_stat.st_size) {
-		fprintf(stderr, "zero-sized file, nothing to do!\n");
-		exit(0);
-	}
-
-	header = perf_header__read(input);
-	head = header->data_offset;
-
-	sample_type = perf_header__sample_type(header);
+	sample_type = type;
 
 	if (!(sample_type & PERF_SAMPLE_CALLCHAIN)) {
 		if (sort__has_parent) {
 			fprintf(stderr, "selected --sort parent, but no"
 					" callchain data. Did you call"
 					" perf record without -g?\n");
-			exit(-1);
+			return -1;
 		}
 		if (callchain) {
 			fprintf(stderr, "selected -g but no callchain data."
 					" Did you call perf record without"
 					" -g?\n");
-			exit(-1);
+			return -1;
 		}
 	} else if (callchain_param.mode != CHAIN_NONE && !callchain) {
 			callchain = 1;
 			if (register_callchain_param(&callchain_param) < 0) {
 				fprintf(stderr, "Can't register callchain"
 						" params\n");
-				exit(-1);
+				return -1;
 			}
 	}
 
-	if (load_kernel() < 0) {
-		perror("failed to load kernel symbols");
-		return EXIT_FAILURE;
-	}
-
-	if (!full_paths) {
-		if (getcwd(__cwd, sizeof(__cwd)) == NULL) {
-			perror("failed to get the current directory");
-			return EXIT_FAILURE;
-		}
-		cwdlen = strlen(cwd);
-	} else {
-		cwd = NULL;
-		cwdlen = 0;
-	}
-
-	shift = page_size * (head / page_size);
-	offset += shift;
-	head -= shift;
-
-remap:
-	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
-			   MAP_SHARED, input, offset);
-	if (buf == MAP_FAILED) {
-		perror("failed to mmap file");
-		exit(-1);
-	}
-
-more:
-	event = (event_t *)(buf + head);
-
-	size = event->header.size;
-	if (!size)
-		size = 8;
-
-	if (head + event->header.size >= page_size * mmap_window) {
-		int munmap_ret;
-
-		shift = page_size * (head / page_size);
-
-		munmap_ret = munmap(buf, page_size * mmap_window);
-		assert(munmap_ret == 0);
-
-		offset += shift;
-		head -= shift;
-		goto remap;
-	}
-
-	size = event->header.size;
-
-	dump_printf("\n%p [%p]: event: %d\n",
-			(void *)(offset + head),
-			(void *)(long)event->header.size,
-			event->header.type);
-
-	if (!size || process_event(event, offset, head) < 0) {
-
-		dump_printf("%p [%p]: skipping unknown header type: %d\n",
-			(void *)(offset + head),
-			(void *)(long)(event->header.size),
-			event->header.type);
-
-		total_unknown++;
+	return 0;
+}
 
-		/*
-		 * assume we lost track of the stream, check alignment, and
-		 * increment a single u64 in the hope to catch on again 'soon'.
-		 */
+static struct perf_file_handler file_handler = {
+	.process_sample_event	= process_sample_event,
+	.process_mmap_event	= process_mmap_event,
+	.process_comm_event	= process_comm_event,
+	.process_exit_event	= process_task_event,
+	.process_fork_event	= process_task_event,
+	.process_lost_event	= process_lost_event,
+	.process_read_event	= process_read_event,
+	.sample_type_check	= sample_type_check,
+};
 
-		if (unlikely(head & 7))
-			head &= ~7ULL;
 
-		size = 8;
-	}
+static int __cmd_report(void)
+{
+	struct thread *idle;
+	int ret;
 
-	head += size;
+	idle = register_idle_thread(&threads, &last_match);
+	thread__comm_adjust(idle);
 
-	if (offset + head >= header->data_offset + header->data_size)
-		goto done;
+	if (show_threads)
+		perf_read_values_init(&show_threads_values);
 
-	if (offset + head < (unsigned long)input_stat.st_size)
-		goto more;
+	register_perf_file_handler(&file_handler);
 
-done:
-	rc = EXIT_SUCCESS;
-	close(input);
+	ret = mmap_dispatch_perf_file(&header, input_name, force, full_paths,
+				      &cwdlen, &cwd);
+	if (ret)
+		return ret;
 
 	dump_printf("      IP events: %10ld\n", total);
 	dump_printf("    mmap events: %10ld\n", total_mmap);
 	dump_printf("    comm events: %10ld\n", total_comm);
 	dump_printf("    fork events: %10ld\n", total_fork);
 	dump_printf("    lost events: %10ld\n", total_lost);
-	dump_printf(" unknown events: %10ld\n", total_unknown);
+	dump_printf(" unknown events: %10ld\n", file_handler.total_unknown);
 
 	if (dump_trace)
 		return 0;
@@ -1034,7 +893,7 @@ done:
 	if (show_threads)
 		perf_read_values_destroy(&show_threads_values);
 
-	return rc;
+	return ret;
 }
 
 static int
@@ -1177,8 +1036,6 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
 	symbol__init();
 
-	page_size = getpagesize();
-
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
 	setup_sorting();
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 1887138..e1df705 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -11,6 +11,7 @@
 #include "util/trace-event.h"
 
 #include "util/debug.h"
+#include "util/data_map.h"
 
 #include <sys/types.h>
 #include <sys/prctl.h>
@@ -20,9 +21,6 @@
 #include <math.h>
 
 static char			const *input_name = "perf.data";
-static int			input;
-static unsigned long		page_size;
-static unsigned long		mmap_window = 32;
 
 static unsigned long		total_comm = 0;
 
@@ -35,6 +33,9 @@ static u64			sample_type;
 static char			default_sort_order[] = "avg, max, switch, runtime";
 static char			*sort_order = default_sort_order;
 
+static char			*cwd;
+static int			cwdlen;
+
 #define PR_SET_NAME		15               /* Set process name */
 #define MAX_CPUS		4096
 
@@ -1594,129 +1595,43 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 }
 
 static int
-process_event(event_t *event, unsigned long offset, unsigned long head)
+process_lost_event(event_t *event __used,
+		   unsigned long offset __used,
+		   unsigned long head __used)
 {
-	trace_event(event);
-
-	nr_events++;
-	switch (event->header.type) {
-	case PERF_RECORD_MMAP:
-		return 0;
-	case PERF_RECORD_LOST:
-		nr_lost_chunks++;
-		nr_lost_events += event->lost.lost;
-		return 0;
-
-	case PERF_RECORD_COMM:
-		return process_comm_event(event, offset, head);
+	nr_lost_chunks++;
+	nr_lost_events += event->lost.lost;
 
-	case PERF_RECORD_EXIT ... PERF_RECORD_READ:
-		return 0;
+	return 0;
+}
 
-	case PERF_RECORD_SAMPLE:
-		return process_sample_event(event, offset, head);
+static int sample_type_check(u64 type)
+{
+	sample_type = type;
 
-	case PERF_RECORD_MAX:
-	default:
+	if (!(sample_type & PERF_SAMPLE_RAW)) {
+		fprintf(stderr,
+			"No trace sample to read. Did you call perf record "
+			"without -R?");
 		return -1;
 	}
 
 	return 0;
 }
 
+static struct perf_file_handler file_handler = {
+	.process_sample_event	= process_sample_event,
+	.process_comm_event	= process_comm_event,
+	.process_lost_event	= process_lost_event,
+	.sample_type_check	= sample_type_check,
+};
+
 static int read_events(void)
 {
-	int ret, rc = EXIT_FAILURE;
-	unsigned long offset = 0;
-	unsigned long head = 0;
-	struct stat perf_stat;
-	event_t *event;
-	uint32_t size;
-	char *buf;
-
 	register_idle_thread(&threads, &last_match);
+	register_perf_file_handler(&file_handler);
 
-	input = open(input_name, O_RDONLY);
-	if (input < 0) {
-		perror("failed to open file");
-		exit(-1);
-	}
-
-	ret = fstat(input, &perf_stat);
-	if (ret < 0) {
-		perror("failed to stat file");
-		exit(-1);
-	}
-
-	if (!perf_stat.st_size) {
-		fprintf(stderr, "zero-sized file, nothing to do!\n");
-		exit(0);
-	}
-	header = perf_header__read(input);
-	head = header->data_offset;
-	sample_type = perf_header__sample_type(header);
-
-	if (!(sample_type & PERF_SAMPLE_RAW))
-		die("No trace sample to read. Did you call perf record "
-		    "without -R?");
-
-	if (load_kernel() < 0) {
-		perror("failed to load kernel symbols");
-		return EXIT_FAILURE;
-	}
-
-remap:
-	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
-			   MAP_SHARED, input, offset);
-	if (buf == MAP_FAILED) {
-		perror("failed to mmap file");
-		exit(-1);
-	}
-
-more:
-	event = (event_t *)(buf + head);
-
-	size = event->header.size;
-	if (!size)
-		size = 8;
-
-	if (head + event->header.size >= page_size * mmap_window) {
-		unsigned long shift = page_size * (head / page_size);
-		int res;
-
-		res = munmap(buf, page_size * mmap_window);
-		assert(res == 0);
-
-		offset += shift;
-		head -= shift;
-		goto remap;
-	}
-
-	size = event->header.size;
-
-
-	if (!size || process_event(event, offset, head) < 0) {
-
-		/*
-		 * assume we lost track of the stream, check alignment, and
-		 * increment a single u64 in the hope to catch on again 'soon'.
-		 */
-
-		if (unlikely(head & 7))
-			head &= ~7ULL;
-
-		size = 8;
-	}
-
-	head += size;
-
-	if (offset + head < (unsigned long)perf_stat.st_size)
-		goto more;
-
-	rc = EXIT_SUCCESS;
-	close(input);
-
-	return rc;
+	return mmap_dispatch_perf_file(&header, input_name, 0, 0, &cwdlen, &cwd);
 }
 
 static void print_bad_events(void)
@@ -1934,7 +1849,6 @@ static int __cmd_record(int argc, const char **argv)
 int cmd_sched(int argc, const char **argv, const char *prefix __used)
 {
 	symbol__init();
-	page_size = getpagesize();
 
 	argc = parse_options(argc, argv, sched_options, sched_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index d9abb4a..fb3f3c2 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -12,11 +12,9 @@
 #include "util/debug.h"
 
 #include "util/trace-event.h"
+#include "util/data_map.h"
 
 static char		const *input_name = "perf.data";
-static int		input;
-static unsigned long	page_size;
-static unsigned long	mmap_window = 32;
 
 static unsigned long	total = 0;
 static unsigned long	total_comm = 0;
@@ -27,6 +25,9 @@ static struct thread	*last_match;
 static struct perf_header *header;
 static u64		sample_type;
 
+static char		*cwd;
+static int		cwdlen;
+
 
 static int
 process_comm_event(event_t *event, unsigned long offset, unsigned long head)
@@ -112,125 +113,32 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
-static int
-process_event(event_t *event, unsigned long offset, unsigned long head)
+static int sample_type_check(u64 type)
 {
-	trace_event(event);
-
-	switch (event->header.type) {
-	case PERF_RECORD_MMAP ... PERF_RECORD_LOST:
-		return 0;
-
-	case PERF_RECORD_COMM:
-		return process_comm_event(event, offset, head);
-
-	case PERF_RECORD_EXIT ... PERF_RECORD_READ:
-		return 0;
+	sample_type = type;
 
-	case PERF_RECORD_SAMPLE:
-		return process_sample_event(event, offset, head);
-
-	case PERF_RECORD_MAX:
-	default:
+	if (!(sample_type & PERF_SAMPLE_RAW)) {
+		fprintf(stderr,
+			"No trace sample to read. Did you call perf record "
+			"without -R?");
 		return -1;
 	}
 
 	return 0;
 }
 
+static struct perf_file_handler file_handler = {
+	.process_sample_event	= process_sample_event,
+	.process_comm_event	= process_comm_event,
+	.sample_type_check	= sample_type_check,
+};
+
 static int __cmd_trace(void)
 {
-	int ret, rc = EXIT_FAILURE;
-	unsigned long offset = 0;
-	unsigned long head = 0;
-	unsigned long shift;
-	struct stat perf_stat;
-	event_t *event;
-	uint32_t size;
-	char *buf;
-
 	register_idle_thread(&threads, &last_match);
+	register_perf_file_handler(&file_handler);
 
-	input = open(input_name, O_RDONLY);
-	if (input < 0) {
-		perror("failed to open file");
-		exit(-1);
-	}
-
-	ret = fstat(input, &perf_stat);
-	if (ret < 0) {
-		perror("failed to stat file");
-		exit(-1);
-	}
-
-	if (!perf_stat.st_size) {
-		fprintf(stderr, "zero-sized file, nothing to do!\n");
-		exit(0);
-	}
-	header = perf_header__read(input);
-	head = header->data_offset;
-	sample_type = perf_header__sample_type(header);
-
-	if (!(sample_type & PERF_SAMPLE_RAW))
-		die("No trace sample to read. Did you call perf record "
-		    "without -R?");
-
-	if (load_kernel() < 0) {
-		perror("failed to load kernel symbols");
-		return EXIT_FAILURE;
-	}
-
-	shift = page_size * (head / page_size);
-	offset += shift;
-	head -= shift;
-
-remap:
-	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
-			   MAP_SHARED, input, offset);
-	if (buf == MAP_FAILED) {
-		perror("failed to mmap file");
-		exit(-1);
-	}
-
-more:
-	event = (event_t *)(buf + head);
-
-	if (head + event->header.size >= page_size * mmap_window) {
-		int res;
-
-		shift = page_size * (head / page_size);
-		res = munmap(buf, page_size * mmap_window);
-		assert(res == 0);
-
-		offset += shift;
-		head -= shift;
-		goto remap;
-	}
-
-	size = event->header.size;
-
-	if (!size || process_event(event, offset, head) < 0) {
-
-		/*
-		 * assume we lost track of the stream, check alignment, and
-		 * increment a single u64 in the hope to catch on again 'soon'.
-		 */
-
-		if (unlikely(head & 7))
-			head &= ~7ULL;
-
-		size = 8;
-	}
-
-	head += size;
-
-	if (offset + head < (unsigned long)perf_stat.st_size)
-		goto more;
-
-	rc = EXIT_SUCCESS;
-	close(input);
-
-	return rc;
+	return mmap_dispatch_perf_file(&header, input_name, 0, 0, &cwdlen, &cwd);
 }
 
 static const char * const annotate_usage[] = {
@@ -249,7 +157,6 @@ static const struct option options[] = {
 int cmd_trace(int argc, const char **argv, const char *prefix __used)
 {
 	symbol__init();
-	page_size = getpagesize();
 
 	argc = parse_options(argc, argv, options, annotate_usage, 0);
 	if (argc) {
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
new file mode 100644
index 0000000..242b055
--- /dev/null
+++ b/tools/perf/util/data_map.c
@@ -0,0 +1,222 @@
+#include "data_map.h"
+#include "symbol.h"
+#include "util.h"
+#include "debug.h"
+
+
+static struct perf_file_handler *curr_handler;
+static unsigned long	mmap_window = 32;
+static char		__cwd[PATH_MAX];
+
+static int
+process_event_stub(event_t *event __used,
+		   unsigned long offset __used,
+		   unsigned long head __used)
+{
+	return 0;
+}
+
+void register_perf_file_handler(struct perf_file_handler *handler)
+{
+	if (!handler->process_sample_event)
+		handler->process_sample_event = process_event_stub;
+	if (!handler->process_mmap_event)
+		handler->process_mmap_event = process_event_stub;
+	if (!handler->process_comm_event)
+		handler->process_comm_event = process_event_stub;
+	if (!handler->process_fork_event)
+		handler->process_fork_event = process_event_stub;
+	if (!handler->process_exit_event)
+		handler->process_exit_event = process_event_stub;
+	if (!handler->process_lost_event)
+		handler->process_lost_event = process_event_stub;
+	if (!handler->process_read_event)
+		handler->process_read_event = process_event_stub;
+	if (!handler->process_throttle_event)
+		handler->process_throttle_event = process_event_stub;
+	if (!handler->process_unthrottle_event)
+		handler->process_unthrottle_event = process_event_stub;
+
+	curr_handler = handler;
+}
+
+static int
+process_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	trace_event(event);
+
+	switch (event->header.type) {
+	case PERF_RECORD_SAMPLE:
+		return curr_handler->process_sample_event(event, offset, head);
+	case PERF_RECORD_MMAP:
+		return curr_handler->process_mmap_event(event, offset, head);
+	case PERF_RECORD_COMM:
+		return curr_handler->process_comm_event(event, offset, head);
+	case PERF_RECORD_FORK:
+		return curr_handler->process_fork_event(event, offset, head);
+	case PERF_RECORD_EXIT:
+		return curr_handler->process_exit_event(event, offset, head);
+	case PERF_RECORD_LOST:
+		return curr_handler->process_lost_event(event, offset, head);
+	case PERF_RECORD_READ:
+		return curr_handler->process_read_event(event, offset, head);
+	case PERF_RECORD_THROTTLE:
+		return curr_handler->process_throttle_event(event, offset, head);
+	case PERF_RECORD_UNTHROTTLE:
+		return curr_handler->process_unthrottle_event(event, offset, head);
+	default:
+		curr_handler->total_unknown++;
+		return -1;
+	}
+}
+
+int mmap_dispatch_perf_file(struct perf_header **pheader,
+			    const char *input_name,
+			    int force,
+			    int full_paths,
+			    int *cwdlen,
+			    char **cwd)
+{
+	int ret, rc = EXIT_FAILURE;
+	struct perf_header *header;
+	unsigned long head, shift;
+	unsigned long offset = 0;
+	struct stat input_stat;
+	size_t	page_size;
+	u64 sample_type;
+	event_t *event;
+	uint32_t size;
+	int input;
+	char *buf;
+
+	if (!curr_handler)
+		die("Forgot to register perf file handler");
+
+	page_size = getpagesize();
+
+	input = open(input_name, O_RDONLY);
+	if (input < 0) {
+		fprintf(stderr, " failed to open file: %s", input_name);
+		if (!strcmp(input_name, "perf.data"))
+			fprintf(stderr, "  (try 'perf record' first)");
+		fprintf(stderr, "\n");
+		exit(-1);
+	}
+
+	ret = fstat(input, &input_stat);
+	if (ret < 0) {
+		perror("failed to stat file");
+		exit(-1);
+	}
+
+	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
+		fprintf(stderr, "file: %s not owned by current user or root\n",
+			input_name);
+		exit(-1);
+	}
+
+	if (!input_stat.st_size) {
+		fprintf(stderr, "zero-sized file, nothing to do!\n");
+		exit(0);
+	}
+
+	*pheader = perf_header__read(input);
+	header = *pheader;
+	head = header->data_offset;
+
+	sample_type = perf_header__sample_type(header);
+
+	if (curr_handler->sample_type_check)
+		if (curr_handler->sample_type_check(sample_type) < 0)
+			exit(-1);
+
+	if (load_kernel() < 0) {
+		perror("failed to load kernel symbols");
+		return EXIT_FAILURE;
+	}
+
+	if (!full_paths) {
+		if (getcwd(__cwd, sizeof(__cwd)) == NULL) {
+			perror("failed to get the current directory");
+			return EXIT_FAILURE;
+		}
+		*cwd = __cwd;
+		*cwdlen = strlen(*cwd);
+	} else {
+		*cwd = NULL;
+		*cwdlen = 0;
+	}
+
+	shift = page_size * (head / page_size);
+	offset += shift;
+	head -= shift;
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
+		int munmap_ret;
+
+		shift = page_size * (head / page_size);
+
+		munmap_ret = munmap(buf, page_size * mmap_window);
+		assert(munmap_ret == 0);
+
+		offset += shift;
+		head -= shift;
+		goto remap;
+	}
+
+	size = event->header.size;
+
+	dump_printf("\n%p [%p]: event: %d\n",
+			(void *)(offset + head),
+			(void *)(long)event->header.size,
+			event->header.type);
+
+	if (!size || process_event(event, offset, head) < 0) {
+
+		dump_printf("%p [%p]: skipping unknown header type: %d\n",
+			(void *)(offset + head),
+			(void *)(long)(event->header.size),
+			event->header.type);
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
+	if (offset + head >= header->data_offset + header->data_size)
+		goto done;
+
+	if (offset + head < (unsigned long)input_stat.st_size)
+		goto more;
+
+done:
+	rc = EXIT_SUCCESS;
+	close(input);
+
+	return rc;
+}
+
+
diff --git a/tools/perf/util/data_map.h b/tools/perf/util/data_map.h
new file mode 100644
index 0000000..716d105
--- /dev/null
+++ b/tools/perf/util/data_map.h
@@ -0,0 +1,31 @@
+#ifndef __PERF_DATAMAP_H
+#define __PERF_DATAMAP_H
+
+#include "event.h"
+#include "header.h"
+
+typedef int (*event_type_handler_t)(event_t *, unsigned long, unsigned long);
+
+struct perf_file_handler {
+	event_type_handler_t	process_sample_event;
+	event_type_handler_t	process_mmap_event;
+	event_type_handler_t	process_comm_event;
+	event_type_handler_t	process_fork_event;
+	event_type_handler_t	process_exit_event;
+	event_type_handler_t	process_lost_event;
+	event_type_handler_t	process_read_event;
+	event_type_handler_t	process_throttle_event;
+	event_type_handler_t	process_unthrottle_event;
+	int			(*sample_type_check)(u64 sample_type);
+	unsigned long		total_unknown;
+};
+
+void register_perf_file_handler(struct perf_file_handler *handler);
+int mmap_dispatch_perf_file(struct perf_header **pheader,
+			    const char *input_name,
+			    int force,
+			    int full_paths,
+			    int *cwdlen,
+			    char **cwd);
+
+#endif
