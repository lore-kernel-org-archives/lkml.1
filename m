Return-Path: <linux-kernel-owner+w=401wt.eu-S1763201AbXIMXXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763201AbXIMXXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbXIMXX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:23:28 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:32078 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbXIMXX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:23:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=uMRAw01HQcaTVt05INu+d675wFzyoHBWao1aBjaBw1FzMZzTy2kjBO/5kYMzlMQxJwK9NOkaDbwZzxL25LlvAQBWkD/r8cTHbfMpEuV3Mkuf8C9/HMiC4Hrcl6fNSfSJVYZ20XG4Sj6q1uowI0RjZoP0XmQMdWxOtpffZhkvRto=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] module.c: add missing ifdefs for CONFIG_UNUSED_SYMBOLS
Date: Fri, 14 Sep 2007 00:23:17 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200709132330.33283.vda.linux@googlemail.com> <20070913160047.159e5e3d.akpm@linux-foundation.org>
In-Reply-To: <20070913160047.159e5e3d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_lZc6GUXoncw+qST"
Message-Id: <200709140023.17307.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_lZc6GUXoncw+qST
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 14 September 2007 00:00, Andrew Morton wrote:
> > In short, patch makes trivial changes which are "obviously correct"
> > (famous last words).
> 
> The intent seems reasonable.  Would have preferred separate patches for the
> separate things though..
> 
> This:
> 
> akpm:/usr/src/25> grep '^+#' patches/modulec-add-missing-ifdefs-for-config_unused_symbols.patch                                                                 +#ifdef CONFIG_UNUSED_SYMBOLS
> +#endif
> +#ifdef CONFIG_UNUSED_SYMBOLS
> +#endif
> +#ifdef CONFIG_UNUSED_SYMBOLS
> +#endif
> +#ifdef CONFIG_UNUSED_SYMBOLS
> +#endif
> +#ifdef CONFIG_UNUSED_SYMBOLS
> +#endif
> +#ifdef CONFIG_UNUSED_SYMBOLS
> +#endif
> +#ifdef CONFIG_UNUSED_SYMBOLS
> +#endif
> +#ifdef CONFIG_UNUSED_SYMBOLS
> +#endif
> +#ifdef CONFIG_UNUSED_SYMBOLS
> +#endif
> +#ifdef CONFIG_UNUSED_SYMBOLS
> +#endif
> +#ifdef CONFIG_UNUSED_SYMBOLS
> +#endif
> 
> is a bit of a maintenance problem though.  Can you think of a way in whcih
> we can cut down on that?

Attached patch reduces number of inserted #ifdefs from 11 to 8.
--
vda

--Boundary-00=_lZc6GUXoncw+qST
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="linux-2.6.23-rc6.module.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.23-rc6.module.diff"

diff -urpN linux-2.6.23-rc6/include/linux/module.h linux-2.6.23-rc6.module/include/linux/module.h
--- linux-2.6.23-rc6/include/linux/module.h	2007-09-14 00:08:12.000000000 +0100
+++ linux-2.6.23-rc6.module/include/linux/module.h	2007-09-14 00:16:11.000000000 +0100
@@ -263,28 +263,29 @@ struct module
 	const char *srcversion;
 	struct kobject *holders_dir;
 
-	/* Exported symbols */
-	const struct kernel_symbol *syms;
+	/* Counts: exported symbols */
 	unsigned int num_syms;
-	const unsigned long *crcs;
-
-	/* GPL-only exported symbols. */
-	const struct kernel_symbol *gpl_syms;
+	/* GPL-only exported symbols */
 	unsigned int num_gpl_syms;
-	const unsigned long *gpl_crcs;
+	/* symbols that will be GPL-only in the near future */
+	unsigned int num_gpl_future_syms;
+#ifdef CONFIG_UNUSED_SYMBOLS
+	/* unused exported symbols */
+	unsigned int num_unused_syms;
+	/* GPL-only, unused exported symbols */
+	unsigned int num_unused_gpl_syms;
 
-	/* unused exported symbols. */
+	/* And respective pointers */
 	const struct kernel_symbol *unused_syms;
-	unsigned int num_unused_syms;
 	const unsigned long *unused_crcs;
-	/* GPL-only, unused exported symbols. */
 	const struct kernel_symbol *unused_gpl_syms;
-	unsigned int num_unused_gpl_syms;
 	const unsigned long *unused_gpl_crcs;
-
-	/* symbols that will be GPL-only in the near future. */
+#endif
+	const struct kernel_symbol *syms;
+	const unsigned long *crcs;
+	const struct kernel_symbol *gpl_syms;
+	const unsigned long *gpl_crcs;
 	const struct kernel_symbol *gpl_future_syms;
-	unsigned int num_gpl_future_syms;
 	const unsigned long *gpl_future_crcs;
 
 	/* Exception table */
@@ -301,10 +302,10 @@ struct module
 	void *module_core;
 
 	/* Here are the sizes of the init and core sections */
-	unsigned long init_size, core_size;
+	unsigned int init_size, core_size;
 
 	/* The size of the executable code in each section.  */
-	unsigned long init_text_size, core_text_size;
+	unsigned int init_text_size, core_text_size;
 
 	/* The handle returned from unwind_add_table. */
 	void *unwind_info;
