Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbYKCVAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbYKCVAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYKCVAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:00:44 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:39177 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYKCVAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:00:43 -0500
Date: Mon, 3 Nov 2008 21:40:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Chris Zankel <chris@zankel.net>, LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PSEUDO PATCH] xtensa: move headers files to arch/xtensa/include
Message-ID: <20081103204042.GA1334@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris.

Following is an untested receipe to move all header files for xtensa
to arch/xtensa/include.
As well as moving the files it gets rid of all uses of symlinks
in the Makefile.

We have done so already for the majority of the architectures
and xtensa is one out of six missing.

Please consider applying and submitting to Linus ASAP.
Linus will most likely accept such a patch even this late to
get all arches moved over to use arch/$ARCH/include.

You can add:
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
to the final commit.

Or you can ask Linus to execute the follwing steps if you do not
have a git tree handy.

	Sam


Step 1) - execute the following script:
#!/bin/sh
set -e

mkdir -p arch/xtensa/include/asm
mkdir -p arch/xtensa/include/variant-dc232b/variant
mkdir -p arch/xtensa/include/variant-fsf/variant
mkdir -p arch/xtensa/include/platform-iss

git mv include/asm-xtensa/variant-dc232b/* arch/xtensa/include/variant-dc232b/variant
rmdir include/asm-xtensa/variant-dc232b

git mv include/asm-xtensa/variant-fsf/*    arch/xtensa/include/variant-fsf/variant
rmdir include/asm-xtensa/variant-fsf

git mv include/asm-xtensa/platform-iss/* arch/xtensa/include/platform-iss
rmdir include/asm-xtensa/platform-iss

git mv include/asm-xtensa/* arch/xtensa/include/asm
rmdir include/asm-xtensa


Step 2) apply the following patch
diff --git a/arch/xtensa/Makefile b/arch/xtensa/Makefile
index 015b6b2..d51cfc0 100644
--- a/arch/xtensa/Makefile
+++ b/arch/xtensa/Makefile
@@ -32,6 +32,8 @@ export PLATFORM
 KBUILD_CFLAGS += -ffreestanding
 
 KBUILD_CFLAGS += -pipe -mlongcalls
+KBUILD_CFLAGS += -Iarch/xtensa/include/platform-$(platform-y)
+KBUILD_CFLAGS += -Iarch/xtensa/include/variant-$(variant-y)
 
 KBUILD_DEFCONFIG := iss_defconfig
 
@@ -66,21 +68,6 @@ libs-y		+= arch/xtensa/lib/ $(LIBGCC)
 
 boot		:= arch/xtensa/boot
 
-archinc		:= include/asm-xtensa
-
-archprepare: $(archinc)/.platform
-
-# Update processor variant and platform symlinks if something which affects
-# them changed.
-
-$(archinc)/.platform: $(wildcard include/config/arch/*.h) include/config/auto.conf
-	@echo '  SYMLINK $(archinc)/variant -> $(archinc)/variant-$(VARIANT)'
-	$(Q)mkdir -p $(archinc)
-	$(Q)ln -fsn $(srctree)/$(archinc)/variant-$(VARIANT) $(archinc)/variant
-	@echo '  SYMLINK $(archinc)/platform -> $(archinc)/platform-$(PLATFORM)'
-	$(Q)ln -fsn $(srctree)/$(archinc)/platform-$(PLATFORM) $(archinc)/platform
-	@touch $@
-
 
 all: zImage
 
@@ -89,10 +76,6 @@ bzImage : zImage
 zImage zImage.initrd: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $@
 
-CLEAN_FILES	+= arch/xtensa/vmlinux.lds                      \
-		   $(archinc)/platform $(archinc)/variant	\
-		   $(archinc)/.platform
-
 define archhelp
   @echo '* zImage      - Compressed kernel image (arch/xtensa/boot/images/zImage.*)'
 endef
diff --git a/arch/xtensa/boot/boot-elf/boot.lds.S b/arch/xtensa/boot/boot-elf/boot.lds.S
index 849dfca..4e53b74 100644
--- a/arch/xtensa/boot/boot-elf/boot.lds.S
+++ b/arch/xtensa/boot/boot-elf/boot.lds.S
@@ -1,4 +1,4 @@
-#include <asm/variant/core.h>
+#include <variant/core.h>
 OUTPUT_ARCH(xtensa)
 ENTRY(_ResetVector)
 
diff --git a/arch/xtensa/boot/boot-redboot/bootstrap.S b/arch/xtensa/boot/boot-redboot/bootstrap.S
index 8484812..5582e8c 100644
--- a/arch/xtensa/boot/boot-redboot/bootstrap.S
+++ b/arch/xtensa/boot/boot-redboot/bootstrap.S
@@ -1,4 +1,4 @@
-#include <asm/variant/core.h>
+#include <variant/core.h>
 #include <asm/regs.h>
 #include <asm/asmmacro.h>
 #include <asm/cacheasm.h>
diff --git a/arch/xtensa/kernel/entry.S b/arch/xtensa/kernel/entry.S
index dfd35dc..a51d36a 100644
--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -25,7 +25,7 @@
 #include <asm/page.h>
 #include <asm/signal.h>
 #include <asm/tlbflush.h>
-#include <asm/variant/tie-asm.h>
+#include <variant/tie-asm.h>
 
 /* Unimplemented features. */
 
