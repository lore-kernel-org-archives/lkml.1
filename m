Return-Path: <linux-kernel-owner+w=401wt.eu-S1422650AbXBVAXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422650AbXBVAXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161172AbXBVAXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:23:48 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:58548 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161146AbXBVAXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:23:47 -0500
Date: Wed, 21 Feb 2007 19:18:28 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@redhat.com>, systemtap@sources.redhat.com,
       ltt-dev@shafik.org, Karim Yaghmour <karim.yaghmour@kryptiva.com>
Subject: [PATCH] Linux Kernel Markers - cleanup
Message-ID: <20070222001828.GB3767@Krystal>
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca> <1171224209195-git-send-email-mathieu.desnoyers@polymtl.ca> <20070214231635.091c7169.akpm@linux-foundation.org> <20070215190919.GA31359@Krystal> <45D61361.6030200@kryptiva.com> <20070216233825.GB28087@Krystal> <45DCA6E1.7080903@kryptiva.com> <20070221204535.GA616@Krystal> <45DCC24B.4040204@kryptiva.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <45DCC24B.4040204@kryptiva.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 17:47:16 up 19 days, 12:55,  3 users,  load average: 1.82, 1.80, 1.82
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Markers - cleanup

- Keep a positive CONFIG_MARKERS_ENABLE_OPTIMIZATION for Makefile.
- Have CONFIG_MARKERS_DISABLE_OPTIMIZATION depending on EMBEDDED shown
  in the menus.
- CONFIG_MARKERS_ENABLE_OPTIMIZATION depends on
       !CONFIG_MARKERS_DISABLE_OPTIMIZATION and defaults to y (hidden)
         (suggested by Martin Bligh)
