Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbYEaHGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbYEaHGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 03:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYEaHGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 03:06:37 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:13526 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751003AbYEaHGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 03:06:36 -0400
From: Clifford Wolf <clifford@clifford.at>
To: linux-kernel@vger.kernel.org
Cc: Clifford Wolf <clifford@clifford.at>
Subject: [PATCH] Add 'make no2modconfig' config generation target
Date: Sat, 31 May 2008 09:05:07 +0200
Message-Id: <1212217507-32126-1-git-send-email-clifford@clifford.at>
X-Mailer: git-send-email 1.5.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new 'make no2modconfig' make target creates a new kernel
config based on the current one, switching all tristate options
from 'n' to 'm'.

Signed-off-by: Clifford Wolf <clifford@clifford.at>
---
 scripts/kconfig/Makefile |    6 +++++-
 scripts/kconfig/conf.c   |   17 ++++++++++++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index fa1a7d5..66570bf 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -47,7 +47,7 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	$(Q)rm -f arch/um/Kconfig.arch
 	$(Q)rm -f $(obj)/config.pot
 
-PHONY += randconfig allyesconfig allnoconfig allmodconfig defconfig
+PHONY += randconfig allyesconfig allnoconfig allmodconfig no2modconfig defconfig
 
 randconfig: $(obj)/conf
 	$< -r $(Kconfig)
@@ -61,6 +61,9 @@ allnoconfig: $(obj)/conf
 allmodconfig: $(obj)/conf
 	$< -m $(Kconfig)
 
+no2modconfig: scripts/kconfig/conf
+	$< -M $(Kconfig)
+
 defconfig: $(obj)/conf
 ifeq ($(KBUILD_DEFCONFIG),)
 	$< -d $(Kconfig)
@@ -83,6 +86,7 @@ help:
 	@echo  '  randconfig	  - New config with random answer to all options'
 	@echo  '  defconfig	  - New config with default answer to all options'
 	@echo  '  allmodconfig	  - New config selecting modules when possible'
+	@echo  '  no2modconfig    - New config selecting modules for disabled options'
 	@echo  '  allyesconfig	  - New config where all options are accepted with yes'
 	@echo  '  allnoconfig	  - New config where all options are answered with no'
 
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index fda6313..d5770bd 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -22,6 +22,7 @@ enum {
 	ask_all,
 	ask_new,
 	ask_silent,
+	ask_no2mod,
 	set_default,
 	set_yes,
 	set_mod,
@@ -101,6 +102,15 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 			return 0;
 		}
 		break;
+       case ask_no2mod:
+               if (type == S_TRISTATE &&
+                   sym_get_tristate_value(sym) == no) {
+                       fprintf(stderr, "Setting %s to 'm'.\n", sym->name);
+                       line[0] = 'm';
+                       line[1] = '\n';
+                       line[2] = 0;
+                       break;
+               }
 	case ask_new:
 	case ask_silent:
 		if (sym_has_value(sym)) {
@@ -359,6 +369,7 @@ static int conf_choice(struct menu *menu)
 				break;
 			}
 			check_stdin();
+		case ask_no2mod:
 		case ask_all:
 			fflush(stdout);
 			fgets(line, 128, stdin);
@@ -504,7 +515,7 @@ int main(int ac, char **av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	while ((opt = getopt(ac, av, "osdD:nmyrh")) != -1) {
+	while ((opt = getopt(ac, av, "osdD:nmMyrh")) != -1) {
 		switch (opt) {
 		case 'o':
 			input_mode = ask_new;
@@ -526,6 +537,9 @@ int main(int ac, char **av)
 		case 'm':
 			input_mode = set_mod;
 			break;
+		case 'M':
+			input_mode = ask_no2mod;
+			break;
 		case 'y':
 			input_mode = set_yes;
 			break;
@@ -573,6 +587,7 @@ int main(int ac, char **av)
 		}
 	case ask_all:
 	case ask_new:
+	case ask_no2mod:
 		conf_read(NULL);
 		break;
 	case set_no:
-- 
1.5.5.3

