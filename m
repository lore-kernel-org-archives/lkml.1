Return-Path: <linux-kernel-owner+w=401wt.eu-S1760882AbZBYEuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882AbZBYEuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760774AbZBYEuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:50:22 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:15738 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759856AbZBYEuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:50:20 -0500
Date: Tue, 24 Feb 2009 20:52:22 -0800 (PST)
From: Justin Chen <jchen@hpdst41.cup.hp.com>
Message-Id: <200902250452.UAA12892@hpdst41.cup.hp.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 13/15] bitops: Change the bitmap index from int to unsigned long [x86]
Cc: bjorn.helgaas@hp.com, hpa@zytor.com, justin.chen@hp.com,
       linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
       x86@kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the index to unsigned long in all bitops for [x86]

Signed-off-by: Justin Chen <justin.chen@hp.com>
Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 arch/x86/boot/bitops.h             |    6 ++---
 arch/x86/include/asm/bitops.h      |   48 +++++++++++++++++++++++++++++-----------------
 arch/x86/include/asm/sync_bitops.h |   18 +++++++++++------
 3 files changed, 46 insertions(+), 26 deletions(-)
diff -Nru a/arch/x86/boot/bitops.h b/arch/x86/boot/bitops.h
--- a/arch/x86/boot/bitops.h	2009-02-13 15:31:30.000000000 -0800
+++ b/arch/x86/boot/bitops.h	2009-02-15 18:19:39.786205084 -0800
@@ -16,12 +16,12 @@
 #define BOOT_BITOPS_H
 #define _LINUX_BITOPS_H		/* Inhibit inclusion of <linux/bitops.h> */
 
-static inline int constant_test_bit(int nr, const void *addr)
+static inline int constant_test_bit(unsigned long nr, const void *addr)
 {
 	const u32 *p = (const u32 *)addr;
 	return ((1UL << (nr & 31)) & (p[nr >> 5])) != 0;
 }
-static inline int variable_test_bit(int nr, const void *addr)
+static inline int variable_test_bit(unsigned long nr, const void *addr)
 {
 	u8 v;
 	const u32 *p = (const u32 *)addr;
@@ -35,7 +35,7 @@
  constant_test_bit((nr),(addr)) : \
  variable_test_bit((nr),(addr)))
 
-static inline void set_bit(int nr, void *addr)
+static inline void set_bit(unsigned long nr, void *addr)
 {
 	asm("btsl %1,%0" : "+m" (*(u32 *)addr) : "Ir" (nr));
 }
diff -Nru a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
--- a/arch/x86/include/asm/bitops.h	2009-02-13 15:31:30.000000000 -0800
+++ b/arch/x86/include/asm/bitops.h	2009-02-15 18:19:39.787181647 -0800
@@ -57,7 +57,7 @@
  * restricted to acting on a single-word quantity.
  */
 static __always_inline void
-set_bit(unsigned int nr, volatile unsigned long *addr)
+set_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "orb %1,%0"
@@ -79,7 +79,8 @@
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __set_bit(int nr, volatile unsigned long *addr)
+static inline void
+__set_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	asm volatile("bts %1,%0" : ADDR : "Ir" (nr) : "memory");
 }
@@ -95,7 +96,7 @@
  * in order to ensure changes are visible on other processors.
  */
 static __always_inline void
-clear_bit(int nr, volatile unsigned long *addr)
+clear_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "andb %1,%0"
@@ -116,13 +117,15 @@
  * clear_bit() is atomic and implies release semantics before the memory
  * operation. It can be used for an unlock.
  */
-static inline void clear_bit_unlock(unsigned nr, volatile unsigned long *addr)
+static inline void
+clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
 {
 	barrier();
 	clear_bit(nr, addr);
 }
 
-static inline void __clear_bit(int nr, volatile unsigned long *addr)
+static inline void
+__clear_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	asm volatile("btr %1,%0" : ADDR : "Ir" (nr));
 }
@@ -139,7 +142,8 @@
  * No memory barrier is required here, because x86 cannot reorder stores past
  * older loads. Same principle as spin_unlock.
  */
-static inline void __clear_bit_unlock(unsigned nr, volatile unsigned long *addr)
+static inline void
+__clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
 {
 	barrier();
 	__clear_bit(nr, addr);
@@ -157,7 +161,8 @@
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __change_bit(int nr, volatile unsigned long *addr)
+static inline void
+__change_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	asm volatile("btc %1,%0" : ADDR : "Ir" (nr));
 }
@@ -171,7 +176,8 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void change_bit(int nr, volatile unsigned long *addr)
+static inline void
+change_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "xorb %1,%0"
@@ -192,7 +198,8 @@
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int
+test_and_set_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -210,7 +217,7 @@
  * This is the same as test_and_set_bit on x86.
  */
 static __always_inline int
-test_and_set_bit_lock(int nr, volatile unsigned long *addr)
+test_and_set_bit_lock(unsigned long nr, volatile unsigned long *addr)
 {
 	return test_and_set_bit(nr, addr);
 }
@@ -224,7 +231,8 @@
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int
+__test_and_set_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -243,7 +251,8 @@
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int
+test_and_clear_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -263,7 +272,8 @@
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int
+__test_and_clear_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -275,7 +285,8 @@
 }
 
 /* WARNING: non atomic and it can be reordered! */
-static inline int __test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int
+__test_and_change_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -295,7 +306,8 @@
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int
+test_and_change_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -306,13 +318,15 @@
 	return oldbit;
 }
 
-static __always_inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
+static __always_inline int
+constant_test_bit(unsigned long nr, const volatile unsigned long *addr)
 {
 	return ((1UL << (nr % BITS_PER_LONG)) &
 		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
 }
 
-static inline int variable_test_bit(int nr, volatile const unsigned long *addr)
+static inline int
+variable_test_bit(unsigned long nr, volatile const unsigned long *addr)
 {
 	int oldbit;
 
diff -Nru a/arch/x86/include/asm/sync_bitops.h b/arch/x86/include/asm/sync_bitops.h
--- a/arch/x86/include/asm/sync_bitops.h	2009-02-13 15:31:30.000000000 -0800
+++ b/arch/x86/include/asm/sync_bitops.h	2009-02-15 18:19:39.788158209 -0800
@@ -26,7 +26,8 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void sync_set_bit(int nr, volatile unsigned long *addr)
+static inline void
+sync_set_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	asm volatile("lock; btsl %1,%0"
 		     : "+m" (ADDR)
@@ -44,7 +45,8 @@
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static inline void sync_clear_bit(int nr, volatile unsigned long *addr)
+static inline void
+sync_clear_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	asm volatile("lock; btrl %1,%0"
 		     : "+m" (ADDR)
@@ -61,7 +63,8 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void sync_change_bit(int nr, volatile unsigned long *addr)
+static inline void
+sync_change_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	asm volatile("lock; btcl %1,%0"
 		     : "+m" (ADDR)
@@ -77,7 +80,8 @@
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int sync_test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int
+sync_test_and_set_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -95,7 +99,8 @@
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int sync_test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int
+sync_test_and_clear_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -113,7 +118,8 @@
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int sync_test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int
+sync_test_and_change_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
