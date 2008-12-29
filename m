Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbYL2Nwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbYL2Nwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYL2Nvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:51:52 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:36134 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYL2Nvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:51:49 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH 06/13] kconfig: print all locations when we see a recursive dependency
Date: Mon, 29 Dec 2008 14:53:16 +0100
Message-Id: <1230558803-7168-6-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081229134402.GA7069@uranus.ravnborg.org>
References: <20081229134402.GA7069@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is nessesary to know all locations when trying to track
a recursive dependency. So print out all locations for each symbol.

Sample output:
Kconfig:1: found recursive dependency:
            TEST1
         -> TEST2 (Kconfig:4),(Kconfig:12)
         -> TEST1 (Kconfig:1),(Kconfig:7)

In a more complex example the symbols can be defined in different
files thus making it harder to track.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 scripts/kconfig/symbol.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 474dae2..fc62f34 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -790,6 +790,21 @@ static struct symbol *sym_check_expr_deps(struct expr *e)
 	return NULL;
 }
 
+static void print_symbol_location(struct symbol *sym)
+{
+	struct property *prop;
+	int comma = 0;
+
+	fprintf(stderr, "\t -> %s ", sym->name ? sym->name : "<choice>");
+	for (prop = sym->prop; prop; prop = prop->next) {
+		if (prop->type == P_SYMBOL) {
+			fprintf(stderr, "%s(%s:%d)",
+			comma ? "," : "", prop->file->name, prop->lineno);
+			comma = 1;
+		}
+	}
+	fprintf(stderr, "\n");
+}
 /* return NULL when dependencies are OK */
 static struct symbol *sym_check_sym_deps(struct symbol *sym)
 {
@@ -835,7 +850,7 @@ static struct symbol *sym_check_choice_deps(struct symbol *choice)
 	expr_list_for_each_sym(prop->expr, e, sym) {
 		sym2 = sym_check_sym_deps(sym);
 		if (sym2) {
-			fprintf(stderr, " -> %s", sym->name);
+			print_symbol_location(sym);
 			break;
 		}
 	}
@@ -856,7 +871,7 @@ struct symbol *sym_check_deps(struct symbol *sym)
 	struct property *prop;
 
 	if (sym->flags & SYMBOL_CHECK) {
-		fprintf(stderr, "%s:%d:error: found recursive dependency:\n",
+		fprintf(stderr, "%s:%d: found recursive dependency:\n",
 		        sym->prop->file->name, sym->prop->lineno);
 		fprintf(stderr, "\t    %s\n",
 			sym->name ? sym->name : "<choice>");
@@ -878,11 +893,8 @@ struct symbol *sym_check_deps(struct symbol *sym)
 	}
 
 	if (sym2) {
-		fprintf(stderr, "\t -> %s (%s:%d)\n",
-		        sym->name ? sym->name : "<choice>",
-			sym->prop->file->name, sym->prop->lineno);
+		print_symbol_location(sym);
 		if (sym2 == sym) {
-			fprintf(stderr, "\n");
 			zconfnerrs++;
 			sym2 = NULL;
 		}
-- 
1.6.0.2.GIT

