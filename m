Return-Path: <linux-kernel-owner+w=401wt.eu-S1752364AbYEERPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbYEERPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbYEERPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:15:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38200 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbYEERPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:15:19 -0400
Date: Mon, 5 May 2008 19:15:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "akpm@osdl.org" <akpm@osdl.org>, Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] default to n for GROUP_SCHED and FAIR_GROUP_SCHED
Message-ID: <20080505171501.GA22332@elte.hu>
References: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com> <20080504092417.GA3425@elte.hu> <82e4877d0805050814j721ae522k84384df48c9f4336@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82e4877d0805050814j721ae522k84384df48c9f4336@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Parag Warudkar <parag.warudkar@gmail.com> wrote:

> sched-devel does not boot on my machine - stops right after PCI: Not 
> using mmconfig.
> 
> Here is my config for sched-devel - I did a echo "n" | make oldconfig 
> after copying over the previous config file BTW. Should I try 
> disabling things in config? What's most likely to break boot? (Seems 
> likes there are a lot of significant changes in there.)

every config is supposed to work, but in general you should pick the 
defaults instead of saying 'n' to all questions. As long as every 
question can be answered with an 'enter', this should work:

  make oldconfig < /dev/null

this non-interactive 'make oldconfig' will hang with the kconfig tool 
looping infinitely if there's any numeric question that cannot be 
answered via 'enter'.

This is a many years old kconfig bug that is frequently hacked around in 
distro kernel packages but which has been ignored upstream - i've 
attached Fedora's nonint_oldconfig patch from Dave Jones below. (maybe 
Arjan wrote it originally?)

	Ingo

---
 scripts/kconfig/Makefile |    3 +++
 scripts/kconfig/conf.c   |   28 ++++++++++++++++++++++++----
 2 files changed, 27 insertions(+), 4 deletions(-)

Index: linux/scripts/kconfig/Makefile
===================================================================
--- linux.orig/scripts/kconfig/Makefile
+++ linux/scripts/kconfig/Makefile
@@ -24,6 +24,9 @@ oldconfig: $(obj)/conf
 silentoldconfig: $(obj)/conf
 	$< -s $(Kconfig)
 
+nonint_oldconfig: scripts/kconfig/conf
+	./scripts/kconfig/conf -b arch/x86/Kconfig
+
 # Create new linux.pot file
 # Adjust charset to UTF-8 in .po file to accept UTF-8 in Kconfig files
 # The symlink is used to repair a deficiency in arch/um
Index: linux/scripts/kconfig/conf.c
===================================================================
--- linux.orig/scripts/kconfig/conf.c
+++ linux/scripts/kconfig/conf.c
@@ -22,6 +22,7 @@ enum {
 	ask_all,
 	ask_new,
 	ask_silent,
+	dont_ask,
 	set_default,
 	set_yes,
 	set_mod,
@@ -46,6 +47,8 @@ static const char *get_help(struct menu 
 		return nohelp_text;
 }
 
+static int return_value = 0;
+
 static void strip(char *str)
 {
 	char *p = str;
@@ -112,6 +115,12 @@ static int conf_askvalue(struct symbol *
 		fflush(stdout);
 		fgets(line, 128, stdin);
 		return 1;
+	case dont_ask:
+		if (!sym_has_value(sym)) {
+			fprintf(stderr,"CONFIG_%s\n",sym->name);
+			return_value++;
+		}
+		return;
 	case set_default:
 		printf("%s\n", def);
 		return 1;
@@ -351,6 +360,10 @@ static int conf_choice(struct menu *menu
 			printf("?");
 		printf("]: ");
 		switch (input_mode) {
+		case dont_ask:
+			cnt = def;
+			printf("%d\n", cnt);
+			break;
 		case ask_new:
 		case ask_silent:
 			if (!is_new) {
@@ -486,7 +499,10 @@ static void check_conf(struct menu *menu
 			if (!conf_cnt++)
 				printf(_("*\n* Restart config...\n*\n"));
 			rootEntry = menu_get_parent_menu(menu);
-			conf(rootEntry);
+			if (input_mode == dont_ask)
+				fprintf(stderr,"CONFIG_%s\n",sym->name);
+			else
+				conf(rootEntry);
 		}
 	}
 
@@ -504,11 +520,14 @@ int main(int ac, char **av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	while ((opt = getopt(ac, av, "osdD:nmyrh")) != -1) {
+	while ((opt = getopt(ac, av, "obsdD:nmyrh")) != -1) {
 		switch (opt) {
 		case 'o':
 			input_mode = ask_new;
 			break;
+		case 'b':
+			input_mode = dont_ask;
+			break;
 		case 's':
 			input_mode = ask_silent;
 			valid_stdin = isatty(0) && isatty(1) && isatty(2);
@@ -573,6 +592,7 @@ int main(int ac, char **av)
 		}
 	case ask_all:
 	case ask_new:
+	case dont_ask:
 		conf_read(NULL);
 		break;
 	case set_no:
@@ -619,7 +639,7 @@ int main(int ac, char **av)
 	do {
 		conf_cnt = 0;
 		check_conf(&rootmenu);
-	} while (conf_cnt);
+	} while ((conf_cnt) && (input_mode != dont_ask));
 	if (conf_write(NULL)) {
 		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
 		return 1;
@@ -630,5 +650,5 @@ skip_check:
 		return 1;
 	}
 
-	return 0;
+	return return_value;
 }
