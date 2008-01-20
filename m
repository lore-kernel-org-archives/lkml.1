Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYATUKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYATUKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 15:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbYATUJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 15:09:22 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:39065 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844AbYATUJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 15:09:10 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linux-arch@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] kbuild: check section names consistently in modpost
Date: Sun, 20 Jan 2008 21:09:00 +0100
Message-Id: <1200859743-24037-5-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <1200859743-24037-4-git-send-email-sam@ravnborg.org>
References: <20080120200527.GA23852@uranus.ravnborg.org>
 <1200859743-24037-1-git-send-email-sam@ravnborg.org>
 <1200859743-24037-2-git-send-email-sam@ravnborg.org>
 <1200859743-24037-3-git-send-email-sam@ravnborg.org>
 <1200859743-24037-4-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that match() is introduced use it consistently so
we can share the section name definitions.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |  146 ++++++++++++++++++++-----------------------------
 1 files changed, 60 insertions(+), 86 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 6c206b9..986513d 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -625,6 +625,7 @@ static int number_prefix(const char *sym)
 
 /* The pattern is an array of simple patterns.
  * "foo" will match an exact string equal to "foo"
+ * "*foo" will match a string that ends with "foo"
  * "foo*" will match a string that begins with "foo"
  * "foo$" will match a string equal to "foo" or "foo.1"
  *   where the '1' can be any number including several digits.
@@ -638,8 +639,13 @@ int match(const char *sym, const char * const pat[])
 		p = *pat++;
 		const char *endp = p + strlen(p) - 1;
 
+		/* "*foo" */
+		if (*p == '*') {
+			if (strrcmp(sym, p + 1) == 0)
+				return 1;
+		}
 		/* "foo*" */
-		if (*endp == '*') {
+		else if (*endp == '*') {
 			if (strncmp(sym, p, strlen(p) - 1) == 0)
 				return 1;
 		}
@@ -660,54 +666,6 @@ int match(const char *sym, const char * const pat[])
 	return 0;
 }
 
-/*
- * Functions used only during module init is marked __init and is stored in
- * a .init.text section. Likewise data is marked __initdata and stored in
- * a .init.data section.
- * If this section is one of these sections return 1
- * See include/linux/init.h for the details
- */
-static int init_section(const char *name)
-{
-	if (strcmp(name, ".init") == 0)
-		return 1;
-	if (strncmp(name, ".init.", strlen(".init.")) == 0)
-		return 1;
-	return 0;
-}
-
-/*
- * Functions used only during module exit is marked __exit and is stored in
- * a .exit.text section. Likewise data is marked __exitdata and stored in
- * a .exit.data section.
- * If this section is one of these sections return 1
- * See include/linux/init.h for the details
- **/
-static int exit_section(const char *name)
-{
-	if (strcmp(name, ".exit.text") == 0)
-		return 1;
-	if (strcmp(name, ".exit.data") == 0)
-		return 1;
-	return 0;
-
-}
-
-/*
- * Data sections are named like this:
- * .data | .data.rel | .data.rel.*
- * Return 1 if the specified section is a data section
- */
-static int data_section(const char *name)
-{
-	if ((strcmp(name, ".data") == 0) ||
-	    (strcmp(name, ".data.rel") == 0) ||
-	    (strncmp(name, ".data.rel.", strlen(".data.rel.")) == 0))
-		return 1;
-	else
-		return 0;
-}
-
 /* sections that we do not want to do full section mismatch check on */
 static const char *section_white_list[] =
 	{ ".debug*", ".stab*", ".note*", ".got*", ".toc*", NULL };
@@ -721,9 +679,50 @@ static const char *section_white_list[] =
 #define INIT_SECTIONS INIT_DATA_SECTIONS, INIT_TEXT_SECTIONS
 #define EXIT_SECTIONS EXIT_DATA_SECTIONS, EXIT_TEXT_SECTIONS
 
-#define DATA_SECTIONS ".data$"
+#define DATA_SECTIONS ".data$", ".data.rel$"
 #define TEXT_SECTIONS ".text$"
 
