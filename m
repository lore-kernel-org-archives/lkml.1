Return-Path: <linux-kernel-owner+w=401wt.eu-S1765522AbXEVSXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765522AbXEVSXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbXEVSXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:23:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:12477 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756617AbXEVSXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:23:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,567,1170662400"; 
   d="scan'208";a="230913079"
Date: Tue, 22 May 2007 11:20:03 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: akpm@linux-foundation.org, suresh.b.siddha@intel.com, clameter@sgi.com,
       kiran@scalex86.org, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: fenghua.yu@intel.com
Subject: [PATCH 1/2] Define new percpu interface for shared data -- version 3
Message-ID: <20070522182003.GA28106@linux-os.sc.intel.com>
References: <20070522124713.GB27428@frankl.hpl.hp.com> <20070522090210.1388ff3e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522090210.1388ff3e.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from previous version:
Fix a compilation error for ARM

per cpu data section contains two types of data. One set which is exclusively
accessed by the local cpu and the other set which is  per cpu, but also shared
by remote cpus. In the current kernel, these two sets are not clearely
separated out. This can potentially cause the same data cacheline shared
between the two sets of data, which will result in unnecessary bouncing of the
cacheline between cpus.

One way to fix the problem is to cacheline align the remotely accessed per cpu
data, both at the beginning and at the end. Because of the padding at both ends,
this will likely cause some memory wastage and also the interface to achieve
this is not clean.

This patch:

Moves the remotely accessed per cpu data (which is currently marked
as ____cacheline_aligned_in_smp) into a different section, where all the data
elements are cacheline aligned. And as such, this differentiates the local
only data and remotely accessed data cleanly.

igned-off-by: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

---

 arch/alpha/kernel/vmlinux.lds.S   |    5 +----
 arch/arm/kernel/vmlinux.lds.S     |    1 +
 arch/cris/arch-v32/vmlinux.lds.S  |    5 +----
 arch/frv/kernel/vmlinux.lds.S     |    5 +----
 arch/i386/kernel/vmlinux.lds.S    |    7 +------
 arch/ia64/kernel/vmlinux.lds.S    |    1 +
 arch/m32r/kernel/vmlinux.lds.S    |    5 +----
 arch/mips/kernel/vmlinux.lds.S    |    5 +----
 arch/parisc/kernel/vmlinux.lds.S  |    7 +++----
 arch/powerpc/kernel/vmlinux.lds.S |    7 +------
 arch/ppc/kernel/vmlinux.lds.S     |    5 +----
 arch/s390/kernel/vmlinux.lds.S    |    5 +----
 arch/sh/kernel/vmlinux.lds.S      |    5 +----
 arch/sh64/kernel/vmlinux.lds.S    |    5 +----
 arch/sparc/kernel/vmlinux.lds.S   |    5 +----
 arch/sparc64/kernel/vmlinux.lds.S |    5 +----
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
 26 files changed, 80 insertions(+), 68 deletions(-)

diff -Nurp linux-2.6.22-rc1-mm1.0/arch/alpha/kernel/vmlinux.lds.S linux-2.6.22-rc1-mm1.1/arch/alpha/kernel/vmlinux.lds.S
--- linux-2.6.22-rc1-mm1.0/arch/alpha/kernel/vmlinux.lds.S	2007-05-18 15:37:15.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/arch/alpha/kernel/vmlinux.lds.S	2007-05-18 15:40:08.000000000 -0700
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
diff -Nurp linux-2.6.22-rc1-mm1.0/arch/arm/kernel/vmlinux.lds.S linux-2.6.22-rc1-mm1.1/arch/arm/kernel/vmlinux.lds.S
--- linux-2.6.22-rc1-mm1.0/arch/arm/kernel/vmlinux.lds.S	2007-05-18 15:37:15.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/arch/arm/kernel/vmlinux.lds.S	2007-05-18 15:40:08.000000000 -0700
@@ -66,6 +66,7 @@ SECTIONS
 		. = ALIGN(4096);
 		__per_cpu_start = .;
 			*(.data.percpu)
+			*(.data.percpu.shared_aligned)
 		__per_cpu_end = .;
 #ifndef CONFIG_XIP_KERNEL
 		__init_begin = _stext;
