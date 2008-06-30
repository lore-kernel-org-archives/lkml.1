Return-Path: <linux-kernel-owner+w=401wt.eu-S933268AbYF3VjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268AbYF3VjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763281AbYF3Veo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:34:44 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51664 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763082AbYF3Ved (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:33 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 12/24] kbuild: asm symlink support for arch/$ARCH/include
Date: Mon, 30 Jun 2008 23:35:06 +0200
Message-Id: <1214861718-32626-12-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust the asm symlink support so we do not create the
symlink unless really needed.
We check the precense of include/asm-$ARCH by checking
for the system.h file. We may end up with a stale directory
so it is not enough to check if the directory is present.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Kbuild   |    3 +--
 Makefile |   42 ++++++++++++++++++++++++++++--------------
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/Kbuild b/Kbuild
index e750e9c..f056b4f 100644
--- a/Kbuild
+++ b/Kbuild
@@ -43,7 +43,7 @@ $(obj)/$(bounds-file): kernel/bounds.s Kbuild
 # 2) Generate asm-offsets.h
 #
 
-offsets-file := include/asm-$(SRCARCH)/asm-offsets.h
+offsets-file := include/asm/asm-offsets.h
 
 always  += $(offsets-file)
 targets += $(offsets-file)
@@ -81,7 +81,6 @@ arch/$(SRCARCH)/kernel/asm-offsets.s: arch/$(SRCARCH)/kernel/asm-offsets.c \
 	$(call if_changed_dep,cc_s_c)
 
 $(obj)/$(offsets-file): arch/$(SRCARCH)/kernel/asm-offsets.s Kbuild
-	$(Q)mkdir -p $(dir $@)
 	$(call cmd,offsets)
 
 #####
diff --git a/Makefile b/Makefile
index 39b997f..339f6d3 100644
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
@@ -947,22 +949,34 @@ export CPPFLAGS_vmlinux.lds += -P -C -U$(ARCH)
 
 # The asm symlink changes when $(ARCH) changes.
 # Detect this and ask user to run make mrproper
-
-include/asm: FORCE
-	$(Q)set -e; asmlink=`readlink include/asm | cut -d '-' -f 2`;   \
-	if [ -L include/asm ]; then                                     \
-		if [ "$$asmlink" != "$(SRCARCH)" ]; then                \
+define check-symlink
+	set -e;                                                            \
+	if [ -L include/asm ]; then                                        \
+		asmlink=`readlink include/asm | cut -d '-' -f 2`;          \
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
+	fi
+endef
+
+# We create the target directory of the symlink if it does
+# not exist so the test in chack-symlink works and we have a
+# directory for generated filesas used by some architectures.
+define create-symlink
+	if [ ! -L include/asm ]; then                                      \
+			echo '  SYMLINK $@ -> include/asm-$(SRCARCH)';     \
+			if [ ! -d include/asm-$(SRCARCH) ]; then           \
+				mkdir -p include/asm-$(SRCARCH);           \
+			fi;                                                \
+			ln -fsn asm-$(SRCARCH) $@;                         \
 	fi
+endef
+
+include/asm: FORCE
+	$(Q)$(check-symlink)
+	$(Q)$(create-symlink)
 
 # Generate some files
 # ---------------------------------------------------------------------------
-- 
1.5.6.1.93.gef98

