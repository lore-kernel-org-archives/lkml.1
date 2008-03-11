Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbYCKPXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbYCKPXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 11:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbYCKPX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 11:23:28 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:2339 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbYCKPX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 11:23:26 -0400
Date: Tue, 11 Mar 2008 16:22:39 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: linux-arch <linux-arch@vger.kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] non-x86: Optimize find_next_(zero_)bit for small constant-size bitmaps
Message-ID: <20080311152239.GA15335@mailshack.com>
References: <20080309200103.GA895@mailshack.com> <20080309201152.GB28454@elte.hu> <1205094704.6430.1241420859@webmail.messagingengine.com> <20080309205132.GA9021@elte.hu> <20080310231724.GA8370@mailshack.com> <20080311095631.GT25110@elte.hu> <20080311151719.GA15313@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20080311151719.GA15313@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Tue, 11 Mar 2008 16:23:02 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.73; VDF: 7.0.3.16; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

non-x86: Optimize small bitmap searches for the other archs.

Concerns archs that have their own implementation of find_next_bit
and find_next_zero_bit.

For archs that define CONFIG_GENERIC_FIND_NEXT_BIT, a patch is
submitted to be included in Ingo's x86-testing tree. It moves
an optimization for searching small, constant-sized bitmaps
from x86_64-specific to generic code. It works by creating
a new __always_inline-marked function in linux/bitops.h, and
renaming find_next_(zero_)bit to __find_next_(zero_)bit in
the generic code. The new code is currently guarded by
CONFIG_GENERIC_FIND_NEXT_BIT, so other archs are expected to
work as before.

To enable the optimization globally, all other archs need to
implement __find_next_bit and __find_next_zero_bit either
by exporting these symbols, or by implementing them as inline
functions in their asm/bitops.h.

It would also be nice if every implementation would have the
same declaration:

	unsigned long __find_next_(zero_)bit(unsigned long *,
			unsigned long, unsigned long);

I added a totally untested patch for reference.

Did I mis an arch?
Does the assembly still match the (changed) prototype?
Can we get concensus on doing the optimization in generic code?

Greetings,
	Alexander

 arch/arm/lib/findbit.S          |    6 ++++--
 arch/avr32/kernel/avr32_ksyms.c |    4 ++--
 arch/avr32/lib/findbit.S        |    4 ++--
 include/asm-arm/bitops.h        |   20 ++++++++++++--------
 include/asm-m68k/bitops.h       |    8 ++++----
 include/asm-powerpc/bitops.h    |    4 ----
 include/asm-s390/bitops.h       |   12 ++++++------
 include/linux/bitops.h          |    2 --
 8 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/arm/lib/findbit.S b/arch/arm/lib/findbit.S
index a5ca024..5c92967 100644
--- a/arch/arm/lib/findbit.S
+++ b/arch/arm/lib/findbit.S
@@ -36,7 +36,8 @@ ENTRY(_find_first_zero_bit_le)
 
 /*
  * Purpose  : Find next 'zero' bit
- * Prototype: int find_next_zero_bit(void *addr, unsigned int maxbit, int offset)
+ * Prototype: unsigned long find_next_zero_bit(unsigned long *addr,
+ *			unsigned long maxbit, unsigned long offset);
  */
 ENTRY(_find_next_zero_bit_le)
 		teq	r1, #0
@@ -70,7 +71,8 @@ ENTRY(_find_first_bit_le)
 
 /*
  * Purpose  : Find next 'one' bit
- * Prototype: int find_next_zero_bit(void *addr, unsigned int maxbit, int offset)
+ * Prototype: unsigned long find_next_zero_bit(unsigned long *addr,
+ *			unsigned long maxbit, unsigned long offset);
  */
 ENTRY(_find_next_bit_le)
 		teq	r1, #0
diff --git a/arch/avr32/kernel/avr32_ksyms.c b/arch/avr32/kernel/avr32_ksyms.c
index 80f55f8..c228ed1 100644
--- a/arch/avr32/kernel/avr32_ksyms.c
+++ b/arch/avr32/kernel/avr32_ksyms.c
@@ -51,9 +51,9 @@ EXPORT_SYMBOL(__const_udelay);
 
 /* Bit operations (lib/findbit.S) */
 EXPORT_SYMBOL(find_first_zero_bit);
-EXPORT_SYMBOL(find_next_zero_bit);
+EXPORT_SYMBOL(__find_next_zero_bit);
 EXPORT_SYMBOL(find_first_bit);
-EXPORT_SYMBOL(find_next_bit);
+EXPORT_SYMBOL(__find_next_bit);
 EXPORT_SYMBOL(generic_find_next_zero_le_bit);
 
 /* I/O primitives (lib/io-*.S) */
