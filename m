Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbZIVNjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbZIVNjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbZIVNjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:39:08 -0400
Received: from mxout-08.mxes.net ([216.86.168.183]:47069 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbZIVNiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:38:54 -0400
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linux-modules@vger.org, Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 4/4] module: speed up find_symbol() using binary search on the builtin symbol tables
Date: Tue, 22 Sep 2009 14:38:38 +0100
Message-Id: <1253626718-18887-5-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1253626718-18887-1-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <1253626718-18887-1-git-send-email-alan-jenkins@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The builtin symbol tables are now sorted, so we can use a binary
search.

The symbol tables in modules are still unsorted and require linear
searching as before. But since the generic each_symbol() is removed,
the code size only goes up 8 bytes overall on i386.

On my EeePC 701, coldplug is mainly cpu bound and takes 1.5 seconds
during boot. perf showed this change eliminated 20% of cpu cycles during
coldplug, saving 0.3 seconds of real time.

These savings may not be representative since my config is not very well
tuned.  The numbers above represent the loading of 35 modules,
referencing a total of 441 symbols.  Nevertheless, it shows why I think
this is worth doing.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 kernel/module.c |  209 ++++++++++++++++++++++++++++++-------------------------
 1 files changed, 113 insertions(+), 96 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index b24fc55..c78481d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -203,31 +203,38 @@ struct symsearch {
 #define symversion(base, idx) ((base != NULL) ? ((base) + (idx)) : NULL)
 #endif
 
-static bool each_symbol_in_section(const struct symsearch *arr,
-				   unsigned int arrsize,
-				   struct module *owner,
-				   bool (*fn)(const struct symsearch *syms,
-					      struct module *owner,
-					      unsigned int symnum, void *data),
-				   void *data)
-{
-	unsigned int i, j;
-
-	for (j = 0; j < arrsize; j++) {
-		for (i = 0; i < arr[j].stop - arr[j].start; i++)
-			if (fn(&arr[j], owner, i, data))
-				return true;
+/* binary search on sorted symbols */
+static bool find_symbol_in_kernel_section(const struct symsearch *syms,
+					  const char *name,
+					  unsigned int *symnum)
+{
+	int lo = 0, hi = syms->stop - syms->start - 1;
+	int mid, cmp;
+
+	while (lo <= hi) {
+		mid = (lo + hi) / 2;
+		cmp = strcmp(syms->start[mid].name, name);
+		if (cmp == 0) {
+			*symnum = mid;
+			return true;
+		}
+		else if (cmp < 0)
+			hi = mid - 1;
+		else
+			lo = mid + 1;
 	}
 
 	return false;
 }
 
-/* Returns true as soon as fn returns true, otherwise false. */
-static bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
-			    unsigned int symnum, void *data), void *data)
+
+static bool find_symbol_in_kernel(const char *name,
+				  struct symsearch *sym,
+				  unsigned int *symnum)
 {
-	struct module *mod;
-	const struct symsearch arr[] = {
+	unsigned int j;
+
+	struct symsearch arr[] = {
 		{ __start___ksymtab, __stop___ksymtab, __start___kcrctab,
 		  NOT_GPL_ONLY, false },
 		{ __start___ksymtab_gpl, __stop___ksymtab_gpl,
@@ -246,66 +253,101 @@ static bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *o
 #endif
 	};
 
-	if (each_symbol_in_section(arr, ARRAY_SIZE(arr), NULL, fn, data))
-		return true;
+	for (j = 0; j < ARRAY_SIZE(arr); j++)
+		if (find_symbol_in_kernel_section(&arr[j], name, symnum)) {
+			*sym = arr[j];
+			return true;
+		}
 
-	list_for_each_entry_rcu(mod, &modules, list) {
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
+	return false;
+}
+
+/* linear search on unsorted symbols */
+static bool find_symbol_in_module_section(const struct symsearch *syms,
+					  const char *name,
+					  unsigned int *symnum)
+{
+	unsigned int i;
+
+	for (i = 0; i < syms->stop - syms->start; i++)
+		if (strcmp(syms->start[i].name, name) == 0) {
+			*symnum = i;
+			return true;
+		}
+
+	return false;
+}
+
+
+static bool find_symbol_in_module(struct module *mod,
+				  const char *name,
+				  struct symsearch *sym,
+				  unsigned int *symnum)
+{
+	unsigned int j;
+
+	struct symsearch arr[] = {
+		{ mod->syms, mod->syms + mod->num_syms, mod->crcs,
+			NOT_GPL_ONLY, false },
+		{ mod->gpl_syms, mod->gpl_syms + mod->num_gpl_syms,
+			mod->gpl_crcs,
+			GPL_ONLY, false },
+		{ mod->gpl_future_syms,
+			mod->gpl_future_syms + mod->num_gpl_future_syms,
+			mod->gpl_future_crcs,
+			WILL_BE_GPL_ONLY, false },
 #ifdef CONFIG_UNUSED_SYMBOLS
-			{ mod->unused_syms,
-			  mod->unused_syms + mod->num_unused_syms,
-			  mod->unused_crcs,
-			  NOT_GPL_ONLY, true },
-			{ mod->unused_gpl_syms,
-			  mod->unused_gpl_syms + mod->num_unused_gpl_syms,
-			  mod->unused_gpl_crcs,
-			  GPL_ONLY, true },
+		{ mod->unused_syms,
+			mod->unused_syms + mod->num_unused_syms,
+			mod->unused_crcs,
+			NOT_GPL_ONLY, true },
+		{ mod->unused_gpl_syms,
+			mod->unused_gpl_syms + mod->num_unused_gpl_syms,
+			mod->unused_gpl_crcs,
+			GPL_ONLY, true },
 #endif
-		};
+	};
 
-		if (each_symbol_in_section(arr, ARRAY_SIZE(arr), mod, fn, data))
+	for (j = 0; j < ARRAY_SIZE(arr); j++) {
+		if (find_symbol_in_module_section(&arr[j], name, symnum)) {
+			*sym = arr[j];
 			return true;
+		}
 	}
+
 	return false;
 }
 
-struct find_symbol_arg {
-	/* Input */
-	const char *name;
-	bool gplok;
-	bool warn;
+/* Find a symbol and return it, along with, (optional) crc and
+ * (optional) module which owns it */
+const struct kernel_symbol *find_symbol(const char *name,
+					struct module **owner,
+					const unsigned long **crc,
+					bool gplok,
+					bool warn)
+{
+	struct symsearch syms;
+	unsigned int symnum;
+	struct module *mod = NULL;
 
-	/* Output */
-	struct module *owner;
-	const unsigned long *crc;
-	const struct kernel_symbol *sym;
-};
+	if (find_symbol_in_kernel(name, &syms, &symnum))
+		goto found;
 
-static bool find_symbol_in_section(const struct symsearch *syms,
-				   struct module *owner,
-				   unsigned int symnum, void *data)
-{
-	struct find_symbol_arg *fsa = data;
+	list_for_each_entry_rcu(mod, &modules, list)
+		if (find_symbol_in_module(mod, name, &syms, &symnum))
+			goto found;
 
-	if (strcmp(syms->start[symnum].name, fsa->name) != 0)
-		return false;
+	DEBUGP("Failed to find symbol %s\n", name);
+	return NULL;
 
-	if (!fsa->gplok) {
-		if (syms->licence == GPL_ONLY)
-			return false;
-		if (syms->licence == WILL_BE_GPL_ONLY && fsa->warn) {
+found:
+	if (!gplok) {
+		if (syms.licence == GPL_ONLY)
+			return NULL;
+		if (syms.licence == WILL_BE_GPL_ONLY && warn) {
 			printk(KERN_WARNING "Symbol %s is being used "
 			       "by a non-GPL module, which will not "
-			       "be allowed in the future\n", fsa->name);
+			       "be allowed in the future\n", name);
 			printk(KERN_WARNING "Please see the file "
 			       "Documentation/feature-removal-schedule.txt "
 			       "in the kernel source tree for more details.\n");
@@ -313,9 +355,9 @@ static bool find_symbol_in_section(const struct symsearch *syms,
 	}
 
 #ifdef CONFIG_UNUSED_SYMBOLS
-	if (syms->unused && fsa->warn) {
+	if (syms.unused && warn) {
 		printk(KERN_WARNING "Symbol %s is marked as UNUSED, "
-		       "however this module is using it.\n", fsa->name);
+		       "however this module is using it.\n", name);
 		printk(KERN_WARNING
 		       "This symbol will go away in the future.\n");
 		printk(KERN_WARNING
@@ -326,36 +368,11 @@ static bool find_symbol_in_section(const struct symsearch *syms,
 	}
 #endif
 
-	fsa->owner = owner;
-	fsa->crc = symversion(syms->crcs, symnum);
-	fsa->sym = &syms->start[symnum];
-	return true;
-}
-
-/* Find a symbol and return it, along with, (optional) crc and
- * (optional) module which owns it */
-const struct kernel_symbol *find_symbol(const char *name,
-					struct module **owner,
-					const unsigned long **crc,
-					bool gplok,
-					bool warn)
-{
-	struct find_symbol_arg fsa;
-
-	fsa.name = name;
-	fsa.gplok = gplok;
-	fsa.warn = warn;
-
-	if (each_symbol(find_symbol_in_section, &fsa)) {
-		if (owner)
-			*owner = fsa.owner;
-		if (crc)
-			*crc = fsa.crc;
-		return fsa.sym;
-	}
-
-	DEBUGP("Failed to find symbol %s\n", name);
-	return NULL;
+	if (owner)
+		*owner = mod;
+	if (crc)
+		*crc = symversion(syms.crcs, symnum);
+	return &syms.start[symnum];
 }
 EXPORT_SYMBOL_GPL(find_symbol);
 
-- 
1.6.3.2

