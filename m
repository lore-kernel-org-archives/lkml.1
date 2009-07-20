Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbZGTKCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbZGTKCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 06:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZGTKB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 06:01:59 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:44536 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbZGTKB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 06:01:58 -0400
Date: Mon, 20 Jul 2009 12:01:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: save ARCH & CROSS_COMPILE when building a kernel
Message-ID: <20090720100157.GA6467@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have tested this locally - but it would
be good if someone with different habits than me try it
out before it hits -next.

So far it works for me.

Last time I tries this it failed in strange ways in different setups.
But I think I have addressed this by postponing the settings to *config
time _after_ including the arch specific makefile.

This patch is a prerequisite for a small serie of patches to clean up
how we handle generated files.

	Sam


>From 9e27e311540fbe0c31d9cdfe731ad60a54ad1202 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 20 Jul 2009 11:49:54 +0200
Subject: [PATCH] kbuild: save ARCH & CROSS_COMPILE when building a kernel

When building a kernel for a different architecture
kbuild requires the user always to specify ARCH and
CROSS_COMPILE on the command-line.

We use the asm symlink to detect if user forgets to
specify the correct ARCH value - but that symlink
is about to die. And we do now want to loose this check.

This patch save the settings of ARCH and CROSS_COMPILE
in a file named ".kbuild".
The settings are saved during "make *config" time
and always read.

If user try to change the settings we error out.

This works both for plain builds and for O=...
builds.
So now you can do:
$ mkdir sparc64
$ make O=sparc64 ARCH=sparc64 CROSS_COMPILE=sparc64-linux- defconfig
$ cd sparc64
$ make

Notice that you no longer need to tell kbuild
the settings of ARCH and CROSS_COMPILE when you type make
in the output directory.
Likewise for plain builds where you do not use O=...

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile |   36 ++++++++++++++++++++++++++++++++++--
 1 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 79957b3..3c95e76 100644
--- a/Makefile
+++ b/Makefile
@@ -179,9 +179,36 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 # Alternatively CROSS_COMPILE can be set in the environment.
 # Default value for CROSS_COMPILE is not to prefix executables
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
+#
+# To force ARCH and CROSS_COMPILE settings include .kbuild
+# in the kernel tree - do not patch this file.
 export KBUILD_BUILDHOST := $(SUBARCH)
-ARCH		?= $(SUBARCH)
-CROSS_COMPILE	?=
+
+# Kbuild save the ARCH and CROSS_COMPILE setting in .kbuild
+# Restore these settings and check that user did not specify
+# conflicting values.
+ifneq ($(wildcard .kbuild),)
+        -include .kbuild
+        ifneq ($(CROSS_COMPILE),)
+                 ifneq ($(CROSS_COMPILE),$(KBUILD_CROSS_COMPILE))
+                        $(error CROSS_COMPILE changed from \
+                                "$(KBUILD_CROSS_COMPILE)" to \
+                                to "$(CROSS_COMPILE)". \
+                                Use "make mrproper" to fix it up)
+                endif
+        endif
+        ifneq ($(ARCH),)
+                ifneq ($(KBUILD_ARCH),$(ARCH))
+                        $(error ARCH changed from \
+                                "$(KBUILD_ARCH)" to "$(ARCH)". \
+                                Use "make mrproper" to fix it up)
+                endif
+        endif
+        CROSS_COMPILE := $(KBUILD_CROSS_COMPILE)
+        ARCH          := $(KBUILD_ARCH)
+else
+        ARCH ?= $(SUBARCH)
+endif
 
 # Architecture as present in compile.h
 UTS_MACHINE 	:= $(ARCH)
@@ -444,6 +471,10 @@ ifeq ($(config-targets),1)
 include $(srctree)/arch/$(SRCARCH)/Makefile
 export KBUILD_DEFCONFIG KBUILD_KCONFIG
 
+# save ARCH & CROSS_COMPILE settings
+$(shell (echo KBUILD_ARCH := $(ARCH) && \
+         echo KBUILD_CROSS_COMPILE := $(CROSS_COMPILE)) > .kbuild)
+
 config: scripts_basic outputmakefile FORCE
 	$(Q)mkdir -p include/linux include/config
 	$(Q)$(MAKE) $(build)=scripts/kconfig $@
@@ -1195,6 +1226,7 @@ CLEAN_FILES +=	vmlinux System.map \
 # Directories & files removed with 'make mrproper'
 MRPROPER_DIRS  += include/config include2 usr/include include/generated
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
+                  .kbuild                                               \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
                   include/linux/bounds.h include/asm*/asm-offsets.h     \
-- 
1.6.2.5

