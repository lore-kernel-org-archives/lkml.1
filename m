Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbYAXLxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbYAXLxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 06:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbYAXLxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 06:53:48 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:15886
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753562AbYAXLxr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 06:53:47 -0500
Message-Id: <47988A7F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 24 Jan 2008 11:54:23 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Roman Zippel" <zippel@linux-m68k.org>, <sam@ravnborg.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] tristate choices with mixed tristate and boolean
	values (v3)
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

Also fix scripts/kconfig/conf's handling of children of choice values -
there may be more than one immediate child, and all of them need to be
processed.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 scripts/kconfig/conf.c |    4 ++--
 scripts/kconfig/expr.c |   10 ++++++++--
 scripts/kconfig/menu.c |   33 ++++++++++++++++++++++++++++++---
 3 files changed, 45 insertions(+), 7 deletions(-)

--- linux-2.6.24-rc8/scripts/kconfig/conf.c
+++ 2.6.24-rc8-tristate-choices/scripts/kconfig/conf.c
@@ -399,9 +399,9 @@ static int conf_choice(struct menu *menu
 			continue;
 		}
 		sym_set_choice_value(sym, child->sym);
-		if (child->list) {
+		for (child = child->list; child; child = child->next) {
 			indent += 2;
-			conf(child->list);
+			conf(child);
 			indent -= 2;
 		}
 		return 1;
--- linux-2.6.24-rc8/scripts/kconfig/expr.c
+++ 2.6.24-rc8-tristate-choices/scripts/kconfig/expr.c
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
--- linux-2.6.24-rc8/scripts/kconfig/menu.c
+++ 2.6.24-rc8-tristate-choices/scripts/kconfig/menu.c
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
@@ -326,7 +328,37 @@ void menu_finalize(struct menu *parent)
 					    "values not supported");
 			}
 			current_entry = menu;
-			menu_set_type(sym->type);
+			if (menu->sym->type == S_UNKNOWN)
+				menu_set_type(sym->type);
+			/* Non-tristate choice values of tristate choices must
+			 * depend on the choice being set to Y. The choice
+			 * values' dependencies were propagated to their
+			 * properties above, so the change here must be re-
+			 * propagated. */
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



