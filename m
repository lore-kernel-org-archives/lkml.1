Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926AbYKRJFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbYKRJFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 04:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYKRJEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 04:04:14 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:50304 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbYKRJDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 04:03:52 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62693726"
From: Bryan Wu <cooloney@kernel.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Graf Yang <graf.yang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/5] Blackfin arch: SMP supporting patchset: Blackfin header files and machine common code
Date: Tue, 18 Nov 2008 17:05:05 +0800
Message-Id: <1226999108-13839-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
References: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Blackfin dual core BF561 processor can support SMP like features.
https://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:smp-like

In this patch, we provide SMP extend to Blackfin header files
and machine common code

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/include/asm/atomic.h         |  124 ++++++--
 arch/blackfin/include/asm/bfin-global.h    |    5 +-
 arch/blackfin/include/asm/bitops.h         |  185 ++++++++----
 arch/blackfin/include/asm/cache.h          |   29 ++
 arch/blackfin/include/asm/cacheflush.h     |   20 +-
 arch/blackfin/include/asm/context.S        |    6 +-
 arch/blackfin/include/asm/cpu.h            |   42 +++
 arch/blackfin/include/asm/l1layout.h       |    3 +-
 arch/blackfin/include/asm/mutex-dec.h      |  112 +++++++
 arch/blackfin/include/asm/mutex.h          |   63 ++++
 arch/blackfin/include/asm/pda.h            |   70 ++++
 arch/blackfin/include/asm/percpu.h         |   12 +-
 arch/blackfin/include/asm/processor.h      |    7 +-
 arch/blackfin/include/asm/rwlock.h         |    6 +
 arch/blackfin/include/asm/smp.h            |   42 +++
 arch/blackfin/include/asm/spinlock.h       |   87 +++++-
 arch/blackfin/include/asm/spinlock_types.h |   22 ++
 arch/blackfin/include/asm/system.h         |  116 ++++++--
 arch/blackfin/mach-common/Makefile         |    1 +
 arch/blackfin/mach-common/cache.S          |   36 ++
 arch/blackfin/mach-common/entry.S          |   92 +++---
 arch/blackfin/mach-common/head.S           |   29 +-
 arch/blackfin/mach-common/ints-priority.c  |   41 +++-
 arch/blackfin/mach-common/smp.c            |  476 ++++++++++++++++++++++++++++
 arch/blackfin/oprofile/common.c            |    2 +-
 25 files changed, 1437 insertions(+), 191 deletions(-)
 create mode 100644 arch/blackfin/include/asm/cpu.h
 create mode 100644 arch/blackfin/include/asm/mutex-dec.h
 create mode 100644 arch/blackfin/include/asm/pda.h
 create mode 100644 arch/blackfin/include/asm/rwlock.h
 create mode 100644 arch/blackfin/include/asm/smp.h
 create mode 100644 arch/blackfin/include/asm/spinlock_types.h
 create mode 100644 arch/blackfin/mach-common/smp.c

diff --git a/arch/blackfin/include/asm/atomic.h b/arch/blackfin/include/asm/atomic.h
index 7cf5087..8af0542 100644
--- a/arch/blackfin/include/asm/atomic.h
+++ b/arch/blackfin/include/asm/atomic.h
@@ -13,15 +13,83 @@
  * Tony Kou (tonyko@lineo.ca)   Lineo Inc.   2001
  */
 
-typedef struct {
-	int counter;
-} atomic_t;
-#define ATOMIC_INIT(i)	{ (i) }
+typedef struct { volatile int counter; } atomic_t;
 
-#define atomic_read(v)		((v)->counter)
+#define ATOMIC_INIT(i)	{ (i) }
 #define atomic_set(v, i)	(((v)->counter) = i)
 
-static __inline__ void atomic_add(int i, atomic_t * v)
+#ifdef CONFIG_SMP
+
+#define atomic_read(v)	__raw_uncached_fetch_asm(&(v)->counter)
+
+asmlinkage int __raw_uncached_fetch_asm(const volatile int *ptr);
+
+asmlinkage int __raw_atomic_update_asm(volatile int *ptr, int value);
+
+asmlinkage int __raw_atomic_clear_asm(volatile int *ptr, int value);
+
+asmlinkage int __raw_atomic_set_asm(volatile int *ptr, int value);
+
+asmlinkage int __raw_atomic_xor_asm(volatile int *ptr, int value);
+
+asmlinkage int __raw_atomic_test_asm(const volatile int *ptr, int value);
+
+static inline void atomic_add(int i, atomic_t *v)
+{
+	__raw_atomic_update_asm(&v->counter, i);
+}
+
+static inline void atomic_sub(int i, atomic_t *v)
+{
+	__raw_atomic_update_asm(&v->counter, -i);
+}
+
+static inline int atomic_add_return(int i, atomic_t *v)
+{
+	return __raw_atomic_update_asm(&v->counter, i);
+}
+
+static inline int atomic_sub_return(int i, atomic_t *v)
+{
+	return __raw_atomic_update_asm(&v->counter, -i);
+}
+
+static inline void atomic_inc(volatile atomic_t *v)
+{
+	__raw_atomic_update_asm(&v->counter, 1);
+}
+
+static inline void atomic_dec(volatile atomic_t *v)
+{
+	__raw_atomic_update_asm(&v->counter, -1);
+}
+
+static inline void atomic_clear_mask(int mask, atomic_t *v)
+{
+	__raw_atomic_clear_asm(&v->counter, mask);
+}
+
+static inline void atomic_set_mask(int mask, atomic_t *v)
+{
+	__raw_atomic_set_asm(&v->counter, mask);
+}
+
+static inline int atomic_test_mask(int mask, atomic_t *v)
+{
+	return __raw_atomic_test_asm(&v->counter, mask);
+}
+
+/* Atomic operations are already serializing */
+#define smp_mb__before_atomic_dec()    barrier()
+#define smp_mb__after_atomic_dec() barrier()
+#define smp_mb__before_atomic_inc()    barrier()
+#define smp_mb__after_atomic_inc() barrier()
+
+#else /* !CONFIG_SMP */
+
+#define atomic_read(v)	((v)->counter)
+
+static inline void atomic_add(int i, atomic_t *v)
 {
 	long flags;
 
@@ -30,7 +98,7 @@ static __inline__ void atomic_add(int i, atomic_t * v)
 	local_irq_restore(flags);
 }
 
-static __inline__ void atomic_sub(int i, atomic_t * v)
+static inline void atomic_sub(int i, atomic_t *v)
 {
 	long flags;
 
@@ -40,7 +108,7 @@ static __inline__ void atomic_sub(int i, atomic_t * v)
 
 }
 
-static inline int atomic_add_return(int i, atomic_t * v)
+static inline int atomic_add_return(int i, atomic_t *v)
 {
 	int __temp = 0;
 	long flags;
@@ -54,8 +122,7 @@ static inline int atomic_add_return(int i, atomic_t * v)
 	return __temp;
 }
 
-#define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
-static inline int atomic_sub_return(int i, atomic_t * v)
+static inline int atomic_sub_return(int i, atomic_t *v)
 {
 	int __temp = 0;
 	long flags;
@@ -68,7 +135,7 @@ static inline int atomic_sub_return(int i, atomic_t * v)
 	return __temp;
 }
 
-static __inline__ void atomic_inc(volatile atomic_t * v)
+static inline void atomic_inc(volatile atomic_t *v)
 {
 	long flags;
 
@@ -77,20 +144,7 @@ static __inline__ void atomic_inc(volatile atomic_t * v)
 	local_irq_restore(flags);
 }
 
