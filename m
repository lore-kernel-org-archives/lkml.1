Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbYDAJrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbYDAJrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbYDAJrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:47:37 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:15823 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbYDAJrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:47:37 -0400
Date: Tue, 1 Apr 2008 11:46:19 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCH] x86: generic versions of find_first_(zero_)bit, convert i386
Message-ID: <20080401094618.GA24862@mailshack.com>
References: <20080331171506.GA24017@mailshack.com> <20080401084710.GB4787@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401084710.GB4787@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Tue, 01 Apr 2008 11:47:21 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.78; VDF: 7.0.3.100; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: generic versions of find_first_(zero_)bit, convert i386

Generic versions of __find_first_bit and __find_first_zero_bit
are introduced as simplified versions of __find_next_bit and
__find_next_zero_bit. Their compilation and use are guarded by
a new config variable GENERIC_FIND_FIRST_BIT.

The generic versions of find_first_bit and find_first_zero_bit
are implemented in terms of the newly introduced __find_first_bit
and __find_first_zero_bit.

This patch does not remove the i386-specific implementation,
but it does switch i386 to use the generic functions by setting
GENERIC_FIND_FIRST_BIT=y for X86_32.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>


 arch/x86/Kconfig            |    3 ++
 include/asm-x86/bitops_32.h |    2 +
 include/linux/bitops.h      |   34 +++++++++++++++++++++++++
 lib/Makefile                |    1 +
 lib/find_next_bit.c         |   58 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 98 insertions(+), 0 deletions(-)

---

> I guess we should keep the bitops.h portions alive for the moment 
> though (surrounded by #ifndef GENERIC_FIND_FIRST_BIT), to make it
> easy for anyone to flip the Kconfig bit around via a oneliner patch
> and do some benchmarking? At least initially - i'm convinced that
> we want the generic versions in the long run. (especially if, as
> your patches do it, the generic code picks up the easy constant
> tests and optimizes them at build time)
>
>        Ingo 

Keeping the old version alive for the moment is fine with me. Here
is a replacement patch that does exactly that. Runs on i386 with
this patch and also with GENERIC_FIND_FIRST_BIT=n.

I'll finish the patches for X86_64 and the constant-size bitmap
optimizations after work.

Greetings,
	Alexander

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
index 3ed64b2..ba2c0de 100644
--- a/include/asm-x86/bitops_32.h
+++ b/include/asm-x86/bitops_32.h
@@ -5,6 +5,7 @@
  * Copyright 1992, Linus Torvalds.
  */
 
+#ifndef CONFIG_GENERIC_FIND_FIRST_BIT
 /**
  * find_first_zero_bit - find the first zero bit in a memory region
  * @addr: The address to start the search at
@@ -59,6 +60,7 @@ static inline unsigned find_first_bit(const unsigned long *addr, unsigned size)
 	}
 	return x;
 }
+#endif
 
 #ifdef __KERNEL__
 
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
 
