Return-Path: <linux-kernel-owner+w=401wt.eu-S937137AbYEBUtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937137AbYEBUtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936385AbYEBUsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:48:47 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46399 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935015AbYEBUso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:48:44 -0400
From: sam@ravnborg.org
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: Sam Ravnborg <sam@uranus.ravnborg.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] kconfig: drop all*config support in conf.c
Date: Fri,  2 May 2008 22:49:15 +0200
Message-Id: <1209761358-6579-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <1209761358-6579-1-git-send-email-sam@ravnborg.org>
References: <20080502204729.GA6534@uranus.ravnborg.org>
 <1209761358-6579-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@uranus.ravnborg.org>

With the introduction of aconf we can now kill all
the old all*config support code in conf.c
Modified Makefile so defconfig is now handled by
aconf always.
This removed the feature that kconfig could look
up a default configuration in one of the files listed
in DEFCONFIG_LIST.
But this was only used by archs that did not define
KBUILD_DEFCONFIG so no harm done.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/Makefile |   12 ++--
 scripts/kconfig/conf.c   |  128 +---------------------------------------------
 2 files changed, 7 insertions(+), 133 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 3e560a4..47d5df8 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -57,14 +57,14 @@ $(aconf-targets): $(src)/aconf.sh $(obj)/aconf
 	$(Q)K=arch/$(SRCARCH)/configs/$@ \
 	$(CONFIG_SHELL) $< alldefconfig $(Kconfig)
 
-ifeq ($(KBUILD_DEFCONFIG),)
-defconfig: $(obj)/conf
-	$< -d $(Kconfig)
-else
+defconfig-file := $(if $(KBUILD_DEFCONFIG),            \
+        arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG),   \
+        arch/$(SRCARCH)/defconfig)
+defconfig-file := $(strip $(defconfig-file))
+
 defconfig: $(src)/aconf.sh $(obj)/aconf
-	$(Q)K=arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG) \
+	$(Q)K=$(defconfig-file) \
 	$(CONFIG_SHELL) $< alldefconfig $(Kconfig)
-endif
 
 
 # Help text used by make help
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index fda6313..7aabe0b 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -22,13 +22,7 @@ enum {
 	ask_all,
 	ask_new,
 	ask_silent,
-	set_default,
-	set_yes,
-	set_mod,
-	set_no,
-	set_random
 } input_mode = ask_all;
-char *defconfig_file;
 
 static int indent = 1;
 static int valid_stdin = 1;
@@ -76,7 +70,6 @@ static void check_stdin(void)
 static int conf_askvalue(struct symbol *sym, const char *def)
 {
 	enum symbol_type type = sym_get_type(sym);
-	tristate val;
 
 	if (!sym_has_value(sym))
 		printf(_("(NEW) "));
@@ -92,15 +85,6 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 	}
 
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
 	case ask_silent:
 		if (sym_has_value(sym)) {
@@ -112,9 +96,6 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 		fflush(stdout);
 		fgets(line, 128, stdin);
 		return 1;
-	case set_default:
-		printf("%s\n", def);
-		return 1;
 	default:
 		break;
 	}
@@ -128,52 +109,6 @@ static int conf_askvalue(struct symbol *sym, const char *def)
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
@@ -374,16 +309,6 @@ static int conf_choice(struct menu *menu)
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
@@ -504,7 +429,7 @@ int main(int ac, char **av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	while ((opt = getopt(ac, av, "osdD:nmyrh")) != -1) {
+	while ((opt = getopt(ac, av, "osh")) != -1) {
 		switch (opt) {
 		case 'o':
 			input_mode = ask_new;
@@ -513,26 +438,6 @@ int main(int ac, char **av)
 			input_mode = ask_silent;
 			valid_stdin = isatty(0) && isatty(1) && isatty(2);
 			break;
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
@@ -550,16 +455,6 @@ int main(int ac, char **av)
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
 	case ask_silent:
 		if (stat(".config", &tmpstat)) {
 			printf(_("***\n"
@@ -575,27 +470,6 @@ int main(int ac, char **av)
 	case ask_new:
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
 	default:
 		break;
 	}
-- 
1.5.4.1.143.ge7e51

