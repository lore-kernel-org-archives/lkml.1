Return-Path: <linux-kernel-owner+w=401wt.eu-S1759907AbYD2KBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907AbYD2KBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYD2KBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:01:35 -0400
Received: from www.tglx.de ([62.245.132.106]:37139 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbYD2KBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:01:34 -0400
Date: Tue, 29 Apr 2008 12:01:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: [PATCH] bitops: remove "optimizations"
In-Reply-To: <alpine.LFD.1.10.0804281233090.3119@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0804291141580.3261@apollo.tec.linutronix.de>
References: <1209327591.14173.74.camel@brick> <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org> <alpine.LFD.1.10.0804281534530.3261@apollo.tec.linutronix.de> <alpine.LFD.1.10.0804280924270.3119@woody.linux-foundation.org>
 <alpine.LFD.1.10.0804281845250.3261@apollo.tec.linutronix.de> <alpine.LFD.1.10.0804280953570.3119@woody.linux-foundation.org> <alpine.LFD.1.10.0804282038160.3261@apollo.tec.linutronix.de> <alpine.LFD.1.10.0804281233090.3119@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mapsize optimizations which were moved from x86 to the generic
code in commit 64970b68d2b3ed32b964b0b30b1b98518fde388e increased the
binary size on non x86 architectures.

Looking into the real effects of the "optimizations" it turned out
that they are not used in find_next_bit() and find_next_zero_bit().

The ones in find_first_bit() and find_first_zero_bit() are used in a
couple of places but none of them is a real hot path.

Remove the "optimizations" all together and call the library functions
unconditionally.

Boot-tested on x86 and compile tested on every cross compiler I have.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/bitops.h |  115 +++++--------------------------------------------
 lib/find_next_bit.c    |   22 ++++-----
 2 files changed, 22 insertions(+), 115 deletions(-)

Index: linux-2.6/include/linux/bitops.h
===================================================================
--- linux-2.6.orig/include/linux/bitops.h
+++ linux-2.6/include/linux/bitops.h
@@ -114,8 +114,6 @@ static inline unsigned fls_long(unsigned
 
 #ifdef __KERNEL__
 #ifdef CONFIG_GENERIC_FIND_FIRST_BIT
-extern unsigned long __find_first_bit(const unsigned long *addr,
-		unsigned long size);
 
 /**
  * find_first_bit - find the first set bit in a memory region
@@ -124,28 +122,8 @@ extern unsigned long __find_first_bit(co
  *
  * Returns the bit number of the first set bit.
  */
-static __always_inline unsigned long
-find_first_bit(const unsigned long *addr, unsigned long size)
-{
-	/* Avoid a function call if the bitmap size is a constant */
-	/* and not bigger than BITS_PER_LONG. */
-
-	/* insert a sentinel so that __ffs returns size if there */
-	/* are no set bits in the bitmap */
-	if (__builtin_constant_p(size) && (size < BITS_PER_LONG))
-		return __ffs((*addr) | (1ul << size));
-
-	/* the result of __ffs(0) is undefined, so it needs to be */
-	/* handled separately */
-	if (__builtin_constant_p(size) && (size == BITS_PER_LONG))
-		return ((*addr) == 0) ? BITS_PER_LONG : __ffs(*addr);
-
-	/* size is not constant or too big */
-	return __find_first_bit(addr, size);
-}
-
-extern unsigned long __find_first_zero_bit(const unsigned long *addr,
-		unsigned long size);
+extern unsigned long find_first_bit(const unsigned long *addr,
+				    unsigned long size);
 
 /**
  * find_first_zero_bit - find the first cleared bit in a memory region
@@ -154,31 +132,12 @@ extern unsigned long __find_first_zero_b
  *
  * Returns the bit number of the first cleared bit.
  */
-static __always_inline unsigned long
-find_first_zero_bit(const unsigned long *addr, unsigned long size)
-{
-	/* Avoid a function call if the bitmap size is a constant */
-	/* and not bigger than BITS_PER_LONG. */
-
-	/* insert a sentinel so that __ffs returns size if there */
-	/* are no set bits in the bitmap */
-	if (__builtin_constant_p(size) && (size < BITS_PER_LONG)) {
-		return __ffs(~(*addr) | (1ul << size));
-	}
-
-	/* the result of __ffs(0) is undefined, so it needs to be */
-	/* handled separately */
-	if (__builtin_constant_p(size) && (size == BITS_PER_LONG))
-		return (~(*addr) == 0) ? BITS_PER_LONG : __ffs(~(*addr));
-
-	/* size is not constant or too big */
-	return __find_first_zero_bit(addr, size);
-}
+extern unsigned long find_first_zero_bit(const unsigned long *addr,
+					 unsigned long size);
+
 #endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
 #ifdef CONFIG_GENERIC_FIND_NEXT_BIT
-extern unsigned long __find_next_bit(const unsigned long *addr,
-		unsigned long size, unsigned long offset);
 
 /**
  * find_next_bit - find the next set bit in a memory region
@@ -186,36 +145,8 @@ extern unsigned long __find_next_bit(con
  * @offset: The bitnumber to start searching at
  * @size: The bitmap size in bits
  */
-static __always_inline unsigned long
-find_next_bit(const unsigned long *addr, unsigned long size,
-		unsigned long offset)
-{
-	unsigned long value;
-
-	/* Avoid a function call if the bitmap size is a constant */
-	/* and not bigger than BITS_PER_LONG. */
-
-	/* insert a sentinel so that __ffs returns size if there */
-	/* are no set bits in the bitmap */
-	if (__builtin_constant_p(size) && (size < BITS_PER_LONG)) {
-		value = (*addr) & ((~0ul) << offset);
-		value |= (1ul << size);
-		return __ffs(value);
-	}
-
-	/* the result of __ffs(0) is undefined, so it needs to be */
-	/* handled separately */
-	if (__builtin_constant_p(size) && (size == BITS_PER_LONG)) {
-		value = (*addr) & ((~0ul) << offset);
-		return (value == 0) ? BITS_PER_LONG : __ffs(value);
-	}
-
-	/* size is not constant or too big */
-	return __find_next_bit(addr, size, offset);
-}
-
-extern unsigned long __find_next_zero_bit(const unsigned long *addr,
-		unsigned long size, unsigned long offset);
+extern unsigned long find_next_bit(const unsigned long *addr,
+				   unsigned long size, unsigned long offset);
 
 /**
  * find_next_zero_bit - find the next cleared bit in a memory region
@@ -223,33 +154,11 @@ extern unsigned long __find_next_zero_bi
  * @offset: The bitnumber to start searching at
  * @size: The bitmap size in bits
  */
-static __always_inline unsigned long
-find_next_zero_bit(const unsigned long *addr, unsigned long size,
-		unsigned long offset)
-{
-	unsigned long value;
-
-	/* Avoid a function call if the bitmap size is a constant */
-	/* and not bigger than BITS_PER_LONG. */
-
-	/* insert a sentinel so that __ffs returns size if there */
-	/* are no set bits in the bitmap */
-	if (__builtin_constant_p(size) && (size < BITS_PER_LONG)) {
-		value = (~(*addr)) & ((~0ul) << offset);
-		value |= (1ul << size);
-		return __ffs(value);
-	}
-
-	/* the result of __ffs(0) is undefined, so it needs to be */
-	/* handled separately */
-	if (__builtin_constant_p(size) && (size == BITS_PER_LONG)) {
-		value = (~(*addr)) & ((~0ul) << offset);
-		return (value == 0) ? BITS_PER_LONG : __ffs(value);
-	}
-
-	/* size is not constant or too big */
-	return __find_next_zero_bit(addr, size, offset);
-}
+
+extern unsigned long find_next_zero_bit(const unsigned long *addr,
+					unsigned long size,
+					unsigned long offset);
+
 #endif /* CONFIG_GENERIC_FIND_NEXT_BIT */
 #endif /* __KERNEL__ */
 #endif
Index: linux-2.6/lib/find_next_bit.c
===================================================================
--- linux-2.6.orig/lib/find_next_bit.c
+++ linux-2.6/lib/find_next_bit.c
@@ -20,8 +20,8 @@
 /*
  * Find the next set bit in a memory region.
  */
-unsigned long __find_next_bit(const unsigned long *addr,
-		unsigned long size, unsigned long offset)
+unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
+			    unsigned long offset)
 {
 	const unsigned long *p = addr + BITOP_WORD(offset);
 	unsigned long result = offset & ~(BITS_PER_LONG-1);
@@ -58,14 +58,14 @@ found_first:
 found_middle:
 	return result + __ffs(tmp);
 }
-EXPORT_SYMBOL(__find_next_bit);
+EXPORT_SYMBOL(find_next_bit);
 
 /*
  * This implementation of find_{first,next}_zero_bit was stolen from
  * Linus' asm-alpha/bitops.h.
  */
-unsigned long __find_next_zero_bit(const unsigned long *addr,
-		unsigned long size, unsigned long offset)
+unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
+				 unsigned long offset)
 {
 	const unsigned long *p = addr + BITOP_WORD(offset);
 	unsigned long result = offset & ~(BITS_PER_LONG-1);
@@ -102,15 +102,14 @@ found_first:
 found_middle:
 	return result + ffz(tmp);
 }
