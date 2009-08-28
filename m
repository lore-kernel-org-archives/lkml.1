Return-Path: <linux-kernel-owner+w=401wt.eu-S1751004AbZH1BKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751004AbZH1BKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 21:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbZH1BKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 21:10:03 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:55721 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbZH1BKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 21:10:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xYUWMolPjzgzCSQ+VK14uGC49mBLQy8nBxauquCf6ncgKEnNwBRmR42VzLLmeAI+77
         7z9u1DP/VwuW7Xl0P/OK2r0jHZ6u8his4jyKJTRFX7Y27ytsUidg6gubSiZmf/tgLscU
         LpsBlBOeX+HNxYj4liRIj9e3IyDHcXyVvyEds=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] perf tools: Only save the event formats we need
Date: Fri, 28 Aug 2009 03:09:58 +0200
Message-Id: <1251421798-9101-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While opening a trace event counter, every events are saved in the
trace.info file. But we only want to save the specifications of the
events we are using.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/builtin-record.c         |    4 +-
 tools/perf/util/parse-events.c      |   47 +++++++++++++++++++----
 tools/perf/util/parse-events.h      |   13 ++++++-
 tools/perf/util/trace-event-info.c  |   72 +++++++++++++++++++++++++++++------
 tools/perf/util/trace-event-parse.c |    1 +
 tools/perf/util/trace-event-read.c  |    1 +
 tools/perf/util/trace-event.h       |    9 ++--
 7 files changed, 120 insertions(+), 27 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index acbe594..add514d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -549,11 +549,11 @@ static int __cmd_record(int argc, const char **argv)
 
 
 	if (raw_samples) {
-		read_tracing_data();
+		read_tracing_data(attrs, nr_counters);
 	} else {
 		for (i = 0; i < nr_counters; i++) {
 			if (attrs[i].sample_type & PERF_SAMPLE_RAW) {
-				read_tracing_data();
+				read_tracing_data(attrs, nr_counters);
 				break;
 			}
 		}
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 967d17f..8c20239 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -158,9 +158,9 @@ int valid_debugfs_mount(const char *debugfs)
 	return 0;
 }
 
-static const char *tracepoint_id_to_name(u64 config)
+struct tracepoint_path *tracepoint_id_to_path(u64 config)
 {
-	static char tracepoint_name[2 * MAX_EVENT_LENGTH];
+	struct tracepoint_path *path = NULL;
 	DIR *sys_dir, *evt_dir;
 	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
 	struct stat st;
@@ -170,7 +170,7 @@ static const char *tracepoint_id_to_name(u64 config)
 	char evt_path[MAXPATHLEN];
 
 	if (valid_debugfs_mount(debugfs_path))
-		return "unkown";
+		return NULL;
 
 	sys_dir = opendir(debugfs_path);
 	if (!sys_dir)
@@ -197,10 +197,23 @@ static const char *tracepoint_id_to_name(u64 config)
 			if (id == config) {
 				closedir(evt_dir);
 				closedir(sys_dir);
-				snprintf(tracepoint_name, 2 * MAX_EVENT_LENGTH,
-					"%s:%s", sys_dirent.d_name,
-					evt_dirent.d_name);
-				return tracepoint_name;
+				path = calloc(1, sizeof(path));
+				path->system = malloc(MAX_EVENT_LENGTH);
+				if (!path->system) {
+					free(path);
+					return NULL;
+				}
+				path->name = malloc(MAX_EVENT_LENGTH);
+				if (!path->name) {
+					free(path->system);
+					free(path);
+					return NULL;
+				}
+				strncpy(path->system, sys_dirent.d_name,
+					MAX_EVENT_LENGTH);
+				strncpy(path->name, evt_dirent.d_name,
+					MAX_EVENT_LENGTH);
+				return path;
 			}
 		}
 		closedir(evt_dir);
@@ -208,7 +221,25 @@ static const char *tracepoint_id_to_name(u64 config)
 
 cleanup:
 	closedir(sys_dir);
