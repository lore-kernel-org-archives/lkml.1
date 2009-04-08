Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbZDHHZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbZDHHZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZDHHZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:25:04 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:55293 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbZDHHY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:24:59 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Kyle McMartin <kyle@mcmartin.ca>
MIME-Version: 1.0
Subject: [PATCH 2/14] score - New architecure port to SunplusCT S+CORE
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF522DF4EC.299F045D-ON48257592.00284C5F-48257592.00289156@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Wed, 8 Apr 2009 15:21:00 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/04/08 ?? 03:20:58,
	Serialize complete at 2009/04/08 ?? 03:20:58
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Liqin <liqin.chen@sunplusct.com>

asm/asm.h, asm/atomic.h, asm/auxvec.h, asm/bitops.h, asm/bug.h,
asm/bugs.h, asm/byteorder.h, asm/cacheflush.h, asm/cache.h
and asm/checksum.h for the score architecture.

Signed off by: Chen Liqin <liqin.chen@sunplusct.com>
Signed off by: Lennox Wu <lennox.wu@sunplusct.com>
--

diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/asm.h 
linux-2.6-git.new/arch/score/include/asm/asm.h
--- linux-2.6-git.ori/arch/score/include/asm/asm.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/asm.h      2009-04-03 
16:54:08.000000000 +0800
@@ -0,0 +1,161 @@
+#ifndef __SCORE_ASM_H
+#define __SCORE_ASM_H
+
+#include <asm/asm-offsets.h>
+
+#ifdef __ASSEMBLY__
+
+.macro SAVE_ALL
+       mfcr    r30, cr0
+       mv      r31, r0
+       nop
+       /* if UMs == 1, change stack. */
+       slli.c  r30, r30, 28
+       bpl     8f
+       la      r31, kernelsp
+       lw      r31, [r31]
+8:
+       mv      r30, r0
+       addri   r0, r31, -PT_SIZE
+
+       sw      r30, [r0, PT_R0]
+       .set    r1
+       sw      r1, [r0, PT_R1]
+       .set    nor1
+       sw      r2, [r0, PT_R2]
+       sw      r3, [r0, PT_R3]
+       sw      r4, [r0, PT_R4]
+       sw      r5, [r0, PT_R5]
+       sw      r6, [r0, PT_R6]
+       sw      r7, [r0, PT_R7]
+
+       sw      r8, [r0, PT_R8]
+       sw      r9, [r0, PT_R9]
+       sw      r10, [r0, PT_R10]
+       sw      r11, [r0, PT_R11]
+       sw      r12, [r0, PT_R12]
+       sw      r13, [r0, PT_R13]
+       sw      r14, [r0, PT_R14]
+       sw      r15, [r0, PT_R15]
+
+       sw      r16, [r0, PT_R16]
+       sw      r17, [r0, PT_R17]
+       sw      r18, [r0, PT_R18]
+       sw      r19, [r0, PT_R19]
+       sw      r20, [r0, PT_R20]
+       sw      r21, [r0, PT_R21]
+       sw      r22, [r0, PT_R22]
+       sw      r23, [r0, PT_R23]
+
+       sw      r24, [r0, PT_R24]
+       sw      r25, [r0, PT_R25]
+       sw      r25, [r0, PT_R25]
+       sw      r26, [r0, PT_R26]
+       sw      r27, [r0, PT_R27]
+
+       sw      r28, [r0, PT_R28]
+       sw      r29, [r0, PT_R29]
+       orri    r28, r0, 0x1fff
+       li      r31, 0x00001fff
+       xor     r28, r28, r31
+
+       mfcehl  r30, r31
+       sw      r30, [r0, PT_CEH]
+       sw      r31, [r0, PT_CEL]
+
+       mfcr    r31, cr0
+       sw      r31, [r0, PT_PSR]
+
+       mfcr    r31, cr1
+       sw      r31, [r0, PT_CONDITION]
+
+       mfcr    r31, cr2
+       sw      r31, [r0, PT_ECR]
+ 
+       mfcr    r31, cr5
+       srli    r31, r31, 1
+       slli    r31, r31, 1
+       sw      r31, [r0, PT_EPC]
+.endm
+
+.macro RESTORE_ALL_AND_RET
+       mfcr    r30, cr0
+       srli    r30, r30, 1
+       slli    r30, r30, 1
+       mtcr    r30, cr0
+       nop
+       nop
+       nop
+       nop
+       nop
+
+       .set    r1
+       ldis    r1, 0x00ff
+       and     r30, r30, r1
+       not     r1, r1
+       lw      r31, [r0, PT_PSR]
+       and     r31, r31, r1
+       .set    nor1
+       or      r31, r31, r30
+       mtcr    r31, cr0
+       nop
+       nop
+       nop
+       nop
+       nop
+
+       lw      r30, [r0, PT_CONDITION]
+       mtcr    r30, cr1
+       nop
+       nop
+       nop
+       nop
+       nop
+
+       lw      r30, [r0, PT_CEH]
+       lw      r31, [r0, PT_CEL]
+       mtcehl  r30, r31
+
+       .set    r1
+       lw      r1, [r0, PT_R1]
+       .set    nor1
+       lw      r2, [r0, PT_R2]
+       lw      r3, [r0, PT_R3]
+       lw      r4, [r0, PT_R4]
+       lw      r5, [r0, PT_R5]
+       lw      r6, [r0, PT_R6]
+       lw      r7, [r0, PT_R7]
+
+       lw      r8, [r0, PT_R8]
+       lw      r9, [r0, PT_R9]
+       lw      r10, [r0, PT_R10]
+       lw      r11, [r0, PT_R11]
+       lw      r12, [r0, PT_R12]
+       lw      r13, [r0, PT_R13]
+       lw      r14, [r0, PT_R14]
+       lw      r15, [r0, PT_R15]
+
+       lw      r16, [r0, PT_R16]
+       lw      r17, [r0, PT_R17]
+       lw      r18, [r0, PT_R18]
+       lw      r19, [r0, PT_R19]
+       lw      r20, [r0, PT_R20]
+       lw      r21, [r0, PT_R21]
+       lw      r22, [r0, PT_R22]
+       lw      r23, [r0, PT_R23]
+
+       lw      r24, [r0, PT_R24]
+       lw      r25, [r0, PT_R25]
+       lw      r26, [r0, PT_R26]
+       lw      r27, [r0, PT_R27]
+       lw      r28, [r0, PT_R28]
+       lw      r29, [r0, PT_R29]
+
+       lw      r30, [r0, PT_EPC]
+       lw      r0, [r0, PT_R0]
+       mtcr    r30, cr5
+       rte
+.endm
+
+#endif /* __ASSEMBLY__ */
+#endif /* __SCORE_ASM_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/atomic.h 
linux-2.6-git.new/arch/score/include/asm/atomic.h
--- linux-2.6-git.ori/arch/score/include/asm/atomic.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/atomic.h   2009-04-07 
20:12:22.000000000 +0800
@@ -0,0 +1,240 @@
+#ifndef _SCORE_ATOMIC_H
+#define _SCORE_ATOMIC_H
+
+#include <linux/irqflags.h>
+#include <asm/system.h>
+
+#define ATOMIC_INIT(i)         {(i)}
+
+/*
+ * atomic_read - read atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically reads the value of @v.
+ */
+#define atomic_read(v)         ((v)->counter)
+
+/*
+ * atomic_set - set atomic variable
+ * @v: pointer of type atomic_t
+ * @i: required value
+ *
+ * Atomically sets the value of @v to @i.
+ */
+#define atomic_set(v, i)       ((v)->counter = (i))
+
+/*
+ * atomic_add - add integer to atomic variable
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ *
+ * Atomically adds @i to @v.
+ */
+static inline void atomic_add(int i, atomic_t *v)
+{
+       unsigned long flags;
+
+       raw_local_irq_save(flags);
+       v->counter += i;
+       raw_local_irq_restore(flags);
+}
+
+/*
+ * atomic_sub - subtract the atomic variable
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_t
+ *
+ * Atomically subtracts @i from @v.
+ */
+static inline void atomic_sub(int i, atomic_t *v)
+{
+       unsigned long flags;
+
+       raw_local_irq_save(flags);
+       v->counter -= i;
+       raw_local_irq_restore(flags);
+}
+
+/*
+ * Same as above, but return the result value
+ */
+static inline int atomic_add_return(int i, atomic_t *v)
+{
+       unsigned long flags;
+       int temp;
+
+       raw_local_irq_save(flags);
+       temp = v->counter;
+       temp += i;
+       v->counter = temp;
+       raw_local_irq_restore(flags);
+
+       return temp;
+}
+
+static inline int atomic_sub_return(int i, atomic_t *v)
+{
+       unsigned long flags;
+       int temp;
+
+       raw_local_irq_save(flags);
+       temp = v->counter;
+       temp -= i;
+       v->counter = temp;
+       raw_local_irq_restore(flags);
+
+       return temp;
+}
+
+/*
+ * atomic_sub_if_positive - conditionally subtract integer from atomic 
variable
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_t
+ *
+ * Atomically test @v and subtract @i if @v is greater or equal than @i.
+ * The function returns the old value of @v minus @i.
+ */
+static inline int atomic_sub_if_positive(int i, atomic_t *v)
+{
+       unsigned long result;
+       unsigned long flags;
+
+       raw_local_irq_save(flags);
+       result = v->counter;
+       result -= i;
+       if (result >= 0)
+               v->counter = result;
+       raw_local_irq_restore(flags);
+
+       return result;
+}
+
+static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
+{
+       unsigned long flags;
+       int prev;
+
+       raw_local_irq_save(flags);
+       prev = atomic_read(v);
+       if (prev == old)
+               atomic_set(v, new);
+       raw_local_irq_restore(flags);
+       return prev;
+}
+
+static inline int atomic_xchg(atomic_t *v, int new)
+{
+       unsigned long flags;
+       int prev;
+
+       raw_local_irq_save(flags);
+       prev = atomic_read(v);
+       atomic_set(v, new);
+       raw_local_irq_restore(flags);
+       return prev;
+}
+
+/**
+ * atomic_add_unless - add unless the number is a given value
+ * @v: pointer of type atomic_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as it was not @u.
+ * Returns non-zero if @v was not @u, and zero otherwise.
+ */
+static inline int atomic_add_unless(atomic_t *v, int a, int u)
+{
+       int c, old;
+       c = atomic_read(v);
+       for (;;) {
+               if (unlikely(c == (u)))
+                       break;
+               old = atomic_cmpxchg((v), c, c + (a));
+               if (likely(old == c))
+                       break;
+               c = old;
+       }
+       return c != (u);
+}
+
+#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
+
+#define atomic_dec_return(v) atomic_sub_return(1, (v))
+#define atomic_inc_return(v) atomic_add_return(1, (v))
+
+/*
+ * atomic_sub_and_test - subtract value from variable and test result
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_t
+ *
+ * Atomically subtracts @i from @v and returns
+ * true if the result is zero, or false for all
+ * other cases.
+ */
+#define atomic_sub_and_test(i, v) (atomic_sub_return((i), (v)) == 0)
+
+/*
+ * atomic_inc_and_test - increment and test
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+#define atomic_inc_and_test(v) (atomic_inc_return(v) == 0)
+
+/*
+ * atomic_dec_and_test - decrement by 1 and test
+ * @v: pointer of type atomic_t
+ *
+ * Atomically decrements @v by 1 and
+ * returns true if the result is 0, or false for all other
+ * cases.
+ */
+#define atomic_dec_and_test(v) (atomic_sub_return(1, (v)) == 0)
+
+/*
+ * atomic_dec_if_positive - decrement by 1 if old value positive
+ * @v: pointer of type atomic_t
+ */
+#define atomic_dec_if_positive(v)      atomic_sub_if_positive(1, v)
+
+/*
+ * atomic_inc - increment atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1.
+ */
+#define atomic_inc(v) atomic_add(1, (v))
+
+/*
+ * atomic_dec - decrement and test
+ * @v: pointer of type atomic_t
+ *
+ * Atomically decrements @v by 1.
+ */
+#define atomic_dec(v) atomic_sub(1, (v))
+
+/*
+ * atomic_add_negative - add and test if negative
+ * @v: pointer of type atomic_t
+ * @i: integer value to add
+ *
+ * Atomically adds @i to @v and returns true
+ * if the result is negative, or false when
+ * result is greater than or equal to zero.
+ */
+#define atomic_add_negative(i, v) (atomic_add_return(i, (v)) < 0)
+
+/*
+ * atomic*_return operations are serializing but not the non-*_return
+ * versions.
+ */
+#define smp_mb__before_atomic_dec()    barrier()
+#define smp_mb__after_atomic_dec()     barrier()
+#define smp_mb__before_atomic_inc()    barrier()
+#define smp_mb__after_atomic_inc()     barrier()
+
+#include <asm-generic/atomic.h>
+#endif /* _SCORE_ATOMIC_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/auxvec.h 
linux-2.6-git.new/arch/score/include/asm/auxvec.h
--- linux-2.6-git.ori/arch/score/include/asm/auxvec.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/auxvec.h   2009-04-03 
16:54:39.000000000 +0800
@@ -0,0 +1,4 @@
+#ifndef _SCORE_AUXVEC_H
+#define _SCORE_AUXVEC_H
+
+#endif /* _SCORE_AUXVEC_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/bitops.h 
linux-2.6-git.new/arch/score/include/asm/bitops.h
--- linux-2.6-git.ori/arch/score/include/asm/bitops.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/bitops.h   2009-04-03 
16:55:04.000000000 +0800
@@ -0,0 +1,253 @@
+#ifndef _SCORE_BITOPS_H
+#define _SCORE_BITOPS_H
+
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
+#include <linux/compiler.h>
+#include <linux/irqflags.h>
+#include <linux/types.h>
+#include <asm/system.h>
+#include <asm/byteorder.h>
+
+#define SZLONG_LOG 5
+#define SZLONG_MASK 31UL
+
+/*
+ * clear_bit() doesn't provide any barrier for the compiler.
+ */
+#define smp_mb__before_clear_bit()     barrier()
+#define smp_mb__after_clear_bit()      barrier()
+
+/*
+ * set_bit - Atomically set a bit in memory
+ * @nr: the bit to set
+ * @addr: the address to start counting from
+ *
+ * This function is atomic and may not be reordered.  See __set_bit()
+ * if you do not require the atomic guarantees.
+ * Note that @nr may be almost arbitrarily large; this function is not
+ * restricted to acting on a single-word quantity.
+ */
+static inline void set_bit(unsigned long nr, volatile unsigned long 
*addr)
+{
+       unsigned short bit = nr & SZLONG_MASK;
+
+       volatile unsigned long *a = addr;
+       unsigned long mask;
+       unsigned long flags;
+
+       a += nr >> SZLONG_LOG;
+       mask = 1UL << bit;
+       raw_local_irq_save(flags);
+       *a |= mask;
+       raw_local_irq_restore(flags);
+}
+
+/*
+ * clear_bit - Clears a bit in memory
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * clear_bit() is atomic and may not be reordered.  However, it does
+ * not contain a memory barrier, so if it is used for locking purposes,
+ * you should call smp_mb__before_clear_bit() and/or 
smp_mb__after_clear_bit()
+ * in order to ensure changes are visible on other processors.
+ */
+static inline void clear_bit(unsigned long nr, volatile unsigned long 
*addr)
+{
+       unsigned short bit = nr & SZLONG_MASK;
+
+       volatile unsigned long *a = addr;
+       unsigned long mask;
+       unsigned long flags;
+
+       a += nr >> SZLONG_LOG;
+       mask = 1UL << bit;
+       raw_local_irq_save(flags);
+       *a &= ~mask;
+       raw_local_irq_restore(flags);
+}
+
+/*
+ * clear_bit_unlock - Clears a bit in memory
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * clear_bit() is atomic and implies release semantics before the memory
+ * operation. It can be used for an unlock.
+ */
+static inline void
+clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
+{
+       clear_bit(nr, addr);
+}
+
+/*
+ * change_bit - Toggle a bit in memory
+ * @nr: Bit to change
+ * @addr: Address to start counting from
+ *
+ * change_bit() is atomic and may not be reordered.
+ * Note that @nr may be almost arbitrarily large; this function is not
+ * restricted to acting on a single-word quantity.
+ */
+static inline void change_bit(unsigned long nr, volatile unsigned long 
*addr)
+{
+       unsigned short bit = nr & SZLONG_MASK;
+       volatile unsigned long *a = addr;
+       unsigned long mask;
+       unsigned long flags;
+
+       a += nr >> SZLONG_LOG;
+       mask = 1UL << bit;
+       raw_local_irq_save(flags);
+       *a ^= mask;
+       raw_local_irq_restore(flags);
+}
+
+/*
+ * test_and_set_bit - Set a bit and return its old value
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This operation is atomic and cannot be reordered.
+ * It also implies a memory barrier.
+ */
+static inline int
+test_and_set_bit(unsigned long nr, volatile unsigned long *addr)
+{
+       unsigned short bit = nr & SZLONG_MASK;
+       unsigned long res;
+       volatile unsigned long *a = addr;
+       unsigned long mask;
+       unsigned long flags;
+
+       a += nr >> SZLONG_LOG;
+       mask = 1UL << bit;
+       raw_local_irq_save(flags);
+       res = (mask & *a);
+       *a |= mask;
+       raw_local_irq_restore(flags);
+
+       return res != 0;
+}
+
+/*
+ * test_and_set_bit_lock - Set a bit and return its old value
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This operation is atomic and implies acquire ordering semantics
+ * after the memory operation.
+ */
+static inline int
+test_and_set_bit_lock(unsigned long nr, volatile unsigned long *addr)
+{
+       unsigned short bit = nr & SZLONG_MASK;
+       unsigned long res;
+       volatile unsigned long *a = addr;
+       unsigned long mask;
+       unsigned long flags;
+
+       a += nr >> SZLONG_LOG;
+       mask = 1UL << bit;
+       raw_local_irq_save(flags);
+       res = (mask & *a);
+       *a |= mask;
+       raw_local_irq_restore(flags);
+
+       return res != 0;
+}
+/*
+ * test_and_clear_bit - Clear a bit and return its old value
+ * @nr: Bit to clear
+ * @addr: Address to count from
+ *
+ * This operation is atomic and cannot be reordered.
+ * It also implies a memory barrier.
+ */
+static inline int
+test_and_clear_bit(unsigned long nr, volatile unsigned long *addr)
+{
+       unsigned short bit = nr & SZLONG_MASK;
+       unsigned long res;
+       volatile unsigned long *a = addr;
+       unsigned long mask;
+       unsigned long flags;
+
+       a += nr >> SZLONG_LOG;
+       mask = 1UL << bit;
+       raw_local_irq_save(flags);
+       res = (mask & *a);
+       *a &= ~mask;
+       raw_local_irq_restore(flags);
+
+       return res != 0;
+}
+
+/*
+ * test_and_change_bit - Change a bit and return its old value
+ * @nr: Bit to change
+ * @addr: Address to count from
+ *
+ * This operation is atomic and cannot be reordered.
+ * It also implies a memory barrier.
+ */
+static inline int
+test_and_change_bit(unsigned long nr, volatile unsigned long *addr)
+{
+       unsigned short bit = nr & SZLONG_MASK;
+       unsigned long res;
+       volatile unsigned long *a = addr;
+       unsigned long mask;
+       unsigned long flags;
+
+       a += nr >> SZLONG_LOG;
+       mask = 1UL << bit;
+       raw_local_irq_save(flags);
+       res = (mask & *a);
+       *a ^= mask;
+       raw_local_irq_restore(flags);
+
+       return res != 0;
+}
+
+#include <asm-generic/bitops/non-atomic.h>
+
+/*
+ * __clear_bit_unlock - Clears a bit in memory
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * __clear_bit() is non-atomic and implies release semantics before the 
memory
+ * operation. It can be used for an unlock if no other CPUs can 
concurrently
+ * modify other bits in the word.
+ */
+static inline void
+__clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
+{
+       __clear_bit(nr, addr);
+}
+
+#include <asm-generic/bitops/__ffs.h>
+#include <asm-generic/bitops/__fls.h>
+#include <asm-generic/bitops/ffs.h>
+#include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/fls64.h>
+
+#include <asm-generic/bitops/ffz.h>
+#include <asm-generic/bitops/find.h>
+
+#ifdef __KERNEL__
+
+#include <asm-generic/bitops/sched.h>
+#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/ext2-non-atomic.h>
+#include <asm-generic/bitops/ext2-atomic.h>
+#include <asm-generic/bitops/minix.h>
+
+#endif /* __KERNEL__ */
+
+#endif /* _SCORE_BITOPS_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/bug.h 
linux-2.6-git.new/arch/score/include/asm/bug.h
--- linux-2.6-git.ori/arch/score/include/asm/bug.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/bug.h      2009-04-03 
16:55:20.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef __SCORE_BUG_H
+#define __SCORE_BUG_H
+
+#include <asm-generic/bug.h>
+
+#endif /* __SCORE_BUG_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/bugs.h 
linux-2.6-git.new/arch/score/include/asm/bugs.h
--- linux-2.6-git.ori/arch/score/include/asm/bugs.h     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/bugs.h     2009-04-03 
16:56:16.000000000 +0800
@@ -0,0 +1,7 @@
+#ifndef __SCORE_BUGS_H
+#define __SCORE_BUGS_H
+
+static inline void check_bugs(void)
+{}
+
+#endif /* __SCORE_BUGS_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/byteorder.h 
linux-2.6-git.new/arch/score/include/asm/byteorder.h
--- linux-2.6-git.ori/arch/score/include/asm/byteorder.h        1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/byteorder.h        2009-04-03 
16:56:46.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef __SCORE_BYTEORDER_H
+#define __SCORE_BYTEORDER_H
+
+#include <linux/byteorder/little_endian.h>
+
+#endif /* __SCORE_BYTEORDER_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/cacheflush.h 
linux-2.6-git.new/arch/score/include/asm/cacheflush.h
--- linux-2.6-git.ori/arch/score/include/asm/cacheflush.h       1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/cacheflush.h       2009-04-07 
20:15:35.000000000 +0800
@@ -0,0 +1,85 @@
+#ifndef __SCORE_CACHEFLUSH_H
+#define __SCORE_CACHEFLUSH_H
+
+/* Keep includes the same across arches.  */
+#include <linux/mm.h>
+
+/* Cache flushing:
+ *
+ *  - flush_cache_all() flushes entire cache
+ *  - flush_cache_mm(mm) flushes the specified mm context's cache lines
+ *  - flush_cache_dup mm(mm) handles cache flushing when forking
+ *  - flush_cache_page(mm, vmaddr, pfn) flushes a single page
+ *  - flush_cache_range(vma, start, end) flushes a range of pages
+ *  - flush_icache_range(start, end) flush a range of instructions
+ *  - flush_dcache_page(pg) flushes(wback&invalidates) a page for dcache
+ *
+ *  - flush_cache_sigtramp() flush signal trampoline
+ *  - flush_icache_all() flush the entire instruction cache
+ *  - flush_data_cache_page() flushes a page from the data cache
+ */
+extern void (*flush_cache_all)(void);
+extern void (*__flush_cache_all)(void);
+extern void (*flush_cache_mm)(struct mm_struct *mm);
+extern void (*flush_cache_range)(struct vm_area_struct *vma,
+                                unsigned long start, unsigned long end);
+extern void (*flush_cache_page)(struct vm_area_struct *vma,
+                                unsigned long page, unsigned long pfn);
+extern void __flush_dcache_page(struct page *page);
+
+#define flush_cache_dup_mm(mm)                 do {} while (0)
+#define flush_dcache_page(page)                        do {} while (0)
+#define flush_dcache_mmap_lock(mapping)                do {} while (0)
+#define flush_dcache_mmap_unlock(mapping)      do {} while (0)
+
+extern void (*flush_icache_range)(unsigned long start, unsigned long 
end);
+
+static inline void flush_icache_page(struct vm_area_struct *vma,
+       struct page *page)
+{
+       if (vma->vm_flags & VM_EXEC) {
+               void *v = page_address(page);
+               flush_icache_range((unsigned long) v,
+                                  (unsigned long) v + PAGE_SIZE);
+       }
+}
+
+extern void (*flush_icache_range)(unsigned long start, unsigned long 
end);
+extern void (*__flush_cache_vmap)(void);
+extern void (*__flush_cache_vunmap)(void);
+
+static inline void flush_cache_vmap(unsigned long start, unsigned long 
end)
+{}
+
+static inline void flush_cache_vunmap(unsigned long start, unsigned long 
end)
+{}
+
+#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
+       memcpy(dst, src, len)
+
+#define copy_to_user_page(vma, page, vaddr, dst, src, len)     \
+       do {                                                    \
+               memcpy(dst, src, len);                          \
+               if ((vma->vm_flags & VM_EXEC))                  \
+                       flush_cache_page(vma, vaddr, page_to_pfn(page));\
+       } while (0)
+
+extern void (*flush_cache_sigtramp)(unsigned long addr);
+extern void (*flush_icache_all)(void);
+extern void (*local_flush_data_cache_page)(void *addr);
+extern void (*flush_data_cache_page)(unsigned long addr);
+
+/*
+ * This flag is used to indicate that the page pointed to by a pte
+ * is dirty and requires cleaning before returning it to the user.
+ */
+#define PG_dcache_dirty                        PG_arch_1
+
+#define Page_dcache_dirty(page)                \
+       test_bit(PG_dcache_dirty, &(page)->flags)
+#define SetPageDcacheDirty(page)       \
+       set_bit(PG_dcache_dirty, &(page)->flags)
+#define ClearPageDcacheDirty(page)     \
+       clear_bit(PG_dcache_dirty, &(page)->flags)
+
+#endif /* __SCORE_CACHEFLUSH_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/cache.h 
linux-2.6-git.new/arch/score/include/asm/cache.h
--- linux-2.6-git.ori/arch/score/include/asm/cache.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/cache.h    2009-04-08 
10:27:16.000000000 +0800
@@ -0,0 +1,16 @@
+#ifndef __SCORE_CACHE_H
+#define __SCORE_CACHE_H
+
+/* Primary cache parameters. Cache Line Size*/
+/* Score7 chache line size:4 words*/
+#define ICACHE_LSIZE           16
+#define DCACHE_LSIZE           16
+
+#define L1_CACHE_SHIFT         4
+#define L1_CACHE_BYTES         (1 << L1_CACHE_SHIFT)
+
+void s7_flush_cache_all(void);
+void s7_flush_dcache_all(void);
+void s7_flush_icache_all(void);
+
+#endif /* __SCORE_CACHE_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/checksum.h 
linux-2.6-git.new/arch/score/include/asm/checksum.h
--- linux-2.6-git.ori/arch/score/include/asm/checksum.h 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/checksum.h 2009-04-07 
20:17:19.000000000 +0800
@@ -0,0 +1,236 @@
+#ifndef __SCORE_CHECKSUM_H
+#define __SCORE_CHECKSUM_H
+
+#include <linux/in6.h>
+
+#include <asm/uaccess.h>
+
+/*
+ * computes the checksum of a memory block at buff, length len,
+ * and adds in "sum" (32-bit)
+ *
+ * returns a 32-bit number suitable for feeding into itself
+ * or csum_tcpudp_magic
+ *
+ * this function must be called with even lengths, except
+ * for the last fragment, which may be odd
+ *
+ * it's best to have buff aligned on a 32-bit boundary
+ */
+unsigned int csum_partial(const void *buff, int len, __wsum sum);
+unsigned int csum_partial_copy_from_user(const char *src, char *dst, int 
len,
+                                        unsigned int sum, int *csum_err);
+unsigned int csum_partial_copy(const char *src, char *dst,
+                                        int len, unsigned int sum);
+
+/*
+ * this is a new version of the above that records errors it finds in 
*errp,
+ * but continues and zeros the rest of the buffer.
+ */
+
+/*
+ * Copy and checksum to user
+ */
+#define HAVE_CSUM_COPY_USER
+static inline
+__wsum csum_and_copy_to_user(const void *src, void __user *dst, int len,
+                               __wsum sum, int *err_ptr)
+{
+       sum = csum_partial(src, len, sum);
+       if (copy_to_user(dst, src, len)) {
+               *err_ptr = -EFAULT;
+               return (__force __wsum) -1; /* invalid checksum */
+       }
+       return sum;
+}
+
+
+#define csum_partial_copy_nocheck csum_partial_copy
+/*
+ *     Fold a partial checksum without adding pseudo headers
+ */
+
+static inline __sum16 csum_fold(__wsum sum)
+{
+       /* the while loop is unnecessary really, it's always enough with 
two
+          iterations */
+       __asm__ __volatile__(
+               ".set volatile\n\t"
+               ".set\tr1\n\t"
+               "slli\tr1,%0, 16\n\t"
+               "add\t%0,%0, r1\n\t"
+               "cmp.c\tr1, %0\n\t"
+               "srli\t%0, %0, 16\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n\t"
+               "1:ldi\tr30, 0xffff\n\t"
+               "xor\t%0, %0, r30\n\t"
+               "slli\t%0, %0, 16\n\t"
+               "srli\t%0, %0, 16\n\t"
+               ".set\tnor1\n\t"
+               ".set optimize\n\t"
+               : "=r" (sum)
+               : "0" (sum));
+       return sum;
+}
+
+/*
+ *     This is a version of ip_compute_csum() optimized for IP headers,
+ *     which always checksum on 4 octet boundaries.
+ *
+ *     By Jorge Cwik <jorge@laser.satlink.net>, adapted for linux by
+ *     Arnt Gulbrandsen.
+ */
+static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
+{
+       unsigned int sum;
+       unsigned long dummy;
+
+       __asm__ __volatile__(
+               ".set volatile\n\t"
+               ".set\tnor1\n\t"
+               "lw\t%0, [%1]\n\t"
+               "subri\t%2, %2, 4\n\t"
+               "slli\t%2, %2, 2\n\t"
+               "lw\t%3, [%1, 4]\n\t"
+               "add\t%2, %2, %1\n\t"
+               "add\t%0, %0, %3\n\t"
+               "cmp.c\t%3, %0\n\t"
+               "lw\t%3, [%1, 8]\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n\t"
+               "1:\n\t"
+               "add\t%0, %0, %3\n\t"
+               "cmp.c\t%3, %0\n\t"
+               "lw\t%3, [%1, 12]\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n\t"
+               "1:add\t%0, %0, %3\n\t"
+               "cmp.c\t%3, %0\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n"
+
+               "1:\tlw\t%3, [%1, 16]\n\t"
+               "addi\t%1, 4\n\t"
+               "add\t%0, %0, %3\n\t"
+               "cmp.c\t%3, %0\n\t"
+               "bleu\t2f\n\t"
+               "addi\t%0, 0x1\n"
+               "2:cmp.c\t%2, %1\n\t"
+               "bne\t1b\n\t"
+
+               ".set\tr1\n\t"
+               ".set optimize\n\t"
+               : "=&r" (sum), "=&r" (iph), "=&r" (ihl), "=&r" (dummy)
+               : "1" (iph), "2" (ihl));
+
+       return csum_fold(sum);
+}
+
+static inline __wsum
+csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
+                       unsigned short proto, __wsum sum)
+{
+       unsigned long tmp = (ntohs(len) << 16) + proto * 256;
+       __asm__ __volatile__(
+               ".set volatile\n\t"
+               "add\t%0, %0, %2\n\t"
+               "cmp.c\t%2, %0\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n\t"
+               "1:\n\t"
+               "add\t%0, %0, %3\n\t"
+               "cmp.c\t%3, %0\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n\t"
+               "1:\n\t"
+               "add\t%0, %0, %4\n\t"
+               "cmp.c\t%4, %0\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n\t"
+               "1:\n\t"
+               ".set optimize\n\t"
+               : "=r" (sum)
+               : "0" (daddr), "r"(saddr),
+               "r" (tmp),
+               "r" (sum));
+       return sum;
+}
+
+/*
+ * computes the checksum of the TCP/UDP pseudo-header
+ * returns a 16-bit checksum, already complemented
+ */
+static inline __sum16
+csum_tcpudp_magic(__be32 saddr, __be32 daddr, unsigned short len,
+                       unsigned short proto, __wsum sum)
+{
+       return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, 
sum));
+}
+
+/*
+ * this routine is used for miscellaneous IP-like checksums, mainly
+ * in icmp.c
+ */
+
+static inline unsigned short ip_compute_csum(const void *buff, int len)
+{
+       return csum_fold(csum_partial(buff, len, 0));
+}
+
+#define _HAVE_ARCH_IPV6_CSUM
+static inline __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
+                                       const struct in6_addr *daddr,
+                                       __u32 len, unsigned short proto,
+                                       __wsum sum)
+{
+       __asm__ __volatile__(
+               ".set\tnoreorder\t\t\t# csum_ipv6_magic\n\t"
+               ".set\tnoat\n\t"
+               "addu\t%0, %5\t\t\t# proto (long in network byte 
order)\n\t"
+               "sltu\t$1, %0, %5\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %6\t\t\t# csum\n\t"
+               "sltu\t$1, %0, %6\n\t"
+               "lw\t%1, 0(%2)\t\t\t# four words source address\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 4(%2)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 8(%2)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 12(%2)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 0(%3)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 4(%3)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 8(%3)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 12(%3)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "addu\t%0, $1\t\t\t# Add final carry\n\t"
+               ".set\tnoat\n\t"
+               ".set\tnoreorder"
+               : "=r" (sum), "=r" (proto)
+               : "r" (saddr), "r" (daddr),
+                 "0" (htonl(len)), "1" (htonl(proto)), "r" (sum));
+
+       return csum_fold(sum);
+}
+#endif /* __SCORE_CHECKSUM_H */
