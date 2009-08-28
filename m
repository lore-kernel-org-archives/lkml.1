Return-Path: <linux-kernel-owner+w=401wt.eu-S1751493AbZH1CqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbZH1CqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 22:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZH1CqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 22:46:16 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:36288 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZH1CqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 22:46:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IQdo/Vv0XEwiNzOi7NGtkyq/j/5g6ZXxyeA1U001L2KmIaGWKHS3p+zH9YQDSLTvng
         ZVtpWAn9YcMrVXYDDQ4auDR7DrqXWlrmkqA1dXxn0StnZZ6SXIVT9UI/qXWr+9fMHYPX
         POfwSlxrljnrkagpDH04BRzTNKFWrroOzWdMM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/2] perf tools: Import trace saved cmdlines to threads base
Date: Fri, 28 Aug 2009 04:46:06 +0200
Message-Id: <1251427567-10551-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, perf has its own base of threads objects that resolve
a pid to a thread.
This tables is built by the PERF_EVENT_COMM events.

But ftrace events may need more than this table: they sometimes require
to store task comms that are not profiled by perf.

We then import the saved cmdlines file from debugfs to import its
entries into the perf thread base.

Some of the imported code comes from trace-cmd.c written
by Steven Rostedt (and this imported code has been patched into
the current perf imported code from trace-cmd.c :-)

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/builtin-record.c         |   11 ++++++++-
 tools/perf/builtin-trace.c          |   37 +++++++++++++++++++++++++++++++++-
 tools/perf/util/trace-event-info.c  |   14 ++++++++++++
 tools/perf/util/trace-event-parse.c |   38 ++++++++++++++--------------------
 tools/perf/util/trace-event-read.c  |   12 +++++++++++
 tools/perf/util/trace-event.h       |   19 ++++++++++++++--
 6 files changed, 103 insertions(+), 28 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index add514d..9b1e143 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -64,6 +64,8 @@ static int			file_new = 1;
 
 struct perf_header		*header;
 
+static int			tracing_info;
+
 struct mmap_data {
 	int			counter;
 	void			*base;
@@ -549,15 +551,18 @@ static int __cmd_record(int argc, const char **argv)
 
 
 	if (raw_samples) {
-		read_tracing_data(attrs, nr_counters);
+		tracing_info = 1;
 	} else {
 		for (i = 0; i < nr_counters; i++) {
 			if (attrs[i].sample_type & PERF_SAMPLE_RAW) {
-				read_tracing_data(attrs, nr_counters);
+				tracing_info = 1;
 				break;
 			}
 		}
 	}
+	if (tracing_info)
+		read_tracing_data(attrs, nr_counters);
+
 	atexit(atexit_header);
 
 	if (!system_wide) {
@@ -622,6 +627,8 @@ static int __cmd_record(int argc, const char **argv)
 		}
 	}
 
+	if (tracing_info)
+		read_cmdlines();
 	/*
 	 * Approximate RIP event size: 24 bytes.
 	 */
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index dd3c2e7..cb56520 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -120,7 +120,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		 * field, although it should be the same than this perf
 		 * event pid
 		 */
-		print_event(0, raw->data, raw->size, 0, thread->comm);
+		print_event(0, raw->data, raw->size, 0);
 	}
 	total += period;
 
