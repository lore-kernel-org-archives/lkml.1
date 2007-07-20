Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbXGTWcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbXGTWcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbXGTWbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:31:13 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43826 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbXGTWbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:31:09 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 3/4] kconfig: attach help text to menus
Date: Sat, 21 Jul 2007 00:30:43 +0200
Message-Id: <11849706441498-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11849706441152-git-send-email-sam@ravnborg.org>
References: <20070720222039.GA25443@uranus.ravnborg.org> <11849706443410-git-send-email-sam@ravnborg.org> <11849706441152-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel wrote:
> A simple example would be
> help texts, right now they are per symbol, but they should really be per
> menu, so archs can provide different help texts for something.

This patch does this and at the same time introduce a few API
funtions used to access the help text.

The relevant api functions are introduced in the various frontends.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 scripts/kconfig/conf.c              |   31 +++++++++++++++----------------
 scripts/kconfig/expr.h              |    3 +--
 scripts/kconfig/gconf.c             |   10 ++--------
 scripts/kconfig/kxgettext.c         |    4 ++--
 scripts/kconfig/lkc_proto.h         |    2 ++
 scripts/kconfig/mconf.c             |    4 ++--
 scripts/kconfig/menu.c              |   12 ++++++++++++
 scripts/kconfig/qconf.cc            |    2 +-
 scripts/kconfig/zconf.tab.c_shipped |   12 ++++++------
 scripts/kconfig/zconf.y             |   12 ++++++------
 10 files changed, 49 insertions(+), 43 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 1199baf..8be6a42 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -37,6 +37,14 @@ static struct menu *rootEntry;
 
 static char nohelp_text[] = N_("Sorry, no help available for this option yet.\n");
 
