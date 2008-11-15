Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbYKONV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbYKONV2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 08:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbYKONVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 08:21:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56380 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217AbYKONVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 08:21:17 -0500
To: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_OPTIMIZE_INLINING fun
From: Andi Kleen <andi@firstfloor.org>
References: <Pine.LNX.4.64.0811141804030.29883@blonde.site>
Date: Sat, 15 Nov 2008 14:21:19 +0100
In-Reply-To: <Pine.LNX.4.64.0811141804030.29883@blonde.site> (Hugh Dickins's message of "Fri, 14 Nov 2008 18:13:23 +0000 (GMT)")
Message-ID: <87zlk1yvjk.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hugh@veritas.com> writes:

> I'm wondering whether we need this patch: though perhaps it doesn't
> matter, since OPTIMIZE_INLINING is already under kernel hacking and
> defaulted off and there expressly for gathering feedback...
>
> --- 2.6.28-rc4/arch/x86/Kconfig.debug	2008-10-24 09:27:47.000000000 +0100
> +++ linux/arch/x86/Kconfig.debug	2008-11-14 16:26:15.000000000 +0000
> @@ -302,6 +302,7 @@ config CPA_DEBUG
>  
>  config OPTIMIZE_INLINING
>  	bool "Allow gcc to uninline functions marked 'inline'"
> +	depends on !CC_OPTIMIZE_FOR_SIZE
>  	help
>  	  This option determines if the kernel forces gcc to inline the functions
>  	  developers have marked 'inline'. Doing so takes away freedom from gcc to
>
> I've been building with CC_OPTIMIZE_FOR_SIZE=y and OPTIMIZE_INLINING=y
> for a while, but I've now taken OPTIMIZE_INLINING off, after noticing
> the 83 " Page" and 202 constant_test_bit functions in my System.map:
> it appears that the functions in include/linux/page-flags.h (perhaps
> others I've not noticed) make OPTIMIZE_INLINING behave very stupidly
> when CC_OPTIMIZE_FOR_SIZE is on (and somewhat even when off).

I believe newer gcc 4.3/4.4 have improved heuristics to fix this
case by eliminating code that gets optimized away better before
inlining. But that doesn't help with older compilers.

The right fix imho is to mark all of these functions which require 
inlining as __always_inline. In theory this would be all of bitops.h
but my understanding is that for inlines with only a single
asm statement the inliner heuristics in gcc already work well.
The problem is only in more complex functions like __constant_test_bit

Initial patch for bitops.h appended.

-Andi

---

Mark complex bitops.h inlines as __always_inline

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

Index: linux-2.6.28-rc4-test/arch/x86/include/asm/bitops.h
===================================================================
--- linux-2.6.28-rc4-test.orig/arch/x86/include/asm/bitops.h	2008-10-24 13:34:40.000000000 +0200
+++ linux-2.6.28-rc4-test/arch/x86/include/asm/bitops.h	2008-11-15 14:16:10.000000000 +0100
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
Index: linux-2.6.28-rc4-test/include/asm-generic/bitops/__ffs.h
===================================================================
--- linux-2.6.28-rc4-test.orig/include/asm-generic/bitops/__ffs.h	2006-04-03 16:06:13.000000000 +0200
+++ linux-2.6.28-rc4-test/include/asm-generic/bitops/__ffs.h	2008-11-15 14:18:01.000000000 +0100
@@ -9,7 +9,7 @@
  *
  * Undefined if no bit exists, so code should check against 0 first.
  */
-static inline unsigned long __ffs(unsigned long word)
+static __always_inline unsigned long __ffs(unsigned long word)
 {
 	int num = 0;
 
Index: linux-2.6.28-rc4-test/include/asm-generic/bitops/__fls.h
===================================================================
--- linux-2.6.28-rc4-test.orig/include/asm-generic/bitops/__fls.h	2008-05-08 12:56:05.000000000 +0200
+++ linux-2.6.28-rc4-test/include/asm-generic/bitops/__fls.h	2008-11-15 14:18:12.000000000 +0100
@@ -9,7 +9,7 @@
  *
  * Undefined if no set bit exists, so code should check against 0 first.
  */
-static inline unsigned long __fls(unsigned long word)
+static __always_inline unsigned long __fls(unsigned long word)
 {
 	int num = BITS_PER_LONG - 1;
 
Index: linux-2.6.28-rc4-test/include/asm-generic/bitops/fls.h
===================================================================
--- linux-2.6.28-rc4-test.orig/include/asm-generic/bitops/fls.h	2006-04-03 16:06:13.000000000 +0200
+++ linux-2.6.28-rc4-test/include/asm-generic/bitops/fls.h	2008-11-15 14:17:34.000000000 +0100
@@ -9,7 +9,7 @@
  * Note fls(0) = 0, fls(1) = 1, fls(0x80000000) = 32.
  */
 
-static inline int fls(int x)
+static __always_inline int fls(int x)
 {
 	int r = 32;
 
Index: linux-2.6.28-rc4-test/include/asm-generic/bitops/fls64.h
===================================================================
--- linux-2.6.28-rc4-test.orig/include/asm-generic/bitops/fls64.h	2008-05-08 12:56:05.000000000 +0200
+++ linux-2.6.28-rc4-test/include/asm-generic/bitops/fls64.h	2008-11-15 14:17:38.000000000 +0100
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


-- 
ak@linux.intel.com
