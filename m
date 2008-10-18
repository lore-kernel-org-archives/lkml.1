Return-Path: <linux-kernel-owner+w=401wt.eu-S1752168AbYJREAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbYJREAa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 00:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbYJREAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 00:00:22 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40579 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbYJREAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 00:00:20 -0400
Date: Fri, 17 Oct 2008 22:00:03 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, ying.huang@intel.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, tglx@linutronix.de
Subject: Re: [PATCH -mm -v5] Separate atomic_t declaration from asm/atomic.h into asm/atomic_def.h
Message-ID: <20081018040002.GW15064@parisc-linux.org>
References: <1223459070.5872.167.camel@yhuang-dev.sh.intel.com> <20081010144335.65d8153b.akpm@linux-foundation.org> <20081010214958.GA7708@elte.hu> <20081010155450.094288b4.akpm@linux-foundation.org> <20081014184718.GG15064@parisc-linux.org> <20081015151119.493ea13f.akpm@linux-foundation.org> <20081015221947.GN15064@parisc-linux.org> <20081015153124.c560e97e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015153124.c560e97e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 03:31:24PM -0700, Andrew Morton wrote:
> Well we've been glacially fartarsing around with this for sufficiently
> long that any such alterations will be too late for 2.6.28.
> 
> I'll drop it all.  Again.

Here's an updated patch which uses linux/types.h as suggested by Roman.
I started fresh rather than use the original patch.  I compared the
diffstats afterwards and I caught one architecture the original didn't
(parisc), plus the original was creating files in include/asm-*/ even
for architectures that had migrated to arch/*/include/asm.

---

The atomic_t type cannot currently be used in some header files because it
would create an include loop with asm/atomic.h.  Move the type definition
to linux/types.h to break the loop.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

 arch/alpha/include/asm/atomic.h     |    9 +--------
 arch/arm/include/asm/atomic.h       |    3 +--
 arch/avr32/include/asm/atomic.h     |    2 +-
 arch/blackfin/include/asm/atomic.h  |    4 +---
 arch/h8300/include/asm/atomic.h     |    3 ++-
 arch/ia64/include/asm/atomic.h      |    6 ------
 arch/m68knommu/include/asm/atomic.h |    2 +-
 arch/mips/include/asm/atomic.h      |    5 +----
 arch/powerpc/include/asm/atomic.h   |    4 +---
 arch/s390/include/asm/atomic.h      |    7 +------
 arch/sh/include/asm/atomic.h        |    7 +++----
 arch/sparc/include/asm/atomic_32.h  |    2 --
 arch/sparc/include/asm/atomic_64.h  |    3 ---
 include/asm-cris/atomic.h           |    4 +---
 include/asm-frv/atomic.h            |    4 ----
 include/asm-m32r/atomic.h           |    8 +-------
 include/asm-m68k/atomic.h           |    3 +--
 include/asm-mn10300/atomic.h        |    9 ---------
 include/asm-parisc/atomic.h         |   11 +++--------
 include/asm-x86/atomic_32.h         |   10 +---------
 include/asm-x86/atomic_64.h         |   18 ++----------------
 include/asm-xtensa/atomic.h         |    3 +--
 include/linux/types.h               |   10 ++++++++++
 23 files changed, 33 insertions(+), 104 deletions(-)

diff --git a/arch/alpha/include/asm/atomic.h b/arch/alpha/include/asm/atomic.h
index ca88e54..62b3635 100644
--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -1,6 +1,7 @@
 #ifndef _ALPHA_ATOMIC_H
 #define _ALPHA_ATOMIC_H
 
+#include <linux/types.h>
 #include <asm/barrier.h>
 #include <asm/system.h>
 
@@ -13,14 +14,6 @@
  */
 
 
-/*
- * Counter is volatile to make sure gcc doesn't try to be clever
- * and move things around on us. We need to use _exactly_ the address
- * the user gave us, not some alias that contains the same information.
- */
-typedef struct { volatile int counter; } atomic_t;
-typedef struct { volatile long counter; } atomic64_t;
-
 #define ATOMIC_INIT(i)		( (atomic_t) { (i) } )
 #define ATOMIC64_INIT(i)	( (atomic64_t) { (i) } )
 
diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index 325f881..ee99723 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -12,10 +12,9 @@
 #define __ASM_ARM_ATOMIC_H
 
 #include <linux/compiler.h>
+#include <linux/types.h>
 #include <asm/system.h>
 
-typedef struct { volatile int counter; } atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
 
 #ifdef __KERNEL__
diff --git a/arch/avr32/include/asm/atomic.h b/arch/avr32/include/asm/atomic.h
index 7ef3862..3188151 100644
--- a/arch/avr32/include/asm/atomic.h
+++ b/arch/avr32/include/asm/atomic.h
@@ -14,9 +14,9 @@
 #ifndef __ASM_AVR32_ATOMIC_H
 #define __ASM_AVR32_ATOMIC_H
 
