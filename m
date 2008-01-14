Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbYANDv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbYANDv2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 22:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbYANDvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 22:51:00 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:3529 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402AbYANDu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 22:50:57 -0500
Date: Mon, 14 Jan 2008 04:50:54 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [PATCH 2/3] environment symbol support
In-Reply-To: <20080106132601.GA3139@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0801140450310.17507@scrub.home>
References: <20071110204038.GA13140@uranus.ravnborg.org>
 <11947274093185-git-send-email-sam@ravnborg.org> <11947274091127-git-send-email-sam@ravnborg.org>
 <Pine.LNX.4.64.0711142116500.1818@scrub.home> <20071114220840.GB10920@uranus.ravnborg.org>
 <Pine.LNX.4.64.0711151616330.1817@scrub.home> <20080106132601.GA3139@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add the possibility to import a value from the environment into kconfig
via the option syntax. Beside flexibility this has the advantage
providing proper dependencies.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 Documentation/kbuild/kconfig-language.txt |   21 ++++++++++++++
 scripts/kconfig/expr.h                    |    3 +-
 scripts/kconfig/lkc.h                     |    5 +++
 scripts/kconfig/menu.c                    |    5 ++-
 scripts/kconfig/qconf.cc                  |   16 +++-------
 scripts/kconfig/symbol.c                  |   45 ++++++++++++++++++++++++++++++
 scripts/kconfig/util.c                    |   23 ++++++++++++++-
 scripts/kconfig/zconf.gperf               |    1 
 scripts/kconfig/zconf.hash.c_shipped      |   45 ++++++++++++++++--------------
 9 files changed, 129 insertions(+), 35 deletions(-)

Index: linux-2.6/Documentation/kbuild/kconfig-language.txt
===================================================================
--- linux-2.6.orig/Documentation/kbuild/kconfig-language.txt
+++ linux-2.6/Documentation/kbuild/kconfig-language.txt
@@ -127,6 +127,27 @@ applicable everywhere (see syntax).
   used to help visually separate configuration logic from help within
   the file as an aid to developers.
 
