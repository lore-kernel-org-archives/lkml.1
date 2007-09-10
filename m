Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbXIJM5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbXIJM5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 08:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbXIJM5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 08:57:14 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:43406
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756423AbXIJM5O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 08:57:14 -0400
Message-Id: <46E55B7A.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 10 Sep 2007 13:58:02 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] tristate choices with mixed tristate and boolean
	values
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change kconfig behavior so that mixing bool and tristate config
settings in a choice is possible and has the desired effect of
offering just the tristate options individually if the choice gets set
to M, and a normal boolean selection if the choice gets set to Y.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 scripts/kconfig/menu.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

--- linux-2.6.23-rc5/scripts/kconfig/menu.c	2007-09-07 16:48:23.000000000 +0200
+++ 2.6.23-rc5-tristate-choices/scripts/kconfig/menu.c	2007-09-03 10:29:41.000000000 +0200
@@ -235,16 +235,23 @@ void menu_finalize(struct menu *parent)
 	sym = parent->sym;
 	if (parent->list) {
 		if (sym && sym_is_choice(sym)) {
-			/* find the first choice value and find out choice type */
+			/* find out choice type */
+			enum symbol_type type = S_UNKNOWN;
+
 			for (menu = parent->list; menu; menu = menu->next) {
-				if (menu->sym) {
-					current_entry = parent;
-					menu_set_type(menu->sym->type);
-					current_entry = menu;
-					menu_set_type(sym->type);
-					break;
+				if (menu->sym && menu->sym->type != S_UNKNOWN) {
+					if (type == S_UNKNOWN)
+						type = menu->sym->type;
+					if (type != S_BOOLEAN)
+						break;
+					if (menu->sym->type == S_TRISTATE) {
+						type = S_TRISTATE;
+						break;
+					}
 				}
 			}
+			current_entry = parent;
+			menu_set_type(type);
 			parentdep = expr_alloc_symbol(sym);
 		} else if (parent->prompt)
 			parentdep = parent->prompt->visible.expr;
@@ -253,7 +260,16 @@ void menu_finalize(struct menu *parent)
 
 		for (menu = parent->list; menu; menu = menu->next) {
 			basedep = expr_transform(menu->dep);
-			basedep = expr_alloc_and(expr_copy(parentdep), basedep);
+			dep = parentdep;
+			if (sym && sym_is_choice(sym) && menu->sym) {
+				enum symbol_type type = menu->sym->type;
+
+				if (type == S_UNKNOWN)
+					type = sym->type;
+			     if (type != S_TRISTATE)
+					dep = expr_alloc_comp(E_EQUAL, sym, &symbol_yes);
+			}
+			basedep = expr_alloc_and(expr_copy(dep), basedep);
 			basedep = expr_eliminate_dups(basedep);
 			menu->dep = basedep;
 			if (menu->sym)
@@ -326,7 +342,8 @@ void menu_finalize(struct menu *parent)
 					    "values not supported");
 			}
 			current_entry = menu;
-			menu_set_type(sym->type);
+			if (menu->sym->type == S_UNKNOWN)
+				menu_set_type(sym->type);
 			menu_add_symbol(P_CHOICE, sym, NULL);
 			prop = sym_get_choice_prop(sym);
 			for (ep = &prop->expr; *ep; ep = &(*ep)->left.expr)



