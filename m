Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbXFCUuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbXFCUuk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbXFCUsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:48:12 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:56539 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbXFCUsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:48:11 -0400
Date: Sun, 3 Jun 2007 22:49:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: [PATCH 17/19] kbuild: refactor code in modpost
Message-ID: <20070603204912.GR9240@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 17/19] kbuild: refactor code in modpost
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 3 Jun 2007 00:41:22 +0200

Move more checks from whitelist to the section check functions
Renumber the patterns.
No functional changes.
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |   33 +++++++--------------------------
 1 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 877ed0c..f0474a9 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -612,14 +612,10 @@ static int strrcmp(const char *s, const char *sub)
  *   atsym = *driver, *_template, *_sht, *_ops, *_probe, *probe_one, *_console
  *
  * Pattern 3:
- *   Whitelist all references from .pci_fixup* section to .init.text
- *   This is part of the PCI init when built-in
- *
- * Pattern 4:
  *   Whitelist all refereces from .text.head to .init.data
  *   Whitelist all refereces from .text.head to .init.text
  *
- * Pattern 5:
+ * Pattern 4:
  *   Some symbols belong to init section but still it is ok to reference
  *   these from non-init sections as these symbols don't have any memory
  *   allocated for them and symbol address and value are same. So even
@@ -628,7 +624,7 @@ static int strrcmp(const char *s, const char *sub)
  *   This pattern is identified by
  *   refsymname = __init_begin, _sinittext, _einittext
  *
- * Pattern 7:
+ * Pattern 5:
  *  Logos used in drivers/video/logo reside in __initdata but the
  *  funtion that references them are EXPORT_SYMBOL() so cannot be
  *  marker __init. So we whitelist them here.
@@ -636,12 +632,6 @@ static int strrcmp(const char *s, const char *sub)
  *  tosec      = .init.data
  *  fromsec    = .text*
  *  refsymname = logo_
- *
- * Pattern 10:
- *  ia64 has machvec table for each platform and
- *  powerpc has a machine desc table for each platform.
- *  It is mixture of function pointers of .init.text and .text.
- *  fromsec  = .machvec | .machine.desc
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
@@ -698,32 +688,22 @@ static int secref_whitelist(const char *modname, const char *tosec,
 		return 1;
 
 	/* Check for pattern 3 */
-	if ((strncmp(fromsec, ".pci_fixup", strlen(".pci_fixup")) == 0) &&
-	    (strcmp(tosec, ".init.text") == 0))
-	return 1;
-
-	/* Check for pattern 4 */
 	if ((strcmp(fromsec, ".text.head") == 0) &&
 		((strcmp(tosec, ".init.data") == 0) ||
 		(strcmp(tosec, ".init.text") == 0)))
 	return 1;
 
-	/* Check for pattern 5 */
+	/* Check for pattern 4 */
 	for (s = pat3refsym; *s; s++)
 		if (strcmp(refsymname, *s) == 0)
 			return 1;
 
-	/* Check for pattern 7 */
+	/* Check for pattern 5 */
 	if ((strcmp(tosec, ".init.data") == 0) &&
 	    (strncmp(fromsec, ".text", strlen(".text")) == 0) &&
 	    (strncmp(refsymname, "logo_", strlen("logo_")) == 0))
 		return 1;
 
-	/* Check for pattern 10 */
-	if ((strcmp(fromsec, ".machvec") == 0) ||
-	    (strcmp(fromsec, ".machine.desc") == 0))
-		return 1;
-
 	return 0;
 }
 
@@ -1085,6 +1065,8 @@ static int initexit_section_ref_ok(const char *name)
 		"__ex_table",
 		".altinstructions",
 		".fixup",
+		".machvec",		/* ia64 + powerpc uses these */
+		".machine.desc",
 		".opd",			/* See comment [OPD] */
 		".parainstructions",
 		".pdr",
@@ -1161,14 +1143,13 @@ static int init_section_ref_ok(const char *name)
 		"__param",
 		".data.rel.ro",		/* used by parisc64 */
 		".init",
-		".pci_fixup_header",
-		".pci_fixup_final",
 		".text.lock",
 		NULL
 	};
 	/* Start of section names */
 	const char *namelist2[] = {
 		".init.",
+		".pci_fixup",
 		".rodata",
 		NULL
 	};
-- 
1.5.1.rc3.1544.g8a923


----- End forwarded message -----
