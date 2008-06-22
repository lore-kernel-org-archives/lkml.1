Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbYFVWJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbYFVWJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 18:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbYFVWIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 18:08:06 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60316 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbYFVWH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 18:07:59 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 4/5] kbuild: asm symlink support for arch/$ARCH/include
Date: Mon, 23 Jun 2008 00:08:43 +0200
Message-Id: <1214172524-9043-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080622220508.GA8957@uranus.ravnborg.org>
References: <20080622220508.GA8957@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust the asm symlink support so we do not create the
symlink unless really needed.
We check the precense of include/asm-$ARCH by checking
for the system.h file. We may end up with a stale directory
so it is not enough to check if the directory is present.

For "make O=..." build if we see that asm is a symlink
then it is deleted. This happens when we apply this patch
to a kernel with a valid build - so we do not require
a "make mrproper".

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Kbuild   |    2 +-
 Makefile |   50 ++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/Kbuild b/Kbuild
index e750e9c..254a6af 100644
--- a/Kbuild
+++ b/Kbuild
@@ -43,7 +43,7 @@ $(obj)/$(bounds-file): kernel/bounds.s Kbuild
 # 2) Generate asm-offsets.h
 #
 
-offsets-file := include/asm-$(SRCARCH)/asm-offsets.h
+offsets-file := include/asm/asm-offsets.h
 
 always  += $(offsets-file)
 targets += $(offsets-file)
diff --git a/Makefile b/Makefile
index 115eb48..aac0ae0 100644
--- a/Makefile
+++ b/Makefile
@@ -921,7 +921,9 @@ ifneq ($(KBUILD_SRC),)
 		/bin/false; \
 	fi;
 	$(Q)if [ ! -d include2 ]; then mkdir -p include2; fi;
-	$(Q)ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm
+	$(Q)if [ -e $(srctree)/include/asm-$(SRCARCH)/system.h ]; then  \
+	    ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
+	    fi
 endif
 
 # prepare2 creates a makefile if using a separate output directory
@@ -947,22 +949,42 @@ export CPPFLAGS_vmlinux.lds += -P -C -U$(ARCH)
 
 # The asm symlink changes when $(ARCH) changes.
 # Detect this and ask user to run make mrproper
-
-include/asm: FORCE
-	$(Q)set -e; asmlink=`readlink include/asm | cut -d '-' -f 2`;   \
-	if [ -L include/asm ]; then                                     \
-		if [ "$$asmlink" != "$(SRCARCH)" ]; then                \
+define check-symlink
+	set -e; asmlink=`readlink include/asm | cut -d '-' -f 2`;      \
+	if [ -L include/asm ]; then                                        \
+		if [ "$$asmlink" != "$(SRCARCH)" ]; then                   \
 			echo "ERROR: the symlink $@ points to asm-$$asmlink but asm-$(SRCARCH) was expected"; \
 			echo "       set ARCH or save .config and run 'make mrproper' to fix it";             \
-			exit 1;                                         \
-		fi;                                                     \
-	else                                                            \
-		echo '  SYMLINK $@ -> include/asm-$(SRCARCH)';          \
-		if [ ! -d include ]; then                               \
-			mkdir -p include;                               \
-		fi;                                                     \
-		ln -fsn asm-$(SRCARCH) $@;                              \
+			exit 1;                                            \
+		fi;                                                        \
 	fi
+endef
+
+# For make O=... builds we create a directory when we create
+# asm-offsets so no need to try to create a symlink then
+ifneq ($(KBUILD_SRC),)
+define create-symlink
+	if [ -L include/asm ]; then                                        \
+		rm include/asm;                                            \
+	fi
+endef
+else
+define create-symlink
+	if [ ! -L include/asm ]; then                                      \
+		if [ -e $(srctree)/include/asm-$(SRCARCH)/system.h ]; then \
+			echo '  SYMLINK $@ -> include/asm-$(SRCARCH)';     \
+			if [ ! -d include ]; then                          \
+				mkdir -p include;                          \
+			fi;                                                \
+			ln -fsn asm-$(SRCARCH) $@;                         \
+		fi                                                         \
+	fi
+endef
+endif
+
+include/asm: FORCE
+	$(Q)$(check-symlink)
+	$(Q)$(create-symlink)
 
 # Generate some files
 # ---------------------------------------------------------------------------
-- 
1.5.4.1.143.ge7e51

