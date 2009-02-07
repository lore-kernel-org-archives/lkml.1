Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbZBGMs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbZBGMs7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 07:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZBGMqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 07:46:47 -0500
Received: from ozlabs.org ([203.10.76.45]:45017 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbZBGMqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 07:46:46 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 07 Feb 2009 23:15:22 +1030
Subject: [PATCH 1/9] module: Make find_symbol return a struct kernel_symbol
Cc: Anders Kaseorg <andersk@mit.edu>
Cc: Jeff Arnold <jbarnold@mit.edu>
Cc: Tim Abbott <tabbott@mit.edu>
Message-Id: <20090207124644.0737DDDDE0@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Abbott <tabbott@mit.edu>

Impact: Cleanup, internal API change

Ksplice needs access to the kernel_symbol structure in order to support
modifications to the exported symbol table.

Cc: Anders Kaseorg <andersk@mit.edu>
Cc: Jeff Arnold <jbarnold@mit.edu>
Signed-off-by: Tim Abbott <tabbott@mit.edu>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (bugfix and style)
---
 kernel/module.c |   77 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 38 insertions(+), 39 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -282,7 +282,7 @@ struct find_symbol_arg {
 	/* Output */
 	struct module *owner;
 	const unsigned long *crc;
-	unsigned long value;
+	const struct kernel_symbol *sym;
 };
 
 static bool find_symbol_in_section(const struct symsearch *syms,
@@ -323,17 +323,17 @@ static bool find_symbol_in_section(const
 
 	fsa->owner = owner;
 	fsa->crc = symversion(syms->crcs, symnum);
-	fsa->value = syms->start[symnum].value;
+	fsa->sym = &syms->start[symnum];
 	return true;
 }
 
-/* Find a symbol, return value, (optional) crc and (optional) module
- * which owns it */
-static unsigned long find_symbol(const char *name,
-				 struct module **owner,
-				 const unsigned long **crc,
-				 bool gplok,
-				 bool warn)
+/* Find a symbol and return it, along with, (optional) crc and
+ * (optional) module which owns it */
+static const struct kernel_symbol *find_symbol(const char *name,
+					       struct module **owner,
+					       const unsigned long **crc,
+					       bool gplok,
+					       bool warn)
 {
 	struct find_symbol_arg fsa;
 
@@ -346,11 +346,11 @@ static unsigned long find_symbol(const c
 			*owner = fsa.owner;
 		if (crc)
 			*crc = fsa.crc;
-		return fsa.value;
+		return fsa.sym;
 	}
 
 	DEBUGP("Failed to find symbol %s\n", name);
-	return -ENOENT;
+	return NULL;
 }
 
 /* Search for module by name: must hold module_mutex. */
@@ -860,7 +860,7 @@ void __symbol_put(const char *symbol)
 	struct module *owner;
 
 	preempt_disable();
-	if (IS_ERR_VALUE(find_symbol(symbol, &owner, NULL, true, false)))
+	if (!find_symbol(symbol, &owner, NULL, true, false))
 		BUG();
 	module_put(owner);
 	preempt_enable();
@@ -1023,7 +1023,7 @@ static inline int check_modstruct_versio
 {
 	const unsigned long *crc;
 
-	if (IS_ERR_VALUE(find_symbol("struct_module", NULL, &crc, true, false)))
+	if (!find_symbol("struct_module", NULL, &crc, true, false))
 		BUG();
 	return check_version(sechdrs, versindex, "struct_module", mod, crc);
 }
@@ -1064,25 +1064,25 @@ static inline int same_magic(const char 
 
 /* Resolve a symbol for this module.  I.e. if we find one, record usage.
    Must be holding module_mutex. */
-static unsigned long resolve_symbol(Elf_Shdr *sechdrs,
-				    unsigned int versindex,
-				    const char *name,
-				    struct module *mod)
+static const struct kernel_symbol *resolve_symbol(Elf_Shdr *sechdrs,
+						  unsigned int versindex,
+						  const char *name,
+						  struct module *mod)
 {
 	struct module *owner;
-	unsigned long ret;
+	const struct kernel_symbol *sym;
 	const unsigned long *crc;
 
-	ret = find_symbol(name, &owner, &crc,
+	sym = find_symbol(name, &owner, &crc,
 			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
-	if (!IS_ERR_VALUE(ret)) {
-		/* use_module can fail due to OOM,
-		   or module initialization or unloading */
+	/* use_module can fail due to OOM,
+	   or module initialization or unloading */
+	if (sym) {
 		if (!check_version(sechdrs, versindex, name, mod, crc) ||
 		    !use_module(mod, owner))
-			ret = -EINVAL;
+			sym = NULL;
 	}
-	return ret;
+	return sym;
 }
 
 /*
@@ -1479,17 +1479,15 @@ void *__symbol_get(const char *symbol)
 void *__symbol_get(const char *symbol)
 {
 	struct module *owner;
-	unsigned long value;
+	const struct kernel_symbol *sym;
 
 	preempt_disable();
-	value = find_symbol(symbol, &owner, NULL, true, true);
-	if (IS_ERR_VALUE(value))
-		value = 0;
-	else if (strong_try_module_get(owner))
-		value = 0;
+	sym = find_symbol(symbol, &owner, NULL, true, true);
+	if (sym && strong_try_module_get(owner))
+		sym = NULL;
 	preempt_enable();
 
-	return (void *)value;
+	return sym ? (void *)sym->value : NULL;
 }
 EXPORT_SYMBOL_GPL(__symbol_get);
 
@@ -1517,8 +1515,7 @@ static int verify_export_symbols(struct 
 
 	for (i = 0; i < ARRAY_SIZE(arr); i++) {
 		for (s = arr[i].sym; s < arr[i].sym + arr[i].num; s++) {
-			if (!IS_ERR_VALUE(find_symbol(s->name, &owner,
-						      NULL, true, false))) {
+			if (find_symbol(s->name, &owner, NULL, true, false)) {
 				printk(KERN_ERR
 				       "%s: exports duplicate symbol %s"
 				       " (owned by %s)\n",
@@ -1542,6 +1539,7 @@ static int simplify_symbols(Elf_Shdr *se
 	unsigned long secbase;
 	unsigned int i, n = sechdrs[symindex].sh_size / sizeof(Elf_Sym);
 	int ret = 0;
+	const struct kernel_symbol *ksym;
 
 	for (i = 1; i < n; i++) {
 		switch (sym[i].st_shndx) {
@@ -1561,13 +1559,14 @@ static int simplify_symbols(Elf_Shdr *se
 			break;
 
 		case SHN_UNDEF:
-			sym[i].st_value
-			  = resolve_symbol(sechdrs, versindex,
-					   strtab + sym[i].st_name, mod);
+			ksym = resolve_symbol(sechdrs, versindex,
+					      strtab + sym[i].st_name, mod);
+			/* Ok if resolved.  */
+			if (ksym) {
+				sym[i].st_value = ksym->value;
+				break;
+			}
 
-			/* Ok if resolved.  */
-			if (!IS_ERR_VALUE(sym[i].st_value))
-				break;
 			/* Ok if weak.  */
 			if (ELF_ST_BIND(sym[i].st_info) == STB_WEAK)
 				break;

