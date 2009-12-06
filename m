Return-Path: <linux-kernel-owner+w=401wt.eu-S933678AbZLFK7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933678AbZLFK7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 05:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933659AbZLFK7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 05:59:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64134 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933658AbZLFK7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 05:59:05 -0500
Message-ID: <4B1B8E0E.3040007@cn.fujitsu.com>
Date: Sun, 06 Dec 2009 18:57:18 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf/sched: fix for getting task's execute time
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, we get task's execute time by reading
"/proc/<pid>/sched" file, it's wrong if the task is created
by pthread_create(), because every thread task has same pid.
So, the correct way is reading "/proc/<ppid>/task/<tid>/sched"
file.

This patch also remove redundant include files since <sys/types.h>
is included in "perf.h"

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 tools/perf/builtin-sched.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 26b782f..b2e910e 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -13,7 +13,6 @@
 #include "util/debug.h"
 #include "util/data_map.h"
 
-#include <sys/types.h>
 #include <sys/prctl.h>
 
 #include <semaphore.h>
@@ -416,7 +415,7 @@ static u64 get_cpu_usage_nsec_parent(void)
 
 static u64 get_cpu_usage_nsec_self(void)
 {
-	char filename [] = "/proc/1234567890/sched";
+	char filename [] = "/proc/1234567890/task/1234567890/sched";
 	unsigned long msecs, nsecs;
 	char *line = NULL;
 	u64 total = 0;
@@ -425,7 +424,9 @@ static u64 get_cpu_usage_nsec_self(void)
 	FILE *file;
 	int ret;
 
-	sprintf(filename, "/proc/%d/sched", getpid());
+	sprintf(filename, "/proc/%d/task/%d/sched", getpid(),
+		(pid_t)syscall(SYS_gettid));
+
 	file = fopen(filename, "r");
 	BUG_ON(!file);
 
-- 
1.6.1.2