+/* init data sections */
+static const char *init_data_sections[] = { INIT_DATA_SECTIONS, NULL };
+
+/* all init sections */
+static const char *init_sections[] = { INIT_SECTIONS, NULL };
+
+/* All init and exit sections (code + data) */
+static const char *init_exit_sections[] =
+	{INIT_SECTIONS, EXIT_SECTIONS, NULL };
+
+/* data section */
+static const char *data_sections[] = { DATA_SECTIONS, NULL };
+
+/* sections that may refer to an init/exit section with no warning */
+static const char *initref_sections[] =
+{
+	".text.init.refok*",
+	".exit.text.refok*",
+	".data.init.refok*",
+	NULL
+};
+
+
+/* symbols in .data that may refer to init/exit sections */
+static const char *symbol_white_list[] =
+{
+	"*driver",
+	"*_template", /* scsi uses *_template a lot */
+	"*_timer",    /* arm uses ops structures named _timer a lot */
+	"*_sht",      /* scsi also used *_sht to some extent */
+	"*_ops",
+	"*_probe",
+	"*_probe_one",
+	"*_console",
+	NULL
+};
+
+static const char *head_sections[] = { ".head.text*", NULL };
+static const char *linker_symbols[] =
+	{ "__init_begin", "_sinittext", "_einittext", NULL };
+
 struct sectioncheck {
 	const char *fromsec[20];
 	const char *tosec[20];
@@ -817,55 +816,30 @@ static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
 			    const char *refsymname)
 {
-	const char **s;
-	const char *pat2sym[] = {
-		"driver",
-		"_template", /* scsi uses *_template a lot */
-		"_timer",    /* arm uses ops structures named _timer a lot */
-		"_sht",      /* scsi also used *_sht to some extent */
-		"_ops",
-		"_probe",
-		"_probe_one",
-		"_console",
-		NULL
-	};
-
-	const char *pat3refsym[] = {
-		"__init_begin",
-		"_sinittext",
-		"_einittext",
-		NULL
-	};
-
 	/* Check for pattern 0 */
-	if ((strncmp(fromsec, ".text.init.refok", strlen(".text.init.refok")) == 0) ||
-	    (strncmp(fromsec, ".exit.text.refok", strlen(".exit.text.refok")) == 0) ||
-	    (strncmp(fromsec, ".data.init.refok", strlen(".data.init.refok")) == 0))
+	if (match(fromsec, initref_sections))
 		return 1;
 
 	/* Check for pattern 1 */
-	if ((strcmp(tosec, ".init.data") == 0) &&
-	    (strncmp(fromsec, ".data", strlen(".data")) == 0) &&
+	if (match(tosec, init_data_sections) &&
+	    match(fromsec, data_sections) &&
 	    (strncmp(atsym, "__param", strlen("__param")) == 0))
 		return 1;
 
 	/* Check for pattern 2 */
-	if ((init_section(tosec) || exit_section(tosec))
-	    && data_section(fromsec))
-		for (s = pat2sym; *s; s++)
-			if (strrcmp(atsym, *s) == 0)
-				return 1;
+	if (match(tosec, init_exit_sections) &&
+	    match(fromsec, data_sections) &&
+	    match(atsym, symbol_white_list))
+		return 1;
 
 	/* Check for pattern 3 */
-	if ((strcmp(fromsec, ".text.head") == 0) &&
-	    ((strcmp(tosec, ".init.data") == 0) ||
-	    (strcmp(tosec, ".init.text") == 0)))
+	if (match(fromsec, head_sections) &&
+	    match(tosec, init_sections))
 	return 1;
 
 	/* Check for pattern 4 */
-	for (s = pat3refsym; *s; s++)
-		if (strcmp(refsymname, *s) == 0)
-			return 1;
+	if (match(refsymname, linker_symbols))
+		return 1;
 
 	return 0;
 }
-- 
1.5.4.rc3.14.g44397

