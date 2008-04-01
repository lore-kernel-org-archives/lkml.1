Return-Path: <linux-kernel-owner+w=401wt.eu-S1759813AbYDAPu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759813AbYDAPu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYDAPut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:50:49 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:24649 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbYDAPus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:50:48 -0400
Date: Tue, 1 Apr 2008 17:47:57 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] x86: remove x86-specific implementations of find_first_bit
Message-ID: <20080401154757.GC26062@mailshack.com>
References: <20080331171506.GA24017@mailshack.com> <20080401084710.GB4787@elte.hu> <20080401094618.GA24862@mailshack.com> <20080401154126.GA26062@mailshack.com> <20080401154221.GB26062@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401154221.GB26062@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Tue, 01 Apr 2008 17:50:21 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.78; VDF: 7.0.3.104; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: remove x86-specific implementations of find_first_bit

x86 has been switched to the generic versions of find_first_bit
and find_first_zero_bit, but the original versions were retained.
This patch just removes the now unused x86-specific versions.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---
 arch/x86/lib/Makefile       |    1 -
 arch/x86/lib/bitops_64.c    |  109 -------------------------------------------
 include/asm-x86/bitops_32.h |   58 -----------------------
 include/asm-x86/bitops_64.h |   23 ---------
 4 files changed, 0 insertions(+), 191 deletions(-)
 delete mode 100644 arch/x86/lib/bitops_64.c

This patch should of course wait until it is decided if the generic
version is good enough to replace the x86-specific ones. I hacked
together a benchmark that people can run on different machines. It
can be downloaded from:

   http://heukelum.fastmail.fm/find_first_bit

Greetings,
	Alexander

diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 4360932..76f60f5 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -21,7 +21,6 @@ else
 
         lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
         lib-y += thunk_64.o clear_page_64.o copy_page_64.o
-        lib-y += bitops_64.o
         lib-y += memmove_64.o memset_64.o
         lib-y += copy_user_64.o rwlock_64.o copy_user_nocache_64.o
 endif
diff --git a/arch/x86/lib/bitops_64.c b/arch/x86/lib/bitops_64.c
deleted file mode 100644
index 568467d..0000000
--- a/arch/x86/lib/bitops_64.c
+++ /dev/null
@@ -1,109 +0,0 @@
-#ifndef CONFIG_GENERIC_FIND_FIRST_BIT
-#include <linux/bitops.h>
-
-#undef find_first_zero_bit
-#undef find_first_bit
-
-static inline long
-__find_first_zero_bit(const unsigned long * addr, unsigned long size)
-{
-	long d0, d1, d2;
-	long res;
-
-	/*
-	 * We must test the size in words, not in bits, because
-	 * otherwise incoming sizes in the range -63..-1 will not run
-	 * any scasq instructions, and then the flags used by the je
-	 * instruction will have whatever random value was in place
-	 * before.  Nobody should call us like that, but
-	 * find_next_zero_bit() does when offset and size are at the
-	 * same word and it fails to find a zero itself.
-	 */
-	size += 63;
-	size >>= 6;
-	if (!size)
-		return 0;
-	asm volatile(
-		"  repe; scasq\n"
-		"  je 1f\n"
-		"  xorq -8(%%rdi),%%rax\n"
-		"  subq $8,%%rdi\n"
-		"  bsfq %%rax,%%rdx\n"
-		"1:  subq %[addr],%%rdi\n"
-		"  shlq $3,%%rdi\n"
-		"  addq %%rdi,%%rdx"
-		:"=d" (res), "=&c" (d0), "=&D" (d1), "=&a" (d2)
-		:"0" (0ULL), "1" (size), "2" (addr), "3" (-1ULL),
-		 [addr] "S" (addr) : "memory");
-	/*
-	 * Any register would do for [addr] above, but GCC tends to
-	 * prefer rbx over rsi, even though rsi is readily available
-	 * and doesn't have to be saved.
-	 */
-	return res;
-}
-
-/**
- * find_first_zero_bit - find the first zero bit in a memory region
- * @addr: The address to start the search at
- * @size: The maximum size to search
- *
- * Returns the bit-number of the first zero bit, not the number of the byte
- * containing a bit.
- */
-long find_first_zero_bit(const unsigned long * addr, unsigned long size)
-{
-	return __find_first_zero_bit (addr, size);
-}
-
-static inline long
-__find_first_bit(const unsigned long * addr, unsigned long size)
-{
-	long d0, d1;
-	long res;
-
-	/*
-	 * We must test the size in words, not in bits, because
-	 * otherwise incoming sizes in the range -63..-1 will not run
-	 * any scasq instructions, and then the flags used by the jz
-	 * instruction will have whatever random value was in place
-	 * before.  Nobody should call us like that, but
-	 * find_next_bit() does when offset and size are at the same
-	 * word and it fails to find a one itself.
-	 */
-	size += 63;
-	size >>= 6;
-	if (!size)
-		return 0;
-	asm volatile(
-		"   repe; scasq\n"
-		"   jz 1f\n"
-		"   subq $8,%%rdi\n"
-		"   bsfq (%%rdi),%%rax\n"
-		"1: subq %[addr],%%rdi\n"
-		"   shlq $3,%%rdi\n"
-		"   addq %%rdi,%%rax"
-		:"=a" (res), "=&c" (d0), "=&D" (d1)
-		:"0" (0ULL), "1" (size), "2" (addr),
-		 [addr] "r" (addr) : "memory");
-	return res;
-}
-
-/**
- * find_first_bit - find the first set bit in a memory region
- * @addr: The address to start the search at
- * @size: The maximum size to search
- *
- * Returns the bit-number of the first set bit, not the number of the byte
- * containing a bit.
- */
-long find_first_bit(const unsigned long * addr, unsigned long size)
-{
-	return __find_first_bit(addr,size);
-}
-
-#include <linux/module.h>
-
-EXPORT_SYMBOL(find_first_bit);
-EXPORT_SYMBOL(find_first_zero_bit);
-#endif
diff --git a/include/asm-x86/bitops_32.h b/include/asm-x86/bitops_32.h
index ba2c0de..2e86302 100644
--- a/include/asm-x86/bitops_32.h
+++ b/include/asm-x86/bitops_32.h
@@ -4,64 +4,6 @@
 /*
  * Copyright 1992, Linus Torvalds.
  */
