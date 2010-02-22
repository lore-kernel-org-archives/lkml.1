Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0BVOUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 09:20:21 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:38588 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab0BVOUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 09:20:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=G+PxvLGuXl/JPiMdcMfMfV+LCiPsmN719htW0z3KPp09KDWvym7Z2PMLcxmrtkEyUC
         S+/EoO5EjyEKTKesfvnTp19okfQfOLY7my4onaVLU3B7Pc1adQVwC2ANYHsmiK2FuUPp
         h1BGP6G10znyOzb79VkT2yYv+it6B3SXRT6cc=
Date: Mon, 22 Feb 2010 22:20:08 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Neil Horman <nhorman@tuxdriver.com>, Vivek Goyal <vgoyal@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Markus Metzger <markus.t.metzger@intel.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/06] kernel.h tracing stuff cleanup
Message-ID: <20100222142008.GA9032@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace stuff in kernel.h should stay in their own head file 

cleanup trace declarations in kernel.h, put them into ring_buffer.h
include ring_buffer.h in every file which need it

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 drivers/char/sysrq.c          |    1 
 include/linux/ring_buffer.h   |  137 ++++++++++++++++++++++++++++++++++++++++++
 kernel/panic.c                |    1 
 kernel/trace/trace_selftest.c |    1 
 4 files changed, 140 insertions(+)

--- linux-2.6.orig/include/linux/ring_buffer.h	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/include/linux/ring_buffer.h	2010-02-16 17:41:33.000000000 +0800
@@ -1,6 +1,7 @@
 #ifndef _LINUX_RING_BUFFER_H
 #define _LINUX_RING_BUFFER_H
 
+#include <stdarg.h>
 #include <linux/kmemcheck.h>
 #include <linux/mm.h>
 #include <linux/seq_file.h>
@@ -189,4 +190,140 @@ enum ring_buffer_flags {
 	RB_FL_OVERWRITE		= 1 << 0,
 };
 
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
 #endif /* _LINUX_RING_BUFFER_H */
--- linux-2.6.orig/kernel/panic.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/kernel/panic.c	2010-02-16 17:41:33.000000000 +0800
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/nmi.h>
 #include <linux/dmi.h>
+#include <linux/ring_buffer.h>
 
 int panic_on_oops;
 static unsigned long tainted_mask;
--- linux-2.6.orig/kernel/trace/trace_selftest.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/kernel/trace/trace_selftest.c	2010-02-16 17:41:33.000000000 +0800
@@ -1,5 +1,6 @@
 /* Include in trace.c */
 
+#include <linux/ring_buffer.h>
 #include <linux/stringify.h>
 #include <linux/kthread.h>
 #include <linux/delay.h>
--- linux-2.6.orig/drivers/char/sysrq.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/drivers/char/sysrq.c	2010-02-16 17:41:33.000000000 +0800
@@ -38,6 +38,7 @@
 #include <linux/workqueue.h>
 #include <linux/hrtimer.h>
 #include <linux/oom.h>
+#include <linux/ring_buffer.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
