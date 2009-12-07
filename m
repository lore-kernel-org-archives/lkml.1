Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbZLGHWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbZLGHWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbZLGHWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:22:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54894 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757963AbZLGHWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:22:10 -0500
Message-ID: <4B1CACC4.3030709@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 15:20:36 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Xiao Guangrong <ericxiao.gr@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] perf/sched: fix for getting task's execution time
References: <4B1B8E0E.3040007@cn.fujitsu.com>	 <1260097512.7818.341.camel@laptop> <1260097609.7818.349.camel@laptop> <4B1BE588.8020608@gmail.com>
In-Reply-To: <4B1BE588.8020608@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, task's execute time is got by reading
'/proc/<pid>/sched' file, it's wrong if the task is created
by pthread_create(), because every thread task has same pid.

This way also has two demerits:

1: 'perf sched replay' can't work if the kernel not compile with
   'CONFIG_SCHED_DEBUG' option
2: perf tool should depend on proc file system

So, this patch call getrusage() to get task's execution time instead
of reading /proc file

Reported-by: Török Edwin <edwintorok@gmail.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 tools/perf/builtin-sched.c |   46 ++++++++++++++-----------------------------
 1 files changed, 15 insertions(+), 31 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 19f43fa..bd57994 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -13,7 +13,6 @@
 #include "util/debug.h"
 #include "util/data_map.h"
 
-#include <sys/types.h>
 #include <sys/prctl.h>
 
 #include <semaphore.h>
@@ -399,49 +398,34 @@ process_sched_event(struct task_desc *this_task __used, struct sched_atom *atom)
 	}
 }
 
+static u64 get_sum_time(struct rusage *ru)
+{
+	u64 sum;
+
+	sum =  ru->ru_utime.tv_sec*1e9 + ru->ru_utime.tv_usec*1e3;
+	sum += ru->ru_stime.tv_sec*1e9 + ru->ru_stime.tv_usec*1e3;
+	return sum;
+}
+
 static u64 get_cpu_usage_nsec_parent(void)
 {
 	struct rusage ru;
-	u64 sum;
 	int err;
 
 	err = getrusage(RUSAGE_SELF, &ru);
 	BUG_ON(err);
 
-	sum =  ru.ru_utime.tv_sec*1e9 + ru.ru_utime.tv_usec*1e3;
-	sum += ru.ru_stime.tv_sec*1e9 + ru.ru_stime.tv_usec*1e3;
-
-	return sum;
+	return get_sum_time(&ru);
 }
 
 static u64 get_cpu_usage_nsec_self(void)
 {
-	char filename [] = "/proc/1234567890/sched";
-	unsigned long msecs, nsecs;
-	char *line = NULL;
-	u64 total = 0;
-	size_t len = 0;
-	ssize_t chars;
-	FILE *file;
-	int ret;
-
-	sprintf(filename, "/proc/%d/sched", getpid());
-	file = fopen(filename, "r");
-	BUG_ON(!file);
-
-	while ((chars = getline(&line, &len, file)) != -1) {
-		ret = sscanf(line, "se.sum_exec_runtime : %ld.%06ld\n",
-			&msecs, &nsecs);
-		if (ret == 2) {
-			total = msecs*1e6 + nsecs;
-			break;
-		}
-	}
-	if (line)
-		free(line);
-	fclose(file);
+	struct rusage ru;
+	int err;
 
-	return total;
+	err = getrusage(RUSAGE_THREAD, &ru);
+	BUG_ON(err);
+	return get_sum_time(&ru);
 }
 
 static void *thread_func(void *ctx)
-- 
1.6.1.2