-
-#ifndef CONFIG_GENERIC_FIND_FIRST_BIT
-/**
- * find_first_zero_bit - find the first zero bit in a memory region
- * @addr: The address to start the search at
- * @size: The maximum size to search
- *
- * Returns the bit number of the first zero bit, not the number of the byte
- * containing a bit.
- */
-static inline int find_first_zero_bit(const unsigned long *addr, unsigned size)
-{
-	int d0, d1, d2;
-	int res;
-
-	if (!size)
-		return 0;
-	/* This looks at memory.
-	 * Mark it volatile to tell gcc not to move it around
-	 */
-	asm volatile("movl $-1,%%eax\n\t"
-		     "xorl %%edx,%%edx\n\t"
-		     "repe; scasl\n\t"
-		     "je 1f\n\t"
-		     "xorl -4(%%edi),%%eax\n\t"
-		     "subl $4,%%edi\n\t"
-		     "bsfl %%eax,%%edx\n"
-		     "1:\tsubl %%ebx,%%edi\n\t"
-		     "shll $3,%%edi\n\t"
-		     "addl %%edi,%%edx"
-		     : "=d" (res), "=&c" (d0), "=&D" (d1), "=&a" (d2)
-		     : "1" ((size + 31) >> 5), "2" (addr),
-		       "b" (addr) : "memory");
-	return res;
-}
-
-/**
- * find_first_bit - find the first set bit in a memory region
- * @addr: The address to start the search at
- * @size: The maximum size to search
- *
- * Returns the bit number of the first set bit, not the number of the byte
- * containing a bit.
- */
-static inline unsigned find_first_bit(const unsigned long *addr, unsigned size)
-{
-	unsigned x = 0;
-
-	while (x < size) {
-		unsigned long val = *addr++;
-		if (val)
-			return __ffs(val) + x;
-		x += sizeof(*addr) << 3;
-	}
-	return x;
-}
-#endif
-
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/sched.h>
diff --git a/include/asm-x86/bitops_64.h b/include/asm-x86/bitops_64.h
index 4081d7e..cb23122 100644
--- a/include/asm-x86/bitops_64.h
+++ b/include/asm-x86/bitops_64.h
@@ -4,29 +4,6 @@
 /*
  * Copyright 1992, Linus Torvalds.
  */
-
-#ifndef CONFIG_GENERIC_FIND_FIRST_BIT
-extern long find_first_zero_bit(const unsigned long *addr, unsigned long size);
-extern long find_first_bit(const unsigned long *addr, unsigned long size);
-
-/* return index of first bet set in val or max when no bit is set */
-static inline long __scanbit(unsigned long val, unsigned long max)
-{
-	asm("bsfq %1,%0 ; cmovz %2,%0" : "=&r" (val) : "r" (val), "r" (max));
-	return val;
-}
-
-#define find_first_bit(addr, size)					\
-	((__builtin_constant_p((size)) && (size) <= BITS_PER_LONG	\
-	  ? (__scanbit(*(unsigned long *)(addr), (size)))		\
-	  : find_first_bit((addr), (size))))
-
-#define find_first_zero_bit(addr, size)					\
-	((__builtin_constant_p((size)) && (size) <= BITS_PER_LONG	\
-	  ? (__scanbit(~*(unsigned long *)(addr), (size)))		\
-	  : find_first_zero_bit((addr), (size))))
-#endif
-
 static inline void set_bit_string(unsigned long *bitmap, unsigned long i,
 				  int len)
 {
-- 
1.5.2.5

