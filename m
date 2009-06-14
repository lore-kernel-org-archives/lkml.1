Return-Path: <linux-kernel-owner+w=401wt.eu-S1761168AbZFNMEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761168AbZFNMEh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbZFNMBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:01:40 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52687 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758593AbZFNMBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:01:38 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 12/17] Blackfin: convert locking primitives to asm-generic
Date: Sun, 14 Jun 2009 08:01:13 -0400
Message-Id: <1244980878-2124-13-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/atomic.h    |  109 +-----------------
 arch/blackfin/include/asm/bitops.h    |  198 ++-------------------------------
 arch/blackfin/include/asm/mutex.h     |    2 +-
 arch/blackfin/include/asm/spinlock.h  |    6 +
 arch/blackfin/include/asm/swab.h      |    6 +-
 arch/blackfin/include/asm/unaligned.h |   12 +--
 6 files changed, 25 insertions(+), 308 deletions(-)

diff --git a/arch/blackfin/include/asm/atomic.h b/arch/blackfin/include/asm/atomic.h
index b1d92f1..88f36d5 100644
--- a/arch/blackfin/include/asm/atomic.h
+++ b/arch/blackfin/include/asm/atomic.h
@@ -1,24 +1,21 @@
 #ifndef __ARCH_BLACKFIN_ATOMIC__
 #define __ARCH_BLACKFIN_ATOMIC__
 
+#ifndef CONFIG_SMP
+# include <asm-generic/atomic.h>
+#else
+
 #include <linux/types.h>
 #include <asm/system.h>	/* local_irq_XXX() */
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
- *
- * Generally we do not concern about SMP BFIN systems, so we don't have
- * to deal with that.
- *
- * Tony Kou (tonyko@lineo.ca)   Lineo Inc.   2001
  */
 
 #define ATOMIC_INIT(i)	{ (i) }
 #define atomic_set(v, i)	(((v)->counter) = i)
 
-#ifdef CONFIG_SMP
-
 #define atomic_read(v)	__raw_uncached_fetch_asm(&(v)->counter)
 
 asmlinkage int __raw_uncached_fetch_asm(const volatile int *ptr);
@@ -84,100 +81,6 @@ static inline int atomic_test_mask(int mask, atomic_t *v)
 #define smp_mb__before_atomic_inc()    barrier()
 #define smp_mb__after_atomic_inc() barrier()
 
-#else /* !CONFIG_SMP */
-
-#define atomic_read(v)	((v)->counter)
-
-static inline void atomic_add(int i, atomic_t *v)
-{
-	unsigned long flags;
-
-	local_irq_save_hw(flags);
-	v->counter += i;
-	local_irq_restore_hw(flags);
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned long flags;
-
-	local_irq_save_hw(flags);
-	v->counter -= i;
-	local_irq_restore_hw(flags);
-
-}
-
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int __temp = 0;
-	unsigned long flags;
-
-	local_irq_save_hw(flags);
-	v->counter += i;
-	__temp = v->counter;
-	local_irq_restore_hw(flags);
-
-
-	return __temp;
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	int __temp = 0;
-	unsigned long flags;
-
-	local_irq_save_hw(flags);
-	v->counter -= i;
-	__temp = v->counter;
-	local_irq_restore_hw(flags);
-
-	return __temp;
-}
-
-static inline void atomic_inc(volatile atomic_t *v)
-{
-	unsigned long flags;
-
-	local_irq_save_hw(flags);
-	v->counter++;
-	local_irq_restore_hw(flags);
-}
-
-static inline void atomic_dec(volatile atomic_t *v)
-{
-	unsigned long flags;
-
-	local_irq_save_hw(flags);
-	v->counter--;
-	local_irq_restore_hw(flags);
-}
-
-static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
-{
-	unsigned long flags;
-
-	local_irq_save_hw(flags);
-	v->counter &= ~mask;
-	local_irq_restore_hw(flags);
-}
-
-static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
-{
-	unsigned long flags;
-
-	local_irq_save_hw(flags);
-	v->counter |= mask;
-	local_irq_restore_hw(flags);
-}
-
-/* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()    barrier()
-#define smp_mb__after_atomic_dec() barrier()
-#define smp_mb__before_atomic_inc()    barrier()
-#define smp_mb__after_atomic_inc() barrier()
-
-#endif /* !CONFIG_SMP */
-
 #define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
 #define atomic_dec_return(v) atomic_sub_return(1,(v))
 #define atomic_inc_return(v) atomic_add_return(1,(v))
@@ -210,4 +113,6 @@ static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
 
 #include <asm-generic/atomic-long.h>
 
