Return-Path: <linux-kernel-owner+w=401wt.eu-S1765098AbXGSKAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765098AbXGSKAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbXGSJzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:00 -0400
Received: from ns.suse.de ([195.135.220.2]:35342 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979AbXGSJy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:54:58 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: jh@suse.cz, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [11/58] x86: Support __attribute__((__cold__)) in gcc 4.3
Message-Id: <20070719095455.A8C6714E05@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:54:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


gcc 4.3 supports a new __attribute__((__cold__)) to mark functions cold. Any 
path directly leading to a call of this function will be unlikely. And gcc
will try to generate smaller code for the function itself.

Please use with care. The code generation advantage isn't large and in most
cases it is not worth uglifying code with this.

This patch marks some common error functions like panic(), printk(), BUG()
as cold.  This will longer term make many unlikely()s unnecessary, although
we can keep them for now for older compilers.

Also all __init and __exit functions are marked cold. With a non -Os
build this will tell the compiler to generate slightly smaller code
for them. I think it currently only uses less alignments for labels,
but that might change in the future.

One disadvantage over *likely() is that they cannot be easily instrumented 
to verify them.

Another drawback is that only the latest gcc 4.3 snapshots support this. 
Unfortunately we cannot detect this using the preprocessor. This means older 
snapshots will fail now. I don't think that's a problem because they are 
unreleased compilers that nobody should be using.

gcc also has a __hot__ attribute, but I don't see any sense in using
this in the kernel right now. But someday I hope gcc will be able
to use more aggressive optimizing for hot functions even in -Os,
if that happens it should be added.

Includes compile fix from Thomas Gleixner.

TBD wait for COLD()

Cc: jh@suse.cz
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-generic/bug.h     |    1 +
 include/asm-i386/bug.h        |    4 ++++
 include/asm-x86_64/bug.h      |    8 ++++++--
 include/linux/compiler-gcc4.h |   23 +++++++++++++++++++++++
 include/linux/compiler.h      |   12 ++++++++++++
 include/linux/init.h          |    8 ++++----
 include/linux/kernel.h        |    8 ++++----
 7 files changed, 54 insertions(+), 10 deletions(-)

Index: linux/include/asm-generic/bug.h
===================================================================
--- linux.orig/include/asm-generic/bug.h
+++ linux/include/asm-generic/bug.h
@@ -22,6 +22,7 @@ struct bug_entry {
 
 #ifndef HAVE_ARCH_BUG
 #define BUG() do { \
+	COLD(); \
 	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
 	panic("BUG!"); \
 } while (0)
Index: linux/include/asm-i386/bug.h
===================================================================
--- linux.orig/include/asm-i386/bug.h
+++ linux/include/asm-i386/bug.h
@@ -10,9 +10,12 @@
 #ifdef CONFIG_BUG
 #define HAVE_ARCH_BUG
 
+#include <linux/compiler.h>
+
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 #define BUG()								\
 	do {								\
+		COLD();							\
 		asm volatile("1:\tud2\n"				\
 			     ".pushsection __bug_table,\"a\"\n"		\
 			     "2:\t.long 1b, %c0\n"			\
@@ -27,6 +30,7 @@
 #else
 #define BUG()								\
 	do {								\
+		COLD();							\
 		asm volatile("ud2");					\
 		for(;;) ;						\
 	} while(0)
Index: linux/include/asm-x86_64/bug.h
===================================================================
--- linux.orig/include/asm-x86_64/bug.h
+++ linux/include/asm-x86_64/bug.h
@@ -4,9 +4,12 @@
 #ifdef CONFIG_BUG
 #define HAVE_ARCH_BUG
 
+#include <linux/compiler.h>
+
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 #define BUG()								\
 	do {								\
+		COLD();							\
 		asm volatile("1:\tud2\n"				\
 			     ".pushsection __bug_table,\"a\"\n"		\
 			     "2:\t.quad 1b, %c0\n"			\
@@ -20,14 +23,15 @@
 #else
 #define BUG()								\
 	do {								\
+		COLD();							\
 		asm volatile("ud2");					\
 		for(;;) ;						\
 	} while(0)
 #endif
 
-void out_of_line_bug(void);
+void out_of_line_bug(void) __cold;
 #else
-static inline void out_of_line_bug(void) { }
+static inline void out_of_line_bug(void) __cold { }
 #endif
 
 #include <asm-generic/bug.h>
Index: linux/include/linux/compiler-gcc4.h
===================================================================
--- linux.orig/include/linux/compiler-gcc4.h
+++ linux/include/linux/compiler-gcc4.h
@@ -23,3 +23,26 @@
  * code
  */
 #define uninitialized_var(x) x = x
+
+#if !(__GNUC__ == 4 && __GNUC_MINOR__ < 3)
+/* Mark functions as cold. gcc will assume any path leading to a call
+   to them will be unlikely.  This means a lot of manual unlikely()s
+   are unnecessary now for any paths leading to the usual suspects
+   like BUG(), printk(), panic() etc. [but let's keep them for now for
+   older compilers]
+
+   Early snapshots of gcc 4.3 don't support this and we can't detect this
+   in the preprocessor, but we can live with this because they're unreleased.
+   Maketime probing would be overkill here.
+
+   gcc also has a __attribute__((__hot__)) to move hot functions into
+   a special section, but I don't see any sense in this right now in
+   the kernel context */
+#define __cold			__attribute__((__cold__))
+
+/* Use this to mark a path cold that isn't a function call
+   Use with care. The code generation advantage isn't large and it is rarely
+   worth it to uglify your code with this. */
+static inline void __cold cold_inline(void) {}
+#define COLD()			cold_inline();
+#endif
Index: linux/include/linux/compiler.h
===================================================================
--- linux.orig/include/linux/compiler.h
+++ linux/include/linux/compiler.h
@@ -174,4 +174,16 @@ extern void __chk_io_ptr(const void __io
 # define __attribute_const__	/* unimplemented */
 #endif
 
+/*
+ * Tell gcc if a function is cold. The compiler will assume any path
+ * directly leading to the call is unlikely.
+ */
+
+#ifndef __cold
+#define __cold
+#endif
+#ifndef COLD
+#define COLD() do {} while (0)
+#endif
+
 #endif /* __LINUX_COMPILER_H */
Index: linux/include/linux/init.h
===================================================================
--- linux.orig/include/linux/init.h
+++ linux/include/linux/init.h
@@ -40,10 +40,10 @@
 
 /* These are for everybody (although not all archs will actually
    discard it in modules) */
-#define __init		__attribute__ ((__section__ (".init.text")))
+#define __init		__attribute__ ((__section__ (".init.text"))) __cold
 #define __initdata	__attribute__ ((__section__ (".init.data")))
 #define __exitdata	__attribute__ ((__section__(".exit.data")))
-#define __exit_call	__attribute_used__ __attribute__ ((__section__ (".exitcall.exit")))
+#define __exit_call	__attribute_used__ __attribute__ ((__section__ (".exitcall.exit"))) __cold
 
 /* modpost check for section mismatches during the kernel build.
  * A section mismatch happens when there are references from a
@@ -59,9 +59,9 @@
 #define __initdata_refok          __attribute__ ((__section__ (".data.init.refok")))
 
 #ifdef MODULE
-#define __exit		__attribute__ ((__section__(".exit.text")))
+#define __exit		__attribute__ ((__section__(".exit.text"))) __cold
 #else
-#define __exit		__attribute_used__ __attribute__ ((__section__(".exit.text")))
+#define __exit		__attribute_used__ __attribute__ ((__section__(".exit.text"))) __cold
 #endif
 
 /* For assembly routines */
Index: linux/include/linux/kernel.h
===================================================================
--- linux.orig/include/linux/kernel.h
+++ linux/include/linux/kernel.h
@@ -106,7 +106,7 @@ extern int cond_resched(void);
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
 NORET_TYPE void panic(const char * fmt, ...)
-	__attribute__ ((NORET_AND format (printf, 1, 2)));
+	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
@@ -155,14 +155,14 @@ extern void dump_thread(struct pt_regs *
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
 asmlinkage int printk(const char * fmt, ...)
-	__attribute__ ((format (printf, 1, 2)));
+	__attribute__ ((format (printf, 1, 2))) __cold;
 #else
 static inline int vprintk(const char *s, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
 static inline int vprintk(const char *s, va_list args) { return 0; }
 static inline int printk(const char *s, ...)
 	__attribute__ ((format (printf, 1, 2)));
-static inline int printk(const char *s, ...) { return 0; }
+static inline int __cold printk(const char *s, ...) { return 0; }
 #endif
 
 unsigned long int_sqrt(unsigned long);
@@ -212,7 +212,7 @@ extern enum system_states {
 #define TAINT_USER			(1<<6)
 #define TAINT_DIE			(1<<7)
 
-extern void dump_stack(void);
+extern void dump_stack(void) __cold;
 
 enum {
 	DUMP_PREFIX_NONE,
