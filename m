Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbXIPRor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbXIPRor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 13:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbXIPRol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 13:44:41 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:47881 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbXIPRok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 13:44:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:in-reply-to:references:date:subject:mime-version:from:to:cc:content-disposition:content-type:content-transfer-encoding:message-id;
        b=hRn3VP87QdrS+spMc4p0eQLsjo0OYegppo8ecp1mmrdbmc5jVpIKh6X9fuj5VzZopc3DqvqK/taKpGeEAMQhvAj8GGBCfiPeUjvjZoDWfBixTxaCCrtqq5Jh39tfi+SSHUW6gu8qVUcsoco2J7vYPaA+lkrAv2OH1c3Cm6elwF0=
In-Reply-To: <200709152004.11930.strohel@gmail.com>
References: <200709152004.11930.strohel@gmail.com>
Date: Sun, 16 Sep 2007 19:44:30 +0200
Subject: [PATCH v3] menuconfig: distinguish between selected-by-another options and comments
MIME-Version: 1.0
From: Matej Laitl <strohel@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200709161944.31780.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

menuconfig currently represents options implied by another option ('select'
directive in Kconfig) by prefixing them with '---'. Unfortunately the same
notation is used for comments.

This patch changes notation of selected-by-another items by introducing new
representations for implied options:
{*} or {M} for module capable selected-by features
(*) for module incapable selected-by features

Additionally introduce new notation for features unchangeable due to unsatisfied
dependency of prompt field: "-*-" or "- -". (See CONFIG_BLOCK)

Add help text reporting why feature is unchangable.

Signed-off-by: Matěj Laitl <strohel@gmail.com>
---
Hi Sam, Randy, Roman,
I'm presenting third version of the patch, which should address all mentioned
issues with the patch.
I'm not sure if the text in symbol's help is necessary, feel free to exclude
it.

Changes since v2:
* introduce sym_get_maximal_value()
* make selected-by another features distinguishable from features with no 
active prompt, thus unchangeable.
* add text to each unchangeable symbol's help explaining why it's so.

Changes since v1:
* introduce sym_get_minimal_value(), so that access to struct symbol is 
abstracted.
* change also menuconfig's window header text to reflect the change. I'm still 
not sure if the wording is optimal.

 scripts/kconfig/lkc_proto.h |    2 +
 scripts/kconfig/mconf.c     |   55 +++++++++++++++++++++++++++++--------------
 scripts/kconfig/symbol.c    |   10 ++++++++
 3 files changed, 49 insertions(+), 18 deletions(-)

diff --git a/scripts/kconfig/lkc_proto.h b/scripts/kconfig/lkc_proto.h
index 4d09f6d..c2e3461 100644
--- a/scripts/kconfig/lkc_proto.h
+++ b/scripts/kconfig/lkc_proto.h
@@ -34,6 +34,8 @@ P(sym_string_valid,bool,(struct symbol *sym, const char *newval));
 P(sym_string_within_range,bool,(struct symbol *sym, const char *str));
 P(sym_set_string_value,bool,(struct symbol *sym, const char *newval));
 P(sym_is_changable,bool,(struct symbol *sym));
