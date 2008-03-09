Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbYCIUB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbYCIUB7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYCIUBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:01:49 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:8920 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbYCIUBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:01:48 -0400
Date: Sun, 9 Mar 2008 21:01:04 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: heukelum@fastmail.fm
Subject: [PATCH] x86: Change x86 to use generic find_next_bit
Message-ID: <20080309200103.GA895@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Sun, 09 Mar 2008 21:01:37 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.73; VDF: 7.0.3.5; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: Change x86 to use the generic find_next_bit implementation

The versions with inline assembly are in fact slower on the machines I
tested them on (in userspace) (Athlon XP 2800+, p4-like Xeon 2.8GHz, AMD
Opteron 270). The i386-version needed a fix similar to 06024f21 to avoid
crashing the benchmark.

Benchmark using: gcc -fomit-frame-pointer -Os. For each bitmap size 
1...512, for each possible bitmap with one bit set, for each possible 
offset: find the position of the first bit starting at offset. If you 
follow ;). Times include setup of the bitmap and checking of the 
results.

		Athlon		Xeon		Opteron 32/64bit
x86-specific:	0m3.692s	0m2.820s	0m3.196s / 0m2.480s
generic:	0m2.622s	0m1.662s	0m2.100s / 0m1.572s

If the bitmap size is not a multiple of BITS_PER_LONG, and no set 
(cleared) bit is found, find_next_bit (find_next_zero_bit) returns a 
value outside of the range [0,size]. The generic version always returns 
exactly size. The generic version also uses unsigned long everywhere, 
while the x86 versions use a mishmash of int, unsigned (int), long and 
unsigned long.

Using the generic version does give a slightly bigger kernel, though.

defconfig:	   text    data     bss     dec     hex filename
x86-specific:	4738555  481232  626688 5846475  5935cb vmlinux (32 bit)
generic:	4738621  481232  626688 5846541  59360d vmlinux (32 bit)
x86-specific:	5392395  846568  724424 6963387  6a40bb vmlinux (64 bit)
generic:	5392458  846568  724424 6963450  6a40fa vmlinux (64 bit)

 arch/x86/Kconfig            |    3 ++
 arch/x86/lib/Makefile       |    2 +-
 arch/x86/lib/bitops_32.c    |   70 -------------------------------------------
 arch/x86/lib/bitops_64.c    |   68 -----------------------------------------
 include/asm-x86/bitops.h    |    6 ++++
 include/asm-x86/bitops_32.h |   16 ----------
 include/asm-x86/bitops_64.h |    2 -
 lib/find_next_bit.c         |    2 +
 8 files changed, 12 insertions(+), 157 deletions(-)

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

Hi,

I think it would be a good idea to use the generic versions of
find_next_bit and find_next_zero_bit. The i386 versions have
a bug, and the generic ones are faster (in my probably 
not-so-representative micro-benchmark, that is).

Patch is against -x86#testing. It compiles.

Greetings,
	Alexander

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ab85a04..29a5a38 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -83,6 +83,9 @@ config GENERIC_BUG
 	def_bool y
 	depends on BUG
 
+config GENERIC_FIND_NEXT_BIT
+	def_bool y
+
 config GENERIC_HWEIGHT
 	def_bool y
 
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 25df1c1..4360932 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -11,7 +11,7 @@ lib-y += memcpy_$(BITS).o
 ifeq ($(CONFIG_X86_32),y)
         lib-y += checksum_32.o
         lib-y += strstr_32.o
-        lib-y += bitops_32.o semaphore_32.o string_32.o
+        lib-y += semaphore_32.o string_32.o
 
         lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
 else
