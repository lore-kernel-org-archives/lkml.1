Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbXH3DGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbXH3DGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 23:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbXH3DGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 23:06:00 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4584 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbXH3DF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 23:05:59 -0400
Date: Thu, 30 Aug 2007 05:06:17 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       kbuild-devel@lists.sourceforge.net
Subject: Re: CONFIG_HOTPLUG_CPU: kconfig bug?
In-Reply-To: <20070829180158.GA7849@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0708300235010.1817@scrub.home>
References: <Pine.LNX.4.64.0708271525400.21853@blonde.wat.veritas.com>
 <20070827172654.GA21871@uranus.ravnborg.org> <Pine.LNX.4.64.0708272143150.29594@blonde.wat.veritas.com>
 <20070829180158.GA7849@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 29 Aug 2007, Sam Ravnborg wrote:

> > > > I've noticed an oddity with CONFIG_HOTPLUG_CPU in 2.6.23-rc:
> > > > make oldconfig seems to turn it on even when nothing wants it,
> > > > increasing kernel size by about 10k; but if you then edit the
> > > > line out of .config and make oldconfig again, it correctly
> > > > offers the choice and lets it be turned off after all.
> 
> I have tried to track down what is happening here.
> The culprint is:
> 
> config SUSPEND_SMP
> 	bool
> 	depends on SUSPEND_SMP_POSSIBLE && PM_SLEEP
> 	select HOTPLUG_CPU
> 	default y
> 
> 
> It seems that due to the fact that SUSPEND_SMP is default y
> then kconfig enforce the "select HOTPLUG_CPU".

It's somewhat a side effect of using select and defaults, the order of the 
config symbols becomes significant for oldconfig, if you look at the 
output you'll find:

Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL) (HOTPLUG_CPU) [Y/?] y

this sets it to 'y'. In this case one isn't asked about it, because there 
is only one choice. The patch below avoids the setting of the value here.

bye, Roman



Avoid setting the value if the symbol doesn't need to be changed or can't 
be changed. Later choices may change the dependencies and thus the 
possible input range.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 scripts/kconfig/conf.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

Index: linux-2.6/scripts/kconfig/conf.c
===================================================================
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
