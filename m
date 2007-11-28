Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbXK1VQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbXK1VQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 16:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbXK1VPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 16:15:30 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56236 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755166AbXK1VP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 16:15:27 -0500
Message-Id: <20071128211526.395581258@sgi.com>
References: <20071128210926.008783214@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 28 Nov 2007 13:09:28 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>
Subject: [patch 02/10] percpu: Move arch XX_PER_CPU_XX definitions into linux/percpu.h
Content-Disposition: inline; filename=move_percpu_declarations
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

V1->V2:
- Special consideration for IA64: Add the ability to specify
  arch specific per cpu flags

The arch definitions are all the same. So move them into linux/percpu.h.

We cannot move DECLARE_PER_CPU since some include files just include
asm/percpu.h to avoid include recursion problems.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-generic/percpu.h |   18 ------------------
 include/asm-ia64/percpu.h    |   24 ++----------------------
 include/asm-powerpc/percpu.h |   17 -----------------
 include/asm-s390/percpu.h    |   18 ------------------
 include/asm-sparc64/percpu.h |   16 ----------------
 include/asm-x86/percpu_32.h  |   12 ------------
 include/asm-x86/percpu_64.h  |   17 -----------------
 include/linux/percpu.h       |   21 +++++++++++++++++++++
 8 files changed, 23 insertions(+), 120 deletions(-)

Index: linux-2.6.24-rc3-mm2/include/linux/percpu.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/linux/percpu.h	2007-11-28 12:51:21.231963697 -0800
+++ linux-2.6.24-rc3-mm2/include/linux/percpu.h	2007-11-28 12:51:42.448213150 -0800
@@ -9,6 +9,27 @@
 
 #include <asm/percpu.h>
 
