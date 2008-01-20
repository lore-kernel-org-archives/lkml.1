Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYATUKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYATUKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 15:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbYATUJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 15:09:18 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:39031 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755808AbYATUJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 15:09:09 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linux-arch@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Adrian Bunk <bunk@kernel.org>
Subject: [PATCH] kbuild: introduce blacklisting in modpost
Date: Sun, 20 Jan 2008 21:08:59 +0100
Message-Id: <1200859743-24037-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <1200859743-24037-3-git-send-email-sam@ravnborg.org>
References: <20080120200527.GA23852@uranus.ravnborg.org>
 <1200859743-24037-1-git-send-email-sam@ravnborg.org>
 <1200859743-24037-2-git-send-email-sam@ravnborg.org>
 <1200859743-24037-3-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the logic in modpost so we identify all the
bad combinations of sections that refer to other
sections.
Compared to the previous approach we are much less
dependent on knowledge of what additional sections
the tool chain uses and thus we can keep the false
positives low.

The implmentation is changed to use a table based
lookup and we now check all combinations in first
pass so we no longer need separate passes for init
and exit sections.

Tested that the same warnings are generated for
an allyesconfig build without CONFIG_HOTPLUG.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Adrian Bunk <bunk@kernel.org>
---
 scripts/mod/modpost.c |  305 +++++++++++++++++++++----------------------------
 1 files changed, 128 insertions(+), 177 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index e463013..6c206b9 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -605,6 +605,61 @@ static int strrcmp(const char *s, const char *sub)
 	return memcmp(s + slen - sublen, sub, sublen);
 }
 
