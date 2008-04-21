Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbYDUVVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbYDUVVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYDUVVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:21:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33008 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYDUVVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:21:30 -0400
Message-Id: <20080421212128.516224560@goodmis.org>
References: <20080421210935.460817943@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 Apr 2008 17:09:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       akpm@osdl.org, Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/3] TEST PATCH - ftrace example patch for use of trace pipe headers
Content-Disposition: inline; filename=ftrace-test-pipe-open.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DO NOT APPLY THIS PATCH!!!!!

This is an example of implementing a plugin for header for the trace_pipe
file.

DO NOT APPLY THIS PATCH!!!!! 

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_functions.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

Index: linux-sched-devel.git/kernel/trace/trace_functions.c
===================================================================
--- linux-sched-devel.git.orig/kernel/trace/trace_functions.c	2008-04-21 16:50:49.000000000 -0400
+++ linux-sched-devel.git/kernel/trace/trace_functions.c	2008-04-21 16:54:55.000000000 -0400
@@ -16,6 +16,45 @@
 
 #include "trace.h"
 
+static void function_pipe_open(struct trace_iterator *iter)
+{
+	int *traceme;
+
+	traceme = kzalloc(sizeof(int), GFP_KERNEL);
+	if (!traceme)
+		return;
+
+	iter->private = traceme;
+}
+
+static ssize_t function_read(struct trace_iterator *iter,
+			     struct file *filp, char __user *ubuf,
+			     size_t cnt, loff_t *ppos)
+{
+	unsigned char head[] = "Test header\n";
+	int *traced;
+	int ret;
+
+	if (!iter->private)
+		return 0;
+
+	traced = iter->private;
+	if (*traced >= sizeof(head)-1)
+		return 0;
+
+	if (cnt > sizeof(head)-1)
+		cnt = sizeof(head)-1;
+
+	ret = copy_to_user(ubuf, head + *traced, cnt);
+
+	*traced += cnt;
+
+	if (ret)
+		cnt = -EFAULT;
+
+	return cnt;
+}
+
 static void function_reset(struct trace_array *tr)
 {
 	int cpu;
@@ -68,6 +107,8 @@ static struct tracer function_trace __re
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_function,
 #endif
+	.pipe_open   = function_pipe_open,
+	.read        = function_read,
 };
 
 static __init int init_function_trace(void)

-- 
