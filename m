Return-Path: <linux-kernel-owner+w=401wt.eu-S1759285AbXFMTBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285AbXFMTBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbXFMTBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:01:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:12287 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbXFMTBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:01:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,417,1175497200"; 
   d="scan'208";a="238782178"
Date: Wed, 13 Jun 2007 11:57:06 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: akpm@linux-foundation.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, clameter@sgi.com,
       michal.k.k.piotrowski@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2]: define new percpu interface for shared data - version 4
Message-ID: <20070613185706.GA12476@linux-os.sc.intel.com>
References: <200705231748.l4NHm1IM028416@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705231748.l4NHm1IM028416@shell0.pdx.osdl.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from previous version:
Fix a per_cpu_start and per_cpu_end absolute symbols bug on i386.

per cpu data section contains two types of data.  One set which is exclusively
accessed by the local cpu and the other set which is per cpu, but also shared
by remote cpus.  In the current kernel, these two sets are not clearely
separated out.  This can potentially cause the same data cacheline shared
between the two sets of data, which will result in unnecessary bouncing of the
cacheline between cpus.

One way to fix the problem is to cacheline align the remotely accessed per cpu
data, both at the beginning and at the end.  Because of the padding at both
ends, this will likely cause some memory wastage and also the interface to
achieve this is not clean.

This patch:

Moves the remotely accessed per cpu data (which is currently marked
as ____cacheline_aligned_in_smp) into a different section, where all the data
elements are cacheline aligned. And as such, this differentiates the local
only data and remotely accessed data cleanly.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/vmlinux.lds.S   |    5 +----
 arch/arm/kernel/vmlinux.lds.S     |    1 +
 arch/cris/arch-v32/vmlinux.lds.S  |    5 +----
 arch/frv/kernel/vmlinux.lds.S     |    5 +----
 arch/i386/kernel/vmlinux.lds.S    |    1 +
 arch/ia64/kernel/vmlinux.lds.S    |    1 +
 arch/m32r/kernel/vmlinux.lds.S    |    5 +----
 arch/mips/kernel/vmlinux.lds.S    |    5 +----
 arch/parisc/kernel/vmlinux.lds.S  |    7 +++----
 arch/powerpc/kernel/vmlinux.lds.S |    1 +
 arch/ppc/kernel/vmlinux.lds.S     |    5 +----
 arch/s390/kernel/vmlinux.lds.S    |    5 +----
 arch/sh/kernel/vmlinux.lds.S      |    5 +----
 arch/sh64/kernel/vmlinux.lds.S    |    5 ++++-
 arch/sparc/kernel/vmlinux.lds.S   |    5 +----
 arch/sparc64/kernel/vmlinux.lds.S |    6 ++----
 arch/x86_64/kernel/vmlinux.lds.S  |    6 ++----
 arch/xtensa/kernel/vmlinux.lds.S  |    5 +----
 include/asm-generic/percpu.h      |    8 ++++++++
 include/asm-generic/vmlinux.lds.h |    8 ++++++++
 include/asm-i386/percpu.h         |    5 +++++
 include/asm-ia64/percpu.h         |   10 ++++++++++
 include/asm-powerpc/percpu.h      |    7 +++++++
 include/asm-s390/percpu.h         |    7 +++++++
 include/asm-sparc64/percpu.h      |    7 +++++++
 include/asm-x86_64/percpu.h       |    7 +++++++
 26 files changed, 84 insertions(+), 53 deletions(-)

diff -Nurp linux-2.6.21.0/arch/alpha/kernel/vmlinux.lds.S linux-2.6.21.1/arch/alpha/kernel/vmlinux.lds.S
--- linux-2.6.21.0/arch/alpha/kernel/vmlinux.lds.S	2007-06-11 10:49:40.000000000 -0700
+++ linux-2.6.21.1/arch/alpha/kernel/vmlinux.lds.S	2007-06-11 10:42:16.000000000 -0700
@@ -69,10 +69,7 @@ SECTIONS
   . = ALIGN(8);
   SECURITY_INIT
 
