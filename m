Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbZKGVEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbZKGVEc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 16:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbZKGVE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 16:04:27 -0500
Received: from mxout-08.mxes.net ([216.86.168.183]:39928 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbZKGVET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 16:04:19 -0500
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 06/10] module: refactor symbol tables and try to reduce code size of each_symbol()
Date: Sat,  7 Nov 2009 21:03:57 +0000
Message-Id: <1257627841-15817-6-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <4AF5DF9F.5020208@tuffmail.co.uk>
References: <4AF5DF9F.5020208@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_symbol() will use bsearch() instead of each_symbol(). each_symbol()
is still desired by Ksplice (although it is not in-tree yet).  Let's try
to minimize the code which will be duplicated between these two
functions, by changing how the symbol tables are declared.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 include/linux/module.h |  102 +++++++++++++--------
 kernel/module.c        |  241 ++++++++++++++++++++++++------------------------
 2 files changed, 183 insertions(+), 160 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index b9e860a..0bb0f74 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -168,6 +168,62 @@ void *__symbol_get(const char *symbol);
 void *__symbol_get_gpl(const char *symbol);
 #define symbol_get(x) ((typeof(&x))(__symbol_get(MODULE_SYMBOL_PREFIX #x)))
 
+#ifdef CONFIG_UNUSED_SYMBOLS
+enum export_type {
+	/* GPL-only exported symbols. */
+	__EXPORT_FLAG_GPL_ONLY =	0x1,
+
+	/* unused exported symbols. */
+	__EXPORT_FLAG_UNUSED =		0x2,
+
+	/* exports that will be GPL-only in the near future. */
+	__EXPORT_FLAG_GPL_FUTURE =	0x4,
+
+	EXPORT_TYPE_PLAIN =		0x0,
+	EXPORT_TYPE_GPL =		0x1,
+	EXPORT_TYPE_UNUSED =		0x2,
+	EXPORT_TYPE_UNUSED_GPL =	0x3,
+	EXPORT_TYPE_GPL_FUTURE = 	0x4,
+
+	EXPORT_TYPE_MAX
+};
+
+#else /* !CONFIG_UNUSED_EXPORTS */
+enum export_type {
+	__EXPORT_FLAG_UNUSED =		0x0,
+	__EXPORT_FLAG_GPL_ONLY =	0x1,
+	__EXPORT_FLAG_GPL_FUTURE =	0x2,
+
+	EXPORT_TYPE_PLAIN =		0x0,
+	EXPORT_TYPE_GPL =		0x1,
+	EXPORT_TYPE_GPL_FUTURE = 	0x2,
+	EXPORT_TYPE_MAX
+};
+#endif
+
+static inline bool export_is_gpl_only(enum export_type type)
+{
+	return (type & __EXPORT_FLAG_GPL_ONLY);
+}
+
+static inline bool export_is_unused(enum export_type type)
+{
+	return (type & __EXPORT_FLAG_UNUSED);
+}
+
+static inline bool export_is_gpl_future(enum export_type type)
+{
+	return (type & __EXPORT_FLAG_GPL_FUTURE);
+}
+
+struct ksymtab {
+	const struct kernel_symbol *syms;
+#ifdef CONFIG_MODVERSIONS
+	const unsigned long *crcs;
+#endif
+	unsigned int num_syms;
+};
+
 enum module_state
 {
 	MODULE_STATE_LIVE,
@@ -193,36 +249,12 @@ struct module
 	struct kobject *holders_dir;
 
 	/* Exported symbols */
-	const struct kernel_symbol *syms;
-	const unsigned long *crcs;
-	unsigned int num_syms;
+	struct ksymtab syms[EXPORT_TYPE_MAX];
 
 	/* Kernel parameters. */
 	struct kernel_param *kp;
 	unsigned int num_kp;
 
-	/* GPL-only exported symbols. */
-	unsigned int num_gpl_syms;
-	const struct kernel_symbol *gpl_syms;
-	const unsigned long *gpl_crcs;
-
-#ifdef CONFIG_UNUSED_SYMBOLS
-	/* unused exported symbols. */
-	const struct kernel_symbol *unused_syms;
-	const unsigned long *unused_crcs;
-	unsigned int num_unused_syms;
-
-	/* GPL-only, unused exported symbols. */
-	unsigned int num_unused_gpl_syms;
-	const struct kernel_symbol *unused_gpl_syms;
-	const unsigned long *unused_gpl_crcs;
-#endif
-
-	/* symbols that will be GPL-only in the near future. */
-	const struct kernel_symbol *gpl_future_syms;
-	const unsigned long *gpl_future_crcs;
-	unsigned int num_gpl_future_syms;
-
 	/* Exception table */
 	unsigned int num_exentries;
 	struct exception_table_entry *extable;
@@ -352,17 +384,6 @@ static inline int within_module_init(unsigned long addr, struct module *mod)
 /* Search for module by name: must hold module_mutex. */
 struct module *find_module(const char *name);
 
-struct symsearch {
-	const struct kernel_symbol *start, *stop;
-	const unsigned long *crcs;
-	enum {
-		NOT_GPL_ONLY,
-		GPL_ONLY,
-		WILL_BE_GPL_ONLY,
-	} licence;
-	bool unused;
-};
-
 /* Search for an exported symbol by name. */
 const struct kernel_symbol *find_symbol(const char *name,
 					struct module **owner,
@@ -370,9 +391,14 @@ const struct kernel_symbol *find_symbol(const char *name,
 					bool gplok,
 					bool warn);
 
+typedef bool each_symbol_fn_t (enum export_type type,
+			       const struct kernel_symbol *sym,
+			       const unsigned long *crc,
+			       struct module *owner,
+			       void *data);
+
 /* Walk the exported symbol table */
-bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
-			    unsigned int symnum, void *data), void *data);
+bool each_symbol(each_symbol_fn_t *fn, void *data);
 
 /* Returns 0 and fills in value, defined and namebuf, or -ERANGE if
    symnum out of range. */
