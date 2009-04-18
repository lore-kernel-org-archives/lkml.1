Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbZDRSP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbZDRSP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 14:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZDRSPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 14:15:12 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:54453 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbZDRSPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 14:15:11 -0400
Date: Sat, 18 Apr 2009 20:17:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, takata@linux-m32r.org,
       Christoph Hellwig <hch@lst.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] arm: use include/gen for mach-types.h
Message-ID: <20090418181714.GA25786@uranus.ravnborg.org>
References: <20090416150707.GA941@lst.de> <20090416164050.GB4850@uranus.ravnborg.org> <swfmyag9fx8.wl%takata.hirokazu@renesas.com> <alpine.LFD.2.00.0904171034140.4042@localhost.localdomain> <20090417221440.GA16791@uranus.ravnborg.org> <20090418101444.GA9768@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090418101444.GA9768@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mach-types.h is a generated file.
As we no longer has a .gitignore file in asm-arm the risk
that somebody by accident commit mach-types.h is big.

Avoid this by the introduction of include/gen/ to
hold this (and soon other) generated files.

The patch includes two small cleanups to arch/arm/Makefile.
1) delete stale comment
2) combine two targets in one line and drop unused prerequisite

The idea to introduce include/gen/ is originally from Al Viro.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---

Hi Russell.
This patch is _not_ tested - as I have yet to get the
arm toolchain operational.
But it looks trivial correct.

Please consider applying.

	Sam

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index e84729b..b50dfa0 100644
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
+	$(Q)$(MAKE) $(build)=arch/arm/tools include/gen/mach-types.h
 
 # Convert bzImage to zImage
 bzImage: zImage
@@ -233,8 +227,7 @@ zImage Image xipImage bootpImage uImage: vmlinux
 zinstall install: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
 
-CLEAN_FILES += include/asm-arm/mach-types.h \
-	       include/asm-arm/arch include/asm-arm/.arch
+CLEAN_FILES += include/gen/mach-types.h
 
 # We use MRPROPER_FILES and CLEAN_FILES now
 archclean:
diff --git a/arch/arm/include/asm/mach-types.h b/arch/arm/include/asm/mach-types.h
new file mode 100644
index 0000000..e6fcab7
--- /dev/null
+++ b/arch/arm/include/asm/mach-types.h
@@ -0,0 +1,4 @@
+# mach-types is the list of machine types supported by arm
+# This file allow us to use: <asm/mach-types.h> when including mach-types
+
+#incude <gen/mach-types.h>
diff --git a/arch/arm/tools/Makefile b/arch/arm/tools/Makefile
index 1dbaa29..63a6aae 100644
--- a/arch/arm/tools/Makefile
+++ b/arch/arm/tools/Makefile
@@ -4,7 +4,7 @@
 # Copyright (C) 2001 Russell King
 #
 
-include/asm-arm/mach-types.h: $(src)/gen-mach-types $(src)/mach-types
+include/gen/mach-types.h: $(src)/gen-mach-types $(src)/mach-types
 	@echo '  Generating $@'
 	@mkdir -p $(dir $@)
 	$(Q)$(AWK) -f $^ > $@ || { rm -f $@; /bin/false; }
diff --git a/include/gen/.gitignore b/include/gen/.gitignore
new file mode 100644
index 0000000..1e809fd
--- /dev/null
+++ b/include/gen/.gitignore
@@ -0,0 +1,2 @@
+# mach-types.h is used by arm
+mach-types.h
