Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbXL2Ul2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbXL2Ul2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 15:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXL2UlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 15:41:19 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:44548 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbXL2UlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 15:41:18 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@saturn.ravnborg.org>, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/5] x86: biarch support for 32 bit builds beautified
Date: Sat, 29 Dec 2007 21:41:14 +0100
Message-Id: <1198960876-21159-3-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <1198960876-21159-2-git-send-email-sam@ravnborg.org>
References: <20071229203836.GA21020@uranus.ravnborg.org>
 <1198960876-21159-1-git-send-email-sam@ravnborg.org>
 <1198960876-21159-2-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@saturn.ravnborg.org>

There were no reason to mess around with CC, AS and LD.
Fixing this up avoided duplicated option for ld.

A small fixlet were needed in boot/Makefile which assumed
that CC were modified.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/Makefile      |   11 ++++-------
 arch/x86/boot/Makefile |    4 +---
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 4124df5..027929e 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -15,18 +15,15 @@ export BITS
 ifeq ($(CONFIG_X86_32),y)
         BITS := 32
         UTS_MACHINE := i386
+        CHECKFLAGS += -D__i386__
 
-        HAS_BIARCH := $(call cc-option-yn, -m32)
-        ifeq ($(HAS_BIARCH),y)
-                AS := $(AS) --32
-                LD := $(LD) -m elf_i386
-                CC := $(CC) -m32
-        endif
+        biarch := $(call cc-option,-m32)
+        KBUILD_AFLAGS += $(biarch)
+        KBUILD_CFLAGS += $(biarch)
 
         ifdef CONFIG_RELOCATABLE
                 LDFLAGS_vmlinux := --emit-relocs
         endif
-        CHECKFLAGS += -D__i386__
 
         KBUILD_CFLAGS += -msoft-float -mregparm=3 -freg-struct-return
 
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 7a3116c..dcad650 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -49,10 +49,7 @@ HOSTCFLAGS_build.o := $(LINUXINCLUDE)
 
 # How to compile the 16-bit code.  Note we always compile for -march=i386,
 # that way we can complain to the user if the CPU is insufficient.
-cflags-$(CONFIG_X86_32) :=
-cflags-$(CONFIG_X86_64) := -m32
 KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
-		   $(cflags-y) \
 		   -Wall -Wstrict-prototypes \
 		   -march=i386 -mregparm=3 \
 		   -include $(srctree)/$(src)/code16gcc.h \
@@ -62,6 +59,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
 			$(call cc-option, -fno-unit-at-a-time)) \
 		   $(call cc-option, -fno-stack-protector) \
 		   $(call cc-option, -mpreferred-stack-boundary=2)
+KBUILD_CFLAGS +=   $(call cc-option,-m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 
 $(obj)/zImage:  IMAGE_OFFSET := 0x1000
-- 
1.5.3.7.1112.g9758e