+#ifndef PER_CPU_ATTRIBUTES
+#define PER_CPU_ATTRIBUTES
+#endif
+
+#define DEFINE_PER_CPU(type, name)					\
+	__attribute__((__section__(".data.percpu")))			\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+
+#ifdef CONFIG_SMP
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
+	__attribute__((__section__(".data.percpu.shared_aligned")))	\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name		\
+	____cacheline_aligned_in_smp
+#else
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		      \
+	DEFINE_PER_CPU(type, name)
+#endif
+
+#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
+#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
+
 /* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
 #ifndef PERCPU_ENOUGH_ROOM
 #ifdef CONFIG_MODULES
Index: linux-2.6.24-rc3-mm2/include/asm-generic/percpu.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-generic/percpu.h	2007-11-28 12:51:38.782051096 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-generic/percpu.h	2007-11-28 12:51:42.448213150 -0800
@@ -9,15 +9,6 @@ extern unsigned long __per_cpu_offset[NR
 
 #define per_cpu_offset(x) (__per_cpu_offset[x])
 
-/* Separate out the type, so (int[3], foo) works. */
-#define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
-    ____cacheline_aligned_in_smp
-
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*({				\
 	extern int simple_identifier_##var(void);	\
@@ -27,12 +18,6 @@ extern unsigned long __per_cpu_offset[NR
 
 #else /* ! SMP */
 
-#define DEFINE_PER_CPU(type, name) \
-    __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
-    DEFINE_PER_CPU(type, name)
-
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
 #define __raw_get_cpu_var(var)			per_cpu__##var
@@ -41,7 +26,4 @@ extern unsigned long __per_cpu_offset[NR
 
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
 
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-
 #endif /* _ASM_GENERIC_PERCPU_H_ */
Index: linux-2.6.24-rc3-mm2/include/asm-ia64/percpu.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-ia64/percpu.h	2007-11-28 12:51:21.255962978 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-ia64/percpu.h	2007-11-28 12:51:42.448213150 -0800
@@ -16,28 +16,11 @@
 #include <linux/threads.h>
 
 #ifdef HAVE_MODEL_SMALL_ATTRIBUTE
-# define __SMALL_ADDR_AREA	__attribute__((__model__ (__small__)))
-#else
-# define __SMALL_ADDR_AREA
+# define PER_CPU_ATTRIBUTES	__attribute__((__model__ (__small__)))
 #endif
 
 #define DECLARE_PER_CPU(type, name)				\
-	extern __SMALL_ADDR_AREA __typeof__(type) per_cpu__##name
-
-/* Separate out the type, so (int[3], foo) works. */
-#define DEFINE_PER_CPU(type, name)				\
-	__attribute__((__section__(".data.percpu")))		\
-	__SMALL_ADDR_AREA __typeof__(type) per_cpu__##name
-
-#ifdef CONFIG_SMP
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
-	__attribute__((__section__(".data.percpu.shared_aligned")))	\
-	__SMALL_ADDR_AREA __typeof__(type) per_cpu__##name		\
-	____cacheline_aligned_in_smp
-#else
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
-	DEFINE_PER_CPU(type, name)
-#endif
+	extern PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 
 #ifdef CONFIG_SMP
 
@@ -63,9 +46,6 @@ extern void *per_cpu_init(void);
 
 #endif	/* SMP */
 
-#define EXPORT_PER_CPU_SYMBOL(var)		EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var)		EXPORT_SYMBOL_GPL(per_cpu__##var)
-
 /*
  * Be extremely careful when taking the address of this variable!  Due to virtual
  * remapping, it is different from the canonical address returned by __get_cpu_var(var)!
Index: linux-2.6.24-rc3-mm2/include/asm-powerpc/percpu.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-powerpc/percpu.h	2007-11-28 12:51:21.267963102 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-powerpc/percpu.h	2007-11-28 12:51:42.448213150 -0800
@@ -16,15 +16,6 @@
 #define __my_cpu_offset() get_paca()->data_offset
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
-/* Separate out the type, so (int[3], foo) works. */
-#define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
-    ____cacheline_aligned_in_smp
-
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*RELOC_HIDE(&per_cpu__##var, __per_cpu_offset(cpu)))
 #define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()))
@@ -34,11 +25,6 @@ extern void setup_per_cpu_areas(void);
 
 #else /* ! SMP */
 
-#define DEFINE_PER_CPU(type, name) \
-    __typeof__(type) per_cpu__##name
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
-    DEFINE_PER_CPU(type, name)
-
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
 #define __raw_get_cpu_var(var)			per_cpu__##var
@@ -47,9 +33,6 @@ extern void setup_per_cpu_areas(void);
 
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
 
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-
 #else
 #include <asm-generic/percpu.h>
 #endif
Index: linux-2.6.24-rc3-mm2/include/asm-s390/percpu.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-s390/percpu.h	2007-11-28 12:51:38.784139633 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-s390/percpu.h	2007-11-28 12:51:42.448213150 -0800
@@ -34,16 +34,6 @@
 
 extern unsigned long __per_cpu_offset[NR_CPUS];
 
-/* Separate out the type, so (int[3], foo) works. */
-#define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) \
-    __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
-    ____cacheline_aligned_in_smp
-
 #define __get_cpu_var(var) __reloc_hide(var,S390_lowcore.percpu_offset)
 #define __raw_get_cpu_var(var) __reloc_hide(var,S390_lowcore.percpu_offset)
 #define per_cpu(var,cpu) __reloc_hide(var,__per_cpu_offset[cpu])
@@ -51,11 +41,6 @@ extern unsigned long __per_cpu_offset[NR
 
 #else /* ! SMP */
 
-#define DEFINE_PER_CPU(type, name) \
-    __typeof__(type) per_cpu__##name
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
-    DEFINE_PER_CPU(type, name)
-
 #define __get_cpu_var(var) __reloc_hide(var,0)
 #define __raw_get_cpu_var(var) __reloc_hide(var,0)
 #define per_cpu(var,cpu) __reloc_hide(var,0)
@@ -64,7 +49,4 @@ extern unsigned long __per_cpu_offset[NR
 
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
 
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-
 #endif /* __ARCH_S390_PERCPU__ */
Index: linux-2.6.24-rc3-mm2/include/asm-sparc64/percpu.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-sparc64/percpu.h	2007-11-28 12:51:21.291963355 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-sparc64/percpu.h	2007-11-28 12:51:42.448213150 -0800
@@ -16,15 +16,6 @@ extern unsigned long __per_cpu_shift;
 	(__per_cpu_base + ((unsigned long)(__cpu) << __per_cpu_shift))
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
-/* Separate out the type, so (int[3], foo) works. */
-#define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
-    ____cacheline_aligned_in_smp
-
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*RELOC_HIDE(&per_cpu__##var, __per_cpu_offset(cpu)))
 #define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __local_per_cpu_offset))
@@ -33,10 +24,6 @@ extern unsigned long __per_cpu_shift;
 #else /* ! SMP */
 
 #define real_setup_per_cpu_areas()		do { } while (0)
-#define DEFINE_PER_CPU(type, name) \
-    __typeof__(type) per_cpu__##name
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
-    DEFINE_PER_CPU(type, name)
 
 #define per_cpu(var, cpu)			(*((void)cpu, &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
@@ -46,7 +33,4 @@ extern unsigned long __per_cpu_shift;
 
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
 
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-
 #endif /* __ARCH_SPARC64_PERCPU__ */
Index: linux-2.6.24-rc3-mm2/include/asm-x86/percpu_32.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-x86/percpu_32.h	2007-11-28 12:51:38.782051096 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-x86/percpu_32.h	2007-11-28 12:51:42.448213150 -0800
@@ -47,16 +47,7 @@ extern unsigned long __per_cpu_offset[];
 
 #define per_cpu_offset(x) (__per_cpu_offset[x])
 
-/* Separate out the type, so (int[3], foo) works. */
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
-#define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
-    ____cacheline_aligned_in_smp
-
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
@@ -72,9 +63,6 @@ DECLARE_PER_CPU(unsigned long, this_cpu_
 
 #define __get_cpu_var(var) __raw_get_cpu_var(var)
 
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-
 /* fs segment starts at (positive) offset == __per_cpu_offset[cpu] */
 #define __percpu_seg "%%fs:"
 #else  /* !SMP */
Index: linux-2.6.24-rc3-mm2/include/asm-x86/percpu_64.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-x86/percpu_64.h	2007-11-28 12:51:21.315963460 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-x86/percpu_64.h	2007-11-28 12:51:42.452213062 -0800
@@ -16,15 +16,6 @@
 
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
-/* Separate out the type, so (int[3], foo) works. */
-#define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
-    ____cacheline_internodealigned_in_smp
-
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*({				\
 	extern int simple_identifier_##var(void);	\
@@ -40,11 +31,6 @@ extern void setup_per_cpu_areas(void);
 
 #else /* ! SMP */
 
-#define DEFINE_PER_CPU(type, name) \
-    __typeof__(type) per_cpu__##name
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
-    DEFINE_PER_CPU(type, name)
-
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
 #define __raw_get_cpu_var(var)			per_cpu__##var
@@ -53,7 +39,4 @@ extern void setup_per_cpu_areas(void);
 
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
 
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-
 #endif /* _ASM_X8664_PERCPU_H_ */

-- 
