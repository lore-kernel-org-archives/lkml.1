Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbYANDuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbYANDuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 22:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbYANDu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 22:50:27 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:3527 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbYANDuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 22:50:25 -0500
Date: Mon, 14 Jan 2008 04:50:23 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [PATCH 1/3] explicitly introduce expression list
In-Reply-To: <20080106132601.GA3139@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0801140449570.17507@scrub.home>
References: <20071110204038.GA13140@uranus.ravnborg.org>
 <11947274093185-git-send-email-sam@ravnborg.org> <11947274091127-git-send-email-sam@ravnborg.org>
 <Pine.LNX.4.64.0711142116500.1818@scrub.home> <20071114220840.GB10920@uranus.ravnborg.org>
 <Pine.LNX.4.64.0711151616330.1817@scrub.home> <20080106132601.GA3139@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rename E_CHOICE to E_LIST to explicitly add support for expression
lists. Add a helper macro expr_list_for_each_sym to more easily iterate
over the list.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 scripts/kconfig/confdata.c |    8 ++++----
 scripts/kconfig/expr.c     |   16 ++++++++--------
 scripts/kconfig/expr.h     |    5 ++++-
 scripts/kconfig/menu.c     |    2 +-
 scripts/kconfig/symbol.c   |   13 +++++++------
 5 files changed, 24 insertions(+), 20 deletions(-)

Index: linux-2.6/scripts/kconfig/confdata.c
===================================================================
--- linux-2.6.orig/scripts/kconfig/confdata.c
+++ linux-2.6/scripts/kconfig/confdata.c
@@ -316,7 +316,7 @@ load:
 
 int conf_read(const char *name)
 {
-	struct symbol *sym;
+	struct symbol *sym, *choice_sym;
 	struct property *prop;
 	struct expr *e;
 	int i, flags;
@@ -357,9 +357,9 @@ int conf_read(const char *name)
 		 */
 		prop = sym_get_choice_prop(sym);
 		flags = sym->flags;
-		for (e = prop->expr; e; e = e->left.expr)
-			if (e->right.sym->visible != no)
-				flags &= e->right.sym->flags;
+		expr_list_for_each_sym(prop->expr, e, choice_sym)
+			if (choice_sym->visible != no)
+				flags &= choice_sym->flags;
 		sym->flags &= flags | ~SYMBOL_DEF_USER;
 	}
 
Index: linux-2.6/scripts/kconfig/expr.c
===================================================================
--- linux-2.6.orig/scripts/kconfig/expr.c
+++ linux-2.6/scripts/kconfig/expr.c
@@ -87,7 +87,7 @@ struct expr *expr_copy(struct expr *org)
 		break;
 	case E_AND:
 	case E_OR:
-	case E_CHOICE:
+	case E_LIST:
 		e->left.expr = expr_copy(org->left.expr);
 		e->right.expr = expr_copy(org->right.expr);
 		break;
