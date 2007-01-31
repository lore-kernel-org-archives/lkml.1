Return-Path: <linux-kernel-owner+w=401wt.eu-S932667AbXAaHCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667AbXAaHCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 02:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbXAaHCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 02:02:34 -0500
Received: from raven.upol.cz ([158.194.120.4]:65292 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbXAaHCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 02:02:33 -0500
Date: Wed, 31 Jan 2007 07:11:04 +0000
To: LKML <linux-kernel@vger.kernel.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Bastian Blank <bastian@waldi.eu.org>,
       Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@osdl.org>
Subject: [patch] kbuild: correctly skip tilded backups in localversion files
Message-ID: <20070131071103.GA3295@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kbuild: correctly skip tilded backups in localversion files

 Tildes as in path as in filenames are handled correctly now.

 Definition of `space' was removed, scripts/Kbuild.include has one.
 This definition was taken right from GNU make manual, while Kbuild's
 version is original.

Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Bastian Blank <bastian@waldi.eu.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
---
Another try.

Original report and fix by Bastian Blank:

 The following patch fixes the problem that localversion files where
 ignored if the tree lives in a path which contains a ~. It changes the
 test to apply to the filename only.
 
 Debian allows versions which contains ~ in it. The upstream part of the
 version is in the directory name of the build tree and we got weird
 results because the localversion files was just got ignored in this
 case.

 Makefile |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- linux-2.6.20-rc6/Makefile~4tilde-backups~	2007-01-30 23:33:45.781462750 +0100
+++ linux-2.6.20-rc6/Makefile	2007-01-31 07:46:18.696404500 +0100
@@ -777,5 +777,5 @@ $(vmlinux-dirs): prepare scripts
 #	$(localver-full)
 #	  $(localver)
-#	    localversion*		(all localversion* files)
+#	    localversion*		(files, without backups containing '~')
 #	    $(CONFIG_LOCALVERSION)	(from kernel config setting)
 #	  $(localver-auto)		(only if CONFIG_LOCALVERSION_AUTO is set)
@@ -788,14 +788,9 @@ $(vmlinux-dirs): prepare scripts
 # scripts/setlocalversion and add the appropriate checks as needed.
 
-nullstring :=
-space      := $(nullstring) # end of line
-
-___localver = $(objtree)/localversion* $(srctree)/localversion*
-__localver  = $(sort $(wildcard $(___localver)))
-# skip backup files (containing '~')
-_localver = $(foreach f, $(__localver), $(if $(findstring ~, $(f)),,$(f)))
-
+localversion = $(objtree)/localversion	    $(srctree)/localversion
+ext_versions = $(objtree)/localversion[^~]* $(srctree)/localversion[!~]*
+versions = $(localversion) $(ext_versions)
 localver = $(subst $(space),, \
-	   $(shell cat /dev/null $(_localver)) \
+	   $(shell cat /dev/null $(sort $(wildcard $(versions)))) \
 	   $(patsubst "%",%,$(CONFIG_LOCALVERSION)))
 
