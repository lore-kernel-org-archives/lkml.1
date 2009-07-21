Return-Path: <linux-kernel-owner+w=401wt.eu-S1751135AbZGUEfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135AbZGUEfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 00:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973AbZGUEfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 00:35:15 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4945 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZGUEfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 00:35:13 -0400
From: Joe Perches <joe@perches.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>,
       Denis Turischev <denis@compulab.co.il>,
       Andrey Panin <pazke@centrinvest.ru>
Subject: [PATCH 1/3] include/linux: kernel.h dynamic_debug.h device.h - Use section fmts
Date: Mon, 20 Jul 2009 21:35:00 -0700
Message-Id: <8fa27cdd7fe563f4d7830cf42e2afa8333bcdf44.1248148947.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <4A6492EB.1080709@compulab.co.il>
References: <4A6492EB.1080709@compulab.co.il>
In-Reply-To: <cover.1248148947.git.joe@perches.com>
References: <cover.1248148947.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow printk format strings to be placed into specific sections

({const char section __fmt[] = fmt; printk(__fmt, ...); })

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/device.h        |    4 +++
 include/linux/dynamic_debug.h |   34 +++++++++++++++++++++++++-
 include/linux/kernel.h        |   51 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index aebb810..badabb2 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -554,6 +554,10 @@ extern void sysdev_shutdown(void);
 
 /* debugging and troubleshooting/diagnostic helpers. */
 extern const char *dev_driver_string(const struct device *dev);
+
+#define dev_printk_section(section, level, dev, format, arg...)		\
+	printk_section(section, level "%s %s: " format,			\
+		       dev_driver_string(dev), dev_name(dev), ##arg)
 #define dev_printk(level, dev, format, arg...)	\
 	printk(level "%s %s: " format , dev_driver_string(dev) , \
 	       dev_name(dev) , ## arg)
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index a0d9422..f5a00de 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -74,6 +74,30 @@ extern int ddebug_remove_module(char *mod_name);
 					##__VA_ARGS__);			\
 	} while (0)
 
+#define dynamic_pr_debug_section(section, fmt, ...) do {		\
+	static struct _ddebug descriptor				\
+	__used								\
+	__attribute__((section("__verbose"), aligned(8))) =		\
+	{ KBUILD_MODNAME, __func__, __FILE__, fmt, DEBUG_HASH,		\
+		DEBUG_HASH2, __LINE__, _DPRINTK_FLAGS_DEFAULT };	\
+	if (__dynamic_dbg_enabled(descriptor))				\
+		printk_section(section,					\
+			       KERN_DEBUG KBUILD_MODNAME ":" pr_fmt(fmt), \
+			       ##__VA_ARGS__);				\
+	} while (0)
+
+
+#define dynamic_dev_dbg_section(section, dev, fmt, ...) do {		\
+	static struct _ddebug descriptor				\
+	__used								\
+	__attribute__((section("__verbose"), aligned(8))) =		\
+	{ KBUILD_MODNAME, __func__, __FILE__, fmt, DEBUG_HASH,		\
+		DEBUG_HASH2, __LINE__, _DPRINTK_FLAGS_DEFAULT };	\
+	if (__dynamic_dbg_enabled(descriptor))				\
+		dev_printk_section(section, KERN_DEBUG, dev,		\
+				   KBUILD_MODNAME ": " fmt, ##__VA_ARGS__); \
+	} while (0)
+
 #else
 
 static inline int ddebug_remove_module(char *mod)
@@ -81,8 +105,14 @@ static inline int ddebug_remove_module(char *mod)
 	return 0;
 }
 
-#define dynamic_pr_debug(fmt, ...)  do { } while (0)
-#define dynamic_dev_dbg(dev, format, ...)  do { } while (0)
+#define dynamic_pr_debug(fmt, ...)					\
+	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+#define dynamic_dev_dbg(dev, format, ...)				\
+	({ if (0) dev_printk(KERN_DEBUG, dev, format, ##__VA_ARGS__); 0; })
+#define dynamic_pr_debug_section(section, fmt, ...)			\
+	({ if (0) printk_section(section, KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+#define dynamic_dev_dbg_section(section, dev, format, ...)		\
+	({ if (0) dev_printk_section(section, KERN_DEBUG, dev, format, ##__VA_ARGS__); 0; })
 #endif
 
 #endif
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d6320a3..2afb826 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -404,6 +404,57 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 #endif
 
 /*
+ * Special section printks, put the format string in a particular data section
+ */
+#define printk_section(section, fmt, ...)				\
+	({ static const section char __fmt[] = fmt;			\
+		printk(__fmt, ##__VA_ARGS__); })
+
+#define pr_emerg_section(section, fmt, ...)				\
+	printk_section(section, KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert_section(section, fmt, ...)				\
+        printk_section(section, KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit_section(section, fmt, ...)				\
+        printk_section(section, KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err_section(section, fmt, ...)				\
+        printk_section(section, KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning_section(section, fmt, ...)				\
+        printk_section(section, KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice_section(section, fmt, ...)				\
+        printk_section(section, KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info_section(section, fmt, ...)				\
+        printk_section(section, KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_cont_section(section, fmt, ...)				\
+	printk_section(section, KERN_CONT fmt, ##__VA_ARGS__)
+
+/* pr_devel() should produce zero code unless DEBUG is defined */
+#ifdef DEBUG
+#define pr_devel_section(section, fmt, ...)				\
+	printk_section(section, KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_devel_section(fmt, ...)					\
+	({ if (0)							\
+		printk_section(section, KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);\
+	0; })
+#endif
+
+/* If you are writing a driver, please use dev_dbg instead */
+#if defined(DEBUG)
+#define pr_debug_section(section, fmt, ...)				\
+	printk_section(section, KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#elif defined(CONFIG_DYNAMIC_DEBUG)
+/* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
+#define pr_debug_section(section, fmt, ...) do {	\
+		dynamic_pr_debug(fmt, ##__VA_ARGS__);	\
+	} while (0)
+#else
+#define pr_debug_section(fmt, ...)					\
+	({ if (0)							\
+		printk_section(section, KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);\
+	0; })
+#endif
+
+/*
  * General tracing related utility functions - trace_printk(),
  * tracing_on/tracing_off and tracing_start()/tracing_stop
  *
-- 
1.6.3.1.10.g659a0.dirty

