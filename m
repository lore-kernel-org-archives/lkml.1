Return-Path: <linux-kernel-owner+w=401wt.eu-S1762766AbZLKXYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762766AbZLKXYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762733AbZLKXYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:24:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:33706 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762732AbZLKXYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:24:07 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf tools: Introduce perf_session class
Date: Fri, 11 Dec 2009 21:24:02 -0200
Message-Id: <1260573842-19720-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

That does all the initialization boilerplate, opening the file, reading
the header, checking if it is valid, etc.

And that will as well have the threads list, kmap (now) global variable,
etc, so that we can handle two (or more) perf.data files describing
sessions to compare.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile               |    3 +
 tools/perf/builtin-annotate.c     |   15 +++++--
 tools/perf/builtin-buildid-list.c |   55 ++++---------------------
 tools/perf/builtin-kmem.c         |   13 +++++-
 tools/perf/builtin-record.c       |   25 ++++++------
 tools/perf/builtin-report.c       |   20 ++++++---
 tools/perf/builtin-sched.c        |   13 +++++-
 tools/perf/builtin-timechart.c    |   15 ++++---
 tools/perf/builtin-trace.c        |   20 ++++++----
 tools/perf/util/data_map.c        |   71 +++++---------------------------
 tools/perf/util/data_map.h        |    9 +---
 tools/perf/util/header.c          |   28 +++----------
 tools/perf/util/header.h          |    4 +-
 tools/perf/util/session.c         |   80 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.h         |   16 +++++++
 15 files changed, 206 insertions(+), 181 deletions(-)
 create mode 100644 tools/perf/util/session.c
 create mode 100644 tools/perf/util/session.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e2ee3b5..4069996 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -356,7 +356,9 @@ LIB_H += util/parse-options.h
 LIB_H += util/parse-events.h
 LIB_H += util/quote.h
 LIB_H += util/util.h
+LIB_H += util/header.h
 LIB_H += util/help.h
+LIB_H += util/session.h
 LIB_H += util/strbuf.h
 LIB_H += util/string.h
 LIB_H += util/strlist.h
@@ -405,6 +407,7 @@ LIB_OBJS += util/callchain.o
 LIB_OBJS += util/values.o
 LIB_OBJS += util/debug.o
 LIB_OBJS += util/map.o
+LIB_OBJS += util/session.o
 LIB_OBJS += util/thread.o
 LIB_OBJS += util/trace-event-parse.o
 LIB_OBJS += util/trace-event-read.o
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 0bf2e8f..21a78d3 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -25,6 +25,7 @@
 #include "util/thread.h"
 #include "util/sort.h"
 #include "util/hist.h"
+#include "util/session.h"
 #include "util/data_map.h"
 
 static char		const *input_name = "perf.data";
@@ -462,21 +463,23 @@ static struct perf_file_handler file_handler = {
 
 static int __cmd_annotate(void)
 {
-	struct perf_header *header;
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY, force);
 	struct thread *idle;
 	int ret;
 
+	if (session == NULL)
+		return -ENOMEM;
+
 	idle = register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
-	ret = mmap_dispatch_perf_file(&header, input_name, 0, 0,
-				      &event__cwdlen, &event__cwd);
+	ret = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
 	if (ret)
-		return ret;
+		goto out_delete;
 
 	if (dump_trace) {
 		event__print_totals();
-		return 0;
+		goto out_delete;
 	}
 
 	if (verbose > 3)
@@ -489,6 +492,8 @@ static int __cmd_annotate(void)
 	output__resort(event__total[0]);
 
 	find_annotations();
+out_delete:
+	perf_session__delete(session);
 
 	return ret;
 }
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index dcb6143..bfd16a1 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -11,8 +11,8 @@
 #include "util/cache.h"
 #include "util/data_map.h"
 #include "util/debug.h"
-#include "util/header.h"
 #include "util/parse-options.h"
+#include "util/session.h"
 #include "util/symbol.h"
 
 static char const *input_name = "perf.data";