diff --git a/kernel/module.c b/kernel/module.c
index fe748a8..ca4f2ba 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -192,25 +192,56 @@ extern const unsigned long __start___kcrctab_unused[];
 extern const unsigned long __start___kcrctab_unused_gpl[];
 #endif
 
+static struct ksymtab ksymtab[EXPORT_TYPE_MAX];
+
+static int __init init_ksymtab(void)
+{
+	ksymtab[EXPORT_TYPE_PLAIN] = (struct ksymtab) {
+		__start___ksymtab, __start___kcrctab,
+		__stop___ksymtab - __start___ksymtab,
+	};
+	ksymtab[EXPORT_TYPE_GPL] = (struct ksymtab) {
+		__start___ksymtab_gpl, __start___kcrctab_gpl,
+		__stop___ksymtab_gpl - __start___ksymtab_gpl,
+	};
+#ifdef CONFIG_UNUSED_EXPORTS
+	ksymtab[EXPORT_TYPE_UNUSED] = (struct ksymtab) {
+		__start___ksymtab_unused, __start___kcrctab_unused,
+		__stop___ksymtab_unused - __start___ksymtab_unused,
+	};
+	ksymtab[EXPORT_TYPE_UNUSED_GPL] = (struct ksymtab) {
+		__start___ksymtab_unused_gpl, __start___kcrctab_unused_gpl,
+		__stop___ksymtab_unused_gpl - __start___ksymtab_unused_gpl,
+	};
+#endif
+	ksymtab[EXPORT_TYPE_GPL_FUTURE] = (struct ksymtab) {
+		__start___ksymtab_gpl_future, __start___kcrctab_gpl_future,
+		__stop___ksymtab_gpl_future - __start___ksymtab_gpl_future,
+	};
+
+	return 0;
+}
+pure_initcall(init_ksymtab);
+
 #ifndef CONFIG_MODVERSIONS
 #define symversion(base, idx) NULL
 #else
 #define symversion(base, idx) ((base != NULL) ? ((base) + (idx)) : NULL)
 #endif
 
