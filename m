Return-Path: <linux-kernel-owner+w=401wt.eu-S1760228AbYACAvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228AbYACAvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbYACAuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:50:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060AbYACAuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:50:02 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103149.088038000@suse.de>
In-Reply-To: <20080103149.088038000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [5/20] x86: Introduce nsec_barrier() 
Message-Id: <20080103005000.65D0C14D40@wotan.suse.de>
Date: Thu,  3 Jan 2008 01:50:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


nsec_barrier() is a new barrier primitive that stops RDTSC speculation
to avoid races with timer interrupts on other CPUs.

Add it to all architectures. Except for x86 it is a nop right now.
I only tested x86, but it's a very simple change.

On x86 it expands either to LFENCE (for Intel CPUs) or MFENCE (for
AMD CPUs) which stops RDTSC on all currently known microarchitectures
that implement SSE. On CPUs without SSE there is generally no RDTSC
speculation.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/vsyscall_64.c  |    2 ++
 include/asm-alpha/barrier.h    |    2 ++
 include/asm-arm/system.h       |    1 +
 include/asm-avr32/system.h     |    1 +
 include/asm-blackfin/system.h  |    1 +
 include/asm-cris/system.h      |    1 +
 include/asm-frv/system.h       |    1 +
 include/asm-h8300/system.h     |    1 +
 include/asm-ia64/system.h      |    1 +
 include/asm-m32r/system.h      |    1 +
 include/asm-m68k/system.h      |    1 +
 include/asm-m68knommu/system.h |    1 +
 include/asm-mips/barrier.h     |    2 ++
 include/asm-parisc/system.h    |    1 +
 include/asm-powerpc/system.h   |    1 +
 include/asm-ppc/system.h       |    1 +
 include/asm-s390/system.h      |    1 +
 include/asm-sh/system.h        |    1 +
 include/asm-sparc/system.h     |    1 +
 include/asm-sparc64/system.h   |    2 ++
 include/asm-v850/system.h      |    2 ++
 include/asm-x86/system.h       |   11 +++++++++++
 include/asm-xtensa/system.h    |    1 +
 kernel/time/timekeeping.c      |    2 ++
 24 files changed, 40 insertions(+)

Index: linux/arch/x86/kernel/vsyscall_64.c
===================================================================
--- linux.orig/arch/x86/kernel/vsyscall_64.c
+++ linux/arch/x86/kernel/vsyscall_64.c
@@ -126,6 +126,7 @@ static __always_inline void do_vgettimeo
 	cycle_t (*vread)(void);
 	do {
 		seq = read_seqbegin(&__vsyscall_gtod_data.lock);
+		nsec_barrier();
 
 		vread = __vsyscall_gtod_data.clock.vread;
 		if (unlikely(!__vsyscall_gtod_data.sysctl_enabled || !vread)) {
@@ -140,6 +141,7 @@ static __always_inline void do_vgettimeo
 
 		tv->tv_sec = __vsyscall_gtod_data.wall_time_sec;
 		nsec = __vsyscall_gtod_data.wall_time_nsec;
+		nsec_barrier();
 	} while (read_seqretry(&__vsyscall_gtod_data.lock, seq));
 
 	/* calculate interval: */
Index: linux/kernel/time/timekeeping.c
===================================================================
--- linux.orig/kernel/time/timekeeping.c
+++ linux/kernel/time/timekeeping.c
@@ -94,10 +94,12 @@ void getnstimeofday(struct timespec *ts)
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
+		nsec_barrier();
 
 		*ts = xtime;
 		nsecs = __get_nsec_offset();
 
+		nsec_barrier();
 	} while (read_seqretry(&xtime_lock, seq));
 
 	timespec_add_ns(ts, nsecs);
Index: linux/include/asm-x86/system.h
===================================================================
--- linux.orig/include/asm-x86/system.h
+++ linux/include/asm-x86/system.h
@@ -5,6 +5,7 @@
 #include <asm/segment.h>
 #include <asm/cpufeature.h>
 #include <asm/cmpxchg.h>
