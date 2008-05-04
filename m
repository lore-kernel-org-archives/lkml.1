Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbYEDS6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbYEDS6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 14:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbYEDS6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 14:58:46 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36327 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbYEDS6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 14:58:44 -0400
Date: Sun, 4 May 2008 20:59:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH 1/2] kconfig: introduce K= support
Message-ID: <20080504185918.GB23063@uranus.ravnborg.org>
References: <20080502204729.GA6534@uranus.ravnborg.org> <20080504185737.GA23063@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080504185737.GA23063@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9122065d7fe0c8a9823794e91b16b2493122df80 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 4 May 2008 20:32:11 +0200
Subject: [PATCH] kconfig: introduce K= support

The base configuration can now be specified for
the targets: randconfig, all*config using following syntax:

   make K=base-config allnoconfig

The configuration will be based on the file base-config.

Also add a new target: alldefconfig
   alldefconfig will set all values to default vaules.

Make defconfig has changed such that it only searches
KBUILD_DEFCONFIG or arch/$ARCH/defconfig for the
baseconfig.

The verbose output generated as part of an
randconfig, all*config build has been dropped.

To implement this a new program 'aconf' is used which
is based on conf.c.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 README                     |   28 ++--
 scripts/kconfig/.gitignore |    1 +
 scripts/kconfig/Makefile   |   72 ++++++-----
 scripts/kconfig/aconf.c    |  317 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 374 insertions(+), 44 deletions(-)
 create mode 100644 scripts/kconfig/aconf.c

diff --git a/README b/README
index 159912c..f31f19b 100644
--- a/README
+++ b/README
@@ -171,11 +171,9 @@ CONFIGURING the kernel:
 	"make oldconfig"   Default all questions based on the contents of
 			   your existing ./.config file and asking about
 			   new config symbols.
-	"make silentoldconfig"
-			   Like above, but avoids cluttering the screen
-			   with questions already answered.
-	"make defconfig"   Create a ./.config file by using the default
-			   symbol values from arch/$ARCH/defconfig.
+	"make defconfig"   Create a ./.config file by using the base
+			   configuration found in the file specified by
+			   the environment variable KBUILD_DEFCONFIG.
 	"make allyesconfig"
 			   Create a ./.config file by setting symbol
 			   values to 'y' as much as possible.
@@ -184,17 +182,21 @@ CONFIGURING the kernel:
 			   values to 'm' as much as possible.
 	"make allnoconfig" Create a ./.config file by setting symbol
 			   values to 'n' as much as possible.
+	"make alldefconfig"
+			   Create a configuration with default values.
 	"make randconfig"  Create a ./.config file by setting symbol
 			   values to random values.
 
-   The allyesconfig/allmodconfig/allnoconfig/randconfig variants can
-   also use the environment variable KCONFIG_ALLCONFIG to specify a
-   filename that contains config options that the user requires to be
-   set to a specific value.  If KCONFIG_ALLCONFIG=filename is not used,
-   "make *config" checks for a file named "all{yes/mod/no/random}.config"
-   for symbol values that are to be forced.  If this file is not found,
-   it checks for a file named "all.config" to contain forced values.
-   
+   The allyesconfig/allmodconfig/allnoconfig/alldefconfig/randconfig
+   variants can be tweaked using a base confguration that can be
+   set either using the syntax:
+
+	make K=base-config allnoconfig
+
+   Or using the environment variable KCONFIG_ALLCONFIG.
+   K= in the example is also used as an environment variable and an
+   assignment to K takes precendence over a KCONFIG_ALLCONFIG assignment.
+
 	NOTES on "make config":
 	- having unnecessary drivers will make the kernel bigger, and can
 	  under some circumstances lead to problems: probing for a
diff --git a/scripts/kconfig/.gitignore b/scripts/kconfig/.gitignore
index b49584c..ae664f9 100644
--- a/scripts/kconfig/.gitignore
+++ b/scripts/kconfig/.gitignore
@@ -13,6 +13,7 @@ lkc_defs.h
 # configuration programs
 #
 conf
+aconf
 mconf
 qconf
 gconf
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index fa1a7d5..70b329d 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -47,30 +47,37 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	$(Q)rm -f arch/um/Kconfig.arch
 	$(Q)rm -f $(obj)/config.pot
 
-PHONY += randconfig allyesconfig allnoconfig allmodconfig defconfig
+#####
+#
+# aconf support
+#
+aconf-targets := allnoconfig allyesconfig allmodconfig alldefconfig randconfig
+PHONY += $(aconf-targets) defconfig
+
+# Optional base file for aconf
+# K= have precedence over KCONFIG_ALLCONFIG
+aconf-file := $(if $(KCONFIG_ALLCONFIG),-b $(KCONFIG_ALLCONFIG))
+aconf-file := $(if $(K),-b $(K), $(aconf-file))
+$(aconf-targets): $(obj)/aconf
+	$< $@ $(aconf-file) $(Kconfig)
+
+# Targets named *_defconfig may be located in arch/.../configs/
+# but try current dir first and always fallback to current dir
+archdef = arch/$(SRCARCH)/configs/$@
+aconf-archdef = $(if $(wildcard $(archdef)),$(if $(wildcard $@),$@,$(archdef)),$@)
+%_defconfig: $(obj)/aconf
+	$< alldefconfig -b $(aconf-archdef) $(Kconfig)
+
+# An arch may use KBUILD_DEFCONFIG to specify defconfig file
+# fallback to arch/$ARCH/defconfig
+defconfig-file := $(if $(KBUILD_DEFCONFIG),            \
+        arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG),   \
+        arch/$(SRCARCH)/defconfig)
+defconfig-file := $(strip $(defconfig-file))
+
+defconfig: $(obj)/aconf
+	$< alldefconfig -b $(defconfig-file) $(Kconfig)
 
