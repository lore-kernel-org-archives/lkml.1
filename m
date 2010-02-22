Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab0BVOTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 09:19:37 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:42598 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab0BVOTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 09:19:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nZUBd0ZF7K/edo1gcmh1LNGzATcxbVywJvMIKqKzTYSILaQcT156cfDIfW818QzcGe
         PfU+8UVZLPcCACvuzeBkqOxhTXVU6+S8cObr8Xc2yx8N859Zr0iRgpwgUKo3DmqgVqkA
         mYgpFK1TtI7Yg64p5JayIppIMWrP6Hk7QzJmk=
Date: Mon, 22 Feb 2010 22:19:18 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       andre.goddard@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 02/06] kernel.h printk/panic/string cleanup
Message-ID: <20100222141918.GA9029@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup kernel.h extern declarations, move printk/panic/string stuff to their
own head files. But due to lots of files need them, include them in kernel.h
for convinience. At least it can be thought as the first step to do the full
cleanup.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/kernel.h |  438 -------------------------------------------------
 include/linux/panic.h  |   35 +++
 include/linux/printk.h |  220 ++++++++++++++++++++++++
 include/linux/string.h |   30 +++
 4 files changed, 288 insertions(+), 435 deletions(-)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/linux/printk.h	2010-02-16 17:25:39.000000000 +0800
@@ -0,0 +1,220 @@
+#ifndef _PRINTK_H
+#define _PRINTK_H
+
+#include <stdarg.h>
+#include <linux/linkage.h>
+#include <linux/types.h>
+#include <linux/dynamic_debug.h>
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
+extern int console_printk[];
+
+#define console_loglevel (console_printk[0])
+#define default_message_loglevel (console_printk[1])
+#define minimum_console_loglevel (console_printk[2])
+#define default_console_loglevel (console_printk[3])
+
+#ifdef CONFIG_PRINTK
+asmlinkage int vprintk(const char *fmt, va_list args)
+	__attribute__ ((format (printf, 1, 0)));
+asmlinkage int printk(const char * fmt, ...)
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
+#ifndef pr_fmt
+#define pr_fmt(fmt) fmt
+#endif
+
+#define pr_emerg(fmt, ...) \
+        printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert(fmt, ...) \
+        printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit(fmt, ...) \
+        printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err(fmt, ...) \
+        printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning(fmt, ...) \
+        printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice(fmt, ...) \
+        printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info(fmt, ...) \
+        printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
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
+#endif
--- linux-2.6.orig/include/linux/kernel.h	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/include/linux/kernel.h	2010-02-16 17:25:39.000000000 +0800
@@ -7,15 +7,15 @@
 
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
+#include <linux/string.h>
+#include <linux/panic.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
@@ -87,31 +87,6 @@ extern const char linux_proc_banner[];
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
@@ -157,47 +132,10 @@ static inline void might_fault(void)
 	might_sleep();
 }
 #endif
-
-extern struct atomic_notifier_head panic_notifier_list;
-extern long (*panic_blink)(long time);
-NORET_TYPE void panic(const char * fmt, ...)
-	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
-extern void oops_enter(void);
-extern void oops_exit(void);
-extern int oops_may_print(void);
 NORET_TYPE void do_exit(long error_code)
 	ATTRIB_NORET;
 NORET_TYPE void complete_and_exit(struct completion *, long)
 	ATTRIB_NORET;
