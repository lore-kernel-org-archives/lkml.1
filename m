Return-Path: <linux-kernel-owner+w=401wt.eu-S1760291AbYDKNtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291AbYDKNtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 09:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758541AbYDKNtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 09:49:45 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:43167 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758406AbYDKNtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 09:49:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoFAPoI/0dMQWoK/2dsb2JhbACBXal0gh4
Date: Fri, 11 Apr 2008 09:44:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Adrian Bunk <bunk@stusta.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, akpm@osdl.org
Subject: [RFC PATCH] Immediate Values Support init
Message-ID: <20080411134439.GA32602@Krystal>
References: <20080409150829.855195878@polymtl.ca> <20080409152052.245356400@polymtl.ca> <200804101333.36419.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200804101333.36419.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:43:42 up 42 days,  9:54,  6 users,  load average: 0.44, 0.54,
	0.54
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supports placing immediate values in init code

We need to put the immediate values in RW data section so we can edit them
before init section unload.

This code puts NULL pointers in lieu of original pointer referencing init code
before the init sections are freed, both in the core kernel and in modules.

(experimental patch submitted for comments and testing)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: "Frank Ch. Eigler" <fche@redhat.com>
---
 Documentation/immediate.txt       |    5 -----
 include/asm-generic/vmlinux.lds.h |    8 ++++----
 include/asm-powerpc/immediate.h   |    4 ++--
 include/asm-x86/immediate.h       |    6 +++---
 include/linux/immediate.h         |    7 ++++++-
 include/linux/module.h            |    2 +-
 init/main.c                       |    1 +
 kernel/immediate.c                |   32 ++++++++++++++++++++++++++++++--
 kernel/module.c                   |    2 ++
 9 files changed, 49 insertions(+), 18 deletions(-)

Index: linux-2.6-lttng/kernel/immediate.c
===================================================================
--- linux-2.6-lttng.orig/kernel/immediate.c	2008-04-11 09:35:52.000000000 -0400
+++ linux-2.6-lttng/kernel/immediate.c	2008-04-11 09:41:33.000000000 -0400
@@ -22,6 +22,7 @@
 #include <linux/cpu.h>
 #include <linux/stop_machine.h>
 
+#include <asm/sections.h>
 #include <asm/cacheflush.h>
 
 /*
@@ -30,8 +31,8 @@
 static int imv_early_boot_complete;
 static int wrote_text;
 
-extern const struct __imv __start___imv[];
-extern const struct __imv __stop___imv[];
+extern struct __imv __start___imv[];
+extern struct __imv __stop___imv[];
 
 static int stop_machine_imv_update(void *imv_ptr)
 {
@@ -118,6 +119,8 @@ void imv_update_range(const struct __imv
 	int ret;
 	for (iter = begin; iter < end; iter++) {
 		mutex_lock(&imv_mutex);
+		if (!iter->imv)	/* Skip removed __init immediate values */
+			goto skip;
 		ret = apply_imv_update(iter);
 		if (imv_early_boot_complete && ret)
 			printk(KERN_WARNING
@@ -126,6 +129,7 @@ void imv_update_range(const struct __imv
 				"instruction at %p, size %hu\n",
 				(void *)iter->imv,
 				(void *)iter->var, iter->size);
+skip:
 		mutex_unlock(&imv_mutex);
 	}
 }
@@ -143,6 +147,30 @@ void core_imv_update(void)
 }
 EXPORT_SYMBOL_GPL(core_imv_update);
 
