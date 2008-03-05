Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbYCES4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbYCES4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 13:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbYCES4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 13:56:44 -0500
Received: from testure.choralone.org ([194.9.77.134]:44164 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbYCES4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 13:56:43 -0500
Date: Wed, 5 Mar 2008 13:56:30 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: sam@ravnborg.org
Cc: roland@redhat.com, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: rfc: nonint_oldconfig
Message-ID: <20080305185630.GD16181@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>, sam@ravnborg.org,
	roland@redhat.com, Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam.
 We've had this kicking around in Fedora forever
(Seriously, even our 2.4 kernels had it)
The basic behaviour is to run oldconfig, but instead of
stopping and prompting for each unknown option, print
out a list of the unknowns at the end.
This is useful for us for the case where we're rebasing
to a new kernel. Instead of having to add an option to
our configs and rerun make oldconfig n times, we do it just once,
adding all the new options in one go.
(Well, sometimes it still takes 1-2 more runs if the new options
 are dependancies of other new options, but it still cuts down
the number of times to rerun oldconfig a lot).

There's also an additional target that does the same, but
ignores any options defined in the local configs that the kernel
being configured doesn't know about.

Any comments?

	Dave

-- 
http://www.codemonkey.org.uk



diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 32e8c5a..8020453 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -24,6 +24,11 @@ oldconfig: $(obj)/conf
 silentoldconfig: $(obj)/conf
 	$< -s $(Kconfig)
 
+nonint_oldconfig: $(obj)/conf
+	$< -b $(Kconfig)
+loose_nonint_oldconfig: $(obj)/conf
+	$< -B $(Kconfig)
+
 # Create new linux.pot file
 # Adjust charset to UTF-8 in .po file to accept UTF-8 in Kconfig files
 # The symlink is used to repair a deficiency in arch/um
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index fda6313..ed33b66 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -22,6 +22,8 @@ enum {
 	ask_all,
 	ask_new,
 	ask_silent,
+	dont_ask,
+	dont_ask_dont_tell,
 	set_default,
 	set_yes,
 	set_mod,
@@ -38,6 +40,8 @@ static struct menu *rootEntry;
 
 static char nohelp_text[] = N_("Sorry, no help available for this option yet.\n");
 
+static int return_value = 0;
+
 static const char *get_help(struct menu *menu)
 {
 	if (menu_has_help(menu))
@@ -112,6 +116,16 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 		fflush(stdout);
 		fgets(line, 128, stdin);
 		return 1;
+	case dont_ask:
+		if (!sym_has_value(sym)) {
+			fprintf(stderr,"CONFIG_%s\n",sym->name);
+			return_value++;
+		}
+		/*FALLTHROUGH*/
+	case dont_ask_dont_tell:
+		if (sym_has_value(sym))
+			return 0;
+		return 1;
 	case set_default:
 		printf("%s\n", def);
 		return 1;
@@ -351,6 +365,11 @@ static int conf_choice(struct menu *menu)
 			printf("?");
 		printf("]: ");
 		switch (input_mode) {
+		case dont_ask:
+		case dont_ask_dont_tell:
+			cnt = def;
+			printf("%d\n", cnt);
+			break;
 		case ask_new:
 		case ask_silent:
 			if (!is_new) {
@@ -486,6 +505,10 @@ static void check_conf(struct menu *menu)
 			if (!conf_cnt++)
 				printf(_("*\n* Restart config...\n*\n"));
 			rootEntry = menu_get_parent_menu(menu);
+			if (input_mode == dont_ask
+			    || input_mode == dont_ask_dont_tell)
+				fprintf(stderr,"CONFIG_%s\n",sym->name);
+			else
 			conf(rootEntry);
 		}
 	}
@@ -504,11 +527,17 @@ int main(int ac, char **av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	while ((opt = getopt(ac, av, "osdD:nmyrh")) != -1) {
+	while ((opt = getopt(ac, av, "osbBdD:nmyrh")) != -1) {
 		switch (opt) {
 		case 'o':
 			input_mode = ask_new;
 			break;
+		case 'b':
+			input_mode = dont_ask;
+			break;
+		case 'B':
+			input_mode = dont_ask_dont_tell;
+			break;
 		case 's':
 			input_mode = ask_silent;
 			valid_stdin = isatty(0) && isatty(1) && isatty(2);
@@ -573,6 +602,8 @@ int main(int ac, char **av)
 		}
 	case ask_all:
 	case ask_new:
+	case dont_ask:
+	case dont_ask_dont_tell:
 		conf_read(NULL);
 		break;
 	case set_no:
@@ -619,7 +650,8 @@ int main(int ac, char **av)
 	do {
 		conf_cnt = 0;
 		check_conf(&rootmenu);
-	} while (conf_cnt);
+ 	} while (conf_cnt && (input_mode != dont_ask
+			      && input_mode != dont_ask_dont_tell));
 	if (conf_write(NULL)) {
 		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
 		return 1;
@@ -630,5 +662,5 @@ skip_check:
 		return 1;
 	}
 
-	return 0;
+	return return_value;
 }
