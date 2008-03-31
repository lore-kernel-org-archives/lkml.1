Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbYCaRRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbYCaRRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 13:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYCaRRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 13:17:39 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:29611 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbYCaRRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 13:17:38 -0400
Date: Mon, 31 Mar 2008 19:15:06 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] x86: generic versions of find_first_(zero_)bit, convert i386
Message-ID: <20080331171506.GA24017@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Mon, 31 Mar 2008 19:17:19 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.78; VDF: 7.0.3.97; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic versions of __find_first_bit and __find_first_zero_bit
are introduced as simplified versions of __find_next_bit and
__find_next_zero_bit. Their compilation and use are guarded by
a new config variable GENERIC_FIND_FIRST_BIT.

The generic versions of find_first_bit and find_first_zero_bit
are implemented in terms of the newly introduced __find_first_bit
and __find_first_zero_bit.

This patch also converts i386 to the generic functions. The text
size shrinks slightly due to uninlining of the find_*_bit functions.

   text    data     bss     dec     hex filename
4764939  480324  622592 5867855  59894f vmlinux  (i386 defconfig before)
4764645  480324  622592 5867561  598829 vmlinux  (i386 defconfig after)

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

Hi Ingo,

Here is another step in the unification of the bitops for i386
and x86_64. This patch implements a minimal conversion to a
generic implementation of find_first_bit/find_first_zero_bit
for i386. The optimization for small bitmaps and the conversion
of x86_64 will follow soon.

Compiles and runs fine on i386 and x86_64 (current x86#testing).

Greetings,
	Alexander

 arch/x86/Kconfig            |    3 ++
 include/asm-x86/bitops_32.h |   56 -----------------------------------------
 include/linux/bitops.h      |   34 +++++++++++++++++++++++++
 lib/Makefile                |    1 +
 lib/find_next_bit.c         |   58 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 96 insertions(+), 56 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6b3626d..fa7d16d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -80,6 +80,9 @@ config GENERIC_BUG
 	def_bool y
 	depends on BUG
 
+config GENERIC_FIND_FIRST_BIT
+	def_bool X86_32
+
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
 
diff --git a/include/asm-x86/bitops_32.h b/include/asm-x86/bitops_32.h
index 3ed64b2..2e86302 100644
--- a/include/asm-x86/bitops_32.h
+++ b/include/asm-x86/bitops_32.h
@@ -4,62 +4,6 @@
 /*
  * Copyright 1992, Linus Torvalds.
  */
-
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
-
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/sched.h>
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 3865f2c..355d67b 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -113,6 +113,40 @@ static inline unsigned fls_long(unsigned long l)
 }
 
 #ifdef __KERNEL__
+#ifdef CONFIG_GENERIC_FIND_FIRST_BIT
+extern unsigned long __find_first_bit(const unsigned long *addr,
+		unsigned long size);
+
+/**
+ * find_first_bit - find the first set bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The maximum size to search
+ *
+ * Returns the bit number of the first set bit.
+ */
+static __always_inline unsigned long
+find_first_bit(const unsigned long *addr, unsigned long size)
+{
+	return __find_first_bit(addr, size);
+}
+
+extern unsigned long __find_first_zero_bit(const unsigned long *addr,
+		unsigned long size);
+
+/**
+ * find_first_zero_bit - find the first cleared bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The maximum size to search
+ *
+ * Returns the bit number of the first cleared bit.
+ */
+static __always_inline unsigned long
+find_first_zero_bit(const unsigned long *addr, unsigned long size)
+{
+	return __find_first_zero_bit(addr, size);
+}
+#endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
+
 #ifdef CONFIG_GENERIC_FIND_NEXT_BIT
 extern unsigned long __find_next_bit(const unsigned long *addr,
 		unsigned long size, unsigned long offset);
diff --git a/lib/Makefile b/lib/Makefile
index 23de261..14c93e1 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_SEMAPHORE_SLEEPERS) += semaphore-sleepers.o
+lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
diff --git a/lib/find_next_bit.c b/lib/find_next_bit.c
index ce94c4c..d3f5784 100644
--- a/lib/find_next_bit.c
+++ b/lib/find_next_bit.c
@@ -16,6 +16,7 @@
 
 #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
 
+#ifdef CONFIG_GENERIC_FIND_NEXT_BIT
 /*
  * Find the next set bit in a memory region.
  */
@@ -102,6 +103,63 @@ found_middle:
 	return result + ffz(tmp);
 }
 EXPORT_SYMBOL(__find_next_zero_bit);
+#endif /* CONFIG_GENERIC_FIND_NEXT_BIT */
+
+#ifdef CONFIG_GENERIC_FIND_FIRST_BIT
+/*
+ * Find the first set bit in a memory region.
+ */
+unsigned long __find_first_bit(const unsigned long *addr,
+		unsigned long size)
+{
+	const unsigned long *p = addr;
+	unsigned long result = 0;
+	unsigned long tmp;
+
+	while (size & ~(BITS_PER_LONG-1)) {
+		if ((tmp = *(p++)))
+			goto found;
+		result += BITS_PER_LONG;
+		size -= BITS_PER_LONG;
+	}
+	if (!size)
+		return result;
+
+	tmp = (*p) & (~0UL >> (BITS_PER_LONG - size));
+	if (tmp == 0UL)		/* Are any bits set? */
+		return result + size;	/* Nope. */
+found:
+	return result + __ffs(tmp);
+}
+EXPORT_SYMBOL(__find_first_bit);
+
+/*
+ * Find the first cleared bit in a memory region.
+ */
+unsigned long __find_first_zero_bit(const unsigned long *addr,
+		unsigned long size)
+{
+	const unsigned long *p = addr;
+	unsigned long result = 0;
+	unsigned long tmp;
+
+	while (size & ~(BITS_PER_LONG-1)) {
+		if (~(tmp = *(p++)))
+			goto found;
+		result += BITS_PER_LONG;
+		size -= BITS_PER_LONG;
+	}
+	if (!size)
+		return result;
+
+	tmp = (*p) | (~0UL << size);
+	if (tmp == ~0UL)	/* Are any bits zero? */
+		return result + size;	/* Nope. */
+found:
+	return result + ffz(tmp);
+}
+EXPORT_SYMBOL(__find_first_zero_bit);
+#endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
 #ifdef __BIG_ENDIAN
 
