Return-Path: <linux-kernel-owner+w=401wt.eu-S1760560AbZEBAOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760560AbZEBAOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 20:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbZEBAOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 20:14:22 -0400
Received: from ru.mvista.com ([213.79.90.228]:7145 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753249AbZEBAOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 20:14:21 -0400
Date: Sat, 2 May 2009 04:14:21 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <srostedt@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] powerpc, Makefile: Make it possible to safely select
	CONFIG_FRAME_POINTER
Message-ID: <20090502001421.GA9342@oksana.dev.rtsoft.ru>
References: <20090502001329.GA11549@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090502001329.GA11549@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces HAVE_NORMAL_FRAME_POINTER Kconfig symbol. When
defined, the top level Makefile won't add -fno-omit-frame-pointer
cflag (the flag is useless for PowerPC kernels, and also makes gcc
generate wrong code).

Also move ARCH_WANT_FRAME_POINTERS's help text.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 Makefile             |    7 +++++--
 arch/powerpc/Kconfig |    1 +
 lib/Kconfig.debug    |   16 ++++++++++------
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index b18afad..bfa58ea 100644
--- a/Makefile
+++ b/Makefile
@@ -543,9 +543,12 @@ KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
 endif
 
 ifdef CONFIG_FRAME_POINTER
-KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
+        KBUILD_CFLAGS += -fno-optimize-sibling-calls
+        ifndef CONFIG_HAVE_NORMAL_FRAME_POINTER
+                KBUILD_CFLAGS += -fno-omit-frame-pointer
+        endif
 else
-KBUILD_CFLAGS	+= -fomit-frame-pointer
+        KBUILD_CFLAGS += -fomit-frame-pointer
 endif
 
 ifdef CONFIG_DEBUG_INFO
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 4c78045..b29a6c3 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -119,6 +119,7 @@ config PPC
 	select HAVE_KPROBES
 	select HAVE_ARCH_KGDB
 	select HAVE_KRETPROBES
+	select HAVE_NORMAL_FRAME_POINTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_LMB
 	select HAVE_DMA_ATTRS if PPC64
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 444002b..1f1633b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -660,20 +660,24 @@ config DEBUG_NOTIFIERS
 	  This is a relatively cheap check but if you care about maximum
 	  performance, say N.
 
-#
-# Select this config option from the architecture Kconfig, if it
-# it is preferred to always offer frame pointers as a config
-# option on the architecture (regardless of KERNEL_DEBUG):
-#
 config ARCH_WANT_FRAME_POINTERS
 	bool
 	help
+	  Select this config option from the architecture Kconfig, if it
+	  it is preferred to always offer frame pointers as a config
+	  option on the architecture (regardless of KERNEL_DEBUG).
+
+config HAVE_NORMAL_FRAME_POINTER
+	bool
+	help
+	  Architectures should select this symbol if their ABI implies
+	  having a frame pointer.
 
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && \
 		(CRIS || M68K || M68KNOMMU || FRV || UML || \
-		 AVR32 || SUPERH || BLACKFIN || MN10300) || \
+		 AVR32 || SUPERH || BLACKFIN || MN10300 || PPC) || \
 		ARCH_WANT_FRAME_POINTERS
 	default y if (DEBUG_INFO && UML) || ARCH_WANT_FRAME_POINTERS
 	help
-- 
1.6.2.2

