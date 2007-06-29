Return-Path: <linux-kernel-owner+w=401wt.eu-S933648AbXF2ORc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648AbXF2ORc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932639AbXF2ORW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:17:22 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1370 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932389AbXF2ORV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:17:21 -0400
Date: Fri, 29 Jun 2007 16:17:38 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706291613040.1818@scrub.home>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 28 Jun 2007, Andrew Morton wrote:

>   So save yourself some hassle and check your .config carefully before
>   building this kernel.  Make sure that everything you need is still enabled.
> 
>   I found that manually adding "CONFIG_BLK_DEV=y" to the .config before
>   running oldconfig saved a large number of config items from getting lost.

This patch should help for this, so that this isn't done when Kconfig or 
.config has been changed and they are not in sync.

bye, Roman


Reset generates values only if Kconfig and .config agree.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 scripts/kconfig/confdata.c |   37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

Index: linux-2.6/scripts/kconfig/confdata.c
===================================================================
--- linux-2.6.orig/scripts/kconfig/confdata.c
+++ linux-2.6/scripts/kconfig/confdata.c
@@ -341,27 +341,42 @@ int conf_read(const char *name)
 		conf_unsaved++;
 		/* maybe print value in verbose mode... */
 	sym_ok:
+		if (!sym_is_choice(sym))
+			continue;
+		/* The choice symbol only has a set value (and thus is not new)
+		 * if all its visible childs have values.
+		 */
+		prop = sym_get_choice_prop(sym);
+		flags = sym->flags;
+		for (e = prop->expr; e; e = e->left.expr)
+			if (e->right.sym->visible != no)
+				flags &= e->right.sym->flags;
+		sym->flags &= flags | ~SYMBOL_DEF_USER;
+	}
+
+	for_all_symbols(i, sym) {
 		if (sym_has_value(sym) && !sym_is_choice_value(sym)) {
-			if (sym->visible == no)
+			/* Reset values of generates values, so they'll appear
+			 * as new, if they should become visible, but that
+			 * doesn't quite work if the Kconfig and the saved
+			 * configuration disagree.
+			 */
+			if (sym->visible == no && !conf_unsaved)
 				sym->flags &= ~SYMBOL_DEF_USER;
 			switch (sym->type) {
 			case S_STRING:
 			case S_INT:
 			case S_HEX:
-				if (!sym_string_within_range(sym, sym->def[S_DEF_USER].val))
-					sym->flags &= ~(SYMBOL_VALID|SYMBOL_DEF_USER);
+				/* Reset a string value if it's out of range */
+				if (sym_string_within_range(sym, sym->def[S_DEF_USER].val))
+					break;
+				sym->flags &= ~(SYMBOL_VALID|SYMBOL_DEF_USER);
+				conf_unsaved++;
+				break;
 			default:
 				break;
 			}
 		}
-		if (!sym_is_choice(sym))
-			continue;
-		prop = sym_get_choice_prop(sym);
-		flags = sym->flags;
-		for (e = prop->expr; e; e = e->left.expr)
-			if (e->right.sym->visible != no)
-				flags &= e->right.sym->flags;
-		sym->flags &= flags | ~SYMBOL_DEF_USER;
 	}
 
 	sym_add_change_count(conf_warnings || conf_unsaved);
