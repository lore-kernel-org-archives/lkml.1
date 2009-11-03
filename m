Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbZKCKHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbZKCKHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbZKCKHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:07:37 -0500
Received: from mxout-08.mxes.net ([216.86.168.183]:46931 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153AbZKCKHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:07:36 -0500
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: greg@kroah.com
Cc: linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 03/10] module: extract __EXPORT_SYMBOL from module.h into mod_export.h
Date: Tue,  3 Nov 2009 10:06:15 +0000
Message-Id: <1257242782-10496-4-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new header mod_export.h allows __EXPORT_SYMBOL to be used without
pulling in any function or variable declarations.  It will be used by
the build system to help sort the list of symbols exported by the
kernel.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 include/linux/mod_export.h |   73 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/module.h     |   63 +-------------------------------------
 2 files changed, 74 insertions(+), 62 deletions(-)
 create mode 100644 include/linux/mod_export.h

diff --git a/include/linux/mod_export.h b/include/linux/mod_export.h
new file mode 100644
index 0000000..3d80057
--- /dev/null
+++ b/include/linux/mod_export.h
@@ -0,0 +1,73 @@
+#ifndef LINUX_MOD_EXPORT_H
+#define LINUX_MOD_EXPORT_H
+
+#include <linux/compiler.h>
+#include <asm/module.h>
+
+/* some toolchains uses a `_' prefix for all user symbols */
+#ifndef MODULE_SYMBOL_PREFIX
+#define MODULE_SYMBOL_PREFIX ""
+#endif
+
+struct kernel_symbol {
+	unsigned long value;
+	const char *name;
+};
+
+#ifdef CONFIG_MODULES
+#ifndef __GENKSYMS__
+#ifdef CONFIG_MODVERSIONS
+/* Mark the CRC weak since genksyms apparently decides not to
+ * generate a checksums for some symbols */
+#define __CRC_SYMBOL(sym, sec)					\
+	extern void *__crc_##sym __attribute__((weak));		\
+	static const unsigned long __kcrctab_##sym		\
+	__used							\
+	__attribute__((section("__kcrctab" sec), unused))	\
+	= (unsigned long) &__crc_##sym;
+#else
+#define __CRC_SYMBOL(sym, sec)
+#endif
+
+/* For every exported symbol, place a struct in the __ksymtab section */
+#define __EXPORT_SYMBOL(sym, sec)				\
+	extern typeof(sym) sym;					\
+	__CRC_SYMBOL(sym, sec)					\
+	static const char __kstrtab_##sym[]			\
+	__attribute__((section("__ksymtab_strings"), aligned(1))) \
+	= MODULE_SYMBOL_PREFIX #sym;                    	\
+	static const struct kernel_symbol __ksymtab_##sym	\
+	__used							\
+	__attribute__((section("__ksymtab" sec), unused))	\
+	= { (unsigned long)&sym, __kstrtab_##sym }
+
+#define EXPORT_SYMBOL(sym)					\
+	__EXPORT_SYMBOL(sym, "")
+
+#define EXPORT_SYMBOL_GPL(sym)					\
+	__EXPORT_SYMBOL(sym, "_gpl")
+
+#define EXPORT_SYMBOL_GPL_FUTURE(sym)				\
+	__EXPORT_SYMBOL(sym, "_gpl_future")
+
+#ifdef CONFIG_UNUSED_SYMBOLS
+#define EXPORT_UNUSED_SYMBOL(sym) __EXPORT_SYMBOL(sym, "_unused")
+#define EXPORT_UNUSED_SYMBOL_GPL(sym) __EXPORT_SYMBOL(sym, "_unused_gpl")
+#else
+#define EXPORT_UNUSED_SYMBOL(sym)
+#define EXPORT_UNUSED_SYMBOL_GPL(sym)
+#endif
+
+#endif /* __GENKSYMS__ */
+
+#else /* !CONFIG_MODULES */
+
+#define EXPORT_SYMBOL(sym)
+#define EXPORT_SYMBOL_GPL(sym)
+#define EXPORT_SYMBOL_GPL_FUTURE(sym)
+#define EXPORT_UNUSED_SYMBOL(sym)
+#define EXPORT_UNUSED_SYMBOL_GPL(sym)
+
+#endif /* CONFIG_MODULES */
+
+#endif /* LINUX_MOD_EXPORT_H */
diff --git a/include/linux/module.h b/include/linux/module.h
index 482efc8..b9e860a 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -15,6 +15,7 @@
 #include <linux/stringify.h>
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
+#include <linux/mod_export.h>
 #include <linux/tracepoint.h>
 
 #include <asm/local.h>
@@ -25,19 +26,8 @@
 /* Not Yet Implemented */
 #define MODULE_SUPPORTED_DEVICE(name)
 
-/* some toolchains uses a `_' prefix for all user symbols */
-#ifndef MODULE_SYMBOL_PREFIX
-#define MODULE_SYMBOL_PREFIX ""
-#endif
-
 #define MODULE_NAME_LEN MAX_PARAM_PREFIX_LEN
 
-struct kernel_symbol
-{
-	unsigned long value;
-	const char *name;
-};
-
 struct modversion_info
 {
 	unsigned long crc;
@@ -178,52 +168,6 @@ void *__symbol_get(const char *symbol);
 void *__symbol_get_gpl(const char *symbol);
 #define symbol_get(x) ((typeof(&x))(__symbol_get(MODULE_SYMBOL_PREFIX #x)))
 
-#ifndef __GENKSYMS__
-#ifdef CONFIG_MODVERSIONS
-/* Mark the CRC weak since genksyms apparently decides not to
- * generate a checksums for some symbols */
-#define __CRC_SYMBOL(sym, sec)					\
-	extern void *__crc_##sym __attribute__((weak));		\
-	static const unsigned long __kcrctab_##sym		\
-	__used							\
-	__attribute__((section("__kcrctab" sec), unused))	\
-	= (unsigned long) &__crc_##sym;
-#else
-#define __CRC_SYMBOL(sym, sec)
-#endif
-
-/* For every exported symbol, place a struct in the __ksymtab section */
-#define __EXPORT_SYMBOL(sym, sec)				\
-	extern typeof(sym) sym;					\
-	__CRC_SYMBOL(sym, sec)					\
-	static const char __kstrtab_##sym[]			\
-	__attribute__((section("__ksymtab_strings"), aligned(1))) \
-	= MODULE_SYMBOL_PREFIX #sym;                    	\
-	static const struct kernel_symbol __ksymtab_##sym	\
-	__used							\
-	__attribute__((section("__ksymtab" sec), unused))	\
-	= { (unsigned long)&sym, __kstrtab_##sym }
-
-#define EXPORT_SYMBOL(sym)					\
-	__EXPORT_SYMBOL(sym, "")
-
-#define EXPORT_SYMBOL_GPL(sym)					\
-	__EXPORT_SYMBOL(sym, "_gpl")
-
-#define EXPORT_SYMBOL_GPL_FUTURE(sym)				\
-	__EXPORT_SYMBOL(sym, "_gpl_future")
-
-
-#ifdef CONFIG_UNUSED_SYMBOLS
-#define EXPORT_UNUSED_SYMBOL(sym) __EXPORT_SYMBOL(sym, "_unused")
-#define EXPORT_UNUSED_SYMBOL_GPL(sym) __EXPORT_SYMBOL(sym, "_unused_gpl")
-#else
-#define EXPORT_UNUSED_SYMBOL(sym)
-#define EXPORT_UNUSED_SYMBOL_GPL(sym)
-#endif
-
-#endif
-
 enum module_state
 {
 	MODULE_STATE_LIVE,
@@ -541,11 +485,6 @@ extern void module_update_tracepoints(void);
 extern int module_get_iter_tracepoints(struct tracepoint_iter *iter);
 
 #else /* !CONFIG_MODULES... */
-#define EXPORT_SYMBOL(sym)
-#define EXPORT_SYMBOL_GPL(sym)
-#define EXPORT_SYMBOL_GPL_FUTURE(sym)
-#define EXPORT_UNUSED_SYMBOL(sym)
-#define EXPORT_UNUSED_SYMBOL_GPL(sym)
 
 /* Given an address, look for it in the exception tables. */
 static inline const struct exception_table_entry *
-- 
1.6.3.2

