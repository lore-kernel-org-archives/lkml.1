Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbZGLIOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbZGLIOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 04:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZGLIMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 04:12:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:53913 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbZGLIM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 04:12:29 -0400
From: Cheng Renquan <crq@kernel.org>
To: linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       crquan@gmail.com
Subject: [PATCH 2/6] add menu_get_ext_help function to display more information
Date: Sun, 12 Jul 2009 16:11:44 +0800
Message-Id: <1247386308-19628-3-git-send-email-crq@kernel.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247386308-19628-2-git-send-email-crq@kernel.org>
References: <1247386308-19628-1-git-send-email-crq@kernel.org>
 <1247386308-19628-2-git-send-email-crq@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Jul 2009 08:11:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

The three functions are moved from mconf.c, then they can be shared in
all menuconfig & gconfig & xconfig & config.

  +void menu_get_ext_help(struct menu *menu, struct gstr *help)
  +static void get_prompt_str(struct gstr *r, struct property *prop)
  +void get_symbol_str(struct gstr *r, struct symbol *sym)

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 scripts/kconfig/lkc_proto.h |    2 +
 scripts/kconfig/menu.c      |   79 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/lkc_proto.h b/scripts/kconfig/lkc_proto.h
index 8e69461..ffeb532 100644
--- a/scripts/kconfig/lkc_proto.h
+++ b/scripts/kconfig/lkc_proto.h
@@ -17,6 +17,8 @@ P(menu_get_root_menu,struct menu *,(struct menu *menu));
 P(menu_get_parent_menu,struct menu *,(struct menu *menu));
 P(menu_has_help,bool,(struct menu *menu));
 P(menu_get_help,const char *,(struct menu *menu));
+P(get_symbol_str,void,(struct gstr *r, struct symbol *sym));
+P(menu_get_ext_help,void,(struct menu *menu, struct gstr *help));
 
 /* symbol.c */
 P(symbol_hash,struct symbol *,[SYMBOL_HASHSIZE]);
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 07ff8d1..931d782 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -9,6 +9,9 @@
 #define LKC_DIRECT_LINK
 #include "lkc.h"
 
+static const char nohelp_text[] = N_(
+	"There is no help available for this kernel option.\n");
+
 struct menu rootmenu;
 static struct menu **last_entry_ptr;
 
@@ -451,3 +454,79 @@ const char *menu_get_help(struct menu *menu)
 	else
 		return "";
 }
+
+static void get_prompt_str(struct gstr *r, struct property *prop)
+{
+	int i, j;
+	struct menu *submenu[8], *menu;
+
+	str_printf(r, _("Prompt: %s\n"), _(prop->text));
+	str_printf(r, _("  Defined at %s:%d\n"), prop->menu->file->name,
+		prop->menu->lineno);
+	if (!expr_is_yes(prop->visible.expr)) {
+		str_append(r, _("  Depends on: "));
+		expr_gstr_print(prop->visible.expr, r);
+		str_append(r, "\n");
+	}
+	menu = prop->menu->parent;
+	for (i = 0; menu != &rootmenu && i < 8; menu = menu->parent)
+		submenu[i++] = menu;
+	if (i > 0) {
+		str_printf(r, _("  Location:\n"));
+		for (j = 4; --i >= 0; j += 2) {
+			menu = submenu[i];
+			str_printf(r, "%*c-> %s", j, ' ', _(menu_get_prompt(menu)));
+			if (menu->sym) {
+				str_printf(r, " (%s [=%s])", menu->sym->name ?
+					menu->sym->name : _("<choice>"),
+					sym_get_string_value(menu->sym));
+			}
+			str_append(r, "\n");
+		}
+	}
+}
+
+void get_symbol_str(struct gstr *r, struct symbol *sym)
+{
+	bool hit;
+	struct property *prop;
+
+	if (sym && sym->name)
+		str_printf(r, "Symbol: %s [=%s]\n", sym->name,
+			   sym_get_string_value(sym));
+	for_all_prompts(sym, prop)
+		get_prompt_str(r, prop);
+	hit = false;
+	for_all_properties(sym, prop, P_SELECT) {
+		if (!hit) {
+			str_append(r, "  Selects: ");
+			hit = true;
+		} else
+			str_printf(r, " && ");
+		expr_gstr_print(prop->expr, r);
+	}
+	if (hit)
+		str_append(r, "\n");
+	if (sym->rev_dep.expr) {
+		str_append(r, _("  Selected by: "));
+		expr_gstr_print(sym->rev_dep.expr, r);
+		str_append(r, "\n");
+	}
+	str_append(r, "\n\n");
+}
+
+void menu_get_ext_help(struct menu *menu, struct gstr *help)
+{
+	struct symbol *sym = menu->sym;
+
+	if (menu_has_help(menu)) {
+		if (sym->name) {
+			str_printf(help, "CONFIG_%s:\n\n", sym->name);
+			str_append(help, _(menu_get_help(menu)));
+			str_append(help, "\n");
+		}
+	} else {
+		str_append(help, nohelp_text);
+	}
+	get_symbol_str(help, sym);
+}
-- 
1.6.3.3