diff --git a/arch/x86/lib/bitops_32.c b/arch/x86/lib/bitops_32.c
deleted file mode 100644
index b654404..0000000
--- a/arch/x86/lib/bitops_32.c
+++ /dev/null
@@ -1,70 +0,0 @@
-#include <linux/bitops.h>
-#include <linux/module.h>
-
-/**
- * find_next_bit - find the next set bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The maximum size to search
- */
-int find_next_bit(const unsigned long *addr, int size, int offset)
-{
-	const unsigned long *p = addr + (offset >> 5);
-	int set = 0, bit = offset & 31, res;
-
-	if (bit) {
-		/*
-		 * Look for nonzero in the first 32 bits:
-		 */
-		__asm__("bsfl %1,%0\n\t"
-			"jne 1f\n\t"
-			"movl $32, %0\n"
-			"1:"
-			: "=r" (set)
-			: "r" (*p >> bit));
-		if (set < (32 - bit))
-			return set + offset;
-		set = 32 - bit;
-		p++;
-	}
-	/*
-	 * No set bit yet, search remaining full words for a bit
-	 */
-	res = find_first_bit (p, size - 32 * (p - addr));
-	return (offset + set + res);
-}
-EXPORT_SYMBOL(find_next_bit);
-
-/**
- * find_next_zero_bit - find the first zero bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The maximum size to search
- */
-int find_next_zero_bit(const unsigned long *addr, int size, int offset)
-{
-	const unsigned long *p = addr + (offset >> 5);
-	int set = 0, bit = offset & 31, res;
-
-	if (bit) {
-		/*
-		 * Look for zero in the first 32 bits.
-		 */
-		__asm__("bsfl %1,%0\n\t"
-			"jne 1f\n\t"
-			"movl $32, %0\n"
-			"1:"
-			: "=r" (set)
-			: "r" (~(*p >> bit)));
-		if (set < (32 - bit))
-			return set + offset;
-		set = 32 - bit;
-		p++;
-	}
-	/*
-	 * No zero yet, search remaining full bytes for a zero
-	 */
-	res = find_first_zero_bit(p, size - 32 * (p - addr));
-	return (offset + set + res);
-}
-EXPORT_SYMBOL(find_next_zero_bit);
diff --git a/arch/x86/lib/bitops_64.c b/arch/x86/lib/bitops_64.c
index 0e8f491..0eeb704 100644
--- a/arch/x86/lib/bitops_64.c
+++ b/arch/x86/lib/bitops_64.c
@@ -1,9 +1,7 @@
 #include <linux/bitops.h>
 
 #undef find_first_zero_bit
-#undef find_next_zero_bit
 #undef find_first_bit
-#undef find_next_bit
 
 static inline long
 __find_first_zero_bit(const unsigned long * addr, unsigned long size)
@@ -57,39 +55,6 @@ long find_first_zero_bit(const unsigned long * addr, unsigned long size)
 	return __find_first_zero_bit (addr, size);
 }
 
-/**
- * find_next_zero_bit - find the next zero bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The maximum size to search
- */
-long find_next_zero_bit (const unsigned long * addr, long size, long offset)
-{
-	const unsigned long * p = addr + (offset >> 6);
-	unsigned long set = 0;
-	unsigned long res, bit = offset&63;
-
-	if (bit) {
-		/*
-		 * Look for zero in first word
-		 */
-		asm("bsfq %1,%0\n\t"
-		    "cmoveq %2,%0"
-		    : "=r" (set)
-		    : "r" (~(*p >> bit)), "r"(64L));
-		if (set < (64 - bit))
-			return set + offset;
-		set = 64 - bit;
-		p++;
-	}
-	/*
-	 * No zero yet, search remaining full words for a zero
-	 */
-	res = __find_first_zero_bit (p, size - 64 * (p - addr));
-
-	return (offset + set + res);
-}
-
 static inline long
 __find_first_bit(const unsigned long * addr, unsigned long size)
 {
@@ -136,40 +101,7 @@ long find_first_bit(const unsigned long * addr, unsigned long size)
 	return __find_first_bit(addr,size);
 }
 