+/* if sym is empty or point to a string
+ * like ".[0-9]+" then return 1.
+ * This is the optional prefix added by ld to some sections
+ */
+static int number_prefix(const char *sym)
+{
+	if (*sym++ == '\0')
+		return 1;
+	if (*sym != '.')
+		return 0;
+	do {
+		char c = *sym++;
+		if (c < '0' || c > '9')
+			return 0;
+	} while (*sym);
+	return 1;
+}
+
+/* The pattern is an array of simple patterns.
+ * "foo" will match an exact string equal to "foo"
+ * "foo*" will match a string that begins with "foo"
+ * "foo$" will match a string equal to "foo" or "foo.1"
+ *   where the '1' can be any number including several digits.
+ *   The $ syntax is for sections where ld append a dot number
+ *   to make section name unique.
+ */
+int match(const char *sym, const char * const pat[])
+{
+	const char *p;
+	while (*pat) {
+		p = *pat++;
+		const char *endp = p + strlen(p) - 1;
+
+		/* "foo*" */
+		if (*endp == '*') {
+			if (strncmp(sym, p, strlen(p) - 1) == 0)
+				return 1;
+		}
+		/* "foo$" */
+		else if (*endp == '$') {
+			if (strncmp(sym, p, strlen(p) - 1) == 0) {
+				if (number_prefix(sym + strlen(p) - 1))
+					return 1;
+			}
+		}
+		/* no wildcards */
+		else {
+			if (strcmp(p, sym) == 0)
+				return 1;
+		}
+	}
+	/* no match */
+	return 0;
+}
+
 /*
  * Functions used only during module init is marked __init and is stored in
  * a .init.text section. Likewise data is marked __initdata and stored in
@@ -653,6 +708,68 @@ static int data_section(const char *name)
 		return 0;
 }
 
+/* sections that we do not want to do full section mismatch check on */
+static const char *section_white_list[] =
+	{ ".debug*", ".stab*", ".note*", ".got*", ".toc*", NULL };
+
+#define INIT_DATA_SECTIONS ".init.data$"
+#define EXIT_DATA_SECTIONS ".exit.data$"
+
+#define INIT_TEXT_SECTIONS ".init.text$"
+#define EXIT_TEXT_SECTIONS ".exit.text$"
+
+#define INIT_SECTIONS INIT_DATA_SECTIONS, INIT_TEXT_SECTIONS
+#define EXIT_SECTIONS EXIT_DATA_SECTIONS, EXIT_TEXT_SECTIONS
+
+#define DATA_SECTIONS ".data$"
+#define TEXT_SECTIONS ".text$"
+
+struct sectioncheck {
+	const char *fromsec[20];
+	const char *tosec[20];
+};
+
+const struct sectioncheck sectioncheck[] = {
+/* Do not reference init/exit code/data from
+ * normal code and data
+ */
+{
+	.fromsec = { TEXT_SECTIONS, DATA_SECTIONS, NULL },
+	.tosec   = { INIT_SECTIONS, EXIT_SECTIONS, NULL }
+},
+/* Do not use exit code/data from init code */
+{
+	.fromsec = { INIT_SECTIONS, NULL },
+	.tosec   = { EXIT_SECTIONS, NULL },
+},
+/* Do not use init code/data from exit code */
+{
+	.fromsec = { EXIT_SECTIONS, NULL },
+	.tosec   = { INIT_SECTIONS, NULL }
+},
+/* Do not export init/exit functions or data */
+{
+	.fromsec = { "__ksymtab*", NULL },
+	.tosec   = { INIT_SECTIONS, EXIT_SECTIONS, NULL }
+}
+};
+
+static int section_mismatch(const char *fromsec, const char *tosec)
+{
+	int i;
+	int elems = sizeof(sectioncheck) / sizeof(struct sectioncheck);
+	const struct sectioncheck *check = &sectioncheck[0];
+
+	for (i = 0; i < elems; i++) {
+		if (match(fromsec, check->fromsec) &&
+		    match(tosec, check->tosec))
+			return 1;
+		check++;
+	}
+	return 0;
+}
+
+
 /**
  * Whitelist to allow certain references to pass with no warning.
  *
@@ -695,18 +812,11 @@ static int data_section(const char *name)
  *   This pattern is identified by
  *   refsymname = __init_begin, _sinittext, _einittext
  *
- * Pattern 5:
- *   Xtensa uses literal sections for constants that are accessed PC-relative.
- *   Literal sections may safely reference their text sections.
- *   (Note that the name for the literal section omits any trailing '.text')
- *   tosec = <section>[.text]
- *   fromsec = <section>.literal
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
 			    const char *refsymname)
 {
-	int len;
 	const char **s;
 	const char *pat2sym[] = {
 		"driver",
@@ -757,15 +867,6 @@ static int secref_whitelist(const char *modname, const char *tosec,
 		if (strcmp(refsymname, *s) == 0)
 			return 1;
 
-	/* Check for pattern 5 */
-	if (strrcmp(tosec, ".text") == 0)
-		len = strlen(tosec) - strlen(".text");
-	else
-		len = strlen(tosec);
-	if ((strncmp(tosec, fromsec, len) == 0) && (strlen(fromsec) > len) &&
-	    (strcmp(fromsec + len, ".literal") == 0))
-		return 1;
-
 	return 0;
 }
 