-	return "unkown";
+	return NULL;
+}
+
+#define TP_PATH_LEN (MAX_EVENT_LENGTH * 2 + 1)
+static const char *tracepoint_id_to_name(u64 config)
+{
+	static char buf[TP_PATH_LEN];
+	struct tracepoint_path *path;
+
+	path = tracepoint_id_to_path(config);
+	if (path) {
+		snprintf(buf, TP_PATH_LEN, "%s:%s", path->system, path->name);
+		free(path->name);
+		free(path->system);
+		free(path);
+	} else
+		snprintf(buf, TP_PATH_LEN, "%s:%s", "unknown", "unknown");
+
+	return buf;
 }
 
 static int is_cache_op_valid(u8 cache_type, u8 cache_op)
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 9b1aeea..60704c1 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -1,10 +1,19 @@
-
+#ifndef _PARSE_EVENTS_H
+#define _PARSE_EVENTS_H
 /*
  * Parse symbolic events/counts passed in as options:
  */
 
 struct option;
 
+struct tracepoint_path {
+	char *system;
+	char *name;
+	struct tracepoint_path *next;
+};
+
+extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
+
 extern int			nr_counters;
 
 extern struct perf_counter_attr attrs[MAX_COUNTERS];
@@ -21,3 +30,5 @@ extern void print_events(void);
 extern char debugfs_path[];
 extern int valid_debugfs_mount(const char *debugfs);
 
+
+#endif /* _PARSE_EVENTS_H */
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 78adff1..8161527 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -32,7 +32,9 @@
 #include <unistd.h>
 #include <ctype.h>
 #include <errno.h>
+#include <stdbool.h>
 
+#include "../perf.h"
 #include "trace-event.h"
 
 
@@ -289,7 +291,18 @@ static void read_header_files(void)
 	put_tracing_file(path);
 }
 
-static void copy_event_system(const char *sys)
+static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
+{
+	while (tps) {
+		if (!strcmp(sys, tps->name))
+			return true;
+		tps = tps->next;
+	}
+
+	return false;
+}
+
+static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 {
 	unsigned long long size, check_size;
 	struct dirent *dent;
@@ -305,7 +318,8 @@ static void copy_event_system(const char *sys)
 
 	while ((dent = readdir(dir))) {
 		if (strcmp(dent->d_name, ".") == 0 ||
-		    strcmp(dent->d_name, "..") == 0)
+		    strcmp(dent->d_name, "..") == 0 ||
+		    !name_in_tp_list(dent->d_name, tps))
 			continue;
 		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
 		sprintf(format, "%s/%s/format", sys, dent->d_name);
@@ -321,7 +335,8 @@ static void copy_event_system(const char *sys)
 	rewinddir(dir);
 	while ((dent = readdir(dir))) {
 		if (strcmp(dent->d_name, ".") == 0 ||
-		    strcmp(dent->d_name, "..") == 0)
+		    strcmp(dent->d_name, "..") == 0 ||
+		    !name_in_tp_list(dent->d_name, tps))
 			continue;
 		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
 		sprintf(format, "%s/%s/format", sys, dent->d_name);
@@ -340,18 +355,29 @@ static void copy_event_system(const char *sys)
 	}
 }
 
-static void read_ftrace_files(void)
+static void read_ftrace_files(struct tracepoint_path *tps)
 {
 	char *path;
 
 	path = get_tracing_file("events/ftrace");
 
-	copy_event_system(path);
+	copy_event_system(path, tps);
 
 	put_tracing_file(path);
 }
 