+#include <asm/nops.h>
 
 #include <linux/kernel.h>
 #include <linux/irqflags.h>
@@ -395,5 +396,15 @@ void default_idle(void);
 #define set_mb(var, value) do { var = value; barrier(); } while (0)
 #endif
 
+/* Stop RDTSC speculation. This is needed when you need to use RDTSC
+ * (or get_cycles or vread that possibly accesses the TSC) in a defined
+ * code region.
+ * Could use an alternative three way for this if there was one.
+ */
+static inline void nsec_barrier(void)
+{
+	alternative(ASM_NOP3, "mfence", X86_FEATURE_MFENCE_RDTSC);
+	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);
+}
 
 #endif
Index: linux/include/asm-alpha/barrier.h
===================================================================
--- linux.orig/include/asm-alpha/barrier.h
+++ linux/include/asm-alpha/barrier.h
@@ -15,6 +15,8 @@ __asm__ __volatile__("wmb": : :"memory")
 #define read_barrier_depends() \
 __asm__ __volatile__("mb": : :"memory")
 
+#define nsec_barrier() barrier()
+
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
 #define smp_rmb()	rmb()
Index: linux/include/asm-arm/system.h
===================================================================
--- linux.orig/include/asm-arm/system.h
+++ linux/include/asm-arm/system.h
@@ -191,6 +191,7 @@ extern unsigned int user_debug;
 #endif
 #define read_barrier_depends()		do { } while(0)
 #define smp_read_barrier_depends()	do { } while(0)
+#define nsec_barrier()			barrier()
 
 #define set_mb(var, value)	do { var = value; smp_mb(); } while (0)
 #define nop() __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t");
Index: linux/include/asm-avr32/system.h
===================================================================
--- linux.orig/include/asm-avr32/system.h
+++ linux/include/asm-avr32/system.h
@@ -25,6 +25,7 @@
 #define wmb()			asm volatile("sync 0" : : : "memory")
 #define read_barrier_depends()  do { } while(0)
 #define set_mb(var, value)      do { var = value; mb(); } while(0)
