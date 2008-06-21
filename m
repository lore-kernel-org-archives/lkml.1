Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbYFUWIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbYFUWIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 18:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbYFUWIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 18:08:09 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41806 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbYFUWII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 18:08:08 -0400
Date: Sun, 22 Jun 2008 00:08:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] kbuild: support arch/$ARCH/include/...
Message-ID: <20080621220851.GC12279@uranus.ravnborg.org>
References: <20080621220703.GA12279@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080621220703.GA12279@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d888d09887a0231e494e7009d855bd3e3c35bfd9 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 21 Jun 2008 01:07:38 +0200
Subject: [PATCH] kbuild: support arch/$ARCH/include/...

Unconditionally add arch/$ARCH/include to the gcc search path.
Create asm symlink only when we need them
Save asm-offset in include/asm
Delete include/asm during mrproper being it a link or a directory

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Kbuild   |    2 +-
 Makefile |   35 ++++++++++++++++++++---------------
 2 files changed, 21 insertions(+), 16 deletions(-)

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
index e309a87..70dc0a8 100644
--- a/Makefile
+++ b/Makefile
@@ -329,7 +329,8 @@ AFLAGS_KERNEL	=
 # Needed to be compatible with the O= option
 LINUXINCLUDE    := -Iinclude \
                    $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
-		   -include include/linux/autoconf.h
+                   -I$(srctree)/arch/$(hdr-arch)/include               \
+                   -include include/linux/autoconf.h
 
 KBUILD_CPPFLAGS := -D__KERNEL__ $(LINUXINCLUDE)
 
@@ -921,7 +922,9 @@ ifneq ($(KBUILD_SRC),)
 		/bin/false; \
 	fi;
 	$(Q)if [ ! -d include2 ]; then mkdir -p include2; fi;
-	$(Q)ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm
+	$(Q)if [ -e $(srctree)/include/asm-$(SRCARCH)/system.h ]; then  \
+	    ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
+	    fi
 endif
 
 # prepare2 creates a makefile if using a separate output directory
@@ -949,19 +952,21 @@ export CPPFLAGS_vmlinux.lds += -P -C -U$(ARCH)
 # Detect this and ask user to run make mrproper
 
 include/asm: FORCE
-	$(Q)set -e; asmlink=`readlink include/asm | cut -d '-' -f 2`;   \
-	if [ -L include/asm ]; then                                     \
-		if [ "$$asmlink" != "$(SRCARCH)" ]; then                \
+	$(Q)set -e; asmlink=`readlink include/asm | cut -d '-' -f 2`;      \
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
+	else                                                               \
+		if [ -e $(srctree)/include/asm-$(SRCARCH)/system.h ]; then \
+			echo '  SYMLINK $@ -> include/asm-$(SRCARCH)';     \
+			if [ ! -d include ]; then                          \
+				mkdir -p include;                          \
+			fi;                                                \
+			ln -fsn asm-$(SRCARCH) $@;                         \
+		fi                                                         \
 	fi
 
 # Generate some files
@@ -1120,8 +1125,8 @@ CLEAN_FILES +=	vmlinux System.map \
                 .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
 
 # Directories & files removed with 'make mrproper'
-MRPROPER_DIRS  += include/config include2 usr/include
-MRPROPER_FILES += .config .config.old include/asm .version .old_version \
+MRPROPER_DIRS  += include/config include2 usr/include include/asm
+MRPROPER_FILES += .config .config.old .version .old_version             \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
                   include/linux/bounds.h include/asm*/asm-offsets.h     \
-- 
1.5.4.1.143.ge7e51

