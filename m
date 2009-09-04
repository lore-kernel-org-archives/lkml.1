Return-Path: <linux-kernel-owner+w=401wt.eu-S933901AbZIDTwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbZIDTwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbZIDTwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:52:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:48568 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757277AbZIDTwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:52:10 -0400
Date: Fri, 4 Sep 2009 19:51:38 GMT
From: tip-bot for Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       drepper@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: drepper@redhat.com, mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090904193951.GB6186@ghostprotocols.net>
References: <20090904193951.GB6186@ghostprotocols.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf tools: Avoid unnecessary work in directory lookups
Message-ID: <tip-6b58e7f146f8d79c08f62087f928e1f01747de71@git.kernel.org>
Git-Commit-ID: 6b58e7f146f8d79c08f62087f928e1f01747de71
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 19:51:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b58e7f146f8d79c08f62087f928e1f01747de71
Gitweb:     http://git.kernel.org/tip/6b58e7f146f8d79c08f62087f928e1f01747de71
Author:     Ulrich Drepper <drepper@redhat.com>
AuthorDate: Fri, 4 Sep 2009 16:39:51 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 21:50:17 +0200

perf tools: Avoid unnecessary work in directory lookups

This patch improves some (common) inefficiencies in the
handling of directory lookups:

- not using the d_type information returned by the kernel

- constructing (absolute) paths for file operation even though
  directory-relative operations using the *at functions is
  possible

There are more places to fix but this is a start.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20090904193951.GB6186@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/parse-events.c |   68 +++++++++++++++++++++------------------
 1 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 89d46c9..52219d5 100644
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
 			fprintf(stderr, "  %-40s [%s]\n", evt_path,
