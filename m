Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbYIBGuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbYIBGuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 02:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbYIBGuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 02:50:44 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:56800 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYIBGun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 02:50:43 -0400
To: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Message-Id: <26128d31856e93dc769ca1fc1bfda34c2fdad6d7.1220338208.git.tony@bakeyournoodle.com>
In-Reply-To: <1219617472.21386.226.camel@pasglop>
From: Tony Breeds <tony@bakeyournoodle.com>
Subject: [PATCH 1/1] Work around the fomit-frame-pointer bug
Date: Tue,  2 Sep 2008 16:50:38 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug is causing random crashes
(http://bugzilla.kernel.org/show_bug.cgi?id=11414).  -fomit-frame-pointer is
only needed on powerpc when -pg is also supplied.  This patch ensures that
CONFIG_FRAME_POINTER is only selected by ftrace.  When CONFIG_FTRACE is enabled
we also pass -mno-sched-epilog to work around the codegen bug

Patch based on work by:
	Andreas Schwab <schwab@suse.de>
	Segher Boessenkool <segher@kernel.crashing.org>

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
 arch/powerpc/Makefile                    |    5 +++++
 arch/powerpc/kernel/Makefile             |    7 ++++---
 arch/powerpc/platforms/powermac/Makefile |    2 +-
 lib/Kconfig.debug                        |    6 +++---
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 9155c93..c6be19e 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -116,6 +116,11 @@ ifeq ($(CONFIG_6xx),y)
 KBUILD_CFLAGS		+= -mcpu=powerpc
 endif
 
+# Work around a gcc code-gen bug with -fno-omit-frame-pointer.
+ifeq ($(CONFIG_FTRACE),y)
+KBUILD_CFLAGS		+= -mno-sched-epilog
+endif
+
 cpu-as-$(CONFIG_4xx)		+= -Wa,-m405
 cpu-as-$(CONFIG_6xx)		+= -Wa,-maltivec
 cpu-as-$(CONFIG_POWER4)		+= -Wa,-maltivec
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 64f5948..946daea 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -14,12 +14,13 @@ endif
 
 ifdef CONFIG_FTRACE
 # Do not trace early boot code
-CFLAGS_REMOVE_cputable.o = -pg
-CFLAGS_REMOVE_prom_init.o = -pg
+CFLAGS_REMOVE_cputable.o = -pg -mno-sched-epilog
+CFLAGS_REMOVE_prom_init.o = -pg -mno-sched-epilog
+CFLAGS_REMOVE_btext.o = -pg -mno-sched-epilog
 
 ifdef CONFIG_DYNAMIC_FTRACE
 # dynamic ftrace setup.
-CFLAGS_REMOVE_ftrace.o = -pg
+CFLAGS_REMOVE_ftrace.o = -pg -mno-sched-epilog
 endif
 
 endif
diff --git a/arch/powerpc/platforms/powermac/Makefile b/arch/powerpc/platforms/powermac/Makefile
index 58ecdd7..be60d64 100644
--- a/arch/powerpc/platforms/powermac/Makefile
+++ b/arch/powerpc/platforms/powermac/Makefile
@@ -2,7 +2,7 @@ CFLAGS_bootx_init.o  		+= -fPIC
 
 ifdef CONFIG_FTRACE
 # Do not trace early boot code
-CFLAGS_REMOVE_bootx_init.o = -pg
+CFLAGS_REMOVE_bootx_init.o = -pg -mno-sched-epilog
 endif
 
 obj-y				+= pic.o setup.o time.o feature.o pci.o \
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 800ac84..413eaca 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -394,7 +394,7 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select STACKTRACE
-	select FRAME_POINTER if !X86 && !MIPS
+	select FRAME_POINTER if !X86 && !MIPS && !PPC
 	select KALLSYMS
 	select KALLSYMS_ALL
 
@@ -676,13 +676,13 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
 	depends on !X86_64
 	select STACKTRACE
-	select FRAME_POINTER
+	select FRAME_POINTER if !PPC
 	help
 	  Provide stacktrace filter for fault-injection capabilities
 
 config LATENCYTOP
 	bool "Latency measuring infrastructure"
-	select FRAME_POINTER if !MIPS
+	select FRAME_POINTER if !MIPS && !PPC
 	select KALLSYMS
 	select KALLSYMS_ALL
 	select STACKTRACE
-- 
1.5.6.5

