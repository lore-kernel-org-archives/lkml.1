Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbYKLF4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbYKLF4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 00:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbYKLF4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 00:56:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62271 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYKLF4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 00:56:03 -0500
Message-Id: <20081112055600.463931707@goodmis.org>
References: <20081112055454.798779203@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 00:54:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] tracing/fastboot: Move boot tracer structs and funcs into their own header.
Content-Disposition: inline; filename=0001-tracing-fastboot-Move-boot-tracer-structs-and-funcs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Cleanups on the boot tracer and ftrace

This patch bring some cleanups about the boot tracer headers.
The functions and structures of this tracer have nothing related to
ftrace and should have so their own header file.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |   41 -----------------------------------------
 include/trace/boot.h   |   43 +++++++++++++++++++++++++++++++++++++++++++
 init/main.c            |    1 +
 kernel/trace/trace.h   |    1 +
 4 files changed, 45 insertions(+), 41 deletions(-)
 create mode 100644 include/trace/boot.h

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
index b20eed0..9878c27 100644
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
1.5.6.5

-- 
