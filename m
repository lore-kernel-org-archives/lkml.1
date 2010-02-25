Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396Ab0BYPn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:43:28 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58813 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759315Ab0BYPn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:43:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=G+GjcB+skieDWTZYitL4sSV10ly53gqKVpKHSM0GaAc32s3Hai9wquCHQAaqNJVnKD
         vwLWyovzHhGdoNclJks8m3WP9G+mPZZDxKnkaFggj98qXD9g2ssauGwCfxHTWaCDdepg
         Ov0P7hqZHjPe72biPgEfnRvPKRA+QA8LZt0hc=
Date: Thu, 25 Feb 2010 23:43:22 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/07] kernel.h trace cleanup
Message-ID: <20100225154322.GA2686@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup kernel.h trace related stuff, move to linux/trace.h

As Steven Rostedt said, trace stuff should be as convenient as printk,
so include trace.h in kernel.h for convinience.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/kernel.h |  137 -----------------------------------------------
 include/linux/trace.h  |  141 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 142 insertions(+), 136 deletions(-)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/linux/trace.h	2010-02-25 17:50:56.761570109 +0800
@@ -0,0 +1,141 @@
+#ifndef _LINUX_TRACE_H
+#define _LINUX_TRACE_H
+
+#include <stdarg.h>
+/*
+ * General tracing related utility functions - trace_printk(),
+ * tracing_on/tracing_off and tracing_start()/tracing_stop
+ *
+ * Use tracing_on/tracing_off when you want to quickly turn on or off
+ * tracing. It simply enables or disables the recording of the trace events.
+ * This also corresponds to the user space /sys/kernel/debug/tracing/tracing_on
+ * file, which gives a means for the kernel and userspace to interact.
+ * Place a tracing_off() in the kernel where you want tracing to end.
+ * From user space, examine the trace, and then echo 1 > tracing_on
+ * to continue tracing.
+ *
+ * tracing_stop/tracing_start has slightly more overhead. It is used
+ * by things like suspend to ram where disabling the recording of the
+ * trace is not enough, but tracing must actually stop because things
+ * like calling smp_processor_id() may crash the system.
+ *
+ * Most likely, you want to use tracing_on/tracing_off.
+ */
+#ifdef CONFIG_RING_BUFFER
+void tracing_on(void);
+void tracing_off(void);
+/* trace_off_permanent stops recording with no way to bring it back */
+void tracing_off_permanent(void);
+int tracing_is_on(void);
+#else
+static inline void tracing_on(void) { }
+static inline void tracing_off(void) { }
+static inline void tracing_off_permanent(void) { }
+static inline int tracing_is_on(void) { return 0; }
+#endif
+#ifdef CONFIG_TRACING
+extern void tracing_start(void);
+extern void tracing_stop(void);
+extern void ftrace_off_permanent(void);
+
+extern void
+ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3);
+
+static inline void __attribute__ ((format (printf, 1, 2)))
+____trace_printk_check_format(const char *fmt, ...)
+{
+}
+#define __trace_printk_check_format(fmt, args...)			\
+do {									\
+	if (0)								\
+		____trace_printk_check_format(fmt, ##args);		\
+} while (0)
+
+/**
+ * trace_printk - printf formatting in the ftrace buffer
+ * @fmt: the printf format for printing
+ *
+ * Note: __trace_printk is an internal function for trace_printk and
+ *       the @ip is passed in via the trace_printk macro.
+ *
+ * This function allows a kernel developer to debug fast path sections
+ * that printk is not appropriate for. By scattering in various
+ * printk like tracing in the code, a developer can quickly see
+ * where problems are occurring.
+ *
+ * This is intended as a debugging tool for the developer only.
+ * Please refrain from leaving trace_printks scattered around in
+ * your code.
+ */
+
+#define trace_printk(fmt, args...)					\
+do {									\
+	__trace_printk_check_format(fmt, ##args);			\
+	if (__builtin_constant_p(fmt)) {				\
+		static const char *trace_printk_fmt			\
+		  __attribute__((section("__trace_printk_fmt"))) =	\
+			__builtin_constant_p(fmt) ? fmt : NULL;		\
+									\
+		__trace_bprintk(_THIS_IP_, trace_printk_fmt, ##args);	\
+	} else								\
+		__trace_printk(_THIS_IP_, fmt, ##args);		\
+} while (0)
+
+extern int
+__trace_bprintk(unsigned long ip, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+
+extern int
+__trace_printk(unsigned long ip, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+
+extern void trace_dump_stack(void);
+
+/*
+ * The double __builtin_constant_p is because gcc will give us an error
+ * if we try to allocate the static variable to fmt if it is not a
+ * constant. Even with the outer if statement.
+ */
+#define ftrace_vprintk(fmt, vargs)					\
+do {									\
+	if (__builtin_constant_p(fmt)) {				\
+		static const char *trace_printk_fmt			\
+		  __attribute__((section("__trace_printk_fmt"))) =	\
+			__builtin_constant_p(fmt) ? fmt : NULL;		\
+									\
+		__ftrace_vbprintk(_THIS_IP_, trace_printk_fmt, vargs);	\
+	} else								\
+		__ftrace_vprintk(_THIS_IP_, fmt, vargs);		\
+} while (0)
+
+extern int
+__ftrace_vbprintk(unsigned long ip, const char *fmt, va_list ap);
+
+extern int
+__ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap);
+
+extern void ftrace_dump(void);
+#else
+static inline void
+ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
+static inline int
+trace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 2)));
+
+static inline void tracing_start(void) { }
+static inline void tracing_stop(void) { }
+static inline void ftrace_off_permanent(void) { }
+static inline void trace_dump_stack(void) { }
+static inline int
+trace_printk(const char *fmt, ...)
+{
+	return 0;
+}
+static inline int
+ftrace_vprintk(const char *fmt, va_list ap)
+{
+	return 0;
+}
+static inline void ftrace_dump(void) { }
+#endif /* CONFIG_TRACING */
+
+#endif /* _LINUX_TRACE_H */
--- linux-2.6.orig/include/linux/kernel.h	2010-02-25 17:39:46.872470838 +0800
+++ linux-2.6/include/linux/kernel.h	2010-02-25 17:39:47.758301987 +0800
@@ -16,6 +16,7 @@
 #include <linux/printk.h>
 #include <linux/panic.h>
 #include <linux/string.h>
+#include <linux/trace.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
@@ -168,142 +169,6 @@ extern enum system_states {
 extern void dump_stack(void) __cold;
 
 /*
- * General tracing related utility functions - trace_printk(),
- * tracing_on/tracing_off and tracing_start()/tracing_stop
- *
- * Use tracing_on/tracing_off when you want to quickly turn on or off
- * tracing. It simply enables or disables the recording of the trace events.
- * This also corresponds to the user space /sys/kernel/debug/tracing/tracing_on
- * file, which gives a means for the kernel and userspace to interact.
- * Place a tracing_off() in the kernel where you want tracing to end.
- * From user space, examine the trace, and then echo 1 > tracing_on
- * to continue tracing.
- *
- * tracing_stop/tracing_start has slightly more overhead. It is used
- * by things like suspend to ram where disabling the recording of the
- * trace is not enough, but tracing must actually stop because things
- * like calling smp_processor_id() may crash the system.
- *
- * Most likely, you want to use tracing_on/tracing_off.
- */
-#ifdef CONFIG_RING_BUFFER
-void tracing_on(void);
-void tracing_off(void);
-/* trace_off_permanent stops recording with no way to bring it back */
-void tracing_off_permanent(void);
-int tracing_is_on(void);
-#else
-static inline void tracing_on(void) { }
-static inline void tracing_off(void) { }
-static inline void tracing_off_permanent(void) { }
-static inline int tracing_is_on(void) { return 0; }
-#endif
-#ifdef CONFIG_TRACING
-extern void tracing_start(void);
-extern void tracing_stop(void);
-extern void ftrace_off_permanent(void);
-
-extern void
-ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3);
-
-static inline void __attribute__ ((format (printf, 1, 2)))
-____trace_printk_check_format(const char *fmt, ...)
-{
-}
-#define __trace_printk_check_format(fmt, args...)			\
-do {									\
-	if (0)								\
-		____trace_printk_check_format(fmt, ##args);		\
-} while (0)
-
-/**
- * trace_printk - printf formatting in the ftrace buffer
- * @fmt: the printf format for printing
- *
- * Note: __trace_printk is an internal function for trace_printk and
- *       the @ip is passed in via the trace_printk macro.
- *
- * This function allows a kernel developer to debug fast path sections
- * that printk is not appropriate for. By scattering in various
- * printk like tracing in the code, a developer can quickly see
- * where problems are occurring.
- *
- * This is intended as a debugging tool for the developer only.
- * Please refrain from leaving trace_printks scattered around in
- * your code.
- */
-
-#define trace_printk(fmt, args...)					\
-do {									\
-	__trace_printk_check_format(fmt, ##args);			\
-	if (__builtin_constant_p(fmt)) {				\
-		static const char *trace_printk_fmt			\
-		  __attribute__((section("__trace_printk_fmt"))) =	\
-			__builtin_constant_p(fmt) ? fmt : NULL;		\
-									\
-		__trace_bprintk(_THIS_IP_, trace_printk_fmt, ##args);	\
-	} else								\
-		__trace_printk(_THIS_IP_, fmt, ##args);		\
-} while (0)
-
-extern int
-__trace_bprintk(unsigned long ip, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-
-extern int
-__trace_printk(unsigned long ip, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-
-extern void trace_dump_stack(void);
-
-/*
- * The double __builtin_constant_p is because gcc will give us an error
- * if we try to allocate the static variable to fmt if it is not a
- * constant. Even with the outer if statement.
- */
-#define ftrace_vprintk(fmt, vargs)					\
-do {									\
-	if (__builtin_constant_p(fmt)) {				\
-		static const char *trace_printk_fmt			\
-		  __attribute__((section("__trace_printk_fmt"))) =	\
-			__builtin_constant_p(fmt) ? fmt : NULL;		\
-									\
-		__ftrace_vbprintk(_THIS_IP_, trace_printk_fmt, vargs);	\
-	} else								\
-		__ftrace_vprintk(_THIS_IP_, fmt, vargs);		\
-} while (0)
-
-extern int
-__ftrace_vbprintk(unsigned long ip, const char *fmt, va_list ap);
-
-extern int
-__ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap);
-
-extern void ftrace_dump(void);
-#else
-static inline void
-ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
-static inline int
-trace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 2)));
-
-static inline void tracing_start(void) { }
-static inline void tracing_stop(void) { }
-static inline void ftrace_off_permanent(void) { }
-static inline void trace_dump_stack(void) { }
-static inline int
-trace_printk(const char *fmt, ...)
-{
-	return 0;
-}
-static inline int
-ftrace_vprintk(const char *fmt, va_list ap)
-{
-	return 0;
-}
-static inline void ftrace_dump(void) { }
-#endif /* CONFIG_TRACING */
-
-/*
  * min()/max()/clamp() macros that also do
  * strict type-checking.. See the
  * "unnecessary" pointer comparison.
