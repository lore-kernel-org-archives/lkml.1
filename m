Return-Path: <linux-kernel-owner+w=401wt.eu-S1763850AbXF0XZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763850AbXF0XZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 19:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762039AbXF0XZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 19:25:48 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2026 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760920AbXF0XZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 19:25:45 -0400
Date: Thu, 28 Jun 2007 01:25:45 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Arch <linux-arch@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] cross-architecture ELF clean up
In-Reply-To: <468168FD.1080200@goop.org>
Message-ID: <Pine.LNX.4.64.0706280027100.4890@scrub.home>
References: <20070620230854.246399397@goop.org> <20070620230902.387008536@goop.org>
 <Pine.LNX.4.64.0706251531110.4386@scrub.home> <468168FD.1080200@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 26 Jun 2007, Jeremy Fitzhardinge wrote:

> > We have the __ASSEMBLY__ define for this, so just for asm code we don't need
> > a separate header.
> >   
> 
> Hm.  The number of __ASSEMBLY__s end up being pretty large, and it just seemed
> cleaner to put them in separate headers.

This could be avoided by reordering things within elf.h, but is it really 
necessary since there is no user of this right now?
Having actual users would help to decide how to deal with this, since e.g. 
if only a few constants were needed this could also be done via 
asm-offsets.h.

> > > 	linux/elf-decl.h	- ELF type declarations, without definitions
> > > 	linux/elf-defn.h	- ELF type definitions
> > >     
> > 
> > What's the point in splitting these two?
> >   
> 
> Because there are other headers which just need some type
> forward-declarations, and don't need the whole set of ELF types defined.  In
> particular, linux/module.h - which is included all over the place in the
> kernel - needs a couple of ELF types declared, and including it all over the
> place is just a waste.

module.h does indeed pull in way too much, but instead of hacking headers 
into little pieces, IMO it would be better to solve the real problem.
I played with it a little and the patch below moves a lot stuff out of 
module.h, so this would drastically reduce the header dependencies.
Unless there are major objections, I can test the patch a little more and 
convert the other archs.

bye, Roman

---
 arch/i386/kernel/module.c    |   24 +--
 drivers/base/bus.c           |    4 
 include/linux/module.h       |  173 ---------------------------
 include/linux/moduleloader.h |  212 +++++++++++++++++++++++++++++++++-
 include/linux/moduleparam.h  |   22 ---
 include/linux/unwind.h       |    4 
 kernel/module.c              |  267 +++++++++++++++++++++----------------------
 kernel/params.c              |   13 +-
 scripts/mod/modpost.c        |    9 -
 9 files changed, 369 insertions(+), 359 deletions(-)

Index: linux-2.6/include/linux/module.h
===================================================================
--- linux-2.6.orig/include/linux/module.h
+++ linux-2.6/include/linux/module.h
@@ -44,23 +44,6 @@ struct modversion_info
 
 struct module;
 
-struct module_attribute {
-        struct attribute attr;
-        ssize_t (*show)(struct module_attribute *, struct module *, char *);
-        ssize_t (*store)(struct module_attribute *, struct module *,
-			 const char *, size_t count);
-	void (*setup)(struct module *, const char *);
-	int (*test)(struct module *);
-	void (*free)(struct module *);
-};
-
-struct module_kobject
-{
-	struct kobject kobj;
-	struct module *mod;
-	struct kobject *drivers_dir;
-};
-
 /* These are either module local, or the kernel's dummy ones. */
 extern int init_module(void);
 extern void cleanup_module(void);
@@ -229,95 +212,13 @@ enum module_state
 	MODULE_STATE_GOING,
 };
 
-/* Similar stuff for section attributes. */
-struct module_sect_attr
-{
-	struct module_attribute mattr;
-	char *name;
-	unsigned long address;
-};
-
-struct module_sect_attrs
-{
-	struct attribute_group grp;
-	int nsections;
-	struct module_sect_attr attrs[0];
-};
-
-struct module_param_attrs;
-
 struct module
 {
 	enum module_state state;
 
-	/* Member of list of modules */
-	struct list_head list;
-
 	/* Unique handle for this module */
 	char name[MODULE_NAME_LEN];
 
-	/* Sysfs stuff. */
-	struct module_kobject mkobj;
-	struct module_param_attrs *param_attrs;
-	struct module_attribute *modinfo_attrs;
-	const char *version;
-	const char *srcversion;
-	struct kobject *holders_dir;
-
-	/* Exported symbols */
-	const struct kernel_symbol *syms;
-	unsigned int num_syms;
-	const unsigned long *crcs;
-
-	/* GPL-only exported symbols. */
-	const struct kernel_symbol *gpl_syms;
-	unsigned int num_gpl_syms;
-	const unsigned long *gpl_crcs;
-
-	/* unused exported symbols. */
-	const struct kernel_symbol *unused_syms;
-	unsigned int num_unused_syms;
-	const unsigned long *unused_crcs;
-	/* GPL-only, unused exported symbols. */
-	const struct kernel_symbol *unused_gpl_syms;
-	unsigned int num_unused_gpl_syms;
-	const unsigned long *unused_gpl_crcs;
-
-	/* symbols that will be GPL-only in the near future. */
-	const struct kernel_symbol *gpl_future_syms;
-	unsigned int num_gpl_future_syms;
-	const unsigned long *gpl_future_crcs;
-
-	/* Exception table */
-	unsigned int num_exentries;
-	const struct exception_table_entry *extable;
-
-	/* Startup function. */
-	int (*init)(void);
-
-	/* If this is non-NULL, vfree after init() returns */
-	void *module_init;
-
-	/* Here is the actual code + data, vfree'd on unload. */
-	void *module_core;
-
-	/* Here are the sizes of the init and core sections */
-	unsigned long init_size, core_size;
-
-	/* The size of the executable code in each section.  */
-	unsigned long init_text_size, core_text_size;
-
-	/* The handle returned from unwind_add_table. */
-	void *unwind_info;
-
-	/* Arch-specific module values */
-	struct mod_arch_specific arch;
-
-	/* Am I unsafe to unload? */
-	int unsafe;
-
-	unsigned int taints;	/* same bits as kernel:tainted */
-
 #ifdef CONFIG_GENERIC_BUG
 	/* Support for BUG */
 	struct list_head bug_list;
@@ -328,25 +229,6 @@ struct module
 #ifdef CONFIG_MODULE_UNLOAD
 	/* Reference counts */
 	struct module_ref ref[NR_CPUS];
-
-	/* What modules depend on me? */
-	struct list_head modules_which_use_me;
-
-	/* Who is waiting for us to be unloaded */
-	struct task_struct *waiter;
-
-	/* Destruction function. */
-	void (*exit)(void);
-#endif
-
-#ifdef CONFIG_KALLSYMS
-	/* We keep the symbol and string tables for kallsyms. */
-	Elf_Sym *symtab;
-	unsigned long num_symtab;
-	char *strtab;
-
-	/* Section attributes */
-	struct module_sect_attrs *sect_attrs;
 #endif
 
 	/* Per-cpu data. */
@@ -356,9 +238,6 @@ struct module
 	   keeping pointers to this stuff */
 	char *args;
 };
-#ifndef MODULE_ARCH_INIT
-#define MODULE_ARCH_INIT {}
-#endif
 
 /* FIXME: It'd be nice to isolate modules during init, too, so they
    aren't used before they (may) fail.  But presently too much code
@@ -571,58 +450,6 @@ static inline void print_modules(void)
 
 #endif /* CONFIG_MODULES */
 
