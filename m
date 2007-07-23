Return-Path: <linux-kernel-owner+w=401wt.eu-S1763242AbXGWQEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763242AbXGWQEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758816AbXGWQET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:04:19 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:53096 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757953AbXGWQES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:04:18 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jul 2007 21:35:33 +0530
Message-Id: <20070723160533.22137.69966.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
Subject: [PATCH 1/8] i386: bitops: Update/correct comments
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

[1/8] i386: bitops: Update/correct comments

Just trying to standardize the look of comments for various functions of the
bitops API, removed some trailing whitespace here and there, give different
kernel-doc description to the atomic functions and their corresponding
unlocked variants, remove/explicitly mention what is inapplicable/applicable
to i386, add kernel-doc comments to functions that lacked them already, and
other janitorial work. Only comments touched in this patch.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: David Howells <dhowells@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>

---

 include/asm-i386/bitops.h |  123 +++++++++++++++++++++++++++++++-------------
 1 files changed, 86 insertions(+), 37 deletions(-)

diff --git a/include/asm-i386/bitops.h b/include/asm-i386/bitops.h
index a20fe98..ba8e4bb 100644
--- a/include/asm-i386/bitops.h
+++ b/include/asm-i386/bitops.h
@@ -10,10 +10,20 @@
 
 /*
  * These have to be done with inline assembly: that way the bit-setting
- * is guaranteed to be atomic. All bit operations return 0 if the bit
- * was cleared before the operation and != 0 if it was not.
+ * is guaranteed to be atomic. All bit test operations return an int type:
+ * 0 if the bit was cleared before the operation and != 0 if it was not.
  *
- * bit 0 is the LSB of addr; bit 32 is the LSB of (addr+1).
+ * However, the operand itself is always of unsigned long type, so care
+ * must be taken to ensure that the int type return of bit test operations
+ * for the != 0 case does not get truncate the '1' bits. This is not an
+ * issue on i386 where sizeof(int) == sizeof(unsigned long), but we avoid
+ * this pitfall anyway by returning with all 1's or LSB set in this case.
+ *
+ * bit 0 is the LSB of addr; bit 31 is the MSB.
+ *
+ * But note that all functions that take a bit-number argument allow it
+ * to be arbitrarily large; these operations are not restricted to acting
+ * on single-dword quantities.
  */
 
 #define ADDR (*(volatile long *) addr)
@@ -23,15 +33,10 @@
  * @nr: the bit to set
  * @addr: the address to start counting from
  *
- * This function is atomic and may not be reordered.  See __set_bit()
- * if you do not require the atomic guarantees.
+ * set_bit() is atomic and cannot be reordered. On the x86, this includes
+ * an implicit memory barrier.
  *
- * Note: there are no guarantees that this function will not be reordered
- * on non x86 architectures, so if you are writing portable code,
- * make sure not to rely on its reordering guarantees.
- *
- * Note that @nr may be almost arbitrarily large; this function is not
- * restricted to acting on a single-word quantity.
+ * See __set_bit() if you do not require the atomic guarantees.
  */
 static inline void set_bit(int nr, volatile unsigned long * addr)
 {
@@ -49,6 +54,9 @@ static inline void set_bit(int nr, volatile unsigned long * addr)
  * Unlike set_bit(), this function is non-atomic and may be reordered.
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
+ *
+ * This is a fast and unlocked operation, and only suitable for callers
+ * that already implement higher-level locking to protect access.
  */
 static inline void __set_bit(int nr, volatile unsigned long * addr)
 {
@@ -59,14 +67,14 @@ static inline void __set_bit(int nr, volatile unsigned long * addr)
 }
 
 /**
- * clear_bit - Clears a bit in memory
+ * clear_bit - Atomically clear a bit in memory
  * @nr: Bit to clear
  * @addr: Address to start counting from
  *
- * clear_bit() is atomic and may not be reordered.  However, it does
- * not contain a memory barrier, so if it is used for locking purposes,
- * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
- * in order to ensure changes are visible on other processors.
+ * clear_bit() is atomic and cannot be reordered. On the x86, this includes
+ * an implicit memory barrier.
+ *
+ * See __clear_bit() if you do not require the atomic guarantees.
  */
 static inline void clear_bit(int nr, volatile unsigned long * addr)
 {
@@ -76,6 +84,18 @@ static inline void clear_bit(int nr, volatile unsigned long * addr)
 		:"Ir" (nr));
 }
 
+/**
+ * __clear_bit - Clear a bit in memory
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * Unlike clear_bit(), this function is non-atomic and may be reordered.
+ * It it's called on the same region of memory simultaneously, the effect
+ * may be that only one operation succeeds.
+ *
+ * This is a fast and unlocked operation, and only suitable for callers
+ * that already implement higher-level locking to protect access.
+ */
 static inline void __clear_bit(int nr, volatile unsigned long * addr)
 {
 	__asm__ __volatile__(
@@ -83,6 +103,11 @@ static inline void __clear_bit(int nr, volatile unsigned long * addr)
 		:"+m" (ADDR)
 		:"Ir" (nr));
 }
+
+/*
+ * Bit operations are already serializing on x86.
+ * These must still be defined here for API completeness.
+ */
 #define smp_mb__before_clear_bit()	barrier()
 #define smp_mb__after_clear_bit()	barrier()
 
