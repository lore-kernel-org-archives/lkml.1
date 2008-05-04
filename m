Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbYEDS70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbYEDS70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 14:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbYEDS7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 14:59:17 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36445 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbYEDS7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 14:59:15 -0400
Date: Sun, 4 May 2008 20:59:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH 2/2] kconfig: make oldconfig less chatty and clean up conf.c
Message-ID: <20080504185950.GC23063@uranus.ravnborg.org>
References: <20080502204729.GA6534@uranus.ravnborg.org> <20080504185737.GA23063@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080504185737.GA23063@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 48ff933e08c7c5b625a82ffdae5ece9c0f4e0a87 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 4 May 2008 20:50:14 +0200
Subject: [PATCH] kconfig: make oldconfig less chatty and clean up conf.c

Moving randconfg, all*config support to aconf.c
allowed conf.c to be cleaned up.
While cleaning up conf.c the chatty oldconfig mode
was killed and conf.c is now only used for two purposes:

make config:
	Interactively ask for each config option

make oldconfig
	Interactively ask for each new config option

We now check for valid stadin in both cases and this
may break a script here and there.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile                 |    2 +-
 scripts/kconfig/Makefile |    5 +-
 scripts/kconfig/conf.c   |  168 ++++------------------------------------------
 3 files changed, 16 insertions(+), 159 deletions(-)

diff --git a/Makefile b/Makefile
index 4492984..1e91804 100644
--- a/Makefile
+++ b/Makefile
@@ -473,7 +473,7 @@ $(KCONFIG_CONFIG) include/config/auto.conf.cmd: ;
 # if auto.conf.cmd is missing then we are probably in a cleaned tree so
 # we execute the config step to be sure to catch updated Kconfig files
 include/config/auto.conf: $(KCONFIG_CONFIG) include/config/auto.conf.cmd
-	$(Q)$(MAKE) -f $(srctree)/Makefile silentoldconfig
+	$(Q)$(MAKE) -f $(srctree)/Makefile oldconfig
 else
 # external modules needs include/linux/autoconf.h and include/config/auto.conf
 # but do not care if they are up-to-date. Use auto.conf to trigger the test
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 70b329d..fa4f746 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -18,12 +18,9 @@ menuconfig: $(obj)/mconf
 config: $(obj)/conf
 	$< $(Kconfig)
 
-oldconfig: $(obj)/conf
+oldconfig silentoldconfig: $(obj)/conf
 	$< -o $(Kconfig)
 
-silentoldconfig: $(obj)/conf
-	$< -s $(Kconfig)
-
 # Create new linux.pot file
 # Adjust charset to UTF-8 in .po file to accept UTF-8 in Kconfig files
 # The symlink is used to repair a deficiency in arch/um
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index fda6313..263165d 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -21,14 +21,7 @@ static void check_conf(struct menu *menu);
 enum {
 	ask_all,
 	ask_new,
-	ask_silent,
-	set_default,
-	set_yes,
-	set_mod,
-	set_no,
-	set_random
 } input_mode = ask_all;
-char *defconfig_file;
 
 static int indent = 1;
 static int valid_stdin = 1;
@@ -65,18 +58,17 @@ static void strip(char *str)
 
 static void check_stdin(void)
 {
-	if (!valid_stdin && input_mode == ask_silent) {
-		printf(_("aborted!\n\n"));
-		printf(_("Console input/output is redirected. "));
-		printf(_("Run 'make oldconfig' to update configuration.\n\n"));
-		exit(1);
-	}
+	if (valid_stdin)
+		return;
+	fprintf(stderr, _("aborted!\n\n"));
+	fprintf(stderr, _("Console input/output is redirected. "));
+	fprintf(stderr, _("Run 'make oldconfig' to update configuration.\n\n"));
+	exit(1);
 }
 
 static int conf_askvalue(struct symbol *sym, const char *def)
 {
 	enum symbol_type type = sym_get_type(sym);
-	tristate val;
 
 	if (!sym_has_value(sym))
 		printf(_("(NEW) "));
@@ -91,32 +83,17 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 		return 0;
 	}
 
+	check_stdin();
 	switch (input_mode) {
-	case set_no:
-	case set_mod:
-	case set_yes:
-	case set_random:
-		if (sym_has_value(sym)) {
-			printf("%s\n", def);
-			return 0;
-		}
-		break;
 	case ask_new:
-	case ask_silent:
 		if (sym_has_value(sym)) {
 			printf("%s\n", def);
 			return 0;
 		}
-		check_stdin();
 	case ask_all:
 		fflush(stdout);
 		fgets(line, 128, stdin);
 		return 1;
-	case set_default:
-		printf("%s\n", def);
-		return 1;
-	default:
-		break;
 	}
 
 	switch (type) {
@@ -128,52 +105,6 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 	default:
 		;
 	}
