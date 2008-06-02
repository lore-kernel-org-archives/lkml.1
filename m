Return-Path: <linux-kernel-owner+w=401wt.eu-S1760920AbYFBNfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920AbYFBNfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760468AbYFBNfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:35:08 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:63117 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759617AbYFBNfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:35:06 -0400
Message-ID: <4843F6C9.9070709@de.ibm.com>
Date: Mon, 02 Jun 2008 15:34:01 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: [PATCH 1/6] kernel: call constructors
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
 include/asm-generic/vmlinux.lds.h |    5 +++++
 include/linux/init.h              |    2 ++
 include/linux/module.h            |    3 +++
 init/main.c                       |   10 ++++++++++
 kernel/module.c                   |   13 +++++++++++++
 7 files changed, 37 insertions(+)

Index: linux-2.6.26-rc4/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.26-rc4.orig/include/asm-generic/vmlinux.lds.h
+++ linux-2.6.26-rc4/include/asm-generic/vmlinux.lds.h
@@ -352,3 +352,8 @@
 		*(.data.percpu.shared_aligned)				\
 	}								\
 	__per_cpu_end = .;
+
+#define CONSTRUCTORS							\
+		VMLINUX_SYMBOL(__ctor_start) = .;			\
+		*(.ctors)						\
+		VMLINUX_SYMBOL(__ctor_end) = .;
Index: linux-2.6.26-rc4/arch/powerpc/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.26-rc4.orig/arch/powerpc/kernel/vmlinux.lds.S
+++ linux-2.6.26-rc4/arch/powerpc/kernel/vmlinux.lds.S
@@ -193,6 +193,9 @@ SECTIONS
 		*(.toc)
 	}
 #endif
+	.data.gcov : {
+		CONSTRUCTORS
+	}
 
 	. = ALIGN(PAGE_SIZE);
 	_edata  =  .;
Index: linux-2.6.26-rc4/include/asm-generic/sections.h
===================================================================
--- linux-2.6.26-rc4.orig/include/asm-generic/sections.h
+++ linux-2.6.26-rc4/include/asm-generic/sections.h
@@ -13,5 +13,6 @@ extern char __per_cpu_start[], __per_cpu
 extern char __kprobes_text_start[], __kprobes_text_end[];
 extern char __initdata_begin[], __initdata_end[];
 extern char __start_rodata[], __end_rodata[];
+extern char __ctor_start[], __ctor_end[];
 
 #endif /* _ASM_GENERIC_SECTIONS_H_ */
Index: linux-2.6.26-rc4/include/linux/module.h
===================================================================
--- linux-2.6.26-rc4.orig/include/linux/module.h
+++ linux-2.6.26-rc4/include/linux/module.h
@@ -342,6 +342,9 @@ struct module
 	struct marker *markers;
 	unsigned int num_markers;
 #endif
+	/* Constructor calls. */
+	ctorcall_t *ctors;
+	unsigned long num_ctors;
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
Index: linux-2.6.26-rc4/kernel/module.c
===================================================================
--- linux-2.6.26-rc4.orig/kernel/module.c
+++ linux-2.6.26-rc4/kernel/module.c
@@ -1770,6 +1770,7 @@ static struct module *load_module(void _
 	unsigned int unusedgplcrcindex;
 	unsigned int markersindex;
 	unsigned int markersstringsindex;
+	unsigned int ctorsindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1866,6 +1867,7 @@ static struct module *load_module(void _
 #ifdef ARCH_UNWIND_SECTION_NAME
 	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
 #endif
+	ctorsindex = find_sec(hdr, sechdrs, secstrings, ".ctors");
 
 	/* Don't keep modinfo and version sections. */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -2076,6 +2078,8 @@ static struct module *load_module(void _
 	mod->num_markers =
 		sechdrs[markersindex].sh_size / sizeof(*mod->markers);
 #endif
+	mod->ctors = (void *) sechdrs[ctorsindex].sh_addr;
+	mod->num_ctors = sechdrs[ctorsindex].sh_size / sizeof(*mod->ctors);
 
         /* Find duplicate symbols */
 	err = verify_export_symbols(mod);
@@ -2188,6 +2192,14 @@ static struct module *load_module(void _
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
@@ -2218,6 +2230,7 @@ sys_init_module(void __user *umod,
 	blocking_notifier_call_chain(&module_notify_list,
 			MODULE_STATE_COMING, mod);
 
+	do_mod_ctors(mod);
 	/* Start the module */
 	if (mod->init != NULL)
 		ret = mod->init();
Index: linux-2.6.26-rc4/init/main.c
===================================================================
--- linux-2.6.26-rc4.orig/init/main.c
+++ linux-2.6.26-rc4/init/main.c
@@ -684,6 +684,15 @@ asmlinkage void __init start_kernel(void
 	rest_init();
 }
 
+static void __init do_ctors(void)
+{
+	ctorcall_t *call;
+
+	for (call = (ctorcall_t *) __ctor_start;
+	     call < (ctorcall_t *) __ctor_end; call++)
+		(*call)();
+}
+
 static int __initdata initcall_debug;
 
 static int __init initcall_debug_setup(char *str)
@@ -763,6 +772,7 @@ static void __init do_basic_setup(void)
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
+	do_ctors();
 	do_initcalls();
 }
 
Index: linux-2.6.26-rc4/include/linux/init.h
===================================================================
--- linux-2.6.26-rc4.orig/include/linux/init.h
+++ linux-2.6.26-rc4/include/linux/init.h
@@ -138,6 +138,8 @@ typedef void (*exitcall_t)(void);
 extern initcall_t __con_initcall_start[], __con_initcall_end[];
 extern initcall_t __security_initcall_start[], __security_initcall_end[];
 
+typedef void (*ctorcall_t)(void);
+
 /* Defined in init/main.c */
 extern char __initdata boot_command_line[];
 extern char *saved_command_line;


