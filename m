Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbZGUQUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbZGUQUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbZGUQUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:20:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41694 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079AbZGUQUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:20:39 -0400
Date: Tue, 21 Jul 2009 12:20:22 -0400
From: Jason Baron <jbaron@redhat.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, fweisbec@gmail.com
Message-Id: <426129bf9fcc8ee63bb094cf736e7316a7dcd77a.1248190728.git.jbaron@redhat.com>
In-Reply-To: <cover.1248190728.git.jbaron@redhat.com>
References: <cover.1248190728.git.jbaron@redhat.com>
Subject: [PATCH 1/2] perf_counter: add tracepoint support to perf list, perf stat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to 'perf list' and 'perf stat' for kernel tracepoints. The
implementation creates a 'for_each_subsystem' and 'for_each_event' for
easy iteration over the tracepoints.


Signed-off-by: Jason Baron <jbaron@redhat.com>


---
 tools/perf/util/parse-events.c |  175 +++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/util.h         |    2 +
 2 files changed, 176 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index d18c98e..5a3cd3a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -12,6 +12,8 @@ int					nr_counters;
 
 struct perf_counter_attr		attrs[MAX_COUNTERS];
 
+static char default_debugfs_path[] = "/sys/kernel/debug/tracing/events";
+
 struct event_symbol {
 	u8	type;
 	u64	config;
@@ -110,6 +112,88 @@ static unsigned long hw_cache_stat[C(MAX)] = {
  [C(BPU)]	= (CACHE_READ),
 };
 
+#define for_each_subsystem(sys_dir, sys_dirent, sys_next, file, st)	       \
+	while (!readdir_r(sys_dir, &sys_dirent, &sys_next) && sys_next)	       \
+	if (snprintf(file, MAXPATHLEN, "%s/%s", default_debugfs_path,	       \
+			sys_dirent.d_name) &&				       \
+	   (!stat(file, &st)) && (S_ISDIR(st.st_mode)) &&		       \
+	   (strcmp(sys_dirent.d_name, ".")) &&				       \
+	   (strcmp(sys_dirent.d_name, "..")))
+
+#define for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next, file, st)    \
+	while (!readdir_r(evt_dir, &evt_dirent, &evt_next) && evt_next)        \
+	if (snprintf(file, MAXPATHLEN, "%s/%s/%s", default_debugfs_path,       \
+			sys_dirent.d_name, evt_dirent.d_name) &&	       \
+	   (!stat(file, &st)) && (S_ISDIR(st.st_mode)) &&		       \
+	   (strcmp(evt_dirent.d_name, ".")) &&				       \
+	   (strcmp(evt_dirent.d_name, "..")))
+
+#define MAX_EVENT_LENGTH 30
+
+static int valid_debugfs_mount(void)
+{
+	struct statfs st_fs;
+
+	if (statfs(default_debugfs_path, &st_fs) < 0)
+		return -ENOENT;
+	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
+		return -ENOENT;
+	return 0;
+}
+
+static char *tracepoint_id_to_name(u64 config)
+{
+	static char tracepoint_name[2 * MAX_EVENT_LENGTH];
+	DIR *sys_dir, *evt_dir;
+	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
+	struct stat st;
+	char id_buf[4];
+	int fd;
+	u64 id;
+	char evt_path[MAXPATHLEN];
+
+	if (valid_debugfs_mount())
+		return "unkown";
+
+	sys_dir = opendir(default_debugfs_path);
+	if (!sys_dir)
+		goto cleanup;
+
+	for_each_subsystem(sys_dir, sys_dirent, sys_next, evt_path, st) {
+		evt_dir = opendir(evt_path);
+		if (!evt_dir)
+			goto cleanup;
+		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next,
+								evt_path, st) {
+			snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id",
+				 default_debugfs_path, sys_dirent.d_name,
+				 evt_dirent.d_name);
+			fd = open(evt_path, O_RDONLY);
+			if (fd < 0)
+				continue;
+			if (read(fd, id_buf, sizeof(id_buf)) < 0) {
+				close(fd);
+				continue;
+			}
+			close(fd);
+			id = atoll(id_buf);
+			if (id == config) {
+				closedir(evt_dir);
+				closedir(sys_dir);
+				snprintf(tracepoint_name, 2 * MAX_EVENT_LENGTH,
+					"%s:%s", sys_dirent.d_name,
+					evt_dirent.d_name);
+				return tracepoint_name;
+			}
+		}
+		closedir(evt_dir);
+	}
+
+cleanup:
+	closedir(sys_dir);
+	return "unkown";
+}
+
 static int is_cache_op_valid(u8 cache_type, u8 cache_op)
 {
 	if (hw_cache_stat[cache_type] & COP(cache_op))
@@ -177,6 +261,9 @@ char *event_name(int counter)
 			return sw_event_names[config];
 		return "unknown-software";
 
+	case PERF_TYPE_TRACEPOINT:
+		return tracepoint_id_to_name(config);
+
 	default:
 		break;
 	}
