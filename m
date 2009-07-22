Return-Path: <linux-kernel-owner+w=401wt.eu-S1752384AbZGVJsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbZGVJsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZGVJsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:48:45 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:61409 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbZGVJsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:48:43 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/2] perf_counter: detect debugfs location
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jason Baron <jbaron@redhat.com>
Cc: Ray Lee <ray-lk@madrabbit.org>, zab@zabbo.net,
       Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, paulus@samba.org, fweisbec@gmail.com
In-Reply-To: <20090721181629.GA3094@redhat.com>
References: <cover.1248190728.git.jbaron@redhat.com>
	 <42fb2af3afccef87d78ca6dd86169ad180b63271.1248190728.git.jbaron@redhat.com>
	 <2c0942db0907210926ra96ee33ke3e6ac8c57458be8@mail.gmail.com>
	 <alpine.DEB.2.00.0907211242570.11743@gandalf.stny.rr.com>
	 <2c0942db0907211001o5273a3ccybbba4de448150ddf@mail.gmail.com>
	 <20090721181629.GA3094@redhat.com>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 11:49:50 +0200
Message-Id: <1248256190.27058.1198.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I queued the below.

Thanks Jason!

---
Subject: perf_counter: Detect debugfs location
From: Jason Baron <jbaron@redhat.com>
Date: Tue, 21 Jul 2009 14:16:29 -0400

If "/sys/kernel/debug" is not a debugfs mount point, search for the debugfs
filesystem in /proc/mounts, but also allows the user to specify
'--debugfs-dir=blah' or set the environment variable: 'PERF_DEBUGFS_DIR'

