Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab0BWP4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 10:56:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab0BWP4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 10:56:44 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH][trace-cmd] minor fixies
Date: Tue, 23 Feb 2010 16:56:39 +0100
Message-Id: <1266940599-11918-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I was looking through the sources and spot few bugs.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 parse-events.c |   11 ++++-------
 trace-cmd.c    |   35 ++++++++++++++++++++---------------
 trace-filter.c |   14 ++++++++------
 trace-input.c  |    2 +-
 trace-output.c |    3 ---
 trace-record.c |    3 ---
 trace-util.c   |    3 ---
 7 files changed, 33 insertions(+), 38 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index b483e85..43adc76 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -68,8 +68,6 @@ struct print_arg *alloc_arg(void)
 	struct print_arg *arg;
 
 	arg = malloc_or_die(sizeof(*arg));
-	if (!arg)
-		return NULL;
 	memset(arg, 0, sizeof(*arg));
 
 	return arg;
@@ -570,12 +568,13 @@ static void add_event(struct pevent *pevent, struct event_format *event)
 
 	if (!pevent->events)
 		pevent->events = malloc_or_die(sizeof(event));
-	else
+	else {
 		pevent->events =
 			realloc(pevent->events, sizeof(event) *
 				(pevent->nr_events + 1));
-	if (!pevent->events)
-		die("Can not allocate events");
+		if (!pevent->events)
+			die("Can not allocate events");
+	}
 
 	for (i = 0; i < pevent->nr_events; i++) {
 		if (pevent->events[i]->id > event->id)
@@ -3855,8 +3854,6 @@ int pevent_parse_event(struct pevent *pevent,
 	init_input_buf(buf, size);
 
 	event = alloc_event();
-	if (!event)
-		return -ENOMEM;
 
 	event->name = event_read_name();
 	if (!event->name)
diff --git a/trace-cmd.c b/trace-cmd.c
index e89362d..01cf563 100644
--- a/trace-cmd.c
+++ b/trace-cmd.c
@@ -226,7 +226,7 @@ static int set_ftrace(int set)
 	int fd;
 	char *val = set ? "1" : "0";
 
-	/* if ftace_enable does not exist, simply ignore it */
+	/* if ftrace_enable does not exist, simply ignore it */
 	fd = stat(path, &buf);
 	if (fd < 0)
 		return -ENODEV;
@@ -356,8 +356,6 @@ static char *get_tracing_file(const char *name)
 	}
 
 	file = malloc_or_die(strlen(tracing) + strlen(name) + 2);
-	if (!file)
-		return NULL;
 
 	sprintf(file, "%s/%s", tracing, name);
 	return file;
@@ -446,6 +444,22 @@ static void show_options(void)
 	fclose(fp);
 }
 
+static void show_stats(void)
+{
+	int cpu;
+	struct trace_seq s;
+
+	printf("Buffer statistics:\n\n");
+	for (cpu = 0; cpu < cpu_count; cpu++) {
+		trace_seq_init(&s);
+		trace_seq_printf(&s, "CPU: %d\n", cpu);
+		tracecmd_stat_cpu(&s, cpu);
+		trace_seq_do_printf(&s);
+		printf("\n");
+	}
+
+}
+
 static void set_option(const char *option)
 {
 	FILE *fp;
@@ -1096,9 +1110,10 @@ void usage(char **argv)
 	       "          Disables the tracer (may reset trace file)\n"
 	       "          Used in conjunction with start\n"
 	       "\n"
-	       " %s report [-i file] [--cpu cpu] [-e][-f][-l][-P][-E][-F filter][-v]\n"
+	       " %s report [-i file] [--cpu cpu] [-e][-p][-f][-l][-P][-E][-F filter][-v]\n"
 	       "          -i input file [default trace.dat]\n"
 	       "          -e show file endianess\n"
+	       "          -p show page size\n"
 	       "          -f show function list\n"
 	       "          -P show printk list\n"
 	       "          -E show event files stored\n"
@@ -1137,7 +1152,6 @@ int main (int argc, char **argv)
 	const char *option;
 	struct event_list *event;
 	struct event_list *last_event;
-	struct trace_seq s;
 	int disable = 0;
 	int plug = 0;
 	int events = 0;
@@ -1147,7 +1161,6 @@ int main (int argc, char **argv)
 	int run_command = 0;
 	int neg_event = 0;
 	int fset;
-	int cpu;
 
 	int c;
 
@@ -1385,6 +1398,7 @@ int main (int argc, char **argv)
 				sleep(10);
 		}
 