+#include <linux/types.h>
 #include <asm/system.h>
 
-typedef struct { volatile int counter; } atomic_t;
 #define ATOMIC_INIT(i)  { (i) }
 
 #define atomic_read(v)		((v)->counter)
diff --git a/arch/blackfin/include/asm/atomic.h b/arch/blackfin/include/asm/atomic.h
index 7cf5087..25776c1 100644
--- a/arch/blackfin/include/asm/atomic.h
+++ b/arch/blackfin/include/asm/atomic.h
@@ -1,6 +1,7 @@
 #ifndef __ARCH_BLACKFIN_ATOMIC__
 #define __ARCH_BLACKFIN_ATOMIC__
 
+#include <linux/types.h>
 #include <asm/system.h>	/* local_irq_XXX() */
 
 /*
@@ -13,9 +14,6 @@
  * Tony Kou (tonyko@lineo.ca)   Lineo Inc.   2001
  */
 
-typedef struct {
-	int counter;
-} atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
 
 #define atomic_read(v)		((v)->counter)
diff --git a/arch/h8300/include/asm/atomic.h b/arch/h8300/include/asm/atomic.h
index b4cf0ea..833186c 100644
--- a/arch/h8300/include/asm/atomic.h
+++ b/arch/h8300/include/asm/atomic.h
@@ -1,12 +1,13 @@
 #ifndef __ARCH_H8300_ATOMIC__
 #define __ARCH_H8300_ATOMIC__
 
+#include <linux/types.h>
+
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
  */
 
-typedef struct { int counter; } atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
 
 #define atomic_read(v)		((v)->counter)
diff --git a/arch/ia64/include/asm/atomic.h b/arch/ia64/include/asm/atomic.h
index 50c2b83..d37292b 100644
--- a/arch/ia64/include/asm/atomic.h
+++ b/arch/ia64/include/asm/atomic.h
@@ -17,12 +17,6 @@
 #include <asm/intrinsics.h>
 #include <asm/system.h>
 
-/*
- * On IA-64, counter must always be volatile to ensure that that the
- * memory accesses are ordered.
- */
-typedef struct { volatile __s32 counter; } atomic_t;
-typedef struct { volatile __s64 counter; } atomic64_t;
 
 #define ATOMIC_INIT(i)		((atomic_t) { (i) })
 #define ATOMIC64_INIT(i)	((atomic64_t) { (i) })
diff --git a/arch/m68knommu/include/asm/atomic.h b/arch/m68knommu/include/asm/atomic.h
index d5632a3..6bb6748 100644
--- a/arch/m68knommu/include/asm/atomic.h
+++ b/arch/m68knommu/include/asm/atomic.h
@@ -1,6 +1,7 @@
 #ifndef __ARCH_M68KNOMMU_ATOMIC__
 #define __ARCH_M68KNOMMU_ATOMIC__
 
+#include <linux/types.h>
 #include <asm/system.h>
 
 /*
@@ -12,7 +13,6 @@
  * We do not have SMP m68k systems, so we don't have to deal with that.
  */
 
-typedef struct { int counter; } atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
 
 #define atomic_read(v)		((v)->counter)
diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index 1232be3..c996c3b 100644
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -15,13 +15,12 @@
 #define _ASM_ATOMIC_H
 
 #include <linux/irqflags.h>
+#include <linux/types.h>
 #include <asm/barrier.h>
 #include <asm/cpu-features.h>
 #include <asm/war.h>
 #include <asm/system.h>
 
-typedef struct { volatile int counter; } atomic_t;
-
 #define ATOMIC_INIT(i)    { (i) }
 
 /*
@@ -404,8 +403,6 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 
 #ifdef CONFIG_64BIT
 
-typedef struct { volatile long counter; } atomic64_t;
-
 #define ATOMIC64_INIT(i)    { (i) }
 
 /*
diff --git a/arch/powerpc/include/asm/atomic.h b/arch/powerpc/include/asm/atomic.h
index f3fc733..9c74e6d 100644
--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -5,7 +5,7 @@
  * PowerPC atomic operations
  */
 
-typedef struct { int counter; } atomic_t;
+#include <linux/types.h>
 
 #ifdef __KERNEL__
 #include <linux/compiler.h>
@@ -251,8 +251,6 @@ static __inline__ int atomic_dec_if_positive(atomic_t *v)
 
 #ifdef __powerpc64__
 
-typedef struct { long counter; } atomic64_t;
-
 #define ATOMIC64_INIT(i)	{ (i) }
 
 static __inline__ long atomic64_read(const atomic64_t *v)
