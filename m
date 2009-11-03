Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbZKCKJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbZKCKJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756499AbZKCKI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:08:59 -0500
Received: from mxout-08.mxes.net ([216.86.168.183]:22381 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbZKCKIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:08:55 -0500
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: greg@kroah.com
Cc: linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 09/10] module: speed up find_symbol() using binary search on the builtin symbol tables
Date: Tue,  3 Nov 2009 10:06:21 +0000
Message-Id: <1257242782-10496-10-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
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
 kernel/module.c |  144 ++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 91 insertions(+), 53 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 38a2859..122c10d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -55,6 +55,7 @@
 #include <linux/async.h>
 #include <linux/percpu.h>
 #include <linux/kmemleak.h>
+#include <linux/bsearch.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
@@ -272,36 +273,98 @@ bool each_symbol(each_symbol_fn_t *fn, void *data)
 }
 EXPORT_SYMBOL_GPL(each_symbol);
 
-struct find_symbol_arg {
-	/* Input */
-	const char *name;
-	bool gplok;
-	bool warn;
+static int symbol_compare(const void *key, const void *elt)
+{
+	const char *str = key;
+	const struct kernel_symbol *sym = elt;
+	return strcmp(str, sym->name);
+}
 
-	/* Output */
+/* binary search on sorted symbols */
+static const struct kernel_symbol *find_symbol_in_kernel(
+	const char *name,
+	enum export_type *t,
+	const unsigned long **crc)
+{
+	struct kernel_symbol *sym;
+	enum export_type type;
+	unsigned int i;
+
+	for (type = 0; type < EXPORT_TYPE_MAX; type++) {
+		sym = bsearch(name, ksymtab[type].syms, ksymtab[type].num_syms,
+			      sizeof(struct kernel_symbol), symbol_compare);
+		if (sym) {
+			i = sym - ksymtab[type].syms;
+			*crc = symversion(ksymtab[type].crcs, i);
+			*t = type;
+			return sym;
+		}
+	}
+
+	return NULL;
+}
+
+/* linear search on unsorted symbols */
+static const struct kernel_symbol *find_symbol_in_module(
+	struct module *mod,
+	const char *name,
+	enum export_type *t,
+	const unsigned long **crc)
+{
+	struct ksymtab *symtab = mod->syms;
 	const struct kernel_symbol *sym;
-	const unsigned long *crc;
-	struct module *owner;
-};
+	enum export_type type;
+	unsigned int i;
 
-static bool find_symbol_in_section(enum export_type type,
-				   const struct kernel_symbol *sym,
-				   const unsigned long *crc,
-				   struct module *owner,
-				   void *data)
+	for (type = 0; type < EXPORT_TYPE_MAX; type++) {
+		for (i = 0; i < symtab[type].num_syms; i++) {
+			sym = &symtab[type].syms[i];
+
+			if (strcmp(sym->name, name) == 0) {
+				*crc = symversion(symtab[type].crcs, i);
+				*t = type;
+				return sym;
+			}
+		}
+	}
+
+	return NULL;
+}
+
+/* Find a symbol and return it, along with, (optional) crc and
+ * (optional) module which owns it */
+const struct kernel_symbol *find_symbol(const char *name,
+					struct module **owner,
+					const unsigned long **crc,
+					bool gplok,
+					bool warn)
 {
-	struct find_symbol_arg *fsa = data;
+	struct module *mod = NULL;
+	const struct kernel_symbol *sym;
+	enum export_type type;
+	const unsigned long *crc_value;
 
-	if (strcmp(sym->name, fsa->name) != 0)
-		return false;
+	sym = find_symbol_in_kernel(name, &type, &crc_value);
+	if (sym)
+		goto found;
+
+	list_for_each_entry_rcu(mod, &modules, list) {
+		sym = find_symbol_in_module(mod, name, &type, &crc_value);
+		if (sym)
+			goto found;
+	}
+
+	DEBUGP("Failed to find symbol %s\n", name);
+	return NULL;
 
-	if (!fsa->gplok) {
+found:
+	if (!gplok) {
 		if (export_is_gpl_only(type))
-			return false;
-		if (export_is_gpl_future(type) && fsa->warn) {
+			return NULL;
+		if (export_is_gpl_future(type) && warn) {
 			printk(KERN_WARNING "Symbol %s is being used "
 			       "by a non-GPL module, which will not "
-			       "be allowed in the future\n", fsa->name);
+			       "be allowed in the future\n", name);
 			printk(KERN_WARNING "Please see the file "
 			       "Documentation/feature-removal-schedule.txt "
 			       "in the kernel source tree for more details.\n");
@@ -309,9 +372,9 @@ static bool find_symbol_in_section(enum export_type type,
 	}
 
 #ifdef CONFIG_UNUSED_SYMBOLS
-	if (export_is_unused(type) && fsa->warn) {
+	if (export_is_unused(type) && warn) {
 		printk(KERN_WARNING "Symbol %s is marked as UNUSED, "
-		       "however this module is using it.\n", fsa->name);
+		       "however this module is using it.\n", name);
 		printk(KERN_WARNING
 		       "This symbol will go away in the future.\n");
 		printk(KERN_WARNING
@@ -322,36 +385,11 @@ static bool find_symbol_in_section(enum export_type type,
 	}
 #endif
 
-	fsa->sym = sym;
-	fsa->crc = crc;
-	fsa->owner = owner;
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
+		*crc = crc_value;
+	return sym;
 }
 EXPORT_SYMBOL_GPL(find_symbol);
 
-- 
1.6.3.2