-extern unsigned long simple_strtoul(const char *,char **,unsigned int);
-extern long simple_strtol(const char *,char **,unsigned int);
-extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
-extern long long simple_strtoll(const char *,char **,unsigned int);
-extern int strict_strtoul(const char *, unsigned int, unsigned long *);
-extern int strict_strtol(const char *, unsigned int, long *);
-extern int strict_strtoull(const char *, unsigned int, unsigned long long *);
-extern int strict_strtoll(const char *, unsigned int, long long *);
-extern int sprintf(char * buf, const char * fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int vsprintf(char *buf, const char *, va_list)
-	__attribute__ ((format (printf, 2, 0)));
-extern int snprintf(char * buf, size_t size, const char * fmt, ...)
-	__attribute__ ((format (printf, 3, 4)));
-extern int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
-	__attribute__ ((format (printf, 3, 0)));
-extern int scnprintf(char * buf, size_t size, const char * fmt, ...)
-	__attribute__ ((format (printf, 3, 4)));
-extern int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
-	__attribute__ ((format (printf, 3, 0)));
-extern char *kasprintf(gfp_t gfp, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
-
-extern int sscanf(const char *, const char *, ...)
-	__attribute__ ((format (scanf, 2, 3)));
-extern int vsscanf(const char *, const char *, va_list)
-	__attribute__ ((format (scanf, 2, 0)));
-
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
@@ -210,106 +148,7 @@ extern int func_ptr_is_kernel_text(void 
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
-unsigned long int_sqrt(unsigned long);
-
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
-extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in progress */
-extern int panic_timeout;
-extern int panic_on_oops;
-extern int panic_on_unrecovered_nmi;
-extern int panic_on_io_nmi;
-extern const char *print_tainted(void);
-extern void add_taint(unsigned flag);
-extern int test_taint(unsigned flag);
-extern unsigned long get_taint(void);
 extern int root_mountflags;
 
 /* Values used for system_state */
@@ -322,279 +161,8 @@ extern enum system_states {
 	SYSTEM_SUSPEND_DISK,
 } system_state;
 
-#define TAINT_PROPRIETARY_MODULE	0
-#define TAINT_FORCED_MODULE		1
-#define TAINT_UNSAFE_SMP		2
-#define TAINT_FORCED_RMMOD		3
-#define TAINT_MACHINE_CHECK		4
-#define TAINT_BAD_PAGE			5
-#define TAINT_USER			6
-#define TAINT_DIE			7
-#define TAINT_OVERRIDDEN_ACPI_TABLE	8
-#define TAINT_WARN			9
-#define TAINT_CRAP			10
-
 extern void dump_stack(void) __cold;
 
-enum {
-	DUMP_PREFIX_NONE,
-	DUMP_PREFIX_ADDRESS,
-	DUMP_PREFIX_OFFSET
-};
-extern void hex_dump_to_buffer(const void *buf, size_t len,
-				int rowsize, int groupsize,
-				char *linebuf, size_t linebuflen, bool ascii);
-extern void print_hex_dump(const char *level, const char *prefix_str,
-				int prefix_type, int rowsize, int groupsize,
-				const void *buf, size_t len, bool ascii);
-extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
-			const void *buf, size_t len);
-
-extern const char hex_asc[];
-#define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
-#define hex_asc_hi(x)	hex_asc[((x) & 0xf0) >> 4]
-
-static inline char *pack_hex_byte(char *buf, u8 byte)
-{
-	*buf++ = hex_asc_hi(byte);
-	*buf++ = hex_asc_lo(byte);
-	return buf;
-}
-
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
 /*
  * min()/max()/clamp() macros that also do
  * strict type-checking.. See the
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/linux/panic.h	2010-02-16 17:25:39.000000000 +0800
@@ -0,0 +1,35 @@
+#ifndef _PANIC_H
+#define _PANIC_H
+
+#define TAINT_PROPRIETARY_MODULE	0
+#define TAINT_FORCED_MODULE		1
+#define TAINT_UNSAFE_SMP		2
+#define TAINT_FORCED_RMMOD		3
+#define TAINT_MACHINE_CHECK		4
+#define TAINT_BAD_PAGE			5
+#define TAINT_USER			6
+#define TAINT_DIE			7
+#define TAINT_OVERRIDDEN_ACPI_TABLE	8
+#define TAINT_WARN			9
+#define TAINT_CRAP			10
+
+extern struct atomic_notifier_head panic_notifier_list;
+extern long (*panic_blink)(long time);
+NORET_TYPE void panic(const char * fmt, ...)
+	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
+extern void oops_enter(void);
+extern void oops_exit(void);
+extern int oops_may_print(void);
+extern const char *print_tainted(void);
+extern void add_taint(unsigned flag);
+extern int test_taint(unsigned flag);
+extern unsigned long get_taint(void);
+/* If oops_in_progress is set,
+an oops, panic(), BUG() or die() is in progress */
+extern int oops_in_progress;
+extern int panic_timeout;
+extern int panic_on_oops;
+extern int panic_on_unrecovered_nmi;
+extern int panic_on_io_nmi;
+
+#endif
--- linux-2.6.orig/include/linux/string.h	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/include/linux/string.h	2010-02-16 17:25:39.000000000 +0800
@@ -142,5 +142,35 @@ static inline bool strstarts(const char 
 {
 	return strncmp(str, prefix, strlen(prefix)) == 0;
 }
+
+extern unsigned long simple_strtoul(const char *,char **,unsigned int);
+extern long simple_strtol(const char *,char **,unsigned int);
+extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
+extern long long simple_strtoll(const char *,char **,unsigned int);
+extern int strict_strtoul(const char *, unsigned int, unsigned long *);
+extern int strict_strtol(const char *, unsigned int, long *);
+extern int strict_strtoull(const char *, unsigned int, unsigned long long *);
+extern int strict_strtoll(const char *, unsigned int, long long *);
+extern int sprintf(char * buf, const char * fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern int vsprintf(char *buf, const char *, va_list)
+	__attribute__ ((format (printf, 2, 0)));
+extern int snprintf(char * buf, size_t size, const char * fmt, ...)
+	__attribute__ ((format (printf, 3, 4)));
+extern int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 3, 0)));
+extern int scnprintf(char * buf, size_t size, const char * fmt, ...)
+	__attribute__ ((format (printf, 3, 4)));
+extern int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 3, 0)));
+extern char *kasprintf(gfp_t gfp, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
+
+extern int sscanf(const char *, const char *, ...)
+	__attribute__ ((format (scanf, 2, 3)));
+extern int vsscanf(const char *, const char *, va_list)
+	__attribute__ ((format (scanf, 2, 0)));
 #endif
+
 #endif /* _LINUX_STRING_H_ */
