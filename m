Return-Path: <linux-kernel-owner+w=401wt.eu-S935027AbZJOIvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935027AbZJOIvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934984AbZJOIvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:51:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:33855 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934982AbZJOIvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:51:44 -0400
Date: Thu, 15 Oct 2009 08:50:39 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, srostedt@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091014194400.076588953@goodmis.org>
References: <20091014194400.076588953@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add latency format to trace output
Message-ID: <tip-cda48461c7fb8431a99b7960480f5f42cc1a5324@git.kernel.org>
Git-Commit-ID: cda48461c7fb8431a99b7960480f5f42cc1a5324
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 08:50:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cda48461c7fb8431a99b7960480f5f42cc1a5324
Gitweb:     http://git.kernel.org/tip/cda48461c7fb8431a99b7960480f5f42cc1a5324
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 14 Oct 2009 15:43:42 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 10:42:39 +0200

perf tools: Add latency format to trace output

Add the irqs disabled, preemption count, need resched, and other
info that is shown in the latency format of ftrace.

 # perf trace -l
    perf-16457   2..s2. 53636.260344: kmem_cache_free: call_site=ffffffff811198f
    perf-16457   2..s2. 53636.264330: kmem_cache_free: call_site=ffffffff811198f
    perf-16457   2d.s4. 53636.300006: kmem_cache_free: call_site=ffffffff810d889

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091014194400.076588953@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-trace.c          |    2 +
 tools/perf/util/trace-event-parse.c |  120 +++++++++++++++++++++++++++++------
 tools/perf/util/trace-event.h       |   11 +++
 3 files changed, 114 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index ccf867d..ce8459a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -144,6 +144,8 @@ static const struct option options[] = {
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('l', "latency", &latency_format,
+		    "show latency attributes (irqs/preemption disabled, etc)"),
 	OPT_END()
 };
 
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index c174765..fde1a43 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -40,6 +40,8 @@ int header_page_size_size;
 int header_page_data_offset;
 int header_page_data_size;
 
+int latency_format;
+
 static char *input_buf;
 static unsigned long long input_buf_ptr;
 static unsigned long long input_buf_siz;
@@ -1928,37 +1930,67 @@ static int get_common_info(const char *type, int *offset, int *size)
 	return 0;
 }
 
-int trace_parse_common_type(void *data)
+static int __parse_common(void *data, int *size, int *offset,
+			  char *name)
 {
-	static int type_offset;
-	static int type_size;
 	int ret;
 
-	if (!type_size) {
-		ret = get_common_info("common_type",
-				      &type_offset,
-				      &type_size);
+	if (!*size) {
+		ret = get_common_info(name, offset, size);
 		if (ret < 0)
 			return ret;
 	}
-	return read_size(data + type_offset, type_size);
+	return read_size(data + *offset, *size);
+}
+
+int trace_parse_common_type(void *data)
+{
+	static int type_offset;
+	static int type_size;
+
+	return __parse_common(data, &type_size, &type_offset,
+			      (char *)"common_type");
 }
 
 static int parse_common_pid(void *data)
 {
 	static int pid_offset;
 	static int pid_size;
+
+	return __parse_common(data, &pid_size, &pid_offset,
+			      (char *)"common_pid");
+}
+
+static int parse_common_pc(void *data)
+{
+	static int pc_offset;
+	static int pc_size;
+
+	return __parse_common(data, &pc_size, &pc_offset,
+			      (char *)"common_preempt_count");
+}
+
+static int parse_common_flags(void *data)
+{
+	static int flags_offset;
+	static int flags_size;
+
+	return __parse_common(data, &flags_size, &flags_offset,
+			      (char *)"common_flags");
+}
+
+static int parse_common_lock_depth(void *data)
+{
+	static int ld_offset;
+	static int ld_size;
 	int ret;
 
-	if (!pid_size) {
-		ret = get_common_info("common_pid",
-				      &pid_offset,
-				      &pid_size);
-		if (ret < 0)
-			return ret;
-	}
+	ret = __parse_common(data, &ld_size, &ld_offset,
+			     (char *)"common_lock_depth");
+	if (ret < 0)
+		return -1;
 
-	return read_size(data + pid_offset, pid_size);
+	return ret;
 }
 
 struct event *trace_find_event(int id)
@@ -2525,6 +2557,41 @@ static inline int log10_cpu(int nb)
 	return 1;
 }
 
