Return-Path: <linux-kernel-owner+w=401wt.eu-S932347AbZJGHdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbZJGHdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 03:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932140AbZJGHdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 03:33:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:55385 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110AbZJGHdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 03:33:10 -0400
Date: Wed, 7 Oct 2009 07:31:54 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091006213643.GA5343@nowhere>
References: <20091006213643.GA5343@nowhere>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Merge trace.info content into perf.data
Message-ID: <tip-03456a158d9067d2f657bec170506009db81756d@git.kernel.org>
Git-Commit-ID: 03456a158d9067d2f657bec170506009db81756d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 07 Oct 2009 07:31:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03456a158d9067d2f657bec170506009db81756d
Gitweb:     http://git.kernel.org/tip/03456a158d9067d2f657bec170506009db81756d
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 6 Oct 2009 23:36:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 7 Oct 2009 08:36:10 +0200

perf tools: Merge trace.info content into perf.data

This drops the trace.info file and move its contents into the
common perf.data file.

This is done by creating a new trace_info section into this file. A
user of perf headers needs to call perf_header__set_trace_info() to
save the trace meta informations into the perf.data file.

A file created by perf after his patch is unsupported by previous
version because the size of the headers have increased.

That said, it's two new fields that have been added in the end of
the headers, and those could be ignored by previous versions if
they just handled the dynamic header size and then ignore the
unknow part. The offsets guarantee the compatibility. We'll do a
-stable fix for that.

But current previous versions handle the header size using its
static size, not dynamic, then it's not backward compatible with
trace records.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091006213643.GA5343@nowhere>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c        |    7 ++---
 tools/perf/builtin-sched.c         |    1 -
 tools/perf/builtin-trace.c         |    1 -
 tools/perf/util/header.c           |   42 ++++++++++++++++++++++++++++++++++++
 tools/perf/util/header.h           |    4 ++-
 tools/perf/util/trace-event-info.c |    6 +---
 tools/perf/util/trace-event-read.c |    7 +----
 tools/perf/util/trace-event.h      |    4 +-
 8 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 494f8c7..59af03d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -17,7 +17,6 @@
 #include "util/header.h"
 #include "util/event.h"
 #include "util/debug.h"
-#include "util/trace-event.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -566,17 +565,17 @@ static int __cmd_record(int argc, const char **argv)
 	else
 		header = perf_header__new();
 
-
 	if (raw_samples) {
-		read_tracing_data(attrs, nr_counters);
+		perf_header__set_trace_info();
 	} else {
 		for (i = 0; i < nr_counters; i++) {
 			if (attrs[i].sample_type & PERF_SAMPLE_RAW) {
-				read_tracing_data(attrs, nr_counters);
+				perf_header__set_trace_info();
 				break;
 			}
 		}
 	}
+
 	atexit(atexit_header);
 
 	if (!system_wide) {
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 4470f25..1887138 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1634,7 +1634,6 @@ static int read_events(void)
 	uint32_t size;
 	char *buf;
 
-	trace_report();
 	register_idle_thread(&threads, &last_match);
 
 	input = open(input_name, O_RDONLY);
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index d573d4e..d9abb4a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -149,7 +149,6 @@ static int __cmd_trace(void)
 	uint32_t size;
 	char *buf;
 
-	trace_report();
 	register_idle_thread(&threads, &last_match);
 
 	input = open(input_name, O_RDONLY);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index e306857..212fade 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -5,6 +5,8 @@
 
 #include "util.h"
 #include "header.h"
+#include "../perf.h"
+#include "trace-event.h"
 
 /*
  * Create new perf.data header attribute:
@@ -62,6 +64,8 @@ struct perf_header *perf_header__new(void)
 
 	self->data_offset = 0;
 	self->data_size = 0;
+	self->trace_info_offset = 0;
+	self->trace_info_size = 0;
 
 	return self;
 }
@@ -145,8 +149,16 @@ struct perf_file_header {
 	struct perf_file_section	attrs;
 	struct perf_file_section	data;
 	struct perf_file_section	event_types;
+	struct perf_file_section	trace_info;
 };
 
+static int trace_info;
+
+void perf_header__set_trace_info(void)
+{
+	trace_info = 1;
+}
+
 static void do_write(int fd, void *buf, size_t size)
 {
 	while (size) {
@@ -198,6 +210,23 @@ void perf_header__write(struct perf_header *self, int fd)
 	if (events)
 		do_write(fd, events, self->event_size);
 
+	if (trace_info) {
+		static int trace_info_written;
+
+		/*
+		 * Write it only once
+		 */
+		if (!trace_info_written) {
+			self->trace_info_offset = lseek(fd, 0, SEEK_CUR);
+			read_tracing_data(fd, attrs, nr_counters);
+			self->trace_info_size = lseek(fd, 0, SEEK_CUR) -
+						self->trace_info_offset;
+			trace_info_written = 1;
+		} else {
+			lseek(fd, self->trace_info_offset +
+				self->trace_info_size, SEEK_SET);
+		}
+	}
 
 	self->data_offset = lseek(fd, 0, SEEK_CUR);
 
