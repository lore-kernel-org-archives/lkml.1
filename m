Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbZCXFaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbZCXFaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 01:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbZCXF3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 01:29:50 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:34500 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880AbZCXF3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 01:29:49 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/4] modpost: Check the section flags, not name, to catch missing "ax"/"aw"
Date: Tue, 24 Mar 2009 01:28:43 -0400
Message-Id: <1237872525-31014-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1237872525-31014-2-git-send-email-tabbott@mit.edu>
References: <1237872525-31014-1-git-send-email-tabbott@mit.edu>
 <1237872525-31014-2-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anders Kaseorg <andersk@mit.edu>

When you put
  .section ".foo"
in an assembly file instead of
  .section "foo", "ax"
, one of the possible symptoms is that modpost will see an
ld-generated section name ".foo.1" in section_rel() or section_rela().
But this heuristic has two problems: it will miss a bad section that
has no relocations, and it will incorrectly flag many gcc-generated
sections as bad when compiling with -ffunction-sections
-fdata-sections.

So instead of checking whether the section name matches a particular
pattern, we directly check for a missing SHF_ALLOC in the section
flags.

Signed-off-by: Anders Kaseorg <andersk@mit.edu>
---
 scripts/mod/modpost.c |   49 ++++++++++++++++++-------------------------------
 1 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index a7e282e..fba468a 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -713,41 +713,27 @@ int match(const char *sym, const char * const pat[])
 
 /* sections that we do not want to do full section mismatch check on */
 static const char *section_white_list[] =
-	{ ".debug*", ".stab*", ".note*", ".got*", ".toc*", NULL };
+	{ ".comment", ".debug*", ".stab*", ".note*", ".got*", ".toc*", NULL };
 
 /*
- * Is this section one we do not want to check?
- * This is often debug sections.
- * If we are going to check this section then
- * test if section name ends with a dot and a number.
- * This is used to find sections where the linker have
- * appended a dot-number to make the name unique.
+ * This is used to find sections missing the SHF_ALLOC flag.
  * The cause of this is often a section specified in assembler
- * without "ax" / "aw" and the same section used in .c
- * code where gcc add these.
+ * without "ax" / "aw".
  */
-static int check_section(const char *modname, const char *sec)
-{
-	const char *e = sec + strlen(sec) - 1;
-	if (match(sec, section_white_list))
-		return 1;
-
-	if (*e && isdigit(*e)) {
-		/* consume all digits */
-		while (*e && e != sec && isdigit(*e))
-			e--;
-		if (*e == '.' && !strstr(sec, ".linkonce")) {
-			warn("%s (%s): unexpected section name.\n"
-			     "The (.[number]+) following section name are "
-			     "ld generated and not expected.\n"
-			     "Did you forget to use \"ax\"/\"aw\" "
-			     "in a .S file?\n"
-			     "Note that for example <linux/init.h> contains\n"
-			     "section definitions for use in .S files.\n\n",
-			     modname, sec);
-		}
+static void check_section(const char *modname, struct elf_info *elf,
+                          Elf_Shdr *sechdr)
+{
+	const char *sec = sech_name(elf, sechdr);
+
+	if (sechdr->sh_type == SHT_PROGBITS &&
+	    !(sechdr->sh_flags & SHF_ALLOC) &&
+	    !match(sec, section_white_list)) {
+		warn("%s (%s): unexpected non-allocatable section.\n"
+		     "Did you forget to use \"ax\"/\"aw\" in a .S file?\n"
+		     "Note that for example <linux/init.h> contains\n"
+		     "section definitions for use in .S files.\n\n",
+		     modname, sec);
 	}
-	return 0;
 }
 
 
@@ -1374,7 +1360,7 @@ static void section_rela(const char *modname, struct elf_info *elf,
 	fromsec = sech_name(elf, sechdr);
 	fromsec += strlen(".rela");
 	/* if from section (name) is know good then skip it */
-	if (check_section(modname, fromsec))
+	if (match(fromsec, section_white_list))
 		return;
 
 	for (rela = start; rela < stop; rela++) {
@@ -1418,7 +1404,7 @@ static void section_rel(const char *modname, struct elf_info *elf,
 	fromsec = sech_name(elf, sechdr);
 	fromsec += strlen(".rel");
 	/* if from section (name) is know good then skip it */
-	if (check_section(modname, fromsec))
+	if (match(fromsec, section_white_list))
 		return;
 
 	for (rel = start; rel < stop; rel++) {
@@ -1481,6 +1467,7 @@ static void check_sec_ref(struct module *mod, const char *modname,
 
 	/* Walk through all sections */
 	for (i = 0; i < elf->hdr->e_shnum; i++) {
+		check_section(modname, elf, &elf->sechdrs[i]);
 		/* We want to process only relocation sections and not .init */
 		if (sechdrs[i].sh_type == SHT_RELA)
 			section_rela(modname, elf, &elf->sechdrs[i]);
-- 
1.6.2