diff --git a/arch/xtensa/kernel/vmlinux.lds.S b/arch/xtensa/kernel/vmlinux.lds.S
index 51f4fb6..d506774 100644
--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -16,7 +16,7 @@
 
 #include <asm-generic/vmlinux.lds.h>
 
-#include <asm/variant/core.h>
+#include <variant/core.h>
 OUTPUT_ARCH(xtensa)
 ENTRY(_start)
 
diff --git a/arch/xtensa/lib/checksum.S b/arch/xtensa/lib/checksum.S
index 9d9cd99..df397f9 100644
--- a/arch/xtensa/lib/checksum.S
+++ b/arch/xtensa/lib/checksum.S
@@ -16,7 +16,7 @@
 
 #include <asm/errno.h>
 #include <linux/linkage.h>
-#include <asm/variant/core.h>
+#include <variant/core.h>
 
 /*
  * computes a partial checksum, e.g. for TCP/UDP fragments
diff --git a/arch/xtensa/lib/memcopy.S b/arch/xtensa/lib/memcopy.S
index ddda8f4..ea59dcd 100644
--- a/arch/xtensa/lib/memcopy.S
+++ b/arch/xtensa/lib/memcopy.S
@@ -9,7 +9,7 @@
  * Copyright (C) 2002 - 2005 Tensilica Inc.
  */
 
-#include <asm/variant/core.h>
+#include <variant/core.h>
 
 	.macro	src_b	r, w0, w1
 #ifdef __XTENSA_EB__
diff --git a/arch/xtensa/lib/memset.S b/arch/xtensa/lib/memset.S
index 56a1749..10b8c40 100644
--- a/arch/xtensa/lib/memset.S
+++ b/arch/xtensa/lib/memset.S
@@ -11,7 +11,7 @@
  *  Copyright (C) 2002 Tensilica Inc.
  */
 
-#include <asm/variant/core.h>
+#include <variant/core.h>
 
 /*
  * void *memset(void *dst, int c, size_t length)
diff --git a/arch/xtensa/lib/strncpy_user.S b/arch/xtensa/lib/strncpy_user.S
index b2655d9..9f603cd 100644
--- a/arch/xtensa/lib/strncpy_user.S
+++ b/arch/xtensa/lib/strncpy_user.S
@@ -11,7 +11,7 @@
  *  Copyright (C) 2002 Tensilica Inc.
  */
 
-#include <asm/variant/core.h>
+#include <variant/core.h>
 #include <linux/errno.h>
 
 /* Load or store instructions that may cause exceptions use the EX macro. */
diff --git a/arch/xtensa/lib/strnlen_user.S b/arch/xtensa/lib/strnlen_user.S
index ad3f616..23f2a89 100644
--- a/arch/xtensa/lib/strnlen_user.S
+++ b/arch/xtensa/lib/strnlen_user.S
@@ -11,7 +11,7 @@
  *  Copyright (C) 2002 Tensilica Inc.
  */
 
-#include <asm/variant/core.h>
+#include <variant/core.h>
 
 /* Load or store instructions that may cause exceptions use the EX macro. */
 
diff --git a/arch/xtensa/lib/usercopy.S b/arch/xtensa/lib/usercopy.S
index a8ab1d4..46d6031 100644
--- a/arch/xtensa/lib/usercopy.S
+++ b/arch/xtensa/lib/usercopy.S
@@ -53,7 +53,7 @@
  *	a11/ original length
  */
 
-#include <asm/variant/core.h>
+#include <variant/core.h>
 
 #ifdef __XTENSA_EB__
 #define ALIGN(R, W0, W1) src	R, W0, W1
diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index 9141e36..cd7344a 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -24,7 +24,7 @@
 #include <asm/uaccess.h>
 #include <asm/irq.h>
 
-#include <asm/platform/simcall.h>
+#include <platform-iss/simcall.h>
 
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
diff --git a/arch/xtensa/platforms/iss/io.c b/arch/xtensa/platforms/iss/io.c
index 5b161a5..b44a98b 100644
--- a/arch/xtensa/platforms/iss/io.c
+++ b/arch/xtensa/platforms/iss/io.c
@@ -3,7 +3,7 @@
 #if 0
 
 #include <asm/io.h>
-#include <xtensa/simcall.h>
+#include <platform-iss/simcall.h>
 
 extern int __simc ();
 
diff --git a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/iss/network.c
index 11a20ad..b775d04 100644
--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -33,7 +33,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/platform_device.h>
 
-#include <asm/platform/simcall.h>
+#include <platform-iss/simcall.h>
 
 #define DRIVER_NAME "iss-netdev"
 #define ETH_MAX_PACKET 1500