-  . = ALIGN(8192);
-  __per_cpu_start = .;
-  .data.percpu : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(8192)
 
   . = ALIGN(2*8192);
   __init_end = .;
diff -Nurp linux-2.6.21.0/arch/arm/kernel/vmlinux.lds.S linux-2.6.21.1/arch/arm/kernel/vmlinux.lds.S
--- linux-2.6.21.0/arch/arm/kernel/vmlinux.lds.S	2007-06-11 10:49:40.000000000 -0700
+++ linux-2.6.21.1/arch/arm/kernel/vmlinux.lds.S	2007-06-11 10:42:16.000000000 -0700
@@ -66,6 +66,7 @@ SECTIONS
 		. = ALIGN(4096);
 		__per_cpu_start = .;
 			*(.data.percpu)
+			*(.data.percpu.shared_aligned)
 		__per_cpu_end = .;
 #ifndef CONFIG_XIP_KERNEL
 		__init_begin = _stext;
diff -Nurp linux-2.6.21.0/arch/cris/arch-v32/vmlinux.lds.S linux-2.6.21.1/arch/cris/arch-v32/vmlinux.lds.S
--- linux-2.6.21.0/arch/cris/arch-v32/vmlinux.lds.S	2007-06-11 10:49:40.000000000 -0700
+++ linux-2.6.21.1/arch/cris/arch-v32/vmlinux.lds.S	2007-06-11 10:42:16.000000000 -0700
@@ -91,10 +91,7 @@ SECTIONS
 	}
 	SECURITY_INIT
 
-	. =  ALIGN (8192);
-	__per_cpu_start = .;
-	.data.percpu  : { *(.data.percpu) }
-	__per_cpu_end = .;
+	PERCPU(8192)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	.init.ramfs : {
diff -Nurp linux-2.6.21.0/arch/frv/kernel/vmlinux.lds.S linux-2.6.21.1/arch/frv/kernel/vmlinux.lds.S
--- linux-2.6.21.0/arch/frv/kernel/vmlinux.lds.S	2007-06-11 10:49:40.000000000 -0700
+++ linux-2.6.21.1/arch/frv/kernel/vmlinux.lds.S	2007-06-11 10:42:16.000000000 -0700
@@ -57,10 +57,7 @@ SECTIONS
   __alt_instructions_end = .;
  .altinstr_replacement : { *(.altinstr_replacement) }
 
-  . = ALIGN(4096);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(4096)
 
 #ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(4096);
diff -Nurp linux-2.6.21.0/arch/i386/kernel/vmlinux.lds.S linux-2.6.21.1/arch/i386/kernel/vmlinux.lds.S
--- linux-2.6.21.0/arch/i386/kernel/vmlinux.lds.S	2007-06-11 10:49:40.000000000 -0700
+++ linux-2.6.21.1/arch/i386/kernel/vmlinux.lds.S	2007-06-11 10:43:31.000000000 -0700
@@ -180,6 +180,7 @@ SECTIONS
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
 	__per_cpu_start = .;
 	*(.data.percpu)
+	*(.data.percpu.shared_aligned)
 	__per_cpu_end = .;
   }
   . = ALIGN(4096);
diff -Nurp linux-2.6.21.0/arch/ia64/kernel/vmlinux.lds.S linux-2.6.21.1/arch/ia64/kernel/vmlinux.lds.S
--- linux-2.6.21.0/arch/ia64/kernel/vmlinux.lds.S	2007-06-11 10:49:40.000000000 -0700
+++ linux-2.6.21.1/arch/ia64/kernel/vmlinux.lds.S	2007-06-11 10:42:16.000000000 -0700
@@ -206,6 +206,7 @@ SECTIONS
 	{
 		__per_cpu_start = .;
 		*(.data.percpu)
+		*(.data.percpu.shared_aligned)
 		__per_cpu_end = .;
 	}
   . = __phys_per_cpu_start + PERCPU_PAGE_SIZE;	/* ensure percpu data fits
diff -Nurp linux-2.6.21.0/arch/m32r/kernel/vmlinux.lds.S linux-2.6.21.1/arch/m32r/kernel/vmlinux.lds.S
--- linux-2.6.21.0/arch/m32r/kernel/vmlinux.lds.S	2007-06-11 10:49:40.000000000 -0700
+++ linux-2.6.21.1/arch/m32r/kernel/vmlinux.lds.S	2007-06-11 10:42:16.000000000 -0700
@@ -110,10 +110,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(4096);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(4096)
   . = ALIGN(4096);
   __init_end = .;
   /* freed after init ends here */