diff --git a/arch/s390/include/asm/atomic.h b/arch/s390/include/asm/atomic.h
index 2d18465..de432f2 100644
--- a/arch/s390/include/asm/atomic.h
+++ b/arch/s390/include/asm/atomic.h
@@ -2,6 +2,7 @@
 #define __ARCH_S390_ATOMIC__
 
 #include <linux/compiler.h>
+#include <linux/types.h>
 
 /*
  *  include/asm-s390/atomic.h
@@ -23,9 +24,6 @@
  * S390 uses 'Compare And Swap' for atomicity in SMP enviroment
  */
 
-typedef struct {
-	int counter;
-} __attribute__ ((aligned (4))) atomic_t;
 #define ATOMIC_INIT(i)  { (i) }
 
 #ifdef __KERNEL__
@@ -149,9 +147,6 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 #undef __CS_LOOP
 
 #ifdef __s390x__
-typedef struct {
-	long long counter;
-} __attribute__ ((aligned (8))) atomic64_t;
 #define ATOMIC64_INIT(i)  { (i) }
 
 #if __GNUC__ > 3 || (__GNUC__ == 3 && __GNUC_MINOR__ > 2)
diff --git a/arch/sh/include/asm/atomic.h b/arch/sh/include/asm/atomic.h
index c043ef0..6327ffb 100644
--- a/arch/sh/include/asm/atomic.h
+++ b/arch/sh/include/asm/atomic.h
@@ -7,16 +7,15 @@
  *
  */
 
-typedef struct { volatile int counter; } atomic_t;
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <asm/system.h>
 
 #define ATOMIC_INIT(i)	( (atomic_t) { (i) } )
 
 #define atomic_read(v)		((v)->counter)
 #define atomic_set(v,i)		((v)->counter = (i))
 
-#include <linux/compiler.h>
-#include <asm/system.h>
-
 #if defined(CONFIG_GUSA_RB)
 #include <asm/atomic-grb.h>
 #elif defined(CONFIG_CPU_SH4A)
diff --git a/arch/sparc/include/asm/atomic_32.h b/arch/sparc/include/asm/atomic_32.h
index 5c944b5..ce46597 100644
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -13,8 +13,6 @@
 
 #include <linux/types.h>
 
-typedef struct { volatile int counter; } atomic_t;
-
 #ifdef __KERNEL__
 
 #define ATOMIC_INIT(i)  { (i) }
diff --git a/arch/sparc/include/asm/atomic_64.h b/arch/sparc/include/asm/atomic_64.h
index 2c71ec4..f432a4e 100644
--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -10,9 +10,6 @@
 #include <linux/types.h>
 #include <asm/system.h>
 
-typedef struct { volatile int counter; } atomic_t;
-typedef struct { volatile __s64 counter; } atomic64_t;
-
 #define ATOMIC_INIT(i)		{ (i) }
 #define ATOMIC64_INIT(i)	{ (i) }
 
diff --git a/include/asm-cris/atomic.h b/include/asm-cris/atomic.h
index 5fc8776..3293a6a 100644
--- a/include/asm-cris/atomic.h
+++ b/include/asm-cris/atomic.h
@@ -4,7 +4,7 @@
 #define __ASM_CRIS_ATOMIC__
 
 #include <linux/compiler.h>
-
+#include <linux/types.h>
 #include <asm/system.h>
 #include <asm/arch/atomic.h>
 
@@ -13,8 +13,6 @@
  * resource counting etc..
  */
 
-typedef struct { volatile int counter; } atomic_t;
-
 #define ATOMIC_INIT(i)  { (i) }
 
 #define atomic_read(v) ((v)->counter)
diff --git a/include/asm-frv/atomic.h b/include/asm-frv/atomic.h
index 46d696b..296c35c 100644
--- a/include/asm-frv/atomic.h
+++ b/include/asm-frv/atomic.h
@@ -35,10 +35,6 @@
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-typedef struct {
-	int counter;
-} atomic_t;
-
 #define ATOMIC_INIT(i)		{ (i) }
 #define atomic_read(v)		((v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = (i))
diff --git a/include/asm-m32r/atomic.h b/include/asm-m32r/atomic.h
index 3a38ffe..2eed30f 100644
--- a/include/asm-m32r/atomic.h
+++ b/include/asm-m32r/atomic.h
@@ -9,6 +9,7 @@
  *    Copyright (C) 2004  Hirokazu Takata <takata at linux-m32r.org>
  */
 
+#include <linux/types.h>
 #include <asm/assembler.h>
 #include <asm/system.h>
 
