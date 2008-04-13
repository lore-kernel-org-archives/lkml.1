Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbYDMLYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbYDMLYQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 07:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbYDMLYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 07:24:00 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:22584 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbYDMLX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 07:23:59 -0400
Date: Sun, 13 Apr 2008 13:23:08 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, heukelum@fastmail.fm
Subject: [PATCH] x86: always_inline wrapper for x86's test_bit
Message-ID: <20080413112308.GA23426@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Sun, 13 Apr 2008 13:23:46 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.85; VDF: 7.0.3.158; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86, test_bit is currently implemented as a preprocessor macro. It
uses gcc's __builtin_constant_p to determine if the bit position is 
known at compile time and defers to one of two functions depending
on that. This changes the same logic to an __always_inline wrapper
instead.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

Hi Ingo,

This patch is a cleanup, changing a macro into an inline function.

However, the size comparison here is interesting. Allowing gcc to
uninline functions marked inline causes a nice decrease in size
for a defconfig, but on my tiny config the size increases.

   text    data     bss     dec     hex vmlinux/i386
4850554  474688  622592 5947834  5ac1ba defconfig+forced inlining
4850888  474688  622592 5948168  5ac308 defconfig+forced inlining (patched)
4721175  474688  622592 5818455  58c857 defconfig (uninlining)
4705595  474688  622592 5802875  588b7b defconfig (uninlining, patched)
   
   text    data     bss     dec     hex vmlinux/i386
 759524   77400   81920  918844   e053c tiny (forced inlining)
 759562   77400   81920  918882   e0562 tiny (forced inlining, patched)
 787508   77400   81920  946828   e728c tiny (uninlining)
 784492   77400   81920  943812   e66c4 tiny (uninlining, patched)

If gcc decides to emit a separate function instead of inlining it,
the image can have multiple instances of this uninlined function.
Moreover, gcc decides if a function is too big to be inlined using
a heuristic and sometimes gets it wrong. In particular, it uninlined
constant_bit_test which indeed looks a bit big, but should reduce to
a single assembly instruction after constant folding.

So I guess we should sprinkle some __always_inlines in the core
parts of the kernel? The most problematic ones are easily spotted
using: nm -S vmlinux|uniq -f2 -D

Greetings,
	Alexander

 arch/x86/boot/bitops.h   |   20 ++++++++++----------
 include/asm-x86/bitops.h |   23 +++++++++--------------
 2 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/arch/x86/boot/bitops.h b/arch/x86/boot/bitops.h
index 878e4b9..b1a4841 100644
--- a/arch/x86/boot/bitops.h
+++ b/arch/x86/boot/bitops.h
@@ -16,12 +16,7 @@
 #define BOOT_BITOPS_H
 #define _LINUX_BITOPS_H		/* Inhibit inclusion of <linux/bitops.h> */
 
-static inline int constant_test_bit(int nr, const void *addr)
-{
-	const u32 *p = (const u32 *)addr;
-	return ((1UL << (nr & 31)) & (p[nr >> 5])) != 0;
-}
-static inline int variable_test_bit(int nr, const void *addr)
+static inline int variable_test_bit(int nr, const volatile unsigned long *addr)
 {
 	u8 v;
 	const u32 *p = (const u32 *)addr;
@@ -30,10 +25,15 @@ static inline int variable_test_bit(int nr, const void *addr)
 	return v;
 }
 
-#define test_bit(nr,addr) \
-(__builtin_constant_p(nr) ? \
- constant_test_bit((nr),(addr)) : \
- variable_test_bit((nr),(addr)))
+static __always_inline int test_bit(int nr, const volatile unsigned long *addr)
+{
+	if (__builtin_constant_p(nr)) {
+		return ((1UL << (nr % BITS_PER_LONG)) &
+			(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
+	}
+
+	return variable_test_bit(nr, addr);	
+}
 
 static inline void set_bit(int nr, void *addr)
 {
diff --git a/include/asm-x86/bitops.h b/include/asm-x86/bitops.h
index b81a4d4..85dc2e7 100644
--- a/include/asm-x86/bitops.h
+++ b/include/asm-x86/bitops.h
@@ -266,13 +266,7 @@ static inline int test_and_change_bit(int nr, volatile void *addr)
 	return oldbit;
 }
 
-static inline int constant_test_bit(int nr, const volatile void *addr)
-{
-	return ((1UL << (nr % BITS_PER_LONG)) &
-		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
-}
-
-static inline int variable_test_bit(int nr, volatile const void *addr)
+static inline int variable_test_bit(int nr, const volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -285,19 +279,20 @@ static inline int variable_test_bit(int nr, volatile const void *addr)
 	return oldbit;
 }
 
-#if 0 /* Fool kernel-doc since it doesn't do macros yet */
 /**
  * test_bit - Determine whether a bit is set
  * @nr: bit number to test
  * @addr: Address to start counting from
  */
-static int test_bit(int nr, const volatile unsigned long *addr);
-#endif
+static __always_inline int test_bit(int nr, const volatile unsigned long *addr)
+{
+	if (__builtin_constant_p(nr)) {
+		return ((1UL << (nr % BITS_PER_LONG)) &
+			(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
+	}
 
-#define test_bit(nr, addr)			\
-	(__builtin_constant_p((nr))		\
-	 ? constant_test_bit((nr), (addr))	\
-	 : variable_test_bit((nr), (addr)))
+	return variable_test_bit(nr, addr);	
+}
 
 /**
  * __ffs - find first set bit in word