-#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
-#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
-
-#define atomic_add_unless(v, a, u)				\
-({								\
-	int c, old;						\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
-
-static __inline__ void atomic_dec(volatile atomic_t * v)
+static inline void atomic_dec(volatile atomic_t *v)
 {
 	long flags;
 
@@ -99,7 +153,7 @@ static __inline__ void atomic_dec(volatile atomic_t * v)
 	local_irq_restore(flags);
 }
 
-static __inline__ void atomic_clear_mask(unsigned int mask, atomic_t * v)
+static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
 	long flags;
 
@@ -108,7 +162,7 @@ static __inline__ void atomic_clear_mask(unsigned int mask, atomic_t * v)
 	local_irq_restore(flags);
 }
 
-static __inline__ void atomic_set_mask(unsigned int mask, atomic_t * v)
+static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
 {
 	long flags;
 
@@ -123,9 +177,25 @@ static __inline__ void atomic_set_mask(unsigned int mask, atomic_t * v)
 #define smp_mb__before_atomic_inc()    barrier()
 #define smp_mb__after_atomic_inc() barrier()
 
+#endif /* !CONFIG_SMP */
+
+#define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
 #define atomic_dec_return(v) atomic_sub_return(1,(v))
 #define atomic_inc_return(v) atomic_add_return(1,(v))
 
+#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
+#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+
+#define atomic_add_unless(v, a, u)				\
+({								\
+	int c, old;						\
+	c = atomic_read(v);					\
+	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
+		c = old;					\
+	c != (u);						\
+})
+#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
+
 /*
  * atomic_inc_and_test - increment and test
  * @v: pointer of type atomic_t
diff --git a/arch/blackfin/include/asm/bfin-global.h b/arch/blackfin/include/asm/bfin-global.h
index 7729566..1dd0805 100644
--- a/arch/blackfin/include/asm/bfin-global.h
+++ b/arch/blackfin/include/asm/bfin-global.h
@@ -47,6 +47,9 @@
 # define DMA_UNCACHED_REGION (0)
 #endif
 
+extern void bfin_setup_caches(unsigned int cpu);
+extern void bfin_setup_cpudata(unsigned int cpu);
+
 extern unsigned long get_cclk(void);
 extern unsigned long get_sclk(void);
 extern unsigned long sclk_to_usecs(unsigned long sclk);
@@ -58,8 +61,6 @@ extern void dump_bfin_trace_buffer(void);
 
 /* init functions only */
 extern int init_arch_irq(void);
-extern void bfin_icache_init(void);
-extern void bfin_dcache_init(void);
 extern void init_exception_vectors(void);
 extern void program_IAR(void);
 
diff --git a/arch/blackfin/include/asm/bitops.h b/arch/blackfin/include/asm/bitops.h
index b39a175..5872fb6 100644
--- a/arch/blackfin/include/asm/bitops.h
+++ b/arch/blackfin/include/asm/bitops.h
@@ -7,7 +7,6 @@
 
 #include <linux/compiler.h>
 #include <asm/byteorder.h>	/* swab32 */
-#include <asm/system.h>		/* save_flags */
 
 #ifdef __KERNEL__
 
@@ -20,36 +19,71 @@
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/ffz.h>
 
-static __inline__ void set_bit(int nr, volatile unsigned long *addr)
+#ifdef CONFIG_SMP
+
+#include <linux/linkage.h>
+
+asmlinkage int __raw_bit_set_asm(volatile unsigned long *addr, int nr);
+
+asmlinkage int __raw_bit_clear_asm(volatile unsigned long *addr, int nr);
+
+asmlinkage int __raw_bit_toggle_asm(volatile unsigned long *addr, int nr);
+
+asmlinkage int __raw_bit_test_set_asm(volatile unsigned long *addr, int nr);
+
+asmlinkage int __raw_bit_test_clear_asm(volatile unsigned long *addr, int nr);
+
+asmlinkage int __raw_bit_test_toggle_asm(volatile unsigned long *addr, int nr);
+
+asmlinkage int __raw_bit_test_asm(const volatile unsigned long *addr, int nr);
+
+static inline void set_bit(int nr, volatile unsigned long *addr)
 {
-	int *a = (int *)addr;
-	int mask;
-	unsigned long flags;
+	volatile unsigned long *a = addr + (nr >> 5);
+	__raw_bit_set_asm(a, nr & 0x1f);
+}
 
-	a += nr >> 5;
-	mask = 1 << (nr & 0x1f);
-	local_irq_save(flags);
-	*a |= mask;
-	local_irq_restore(flags);
+static inline void clear_bit(int nr, volatile unsigned long *addr)
+{
+	volatile unsigned long *a = addr + (nr >> 5);
+	__raw_bit_clear_asm(a, nr & 0x1f);
 }
 
-static __inline__ void __set_bit(int nr, volatile unsigned long *addr)
+static inline void change_bit(int nr, volatile unsigned long *addr)
 {
-	int *a = (int *)addr;
-	int mask;
+	volatile unsigned long *a = addr + (nr >> 5);
+	__raw_bit_toggle_asm(a, nr & 0x1f);
+}
 
-	a += nr >> 5;
-	mask = 1 << (nr & 0x1f);
-	*a |= mask;
+static inline int test_bit(int nr, const volatile unsigned long *addr)
+{
+	volatile const unsigned long *a = addr + (nr >> 5);
+	return __raw_bit_test_asm(a, nr & 0x1f) != 0;
 }
 
-/*
- * clear_bit() doesn't provide any barrier for the compiler.
- */
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
+static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
+{
+	volatile unsigned long *a = addr + (nr >> 5);
+	return __raw_bit_test_set_asm(a, nr & 0x1f);
+}
 
-static __inline__ void clear_bit(int nr, volatile unsigned long *addr)
+static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
+{
+	volatile unsigned long *a = addr + (nr >> 5);
+	return __raw_bit_test_clear_asm(a, nr & 0x1f);
+}
+
+static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
+{
+	volatile unsigned long *a = addr + (nr >> 5);
+	return __raw_bit_test_toggle_asm(a, nr & 0x1f);
+}
+
+#else /* !CONFIG_SMP */
+
+#include <asm/system.h>		/* save_flags */
+
+static inline void set_bit(int nr, volatile unsigned long *addr)
 {
 	int *a = (int *)addr;
 	int mask;
@@ -57,21 +91,23 @@ static __inline__ void clear_bit(int nr, volatile unsigned long *addr)
 	a += nr >> 5;
 	mask = 1 << (nr & 0x1f);
 	local_irq_save(flags);
-	*a &= ~mask;
+	*a |= mask;
 	local_irq_restore(flags);
 }
 
-static __inline__ void __clear_bit(int nr, volatile unsigned long *addr)
+static inline void clear_bit(int nr, volatile unsigned long *addr)
 {
 	int *a = (int *)addr;
 	int mask;
-
+	unsigned long flags;
 	a += nr >> 5;
 	mask = 1 << (nr & 0x1f);
+	local_irq_save(flags);
 	*a &= ~mask;
+	local_irq_restore(flags);
 }
 
-static __inline__ void change_bit(int nr, volatile unsigned long *addr)
+static inline void change_bit(int nr, volatile unsigned long *addr)
 {
 	int mask, flags;
 	unsigned long *ADDR = (unsigned long *)addr;
@@ -83,17 +119,7 @@ static __inline__ void change_bit(int nr, volatile unsigned long *addr)
 	local_irq_restore(flags);
 }
 
-static __inline__ void __change_bit(int nr, volatile unsigned long *addr)
-{
-	int mask;
-	unsigned long *ADDR = (unsigned long *)addr;
-
-	ADDR += nr >> 5;
-	mask = 1 << (nr & 31);
-	*ADDR ^= mask;
-}
-
-static __inline__ int test_and_set_bit(int nr, void *addr)
+static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 {
 	int mask, retval;
 	volatile unsigned int *a = (volatile unsigned int *)addr;
@@ -109,19 +135,23 @@ static __inline__ int test_and_set_bit(int nr, void *addr)
 	return retval;
 }
 
-static __inline__ int __test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
 	int mask, retval;
 	volatile unsigned int *a = (volatile unsigned int *)addr;
+	unsigned long flags;
 
 	a += nr >> 5;
 	mask = 1 << (nr & 0x1f);
+	local_irq_save(flags);
 	retval = (mask & *a) != 0;
-	*a |= mask;
+	*a &= ~mask;
+	local_irq_restore(flags);
+
 	return retval;
 }
 
-static __inline__ int test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 {
 	int mask, retval;
 	volatile unsigned int *a = (volatile unsigned int *)addr;
@@ -131,13 +161,59 @@ static __inline__ int test_and_clear_bit(int nr, volatile unsigned long *addr)
 	mask = 1 << (nr & 0x1f);
 	local_irq_save(flags);
 	retval = (mask & *a) != 0;
-	*a &= ~mask;
+	*a ^= mask;
 	local_irq_restore(flags);
-
 	return retval;
 }
 
-static __inline__ int __test_and_clear_bit(int nr, volatile unsigned long *addr)
+/*
+ * This routine doesn't need to go through raw atomic ops in UP
+ * context.
+ */
+#define test_bit(nr,addr) \
+(__builtin_constant_p(nr) ? \
+ __constant_test_bit((nr), (addr)) : \
+ __test_bit((nr), (addr)))
+
+#endif /* CONFIG_SMP */
+
+/*
+ * clear_bit() doesn't provide any barrier for the compiler.
+ */
+#define smp_mb__before_clear_bit()	barrier()
+#define smp_mb__after_clear_bit()	barrier()
+
+static inline void __set_bit(int nr, volatile unsigned long *addr)
+{
+	int *a = (int *)addr;
+	int mask;
+
+	a += nr >> 5;
+	mask = 1 << (nr & 0x1f);
+	*a |= mask;
+}
+
+static inline void __clear_bit(int nr, volatile unsigned long *addr)
+{
+	int *a = (int *)addr;
+	int mask;
+
+	a += nr >> 5;
+	mask = 1 << (nr & 0x1f);
+	*a &= ~mask;
+}
+
+static inline void __change_bit(int nr, volatile unsigned long *addr)
+{
+	int mask;
+	unsigned long *ADDR = (unsigned long *)addr;
+
+	ADDR += nr >> 5;
+	mask = 1 << (nr & 31);
+	*ADDR ^= mask;
+}
+
+static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
 {
 	int mask, retval;
 	volatile unsigned int *a = (volatile unsigned int *)addr;
@@ -145,26 +221,23 @@ static __inline__ int __test_and_clear_bit(int nr, volatile unsigned long *addr)
 	a += nr >> 5;
 	mask = 1 << (nr & 0x1f);
 	retval = (mask & *a) != 0;
-	*a &= ~mask;
+	*a |= mask;
 	return retval;
 }
 
-static __inline__ int test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
 	int mask, retval;
 	volatile unsigned int *a = (volatile unsigned int *)addr;
-	unsigned long flags;
 
 	a += nr >> 5;
 	mask = 1 << (nr & 0x1f);
-	local_irq_save(flags);
 	retval = (mask & *a) != 0;
-	*a ^= mask;
-	local_irq_restore(flags);
+	*a &= ~mask;
 	return retval;
 }
 
-static __inline__ int __test_and_change_bit(int nr,
+static inline int __test_and_change_bit(int nr,
 					    volatile unsigned long *addr)
 {
 	int mask, retval;
@@ -177,16 +250,13 @@ static __inline__ int __test_and_change_bit(int nr,
 	return retval;
 }
 
-/*
- * This routine doesn't need to be atomic.
- */
-static __inline__ int __constant_test_bit(int nr, const void *addr)
+static inline int __constant_test_bit(int nr, const void *addr)
 {
 	return ((1UL << (nr & 31)) &
 		(((const volatile unsigned int *)addr)[nr >> 5])) != 0;
 }
 
-static __inline__ int __test_bit(int nr, const void *addr)
+static inline int __test_bit(int nr, const void *addr)
 {
 	int *a = (int *)addr;
 	int mask;
@@ -196,11 +266,6 @@ static __inline__ int __test_bit(int nr, const void *addr)
 	return ((mask & *a) != 0);
 }
 
-#define test_bit(nr,addr) \
-(__builtin_constant_p(nr) ? \
- __constant_test_bit((nr),(addr)) : \
- __test_bit((nr),(addr)))
-
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
diff --git a/arch/blackfin/include/asm/cache.h b/arch/blackfin/include/asm/cache.h
index 023d721..8663781 100644
--- a/arch/blackfin/include/asm/cache.h
+++ b/arch/blackfin/include/asm/cache.h
@@ -12,6 +12,11 @@
 #define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
 #define SMP_CACHE_BYTES	L1_CACHE_BYTES
 
+#ifdef CONFIG_SMP
+#define __cacheline_aligned
+#else
+#define ____cacheline_aligned
+
 /*
  * Put cacheline_aliged data to L1 data memory
  */
@@ -21,9 +26,33 @@
 		__section__(".data_l1.cacheline_aligned")))
 #endif
 
+#endif
+
 /*
  * largest L1 which this arch supports
  */
 #define L1_CACHE_SHIFT_MAX	5
 
