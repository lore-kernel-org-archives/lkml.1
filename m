Return-Path: <linux-kernel-owner+w=401wt.eu-S1759371AbXINLQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371AbXINLQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 07:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757672AbXINLQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 07:16:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:25401 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbXINLQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 07:16:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:subject:mime-version:from:to:content-disposition:content-type:content-transfer-encoding:message-id;
        b=S2ZKakqt7OJNQL8YA6thRJHrQMFm3LP3PeKTdWbXCQa0algt5xSB+mLItBuJ/9mkCgQOeaG9/cI+x0ddwrgTz1ida7KpFjjAJ0Tf+509lXCqPRdIcHDwxm69aRj7eRXEEJamsi0MEFAueNVInZPY5qx+iI03z6Yl+CDt3KlyxxQ=
Date: Fri, 14 Sep 2007 13:16:31 +0200
Subject: RFC [PATCH] menuconfig: distinguish between selected-by-another options and comments (resend)
MIME-Version: 1.0
From: Matej Laitl <strohel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200709141316.31841.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

menuconfig currently represents options implied by another option ('select'
directive in Kconfig) by prefixing them with '---'. Unfortunately the same
notation is used for comments. If the implied option is module capable,
user can still switch between Y and M, all without any feedback until she
visits option's help. (try saying M to MAC80211 and then toggling CFG80211)

This patch changes notation of selected-by-another items by introducing 2 new
representations for implied options:
{*} or {M} for options selected by another modularized one, thus builtin or
module capable,
-*- or -M- for options that cannot be at the moment changed by user.

The idea is to represent actual capability of the option by braces (dashes)
around and to always report actual state by * or M inside.

Signed-off-by: Matěj Laitl <strohel@gmail.com>
---
Hi list,
after being a little annoyed by menuconfig not showing me current state of 
selected-by-another options (which were looking as comments), I made up a 
little patch to help users tell these 2 things apart.

I'd like to hear your comments especially concerning the following:
 * English grammar and style in new menuconfig README (I'm non-native english 
speaker)
 * the way to present the new combinations to user (currently I use "{ }" 
and "- -", which may be replaced by something more sexy and clear)
 * the use of "if (sym->rev_dep.tri == mod)". It seems inappropriate to use 
something from struct symbol directly, as all other uses of it are 
abstracted.

TODO is to also change legend text in menuconfig's window header.

Regards,
         Matěj Latil

 scripts/kconfig/mconf.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index bc5854e..5cf99dd 100644
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
@@ -560,7 +564,7 @@ static void build_conf(struct menu *menu)
 				if (sym_is_changable(sym))
 					item_make("[%c]", val == no ? ' ' : '*');
 				else
-					item_make("---");
+					item_make("-%c-", val == no ? ' ' : '*');
 				item_set_tag('t');
 				item_set_data(menu);
 				break;
@@ -570,10 +574,13 @@ static void build_conf(struct menu *menu)
 				case mod: ch = 'M'; break;
 				default:  ch = ' '; break;
 				}
-				if (sym_is_changable(sym))
-					item_make("<%c>", ch);
-				else
-					item_make("---");
+				if (sym_is_changable(sym)) {
+					if (sym->rev_dep.tri == mod)
+						item_make("{%c}", ch);
+					else
+						item_make("<%c>", ch);
+				} else
+					item_make("-%c-", ch);
 				item_set_tag('t');
 				item_set_data(menu);
 				break;
-- 
1.5.1.6

