Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbXIXQ1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbXIXQ1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760433AbXIXQZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:25:05 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47216 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760428AbXIXQZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:25:03 -0400
Date: Mon, 24 Sep 2007 09:20:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Roman Zippel <zippel@linux-m68k.org>,
       Hugh Dickins <hugh@veritas.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [07/50] kconfig: oldconfig shall not set symbols if it does not
	need to
Message-ID: <20070924162008.GH13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kconfig-oldconfig-shall-not-set-symbols-if-it-does-not-need-to.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


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

---
 scripts/kconfig/conf.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -64,7 +64,7 @@ static void check_stdin(void)
 	}
 }
 
-static void conf_askvalue(struct symbol *sym, const char *def)
+static int conf_askvalue(struct symbol *sym, const char *def)
 {
 	enum symbol_type type = sym_get_type(sym);
 	tristate val;
@@ -79,7 +79,7 @@ static void conf_askvalue(struct symbol 
 		printf("%s\n", def);
 		line[0] = '\n';
 		line[1] = 0;
-		return;
+		return 0;
 	}
 
 	switch (input_mode) {
@@ -89,23 +89,23 @@ static void conf_askvalue(struct symbol 
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
@@ -115,7 +115,7 @@ static void conf_askvalue(struct symbol 
 	case S_HEX:
 	case S_STRING:
 		printf("%s\n", def);
-		return;
+		return 1;
 	default:
 		;
 	}
@@ -166,6 +166,7 @@ static void conf_askvalue(struct symbol 
 		break;
 	}
 	printf("%s", line);
+	return 1;
 }
 
 int conf_string(struct menu *menu)
@@ -179,7 +180,8 @@ int conf_string(struct menu *menu)
 		def = sym_get_string_value(sym);
 		if (sym_get_string_value(sym))
 			printf("[%s] ", def);
-		conf_askvalue(sym, def);
+		if (!conf_askvalue(sym, def))
+			return 0;
 		switch (line[0]) {
 		case '\n':
 			break;
@@ -236,7 +238,8 @@ static int conf_sym(struct menu *menu)
 		if (sym->help)
 			printf("/?");
 		printf("] ");
-		conf_askvalue(sym, sym_get_string_value(sym));
+		if (!conf_askvalue(sym, sym_get_string_value(sym)))
+			return 0;
 		strip(line);
 
 		switch (line[0]) {

-- 
