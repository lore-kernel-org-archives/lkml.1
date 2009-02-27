Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbZB0CLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbZB0CLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 21:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZB0CKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 21:10:55 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61906 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227AbZB0CKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 21:10:54 -0500
Date: Thu, 26 Feb 2009 21:10:13 -0500 (EST)
From: Anders Kaseorg <andersk@MIT.EDU>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Tim Abbott <tabbott@MIT.EDU>, linux-kernel@vger.kernel.org,
       Jeff Arnold <jbarnold@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] modpost: Check the section flags, not name, to catch missing
 "ax"/"aw"
In-Reply-To: <49A49D2B.8050701@zytor.com>
Message-ID: <alpine.DEB.2.00.0902262057080.9996@vinegar-pot.mit.edu>
References: <1235521315-3424-1-git-send-email-tabbott@mit.edu> <1235521315-3424-2-git-send-email-tabbott@mit.edu> <1235521315-3424-3-git-send-email-tabbott@mit.edu> <49A49D2B.8050701@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, H. Peter Anvin wrote:
> This is a pretty critical set of warnings, that often represent real 
> bugs.  I don't think it's acceptable to lose them.  However, you already 
> have (prior in the sequence) changed those section names to not conflict 
> with the automatically generated ones, so it seems to me that this 
> should be fixable without too much pain.

Actually, the problem arises from a conflict between two classes of 
automatically generated section names, one from ld, and one from gcc.  
Instead of basing the warning on section names (the existing heuristic 
also fails to warn on some cases where it should, as it turns out), what 
do you think about this patch?  I've tested that it still triggers the 
warning when an "ax" or "aw" is incorrectly removed, and it should handle 
even more cases than before.

Anders

[PATCH] modpost: Check the section flags, not name, to catch missing "ax"/"aw"

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
index 8892161..bb794fa 100644
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
1.6.1.3

