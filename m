Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZJXOS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZJXOS0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 10:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbZJXOSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 10:18:24 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:62185 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbZJXORR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 10:17:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qqKxaaULL8qWgc7/mUGpRcK9fD7N3jDHyyqtjX03PyZdkFb+3dmHl7y0EBeGq5UD9L
         N5irfEnH6Iw7PRm4hlAKzYADswAkB+XjndhvzniBQosqoZHLL4y0Kmo8DrnI8l031ZfT
         1p6gUl52qXUv9kEvW+hzRXRb29451wr2ykZ1o=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>, Jan Kiszka <jan.kiszka@web.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/6] perf/core: Provide a kernel-internal interface to get to performance counters
Date: Sat, 24 Oct 2009 16:16:53 +0200
Message-Id: <1256393818-8921-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1256393818-8921-1-git-send-email-fweisbec@gmail.com>
References: <1256393818-8921-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@infradead.org>

There are reasons for kernel code to ask for, and use, performance
counters.
For example, in CPU freq governors this tends to be a good idea, but
there are other examples possible as well of course.

This patch adds the needed bits to do enable this functionality; they
have been tested in an experimental cpufreq driver that I'm working on,
and the changes are all that I needed to access counters properly.

[fweisbec@gmail.com: added pid to perf_event_create_kernel_counter so
that we can profile a particular task too

TODO: Have a better error reporting, don't just return NULL in fail
case.]

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jan Kiszka <jan.kiszka@web.de>
Cc: Avi Kivity <avi@redhat.com>
LKML-Reference: <20090925122556.2f8bd939@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/perf_event.h |    6 ++++
 kernel/perf_event.c        |   72 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 77 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index df9d964..fa151d4 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -744,6 +744,12 @@ extern int hw_perf_group_sched_in(struct perf_event *group_leader,
 	       struct perf_cpu_context *cpuctx,
 	       struct perf_event_context *ctx, int cpu);
 extern void perf_event_update_userpage(struct perf_event *event);
+extern int perf_event_release_kernel(struct perf_event *event);
+extern struct perf_event *
+perf_event_create_kernel_counter(struct perf_event_attr *attr,
+				int cpu,
+				pid_t pid);
+extern u64 perf_event_read_value(struct perf_event *event);
 
 struct perf_sample_data {
 	u64				type;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 12b5ec3..1fc69d8 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1725,6 +1725,26 @@ static int perf_release(struct inode *inode, struct file *file)
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
@@ -1750,7 +1770,7 @@ static int perf_event_read_size(struct perf_event *event)
 	return size;
 }
 
-static u64 perf_event_read_value(struct perf_event *event)
+u64 perf_event_read_value(struct perf_event *event)
 {
 	struct perf_event *child;
 	u64 total = 0;
@@ -1761,6 +1781,7 @@ static u64 perf_event_read_value(struct perf_event *event)
 
 	return total;
 }
+EXPORT_SYMBOL_GPL(perf_event_read_value);
 
 static int perf_event_read_entry(struct perf_event *event,
 				   u64 read_format, char __user *buf)
@@ -4639,6 +4660,55 @@ err_put_context:
 }
 
 /*
+ * perf_event_create_kernel_counter
+ * MUST be called from a kernel thread.
+ */
+struct perf_event *
+perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
+				 pid_t pid)
+{
+	struct perf_event *event;
+	struct perf_event_context *ctx;
+	int err;
+
+	/*
+	 * Get the target context (task or percpu):
+	 */
+
+	ctx = find_get_context(pid, cpu);
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
1.6.2.3

