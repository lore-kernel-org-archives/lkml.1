Return-Path: <linux-kernel-owner+w=401wt.eu-S933427AbYF3Vkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427AbYF3Vkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763413AbYF3Vet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:34:49 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48257 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175AbYF3Vee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:34 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH 22/24] kconfig: speed up all*config + randconfig
Date: Mon, 30 Jun 2008 23:35:16 +0200
Message-Id: <1214861718-32626-22-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the chatty mode when we generate the all*config, randconfig
configurations.
Ths speeds up the process considerably and noone looked
at the output anyway.
This patch uses the conf_set_all_new_symbols() function
just added to kconfig.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 scripts/kconfig/conf.c |  154 +++++++++++++++++++++---------------------------
 1 files changed, 68 insertions(+), 86 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index fda6313..bd2a27e 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -76,7 +76,6 @@ static void check_stdin(void)
 static int conf_askvalue(struct symbol *sym, const char *def)
 {
 	enum symbol_type type = sym_get_type(sym);
-	tristate val;
 
 	if (!sym_has_value(sym))
 		printf(_("(NEW) "));
@@ -92,15 +91,6 @@ static int conf_askvalue(struct symbol *sym, const char *def)
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
@@ -128,52 +118,6 @@ static int conf_askvalue(struct symbol *sym, const char *def)
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
@@ -374,16 +318,12 @@ static int conf_choice(struct menu *menu)
 			else
 				continue;
 			break;
-		case set_random:
-			if (is_new)
-				def = (rand() % cnt) + 1;
 		case set_default:
-		case set_yes:
-		case set_mod:
-		case set_no:
 			cnt = def;
 			printf("%d\n", cnt);
 			break;
+		default:
+			break;
 		}
 
 	conf_childs:
@@ -494,6 +434,43 @@ static void check_conf(struct menu *menu)
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
@@ -599,36 +576,41 @@ int main(int ac, char **av)
 	default:
 		break;
 	}
+	switch (input_mode) {
+	case set_no:
+		conf_set_all_new_symbols(def_no);
+		break;
+	case set_yes:
+		conf_set_all_new_symbols(def_yes);
+		break;
+	case set_mod:
+		conf_set_all_new_symbols(def_mod);
+		break;
+	case set_random:
+		conf_set_all_new_symbols(def_random);
+		break;
+	case ask_silent:
+		if (conf_silent_update())
+			exit(1);
+		break;
+	case ask_new:
+	case ask_all:
+	case set_default:
+		if (conf_update())
+			exit(1);
+		break;
+	}
 
-	if (input_mode != ask_silent) {
-		rootEntry = &rootmenu;
-		conf(&rootmenu);
-		if (input_mode == ask_all) {
-			input_mode = ask_silent;
-			valid_stdin = 1;
-		}
-	} else if (conf_get_changed()) {
-		name = getenv("KCONFIG_NOSILENTUPDATE");
-		if (name && *name) {
-			fprintf(stderr, _("\n*** Kernel configuration requires explicit update.\n\n"));
-			return 1;
-		}
-	} else
-		goto skip_check;
-
-	do {
-		conf_cnt = 0;
-		check_conf(&rootmenu);
-	} while (conf_cnt);
-	if (conf_write(NULL)) {
+	if (conf_get_changed() && conf_write(NULL)) {
 		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
-		return 1;
+		exit(1);
 	}
-skip_check:
+	/* ask_silent is used during the build so we shall update autoconf.
+	 * All other commands are only used to generate a config.
+	 */
 	if (input_mode == ask_silent && conf_write_autoconf()) {
 		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
 		return 1;
 	}
-
 	return 0;
 }
-- 
1.5.6.1.93.gef98

