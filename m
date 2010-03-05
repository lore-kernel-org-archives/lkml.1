Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab0CEG5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 01:57:15 -0500
Received: from mail.perches.com ([173.55.12.10]:1417 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab0CEG46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 01:56:58 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] kernel.h kernel/printk.c: Convert pr_<level> macros to functions
Date: Thu,  4 Mar 2010 22:56:54 -0800
Message-Id: <1c74bc55ad2850559b2a3952914e3735f38023e1.1267771398.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1267771398.git.joe@perches.com>
References: <cover.1267771398.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save ~1K of duplicated KERN_<level> strings

Use %pV and struct va_format
Format arguments are verified before printk

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |   70 +++++++++++++++++++++++++++++++++++++-----------
 kernel/printk.c        |   26 ++++++++++++++++++
 2 files changed, 80 insertions(+), 16 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 0eae8e9..2bba3d6 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -255,6 +255,22 @@ asmlinkage int vprintk(const char *fmt, va_list args)
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
@@ -283,6 +299,30 @@ static inline int vprintk(const char *s, va_list args) { return 0; }
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
 static inline int printk_ratelimit(void) { return 0; }
 static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 					  unsigned int interval_msec)	\
@@ -381,22 +421,20 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 #define pr_fmt(fmt) fmt
 #endif
 
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
+#define pr_emerg(fmt, ...)			\
+	pr_emerg(pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert(fmt, ...)			\
+	pr_alert(pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit(fmt, ...)			\
+	pr_crit(pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err(fmt, ...)			\
+	pr_err(pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning(fmt, ...)			\
+	pr_warning(pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice(fmt, ...)			\
+	pr_notice(pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info(fmt, ...)			\
+	pr_info(pr_fmt(fmt), ##__VA_ARGS__)
 
 /* pr_devel() should produce zero code unless DEBUG is defined */
 #ifdef DEBUG
diff --git a/kernel/printk.c b/kernel/printk.c
index 4067412..83b6299 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -797,6 +797,32 @@ out_restore_irqs:
 EXPORT_SYMBOL(printk);
 EXPORT_SYMBOL(vprintk);
 
+#define declare_pr_level(function, level)		\
+asmlinkage int function(const char *fmt, ...)		\
+{							\
+	struct va_format vaf;				\
+	va_list args;					\
+	int r;						\
+							\
+	va_start(args, fmt);				\
+	vaf.fmt = fmt;					\
+	vaf.va = &args;					\
+	r = printk(level "%pV", &vaf);			\
+	va_end(args);					\
+							\
+	return r;					\
+}							\
+EXPORT_SYMBOL(function)
+
+declare_pr_level(pr_emerg,	KERN_EMERG);
+declare_pr_level(pr_alert,	KERN_ALERT);
+declare_pr_level(pr_crit,	KERN_CRIT);
+declare_pr_level(pr_err,	KERN_ERR);
+declare_pr_level(pr_warning,	KERN_WARNING);
+declare_pr_level(pr_notice,	KERN_NOTICE);
+declare_pr_level(pr_info,	KERN_INFO);
+declare_pr_level(pr_cont,	KERN_CONT);
+
 #else
 
 static void call_console_drivers(unsigned start, unsigned end)
-- 
1.7.0.14.g7e948

