Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbXK1VPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbXK1VPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 16:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbXK1VP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 16:15:29 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56231 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755130AbXK1VP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 16:15:27 -0500
Message-Id: <20071128211526.149834716@sgi.com>
References: <20071128210926.008783214@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 28 Nov 2007 13:09:27 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>
Subject: [patch 01/10] percpu: Use a kconfig variable to signal arch specific percpu setup
Content-Disposition: inline; filename=arch_sets_up_per_cpu_areas
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

V1->V2:
- Use def_bool as suggested by Randy.

The use of the __GENERIC_PERCPU is a bit problematic since arches
may want to run their own percpu setup while using the generic
percpu definitions. Replace it through a kconfig variable.



Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/ia64/Kconfig            |    3 +++
 arch/powerpc/Kconfig         |    3 +++
 arch/sparc64/Kconfig         |    3 +++
 arch/x86/Kconfig             |    5 ++---
 include/asm-generic/percpu.h |    1 -
 include/asm-s390/percpu.h    |    2 --
 include/asm-x86/percpu_32.h  |    2 --
 init/main.c                  |    4 ++--
 8 files changed, 13 insertions(+), 10 deletions(-)

Index: linux-2.6.24-rc3-mm2/init/main.c
===================================================================
--- linux-2.6.24-rc3-mm2.orig/init/main.c	2007-11-28 12:51:28.288463092 -0800
+++ linux-2.6.24-rc3-mm2/init/main.c	2007-11-28 12:51:38.636214129 -0800
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
Index: linux-2.6.24-rc3-mm2/arch/ia64/Kconfig
===================================================================
--- linux-2.6.24-rc3-mm2.orig/arch/ia64/Kconfig	2007-11-28 12:51:28.300463519 -0800
+++ linux-2.6.24-rc3-mm2/arch/ia64/Kconfig	2007-11-28 12:51:38.640213057 -0800
@@ -75,6 +75,9 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default y
 
+config ARCH_SETS_UP_PER_CPU_AREA
+	def_bool y
+
 config DMI
 	bool
 	default y
Index: linux-2.6.24-rc3-mm2/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.24-rc3-mm2.orig/arch/powerpc/Kconfig	2007-11-28 12:51:28.312463458 -0800
+++ linux-2.6.24-rc3-mm2/arch/powerpc/Kconfig	2007-11-28 12:51:38.640213057 -0800
@@ -42,6 +42,9 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
+config ARCH_SETS_UP_PER_CPU_AREA
+	def_bool PPC64
+
 config IRQ_PER_CPU
 	bool
 	default y
Index: linux-2.6.24-rc3-mm2/arch/sparc64/Kconfig
===================================================================
--- linux-2.6.24-rc3-mm2.orig/arch/sparc64/Kconfig	2007-11-28 12:51:28.391963652 -0800
+++ linux-2.6.24-rc3-mm2/arch/sparc64/Kconfig	2007-11-28 12:51:38.640213057 -0800
@@ -66,6 +66,9 @@ config AUDIT_ARCH
 	bool
 	default y
 
+config ARCH_SETS_UP_PER_CPU_AREA
+	def_bool y
+
 config ARCH_NO_VIRT_TO_BUS
 	def_bool y
 
Index: linux-2.6.24-rc3-mm2/arch/x86/Kconfig
===================================================================
--- linux-2.6.24-rc3-mm2.orig/arch/x86/Kconfig	2007-11-28 12:51:28.407962976 -0800
+++ linux-2.6.24-rc3-mm2/arch/x86/Kconfig	2007-11-28 12:51:38.782051096 -0800
@@ -120,9 +120,8 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default X86_64
 
-
-
-
+config ARCH_SETS_UP_PER_CPU_AREA
+	def_bool X86_64
 
 config ZONE_DMA32
 	bool
Index: linux-2.6.24-rc3-mm2/include/asm-generic/percpu.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-generic/percpu.h	2007-11-28 12:51:28.419963226 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-generic/percpu.h	2007-11-28 12:51:38.782051096 -0800
@@ -3,7 +3,6 @@
 #include <linux/compiler.h>
 #include <linux/threads.h>
 
-#define __GENERIC_PER_CPU
 #ifdef CONFIG_SMP
 
 extern unsigned long __per_cpu_offset[NR_CPUS];
Index: linux-2.6.24-rc3-mm2/include/asm-x86/percpu_32.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-x86/percpu_32.h	2007-11-28 12:51:28.431963118 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-x86/percpu_32.h	2007-11-28 12:51:38.782051096 -0800
@@ -41,8 +41,6 @@
  *    PER_CPU(cpu_gdt_descr, %ebx)
  */
 #ifdef CONFIG_SMP
-/* Same as generic implementation except for optimized local access. */
-#define __GENERIC_PER_CPU
 
 /* This is used for other cpus to find our section. */
 extern unsigned long __per_cpu_offset[];
Index: linux-2.6.24-rc3-mm2/include/asm-s390/percpu.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-s390/percpu.h	2007-11-28 12:51:28.443963942 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-s390/percpu.h	2007-11-28 12:51:38.784139633 -0800
@@ -4,8 +4,6 @@
 #include <linux/compiler.h>
 #include <asm/lowcore.h>
 
-#define __GENERIC_PER_CPU
-
 /*
  * s390 uses its own implementation for per cpu data, the offset of
  * the cpu local data area is cached in the cpu's lowcore memory.

-- 
