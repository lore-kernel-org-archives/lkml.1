Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbZF3IqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbZF3IqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 04:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZF3IqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 04:46:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55477 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbZF3IqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 04:46:15 -0400
Message-ID: <4A49D12A.9040901@cn.fujitsu.com>
Date: Tue, 30 Jun 2009 16:47:38 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: use hash table to simulate the sparse array
References: <4A3F2E38.7030604@cn.fujitsu.com>
In-Reply-To: <4A3F2E38.7030604@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> 
> Subject: [PATCH] tracing: rewrite trace_save_cmdline()
> 
> I found the sparse array map_pid_to_cmdline[PID_MAX_DEFAULT+1]
> wastes too much memory, so I remove it.
> 
> The old FIFO algorithm is replaced with a new one:
> Open address hash table with double hash + tick-LRU.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---

This patch reduces the memory usage.(save 128K memory in kernel)
But it's too complicated, and it changes the original algorithm.

This new patch does NOT change the original algorithm,
but it uses a hash table to simulate the sparse array.

---------------

Subject: [PATCH] tracing: use hash table to simulate the sparse array

I found the sparse array map_pid_to_cmdline[PID_MAX_DEFAULT+1]
wastes too much memory, so I remove it.

A hash table is added to simulate the sparse array. And
map_pid_to_cmdline and map_cmdline_to_pid become light functions.

map_pid_to_cmdline[pid] ==> map_pid_to_cmdline(pid)
map_cmdline_to_pid[idx] ==> map_cmdline_to_pid(idx)

[Impact: save about 127k memory]

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3aa0a0d..3526b9c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -36,6 +36,7 @@
 #include <linux/poll.h>
 #include <linux/gfp.h>
 #include <linux/fs.h>
+#include <linux/hash.h>
 
 #include "trace.h"
 #include "trace_output.h"
@@ -648,10 +649,47 @@ void tracing_reset_current_online_cpus(void)
 	tracing_reset_online_cpus(&global_trace);
 }
 
-#define SAVED_CMDLINES 128
+#define SAVED_CMDLINES_SHIFT 7
+#define SAVED_CMDLINES (1 << 7)
 #define NO_CMDLINE_MAP UINT_MAX
-static unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
-static unsigned map_cmdline_to_pid[SAVED_CMDLINES];
+
+struct cmdline_index {
+	struct hlist_node node;
+	unsigned int pid;
+};
+
+struct hlist_head map_head[SAVED_CMDLINES];
+struct cmdline_index indexes[SAVED_CMDLINES];
+
+static unsigned int map_pid_to_cmdline(unsigned int pid)
+{
+	struct cmdline_index *index;
+	struct hlist_node *n;
+	unsigned int hash = hash_32(pid, SAVED_CMDLINES_SHIFT);
+
+	hlist_for_each_entry(index, n, &map_head[hash], node) {
+		if (index->pid == pid)
+			return index - indexes;
+	}
+
+	return NO_CMDLINE_MAP;
+}
+
+static unsigned int map_cmdline_to_pid(unsigned int idx)
+{
+	return indexes[idx].pid;
+}
+
+static void do_map_cmdline_index(unsigned int idx, unsigned int pid)
+{
+	unsigned int hash = hash_32(pid, SAVED_CMDLINES_SHIFT);
+
+	if (map_cmdline_to_pid(idx) != NO_CMDLINE_MAP)
+		hlist_del(&indexes[idx].node);
+	indexes[idx].pid = pid;
+	hlist_add_head(&indexes[idx].node, &map_head[hash]);
+}
+
 static char saved_cmdlines[SAVED_CMDLINES][TASK_COMM_LEN];
 static int cmdline_idx;
 static raw_spinlock_t trace_cmdline_lock = __RAW_SPIN_LOCK_UNLOCKED;
@@ -661,8 +699,7 @@ static atomic_t trace_record_cmdline_disabled __read_mostly;
 
 static void trace_init_cmdlines(void)
 {
-	memset(&map_pid_to_cmdline, NO_CMDLINE_MAP, sizeof(map_pid_to_cmdline));
-	memset(&map_cmdline_to_pid, NO_CMDLINE_MAP, sizeof(map_cmdline_to_pid));
+	memset(&indexes, NO_CMDLINE_MAP, sizeof(indexes));
 	cmdline_idx = 0;
 }
 
@@ -754,9 +791,9 @@ void trace_stop_cmdline_recording(void);
 
 static void trace_save_cmdline(struct task_struct *tsk)
 {
-	unsigned pid, idx;
+	unsigned int idx;
 
-	if (!tsk->pid || unlikely(tsk->pid > PID_MAX_DEFAULT))
+	if (!tsk->pid)
 		return;
 
 	/*
@@ -768,22 +805,11 @@ static void trace_save_cmdline(struct task_struct *tsk)
 	if (!__raw_spin_trylock(&trace_cmdline_lock))
 		return;
 
-	idx = map_pid_to_cmdline[tsk->pid];
+	idx = map_pid_to_cmdline(tsk->pid);
 	if (idx == NO_CMDLINE_MAP) {
 		idx = (cmdline_idx + 1) % SAVED_CMDLINES;
 
-		/*
-		 * Check whether the cmdline buffer at idx has a pid
-		 * mapped. We are going to overwrite that entry so we
-		 * need to clear the map_pid_to_cmdline. Otherwise we
-		 * would read the new comm for the old pid.
-		 */
-		pid = map_cmdline_to_pid[idx];
-		if (pid != NO_CMDLINE_MAP)
-			map_pid_to_cmdline[pid] = NO_CMDLINE_MAP;
-
-		map_cmdline_to_pid[idx] = tsk->pid;
-		map_pid_to_cmdline[tsk->pid] = idx;
+		do_map_cmdline_index(idx, tsk->pid);
 
 		cmdline_idx = idx;
 	}
@@ -802,14 +828,9 @@ void trace_find_cmdline(int pid, char comm[])
 		return;
 	}
 
-	if (pid > PID_MAX_DEFAULT) {
-		strcpy(comm, "<...>");
-		return;
-	}
-
 	preempt_disable();
 	__raw_spin_lock(&trace_cmdline_lock);
-	map = map_pid_to_cmdline[pid];
+	map = map_pid_to_cmdline(pid);
 	if (map != NO_CMDLINE_MAP)
 		strcpy(comm, saved_cmdlines[map]);
 	else
@@ -2458,7 +2479,7 @@ tracing_saved_cmdlines_read(struct file *file, char __user *ubuf,
 	for (i = 0; i < SAVED_CMDLINES; i++) {
 		int r;
 
-		pid = map_cmdline_to_pid[i];
+		pid = map_cmdline_to_pid(i);
 		if (pid == -1 || pid == NO_CMDLINE_MAP)
 			continue;
 






