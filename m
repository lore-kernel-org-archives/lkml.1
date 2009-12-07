Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZLGFco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZLGFco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 00:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbZLGFcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 00:32:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:49308 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbZLGFcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 00:32:06 -0500
Date: Mon, 7 Dec 2009 05:31:32 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, peterz@infradead.org,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com,
       hirofumi@mail.parknet.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, peterz@infradead.org,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com,
       hirofumi@mail.parknet.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B1C8CC4.4050007@cn.fujitsu.com>
References: <4B1C8CC4.4050007@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_event: Eliminate raw->size
Message-ID: <tip-f48f669d42e133db839af16656fd720107ef6742@git.kernel.org>
Git-Commit-ID: f48f669d42e133db839af16656fd720107ef6742
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f48f669d42e133db839af16656fd720107ef6742
Gitweb:     http://git.kernel.org/tip/f48f669d42e133db839af16656fd720107ef6742
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Mon, 7 Dec 2009 13:04:04 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 7 Dec 2009 06:26:25 +0100

perf_event: Eliminate raw->size

raw->size is not used, this patch just cleans it up.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4B1C8CC4.4050007@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-kmem.c  |   38 +++++++-----------
 tools/perf/builtin-sched.c |   94 +++++++++++++++++++------------------------
 2 files changed, 56 insertions(+), 76 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index f84d7a3..7551a5f 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -57,11 +57,6 @@ static struct rb_root root_caller_sorted;
 static unsigned long total_requested, total_allocated;
 static unsigned long nr_allocs, nr_cross_allocs;
 
-struct raw_event_sample {
-	u32 size;
-	char data[0];
-};
-
 #define PATH_SYS_NODE	"/sys/devices/system/node"
 
 static void init_cpunode_map(void)
@@ -201,7 +196,7 @@ static void insert_caller_stat(unsigned long call_site,
 	}
 }
 
