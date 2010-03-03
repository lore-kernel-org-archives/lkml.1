Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab0CCPUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:20:21 -0500
Received: from mail.perches.com ([173.55.12.10]:1329 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab0CCPUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:20:19 -0500
Subject: [RFC PATCH] printk: Convert pr_<level> macros to functions
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 07:20:18 -0800
Message-ID: <1267629618.8926.73.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk is defined asmlinkage (extern "C")
For this RFC patch, pr_<level> calls are as well.
Is this declaration style really necessary?
Maybe moving printed_len to file scope is racy somehow?

Save 3 bytes per pr_<level> use after printk overhead

Does not store the KERN_<level> string as constant string
when using pr_<level> calls

printk.o increases ~200 bytes
defconfig decreases ~700 bytes

Minor printk neatening, moving comments above function declaration
Renamed vprint to __vprintk, added vprintk wrapper
Moved automatic printed_len to file static
Moved EXPORT_SYMBOL after functions

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |   57 ++++++++++++--
 kernel/printk.c        |  195 +++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 206 insertions(+), 46 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 1221d23..afb7b03 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -240,6 +240,22 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
 asmlinkage int printk(const char * fmt, ...)
 	__attribute__ ((format (printf, 1, 2))) __cold;
+asmlinkage int pr_emerg(const char *s, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int pr_crit(const char *s, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int pr_alert(const char *s, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int pr_err(const char *s, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int pr_warning(const char *s, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int pr_notice(const char *s, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int pr_info(const char *s, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int pr_cont(const char *s, ...)
+	__attribute__ ((format (printf, 1, 2)));
 
 extern int __printk_ratelimit(const char *func);
 #define printk_ratelimit() __printk_ratelimit(__func__)
@@ -268,6 +284,31 @@ static inline int vprintk(const char *s, va_list args) { return 0; }
 static inline int printk(const char *s, ...)
 	__attribute__ ((format (printf, 1, 2)));
 static inline int __cold printk(const char *s, ...) { return 0; }
+static inline int pr_emerg(const char *s, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int pr_emerg(const char *s, ...) { return 0; }
+static inline int pr_crit(const char *s, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int pr_crit(const char *s, ...) { return 0; }
+static inline int pr_alert(const char *s, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int pr_alert(const char *s, ...) { return 0; }
+static inline int pr_err(const char *s, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int pr_err(const char *s, ...) { return 0; }
+static inline int pr_warning(const char *s, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int pr_warning(const char *s, ...) { return 0; }
+static inline int pr_notice(const char *s, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int pr_notice(const char *s, ...) { return 0; }
+static inline int pr_info(const char *s, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int pr_info(const char *s, ...) { return 0; }
+static inline int pr_cont(const char *s, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int pr_cont(const char *s, ...) { return 0; }
+
 static inline int printk_ratelimit(void) { return 0; }
 static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 					  unsigned int interval_msec)	\
@@ -367,21 +408,19 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 #endif
 
 #define pr_emerg(fmt, ...) \
-        printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+	pr_emerg(pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_alert(fmt, ...) \
-        printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+	pr_alert(pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_crit(fmt, ...) \
-        printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+	pr_crit(pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_err(fmt, ...) \
-        printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+	pr_err(pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_warning(fmt, ...) \
-        printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+	pr_warning(pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_notice(fmt, ...) \
-        printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+	pr_notice(pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_info(fmt, ...) \
-        printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_cont(fmt, ...) \
-	printk(KERN_CONT fmt, ##__VA_ARGS__)
+	pr_info(pr_fmt(fmt), ##__VA_ARGS__)
 
 /* pr_devel() should produce zero code unless DEBUG is defined */
 #ifdef DEBUG
diff --git a/kernel/printk.c b/kernel/printk.c
index 1751c45..2868bff 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -566,40 +566,6 @@ static int have_callable_console(void)
 	return 0;
 }
 
-/**
- * printk - print a kernel message
- * @fmt: format string
- *
- * This is printk().  It can be called from any context.  We want it to work.
- *
- * We try to grab the console_sem.  If we succeed, it's easy - we log the output and
- * call the console drivers.  If we fail to get the semaphore we place the output
- * into the log buffer and return.  The current holder of the console_sem will
- * notice the new output in release_console_sem() and will send it to the
- * consoles before releasing the semaphore.
- *
- * One effect of this deferred printing is that code which calls printk() and
- * then changes console_loglevel may break. This is because console_loglevel
- * is inspected when the actual printing occurs.
- *
- * See also:
- * printf(3)
- *
- * See the vsnprintf() documentation for format string extensions over C99.
- */
-
-asmlinkage int printk(const char *fmt, ...)
-{
-	va_list args;
-	int r;
-
-	va_start(args, fmt);
-	r = vprintk(fmt, args);
-	va_end(args);
-
-	return r;
-}
-
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int printk_cpu = UINT_MAX;
 
@@ -654,6 +620,7 @@ static const char recursion_bug_msg [] =
 static int recursion_bug;
 static int new_text_line = 1;
 static char printk_buf[1024];
+static int printed_len;
 
 int printk_delay_msec __read_mostly;
 
@@ -669,9 +636,8 @@ static inline void printk_delay(void)
 	}
 }
 
-asmlinkage int vprintk(const char *fmt, va_list args)
+static asmlinkage int __vprintk(const char *fmt, va_list args)
 {
-	int printed_len = 0;
 	int current_log_level = default_message_loglevel;
 	unsigned long flags;
 	int this_cpu;
@@ -800,9 +766,164 @@ out_restore_irqs:
 	preempt_enable();
 	return printed_len;
 }
-EXPORT_SYMBOL(printk);
+
+asmlinkage int vprintk(const char *fmt, va_list args)
+{
+	printed_len = 0;
+	return __vprintk(fmt, args);
+}
 EXPORT_SYMBOL(vprintk);
 
+/**
+ * printk - print a kernel message
+ * @fmt: format string
+ *
+ * This is printk().  It can be called from any context.  We want it to work.
+ *
+ * We try to grab the console_sem.
+ * If we succeed, it's easy - we log the output and call the console drivers.
+ * If we fail to get the semaphore we place the output into the log buffer
+ * and return.  The current holder of the console_sem will notice the new
+ * output in release_console_sem() and will send it to the consoles before
+ * releasing the semaphore.
+ *
+ * One effect of this deferred printing is that code which calls printk() and
+ * then changes console_loglevel may break. This is because console_loglevel
+ * is inspected when the actual printing occurs.
+ *
+ * See also:
+ * printf(3)
+ *
+ * See the vsnprintf() documentation for format string extensions over C99.
+ */
+
+asmlinkage int printk(const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+	r = vprintk(fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(printk);
+
+static int pr_printk(char level, const char *fmt, va_list args)
+{
+	printk_buf[0] = '<';
+	printk_buf[1] = level;
+	printk_buf[2] = '>';
+	printed_len = 3;
+	return __vprintk(fmt, args);
+}
+
+asmlinkage int pr_emerg(const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+	r = pr_printk('0', fmt, args);
+	r = __vprintk(fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(pr_emerg);
+
+asmlinkage int pr_alert(const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+	r = pr_printk('1', fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(pr_alert);
+
+asmlinkage int pr_crit(const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+	r = pr_printk('2', fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(pr_crit);
+
+asmlinkage int pr_err(const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+	r = pr_printk('3', fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(pr_err);
+
+asmlinkage int pr_warning(const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+	r = pr_printk('4', fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(pr_warning);
+
+asmlinkage int pr_notice(const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+	r = pr_printk('5', fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(pr_notice);
+
+asmlinkage int pr_info(const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+	r = pr_printk('6', fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(pr_info);
+
+asmlinkage int pr_cont(const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+	r = pr_printk('c', fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(pr_cont);
+
 #else
 
 static void call_console_drivers(unsigned start, unsigned end)
-- 
1.7.0.14.g7e948