@@ -265,6 +352,53 @@ parse_generic_hw_event(const char **str, struct perf_counter_attr *attr)
 	return 1;
 }
 
+static int parse_tracepoint_event(const char **strp,
+				    struct perf_counter_attr *attr)
+{
+	const char *evt_name;
+	char sys_name[MAX_EVENT_LENGTH];
+	char id_buf[4];
+	int fd;
+	unsigned int sys_length, evt_length;
+	u64 id;
+	char evt_path[MAXPATHLEN];
+
+	if (valid_debugfs_mount())
+		return 0;
+
+	evt_name = strchr(*strp, ':');
+	if (!evt_name)
+		return 0;
+
+	sys_length = evt_name - *strp;
+	if (sys_length >= MAX_EVENT_LENGTH)
+		return 0;
+
+	strncpy(sys_name, *strp, sys_length);
+	sys_name[sys_length] = '\0';
+	evt_name = evt_name + 1;
+	evt_length = strlen(evt_name);
+	if (evt_length >= MAX_EVENT_LENGTH)
+		return 0;
+
+	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", default_debugfs_path,
+				sys_name, evt_name);
+	fd = open(evt_path, O_RDONLY);
+	if (fd < 0)
+		return 0;
+
+	if (read(fd, id_buf, sizeof(id_buf)) < 0) {
+		close(fd);
+		return 0;
+	}
+	close(fd);
+	id = atoll(id_buf);
+	attr->config = id;
+	attr->type = PERF_TYPE_TRACEPOINT;
+	*strp = evt_name + evt_length;
+	return 1;
+}
+
 static int check_events(const char *str, unsigned int i)
 {
 	int n;
@@ -374,7 +508,8 @@ parse_event_modifier(const char **strp, struct perf_counter_attr *attr)
  */
 static int parse_event_symbols(const char **str, struct perf_counter_attr *attr)
 {
-	if (!(parse_raw_event(str, attr) ||
+	if (!(parse_tracepoint_event(str, attr) ||
+	      parse_raw_event(str, attr) ||
 	      parse_numeric_event(str, attr) ||
 	      parse_symbolic_event(str, attr) ||
 	      parse_generic_hw_event(str, attr)))
@@ -423,6 +558,42 @@ static const char * const event_type_descriptors[] = {
 };
 
 /*
+ * Print the events from <debugfs_mount_point>/tracing/events
+ */
+
+static void print_tracepoint_events(void)
+{
+	DIR *sys_dir, *evt_dir;
+	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
+	struct stat st;
+	char evt_path[MAXPATHLEN];
+
+	if (valid_debugfs_mount())
+		return;
+
+	sys_dir = opendir(default_debugfs_path);
+	if (!sys_dir)
+		goto cleanup;
+
+	for_each_subsystem(sys_dir, sys_dirent, sys_next, evt_path, st) {
+		evt_dir = opendir(evt_path);
+		if (!evt_dir)
+			goto cleanup;
+		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next,
+								evt_path, st) {
+			snprintf(evt_path, MAXPATHLEN, "%s:%s",
+				 sys_dirent.d_name, evt_dirent.d_name);
+			fprintf(stderr, "  %-40s [%s]\n", evt_path,
+				event_type_descriptors[PERF_TYPE_TRACEPOINT+1]);
+		}
+		closedir(evt_dir);
+	}
+
+cleanup:
+	closedir(sys_dir);
+}
+
+/*
  * Print the help text for the event symbols:
  */
 void print_events(void)
@@ -472,5 +643,7 @@ void print_events(void)
 		"rNNN");
 	fprintf(stderr, "\n");
 
+	print_tracepoint_events();
+
 	exit(129);
 }
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index b4be607..68fe157 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -50,6 +50,7 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <sys/stat.h>
+#include <sys/statfs.h>
 #include <fcntl.h>
 #include <stddef.h>
 #include <stdlib.h>
@@ -80,6 +81,7 @@
 #include <netdb.h>
 #include <pwd.h>
 #include <inttypes.h>
+#include "../../../include/linux/magic.h"
 
 #ifndef NO_ICONV
 #include <iconv.h>
-- 
1.6.0.6

