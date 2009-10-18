Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbZJRIMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbZJRIMQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 04:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZJRIMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 04:12:14 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:50925 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbZJRILU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 04:11:20 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 10/14] kbuild: drop include/asm
Date: Sun, 18 Oct 2009 10:15:19 +0200
Message-Id: <1255853723-477-10-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20091018080635.GA13767@merkur.ravnborg.org>
References: <20091018080635.GA13767@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer use this directory for generated files and
all architectures has moved their header files so no
symlink tricks are needed either.

Drop the symlink and drop the ARCH check.

If we really need to check that the SRCARCH has not changed
when we build a kernel we can add this check back - but then we will
find a more convenient way to store the info.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 .gitignore |    1 -
 Makefile   |   40 ++--------------------------------------
 2 files changed, 2 insertions(+), 39 deletions(-)

diff --git a/.gitignore b/.gitignore
index 5a5024a..624e3ab 100644
--- a/.gitignore
+++ b/.gitignore
@@ -44,7 +44,6 @@ Module.symvers
 #
 # Generated include files
 #
-include/asm
 include/config
 include/linux/autoconf.h
 include/linux/compile.h
diff --git a/Makefile b/Makefile
index 5e71b69..6570cf1 100644
--- a/Makefile
+++ b/Makefile
@@ -967,7 +967,7 @@ endif
 prepare2: prepare3 outputmakefile
 
 prepare1: prepare2 include/linux/version.h include/linux/utsrelease.h \
-                   include/asm include/config/auto.conf
+                   include/config/auto.conf
 	$(cmd_crmodverdir)
 
 archprepare: prepare1 scripts_basic
@@ -979,42 +979,6 @@ prepare0: archprepare FORCE
 # All the preparing..
 prepare: prepare0
 
-# The asm symlink changes when $(ARCH) changes.
-# Detect this and ask user to run make mrproper
-# If asm is a stale symlink (point to dir that does not exist) remove it
-define check-symlink
-	set -e;                                                            \
-	if [ -L include/asm ]; then                                        \
-		asmlink=`readlink include/asm | cut -d '-' -f 2`;          \
-		if [ "$$asmlink" != "$(SRCARCH)" ]; then                   \
-			echo "ERROR: the symlink $@ points to asm-$$asmlink but asm-$(SRCARCH) was expected"; \
-			echo "       set ARCH or save .config and run 'make mrproper' to fix it";             \
-			exit 1;                                            \
-		fi;                                                        \
-		test -e $$asmlink || rm include/asm;                       \
-	elif [ -d include/asm ]; then                                      \
-		echo "ERROR: $@ is a directory but a symlink was expected";\
-		exit 1;                                                    \
-	fi
-endef
-
-# We create the target directory of the symlink if it does
-# not exist so the test in check-symlink works and we have a
-# directory for generated filesas used by some architectures.
-define create-symlink
-	if [ ! -L include/asm ]; then                                      \
-			$(kecho) '  SYMLINK $@ -> include/asm-$(SRCARCH)'; \
-			if [ ! -d include/asm-$(SRCARCH) ]; then           \
-				mkdir -p include/asm-$(SRCARCH);           \
-			fi;                                                \
-			ln -fsn asm-$(SRCARCH) $@;                         \
-	fi
-endef
-
-include/asm: FORCE
-	$(Q)$(check-symlink)
-	$(Q)$(create-symlink)
-
 # Generate some files
 # ---------------------------------------------------------------------------
 
@@ -1183,7 +1147,7 @@ CLEAN_FILES +=	vmlinux System.map \
 
 # Directories & files removed with 'make mrproper'
 MRPROPER_DIRS  += include/config usr/include include/generated
-MRPROPER_FILES += .config .config.old include/asm .version .old_version \
+MRPROPER_FILES += .config .config.old .version .old_version             \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
 		  Module.symvers Module.markers tags TAGS cscope*
-- 
1.6.2.5

