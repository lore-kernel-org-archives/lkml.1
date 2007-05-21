Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbXEVBH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbXEVBH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 21:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757136AbXEVBHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 21:07:21 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36600 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757108AbXEVBHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 21:07:20 -0400
Date: Mon, 21 May 2007 21:44:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: kconfig - scan all Kconfig files
Message-ID: <20070521194416.GA3596@uranus.ravnborg.org>
References: <20070520175203.GA24511@uranus.ravnborg.org> <Pine.LNX.4.64.0705210235030.1817@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705210235030.1817@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> A simple example would be 
> help texts, right now they are per symbol, but they should really be per 
> menu, so archs can provide different help texts for something.

This one turned out easy.
I assume what you had in mind was something like the attached.

With this the help entry present is no loger tha last one seen but the one belonging
to the menu (the symbol used within that menu).
So if I have:

menu "My first menu"
config FOO
	bool "Foobar"
	help
	  First menu help
endmenu

menu "My second menu"
config FOO
	bool "barfoo"
	help
	 Second menu help
endmenu

Then the help text will be the expected one in the two menus.

gconf + qconf will be fixed later if you are OK with this one.
This is IMO a general improvement and should be finished and applied.

	Sam

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 1199baf..c2ca5fc 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -187,9 +187,9 @@ int conf_string(struct menu *menu)
 			/* print help */
 			if (line[1] == '\n') {
 				help = nohelp_text;
-				if (menu->sym->help)
-					help = menu->sym->help;
-				printf("\n%s\n", menu->sym->help);
+				if (menu->help)
+					help = menu->help;
+				printf("\n%s\n", menu->help);
 				def = NULL;
 				break;
 			}
@@ -233,7 +233,7 @@ static int conf_sym(struct menu *menu)
 			printf("/m");
 		if (oldval != yes && sym_tristate_within_range(sym, yes))
 			printf("/y");
-		if (sym->help)
+		if (menu->help)
 			printf("/?");
 		printf("] ");
 		conf_askvalue(sym, sym_get_string_value(sym));
@@ -270,8 +270,8 @@ static int conf_sym(struct menu *menu)
 			return 0;
 help:
 		help = nohelp_text;
-		if (sym->help)
-			help = sym->help;
+		if (menu->help)
+			help = menu->help;
 		printf("\n%s\n", help);
 	}
 }
@@ -342,7 +342,7 @@ static int conf_choice(struct menu *menu)
 			goto conf_childs;
 		}
 		printf("[1-%d", cnt);
-		if (sym->help)
+		if (menu->help)
 			printf("?");
 		printf("]: ");
 		switch (input_mode) {
@@ -359,8 +359,8 @@ static int conf_choice(struct menu *menu)
 			fgets(line, 128, stdin);
 			strip(line);
 			if (line[0] == '?') {
-				printf("\n%s\n", menu->sym->help ?
-					menu->sym->help : nohelp_text);
+				printf("\n%s\n", menu->help ?
+					menu->help : nohelp_text);
 				continue;
 			}
 			if (!line[0])
@@ -391,8 +391,8 @@ static int conf_choice(struct menu *menu)
 		if (!child)
 			continue;
 		if (line[strlen(line) - 1] == '?') {
-			printf("\n%s\n", child->sym->help ?
-				child->sym->help : nohelp_text);
+			printf("\n%s\n", child->help ?
+				child->help : nohelp_text);
 			continue;
 		}
 		sym_set_choice_value(sym, child->sym);
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 6084525..0b22c73 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -71,7 +71,7 @@ enum {
 struct symbol {
 	struct symbol *next;
 	char *name;
-	char *help;
+	//char *help;
 	enum symbol_type type;
 	struct symbol_value curr;
 	struct symbol_value def[4];
@@ -139,7 +139,7 @@ struct menu {
 	struct property *prompt;
 	struct expr *dep;
 	unsigned int flags;
-	//char *help;
+	char *help;
 	struct file *file;
 	int lineno;
 	void *data;
diff --git a/scripts/kconfig/kxgettext.c b/scripts/kconfig/kxgettext.c
index abee55c..4b0aaa1 100644
--- a/scripts/kconfig/kxgettext.c
+++ b/scripts/kconfig/kxgettext.c
@@ -170,8 +170,8 @@ void menu_build_message_list(struct menu *menu)
 		     menu->file == NULL ? "Root Menu" : menu->file->name,
 		     menu->lineno);
 
-	if (menu->sym != NULL && menu->sym->help != NULL)
-		message__add(menu->sym->help, menu->sym->name,
+	if (menu->sym != NULL && menu->help != NULL)
+		message__add(menu->help, menu->sym->name,
 			     menu->file == NULL ? "Root Menu" : menu->file->name,
 			     menu->lineno);
 
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index d0e4fa5..25d67b2 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -718,11 +718,11 @@ static void show_help(struct menu *menu)
 	struct gstr help = str_new();
 	struct symbol *sym = menu->sym;
 
-	if (sym->help)
+	if (menu->help)
 	{
 		if (sym->name) {
 			str_printf(&help, "CONFIG_%s:\n\n", sym->name);
-			str_append(&help, _(sym->help));
+			str_append(&help, _(menu->help));
 			str_append(&help, "\n");
 		}
 	} else {
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
