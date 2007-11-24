Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbXKXXSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbXKXXSA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 18:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbXKXXRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 18:17:51 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:61562 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbXKXXRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 18:17:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=l+zKYX1buDVRkMwGCQK/QQa4cjOOCgZOw9jV2LgzwpQp9pygZm3hqjhKg0j1NzVHXXA+qqRgYzgWmhcUg08tPsIWOeK8m7zF90Um3S0GhEipHOwzvtEKbvWLs9aIQsBEE+9mUTEoUeSbxOIzW3pcrbPwJ5wRXC4pYeqvfrVR1lo=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 2/3] build system: section garbage collection - modpost fix
Date: Sat, 24 Nov 2007 15:17:43 -0800
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200709112105.34301.vda.linux@googlemail.com> <20071118230057.GA6303@uranus.ravnborg.org> <200711241514.26451.vda.linux@googlemail.com>
In-Reply-To: <200711241514.26451.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_XELSHwVpefAF101"
Message-Id: <200711241517.43643.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_XELSHwVpefAF101
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 24 November 2007 15:14, Denys Vlasenko wrote:
> 2.modpost
>     Update scripts/mod/* machinery to correctly handle the case
>     when we have more than 64k sections.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
-- 
vda

--Boundary-00=_XELSHwVpefAF101
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="linux-2.6-linus_git.2.modpost_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6-linus_git.2.modpost_fix.patch"

diff -urpN linux-2.6.gc1/scripts/mod/file2alias.c linux-2.6.gc2/scripts/mod/file2alias.c
--- linux-2.6.gc1/scripts/mod/file2alias.c	2007-11-23 18:55:26.000000000 -0800
+++ linux-2.6.gc2/scripts/mod/file2alias.c	2007-11-23 21:10:04.000000000 -0800
@@ -585,7 +585,7 @@ void handle_moddevtable(struct module *m
 	char *zeros = NULL;
 
 	/* We're looking for a section relative symbol */
-	if (!sym->st_shndx || sym->st_shndx >= info->hdr->e_shnum)
+	if (!sym->st_shndx || get_secindex(info, sym) >= info->num_sections)
 		return;
 
 	/* Handle all-NULL symbols allocated into .bss */
@@ -594,7 +594,7 @@ void handle_moddevtable(struct module *m
 		symval = zeros;
 	} else {
 		symval = (void *)info->hdr
-			+ info->sechdrs[sym->st_shndx].sh_offset
+			+ info->sechdrs[get_secindex(info, sym)].sh_offset
 			+ sym->st_value;
 	}
 
diff -urpN linux-2.6.gc1/scripts/mod/modpost.c linux-2.6.gc2/scripts/mod/modpost.c
--- linux-2.6.gc1/scripts/mod/modpost.c	2007-11-23 20:55:54.000000000 -0800
+++ linux-2.6.gc2/scripts/mod/modpost.c	2007-11-23 21:08:41.000000000 -0800
@@ -235,7 +235,7 @@ static enum export export_no(const char 
 	return export_unknown;
 }
 
