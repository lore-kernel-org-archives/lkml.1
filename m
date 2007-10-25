Return-Path: <linux-kernel-owner+w=401wt.eu-S1760535AbXJYUDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535AbXJYUDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbXJYUDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:03:00 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:57093 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbXJYUC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:02:59 -0400
Date: Thu, 25 Oct 2007 22:04:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [PATCH 3/6] x86: unification of i386 and x86_64 Kconfig.debug
Message-ID: <20071025200434.GD14501@uranus.ravnborg.org>
References: <20071025195644.GA14501@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025195644.GA14501@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 16b853f53463e43bfce341965ac10a78a3755a14 Mon Sep 17 00:00:00 2001
From: Randy Dunlap <rdunlap@xenotime.net>
Date: Wed, 24 Oct 2007 15:50:43 -0700
Subject: [PATCH] x86: unification of i386 and x86_64 Kconfig.debug

Adding proper dependencies so the two Kconfig.debug files
are now identical.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/i386/Kconfig.debug             |   51 ++++++++++++++++++++++++++++-------
 arch/x86_64/Kconfig                 |    4 ---
 arch/{i386 => x86_64}/Kconfig.debug |   51 ++++++++++++++++++++++++++++-------
 3 files changed, 82 insertions(+), 24 deletions(-)
 copy arch/{i386 => x86_64}/Kconfig.debug (65%)

diff --git a/arch/i386/Kconfig.debug b/arch/i386/Kconfig.debug
index f03531e..970b2de 100644
--- a/arch/i386/Kconfig.debug
+++ b/arch/i386/Kconfig.debug
@@ -1,14 +1,14 @@
 menu "Kernel hacking"
 
 config TRACE_IRQFLAGS_SUPPORT
-	bool
-	default y
+	def_bool y
 
 source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
 	bool "Early printk" if EMBEDDED && DEBUG_KERNEL
 	default y
+	depends on X86_32
 	help
 	  Write kernel log output directly into the VGA buffer or to a serial
 	  port.
@@ -37,10 +37,12 @@ config DEBUG_STACK_USAGE
 
 comment "Page alloc debug is incompatible with Software Suspend on i386"
 	depends on DEBUG_KERNEL && HIBERNATION
+	depends on X86_32
 
 config DEBUG_PAGEALLOC
 	bool "Debug page memory allocations"
 	depends on DEBUG_KERNEL && !HIBERNATION && !HUGETLBFS
+	depends on X86_32
 	help
 	  Unmap pages from the kernel linear mapping after free_pages().
 	  This results in a large slowdown, but helps to find certain types
@@ -59,6 +61,7 @@ config DEBUG_RODATA
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
 	depends on DEBUG_KERNEL
+	depends on X86_32
 	help
 	  If you say Y here the kernel will use a 4Kb stacksize for the
 	  kernel stack attached to each process/thread. This facilitates
@@ -67,22 +70,50 @@ config 4KSTACKS
 	  will also use IRQ stacks to compensate for the reduced stackspace.
 
 config X86_FIND_SMP_CONFIG
-	bool
+	def_bool y
 	depends on X86_LOCAL_APIC || X86_VOYAGER
-	default y
+	depends on X86_32
 
 config X86_MPPARSE
-	bool
+	def_bool y
 	depends on X86_LOCAL_APIC && !X86_VISWS
-	default y
+	depends on X86_32
 
 config DOUBLEFAULT
 	default y
 	bool "Enable doublefault exception handler" if EMBEDDED
+	depends on X86_32
+	help
+	  This option allows trapping of rare doublefault exceptions that
+	  would otherwise cause a system to silently reboot. Disabling this
+	  option saves about 4k and might cause you much additional grey
+	  hair.
+
+config IOMMU_DEBUG
+	bool "Enable IOMMU debugging"
+	depends on IOMMU && DEBUG_KERNEL
+	depends on X86_64
 	help
-          This option allows trapping of rare doublefault exceptions that
-          would otherwise cause a system to silently reboot. Disabling this
-          option saves about 4k and might cause you much additional grey
-          hair.
+	  Force the IOMMU to on even when you have less than 4GB of
+	  memory and add debugging code. On overflow always panic. And
+	  allow to enable IOMMU leak tracing. Can be disabled at boot
+	  time with iommu=noforce. This will also enable scatter gather
+	  list merging.  Currently not recommended for production
+	  code. When you use it make sure you have a big enough
+	  IOMMU/AGP aperture.  Most of the options enabled by this can
+	  be set more finegrained using the iommu= command line
+	  options. See Documentation/x86_64/boot-options.txt for more
+	  details.
+
+config IOMMU_LEAK
+	bool "IOMMU leak tracing"
+	depends on DEBUG_KERNEL
+	depends on IOMMU_DEBUG
+	help
+	  Add a simple leak tracer to the IOMMU code. This is useful when you
+	  are debugging a buggy device driver that leaks IOMMU mappings.
+
+#config X86_REMOTE_DEBUG
+#	bool "kgdb debugging stub"
 
 endmenu
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 308970a..1bc0268 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -97,10 +97,6 @@ config X86_CMPXCHG
 	bool
 	default y
 