-struct device_driver;
-#ifdef CONFIG_SYSFS
-struct module;
-
-extern struct kset module_subsys;
-
-int mod_sysfs_init(struct module *mod);
-int mod_sysfs_setup(struct module *mod,
-			   struct kernel_param *kparam,
-			   unsigned int num_params);
-int module_add_modinfo_attrs(struct module *mod);
-void module_remove_modinfo_attrs(struct module *mod);
-
-#else /* !CONFIG_SYSFS */
-
-static inline int mod_sysfs_init(struct module *mod)
-{
-	return 0;
-}
-
-static inline int mod_sysfs_setup(struct module *mod,
-			   struct kernel_param *kparam,
-			   unsigned int num_params)
-{
-	return 0;
-}
-
-static inline int module_add_modinfo_attrs(struct module *mod)
-{
-	return 0;
-}
-
-static inline void module_remove_modinfo_attrs(struct module *mod)
-{ }
-
-#endif /* CONFIG_SYSFS */
-
-#if defined(CONFIG_SYSFS) && defined(CONFIG_MODULES)
-
-void module_add_driver(struct module *mod, struct device_driver *drv);
-void module_remove_driver(struct device_driver *drv);
-
-#else /* not both CONFIG_SYSFS && CONFIG_MODULES */
-
-static inline void module_add_driver(struct module *mod, struct device_driver *drv)
-{ }
-
-static inline void module_remove_driver(struct device_driver *drv)
-{ }
-
-#endif
-
 #define symbol_request(x) try_then_request_module(symbol_get(x), "symbol:" #x)
 
 /* BELOW HERE ALL THESE ARE OBSOLETE AND WILL VANISH */
Index: linux-2.6/include/linux/moduleloader.h
===================================================================
--- linux-2.6.orig/include/linux/moduleloader.h
+++ linux-2.6/include/linux/moduleloader.h
@@ -5,20 +5,148 @@
 #include <linux/module.h>
 #include <linux/elf.h>
 
+struct module_kobject
+{
+	struct kobject kobj;
+	struct module_private *mod;
+	struct kobject *drivers_dir;
+};
+
+#define get_mod_private(m)	container_of(m, struct module_private, mod)
+
+struct module_private
+{
+	struct module mod;
+
+	/* Member of list of modules */
+	struct list_head list;
+
+	/* Sysfs stuff. */
+	struct module_kobject mkobj;
+	struct module_param_attrs *param_attrs;
+	struct module_attribute *modinfo_attrs;
+	const char *version;
+	const char *srcversion;
+	struct kobject *holders_dir;
+
+	/* Exported symbols */
+	const struct kernel_symbol *syms;
+	unsigned int num_syms;
+	const unsigned long *crcs;
+
+	/* GPL-only exported symbols. */
+	const struct kernel_symbol *gpl_syms;
+	unsigned int num_gpl_syms;
+	const unsigned long *gpl_crcs;
+
+	/* unused exported symbols. */
+	const struct kernel_symbol *unused_syms;
+	unsigned int num_unused_syms;
+	const unsigned long *unused_crcs;
+	/* GPL-only, unused exported symbols. */
+	const struct kernel_symbol *unused_gpl_syms;
+	unsigned int num_unused_gpl_syms;
+	const unsigned long *unused_gpl_crcs;
+
+	/* symbols that will be GPL-only in the near future. */
+	const struct kernel_symbol *gpl_future_syms;
+	unsigned int num_gpl_future_syms;
+	const unsigned long *gpl_future_crcs;
+
+	/* Exception table */
+	unsigned int num_exentries;
+	const struct exception_table_entry *extable;
+
+	/* Startup function. */
+	int (*init)(void);
+
+	/* If this is non-NULL, vfree after init() returns */
+	void *module_init;
+
+	/* Here is the actual code + data, vfree'd on unload. */
+	void *module_core;
+
+	/* Here are the sizes of the init and core sections */
+	unsigned long init_size, core_size;
+
+	/* The size of the executable code in each section.  */
+	unsigned long init_text_size, core_text_size;
+
+	/* The handle returned from unwind_add_table. */
+	void *unwind_info;
+
+	/* Arch-specific module values */
+	struct mod_arch_specific arch;
+
+	/* Am I unsafe to unload? */
+	int unsafe;
+
+	unsigned int taints;	/* same bits as kernel:tainted */
+
+#ifdef CONFIG_MODULE_UNLOAD
+	/* What modules depend on me? */
+	struct list_head modules_which_use_me;
+
+	/* Who is waiting for us to be unloaded */
+	struct task_struct *waiter;
+
+	/* Destruction function. */
+	void (*exit)(void);
+#endif
+
+#ifdef CONFIG_KALLSYMS
+	/* We keep the symbol and string tables for kallsyms. */
+	Elf_Sym *symtab;
+	unsigned long num_symtab;
+	char *strtab;
+
+	/* Section attributes */
+	struct module_sect_attrs *sect_attrs;
+#endif
+};
+#ifndef MODULE_ARCH_INIT
+#define MODULE_ARCH_INIT {}
+#endif
+
+struct module_attribute {
+        struct attribute attr;
+        ssize_t (*show)(struct module_attribute *, struct module_private *, char *);
+        ssize_t (*store)(struct module_attribute *, struct module_private *,
+			 const char *, size_t count);
+	void (*setup)(struct module_private *, const char *);
+	int (*test)(struct module_private *);
+	void (*free)(struct module_private *);
+};
+
+/* Similar stuff for section attributes. */
+struct module_sect_attr
+{
+	struct module_attribute mattr;
+	char *name;
+	unsigned long address;
+};
+
+struct module_sect_attrs
+{
+	struct attribute_group grp;
+	int nsections;
+	struct module_sect_attr attrs[0];
+};
+
 /* These must be implemented by the specific architecture */
 
 /* Adjust arch-specific sections.  Return 0 on success.  */
 int module_frob_arch_sections(Elf_Ehdr *hdr,
 			      Elf_Shdr *sechdrs,
 			      char *secstrings,
-			      struct module *mod);
+			      struct module_private *mod);
 
 /* Allocator used for allocating struct module, core sections and init
    sections.  Returns NULL on failure. */
 void *module_alloc(unsigned long size);
 
 /* Free memory returned from module_alloc. */
-void module_free(struct module *mod, void *module_region);
+void module_free(struct module_private *mod, void *module_region);
 
 /* Apply the given relocation to the (simplified) ELF.  Return -error
    or 0. */
@@ -26,7 +154,7 @@ int apply_relocate(Elf_Shdr *sechdrs,
 		   const char *strtab,
 		   unsigned int symindex,
 		   unsigned int relsec,
-		   struct module *mod);
+		   struct module_private *mod);
 
 /* Apply the given add relocation to the (simplified) ELF.  Return
    -error or 0 */
@@ -34,14 +162,86 @@ int apply_relocate_add(Elf_Shdr *sechdrs
 		       const char *strtab,
 		       unsigned int symindex,
 		       unsigned int relsec,
-		       struct module *mod);
+		       struct module_private *mod);
 
 /* Any final processing of module before access.  Return -error or 0. */
 int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
-		    struct module *mod);
+		    struct module_private *mod);
 
 /* Any cleanup needed when module leaves. */
-void module_arch_cleanup(struct module *mod);
+void module_arch_cleanup(struct module_private *mod);
+
+/* for exporting parameters in /sys/parameters */
+
+struct device_driver;
+
+#if defined(CONFIG_SYSFS) && defined(CONFIG_MODULES)
+extern int module_param_sysfs_setup(struct module_private *mod,
+				    struct kernel_param *kparam,
+				    unsigned int num_params);
+
+extern void module_param_sysfs_remove(struct module_private *mod);
+
+void module_add_driver(struct module_private *mod, struct device_driver *drv);
+void module_remove_driver(struct device_driver *drv);
+
+#else
+static inline int module_param_sysfs_setup(struct module_private *mod,
+					   struct kernel_param *kparam,
+					   unsigned int num_params)
+{
+	return 0;
+}
+
+static inline void module_param_sysfs_remove(struct module_private *mod)
+{
+}
+
+static inline void module_add_driver(struct module_private *mod, struct device_driver *drv)
+{
+}
+
+static inline void module_remove_driver(struct device_driver *drv)
+{
+}
+
+#endif
+
+#ifdef CONFIG_SYSFS
+
+extern struct kset module_subsys;
+
+int mod_sysfs_init(struct module_private *mod);
+int mod_sysfs_setup(struct module_private *mod,
+			   struct kernel_param *kparam,
+			   unsigned int num_params);
+int module_add_modinfo_attrs(struct module_private *mod);
+void module_remove_modinfo_attrs(struct module_private *mod);
+
+#else /* !CONFIG_SYSFS */
+
+static inline int mod_sysfs_init(struct module *mod)
+{
+	return 0;
+}
+
+static inline int mod_sysfs_setup(struct module_private *mod,
+			   struct kernel_param *kparam,
+			   unsigned int num_params)
+{
+	return 0;
+}
+
+static inline int module_add_modinfo_attrs(struct module_private *mod)
+{
+	return 0;
+}
+
+static inline void module_remove_modinfo_attrs(struct module_private *mod)
+{
+}
+
+#endif /* CONFIG_SYSFS */
 
 #endif
