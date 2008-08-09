Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbYHIF3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbYHIF3T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 01:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbYHIF3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 01:29:11 -0400
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:1113 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYHIF3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 01:29:08 -0400
Date: Sat, 9 Aug 2008 07:26:37 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Adrian Bunk <bunk@kernel.org>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: Kconfig no longer outputs a .config with freshly updated defconfigs
In-Reply-To: <20080805204332.GB5464@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0808090717140.6791@localhost.localdomain>
References: <1217693013.2328.22.camel@localhost.localdomain>
 <20080802192646.GR19682@cs181140183.pp.htv.fi> <20080803080019.GA13265@uranus.ravnborg.org>
 <20080803100732.GA7442@cs181140183.pp.htv.fi> <20080804210848.GA29902@uranus.ravnborg.org>
 <Pine.LNX.4.64.0808050435320.6791@localhost.localdomain>
 <20080805204332.GB5464@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 5 Aug 2008, Sam Ravnborg wrote:

> silentoldconfig now always update .config - and that a bug.
> I was too hasty ghere - sorry.
> Will fix it during the weekend.

I looked over it a bit more carefully and a few other things.
KCONFIG_NOSILENTUPDATE wasn't quite working anymore - it should only be 
checked during the kbuild config call.
Removing the warning in confdata.c had the side effect, that the change 
counter was incremented anymore.
To make things more explicit, I added a new syncconfig target and 
silentoldconfig and oldconfig are doing now the same. In conf.c it should 
also be more obvious now, what belongs to the user config update and the 
kbuild config update.

bye, Roman

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 Makefile                   |    2 
 scripts/kconfig/Makefile   |   11 ++-
 scripts/kconfig/conf.c     |  126 +++++++++++++++++++++------------------------
 scripts/kconfig/confdata.c |    8 ++
 4 files changed, 74 insertions(+), 73 deletions(-)

Index: linux-2.6/Makefile
===================================================================
--- linux-2.6.orig/Makefile
+++ linux-2.6/Makefile
@@ -481,7 +481,7 @@ $(KCONFIG_CONFIG) include/config/auto.co
 # if auto.conf.cmd is missing then we are probably in a cleaned tree so
 # we execute the config step to be sure to catch updated Kconfig files
 include/config/auto.conf: $(KCONFIG_CONFIG) include/config/auto.conf.cmd
-	$(Q)$(MAKE) -f $(srctree)/Makefile silentoldconfig
+	$(Q)$(MAKE) -f $(srctree)/Makefile syncconfig
 else
 # external modules needs include/linux/autoconf.h and include/config/auto.conf
 # but do not care if they are up-to-date. Use auto.conf to trigger the test
Index: linux-2.6/scripts/kconfig/Makefile
===================================================================
--- linux-2.6.orig/scripts/kconfig/Makefile
+++ linux-2.6/scripts/kconfig/Makefile
@@ -2,7 +2,7 @@
 # Kernel configuration targets
 # These targets are used from top-level makefile
 
-PHONY += oldconfig xconfig gconfig menuconfig config silentoldconfig update-po-config
+PHONY += oldconfig xconfig gconfig menuconfig config silentoldconfig syncconfig update-po-config
 
 Kconfig := arch/$(SRCARCH)/Kconfig
 
@@ -18,12 +18,15 @@ menuconfig: $(obj)/mconf
 config: $(obj)/conf
 	$< $(Kconfig)
 
-oldconfig: $(obj)/conf
-	$< -o $(Kconfig)
-
 silentoldconfig: $(obj)/conf
 	$< -s $(Kconfig)
 
+oldconfig: $(obj)/conf
+	$< -s $(Kconfig)
+
+syncconfig: $(obj)/conf
+	$< -k $(Kconfig)
+
 # Create new linux.pot file
 # Adjust charset to UTF-8 in .po file to accept UTF-8 in Kconfig files
 # The symlink is used to repair a deficiency in arch/um
Index: linux-2.6/scripts/kconfig/conf.c
===================================================================
--- linux-2.6.orig/scripts/kconfig/conf.c
+++ linux-2.6/scripts/kconfig/conf.c
@@ -32,6 +32,7 @@ char *defconfig_file;
 
 static int indent = 1;
 static int valid_stdin = 1;
+static int sync_kconfig;
 static int conf_cnt;
 static char line[128];
 static struct menu *rootEntry;