-randconfig: $(obj)/conf
-	$< -r $(Kconfig)
-
-allyesconfig: $(obj)/conf
-	$< -y $(Kconfig)
-
-allnoconfig: $(obj)/conf
-	$< -n $(Kconfig)
-
-allmodconfig: $(obj)/conf
-	$< -m $(Kconfig)
-
-defconfig: $(obj)/conf
-ifeq ($(KBUILD_DEFCONFIG),)
-	$< -d $(Kconfig)
-else
-	@echo "*** Default configuration is based on '$(KBUILD_DEFCONFIG)'"
-	$(Q)$< -D arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG) $(Kconfig)
-endif
-
-%_defconfig: $(obj)/conf
-	$(Q)$< -D arch/$(SRCARCH)/configs/$@ $(Kconfig)
 
 # Help text used by make help
 help:
@@ -78,13 +85,14 @@ help:
 	@echo  '  menuconfig	  - Update current config utilising a menu based program'
 	@echo  '  xconfig	  - Update current config utilising a QT based front-end'
 	@echo  '  gconfig	  - Update current config utilising a GTK based front-end'
-	@echo  '  oldconfig	  - Update current config utilising a provided .config as base'
-	@echo  '  silentoldconfig - Same as oldconfig, but quietly'
-	@echo  '  randconfig	  - New config with random answer to all options'
-	@echo  '  defconfig	  - New config with default answer to all options'
-	@echo  '  allmodconfig	  - New config selecting modules when possible'
-	@echo  '  allyesconfig	  - New config where all options are accepted with yes'
-	@echo  '  allnoconfig	  - New config where all options are answered with no'
+	@echo  '  oldconfig	  - Update current config utilising .config as base'
+	@echo  '  defconfig	  - New config based on arch specific base configuration'
+	@echo  '  randconfig	  - New config with random values for all symbols'
+	@echo  '  allnoconfig	  - New config where all values are set to no'
+	@echo  '  allyesconfig	  - New config where all values are set to yes'
+	@echo  '  allmodconfig	  - New config where all values are set to module'
+	@echo  '  alldefconfig	  - New config where all values has their default value'
+	@echo  '  For randconfig and all*config targets use K=file to specify a base configuration'
 
 # lxdialog stuff
 check-lxdialog  := $(srctree)/$(src)/lxdialog/check-lxdialog.sh
@@ -100,6 +108,7 @@ HOST_EXTRACFLAGS += -DLOCALE
 # ===========================================================================
 # Shared Makefile for the various kconfig executables:
 # conf:	  Used for defconfig, oldconfig and related targets
+# aconf:  Generate simple configurations (all*config, etc)
 # mconf:  Used for the mconfig target.
 #         Utilizes the lxdialog package
 # qconf:  Used for the xconfig target
@@ -112,10 +121,11 @@ lxdialog := lxdialog/checklist.o lxdialog/util.o lxdialog/inputbox.o
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
index 0000000..cf05861
--- /dev/null
+++ b/scripts/kconfig/aconf.c
@@ -0,0 +1,317 @@
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
+	set_default,
+	set_yes,
+	set_mod,
+	set_no,
+	set_random
+} default_value;
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
+static void usage(void)
+{
+	printf(_("usage: aconf COMMAND [-b config_file] Kconfig\n"));
+	printf("\n");
+	printf(_("The supported commands are:\n"));
+	printf(_("   allnoconfig  set as many values as possible to 'n'\n"));
+	printf(_("   allyesconfig set as many values as possible to 'y'\n"));
+	printf(_("   allmodconfig set as many values as possible to 'm'\n"));
+	printf(_("   alldefconfig set all vaues to their default value\n"));
+	printf(_("   randconfig   select a random value for all value\n"));
+	printf("\n");
+	printf(_("   -b file      optional base configuration\n"));
+	printf(_("   Kconfig      the kconfig configuration\n"));
+	printf("\n");
+	printf(_("   Output is stored in .config (if not overridden by KCONFIG_CONFIG)\n"));
+	printf("\n");
+}
+
+int main(int ac, char **av)
+{
+	char *config_file = NULL;
+	char *kconfig_file = NULL;
+	struct stat tmpstat;
+
+	setlocale(LC_ALL, "");
+	bindtextdomain(PACKAGE, LOCALEDIR);
+	textdomain(PACKAGE);
+
+	if (ac < 2) {
+		usage();
+		exit(1);
+	}
+	if (strcmp(av[1], "allnoconfig") == 0)
+		default_value = set_no;
+	else if (strcmp(av[1], "allyesconfig") == 0)
+		default_value = set_yes;
+	else if (strcmp(av[1], "allmodconfig") == 0)
+		default_value = set_mod;
+	else if (strcmp(av[1], "alldefconfig") == 0)
+		default_value = set_default;
+	else if (strcmp(av[1], "randconfig") == 0) {
+		default_value = set_random;
+		srand(time(NULL));
+	} else {
+		usage();
+		exit(1);
+	}
+	if (strcmp(av[2], "-b") == 0) {
+		config_file = av[3];
+		kconfig_file = av[4];
+	} else {
+		kconfig_file = av[2];
+	}
+	if (!kconfig_file) {
+		fprintf(stderr, _("%s: Kconfig file missing\n"), av[0]);
+		exit(1);
+	}
+	conf_parse(kconfig_file);
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
+		printf("#\n");
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
-- 
1.5.4.1.143.ge7e51