-#endif				/* __ARCH_BLACKFIN_ATOMIC __ */
+#endif
+
+#endif
diff --git a/arch/blackfin/include/asm/bitops.h b/arch/blackfin/include/asm/bitops.h
index 75fee2f..daffa71 100644
--- a/arch/blackfin/include/asm/bitops.h
+++ b/arch/blackfin/include/asm/bitops.h
@@ -1,26 +1,22 @@
 #ifndef _BLACKFIN_BITOPS_H
 #define _BLACKFIN_BITOPS_H
 
-/*
- * Copyright 1992, Linus Torvalds.
- */
-
-#include <linux/compiler.h>
-#include <asm/byteorder.h>	/* swab32 */
-
-#ifdef __KERNEL__
+#ifndef CONFIG_SMP
+# include <asm-generic/bitops.h>
+#else
 
 #ifndef _LINUX_BITOPS_H
 #error only <linux/bitops.h> can be included directly
 #endif
 
+#include <linux/compiler.h>
+#include <asm/byteorder.h>	/* swab32 */
+
 #include <asm-generic/bitops/ffs.h>
 #include <asm-generic/bitops/__ffs.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/ffz.h>
 
-#ifdef CONFIG_SMP
-
 #include <linux/linkage.h>
 
 asmlinkage int __raw_bit_set_asm(volatile unsigned long *addr, int nr);
@@ -79,189 +75,13 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 	return __raw_bit_test_toggle_asm(a, nr & 0x1f);
 }
 
-#else /* !CONFIG_SMP */
-
-#include <asm/system.h>		/* save_flags */
-
-static inline void set_bit(int nr, volatile unsigned long *addr)
-{
-	int *a = (int *)addr;
-	int mask;
-	unsigned long flags;
-	a += nr >> 5;
-	mask = 1 << (nr & 0x1f);
-	local_irq_save_hw(flags);
-	*a |= mask;
-	local_irq_restore_hw(flags);
-}
-
-static inline void clear_bit(int nr, volatile unsigned long *addr)
-{
-	int *a = (int *)addr;
-	int mask;
-	unsigned long flags;
-	a += nr >> 5;
-	mask = 1 << (nr & 0x1f);
-	local_irq_save_hw(flags);
-	*a &= ~mask;
-	local_irq_restore_hw(flags);
-}
-
-static inline void change_bit(int nr, volatile unsigned long *addr)
-{
-	int mask;
-	unsigned long flags;
-	unsigned long *ADDR = (unsigned long *)addr;
-
-	ADDR += nr >> 5;
-	mask = 1 << (nr & 31);
-	local_irq_save_hw(flags);
-	*ADDR ^= mask;
-	local_irq_restore_hw(flags);
-}
-
-static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
-{
-	int mask, retval;
-	volatile unsigned int *a = (volatile unsigned int *)addr;
-	unsigned long flags;
-
-	a += nr >> 5;
-	mask = 1 << (nr & 0x1f);
-	local_irq_save_hw(flags);
-	retval = (mask & *a) != 0;
-	*a |= mask;
-	local_irq_restore_hw(flags);
-
-	return retval;
-}
-
-static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
-{
-	int mask, retval;
-	volatile unsigned int *a = (volatile unsigned int *)addr;
-	unsigned long flags;
-
-	a += nr >> 5;
-	mask = 1 << (nr & 0x1f);
-	local_irq_save_hw(flags);
-	retval = (mask & *a) != 0;
-	*a &= ~mask;
-	local_irq_restore_hw(flags);
-
-	return retval;
-}
-
-static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
-{
-	int mask, retval;
-	volatile unsigned int *a = (volatile unsigned int *)addr;
-	unsigned long flags;
-
-	a += nr >> 5;
-	mask = 1 << (nr & 0x1f);
-	local_irq_save_hw(flags);
-	retval = (mask & *a) != 0;
-	*a ^= mask;
-	local_irq_restore_hw(flags);
-	return retval;
-}
-
-#endif /* CONFIG_SMP */
-
 /*
  * clear_bit() doesn't provide any barrier for the compiler.
  */
 #define smp_mb__before_clear_bit()	barrier()
 #define smp_mb__after_clear_bit()	barrier()
 
