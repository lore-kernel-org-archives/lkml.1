Return-Path: <linux-kernel-owner+w=401wt.eu-S1763627AbZEHPrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763627AbZEHPrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763380AbZEHPqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:46:23 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:43284 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbZEHPqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:46:21 -0400
Message-Id: <20090508154408.925135176@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 08 May 2009 17:44:09 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Michael Ellerman <michaele@au1.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
       Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 1/4] kernel: constructor support
References: <20090508154407.956216094@linux.vnet.ibm.com>
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
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Dike <jdike@addtoit.com>
---
 include/asm-generic/vmlinux.lds.h |   11 ++++++++++-
 include/linux/init.h              |    2 ++
 include/linux/module.h            |    6 ++++++
 init/Kconfig                      |    5 +++++
 init/main.c                       |   13 +++++++++++++
 kernel/module.c                   |   16 ++++++++++++++++
 6 files changed, 52 insertions(+), 1 deletion(-)

Index: linux-2.6.30-rc4/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.30-rc4.orig/include/asm-generic/vmlinux.lds.h
+++ linux-2.6.30-rc4/include/asm-generic/vmlinux.lds.h
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
Index: linux-2.6.30-rc4/include/linux/init.h
===================================================================
--- linux-2.6.30-rc4.orig/include/linux/init.h
+++ linux-2.6.30-rc4/include/linux/init.h
@@ -136,6 +136,8 @@ typedef void (*exitcall_t)(void);
 extern initcall_t __con_initcall_start[], __con_initcall_end[];
 extern initcall_t __security_initcall_start[], __security_initcall_end[];
 
+typedef void (*ctor_fn_t)(void);
+
 /* Defined in init/main.c */
 extern int do_one_initcall(initcall_t fn);
 extern char __initdata boot_command_line[];
Index: linux-2.6.30-rc4/include/linux/module.h
===================================================================
--- linux-2.6.30-rc4.orig/include/linux/module.h
+++ linux-2.6.30-rc4/include/linux/module.h
@@ -354,6 +354,12 @@ struct module
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
Index: linux-2.6.30-rc4/init/main.c
===================================================================
--- linux-2.6.30-rc4.orig/init/main.c
+++ linux-2.6.30-rc4/init/main.c
@@ -700,6 +700,18 @@ asmlinkage void __init start_kernel(void
 	rest_init();
 }
 
+/* Call all constructor functions linked into the kernel. */
+static void __init do_ctors(void)
+{
+#ifdef CONFIG_CONSTRUCTORS
+	extern ctor_fn_t __ctors_start[], __ctors_end[];
+	ctor_fn_t *call;
+
+	for (call = __ctors_start; call < __ctors_end; call++)
+		(*call)();
+#endif
+}
+
 int initcall_debug;
 core_param(initcall_debug, initcall_debug, bool, 0644);
 
@@ -780,6 +792,7 @@ static void __init do_basic_setup(void)
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
+	do_ctors();
 	do_initcalls();
 }
 
Index: linux-2.6.30-rc4/kernel/module.c
===================================================================
--- linux-2.6.30-rc4.orig/kernel/module.c
+++ linux-2.6.30-rc4/kernel/module.c
@@ -2172,6 +2172,10 @@ static noinline struct module *load_modu
 					sizeof(*mod->tracepoints),
 					&mod->num_tracepoints);
 #endif
+#ifdef CONFIG_CONSTRUCTORS
+	mod->ctors = section_objs(hdr, sechdrs, secstrings, ".ctors",
+				  sizeof(*mod->ctors), &mod->num_ctors);
+#endif
 
 #ifdef CONFIG_MODVERSIONS
 	if ((mod->num_syms && !mod->crcs)
@@ -2328,6 +2332,17 @@ static noinline struct module *load_modu
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
@@ -2356,6 +2371,7 @@ SYSCALL_DEFINE3(init_module, void __user
 	blocking_notifier_call_chain(&module_notify_list,
 			MODULE_STATE_COMING, mod);
 
+	do_mod_ctors(mod);
 	/* Start the module */
 	if (mod->init != NULL)
 		ret = do_one_initcall(mod->init);
Index: linux-2.6.30-rc4/init/Kconfig
===================================================================
--- linux-2.6.30-rc4.orig/init/Kconfig
+++ linux-2.6.30-rc4/init/Kconfig
@@ -16,6 +16,11 @@ config DEFCONFIG_LIST
 	default "$ARCH_DEFCONFIG"
 	default "arch/$ARCH/defconfig"
 
+config CONSTRUCTORS
+	bool
+	depends on !UML
+	default y
+
 menu "General setup"
 
 config EXPERIMENTAL


