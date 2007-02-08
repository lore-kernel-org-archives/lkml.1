Return-Path: <linux-kernel-owner+w=401wt.eu-S1161493AbXBHAOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161493AbXBHAOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161495AbXBHAOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:14:16 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:32844 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161493AbXBHAOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:14:15 -0500
Date: Thu, 8 Feb 2007 01:13:39 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Andrew Morton <akpm@osdl.org>
cc: olecom@flower.upol.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] refix localversion handling
Message-ID: <Pine.LNX.4.64.0702080109550.14457@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This reverts part of the localversion patch, which now already got into 
git. It removes the unnecessary find call, with the simpler $(notdir ...) 
fix.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 Makefile |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

Index: linux-2.6/Makefile
===================================================================
--- linux-2.6.orig/Makefile
+++ linux-2.6/Makefile
@@ -787,12 +787,14 @@ $(vmlinux-dirs): prepare scripts
 # moment, only git is supported but other SCMs can edit the script
 # scripts/setlocalversion and add the appropriate checks as needed.
 
-pattern = ".*/localversion[^~]*"
-string  = $(shell cat /dev/null \
-	   `find $(objtree) $(srctree) -maxdepth 1 -regex $(pattern) | sort`)
-
-localver = $(subst $(space),, $(string) \
-			      $(patsubst "%",%,$(CONFIG_LOCALVERSION)))
+___localver = $(objtree)/localversion* $(srctree)/localversion*
+__localver  = $(sort $(wildcard $(___localver)))
+# skip files containing '~' (like backup files)
+_localver = $(foreach f,$(__localver),$(if $(findstring ~,$(notdir $(f))),,$(f)))
+
+localver = $(subst $(space),, \
+	   $(shell cat /dev/null $(_localver)) \
+	   $(patsubst "%",%,$(CONFIG_LOCALVERSION)))
 
 # If CONFIG_LOCALVERSION_AUTO is set scripts/setlocalversion is called
 # and if the SCM is know a tag from the SCM is appended.
