Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbYIMFTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbYIMFTX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 01:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbYIMFR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 01:17:57 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40806 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388AbYIMFR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 01:17:56 -0400
From: Jeffrey Brian Arnold <jbarnold@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [RFC v2 PATCH 1/9] Ksplice: Make find_symbol return a struct kernel_symbol
Date: Sat, 13 Sep 2008 01:14:37 -0400
Message-Id: <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221282535.git.jbarnold@mit.edu>
X-Mailer: git-send-email 1.6.0
In-Reply-To: <1221282885-1150-1-git-send-email-jbarnold@mit.edu>
References: <1221282885-1150-1-git-send-email-jbarnold@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Abbott <tabbott@mit.edu>

Ksplice needs access to the kernel_symbol structure in order to
support modifications to the exported symbol table.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
---
 kernel/module.c |   80 ++++++++++++++++++++++++++----------------------------
 1 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 6cedfc7..8954556 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -254,7 +254,7 @@ struct find_symbol_arg {
 	/* Output */
 	struct module *owner;
 	const unsigned long *crc;
-	unsigned long value;
+	const struct kernel_symbol *sym;
 };
 
 static bool find_symbol_in_section(const struct symsearch *syms,
@@ -295,17 +295,17 @@ static bool find_symbol_in_section(const struct symsearch *syms,
 
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
 
@@ -318,11 +318,11 @@ static unsigned long find_symbol(const char *name,
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
@@ -819,7 +819,7 @@ void __symbol_put(const char *symbol)
 	struct module *owner;
 
 	preempt_disable();
-	if (IS_ERR_VALUE(find_symbol(symbol, &owner, NULL, true, false)))
+	if (find_symbol(symbol, &owner, NULL, true, false) == NULL)
 		BUG();
 	module_put(owner);
 	preempt_enable();
@@ -982,7 +982,7 @@ static inline int check_modstruct_version(Elf_Shdr *sechdrs,
 {
 	const unsigned long *crc;
 
-	if (IS_ERR_VALUE(find_symbol("struct_module", NULL, &crc, true, false)))
+	if (find_symbol("struct_module", NULL, &crc, true, false) == NULL)
 		BUG();
 	return check_version(sechdrs, versindex, "struct_module", mod, crc);
 }
@@ -1023,25 +1023,23 @@ static inline int same_magic(const char *amagic, const char *bmagic,
 
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
 			  !(mod->taints & TAINT_PROPRIETARY_MODULE), true);
-	if (!IS_ERR_VALUE(ret)) {
-		/* use_module can fail due to OOM,
-		   or module initialization or unloading */
-		if (!check_version(sechdrs, versindex, name, mod, crc) ||
-		    !use_module(mod, owner))
-			ret = -EINVAL;
-	}
-	return ret;
+	/* use_module can fail due to OOM,
+	   or module initialization or unloading */
+	if (!check_version(sechdrs, versindex, name, mod, crc) ||
+	    !use_module(mod, owner))
+		sym = NULL;
+	return sym;
 }
 
 /*
@@ -1445,17 +1443,15 @@ static void free_module(struct module *mod)
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
+	if (sym != NULL && strong_try_module_get(owner))
+		sym = NULL;
 	preempt_enable();
 
-	return (void *)value;
+	return sym == NULL ? (void *)0 : (void *)sym->value;
 }
 EXPORT_SYMBOL_GPL(__symbol_get);
 
@@ -1483,8 +1479,8 @@ static int verify_export_symbols(struct module *mod)
 
 	for (i = 0; i < ARRAY_SIZE(arr); i++) {
 		for (s = arr[i].sym; s < arr[i].sym + arr[i].num; s++) {
-			if (!IS_ERR_VALUE(find_symbol(s->name, &owner,
-						      NULL, true, false))) {
+			if (find_symbol(s->name, &owner, NULL, true, false)
+			    != NULL) {
 				printk(KERN_ERR
 				       "%s: exports duplicate symbol %s"
 				       " (owned by %s)\n",
@@ -1508,6 +1504,7 @@ static int simplify_symbols(Elf_Shdr *sechdrs,
 	unsigned long secbase;
 	unsigned int i, n = sechdrs[symindex].sh_size / sizeof(Elf_Sym);
 	int ret = 0;
+	const struct kernel_symbol *ksym;
 
 	for (i = 1; i < n; i++) {
 		switch (sym[i].st_shndx) {
@@ -1527,13 +1524,14 @@ static int simplify_symbols(Elf_Shdr *sechdrs,
 			break;
 
 		case SHN_UNDEF:
-			sym[i].st_value
-			  = resolve_symbol(sechdrs, versindex,
-					   strtab + sym[i].st_name, mod);
-
+			ksym = resolve_symbol(sechdrs, versindex,
+					      strtab + sym[i].st_name, mod);
 			/* Ok if resolved.  */
-			if (!IS_ERR_VALUE(sym[i].st_value))
+			if (ksym != NULL) {
+				sym[i].st_value = ksym->value;
 				break;
+			}
+
 			/* Ok if weak.  */
 			if (ELF_ST_BIND(sym[i].st_info) == STB_WEAK)
 				break;
-- 
1.5.4.3

