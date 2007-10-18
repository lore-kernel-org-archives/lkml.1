Return-Path: <linux-kernel-owner+w=401wt.eu-S1764902AbXJRNcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764902AbXJRNcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 09:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760188AbXJRNcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 09:32:00 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60623 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757613AbXJRNb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 09:31:59 -0400
Date: Thu, 18 Oct 2007 15:31:58 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Allow kconfig to accept overrides
In-Reply-To: <20071018132955.GB20259@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0710181531370.2936@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr>
 <20071012155708.d8abd06d.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0710130127420.31913@fbirervta.pbzchgretzou.qr>
 <47107ED2.6040509@s5r6.in-berlin.de> <Pine.LNX.4.64.0710131338330.31913@fbirervta.pbzchgretzou.qr>
 <4710CF9F.6080207@s5r6.in-berlin.de> <Pine.LNX.4.64.0710131609170.3348@fbirervta.pbzchgretzou.qr>
 <4710F17C.8080100@oracle.com> <Pine.LNX.4.64.0710131836150.3348@fbirervta.pbzchgretzou.qr>
 <20071018132955.GB20259@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 18 2007 15:29, Sam Ravnborg wrote:
>> Yeah, I've put in
>> 	("override: %s changes choice state", sym->name);
>> this morning.
>Care to send me the updated patch.
>

===
Allow config variables in .config to override earlier ones in the same
file. In other words,

	# CONFIG_SECURITY is not defined
	CONFIG_SECURITY=y

will activate it. This makes it a bit easier to do

	(cat original-config myconfig myconfig2 ... >.config)

and run menuconfig as expected.

Posted at:
	http://lkml.org/lkml/2006/10/25/81
	http://lkml.org/lkml/2007/4/1/175

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>

---
 scripts/kconfig/confdata.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

Index: linux-2.6.23.1/scripts/kconfig/confdata.c
===================================================================
--- linux-2.6.23.1.orig/scripts/kconfig/confdata.c
+++ linux-2.6.23.1/scripts/kconfig/confdata.c
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
+					conf_warning("override: %s changes choice state", sym->name);
+				cs->def[def].val = sym;
 				break;
 			}
 			cs->def[def].tri = E_OR(cs->def[def].tri, sym->def[def].tri);
