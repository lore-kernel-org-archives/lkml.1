Return-Path: <linux-kernel-owner+w=401wt.eu-S1758550AbXJYUBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbXJYUBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbXJYUB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:01:28 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:56606 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbXJYUB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:01:26 -0400
Date: Thu, 25 Oct 2007 22:03:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [PATCH 1/6] x86: move i386 and x86_64 Makefiles to arch/x86
Message-ID: <20071025200300.GB14501@uranus.ravnborg.org>
References: <20071025195644.GA14501@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025195644.GA14501@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9d80894bef9805c70795f73ce1758d2a9e4cb077 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 25 Oct 2007 19:42:04 +0200
Subject: [PATCH] x86: move i386 and x86_64 Makefiles to arch/x86

Moving the ARCH specific Makefiles for i386 and x86_64
required a litle bit tweaking in the top-lvel Makefile.

SRCARCH is now set in the top-level Makefile
because we need this info to include the correct
arch Makefile.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile                                        |    7 +++++--
 arch/x86/Makefile                               |   13 +++++++++++++
 arch/{i386/Makefile => x86/Makefile_32}         |    7 ++-----
 arch/{i386/Makefile.cpu => x86/Makefile_32.cpu} |    0 
 arch/{x86_64/Makefile => x86/Makefile_64}       |    5 +----
 5 files changed, 21 insertions(+), 11 deletions(-)
 create mode 100644 arch/x86/Makefile
 rename arch/{i386/Makefile => x86/Makefile_32} (98%)
 rename arch/{i386/Makefile.cpu => x86/Makefile_32.cpu} (100%)
 rename arch/{x86_64/Makefile => x86/Makefile_64} (99%)

diff --git a/Makefile b/Makefile
index 2a47290..8816060 100644
--- a/Makefile
+++ b/Makefile
@@ -196,6 +196,9 @@ CROSS_COMPILE	?=
 UTS_MACHINE 	:= $(ARCH)
 SRCARCH 	:= $(ARCH)
 
+# for i386 and x86_64 we use SRCARCH equal to x86
+SRCARCH := $(if $(filter x86_64 i386,$(SRCARCH)),x86,$(SRCARCH))
+
 KCONFIG_CONFIG	?= .config
 
 # SHELL used by kbuild
@@ -418,7 +421,7 @@ ifeq ($(config-targets),1)
 # Read arch specific Makefile to set KBUILD_DEFCONFIG as needed.
 # KBUILD_DEFCONFIG may point out an alternative default configuration
 # used for 'make defconfig'
-include $(srctree)/arch/$(ARCH)/Makefile
+include $(srctree)/arch/$(SRCARCH)/Makefile
 export KBUILD_DEFCONFIG
 
 config %config: scripts_basic outputmakefile FORCE
@@ -497,7 +500,7 @@ else
 KBUILD_CFLAGS	+= -O2
 endif
 
-include $(srctree)/arch/$(ARCH)/Makefile
+include $(srctree)/arch/$(SRCARCH)/Makefile
 
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
new file mode 100644
index 0000000..65077d7
--- /dev/null
+++ b/arch/x86/Makefile
@@ -0,0 +1,13 @@
+# Unified Makefile for i386 and x86_64
+
+# No need to remake these files
+$(srctree)/arch/x86/Makefile%: ;
+
+ifeq ($(ARCH),i386)
+        include $(srctree)/arch/x86/Makefile_32
+else
+        include $(srctree)/arch/x86/Makefile_64
+endif
+
+
+
diff --git a/arch/i386/Makefile b/arch/x86/Makefile_32
similarity index 98%
rename from arch/i386/Makefile
rename to arch/x86/Makefile_32
index f5b9a37..346ac07 100644
--- a/arch/i386/Makefile
+++ b/arch/x86/Makefile_32
@@ -1,5 +1,5 @@
 #
-# i386/Makefile
+# i386 Makefile
 #
 # This file is included by the global makefile so that you can add your own
 # architecture-specific flags and dependencies. Remember to do have actions
@@ -17,9 +17,6 @@
 # 20050320  Kianusch Sayah Karadji <kianusch@sk-tech.net>
 #           Added support for GEODE CPU
 
-# Fill in SRCARCH
-SRCARCH	:= x86
-
 # BITS is used as extension for files which are available in a 32 bit
 # and a 64 bit version to simplify shared Makefiles.
 # e.g.: obj-y += foo_$(BITS).o
@@ -46,7 +43,7 @@ KBUILD_CFLAGS += -pipe -msoft-float -mregparm=3 -freg-struct-return
 KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=2)
 
 # CPU-specific tuning. Anything which can be shared with UML should go here.
-include $(srctree)/arch/i386/Makefile.cpu
+include $(srctree)/arch/x86/Makefile_32.cpu
 
 # temporary until string.h is fixed
 cflags-y += -ffreestanding
diff --git a/arch/i386/Makefile.cpu b/arch/x86/Makefile_32.cpu
similarity index 100%
rename from arch/i386/Makefile.cpu
rename to arch/x86/Makefile_32.cpu
diff --git a/arch/x86_64/Makefile b/arch/x86/Makefile_64
similarity index 99%
rename from arch/x86_64/Makefile
rename to arch/x86/Makefile_64
index 20eb69b..57e714a 100644
--- a/arch/x86_64/Makefile
+++ b/arch/x86/Makefile_64
@@ -1,5 +1,5 @@
 #
-# x86_64/Makefile
+# x86_64 Makefile
 #
 # This file is included by the global makefile so that you can add your own
 # architecture-specific flags and dependencies. Remember to do have actions
@@ -21,9 +21,6 @@
 #
 # $Id: Makefile,v 1.31 2002/03/22 15:56:07 ak Exp $
 
-# Fill in SRCARCH
-SRCARCH	:= x86
-
 # BITS is used as extension for files which are available in a 32 bit
 # and a 64 bit version to simplify shared Makefiles.
 # e.g.: obj-y += foo_$(BITS).o
-- 
1.5.3.4.1157.g0e74-dirty

