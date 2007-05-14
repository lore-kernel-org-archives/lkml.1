Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbXENPka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbXENPka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 11:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbXENPkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 11:40:24 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:52355 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbXENPkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 11:40:23 -0400
Date: Tue, 15 May 2007 00:40:35 +0900 (JST)
Message-Id: <20070515.004035.21363504.anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, ralf@linux-mips.org
Subject: [PATCH] kbuild: make better section mismatch reports on i386 and
 mips
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On i386 and MIPS, warn_sec_mismatch() sometimes fails to show usefull
symbol name.  This is because empty 'refsym' due to 0 r_addend value.
This patch is to adjust r_addend value, consulting with
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
---
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 113dc77..459ac2e 100644
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
@@ -911,6 +912,51 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
 	}
 }
 
+static void addend_386_rel(struct elf_info *elf,
+			   int section, Elf_Rela *r)
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
+static int addend_mips_rel(struct elf_info *elf,
+			   int section, Elf_Rela *r)
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
@@ -954,8 +1000,11 @@ static void check_sec_ref(struct module *mod, const char *modname,
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
@@ -988,8 +1037,11 @@ static void check_sec_ref(struct module *mod, const char *modname,
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
@@ -999,6 +1051,12 @@ static void check_sec_ref(struct module *mod, const char *modname,
 				r_sym = ELF_R_SYM(r.r_info);
 #endif
 				r.r_addend = 0;
+				if (hdr->e_machine == EM_386)
+					addend_386_rel(elf, i, &r);
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