@@ -55,56 +55,17 @@ static int perf_file_section__process_buildids(struct perf_file_section *self,
 static int __cmd_buildid_list(void)
 {
 	int err = -1;
-	struct perf_header *header;
-	struct perf_file_header f_header;
-	struct stat input_stat;
-	int input = open(input_name, O_RDONLY);
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY, force);
 
-	if (input < 0) {
-		pr_err("failed to open file: %s", input_name);
-		if (!strcmp(input_name, "perf.data"))
-			pr_err("  (try 'perf record' first)");
-		pr_err("\n");
-		goto out;
-	}
-
-	err = fstat(input, &input_stat);
-	if (err < 0) {
-		perror("failed to stat file");
-		goto out_close;
-	}
-
-	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
-		pr_err("file %s not owned by current user or root\n",
-		       input_name);
-		goto out_close;
-	}
-
-	if (!input_stat.st_size) {
-		pr_info("zero-sized file, nothing to do!\n");
-		goto out_close;
-	}
-
-	err = -1;
-	header = perf_header__new();
-	if (header == NULL)
-		goto out_close;
-
-	if (perf_file_header__read(&f_header, header, input) < 0) {
-		pr_warning("incompatible file format");
-		goto out_close;
-	}
+	if (session == NULL)
+		return -1;
 
-	err = perf_header__process_sections(header, input,
+	err = perf_header__process_sections(&session->header, session->fd,
 				         perf_file_section__process_buildids);
+	if (err >= 0)
+		dsos__fprintf_buildid(stdout);
 
-	if (err < 0)
-		goto out_close;
-
-	dsos__fprintf_buildid(stdout);
-out_close:
-	close(input);
-out:
+	perf_session__delete(session);
 	return err;
 }
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index fe73435..2071d24 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -6,6 +6,7 @@
 #include "util/symbol.h"
 #include "util/thread.h"
 #include "util/header.h"
+#include "util/session.h"
 
 #include "util/parse-options.h"
 #include "util/trace-event.h"
@@ -20,7 +21,6 @@ typedef int (*sort_fn_t)(struct alloc_stat *, struct alloc_stat *);
 
 static char const		*input_name = "perf.data";
 
-static struct perf_header	*header;
 static u64			sample_type;
 
 static int			alloc_flag;
