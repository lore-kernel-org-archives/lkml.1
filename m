Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbZDRTxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbZDRTxg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 15:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbZDRTxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 15:53:16 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:42452 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbZDRTxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 15:53:15 -0400
Date: Sat, 18 Apr 2009 21:55:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, takata@linux-m32r.org,
       Christoph Hellwig <hch@lst.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] arm: use include/gen for mach-types.h
Message-ID: <20090418195521.GA26697@uranus.ravnborg.org>
References: <20090416150707.GA941@lst.de> <20090416164050.GB4850@uranus.ravnborg.org> <swfmyag9fx8.wl%takata.hirokazu@renesas.com> <alpine.LFD.2.00.0904171034140.4042@localhost.localdomain> <20090417221440.GA16791@uranus.ravnborg.org> <20090418101444.GA9768@flint.arm.linux.org.uk> <20090418181714.GA25786@uranus.ravnborg.org> <alpine.LFD.2.00.0904181226170.4042@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904181226170.4042@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mach-types.h is a generated file.
As we no longer has a .gitignore file in asm-arm the risk
that somebody by accident commit mach-types.h is big.

Avoid this by the introduction of include/generated/ to
hold this (and soon other) generated files.

The patch includes two small cleanups to arch/arm/Makefile.
1) delete stale comment
2) combine two targets in one line and drop unused prerequisite

The idea to introduce include/generated/ is originally from Al Viro.

This is the first user of include/generated and therefore this
patch include changes in top-level Makefile and top-level
.gitignore to support include/generated

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---

This patch addresses comments by Al and Linus:
- use include/generated/
- just ignore all of include/generated
- remove include/generated directory in make mrproper

	Sam

diff --git a/.gitignore b/.gitignore
index 869e1a3..51bd99d 100644
--- a/.gitignore
+++ b/.gitignore
@@ -49,6 +49,7 @@ include/linux/compile.h
 include/linux/version.h
 include/linux/utsrelease.h
 include/linux/bounds.h
+include/generated
 
 # stgit generated dirs
 patches-*
diff --git a/Makefile b/Makefile
index bfdef56..6f4208f 100644
--- a/Makefile
+++ b/Makefile
@@ -1200,7 +1200,7 @@ CLEAN_FILES +=	vmlinux System.map \
                 .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
 
 # Directories & files removed with 'make mrproper'
-MRPROPER_DIRS  += include/config include2 usr/include
+MRPROPER_DIRS  += include/config include2 usr/include include/generated
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index e84729b..1bedda1 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -214,15 +214,9 @@ all:	$(KBUILD_IMAGE)
 
 boot := arch/arm/boot
 
-#	Update machine arch and proc symlinks if something which affects
-#	them changed.  We use .arch to indicate when they were updated
-#	last, otherwise make uses the target directory mtime.
-
-archprepare: maketools
-
 PHONY += maketools FORCE
-maketools: include/linux/version.h FORCE
-	$(Q)$(MAKE) $(build)=arch/arm/tools include/asm-arm/mach-types.h
+archprepare maketools:
+	$(Q)$(MAKE) $(build)=arch/arm/tools include/generated/mach-types.h
 
 # Convert bzImage to zImage
 bzImage: zImage
@@ -233,9 +227,6 @@ zImage Image xipImage bootpImage uImage: vmlinux
 zinstall install: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
 
-CLEAN_FILES += include/asm-arm/mach-types.h \
-	       include/asm-arm/arch include/asm-arm/.arch
-
 # We use MRPROPER_FILES and CLEAN_FILES now
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
diff --git a/arch/arm/include/asm/mach-types.h b/arch/arm/include/asm/mach-types.h
new file mode 100644
index 0000000..b44d1a1
--- /dev/null
+++ b/arch/arm/include/asm/mach-types.h
@@ -0,0 +1,4 @@
+# mach-types is the list of machine types supported by arm
+# This file allow us to use: <asm/mach-types.h> when including mach-types
+
+#include <generated/mach-types.h>
diff --git a/arch/arm/tools/Makefile b/arch/arm/tools/Makefile
index 1dbaa29..635cb18 100644
--- a/arch/arm/tools/Makefile
+++ b/arch/arm/tools/Makefile
@@ -4,7 +4,7 @@
 # Copyright (C) 2001 Russell King
 #
 
-include/asm-arm/mach-types.h: $(src)/gen-mach-types $(src)/mach-types
+include/generated/mach-types.h: $(src)/gen-mach-types $(src)/mach-types
 	@echo '  Generating $@'
 	@mkdir -p $(dir $@)
 	$(Q)$(AWK) -f $^ > $@ || { rm -f $@; /bin/false; }

