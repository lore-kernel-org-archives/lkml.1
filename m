Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbXJITr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbXJITr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 15:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbXJITru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 15:47:50 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:36957 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbXJITrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 15:47:49 -0400
Date: Tue, 9 Oct 2007 21:49:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@suse.de>, Adrian Bunk <bunk@kernel.org>
Subject: [PATCH v2] kbuild: save ARCH & CROSS_COMPILE when building a kernel
Message-ID: <20071009194919.GA26726@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When building a kernel for a different architecture
kbuild requires the user always to specify ARCH and
CROSS_COMPILE on the command-line.
Failing to do so can result in strange build errros especially
when the asm symlink point to anohter architecture than
the one being build.
The typical case is that the user forget to specify
ARCH and/or CROSS_COMPILE on the commandline.

Address the above issues by saving ARCH and CROSS_COMPILE
when building a kernel. The information is saved in a
file named ".kbuild" which is not supposed to be manually
edited and kbuild will overwrite it when a kernel is build.

If a kernel is build and no ARCH/CROSS_COMPILE info is saved
then the current settings are saved.
If ARCH/CROSS_COMPILE was saved then these value are used.
If the user specified either ARCH and/or CROSS_COMPILE
it is validated that they match the saved values and kbuild
error out if this is not the case.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
This addressed the comments from Adrian and Andi.
The file is now named ".kbuild".
And the dummy assignmnets are preserved (and commented).

I plan to sneak this patch into the merge window if there
are no complains - despite that I have not tested this in -mm.

diff --git a/Makefile b/Makefile
index 9d06120..6e930ef 100644
--- a/Makefile
+++ b/Makefile
@@ -189,9 +189,39 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 # Default value for CROSS_COMPILE is not to prefix executables
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
 
-ARCH		?= $(SUBARCH)
+# The empty ARCH and CROSS_COMPILE statements exist so it is easy to
+# patch in hardcoded values for ARCH and CROSS_COMPILE
+ARCH		?=
 CROSS_COMPILE	?=
 
+# Kbuild save the ARCH and CROSS_COMPILE setting in .kbuild
+# Restore these settings and check that user did not specify
+# conflicting values.
+.kbuild: ;
+noconfigcheck-targets := clean mrproper distclean help %config
+
+ifneq ($(wildcard .kbuild),)
+        -include .kbuild
+        ifeq ($(filter $(noconfigcheck-targets),$(MAKECMDGOALS)),)
+                ifneq ($(CROSS_COMPILE),)
+                        ifneq ($(CROSS_COMPILE),$(KBUILD_CROSS_COMPILE))
+                                $(error CROSS_COMPILE changed from "$(KBUILD_CROSS_COMPILE)" \
+                                        to "$(CROSS_COMPILE)". Use "make mrproper" to fix it up)
+                        endif
+                endif
+                ifneq ($(ARCH),)
+                        ifneq ($(KBUILD_ARCH),$(ARCH))
+                                $(error ARCH changed from "$(KBUILD_ARCH)" \
+                                        to "$(ARCH)". Use "make mrproper" to fix it up)
+                        endif
+                endif   
+        endif
+        CROSS_COMPILE := $(KBUILD_CROSS_COMPILE)
+        ARCH := $(KBUILD_ARCH)
+else
+        ARCH ?= $(SUBARCH)
+endif
+
 # Architecture as present in compile.h
 UTS_MACHINE := $(ARCH)
 
@@ -358,6 +388,12 @@ scripts_basic:
 # To avoid any implicit rule to kick in, define an empty command.
 scripts/basic/%: scripts_basic ;
 
+# Save CROSS_COMPILE and ARCH for subsequent make invocations
+PHONY += dotkbuild
+dotkbuild:
+	$(Q)echo KBUILD_ARCH := $(ARCH)                   >  .kbuild
+	$(Q)echo KBUILD_CROSS_COMPILE := $(CROSS_COMPILE) >> .kbuild
+
 PHONY += outputmakefile
 # outputmakefile generates a Makefile in the output directory, if using a
 # separate output directory. This allows convenient use of make in the
@@ -420,7 +456,7 @@ ifeq ($(config-targets),1)
 include $(srctree)/arch/$(ARCH)/Makefile
 export KBUILD_DEFCONFIG
 
-config %config: scripts_basic outputmakefile FORCE
+config %config: scripts_basic outputmakefile dotkbuild FORCE
 	$(Q)mkdir -p include/linux include/config
 	$(Q)$(MAKE) $(build)=scripts/kconfig $@
 
@@ -866,7 +902,10 @@ PHONY += prepare archprepare prepare0 prepare1 prepare2 prepare3
 # and if so do:
 # 1) Check that make has not been executed in the kernel src $(srctree)
 # 2) Create the include2 directory, used for the second asm symlink
-prepare3: include/config/kernel.release
+prepare3: include/config/kernel.release dotkbuild
+ifneq ($(KBUILD_CROSS_COMPILE)$(KBUILD_ARCH),)
+	$(Q)echo '  Using ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)'
+endif
 ifneq ($(KBUILD_SRC),)
 	@echo '  Using $(srctree) as source for kernel'
 	$(Q)if [ -f $(srctree)/.config -o -d $(srctree)/include/config ]; then \
@@ -932,10 +971,10 @@ define filechk_version.h
 	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
 endef
 
-include/linux/version.h: $(srctree)/Makefile FORCE
+include/linux/version.h: $(srctree)/Makefile prepare2 FORCE
 	$(call filechk,version.h)
 
-include/linux/utsrelease.h: include/config/kernel.release FORCE
+include/linux/utsrelease.h: include/config/kernel.release prepare2 FORCE
 	$(call filechk,utsrelease.h)
 
 # ---------------------------------------------------------------------------
@@ -1063,7 +1102,7 @@ CLEAN_FILES +=	vmlinux System.map \
 MRPROPER_DIRS  += include/config include2 usr/include
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h include/linux/version.h      \
-                  include/linux/utsrelease.h                            \
+                  include/linux/utsrelease.h .kbuild                    \
 		  Module.symvers tags TAGS cscope*
 
 # clean - Delete most, but leave enough to build external modules
