Return-Path: <linux-kernel-owner+w=401wt.eu-S1762196AbXKCXwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762196AbXKCXwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759483AbXKCXtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:49:52 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59243 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757364AbXKCXto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:49:44 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 09/10] x86: select i386 or x86_64 at config time
Date: Sun,  4 Nov 2007 00:51:19 +0100
Message-Id: <1194133881756-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1194133881972-git-send-email-sam@ravnborg.org>
References: <11941338801315-git-send-email-sam@ravnborg.org> <11941338804007-git-send-email-sam@ravnborg.org> <11941338801910-git-send-email-sam@ravnborg.org> <11941338802525-git-send-email-sam@ravnborg.org> <11941338802646-git-send-email-sam@ravnborg.org> <11941338813125-git-send-email-sam@ravnborg.org> <11941338813105-git-send-email-sam@ravnborg.org> <1194133881972-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Like powerpc and other we now select the actual
architecture during configuration.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/Kconfig         |   26 +++++++++++++++++++++++++-
 arch/x86/Kconfig.i386    |   17 +++--------------
 arch/x86/Kconfig.x86_64  |   16 +++-------------
 scripts/kconfig/Makefile |    7 +------
 4 files changed, 32 insertions(+), 34 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c325606..d51f3c8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1,4 +1,28 @@
+mainmenu "Linux Kernel Configuration"
 
+choice
+	prompt "Architecture?"
+	default X86_32
+
+config X86_32
+	bool "i386"
+	help
+	  This is Linux's home port.  Linux was originally native to the Intel
+	  386, and runs on all the later x86 processors including the Intel
+	  486, 586, Pentiums, and various instruction-set-compatible chips by
+	  AMD, Cyrix, and others.
+
+config X86_64
+	bool "x86_64"
+	help
+	  Port to the x86-64 architecture. x86-64 is a 64-bit extension to the
+	  classical 32-bit x86 architecture. For details see
+	  <http://www.x86-64.org/>.
+
+endchoice
+
+source "arch/x86/Kconfig.i386"
+source "arch/x86/Kconfig.x86_64"
 source "init/Kconfig"
 
 menu "Processor type and features"
@@ -792,8 +816,8 @@ config CRASH_DUMP
 
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
-	default "0x1000000" if X86_NUMAQ
 	default "0x200000"  if X86_64
+	default "0x1000000" if X86_NUMAQ
 	default "0x100000"
 	help
 	  This gives the physical address where the kernel is loaded.
diff --git a/arch/x86/Kconfig.i386 b/arch/x86/Kconfig.i386
index 9fe6c36..c8cc0f2 100644
--- a/arch/x86/Kconfig.i386
+++ b/arch/x86/Kconfig.i386
@@ -1,18 +1,7 @@
+# i386 specific settings
 #
-# For a description of the syntax of this configuration file,
-# see Documentation/kbuild/kconfig-language.txt.
-#
-
-mainmenu "Linux Kernel Configuration"
 
-config X86_32
-	bool
-	default y
-	help
-	  This is Linux's home port.  Linux was originally native to the Intel
-	  386, and runs on all the later x86 processors including the Intel
-	  486, 586, Pentiums, and various instruction-set-compatible chips by
-	  AMD, Cyrix, and others.
+if X86_32
 
 config GENERIC_TIME
 	bool
@@ -296,4 +285,4 @@ config KTIME_SCALAR
 	bool
 	default y
 
-source "arch/x86/Kconfig"
+endif  # X86_32
diff --git a/arch/x86/Kconfig.x86_64 b/arch/x86/Kconfig.x86_64
index 8721902..6eb8a09 100644
--- a/arch/x86/Kconfig.x86_64
+++ b/arch/x86/Kconfig.x86_64
@@ -1,21 +1,11 @@
-#
-# For a description of the syntax of this configuration file,
-# see Documentation/kbuild/kconfig-language.txt.
+# X86_64 specific settings
 #
 # Note: ISA is disabled and will hopefully never be enabled.
 # If you managed to buy an ISA x86-64 box you'll have to fix all the
 # ISA drivers you need yourself.
 #
 
-mainmenu "Linux Kernel Configuration"
-
-config X86_64
-	bool
-	default y
-	help
-	  Port to the x86-64 architecture. x86-64 is a 64-bit extension to the
-	  classical 32-bit x86 architecture. For details see
-	  <http://www.x86-64.org/>.
+if X86_64
 
 config 64BIT
 	def_bool y
@@ -300,4 +290,4 @@ config SYSVIPC_COMPAT
 	depends on COMPAT && SYSVIPC
 	default y
 
-source "arch/x86/Kconfig"
+endif # X86_64
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

