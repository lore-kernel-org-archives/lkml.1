Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbYLDWvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbYLDWvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 17:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756946AbYLDWv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 17:51:29 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:6769 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbYLDWv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 17:51:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=XDJZrnTp+PVsWUMO7iUtVDYV8uAi2n/vX9Fm5PffkhMOXZ3a4p10yo3EcuDgHt3zZa
         1BfBRFj4q2YYh9FYgrBEWLcQq9mei4WZgPzc2PoykF0oANrqBxv8o+5aiFHVaMsfQXCP
         GqBrvJnio2EYYmuxI/HhBpiXkFZdabjIomqiI=
Message-ID: <49385EEB.20003@gmail.com>
Date: Thu, 04 Dec 2008 23:51:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] tracing/ftrace: provide the macro task_curr_ret_stack()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

As suggested by Steven Rostedt, this patch provide a new macro
task_curr_ret_stack() to move the cpp conditionnal CONFIG into
the linux/ftrace.h headers.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/ftrace.h |   11 +++++++++++
 kernel/trace/trace.c   |    8 +-------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index b295d31..b9b4d0a 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -8,6 +8,7 @@
 #include <linux/types.h>
 #include <linux/kallsyms.h>
 #include <linux/bitops.h>
+#include <linux/sched.h>
 
 #ifdef CONFIG_FUNCTION_TRACER
 
@@ -387,9 +388,19 @@ extern void unregister_ftrace_graph(void);
 
 extern void ftrace_graph_init_task(struct task_struct *t);
 extern void ftrace_graph_exit_task(struct task_struct *t);
+
+static inline int task_curr_ret_stack(struct task_struct *t)
+{
+	return t->curr_ret_stack;
+}
 #else
 static inline void ftrace_graph_init_task(struct task_struct *t) { }
 static inline void ftrace_graph_exit_task(struct task_struct *t) { }
+
+static inline int task_curr_ret_stack(struct task_struct *tsk)
+{
+	return -1;
+}
 #endif
 
 #ifdef CONFIG_TRACING
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5dca6ef..7a93c66 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3657,13 +3657,7 @@ int __ftrace_printk(unsigned long ip, const char *fmt, ...)
 		return 0;
 
 	va_start(ap, fmt);
-
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	ret = trace_vprintk(ip, current->curr_ret_stack, fmt, ap);
-#else
-	ret = trace_vprintk(ip, -1, fmt, ap);
-#endif
-
+	ret = trace_vprintk(ip, task_curr_ret_stack(current), fmt, ap);
 	va_end(ap);
 	return ret;
 }
-- 
1.5.6.3

