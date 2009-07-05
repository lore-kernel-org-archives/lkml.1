Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbZGEXYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbZGEXYH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 19:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZGEXXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 19:23:55 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:37591 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbZGEXXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 19:23:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qfBSvT5PQc0K0ZqWL0XtrLUAMzcSMe5byam42ZIT4h12KYmfT9xG9Vg6Em0BUUa/bk
         7rao60VXRYZAueBuoGKw1c4CCrPDS1RQs1lk+1xnA3brUkC4Afm1EvNe9QZrExzDE8tF
         7L1NQDoeiAc7yBv9iF87UlkD53xMImlcGAboE=
MIME-Version: 1.0
Date: Sun, 5 Jul 2009 19:23:56 -0400
Message-ID: <817ecb6f0907051623l46ad93e9uc24d8d61669c938e@mail.gmail.com>
Subject: [PATCH v3] RO/NX protection for loadable kernel modules
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
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
right before successful exit from load_module(). Further,
module_free() have been modified to set module_core or module_init as
RW+NX right before calling vfree().

By default, the original section layout is preserved and RO/NX is
enforced only for whole pages of same content.
However, when compiled with CONFIG_DEBUG_RODATA=y, the patch
will page-align each group of section to ensure that each page contains
only one type of content mentioned above.

v1: Initial proof-of concept patch.

v2: The patch have been re-written to reduce the number of #ifdefs and
to make it architecture-agnostic. Code formatting have been corrected also.

v3: Opportunistic RO/NX protectiuon is now unconditional. Section
page-alignment is enabled when CONFIG_DEBUG_RODATA=y.

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
index e797812..357ab77 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -63,6 +63,45 @@
 #define ARCH_SHF_SMALL 0
 #endif

+/* Modules' sections will be aligned on page boundaries
+ * to ensure complete separation of code and data */
+#ifdef CONFIG_DEBUG_RODATA
+#define ALIGN_MODULE_SECTION(SECTION, ALIGNMENT) \
+	do { SECTION = ALIGN(SECTION, ALIGNMENT); } while (0)
+#else
+#define ALIGN_MODULE_SECTION(SECTION, ALIGNMENT) do { ; } while (0)
+#endif
+
+/* Given a virtual address returns 1 if the address is page-aligned,
+ * 0 otherwise */
+#define PAGE_ALIGNED(ADDR) (((unsigned long) ADDR & \
+				((1UL << PAGE_SHIFT) - 1UL)) ? \
+					(0) : (1))
+
+/* Given a virtual address returns a virtual page number
+ * that contains that address */
+#define PAGE_NUMBER(ADDR) (((unsigned long) ADDR) >> PAGE_SHIFT)
+
+/* Given BASE and SIZE this macro calculates the number of pages the
+ * memory regions occupies */
+#define NUMBER_OF_PAGES(BASE, SIZE) ((SIZE > 0) ?	\
+		(PAGE_NUMBER(BASE + SIZE - 1) -		\
+			 PAGE_NUMBER(BASE) + 1)		\
+		: (0UL))
+
+/* This macro catches a section group with SEC_ID and records it's
+ * size into SEC_SIZE, aligning it (as well as SIZE) on page boundary
+ * if necessary */
+#define CATCH_MODULE_SECTION(SEC_GROUP, SEC_ID, SEC_SIZE, SIZE)	\
+	do {							\
+		if (SEC_GROUP == SEC_ID) {			\
+			/* align section size to a page */	\
+			ALIGN_MODULE_SECTION(SIZE, PAGE_SIZE);	\
+			/* set new module section size */	\
+			SEC_SIZE = SIZE;			\
+		}						\
+	} while (0)
+
 /* If this is set, the section belongs in the init part of the module */
 #define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))

@@ -187,6 +226,35 @@ extern const unsigned long __start___kcrctab_unused_gpl[];
 #define symversion(base, idx) ((base != NULL) ? ((base) + (idx)) : NULL)
 #endif

+/* Generic memory allocation for modules, since
+ * module_alloc() is platform-specific */
+#define generic_module_alloc(size) module_alloc(size)
+
+/* Free memory returned from generic_module_alloc, since
+ * module_free() is platform-specific */
+void generic_module_free(struct module *mod, void *module_region)
+{
+	unsigned long total_pages;
+
+	if (mod->module_core == module_region) {
+		/* Set core as NX+RW */
+		total_pages = NUMBER_OF_PAGES(mod->module_core, mod->core_size);
+		DEBUGP("RELEASING MODULE CORE: 0x%lx %lu\n",
+				(unsigned long)mod->module_core, total_pages);
+		set_memory_nx((unsigned long)mod->module_core, total_pages);
+		set_memory_rw((unsigned long)mod->module_core, total_pages);
+
+	} else if (mod->module_init == module_region) {
+		/* Set init as NX+RW */
+		total_pages = NUMBER_OF_PAGES(mod->module_init, mod->init_size);
+		DEBUGP("RELEASING MODULE INIT: 0x%lx %lu\n",
+				(unsigned long)mod->module_init, total_pages);
+		set_memory_nx((unsigned long)mod->module_init, total_pages);
+		set_memory_rw((unsigned long)mod->module_init, total_pages);
+	}
+	module_free(mod, module_region);
+}
+
 static bool each_symbol_in_section(const struct symsearch *arr,
 				   unsigned int arrsize,
 				   struct module *owner,
@@ -1493,7 +1561,7 @@ static void free_module(struct module *mod)
 	ftrace_release(mod->module_core, mod->core_size);

 	/* This may be NULL, but that's OK */
-	module_free(mod, mod->module_init);
+	generic_module_free(mod, mod->module_init);
 	kfree(mod->args);
 	if (mod->percpu)
 		percpu_modfree(mod->percpu);
@@ -1505,7 +1573,7 @@ static void free_module(struct module *mod)
 	lockdep_free_key_range(mod->module_core, mod->core_size);

 	/* Finally, free the core (containing the module structure) */
-	module_free(mod, mod->module_core);
+	generic_module_free(mod, mod->module_core);
 }

 void *__symbol_get(const char *symbol)
