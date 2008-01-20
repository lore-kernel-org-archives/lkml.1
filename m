Return-Path: <linux-kernel-owner+w=401wt.eu-S1756373AbYATUJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbYATUJz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 15:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbYATUJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 15:09:14 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:39034 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811AbYATUJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 15:09:09 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linux-arch@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] kbuild: code refactoring in modpost
Date: Sun, 20 Jan 2008 21:08:58 +0100
Message-Id: <1200859743-24037-3-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <1200859743-24037-2-git-send-email-sam@ravnborg.org>
References: <20080120200527.GA23852@uranus.ravnborg.org>
 <1200859743-24037-1-git-send-email-sam@ravnborg.org>
 <1200859743-24037-2-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split a too long function up in smaller bits to make
prgram logic easier to follow.
A few related changes done due to parameter
changes.

No functional changes.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |  242 ++++++++++++++++++++++++++++---------------------
 1 files changed, 137 insertions(+), 105 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 902ee55..e463013 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -937,19 +937,19 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
 }
 
 static unsigned int *reloc_location(struct elf_info *elf,
-					   int rsection, Elf_Rela *r)
+				    Elf_Shdr *sechdr, Elf_Rela *r)
 {
 	Elf_Shdr *sechdrs = elf->sechdrs;
-	int section = sechdrs[rsection].sh_info;
+	int section = sechdr->sh_info;
 
 	return (void *)elf->hdr + sechdrs[section].sh_offset +
 		(r->r_offset - sechdrs[section].sh_addr);
 }
 
-static int addend_386_rel(struct elf_info *elf, int rsection, Elf_Rela *r)
+static int addend_386_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
 {
 	unsigned int r_typ = ELF_R_TYPE(r->r_info);
-	unsigned int *location = reloc_location(elf, rsection, r);
+	unsigned int *location = reloc_location(elf, sechdr, r);
 
 	switch (r_typ) {
 	case R_386_32:
@@ -965,7 +965,7 @@ static int addend_386_rel(struct elf_info *elf, int rsection, Elf_Rela *r)
 	return 0;
 }
 
-static int addend_arm_rel(struct elf_info *elf, int rsection, Elf_Rela *r)
+static int addend_arm_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
 {
 	unsigned int r_typ = ELF_R_TYPE(r->r_info);
 
@@ -978,8 +978,8 @@ static int addend_arm_rel(struct elf_info *elf, int rsection, Elf_Rela *r)
 	case R_ARM_PC24:
 		/* From ARM ABI: ((S + A) | T) - P */
 		r->r_addend = (int)(long)(elf->hdr +
-		              elf->sechdrs[rsection].sh_offset +
-		              (r->r_offset - elf->sechdrs[rsection].sh_addr));
+		              sechdr->sh_offset +
+		              (r->r_offset - sechdr->sh_addr));
 		break;
 	default:
 		return 1;
@@ -987,10 +987,10 @@ static int addend_arm_rel(struct elf_info *elf, int rsection, Elf_Rela *r)
 	return 0;
 }
 
-static int addend_mips_rel(struct elf_info *elf, int rsection, Elf_Rela *r)
+static int addend_mips_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
 {
 	unsigned int r_typ = ELF_R_TYPE(r->r_info);
-	unsigned int *location = reloc_location(elf, rsection, r);
+	unsigned int *location = reloc_location(elf, sechdr, r);
 	unsigned int inst;
 
 	if (r_typ == R_MIPS_HI16)
@@ -1010,6 +1010,128 @@ static int addend_mips_rel(struct elf_info *elf, int rsection, Elf_Rela *r)
 	return 0;
 }
 
