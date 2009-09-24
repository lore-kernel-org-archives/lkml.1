Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbZIXTZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbZIXTZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbZIXTZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:25:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:55161 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbZIXTZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:25:43 -0400
Date: Thu, 24 Sep 2009 19:25:12 GMT
From: tip-bot for Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, drepper@redhat.com, hpa@zytor.com,
       mingo@redhat.com, eric.dumazet@gmail.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, drepper@redhat.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4ABB767D.6080004@gmail.com>
References: <4ABB767D.6080004@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Dont use openat()
Message-ID: <tip-725b13685c61168f71825b3fb67d96d2d7aa3b0f@git.kernel.org>
Git-Commit-ID: 725b13685c61168f71825b3fb67d96d2d7aa3b0f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 24 Sep 2009 19:25:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  725b13685c61168f71825b3fb67d96d2d7aa3b0f
Gitweb:     http://git.kernel.org/tip/725b13685c61168f71825b3fb67d96d2d7aa3b0f
Author:     Eric Dumazet <eric.dumazet@gmail.com>
AuthorDate: Thu, 24 Sep 2009 15:39:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Sep 2009 21:20:08 +0200

perf tools: Dont use openat()

openat() is still a young glibc facility, better to not use it in a
non performance critical program (perf list)

Many machines have older glibc (RHEL 4 Update 5 -> glibc-2.3.4-2.36
on my dev machine for example).

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ulrich Drepper <drepper@redhat.com>
LKML-Reference: <4ABB767D.6080004@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/parse-events.c |   49 ++++++++++++++++-----------------------
 1 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 13ab4b8..87c424d 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -165,33 +165,31 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 	DIR *sys_dir, *evt_dir;
 	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
 	char id_buf[4];
-	int sys_dir_fd, fd;
+	int fd;
 	u64 id;
 	char evt_path[MAXPATHLEN];
+	char dir_path[MAXPATHLEN];
 
 	if (valid_debugfs_mount(debugfs_path))
 		return NULL;
 
 	sys_dir = opendir(debugfs_path);
 	if (!sys_dir)
-		goto cleanup;
-	sys_dir_fd = dirfd(sys_dir);
+		return NULL;
 
 	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
-		int dfd = openat(sys_dir_fd, sys_dirent.d_name,
-				 O_RDONLY|O_DIRECTORY), evt_dir_fd;
-		if (dfd == -1)
-			continue;
-		evt_dir = fdopendir(dfd);
-		if (!evt_dir) {
-			close(dfd);
+
+		snprintf(dir_path, MAXPATHLEN, "%s/%s", debugfs_path,
+			 sys_dirent.d_name);
+		evt_dir = opendir(dir_path);
+		if (!evt_dir)
 			continue;
-		}
-		evt_dir_fd = dirfd(evt_dir);
+
 		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
-			snprintf(evt_path, MAXPATHLEN, "%s/id",
+
+			snprintf(evt_path, MAXPATHLEN, "%s/%s/id", dir_path,
 				 evt_dirent.d_name);
-			fd = openat(evt_dir_fd, evt_path, O_RDONLY);
+			fd = open(evt_path, O_RDONLY);
 			if (fd < 0)
 				continue;
 			if (read(fd, id_buf, sizeof(id_buf)) < 0) {
@@ -225,7 +223,6 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 		closedir(evt_dir);
 	}
 
-cleanup:
 	closedir(sys_dir);
 	return NULL;
 }
@@ -761,28 +758,24 @@ static void print_tracepoint_events(void)
 {
 	DIR *sys_dir, *evt_dir;
 	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
-	int sys_dir_fd;
 	char evt_path[MAXPATHLEN];
+	char dir_path[MAXPATHLEN];
 
 	if (valid_debugfs_mount(debugfs_path))
 		return;
 
 	sys_dir = opendir(debugfs_path);
 	if (!sys_dir)
-		goto cleanup;
-	sys_dir_fd = dirfd(sys_dir);
+		return;
 
 	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
-		int dfd = openat(sys_dir_fd, sys_dirent.d_name,
-				 O_RDONLY|O_DIRECTORY), evt_dir_fd;
-		if (dfd == -1)
-			continue;
-		evt_dir = fdopendir(dfd);
-		if (!evt_dir) {
-			close(dfd);
+
+		snprintf(dir_path, MAXPATHLEN, "%s/%s", debugfs_path,
+			 sys_dirent.d_name);
+		evt_dir = opendir(dir_path);
+		if (!evt_dir)
 			continue;
-		}
-		evt_dir_fd = dirfd(evt_dir);
+
 		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
 			snprintf(evt_path, MAXPATHLEN, "%s:%s",
 				 sys_dirent.d_name, evt_dirent.d_name);
@@ -791,8 +784,6 @@ static void print_tracepoint_events(void)
 		}
 		closedir(evt_dir);
 	}
-
-cleanup:
 	closedir(sys_dir);
 }
 