diff -Nurp linux-2.6.22-rc1-mm1.0/arch/cris/arch-v32/vmlinux.lds.S linux-2.6.22-rc1-mm1.1/arch/cris/arch-v32/vmlinux.lds.S
--- linux-2.6.22-rc1-mm1.0/arch/cris/arch-v32/vmlinux.lds.S	2007-05-18 15:37:16.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/arch/cris/arch-v32/vmlinux.lds.S	2007-05-18 15:40:08.000000000 -0700
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
diff -Nurp linux-2.6.22-rc1-mm1.0/arch/frv/kernel/vmlinux.lds.S linux-2.6.22-rc1-mm1.1/arch/frv/kernel/vmlinux.lds.S
--- linux-2.6.22-rc1-mm1.0/arch/frv/kernel/vmlinux.lds.S	2007-05-18 15:37:16.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/arch/frv/kernel/vmlinux.lds.S	2007-05-18 15:40:08.000000000 -0700
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
diff -Nurp linux-2.6.22-rc1-mm1.0/arch/i386/kernel/vmlinux.lds.S linux-2.6.22-rc1-mm1.1/arch/i386/kernel/vmlinux.lds.S
--- linux-2.6.22-rc1-mm1.0/arch/i386/kernel/vmlinux.lds.S	2007-05-18 15:38:09.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/arch/i386/kernel/vmlinux.lds.S	2007-05-18 15:40:08.000000000 -0700
@@ -178,12 +178,7 @@ SECTIONS
 	__initramfs_end = .;
   }
 #endif
-  . = ALIGN(4096);
-  .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
-	__per_cpu_start = .;
-	*(.data.percpu)
-	__per_cpu_end = .;
-  }
+  PERCPU(4096)
   . = ALIGN(4096);
   /* freed after init ends here */
 	
diff -Nurp linux-2.6.22-rc1-mm1.0/arch/ia64/kernel/vmlinux.lds.S linux-2.6.22-rc1-mm1.1/arch/ia64/kernel/vmlinux.lds.S
--- linux-2.6.22-rc1-mm1.0/arch/ia64/kernel/vmlinux.lds.S	2007-05-18 15:37:16.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/arch/ia64/kernel/vmlinux.lds.S	2007-05-18 15:40:08.000000000 -0700
@@ -206,6 +206,7 @@ SECTIONS
 	{
 		__per_cpu_start = .;
 		*(.data.percpu)
+		*(.data.percpu.shared_aligned)
 		__per_cpu_end = .;
 	}
   . = __phys_per_cpu_start + PERCPU_PAGE_SIZE;	/* ensure percpu data fits
diff -Nurp linux-2.6.22-rc1-mm1.0/arch/m32r/kernel/vmlinux.lds.S linux-2.6.22-rc1-mm1.1/arch/m32r/kernel/vmlinux.lds.S
--- linux-2.6.22-rc1-mm1.0/arch/m32r/kernel/vmlinux.lds.S	2007-05-18 15:37:16.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/arch/m32r/kernel/vmlinux.lds.S	2007-05-18 15:40:08.000000000 -0700
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
diff -Nurp linux-2.6.22-rc1-mm1.0/arch/mips/kernel/vmlinux.lds.S linux-2.6.22-rc1-mm1.1/arch/mips/kernel/vmlinux.lds.S
--- linux-2.6.22-rc1-mm1.0/arch/mips/kernel/vmlinux.lds.S	2007-05-18 15:37:16.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/arch/mips/kernel/vmlinux.lds.S	2007-05-18 15:40:08.000000000 -0700
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
diff -Nurp linux-2.6.22-rc1-mm1.0/arch/parisc/kernel/vmlinux.lds.S linux-2.6.22-rc1-mm1.1/arch/parisc/kernel/vmlinux.lds.S
--- linux-2.6.22-rc1-mm1.0/arch/parisc/kernel/vmlinux.lds.S	2007-05-18 15:37:16.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/arch/parisc/kernel/vmlinux.lds.S	2007-05-18 15:40:08.000000000 -0700
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
diff -Nurp linux-2.6.22-rc1-mm1.0/arch/powerpc/kernel/vmlinux.lds.S linux-2.6.22-rc1-mm1.1/arch/powerpc/kernel/vmlinux.lds.S
--- linux-2.6.22-rc1-mm1.0/arch/powerpc/kernel/vmlinux.lds.S	2007-05-18 15:37:16.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/arch/powerpc/kernel/vmlinux.lds.S	2007-05-18 15:40:08.000000000 -0700
@@ -139,12 +139,7 @@ SECTIONS
 		__initramfs_end = .;
 	}
 #endif
-	. = ALIGN(PAGE_SIZE);
-	.data.percpu : {
-		__per_cpu_start = .;
-		*(.data.percpu)
-		__per_cpu_end = .;
-	}
+	PERCPU(PAGE_SIZE)
 
 	. = ALIGN(8);
 	.machine.desc : {
diff -Nurp linux-2.6.22-rc1-mm1.0/arch/ppc/kernel/vmlinux.lds.S linux-2.6.22-rc1-mm1.1/arch/ppc/kernel/vmlinux.lds.S
--- linux-2.6.22-rc1-mm1.0/arch/ppc/kernel/vmlinux.lds.S	2007-05-18 15:37:16.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/arch/ppc/kernel/vmlinux.lds.S	2007-05-18 15:40:08.000000000 -0700
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
diff -Nurp linux-2.6.22-rc1-mm1.0/arch/s390/kernel/vmlinux.lds.S linux-2.6.22-rc1-mm1.1/arch/s390/kernel/vmlinux.lds.S
--- linux-2.6.22-rc1-mm1.0/arch/s390/kernel/vmlinux.lds.S	2007-05-18 15:37:16.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/arch/s390/kernel/vmlinux.lds.S	2007-05-18 15:40:08.000000000 -0700
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
diff -Nurp linux-2.6.22-rc1-mm1.0/arch/sh/kernel/vmlinux.lds.S linux-2.6.22-rc1-mm1.1/arch/sh/kernel/vmlinux.lds.S
--- linux-2.6.22-rc1-mm1.0/arch/sh/kernel/vmlinux.lds.S	2007-05-18 15:38:09.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/arch/sh/kernel/vmlinux.lds.S	2007-05-18 15:40:08.000000000 -0700
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
diff -Nurp linux-2.6.22-rc1-mm1.0/arch/sh64/kernel/vmlinux.lds.S linux-2.6.22-rc1-mm1.1/arch/sh64/kernel/vmlinux.lds.S
--- linux-2.6.22-rc1-mm1.0/arch/sh64/kernel/vmlinux.lds.S	2007-05-18 15:37:16.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/arch/sh64/kernel/vmlinux.lds.S	2007-05-18 15:40:08.000000000 -0700
@@ -85,10 +85,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   .data.page_aligned : C_PHYS(.data.page_aligned) { *(.data.page_aligned) }
 
-  . = ALIGN(PAGE_SIZE);
-  __per_cpu_start = .;
-  .data.percpu : C_PHYS(.data.percpu) { *(.data.percpu) }
-  __per_cpu_end = . ;
+  PERCPU(PAGE_SIZE)
   .data.cacheline_aligned : C_PHYS(.data.cacheline_aligned) { *(.data.cacheline_aligned) }
 
   _edata = .;			/* End of data section */