-static bool each_symbol_in_section(const struct symsearch *arr,
-				   unsigned int arrsize,
+static bool each_symbol_in_section(const struct ksymtab syms[EXPORT_TYPE_MAX],
 				   struct module *owner,
-				   bool (*fn)(const struct symsearch *syms,
-					      struct module *owner,
-					      unsigned int symnum, void *data),
+				   each_symbol_fn_t *fn,
 				   void *data)
 {
-	unsigned int i, j;
+	enum export_type type;
+	unsigned int i;
 
-	for (j = 0; j < arrsize; j++) {
-		for (i = 0; i < arr[j].stop - arr[j].start; i++)
-			if (fn(&arr[j], owner, i, data))
+	for (type = 0; type < EXPORT_TYPE_MAX; type++) {
+		for (i = 0; i < syms[type].num_syms; i++)
+			if (fn(type, &syms[type].syms[i],
+			       symversion(syms[type].crcs, i),
+			       owner, data))
 				return true;
 	}
 
@@ -218,56 +249,15 @@ static bool each_symbol_in_section(const struct symsearch *arr,
 }
 
 /* Returns true as soon as fn returns true, otherwise false. */
-bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
-			    unsigned int symnum, void *data), void *data)
+bool each_symbol(each_symbol_fn_t *fn, void *data)
 {
 	struct module *mod;
-	const struct symsearch arr[] = {
-		{ __start___ksymtab, __stop___ksymtab, __start___kcrctab,
-		  NOT_GPL_ONLY, false },
-		{ __start___ksymtab_gpl, __stop___ksymtab_gpl,
-		  __start___kcrctab_gpl,
-		  GPL_ONLY, false },
-		{ __start___ksymtab_gpl_future, __stop___ksymtab_gpl_future,
-		  __start___kcrctab_gpl_future,
-		  WILL_BE_GPL_ONLY, false },
-#ifdef CONFIG_UNUSED_SYMBOLS
-		{ __start___ksymtab_unused, __stop___ksymtab_unused,
-		  __start___kcrctab_unused,
-		  NOT_GPL_ONLY, true },
-		{ __start___ksymtab_unused_gpl, __stop___ksymtab_unused_gpl,
-		  __start___kcrctab_unused_gpl,
-		  GPL_ONLY, true },
-#endif
-	};
 
-	if (each_symbol_in_section(arr, ARRAY_SIZE(arr), NULL, fn, data))
+	if (each_symbol_in_section(ksymtab, NULL, fn, data))
 		return true;
 
 	list_for_each_entry_rcu(mod, &modules, list) {
-		struct symsearch arr[] = {
-			{ mod->syms, mod->syms + mod->num_syms, mod->crcs,
-			  NOT_GPL_ONLY, false },
-			{ mod->gpl_syms, mod->gpl_syms + mod->num_gpl_syms,
-			  mod->gpl_crcs,
-			  GPL_ONLY, false },
-			{ mod->gpl_future_syms,
-			  mod->gpl_future_syms + mod->num_gpl_future_syms,
-			  mod->gpl_future_crcs,
-			  WILL_BE_GPL_ONLY, false },
-#ifdef CONFIG_UNUSED_SYMBOLS
-			{ mod->unused_syms,
-			  mod->unused_syms + mod->num_unused_syms,
-			  mod->unused_crcs,
-			  NOT_GPL_ONLY, true },
-			{ mod->unused_gpl_syms,
-			  mod->unused_gpl_syms + mod->num_unused_gpl_syms,
-			  mod->unused_gpl_crcs,
-			  GPL_ONLY, true },
-#endif
-		};
-
-		if (each_symbol_in_section(arr, ARRAY_SIZE(arr), mod, fn, data))
+		if (each_symbol_in_section(mod->syms, mod, fn, data))
 			return true;
 	}
 	return false;
@@ -286,19 +276,21 @@ struct find_symbol_arg {
 	const struct kernel_symbol *sym;
 };
 
-static bool find_symbol_in_section(const struct symsearch *syms,
+static bool find_symbol_in_section(enum export_type type,
+				   const struct kernel_symbol *sym,
+				   const unsigned long *crc,
 				   struct module *owner,
-				   unsigned int symnum, void *data)
+				   void *data)
 {
 	struct find_symbol_arg *fsa = data;
 
-	if (strcmp(syms->start[symnum].name, fsa->name) != 0)
+	if (strcmp(sym->name, fsa->name) != 0)
 		return false;
 
 	if (!fsa->gplok) {
-		if (syms->licence == GPL_ONLY)
+		if (export_is_gpl_only(type))
 			return false;
-		if (syms->licence == WILL_BE_GPL_ONLY && fsa->warn) {
+		if (export_is_gpl_future(type) && fsa->warn) {
 			printk(KERN_WARNING "Symbol %s is being used "
 			       "by a non-GPL module, which will not "
 			       "be allowed in the future\n", fsa->name);
@@ -309,7 +301,7 @@ static bool find_symbol_in_section(const struct symsearch *syms,
 	}
 
 #ifdef CONFIG_UNUSED_SYMBOLS
-	if (syms->unused && fsa->warn) {
+	if (export_is_unused(type) && fsa->warn) {
 		printk(KERN_WARNING "Symbol %s is marked as UNUSED, "
 		       "however this module is using it.\n", fsa->name);
 		printk(KERN_WARNING
@@ -323,8 +315,8 @@ static bool find_symbol_in_section(const struct symsearch *syms,
 #endif
 
 	fsa->owner = owner;
-	fsa->crc = symversion(syms->crcs, symnum);
-	fsa->sym = &syms->start[symnum];
+	fsa->crc = crc;
+	fsa->sym = sym;
 	return true;
 }
 
@@ -1564,23 +1556,13 @@ EXPORT_SYMBOL_GPL(__symbol_get);
 static int verify_export_symbols(struct module *mod)
 {
 	unsigned int i;
-	struct module *owner;
+	enum export_type type;
 	const struct kernel_symbol *s;
-	struct {
-		const struct kernel_symbol *sym;
-		unsigned int num;
-	} arr[] = {
-		{ mod->syms, mod->num_syms },
-		{ mod->gpl_syms, mod->num_gpl_syms },
-		{ mod->gpl_future_syms, mod->num_gpl_future_syms },
-#ifdef CONFIG_UNUSED_SYMBOLS
-		{ mod->unused_syms, mod->num_unused_syms },
-		{ mod->unused_gpl_syms, mod->num_unused_gpl_syms },
-#endif
-	};
+	struct module *owner;
 
-	for (i = 0; i < ARRAY_SIZE(arr); i++) {
-		for (s = arr[i].sym; s < arr[i].sym + arr[i].num; s++) {
+	for (type = 0; type < EXPORT_TYPE_MAX; type++) {
+		for (i = 0; i < mod->syms[type].num_syms; i++) {
+			s = &mod->syms[type].syms[i];
 			if (find_symbol(s->name, &owner, NULL, true, false)) {
 				printk(KERN_ERR
 				       "%s: exports duplicate symbol %s"
@@ -1812,24 +1794,30 @@ static void free_modinfo(struct module *mod)
 
 /* lookup symbol in given range of kernel_symbols */
 static const struct kernel_symbol *lookup_symbol(const char *name,
-	const struct kernel_symbol *start,
-	const struct kernel_symbol *stop)
+	const struct kernel_symbol *syms,
+	unsigned int count)
 {
-	const struct kernel_symbol *ks = start;
-	for (; ks < stop; ks++)
-		if (strcmp(ks->name, name) == 0)
-			return ks;
+	unsigned int i;
+
+	for (i = 0; i < count; i++)
+		if (strcmp(syms[i].name, name) == 0)
+			return &syms[i];
 	return NULL;
 }
 
 static int is_exported(const char *name, unsigned long value,
 		       const struct module *mod)
 {
+	const struct ksymtab *symtab;
 	const struct kernel_symbol *ks;
+
 	if (!mod)
-		ks = lookup_symbol(name, __start___ksymtab, __stop___ksymtab);
+		symtab = &ksymtab[EXPORT_TYPE_PLAIN];
 	else
-		ks = lookup_symbol(name, mod->syms, mod->syms + mod->num_syms);
+		symtab = &mod->syms[EXPORT_TYPE_PLAIN];
+
+	ks = lookup_symbol(name, symtab->syms, symtab->num_syms);
+
 	return ks != NULL && ks->value == value;
 }
 
@@ -2064,6 +2052,26 @@ static inline void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
 }
 #endif
 
+static const char *export_section_names[] = {
+	[EXPORT_TYPE_PLAIN] = "__ksymtab",
+	[EXPORT_TYPE_GPL] = "__ksymtab_gpl",
+#ifdef CONFIG_UNUSED_SYMBOLS
+	[EXPORT_TYPE_UNUSED] = "__ksymtab_unused",
+	[EXPORT_TYPE_UNUSED_GPL] = "__ksymtab_unused_gpl",
+#endif
+	[EXPORT_TYPE_GPL_FUTURE] = "__ksymtab_gpl_future",
+};
+
+static const char *crc_section_names[] = {
+	[EXPORT_TYPE_PLAIN] = "__kcrctab",
+	[EXPORT_TYPE_GPL] = "__kcrctab_gpl",
+#ifdef CONFIG_UNUSED_SYMBOLS
+	[EXPORT_TYPE_UNUSED] = "__kcrctab_unused",
+	[EXPORT_TYPE_UNUSED_GPL] = "__kcrctab_unused_gpl",
+#endif
+	[EXPORT_TYPE_GPL_FUTURE] = "__kcrctab_gpl_future",
+};
+
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static noinline struct module *load_module(void __user *umod,
@@ -2078,6 +2086,7 @@ static noinline struct module *load_module(void __user *umod,
 	unsigned int symindex = 0;
 	unsigned int strindex = 0;
 	unsigned int modindex, versindex, infoindex, pcpuindex;
+	enum export_type export_type;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -2338,34 +2347,21 @@ static noinline struct module *load_module(void __user *umod,
 	 * find optional sections. */
 	mod->kp = section_objs(hdr, sechdrs, secstrings, "__param",
 			       sizeof(*mod->kp), &mod->num_kp);
-	mod->syms = section_objs(hdr, sechdrs, secstrings, "__ksymtab",
-				 sizeof(*mod->syms), &mod->num_syms);
-	mod->crcs = section_addr(hdr, sechdrs, secstrings, "__kcrctab");
-	mod->gpl_syms = section_objs(hdr, sechdrs, secstrings, "__ksymtab_gpl",
-				     sizeof(*mod->gpl_syms),
-				     &mod->num_gpl_syms);
-	mod->gpl_crcs = section_addr(hdr, sechdrs, secstrings, "__kcrctab_gpl");
-	mod->gpl_future_syms = section_objs(hdr, sechdrs, secstrings,
-					    "__ksymtab_gpl_future",
-					    sizeof(*mod->gpl_future_syms),
-					    &mod->num_gpl_future_syms);
-	mod->gpl_future_crcs = section_addr(hdr, sechdrs, secstrings,
-					    "__kcrctab_gpl_future");
 
-#ifdef CONFIG_UNUSED_SYMBOLS
-	mod->unused_syms = section_objs(hdr, sechdrs, secstrings,
-					"__ksymtab_unused",
-					sizeof(*mod->unused_syms),
-					&mod->num_unused_syms);
-	mod->unused_crcs = section_addr(hdr, sechdrs, secstrings,
-					"__kcrctab_unused");
-	mod->unused_gpl_syms = section_objs(hdr, sechdrs, secstrings,
-					    "__ksymtab_unused_gpl",
-					    sizeof(*mod->unused_gpl_syms),
-					    &mod->num_unused_gpl_syms);
-	mod->unused_gpl_crcs = section_addr(hdr, sechdrs, secstrings,
-					    "__kcrctab_unused_gpl");
+	export_type = 0;
+	for (; export_type < ARRAY_SIZE(export_section_names); export_type++) {
+		mod->syms[export_type].syms =
+				section_objs(hdr, sechdrs, secstrings,
+					     export_section_names[export_type],
+					     sizeof(struct kernel_symbol),
+					     &mod->syms[export_type].num_syms);
+#ifdef CONFIG_MODVERSIONS
+		mod->syms[export_type].crcs =
+				section_addr(hdr, sechdrs, secstrings,
+					     crc_section_names[export_type]);
 #endif
+	}
+
 #ifdef CONFIG_CONSTRUCTORS
 	mod->ctors = section_objs(hdr, sechdrs, secstrings, ".ctors",
 				  sizeof(*mod->ctors), &mod->num_ctors);
@@ -2390,19 +2386,20 @@ static noinline struct module *load_module(void __user *umod,
 					     sizeof(*mod->ftrace_callsites),
 					     &mod->num_ftrace_callsites);
 #endif
+
 #ifdef CONFIG_MODVERSIONS
-	if ((mod->num_syms && !mod->crcs)
-	    || (mod->num_gpl_syms && !mod->gpl_crcs)
-	    || (mod->num_gpl_future_syms && !mod->gpl_future_crcs)
-#ifdef CONFIG_UNUSED_SYMBOLS
-	    || (mod->num_unused_syms && !mod->unused_crcs)
-	    || (mod->num_unused_gpl_syms && !mod->unused_gpl_crcs)
-#endif
-		) {
-		err = try_to_force_load(mod,
-					"no versions for exported symbols");
-		if (err)
-			goto cleanup;
+	export_type = 0;
+	for (; export_type < ARRAY_SIZE(mod->syms); export_type++) {
+		if (mod->syms[export_type].syms &&
+		    !mod->syms[export_type].crcs) {
+			err = try_to_force_load(mod,
+				"no versions for exported symbols");
+			if (err)
+				goto cleanup;
+
+			/* force load approved, don't check other sections */
+			break;
+		}
 	}
 #endif
 
-- 
1.6.3.3

