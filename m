Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbZGFVM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbZGFVM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbZGFVMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:12:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42507 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbZGFVML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:12:11 -0400
Date: Mon, 6 Jul 2009 17:12:02 -0400
From: Jason Baron <jbaron@redhat.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, fweisbec@gmail.com
Message-Id: <0d7326e18b9860fbf8fb2739f90a23eb9262e24b.1246912068.git.jbaron@redhat.com>
In-Reply-To: <cover.1246912068.git.jbaron@redhat.com>
References: <cover.1246912068.git.jbaron@redhat.com>
Subject: [PATCH 2/2] perf_counter: add support to the 'perf' tool for tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to 'perf list' and 'perf stat' for kernel tracepoints. The
implementation creates a 'for_each_subsystem' and 'for_each_event' for
easy iteration over the tracepoints. The debugfs filesystem must be mounted
at '/sys/kernel/debug'. We can add an optional search path in the future.


Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 tools/perf/util/parse-events.c |  195 +++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/util.h         |    2 +
 2 files changed, 196 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5184959..d454eac 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -12,6 +12,8 @@ int					nr_counters;
 
 struct perf_counter_attr		attrs[MAX_COUNTERS];
 
+static char default_debugfs_path[] = "/sys/kernel/debug/tracing/events";
+
 struct event_symbol {
 	u8	type;
 	u64	config;
@@ -110,6 +112,86 @@ static unsigned long hw_cache_stat[C(MAX)] = {
  [C(BPU)]	= (CACHE_READ),
 };
 
+#define for_each_subsystem(sys_dir, sys_dirent, sys_next, file, st)	       \
+	while (!readdir_r(sys_dir, &sys_dirent, &sys_next) && sys_next)	       \
+	if (sprintf(file, "%s/%s", default_debugfs_path, sys_dirent.d_name) && \
+	   (stat(file, &st) == 0) && (S_ISDIR(st.st_mode)) &&		       \
+	   (strcmp(sys_dirent.d_name, ".") != 0) &&			       \
+	   (strcmp(sys_dirent.d_name, "..") != 0))
+
+#define for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next, file, st)    \
+	while (!readdir_r(evt_dir, &evt_dirent, &evt_next) && evt_next)        \
+	if (sprintf(file, "%s/%s/%s", default_debugfs_path, sys_dirent.d_name, \
+			evt_dirent.d_name) && 				       \
+	   (stat(file, &st) == 0) && (S_ISDIR(st.st_mode)) &&		       \
+	   (strcmp(evt_dirent.d_name, ".") != 0) && 			       \
+	   (strcmp(evt_dirent.d_name, "..") != 0))
+
+#define MAX_PATH_LENGTH (strlen(default_debugfs_path) + 3 + \
+			(3 * (strlen(sys_dirent.d_name))) + 1)
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
+	long long id;
+	char evt_path[MAX_PATH_LENGTH];
+
+	if (valid_debugfs_mount())
+		return "unkown";
+
+	sys_dir = opendir(default_debugfs_path);
+	if (!sys_dir)
+		goto cleanup;
+	for_each_subsystem(sys_dir, sys_dirent, sys_next, evt_path, st) {
+		evt_dir = opendir(evt_path);
+		if (!evt_dir)
+			goto cleanup;
+		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next,
+								evt_path, st) {
+			sprintf(evt_path, "%s/%s/%s/id", default_debugfs_path,
+				sys_dirent.d_name, evt_dirent.d_name);
+			fd = open(evt_path, O_RDONLY);
+			if (fd < 0)
+				continue;
+			if (read(fd, id_buf, sizeof(id_buf)) < 0) {
+				close(fd);
+				continue;
+			}
+			close(fd);
+			id = atoll(id_buf);
+			if ((u64)id == config) {
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
+cleanup:
+	closedir(sys_dir);
+	return "unkown";
+}
+
 static int is_cache_op_valid(u8 cache_type, u8 cache_op)
 {
 	if (hw_cache_stat[cache_type] & COP(cache_op))
@@ -177,6 +259,9 @@ char *event_name(int counter)
 			return sw_event_names[config];
 		return "unknown-software";
 
+	case PERF_TYPE_TRACEPOINT:
+		return tracepoint_id_to_name(config);
+
 	default:
 		break;
 	}
@@ -265,6 +350,78 @@ parse_generic_hw_event(const char **str, struct perf_counter_attr *attr)
 	return 1;
 }
 
