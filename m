Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbZGFNut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbZGFNut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 09:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbZGFNum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 09:50:42 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:23797 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbZGFNul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 09:50:41 -0400
Message-Id: <4A521D520200007800008F94@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Mon, 06 Jul 2009 14:50:42 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] reduce symbol table for loaded modules (v2)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discard all symbols not interesting for kallsyms use: absolute,
section, and in the common case (!KALLSYMS_ALL) data ones.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 include/linux/module.h |   10 +++--
 kernel/module.c        |   91 ++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 94 insertions(+), 7 deletions(-)

--- 2.6.31-rc2-module-strip.orig/include/linux/module.h
+++ 2.6.31-rc2-module-strip/include/linux/module.h
@@ -307,9 +307,13 @@ struct module
 #endif
 
 #ifdef CONFIG_KALLSYMS
-	/* We keep the symbol and string tables for kallsyms. */
-	Elf_Sym *symtab;
-	unsigned int num_symtab;
+	/*
+	 * We keep the symbol and string tables for kallsyms.
+	 * The core_* fields below are temporary, loader-only (they
+	 * could really be discarded after module init).
+	 */
+	Elf_Sym *symtab, *core_symtab;
+	unsigned int num_symtab, core_num_syms;
 	char *strtab;
 
 	/* Section attributes */
--- 2.6.31-rc2-module-strip.orig/kernel/module.c
+++ 2.6.31-rc2-module-strip/kernel/module.c
@@ -1841,13 +1841,68 @@ static char elf_type(const Elf_Sym *sym,
 	return '?';
 }
 
+static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
+                           unsigned int shnum)
+{
+	const Elf_Shdr *sec;
+
+	if (src->st_shndx == SHN_UNDEF
+	    || src->st_shndx >= shnum
+	    || !src->st_name)
+		return false;
+
+	sec = sechdrs + src->st_shndx;
+	if (!(sec->sh_flags & SHF_ALLOC)
+#ifndef CONFIG_KALLSYMS_ALL
+	    || !(sec->sh_flags & SHF_EXECINSTR)
+#endif
+	    || (sec->sh_entsize & INIT_OFFSET_MASK))
+		return false;
+
+	return true;
+}
+
+static unsigned long layout_symtab(struct module *mod,
+				   Elf_Shdr *sechdrs,
+				   unsigned int symindex,
+				   const Elf_Ehdr *hdr,
+				   const char *secstrings)
+{
+	unsigned long symoffs;
+	Elf_Shdr *symsect = sechdrs + symindex;
+	const Elf_Sym *src;
+	unsigned int i, nsrc, ndst;
+
+	/* Put symbol section at end of init part of module. */
+	symsect->sh_flags |= SHF_ALLOC;
+	symsect->sh_entsize = get_offset(mod, &mod->init_size, symsect,
+					 symindex) | INIT_OFFSET_MASK;
+	DEBUGP("\t%s\n", secstrings + symsect->sh_name);
+
+	src = (void *)hdr + symsect->sh_offset;
+	nsrc = symsect->sh_size / sizeof(*src);
+	for (ndst = i = 1; i < nsrc; ++i, ++src)
+		if (is_core_symbol(src, sechdrs, hdr->e_shnum))
+			++ndst;
+
+	/* Append room for core symbols at end of core part. */
+	symoffs = ALIGN(mod->core_size, symsect->sh_addralign ?: 1);
+	mod->core_size = symoffs + ndst * sizeof(Elf_Sym);
+
+	return symoffs;
+}
+
 static void add_kallsyms(struct module *mod,
 			 Elf_Shdr *sechdrs,
+			 unsigned int shnum,
 			 unsigned int symindex,
 			 unsigned int strindex,
+			 unsigned long symoffs,
 			 const char *secstrings)
 {
-	unsigned int i;
+	unsigned int i, ndst;
+	const Elf_Sym *src;
+	Elf_Sym *dst;
 
 	mod->symtab = (void *)sechdrs[symindex].sh_addr;
 	mod->num_symtab = sechdrs[symindex].sh_size / sizeof(Elf_Sym);
@@ -1857,12 +1912,32 @@ static void add_kallsyms(struct module *
 	for (i = 0; i < mod->num_symtab; i++)
 		mod->symtab[i].st_info
 			= elf_type(&mod->symtab[i], sechdrs, secstrings, mod);
+
+	mod->core_symtab = dst = mod->module_core + symoffs;
+	src = mod->symtab;
+	*dst = *src;
+	for (ndst = i = 1; i < mod->num_symtab; ++i, ++src) {
+		if (!is_core_symbol(src, sechdrs, shnum))
+			continue;
+		dst[ndst] = *src;
+		++ndst;
+	}
+	mod->core_num_syms = ndst;
 }
 #else
+static inline unsigned long layout_symtab(struct module *mod,
+					  Elf_Shdr *sechdrs,
+					  unsigned int symindex,
+					  const Elf_Hdr *hdr,
+					  const char *secstrings)
+{
+}
 static inline void add_kallsyms(struct module *mod,
 				Elf_Shdr *sechdrs,
+				unsigned int shnum,
 				unsigned int symindex,
 				unsigned int strindex,
+				unsigned long symoffs,
 				const char *secstrings)
 {
 }
@@ -1938,6 +2013,9 @@ static noinline struct module *load_modu
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
+#ifdef CONFIG_KALLSYMS
+	unsigned long symoffs;
+#endif
 	mm_segment_t old_fs;
 
 	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
@@ -2020,8 +2098,7 @@ static noinline struct module *load_modu
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
 	sechdrs[versindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
 #ifdef CONFIG_KALLSYMS
-	/* Keep symbol and string tables for decoding later. */
-	sechdrs[symindex].sh_flags |= SHF_ALLOC;
+	/* Keep string table for decoding later. */
 	sechdrs[strindex].sh_flags |= SHF_ALLOC;
 #endif
 
@@ -2088,6 +2165,7 @@ static noinline struct module *load_modu
 	   this is done generically; there doesn't appear to be any
 	   special cases for the architectures. */
 	layout_sections(mod, hdr, sechdrs, secstrings);
+	symoffs = layout_symtab(mod, sechdrs, symindex, hdr, secstrings);
 
 	/* Do the allocs. */
 	ptr = module_alloc_update_bounds(mod->core_size);
@@ -2296,7 +2374,8 @@ static noinline struct module *load_modu
 	percpu_modcopy(mod->percpu, (void *)sechdrs[pcpuindex].sh_addr,
 		       sechdrs[pcpuindex].sh_size);
 
-	add_kallsyms(mod, sechdrs, symindex, strindex, secstrings);
+	add_kallsyms(mod, sechdrs, hdr->e_shnum, symindex, strindex,
+		     symoffs, secstrings);
 
 	if (!mod->taints) {
 		struct _ddebug *debug;
@@ -2472,6 +2551,10 @@ SYSCALL_DEFINE3(init_module, void __user
 	/* Drop initial reference. */
 	module_put(mod);
 	trim_init_extable(mod);
+#ifdef CONFIG_KALLSYMS
+	mod->num_symtab = mod->core_num_syms;
+	mod->symtab = mod->core_symtab;
+#endif
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;
 	mod->init_size = 0;


