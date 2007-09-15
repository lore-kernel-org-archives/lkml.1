Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbXIOSEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbXIOSEc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 14:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXIOSEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 14:04:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:13129 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbXIOSEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 14:04:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:subject:mime-version:from:to:cc:reply-to:content-disposition:content-type:content-transfer-encoding:message-id;
        b=jYSWHnPb4C3O4+liX+Y69V/OXobeMJErtcp1pdIdyy/IvX2jhGc76jyU9dmLrOGOvVFfUVb1RHwIDRDd/c3UGo4U+blDrIcBnOGNkuSPFNwLLtIDvU+hLd6IOzpWEaqtVLntP7Qo0YNwqoQYsFPQcZa7Ut4llj0rd9dXNjgPtX4=
Date: Sat, 15 Sep 2007 20:04:10 +0200
Subject: [PATCH v2] menuconfig: distinguish between selected-by-another options and comments
MIME-Version: 1.0
From: Matej Laitl <strohel@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Roman Zippel <zippel@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Reply-To: 20070914100717.8900b29b.randy.dunlap@oracle.com
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200709152004.11930.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

menuconfig currently represents options implied by another option ('select'
directive in Kconfig) by prefixing them with '---'. Unfortunately the same
notation is used for comments.

This patch changes notation of selected-by-another items by introducing 2 new
representations for implied options:
{*} or {M} for options selected by another modularized one, thus builtin or
module capable,
-*- or -M- for options that cannot be at the moment changed by user.

The idea is to represent actual capability of the option by braces (dashes)
around and to always report actual state by * or M inside.

Signed-off-by: Matěj Laitl <strohel@gmail.com>
---
Changes since v1:
* introduce sym_get_minimal_value(), so that access to struct symbol is 
abstracted.
* change also menuconfig's window header text to reflect the change. I'm still 
not sure if the wording is optimal.

v1 was acked by Randy Dunlap, I'm not sure if it's appropriate to keep 
Acked-by when patch changes. (teach me please)

 scripts/kconfig/lkc_proto.h |    1 +
 scripts/kconfig/mconf.c     |   21 +++++++++++++--------
 scripts/kconfig/symbol.c    |    5 +++++
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/scripts/kconfig/lkc_proto.h b/scripts/kconfig/lkc_proto.h
index 4d09f6d..98642bc 100644
--- a/scripts/kconfig/lkc_proto.h
+++ b/scripts/kconfig/lkc_proto.h
@@ -34,6 +34,7 @@ P(sym_string_valid,bool,(struct symbol *sym, const char 
*newval));
 P(sym_string_within_range,bool,(struct symbol *sym, const char *str));
 P(sym_set_string_value,bool,(struct symbol *sym, const char *newval));
 P(sym_is_changable,bool,(struct symbol *sym));
+P(sym_get_minimal_value,tristate,(struct symbol *sym));
 P(sym_get_choice_prop,struct property *,(struct symbol *sym));
 P(sym_get_default_prop,struct property *,(struct symbol *sym));
 P(sym_get_string_value,const char *,(struct symbol *sym));
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index bc5854e..77ab552 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -35,9 +35,13 @@ static const char mconf_readme[] = N_(
 "kernel parameters which are not really features, but must be\n"
 "entered in as decimal or hexadecimal numbers or possibly text.\n"
 "\n"
-"Menu items beginning with [*], <M> or [ ] represent features\n"
-"configured to be built in, modularized or removed respectively.\n"
-"Pointed brackets <> represent module capable features.\n"
+"Menu items beginning with following braces represent features that\n"
+"  [ ] can be built in or removed\n"
+"  < > can be built in, modularized or removed\n"
+"  { } can be built in or modularized (selected by other feature)\n"
+"  - - are selected by other feature,\n"
+"while *, M or whitespace inside braces means to build in, build as\n"
+"a module or to exclude the feature respectively.\n"
 "\n"
 "To change any of these features, highlight it with the cursor\n"
 "keys and press <Y> to build it in, <M> to make it a module or\n"
@@ -178,9 +182,9 @@ menu_instructions[] = N_(
 	"Arrow keys navigate the menu.  "
 	"<Enter> selects submenus --->.  "
 	"Highlighted letters are hotkeys.  "
-	"Pressing <Y> includes, <N> excludes, <M> modularizes features.  "
+	"Pressing <Y> includes (*), <M> modularizes (M), <N> excludes features 
( ).  "
 	"Press <Esc><Esc> to exit, <?> for Help, </> for Search.  "
-	"Legend: [*] built-in  [ ] excluded  <M> module  < > module capable"),
+	"Legend: [*] built-in, < > module capable, { } implied, -*- forced."),
 radiolist_instructions[] = N_(
 	"Use the arrow keys to navigate this window or "
 	"press the hotkey of the item you wish to select "
@@ -560,7 +564,7 @@ static void build_conf(struct menu *menu)
 				if (sym_is_changable(sym))
 					item_make("[%c]", val == no ? ' ' : '*');
 				else
-					item_make("---");
+					item_make("-%c-", val == no ? ' ' : '*');
 				item_set_tag('t');
 				item_set_data(menu);
 				break;
@@ -571,9 +575,10 @@ static void build_conf(struct menu *menu)
 				default:  ch = ' '; break;
 				}
 				if (sym_is_changable(sym))
-					item_make("<%c>", ch);
+					item_make((sym_get_minimal_value(sym) == mod) ?
+					          "{%c}" : "<%c>", ch);
 				else
-					item_make("---");
+					item_make("-%c-", ch);
 				item_set_tag('t');
 				item_set_data(menu);
 				break;
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index c35dcc5..b9832d0 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -643,6 +643,11 @@ bool sym_is_changable(struct symbol *sym)
 	return sym->visible > sym->rev_dep.tri;
 }
 
+tristate sym_get_minimal_value(struct symbol *sym)
+{
+	return sym->rev_dep.tri;
+}
+
 struct symbol *sym_lookup(const char *name, int isconst)
 {
 	struct symbol *symbol;
-- 
1.5.1.6

