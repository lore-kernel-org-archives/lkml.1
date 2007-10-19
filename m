Return-Path: <linux-kernel-owner+w=401wt.eu-S1764231AbXJSB4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764231AbXJSB4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 21:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759710AbXJSB4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 21:56:38 -0400
Received: from lixom.net ([66.141.50.11]:52585 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759541AbXJSB4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 21:56:38 -0400
Date: Thu, 18 Oct 2007 21:03:05 -0500
From: Olof Johansson <olof@lixom.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, paulus@ozlabs.org, lethal@linux-sh.org,
       kyle@parisc-linux.org, grundler@parisc-linux.org,
       linux-arch@vger.kernel.org
Subject: [PATCH v2] [1/2] bug.h: Remove HAVE_ARCH_BUG.* / HAVE_ARCH_WARN.*
Message-ID: <20071019020305.GA28359@lixom.net>
References: <20071011171211.GB10877@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011171211.GB10877@lixom.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No need to have the HAVE_ARCH_BUG.* / HAVE_ARCH_WARN.* defines, when
the generic implementation can just use #ifndef on the macros themselves.

Also, introduce __WARN() in the generic case, so the generic WARN_ON()
can use arch-specific code for when the condition is true.

Built on powerpc, i386, sh and sparc64.


Signed-off-by: Olof Johansson <olof@lixom.net>

Index: k.org/include/asm-generic/bug.h
===================================================================
--- k.org.orig/include/asm-generic/bug.h
+++ k.org/include/asm-generic/bug.h
@@ -20,39 +20,44 @@ struct bug_entry {
 #define BUGFLAG_WARNING	(1<<0)
 #endif	/* CONFIG_GENERIC_BUG */
 
-#ifndef HAVE_ARCH_BUG
+#ifndef BUG
 #define BUG() do { \
 	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
 	panic("BUG!"); \
 } while (0)
 #endif
 
-#ifndef HAVE_ARCH_BUG_ON
+#ifndef BUG_ON
 #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
 #endif
 
-#ifndef HAVE_ARCH_WARN_ON
+#ifndef __WARN
+#define __WARN() do {							\
+	printk("WARNING: at %s:%d %s()\n", __FILE__,			\
+		__LINE__, __FUNCTION__);				\
+	dump_stack();							\
+} while (0)
+#endif
+
+#ifndef WARN_ON
 #define WARN_ON(condition) ({						\
 	int __ret_warn_on = !!(condition);				\
-	if (unlikely(__ret_warn_on)) {					\
-		printk("WARNING: at %s:%d %s()\n", __FILE__,		\
-			__LINE__, __FUNCTION__);			\
-		dump_stack();						\
-	}								\
+	if (unlikely(__ret_warn_on))					\
+		__WARN();						\
 	unlikely(__ret_warn_on);					\
 })
 #endif
 
 #else /* !CONFIG_BUG */
-#ifndef HAVE_ARCH_BUG
+#ifndef BUG
 #define BUG()
 #endif
 
-#ifndef HAVE_ARCH_BUG_ON
+#ifndef BUG_ON
 #define BUG_ON(condition) do { if (condition) ; } while(0)
 #endif
 
-#ifndef HAVE_ARCH_WARN_ON
+#ifndef WARN_ON
 #define WARN_ON(condition) ({						\
 	int __ret_warn_on = !!(condition);				\
 	unlikely(__ret_warn_on);					\
Index: k.org/include/asm-parisc/bug.h
===================================================================
--- k.org.orig/include/asm-parisc/bug.h
+++ k.org/include/asm-parisc/bug.h
@@ -7,8 +7,6 @@
  */
 
 #ifdef CONFIG_BUG
-#define HAVE_ARCH_BUG
-#define HAVE_ARCH_WARN_ON
 
 /* the break instruction is used as BUG() marker.  */
 #define	PARISC_BUG_BREAK_ASM	"break 0x1f, 0x1fff"
Index: k.org/include/asm-powerpc/bug.h
===================================================================
--- k.org.orig/include/asm-powerpc/bug.h
+++ k.org/include/asm-powerpc/bug.h
@@ -109,9 +109,6 @@
 	unlikely(__ret_warn_on);				\
 })
 
-#define HAVE_ARCH_BUG
-#define HAVE_ARCH_BUG_ON
-#define HAVE_ARCH_WARN_ON
 #endif /* __ASSEMBLY __ */
 #endif /* CONFIG_BUG */
 
Index: k.org/include/asm-sh/bug.h
===================================================================
--- k.org.orig/include/asm-sh/bug.h
+++ k.org/include/asm-sh/bug.h
@@ -4,8 +4,6 @@
 #define TRAPA_BUG_OPCODE	0xc33e	/* trapa #0x3e */
 
 #ifdef CONFIG_BUG
