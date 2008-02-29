Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbYB2EKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbYB2EKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 23:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYB2EKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 23:10:40 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:37623 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbYB2EKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 23:10:39 -0500
Date: Fri, 29 Feb 2008 05:10:24 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kiran@scalemp.com, shai@scalemp.com, Glauber Costa <gcosta@redhat.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 2/3] fix choice dependency check
In-Reply-To: <20080226194058.GA31438@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0802290509100.2723@scrub.home>
References: <200802210258.45011.yinghai.lu@sun.com> <200802241832.37850.yinghai.lu@sun.com>
 <200802242136.28744.yinghai.lu@sun.com> <200802242243.49576.yinghai.lu@sun.com>
 <20080226194058.GA31438@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Properly check the dependency of choices as a group.
Also fix that sym_check_deps() correctly terminates the dependency loop 
error check (otherwise it would continue printing the dependency chain).

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 scripts/kconfig/symbol.c |   94 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 76 insertions(+), 18 deletions(-)

Index: linux-2.6/scripts/kconfig/symbol.c
===================================================================
--- linux-2.6.orig/scripts/kconfig/symbol.c
+++ linux-2.6/scripts/kconfig/symbol.c
@@ -762,8 +762,6 @@ struct symbol **sym_re_search(const char
 }
 
 
-struct symbol *sym_check_deps(struct symbol *sym);
-
 static struct symbol *sym_check_expr_deps(struct expr *e)
 {
 	struct symbol *sym;
@@ -795,40 +793,100 @@ static struct symbol *sym_check_expr_dep
 }
 
 /* return NULL when dependencies are OK */
-struct symbol *sym_check_deps(struct symbol *sym)
+static struct symbol *sym_check_sym_deps(struct symbol *sym)
 {
 	struct symbol *sym2;
 	struct property *prop;
 
-	if (sym->flags & SYMBOL_CHECK) {
-		fprintf(stderr, "%s:%d:error: found recursive dependency: %s",
-		        sym->prop->file->name, sym->prop->lineno, sym->name);
-		return sym;
-	}
-	if (sym->flags & SYMBOL_CHECKED)
-		return NULL;
-
-	sym->flags |= (SYMBOL_CHECK | SYMBOL_CHECKED);
 	sym2 = sym_check_expr_deps(sym->rev_dep.expr);
 	if (sym2)
-		goto out;
+		return sym2;
 
 	for (prop = sym->prop; prop; prop = prop->next) {
 		if (prop->type == P_CHOICE || prop->type == P_SELECT)
 			continue;
 		sym2 = sym_check_expr_deps(prop->visible.expr);
 		if (sym2)
-			goto out;
+			break;
 		if (prop->type != P_DEFAULT || sym_is_choice(sym))
 			continue;
 		sym2 = sym_check_expr_deps(prop->expr);
 		if (sym2)
-			goto out;
+			break;
 	}
-out:
+
+	return sym2;
+}
+
+static struct symbol *sym_check_choice_deps(struct symbol *choice)
+{
+	struct symbol *sym, *sym2;
+	struct property *prop;
+	struct expr *e;
+
+	prop = sym_get_choice_prop(choice);
+	expr_list_for_each_sym(prop->expr, e, sym)
+		sym->flags |= (SYMBOL_CHECK | SYMBOL_CHECKED);
+
+	choice->flags |= (SYMBOL_CHECK | SYMBOL_CHECKED);
+	sym2 = sym_check_sym_deps(choice);
+	choice->flags &= ~SYMBOL_CHECK;
 	if (sym2)
-		fprintf(stderr, " -> %s%s", sym->name, sym2 == sym? "\n": "");
-	sym->flags &= ~SYMBOL_CHECK;
+		goto out;
+
+	expr_list_for_each_sym(prop->expr, e, sym) {
+		sym2 = sym_check_sym_deps(sym);
+		if (sym2) {
+			fprintf(stderr, " -> %s", sym->name);
+			break;
+		}
+	}
+out:
+	expr_list_for_each_sym(prop->expr, e, sym)
+		sym->flags &= ~SYMBOL_CHECK;
+
+	if (sym2 && sym_is_choice_value(sym2) &&
+	    prop_get_symbol(sym_get_choice_prop(sym2)) == choice)
+		sym2 = choice;
+
+	return sym2;
+}
+
+struct symbol *sym_check_deps(struct symbol *sym)
+{
+	struct symbol *sym2;
+	struct property *prop;
+
+	if (sym->flags & SYMBOL_CHECK) {
+		fprintf(stderr, "%s:%d:error: found recursive dependency: %s",
+		        sym->prop->file->name, sym->prop->lineno,
+			sym->name ? sym->name : "<choice>");
+		return sym;
+	}
+	if (sym->flags & SYMBOL_CHECKED)
+		return NULL;
+
+	if (sym_is_choice_value(sym)) {
+		/* for choice groups start the check with main choice symbol */
+		prop = sym_get_choice_prop(sym);
+		sym2 = sym_check_deps(prop_get_symbol(prop));
+	} else if (sym_is_choice(sym)) {
+		sym2 = sym_check_choice_deps(sym);
+	} else {
+		sym->flags |= (SYMBOL_CHECK | SYMBOL_CHECKED);
+		sym2 = sym_check_sym_deps(sym);
+		sym->flags &= ~SYMBOL_CHECK;
+	}
+
+	if (sym2) {
+		fprintf(stderr, " -> %s", sym->name ? sym->name : "<choice>");
+		if (sym2 == sym) {
+			fprintf(stderr, "\n");
+			zconfnerrs++;
+			sym2 = NULL;
+		}
+	}
+
 	return sym2;
 }
 
