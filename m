Return-Path: <linux-kernel-owner+w=401wt.eu-S934518AbZDHRDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934518AbZDHRDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934410AbZDHQ76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:59:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:39172 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932527AbZDHQ7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:59:53 -0400
Date: Wed, 8 Apr 2009 16:58:33 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090408130409.127422406@chello.nl>
References: <20090408130409.127422406@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: track task-comm data
Message-ID: <tip-e278f3cdbd9cfb9c9e7e0d0b3a2844ceed84197c@git.kernel.org>
Git-Commit-ID: e278f3cdbd9cfb9c9e7e0d0b3a2844ceed84197c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 16:58:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e278f3cdbd9cfb9c9e7e0d0b3a2844ceed84197c
Gitweb:     http://git.kernel.org/tip/e278f3cdbd9cfb9c9e7e0d0b3a2844ceed84197c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 8 Apr 2009 15:01:30 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 18:53:30 +0200

perf_counter: track task-comm data

Similar to the mmap data stream, add one that tracks the task COMM field,
so that the userspace reporting knows what to call a task.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090408130409.127422406@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 fs/exec.c                    |    1 +
 include/linux/perf_counter.h |   15 ++++++-
 kernel/perf_counter.c        |   93 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index e015c0b..bf47ed0 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -951,6 +951,7 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 	task_lock(tsk);
 	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
 	task_unlock(tsk);
+	perf_counter_comm(tsk);
 }
 
 int flush_old_exec(struct linux_binprm * bprm)
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 8bf764f..fed9216 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -142,8 +142,9 @@ struct perf_counter_hw_event {
 				exclude_idle   :  1, /* don't count when idle */
 				mmap           :  1, /* include mmap data     */
 				munmap         :  1, /* include munmap data   */
+				comm	       :  1, /* include comm data     */
 
-				__reserved_1   : 53;
+				__reserved_1   : 52;
 
 	__u32			extra_config_len;
 	__u32			wakeup_events;	/* wakeup every n events */
@@ -231,6 +232,16 @@ enum perf_event_type {
 	PERF_EVENT_MUNMAP		= 2,
 
 	/*
+	 * struct {
+	 * 	struct perf_event_header	header;
+	 *
+	 * 	u32				pid, tid;
+	 * 	char				comm[];
+	 * };
+	 */
+	PERF_EVENT_COMM			= 3,
+
+	/*
 	 * When header.misc & PERF_EVENT_MISC_OVERFLOW the event_type field
 	 * will be PERF_RECORD_*
 	 *
@@ -545,6 +556,8 @@ extern void perf_counter_mmap(unsigned long addr, unsigned long len,
 extern void perf_counter_munmap(unsigned long addr, unsigned long len,
 				unsigned long pgoff, struct file *file);
 
+extern void perf_counter_comm(struct task_struct *tsk);
+
 #define MAX_STACK_DEPTH		255
 
 struct perf_callchain_entry {
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index bf12df6..2d4aebb 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1917,6 +1917,99 @@ static void perf_counter_output(struct perf_counter *counter,
 }
 
 /*
+ * comm tracking
+ */
+
+struct perf_comm_event {
+	struct task_struct 	*task;
+	char 			*comm;
+	int			comm_size;
+
+	struct {
+		struct perf_event_header	header;
+
+		u32				pid;
+		u32				tid;
+	} event;
+};
+
+static void perf_counter_comm_output(struct perf_counter *counter,
+				     struct perf_comm_event *comm_event)
+{
+	struct perf_output_handle handle;
+	int size = comm_event->event.header.size;
+	int ret = perf_output_begin(&handle, counter, size, 0, 0);
+
+	if (ret)
+		return;
+
+	perf_output_put(&handle, comm_event->event);
+	perf_output_copy(&handle, comm_event->comm,
+				   comm_event->comm_size);
+	perf_output_end(&handle);
+}
+
+static int perf_counter_comm_match(struct perf_counter *counter,
+				   struct perf_comm_event *comm_event)
+{
+	if (counter->hw_event.comm &&
+	    comm_event->event.header.type == PERF_EVENT_COMM)
+		return 1;
+
+	return 0;
+}
+
+static void perf_counter_comm_ctx(struct perf_counter_context *ctx,
+				  struct perf_comm_event *comm_event)
+{
+	struct perf_counter *counter;
+
+	if (system_state != SYSTEM_RUNNING || list_empty(&ctx->event_list))
+		return;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(counter, &ctx->event_list, event_entry) {
+		if (perf_counter_comm_match(counter, comm_event))
+			perf_counter_comm_output(counter, comm_event);
+	}
+	rcu_read_unlock();
+}
+
+static void perf_counter_comm_event(struct perf_comm_event *comm_event)
+{
+	struct perf_cpu_context *cpuctx;
+	unsigned int size;
+	char *comm = comm_event->task->comm;
+
+	size = ALIGN(strlen(comm), sizeof(u64));
+
+	comm_event->comm = comm;
+	comm_event->comm_size = size;
+
+	comm_event->event.header.size = sizeof(comm_event->event) + size;
+
+	cpuctx = &get_cpu_var(perf_cpu_context);
+	perf_counter_comm_ctx(&cpuctx->ctx, comm_event);
+	put_cpu_var(perf_cpu_context);
+
+	perf_counter_comm_ctx(&current->perf_counter_ctx, comm_event);
+}
+
+void perf_counter_comm(struct task_struct *task)
+{
+	struct perf_comm_event comm_event = {
+		.task	= task,
+		.event  = {
+			.header = { .type = PERF_EVENT_COMM, },
+			.pid	= task->group_leader->pid,
+			.tid	= task->pid,
+		},
+	};
+
+	perf_counter_comm_event(&comm_event);
+}
+
+/*
  * mmap tracking
  */
 
