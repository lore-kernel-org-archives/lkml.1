Return-Path: <linux-kernel-owner+w=401wt.eu-S1758389AbZDEXPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389AbZDEXPu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 19:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbZDEXPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 19:15:41 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55934 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753573AbZDEXPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 19:15:40 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>
Subject: [PATCH v2 3/4] modpost: Support objects with more than 64k sections
Date: Sun,  5 Apr 2009 19:14:37 -0400
Message-Id: <1238973278-31735-4-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1238973278-31735-3-git-send-email-tabbott@mit.edu>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu>
 <1238973278-31735-2-git-send-email-tabbott@mit.edu>
 <1238973278-31735-3-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <vda.linux@googlemail.com>

This patch makes modpost able to process object files with more than
64k sections. Needed for huge kernel builds (allyesconfig, for example)
with -ffunction-sections.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
[andersk@mit.edu: updated for 2.6.29]
Signed-off-by: Anders Kaseorg <andersk@mit.edu>
---
 scripts/mod/file2alias.c |    6 +-
 scripts/mod/modpost.c    |   94 ++++++++++++++++++++++++++++++++-------------
 scripts/mod/modpost.h    |   43 +++++++++++++++++++++
 3 files changed, 113 insertions(+), 30 deletions(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index a334428..49c669e 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -761,16 +761,16 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 	char *zeros = NULL;
 
 	/* We're looking for a section relative symbol */
-	if (!sym->st_shndx || sym->st_shndx >= info->hdr->e_shnum)
+	if (!sym->st_shndx || get_secindex(info, sym) >= info->num_sections)
 		return;
 
 	/* Handle all-NULL symbols allocated into .bss */
-	if (info->sechdrs[sym->st_shndx].sh_type & SHT_NOBITS) {
+	if (info->sechdrs[get_secindex(info, sym)].sh_type & SHT_NOBITS) {
 		zeros = calloc(1, sym->st_size);
 		symval = zeros;
 	} else {
 		symval = (void *)info->hdr
-			+ info->sechdrs[sym->st_shndx].sh_offset
+			+ info->sechdrs[get_secindex(info, sym)].sh_offset
 			+ sym->st_value;
 	}
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 41c2229..6bb55a4 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -244,7 +244,7 @@ static enum export export_no(const char *s)
 	return export_unknown;
 }
 
-static enum export export_from_sec(struct elf_info *elf, Elf_Section sec)
+static enum export export_from_sec(struct elf_info *elf, unsigned int sec)
 {
 	if (sec == elf->export_sec)
 		return export_plain;
@@ -364,6 +364,8 @@ static int parse_elf(struct elf_info *info, const char *filename)
 	Elf_Ehdr *hdr;
 	Elf_Shdr *sechdrs;
 	Elf_Sym  *sym;
+	const char *secstrings;
+	unsigned int symtab_idx = ~0U, symtab_shndx_idx = ~0U;
 
 	hdr = grab_file(filename, &info->size);
 	if (!hdr) {
@@ -400,8 +402,19 @@ static int parse_elf(struct elf_info *info, const char *filename)
 		return 0;
 	}
 
+	/* Fixups for more than 64k sections */
+	info->num_sections = hdr->e_shnum;
+	if (info->num_sections == 0) { /* more than 64k sections? */
+		/* doesn't need shndx2secindex() */
+		info->num_sections = TO_NATIVE(sechdrs[0].sh_size);
+	}
+	info->secindex_strings = hdr->e_shstrndx;
+	if (info->secindex_strings == SHN_XINDEX)
+		info->secindex_strings =
+		    shndx2secindex(TO_NATIVE(sechdrs[0].sh_link));
+
 	/* Fix endianness in section headers */
-	for (i = 0; i < hdr->e_shnum; i++) {
+	for (i = 0; i < info->num_sections; i++) {
 		sechdrs[i].sh_type   = TO_NATIVE(sechdrs[i].sh_type);
 		sechdrs[i].sh_offset = TO_NATIVE(sechdrs[i].sh_offset);
 		sechdrs[i].sh_size   = TO_NATIVE(sechdrs[i].sh_size);
@@ -411,9 +424,8 @@ static int parse_elf(struct elf_info *info, const char *filename)
 		sechdrs[i].sh_addr   = TO_NATIVE(sechdrs[i].sh_addr);
 	}
 	/* Find symbol table. */
-	for (i = 1; i < hdr->e_shnum; i++) {
-		const char *secstrings
-			= (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
+	secstrings = (void *)hdr + sechdrs[info->secindex_strings].sh_offset;
+	for (i = 1; i < info->num_sections; i++) {
 		const char *secname;
 		int nobits = sechdrs[i].sh_type == SHT_NOBITS;
 
@@ -443,14 +455,24 @@ static int parse_elf(struct elf_info *info, const char *filename)
 		else if (strcmp(secname, "__markers_strings") == 0)
 			info->markers_strings_sec = i;
 
-		if (sechdrs[i].sh_type != SHT_SYMTAB)
-			continue;
+		if (sechdrs[i].sh_type == SHT_SYMTAB) {
+			symtab_idx = i;
+			info->symtab_start = (void *)hdr +
+			    sechdrs[i].sh_offset;
+			info->symtab_stop  = (void *)hdr +
+			    sechdrs[i].sh_offset + sechdrs[i].sh_size;
+			info->strtab       = (void *)hdr +
+			    sechdrs[shndx2secindex(sechdrs[i].sh_link)].sh_offset;
+		}
 
-		info->symtab_start = (void *)hdr + sechdrs[i].sh_offset;
-		info->symtab_stop  = (void *)hdr + sechdrs[i].sh_offset
-			                         + sechdrs[i].sh_size;
-		info->strtab       = (void *)hdr +
-			             sechdrs[sechdrs[i].sh_link].sh_offset;
+		/* 32bit section no. table? ("more than 64k sections") */
+		if (sechdrs[i].sh_type == SHT_SYMTAB_SHNDX) {
+			symtab_shndx_idx = i;
+			info->symtab_shndx_start = (void *)hdr +
+			    sechdrs[i].sh_offset;
+			info->symtab_shndx_stop  = (void *)hdr +
+			    sechdrs[i].sh_offset + sechdrs[i].sh_size;
+		}
 	}
 	if (!info->symtab_start)
 		fatal("%s has no symtab?\n", filename);
@@ -462,6 +484,21 @@ static int parse_elf(struct elf_info *info, const char *filename)
 		sym->st_value = TO_NATIVE(sym->st_value);
 		sym->st_size  = TO_NATIVE(sym->st_size);
 	}
+
+	if (symtab_shndx_idx != ~0U) {
+		Elf32_Word *p;
+		if (symtab_idx !=
+		    shndx2secindex(sechdrs[symtab_shndx_idx].sh_link))
+			fatal("%s: SYMTAB_SHNDX has bad sh_link: %u!=%u\n",
+			      filename,
+			      shndx2secindex(sechdrs[symtab_shndx_idx].sh_link),
+			      symtab_idx);
+		/* Fix endianness */
+		for (p = info->symtab_shndx_start; p < info->symtab_shndx_stop;
+		     p++)
+			*p = TO_NATIVE(*p);
+	}
+
 	return 1;
 }
 
@@ -496,7 +533,7 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
 			       Elf_Sym *sym, const char *symname)
 {
 	unsigned int crc;
-	enum export export = export_from_sec(info, sym->st_shndx);
+	enum export export = export_from_sec(info, get_secindex(info, sym));
 
 	switch (sym->st_shndx) {
 	case SHN_COMMON:
@@ -638,18 +675,18 @@ static const char *sym_name(struct elf_info *elf, Elf_Sym *sym)
 		return "(unknown)";
 }
 
-static const char *sec_name(struct elf_info *elf, int shndx)
+static const char *sec_name(struct elf_info *elf, int secindex)
 {
 	Elf_Shdr *sechdrs = elf->sechdrs;
 	return (void *)elf->hdr +
-	        elf->sechdrs[elf->hdr->e_shstrndx].sh_offset +
-	        sechdrs[shndx].sh_name;
+	        elf->sechdrs[elf->secindex_strings].sh_offset +
+	        sechdrs[secindex].sh_name;
 }
 
 static const char *sech_name(struct elf_info *elf, Elf_Shdr *sechdr)
 {
 	return (void *)elf->hdr +
-	        elf->sechdrs[elf->hdr->e_shstrndx].sh_offset +
+	        elf->sechdrs[elf->secindex_strings].sh_offset +
 	        sechdr->sh_name;
 }
 
@@ -986,11 +1023,14 @@ static Elf_Sym *find_elf_symbol(struct elf_info *elf, Elf64_Sword addr,
 	Elf_Sym *near = NULL;
 	Elf64_Sword distance = 20;
 	Elf64_Sword d;
+	unsigned int relsym_secindex;
 
 	if (relsym->st_name != 0)
 		return relsym;
+
+	relsym_secindex = get_secindex(elf, relsym);
 	for (sym = elf->symtab_start; sym < elf->symtab_stop; sym++) {
-		if (sym->st_shndx != relsym->st_shndx)
+		if (get_secindex(elf, sym) != relsym_secindex)
 			continue;
 		if (ELF_ST_TYPE(sym->st_info) == STT_SECTION)
 			continue;
@@ -1052,9 +1092,9 @@ static Elf_Sym *find_elf_symbol2(struct elf_info *elf, Elf_Addr addr,
 	for (sym = elf->symtab_start; sym < elf->symtab_stop; sym++) {
 		const char *symsec;
 
-		if (sym->st_shndx >= SHN_LORESERVE)
+		if (is_shndx_special(sym->st_shndx))
 			continue;
-		symsec = sec_name(elf, sym->st_shndx);
+		symsec = sec_name(elf, get_secindex(elf, sym));
 		if (strcmp(symsec, sec) != 0)
 			continue;
 		if (!is_valid_name(elf, sym))
@@ -1251,7 +1291,7 @@ static void check_section_mismatch(const char *modname, struct elf_info *elf,
 	const char *tosec;
 	enum mismatch mismatch;
 
-	tosec = sec_name(elf, sym->st_shndx);
+	tosec = sec_name(elf, get_secindex(elf, sym));
 	mismatch = section_mismatch(fromsec, tosec);
 	if (mismatch != NO_MISMATCH) {
 		Elf_Sym *to;
@@ -1278,7 +1318,7 @@ static unsigned int *reloc_location(struct elf_info *elf,
 				    Elf_Shdr *sechdr, Elf_Rela *r)
 {
 	Elf_Shdr *sechdrs = elf->sechdrs;
-	int section = sechdr->sh_info;
+	int section = shndx2secindex(sechdr->sh_info);
 
 	return (void *)elf->hdr + sechdrs[section].sh_offset +
 		(r->r_offset - sechdrs[section].sh_addr);
@@ -1386,7 +1426,7 @@ static void section_rela(const char *modname, struct elf_info *elf,
 		r.r_addend = TO_NATIVE(rela->r_addend);
 		sym = elf->symtab_start + r_sym;
 		/* Skip special sections */
-		if (sym->st_shndx >= SHN_LORESERVE)
+		if (is_shndx_special(sym->st_shndx))
 			continue;
 		check_section_mismatch(modname, elf, &r, sym, fromsec);
 	}
@@ -1444,7 +1484,7 @@ static void section_rel(const char *modname, struct elf_info *elf,
 		}
 		sym = elf->symtab_start + r_sym;
 		/* Skip special sections */
-		if (sym->st_shndx >= SHN_LORESERVE)
+		if (is_shndx_special(sym->st_shndx))
 			continue;
 		check_section_mismatch(modname, elf, &r, sym, fromsec);
 	}
@@ -1469,7 +1509,7 @@ static void check_sec_ref(struct module *mod, const char *modname,
 	Elf_Shdr *sechdrs = elf->sechdrs;
 
 	/* Walk through all sections */
-	for (i = 0; i < elf->hdr->e_shnum; i++) {
+	for (i = 0; i < elf->num_sections; i++) {
 		check_section(modname, elf, &elf->sechdrs[i]);
 		/* We want to process only relocation sections and not .init */
 		if (sechdrs[i].sh_type == SHT_RELA)
@@ -1499,7 +1539,7 @@ static void get_markers(struct elf_info *info, struct module *mod)
 	n = 0;
 	for (sym = info->symtab_start; sym < info->symtab_stop; sym++)
 		if (ELF_ST_TYPE(sym->st_info) == STT_OBJECT &&
-		    sym->st_shndx == info->markers_strings_sec &&
+		    get_secindex(info, sym) == info->markers_strings_sec &&
 		    !strncmp(info->strtab + sym->st_name,
 			     "__mstrtab_", sizeof "__mstrtab_" - 1)) {
 			if (first_sym == NULL)
@@ -1523,7 +1563,7 @@ static void get_markers(struct elf_info *info, struct module *mod)
 	n = 0;
 	for (sym = first_sym; sym <= last_sym; sym++)
 		if (ELF_ST_TYPE(sym->st_info) == STT_OBJECT &&
-		    sym->st_shndx == info->markers_strings_sec &&
+		    get_secindex(info, sym) == info->markers_strings_sec &&
 		    !strncmp(info->strtab + sym->st_name,
 			     "__mstrtab_", sizeof "__mstrtab_" - 1)) {
 			const char *name = strings + sym->st_value;
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 09f58e3..dbde650 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -132,8 +132,51 @@ struct elf_info {
 	const char   *strtab;
 	char	     *modinfo;
 	unsigned int modinfo_len;
+
+	/* support for 32bit section numbers */
+
+	unsigned int num_sections; /* max_secindex + 1 */
+	unsigned int secindex_strings;
+	/* if Nth symbol table entry has .st_shndx = SHN_XINDEX,
+	 * take shndx from symtab_shndx_start[N] instead */
+	Elf32_Word   *symtab_shndx_start;
+	Elf32_Word   *symtab_shndx_stop;
 };
 
+static inline int is_shndx_special(unsigned int i)
+{
+	return i != SHN_XINDEX && i >= SHN_LORESERVE && i <= SHN_HIRESERVE;
+}
+
+/* shndx is in [0..SHN_LORESERVE) U (SHN_HIRESERVE, 0xfffffff], thus:
+ * shndx == 0               <=> sechdrs[0]
+ * ......
+ * shndx == SHN_LORESERVE-1 <=> sechdrs[SHN_LORESERVE-1]
+ * shndx == SHN_HIRESERVE+1 <=> sechdrs[SHN_LORESERVE]
+ * shndx == SHN_HIRESERVE+2 <=> sechdrs[SHN_LORESERVE+1]
+ * ......
+ * fyi: sym->st_shndx is uint16, SHN_LORESERVE = ff00, SHN_HIRESERVE = ffff,
+ * so basically we map  0000..feff -> 0000..feff
+ *                      ff00..ffff -> (you are a bad boy, dont do it)
+ *                     10000..xxxx -> ff00..(xxxx-0x100)
+ */
+static inline unsigned int shndx2secindex(unsigned int i)
+{
+	if (i <= SHN_HIRESERVE)
+		return i;
+	return i - (SHN_HIRESERVE + 1 - SHN_LORESERVE);
+}
+
+/* Accessor for sym->st_shndx, hides ugliness of "64k sections" */
+static inline unsigned int get_secindex(const struct elf_info *info,
+					const Elf_Sym *sym)
+{
+	if (sym->st_shndx != SHN_XINDEX)
+		return sym->st_shndx;
+	return shndx2secindex(info->symtab_shndx_start[sym -
+						       info->symtab_start]);
+}
+
 /* file2alias.c */
 extern unsigned int cross_build;
 void handle_moddevtable(struct module *mod, struct elf_info *info,
-- 
1.6.2.1