+- misc options: "option" <symbol>[=<value>]
+  Various less common options can be defined via this option syntax,
+  which can modify the behaviour of the menu entry and its config
+  symbol. These options are currently possible:
+
+  - "defconfig_list"
+    This declares a list of default entries which can be used when
+    looking for the default configuration (which is used when the main
+    .config doesn't exists yet.)
+
+  - "modules"
+    This declares the symbol to be used as the MODULES symbol, which
+    enables the third modular state for all config symbols.
+
+  - "env"=<value>
+    This imports the environment variable into Kconfig. It behaves like
+    a default, except that the value comes from the environment, this
+    also means that the behaviour when mixing it with normal defaults is
+    undefined at this point. The symbol is currently not exported back
+    to the build environment (if this is desired, it can be done via
+    another symbol).
 
 Menu dependencies
 -----------------
Index: linux-2.6/scripts/kconfig/expr.h
===================================================================
--- linux-2.6.orig/scripts/kconfig/expr.h
+++ linux-2.6/scripts/kconfig/expr.h
@@ -108,7 +108,8 @@ struct symbol {
 #define SYMBOL_HASHMASK		0xff
 
 enum prop_type {
-	P_UNKNOWN, P_PROMPT, P_COMMENT, P_MENU, P_DEFAULT, P_CHOICE, P_SELECT, P_RANGE
+	P_UNKNOWN, P_PROMPT, P_COMMENT, P_MENU, P_DEFAULT, P_CHOICE,
+	P_SELECT, P_RANGE, P_ENV
 };
 
 struct property {
Index: linux-2.6/scripts/kconfig/lkc.h
===================================================================
--- linux-2.6.orig/scripts/kconfig/lkc.h
+++ linux-2.6/scripts/kconfig/lkc.h
@@ -44,6 +44,7 @@ extern "C" {
 
 #define T_OPT_MODULES		1
 #define T_OPT_DEFCONFIG_LIST	2
+#define T_OPT_ENV		3
 
 struct kconf_id {
 	int name;
@@ -74,6 +75,7 @@ void kconfig_load(void);
 
 /* menu.c */
 void menu_init(void);
+void menu_warn(struct menu *menu, const char *fmt, ...);
 struct menu *menu_add_menu(void);
 void menu_end_menu(void);
 void menu_add_entry(struct symbol *sym);
@@ -103,6 +105,8 @@ void str_printf(struct gstr *gs, const c
 const char *str_get(struct gstr *gs);
 
 /* symbol.c */
+extern struct expr *sym_env_list;
+
 void sym_init(void);
 void sym_clear_all_valid(void);
 void sym_set_all_changed(void);
@@ -110,6 +114,7 @@ void sym_set_changed(struct symbol *sym)
 struct symbol *sym_check_deps(struct symbol *sym);
 struct property *prop_alloc(enum prop_type type, struct symbol *sym);
 struct symbol *prop_get_symbol(struct property *prop);
+struct property *sym_get_env_prop(struct symbol *sym);
 
 static inline tristate sym_get_tristate_value(struct symbol *sym)
 {
Index: linux-2.6/scripts/kconfig/menu.c
===================================================================
--- linux-2.6.orig/scripts/kconfig/menu.c
+++ linux-2.6/scripts/kconfig/menu.c
@@ -15,7 +15,7 @@ static struct menu **last_entry_ptr;
 struct file *file_list;
 struct file *current_file;
 
-static void menu_warn(struct menu *menu, const char *fmt, ...)
+void menu_warn(struct menu *menu, const char *fmt, ...)
 {
 	va_list ap;
 	va_start(ap, fmt);
@@ -172,6 +172,9 @@ void menu_add_option(int token, char *ar
 		else if (sym_defconfig_list != current_entry->sym)
 			zconf_error("trying to redefine defconfig symbol");
 		break;
+	case T_OPT_ENV:
+		prop_add_env(arg);
+		break;
 	}
 }
 
Index: linux-2.6/scripts/kconfig/qconf.cc
===================================================================
--- linux-2.6.orig/scripts/kconfig/qconf.cc
+++ linux-2.6/scripts/kconfig/qconf.cc
@@ -1083,7 +1083,11 @@ QString ConfigInfoView::debug_info(struc
 			debug += "</a><br>";
 			break;
 		case P_DEFAULT:
-			debug += "default: ";
+		case P_SELECT:
+		case P_RANGE:
+		case P_ENV:
+			debug += prop_get_type_name(prop->type);
+			debug += ": ";
 			expr_print(prop->expr, expr_print_help, &debug, E_NONE);
 			debug += "<br>";
 			break;
@@ -1094,16 +1098,6 @@ QString ConfigInfoView::debug_info(struc
 				debug += "<br>";
 			}
 			break;
-		case P_SELECT:
-			debug += "select: ";
-			expr_print(prop->expr, expr_print_help, &debug, E_NONE);
-			debug += "<br>";
-			break;
-		case P_RANGE:
-			debug += "range: ";
-			expr_print(prop->expr, expr_print_help, &debug, E_NONE);
-			debug += "<br>";
-			break;
 		default:
 			debug += "unknown property: ";
 			debug += prop_get_type_name(prop->type);
Index: linux-2.6/scripts/kconfig/symbol.c
===================================================================
--- linux-2.6.orig/scripts/kconfig/symbol.c
+++ linux-2.6/scripts/kconfig/symbol.c
@@ -34,6 +34,8 @@ struct symbol *sym_defconfig_list;
 struct symbol *modules_sym;
 tristate modules_val;
 
+struct expr *sym_env_list;
+
 void sym_add_default(struct symbol *sym, const char *def)
 {
 	struct property *prop = prop_alloc(P_DEFAULT, sym);
@@ -117,6 +119,15 @@ struct property *sym_get_choice_prop(str
 	return NULL;
 }
 
+struct property *sym_get_env_prop(struct symbol *sym)
+{
+	struct property *prop;
+
+	for_all_properties(sym, prop, P_ENV)
+		return prop;
+	return NULL;
+}
+
 struct property *sym_get_default_prop(struct symbol *sym)
 {
 	struct property *prop;
@@ -346,6 +357,9 @@ void sym_calc_value(struct symbol *sym)
 		;
 	}
 
+	if (sym->flags & SYMBOL_AUTO)
+		sym->flags &= ~SYMBOL_WRITE;
+
 	sym->curr = newval;
 	if (sym_is_choice(sym) && newval.tri == yes)
 		sym->curr.val = sym_calc_choice(sym);
@@ -860,6 +874,8 @@ const char *prop_get_type_name(enum prop
 	switch (type) {
 	case P_PROMPT:
 		return "prompt";
+	case P_ENV:
+		return "env";
 	case P_COMMENT:
 		return "comment";
 	case P_MENU:
@@ -877,3 +893,32 @@ const char *prop_get_type_name(enum prop
 	}
 	return "unknown";
 }
+
+void prop_add_env(const char *env)
+{
+	struct symbol *sym, *sym2;
+	struct property *prop;
+	char *p;
+
+	sym = current_entry->sym;
+	sym->flags |= SYMBOL_AUTO;
+	for_all_properties(sym, prop, P_ENV) {
+		sym2 = prop_get_symbol(prop);
+		if (strcmp(sym2->name, env))
+			menu_warn(current_entry, "redefining environment symbol from %s",
+				  sym2->name);
+		return;
+	}
+
+	prop = prop_alloc(P_ENV, sym);
+	prop->expr = expr_alloc_symbol(sym_lookup(env, 1));
+
+	sym_env_list = expr_alloc_one(E_LIST, sym_env_list);
+	sym_env_list->right.sym = sym;
+
+	p = getenv(env);
+	if (p)
+		sym_add_default(sym, p);
+	else
+		menu_warn(current_entry, "environment variable %s undefined", env);
+}
Index: linux-2.6/scripts/kconfig/util.c
===================================================================
--- linux-2.6.orig/scripts/kconfig/util.c
+++ linux-2.6/scripts/kconfig/util.c
@@ -29,6 +29,8 @@ struct file *file_lookup(const char *nam
 /* write a dependency file as used by kbuild to track dependencies */
 int file_write_dep(const char *name)
 {
+	struct symbol *sym, *env_sym;
+	struct expr *e;
 	struct file *file;
 	FILE *out;
 
@@ -45,8 +47,25 @@ int file_write_dep(const char *name)
 			fprintf(out, "\t%s\n", file->name);
 	}
 	fprintf(out, "\ninclude/config/auto.conf: \\\n"
-		     "\t$(deps_config)\n\n"
-		     "$(deps_config): ;\n");
+		     "\t$(deps_config)\n\n");
+
+	expr_list_for_each_sym(sym_env_list, e, sym) {
+		struct property *prop;
+		const char *value;
+
+		prop = sym_get_env_prop(sym);
+		env_sym = prop_get_symbol(prop);
+		if (!env_sym)
+			continue;
+		value = getenv(env_sym->name);
+		if (!value)
+			value = "";
+		fprintf(out, "ifneq \"$(%s)\" \"%s\"\n", env_sym->name, value);
+		fprintf(out, "include/config/auto.conf: FORCE\n");
+		fprintf(out, "endif\n");
+	}
+
+	fprintf(out, "\n$(deps_config): ;\n");
 	fclose(out);
 	rename("..config.tmp", name);
 	return 0;
Index: linux-2.6/scripts/kconfig/zconf.gperf
===================================================================
--- linux-2.6.orig/scripts/kconfig/zconf.gperf
+++ linux-2.6/scripts/kconfig/zconf.gperf
@@ -41,4 +41,5 @@ option,		T_OPTION,	TF_COMMAND
 on,		T_ON,		TF_PARAM
 modules,	T_OPT_MODULES,	TF_OPTION
 defconfig_list,	T_OPT_DEFCONFIG_LIST,TF_OPTION
+env,		T_OPT_ENV,	TF_OPTION
 %%
Index: linux-2.6/scripts/kconfig/zconf.hash.c_shipped
===================================================================
--- linux-2.6.orig/scripts/kconfig/zconf.hash.c_shipped
+++ linux-2.6/scripts/kconfig/zconf.hash.c_shipped
@@ -53,10 +53,10 @@ kconf_id_hash (register const char *str,
       49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
       49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
       49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 18, 11,  5,
+      49, 49, 49, 49, 49, 49, 49, 35, 35,  5,
        0,  0,  5, 49,  5, 20, 49, 49,  5, 20,
-       5,  0, 30, 49,  0, 15,  0, 10, 49, 49,
-      25, 49, 49, 49, 49, 49, 49, 49, 49, 49,
+       5,  0, 30, 49,  0, 15,  0, 10,  0, 49,
+      10, 49, 49, 49, 49, 49, 49, 49, 49, 49,
       49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
       49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
       49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
@@ -89,6 +89,7 @@ kconf_id_hash (register const char *str,
 struct kconf_id_strings_t
   {
     char kconf_id_strings_str2[sizeof("on")];
+    char kconf_id_strings_str3[sizeof("env")];
     char kconf_id_strings_str5[sizeof("endif")];
     char kconf_id_strings_str6[sizeof("option")];
     char kconf_id_strings_str7[sizeof("endmenu")];
@@ -99,30 +100,31 @@ struct kconf_id_strings_t
     char kconf_id_strings_str12[sizeof("default")];
     char kconf_id_strings_str13[sizeof("def_bool")];
     char kconf_id_strings_str14[sizeof("help")];
-    char kconf_id_strings_str15[sizeof("bool")];
     char kconf_id_strings_str16[sizeof("config")];
     char kconf_id_strings_str17[sizeof("def_tristate")];
-    char kconf_id_strings_str18[sizeof("boolean")];
+    char kconf_id_strings_str18[sizeof("hex")];
     char kconf_id_strings_str19[sizeof("defconfig_list")];
     char kconf_id_strings_str21[sizeof("string")];
     char kconf_id_strings_str22[sizeof("if")];
     char kconf_id_strings_str23[sizeof("int")];
-    char kconf_id_strings_str24[sizeof("enable")];
     char kconf_id_strings_str26[sizeof("select")];
     char kconf_id_strings_str27[sizeof("modules")];
     char kconf_id_strings_str28[sizeof("tristate")];
     char kconf_id_strings_str29[sizeof("menu")];
     char kconf_id_strings_str31[sizeof("source")];
     char kconf_id_strings_str32[sizeof("comment")];
-    char kconf_id_strings_str33[sizeof("hex")];
     char kconf_id_strings_str35[sizeof("menuconfig")];
     char kconf_id_strings_str36[sizeof("prompt")];
     char kconf_id_strings_str37[sizeof("depends")];
+    char kconf_id_strings_str39[sizeof("bool")];
+    char kconf_id_strings_str41[sizeof("enable")];
+    char kconf_id_strings_str42[sizeof("boolean")];
     char kconf_id_strings_str48[sizeof("mainmenu")];
   };
 static struct kconf_id_strings_t kconf_id_strings_contents =
   {
     "on",
+    "env",
     "endif",
     "option",
     "endmenu",
@@ -133,25 +135,25 @@ static struct kconf_id_strings_t kconf_i
     "default",
     "def_bool",
     "help",
-    "bool",
     "config",
     "def_tristate",
-    "boolean",
+    "hex",
     "defconfig_list",
     "string",
     "if",
     "int",
-    "enable",
     "select",
     "modules",
     "tristate",
     "menu",
     "source",
     "comment",
-    "hex",
     "menuconfig",
     "prompt",
     "depends",
+    "bool",
+    "enable",
+    "boolean",
     "mainmenu"
   };
 #define kconf_id_strings ((const char *) &kconf_id_strings_contents)
@@ -163,7 +165,7 @@ kconf_id_lookup (register const char *st
 {
   enum
     {
-      TOTAL_KEYWORDS = 31,
+      TOTAL_KEYWORDS = 32,
       MIN_WORD_LENGTH = 2,
       MAX_WORD_LENGTH = 14,
       MIN_HASH_VALUE = 2,
@@ -174,7 +176,8 @@ kconf_id_lookup (register const char *st
     {
       {-1}, {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str2,		T_ON,		TF_PARAM},
-      {-1}, {-1},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str3,		T_OPT_ENV,	TF_OPTION},
+      {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str5,		T_ENDIF,	TF_COMMAND},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str6,		T_OPTION,	TF_COMMAND},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str7,	T_ENDMENU,	TF_COMMAND},
@@ -185,17 +188,16 @@ kconf_id_lookup (register const char *st
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str12,	T_DEFAULT,	TF_COMMAND, S_UNKNOWN},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str13,	T_DEFAULT,	TF_COMMAND, S_BOOLEAN},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str14,		T_HELP,		TF_COMMAND},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str15,		T_TYPE,		TF_COMMAND, S_BOOLEAN},
+      {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str16,		T_CONFIG,	TF_COMMAND},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str17,	T_DEFAULT,	TF_COMMAND, S_TRISTATE},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str18,	T_TYPE,		TF_COMMAND, S_BOOLEAN},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str18,		T_TYPE,		TF_COMMAND, S_HEX},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str19,	T_OPT_DEFCONFIG_LIST,TF_OPTION},
       {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str21,		T_TYPE,		TF_COMMAND, S_STRING},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str22,		T_IF,		TF_COMMAND|TF_PARAM},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str23,		T_TYPE,		TF_COMMAND, S_INT},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str24,		T_SELECT,	TF_COMMAND},
-      {-1},
+      {-1}, {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str26,		T_SELECT,	TF_COMMAND},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str27,	T_OPT_MODULES,	TF_OPTION},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str28,	T_TYPE,		TF_COMMAND, S_TRISTATE},
@@ -203,13 +205,16 @@ kconf_id_lookup (register const char *st
       {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str31,		T_SOURCE,	TF_COMMAND},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str32,	T_COMMENT,	TF_COMMAND},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str33,		T_TYPE,		TF_COMMAND, S_HEX},
-      {-1},
+      {-1}, {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str35,	T_MENUCONFIG,	TF_COMMAND},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str36,		T_PROMPT,	TF_COMMAND},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str37,	T_DEPENDS,	TF_COMMAND},
-      {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
       {-1},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str39,		T_TYPE,		TF_COMMAND, S_BOOLEAN},
+      {-1},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str41,		T_SELECT,	TF_COMMAND},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str42,	T_TYPE,		TF_COMMAND, S_BOOLEAN},
+      {-1}, {-1}, {-1}, {-1}, {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str48,	T_MAINMENU,	TF_COMMAND}
     };
 
