Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbYK2Vkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbYK2Vkj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 16:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYK2VkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 16:40:25 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:46423 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbYK2VkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 16:40:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ittLeKOSLd8nZJnI4jbaacQFaCojj+Tc6vGjkPk6QVJsztxjqIq1phmxu7IBeFfmat
         NtIA5daq4W2GtD7BXx4K/DgrEZcZz459Kga3iPX3Kv6lQQw/RN/PKKK83M/j9/ISifrZ
         gdKjIMFpwS35M2+l1dD3626ypMdtZgDNp8ji0=
From: Nir Tzachar <nir.tzachar@gmail.com>
To: nir.tzachar@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] nconfig V3
Date: Sat, 29 Nov 2008 23:40:14 +0200
Message-Id: <1227994814-17551-2-git-send-email-nir.tzachar@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1227994814-17551-1-git-send-email-nir.tzachar@gmail.com>
References: <1220469076-16487-1-git-send-email-nir@tzachar.com>
 <1227994814-17551-1-git-send-email-nir.tzachar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since last version:

1) Added cursor to input dialog boxes.
2) ? key is bound to help messages.
3) Removed the "()" logic of hot keys. Now, the first upper cased letter of an
   item is the hot key.
4) Source was split into two parts; for gui logic (nconf.gui.c) and kconfig
   interface (nconf.c).
5) Shared code with mconf.c has been moved to share.c .
6) General improvements (e.g., all text is centered, etc.)

Open issues:

1) The problem Willy reported with pressing the keypad too quickly. As I cannot
   reproduce this, I would appreciate a recheck.
2) The color scheme.

Regarding the color scheme, I think we should first agree that the patch is
worth including before we procceed. Tweaking the colors will be the easy part ;)

---
 scripts/kconfig/Makefile            |   23 +-
 scripts/kconfig/conf.c              |  123 ++--
 scripts/kconfig/confdata.c          |   11 +-
 scripts/kconfig/lkc.h               |    2 +-
 scripts/kconfig/mconf.c             |   76 +--
 scripts/kconfig/menu.c              |    2 +-
 scripts/kconfig/nconf.c             | 1378 +++++++++++++++++++++++++++++++++++
 scripts/kconfig/nconf.gui.c         |  653 +++++++++++++++++
 scripts/kconfig/nconf.h             |   86 +++
 scripts/kconfig/shared.c            |   82 +++
 scripts/kconfig/shared.h            |   13 +
 scripts/kconfig/zconf.tab.c_shipped |    2 +-
 scripts/kconfig/zconf.y             |    2 +-
 13 files changed, 2306 insertions(+), 147 deletions(-)
 create mode 100644 scripts/kconfig/nconf.c
 create mode 100644 scripts/kconfig/nconf.gui.c
 create mode 100644 scripts/kconfig/nconf.h
 create mode 100644 scripts/kconfig/shared.c
 create mode 100644 scripts/kconfig/shared.h

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index fa8c2dd..58626b0 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -4,11 +4,7 @@
 
 PHONY += oldconfig xconfig gconfig menuconfig config silentoldconfig update-po-config
 
-ifdef KBUILD_KCONFIG
-Kconfig := $(KBUILD_KCONFIG)
-else
 Kconfig := arch/$(SRCARCH)/Kconfig
-endif
 
 xconfig: $(obj)/qconf
 	$< $(Kconfig)
@@ -19,6 +15,9 @@ gconfig: $(obj)/gconf
 menuconfig: $(obj)/mconf
 	$< $(Kconfig)
 
+nconfig: $(obj)/nconf
+	$< $(Kconfig)
+
 config: $(obj)/conf
 	$< $(Kconfig)
 
@@ -79,6 +78,7 @@ endif
 # Help text used by make help
 help:
 	@echo  '  config	  - Update current config utilising a line-oriented program'
+	@echo  '  nconfig	  - Update current config utilising a ncurses menu based program'
 	@echo  '  menuconfig	  - Update current config utilising a menu based program'
 	@echo  '  xconfig	  - Update current config utilising a QT based front-end'
 	@echo  '  gconfig	  - Update current config utilising a GTK based front-end'
@@ -106,6 +106,8 @@ HOST_EXTRACFLAGS += -DLOCALE
 # conf:	  Used for defconfig, oldconfig and related targets
 # mconf:  Used for the mconfig target.
 #         Utilizes the lxdialog package
+# nconf:  Used for the nconfig target.
+#         Utilizes ncurses
 # qconf:  Used for the xconfig target
 #         Based on QT which needs to be installed to compile it
 # gconf:  Used for the gconfig target
@@ -116,7 +118,8 @@ lxdialog := lxdialog/checklist.o lxdialog/util.o lxdialog/inputbox.o
 lxdialog += lxdialog/textbox.o lxdialog/yesno.o lxdialog/menubox.o
 
 conf-objs	:= conf.o  zconf.tab.o
-mconf-objs	:= mconf.o zconf.tab.o $(lxdialog)
+mconf-objs	:= mconf.o zconf.tab.o shared.o $(lxdialog)
+nconf-objs	:= nconf.o zconf.tab.o shared.o nconf.gui.o 
 kxgettext-objs	:= kxgettext.o zconf.tab.o
 
 hostprogs-y := conf qconf gconf kxgettext
@@ -125,6 +128,10 @@ ifeq ($(MAKECMDGOALS),menuconfig)
 	hostprogs-y += mconf
 endif
 
+ifeq ($(MAKECMDGOALS),nconfig)
+	hostprogs-y += nconf
+endif
+
 ifeq ($(MAKECMDGOALS),xconfig)
 	qconf-target := 1
 endif
@@ -144,7 +151,7 @@ endif
 
 clean-files	:= lkc_defs.h qconf.moc .tmp_qtcheck \
 		   .tmp_gtkcheck zconf.tab.c lex.zconf.c zconf.hash.c gconf.glade.h
-clean-files     += mconf qconf gconf
+clean-files     += mconf qconf gconf nconf
 clean-files     += config.pot linux.pot
 
 # Check that we have the required ncurses stuff installed for lxdialog (menuconfig)