-/**
- * find_next_bit - find the first set bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The maximum size to search
- */
-long find_next_bit(const unsigned long * addr, long size, long offset)
-{
-	const unsigned long * p = addr + (offset >> 6);
-	unsigned long set = 0, bit = offset & 63, res;
-
-	if (bit) {
-		/*
-		 * Look for nonzero in the first 64 bits:
-		 */
-		asm("bsfq %1,%0\n\t"
-		    "cmoveq %2,%0\n\t"
-		    : "=r" (set)
-		    : "r" (*p >> bit), "r" (64L));
-		if (set < (64 - bit))
-			return set + offset;
-		set = 64 - bit;
-		p++;
-	}
-	/*
-	 * No set bit yet, search remaining full words for a bit
-	 */
-	res = __find_first_bit (p, size - 64 * (p - addr));
-	return (offset + set + res);
-}
-
 #include <linux/module.h>
 
-EXPORT_SYMBOL(find_next_bit);
 EXPORT_SYMBOL(find_first_bit);
 EXPORT_SYMBOL(find_first_zero_bit);
-EXPORT_SYMBOL(find_next_zero_bit);
diff --git a/include/asm-x86/bitops.h b/include/asm-x86/bitops.h
index 1a23ce1..7fbf93a 100644
--- a/include/asm-x86/bitops.h
+++ b/include/asm-x86/bitops.h
@@ -312,6 +312,12 @@ static int test_bit(int nr, const volatile unsigned long *addr);
 
 #undef ADDR
 
+unsigned long find_next_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset);
+unsigned long find_next_zero_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset);
+
+
 #ifdef CONFIG_X86_32
 # include "bitops_32.h"
 #else
diff --git a/include/asm-x86/bitops_32.h b/include/asm-x86/bitops_32.h
index e4d75fc..570f0fa 100644
--- a/include/asm-x86/bitops_32.h
+++ b/include/asm-x86/bitops_32.h
@@ -38,14 +38,6 @@ static inline int find_first_zero_bit(const unsigned long *addr, unsigned size)
 }
 
 /**
- * find_next_zero_bit - find the first zero bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bit number to start searching at
- * @size: The maximum size to search
- */
-int find_next_zero_bit(const unsigned long *addr, int size, int offset);
-
-/**
  * __ffs - find first bit in word.
  * @word: The word to search
  *
@@ -81,14 +73,6 @@ static inline unsigned find_first_bit(const unsigned long *addr, unsigned size)
 }
 
 /**
- * find_next_bit - find the first set bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bit number to start searching at
- * @size: The maximum size to search
- */
-int find_next_bit(const unsigned long *addr, int size, int offset);
-
-/**
  * ffz - find first zero in word.
  * @word: The word to search
  *
diff --git a/include/asm-x86/bitops_64.h b/include/asm-x86/bitops_64.h
index aaf1519..40bf0f8 100644
--- a/include/asm-x86/bitops_64.h
+++ b/include/asm-x86/bitops_64.h
@@ -6,9 +6,7 @@
  */
 
 extern long find_first_zero_bit(const unsigned long *addr, unsigned long size);
-extern long find_next_zero_bit(const unsigned long *addr, long size, long offset);
 extern long find_first_bit(const unsigned long *addr, unsigned long size);
-extern long find_next_bit(const unsigned long *addr, long size, long offset);
 
 /* return index of first bet set in val or max when no bit is set */
 static inline long __scanbit(unsigned long val, unsigned long max)
diff --git a/lib/find_next_bit.c b/lib/find_next_bit.c
index 78ccd73..5820e07 100644
--- a/lib/find_next_bit.c
+++ b/lib/find_next_bit.c
@@ -15,6 +15,8 @@
 #include <asm/byteorder.h>
 
 #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
+#undef find_next_bit
+#undef find_next_zero_bit
 
 /**
  * find_next_bit - find the next set bit in a memory region

