Return-Path: <linux-kernel-owner+w=401wt.eu-S1761793AbZLPILu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761793AbZLPILu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761765AbZLPILj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:11:39 -0500
Received: from mail.perches.com ([173.55.12.10]:1209 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761759AbZLPIJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:09:16 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/14] kernel.h: Add pr_<level>_once
Date: Wed, 16 Dec 2009 00:09:11 -0800
Message-Id: <cb48f39b4c87bfa310739e3da38ba1871b7a563e.1260949674.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1260949674.git.joe@perches.com>
References: <cover.1260949674.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate the define and use of printk_once near printk_ratelimited
Add pr_<level>_once macros that use pr_fmt(fmt)
A little alignment neatening

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |  105 +++++++++++++++++++++++++++++++----------------
 1 files changed, 69 insertions(+), 36 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e079744..7d7f7e2 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -434,19 +434,6 @@ extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 
 extern int printk_delay_msec;
 
-/*
- * Print a one-time message (analogous to WARN_ONCE() et al):
- */
-#define printk_once(fmt, ...)			\
-({						\
-	static bool __print_once;		\
-						\
-	if (!__print_once) {			\
-		__print_once = true;		\
-		printk(fmt, ##__VA_ARGS__);	\
-	}					\
-})
-
 void log_buf_kexec_setup(void);
 #else
 static inline int vprintk(const char *s, va_list args)
@@ -462,9 +449,6 @@ static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 	return false;
 }
 
-/* No effect, but we still get type checking even in the !PRINTK case: */
-#define printk_once(fmt, ...) printk(fmt, ##__VA_ARGS__)
-
 static inline void log_buf_kexec_setup(void)
 {
 }
@@ -514,26 +498,26 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 #define pr_fmt(fmt) fmt
 #endif
 
-#define pr_emerg(fmt, ...)				\
+#define pr_emerg(fmt, ...)					\
 	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_alert(fmt, ...)				\
+#define pr_alert(fmt, ...)					\
 	printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_crit(fmt, ...)				\
+#define pr_crit(fmt, ...)					\
 	printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_err(fmt, ...)				\
+#define pr_err(fmt, ...)					\
 	printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warning(fmt, ...)				\
+#define pr_warning(fmt, ...)					\
 	printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_notice(fmt, ...)				\
+#define pr_notice(fmt, ...)					\
 	printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_info(fmt, ...)				\
+#define pr_info(fmt, ...)					\
 	printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_cont(fmt, ...)				\
+#define pr_cont(fmt, ...)					\
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
 /* pr_devel() should produce zero code unless DEBUG is defined */
 #ifdef DEBUG
-#define pr_devel(fmt, ...)				\
+#define pr_devel(fmt, ...)					\
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
 #define pr_devel(fmt, ...)					\
@@ -546,11 +530,11 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
-#define pr_debug(fmt, ...)				\
+#define pr_debug(fmt, ...)					\
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #elif defined(CONFIG_DYNAMIC_DEBUG)
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
-#define pr_debug(fmt, ...)				\
+#define pr_debug(fmt, ...)					\
 	dynamic_pr_debug(fmt, ##__VA_ARGS__)
 #else
 #define pr_debug(fmt, ...)					\
@@ -562,19 +546,68 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 #endif
 
 /*
+ * Print a one-time message (analogous to WARN_ONCE() et al):
+ * no local state used in the !PRINTK case
+ */
+#ifdef CONFIG_PRINTK
+#define printk_once(fmt, ...)					\
+({								\
+	static bool __print_once;				\
+								\
+	if (!__print_once) {					\
+		__print_once = true;				\
+		printk(fmt, ##__VA_ARGS__);			\
+	}							\
+})
+
+#else
+/* No effect, but we still get type checking even in the !PRINTK case: */
+#define printk_once(fmt, ...) printk(fmt, ##__VA_ARGS__)
+#endif
+
+#define pr_emerg_once(fmt, ...)					\
+	printk_once(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert_once(fmt, ...)					\
+	printk_once(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit_once(fmt, ...)					\
+	printk_once(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err_once(fmt, ...)					\
+	printk_once(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning_once(fmt, ...)				\
+	printk_once(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice_once(fmt, ...)				\
+	printk_once(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info_once(fmt, ...)					\
+	printk_once(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+/* no pr_cont_once, don't do that... */
+/* If you are writing a driver, please use dev_dbg instead */
+#if defined(DEBUG)
+#define pr_debug_once(fmt, ...)					\
+	printk_once(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_debug_once(fmt, ...)					\
+({								\
+	if (0)							\
+		printk_once(KERN_DEBUG pr_fmt(fmt),		\
+				   ##__VA_ARGS__);		\
+	0;							\
+})
+#endif
+
+/*
  * ratelimited messages with local ratelimit_state,
  * no local ratelimit_state used in the !PRINTK case
  */
 #ifdef CONFIG_PRINTK
-#define printk_ratelimited(fmt, ...)			\
-({							\
-	static struct ratelimit_state _rs = {		\
-		.interval = DEFAULT_RATELIMIT_INTERVAL, \
-		.burst = DEFAULT_RATELIMIT_BURST,       \
-	};                                              \
-							\
-	if (!__ratelimit(&_rs))                         \
-		printk(fmt, ##__VA_ARGS__);		\
+#define printk_ratelimited(fmt, ...)				\
+({								\
+	static struct ratelimit_state _rs = {			\
+		.interval = DEFAULT_RATELIMIT_INTERVAL,		\
+		.burst = DEFAULT_RATELIMIT_BURST,		\
+	};							\
+								\
+	if (!__ratelimit(&_rs))					\
+		printk(fmt, ##__VA_ARGS__);			\
 })
 #else
 /* No effect, but we still get type checking even in the !PRINTK case: */
-- 
1.6.6.rc0.57.gad7a

