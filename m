Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbXIRSQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbXIRSQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbXIRSQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:16:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:21023 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbXIRSQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:16:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:in-reply-to:references:date:subject:mime-version:from:to:cc:content-disposition:content-type:content-transfer-encoding:message-id;
        b=qtsT/Tkq26GBYdbFGB1oK/ojHym4jWz2hcZSscrf2YjaNjyhBjLi6xop5Db2kuJrvMCeOmsjlElmZDAKYzffb6izfFn+mciM/giX9Mg05Bd7/dHH93igDwfuR1jvxuasIW93I2/v0xzGTA8rc0fFyrc7nEH2ESmyUXl9z36s53A=
In-Reply-To: <200709152004.11930.strohel@gmail.com>
References: <200709152004.11930.strohel@gmail.com>
Date: Tue, 18 Sep 2007 20:16:00 +0200
Subject: [PATCH] kconfig: menuconfig: change "---" items to "-*-", "-M-" or "- -"
MIME-Version: 1.0
From: Matej Laitl <strohel@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200709182016.02436.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This little patch changes notation of unchangeable menuconfig items to always
reflect the current state of inclusion of a feature.

Signed-off-by: Matěj Laitl <strohel@gmail.com>
---
Hi again, Sam, Roman, Randy.

Instead of incorporating all changes into a single patch, I decided to split 
things into more rather independent patches.

Expect another one extending show_help(). (which ATM needs more polishing 
before being posted)

 scripts/kconfig/mconf.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index bc5854e..38ffbe1 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -542,14 +542,19 @@ static void build_conf(struct menu *menu)
 			return;
 		}
 	} else {
+		val = sym_get_tristate_value(sym);
+		switch (val) {
+			case yes: ch = '*'; break;
+			case mod: ch = 'M'; break;
+			default:  ch = ' '; break;
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
@@ -558,22 +563,17 @@ static void build_conf(struct menu *menu)
 			switch (type) {
 			case S_BOOLEAN:
 				if (sym_is_changable(sym))
-					item_make("[%c]", val == no ? ' ' : '*');
+					item_make("[%c]", ch);
 				else
-					item_make("---");
+					item_make("-%c-", ch);
 				item_set_tag('t');
 				item_set_data(menu);
 				break;
 			case S_TRISTATE:
-				switch (val) {
-				case yes: ch = '*'; break;
-				case mod: ch = 'M'; break;
-				default:  ch = ' '; break;
-				}
 				if (sym_is_changable(sym))
 					item_make("<%c>", ch);
 				else
-					item_make("---");
+					item_make("-%c-", ch);
 				item_set_tag('t');
 				item_set_data(menu);
 				break;
-- 
1.5.1.6

