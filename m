Return-Path: <linux-kernel-owner+w=401wt.eu-S1764057AbXGWQFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764057AbXGWQFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762819AbXGWQEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:04:32 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:53116 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762618AbXGWQEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:04:30 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jul 2007 21:35:48 +0530
Message-Id: <20070723160548.22137.66072.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
Subject: [PATCH 4/8] i386: bitops: Kill volatile-casting of memory addresses
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

[4/8] i386: bitops: Kill volatile-casting of memory addresses

All the occurrences of "volatile" that are used to qualify access to the
passed bit-string pointer/address must be removed, because "volatile" is
crazy, doesn't really work anyway, has nothing to do with locking and
atomicity, and is in general wholly unnecessary for these operations:

* In the case of the unlocked variants, we're not providing any guarantees
  whatsoever, so we want the caller to do any necessary locking surrounding
  the use of that function anyway.

* In case of the primitives where we *do* make locking/atomicity/reordering
  (three very different, but related, concepts) guarantees, we're doing that
  properly by using the lock instruction-prefix and "__asm__ __volatile__"
  anyway (and with "addr" always being constrained with "m" in the assembly,
  gcc doesn't bring it into a local register either).

So let's just kill the pointless use of volatile.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: David Howells <dhowells@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>

---

 include/asm-i386/bitops.h |   60 +++++++++++++++++++++------------------------
 1 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/include/asm-i386/bitops.h b/include/asm-i386/bitops.h
index d623fd9..0f5634b 100644
--- a/include/asm-i386/bitops.h
+++ b/include/asm-i386/bitops.h
@@ -26,8 +26,6 @@
  * on single-dword quantities.
  */
 
-#define ADDR (*(volatile long *) addr)
-
 /**
  * set_bit - Atomically set a bit in memory
  * @nr: the bit to set
@@ -38,11 +36,11 @@
  *
  * See __set_bit() if you do not require the atomic guarantees.
  */
-static inline void set_bit(int nr, volatile unsigned long * addr)
+static inline void set_bit(int nr, unsigned long *addr)
 {
 	__asm__ __volatile__( LOCK_PREFIX
 		"btsl %1,%0"
-		:"=m" (ADDR)
+		:"=m" (*addr)
 		:"r" (nr));
 }
 
@@ -58,11 +56,11 @@ static inline void set_bit(int nr, volatile unsigned long * addr)
  * This is a fast and unlocked operation, and only suitable for callers
  * that already implement higher-level locking to protect access.
  */
-static inline void __set_bit(int nr, volatile unsigned long * addr)
+static inline void __set_bit(int nr, unsigned long *addr)
 {
 	__asm__(
 		"btsl %1,%0"
-		:"=m" (ADDR)
+		:"=m" (*addr)
 		:"r" (nr));
 }
 
@@ -76,11 +74,11 @@ static inline void __set_bit(int nr, volatile unsigned long * addr)
  *
  * See __clear_bit() if you do not require the atomic guarantees.
  */
-static inline void clear_bit(int nr, volatile unsigned long * addr)
+static inline void clear_bit(int nr, unsigned long *addr)
 {
 	__asm__ __volatile__( LOCK_PREFIX
 		"btrl %1,%0"
-		:"=m" (ADDR)
+		:"=m" (*addr)
 		:"r" (nr));
 }
 
@@ -96,11 +94,11 @@ static inline void clear_bit(int nr, volatile unsigned long * addr)
  * This is a fast and unlocked operation, and only suitable for callers
  * that already implement higher-level locking to protect access.
  */
-static inline void __clear_bit(int nr, volatile unsigned long * addr)
+static inline void __clear_bit(int nr, unsigned long *addr)
 {
 	__asm__ __volatile__(
 		"btrl %1,%0"
-		:"=m" (ADDR)
+		:"=m" (*addr)
 		:"r" (nr));
 }
 
@@ -123,11 +121,11 @@ static inline void __clear_bit(int nr, volatile unsigned long * addr)
  * This is a fast and unlocked operation, and only suitable for callers
  * that already implement higher-level locking to protect access.
  */
-static inline void __change_bit(int nr, volatile unsigned long * addr)
+static inline void __change_bit(int nr, unsigned long *addr)
 {
 	__asm__ __volatile__(
 		"btcl %1,%0"
-		:"=m" (ADDR)
+		:"=m" (*addr)
 		:"r" (nr));
 }
 
@@ -141,11 +139,11 @@ static inline void __change_bit(int nr, volatile unsigned long * addr)
  *
  * See __change_bit() if you do not require the atomic guarantees.
  */
-static inline void change_bit(int nr, volatile unsigned long * addr)
+static inline void change_bit(int nr, unsigned long *addr)
 {
 	__asm__ __volatile__( LOCK_PREFIX
 		"btcl %1,%0"
-		:"=m" (ADDR)
+		:"=m" (*addr)
 		:"r" (nr));
 }
 
@@ -159,13 +157,13 @@ static inline void change_bit(int nr, volatile unsigned long * addr)
  *
  * See __test_and_set_bit() if you do not require the atomic guarantees.
  */
-static inline int test_and_set_bit(int nr, volatile unsigned long * addr)
+static inline int test_and_set_bit(int nr, unsigned long *addr)
 {
 	int oldbit;
 
 	__asm__ __volatile__( LOCK_PREFIX
 		"btsl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),"=m" (ADDR)
+		:"=r" (oldbit),"=m" (*addr)
 		:"r" (nr) : "memory");
 	return oldbit;
 }
@@ -182,13 +180,13 @@ static inline int test_and_set_bit(int nr, volatile unsigned long * addr)
  * This is a fast and unlocked operation, and only suitable for callers
  * that already implement higher-level locking to protect access.
  */
-static inline int __test_and_set_bit(int nr, volatile unsigned long * addr)
+static inline int __test_and_set_bit(int nr, unsigned long *addr)
 {
 	int oldbit;
 
 	__asm__(
 		"btsl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),"=m" (ADDR)
+		:"=r" (oldbit),"=m" (*addr)
 		:"r" (nr));
 	return oldbit;
 }
@@ -203,13 +201,13 @@ static inline int __test_and_set_bit(int nr, volatile unsigned long * addr)
  *
  * See __test_and_clear_bit() if you do not require the atomic guarantees.
  */
-static inline int test_and_clear_bit(int nr, volatile unsigned long * addr)
+static inline int test_and_clear_bit(int nr, unsigned long *addr)
 {
 	int oldbit;
 
 	__asm__ __volatile__( LOCK_PREFIX
 		"btrl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),"=m" (ADDR)
+		:"=r" (oldbit),"=m" (*addr)
 		:"r" (nr) : "memory");
 	return oldbit;
 }
@@ -226,13 +224,13 @@ static inline int test_and_clear_bit(int nr, volatile unsigned long * addr)
  * This is a fast and unlocked operation, and only suitable for callers
  * that already implement higher-level locking to protect access.
  */
-static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_clear_bit(int nr, unsigned long *addr)
 {
 	int oldbit;
 
 	__asm__(
 		"btrl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),"=m" (ADDR)
+		:"=r" (oldbit),"=m" (*addr)
 		:"r" (nr));
 	return oldbit;
 }
@@ -249,13 +247,13 @@ static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
  * This is a fast and unlocked operation, and only suitable for callers
  * that already implement higher-level locking to protect access.
  */
-static inline int __test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_change_bit(int nr, unsigned long *addr)
 {
 	int oldbit;
 
 	__asm__ __volatile__(
 		"btcl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),"=m" (ADDR)
+		:"=r" (oldbit),"=m" (*addr)
 		:"r" (nr) : "memory");
 	return oldbit;
 }
@@ -270,13 +268,13 @@ static inline int __test_and_change_bit(int nr, volatile unsigned long *addr)
  *
  * See __test_and_change_bit() if you do not require the atomic guarantees.
  */
-static inline int test_and_change_bit(int nr, volatile unsigned long* addr)
+static inline int test_and_change_bit(int nr, unsigned long *addr)
 {
 	int oldbit;
 
 	__asm__ __volatile__( LOCK_PREFIX
 		"btcl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),"=m" (ADDR)
+		:"=r" (oldbit),"=m" (*addr)
 		:"r" (nr) : "memory");
 	return oldbit;
 }
@@ -287,22 +285,22 @@ static inline int test_and_change_bit(int nr, volatile unsigned long* addr)
  * @nr: bit number to test
  * @addr: Address to start counting from
  */
-static int test_bit(int nr, const volatile void * addr);
+static int test_bit(int nr, const unsigned long *addr);
 #endif
 
-static __always_inline int constant_test_bit(int nr, const volatile unsigned long *addr)
+static __always_inline int constant_test_bit(int nr, const unsigned long *addr)
 {
 	return ((1UL << (nr & 31)) & (addr[nr >> 5])) != 0;
 }
 
-static inline int variable_test_bit(int nr, const volatile unsigned long * addr)
+static inline int variable_test_bit(int nr, const unsigned long *addr)
 {
 	int oldbit;
 
 	__asm__ __volatile__(
 		"btl %2,%1\n\tsbbl %0,%0"
 		:"=r" (oldbit)
-		:"m" (ADDR),"r" (nr));
+		:"m" (*addr),"r" (nr));
 	return oldbit;
 }
 
@@ -311,8 +309,6 @@ static inline int variable_test_bit(int nr, const volatile unsigned long * addr)
  constant_test_bit((nr),(addr)) : \
  variable_test_bit((nr),(addr)))
 
-#undef ADDR
-
 /**
  * find_first_zero_bit - find the first zero bit in a memory region
  * @addr: The address to start the search at
