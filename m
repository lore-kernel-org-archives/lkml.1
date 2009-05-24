Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbZEXHCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbZEXHCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 03:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZEXHCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 03:02:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:35679 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbZEXHCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 03:02:04 -0400
Date: Sun, 24 May 2009 07:01:19 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090523163012.533186528@chello.nl>
References: <20090523163012.533186528@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: Sanitize counter->mutex
Message-ID: <tip-fccc714b3148ab9741fafc1e90c3876d50df6093@git.kernel.org>
Git-Commit-ID: fccc714b3148ab9741fafc1e90c3876d50df6093
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 24 May 2009 07:01:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fccc714b3148ab9741fafc1e90c3876d50df6093
Gitweb:     http://git.kernel.org/tip/fccc714b3148ab9741fafc1e90c3876d50df6093
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 23 May 2009 18:28:56 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 23 May 2009 19:37:45 +0200

perf_counter: Sanitize counter->mutex

s/counter->mutex/counter->child_mutex/ and make sure its only
used to protect child_list.

The usage in __perf_counter_exit_task() doesn't appear to be
problematic since ctx->mutex also covers anything related to fd
tear-down.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090523163012.533186528@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    7 ++---
 kernel/perf_counter.c        |   47 +++++++++++++++++-------------------------
 2 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 23ddd29..4ab8050 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -452,9 +452,6 @@ struct perf_counter {
 	struct perf_counter_context	*ctx;
 	struct file			*filp;
 
-	struct perf_counter		*parent;
-	struct list_head		child_list;
-
 	/*
 	 * These accumulate total time (in nanoseconds) that children
 	 * counters have been enabled and running, respectively.
@@ -465,7 +462,9 @@ struct perf_counter {
 	/*
 	 * Protect attach/detach and child_list:
 	 */
-	struct mutex			mutex;
+	struct mutex			child_mutex;
+	struct list_head		child_list;
+	struct perf_counter		*parent;
 
 	int				oncpu;
 	int				cpu;
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 2f410ea..679c3b5 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -111,6 +111,10 @@ static void put_ctx(struct perf_counter_context *ctx)
 	}
 }
 
+/*
+ * Add a counter from the lists for its context.
+ * Must be called with ctx->mutex and ctx->lock held.
+ */
 static void
 list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 {
@@ -136,7 +140,7 @@ list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 
 /*
  * Remove a counter from the lists for its context.
- * Must be called with counter->mutex and ctx->mutex held.
+ * Must be called with ctx->mutex and ctx->lock held.
  */
 static void
 list_del_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
@@ -276,7 +280,7 @@ static void __perf_counter_remove_from_context(void *info)
 /*
  * Remove the counter from a task's (or a CPU's) list of counters.
  *
- * Must be called with counter->mutex and ctx->mutex held.
+ * Must be called with ctx->mutex held.
  *
  * CPU counters are removed with a smp call. For task counters we only
  * call when the task is on a CPU.
@@ -1407,11 +1411,7 @@ static int perf_release(struct inode *inode, struct file *file)
 	file->private_data = NULL;
 
 	mutex_lock(&ctx->mutex);
-	mutex_lock(&counter->mutex);
-
 	perf_counter_remove_from_context(counter);
-
-	mutex_unlock(&counter->mutex);
 	mutex_unlock(&ctx->mutex);
 
 	free_counter(counter);
@@ -1437,7 +1437,7 @@ perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 	if (counter->state == PERF_COUNTER_STATE_ERROR)
 		return 0;
 
-	mutex_lock(&counter->mutex);
+	mutex_lock(&counter->child_mutex);
 	values[0] = perf_counter_read(counter);
 	n = 1;
 	if (counter->hw_event.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
@@ -1446,7 +1446,7 @@ perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 	if (counter->hw_event.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
 		values[n++] = counter->total_time_running +
 			atomic64_read(&counter->child_total_time_running);
-	mutex_unlock(&counter->mutex);
+	mutex_unlock(&counter->child_mutex);
 
 	if (count < n * sizeof(u64))
 		return -EINVAL;
@@ -1510,11 +1510,11 @@ static void perf_counter_for_each_child(struct perf_counter *counter,
 {
 	struct perf_counter *child;
 
-	mutex_lock(&counter->mutex);
+	mutex_lock(&counter->child_mutex);
 	func(counter);
 	list_for_each_entry(child, &counter->child_list, child_list)
 		func(child);
-	mutex_unlock(&counter->mutex);
+	mutex_unlock(&counter->child_mutex);
 }
 
 static void perf_counter_for_each(struct perf_counter *counter,
@@ -1522,11 +1522,11 @@ static void perf_counter_for_each(struct perf_counter *counter,
 {
 	struct perf_counter *child;
 
-	mutex_lock(&counter->mutex);
+	mutex_lock(&counter->child_mutex);
 	perf_counter_for_each_sibling(counter, func);
 	list_for_each_entry(child, &counter->child_list, child_list)
 		perf_counter_for_each_sibling(child, func);
-	mutex_unlock(&counter->mutex);
+	mutex_unlock(&counter->child_mutex);
 }
 
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
@@ -3106,7 +3106,9 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 	if (!group_leader)
 		group_leader = counter;
 
-	mutex_init(&counter->mutex);
+	mutex_init(&counter->child_mutex);
+	INIT_LIST_HEAD(&counter->child_list);
+
 	INIT_LIST_HEAD(&counter->list_entry);
 	INIT_LIST_HEAD(&counter->event_entry);
 	INIT_LIST_HEAD(&counter->sibling_list);
@@ -3114,8 +3116,6 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 
 	mutex_init(&counter->mmap_mutex);
 
-	INIT_LIST_HEAD(&counter->child_list);
-
 	counter->cpu			= cpu;
 	counter->hw_event		= *hw_event;
 	counter->group_leader		= group_leader;
@@ -3346,10 +3346,9 @@ inherit_counter(struct perf_counter *parent_counter,
 	/*
 	 * Link this into the parent counter's child list
 	 */
-	mutex_lock(&parent_counter->mutex);
+	mutex_lock(&parent_counter->child_mutex);
 	list_add_tail(&child_counter->child_list, &parent_counter->child_list);
-
-	mutex_unlock(&parent_counter->mutex);
+	mutex_unlock(&parent_counter->child_mutex);
 
 	return child_counter;
 }
@@ -3396,9 +3395,9 @@ static void sync_child_counter(struct perf_counter *child_counter,
 	/*
 	 * Remove this counter from the parent's list
 	 */
-	mutex_lock(&parent_counter->mutex);
+	mutex_lock(&parent_counter->child_mutex);
 	list_del_init(&child_counter->child_list);
-	mutex_unlock(&parent_counter->mutex);
+	mutex_unlock(&parent_counter->child_mutex);
 
 	/*
 	 * Release the parent counter, if this was the last
@@ -3414,17 +3413,9 @@ __perf_counter_exit_task(struct task_struct *child,
 {
 	struct perf_counter *parent_counter;
 
-	/*
-	 * Protect against concurrent operations on child_counter
-	 * due its fd getting closed, etc.
-	 */
-	mutex_lock(&child_counter->mutex);
-
 	update_counter_times(child_counter);
 	list_del_counter(child_counter, child_ctx);
 
-	mutex_unlock(&child_counter->mutex);
-
 	parent_counter = child_counter->parent;
 	/*
 	 * It can happen that parent exits first, and has counters