+		show_stats();
 		disable_tracing();
 	}
 
@@ -1393,15 +1407,6 @@ int main (int argc, char **argv)
 	record_data();
 	delete_thread_data();
 
-	printf("Buffer statistics:\n\n");
-	for (cpu = 0; cpu < cpu_count; cpu++) {
-		trace_seq_init(&s);
-		trace_seq_printf(&s, "CPU: %d\n", cpu);
-		tracecmd_stat_cpu(&s, cpu);
-		trace_seq_do_printf(&s);
-		printf("\n");
-	}
-
 	exit(0);
 
 	return 0;
diff --git a/trace-filter.c b/trace-filter.c
index faf1e89..c214d25 100644
--- a/trace-filter.c
+++ b/trace-filter.c
@@ -2015,10 +2015,11 @@ static void add_system_str(gchar ***systems, char *system, int count)
 
 	if (!count)
 		*systems = malloc_or_die(sizeof(char *) * 2);
-	else
+	else {
 		*systems = realloc(*systems, sizeof(char *) * (count + 2));
-	if (!*systems)
-		die("Can't allocate systems");
+		if (!*systems)
+			die("Can't allocate systems");
+	}
 
 	(*systems)[count] = system;
 	(*systems)[count+1] = NULL;
@@ -2031,10 +2032,11 @@ static void add_event_int(gint **events, gint event, int count)
 
 	if (!count)
 		*events = malloc_or_die(sizeof(gint) * 2);
-	else
+	else {
 		*events = realloc(*events, sizeof(gint) * (count + 2));
-	if (!*events)
-		die("Can't allocate events");
+		if (!*events)
+			die("Can't allocate events");
+	}
 
 	(*events)[count] = event;
 	(*events)[count+1] = -1;
diff --git a/trace-input.c b/trace-input.c
index ecf86e4..cb8a64d 100644
--- a/trace-input.c
+++ b/trace-input.c
@@ -92,7 +92,7 @@ static int do_read(struct tracecmd_input *handle, void *data, int size)
 	int r;
 
 	do {
-		r = read(handle->fd, data, size - tot);
+		r = read(handle->fd, data + tot, size - tot);
 		tot += r;
 
 		if (!r)
diff --git a/trace-output.c b/trace-output.c
index a59099d..4386b5b 100644
--- a/trace-output.c
+++ b/trace-output.c
@@ -175,9 +175,6 @@ static char *get_tracing_file(struct tracecmd_output *handle, const char *name)
 		return NULL;
 
 	file = malloc_or_die(strlen(tracing) + strlen(name) + 2);
-	if (!file)
-		return NULL;
-
 	sprintf(file, "%s/%s", tracing, name);
 	return file;
 }
diff --git a/trace-record.c b/trace-record.c
index 8317320..cbcfff9 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -64,9 +64,6 @@ struct tracecmd_recorder *tracecmd_create_recorder(const char *file, int cpu)
 	int ret;
 
 	recorder = malloc_or_die(sizeof(*recorder));
-	if (!recorder)
-		return NULL;
-
 	recorder->cpu = cpu;
 
 	/* Init to know what to free and release */
diff --git a/trace-util.c b/trace-util.c
index 6854977..435c05d 100644
--- a/trace-util.c
+++ b/trace-util.c
@@ -270,9 +270,6 @@ char *tracecmd_find_tracing_dir(void)
 	}
 
 	tracing_dir = malloc_or_die(strlen(debugfs) + 9);
-	if (!tracing_dir)
-		return NULL;
-
 	sprintf(tracing_dir, "%s/tracing", debugfs);
 
 	return tracing_dir;
