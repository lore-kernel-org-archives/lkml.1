Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625AbZIXOnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbZIXOnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZIXOnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:43:11 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48240 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbZIXOnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:43:06 -0400
Message-Id: <20090924133400.512675657@polymtl.ca>
References: <20090924132626.485545323@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Sep 2009 09:26:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [patch 10/12] Immediate Values Support init
Content-Disposition: inline; filename=immediate-values-support-init.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 24 Sep 2009 14:07:33 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supports placing immediate values in init code

We need to put the immediate values in RW data section so we can edit them
before init section unload.

This code puts NULL pointers in lieu of original pointer referencing init code
before the init sections are freed, both in the core kernel and in modules.

TODO : support __exit section.

Changelog:
- Fix !CONFIG_IMMEDIATE
- Folded immediate-values-support-init-kerneldoc-fix

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 Documentation/immediate.txt          |    8 ++++----
 arch/powerpc/include/asm/immediate.h |    4 ++--
 arch/x86/include/asm/immediate.h     |    6 +++---
 include/asm-generic/vmlinux.lds.h    |    6 +++---
 include/linux/immediate.h            |    4 ++++
 include/linux/module.h               |    2 +-
 init/main.c                          |    1 +
 kernel/immediate.c                   |   34 ++++++++++++++++++++++++++++++++--
 kernel/module.c                      |    4 ++++
 9 files changed, 54 insertions(+), 15 deletions(-)

Index: linux.trees.git/kernel/immediate.c
===================================================================
--- linux.trees.git.orig/kernel/immediate.c	2009-09-24 08:58:28.000000000 -0400
+++ linux.trees.git/kernel/immediate.c	2009-09-24 09:02:06.000000000 -0400
@@ -22,6 +22,7 @@
 #include <linux/cpu.h>
 #include <linux/stop_machine.h>
 
+#include <asm/sections.h>
 #include <asm/cacheflush.h>
 #include <asm/atomic.h>
 
@@ -32,8 +33,8 @@ static int imv_early_boot_complete;
 static atomic_t stop_machine_first;
 static int wrote_text;
 
