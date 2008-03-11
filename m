Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbYCKPUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbYCKPUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 11:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbYCKPUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 11:20:07 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:5676 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbYCKPUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 11:20:05 -0400
Date: Tue, 11 Mar 2008 16:17:19 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Optimize find_next_(zero_)bit for small constant-size bitmaps
Message-ID: <20080311151719.GA15313@mailshack.com>
References: <20080309200103.GA895@mailshack.com> <20080309201152.GB28454@elte.hu> <1205094704.6430.1241420859@webmail.messagingengine.com> <20080309205132.GA9021@elte.hu> <20080310231724.GA8370@mailshack.com> <20080311095631.GT25110@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311095631.GT25110@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Tue, 11 Mar 2008 16:19:40 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.73; VDF: 7.0.3.16; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: Optimize find_next_(zero_)bit for small constant-size bitmaps.

This moves an optimization for searching constant-sized small 
bitmaps form x86_64-specific to generic code.

On an i386 defconfig (the x86#testing one), the size of vmlinux hardly
changes with this applied. I have observed only four places where this
optimization avoids a call into find_next_bit:

In the functions return_unused_surplus_pages, alloc_fresh_huge_page,
and adjust_pool_surplus, this patch avoids a call for a 1-bit bitmap.
In __next_cpu a call is avoided for a 32-bit bitmap. That's it.

On x86_64, 52 locations are optimized with a minimal increase in
code size:

Current #testing defconfig: 
	146 x bsf, 27 x find_next_*bit
   text    data     bss     dec     hex filename
   5392637  846592  724424 6963653  6a41c5 vmlinux

After removing the x86_64 specific optimization for find_next_*bit:
	94 x bsf, 79 x find_next_*bit
   text    data     bss     dec     hex filename
   5392358  846592  724424 6963374  6a40ae vmlinux

After this patch (making the optimization generic):
	146 x bsf, 27 x find_next_*bit
   text    data     bss     dec     hex filename
   5392396  846592  724424 6963412  6a40d4 vmlinux

---

Hi Ingo,

I have now tested (in user-space) the one-long-versions of the 
find_next_(zero_)bit in the patch. They give the expected
results.

> > +#ifdef CONFIG_GENERIC_FIND_NEXT_BIT
> > +unsigned long __find_next_bit(const unsigned long *addr,
> > +		unsigned long size, unsigned long offset);
> > +
> > +static __always_inline unsigned long
> > +find_next_bit(const unsigned long *addr, unsigned long size,
> > +		unsigned long offset)
> 
> > +#endif /* CONFIG_GENERIC_FIND_NEXT_BIT */
> 
> there should be an #else here i think, which maps find_next_bit to 
> __find_next_bit / etc.

No, that is intentional: architectures are expected to either set
CONFIG_GENERIC_FIND_NEXT_BIT, or provide their own implementation
of find_next_bit.

An alternative would be to have all architectures providing
__find_next_bit/__find_next_zero_bit and do the optimization
unconditionally.

> > +unsigned long __find_next_bit(const unsigned long *addr,
> > +		unsigned long size, unsigned long offset);
> 
> should be explicitly "extern", so that we see that it's a prototype 
> declaration.

ok.

This version runs fine on qemu.

Greetings,
	Alexander

diff --git a/include/asm-x86/bitops.h b/include/asm-x86/bitops.h
index 7fbf93a..1a23ce1 100644
--- a/include/asm-x86/bitops.h
+++ b/include/asm-x86/bitops.h
@@ -312,12 +312,6 @@ static int test_bit(int nr, const volatile unsigned long *addr);
 
 #undef ADDR
 
-unsigned long find_next_bit(const unsigned long *addr,
-		unsigned long size, unsigned long offset);
-unsigned long find_next_zero_bit(const unsigned long *addr,
-		unsigned long size, unsigned long offset);
-
-
 #ifdef CONFIG_X86_32
 # include "bitops_32.h"
 #else
diff --git a/include/asm-x86/bitops_64.h b/include/asm-x86/bitops_64.h
index 40bf0f8..87e1a17 100644
--- a/include/asm-x86/bitops_64.h
+++ b/include/asm-x86/bitops_64.h
@@ -20,21 +20,11 @@ static inline long __scanbit(unsigned long val, unsigned long max)
   (__scanbit(*(unsigned long *)addr,(size))) : \
   find_first_bit(addr,size)))
 
-#define find_next_bit(addr,size,off) \
-((__builtin_constant_p(size) && (size) <= BITS_PER_LONG ? 	  \
-  ((off) + (__scanbit((*(unsigned long *)addr) >> (off),(size)-(off)))) : \
-	find_next_bit(addr,size,off)))
-
 #define find_first_zero_bit(addr,size) \
 ((__builtin_constant_p(size) && (size) <= BITS_PER_LONG ? \
   (__scanbit(~*(unsigned long *)addr,(size))) : \
   	find_first_zero_bit(addr,size)))
 	
