Return-Path: <linux-kernel-owner+w=401wt.eu-S937188AbYEBUuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937188AbYEBUuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936433AbYEBUss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:48:48 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46400 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935973AbYEBUso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:48:44 -0400
From: sam@ravnborg.org
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: Sam Ravnborg <sam@uranus.ravnborg.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] kconfig: conf is less chatty
Date: Fri,  2 May 2008 22:49:16 +0200
Message-Id: <1209761358-6579-3-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <1209761358-6579-2-git-send-email-sam@ravnborg.org>
References: <20080502204729.GA6534@uranus.ravnborg.org>
 <1209761358-6579-1-git-send-email-sam@ravnborg.org>
 <1209761358-6579-2-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@uranus.ravnborg.org>

No one really used the output generated during a
oldconfig run. So drop it and behave like the
old 'silentoldconfig' always did.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile                 |    2 +-
 scripts/kconfig/Makefile |    5 +----
 scripts/kconfig/conf.c   |   42 ++++++++++++++----------------------------
 3 files changed, 16 insertions(+), 33 deletions(-)

diff --git a/Makefile b/Makefile
index d3634cd..99fcf12 100644
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
index 47d5df8..1ccd584 100644
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
index 7aabe0b..263165d 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -21,7 +21,6 @@ static void check_conf(struct menu *menu);
 enum {
 	ask_all,
 	ask_new,
-	ask_silent,
 } input_mode = ask_all;
 
 static int indent = 1;
@@ -59,12 +58,12 @@ static void strip(char *str)
 
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
@@ -84,20 +83,17 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 		return 0;
 	}
 
+	check_stdin();
 	switch (input_mode) {
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
-	default:
-		break;
 	}
 
 	switch (type) {
@@ -287,7 +283,6 @@ static int conf_choice(struct menu *menu)
 		printf("]: ");
 		switch (input_mode) {
 		case ask_new:
-		case ask_silent:
 			if (!is_new) {
 				cnt = def;
 				printf("%d\n", cnt);
@@ -350,7 +345,7 @@ static void conf(struct menu *menu)
 
 		switch (prop->type) {
 		case P_MENU:
-			if (input_mode == ask_silent && rootEntry != menu) {
+			if (input_mode != ask_all && rootEntry != menu) {
 				check_conf(menu);
 				return;
 			}
@@ -429,15 +424,13 @@ int main(int ac, char **av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	while ((opt = getopt(ac, av, "osh")) != -1) {
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
 		case 'h':
 			printf(_("See README for usage info\n"));
 			exit(0);
@@ -455,7 +448,7 @@ int main(int ac, char **av)
 	conf_parse(name);
 	//zconfdump(stdout);
 	switch (input_mode) {
-	case ask_silent:
+	case ask_new:
 		if (stat(".config", &tmpstat)) {
 			printf(_("***\n"
 				"*** You have not yet configured your kernel!\n"
@@ -467,20 +460,13 @@ int main(int ac, char **av)
 			exit(1);
 		}
 	case ask_all:
-	case ask_new:
 		conf_read(NULL);
 		break;
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
@@ -499,7 +485,7 @@ int main(int ac, char **av)
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

