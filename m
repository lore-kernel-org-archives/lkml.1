Return-Path: <linux-kernel-owner+w=401wt.eu-S1758700AbXEOAZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbXEOAZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 20:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbXEOAZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 20:25:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:61498 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbXEOAZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 20:25:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,534,1170662400"; 
   d="scan'208";a="86906436"
Date: Mon, 14 May 2007 17:22:48 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: akpm@linux-foundation.org, "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Christoph Lameter <clameter@sgi.com>, kiran@scalex86.org,
       linux-kernel@vger.kernel.org
Cc: fenghua.yu@intel.com
Subject: [PATCH 1/2] Define new percpu interface for shared data -- version 2
Message-ID: <20070515002248.GB27978@linux-os.sc.intel.com>
References: <33E1C72C74DBE747B7B59C1740F7443701A2F0AB@orsmsx417.amr.corp.intel.com> <20070505001222.GA26142@linux-os.sc.intel.com> <Pine.LNX.4.64.0705050951040.27326@schroedinger.engr.sgi.com> <20070507171129.GA21638@linux-os.sc.intel.com> <Pine.LNX.4.64.0705071029470.5447@schroedinger.engr.sgi.com> <20070507174608.GB21638@linux-os.sc.intel.com> <20070515001255.GA27978@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515001255.GA27978@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from previous version:
1. Shorter macro and section names.
2. Detailed change log.
 
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

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

---

 arch/alpha/kernel/vmlinux.lds.S   |    5 +----
 arch/arm/kernel/vmlinux.lds.S     |    5 +----
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
 include/asm-generic/vmlinux.lds.h |   10 ++++++++++
 include/asm-i386/percpu.h         |    5 +++++
 include/asm-ia64/percpu.h         |   10 ++++++++++
 include/asm-powerpc/percpu.h      |    7 +++++++
 include/asm-s390/percpu.h         |    7 +++++++
 include/asm-sparc64/percpu.h      |    7 +++++++
 include/asm-x86_64/percpu.h       |    7 +++++++
 26 files changed, 82 insertions(+), 72 deletions(-)


diff -Nurp linux-2.6.21-rc7.0/arch/alpha/kernel/vmlinux.lds.S linux-2.6.21-rc7.1/arch/alpha/kernel/vmlinux.lds.S
--- linux-2.6.21-rc7.0/arch/alpha/kernel/vmlinux.lds.S	2007-05-01 07:32:58.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/alpha/kernel/vmlinux.lds.S	2007-05-14 12:44:40.000000000 -0700
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
diff -Nurp linux-2.6.21-rc7.0/arch/arm/kernel/vmlinux.lds.S linux-2.6.21-rc7.1/arch/arm/kernel/vmlinux.lds.S
--- linux-2.6.21-rc7.0/arch/arm/kernel/vmlinux.lds.S	2007-05-01 07:32:58.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/arm/kernel/vmlinux.lds.S	2007-05-14 12:44:40.000000000 -0700
@@ -59,10 +59,7 @@ SECTIONS
 			usr/built-in.o(.init.ramfs)
 		__initramfs_end = .;
 #endif
-		. = ALIGN(4096);
-		__per_cpu_start = .;
-			*(.data.percpu)
-		__per_cpu_end = .;
+		PERCPU(4096)
 #ifndef CONFIG_XIP_KERNEL
 		__init_begin = _stext;
 		*(.init.data)
diff -Nurp linux-2.6.21-rc7.0/arch/cris/arch-v32/vmlinux.lds.S linux-2.6.21-rc7.1/arch/cris/arch-v32/vmlinux.lds.S
--- linux-2.6.21-rc7.0/arch/cris/arch-v32/vmlinux.lds.S	2007-05-01 07:32:59.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/cris/arch-v32/vmlinux.lds.S	2007-05-14 12:44:40.000000000 -0700
@@ -92,10 +92,7 @@ SECTIONS
 	}
 	SECURITY_INIT
 
