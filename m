Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757586AbYLQGNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbYLQGNK (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 01:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbYLQGMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 01:12:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54067 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbYLQGMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 01:12:54 -0500
Date: Wed, 17 Dec 2008 06:12:50 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: jdike@addtoit.com
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: [PATCH] get rid of the last symlink in uml build
Message-ID: <20081217061250.GX28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	We need to make asm-offsets.h contents visible for objects built
with userland headers.  Instead of creating a symlink, just have the
file with equivalent include (relative to location of header) created
once.

	That kills the last symlink used in arch/um builds.  Have fun...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/um/Makefile b/arch/um/Makefile
index d944c34..3fd7e45 100644
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
+prepare: $(SHARED_HEADERS)/kern_constants.h
 
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
