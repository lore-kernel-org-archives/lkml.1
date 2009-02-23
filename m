Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbZBWPLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbZBWPLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbZBWPKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:10:23 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:24359 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbZBWPKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:10:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZAMZpyrvjnlsiZoZQKe6BvrBCmQkCSJLxeEDnHA82UW5i/UxAW+FQIV0oIijEw9qK8
         7mO5xR88AKV41OQiFeLed49p4F2wxpNsv7R/H/k9GIetoMvY1f6+VbwL+VOUynpCLwvz
         BaQ1QB1Vpc5jIzDmeX2UvdR1C9+uprn1pBqWY=
From: Cheng Renquan <crquan@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       cr_quan@163.com
Subject: [PATCH 2/6] [KBUILD] add menu_get_ext_help function to display more information
Date: Mon, 23 Feb 2009 23:10:00 +0800
Message-Id: <1235401804-8136-3-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235401804-8136-2-git-send-email-crquan@gmail.com>
References: <1235401804-8136-1-git-send-email-crquan@gmail.com>
 <1235401804-8136-2-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.6.0.6