+#define nsec_barrier()		barrier();
 
 /*
  * Help PathFinder and other Nexus-compliant debuggers keep track of
Index: linux/include/asm-blackfin/system.h
===================================================================
--- linux.orig/include/asm-blackfin/system.h
+++ linux/include/asm-blackfin/system.h
@@ -128,6 +128,7 @@ extern unsigned long irq_flags;
 #define mb()   asm volatile (""   : : :"memory")
 #define rmb()  asm volatile (""   : : :"memory")
 #define wmb()  asm volatile (""   : : :"memory")
+#define nsec_barrier() barrier()
 #define set_mb(var, value) do { (void) xchg(&var, value); } while (0)
 
 #define read_barrier_depends() 		do { } while(0)
Index: linux/include/asm-cris/system.h
===================================================================
--- linux.orig/include/asm-cris/system.h
+++ linux/include/asm-cris/system.h
@@ -15,6 +15,7 @@ extern struct task_struct *resume(struct
 #define mb() barrier()
 #define rmb() mb()
 #define wmb() mb()
+#define nsec_barrier() barrier()
 #define read_barrier_depends() do { } while(0)
 #define set_mb(var, value)  do { var = value; mb(); } while (0)
 
Index: linux/include/asm-frv/system.h
===================================================================
--- linux.orig/include/asm-frv/system.h
+++ linux/include/asm-frv/system.h
@@ -179,6 +179,7 @@ do {							\
 #define rmb()			asm volatile ("membar" : : :"memory")
 #define wmb()			asm volatile ("membar" : : :"memory")
 #define set_mb(var, value)	do { var = value; mb(); } while (0)
+#define nsec_barrier()		barrier()
 
 #define smp_mb()		mb()
 #define smp_rmb()		rmb()
Index: linux/include/asm-h8300/system.h
===================================================================
--- linux.orig/include/asm-h8300/system.h
+++ linux/include/asm-h8300/system.h
@@ -83,6 +83,7 @@ asmlinkage void resume(void);
 #define rmb()  asm volatile (""   : : :"memory")
 #define wmb()  asm volatile (""   : : :"memory")
 #define set_mb(var, value) do { xchg(&var, value); } while (0)
+#define nsec_barrier()	barrier()
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
Index: linux/include/asm-ia64/system.h
===================================================================
--- linux.orig/include/asm-ia64/system.h
+++ linux/include/asm-ia64/system.h
@@ -86,6 +86,7 @@ extern struct ia64_boot_param {
 #define rmb()	mb()
 #define wmb()	mb()
 #define read_barrier_depends()	do { } while(0)
+#define nsec_barrier()	barrier()
 
 #ifdef CONFIG_SMP
 # define smp_mb()	mb()
Index: linux/include/asm-m32r/system.h
===================================================================
--- linux.orig/include/asm-m32r/system.h
+++ linux/include/asm-m32r/system.h
@@ -267,6 +267,7 @@ __cmpxchg(volatile void *ptr, unsigned l
 #define mb()   barrier()
 #define rmb()  mb()
 #define wmb()  mb()
+#define nsec_barrier() barrier()
 
 /**
  * read_barrier_depends - Flush all pending reads that subsequents reads
Index: linux/include/asm-m68k/system.h
===================================================================
--- linux.orig/include/asm-m68k/system.h
+++ linux/include/asm-m68k/system.h
@@ -56,6 +56,7 @@ asmlinkage void resume(void);
 #define wmb()		barrier()
 #define read_barrier_depends()	((void)0)
 #define set_mb(var, value)	({ (var) = (value); wmb(); })
+#define nsec_barrier()		barrier()
 
 #define smp_mb()	barrier()
 #define smp_rmb()	barrier()
Index: linux/include/asm-m68knommu/system.h
===================================================================
--- linux.orig/include/asm-m68knommu/system.h
+++ linux/include/asm-m68knommu/system.h
@@ -105,6 +105,7 @@ asmlinkage void resume(void);
 #define rmb()  asm volatile (""   : : :"memory")
 #define wmb()  asm volatile (""   : : :"memory")
 #define set_mb(var, value) do { xchg(&var, value); } while (0)
+#define nsec_barrier() barrier()
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
Index: linux/include/asm-mips/barrier.h
===================================================================
--- linux.orig/include/asm-mips/barrier.h
+++ linux/include/asm-mips/barrier.h
@@ -138,4 +138,6 @@
 #define smp_llsc_rmb()	__asm__ __volatile__(__WEAK_LLSC_MB : : :"memory")
 #define smp_llsc_wmb()	__asm__ __volatile__(__WEAK_LLSC_MB : : :"memory")
 
+#define nsec_barrier() barrier()
+
 #endif /* __ASM_BARRIER_H */
