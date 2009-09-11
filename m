Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbZIKD3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbZIKD3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 23:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZIKD3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 23:29:43 -0400
Received: from mail.perches.com ([173.55.12.10]:1092 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbZIKD3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 23:29:40 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/3] include/linux/logging.h: Separate logging functions out of kernel.h
Date: Thu, 10 Sep 2009 20:29:40 -0700
Message-Id: <6415a598d75cd9c10c9177ce6c9171bee22f979c.1252639196.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1252639195.git.joe@perches.com>
References: <cover.1252639195.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved all logging/tracing bits to a separate file
Neatened a bit for checkpatch complaints

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h  |  293 +-------------------------------------------
 include/linux/logging.h |  313 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 314 insertions(+), 292 deletions(-)
 create mode 100644 include/linux/logging.h

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f61039e..20eb8ae 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -17,10 +17,10 @@
 #include <linux/typecheck.h>
 #include <linux/ratelimit.h>
 #include <linux/dynamic_debug.h>
+#include <linux/logging.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
-
 struct ftrace_branch_data {
 	const char *func;
 	const char *file;
@@ -112,9 +112,6 @@ static inline void branch_profiler(struct ftrace_branch_data *data, int cond)
 #endif /* CONFIG_PROFILE_ALL_BRANCHES */
 #endif
 
-extern const char linux_banner[];
-extern const char linux_proc_banner[];
-
 #define USHORT_MAX	((u16)(~0U))
 #define SHORT_MAX	((s16)(USHORT_MAX>>1))
 #define SHORT_MIN	(-SHORT_MAX - 1)
@@ -180,31 +177,6 @@ extern const char linux_proc_banner[];
  */
 #define lower_32_bits(n) ((u32)(n))
 
-#define	KERN_EMERG	"<0>"	/* system is unusable			*/
-#define	KERN_ALERT	"<1>"	/* action must be taken immediately	*/
-#define	KERN_CRIT	"<2>"	/* critical conditions			*/
-#define	KERN_ERR	"<3>"	/* error conditions			*/
-#define	KERN_WARNING	"<4>"	/* warning conditions			*/
-#define	KERN_NOTICE	"<5>"	/* normal but significant condition	*/
-#define	KERN_INFO	"<6>"	/* informational			*/
-#define	KERN_DEBUG	"<7>"	/* debug-level messages			*/
-
-/* Use the default kernel loglevel */
-#define KERN_DEFAULT	"<d>"
-/*
- * Annotation for a "continued" line of log printout (only done after a
- * line that had no enclosing \n). Only to be used by core/arch code
- * during early bootup (a continued line is not SMP-safe otherwise).
- */
-#define	KERN_CONT	"<c>"
-
-extern int console_printk[];
-
-#define console_loglevel (console_printk[0])
-#define default_message_loglevel (console_printk[1])
-#define minimum_console_loglevel (console_printk[2])
-#define default_console_loglevel (console_printk[3])
-
 struct completion;
 struct pt_regs;
 struct user;
@@ -303,93 +275,8 @@ extern int func_ptr_is_kernel_text(void *ptr);
 struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
-/*
- * FW_BUG
- * Add this to a message where you are sure the firmware is buggy or behaves
- * really stupid or out of spec. Be aware that the responsible BIOS developer
- * should be able to fix this issue or at least get a concrete idea of the
- * problem by reading your message without the need of looking at the kernel
- * code.
- * 
- * Use it for definite and high priority BIOS bugs.
- *
- * FW_WARN
- * Use it for not that clear (e.g. could the kernel messed up things already?)
- * and medium priority BIOS bugs.
- *
- * FW_INFO
- * Use this one if you want to tell the user or vendor about something
- * suspicious, but generally harmless related to the firmware.
- *
- * Use it for information or very low priority BIOS bugs.
- */
-#define FW_BUG		"[Firmware Bug]: "
-#define FW_WARN		"[Firmware Warn]: "
-#define FW_INFO		"[Firmware Info]: "
-
-#ifdef CONFIG_PRINTK
-asmlinkage int vprintk(const char *fmt, va_list args)
-	__attribute__ ((format (printf, 1, 0)));
-asmlinkage int printk(const char * fmt, ...)
-	__attribute__ ((format (printf, 1, 2))) __cold;
-
-extern struct ratelimit_state printk_ratelimit_state;
-extern int printk_ratelimit(void);
-extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
-				   unsigned int interval_msec);
-
-/*
- * Print a one-time message (analogous to WARN_ONCE() et al):
- */
-#define printk_once(x...) ({			\
-	static int __print_once = 1;		\
-						\
-	if (__print_once) {			\
-		__print_once = 0;		\
-		printk(x);			\
-	}					\
-})
-
-void log_buf_kexec_setup(void);
-#else
-static inline int vprintk(const char *s, va_list args)
-	__attribute__ ((format (printf, 1, 0)));
-static inline int vprintk(const char *s, va_list args) { return 0; }
-static inline int printk(const char *s, ...)
-	__attribute__ ((format (printf, 1, 2)));
-static inline int __cold printk(const char *s, ...) { return 0; }
-static inline int printk_ratelimit(void) { return 0; }
-static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
-					  unsigned int interval_msec)	\
-		{ return false; }
-
-/* No effect, but we still get type checking even in the !PRINTK case: */
-#define printk_once(x...) printk(x)
-
-static inline void log_buf_kexec_setup(void)
-{
-}
-#endif
-
-extern int printk_needs_cpu(int cpu);
-extern void printk_tick(void);
-
-extern void asmlinkage __attribute__((format(printf, 1, 2)))
-	early_printk(const char *fmt, ...);
-
 unsigned long int_sqrt(unsigned long);
 
