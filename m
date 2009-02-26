Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbZBZNwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbZBZNwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbZBZNv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:51:58 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:49597 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002AbZBZNv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:51:56 -0500
Message-ID: <49A69E55.7060208@linux.vnet.ibm.com>
Date: Thu, 26 Feb 2009 14:51:17 +0100
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 1/4] kernel: constructor support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

---
 include/asm-generic/vmlinux.lds.h |   11 ++++++++++-
 include/linux/init.h              |    2 ++
 include/linux/module.h            |    6 ++++++
 init/Kconfig                      |    5 +++++
 init/main.c                       |   13 +++++++++++++
 kernel/module.c                   |   16 ++++++++++++++++
 6 files changed, 52 insertions(+), 1 deletion(-)

Index: linux-2.6.29-rc6/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.29-rc6.orig/include/asm-generic/vmlinux.lds.h
+++ linux-2.6.29-rc6/include/asm-generic/vmlinux.lds.h
@@ -301,6 +301,14 @@
 /* Section used for early init (in .S files) */
 #define HEAD_TEXT  *(.head.text)
 
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
@@ -317,7 +325,8 @@
 	. = ALIGN(8);							\
 	VMLINUX_SYMBOL(__start___verbose) = .;                          \
 	*(__verbose)                                                    \
-	VMLINUX_SYMBOL(__stop___verbose) = .;
+	VMLINUX_SYMBOL(__stop___verbose) = .;				\
+	KERNEL_CTORS()
 
 #define INIT_TEXT							\
 	*(.init.text)							\
Index: linux-2.6.29-rc6/include/linux/init.h
===================================================================
--- linux-2.6.29-rc6.orig/include/linux/init.h
+++ linux-2.6.29-rc6/include/linux/init.h
@@ -142,6 +142,8 @@ typedef void (*exitcall_t)(void);
 extern initcall_t __con_initcall_start[], __con_initcall_end[];
 extern initcall_t __security_initcall_start[], __security_initcall_end[];
 
+typedef void (*ctorcall_t)(void);
+
 /* Defined in init/main.c */
 extern int do_one_initcall(initcall_t fn);
 extern char __initdata boot_command_line[];
Index: linux-2.6.29-rc6/include/linux/module.h
===================================================================
--- linux-2.6.29-rc6.orig/include/linux/module.h
+++ linux-2.6.29-rc6/include/linux/module.h
@@ -345,6 +345,12 @@ struct module
 	local_t ref;
 #endif
 #endif
+
+#ifdef CONFIG_CONSTRUCTORS
+	/* Constructor functions. */
+	ctorcall_t *ctors;
+	unsigned int num_ctors;
+#endif
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
Index: linux-2.6.29-rc6/init/main.c
===================================================================
--- linux-2.6.29-rc6.orig/init/main.c
+++ linux-2.6.29-rc6/init/main.c
@@ -686,6 +686,18 @@ asmlinkage void __init start_kernel(void
 	rest_init();
 }
 
+/* Call all constructor functions linked into the kernel. */
+static void __init do_ctors(void)
+{
+#ifdef CONFIG_CONSTRUCTORS
+	extern ctorcall_t __ctors_start[], __ctors_end[];
+	ctorcall_t *call;
+
+	for (call = __ctors_start; call < __ctors_end; call++)
+		(*call)();
+#endif
+}
+
 int initcall_debug;
 core_param(initcall_debug, initcall_debug, bool, 0644);
 
@@ -765,6 +777,7 @@ static void __init do_basic_setup(void)
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
+	do_ctors();
 	do_initcalls();
 }
 
Index: linux-2.6.29-rc6/kernel/module.c
===================================================================
--- linux-2.6.29-rc6.orig/kernel/module.c
+++ linux-2.6.29-rc6/kernel/module.c
@@ -2157,6 +2157,10 @@ static noinline struct module *load_modu
 					sizeof(*mod->tracepoints),
 					&mod->num_tracepoints);
 #endif
+#ifdef CONFIG_CONSTRUCTORS
+	mod->ctors = section_objs(hdr, sechdrs, secstrings, ".ctors",
+				  sizeof(*mod->ctors), &mod->num_ctors);
+#endif
 
 #ifdef CONFIG_MODVERSIONS
 	if ((mod->num_syms && !mod->crcs)
@@ -2310,6 +2314,17 @@ static noinline struct module *load_modu
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
@@ -2338,6 +2353,7 @@ SYSCALL_DEFINE3(init_module, void __user
 	blocking_notifier_call_chain(&module_notify_list,
 			MODULE_STATE_COMING, mod);
 
+	do_mod_ctors(mod);
 	/* Start the module */
 	if (mod->init != NULL)
 		ret = do_one_initcall(mod->init);
Index: linux-2.6.29-rc6/init/Kconfig
===================================================================
--- linux-2.6.29-rc6.orig/init/Kconfig
+++ linux-2.6.29-rc6/init/Kconfig
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


