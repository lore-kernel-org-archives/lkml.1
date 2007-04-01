Return-Path: <linux-kernel-owner+w=401wt.eu-S933808AbXDASTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808AbXDASTB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933794AbXDASSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:18:53 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:40531 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933805AbXDASSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:18:17 -0400
Date: Sun, 1 Apr 2007 20:17:32 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH 14/16] kconfig-allow-override.diff
In-Reply-To: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704012010250.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Allow config variables in .config to override earlier ones in the same
file. In other words,

	# CONFIG_SECURITY is not defined
	CONFIG_SECURITY=y

will activate it. This makes it a bit easier to do

	(cat original-config myconfig myconfig2 ... >.config)

and run menuconfig as expected.

Already posted at http://lkml.org/lkml/2006/10/25/81
Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Sam Ravnborg <sam@ravnborg.org>

 confdata.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

Index: linux-2.6.21-rc5/scripts/kconfig/confdata.c
===================================================================
--- linux-2.6.21-rc5.orig/scripts/kconfig/confdata.c
+++ linux-2.6.21-rc5/scripts/kconfig/confdata.c
@@ -170,8 +170,7 @@ load:
 					sym->type = S_BOOLEAN;
 			}
 			if (sym->flags & def_flags) {
-				conf_warning("trying to reassign symbol %s", sym->name);
-				break;
+				conf_warning("override: reassigning to symbol %s", sym->name);
 			}
 			switch (sym->type) {
 			case S_BOOLEAN:
@@ -210,8 +209,7 @@ load:
 					sym->type = S_OTHER;
 			}
 			if (sym->flags & def_flags) {
-				conf_warning("trying to reassign symbol %s", sym->name);
-				break;
+				conf_warning("override: reassigning to symbol %s", sym->name);
 			}
 			switch (sym->type) {
 			case S_TRISTATE:
@@ -288,11 +286,9 @@ load:
 				}
 				break;
 			case yes:
-				if (cs->def[def].tri != no) {
-					conf_warning("%s creates inconsistent choice state", sym->name);
-					cs->flags &= ~def_flags;
-				} else
-					cs->def[def].val = sym;
+				if(cs->def[def].tri != no)
+					conf_warning("override: %s turns state choice", sym->name);
+				cs->def[def].val = sym;
 				break;
 			}
 			cs->def[def].tri = E_OR(cs->def[def].tri, sym->def[def].tri);
#<EOF>
