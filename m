Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbZGUVRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbZGUVRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbZGUVRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:17:52 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:54741 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbZGUVP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:15:58 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
       <linux-arch@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 06/10] kbuild: drop asm symlink
Date: Tue, 21 Jul 2009 23:19:37 +0200
Message-Id: <1248211181-6757-6-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20090721211040.GA7688@merkur.ravnborg.org>
References: <20090721211040.GA7688@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generated files are no longer saved in include/asm
so there is no use left of this.

This also allowed us to get rid of the ugly "include2"
directory used for O=... builds.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 .gitignore |    1 -
 Makefile   |   51 +++++----------------------------------------------
 2 files changed, 5 insertions(+), 47 deletions(-)

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
index 1f6a34c..100dfd1 100644
--- a/Makefile
+++ b/Makefile
@@ -334,7 +334,7 @@ CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
 # Use LINUXINCLUDE when you must reference the include/ directory.
 # Needed to be compatible with the O= option
 LINUXINCLUDE    := -Iinclude \
-                   $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
+                   $(if $(KBUILD_SRC), -I$(srctree)/include)           \
                    -I$(srctree)/arch/$(hdr-arch)/include               \
                    -include include/linux/autoconf.h
 
@@ -940,7 +940,7 @@ include/config/kernel.release: include/config/auto.conf FORCE
 # Things we need to do before we recursively start building the kernel
 # or the modules are listed in "prepare".
 # A multi level approach is used. prepareN is processed before prepareN-1.
-# archprepare is used in arch Makefiles and when processed asm symlink,
+# archprepare is used in arch Makefiles when
 # version.h and scripts_basic is processed / created.
 
 # Listed in dependency order
@@ -949,7 +949,6 @@ PHONY += prepare archprepare prepare0 prepare1 prepare2 prepare3
 # prepare3 is used to check if we are building in a separate output directory,
 # and if so do:
 # 1) Check that make has not been executed in the kernel src $(srctree)
-# 2) Create the include2 directory, used for the second asm symlink
 prepare3: include/config/kernel.release
 ifneq ($(KBUILD_SRC),)
 	@$(kecho) '  Using $(srctree) as source for kernel'
@@ -958,17 +957,13 @@ ifneq ($(KBUILD_SRC),)
 		echo "  in the '$(srctree)' directory.";\
 		/bin/false; \
 	fi;
-	$(Q)if [ ! -d include2 ]; then                                  \
-	    mkdir -p include2;                                          \
-	    ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
-	fi
 endif
 
 # prepare2 creates a makefile if using a separate output directory
 prepare2: prepare3 outputmakefile
 
 prepare1: prepare2 include/linux/version.h include/linux/utsrelease.h \
-                   include/asm include/config/auto.conf
+                   include/config/auto.conf
 	$(cmd_crmodverdir)
 
 archprepare: prepare1 scripts_basic
@@ -985,42 +980,6 @@ prepare: prepare0
 
 export CPPFLAGS_vmlinux.lds += -P -C -U$(ARCH)
 
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
 
@@ -1193,8 +1152,8 @@ CLEAN_FILES +=	vmlinux System.map \
                 .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
 
 # Directories & files removed with 'make mrproper'
-MRPROPER_DIRS  += include/config include2 usr/include include/generated
-MRPROPER_FILES += .config .config.old include/asm .version .old_version \
+MRPROPER_DIRS  += include/config usr/include include/generated
+MRPROPER_FILES += .config .config.old .version .old_version             \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
 		  Module.symvers Module.markers tags TAGS cscope*
-- 
1.6.2.5

