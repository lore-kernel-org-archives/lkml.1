Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbXKJUmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbXKJUmd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 15:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbXKJUlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 15:41:52 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:33964 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbXKJUlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 15:41:50 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86: introduce ARCH=i386,ARCH=x86_64 to select 32/64 bit
Date: Sat, 10 Nov 2007 21:43:29 +0100
Message-Id: <11947274090-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11947274092719-git-send-email-sam@ravnborg.org>
References: <20071110204038.GA13140@uranus.ravnborg.org> <11947274093185-git-send-email-sam@ravnborg.org> <11947274091127-git-send-email-sam@ravnborg.org> <11947274093213-git-send-email-sam@ravnborg.org> <11947274092719-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Using the newly added infrastructure is is now simple
to add addition ARCH= symbols to select between 32 and 64 bit.
Do this for x86.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile                 |   16 +++++++++++++---
 arch/x86/Makefile        |   10 +++++++---
 scripts/kconfig/Makefile |    2 +-
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index 902082b..5efee80 100644
--- a/Makefile
+++ b/Makefile
@@ -165,8 +165,7 @@ export srctree objtree VPATH TOPDIR
 # then ARCH is assigned, getting whatever value it gets normally, and 
 # SUBARCH is subsequently ignored.
 
-SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/        \
-				  -e s/sun4u/sparc64/                    \
+SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 				  -e s/arm.*/arm/ -e s/sa110/arm/ \
 				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
@@ -198,8 +197,19 @@ CROSS_COMPILE	?=
 UTS_MACHINE 	:= $(ARCH)
 SRCARCH 	:= $(ARCH)
 
+ifeq ($(ARCH),i386)
+        K64BIT := n
+        SRCARCH   := x86
+endif
+ifeq ($(ARCH),x86_64)
+        K64BIT := y
+        SRCARCH := x86
+endif
+export K64BIT
+
+
 # Sanity check the specified ARCH
-ifeq ($(wildcard $(srctree)/arch/$(ARCH)/Kconfig),)
+ifeq ($(wildcard $(srctree)/arch/$(SRCARCH)/Kconfig),)
         $(error "ERROR: ARCH ($(ARCH)) does not exist (for i386 and x86_64 use ARCH=x86)")
 endif
 
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index ee94224..feba761 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -1,9 +1,13 @@
 # Unified Makefile for i386 and x86_64
 
 # select i386 defconfig file as default config
-KBUILD_DEFCONFIG := i386_defconfig
-
-# # No need to remake these files
+ifeq ($(ARCH),x86)
+        KBUILD_DEFCONFIG := i386_defconfig
+else
+        KBUILD_DEFCONFIG := $(ARCH)_defconfig
+endif
+        
+# No need to remake these files
 $(srctree)/arch/x86/Makefile%: ;
 
 ifeq ($(CONFIG_X86_32),y)
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 3c9db07..1ad6f7f 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -4,7 +4,7 @@
 
 PHONY += oldconfig xconfig gconfig menuconfig config silentoldconfig update-po-config
 
-Kconfig := arch/$(ARCH)/Kconfig
+Kconfig := arch/$(SRCARCH)/Kconfig
 
 xconfig: $(obj)/qconf
 	$< $(Kconfig)
-- 
1.5.3.4.1157.g0e74-dirty