-config EARLY_PRINTK
-	bool
-	default y
-
 config GENERIC_ISA_DMA
 	bool
 	default y
diff --git a/arch/i386/Kconfig.debug b/arch/x86_64/Kconfig.debug
similarity index 65%
copy from arch/i386/Kconfig.debug
copy to arch/x86_64/Kconfig.debug
index f03531e..970b2de 100644
--- a/arch/i386/Kconfig.debug
+++ b/arch/x86_64/Kconfig.debug
@@ -1,14 +1,14 @@
 menu "Kernel hacking"
 
 config TRACE_IRQFLAGS_SUPPORT
-	bool
-	default y
+	def_bool y
 
 source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
 	bool "Early printk" if EMBEDDED && DEBUG_KERNEL
 	default y
+	depends on X86_32
 	help
 	  Write kernel log output directly into the VGA buffer or to a serial
 	  port.
@@ -37,10 +37,12 @@ config DEBUG_STACK_USAGE
 
 comment "Page alloc debug is incompatible with Software Suspend on i386"
 	depends on DEBUG_KERNEL && HIBERNATION
+	depends on X86_32
 
 config DEBUG_PAGEALLOC
 	bool "Debug page memory allocations"
 	depends on DEBUG_KERNEL && !HIBERNATION && !HUGETLBFS
+	depends on X86_32
 	help
 	  Unmap pages from the kernel linear mapping after free_pages().
 	  This results in a large slowdown, but helps to find certain types
@@ -59,6 +61,7 @@ config DEBUG_RODATA
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
 	depends on DEBUG_KERNEL
+	depends on X86_32
 	help
 	  If you say Y here the kernel will use a 4Kb stacksize for the
 	  kernel stack attached to each process/thread. This facilitates
@@ -67,22 +70,50 @@ config 4KSTACKS
 	  will also use IRQ stacks to compensate for the reduced stackspace.
 
 config X86_FIND_SMP_CONFIG
-	bool
+	def_bool y
 	depends on X86_LOCAL_APIC || X86_VOYAGER
-	default y
+	depends on X86_32
 
 config X86_MPPARSE
-	bool
+	def_bool y
 	depends on X86_LOCAL_APIC && !X86_VISWS
-	default y
+	depends on X86_32
 
 config DOUBLEFAULT
 	default y
 	bool "Enable doublefault exception handler" if EMBEDDED
+	depends on X86_32
+	help
+	  This option allows trapping of rare doublefault exceptions that
+	  would otherwise cause a system to silently reboot. Disabling this
+	  option saves about 4k and might cause you much additional grey
+	  hair.
+
+config IOMMU_DEBUG
+	bool "Enable IOMMU debugging"
+	depends on IOMMU && DEBUG_KERNEL
+	depends on X86_64
 	help
-          This option allows trapping of rare doublefault exceptions that
-          would otherwise cause a system to silently reboot. Disabling this
-          option saves about 4k and might cause you much additional grey
-          hair.
+	  Force the IOMMU to on even when you have less than 4GB of
+	  memory and add debugging code. On overflow always panic. And
+	  allow to enable IOMMU leak tracing. Can be disabled at boot
+	  time with iommu=noforce. This will also enable scatter gather
+	  list merging.  Currently not recommended for production
+	  code. When you use it make sure you have a big enough
+	  IOMMU/AGP aperture.  Most of the options enabled by this can
+	  be set more finegrained using the iommu= command line
+	  options. See Documentation/x86_64/boot-options.txt for more
+	  details.
+
+config IOMMU_LEAK
+	bool "IOMMU leak tracing"
+	depends on DEBUG_KERNEL
+	depends on IOMMU_DEBUG
+	help
+	  Add a simple leak tracer to the IOMMU code. This is useful when you
+	  are debugging a buggy device driver that leaks IOMMU mappings.
+
+#config X86_REMOTE_DEBUG
+#	bool "kgdb debugging stub"
 
 endmenu
-- 
1.5.3.4.1157.g0e74-dirty

