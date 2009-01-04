Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbZADXgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbZADXgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbZADXf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:35:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56841 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbZADXf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:35:26 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200901051236.281008835@firstfloor.org>
In-Reply-To: <200901051236.281008835@firstfloor.org>
To: akpm@linux-foundation.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/5] Mark complex bitops.h inlines as __always_inline
Message-Id: <20090104233640.6A7453E6653@basil.firstfloor.org>
Date: Mon,  5 Jan 2009 00:36:40 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hugh Dickins noticed that older gcc versions when the kernel
is built for code size didn't inline some of the bitops.

Mark all complex x86 bitops that have more than a single
asm statement or two as always inline to avoid this problem.

Probably should be done for other architectures too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/bitops.h      |   15 +++++++++++----
 include/asm-generic/bitops/__ffs.h |    2 +-
 include/asm-generic/bitops/__fls.h |    2 +-
 include/asm-generic/bitops/fls.h   |    2 +-
 include/asm-generic/bitops/fls64.h |    4 ++--
 5 files changed, 16 insertions(+), 9 deletions(-)

Index: linux-2.6.28-test/arch/x86/include/asm/bitops.h
===================================================================
--- linux-2.6.28-test.orig/arch/x86/include/asm/bitops.h	2008-10-24 13:34:40.000000000 +0200
+++ linux-2.6.28-test/arch/x86/include/asm/bitops.h	2009-01-02 16:01:00.000000000 +0100
@@ -3,6 +3,9 @@
 
 /*
  * Copyright 1992, Linus Torvalds.
+ *
+ * Note: inlines with more than a single statement should be marked
+ * __always_inline to avoid problems with older gcc's inlining heuristics.
  */
 
 #ifndef _LINUX_BITOPS_H
@@ -53,7 +56,8 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void set_bit(unsigned int nr, volatile unsigned long *addr)
+static __always_inline void
+set_bit(unsigned int nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "orb %1,%0"
@@ -90,7 +94,8 @@
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static inline void clear_bit(int nr, volatile unsigned long *addr)
+static __always_inline void
+clear_bit(int nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "andb %1,%0"
@@ -196,7 +201,8 @@
  *
  * This is the same as test_and_set_bit on x86.
  */
-static inline int test_and_set_bit_lock(int nr, volatile unsigned long *addr)
+static __always_inline int
+test_and_set_bit_lock(int nr, volatile unsigned long *addr)
 {
 	return test_and_set_bit(nr, addr);
 }
@@ -292,7 +298,8 @@
 	return oldbit;
 }
 
-static inline int constant_test_bit(int nr, const volatile unsigned long *addr)
+static __always_inline int
+constant_test_bit(int nr, const volatile unsigned long *addr)
 {
 	return ((1UL << (nr % BITS_PER_LONG)) &
 		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
Index: linux-2.6.28-test/include/asm-generic/bitops/__ffs.h
===================================================================
--- linux-2.6.28-test.orig/include/asm-generic/bitops/__ffs.h	2006-04-03 16:06:13.000000000 +0200
+++ linux-2.6.28-test/include/asm-generic/bitops/__ffs.h	2009-01-02 16:01:00.000000000 +0100
@@ -9,7 +9,7 @@
  *
  * Undefined if no bit exists, so code should check against 0 first.
  */
-static inline unsigned long __ffs(unsigned long word)
+static __always_inline unsigned long __ffs(unsigned long word)
 {
 	int num = 0;
 
Index: linux-2.6.28-test/include/asm-generic/bitops/__fls.h
===================================================================
--- linux-2.6.28-test.orig/include/asm-generic/bitops/__fls.h	2008-05-08 12:56:05.000000000 +0200
+++ linux-2.6.28-test/include/asm-generic/bitops/__fls.h	2009-01-02 16:01:00.000000000 +0100
@@ -9,7 +9,7 @@
  *
  * Undefined if no set bit exists, so code should check against 0 first.
  */
-static inline unsigned long __fls(unsigned long word)
+static __always_inline unsigned long __fls(unsigned long word)
 {
 	int num = BITS_PER_LONG - 1;
 
Index: linux-2.6.28-test/include/asm-generic/bitops/fls.h
===================================================================
--- linux-2.6.28-test.orig/include/asm-generic/bitops/fls.h	2006-04-03 16:06:13.000000000 +0200
+++ linux-2.6.28-test/include/asm-generic/bitops/fls.h	2009-01-02 16:01:00.000000000 +0100
@@ -9,7 +9,7 @@
  * Note fls(0) = 0, fls(1) = 1, fls(0x80000000) = 32.
  */
 
-static inline int fls(int x)
+static __always_inline int fls(int x)
 {
 	int r = 32;
 
Index: linux-2.6.28-test/include/asm-generic/bitops/fls64.h
===================================================================
--- linux-2.6.28-test.orig/include/asm-generic/bitops/fls64.h	2008-05-08 12:56:05.000000000 +0200
+++ linux-2.6.28-test/include/asm-generic/bitops/fls64.h	2009-01-02 16:01:00.000000000 +0100
@@ -15,7 +15,7 @@
  * at position 64.
  */
 #if BITS_PER_LONG == 32
-static inline int fls64(__u64 x)
+static __always_inline int fls64(__u64 x)
 {
 	__u32 h = x >> 32;
 	if (h)
@@ -23,7 +23,7 @@
 	return fls(x);
 }
 #elif BITS_PER_LONG == 64
-static inline int fls64(__u64 x)
+static __always_inline int fls64(__u64 x)
 {
 	if (x == 0)
 		return 0;