diff --git a/arch/avr32/lib/findbit.S b/arch/avr32/lib/findbit.S
index c6b91de..729deab 100644
--- a/arch/avr32/lib/findbit.S
+++ b/arch/avr32/lib/findbit.S
@@ -29,7 +29,7 @@ ENTRY(find_first_zero_bit)
 	 *				    unsigned long size,
 	 *				    unsigned long offset)
 	 */
-ENTRY(find_next_zero_bit)
+ENTRY(__find_next_zero_bit)
 	lsr	r8, r10, 5
 	sub	r9, r11, r10
 	retle	r11
@@ -93,7 +93,7 @@ ENTRY(find_first_bit)
 	 *			       unsigned long size,
 	 *			       unsigned long offset)
 	 */
-ENTRY(find_next_bit)
+ENTRY(__find_next_bit)
 	lsr	r8, r10, 5
 	sub	r9, r11, r10
 	retle	r11
diff --git a/include/asm-arm/bitops.h b/include/asm-arm/bitops.h
index 5c60bfc..08b3163 100644
--- a/include/asm-arm/bitops.h
+++ b/include/asm-arm/bitops.h
@@ -158,9 +158,11 @@ extern int _test_and_set_bit_le(int nr, volatile unsigned long * p);
 extern int _test_and_clear_bit_le(int nr, volatile unsigned long * p);
 extern int _test_and_change_bit_le(int nr, volatile unsigned long * p);
 extern int _find_first_zero_bit_le(const void * p, unsigned size);
-extern int _find_next_zero_bit_le(const void * p, int size, int offset);
+extern unsigned long _find_next_zero_bit_le(const unsigned long * p,
+		unsigned long size, unsigned long offset);
 extern int _find_first_bit_le(const unsigned long *p, unsigned size);
-extern int _find_next_bit_le(const unsigned long *p, int size, int offset);
+extern unsigned long _find_next_bit_le(const unsigned long *p,
+		unsigned long size, unsigned long offset);
 
 /*
  * Big endian assembly bitops.  nr = 0 -> byte 3 bit 0.
@@ -172,9 +174,11 @@ extern int _test_and_set_bit_be(int nr, volatile unsigned long * p);
 extern int _test_and_clear_bit_be(int nr, volatile unsigned long * p);
 extern int _test_and_change_bit_be(int nr, volatile unsigned long * p);
 extern int _find_first_zero_bit_be(const void * p, unsigned size);
-extern int _find_next_zero_bit_be(const void * p, int size, int offset);
+extern unsigned long _find_next_zero_bit_be(const unsigned long * p,
+		unsigned long size, unsigned long offset);
 extern int _find_first_bit_be(const unsigned long *p, unsigned size);
-extern int _find_next_bit_be(const unsigned long *p, int size, int offset);
+extern unsigned long _find_next_bit_be(const unsigned long *p,
+		unsigned long size, unsigned long offset);
 
 #ifndef CONFIG_SMP
 /*
@@ -208,9 +212,9 @@ extern int _find_next_bit_be(const unsigned long *p, int size, int offset);
 #define test_and_clear_bit(nr,p)	ATOMIC_BITOP_LE(test_and_clear_bit,nr,p)
 #define test_and_change_bit(nr,p)	ATOMIC_BITOP_LE(test_and_change_bit,nr,p)
 #define find_first_zero_bit(p,sz)	_find_first_zero_bit_le(p,sz)
-#define find_next_zero_bit(p,sz,off)	_find_next_zero_bit_le(p,sz,off)
+#define __find_next_zero_bit(p,sz,off)	_find_next_zero_bit_le(p,sz,off)
 #define find_first_bit(p,sz)		_find_first_bit_le(p,sz)
-#define find_next_bit(p,sz,off)		_find_next_bit_le(p,sz,off)
+#define __find_next_bit(p,sz,off)	_find_next_bit_le(p,sz,off)
 
 #define WORD_BITOFF_TO_LE(x)		((x))
 
@@ -226,9 +230,9 @@ extern int _find_next_bit_be(const unsigned long *p, int size, int offset);
 #define test_and_clear_bit(nr,p)	ATOMIC_BITOP_BE(test_and_clear_bit,nr,p)
 #define test_and_change_bit(nr,p)	ATOMIC_BITOP_BE(test_and_change_bit,nr,p)
 #define find_first_zero_bit(p,sz)	_find_first_zero_bit_be(p,sz)
-#define find_next_zero_bit(p,sz,off)	_find_next_zero_bit_be(p,sz,off)
+#define __find_next_zero_bit(p,sz,off)	_find_next_zero_bit_be(p,sz,off)
 #define find_first_bit(p,sz)		_find_first_bit_be(p,sz)
-#define find_next_bit(p,sz,off)		_find_next_bit_be(p,sz,off)
+#define __find_next_bit(p,sz,off)	_find_next_bit_be(p,sz,off)
 
 #define WORD_BITOFF_TO_LE(x)		((x) ^ 0x18)
 
diff --git a/include/asm-m68k/bitops.h b/include/asm-m68k/bitops.h
index 83d1f28..c320c7a 100644
--- a/include/asm-m68k/bitops.h
+++ b/include/asm-m68k/bitops.h
@@ -199,8 +199,8 @@ out:
 	return ((long)p - (long)vaddr - 4) * 8 + res;
 }
 
-static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
-				     int offset)
+static inline unsigned long __find_next_zero_bit(const unsigned long *vaddr,
+		unsigned long size, unsigned long offset)
 {
 	const unsigned long *p = vaddr + (offset >> 5);
 	int bit = offset & 31UL, res;
@@ -246,8 +246,8 @@ out:
 	return ((long)p - (long)vaddr - 4) * 8 + res;
 }
 
-static inline int find_next_bit(const unsigned long *vaddr, int size,
-				int offset)
+static inline unsigned long __find_next_bit(const unsigned long *vaddr,
+		unsigned long size, unsigned long offset)
 {
 	const unsigned long *p = vaddr + (offset >> 5);
 	int bit = offset & 31UL, res;
diff --git a/include/asm-powerpc/bitops.h b/include/asm-powerpc/bitops.h
index 220d9a7..8ae6667 100644
--- a/include/asm-powerpc/bitops.h
+++ b/include/asm-powerpc/bitops.h
@@ -317,8 +317,6 @@ static __inline__ int fls(unsigned int x)
 #include <asm-generic/bitops/hweight.h>
 
 #define find_first_zero_bit(addr, size) find_next_zero_bit((addr), (size), 0)
-unsigned long find_next_zero_bit(const unsigned long *addr,
-				 unsigned long size, unsigned long offset);
 /**
  * find_first_bit - find the first set bit in a memory region
  * @addr: The address to start the search at
@@ -328,8 +326,6 @@ unsigned long find_next_zero_bit(const unsigned long *addr,
  * containing a bit.
  */
 #define find_first_bit(addr, size) find_next_bit((addr), (size), 0)
