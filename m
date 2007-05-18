Return-Path: <linux-kernel-owner+w=401wt.eu-S1761754AbXERGtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761754AbXERGtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbXERGt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:49:28 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:33433 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119AbXERGt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:49:27 -0400
Date: Fri, 18 May 2007 08:50:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: [PATCH 02/14] kbuild: make better section mismatch reports on i386, arm and mips
Message-ID: <20070518065024.GB12284@uranus.ravnborg.org>
References: <20070518064126.GA12193@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518064126.GA12193@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 41fa40aeb2314458b25dd2227dc71fdecb504e5e Mon Sep 17 00:00:00 2001
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Date: Thu, 17 May 2007 01:14:38 +0900
Subject: [PATCH 02/14] kbuild: make better section mismatch reports on i386, arm and mips

On i386, ARM and MIPS, warn_sec_mismatch() sometimes fails to show
usefull symbol name.  This is because empty 'refsym' due to 0 r_addend
value.  This patch is to adjust r_addend value, consulting with
apply_relocate() routine in kernel code.

Without this patch:
  MODPOST vmlinux
WARNING: init/built-in.o - Section mismatch: reference to .init.text: from .text between 'rest_init' (at offset 0xf4) and 'try_name'
WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text between 'kmem_cache_create' (at offset 0x18a39) and 'cache_reap'
WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text between 'kmem_cache_create' (at offset 0x18a6b) and 'cache_reap'

With this patch:
  MODPOST vmlinux
WARNING: mm/built-in.o - Section mismatch: reference to .init.text:set_up_list3s from .text between 'kmem_cache_create' (at offset 0x18a39) and 'cache_reap'
WARNING: mm/built-in.o - Section mismatch: reference to .init.text:set_up_list3s from .text between 'kmem_cache_create' (at offset 0x18a6b) and 'cache_reap'

Now modpost can detect "kernel_init" name (and whitelist it) and show
"set_up_list3s" name.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |   79 +++++++++++++++++++++++++++++++++++++++++++++++++
 scripts/mod/modpost.h |    3 ++
 2 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index acd28ab..ecb0a15 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -384,6 +384,7 @@ static int parse_elf(struct elf_info *info, const char *filename)
 		sechdrs[i].sh_size   = TO_NATIVE(sechdrs[i].sh_size);
 		sechdrs[i].sh_link   = TO_NATIVE(sechdrs[i].sh_link);
 		sechdrs[i].sh_name   = TO_NATIVE(sechdrs[i].sh_name);
+		sechdrs[i].sh_info   = TO_NATIVE(sechdrs[i].sh_info);
 	}
 	/* Find symbol table. */
 	for (i = 1; i < hdr->e_shnum; i++) {
@@ -773,6 +774,8 @@ static Elf_Sym *find_elf_symbol(struct elf_info *elf, Elf_Addr addr,
 	for (sym = elf->symtab_start; sym < elf->symtab_stop; sym++) {
 		if (sym->st_shndx != relsym->st_shndx)
 			continue;
+		if (ELF_ST_TYPE(sym->st_info) == STT_SECTION)
+			continue;
 		if (sym->st_value == addr)
 			return sym;
 	}
@@ -910,6 +913,68 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
 	}
 }
 
