Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbZGUQUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbZGUQUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbZGUQUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:20:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41701 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637AbZGUQUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:20:44 -0400
Date: Tue, 21 Jul 2009 12:20:25 -0400
From: Jason Baron <jbaron@redhat.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, fweisbec@gmail.com
Message-Id: <42fb2af3afccef87d78ca6dd86169ad180b63271.1248190728.git.jbaron@redhat.com>
In-Reply-To: <cover.1248190728.git.jbaron@redhat.com>
References: <cover.1248190728.git.jbaron@redhat.com>
Subject: [PATCH 2/2] perf_counter: detect debugfs location
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Search for the debugfs filesystem in /proc/mounts, but also allows the user to
specify '--debugfs-dir=blah' or set the environment variable: 'PERF_DIR_DEBUGFS'

Signed-off-by: Jason Baron <jbaron@redhat.com>


---
 tools/perf/perf.c              |   58 +++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/cache.h        |    1 +
 tools/perf/util/parse-events.c |   25 +++++++++--------
 tools/perf/util/parse-events.h |    3 ++
 tools/perf/util/string.h       |    3 ++
 5 files changed, 77 insertions(+), 13 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index c565678..67e3da9 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -12,6 +12,8 @@
 #include "util/cache.h"
 #include "util/quote.h"
 #include "util/run-command.h"
+#include "util/parse-events.h"
+#include "util/string.h"
 
 const char perf_usage_string[] =
 	"perf [--version] [--help] COMMAND [ARGS]";
@@ -25,6 +27,8 @@ struct pager_config {
 	int val;
 };
 
+static char debugfs_mntpt[MAXPATHLEN];
+
 static int pager_command_config(const char *var, const char *value, void *data)
 {
 	struct pager_config *c = data;
@@ -56,6 +60,15 @@ static void commit_pager_choice(void) {
 	}
 }
 
+static void set_debugfs_path(void)
+{
+	char *path;
+
+	path = getenv(PERF_DEBUGFS_ENVIRONMENT);
+	snprintf(debugfs_path, MAXPATHLEN, "%s/%s", path ?: debugfs_mntpt,
+		 "tracing/events");
+}
+
 static int handle_options(const char*** argv, int* argc, int* envchanged)
 {
 	int handled = 0;
@@ -122,6 +135,22 @@ static int handle_options(const char*** argv, int* argc, int* envchanged)
 			setenv(PERF_WORK_TREE_ENVIRONMENT, cmd + 12, 1);
 			if (envchanged)
 				*envchanged = 1;
+		} else if (!strcmp(cmd, "--debugfs-dir")) {
+			if (*argc < 2) {
+				fprintf(stderr, "No directory given for --debugfs-dir.\n");
+				usage(perf_usage_string);
+			}
+			strncpy(debugfs_mntpt, (*argv)[1], MAXPATHLEN);
+			debugfs_mntpt[MAXPATHLEN - 1] = '\0';
+			if (envchanged)
+				*envchanged = 1;
+			(*argv)++;
+			(*argc)--;
+		} else if (!prefixcmp(cmd, "--debugfs-dir=")) {
+			strncpy(debugfs_mntpt, cmd + 14, MAXPATHLEN);
+			debugfs_mntpt[MAXPATHLEN - 1] = '\0';
+			if (envchanged)
+				*envchanged = 1;
 		} else {
 			fprintf(stderr, "Unknown option: %s\n", cmd);
 			usage(perf_usage_string);
@@ -228,6 +257,7 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 	if (use_pager == -1 && p->option & USE_PAGER)
 		use_pager = 1;
 	commit_pager_choice();
+	set_debugfs_path();
 
 	status = p->fn(argc, argv, prefix);
 	if (status)
@@ -346,6 +376,30 @@ static int run_argv(int *argcp, const char ***argv)
 	return done_alias;
 }
 
