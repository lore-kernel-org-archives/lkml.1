Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbYJUXGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbYJUXGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 19:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYJUXGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 19:06:08 -0400
Received: from ozlabs.org ([203.10.76.45]:42294 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbYJUXGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 19:06:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] module, param and stop_machine patches
Date: Wed, 22 Oct 2008 10:05:58 +1100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Arjan van de Ven <arjan@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810221005.59874.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2515ddc6db8eb49a79f0fe5e67ff09ac7c81eab4:
  Paul Mundt (1):
        binfmt_elf_fdpic: Update for cputime changes.

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Andi Kleen (1):
      Remove stop_machine during module load v2

Heiko Carstens (4):
      Call init_workqueues before pre smp initcalls.
      workqueue: introduce create_rt_workqueue
      stop_machine: use workqueues instead of kernel threads
      stop_machine: fix error code handling on multiple cpus

Rusty Russell (6):
      module: simplify load_module.
      module: check kernel param length at compile time, not runtime
      param: Fix duplicate module prefixes
      core_param() for genuinely core kernel parameters
      Make initcall_debug a core_param
      Make panic= and panic_on_oops into core_params

 include/linux/module.h      |    6 +-
 include/linux/moduleparam.h |   25 ++++-
 include/linux/workqueue.h   |   18 ++--
 init/main.c                 |   12 +--
 kernel/module.c             |  284 ++++++++++++++++++------------------------
 kernel/panic.c              |   17 +--
 kernel/params.c             |  274 ++++++++++++++++++++++-------------------
 kernel/stop_machine.c       |  120 +++++++-----------
 kernel/workqueue.c          |    7 +-
 9 files changed, 364 insertions(+), 399 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 5d2970c..3bfed01 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -29,7 +29,7 @@
 #define MODULE_SYMBOL_PREFIX ""
 #endif
 
-#define MODULE_NAME_LEN (64 - sizeof(unsigned long))
+#define MODULE_NAME_LEN MAX_PARAM_PREFIX_LEN
 
 struct kernel_symbol
 {
@@ -60,6 +60,7 @@ struct module_kobject
 	struct kobject kobj;
 	struct module *mod;
 	struct kobject *drivers_dir;
+	struct module_param_attrs *mp;
 };
 
 /* These are either module local, or the kernel's dummy ones. */
@@ -242,7 +243,6 @@ struct module
 
 	/* Sysfs stuff. */
 	struct module_kobject mkobj;
-	struct module_param_attrs *param_attrs;
 	struct module_attribute *modinfo_attrs;
 	const char *version;
 	const char *srcversion;
@@ -277,7 +277,7 @@ struct module
 
 	/* Exception table */
 	unsigned int num_exentries;
-	const struct exception_table_entry *extable;
+	struct exception_table_entry *extable;
 
 	/* Startup function. */
 	int (*init)(void);
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index ec62438..e4af339 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -13,6 +13,9 @@
 #define MODULE_PARAM_PREFIX KBUILD_MODNAME "."
 #endif
 
+/* Chosen so that structs with an unsigned long line up. */
+#define MAX_PARAM_PREFIX_LEN (64 - sizeof(unsigned long))
+
 #ifdef MODULE
 #define ___module_cat(a,b) __mod_ ## a ## b
 #define __module_cat(a,b) ___module_cat(a,b)
@@ -79,7 +82,8 @@ struct kparam_array
 #define __module_param_call(prefix, name, set, get, arg, perm)		\
 	/* Default value instead of permissions? */			\
 	static int __param_perm_check_##name __attribute__((unused)) =	\
-	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2));	\
+	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
+	+ BUILD_BUG_ON_ZERO(sizeof(""prefix) > MAX_PARAM_PREFIX_LEN);	\
 	static const char __param_str_##name[] = prefix #name;		\
 	static struct kernel_param __moduleparam_const __param_##name	\
 	__used								\
@@ -100,6 +104,25 @@ struct kparam_array
 #define module_param(name, type, perm)				\
 	module_param_named(name, name, type, perm)
 
