Return-Path: <linux-kernel-owner+w=401wt.eu-S1759958AbXGYU2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958AbXGYU2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbXGYU2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:28:11 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38222 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbXGYU2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:28:10 -0400
Date: Wed, 25 Jul 2007 22:29:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Chris Zankel <czankel@tensilica.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, chris@zankel.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix modpost warnings for xtensa
Message-ID: <20070725202922.GA29065@uranus.ravnborg.org>
References: <200707191837.l6JIbuE25527@corvus.hq.tensilica.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707191837.l6JIbuE25527@corvus.hq.tensilica.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 11:37:56AM -0700, Chris Zankel wrote:
> 	[PATCH] fix modpost warnings for xtensa
> 
> 	The Xtensa architecture places literal pools in sections separate 
> 	from the instructions. The corresponsing text sections, therefore, 
> 	reference the .literal section, and we have to suppress those
> 	warnings. The naming convention defines the name for a literal 
> 	section as .SECTION.literal, unless .SECTION is .text. In that case
> 	the name is only .literal. Using strncmp() instead of strcmp() 
> 	to compare the from-section with .SECTION.init.refok in pattern 0
> 	should not cause any regressions for other architectures.
> 	We also need to suppress warnings for two informational 
> 	sections (.xt.lit and .xt.prop) used by the Xtensa architecture.
> 
> 	Signed-off-by: Chris Zankel <chris@zankel.net>

Hi Chris,
I hand applied your patch and have pushed the following patch to kbuild.git.
I simplified it a bit and decided to break the 80 char limit..

	Sam

>From cb7e51d8b1f8e2390970f4bb7d095c414b1bf3cf Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 25 Jul 2007 22:24:52 +0200
Subject: [PATCH] kbuild: fix modpost warnings for xtensa

The Xtensa architecture places literal pools in sections separate
from the instructions. The corresponsing text sections, therefore,
reference the .literal section, and we have to suppress those
warnings.

The naming convention defines the name for a literal
section as .SECTION.literal, unless .SECTION is .text. In that case
the name is only .literal. Using strncmp() instead of strcmp()
to compare the from-section with .SECTION.init.refok in pattern 0
should not cause any regressions for other architectures.

We also need to suppress warnings for two informational
sections (.xt.lit and .xt.prop) used by the Xtensa architecture.

Signed-off-by: Chris Zankel <chris@zankel.net>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |   30 ++++++++++++++++++++++++------
 1 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 3db4edc..ee58ded 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -640,7 +640,7 @@ static int data_section(const char *name)
  * Pattern 0:
  *   Do not warn if funtion/data are marked with __init_refok/__initdata_refok.
  *   The pattern is identified by:
- *   fromsec = .text.init.refok | .data.init.refok
+ *   fromsec = .text.init.refok* | .data.init.refok*
  *
  * Pattern 1:
  *   If a module parameter is declared __initdata and permissions=0
@@ -675,11 +675,18 @@ static int data_section(const char *name)
  *   This pattern is identified by
  *   refsymname = __init_begin, _sinittext, _einittext
  *
+ * Pattern 5:
+ *   Xtensa uses literal sections for constants that are accessed PC-relative.
+ *   Literal sections may safely reference their text sections.
+ *   (Note that the name for the literal section omits any trailing '.text')
+ *   tosec = <section>[.text]
+ *   fromsec = <section>.literal
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
 			    const char *refsymname)
 {
+	int len;
 	const char **s;
 	const char *pat2sym[] = {
 		"driver",
@@ -701,8 +708,8 @@ static int secref_whitelist(const char *modname, const char *tosec,
 	};
 
 	/* Check for pattern 0 */
-	if ((strcmp(fromsec, ".text.init.refok") == 0) ||
-	    (strcmp(fromsec, ".data.init.refok") == 0))
+	if ((strncmp(fromsec, ".text.init.refok", strlen(".text.init.refok")) == 0) ||
+	    (strncmp(fromsec, ".data.init.refok", strlen(".data.init.refok")) == 0))
 		return 1;
 
 	/* Check for pattern 1 */
@@ -728,6 +735,15 @@ static int secref_whitelist(const char *modname, const char *tosec,
 		if (strcmp(refsymname, *s) == 0)
 			return 1;
 
+	/* Check for pattern 5 */
+	if (strrcmp(tosec, ".text") == 0)
+		len = strlen(tosec) - strlen(".text");
+	else
+		len = strlen(tosec);
+	if ((strncmp(tosec, fromsec, len) == 0) && (strlen(fromsec) > len) &&
+	    (strcmp(fromsec + len, ".literal") == 0))
+		return 1;
+
 	return 0;
 }
 
@@ -856,9 +872,9 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
 		refsymname = elf->strtab + refsym->st_name;
 
 	/* check whitelist - we may ignore it */
-	if (before &&
-	    secref_whitelist(modname, secname, fromsec,
-			     elf->strtab + before->st_name, refsymname))
+	if (secref_whitelist(modname, secname, fromsec,
+			     before ? elf->strtab + before->st_name : "",
+	                     refsymname))
 		return;
 
 	if (before && after) {
@@ -1111,6 +1127,8 @@ static int initexit_section_ref_ok(const char *name)
 		".smp_locks",
 		".stab",
 		".m68k_fixup",
+		".xt.prop",		/* xtensa informational section */
+		".xt.lit",		/* xtensa informational section */
 		NULL
 	};
 	/* Start of section names */
-- 
1.5.1.rc3.g84b7-dirty