diff -Nurp linux-2.6.21.0/arch/mips/kernel/vmlinux.lds.S linux-2.6.21.1/arch/mips/kernel/vmlinux.lds.S
--- linux-2.6.21.0/arch/mips/kernel/vmlinux.lds.S	2007-06-11 10:49:41.000000000 -0700
+++ linux-2.6.21.1/arch/mips/kernel/vmlinux.lds.S	2007-06-11 10:42:16.000000000 -0700
@@ -119,10 +119,7 @@ SECTIONS
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
 #endif
-  . = ALIGN(_PAGE_SIZE);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(_PAGE_SIZE)
   . = ALIGN(_PAGE_SIZE);
   __init_end = .;
   /* freed after init ends here */
diff -Nurp linux-2.6.21.0/arch/parisc/kernel/vmlinux.lds.S linux-2.6.21.1/arch/parisc/kernel/vmlinux.lds.S
--- linux-2.6.21.0/arch/parisc/kernel/vmlinux.lds.S	2007-06-11 10:49:41.000000000 -0700
+++ linux-2.6.21.1/arch/parisc/kernel/vmlinux.lds.S	2007-06-11 10:42:16.000000000 -0700
@@ -181,10 +181,9 @@ SECTIONS
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
 #endif
-  . = ALIGN(ASM_PAGE_SIZE);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+
+  PERCPU(ASM_PAGE_SIZE)
+
   . = ALIGN(ASM_PAGE_SIZE);
   __init_end = .;
   /* freed after init ends here */
diff -Nurp linux-2.6.21.0/arch/powerpc/kernel/vmlinux.lds.S linux-2.6.21.1/arch/powerpc/kernel/vmlinux.lds.S
--- linux-2.6.21.0/arch/powerpc/kernel/vmlinux.lds.S	2007-06-11 10:49:41.000000000 -0700
+++ linux-2.6.21.1/arch/powerpc/kernel/vmlinux.lds.S	2007-06-11 10:44:31.000000000 -0700
@@ -143,6 +143,7 @@ SECTIONS
 	.data.percpu : {
 		__per_cpu_start = .;
 		*(.data.percpu)
+		*(.data.percpu.shared_aligned)
 		__per_cpu_end = .;
 	}
 
diff -Nurp linux-2.6.21.0/arch/ppc/kernel/vmlinux.lds.S linux-2.6.21.1/arch/ppc/kernel/vmlinux.lds.S
--- linux-2.6.21.0/arch/ppc/kernel/vmlinux.lds.S	2007-06-11 10:49:41.000000000 -0700
+++ linux-2.6.21.1/arch/ppc/kernel/vmlinux.lds.S	2007-06-11 10:42:16.000000000 -0700
@@ -130,10 +130,7 @@ SECTIONS
   __ftr_fixup : { *(__ftr_fixup) }
   __stop___ftr_fixup = .;
 
-  . = ALIGN(4096);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(4096)
 
 #ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(4096);
diff -Nurp linux-2.6.21.0/arch/s390/kernel/vmlinux.lds.S linux-2.6.21.1/arch/s390/kernel/vmlinux.lds.S
--- linux-2.6.21.0/arch/s390/kernel/vmlinux.lds.S	2007-06-11 10:49:41.000000000 -0700
+++ linux-2.6.21.1/arch/s390/kernel/vmlinux.lds.S	2007-06-11 10:42:16.000000000 -0700
@@ -107,10 +107,7 @@ SECTIONS
   . = ALIGN(2);
   __initramfs_end = .;
 #endif
