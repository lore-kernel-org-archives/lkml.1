Return-Path: <linux-kernel-owner+w=401wt.eu-S1756480AbZGVJB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbZGVJB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201AbZGVJB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:01:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65529 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756130AbZGVJB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:01:26 -0400
Message-ID: <4A66D50A.6050307@cn.fujitsu.com>
Date: Wed, 22 Jul 2009 16:59:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] tracing: remove max_tracer_type_len
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit the length of a tracer's name within 100 chars, and then we
don't have to play with max_tracer_type_len.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.c |   49 ++++++++++++++++---------------------------------
 1 files changed, 16 insertions(+), 33 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e30e6b1..bec133c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -128,13 +128,13 @@ int ftrace_dump_on_oops;
 
 static int tracing_set_tracer(const char *buf);
 
-#define BOOTUP_TRACER_SIZE		100
-static char bootup_tracer_buf[BOOTUP_TRACER_SIZE] __initdata;
+#define MAX_TRACER_SIZE		100
+static char bootup_tracer_buf[MAX_TRACER_SIZE] __initdata;
 static char *default_bootup_tracer;
 
 static int __init set_ftrace(char *str)
 {
-	strncpy(bootup_tracer_buf, str, BOOTUP_TRACER_SIZE);
+	strncpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
 	default_bootup_tracer = bootup_tracer_buf;
 	/* We are using ftrace early, expand it */
 	ring_buffer_expanded = 1;
@@ -244,13 +244,6 @@ static struct tracer		*trace_types __read_mostly;
 static struct tracer		*current_trace __read_mostly;
 
 /*
- * max_tracer_type_len is used to simplify the allocating of
- * buffers to read userspace tracer names. We keep track of
- * the longest tracer name registered.
- */
-static int			max_tracer_type_len;
-
-/*
  * trace_types_lock is used to protect the trace_types list.
  * This lock is also used to keep user access serialized.
  * Accesses from userspace will grab this lock while userspace
@@ -479,7 +472,6 @@ __releases(kernel_lock)
 __acquires(kernel_lock)
 {
 	struct tracer *t;
-	int len;
 	int ret = 0;
 
 	if (!type->name) {
@@ -487,6 +479,11 @@ __acquires(kernel_lock)
 		return -1;
 	}
 
+	if (strlen(type->name) > MAX_TRACER_SIZE) {
+		pr_info("Tracer has a name longer than %d\n", MAX_TRACER_SIZE);
+		return -1;
+	}
+
 	/*
 	 * When this gets called we hold the BKL which means that
 	 * preemption is disabled. Various trace selftests however
@@ -501,7 +498,7 @@ __acquires(kernel_lock)
 	for (t = trace_types; t; t = t->next) {
 		if (strcmp(type->name, t->name) == 0) {
 			/* already found */
-			pr_info("Trace %s already registered\n",
+			pr_info("Tracer %s already registered\n",
 				type->name);
 			ret = -1;
 			goto out;
@@ -555,9 +552,6 @@ __acquires(kernel_lock)
 
 	type->next = trace_types;
 	trace_types = type;
-	len = strlen(type->name);
-	if (len > max_tracer_type_len)
-		max_tracer_type_len = len;
 
  out:
 	tracing_selftest_running = false;
@@ -566,7 +560,7 @@ __acquires(kernel_lock)
 	if (ret || !default_bootup_tracer)
 		goto out_unlock;
 
-	if (strncmp(default_bootup_tracer, type->name, BOOTUP_TRACER_SIZE))
+	if (strncmp(default_bootup_tracer, type->name, MAX_TRACER_SIZE))
 		goto out_unlock;
 
 	printk(KERN_INFO "Starting tracer '%s'\n", type->name);
@@ -588,14 +582,13 @@ __acquires(kernel_lock)
 void unregister_tracer(struct tracer *type)
 {
 	struct tracer **t;
-	int len;
 
 	mutex_lock(&trace_types_lock);
 	for (t = &trace_types; *t; t = &(*t)->next) {
 		if (*t == type)
 			goto found;
 	}
-	pr_info("Trace %s not registered\n", type->name);
+	pr_info("Tracer %s not registered\n", type->name);
 	goto out;
 
  found:
@@ -608,17 +601,7 @@ void unregister_tracer(struct tracer *type)
 			current_trace->stop(&global_trace);
 		current_trace = &nop_trace;
 	}
-
-	if (strlen(type->name) != max_tracer_type_len)
-		goto out;
-
-	max_tracer_type_len = 0;
-	for (t = &trace_types; *t; t = &(*t)->next) {
-		len = strlen((*t)->name);
-		if (len > max_tracer_type_len)
-			max_tracer_type_len = len;
-	}
- out:
+out:
 	mutex_unlock(&trace_types_lock);
 }
 
@@ -2542,7 +2525,7 @@ static ssize_t
 tracing_set_trace_read(struct file *filp, char __user *ubuf,
 		       size_t cnt, loff_t *ppos)
 {
-	char buf[max_tracer_type_len+2];
+	char buf[MAX_TRACER_SIZE+2];
 	int r;
 
 	mutex_lock(&trace_types_lock);
@@ -2692,15 +2675,15 @@ static ssize_t
 tracing_set_trace_write(struct file *filp, const char __user *ubuf,
 			size_t cnt, loff_t *ppos)
 {
-	char buf[max_tracer_type_len+1];
+	char buf[MAX_TRACER_SIZE+1];
 	int i;
 	size_t ret;
 	int err;
 
 	ret = cnt;
 
-	if (cnt > max_tracer_type_len)
-		cnt = max_tracer_type_len;
+	if (cnt > MAX_TRACER_SIZE)
+		cnt = MAX_TRACER_SIZE;
 
 	if (copy_from_user(&buf, ubuf, cnt))
 		return -EFAULT;
-- 
1.6.3