@@ -162,6 +169,10 @@ HOST_EXTRACFLAGS += $(shell $(CONFIG_SHELL) $(srctree)/$(src)/check.sh $(HOSTCC)
 HOSTCFLAGS_lex.zconf.o	:= -I$(src)
 HOSTCFLAGS_zconf.tab.o	:= -I$(src)
 
+HOSTLOADLIBES_nconf	= -lmenu -lpanel -lncurses 
+HOSTCFLAGS_nconf.o	=
+LDFLAGS_nconf.o		=
+
 HOSTLOADLIBES_qconf	= $(KC_QT_LIBS) -ldl
 HOSTCXXFLAGS_qconf.o	= $(KC_QT_CFLAGS) -D LKC_DIRECT_LINK
 
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 3e1057f..36b5eed 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -32,7 +32,6 @@ char *defconfig_file;
 
 static int indent = 1;
 static int valid_stdin = 1;
-static int sync_kconfig;
 static int conf_cnt;
 static char line[128];
 static struct menu *rootEntry;
@@ -66,7 +65,7 @@ static void strip(char *str)
 
 static void check_stdin(void)
 {
-	if (!valid_stdin) {
+	if (!valid_stdin && input_mode == ask_silent) {
 		printf(_("aborted!\n\n"));
 		printf(_("Console input/output is redirected. "));
 		printf(_("Run 'make oldconfig' to update configuration.\n\n"));
@@ -428,6 +427,43 @@ static void check_conf(struct menu *menu)
 		check_conf(child);
 }
 
+static void conf_do_update(void)
+{
+	/* Update until a loop caused no more changes */
+	do {
+		conf_cnt = 0;
+		check_conf(&rootmenu);
+	} while (conf_cnt);
+}
+
+static int conf_silent_update(void)
+{
+	const char *name;
+
+	if (conf_get_changed()) {
+		name = getenv("KCONFIG_NOSILENTUPDATE");
+		if (name && *name) {
+			fprintf(stderr,
+			_("\n*** Kernel configuration requires explicit update.\n\n"));
+			return 1;
+		}
+		conf_do_update();
+	}
+	return 0;
+}
+
+static int conf_update(void)
+{
+	rootEntry = &rootmenu;
+	conf(&rootmenu);
+	if (input_mode == ask_all) {
+		input_mode = ask_silent;
+		valid_stdin = 1;
+	}
+	conf_do_update();
+	return 0;
+}
+
 int main(int ac, char **av)
 {
 	int opt;
@@ -441,11 +477,11 @@ int main(int ac, char **av)
 	while ((opt = getopt(ac, av, "osdD:nmyrh")) != -1) {
 		switch (opt) {
 		case 'o':
-			input_mode = ask_silent;
+			input_mode = ask_new;
 			break;
 		case 's':
 			input_mode = ask_silent;
-			sync_kconfig = 1;
+			valid_stdin = isatty(0) && isatty(1) && isatty(2);
 			break;
 		case 'd':
 			input_mode = set_default;
@@ -483,19 +519,6 @@ int main(int ac, char **av)
 	name = av[optind];
 	conf_parse(name);
 	//zconfdump(stdout);
-	if (sync_kconfig) {
-		if (stat(".config", &tmpstat)) {
-			fprintf(stderr, _("***\n"
-				"*** You have not yet configured your kernel!\n"
-				"*** (missing kernel .config file)\n"
-				"***\n"
-				"*** Please run some configurator (e.g. \"make oldconfig\" or\n"
-				"*** \"make menuconfig\" or \"make xconfig\").\n"
-				"***\n"));
-			exit(1);
-		}
-	}
-
 	switch (input_mode) {
 	case set_default:
 		if (!defconfig_file)
@@ -508,6 +531,16 @@ int main(int ac, char **av)
 		}
 		break;
 	case ask_silent:
+		if (stat(".config", &tmpstat)) {
+			printf(_("***\n"
+				"*** You have not yet configured your kernel!\n"
+				"*** (missing kernel .config file)\n"
+				"***\n"
+				"*** Please run some configurator (e.g. \"make oldconfig\" or\n"
+				"*** \"make menuconfig\" or \"make xconfig\").\n"
+				"***\n"));
+			exit(1);
+		}
 	case ask_all:
 	case ask_new:
 		conf_read(NULL);
@@ -536,19 +569,6 @@ int main(int ac, char **av)
 	default:
 		break;
 	}
-
-	if (sync_kconfig) {
-		if (conf_get_changed()) {
-			name = getenv("KCONFIG_NOSILENTUPDATE");
-			if (name && *name) {
-				fprintf(stderr,
-					_("\n*** Kernel configuration requires explicit update.\n\n"));
-				return 1;
-			}
-		}
-		valid_stdin = isatty(0) && isatty(1) && isatty(2);
-	}
-
 	switch (input_mode) {
 	case set_no:
 		conf_set_all_new_symbols(def_no);
@@ -565,38 +585,27 @@ int main(int ac, char **av)
 	case set_default:
 		conf_set_all_new_symbols(def_default);
 		break;
+	case ask_silent:
 	case ask_new:
+		if (conf_silent_update())
+			exit(1);
+		break;
 	case ask_all:
-		rootEntry = &rootmenu;
-		conf(&rootmenu);
-		input_mode = ask_silent;
-		/* fall through */
-	case ask_silent:
-		/* Update until a loop caused no more changes */
-		do {
-			conf_cnt = 0;
-			check_conf(&rootmenu);
-		} while (conf_cnt);
+		if (conf_update())
+			exit(1);
 		break;
 	}
 
-	if (sync_kconfig) {
-		/* silentoldconfig is used during the build so we shall update autoconf.
-		 * All other commands are only used to generate a config.
-		 */
-		if (conf_get_changed() && conf_write(NULL)) {
-			fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
-			exit(1);
-		}
-		if (conf_write_autoconf()) {
-			fprintf(stderr, _("\n*** Error during update of the kernel configuration.\n\n"));
-			return 1;
-		}
-	} else {
-		if (conf_write(NULL)) {
-			fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
-			exit(1);
-		}
+	if (conf_write(NULL)) {
+		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
+		exit(1);
+	}
+	/* ask_silent is used during the build so we shall update autoconf.
+	 * All other commands are only used to generate a config.
+	 */
+	if (input_mode == ask_silent && conf_write_autoconf()) {
+		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
+		return 1;
 	}
 	return 0;
 }
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 830d9ea..df6a188 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -222,10 +222,8 @@ load:
 				continue;
 			if (def == S_DEF_USER) {
 				sym = sym_find(line + 9);
-				if (!sym) {
-					sym_add_change_count(1);
+				if (!sym)
 					break;
-				}
 			} else {
 				sym = sym_lookup(line + 9, 0);
 				if (sym->type == S_UNKNOWN)
@@ -261,10 +259,8 @@ load:
 			}
 			if (def == S_DEF_USER) {
 				sym = sym_find(line + 7);
-				if (!sym) {
-					sym_add_change_count(1);
+				if (!sym)
 					break;
-				}
 			} else {
 				sym = sym_lookup(line + 7, 0);
 				if (sym->type == S_UNKNOWN)
@@ -852,7 +848,8 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 
 	}
 
-	sym_clear_all_valid();
+	if (modules_sym)
+		sym_calc_value(modules_sym);
 
 	if (mode != def_random)
 		return;
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index 4a9af6f..0e9c477 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -83,7 +83,7 @@ void conf_set_all_new_symbols(enum conf_def_mode mode);
 void kconfig_load(void);
 
 /* menu.c */
-void menu_init(void);
+void _menu_init(void);
 void menu_warn(struct menu *menu, const char *fmt, ...);
 struct menu *menu_add_menu(void);
 void menu_end_menu(void);
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 6841e95..96dfcab 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -6,6 +6,8 @@
  * 2002-11-06 Petr Baudis <pasky@ucw.cz>
  *
  * i18n, 2005, Arnaldo Carvalho de Melo <acme@conectiva.com.br>
+ *
+ * ncurses interface, 2008, Nir Tzachar <nir@tzachar.com>
  */
 
 #include <ctype.h>
@@ -20,6 +22,7 @@
 
 #define LKC_DIRECT_LINK
 #include "lkc.h"
+#include "shared.h"
 #include "lxdialog/dialog.h"
 
 static const char mconf_readme[] = N_(
@@ -284,78 +287,6 @@ static void show_textbox(const char *title, const char *text, int r, int c);
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
-static struct gstr get_relations_str(struct symbol **sym_arr)
-{
-	struct symbol *sym;
-	struct gstr res = str_new();
-	int i;
-
-	for (i = 0; sym_arr && (sym = sym_arr[i]); i++)
-		get_symbol_str(&res, sym);
-	if (!i)
-		str_append(&res, _("No matches found.\n"));
-	return res;
-}
 
 static char filename[PATH_MAX+1];
 static void set_config_filename(const char *config_filename)
@@ -378,7 +309,6 @@ static void set_config_filename(const char *config_filename)
 		filename[sizeof(filename)-1] = '\0';
 }
 
-
 static void search_conf(void)
 {
 	struct symbol **sym_arr;
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 07ff8d1..ade19a3 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -35,7 +35,7 @@ static void prop_warn(struct property *prop, const char *fmt, ...)
 	va_end(ap);
 }
 
-void menu_init(void)
+void _menu_init(void)
 {
 	current_entry = current_menu = &rootmenu;
 	last_entry_ptr = &rootmenu.list;
diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
new file mode 100644
index 0000000..cb64236
--- /dev/null
+++ b/scripts/kconfig/nconf.c
@@ -0,0 +1,1378 @@
+/*
+ * Copyright (C) 2008 Nir Tzachar <nir.tzachar@gmail.com?
+ * Released under the terms of the GNU GPL v2.0.
+ *
+ * Derived from menuconfig.
+ *
+ */
+#define LKC_DIRECT_LINK
+#include "lkc.h"
+#include "shared.h"
+#include "nconf.h"
+
+static const char nconf_readme[] = N_(
+"Overview\n"
+"--------\n"
+"Some kernel features may be built directly into the kernel.\n"
+"Some may be made into loadable runtime modules.  Some features\n"
+"may be completely removed altogether.  There are also certain\n"
+"kernel parameters which are not really features, but must be\n"
+"entered in as decimal or hexadecimal numbers or possibly text.\n"
+"\n"
+"Menu items beginning with following braces represent features that\n"
+"  [ ] can be built in or removed\n"
+"  < > can be built in, modularized or removed\n"
+"  { } can be built in or modularized (selected by other feature)\n"
+"  - - are selected by other feature,\n"
+"while *, M or whitespace inside braces means to build in, build as\n"
+"a module or to exclude the feature respectively.\n"
+"\n"
+"To change any of these features, highlight it with the cursor\n"
+"keys and press <Y> to build it in, <M> to make it a module or\n"
+"<N> to removed it.  You may also press the <Space Bar> to cycle\n"
+"through the available options (ie. Y->N->M->Y).\n"
+"\n"
+"Some additional keyboard hints:\n"
+"\n"
+"Menus\n"
+"----------\n"
+"o  Use the Up/Down arrow keys (cursor keys) to highlight the item\n"
+"   you wish to change or submenu wish to select and press <Enter>.\n"
+"   Submenus are designated by \"--->\".\n"
+"\n"
+"   Shortcut: Press the option's highlighted letter (hotkey).\n"
+"             Pressing a hotkey more than once will sequence\n"
+"             through all visible items which use that hotkey.\n"
+"\n"
+"   You may also use the <PAGE UP> and <PAGE DOWN> keys to scroll\n"
+"   unseen options into view.\n"
+"\n"
+"o  To exit a menu use the cursor keys to highlight the <Exit> button\n"
+"   and press <ENTER>, or just press <ESC>.\n"
+"\n"
+"   Also, the <TAB> and cursor keys will cycle between <Select>,\n"
+"   <Exit>, <Help> and <Instructions> \n"
+"\n"
+"o  To get help with an item, use the cursor keys to highlight <Help>\n"
+"   and Press <ENTER>.\n"
+"\n"
+"   Shortcut: Press <h> or <?>.\n"
+"\n"
+"\n"
+"Radiolists  (Choice lists)\n"
+"-----------\n"
+"o  Use the cursor keys to select the option you wish to set and press\n"
+"   <S> or the <SPACE BAR>.\n"
+"\n"
+"   Shortcut: Press the first letter of the option you wish to set then\n"
+"             press <S> or <SPACE BAR>.\n"
+"\n"
+"o  To see available help for the item, use the cursor keys to highlight\n"
+"   <Help> and Press <ENTER>.\n"
+"\n"
+"   Shortcut: Press <H> or <?>.\n"
+"\n"
+"   Also, the <TAB> and cursor keys will cycle between <Select>, \n"
+"   <Exit>, <Help> and <Instructions>\n"
+"\n"
+"\n"
+"Data Entry\n"
+"-----------\n"
+"o  Enter the requested information and press <ENTER>\n"
+"   If you are entering hexadecimal values, it is not necessary to\n"
+"   add the '0x' prefix to the entry.\n"
+"\n"
+"o  For help, use the <TAB> or cursor keys to highlight the help option\n"
+"   and press <ENTER>.  You can try <TAB><H> as well.\n"
+"\n"
+"\n"
+"Text Box    (Help Window)\n"
+"--------\n"
+"o  Use the cursor keys to scroll up/down/left/right.  The VI editor\n"
+"   keys h,j,k,l function here as do <SPACE BAR> for those\n"
+"   who are familiar with less and lynx.\n"
+"\n"
+"o  Press <Enter> or <Esc> to exit.\n"
+"\n"
+"\n"
+"Alternate Configuration Files\n"
+"-----------------------------\n"
+"nconfig supports the use of alternate configuration files for\n"
+"those who, for various reasons, find it necessary to switch\n"
+"between different kernel configurations.\n"
+"\n"
+"At the end of the main menu you will find two options.  One is\n"
+"for saving the current configuration to a file of your choosing.\n"
+"The other option is for loading a previously saved alternate\n"
+"configuration.\n"
+"\n"
+"Even if you don't use alternate configuration files, but you\n"
+"find during a nconfig session that you have completely messed\n"
+"up your settings, you may use the \"Load Alternate...\" option to\n"
+"restore your previously saved settings from \".config\" without\n"
+"restarting nconfig.\n"
+"\n"
+"Other information\n"
+"-----------------\n"
+"If you use nconfig in an XTERM window make sure you have your\n"
+"$TERM variable set to point to a xterm definition which supports color.\n"
+"Otherwise, nconfig will look rather bad.  nconfig will not\n"
+"display correctly in a RXVT window because rxvt displays only one\n"
+"intensity of color, bright.\n"
+"\n"
+"nconfig will display larger menus on screens or xterms which are\n"
+"set to display more than the standard 25 row by 80 column geometry.\n"
+"In order for this to work, the \"stty size\" command must be able to\n"
+"display the screen's current row and column geometry.  I STRONGLY\n"
+"RECOMMEND that you make sure you do NOT have the shell variables\n"
+"LINES and COLUMNS exported into your environment.  Some distributions\n"
+"export those variables via /etc/profile.  Some ncurses programs can\n"
+"become confused when those variables (LINES & COLUMNS) don't reflect\n"
+"the true screen size.\n"
+"\n"
+"Optional personality available\n"
+"------------------------------\n"
+"If you prefer to have all of the kernel options listed in a single\n"
+"menu, rather than the default multimenu hierarchy, run the nconfig\n"
+"with NCONFIG_MODE environment variable set to single_menu. Example:\n"
+"\n"
+"make NCONFIG_MODE = single_menu nconfig\n"
+"\n"
+"<Enter> will then unroll the appropriate category, or enfold it if it\n"
+"is already unrolled.\n"
+"\n"
+"Note that this mode can eventually be a little more CPU expensive\n"
+"(especially with a larger number of unrolled categories) than the\n"
+"default mode.\n"
+"\n"),
+menu_instructions[] = N_(
+	" Arrow keys navigate the menu.\n"
+	" <Enter> selects submenus --->.\n"
+	" Letters in () are hotkeys.\n"
+	" Pressing <Y> includes, <N> excludes, <M> modularizes features.\n"
+	" Press <Esc> to go back one menu, <?> or <h> for Help, </> for Search.\n"
+	" Legend: [*] built-in  [ ] excluded  <M> module  < > module capable.\n"
+	" <Esc> allways leaves the current window\n"),
+radiolist_instructions[] = N_(
+	" Use the arrow keys to navigate this window or\n"
+	" press the hotkey of the item you wish to select\n"
+	" followed by the <SPACE BAR>.\n"
+	" Press <?> or <h> for additional information about this option.\n"),
+inputbox_instructions_int[] = N_(
+	"Please enter a decimal value.\n"
+	"Fractions will not be accepted.\n"
+	"Press <RETURN> to accept, <ESC> to cancel."),
+inputbox_instructions_hex[] = N_(
+	"Please enter a hexadecimal value.\n"
+	"Press <RETURN> to accept, <ESC> to cancel."),
+inputbox_instructions_string[] = N_(
+	"Please enter a string value.\n"
+	"Press <RETURN> to accept, <ESC> to cancel."),
+setmod_text[] = N_(
+	"This feature depends on another which\n"
+	"has been configured as a module.\n"
+	"As a result, this feature will be built as a module."),
+nohelp_text[] = N_(
+	"There is no help available for this kernel option.\n"),
+load_config_text[] = N_(
+	"Enter the name of the configuration file you wish to load.\n"
+	"Accept the name shown to restore the configuration you\n"
+	"last retrieved.  Leave blank to abort."),
+load_config_help[] = N_(
+	"\n"
+	"For various reasons, one may wish to keep several different kernel\n"
+	"configurations available on a single machine.\n"
+	"\n"
+	"If you have saved a previous configuration in a file other than the\n"
+	"kernel's default, entering the name of the file here will allow you\n"
+	"to modify that configuration.\n"
+	"\n"
+	"If you are uncertain, then you have probably never used alternate\n"
+	"configuration files.  You should therefor leave this blank to abort.\n"),
+save_config_text[] = N_(
+	"Enter a filename to which this configuration should be saved\n"
+	"as an alternate.  Leave blank to abort."),
+save_config_help[] = N_(
+	"\n"
+	"For various reasons, one may wish to keep different kernel\n"
+	"configurations available on a single machine.\n"
+	"\n"
+	"Entering a file name here will allow you to later retrieve, modify\n"
+	"and use the current configuration as an alternate to whatever\n"
+	"configuration options you have selected at that time.\n"
+	"\n"
+	"If you are uncertain what all this means then you should probably\n"
+	"leave this blank.\n"),
+search_help[] = N_(
+	"\n"
+	"Search for CONFIG_ symbols and display their relations.\n"
+	"Regular expressions are allowed.\n"
+	"Example: search for \"^FOO\"\n"
+	"Result:\n"
+	"-----------------------------------------------------------------\n"
+	"Symbol: FOO [ = m]\n"
+	"Prompt: Foo bus is used to drive the bar HW\n"
+	"Defined at drivers/pci/Kconfig:47\n"
+	"Depends on: X86_LOCAL_APIC && X86_IO_APIC || IA64\n"
+	"Location:\n"
+	"  -> Bus options (PCI, PCMCIA, EISA, MCA, ISA)\n"
+	"    -> PCI support (PCI [ = y])\n"
+	"      -> PCI access mode (<choice> [ = y])\n"
+	"Selects: LIBCRC32\n"
+	"Selected by: BAR\n"
+	"-----------------------------------------------------------------\n"
+	"o The line 'Prompt:' shows the text used in the menu structure for\n"
+	"  this CONFIG_ symbol\n"
+	"o The 'Defined at' line tell at what file / line number the symbol\n"
+	"  is defined\n"
+	"o The 'Depends on:' line tell what symbols needs to be defined for\n"
+	"  this symbol to be visible in the menu (selectable)\n"
+	"o The 'Location:' lines tell where in the menu structure this symbol\n"
+	"  is located\n"
+	"    A location followed by a [ = y] indicate that this is a selectable\n"
+	"    menu item - and current value is displayed inside brackets.\n"
+	"o The 'Selects:' line tell what symbol will be automatically\n"
+	"  selected if this symbol is selected (y or m)\n"
+	"o The 'Selected by' line tell what symbol has selected this symbol\n"
+	"\n"
+	"Only relevant lines are shown.\n"
+	"\n\n"
+	"Search examples:\n"
+	"Examples: USB	 = > find all CONFIG_ symbols containing USB\n"
+	"          ^USB => find all CONFIG_ symbols starting with USB\n"
+	"          USB$ => find all CONFIG_ symbols ending with USB\n"
+	"\n");
+
+struct mitem {
+	char str[256];
+	char tag;
+	void *usrptr;
+	int is_hot;
+};
+
+#define MAX_MENU_ITEMS 4096
+static int indent;
+static struct menu *current_menu;
+static int child_count;
+static int single_menu_mode;
+/* the window in which all information appears */
+static WINDOW *main_window;
+/* the largest size of the menu window */
+static int mwin_max_lines;
+static int mwin_max_cols;
+/* the window in which we show option buttons */
+static WINDOW *btns_window;
+static MENU *curses_menu;
+static MENU *btns_menu;
+static ITEM *curses_menu_items[MAX_MENU_ITEMS];
+static struct mitem k_menu_items[MAX_MENU_ITEMS];
+static int items_num;
+/* the currently selected button */
+static enum current_btn_t { BTN_SELECT = 0, BTN_EXIT, BTN_HELP, BTN_INSTS,
+	BTN_MAX} current_btn = BTN_SELECT;
+static ITEM *btns_items[BTN_MAX];
+const char *current_instructions = menu_instructions;
+
+static char *btns[] = {
+	"   <Select>   ",
+	"    <Exit>    ",
+	"    <Help>    ",
+	"<Instructions>",
+	NULL
+};
+
+/* this array is used to implement hot keys. it is updated in item_make and
+ * resetted in clean_items. It would be better to use a hash, but lets keep it
+ * simple... */
+#define MAX_SAME_KEY MAX_MENU_ITEMS
+struct {
+	int count;
+	int ptrs[MAX_MENU_ITEMS];
+} hotkeys[1<<(sizeof(char)*8)];
+
+static void conf(struct menu *menu);
+static void conf_choice(struct menu *menu);
+static void conf_string(struct menu *menu);
+static void conf_load(void);
+static void conf_save(void);
+static void show_help(struct menu *menu);
+
+static void update_current_btn(void)
+{
+	int index = item_index(current_item(btns_menu));
+	switch (index) {
+	case 0:
+		current_btn = BTN_SELECT;
+		break;
+	case 1:
+		current_btn = BTN_EXIT;
+		break;
+	case 2:
+		current_btn = BTN_HELP;
+		break;
+	case 3:
+		current_btn = BTN_INSTS;
+		break;
+	}
+}
+
+
+static void clean_items(void)
+{
+	int i;
+	for (i = 0; curses_menu_items[i]; i++)
+		free_item(curses_menu_items[i]);
+	bzero(curses_menu_items, sizeof(curses_menu_items));
+	bzero(k_menu_items, sizeof(k_menu_items));
+	bzero(hotkeys, sizeof(hotkeys));
+	items_num = 0;
+}
+
+/* return the index of the next hot item, or -1 if no such item exists */
+int get_next_hot(int c)
+{
+	static int hot_index;
+	static int hot_char;
+
+	if (c < 0 || c > 255 || hotkeys[c].count <= 0)
+		return -1;
+
+	if (hot_char == c) {
+		hot_index = (hot_index+1)%hotkeys[c].count;
+		return hotkeys[c].ptrs[hot_index];
+	} else {
+		hot_char = c;
+		hot_index = 0;
+		return hotkeys[c].ptrs[0];
+	}
+}
+
+/* can the char c be a hot key? no, if c is a common shortcut used elsewhere */
+int canbhot(char c)
+{
+	return isalnum(c) && c != 'm' && c != 'M' && c != 'h' && c != 'H' &&
+		c != 'n' && c != 'N' && c != 's' && c != '?';
+}
+
+/* check if str already contains a hot key. */
+int is_hot(int index)
+{
+	return k_menu_items[index].is_hot;
+}
+
+/* find the first possible hot key, and mark it.
+ * index is the index of the item in the menu
+ * return 0 on success*/
+int make_hot(char *dest, int len, const char *org, int index)
+{
+	int position = -1;
+	int i;
+	int tmp;
+	int c;
+	int org_len = strlen(org);
+
+	if (org == NULL || is_hot(index))
+		return 1;
+
+	/* make sure not to make hot keys out of markers.
+	 * find where to start looking for a hot key
+	 */
+	i = 0;
+	/* skip white space */
+	while (i < org_len && org[i] == ' ')
+		i++;
+	if (i == org_len)
+		return -1;
+	/* if encountering '(' or '<' or '[', find the match and look from there
+	 **/
+	if (org[i] == '[' || org[i] == '<' || org[i] == '(') {
+		i++;
+		for (; i < org_len; i++)
+			if (org[i] == ']' || org[i] == '>' || org[i] == ')')
+				break;
+	}
+	if (i == org_len)
+		return -1;
+	for (; i < org_len; i++) {
+		if (canbhot(org[i]) && org[i-1] != '<' && org[i-1] != '(') {
+			position = i;
+			break;
+		}
+	}
+	if (position == -1)
+		return 1;
+
+	/* ok, char at org[position] should be a hot key to this item */
+	c = tolower(org[position]);
+	tmp = hotkeys[c].count;
+	hotkeys[c].ptrs[tmp] = index;
+	hotkeys[c].count++;
+	/*
+	snprintf(dest, len, "%.*s(%c)%s", position, org, org[position],
+			&org[position+1]);
+	*/
+	/* make org[position] uppercase, and all leading letter small case */
+	strncpy(dest, org, len);
+	for (i=0; i<position; i++)
+		dest[i] = tolower(dest[i]);
+	dest[position] = toupper(dest[position]);
+	k_menu_items[index].is_hot = 1;
+	return 0;
+}
+
+/* Make a new item. Add a hotkey mark in the first possible letter.
+ * As ncurses does not allow any attributes inside menue item, we use mark the
+ * hot key as the first capitalized letter in the string */
+void item_make(void *usrptr, char tag, const char *fmt, ...)
+{
+	va_list ap;
+	char tmp_str[256];
+
+	if (items_num > MAX_MENU_ITEMS-1)
+		return;
+
+	bzero(&k_menu_items[items_num], sizeof(k_menu_items[0]));
+	k_menu_items[items_num].tag = tag;
+	k_menu_items[items_num].usrptr = usrptr;
+
+	va_start(ap, fmt);
+	vsnprintf(tmp_str, sizeof(tmp_str), fmt, ap);
+	va_end(ap);
+	if (make_hot(k_menu_items[items_num].str,
+		sizeof(k_menu_items[items_num].str), tmp_str, items_num) != 0)
+		strncpy(k_menu_items[items_num].str,
+			tmp_str,
+			sizeof(k_menu_items[items_num].str));
+
+	curses_menu_items[items_num] = new_item(
+			k_menu_items[items_num].str,
+			k_menu_items[items_num].str);
+	set_item_userptr(curses_menu_items[items_num],
+			&k_menu_items[items_num]);
+	items_num++;
+	curses_menu_items[items_num] = NULL;
+}
+
+/* very hackish. adds a string to the last item added */
+void item_add_str(const char *fmt, ...)
+{
+	va_list ap;
+	int index = items_num-1;
+	char new_str[256];
+	char tmp_str[256];
+
+	if (index < 0)
+		return;
+
+	va_start(ap, fmt);
+	vsnprintf(new_str, sizeof(new_str), fmt, ap);
+	va_end(ap);
+	snprintf(tmp_str, sizeof(tmp_str), "%s%s",
+		k_menu_items[index].str, new_str);
+	if (make_hot(k_menu_items[index].str,
+		sizeof(k_menu_items[index].str), tmp_str, index) != 0)
+		strncpy(k_menu_items[index].str,
+			tmp_str,
+			sizeof(k_menu_items[index].str));
+
+	free_item(curses_menu_items[index]);
+	curses_menu_items[index] = new_item(
+			k_menu_items[index].str,
+			k_menu_items[index].str);
+	set_item_userptr(curses_menu_items[index],
+			&k_menu_items[index]);
+}
+
+/* get the tag of the currently selected item */
+char item_tag(void)
+{
+	ITEM *cur;
+	struct mitem *mcur;
+
+	cur = current_item(curses_menu);
+	if (cur == NULL)
+		return 0;
+	mcur = (struct mitem *) item_userptr(cur);
+	return mcur->tag;
+}
+
+int curses_item_index(void)
+{
+	return	item_index(current_item(curses_menu));
+}
+
+void *item_data(void)
+{
+	ITEM *cur;
+	struct mitem *mcur;
+
+	cur = current_item(curses_menu);
+	mcur = (struct mitem *) item_userptr(cur);
+	return mcur->usrptr;
+
+}
+
+int item_is_tag(char tag)
+{
+	return item_tag() == tag;
+}
+
+static char filename[PATH_MAX+1];
+const char *set_config_filename(const char *config_filename)
+{
+	static char menu_backtitle[PATH_MAX+128];
+	int size;
+	struct symbol *sym;
+
+	sym = sym_lookup("KERNELVERSION", 0);
+	sym_calc_value(sym);
+	size = snprintf(menu_backtitle, sizeof(menu_backtitle),
+			_("%s - Linux Kernel v%s Configuration"),
+			config_filename, sym_get_string_value(sym));
+	if (size >= sizeof(menu_backtitle))
+		menu_backtitle[sizeof(menu_backtitle)-1] = '\0';
+
+	size = snprintf(filename, sizeof(filename), "%s", config_filename);
+	if (size >= sizeof(filename))
+		filename[sizeof(filename)-1] = '\0';
+	return menu_backtitle;
+}
+
+
+static void search_conf(void)
+{
+	struct symbol **sym_arr;
+	struct gstr res;
+	char dialog_input_result[100];
+	char *dialog_input;
+	int dres;
+again:
+	dres = dialog_inputbox(main_window,
+			_("Search Configuration Parameter"),
+		      _("Enter CONFIG_ (sub)string to search for "
+			"(with or without \"CONFIG\")"),
+		      "", dialog_input_result, 99);
+	switch (dres) {
+	case 0:
+		break;
+	case 1:
+		show_scroll_win(main_window,
+			_("Search Configuration"), search_help);
+		goto again;
+	default:
+		return;
+	}
+
+	/* strip CONFIG_ if necessary */
+	dialog_input = dialog_input_result;
+	if (strncasecmp(dialog_input_result, "CONFIG_", 7) == 0)
+		dialog_input += 7;
+
+	sym_arr = sym_re_search(dialog_input);
+	res = get_relations_str(sym_arr);
+	free(sym_arr);
+	show_scroll_win(main_window,
+		_("Search Results"), str_get(&res));
+	str_free(&res);
+}
+
+
+static void build_conf(struct menu *menu)
+{
+	struct symbol *sym;
+	struct property *prop;
+	struct menu *child;
+	int type, tmp, doint = 2;
+	tristate val;
+	char ch;
+
+
+	if (!menu_is_visible(menu))
+		return;
+
+	sym = menu->sym;
+	prop = menu->prompt;
+	if (!sym) {
+		if (prop && menu != current_menu) {
+			const char *prompt = menu_get_prompt(menu);
+			switch (prop->type) {
+			case P_MENU:
+				child_count++;
+				prompt = _(prompt);
+				if (single_menu_mode) {
+					item_make(menu, 'm',
+						"%s%*c%s",
+						menu->data ? "-->" : "++>",
+						indent + 1, ' ', prompt);
+				} else
+					item_make(menu, 'm',
+							"   %*c%s  --->",
+							indent + 1,
+							' ', prompt);
+
+				if (single_menu_mode && menu->data)
+					goto conf_childs;
+				return;
+			case P_COMMENT:
+				if (prompt) {
+					child_count++;
+					item_make(menu, ':',
+							"   %*c*** %s ***",
+							indent + 1, ' ',
+							_(prompt));
+				}
+				break;
+			default:
+				if (prompt) {
+					child_count++;
+					item_make(menu, ':', "---%*c%s",
+							indent + 1, ' ',
+							_(prompt));
+				}
+			}
+		} else
+			doint = 0;
+		goto conf_childs;
+	}
+
+	type = sym_get_type(sym);
+	if (sym_is_choice(sym)) {
+		struct symbol *def_sym = sym_get_choice_value(sym);
+		struct menu *def_menu = NULL;
+
+		child_count++;
+		for (child = menu->list; child; child = child->next) {
+			if (menu_is_visible(child) && child->sym == def_sym)
+				def_menu = child;
+		}
+
+		val = sym_get_tristate_value(sym);
+		if (sym_is_changable(sym)) {
+			switch (type) {
+			case S_BOOLEAN:
+				item_make(menu, 't', "[%c]",
+						val == no ? ' ' : '*');
+				break;
+			case S_TRISTATE:
+				switch (val) {
+				case yes:
+					ch = '*';
+					break;
+				case mod:
+					ch = 'M';
+					break;
+				default:
+					ch = ' ';
+					break;
+				}
+				item_make(menu, 't', "<%c>", ch);
+				break;
+			}
+		} else {
+			item_make(menu, def_menu ? 't' : ':', "   ");
+		}
+
+		item_add_str("%*c%s", indent + 1,
+				' ', _(menu_get_prompt(menu)));
+		if (val == yes) {
+			if (def_menu) {
+				item_add_str(" (%s)",
+					_(menu_get_prompt(def_menu)));
+				item_add_str("  --->");
+				if (def_menu->list) {
+					indent += 2;
+					build_conf(def_menu);
+					indent -= 2;
+				}
+			}
+			return;
+		}
+	} else {
+		if (menu == current_menu) {
+			item_make(menu, ':',
+				"---%*c%s", indent + 1,
+				' ', _(menu_get_prompt(menu)));
+			goto conf_childs;
+		}
+		child_count++;
+		val = sym_get_tristate_value(sym);
+		if (sym_is_choice_value(sym) && val == yes) {
+			item_make(menu, ':', "   ");
+		} else {
+			switch (type) {
+			case S_BOOLEAN:
+				if (sym_is_changable(sym))
+					item_make(menu, 't', "[%c]",
+						val == no ? ' ' : '*');
+				else
+					item_make(menu, 't', "-%c-",
+						val == no ? ' ' : '*');
+				break;
+			case S_TRISTATE:
+				switch (val) {
+				case yes:
+					ch = '*';
+					break;
+				case mod:
+					ch = 'M';
+					break;
+				default:
+					ch = ' ';
+					break;
+				}
+				if (sym_is_changable(sym)) {
+					if (sym->rev_dep.tri == mod)
+						item_make(menu,
+							't', "{%c}", ch);
+					else
+						item_make(menu,
+							't', "<%c>", ch);
+				} else
+					item_make(menu, 't', "-%c-", ch);
+				break;
+			default:
+				tmp = 2 + strlen(sym_get_string_value(sym));
+				item_make(menu, 's', "(%s)",
+					sym_get_string_value(sym));
+				tmp = indent - tmp + 4;
+				if (tmp < 0)
+					tmp = 0;
+				item_add_str("%*c%s%s", tmp, ' ',
+					_(menu_get_prompt(menu)),
+					(sym_has_value(sym) ||
+					 !sym_is_changable(sym)) ? "" :
+					   _(" (NEW)"));
+				goto conf_childs;
+			}
+		}
+		item_add_str("%*c%s%s", indent + 1, ' ',
+			_(menu_get_prompt(menu)),
+			(sym_has_value(sym) || !sym_is_changable(sym)) ?
+			  "" : _(" (NEW)"));
+		if (menu->prompt->type == P_MENU) {
+			item_add_str("  --->");
+			return;
+		}
+	}
+
+conf_childs:
+	indent += doint;
+	for (child = menu->list; child; child = child->next)
+		build_conf(child);
+	indent -= doint;
+}
+
+static void reset_menu(void)
+{
+	unpost_menu(curses_menu);
+	unpost_menu(btns_menu);
+	clean_items();
+}
+
+/* adjust the menu to show this item.
+ * prefer not to scroll the menu if possible*/
+static void center_item(int selected_index)
+{
+	int toprow;
+	int maxy, maxx;
+
+	scale_menu(curses_menu, &maxy, &maxx);
+	toprow = top_row(curses_menu);
+	if (selected_index >= toprow && selected_index < toprow+maxy) {
+		/* we can only move the selected item. no need to scroll */
+		set_current_item(curses_menu,
+			curses_menu_items[selected_index]);
+	} else {
+		toprow = max(selected_index-maxy/2, 0);
+		if (toprow >= item_count(curses_menu)-maxy)
+			toprow = item_count(curses_menu)-mwin_max_lines;
+		set_top_row(curses_menu, toprow);
+		set_current_item(curses_menu,
+			curses_menu_items[selected_index]);
+	}
+	post_menu(curses_menu);
+	refresh_all_windows(main_window);
+}
+
+/* this function assumes reset_menu has been called before */
+static void show_menu(const char *prompt, const char *instructions,
+		int selected_index)
+{
+	int maxx, maxy;
+	WINDOW *menu_window;
+
+	current_instructions = instructions;
+
+	wclear(main_window);
+
+	wattrset(main_window, attributes[MAIN_MENU_BOX]);
+	box(main_window, 0, 0);
+	wattrset(main_window, attributes[MAIN_MENU_HEADING]);
+	mvwprintw(main_window, 0, 3, " %s ", prompt);
+
+	set_menu_items(curses_menu, curses_menu_items);
+
+	/* position the menu at the middle of the screen */
+	scale_menu(curses_menu, &maxy, &maxx);
+	maxx = min(maxx, mwin_max_cols);
+	menu_window = derwin(main_window,
+			mwin_max_lines,
+			maxx,
+			2,
+			(COLS-maxx)/2);
+	keypad(menu_window, TRUE);
+	set_menu_win(curses_menu, menu_window);
+	set_menu_sub(curses_menu, menu_window);
+
+	/* must reassert this after changing items, otherwise returns to a
+	 * default of 16
+	 */
+	set_menu_format(curses_menu, mwin_max_lines, 1);
+	center_item(selected_index);
+
+	/* move lower menu btn to <select> */
+	set_current_item(btns_menu, btns_items[BTN_SELECT]);
+
+	/* Post the menu */
+	post_menu(curses_menu);
+	post_menu(btns_menu);
+	refresh_all_windows(main_window);
+}
+
+
+static void conf(struct menu *menu)
+{
+	char pattern[256];
+	struct menu *submenu;
+	const char *prompt = menu_get_prompt(menu);
+	struct symbol *sym;
+	struct menu *active_menu = NULL;
+	int res;
+	int current_index = 0;
+
+	bzero(pattern, sizeof(pattern));
+
+	while (1) {
+		reset_menu();
+		current_menu = menu;
+		build_conf(menu);
+		if (!child_count)
+			break;
+
+		if (menu == &rootmenu) {
+			item_make(NULL, 0, "--- ");
+			item_make(NULL, 'L',
+				_("    Load an Alternate Configuration File"));
+			item_make(NULL, 'S',
+				_("    Save an Alternate Configuration File"));
+		}
+
+		show_menu(prompt ? _(prompt) : _("Main Menu"),
+				_(menu_instructions),
+				current_index);
+		while ((res = wgetch(menu_win(curses_menu)))) {
+			switch (res) {
+			case KEY_DOWN:
+				menu_driver(curses_menu, REQ_DOWN_ITEM);
+				break;
+			case KEY_UP:
+				menu_driver(curses_menu, REQ_UP_ITEM);
+				break;
+			case KEY_LEFT:
+				menu_driver(btns_menu, REQ_LEFT_ITEM);
+				break;
+			case KEY_RIGHT:
+			case '\t':
+				menu_driver(btns_menu, REQ_RIGHT_ITEM);
+				break;
+			case KEY_NPAGE:
+				menu_driver(curses_menu, REQ_SCR_DPAGE);
+				break;
+			case KEY_PPAGE:
+				menu_driver(curses_menu, REQ_SCR_UPAGE);
+				break;
+			}
+			if (res == 10 || res == 27 ||  res == 'h' ||
+			    res == 32 || res == 'n' || res == 'y' ||
+			    res == 'm' || res == '/' || res == '?')
+				break;
+			else if (canbhot(res)) {
+				/* check for hot keys: */
+				int tmp = get_next_hot(res);
+				if (tmp != -1)
+					center_item(tmp);
+			}
+			refresh_all_windows(main_window);
+		}
+
+		/* update selected btn */
+		update_current_btn();
+		refresh_all_windows(main_window);
+
+		/* if ESC or btn_exit */
+		if (res == 27 || (res == 10 && current_btn == BTN_EXIT))
+			break;
+
+		/* remember location in the menu */
+		current_index = curses_item_index();
+
+		if (!item_tag())
+			continue;
+
+		submenu = (struct menu *) item_data();
+		active_menu = (struct menu *)item_data();
+		if (submenu)
+			sym = submenu->sym;
+		else
+			sym = NULL;
+
+		switch (res) {
+		case 10: /* ENTER WAS PRESSED */
+			/* check for btn help!! */
+			if (current_btn == BTN_HELP) {
+				if (sym)
+					show_help(submenu);
+				else
+					show_scroll_win(main_window,
+						_("README"),
+						_(nconf_readme));
+				break;
+			} else if (current_btn == BTN_INSTS) {
+				show_scroll_win(main_window,
+					_("Instructions"),
+					_(current_instructions));
+				break;
+			}
+
+			switch (item_tag()) {
+			case 'm':
+				if (single_menu_mode)
+					submenu->data =
+						(void *) (long) !submenu->data;
+				else
+					conf(submenu);
+				break;
+			case 't':
+				if (sym_is_choice(sym) &&
+					sym_get_tristate_value(sym) == yes)
+						conf_choice(submenu);
+				else if (submenu->prompt->type == P_MENU)
+					conf(submenu);
+				break;
+			case 's':
+				conf_string(submenu);
+				break;
+			case 'L':
+				conf_load();
+				break;
+			case 'S':
+				conf_save();
+				break;
+			}
+			break;
+		case 'h':
+		case '?':
+			if (sym)
+				show_help(submenu);
+			else
+				show_scroll_win(main_window,
+					_("README"), _(nconf_readme));
+			break;
+		case 'y':
+			if (item_is_tag('t')) {
+				if (sym_set_tristate_value(sym, yes))
+					break;
+				if (sym_set_tristate_value(sym, mod))
+					btn_dialog(main_window, setmod_text, 0);
+			}
+			break;
+		case 'n':
+			if (item_is_tag('t'))
+				sym_set_tristate_value(sym, no);
+			break;
+		case 'm':
+			if (item_is_tag('t'))
+				sym_set_tristate_value(sym, mod);
+			break;
+		case ' ':
+			if (item_is_tag('t'))
+				sym_toggle_tristate_value(sym);
+			else if (item_is_tag('m'))
+				conf(submenu);
+			break;
+		case '/':
+			search_conf();
+			break;
+		}
+	}
+}
+
+static void show_help(struct menu *menu)
+{
+	struct gstr help = str_new();
+	struct symbol *sym = menu->sym;
+
+	if (menu_has_help(menu)) {
+		if (sym->name) {
+			str_printf(&help, "CONFIG_%s:\n\n", sym->name);
+			str_append(&help, _(menu_get_help(menu)));
+			str_append(&help, "\n");
+		}
+	} else {
+		str_append(&help, nohelp_text);
+	}
+	get_symbol_str(&help, sym);
+	show_scroll_win(main_window, _(menu_get_prompt(menu)), str_get(&help));
+	str_free(&help);
+}
+
+static void conf_choice(struct menu *menu)
+{
+	const char *prompt = _(menu_get_prompt(menu));
+	struct menu *child;
+	struct symbol *active;
+	int selected_index = 0;
+	int res, i = 0;
+
+	active = sym_get_choice_value(menu->sym);
+	/* this is mostly duplicated from the conf() function. */
+	while (1) {
+		reset_menu();
+
+		for (i = 0, child = menu->list; child; child = child->next) {
+			if (!menu_is_visible(child))
+				continue;
+
+			if (child->sym == sym_get_choice_value(menu->sym))
+				item_make(child, ':', "<X> %s",
+					_(menu_get_prompt(child)));
+			else
+				item_make(child, ':', "    %s",
+					_(menu_get_prompt(child)));
+			if (child->sym == active)
+				selected_index = i;
+			i++;
+		}
+		show_menu(prompt ? _(prompt) : _("Choice Menu"),
+				_(radiolist_instructions),
+				selected_index);
+		while ((res = wgetch(menu_win(curses_menu)))) {
+			switch (res) {
+			case KEY_DOWN:
+				menu_driver(curses_menu, REQ_DOWN_ITEM);
+				break;
+			case KEY_UP:
+				menu_driver(curses_menu, REQ_UP_ITEM);
+				break;
+			case KEY_LEFT:
+				menu_driver(btns_menu, REQ_LEFT_ITEM);
+				break;
+			case KEY_RIGHT:
+			case '\t':
+				menu_driver(btns_menu, REQ_RIGHT_ITEM);
+				break;
+			case KEY_NPAGE:
+				menu_driver(curses_menu, REQ_SCR_DPAGE);
+				break;
+			case KEY_PPAGE:
+				menu_driver(curses_menu, REQ_SCR_UPAGE);
+				break;
+			}
+			if (res == 10 || res == 27 || res == 'h'
+				|| res == ' ' || res == 's' || res == '?')
+				break;
+			else if (canbhot(res)) {
+				/* check for hot keys: */
+				int tmp = get_next_hot(res);
+				if (tmp != -1)
+					center_item(tmp);
+			}
+			refresh_all_windows(main_window);
+		}
+		/* update selected btn */
+		update_current_btn();
+
+		/* if ESC or btn_exit */
+		if (res == 27 || (res == 10 && current_btn == BTN_EXIT))
+			return;
+
+		child = item_data();
+		switch (res) {
+		case ' ':
+		case 's':
+		case  10:
+			if (current_btn == BTN_HELP) {
+				show_help(child);
+				break;
+			} else if (current_btn == BTN_INSTS) {
+				show_scroll_win(main_window, _("Instructions"),
+						_(current_instructions));
+				break;
+			}
+			sym_set_tristate_value(child->sym, yes);
+			return;
+		case 'h':
+		case '?':
+			show_help(child);
+			active = child->sym;
+			break;
+		case KEY_EXIT:
+			return;
+		}
+	}
+}
+
+static void conf_string(struct menu *menu)
+{
+	const char *prompt = menu_get_prompt(menu);
+	char dialog_input_result[256];
+
+	while (1) {
+		int res;
+		const char *heading;
+
+		switch (sym_get_type(menu->sym)) {
+		case S_INT:
+			heading = _(inputbox_instructions_int);
+			break;
+		case S_HEX:
+			heading = _(inputbox_instructions_hex);
+			break;
+		case S_STRING:
+			heading = _(inputbox_instructions_string);
+			break;
+		default:
+			heading = _("Internal nconf error!");
+		}
+		res = dialog_inputbox(main_window,
+				prompt ? _(prompt) : _("Main Menu"),
+			      heading,
+			      sym_get_string_value(menu->sym),
+			      dialog_input_result,
+			      sizeof(dialog_input_result));
+		switch (res) {
+		case 0:
+			if (sym_set_string_value(menu->sym,
+				dialog_input_result))
+					return;
+			btn_dialog(main_window,
+				_("You have made an invalid entry."), 0);
+			break;
+		case 1:
+			show_help(menu);
+			break;
+		case KEY_EXIT:
+			return;
+		}
+	}
+}
+
+static void conf_load(void)
+{
+	char dialog_input_result[256];
+	while (1) {
+		int res;
+		res = dialog_inputbox(main_window,
+				NULL, load_config_text,
+				filename,
+				dialog_input_result,
+				sizeof(dialog_input_result));
+		switch (res) {
+		case 0:
+			if (!dialog_input_result[0])
+				return;
+			if (!conf_read(dialog_input_result)) {
+				set_config_filename(dialog_input_result);
+				sym_set_change_count(1);
+				return;
+			}
+			btn_dialog(main_window, _("File does not exist!"), 0);
+			break;
+		case 1:
+			show_scroll_win(main_window,
+				_("Load Alternate Configuration"),
+				load_config_help);
+			break;
+		case KEY_EXIT:
+			return;
+		}
+	}
+}
+
+static void conf_save(void)
+{
+	char dialog_input_result[256];
+	while (1) {
+		int res;
+		res = dialog_inputbox(main_window,
+				NULL, save_config_text,
+				filename,
+				dialog_input_result,
+				sizeof(dialog_input_result));
+		switch (res) {
+		case 0:
+			if (!dialog_input_result[0])
+				return;
+			if (!conf_write(dialog_input_result)) {
+				set_config_filename(dialog_input_result);
+				return;
+			}
+			btn_dialog(main_window, _("Can't create file! "
+				"Probably a nonexistent directory."), 0);
+			break;
+		case 1:
+			show_scroll_win(main_window,
+				_("Save Alternate Configuration"),
+				save_config_help);
+			break;
+		case KEY_EXIT:
+			return;
+		}
+	}
+}
+
+void setup_windows(void)
+{
+	int btn_lines, btn_cols;
+
+	if (main_window != NULL)
+		delwin(main_window);
+
+	/* set up the menu and menu window */
+	main_window = newwin(LINES-2, COLS-2, 2, 1);
+	keypad(main_window, TRUE);
+	mwin_max_lines = LINES-7;
+	mwin_max_cols = COLS-6;
+
+	scale_menu(btns_menu, &btn_lines, &btn_cols);
+	btn_cols = min(btn_cols, COLS-16);
+	btns_window = derwin(main_window,
+		1,
+		btn_cols,
+		LINES-4,
+		(COLS-2-btn_cols)/2);
+	set_menu_win(btns_menu, btns_window);
+	set_menu_sub(btns_menu, btns_window);
+
+	/* panels order is from bottom to top */
+	new_panel(main_window);
+}
+
+int main(int ac, char **av)
+{
+	char *mode;
+	const char *title;
+	int res;
+	int i;
+
+
+	setlocale(LC_ALL, "");
+	bindtextdomain(PACKAGE, LOCALEDIR);
+	textdomain(PACKAGE);
+
+	conf_parse(av[1]);
+	conf_read(NULL);
+
+	mode = getenv("NCONFIG_MODE");
+	if (mode) {
+		if (!strcasecmp(mode, "single_menu"))
+			single_menu_mode = 1;
+	}
+
+	/* Initialize curses */
+	initscr();
+	cbreak();
+	noecho();
+	raw();
+	keypad(stdscr, TRUE);
+	clear();
+	curs_set(0);
+
+	if (COLS < 60 || LINES < 20) {
+		endwin();
+		printf("Your terminal should have at "
+			"least 20 lines and 60 columns\n");
+		return 1;
+	}
+
+	/* set color theme */
+	set_colors();
+
+	notimeout(stdscr, TRUE);
+	/* notimeout does not seem to work!! */
+	ESCDELAY = 0;
+
+	title = set_config_filename(conf_get_configname());
+	print_in_middle(stdscr, 1, 0, COLS, title, attributes[MAIN_HEADING]);
+
+	/* set btns menu */
+	for (i = 0; i < BTN_MAX; i++)
+		btns_items[i] = new_item(btns[i], "");
+	btns_items[BTN_MAX] = NULL;
+	btns_menu = new_menu(btns_items);
+	set_menu_format(btns_menu, 1, BTN_MAX);
+	menu_opts_off(btns_menu, O_SHOWDESC);
+	menu_opts_on(btns_menu, O_SHOWMATCH);
+	menu_opts_on(btns_menu, O_ONEVALUE);
+	menu_opts_off(btns_menu, O_NONCYCLIC);
+	set_menu_mark(btns_menu, "");
+	set_menu_fore(btns_menu, attributes[BOTTOM_MENU_FORE]);
+	set_menu_back(btns_menu, attributes[BOTTOM_MENU_BACK]);
+
+	curses_menu = new_menu(curses_menu_items);
+	menu_opts_off(curses_menu, O_SHOWDESC);
+	menu_opts_on(curses_menu, O_SHOWMATCH);
+	menu_opts_on(curses_menu, O_ONEVALUE);
+	menu_opts_on(curses_menu, O_NONCYCLIC);
+	set_menu_mark(curses_menu, " ");
+	set_menu_fore(curses_menu, attributes[MAIN_MENU_FORE]);
+	set_menu_back(curses_menu, attributes[MAIN_MENU_BACK]);
+
+	setup_windows();
+
+	do {
+		conf(&rootmenu);
+		clear();
+		if (conf_get_changed())
+			res = btn_dialog(main_window,
+					_("Do you wish to save your "
+					     "new kernel configuration?\n"
+					     "<ESC><ESC> to continue."),
+					2,
+					"   <save>   ",
+					"<don't save>");
+		else
+			res = -1;
+	} while (res == KEY_EXIT);
+	unpost_menu(curses_menu);
+	unpost_menu(btns_menu);
+	free_menu(curses_menu);
+	free_menu(btns_menu);
+	delwin(main_window);
+	endwin();
+
+
+	switch (res) {
+	case 0:
+		if (conf_write(filename)) {
+			fprintf(stderr, _("\n\n"
+			"Error during writing of the kernel configuration.\n"
+			"Your kernel configuration changes were NOT saved."
+			"\n\n"));
+			return 1;
+		}
+	case -1:
+		printf(_("\n\n"
+		"*** End of Linux kernel configuration.\n"
+		"*** Execute 'make' to build the kernel or try 'make help'."
+		"\n\n"));
+		break;
+	default:
+		fprintf(stderr, _("\n\n"
+			"Your kernel configuration changes were NOT saved."
+			"\n\n"));
+	}
+
+	return 0;
+}
+
diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
new file mode 100644
index 0000000..dd39628
--- /dev/null
+++ b/scripts/kconfig/nconf.gui.c
@@ -0,0 +1,653 @@
+/*
+ * Copyright (C) 2008 Nir Tzachar <nir.tzachar@gmail.com?
+ * Released under the terms of the GNU GPL v2.0.
+ *
+ * Derived from menuconfig.
+ *
+ */
+#include "nconf.h"
+
+/* a list of all the different widgets we use */
+attributes_t attributes[ATTR_MAX+1] = {0};
+
+/* available colors:
+   COLOR_BLACK   0
+   COLOR_RED     1
+   COLOR_GREEN   2
+   COLOR_YELLOW  3
+   COLOR_BLUE    4
+   COLOR_MAGENTA 5
+   COLOR_CYAN    6
+   COLOR_WHITE   7
+   */
+void set_normal_colors(void)
+{
+	init_pair(NORMAL, COLOR_WHITE, COLOR_BLACK);
+	init_pair(MAIN_HEADING, COLOR_MAGENTA, COLOR_BLACK);
+
+	/* FORE is for the selected item */
+	init_pair(MAIN_MENU_FORE, COLOR_CYAN, COLOR_BLACK);
+	/* BACK for all the rest */
+	init_pair(MAIN_MENU_BACK, COLOR_CYAN, COLOR_BLACK);
+	init_pair(MAIN_MENU_HEADING, COLOR_GREEN, COLOR_BLACK);
+	init_pair(MAIN_MENU_BOX, COLOR_YELLOW, COLOR_BLACK);
+
+	init_pair(INSTS_WIN_TEXT, COLOR_BLUE, COLOR_BLACK);
+	init_pair(INSTS_WIN_HEADING, COLOR_GREEN, COLOR_BLACK);
+	init_pair(INSTS_WIN_BOX, COLOR_YELLOW, COLOR_BLACK);
+
+	init_pair(SCROLLWIN_TEXT, COLOR_WHITE, COLOR_BLACK);
+	init_pair(SCROLLWIN_HEADING, COLOR_GREEN, COLOR_BLACK);
+	init_pair(SCROLLWIN_BOX, COLOR_YELLOW, COLOR_BLACK);
+
+	init_pair(BOTTOM_MENU_FORE, COLOR_YELLOW, COLOR_BLACK);
+	init_pair(BOTTOM_MENU_BACK, COLOR_WHITE, COLOR_BLACK);
+
+	init_pair(DIALOG_TEXT, COLOR_RED, COLOR_BLACK);
+	init_pair(DIALOG_BOX, COLOR_YELLOW, COLOR_BLACK);
+	init_pair(DIALOG_MENU_FORE, COLOR_YELLOW, COLOR_BLACK);
+	init_pair(DIALOG_MENU_BACK, COLOR_WHITE, COLOR_BLACK);
+
+	init_pair(INPUT_BOX, COLOR_YELLOW, COLOR_BLACK);
+	init_pair(INPUT_HEADING, COLOR_GREEN, COLOR_BLACK);
+	init_pair(INPUT_TEXT, COLOR_RED, COLOR_BLACK);
+	init_pair(INPUT_FIELD, COLOR_BLUE, COLOR_BLACK);
+}
+
+void rgb_colors(void)
+{
+	int start_color = COLOR_BLACK+1;
+
+/* make a new color pair, given foureground and background rgb vals
+ * values for rgb are from 0 to 1000 */
+#define mkcolor(attr, fr, fg, fb, br, bg, bb) {\
+	init_color(start_color, fr, fg, fb);\
+	init_color(start_color+1, br, bg, bb);\
+	init_pair(attr, start_color, start_color+1); }
+
+	mkcolor(NORMAL, 1000, 0, 0, 0, 0, 0);
+	init_pair(MAIN_HEADING, COLOR_MAGENTA, COLOR_BLACK);
+
+	/* FORE is for the selected item */
+	init_pair(MAIN_MENU_FORE, COLOR_CYAN, COLOR_BLACK);
+	/* BACK for all the rest */
+	init_pair(MAIN_MENU_BACK, COLOR_CYAN, COLOR_BLACK);
+	init_pair(MAIN_MENU_HEADING, COLOR_GREEN, COLOR_BLACK);
+	init_pair(MAIN_MENU_BOX, COLOR_YELLOW, COLOR_BLACK);
+
+	init_pair(INSTS_WIN_TEXT, COLOR_BLUE, COLOR_BLACK);
+	init_pair(INSTS_WIN_HEADING, COLOR_GREEN, COLOR_BLACK);
+	init_pair(INSTS_WIN_BOX, COLOR_YELLOW, COLOR_BLACK);
+
+	init_pair(SCROLLWIN_TEXT, COLOR_RED, COLOR_BLACK);
+	init_pair(SCROLLWIN_HEADING, COLOR_GREEN, COLOR_BLACK);
+	init_pair(SCROLLWIN_BOX, COLOR_YELLOW, COLOR_BLACK);
+
+	init_pair(BOTTOM_MENU_FORE, COLOR_YELLOW, COLOR_BLACK);
+	init_pair(BOTTOM_MENU_BACK, COLOR_WHITE, COLOR_BLACK);
+
+	init_pair(DIALOG_TEXT, COLOR_RED, COLOR_BLACK);
+	init_pair(DIALOG_BOX, COLOR_YELLOW, COLOR_BLACK);
+	init_pair(DIALOG_MENU_FORE, COLOR_MAGENTA, COLOR_BLACK);
+	init_pair(DIALOG_MENU_BACK, COLOR_WHITE, COLOR_BLACK);
+
+	init_pair(INPUT_BOX, COLOR_YELLOW, COLOR_BLACK);
+	init_pair(INPUT_HEADING, COLOR_GREEN, COLOR_BLACK);
+	init_pair(INPUT_TEXT, COLOR_RED, COLOR_BLACK);
+	init_pair(INPUT_FIELD, COLOR_BLUE, COLOR_BLACK);
+
+}
+
+/* available attributes:
+   A_NORMAL        Normal display (no highlight)
+   A_STANDOUT      Best highlighting mode of the terminal.
+   A_UNDERLINE     Underlining
+   A_REVERSE       Reverse video
+   A_BLINK         Blinking
+   A_DIM           Half bright
+   A_BOLD          Extra bright or bold
+   A_PROTECT       Protected mode
+   A_INVIS         Invisible or blank mode
+   A_ALTCHARSET    Alternate character set
+   A_CHARTEXT      Bit-mask to extract a character
+   COLOR_PAIR(n)   Color-pair number n
+   */
+void normal_color_theme(void)
+{
+/* automatically add color... */
+#define mkattr(name, attr) { attributes[name] = attr | COLOR_PAIR(name); }
+	mkattr(NORMAL, NORMAL);
+	mkattr(MAIN_HEADING, A_BOLD | A_UNDERLINE);
+
+	mkattr(MAIN_MENU_FORE, A_STANDOUT);
+	mkattr(MAIN_MENU_BACK, A_NORMAL);
+	mkattr(MAIN_MENU_HEADING, A_BOLD);
+	mkattr(MAIN_MENU_BOX, A_NORMAL);
+
+	mkattr(INSTS_WIN_TEXT, A_NORMAL);
+	mkattr(INSTS_WIN_HEADING, A_BOLD);
+	mkattr(INSTS_WIN_BOX, A_NORMAL);
+
+	mkattr(SCROLLWIN_TEXT, A_NORMAL);
+	mkattr(SCROLLWIN_HEADING, A_BOLD);
+	mkattr(SCROLLWIN_BOX, A_BOLD);
+
+	mkattr(BOTTOM_MENU_FORE, A_STANDOUT);
+	mkattr(BOTTOM_MENU_BACK, A_BOLD);
+
+	mkattr(DIALOG_TEXT, A_BOLD);
+	mkattr(DIALOG_BOX, A_BOLD);
+	mkattr(DIALOG_MENU_FORE, A_STANDOUT);
+	mkattr(DIALOG_MENU_BACK, A_BOLD);
+
+	mkattr(INPUT_BOX, A_BOLD);
+	mkattr(INPUT_HEADING, A_BOLD);
+	mkattr(INPUT_TEXT, A_NORMAL);
+	mkattr(INPUT_FIELD, A_UNDERLINE);
+}
+
+void no_colors_theme(void)
+{
+/* automatically add highlight, no color */
+#define mkattrn(name, attr) { attributes[name] = attr; }
+
+	mkattrn(NORMAL, NORMAL);
+	mkattrn(MAIN_HEADING, A_BOLD | A_UNDERLINE);
+
+	mkattrn(MAIN_MENU_FORE, A_STANDOUT);
+	mkattrn(MAIN_MENU_BACK, A_NORMAL);
+	mkattrn(MAIN_MENU_HEADING, A_BOLD);
+	mkattrn(MAIN_MENU_BOX, A_NORMAL);
+
+	mkattrn(INSTS_WIN_TEXT, A_NORMAL);
+	mkattrn(INSTS_WIN_HEADING, A_BOLD);
+	mkattrn(INSTS_WIN_BOX, A_NORMAL);
+
+	mkattrn(SCROLLWIN_TEXT, A_NORMAL);
+	mkattrn(SCROLLWIN_HEADING, A_BOLD);
+	mkattrn(SCROLLWIN_BOX, A_BOLD);
+
+	mkattrn(BOTTOM_MENU_FORE, A_STANDOUT);
+	mkattrn(BOTTOM_MENU_BACK, A_BOLD);
+
+	mkattrn(DIALOG_TEXT, A_NORMAL);
+	mkattrn(DIALOG_BOX, A_BOLD);
+	mkattrn(DIALOG_MENU_FORE, A_STANDOUT);
+	mkattrn(DIALOG_MENU_BACK, A_BOLD);
+
+	mkattrn(INPUT_BOX, A_BOLD);
+	mkattrn(INPUT_HEADING, A_BOLD);
+	mkattrn(INPUT_TEXT, A_NORMAL);
+	mkattrn(INPUT_FIELD, A_UNDERLINE);
+}
+
+void set_colors()
+{
+	if (has_colors()) {
+		start_color();
+		if (can_change_color())
+			rgb_colors();
+		else
+			set_normal_colors();
+		normal_color_theme();
+	} else {
+		/* give deafults */
+		no_colors_theme();
+	}
+}
+
+
+/* this changes the windows attributes !!! */
+void print_in_middle(WINDOW *win,
+		int starty,
+		int startx,
+		int width,
+		const char *string,
+		chtype color)
+{	int length, x, y;
+	float temp;
+
+
+	if (win == NULL)
+		win = stdscr;
+	getyx(win, y, x);
+	if (startx != 0)
+		x = startx;
+	if (starty != 0)
+		y = starty;
+	if (width == 0)
+		width = 80;
+
+	length = strlen(string);
+	temp = (width - length) / 2;
+	x = startx + (int)temp;
+	wattrset(win, color);
+	mvwprintw(win, y, x, "%s", string);
+	refresh();
+}
+
+int get_line_no(const char *text)
+{
+	int i;
+	int total = 1;
+
+	if (!text)
+		return 0;
+
+	for (i = 0; text[i] != '\0'; i++)
+		if (text[i] == '\n')
+			total++;
+	return total;
+}
+
+const char *get_line(const char *text, int line_no)
+{
+	int i;
+	int lines = 0;
+
+	if (!text)
+		return 0;
+
+	for (i = 0; text[i] != '\0' && lines < line_no; i++)
+		if (text[i] == '\n')
+			lines++;
+	return text+i;
+}
+
+int get_line_length(const char *line)
+{
+	int res = 0;
+	while (*line != '\0' && *line != '\n') {
+		line++;
+		res++;
+	}
+	return res;
+}
+
+/* print all lines to the window. */
+void fill_window(WINDOW *win, const char *text)
+{
+	int x, y;
+	int total_lines = get_line_no(text);
+	int i;
+
+	getmaxyx(win, y, x);
+	/* do not go over end of line */
+	total_lines = min(total_lines, y);
+	for (i = 0; i < total_lines; i++) {
+		char tmp[x+10];
+		const char *line = get_line(text, i);
+		int len = get_line_length(line);
+		strncpy(tmp, line, min(len, x));
+		tmp[len] = '\0';
+		mvwprintw(win, i, 0, tmp);
+	}
+}
+
+/* get the message, and buttons.
+ * each button must be a char*
+ * return the selected button
+ *
+ * this dialog is used for 2 different things:
+ * 1) show a text box, no buttons.
+ * 2) show a dialog, with horizontal buttons
+ */
+int btn_dialog(WINDOW *main_window, const char *msg, int btn_num, ...)
+{
+	va_list ap;
+	char *btn;
+	int btns_width = 0;
+	int msg_lines = 0;
+	int msg_width = 0;
+	int total_width;
+	int win_rows = 0;
+	WINDOW *win;
+	WINDOW *msg_win;
+	WINDOW *menu_win;
+	PANEL *panel;
+	MENU *menu;
+	ITEM *btns[btn_num+1];
+	int i, x, y;
+	int res = -1;
+
+
+	va_start(ap, btn_num);
+	for (i = 0; i < btn_num; i++) {
+		btn = va_arg(ap, char *);
+		btns[i] = new_item(btn, "");
+		btns_width += strlen(btn)+1;
+	}
+	va_end(ap);
+	btns[btn_num] = NULL;
+
+	/* find the widest line of msg: */
+	msg_lines = get_line_no(msg);
+	for (i = 0; i < msg_lines; i++) {
+		const char *line = get_line(msg, i);
+		int len = get_line_length(line);
+		if (msg_width < len)
+			msg_width = len;
+	}
+
+	total_width = max(msg_width, btns_width);
+	/* place dialog in middle of screen */
+	y = (LINES-(msg_lines+4))/2;
+	x = (COLS-(total_width+4))/2;
+
+
+	/* create the windows */
+	if (btn_num > 0)
+		win_rows = msg_lines+4;
+	else
+		win_rows = msg_lines+2;
+
+	win = newwin(win_rows, total_width+4, y, x);
+	keypad(win, TRUE);
+	menu_win = derwin(win, 1, btns_width, win_rows-2,
+			1+(total_width+2-btns_width)/2);
+	menu = new_menu(btns);
+	msg_win = derwin(win, win_rows-2, msg_width, 1,
+			1+(total_width+2-msg_width)/2);
+
+	set_menu_fore(menu, attributes[DIALOG_MENU_FORE]);
+	set_menu_back(menu, attributes[DIALOG_MENU_BACK]);
+
+	wattrset(win, attributes[DIALOG_BOX]);
+	box(win, 0, 0);
+
+	/* print message */
+	wattrset(msg_win, attributes[DIALOG_TEXT]);
+	fill_window(msg_win, msg);
+
+	set_menu_win(menu, win);
+	set_menu_sub(menu, menu_win);
+	set_menu_format(menu, 1, btn_num);
+	menu_opts_off(menu, O_SHOWDESC);
+	menu_opts_on(menu, O_SHOWMATCH);
+	menu_opts_on(menu, O_ONEVALUE);
+	menu_opts_on(menu, O_NONCYCLIC);
+	set_menu_mark(menu, "");
+	post_menu(menu);
+
+
+	/* create panels */
+	panel = new_panel(win);
+
+	touchwin(win);
+	refresh_all_windows(main_window);
+	while ((res = wgetch(win))) {
+		switch (res) {
+		case KEY_LEFT:
+			menu_driver(menu, REQ_LEFT_ITEM);
+			break;
+		case KEY_RIGHT:
+			menu_driver(menu, REQ_RIGHT_ITEM);
+			break;
+		case 10: /* ENTER */
+			break;
+		case 27: /* ESCAPE */
+			break;
+		}
+		touchwin(win);
+		refresh_all_windows(main_window);
+
+		if (res == 10) {
+			res = item_index(current_item(menu));
+			break;
+		} else if (res == 27) {
+			res = -1;
+			break;
+		}
+	}
+
+	unpost_menu(menu);
+	free_menu(menu);
+	for (i = 0; i < btn_num; i++)
+		free_item(btns[i]);
+
+	del_panel(panel);
+	delwin(win);
+	return res;
+}
+
+int dialog_inputbox(WINDOW *main_window,
+		const char *title, const char *prompt,
+		const char *init, char *result, int result_len)
+{
+	int prompt_lines = 0;
+	int prompt_width = 0;
+	WINDOW *win;
+	WINDOW *prompt_win;
+	WINDOW *form_win;
+	PANEL *panel;
+	int i, x, y;
+	int res = -1;
+	int cursor_position = strlen(init);
+
+
+	/* find the widest line of msg: */
+	prompt_lines = get_line_no(prompt);
+	for (i = 0; i < prompt_lines; i++) {
+		const char *line = get_line(prompt, i);
+		int len = get_line_length(line);
+		prompt_width = max(prompt_width, len);
+	}
+
+	if (title)
+		prompt_width = max(prompt_width, strlen(title));
+
+	/* place dialog in middle of screen */
+	y = (LINES-(prompt_lines+4))/2;
+	x = (COLS-(prompt_width+4))/2;
+
+	strncpy(result, init, result_len);
+
+	/* create the windows */
+	win = newwin(prompt_lines+6, prompt_width+7, y, x);
+	prompt_win = derwin(win, prompt_lines+1, prompt_width, 2, 2);
+	form_win = derwin(win, 1, prompt_width, prompt_lines+3, 2);
+	keypad(form_win, TRUE);
+	wattrset(form_win, attributes[INPUT_FIELD]);
+
+	wattrset(win, attributes[INPUT_BOX]);
+	box(win, 0, 0);
+	wattrset(win, attributes[INPUT_HEADING]);
+	if (title)
+		mvwprintw(win, 0, 3, "%s", title);
+
+	/* print message */
+	wattrset(prompt_win, attributes[INPUT_TEXT]);
+	fill_window(prompt_win, prompt);
+
+	mvwprintw(form_win, 0, 0, "%*s", prompt_width, " ");
+	mvwprintw(form_win, 0, 0, "%s", result);
+
+	/* create panels */
+	panel = new_panel(win);
+
+	/* show the cursor */
+	curs_set(1);
+
+	touchwin(win);
+	refresh_all_windows(main_window);
+	while ((res = wgetch(form_win))) {
+		int len = strlen(result);
+		switch (res) {
+		case 10: /* ENTER */
+		case 27: /* ESCAPE */
+		case '?':
+			break;
+		case 127:
+		case KEY_BACKSPACE:
+			if (cursor_position > 0) {
+				memmove(&result[cursor_position-1],
+					&result[cursor_position],
+					len-cursor_position+1);
+				cursor_position--;
+			}
+			break;
+		case KEY_DC:
+			if (cursor_position >= 0 && cursor_position < len) {
+				memmove(&result[cursor_position],
+					&result[cursor_position+1],
+					len-cursor_position+1);
+			}
+			break;
+		case KEY_UP:
+		case KEY_RIGHT:
+			if (cursor_position < len &&
+			     cursor_position < min(result_len, prompt_width))
+				cursor_position++;
+			break;
+		case KEY_DOWN:
+		case KEY_LEFT:
+			if (cursor_position > 0)
+				cursor_position--;
+			break;
+		default:
+			if ((isgraph(res) || isspace(res)) &&
+			    len-2 < result_len) {
+				/* insert the char at the proper position */
+				memmove(&result[cursor_position+1],
+					&result[cursor_position],
+					len+1);
+				result[cursor_position] = res;
+				cursor_position++;
+			} else {
+				mvprintw(0, 0, "unknow key: %d\n", res);
+			}
+			break;
+		}
+		wmove(form_win, 0, 0);
+		wclrtoeol(form_win);
+		mvwprintw(form_win, 0, 0, "%*s", prompt_width, " ");
+		mvwprintw(form_win, 0, 0, "%s", result);
+		wmove(form_win, 0, cursor_position);
+		touchwin(win);
+		refresh_all_windows(main_window);
+
+		if (res == 10) {
+			res = 0;
+			break;
+		} else if (res == 27) {
+			res = KEY_EXIT;
+			break;
+		} else if (res == '?') {
+			res = 1;
+			break;
+		}
+	}
+
+	/* hide the cursor */
+	curs_set(0);
+	del_panel(panel);
+	delwin(win);
+	return res;
+}
+
+/* refresh all windows in the correct order */
+void refresh_all_windows(WINDOW *main_window)
+{
+	update_panels();
+	touchwin(main_window);
+	refresh();
+}
+
+/* layman's scrollble window... */
+void show_scroll_win(WINDOW *main_window,
+		const char *title, 
+		const char *text)
+{
+	int res;
+	int total_lines = get_line_no(text);
+	int x, y;
+	int start_x = 0, start_y = 0;
+	int text_lines = 0, text_cols = 0;
+	int total_cols = 0;
+	int win_cols = 0;
+	int win_lines = 0;
+	int i = 0;
+	WINDOW *win;
+	WINDOW *pad;
+	PANEL *panel;
+
+	/* find the widest line of msg: */
+	total_lines = get_line_no(text);
+	for (i = 0; i < total_lines; i++) {
+		const char *line = get_line(text, i);
+		int len = get_line_length(line);
+		total_cols = max(total_cols, len+2);
+	}
+
+	/* create the pad */
+	pad = newpad(total_lines+10, total_cols+10);
+	wattrset(pad, attributes[SCROLLWIN_TEXT]);
+	fill_window(pad, text);
+
+	win_lines = min(total_lines+2, LINES-2);
+	win_cols = min(total_cols+2, COLS-2);
+	text_lines = max(win_lines-2, 0);
+	text_cols = max(win_cols-2, 0);
+
+	/* place window in middle of screen */
+	y = (LINES-win_lines)/2;
+	x = (COLS-win_cols)/2;
+
+	win = newwin(win_lines, win_cols, y, x);
+	keypad(win, TRUE);
+	/* show the help in the help window, and show the help panel */
+	wattrset(win, attributes[SCROLLWIN_BOX]);
+	box(win, 0, 0);
+	wattrset(win, attributes[SCROLLWIN_HEADING]);
+	mvwprintw(win, 0, 3, " %s ", title);
+	panel = new_panel(win);
+
+	/* handle scrolling */
+	do {
+
+		copywin(pad, win, start_y, start_x, 2, 2, text_lines,
+				text_cols, 0);
+		wrefresh(win);
+
+		res = wgetch(win);
+		switch (res) {
+		case KEY_NPAGE:
+		case ' ':
+			start_y += text_lines-2;
+			break;
+		case KEY_PPAGE:
+			start_y -= text_lines+2;
+			break;
+		case KEY_DOWN:
+		case 'j':
+			start_y++;
+			break;
+		case KEY_UP:
+		case 'k':
+			start_y--;
+			break;
+		case KEY_LEFT:
+		case 'h':
+			start_x--;
+			break;
+		case KEY_RIGHT:
+		case 'l':
+			start_x++;
+			break;
+		}
+		if (res == 10 || res == 27)
+			break;
+		if (start_y < 0)
+			start_y = 0;
+		if (start_y >= total_lines-text_lines)
+			start_y = total_lines-text_lines;
+		if (start_x < 0)
+			start_x = 0;
+		if (start_x >= total_cols-text_cols)
+			start_x = total_cols-text_cols;
+	} while (res);
+
+	del_panel(panel);
+	delwin(win);
+	refresh_all_windows(main_window);
+}
diff --git a/scripts/kconfig/nconf.h b/scripts/kconfig/nconf.h
new file mode 100644
index 0000000..39ed395
--- /dev/null
+++ b/scripts/kconfig/nconf.h
@@ -0,0 +1,86 @@
+/*
+ * Copyright (C) 2008 Nir Tzachar <nir.tzachar@gmail.com?
+ * Released under the terms of the GNU GPL v2.0.
+ *
+ * Derived from menuconfig.
+ *
+ */
+
+#include <ctype.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdarg.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <locale.h>
+#include <curses.h>
+#include <menu.h>
+#include <panel.h>
+#include <form.h>
+
+#include <stdio.h>
+#include <time.h>
+#include <sys/time.h>
+
+#include "ncurses.h"
+
+#define max(a,b) ({\
+		typeof(a) _a = a;\
+		typeof(b) _b = b;\
+		_a > _b ? _a : _b; })
+
+#define min(a,b) ({\
+		typeof(a) _a = a;\
+		typeof(b) _b = b;\
+		_a < _b ? _a : _b; })
+
+typedef enum {
+	NORMAL = 1,
+	MAIN_HEADING,
+	MAIN_MENU_BOX,
+	MAIN_MENU_FORE,
+	MAIN_MENU_BACK,
+	MAIN_MENU_HEADING,
+	INSTS_WIN_BOX,
+	INSTS_WIN_HEADING,
+	INSTS_WIN_TEXT,
+	SCROLLWIN_TEXT,
+	SCROLLWIN_HEADING,
+	SCROLLWIN_BOX,
+	BOTTOM_MENU_FORE,
+	BOTTOM_MENU_BACK,
+	DIALOG_TEXT,
+	DIALOG_MENU_FORE,
+	DIALOG_MENU_BACK,
+	DIALOG_BOX,
+	INPUT_BOX,
+	INPUT_HEADING,
+	INPUT_TEXT,
+	INPUT_FIELD,
+	ATTR_MAX
+} attributes_t;
+extern attributes_t attributes[];
+
+void set_colors(void);
+
+/* this changes the windows attributes !!! */
+void print_in_middle(WINDOW *win,
+	int starty,
+	int startx,
+	int width,
+	const char *string,
+	chtype color);
+int get_line_length(const char *line);
+int get_line_no(const char *text);
+const char *get_line(const char *text, int line_no);
+void fill_window(WINDOW *win, const char *text);
+int btn_dialog(WINDOW *main_window, const char *msg, int btn_num, ...);
+int dialog_inputbox(WINDOW *main_window,
+	const char *title, const char *prompt,
+	const char *init, char *result, int result_len);
+void refresh_all_windows(WINDOW *main_window);
+void show_scroll_win(WINDOW *main_window,
+	const char *title, 
+	const char *text);
diff --git a/scripts/kconfig/shared.c b/scripts/kconfig/shared.c
new file mode 100644
index 0000000..b4f3f4b
--- /dev/null
+++ b/scripts/kconfig/shared.c
@@ -0,0 +1,82 @@
+/*
+ * Copyright (C) 2008 Nir Tzachar <nir.tzachar@gmail.com?
+ * Released under the terms of the GNU GPL v2.0.
+ *
+ * Derived from menuconfig.
+ *
+ */
+
+#include "shared.h"
+
+void get_prompt_str(struct gstr *r, struct property *prop)
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
+		                                    sym_get_string_value(sym));
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
+struct gstr get_relations_str(struct symbol **sym_arr)
+{
+	struct symbol *sym;
+	struct gstr res = str_new();
+	int i;
+
+	for (i = 0; sym_arr && (sym = sym_arr[i]); i++)
+		get_symbol_str(&res, sym);
+	if (!i)
+		str_append(&res, _("No matches found.\n"));
+	return res;
+}
diff --git a/scripts/kconfig/shared.h b/scripts/kconfig/shared.h
new file mode 100644
index 0000000..935dcaa
--- /dev/null
+++ b/scripts/kconfig/shared.h
@@ -0,0 +1,13 @@
+/*
+ * Copyright (C) 2008 Nir Tzachar <nir.tzachar@gmail.com?
+ * Released under the terms of the GNU GPL v2.0.
+ *
+ * Derived from menuconfig.
+ *
+ */
+#define LKC_DIRECT_LINK
+#include "lkc.h"
+
+void get_prompt_str(struct gstr *r, struct property *prop);
+void get_symbol_str(struct gstr *r, struct symbol *sym);
+struct gstr get_relations_str(struct symbol **sym_arr);
diff --git a/scripts/kconfig/zconf.tab.c_shipped b/scripts/kconfig/zconf.tab.c_shipped
index 95df833..ef5b369 100644
--- a/scripts/kconfig/zconf.tab.c_shipped
+++ b/scripts/kconfig/zconf.tab.c_shipped
@@ -2255,7 +2255,7 @@ void conf_parse(const char *name)
 	zconf_initscan(name);
 
 	sym_init();
-	menu_init();
+	_menu_init();
 	modules_sym = sym_lookup(NULL, 0);
 	modules_sym->type = S_BOOLEAN;
 	modules_sym->flags |= SYMBOL_AUTO;
diff --git a/scripts/kconfig/zconf.y b/scripts/kconfig/zconf.y
index 9710b82..cbb72fd 100644
--- a/scripts/kconfig/zconf.y
+++ b/scripts/kconfig/zconf.y
@@ -472,7 +472,7 @@ void conf_parse(const char *name)
 	zconf_initscan(name);
 
 	sym_init();
-	menu_init();
+	_menu_init();
 	modules_sym = sym_lookup(NULL, 0);
 	modules_sym->type = S_BOOLEAN;
 	modules_sym->flags |= SYMBOL_AUTO;
-- 
1.5.6.4