@@ -94,6 +119,9 @@ static inline void __clear_bit(int nr, volatile unsigned long * addr)
  * Unlike change_bit(), this function is non-atomic and may be reordered.
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
+ *
+ * This is a fast and unlocked operation, and only suitable for callers
+ * that already implement higher-level locking to protect access.
  */
 static inline void __change_bit(int nr, volatile unsigned long * addr)
 {
@@ -104,14 +132,14 @@ static inline void __change_bit(int nr, volatile unsigned long * addr)
 }
 
 /**
- * change_bit - Toggle a bit in memory
+ * change_bit - Atomically toggle a bit in memory
  * @nr: Bit to change
  * @addr: Address to start counting from
  *
- * change_bit() is atomic and may not be reordered. It may be
- * reordered on other architectures than x86.
- * Note that @nr may be almost arbitrarily large; this function is not
- * restricted to acting on a single-word quantity.
+ * change_bit() is atomic and cannot be reordered. On the x86, this includes
+ * an implicit memory barrier.
+ *
+ * See __change_bit() if you do not require the atomic guarantees.
  */
 static inline void change_bit(int nr, volatile unsigned long * addr)
 {
@@ -122,13 +150,14 @@ static inline void change_bit(int nr, volatile unsigned long * addr)
 }
 
 /**
- * test_and_set_bit - Set a bit and return its old value
+ * test_and_set_bit - Atomically set a bit and return its old value
  * @nr: Bit to set
  * @addr: Address to count from
  *
- * This operation is atomic and cannot be reordered.  
- * It may be reordered on other architectures than x86.
- * It also implies a memory barrier.
+ * test_and_set_bit() is atomic and cannot be reordered. On the x86, this
+ * includes an implicit memory barrier.
+ *
+ * See __test_and_set_bit() if you do not require the atomic guarantees.
  */
 static inline int test_and_set_bit(int nr, volatile unsigned long * addr)
 {
@@ -146,9 +175,12 @@ static inline int test_and_set_bit(int nr, volatile unsigned long * addr)
  * @nr: Bit to set
  * @addr: Address to count from
  *
- * This operation is non-atomic and can be reordered.  
+ * Unlike test_and_set_bit(), this function is non-atomic and may be reordered.
  * If two examples of this operation race, one can appear to succeed
- * but actually fail.  You must protect multiple accesses with a lock.
+ * but actually fail.
+ *
+ * This is a fast and unlocked operation, and only suitable for callers
+ * that already implement higher-level locking to protect access.
  */
 static inline int __test_and_set_bit(int nr, volatile unsigned long * addr)
 {
@@ -162,13 +194,14 @@ static inline int __test_and_set_bit(int nr, volatile unsigned long * addr)
 }
 
 /**
- * test_and_clear_bit - Clear a bit and return its old value
+ * test_and_clear_bit - Atomically clear a bit and return its old value
  * @nr: Bit to clear
  * @addr: Address to count from
  *
- * This operation is atomic and cannot be reordered.
- * It can be reorderdered on other architectures other than x86.
- * It also implies a memory barrier.
+ * test_and_clear_bit() is atomic and cannot be reordered. On the x86, this
+ * includes an implicit memory barrier.
+ *
+ * See __test_and_clear_bit() if you do not require the atomic guarantees.
  */
 static inline int test_and_clear_bit(int nr, volatile unsigned long * addr)
 {
@@ -186,9 +219,12 @@ static inline int test_and_clear_bit(int nr, volatile unsigned long * addr)
  * @nr: Bit to clear
  * @addr: Address to count from
  *
- * This operation is non-atomic and can be reordered.  
+ * Unlike test_and_clear_bit(), this function is non-atomic and may be reordered.
  * If two examples of this operation race, one can appear to succeed
- * but actually fail.  You must protect multiple accesses with a lock.
+ * but actually fail.
+ *
+ * This is a fast and unlocked operation, and only suitable for callers
+ * that already implement higher-level locking to protect access.
  */
 static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
@@ -201,7 +237,18 @@ static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
 	return oldbit;
 }
 
-/* WARNING: non atomic and it can be reordered! */
+/**
+ * __test_and_change_bit - Change a bit and return its old value
+ * @nr: Bit to clear
+ * @addr: Address to count from
+ *
+ * Unlike test_and_change_bit(), this function is non-atomic and may be reordered.
+ * If two examples of this operation race, one can appear to succeed
+ * but actually fail.
+ *
+ * This is a fast and unlocked operation, and only suitable for callers
+ * that already implement higher-level locking to protect access.
+ */
 static inline int __test_and_change_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
@@ -214,12 +261,14 @@ static inline int __test_and_change_bit(int nr, volatile unsigned long *addr)
 }
 
 /**
- * test_and_change_bit - Change a bit and return its old value
+ * test_and_change_bit - Atomically change a bit and return its old value
  * @nr: Bit to change
  * @addr: Address to count from
  *
- * This operation is atomic and cannot be reordered.  
- * It also implies a memory barrier.
+ * test_and_change_bit() is atomic and cannot be reordered. On the x86, this
+ * includes an implicit memory barrier.
+ *
+ * See __test_and_change_bit() if you do not require the atomic guarantees.
  */
 static inline int test_and_change_bit(int nr, volatile unsigned long* addr)
 {
