Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbYGHRCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbYGHRCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbYGHQ6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:58:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:55166 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772AbYGHQ6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:58:09 -0400
Date: Tue, 8 Jul 2008 09:40:23 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu
Subject: [patch 2/17] Add a WARN() macro that acts like WARN_ON()+printk
Message-ID: <20080708094023.260a31bb@infradead.org>
In-Reply-To: <20080708093800.274504ba@infradead.org>
References: <20080708093800.274504ba@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

Add a WARN() macro that acts like WARN_ON(), with the added feature that it
takes a printk like argument that is printed as part of the warning message.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |   32 ++++++++++++++++++++++++++++++++
 kernel/panic.c            |   22 ++++++++++++++++++++++
 2 files changed, 54 insertions(+)

Index: linux.trees.git/include/asm-generic/bug.h
===================================================================
--- linux.trees.git.orig/include/asm-generic/bug.h
+++ linux.trees.git/include/asm-generic/bug.h
@@ -34,9 +34,14 @@ struct bug_entry {
 #ifndef __WARN
 #ifndef __ASSEMBLY__
 extern void warn_on_slowpath(const char *file, const int line);
+extern void warn_slowpath(const char *file, const int line,
+		const char *fmt, ...) __attribute__((format(printf, 3, 4)));
 #define WANT_WARN_ON_SLOWPATH
 #endif
 #define __WARN() warn_on_slowpath(__FILE__, __LINE__)
+#define __WARN_printf(arg...) warn_slowpath(__FILE__, __LINE__, arg)
+#else
+#define __WARN_printf(arg...) __WARN()
 #endif
 
 #ifndef WARN_ON
@@ -48,6 +53,15 @@ extern void warn_on_slowpath(const char 
 })
 #endif
 
+#ifndef WARN
+#define WARN(condition, format...) ({					\
+	int __ret_warn_on = !!(condition);				\
+	if (unlikely(__ret_warn_on))					\
+		__WARN_printf(format);					\
+	unlikely(__ret_warn_on);					\
+})
+#endif
+
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
 #define BUG()
@@ -63,6 +77,14 @@ extern void warn_on_slowpath(const char 
 	unlikely(__ret_warn_on);					\
 })
 #endif
+
+#ifndef WARN
+#define WARN(condition, format...) ({					\
+	int __ret_warn_on = !!(condition);				\
+	unlikely(__ret_warn_on);					\
+})
+#endif
+
 #endif
 
 #define WARN_ON_ONCE(condition)	({				\
@@ -75,6 +97,16 @@ extern void warn_on_slowpath(const char 
 	unlikely(__ret_warn_once);				\
 })
 
+#define WARN_ONCE(condition, format...)	({			\
+	static int __warned;					\
+	int __ret_warn_once = !!(condition);			\
+								\
+	if (unlikely(__ret_warn_once))				\
+		if (WARN(!__warned, format)) 			\
+			__warned = 1;				\
+	unlikely(__ret_warn_once);				\
+})
+
 #ifdef CONFIG_SMP
 # define WARN_ON_SMP(x)			WARN_ON(x)
 #else
Index: linux.trees.git/kernel/panic.c
===================================================================
--- linux.trees.git.orig/kernel/panic.c
+++ linux.trees.git/kernel/panic.c
@@ -321,6 +321,28 @@ void warn_on_slowpath(const char *file, 
 	add_taint(TAINT_WARN);
 }
 EXPORT_SYMBOL(warn_on_slowpath);
+
+
+void warn_slowpath(const char *file, int line, const char *fmt, ...)
+{
+	va_list args;
+	char function[KSYM_SYMBOL_LEN];
+	unsigned long caller = (unsigned long)__builtin_return_address(0);
+	sprint_symbol(function, caller);
+
+	printk(KERN_WARNING "------------[ cut here ]------------\n");
+	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
+		line, function);
+	va_start(args, fmt);
+	vprintk(fmt, args);
+	va_end(args);
+
+	print_modules();
+	dump_stack();
+	print_oops_end_marker();
+	add_taint(TAINT_WARN);
+}
+EXPORT_SYMBOL(warn_slowpath);
 #endif
 
 #ifdef CONFIG_CC_STACKPROTECTOR