@@ -17,13 +18,6 @@
  * resource counting etc..
  */
 
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct { volatile int counter; } atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
 
 /**
diff --git a/include/asm-m68k/atomic.h b/include/asm-m68k/atomic.h
index 4915294..eb0ab9d 100644
--- a/include/asm-m68k/atomic.h
+++ b/include/asm-m68k/atomic.h
@@ -1,7 +1,7 @@
 #ifndef __ARCH_M68K_ATOMIC__
 #define __ARCH_M68K_ATOMIC__
 
-
+#include <linux/types.h>
 #include <asm/system.h>
 
 /*
@@ -13,7 +13,6 @@
  * We do not have SMP m68k systems, so we don't have to deal with that.
  */
 
-typedef struct { int counter; } atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
 
 #define atomic_read(v)		((v)->counter)
diff --git a/include/asm-mn10300/atomic.h b/include/asm-mn10300/atomic.h
index 27c9690..bc06482 100644
--- a/include/asm-mn10300/atomic.h
+++ b/include/asm-mn10300/atomic.h
@@ -20,15 +20,6 @@
  * resource counting etc..
  */
 
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct {
-	int	counter;
-} atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
 
 #ifdef __KERNEL__
diff --git a/include/asm-parisc/atomic.h b/include/asm-parisc/atomic.h
index 57fcc4a..edbfe25 100644
--- a/include/asm-parisc/atomic.h
+++ b/include/asm-parisc/atomic.h
@@ -155,14 +155,11 @@ static inline unsigned long __cmpxchg_local(volatile void *ptr,
 #define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
 #endif
 
-/* Note that we need not lock read accesses - aligned word writes/reads
- * are atomic, so a reader never sees unconsistent values.
- *
- * Cache-line alignment would conflict with, for example, linux/module.h
+/*
+ * Note that we need not lock read accesses - aligned word writes/reads
+ * are atomic, so a reader never sees inconsistent values.
  */
 
-typedef struct { volatile int counter; } atomic_t;
-
 /* It's possible to reduce all atomic operations to either
  * __atomic_add_return, atomic_set and atomic_read (the latter
  * is there only for consistency).
@@ -260,8 +257,6 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 
 #ifdef CONFIG_64BIT
 
-typedef struct { volatile s64 counter; } atomic64_t;
-
 #define ATOMIC64_INIT(i) ((atomic64_t) { (i) })
 
 static __inline__ int
diff --git a/include/asm-x86/atomic_32.h b/include/asm-x86/atomic_32.h
index 14d3f0b..f3b37f8 100644
--- a/include/asm-x86/atomic_32.h
+++ b/include/asm-x86/atomic_32.h
@@ -2,6 +2,7 @@
 #define ASM_X86__ATOMIC_32_H
 
 #include <linux/compiler.h>
+#include <linux/types.h>
 #include <asm/processor.h>
 #include <asm/cmpxchg.h>
 
@@ -10,15 +11,6 @@
  * resource counting etc..
  */
 
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct {
-	int counter;
-} atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
 
 /**
diff --git a/include/asm-x86/atomic_64.h b/include/asm-x86/atomic_64.h
index 2cb218c..acd07a5 100644
--- a/include/asm-x86/atomic_64.h
+++ b/include/asm-x86/atomic_64.h
@@ -1,25 +1,15 @@
 #ifndef ASM_X86__ATOMIC_64_H
 #define ASM_X86__ATOMIC_64_H
 
+#include <linux/types.h>
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
 
-/* atomic_t should be 32 bit signed type */
-
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
  */
 
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct {
-	int counter;
-} atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
 
 /**
@@ -191,11 +181,7 @@ static inline int atomic_sub_return(int i, atomic_t *v)
 #define atomic_inc_return(v)  (atomic_add_return(1, v))
 #define atomic_dec_return(v)  (atomic_sub_return(1, v))
 
-/* An 64bit atomic type */
-
-typedef struct {
-	long counter;
-} atomic64_t;
+/* The 64-bit atomic type */
 
 #define ATOMIC64_INIT(i)	{ (i) }
 
diff --git a/include/asm-xtensa/atomic.h b/include/asm-xtensa/atomic.h
index b3b2354..67ad67b 100644
--- a/include/asm-xtensa/atomic.h
+++ b/include/asm-xtensa/atomic.h
@@ -14,8 +14,7 @@
 #define _XTENSA_ATOMIC_H
 
 #include <linux/stringify.h>
-
-typedef struct { volatile int counter; } atomic_t;
+#include <linux/types.h>
 
 #ifdef __KERNEL__
 #include <asm/processor.h>
diff --git a/include/linux/types.h b/include/linux/types.h
index f24f7be..400df51 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -199,6 +199,16 @@ typedef u32 phys_addr_t;
 
 typedef phys_addr_t resource_size_t;
 
+typedef struct {
+	volatile int counter;
+} atomic_t;
+
+#ifdef CONFIG_64BIT
+typedef struct {
+	volatile long counter;
+} atomic64_t;
+#endif
+
 struct ustat {
 	__kernel_daddr_t	f_tfree;
 	__kernel_ino_t		f_tinode;

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