diff -Nurp linux-2.6.22-rc1-mm1.0/arch/sparc/kernel/vmlinux.lds.S linux-2.6.22-rc1-mm1.1/arch/sparc/kernel/vmlinux.lds.S
--- linux-2.6.22-rc1-mm1.0/arch/sparc/kernel/vmlinux.lds.S	2007-05-18 15:37:16.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/arch/sparc/kernel/vmlinux.lds.S	2007-05-18 15:40:08.000000000 -0700
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
diff -Nurp linux-2.6.22-rc1-mm1.0/arch/sparc64/kernel/vmlinux.lds.S linux-2.6.22-rc1-mm1.1/arch/sparc64/kernel/vmlinux.lds.S
--- linux-2.6.22-rc1-mm1.0/arch/sparc64/kernel/vmlinux.lds.S	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/arch/sparc64/kernel/vmlinux.lds.S	2007-05-18 15:40:08.000000000 -0700
@@ -89,10 +89,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(8192);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(8192)
   . = ALIGN(8192);
   __init_end = .;
   __bss_start = .;
diff -Nurp linux-2.6.22-rc1-mm1.0/arch/x86_64/kernel/vmlinux.lds.S linux-2.6.22-rc1-mm1.1/arch/x86_64/kernel/vmlinux.lds.S
--- linux-2.6.22-rc1-mm1.0/arch/x86_64/kernel/vmlinux.lds.S	2007-05-18 15:38:09.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/arch/x86_64/kernel/vmlinux.lds.S	2007-05-18 15:40:08.000000000 -0700
@@ -203,10 +203,8 @@ SECTIONS
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
 
