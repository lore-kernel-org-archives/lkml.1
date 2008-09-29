Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYI2Dxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYI2Dxb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 23:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbYI2DxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 23:53:06 -0400
Received: from linux-m68k.xs4all.nl ([82.95.193.92]:48220 "EHLO
	scrub.xs4all.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753042AbYI2DxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 23:53:04 -0400
Message-Id: <20080929032837.695642586@linux-m68k.org>
References: <20080929032709.693370201@linux-m68k.org>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 05:27:10 +0200
From: zippel@linux-m68k.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: [PATCH 1/2] fix silentoldconfig
Content-Disposition: inline; filename=fix-conf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent changes to oldconfig have mixed up the silentoldconfig handling,
so this fixes that by clearly separating that special mode, e.g.
KCONFIG_NOSILENTUPDATE is only relevant here, the .config is written as
needed.
This will also properly close Bug 11230.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 scripts/kconfig/conf.c |  123 ++++++++++++++++++++++---------------------------
 1 file changed, 57 insertions(+), 66 deletions(-)

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
@@ -477,11 +441,11 @@ int main(int ac, char **av)
 	while ((opt = getopt(ac, av, "osdD:nmyrh")) != -1) {
 		switch (opt) {
 		case 'o':
-			input_mode = ask_new;
+			input_mode = ask_silent;
 			break;
 		case 's':
 			input_mode = ask_silent;
-			valid_stdin = isatty(0) && isatty(1) && isatty(2);
+			sync_kconfig = 1;
 			break;
 		case 'd':
 			input_mode = set_default;
@@ -519,6 +483,19 @@ int main(int ac, char **av)
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
@@ -531,16 +508,6 @@ int main(int ac, char **av)
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
@@ -569,6 +536,19 @@ int main(int ac, char **av)
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
@@ -585,27 +565,38 @@ int main(int ac, char **av)
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
+		/* silentoldconfig is used during the build so we shall update autoconf.
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

-- 