Index: linux/include/asm-parisc/system.h
===================================================================
--- linux.orig/include/asm-parisc/system.h
+++ linux/include/asm-parisc/system.h
@@ -130,6 +130,7 @@ static inline void set_eiem(unsigned lon
 #define smp_wmb()	mb()
 #define smp_read_barrier_depends()	do { } while(0)
 #define read_barrier_depends()		do { } while(0)
+#define nsec_barrier()	barrier()
 
 #define set_mb(var, value)		do { var = value; mb(); } while (0)
 
Index: linux/include/asm-powerpc/system.h
===================================================================
--- linux.orig/include/asm-powerpc/system.h
+++ linux/include/asm-powerpc/system.h
@@ -36,6 +36,7 @@
 #define rmb()  __asm__ __volatile__ (__stringify(LWSYNC) : : : "memory")
 #define wmb()  __asm__ __volatile__ ("sync" : : : "memory")
 #define read_barrier_depends()  do { } while(0)
+#define nsec_barrier()	barrier()
 
 #define set_mb(var, value)	do { var = value; mb(); } while (0)
 
Index: linux/include/asm-ppc/system.h
===================================================================
--- linux.orig/include/asm-ppc/system.h
+++ linux/include/asm-ppc/system.h
@@ -30,6 +30,7 @@
 #define rmb()  __asm__ __volatile__ ("sync" : : : "memory")
 #define wmb()  __asm__ __volatile__ ("eieio" : : : "memory")
 #define read_barrier_depends()  do { } while(0)
+#define nsec_barrier() barrier()
 
 #define set_mb(var, value)	do { var = value; mb(); } while (0)
 
Index: linux/include/asm-s390/system.h
===================================================================
--- linux.orig/include/asm-s390/system.h
+++ linux/include/asm-s390/system.h
@@ -297,6 +297,7 @@ __cmpxchg(volatile void *ptr, unsigned l
 #define smp_read_barrier_depends()    read_barrier_depends()
 #define smp_mb__before_clear_bit()     smp_mb()
 #define smp_mb__after_clear_bit()      smp_mb()
+#define nsec_barrier()	barrier()
 
 
 #define set_mb(var, value)      do { var = value; mb(); } while (0)
Index: linux/include/asm-sh/system.h
===================================================================
--- linux.orig/include/asm-sh/system.h
+++ linux/include/asm-sh/system.h
@@ -104,6 +104,7 @@ struct task_struct *__switch_to(struct t
 #define ctrl_barrier()	__asm__ __volatile__ ("nop;nop;nop;nop;nop;nop;nop;nop")
 #define read_barrier_depends()	do { } while(0)
 #endif
+#define nsec_barrier()	barrier()
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
Index: linux/include/asm-sparc/system.h
===================================================================
--- linux.orig/include/asm-sparc/system.h
+++ linux/include/asm-sparc/system.h
@@ -174,6 +174,7 @@ extern void fpsave(unsigned long *fpregs
 #define smp_rmb()	__asm__ __volatile__("":::"memory")
 #define smp_wmb()	__asm__ __volatile__("":::"memory")
 #define smp_read_barrier_depends()	do { } while(0)
+#define nsec_barrier()	barrier()
 
 #define nop() __asm__ __volatile__ ("nop")
 
Index: linux/include/asm-sparc64/system.h
===================================================================
--- linux.orig/include/asm-sparc64/system.h
+++ linux/include/asm-sparc64/system.h
@@ -74,6 +74,8 @@ do {	__asm__ __volatile__("ba,pt	%%xcc, 
 
 #endif
 
+#define nsec_barrier() barrier()
+
 #define nop() 		__asm__ __volatile__ ("nop")
 
 #define read_barrier_depends()		do { } while(0)
Index: linux/include/asm-v850/system.h
===================================================================
--- linux.orig/include/asm-v850/system.h
+++ linux/include/asm-v850/system.h
@@ -73,6 +73,8 @@ static inline int irqs_disabled (void)
 #define smp_wmb()	wmb ()
 #define smp_read_barrier_depends()	read_barrier_depends()
 
+#define nsec_barrier()	barrier()
+
 #define xchg(ptr, with) \
   ((__typeof__ (*(ptr)))__xchg ((unsigned long)(with), (ptr), sizeof (*(ptr))))
 
Index: linux/include/asm-xtensa/system.h
===================================================================
--- linux.orig/include/asm-xtensa/system.h
+++ linux/include/asm-xtensa/system.h
@@ -89,6 +89,7 @@ static inline void disable_coprocessor(i
 #define mb()  barrier()
 #define rmb() mb()
 #define wmb() mb()
+#define nsec_barrier() barrier()
 
 #ifdef CONFIG_SMP
 #error smp_* not defined