@@ -1011,8 +1112,7 @@ static int addend_mips_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
 }
 
 static void section_rela(const char *modname, struct elf_info *elf,
-                         Elf_Shdr *sechdr, int section(const char *),
-                         int section_ref_ok(const char *))
+                         Elf_Shdr *sechdr)
 {
 	Elf_Sym  *sym;
 	Elf_Rela *rela;
@@ -1031,7 +1131,7 @@ static void section_rela(const char *modname, struct elf_info *elf,
 	fromsec = secstrings + sechdr->sh_name;
 	fromsec += strlen(".rela");
 	/* if from section (name) is know good then skip it */
-	if (section_ref_ok(fromsec))
+	if (match(fromsec, section_white_list))
 		return;
 
 	for (rela = start; rela < stop; rela++) {
@@ -1059,14 +1159,13 @@ static void section_rela(const char *modname, struct elf_info *elf,
 
 		tosec = secstrings +
 			elf->sechdrs[sym->st_shndx].sh_name;
-		if (section(tosec))
+		if (section_mismatch(fromsec, tosec))
 			warn_sec_mismatch(modname, fromsec, elf, sym, r);
 	}
 }
 
 static void section_rel(const char *modname, struct elf_info *elf,
-                        Elf_Shdr *sechdr, int section(const char *),
-                        int section_ref_ok(const char *))
+                        Elf_Shdr *sechdr)
 {
 	Elf_Sym *sym;
 	Elf_Rel *rel;
@@ -1085,7 +1184,7 @@ static void section_rel(const char *modname, struct elf_info *elf,
 	fromsec = secstrings + sechdr->sh_name;
 	fromsec += strlen(".rel");
 	/* if from section (name) is know good then skip it */
-	if (section_ref_ok(fromsec))
+	if (match(fromsec, section_white_list))
 		return;
 
 	for (rel = start; rel < stop; rel++) {
@@ -1127,7 +1226,7 @@ static void section_rel(const char *modname, struct elf_info *elf,
 
 		tosec = secstrings +
 			elf->sechdrs[sym->st_shndx].sh_name;
-		if (section(tosec))
+		if (section_mismatch(fromsec, tosec))
 			warn_sec_mismatch(modname, fromsec, elf, sym, r);
 	}
 }
@@ -1145,9 +1244,7 @@ static void section_rel(const char *modname, struct elf_info *elf,
  * be discarded and warns about it.
  **/
 static void check_sec_ref(struct module *mod, const char *modname,
-			  struct elf_info *elf,
-			  int section(const char *),
-			  int section_ref_ok(const char *))
+                          struct elf_info *elf)
 {
 	int i;
 	Elf_Ehdr *hdr = elf->hdr;
@@ -1157,156 +1254,12 @@ static void check_sec_ref(struct module *mod, const char *modname,
 	for (i = 0; i < hdr->e_shnum; i++) {
 		/* We want to process only relocation sections and not .init */
 		if (sechdrs[i].sh_type == SHT_RELA)
-			section_rela(modname, elf, &elf->sechdrs[i],
-			             section, section_ref_ok);
+			section_rela(modname, elf, &elf->sechdrs[i]);
 		else if (sechdrs[i].sh_type == SHT_REL)
-			section_rel(modname, elf, &elf->sechdrs[i],
-			            section, section_ref_ok);
+			section_rel(modname, elf, &elf->sechdrs[i]);
 	}
 }
 
-/*
- * Identify sections from which references to either a
- * .init or a .exit section is OK.
- *
- * [OPD] Keith Ownes <kaos@sgi.com> commented:
- * For our future {in}sanity, add a comment that this is the ppc .opd
- * section, not the ia64 .opd section.
- * ia64 .opd should not point to discarded sections.
- * [.rodata] like for .init.text we ignore .rodata references -same reason
- */
-static int initexit_section_ref_ok(const char *name)
-{
-	const char **s;
-	/* Absolute section names */
-	const char *namelist1[] = {
-		"__bug_table",	/* used by powerpc for BUG() */
-		"__ex_table",
-		".altinstructions",
-		".cranges",	/* used by sh64 */
-		".fixup",
-		".machvec",	/* ia64 + powerpc uses these */
-		".machine.desc",
-		".opd",		/* See comment [OPD] */
-		"__dbe_table",
-		".parainstructions",
-		".pdr",
-		".plt",		/* seen on ARCH=um build on x86_64. Harmless */
-		".smp_locks",
-		".stab",
-		".m68k_fixup",
-		".xt.prop",	/* xtensa informational section */
-		".xt.lit",	/* xtensa informational section */
-		NULL
-	};
-	/* Start of section names */
-	const char *namelist2[] = {
-		".debug",
-		".eh_frame",
-		".note",	/* ignore ELF notes - may contain anything */
-		".got",		/* powerpc - global offset table */
-		".toc",		/* powerpc - table of contents */
-		NULL
-	};
-	/* part of section name */
-	const char *namelist3 [] = {
-		".unwind",  /* Sample: IA_64.unwind.exit.text */
-		NULL
-	};
-
-	for (s = namelist1; *s; s++)
-		if (strcmp(*s, name) == 0)
-			return 1;
-	for (s = namelist2; *s; s++)
-		if (strncmp(*s, name, strlen(*s)) == 0)
-			return 1;
-	for (s = namelist3; *s; s++)
-		if (strstr(name, *s) != NULL)
-			return 1;
-	return 0;
-}
-
-
-/*
- * Identify sections from which references to a .init section is OK.
- *
- * Unfortunately references to read only data that referenced .init
- * sections had to be excluded. Almost all of these are false
- * positives, they are created by gcc. The downside of excluding rodata
- * is that there really are some user references from rodata to
- * init code, e.g. drivers/video/vgacon.c:
- *
- * const struct consw vga_con = {
- *        con_startup:            vgacon_startup,
- *
- * where vgacon_startup is __init.  If you want to wade through the false
- * positives, take out the check for rodata.
- */
-static int init_section_ref_ok(const char *name)
-{
-	const char **s;
-	/* Absolute section names */
-	const char *namelist1[] = {
-		"__dbe_table",		/* MIPS generate these */
-		"__ftr_fixup",		/* powerpc cpu feature fixup */
-		"__fw_ftr_fixup",	/* powerpc firmware feature fixup */
-		"__param",
-		".data.rel.ro",		/* used by parisc64 */
-		".init",
-		".text.lock",
-		NULL
-	};
-	/* Start of section names */
-	const char *namelist2[] = {
-		".init.",
-		".pci_fixup",
-		".rodata",
-		NULL
-	};
-
-	if (initexit_section_ref_ok(name))
-		return 1;
-
-	for (s = namelist1; *s; s++)
-		if (strcmp(*s, name) == 0)
-			return 1;
-	for (s = namelist2; *s; s++)
-		if (strncmp(*s, name, strlen(*s)) == 0)
-			return 1;
-
-	/* If section name ends with ".init" we allow references
-	 * as is the case with .initcallN.init, .early_param.init,
-	 * .taglist.init etc
-	 */
-	if (strrcmp(name, ".init") == 0)
-		return 1;
-	return 0;
-}
-
-/*
- * Identify sections from which references to a .exit section is OK.
- */
-static int exit_section_ref_ok(const char *name)
-{
-	const char **s;
-	/* Absolute section names */
-	const char *namelist1[] = {
-		".exit.data",
-		".exit.text",
-		".exitcall.exit",
-		".rodata",
-		NULL
-	};
-
-	if (initexit_section_ref_ok(name))
-		return 1;
-
-	for (s = namelist1; *s; s++)
-		if (strcmp(*s, name) == 0)
-			return 1;
-	return 0;
-}
-
 static void read_symbols(char *modname)
 {
 	const char *symname;
@@ -1347,10 +1300,8 @@ static void read_symbols(char *modname)
 		handle_moddevtable(mod, &info, sym, symname);
 	}
 	if (!is_vmlinux(modname) ||
-	     (is_vmlinux(modname) && vmlinux_section_warnings)) {
-		check_sec_ref(mod, modname, &info, init_section, init_section_ref_ok);
-		check_sec_ref(mod, modname, &info, exit_section, exit_section_ref_ok);
-	}
+	     (is_vmlinux(modname) && vmlinux_section_warnings))
+		check_sec_ref(mod, modname, &info);
 
 	version = get_modinfo(info.modinfo, info.modinfo_len, "version");
 	if (version)
-- 
1.5.4.rc3.14.g44397

