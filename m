Return-Path: <linux-kernel-owner+w=401wt.eu-S1759560AbZF2PQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbZF2PQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZF2PQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:16:42 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:64344 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbZF2PQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:16:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=JK9fGRo5ARNuaxrLi6hbW3yz9kJRsancYPxBXMBp3DNkk+BS2oA8YYrLEM1zxSW5PW
         2/LqWPYWiTISUMmGCvq9Hnajp4R8/9/x6B6wLFPEl94Qydj5nYCmx9KYoyv5w3mPPXU+
         RjsbZOQpzca74eVSNQ5NGIvqFJto/Ym8GTsAE=
MIME-Version: 1.0
Date: Mon, 29 Jun 2009 11:16:40 -0400
Message-ID: <817ecb6f0906290816t2537e5des3b78b32c6fd16700@mail.gmail.com>
Subject: [PATCH v2] RO/NX protection for loadable kernel modules
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Andi Kleen <ak@muc.de>,
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
RW+NX right before calling vfree(). Functionality of this patch is
enabled only when CONFIG_DEBUG_RODATA defined at compile time.

This is the second revision of the patch: it have been re-written to reduce the
number of #ifdefs and to make it architecture-agnostic. Code formatting have
been corrected also.

The patch have been developed for Linux 2.6.30.

Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>


diff --git a/include/linux/module.h b/include/linux/module.h
index 627ac08..75e7428 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -293,6 +293,11 @@ struct module
 	/* The size of the executable code in each section.  */
 	unsigned int init_text_size, core_text_size;

+#ifdef CONFIG_DEBUG_RODATA
+	/* Size of RO sections of the module (text+rodata) */
+	unsigned int init_ro_size, core_ro_size;
+#endif
+
 	/* Arch-specific module values */
 	struct mod_arch_specific arch;

diff --git a/kernel/module.c b/kernel/module.c
index e797812..7a35321 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -63,6 +63,125 @@
 #define ARCH_SHF_SMALL 0
 #endif

+#ifdef CONFIG_DEBUG_RODATA
+/* LKM RO/NX protection: set of macros to protect module's text/ro-data
+ * from modification and any data from execution.
+ * Siarhei Liakh, Xuxian Jiang  */
+
+/* Given BASE and SIZE this macro calculates the number of pages this
+ * memory regions occupies */
+#define NUMBER_OF_PAGES(BASE, SIZE) ((unsigned long) \
+	(((unsigned long) BASE + (unsigned long) SIZE) >> PAGE_SHIFT) - \
+	(((unsigned long) BASE) >> PAGE_SHIFT) + ((SIZE > 0) ? 1 : 0))
+
+/* Sets RO and NX regions for module core and init sections */
+#define SET_SECTION_RO_NX(BASE, TEXT_PAGES, RO_PAGES, TOTAL_PAGES) 	\
+	do {								\
+		DEBUGP("MODULE SECTION: 0x%lx %lu\n"			\
+			"  RO: 0x%lx %lu\n"				\
+			"  NX: 0x%lx %lu\n",				\
+			(unsigned long)BASE, (unsigned long)TOTAL_PAGES,\
+			(unsigned long)BASE, (unsigned long)RO_PAGES,	\
+			(unsigned long)BASE +				\
+			  ((unsigned long)TEXT_PAGES << PAGE_SHIFT),	\
+			(unsigned long)TOTAL_PAGES -			\
+			  (unsigned long)TEXT_PAGES);			\
+		if (RO_PAGES > 0)					\
+			set_memory_ro((unsigned long)BASE,		\
+					(unsigned long)RO_PAGES);	\
+		if (TOTAL_PAGES > TEXT_PAGES)				\
+			set_memory_nx((unsigned long)BASE + 		\
+					  ((unsigned long)TEXT_PAGES <<	\
+					    PAGE_SHIFT) ,		\
+					(unsigned long)TOTAL_PAGES -	\
+					  (unsigned long)TEXT_PAGES);	\
+	} while (0)
+
+#define PROTECT_MODULE(MOD) 					\
+	do {							\
+		/* Set RO and NX regions for core */		\
+		SET_SECTION_RO_NX(MOD->module_core,		\
+			NUMBER_OF_PAGES(MOD->module_core,	\
+					 MOD->core_text_size),	\
+			NUMBER_OF_PAGES(MOD->module_core,	\
+					 MOD->core_ro_size),	\
+			NUMBER_OF_PAGES(MOD->module_core,	\
+					 MOD->core_size));	\
+		/* Set RO and NX regions for init */		\
+		SET_SECTION_RO_NX(MOD->module_init,		\
+			NUMBER_OF_PAGES(MOD->module_init,	\
+					 MOD->init_text_size),	\
+			NUMBER_OF_PAGES(MOD->module_init,	\
+					 MOD->init_ro_size),	\
+			NUMBER_OF_PAGES(MOD->module_init,	\
+					 MOD->init_size));	\
+	} while (0)
+
+#define DEFINE_ALIGNMENT_FLAG(ALIGN_FLAG) int ALIGN_FLAG
+#define SET_ALIGNMENT_FLAG(ALIGN_FLAG, VAL)			\
+	do { ALIGN_FLAG = VAL; } while (0)
+
+#define ALIGN_MODULE_SECTION(SECTION_SIZE, ALIGN_FLAG)		\
+	do {							\
+		if (ALIGN_FLAG) {				\
+			SECTION_SIZE = ALIGN(SECTION_SIZE,	\
+						PAGE_SIZE);	\
+			ALIGN_FLAG = 0;				\
+		}						\
+	} while (0)
+
+#define CATCH_MODULE_RO_SECTION(SEC_GROUP, RO_SIZE, SIZE, ALIGN_FLAG)	\
+	do {								\
+		if (SEC_GROUP == 1) {					\
+			/* module RO size (text+rodata)	*/		\
+			RO_SIZE = SIZE;					\
+			/* next section should start on new page */	\
+			SET_ALIGNMENT_FLAG(ALIGN_FLAG, 1);		\
+		}							\
+	} while (0)
+
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
+#else
+
+#define PROTECT_MODULE(MOD) do { ; } while (0)
+#define generic_module_free(mod, module_region) module_free(mod ,
module_region)
+
+#define DEFINE_ALIGNMENT_FLAG(ALIGN_FLAG)
+#define SET_ALIGNMENT_FLAG(ALIGN_FLAG, VAL)
+#define ALIGN_MODULE_SECTION(SECTION_SIZE, ALIGN_FLAG)
+#define CATCH_MODULE_RO_SECTION(SEC_GROUP, RO_SIZE, SIZE, ALIGN_FLAG)
+
+#endif
+
+/* Generic memory allocation for modules, since
+ * module_alloc() is platform-specific */
+#define generic_module_alloc(size) module_alloc(size)
+
 /* If this is set, the section belongs in the init part of the module */
 #define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))