-extern const struct __imv __start___imv[];
-extern const struct __imv __stop___imv[];
+extern struct __imv __start___imv[];
+extern struct __imv __stop___imv[];
 
 static int stop_machine_imv_update(void *imv_ptr)
 {
@@ -124,6 +125,8 @@ void imv_update_range(const struct __imv
 
 	mutex_lock(&imv_mutex);
 	for (iter = begin; iter < end; iter++) {
+		if (!iter->imv) /* Skip removed __init immediate values */
+			continue;
 		ret = apply_imv_update(iter);
 		if (imv_early_boot_complete && ret)
 			printk(KERN_WARNING
@@ -149,6 +152,33 @@ void core_imv_update(void)
 }
 EXPORT_SYMBOL_GPL(core_imv_update);
 
+/**
+ * imv_unref
+ * @begin: pointer to the beginning of the range
+ * @end: pointer to the end of the range
+ * @start: beginning of the region to consider
+ * @size: size of the region to consider
+ *
+ * Deactivate any immediate value reference pointing into the code region in the
+ * range start to start + size.
+ */
+void imv_unref(struct __imv *begin, struct __imv *end, void *start,
+		unsigned long size)
+{
+	struct __imv *iter;
+
+	for (iter = begin; iter < end; iter++)
+		if (iter->imv >= (unsigned long)start
+			&& iter->imv < (unsigned long)start + size)
+			iter->imv = 0UL;
+}
+
+void imv_unref_core_init(void)
+{
+	imv_unref(__start___imv, __stop___imv, __init_begin,
+		(unsigned long)__init_end - (unsigned long)__init_begin);
+}
+
 void __init imv_init_complete(void)
 {
 	imv_early_boot_complete = 1;
Index: linux.trees.git/kernel/module.c
===================================================================
--- linux.trees.git.orig/kernel/module.c	2009-09-24 08:58:28.000000000 -0400
+++ linux.trees.git/kernel/module.c	2009-09-24 09:02:50.000000000 -0400
@@ -2491,6 +2491,10 @@ SYSCALL_DEFINE3(init_module, void __user
 	mutex_lock(&module_mutex);
 	/* Drop initial reference. */
 	module_put(mod);
+#ifdef CONFIG_IMMEDIATE
+	imv_unref(mod->immediate, mod->immediate + mod->num_immediate,
+		mod->module_init, mod->init_size);
+#endif
 	trim_init_extable(mod);
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;
Index: linux.trees.git/include/linux/module.h
===================================================================
--- linux.trees.git.orig/include/linux/module.h	2009-09-24 08:59:42.000000000 -0400
+++ linux.trees.git/include/linux/module.h	2009-09-24 09:02:06.000000000 -0400
@@ -332,7 +332,7 @@ struct module
 	unsigned int num_tracepoints;
 #endif
 #ifdef CONFIG_IMMEDIATE
-	const struct __imv *immediate;
+	struct __imv *immediate;
 	unsigned int num_immediate;
 #endif
 
Index: linux.trees.git/include/linux/immediate.h
===================================================================
--- linux.trees.git.orig/include/linux/immediate.h	2009-09-24 08:58:28.000000000 -0400
+++ linux.trees.git/include/linux/immediate.h	2009-09-24 09:02:06.000000000 -0400
@@ -46,6 +46,9 @@ struct __imv {
 extern void core_imv_update(void);
 extern void imv_update_range(const struct __imv *begin,
 	const struct __imv *end);
+extern void imv_unref_core_init(void);
+extern void imv_unref(struct __imv *begin, struct __imv *end, void *start,
+		unsigned long size);
 
 #else
 
@@ -73,6 +76,7 @@ extern void imv_update_range(const struc
 
 static inline void core_imv_update(void) { }
 static inline void module_imv_update(void) { }
+static inline void imv_unref_core_init(void) { }
 
 #endif
 
Index: linux.trees.git/arch/x86/include/asm/immediate.h
===================================================================
--- linux.trees.git.orig/arch/x86/include/asm/immediate.h	2009-09-24 09:00:27.000000000 -0400
+++ linux.trees.git/arch/x86/include/asm/immediate.h	2009-09-24 09:02:06.000000000 -0400
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
Index: linux.trees.git/arch/powerpc/include/asm/immediate.h
===================================================================
--- linux.trees.git.orig/arch/powerpc/include/asm/immediate.h	2009-09-24 09:00:33.000000000 -0400
+++ linux.trees.git/arch/powerpc/include/asm/immediate.h	2009-09-24 09:02:06.000000000 -0400
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
Index: linux.trees.git/Documentation/immediate.txt
===================================================================
--- linux.trees.git.orig/Documentation/immediate.txt	2009-09-24 09:01:58.000000000 -0400
+++ linux.trees.git/Documentation/immediate.txt	2009-09-24 09:02:06.000000000 -0400
@@ -42,10 +42,10 @@ The immediate mechanism supports inserti
 immediate. Immediate values can be put in inline functions, inlined static
 functions, and unrolled loops.
 
-If you have to read the immediate values from a function declared as __init or
-__exit, you should explicitly use _imv_read(), which will fall back on a
-global variable read. Failing to do so will leave a reference to the __init
-section after it is freed (it would generate a modpost warning).
+If you have to read the immediate values from a function declared as __exit, you
+should explicitly use _imv_read(), which will fall back on a global variable
+read. Failing to do so will leave a reference to the __exit section in kernel
+without module unload support. imv_read() in the __init section is supported.
 
 You can choose to set an initial static value to the immediate by using, for
 instance:
Index: linux.trees.git/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux.trees.git.orig/include/asm-generic/vmlinux.lds.h	2009-09-24 08:58:28.000000000 -0400
+++ linux.trees.git/include/asm-generic/vmlinux.lds.h	2009-09-24 09:02:06.000000000 -0400
@@ -154,6 +154,9 @@
 	VMLINUX_SYMBOL(__start___tracepoints) = .;			\
 	*(__tracepoints)						\
 	VMLINUX_SYMBOL(__stop___tracepoints) = .;			\
+	VMLINUX_SYMBOL(__start___imv) = .;				\
+	*(__imv)		/* Immediate values: pointers */	\
+	VMLINUX_SYMBOL(__stop___imv) = .;				\
 	/* implement dynamic printk debug */				\
 	. = ALIGN(8);							\
 	VMLINUX_SYMBOL(__start___verbose) = .;                          \
@@ -202,9 +205,6 @@
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
-		VMLINUX_SYMBOL(__start___imv) = .;			\
-		*(__imv)		/* Immediate values: pointers */ \
-		VMLINUX_SYMBOL(__stop___imv) = .;			\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
Index: linux.trees.git/init/main.c
===================================================================
--- linux.trees.git.orig/init/main.c	2009-09-24 08:58:28.000000000 -0400
+++ linux.trees.git/init/main.c	2009-09-24 09:02:06.000000000 -0400
@@ -822,6 +822,7 @@ static noinline int init_post(void)
 {
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
+	imv_unref_core_init();
 	free_initmem();
 	unlock_kernel();
 	mark_rodata_ro();

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
