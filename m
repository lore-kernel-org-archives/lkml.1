Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbYCTF1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbYCTF1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 01:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbYCTF1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 01:27:10 -0400
Received: from ozlabs.org ([203.10.76.45]:49491 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbYCTF1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 01:27:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: [PATCH 1/2] module: neaten __find_symbol, rename to find_symbol.
Date: Thu, 20 Mar 2008 16:25:45 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <47D8FC21.76E4.0078.0@novell.com> <200803180936.04586.rusty@rustcorp.com.au> <200803181129.32399.rusty@rustcorp.com.au>
In-Reply-To: <200803181129.32399.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803201625.45920.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__find_symbol() has grown over time: there are now 5 different arrays
of symbols it traverses.  It also shouldn't print out a warning on
some calls (ie. verify_symbol which simply checks for name clashes,
and __symbol_put which checks for bugs).

1) Rename to find_symbol: no need for underscores.
2) Use bool and add "warn" parameter to suppress warnings.
3) Make table-driven rather than open coded.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |  244 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 122 insertions(+), 122 deletions(-)

diff -r 08e60e418777 kernel/module.c
--- a/kernel/module.c	Tue Mar 18 11:30:06 2008 +1100
+++ b/kernel/module.c	Tue Mar 18 14:15:32 2008 +1100
@@ -165,131 +165,136 @@ static const struct kernel_symbol *looku
 	return NULL;
 }
 
-static void printk_unused_warning(const char *name)
+static bool always_ok(bool gplok, bool warn, const char *name)
 {
-	printk(KERN_WARNING "Symbol %s is marked as UNUSED, "
-		"however this module is using it.\n", name);
-	printk(KERN_WARNING "This symbol will go away in the future.\n");
-	printk(KERN_WARNING "Please evalute if this is the right api to use, "
-		"and if it really is, submit a report the linux kernel "
-		"mailinglist together with submitting your code for "
-		"inclusion.\n");
+	return true;
 }
 
