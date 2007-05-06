Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbXEFHjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbXEFHjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 03:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbXEFHjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 03:39:45 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52837 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296AbXEFHjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 03:39:45 -0400
Date: Sun, 6 May 2007 09:40:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Bunk <bunk@stusta.de>, Roman Zippel <zippel@linux-m68k.org>
Subject: kconfig: error out if recursive dependencies are found
Message-ID: <20070506074038.GB6492@uranus.ravnborg.org>
References: <20070502201741.GD9044@uranus.ravnborg.org> <20070506073615.GA6492@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070506073615.GA6492@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sample:
config FOO
	bool "This is foo"
	depends on BAR

config BAR
	bool "This is bar"
	depends on FOO

This will result in following error message:
error: found recursive dependency: FOO -> BAR -> FOO

And will then exit with exit code equal 1 so make will stop.
Inspired by patch from: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 scripts/kconfig/symbol.c            |   13 +++++--------
 scripts/kconfig/zconf.tab.c_shipped |    6 ++++--
 scripts/kconfig/zconf.y             |    6 ++++--
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 8f06c47..c35dcc5 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -786,13 +786,15 @@ static struct symbol *sym_check_expr_deps(struct expr *e)
 	return NULL;
 }
 
+/* return NULL when dependencies are OK */
 struct symbol *sym_check_deps(struct symbol *sym)
 {
 	struct symbol *sym2;
 	struct property *prop;
 
 	if (sym->flags & SYMBOL_CHECK) {
-		printf("Warning! Found recursive dependency: %s", sym->name);
+		fprintf(stderr, "%s:%d:error: found recursive dependency: %s",
+		        sym->prop->file->name, sym->prop->lineno, sym->name);
 		return sym;
 	}
 	if (sym->flags & SYMBOL_CHECKED)
@@ -816,13 +818,8 @@ struct symbol *sym_check_deps(struct symbol *sym)
 			goto out;
 	}
 out:
-	if (sym2) {
-		printf(" %s", sym->name);
-		if (sym2 == sym) {
-			printf("\n");
-			sym2 = NULL;
-		}
-	}
+	if (sym2)
+		fprintf(stderr, " -> %s%s", sym->name, sym2 == sym? "\n": "");
 	sym->flags &= ~SYMBOL_CHECK;
 	return sym2;
 }
diff --git a/scripts/kconfig/zconf.tab.c_shipped b/scripts/kconfig/zconf.tab.c_shipped
index d777fe8..9a06b67 100644
--- a/scripts/kconfig/zconf.tab.c_shipped
+++ b/scripts/kconfig/zconf.tab.c_shipped
@@ -2132,9 +2132,11 @@ void conf_parse(const char *name)
 	}
 	menu_finalize(&rootmenu);
 	for_all_symbols(i, sym) {
-		sym_check_deps(sym);
+		if (sym_check_deps(sym))
+			zconfnerrs++;
         }
-
+	if (zconfnerrs)
+		exit(1);
 	sym_set_change_count(1);
 }
 
diff --git a/scripts/kconfig/zconf.y b/scripts/kconfig/zconf.y
index 04a5864..92eb02b 100644
--- a/scripts/kconfig/zconf.y
+++ b/scripts/kconfig/zconf.y
@@ -501,9 +501,11 @@ void conf_parse(const char *name)
 	}
 	menu_finalize(&rootmenu);
 	for_all_symbols(i, sym) {
-		sym_check_deps(sym);
+		if (sym_check_deps(sym))
+			zconfnerrs++;
         }
-
+	if (zconfnerrs)
+		exit(1);
 	sym_set_change_count(1);
 }
 
-- 
1.5.1.rc3.20.gaa453