@@ -153,6 +153,39 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
+static char *find_cmdline(int pid)
+{
+	struct thread *thread;
+
+	if (!pid)
+		return (char *)"<idle>";
+
+	thread = threads__findnew(pid, &threads, &last_match);
+	if (thread && thread->comm)
+		return thread->comm;
+
+	return (char *)"<...>";
+}
+
+static void import_trace_cmdlines(void)
+{
+	struct trace_cmdlines cmds;
+	struct thread *thread;
+	int i;
+
+	get_trace_cmdlines(&cmds);
+
+	for (i = 0; i < cmds.nb; i++) {
+		struct cmdline *cmd = &cmds.list[i];
+
+		thread = threads__findnew(cmd->pid, &threads, &last_match);
+		if (!thread || thread__set_comm(thread, cmd->comm)) {
+			dump_printf("problem processing PERF_EVENT_COMM, "
+				    "skipping event.\n");
+		}
+	}
+}
+
 static int __cmd_trace(void)
 {
 	int ret, rc = EXIT_FAILURE;
@@ -164,6 +197,8 @@ static int __cmd_trace(void)
 	char *buf;
 
 	trace_report();
+	import_trace_cmdlines();
+	set_cmdline_finder(find_cmdline);
 
 	input = open(input_name, O_RDONLY);
 	if (input < 0) {
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 8161527..026224d 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -455,6 +455,20 @@ static void read_proc_kallsyms(void)
 
 }
 
+void read_cmdlines(void)
+{
+	char *file;
+	unsigned long long size, check_size;
+
+	file = get_tracing_file("saved_cmdlines");
+	size = get_size(file);
+	write_or_die(&size, 8);
+	check_size = copy_file(file);
+	if (size != check_size)
+		die("error in size of file '%s'", file);
+	put_tracing_file(file);
+}
+
 static void read_ftrace_printk(void)
 {
 	unsigned int size, check_size;
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index a6577cd..a2de650 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -54,28 +54,10 @@ static void init_input_buf(char *buf, unsigned long long size)
 	input_buf_ptr = 0;
 }
 
-struct cmdline {
-	char *comm;
-	int pid;
-};
-
 static struct cmdline *cmdlines;
 static int cmdline_count;
 
-static int cmdline_cmp(const void *a, const void *b)
-{
-	const struct cmdline *ca = a;
-	const struct cmdline *cb = b;
-
-	if (ca->pid < cb->pid)
-		return -1;
-	if (ca->pid > cb->pid)
-		return 1;
-
-	return 0;
-}
-
-void parse_cmdlines(char *file, int size __unused)
+void parse_cmdlines(char *file)
 {
 	struct cmdline_list {
 		struct cmdline_list	*next;
@@ -108,8 +90,19 @@ void parse_cmdlines(char *file, int size __unused)
 		list = list->next;
 		free(item);
 	}
+}
 
-	qsort(cmdlines, cmdline_count, sizeof(*cmdlines), cmdline_cmp);
+void get_trace_cmdlines(struct trace_cmdlines *cmds)
+{
+	cmds->list = cmdlines;
+	cmds->nb = cmdline_count;
+}
+
+static char *(*find_cmdline)(int pid);
+
+void set_cmdline_finder(char *(*find)(int))
+{
+	find_cmdline = find;
 }
 
 static struct func_map {
@@ -2670,12 +2663,12 @@ pretty_print_func_graph(void *data, int size, struct event *event,
 	printf("\n");
 }
 
-void print_event(int cpu, void *data, int size, unsigned long long nsecs,
-		  char *comm)
+void print_event(int cpu, void *data, int size, unsigned long long nsecs)
 {
 	struct event *event;
 	unsigned long secs;
 	unsigned long usecs;
+	char *comm;
 	int type;
 	int pid;
 
@@ -2690,6 +2683,7 @@ void print_event(int cpu, void *data, int size, unsigned long long nsecs,
 		die("ug! no event found for type %d", type);
 
 	pid = parse_common_pid(data);
+	comm = find_cmdline(pid);
 
 	if (event->flags & (EVENT_FL_ISFUNCENT | EVENT_FL_ISFUNCRET))
 		return pretty_print_func_graph(data, size, event, cpu,
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index b12e490..d2e190d 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -455,6 +455,17 @@ struct record *trace_read_data(int cpu)
 	return data;
 }
 
+static void read_data_info(void)
+{
+	unsigned long long size;
+	char *cmdlines;
+
+	size = read8();
+	cmdlines = malloc_or_die(size);
+	read_or_die(cmdlines, size);
+	parse_cmdlines(cmdlines);
+}
+
 void trace_report (void)
 {
 	const char *input_file = "trace.info";
@@ -495,6 +506,7 @@ void trace_report (void)
 	read_event_files();
 	read_proc_kallsyms();
 	read_ftrace_printk();
+	read_data_info();
 
 	if (show_funcs) {
 		print_funcs();
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 051fcf3..de61496 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -148,6 +148,19 @@ struct record {
 	void *data;
 };
 
+struct cmdline {
+	char *comm;
+	int pid;
+};
+
+struct trace_cmdlines {
+	struct cmdline *list;
+	int		nb;
+};
+
+void get_trace_cmdlines(struct trace_cmdlines *cmds);
+void set_cmdline_finder(char *(*find_cmdline)(int));
+
 struct record *trace_peek_data(int cpu);
 struct record *trace_read_data(int cpu);
 
@@ -157,7 +170,7 @@ void trace_report(void);
 
 void *malloc_or_die(unsigned int size);
 
-void parse_cmdlines(char *file, int size);
+void parse_cmdlines(char *file);
 void parse_proc_kallsyms(char *file, unsigned int size);
 void parse_ftrace_printk(char *file, unsigned int size);
 
@@ -166,8 +179,7 @@ void print_printk(void);
 
 int parse_ftrace_file(char *buf, unsigned long size);
 int parse_event_file(char *buf, unsigned long size, char *system);
-void print_event(int cpu, void *data, int size, unsigned long long nsecs,
-		  char *comm);
+void print_event(int cpu, void *data, int size, unsigned long long nsecs);
 
 extern int file_bigendian;
 extern int host_bigendian;
@@ -235,5 +247,6 @@ extern int header_page_data_size;
 int parse_header_page(char *buf, unsigned long size);
 
 void read_tracing_data(struct perf_counter_attr *pattrs, int nb_counters);
+void read_cmdlines(void);
 
 #endif /* _TRACE_EVENTS_H */
-- 
1.6.2.3

