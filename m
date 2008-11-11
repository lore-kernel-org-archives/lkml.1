Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbYKKWVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbYKKWVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYKKWVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:21:37 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:49986 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbYKKWVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:21:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=MAw1ZHpBHhvafcmxpMlYpT2SeR4X4NNyFxak446nPAT2L2QG+smBjIV63MCURSvB2s
         KMweg64nZurPeLaEo58TmOH2nb43ahW8dZO4qKI2yOGKaXwdznkINkZXLqpYsTachMcf
         n55aK4yKne98nugjim7C7derytXJz5OsA6rG0=
Message-ID: <491A056B.2010500@gmail.com>
Date: Tue, 11 Nov 2008 23:21:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] tracing/fastboot: Move boot tracer structs and funcs
 into their own header.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Cleanups on the boot tracer and ftrace

This patch bring some cleanups about the boot tracer headers.
The functions and structures of this tracer have nothing related to
ftrace and should have so their own header file.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/ftrace.h |   41 -----------------------------------------
 include/trace/boot.h   |   43 +++++++++++++++++++++++++++++++++++++++++++
 init/main.c            |    1 +
 kernel/trace/trace.h   |    1 +
 4 files changed, 45 insertions(+), 41 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index dcbbf72..4fbc4a8 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -287,45 +287,4 @@ extern trace_function_return_t ftrace_function_return;
 extern void unregister_ftrace_return(void);
 #endif
 
-/*
- * Structure which defines the trace of an initcall.
- * You don't have to fill the func field since it is
- * only used internally by the tracer.
- */
-struct boot_trace {
-	pid_t			caller;
-	char			func[KSYM_NAME_LEN];
-	int			result;
-	unsigned long long	duration;		/* usecs */
-	ktime_t			calltime;
-	ktime_t			rettime;
-};
-
-#ifdef CONFIG_BOOT_TRACER
-/* Append the trace on the ring-buffer */
-extern void trace_boot(struct boot_trace *it, initcall_t fn);
-
-/* Tells the tracer that smp_pre_initcall is finished.
- * So we can start the tracing
- */
-extern void start_boot_trace(void);
-
-/* Resume the tracing of other necessary events
- * such as sched switches
- */
-extern void enable_boot_trace(void);
-
-/* Suspend this tracing. Actually, only sched_switches tracing have
- * to be suspended. Initcalls doesn't need it.)
- */
-extern void disable_boot_trace(void);
-#else
-static inline void trace_boot(struct boot_trace *it, initcall_t fn) { }
-static inline void start_boot_trace(void) { }
-static inline void enable_boot_trace(void) { }
-static inline void disable_boot_trace(void) { }
-#endif
-
-
-
 #endif /* _LINUX_FTRACE_H */
diff --git a/include/trace/boot.h b/include/trace/boot.h
new file mode 100644
index 0000000..4cbe64e
--- /dev/null
+++ b/include/trace/boot.h
@@ -0,0 +1,43 @@
+#ifndef _LINUX_TRACE_BOOT_H
+#define _LINUX_TRACE_BOOT_H
+
+/*
+ * Structure which defines the trace of an initcall.
+ * You don't have to fill the func field since it is
+ * only used internally by the tracer.
+ */
+struct boot_trace {
+	pid_t			caller;
+	char			func[KSYM_NAME_LEN];
+	int			result;
+	unsigned long long	duration;		/* usecs */
+	ktime_t			calltime;
+	ktime_t			rettime;
+};
+
+#ifdef CONFIG_BOOT_TRACER
+/* Append the trace on the ring-buffer */
+extern void trace_boot(struct boot_trace *it, initcall_t fn);
+
+/* Tells the tracer that smp_pre_initcall is finished.
+ * So we can start the tracing
+ */
+extern void start_boot_trace(void);
+
+/* Resume the tracing of other necessary events
+ * such as sched switches
+ */
+extern void enable_boot_trace(void);
+
+/* Suspend this tracing. Actually, only sched_switches tracing have
+ * to be suspended. Initcalls doesn't need it.)
+ */
+extern void disable_boot_trace(void);
+#else
+static inline void trace_boot(struct boot_trace *it, initcall_t fn) { }
+static inline void start_boot_trace(void) { }
+static inline void enable_boot_trace(void) { }
+static inline void disable_boot_trace(void) { }
+#endif /* CONFIG_BOOT_TRACER */
+
+#endif /* __LINUX_TRACE_BOOT_H */
diff --git a/init/main.c b/init/main.c
index f5f4f5b..2a04290 100644
--- a/init/main.c
+++ b/init/main.c
@@ -65,6 +65,7 @@
 #include <linux/idr.h>
 #include <linux/kmemcheck.h>
 #include <linux/ftrace.h>
+#include <trace/boot.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e40ce0c..f69a519 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -8,6 +8,7 @@
 #include <linux/ring_buffer.h>
 #include <linux/mmiotrace.h>
 #include <linux/ftrace.h>
+#include <trace/boot.h>
 
 enum trace_type {
 	__TRACE_FIRST_TYPE = 0,
-- 
1.5.2.5