-static enum export export_from_sec(struct elf_info *elf, Elf_Section sec)
+static enum export export_from_sec(struct elf_info *elf, unsigned sec)
 {
 	if (sec == elf->export_sec)
 		return export_plain;
@@ -356,6 +356,8 @@ static int parse_elf(struct elf_info *in
 	Elf_Ehdr *hdr;
 	Elf_Shdr *sechdrs;
 	Elf_Sym  *sym;
+	const char *secstrings;
+	unsigned int symtab_idx = ~0U;
 
 	hdr = grab_file(filename, &info->size);
 	if (!hdr) {
@@ -375,6 +377,7 @@ static int parse_elf(struct elf_info *in
 		/* Not an ELF file - silently ignore it */
 		return 0;
 	}
+
 	/* Fix endianness in ELF header */
 	hdr->e_shoff    = TO_NATIVE(hdr->e_shoff);
 	hdr->e_shstrndx = TO_NATIVE(hdr->e_shstrndx);
@@ -390,8 +393,18 @@ static int parse_elf(struct elf_info *in
 		return 0;
 	}
 
+	/* Fixups for more than 64k sections */
+	info->num_sections = hdr->e_shnum;
+	if (info->num_sections == SHN_UNDEF) { /* more than 64k sections? */
+		/* doesn't need shndx2secindex() */
+		info->num_sections = TO_NATIVE(sechdrs[0].sh_size);
+	}
+	info->secindex_strings = hdr->e_shstrndx;
+	if (info->secindex_strings == SHN_XINDEX)
+		info->secindex_strings = shndx2secindex(TO_NATIVE(sechdrs[0].sh_link));
+
 	/* Fix endianness in section headers */
-	for (i = 0; i < hdr->e_shnum; i++) {
+	for (i = 0; i < info->num_sections; i++) {
 		sechdrs[i].sh_type   = TO_NATIVE(sechdrs[i].sh_type);
 		sechdrs[i].sh_offset = TO_NATIVE(sechdrs[i].sh_offset);
 		sechdrs[i].sh_size   = TO_NATIVE(sechdrs[i].sh_size);
@@ -401,9 +414,8 @@ static int parse_elf(struct elf_info *in
 		sechdrs[i].sh_addr   = TO_NATIVE(sechdrs[i].sh_addr);
 	}
 	/* Find symbol table. */
-	for (i = 1; i < hdr->e_shnum; i++) {
-		const char *secstrings
-			= (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
+	secstrings = (void *)hdr + sechdrs[info->secindex_strings].sh_offset;
+	for (i = 1; i < info->num_sections; i++) {
 		const char *secname;
 
 		if (sechdrs[i].sh_offset > info->size) {
@@ -425,14 +437,29 @@ static int parse_elf(struct elf_info *in
 		else if (strcmp(secname, "__ksymtab_gpl_future") == 0)
 			info->export_gpl_future_sec = i;
 
-		if (sechdrs[i].sh_type != SHT_SYMTAB)
-			continue;
+		if (sechdrs[i].sh_type == SHT_SYMTAB) {
+			symtab_idx = i;
+			info->symtab_start = (void *)hdr + sechdrs[i].sh_offset;
+			info->symtab_stop  = (void *)hdr + sechdrs[i].sh_offset
+				                         + sechdrs[i].sh_size;
+			info->strtab       = (void *)hdr +
+			             sechdrs[shndx2secindex(sechdrs[i].sh_link)].sh_offset;
+		}
 
-		info->symtab_start = (void *)hdr + sechdrs[i].sh_offset;
-		info->symtab_stop  = (void *)hdr + sechdrs[i].sh_offset
-			                         + sechdrs[i].sh_size;
-		info->strtab       = (void *)hdr +
-			             sechdrs[sechdrs[i].sh_link].sh_offset;
+		/* 32bit section no. table? ("more than 64k sections") */
+		if (sechdrs[i].sh_type == SHT_SYMTAB_SHNDX) {
+			uint32_t *p32;
+			info->symtab_shndx = (void *)hdr + sechdrs[i].sh_offset;
+			if (symtab_idx != shndx2secindex(sechdrs[i].sh_link))
+				fatal("%s: SYMTAB_SHNDX has bad sh_link: %u!=%u\n",
+					filename,
+					shndx2secindex(sechdrs[i].sh_link),
+					symtab_idx);
+			/* Fix endianness */
+			p32 = (void*)info->symtab_shndx + sechdrs[i].sh_size;
+			while (--p32 >= info->symtab_shndx)
+				*p32 = TO_NATIVE(*p32);
+		}
 	}
 	if (!info->symtab_start) {
 		fatal("%s has no symtab?\n", filename);
@@ -459,7 +486,7 @@ static void handle_modversions(struct mo
 			       Elf_Sym *sym, const char *symname)
 {
 	unsigned int crc;
-	enum export export = export_from_sec(info, sym->st_shndx);
+	enum export export = export_from_sec(info, get_secindex(info, sym));
 
 	switch (sym->st_shndx) {
 	case SHN_COMMON:
@@ -768,11 +795,14 @@ static Elf_Sym *find_elf_symbol(struct e
 				Elf_Sym *relsym)
 {
 	Elf_Sym *sym;
+	unsigned relsym_secindex;
 
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
@@ -821,7 +851,7 @@ static void find_symbols_between(struct 
 	Elf_Addr beforediff = ~0;
 	Elf_Addr afterdiff = ~0;
 	const char *secstrings = (void *)hdr +
-				 elf->sechdrs[hdr->e_shstrndx].sh_offset;
+				 elf->sechdrs[elf->secindex_strings].sh_offset;
 
 	*before = NULL;
 	*after = NULL;
@@ -829,9 +859,9 @@ static void find_symbols_between(struct 
 	for (sym = elf->symtab_start; sym < elf->symtab_stop; sym++) {
 		const char *symsec;
 
-		if (sym->st_shndx >= SHN_LORESERVE)
+		if (is_shndx_special(sym->st_shndx))
 			continue;
-		symsec = secstrings + elf->sechdrs[sym->st_shndx].sh_name;
+		symsec = secstrings + elf->sechdrs[get_secindex(elf, sym)].sh_name;
 		if (strcmp(symsec, sec) != 0)
 			continue;
 		if (!is_valid_name(elf, sym))
@@ -872,8 +902,8 @@ static void warn_sec_mismatch(const char
 	Elf_Ehdr *hdr = elf->hdr;
 	Elf_Shdr *sechdrs = elf->sechdrs;
 	const char *secstrings = (void *)hdr +
-				 sechdrs[hdr->e_shstrndx].sh_offset;
-	const char *secname = secstrings + sechdrs[sym->st_shndx].sh_name;
+				 sechdrs[elf->secindex_strings].sh_offset;
+	const char *secname = secstrings + sechdrs[get_secindex(elf, sym)].sh_name;
 
 	find_symbols_between(elf, r.r_offset, fromsec, &before, &after);
 
@@ -1007,10 +1037,10 @@ static void check_sec_ref(struct module 
 	Elf_Ehdr *hdr = elf->hdr;
 	Elf_Shdr *sechdrs = elf->sechdrs;
 	const char *secstrings = (void *)hdr +
-				 sechdrs[hdr->e_shstrndx].sh_offset;
+				 sechdrs[elf->secindex_strings].sh_offset;
 
 	/* Walk through all sections */
-	for (i = 0; i < hdr->e_shnum; i++) {
+	for (i = 0; i < elf->num_sections; i++) {
 		const char *name = secstrings + sechdrs[i].sh_name;
 		const char *secname;
 		Elf_Rela r;
@@ -1044,11 +1074,11 @@ static void check_sec_ref(struct module 
 				r.r_addend = TO_NATIVE(rela->r_addend);
 				sym = elf->symtab_start + r_sym;
 				/* Skip special sections */
-				if (sym->st_shndx >= SHN_LORESERVE)
+				if (is_shndx_special(sym->st_shndx))
 					continue;
 
 				secname = secstrings +
-					sechdrs[sym->st_shndx].sh_name;
+					sechdrs[get_secindex(elf, sym)].sh_name;
 				if (section(secname))
 					warn_sec_mismatch(modname, name,
 							  elf, sym, r);
@@ -1095,11 +1125,11 @@ static void check_sec_ref(struct module 
 				}
 				sym = elf->symtab_start + r_sym;
 				/* Skip special sections */
-				if (sym->st_shndx >= SHN_LORESERVE)
+				if (is_shndx_special(sym->st_shndx))
 					continue;
 
 				secname = secstrings +
-					sechdrs[sym->st_shndx].sh_name;
+					sechdrs[get_secindex(elf, sym)].sh_name;
 				if (section(secname))
 					warn_sec_mismatch(modname, name,
 							  elf, sym, r);
diff -urpN linux-2.6.gc1/scripts/mod/modpost.h linux-2.6.gc2/scripts/mod/modpost.h
--- linux-2.6.gc1/scripts/mod/modpost.h	2007-11-23 18:55:26.000000000 -0800
+++ linux-2.6.gc2/scripts/mod/modpost.h	2007-11-23 21:08:41.000000000 -0800
@@ -127,8 +127,49 @@ struct elf_info {
 	const char   *strtab;
 	char	     *modinfo;
 	unsigned int modinfo_len;
+
+	/* support for 32bit section numbers */
+
+	unsigned int num_sections; /* max_secindex + 1 */
+	unsigned int secindex_strings;
+	/* if Nth symbol table entry has .st_shndx = SHN_XINDEX,
+	 * take shndx from symtab_shndx[N] instead */
+	uint32_t     *symtab_shndx;
 };
 
+static inline int is_shndx_special(unsigned i)
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
+static inline unsigned shndx2secindex(unsigned i)
+{
+	if (i <= SHN_HIRESERVE)
+		return i;
+	return i - (SHN_HIRESERVE + 1 - SHN_LORESERVE);
+}
+
+/* Accessor for sym->st_shndx, hides ugliness of "64k sections" */
+static inline unsigned get_secindex(struct elf_info *info, Elf_Sym *sym)
+{
+	if (sym->st_shndx != SHN_XINDEX)
+		return sym->st_shndx;
+	return shndx2secindex(info->symtab_shndx[sym - info->symtab_start]);
+}
+
+
 /* file2alias.c */
 void handle_moddevtable(struct module *mod, struct elf_info *info,
 			Elf_Sym *sym, const char *symname);

--Boundary-00=_XELSHwVpefAF101--
