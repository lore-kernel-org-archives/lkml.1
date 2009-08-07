Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbZHGLNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbZHGLNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757356AbZHGLNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:13:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:37831 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757110AbZHGLNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:13:20 -0400
Date: Fri, 7 Aug 2009 11:12:37 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, rostedt@goodmis.org,
       chris.mason@oracle.com, tglx@linutronix.de, jbaron@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org, rostedt@goodmis.org,
       chris.mason@oracle.com, tglx@linutronix.de, jbaron@redhat.com,
       mingo@elte.hu
In-Reply-To: <1249570134.32113.483.camel@twins>
References: <1249570134.32113.483.camel@twins>
Subject: [tip:perfcounters/urgent] perf: Don't list tracepoints without an id
Message-ID: <tip-79e372825f775fabd2219c9c45fbdff93c24cd3f@git.kernel.org>
Git-Commit-ID: 79e372825f775fabd2219c9c45fbdff93c24cd3f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 07 Aug 2009 11:12:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79e372825f775fabd2219c9c45fbdff93c24cd3f
Gitweb:     http://git.kernel.org/tip/79e372825f775fabd2219c9c45fbdff93c24cd3f
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 6 Aug 2009 16:48:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Aug 2009 13:09:10 +0200

perf: Don't list tracepoints without an id

Stop perf list from displaying tracepoints without an id file,
those are special tracepoints that are not interfaced to
perfcounters.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Chris Mason <chris.mason@oracle.com>
LKML-Reference: <1249570134.32113.483.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/parse-events.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index f77407b..4858d83 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -121,13 +121,29 @@ static unsigned long hw_cache_stat[C(MAX)] = {
 	   (strcmp(sys_dirent.d_name, ".")) &&				       \
 	   (strcmp(sys_dirent.d_name, "..")))
 
+static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
+{
+	char evt_path[MAXPATHLEN];
+	int fd;
+
+	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
+			sys_dir->d_name, evt_dir->d_name);
+	fd = open(evt_path, O_RDONLY);
+	if (fd < 0)
+		return -EINVAL;
+	close(fd);
+
+	return 0;
+}
+
 #define for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next, file, st)    \
 	while (!readdir_r(evt_dir, &evt_dirent, &evt_next) && evt_next)        \
 	if (snprintf(file, MAXPATHLEN, "%s/%s/%s", debugfs_path,	       \
 		     sys_dirent.d_name, evt_dirent.d_name) &&		       \
 	   (!stat(file, &st)) && (S_ISDIR(st.st_mode)) &&		       \
 	   (strcmp(evt_dirent.d_name, ".")) &&				       \
-	   (strcmp(evt_dirent.d_name, "..")))
+	   (strcmp(evt_dirent.d_name, "..")) &&				       \
+	   (!tp_event_has_id(&sys_dirent, &evt_dirent)))
 
 #define MAX_EVENT_LENGTH 30
 