+static void addend_386_rel(struct elf_info *elf, int section, Elf_Rela *r)
+{
+	Elf_Shdr *sechdrs = elf->sechdrs;
+	unsigned int r_typ;
+	unsigned int *location;
+
+	r_typ = ELF_R_TYPE(r->r_info);
+	location = (void *)elf->hdr +
+		sechdrs[sechdrs[section].sh_info].sh_offset + r->r_offset;
+	switch (r_typ) {
+	case R_386_32:
+		r->r_addend = TO_NATIVE(*location);
+		break;
+	case R_386_PC32:
+		r->r_addend = TO_NATIVE(*location) + 4;
+		break;
+	}
+}
+
+static void addend_arm_rel(struct elf_info *elf, int section, Elf_Rela *r)
+{
+	Elf_Shdr *sechdrs = elf->sechdrs;
+	unsigned int r_typ;
+	unsigned int *location;
+
+	r_typ = ELF_R_TYPE(r->r_info);
+	location = (void *)elf->hdr +
+		sechdrs[sechdrs[section].sh_info].sh_offset + r->r_offset;
+	switch (r_typ) {
+	case R_ARM_ABS32:
+		r->r_addend = TO_NATIVE(*location);
+		break;
+	case R_ARM_PC24:
+		r->r_addend = ((TO_NATIVE(*location) & 0x00ffffff) << 2) + 8;
+		break;
+	}
+}
+
+static int addend_mips_rel(struct elf_info *elf, int section, Elf_Rela *r)
+{
+	Elf_Shdr *sechdrs = elf->sechdrs;
+	unsigned int r_typ;
+	unsigned int *location;
+	unsigned int inst;
+
+	r_typ = ELF_R_TYPE(r->r_info);
+	if (r_typ == R_MIPS_HI16)
+		return 1;	/* skip this */
+	location = (void *)elf->hdr +
+		sechdrs[sechdrs[section].sh_info].sh_offset + r->r_offset;
+	inst = TO_NATIVE(*location);
+	switch (r_typ) {
+	case R_MIPS_LO16:
+		r->r_addend = ((inst & 0xffff) ^ 0x8000) - 0x8000;
+		break;
+	case R_MIPS_26:
+		r->r_addend = (inst & 0x03ffffff) << 2;
+		break;
+	}
+	return 0;
+}
+
 /**
  * A module includes a number of sections that are discarded
  * either when loaded or when used as built-in.
@@ -953,8 +1018,11 @@ static void check_sec_ref(struct module *mod, const char *modname,
 				r.r_offset = TO_NATIVE(rela->r_offset);
 #if KERNEL_ELFCLASS == ELFCLASS64
 				if (hdr->e_machine == EM_MIPS) {
+					unsigned int r_typ;
 					r_sym = ELF64_MIPS_R_SYM(rela->r_info);
 					r_sym = TO_NATIVE(r_sym);
+					r_typ = ELF64_MIPS_R_TYPE(rela->r_info);
+					r.r_info = ELF64_R_INFO(r_sym, r_typ);
 				} else {
 					r.r_info = TO_NATIVE(rela->r_info);
 					r_sym = ELF_R_SYM(r.r_info);
@@ -987,8 +1055,11 @@ static void check_sec_ref(struct module *mod, const char *modname,
 				r.r_offset = TO_NATIVE(rel->r_offset);
 #if KERNEL_ELFCLASS == ELFCLASS64
 				if (hdr->e_machine == EM_MIPS) {
+					unsigned int r_typ;
 					r_sym = ELF64_MIPS_R_SYM(rel->r_info);
 					r_sym = TO_NATIVE(r_sym);
+					r_typ = ELF64_MIPS_R_TYPE(rel->r_info);
+					r.r_info = ELF64_R_INFO(r_sym, r_typ);
 				} else {
 					r.r_info = TO_NATIVE(rel->r_info);
 					r_sym = ELF_R_SYM(r.r_info);
@@ -998,6 +1069,14 @@ static void check_sec_ref(struct module *mod, const char *modname,
 				r_sym = ELF_R_SYM(r.r_info);
 #endif
 				r.r_addend = 0;
+				if (hdr->e_machine == EM_386)
+					addend_386_rel(elf, i, &r);
+				else if (hdr->e_machine == EM_ARM)
+					addend_arm_rel(elf, i, &r);
+				else if (hdr->e_machine == EM_MIPS) {
+					if (addend_mips_rel(elf, i, &r))
+						continue;
+				}
 				sym = elf->symtab_start + r_sym;
 				/* Skip special sections */
 				if (sym->st_shndx >= SHN_LORESERVE)
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 0858caa..4156dd3 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -60,6 +60,9 @@ typedef union
 #define ELF64_MIPS_R_SYM(i) \
   ((__extension__ (_Elf64_Mips_R_Info_union)(i)).r_info_fields.r_sym)
 
+#define ELF64_MIPS_R_TYPE(i) \
+  ((__extension__ (_Elf64_Mips_R_Info_union)(i)).r_info_fields.r_type1)
+
 #if KERNEL_ELFDATA != HOST_ELFDATA
 
 static inline void __endian(const void *src, void *dest, unsigned int size)
-- 
1.5.1.rc3.20.gaa453

