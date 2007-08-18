Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbXHRJll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbXHRJll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 05:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbXHRJlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 05:41:31 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:43331 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751693AbXHRJla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 05:41:30 -0400
Message-id: <159298518156416012@wsc.cz>
In-reply-to: <737828602404912540@wsc.cz>
Subject: [PATCH 6/9] define first set of BIT* macros
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sat, 18 Aug 2007 11:42:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

define first set of BIT* macros

- move BITOP_MASK and BITOP_WORD from asm-generic/bitops/atomic.h to
  include/linux/bitops.h and rename it to BIT_MASK and BIT_WORD
- move BITS_TO_LONGS and BITS_PER_BYTE to bitops.h too and allow easily
  define another BITS_TO_something (e.g. in event.c) by BITS_TO_TYPE macro
Remaining (and common) BIT macro will be defined after all occurences and
conflicts will be sorted out in the patches.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 57e4f5e2b08adde4730d20ee8b8e1e6706f6ce7c
tree ed8a6053be2d6901a39ddeb31dd7ea66b7f24e98
parent 4e7c777ee287082c3185d50a5dab813f562f70de
author Jiri Slaby <jirislaby@gmail.com> Wed, 15 Aug 2007 22:04:45 +0200
committer Jiri Slaby <jirislaby@gmail.com> Wed, 15 Aug 2007 22:04:45 +0200

 include/asm-generic/bitops/atomic.h     |   27 ++++++++++++---------------
 include/asm-generic/bitops/non-atomic.h |   29 +++++++++++++----------------
 include/linux/bitops.h                  |    8 ++++++++
 include/linux/types.h                   |    3 ---
 4 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/include/asm-generic/bitops/atomic.h b/include/asm-generic/bitops/atomic.h
index cd8a964..4657f3e 100644
--- a/include/asm-generic/bitops/atomic.h
+++ b/include/asm-generic/bitops/atomic.h
@@ -3,9 +3,6 @@
 
 #include <asm/types.h>
 
-#define BITOP_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
-#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
-
 #ifdef CONFIG_SMP
 #include <asm/spinlock.h>
 #include <asm/cache.h>		/* we use L1_CACHE_BYTES */
@@ -66,8 +63,8 @@ extern raw_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned;
  */
 static inline void set_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long flags;
 
 	_atomic_spin_lock_irqsave(p, flags);
@@ -87,8 +84,8 @@ static inline void set_bit(int nr, volatile unsigned long *addr)
  */
 static inline void clear_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long flags;
 
 	_atomic_spin_lock_irqsave(p, flags);
@@ -108,8 +105,8 @@ static inline void clear_bit(int nr, volatile unsigned long *addr)
  */
 static inline void change_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long flags;
 
 	_atomic_spin_lock_irqsave(p, flags);
@@ -128,8 +125,8 @@ static inline void change_bit(int nr, volatile unsigned long *addr)
  */
 static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long old;
 	unsigned long flags;
 
@@ -152,8 +149,8 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
  */
 static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long old;
 	unsigned long flags;
 
@@ -175,8 +172,8 @@ static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
  */
 static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long old;
 	unsigned long flags;
 
diff --git a/include/asm-generic/bitops/non-atomic.h b/include/asm-generic/bitops/non-atomic.h
index 46a825c..697cc2b 100644
--- a/include/asm-generic/bitops/non-atomic.h
+++ b/include/asm-generic/bitops/non-atomic.h
@@ -3,9 +3,6 @@
 
 #include <asm/types.h>
 
-#define BITOP_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
-#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
-
 /**
  * __set_bit - Set a bit in memory
  * @nr: the bit to set
@@ -17,16 +14,16 @@
  */
 static inline void __set_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 
 	*p  |= mask;
 }
 
 static inline void __clear_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 
 	*p &= ~mask;
 }
@@ -42,8 +39,8 @@ static inline void __clear_bit(int nr, volatile unsigned long *addr)
  */
 static inline void __change_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 
 	*p ^= mask;
 }
@@ -59,8 +56,8 @@ static inline void __change_bit(int nr, volatile unsigned long *addr)
  */
 static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long old = *p;
 
 	*p = old | mask;
@@ -78,8 +75,8 @@ static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
  */
 static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long old = *p;
 
 	*p = old & ~mask;
@@ -90,8 +87,8 @@ static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
 static inline int __test_and_change_bit(int nr,
 					    volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long old = *p;
 
 	*p = old ^ mask;
@@ -105,7 +102,7 @@ static inline int __test_and_change_bit(int nr,
  */
 static inline int test_bit(int nr, const volatile unsigned long *addr)
 {
-	return 1UL & (addr[BITOP_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
+	return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
 }
 
 #endif /* _ASM_GENERIC_BITOPS_NON_ATOMIC_H_ */
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 638165f..3255b06 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -2,6 +2,14 @@
 #define _LINUX_BITOPS_H
 #include <asm/types.h>
 
+#ifdef	__KERNEL__
+#define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
+#define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
+#define BITS_TO_TYPE(nr, t)	(((nr)+(t)-1)/(t))
+#define BITS_TO_LONGS(nr)	BITS_TO_TYPE(nr, BITS_PER_LONG)
+#define BITS_PER_BYTE		8
+#endif
+
 /*
  * Include this here because some architectures need generic_ffs/fls in
  * scope
diff --git a/include/linux/types.h b/include/linux/types.h
index 0351bf2..4f0dad2 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -3,12 +3,9 @@
 
 #ifdef	__KERNEL__
 
-#define BITS_TO_LONGS(bits) \
-	(((bits)+BITS_PER_LONG-1)/BITS_PER_LONG)
 #define DECLARE_BITMAP(name,bits) \
 	unsigned long name[BITS_TO_LONGS(bits)]
 
-#define BITS_PER_BYTE 8
 #endif
 
 #include <linux/posix_types.h>