Index: linux-2.6/include/linux/moduleparam.h
===================================================================
--- linux-2.6.orig/include/linux/moduleparam.h
+++ linux-2.6/include/linux/moduleparam.h
@@ -165,26 +165,4 @@ extern int param_array_get(char *buffer,
 extern int param_set_copystring(const char *val, struct kernel_param *kp);
 extern int param_get_string(char *buffer, struct kernel_param *kp);
 
-/* for exporting parameters in /sys/parameters */
-
-struct module;
-
-#if defined(CONFIG_SYSFS) && defined(CONFIG_MODULES)
-extern int module_param_sysfs_setup(struct module *mod,
-				    struct kernel_param *kparam,
-				    unsigned int num_params);
-
-extern void module_param_sysfs_remove(struct module *mod);
-#else
-static inline int module_param_sysfs_setup(struct module *mod,
-			     struct kernel_param *kparam,
-			     unsigned int num_params)
-{
-	return 0;
-}
-
-static inline void module_param_sysfs_remove(struct module *mod)
-{ }
-#endif
-
 #endif /* _LINUX_MODULE_PARAMS_H */
Index: linux-2.6/include/linux/unwind.h
===================================================================
--- linux-2.6.orig/include/linux/unwind.h
+++ linux-2.6/include/linux/unwind.h
@@ -12,7 +12,7 @@
  * is not much point in implementing the full Dwarf2 unwind API.
  */
 
-struct module;
+struct module_private;
 
 struct unwind_frame_info {};
 
@@ -21,7 +21,7 @@ static inline void unwind_setup(void) {}
 
 #ifdef CONFIG_MODULES
 
-static inline void *unwind_add_table(struct module *mod,
+static inline void *unwind_add_table(struct module_private *mod,
                                      const void *table_start,
                                      unsigned long table_size)
 {
Index: linux-2.6/kernel/module.c
===================================================================
--- linux-2.6.orig/kernel/module.c
+++ linux-2.6/kernel/module.c
@@ -90,7 +90,7 @@ static inline int strong_try_module_get(
 	return try_module_get(mod);
 }
 
-static inline void add_taint_module(struct module *mod, unsigned flag)
+static inline void add_taint_module(struct module_private *mod, unsigned flag)
 {
 	add_taint(flag);
 	mod->taints |= flag;
@@ -173,11 +173,11 @@ static void printk_unused_warning(const 
 
 /* Find a symbol, return value, crc and module which owns it */
 static unsigned long __find_symbol(const char *name,
-				   struct module **owner,
+				   struct module_private **owner,
 				   const unsigned long **crc,
 				   int gplok)
 {
-	struct module *mod;
+	struct module_private *mod;
 	const struct kernel_symbol *ks;
 
 	/* Core kernel first. */ 
@@ -290,12 +290,12 @@ static unsigned long __find_symbol(const
 }
 
 /* Search for module by name: must hold module_mutex. */
-static struct module *find_module(const char *name)
+static struct module_private *find_module(const char *name)
 {
-	struct module *mod;
+	struct module_private *mod;
 
 	list_for_each_entry(mod, &modules, list) {
-		if (strcmp(mod->name, name) == 0)
+		if (strcmp(mod->mod.name, name) == 0)
 			return mod;
 	}
 	return NULL;
@@ -469,20 +469,20 @@ static inline void percpu_modcopy(void *
 #endif /* CONFIG_SMP */
 
 #define MODINFO_ATTR(field)	\
-static void setup_modinfo_##field(struct module *mod, const char *s)  \
+static void setup_modinfo_##field(struct module_private *mod, const char *s) \
 {                                                                     \
 	mod->field = kstrdup(s, GFP_KERNEL);                          \
 }                                                                     \
 static ssize_t show_modinfo_##field(struct module_attribute *mattr,   \
-	                struct module *mod, char *buffer)             \
+	                struct module_private *mod, char *buffer)     \
 {                                                                     \
 	return sprintf(buffer, "%s\n", mod->field);                   \
 }                                                                     \
-static int modinfo_##field##_exists(struct module *mod)               \
+static int modinfo_##field##_exists(struct module_private *mod)       \
 {                                                                     \
 	return mod->field != NULL;                                    \
 }                                                                     \
-static void free_modinfo_##field(struct module *mod)                  \
+static void free_modinfo_##field(struct module_private *mod)          \
 {                                                                     \
         kfree(mod->field);                                            \
         mod->field = NULL;                                            \
@@ -501,15 +501,15 @@ MODINFO_ATTR(srcversion);
 
 #ifdef CONFIG_MODULE_UNLOAD
 /* Init the unload section of the module. */
-static void module_unload_init(struct module *mod)
+static void module_unload_init(struct module_private *mod)
 {
 	unsigned int i;
 
 	INIT_LIST_HEAD(&mod->modules_which_use_me);
 	for (i = 0; i < NR_CPUS; i++)
-		local_set(&mod->ref[i].count, 0);
+		local_set(&mod->mod.ref[i].count, 0);
 	/* Hold reference count during initialization. */
-	local_set(&mod->ref[raw_smp_processor_id()].count, 1);
+	local_set(&mod->mod.ref[raw_smp_processor_id()].count, 1);
 	/* Backwards compatibility macros put refcount during init. */
 	mod->waiter = current;
 }
@@ -518,11 +518,11 @@ static void module_unload_init(struct mo
 struct module_use
 {
 	struct list_head list;
-	struct module *module_which_uses;
+	struct module_private *module_which_uses;
 };
 
 /* Does a already use b? */
-static int already_uses(struct module *a, struct module *b)
+static int already_uses(struct module_private *a, struct module_private *b)
 {
 	struct module_use *use;
 
@@ -537,34 +537,35 @@ static int already_uses(struct module *a
 }
 
 /* Module a uses b */
-static int use_module(struct module *a, struct module *b)
+static int use_module(struct module_private *a, struct module_private *b)
 {
 	struct module_use *use;
 	int no_warn;
 
-	if (b == NULL || already_uses(a, b)) return 1;
+	if (b == NULL || already_uses(a, b))
+		return 1;
 
-	if (!strong_try_module_get(b))
+	if (!strong_try_module_get(&b->mod))
 		return 0;
 
 	DEBUGP("Allocating new usage for %s.\n", a->name);
 	use = kmalloc(sizeof(*use), GFP_ATOMIC);
 	if (!use) {
-		printk("%s: out of memory loading\n", a->name);
-		module_put(b);
+		printk("%s: out of memory loading\n", a->mod.name);
+		module_put(&b->mod);
 		return 0;
 	}
 
 	use->module_which_uses = a;
 	list_add(&use->list, &b->modules_which_use_me);
-	no_warn = sysfs_create_link(b->holders_dir, &a->mkobj.kobj, a->name);
+	no_warn = sysfs_create_link(b->holders_dir, &a->mkobj.kobj, a->mod.name);
 	return 1;
 }
 
 /* Clear the unload stuff of the module. */
-static void module_unload_free(struct module *mod)
+static void module_unload_free(struct module_private *mod)
 {
-	struct module *i;
+	struct module_private *i;
 
 	list_for_each_entry(i, &modules, list) {
 		struct module_use *use;
@@ -572,10 +573,10 @@ static void module_unload_free(struct mo
 		list_for_each_entry(use, &i->modules_which_use_me, list) {
 			if (use->module_which_uses == mod) {
 				DEBUGP("%s unusing %s\n", mod->name, i->name);
-				module_put(i);
+				module_put(&i->mod);
 				list_del(&use->list);
 				kfree(use);
-				sysfs_remove_link(i->holders_dir, mod->name);
+				sysfs_remove_link(i->holders_dir, mod->mod.name);
 				/* There can be at most one match. */
 				break;
 			}
@@ -600,7 +601,7 @@ static inline int try_force_unload(unsig
 
 struct stopref
 {
-	struct module *mod;
+	struct module_private *mod;
 	int flags;
 	int *forced;
 };
@@ -611,17 +612,17 @@ static int __try_stop_module(void *_sref
 	struct stopref *sref = _sref;
 
 	/* If it's not unused, quit unless we are told to block. */
-	if ((sref->flags & O_NONBLOCK) && module_refcount(sref->mod) != 0) {
+	if ((sref->flags & O_NONBLOCK) && module_refcount(&sref->mod->mod) != 0) {
 		if (!(*sref->forced = try_force_unload(sref->flags)))
 			return -EWOULDBLOCK;
 	}
 
 	/* Mark it as dying. */
-	sref->mod->state = MODULE_STATE_GOING;
+	sref->mod->mod.state = MODULE_STATE_GOING;
 	return 0;
 }
 
-static int try_stop_module(struct module *mod, int flags, int *forced)
+static int try_stop_module(struct module_private *mod, int flags, int *forced)
 {
 	struct stopref sref = { mod, flags, forced };
 
@@ -639,16 +640,16 @@ unsigned int module_refcount(struct modu
 EXPORT_SYMBOL(module_refcount);
 
 /* This exists whether we can unload or not */
-static void free_module(struct module *mod);
+static void free_module(struct module_private *mod);
 
-static void wait_for_zero_refcount(struct module *mod)
+static void wait_for_zero_refcount(struct module_private *mod)
 {
 	/* Since we might sleep for some time, drop the semaphore first */
 	mutex_unlock(&module_mutex);
 	for (;;) {
 		DEBUGP("Looking at refcount...\n");
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (module_refcount(mod) == 0)
+		if (module_refcount(&mod->mod) == 0)
 			break;
 		schedule();
 	}
@@ -659,7 +660,7 @@ static void wait_for_zero_refcount(struc
 asmlinkage long
 sys_delete_module(const char __user *name_user, unsigned int flags)
 {
-	struct module *mod;
+	struct module_private *mod;
 	char name[MODULE_NAME_LEN];
 	int ret, forced = 0;
 
@@ -686,7 +687,7 @@ sys_delete_module(const char __user *nam
 	}
 
 	/* Doing init or already dying? */
-	if (mod->state != MODULE_STATE_LIVE) {
+	if (mod->mod.state != MODULE_STATE_LIVE) {
 		/* FIXME: if (force), slam module count and wake up
                    waiter --RR */
 		DEBUGP("%s already dying\n", mod->name);
@@ -714,7 +715,7 @@ sys_delete_module(const char __user *nam
 		goto out;
 
 	/* Never wait if forced. */
-	if (!forced && module_refcount(mod) != 0)
+	if (!forced && module_refcount(&mod->mod) != 0)
 		wait_for_zero_refcount(mod);
 
 	/* Final destruction now noone is using it. */
@@ -730,18 +731,18 @@ sys_delete_module(const char __user *nam
 	return ret;
 }
 
-static void print_unload_info(struct seq_file *m, struct module *mod)
+static void print_unload_info(struct seq_file *m, struct module_private *mod)
 {
 	struct module_use *use;
 	int printed_something = 0;
 
-	seq_printf(m, " %u ", module_refcount(mod));
+	seq_printf(m, " %u ", module_refcount(&mod->mod));
 
 	/* Always include a trailing , so userspace can differentiate
            between this and the old multi-field proc format. */
 	list_for_each_entry(use, &mod->modules_which_use_me, list) {
 		printed_something = 1;
-		seq_printf(m, "%s,", use->module_which_uses->name);
+		seq_printf(m, "%s,", use->module_which_uses->mod.name);
 	}
 
 	if (mod->unsafe) {
@@ -760,14 +761,14 @@ static void print_unload_info(struct seq
 
 void __symbol_put(const char *symbol)
 {
-	struct module *owner;
+	struct module_private *owner;
 	unsigned long flags;
 	const unsigned long *crc;
 
 	spin_lock_irqsave(&modlist_lock, flags);
 	if (!__find_symbol(symbol, &owner, &crc, 1))
 		BUG();
-	module_put(owner);
+	module_put(&owner->mod);
 	spin_unlock_irqrestore(&modlist_lock, flags);
 }
 EXPORT_SYMBOL(__symbol_put);
@@ -786,10 +787,10 @@ void symbol_put_addr(void *addr)
 EXPORT_SYMBOL_GPL(symbol_put_addr);
 
 static ssize_t show_refcnt(struct module_attribute *mattr,
-			   struct module *mod, char *buffer)
+			   struct module_private *mod, char *buffer)
 {
 	/* sysfs holds a reference */
-	return sprintf(buffer, "%u\n", module_refcount(mod)-1);
+	return sprintf(buffer, "%u\n", module_refcount(&mod->mod)-1);
 }
 
 static struct module_attribute refcnt = {
@@ -804,7 +805,7 @@ void module_put(struct module *module)
 		local_dec(&module->ref[cpu].count);
 		/* Maybe they're waiting for us to drop reference? */
 		if (unlikely(!module_is_live(module)))
-			wake_up_process(module->waiter);
+			wake_up_process(get_mod_private(module)->waiter);
 		put_cpu();
 	}
 }
@@ -832,11 +833,11 @@ static inline void module_unload_init(st
 #endif /* CONFIG_MODULE_UNLOAD */
 
 static ssize_t show_initstate(struct module_attribute *mattr,
-			   struct module *mod, char *buffer)
+			   struct module_private *mod, char *buffer)
 {
 	const char *state = "unknown";
 
-	switch (mod->state) {
+	switch (mod->mod.state) {
 	case MODULE_STATE_LIVE:
 		state = "live";
 		break;
@@ -871,7 +872,7 @@ static const char vermagic[] = VERMAGIC_
 static int check_version(Elf_Shdr *sechdrs,
 			 unsigned int versindex,
 			 const char *symname,
-			 struct module *mod, 
+			 struct module_private *mod,
 			 const unsigned long *crc)
 {
 	unsigned int i, num_versions;
@@ -892,7 +893,7 @@ static int check_version(Elf_Shdr *sechd
 		if (versions[i].crc == *crc)
 			return 1;
 		printk("%s: disagrees about version of symbol %s\n",
-		       mod->name, symname);
+		       mod->mod.name, symname);
 		DEBUGP("Found checksum %lX vs module %lX\n",
 		       *crc, versions[i].crc);
 		return 0;
@@ -900,17 +901,17 @@ static int check_version(Elf_Shdr *sechd
 	/* Not in module's version table.  OK, but that taints the kernel. */
 	if (!(tainted & TAINT_FORCED_MODULE))
 		printk("%s: no version for \"%s\" found: kernel tainted.\n",
-		       mod->name, symname);
+		       mod->mod.name, symname);
 	add_taint_module(mod, TAINT_FORCED_MODULE);
 	return 1;
 }
 
 static inline int check_modstruct_version(Elf_Shdr *sechdrs,
 					  unsigned int versindex,
-					  struct module *mod)
+					  struct module_private *mod)
 {
 	const unsigned long *crc;
-	struct module *owner;
+	struct module_private *owner;
 
 	if (!__find_symbol("struct_module", &owner, &crc, 1))
 		BUG();
@@ -929,7 +930,7 @@ static inline int same_magic(const char 
 static inline int check_version(Elf_Shdr *sechdrs,
 				unsigned int versindex,
 				const char *symname,
-				struct module *mod, 
+				struct module_private *mod,
 				const unsigned long *crc)
 {
 	return 1;
@@ -937,7 +938,7 @@ static inline int check_version(Elf_Shdr
 
 static inline int check_modstruct_version(Elf_Shdr *sechdrs,
 					  unsigned int versindex,
-					  struct module *mod)
+					  struct module_private *mod)
 {
 	return 1;
 }
@@ -953,9 +954,9 @@ static inline int same_magic(const char 
 static unsigned long resolve_symbol(Elf_Shdr *sechdrs,
 				    unsigned int versindex,
 				    const char *name,
-				    struct module *mod)
+				    struct module_private *mod)
 {
-	struct module *owner;
+	struct module_private *owner;
 	unsigned long ret;
 	const unsigned long *crc;
 
@@ -977,7 +978,7 @@ static unsigned long resolve_symbol(Elf_
  */
 #ifdef CONFIG_KALLSYMS
 static ssize_t module_sect_show(struct module_attribute *mattr,
-				struct module *mod, char *buf)
+				struct module_private *mod, char *buf)
 {
 	struct module_sect_attr *sattr =
 		container_of(mattr, struct module_sect_attr, mattr);
@@ -993,7 +994,7 @@ static void free_sect_attrs(struct modul
 	kfree(sect_attrs);
 }
 
-static void add_sect_attrs(struct module *mod, unsigned int nsect,
+static void add_sect_attrs(struct module_private *mod, unsigned int nsect,
 		char *secstrings, Elf_Shdr *sechdrs)
 {
 	unsigned int nloaded = 0, i, size[2];
@@ -1032,7 +1033,7 @@ static void add_sect_attrs(struct module
 		sattr->mattr.show = module_sect_show;
 		sattr->mattr.store = NULL;
 		sattr->mattr.attr.name = sattr->name;
-		sattr->mattr.attr.owner = mod;
+		sattr->mattr.attr.owner = &mod->mod;
 		sattr->mattr.attr.mode = S_IRUGO;
 		*(gattr++) = &(sattr++)->mattr.attr;
 	}
@@ -1047,7 +1048,7 @@ static void add_sect_attrs(struct module
 	free_sect_attrs(sect_attrs);
 }
 
-static void remove_sect_attrs(struct module *mod)
+static void remove_sect_attrs(struct module_private *mod)
 {
 	if (mod->sect_attrs) {
 		sysfs_remove_group(&mod->mkobj.kobj,
@@ -1072,7 +1073,7 @@ static inline void remove_sect_attrs(str
 #endif /* CONFIG_KALLSYMS */
 
 #ifdef CONFIG_SYSFS
-int module_add_modinfo_attrs(struct module *mod)
+int module_add_modinfo_attrs(struct module_private *mod)
 {
 	struct module_attribute *attr;
 	struct module_attribute *temp_attr;
@@ -1090,7 +1091,7 @@ int module_add_modinfo_attrs(struct modu
 		if (!attr->test ||
 		    (attr->test && attr->test(mod))) {
 			memcpy(temp_attr, attr, sizeof(*temp_attr));
-			temp_attr->attr.owner = mod;
+			temp_attr->attr.owner = &mod->mod;
 			error = sysfs_create_file(&mod->mkobj.kobj,&temp_attr->attr);
 			++temp_attr;
 		}
@@ -1098,7 +1099,7 @@ int module_add_modinfo_attrs(struct modu
 	return error;
 }
 
-void module_remove_modinfo_attrs(struct module *mod)
+void module_remove_modinfo_attrs(struct module_private *mod)
 {
 	struct module_attribute *attr;
 	int i;
@@ -1116,18 +1117,18 @@ void module_remove_modinfo_attrs(struct 
 #endif
 
 #ifdef CONFIG_SYSFS
-int mod_sysfs_init(struct module *mod)
+int mod_sysfs_init(struct module_private *mod)
 {
 	int err;
 
 	if (!module_sysfs_initialized) {
 		printk(KERN_ERR "%s: module sysfs not initialized\n",
-		       mod->name);
+		       mod->mod.name);
 		err = -EINVAL;
 		goto out;
 	}
 	memset(&mod->mkobj.kobj, 0, sizeof(mod->mkobj.kobj));
-	err = kobject_set_name(&mod->mkobj.kobj, "%s", mod->name);
+	err = kobject_set_name(&mod->mkobj.kobj, "%s", mod->mod.name);
 	if (err)
 		goto out;
 	kobj_set_kset_s(&mod->mkobj, module_subsys);
@@ -1139,7 +1140,7 @@ out:
 	return err;
 }
 
-int mod_sysfs_setup(struct module *mod,
+int mod_sysfs_setup(struct module_private *mod,
 			   struct kernel_param *kparam,
 			   unsigned int num_params)
 {
@@ -1179,7 +1180,7 @@ out:
 }
 #endif
 
-static void mod_kobject_remove(struct module *mod)
+static void mod_kobject_remove(struct module_private *mod)
 {
 	module_remove_modinfo_attrs(mod);
 	module_param_sysfs_remove(mod);
@@ -1194,13 +1195,13 @@ static void mod_kobject_remove(struct mo
  */
 static int __unlink_module(void *_mod)
 {
-	struct module *mod = _mod;
+	struct module_private *mod = _mod;
 	list_del(&mod->list);
 	return 0;
 }
 
 /* Free a module, remove from lists, etc (must hold module_mutex). */
-static void free_module(struct module *mod)
+static void free_module(struct module_private *mod)
 {
 	/* Delete from various lists */
 	stop_machine_run(__unlink_module, mod, NR_CPUS);
@@ -1217,9 +1218,9 @@ static void free_module(struct module *m
 
 	/* This may be NULL, but that's OK */
 	module_free(mod, mod->module_init);
-	kfree(mod->args);
-	if (mod->percpu)
-		percpu_modfree(mod->percpu);
+	kfree(mod->mod.args);
+	if (mod->mod.percpu)
+		percpu_modfree(mod->mod.percpu);
 
 	/* Free lock-classes: */
 	lockdep_free_key_range(mod->module_core, mod->core_size);
@@ -1230,13 +1231,13 @@ static void free_module(struct module *m
 
 void *__symbol_get(const char *symbol)
 {
-	struct module *owner;
+	struct module_private *owner;
 	unsigned long value, flags;
 	const unsigned long *crc;
 
 	spin_lock_irqsave(&modlist_lock, flags);
 	value = __find_symbol(symbol, &owner, &crc, 1);
-	if (value && !strong_try_module_get(owner))
+	if (value && !strong_try_module_get(&owner->mod))
 		value = 0;
 	spin_unlock_irqrestore(&modlist_lock, flags);
 
@@ -1248,11 +1249,11 @@ EXPORT_SYMBOL_GPL(__symbol_get);
  * Ensure that an exported symbol [global namespace] does not already exist
  * in the kernel or in some other module's exported symbol table.
  */
-static int verify_export_symbols(struct module *mod)
+static int verify_export_symbols(struct module_private *mod)
 {
 	const char *name = NULL;
 	unsigned long i, ret = 0;
-	struct module *owner;
+	struct module_private *owner;
 	const unsigned long *crc;
 
 	for (i = 0; i < mod->num_syms; i++)
@@ -1272,7 +1273,7 @@ static int verify_export_symbols(struct 
 dup:
 	if (ret)
 		printk(KERN_ERR "%s: exports duplicate symbol %s (owned by %s)\n",
-			mod->name, name, module_name(owner));
+			mod->mod.name, name, module_name(&owner->mod));
 
 	return ret;
 }
@@ -1283,7 +1284,7 @@ static int simplify_symbols(Elf_Shdr *se
 			    const char *strtab,
 			    unsigned int versindex,
 			    unsigned int pcpuindex,
-			    struct module *mod)
+			    struct module_private *mod)
 {
 	Elf_Sym *sym = (void *)sechdrs[symindex].sh_addr;
 	unsigned long secbase;
@@ -1297,7 +1298,7 @@ static int simplify_symbols(Elf_Shdr *se
 			   supposed to happen.  */
 			DEBUGP("Common symbol: %s\n", strtab + sym[i].st_name);
 			printk("%s: please compile with -fno-common\n",
-			       mod->name);
+			       mod->mod.name);
 			ret = -ENOEXEC;
 			break;
 
@@ -1320,14 +1321,14 @@ static int simplify_symbols(Elf_Shdr *se
 				break;
 
 			printk(KERN_WARNING "%s: Unknown symbol %s\n",
-			       mod->name, strtab + sym[i].st_name);
+			       mod->mod.name, strtab + sym[i].st_name);
 			ret = -ENOENT;
 			break;
 
 		default:
 			/* Divert to percpu allocation if a percpu var. */
 			if (sym[i].st_shndx == pcpuindex)
-				secbase = (unsigned long)mod->percpu;
+				secbase = (unsigned long)mod->mod.percpu;
 			else
 				secbase = sechdrs[sym[i].st_shndx].sh_addr;
 			sym[i].st_value += secbase;
@@ -1352,7 +1353,7 @@ static long get_offset(unsigned long *si
    might -- code, read-only data, read-write data, small data.  Tally
    sizes, and place the offsets into sh_entsize fields: high bit means it
    belongs in init. */
-static void layout_sections(struct module *mod,
+static void layout_sections(struct module_private *mod,
 			    const Elf_Ehdr *hdr,
 			    Elf_Shdr *sechdrs,
 			    const char *secstrings)
@@ -1409,7 +1410,7 @@ static void layout_sections(struct modul
 	}
 }
 
-static void set_license(struct module *mod, const char *license)
+static void set_license(struct module_private *mod, const char *license)
 {
 	if (!license)
 		license = "unspecified";
@@ -1417,7 +1418,7 @@ static void set_license(struct module *m
 	if (!license_is_gpl_compatible(license)) {
 		if (!(tainted & TAINT_PROPRIETARY_MODULE))
 			printk(KERN_WARNING "%s: module license '%s' taints "
-				"kernel.\n", mod->name, license);
+				"kernel.\n", mod->mod.name, license);
 		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
 	}
 }
@@ -1456,7 +1457,7 @@ static char *get_modinfo(Elf_Shdr *sechd
 	return NULL;
 }
 
-static void setup_modinfo(struct module *mod, Elf_Shdr *sechdrs,
+static void setup_modinfo(struct module_private *mod, Elf_Shdr *sechdrs,
 			  unsigned int infoindex)
 {
 	struct module_attribute *attr;
@@ -1472,7 +1473,7 @@ static void setup_modinfo(struct module 
 }
 
 #ifdef CONFIG_KALLSYMS
-static int is_exported(const char *name, const struct module *mod)
+static int is_exported(const char *name, const struct module_private *mod)
 {
 	if (!mod && lookup_symbol(name, __start___ksymtab, __stop___ksymtab))
 		return 1;
@@ -1487,7 +1488,7 @@ static int is_exported(const char *name,
 static char elf_type(const Elf_Sym *sym,
 		     Elf_Shdr *sechdrs,
 		     const char *secstrings,
-		     struct module *mod)
+		     struct module_private *mod)
 {
 	if (ELF_ST_BIND(sym->st_info) == STB_WEAK) {
 		if (ELF_ST_TYPE(sym->st_info) == STT_OBJECT)
@@ -1524,7 +1525,7 @@ static char elf_type(const Elf_Sym *sym,
 	return '?';
 }
 
-static void add_kallsyms(struct module *mod,
+static void add_kallsyms(struct module_private *mod,
 			 Elf_Shdr *sechdrs,
 			 unsigned int symindex,
 			 unsigned int strindex,
@@ -1542,7 +1543,7 @@ static void add_kallsyms(struct module *
 			= elf_type(&mod->symtab[i], sechdrs, secstrings, mod);
 }
 #else
-static inline void add_kallsyms(struct module *mod,
+static inline void add_kallsyms(struct module_private *mod,
 				Elf_Shdr *sechdrs,
 				unsigned int symindex,
 				unsigned int strindex,
@@ -1553,7 +1554,7 @@ static inline void add_kallsyms(struct m
 
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
-static struct module *load_module(void __user *umod,
+static struct module_private *load_module(void __user *umod,
 				  unsigned long len,
 				  const char __user *uargs)
 {
@@ -1581,7 +1582,7 @@ static struct module *load_module(void _
 	unsigned int unusedcrcindex;
 	unsigned int unusedgplindex;
 	unsigned int unusedgplcrcindex;
-	struct module *mod;
+	struct module_private *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
 	struct exception_table_entry *extable;
@@ -1652,7 +1653,7 @@ static struct module *load_module(void _
 
 	if (symindex == 0) {
 		printk(KERN_WARNING "%s: module has no symbols (stripped?)\n",
-		       mod->name);
+		       mod->mod.name);
 		err = -ENOEXEC;
 		goto free_hdr;
 	}
@@ -1699,10 +1700,10 @@ static struct module *load_module(void _
 	if (!modmagic) {
 		add_taint_module(mod, TAINT_FORCED_MODULE);
 		printk(KERN_WARNING "%s: no version magic, tainting kernel.\n",
-		       mod->name);
+		       mod->mod.name);
 	} else if (!same_magic(modmagic, vermagic)) {
 		printk(KERN_ERR "%s: version magic '%s' should be '%s'\n",
-		       mod->name, modmagic, vermagic);
+		       mod->mod.name, modmagic, vermagic);
 		err = -ENOEXEC;
 		goto free_hdr;
 	}
@@ -1714,12 +1715,12 @@ static struct module *load_module(void _
 		goto free_hdr;
 	}
 
-	if (find_module(mod->name)) {
+	if (find_module(mod->mod.name)) {
 		err = -EEXIST;
 		goto free_mod;
 	}
 
-	mod->state = MODULE_STATE_COMING;
+	mod->mod.state = MODULE_STATE_COMING;
 
 	/* Allow arches to frob section contents and sizes.  */
 	err = module_frob_arch_sections(hdr, sechdrs, secstrings, mod);
@@ -1730,13 +1731,13 @@ static struct module *load_module(void _
 		/* We have a special allocation for this section. */
 		percpu = percpu_modalloc(sechdrs[pcpuindex].sh_size,
 					 sechdrs[pcpuindex].sh_addralign,
-					 mod->name);
+					 mod->mod.name);
 		if (!percpu) {
 			err = -ENOMEM;
 			goto free_mod;
 		}
 		sechdrs[pcpuindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
-		mod->percpu = percpu;
+		mod->mod.percpu = percpu;
 	}
 
 	/* Determine total sizes, and put offsets in sh_entsize.  For now
@@ -1795,9 +1796,9 @@ static struct module *load_module(void _
 	/* Set up license info based on the info section */
 	set_license(mod, get_modinfo(sechdrs, infoindex, "license"));
 
-	if (strcmp(mod->name, "ndiswrapper") == 0)
+	if (strcmp(mod->mod.name, "ndiswrapper") == 0)
 		add_taint(TAINT_PROPRIETARY_MODULE);
-	if (strcmp(mod->name, "driverloader") == 0)
+	if (strcmp(mod->mod.name, "driverloader") == 0)
 		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
 
 	/* Set up MODINFO_ATTR fields */
@@ -1842,7 +1843,7 @@ static struct module *load_module(void _
 	    (mod->num_unused_syms && !unusedcrcindex) ||
 	    (mod->num_unused_gpl_syms && !unusedgplcrcindex)) {
 		printk(KERN_WARNING "%s: No versions for exported symbols."
-		       " Tainting kernel.\n", mod->name);
+		       " Tainting kernel.\n", mod->mod.name);
 		add_taint_module(mod, TAINT_FORCED_MODULE);
 	}
 #endif
@@ -1881,7 +1882,7 @@ static struct module *load_module(void _
 	sort_extable(extable, extable + mod->num_exentries);
 
 	/* Finally, copy percpu area over. */
-	percpu_modcopy(mod->percpu, (void *)sechdrs[pcpuindex].sh_addr,
+	percpu_modcopy(mod->mod.percpu, (void *)sechdrs[pcpuindex].sh_addr,
 		       sechdrs[pcpuindex].sh_size);
 
 	add_kallsyms(mod, sechdrs, symindex, strindex, secstrings);
@@ -1908,13 +1909,13 @@ static struct module *load_module(void _
 
 	set_fs(old_fs);
 
-	mod->args = args;
+	mod->mod.args = args;
 	if (obsparmindex)
 		printk(KERN_WARNING "%s: Ignoring obsolete parameters\n",
-		       mod->name);
+		       mod->mod.name);
 
 	/* Size of section 0 is 0, so this works well if no params */
-	err = parse_args(mod->name, mod->args,
+	err = parse_args(mod->mod.name, mod->mod.args,
 			 (struct kernel_param *)
 			 sechdrs[setupindex].sh_addr,
 			 sechdrs[setupindex].sh_size
@@ -1971,7 +1972,7 @@ static struct module *load_module(void _
  */
 static int __link_module(void *_mod)
 {
-	struct module *mod = _mod;
+	struct module_private *mod = _mod;
 	list_add(&mod->list, &modules);
 	return 0;
 }
@@ -1982,7 +1983,7 @@ sys_init_module(void __user *umod,
 		unsigned long len,
 		const char __user *uargs)
 {
-	struct module *mod;
+	struct module_private *mod;
 	int ret = 0;
 
 	/* Must have permission */
@@ -2016,13 +2017,13 @@ sys_init_module(void __user *umod,
 	if (ret < 0) {
 		/* Init routine failed: abort.  Try to protect us from
                    buggy refcounters. */
-		mod->state = MODULE_STATE_GOING;
+		mod->mod.state = MODULE_STATE_GOING;
 		synchronize_sched();
 		if (mod->unsafe)
 			printk(KERN_ERR "%s: module is now stuck!\n",
-			       mod->name);
+			       mod->mod.name);
 		else {
-			module_put(mod);
+			module_put(&mod->mod);
 			mutex_lock(&module_mutex);
 			free_module(mod);
 			mutex_unlock(&module_mutex);
@@ -2032,9 +2033,9 @@ sys_init_module(void __user *umod,
 
 	/* Now it's a first class citizen! */
 	mutex_lock(&module_mutex);
-	mod->state = MODULE_STATE_LIVE;
+	mod->mod.state = MODULE_STATE_LIVE;
 	/* Drop initial reference. */
-	module_put(mod);
+	module_put(&mod->mod);
 	unwind_remove_table(mod->unwind_info, 1);
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;
@@ -2061,7 +2062,7 @@ static inline int is_arm_mapping_symbol(
 	       && (str[2] == '\0' || str[2] == '.');
 }
 
-static const char *get_ksymbol(struct module *mod,
+static const char *get_ksymbol(struct module_private *mod,
 			       unsigned long addr,
 			       unsigned long *size,
 			       unsigned long *offset)
@@ -2113,13 +2114,13 @@ const char *module_address_lookup(unsign
 				  unsigned long *offset,
 				  char **modname)
 {
-	struct module *mod;
+	struct module_private *mod;
 
 	list_for_each_entry(mod, &modules, list) {
 		if (within(addr, mod->module_init, mod->init_size)
 		    || within(addr, mod->module_core, mod->core_size)) {
 			if (modname)
-				*modname = mod->name;
+				*modname = mod->mod.name;
 			return get_ksymbol(mod, addr, size, offset);
 		}
 	}
@@ -2128,7 +2129,7 @@ const char *module_address_lookup(unsign
 
 int lookup_module_symbol_name(unsigned long addr, char *symname)
 {
-	struct module *mod;
+	struct module_private *mod;
 
 	mutex_lock(&module_mutex);
 	list_for_each_entry(mod, &modules, list) {
@@ -2152,7 +2153,7 @@ out:
 int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size,
 			unsigned long *offset, char *modname, char *name)
 {
-	struct module *mod;
+	struct module_private *mod;
 
 	mutex_lock(&module_mutex);
 	list_for_each_entry(mod, &modules, list) {
@@ -2164,7 +2165,7 @@ int lookup_module_symbol_attrs(unsigned 
 			if (!sym)
 				goto out;
 			if (modname)
-				strlcpy(modname, mod->name, MODULE_NAME_LEN + 1);
+				strlcpy(modname, mod->mod.name, MODULE_NAME_LEN + 1);
 			if (name)
 				strlcpy(name, sym, KSYM_NAME_LEN + 1);
 			mutex_unlock(&module_mutex);
@@ -2179,7 +2180,7 @@ out:
 int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 			char *name, char *module_name, int *exported)
 {
-	struct module *mod;
+	struct module_private *mod;
 
 	mutex_lock(&module_mutex);
 	list_for_each_entry(mod, &modules, list) {
@@ -2188,7 +2189,7 @@ int module_get_kallsym(unsigned int symn
 			*type = mod->symtab[symnum].st_info;
 			strlcpy(name, mod->strtab + mod->symtab[symnum].st_name,
 				KSYM_NAME_LEN + 1);
-			strlcpy(module_name, mod->name, MODULE_NAME_LEN + 1);
+			strlcpy(module_name, mod->mod.name, MODULE_NAME_LEN + 1);
 			*exported = is_exported(name, mod);
 			mutex_unlock(&module_mutex);
 			return 0;
@@ -2199,7 +2200,7 @@ int module_get_kallsym(unsigned int symn
 	return -ERANGE;
 }
 
-static unsigned long mod_find_symname(struct module *mod, const char *name)
+static unsigned long mod_find_symname(struct module_private *mod, const char *name)
 {
 	unsigned int i;
 
@@ -2213,7 +2214,7 @@ static unsigned long mod_find_symname(st
 /* Look for this name: can be of form module:name. */
 unsigned long module_kallsyms_lookup_name(const char *name)
 {
-	struct module *mod;
+	struct module_private *mod;
 	char *colon;
 	unsigned long ret = 0;
 
@@ -2286,17 +2287,17 @@ static char *taint_flags(unsigned int ta
 
 static int m_show(struct seq_file *m, void *p)
 {
-	struct module *mod = list_entry(p, struct module, list);
+	struct module_private *mod = list_entry(p, struct module_private, list);
 	char buf[8];
 
 	seq_printf(m, "%s %lu",
-		   mod->name, mod->init_size + mod->core_size);
+		   mod->mod.name, mod->init_size + mod->core_size);
 	print_unload_info(m, mod);
 
 	/* Informative for users. */
 	seq_printf(m, " %s",
-		   mod->state == MODULE_STATE_GOING ? "Unloading":
-		   mod->state == MODULE_STATE_COMING ? "Loading":
+		   mod->mod.state == MODULE_STATE_GOING ? "Unloading":
+		   mod->mod.state == MODULE_STATE_COMING ? "Loading":
 		   "Live");
 	/* Used by oprofile and other similar tools. */
 	seq_printf(m, " 0x%p", mod->module_core);
@@ -2326,7 +2327,7 @@ const struct exception_table_entry *sear
 {
 	unsigned long flags;
 	const struct exception_table_entry *e = NULL;
-	struct module *mod;
+	struct module_private *mod;
 
 	spin_lock_irqsave(&modlist_lock, flags);
 	list_for_each_entry(mod, &modules, list) {
@@ -2352,7 +2353,7 @@ const struct exception_table_entry *sear
 int is_module_address(unsigned long addr)
 {
 	unsigned long flags;
-	struct module *mod;
+	struct module_private *mod;
 
 	spin_lock_irqsave(&modlist_lock, flags);
 
@@ -2372,12 +2373,12 @@ int is_module_address(unsigned long addr
 /* Is this a valid kernel address?  We don't grab the lock: we are oopsing. */
 struct module *__module_text_address(unsigned long addr)
 {
-	struct module *mod;
+	struct module_private *mod;
 
 	list_for_each_entry(mod, &modules, list)
 		if (within(addr, mod->module_init, mod->init_text_size)
 		    || within(addr, mod->module_core, mod->core_text_size))
-			return mod;
+			return &mod->mod;
 	return NULL;
 }
 
@@ -2396,12 +2397,12 @@ struct module *module_text_address(unsig
 /* Don't grab lock, we're oopsing. */
 void print_modules(void)
 {
-	struct module *mod;
+	struct module_private *mod;
 	char buf[8];
 
 	printk("Modules linked in:");
 	list_for_each_entry(mod, &modules, list)
-		printk(" %s%s", mod->name, taint_flags(mod->taints, buf));
+		printk(" %s%s", mod->mod.name, taint_flags(mod->taints, buf));
 	printk("\n");
 }
 
@@ -2427,7 +2428,7 @@ static void module_create_drivers_dir(st
 	mk->drivers_dir = kobject_add_dir(&mk->kobj, "drivers");
 }
 
-void module_add_driver(struct module *mod, struct device_driver *drv)
+void module_add_driver(struct module_private *mod, struct device_driver *drv)
 {
 	char *driver_name;
 	int no_warn;
@@ -2478,7 +2479,7 @@ void module_remove_driver(struct device_
 	sysfs_remove_link(&drv->kobj, "module");
 
 	if (drv->owner)
-		mk = &drv->owner->mkobj;
+		mk = &get_mod_private(drv->owner)->mkobj;
 	else if (drv->mkobj)
 		mk = drv->mkobj;
 	if (mk && mk->drivers_dir) {
Index: linux-2.6/kernel/params.c
===================================================================
--- linux-2.6.orig/kernel/params.c
+++ linux-2.6/kernel/params.c
@@ -15,6 +15,7 @@
     along with this program; if not, write to the Free Software
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
+#include <linux/moduleloader.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
@@ -397,7 +398,7 @@ struct module_param_attrs
 #define to_param_attr(n) container_of(n, struct param_attribute, mattr);
 
 static ssize_t param_attr_show(struct module_attribute *mattr,
-			       struct module *mod, char *buf)
+			       struct module_private *mod, char *buf)
 {
 	int count;
 	struct param_attribute *attribute = to_param_attr(mattr);
@@ -415,7 +416,7 @@ static ssize_t param_attr_show(struct mo
 
 /* sysfs always hands a nul-terminated string in buf.  We rely on that. */
 static ssize_t param_attr_store(struct module_attribute *mattr,
-				struct module *owner,
+				struct module_private *owner,
 				const char *buf, size_t len)
 {
  	int err;
@@ -491,7 +492,7 @@ param_sysfs_setup(struct module_kobject 
 			pattr->mattr.show = param_attr_show;
 			pattr->mattr.store = param_attr_store;
 			pattr->mattr.attr.name = (char *)&kp->name[name_skip];
-			pattr->mattr.attr.owner = mk->mod;
+			pattr->mattr.attr.owner = &mk->mod->mod;
 			pattr->mattr.attr.mode = kp->perm;
 			*(gattr++) = &(pattr++)->mattr.attr;
 		}
@@ -515,7 +516,7 @@ param_sysfs_setup(struct module_kobject 
  * Adds sysfs entries for module parameters, and creates a link from
  * /sys/module/[mod->name]/parameters to /sys/parameters/[mod->name]/
  */
-int module_param_sysfs_setup(struct module *mod,
+int module_param_sysfs_setup(struct module_private *mod,
 			     struct kernel_param *kparam,
 			     unsigned int num_params)
 {
@@ -536,7 +537,7 @@ int module_param_sysfs_setup(struct modu
  * Remove sysfs entries for module parameters and the corresponding
  * kobject.
  */
-void module_param_sysfs_remove(struct module *mod)
+void module_param_sysfs_remove(struct module_private *mod)
 {
 	if (mod->param_attrs) {
 		sysfs_remove_group(&mod->mkobj.kobj,
@@ -563,7 +564,7 @@ static void __init kernel_param_sysfs_se
 	mk = kzalloc(sizeof(struct module_kobject), GFP_KERNEL);
 	BUG_ON(!mk);
 
-	mk->mod = THIS_MODULE;
+	mk->mod = get_mod_private(THIS_MODULE);
 	kobj_set_kset_s(mk, module_subsys);
 	kobject_set_name(&mk->kobj, name);
 	kobject_init(&mk->kobj);
Index: linux-2.6/arch/i386/kernel/module.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/module.c
+++ linux-2.6/arch/i386/kernel/module.c
@@ -38,7 +38,7 @@ void *module_alloc(unsigned long size)
 
 
 /* Free memory returned from module_alloc */
-void module_free(struct module *mod, void *module_region)
+void module_free(struct module_private *mod, void *module_region)
 {
 	vfree(module_region);
 	/* FIXME: If module_region == mod->init_region, trim exception
@@ -49,7 +49,7 @@ void module_free(struct module *mod, voi
 int module_frob_arch_sections(Elf_Ehdr *hdr,
 			      Elf_Shdr *sechdrs,
 			      char *secstrings,
-			      struct module *mod)
+			      struct module_private *mod)
 {
 	return 0;
 }
@@ -58,7 +58,7 @@ int apply_relocate(Elf32_Shdr *sechdrs,
 		   const char *strtab,
 		   unsigned int symindex,
 		   unsigned int relsec,
-		   struct module *me)
+		   struct module_private *me)
 {
 	unsigned int i;
 	Elf32_Rel *rel = (void *)sechdrs[relsec].sh_addr;
@@ -87,7 +87,7 @@ int apply_relocate(Elf32_Shdr *sechdrs,
 			break;
 		default:
 			printk(KERN_ERR "module %s: Unknown relocation: %u\n",
-			       me->name, ELF32_R_TYPE(rel[i].r_info));
+			       me->mod.name, ELF32_R_TYPE(rel[i].r_info));
 			return -ENOEXEC;
 		}
 	}
@@ -98,16 +98,16 @@ int apply_relocate_add(Elf32_Shdr *sechd
 		       const char *strtab,
 		       unsigned int symindex,
 		       unsigned int relsec,
-		       struct module *me)
+		       struct module_private *me)
 {
 	printk(KERN_ERR "module %s: ADD RELOCATION unsupported\n",
-	       me->name);
+	       me->mod.name);
 	return -ENOEXEC;
 }
 
 int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
-		    struct module *me)
+		    struct module_private *me)
 {
 	const Elf_Shdr *s, *text = NULL, *alt = NULL, *locks = NULL,
 		*para = NULL;
@@ -132,7 +132,7 @@ int module_finalize(const Elf_Ehdr *hdr,
 	if (locks && text) {
 		void *lseg = (void *)locks->sh_addr;
 		void *tseg = (void *)text->sh_addr;
-		alternatives_smp_module_add(me, me->name,
+		alternatives_smp_module_add(&me->mod, me->mod.name,
 					    lseg, lseg + locks->sh_size,
 					    tseg, tseg + text->sh_size);
 	}
@@ -142,11 +142,11 @@ int module_finalize(const Elf_Ehdr *hdr,
 		apply_paravirt(pseg, pseg + para->sh_size);
 	}
 
-	return module_bug_finalize(hdr, sechdrs, me);
+	return module_bug_finalize(hdr, sechdrs, &me->mod);
 }
 
-void module_arch_cleanup(struct module *mod)
+void module_arch_cleanup(struct module_private *mod)
 {
-	alternatives_smp_module_del(mod);
-	module_bug_cleanup(mod);
+	alternatives_smp_module_del(&mod->mod);
+	module_bug_cleanup(&mod->mod);
 }
Index: linux-2.6/drivers/base/bus.c
===================================================================
--- linux-2.6.orig/drivers/base/bus.c
+++ linux-2.6/drivers/base/bus.c
@@ -9,7 +9,7 @@
  */
 
 #include <linux/device.h>
-#include <linux/module.h>
+#include <linux/moduleloader.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/string.h>
@@ -619,7 +619,7 @@ int bus_add_driver(struct device_driver 
 			goto out_unregister;
 	}
 	klist_add_tail(&drv->knode_bus, &bus->klist_drivers);
-	module_add_driver(drv->owner, drv);
+	module_add_driver(get_mod_private(drv->owner), drv);
 
 	error = driver_add_attrs(bus, drv);
 	if (error) {
Index: linux-2.6/scripts/mod/modpost.c
===================================================================
--- linux-2.6.orig/scripts/mod/modpost.c
+++ linux-2.6/scripts/mod/modpost.c
@@ -1314,15 +1314,17 @@ static void check_exports(struct module 
  **/
 static void add_header(struct buffer *b, struct module *mod)
 {
-	buf_printf(b, "#include <linux/module.h>\n");
+	buf_printf(b, "#include <linux/moduleloader.h>\n");
 	buf_printf(b, "#include <linux/vermagic.h>\n");
 	buf_printf(b, "#include <linux/compiler.h>\n");
 	buf_printf(b, "\n");
 	buf_printf(b, "MODULE_INFO(vermagic, VERMAGIC_STRING);\n");
 	buf_printf(b, "\n");
-	buf_printf(b, "struct module __this_module\n");
+	buf_printf(b, "struct module_private __this_module_private\n");
 	buf_printf(b, "__attribute__((section(\".gnu.linkonce.this_module\"))) = {\n");
-	buf_printf(b, " .name = KBUILD_MODNAME,\n");
+	buf_printf(b, " .mod = {\n");
+	buf_printf(b, "  .name = KBUILD_MODNAME,\n");
+	buf_printf(b, " },\n");
 	if (mod->has_init)
 		buf_printf(b, " .init = init_module,\n");
 	if (mod->has_cleanup)
@@ -1331,6 +1333,7 @@ static void add_header(struct buffer *b,
 			      "#endif\n");
 	buf_printf(b, " .arch = MODULE_ARCH_INIT,\n");
 	buf_printf(b, "};\n");
+	buf_printf(b, "asm (\".globl __this_module; .type __this_module,@object; __this_module = __this_module_private\");\n");
 }
 
 /**
