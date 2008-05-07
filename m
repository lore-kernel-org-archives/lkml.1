Return-Path: <linux-kernel-owner+w=401wt.eu-S1762764AbYEGGVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762764AbYEGGVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 02:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756126AbYEGGV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 02:21:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41785 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbYEGGV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 02:21:26 -0400
Date: Tue, 6 May 2008 23:21:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch 2/3] Add a WARN() macro; this is WARN_ON() + printk
 arguments
Message-ID: <20080506232113.7f066c26@infradead.org>
In-Reply-To: <20080506232017.247001e0@infradead.org>
References: <20080506232017.247001e0@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Add a WARN() macro; this is WARN_ON() + printk arguments
From: Arjan van de Ven <arjan@linux.intel.com>

Add a WARN() macro that acts like WARN_ON(), with the added feature that
it takes a printk like argument that is printed as part of the warning
message.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/asm-generic/bug.h |   16 ++++++++++++++++
 kernel/panic.c            |   24 ++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 2632328..dcefa5e 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -34,9 +34,13 @@ struct bug_entry {
 #ifndef __WARN
 #ifndef __ASSEMBLY__
 extern void warn_on_slowpath(const char *file, const int line);
+extern void warn_slowpath(const char *file, const int line, const char *fmt, ...);
 #define WANT_WARN_ON_SLOWPATH
 #endif
 #define __WARN() warn_on_slowpath(__FILE__, __LINE__)
+#define __WARN_printf(arg...) warn_slowpath(__FILE__, __LINE__, arg)
+#else
+#define __WARN_printf(arg...) __WARN()
 #endif
 
 #ifndef WARN_ON
@@ -48,6 +52,18 @@ extern void warn_on_slowpath(const char *file, const int line);
 })
 #endif
 
+#ifndef WARN
+#define WARN(condition, format...) ({						\
+	int __ret_warn_on = !!(condition);				\
+	if (unlikely(__ret_warn_on))					\
+		__WARN_printf(format);					\
+	unlikely(__ret_warn_on);					\
+})
+#endif
+
+
+
+
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
 #define BUG()
diff --git a/kernel/panic.c b/kernel/panic.c
index 425567f..3e0c36b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -318,6 +318,30 @@ void warn_on_slowpath(const char *file, int line)
 	add_taint(TAINT_WARN);
 }
 EXPORT_SYMBOL(warn_on_slowpath);
+
+
+void warn_slowpath(const char *file, int line, const char *fmt, ...)
+{
+	va_list args;
+
+
+	char function[KSYM_SYMBOL_LEN];
+	unsigned long caller = (unsigned long) __builtin_return_address(0);
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
-- 
1.5.4.5


