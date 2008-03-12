Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbYCLUC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbYCLUC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 16:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbYCLUCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 16:02:18 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:9226 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbYCLUCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 16:02:17 -0400
Date: Wed, 12 Mar 2008 21:01:28 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: merge the simple bitops and move them to bitops.h
Message-ID: <20080312200128.GA24983@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Wed, 12 Mar 2008 21:01:43 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.73; VDF: 7.0.3.22; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: merge the simple bitops and move them to bitops.h

Some of those can be written in such a way that the same
inline assembly can be used to generate both 32 bit and
64 bit code.

For ffs and fls, x86_64 unconditionally used the cmov
instruction and i386 unconditionally used a conditional
branch over a mov instruction. In the current patch I
chose to select the version based on the availability
of the cmov instruction instead. A small detail here is
that x86_64 did not previously set CONFIG_X86_CMOV=y.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

 arch/x86/Kconfig.cpu        |    2 +-
 include/asm-x86/bitops.h    |   90 +++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/bitops_32.h |   64 ------------------------------
 include/asm-x86/bitops_64.h |   76 ------------------------------------
 4 files changed, 91 insertions(+), 141 deletions(-)

Hi Ingo,

On a 64-bit machine the cmov instruction is always available. I made
that explicit by turning on CONFIG_X86_CMOV for all 64-bit builds.

This patch introduces a change in behaviour for 32-bit builds: if
the selected cpu has the cmov instruction, it will now be used by
the functions ffs and fls.

For the i386 defconfig the number of occurrences of cmov increases
from 4336 to 4429 and vmlinux text size increases 15 bytes. When
building for 486 no cmovs are generated, as expected.

Greetings,
	Alexander

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 31e92fb..fb7399b 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -399,7 +399,7 @@ config X86_TSC
 # generates cmov.
 config X86_CMOV
 	def_bool y
-	depends on (MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7)
+	depends on (MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || X86_64)
 
 config X86_MINIMUM_CPU_FAMILY
 	int
diff --git a/include/asm-x86/bitops.h b/include/asm-x86/bitops.h
index 1a23ce1..bbdecee 100644
--- a/include/asm-x86/bitops.h
+++ b/include/asm-x86/bitops.h
@@ -310,6 +310,96 @@ static int test_bit(int nr, const volatile unsigned long *addr);
 	 constant_test_bit((nr),(addr)) :	\
 	 variable_test_bit((nr),(addr)))
 
+/**
+ * __ffs - find first bit in word.
+ * @word: The word to search
+ *
+ * Undefined if no bit exists, so code should check against 0 first.
+ */
+static inline unsigned long __ffs(unsigned long word)
+{
+	__asm__("bsf %1,%0"
+		:"=r" (word)
+		:"rm" (word));
+	return word;
+}
+
+/**
+ * ffz - find first zero in word.
+ * @word: The word to search
+ *
+ * Undefined if no zero exists, so code should check against ~0UL first.
+ */
+static inline unsigned long ffz(unsigned long word)
+{
+	__asm__("bsf %1,%0"
+		:"=r" (word)
+		:"r" (~word));
+	return word;
+}
+
+/*
+ * __fls: find last bit set.
+ * @word: The word to search
+ *
+ * Undefined if no zero exists, so code should check against ~0UL first.
+ */
+static inline unsigned long __fls(unsigned long word)
+{
+	__asm__("bsr %1,%0"
+		:"=r" (word)
+		:"rm" (word));
+	return word;
+}
+
+#ifdef __KERNEL__
+/**
+ * ffs - find first bit set
+ * @x: the word to search
+ *
+ * This is defined the same way as
+ * the libc and compiler builtin ffs routines, therefore
+ * differs in spirit from the above ffz() (man ffs).
+ */
+static inline int ffs(int x)
+{
+	int r;
+#ifdef CONFIG_X86_CMOV
+	__asm__("bsfl %1,%0\n\t"
+		"cmovzl %2,%0"
+		: "=r" (r) : "rm" (x), "r" (-1));
+#else
+	__asm__("bsfl %1,%0\n\t"
+		"jnz 1f\n\t"
+		"movl $-1,%0\n"
+		"1:" : "=r" (r) : "rm" (x));
+#endif
+	return r+1;
+}
+
+/**
+ * fls - find last bit set
+ * @x: the word to search
+ *
+ * This is defined the same way as ffs().
+ */
+static inline int fls(int x)
+{
+	int r;
+#ifdef CONFIG_X86_CMOV
+	__asm__("bsrl %1,%0\n\t"
+		"cmovzl %2,%0"
+		: "=&r" (r) : "rm" (x), "rm" (-1));
+#else
+	__asm__("bsrl %1,%0\n\t"
+		"jnz 1f\n\t"
+		"movl $-1,%0\n"
+		"1:" : "=r" (r) : "rm" (x));
+#endif
+	return r+1;
+}
+#endif /* __KERNEL__ */
+
 #undef ADDR
 
 #ifdef CONFIG_X86_32