+static int parse_tracepoint_event(const char **strp,
+				    struct perf_counter_attr *attr)
+{
+	const char *evt_name;
+	char sys_name[MAX_EVENT_LENGTH];
+	DIR *sys_dir, *evt_dir;
+	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
+	struct stat st;
+	char id_buf[4];
+	int fd;
+	unsigned int sys_length, evt_length;
+	u64 id;
+	char evt_path[MAX_PATH_LENGTH];
+
+	if (valid_debugfs_mount())
+		return 0;
+
+	evt_name = strchr(*strp, ':');
+	if (evt_name) {
+		sys_length = evt_name - *strp;
+		if (sys_length >= MAX_EVENT_LENGTH)
+			return 0;
+		strncpy(sys_name, *strp, sys_length);
+		sys_name[sys_length] = '\0';
+		evt_name = evt_name + 1;
+		evt_length = strlen(evt_name);
+		if (evt_length >= MAX_EVENT_LENGTH)
+			return 0;
+	} else
+		return 0;
+
+	sys_dir = opendir(default_debugfs_path);
+	if (!sys_dir)
+		goto cleanup;
+	for_each_subsystem(sys_dir, sys_dirent, sys_next, evt_path, st) {
+		if (strcmp(sys_dirent.d_name, sys_name) == 0) {
+			evt_dir = opendir(evt_path);
+			if (!evt_dir)
+				goto cleanup;
+			for_each_event(sys_dirent, evt_dir, evt_dirent,
+						       evt_next, evt_path, st) {
+				if (strcmp(evt_dirent.d_name, evt_name) == 0) {
+					sprintf(evt_path, "%s/%s/%s/id",
+						default_debugfs_path,
+						sys_dirent.d_name,
+						evt_dirent.d_name);
+					fd = open(evt_path, O_RDONLY);
+					if (fd < 0)
+						continue;
+					if (read(fd, id_buf,
+						 sizeof(id_buf)) < 0) {
+						close(fd);
+						continue;
+					}
+					close(fd);
+					id = atoll(id_buf);
+					attr->config = id;
+					attr->type = PERF_TYPE_TRACEPOINT;
+					closedir(evt_dir);
+					closedir(sys_dir);
+					*strp = evt_name + evt_length;
+					return 1;
+				}
+			}
+			closedir(evt_dir);
+		}
+	}
+cleanup:
+	closedir(sys_dir);
+	return 0;
+}
+
 static int check_events(const char *str, unsigned int i)
 {
 	int n;
@@ -374,7 +531,8 @@ parse_event_modifier(const char **strp, struct perf_counter_attr *attr)
  */
 static int parse_event_symbols(const char **str, struct perf_counter_attr *attr)
 {
-	if (!(parse_raw_event(str, attr) ||
+	if (!(parse_tracepoint_event(str, attr) ||
+	      parse_raw_event(str, attr) ||
 	      parse_numeric_event(str, attr) ||
 	      parse_symbolic_event(str, attr) ||
 	      parse_generic_hw_event(str, attr)))
@@ -423,6 +581,39 @@ static const char * const event_type_descriptors[] = {
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
+	char evt_path[MAX_PATH_LENGTH];
+
+	if (valid_debugfs_mount())
+		return;
+
+	sys_dir = opendir(default_debugfs_path);
+	if (!sys_dir)
+		goto cleanup;
+	for_each_subsystem(sys_dir, sys_dirent, sys_next, evt_path, st) {
+		evt_dir = opendir(evt_path);
+		if (!evt_dir)
+			goto cleanup;
+		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next,
+								evt_path, st) {
+			fprintf(stderr, "  %s:%-40s [%s]\n", sys_dirent.d_name,
+				evt_dirent.d_name,
+				event_type_descriptors[PERF_TYPE_TRACEPOINT+1]);
+		}
+		closedir(evt_dir);
+	}
+cleanup:
+	closedir(sys_dir);
+}
+
+/*
  * Print the help text for the event symbols:
  */
 void print_events(void)
@@ -472,5 +663,7 @@ void print_events(void)
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

