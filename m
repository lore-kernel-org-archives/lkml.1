Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZGFNvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZGFNvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 09:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbZGFNvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 09:51:44 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:23842 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbZGFNvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 09:51:43 -0400
Message-Id: <4A521D900200007800008F97@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Mon, 06 Jul 2009 14:51:44 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] reduce string table for loaded modules (v2)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove all parts of the string table (referenced by the symbol
table) that are not needed for kallsyms use (i.e. which were only
referenced by symbols discarded by the previous patch, or not
referenced at all for whatever reason).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 include/linux/module.h |    2 -
 kernel/module.c        |   68 ++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 57 insertions(+), 13 deletions(-)

--- 2.6.31-rc2-module-strip.orig/include/linux/module.h
+++ 2.6.31-rc2-module-strip/include/linux/module.h
@@ -314,7 +314,7 @@ struct module
 	 */
 	Elf_Sym *symtab, *core_symtab;
 	unsigned int num_symtab, core_num_syms;
-	char *strtab;
+	char *strtab, *core_strtab;
 
 	/* Section attributes */
 	struct module_sect_attrs *sect_attrs;
--- 2.6.31-rc2-module-strip.orig/kernel/module.c
+++ 2.6.31-rc2-module-strip/kernel/module.c
@@ -1865,12 +1865,17 @@ static bool is_core_symbol(const Elf_Sym
 static unsigned long layout_symtab(struct module *mod,
 				   Elf_Shdr *sechdrs,
 				   unsigned int symindex,
+				   unsigned int strindex,
 				   const Elf_Ehdr *hdr,
-				   const char *secstrings)
+				   const char *secstrings,
+				   unsigned long *pstroffs,
+				   unsigned long *strmap)
 {
 	unsigned long symoffs;
 	Elf_Shdr *symsect = sechdrs + symindex;
+	Elf_Shdr *strsect = sechdrs + strindex;
 	const Elf_Sym *src;
+	const char *strtab;
 	unsigned int i, nsrc, ndst;
 
 	/* Put symbol section at end of init part of module. */
@@ -1881,14 +1886,31 @@ static unsigned long layout_symtab(struc
 
 	src = (void *)hdr + symsect->sh_offset;
 	nsrc = symsect->sh_size / sizeof(*src);
+	strtab = (void *)hdr + strsect->sh_offset;
 	for (ndst = i = 1; i < nsrc; ++i, ++src)
-		if (is_core_symbol(src, sechdrs, hdr->e_shnum))
+		if (is_core_symbol(src, sechdrs, hdr->e_shnum)) {
+			unsigned int j = src->st_name;
+
+			while(!__test_and_set_bit(j, strmap) && strtab[j])
+				++j;
 			++ndst;
+		}
 
 	/* Append room for core symbols at end of core part. */
 	symoffs = ALIGN(mod->core_size, symsect->sh_addralign ?: 1);
 	mod->core_size = symoffs + ndst * sizeof(Elf_Sym);
 
+	/* Put string table section at end of init part of module. */
+	strsect->sh_flags |= SHF_ALLOC;
+	strsect->sh_entsize = get_offset(mod, &mod->init_size, strsect,
+					 strindex) | INIT_OFFSET_MASK;
+	DEBUGP("\t%s\n", secstrings + strsect->sh_name);
+
+	/* Append room for core symbols' strings at end of core part. */
+	*pstroffs = mod->core_size;
+	__set_bit(0, strmap);
+	mod->core_size += bitmap_weight(strmap, strsect->sh_size);
+
 	return symoffs;
 }
 
@@ -1898,11 +1920,14 @@ static void add_kallsyms(struct module *
 			 unsigned int symindex,
 			 unsigned int strindex,
 			 unsigned long symoffs,
-			 const char *secstrings)
+			 unsigned long stroffs,
+			 const char *secstrings,
+			 unsigned long *strmap)
 {
 	unsigned int i, ndst;
 	const Elf_Sym *src;
 	Elf_Sym *dst;
+	char *s;
 
 	mod->symtab = (void *)sechdrs[symindex].sh_addr;
 	mod->num_symtab = sechdrs[symindex].sh_size / sizeof(Elf_Sym);
@@ -1920,16 +1945,25 @@ static void add_kallsyms(struct module *
 		if (!is_core_symbol(src, sechdrs, shnum))
 			continue;
 		dst[ndst] = *src;
+		dst[ndst].st_name = bitmap_weight(strmap, dst[ndst].st_name);
 		++ndst;
 	}
 	mod->core_num_syms = ndst;
+
+	mod->core_strtab = s = mod->module_core + stroffs;
+	for (*s = 0, i = 1; i < sechdrs[strindex].sh_size; ++i)
+		if (test_bit(i, strmap))
+			*++s = mod->strtab[i];
 }
 #else
 static inline unsigned long layout_symtab(struct module *mod,
 					  Elf_Shdr *sechdrs,
 					  unsigned int symindex,
+					  unsigned int strindex,
 					  const Elf_Hdr *hdr,
-					  const char *secstrings)
+					  const char *secstrings,
+					  unsigned long *pstroffs,
+					  unsigned long *strmap)
 {
 }
 static inline void add_kallsyms(struct module *mod,
@@ -1938,7 +1972,9 @@ static inline void add_kallsyms(struct m
 				unsigned int symindex,
 				unsigned int strindex,
 				unsigned long symoffs,
-				const char *secstrings)
+				unsigned long stroffs,
+				const char *secstrings,
+				const unsigned long *strmap)
 {
 }
 #endif /* CONFIG_KALLSYMS */
