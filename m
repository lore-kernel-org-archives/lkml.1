Return-Path: <linux-kernel-owner+w=401wt.eu-S1763904AbXIUVbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763904AbXIUVbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762564AbXIUVbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 17:31:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762381AbXIUVbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 17:31:09 -0400
Subject: patch kconfig-oldconfig-shall-not-set-symbols-if-it-does-not-need-to.patch queued to -stable tree
To: sam@ravnborg.org, gregkh@suse.de, hugh@veritas.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       zippel@linux-m68k.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Fri, 21 Sep 2007 14:31:42 -0700
In-Reply-To: <20070901062940.GA1520@uranus.ravnborg.org>
Message-Id: <20070921213104.CDB3C14540D1@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

     Subject: kconfig: oldconfig shall not set symbols if it does not need to

to the 2.6.22-stable tree.  Its filename is

     kconfig-oldconfig-shall-not-set-symbols-if-it-does-not-need-to.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Fri Aug 31 23:28:28 2007
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 1 Sep 2007 08:29:40 +0200
Subject: kconfig: oldconfig shall not set symbols if it does not need to
To: Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Cc: Roman Zippel <zippel@linux-m68k.org>, Hugh Dickins <hugh@veritas.com>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <20070901062940.GA1520@uranus.ravnborg.org>
Content-Disposition: inline


From: Roman Zippel <zippel@linux-m68k.org>

commit f82f3f9422d4da1eeec6f6cf3e64c6c34c4fe19b in mainline.

Avoid setting the value if the symbol doesn't need to be changed or can't
be changed. Later choices may change the dependencies and thus the
possible input range.

make oldconfig from a 2.6.22 .config with CONFIG_HOTPLUG_CPU not set
was in some configurations setting CONFIG_HOTPLUG_CPU=y without asking,
even when there was no actual requirement for CONFIG_HOTPLUG_CPU.
This was triggered by SUSPEND_SMP that does a select HOTPLUG_CPU.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Tested-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- linux-2.6.orig/scripts/kconfig/conf.c
+++ linux-2.6/scripts/kconfig/conf.c
@@ -72,7 +72,7 @@ static void check_stdin(void)
 	}
 }
 
-static void conf_askvalue(struct symbol *sym, const char *def)
+static int conf_askvalue(struct symbol *sym, const char *def)
 {
 	enum symbol_type type = sym_get_type(sym);
 	tristate val;
@@ -87,7 +87,7 @@ static void conf_askvalue(struct symbol 
 		printf("%s\n", def);
 		line[0] = '\n';
 		line[1] = 0;
-		return;
+		return 0;
 	}
 
 	switch (input_mode) {
@@ -97,23 +97,23 @@ static void conf_askvalue(struct symbol 
 	case set_random:
 		if (sym_has_value(sym)) {
 			printf("%s\n", def);
-			return;
+			return 0;
 		}
 		break;
 	case ask_new:
 	case ask_silent:
 		if (sym_has_value(sym)) {
 			printf("%s\n", def);
-			return;
+			return 0;
 		}
 		check_stdin();
 	case ask_all:
 		fflush(stdout);
 		fgets(line, 128, stdin);
-		return;
+		return 1;
 	case set_default:
 		printf("%s\n", def);
-		return;
+		return 1;
 	default:
 		break;
 	}
@@ -123,7 +123,7 @@ static void conf_askvalue(struct symbol 
 	case S_HEX:
 	case S_STRING:
 		printf("%s\n", def);
-		return;
+		return 1;
 	default:
 		;
 	}
@@ -174,6 +174,7 @@ static void conf_askvalue(struct symbol 
 		break;
 	}
 	printf("%s", line);
+	return 1;
 }
 
 int conf_string(struct menu *menu)
@@ -187,7 +188,8 @@ int conf_string(struct menu *menu)
 		def = sym_get_string_value(sym);
 		if (sym_get_string_value(sym))
 			printf("[%s] ", def);
-		conf_askvalue(sym, def);
+		if (!conf_askvalue(sym, def))
+			return 0;
 		switch (line[0]) {
 		case '\n':
 			break;
@@ -240,7 +242,8 @@ static int conf_sym(struct menu *menu)
 		if (menu_has_help(menu))
 			printf("/?");
 		printf("] ");
-		conf_askvalue(sym, sym_get_string_value(sym));
+		if (!conf_askvalue(sym, sym_get_string_value(sym)))
+			return 0;
 		strip(line);
 
 		switch (line[0]) {

_______________________________________________
stable mailing list
stable@linux.kernel.org
http://linux.kernel.org/mailman/listinfo/stable



Patches currently in stable-queue which might be from sam@ravnborg.org are

queue-2.6.22/kconfig-oldconfig-shall-not-set-symbols-if-it-does-not-need-to.patch
