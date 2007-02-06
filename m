Return-Path: <linux-kernel-owner+w=401wt.eu-S965442AbXBFBXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965442AbXBFBXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 20:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965443AbXBFBXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 20:23:15 -0500
Received: from raven.upol.cz ([158.194.120.4]:52426 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965442AbXBFBXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 20:23:13 -0500
Message-Id: <20070206012208.050237000@flower.upol.cz>
References: <20070206011819.160359000@flower.upol.cz>
User-Agent: jed + quilt/0.45-1
X-Mailer: formail (procmail)
Date: Tue, 06 Feb 2007 02:18:22 +0100
From: Oleg Verych <olecom@flower.upol.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       Bastian Blank <bastian@waldi.eu.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [patch 3/3, resend] kbuild: correctly skip tilded backups in localversion files
Content-Disposition: inline; filename=kbuild-localversion-correctly-skip-backups.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kbuild: correctly skip tilded backups in localversion files

 Tildes as in path as in filenames are handled correctly now:
 only files, containing tilde '~', are backups, thus are not valid.

 [KJ]:
 Definition of `space' was removed, scripts/Kbuild.include has one.
 That definition was taken right from the GNU make manual, while Kbuild's
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

 Makefile |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

Index: linux-2.6.20/Makefile
===================================================================
--- linux-2.6.20.orig/Makefile	2007-02-06 02:12:35.703713750 +0100
+++ linux-2.6.20/Makefile	2007-02-06 02:17:06.612644500 +0100
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

--