-#define HAVE_ARCH_BUG
-#define HAVE_ARCH_WARN_ON
 
 /**
  * _EMIT_BUG_ENTRY
Index: k.org/include/asm-alpha/bug.h
===================================================================
--- k.org.orig/include/asm-alpha/bug.h
+++ k.org/include/asm-alpha/bug.h
@@ -10,7 +10,6 @@
   __asm__ __volatile__("call_pal %0  # bugchk\n\t"".long %1\n\t.8byte %2" \
 		       : : "i" (PAL_bugchk), "i"(__LINE__), "i"(__FILE__))
 
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
Index: k.org/include/asm-arm/bug.h
===================================================================
--- k.org.orig/include/asm-arm/bug.h
+++ k.org/include/asm-arm/bug.h
@@ -16,7 +16,6 @@ extern void __bug(const char *file, int 
 
 #endif
 
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
Index: k.org/include/asm-avr32/bug.h
===================================================================
--- k.org.orig/include/asm-avr32/bug.h
+++ k.org/include/asm-avr32/bug.h
@@ -63,9 +63,6 @@
 		unlikely(__ret_warn_on);				\
 	})
 
-#define HAVE_ARCH_BUG
-#define HAVE_ARCH_WARN_ON
-
 #endif /* CONFIG_BUG */
 
 #include <asm-generic/bug.h>
Index: k.org/include/asm-frv/bug.h
===================================================================
--- k.org.orig/include/asm-frv/bug.h
+++ k.org/include/asm-frv/bug.h
@@ -32,7 +32,6 @@ do {						\
 	asm volatile("nop");			\
 } while(0)
 
-#define HAVE_ARCH_BUG
 #define BUG()					\
 do {						\
 	_debug_bug_printk();			\
Index: k.org/include/asm-ia64/bug.h
===================================================================
--- k.org.orig/include/asm-ia64/bug.h
+++ k.org/include/asm-ia64/bug.h
@@ -6,7 +6,6 @@
 #define BUG() do { printk("kernel BUG at %s:%d!\n", __FILE__, __LINE__); ia64_abort(); } while (0)
 
 /* should this BUG be made generic? */
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
Index: k.org/include/asm-m68k/bug.h
===================================================================
--- k.org.orig/include/asm-m68k/bug.h
+++ k.org/include/asm-m68k/bug.h
@@ -21,7 +21,6 @@
 } while (0)
 #endif
 
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
Index: k.org/include/asm-mips/bug.h
===================================================================
--- k.org.orig/include/asm-mips/bug.h
+++ k.org/include/asm-mips/bug.h
@@ -12,8 +12,6 @@ do {									\
 	__asm__ __volatile__("break %0" : : "i" (BRK_BUG));		\
 } while (0)
 
-#define HAVE_ARCH_BUG
-
 #if (_MIPS_ISA > _MIPS_ISA_MIPS1)
 
 #define BUG_ON(condition)						\
@@ -22,8 +20,6 @@ do {									\
 			     : : "r" (condition), "i" (BRK_BUG));	\
 } while (0)
 
-#define HAVE_ARCH_BUG_ON
-
 #endif /* _MIPS_ISA > _MIPS_ISA_MIPS1 */
 
 #endif
Index: k.org/include/asm-s390/bug.h
===================================================================
--- k.org.orig/include/asm-s390/bug.h
+++ k.org/include/asm-s390/bug.h
@@ -61,8 +61,6 @@
 	unlikely(__ret_warn_on);			\
 })
 
-#define HAVE_ARCH_BUG
-#define HAVE_ARCH_WARN_ON
 #endif /* CONFIG_BUG */
 
 #include <asm-generic/bug.h>
Index: k.org/include/asm-sh64/bug.h
===================================================================
--- k.org.orig/include/asm-sh64/bug.h
+++ k.org/include/asm-sh64/bug.h
@@ -11,7 +11,6 @@
 	*(volatile int *)0 = 0; \
 } while (0)
 
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
Index: k.org/include/asm-sparc/bug.h
===================================================================
--- k.org.orig/include/asm-sparc/bug.h
+++ k.org/include/asm-sparc/bug.h
@@ -26,7 +26,6 @@ extern void do_BUG(const char *file, int
 #define BUG()		__bug_trap()
 #endif
 
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
Index: k.org/include/asm-sparc64/bug.h
===================================================================
--- k.org.orig/include/asm-sparc64/bug.h
+++ k.org/include/asm-sparc64/bug.h
@@ -14,7 +14,6 @@ extern void do_BUG(const char *file, int
 #define BUG()		__builtin_trap()
 #endif
 
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
Index: k.org/include/asm-v850/bug.h
===================================================================
--- k.org.orig/include/asm-v850/bug.h
+++ k.org/include/asm-v850/bug.h
@@ -17,7 +17,6 @@
 #ifdef CONFIG_BUG
 extern void __bug (void) __attribute__ ((noreturn));
 #define BUG()		__bug()
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
Index: k.org/include/asm-x86/bug.h
===================================================================
--- k.org.orig/include/asm-x86/bug.h
+++ k.org/include/asm-x86/bug.h
@@ -2,7 +2,6 @@
 #define _ASM_X86_BUG_H
 
 #ifdef CONFIG_BUG
-#define HAVE_ARCH_BUG
 
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 
