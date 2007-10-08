Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbXJHUBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbXJHUBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 16:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbXJHUB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 16:01:26 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60003 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbXJHUBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 16:01:25 -0400
Date: Mon, 8 Oct 2007 22:02:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC/RFT] kbuild: save ARCH & CROSS_COMPILE
Message-ID: <20071008200255.GA16497@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One of the complaints that I continue to hear is that kbuild
is lacking a way to 'remember' the ARCH and CROSS_COMPILE
values originally used.
Likewise we have people that change ARCH settings and get
a lot of build errors due to asm symlink pointing at the
wrong directory.

This patch tries to address this by saving ARCH and
CROSS_COMPILE settings and error out if user specify
anohter ARCH or CROSS_COMPILE setting.
If there is inconsistency then error out and suggest
to run make mrproper.

This will as a side-effect prevent a build with the wrong
asm symlink.

The settings are stored in the build directory in a file
named "Kbuild.config" (should it be a .dot file?).

I have tested it here with success - but please give
it a try in your setup and let me know if anything breaks.

The patch is on top of latest linus tree but should apply
with some fuzz to -mm too (at least it apply on top of 
my kbuild.git tree).

PS. I do not like adding additional cruft to the top-level
Makefile but did not find an easy way to push this to
kconfig.

	Sam

diff --git a/Makefile b/Makefile
index 6fc97bf..9f6d03f 100644
--- a/Makefile
+++ b/Makefile
@@ -182,8 +182,33 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 # Default value for CROSS_COMPILE is not to prefix executables
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
 
-ARCH		?= $(SUBARCH)
-CROSS_COMPILE	?=
+# Kbuild save the ARCH and CROSS_COMPILE setting in Kbuild.config
+# Restore these settings and check that user did not specify
+# conflicting values.
+Kbuild.config: ;
+noconfigcheck-targets := clean mrproper distclean help %config
+
+ifneq ($(wildcard Kbuild.config),)
+        -include Kbuild.config
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
 
 # Architecture as present in compile.h
 UTS_MACHINE := $(ARCH)
@@ -351,6 +376,12 @@ scripts_basic:
 # To avoid any implicit rule to kick in, define an empty command.
 scripts/basic/%: scripts_basic ;
 
+# Save CROSS_COMPILE and ARCH for subsequent make invocations
+PHONY += Kbuild.config.save
+Kbuild.config.save:
+	$(Q)echo KBUILD_ARCH := $(ARCH)                   >  Kbuild.config
+	$(Q)echo KBUILD_CROSS_COMPILE := $(CROSS_COMPILE) >> Kbuild.config
+
 PHONY += outputmakefile
 # outputmakefile generates a Makefile in the output directory, if using a
 # separate output directory. This allows convenient use of make in the
@@ -413,7 +444,7 @@ ifeq ($(config-targets),1)
 include $(srctree)/arch/$(ARCH)/Makefile
 export KBUILD_DEFCONFIG
 
-config %config: scripts_basic outputmakefile FORCE
+config %config: scripts_basic outputmakefile Kbuild.config.save FORCE
 	$(Q)mkdir -p include/linux include/config
 	$(Q)$(MAKE) $(build)=scripts/kconfig $@
 
@@ -853,7 +884,10 @@ PHONY += prepare archprepare prepare0 prepare1 prepare2 prepare3
 # and if so do:
 # 1) Check that make has not been executed in the kernel src $(srctree)
 # 2) Create the include2 directory, used for the second asm symlink
-prepare3: include/config/kernel.release
+prepare3: include/config/kernel.release Kbuild.config.save
+ifneq ($(KBUILD_CROSS_COMPILE)$(KBUILD_ARCH),)
+	$(Q)echo '  Using ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)'
+endif
 ifneq ($(KBUILD_SRC),)
 	@echo '  Using $(srctree) as source for kernel'
 	$(Q)if [ -f $(srctree)/.config -o -d $(srctree)/include/config ]; then \
@@ -919,10 +953,10 @@ define filechk_version.h
 	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
 endef
 
-include/linux/version.h: $(srctree)/Makefile FORCE
+include/linux/version.h: $(srctree)/Makefile prepare2 FORCE
 	$(call filechk,version.h)
 
-include/linux/utsrelease.h: include/config/kernel.release FORCE
+include/linux/utsrelease.h: include/config/kernel.release prepare2 FORCE
 	$(call filechk,utsrelease.h)
 
 # ---------------------------------------------------------------------------
@@ -1050,7 +1084,7 @@ CLEAN_FILES +=	vmlinux System.map \
 MRPROPER_DIRS  += include/config include2 usr/include
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h include/linux/version.h      \
-                  include/linux/utsrelease.h                            \
+                  include/linux/utsrelease.h Kbuild.config              \
 		  Module.symvers tags TAGS cscope*
 
 # clean - Delete most, but leave enough to build external modules
