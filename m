Return-Path: <linux-kernel-owner+w=401wt.eu-S1765732AbXIMWax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765732AbXIMWax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 18:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbXIMWaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 18:30:46 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:51757 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904AbXIMWap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 18:30:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:message-id;
        b=AghhShOuNMukCgY1rKd8x6m7Az3fj+5u4GGCuF5soPbPu1c5w5CvMtLveJOvm4udo/IgcQgMF3yDLCuAuJ7mt2kwdVSPzY6jj2iEr5RZHkkcrxXadAfWDwLk46L1XhCo3PPaAE/7VhjleZP/pTTMzuAHtw1I+UIaAnqi+HkkDYI=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] module.c: add missing ifdefs for CONFIG_UNUSED_SYMBOLS
Date: Thu, 13 Sep 2007 23:30:33 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Job6GIxUASRKqOB"
Message-Id: <200709132330.33283.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_Job6GIxUASRKqOB
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Andrew,

module.c and module.h conatains code for finding
exported symbols which are declared with EXPORT_UNUSED_SYMBOL,
and this code is compiled in even if CONFIG_UNUSED_SYMBOLS is not set
and thus there can be no EXPORT_UNUSED_SYMBOLs in modules anyway
(because EXPORT_UNUSED_SYMBOL(x) are compiled out to nothing then).

This patch adds required #ifdefs.

This shrinks module.o and each *.ko file.

Patch also regroups some struct module members so
that on 64 bit CPUs we are not wasting 32 bits on padding here:

        const struct kernel_symbol *unused_syms;
        unsigned int num_unused_syms;
        const unsigned long *unused_crcs;

It groups counters and pointers separately.

Patch makes small edit to help text of CONFIG_MODULE_UNLOAD -
it explicitly says that without that option, kernel
will be also faster, not only "smaller and simpler".
When I realized how much churn is going on under the hood
in order to make module unloading possible, I felt that
users are not informed well enough about it in the help text.

And finally, structure members which hold length of module
code (four such members there) and count of symbols
are converted from longs to ints.

We cannot possibly have a module where 32 bits won't
be enough to hold such counts.

For one, module loading checks module size for sanity
before loading, so such insanely big module will fail
that test first.

In short, patch makes trivial changes which are "obviously correct"
(famous last words).

Patch is compile tested with various combinations of CONFIGs.

Please put it into -mm.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_Job6GIxUASRKqOB
Content-Type: text/x-diff;
  charset="us-ascii";
  name="linux-2.6.23-rc6.structmodule.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.23-rc6.structmodule.patch"

--- linux-2.6.23-rc6/include/linux/module.h	Wed Sep 12 22:35:32 2007
+++ linux-2.6.23-rc6.structmodule/include/linux/module.h	Thu Sep 13 10:04:33 2007
@@ -264,28 +264,30 @@
 	struct kobject *holders_dir;
 
 	/* Exported symbols */
-	const struct kernel_symbol *syms;
 	unsigned int num_syms;
-	const unsigned long *crcs;
-
 	/* GPL-only exported symbols. */
-	const struct kernel_symbol *gpl_syms;
 	unsigned int num_gpl_syms;
-	const unsigned long *gpl_crcs;
-
+	/* symbols that will be GPL-only in the near future. */
+	unsigned int num_gpl_future_syms;
+#ifdef CONFIG_UNUSED_SYMBOLS
 	/* unused exported symbols. */
-	const struct kernel_symbol *unused_syms;
 	unsigned int num_unused_syms;
-	const unsigned long *unused_crcs;
 	/* GPL-only, unused exported symbols. */
-	const struct kernel_symbol *unused_gpl_syms;
 	unsigned int num_unused_gpl_syms;
-	const unsigned long *unused_gpl_crcs;
-
-	/* symbols that will be GPL-only in the near future. */
+#endif
+	/* and respective pointers... */
+	const struct kernel_symbol *syms;
+	const unsigned long *crcs;
+	const struct kernel_symbol *gpl_syms;
+	const unsigned long *gpl_crcs;
 	const struct kernel_symbol *gpl_future_syms;
-	unsigned int num_gpl_future_syms;
 	const unsigned long *gpl_future_crcs;
+#ifdef CONFIG_UNUSED_SYMBOLS
+	const struct kernel_symbol *unused_syms;
+	const unsigned long *unused_crcs;
+	const struct kernel_symbol *unused_gpl_syms;
+	const unsigned long *unused_gpl_crcs;
+#endif
 
 	/* Exception table */
 	unsigned int num_exentries;
@@ -301,10 +303,10 @@
 	void *module_core;
 
 	/* Here are the sizes of the init and core sections */
-	unsigned long init_size, core_size;
+	unsigned int init_size, core_size;
 
 	/* The size of the executable code in each section.  */
-	unsigned long init_text_size, core_text_size;
+	unsigned int init_text_size, core_text_size;
 
 	/* The handle returned from unwind_add_table. */
 	void *unwind_info;
