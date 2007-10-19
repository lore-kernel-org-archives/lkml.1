Return-Path: <linux-kernel-owner+w=401wt.eu-S1764456AbXJSFNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764456AbXJSFNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 01:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbXJSFNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 01:13:07 -0400
Received: from ns.suse.de ([195.135.220.2]:48086 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbXJSFNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 01:13:06 -0400
Date: Fri, 19 Oct 2007 07:13:02 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] x86: lock bitops
Message-ID: <20071019051302.GA14702@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I missed an obvious one!

x86 CPUs are defined not to reorder stores past earlier loads, so there is
no hardware memory barrier required to implement a release-consistent store
(all stores are, by definition).

So ditch the generic lock bitops, and implement optimised versions for x86,
which removes the mfence from __clear_bit_unlock (which is already a useful
primitive for SLUB).

Signed-off-by: Nick Piggin <npiggin@suse.de>

---
Index: linux-2.6/include/asm-x86/bitops_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/bitops_32.h
+++ linux-2.6/include/asm-x86/bitops_32.h
@@ -76,6 +76,20 @@ static inline void clear_bit(int nr, vol
 		:"Ir" (nr));
 }
 
+/*
+ * clear_bit_unlock - Clears a bit in memory
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * clear_bit() is atomic and implies release semantics before the memory
+ * operation. It can be used for an unlock.
+ */
+static inline void clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
+{
+	barrier();
+	clear_bit(nr, addr);
+}
+
 static inline void __clear_bit(int nr, volatile unsigned long * addr)
 {
 	__asm__ __volatile__(
@@ -83,6 +97,25 @@ static inline void __clear_bit(int nr, v
 		:"+m" (ADDR)
 		:"Ir" (nr));
 }
+
+/*
+ * __clear_bit_unlock - Clears a bit in memory
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * __clear_bit() is non-atomic and implies release semantics before the memory
+ * operation. It can be used for an unlock if no other CPUs can concurrently
+ * modify other bits in the word.
+ *
+ * No memory barrier is required here, because x86 cannot reorder stores past
+ * older loads. Same principle as spin_unlock.
+ */
+static inline void __clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
+{
+	barrier();
+	__clear_bit(nr, addr);
+}
+
 #define smp_mb__before_clear_bit()	barrier()
 #define smp_mb__after_clear_bit()	barrier()
 
@@ -142,6 +175,15 @@ static inline int test_and_set_bit(int n
 }
 
 /**
+ * test_and_set_bit_lock - Set a bit and return its old value for lock
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This is the same as test_and_set_bit on x86
+ */
+#define test_and_set_bit_lock test_and_set_bit
+
+/**
  * __test_and_set_bit - Set a bit and return its old value
  * @nr: Bit to set
  * @addr: Address to count from
@@ -402,7 +444,6 @@ static inline int fls(int x)
 }
 
 #include <asm-generic/bitops/hweight.h>
-#include <asm-generic/bitops/lock.h>
 
 #endif /* __KERNEL__ */
 
Index: linux-2.6/include/asm-x86/bitops_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/bitops_64.h
+++ linux-2.6/include/asm-x86/bitops_64.h
@@ -68,6 +68,20 @@ static __inline__ void clear_bit(int nr,
 		:"dIr" (nr));
 }
 
+/*
+ * clear_bit_unlock - Clears a bit in memory
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * clear_bit() is atomic and implies release semantics before the memory
+ * operation. It can be used for an unlock.
+ */
+static inline void clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
+{
+	barrier();
+	clear_bit(nr, addr);
+}
+
 static __inline__ void __clear_bit(int nr, volatile void * addr)
 {
 	__asm__ __volatile__(
@@ -76,6 +90,24 @@ static __inline__ void __clear_bit(int n
 		:"dIr" (nr));
 }
 
+/*
+ * __clear_bit_unlock - Clears a bit in memory
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * __clear_bit() is non-atomic and implies release semantics before the memory
+ * operation. It can be used for an unlock if no other CPUs can concurrently
+ * modify other bits in the word.
+ *
+ * No memory barrier is required here, because x86 cannot reorder stores past
+ * older loads. Same principle as spin_unlock.
+ */
+static inline void __clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
+{
+	barrier();
+	__clear_bit(nr, addr);
+}
+
 #define smp_mb__before_clear_bit()	barrier()
 #define smp_mb__after_clear_bit()	barrier()
 
@@ -133,6 +165,15 @@ static __inline__ int test_and_set_bit(i
 }
 
 /**
+ * test_and_set_bit_lock - Set a bit and return its old value for lock
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This is the same as test_and_set_bit on x86
+ */
+#define test_and_set_bit_lock test_and_set_bit
+
+/**
  * __test_and_set_bit - Set a bit and return its old value
  * @nr: Bit to set
  * @addr: Address to count from
@@ -408,7 +449,6 @@ static __inline__ int fls(int x)
 #define ARCH_HAS_FAST_MULTIPLIER 1
 
 #include <asm-generic/bitops/hweight.h>
-#include <asm-generic/bitops/lock.h>
 
 #endif /* __KERNEL__ */
 
