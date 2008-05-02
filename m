Return-Path: <linux-kernel-owner+w=401wt.eu-S937223AbYEBUuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937223AbYEBUuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936707AbYEBUsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:48:51 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46398 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763758AbYEBUso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:48:44 -0400
From: sam@ravnborg.org
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: Sam Ravnborg <sam@uranus.ravnborg.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] kconfig: add support for K=file
Date: Fri,  2 May 2008 22:49:14 +0200
Message-Id: <1209761358-6579-1-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080502204729.GA6534@uranus.ravnborg.org>
References: <20080502204729.GA6534@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@uranus.ravnborg.org>

Input file to all*config, randconfig and defconfig can
be specified using the environment variable 'K'.
It is expected to be used like this:

make K=my_config alldefconfig

This replaces the KCONFIL_ALLCONFIG support
and the input files named: all*.config

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/Makefile |   31 ++---
 scripts/kconfig/aconf.c  |  316 ++++++++++++++++++++++++++++++++++++++++++++++
 scripts/kconfig/aconf.sh |   30 +++++
 3 files changed, 360 insertions(+), 17 deletions(-)
 create mode 100644 scripts/kconfig/aconf.c
 create mode 100755 scripts/kconfig/aconf.sh

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index fa1a7d5..3e560a4 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -47,30 +47,25 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	$(Q)rm -f arch/um/Kconfig.arch
 	$(Q)rm -f $(obj)/config.pot
 
-PHONY += randconfig allyesconfig allnoconfig allmodconfig defconfig
+aconf-targets := allnoconfig allyesconfig allmodconfig alldefconfig randconfig
+PHONY += $(aconf-targets) defconfig
 
-randconfig: $(obj)/conf
-	$< -r $(Kconfig)
+$(aconf-targets): $(src)/aconf.sh $(obj)/aconf
+	$(Q)$(CONFIG_SHELL) $< $@ $(Kconfig)
 
-allyesconfig: $(obj)/conf
-	$< -y $(Kconfig)
+%_defconfig: $(src)/aconf.sh $(obj)/aconf
+	$(Q)K=arch/$(SRCARCH)/configs/$@ \
+	$(CONFIG_SHELL) $< alldefconfig $(Kconfig)
 
-allnoconfig: $(obj)/conf
-	$< -n $(Kconfig)
-
-allmodconfig: $(obj)/conf
-	$< -m $(Kconfig)
-
-defconfig: $(obj)/conf
 ifeq ($(KBUILD_DEFCONFIG),)
+defconfig: $(obj)/conf
 	$< -d $(Kconfig)
 else
-	@echo "*** Default configuration is based on '$(KBUILD_DEFCONFIG)'"
-	$(Q)$< -D arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG) $(Kconfig)
+defconfig: $(src)/aconf.sh $(obj)/aconf
+	$(Q)K=arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG) \
+	$(CONFIG_SHELL) $< alldefconfig $(Kconfig)
 endif
 
-%_defconfig: $(obj)/conf
-	$(Q)$< -D arch/$(SRCARCH)/configs/$@ $(Kconfig)
 
 # Help text used by make help
 help:
@@ -100,6 +95,7 @@ HOST_EXTRACFLAGS += -DLOCALE
 # ===========================================================================
 # Shared Makefile for the various kconfig executables:
 # conf:	  Used for defconfig, oldconfig and related targets
+# aconf:  Generate simple configurations (all*config, etc)
 # mconf:  Used for the mconfig target.
 #         Utilizes the lxdialog package
 # qconf:  Used for the xconfig target
@@ -112,10 +108,11 @@ lxdialog := lxdialog/checklist.o lxdialog/util.o lxdialog/inputbox.o
 lxdialog += lxdialog/textbox.o lxdialog/yesno.o lxdialog/menubox.o
 
 conf-objs	:= conf.o  zconf.tab.o
+aconf-objs	:= aconf.o zconf.tab.o
 mconf-objs	:= mconf.o zconf.tab.o $(lxdialog)
 kxgettext-objs	:= kxgettext.o zconf.tab.o
 
-hostprogs-y := conf qconf gconf kxgettext
+hostprogs-y := conf aconf qconf gconf kxgettext
 
 ifeq ($(MAKECMDGOALS),menuconfig)
 	hostprogs-y += mconf