+static const char *get_help(struct menu *menu)
+{
+	if (menu_has_help(menu))
+		return menu_get_help(menu);
+	else
+		return nohelp_text;
+}
+
 static void strip(char *str)
 {
 	char *p = str;
@@ -171,7 +179,7 @@ static void conf_askvalue(struct symbol *sym, const char *def)
 int conf_string(struct menu *menu)
 {
 	struct symbol *sym = menu->sym;
-	const char *def, *help;
+	const char *def;
 
 	while (1) {
 		printf("%*s%s ", indent - 1, "", menu->prompt->text);
@@ -186,10 +194,7 @@ int conf_string(struct menu *menu)
 		case '?':
 			/* print help */
 			if (line[1] == '\n') {
-				help = nohelp_text;
-				if (menu->sym->help)
-					help = menu->sym->help;
-				printf("\n%s\n", menu->sym->help);
+				printf("\n%s\n", get_help(menu));
 				def = NULL;
 				break;
 			}
@@ -207,7 +212,6 @@ static int conf_sym(struct menu *menu)
 	struct symbol *sym = menu->sym;
 	int type;
 	tristate oldval, newval;
-	const char *help;
 
 	while (1) {
 		printf("%*s%s ", indent - 1, "", menu->prompt->text);
@@ -233,7 +237,7 @@ static int conf_sym(struct menu *menu)
 			printf("/m");
 		if (oldval != yes && sym_tristate_within_range(sym, yes))
 			printf("/y");
-		if (sym->help)
+		if (menu_has_help(menu))
 			printf("/?");
 		printf("] ");
 		conf_askvalue(sym, sym_get_string_value(sym));
@@ -269,10 +273,7 @@ static int conf_sym(struct menu *menu)
 		if (sym_set_tristate_value(sym, newval))
 			return 0;
 help:
-		help = nohelp_text;
-		if (sym->help)
-			help = sym->help;
-		printf("\n%s\n", help);
+		printf("\n%s\n", get_help(menu));
 	}
 }
 
@@ -342,7 +343,7 @@ static int conf_choice(struct menu *menu)
 			goto conf_childs;
 		}
 		printf("[1-%d", cnt);
-		if (sym->help)
+		if (menu_has_help(menu))
 			printf("?");
 		printf("]: ");
 		switch (input_mode) {
@@ -359,8 +360,7 @@ static int conf_choice(struct menu *menu)
 			fgets(line, 128, stdin);
 			strip(line);
 			if (line[0] == '?') {
-				printf("\n%s\n", menu->sym->help ?
-					menu->sym->help : nohelp_text);
+				printf("\n%s\n", get_help(menu));
 				continue;
 			}
 			if (!line[0])
@@ -391,8 +391,7 @@ static int conf_choice(struct menu *menu)
 		if (!child)
 			continue;
 		if (line[strlen(line) - 1] == '?') {
-			printf("\n%s\n", child->sym->help ?
-				child->sym->help : nohelp_text);
+			printf("\n%s\n", get_help(child));
 			continue;
 		}
 		sym_set_choice_value(sym, child->sym);
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 6084525..d6c33ce 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -71,7 +71,6 @@ enum {
 struct symbol {
 	struct symbol *next;
 	char *name;
-	char *help;
 	enum symbol_type type;
 	struct symbol_value curr;
 	struct symbol_value def[4];
@@ -139,7 +138,7 @@ struct menu {
 	struct property *prompt;
 	struct expr *dep;
 	unsigned int flags;
-	//char *help;
+	char *help;
 	struct file *file;
 	int lineno;
 	void *data;
diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 61d8166..262908c 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -38,9 +38,6 @@ static gboolean show_all = FALSE;
 static gboolean show_debug = FALSE;
 static gboolean resizeable = FALSE;
 
-static char nohelp_text[] =
-    N_("Sorry, no help available for this option yet.\n");
-
 GtkWidget *main_wnd = NULL;
 GtkWidget *tree1_w = NULL;	// left  frame
 GtkWidget *tree2_w = NULL;	// right frame
@@ -462,12 +459,9 @@ static void text_insert_help(struct menu *menu)
 	GtkTextIter start, end;
 	const char *prompt = menu_get_prompt(menu);
 	gchar *name;
-	const char *help = _(nohelp_text);
+	const char *help;
 
-	if (!menu->sym)
-		help = "";
-	else if (menu->sym->help)
-		help = _(menu->sym->help);
+	help = _(menu_get_help(menu));
 
 	if (menu->sym && menu->sym->name)
 		name = g_strdup_printf(_(menu->sym->name));
diff --git a/scripts/kconfig/kxgettext.c b/scripts/kconfig/kxgettext.c
index 11f7dab..6eb72a7 100644
--- a/scripts/kconfig/kxgettext.c
+++ b/scripts/kconfig/kxgettext.c
@@ -170,8 +170,8 @@ void menu_build_message_list(struct menu *menu)
 		     menu->file == NULL ? "Root Menu" : menu->file->name,
 		     menu->lineno);
 
-	if (menu->sym != NULL && menu->sym->help != NULL)
-		message__add(menu->sym->help, menu->sym->name,
+	if (menu->sym != NULL && menu_has_help(menu))
+		message__add(menu_get_help(menu), menu->sym->name,
 			     menu->file == NULL ? "Root Menu" : menu->file->name,
 			     menu->lineno);
 
diff --git a/scripts/kconfig/lkc_proto.h b/scripts/kconfig/lkc_proto.h
index 1503077..4d09f6d 100644
--- a/scripts/kconfig/lkc_proto.h
+++ b/scripts/kconfig/lkc_proto.h
@@ -15,6 +15,8 @@ P(menu_is_visible,bool,(struct menu *menu));
 P(menu_get_prompt,const char *,(struct menu *menu));
 P(menu_get_root_menu,struct menu *,(struct menu *menu));
 P(menu_get_parent_menu,struct menu *,(struct menu *menu));
+P(menu_has_help,bool,(struct menu *menu));
+P(menu_get_help,const char *,(struct menu *menu));
 
 /* symbol.c */
 P(symbol_hash,struct symbol *,[SYMBOL_HASHSIZE]);
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index d2c2a42..bc5854e 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -725,11 +725,11 @@ static void show_help(struct menu *menu)
 	struct gstr help = str_new();
 	struct symbol *sym = menu->sym;
 
-	if (sym->help)
+	if (menu_has_help(menu))
 	{
 		if (sym->name) {
 			str_printf(&help, "CONFIG_%s:\n\n", sym->name);
-			str_append(&help, _(sym->help));
+			str_append(&help, _(menu_get_help(menu)));
 			str_append(&help, "\n");
 		}
 	} else {
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index f14aeac..f9d0d91 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -417,3 +417,15 @@ struct menu *menu_get_parent_menu(struct menu *menu)
 	return menu;
 }
 
+bool menu_has_help(struct menu *menu)
+{
+	return menu->help != NULL;
+}
+
+const char *menu_get_help(struct menu *menu)
+{
+	if (menu->help)
+		return menu->help;
+	else
+		return "";
+}
diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index f2a23a9..e4eeb59 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1041,7 +1041,7 @@ void ConfigInfoView::menuInfo(void)
 		if (showDebug())
 			debug = debug_info(sym);
 
-		help = print_filter(_(sym->help));
+		help = print_filter(_(menu_get_help(menu)));
 	} else if (menu->prompt) {
 		head += "<big><b>";
 		head += print_filter(_(menu->prompt->text));
diff --git a/scripts/kconfig/zconf.tab.c_shipped b/scripts/kconfig/zconf.tab.c_shipped
index 9a06b67..ec21db7 100644
--- a/scripts/kconfig/zconf.tab.c_shipped
+++ b/scripts/kconfig/zconf.tab.c_shipped
@@ -1722,7 +1722,7 @@ yyreduce:
   case 83:
 
     {
-	current_entry->sym->help = (yyvsp[0].string);
+	current_entry->help = (yyvsp[0].string);
 ;}
     break;
 
@@ -2280,11 +2280,11 @@ void print_symbol(FILE *out, struct menu *menu)
 			break;
 		}
 	}
-	if (sym->help) {
-		int len = strlen(sym->help);
-		while (sym->help[--len] == '\n')
-			sym->help[len] = 0;
-		fprintf(out, "  help\n%s\n", sym->help);
+	if (menu->help) {
+		int len = strlen(menu->help);
+		while (menu->help[--len] == '\n')
+			menu->help[len] = 0;
+		fprintf(out, "  help\n%s\n", menu->help);
 	}
 	fputc('\n', out);
 }
diff --git a/scripts/kconfig/zconf.y b/scripts/kconfig/zconf.y
index 92eb02b..79db4cf 100644
--- a/scripts/kconfig/zconf.y
+++ b/scripts/kconfig/zconf.y
@@ -402,7 +402,7 @@ help_start: T_HELP T_EOL
 
 help: help_start T_HELPTEXT
 {
-	current_entry->sym->help = $2;
+	current_entry->help = $2;
 };
 
 /* depends option */
@@ -649,11 +649,11 @@ void print_symbol(FILE *out, struct menu *menu)
 			break;
 		}
 	}
-	if (sym->help) {
-		int len = strlen(sym->help);
-		while (sym->help[--len] == '\n')
-			sym->help[len] = 0;
-		fprintf(out, "  help\n%s\n", sym->help);
+	if (menu->help) {
+		int len = strlen(menu->help);
+		while (menu->help[--len] == '\n')
+			menu->help[len] = 0;
+		fprintf(out, "  help\n%s\n", menu->help);
 	}
 	fputc('\n', out);
 }
-- 
1.5.0.6

