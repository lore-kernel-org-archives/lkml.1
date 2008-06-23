Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbYFWDtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbYFWDtU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 23:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYFWDtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 23:49:12 -0400
Received: from ozlabs.org ([203.10.76.45]:60996 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbYFWDtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 23:49:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] module: make symbol_put_addr() work for all exported symbols
Date: Mon, 23 Jun 2008 13:48:58 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       llipavsky@suse.cz
References: <alpine.LNX.1.10.0806191508020.4593@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0806191508020.4593@jikos.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200806231348.58317.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 June 2008 23:11:54 Jiri Kosina wrote:
> symbol_put_addr() works only for exported function names (symbols present
> in text section). This for example means that
>
>          symbol_put_addr(__symbol_get("any_exported_variable_name"))
>
> triggers a BUG, which really seems wrong.

Hi Jiri,

    You're right, good catch!

> This patch introduces generic lookup_symbol_address(), which performs
> lookup on symbol tables of all modules according to the address, and makes
> symbol_put_addr() use this interface to find the module owner instead.
>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

    It might be better to centralize all these iterators, and create a proper 
iterator function.  Any chance you could rewrite it on top of this patch? 
(Lightly tested)

Thanks!
Rusty.

module: generic each_symbol iterator function

Introduce an each_symbol() iterator to avoid duplicating the knowledge
about the 5 different sections containing symbols.  Currently only
used by find_symbol(), but will be used by symbol_put_addr() too.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 909eac180d25 kernel/module.c
--- a/kernel/module.c	Fri Jun 20 15:56:43 2008 +1000
+++ b/kernel/module.c	Mon Jun 23 13:40:43 2008 +1000
@@ -152,6 +152,167 @@ extern const unsigned long __start___kcr
 #define symversion(base, idx) ((base != NULL) ? ((base) + (idx)) : NULL)
 #endif
 