@@ -1493,7 +1612,7 @@ static void free_module(struct module *mod)
 	ftrace_release(mod->module_core, mod->core_size);

 	/* This may be NULL, but that's OK */
-	module_free(mod, mod->module_init);
+	generic_module_free(mod, mod->module_init);
 	kfree(mod->args);
 	if (mod->percpu)
 		percpu_modfree(mod->percpu);
@@ -1505,7 +1624,7 @@ static void free_module(struct module *mod)
 	lockdep_free_key_range(mod->module_core, mod->core_size);

 	/* Finally, free the core (containing the module structure) */
-	module_free(mod, mod->module_core);
+	generic_module_free(mod, mod->module_core);
 }

 void *__symbol_get(const char *symbol)
@@ -1661,10 +1780,12 @@ static void layout_sections(struct module *mod,
 		{ ARCH_SHF_SMALL | SHF_ALLOC, 0 }
 	};
 	unsigned int m, i;
+	DEFINE_ALIGNMENT_FLAG(need_alignment);

 	for (i = 0; i < hdr->e_shnum; i++)
 		sechdrs[i].sh_entsize = ~0UL;

+	SET_ALIGNMENT_FLAG(need_alignment, 1);
 	DEBUGP("Core section allocation order:\n");
 	for (m = 0; m < ARRAY_SIZE(masks); ++m) {
 		for (i = 0; i < hdr->e_shnum; ++i) {
@@ -1675,13 +1796,22 @@ static void layout_sections(struct module *mod,
 			    || s->sh_entsize != ~0UL
 			    || strstarts(secstrings + s->sh_name, ".init"))
 				continue;
+			ALIGN_MODULE_SECTION(mod->core_size, need_alignment);
 			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
 		}
-		if (m == 0)
+		if (m == 0) {
+			/* module code size */
 			mod->core_text_size = mod->core_size;
+			/* Align next section, if needed */
+			SET_ALIGNMENT_FLAG(need_alignment, 1);
+		}
+
+		CATCH_MODULE_RO_SECTION(m, mod->core_ro_size,
+					mod->core_size,	need_alignment);
 	}

+	SET_ALIGNMENT_FLAG(need_alignment, 1);
 	DEBUGP("Init section allocation order:\n");
 	for (m = 0; m < ARRAY_SIZE(masks); ++m) {
 		for (i = 0; i < hdr->e_shnum; ++i) {
@@ -1692,12 +1822,20 @@ static void layout_sections(struct module *mod,
 			    || s->sh_entsize != ~0UL
 			    || !strstarts(secstrings + s->sh_name, ".init"))
 				continue;
+			ALIGN_MODULE_SECTION(mod->init_size, need_alignment);
 			s->sh_entsize = (get_offset(mod, &mod->init_size, s, i)
 					 | INIT_OFFSET_MASK);
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
 		}
-		if (m == 0)
+		if (m == 0) {
+			/* module code size */
 			mod->init_text_size = mod->init_size;
+			/* Align next section, if needed */
+			SET_ALIGNMENT_FLAG(need_alignment, 1);
+		}
+
+		CATCH_MODULE_RO_SECTION(m, mod->init_ro_size,
+					mod->init_size,	need_alignment);
 	}
 }

@@ -1866,7 +2004,7 @@ static void dynamic_debug_setup(struct _ddebug
*debug, unsigned int num)

 static void *module_alloc_update_bounds(unsigned long size)
 {
-	void *ret = module_alloc(size);
+	void *ret = generic_module_alloc(size);

 	if (ret) {
 		/* Update module bounds. */
@@ -2291,6 +2429,9 @@ static noinline struct module *load_module(void
__user *umod,
 	/* Get rid of temporary copy */
 	vfree(hdr);

+	/* Set RO/NX protection, if enabled*/
+	PROTECT_MODULE(mod);
+
 	/* Done! */
 	return mod;

@@ -2309,9 +2450,9 @@ static noinline struct module *load_module(void
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
@@ -2394,7 +2535,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	mutex_lock(&module_mutex);
 	/* Drop initial reference. */
 	module_put(mod);
-	module_free(mod, mod->module_init);
+	generic_module_free(mod, mod->module_init);
 	mod->module_init = NULL;
 	mod->init_size = 0;
 	mod->init_text_size = 0;
