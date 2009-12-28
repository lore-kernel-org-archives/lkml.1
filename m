Return-Path: <linux-kernel-owner+w=401wt.eu-S1751977AbZL1ItI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbZL1ItI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:49:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbZL1ItH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:49:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63245 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbZL1ItF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:49:05 -0500
Message-ID: <4B387090.7080407@cn.fujitsu.com>
Date: Mon, 28 Dec 2009 16:47:12 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH v2 1/3] perf tools: mount debugfs automatically
References: <4B383DE3.3070702@cn.fujitsu.com> <20091228074426.GA20039@elte.hu> <4B386615.7000207@cn.fujitsu.com> <20091228080615.GC28652@elte.hu>
In-Reply-To: <20091228080615.GC28652@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mount debugfs filesystem under '/sys/kernel/debug' if it's not mounted

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
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
-- 
1.6.1.2