+static void section_rela(const char *modname, struct elf_info *elf,
+                         Elf_Shdr *sechdr, int section(const char *),
+                         int section_ref_ok(const char *))
+{
+	Elf_Sym  *sym;
+	Elf_Rela *rela;
+	Elf_Rela r;
+	unsigned int r_sym;
+	const char *fromsec;
+	const char * tosec;
+
+	Elf_Ehdr *hdr = elf->hdr;
+	Elf_Rela *start = (void *)hdr + sechdr->sh_offset;
+	Elf_Rela *stop  = (void *)start + sechdr->sh_size;
+
+	const char *secstrings = (void *)hdr +
+				 elf->sechdrs[hdr->e_shstrndx].sh_offset;
+
+	fromsec = secstrings + sechdr->sh_name;
+	fromsec += strlen(".rela");
+	/* if from section (name) is know good then skip it */
+	if (section_ref_ok(fromsec))
+		return;
+
+	for (rela = start; rela < stop; rela++) {
+		r.r_offset = TO_NATIVE(rela->r_offset);
+#if KERNEL_ELFCLASS == ELFCLASS64
+		if (hdr->e_machine == EM_MIPS) {
+			unsigned int r_typ;
+			r_sym = ELF64_MIPS_R_SYM(rela->r_info);
+			r_sym = TO_NATIVE(r_sym);
+			r_typ = ELF64_MIPS_R_TYPE(rela->r_info);
+			r.r_info = ELF64_R_INFO(r_sym, r_typ);
+		} else {
+			r.r_info = TO_NATIVE(rela->r_info);
+			r_sym = ELF_R_SYM(r.r_info);
+		}
+#else
+		r.r_info = TO_NATIVE(rela->r_info);
+		r_sym = ELF_R_SYM(r.r_info);
+#endif
+		r.r_addend = TO_NATIVE(rela->r_addend);
+		sym = elf->symtab_start + r_sym;
+		/* Skip special sections */
+		if (sym->st_shndx >= SHN_LORESERVE)
+			continue;
+
+		tosec = secstrings +
+			elf->sechdrs[sym->st_shndx].sh_name;
+		if (section(tosec))
+			warn_sec_mismatch(modname, fromsec, elf, sym, r);
+	}
+}
+
+static void section_rel(const char *modname, struct elf_info *elf,
+                        Elf_Shdr *sechdr, int section(const char *),
+                        int section_ref_ok(const char *))
+{
+	Elf_Sym *sym;
+	Elf_Rel *rel;
+	Elf_Rela r;
+	unsigned int r_sym;
+	const char *fromsec;
+	const char * tosec;
+
+	Elf_Ehdr *hdr = elf->hdr;
+	Elf_Rel *start = (void *)hdr + sechdr->sh_offset;
+	Elf_Rel *stop  = (void *)start + sechdr->sh_size;
+
+	const char *secstrings = (void *)hdr +
+				 elf->sechdrs[hdr->e_shstrndx].sh_offset;
+
+	fromsec = secstrings + sechdr->sh_name;
+	fromsec += strlen(".rel");
+	/* if from section (name) is know good then skip it */
+	if (section_ref_ok(fromsec))
+		return;
+
+	for (rel = start; rel < stop; rel++) {
+		r.r_offset = TO_NATIVE(rel->r_offset);
+#if KERNEL_ELFCLASS == ELFCLASS64
+		if (hdr->e_machine == EM_MIPS) {
+			unsigned int r_typ;
+			r_sym = ELF64_MIPS_R_SYM(rel->r_info);
+			r_sym = TO_NATIVE(r_sym);
+			r_typ = ELF64_MIPS_R_TYPE(rel->r_info);
+			r.r_info = ELF64_R_INFO(r_sym, r_typ);
+		} else {
+			r.r_info = TO_NATIVE(rel->r_info);
+			r_sym = ELF_R_SYM(r.r_info);
+		}
+#else
+		r.r_info = TO_NATIVE(rel->r_info);
+		r_sym = ELF_R_SYM(r.r_info);
+#endif
+		r.r_addend = 0;
+		switch (hdr->e_machine) {
+		case EM_386:
+			if (addend_386_rel(elf, sechdr, &r))
+				continue;
+			break;
+		case EM_ARM:
+			if (addend_arm_rel(elf, sechdr, &r))
+				continue;
+			break;
+		case EM_MIPS:
+			if (addend_mips_rel(elf, sechdr, &r))
+				continue;
+			break;
+		}
+		sym = elf->symtab_start + r_sym;
+		/* Skip special sections */
+		if (sym->st_shndx >= SHN_LORESERVE)
+			continue;
+
+		tosec = secstrings +
+			elf->sechdrs[sym->st_shndx].sh_name;
+		if (section(tosec))
+			warn_sec_mismatch(modname, fromsec, elf, sym, r);
+	}
+}
+
 /**
  * A module includes a number of sections that are discarded
  * either when loaded or when used as built-in.
@@ -1028,108 +1150,18 @@ static void check_sec_ref(struct module *mod, const char *modname,
 			  int section_ref_ok(const char *))
 {
 	int i;
-	Elf_Sym  *sym;
 	Elf_Ehdr *hdr = elf->hdr;
 	Elf_Shdr *sechdrs = elf->sechdrs;
-	const char *secstrings = (void *)hdr +
-				 sechdrs[hdr->e_shstrndx].sh_offset;
 
 	/* Walk through all sections */
 	for (i = 0; i < hdr->e_shnum; i++) {
-		const char *name = secstrings + sechdrs[i].sh_name;
-		const char *secname;
-		Elf_Rela r;
-		unsigned int r_sym;
 		/* We want to process only relocation sections and not .init */
-		if (sechdrs[i].sh_type == SHT_RELA) {
-			Elf_Rela *rela;
-			Elf_Rela *start = (void *)hdr + sechdrs[i].sh_offset;
-			Elf_Rela *stop  = (void *)start + sechdrs[i].sh_size;
-			name += strlen(".rela");
-			if (section_ref_ok(name))
-				continue;
-
-			for (rela = start; rela < stop; rela++) {
-				r.r_offset = TO_NATIVE(rela->r_offset);
-#if KERNEL_ELFCLASS == ELFCLASS64
-				if (hdr->e_machine == EM_MIPS) {
-					unsigned int r_typ;
-					r_sym = ELF64_MIPS_R_SYM(rela->r_info);
-					r_sym = TO_NATIVE(r_sym);
-					r_typ = ELF64_MIPS_R_TYPE(rela->r_info);
-					r.r_info = ELF64_R_INFO(r_sym, r_typ);
-				} else {
-					r.r_info = TO_NATIVE(rela->r_info);
-					r_sym = ELF_R_SYM(r.r_info);
-				}
-#else
-				r.r_info = TO_NATIVE(rela->r_info);
-				r_sym = ELF_R_SYM(r.r_info);
-#endif
-				r.r_addend = TO_NATIVE(rela->r_addend);
-				sym = elf->symtab_start + r_sym;
-				/* Skip special sections */
-				if (sym->st_shndx >= SHN_LORESERVE)
-					continue;
-
-				secname = secstrings +
-					sechdrs[sym->st_shndx].sh_name;
-				if (section(secname))
-					warn_sec_mismatch(modname, name,
-							  elf, sym, r);
-			}
-		} else if (sechdrs[i].sh_type == SHT_REL) {
-			Elf_Rel *rel;
-			Elf_Rel *start = (void *)hdr + sechdrs[i].sh_offset;
-			Elf_Rel *stop  = (void *)start + sechdrs[i].sh_size;
-			name += strlen(".rel");
-			if (section_ref_ok(name))
-				continue;
-
-			for (rel = start; rel < stop; rel++) {
-				r.r_offset = TO_NATIVE(rel->r_offset);
-#if KERNEL_ELFCLASS == ELFCLASS64
-				if (hdr->e_machine == EM_MIPS) {
-					unsigned int r_typ;
-					r_sym = ELF64_MIPS_R_SYM(rel->r_info);
-					r_sym = TO_NATIVE(r_sym);
-					r_typ = ELF64_MIPS_R_TYPE(rel->r_info);
-					r.r_info = ELF64_R_INFO(r_sym, r_typ);
-				} else {
-					r.r_info = TO_NATIVE(rel->r_info);
-					r_sym = ELF_R_SYM(r.r_info);
-				}
-#else
-				r.r_info = TO_NATIVE(rel->r_info);
-				r_sym = ELF_R_SYM(r.r_info);
-#endif
-				r.r_addend = 0;
-				switch (hdr->e_machine) {
-				case EM_386:
-					if (addend_386_rel(elf, i, &r))
-						continue;
-					break;
-				case EM_ARM:
-					if (addend_arm_rel(elf, i, &r))
-						continue;
-					break;
-				case EM_MIPS:
-					if (addend_mips_rel(elf, i, &r))
-						continue;
-					break;
-				}
-				sym = elf->symtab_start + r_sym;
-				/* Skip special sections */
-				if (sym->st_shndx >= SHN_LORESERVE)
-					continue;
-
-				secname = secstrings +
-					sechdrs[sym->st_shndx].sh_name;
-				if (section(secname))
-					warn_sec_mismatch(modname, name,
-							  elf, sym, r);
-			}
-		}
+		if (sechdrs[i].sh_type == SHT_RELA)
+			section_rela(modname, elf, &elf->sechdrs[i],
+			             section, section_ref_ok);
+		else if (sechdrs[i].sh_type == SHT_REL)
+			section_rel(modname, elf, &elf->sechdrs[i],
+			            section, section_ref_ok);
 	}
 }
 
-- 
1.5.4.rc3.14.g44397