@@ -341,7 +343,7 @@
 #ifdef CONFIG_KALLSYMS
 	/* We keep the symbol and string tables for kallsyms. */
 	Elf_Sym *symtab;
-	unsigned long num_symtab;
+	unsigned int num_symtab;
 	char *strtab;
 
 	/* Section attributes */
--- linux-2.6.23-rc6/init/Kconfig	Wed Sep 12 22:35:32 2007
+++ linux-2.6.23-rc6.structmodule/init/Kconfig	Thu Sep 13 01:32:31 2007
@@ -611,8 +611,8 @@
 	help
 	  Without this option you will not be able to unload any
 	  modules (note that some modules may not be unloadable
-	  anyway), which makes your kernel slightly smaller and
-	  simpler.  If unsure, say Y.
+	  anyway), which makes your kernel smaller, faster
+	  and simpler.  If unsure, say Y.
 
 config MODULE_FORCE_UNLOAD
 	bool "Forced module unloading"
--- linux-2.6.23-rc6/kernel/module.c	Tue Sep 11 22:34:01 2007
+++ linux-2.6.23-rc6.structmodule/kernel/module.c	Thu Sep 13 10:14:17 2007
@@ -128,17 +128,19 @@
 extern const struct kernel_symbol __stop___ksymtab_gpl[];
 extern const struct kernel_symbol __start___ksymtab_gpl_future[];
 extern const struct kernel_symbol __stop___ksymtab_gpl_future[];
-extern const struct kernel_symbol __start___ksymtab_unused[];
-extern const struct kernel_symbol __stop___ksymtab_unused[];
-extern const struct kernel_symbol __start___ksymtab_unused_gpl[];
-extern const struct kernel_symbol __stop___ksymtab_unused_gpl[];
 extern const struct kernel_symbol __start___ksymtab_gpl_future[];
 extern const struct kernel_symbol __stop___ksymtab_gpl_future[];
 extern const unsigned long __start___kcrctab[];
 extern const unsigned long __start___kcrctab_gpl[];
 extern const unsigned long __start___kcrctab_gpl_future[];
+#ifdef CONFIG_UNUSED_SYMBOLS
+extern const struct kernel_symbol __start___ksymtab_unused[];
+extern const struct kernel_symbol __stop___ksymtab_unused[];
+extern const struct kernel_symbol __start___ksymtab_unused_gpl[];
+extern const struct kernel_symbol __stop___ksymtab_unused_gpl[];
 extern const unsigned long __start___kcrctab_unused[];
 extern const unsigned long __start___kcrctab_unused_gpl[];
+#endif
 
 #ifndef CONFIG_MODVERSIONS
 #define symversion(base, idx) NULL
@@ -158,6 +160,7 @@
 	return NULL;
 }
 
+#ifdef CONFIG_UNUSED_SYMBOLS
 static void printk_unused_warning(const char *name)
 {
 	printk(KERN_WARNING "Symbol %s is marked as UNUSED, "
@@ -168,6 +171,7 @@
 		"mailinglist together with submitting your code for "
 		"inclusion.\n");
 }
+#endif
 
 /* Find a symbol, return value, crc and module which owns it */
 static unsigned long __find_symbol(const char *name,
@@ -211,6 +215,7 @@
 		return ks->value;
 	}
 
+#ifdef CONFIG_UNUSED_SYMBOLS
 	ks = lookup_symbol(name, __start___ksymtab_unused,
 				 __stop___ksymtab_unused);
 	if (ks) {
@@ -229,6 +234,7 @@
 				  (ks - __start___ksymtab_unused_gpl));
 		return ks->value;
 	}
+#endif
 
 	/* Now try modules. */ 
 	list_for_each_entry(mod, &modules, list) {
@@ -248,13 +254,13 @@
 				return ks->value;
 			}
 		}
+#ifdef CONFIG_UNUSED_SYMBOLS
 		ks = lookup_symbol(name, mod->unused_syms, mod->unused_syms + mod->num_unused_syms);
 		if (ks) {
 			printk_unused_warning(name);
 			*crc = symversion(mod->unused_crcs, (ks - mod->unused_syms));
 			return ks->value;
 		}
-
 		if (gplok) {
 			ks = lookup_symbol(name, mod->unused_gpl_syms,
 					   mod->unused_gpl_syms + mod->num_unused_gpl_syms);
@@ -265,6 +271,7 @@
 				return ks->value;
 			}
 		}
+#endif
 		ks = lookup_symbol(name, mod->gpl_future_syms,
 				   (mod->gpl_future_syms +
 				    mod->num_gpl_future_syms));
@@ -1332,7 +1339,7 @@
 }
 
 /* Update size with this section: return offset. */
