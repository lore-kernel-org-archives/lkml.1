Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbYACWd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbYACWd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 17:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbYACWdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 17:33:46 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:41758 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbYACWdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 17:33:45 -0500
Date: Thu, 3 Jan 2008 23:33:44 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kbuild update
In-Reply-To: <20080103213255.GA21811@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0801032308400.26693@fbirervta.pbzchgretzou.qr>
References: <20080103213255.GA21811@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 3 2008 22:32, Sam Ravnborg wrote:
>
>On top of this I have my personal todo items such as:
>- modern ncurses interface for menuconfig (ala tig, htop and others)

Sorry.. your comparison {menuconfig, htop} raises an "incompatible
pointer passed" on my side. Please explain :)


>TODO items (from my mailbox - I have plenty more)
>=================================================
>- allow kconfig to accept overrides (Jan Engelhart)
>  maybe there is a patch, needs followup

Indeed there is/was a patch. Well, the one I sent last time.
http://lkml.org/lkml/2007/10/18/206

I have updated it to Linus's current treetop.
git://computergmbh.de/linux 'kconfig' branch;

===

commit da9389c3e640f9ee261865beb6b9861fe5b30b78
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Jan 3 23:23:38 2008 +0100

    kconfig: allow overriding symbols
    
    Allow config variables in .config to override earlier ones in the same
    file. In other words,
    
    	# CONFIG_SECURITY is not defined
    	CONFIG_SECURITY=y
    
    will activate it. This makes it a bit easier to do
    
    	cat original-config myconfig myconfig2 ... >.config;
    
    and run *config as expected.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index e0f402f..2853ca7 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -232,8 +232,7 @@ load:
 					sym->type = S_BOOLEAN;
 			}
 			if (sym->flags & def_flags) {
-				conf_warning("trying to reassign symbol %s", sym->name);
-				break;
+				conf_warning("override: reassigning to symbol %s", sym->name);
 			}
 			switch (sym->type) {
 			case S_BOOLEAN:
@@ -272,8 +271,7 @@ load:
 					sym->type = S_OTHER;
 			}
 			if (sym->flags & def_flags) {
-				conf_warning("trying to reassign symbol %s", sym->name);
-				break;
+				conf_warning("override: reassigning to symbol %s", sym->name);
 			}
 			if (conf_set_sym_val(sym, def, def_flags, p))
 				continue;
@@ -297,11 +295,9 @@ load:
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