+#if defined(CONFIG_SMP) && \
+    !defined(CONFIG_BFIN_CACHE_COHERENT) && \
+    defined(CONFIG_BFIN_DCACHE)
+#define __ARCH_SYNC_CORE_DCACHE
+#ifndef __ASSEMBLY__
+asmlinkage void __raw_smp_mark_barrier_asm(void);
+asmlinkage void __raw_smp_check_barrier_asm(void);
+
+static inline void smp_mark_barrier(void)
+{
+	__raw_smp_mark_barrier_asm();
+}
+static inline void smp_check_barrier(void)
+{
+	__raw_smp_check_barrier_asm();
+}
+
+void resync_core_dcache(void);
+#endif
+#endif
+
+
 #endif
diff --git a/arch/blackfin/include/asm/cacheflush.h b/arch/blackfin/include/asm/cacheflush.h
index 4403415..1b040f5 100644
--- a/arch/blackfin/include/asm/cacheflush.h
+++ b/arch/blackfin/include/asm/cacheflush.h
@@ -35,6 +35,7 @@ extern void blackfin_icache_flush_range(unsigned long start_address, unsigned lo
 extern void blackfin_dcache_flush_range(unsigned long start_address, unsigned long end_address);
 extern void blackfin_dcache_invalidate_range(unsigned long start_address, unsigned long end_address);
 extern void blackfin_dflush_page(void *page);
+extern void blackfin_invalidate_entire_dcache(void);
 
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
@@ -44,12 +45,20 @@ extern void blackfin_dflush_page(void *page);
 #define flush_cache_vmap(start, end)		do { } while (0)
 #define flush_cache_vunmap(start, end)		do { } while (0)
 
+#ifdef CONFIG_SMP
+#define flush_icache_range_others(start, end)	\
+	smp_icache_flush_range_others((start), (end))
+#else
+#define flush_icache_range_others(start, end)	do { } while (0)
+#endif
+
 static inline void flush_icache_range(unsigned start, unsigned end)
 {
 #if defined(CONFIG_BFIN_DCACHE) && defined(CONFIG_BFIN_ICACHE)
 
 # if defined(CONFIG_BFIN_WT)
 	blackfin_icache_flush_range((start), (end));
+	flush_icache_range_others(start, end);
 # else
 	blackfin_icache_dcache_flush_range((start), (end));
 # endif
@@ -58,6 +67,7 @@ static inline void flush_icache_range(unsigned start, unsigned end)
 
 # if defined(CONFIG_BFIN_ICACHE)
 	blackfin_icache_flush_range((start), (end));
+	flush_icache_range_others(start, end);
 # endif
 # if defined(CONFIG_BFIN_DCACHE)
 	blackfin_dcache_flush_range((start), (end));
@@ -66,10 +76,12 @@ static inline void flush_icache_range(unsigned start, unsigned end)
 #endif
 }
 
-#define copy_to_user_page(vma, page, vaddr, dst, src, len) \
-do { memcpy(dst, src, len); \
-     flush_icache_range ((unsigned) (dst), (unsigned) (dst) + (len)); \
+#define copy_to_user_page(vma, page, vaddr, dst, src, len)		\
+do { memcpy(dst, src, len);						\
+     flush_icache_range((unsigned) (dst), (unsigned) (dst) + (len));	\
+     flush_icache_range_others((unsigned long) (dst), (unsigned long) (dst) + (len));\
 } while (0)
+
 #define copy_from_user_page(vma, page, vaddr, dst, src, len)	memcpy(dst, src, len)
 
 #if defined(CONFIG_BFIN_DCACHE)
@@ -82,7 +94,7 @@ do { memcpy(dst, src, len); \
 # define flush_dcache_page(page)			blackfin_dflush_page(page_address(page))
 #else
 # define flush_dcache_range(start,end)		do { } while (0)
-# define flush_dcache_page(page)			do { } while (0)
+# define flush_dcache_page(page)		do { } while (0)
 #endif
 
 extern unsigned long reserved_mem_dcache_on;
diff --git a/arch/blackfin/include/asm/context.S b/arch/blackfin/include/asm/context.S
index c0e630e..40d20b4 100644
--- a/arch/blackfin/include/asm/context.S
+++ b/arch/blackfin/include/asm/context.S
@@ -303,9 +303,14 @@
 	RETI = [sp++];
 	RETS = [sp++];
 
+#ifdef CONFIG_SMP
+	GET_PDA(p0, r0);
+	r0 = [p0 + PDA_IRQFLAGS];
+#else
 	p0.h = _irq_flags;
 	p0.l = _irq_flags;
 	r0 = [p0];
+#endif
 	sti r0;
 
 	sp += 4;	/* Skip Reserved */
@@ -352,4 +357,3 @@
 	SYSCFG = [sp++];
 	csync;
 .endm
-
diff --git a/arch/blackfin/include/asm/cpu.h b/arch/blackfin/include/asm/cpu.h
new file mode 100644
index 0000000..9b7aefe
--- /dev/null
+++ b/arch/blackfin/include/asm/cpu.h
@@ -0,0 +1,42 @@
+/*
+ * File:         arch/blackfin/include/asm/cpu.h.
+ * Author:       Philippe Gerum <rpm@xenomai.org>
+ *
+ *               Copyright 2007 Analog Devices Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef __ASM_BLACKFIN_CPU_H
+#define __ASM_BLACKFIN_CPU_H
+
+#include <linux/percpu.h>
+
+struct task_struct;
+
+struct blackfin_cpudata {
+	struct cpu cpu;
+	struct task_struct *idle;
+	unsigned long cclk;
+	unsigned int imemctl;
+	unsigned int dmemctl;
+	unsigned long loops_per_jiffy;
+	unsigned long dcache_invld_count;
+};
+
+DECLARE_PER_CPU(struct blackfin_cpudata, cpu_data);
+
+#endif
diff --git a/arch/blackfin/include/asm/l1layout.h b/arch/blackfin/include/asm/l1layout.h
index c13ded7..06bb37f 100644
--- a/arch/blackfin/include/asm/l1layout.h
+++ b/arch/blackfin/include/asm/l1layout.h
@@ -24,7 +24,8 @@ struct l1_scratch_task_info
 };
 
 /* A pointer to the structure in memory.  */
-#define L1_SCRATCH_TASK_INFO ((struct l1_scratch_task_info *)L1_SCRATCH_START)
+#define L1_SCRATCH_TASK_INFO ((struct l1_scratch_task_info *)\
+						get_l1_scratch_start())
 
 #endif
 
diff --git a/arch/blackfin/include/asm/mutex-dec.h b/arch/blackfin/include/asm/mutex-dec.h
new file mode 100644
index 0000000..0134151
--- /dev/null
+++ b/arch/blackfin/include/asm/mutex-dec.h
@@ -0,0 +1,112 @@
+/*
+ * include/asm-generic/mutex-dec.h
+ *
+ * Generic implementation of the mutex fastpath, based on atomic
+ * decrement/increment.
+ */
+#ifndef _ASM_GENERIC_MUTEX_DEC_H
+#define _ASM_GENERIC_MUTEX_DEC_H
+
+/**
+ *  __mutex_fastpath_lock - try to take the lock by moving the count
+ *                          from 1 to a 0 value
+ *  @count: pointer of type atomic_t
+ *  @fail_fn: function to call if the original value was not 1
+ *
+ * Change the count from 1 to a value lower than 1, and call <fail_fn> if
+ * it wasn't 1 originally. This function MUST leave the value lower than
+ * 1 even when the "1" assertion wasn't true.
+ */
+static inline void
+__mutex_fastpath_lock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
+{
+	if (unlikely(atomic_dec_return(count) < 0))
+		fail_fn(count);
+	else
+		smp_mb();
+}
+
+/**
+ *  __mutex_fastpath_lock_retval - try to take the lock by moving the count
+ *                                 from 1 to a 0 value
+ *  @count: pointer of type atomic_t
+ *  @fail_fn: function to call if the original value was not 1
+ *
+ * Change the count from 1 to a value lower than 1, and call <fail_fn> if
+ * it wasn't 1 originally. This function returns 0 if the fastpath succeeds,
+ * or anything the slow path function returns.
+ */
+static inline int
+__mutex_fastpath_lock_retval(atomic_t *count, fastcall int (*fail_fn)(atomic_t *))
+{
+	if (unlikely(atomic_dec_return(count) < 0))
+		return fail_fn(count);
+	else {
+		smp_mb();
+		return 0;
+	}
+}
+
+/**
+ *  __mutex_fastpath_unlock - try to promote the count from 0 to 1
+ *  @count: pointer of type atomic_t
+ *  @fail_fn: function to call if the original value was not 0
+ *
+ * Try to promote the count from 0 to 1. If it wasn't 0, call <fail_fn>.
+ * In the failure case, this function is allowed to either set the value to
+ * 1, or to set it to a value lower than 1.
+ *
+ * If the implementation sets it to a value of lower than 1, then the
+ * __mutex_slowpath_needs_to_unlock() macro needs to return 1, it needs
+ * to return 0 otherwise.
+ */
+static inline void
+__mutex_fastpath_unlock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
+{
+	smp_mb();
+	if (unlikely(atomic_inc_return(count) <= 0))
+		fail_fn(count);
+}
+
+#define __mutex_slowpath_needs_to_unlock()		1
+
+/**
+ * __mutex_fastpath_trylock - try to acquire the mutex, without waiting
+ *
+ *  @count: pointer of type atomic_t
+ *  @fail_fn: fallback function
+ *
+ * Change the count from 1 to a value lower than 1, and return 0 (failure)
+ * if it wasn't 1 originally, or return 1 (success) otherwise. This function
+ * MUST leave the value lower than 1 even when the "1" assertion wasn't true.
+ * Additionally, if the value was < 0 originally, this function must not leave
+ * it to 0 on failure.
+ *
+ * If the architecture has no effective trylock variant, it should call the
+ * <fail_fn> spinlock-based trylock variant unconditionally.
+ */
+static inline int
+__mutex_fastpath_trylock(atomic_t *count, int (*fail_fn)(atomic_t *))
+{
+	/*
+	 * We have two variants here. The cmpxchg based one is the best one
+	 * because it never induce a false contention state.  It is included
+	 * here because architectures using the inc/dec algorithms over the
+	 * xchg ones are much more likely to support cmpxchg natively.
+	 *
+	 * If not we fall back to the spinlock based variant - that is
+	 * just as efficient (and simpler) as a 'destructive' probing of
+	 * the mutex state would be.
+	 */
+#ifdef __HAVE_ARCH_CMPXCHG
+	if (likely(atomic_cmpxchg(count, 1, 0) == 1)) {
+		smp_mb();
+		return 1;
+	}
+	return 0;
+#else
+	return fail_fn(count);
+#endif
+}
+
+#endif
diff --git a/arch/blackfin/include/asm/mutex.h b/arch/blackfin/include/asm/mutex.h
index 458c1f7..5d39925 100644
--- a/arch/blackfin/include/asm/mutex.h
+++ b/arch/blackfin/include/asm/mutex.h
@@ -6,4 +6,67 @@
  * implementation. (see asm-generic/mutex-xchg.h for details)
  */
 
+#ifndef _ASM_MUTEX_H
+#define _ASM_MUTEX_H
+
+#ifndef CONFIG_SMP
 #include <asm-generic/mutex-dec.h>
+#else
+
+static inline void
+__mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
+{
+	if (unlikely(atomic_dec_return(count) < 0))
+		fail_fn(count);
+	else
+		smp_mb();
+}
+
+static inline int
+__mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
+{
+	if (unlikely(atomic_dec_return(count) < 0))
+		return fail_fn(count);
+	else {
+		smp_mb();
+		return 0;
+	}
+}
+
+static inline void
+__mutex_fastpath_unlock(atomic_t *count, void (*fail_fn)(atomic_t *))
+{
+	smp_mb();
+	if (unlikely(atomic_inc_return(count) <= 0))
+		fail_fn(count);
+}
+
+#define __mutex_slowpath_needs_to_unlock()		1
+
+static inline int
+__mutex_fastpath_trylock(atomic_t *count, int (*fail_fn)(atomic_t *))
+{
+	/*
+	 * We have two variants here. The cmpxchg based one is the best one
+	 * because it never induce a false contention state.  It is included
+	 * here because architectures using the inc/dec algorithms over the
+	 * xchg ones are much more likely to support cmpxchg natively.
+	 *
+	 * If not we fall back to the spinlock based variant - that is
+	 * just as efficient (and simpler) as a 'destructive' probing of
+	 * the mutex state would be.
+	 */
+#ifdef __HAVE_ARCH_CMPXCHG
+	if (likely(atomic_cmpxchg(count, 1, 0) == 1)) {
+		smp_mb();
+		return 1;
+	}
+	return 0;
+#else
+	return fail_fn(count);
+#endif
+}
+
+#endif
+
+#endif
diff --git a/arch/blackfin/include/asm/pda.h b/arch/blackfin/include/asm/pda.h
new file mode 100644
index 0000000..a24d130
--- /dev/null
+++ b/arch/blackfin/include/asm/pda.h
@@ -0,0 +1,70 @@
+/*
+ * File:         arch/blackfin/include/asm/pda.h
+ * Author:       Philippe Gerum <rpm@xenomai.org>
+ *
+ *               Copyright 2007 Analog Devices Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef _ASM_BLACKFIN_PDA_H
+#define _ASM_BLACKFIN_PDA_H
+
+#include <asm/mem_map.h>
+
+#ifndef __ASSEMBLY__
+
+struct blackfin_pda {			/* Per-processor Data Area */
+	struct blackfin_pda *next;
+
+	unsigned long syscfg;
+#ifdef CONFIG_SMP
+	unsigned long imask;		/* Current IMASK value */
+#endif
+
+	unsigned long *ipdt;		/* Start of switchable I-CPLB table */
+	unsigned long *ipdt_swapcount;	/* Number of swaps in ipdt */
+	unsigned long *dpdt;		/* Start of switchable D-CPLB table */
+	unsigned long *dpdt_swapcount;	/* Number of swaps in dpdt */
+
+	/*
+	 * Single instructions can have multiple faults, which
+	 * need to be handled by traps.c, in irq5. We store
+	 * the exception cause to ensure we don't miss a
+	 * double fault condition
+	 */
+	unsigned long ex_iptr;
+	unsigned long ex_optr;
+	unsigned long ex_buf[4];
+	unsigned long ex_imask;		/* Saved imask from exception */
+	unsigned long *ex_stack;	/* Exception stack space */
+
+#ifdef ANOMALY_05000261
+	unsigned long last_cplb_fault_retx;
+#endif
+	unsigned long dcplb_fault_addr;
+	unsigned long icplb_fault_addr;
+	unsigned long retx;
+	unsigned long seqstat;
+};
+
+extern struct blackfin_pda cpu_pda[];
+
+void reserve_pda(void);
+
+#endif	/* __ASSEMBLY__ */
+
+#endif /* _ASM_BLACKFIN_PDA_H */
diff --git a/arch/blackfin/include/asm/percpu.h b/arch/blackfin/include/asm/percpu.h
index 78dd61f..797c0c1 100644
--- a/arch/blackfin/include/asm/percpu.h
+++ b/arch/blackfin/include/asm/percpu.h
@@ -3,4 +3,14 @@
 
 #include <asm-generic/percpu.h>
 
-#endif				/* __ARCH_BLACKFIN_PERCPU__ */
+#ifdef CONFIG_MODULES
+#define PERCPU_MODULE_RESERVE 8192
+#else
+#define PERCPU_MODULE_RESERVE 0
+#endif
+
+#define PERCPU_ENOUGH_ROOM \
+	(ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES) + \
+	 PERCPU_MODULE_RESERVE)
+
+#endif	/* __ARCH_BLACKFIN_PERCPU__ */
diff --git a/arch/blackfin/include/asm/processor.h b/arch/blackfin/include/asm/processor.h
index e3e9b41..30703c7 100644
--- a/arch/blackfin/include/asm/processor.h
+++ b/arch/blackfin/include/asm/processor.h
@@ -106,7 +106,8 @@ unsigned long get_wchan(struct task_struct *p);
 	eip; })
 #define	KSTK_ESP(tsk)	((tsk) == current ? rdusp() : (tsk)->thread.usp)
 