-static void process_alloc_event(struct raw_event_sample *raw,
+static void process_alloc_event(void *data,
 				struct event *event,
 				int cpu,
 				u64 timestamp __used,
@@ -214,10 +209,10 @@ static void process_alloc_event(struct raw_event_sample *raw,
 	int bytes_alloc;
 	int node1, node2;
 
-	ptr = raw_field_value(event, "ptr", raw->data);
-	call_site = raw_field_value(event, "call_site", raw->data);
-	bytes_req = raw_field_value(event, "bytes_req", raw->data);
-	bytes_alloc = raw_field_value(event, "bytes_alloc", raw->data);
+	ptr = raw_field_value(event, "ptr", data);
+	call_site = raw_field_value(event, "call_site", data);
+	bytes_req = raw_field_value(event, "bytes_req", data);
+	bytes_alloc = raw_field_value(event, "bytes_alloc", data);
 
 	insert_alloc_stat(call_site, ptr, bytes_req, bytes_alloc, cpu);
 	insert_caller_stat(call_site, bytes_req, bytes_alloc);
@@ -227,7 +222,7 @@ static void process_alloc_event(struct raw_event_sample *raw,
 
 	if (node) {
 		node1 = cpunode_map[cpu];
-		node2 = raw_field_value(event, "node", raw->data);
+		node2 = raw_field_value(event, "node", data);
 		if (node1 != node2)
 			nr_cross_allocs++;
 	}
@@ -262,7 +257,7 @@ static struct alloc_stat *search_alloc_stat(unsigned long ptr,
 	return NULL;
 }
 
-static void process_free_event(struct raw_event_sample *raw,
+static void process_free_event(void *data,
 			       struct event *event,
 			       int cpu,
 			       u64 timestamp __used,
@@ -271,7 +266,7 @@ static void process_free_event(struct raw_event_sample *raw,
 	unsigned long ptr;
 	struct alloc_stat *s_alloc, *s_caller;
 
-	ptr = raw_field_value(event, "ptr", raw->data);
+	ptr = raw_field_value(event, "ptr", data);
 
 	s_alloc = search_alloc_stat(ptr, 0, &root_alloc_stat, ptr_cmp);
 	if (!s_alloc)
@@ -289,35 +284,30 @@ static void process_free_event(struct raw_event_sample *raw,
 }
 
 static void
-process_raw_event(event_t *raw_event __used, u32 size, void *data,
+process_raw_event(event_t *raw_event __used, void *data,
 		  int cpu, u64 timestamp, struct thread *thread)
 {
-	struct raw_event_sample *raw;
 	struct event *event;
 	int type;
 
-	raw = malloc_or_die(sizeof(*raw)+size);
-	raw->size = size;
-	memcpy(raw->data, data, size);
-
-	type = trace_parse_common_type(raw->data);
+	type = trace_parse_common_type(data);
 	event = trace_find_event(type);
 
 	if (!strcmp(event->name, "kmalloc") ||
 	    !strcmp(event->name, "kmem_cache_alloc")) {
-		process_alloc_event(raw, event, cpu, timestamp, thread, 0);
+		process_alloc_event(data, event, cpu, timestamp, thread, 0);
 		return;
 	}
 
 	if (!strcmp(event->name, "kmalloc_node") ||
 	    !strcmp(event->name, "kmem_cache_alloc_node")) {
-		process_alloc_event(raw, event, cpu, timestamp, thread, 1);
+		process_alloc_event(data, event, cpu, timestamp, thread, 1);
 		return;
 	}
 
 	if (!strcmp(event->name, "kfree") ||
 	    !strcmp(event->name, "kmem_cache_free")) {
-		process_free_event(raw, event, cpu, timestamp, thread);
+		process_free_event(data, event, cpu, timestamp, thread);
 		return;
 	}
 }
@@ -349,7 +339,7 @@ static int process_sample_event(event_t *event)
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	process_raw_event(event, data.raw_size, data.raw_data, data.cpu,
+	process_raw_event(event, data.raw_data, data.cpu,
 			  data.time, thread);
 
 	return 0;
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 4655e16..19f43fa 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -628,11 +628,6 @@ static void test_calibrations(void)
 	printf("the sleep test took %Ld nsecs\n", T1-T0);
 }
 
-struct raw_event_sample {
-	u32 size;
-	char data[0];
-};
-
 #define FILL_FIELD(ptr, field, event, data)	\
 	ptr.field = (typeof(ptr.field)) raw_field_value(event, #field, data)
 
@@ -1356,7 +1351,7 @@ static void sort_lat(void)
 static struct trace_sched_handler *trace_handler;
 
 static void
-process_sched_wakeup_event(struct raw_event_sample *raw,
+process_sched_wakeup_event(void *data,
 			   struct event *event,
 			   int cpu __used,
 			   u64 timestamp __used,
@@ -1364,13 +1359,13 @@ process_sched_wakeup_event(struct raw_event_sample *raw,
 {
 	struct trace_wakeup_event wakeup_event;
 
-	FILL_COMMON_FIELDS(wakeup_event, event, raw->data);
+	FILL_COMMON_FIELDS(wakeup_event, event, data);
 
-	FILL_ARRAY(wakeup_event, comm, event, raw->data);
-	FILL_FIELD(wakeup_event, pid, event, raw->data);
-	FILL_FIELD(wakeup_event, prio, event, raw->data);
-	FILL_FIELD(wakeup_event, success, event, raw->data);
-	FILL_FIELD(wakeup_event, cpu, event, raw->data);
+	FILL_ARRAY(wakeup_event, comm, event, data);
+	FILL_FIELD(wakeup_event, pid, event, data);
+	FILL_FIELD(wakeup_event, prio, event, data);
+	FILL_FIELD(wakeup_event, success, event, data);
+	FILL_FIELD(wakeup_event, cpu, event, data);
 
 	if (trace_handler->wakeup_event)
 		trace_handler->wakeup_event(&wakeup_event, event, cpu, timestamp, thread);
@@ -1469,7 +1464,7 @@ map_switch_event(struct trace_switch_event *switch_event,
 
 
 static void
-process_sched_switch_event(struct raw_event_sample *raw,
+process_sched_switch_event(void *data,
 			   struct event *event,
 			   int this_cpu,
 			   u64 timestamp __used,
@@ -1477,15 +1472,15 @@ process_sched_switch_event(struct raw_event_sample *raw,
 {
 	struct trace_switch_event switch_event;
 
-	FILL_COMMON_FIELDS(switch_event, event, raw->data);
+	FILL_COMMON_FIELDS(switch_event, event, data);
 
-	FILL_ARRAY(switch_event, prev_comm, event, raw->data);
-	FILL_FIELD(switch_event, prev_pid, event, raw->data);
-	FILL_FIELD(switch_event, prev_prio, event, raw->data);
-	FILL_FIELD(switch_event, prev_state, event, raw->data);
-	FILL_ARRAY(switch_event, next_comm, event, raw->data);
-	FILL_FIELD(switch_event, next_pid, event, raw->data);
-	FILL_FIELD(switch_event, next_prio, event, raw->data);
+	FILL_ARRAY(switch_event, prev_comm, event, data);
+	FILL_FIELD(switch_event, prev_pid, event, data);
+	FILL_FIELD(switch_event, prev_prio, event, data);
+	FILL_FIELD(switch_event, prev_state, event, data);
+	FILL_ARRAY(switch_event, next_comm, event, data);
+	FILL_FIELD(switch_event, next_pid, event, data);
+	FILL_FIELD(switch_event, next_prio, event, data);
 
 	if (curr_pid[this_cpu] != (u32)-1) {
 		/*
@@ -1502,7 +1497,7 @@ process_sched_switch_event(struct raw_event_sample *raw,
 }
 
 static void
-process_sched_runtime_event(struct raw_event_sample *raw,
+process_sched_runtime_event(void *data,
 			   struct event *event,
 			   int cpu __used,
 			   u64 timestamp __used,
@@ -1510,17 +1505,17 @@ process_sched_runtime_event(struct raw_event_sample *raw,
 {
 	struct trace_runtime_event runtime_event;
 
-	FILL_ARRAY(runtime_event, comm, event, raw->data);
-	FILL_FIELD(runtime_event, pid, event, raw->data);
-	FILL_FIELD(runtime_event, runtime, event, raw->data);
-	FILL_FIELD(runtime_event, vruntime, event, raw->data);
+	FILL_ARRAY(runtime_event, comm, event, data);
+	FILL_FIELD(runtime_event, pid, event, data);
+	FILL_FIELD(runtime_event, runtime, event, data);
+	FILL_FIELD(runtime_event, vruntime, event, data);
 
 	if (trace_handler->runtime_event)
 		trace_handler->runtime_event(&runtime_event, event, cpu, timestamp, thread);
 }
 
 static void
-process_sched_fork_event(struct raw_event_sample *raw,
+process_sched_fork_event(void *data,
 			 struct event *event,
 			 int cpu __used,
 			 u64 timestamp __used,
@@ -1528,12 +1523,12 @@ process_sched_fork_event(struct raw_event_sample *raw,
 {
 	struct trace_fork_event fork_event;
 
-	FILL_COMMON_FIELDS(fork_event, event, raw->data);
+	FILL_COMMON_FIELDS(fork_event, event, data);
 
-	FILL_ARRAY(fork_event, parent_comm, event, raw->data);
-	FILL_FIELD(fork_event, parent_pid, event, raw->data);
-	FILL_ARRAY(fork_event, child_comm, event, raw->data);
-	FILL_FIELD(fork_event, child_pid, event, raw->data);
+	FILL_ARRAY(fork_event, parent_comm, event, data);
+	FILL_FIELD(fork_event, parent_pid, event, data);
+	FILL_ARRAY(fork_event, child_comm, event, data);
+	FILL_FIELD(fork_event, child_pid, event, data);
 
 	if (trace_handler->fork_event)
 		trace_handler->fork_event(&fork_event, event, cpu, timestamp, thread);
@@ -1550,7 +1545,7 @@ process_sched_exit_event(struct event *event,
 }
 
 static void
-process_sched_migrate_task_event(struct raw_event_sample *raw,
+process_sched_migrate_task_event(void *data,
 			   struct event *event,
 			   int cpu __used,
 			   u64 timestamp __used,
@@ -1558,46 +1553,42 @@ process_sched_migrate_task_event(struct raw_event_sample *raw,
 {
 	struct trace_migrate_task_event migrate_task_event;
 
-	FILL_COMMON_FIELDS(migrate_task_event, event, raw->data);
+	FILL_COMMON_FIELDS(migrate_task_event, event, data);
 
-	FILL_ARRAY(migrate_task_event, comm, event, raw->data);
-	FILL_FIELD(migrate_task_event, pid, event, raw->data);
-	FILL_FIELD(migrate_task_event, prio, event, raw->data);
-	FILL_FIELD(migrate_task_event, cpu, event, raw->data);
+	FILL_ARRAY(migrate_task_event, comm, event, data);
+	FILL_FIELD(migrate_task_event, pid, event, data);
+	FILL_FIELD(migrate_task_event, prio, event, data);
+	FILL_FIELD(migrate_task_event, cpu, event, data);
 
 	if (trace_handler->migrate_task_event)
 		trace_handler->migrate_task_event(&migrate_task_event, event, cpu, timestamp, thread);
 }
 
 static void
-process_raw_event(event_t *raw_event __used, u32 size, void *data,
+process_raw_event(event_t *raw_event __used, void *data,
 		  int cpu, u64 timestamp, struct thread *thread)
 {
-	struct raw_event_sample *raw;
 	struct event *event;
 	int type;
 
-	raw = malloc_or_die(sizeof(*raw)+size);
-	raw->size = size;
-	memcpy(raw->data, data, size);
 
-	type = trace_parse_common_type(raw->data);
+	type = trace_parse_common_type(data);
 	event = trace_find_event(type);
 
 	if (!strcmp(event->name, "sched_switch"))
-		process_sched_switch_event(raw, event, cpu, timestamp, thread);
+		process_sched_switch_event(data, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_stat_runtime"))
-		process_sched_runtime_event(raw, event, cpu, timestamp, thread);
+		process_sched_runtime_event(data, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_wakeup"))
-		process_sched_wakeup_event(raw, event, cpu, timestamp, thread);
+		process_sched_wakeup_event(data, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_wakeup_new"))
-		process_sched_wakeup_event(raw, event, cpu, timestamp, thread);
+		process_sched_wakeup_event(data, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_process_fork"))
-		process_sched_fork_event(raw, event, cpu, timestamp, thread);
+		process_sched_fork_event(data, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_process_exit"))
 		process_sched_exit_event(event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_migrate_task"))
-		process_sched_migrate_task_event(raw, event, cpu, timestamp, thread);
+		process_sched_migrate_task_event(data, event, cpu, timestamp, thread);
 }
 
 static int process_sample_event(event_t *event)
@@ -1633,8 +1624,7 @@ static int process_sample_event(event_t *event)
 	if (profile_cpu != -1 && profile_cpu != (int)data.cpu)
 		return 0;
 
-	process_raw_event(event, data.raw_size, data.raw_data, data.cpu,
-			  data.time, thread);
+	process_raw_event(event, data.raw_data, data.cpu, data.time, thread);
 
 	return 0;
 }
