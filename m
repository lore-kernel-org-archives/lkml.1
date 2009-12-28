Return-Path: <linux-kernel-owner+w=401wt.eu-S1752295AbZL1KMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbZL1KMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZL1KMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:12:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:48170 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbZL1KMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:12:44 -0500
Date: Mon, 28 Dec 2009 10:09:21 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, jkacur@redhat.com, williams@redhat.com,
       peterz@infradead.org, xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, williams@redhat.com,
       peterz@infradead.org, xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B387090.7080407@cn.fujitsu.com>
References: <4B387090.7080407@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Mount debugfs automatically
Message-ID: <tip-29c52aa2300173dd45df04dae1f5acc81a2c93b1@git.kernel.org>
Git-Commit-ID: 29c52aa2300173dd45df04dae1f5acc81a2c93b1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29c52aa2300173dd45df04dae1f5acc81a2c93b1
Gitweb:     http://git.kernel.org/tip/29c52aa2300173dd45df04dae1f5acc81a2c93b1
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Mon, 28 Dec 2009 16:47:12 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Dec 2009 10:36:36 +0100

perf tools: Mount debugfs automatically

Mount debugfs filesystem under '/sys/kernel/debug', if it's not
mounted.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Clark Williams <williams@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <4B387090.7080407@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/perf.c         |    2 +-
 tools/perf/util/debugfs.c |   16 +++++++---------
 tools/perf/util/debugfs.h |    2 +-
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 873e55f..fc89005 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -388,7 +388,7 @@ static int run_argv(int *argcp, const char ***argv)
 /* mini /proc/mounts parser: searching for "^blah /mount/point debugfs" */
 static void get_debugfs_mntpt(void)
 {
-	const char *path = debugfs_find_mountpoint();
+	const char *path = debugfs_mount(NULL);
 
 	if (path)
 		strncpy(debugfs_mntpt, path, sizeof(debugfs_mntpt));
diff --git a/tools/perf/util/debugfs.c b/tools/perf/util/debugfs.c
index 06b73ee..1f805fd 100644
--- a/tools/perf/util/debugfs.c
+++ b/tools/perf/util/debugfs.c
@@ -106,16 +106,14 @@ int debugfs_valid_entry(const char *path)
 	return 0;
 }
 
-/* mount the debugfs somewhere */
+/* mount the debugfs somewhere if it's not mounted */
 
-int debugfs_mount(const char *mountpoint)
+char *debugfs_mount(const char *mountpoint)
 {
-	char mountcmd[128];
-
 	/* see if it's already mounted */
 	if (debugfs_find_mountpoint()) {
 		debugfs_premounted = 1;
-		return 0;
+		return debugfs_mountpoint;
 	}
 
 	/* if not mounted and no argument */
@@ -127,13 +125,13 @@ int debugfs_mount(const char *mountpoint)
 			mountpoint = "/sys/kernel/debug";
 	}
 
+	if (mount(NULL, mountpoint, "debugfs", 0, NULL) < 0)
+		return NULL;
+
 	/* save the mountpoint */
 	strncpy(debugfs_mountpoint, mountpoint, sizeof(debugfs_mountpoint));
 
-	/* mount it */
-	snprintf(mountcmd, sizeof(mountcmd),
-		 "/bin/mount -t debugfs debugfs %s", mountpoint);
-	return system(mountcmd);
+	return debugfs_mountpoint;
 }
 
 /* umount the debugfs */
diff --git a/tools/perf/util/debugfs.h b/tools/perf/util/debugfs.h
index 3cd14f9..83a0287 100644
--- a/tools/perf/util/debugfs.h
+++ b/tools/perf/util/debugfs.h
@@ -15,7 +15,7 @@
 extern const char *debugfs_find_mountpoint(void);
 extern int debugfs_valid_mountpoint(const char *debugfs);
 extern int debugfs_valid_entry(const char *path);
-extern int debugfs_mount(const char *mountpoint);
+extern char *debugfs_mount(const char *mountpoint);
 extern int debugfs_umount(void);
 extern int debugfs_write(const char *entry, const char *value);
 extern int debugfs_read(const char *entry, char *buffer, size_t size);