-#define cpu_relax()    	barrier()
+#define cpu_relax()    	smp_mb()
+
 
 /* Get the Silicon Revision of the chip */
 static inline uint32_t __pure bfin_revid(void)
@@ -137,7 +138,11 @@ static inline uint32_t __pure bfin_revid(void)
 static inline uint16_t __pure bfin_cpuid(void)
 {
 	return (bfin_read_CHIPID() & CHIPID_FAMILY) >> 12;
+}
 
+static inline uint32_t __pure bfin_dspid(void)
+{
+	return bfin_read_DSPID();
 }
 
 static inline uint32_t __pure bfin_compiled_revid(void)
diff --git a/arch/blackfin/include/asm/rwlock.h b/arch/blackfin/include/asm/rwlock.h
new file mode 100644
index 0000000..4a724b3
--- /dev/null
+++ b/arch/blackfin/include/asm/rwlock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_BLACKFIN_RWLOCK_H
+#define _ASM_BLACKFIN_RWLOCK_H
+
+#define RW_LOCK_BIAS	0x01000000
+
+#endif
diff --git a/arch/blackfin/include/asm/smp.h b/arch/blackfin/include/asm/smp.h
new file mode 100644
index 0000000..233cb8c
--- /dev/null
+++ b/arch/blackfin/include/asm/smp.h
@@ -0,0 +1,42 @@
+/*
+ * File:         arch/blackfin/include/asm/smp.h
+ * Author:       Philippe Gerum <rpm@xenomai.org>
+ *
+ *               Copyright 2007 Analog Devices Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef __ASM_BLACKFIN_SMP_H
+#define __ASM_BLACKFIN_SMP_H
+
+#include <linux/kernel.h>
+#include <linux/threads.h>
+#include <linux/cpumask.h>
+#include <linux/cache.h>
+#include <asm/blackfin.h>
+#include <mach/smp.h>
+
+#define raw_smp_processor_id()  blackfin_core_id()
+
+struct corelock_slot {
+	int lock;
+};
+
+void smp_icache_flush_range_others(unsigned long start,
+				   unsigned long end);
+
+#endif /* !__ASM_BLACKFIN_SMP_H */
diff --git a/arch/blackfin/include/asm/spinlock.h b/arch/blackfin/include/asm/spinlock.h
index 64e908a..0249ac3 100644
--- a/arch/blackfin/include/asm/spinlock.h
+++ b/arch/blackfin/include/asm/spinlock.h
@@ -1,6 +1,89 @@
 #ifndef __BFIN_SPINLOCK_H
 #define __BFIN_SPINLOCK_H
 
-#error blackfin architecture does not support SMP spin lock yet
+#include <asm/atomic.h>
 
-#endif
+asmlinkage int __raw_spin_is_locked_asm(volatile int *ptr);
+asmlinkage void __raw_spin_lock_asm(volatile int *ptr);
+asmlinkage int __raw_spin_trylock_asm(volatile int *ptr);
+asmlinkage void __raw_spin_unlock_asm(volatile int *ptr);
+asmlinkage void __raw_read_lock_asm(volatile int *ptr);
+asmlinkage int __raw_read_trylock_asm(volatile int *ptr);
+asmlinkage void __raw_read_unlock_asm(volatile int *ptr);
+asmlinkage void __raw_write_lock_asm(volatile int *ptr);
+asmlinkage int __raw_write_trylock_asm(volatile int *ptr);
+asmlinkage void __raw_write_unlock_asm(volatile int *ptr);
+
+static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
+{
+	return __raw_spin_is_locked_asm(&lock->lock);
+}
+
+static inline void __raw_spin_lock(raw_spinlock_t *lock)
+{
+	__raw_spin_lock_asm(&lock->lock);
+}
+
+#define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
+
+static inline int __raw_spin_trylock(raw_spinlock_t *lock)
+{
+	return __raw_spin_trylock_asm(&lock->lock);
+}
+
+static inline void __raw_spin_unlock(raw_spinlock_t *lock)
+{
+	__raw_spin_unlock_asm(&lock->lock);
+}
+
+static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)
+{
+	while (__raw_spin_is_locked(lock))
+		cpu_relax();
+}
+
+static inline int __raw_read_can_lock(raw_rwlock_t *rw)
+{
+	return __raw_uncached_fetch_asm(&rw->lock) > 0;
+}
+
+static inline int __raw_write_can_lock(raw_rwlock_t *rw)
+{
+	return __raw_uncached_fetch_asm(&rw->lock) == RW_LOCK_BIAS;
+}
+
+static inline void __raw_read_lock(raw_rwlock_t *rw)
+{
+	__raw_read_lock_asm(&rw->lock);
+}
+
+static inline int __raw_read_trylock(raw_rwlock_t *rw)
+{
+	return __raw_read_trylock_asm(&rw->lock);
+}
+
+static inline void __raw_read_unlock(raw_rwlock_t *rw)
+{
+	__raw_read_unlock_asm(&rw->lock);
+}
+
+static inline void __raw_write_lock(raw_rwlock_t *rw)
+{
+	__raw_write_lock_asm(&rw->lock);
+}
+
+static inline int __raw_write_trylock(raw_rwlock_t *rw)
+{
+	return __raw_write_trylock_asm(&rw->lock);
+}
+
+static inline void __raw_write_unlock(raw_rwlock_t *rw)
+{
+	__raw_write_unlock_asm(&rw->lock);
+}
+
+#define _raw_spin_relax(lock)  	cpu_relax()
+#define _raw_read_relax(lock)	cpu_relax()
+#define _raw_write_relax(lock)	cpu_relax()
+
+#endif /*  !__BFIN_SPINLOCK_H */
diff --git a/arch/blackfin/include/asm/spinlock_types.h b/arch/blackfin/include/asm/spinlock_types.h
new file mode 100644
index 0000000..b1e3c4c
--- /dev/null
+++ b/arch/blackfin/include/asm/spinlock_types.h
@@ -0,0 +1,22 @@
+#ifndef __ASM_SPINLOCK_TYPES_H
+#define __ASM_SPINLOCK_TYPES_H
+
+#ifndef __LINUX_SPINLOCK_TYPES_H
+# error "please don't include this file directly"
+#endif
+
+#include <asm/rwlock.h>
+
+typedef struct {
+	volatile unsigned int lock;
+} raw_spinlock_t;
+
+#define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
+
+typedef struct {
+	volatile unsigned int lock;
+} raw_rwlock_t;
+
+#define __RAW_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
+
+#endif
diff --git a/arch/blackfin/include/asm/system.h b/arch/blackfin/include/asm/system.h
index 8f1627d..6b368fa 100644
--- a/arch/blackfin/include/asm/system.h
+++ b/arch/blackfin/include/asm/system.h
@@ -37,20 +37,16 @@
 #include <linux/linkage.h>
 #include <linux/compiler.h>
 #include <mach/anomaly.h>