@@ -65,7 +66,7 @@ static void strip(char *str)
 
 static void check_stdin(void)
 {
-	if (!valid_stdin && input_mode == ask_silent) {
+	if (!valid_stdin) {
 		printf(_("aborted!\n\n"));
 		printf(_("Console input/output is redirected. "));
 		printf(_("Run 'make oldconfig' to update configuration.\n\n"));
@@ -427,43 +428,6 @@ static void check_conf(struct menu *menu
 		check_conf(child);
 }
 
-static void conf_do_update(void)
-{
-	/* Update until a loop caused no more changes */
-	do {
-		conf_cnt = 0;
-		check_conf(&rootmenu);
-	} while (conf_cnt);
-}
-
-static int conf_silent_update(void)
-{
-	const char *name;
-
-	if (conf_get_changed()) {
-		name = getenv("KCONFIG_NOSILENTUPDATE");
-		if (name && *name) {
-			fprintf(stderr,
-			_("\n*** Kernel configuration requires explicit update.\n\n"));
-			return 1;
-		}
-		conf_do_update();
-	}
-	return 0;
-}
-
-static int conf_update(void)
-{
-	rootEntry = &rootmenu;
-	conf(&rootmenu);
-	if (input_mode == ask_all) {
-		input_mode = ask_silent;
-		valid_stdin = 1;
-	}
-	conf_do_update();
-	return 0;
-}
-
 int main(int ac, char **av)
 {
 	int opt;
@@ -474,14 +438,13 @@ int main(int ac, char **av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	while ((opt = getopt(ac, av, "osdD:nmyrh")) != -1) {
+	while ((opt = getopt(ac, av, "osdD:nmyrhk")) != -1) {
 		switch (opt) {
 		case 'o':
 			input_mode = ask_new;
 			break;
 		case 's':
 			input_mode = ask_silent;
-			valid_stdin = isatty(0) && isatty(1) && isatty(2);
 			break;
 		case 'd':
 			input_mode = set_default;
@@ -507,6 +470,10 @@ int main(int ac, char **av)
 			printf(_("See README for usage info\n"));
 			exit(0);
 			break;
+		case 'k':
+			input_mode = ask_silent;
+			sync_kconfig = 1;
+			break;
 		default:
 			fprintf(stderr, _("See README for usage info\n"));
 			exit(1);
@@ -519,6 +486,19 @@ int main(int ac, char **av)
 	name = av[optind];
 	conf_parse(name);
 	//zconfdump(stdout);
+	if (sync_kconfig) {
+		if (stat(".config", &tmpstat)) {
+			fprintf(stderr, _("***\n"
+				"*** You have not yet configured your kernel!\n"
+				"*** (missing kernel .config file)\n"
+				"***\n"
+				"*** Please run some configurator (e.g. \"make oldconfig\" or\n"
+				"*** \"make menuconfig\" or \"make xconfig\").\n"
+				"***\n"));
+			exit(1);
+		}
+	}
+
 	switch (input_mode) {
 	case set_default:
 		if (!defconfig_file)
@@ -531,16 +511,6 @@ int main(int ac, char **av)
 		}
 		break;
 	case ask_silent:
-		if (stat(".config", &tmpstat)) {
-			printf(_("***\n"
-				"*** You have not yet configured your kernel!\n"
-				"*** (missing kernel .config file)\n"
-				"***\n"
-				"*** Please run some configurator (e.g. \"make oldconfig\" or\n"
-				"*** \"make menuconfig\" or \"make xconfig\").\n"
-				"***\n"));
-			exit(1);
-		}
 	case ask_all:
 	case ask_new:
 		conf_read(NULL);
@@ -569,6 +539,19 @@ int main(int ac, char **av)
 	default:
 		break;
 	}
+
+	if (sync_kconfig) {
+		if (conf_get_changed()) {
+			name = getenv("KCONFIG_NOSILENTUPDATE");
+			if (name && *name) {
+				fprintf(stderr,
+					_("\n*** Kernel configuration requires explicit update.\n\n"));
+				return 1;
+			}
+		}
+		valid_stdin = isatty(0) && isatty(1) && isatty(2);
+	}
+
 	switch (input_mode) {
 	case set_no:
 		conf_set_all_new_symbols(def_no);
@@ -585,27 +568,38 @@ int main(int ac, char **av)
 	case set_default:
 		conf_set_all_new_symbols(def_default);
 		break;
-	case ask_silent:
 	case ask_new:
-		if (conf_silent_update())
-			exit(1);
-		break;
 	case ask_all:
-		if (conf_update())
-			exit(1);
+		rootEntry = &rootmenu;
+		conf(&rootmenu);
+		input_mode = ask_silent;
+		/* fall through */
+	case ask_silent:
+		/* Update until a loop caused no more changes */
+		do {
+			conf_cnt = 0;
+			check_conf(&rootmenu);
+		} while (conf_cnt);
 		break;
 	}
 
-	if (conf_write(NULL)) {
-		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
-		exit(1);
-	}
-	/* ask_silent is used during the build so we shall update autoconf.
-	 * All other commands are only used to generate a config.
-	 */
-	if (input_mode == ask_silent && conf_write_autoconf()) {
-		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
-		return 1;
+	if (sync_kconfig) {
+		/* sync_kconfig is used during the build so we shall update autoconf.
+		 * All other commands are only used to generate a config.
+		 */
+		if (conf_get_changed() && conf_write(NULL)) {
+			fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
+			exit(1);
+		}
+		if (conf_write_autoconf()) {
+			fprintf(stderr, _("\n*** Error during update of the kernel configuration.\n\n"));
+			return 1;
+		}
+	} else {
+		if (conf_write(NULL)) {
+			fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
+			exit(1);
+		}
 	}
 	return 0;
 }
Index: linux-2.6/scripts/kconfig/confdata.c
===================================================================
--- linux-2.6.orig/scripts/kconfig/confdata.c
+++ linux-2.6/scripts/kconfig/confdata.c
@@ -222,8 +222,10 @@ load:
 				continue;
 			if (def == S_DEF_USER) {
 				sym = sym_find(line + 9);
-				if (!sym)
+				if (!sym) {
+					sym_add_change_count(1);
 					break;
+				}
 			} else {
 				sym = sym_lookup(line + 9, 0);
 				if (sym->type == S_UNKNOWN)
@@ -259,8 +261,10 @@ load:
 			}
 			if (def == S_DEF_USER) {
 				sym = sym_find(line + 7);
-				if (!sym)
+				if (!sym) {
+					sym_add_change_count(1);
 					break;
+				}
 			} else {
 				sym = sym_lookup(line + 7, 0);
 				if (sym->type == S_UNKNOWN)
