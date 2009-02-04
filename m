Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbZBDPJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbZBDPJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbZBDPIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:08:41 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:60214 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752643AbZBDPIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:08:39 -0500
Date: Wed, 4 Feb 2009 18:08:38 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: [PATCH 2/3] powerpc: Make it possible to safely select
	CONFIG_FRAME_POINTER
Message-ID: <20090204150838.GB30027@oksana.dev.rtsoft.ru>
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090204150755.GA24163@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove -fno-omit-frame-pointer flag from CFLAGS.
Remove -fno-omit-frame-pointer workarounds.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/Makefile                    |   10 ++++++----
 arch/powerpc/kernel/Makefile             |   10 +++++-----
 arch/powerpc/platforms/powermac/Makefile |    2 +-
 lib/Kconfig.debug                        |    8 ++++----
 4 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 72d17f5..627aa7f 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -120,10 +120,12 @@ ifeq ($(CONFIG_6xx),y)
 KBUILD_CFLAGS		+= -mcpu=powerpc
 endif
 
-# Work around a gcc code-gen bug with -fno-omit-frame-pointer.
-ifeq ($(CONFIG_FUNCTION_TRACER),y)
-KBUILD_CFLAGS		+= -mno-sched-epilog
-endif
+# Remove -fno-omit-frame-pointer flag. There are two reasons:
+# 1. On powerpc we always have frame pointers.
+# 2. Some gcc versions might generate wrong code with -fno-omit-frame-pointer
+#    flag. So, if for some reason you're going to remove this line, then add
+#    -mno-sched-epilog to workaround the gcc bug.
+KBUILD_CFLAGS := $(subst -fno-omit-frame-pointer,,$(KBUILD_CFLAGS))
 
 cpu-as-$(CONFIG_4xx)		+= -Wa,-m405
 cpu-as-$(CONFIG_6xx)		+= -Wa,-maltivec
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 8d1a419..a97f215 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -14,14 +14,14 @@ endif
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace early boot code
-CFLAGS_REMOVE_cputable.o = -pg -mno-sched-epilog
-CFLAGS_REMOVE_prom_init.o = -pg -mno-sched-epilog
-CFLAGS_REMOVE_btext.o = -pg -mno-sched-epilog
-CFLAGS_REMOVE_prom.o = -pg -mno-sched-epilog
+CFLAGS_REMOVE_cputable.o = -pg
+CFLAGS_REMOVE_prom_init.o = -pg
+CFLAGS_REMOVE_btext.o = -pg
+CFLAGS_REMOVE_prom.o = -pg
 
 ifdef CONFIG_DYNAMIC_FTRACE
 # dynamic ftrace setup.
-CFLAGS_REMOVE_ftrace.o = -pg -mno-sched-epilog
+CFLAGS_REMOVE_ftrace.o = -pg
 endif
 
 endif
diff --git a/arch/powerpc/platforms/powermac/Makefile b/arch/powerpc/platforms/powermac/Makefile
index 50f1693..0eb8781 100644
--- a/arch/powerpc/platforms/powermac/Makefile
+++ b/arch/powerpc/platforms/powermac/Makefile
@@ -2,7 +2,7 @@ CFLAGS_bootx_init.o  		+= -fPIC
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace early boot code
-CFLAGS_REMOVE_bootx_init.o = -pg -mno-sched-epilog
+CFLAGS_REMOVE_bootx_init.o = -pg
 endif
 
 obj-y				+= pic.o setup.o time.o feature.o pci.o \
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 29044f5..657126c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -402,7 +402,7 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select STACKTRACE
-	select FRAME_POINTER if !X86 && !MIPS && !PPC
+	select FRAME_POINTER if !X86 && !MIPS
 	select KALLSYMS
 	select KALLSYMS_ALL
 
@@ -583,7 +583,7 @@ config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && \
 		(CRIS || M68K || M68KNOMMU || FRV || UML || S390 || \
-		 AVR32 || SUPERH || BLACKFIN || MN10300) || \
+		 AVR32 || SUPERH || BLACKFIN || MN10300 || PPC) || \
 		ARCH_WANT_FRAME_POINTERS
 	default y if (DEBUG_INFO && UML) || ARCH_WANT_FRAME_POINTERS
 	help
@@ -771,13 +771,13 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
 	depends on !X86_64
 	select STACKTRACE
-	select FRAME_POINTER if !PPC
+	select FRAME_POINTER
 	help
 	  Provide stacktrace filter for fault-injection capabilities
 
 config LATENCYTOP
 	bool "Latency measuring infrastructure"
-	select FRAME_POINTER if !MIPS && !PPC
+	select FRAME_POINTER if !MIPS
 	select KALLSYMS
 	select KALLSYMS_ALL
 	select STACKTRACE
-- 
1.5.6.5

