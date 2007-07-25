Return-Path: <linux-kernel-owner+w=401wt.eu-S1762720AbXGYVKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762720AbXGYVKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 17:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbXGYVKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 17:10:38 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46473 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbXGYVKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 17:10:36 -0400
Date: Wed, 25 Jul 2007 23:11:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [GIT PULL] kbuild fixes/updates for -rc1
Message-ID: <20070725211149.GA29705@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

kbuild fixes/updates for -rc1.
The changes are a bit more than I prefer for -rc1 but thats
mainly because the first four patches was sent but not applied during
the merge window.

A good part of the modpost changes as indicated by the diffstat is simple
code movement.

Please pull from:
	git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git

	Sam

Shortlog + diffstat + full diff below.

Jesper Juhl (1):
      kbuild: fix up printing of Linux C Library version in scripts/ver_linux

Roland McGrath (1):
      kbuild: use LDFLAGS_MODULE only for .ko links

Sam Ravnborg (6):
      kbuild: do not do section mismatch checks on vmlinux in 2nd pass
      kconfig: attach help text to menus
      kconfig: remove unused members from struct symbol
      kbuild: rearrange a few function in modpost
      kbuild: be more foregiving on init section naming
      kbuild: fix modpost warnings for xtensa

 Makefile                            |    2 +-
 scripts/Makefile.build              |    2 +-
 scripts/Makefile.modpost            |   21 +++--
 scripts/kconfig/conf.c              |   31 ++++----
 scripts/kconfig/expr.h              |    4 +-
 scripts/kconfig/gconf.c             |   10 +--
 scripts/kconfig/kxgettext.c         |    4 +-
 scripts/kconfig/lkc_proto.h         |    2 +
 scripts/kconfig/mconf.c             |    4 +-
 scripts/kconfig/menu.c              |   12 +++
 scripts/kconfig/qconf.cc            |    2 +-
 scripts/kconfig/zconf.tab.c_shipped |   12 ++--
 scripts/kconfig/zconf.y             |   12 ++--
 scripts/mod/modpost.c               |  159 ++++++++++++++++++++---------------
 scripts/ver_linux                   |    4 +-
 15 files changed, 156 insertions(+), 125 deletions(-)