+#include <asm/pda.h>
+#include <asm/processor.h>
+
+/* Forward decl needed due to cdef inter dependencies */
+static inline uint32_t __pure bfin_dspid(void);
+#define blackfin_core_id() (bfin_dspid() & 0xff)
 
 /*
  * Interrupt configuring macros.
  */
-
-extern unsigned long irq_flags;
-
-#define local_irq_enable() \
-	__asm__ __volatile__( \
-		"sti %0;" \
-		: \
-		: "d" (irq_flags) \
-	)
-
 #define local_irq_disable() \
 	do { \
 		int __tmp_dummy; \
@@ -66,6 +62,18 @@ extern unsigned long irq_flags;
 # define NOP_PAD_ANOMALY_05000244
 #endif
 
+#ifdef CONFIG_SMP
+# define irq_flags cpu_pda[blackfin_core_id()].imask
+#else
+extern unsigned long irq_flags;
+#endif
+
+#define local_irq_enable() \
+	__asm__ __volatile__( \
+		"sti %0;" \
+		: \
+		: "d" (irq_flags) \
+	)
 #define idle_with_irq_disabled() \
 	__asm__ __volatile__( \
 		NOP_PAD_ANOMALY_05000244 \
@@ -129,22 +137,85 @@ extern unsigned long irq_flags;
 #define rmb()  asm volatile (""   : : :"memory")
 #define wmb()  asm volatile (""   : : :"memory")
 #define set_mb(var, value) do { (void) xchg(&var, value); } while (0)
-
 #define read_barrier_depends() 		do { } while(0)
 
 #ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#define smp_read_barrier_depends()	read_barrier_depends()
+asmlinkage unsigned long __raw_xchg_1_asm(volatile void *ptr, unsigned long value);
+asmlinkage unsigned long __raw_xchg_2_asm(volatile void *ptr, unsigned long value);
+asmlinkage unsigned long __raw_xchg_4_asm(volatile void *ptr, unsigned long value);
+asmlinkage unsigned long __raw_cmpxchg_1_asm(volatile void *ptr,
+					unsigned long new, unsigned long old);
+asmlinkage unsigned long __raw_cmpxchg_2_asm(volatile void *ptr,
+					unsigned long new, unsigned long old);
+asmlinkage unsigned long __raw_cmpxchg_4_asm(volatile void *ptr,
+					unsigned long new, unsigned long old);
+
+#ifdef __ARCH_SYNC_CORE_DCACHE
+# define smp_mb()	do { barrier(); smp_check_barrier(); smp_mark_barrier(); } while (0)
+# define smp_rmb()	do { barrier(); smp_check_barrier(); } while (0)
+# define smp_wmb()	do { barrier(); smp_mark_barrier(); } while (0)
 #else
+# define smp_mb()	barrier()
+# define smp_rmb()	barrier()
+# define smp_wmb()	barrier()
+#endif
+
+static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
+				   int size)
+{
+	unsigned long tmp;
+
+	switch (size) {
+	case 1:
+		tmp = __raw_xchg_1_asm(ptr, x);
+		break;
+	case 2:
+		tmp = __raw_xchg_2_asm(ptr, x);
+		break;
+	case 4:
+		tmp = __raw_xchg_4_asm(ptr, x);
+		break;
+	}
+
+	return tmp;
+}
+
+/*
+ * Atomic compare and exchange.  Compare OLD with MEM, if identical,
+ * store NEW in MEM.  Return the initial value in MEM.  Success is
+ * indicated by comparing RETURN with OLD.
+ */
+static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
+				      unsigned long new, int size)
+{
+	unsigned long tmp;
+
+	switch (size) {
+	case 1:
+		tmp = __raw_cmpxchg_1_asm(ptr, new, old);
+		break;
+	case 2:
+		tmp = __raw_cmpxchg_2_asm(ptr, new, old);
+		break;
+	case 4:
+		tmp = __raw_cmpxchg_4_asm(ptr, new, old);
+		break;
+	}
+
+	return tmp;
+}
+#define cmpxchg(ptr, o, n) \
+	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o), \
+		(unsigned long)(n), sizeof(*(ptr))))
+
+#define smp_read_barrier_depends()	smp_check_barrier()
+
+#else /* !CONFIG_SMP */
+
 #define smp_mb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 #define smp_read_barrier_depends()	do { } while(0)
-#endif
-
-#define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
 
 struct __xchg_dummy {
 	unsigned long a[100];
@@ -194,9 +265,12 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
 			(unsigned long)(n), sizeof(*(ptr))))
 #define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
 
-#ifndef CONFIG_SMP
 #include <asm-generic/cmpxchg.h>
-#endif
+
+#endif /* !CONFIG_SMP */
+
+#define xchg(ptr, x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
+#define tas(ptr) ((void)xchg((ptr), 1))
 
 #define prepare_to_switch()     do { } while(0)
 
@@ -218,4 +292,4 @@ do {    \
 	(last) = resume (prev, next);   \
 } while (0)
 
-#endif				/* _BLACKFIN_SYSTEM_H */
+#endif	/* _BLACKFIN_SYSTEM_H */
diff --git a/arch/blackfin/mach-common/Makefile b/arch/blackfin/mach-common/Makefile
index e6ed57c..9388b4a 100644
--- a/arch/blackfin/mach-common/Makefile
+++ b/arch/blackfin/mach-common/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_BFIN_ICACHE_LOCK) += lock.o
 obj-$(CONFIG_PM)          += pm.o dpmc_modes.o
 obj-$(CONFIG_CPU_FREQ)    += cpufreq.o
 obj-$(CONFIG_CPU_VOLTAGE) += dpmc.o
+obj-$(CONFIG_SMP)         += smp.o
diff --git a/arch/blackfin/mach-common/cache.S b/arch/blackfin/mach-common/cache.S
index 3c98dac..1187512 100644
--- a/arch/blackfin/mach-common/cache.S
+++ b/arch/blackfin/mach-common/cache.S
@@ -97,3 +97,39 @@ ENTRY(_blackfin_dflush_page)
 	P1 = 1 << (PAGE_SHIFT - L1_CACHE_SHIFT);
 	jump .Ldfr;
 ENDPROC(_blackfin_dflush_page)
+
+/* Invalidate the Entire Data cache by
+ * clearing DMC[1:0] bits
+ */
+ENTRY(_blackfin_invalidate_entire_dcache)
+	[--SP] = ( R7:5);
+
+	P0.L = LO(DMEM_CONTROL);
+	P0.H = HI(DMEM_CONTROL);
+	R7 = [P0];
+	R5 = R7;	/* Save DMEM_CNTR */
+
+	/* Clear the DMC[1:0] bits, All valid bits in the data
+	 * cache are set to the invalid state
+	 */
+	BITCLR(R7,DMC0_P);
+	BITCLR(R7,DMC1_P);
+	CLI R6;
+	SSYNC;		/* SSYNC required before writing to DMEM_CONTROL. */
+	.align 8;
+	[P0] = R7;
+	SSYNC;
+	STI R6;
+
+	/* Configures the data cache again */
+
+	CLI R6;
+	SSYNC;		/* SSYNC required before writing to DMEM_CONTROL. */
+	.align 8;
+	[P0] = R5;
+	SSYNC;
+	STI R6;
+
+	( R7:5) = [SP++];
+	RTS;
+ENDPROC(_blackfin_invalidate_entire_dcache)
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index c6ae844..5531f49 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -36,6 +36,7 @@
 #include <linux/init.h>
 #include <linux/linkage.h>
 #include <linux/unistd.h>
+#include <linux/threads.h>
 #include <asm/blackfin.h>
 #include <asm/errno.h>
 #include <asm/fixed_code.h>
@@ -75,11 +76,11 @@ ENTRY(_ex_workaround_261)
 	 * handle it.
 	 */
 	P4 = R7;	/* Store EXCAUSE */
-	p5.l = _last_cplb_fault_retx;
-	p5.h = _last_cplb_fault_retx;
-	r7 = [p5];
+
+	GET_PDA(p5, r7);
+	r7 = [p5 + PDA_LFRETX];
 	r6 = retx;
-	[p5] = r6;
+	[p5 + PDA_LFRETX] = r6;
 	cc = r6 == r7;
 	if !cc jump _bfin_return_from_exception;
 	/* fall through */
@@ -324,7 +325,9 @@ ENTRY(_ex_trap_c)
 	[p4] = p5;
 	csync;
 
