Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbXFCUtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbXFCUtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbXFCUrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:47:39 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:56183 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbXFCUri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:47:38 -0400
Date: Sun, 3 Jun 2007 22:48:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: [PATCH 14/19] kbuild: refactor code in modpost to improve maintainability
Message-ID: <20070603204839.GO9240@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 14/19] kbuild: refactor code in modpost to improve maintainability
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 2 Jun 2007 21:18:51 +0200

There were a great deal of overlap between the two functions
that check which sections may reference .init.text and .exit.text.
Factor out common check to a separate function and
sort entries in the original functions.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |  140 +++++++++++++++++++++++-------------------------
 1 files changed, 67 insertions(+), 73 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index b824198..2b881c2 100644
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
@@ -1075,6 +1067,60 @@ static void check_sec_ref(struct module *mod, const char *modname,
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
@@ -1111,52 +1157,32 @@ static int init_section_ref_ok(const char *name)
 	const char **s;
 	/* Absolute section names */
 	const char *namelist1[] = {
+		"__ftr_fixup",		/* powerpc cpu feature fixup */
+		"__fw_ftr_fixup",	/* powerpc firmware feature fixup */
+		"__param",
+		".data.rel.ro",		/* used by parisc64 */
 		".init",
-		".opd",   /* see comment [OPD] at exit_section_ref_ok() */
-		".toc1",  /* used by ppc64 */
-		".stab",
-		".data.rel.ro", /* used by parisc64 */
-		".parainstructions",
-		".text.lock",
-		"__bug_table", /* used by powerpc for BUG() */
 		".pci_fixup_header",
 		".pci_fixup_final",
-		".pdr",
-		"__param",
-		"__ex_table",
-		".fixup",
-		".smp_locks",
-		".plt",  /* seen on ARCH=um build on x86_64. Harmless */
-		"__ftr_fixup",		/* powerpc cpu feature fixup */
-		"__fw_ftr_fixup",	/* powerpc firmware feature fixup */
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
 	if (strrcmp(name, ".init") == 0)
 		return 1;
 	return 0;
@@ -1181,58 +1207,26 @@ static int exit_section(const char *name)
 
 /*
  * Identify sections from which references to a .exit section is OK.
- *
- * [OPD] Keith Ownes <kaos@sgi.com> commented:
- * For our future {in}sanity, add a comment that this is the ppc .opd
- * section, not the ia64 .opd section.
- * ia64 .opd should not point to discarded sections.
- * [.rodata] like for .init.text we ignore .rodata references -same reason
  **/
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
1.5.1.rc3.1544.g8a923


----- End forwarded message -----
