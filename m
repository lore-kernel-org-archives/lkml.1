Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383Ab0BYPjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:39:13 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:55967 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab0BYPjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:39:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lOYyHJEdfo/I8FnZD0EHGHBp7JR6omghzLMDUoC6GMBUk7uBZRMia+M1JS3mvgG3vM
         b+8BxgY6OsiPOTqnzvIsr/beCseBXDwFnyALPsU8o85GPA0zM3xFCbr3bpvyxGhftaf4
         4xYBoWLkAu9ApmdHonh2Pgl45XIwZ07xoJA+M=
Date: Thu, 25 Feb 2010 23:39:02 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/07] kernel.h printk cleanup
Message-ID: <20100225153901.GA2660@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup kernel.h printk related extern declarations, move to linux/printk.h

But due to lots of files need them, include printk.h in kernel.h just
for convinience. It can be thought as the first step of further cleanup. 

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/kernel.h |  215 -----------------------------------------------
 include/linux/printk.h |  221 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 222 insertions(+), 214 deletions(-)

--- linux-2.6.orig/include/linux/kernel.h	2010-02-25 20:41:26.000000000 +0800
+++ linux-2.6/include/linux/kernel.h	2010-02-25 20:43:08.000000000 +0800
@@ -7,15 +7,13 @@
 
 #ifdef __KERNEL__
 
-#include <stdarg.h>
-#include <linux/linkage.h>
 #include <linux/stddef.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/bitops.h>
 #include <linux/log2.h>
 #include <linux/typecheck.h>
