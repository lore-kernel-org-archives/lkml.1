Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbXK0AP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbXK0AP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757546AbXK0AOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:14:34 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49123 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756909AbXK0AOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:14:31 -0500
Message-Id: <20071127001430.313046247@sgi.com>
References: <20071127001407.859743255@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 26 Nov 2007 16:14:12 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>
Subject: [patch 05/14] percpu: Use a Kconfig variable to configure arch specific percpu setup
Content-Disposition: inline; filename=arch_sets_up_per_cpu_areas
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The use of the __GENERIC_PERCPU is a bit problematic since arches
may want to run their own percpu setup while using the generic
percpu definitions. Replace it through a kconfig variable.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/ia64/Kconfig            |    4 ++++
 arch/powerpc/Kconfig         |    4 ++++
 arch/sparc64/Kconfig         |    4 ++++
 arch/x86/Kconfig             |    6 +++---
 include/asm-generic/percpu.h |    1 -
 include/asm-s390/percpu.h    |    2 --
 include/asm-x86/percpu_32.h  |    2 --
 init/main.c                  |    4 ++--
 8 files changed, 17 insertions(+), 10 deletions(-)

Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c	2007-11-26 15:38:56.407111768 -0800
+++ linux-2.6/init/main.c	2007-11-26 15:40:10.425862722 -0800
@@ -363,7 +363,7 @@ static inline void smp_prepare_cpus(unsi
 
 #else
 
-#ifdef __GENERIC_PER_CPU
+#ifndef CONFIG_ARCH_SETS_UP_PER_CPU_AREA
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 
 EXPORT_SYMBOL(__per_cpu_offset);
@@ -384,7 +384,7 @@ static void __init setup_per_cpu_areas(v
 		ptr += size;
 	}
 }
-#endif /* !__GENERIC_PER_CPU */
+#endif /* CONFIG_ARCH_SETS_UP_CPU_AREA */
 
 /* Called by boot processor to activate the rest. */
 static void __init smp_init(void)
Index: linux-2.6/arch/ia64/Kconfig
===================================================================
--- linux-2.6.orig/arch/ia64/Kconfig	2007-11-26 15:38:56.415112360 -0800
+++ linux-2.6/arch/ia64/Kconfig	2007-11-26 15:40:10.425862722 -0800
@@ -75,6 +75,10 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default y
 
+config ARCH_SETS_UP_PER_CPU_AREA
+	bool
+	default y
+
 config DMI
 	bool
 	default y
Index: linux-2.6/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.orig/arch/powerpc/Kconfig	2007-11-26 15:38:56.427111914 -0800
+++ linux-2.6/arch/powerpc/Kconfig	2007-11-26 15:40:10.425862722 -0800
@@ -42,6 +42,10 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
+config ARCH_SETS_UP_PER_CPU_AREA
+	bool
+	default PPC64
+
 config IRQ_PER_CPU
 	bool
 	default y
Index: linux-2.6/arch/sparc64/Kconfig
===================================================================
--- linux-2.6.orig/arch/sparc64/Kconfig	2007-11-26 15:38:56.447111936 -0800
+++ linux-2.6/arch/sparc64/Kconfig	2007-11-26 15:40:10.425862722 -0800
@@ -66,6 +66,10 @@ config AUDIT_ARCH
 	bool
 	default y
 
+config ARCH_SETS_UP_PER_CPU_AREA
+	bool
+	default y
+
 config ARCH_NO_VIRT_TO_BUS
 	def_bool y
 
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig	2007-11-26 15:38:58.234361975 -0800
+++ linux-2.6/arch/x86/Kconfig	2007-11-26 15:40:52.465611449 -0800
@@ -112,9 +112,9 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default X86_64
 
-
-
-
+config ARCH_SETS_UP_PER_CPU_AREA
+	bool
+	default X86_64
 
 config ZONE_DMA32
 	bool
Index: linux-2.6/include/asm-generic/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-generic/percpu.h	2007-11-26 15:40:04.469611815 -0800
+++ linux-2.6/include/asm-generic/percpu.h	2007-11-26 15:40:10.437861790 -0800
@@ -3,7 +3,6 @@
 #include <linux/compiler.h>
 #include <linux/threads.h>
 
-#define __GENERIC_PER_CPU
 #ifdef CONFIG_SMP
 
 extern unsigned long __per_cpu_offset[NR_CPUS];
Index: linux-2.6/include/asm-x86/percpu_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/percpu_32.h	2007-11-26 15:40:04.469611815 -0800
+++ linux-2.6/include/asm-x86/percpu_32.h	2007-11-26 15:40:10.441861845 -0800
@@ -41,8 +41,6 @@
  *    PER_CPU(cpu_gdt_descr, %ebx)
  */
 #ifdef CONFIG_SMP
-/* Same as generic implementation except for optimized local access. */
-#define __GENERIC_PER_CPU
 
 /* This is used for other cpus to find our section. */
 extern unsigned long __per_cpu_offset[];
Index: linux-2.6/include/asm-s390/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-s390/percpu.h	2007-11-26 15:40:04.469611815 -0800
+++ linux-2.6/include/asm-s390/percpu.h	2007-11-26 15:40:10.441861845 -0800
@@ -4,8 +4,6 @@
 #include <linux/compiler.h>
 #include <asm/lowcore.h>
 
-#define __GENERIC_PER_CPU
-
 /*
  * s390 uses its own implementation for per cpu data, the offset of
  * the cpu local data area is cached in the cpu's lowcore memory.

-- 