-EXPORT_SYMBOL(__find_next_zero_bit);
+EXPORT_SYMBOL(find_next_zero_bit);
 #endif /* CONFIG_GENERIC_FIND_NEXT_BIT */
 
 #ifdef CONFIG_GENERIC_FIND_FIRST_BIT
 /*
  * Find the first set bit in a memory region.
  */
-unsigned long __find_first_bit(const unsigned long *addr,
-		unsigned long size)
+unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
 {
 	const unsigned long *p = addr;
 	unsigned long result = 0;
@@ -131,13 +130,12 @@ unsigned long __find_first_bit(const uns
 found:
 	return result + __ffs(tmp);
 }
-EXPORT_SYMBOL(__find_first_bit);
+EXPORT_SYMBOL(find_first_bit);
 
 /*
  * Find the first cleared bit in a memory region.
  */
-unsigned long __find_first_zero_bit(const unsigned long *addr,
-		unsigned long size)
+unsigned long find_first_zero_bit(const unsigned long *addr, unsigned long size)
 {
 	const unsigned long *p = addr;
 	unsigned long result = 0;
@@ -158,7 +156,7 @@ unsigned long __find_first_zero_bit(cons
 found:
 	return result + ffz(tmp);
 }
-EXPORT_SYMBOL(__find_first_zero_bit);
+EXPORT_SYMBOL(find_first_zero_bit);
 #endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
 #ifdef __BIG_ENDIAN
