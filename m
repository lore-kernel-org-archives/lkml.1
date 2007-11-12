Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbXKLVDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbXKLVDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 16:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757590AbXKLU7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 15:59:16 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:43501 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbXKLU66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 15:58:58 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: enable "make ARCH=x86"
Date: Mon, 12 Nov 2007 22:00:36 +0100
Message-Id: <1194901236-22820-13-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <1194901236-22820-12-git-send-email-sam@ravnborg.org>
References: <20071112205451.GA22528@uranus.ravnborg.org>
 <1194901236-22820-1-git-send-email-sam@ravnborg.org>
 <1194901236-22820-2-git-send-email-sam@ravnborg.org>
 <1194901236-22820-3-git-send-email-sam@ravnborg.org>
 <1194901236-22820-4-git-send-email-sam@ravnborg.org>
 <1194901236-22820-5-git-send-email-sam@ravnborg.org>
 <1194901236-22820-6-git-send-email-sam@ravnborg.org>
 <1194901236-22820-7-git-send-email-sam@ravnborg.org>
 <1194901236-22820-8-git-send-email-sam@ravnborg.org>
 <1194901236-22820-9-git-send-email-sam@ravnborg.org>
 <1194901236-22820-10-git-send-email-sam@ravnborg.org>
 <1194901236-22820-11-git-send-email-sam@ravnborg.org>
 <1194901236-22820-12-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After unification of the Kconfig files and
introducing K64BIT support in kconfig
it required only trivial changes to enable
"make ARCH=x86".

With this patch you can build for x86_64 in several ways:
1) make ARCH=x86_64
2) make ARCH=x86 K64BIT=y
3) make ARCH=x86 menuconfig
   => select 64-bit

Likewise for i386 with the addition that
i386 is default is you say ARCH=x86.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 Makefile                 |    4 +++-
 arch/x86/Kconfig         |   18 +++++++++++++++---
 arch/x86/Kconfig.i386    |   18 ------------------
 arch/x86/Kconfig.x86_64  |   20 --------------------
 scripts/kconfig/Makefile |    7 +------
 5 files changed, 19 insertions(+), 48 deletions(-)
 delete mode 100644 arch/x86/Kconfig.i386
 delete mode 100644 arch/x86/Kconfig.x86_64

diff --git a/Makefile b/Makefile
index b32963a..9c9c4bf 100644
--- a/Makefile
+++ b/Makefile
@@ -200,9 +200,11 @@ SRCARCH 	:= $(ARCH)
 # Additional ARCH settings for x86
 ifeq ($(ARCH),i386)
         SRCARCH := x86
+        K64BIT  := n
 endif
 ifeq ($(ARCH),x86_64)
         SRCARCH := x86
+        K64BIT  := y
 endif
 
 KCONFIG_CONFIG	?= .config
@@ -339,7 +341,7 @@ KERNELRELEASE = $(shell cat include/config/kernel.release 2> /dev/null)
 KERNELVERSION = $(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
 
 export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
-export ARCH SRCARCH CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
+export ARCH SRCARCH K64BIT CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
 export CPP AR NM STRIP OBJCOPY OBJDUMP MAKE AWK GENKSYMS PERL UTS_MACHINE
 export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 34517bf..1eb5997 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1,13 +1,25 @@
 # x86 configuration
+mainmenu "Linux Kernel Configuration for x86"
+
+# Select 32 or 64 bit
+config 64BIT
+	bool "64-bit kernel"
+	default n
+	help
+	  Say yes to build a 64-bit kernel - formerly known as x86_64
+	  Say no to build a 32-bit kernel - formerly known as i386
+
+config X86_32
+	def_bool !64BIT
+
+config X86_64
+	def_bool 64BIT
 
 ### Arch settings
 config X86
 	bool
 	default y
 
-config 64BIT
-	def_bool X86_64
-
 config GENERIC_TIME
 	bool
 	default y
diff --git a/arch/x86/Kconfig.i386 b/arch/x86/Kconfig.i386
deleted file mode 100644
index 7b8dc26..0000000
--- a/arch/x86/Kconfig.i386
+++ /dev/null
@@ -1,18 +0,0 @@
-#
-# For a description of the syntax of this configuration file,
-# see Documentation/kbuild/kconfig-language.txt.
-#
-
-mainmenu "Linux Kernel Configuration"
-
-config X86_32
-	bool
-	default y
-	help
-	  This is Linux's home port.  Linux was originally native to the Intel
-	  386, and runs on all the later x86 processors including the Intel
-	  486, 586, Pentiums, and various instruction-set-compatible chips by
-	  AMD, Cyrix, and others.
-
-
-source "arch/x86/Kconfig"
diff --git a/arch/x86/Kconfig.x86_64 b/arch/x86/Kconfig.x86_64
deleted file mode 100644
index b262aae..0000000
--- a/arch/x86/Kconfig.x86_64
+++ /dev/null
@@ -1,20 +0,0 @@
-#
-# For a description of the syntax of this configuration file,
-# see Documentation/kbuild/kconfig-language.txt.
-#
-# Note: ISA is disabled and will hopefully never be enabled.
-# If you managed to buy an ISA x86-64 box you'll have to fix all the
-# ISA drivers you need yourself.
-#
-
-mainmenu "Linux Kernel Configuration"
-
-config X86_64
-	bool
-	default y
-	help
-	  Port to the x86-64 architecture. x86-64 is a 64-bit extension to the
-	  classical 32-bit x86 architecture. For details see
-	  <http://www.x86-64.org/>.
-
-source "arch/x86/Kconfig"
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 5959412..1ad6f7f 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -4,12 +4,7 @@
 
 PHONY += oldconfig xconfig gconfig menuconfig config silentoldconfig update-po-config
 
-# If a arch/$(SRCARCH)/Kconfig.$(ARCH) file exist use it
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/Kconfig.$(ARCH)),)
-        Kconfig := arch/$(SRCARCH)/Kconfig.$(ARCH)
-else
-        Kconfig := arch/$(SRCARCH)/Kconfig
-endif
+Kconfig := arch/$(SRCARCH)/Kconfig
 
 xconfig: $(obj)/qconf
 	$< $(Kconfig)
-- 
1.5.3.4.1157.g0e74-dirty

