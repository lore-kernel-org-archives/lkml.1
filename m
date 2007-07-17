Return-Path: <linux-kernel-owner+w=401wt.eu-S933846AbXGQOQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbXGQOQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761724AbXGQOIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:08:14 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35924 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761274AbXGQOHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:52 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 28/33] kconfig: reset generated values only if Kconfig and .config agree.
Date: Tue, 17 Jul 2007 16:08:57 +0200
Message-Id: <1184681345321-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11846813443988-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org> <11846813432234-git-send-email-sam@ravnborg.org> <11846813441521-git-send-email-sam@ravnborg.org> <11846813443387-git-send-email-sam@ravnborg.org> <1184681344594-git-send-email-sam@ravnborg.org> <11846813444176-git-send-email-sam@ravnborg.org> <11846813442297-git-send-email-sam@ravnborg.org> <11846813443187-git-send-email-sam@ravnborg.org> <11846813
 444171-git-send-email-sam@ravnborg.org> <1184681344985-git-send-email-sam@ravnborg.org> <11846813442810-git-send-email-sam@ravnborg.org> <118468134441-git-send-email-sam@ravnborg.org> <11846813441741-git-send-email-sam@ravnborg.org> <1184681344376-git-send-email-sam@ravnborg.org> <11846813442541-git-send-email-sam@ravnborg.org> <11846813443988-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Zippel <zippel@linux-m68k.org>

Normally generated values (Kconfig entries without a prompt) are cleared as
they are regenerated anyway and so they appear as new should they become
visible and defaults work as expected (once a value is set defaults aren't
used anymore).

The detection whether a value is generated or not is only based on its
visibility status, which can quickly change for a lot of symbols by just
removing a single line from .config or adding a dependency to Kconfig as you
noticed.

The patch now suppresses this logic when .config and Kconfig aren't in sync
and .config needs to be updated, so that you can remove now a random value
from .config and oldconfig won't reask for many other values.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/confdata.c |   37 ++++++++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 664fe29..b2913e9 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
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
-- 
1.5.0.6

