Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbXEVF4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbXEVF4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 01:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbXEVF4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 01:56:31 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:61854 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755889AbXEVF4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 01:56:30 -0400
X-Greylist: delayed 1618 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2007 01:56:30 EDT
Date: Tue, 22 May 2007 14:29:29 +0900 (JST)
Message-Id: <20070522.142929.05161433.nemoto@toshiba-tops.co.jp>
From: Atsushi Nemoto <nemoto@toshiba-tops.co.jp>
To: torvalds@linux-foundation.org
Cc: ben.collins@ubuntu.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sam@ravnborg.org, dwmw2@infradead.org,
       adobriyan@gmail.com
Subject: Re: [RFC] Crash on modpost, addend_386_rel()
In-Reply-To: <alpine.LFD.0.98.0705212150000.3890@woody.linux-foundation.org>
References: <1179799287.7485.17.camel@cunning>
	<20070522.134015.65004318.nemoto@toshiba-tops.co.jp>
	<alpine.LFD.0.98.0705212150000.3890@woody.linux-foundation.org>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 21:52:59 -0700 (PDT), Linus Torvalds <torvalds@linux-foundation.org> wrote:
> Would you mind also just making this whole logic (that is generic and 
> shared with all the different arch versions) be an inline function of its 
> own? 
> 
> > +	Elf_Shdr *sechdrs = elf->sechdrs;
> > +	unsigned int *location;
> > +	int section = sechdrs[rsection].sh_info;
> > +
> > +	location = (void *)elf->hdr + sechdrs[section].sh_offset +
> > +		(r->r_offset - sechdrs[section].sh_addr);
> 
> so that all the functions could just use some generic
> 
> 	location = reloc_location(elf, rsection, r);
> 
> or similar, instead of having that complex thing duplicated three times 
> (arm, mips and i386)?

Sure, updated.

> Especially since other architectures will likely end up doing the same 
> thing too...

Archs using RELA instead of REL section are not affected by this
patch.  But I'm not sure how many are using RELA.


Subject: [PATCH] kbuild: make better section mismatch reports on i386, arm and mips (take 3)

On i386, ARM and MIPS, warn_sec_mismatch() sometimes fails to show
usefull symbol name.  This is because empty 'refsym' due to 0 r_addend
value.  This patch is to adjust r_addend value, consulting with
apply_relocate() routine in kernel code.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 8e5610d..44c3960 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -384,6 +384,8 @@ static int parse_elf(struct elf_info *info, const char *filename)
 		sechdrs[i].sh_size   = TO_NATIVE(sechdrs[i].sh_size);
 		sechdrs[i].sh_link   = TO_NATIVE(sechdrs[i].sh_link);
 		sechdrs[i].sh_name   = TO_NATIVE(sechdrs[i].sh_name);
+		sechdrs[i].sh_info   = TO_NATIVE(sechdrs[i].sh_info);
+		sechdrs[i].sh_addr   = TO_NATIVE(sechdrs[i].sh_addr);
 	}
 	/* Find symbol table. */
 	for (i = 1; i < hdr->e_shnum; i++) {
@@ -753,6 +755,8 @@ static Elf_Sym *find_elf_symbol(struct elf_info *elf, Elf_Addr addr,
 	for (sym = elf->symtab_start; sym < elf->symtab_stop; sym++) {
 		if (sym->st_shndx != relsym->st_shndx)
 			continue;
+		if (ELF_ST_TYPE(sym->st_info) == STT_SECTION)
+			continue;
 		if (sym->st_value == addr)
 			return sym;
 	}
@@ -895,6 +899,69 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
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
@@ -938,8 +1005,11 @@ static void check_sec_ref(struct module *mod, const char *modname,
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
@@ -972,8 +1042,11 @@ static void check_sec_ref(struct module *mod, const char *modname,
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
@@ -983,6 +1056,14 @@ static void check_sec_ref(struct module *mod, const char *modname,
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
