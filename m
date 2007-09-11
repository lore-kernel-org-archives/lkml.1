Return-Path: <linux-kernel-owner+w=401wt.eu-S934506AbXIKUTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506AbXIKUTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966387AbXIKULd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:11:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:13944 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966377AbXIKUL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:11:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=NVkGDCUVSVU2YGNLJJk0/NB0nwk5Wc9SbqzpvJHoHJbFSlbuvacSDIl1f4++ubc+O0r3FzG4Qcxds8otMjTMfKbljE1liqvhd3AgivzMFaXxTwttsjiGce7hsf4GrduQ7RTHEn+WRVqYxiRSh12xcgApck1xonJ4k/7DTXd1B6I=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 3/4] build system: section garbage collection for vmlinux
Date: Tue, 11 Sep 2007 21:11:21 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200709112105.34301.vda.linux@googlemail.com> <200709112107.53155.vda.linux@googlemail.com> <200709112110.14270.vda.linux@googlemail.com>
In-Reply-To: <200709112110.14270.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_pZv5GoGs09SoG/q"
Message-Id: <200709112111.21089.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_pZv5GoGs09SoG/q
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch makes modpost able to process object files with more than
64k sections. Needed for huge kernel builds (allyesconfig, for example)
with --gc-sections.

This patch basically fixes modpost, it isn't specific
for section garbage collection.

Please apply.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_pZv5GoGs09SoG/q
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="linux-2.6.23-rc4.3.modpost_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.23-rc4.3.modpost_fix.patch"

--- linux-2.6.23-rc4.gc2/scripts/mod/file2alias.c	Sun Sep  2 17:29:37 2007
+++ linux-2.6.23-rc4.gc3/scripts/mod/file2alias.c	Sat Sep  8 22:07:54 2007
@@ -529,11 +529,11 @@
 	void *symval;
 
 	/* We're looking for a section relative symbol */
-	if (!sym->st_shndx || sym->st_shndx >= info->hdr->e_shnum)
+	if (!sym->st_shndx || get_secindex(info, sym) >= info->num_sections)
 		return;
 
 	symval = (void *)info->hdr
-		+ info->sechdrs[sym->st_shndx].sh_offset
+		+ info->sechdrs[get_secindex(info, sym)].sh_offset
 		+ sym->st_value;
 
 	if (sym_is(symname, "__mod_pci_device_table"))
--- linux-2.6.23-rc4.gc2/scripts/mod/modpost.c	Sat Sep  8 22:06:52 2007
+++ linux-2.6.23-rc4.gc3/scripts/mod/modpost.c	Sat Sep  8 22:07:54 2007
@@ -235,7 +235,7 @@
 	return export_unknown;
 }
 
-static enum export export_from_sec(struct elf_info *elf, Elf_Section sec)
+static enum export export_from_sec(struct elf_info *elf, unsigned sec)
 {
 	if (sec == elf->export_sec)
 		return export_plain;
@@ -353,6 +353,8 @@
 	Elf_Ehdr *hdr;
 	Elf_Shdr *sechdrs;
 	Elf_Sym  *sym;
+	const char *secstrings;
+	unsigned int symtab_idx = ~0U;
 
 	hdr = grab_file(filename, &info->size);
 	if (!hdr) {
@@ -372,6 +374,7 @@
 		/* Not an ELF file - silently ignore it */
 		return 0;
 	}
+
 	/* Fix endianness in ELF header */
 	hdr->e_shoff    = TO_NATIVE(hdr->e_shoff);
 	hdr->e_shstrndx = TO_NATIVE(hdr->e_shstrndx);
@@ -381,8 +384,18 @@
 	sechdrs = (void *)hdr + hdr->e_shoff;
 	info->sechdrs = sechdrs;
 
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
@@ -392,9 +405,8 @@
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
@@ -416,14 +428,29 @@
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
@@ -450,7 +477,7 @@
 			       Elf_Sym *sym, const char *symname)
 {
 	unsigned int crc;
-	enum export export = export_from_sec(info, sym->st_shndx);
+	enum export export = export_from_sec(info, get_secindex(info, sym));
 
 	switch (sym->st_shndx) {
 	case SHN_COMMON:
@@ -758,11 +785,14 @@
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
@@ -811,7 +841,7 @@
 	Elf_Addr beforediff = ~0;
 	Elf_Addr afterdiff = ~0;
 	const char *secstrings = (void *)hdr +
-				 elf->sechdrs[hdr->e_shstrndx].sh_offset;
+				 elf->sechdrs[elf->secindex_strings].sh_offset;
 
 	*before = NULL;
 	*after = NULL;
@@ -819,9 +849,9 @@
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
@@ -862,8 +892,8 @@
 	Elf_Ehdr *hdr = elf->hdr;
 	Elf_Shdr *sechdrs = elf->sechdrs;
 	const char *secstrings = (void *)hdr +
-				 sechdrs[hdr->e_shstrndx].sh_offset;
-	const char *secname = secstrings + sechdrs[sym->st_shndx].sh_name;
+				 sechdrs[elf->secindex_strings].sh_offset;
+	const char *secname = secstrings + sechdrs[get_secindex(elf, sym)].sh_name;
 
 	find_symbols_between(elf, r.r_offset, fromsec, &before, &after);
 
@@ -997,10 +1027,10 @@
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
@@ -1034,11 +1064,11 @@
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
@@ -1085,11 +1115,11 @@
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
--- linux-2.6.23-rc4.gc2/scripts/mod/modpost.h	Sun Sep  2 17:29:37 2007
+++ linux-2.6.23-rc4.gc3/scripts/mod/modpost.h	Sat Sep  8 22:07:54 2007
@@ -127,7 +127,48 @@
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
+
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
 
 /* file2alias.c */
 void handle_moddevtable(struct module *mod, struct elf_info *info,

--Boundary-00=_pZv5GoGs09SoG/q--
