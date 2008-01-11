Return-Path: <linux-kernel-owner+w=401wt.eu-S1762805AbYAKXJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762805AbYAKXJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 18:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759557AbYAKXJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 18:09:25 -0500
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:60297 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422AbYAKXJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 18:09:23 -0500
Subject: [PATCH 3/10] kconfig: gettext support for config
From: EGRY Gabor <gaboregry1@t-online.hu>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-kernel@zh-kernel.org
Content-Type: text/plain
Date: Fri, 11 Jan 2008 23:44:39 +0100
Message-Id: <1200091479.10603.37.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Gettext support for conf.c .

Signed-off-by: Egry Gabor <gaboregry1@t-online.hu>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
---

 kbuild-szilard/scripts/kconfig/conf.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff -puN scripts/kconfig/conf.c~kconfig-i18n-06-config-i18n scripts/kconfig/conf.c
--- kbuild/scripts/kconfig/conf.c~kconfig-i18n-06-config-i18n	2008-01-11 22:24:40.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/conf.c	2008-01-11 22:24:40.000000000 +0100
@@ -40,7 +40,7 @@ static char nohelp_text[] = N_("Sorry, n
 static const char *get_help(struct menu *menu)
 {
 	if (menu_has_help(menu))
-		return menu_get_help(menu);
+		return _(menu_get_help(menu));
 	else
 		return nohelp_text;
 }
@@ -78,7 +78,7 @@ static int conf_askvalue(struct symbol *
 	tristate val;
 
 	if (!sym_has_value(sym))
-		printf("(NEW) ");
+		printf(_("(NEW) "));
 
 	line[0] = '\n';
 	line[1] = 0;
@@ -183,7 +183,7 @@ int conf_string(struct menu *menu)
 	const char *def;
 
 	while (1) {
-		printf("%*s%s ", indent - 1, "", menu->prompt->text);
+		printf("%*s%s ", indent - 1, "", _(menu->prompt->text));
 		printf("(%s) ", sym->name);
 		def = sym_get_string_value(sym);
 		if (sym_get_string_value(sym))
@@ -216,7 +216,7 @@ static int conf_sym(struct menu *menu)
 	tristate oldval, newval;
 
 	while (1) {
-		printf("%*s%s ", indent - 1, "", menu->prompt->text);
+		printf("%*s%s ", indent - 1, "", _(menu->prompt->text));
 		if (sym->name)
 			printf("(%s) ", sym->name);
 		type = sym_get_type(sym);
@@ -306,7 +306,7 @@ static int conf_choice(struct menu *menu
 		case no:
 			return 1;
 		case mod:
-			printf("%*s%s\n", indent - 1, "", menu_get_prompt(menu));
+			printf("%*s%s\n", indent - 1, "", _(menu_get_prompt(menu)));
 			return 0;
 		case yes:
 			break;
@@ -316,7 +316,7 @@ static int conf_choice(struct menu *menu
 	while (1) {
 		int cnt, def;
 
-		printf("%*s%s\n", indent - 1, "", menu_get_prompt(menu));
+		printf("%*s%s\n", indent - 1, "", _(menu_get_prompt(menu)));
 		def_sym = sym_get_choice_value(sym);
 		cnt = def = 0;
 		line[0] = 0;
@@ -324,7 +324,7 @@ static int conf_choice(struct menu *menu
 			if (!menu_is_visible(child))
 				continue;
 			if (!child->sym) {
-				printf("%*c %s\n", indent, '*', menu_get_prompt(child));
+				printf("%*c %s\n", indent, '*', _(menu_get_prompt(child)));
 				continue;
 			}
 			cnt++;
@@ -333,14 +333,14 @@ static int conf_choice(struct menu *menu
 				printf("%*c", indent, '>');
 			} else
 				printf("%*c", indent, ' ');
-			printf(" %d. %s", cnt, menu_get_prompt(child));
+			printf(" %d. %s", cnt, _(menu_get_prompt(child)));
 			if (child->sym->name)
 				printf(" (%s)", child->sym->name);
 			if (!sym_has_value(child->sym))
-				printf(" (NEW)");
+				printf(_(" (NEW)"));
 			printf("\n");
 		}
-		printf("%*schoice", indent - 1, "");
+		printf(_("%*schoice"), indent - 1, "");
 		if (cnt == 1) {
 			printf("[1]: 1\n");
 			goto conf_childs;
@@ -433,7 +433,7 @@ static void conf(struct menu *menu)
 			if (prompt)
 				printf("%*c\n%*c %s\n%*c\n",
 					indent, '*',
-					indent, '*', prompt,
+					indent, '*', _(prompt),
 					indent, '*');
 		default:
 			;
@@ -499,6 +499,10 @@ int main(int ac, char **av)
 	const char *name;
 	struct stat tmpstat;
 
+	setlocale (LC_ALL, "");
+	bindtextdomain (PACKAGE, LOCALEDIR);
+	textdomain (PACKAGE);
+
 	while ((opt = getopt(ac, av, "osdD:nmyrh")) != -1) {
 		switch (opt) {
 		case 'o':
@@ -529,11 +533,11 @@ int main(int ac, char **av)
 			srand(time(NULL));
 			break;
 		case 'h':
-			printf("See README for usage info\n");
+			printf(_("See README for usage info\n"));
 			exit(0);
 			break;
 		default:
-			fprintf(stderr, "See README for usage info\n");
+			fprintf(stderr, _("See README for usage info\n"));
 			exit(1);
 		}
 	}
@@ -549,9 +553,9 @@ int main(int ac, char **av)
 		if (!defconfig_file)
 			defconfig_file = conf_get_default_confname();
 		if (conf_read(defconfig_file)) {
-			printf("***\n"
+			printf(_("***\n"
 				"*** Can't find default configuration \"%s\"!\n"
-				"***\n", defconfig_file);
+				"***\n"), defconfig_file);
 			exit(1);
 		}
 		break;
_

