Return-Path: <linux-kernel-owner+w=401wt.eu-S1751974AbZL1IuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbZL1IuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZL1IuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:50:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63648 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbZL1IuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:50:21 -0500
Message-ID: <4B3870DE.7090500@cn.fujitsu.com>
Date: Mon, 28 Dec 2009 16:48:30 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 2/3] perf trace: cleanup find_debugfs()
References: <4B383DE3.3070702@cn.fujitsu.com> <20091228074426.GA20039@elte.hu> <4B386615.7000207@cn.fujitsu.com> <20091228080615.GC28652@elte.hu> <4B387090.7080407@cn.fujitsu.com>
In-Reply-To: <4B387090.7080407@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant code for 'perf trace'

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
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
index cace355..5dd5c81 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -37,6 +37,7 @@
 
 #include "../perf.h"
 #include "trace-event.h"
+#include "debugfs.h"
 
 #define VERSION "0.5"
 
@@ -101,32 +102,12 @@ void *malloc_or_die(unsigned int size)
 
 static const char *find_debugfs(void)
 {
-	static char debugfs[MAX_PATH+1];
-	static int debugfs_found;
-	char type[100];
-	FILE *fp;
-
-	if (debugfs_found)
-		return debugfs;
-
-	if ((fp = fopen("/proc/mounts","r")) == NULL)
-		die("Can't open /proc/mounts for read");
-
-	while (fscanf(fp, "%*s %"
-		      STR(MAX_PATH)
-		      "s %99s %*s %*d %*d\n",
-		      debugfs, type) == 2) {
-		if (strcmp(type, "debugfs") == 0)
-			break;
-	}
-	fclose(fp);
-
-	if (strcmp(type, "debugfs") != 0)
-		die("debugfs not mounted, please mount");
+	const char *path = debugfs_mount(NULL);
 
-	debugfs_found = 1;
+	if (!path)
+		die("Your kernel not support debugfs filesystem");
 
-	return debugfs;
+	return path;
 }
 
 /*
-- 
1.6.1.2