+	GET_PDA(p5, r6);
 #ifndef CONFIG_DEBUG_DOUBLEFAULT
+
 	/*
 	 * Save these registers, as they are only valid in exception context
 	 *  (where we are now - as soon as we defer to IRQ5, they can change)
@@ -335,29 +338,25 @@ ENTRY(_ex_trap_c)
 	p4.l = lo(DCPLB_FAULT_ADDR);
 	p4.h = hi(DCPLB_FAULT_ADDR);
 	r7 = [p4];
-	p5.h = _saved_dcplb_fault_addr;
-	p5.l = _saved_dcplb_fault_addr;
-	[p5] = r7;
+	[p5 + PDA_DCPLB] = r7;
 
-	r7 = [p4 + (ICPLB_FAULT_ADDR - DCPLB_FAULT_ADDR)];
-	p5.h = _saved_icplb_fault_addr;
-	p5.l = _saved_icplb_fault_addr;
-	[p5] = r7;
+	p4.l = lo(ICPLB_FAULT_ADDR);
+	p4.h = hi(ICPLB_FAULT_ADDR);
+	r6 = [p4];
+	[p5 + PDA_ICPLB] = r6;
 
 	r6 = retx;
-	p4.l = _saved_retx;
-	p4.h = _saved_retx;
-	[p4] = r6;
+	[p5 + PDA_RETX] = r6;
 #endif
 	r6 = SYSCFG;
-	[p4 + 4] = r6;
+	[p5 + PDA_SYSCFG] = r6;
 	BITCLR(r6, 0);
 	SYSCFG = r6;
 
 	/* Disable all interrupts, but make sure level 5 is enabled so
 	 * we can switch to that level.  Save the old mask.  */
 	cli r6;
-	[p4 + 8] = r6;
+	[p5 + PDA_EXIMASK] = r6;
 
 	p4.l = lo(SAFE_USER_INSTRUCTION);
 	p4.h = hi(SAFE_USER_INSTRUCTION);
@@ -424,17 +423,16 @@ ENDPROC(_double_fault)
 ENTRY(_exception_to_level5)
 	SAVE_ALL_SYS
 
-	p4.l = _saved_retx;
-	p4.h = _saved_retx;
-	r6 = [p4];
+	GET_PDA(p4, r7);        /* Fetch current PDA */
+	r6 = [p4 + PDA_RETX];
 	[sp + PT_PC] = r6;
 
-	r6 = [p4 + 4];
+	r6 = [p4 + PDA_SYSCFG];
 	[sp + PT_SYSCFG] = r6;
 
 	/* Restore interrupt mask.  We haven't pushed RETI, so this
 	 * doesn't enable interrupts until we return from this handler.  */
-	r6 = [p4 + 8];
+	r6 = [p4 + PDA_EXIMASK];
 	sti r6;
 
 	/* Restore the hardware error vector.  */
@@ -478,8 +476,8 @@ ENTRY(_trap) /* Exception: 4th entry into system event table(supervisor mode)*/
 	 * scratch register (for want of a better option).
 	 */
 	EX_SCRATCH_REG = sp;
-	sp.l = _exception_stack_top;
-	sp.h = _exception_stack_top;
+	GET_PDA_SAFE(sp);
+	sp = [sp + PDA_EXSTACK]
 	/* Try to deal with syscalls quickly.  */
 	[--sp] = ASTAT;
 	[--sp] = (R7:6,P5:4);
@@ -501,27 +499,22 @@ ENTRY(_trap) /* Exception: 4th entry into system event table(supervisor mode)*/
 	 * but they are not very interesting, so don't save them
 	 */
 
+	GET_PDA(p5, r7);
 	p4.l = lo(DCPLB_FAULT_ADDR);
 	p4.h = hi(DCPLB_FAULT_ADDR);
 	r7 = [p4];
-	p5.h = _saved_dcplb_fault_addr;
-	p5.l = _saved_dcplb_fault_addr;
-	[p5] = r7;
+	[p5 + PDA_DCPLB] = r7;
 
-	r7 = [p4 + (ICPLB_FAULT_ADDR - DCPLB_FAULT_ADDR)];
-	p5.h = _saved_icplb_fault_addr;
-	p5.l = _saved_icplb_fault_addr;
-	[p5] = r7;
+	p4.l = lo(ICPLB_FAULT_ADDR);
+	p4.h = hi(ICPLB_FAULT_ADDR);
+	r7 = [p4];
+	[p5 + PDA_ICPLB] = r7;
 
-	p4.l = _saved_retx;
-	p4.h = _saved_retx;
 	r6 = retx;
-	[p4] = r6;
+	[p5 + PDA_RETX] = r6;
 
 	r7 = SEQSTAT;		/* reason code is in bit 5:0 */
-	p4.l = _saved_seqstat;
-	p4.h = _saved_seqstat;
-	[p4] = r7;
+	[p5 + PDA_SEQSTAT] = r7;
 #else
 	r7 = SEQSTAT;           /* reason code is in bit 5:0 */
 #endif
@@ -546,11 +539,11 @@ ENTRY(_kernel_execve)
 	p0 = sp;
 	r3 = SIZEOF_PTREGS / 4;
 	r4 = 0(x);
-0:
+.Lclear_regs:
 	[p0++] = r4;
 	r3 += -1;
 	cc = r3 == 0;
-	if !cc jump 0b (bp);
+	if !cc jump .Lclear_regs (bp);
 
 	p0 = sp;
 	sp += -16;
@@ -558,7 +551,7 @@ ENTRY(_kernel_execve)
 	call _do_execve;
 	SP += 16;
 	cc = r0 == 0;
-	if ! cc jump 1f;
+	if ! cc jump .Lexecve_failed;
 	/* Success.  Copy our temporary pt_regs to the top of the kernel
 	 * stack and do a normal exception return.
 	 */
@@ -574,12 +567,12 @@ ENTRY(_kernel_execve)
 	p0 = fp;
 	r4 = [p0--];
 	r3 = SIZEOF_PTREGS / 4;
-0:
+.Lcopy_regs:
 	r4 = [p0--];
 	[p1--] = r4;
 	r3 += -1;
 	cc = r3 == 0;
-	if ! cc jump 0b (bp);
+	if ! cc jump .Lcopy_regs (bp);
 
 	r0 = (KERNEL_STACK_SIZE - SIZEOF_PTREGS) (z);
 	p1 = r0;
@@ -591,7 +584,7 @@ ENTRY(_kernel_execve)
 
 	RESTORE_CONTEXT;
 	rti;
-1:
+.Lexecve_failed:
 	unlink;
 	rts;
 ENDPROC(_kernel_execve)
@@ -925,9 +918,14 @@ _schedule_and_signal_from_int:
 	p1 = rets;
 	[sp + PT_RESERVED] = p1;
 
+#ifdef CONFIG_SMP
+	GET_PDA(p0, r0); 	/* Fetch current PDA (can't migrate to other CPU here) */
+	r0 = [p0 + PDA_IRQFLAGS];
+#else
 	p0.l = _irq_flags;
 	p0.h = _irq_flags;
 	r0 = [p0];
+#endif
 	sti r0;
 
 	r0 = sp;
@@ -1539,12 +1537,6 @@ ENTRY(_sys_call_table)
 	.endr
 END(_sys_call_table)
 
-#if ANOMALY_05000261
-/* Used by the assembly entry point to work around an anomaly.  */
-_last_cplb_fault_retx:
-	.long 0;
-#endif
-
 #ifdef CONFIG_EXCEPTION_L1_SCRATCH
 /* .section .l1.bss.scratch */
 .set _exception_stack_top, L1_SCRATCH_START + L1_SCRATCH_LENGTH
@@ -1554,8 +1546,8 @@ _last_cplb_fault_retx:
 #else
 .bss
 #endif
-_exception_stack:
-	.rept 1024
+ENTRY(_exception_stack)
+	.rept 1024 * NR_CPUS
 	.long 0
 	.endr
 _exception_stack_top:
diff --git a/arch/blackfin/mach-common/head.S b/arch/blackfin/mach-common/head.S
index c1dcaeb..a621ae4 100644
--- a/arch/blackfin/mach-common/head.S
+++ b/arch/blackfin/mach-common/head.S
@@ -13,6 +13,7 @@
 #include <asm/blackfin.h>
 #include <asm/thread_info.h>
 #include <asm/trace.h>
+#include <asm/asm-offsets.h>
 
 __INIT
 
@@ -111,33 +112,26 @@ ENTRY(__start)
 	 * This happens here, since L1 gets clobbered
 	 * below
 	 */
-	p0.l = _saved_retx;
-	p0.h = _saved_retx;
+	GET_PDA(p0, r0);
+	r7 = [p0 + PDA_RETX];
 	p1.l = _init_saved_retx;
 	p1.h = _init_saved_retx;
-	r0 = [p0];
-	[p1] = r0;
+	[p1] = r7;
 
-	p0.l = _saved_dcplb_fault_addr;
-	p0.h = _saved_dcplb_fault_addr;
+	r7 = [p0 + PDA_DCPLB];
 	p1.l = _init_saved_dcplb_fault_addr;
 	p1.h = _init_saved_dcplb_fault_addr;
-	r0 = [p0];
-	[p1] = r0;
+	[p1] = r7;
 
-	p0.l = _saved_icplb_fault_addr;
-	p0.h = _saved_icplb_fault_addr;
+	r7 = [p0 + PDA_ICPLB];
 	p1.l = _init_saved_icplb_fault_addr;
 	p1.h = _init_saved_icplb_fault_addr;
-	r0 = [p0];
-	[p1] = r0;
+	[p1] = r7;
 
-	p0.l = _saved_seqstat;
-	p0.h = _saved_seqstat;
+	r7 = [p0 + PDA_SEQSTAT];
 	p1.l = _init_saved_seqstat;
 	p1.h = _init_saved_seqstat;
-	r0 = [p0];
-	[p1] = r0;
+	[p1] = r7;
 #endif
 
 	/* Initialize stack pointer */
@@ -255,6 +249,9 @@ ENTRY(_real_start)
 	sp = sp + p1;
 	usp = sp;
 	fp = sp;
+	sp += -12;
+	call _init_pda
+	sp += 12;
 	jump.l _start_kernel;
 ENDPROC(_real_start)
 
diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
index d45d0c5..eb8dfcf 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -55,6 +55,7 @@
  * -
  */
 