diff --git a/include/asm-x86/bitops_32.h b/include/asm-x86/bitops_32.h
index 570f0fa..c19fbe9 100644
--- a/include/asm-x86/bitops_32.h
+++ b/include/asm-x86/bitops_32.h
@@ -38,20 +38,6 @@ static inline int find_first_zero_bit(const unsigned long *addr, unsigned size)
 }
 
 /**
- * __ffs - find first bit in word.
- * @word: The word to search
- *
- * Undefined if no bit exists, so code should check against 0 first.
- */
-static inline unsigned long __ffs(unsigned long word)
-{
-	__asm__("bsfl %1,%0"
-		:"=r" (word)
-		:"rm" (word));
-	return word;
-}
-
-/**
  * find_first_bit - find the first set bit in a memory region
  * @addr: The address to start the search at
  * @size: The maximum size to search
@@ -72,60 +58,10 @@ static inline unsigned find_first_bit(const unsigned long *addr, unsigned size)
 	return x;
 }
 
-/**
- * ffz - find first zero in word.
- * @word: The word to search
- *
- * Undefined if no zero exists, so code should check against ~0UL first.
- */
-static inline unsigned long ffz(unsigned long word)
-{
-	__asm__("bsfl %1,%0"
-		:"=r" (word)
-		:"r" (~word));
-	return word;
-}
-
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/sched.h>
 
-/**
- * ffs - find first bit set
- * @x: the word to search
- *
- * This is defined the same way as
- * the libc and compiler builtin ffs routines, therefore
- * differs in spirit from the above ffz() (man ffs).
- */
-static inline int ffs(int x)
-{
-	int r;
-
-	__asm__("bsfl %1,%0\n\t"
-		"jnz 1f\n\t"
-		"movl $-1,%0\n"
-		"1:" : "=r" (r) : "rm" (x));
-	return r+1;
-}
-
-/**
- * fls - find last bit set
- * @x: the word to search
- *
- * This is defined the same way as ffs().
- */
-static inline int fls(int x)
-{
-	int r;
-
-	__asm__("bsrl %1,%0\n\t"
-		"jnz 1f\n\t"
-		"movl $-1,%0\n"
-		"1:" : "=r" (r) : "rm" (x));
-	return r+1;
-}
-
 #include <asm-generic/bitops/hweight.h>
 
 #endif /* __KERNEL__ */
diff --git a/include/asm-x86/bitops_64.h b/include/asm-x86/bitops_64.h
index 87e1a17..866ed56 100644
--- a/include/asm-x86/bitops_64.h
+++ b/include/asm-x86/bitops_64.h
@@ -35,71 +35,11 @@ static inline void set_bit_string(unsigned long *bitmap, unsigned long i,
 	}
 } 
 
-/**
- * ffz - find first zero in word.
- * @word: The word to search
- *
- * Undefined if no zero exists, so code should check against ~0UL first.
- */
-static inline unsigned long ffz(unsigned long word)
-{
-	__asm__("bsfq %1,%0"
-		:"=r" (word)
-		:"r" (~word));
-	return word;
-}
-
-/**
- * __ffs - find first bit in word.
- * @word: The word to search
- *
- * Undefined if no bit exists, so code should check against 0 first.
- */
-static inline unsigned long __ffs(unsigned long word)
-{
-	__asm__("bsfq %1,%0"
-		:"=r" (word)
-		:"rm" (word));
-	return word;
-}
-
-/*
- * __fls: find last bit set.
- * @word: The word to search
- *
- * Undefined if no zero exists, so code should check against ~0UL first.
- */
-static inline unsigned long __fls(unsigned long word)
-{
-	__asm__("bsrq %1,%0"
-		:"=r" (word)
-		:"rm" (word));
-	return word;
-}
-
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/sched.h>
 
 /**
- * ffs - find first bit set
- * @x: the word to search
- *
- * This is defined the same way as
- * the libc and compiler builtin ffs routines, therefore
- * differs in spirit from the above ffz (man ffs).
- */
-static inline int ffs(int x)
-{
-	int r;
-
-	__asm__("bsfl %1,%0\n\t"
-		"cmovzl %2,%0" 
-		: "=r" (r) : "rm" (x), "r" (-1));
-	return r+1;
-}
-
-/**
  * fls64 - find last bit set in 64 bit word
  * @x: the word to search
  *
@@ -112,22 +52,6 @@ static inline int fls64(__u64 x)
 	return __fls(x) + 1;
 }
 
-/**
- * fls - find last bit set
- * @x: the word to search
- *
- * This is defined the same way as ffs.
- */
-static inline int fls(int x)
-{
-	int r;
-
-	__asm__("bsrl %1,%0\n\t"
-		"cmovzl %2,%0"
-		: "=&r" (r) : "rm" (x), "rm" (-1));
-	return r+1;
-}
-
 #define ARCH_HAS_FAST_MULTIPLIER 1
 
 #include <asm-generic/bitops/hweight.h>
