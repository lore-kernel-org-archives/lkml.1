Return-Path: <linux-kernel-owner+w=401wt.eu-S936745AbXGSSuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936745AbXGSSuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 14:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbXGSSuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 14:50:37 -0400
Received: from hq.tensilica.com ([65.205.227.29]:40944 "EHLO
	maia.hq.tensilica.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754377AbXGSSug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 14:50:36 -0400
X-Greylist: delayed 757 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2007 14:50:36 EDT
Date: Thu, 19 Jul 2007 11:37:56 -0700
From: Chris Zankel <czankel@tensilica.com>
Message-Id: <200707191837.l6JIbuE25527@corvus.hq.tensilica.com>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: [PATCH] fix modpost warnings for xtensa
Cc: chris@zankel.net, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	[PATCH] fix modpost warnings for xtensa

	The Xtensa architecture places literal pools in sections separate 
	from the instructions. The corresponsing text sections, therefore, 
	reference the .literal section, and we have to suppress those
	warnings. The naming convention defines the name for a literal 
	section as .SECTION.literal, unless .SECTION is .text. In that case
	the name is only .literal. Using strncmp() instead of strcmp() 
	to compare the from-section with .SECTION.init.refok in pattern 0
	should not cause any regressions for other architectures.
	We also need to suppress warnings for two informational 
	sections (.xt.lit and .xt.prop) used by the Xtensa architecture.

	Signed-off-by: Chris Zankel <chris@zankel.net>

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 3645e98..9061443 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -645,12 +645,20 @@ static int strrcmp(const char *s, const char *sub)
  *  powerpc has a machine desc table for each platform.
  *  It is mixture of function pointers of .init.text and .text.
  *  fromsec  = .machvec | .machine.desc
+ *
+ * Pattern 11:
+ *  Xtensa uses literal sections for constants that are accessed PC-relative.
+ *  Literal sections may savely reference their text sections.
+ *  (Note that the name for the literal section omits any trailing '.text')
+ *  tosec = <section>[.text]
+ *  fromsec = <section>.literal
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
 			    const char *refsymname)
 {
 	int f1 = 1, f2 = 1;
+	int len;
 	const char **s;
 	const char *pat2sym[] = {
 		"driver",
@@ -672,8 +680,10 @@ static int secref_whitelist(const char *modname, const char *tosec,
 	};
 
 	/* Check for pattern 0 */
-	if ((strcmp(fromsec, ".text.init.refok") == 0) ||
-	    (strcmp(fromsec, ".data.init.refok") == 0))
+	if ((strncmp(fromsec, ".text.init.refok",
+		     strlen(".text.init.refok")) == 0) ||
+	    (strncmp(fromsec, ".data.init.refok",
+		     strlen(".data.init.refok")) == 0))
 		return 1;
 
 	/* Check for pattern 1 */
@@ -733,6 +743,16 @@ static int secref_whitelist(const char *modname, const char *tosec,
 	    (strcmp(fromsec, ".machine.desc") == 0))
 		return 1;
 
+
+	/* Check for pattern 11 */
+	len = strlen(tosec) - strlen(".text");
+	if (len <= 0 || strcmp(tosec + len, ".text") != 0)
+		len = strlen(tosec);
+	if (strncmp(tosec, fromsec, len) == 0
+	    && (strlen(fromsec) > len)
+	    && (strcmp(fromsec + len, ".literal") == 0))
+		return 1;
+
 	return 0;
 }
 
@@ -858,10 +878,9 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
 	if (refsym && strlen(elf->strtab + refsym->st_name))
 		refsymname = elf->strtab + refsym->st_name;
 
-	/* check whitelist - we may ignore it */
-	if (before &&
-	    secref_whitelist(modname, secname, fromsec,
-			     elf->strtab + before->st_name, refsymname))
+	if (secref_whitelist(modname, secname, fromsec,
+			     before ? elf->strtab + before->st_name : "",
+			     refsymname))
 		return;
 
 	/* fromsec whitelist - without a valid 'before'
@@ -1053,6 +1072,8 @@ static int init_section_ref_ok(const char *name)
 		"__ftr_fixup",		/* powerpc cpu feature fixup */
 		"__fw_ftr_fixup",	/* powerpc firmware feature fixup */
 		".cranges",	/* used by sh64 */
+		".xt.prop",		/* xtensa informational section */
+		".xt.lit",		/* xtensa informational section */
 		NULL
 	};
 	/* Start of section names */
@@ -1134,6 +1155,8 @@ static int exit_section_ref_ok(const char *name)
 		".smp_locks",
 		".plt",  /* seen on ARCH=um build on x86_64. Harmless */
 		".cranges",	/* used by sh64 */
+		".xt.prop",		/* xtensa informational section */
+		".xt.lit",		/* xtensa informational section */
 		NULL
 	};
 	/* Start of section names */