+#ifndef CONFIG_SMP
 /* Initialize this to an actual value to force it into the .data
  * section so that we know it is properly initialized at entry into
  * the kernel but before bss is initialized to zero (which is where
@@ -63,6 +64,7 @@
  */
 unsigned long irq_flags = 0x1f;
 EXPORT_SYMBOL(irq_flags);
+#endif
 
 /* The number of spurious interrupts */
 atomic_t num_spurious;
@@ -163,6 +165,10 @@ static void bfin_internal_mask_irq(unsigned int irq)
 	mask_bit = SIC_SYSIRQ(irq) % 32;
 	bfin_write_SIC_IMASK(mask_bank, bfin_read_SIC_IMASK(mask_bank) &
 			     ~(1 << mask_bit));
+#ifdef CONFIG_SMP
+	bfin_write_SICB_IMASK(mask_bank, bfin_read_SICB_IMASK(mask_bank) &
+			     ~(1 << mask_bit));
+#endif
 #endif
 }
 
@@ -177,6 +183,10 @@ static void bfin_internal_unmask_irq(unsigned int irq)
 	mask_bit = SIC_SYSIRQ(irq) % 32;
 	bfin_write_SIC_IMASK(mask_bank, bfin_read_SIC_IMASK(mask_bank) |
 			     (1 << mask_bit));
+#ifdef CONFIG_SMP
+	bfin_write_SICB_IMASK(mask_bank, bfin_read_SICB_IMASK(mask_bank) |
+			     (1 << mask_bit));
+#endif
 #endif
 }
 
@@ -896,7 +906,7 @@ static struct irq_chip bfin_gpio_irqchip = {
 #endif
 };
 
