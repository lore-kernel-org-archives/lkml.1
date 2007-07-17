Return-Path: <linux-kernel-owner+w=401wt.eu-S933402AbXGQOMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402AbXGQOMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762556AbXGQOID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:08:03 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35939 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbXGQOHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:51 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 16/33] kbuild: refactor code in modpost to improve maintainability
Date: Tue, 17 Jul 2007 16:08:45 +0200
Message-Id: <1184681344594-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11846813443387-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org> <11846813432234-git-send-email-sam@ravnborg.org> <11846813441521-git-send-email-sam@ravnborg.org> <11846813443387-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There were a great deal of overlap between the two functions
that check which sections may reference .init.text and .exit.text.
Factor out common check to a separate function and
sort entries in the original functions.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |  154 ++++++++++++++++++++++++-------------------------
 1 files changed, 75 insertions(+), 79 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 9c35f30..f22c8b4 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -858,14 +858,6 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
 			     elf->strtab + before->st_name, refsymname))
 		return;
 
-	/* fromsec whitelist - without a valid 'before'
-	 * powerpc has a GOT table in .got2 section
-	 * and also a .toc section */
-	if (strcmp(fromsec, ".got2") == 0)
-		return;
-	if (strcmp(fromsec, ".toc") == 0)
-		return;
-
 	if (before && after) {
 		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
 		     "(between '%s' and '%s')\n",
@@ -1087,6 +1079,61 @@ static void check_sec_ref(struct module *mod, const char *modname,
 	}
 }
 