-#include <linux/dynamic_debug.h>
+#include <linux/printk.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
@@ -87,31 +85,6 @@ extern const char linux_proc_banner[];
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
@@ -210,97 +183,9 @@ extern int func_ptr_is_kernel_text(void 
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
-extern int __printk_ratelimit(const char *func);
-#define printk_ratelimit() __printk_ratelimit(__func__)
-extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
-				   unsigned int interval_msec);
-
-extern int printk_delay_msec;
-
-/*
- * Print a one-time message (analogous to WARN_ONCE() et al):
- */
-#define printk_once(x...) ({			\
-	static bool __print_once;		\
-						\
-	if (!__print_once) {			\
-		__print_once = true;		\
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
-extern void wake_up_klogd(void);
 extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in progress */
 extern int panic_timeout;
 extern int panic_on_oops;
@@ -361,93 +246,6 @@ static inline char *pack_hex_byte(char *
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
-#define pr_debug(fmt, ...) \
-	dynamic_pr_debug(fmt, ##__VA_ARGS__)
-#else
-#define pr_debug(fmt, ...) \
-	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
-#endif
-
-/*
- * ratelimited messages with local ratelimit_state,
- * no local ratelimit_state used in the !PRINTK case
- */
-#ifdef CONFIG_PRINTK
-#define printk_ratelimited(fmt, ...)  ({		\
-	static struct ratelimit_state _rs = {		\
-		.interval = DEFAULT_RATELIMIT_INTERVAL, \
-		.burst = DEFAULT_RATELIMIT_BURST,       \
-	};                                              \
-							\
-	if (!__ratelimit(&_rs))                         \
-		printk(fmt, ##__VA_ARGS__);		\
-})
-#else
-/* No effect, but we still get type checking even in the !PRINTK case: */
-#define printk_ratelimited printk
-#endif
-
-#define pr_emerg_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_alert_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_crit_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_err_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warning_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_notice_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_info_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
-/* no pr_cont_ratelimited, don't do that... */
-/* If you are writing a driver, please use dev_dbg instead */
-#if defined(DEBUG)
-#define pr_debug_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
-#else
-#define pr_debug_ratelimited(fmt, ...) \
-	({ if (0) printk_ratelimited(KERN_DEBUG pr_fmt(fmt), \
-				     ##__VA_ARGS__); 0; })
-#endif
-
 /*
  * General tracing related utility functions - trace_printk(),
  * tracing_on/tracing_off and tracing_start()/tracing_stop
@@ -585,17 +383,6 @@ static inline void ftrace_dump(void) { }
 #endif /* CONFIG_TRACING */
 
 /*
- *      Display an IP address in readable format.
- */
-
-#define NIPQUAD(addr) \
-	((unsigned char *)&addr)[0], \
-	((unsigned char *)&addr)[1], \
-	((unsigned char *)&addr)[2], \
-	((unsigned char *)&addr)[3]
-#define NIPQUAD_FMT "%u.%u.%u.%u"
-
-/*
  * min()/max()/clamp() macros that also do
  * strict type-checking.. See the
  * "unnecessary" pointer comparison.
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/linux/printk.h	2010-02-25 20:44:48.000000000 +0800
@@ -0,0 +1,221 @@
+#ifndef _PRINTK_H
+#define _PRINTK_H
+
+#include <stdarg.h>
+#include <linux/linkage.h>
+#include <linux/types.h>
+#include <linux/dynamic_debug.h>
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
+extern int console_printk[];
+
+#define console_loglevel (console_printk[0])
+#define default_message_loglevel (console_printk[1])
+#define minimum_console_loglevel (console_printk[2])
+#define default_console_loglevel (console_printk[3])
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
+asmlinkage int vprintk(const char *fmt, va_list args)
+	__attribute__ ((format (printf, 1, 0)));
+asmlinkage int printk(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) __cold;
+
+extern int __printk_ratelimit(const char *func);
+#define printk_ratelimit() __printk_ratelimit(__func__)
+extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
+				   unsigned int interval_msec);
+
+extern int printk_delay_msec;
+
+/*
+ * Print a one-time message (analogous to WARN_ONCE() et al):
+ */
+#define printk_once(x...) ({			\
+	static bool __print_once;		\
+						\
+	if (!__print_once) {			\
+		__print_once = true;		\
+		printk(x);			\
+	}					\
+})
+
+void log_buf_kexec_setup(void);
+#else
+static inline int vprintk(const char *s, va_list args)
+	__attribute__ ((format (printf, 1, 0)));
+static inline int vprintk(const char *s, va_list args) { return 0; }
+static inline int printk(const char *s, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int __cold printk(const char *s, ...) { return 0; }
+static inline int printk_ratelimit(void) { return 0; }
+static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
+					  unsigned int interval_msec)	\
+		{ return false; }
+
+/* No effect, but we still get type checking even in the !PRINTK case: */
+#define printk_once(x...) printk(x)
+
+static inline void log_buf_kexec_setup(void)
+{
+}
+#endif
+
+extern int printk_needs_cpu(int cpu);
+extern void printk_tick(void);
+
+extern void asmlinkage __attribute__((format(printf, 1, 2)))
+	early_printk(const char *fmt, ...);
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
+extern void wake_up_klogd(void);
+
+/*
+ *      Display an IP address in readable format.
+ */
+
+#define NIPQUAD(addr) \
+	((unsigned char *)&addr)[0], \
+	((unsigned char *)&addr)[1], \
+	((unsigned char *)&addr)[2], \
+	((unsigned char *)&addr)[3]
+#define NIPQUAD_FMT "%u.%u.%u.%u"
+
+#ifndef pr_fmt
+#define pr_fmt(fmt) fmt
+#endif
+
+#define pr_emerg(fmt, ...) \
+	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert(fmt, ...) \
+	printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit(fmt, ...) \
+	printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err(fmt, ...) \
+	printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning(fmt, ...) \
+	printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice(fmt, ...) \
+	printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info(fmt, ...) \
+	printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_cont(fmt, ...) \
+	printk(KERN_CONT fmt, ##__VA_ARGS__)
+
+/* pr_devel() should produce zero code unless DEBUG is defined */
+#ifdef DEBUG
+#define pr_devel(fmt, ...) \
+	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_devel(fmt, ...) \
+	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+#endif
+
+/* If you are writing a driver, please use dev_dbg instead */
+#if defined(DEBUG)
+#define pr_debug(fmt, ...) \
+	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#elif defined(CONFIG_DYNAMIC_DEBUG)
+/* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
+#define pr_debug(fmt, ...) \
+	dynamic_pr_debug(fmt, ##__VA_ARGS__)
+#else
+#define pr_debug(fmt, ...) \
+	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+#endif
+
+/*
+ * ratelimited messages with local ratelimit_state,
+ * no local ratelimit_state used in the !PRINTK case
+ */
+#ifdef CONFIG_PRINTK
+#define printk_ratelimited(fmt, ...)  ({		\
+	static struct ratelimit_state _rs = {		\
+		.interval = DEFAULT_RATELIMIT_INTERVAL, \
+		.burst = DEFAULT_RATELIMIT_BURST,       \
+	};                                              \
+							\
+	if (!__ratelimit(&_rs))                         \
+		printk(fmt, ##__VA_ARGS__);		\
+})
+#else
+/* No effect, but we still get type checking even in the !PRINTK case: */
+#define printk_ratelimited printk
+#endif
+
+#define pr_emerg_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+/* no pr_cont_ratelimited, don't do that... */
+/* If you are writing a driver, please use dev_dbg instead */
+#if defined(DEBUG)
+#define pr_debug_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_debug_ratelimited(fmt, ...) \
+	({ if (0) printk_ratelimited(KERN_DEBUG pr_fmt(fmt), \
+				     ##__VA_ARGS__); 0; })
+#endif
+
+#endif