-  . = ALIGN(4096);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(4096)
   . = ALIGN(4096);
   __init_end = .;
   /* freed after init ends here */
diff -Nurp linux-2.6.21.0/arch/sh/kernel/vmlinux.lds.S linux-2.6.21.1/arch/sh/kernel/vmlinux.lds.S
--- linux-2.6.21.0/arch/sh/kernel/vmlinux.lds.S	2007-06-11 10:49:42.000000000 -0700
+++ linux-2.6.21.1/arch/sh/kernel/vmlinux.lds.S	2007-06-11 10:42:16.000000000 -0700
@@ -60,10 +60,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   __nosave_end = .;
 
-  . = ALIGN(PAGE_SIZE);
-  __per_cpu_start = .;
-  .data.percpu : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(PAGE_SIZE)
   .data.cacheline_aligned : { *(.data.cacheline_aligned) }
 
   _edata = .;			/* End of data section */
diff -Nurp linux-2.6.21.0/arch/sh64/kernel/vmlinux.lds.S linux-2.6.21.1/arch/sh64/kernel/vmlinux.lds.S
--- linux-2.6.21.0/arch/sh64/kernel/vmlinux.lds.S	2007-06-11 10:49:42.000000000 -0700
+++ linux-2.6.21.1/arch/sh64/kernel/vmlinux.lds.S	2007-06-11 10:46:36.000000000 -0700
@@ -87,7 +87,10 @@ SECTIONS
 
   . = ALIGN(PAGE_SIZE);
   __per_cpu_start = .;
-  .data.percpu : C_PHYS(.data.percpu) { *(.data.percpu) }
+  .data.percpu : C_PHYS(.data.percpu) {
+	*(.data.percpu)
+	*(.data.percpu.shared_aligned)
+  }
   __per_cpu_end = . ;
   .data.cacheline_aligned : C_PHYS(.data.cacheline_aligned) { *(.data.cacheline_aligned) }
 
diff -Nurp linux-2.6.21.0/arch/sparc/kernel/vmlinux.lds.S linux-2.6.21.1/arch/sparc/kernel/vmlinux.lds.S
--- linux-2.6.21.0/arch/sparc/kernel/vmlinux.lds.S	2007-06-11 10:49:42.000000000 -0700
+++ linux-2.6.21.1/arch/sparc/kernel/vmlinux.lds.S	2007-06-11 10:42:16.000000000 -0700
@@ -65,10 +65,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(4096);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(4096)
   . = ALIGN(4096);
   __init_end = .;
   . = ALIGN(32);
