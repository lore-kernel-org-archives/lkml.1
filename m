Return-Path: <linux-kernel-owner+w=401wt.eu-S932418AbZJELvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbZJELvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 07:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932365AbZJELvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 07:51:22 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:37936 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbZJELvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 07:51:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=chKJFD01FF6SXQmwXUFZbcPEwWVOKBc17KIcQ5fVU7m4rogMvZRChY1fjEBsMJi2ip
         3lvNpGZhmk4obYSQWQcq05/9e+00vGqkIs42GJwB0UhJsNBcaK8y7WoEaYQBUovenR2e
         BPm2Y7AMy2Zx4cBqFhO5n4gDZKjr3vAp52Zss=
MIME-Version: 1.0
Date: Mon, 5 Oct 2009 07:50:42 -0400
Message-ID: <817ecb6f0910050450o29ee65a1j49c27cf350b77493@mail.gmail.com>
Subject: [PATCH v7] RO/NX protection for loadable kernel modules
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a logical extension of the protection provided by
CONFIG_DEBUG_RODATA to LKMs. The protection is provided by splitting
module_core and module_init into three logical parts each and setting
appropriate page access permissions for each individual section:

 1. Code: RO+X
 2. RO data: RO+NX
 3. RW data: RW+NX

In order to achieve proper protection, layout_sections() have been
modified to align each of the three parts mentioned above onto page
boundary. Next, the corresponding page access permissions are set
right before successful exit from load_module(). Further, free_module()
and sys_init_module have been modified to set module_core and
module_init as RW+NX right before calling module_free().

By default, the original section layout and access flags are preserved.
When compiled with CONFIG_DEBUG_SET_MODULE_RONX=y, the patch
will page-align each group of sections to ensure that each page contains
only one type of content and will enforce RO/NX for each group of pages.

v1: Initial proof-of-concept patch.

v2: The patch have been re-written to reduce the number of #ifdefs and
to make it architecture-agnostic. Code formatting have been corrected also.

v3: Opportunistic RO/NX protectiuon is now unconditional. Section
page-alignment is enabled when CONFIG_DEBUG_RODATA=y.

v4: Removed most macros and improved coding style.

v5: Changed page-alignment and RO/NX section size calculation

v6: Fixed comments. Restricted RO/NX enforcement to x86 only

v7: Introduced CONFIG_DEBUG_SET_MODULE_RONX, added calls to
set_all_modules_text_rw() and set_all_modules_text_ro() in ftrace

The patch have been developed for Linux 2.6.30 by Siarhei Liakh
<sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.

---

Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index d8359e7..1c0f2bd 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -115,6 +115,17 @@ config DEBUG_RODATA_TEST
 	  feature as well as for the change_page_attr() infrastructure.
 	  If in doubt, say "N"

+config DEBUG_SET_MODULE_RONX
+	bool "Set loadable kernel module data as NX and text as RO"
+	default n
+	depends on X86 && MODULES
+	---help---
+	  This option helps to catch unintended modifications to loadable
+	  kernel module's text and read-only data. It also prevents execution
+	  of LKM's data. Such protection may interfere with run-time code
+	  patching and dynamic kernel tracing.
+	  If in doubt, say "N".
+
 config DEBUG_NX_TEST
 	tristate "Testcase for the NX non-executable stack feature"
 	depends on DEBUG_KERNEL && m
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index b79c553..2bc69fc 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -17,6 +17,7 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/list.h>
+#include <linux/module.h>

 #include <trace/syscall.h>

@@ -27,16 +28,17 @@


 #ifdef CONFIG_DYNAMIC_FTRACE
-
 int ftrace_arch_code_modify_prepare(void)
 {
 	set_kernel_text_rw();
+	set_all_modules_text_rw();
 	return 0;
 }

 int ftrace_arch_code_modify_post_process(void)
 {
 	set_kernel_text_ro();
+	set_all_modules_text_ro();
 	return 0;
 }

diff --git a/include/linux/module.h b/include/linux/module.h
index 627ac08..9225bdc 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -293,6 +293,9 @@ struct module
 	/* The size of the executable code in each section.  */
 	unsigned int init_text_size, core_text_size;

+	/* Size of RO sections of the module (text+rodata) */
+	unsigned int init_ro_size, core_ro_size;
+
 	/* Arch-specific module values */
 	struct mod_arch_specific arch;

@@ -517,6 +520,9 @@ extern void module_update_markers(void);
 extern void module_update_tracepoints(void);
 extern int module_get_iter_tracepoints(struct tracepoint_iter *iter);

+void set_all_modules_text_rw(void);
+void set_all_modules_text_ro(void);
+
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
@@ -641,6 +647,13 @@ static inline int
module_get_iter_tracepoints(struct tracepoint_iter *iter)
 	return 0;
 }

