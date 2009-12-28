Return-Path: <linux-kernel-owner+w=401wt.eu-S1751719AbZL1KLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbZL1KLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbZL1KLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:11:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:36457 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbZL1KLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:11:03 -0500
Date: Mon, 28 Dec 2009 10:09:37 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, jkacur@redhat.com, williams@redhat.com,
       peterz@infradead.org, xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, williams@redhat.com,
       peterz@infradead.org, xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B3870DE.7090500@cn.fujitsu.com>
References: <4B3870DE.7090500@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Clean up find_debugfs()
Message-ID: <tip-61be3e59ba7a6dbd39f92fd1f107285a0caeb008@git.kernel.org>
Git-Commit-ID: 61be3e59ba7a6dbd39f92fd1f107285a0caeb008
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61be3e59ba7a6dbd39f92fd1f107285a0caeb008
Gitweb:     http://git.kernel.org/tip/61be3e59ba7a6dbd39f92fd1f107285a0caeb008
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Mon, 28 Dec 2009 16:48:30 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Dec 2009 10:36:36 +0100

perf trace: Clean up find_debugfs()

Remove redundant code for 'perf trace'

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Clark Williams <williams@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <4B3870DE.7090500@cn.fujitsu.com>
[ v2: resolved conflicts with recent changes ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/debugfs.c          |    1 +
 tools/perf/util/trace-event-info.c |   29 +++++------------------------
 2 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/tools/perf/util/debugfs.c b/tools/perf/util/debugfs.c
index 1f805fd..a88fefc 100644
--- a/tools/perf/util/debugfs.c
+++ b/tools/perf/util/debugfs.c
@@ -130,6 +130,7 @@ char *debugfs_mount(const char *mountpoint)
 
 	/* save the mountpoint */
 	strncpy(debugfs_mountpoint, mountpoint, sizeof(debugfs_mountpoint));
+	debugfs_found = 1;
 
 	return debugfs_mountpoint;
 }
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index dfef238..535176d 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -38,6 +38,7 @@
 
 #include "../perf.h"
 #include "trace-event.h"
+#include "debugfs.h"
 
 #define VERSION "0.5"
 
@@ -102,32 +103,12 @@ void *malloc_or_die(unsigned int size)
 
 static const char *find_debugfs(void)
 {
-	static char debugfs[MAX_PATH+1];
-	static int debugfs_found;
-	FILE *fp;
-	struct mntent *m;
-
-	if (debugfs_found)
-		return debugfs;
-
-	fp = setmntent("/proc/mounts", "r");
-	if (!fp)
-		die("Can't open /proc/mounts for read");
-
-	while ((m = getmntent(fp)) != NULL) {
-		if (strcmp(m->mnt_type, "debugfs") == 0) {
-			strcpy(debugfs, m->mnt_dir);
-			debugfs_found = 1;
-			break;
-		}
-	}
-
-	endmntent(fp);
+	const char *path = debugfs_mount(NULL);
 
-	if (!debugfs_found)
-		die("debugfs not mounted, please mount");
+	if (!path)
+		die("Your kernel not support debugfs filesystem");
 
-	return debugfs;
+	return path;
 }
 
 /*