@@ -341,7 +342,7 @@ struct module
 #ifdef CONFIG_KALLSYMS
 	/* We keep the symbol and string tables for kallsyms. */
 	Elf_Sym *symtab;
-	unsigned long num_symtab;
+	unsigned int num_symtab;
 	char *strtab;
 
 	/* Section attributes */
diff -urpN linux-2.6.23-rc6/init/Kconfig linux-2.6.23-rc6.module/init/Kconfig
--- linux-2.6.23-rc6/init/Kconfig	2007-09-14 00:08:13.000000000 +0100
+++ linux-2.6.23-rc6.module/init/Kconfig	2007-09-14 00:09:26.000000000 +0100
@@ -611,8 +611,8 @@ config MODULE_UNLOAD
 	help
 	  Without this option you will not be able to unload any
 	  modules (note that some modules may not be unloadable
-	  anyway), which makes your kernel slightly smaller and
-	  simpler.  If unsure, say Y.
+	  anyway), which makes your kernel smaller, faster
+	  and simpler.  If unsure, say Y.
 
 config MODULE_FORCE_UNLOAD
 	bool "Forced module unloading"
diff -urpN linux-2.6.23-rc6/kernel/module.c linux-2.6.23-rc6.module/kernel/module.c
--- linux-2.6.23-rc6/kernel/module.c	2007-09-14 00:08:13.000000000 +0100
+++ linux-2.6.23-rc6.module/kernel/module.c	2007-09-14 00:16:58.000000000 +0100
@@ -158,6 +158,7 @@ static const struct kernel_symbol *looku
 	return NULL;
 }
 
+#ifdef CONFIG_UNUSED_SYMBOLS
 static void printk_unused_warning(const char *name)
 {
 	printk(KERN_WARNING "Symbol %s is marked as UNUSED, "
@@ -168,6 +169,7 @@ static void printk_unused_warning(const 
 		"mailinglist together with submitting your code for "
 		"inclusion.\n");
 }
+#endif
 
 /* Find a symbol, return value, crc and module which owns it */
 static unsigned long __find_symbol(const char *name,
@@ -211,6 +213,7 @@ static unsigned long __find_symbol(const
 		return ks->value;
 	}
 
+#ifdef CONFIG_UNUSED_SYMBOLS
 	ks = lookup_symbol(name, __start___ksymtab_unused,
 				 __stop___ksymtab_unused);
 	if (ks) {
@@ -229,6 +232,7 @@ static unsigned long __find_symbol(const
 				  (ks - __start___ksymtab_unused_gpl));
 		return ks->value;
 	}
+#endif
 
 	/* Now try modules. */ 
 	list_for_each_entry(mod, &modules, list) {
@@ -248,13 +252,13 @@ static unsigned long __find_symbol(const
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
@@ -265,6 +269,7 @@ static unsigned long __find_symbol(const
 				return ks->value;
 			}
 		}
+#endif
 		ks = lookup_symbol(name, mod->gpl_future_syms,
 				   (mod->gpl_future_syms +
 				    mod->num_gpl_future_syms));
@@ -1332,7 +1337,7 @@ static int simplify_symbols(Elf_Shdr *se
 }
 
 /* Update size with this section: return offset. */
-static long get_offset(unsigned long *size, Elf_Shdr *sechdr)
+static long get_offset(unsigned int *size, Elf_Shdr *sechdr)
 {
 	long ret;
 
@@ -1570,10 +1575,12 @@ static struct module *load_module(void _
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
@@ -1654,13 +1661,15 @@ static struct module *load_module(void _
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
@@ -1813,27 +1822,32 @@ static struct module *load_module(void _
 		mod->gpl_crcs = (void *)sechdrs[gplcrcindex].sh_addr;
 	mod->num_gpl_future_syms = sechdrs[gplfutureindex].sh_size /
 					sizeof(*mod->gpl_future_syms);
-	mod->num_unused_syms = sechdrs[unusedindex].sh_size /
-					sizeof(*mod->unused_syms);
-	mod->num_unused_gpl_syms = sechdrs[unusedgplindex].sh_size /
-					sizeof(*mod->unused_gpl_syms);
 	mod->gpl_future_syms = (void *)sechdrs[gplfutureindex].sh_addr;
 	if (gplfuturecrcindex)
 		mod->gpl_future_crcs = (void *)sechdrs[gplfuturecrcindex].sh_addr;
 
+#ifdef CONFIG_UNUSED_SYMBOLS
+	mod->num_unused_syms = sechdrs[unusedindex].sh_size /
+					sizeof(*mod->unused_syms);
+	mod->num_unused_gpl_syms = sechdrs[unusedgplindex].sh_size /
+					sizeof(*mod->unused_gpl_syms);
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
@@ -2269,7 +2283,7 @@ static int m_show(struct seq_file *m, vo
 	struct module *mod = list_entry(p, struct module, list);
 	char buf[8];
 
-	seq_printf(m, "%s %lu",
+	seq_printf(m, "%s %u",
 		   mod->name, mod->init_size + mod->core_size);
 	print_unload_info(m, mod);
 

--Boundary-00=_lZc6GUXoncw+qST--
