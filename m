Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbZGLINV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbZGLINV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 04:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbZGLIMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 04:12:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:53914 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048AbZGLIM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 04:12:29 -0400
From: Cheng Renquan <crq@kernel.org>
To: linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       crquan@gmail.com
Subject: [PATCH 3/6] menuconfig improvements
Date: Sun, 12 Jul 2009 16:11:45 +0800
Message-Id: <1247386308-19628-4-git-send-email-crq@kernel.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247386308-19628-3-git-send-email-crq@kernel.org>
References: <1247386308-19628-1-git-send-email-crq@kernel.org>
 <1247386308-19628-2-git-send-email-crq@kernel.org>
 <1247386308-19628-3-git-send-email-crq@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Jul 2009 08:11:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

The removed functions are moved into menu.c for sharing with
gconfig & xconfig & config.

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 scripts/kconfig/mconf.c |   78 ++---------------------------------------------
 1 files changed, 3 insertions(+), 75 deletions(-)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 3bcacb4..4567b5e 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -199,8 +199,6 @@ inputbox_instructions_string[] = N_(
 setmod_text[] = N_(
 	"This feature depends on another which has been configured as a module.\n"
 	"As a result, this feature will be built as a module."),
-nohelp_text[] = N_(
-	"There is no help available for this kernel option.\n"),
 load_config_text[] = N_(
 	"Enter the name of the configuration file you wish to load.  "
 	"Accept the name shown to restore the configuration you "
@@ -284,66 +282,6 @@ static void show_textbox(const char *title, const char *text, int r, int c);
 static void show_helptext(const char *title, const char *text);
 static void show_help(struct menu *menu);
 
-static void get_prompt_str(struct gstr *r, struct property *prop)
-{
-	int i, j;
-	struct menu *submenu[8], *menu;
-
-	str_printf(r, _("Prompt: %s\n"), _(prop->text));
-	str_printf(r, _("  Defined at %s:%d\n"), prop->menu->file->name,
-		prop->menu->lineno);
-	if (!expr_is_yes(prop->visible.expr)) {
-		str_append(r, _("  Depends on: "));
-		expr_gstr_print(prop->visible.expr, r);
-		str_append(r, "\n");
-	}
-	menu = prop->menu->parent;
-	for (i = 0; menu != &rootmenu && i < 8; menu = menu->parent)
-		submenu[i++] = menu;
-	if (i > 0) {
-		str_printf(r, _("  Location:\n"));
-		for (j = 4; --i >= 0; j += 2) {
-			menu = submenu[i];
-			str_printf(r, "%*c-> %s", j, ' ', _(menu_get_prompt(menu)));
-			if (menu->sym) {
-				str_printf(r, " (%s [=%s])", menu->sym->name ?
-					menu->sym->name : _("<choice>"),
-					sym_get_string_value(menu->sym));
-			}
-			str_append(r, "\n");
-		}
-	}
-}
-
-static void get_symbol_str(struct gstr *r, struct symbol *sym)
-{
-	bool hit;
-	struct property *prop;
-
-	if (sym && sym->name)
-		str_printf(r, "Symbol: %s [=%s]\n", sym->name,
-		                                    sym_get_string_value(sym));
-	for_all_prompts(sym, prop)
-		get_prompt_str(r, prop);
-	hit = false;
-	for_all_properties(sym, prop, P_SELECT) {
-		if (!hit) {
-			str_append(r, "  Selects: ");
-			hit = true;
-		} else
-			str_printf(r, " && ");
-		expr_gstr_print(prop->expr, r);
-	}
-	if (hit)
-		str_append(r, "\n");
-	if (sym->rev_dep.expr) {
-		str_append(r, _("  Selected by: "));
-		expr_gstr_print(sym->rev_dep.expr, r);
-		str_append(r, "\n");
-	}
-	str_append(r, "\n\n");
-}
-
 static struct gstr get_relations_str(struct symbol **sym_arr)
 {
 	struct symbol *sym;
@@ -699,19 +637,9 @@ static void show_helptext(const char *title, const char *text)
 static void show_help(struct menu *menu)
 {
 	struct gstr help = str_new();
-	struct symbol *sym = menu->sym;
-
-	if (menu_has_help(menu))
-	{
-		if (sym->name) {
-			str_printf(&help, "CONFIG_%s:\n\n", sym->name);
-			str_append(&help, _(menu_get_help(menu)));
-			str_append(&help, "\n");
-		}
-	} else {
-		str_append(&help, nohelp_text);
-	}
-	get_symbol_str(&help, sym);
+
+	menu_get_ext_help(menu, &help);
+
 	show_helptext(_(menu_get_prompt(menu)), str_get(&help));
 	str_free(&help);
 }
-- 
1.6.3.3

