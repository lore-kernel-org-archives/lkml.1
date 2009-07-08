Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbZGHArx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbZGHArx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 20:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbZGHArp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 20:47:45 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:61203 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbZGHAro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 20:47:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZFLMACzsWX8b2q7bWYHi4t4bCrCSb0SDx/iAAHhCa7ljUGimLLwnAxn04yxtt6rt1g
         tiiJ4FpEJ0Zc8nPNpQvqXaSkVek6daQcEqLp9LZhceBSvPNI97NA/GBVJ8k1pBJDKMys
         rH2H/aJNQitfcWeNG/99RzDw9YuaPO5njlxzk=
MIME-Version: 1.0
In-Reply-To: <200907061043.11793.rusty@rustcorp.com.au>
References: <817ecb6f0907051623l46ad93e9uc24d8d61669c938e@mail.gmail.com>
	 <200907061043.11793.rusty@rustcorp.com.au>
Date: Tue, 7 Jul 2009 20:47:42 -0400
Message-ID: <817ecb6f0907071747g1d3455cdy9eb84102c17c5ad0@mail.gmail.com>
Subject: [PATCH v4] RO/NX protection for loadable kernel modules
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

By default, the original section layout is preserved and RO/NX is
enforced only for whole pages of same content.
However, when compiled with CONFIG_DEBUG_RODATA=y, the patch
will page-align each group of sections to ensure that each page contains
only one type of content mentioned above.

v1: Initial proof-of concept patch.

v2: The patch have been re-written to reduce the number of #ifdefs and
to make it architecture-agnostic. Code formatting have been corrected also.

v3: Opportunistic RO/NX protectiuon is now unconditional. Section
page-alignment is enabled when CONFIG_DEBUG_RODATA=y.

v4: Removed most macros and improved coding style.

The patch have been developed for Linux 2.6.30 by Siarhei Liakh
<sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.

---

Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>

diff --git a/include/linux/module.h b/include/linux/module.h
index 627ac08..5ba770e 100644
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

diff --git a/kernel/module.c b/kernel/module.c
index e797812..3a995db 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -52,6 +52,7 @@
 #include <linux/ftrace.h>
 #include <linux/async.h>
 #include <linux/percpu.h>
+#include <linux/pfn.h>

 #if 0
 #define DEBUGP printk
@@ -63,6 +64,22 @@
 #define ARCH_SHF_SMALL 0
 #endif

+/* Modules' sections will be aligned on page boundaries
+ * to ensure complete separation of code and data, but
+ * only when CONFIG_DEBUG_RODATA=y */
+#ifdef CONFIG_DEBUG_RODATA
+#define debug_align(X) ALIGN(X, PAGE_SIZE)
+#else
+#define debug_align(X) (X)
+#endif
+
+/* Given BASE and SIZE this macro calculates the number of pages the
+ * memory regions occupies */
+#define NUMBER_OF_PAGES(BASE, SIZE) ((SIZE > 0) ?		\
+		(PFN_DOWN((unsigned long)BASE + SIZE - 1) -	\
+			 PFN_DOWN((unsigned long)BASE) + 1)	\
+		: (0UL))
+
 /* If this is set, the section belongs in the init part of the module */
 #define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))

@@ -1471,6 +1488,94 @@ static int __unlink_module(void *_mod)
 	return 0;
 }