+/* mini /proc/mounts parser: searching for "^blah /mount/point debugfs" */
+static void get_debugfs_mntpt(void)
+{
+	FILE *file;
+	char fs_type[100];
+	char debugfs[MAXPATHLEN];
+
+	file = fopen("/proc/mounts", "r");
+	if (file == NULL)
+		return;
+
+	while (fscanf(file, "%*s %"
+		      STR(MAXPATHLEN)
+		      "s %99s %*s %*d %*d\n",
+		      debugfs, fs_type) == 2) {
+		if (strcmp(fs_type, "debugfs") == 0)
+			break;
+	}
+	fclose(file);
+	if (strcmp(fs_type, "debugfs") == 0) {
+		strncpy(debugfs_mntpt, debugfs, MAXPATHLEN);
+		debugfs_mntpt[MAXPATHLEN - 1] = '\0';
+	}
+}
 
 int main(int argc, const char **argv)
 {
@@ -354,7 +408,8 @@ int main(int argc, const char **argv)
 	cmd = perf_extract_argv0_path(argv[0]);
 	if (!cmd)
 		cmd = "perf-help";
-
+	/* get debugfs mount point from /proc/mounts */
+	get_debugfs_mntpt();
 	/*
 	 * "perf-xxxx" is the same as "perf xxxx", but we obviously:
 	 *
@@ -377,6 +432,7 @@ int main(int argc, const char **argv)
 	argc--;
 	handle_options(&argv, &argc, NULL);
 	commit_pager_choice();
+	set_debugfs_path();
 	if (argc > 0) {
 		if (!prefixcmp(argv[0], "--"))
 			argv[0] += 2;
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 161d5f4..4ba4b3e 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -18,6 +18,7 @@
 #define PERFATTRIBUTES_FILE ".perfattributes"
 #define INFOATTRIBUTES_FILE "info/attributes"
 #define ATTRIBUTE_MACRO_PREFIX "[attr]"
+#define PERF_DEBUGFS_ENVIRONMENT "PERF_DIR_DEBUGFS"
 
 typedef int (*config_fn_t)(const char *, const char *, void *);
 extern int perf_default_config(const char *, const char *, void *);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5a3cd3a..891fd03 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -5,6 +5,7 @@
 #include "parse-events.h"
 #include "exec_cmd.h"
 #include "string.h"
+#include "cache.h"
 
 extern char *strcasestr(const char *haystack, const char *needle);
 
@@ -12,8 +13,6 @@ int					nr_counters;
 
 struct perf_counter_attr		attrs[MAX_COUNTERS];
 
-static char default_debugfs_path[] = "/sys/kernel/debug/tracing/events";
-
 struct event_symbol {
 	u8	type;
 	u64	config;
@@ -21,6 +20,8 @@ struct event_symbol {
 	char	*alias;
 };
 
+char debugfs_path[MAXPATHLEN];
+
 #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
 #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
 
@@ -114,16 +115,16 @@ static unsigned long hw_cache_stat[C(MAX)] = {
 
 #define for_each_subsystem(sys_dir, sys_dirent, sys_next, file, st)	       \
 	while (!readdir_r(sys_dir, &sys_dirent, &sys_next) && sys_next)	       \
-	if (snprintf(file, MAXPATHLEN, "%s/%s", default_debugfs_path,	       \
-			sys_dirent.d_name) &&				       \
+	if (snprintf(file, MAXPATHLEN, "%s/%s", debugfs_path,	       	       \
+			sys_dirent.d_name) &&		       		       \
 	   (!stat(file, &st)) && (S_ISDIR(st.st_mode)) &&		       \
 	   (strcmp(sys_dirent.d_name, ".")) &&				       \
 	   (strcmp(sys_dirent.d_name, "..")))
 
 #define for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next, file, st)    \
 	while (!readdir_r(evt_dir, &evt_dirent, &evt_next) && evt_next)        \
-	if (snprintf(file, MAXPATHLEN, "%s/%s/%s", default_debugfs_path,       \
-			sys_dirent.d_name, evt_dirent.d_name) &&	       \
+	if (snprintf(file, MAXPATHLEN, "%s/%s/%s", debugfs_path,	       \
+		     sys_dirent.d_name, evt_dirent.d_name) &&		       \
 	   (!stat(file, &st)) && (S_ISDIR(st.st_mode)) &&		       \
 	   (strcmp(evt_dirent.d_name, ".")) &&				       \
 	   (strcmp(evt_dirent.d_name, "..")))
@@ -134,7 +135,7 @@ static int valid_debugfs_mount(void)
 {
 	struct statfs st_fs;
 
-	if (statfs(default_debugfs_path, &st_fs) < 0)
+	if (statfs(debugfs_path, &st_fs) < 0)
 		return -ENOENT;
 	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
 		return -ENOENT;
@@ -155,7 +156,7 @@ static char *tracepoint_id_to_name(u64 config)
 	if (valid_debugfs_mount())
 		return "unkown";
 
-	sys_dir = opendir(default_debugfs_path);
+	sys_dir = opendir(debugfs_path);
 	if (!sys_dir)
 		goto cleanup;
 
@@ -166,7 +167,7 @@ static char *tracepoint_id_to_name(u64 config)
 		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next,
 								evt_path, st) {
 			snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id",
-				 default_debugfs_path, sys_dirent.d_name,
+				 debugfs_path, sys_dirent.d_name,
 				 evt_dirent.d_name);
 			fd = open(evt_path, O_RDONLY);
 			if (fd < 0)
@@ -381,8 +382,8 @@ static int parse_tracepoint_event(const char **strp,
 	if (evt_length >= MAX_EVENT_LENGTH)
 		return 0;
 
-	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", default_debugfs_path,
-				sys_name, evt_name);
+	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
+		 sys_name, evt_name);
 	fd = open(evt_path, O_RDONLY);
 	if (fd < 0)
 		return 0;
@@ -571,7 +572,7 @@ static void print_tracepoint_events(void)
 	if (valid_debugfs_mount())
 		return;
 
-	sys_dir = opendir(default_debugfs_path);
+	sys_dir = opendir(debugfs_path);
 	if (!sys_dir)
 		goto cleanup;
 
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index e3d5529..0b06da7 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -3,6 +3,8 @@
  * Parse symbolic events/counts passed in as options:
  */
 
+struct option;
+
 extern int			nr_counters;
 
 extern struct perf_counter_attr attrs[MAX_COUNTERS];
@@ -15,3 +17,4 @@ extern int parse_events(const struct option *opt, const char *str, int unset);
 
 extern void print_events(void);
 
+extern char debugfs_path[];
diff --git a/tools/perf/util/string.h b/tools/perf/util/string.h
index 3dca2f6..bf39dfa 100644
--- a/tools/perf/util/string.h
+++ b/tools/perf/util/string.h
@@ -5,4 +5,7 @@
 
 int hex2u64(const char *ptr, u64 *val);
 
+#define _STR(x) #x
+#define STR(x) _STR(x)
+
 #endif
-- 
1.6.0.6