+#ifndef MODULE
+/**
+ * core_param - define a historical core kernel parameter.
+ * @name: the name of the cmdline and sysfs parameter (often the same as var)
+ * @var: the variable
+ * @type: the type (for param_set_##type and param_get_##type)
+ * @perm: visibility in sysfs
+ *
+ * core_param is just like module_param(), but cannot be modular and
+ * doesn't add a prefix (such as "printk.").  This is for compatibility
+ * with __setup(), and it makes sense as truly core parameters aren't
+ * tied to the particular file they're in.
+ */
+#define core_param(name, var, type, perm)				\
+	param_check_##type(name, &(var));				\
+	__module_param_call("", name, param_set_##type, param_get_##type, \
+			    &var, perm)
+#endif /* !MODULE */
+
 /* Actually copy string: maxlen param is usually sizeof(string). */
 #define module_param_string(name, string, len, perm)			\
 	static const struct kparam_string __param_string_##name		\
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 5c158c4..89a5a12 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -149,11 +149,11 @@ struct execute_work {
 
 extern struct workqueue_struct *
 __create_workqueue_key(const char *name, int singlethread,
-		       int freezeable, struct lock_class_key *key,
+		       int freezeable, int rt, struct lock_class_key *key,
 		       const char *lock_name);
 
 #ifdef CONFIG_LOCKDEP
-#define __create_workqueue(name, singlethread, freezeable)	\
+#define __create_workqueue(name, singlethread, freezeable, rt)	\
 ({								\
 	static struct lock_class_key __key;			\
 	const char *__lock_name;				\
@@ -164,17 +164,19 @@ __create_workqueue_key(const char *name, int singlethread,
 		__lock_name = #name;				\
 								\
 	__create_workqueue_key((name), (singlethread),		\
-			       (freezeable), &__key,		\
+			       (freezeable), (rt), &__key,	\
 			       __lock_name);			\
 })
 #else
-#define __create_workqueue(name, singlethread, freezeable)	\
-	__create_workqueue_key((name), (singlethread), (freezeable), NULL, NULL)
+#define __create_workqueue(name, singlethread, freezeable, rt)	\
+	__create_workqueue_key((name), (singlethread), (freezeable), (rt), \
+			       NULL, NULL)
 #endif
 
-#define create_workqueue(name) __create_workqueue((name), 0, 0)
-#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
-#define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0)
+#define create_workqueue(name) __create_workqueue((name), 0, 0, 0)
+#define create_rt_workqueue(name) __create_workqueue((name), 0, 0, 1)
+#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1, 0)
+#define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0, 0)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
diff --git a/init/main.c b/init/main.c
index 3e17a3b..6c7fd13 100644
--- a/init/main.c
+++ b/init/main.c
@@ -697,13 +697,7 @@ asmlinkage void __init start_kernel(void)
 }
 
 static int initcall_debug;
-
-static int __init initcall_debug_setup(char *str)
-{
-	initcall_debug = 1;
-	return 1;
-}
-__setup("initcall_debug", initcall_debug_setup);
+core_param(initcall_debug, initcall_debug, bool, 0644);
 
 int do_one_initcall(initcall_t fn)
 {
@@ -773,8 +767,6 @@ static void __init do_initcalls(void)
 static void __init do_basic_setup(void)
 {
 	rcu_init_sched(); /* needed by module_init stage. */
-	/* drivers will send hotplug events */
-	init_workqueues();
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
@@ -858,6 +850,8 @@ static int __init kernel_init(void * unused)
 
 	cad_pid = task_pid(current);
 
+	init_workqueues();
+
 	smp_prepare_cpus(setup_max_cpus);
 
 	do_pre_smp_initcalls();
diff --git a/kernel/module.c b/kernel/module.c
index 0d8d21e..c0f1826 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -42,6 +42,7 @@
 #include <linux/string.h>
 #include <linux/mutex.h>
 #include <linux/unwind.h>
+#include <linux/rculist.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
 #include <linux/license.h>
@@ -63,7 +64,7 @@
 #define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))
 
 /* List of modules, protected by module_mutex or preempt_disable
- * (add/delete uses stop_machine). */
+ * (delete uses stop_machine/add uses RCU list operations). */
 static DEFINE_MUTEX(module_mutex);
 static LIST_HEAD(modules);
 
@@ -132,6 +133,29 @@ static unsigned int find_sec(Elf_Ehdr *hdr,
 	return 0;
 }
 
+/* Find a module section, or NULL. */
+static void *section_addr(Elf_Ehdr *hdr, Elf_Shdr *shdrs,
+			  const char *secstrings, const char *name)
+{
+	/* Section 0 has sh_addr 0. */
+	return (void *)shdrs[find_sec(hdr, shdrs, secstrings, name)].sh_addr;
+}
+
+/* Find a module section, or NULL.  Fill in number of "objects" in section. */
+static void *section_objs(Elf_Ehdr *hdr,
+			  Elf_Shdr *sechdrs,
+			  const char *secstrings,
+			  const char *name,
+			  size_t object_size,
+			  unsigned int *num)
+{
+	unsigned int sec = find_sec(hdr, sechdrs, secstrings, name);
+
+	/* Section 0 has sh_addr 0 and sh_size 0. */
+	*num = sechdrs[sec].sh_size / object_size;
+	return (void *)sechdrs[sec].sh_addr;
+}
+
 /* Provided by the linker */
 extern const struct kernel_symbol __start___ksymtab[];
 extern const struct kernel_symbol __stop___ksymtab[];
@@ -218,7 +242,7 @@ static bool each_symbol(bool (*fn)(const struct symsearch *arr,
 	if (each_symbol_in_section(arr, ARRAY_SIZE(arr), NULL, fn, data))
 		return true;
 
-	list_for_each_entry(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list) {
 		struct symsearch arr[] = {
 			{ mod->syms, mod->syms + mod->num_syms, mod->crcs,
 			  NOT_GPL_ONLY, false },
@@ -1394,17 +1418,6 @@ static void mod_kobject_remove(struct module *mod)
 }
 
 /*
- * link the module with the whole machine is stopped with interrupts off
- * - this defends against kallsyms not taking locks
- */
-static int __link_module(void *_mod)
-{
-	struct module *mod = _mod;
-	list_add(&mod->list, &modules);
-	return 0;
-}
-
-/*
  * unlink the module with the whole machine is stopped with interrupts off
  * - this defends against kallsyms not taking locks
  */
@@ -1789,32 +1802,20 @@ static inline void add_kallsyms(struct module *mod,
 }
 #endif /* CONFIG_KALLSYMS */
 
-#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
-static void dynamic_printk_setup(Elf_Shdr *sechdrs, unsigned int verboseindex)
+static void dynamic_printk_setup(struct mod_debug *debug, unsigned int num)
 {
-	struct mod_debug *debug_info;
-	unsigned long pos, end;
-	unsigned int num_verbose;
-
-	pos = sechdrs[verboseindex].sh_addr;
-	num_verbose = sechdrs[verboseindex].sh_size /
-				sizeof(struct mod_debug);
-	end = pos + (num_verbose * sizeof(struct mod_debug));
+#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
+	unsigned int i;
 
-	for (; pos < end; pos += sizeof(struct mod_debug)) {
-		debug_info = (struct mod_debug *)pos;
-		register_dynamic_debug_module(debug_info->modname,
-			debug_info->type, debug_info->logical_modname,
-			debug_info->flag_names, debug_info->hash,
-			debug_info->hash2);
+	for (i = 0; i < num; i++) {
+		register_dynamic_debug_module(debug[i].modname,
+					      debug[i].type,
+					      debug[i].logical_modname,
+					      debug[i].flag_names,
+					      debug[i].hash, debug[i].hash2);
 	}
-}
-#else
-static inline void dynamic_printk_setup(Elf_Shdr *sechdrs,
-					unsigned int verboseindex)
-{
-}
 #endif /* CONFIG_DYNAMIC_PRINTK_DEBUG */
+}
 
 static void *module_alloc_update_bounds(unsigned long size)
 {
@@ -1843,37 +1844,14 @@ static noinline struct module *load_module(void __user *umod,
 	unsigned int i;
 	unsigned int symindex = 0;
 	unsigned int strindex = 0;
-	unsigned int setupindex;
-	unsigned int exindex;
-	unsigned int exportindex;
-	unsigned int modindex;
-	unsigned int obsparmindex;
-	unsigned int infoindex;
-	unsigned int gplindex;
-	unsigned int crcindex;
-	unsigned int gplcrcindex;
-	unsigned int versindex;
-	unsigned int pcpuindex;
-	unsigned int gplfutureindex;
-	unsigned int gplfuturecrcindex;
+	unsigned int modindex, versindex, infoindex, pcpuindex;
 	unsigned int unwindex = 0;
-#ifdef CONFIG_UNUSED_SYMBOLS
-	unsigned int unusedindex;
-	unsigned int unusedcrcindex;
-	unsigned int unusedgplindex;
-	unsigned int unusedgplcrcindex;
-#endif
-	unsigned int markersindex;
-	unsigned int markersstringsindex;
-	unsigned int verboseindex;
-	unsigned int tracepointsindex;
-	unsigned int tracepointsstringsindex;
-	unsigned int mcountindex;
+	unsigned int num_kp, num_mcount;
+	struct kernel_param *kp;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
-	void *mseg;
-	struct exception_table_entry *extable;
+	unsigned long *mseg;
 	mm_segment_t old_fs;
 
 	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
@@ -1937,6 +1915,7 @@ static noinline struct module *load_module(void __user *umod,
 		err = -ENOEXEC;
 		goto free_hdr;
 	}
+	/* This is temporary: point mod into copy of data. */
 	mod = (void *)sechdrs[modindex].sh_addr;
 
 	if (symindex == 0) {
@@ -1946,22 +1925,6 @@ static noinline struct module *load_module(void __user *umod,
 		goto free_hdr;
 	}
 
-	/* Optional sections */
-	exportindex = find_sec(hdr, sechdrs, secstrings, "__ksymtab");
-	gplindex = find_sec(hdr, sechdrs, secstrings, "__ksymtab_gpl");
-	gplfutureindex = find_sec(hdr, sechdrs, secstrings, "__ksymtab_gpl_future");
-	crcindex = find_sec(hdr, sechdrs, secstrings, "__kcrctab");
-	gplcrcindex = find_sec(hdr, sechdrs, secstrings, "__kcrctab_gpl");
-	gplfuturecrcindex = find_sec(hdr, sechdrs, secstrings, "__kcrctab_gpl_future");
-#ifdef CONFIG_UNUSED_SYMBOLS
-	unusedindex = find_sec(hdr, sechdrs, secstrings, "__ksymtab_unused");
-	unusedgplindex = find_sec(hdr, sechdrs, secstrings, "__ksymtab_unused_gpl");
-	unusedcrcindex = find_sec(hdr, sechdrs, secstrings, "__kcrctab_unused");
-	unusedgplcrcindex = find_sec(hdr, sechdrs, secstrings, "__kcrctab_unused_gpl");
-#endif
-	setupindex = find_sec(hdr, sechdrs, secstrings, "__param");
-	exindex = find_sec(hdr, sechdrs, secstrings, "__ex_table");
-	obsparmindex = find_sec(hdr, sechdrs, secstrings, "__obsparm");
 	versindex = find_sec(hdr, sechdrs, secstrings, "__versions");
 	infoindex = find_sec(hdr, sechdrs, secstrings, ".modinfo");
 	pcpuindex = find_pcpusec(hdr, sechdrs, secstrings);
@@ -2117,42 +2080,57 @@ static noinline struct module *load_module(void __user *umod,
 	if (err < 0)
 		goto cleanup;
 
-	/* Set up EXPORTed & EXPORT_GPLed symbols (section 0 is 0 length) */
-	mod->num_syms = sechdrs[exportindex].sh_size / sizeof(*mod->syms);
-	mod->syms = (void *)sechdrs[exportindex].sh_addr;
-	if (crcindex)
-		mod->crcs = (void *)sechdrs[crcindex].sh_addr;
-	mod->num_gpl_syms = sechdrs[gplindex].sh_size / sizeof(*mod->gpl_syms);
-	mod->gpl_syms = (void *)sechdrs[gplindex].sh_addr;
-	if (gplcrcindex)
-		mod->gpl_crcs = (void *)sechdrs[gplcrcindex].sh_addr;
-	mod->num_gpl_future_syms = sechdrs[gplfutureindex].sh_size /
-					sizeof(*mod->gpl_future_syms);
-	mod->gpl_future_syms = (void *)sechdrs[gplfutureindex].sh_addr;
-	if (gplfuturecrcindex)
-		mod->gpl_future_crcs = (void *)sechdrs[gplfuturecrcindex].sh_addr;
+	/* Now we've got everything in the final locations, we can
+	 * find optional sections. */
+	kp = section_objs(hdr, sechdrs, secstrings, "__param", sizeof(*kp),
+			  &num_kp);
+	mod->syms = section_objs(hdr, sechdrs, secstrings, "__ksymtab",
+				 sizeof(*mod->syms), &mod->num_syms);
+	mod->crcs = section_addr(hdr, sechdrs, secstrings, "__kcrctab");
+	mod->gpl_syms = section_objs(hdr, sechdrs, secstrings, "__ksymtab_gpl",
+				     sizeof(*mod->gpl_syms),
+				     &mod->num_gpl_syms);
+	mod->gpl_crcs = section_addr(hdr, sechdrs, secstrings, "__kcrctab_gpl");
+	mod->gpl_future_syms = section_objs(hdr, sechdrs, secstrings,
+					    "__ksymtab_gpl_future",
+					    sizeof(*mod->gpl_future_syms),
+					    &mod->num_gpl_future_syms);
+	mod->gpl_future_crcs = section_addr(hdr, sechdrs, secstrings,
+					    "__kcrctab_gpl_future");
 
 #ifdef CONFIG_UNUSED_SYMBOLS
-	mod->num_unused_syms = sechdrs[unusedindex].sh_size /
-					sizeof(*mod->unused_syms);
-	mod->num_unused_gpl_syms = sechdrs[unusedgplindex].sh_size /
-					sizeof(*mod->unused_gpl_syms);
-	mod->unused_syms = (void *)sechdrs[unusedindex].sh_addr;
-	if (unusedcrcindex)
-		mod->unused_crcs = (void *)sechdrs[unusedcrcindex].sh_addr;
-	mod->unused_gpl_syms = (void *)sechdrs[unusedgplindex].sh_addr;
-	if (unusedgplcrcindex)
-		mod->unused_gpl_crcs
-			= (void *)sechdrs[unusedgplcrcindex].sh_addr;
+	mod->unused_syms = section_objs(hdr, sechdrs, secstrings,
+					"__ksymtab_unused",
+					sizeof(*mod->unused_syms),
+					&mod->num_unused_syms);
+	mod->unused_crcs = section_addr(hdr, sechdrs, secstrings,
+					"__kcrctab_unused");
+	mod->unused_gpl_syms = section_objs(hdr, sechdrs, secstrings,
+					    "__ksymtab_unused_gpl",
+					    sizeof(*mod->unused_gpl_syms),
+					    &mod->num_unused_gpl_syms);
+	mod->unused_gpl_crcs = section_addr(hdr, sechdrs, secstrings,
+					    "__kcrctab_unused_gpl");
+#endif
+
+#ifdef CONFIG_MARKERS
+	mod->markers = section_objs(hdr, sechdrs, secstrings, "__markers",
+				    sizeof(*mod->markers), &mod->num_markers);
+#endif
+#ifdef CONFIG_TRACEPOINTS
+	mod->tracepoints = section_objs(hdr, sechdrs, secstrings,
+					"__tracepoints",
+					sizeof(*mod->tracepoints),
+					&mod->num_tracepoints);
 #endif
 
 #ifdef CONFIG_MODVERSIONS
-	if ((mod->num_syms && !crcindex)
-	    || (mod->num_gpl_syms && !gplcrcindex)
-	    || (mod->num_gpl_future_syms && !gplfuturecrcindex)
+	if ((mod->num_syms && !mod->crcs)
+	    || (mod->num_gpl_syms && !mod->gpl_crcs)
+	    || (mod->num_gpl_future_syms && !mod->gpl_future_crcs)
 #ifdef CONFIG_UNUSED_SYMBOLS
-	    || (mod->num_unused_syms && !unusedcrcindex)
-	    || (mod->num_unused_gpl_syms && !unusedgplcrcindex)
+	    || (mod->num_unused_syms && !mod->unused_crcs)
+	    || (mod->num_unused_gpl_syms && !mod->unused_gpl_crcs)
 #endif
 		) {
 		printk(KERN_WARNING "%s: No versions for exported symbols.\n", mod->name);
@@ -2161,16 +2139,6 @@ static noinline struct module *load_module(void __user *umod,
 			goto cleanup;
 	}
 #endif
-	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
- 	markersstringsindex = find_sec(hdr, sechdrs, secstrings,
-					"__markers_strings");
-	verboseindex = find_sec(hdr, sechdrs, secstrings, "__verbose");
-	tracepointsindex = find_sec(hdr, sechdrs, secstrings, "__tracepoints");
-	tracepointsstringsindex = find_sec(hdr, sechdrs, secstrings,
-					"__tracepoints_strings");
-
-	mcountindex = find_sec(hdr, sechdrs, secstrings,
-			       "__mcount_loc");
 
 	/* Now do relocations. */
 	for (i = 1; i < hdr->e_shnum; i++) {
@@ -2193,28 +2161,16 @@ static noinline struct module *load_module(void __user *umod,
 		if (err < 0)
 			goto cleanup;
 	}
-#ifdef CONFIG_MARKERS
-	mod->markers = (void *)sechdrs[markersindex].sh_addr;
-	mod->num_markers =
-		sechdrs[markersindex].sh_size / sizeof(*mod->markers);
-#endif
-#ifdef CONFIG_TRACEPOINTS
-	mod->tracepoints = (void *)sechdrs[tracepointsindex].sh_addr;
-	mod->num_tracepoints =
-		sechdrs[tracepointsindex].sh_size / sizeof(*mod->tracepoints);
-#endif
-
 
         /* Find duplicate symbols */
 	err = verify_export_symbols(mod);
-
 	if (err < 0)
 		goto cleanup;
 
   	/* Set up and sort exception table */
-	mod->num_exentries = sechdrs[exindex].sh_size / sizeof(*mod->extable);
-	mod->extable = extable = (void *)sechdrs[exindex].sh_addr;
-	sort_extable(extable, extable + mod->num_exentries);
+	mod->extable = section_objs(hdr, sechdrs, secstrings, "__ex_table",
+				    sizeof(*mod->extable), &mod->num_exentries);
+	sort_extable(mod->extable, mod->extable + mod->num_exentries);
 
 	/* Finally, copy percpu area over. */
 	percpu_modcopy(mod->percpu, (void *)sechdrs[pcpuindex].sh_addr,
@@ -2223,11 +2179,17 @@ static noinline struct module *load_module(void __user *umod,
 	add_kallsyms(mod, sechdrs, symindex, strindex, secstrings);
 
 	if (!mod->taints) {
+		struct mod_debug *debug;
+		unsigned int num_debug;
+
 #ifdef CONFIG_MARKERS
 		marker_update_probe_range(mod->markers,
 			mod->markers + mod->num_markers);
 #endif
-	dynamic_printk_setup(sechdrs, verboseindex);
+		debug = section_objs(hdr, sechdrs, secstrings, "__verbose",
+				     sizeof(*debug), &num_debug);
+		dynamic_printk_setup(debug, num_debug);
+
 #ifdef CONFIG_TRACEPOINTS
 		tracepoint_update_probe_range(mod->tracepoints,
 			mod->tracepoints + mod->num_tracepoints);
@@ -2235,8 +2197,9 @@ static noinline struct module *load_module(void __user *umod,
 	}
 
 	/* sechdrs[0].sh_size is always zero */
-	mseg = (void *)sechdrs[mcountindex].sh_addr;
-	ftrace_init_module(mseg, mseg + sechdrs[mcountindex].sh_size);
+	mseg = section_objs(hdr, sechdrs, secstrings, "__mcount_loc",
+			    sizeof(*mseg), &num_mcount);
+	ftrace_init_module(mseg, mseg + num_mcount);
 
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
@@ -2261,30 +2224,24 @@ static noinline struct module *load_module(void __user *umod,
 	set_fs(old_fs);
 
 	mod->args = args;
-	if (obsparmindex)
+	if (section_addr(hdr, sechdrs, secstrings, "__obsparm"))
 		printk(KERN_WARNING "%s: Ignoring obsolete parameters\n",
 		       mod->name);
 
 	/* Now sew it into the lists so we can get lockdep and oops
-         * info during argument parsing.  Noone should access us, since
-         * strong_try_module_get() will fail. */
-	stop_machine(__link_module, mod, NULL);
-
-	/* Size of section 0 is 0, so this works well if no params */
-	err = parse_args(mod->name, mod->args,
-			 (struct kernel_param *)
-			 sechdrs[setupindex].sh_addr,
-			 sechdrs[setupindex].sh_size
-			 / sizeof(struct kernel_param),
-			 NULL);
+	 * info during argument parsing.  Noone should access us, since
+	 * strong_try_module_get() will fail.
+	 * lockdep/oops can run asynchronous, so use the RCU list insertion
+	 * function to insert in a way safe to concurrent readers.
+	 * The mutex protects against concurrent writers.
+	 */
+	list_add_rcu(&mod->list, &modules);
+
+	err = parse_args(mod->name, mod->args, kp, num_kp, NULL);
 	if (err < 0)
 		goto unlink;
 
-	err = mod_sysfs_setup(mod,
-			      (struct kernel_param *)
-			      sechdrs[setupindex].sh_addr,
-			      sechdrs[setupindex].sh_size
-			      / sizeof(struct kernel_param));
+	err = mod_sysfs_setup(mod, kp, num_kp);
 	if (err < 0)
 		goto unlink;
 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
@@ -2473,7 +2430,7 @@ const char *module_address_lookup(unsigned long addr,
 	const char *ret = NULL;
 
 	preempt_disable();
-	list_for_each_entry(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list) {
 		if (within(addr, mod->module_init, mod->init_size)
 		    || within(addr, mod->module_core, mod->core_size)) {
 			if (modname)
@@ -2496,7 +2453,7 @@ int lookup_module_symbol_name(unsigned long addr, char *symname)
 	struct module *mod;
 
 	preempt_disable();
-	list_for_each_entry(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list) {
 		if (within(addr, mod->module_init, mod->init_size) ||
 		    within(addr, mod->module_core, mod->core_size)) {
 			const char *sym;
@@ -2520,7 +2477,7 @@ int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size,
 	struct module *mod;
 
 	preempt_disable();
-	list_for_each_entry(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list) {
 		if (within(addr, mod->module_init, mod->init_size) ||
 		    within(addr, mod->module_core, mod->core_size)) {
 			const char *sym;
@@ -2547,7 +2504,7 @@ int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 	struct module *mod;
 
 	preempt_disable();
-	list_for_each_entry(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list) {
 		if (symnum < mod->num_symtab) {
 			*value = mod->symtab[symnum].st_value;
 			*type = mod->symtab[symnum].st_info;
@@ -2590,7 +2547,7 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 			ret = mod_find_symname(mod, colon+1);
 		*colon = ':';
 	} else {
-		list_for_each_entry(mod, &modules, list)
+		list_for_each_entry_rcu(mod, &modules, list)
 			if ((ret = mod_find_symname(mod, name)) != 0)
 				break;
 	}
@@ -2693,7 +2650,7 @@ const struct exception_table_entry *search_module_extables(unsigned long addr)
 	struct module *mod;
 
 	preempt_disable();
-	list_for_each_entry(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->num_exentries == 0)
 			continue;
 
@@ -2719,7 +2676,7 @@ int is_module_address(unsigned long addr)
 
 	preempt_disable();
 
-	list_for_each_entry(mod, &modules, list) {
+	list_for_each_entry_rcu(mod, &modules, list) {
 		if (within(addr, mod->module_core, mod->core_size)) {
 			preempt_enable();
 			return 1;
@@ -2740,7 +2697,7 @@ struct module *__module_text_address(unsigned long addr)
 	if (addr < module_addr_min || addr > module_addr_max)
 		return NULL;
 
-	list_for_each_entry(mod, &modules, list)
+	list_for_each_entry_rcu(mod, &modules, list)
 		if (within(addr, mod->module_init, mod->init_text_size)
 		    || within(addr, mod->module_core, mod->core_text_size))
 			return mod;
@@ -2765,8 +2722,11 @@ void print_modules(void)
 	char buf[8];
 
 	printk("Modules linked in:");
-	list_for_each_entry(mod, &modules, list)
+	/* Most callers should already have preempt disabled, but make sure */
+	preempt_disable();
+	list_for_each_entry_rcu(mod, &modules, list)
 		printk(" %s%s", mod->name, module_flags(mod, buf));
+	preempt_enable();
 	if (last_unloaded_module[0])
 		printk(" [last unloaded: %s]", last_unloaded_module);
 	printk("\n");
diff --git a/kernel/panic.c b/kernel/panic.c
index bda561e..6513aac 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -34,13 +34,6 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
 EXPORT_SYMBOL(panic_notifier_list);
 
-static int __init panic_setup(char *str)
-{
-	panic_timeout = simple_strtoul(str, NULL, 0);
-	return 1;
-}
-__setup("panic=", panic_setup);
-
 static long no_blink(long time)
 {
 	return 0;
@@ -218,13 +211,6 @@ void add_taint(unsigned flag)
 }
 EXPORT_SYMBOL(add_taint);
 
-static int __init pause_on_oops_setup(char *str)
-{
-	pause_on_oops = simple_strtoul(str, NULL, 0);
-	return 1;
-}
-__setup("pause_on_oops=", pause_on_oops_setup);
-
 static void spin_msec(int msecs)
 {
 	int i;
@@ -384,3 +370,6 @@ void __stack_chk_fail(void)
 }
 EXPORT_SYMBOL(__stack_chk_fail);
 #endif
+
+core_param(panic, panic_timeout, int, 0644);
+core_param(pause_on_oops, pause_on_oops, int, 0644);
diff --git a/kernel/params.c b/kernel/params.c
index afc46a2..b077f1b 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -373,6 +373,8 @@ int param_get_string(char *buffer, struct kernel_param *kp)
 }
 
 /* sysfs output in /sys/modules/XYZ/parameters/ */
+#define to_module_attr(n) container_of(n, struct module_attribute, attr);
+#define to_module_kobject(n) container_of(n, struct module_kobject, kobj);
 
 extern struct kernel_param __start___param[], __stop___param[];
 
@@ -384,6 +386,7 @@ struct param_attribute
 
 struct module_param_attrs
 {
+	unsigned int num;
 	struct attribute_group grp;
 	struct param_attribute attrs[0];
 };
@@ -434,69 +437,84 @@ static ssize_t param_attr_store(struct module_attribute *mattr,
 
 #ifdef CONFIG_SYSFS
 /*
- * param_sysfs_setup - setup sysfs support for one module or KBUILD_MODNAME
- * @mk: struct module_kobject (contains parent kobject)
- * @kparam: array of struct kernel_param, the actual parameter definitions
- * @num_params: number of entries in array
- * @name_skip: offset where the parameter name start in kparam[].name. Needed for built-in "modules"
+ * add_sysfs_param - add a parameter to sysfs
+ * @mk: struct module_kobject
+ * @kparam: the actual parameter definition to add to sysfs
+ * @name: name of parameter
  *
- * Create a kobject for a (per-module) group of parameters, and create files
- * in sysfs. A pointer to the param_kobject is returned on success,
- * NULL if there's no parameter to export, or other ERR_PTR(err).
+ * Create a kobject if for a (per-module) parameter if mp NULL, and
+ * create file in sysfs.  Returns an error on out of memory.  Always cleans up
+ * if there's an error.
  */
-static __modinit struct module_param_attrs *
-param_sysfs_setup(struct module_kobject *mk,
-		  struct kernel_param *kparam,
-		  unsigned int num_params,
-		  unsigned int name_skip)
+static __modinit int add_sysfs_param(struct module_kobject *mk,
+				     struct kernel_param *kp,
+				     const char *name)
 {
-	struct module_param_attrs *mp;
-	unsigned int valid_attrs = 0;
-	unsigned int i, size[2];
-	struct param_attribute *pattr;
-	struct attribute **gattr;
-	int err;
-
-	for (i=0; i<num_params; i++) {
-		if (kparam[i].perm)
-			valid_attrs++;
+	struct module_param_attrs *new;
+	struct attribute **attrs;
+	int err, num;
+
+	/* We don't bother calling this with invisible parameters. */
+	BUG_ON(!kp->perm);
+
+	if (!mk->mp) {
+		num = 0;
+		attrs = NULL;
+	} else {
+		num = mk->mp->num;
+		attrs = mk->mp->grp.attrs;
 	}
 
-	if (!valid_attrs)
-		return NULL;
-
-	size[0] = ALIGN(sizeof(*mp) +
-			valid_attrs * sizeof(mp->attrs[0]),
-			sizeof(mp->grp.attrs[0]));
-	size[1] = (valid_attrs + 1) * sizeof(mp->grp.attrs[0]);
-
-	mp = kzalloc(size[0] + size[1], GFP_KERNEL);
-	if (!mp)
-		return ERR_PTR(-ENOMEM);
+	/* Enlarge. */
+	new = krealloc(mk->mp,
+		       sizeof(*mk->mp) + sizeof(mk->mp->attrs[0]) * (num+1),
+		       GFP_KERNEL);
+	if (!new) {
+		kfree(mk->mp);
+		err = -ENOMEM;
+		goto fail;
+	}
+	attrs = krealloc(attrs, sizeof(new->grp.attrs[0])*(num+2), GFP_KERNEL);
+	if (!attrs) {
+		err = -ENOMEM;
+		goto fail_free_new;
+	}
 
-	mp->grp.name = "parameters";
-	mp->grp.attrs = (void *)mp + size[0];
+	/* Sysfs wants everything zeroed. */
+	memset(new, 0, sizeof(*new));
+	memset(&new->attrs[num], 0, sizeof(new->attrs[num]));
+	memset(&attrs[num], 0, sizeof(attrs[num]));
+	new->grp.name = "parameters";
+	new->grp.attrs = attrs;
+
+	/* Tack new one on the end. */
+	new->attrs[num].param = kp;
+	new->attrs[num].mattr.show = param_attr_show;
+	new->attrs[num].mattr.store = param_attr_store;
+	new->attrs[num].mattr.attr.name = (char *)name;
+	new->attrs[num].mattr.attr.mode = kp->perm;
+	new->num = num+1;
+
+	/* Fix up all the pointers, since krealloc can move us */
+	for (num = 0; num < new->num; num++)
+		new->grp.attrs[num] = &new->attrs[num].mattr.attr;
+	new->grp.attrs[num] = NULL;
+
+	mk->mp = new;
+	return 0;
 
-	pattr = &mp->attrs[0];
-	gattr = &mp->grp.attrs[0];
-	for (i = 0; i < num_params; i++) {
-		struct kernel_param *kp = &kparam[i];
-		if (kp->perm) {
-			pattr->param = kp;
-			pattr->mattr.show = param_attr_show;
-			pattr->mattr.store = param_attr_store;
-			pattr->mattr.attr.name = (char *)&kp->name[name_skip];
-			pattr->mattr.attr.mode = kp->perm;
-			*(gattr++) = &(pattr++)->mattr.attr;
-		}
-	}
-	*gattr = NULL;
+fail_free_new:
+	kfree(new);
+fail:
+	mk->mp = NULL;
+	return err;
+}
 
-	if ((err = sysfs_create_group(&mk->kobj, &mp->grp))) {
-		kfree(mp);
-		return ERR_PTR(err);
-	}
-	return mp;
+static void free_module_param_attrs(struct module_kobject *mk)
+{
+	kfree(mk->mp->grp.attrs);
+	kfree(mk->mp);
+	mk->mp = NULL;
 }
 
 #ifdef CONFIG_MODULES
@@ -506,21 +524,33 @@ param_sysfs_setup(struct module_kobject *mk,
  * @kparam: module parameters (array)
  * @num_params: number of module parameters
  *
- * Adds sysfs entries for module parameters, and creates a link from
- * /sys/module/[mod->name]/parameters to /sys/parameters/[mod->name]/
+ * Adds sysfs entries for module parameters under
+ * /sys/module/[mod->name]/parameters/
  */
 int module_param_sysfs_setup(struct module *mod,
 			     struct kernel_param *kparam,
 			     unsigned int num_params)
 {
-	struct module_param_attrs *mp;
+	int i, err;
+	bool params = false;
+
+	for (i = 0; i < num_params; i++) {
+		if (kparam[i].perm == 0)
+			continue;
+		err = add_sysfs_param(&mod->mkobj, &kparam[i], kparam[i].name);
+		if (err)
+			return err;
+		params = true;
+	}
 
-	mp = param_sysfs_setup(&mod->mkobj, kparam, num_params, 0);
-	if (IS_ERR(mp))
-		return PTR_ERR(mp);
+	if (!params)
+		return 0;
 
-	mod->param_attrs = mp;
-	return 0;
+	/* Create the param group. */
+	err = sysfs_create_group(&mod->mkobj.kobj, &mod->mkobj.mp->grp);
+	if (err)
+		free_module_param_attrs(&mod->mkobj);
+	return err;
 }
 
 /*
@@ -532,43 +562,55 @@ int module_param_sysfs_setup(struct module *mod,
  */
 void module_param_sysfs_remove(struct module *mod)
 {
-	if (mod->param_attrs) {
-		sysfs_remove_group(&mod->mkobj.kobj,
-				   &mod->param_attrs->grp);
+	if (mod->mkobj.mp) {
+		sysfs_remove_group(&mod->mkobj.kobj, &mod->mkobj.mp->grp);
 		/* We are positive that no one is using any param
 		 * attrs at this point.  Deallocate immediately. */
-		kfree(mod->param_attrs);
-		mod->param_attrs = NULL;
+		free_module_param_attrs(&mod->mkobj);
 	}
 }
 #endif
 
-/*
- * kernel_param_sysfs_setup - wrapper for built-in params support
- */
-static void __init kernel_param_sysfs_setup(const char *name,
-					    struct kernel_param *kparam,
-					    unsigned int num_params,
-					    unsigned int name_skip)
+static void __init kernel_add_sysfs_param(const char *name,
+					  struct kernel_param *kparam,
+					  unsigned int name_skip)
 {
 	struct module_kobject *mk;
-	int ret;
+	struct kobject *kobj;
+	int err;
 
-	mk = kzalloc(sizeof(struct module_kobject), GFP_KERNEL);
-	BUG_ON(!mk);
-
-	mk->mod = THIS_MODULE;
-	mk->kobj.kset = module_kset;
-	ret = kobject_init_and_add(&mk->kobj, &module_ktype, NULL, "%s", name);
-	if (ret) {
-		kobject_put(&mk->kobj);
-		printk(KERN_ERR "Module '%s' failed to be added to sysfs, "
-		      "error number %d\n", name, ret);
-		printk(KERN_ERR	"The system will be unstable now.\n");
-		return;
+	kobj = kset_find_obj(module_kset, name);
+	if (kobj) {
+		/* We already have one.  Remove params so we can add more. */
+		mk = to_module_kobject(kobj);
+		/* We need to remove it before adding parameters. */
+		sysfs_remove_group(&mk->kobj, &mk->mp->grp);
+	} else {
+		mk = kzalloc(sizeof(struct module_kobject), GFP_KERNEL);
+		BUG_ON(!mk);
+
+		mk->mod = THIS_MODULE;
+		mk->kobj.kset = module_kset;
+		err = kobject_init_and_add(&mk->kobj, &module_ktype, NULL,
+					   "%s", name);
+		if (err) {
+			kobject_put(&mk->kobj);
+			printk(KERN_ERR "Module '%s' failed add to sysfs, "
+			       "error number %d\n", name, err);
+			printk(KERN_ERR	"The system will be unstable now.\n");
+			return;
+		}
+		/* So that exit path is even. */
+		kobject_get(&mk->kobj);
 	}
-	param_sysfs_setup(mk, kparam, num_params, name_skip);
+
+	/* These should not fail at boot. */
+	err = add_sysfs_param(mk, kparam, kparam->name + name_skip);
+	BUG_ON(err);
+	err = sysfs_create_group(&mk->kobj, &mk->mp->grp);
+	BUG_ON(err);
 	kobject_uevent(&mk->kobj, KOBJ_ADD);
+	kobject_put(&mk->kobj);
 }
 
 /*
@@ -579,60 +621,36 @@ static void __init kernel_param_sysfs_setup(const char *name,
  * The "module" name (KBUILD_MODNAME) is stored before a dot, the
  * "parameter" name is stored behind a dot in kernel_param->name. So,
  * extract the "module" name for all built-in kernel_param-eters,
- * and for all who have the same, call kernel_param_sysfs_setup.
+ * and for all who have the same, call kernel_add_sysfs_param.
  */
 static void __init param_sysfs_builtin(void)
 {
-	struct kernel_param *kp, *kp_begin = NULL;
-	unsigned int i, name_len, count = 0;
-	char modname[MODULE_NAME_LEN + 1] = "";
+	struct kernel_param *kp;
+	unsigned int name_len;
+	char modname[MODULE_NAME_LEN];
 
-	for (i=0; i < __stop___param - __start___param; i++) {
+	for (kp = __start___param; kp < __stop___param; kp++) {
 		char *dot;
-		size_t max_name_len;
 
-		kp = &__start___param[i];
-		max_name_len =
-			min_t(size_t, MODULE_NAME_LEN, strlen(kp->name));
+		if (kp->perm == 0)
+			continue;
 
-		dot = memchr(kp->name, '.', max_name_len);
+		dot = strchr(kp->name, '.');
 		if (!dot) {
-			DEBUGP("couldn't find period in first %d characters "
-			       "of %s\n", MODULE_NAME_LEN, kp->name);
-			continue;
-		}
-		name_len = dot - kp->name;
-
- 		/* new kbuild_modname? */
-		if (strlen(modname) != name_len
-		    || strncmp(modname, kp->name, name_len) != 0) {
-			/* add a new kobject for previous kernel_params. */
-			if (count)
-				kernel_param_sysfs_setup(modname,
-							 kp_begin,
-							 count,
-							 strlen(modname)+1);
-
-			strncpy(modname, kp->name, name_len);
-			modname[name_len] = '\0';
-			count = 0;
-			kp_begin = kp;
+			/* This happens for core_param() */
+			strcpy(modname, "kernel");
+			name_len = 0;
+		} else {
+			name_len = dot - kp->name + 1;
+			strlcpy(modname, kp->name, name_len);
 		}
-		count++;
+		kernel_add_sysfs_param(modname, kp, name_len);
 	}
-
-	/* last kernel_params need to be registered as well */
-	if (count)
-		kernel_param_sysfs_setup(modname, kp_begin, count,
-					 strlen(modname)+1);
 }
 
 
 /* module-related sysfs stuff */
 
-#define to_module_attr(n) container_of(n, struct module_attribute, attr);
-#define to_module_kobject(n) container_of(n, struct module_kobject, kobj);
-
 static ssize_t module_attr_show(struct kobject *kobj,
 				struct attribute *attr,
 				char *buf)
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index af3c7ce..8aff79d 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -37,9 +37,13 @@ struct stop_machine_data {
 /* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
 static unsigned int num_threads;
 static atomic_t thread_ack;
-static struct completion finished;
 static DEFINE_MUTEX(lock);
 
+static struct workqueue_struct *stop_machine_wq;
+static struct stop_machine_data active, idle;
+static const cpumask_t *active_cpus;
+static void *stop_machine_work;
+
 static void set_state(enum stopmachine_state newstate)
 {
 	/* Reset ack counter. */
@@ -51,21 +55,26 @@ static void set_state(enum stopmachine_state newstate)
 /* Last one to ack a state moves to the next state. */
 static void ack_state(void)
 {
-	if (atomic_dec_and_test(&thread_ack)) {
-		/* If we're the last one to ack the EXIT, we're finished. */
-		if (state == STOPMACHINE_EXIT)
-			complete(&finished);
-		else
-			set_state(state + 1);
-	}
+	if (atomic_dec_and_test(&thread_ack))
+		set_state(state + 1);
 }
 
-/* This is the actual thread which stops the CPU.  It exits by itself rather
- * than waiting for kthread_stop(), because it's easier for hotplug CPU. */
-static int stop_cpu(struct stop_machine_data *smdata)
+/* This is the actual function which stops the CPU. It runs
+ * in the context of a dedicated stopmachine workqueue. */
+static void stop_cpu(struct work_struct *unused)
 {
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
-
+	struct stop_machine_data *smdata = &idle;
+	int cpu = smp_processor_id();
+	int err;
+
+	if (!active_cpus) {
+		if (cpu == first_cpu(cpu_online_map))
+			smdata = &active;
+	} else {
+		if (cpu_isset(cpu, *active_cpus))
+			smdata = &active;
+	}
 	/* Simple state machine */
 	do {
 		/* Chill out and ensure we re-read stopmachine_state. */
@@ -78,9 +87,11 @@ static int stop_cpu(struct stop_machine_data *smdata)
 				hard_irq_disable();
 				break;
 			case STOPMACHINE_RUN:
-				/* |= allows error detection if functions on
-				 * multiple CPUs. */
-				smdata->fnret |= smdata->fn(smdata->data);
+				/* On multiple CPUs only a single error code
+				 * is needed to tell that something failed. */
+				err = smdata->fn(smdata->data);
+				if (err)
+					smdata->fnret = err;
 				break;
 			default:
 				break;
@@ -90,7 +101,6 @@ static int stop_cpu(struct stop_machine_data *smdata)
 	} while (curstate != STOPMACHINE_EXIT);
 
 	local_irq_enable();
-	do_exit(0);
 }
 
 /* Callback for CPUs which aren't supposed to do anything. */
@@ -101,78 +111,34 @@ static int chill(void *unused)
 
 int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
 {
-	int i, err;
-	struct stop_machine_data active, idle;
-	struct task_struct **threads;
+	struct work_struct *sm_work;
+	int i;
 
+	/* Set up initial state. */
+	mutex_lock(&lock);
+	num_threads = num_online_cpus();
+	active_cpus = cpus;
 	active.fn = fn;
 	active.data = data;
 	active.fnret = 0;
 	idle.fn = chill;
 	idle.data = NULL;
 
-	/* This could be too big for stack on large machines. */
-	threads = kcalloc(NR_CPUS, sizeof(threads[0]), GFP_KERNEL);
-	if (!threads)
-		return -ENOMEM;
-
-	/* Set up initial state. */
-	mutex_lock(&lock);
-	init_completion(&finished);
-	num_threads = num_online_cpus();
 	set_state(STOPMACHINE_PREPARE);
 
-	for_each_online_cpu(i) {
-		struct stop_machine_data *smdata = &idle;
-		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
-
-		if (!cpus) {
-			if (i == first_cpu(cpu_online_map))
-				smdata = &active;
-		} else {
-			if (cpu_isset(i, *cpus))
-				smdata = &active;
-		}
-
-		threads[i] = kthread_create((void *)stop_cpu, smdata, "kstop%u",
-					    i);
-		if (IS_ERR(threads[i])) {
-			err = PTR_ERR(threads[i]);
-			threads[i] = NULL;
-			goto kill_threads;
-		}
-
-		/* Place it onto correct cpu. */
-		kthread_bind(threads[i], i);
-
-		/* Make it highest prio. */
-		if (sched_setscheduler_nocheck(threads[i], SCHED_FIFO, &param))
-			BUG();
-	}
-
-	/* We've created all the threads.  Wake them all: hold this CPU so one
+	/* Schedule the stop_cpu work on all cpus: hold this CPU so one
 	 * doesn't hit this CPU until we're ready. */
 	get_cpu();
-	for_each_online_cpu(i)
-		wake_up_process(threads[i]);
-
+	for_each_online_cpu(i) {
+		sm_work = percpu_ptr(stop_machine_work, i);
+		INIT_WORK(sm_work, stop_cpu);
+		queue_work_on(i, stop_machine_wq, sm_work);
+	}
 	/* This will release the thread on our CPU. */
 	put_cpu();
-	wait_for_completion(&finished);
+	flush_workqueue(stop_machine_wq);
 	mutex_unlock(&lock);
-
-	kfree(threads);
-
 	return active.fnret;
-
-kill_threads:
-	for_each_online_cpu(i)
-		if (threads[i])
-			kthread_stop(threads[i]);
-	mutex_unlock(&lock);
-
-	kfree(threads);
-	return err;
 }
 
 int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
@@ -187,3 +153,11 @@ int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(stop_machine);
+
+static int __init stop_machine_init(void)
+{
+	stop_machine_wq = create_rt_workqueue("kstop");
+	stop_machine_work = alloc_percpu(struct work_struct);
+	return 0;
+}
+early_initcall(stop_machine_init);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 714afad..f928f2a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -62,6 +62,7 @@ struct workqueue_struct {
 	const char *name;
 	int singlethread;
 	int freezeable;		/* Freeze threads during suspend */
+	int rt;
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map lockdep_map;
 #endif
@@ -766,6 +767,7 @@ init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 
 static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
+	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 	struct workqueue_struct *wq = cwq->wq;
 	const char *fmt = is_single_threaded(wq) ? "%s" : "%s/%d";
 	struct task_struct *p;
@@ -781,7 +783,8 @@ static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 	 */
 	if (IS_ERR(p))
 		return PTR_ERR(p);
-
+	if (cwq->wq->rt)
+		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
 	cwq->thread = p;
 
 	return 0;
@@ -801,6 +804,7 @@ static void start_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 struct workqueue_struct *__create_workqueue_key(const char *name,
 						int singlethread,
 						int freezeable,
+						int rt,
 						struct lock_class_key *key,
 						const char *lock_name)
 {
@@ -822,6 +826,7 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	wq->singlethread = singlethread;
 	wq->freezeable = freezeable;
+	wq->rt = rt;
 	INIT_LIST_HEAD(&wq->list);
 
 	if (singlethread) {
