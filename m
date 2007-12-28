Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbXL1AQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbXL1AQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 19:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbXL1AQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 19:16:20 -0500
Received: from relay1.sgi.com ([192.48.171.29]:57352 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755188AbXL1AQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 19:16:18 -0500
Message-Id: <20071228001617.770732000@sgi.com>
References: <20071228001617.597161000@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Dec 2007 16:16:18 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>
Subject: [PATCH 01/10] percpu: Use a kconfig variable to signal arch specific percpu setup
Content-Disposition: inline; filename=arch_sets_up_per_cpu_areas
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V1->V2:
- Use def_bool as suggested by Randy.

The use of the __GENERIC_PERCPU is a bit problematic since arches
may want to run their own percpu setup while using the generic
percpu definitions. Replace it through a kconfig variable.



Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>

---
 arch/ia64/Kconfig            |    3 +++
 arch/powerpc/Kconfig         |    3 +++
 arch/sparc64/Kconfig         |    3 +++
 arch/x86/Kconfig             |    3 +++
 include/asm-generic/percpu.h |    1 -
 include/asm-s390/percpu.h    |    2 --
 include/asm-x86/percpu_32.h  |    2 --
 init/main.c                  |    4 ++--
 8 files changed, 14 insertions(+), 7 deletions(-)

--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -82,6 +82,9 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default y
 
+config ARCH_SETS_UP_PER_CPU_AREA
+	def_bool y
+
 config DMI
 	bool
 	default y
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -42,6 +42,9 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
+config ARCH_SETS_UP_PER_CPU_AREA
+	def_bool PPC64
+
 config IRQ_PER_CPU
 	bool
 	default y
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -68,6 +68,9 @@ config AUDIT_ARCH
 	bool
 	default y
 
+config ARCH_SETS_UP_PER_CPU_AREA
+	def_bool y
+
 config ARCH_NO_VIRT_TO_BUS
 	def_bool y
 
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -106,6 +106,9 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default X86_64
 
+config ARCH_SETS_UP_PER_CPU_AREA
+	def_bool X86_64
+
 config ARCH_SUPPORTS_OPROFILE
 	bool
 	default y
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -3,7 +3,6 @@
 #include <linux/compiler.h>
 #include <linux/threads.h>
 
-#define __GENERIC_PER_CPU
 #ifdef CONFIG_SMP
 
 extern unsigned long __per_cpu_offset[NR_CPUS];
--- a/include/asm-s390/percpu.h
+++ b/include/asm-s390/percpu.h
@@ -4,8 +4,6 @@
 #include <linux/compiler.h>
 #include <asm/lowcore.h>
 
-#define __GENERIC_PER_CPU
-
 /*
  * s390 uses its own implementation for per cpu data, the offset of
  * the cpu local data area is cached in the cpu's lowcore memory.
--- a/include/asm-x86/percpu_32.h
+++ b/include/asm-x86/percpu_32.h
@@ -41,8 +41,6 @@
  *    PER_CPU(cpu_gdt_descr, %ebx)
  */
 #ifdef CONFIG_SMP
-/* Same as generic implementation except for optimized local access. */
-#define __GENERIC_PER_CPU
 
 /* This is used for other cpus to find our section. */
 extern unsigned long __per_cpu_offset[];
--- a/init/main.c
+++ b/init/main.c
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

-- 
