Return-Path: <linux-kernel-owner+w=401wt.eu-S1751860AbXBAPvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbXBAPvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbXBAPvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:51:17 -0500
Received: from raven.upol.cz ([158.194.120.4]:42299 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbXBAPvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:51:15 -0500
Date: Thu, 1 Feb 2007 16:59:37 +0100
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Roman Zippel <zippel@linux-m68k.org>,
       Bastian Blank <bastian@waldi.eu.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: 2.6.20-rc7 (Re: [patch] kbuild: correctly skip tilded backups in localversion files)
Message-ID: <20070201155937.GA24388@flower.upol.cz>
References: <20070131071103.GA3295@flower.upol.cz> <20070131155651.529e933c.akpm@osdl.org> <20070201023717.GA22328@flower.upol.cz> <20070131184329.753ce801.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131184329.753ce801.akpm@osdl.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kbuild: correctly skip tilded backups in localversion files

 Tildes as in path as in filenames are handled correctly now:
 only files, containing tilde '~', are backups, thus are not valid.

 [KJ]:
 Definition of `space' was removed, scripts/Kbuild.include has one.
 This definition was taken right from GNU make manual, while Kbuild's
 version is original.

Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Bastian Blank <bastian@waldi.eu.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
---

 My using of the `sh' rides from willing to have more portable,
 understandable implementation (and due to GFDL make's docs ;)

Original report by Bastian Blank:

 The following patch fixes the problem that localversion files where
 ignored if the tree lives in a path which contains a ~. It changes the
 test to apply to the filename only.
 
 Debian allows versions which contains ~ in it. The upstream part of the
 version is in the directory name of the build tree and we got weird
 results because the localversion files was just got ignored in this
 case.

---
 linux-2.6.20-rc7/Makefile |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

Index: kernel.org/linux-2.6.20-rc7/Makefile
===================================================================
--- kernel.org.orig/linux-2.6.20-rc7/Makefile	2007-02-01 16:20:54.214174250 +0100
+++ kernel.org/linux-2.6.20-rc7/Makefile	2007-02-01 16:21:40.649076250 +0100
@@ -777,5 +777,5 @@ $(vmlinux-dirs): prepare scripts
 #	$(localver-full)
 #	  $(localver)
-#	    localversion*		(all localversion* files)
+#	    localversion*		(files without backups, containing '~')
 #	    $(CONFIG_LOCALVERSION)	(from kernel config setting)
 #	  $(localver-auto)		(only if CONFIG_LOCALVERSION_AUTO is set)
@@ -788,15 +788,10 @@ $(vmlinux-dirs): prepare scripts
 # scripts/setlocalversion and add the appropriate checks as needed.
 
-nullstring :=
-space      := $(nullstring) # end of line
+pattern = ".*/localversion[^~]*"
+string  = $(shell cat /dev/null \
+	   `find $(objtree) $(srctree) -maxdepth 1 -regex $(pattern) | sort`)
 
-___localver = $(objtree)/localversion* $(srctree)/localversion*
-__localver  = $(sort $(wildcard $(___localver)))
-# skip backup files (containing '~')
-_localver = $(foreach f, $(__localver), $(if $(findstring ~, $(f)),,$(f)))
-
-localver = $(subst $(space),, \
-	   $(shell cat /dev/null $(_localver)) \
-	   $(patsubst "%",%,$(CONFIG_LOCALVERSION)))
+localver = $(subst $(space),, $(string) \
+			      $(patsubst "%",%,$(CONFIG_LOCALVERSION)))
 
 # If CONFIG_LOCALVERSION_AUTO is set scripts/setlocalversion is called