diff --git a/scripts/kconfig/aconf.c b/scripts/kconfig/aconf.c
new file mode 100644
index 0000000..db3df0f
--- /dev/null
+++ b/scripts/kconfig/aconf.c
@@ -0,0 +1,316 @@
+/*
+ * Copyright (C) 2002 Roman Zippel <zippel@linux-m68k.org>
+ * Copyright (C) 2008 Sam Ravnborg <sam@ravnborg.org>
+ * Released under the terms of the GNU GPL v2.0.
+ */
+
+/*
+ * Generate the automated configs
+ */
+
+#include <locale.h>
+#include <ctype.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+#include <unistd.h>
+#include <sys/stat.h>
+
+#define LKC_DIRECT_LINK
+#include "lkc.h"
+
+static void check_conf(struct menu *menu);
+static void conf(struct menu *menu);
+
+enum {
+	set_unknown,
+	set_default,
+	set_yes,
+	set_mod,
+	set_no,
+	set_random
+} default_value = set_unknown;
+
+
+static int conf_cnt;
+static struct menu *rootEntry;
+
+/* Set strig value - it this a nop as it looks like? */
+static void conf_string(struct menu *menu)
+{
+	struct symbol *sym = menu->sym;
+	const char *def;
+
+
+	if (!sym_is_changable(sym))
+		return;
+
+	if (sym_has_value(sym) && (default_value != set_default))
+		return;
+
+	def = sym_get_string_value(sym);
+	if (def)
+		sym_set_string_value(sym, def);
+}
+
+static void conf_sym(struct menu *menu)
+{
+	struct symbol *sym = menu->sym;
+	int type;
+	tristate val;
+
+	if (!sym_is_changable(sym))
+		return;
+
+	if (sym_has_value(sym) && (default_value != set_default))
+		return;
+
+	type = sym_get_type(sym);
+	switch (default_value) {
+	case set_yes:
+		if (sym_tristate_within_range(sym, yes)) {
+			sym_set_tristate_value(sym, yes);
+			break;
+		}
+	/* fallthrough */
+	case set_mod:
+		if (type == S_TRISTATE) {
+			if (sym_tristate_within_range(sym, mod)) {
+				sym_set_tristate_value(sym, mod);
+				break;
+			}
+		} else if (sym_tristate_within_range(sym, yes)) {
+			sym_set_tristate_value(sym, yes);
+			break;
+		}
+	/* fallthrough */
+	case set_no:
+		if (sym_tristate_within_range(sym, no)) {
+			sym_set_tristate_value(sym, no);
+			break;
+		}
+	/* fallthrough */
+	case set_random:
+		 do {
+			val = (tristate)(rand() % 3);
+		} while (!sym_tristate_within_range(sym, val));
+		switch (val) {
+		case no:  sym_set_tristate_value(sym, no); break;
+		case mod: sym_set_tristate_value(sym, mod); break;
+		case yes: sym_set_tristate_value(sym, yes); break;
+		}
+		break;
+	case set_default:
+		sym_set_tristate_value(sym, sym_get_tristate_value(sym));
+		break;
+	/* silence gcc warning */
+	case set_unknown:
+		break;
+	}
+}
+
+static void conf_choice(struct menu *menu)
+{
+	struct symbol *sym, *def_sym;
+	struct menu *child;
+	int type;
+	bool is_new;
+	int cnt, def;
+
+	sym = menu->sym;
+	type = sym_get_type(sym);
+	is_new = !sym_has_value(sym);
+	if (sym_is_changable(sym)) {
+		conf_sym(menu);
+		sym_calc_value(sym);
+	}
+	if (sym_get_tristate_value(sym) != yes)
+		return;
+	def_sym = sym_get_choice_value(sym);
+	cnt = def = 0;
+	for (child = menu->list; child; child = child->next) {
+		if (!child->sym || !menu_is_visible(child))
+			continue;
+		cnt++;
+		if (child->sym == def_sym)
+			def = cnt;
+	}
+	if (cnt == 1)
+		goto conf_childs;
+
+	switch (default_value) {
+	case set_random:
+		if (is_new)
+			def = (rand() % cnt) + 1;
+	/* fallthrough */
+	case set_default:
+	case set_yes:
+	case set_mod:
+	case set_no:
+		cnt = def;
+		break;
+	/* silence gcc warning */
+	case set_unknown:
+		break;
+	}
+
+conf_childs:
+	for (child = menu->list; child; child = child->next) {
+		if (!child->sym || !menu_is_visible(child))
+			continue;
+		if (!--cnt)
+			break;
+	}
+	sym_set_choice_value(sym, child->sym);
+	for (child = child->list; child; child = child->next)
+		conf(child);
+}
+
+
+static void conf(struct menu *menu)
+{
+	struct symbol *sym;
+	struct property *prop;
+	struct menu *child;
+
+	if (!menu_is_visible(menu))
+		return;
+
+	sym = menu->sym;
+	prop = menu->prompt;
+	if (prop && prop->type == P_MENU) {
+		if (menu != rootEntry) {
+			check_conf(menu);
+			return;
+		}
+	}
+
+	if (!sym)
+		goto conf_childs;
+
+	if (sym_is_choice(sym)) {
+		conf_choice(menu);
+		if (sym->curr.tri != mod)
+			return;
+		goto conf_childs;
+	}
+
+	switch (sym->type) {
+	case S_INT:
+	case S_HEX:
+	case S_STRING:
+		conf_string(menu);
+		break;
+	default:
+		conf_sym(menu);
+		break;
+	}
+
+conf_childs:
+	for (child = menu->list; child; child = child->next)
+		conf(child);
+}
+
+static void check_conf(struct menu *menu)
+{
+	struct symbol *sym;
+	struct menu *child;
+
+	if (!menu_is_visible(menu))
+		return;
+
+	sym = menu->sym;
+	if (sym && !sym_has_value(sym)) {
+		if (sym_is_changable(sym) ||
+		    (sym_is_choice(sym) &&
+		     sym_get_tristate_value(sym) == yes)) {
+			conf_cnt++;
+			rootEntry = menu_get_parent_menu(menu);
+			conf(rootEntry);
+		}
+	}
+
+	for (child = menu->list; child; child = child->next)
+		check_conf(child);
+}
+
+int main(int ac, char **av)
+{
+	int opt;
+	char *config_file = NULL;
+	struct stat tmpstat;
+
+	setlocale(LC_ALL, "");
+	bindtextdomain(PACKAGE, LOCALEDIR);
+	textdomain(PACKAGE);
+
+	while ((opt = getopt(ac, av, "dnmyrhi:")) != -1) {
+		switch (opt) {
+		case 'd':
+			default_value = set_default;
+			break;
+		case 'n':
+			default_value = set_no;
+			break;
+		case 'm':
+			default_value = set_mod;
+			break;
+		case 'y':
+			default_value = set_yes;
+			break;
+		case 'r':
+			default_value = set_random;
+			srand(time(NULL));
+			break;
+		case 'i':
+			config_file = optarg;
+			break;
+		case 'h':
+			printf(_("See README for usage info\n"));
+			exit(0);
+			break;
+		default:
+			fprintf(stderr, _("See README for usage info\n"));
+			exit(1);
+		}
+	}
+	if (ac == optind) {
+		fprintf(stderr, _("%s: Kconfig file missing\n"), av[0]);
+		exit(1);
+	}
+	if (default_value == set_unknown) {
+		fprintf(stderr,
+		        _("%s: default value missing. "
+		        "You must use one of: -{d,n,m,y,r}\n"), av[0]);
+		exit(1);
+	}
+	conf_parse(av[optind]);
+	/* debug: zconfdump(stdout); */
+	if (config_file && stat(config_file, &tmpstat)) {
+		fprintf(stderr, _("%s: failed to open %s\n"),
+		        av[0], config_file);
+		exit(1);
+	}
+	if (config_file && conf_read_simple(config_file, S_DEF_USER)) {
+		fprintf(stderr, _("%s: failed to read %s\n"),
+		        av[0], config_file);
+		exit(1);
+	}
+	if (config_file) {
+		printf(_("# configuration is based on '%s'\n"), config_file);
+	}
+	/* generate the config */
+	do {
+		conf_cnt = 0;
+		check_conf(&rootmenu);
+	} while (conf_cnt);
+	/* write out the config */
+	if (conf_write(NULL) || conf_write_autoconf()) {
+		fprintf(stderr,
+		        _("%s: error during write of the configuration.\n"),
+		        av[0]);
+		exit(1);
+	}
+	return 0;
+}
diff --git a/scripts/kconfig/aconf.sh b/scripts/kconfig/aconf.sh
new file mode 100755
index 0000000..c46a868
--- /dev/null
+++ b/scripts/kconfig/aconf.sh
@@ -0,0 +1,30 @@
+#!/bin/sh
+set -e
+aconf=scripts/kconfig/aconf
+# Find input file
+if [ ! -z $K ]; then
+	config_file="-i $K";
+fi
+
+case "$1" in
+	"allnoconfig")
+		$aconf -n $config_file $2
+		;;
+	"allyesconfig")
+		$aconf -y $config_file $2
+		;;
+	"allmodconfig")
+		$aconf -m $config_file $2
+		;;
+	"alldefconfig")
+		$aconf -d $config_file $2
+		;;
+	"randconfig")
+		$aconf -r $config_file $2
+		;;
+	*)
+		echo "$0: unknow command $1"
+		exit 1
+	;;
+esac
+
-- 
1.5.4.1.143.ge7e51