+P(sym_get_minimal_value,tristate,(struct symbol *sym));
+P(sym_get_maximal_value,tristate,(struct symbol *sym));
 P(sym_get_choice_prop,struct property *,(struct symbol *sym));
 P(sym_get_default_prop,struct property *,(struct symbol *sym));
 P(sym_get_string_value,const char *,(struct symbol *sym));
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index bc5854e..8f8992e 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -35,9 +35,19 @@ static const char mconf_readme[] = N_(
 "kernel parameters which are not really features, but must be\n"
 "entered in as decimal or hexadecimal numbers or possibly text.\n"
 "\n"
-"Menu items beginning with [*], <M> or [ ] represent features\n"
-"configured to be built in, modularized or removed respectively.\n"
-"Pointed brackets <> represent module capable features.\n"
+"Menu items beginning with following braces represent features that\n"
+"  [ ] can be built in or excluded;\n"
+"  < > can be built in, modularized or excluded.\n"
+"Some options may 'select' another options, selected options cannot\n"
+"be excluded from building. Selected features are indicated as follows\n"
+"  ( ) module incapable selected features\n"
+"  { } module capable selected features.\n"
+"Character inside braces represent actual state, where *, M or\n"
+"whitespace means to build in, build as a module or to exclude the\n"
+"feature respectively.\n"
+"\n"
+"Items starting with - -, -M- or -*- cannot changed by the user\n"
+"because they have no active prompt (unsatisfied dependency).\n"
 "\n"
 "To change any of these features, highlight it with the cursor\n"
 "keys and press <Y> to build it in, <M> to make it a module or\n"
@@ -178,9 +188,9 @@ menu_instructions[] = N_(
 	"Arrow keys navigate the menu.  "
 	"<Enter> selects submenus --->.  "
 	"Highlighted letters are hotkeys.  "
-	"Pressing <Y> includes, <N> excludes, <M> modularizes features.  "
+	"Pressing <Y> includes (*), <M> modularizes (M), <N> excludes features ( ).  "
 	"Press <Esc><Esc> to exit, <?> for Help, </> for Search.  "
-	"Legend: [*] built-in  [ ] excluded  <M> module  < > module capable"),
+	"Legend: [*], (*) built-in;  < >, { } module capable."),
 radiolist_instructions[] = N_(
 	"Use the arrow keys to navigate this window or "
 	"press the hotkey of the item you wish to select "
@@ -359,6 +369,11 @@ static void get_symbol_str(struct gstr *r, struct symbol *sym)
 
 	str_printf(r, "Symbol: %s [=%s]\n", sym->name,
 	                               sym_get_string_value(sym));
+	if (sym_get_minimal_value(sym) != no)
+		str_printf(r, "Enforced value: %s (see Selected by:)\n",
+		              sym_get_minimal_value(sym) == mod ? "[m] or [y]" : "[y]");
+	if (sym_get_maximal_value(sym) == no)
+		str_append(r, "None of the prompts active, default value assigned\n");
 	for_all_prompts(sym, prop)
 		get_prompt_str(r, prop);
 	hit = false;
@@ -542,14 +557,19 @@ static void build_conf(struct menu *menu)
 			return;
 		}
 	} else {
+		val = sym_get_tristate_value(sym);
+		switch (val) {
+		case yes: ch = '*'; break;
+		case mod: ch = 'M'; break;
+		default:  ch = ' '; break;
+		}
 		if (menu == current_menu) {
-			item_make("---%*c%s", indent + 1, ' ', menu_get_prompt(menu));
+			item_make("-%c-%*c%s", ch, indent + 1, ' ', menu_get_prompt(menu));
 			item_set_tag(':');
 			item_set_data(menu);
 			goto conf_childs;
 		}
 		child_count++;
-		val = sym_get_tristate_value(sym);
 		if (sym_is_choice_value(sym) && val == yes) {
 			item_make("   ");
 			item_set_tag(':');
@@ -557,23 +577,22 @@ static void build_conf(struct menu *menu)
 		} else {
 			switch (type) {
 			case S_BOOLEAN:
-				if (sym_is_changable(sym))
-					item_make("[%c]", val == no ? ' ' : '*');
+				if (sym_get_maximal_value(sym) == no) /* no prompt visible */
+					item_make("-%c-", ch);
+				else if (sym_get_minimal_value(sym) != no) /* selected-by */
+					item_make("(%c)", ch);
 				else
-					item_make("---");
+					item_make("[%c]", ch);
 				item_set_tag('t');
 				item_set_data(menu);
 				break;
 			case S_TRISTATE:
-				switch (val) {
-				case yes: ch = '*'; break;
-				case mod: ch = 'M'; break;
-				default:  ch = ' '; break;
-				}
-				if (sym_is_changable(sym))
-					item_make("<%c>", ch);
+				if (sym_get_maximal_value(sym) == no) /* no prompt visible */
+					item_make("-%c-", ch);
+				else if (sym_get_minimal_value(sym) != no) /* selected-by */
+					item_make("{%c}", ch);
 				else
-					item_make("---");
+					item_make("<%c>", ch);
 				item_set_tag('t');
 				item_set_data(menu);
 				break;
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index c35dcc5..8fe1d72 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -643,6 +643,16 @@ bool sym_is_changable(struct symbol *sym)
 	return sym->visible > sym->rev_dep.tri;
 }
 
+tristate sym_get_minimal_value(struct symbol *sym)
+{
+	return sym->rev_dep.tri;
+}
+
+tristate sym_get_maximal_value(struct symbol *sym)
+{
+	return sym->visible;
+}
+
 struct symbol *sym_lookup(const char *name, int isconst)
 {
 	struct symbol *symbol;
-- 
1.5.1.6

