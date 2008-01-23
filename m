Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbYAWQoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbYAWQoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYAWQoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:44:11 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:31720
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447AbYAWQoK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:44:10 -0500
Message-Id: <47977D08.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 23 Jan 2008 16:44:40 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] tristate choices with mixed tristate and boolean
	values (v2)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change kconfig behavior so that mixing bool and tristate config
settings in a choice is possible and has the desired effect of offering
just the tristate options individually if the choice gets set to M, and
a normal boolean selection if the choice gets set to Y.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 scripts/kconfig/expr.c |   10 ++++++++--
 scripts/kconfig/menu.c |   33 ++++++++++++++++++++++++++++++---
 2 files changed, 38 insertions(+), 5 deletions(-)

--- linux-2.6.24-rc8/scripts/kconfig/expr.c	2006-09-20 05:42:06.000000000 +0200
+++ 2.6.24-rc8-tristate-choices/scripts/kconfig/expr.c	2008-01-21 13:32:44.000000000 +0100
@@ -1034,12 +1034,18 @@ void expr_print(struct expr *e, void (*f
 		expr_print(e->left.expr, fn, data, E_NOT);
 		break;
 	case E_EQUAL:
-		fn(data, e->left.sym, e->left.sym->name);
+		if (e->left.sym->name)
+			fn(data, e->left.sym, e->left.sym->name);
+		else
+			fn(data, NULL, "<choice>");
 		fn(data, NULL, "=");
 		fn(data, e->right.sym, e->right.sym->name);
 		break;
 	case E_UNEQUAL:
-		fn(data, e->left.sym, e->left.sym->name);
+		if (e->left.sym->name)
+			fn(data, e->left.sym, e->left.sym->name);
+		else
+			fn(data, NULL, "<choice>");
 		fn(data, NULL, "!=");
 		fn(data, e->right.sym, e->right.sym->name);
 		break;
--- linux-2.6.24-rc8/scripts/kconfig/menu.c	2007-10-09 22:31:38.000000000 +0200
+++ 2.6.24-rc8-tristate-choices/scripts/kconfig/menu.c	2008-01-22 09:36:59.000000000 +0100
@@ -239,9 +239,11 @@ void menu_finalize(struct menu *parent)
 			for (menu = parent->list; menu; menu = menu->next) {
 				if (menu->sym) {
 					current_entry = parent;
-					menu_set_type(menu->sym->type);
+					if (sym->type == S_UNKNOWN)
+						menu_set_type(menu->sym->type);
 					current_entry = menu;
-					menu_set_type(sym->type);
+					if (menu->sym->type == S_UNKNOWN)
+						menu_set_type(sym->type);
 					break;
 				}
 			}
@@ -326,7 +328,32 @@ void menu_finalize(struct menu *parent)
 					    "values not supported");
 			}
 			current_entry = menu;
-			menu_set_type(sym->type);
+			if (menu->sym->type == S_UNKNOWN)
+				menu_set_type(sym->type);
+			if (sym->type == S_TRISTATE && menu->sym->type != S_TRISTATE) {
+				basedep = expr_alloc_comp(E_EQUAL, sym, &symbol_yes);
+				basedep = expr_alloc_and(basedep, menu->dep);
+				basedep = expr_eliminate_dups(basedep);
+				menu->dep = basedep;
+				for (prop = menu->sym->prop; prop; prop = prop->next) {
+					if (prop->menu != menu)
+						continue;
+					dep = expr_alloc_and(expr_copy(basedep),
+							     prop->visible.expr);
+					dep = expr_eliminate_dups(dep);
+					dep = expr_trans_bool(dep);
+					prop->visible.expr = dep;
+					if (prop->type == P_SELECT) {
+						struct symbol *es = prop_get_symbol(prop);
+						dep2 = expr_alloc_symbol(menu->sym);
+						dep = expr_alloc_and(dep2,
+								     expr_copy(dep));
+						dep = expr_alloc_or(es->rev_dep.expr, dep);
+						dep = expr_eliminate_dups(dep);
+						es->rev_dep.expr = dep;
+					}
+				}
+			}
 			menu_add_symbol(P_CHOICE, sym, NULL);
 			prop = sym_get_choice_prop(sym);
 			for (ep = &prop->expr; *ep; ep = &(*ep)->left.expr)



