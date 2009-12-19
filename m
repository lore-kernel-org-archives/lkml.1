Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbZLSVmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbZLSVmO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 16:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbZLSVmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 16:42:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbZLSVmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 16:42:12 -0500
Date: Sat, 19 Dec 2009 16:40:28 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200912192140.nBJLeSfA028905@hs20-bc2-1.build.redhat.com>
To: a.p.zijlstra@chello.nl, acme@redhat.com, eranian@google.com,
       fweisbec@gmail.com, linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       mingo@elte.hu, paulus@samba.org, penberg@cs.helsinki.fi,
       xiaoguangrong@cn.fujitsu.com
Subject: perf: A few more directory handling optimizations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few more optimizations for perf when dealing with directories.  Some of
them significantly cut down the work which has to be done.  d_type should
always be set; otherwise fix the kernel code.  And there are functions
available to parse fstab-like files, so use them.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>

 builtin-kmem.c          |   17 +++++-----------
 util/trace-event-info.c |   49 +++++++++++++++++++++---------------------------
 2 files changed, 28 insertions(+), 38 deletions(-)


diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index fc21ad7..a438c54 100644
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
index cace355..bff6d8c 100644
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
@@ -103,28 +104,27 @@ static const char *find_debugfs(void)
 {
 	static char debugfs[MAX_PATH+1];
 	static int debugfs_found;
-	char type[100];
 	FILE *fp;
+	struct mntent *m;
 
 	if (debugfs_found)
 		return debugfs;
 
-	if ((fp = fopen("/proc/mounts","r")) == NULL)
+	if ((fp = setmntent("/proc/mounts", "r")) == NULL)
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
+	if (! debugfs_found)
+		die("debugfs not mounted, please mount");
 
 	return debugfs;
 }
@@ -317,7 +317,8 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 		die("can't read directory '%s'", sys);
 
 	while ((dent = readdir(dir))) {
-		if (strcmp(dent->d_name, ".") == 0 ||
+		if (dent->d_type != DT_DIR ||
+		    strcmp(dent->d_name, ".") == 0 ||
 		    strcmp(dent->d_name, "..") == 0 ||
 		    !name_in_tp_list(dent->d_name, tps))
 			continue;
@@ -334,7 +335,8 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 
 	rewinddir(dir);
 	while ((dent = readdir(dir))) {
-		if (strcmp(dent->d_name, ".") == 0 ||
+		if (dent->d_type != DT_DIR ||
+		    strcmp(dent->d_name, ".") == 0 ||
 		    strcmp(dent->d_name, "..") == 0 ||
 		    !name_in_tp_list(dent->d_name, tps))
 			continue;
@@ -394,26 +396,21 @@ static void read_event_files(struct tracepoint_path *tps)
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
@@ -422,10 +419,8 @@ static void read_event_files(struct tracepoint_path *tps)
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