-static long get_offset(unsigned long *size, Elf_Shdr *sechdr)
+static long get_offset(unsigned int *size, Elf_Shdr *sechdr)
 {
 	long ret;
 
@@ -1570,10 +1577,12 @@
 	unsigned int gplfutureindex;
 	unsigned int gplfuturecrcindex;
 	unsigned int unwindex = 0;
+#ifdef CONFIG_UNUSED_SYMBOLS
 	unsigned int unusedindex;
 	unsigned int unusedcrcindex;
 	unsigned int unusedgplindex;
 	unsigned int unusedgplcrcindex;
+#endif
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1654,13 +1663,15 @@
 	exportindex = find_sec(hdr, sechdrs, secstrings, "__ksymtab");
 	gplindex = find_sec(hdr, sechdrs, secstrings, "__ksymtab_gpl");
 	gplfutureindex = find_sec(hdr, sechdrs, secstrings, "__ksymtab_gpl_future");
-	unusedindex = find_sec(hdr, sechdrs, secstrings, "__ksymtab_unused");
-	unusedgplindex = find_sec(hdr, sechdrs, secstrings, "__ksymtab_unused_gpl");
 	crcindex = find_sec(hdr, sechdrs, secstrings, "__kcrctab");
 	gplcrcindex = find_sec(hdr, sechdrs, secstrings, "__kcrctab_gpl");
 	gplfuturecrcindex = find_sec(hdr, sechdrs, secstrings, "__kcrctab_gpl_future");
+#ifdef CONFIG_UNUSED_SYMBOLS
+	unusedindex = find_sec(hdr, sechdrs, secstrings, "__ksymtab_unused");
+	unusedgplindex = find_sec(hdr, sechdrs, secstrings, "__ksymtab_unused_gpl");
 	unusedcrcindex = find_sec(hdr, sechdrs, secstrings, "__kcrctab_unused");
 	unusedgplcrcindex = find_sec(hdr, sechdrs, secstrings, "__kcrctab_unused_gpl");
+#endif
 	setupindex = find_sec(hdr, sechdrs, secstrings, "__param");
 	exindex = find_sec(hdr, sechdrs, secstrings, "__ex_table");
 	obsparmindex = find_sec(hdr, sechdrs, secstrings, "__obsparm");
@@ -1813,27 +1824,34 @@
 		mod->gpl_crcs = (void *)sechdrs[gplcrcindex].sh_addr;
 	mod->num_gpl_future_syms = sechdrs[gplfutureindex].sh_size /
 					sizeof(*mod->gpl_future_syms);
+#ifdef CONFIG_UNUSED_SYMBOLS
 	mod->num_unused_syms = sechdrs[unusedindex].sh_size /
 					sizeof(*mod->unused_syms);
 	mod->num_unused_gpl_syms = sechdrs[unusedgplindex].sh_size /
 					sizeof(*mod->unused_gpl_syms);
+#endif
 	mod->gpl_future_syms = (void *)sechdrs[gplfutureindex].sh_addr;
 	if (gplfuturecrcindex)
 		mod->gpl_future_crcs = (void *)sechdrs[gplfuturecrcindex].sh_addr;
 
+#ifdef CONFIG_UNUSED_SYMBOLS
 	mod->unused_syms = (void *)sechdrs[unusedindex].sh_addr;
 	if (unusedcrcindex)
 		mod->unused_crcs = (void *)sechdrs[unusedcrcindex].sh_addr;
 	mod->unused_gpl_syms = (void *)sechdrs[unusedgplindex].sh_addr;
 	if (unusedgplcrcindex)
 		mod->unused_crcs = (void *)sechdrs[unusedgplcrcindex].sh_addr;
+#endif
 
 #ifdef CONFIG_MODVERSIONS
 	if ((mod->num_syms && !crcindex) || 
 	    (mod->num_gpl_syms && !gplcrcindex) ||
-	    (mod->num_gpl_future_syms && !gplfuturecrcindex) ||
-	    (mod->num_unused_syms && !unusedcrcindex) ||
-	    (mod->num_unused_gpl_syms && !unusedgplcrcindex)) {
+	    (mod->num_gpl_future_syms && !gplfuturecrcindex)
+#ifdef CONFIG_UNUSED_SYMBOLS
+	    || (mod->num_unused_syms && !unusedcrcindex)
+	    || (mod->num_unused_gpl_syms && !unusedgplcrcindex)
+#endif
+	) {
 		printk(KERN_WARNING "%s: No versions for exported symbols."
 		       " Tainting kernel.\n", mod->name);
 		add_taint_module(mod, TAINT_FORCED_MODULE);
@@ -2269,7 +2287,7 @@
 	struct module *mod = list_entry(p, struct module, list);
 	char buf[8];
 
-	seq_printf(m, "%s %lu",
+	seq_printf(m, "%s %u",
 		   mod->name, mod->init_size + mod->core_size);
 	print_unload_info(m, mod);
 

--Boundary-00=_Job6GIxUASRKqOB--
