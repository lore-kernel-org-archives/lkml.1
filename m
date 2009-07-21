Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbZGUSRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbZGUSRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 14:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbZGUSRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 14:17:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40344 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483AbZGUSR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 14:17:29 -0400
Date: Tue, 21 Jul 2009 14:16:29 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ray Lee <ray-lk@madrabbit.org>, zab@zabbo.net
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, paulus@samba.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com
Subject: Re: [PATCH 2/2] perf_counter: detect debugfs location
Message-ID: <20090721181629.GA3094@redhat.com>
References: <cover.1248190728.git.jbaron@redhat.com> <42fb2af3afccef87d78ca6dd86169ad180b63271.1248190728.git.jbaron@redhat.com> <2c0942db0907210926ra96ee33ke3e6ac8c57458be8@mail.gmail.com> <alpine.DEB.2.00.0907211242570.11743@gandalf.stny.rr.com> <2c0942db0907211001o5273a3ccybbba4de448150ddf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0907211001o5273a3ccybbba4de448150ddf@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 10:01:40AM -0700, Ray Lee wrote:
> On Tue, Jul 21, 2009 at 9:44 AM, Steven Rostedt<rostedt@goodmis.org> wrote:
> >
> > On Tue, 21 Jul 2009, Ray Lee wrote:
> >
> >> On Tue, Jul 21, 2009 at 9:20 AM, Jason Baron <jbaron@redhat.com> wrote:
> >> >
> >> > Search for the debugfs filesystem in /proc/mounts, but also allows the user to
> >> > specify '--debugfs-dir=blah' or set the environment variable: 'PERF_DIR_DEBUGFS'
> >>
> >> > -static char default_debugfs_path[] = "/sys/kernel/debug/tracing/events";
> >>
> >> There are server systems out there that run with thousands of mounts.
> >> It would be kinder to the users of those systems (ie, faster perf
> >> startup) if you only went rooting around /proc/mounts if opening the
> >> default location failed.
> >
> > Well, those that have thousand of mounts could probably get away with
> > setting PERF_DIR_DEBUGFS in /etc/profile.
> 
> The intent of the patch is obviously to try to Do The Right Thing by
> default. I think that's great. I just think it should DT(fast and)RT
> instead.
> 
> > But, a simple stat("/sys/kernel/debug/tracing") should be easy enough.
> 
> <nod>

agreed, that would be better. I'm also renaming the environment variable
PERF_DIR_DEBUGFS -> PERF_DEBUGFS_DIR, as Zach Brown pointed out.
Re-spun path below.

thanks,

-Jason

If "/sys/kernel/debug" is not a debugfs mount point, search for the debugfs 
filesystem in /proc/mounts, but also allows the user to specify
'--debugfs-dir=blah' or set the environment variable: 'PERF_DEBUGFS_DIR'

Signed-off-by: Jason Baron <jbaron@redhat.com>

---

 tools/perf/perf.c              |   63 +++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/cache.h        |    1 +
 tools/perf/util/parse-events.c |   33 +++++++++++----------
 tools/perf/util/parse-events.h |    5 +++
 tools/perf/util/string.h       |    3 ++
 5 files changed, 88 insertions(+), 17 deletions(-)


diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index c565678..6d5b121 100644
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
@@ -346,6 +376,35 @@ static int run_argv(int *argcp, const char ***argv)
 	return done_alias;
 }
 
+/* mini /proc/mounts parser: searching for "^blah /mount/point debugfs" */
+static void get_debugfs_mntpt(void)
+{
+	FILE *file;
+	char fs_type[100];
+	char debugfs[MAXPATHLEN];
+
+	if (valid_debugfs_mount("/sys/kernel/debug/") == 0) {
+		strcpy(debugfs_mntpt, "/sys/kernel/debug/");
+		return;
+	}
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
@@ -354,7 +413,8 @@ int main(int argc, const char **argv)
 	cmd = perf_extract_argv0_path(argv[0]);
 	if (!cmd)
 		cmd = "perf-help";
-
+	/* get debugfs mount point from /proc/mounts */
+	get_debugfs_mntpt();
 	/*
 	 * "perf-xxxx" is the same as "perf xxxx", but we obviously:
 	 *
@@ -377,6 +437,7 @@ int main(int argc, const char **argv)
 	argc--;
 	handle_options(&argv, &argc, NULL);
 	commit_pager_choice();
+	set_debugfs_path();
 	if (argc > 0) {
 		if (!prefixcmp(argv[0], "--"))
 			argv[0] += 2;
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 161d5f4..4b50c41 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -18,6 +18,7 @@
 #define PERFATTRIBUTES_FILE ".perfattributes"
 #define INFOATTRIBUTES_FILE "info/attributes"
 #define ATTRIBUTE_MACRO_PREFIX "[attr]"
+#define PERF_DEBUGFS_ENVIRONMENT "PERF_DEBUGFS_DIR"
 
 typedef int (*config_fn_t)(const char *, const char *, void *);
 extern int perf_default_config(const char *, const char *, void *);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5a3cd3a..7bdad8d 100644
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
 
@@ -114,27 +115,27 @@ static unsigned long hw_cache_stat[C(MAX)] = {
 
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
@@ -152,10 +153,10 @@ static char *tracepoint_id_to_name(u64 config)
 	u64 id;
 	char evt_path[MAXPATHLEN];
 
-	if (valid_debugfs_mount())
+	if (valid_debugfs_mount(debugfs_path))
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
@@ -363,7 +364,7 @@ static int parse_tracepoint_event(const char **strp,
 	u64 id;
 	char evt_path[MAXPATHLEN];
 
-	if (valid_debugfs_mount())
+	if (valid_debugfs_mount(debugfs_path))
 		return 0;
 
 	evt_name = strchr(*strp, ':');
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
@@ -568,10 +569,10 @@ static void print_tracepoint_events(void)
 	struct stat st;
 	char evt_path[MAXPATHLEN];
 
-	if (valid_debugfs_mount())
+	if (valid_debugfs_mount(debugfs_path))
 		return;
 
-	sys_dir = opendir(default_debugfs_path);
+	sys_dir = opendir(debugfs_path);
 	if (!sys_dir)
 		goto cleanup;
 
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index e3d5529..1ea5d09 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -3,6 +3,8 @@
  * Parse symbolic events/counts passed in as options:
  */
 
+struct option;
+
 extern int			nr_counters;
 
 extern struct perf_counter_attr attrs[MAX_COUNTERS];
@@ -15,3 +17,6 @@ extern int parse_events(const struct option *opt, const char *str, int unset);
 
 extern void print_events(void);
 
+extern char debugfs_path[];
+extern int valid_debugfs_mount(const char *debugfs);
+
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