@@ -367,11 +367,18 @@ static struct perf_file_handler file_handler = {
 
 static int read_events(void)
 {
+	int err;
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
+
+	if (session == NULL)
+		return -ENOMEM;
+
 	register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
-	return mmap_dispatch_perf_file(&header, input_name, 0, 0,
-				       &event__cwdlen, &event__cwd);
+	err = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
+	perf_session__delete(session);
+	return err;
 }
 
 static double fragmentation(unsigned long n_req, unsigned long n_alloc)
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0e519c6..4decbd1 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -17,6 +17,7 @@
 #include "util/header.h"
 #include "util/event.h"
 #include "util/debug.h"
+#include "util/session.h"
 #include "util/symbol.h"
 
 #include <unistd.h>
@@ -62,7 +63,7 @@ static int			nr_cpu				=      0;
 
 static int			file_new			=      1;
 
-struct perf_header		*header				=   NULL;
+static struct perf_session	*session;
 
 struct mmap_data {
 	int			counter;
@@ -216,12 +217,12 @@ static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int n
 {
 	struct perf_header_attr *h_attr;
 
-	if (nr < header->attrs) {
-		h_attr = header->attr[nr];
+	if (nr < session->header.attrs) {
+		h_attr = session->header.attr[nr];
 	} else {
 		h_attr = perf_header_attr__new(a);
 		if (h_attr != NULL)
-			if (perf_header__add_attr(header, h_attr) < 0) {
+			if (perf_header__add_attr(&session->header, h_attr) < 0) {
 				perf_header_attr__delete(h_attr);
 				h_attr = NULL;
 			}
@@ -395,9 +396,9 @@ static void open_counters(int cpu, pid_t pid)
 
 static void atexit_header(void)
 {
-	header->data_size += bytes_written;
+	session->header.data_size += bytes_written;
 
-	perf_header__write(header, output, true);
+	perf_header__write(&session->header, output, true);
 }
 
 static int __cmd_record(int argc, const char **argv)
@@ -440,24 +441,24 @@ static int __cmd_record(int argc, const char **argv)
 		exit(-1);
 	}
 
-	header = perf_header__new();
-	if (header == NULL) {
+	session = perf_session__new(output_name, O_WRONLY, force);
+	if (session == NULL) {
 		pr_err("Not enough memory for reading perf file header\n");
 		return -1;
 	}
 
 	if (!file_new) {
-		err = perf_header__read(header, output);
+		err = perf_header__read(&session->header, output);
 		if (err < 0)
 			return err;
 	}
 
 	if (raw_samples) {
-		perf_header__set_feat(header, HEADER_TRACE_INFO);
+		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
 	} else {
 		for (i = 0; i < nr_counters; i++) {
 			if (attrs[i].sample_type & PERF_SAMPLE_RAW) {
-				perf_header__set_feat(header, HEADER_TRACE_INFO);
+				perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
 				break;
 			}
 		}
@@ -481,7 +482,7 @@ static int __cmd_record(int argc, const char **argv)
 	}
 
 	if (file_new) {
-		err = perf_header__write(header, output, false);
+		err = perf_header__write(&session->header, output, false);
 		if (err < 0)
 			return err;
 	}
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2b9eb3a..e2ec49a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -22,6 +22,7 @@
 #include "perf.h"
 #include "util/debug.h"
 #include "util/header.h"
+#include "util/session.h"
 
 #include "util/parse-options.h"
 #include "util/parse-events.h"
@@ -52,7 +53,7 @@ static int		exclude_other = 1;
 
 static char		callchain_default_opt[] = "fractal,0.5";
 
-static struct perf_header *header;
+static struct perf_session *session;
 
 static u64		sample_type;
 
@@ -701,7 +702,7 @@ static int process_read_event(event_t *event)
 {
 	struct perf_event_attr *attr;
 
-	attr = perf_header__find_attr(event->read.id, header);
+	attr = perf_header__find_attr(event->read.id, &session->header);
 
 	if (show_threads) {
 		const char *name = attr ? __event_name(attr->type, attr->config)
@@ -766,6 +767,10 @@ static int __cmd_report(void)
 	struct thread *idle;
 	int ret;
 
+	session = perf_session__new(input_name, O_RDONLY, force);
+	if (session == NULL)
+		return -ENOMEM;
+
 	idle = register_idle_thread();
 	thread__comm_adjust(idle);
 
@@ -774,14 +779,14 @@ static int __cmd_report(void)
 
 	register_perf_file_handler(&file_handler);
 
-	ret = mmap_dispatch_perf_file(&header, input_name, force,
-				      full_paths, &event__cwdlen, &event__cwd);
+	ret = perf_session__process_events(session, full_paths,
+					   &event__cwdlen, &event__cwd);
 	if (ret)
-		return ret;
+		goto out_delete;
 
 	if (dump_trace) {
 		event__print_totals();
-		return 0;
+		goto out_delete;
 	}
 
 	if (verbose > 3)
@@ -796,7 +801,8 @@ static int __cmd_report(void)
 
 	if (show_threads)
 		perf_read_values_destroy(&show_threads_values);
-
+out_delete:
+	perf_session__delete(session);
 	return ret;
 }
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 7cca7c1..65021fe 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -6,6 +6,7 @@
 #include "util/symbol.h"
 #include "util/thread.h"
 #include "util/header.h"
+#include "util/session.h"
 
 #include "util/parse-options.h"
 #include "util/trace-event.h"
@@ -21,7 +22,6 @@
 
 static char			const *input_name = "perf.data";
 
-static struct perf_header	*header;
 static u64			sample_type;
 
 static char			default_sort_order[] = "avg, max, switch, runtime";
@@ -1663,11 +1663,18 @@ static struct perf_file_handler file_handler = {
 
 static int read_events(void)
 {
+	int err;
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
+
+	if (session == NULL)
+		return -ENOMEM;
+
 	register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
-	return mmap_dispatch_perf_file(&header, input_name, 0, 0,
-				       &event__cwdlen, &event__cwd);
+	err = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
+	perf_session__delete(session);
+	return err;
 }
 
 static void print_bad_events(void)
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index f472df9..759dd2b 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1059,15 +1059,17 @@ static struct perf_file_handler file_handler = {
 
 static int __cmd_timechart(void)
 {
-	struct perf_header *header;
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
 	int ret;
 
+	if (session == NULL)
+		return -ENOMEM;
+
 	register_perf_file_handler(&file_handler);
 
-	ret = mmap_dispatch_perf_file(&header, input_name, 0, 0,
-				      &event__cwdlen, &event__cwd);
+	ret = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
 	if (ret)
-		return EXIT_FAILURE;
+		goto out_delete;
 
 	process_samples();
 
@@ -1079,8 +1081,9 @@ static int __cmd_timechart(void)
 
 	pr_info("Written %2.1f seconds of trace to %s.\n",
 		(last_time - first_time) / 1000000000.0, output_name);
-
-	return EXIT_SUCCESS;
+out_delete:
+	perf_session__delete(session);
+	return ret;
 }
 
 static const char * const timechart_usage[] = {
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c2fcc34..0756664 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -7,6 +7,7 @@
 #include "util/header.h"
 #include "util/exec_cmd.h"
 #include "util/trace-event.h"
+#include "util/session.h"
 
 static char const		*script_name;
 static char const		*generate_script_lang;
@@ -61,7 +62,7 @@ static int cleanup_scripting(void)
 
 static char const		*input_name = "perf.data";
 
-static struct perf_header	*header;
+static struct perf_session 	*session;
 static u64			sample_type;
 
 static int process_sample_event(event_t *event)
@@ -126,11 +127,18 @@ static struct perf_file_handler file_handler = {
 
 static int __cmd_trace(void)
 {
+	int err;
+
+	session = perf_session__new(input_name, O_RDONLY, 0);
+	if (session == NULL)
+		return -ENOMEM;
+
 	register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
-	return mmap_dispatch_perf_file(&header, input_name,
-				       0, 0, &event__cwdlen, &event__cwd);
+	err = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
+	perf_session__delete(session);
+	return err;
 }
 
 struct script_spec {
@@ -348,11 +356,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 			return -1;
 		}
 
-		header = perf_header__new();
-		if (header == NULL)
-			return -1;
-
-		perf_header__read(header, input);
+		perf_header__read(&session->header, input);
 		err = scripting_ops->generate_script("perf-trace");
 		goto out;
 	}
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index 59b65d0..6d46dda 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -129,23 +129,16 @@ out:
 	return err;
 }
 
-int mmap_dispatch_perf_file(struct perf_header **pheader,
-			    const char *input_name,
-			    int force,
-			    int full_paths,
-			    int *cwdlen,
-			    char **cwd)
+int perf_session__process_events(struct perf_session *self,
+				 int full_paths, int *cwdlen, char **cwd)
 {
 	int err;
-	struct perf_header *header;
 	unsigned long head, shift;
 	unsigned long offset = 0;
-	struct stat input_stat;
 	size_t	page_size;
 	u64 sample_type;
 	event_t *event;
 	uint32_t size;
-	int input;
 	char *buf;
 
 	if (curr_handler == NULL) {
@@ -155,56 +148,19 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 
 	page_size = getpagesize();
 
-	input = open(input_name, O_RDONLY);
-	if (input < 0) {
-		pr_err("Failed to open file: %s", input_name);
-		if (!strcmp(input_name, "perf.data"))
-			pr_err("  (try 'perf record' first)");
-		pr_err("\n");
-		return -errno;
-	}
-
-	if (fstat(input, &input_stat) < 0) {
-		pr_err("failed to stat file");
-		err = -errno;
-		goto out_close;
-	}
-
-	err = -EACCES;
-	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
-		pr_err("file: %s not owned by current user or root\n",
-			input_name);
-		goto out_close;
-	}
-
-	if (input_stat.st_size == 0) {
-		pr_info("zero-sized file, nothing to do!\n");
-		goto done;
-	}
-
-	err = -ENOMEM;
-	header = perf_header__new();
-	if (header == NULL)
-		goto out_close;
-
-	err = perf_header__read(header, input);
-	if (err < 0)
-		goto out_delete;
-	*pheader = header;
-	head = header->data_offset;
-
-	sample_type = perf_header__sample_type(header);
+	head = self->header.data_offset;
+	sample_type = perf_header__sample_type(&self->header);
 
 	err = -EINVAL;
 	if (curr_handler->sample_type_check &&
 	    curr_handler->sample_type_check(sample_type) < 0)
-		goto out_delete;
+		goto out_err;
 
 	if (!full_paths) {
 		if (getcwd(__cwd, sizeof(__cwd)) == NULL) {
 			pr_err("failed to get the current directory\n");
 			err = -errno;
-			goto out_delete;
+			goto out_err;
 		}
 		*cwd = __cwd;
 		*cwdlen = strlen(*cwd);
@@ -219,11 +175,11 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 
 remap:
 	buf = mmap(NULL, page_size * mmap_window, PROT_READ,
-		   MAP_SHARED, input, offset);
+		   MAP_SHARED, self->fd, offset);
 	if (buf == MAP_FAILED) {
 		pr_err("failed to mmap file\n");
 		err = -errno;
-		goto out_delete;
+		goto out_err;
 	}
 
 more:
@@ -273,19 +229,14 @@ more:
 
 	head += size;
 
-	if (offset + head >= header->data_offset + header->data_size)
+	if (offset + head >= self->header.data_offset + self->header.data_size)
 		goto done;
 
-	if (offset + head < (unsigned long)input_stat.st_size)
+	if (offset + head < self->size)
 		goto more;
 
 done:
 	err = 0;
-out_close:
-	close(input);
-
+out_err:
 	return err;
-out_delete:
-	perf_header__delete(header);
-	goto out_close;
 }
diff --git a/tools/perf/util/data_map.h b/tools/perf/util/data_map.h
index 258a87b..98c5b82 100644
--- a/tools/perf/util/data_map.h
+++ b/tools/perf/util/data_map.h
@@ -3,6 +3,7 @@
 
 #include "event.h"
 #include "header.h"
+#include "session.h"
 
 typedef int (*event_type_handler_t)(event_t *);
 
@@ -21,12 +22,8 @@ struct perf_file_handler {
 };
 
 void register_perf_file_handler(struct perf_file_handler *handler);
-int mmap_dispatch_perf_file(struct perf_header **pheader,
-			    const char *input_name,
-			    int force,
-			    int full_paths,
-			    int *cwdlen,
-			    char **cwd);
+int perf_session__process_events(struct perf_session *self,
+				 int full_paths, int *cwdlen, char **cwd);
 int perf_header__read_build_ids(int input, u64 offset, u64 file_size);
 
 #endif
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 59a9c0b..f2e8d87 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -58,35 +58,19 @@ int perf_header_attr__add_id(struct perf_header_attr *self, u64 id)
 	return 0;
 }
 
-/*
- * Create new perf.data header:
- */
-struct perf_header *perf_header__new(void)
+int perf_header__init(struct perf_header *self)
 {
-	struct perf_header *self = zalloc(sizeof(*self));
-
-	if (self != NULL) {
-		self->size = 1;
-		self->attr = malloc(sizeof(void *));
-
-		if (self->attr == NULL) {
-			free(self);
-			self = NULL;
-		}
-	}
-
-	return self;
+	self->size = 1;
+	self->attr = malloc(sizeof(void *));
+	return self->attr == NULL ? -ENOMEM : 0;
 }
 
-void perf_header__delete(struct perf_header *self)
+void perf_header__exit(struct perf_header *self)
 {
 	int i;
-
 	for (i = 0; i < self->attrs; ++i)
-		perf_header_attr__delete(self->attr[i]);
-
+                perf_header_attr__delete(self->attr[i]);
 	free(self->attr);
-	free(self);
 }
 
 int perf_header__add_attr(struct perf_header *self,
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index d1dbe2b..d118d05 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -55,8 +55,8 @@ struct perf_header {
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 };
 
-struct perf_header *perf_header__new(void);
-void perf_header__delete(struct perf_header *self);
+int perf_header__init(struct perf_header *self);
+void perf_header__exit(struct perf_header *self);
 
 int perf_header__read(struct perf_header *self, int fd);
 int perf_header__write(struct perf_header *self, int fd, bool at_exit);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
new file mode 100644
index 0000000..707ce1c
--- /dev/null
+++ b/tools/perf/util/session.c
@@ -0,0 +1,80 @@
+#include <linux/kernel.h>
+
+#include <unistd.h>
+#include <sys/types.h>
+
+#include "session.h"
+#include "util.h"
+
+static int perf_session__open(struct perf_session *self, bool force)
+{
+	struct stat input_stat;
+
+	self->fd = open(self->filename, O_RDONLY);
+	if (self->fd < 0) {
+		pr_err("failed to open file: %s", self->filename);
+		if (!strcmp(self->filename, "perf.data"))
+			pr_err("  (try 'perf record' first)");
+		pr_err("\n");
+		return -errno;
+	}
+
+	if (fstat(self->fd, &input_stat) < 0)
+		goto out_close;
+
+	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
+		pr_err("file %s not owned by current user or root\n",
+		       self->filename);
+		goto out_close;
+	}
+
+	if (!input_stat.st_size) {
+		pr_info("zero-sized file (%s), nothing to do!\n",
+			self->filename);
+		goto out_close;
+	}
+
+	if (perf_header__read(&self->header, self->fd) < 0) {
+		pr_err("incompatible file format");
+		goto out_close;
+	}
+
+	self->size = input_stat.st_size;
+	return 0;
+
+out_close:
+	close(self->fd);
+	self->fd = -1;
+	return -1;
+}
+
+struct perf_session *perf_session__new(const char *filename, int mode, bool force)
+{
+	size_t len = strlen(filename) + 1;
+	struct perf_session *self = zalloc(sizeof(*self) + len);
+
+	if (self == NULL)
+		goto out;
+
+	if (perf_header__init(&self->header) < 0)
+		goto out_delete;
+
+	memcpy(self->filename, filename, len);
+
+	if (mode == O_RDONLY && perf_session__open(self, force) < 0) {
+		perf_session__delete(self);
+		self = NULL;
+	}
+out:
+	return self;
+out_delete:
+	free(self);
+	return NULL;
+}
+
+void perf_session__delete(struct perf_session *self)
+{
+	perf_header__exit(&self->header);
+	close(self->fd);
+	free(self);
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
new file mode 100644
index 0000000..f3699c8
--- /dev/null
+++ b/tools/perf/util/session.h
@@ -0,0 +1,16 @@
+#ifndef __PERF_SESSION_H
+#define __PERF_SESSION_H
+
+#include "header.h"
+
+struct perf_session {
+	struct perf_header	header;
+	unsigned long		size;
+	int			fd;
+	char filename[0];
+};
+
+struct perf_session *perf_session__new(const char *filename, int mode, bool force);
+void perf_session__delete(struct perf_session *self);
+
+#endif /* __PERF_SESSION_H */
-- 
1.6.2.5