-static inline void console_silent(void)
-{
-	console_loglevel = 0;
-}
-
-static inline void console_verbose(void)
-{
-	if (console_loglevel)
-		console_loglevel = 15;
-}
-
 extern void bust_spinlocks(int yes);
 extern void wake_up_klogd(void);
 extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in progress */
@@ -397,7 +284,6 @@ extern int panic_timeout;
 extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
 extern int panic_on_io_nmi;
-extern const char *print_tainted(void);
 extern void add_taint(unsigned flag);
 extern int test_taint(unsigned flag);
 extern unsigned long get_taint(void);
@@ -452,183 +338,6 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 	return buf;
 }
 
-#ifndef pr_fmt
-#define pr_fmt(fmt) fmt
-#endif
-
-#define pr_emerg(fmt, ...) \
-        printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_alert(fmt, ...) \
-        printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_crit(fmt, ...) \
-        printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_err(fmt, ...) \
-        printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warning(fmt, ...) \
-        printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_notice(fmt, ...) \
-        printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_info(fmt, ...) \
-        printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_cont(fmt, ...) \
-	printk(KERN_CONT fmt, ##__VA_ARGS__)
-
-/* pr_devel() should produce zero code unless DEBUG is defined */
-#ifdef DEBUG
-#define pr_devel(fmt, ...) \
-	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
-#else
-#define pr_devel(fmt, ...) \
-	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
-#endif
-
-/* If you are writing a driver, please use dev_dbg instead */
-#if defined(DEBUG)
-#define pr_debug(fmt, ...) \
-	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
-#elif defined(CONFIG_DYNAMIC_DEBUG)
-/* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
-#define pr_debug(fmt, ...) do { \
-	dynamic_pr_debug(fmt, ##__VA_ARGS__); \
-	} while (0)
-#else
-#define pr_debug(fmt, ...) \
-	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
-#endif
-
-/*
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
 /*
  *      Display an IP address in readable format.
  */
diff --git a/include/linux/logging.h b/include/linux/logging.h
new file mode 100644
index 0000000..361d5ed
--- /dev/null
+++ b/include/linux/logging.h
@@ -0,0 +1,313 @@
+#ifndef _LINUX_LOGGING_H
+#define _LINUX_LOGGING_H
+
+#ifdef __KERNEL__
+
+extern const char linux_banner[];
+extern const char linux_proc_banner[];
+
+/*
+ * Defines used for printk logging level
+ */
+
+#define	KERN_EMERG	"<0>"	/* system is unusable			*/
+#define	KERN_ALERT	"<1>"	/* action must be taken immediately	*/
+#define	KERN_CRIT	"<2>"	/* critical conditions			*/
+#define	KERN_ERR	"<3>"	/* error conditions			*/
+#define	KERN_WARNING	"<4>"	/* warning conditions			*/
+#define	KERN_NOTICE	"<5>"	/* normal but significant condition	*/
+#define	KERN_INFO	"<6>"	/* informational			*/
+#define	KERN_DEBUG	"<7>"	/* debug-level messages			*/
+
+/* Use the default kernel loglevel */
+#define KERN_DEFAULT	"<d>"
+/*
+ * Annotation for a "continued" line of log printout (only done after a
+ * line that had no enclosing \n). Only to be used by core/arch code
+ * during early bootup (a continued line is not SMP-safe otherwise).
+ */
+#define	KERN_CONT	"<c>"
+
+/*
+ * Console elements
+ */
+
+extern int console_printk[];
+
+#define console_loglevel		(console_printk[0])
+#define default_message_loglevel	(console_printk[1])
+#define minimum_console_loglevel	(console_printk[2])
+#define default_console_loglevel	(console_printk[3])
+
+static inline void console_silent(void)
+{
+	console_loglevel = 0;
+}
+
+static inline void console_verbose(void)
+{
+	if (console_loglevel)
+		console_loglevel = 15;
+}
+
+/*
+ * FW_BUG
+ * Add this to a message where you are sure the firmware is buggy or behaves
+ * really stupid or out of spec. Be aware that the responsible BIOS developer
+ * should be able to fix this issue or at least get a concrete idea of the
+ * problem by reading your message without the need of looking at the kernel
+ * code.
+ *
+ * Use it for definite and high priority BIOS bugs.
+ *
+ * FW_WARN
+ * Use it for not that clear (e.g. could the kernel messed up things already?)
+ * and medium priority BIOS bugs.
+ *
+ * FW_INFO
+ * Use this one if you want to tell the user or vendor about something
+ * suspicious, but generally harmless related to the firmware.
+ *
+ * Use it for information or very low priority BIOS bugs.
+ */
+#define FW_BUG		"[Firmware Bug]: "
+#define FW_WARN		"[Firmware Warn]: "
+#define FW_INFO		"[Firmware Info]: "
+
+#ifdef CONFIG_PRINTK
+
+asmlinkage int vprintk(const char *fmt, va_list args)
+	__attribute__ ((format (printf, 1, 0)));
+asmlinkage int printk(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) __cold;
+
+extern struct ratelimit_state printk_ratelimit_state;
+extern int printk_ratelimit(void);
+extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
+				   unsigned int interval_msec);
+
+/*
+ * Print a one-time message (analogous to WARN_ONCE() et al):
+ */
+#define printk_once(fmt, ...) \
+({						\
+	static int __print_once = 1;		\
+						\
+	if (__print_once) {			\
+		__print_once = 0;		\
+		printk(fmt, ##__VA_ARGS__);	\
+	}					\
+})
+
+void log_buf_kexec_setup(void);
+
+#else
+
+static inline int vprintk(const char *s, va_list args)
+	__attribute__ ((format (printf, 1, 0)));
+static inline int vprintk(const char *s, va_list args) { return 0; }
+static inline int printk(const char *s, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int __cold printk(const char *s, ...) { return 0; }
+static inline int printk_ratelimit(void) { return 0; }
+static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies,
+					  unsigned int interval_msec)
+{
+	return false;
+}
+
+/* No effect, but we still get type checking even in the !PRINTK case: */
+#define printk_once(fmt, ...) printk(fmt, ##__VA_ARGS__)
+
+static inline void log_buf_kexec_setup(void)
+{
+}
+
+#endif					/* CONFIG_PRINTK */
+
+extern int printk_needs_cpu(int cpu);
+extern void printk_tick(void);
+
+extern void asmlinkage __attribute__((format(printf, 1, 2)))
+	early_printk(const char *fmt, ...);
+
+extern const char *print_tainted(void);
+
+#ifndef pr_fmt
+#define pr_fmt(fmt) fmt
+#endif
+
+#define pr_emerg(fmt, ...)				\
+	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert(fmt, ...)				\
+	printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit(fmt, ...)				\
+	printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err(fmt, ...)				\
+	printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning(fmt, ...)				\
+	printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice(fmt, ...)				\
+	printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info(fmt, ...)				\
+	printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_cont(fmt, ...)				\
+	printk(KERN_CONT fmt, ##__VA_ARGS__)
+
+/* pr_devel() should produce zero code unless DEBUG is defined */
+#ifdef DEBUG
+#define pr_devel(fmt, ...)				\
+	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_devel(fmt, ...)				\
+	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+#endif
+
+/* If you are writing a driver, please use dev_dbg instead */
+#if defined(DEBUG)
+#define pr_debug(fmt, ...)				\
+	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#elif defined(CONFIG_DYNAMIC_DEBUG)
+/* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
+#define pr_debug(fmt, ...)				\
+	do { dynamic_pr_debug(fmt, ##__VA_ARGS__); } while (0)
+#else
+#define pr_debug(fmt, ...)				\
+	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+#endif
+
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
+#endif					/* __KERNEL__ */
+#endif					/* _LINUX_LOGGING_H */
-- 
1.6.3.1.10.g659a0.dirty