-static inline void __set_bit(int nr, volatile unsigned long *addr)
-{
-	int *a = (int *)addr;
-	int mask;
-
-	a += nr >> 5;
-	mask = 1 << (nr & 0x1f);
-	*a |= mask;
-}
-
-static inline void __clear_bit(int nr, volatile unsigned long *addr)
-{
-	int *a = (int *)addr;
-	int mask;
-
-	a += nr >> 5;
-	mask = 1 << (nr & 0x1f);
-	*a &= ~mask;
-}
-
-static inline void __change_bit(int nr, volatile unsigned long *addr)
-{
-	int mask;
-	unsigned long *ADDR = (unsigned long *)addr;
-
-	ADDR += nr >> 5;
-	mask = 1 << (nr & 31);
-	*ADDR ^= mask;
-}
-
-static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
-{
-	int mask, retval;
-	volatile unsigned int *a = (volatile unsigned int *)addr;
-
-	a += nr >> 5;
-	mask = 1 << (nr & 0x1f);
-	retval = (mask & *a) != 0;
-	*a |= mask;
-	return retval;
-}
-
-static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
-{
-	int mask, retval;
-	volatile unsigned int *a = (volatile unsigned int *)addr;
-
-	a += nr >> 5;
-	mask = 1 << (nr & 0x1f);
-	retval = (mask & *a) != 0;
-	*a &= ~mask;
-	return retval;
-}
-
-static inline int __test_and_change_bit(int nr,
-					    volatile unsigned long *addr)
-{
-	int mask, retval;
-	volatile unsigned int *a = (volatile unsigned int *)addr;
-
-	a += nr >> 5;
-	mask = 1 << (nr & 0x1f);
-	retval = (mask & *a) != 0;
-	*a ^= mask;
-	return retval;
-}
-
-static inline int __test_bit(int nr, const void *addr)
-{
-	int *a = (int *)addr;
-	int mask;
-
-	a += nr >> 5;
-	mask = 1 << (nr & 0x1f);
-	return ((mask & *a) != 0);
-}
-
-#ifndef CONFIG_SMP
-/*
- * This routine doesn't need irq save and restore ops in UP
- * context.
- */
-static inline int test_bit(int nr, const void *addr)
-{
-	return __test_bit(nr, addr);
-}
-#endif
+#include <asm-generic/bitops/non-atomic.h>
 
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/hweight.h>
@@ -272,10 +92,10 @@ static inline int test_bit(int nr, const void *addr)
 
 #include <asm-generic/bitops/minix.h>
 
-#endif				/* __KERNEL__ */
-
 #include <asm-generic/bitops/fls.h>
 #include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
+#endif /* CONFIG_SMP */
+
 #endif				/* _BLACKFIN_BITOPS_H */
diff --git a/arch/blackfin/include/asm/mutex.h b/arch/blackfin/include/asm/mutex.h
index 5d39925..5cc641c 100644
--- a/arch/blackfin/include/asm/mutex.h
+++ b/arch/blackfin/include/asm/mutex.h
@@ -10,7 +10,7 @@
 #define _ASM_MUTEX_H
 
 #ifndef CONFIG_SMP
-#include <asm-generic/mutex-dec.h>
+#include <asm-generic/mutex.h>
 #else
 
 static inline void
diff --git a/arch/blackfin/include/asm/spinlock.h b/arch/blackfin/include/asm/spinlock.h
index 0249ac3..d6ff4b5 100644
--- a/arch/blackfin/include/asm/spinlock.h
+++ b/arch/blackfin/include/asm/spinlock.h
@@ -1,6 +1,10 @@
 #ifndef __BFIN_SPINLOCK_H
 #define __BFIN_SPINLOCK_H
 
+#ifndef CONFIG_SMP
+# include <asm-generic/spinlock.h>
+#else
+
 #include <asm/atomic.h>
 
 asmlinkage int __raw_spin_is_locked_asm(volatile int *ptr);
@@ -86,4 +90,6 @@ static inline void __raw_write_unlock(raw_rwlock_t *rw)
 #define _raw_read_relax(lock)	cpu_relax()
 #define _raw_write_relax(lock)	cpu_relax()
 
+#endif
+
 #endif /*  !__BFIN_SPINLOCK_H */
diff --git a/arch/blackfin/include/asm/swab.h b/arch/blackfin/include/asm/swab.h
index 6403ad2..d442113 100644
--- a/arch/blackfin/include/asm/swab.h
+++ b/arch/blackfin/include/asm/swab.h
@@ -2,11 +2,7 @@
 #define _BLACKFIN_SWAB_H
 
 #include <linux/types.h>
-#include <linux/compiler.h>
-
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __SWAB_64_THRU_32__
-#endif
+#include <asm-generic/swab.h>
 
 #ifdef __GNUC__
 
diff --git a/arch/blackfin/include/asm/unaligned.h b/arch/blackfin/include/asm/unaligned.h
index fd8a1d6..6cecbbb 100644
--- a/arch/blackfin/include/asm/unaligned.h
+++ b/arch/blackfin/include/asm/unaligned.h
@@ -1,11 +1 @@
-#ifndef _ASM_BLACKFIN_UNALIGNED_H
-#define _ASM_BLACKFIN_UNALIGNED_H
-
-#include <linux/unaligned/le_struct.h>
-#include <linux/unaligned/be_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_le
-#define put_unaligned	__put_unaligned_le
-
-#endif /* _ASM_BLACKFIN_UNALIGNED_H */
+#include <asm-generic/unaligned.h>
-- 
1.6.3.1

