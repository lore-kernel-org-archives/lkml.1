Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbZKHRHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbZKHRHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbZKHRHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:07:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:58726 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653AbZKHRHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:07:49 -0500
Date: Sun, 8 Nov 2009 17:06:51 GMT
From: tip-bot for Clark Williams <williams@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, williams@redhat.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, williams@redhat.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091101155720.624cc87e@torg>
References: <20091101155720.624cc87e@torg>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Modify perf routines to use new debugfs routines
Message-ID: <tip-549104f22b3cd4761145eb5fba6ee4d59822da61@git.kernel.org>
Git-Commit-ID: 549104f22b3cd4761145eb5fba6ee4d59822da61
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  549104f22b3cd4761145eb5fba6ee4d59822da61
Gitweb:     http://git.kernel.org/tip/549104f22b3cd4761145eb5fba6ee4d59822da61
Author:     Clark Williams <williams@redhat.com>
AuthorDate: Sun, 8 Nov 2009 09:03:07 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 18:01:35 +0100

perf tools: Modify perf routines to use new debugfs routines

modify perf.c get_debugfs_mntpnt() to use the util/debugfs.c
debugfs_find_mountpoint()

modify util/parse-events.c to use debugfs_valid_mountpoint().

Signed-off-by: Clark Williams <williams@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20091101155720.624cc87e@torg>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/perf.c              |   44 +++++----------------------------------
 tools/perf/util/parse-events.c |   17 +++-----------
 2 files changed, 10 insertions(+), 51 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 624e62d..601f403 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -14,6 +14,7 @@
 #include "util/run-command.h"
 #include "util/parse-events.h"
 #include "util/string.h"
+#include "util/debugfs.h"
 
 const char perf_usage_string[] =
 	"perf [--version] [--help] COMMAND [ARGS]";
@@ -382,45 +383,12 @@ static int run_argv(int *argcp, const char ***argv)
 /* mini /proc/mounts parser: searching for "^blah /mount/point debugfs" */
 static void get_debugfs_mntpt(void)
 {
-	FILE *file;
-	char fs_type[100];
-	char debugfs[MAXPATHLEN];
+	const char *path = debugfs_find_mountpoint();
 
-	/*
-	 * try the standard location
-	 */
-	if (valid_debugfs_mount("/sys/kernel/debug/") == 0) {
-		strcpy(debugfs_mntpt, "/sys/kernel/debug/");
-		return;
-	}
-
-	/*
-	 * try the sane location
-	 */
-	if (valid_debugfs_mount("/debug/") == 0) {
-		strcpy(debugfs_mntpt, "/debug/");
-		return;
-	}
-
-	/*
-	 * give up and parse /proc/mounts
-	 */
-	file = fopen("/proc/mounts", "r");
-	if (file == NULL)
-		return;
-
-	while (fscanf(file, "%*s %"
-		      STR(MAXPATHLEN)
-		      "s %99s %*s %*d %*d\n",
-		      debugfs, fs_type) == 2) {
-		if (strcmp(fs_type, "debugfs") == 0)
-			break;
-	}
-	fclose(file);
-	if (strcmp(fs_type, "debugfs") == 0) {
-		strncpy(debugfs_mntpt, debugfs, MAXPATHLEN);
-		debugfs_mntpt[MAXPATHLEN - 1] = '\0';
-	}
+	if (path)
+		strncpy(debugfs_mntpt, path, sizeof(debugfs_mntpt));
+	else
+		debugfs_mntpt[0] = '\0';
 }
 
 int main(int argc, const char **argv)
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 31baa5a..097938a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -7,6 +7,7 @@
 #include "string.h"
 #include "cache.h"
 #include "header.h"
+#include "debugfs.h"
 
 int				nr_counters;
 
@@ -149,16 +150,6 @@ static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
 
 #define MAX_EVENT_LENGTH 512
 
-int valid_debugfs_mount(const char *debugfs)
-{
-	struct statfs st_fs;
-
-	if (statfs(debugfs, &st_fs) < 0)
-		return -ENOENT;
-	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
-		return -ENOENT;
-	return 0;
-}
 
 struct tracepoint_path *tracepoint_id_to_path(u64 config)
 {
@@ -171,7 +162,7 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 	char evt_path[MAXPATHLEN];
 	char dir_path[MAXPATHLEN];
 
-	if (valid_debugfs_mount(debugfs_path))
+	if (debugfs_valid_mountpoint(debugfs_path))
 		return NULL;
 
 	sys_dir = opendir(debugfs_path);
@@ -510,7 +501,7 @@ static enum event_result parse_tracepoint_event(const char **strp,
 	char sys_name[MAX_EVENT_LENGTH];
 	unsigned int sys_length, evt_length;
 
-	if (valid_debugfs_mount(debugfs_path))
+	if (debugfs_valid_mountpoint(debugfs_path))
 		return 0;
 
 	evt_name = strchr(*strp, ':');
@@ -788,7 +779,7 @@ static void print_tracepoint_events(void)
 	char evt_path[MAXPATHLEN];
 	char dir_path[MAXPATHLEN];
 
-	if (valid_debugfs_mount(debugfs_path))
+	if (debugfs_valid_mountpoint(debugfs_path))
 		return;
 
 	sys_dir = opendir(debugfs_path);