-/* Find a symbol, return value, crc and module which owns it */
-static unsigned long __find_symbol(const char *name,
-				   struct module **owner,
-				   const unsigned long **crc,
-				   int gplok)
+static bool printk_unused_warning(bool gplok, bool warn, const char *name)
+{
+	if (warn) {
+		printk(KERN_WARNING "Symbol %s is marked as UNUSED, "
+		       "however this module is using it.\n", name);
+		printk(KERN_WARNING
+		       "This symbol will go away in the future.\n");
+		printk(KERN_WARNING
+		       "Please evalute if this is the right api to use and if "
+		       "it really is, submit a report the linux kernel "
+		       "mailinglist together with submitting your code for "
+		       "inclusion.\n");
+	}
+	return true;
+}
+
+static bool gpl_only_unused_warning(bool gplok, bool warn, const char *name)
+{
+	if (!gplok)
+		return false;
+	return printk_unused_warning(gplok, warn, name);
+}
+
+static bool gpl_only(bool gplok, bool warn, const char *name)
+{
+	return gplok;
+}
+
+static bool warn_if_not_gpl(bool gplok, bool warn, const char *name)
+{
+	if (!gplok && warn) {
+		printk(KERN_WARNING "Symbol %s is being used "
+		       "by a non-GPL module, which will not "
+		       "be allowed in the future\n", name);
+		printk(KERN_WARNING "Please see the file "
+		       "Documentation/feature-removal-schedule.txt "
+		       "in the kernel source tree for more details.\n");
+	}
+	return true;
+}
+
+struct symsearch {
+	const struct kernel_symbol *start, *stop;
+	bool (*check)(bool gplok, bool warn, const char *name);
+};
+
+/* Look through this array of symbol tables for a symbol match which
+ * passes the check function. */
+static const struct kernel_symbol *search_symarrays(const struct symsearch *arr,
+						    unsigned int num,
+						    const char *name,
+						    bool gplok,
+						    bool warn,
+						    const unsigned long **crc)
+{
+	unsigned int i;
+	const struct kernel_symbol *ks;
+
+	for (i = 0; i < num; i++) {
+		ks = lookup_symbol(name, arr[i].start, arr[i].stop);
+		if (!ks || !arr[i].check(gplok, warn, name))
+			continue;
+
+		if (crc)
+			*crc = symversion(arr[i].start, ks - arr[i].start);
+		return ks;
+	}
+	return NULL;
+}
+
+/* Find a symbol, return value, (optional) crc and (optional) module
+ * which owns it */
+static unsigned long find_symbol(const char *name,
+				 struct module **owner,
+				 const unsigned long **crc,
+				 bool gplok,
+				 bool warn)
 {
 	struct module *mod;
 	const struct kernel_symbol *ks;
+	const struct symsearch arr[] = {
+		{ __start___ksymtab, __stop___ksymtab, always_ok },
+		{ __start___ksymtab_gpl, __stop___ksymtab_gpl, gpl_only },
+		{ __start___ksymtab_gpl_future, __stop___ksymtab_gpl_future,
+		  warn_if_not_gpl },
+		{ __start___ksymtab_unused, __stop___ksymtab_unused,
+		  printk_unused_warning },
+		{ __start___ksymtab_unused_gpl, __stop___ksymtab_unused_gpl,
+		  gpl_only_unused_warning },
+	};
 
 	/* Core kernel first. */
-	*owner = NULL;
-	ks = lookup_symbol(name, __start___ksymtab, __stop___ksymtab);
+	ks = search_symarrays(arr, ARRAY_SIZE(arr), name, gplok, warn, crc);
 	if (ks) {
-		*crc = symversion(__start___kcrctab, (ks - __start___ksymtab));
-		return ks->value;
-	}
-	if (gplok) {
-		ks = lookup_symbol(name, __start___ksymtab_gpl,
-					 __stop___ksymtab_gpl);
-		if (ks) {
-			*crc = symversion(__start___kcrctab_gpl,
-					  (ks - __start___ksymtab_gpl));
-			return ks->value;
-		}
-	}
-	ks = lookup_symbol(name, __start___ksymtab_gpl_future,
-				 __stop___ksymtab_gpl_future);
-	if (ks) {
-		if (!gplok) {
-			printk(KERN_WARNING "Symbol %s is being used "
-			       "by a non-GPL module, which will not "
-			       "be allowed in the future\n", name);
-			printk(KERN_WARNING "Please see the file "
-			       "Documentation/feature-removal-schedule.txt "
-			       "in the kernel source tree for more "
-			       "details.\n");
-		}
-		*crc = symversion(__start___kcrctab_gpl_future,
-				  (ks - __start___ksymtab_gpl_future));
-		return ks->value;
-	}
-
-	ks = lookup_symbol(name, __start___ksymtab_unused,
-				 __stop___ksymtab_unused);
-	if (ks) {
-		printk_unused_warning(name);
-		*crc = symversion(__start___kcrctab_unused,
-				  (ks - __start___ksymtab_unused));
-		return ks->value;
-	}
-
-	if (gplok)
-		ks = lookup_symbol(name, __start___ksymtab_unused_gpl,
-				 __stop___ksymtab_unused_gpl);
-	if (ks) {
-		printk_unused_warning(name);
-		*crc = symversion(__start___kcrctab_unused_gpl,
-				  (ks - __start___ksymtab_unused_gpl));
+		if (owner)
+			*owner = NULL;
 		return ks->value;
 	}
 
 	/* Now try modules. */
 	list_for_each_entry(mod, &modules, list) {
-		*owner = mod;
-		ks = lookup_symbol(name, mod->syms, mod->syms + mod->num_syms);
+		struct symsearch arr[] = {
+			{ mod->syms, mod->syms + mod->num_syms, always_ok },
+			{ mod->gpl_syms, mod->gpl_syms + mod->num_gpl_syms,
+			  gpl_only },
+			{ mod->gpl_future_syms,
+			  mod->gpl_future_syms + mod->num_gpl_future_syms,
+			  warn_if_not_gpl },
+			{ mod->unused_syms,
+			  mod->unused_syms + mod->num_unused_syms,
+			  printk_unused_warning },
+			{ mod->unused_gpl_syms,
+			  mod->unused_gpl_syms + mod->num_unused_gpl_syms,
+			  gpl_only_unused_warning },
+		};
+
+		ks = search_symarrays(arr, ARRAY_SIZE(arr),
+				      name, gplok, warn, crc);
 		if (ks) {
-			*crc = symversion(mod->crcs, (ks - mod->syms));
-			return ks->value;
-		}
-
-		if (gplok) {
-			ks = lookup_symbol(name, mod->gpl_syms,
-					   mod->gpl_syms + mod->num_gpl_syms);
-			if (ks) {
-				*crc = symversion(mod->gpl_crcs,
-						  (ks - mod->gpl_syms));
-				return ks->value;
-			}
-		}
-		ks = lookup_symbol(name, mod->unused_syms, mod->unused_syms + mod->num_unused_syms);
-		if (ks) {
-			printk_unused_warning(name);
-			*crc = symversion(mod->unused_crcs, (ks - mod->unused_syms));
-			return ks->value;
-		}
-
-		if (gplok) {
-			ks = lookup_symbol(name, mod->unused_gpl_syms,
-					   mod->unused_gpl_syms + mod->num_unused_gpl_syms);
-			if (ks) {
-				printk_unused_warning(name);
-				*crc = symversion(mod->unused_gpl_crcs,
-						  (ks - mod->unused_gpl_syms));
-				return ks->value;
-			}
-		}
-		ks = lookup_symbol(name, mod->gpl_future_syms,
-				   (mod->gpl_future_syms +
-				    mod->num_gpl_future_syms));
-		if (ks) {
-			if (!gplok) {
-				printk(KERN_WARNING "Symbol %s is being used "
-				       "by a non-GPL module, which will not "
-				       "be allowed in the future\n", name);
-				printk(KERN_WARNING "Please see the file "
-				       "Documentation/feature-removal-schedule.txt "
-				       "in the kernel source tree for more "
-				       "details.\n");
-			}
-			*crc = symversion(mod->gpl_future_crcs,
-					  (ks - mod->gpl_future_syms));
+			if (owner)
+				*owner = mod;
 			return ks->value;
 		}
 	}
+
 	DEBUGP("Failed to find symbol %s\n", name);
 	return -ENOENT;
 }
