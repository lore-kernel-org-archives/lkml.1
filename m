Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbZFEXlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbZFEXlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZFEXlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:00 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36367 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbZFEXlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:00 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, Roman Zippel <zippel@linux-m68k.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 01/39] kconfig: handle comment entries within choice/endchoice
Date: Sat,  6 Jun 2009 01:42:19 +0200
Message-Id: <1244245377-17441-1-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Korsgaard <jacmet@sunsite.dk>

Implement support for comment entries within choice groups. Comment entries
are displayed visually distinct from normal configs, and selecting them is
a no-op.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/lxdialog/checklist.c |    3 ++-
 scripts/kconfig/mconf.c              |   10 +++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/lxdialog/checklist.c b/scripts/kconfig/lxdialog/checklist.c
index b2a878c..bcc6f19 100644
--- a/scripts/kconfig/lxdialog/checklist.c
+++ b/scripts/kconfig/lxdialog/checklist.c
@@ -41,7 +41,8 @@ static void print_item(WINDOW * win, int choice, int selected)
 	wmove(win, choice, check_x);
 	wattrset(win, selected ? dlg.check_selected.atr
 		 : dlg.check.atr);
-	wprintw(win, "(%c)", item_is_tag('X') ? 'X' : ' ');
+	if (!item_is_tag(':'))
+		wprintw(win, "(%c)", item_is_tag('X') ? 'X' : ' ');
 
 	wattrset(win, selected ? dlg.tag_selected.atr : dlg.tag.atr);
 	mvwaddch(win, choice, item_x, item_str()[0]);
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 6841e95..3bcacb4 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -732,7 +732,12 @@ static void conf_choice(struct menu *menu)
 		for (child = menu->list; child; child = child->next) {
 			if (!menu_is_visible(child))
 				continue;
-			item_make("%s", _(menu_get_prompt(child)));
+			if (child->sym)
+				item_make("%s", _(menu_get_prompt(child)));
+			else {
+				item_make("*** %s ***", _(menu_get_prompt(child)));
+				item_set_tag(':');
+			}
 			item_set_data(child);
 			if (child->sym == active)
 				item_set_selected(1);
@@ -748,6 +753,9 @@ static void conf_choice(struct menu *menu)
 		case 0:
 			if (selected) {
 				child = item_data();
+				if (!child->sym)
+					break;
+
 				sym_set_tristate_value(child->sym, yes);
 			}
 			return;
-- 
1.6.3.rc3.40.g75b44