+static inline void set_all_modules_text_rw()
+{
+}
+
+static inline void set_all_modules_text_ro()
+{
+}
 #endif /* CONFIG_MODULES */

 struct device_driver;
diff --git a/kernel/module.c b/kernel/module.c
index e797812..f1c1941 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -52,6 +52,7 @@
 #include <linux/ftrace.h>
 #include <linux/async.h>
 #include <linux/percpu.h>
+#include <linux/pfn.h>

 #if 0
 #define DEBUGP printk
@@ -63,6 +64,26 @@
 #define ARCH_SHF_SMALL 0
 #endif

+/*
+ * Modules' sections will be aligned on page boundaries
+ * to ensure complete separation of code and data, but
+ * only when CONFIG_DEBUG_SET_MODULE_RONX=y
+ */
+#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+#define debug_align(X) ALIGN(X, PAGE_SIZE)
+#else
+#define debug_align(X) (X)
+#endif
+
+/*
+ * Given BASE and SIZE this macro calculates the number of pages the
+ * memory regions occupies
+ */
+#define NUMBER_OF_PAGES(BASE, SIZE) ((SIZE > 0) ?		\
+		(PFN_DOWN((unsigned long)BASE + SIZE - 1) -	\
+			 PFN_DOWN((unsigned long)BASE) + 1)	\
+		: (0UL))
+
 /* If this is set, the section belongs in the init part of the module */
 #define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))

@@ -1471,6 +1492,134 @@ static int __unlink_module(void *_mod)
 	return 0;
 }

+#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+/*
+ * LKM RO/NX protection: protect module's text/ro-data
+ * from modification and any data from execution.
+ */
+static void set_section_ro_nx(void *base,
+			unsigned long text_size,
+			unsigned long ro_size,
+			unsigned long total_size)
+{
+	/* begin and end PFNs of the current subsection */
+	unsigned long begin_pfn;
+	unsigned long end_pfn;
+
+	/*
+	 * Set RO for module text and RO-data:
+	 * - Always protect first page.
+	 * - Do not protect last partial page.
+	 */
+	if (ro_size > 0) {
+		begin_pfn = PFN_DOWN((unsigned long)base);
+		end_pfn = PFN_DOWN((unsigned long)base + ro_size);
+		if (end_pfn > begin_pfn)
+			set_memory_ro(begin_pfn << PAGE_SHIFT,
+						end_pfn - begin_pfn);
+	}
+
+	/*
+	 * Set NX permissions for module data:
+	 * - Do not protect first partial page.
+	 * - Always protect last page.
+	 */
+	if (total_size > text_size) {
+		begin_pfn = PFN_UP((unsigned long)base + text_size);
+		end_pfn = PFN_UP((unsigned long)base + total_size);
+		if (end_pfn > begin_pfn)
+			set_memory_nx(begin_pfn << PAGE_SHIFT,
+						end_pfn - begin_pfn);
+	}
+}
+
+/* Setting memory back to RW+NX before releasing it */
+void unset_section_ro_nx(struct module *mod, void *module_region)
+{
+	unsigned long total_pages;
+
+	if (mod->module_core == module_region) {
+		/* Set core as NX+RW */
+		total_pages = NUMBER_OF_PAGES(mod->module_core, mod->core_size);
+		set_memory_nx((unsigned long)mod->module_core, total_pages);
+		set_memory_rw((unsigned long)mod->module_core, total_pages);
+
+	} else if (mod->module_init == module_region) {
+		/* Set init as NX+RW */
+		total_pages = NUMBER_OF_PAGES(mod->module_init, mod->init_size);
+		set_memory_nx((unsigned long)mod->module_init, total_pages);
+		set_memory_rw((unsigned long)mod->module_init, total_pages);
+	}
+}
+
+/* Iterate through all modules and set each module's text as RW */
+void set_all_modules_text_rw()
+{
+	struct module *mod;
+	unsigned long begin_pfn;
+	unsigned long end_pfn;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry_rcu(mod, &modules, list) {
+		if ((mod->module_core) && (mod->core_text_size > 0)) {
+			begin_pfn = PFN_DOWN((unsigned long)mod->module_core);
+			end_pfn = PFN_DOWN((unsigned long)mod->module_core +
+						mod->core_text_size);
+			if (end_pfn > begin_pfn)
+				set_memory_rw(begin_pfn << PAGE_SHIFT,
+							end_pfn - begin_pfn);
+		}
+		if ((mod->module_init) && (mod->init_text_size > 0)) {
+			begin_pfn = PFN_DOWN((unsigned long)mod->module_init);
+			end_pfn = PFN_DOWN((unsigned long)mod->module_init +
+						mod->init_text_size);
+			if (end_pfn > begin_pfn)
+				set_memory_rw(begin_pfn << PAGE_SHIFT,
+							end_pfn - begin_pfn);
+		}
+	}
+	mutex_unlock(&module_mutex);
+}
+
+/* Iterate through all modules and set each module's text as RO */
+void set_all_modules_text_ro()
+{
+	struct module *mod;
+	unsigned long begin_pfn;
+	unsigned long end_pfn;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry_rcu(mod, &modules, list) {
+		if ((mod->module_core) && (mod->core_text_size > 0)) {
+			begin_pfn = PFN_DOWN((unsigned long)mod->module_core);
+			end_pfn = PFN_DOWN((unsigned long)mod->module_core +
+						mod->core_text_size);
+			if (end_pfn > begin_pfn)
+				set_memory_ro(begin_pfn << PAGE_SHIFT,
+							end_pfn - begin_pfn);
+		}
+		if ((mod->module_init) && (mod->init_text_size > 0)) {
+			begin_pfn = PFN_DOWN((unsigned long)mod->module_init);
+			end_pfn = PFN_DOWN((unsigned long)mod->module_init +
+						mod->init_text_size);
+			if (end_pfn > begin_pfn)
+				set_memory_ro(begin_pfn << PAGE_SHIFT,
+							end_pfn - begin_pfn);
+		}
+	}
+	mutex_unlock(&module_mutex);
+}
+#else
+static void set_section_ro_nx(void *base,
+			unsigned long text_size,
+			unsigned long ro_size,
+			unsigned long total_size) { }
+
+void unset_section_ro_nx(struct module *mod, void *module_region) { }
+void set_all_modules_text_rw() { }
+void set_all_modules_text_ro() { }
+#endif
+
 /* Free a module, remove from lists, etc (must hold module_mutex). */
 static void free_module(struct module *mod)
 {
@@ -1493,6 +1642,7 @@ static void free_module(struct module *mod)
 	ftrace_release(mod->module_core, mod->core_size);

 	/* This may be NULL, but that's OK */
+	unset_section_ro_nx(mod, mod->module_init);
 	module_free(mod, mod->module_init);
 	kfree(mod->args);
 	if (mod->percpu)
@@ -1505,6 +1655,7 @@ static void free_module(struct module *mod)
 	lockdep_free_key_range(mod->module_core, mod->core_size);

 	/* Finally, free the core (containing the module structure) */
+	unset_section_ro_nx(mod, mod->module_core);
 	module_free(mod, mod->module_core);
 }