diff -Nurp linux-2.6.22-rc1-mm1.0/arch/xtensa/kernel/vmlinux.lds.S linux-2.6.22-rc1-mm1.1/arch/xtensa/kernel/vmlinux.lds.S
--- linux-2.6.22-rc1-mm1.0/arch/xtensa/kernel/vmlinux.lds.S	2007-05-18 15:37:16.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/arch/xtensa/kernel/vmlinux.lds.S	2007-05-18 15:40:08.000000000 -0700
@@ -198,10 +198,7 @@ SECTIONS
   __ftr_fixup : { *(__ftr_fixup) }
   __stop___ftr_fixup = .;
 
-  . = ALIGN(4096);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(4096)
 
 #ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(4096);
diff -Nurp linux-2.6.22-rc1-mm1.0/include/asm-generic/percpu.h linux-2.6.22-rc1-mm1.1/include/asm-generic/percpu.h
--- linux-2.6.22-rc1-mm1.0/include/asm-generic/percpu.h	2007-05-18 15:37:19.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/include/asm-generic/percpu.h	2007-05-18 15:40:08.000000000 -0700
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
diff -Nurp linux-2.6.22-rc1-mm1.0/include/asm-generic/vmlinux.lds.h linux-2.6.22-rc1-mm1.1/include/asm-generic/vmlinux.lds.h
--- linux-2.6.22-rc1-mm1.0/include/asm-generic/vmlinux.lds.h	2007-05-18 15:38:10.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/include/asm-generic/vmlinux.lds.h	2007-05-18 15:41:53.000000000 -0700
@@ -251,3 +251,11 @@
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
diff -Nurp linux-2.6.22-rc1-mm1.0/include/asm-i386/percpu.h linux-2.6.22-rc1-mm1.1/include/asm-i386/percpu.h
--- linux-2.6.22-rc1-mm1.0/include/asm-i386/percpu.h	2007-05-18 15:37:19.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/include/asm-i386/percpu.h	2007-05-18 15:40:08.000000000 -0700
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
 
diff -Nurp linux-2.6.22-rc1-mm1.0/include/asm-ia64/percpu.h linux-2.6.22-rc1-mm1.1/include/asm-ia64/percpu.h
--- linux-2.6.22-rc1-mm1.0/include/asm-ia64/percpu.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/include/asm-ia64/percpu.h	2007-05-18 15:40:08.000000000 -0700
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
diff -Nurp linux-2.6.22-rc1-mm1.0/include/asm-powerpc/percpu.h linux-2.6.22-rc1-mm1.1/include/asm-powerpc/percpu.h
--- linux-2.6.22-rc1-mm1.0/include/asm-powerpc/percpu.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/include/asm-powerpc/percpu.h	2007-05-18 15:40:08.000000000 -0700
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
diff -Nurp linux-2.6.22-rc1-mm1.0/include/asm-s390/percpu.h linux-2.6.22-rc1-mm1.1/include/asm-s390/percpu.h
--- linux-2.6.22-rc1-mm1.0/include/asm-s390/percpu.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/include/asm-s390/percpu.h	2007-05-18 15:40:08.000000000 -0700
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
diff -Nurp linux-2.6.22-rc1-mm1.0/include/asm-sparc64/percpu.h linux-2.6.22-rc1-mm1.1/include/asm-sparc64/percpu.h
--- linux-2.6.22-rc1-mm1.0/include/asm-sparc64/percpu.h	2007-05-18 15:37:25.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/include/asm-sparc64/percpu.h	2007-05-18 15:40:08.000000000 -0700
@@ -17,6 +17,11 @@ extern unsigned long __per_cpu_shift;
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
+    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __typeof__(type) per_cpu__##name				\
+    ____cacheline_aligned_in_smp
+
 register unsigned long __local_per_cpu_offset asm("g5");
 
 /* var is in discarded region: offset to particular copy we want */
@@ -36,6 +41,8 @@ do {								\
 
 #define DEFINE_PER_CPU(type, name) \
     __typeof__(type) per_cpu__##name
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
+    DEFINE_PER_CPU(type, name)
 
 #define per_cpu(var, cpu)			(*((void)cpu, &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
diff -Nurp linux-2.6.22-rc1-mm1.0/include/asm-x86_64/percpu.h linux-2.6.22-rc1-mm1.1/include/asm-x86_64/percpu.h
--- linux-2.6.22-rc1-mm1.0/include/asm-x86_64/percpu.h	2007-05-18 15:37:25.000000000 -0700
+++ linux-2.6.22-rc1-mm1.1/include/asm-x86_64/percpu.h	2007-05-18 15:40:08.000000000 -0700
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
