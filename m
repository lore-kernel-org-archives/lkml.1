Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbZKUNhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbZKUNhU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbZKUNhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:37:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:36294 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbZKUNhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:37:15 -0500
Date: Sat, 21 Nov 2009 13:36:23 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: acme@redhat.com, mingo@redhat.com, stern@rowland.harvard.edu,
       efault@gmx.de, peterz@infradead.org, jirislaby@gmail.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       paulus@samba.org, arjan@linux.intel.com, lizf@cn.fujitsu.com,
       jan.kiszka@web.de, lethal@linux-sh.org, jan.kiszka@siemens.com,
       arjan@infradead.org, prasad@linux.vnet.ibm.com, mingo@elte.hu,
       avi@redhat.com
Reply-To: mingo@redhat.com, acme@redhat.com, stern@rowland.harvard.edu,
       peterz@infradead.org, efault@gmx.de, jirislaby@gmail.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       paulus@samba.org, arjan@linux.intel.com, lizf@cn.fujitsu.com,
       jan.kiszka@web.de, jan.kiszka@siemens.com, lethal@linux-sh.org,
       arjan@infradead.org, avi@redhat.com, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
In-Reply-To: <20090925122556.2f8bd939@infradead.org>
References: <20090925122556.2f8bd939@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/core: Provide a kernel-internal interface to get to performance counters
Message-ID: <tip-fb0459d75c1d0a4ba3cafdd2c754e7486968a676@git.kernel.org>
Git-Commit-ID: fb0459d75c1d0a4ba3cafdd2c754e7486968a676
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb0459d75c1d0a4ba3cafdd2c754e7486968a676
Gitweb:     http://git.kernel.org/tip/fb0459d75c1d0a4ba3cafdd2c754e7486968a676
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Fri, 25 Sep 2009 12:25:56 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 3 Nov 2009 18:04:17 +0100

perf/core: Provide a kernel-internal interface to get to performance counters

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

v2: Remove the wrong comment about the fact
    perf_event_create_kernel_counter must be called from a kernel
    thread.

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
 include/linux/perf_event.h |    6 +++
 kernel/perf_event.c        |   75 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 80 insertions(+), 1 deletions(-)

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
index 12b5ec3..02d4ff0 100644
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
@@ -4638,6 +4659,58 @@ err_put_context:
 	return err;
 }
 
+/**
+ * perf_event_create_kernel_counter
+ *
+ * @attr: attributes of the counter to create
+ * @cpu: cpu in which the counter is bound
+ * @pid: task to profile
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
 /*
  * inherit a event from parent task to child task:
  */