@@ -1678,8 +1829,19 @@ static void layout_sections(struct module *mod,
 			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
 		}
-		if (m == 0)
+		switch (m) {
+		case 0: /* executable */
+			mod->core_size = debug_align(mod->core_size);
 			mod->core_text_size = mod->core_size;
+			break;
+		case 1: /* RO: text and ro-data */
+			mod->core_size = debug_align(mod->core_size);
+			mod->core_ro_size = mod->core_size;
+			break;
+		case 3: /* whole core */
+			mod->core_size = debug_align(mod->core_size);
+			break;
+		}
 	}

 	DEBUGP("Init section allocation order:\n");
@@ -1696,8 +1858,19 @@ static void layout_sections(struct module *mod,
 					 | INIT_OFFSET_MASK);
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
 		}
-		if (m == 0)
+		switch (m) {
+		case 0: /* executable */
+			mod->init_size = debug_align(mod->init_size);
 			mod->init_text_size = mod->init_size;
+			break;
+		case 1: /* RO: text and ro-data */
+			mod->init_size = debug_align(mod->init_size);
+			mod->init_ro_size = mod->init_size;
+			break;
+		case 3: /* whole init */
+			mod->init_size = debug_align(mod->init_size);
+			break;
+		}
 	}
 }

@@ -2291,6 +2464,18 @@ static noinline struct module *load_module(void
__user *umod,
 	/* Get rid of temporary copy */
 	vfree(hdr);

+	/* Set RO and NX regions for core */
+	set_section_ro_nx(mod->module_core,
+				mod->core_text_size,
+				mod->core_ro_size,
+				mod->core_size);
+
+	/* Set RO and NX regions for init */
+	set_section_ro_nx(mod->module_init,
+				mod->init_text_size,
+				mod->init_ro_size,
+				mod->init_size);
+
 	/* Done! */
 	return mod;

@@ -2394,6 +2579,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	mutex_lock(&module_mutex);
 	/* Drop initial reference. */
 	module_put(mod);
+	unset_section_ro_nx(mod, mod->module_init);
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;
 	mod->init_size = 0;
