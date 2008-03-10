Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbYCJXUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbYCJXUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYCJXUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:20:05 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:9826 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYCJXUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:20:03 -0400
Date: Tue, 11 Mar 2008 00:17:24 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC/PATCH] x86: Optimize find_next_(zero_)bit for small constant-size bitmaps
Message-ID: <20080310231724.GA8370@mailshack.com>
References: <20080309200103.GA895@mailshack.com> <20080309201152.GB28454@elte.hu> <1205094704.6430.1241420859@webmail.messagingengine.com> <20080309205132.GA9021@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080309205132.GA9021@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Tue, 11 Mar 2008 00:19:39 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.73; VDF: 7.0.3.12; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: Optimize find_next_(zero_)bit for small constant-size bitmaps

NOTE: This is not well tested. I'm also quite unsure if this makes the 
pre-processor situation any better.

On an i386 defconfig (the x86#testing one), the size of vmlinux hardly
changes with this applied. I have observed only four places where this
optimization avoids a call into find_next_bit:

In the functions return_unused_surplus_pages, alloc_fresh_huge_page,
and adjust_pool_surplus, this patch avoids a call for a 1-bit bitmap.
In __next_cpu a call is avoided for a 32-bit bitmap. That's it.

On x86_64 I observed the following (I did not look closely yet, though).

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

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

> ok - but this needs to be solved in a cleaner way. That build-time 
> optimization needs to be pushed into generic code so that 32-bit x86 and 
> other architectures can make use of it as well. The lib/find_next_bit.c 
> functions should be named __find_next_bit() or so.
> 
> 	Ingo

I think this is what you had in mind? It seems to work.

Alternative implementation ideas? Comments? In particular: does
this break non-x86?

Greetings,
	Alexander

 include/asm-x86/bitops.h    |    4 +-
 include/asm-x86/bitops_64.h |   10 -------
 include/linux/bitops.h      |   60 +++++++++++++++++++++++++++++++++++++++++++
 lib/find_next_bit.c         |   10 +++----
 4 files changed, 66 insertions(+), 18 deletions(-)

diff --git a/include/asm-x86/bitops.h b/include/asm-x86/bitops.h
index 7fbf93a..cbbe329 100644
--- a/include/asm-x86/bitops.h
+++ b/include/asm-x86/bitops.h
@@ -312,9 +312,9 @@ static int test_bit(int nr, const volatile unsigned long *addr);
 
 #undef ADDR
 
-unsigned long find_next_bit(const unsigned long *addr,
+unsigned long __find_next_bit(const unsigned long *addr,
 		unsigned long size, unsigned long offset);
-unsigned long find_next_zero_bit(const unsigned long *addr,
+unsigned long __find_next_zero_bit(const unsigned long *addr,
 		unsigned long size, unsigned long offset);
 
 
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
index 69c1edb..ba78ca1 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -72,4 +72,64 @@ static inline unsigned fls_long(unsigned long l)
 	return fls64(l);
 }
 
+#ifdef __KERNEL__
+#ifdef CONFIG_GENERIC_FIND_NEXT_BIT
+unsigned long __find_next_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset);
+
+static __always_inline unsigned long
+find_next_bit(const unsigned long *addr, unsigned long size,
+		unsigned long offset)
+{
+	unsigned long value;
+
+	/* Here we would like to use a version of ffs that */
+	/* returns BITS_PER_LONG if its argument is zero. */
+	if (__builtin_constant_p(size) && (size == BITS_PER_LONG)) {
+		value = (*addr) & ((~0ul) << offset);
+		return (value == 0) ? BITS_PER_LONG : __ffs(value);
+	}
+
+	/* Less than BITS_PER_LONG: put in sentinel, then __ffs */
+	/* Here we would like to have a __set_bit/__ffs combo */
+	if (__builtin_constant_p(size) && (size < BITS_PER_LONG)) {
+		value = (*addr) & ((~0ul) << offset);
+		value |= (1ul << size);
+		return __ffs(value);
+	}
+
+	/* size not constant or too big */
+	return __find_next_bit(addr, size, offset);
+}
+
+unsigned long __find_next_zero_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset);
+
+static __always_inline unsigned long
+find_next_zero_bit(const unsigned long *addr, unsigned long size,
+		unsigned long offset)
+{
+	unsigned long value;
+
+	/* Here we would like to use a version of ffs that */
+	/* returns BITS_PER_LONG if its argument is zero. */
+	if (__builtin_constant_p(size) && (size == BITS_PER_LONG)) {
+		value = (~(*addr)) & ((~0ul) << offset);
+		return (value == 0) ? BITS_PER_LONG : __ffs(value);
+	}
+
+	/* Less than BITS_PER_LONG: put in sentinel, then __ffs */
+	/* Here we would like to have a __set_bit/__ffs combo. */
+	if (__builtin_constant_p(size) && (size < BITS_PER_LONG)) {
+		value = (~(*addr)) & ((~0ul) << offset);
+		value |= (1ul << size);
+		return __ffs(value);
+	}
+
+	/* size not constant or too big */
+	return __find_next_zero_bit(addr, size, offset);
+}
+
+#endif /* CONFIG_GENERIC_FIND_NEXT_BIT */
+#endif /* __KERNEL__ */
 #endif
diff --git a/lib/find_next_bit.c b/lib/find_next_bit.c
index 5820e07..5249f4a 100644
--- a/lib/find_next_bit.c
+++ b/lib/find_next_bit.c
@@ -15,8 +15,6 @@
 #include <asm/byteorder.h>
 
 #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
-#undef find_next_bit
-#undef find_next_zero_bit
 
 /**
  * find_next_bit - find the next set bit in a memory region
@@ -24,8 +22,8 @@
  * @offset: The bitnumber to start searching at
  * @size: The maximum size to search
  */
-unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
-		unsigned long offset)
+unsigned long __find_next_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset)
 {
 	const unsigned long *p = addr + BITOP_WORD(offset);
 	unsigned long result = offset & ~(BITS_PER_LONG-1);
@@ -69,8 +67,8 @@ EXPORT_SYMBOL(find_next_bit);
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

