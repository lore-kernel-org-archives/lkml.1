Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbZESO03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbZESO03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZESO0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:26:21 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:62354 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbZESO0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:26:08 -0400
Message-Id: <20090519142417.187314650@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 19 May 2009 16:24:17 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Huang Ying <ying.huang@intel.com>, Li Wei <W.Li@Sun.COM>,
       Michael Ellerman <michaele@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       WANG Cong <xiyou.wangcong@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 1/4] kernel: constructor support
References: <20090519142416.356254359@linux.vnet.ibm.com>
Content-Disposition: inline; filename=kernel-constructor-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Call constructors (gcc-generated initcall-like functions) during
kernel start and module load. Constructors are e.g. used for gcov data
initialization.

Disable constructor support for usermode Linux to prevent conflicts
with host glibc.

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Dike <jdike@addtoit.com>
---
 include/asm-generic/sections.h    |    3 +++
 include/asm-generic/vmlinux.lds.h |   11 ++++++++++-
 include/linux/init.h              |    3 +++
 include/linux/module.h            |    6 ++++++
 init/Kconfig                      |    5 +++++
 init/main.c                       |   12 ++++++++++++
 kernel/module.c                   |   16 ++++++++++++++++
 7 files changed, 55 insertions(+), 1 deletion(-)

Index: linux-2.6.30-rc6/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.30-rc6.orig/include/asm-generic/vmlinux.lds.h	2009-05-19 12:27:39.000000000 +0200
+++ linux-2.6.30-rc6/include/asm-generic/vmlinux.lds.h	2009-05-19 12:41:25.000000000 +0200
@@ -332,6 +332,14 @@
 /* Section used for early init (in .S files) */
 #define HEAD_TEXT  *(HEAD_TEXT_SECTION)
 
+#ifdef CONFIG_CONSTRUCTORS
+#define KERNEL_CTORS()	VMLINUX_SYMBOL(__ctors_start) = .; \
+			*(.ctors)			   \
+			VMLINUX_SYMBOL(__ctors_end) = .;
+#else
+#define KERNEL_CTORS()
+#endif
+
 /* init and exit section handling */
 #define INIT_DATA							\
 	*(.init.data)							\
@@ -340,7 +348,8 @@
 	CPU_DISCARD(init.data)						\
 	CPU_DISCARD(init.rodata)					\
 	MEM_DISCARD(init.data)						\
-	MEM_DISCARD(init.rodata)
+	MEM_DISCARD(init.rodata)					\
+	KERNEL_CTORS()
 
 #define INIT_TEXT							\
 	*(.init.text)							\
Index: linux-2.6.30-rc6/include/linux/init.h
===================================================================
--- linux-2.6.30-rc6.orig/include/linux/init.h	2009-05-19 12:27:39.000000000 +0200
+++ linux-2.6.30-rc6/include/linux/init.h	2009-05-19 12:41:25.000000000 +0200
@@ -136,6 +136,9 @@
 extern initcall_t __con_initcall_start[], __con_initcall_end[];
 extern initcall_t __security_initcall_start[], __security_initcall_end[];
 
+/* Used for contructor calls. */
+typedef void (*ctor_fn_t)(void);
+
 /* Defined in init/main.c */
 extern int do_one_initcall(initcall_t fn);
 extern char __initdata boot_command_line[];
Index: linux-2.6.30-rc6/include/linux/module.h
===================================================================
--- linux-2.6.30-rc6.orig/include/linux/module.h	2009-05-19 12:27:39.000000000 +0200
+++ linux-2.6.30-rc6/include/linux/module.h	2009-05-19 12:41:25.000000000 +0200
@@ -354,6 +354,12 @@
 	local_t ref;
 #endif
 #endif
