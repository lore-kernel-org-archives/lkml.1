Return-Path: <linux-kernel-owner+w=401wt.eu-S1761057AbYEXTZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761057AbYEXTZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 15:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYEXTZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 15:25:04 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56990 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbYEXTZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 15:25:01 -0400
Date: Sat, 24 May 2008 21:25:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [RFC PATCH] kconfig: introduce KCONFIG_* symbols for .c files
Message-ID: <20080524192540.GA28067@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have many places in the kernel that looks like
the following:

#ifdef CONFIG_FOO
	...
#endif

Which has the disadvantage that the code denoted '...'
are not even built if CONFIG_FOO is not selected in
the current configuration.

We know that gcc do simple code-elimination for
conditionals which is always true/false and
thus the above code could be turned into:

	if (CONFIG_FOO)
		...

One line smaller and we follow the normal flow in the program.
The code is always build but we do not waste space as gcc will
do proper code-elimination for us.

Today this is not possible because kconfig will only
define CONFIG_FOO if selected and FOO is not a module.

The following patch implement a new set of defines in
the KCONFIG_* namespace.

For a tristate symbol the following are defined:

FOO not selected: 
#define KCONFIG_FOO        0
#define KCONFIG_FOO_MODULE 0

FOO is built-in ('y')
#define KCONFIG_FOO        1
#define KCONFIG_FOO_MODULE 0

FOO is a module ('m'):
#define KCONFIG_FOO        1
#define KCONFIG_FOO_MODULE 1

In other words KCONFIG_FOO will say if the
symbol is selected and KCONFIG_FOO_MODULE
will say if it is a module.

With the above included we can now do:

	if (KCONFIG_FOO)
		...

This is not a replacement for the CONFIG_*
defines but a pleasant supplement.
Using KCONFIG_FOO will also give us a nice
error message the day that FOO is no longer part
of the configuration.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index ee5fe94..011a5ec 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -666,6 +666,31 @@ out:
 	return res;
 }
 
+static void write_tristate(FILE *m, FILE *h, struct symbol *sym)
+{
+	switch (sym_get_tristate_value(sym)) {
+	case mod:
+		fprintf(m, "CONFIG_%s=m\n", sym->name);
+		fprintf(h, "#define CONFIG_%s_MODULE 1\n", sym->name);
+		fprintf(h, "#define KCONFIG_%s 1\n", sym->name);
+		if (sym->type == S_TRISTATE)
+			fprintf(h, "#define KCONFIG_%s_MODULE 1\n", sym->name);
+		break;
+	case yes:
+		fprintf(m, "CONFIG_%s=y\n", sym->name);
+		fprintf(h, "#define CONFIG_%s 1\n", sym->name);
+		fprintf(h, "#define KCONFIG_%s 1\n", sym->name);
+		if (sym->type == S_TRISTATE)
+			fprintf(h, "#define KCONFIG_%s_MODULE 0\n", sym->name);
+		break;
+	case no:
+		fprintf(h, "#define KCONFIG_%s 0\n", sym->name);
+		if (sym->type == S_TRISTATE)
+			fprintf(h, "#define KCONFIG_%s_MODULE 0\n", sym->name);
+		break;
+	}
+}
+
 int conf_write_autoconf(void)
 {
 	struct symbol *sym;
@@ -716,18 +741,7 @@ int conf_write_autoconf(void)
 		switch (sym->type) {
 		case S_BOOLEAN:
 		case S_TRISTATE:
-			switch (sym_get_tristate_value(sym)) {
-			case no:
-				break;
-			case mod:
-				fprintf(out, "CONFIG_%s=m\n", sym->name);
-				fprintf(out_h, "#define CONFIG_%s_MODULE 1\n", sym->name);
-				break;
-			case yes:
-				fprintf(out, "CONFIG_%s=y\n", sym->name);
-				fprintf(out_h, "#define CONFIG_%s 1\n", sym->name);
-				break;
-			}
+			write_tristate(out, out_h, sym);
 			break;
 		case S_STRING:
 			str = sym_get_string_value(sym);