-	switch (input_mode) {
-	case set_yes:
-		if (sym_tristate_within_range(sym, yes)) {
-			line[0] = 'y';
-			line[1] = '\n';
-			line[2] = 0;
-			break;
-		}
-	case set_mod:
-		if (type == S_TRISTATE) {
-			if (sym_tristate_within_range(sym, mod)) {
-				line[0] = 'm';
-				line[1] = '\n';
-				line[2] = 0;
-				break;
-			}
-		} else {
-			if (sym_tristate_within_range(sym, yes)) {
-				line[0] = 'y';
-				line[1] = '\n';
-				line[2] = 0;
-				break;
-			}
-		}
-	case set_no:
-		if (sym_tristate_within_range(sym, no)) {
-			line[0] = 'n';
-			line[1] = '\n';
-			line[2] = 0;
-			break;
-		}
-	case set_random:
-		do {
-			val = (tristate)(rand() % 3);
-		} while (!sym_tristate_within_range(sym, val));
-		switch (val) {
-		case no: line[0] = 'n'; break;
-		case mod: line[0] = 'm'; break;
-		case yes: line[0] = 'y'; break;
-		}
-		line[1] = '\n';
-		line[2] = 0;
-		break;
-	default:
-		break;
-	}
 	printf("%s", line);
 	return 1;
 }
@@ -352,7 +283,6 @@ static int conf_choice(struct menu *menu)
 		printf("]: ");
 		switch (input_mode) {
 		case ask_new:
-		case ask_silent:
 			if (!is_new) {
 				cnt = def;
 				printf("%d\n", cnt);
@@ -374,16 +304,6 @@ static int conf_choice(struct menu *menu)
 			else
 				continue;
 			break;
-		case set_random:
-			if (is_new)
-				def = (rand() % cnt) + 1;
-		case set_default:
-		case set_yes:
-		case set_mod:
-		case set_no:
-			cnt = def;
-			printf("%d\n", cnt);
-			break;
 		}
 
 	conf_childs:
@@ -425,7 +345,7 @@ static void conf(struct menu *menu)
 
 		switch (prop->type) {
 		case P_MENU:
-			if (input_mode == ask_silent && rootEntry != menu) {
+			if (input_mode != ask_all && rootEntry != menu) {
 				check_conf(menu);
 				return;
 			}
@@ -504,35 +424,13 @@ int main(int ac, char **av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	while ((opt = getopt(ac, av, "osdD:nmyrh")) != -1) {
+	valid_stdin = isatty(0) && isatty(1) && isatty(2);
+
+	while ((opt = getopt(ac, av, "oh")) != -1) {
 		switch (opt) {
 		case 'o':
 			input_mode = ask_new;
 			break;
-		case 's':
-			input_mode = ask_silent;
-			valid_stdin = isatty(0) && isatty(1) && isatty(2);
-			break;
-		case 'd':
-			input_mode = set_default;
-			break;
-		case 'D':
-			input_mode = set_default;
-			defconfig_file = optarg;
-			break;
-		case 'n':
-			input_mode = set_no;
-			break;
-		case 'm':
-			input_mode = set_mod;
-			break;
-		case 'y':
-			input_mode = set_yes;
-			break;
-		case 'r':
-			input_mode = set_random;
-			srand(time(NULL));
-			break;
 		case 'h':
 			printf(_("See README for usage info\n"));
 			exit(0);
@@ -550,17 +448,7 @@ int main(int ac, char **av)
 	conf_parse(name);
 	//zconfdump(stdout);
 	switch (input_mode) {
-	case set_default:
-		if (!defconfig_file)
-			defconfig_file = conf_get_default_confname();
-		if (conf_read(defconfig_file)) {
-			printf(_("***\n"
-				"*** Can't find default configuration \"%s\"!\n"
-				"***\n"), defconfig_file);
-			exit(1);
-		}
-		break;
-	case ask_silent:
+	case ask_new:
 		if (stat(".config", &tmpstat)) {
 			printf(_("***\n"
 				"*** You have not yet configured your kernel!\n"
@@ -572,41 +460,13 @@ int main(int ac, char **av)
 			exit(1);
 		}
 	case ask_all:
-	case ask_new:
 		conf_read(NULL);
 		break;
-	case set_no:
-	case set_mod:
-	case set_yes:
-	case set_random:
-		name = getenv("KCONFIG_ALLCONFIG");
-		if (name && !stat(name, &tmpstat)) {
-			conf_read_simple(name, S_DEF_USER);
-			break;
-		}
-		switch (input_mode) {
-		case set_no:	 name = "allno.config"; break;
-		case set_mod:	 name = "allmod.config"; break;
-		case set_yes:	 name = "allyes.config"; break;
-		case set_random: name = "allrandom.config"; break;
-		default: break;
-		}
-		if (!stat(name, &tmpstat))
-			conf_read_simple(name, S_DEF_USER);
-		else if (!stat("all.config", &tmpstat))
-			conf_read_simple("all.config", S_DEF_USER);
-		break;
-	default:
-		break;
 	}
 
-	if (input_mode != ask_silent) {
+	if (input_mode == ask_all) {
 		rootEntry = &rootmenu;
 		conf(&rootmenu);
-		if (input_mode == ask_all) {
-			input_mode = ask_silent;
-			valid_stdin = 1;
-		}
 	} else if (conf_get_changed()) {
 		name = getenv("KCONFIG_NOSILENTUPDATE");
 		if (name && *name) {
@@ -625,7 +485,7 @@ int main(int ac, char **av)
 		return 1;
 	}
 skip_check:
-	if (input_mode == ask_silent && conf_write_autoconf()) {
+	if (conf_write_autoconf()) {
 		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
 		return 1;
 	}
-- 
1.5.4.1.143.ge7e51

