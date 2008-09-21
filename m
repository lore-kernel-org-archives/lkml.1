Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbYIUSRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbYIUSRB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 14:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbYIUSQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 14:16:53 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:30902 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbYIUSQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 14:16:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=fv+YUDDJXnDzxp3ubYVxNNA+/BOaXf5xHMFsrb/3kI5sNdGt/L8EJi/pTPlqmMdvn9
         Z6FyEIQ02iiXm7O7jCSfVYzxUFyQ64hqUtM96mYgVOyfnRRztWrSHh9SIl2RMINBlNeC
         nGKRYjuzM7oyL4Ea14KEiqtCQDQ7ye1ngt0Iw=
Message-ID: <48D68F7E.5020609@gmail.com>
Date: Sun, 21 Sep 2008 20:16:30 +0200
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>
Subject: [Patch 3/3] Tracing/ftrace: Replace none tracer by nop tracer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace "none" tracer by the recently created "nop" tracer. Both are pretty similar except that nop accepts TRACE_PRINT or TRACE_SPECIAL entries.
And as a consequence, changing the size of the ring buffer now requires that tracing has already been disabled.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff -rup linux-2.6-tip (2)/kernel/trace/trace.c linux-2.6-tip/kernel/trace/trace.c
--- linux-2.6-tip (2)/kernel/trace/trace.c	2008-09-18 18:40:00.000000000 +0200
+++ linux-2.6-tip/kernel/trace/trace.c	2008-09-20 17:13:08.000000000 +0200
@@ -142,24 +142,6 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wai
 /* trace_flags holds iter_ctrl options */

 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT;

 

-static notrace void no_trace_init(struct trace_array *tr)

-{

-	int cpu;

-

-	ftrace_function_enabled = 0;

-	if(tr->ctrl)

-		for_each_online_cpu(cpu)

-			tracing_reset(tr->data[cpu]);

-	tracer_enabled = 0;

-}

-

-/* dummy trace to disable tracing */

-static struct tracer no_tracer __read_mostly = {

-	.name		= "none",

-	.init		= no_trace_init

-};

-

-

 /**

  * trace_wake_up - wake up tasks waiting for trace input

  *

@@ -962,7 +944,7 @@ ftrace_special(unsigned long arg1, unsig
 	long disabled;

 	int cpu;

 

-	if (tracing_disabled || current_trace == &no_tracer || !tr->ctrl)

+	if (tracing_disabled || !tr->ctrl)

 		return;

 

 	local_irq_save(flags);

@@ -2794,7 +2776,8 @@ tracing_entries_write(struct file *filp,
 {

 	unsigned long val;

 	char buf[64];

-	int i, ret;

+	int i, ret;
+	struct trace_array *tr = filp->private_data;

 

 	if (cnt >= sizeof(buf))

 		return -EINVAL;

@@ -2814,9 +2797,9 @@ tracing_entries_write(struct file *filp,
 

 	mutex_lock(&trace_types_lock);

 

-	if (current_trace != &no_tracer) {

+	if (tr->ctrl) {

 		cnt = -EBUSY;

-		pr_info("ftrace: set current_tracer to none"

+		pr_info("ftrace: please disable tracing"

 			" before modifying buffer size\n");

 		goto out;

 	}

@@ -2879,20 +2862,6 @@ tracing_entries_write(struct file *filp,
 	return cnt;

 }

 

-static int tracing_open_mark(struct inode *inode, struct file *filp)

-{

-	int ret;

-

-	ret = tracing_open_generic(inode, filp);

-	if (ret)

-		return ret;

-

-	if (current_trace == &no_tracer)

-		return -ENODEV;

-

-	return 0;

-}

-

 static int mark_printk(const char *fmt, ...)

 {

 	int ret;

@@ -2911,7 +2880,7 @@ tracing_mark_write(struct file *filp, co
 	char *end;

 	struct trace_array *tr = &global_trace;

 

-	if (current_trace == &no_tracer || !tr->ctrl || tracing_disabled)

+	if (!tr->ctrl || tracing_disabled)

 		return -EINVAL;

 

 	if (cnt > TRACE_BUF_SIZE)

@@ -2971,7 +2940,7 @@ static struct file_operations tracing_en
 };

 

 static struct file_operations tracing_mark_fops = {

-	.open		= tracing_open_mark,

+	.open		= tracing_open_generic,

 	.write		= tracing_mark_write,

 };

 

@@ -3123,7 +3092,7 @@ int trace_vprintk(unsigned long ip, cons
 	long disabled;

 	int cpu, len = 0, write, written = 0;

 

-	if (current_trace == &no_tracer || !tr->ctrl || tracing_disabled)

+	if (!tr->ctrl || tracing_disabled)

 		return 0;

 

 	local_irq_save(flags);

@@ -3539,8 +3508,8 @@ __init static int tracer_alloc_buffers(v
 

 	trace_init_cmdlines();

 

-	register_tracer(&no_tracer);

-	current_trace = &no_tracer;

+	register_tracer(&nop_trace);

+	current_trace = &nop_trace;

 

 	/* All seems OK, enable tracing */

 	global_trace.ctrl = tracer_enabled;

diff -rup linux-2.6-tip (2)/kernel/trace/trace.h linux-2.6-tip/kernel/trace/trace.h
--- linux-2.6-tip (2)/kernel/trace/trace.h	2008-09-19 18:01:26.000000000 +0200
+++ linux-2.6-tip/kernel/trace/trace.h	2008-09-20 17:23:36.000000000 +0200
@@ -384,5 +384,7 @@ enum trace_iterator_flags {

 	TRACE_ITER_SCHED_TREE		= 0x200,

 	TRACE_ITER_PRINTK		= 0x400,

 };

+
+extern struct tracer nop_trace;
 

 #endif /* _LINUX_KERNEL_TRACE_H */

diff -rup linux-2.6-tip (2)/kernel/trace/trace_nop.c linux-2.6-tip/kernel/trace/trace_nop.c
--- linux-2.6-tip (2)/kernel/trace/trace_nop.c	2008-09-19 18:01:26.000000000 +0200
+++ linux-2.6-tip/kernel/trace/trace_nop.c	2008-09-21 00:44:47.000000000 +0200

@@ -47,7 +51,7 @@ static void nop_trace_ctrl_update(struct
 		stop_nop_trace(tr);

 }

 

-static struct tracer nop_trace __read_mostly =

+struct tracer nop_trace __read_mostly =

 {

 	.name		= "nop",

 	.init		= nop_trace_init,

@@ -57,9 +61,4 @@ static struct tracer nop_trace __read_mo
 	.selftest	= trace_selftest_startup_nop,

 #endif

 };

-

-__init static int init_nop_trace(void)

-{

-	return register_tracer(&nop_trace);

-}

-device_initcall(init_nop_trace);

+
