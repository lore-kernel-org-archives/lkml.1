Return-Path: <linux-kernel-owner+w=401wt.eu-S1765496AbXEVJ2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765496AbXEVJ2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755735AbXEVJ1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:27:52 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:4809 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754979AbXEVJ1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:27:51 -0400
Date: Tue, 22 May 2007 18:27:39 +0900 (JST)
Message-Id: <20070522.182739.48825006.nemoto@toshiba-tops.co.jp>
To: torvalds@linux-foundation.org
Cc: ben.collins@ubuntu.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sam@ravnborg.org, dwmw2@infradead.org,
       adobriyan@gmail.com
Subject: Re: [RFC] Crash on modpost, addend_386_rel()
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20070522.142929.05161433.nemoto@toshiba-tops.co.jp>
References: <20070522.134015.65004318.nemoto@toshiba-tops.co.jp>
	<alpine.LFD.0.98.0705212150000.3890@woody.linux-foundation.org>
	<20070522.142929.05161433.nemoto@toshiba-tops.co.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 14:29:29 +0900 (JST), Atsushi Nemoto <nemoto@toshiba-tops.co.jp> wrote:
> Subject: [PATCH] kbuild: make better section mismatch reports on i386, arm and mips (take 3)

Updated again to get a little bit better report on i386 relocatable
vmlinux.


Subject: [PATCH] kbuild: make better section mismatch reports on i386, arm and mips (take 4)

On i386, ARM and MIPS, warn_sec_mismatch() sometimes fails to show
usefull symbol name.  This is because empty 'refsym' due to 0 r_addend
value.  This patch is to adjust r_addend value, consulting with
apply_relocate() routine in kernel code.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 8e5610d..760b2b3 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -374,6 +374,7 @@ static int parse_elf(struct elf_info *info, const char *filename)
 	hdr->e_shstrndx = TO_NATIVE(hdr->e_shstrndx);
 	hdr->e_shnum    = TO_NATIVE(hdr->e_shnum);
 	hdr->e_machine  = TO_NATIVE(hdr->e_machine);
+	hdr->e_type     = TO_NATIVE(hdr->e_type);
 	sechdrs = (void *)hdr + hdr->e_shoff;
 	info->sechdrs = sechdrs;
 
@@ -384,6 +385,8 @@ static int parse_elf(struct elf_info *info, const char *filename)
 		sechdrs[i].sh_size   = TO_NATIVE(sechdrs[i].sh_size);
 		sechdrs[i].sh_link   = TO_NATIVE(sechdrs[i].sh_link);
 		sechdrs[i].sh_name   = TO_NATIVE(sechdrs[i].sh_name);
+		sechdrs[i].sh_info   = TO_NATIVE(sechdrs[i].sh_info);
+		sechdrs[i].sh_addr   = TO_NATIVE(sechdrs[i].sh_addr);
 	}
 	/* Find symbol table. */
 	for (i = 1; i < hdr->e_shnum; i++) {
@@ -753,6 +756,8 @@ static Elf_Sym *find_elf_symbol(struct elf_info *elf, Elf_Addr addr,
 	for (sym = elf->symtab_start; sym < elf->symtab_stop; sym++) {
 		if (sym->st_shndx != relsym->st_shndx)
 			continue;
+		if (ELF_ST_TYPE(sym->st_info) == STT_SECTION)
+			continue;
 		if (sym->st_value == addr)
 			return sym;
 	}
@@ -895,6 +900,72 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
 	}
 }
 
+static inline unsigned int *reloc_location(struct elf_info *elf,
+					   int rsection, Elf_Rela *r)
+{
+	Elf_Shdr *sechdrs = elf->sechdrs;
+	int section = sechdrs[rsection].sh_info;
+
+	return (void *)elf->hdr + sechdrs[section].sh_offset +
+		(r->r_offset - sechdrs[section].sh_addr);
+}
+
+static void addend_386_rel(struct elf_info *elf, int rsection, Elf_Rela *r)
+{
+	unsigned int r_typ = ELF_R_TYPE(r->r_info);
+	unsigned int *location = reloc_location(elf, rsection, r);
+
+	switch (r_typ) {
+	case R_386_32:
+		r->r_addend = TO_NATIVE(*location);
+		break;
+	case R_386_PC32:
+		r->r_addend = TO_NATIVE(*location) + 4;
+		/* For CONFIG_RELOCATABLE=y */
+		if (elf->hdr->e_type == ET_EXEC)
+			r->r_addend += r->r_offset;
+		break;
+	}
+}
+
+static void addend_arm_rel(struct elf_info *elf, int rsection, Elf_Rela *r)
+{
+	unsigned int r_typ = ELF_R_TYPE(r->r_info);
+	unsigned int *location = reloc_location(elf, rsection, r);
+
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
+static int addend_mips_rel(struct elf_info *elf, int rsection, Elf_Rela *r)
+{
+	unsigned int r_typ = ELF_R_TYPE(r->r_info);
+	unsigned int *location = reloc_location(elf, rsection, r);
+	unsigned int inst;
+
+	if (r_typ == R_MIPS_HI16)
+		return 1;	/* skip this */
+	inst = TO_NATIVE(*location);
+	switch (r_typ) {
+	case R_MIPS_LO16:
+		r->r_addend = inst & 0xffff;
+		break;
+	case R_MIPS_26:
+		r->r_addend = (inst & 0x03ffffff) << 2;
+		break;
+	case R_MIPS_32:
+		r->r_addend = inst;
+		break;
+	}
+	return 0;
+}
+
 /**
  * A module includes a number of sections that are discarded
  * either when loaded or when used as built-in.
@@ -938,8 +1009,11 @@ static void check_sec_ref(struct module *mod, const char *modname,
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
@@ -972,8 +1046,11 @@ static void check_sec_ref(struct module *mod, const char *modname,
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
@@ -983,6 +1060,14 @@ static void check_sec_ref(struct module *mod, const char *modname,
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