-	. =  ALIGN (8192);
-	__per_cpu_start = .;
-	.data.percpu  : { *(.data.percpu) }
-	__per_cpu_end = .;
+	PERCPU(8192)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	.init.ramfs : {
diff -Nurp linux-2.6.21-rc7.0/arch/frv/kernel/vmlinux.lds.S linux-2.6.21-rc7.1/arch/frv/kernel/vmlinux.lds.S
--- linux-2.6.21-rc7.0/arch/frv/kernel/vmlinux.lds.S	2007-05-01 07:32:59.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/frv/kernel/vmlinux.lds.S	2007-05-14 12:44:40.000000000 -0700
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
diff -Nurp linux-2.6.21-rc7.0/arch/i386/kernel/vmlinux.lds.S linux-2.6.21-rc7.1/arch/i386/kernel/vmlinux.lds.S
--- linux-2.6.21-rc7.0/arch/i386/kernel/vmlinux.lds.S	2007-05-01 07:32:59.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/i386/kernel/vmlinux.lds.S	2007-05-14 12:44:40.000000000 -0700
@@ -185,12 +185,7 @@ SECTIONS
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
 	
diff -Nurp linux-2.6.21-rc7.0/arch/ia64/kernel/vmlinux.lds.S linux-2.6.21-rc7.1/arch/ia64/kernel/vmlinux.lds.S
--- linux-2.6.21-rc7.0/arch/ia64/kernel/vmlinux.lds.S	2007-05-01 07:32:59.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/ia64/kernel/vmlinux.lds.S	2007-05-14 12:44:40.000000000 -0700
@@ -206,6 +206,7 @@ SECTIONS
 	{
 		__per_cpu_start = .;
 		*(.data.percpu)
+		*(.data.percpu.shared_aligned)
 		__per_cpu_end = .;
 	}
   . = __phys_per_cpu_start + PERCPU_PAGE_SIZE;	/* ensure percpu data fits
diff -Nurp linux-2.6.21-rc7.0/arch/m32r/kernel/vmlinux.lds.S linux-2.6.21-rc7.1/arch/m32r/kernel/vmlinux.lds.S
--- linux-2.6.21-rc7.0/arch/m32r/kernel/vmlinux.lds.S	2007-05-01 07:32:59.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/m32r/kernel/vmlinux.lds.S	2007-05-14 12:44:40.000000000 -0700
@@ -111,10 +111,7 @@ SECTIONS
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
diff -Nurp linux-2.6.21-rc7.0/arch/mips/kernel/vmlinux.lds.S linux-2.6.21-rc7.1/arch/mips/kernel/vmlinux.lds.S
--- linux-2.6.21-rc7.0/arch/mips/kernel/vmlinux.lds.S	2007-05-01 07:32:59.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/mips/kernel/vmlinux.lds.S	2007-05-14 12:44:40.000000000 -0700
@@ -121,10 +121,7 @@ SECTIONS
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
diff -Nurp linux-2.6.21-rc7.0/arch/parisc/kernel/vmlinux.lds.S linux-2.6.21-rc7.1/arch/parisc/kernel/vmlinux.lds.S
--- linux-2.6.21-rc7.0/arch/parisc/kernel/vmlinux.lds.S	2007-05-01 07:32:59.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/parisc/kernel/vmlinux.lds.S	2007-05-14 12:44:40.000000000 -0700
@@ -182,10 +182,9 @@ SECTIONS
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
diff -Nurp linux-2.6.21-rc7.0/arch/powerpc/kernel/vmlinux.lds.S linux-2.6.21-rc7.1/arch/powerpc/kernel/vmlinux.lds.S
--- linux-2.6.21-rc7.0/arch/powerpc/kernel/vmlinux.lds.S	2007-05-01 07:32:59.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/powerpc/kernel/vmlinux.lds.S	2007-05-14 12:44:40.000000000 -0700
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
diff -Nurp linux-2.6.21-rc7.0/arch/ppc/kernel/vmlinux.lds.S linux-2.6.21-rc7.1/arch/ppc/kernel/vmlinux.lds.S
--- linux-2.6.21-rc7.0/arch/ppc/kernel/vmlinux.lds.S	2007-05-01 07:32:59.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/ppc/kernel/vmlinux.lds.S	2007-05-14 12:44:40.000000000 -0700
@@ -131,10 +131,7 @@ SECTIONS
   __ftr_fixup : { *(__ftr_fixup) }
   __stop___ftr_fixup = .;
 
-  . = ALIGN(4096);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(4096)
 
 #ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(4096);
diff -Nurp linux-2.6.21-rc7.0/arch/s390/kernel/vmlinux.lds.S linux-2.6.21-rc7.1/arch/s390/kernel/vmlinux.lds.S
--- linux-2.6.21-rc7.0/arch/s390/kernel/vmlinux.lds.S	2007-05-01 07:32:59.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/s390/kernel/vmlinux.lds.S	2007-05-14 12:44:40.000000000 -0700
@@ -108,10 +108,7 @@ SECTIONS
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
diff -Nurp linux-2.6.21-rc7.0/arch/sh/kernel/vmlinux.lds.S linux-2.6.21-rc7.1/arch/sh/kernel/vmlinux.lds.S
--- linux-2.6.21-rc7.0/arch/sh/kernel/vmlinux.lds.S	2007-05-01 07:32:59.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/sh/kernel/vmlinux.lds.S	2007-05-14 12:44:40.000000000 -0700
@@ -61,10 +61,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   __nosave_end = .;
 
-  . = ALIGN(PAGE_SIZE);
-  __per_cpu_start = .;
-  .data.percpu : { *(.data.percpu) }
-  __per_cpu_end = .;
+  PERCPU(PAGE_SIZE)
   .data.cacheline_aligned : { *(.data.cacheline_aligned) }
 
   _edata = .;			/* End of data section */
diff -Nurp linux-2.6.21-rc7.0/arch/sh64/kernel/vmlinux.lds.S linux-2.6.21-rc7.1/arch/sh64/kernel/vmlinux.lds.S
--- linux-2.6.21-rc7.0/arch/sh64/kernel/vmlinux.lds.S	2007-05-01 07:32:59.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/sh64/kernel/vmlinux.lds.S	2007-05-14 12:44:40.000000000 -0700
@@ -86,10 +86,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   .data.page_aligned : C_PHYS(.data.page_aligned) { *(.data.page_aligned) }
 
-  . = ALIGN(PAGE_SIZE);
-  __per_cpu_start = .;
-  .data.percpu : C_PHYS(.data.percpu) { *(.data.percpu) }
-  __per_cpu_end = . ;
+  PERCPU(PAGE_SIZE)
   .data.cacheline_aligned : C_PHYS(.data.cacheline_aligned) { *(.data.cacheline_aligned) }
 
   _edata = .;			/* End of data section */
diff -Nurp linux-2.6.21-rc7.0/arch/sparc/kernel/vmlinux.lds.S linux-2.6.21-rc7.1/arch/sparc/kernel/vmlinux.lds.S
--- linux-2.6.21-rc7.0/arch/sparc/kernel/vmlinux.lds.S	2007-05-01 07:32:59.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/sparc/kernel/vmlinux.lds.S	2007-05-14 12:44:40.000000000 -0700
@@ -66,10 +66,7 @@ SECTIONS
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
diff -Nurp linux-2.6.21-rc7.0/arch/sparc64/kernel/vmlinux.lds.S linux-2.6.21-rc7.1/arch/sparc64/kernel/vmlinux.lds.S
--- linux-2.6.21-rc7.0/arch/sparc64/kernel/vmlinux.lds.S	2007-05-01 07:32:59.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/sparc64/kernel/vmlinux.lds.S	2007-05-14 12:44:40.000000000 -0700
@@ -90,10 +90,7 @@ SECTIONS
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
diff -Nurp linux-2.6.21-rc7.0/arch/x86_64/kernel/vmlinux.lds.S linux-2.6.21-rc7.1/arch/x86_64/kernel/vmlinux.lds.S
--- linux-2.6.21-rc7.0/arch/x86_64/kernel/vmlinux.lds.S	2007-05-01 07:32:59.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/x86_64/kernel/vmlinux.lds.S	2007-05-14 12:44:40.000000000 -0700
@@ -209,10 +209,8 @@ SECTIONS
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
diff -Nurp linux-2.6.21-rc7.0/arch/xtensa/kernel/vmlinux.lds.S linux-2.6.21-rc7.1/arch/xtensa/kernel/vmlinux.lds.S
--- linux-2.6.21-rc7.0/arch/xtensa/kernel/vmlinux.lds.S	2007-05-01 07:32:59.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/xtensa/kernel/vmlinux.lds.S	2007-05-14 12:44:40.000000000 -0700
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
diff -Nurp linux-2.6.21-rc7.0/include/asm-generic/percpu.h linux-2.6.21-rc7.1/include/asm-generic/percpu.h
--- linux-2.6.21-rc7.0/include/asm-generic/percpu.h	2007-05-01 07:33:03.000000000 -0700
+++ linux-2.6.21-rc7.1/include/asm-generic/percpu.h	2007-05-14 14:16:15.000000000 -0700
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
diff -Nurp linux-2.6.21-rc7.0/include/asm-generic/vmlinux.lds.h linux-2.6.21-rc7.1/include/asm-generic/vmlinux.lds.h
--- linux-2.6.21-rc7.0/include/asm-generic/vmlinux.lds.h	2007-05-01 07:33:03.000000000 -0700
+++ linux-2.6.21-rc7.1/include/asm-generic/vmlinux.lds.h	2007-05-14 14:16:38.000000000 -0700
@@ -265,3 +265,13 @@
   	*(.initcall6s.init)						\
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
+
+#define PERCPU(align)							\
+  . = ALIGN(align);							\
+  __per_cpu_start = .;							\
+  .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
+	*(.data.percpu)							\
+	*(.data.percpu.shared_aligned)					\
+  }									\
+  __per_cpu_end = .;
+
diff -Nurp linux-2.6.21-rc7.0/include/asm-i386/percpu.h linux-2.6.21-rc7.1/include/asm-i386/percpu.h
--- linux-2.6.21-rc7.0/include/asm-i386/percpu.h	2007-05-01 07:33:03.000000000 -0700
+++ linux-2.6.21-rc7.1/include/asm-i386/percpu.h	2007-05-14 14:17:16.000000000 -0700
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
 
