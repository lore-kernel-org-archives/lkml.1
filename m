Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbYAMVeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbYAMVeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 16:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbYAMVeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 16:34:11 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:60575 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947AbYAMVeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 16:34:10 -0500
Date: Sun, 13 Jan 2008 22:34:14 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>, Adrian Bunk <bunk@kernel.org>
Subject: [PATCH] kbuild: simplify section mismatch check in modpost
Message-ID: <20080113213414.GA2205@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In another thread I mentioned the idea to introduce additional
sections for all the __init markers.
Introducing checks for all the new combinations in modpost
turned out to be difficult so I decided to clean up
what we have today by introducing a table based approach.
The patch below is the result of this effort.

I have pushed out kbuild.git with this change so grab it there
if you like to play with it.

Comments are welcome.

The pattern_cmp() includes support for "*foo*" but that is not
yet used. I know it has a memory leak...
If someone has a better implmentation that does not pull
in any regexp library let me know.

	Sam 


>From 94fb89c040d3a8557b00f042a05901f362bf4c1c Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 13 Jan 2008 22:21:31 +0100
Subject: [PATCH] kbuild: simplify section mismatch check in modpost

Change the logic in modpost so we identify all the
bad combinations of sections that refer to other
sections.
Compared to the previous approach we are much less
dependent on knowledge of what additional sections
the tool chain uses and thus we can keep the false
positives low.

The implmentation is changed to use a table based
lookup and we now check all combinations in first
pass so we no longer need separate passed for init
and exit sections.