diff -Nurp linux-2.6.21.0/arch/sparc64/kernel/vmlinux.lds.S linux-2.6.21.1/arch/sparc64/kernel/vmlinux.lds.S
--- linux-2.6.21.0/arch/sparc64/kernel/vmlinux.lds.S	2007-06-11 10:49:42.000000000 -0700
+++ linux-2.6.21.1/arch/sparc64/kernel/vmlinux.lds.S	2007-06-11 10:48:46.000000000 -0700
@@ -90,10 +90,8 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(PAGE_SIZE);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(PAGE_SIZE)
+
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
   __bss_start = .;
 /* Copies of the original ist values from the tss are only accessed during
  * debugging, no special alignment required.
diff -Nurp linux-2.6.21.0/arch/x86_64/kernel/vmlinux.lds.S linux-2.6.21.1/arch/x86_64/kernel/vmlinux.lds.S
--- linux-2.6.21.0/arch/x86_64/kernel/vmlinux.lds.S	2007-06-11 10:49:42.000000000 -0700
+++ linux-2.6.21.1/arch/x86_64/kernel/vmlinux.lds.S	2007-06-11 10:42:16.000000000 -0700
@@ -194,10 +194,8 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(4096);
-  __per_cpu_start = .;
-  .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(4096)
+
   . = ALIGN(4096);
   __init_end = .;
 
diff -Nurp linux-2.6.21.0/arch/xtensa/kernel/vmlinux.lds.S linux-2.6.21.1/arch/xtensa/kernel/vmlinux.lds.S
--- linux-2.6.21.0/arch/xtensa/kernel/vmlinux.lds.S	2007-06-11 10:49:42.000000000 -0700
+++ linux-2.6.21.1/arch/xtensa/kernel/vmlinux.lds.S	2007-06-11 10:42:16.000000000 -0700
@@ -200,10 +200,7 @@ SECTIONS
   __ftr_fixup : { *(__ftr_fixup) }
   __stop___ftr_fixup = .;
 
-  . = ALIGN(4096);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(4096)
 
 #ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(4096);
diff -Nurp linux-2.6.21.0/include/asm-generic/percpu.h linux-2.6.21.1/include/asm-generic/percpu.h
--- linux-2.6.21.0/include/asm-generic/percpu.h	2007-06-11 10:49:45.000000000 -0700
+++ linux-2.6.21.1/include/asm-generic/percpu.h	2007-06-11 10:42:16.000000000 -0700
@@ -14,6 +14,11 @@ extern unsigned long __per_cpu_offset[NR
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
+    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __typeof__(type) per_cpu__##name				\
+    ____cacheline_aligned_in_smp
+
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*({				\
 	extern int simple_identifier_##var(void);	\
@@ -34,6 +39,9 @@ do {								\
 #define DEFINE_PER_CPU(type, name) \
     __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
+    DEFINE_PER_CPU(type, name)
+
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
 #define __raw_get_cpu_var(var)			per_cpu__##var
diff -Nurp linux-2.6.21.0/include/asm-generic/vmlinux.lds.h linux-2.6.21.1/include/asm-generic/vmlinux.lds.h
--- linux-2.6.21.0/include/asm-generic/vmlinux.lds.h	2007-06-11 10:49:45.000000000 -0700
+++ linux-2.6.21.1/include/asm-generic/vmlinux.lds.h	2007-06-11 10:42:16.000000000 -0700
@@ -245,3 +245,11 @@
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
 
+#define PERCPU(align)							\
+	. = ALIGN(align);						\
+	__per_cpu_start = .;						\
+	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
+		*(.data.percpu)						\
+		*(.data.percpu.shared_aligned)				\
+	}								\
+	__per_cpu_end = .;
diff -Nurp linux-2.6.21.0/include/asm-i386/percpu.h linux-2.6.21.1/include/asm-i386/percpu.h
--- linux-2.6.21.0/include/asm-i386/percpu.h	2007-06-11 10:49:56.000000000 -0700
+++ linux-2.6.21.1/include/asm-i386/percpu.h	2007-06-11 10:42:16.000000000 -0700
@@ -54,6 +54,11 @@ extern unsigned long __per_cpu_offset[];
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
+    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __typeof__(type) per_cpu__##name				\
+    ____cacheline_aligned_in_smp
+
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
diff -Nurp linux-2.6.21.0/include/asm-ia64/percpu.h linux-2.6.21.1/include/asm-ia64/percpu.h
--- linux-2.6.21.0/include/asm-ia64/percpu.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21.1/include/asm-ia64/percpu.h	2007-06-11 10:42:16.000000000 -0700
@@ -29,6 +29,16 @@
 	__attribute__((__section__(".data.percpu")))		\
 	__SMALL_ADDR_AREA __typeof__(type) per_cpu__##name
 
+#ifdef CONFIG_SMP
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
+	__attribute__((__section__(".data.percpu.shared_aligned")))	\
+	__SMALL_ADDR_AREA __typeof__(type) per_cpu__##name		\
+	____cacheline_aligned_in_smp
+#else
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
+	DEFINE_PER_CPU(type, name)
+#endif
+
 /*
  * Pretty much a literal copy of asm-generic/percpu.h, except that percpu_modcopy() is an
  * external routine, to avoid include-hell.
diff -Nurp linux-2.6.21.0/include/asm-powerpc/percpu.h linux-2.6.21.1/include/asm-powerpc/percpu.h
--- linux-2.6.21.0/include/asm-powerpc/percpu.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21.1/include/asm-powerpc/percpu.h	2007-06-11 10:42:16.000000000 -0700
@@ -20,6 +20,11 @@
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
+    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __typeof__(type) per_cpu__##name				\
+    ____cacheline_aligned_in_smp
+
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*RELOC_HIDE(&per_cpu__##var, __per_cpu_offset(cpu)))
 #define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()))
@@ -40,6 +45,8 @@ extern void setup_per_cpu_areas(void);
 
 #define DEFINE_PER_CPU(type, name) \
     __typeof__(type) per_cpu__##name
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
+    DEFINE_PER_CPU(type, name)
 
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
diff -Nurp linux-2.6.21.0/include/asm-s390/percpu.h linux-2.6.21.1/include/asm-s390/percpu.h
--- linux-2.6.21.0/include/asm-s390/percpu.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21.1/include/asm-s390/percpu.h	2007-06-11 10:42:16.000000000 -0700
@@ -41,6 +41,11 @@ extern unsigned long __per_cpu_offset[NR
     __attribute__((__section__(".data.percpu"))) \
     __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
+    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __typeof__(type) per_cpu__##name				\
+    ____cacheline_aligned_in_smp
+
 #define __get_cpu_var(var) __reloc_hide(var,S390_lowcore.percpu_offset)
 #define __raw_get_cpu_var(var) __reloc_hide(var,S390_lowcore.percpu_offset)
 #define per_cpu(var,cpu) __reloc_hide(var,__per_cpu_offset[cpu])
@@ -59,6 +64,8 @@ do {								\
 
 #define DEFINE_PER_CPU(type, name) \
     __typeof__(type) per_cpu__##name
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
+    DEFINE_PER_CPU(type, name)
 
 #define __get_cpu_var(var) __reloc_hide(var,0)
 #define __raw_get_cpu_var(var) __reloc_hide(var,0)
diff -Nurp linux-2.6.21.0/include/asm-sparc64/percpu.h linux-2.6.21.1/include/asm-sparc64/percpu.h
--- linux-2.6.21.0/include/asm-sparc64/percpu.h	2007-06-11 10:49:56.000000000 -0700
+++ linux-2.6.21.1/include/asm-sparc64/percpu.h	2007-06-11 10:42:16.000000000 -0700
@@ -18,6 +18,11 @@ extern unsigned long __per_cpu_shift;
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
+    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __typeof__(type) per_cpu__##name				\
+    ____cacheline_aligned_in_smp
+
 register unsigned long __local_per_cpu_offset asm("g5");
 
 /* var is in discarded region: offset to particular copy we want */
@@ -38,6 +43,8 @@ do {								\
 #define real_setup_per_cpu_areas()		do { } while (0)
 #define DEFINE_PER_CPU(type, name) \
     __typeof__(type) per_cpu__##name
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
+    DEFINE_PER_CPU(type, name)
 
 #define per_cpu(var, cpu)			(*((void)cpu, &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
diff -Nurp linux-2.6.21.0/include/asm-x86_64/percpu.h linux-2.6.21.1/include/asm-x86_64/percpu.h
--- linux-2.6.21.0/include/asm-x86_64/percpu.h	2007-06-11 10:49:56.000000000 -0700
+++ linux-2.6.21.1/include/asm-x86_64/percpu.h	2007-06-11 10:42:16.000000000 -0700
@@ -20,6 +20,11 @@
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
+    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __typeof__(type) per_cpu__##name				\
+    ____cacheline_internodealigned_in_smp
+
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*({				\
 	extern int simple_identifier_##var(void);	\
@@ -46,6 +51,8 @@ extern void setup_per_cpu_areas(void);
 
 #define DEFINE_PER_CPU(type, name) \
     __typeof__(type) per_cpu__##name
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
+    DEFINE_PER_CPU(type, name)
 
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
