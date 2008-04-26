Return-Path: <linux-kernel-owner+w=401wt.eu-S1761594AbYDZCcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761594AbYDZCcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 22:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbYDZCcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 22:32:35 -0400
Received: from mail.queued.net ([207.210.101.209]:2248 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759489AbYDZCcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 22:32:23 -0400
Date: Fri, 25 Apr 2008 22:35:22 -0400
From: Andres Salomon <dilinger@queued.net>
To: sam@ravnborg.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: [PATCH 2/4] kconfig: make conf -s  (silent) a modifier rather than
 an input mode
Message-ID: <20080425223522.4aca9f00@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rather than 'silentoldconfig' being its own input mode, just make it
the same as 'oldconfig' but with a modifier.  This is just a 'silent_mode'
toggle that allows us to add future silent targets.

So, 'silentoldconfig' calls 'conf -s -o' rather than 'conf -s'.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 scripts/kconfig/Makefile |    2 +-
 scripts/kconfig/conf.c   |   23 +++++++++++------------
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 32e8c5a..7df7ea6 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -22,7 +22,7 @@ oldconfig: $(obj)/conf
 	$< -o $(Kconfig)
 
 silentoldconfig: $(obj)/conf
-	$< -s $(Kconfig)
+	$< -s -o $(Kconfig)
 
 # Create new linux.pot file
 # Adjust charset to UTF-8 in .po file to accept UTF-8 in Kconfig files
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index fda6313..e17767e 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -21,7 +21,6 @@ static void check_conf(struct menu *menu);
 enum {
 	ask_all,
 	ask_new,
-	ask_silent,
 	set_default,
 	set_yes,
 	set_mod,
@@ -31,6 +30,7 @@ enum {
 char *defconfig_file;
 
 static int indent = 1;
+static int silent_mode;
 static int valid_stdin = 1;
 static int conf_cnt;
 static char line[128];
@@ -65,7 +65,7 @@ static void strip(char *str)
 
 static void check_stdin(void)
 {
-	if (!valid_stdin && input_mode == ask_silent) {
+	if (!valid_stdin && silent_mode) {
 		printf(_("aborted!\n\n"));
 		printf(_("Console input/output is redirected. "));
 		printf(_("Run 'make oldconfig' to update configuration.\n\n"));
@@ -102,7 +102,6 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 		}
 		break;
 	case ask_new:
-	case ask_silent:
 		if (sym_has_value(sym)) {
 			printf("%s\n", def);
 			return 0;
@@ -352,7 +351,6 @@ static int conf_choice(struct menu *menu)
 		printf("]: ");
 		switch (input_mode) {
 		case ask_new:
-		case ask_silent:
 			if (!is_new) {
 				cnt = def;
 				printf("%d\n", cnt);
@@ -425,7 +423,7 @@ static void conf(struct menu *menu)
 
 		switch (prop->type) {
 		case P_MENU:
-			if (input_mode == ask_silent && rootEntry != menu) {
+			if (silent_mode && rootEntry != menu) {
 				check_conf(menu);
 				return;
 			}
@@ -510,7 +508,7 @@ int main(int ac, char **av)
 			input_mode = ask_new;
 			break;
 		case 's':
-			input_mode = ask_silent;
+			silent_mode = 1;
 			valid_stdin = isatty(0) && isatty(1) && isatty(2);
 			break;
 		case 'd':
@@ -560,8 +558,8 @@ int main(int ac, char **av)
 			exit(1);
 		}
 		break;
-	case ask_silent:
-		if (stat(".config", &tmpstat)) {
+	case ask_new:
+		if (silent_mode && stat(".config", &tmpstat)) {
 			printf(_("***\n"
 				"*** You have not yet configured your kernel!\n"
 				"*** (missing kernel .config file)\n"
@@ -571,8 +569,8 @@ int main(int ac, char **av)
 				"***\n"));
 			exit(1);
 		}
+		/* fall through */
 	case ask_all:
-	case ask_new:
 		conf_read(NULL);
 		break;
 	case set_no:
@@ -600,11 +598,12 @@ int main(int ac, char **av)
 		break;
 	}
 
-	if (input_mode != ask_silent) {
+	if (!silent_mode) {
 		rootEntry = &rootmenu;
 		conf(&rootmenu);
 		if (input_mode == ask_all) {
-			input_mode = ask_silent;
+			input_mode = ask_new;
+			silent_mode = 1;
 			valid_stdin = 1;
 		}
 	} else if (conf_get_changed()) {
@@ -625,7 +624,7 @@ int main(int ac, char **av)
 		return 1;
 	}
 skip_check:
-	if (input_mode == ask_silent && conf_write_autoconf()) {
+	if (silent_mode && conf_write_autoconf()) {
 		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
 		return 1;
 	}
-- 
1.5.5