-static void read_event_files(void)
+static bool system_in_tp_list(char *sys, struct tracepoint_path *tps)
+{
+	while (tps) {
+		if (!strcmp(sys, tps->system))
+			return true;
+		tps = tps->next;
+	}
+
+	return false;
+}
+
+static void read_event_files(struct tracepoint_path *tps)
 {
 	struct dirent *dent;
 	struct stat st;
@@ -370,7 +396,8 @@ static void read_event_files(void)
 	while ((dent = readdir(dir))) {
 		if (strcmp(dent->d_name, ".") == 0 ||
 		    strcmp(dent->d_name, "..") == 0 ||
-		    strcmp(dent->d_name, "ftrace") == 0)
+		    strcmp(dent->d_name, "ftrace") == 0 ||
+		    !system_in_tp_list(dent->d_name, tps))
 			continue;
 		sys = malloc_or_die(strlen(path) + strlen(dent->d_name) + 2);
 		sprintf(sys, "%s/%s", path, dent->d_name);
@@ -388,7 +415,8 @@ static void read_event_files(void)
 	while ((dent = readdir(dir))) {
 		if (strcmp(dent->d_name, ".") == 0 ||
 		    strcmp(dent->d_name, "..") == 0 ||
-		    strcmp(dent->d_name, "ftrace") == 0)
+		    strcmp(dent->d_name, "ftrace") == 0 ||
+		    !system_in_tp_list(dent->d_name, tps))
 			continue;
 		sys = malloc_or_die(strlen(path) + strlen(dent->d_name) + 2);
 		sprintf(sys, "%s/%s", path, dent->d_name);
@@ -396,7 +424,7 @@ static void read_event_files(void)
 		if (ret >= 0) {
 			if (S_ISDIR(st.st_mode)) {
 				write_or_die(dent->d_name, strlen(dent->d_name) + 1);
-				copy_event_system(sys);
+				copy_event_system(sys, tps);
 			}
 		}
 		free(sys);
@@ -450,9 +478,27 @@ static void read_ftrace_printk(void)
 
 }
 
-void read_tracing_data(void)
+static struct tracepoint_path *
+get_tracepoints_path(struct perf_counter_attr *pattrs, int nb_counters)
+{
+	struct tracepoint_path path, *ppath = &path;
+	int i;
+
+	for (i = 0; i < nb_counters; i++) {
+		if (pattrs[i].type != PERF_TYPE_TRACEPOINT)
+			continue;
+		ppath->next = tracepoint_id_to_path(pattrs[i].config);
+		if (!ppath->next)
+			die("%s\n", "No memory to alloc tracepoints list");
+		ppath = ppath->next;
+	}
+
+	return path.next;
+}
+void read_tracing_data(struct perf_counter_attr *pattrs, int nb_counters)
 {
 	char buf[BUFSIZ];
+	struct tracepoint_path *tps;
 
 	output_fd = open(output_file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
 	if (output_fd < 0)
@@ -483,9 +529,11 @@ void read_tracing_data(void)
 	page_size = getpagesize();
 	write_or_die(&page_size, 4);
 
+	tps = get_tracepoints_path(pattrs, nb_counters);
+
 	read_header_files();
-	read_ftrace_files();
-	read_event_files();
+	read_ftrace_files(tps);
+	read_event_files(tps);
 	read_proc_kallsyms();
 	read_ftrace_printk();
 }
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index b53b27f..a6577cd 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -29,6 +29,7 @@
 #include <errno.h>
 
 #undef _GNU_SOURCE
+#include "../perf.h"
 #include "util.h"
 #include "trace-event.h"
 
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 1dac301..b12e490 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -36,6 +36,7 @@
 #include <ctype.h>
 #include <errno.h>
 
+#include "../perf.h"
 #include "util.h"
 #include "trace-event.h"
 
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 3ddb894..051fcf3 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -1,6 +1,7 @@
-#ifndef _PARSE_EVENTS_H
-#define _PARSE_EVENTS_H
+#ifndef _TRACE_EVENTS_H
+#define _TRACE_EVENTS_H
 
+#include "parse-events.h"
 
 #define __unused __attribute__((unused))
 
@@ -233,6 +234,6 @@ extern int header_page_data_size;
 
 int parse_header_page(char *buf, unsigned long size);
 
-void read_tracing_data(void);
+void read_tracing_data(struct perf_counter_attr *pattrs, int nb_counters);
 
-#endif /* _PARSE_EVENTS_H */
+#endif /* _TRACE_EVENTS_H */
-- 
1.6.2.3

