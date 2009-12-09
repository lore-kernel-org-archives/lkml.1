Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbZLIKEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbZLIKEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 05:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZLIKEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 05:04:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:48301 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbZLIKED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 05:04:03 -0500
Date: Wed, 9 Dec 2009 10:03:32 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, edwintorok@gmail.com,
       xiaoguangrong@cn.fujitsu.com, ericxiao.gr@gmail.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       edwintorok@gmail.com, xiaoguangrong@cn.fujitsu.com,
       ericxiao.gr@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B1F7322.80103@cn.fujitsu.com>
References: <4B1F7322.80103@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf sched: Fix for getting task's execution time
Message-ID: <tip-c0c9e72150c07b4a6766cd24a6f685ec2dc9c343@git.kernel.org>
Git-Commit-ID: c0c9e72150c07b4a6766cd24a6f685ec2dc9c343
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0c9e72150c07b4a6766cd24a6f685ec2dc9c343
Gitweb:     http://git.kernel.org/tip/c0c9e72150c07b4a6766cd24a6f685ec2dc9c343
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Wed, 9 Dec 2009 17:51:30 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:59:12 +0100

perf sched: Fix for getting task's execution time

In current code, task's execute time is got by reading
'/proc/<pid>/sched' file, it's wrong if the task is created
by pthread_create(), because every thread task has same pid.

This way also has two demerits:

 1: 'perf sched replay' can't work if the kernel is not
    compiled with the 'CONFIG_SCHED_DEBUG' option

 2: perf tool should depend on proc file system

So, this patch uses PERF_COUNT_SW_TASK_CLOCK to get task's
execution time instead of reading /proc file.

Changelog v2 -> v3:
use PERF_COUNT_SW_TASK_CLOCK instead of rusage() as Ingo's
suggestion

Reported-by: Torok Edwin <edwintorok@gmail.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Xiao Guangrong <ericxiao.gr@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <4B1F7322.80103@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-sched.c |   55 +++++++++++++++++++++----------------------
 1 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 19f43fa..b12b23a 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -13,7 +13,6 @@
 #include "util/debug.h"
 #include "util/data_map.h"
 
-#include <sys/types.h>
 #include <sys/prctl.h>
 
 #include <semaphore.h>
@@ -414,34 +413,33 @@ static u64 get_cpu_usage_nsec_parent(void)
 	return sum;
 }
 
-static u64 get_cpu_usage_nsec_self(void)
+static int self_open_counters(void)
 {
-	char filename [] = "/proc/1234567890/sched";
-	unsigned long msecs, nsecs;
-	char *line = NULL;
-	u64 total = 0;
-	size_t len = 0;
-	ssize_t chars;
-	FILE *file;
-	int ret;
+	struct perf_event_attr attr;
+	int fd;
 
-	sprintf(filename, "/proc/%d/sched", getpid());
-	file = fopen(filename, "r");
-	BUG_ON(!file);
+	memset(&attr, 0, sizeof(attr));
 
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
+	attr.type = PERF_TYPE_SOFTWARE;
+	attr.config = PERF_COUNT_SW_TASK_CLOCK;
 
-	return total;
+	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
+
+	if (fd < 0)
+		die("Error: sys_perf_event_open() syscall returned"
+		    "with %d (%s)\n", fd, strerror(errno));
+	return fd;
+}
+
+static u64 get_cpu_usage_nsec_self(int fd)
+{
+	u64 runtime;
+	int ret;
+
+	ret = read(fd, &runtime, sizeof(runtime));
+	BUG_ON(ret != sizeof(runtime));
+
+	return runtime;
 }
 
 static void *thread_func(void *ctx)
@@ -450,9 +448,11 @@ static void *thread_func(void *ctx)
 	u64 cpu_usage_0, cpu_usage_1;
 	unsigned long i, ret;
 	char comm2[22];
+	int fd;
 
 	sprintf(comm2, ":%s", this_task->comm);
 	prctl(PR_SET_NAME, comm2);
+	fd = self_open_counters();
 
 again:
 	ret = sem_post(&this_task->ready_for_work);
@@ -462,16 +462,15 @@ again:
 	ret = pthread_mutex_unlock(&start_work_mutex);
 	BUG_ON(ret);
 
-	cpu_usage_0 = get_cpu_usage_nsec_self();
+	cpu_usage_0 = get_cpu_usage_nsec_self(fd);
 
 	for (i = 0; i < this_task->nr_events; i++) {
 		this_task->curr_event = i;
 		process_sched_event(this_task, this_task->atoms[i]);
 	}
 
-	cpu_usage_1 = get_cpu_usage_nsec_self();
+	cpu_usage_1 = get_cpu_usage_nsec_self(fd);
 	this_task->cpu_usage = cpu_usage_1 - cpu_usage_0;
-
 	ret = sem_post(&this_task->work_done_sem);
 	BUG_ON(ret);
 
