Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbZCTQoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbZCTQoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 12:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757883AbZCTQod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 12:44:33 -0400
Received: from [213.79.90.228] ([213.79.90.228]:41439 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757756AbZCTQoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 12:44:32 -0400
Date: Fri, 20 Mar 2009 19:44:29 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <srostedt@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] powerpc, Makefile: Make it possible to safely select
	CONFIG_FRAME_POINTER
Message-ID: <20090320164429.GA28037@oksana.dev.rtsoft.ru>
References: <20090320164404.GA19933@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090320164404.GA19933@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces ARCH_HAS_NORMAL_FRAME_POINTERS Kconfig symbol.
When defined, the top level Makefile won't add -fno-omit-frame-pointer
cflag (the flag is useless in PowerPC kernels, and also makes gcc
generate wrong code).

Also move ARCH_WANT_FRAME_POINTERS's help text.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 Makefile             |    7 +++++--
 arch/powerpc/Kconfig |    1 +
 lib/Kconfig.debug    |   16 ++++++++++------
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index 46c04c5..bf41b05 100644
--- a/Makefile
+++ b/Makefile
@@ -538,9 +538,12 @@ KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
 endif
 
 ifdef CONFIG_FRAME_POINTER
-KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
+  KBUILD_CFLAGS	+= -fno-optimize-sibling-calls
+  ifndef ARCH_HAS_NORMAL_FRAME_POINTERS
+    KBUILD_CFLAGS	+= -fno-omit-frame-pointer
+  endif
 else
-KBUILD_CFLAGS	+= -fomit-frame-pointer
+  KBUILD_CFLAGS	+= -fomit-frame-pointer
 endif
 
 ifdef CONFIG_DEBUG_INFO
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 97f9a64..4587e66 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -113,6 +113,7 @@ config PPC
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_HAS_NORMAL_FRAME_POINTERS
 	select HAVE_IDE
 	select HAVE_IOREMAP_PROT
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4b63b6b..fc8cd1f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -661,20 +661,24 @@ config DEBUG_NOTIFIERS
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
+config ARCH_HAS_NORMAL_FRAME_POINTERS
+	bool
+	help
+	  Architectures should select this symbol if their ABI implies
+	  having a frame pointer.
 
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && \
 		(CRIS || M68K || M68KNOMMU || FRV || UML || S390 || \
-		 AVR32 || SUPERH || BLACKFIN || MN10300) || \
+		 AVR32 || SUPERH || BLACKFIN || MN10300 || PPC) || \
 		ARCH_WANT_FRAME_POINTERS
 	default y if (DEBUG_INFO && UML) || ARCH_WANT_FRAME_POINTERS
 	help
-- 
1.5.6.5