+/*
+ * Identify sections from which references to either a
+ * .init or a .exit section is OK.
+ *
+ * [OPD] Keith Ownes <kaos@sgi.com> commented:
+ * For our future {in}sanity, add a comment that this is the ppc .opd
+ * section, not the ia64 .opd section.
+ * ia64 .opd should not point to discarded sections.
+ * [.rodata] like for .init.text we ignore .rodata references -same reason
+ **/
+static int initexit_section_ref_ok(const char *name)
+{
+	const char **s;
+	/* Absolute section names */
+	const char *namelist1[] = {
+		"__bug_table",		/* used by powerpc for BUG() */
+		"__ex_table",
+		".altinstructions",
+		".cranges",		/* used by sh64 */
+		".fixup",
+		".opd",			/* See comment [OPD] */
+		".parainstructions",
+		".pdr",
+		".plt",			/* seen on ARCH=um build on x86_64. Harmless */
+		".smp_locks",
+		".stab",
+		NULL
+	};
+	/* Start of section names */
+	const char *namelist2[] = {
+		".debug",
+		".eh_frame",
+		".note",		/* ignore ELF notes - may contain anything */
+		".got",			/* powerpc - global offset table */
+		".toc",			/* powerpc - table of contents */
+		NULL
+	};
+	/* part of section name */
+	const char *namelist3 [] = {
+		".unwind",  /* Sample: IA_64.unwind.exit.text */
+		NULL
+	};
+
+	for (s = namelist1; *s; s++)
+		if (strcmp(*s, name) == 0)
+			return 1;
+	for (s = namelist2; *s; s++)
+		if (strncmp(*s, name, strlen(*s)) == 0)
+			return 1;
+	for (s = namelist3; *s; s++)
+		if (strstr(name, *s) != NULL)
+			return 1;
+	return 0;
+}
+
 /**
  * Functions used only during module init is marked __init and is stored in
  * a .init.text section. Likewise data is marked __initdata and stored in
@@ -1103,7 +1150,7 @@ static int init_section(const char *name)
 	return 0;
 }
 
-/**
+/*
  * Identify sections from which references to a .init section is OK.
  *
  * Unfortunately references to read only data that referenced .init
@@ -1117,59 +1164,41 @@ static int init_section(const char *name)
  *
  * where vgacon_startup is __init.  If you want to wade through the false
  * positives, take out the check for rodata.
- **/
+ */
 static int init_section_ref_ok(const char *name)
 {
 	const char **s;
 	/* Absolute section names */
 	const char *namelist1[] = {
-		".init",
-		".opd",   /* see comment [OPD] at exit_section_ref_ok() */
-		".toc1",  /* used by ppc64 */
-		".stab",
-		".data.rel.ro", /* used by parisc64 */
-		".parainstructions",
-		".text.lock",
-		"__bug_table", /* used by powerpc for BUG() */
-		".pci_fixup_header",
-		".pci_fixup_final",
-		".pdr",
-		"__param",
-		"__ex_table",
-		".fixup",
-		".smp_locks",
-		".plt",  /* seen on ARCH=um build on x86_64. Harmless */
 		"__ftr_fixup",		/* powerpc cpu feature fixup */
 		"__fw_ftr_fixup",	/* powerpc firmware feature fixup */
-		".cranges",	/* used by sh64 */
+		"__param",
+		".data.rel.ro",		/* used by parisc64 */
+		".init",
+		".text.lock",
 		NULL
 	};
 	/* Start of section names */
 	const char *namelist2[] = {
 		".init.",
-		".altinstructions",
-		".eh_frame",
-		".debug",
-		".parainstructions",
+		".pci_fixup",
 		".rodata",
-		".note",		/* ignore ELF notes - may contain anything */
-		NULL
-	};
-	/* part of section name */
-	const char *namelist3 [] = {
-		".unwind",  /* sample: IA_64.unwind.init.text */
 		NULL
 	};
 
+	if (initexit_section_ref_ok(name))
+		return 1;
+
 	for (s = namelist1; *s; s++)
 		if (strcmp(*s, name) == 0)
 			return 1;
 	for (s = namelist2; *s; s++)
 		if (strncmp(*s, name, strlen(*s)) == 0)
 			return 1;
-	for (s = namelist3; *s; s++)
-		if (strstr(name, *s) != NULL)
-			return 1;
+
+	/* If section name ends with ".init" we allow references
+	 * as is the case with .initcallN.init, .early_param.init, .taglist.init etc
+	 */
 	if (strrcmp(name, ".init") == 0)
 		return 1;
 	return 0;
@@ -1194,59 +1223,26 @@ static int exit_section(const char *name)
 
 /*
  * Identify sections from which references to a .exit section is OK.
- *
- * [OPD] Keith Ownes <kaos@sgi.com> commented:
- * For our future {in}sanity, add a comment that this is the ppc .opd
- * section, not the ia64 .opd section.
- * ia64 .opd should not point to discarded sections.
- * [.rodata] like for .init.text we ignore .rodata references -same reason
- **/
+ */
 static int exit_section_ref_ok(const char *name)
 {
 	const char **s;
 	/* Absolute section names */
 	const char *namelist1[] = {
-		".exit.text",
 		".exit.data",
+		".exit.text",
+		".exitcall.exit",
 		".init.text",
 		".rodata",
-		".opd", /* See comment [OPD] */
-		".toc1",  /* used by ppc64 */
-		".altinstructions",
-		".pdr",
-		"__bug_table", /* used by powerpc for BUG() */
-		".exitcall.exit",
-		".eh_frame",
-		".parainstructions",
-		".stab",
-		"__ex_table",
-		".fixup",
-		".smp_locks",
-		".plt",  /* seen on ARCH=um build on x86_64. Harmless */
-		".cranges",	/* used by sh64 */
-		NULL
-	};
-	/* Start of section names */
-	const char *namelist2[] = {
-		".debug",
-		".note",		/* ignore ELF notes - may contain anything */
-		NULL
-	};
-	/* part of section name */
-	const char *namelist3 [] = {
-		".unwind",  /* Sample: IA_64.unwind.exit.text */
 		NULL
 	};
 
+	if (initexit_section_ref_ok(name))
+		return 1;
+
 	for (s = namelist1; *s; s++)
 		if (strcmp(*s, name) == 0)
 			return 1;
-	for (s = namelist2; *s; s++)
-		if (strncmp(*s, name, strlen(*s)) == 0)
-			return 1;
-	for (s = namelist3; *s; s++)
-		if (strstr(name, *s) != NULL)
-			return 1;
 	return 0;
 }
 
-- 
1.5.0.6

