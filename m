Return-Path: <linux-kernel-owner+w=401wt.eu-S1751914AbZIYKZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbZIYKZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 06:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbZIYKZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 06:25:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:49852 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbZIYKZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 06:25:36 -0400
Date: Fri, 25 Sep 2009 12:25:56 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC PATCH] perf_core: provide a kernel-internal interface to get
 to performance counters
Message-ID: <20090925122556.2f8bd939@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5db5cd76f3c16c9f6093f54d1ccfb97d04b9a1ca Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 25 Sep 2009 12:20:57 +0200
Subject: [PATCH] perf_core: provide a kernel-internal interface to get to performance counters

There are reasons for kernel code to ask for, and use, performance counters.
For example, in CPU freq governors this tends to be a good idea, but there
are other examples possible as well of course.

This patch adds the needed bits to do enable this functionality; they have been
tested in an experimental cpufreq driver that I'm working on, and the changes
are all that I needed to access counters properly.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/perf_event.h |    3 ++
 kernel/perf_event.c        |   71 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 73 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3a9d36d..5890330 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -733,6 +733,9 @@ extern int hw_perf_group_sched_in(struct perf_event *group_leader,
 	       struct perf_cpu_context *cpuctx,
 	       struct perf_event_context *ctx, int cpu);
 extern void perf_event_update_userpage(struct perf_event *event);
+extern int perf_event_release_kernel(struct perf_event *event);
+extern struct perf_event *perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu);
+extern u64 perf_event_read_value(struct perf_event *event);
 
 struct perf_sample_data {
 	u64				type;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 76ac4db..185f45a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1734,6 +1734,26 @@ static int perf_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+int perf_event_release_kernel(struct perf_event *event)
+{
+	struct perf_event_context *ctx = event->ctx;
+
+	WARN_ON_ONCE(ctx->parent_ctx);
+	mutex_lock(&ctx->mutex);
+	perf_event_remove_from_context(event);
+	mutex_unlock(&ctx->mutex);
+
+	mutex_lock(&event->owner->perf_event_mutex);
+	list_del_init(&event->owner_entry);
+	mutex_unlock(&event->owner->perf_event_mutex);
+	put_task_struct(event->owner);
+
+	free_event(event);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(perf_event_release_kernel);
+
 static int perf_event_read_size(struct perf_event *event)
 {
 	int entry = sizeof(u64); /* value */
@@ -1759,7 +1779,7 @@ static int perf_event_read_size(struct perf_event *event)
 	return size;
 }
 
-static u64 perf_event_read_value(struct perf_event *event)
+u64 perf_event_read_value(struct perf_event *event)
 {
 	struct perf_event *child;
 	u64 total = 0;
@@ -1770,6 +1790,7 @@ static u64 perf_event_read_value(struct perf_event *event)
 
 	return total;
 }
+EXPORT_SYMBOL_GPL(perf_event_read_value);
 
 static int perf_event_read_entry(struct perf_event *event,
 				   u64 read_format, char __user *buf)
@@ -4463,6 +4484,54 @@ err_put_context:
 }
 
 /*
+ * perf_event_create_kernel_counter
+ * MUST be called from a kernel thread.
+ */
+struct perf_event *
+perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu)
+{
+	struct perf_event *event;
+	struct perf_event_context *ctx;
+	int err;
+
+	/*
+	 * Get the target context (task or percpu):
+	 */
+
+	ctx = find_get_context(0, cpu);
+	if (IS_ERR(ctx))
+		return NULL ;
+
+	event = perf_event_alloc(attr, cpu, ctx, NULL,
+				     NULL, GFP_KERNEL);
+	err = PTR_ERR(event);
+	if (IS_ERR(event))
+		goto err_put_context;
+
+	event->filp = NULL;
+	WARN_ON_ONCE(ctx->parent_ctx);
+	mutex_lock(&ctx->mutex);
+	perf_install_in_context(ctx, event, cpu);
+	++ctx->generation;
+	mutex_unlock(&ctx->mutex);
+
+	event->owner = current;
+	get_task_struct(current);
+	mutex_lock(&current->perf_event_mutex);
+	list_add_tail(&event->owner_entry, &current->perf_event_list);
+	mutex_unlock(&current->perf_event_mutex);
+
+	return event;
+
+err_put_context:
+	if (err < 0)
+		put_ctx(ctx);
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(perf_event_create_kernel_counter);
+
+/*
  * inherit a event from parent task to child task:
  */
 static struct perf_event *
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