@@ -1678,8 +1746,18 @@ static void layout_sections(struct module *mod,
 			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
 		}
-		if (m == 0)
-			mod->core_text_size = mod->core_size;
+		/* SECTION 0: executable code (text)*/
+		CATCH_MODULE_SECTION(m, 0, mod->core_text_size,
+					mod->core_size);
+
+		/* SECTION 1: RO data (executable code + RO data)*/
+		CATCH_MODULE_SECTION(m, 1, mod->core_ro_size,
+					mod->core_size);
+
+		/* SECTION 3: whole module (executable code + RO data +
+		 * RW data + small alloc )*/
+		CATCH_MODULE_SECTION(m, 3, mod->core_size,
+					mod->core_size);
 	}

 	DEBUGP("Init section allocation order:\n");
@@ -1696,8 +1774,18 @@ static void layout_sections(struct module *mod,
 					 | INIT_OFFSET_MASK);
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
 		}
-		if (m == 0)
-			mod->init_text_size = mod->init_size;
+		/* SECTION 0: executable code (text)*/
+		CATCH_MODULE_SECTION(m, 0, mod->init_text_size,
+					mod->init_size);
+
+		/* SECTION 1: RO data (executable code + RO data)*/
+		CATCH_MODULE_SECTION(m, 1, mod->init_ro_size,
+					mod->init_size);
+
+		/* SECTION 3: whole module (executable code + RO data +
+		 * RW data + small alloc )*/
+		CATCH_MODULE_SECTION(m, 3, mod->init_size,
+					mod->init_size);
 	}
 }

@@ -1866,7 +1954,7 @@ static void dynamic_debug_setup(struct _ddebug
*debug, unsigned int num)

 static void *module_alloc_update_bounds(unsigned long size)
 {
-	void *ret = module_alloc(size);
+	void *ret = generic_module_alloc(size);

 	if (ret) {
 		/* Update module bounds. */
@@ -1878,6 +1966,72 @@ static void
*module_alloc_update_bounds(unsigned long size)
 	return ret;
 }

+/* LKM RO/NX protection: protect module's text/ro-data
+ * from modification and any data from execution.
+ * Siarhei Liakh, Xuxian Jiang  */
+static void set_section_ro_nx(unsigned long base,
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
+		begin_addr = base;
+		end_addr = begin_addr + ro_size;
+
+		/*skip last page if end address is not page-aligned*/
+		if (!PAGE_ALIGNED(end_addr))
+			end_addr = ALIGN(end_addr - PAGE_SIZE, PAGE_SIZE);
+
+		/*Set text RO if there are still pages between begin and end*/
+		if (end_addr > begin_addr) {
+			pg_count = PAGE_NUMBER(end_addr - 1) -
+					PAGE_NUMBER(begin_addr) + 1;
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
+		begin_addr = base + text_size;
+		end_addr = base + total_size;
+
+		/*skip first page if beginning address is not page-aligned*/
+		if (!PAGE_ALIGNED(begin_addr))
+			begin_addr = ALIGN(begin_addr, PAGE_SIZE);
+
+		/*Set data NX if there are still pages between begin and end*/
+		if (end_addr > begin_addr) {
+			pg_count = PAGE_NUMBER(end_addr - 1) -
+					PAGE_NUMBER(begin_addr) + 1;
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
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static noinline struct module *load_module(void __user *umod,
@@ -2291,6 +2445,18 @@ static noinline struct module *load_module(void
__user *umod,
 	/* Get rid of temporary copy */
 	vfree(hdr);

+	/* Set RO and NX regions for core */
+	set_section_ro_nx((unsigned long)mod->module_core,
+				mod->core_text_size,
+				mod->core_ro_size,
+				mod->core_size);
+
+	/* Set RO and NX regions for init */
+	set_section_ro_nx((unsigned long)mod->module_init,
+				mod->init_text_size,
+				mod->init_ro_size,
+				mod->init_size);
+
 	/* Done! */
 	return mod;

@@ -2309,9 +2475,9 @@ static noinline struct module *load_module(void
__user *umod,
  free_init:
 	percpu_modfree(mod->refptr);
 #endif
-	module_free(mod, mod->module_init);
+	generic_module_free(mod, mod->module_init);
  free_core:
-	module_free(mod, mod->module_core);
+	generic_module_free(mod, mod->module_core);
 	/* mod will be freed with core. Don't access it beyond this line! */
  free_percpu:
 	if (percpu)
@@ -2394,7 +2560,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	mutex_lock(&module_mutex);
 	/* Drop initial reference. */
 	module_put(mod);
-	module_free(mod, mod->module_init);
+	generic_module_free(mod, mod->module_init);
 	mod->module_init = NULL;
 	mod->init_size = 0;
 	mod->init_text_size = 0;