-#define find_next_zero_bit(addr,size,off) \
-((__builtin_constant_p(size) && (size) <= BITS_PER_LONG ? 	  \
-  ((off)+(__scanbit(~(((*(unsigned long *)addr)) >> (off)),(size)-(off)))) : \
-	find_next_zero_bit(addr,size,off)))
-
 static inline void set_bit_string(unsigned long *bitmap, unsigned long i, 
 				  int len) 
 { 
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 69c1edb..15360f9 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -72,4 +72,81 @@ static inline unsigned fls_long(unsigned long l)
 	return fls64(l);
 }
 
+#ifdef __KERNEL__
+#ifdef CONFIG_GENERIC_FIND_NEXT_BIT
+extern unsigned long __find_next_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset);
+
+/**
+ * find_next_bit - find the next set bit in a memory region
+ * @addr: The address to base the search on
+ * @offset: The bitnumber to start searching at
+ * @size: The bitmap size in bits
+ */
+static __always_inline unsigned long
+find_next_bit(const unsigned long *addr, unsigned long size,
+		unsigned long offset)
+{
+	unsigned long value;
+
+	/* Avoid a function call if the bitmap size is a constant */
+	/* and not bigger than BITS_PER_LONG. */
+
+	/* insert a sentinel so that __ffs returns size if there */
+	/* are no set bits in the bitmap */
+	if (__builtin_constant_p(size) && (size < BITS_PER_LONG)) {
+		value = (*addr) & ((~0ul) << offset);
+		value |= (1ul << size);
+		return __ffs(value);
+	}
+
+	/* the result of __ffs(0) is undefined, so it needs to be */
+	/* handled separately */
+	if (__builtin_constant_p(size) && (size == BITS_PER_LONG)) {
+		value = (*addr) & ((~0ul) << offset);
+		return (value == 0) ? BITS_PER_LONG : __ffs(value);
+	}
+
+	/* size is not constant or too big */
+	return __find_next_bit(addr, size, offset);
+}
+
+extern unsigned long __find_next_zero_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset);
+
+/**
+ * find_next_zero_bit - find the next cleared bit in a memory region
+ * @addr: The address to base the search on
+ * @offset: The bitnumber to start searching at
+ * @size: The bitmap size in bits
+ */
+static __always_inline unsigned long
+find_next_zero_bit(const unsigned long *addr, unsigned long size,
+		unsigned long offset)
+{
+	unsigned long value;
+
+	/* Avoid a function call if the bitmap size is a constant */
+	/* and not bigger than BITS_PER_LONG. */
+
+	/* insert a sentinel so that __ffs returns size if there */
+	/* are no set bits in the bitmap */
+	if (__builtin_constant_p(size) && (size < BITS_PER_LONG)) {
+		value = (~(*addr)) & ((~0ul) << offset);
+		value |= (1ul << size);
+		return __ffs(value);
+	}
+
+	/* the result of __ffs(0) is undefined, so it needs to be */
+	/* handled separately */
+	if (__builtin_constant_p(size) && (size == BITS_PER_LONG)) {
+		value = (~(*addr)) & ((~0ul) << offset);
+		return (value == 0) ? BITS_PER_LONG : __ffs(value);
+	}
+
+	/* size is not constant or too big */
+	return __find_next_zero_bit(addr, size, offset);
+}
+#endif /* CONFIG_GENERIC_FIND_NEXT_BIT */
+#endif /* __KERNEL__ */
 #endif
diff --git a/lib/find_next_bit.c b/lib/find_next_bit.c
index 5820e07..ce94c4c 100644
--- a/lib/find_next_bit.c
+++ b/lib/find_next_bit.c
@@ -15,17 +15,12 @@
 #include <asm/byteorder.h>
 
 #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
-#undef find_next_bit
-#undef find_next_zero_bit
-
-/**
- * find_next_bit - find the next set bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The maximum size to search
+
+/*
+ * Find the next set bit in a memory region.
  */
-unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
-		unsigned long offset)
+unsigned long __find_next_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset)
 {
 	const unsigned long *p = addr + BITOP_WORD(offset);
 	unsigned long result = offset & ~(BITS_PER_LONG-1);
@@ -62,15 +57,14 @@ found_first:
 found_middle:
 	return result + __ffs(tmp);
 }
-
-EXPORT_SYMBOL(find_next_bit);
+EXPORT_SYMBOL(__find_next_bit);
 
 /*
  * This implementation of find_{first,next}_zero_bit was stolen from
  * Linus' asm-alpha/bitops.h.
  */
-unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
-		unsigned long offset)
+unsigned long __find_next_zero_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset)
 {
 	const unsigned long *p = addr + BITOP_WORD(offset);
 	unsigned long result = offset & ~(BITS_PER_LONG-1);
@@ -107,8 +101,7 @@ found_first:
 found_middle:
 	return result + ffz(tmp);
 }
-
-EXPORT_SYMBOL(find_next_zero_bit);
+EXPORT_SYMBOL(__find_next_zero_bit);
 
 #ifdef __BIG_ENDIAN
 