+/**
+ * imv_unref_init
+ *
+ * Deactivate any immediate value reference pointing into init code before
+ * it vanishes.
+ */
+void imv_unref_init(struct __imv *begin, struct __imv *end, void *init,
+		unsigned long init_size)
+{
+	struct __imv *iter;
+
+	for (iter = begin; iter < end; iter++)
+		if (iter->imv >= (unsigned long)init
+			&& iter->imv < (unsigned long)init + init_size)
+			iter->imv = 0UL;
+}
+
+void imv_unref_core_init(void)
+{
+	imv_unref_init(__start___imv, __stop___imv,
+		__init_begin,
+		(unsigned long)__init_end - (unsigned long)__init_begin);
+}
+
 void __init imv_init_complete(void)
 {
 	imv_early_boot_complete = 1;
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2008-04-11 09:35:54.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2008-04-11 09:36:58.000000000 -0400
@@ -2208,6 +2208,8 @@ sys_init_module(void __user *umod,
 	/* Drop initial reference. */
 	module_put(mod);
 	unwind_remove_table(mod->unwind_info, 1);
+	imv_unref_init(mod->immediate, mod->immediate + mod->num_immediate,
+		mod->module_init, mod->init_size);
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;
 	mod->init_size = 0;
Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h	2008-04-11 09:35:43.000000000 -0400
+++ linux-2.6-lttng/include/linux/module.h	2008-04-11 09:36:58.000000000 -0400
@@ -357,7 +357,7 @@ struct module
 	   keeping pointers to this stuff */
 	char *args;
 #ifdef CONFIG_IMMEDIATE
-	const struct __imv *immediate;
+	struct __imv *immediate;
 	unsigned int num_immediate;
 #endif
 #ifdef CONFIG_MARKERS
Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2008-04-11 09:35:37.000000000 -0400
+++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2008-04-11 09:36:58.000000000 -0400
@@ -52,7 +52,10 @@
 	. = ALIGN(8);							\
 	VMLINUX_SYMBOL(__start___markers) = .;				\
 	*(__markers)							\
-	VMLINUX_SYMBOL(__stop___markers) = .;
+	VMLINUX_SYMBOL(__stop___markers) = .;				\
+	VMLINUX_SYMBOL(__start___imv) = .;				\
+	*(__imv)		/* Immediate values: pointers */ 	\
+	VMLINUX_SYMBOL(__stop___imv) = .;
 
 #define RO_DATA(align)							\
 	. = ALIGN((align));						\
@@ -61,9 +64,6 @@
 		*(.rodata) *(.rodata.*)					\
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
-		VMLINUX_SYMBOL(__start___imv) = .;			\
-		*(__imv)		/* Immediate values: pointers */ \
-		VMLINUX_SYMBOL(__stop___imv) = .;			\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
Index: linux-2.6-lttng/include/linux/immediate.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/immediate.h	2008-04-11 09:35:52.000000000 -0400
+++ linux-2.6-lttng/include/linux/immediate.h	2008-04-11 09:36:58.000000000 -0400
@@ -46,6 +46,9 @@ struct __imv {
 extern void core_imv_update(void);
 extern void imv_update_range(const struct __imv *begin,
 	const struct __imv *end);
+extern void imv_unref_core_init(void);
+extern void imv_unref_init(struct __imv *begin, struct __imv *end, void *init,
+		unsigned long init_size);
 
 #else
 
@@ -73,7 +76,9 @@ extern void imv_update_range(const struc
 
 static inline void core_imv_update(void) { }
 static inline void module_imv_update(void) { }
-
+static inline void imv_unref_core_init(void) { }
+static inline void imv_unref_init(struct __imv *begin, struct __imv *end,
+		void *init, unsigned long init_size) { }
 #endif
 
 #define DECLARE_IMV(type, name) extern __typeof__(type) name##__imv
Index: linux-2.6-lttng/init/main.c
===================================================================
--- linux-2.6-lttng.orig/init/main.c	2008-04-11 09:35:37.000000000 -0400
+++ linux-2.6-lttng/init/main.c	2008-04-11 09:36:58.000000000 -0400
@@ -776,6 +776,7 @@ static void run_init_process(char *init_
  */
 static int noinline init_post(void)
 {
+	imv_unref_core_init();
 	free_initmem();
 	unlock_kernel();
 	mark_rodata_ro();
Index: linux-2.6-lttng/include/asm-x86/immediate.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/immediate.h	2008-04-11 09:35:52.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/immediate.h	2008-04-11 09:38:23.000000000 -0400
@@ -33,7 +33,7 @@
 		BUILD_BUG_ON(sizeof(value) > 8);			\
 		switch (sizeof(value)) {				\
 		case 1:							\
-			asm(".section __imv,\"a\",@progbits\n\t"	\
+			asm(".section __imv,\"aw\",@progbits\n\t"	\
 				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
 				".byte %c2\n\t"				\
 				".previous\n\t"				\
@@ -45,7 +45,7 @@
 			break;						\
 		case 2:							\
 		case 4:							\
-			asm(".section __imv,\"a\",@progbits\n\t"	\
+			asm(".section __imv,\"aw\",@progbits\n\t"	\
 				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
 				".byte %c2\n\t"				\
 				".previous\n\t"				\
@@ -60,7 +60,7 @@
 				value = name##__imv;			\
 				break;					\
 			}						\
-			asm(".section __imv,\"a\",@progbits\n\t"	\
+			asm(".section __imv,\"aw\",@progbits\n\t"	\
 				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
 				".byte %c2\n\t"				\
 				".previous\n\t"				\
Index: linux-2.6-lttng/include/asm-powerpc/immediate.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-powerpc/immediate.h	2008-04-11 09:35:52.000000000 -0400
+++ linux-2.6-lttng/include/asm-powerpc/immediate.h	2008-04-11 09:36:58.000000000 -0400
@@ -26,7 +26,7 @@
 		BUILD_BUG_ON(sizeof(value) > 8);			\
 		switch (sizeof(value)) {				\
 		case 1:							\
-			asm(".section __imv,\"a\",@progbits\n\t"	\
+			asm(".section __imv,\"aw\",@progbits\n\t"	\
 					PPC_LONG "%c1, ((1f)-1)\n\t"	\
 					".byte 1\n\t"			\
 					".previous\n\t"			\
@@ -36,7 +36,7 @@
 				: "i" (&name##__imv));			\
 			break;						\
 		case 2:							\
-			asm(".section __imv,\"a\",@progbits\n\t"	\
+			asm(".section __imv,\"aw\",@progbits\n\t"	\
 					PPC_LONG "%c1, ((1f)-2)\n\t"	\
 					".byte 2\n\t"			\
 					".previous\n\t"			\
Index: linux-2.6-lttng/Documentation/immediate.txt
===================================================================
--- linux-2.6-lttng.orig/Documentation/immediate.txt	2008-04-11 09:43:03.000000000 -0400
+++ linux-2.6-lttng/Documentation/immediate.txt	2008-04-11 09:43:19.000000000 -0400
@@ -42,11 +42,6 @@ The immediate mechanism supports inserti
 immediate. Immediate values can be put in inline functions, inlined static
 functions, and unrolled loops.
 
-If you have to read the immediate values from a function declared as __init or
-__exit, you should explicitly use _imv_read(), which will fall back on a
-global variable read. Failing to do so will leave a reference to the __init
-section after it is freed (it would generate a modpost warning).
-
 You can choose to set an initial static value to the immediate by using, for
 instance:
 
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
