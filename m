Return-Path: <linux-kernel-owner+w=401wt.eu-S1751478AbZL1KIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbZL1KIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbZL1KIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:08:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:36288 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbZL1KIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:08:36 -0500
Date: Mon, 28 Dec 2009 10:08:03 GMT
From: tip-bot for Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, drepper@redhat.com, hpa@zytor.com,
       mingo@redhat.com, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, drepper@redhat.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200912192140.nBJLeSfA028905@hs20-bc2-1.build.redhat.com>
References: <200912192140.nBJLeSfA028905@hs20-bc2-1.build.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Do a few more directory handling optimizations
Message-ID: <tip-659d8cfbb225f1fa5a4f8671a847ef3ab5a89660@git.kernel.org>
Git-Commit-ID: 659d8cfbb225f1fa5a4f8671a847ef3ab5a89660
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  659d8cfbb225f1fa5a4f8671a847ef3ab5a89660
Gitweb:     http://git.kernel.org/tip/659d8cfbb225f1fa5a4f8671a847ef3ab5a89660
Author:     Ulrich Drepper <drepper@redhat.com>
AuthorDate: Sat, 19 Dec 2009 16:40:28 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Dec 2009 10:18:37 +0100

perf tools: Do a few more directory handling optimizations

A few more optimizations for perf when dealing with directories.

Some of them significantly cut down the work which has to be
done. d_type should always be set; otherwise fix the kernel
code. And there are functions available to parse fstab-like
files, so use them.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: a.p.zijlstra@chello.nl
Cc: acme@redhat.com
Cc: eranian@google.com
Cc: fweisbec@gmail.com
Cc: lizf@cn.fujitsu.com
Cc: paulus@samba.org
Cc: xiaoguangrong@cn.fujitsu.com
LKML-Reference: <200912192140.nBJLeSfA028905@hs20-bc2-1.build.redhat.com>
[ v2: two small stylistic fixlets ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-kmem.c          |   17 ++++--------
 tools/perf/util/trace-event-info.c |   50 ++++++++++++++++-------------------
 2 files changed, 29 insertions(+), 38 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 4c06828..05dc5a7 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -92,23 +92,18 @@ static void setup_cpunode_map(void)
 	if (!dir1)
 		return;
 
-	while (true) {
-		dent1 = readdir(dir1);
-		if (!dent1)
-			break;
-
-		if (sscanf(dent1->d_name, "node%u", &mem) < 1)
+	while ((dent1 = readdir(dir1)) != NULL) {
+		if (dent1->d_type != DT_DIR ||
+		    sscanf(dent1->d_name, "node%u", &mem) < 1)
 			continue;
 
 		snprintf(buf, PATH_MAX, "%s/%s", PATH_SYS_NODE, dent1->d_name);
 		dir2 = opendir(buf);
 		if (!dir2)
 			continue;
-		while (true) {
-			dent2 = readdir(dir2);
-			if (!dent2)
-				break;
-			if (sscanf(dent2->d_name, "cpu%u", &cpu) < 1)
+		while ((dent2 = readdir(dir2)) != NULL) {
+			if (dent2->d_type != DT_LNK ||
+			    sscanf(dent2->d_name, "cpu%u", &cpu) < 1)
 				continue;
 			cpunode_map[cpu] = mem;
 		}
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index cace355..dfef238 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -20,6 +20,7 @@
  */
 #define _GNU_SOURCE
 #include <dirent.h>
+#include <mntent.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -103,28 +104,28 @@ static const char *find_debugfs(void)
 {
 	static char debugfs[MAX_PATH+1];
 	static int debugfs_found;
-	char type[100];
 	FILE *fp;
+	struct mntent *m;
 
 	if (debugfs_found)
 		return debugfs;
 
-	if ((fp = fopen("/proc/mounts","r")) == NULL)
+	fp = setmntent("/proc/mounts", "r");
+	if (!fp)
 		die("Can't open /proc/mounts for read");
 
-	while (fscanf(fp, "%*s %"
-		      STR(MAX_PATH)
-		      "s %99s %*s %*d %*d\n",
-		      debugfs, type) == 2) {
-		if (strcmp(type, "debugfs") == 0)
+	while ((m = getmntent(fp)) != NULL) {
+		if (strcmp(m->mnt_type, "debugfs") == 0) {
+			strcpy(debugfs, m->mnt_dir);
+			debugfs_found = 1;
 			break;
+		}
 	}
-	fclose(fp);
 
-	if (strcmp(type, "debugfs") != 0)
-		die("debugfs not mounted, please mount");
+	endmntent(fp);
 
-	debugfs_found = 1;
+	if (!debugfs_found)
+		die("debugfs not mounted, please mount");
 
 	return debugfs;
 }
@@ -317,7 +318,8 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 		die("can't read directory '%s'", sys);
 
 	while ((dent = readdir(dir))) {
-		if (strcmp(dent->d_name, ".") == 0 ||
+		if (dent->d_type != DT_DIR ||
+		    strcmp(dent->d_name, ".") == 0 ||
 		    strcmp(dent->d_name, "..") == 0 ||
 		    !name_in_tp_list(dent->d_name, tps))
 			continue;
@@ -334,7 +336,8 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 
 	rewinddir(dir);
 	while ((dent = readdir(dir))) {
-		if (strcmp(dent->d_name, ".") == 0 ||
+		if (dent->d_type != DT_DIR ||
+		    strcmp(dent->d_name, ".") == 0 ||
 		    strcmp(dent->d_name, "..") == 0 ||
 		    !name_in_tp_list(dent->d_name, tps))
 			continue;
@@ -394,26 +397,21 @@ static void read_event_files(struct tracepoint_path *tps)
 		die("can't read directory '%s'", path);
 
 	while ((dent = readdir(dir))) {
-		if (strcmp(dent->d_name, ".") == 0 ||
+		if (dent->d_type != DT_DIR ||
+		    strcmp(dent->d_name, ".") == 0 ||
 		    strcmp(dent->d_name, "..") == 0 ||
 		    strcmp(dent->d_name, "ftrace") == 0 ||
 		    !system_in_tp_list(dent->d_name, tps))
 			continue;
-		sys = malloc_or_die(strlen(path) + strlen(dent->d_name) + 2);
-		sprintf(sys, "%s/%s", path, dent->d_name);
-		ret = stat(sys, &st);
-		free(sys);
-		if (ret < 0)
-			continue;
-		if (S_ISDIR(st.st_mode))
-			count++;
+		count++;
 	}
 
 	write_or_die(&count, 4);
 
 	rewinddir(dir);
 	while ((dent = readdir(dir))) {
-		if (strcmp(dent->d_name, ".") == 0 ||
+		if (dent->d_type != DT_DIR ||
+		    strcmp(dent->d_name, ".") == 0 ||
 		    strcmp(dent->d_name, "..") == 0 ||
 		    strcmp(dent->d_name, "ftrace") == 0 ||
 		    !system_in_tp_list(dent->d_name, tps))
@@ -422,10 +420,8 @@ static void read_event_files(struct tracepoint_path *tps)
 		sprintf(sys, "%s/%s", path, dent->d_name);
 		ret = stat(sys, &st);
 		if (ret >= 0) {
-			if (S_ISDIR(st.st_mode)) {
-				write_or_die(dent->d_name, strlen(dent->d_name) + 1);
-				copy_event_system(sys, tps);
-			}
+			write_or_die(dent->d_name, strlen(dent->d_name) + 1);
+			copy_event_system(sys, tps);
 		}
 		free(sys);
 	}