-unsigned long find_next_bit(const unsigned long *addr,
-			    unsigned long size, unsigned long offset);
 
 /* Little-endian versions */
 
diff --git a/include/asm-s390/bitops.h b/include/asm-s390/bitops.h
index 965394e..13a5c33 100644
--- a/include/asm-s390/bitops.h
+++ b/include/asm-s390/bitops.h
@@ -691,9 +691,9 @@ static inline unsigned long find_first_bit(const unsigned long * addr,
  * @offset: The bitnumber to start searching at
  * @size: The maximum size to search
  */
-static inline int find_next_zero_bit (const unsigned long * addr,
-				      unsigned long size,
-				      unsigned long offset)
+static inline unsigned long __find_next_zero_bit(const unsigned long * addr,
+						 unsigned long size,
+						 unsigned long offset)
 {
         const unsigned long *p;
 	unsigned long bit, set;
@@ -727,9 +727,9 @@ static inline int find_next_zero_bit (const unsigned long * addr,
  * @offset: The bitnumber to start searching at
  * @size: The maximum size to search
  */
-static inline int find_next_bit (const unsigned long * addr,
-				 unsigned long size,
-				 unsigned long offset)
+static inline unsigned long __find_next_bit(const unsigned long * addr,
+					    unsigned long size,
+					    unsigned long offset)
 {
         const unsigned long *p;
 	unsigned long bit, set;
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 15360f9..68be268 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -73,7 +73,6 @@ static inline unsigned fls_long(unsigned long l)
 }
 
 #ifdef __KERNEL__
-#ifdef CONFIG_GENERIC_FIND_NEXT_BIT
 extern unsigned long __find_next_bit(const unsigned long *addr,
 		unsigned long size, unsigned long offset);
 
@@ -147,6 +146,5 @@ find_next_zero_bit(const unsigned long *addr, unsigned long size,
 	/* size is not constant or too big */
 	return __find_next_zero_bit(addr, size, offset);
 }
-#endif /* CONFIG_GENERIC_FIND_NEXT_BIT */
 #endif /* __KERNEL__ */
 #endif