diff --git a/Makefile b/Makefile
index 23f81c9..dfe3d16 100644
--- a/Makefile
+++ b/Makefile
@@ -299,7 +299,7 @@ CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise $(C
 MODFLAGS	= -DMODULE
 CFLAGS_MODULE   = $(MODFLAGS)
 AFLAGS_MODULE   = $(MODFLAGS)
-LDFLAGS_MODULE  = -r
+LDFLAGS_MODULE  =
 CFLAGS_KERNEL	=
 AFLAGS_KERNEL	=
 
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 3f7b451..7fd6055 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -315,7 +315,7 @@ quiet_cmd_link_multi-y = LD      $@
 cmd_link_multi-y = $(LD) $(ld_flags) -r -o $@ $(link_multi_deps)
 
 quiet_cmd_link_multi-m = LD [M]  $@
-cmd_link_multi-m = $(LD) $(ld_flags) $(LDFLAGS_MODULE) -o $@ $(link_multi_deps)
+cmd_link_multi-m = $(cmd_link_multi-y)
 
 # We would rather have a list of rules like
 # 	foo.o: $(foo-objs)
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index c6fcc59..d988f5d 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -56,23 +56,24 @@ _modpost: $(if $(KBUILD_MODPOST_NOFINAL), $(modules:.ko:.o),$(modules))
 
 # Step 2), invoke modpost
 #  Includes step 3,4
+modpost = scripts/mod/modpost                    \
+ $(if $(CONFIG_MODVERSIONS),-m)                  \
+ $(if $(CONFIG_MODULE_SRCVERSION_ALL),-a,)       \
+ $(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile)   \
+ $(if $(KBUILD_EXTMOD),-I $(modulesymfile))      \
+ $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
+ $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
+
 quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
-      cmd_modpost = scripts/mod/modpost            \
-        $(if $(CONFIG_MODVERSIONS),-m)             \
-	$(if $(CONFIG_MODULE_SRCVERSION_ALL),-a,)  \
-	$(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile) \
-	$(if $(KBUILD_EXTMOD),-I $(modulesymfile)) \
-	$(if $(KBUILD_EXTMOD),-o $(modulesymfile)) \
-	$(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
+      cmd_modpost = $(modpost) -s
 
 PHONY += __modpost
 __modpost: $(modules:.ko=.o) FORCE
 	$(call cmd,modpost) $(wildcard vmlinux) $(filter-out FORCE,$^)
 
 quiet_cmd_kernel-mod = MODPOST $@
-      cmd_kernel-mod = $(cmd_modpost) $@
+      cmd_kernel-mod = $(modpost) $@
 
-PHONY += vmlinux
 vmlinux.o: FORCE
 	$(call cmd,kernel-mod)
 
@@ -97,7 +98,7 @@ targets += $(modules:.ko=.mod.o)
 
 # Step 6), final link of the modules
 quiet_cmd_ld_ko_o = LD [M]  $@
-      cmd_ld_ko_o = $(LD) $(LDFLAGS) $(LDFLAGS_MODULE) -o $@		\
+      cmd_ld_ko_o = $(LD) -r $(LDFLAGS) $(LDFLAGS_MODULE) -o $@		\
 			  $(filter-out FORCE,$^)
 
 $(modules): %.ko :%.o %.mod.o FORCE
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
index 6084525..a195986 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -71,14 +71,12 @@ enum {
 struct symbol {
 	struct symbol *next;
 	char *name;
-	char *help;
 	enum symbol_type type;
 	struct symbol_value curr;
 	struct symbol_value def[4];
 	tristate visible;
 	int flags;
 	struct property *prop;
-	struct expr *dep, *dep2;
 	struct expr_value rev_dep;
 };
 
@@ -139,7 +137,7 @@ struct menu {
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
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 5ab7914..ee58ded 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -23,6 +23,8 @@ int have_vmlinux = 0;
 static int all_versions = 0;
 /* If we are modposting external module set to 1 */
 static int external_module = 0;
+/* Warn about section mismatch in vmlinux if set to 1 */
+static int vmlinux_section_warnings = 1;
 /* Only warn about unresolved symbols */
 static int warn_unresolved = 0;
 /* How a symbol is exported */
@@ -584,13 +586,61 @@ static int strrcmp(const char *s, const char *sub)
         return memcmp(s + slen - sublen, sub, sublen);
 }
 
+/*
+ * Functions used only during module init is marked __init and is stored in
+ * a .init.text section. Likewise data is marked __initdata and stored in
+ * a .init.data section.
+ * If this section is one of these sections return 1
+ * See include/linux/init.h for the details
+ */
+static int init_section(const char *name)
+{
+	if (strcmp(name, ".init") == 0)
+		return 1;
+	if (strncmp(name, ".init.", strlen(".init.")) == 0)
+		return 1;
+	return 0;
+}
+
+/*
+ * Functions used only during module exit is marked __exit and is stored in
+ * a .exit.text section. Likewise data is marked __exitdata and stored in
+ * a .exit.data section.
+ * If this section is one of these sections return 1
+ * See include/linux/init.h for the details
+ **/
+static int exit_section(const char *name)
+{
+	if (strcmp(name, ".exit.text") == 0)
+		return 1;
+	if (strcmp(name, ".exit.data") == 0)
+		return 1;
+	return 0;
+
+}
+
+/*
+ * Data sections are named like this:
+ * .data | .data.rel | .data.rel.*
+ * Return 1 if the specified section is a data section
+ */
+static int data_section(const char *name)
+{
+	if ((strcmp(name, ".data") == 0) ||
+	    (strcmp(name, ".data.rel") == 0) ||
+	    (strncmp(name, ".data.rel.", strlen(".data.rel.")) == 0))
+		return 1;
+	else
+		return 0;
+}
+
 /**
  * Whitelist to allow certain references to pass with no warning.
  *
  * Pattern 0:
  *   Do not warn if funtion/data are marked with __init_refok/__initdata_refok.
  *   The pattern is identified by:
- *   fromsec = .text.init.refok | .data.init.refok
+ *   fromsec = .text.init.refok* | .data.init.refok*
  *
  * Pattern 1:
  *   If a module parameter is declared __initdata and permissions=0
@@ -608,8 +658,8 @@ static int strrcmp(const char *s, const char *sub)
  *   These functions may often be marked __init and we do not want to
  *   warn here.
  *   the pattern is identified by:
- *   tosec   = .init.text | .exit.text | .init.data
- *   fromsec = .data | .data.rel | .data.rel.*
+ *   tosec   = init or exit section
+ *   fromsec = data section
  *   atsym = *driver, *_template, *_sht, *_ops, *_probe, *probe_one, *_console, *_timer
  *
  * Pattern 3:
@@ -625,12 +675,18 @@ static int strrcmp(const char *s, const char *sub)
  *   This pattern is identified by
  *   refsymname = __init_begin, _sinittext, _einittext
  *
+ * Pattern 5:
+ *   Xtensa uses literal sections for constants that are accessed PC-relative.
+ *   Literal sections may safely reference their text sections.
+ *   (Note that the name for the literal section omits any trailing '.text')
+ *   tosec = <section>[.text]
+ *   fromsec = <section>.literal
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
 			    const char *refsymname)
 {
-	int f1 = 1, f2 = 1;
+	int len;
 	const char **s;
 	const char *pat2sym[] = {
 		"driver",
@@ -652,36 +708,21 @@ static int secref_whitelist(const char *modname, const char *tosec,
 	};
 
 	/* Check for pattern 0 */
-	if ((strcmp(fromsec, ".text.init.refok") == 0) ||
-	    (strcmp(fromsec, ".data.init.refok") == 0))
+	if ((strncmp(fromsec, ".text.init.refok", strlen(".text.init.refok")) == 0) ||
+	    (strncmp(fromsec, ".data.init.refok", strlen(".data.init.refok")) == 0))
 		return 1;
 
 	/* Check for pattern 1 */
-	if (strcmp(tosec, ".init.data") != 0)
-		f1 = 0;
-	if (strncmp(fromsec, ".data", strlen(".data")) != 0)
-		f1 = 0;
-	if (strncmp(atsym, "__param", strlen("__param")) != 0)
-		f1 = 0;
-
-	if (f1)
-		return f1;
+	if ((strcmp(tosec, ".init.data") == 0) &&
+	    (strncmp(fromsec, ".data", strlen(".data")) == 0) &&
+	    (strncmp(atsym, "__param", strlen("__param")) == 0))
+		return 1;
 
 	/* Check for pattern 2 */
-	if ((strcmp(tosec, ".init.text") != 0) &&
-	    (strcmp(tosec, ".exit.text") != 0) &&
-	    (strcmp(tosec, ".init.data") != 0))
-		f2 = 0;
-	if ((strcmp(fromsec, ".data") != 0) &&
-	    (strcmp(fromsec, ".data.rel") != 0) &&
-	    (strncmp(fromsec, ".data.rel.", strlen(".data.rel.")) != 0))
-		f2 = 0;
-
-	for (s = pat2sym; *s; s++)
-		if (strrcmp(atsym, *s) == 0)
-			f1 = 1;
-	if (f1 && f2)
-		return 1;
+	if ((init_section(tosec) || exit_section(tosec)) && data_section(fromsec))
+		for (s = pat2sym; *s; s++)
+			if (strrcmp(atsym, *s) == 0)
+				return 1;
 
 	/* Check for pattern 3 */
 	if ((strcmp(fromsec, ".text.head") == 0) &&
@@ -694,6 +735,15 @@ static int secref_whitelist(const char *modname, const char *tosec,
 		if (strcmp(refsymname, *s) == 0)
 			return 1;
 
+	/* Check for pattern 5 */
+	if (strrcmp(tosec, ".text") == 0)
+		len = strlen(tosec) - strlen(".text");
+	else
+		len = strlen(tosec);
+	if ((strncmp(tosec, fromsec, len) == 0) && (strlen(fromsec) > len) &&
+	    (strcmp(fromsec + len, ".literal") == 0))
+		return 1;
+
 	return 0;
 }
 
@@ -822,9 +872,9 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
 		refsymname = elf->strtab + refsym->st_name;
 
 	/* check whitelist - we may ignore it */
-	if (before &&
-	    secref_whitelist(modname, secname, fromsec,
-			     elf->strtab + before->st_name, refsymname))
+	if (secref_whitelist(modname, secname, fromsec,
+			     before ? elf->strtab + before->st_name : "",
+	                     refsymname))
 		return;
 
 	if (before && after) {
@@ -1077,6 +1127,8 @@ static int initexit_section_ref_ok(const char *name)
 		".smp_locks",
 		".stab",
 		".m68k_fixup",
+		".xt.prop",		/* xtensa informational section */
+		".xt.lit",		/* xtensa informational section */
 		NULL
 	};
 	/* Start of section names */
@@ -1106,21 +1158,6 @@ static int initexit_section_ref_ok(const char *name)
 	return 0;
 }
 
-/**
- * Functions used only during module init is marked __init and is stored in
- * a .init.text section. Likewise data is marked __initdata and stored in
- * a .init.data section.
- * If this section is one of these sections return 1
- * See include/linux/init.h for the details
- **/
-static int init_section(const char *name)
-{
-	if (strcmp(name, ".init") == 0)
-		return 1;
-	if (strncmp(name, ".init.", strlen(".init.")) == 0)
-		return 1;
-	return 0;
-}
 
 /*
  * Identify sections from which references to a .init section is OK.
@@ -1178,23 +1215,6 @@ static int init_section_ref_ok(const char *name)
 }
 
 /*
- * Functions used only during module exit is marked __exit and is stored in
- * a .exit.text section. Likewise data is marked __exitdata and stored in
- * a .exit.data section.
- * If this section is one of these sections return 1
- * See include/linux/init.h for the details
- **/
-static int exit_section(const char *name)
-{
-	if (strcmp(name, ".exit.text") == 0)
-		return 1;
-	if (strcmp(name, ".exit.data") == 0)
-		return 1;
-	return 0;
-
-}
-
-/*
  * Identify sections from which references to a .exit section is OK.
  */
 static int exit_section_ref_ok(const char *name)
@@ -1257,8 +1277,10 @@ static void read_symbols(char *modname)
 		handle_modversions(mod, &info, sym, symname);
 		handle_moddevtable(mod, &info, sym, symname);
 	}
-	check_sec_ref(mod, modname, &info, init_section, init_section_ref_ok);
-	check_sec_ref(mod, modname, &info, exit_section, exit_section_ref_ok);
+	if (is_vmlinux(modname) && vmlinux_section_warnings) {
+		check_sec_ref(mod, modname, &info, init_section, init_section_ref_ok);
+		check_sec_ref(mod, modname, &info, exit_section, exit_section_ref_ok);
+	}
 
 	version = get_modinfo(info.modinfo, info.modinfo_len, "version");
 	if (version)
@@ -1626,7 +1648,7 @@ int main(int argc, char **argv)
 	int opt;
 	int err;
 
-	while ((opt = getopt(argc, argv, "i:I:mo:aw")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:mso:aw")) != -1) {
 		switch(opt) {
 			case 'i':
 				kernel_read = optarg;
@@ -1644,6 +1666,9 @@ int main(int argc, char **argv)
 			case 'a':
 				all_versions = 1;
 				break;
+			case 's':
+				vmlinux_section_warnings = 0;
+				break;
 			case 'w':
 				warn_unresolved = 1;
 				break;
diff --git a/scripts/ver_linux b/scripts/ver_linux
index 72876df..8f8df93 100755
--- a/scripts/ver_linux
+++ b/scripts/ver_linux
@@ -66,8 +66,8 @@ showmount --version 2>&1 | grep nfs-utils | awk \
 'NR==1{print "nfs-utils             ", $NF}'
 
 ls -l `ldd /bin/sh | awk '/libc/{print $3}'` | sed \
--e 's/\.so$//' | awk -F'[.-]'   '{print "Linux C Library        " \
-$(NF-2)"."$(NF-1)"."$NF}'
+-e 's/\.so$//' | sed -e 's/>//' | \
+awk -F'[.-]' '{print "Linux C Library        "$(NF-1)"."$NF}'
 
 ldd -v > /dev/null 2>&1 && ldd -v || ldd --version |head -n 1 | awk \
 'NR==1{print "Dynamic linker (ldd)  ", $NF}'
