Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbZAERSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbZAERSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZAERSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:18:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36603 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZAERSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:18:45 -0500
To: torvalds@linux-foundation.org
Subject: get rid of the last symlink in uml build
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Message-Id: <E1LJt6A-0003SJ-SY@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 05 Jan 2009 17:18:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We need to make asm-offsets.h contents visible for objects built
with userland headers.  Instead of creating a symlink, just have the
file with equivalent include (relative to location of header) created
once.  That kills the last symlink used in arch/um builds.

Additionally, both generated headers can become dependencies of
archprepare now, killing the misuse of prepare.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/Makefile |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index d944c34..0728def 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -22,10 +22,11 @@ MODE_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/include/shared/skas
 
 include $(srctree)/$(ARCH_DIR)/Makefile-skas
 
-ARCH_INCLUDE	:= -I$(srctree)/$(ARCH_DIR)/include/shared
+SHARED_HEADERS	:= $(ARCH_DIR)/include/shared
+ARCH_INCLUDE	:= -I$(srctree)/$(SHARED_HEADERS)
 ARCH_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)/shared
 ifneq ($(KBUILD_SRC),)
-ARCH_INCLUDE	+= -I$(ARCH_DIR)/include/shared # for two generated files
+ARCH_INCLUDE	+= -I$(SHARED_HEADERS)
 endif
 KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)
 
@@ -85,8 +86,8 @@ endef
 
 KBUILD_KCONFIG := arch/um/Kconfig.$(HEADER_ARCH)
 
-archprepare: $(ARCH_DIR)/include/shared/user_constants.h
-prepare: $(ARCH_DIR)/include/shared/kern_constants.h
+archprepare: $(SHARED_HEADERS)/user_constants.h
+archprepare: $(SHARED_HEADERS)/kern_constants.h
 
 LINK-$(CONFIG_LD_SCRIPT_STATIC) += -static
 LINK-$(CONFIG_LD_SCRIPT_DYN) += -Wl,-rpath,/lib
@@ -119,17 +120,13 @@ endef
 # When cleaning we don't include .config, so we don't include
 # TT or skas makefiles and don't clean skas_ptregs.h.
 CLEAN_FILES += linux x.i gmon.out \
-	$(ARCH_DIR)/include/shared/user_constants.h \
-	$(ARCH_DIR)/include/shared/kern_constants.h
+	$(SHARED_HEADERS)/user_constants.h \
+	$(SHARED_HEADERS)/kern_constants.h
 
 archclean:
 	@find . \( -name '*.bb' -o -name '*.bbg' -o -name '*.da' \
 		-o -name '*.gcov' \) -type f -print | xargs rm -f
 
-$(objtree)/$(ARCH_DIR)/include/shared:
-	@echo '  MKDIR $@'
-	$(Q)mkdir -p $@
-
 # Generated files
 
 $(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s: FORCE
@@ -148,11 +145,11 @@ define filechk_gen-asm-offsets
          echo ""; )
 endef
 
-$(ARCH_DIR)/include/shared/user_constants.h: $(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s
+$(SHARED_HEADERS)/user_constants.h: $(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s
 	$(call filechk,gen-asm-offsets)
 
-$(ARCH_DIR)/include/shared/kern_constants.h: $(objtree)/$(ARCH_DIR)/include/shared
-	@echo '  SYMLINK $@'
-	$(Q)ln -sf ../../../../include/asm/asm-offsets.h $@
+$(SHARED_HEADERS)/kern_constants.h:
+	$(Q)mkdir -p $(dir $@)
+	$(Q)echo '#include "../../../../include/asm/asm-offsets.h"' >$@
 
 export SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS HEADER_ARCH DEV_NULL_PATH
-- 
1.5.6.5