+/* LKM RO/NX protection: protect module's text/ro-data
+ * from modification and any data from execution.
+ * Siarhei Liakh, Xuxian Jiang  */
+static void set_section_ro_nx(void *base,
+			unsigned long text_size,
+			unsigned long ro_size,
+			unsigned long total_size)
+{
+	/* begin and end addresses of the current subsection */
+	unsigned long begin_addr;
+	unsigned long end_addr;
+	unsigned long pg_count; /*number of pages that will be affectred*/
+
+	/* Initially, all module sections have RWX permissions*/
+
+	DEBUGP("PROTECTING MODULE SECTION: 0x%lx\n"
+			"  text size: %lu\n"
+			"  ro size: %lu\n"
+			"  total size: %lu\n",
+			base, text_size, ro_size, total_size);
+
+	/* Set RO for module text and RO-data*/
+	if (ro_size > 0) {
+		begin_addr = (unsigned long) base;
+		end_addr = begin_addr + ro_size;
+
+		/*skip last page if end address is not page-aligned*/
+		if (!IS_ALIGNED(end_addr, PAGE_SIZE))
+			end_addr = ALIGN(end_addr - PAGE_SIZE, PAGE_SIZE);
+
+		/*Set text RO if there are still pages between begin and end*/
+		if (end_addr > begin_addr) {
+			pg_count = PFN_DOWN(end_addr - 1) -
+					PFN_DOWN(begin_addr) + 1;
+			DEBUGP("  RO: 0x%lx %lu\n", begin_addr, pg_count);
+			set_memory_ro(begin_addr, pg_count);
+		} else {
+			DEBUGP("  RO: less than a page, not enforcing.\n");
+		}
+	} else {
+		DEBUGP("  RO: section not present.\n");
+	}
+
+	/* Set NX permissions for module data */
+	if (total_size > text_size) {
+		begin_addr = (unsigned long) base + text_size;
+		end_addr = (unsigned long) base + total_size;
+
+		/*skip first page if beginning address is not page-aligned*/
+		begin_addr = PFN_UP(begin_addr) << PAGE_SHIFT;
+
+		/*Set data NX if there are still pages between begin and end*/
+		if (end_addr > begin_addr) {
+			pg_count = PFN_DOWN(end_addr - 1) -
+					PFN_DOWN(begin_addr) + 1;
+			DEBUGP("  NX: 0x%lx %lu\n", begin_addr, pg_count);
+			set_memory_nx(begin_addr, pg_count);
+		} else {
+			DEBUGP("  NX: less than a page, not enforcing.\n");
+		}
+	} else {
+		DEBUGP("  NX: section not present.\n");
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
+		DEBUGP("Restoring RW+NX for module's CORE: 0x%lx %lu\n",
+				(unsigned long)mod->module_core, total_pages);
+		set_memory_nx((unsigned long)mod->module_core, total_pages);
+		set_memory_rw((unsigned long)mod->module_core, total_pages);
+
+	} else if (mod->module_init == module_region) {
+		/* Set init as NX+RW */
+		total_pages = NUMBER_OF_PAGES(mod->module_init, mod->init_size);
+		DEBUGP("Restoring RW+NX for module's INIT: 0x%lx %lu\n",
+				(unsigned long)mod->module_init, total_pages);
+		set_memory_nx((unsigned long)mod->module_init, total_pages);
+		set_memory_rw((unsigned long)mod->module_init, total_pages);
+	}
+}
+
 /* Free a module, remove from lists, etc (must hold module_mutex). */
 static void free_module(struct module *mod)
 {
@@ -1493,6 +1598,7 @@ static void free_module(struct module *mod)
 	ftrace_release(mod->module_core, mod->core_size);

 	/* This may be NULL, but that's OK */
+	unset_section_ro_nx(mod, mod->module_init);
 	module_free(mod, mod->module_init);
 	kfree(mod->args);
 	if (mod->percpu)
@@ -1505,6 +1611,7 @@ static void free_module(struct module *mod)
 	lockdep_free_key_range(mod->module_core, mod->core_size);

 	/* Finally, free the core (containing the module structure) */
+	unset_section_ro_nx(mod, mod->module_core);
 	module_free(mod, mod->module_core);
 }

@@ -1678,8 +1785,20 @@ static void layout_sections(struct module *mod,
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
+		case 3: /* whole module core (executable + RO data +
+			 * RW data + small alloc) */
+			mod->core_size = debug_align(mod->core_size);
+			break;
+		}
 	}

 	DEBUGP("Init section allocation order:\n");
@@ -1696,8 +1815,20 @@ static void layout_sections(struct module *mod,
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
+		case 3: /* whole module init (executable + RO data +
+			 * RW data + small alloc) */
+			mod->init_size = debug_align(mod->init_size);
+			break;
+		}
 	}
 }

@@ -2291,6 +2422,18 @@ static noinline struct module *load_module(void
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

@@ -2394,6 +2537,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	mutex_lock(&module_mutex);
 	/* Drop initial reference. */
 	module_put(mod);
+	unset_section_ro_nx(mod, mod->module_init);
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;
 	mod->init_size = 0;
