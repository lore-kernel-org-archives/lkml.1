Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbXIAG22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbXIAG22 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 02:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbXIAG2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 02:28:20 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:42714 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbXIAG2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 02:28:19 -0400
Date: Sat, 1 Sep 2007 08:29:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Cc: Hugh Dickins <hugh@veritas.com>, Roman Zippel <zippel@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PATCH] kconfig: fix overly agressive make oldconfig
Message-ID: <20070901062940.GA1520@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is both -rc and stable material.
Subject: kconfig: oldconfig shall not set symbols if it does not need to
From: Roman Zippel <zippel@linux-m68k.org>

Avoid setting the value if the symbol doesn't need to be changed or can't
be changed. Later choices may change the dependencies and thus the
possible input range.

make oldconfig from a 2.6.22 .config with CONFIG_HOTPLUG_CPU not set
was in some configurations setting CONFIG_HOTPLUG_CPU=y without asking,
even when there was no actual requirement for CONFIG_HOTPLUG_CPU.
This was triggered by SUSPEND_SMP that does a select HOTPLUG_CPU.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Tested-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

The patch can be pulled from (when mirrored out):
git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fix.git

	Sam


 scripts/kconfig/conf.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

Index: linux-2.6/scripts/kconfig/conf.c
===================================================================
--- linux-2.6.orig/scripts/kconfig/conf.c
+++ linux-2.6/scripts/kconfig/conf.c
@@ -72,7 +72,7 @@ static void check_stdin(void)
 	}
 }
 
-static void conf_askvalue(struct symbol *sym, const char *def)
+static int conf_askvalue(struct symbol *sym, const char *def)
 {
 	enum symbol_type type = sym_get_type(sym);
 	tristate val;
@@ -87,7 +87,7 @@ static void conf_askvalue(struct symbol 
 		printf("%s\n", def);
 		line[0] = '\n';
 		line[1] = 0;
-		return;
+		return 0;
 	}
 
 	switch (input_mode) {
@@ -97,23 +97,23 @@ static void conf_askvalue(struct symbol 
 	case set_random:
 		if (sym_has_value(sym)) {
 			printf("%s\n", def);
-			return;
+			return 0;
 		}
 		break;
 	case ask_new:
 	case ask_silent:
 		if (sym_has_value(sym)) {
 			printf("%s\n", def);
-			return;
+			return 0;
 		}
 		check_stdin();
 	case ask_all:
 		fflush(stdout);
 		fgets(line, 128, stdin);
-		return;
+		return 1;
 	case set_default:
 		printf("%s\n", def);
-		return;
+		return 1;
 	default:
 		break;
 	}
@@ -123,7 +123,7 @@ static void conf_askvalue(struct symbol 
 	case S_HEX:
 	case S_STRING:
 		printf("%s\n", def);
-		return;
+		return 1;
 	default:
 		;
 	}
@@ -174,6 +174,7 @@ static void conf_askvalue(struct symbol 
 		break;
 	}
 	printf("%s", line);
+	return 1;
 }
 
 int conf_string(struct menu *menu)
@@ -187,7 +188,8 @@ int conf_string(struct menu *menu)
 		def = sym_get_string_value(sym);
 		if (sym_get_string_value(sym))
 			printf("[%s] ", def);
-		conf_askvalue(sym, def);
+		if (!conf_askvalue(sym, def))
+			return 0;
 		switch (line[0]) {
 		case '\n':
 			break;
@@ -240,7 +242,8 @@ static int conf_sym(struct menu *menu)
 		if (menu_has_help(menu))
 			printf("/?");
 		printf("] ");
-		conf_askvalue(sym, sym_get_string_value(sym));
+		if (!conf_askvalue(sym, sym_get_string_value(sym)))
+			return 0;
 		strip(line);
 
 		switch (line[0]) {

