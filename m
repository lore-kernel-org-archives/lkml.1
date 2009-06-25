Return-Path: <linux-kernel-owner+w=401wt.eu-S1759386AbZFYToW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386AbZFYToW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759249AbZFYTnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:43:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:45319 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759750AbZFYTnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:43:47 -0400
Date: Thu, 25 Jun 2009 19:43:22 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter: Add PERF_EVENT_READ
Message-ID: <tip-38b200d67636a30cb8dc1508137908e7a649b5c9@git.kernel.org>
Git-Commit-ID: 38b200d67636a30cb8dc1508137908e7a649b5c9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 25 Jun 2009 19:43:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38b200d67636a30cb8dc1508137908e7a649b5c9
Gitweb:     http://git.kernel.org/tip/38b200d67636a30cb8dc1508137908e7a649b5c9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 23 Jun 2009 20:13:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Jun 2009 21:39:07 +0200

perf_counter: Add PERF_EVENT_READ

Provide a read() like event which can be used to log the
counter value at specific sites such as child->parent
folding on exit.

In order to be useful, we log the counter parent ID, not the
actual counter ID, since userspace can only relate parent
IDs to perf_counter_attr constructs.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   12 +++++++
 kernel/perf_counter.c        |   72 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index bcbf1c4..6a384f0 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -335,6 +335,18 @@ enum perf_event_type {
 	PERF_EVENT_FORK			= 7,
 
 	/*
+	 * struct {
+	 * 	struct perf_event_header	header;
+	 * 	u32				pid, tid;
+	 * 	u64				value;
+	 * 	{ u64		time_enabled; 	} && PERF_FORMAT_ENABLED
+	 * 	{ u64		time_running; 	} && PERF_FORMAT_RUNNING
+	 * 	{ u64		parent_id;	} && PERF_FORMAT_ID
+	 * };
+	 */
+	PERF_EVENT_READ			= 8,
+
+	/*
 	 * When header.misc & PERF_EVENT_MISC_OVERFLOW the event_type field
 	 * will be PERF_SAMPLE_*
 	 *
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 02994a7..a72c20e 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2624,6 +2624,66 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 }
 
 /*
+ * read event
+ */
+
+struct perf_read_event {
+	struct perf_event_header	header;
+
+	u32				pid;
+	u32				tid;
+	u64				value;
+	u64				format[3];
+};
+
+static void
+perf_counter_read_event(struct perf_counter *counter,
+			struct task_struct *task)
+{
+	struct perf_output_handle handle;
+	struct perf_read_event event = {
+		.header = {
+			.type = PERF_EVENT_READ,
+			.misc = 0,
+			.size = sizeof(event) - sizeof(event.format),
+		},
+		.pid = perf_counter_pid(counter, task),
+		.tid = perf_counter_tid(counter, task),
+		.value = atomic64_read(&counter->count),
+	};
+	int ret, i = 0;
+
+	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
+		event.header.size += sizeof(u64);
+		event.format[i++] = counter->total_time_enabled;
+	}
+
+	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
+		event.header.size += sizeof(u64);
+		event.format[i++] = counter->total_time_running;
+	}
+
+	if (counter->attr.read_format & PERF_FORMAT_ID) {
+		u64 id;
+
+		event.header.size += sizeof(u64);
+		if (counter->parent)
+			id = counter->parent->id;
+		else
+			id = counter->id;
+
+		event.format[i++] = id;
+	}
+
+	ret = perf_output_begin(&handle, counter, event.header.size, 0, 0);
+	if (ret)
+		return;
+
+	perf_output_copy(&handle, &event, event.header.size);
+	perf_output_end(&handle);
+}
+
+/*
  * fork tracking
  */
 
@@ -3985,10 +4045,13 @@ static int inherit_group(struct perf_counter *parent_counter,
 }
 
 static void sync_child_counter(struct perf_counter *child_counter,
-			       struct perf_counter *parent_counter)
+			       struct task_struct *child)
 {
+	struct perf_counter *parent_counter = child_counter->parent;
 	u64 child_val;
 
+	perf_counter_read_event(child_counter, child);
+
 	child_val = atomic64_read(&child_counter->count);
 
 	/*
@@ -4017,7 +4080,8 @@ static void sync_child_counter(struct perf_counter *child_counter,
 
 static void
 __perf_counter_exit_task(struct perf_counter *child_counter,
-			 struct perf_counter_context *child_ctx)
+			 struct perf_counter_context *child_ctx,
+			 struct task_struct *child)
 {
 	struct perf_counter *parent_counter;
 
@@ -4031,7 +4095,7 @@ __perf_counter_exit_task(struct perf_counter *child_counter,
 	 * counters need to be zapped - but otherwise linger.
 	 */
 	if (parent_counter) {
-		sync_child_counter(child_counter, parent_counter);
+		sync_child_counter(child_counter, child);
 		free_counter(child_counter);
 	}
 }
@@ -4093,7 +4157,7 @@ void perf_counter_exit_task(struct task_struct *child)
 again:
 	list_for_each_entry_safe(child_counter, tmp, &child_ctx->counter_list,
 				 list_entry)
-		__perf_counter_exit_task(child_counter, child_ctx);
+		__perf_counter_exit_task(child_counter, child_ctx, child);
 
 	/*
 	 * If the last counter was a group counter, it will have appended all