-void __init init_exception_vectors(void)
+void __cpuinit init_exception_vectors(void)
 {
 	/* cannot program in software:
 	 * evt0 - emulation (jtag)
@@ -935,6 +945,10 @@ int __init init_arch_irq(void)
 # ifdef CONFIG_BF54x
 	bfin_write_SIC_IMASK2(SIC_UNMASK_ALL);
 # endif
+# ifdef CONFIG_SMP
+	bfin_write_SICB_IMASK0(SIC_UNMASK_ALL);
+	bfin_write_SICB_IMASK1(SIC_UNMASK_ALL);
+# endif
 #else
 	bfin_write_SIC_IMASK(SIC_UNMASK_ALL);
 #endif
@@ -995,6 +1009,17 @@ int __init init_arch_irq(void)
 
 			break;
 #endif
+#ifdef CONFIG_TICK_SOURCE_SYSTMR0
+		case IRQ_TIMER0:
+			set_irq_handler(irq, handle_percpu_irq);
+			break;
+#endif
+#ifdef CONFIG_SMP
+		case IRQ_SUPPLE_0:
+		case IRQ_SUPPLE_1:
+			set_irq_handler(irq, handle_percpu_irq);
+			break;
+#endif
 		default:
 			set_irq_handler(irq, handle_simple_irq);
 			break;
@@ -1029,7 +1054,7 @@ int __init init_arch_irq(void)
 	search_IAR();
 
 	/* Enable interrupts IVG7-15 */
-	irq_flags = irq_flags | IMASK_IVG15 |
+	irq_flags |= IMASK_IVG15 |
 	    IMASK_IVG14 | IMASK_IVG13 | IMASK_IVG12 | IMASK_IVG11 |
 	    IMASK_IVG10 | IMASK_IVG9 | IMASK_IVG8 | IMASK_IVG7 | IMASK_IVGHW;
 
@@ -1070,8 +1095,16 @@ void do_irq(int vec, struct pt_regs *fp)
 	|| defined(BF538_FAMILY) || defined(CONFIG_BF51x)
 		unsigned long sic_status[3];
 
-		sic_status[0] = bfin_read_SIC_ISR0() & bfin_read_SIC_IMASK0();
-		sic_status[1] = bfin_read_SIC_ISR1() & bfin_read_SIC_IMASK1();
+		if (smp_processor_id()) {
+#ifdef CONFIG_SMP
+			/* This will be optimized out in UP mode. */
+			sic_status[0] = bfin_read_SICB_ISR0() & bfin_read_SICB_IMASK0();
+			sic_status[1] = bfin_read_SICB_ISR1() & bfin_read_SICB_IMASK1();
+#endif
+		} else {
+			sic_status[0] = bfin_read_SIC_ISR0() & bfin_read_SIC_IMASK0();
+			sic_status[1] = bfin_read_SIC_ISR1() & bfin_read_SIC_IMASK1();
+		}
 #ifdef CONFIG_BF54x
 		sic_status[2] = bfin_read_SIC_ISR2() & bfin_read_SIC_IMASK2();
 #endif
diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
new file mode 100644
index 0000000..7aeeced
--- /dev/null
+++ b/arch/blackfin/mach-common/smp.c
@@ -0,0 +1,476 @@
+/*
+ * File:         arch/blackfin/kernel/smp.c
+ * Author:       Philippe Gerum <rpm@xenomai.org>
+ * IPI management based on arch/arm/kernel/smp.c.
+ *
+ *               Copyright 2007 Analog Devices Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/cache.h>
+#include <linux/profile.h>
+#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/cpu.h>
+#include <linux/smp.h>
+#include <linux/seq_file.h>
+#include <linux/irq.h>
+#include <asm/atomic.h>
+#include <asm/cacheflush.h>
+#include <asm/mmu_context.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+#include <asm/processor.h>
+#include <asm/ptrace.h>
+#include <asm/cpu.h>
+#include <linux/err.h>
+
+struct corelock_slot corelock __attribute__ ((__section__(".l2.bss")));
+
+void __cpuinitdata *init_retx_coreb, *init_saved_retx_coreb,
+	*init_saved_seqstat_coreb, *init_saved_icplb_fault_addr_coreb,
+	*init_saved_dcplb_fault_addr_coreb;
+
+cpumask_t cpu_possible_map;
+EXPORT_SYMBOL(cpu_possible_map);
+
+cpumask_t cpu_online_map;
+EXPORT_SYMBOL(cpu_online_map);
+
+#define BFIN_IPI_RESCHEDULE   0
+#define BFIN_IPI_CALL_FUNC    1
+#define BFIN_IPI_CPU_STOP     2
+
+struct blackfin_flush_data {
+	unsigned long start;
+	unsigned long end;
+};
+
+void *secondary_stack;
+
+
+struct smp_call_struct {
+	void (*func)(void *info);
+	void *info;
+	int wait;
+	cpumask_t pending;
+	cpumask_t waitmask;
+};
+
+static struct blackfin_flush_data smp_flush_data;
+
+static DEFINE_SPINLOCK(stop_lock);
+
+struct ipi_message {
+	struct list_head list;
+	unsigned long type;
+	struct smp_call_struct call_struct;
+};
+
+struct ipi_message_queue {
+	struct list_head head;
+	spinlock_t lock;
+	unsigned long count;
+};
+
+static DEFINE_PER_CPU(struct ipi_message_queue, ipi_msg_queue);
+
+static void ipi_cpu_stop(unsigned int cpu)
+{
+	spin_lock(&stop_lock);
+	printk(KERN_CRIT "CPU%u: stopping\n", cpu);
+	dump_stack();
+	spin_unlock(&stop_lock);
+
+	cpu_clear(cpu, cpu_online_map);
+
+	local_irq_disable();
+
+	while (1)
+		SSYNC();
+}
+
+static void ipi_flush_icache(void *info)
+{
+	struct blackfin_flush_data *fdata = info;
+
+	/* Invalidate the memory holding the bounds of the flushed region. */
+	blackfin_dcache_invalidate_range((unsigned long)fdata,
+					 (unsigned long)fdata + sizeof(*fdata));
+
+	blackfin_icache_flush_range(fdata->start, fdata->end);
+}
+
+static void ipi_call_function(unsigned int cpu, struct ipi_message *msg)
+{
+	int wait;
+	void (*func)(void *info);
+	void *info;
+	func = msg->call_struct.func;
+	info = msg->call_struct.info;
+	wait = msg->call_struct.wait;
+	cpu_clear(cpu, msg->call_struct.pending);
+	func(info);
+	if (wait)
+		cpu_clear(cpu, msg->call_struct.waitmask);
+	else
+		kfree(msg);
+}
+
+static irqreturn_t ipi_handler(int irq, void *dev_instance)
+{
+	struct ipi_message *msg, *mg;
+	struct ipi_message_queue *msg_queue;
+	unsigned int cpu = smp_processor_id();
+
+	platform_clear_ipi(cpu);
+
+	msg_queue = &__get_cpu_var(ipi_msg_queue);
+	msg_queue->count++;
+
+	spin_lock(&msg_queue->lock);
+	list_for_each_entry_safe(msg, mg, &msg_queue->head, list) {
+		list_del(&msg->list);
+		switch (msg->type) {
+		case BFIN_IPI_RESCHEDULE:
+			/* That's the easiest one; leave it to
+			 * return_from_int. */
+			kfree(msg);
+			break;
+		case BFIN_IPI_CALL_FUNC:
+			ipi_call_function(cpu, msg);
+			break;
+		case BFIN_IPI_CPU_STOP:
+			ipi_cpu_stop(cpu);
+			kfree(msg);
+			break;
+		default:
+			printk(KERN_CRIT "CPU%u: Unknown IPI message \
+			0x%lx\n", cpu, msg->type);
+			kfree(msg);
+			break;
+		}
+	}
+	spin_unlock(&msg_queue->lock);
+	return IRQ_HANDLED;
+}
+
+static void ipi_queue_init(void)
+{
+	unsigned int cpu;
+	struct ipi_message_queue *msg_queue;
+	for_each_possible_cpu(cpu) {
+		msg_queue = &per_cpu(ipi_msg_queue, cpu);
+		INIT_LIST_HEAD(&msg_queue->head);
+		spin_lock_init(&msg_queue->lock);
+		msg_queue->count = 0;
+	}
+}
+
+int smp_call_function(void (*func)(void *info), void *info, int wait)
+{
+	unsigned int cpu;
+	cpumask_t callmap;
+	unsigned long flags;
+	struct ipi_message_queue *msg_queue;
+	struct ipi_message *msg;
+
+	callmap = cpu_online_map;
+	cpu_clear(smp_processor_id(), callmap);
+	if (cpus_empty(callmap))
+		return 0;
+
+	msg = kmalloc(sizeof(*msg), GFP_ATOMIC);
+	INIT_LIST_HEAD(&msg->list);
+	msg->call_struct.func = func;
+	msg->call_struct.info = info;
+	msg->call_struct.wait = wait;
+	msg->call_struct.pending = callmap;
+	msg->call_struct.waitmask = callmap;
+	msg->type = BFIN_IPI_CALL_FUNC;
+
+	for_each_cpu_mask(cpu, callmap) {
+		msg_queue = &per_cpu(ipi_msg_queue, cpu);
+		spin_lock_irqsave(&msg_queue->lock, flags);
+		list_add(&msg->list, &msg_queue->head);
+		spin_unlock_irqrestore(&msg_queue->lock, flags);
+		platform_send_ipi_cpu(cpu);
+	}
+	if (wait) {
+		while (!cpus_empty(msg->call_struct.waitmask))
+			blackfin_dcache_invalidate_range(
+				(unsigned long)(&msg->call_struct.waitmask),
+				(unsigned long)(&msg->call_struct.waitmask));
+		kfree(msg);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(smp_call_function);
+
+int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
+				int wait)
+{
+	unsigned int cpu = cpuid;
+	cpumask_t callmap;
+	unsigned long flags;
+	struct ipi_message_queue *msg_queue;
+	struct ipi_message *msg;
+
+	if (cpu_is_offline(cpu))
+		return 0;
+	cpus_clear(callmap);
+	cpu_set(cpu, callmap);
+
+	msg = kmalloc(sizeof(*msg), GFP_ATOMIC);
+	INIT_LIST_HEAD(&msg->list);
+	msg->call_struct.func = func;
+	msg->call_struct.info = info;
+	msg->call_struct.wait = wait;
+	msg->call_struct.pending = callmap;
+	msg->call_struct.waitmask = callmap;
+	msg->type = BFIN_IPI_CALL_FUNC;
+
+	msg_queue = &per_cpu(ipi_msg_queue, cpu);
+	spin_lock_irqsave(&msg_queue->lock, flags);
+	list_add(&msg->list, &msg_queue->head);
+	spin_unlock_irqrestore(&msg_queue->lock, flags);
+	platform_send_ipi_cpu(cpu);
+
+	if (wait) {
+		while (!cpus_empty(msg->call_struct.waitmask))
+			blackfin_dcache_invalidate_range(
+				(unsigned long)(&msg->call_struct.waitmask),
+				(unsigned long)(&msg->call_struct.waitmask));
+		kfree(msg);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(smp_call_function_single);
+
+void smp_send_reschedule(int cpu)
+{
+	unsigned long flags;
+	struct ipi_message_queue *msg_queue;
+	struct ipi_message *msg;
+
+	if (cpu_is_offline(cpu))
+		return;
+
+	msg = kmalloc(sizeof(*msg), GFP_ATOMIC);
+	memset(msg, 0, sizeof(msg));
+	INIT_LIST_HEAD(&msg->list);
+	msg->type = BFIN_IPI_RESCHEDULE;
+
+	msg_queue = &per_cpu(ipi_msg_queue, cpu);
+	spin_lock_irqsave(&msg_queue->lock, flags);
+	list_add(&msg->list, &msg_queue->head);
+	spin_unlock_irqrestore(&msg_queue->lock, flags);
+	platform_send_ipi_cpu(cpu);
+
+	return;
+}
+
+void smp_send_stop(void)
+{
+	unsigned int cpu;
+	cpumask_t callmap;
+	unsigned long flags;
+	struct ipi_message_queue *msg_queue;
+	struct ipi_message *msg;
+
+	callmap = cpu_online_map;
+	cpu_clear(smp_processor_id(), callmap);
+	if (cpus_empty(callmap))
+		return;
+
+	msg = kmalloc(sizeof(*msg), GFP_ATOMIC);
+	memset(msg, 0, sizeof(msg));
+	INIT_LIST_HEAD(&msg->list);
+	msg->type = BFIN_IPI_CPU_STOP;
+
+	for_each_cpu_mask(cpu, callmap) {
+		msg_queue = &per_cpu(ipi_msg_queue, cpu);
+		spin_lock_irqsave(&msg_queue->lock, flags);
+		list_add(&msg->list, &msg_queue->head);
+		spin_unlock_irqrestore(&msg_queue->lock, flags);
+		platform_send_ipi_cpu(cpu);
+	}
+	return;
+}
+
+int __cpuinit __cpu_up(unsigned int cpu)
+{
+	struct task_struct *idle;
+	int ret;
+
+	idle = fork_idle(cpu);
+	if (IS_ERR(idle)) {
+		printk(KERN_ERR "CPU%u: fork() failed\n", cpu);
+		return PTR_ERR(idle);
+	}
+
+	secondary_stack = task_stack_page(idle) + THREAD_SIZE;
+	smp_wmb();
+
+	ret = platform_boot_secondary(cpu, idle);
+
+	if (ret) {
+		cpu_clear(cpu, cpu_present_map);
+		printk(KERN_CRIT "CPU%u: processor failed to boot (%d)\n", cpu, ret);
+		free_task(idle);
+	} else
+		cpu_set(cpu, cpu_online_map);
+
+	secondary_stack = NULL;
+
+	return ret;
+}
+
+static void __cpuinit setup_secondary(unsigned int cpu)
+{
+#ifndef CONFIG_TICK_SOURCE_SYSTMR0
+	struct irq_desc *timer_desc;
+#endif
+	unsigned long ilat;
+
+	bfin_write_IMASK(0);
+	CSYNC();
+	ilat = bfin_read_ILAT();
+	CSYNC();
+	bfin_write_ILAT(ilat);
+	CSYNC();
+
+	/* Reserve the PDA space for the secondary CPU. */
+	reserve_pda();
+
+	/* Enable interrupt levels IVG7-15. IARs have been already
+	 * programmed by the boot CPU.  */
+	irq_flags |= IMASK_IVG15 |
+	    IMASK_IVG14 | IMASK_IVG13 | IMASK_IVG12 | IMASK_IVG11 |
+	    IMASK_IVG10 | IMASK_IVG9 | IMASK_IVG8 | IMASK_IVG7 | IMASK_IVGHW;
+
+#ifdef CONFIG_TICK_SOURCE_SYSTMR0
+	/* Power down the core timer, just to play safe. */
+	bfin_write_TCNTL(0);
+
+	/* system timer0 has been setup by CoreA. */
+#else
+	timer_desc = irq_desc + IRQ_CORETMR;
+	setup_core_timer();
+	timer_desc->chip->enable(IRQ_CORETMR);
+#endif
+}
+
+void __cpuinit secondary_start_kernel(void)
+{
+	unsigned int cpu = smp_processor_id();
+	struct mm_struct *mm = &init_mm;
+
+	if (_bfin_swrst & SWRST_DBL_FAULT_B) {
+		printk(KERN_EMERG "CoreB Recovering from DOUBLE FAULT event\n");
+#ifdef CONFIG_DEBUG_DOUBLEFAULT
+		printk(KERN_EMERG " While handling exception (EXCAUSE = 0x%x) at %pF\n",
+			(int)init_saved_seqstat_coreb & SEQSTAT_EXCAUSE, init_saved_retx_coreb);
+		printk(KERN_NOTICE "   DCPLB_FAULT_ADDR: %pF\n", init_saved_dcplb_fault_addr_coreb);
+		printk(KERN_NOTICE "   ICPLB_FAULT_ADDR: %pF\n", init_saved_icplb_fault_addr_coreb);
+#endif
+		printk(KERN_NOTICE " The instruction at %pF caused a double exception\n",
+			init_retx_coreb);
+	}
+
+	/*
+	 * We want the D-cache to be enabled early, in case the atomic
+	 * support code emulates cache coherence (see
+	 * __ARCH_SYNC_CORE_DCACHE).
+	 */
+	init_exception_vectors();
+
+	bfin_setup_caches(cpu);
+
+	local_irq_disable();
+
+	/* Attach the new idle task to the global mm. */
+	atomic_inc(&mm->mm_users);
+	atomic_inc(&mm->mm_count);
+	current->active_mm = mm;
+	BUG_ON(current->mm);	/* Can't be, but better be safe than sorry. */
+
+	preempt_disable();
+
+	setup_secondary(cpu);
+
+	local_irq_enable();
+
+	platform_secondary_init(cpu);
+
+	cpu_idle();
+}
+
+void __init smp_prepare_boot_cpu(void)
+{
+}
+
+void __init smp_prepare_cpus(unsigned int max_cpus)
+{
+	platform_prepare_cpus(max_cpus);
+	ipi_queue_init();
+	platform_request_ipi(&ipi_handler);
+}
+
+void __init smp_cpus_done(unsigned int max_cpus)
+{
+	unsigned long bogosum = 0;
+	unsigned int cpu;
+
+	for_each_online_cpu(cpu)
+		bogosum += per_cpu(cpu_data, cpu).loops_per_jiffy;
+
+	printk(KERN_INFO "SMP: Total of %d processors activated "
+	       "(%lu.%02lu BogoMIPS).\n",
+	       num_online_cpus(),
+	       bogosum / (500000/HZ),
+	       (bogosum / (5000/HZ)) % 100);
+}
+
+void smp_icache_flush_range_others(unsigned long start, unsigned long end)
+{
+	smp_flush_data.start = start;
+	smp_flush_data.end = end;
+
+	if (smp_call_function(&ipi_flush_icache, &smp_flush_data, 1))
+		printk(KERN_WARNING "SMP: failed to run I-cache flush request on other CPUs\n");
+}
+EXPORT_SYMBOL_GPL(smp_icache_flush_range_others);
+
+#ifdef __ARCH_SYNC_CORE_DCACHE
+unsigned long barrier_mask __attribute__ ((__section__(".l2.bss")));
+
+void resync_core_dcache(void)
+{
+	unsigned int cpu = get_cpu();
+	blackfin_invalidate_entire_dcache();
+	++per_cpu(cpu_data, cpu).dcache_invld_count;
+	put_cpu();
+}
+EXPORT_SYMBOL(resync_core_dcache);
+#endif
diff --git a/arch/blackfin/oprofile/common.c b/arch/blackfin/oprofile/common.c
index 0f6d303..f34795a 100644
--- a/arch/blackfin/oprofile/common.c
+++ b/arch/blackfin/oprofile/common.c
@@ -130,7 +130,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 
 	mutex_init(&pfmon_lock);
 
-	dspid = bfin_read_DSPID();
+	dspid = bfin_dspid();
 
 	printk(KERN_INFO "Oprofile got the cpu id is 0x%x. \n", dspid);
 
-- 
1.5.6.3
