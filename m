Return-Path: <linux-kernel-owner+w=401wt.eu-S1759368AbZD2Uqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbZD2Uqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbZD2Uqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:46:38 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:43686 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZD2Uqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:46:37 -0400
Date: Wed, 29 Apr 2009 22:48:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Fix bogus modpost warnings
Message-ID: <20090429204846.GA655@uranus.ravnborg.org>
References: <20090429123211.GA12874@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429123211.GA12874@linux-mips.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 02:32:11PM +0200, Ralf Baechle wrote:
> Trying to build the current kernel with gcc 4.4.0 will result in a large
> number of apparently bogus warnings like these:
> 
> WARNING: crypto/cryptd.o (.text.T.349): unexpected section name.
> The (.[number]+) following section name are ld generated and not expected.
> Did you forget to use "ax"/"aw" in a .S file?
> Note that for example <linux/init.h> contains
> section definitions for use in .S files.
> 
> WARNING: drivers/block/pktcdvd.o (.text.T.772): unexpected section name.
> The (.[number]+) following section name are ld generated and not expected.
> Did you forget to use "ax"/"aw" in a .S file?
> Note that for example <linux/init.h> contains
> section definitions for use in .S files.
> 
> emitted by modpost.  This is because with -ffunction-sections gcc may now
> generate some section names like .text.T.772 itself instead of like in
> the past deriving those from the function's name like .text.ipgre_close.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> ---
> 
> For now I see this patch as a proposal only.  I'm also not sure if with
> this addition check there are still section names left for which the if
> condition would ever be true.  Data sections maybe?

Anders Kaseorg already wrote a better patch to fix this - appended below.
Could you please give it a try and let me know it it
works for you too.

It is about to be applied to kbuild-next - I have just been sidetracked
by other stuff.

	Sam


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
index f39132b..3e6ff75 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -716,41 +716,27 @@ int match(const char *sym, const char * const pat[])
 
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
 
 
@@ -1377,7 +1363,7 @@ static void section_rela(const char *modname, struct elf_info *elf,
 	fromsec = sech_name(elf, sechdr);
 	fromsec += strlen(".rela");
 	/* if from section (name) is know good then skip it */
-	if (check_section(modname, fromsec))
+	if (match(fromsec, section_white_list))
 		return;
 
 	for (rela = start; rela < stop; rela++) {
@@ -1421,7 +1407,7 @@ static void section_rel(const char *modname, struct elf_info *elf,
 	fromsec = sech_name(elf, sechdr);
 	fromsec += strlen(".rel");
 	/* if from section (name) is know good then skip it */
-	if (check_section(modname, fromsec))
+	if (match(fromsec, section_white_list))
 		return;
 
 	for (rel = start; rel < stop; rel++) {
@@ -1484,6 +1470,7 @@ static void check_sec_ref(struct module *mod, const char *modname,
 
 	/* Walk through all sections */
 	for (i = 0; i < elf->hdr->e_shnum; i++) {
+		check_section(modname, elf, &elf->sechdrs[i]);
 		/* We want to process only relocation sections and not .init */
 		if (sechdrs[i].sh_type == SHT_RELA)
 			section_rela(modname, elf, &elf->sechdrs[i]);
-- 
1.6.2.1

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

