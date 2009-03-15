Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbZCOK0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbZCOK0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 06:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbZCOK0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 06:26:14 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:43822 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbZCOK0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 06:26:13 -0400
Date: Sun, 15 Mar 2009 11:28:12 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] kconfig: fix randconfig for choice blocks
Message-ID: <20090315102812.GA6292@uranus.ravnborg.org>
References: <20090315102341.GA6051@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090315102341.GA6051@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar reported that 'make randconfig' was not covering
choice blocks properly, resulting in certain config options
being left out of randconfig testing altogether.

With the following patch we:
- properly randomize choice value for normal choice blocks
- properly randomize for multi choice blocks
- added several comments to explain what is going on

The root cause of the bug was that SYMBOL_VALID was set on the
symbol representing the choice block so clearing this did
the trick initially.
But testign revealed a few more issues that is now fixed.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/confdata.c |   51 +++++++++++++++++++++++++++++++-------------
 1 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 830d9ea..273d738 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -843,7 +843,7 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 			default:
 				continue;
 			}
-			if (!sym_is_choice(sym) || mode != def_random)
+			if (!(sym_is_choice(sym) && mode == def_random))
 				sym->flags |= SYMBOL_DEF_USER;
 			break;
 		default:
@@ -856,28 +856,49 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 
 	if (mode != def_random)
 		return;
-
+	/*
+	 * We have different type of choice blocks.
+	 * If curr.tri equal to mod then we can select several
+	 * choice symbols in one block.
+	 * In this case we do nothing.
+	 * If curr.tri equal yes then only one symbol can be
+	 * selected in a choice block and we set it to yes,
+	 * and the rest to no.
+	 */
 	for_all_symbols(i, csym) {
 		if (sym_has_value(csym) || !sym_is_choice(csym))
 			continue;
 
 		sym_calc_value(csym);
+
+		if (csym->curr.tri != yes)
+			continue;
+
 		prop = sym_get_choice_prop(csym);
-		def = -1;
-		while (1) {
-			cnt = 0;
-			expr_list_for_each_sym(prop->expr, e, sym) {
-				if (sym->visible == no)
-					continue;
-				if (def == cnt++) {
-					csym->def[S_DEF_USER].val = sym;
-					break;
-				}
+
+		/* count entries in choice block */
+		cnt = 0;
+		expr_list_for_each_sym(prop->expr, e, sym)
+			cnt++;
+
+		/*
+		 * find a random value and set it to yes,
+		 * set the rest to no so we have only one set
+		 */
+		def = (rand() % cnt);
+
+		cnt = 0;
+		expr_list_for_each_sym(prop->expr, e, sym) {
+			if (def == cnt++) {
+				sym->def[S_DEF_USER].tri = yes;
+				csym->def[S_DEF_USER].val = sym;
+			}
+			else {
+				sym->def[S_DEF_USER].tri = no;
 			}
-			if (def >= 0 || cnt < 2)
-				break;
-			def = (rand() % cnt) + 1;
 		}
 		csym->flags |= SYMBOL_DEF_USER;
+		/* clear VALID to get value calculated */
+		csym->flags &= ~(SYMBOL_VALID);
 	}
 }
-- 
1.6.0.2.GIT