+struct symsearch {
+	const struct kernel_symbol *start, *stop;
+	const unsigned long *crcs;
+	enum {
+		NOT_GPL_ONLY,
+		GPL_ONLY,
+		WILL_BE_GPL_ONLY,
+	} licence;
+	bool unused;
+};
+
+static bool each_symbol_in_section(const struct symsearch *arr,
+				   unsigned int arrsize,
+				   struct module *owner,
+				   bool (*fn)(const struct symsearch *syms,
+					      struct module *owner,
+					      unsigned int symnum, void *data),
+				   void *data)
+{
+	unsigned int i, j;
+
+	for (j = 0; j < arrsize; j++) {
+		for (i = 0; i < arr[j].stop - arr[j].start; i++)
+			if (fn(&arr[j], owner, i, data))
+				return true;
+	}
+
+	return false;
+}
+
+/* Returns true as soon as fn returns true, otherwise false. */
+static bool each_symbol(bool (*fn)(const struct symsearch *arr,
+				   struct module *owner,
+				   unsigned int symnum, void *data),
+			void *data)
+{
+	struct module *mod;
+	const struct symsearch arr[] = {
+		{ __start___ksymtab, __stop___ksymtab, __start___kcrctab,
+		  NOT_GPL_ONLY, false },
+		{ __start___ksymtab_gpl, __stop___ksymtab_gpl,
+		  __start___kcrctab_gpl,
+		  GPL_ONLY, false },
+		{ __start___ksymtab_gpl_future, __stop___ksymtab_gpl_future,
+		  __start___kcrctab_gpl_future, 
+		  WILL_BE_GPL_ONLY, false },
+		{ __start___ksymtab_unused, __stop___ksymtab_unused,
+		  __start___kcrctab_unused, 
+		  NOT_GPL_ONLY, true },
+		{ __start___ksymtab_unused_gpl, __stop___ksymtab_unused_gpl,
+		  __start___kcrctab_unused_gpl,
+		  GPL_ONLY, true },
+	};
+
+	if (each_symbol_in_section(arr, ARRAY_SIZE(arr), NULL, fn, data))
+		return true;
+
+	list_for_each_entry(mod, &modules, list) {
+		struct symsearch arr[] = {
+			{ mod->syms, mod->syms + mod->num_syms, mod->crcs,
+			  NOT_GPL_ONLY, false },
+			{ mod->gpl_syms, mod->gpl_syms + mod->num_gpl_syms,
+			  mod->gpl_crcs,
+			  GPL_ONLY, false },
+			{ mod->gpl_future_syms,
+			  mod->gpl_future_syms + mod->num_gpl_future_syms,
+			  mod->gpl_future_crcs,
+			  WILL_BE_GPL_ONLY, false },
+			{ mod->unused_syms,
+			  mod->unused_syms + mod->num_unused_syms,
+			  mod->unused_crcs,
+			  NOT_GPL_ONLY, true },
+			{ mod->unused_gpl_syms,
+			  mod->unused_gpl_syms + mod->num_unused_gpl_syms,
+			  mod->unused_gpl_crcs,
+			  GPL_ONLY, true },
+		};
+
+		if (each_symbol_in_section(arr, ARRAY_SIZE(arr), mod, fn, data))
+			return true;
+	}
+	return false;
+}
+
+struct find_symbol_arg
+{
+	/* Input */
+	const char *name;
+	bool gplok;
+	bool warn;
+
+	/* Output */
+	struct module *owner;
+	const unsigned long *crc;
+	unsigned long value;
+};
+
+static bool find_symbol_in_section(const struct symsearch *syms,
+				   struct module *owner,
+				   unsigned int symnum, void *data)
+{
+	struct find_symbol_arg *fsa = data;
+
+	if (strcmp(syms->start[symnum].name, fsa->name) != 0)
+		return false;
+
+	if (!fsa->gplok) {
+		if (syms->licence == GPL_ONLY)
+			return false;
+		if (syms->licence == WILL_BE_GPL_ONLY && fsa->warn) {
+			printk(KERN_WARNING "Symbol %s is being used "
+			       "by a non-GPL module, which will not "
+			       "be allowed in the future\n", fsa->name);
+			printk(KERN_WARNING "Please see the file "
+			       "Documentation/feature-removal-schedule.txt "
+			       "in the kernel source tree for more details.\n");
+		}
+	}
+
+	if (syms->unused && fsa->warn) {
+		printk(KERN_WARNING "Symbol %s is marked as UNUSED, "
+		       "however this module is using it.\n", fsa->name);
+		printk(KERN_WARNING
+		       "This symbol will go away in the future.\n");
+		printk(KERN_WARNING
+		       "Please evalute if this is the right api to use and if "
+		       "it really is, submit a report the linux kernel "
+		       "mailinglist together with submitting your code for "
+		       "inclusion.\n");
+	}
+	
+	fsa->owner = owner;
+	fsa->crc = symversion(syms->crcs, symnum);
+	fsa->value = syms->start[symnum].value;
+	return true;
+}
+
+/* Find a symbol, return value, (optional) crc and (optional) module
+ * which owns it */
+static unsigned long find_symbol(const char *name,
+				 struct module **owner,
+				 const unsigned long **crc,
+				 bool gplok,
+				 bool warn)
+{
+	struct find_symbol_arg fsa;
+
+	fsa.name = name;
+	fsa.gplok = gplok;
+	fsa.warn = warn;
+
+	if (each_symbol(find_symbol_in_section, &fsa)) {
+		*owner = fsa.owner;
+		*crc = fsa.crc;
+		return fsa.value;
+	}
+
+	DEBUGP("Failed to find symbol %s\n", name);
+	return -ENOENT;
+}
+
 /* lookup symbol in given range of kernel_symbols */
 static const struct kernel_symbol *lookup_symbol(const char *name,
 	const struct kernel_symbol *start,
@@ -162,144 +323,6 @@ static const struct kernel_symbol *looku
 		if (strcmp(ks->name, name) == 0)
 			return ks;
 	return NULL;
-}
-
-static bool always_ok(bool gplok, bool warn, const char *name)
-{
-	return true;
-}
-
-static bool printk_unused_warning(bool gplok, bool warn, const char *name)
-{
-	if (warn) {
-		printk(KERN_WARNING "Symbol %s is marked as UNUSED, "
-		       "however this module is using it.\n", name);
-		printk(KERN_WARNING
-		       "This symbol will go away in the future.\n");
-		printk(KERN_WARNING
-		       "Please evalute if this is the right api to use and if "
-		       "it really is, submit a report the linux kernel "
-		       "mailinglist together with submitting your code for "
-		       "inclusion.\n");
-	}
-	return true;
-}
-
-static bool gpl_only_unused_warning(bool gplok, bool warn, const char *name)
-{
-	if (!gplok)
-		return false;
-	return printk_unused_warning(gplok, warn, name);
-}
-
-static bool gpl_only(bool gplok, bool warn, const char *name)
-{
-	return gplok;
-}
-
-static bool warn_if_not_gpl(bool gplok, bool warn, const char *name)
-{
-	if (!gplok && warn) {
-		printk(KERN_WARNING "Symbol %s is being used "
-		       "by a non-GPL module, which will not "
-		       "be allowed in the future\n", name);
-		printk(KERN_WARNING "Please see the file "
-		       "Documentation/feature-removal-schedule.txt "
-		       "in the kernel source tree for more details.\n");
-	}
-	return true;
-}
-
-struct symsearch {
-	const struct kernel_symbol *start, *stop;
-	const unsigned long *crcs;
-	bool (*check)(bool gplok, bool warn, const char *name);
-};
-
-/* Look through this array of symbol tables for a symbol match which
- * passes the check function. */
-static const struct kernel_symbol *search_symarrays(const struct symsearch *arr,
-						    unsigned int num,
-						    const char *name,
-						    bool gplok,
-						    bool warn,
-						    const unsigned long **crc)
-{
-	unsigned int i;
-	const struct kernel_symbol *ks;
-
-	for (i = 0; i < num; i++) {
-		ks = lookup_symbol(name, arr[i].start, arr[i].stop);
-		if (!ks || !arr[i].check(gplok, warn, name))
-			continue;
-
-		if (crc)
-			*crc = symversion(arr[i].crcs, ks - arr[i].start);
-		return ks;
-	}
-	return NULL;
-}
-
-/* Find a symbol, return value, (optional) crc and (optional) module
- * which owns it */
-static unsigned long find_symbol(const char *name,
-				 struct module **owner,
-				 const unsigned long **crc,
-				 bool gplok,
-				 bool warn)
-{
-	struct module *mod;
-	const struct kernel_symbol *ks;
-	const struct symsearch arr[] = {
-		{ __start___ksymtab, __stop___ksymtab, __start___kcrctab,
-		  always_ok },
-		{ __start___ksymtab_gpl, __stop___ksymtab_gpl,
-		  __start___kcrctab_gpl, gpl_only },
-		{ __start___ksymtab_gpl_future, __stop___ksymtab_gpl_future,
-		  __start___kcrctab_gpl_future, warn_if_not_gpl },
-		{ __start___ksymtab_unused, __stop___ksymtab_unused,
-		  __start___kcrctab_unused, printk_unused_warning },
-		{ __start___ksymtab_unused_gpl, __stop___ksymtab_unused_gpl,
-		  __start___kcrctab_unused_gpl, gpl_only_unused_warning },
-	};
-
-	/* Core kernel first. */
-	ks = search_symarrays(arr, ARRAY_SIZE(arr), name, gplok, warn, crc);
-	if (ks) {
-		if (owner)
-			*owner = NULL;
-		return ks->value;
-	}
-
-	/* Now try modules. */
-	list_for_each_entry(mod, &modules, list) {
-		struct symsearch arr[] = {
-			{ mod->syms, mod->syms + mod->num_syms, mod->crcs,
-			  always_ok },
-			{ mod->gpl_syms, mod->gpl_syms + mod->num_gpl_syms,
-			  mod->gpl_crcs, gpl_only },
-			{ mod->gpl_future_syms,
-			  mod->gpl_future_syms + mod->num_gpl_future_syms,
-			  mod->gpl_future_crcs, warn_if_not_gpl },
-			{ mod->unused_syms,
-			  mod->unused_syms + mod->num_unused_syms,
-			  mod->unused_crcs, printk_unused_warning },
-			{ mod->unused_gpl_syms,
-			  mod->unused_gpl_syms + mod->num_unused_gpl_syms,
-			  mod->unused_gpl_crcs, gpl_only_unused_warning },
-		};
-
-		ks = search_symarrays(arr, ARRAY_SIZE(arr),
-				      name, gplok, warn, crc);
-		if (ks) {
-			if (owner)
-				*owner = mod;
-			return ks->value;
-		}
-	}
-
-	DEBUGP("Failed to find symbol %s\n", name);
-	return -ENOENT;
 }
 
 /* Search for module by name: must hold module_mutex. */