diff -Nurp linux-2.6.21-rc7.0/include/asm-ia64/percpu.h linux-2.6.21-rc7.1/include/asm-ia64/percpu.h
--- linux-2.6.21-rc7.0/include/asm-ia64/percpu.h	2007-04-15 16:50:57.000000000 -0700
+++ linux-2.6.21-rc7.1/include/asm-ia64/percpu.h	2007-05-14 14:17:38.000000000 -0700
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
diff -Nurp linux-2.6.21-rc7.0/include/asm-powerpc/percpu.h linux-2.6.21-rc7.1/include/asm-powerpc/percpu.h
--- linux-2.6.21-rc7.0/include/asm-powerpc/percpu.h	2007-04-15 16:50:57.000000000 -0700
+++ linux-2.6.21-rc7.1/include/asm-powerpc/percpu.h	2007-05-14 14:17:58.000000000 -0700
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
diff -Nurp linux-2.6.21-rc7.0/include/asm-s390/percpu.h linux-2.6.21-rc7.1/include/asm-s390/percpu.h
--- linux-2.6.21-rc7.0/include/asm-s390/percpu.h	2007-04-15 16:50:57.000000000 -0700
+++ linux-2.6.21-rc7.1/include/asm-s390/percpu.h	2007-05-14 14:18:12.000000000 -0700
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
diff -Nurp linux-2.6.21-rc7.0/include/asm-sparc64/percpu.h linux-2.6.21-rc7.1/include/asm-sparc64/percpu.h
--- linux-2.6.21-rc7.0/include/asm-sparc64/percpu.h	2007-05-01 07:33:06.000000000 -0700
+++ linux-2.6.21-rc7.1/include/asm-sparc64/percpu.h	2007-05-14 14:18:27.000000000 -0700
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
diff -Nurp linux-2.6.21-rc7.0/include/asm-x86_64/percpu.h linux-2.6.21-rc7.1/include/asm-x86_64/percpu.h
--- linux-2.6.21-rc7.0/include/asm-x86_64/percpu.h	2007-05-01 07:33:06.000000000 -0700
+++ linux-2.6.21-rc7.1/include/asm-x86_64/percpu.h	2007-05-14 14:19:40.000000000 -0700
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