@@ -778,10 +783,9 @@ void __symbol_put(const char *symbol)
 void __symbol_put(const char *symbol)
 {
 	struct module *owner;
-	const unsigned long *crc;
 
 	preempt_disable();
-	if (IS_ERR_VALUE(__find_symbol(symbol, &owner, &crc, 1)))
+	if (IS_ERR_VALUE(find_symbol(symbol, &owner, NULL, true, false)))
 		BUG();
 	module_put(owner);
 	preempt_enable();
@@ -925,13 +929,10 @@ static inline int check_modstruct_versio
 					  struct module *mod)
 {
 	const unsigned long *crc;
-	struct module *owner;
 
-	if (IS_ERR_VALUE(__find_symbol("struct_module",
-						&owner, &crc, 1)))
+	if (IS_ERR_VALUE(find_symbol("struct_module", NULL, &crc, true, false)))
 		BUG();
-	return check_version(sechdrs, versindex, "struct_module", mod,
-			     crc);
+	return check_version(sechdrs, versindex, "struct_module", mod, crc);
 }
 
 /* First part is kernel version, which we ignore. */
@@ -975,8 +976,8 @@ static unsigned long resolve_symbol(Elf_
 	unsigned long ret;
 	const unsigned long *crc;
 
-	ret = __find_symbol(name, &owner, &crc,
-			!(mod->taints & TAINT_PROPRIETARY_MODULE));
+	ret = find_symbol(name, &owner, &crc,
+			  !(mod->taints & TAINT_PROPRIETARY_MODULE), true);
 	if (!IS_ERR_VALUE(ret)) {
 		/* use_module can fail due to OOM,
 		   or module initialization or unloading */
@@ -1377,10 +1378,9 @@ void *__symbol_get(const char *symbol)
 {
 	struct module *owner;
 	unsigned long value;
-	const unsigned long *crc;
 
 	preempt_disable();
-	value = __find_symbol(symbol, &owner, &crc, 1);
+	value = find_symbol(symbol, &owner, NULL, true, true);
 	if (IS_ERR_VALUE(value))
 		value = 0;
 	else if (strong_try_module_get(owner))
@@ -1403,16 +1403,16 @@ static int verify_export_symbols(struct 
 	const unsigned long *crc;
 
 	for (i = 0; i < mod->num_syms; i++)
-		if (!IS_ERR_VALUE(__find_symbol(mod->syms[i].name,
-							&owner, &crc, 1))) {
+		if (!IS_ERR_VALUE(find_symbol(mod->syms[i].name,
+					      &owner, &crc, true, false))) {
 			name = mod->syms[i].name;
 			ret = -ENOEXEC;
 			goto dup;
 		}
 
 	for (i = 0; i < mod->num_gpl_syms; i++)
-		if (!IS_ERR_VALUE(__find_symbol(mod->gpl_syms[i].name,
-							&owner, &crc, 1))) {
+		if (!IS_ERR_VALUE(find_symbol(mod->gpl_syms[i].name,
+					      &owner, &crc, true, false))) {
 			name = mod->gpl_syms[i].name;
 			ret = -ENOEXEC;
 			goto dup;