- GEN_MARK is now declared in linux/marker.h
- asm-generic/marker.h is now only used as a fallback defining MARK as GEN_MARK
- New MARK_NO_TRAP defined for each architecture.
  asm-generic : defined as GEN_MARK
  asm-i386 : defined as GEN_MARK
  asm-powerpc : defined as MARK (because we don't need to use trap for XMC)
- Remove ugly ifdefs SOME_RANDOM_ARCH in architecture agnostic code

It applies on top of the
linux-kernel-markers-architecture-independant-code-license-fix patch.

Compiles on
arm
i686 (markers enabled, markers disabled)
ia64
m68k
mips
mipsel
powerpc 405
powerpc 970
s390
sparc (except link error not related to markers)
sparc64
x86_64

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/i386/kernel/marker.c
+++ b/arch/i386/kernel/marker.c
@@ -56,7 +56,7 @@ static struct notifier_block mark_notify = {
 	.priority = 0x7fffffff,	/* we need to be notified first */
 };
 
-int arch_marker_set_ins_enable(void *address, char enable)
+int marker_set_ins_enable(void *address, char enable)
 {
 	char saved_byte;
 	int ret;
@@ -91,4 +91,4 @@ int arch_marker_set_ins_enable(void *address, char enable)
 	flush_icache_range(address, size);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(arch_marker_set_ins_enable);
+EXPORT_SYMBOL_GPL(marker_set_ins_enable);
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -92,3 +92,4 @@ obj-$(CONFIG_PPC64)		+= $(obj64-y)
 
 extra-$(CONFIG_PPC_FPU)		+= fpu.o
 extra-$(CONFIG_PPC64)		+= entry_64.o
+obj-$(CONFIG_MARKERS_ENABLE_OPTIMIZATION)	+= marker.o
--- /dev/null
+++ b/arch/powerpc/kernel/marker.c
@@ -0,0 +1,24 @@
+/* marker.c
+ *
+ * Powerpc optimized marker enabling/disabling.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/module.h>
+#include <linux/marker.h>
+#include <linux/string.h>
+#include <asm/cacheflush.h>
+
+int marker_set_ins_enable(void *address, char enable)
+{
+	char newi[MARK_ENABLE_IMMEDIATE_OFFSET+1];
+	int size = MARK_ENABLE_IMMEDIATE_OFFSET+sizeof(MARK_ENABLE_TYPE);
+
+	memcpy(newi, address, size);
+	MARK_ENABLE(&newi[0]) = enable;
+	memcpy(address, newi, size);
+	flush_icache_range((unsigned long)address, size);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(marker_set_ins_enable);
--- a/include/asm-generic/marker.h
+++ b/include/asm-generic/marker.h
@@ -1,3 +1,6 @@
+#ifndef _ASM_GENERIC_MARKER_H
+#define _ASM_GENERIC_MARKER_H
+
 /*
  * marker.h
  *
@@ -10,31 +13,17 @@
  * "used" attribute to fix a gcc 4.1.x bug.
  */
 
-#ifdef CONFIG_MARKERS
-
-#define GEN_MARK(name, format, args...) \
-	do { \
-		static marker_probe_func *__mark_call_##name = \
-					__mark_empty_function; \
-		static char __marker_enable_##name = 0; \
-		static const struct __mark_marker_c __mark_c_##name \
-			__attribute__((section(".markers.c"))) = \
-			{ #name, &__mark_call_##name, format, \
-			MARKER_GENERIC } ; \
-		static const struct __mark_marker __mark_##name \
-			__attribute__((section(".markers"))) = \
-			{ &__mark_c_##name, &__marker_enable_##name } ; \
-		asm volatile ( "" : : "i" (&__mark_##name)); \
-		__mark_check_format(format, ## args); \
-		if (unlikely(__marker_enable_##name)) { \
-			preempt_disable(); \
-			(*__mark_call_##name)(format, ## args); \
-			preempt_enable(); \
-		} \
-	} while (0)
+#include <linux/errno.h>
 
+#define MARK				GEN_MARK
+#define MARK_NO_TRAP			GEN_MARK
+#define MARK_ENABLE_TYPE		GEN_MARK_ENABLE_TYPE
+#define MARK_ENABLE_IMMEDIATE_OFFSET	GEN_MARK_ENABLE_IMMEDIATE_OFFSET
+#define MARK_ENABLE			GEN_MARK_ENABLE
 
-#define GEN_MARK_ENABLE_IMMEDIATE_OFFSET 0
-#define GEN_MARK_ENABLE_TYPE char
+static inline int marker_set_ins_enable(void *address, char enable)
+{
+	return -ENOSYS;
+}
 
-#endif
+#endif /* _ASM_GENERIC_MARKER_H */
--- a/include/asm-i386/marker.h
+++ b/include/asm-i386/marker.h
@@ -36,12 +36,15 @@
 		} \
 	} while (0)
 
+#define MARK_NO_TRAP GEN_MARK
 /* Offset of the immediate value from the start of the movb instruction, in
  * bytes. */
 #define MARK_ENABLE_IMMEDIATE_OFFSET 1
 #define MARK_ENABLE_TYPE char
-#define MARK_POLYMORPHIC
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define MARK_ENABLE(a) \
+	*(MARK_ENABLE_TYPE*)((char*)a+MARK_ENABLE_IMMEDIATE_OFFSET)
 
-extern int arch_marker_set_ins_enable(void *address, char enable);
+extern int marker_set_ins_enable(void *address, char enable);
 
 #endif
--- a/include/asm-powerpc/marker.h
+++ b/include/asm-powerpc/marker.h
@@ -40,10 +40,15 @@
 	} while (0)
 
 
+#define MARK_NO_TRAP MARK
 /* Offset of the immediate value from the start of the addi instruction (result
  * of the li mnemonic), in bytes. */
 #define MARK_ENABLE_IMMEDIATE_OFFSET 2
 #define MARK_ENABLE_TYPE short
-#define MARK_POLYMORPHIC
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define MARK_ENABLE(a) \
+	*(MARK_ENABLE_TYPE*)((char*)a+MARK_ENABLE_IMMEDIATE_OFFSET)
+
+extern int marker_set_ins_enable(void *address, char enable);
 
 #endif
--- a/include/linux/marker.h
+++ b/include/linux/marker.h
@@ -6,29 +6,7 @@
  *
  * Code markup for dynamic and static tracing.
  *
- * Example :
- *
- * MARK(subsystem_event, "%d %s %p[struct task_struct]",
- *   someint, somestring, current);
- * Where :
- * - Subsystem is the name of your subsystem.
- * - event is the name of the event to mark.
- * - "%d %s %p[struct task_struct]" is the formatted string for printk.
- * - someint is an integer.
- * - somestring is a char pointer.
- * - current is a pointer to a struct task_struct.
- *
- * - Dynamically overridable function call based on marker mechanism
- *   from Frank Ch. Eigler <fche@redhat.com>.
- * - Thanks to Jeremy Fitzhardinge <jeremy@goop.org> for his constructive
- *   criticism about gcc optimization related issues.
- *
- * The marker mechanism supports multiple instances of the same marker.
- * Markers can be put in inline functions, inlined static functions and
- * unrolled loops.
- *
- * Note : It is safe to put markers within preempt-safe code : preempt_enable()
- * will not call the scheduler due to the tests in preempt_schedule().
+ * See Documentation/marker.txt.
  *
  * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  *
@@ -36,7 +14,7 @@
  * See the file COPYING for more details.
  */
 
-#ifndef __ASSEMBLY__
+#ifdef __KERNEL__
 
 typedef void marker_probe_func(const char *fmt, ...);
 
@@ -54,32 +32,48 @@ struct __mark_marker {
 	void *enable;
 } __attribute__((packed));
 
-#ifdef CONFIG_MARKERS_ENABLE_OPTIMIZATION
-#include <asm/marker.h>
-#endif
-
-#include <asm-generic/marker.h>
-
-#define MARK_NOARGS " "
-#define MARK_MAX_FORMAT_LEN	1024
+/* Generic marker flavor always available */
+#ifdef CONFIG_MARKERS
+#define GEN_MARK(name, format, args...) \
+	do { \
+		static marker_probe_func *__mark_call_##name = \
+					__mark_empty_function; \
+		static char __marker_enable_##name = 0; \
+		static const struct __mark_marker_c __mark_c_##name \
+			__attribute__((section(".markers.c"))) = \
+			{ #name, &__mark_call_##name, format, \
+			MARKER_GENERIC } ; \
+		static const struct __mark_marker __mark_##name \
+			__attribute__((section(".markers"))) = \
+			{ &__mark_c_##name, &__marker_enable_##name } ; \
+		asm volatile ( "" : : "i" (&__mark_##name)); \
+		__mark_check_format(format, ## args); \
+		if (unlikely(__marker_enable_##name)) { \
+			preempt_disable(); \
+			(*__mark_call_##name)(format, ## args); \
+			preempt_enable(); \
+		} \
+	} while (0)
+
+#define GEN_MARK_ENABLE_IMMEDIATE_OFFSET 0
+#define GEN_MARK_ENABLE_TYPE char
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define GEN_MARK_ENABLE(a) \
+	*(GEN_MARK_ENABLE_TYPE*)((char*)a+GEN_MARK_ENABLE_IMMEDIATE_OFFSET)
 
-#ifndef CONFIG_MARKERS
+#else /* !CONFIG_MARKERS */
 #define GEN_MARK(name, format, args...) \
 		__mark_check_format(format, ## args)
-#endif
+#endif /* CONFIG_MARKERS */
 
-#ifndef MARK
-#define MARK GEN_MARK
-#define MARK_ENABLE_TYPE GEN_MARK_ENABLE_TYPE
-#define MARK_ENABLE_IMMEDIATE_OFFSET GEN_MARK_ENABLE_IMMEDIATE_OFFSET
+#ifdef CONFIG_MARKERS_ENABLE_OPTIMIZATION
+#include <asm/marker.h>			/* optimized marker flavor */
+#else
+#include <asm-generic/marker.h>		/* fallback on generic markers */
 #endif
 
-/* Dereference enable as lvalue from a pointer to its instruction */
-#define MARK_ENABLE(a) \
-	*(MARK_ENABLE_TYPE*)((char*)a+MARK_ENABLE_IMMEDIATE_OFFSET)
-
-#define GEN_MARK_ENABLE(a) \
-	*(GEN_MARK_ENABLE_TYPE*)((char*)a+GEN_MARK_ENABLE_IMMEDIATE_OFFSET)
+#define MARK_MAX_FORMAT_LEN	1024
+#define MARK_NOARGS " "
 
 static inline __attribute__ ((format (printf, 1, 2)))
 void __mark_check_format(const char *fmt, ...)
@@ -93,5 +87,5 @@ extern int marker_set_probe(const char *name, const char *format,
 extern int marker_remove_probe(marker_probe_func *probe);
 extern int marker_list_probe(marker_probe_func *probe);
 
-#endif
+#endif /* __KERNEL__ */
 #endif
--- a/kernel/Kconfig.marker
+++ b/kernel/Kconfig.marker
@@ -7,10 +7,14 @@ config MARKERS
 	  Place an empty function call at each marker site. Can be
 	  dynamically changed for a probe function.
 
-config MARKERS_ENABLE_OPTIMIZATION
-	bool "Enable marker optimization"
-	depends on MARKERS
-	default y
+config MARKERS_DISABLE_OPTIMIZATION
+	bool "Disable marker optimization"
+	depends on MARKERS && EMBEDDED
+	default n
 	help
 	  Disable code replacement jump optimisations. Especially useful if your
 	  code is in a read-only rom/flash.
+
+config MARKERS_ENABLE_OPTIMIZATION
+	def_bool y
+	depends on MARKERS && !MARKERS_DISABLE_OPTIMIZATION
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -307,29 +307,6 @@ void __mark_empty_function(const char *fmt, ...)
 }
 EXPORT_SYMBOL_GPL(__mark_empty_function);
 
-#ifdef MARK_POLYMORPHIC
-static int marker_set_ins_enable(void *address, char enable)
-{
-#ifdef CONFIG_X86_32
-	return arch_marker_set_ins_enable(address, enable);
-#else
-	char newi[MARK_ENABLE_IMMEDIATE_OFFSET+1];
-	int size = MARK_ENABLE_IMMEDIATE_OFFSET+sizeof(MARK_ENABLE_TYPE);
-
-	memcpy(newi, address, size);
-	MARK_ENABLE(&newi[0]) = enable;
-	memcpy(address, newi, size);
-	flush_icache_range((unsigned long)address, size);
-	return 0;
-#endif //CONFIG_X86_32
-}
-#else
-static int marker_set_ins_enable(void *address, char enable)
-{
-	return -EPERM;
-}
-#endif //MARK_POLYMORPHIC
-
 static int marker_set_gen_enable(void *address, char enable)
 {
 	GEN_MARK_ENABLE(address) = enable;
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
