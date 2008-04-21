Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYDUMeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYDUMeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757559AbYDUMeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:34:17 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:30799 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077AbYDUMeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:34:16 -0400
Message-ID: <480C89C4.9050806@de.ibm.com>
Date: Mon, 21 Apr 2008 14:34:12 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ltp-list@lists.sourceforge.net, ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org
Subject: [RFC PATCH 1/8] kernel: call constructors
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Call constructors during kernel init and module load. Required by the
gcov profiling infrastructure: gcc's profiling code uses constructors
to register profiling data structures.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 arch/powerpc/kernel/vmlinux.lds.S |    3 +++
 include/asm-generic/sections.h    |    1 +
 include/asm-generic/vmlinux.lds.h |    8 ++++++++
 include/linux/module.h            |    5 +++++
 init/main.c                       |   10 ++++++++++
 kernel/module.c                   |   13 +++++++++++++
 6 files changed, 40 insertions(+)

Index: linux-2.6.25/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.25.orig/include/asm-generic/vmlinux.lds.h
+++ linux-2.6.25/include/asm-generic/vmlinux.lds.h
@@ -352,3 +352,11 @@
 		*(.data.percpu.shared_aligned)				\
 	}								\
 	__per_cpu_end = .;
+
+#define CONSTRUCTORS							\
+		__CTOR_LIST__ = .;					\
+		*(.ctors)						\
+		__CTOR_END__ = .;					\
+		__DTOR_LIST__ = .;					\
+		*(.dtors)						\
+		__DTOR_END__ = .;
Index: linux-2.6.25/arch/powerpc/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.25.orig/arch/powerpc/kernel/vmlinux.lds.S
+++ linux-2.6.25/arch/powerpc/kernel/vmlinux.lds.S
@@ -196,6 +196,9 @@ SECTIONS
 		*(.toc)
 	}
 #endif
+	.data.gcov : {
+		CONSTRUCTORS
+	}
 
 	. = ALIGN(PAGE_SIZE);
 	_edata  =  .;
Index: linux-2.6.25/include/asm-generic/sections.h
===================================================================
--- linux-2.6.25.orig/include/asm-generic/sections.h
+++ linux-2.6.25/include/asm-generic/sections.h
@@ -13,5 +13,6 @@ extern char __per_cpu_start[], __per_cpu
 extern char __kprobes_text_start[], __kprobes_text_end[];
 extern char __initdata_begin[], __initdata_end[];
 extern char __start_rodata[], __end_rodata[];
+extern char __CTOR_LIST__[], __CTOR_END__[];
 
 #endif /* _ASM_GENERIC_SECTIONS_H_ */
Index: linux-2.6.25/include/linux/module.h
===================================================================
--- linux-2.6.25.orig/include/linux/module.h
+++ linux-2.6.25/include/linux/module.h
@@ -246,6 +246,8 @@ struct module_sect_attrs
 
 struct module_param_attrs;
 
+typedef void (*ctorcall_t)(void);
+
 struct module
 {
 	enum module_state state;
@@ -359,6 +361,9 @@ struct module
 	struct marker *markers;
 	unsigned int num_markers;
 #endif
+	/* Constructor calls. */
+	ctorcall_t *ctors;
+	unsigned long num_ctors;
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
Index: linux-2.6.25/kernel/module.c
===================================================================
--- linux-2.6.25.orig/kernel/module.c
+++ linux-2.6.25/kernel/module.c
@@ -1718,6 +1718,7 @@ static struct module *load_module(void _
 	unsigned int unusedgplcrcindex;
 	unsigned int markersindex;
 	unsigned int markersstringsindex;
+	unsigned int ctorsindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1814,6 +1815,7 @@ static struct module *load_module(void _
 #ifdef ARCH_UNWIND_SECTION_NAME
 	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
 #endif
+	ctorsindex = find_sec(hdr, sechdrs, secstrings, ".ctors");
 
 	/* Don't keep modinfo section */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -2021,6 +2023,8 @@ static struct module *load_module(void _
 	mod->num_markers =
 		sechdrs[markersindex].sh_size / sizeof(*mod->markers);
 #endif
+	mod->ctors = (void *) sechdrs[ctorsindex].sh_addr;
+	mod->num_ctors = sechdrs[ctorsindex].sh_size / sizeof(*mod->ctors);
 
         /* Find duplicate symbols */
 	err = verify_export_symbols(mod);
@@ -2133,6 +2137,14 @@ static struct module *load_module(void _
 	goto free_hdr;
 }
 
+static void do_mod_ctors(struct module *mod)
+{
+	unsigned long i;
+
+	for (i = 0; i < mod->num_ctors; i++)
+		mod->ctors[i]();
+}
+
 /* This is where the real work happens */
 asmlinkage long
 sys_init_module(void __user *umod,
@@ -2163,6 +2175,7 @@ sys_init_module(void __user *umod,
 	blocking_notifier_call_chain(&module_notify_list,
 			MODULE_STATE_COMING, mod);
 
+	do_mod_ctors(mod);
 	/* Start the module */
 	if (mod->init != NULL)
 		ret = mod->init();
Index: linux-2.6.25/init/main.c
===================================================================
--- linux-2.6.25.orig/init/main.c
+++ linux-2.6.25/init/main.c
@@ -650,6 +650,15 @@ asmlinkage void __init start_kernel(void
 	rest_init();
 }
 
+static void __init do_ctors(void)
+{
+	ctorcall_t *call;
+
+	for (call = (ctorcall_t *) __CTOR_LIST__;
+	     call < (ctorcall_t *) __CTOR_END__; call++)
+		(*call)();
+}
+
 static int __initdata initcall_debug;
 
 static int __init initcall_debug_setup(char *str)
@@ -735,6 +744,7 @@ static void __init do_basic_setup(void)
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
+	do_ctors();
 	do_initcalls();
 }
 





