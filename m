Return-Path: <linux-kernel-owner+w=401wt.eu-S1764165AbXE2Uea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764165AbXE2Uea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761718AbXE2UdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:33:20 -0400
Received: from gw.goop.org ([64.81.55.164]:52844 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbXE2UdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:33:18 -0400
Message-ID: <465C8E10.8040608@goop.org>
Date: Tue, 29 May 2007 13:33:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>, Sam Ravnborg <sam@ravnborg.org>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] Tell modpost that any reference from .note* is OK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

.note* sections are ELF notes, which are typically used by external
tools to examine the kernel image.  Since this is removed from any
runtime consideration, it's OK to reference any section from a .note*
section.

As a side-effect, this changes secref_whitelist to accept a NULL "atsym"
pointer, allowing it to be called when "before" is NULL.  This is
needed for .note sections since they don't necessarily have any
symbols, and it also allows the .got2 check to to be folded into the
normal whitelist checks.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sam Ravnborg <sam@ravnborg.org>

---
 scripts/mod/modpost.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

===================================================================
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -639,6 +639,14 @@ static int strrcmp(const char *s, const 
  *  powerpc has a machine desc table for each platform.
  *  It is mixture of function pointers of .init.text and .text.
  *  fromsec  = .machvec | .machine.desc
+ *
+ * Pattern 11:
+ *  Any reference from an ELF note section (.note*) to another section
+ *  is OK.  ELF notes are only used by tools inspecting the actual
+ *  kernel image, so runtime access is not an issue.
+ *
+ * Pattern 12:
+ *  powerpc has a GOT table in .got2 section
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
@@ -675,7 +683,7 @@ static int secref_whitelist(const char *
 		f1 = 0;
 	if (strncmp(fromsec, ".data", strlen(".data")) != 0)
 		f1 = 0;
-	if (strncmp(atsym, "__param", strlen("__param")) != 0)
+	if (!atsym || strncmp(atsym, "__param", strlen("__param")) != 0)
 		f1 = 0;
 
 	if (f1)
@@ -690,7 +698,7 @@ static int secref_whitelist(const char *
 		f2 = 0;
 
 	for (s = pat2sym; *s; s++)
-		if (strrcmp(atsym, *s) == 0)
+		if (atsym && strrcmp(atsym, *s) == 0)
 			f1 = 1;
 	if (f1 && f2)
 		return 1;
@@ -720,6 +728,14 @@ static int secref_whitelist(const char *
 	/* Check for pattern 10 */
 	if ((strcmp(fromsec, ".machvec") == 0) ||
 	    (strcmp(fromsec, ".machine.desc") == 0))
+		return 1;
+
+	/* Check for pattern 11 */
+	if (strncmp(fromsec, ".note", strlen(".note")) == 0)
+		return 1;
+
+	/* Check for pattern 12 */
+	if (strcmp(fromsec, ".got2") == 0)
 		return 1;
 
 	return 0;
@@ -848,14 +864,9 @@ static void warn_sec_mismatch(const char
 		refsymname = elf->strtab + refsym->st_name;
 
 	/* check whitelist - we may ignore it */
-	if (before &&
-	    secref_whitelist(modname, secname, fromsec,
-			     elf->strtab + before->st_name, refsymname))
-		return;
-
-	/* fromsec whitelist - without a valid 'before'
-	 * powerpc has a GOT table in .got2 section */
-	if (strcmp(fromsec, ".got2") == 0)
+	if (secref_whitelist(modname, secname, fromsec,
+			     before ? (elf->strtab + before->st_name) : NULL,
+			     refsymname))
 		return;
 
 	if (before && after) {