@@ -2014,7 +2050,7 @@ static noinline struct module *load_modu
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
 #ifdef CONFIG_KALLSYMS
-	unsigned long symoffs;
+	unsigned long symoffs, stroffs, *strmap;
 #endif
 	mm_segment_t old_fs;
 
@@ -2097,10 +2133,6 @@ static noinline struct module *load_modu
 	/* Don't keep modinfo and version sections. */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
 	sechdrs[versindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
-#ifdef CONFIG_KALLSYMS
-	/* Keep string table for decoding later. */
-	sechdrs[strindex].sh_flags |= SHF_ALLOC;
-#endif
 
 	/* Check module struct version now, before we try to use module. */
 	if (!check_modstruct_version(sechdrs, versindex, mod)) {
@@ -2136,6 +2168,13 @@ static noinline struct module *load_modu
 		goto free_hdr;
 	}
 
+	strmap = kzalloc(BITS_TO_LONGS(sechdrs[strindex].sh_size)
+			 * sizeof(long), GFP_KERNEL);
+	if (!strmap) {
+		err = -ENOMEM;
+		goto free_mod;
+	}
+
 	if (find_module(mod->name)) {
 		err = -EEXIST;
 		goto free_mod;
@@ -2165,7 +2204,8 @@ static noinline struct module *load_modu
 	   this is done generically; there doesn't appear to be any
 	   special cases for the architectures. */
 	layout_sections(mod, hdr, sechdrs, secstrings);
-	symoffs = layout_symtab(mod, sechdrs, symindex, hdr, secstrings);
+	symoffs = layout_symtab(mod, sechdrs, symindex, strindex, hdr,
+				secstrings, &stroffs, strmap);
 
 	/* Do the allocs. */
 	ptr = module_alloc_update_bounds(mod->core_size);
@@ -2375,7 +2415,9 @@ static noinline struct module *load_modu
 		       sechdrs[pcpuindex].sh_size);
 
 	add_kallsyms(mod, sechdrs, hdr->e_shnum, symindex, strindex,
-		     symoffs, secstrings);
+		     symoffs, stroffs, secstrings, strmap);
+	kfree(strmap);
+	strmap = NULL;
 
 	if (!mod->taints) {
 		struct _ddebug *debug;
@@ -2462,6 +2504,7 @@ static noinline struct module *load_modu
 		percpu_modfree(percpu);
  free_mod:
 	kfree(args);
+	kfree(strmap);
  free_hdr:
 	vfree(hdr);
 	return ERR_PTR(err);
@@ -2554,6 +2597,7 @@ SYSCALL_DEFINE3(init_module, void __user
 #ifdef CONFIG_KALLSYMS
 	mod->num_symtab = mod->core_num_syms;
 	mod->symtab = mod->core_symtab;
+	mod->strtab = mod->core_strtab;
 #endif
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;