Signed-off-by: Jason Baron <jbaron@redhat.com>
[ also made it probe "/debug" by default ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090721181629.GA3094@redhat.com>
---
 tools/perf/perf.c              |   77 ++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/cache.h        |    1 
 tools/perf/util/parse-events.c |   33 +++++++++--------
 tools/perf/util/parse-events.h |    5 ++
 tools/perf/util/string.h       |    3 +
 5 files changed, 102 insertions(+), 17 deletions(-)

Index: linux-2.6/tools/perf/perf.c
===================================================================
--- linux-2.6.orig/tools/perf/perf.c
+++ linux-2.6/tools/perf/perf.c
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
@@ -122,6 +135,22 @@ static int handle_options(const char*** 
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
@@ -228,6 +257,7 @@ static int run_builtin(struct cmd_struct
 	if (use_pager == -1 && p->option & USE_PAGER)
 		use_pager = 1;
 	commit_pager_choice();
+	set_debugfs_path();
 
 	status = p->fn(argc, argv, prefix);
 	if (status)
@@ -346,6 +376,49 @@ static int run_argv(int *argcp, const ch
 	return done_alias;
 }
 
+/* mini /proc/mounts parser: searching for "^blah /mount/point debugfs" */
+static void get_debugfs_mntpt(void)
+{
+	FILE *file;
+	char fs_type[100];
+	char debugfs[MAXPATHLEN];
+
+	/*
+	 * try the standard location
+	 */
+	if (valid_debugfs_mount("/sys/kernel/debug/") == 0) {
+		strcpy(debugfs_mntpt, "/sys/kernel/debug/");
+		return;
+	}
+
+	/*
+	 * try the sane location
+	 */
+	if (valid_debugfs_mount("/debug/") == 0) {
+		strcpy(debugfs_mntpt, "/debug/");
+		return;
+	}
+
+	/*
+	 * give up and parse /proc/mounts
+	 */
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
@@ -354,7 +427,8 @@ int main(int argc, const char **argv)
 	cmd = perf_extract_argv0_path(argv[0]);
 	if (!cmd)
 		cmd = "perf-help";
-
+	/* get debugfs mount point from /proc/mounts */
+	get_debugfs_mntpt();
 	/*
 	 * "perf-xxxx" is the same as "perf xxxx", but we obviously:
 	 *
@@ -377,6 +451,7 @@ int main(int argc, const char **argv)
 	argc--;
 	handle_options(&argv, &argc, NULL);
 	commit_pager_choice();
+	set_debugfs_path();
 	if (argc > 0) {
 		if (!prefixcmp(argv[0], "--"))
 			argv[0] += 2;
Index: linux-2.6/tools/perf/util/cache.h
===================================================================
--- linux-2.6.orig/tools/perf/util/cache.h
+++ linux-2.6/tools/perf/util/cache.h
@@ -18,6 +18,7 @@
 #define PERFATTRIBUTES_FILE ".perfattributes"
 #define INFOATTRIBUTES_FILE "info/attributes"
 #define ATTRIBUTE_MACRO_PREFIX "[attr]"
+#define PERF_DEBUGFS_ENVIRONMENT "PERF_DEBUGFS_DIR"
 
 typedef int (*config_fn_t)(const char *, const char *, void *);
 extern int perf_default_config(const char *, const char *, void *);
Index: linux-2.6/tools/perf/util/parse-events.c
===================================================================
--- linux-2.6.orig/tools/perf/util/parse-events.c
+++ linux-2.6/tools/perf/util/parse-events.c
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
 
@@ -114,27 +115,27 @@ static unsigned long hw_cache_stat[C(MAX
 
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
 
 #define MAX_EVENT_LENGTH 30
 
-static int valid_debugfs_mount(void)
+int valid_debugfs_mount(const char *debugfs)
 {
 	struct statfs st_fs;
 
-	if (statfs(default_debugfs_path, &st_fs) < 0)
+	if (statfs(debugfs, &st_fs) < 0)
 		return -ENOENT;
 	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
 		return -ENOENT;
@@ -152,10 +153,10 @@ static char *tracepoint_id_to_name(u64 c
 	u64 id;
 	char evt_path[MAXPATHLEN];
 
-	if (valid_debugfs_mount())
+	if (valid_debugfs_mount(debugfs_path))
 		return "unkown";
 
-	sys_dir = opendir(default_debugfs_path);
+	sys_dir = opendir(debugfs_path);
 	if (!sys_dir)
 		goto cleanup;
 
@@ -166,7 +167,7 @@ static char *tracepoint_id_to_name(u64 c
 		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next,
 								evt_path, st) {
 			snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id",
-				 default_debugfs_path, sys_dirent.d_name,
+				 debugfs_path, sys_dirent.d_name,
 				 evt_dirent.d_name);
 			fd = open(evt_path, O_RDONLY);
 			if (fd < 0)
@@ -363,7 +364,7 @@ static int parse_tracepoint_event(const 
 	u64 id;
 	char evt_path[MAXPATHLEN];
 
-	if (valid_debugfs_mount())
+	if (valid_debugfs_mount(debugfs_path))
 		return 0;
 
 	evt_name = strchr(*strp, ':');
@@ -381,8 +382,8 @@ static int parse_tracepoint_event(const 
 	if (evt_length >= MAX_EVENT_LENGTH)
 		return 0;
 
-	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", default_debugfs_path,
-				sys_name, evt_name);
+	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
+		 sys_name, evt_name);
 	fd = open(evt_path, O_RDONLY);
 	if (fd < 0)
 		return 0;
@@ -568,10 +569,10 @@ static void print_tracepoint_events(void
 	struct stat st;
 	char evt_path[MAXPATHLEN];
 
-	if (valid_debugfs_mount())
+	if (valid_debugfs_mount(debugfs_path))
 		return;
 
-	sys_dir = opendir(default_debugfs_path);
+	sys_dir = opendir(debugfs_path);
 	if (!sys_dir)
 		goto cleanup;
 
Index: linux-2.6/tools/perf/util/parse-events.h
===================================================================
--- linux-2.6.orig/tools/perf/util/parse-events.h
+++ linux-2.6/tools/perf/util/parse-events.h
@@ -3,6 +3,8 @@
  * Parse symbolic events/counts passed in as options:
  */
 
+struct option;
+
 extern int			nr_counters;
 
 extern struct perf_counter_attr attrs[MAX_COUNTERS];
@@ -15,3 +17,6 @@ extern int parse_events(const struct opt
 
 extern void print_events(void);
 
+extern char debugfs_path[];
+extern int valid_debugfs_mount(const char *debugfs);
+
Index: linux-2.6/tools/perf/util/string.h
===================================================================
--- linux-2.6.orig/tools/perf/util/string.h
+++ linux-2.6/tools/perf/util/string.h
@@ -5,4 +5,7 @@
 
 int hex2u64(const char *ptr, u64 *val);
 
+#define _STR(x) #x
+#define STR(x) _STR(x)
+
 #endif