@@ -217,7 +217,7 @@ int expr_eq(struct expr *e1, struct expr
 		expr_free(e2);
 		trans_count = old_count;
 		return res;
-	case E_CHOICE:
+	case E_LIST:
 	case E_RANGE:
 	case E_NONE:
 		/* panic */;
@@ -648,7 +648,7 @@ struct expr *expr_transform(struct expr 
 	case E_EQUAL:
 	case E_UNEQUAL:
 	case E_SYMBOL:
-	case E_CHOICE:
+	case E_LIST:
 		break;
 	default:
 		e->left.expr = expr_transform(e->left.expr);
@@ -932,7 +932,7 @@ struct expr *expr_trans_compare(struct e
 		break;
 	case E_SYMBOL:
 		return expr_alloc_comp(type, e->left.sym, sym);
-	case E_CHOICE:
+	case E_LIST:
 	case E_RANGE:
 	case E_NONE:
 		/* panic */;
@@ -1000,9 +1000,9 @@ int expr_compare_type(enum expr_type t1,
 		if (t2 == E_OR)
 			return 1;
 	case E_OR:
-		if (t2 == E_CHOICE)
+		if (t2 == E_LIST)
 			return 1;
-	case E_CHOICE:
+	case E_LIST:
 		if (t2 == 0)
 			return 1;
 	default:
@@ -1053,11 +1053,11 @@ void expr_print(struct expr *e, void (*f
 		fn(data, NULL, " && ");
 		expr_print(e->right.expr, fn, data, E_AND);
 		break;
-	case E_CHOICE:
+	case E_LIST:
 		fn(data, e->right.sym, e->right.sym->name);
 		if (e->left.expr) {
 			fn(data, NULL, " ^ ");
-			expr_print(e->left.expr, fn, data, E_CHOICE);
+			expr_print(e->left.expr, fn, data, E_LIST);
 		}
 		break;
 	case E_RANGE:
Index: linux-2.6/scripts/kconfig/expr.h
===================================================================
--- linux-2.6.orig/scripts/kconfig/expr.h
+++ linux-2.6/scripts/kconfig/expr.h
@@ -32,7 +32,7 @@ typedef enum tristate {
 } tristate;
 
 enum expr_type {
-	E_NONE, E_OR, E_AND, E_NOT, E_EQUAL, E_UNEQUAL, E_CHOICE, E_SYMBOL, E_RANGE
+	E_NONE, E_OR, E_AND, E_NOT, E_EQUAL, E_UNEQUAL, E_LIST, E_SYMBOL, E_RANGE
 };
 
 union expr_data {
@@ -49,6 +49,9 @@ struct expr {
 #define E_AND(dep1, dep2)	(((dep1)<(dep2))?(dep1):(dep2))
 #define E_NOT(dep)		(2-(dep))
 
+#define expr_list_for_each_sym(l, e, s) \
+	for (e = (l); e && (s = e->right.sym); e = e->left.expr)
+
 struct expr_value {
 	struct expr *expr;
 	tristate tri;
Index: linux-2.6/scripts/kconfig/menu.c
===================================================================
--- linux-2.6.orig/scripts/kconfig/menu.c
+++ linux-2.6/scripts/kconfig/menu.c
@@ -331,7 +331,7 @@ void menu_finalize(struct menu *parent)
 			prop = sym_get_choice_prop(sym);
 			for (ep = &prop->expr; *ep; ep = &(*ep)->left.expr)
 				;
-			*ep = expr_alloc_one(E_CHOICE, NULL);
+			*ep = expr_alloc_one(E_LIST, NULL);
 			(*ep)->right.sym = menu->sym;
 		}
 		if (menu->list && (!menu->prompt || !menu->prompt->text)) {
Index: linux-2.6/scripts/kconfig/symbol.c
===================================================================
--- linux-2.6.orig/scripts/kconfig/symbol.c
+++ linux-2.6/scripts/kconfig/symbol.c
@@ -247,8 +247,7 @@ static struct symbol *sym_calc_choice(st
 
 	/* just get the first visible value */
 	prop = sym_get_choice_prop(sym);
-	for (e = prop->expr; e; e = e->left.expr) {
-		def_sym = e->right.sym;
+	expr_list_for_each_sym(prop->expr, e, def_sym) {
 		sym_calc_visibility(def_sym);
 		if (def_sym->visible != no)
 			return def_sym;
@@ -361,12 +360,14 @@ void sym_calc_value(struct symbol *sym)
 	}
 
 	if (sym_is_choice(sym)) {
+		struct symbol *choice_sym;
 		int flags = sym->flags & (SYMBOL_CHANGED | SYMBOL_WRITE);
+
 		prop = sym_get_choice_prop(sym);
-		for (e = prop->expr; e; e = e->left.expr) {
-			e->right.sym->flags |= flags;
+		expr_list_for_each_sym(prop->expr, e, choice_sym) {
+			choice_sym->flags |= flags;
 			if (flags & SYMBOL_CHANGED)
-				sym_set_changed(e->right.sym);
+				sym_set_changed(choice_sym);
 		}
 	}
 }
@@ -849,7 +850,7 @@ struct property *prop_alloc(enum prop_ty
 struct symbol *prop_get_symbol(struct property *prop)
 {
 	if (prop->expr && (prop->expr->type == E_SYMBOL ||
-			   prop->expr->type == E_CHOICE))
+			   prop->expr->type == E_LIST))
 		return prop->expr->left.sym;
 	return NULL;
 }
