Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbZIDTkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbZIDTkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbZIDTkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:40:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242AbZIDTkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:40:15 -0400
Date: Fri, 4 Sep 2009 16:39:51 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf tools: Avoid unnecessary work in directory lookups
Message-ID: <20090904193951.GB6186@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Drepper <drepper@redhat.com>

This patch improves some (common) inefficiencies in the handling of
directory lookups:

- not using the d_type information returned by the kernel

- constructing (absolute) paths for file operation even though
  directory-relative operations using the *at functions is possible

There are more places to fix but this is a start.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |   68 +++++++++++++++++++++------------------
 1 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 8c20239..a587d41 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1,14 +1,12 @@
 
-#include "../perf.h"
 #include "util.h"
+#include "../perf.h"
 #include "parse-options.h"
 #include "parse-events.h"
 #include "exec_cmd.h"
 #include "string.h"
 #include "cache.h"
 
-extern char *strcasestr(const char *haystack, const char *needle);
-
 int					nr_counters;
 
 struct perf_counter_attr		attrs[MAX_COUNTERS];
@@ -113,11 +111,9 @@ static unsigned long hw_cache_stat[C(MAX)] = {
  [C(BPU)]	= (CACHE_READ),
 };
 
-#define for_each_subsystem(sys_dir, sys_dirent, sys_next, file, st)	       \
+#define for_each_subsystem(sys_dir, sys_dirent, sys_next)	       \
 	while (!readdir_r(sys_dir, &sys_dirent, &sys_next) && sys_next)	       \
-	if (snprintf(file, MAXPATHLEN, "%s/%s", debugfs_path,	       	       \
-			sys_dirent.d_name) &&		       		       \
-	   (!stat(file, &st)) && (S_ISDIR(st.st_mode)) &&		       \
+	if (sys_dirent.d_type == DT_DIR &&				       \
 	   (strcmp(sys_dirent.d_name, ".")) &&				       \
 	   (strcmp(sys_dirent.d_name, "..")))
 
@@ -136,11 +132,9 @@ static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
 	return 0;
 }
 
-#define for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next, file, st)    \
+#define for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next)	       \
 	while (!readdir_r(evt_dir, &evt_dirent, &evt_next) && evt_next)        \
-	if (snprintf(file, MAXPATHLEN, "%s/%s/%s", debugfs_path,	       \
-		     sys_dirent.d_name, evt_dirent.d_name) &&		       \
-	   (!stat(file, &st)) && (S_ISDIR(st.st_mode)) &&		       \
+	if (evt_dirent.d_type == DT_DIR &&				       \
 	   (strcmp(evt_dirent.d_name, ".")) &&				       \
 	   (strcmp(evt_dirent.d_name, "..")) &&				       \
 	   (!tp_event_has_id(&sys_dirent, &evt_dirent)))
@@ -163,9 +157,8 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 	struct tracepoint_path *path = NULL;
 	DIR *sys_dir, *evt_dir;
 	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
-	struct stat st;
 	char id_buf[4];
-	int fd;
+	int sys_dir_fd, fd;
 	u64 id;
 	char evt_path[MAXPATHLEN];
 
@@ -175,17 +168,23 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 	sys_dir = opendir(debugfs_path);
 	if (!sys_dir)
 		goto cleanup;
-
-	for_each_subsystem(sys_dir, sys_dirent, sys_next, evt_path, st) {
-		evt_dir = opendir(evt_path);
-		if (!evt_dir)
-			goto cleanup;
-		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next,
-								evt_path, st) {
-			snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id",
-				 debugfs_path, sys_dirent.d_name,
+	sys_dir_fd = dirfd(sys_dir);
+
+	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
+		int dfd = openat(sys_dir_fd, sys_dirent.d_name,
+				 O_RDONLY|O_DIRECTORY), evt_dir_fd;
+		if (dfd == -1)
+			continue;
+		evt_dir = fdopendir(dfd);
+		if (!evt_dir) {
+			close(dfd);
+			continue;
+		}
+		evt_dir_fd = dirfd(evt_dir);
+		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
+			snprintf(evt_path, MAXPATHLEN, "%s/id",
 				 evt_dirent.d_name);
-			fd = open(evt_path, O_RDONLY);
+			fd = openat(evt_dir_fd, evt_path, O_RDONLY);
 			if (fd < 0)
 				continue;
 			if (read(fd, id_buf, sizeof(id_buf)) < 0) {
@@ -629,7 +628,7 @@ static void print_tracepoint_events(void)
 {
 	DIR *sys_dir, *evt_dir;
 	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
-	struct stat st;
+	int sys_dir_fd;
 	char evt_path[MAXPATHLEN];
 
 	if (valid_debugfs_mount(debugfs_path))
@@ -638,13 +637,20 @@ static void print_tracepoint_events(void)
 	sys_dir = opendir(debugfs_path);
 	if (!sys_dir)
 		goto cleanup;
-
-	for_each_subsystem(sys_dir, sys_dirent, sys_next, evt_path, st) {
-		evt_dir = opendir(evt_path);
-		if (!evt_dir)
-			goto cleanup;
-		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next,
-								evt_path, st) {
+	sys_dir_fd = dirfd(sys_dir);
+
+	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
+		int dfd = openat(sys_dir_fd, sys_dirent.d_name,
+				 O_RDONLY|O_DIRECTORY), evt_dir_fd;
+		if (dfd == -1)
+			continue;
+		evt_dir = fdopendir(dfd);
+		if (!evt_dir) {
+			close(dfd);
+			continue;
+		}
+		evt_dir_fd = dirfd(evt_dir);
+		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
 			snprintf(evt_path, MAXPATHLEN, "%s:%s",
 				 sys_dirent.d_name, evt_dirent.d_name);
 			fprintf(stderr, "  %-42s [%s]\n", evt_path,
-- 
1.5.5.1

