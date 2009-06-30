Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbZF3MKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbZF3MKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 08:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZF3MKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 08:10:17 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:46833 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZF3MKQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 08:10:16 -0400
Message-Id: <4A4A1CCC0200007800008374@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 30 Jun 2009 13:10:20 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] reduce string table for loaded modules
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
 kernel/module.c        |   71 +++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 58 insertions(+), 15 deletions(-)

--- 2.6.31-rc1-module-strip.orig/include/linux/module.h
+++ 2.6.31-rc1-module-strip/include/linux/module.h
@@ -310,7 +310,7 @@ struct module
 	/* We keep the symbol and string tables for kallsyms. */
 	Elf_Sym *symtab, *core_symtab;
 	unsigned int num_symtab, core_num_syms;
-	char *strtab;
+	char *strtab, *core_strtab;
 
 	/* Section attributes */
 	struct module_sect_attrs *sect_attrs;
--- 2.6.31-rc1-module-strip.orig/kernel/module.c
+++ 2.6.31-rc1-module-strip/kernel/module.c
@@ -1843,6 +1843,7 @@ static char elf_type(const Elf_Sym *sym,
 
 static unsigned int filter_symbols(Elf_Sym *dst,
 				   const Elf_Sym *src, unsigned int nsrc,
+				   const char *strtab, unsigned long *strmap,
 				   const Elf_Shdr *sechdrs, unsigned int shnum)
 {
 	unsigned int i, ndst;
@@ -1863,8 +1864,16 @@ static unsigned int filter_symbols(Elf_S
 #endif
 		    || (sec->sh_entsize & INIT_OFFSET_MASK))
 			continue;
-		if (dst)
+		if (dst) {
 			dst[ndst] = *src;
+			dst[ndst].st_name = bitmap_weight(strmap,
+							  dst[ndst].st_name);
+		} else {
+			unsigned int j = src->st_name;
+
+			while(!__test_and_set_bit(j, strmap) && strtab[j])
+				++j;
+		}
 		++ndst;
 	}
 
@@ -1874,11 +1883,15 @@ static unsigned int filter_symbols(Elf_S
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
 
 	symsect->sh_flags |= SHF_ALLOC;
 	symsect->sh_entsize = get_offset(mod, &mod->init_size, symsect,
@@ -1890,9 +1903,19 @@ static unsigned long layout_symtab(struc
 			 + filter_symbols(NULL,
 			 		  (void *)hdr + symsect->sh_offset,
 					  symsect->sh_size / sizeof(Elf_Sym),
-					  sechdrs, hdr->e_shnum)
+			 		  (void *)hdr + strsect->sh_offset,
+			 		  strmap, sechdrs, hdr->e_shnum)
 			 * sizeof(Elf_Sym);
 
+	strsect->sh_flags |= SHF_ALLOC;
+	strsect->sh_entsize = get_offset(mod, &mod->init_size, strsect,
+					 strindex) | INIT_OFFSET_MASK;
+	DEBUGP("\t%s\n", secstrings + strsect->sh_name);
+
+	*pstroffs = mod->core_size;
+	__set_bit(0, strmap);
+	mod->core_size += bitmap_weight(strmap, strsect->sh_size);
+
 	return symoffs;
 }
 
@@ -1902,9 +1925,12 @@ static void add_kallsyms(struct module *
 			 unsigned int symindex,
 			 unsigned int strindex,
 			 unsigned long symoffs,
-			 const char *secstrings)
+			 unsigned long stroffs,
+			 const char *secstrings,
+			 unsigned long *strmap)
 {
 	unsigned int i;
+	char *s;
 
 	mod->symtab = (void *)sechdrs[symindex].sh_addr;
 	mod->num_symtab = sechdrs[symindex].sh_size / sizeof(Elf_Sym);
@@ -1918,14 +1944,21 @@ static void add_kallsyms(struct module *
 	mod->core_symtab = mod->module_core + symoffs;
 	mod->core_num_syms = filter_symbols(mod->core_symtab,
 					    mod->symtab, mod->num_symtab,
-					    sechdrs, shnum);
+					    NULL, strmap, sechdrs, shnum);
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
@@ -1934,7 +1967,9 @@ static inline void add_kallsyms(struct m
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
@@ -2010,7 +2045,7 @@ static noinline struct module *load_modu
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
 #ifdef CONFIG_KALLSYMS
-	unsigned long symoffs;
+	unsigned long symoffs, stroffs, *strmap;
 #endif
 	mm_segment_t old_fs;
 
@@ -2093,10 +2128,6 @@ static noinline struct module *load_modu
 	/* Don't keep modinfo and version sections. */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
 	sechdrs[versindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
-#ifdef CONFIG_KALLSYMS
-	/* Keep string table for decoding later. */
-	sechdrs[strindex].sh_flags |= SHF_ALLOC;
-#endif
 
 	/* Check module struct version now, before we try to use module. */
 	if (!check_modstruct_version(sechdrs, versindex, mod)) {
@@ -2132,6 +2163,13 @@ static noinline struct module *load_modu
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
@@ -2161,7 +2199,8 @@ static noinline struct module *load_modu
 	   this is done generically; there doesn't appear to be any
 	   special cases for the architectures. */
 	layout_sections(mod, hdr, sechdrs, secstrings);
-	symoffs = layout_symtab(mod, sechdrs, symindex, hdr, secstrings);
+	symoffs = layout_symtab(mod, sechdrs, symindex, strindex, hdr,
+				secstrings, &stroffs, strmap);
 
 	/* Do the allocs. */
 	ptr = module_alloc_update_bounds(mod->core_size);
@@ -2371,7 +2410,9 @@ static noinline struct module *load_modu
 		       sechdrs[pcpuindex].sh_size);
 
 	add_kallsyms(mod, sechdrs, hdr->e_shnum, symindex, strindex,
-		     symoffs, secstrings);
+		     symoffs, stroffs, secstrings, strmap);
+	kfree(strmap);
+	strmap = NULL;
 
 	if (!mod->taints) {
 		struct _ddebug *debug;
@@ -2458,6 +2499,7 @@ static noinline struct module *load_modu
 		percpu_modfree(percpu);
  free_mod:
 	kfree(args);
+	kfree(strmap);
  free_hdr:
 	vfree(hdr);
 	return ERR_PTR(err);
@@ -2550,6 +2592,7 @@ SYSCALL_DEFINE3(init_module, void __user
 #ifdef CONFIG_KALLSYMS
 	mod->num_symtab = mod->core_num_syms;
 	mod->symtab = mod->core_symtab;
+	mod->strtab = mod->core_strtab;
 #endif
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;