@@ -217,6 +246,10 @@ void perf_header__write(struct perf_header *self, int fd)
 			.offset = self->event_offset,
 			.size	= self->event_size,
 		},
+		.trace_info = {
+			.offset = self->trace_info_offset,
+			.size = self->trace_info_size,
+		},
 	};
 
 	lseek(fd, 0, SEEK_SET);
@@ -290,6 +323,15 @@ struct perf_header *perf_header__read(int fd)
 		do_read(fd, events, f_header.event_types.size);
 		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
 	}
+
+	self->trace_info_offset = f_header.trace_info.offset;
+	self->trace_info_size = f_header.trace_info.size;
+
+	if (self->trace_info_size) {
+		lseek(fd, self->trace_info_offset, SEEK_SET);
+		trace_report(fd);
+	}
+
 	self->event_offset = f_header.event_types.offset;
 	self->event_size   = f_header.event_types.size;
 
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index a2916b6..30aee51 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -21,6 +21,8 @@ struct perf_header {
 	u64 data_size;
 	u64 event_offset;
 	u64 event_size;
+	u64 trace_info_offset;
+	u64 trace_info_size;
 };
 
 struct perf_header *perf_header__read(int fd);
@@ -40,7 +42,7 @@ void perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
 u64 perf_header__sample_type(struct perf_header *header);
 struct perf_event_attr *
 perf_header__find_attr(u64 id, struct perf_header *header);
-
+void perf_header__set_trace_info(void);
 
 struct perf_header *perf_header__new(void);
 
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index af4b057..831052d 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -496,14 +496,12 @@ get_tracepoints_path(struct perf_event_attr *pattrs, int nb_events)
 
 	return path.next;
 }
-void read_tracing_data(struct perf_event_attr *pattrs, int nb_events)
+void read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
 {
 	char buf[BUFSIZ];
 	struct tracepoint_path *tps;
 
-	output_fd = open(output_file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
-	if (output_fd < 0)
-		die("creating file '%s'", output_file);
+	output_fd = fd;
 
 	buf[0] = 23;
 	buf[1] = 8;
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 1b5c847..44292e0 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -458,9 +458,8 @@ struct record *trace_read_data(int cpu)
 	return data;
 }
 
-void trace_report(void)
+void trace_report(int fd)
 {
-	const char *input_file = "trace.info";
 	char buf[BUFSIZ];
 	char test[] = { 23, 8, 68 };
 	char *version;
@@ -468,9 +467,7 @@ void trace_report(void)
 	int show_funcs = 0;
 	int show_printk = 0;
 
-	input_fd = open(input_file, O_RDONLY);
-	if (input_fd < 0)
-		die("opening '%s'\n", input_file);
+	input_fd = fd;
 
 	read_or_die(buf, 3);
 	if (memcmp(buf, test, 3) != 0)
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 5f59a39..da77e07 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -158,7 +158,7 @@ struct record *trace_read_data(int cpu);
 
 void parse_set_info(int nr_cpus, int long_sz);
 
-void trace_report(void);
+void trace_report(int fd);
 
 void *malloc_or_die(unsigned int size);
 
@@ -244,6 +244,6 @@ unsigned long long
 raw_field_value(struct event *event, const char *name, void *data);
 void *raw_field_ptr(struct event *event, const char *name, void *data);
 
-void read_tracing_data(struct perf_event_attr *pattrs, int nb_events);
+void read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events);
 
 #endif /* __PERF_TRACE_EVENTS_H */