Tested that the same warnings are generated for
a allyesconfig build without CONFIG_HOTPLUG.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Adrian Bunk <bunk@kernel.org>
---
 scripts/mod/modpost.c |  292 +++++++++++++++++++++++--------------------------
 1 files changed, 137 insertions(+), 155 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 696d2a5..4521eef 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -606,6 +606,138 @@ static int strrcmp(const char *s, const char *sub)
 }
 
 /*
+ * Simple pattern matching.
+ * If sym matches one of the patterns then return 1 - otherwise 0.
+ * The patterns most be terminated with a NULL.
+ * Simple wildcard functionality is implemented.
+ * A '*' may be used as wildcard in start and/or end of string
+ * to match anything.
+ */
+static int pattern_cmp(const char *sym, const char * const pat[])
+{
+	const char *p;
+	while (*pat) {
+		p = *pat++;
+		const char *endp = p + strlen(p) - 1;
+
+		/* "*foo" */
+		if (*p == '*') {
+			if (strrcmp(sym, p + 1) == 0)
+				return 1;
+		}
+		/* "foo*" */
+		else if (*endp == '*') {
+			if (strncmp(sym, p, strlen(p) - 1) == 0)
+				return 1;
+		}
+		/* "*foo*" */
+		else if ((*p == '*') && (*endp == '*')) {
+			char *str = strdup(p + 1);
+			int len = strlen(str);
+			if (len)
+				*(str + len - 1) = '\0';
+			if (strstr(sym, str))
+				return 1;
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
+
+struct sectioncheck {
+	const char *fromsec[10];
+	const char *tosec[10];
+};
+
+const struct sectioncheck sectioncheck[] = {
+/* Do not reference init/exit code/data from
+ * normal code and data
+ */
+{
+	.fromsec = {
+		".text",
+		".text.*",
+		".data",
+		".data.*",
+		NULL
+	},
+	.tosec = {
+		"*init.text",
+		"*init.data",
+		"*exit.text",
+		"*exit.data",
+		NULL
+	},
+},
+/* Do not use exit code/data from init code */
+{
+	.fromsec = {
+		".init.text",
+		".init.data",
+		NULL
+	},
+	.tosec = {
+		".exit.text",
+		".exit.data",
+		NULL
+	},
+},
+/* Do not use init code/data from exit code */
+{
+	.fromsec = {
+		".exit.text",
+		".exit.data",
+		NULL
+	},
+	.tosec = {
+		".init.text",
+		".init.data",
+		NULL
+	},
+},
+/* Do not export init/exit functions or data */
+{
+	.fromsec = {
+		"__ksymtab*",
+		NULL
+	},
+	.tosec = {
+		".init.*",
+		".exit*",
+		NULL
+	},
+}
+};
+
+/*
+ * Check if the reference fromsec => tosec is a potential
+ * candidate for a section mismatch.
+ * Find only the combinations we know are candidates and ignore
+ * the others.
+ * Returns 1 if we have found a potential section mismatch reference.
+ */
+static int bad_section_ref(const char *fromsec, const char *tosec)
+{
+	int i;
+	int elems = sizeof(sectioncheck) / sizeof(struct sectioncheck);
+	const struct sectioncheck *check = &sectioncheck[0];
+
+	for (i = 0; i < elems; i++) {
+		if (pattern_cmp(fromsec, check->fromsec) &&
+		    pattern_cmp(tosec, check->tosec))
+			return 1;
+		check++;
+	}
+	return 0;
+}
+
+/*
  * Functions used only during module init is marked __init and is stored in
  * a .init.text section. Likewise data is marked __initdata and stored in
  * a .init.data section.
@@ -1008,9 +1140,7 @@ static int addend_mips_rel(struct elf_info *elf, int rsection, Elf_Rela *r)
  * be discarded and warns about it.
  **/
 static void check_sec_ref(struct module *mod, const char *modname,
-			  struct elf_info *elf,
-			  int section(const char *),
-			  int section_ref_ok(const char *))
+			  struct elf_info *elf)
 {
 	int i;
 	Elf_Sym  *sym;
@@ -1031,8 +1161,6 @@ static void check_sec_ref(struct module *mod, const char *modname,
 			Elf_Rela *start = (void *)hdr + sechdrs[i].sh_offset;
 			Elf_Rela *stop  = (void *)start + sechdrs[i].sh_size;
 			name += strlen(".rela");
-			if (section_ref_ok(name))
-				continue;
 
 			for (rela = start; rela < stop; rela++) {
 				r.r_offset = TO_NATIVE(rela->r_offset);
@@ -1059,7 +1187,7 @@ static void check_sec_ref(struct module *mod, const char *modname,
 
 				secname = secstrings +
 					sechdrs[sym->st_shndx].sh_name;
-				if (section(secname))
+				if (bad_section_ref(name, secname))
 					warn_sec_mismatch(modname, name,
 							  elf, sym, r);
 			}
@@ -1068,8 +1196,6 @@ static void check_sec_ref(struct module *mod, const char *modname,
 			Elf_Rel *start = (void *)hdr + sechdrs[i].sh_offset;
 			Elf_Rel *stop  = (void *)start + sechdrs[i].sh_size;
 			name += strlen(".rel");
-			if (section_ref_ok(name))
-				continue;
 
 			for (rel = start; rel < stop; rel++) {
 				r.r_offset = TO_NATIVE(rel->r_offset);
@@ -1110,7 +1236,7 @@ static void check_sec_ref(struct module *mod, const char *modname,
 
 				secname = secstrings +
 					sechdrs[sym->st_shndx].sh_name;
-				if (section(secname))
+				if (bad_section_ref(name, secname))
 					warn_sec_mismatch(modname, name,
 							  elf, sym, r);
 			}
@@ -1118,148 +1244,6 @@ static void check_sec_ref(struct module *mod, const char *modname,
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
@@ -1299,10 +1283,8 @@ static void read_symbols(char *modname)
 		handle_modversions(mod, &info, sym, symname);
 		handle_moddevtable(mod, &info, sym, symname);
 	}
-	if (is_vmlinux(modname) && vmlinux_section_warnings) {
-		check_sec_ref(mod, modname, &info, init_section, init_section_ref_ok);
-		check_sec_ref(mod, modname, &info, exit_section, exit_section_ref_ok);
-	}
+	if (is_vmlinux(modname) && vmlinux_section_warnings)
+		check_sec_ref(mod, modname, &info);
 
 	version = get_modinfo(info.modinfo, info.modinfo_len, "version");
 	if (version)
-- 
1.5.3.7.1112.g9758e