+
+#ifdef CONFIG_CONSTRUCTORS
+	/* Constructor functions. */
+	ctor_fn_t *ctors;
+	unsigned int num_ctors;
+#endif
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
Index: linux-2.6.30-rc6/init/main.c
===================================================================
--- linux-2.6.30-rc6.orig/init/main.c	2009-05-19 12:27:39.000000000 +0200
+++ linux-2.6.30-rc6/init/main.c	2009-05-19 12:41:25.000000000 +0200
@@ -700,6 +700,17 @@
 	rest_init();
 }
 
+/* Call all constructor functions linked into the kernel. */
+static void __init do_ctors(void)
+{
+#ifdef CONFIG_CONSTRUCTORS
+	ctor_fn_t *call = (ctor_fn_t *) __ctors_start;
+
+	for (; call < (ctor_fn_t *) __ctors_end; call++)
+		(*call)();
+#endif
+}
+
 int initcall_debug;
 core_param(initcall_debug, initcall_debug, bool, 0644);
 
@@ -780,6 +791,7 @@
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
+	do_ctors();
 	do_initcalls();
 }
 
Index: linux-2.6.30-rc6/kernel/module.c
===================================================================
--- linux-2.6.30-rc6.orig/kernel/module.c	2009-05-19 12:27:39.000000000 +0200
+++ linux-2.6.30-rc6/kernel/module.c	2009-05-19 12:41:26.000000000 +0200
@@ -2172,6 +2172,10 @@
 					sizeof(*mod->tracepoints),
 					&mod->num_tracepoints);
 #endif
+#ifdef CONFIG_CONSTRUCTORS
+	mod->ctors = section_objs(hdr, sechdrs, secstrings, ".ctors",
+				  sizeof(*mod->ctors), &mod->num_ctors);
+#endif
 
 #ifdef CONFIG_MODVERSIONS
 	if ((mod->num_syms && !mod->crcs)
@@ -2328,6 +2332,17 @@
 	goto free_hdr;
 }
 
+/* Call module constructors. */
+static void do_mod_ctors(struct module *mod)
+{
+#ifdef CONFIG_CONSTRUCTORS
+	unsigned long i;
+
+	for (i = 0; i < mod->num_ctors; i++)
+		mod->ctors[i]();
+#endif
+}
+
 /* This is where the real work happens */
 SYSCALL_DEFINE3(init_module, void __user *, umod,
 		unsigned long, len, const char __user *, uargs)
@@ -2356,6 +2371,7 @@
 	blocking_notifier_call_chain(&module_notify_list,
 			MODULE_STATE_COMING, mod);
 
+	do_mod_ctors(mod);
 	/* Start the module */
 	if (mod->init != NULL)
 		ret = do_one_initcall(mod->init);
Index: linux-2.6.30-rc6/init/Kconfig
===================================================================
--- linux-2.6.30-rc6.orig/init/Kconfig	2009-05-19 12:27:39.000000000 +0200
+++ linux-2.6.30-rc6/init/Kconfig	2009-05-19 12:41:26.000000000 +0200
@@ -16,6 +16,11 @@
 	default "$ARCH_DEFCONFIG"
 	default "arch/$ARCH/defconfig"
 
+config CONSTRUCTORS
+	bool
+	depends on !UML
+	default y
+
 menu "General setup"
 
 config EXPERIMENTAL
Index: linux-2.6.30-rc6/include/asm-generic/sections.h
===================================================================
--- linux-2.6.30-rc6.orig/include/asm-generic/sections.h	2009-05-19 12:27:39.000000000 +0200
+++ linux-2.6.30-rc6/include/asm-generic/sections.h	2009-05-19 12:41:26.000000000 +0200
@@ -14,6 +14,9 @@
 extern char __initdata_begin[], __initdata_end[];
 extern char __start_rodata[], __end_rodata[];
 
+/* Start and end of .ctors section - used for constructor calls. */
+extern char __ctors_start[], __ctors_end[];
+
 /* function descriptor handling (if any).  Override
  * in asm/sections.h */
 #ifndef dereference_function_descriptor


