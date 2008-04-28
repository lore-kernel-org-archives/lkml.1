Return-Path: <linux-kernel-owner+w=401wt.eu-S934453AbYD1OFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934453AbYD1OFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933301AbYD1OFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:05:44 -0400
Received: from www.tglx.de ([62.245.132.106]:56811 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933246AbYD1OFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:05:43 -0400
Date: Mon, 28 Apr 2008 16:04:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] bitops: simplify generic bit finding functions
In-Reply-To: <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0804281534530.3261@apollo.tec.linutronix.de>
References: <1209327591.14173.74.camel@brick> <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008, Linus Torvalds wrote:
> On Sun, 27 Apr 2008, Harvey Harrison wrote:
> >
> > No need for a sentinal if we explicitly catch the no bits/all bits set
> > cases, make it clear they are special cases returning size/BITS_PER_LONG.
> 
> These things need to be re-done anyway. David already complained that the 
> thing inlines to something much much too big.

The delta between the inlined version including the constant
optimizations and the original non inlined version is exactly 1400
bytes on a sparc64 defconfig build.

> Let's just make it not be an inline at all.

Which makes the whole constant optimization moot.

How about making the optimization controlled by a config switch so
arch maintainers can decide whether they want to enable the constant
optimization or unconditionally call the lib function ?

See patch below. It gives back the 1400 bytes on SPARC64 and other
platforms that have no instruction for find bit.

Thanks,
	tglx

---------->

Subject: bitops: optional bitops mapsize optimization on config switch
From: Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 28 Apr 2008 00:22:06 +0200

The mapsize optimizations which were moved from x86 to the generic
code in commit 64970b68d2b3ed32b964b0b30b1b98518fde388e increased the
binary size on non x86 architectures.

Make the optimization depend on a config switch so architecture
maintainers can decide.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86/Kconfig.cpu   |    1 +
 include/linux/bitops.h |    6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/Kconfig.cpu
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig.cpu
+++ linux-2.6/arch/x86/Kconfig.cpu
@@ -282,6 +282,7 @@ config X86_CPU
 	def_bool y
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_FIND_NEXT_BIT
+	select GENERIC_FIND_BIT_MAPSIZE_OPTIMIZE
 
 config X86_GENERIC
 	bool "Generic x86 support"
Index: linux-2.6/include/linux/bitops.h
===================================================================
--- linux-2.6.orig/include/linux/bitops.h
+++ linux-2.6/include/linux/bitops.h
@@ -190,6 +190,7 @@ static __always_inline unsigned long
 find_next_bit(const unsigned long *addr, unsigned long size,
 		unsigned long offset)
 {
+#ifdef CONFIG_GENERIC_FIND_BIT_MAPSIZE_OPTIMIZE
 	unsigned long value;
 
 	/* Avoid a function call if the bitmap size is a constant */
@@ -209,7 +210,7 @@ find_next_bit(const unsigned long *addr,
 		value = (*addr) & ((~0ul) << offset);
 		return (value == 0) ? BITS_PER_LONG : __ffs(value);
 	}
-
+#endif
 	/* size is not constant or too big */
 	return __find_next_bit(addr, size, offset);
 }
@@ -227,6 +228,7 @@ static __always_inline unsigned long
 find_next_zero_bit(const unsigned long *addr, unsigned long size,
 		unsigned long offset)
 {
+#ifdef CONFIG_GENERIC_FIND_BIT_MAPSIZE_OPTIMIZE
 	unsigned long value;
 
 	/* Avoid a function call if the bitmap size is a constant */
@@ -246,7 +248,7 @@ find_next_zero_bit(const unsigned long *
 		value = (~(*addr)) & ((~0ul) << offset);
 		return (value == 0) ? BITS_PER_LONG : __ffs(value);
 	}
-
+#endif
 	/* size is not constant or too big */
 	return __find_next_zero_bit(addr, size, offset);
 }