+static void print_lat_fmt(void *data, int size __unused)
+{
+	unsigned int lat_flags;
+	unsigned int pc;
+	int lock_depth;
+	int hardirq;
+	int softirq;
+
+	lat_flags = parse_common_flags(data);
+	pc = parse_common_pc(data);
+	lock_depth = parse_common_lock_depth(data);
+
+	hardirq = lat_flags & TRACE_FLAG_HARDIRQ;
+	softirq = lat_flags & TRACE_FLAG_SOFTIRQ;
+
+	printf("%c%c%c",
+	       (lat_flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
+	       (lat_flags & TRACE_FLAG_IRQS_NOSUPPORT) ?
+	       'X' : '.',
+	       (lat_flags & TRACE_FLAG_NEED_RESCHED) ?
+	       'N' : '.',
+	       (hardirq && softirq) ? 'H' :
+	       hardirq ? 'h' : softirq ? 's' : '.');
+
+	if (pc)
+		printf("%x", pc);
+	else
+		printf(".");
+
+	if (lock_depth < 0)
+		printf(".");
+	else
+		printf("%d", lock_depth);
+}
+
 /* taken from Linux, written by Frederic Weisbecker */
 static void print_graph_cpu(int cpu)
 {
@@ -2768,6 +2835,11 @@ pretty_print_func_ent(void *data, int size, struct event *event,
 
 	printf(" | ");
 
+	if (latency_format) {
+		print_lat_fmt(data, size);
+		printf(" | ");
+	}
+
 	field = find_field(event, "func");
 	if (!field)
 		die("function entry does not have func field");
@@ -2811,6 +2883,11 @@ pretty_print_func_ret(void *data, int size __unused, struct event *event,
 
 	printf(" | ");
 
+	if (latency_format) {
+		print_lat_fmt(data, size);
+		printf(" | ");
+	}
+
 	field = find_field(event, "rettime");
 	if (!field)
 		die("can't find rettime in return graph");
@@ -2882,9 +2959,14 @@ void print_event(int cpu, void *data, int size, unsigned long long nsecs,
 		return pretty_print_func_graph(data, size, event, cpu,
 					       pid, comm, secs, usecs);
 
-	printf("%16s-%-5d [%03d] %5lu.%09Lu: %s: ",
-	       comm, pid,  cpu,
-	       secs, nsecs, event->name);
+	if (latency_format) {
+		printf("%8.8s-%-5d %3d",
+		       comm, pid, cpu);
+		print_lat_fmt(data, size);
+	} else
+		printf("%16s-%-5d [%03d]", comm, pid,  cpu);
+
+	printf(" %5lu.%06lu: %s: ", secs, usecs, event->name);
 
 	if (event->flags & EVENT_FL_FAILED) {
 		printf("EVENT '%s' FAILED TO PARSE\n",
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 29821ac..f6637c2 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -239,6 +239,8 @@ extern int header_page_size_size;
 extern int header_page_data_offset;
 extern int header_page_data_size;
 
+extern int latency_format;
+
 int parse_header_page(char *buf, unsigned long size);
 int trace_parse_common_type(void *data);
 struct event *trace_find_event(int id);
@@ -248,4 +250,13 @@ void *raw_field_ptr(struct event *event, const char *name, void *data);
 
 void read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events);
 
+/* taken from kernel/trace/trace.h */
+enum trace_flag_type {
+	TRACE_FLAG_IRQS_OFF		= 0x01,
+	TRACE_FLAG_IRQS_NOSUPPORT	= 0x02,
+	TRACE_FLAG_NEED_RESCHED		= 0x04,
+	TRACE_FLAG_HARDIRQ		= 0x08,
+	TRACE_FLAG_SOFTIRQ		= 0x10,
+};
+
 #endif /* __PERF_TRACE_EVENTS_H */
