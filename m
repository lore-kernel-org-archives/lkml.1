Return-Path: <linux-kernel-owner+w=401wt.eu-S933601AbXGQONE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601AbXGQONE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbXGQOIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:08:06 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35927 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbXGQOHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:52 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 17/33] kbuild: consolidate section checks
Date: Tue, 17 Jul 2007 16:08:46 +0200
Message-Id: <11846813444176-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1184681344594-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org> <11846813432234-git-send-email-sam@ravnborg.org> <11846813441521-git-send-email-sam@ravnborg.org> <11846813443387-git-send-email-sam@ravnborg.org> <1184681344594-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move more checks from whitelist to the section check functions.
Remove the redundent pci_fixup check.
Renumber the patterns.
No functional changes.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |   32 +++++++-------------------------
 1 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index f22c8b4..1ef7875 100644
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
@@ -699,32 +689,22 @@ static int secref_whitelist(const char *modname, const char *tosec,
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
 
@@ -1088,7 +1068,7 @@ static void check_sec_ref(struct module *mod, const char *modname,
  * section, not the ia64 .opd section.
  * ia64 .opd should not point to discarded sections.
  * [.rodata] like for .init.text we ignore .rodata references -same reason
- **/
+ */
 static int initexit_section_ref_ok(const char *name)
 {
 	const char **s;
@@ -1099,6 +1079,8 @@ static int initexit_section_ref_ok(const char *name)
 		".altinstructions",
 		".cranges",		/* used by sh64 */
 		".fixup",
+		".machvec",		/* ia64 + powerpc uses these */
+		".machine.desc",
 		".opd",			/* See comment [OPD] */
 		".parainstructions",
 		".pdr",
-- 
1.5.0.6

