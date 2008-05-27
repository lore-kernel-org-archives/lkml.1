Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbYE0Qrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbYE0Qrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757691AbYE0Qrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:47:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757675AbYE0Qrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:47:36 -0400
Date: Tue, 27 May 2008 09:47:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
In-Reply-To: <alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805270943100.2958@woody.linux-foundation.org>
References: <1211852026.3286.36.camel@pasglop>  <20080526.184047.88207142.davem@davemloft.net>  <1211854540.3286.42.camel@pasglop>  <20080526.192812.184590464.davem@davemloft.net> <1211859542.3286.46.camel@pasglop>
 <alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 May 2008, Linus Torvalds wrote:
> 
> Expecting people to fix up all drivers is simply not going to happen. And 
> serializing things shouldn't be *that* expensive. People who cannot take 
> the expense can continue to use the magic __raw_writel() etc stuff.

Of course, for non-x86, you kind of have to expect drivers to be 
well-behaved, so non-x86 can probably avoid this simply because there are 
less relevant drivers involved.

Here's a UNTESTED patch for x86 that may or may not compile and work, and 
which serializes (on a compiler level) the IO accesses against regular 
memory accesses.

__read[bwlq]()/__write[bwlq]() are not serialized with a :"memory" 
barrier, although since they still use "asm volatile" I suspect that i 
practice they are probably serial too. Did not look very closely at any 
generated code (only did a trivial test to see that the code looks 
*roughly* correct).

		Linus

---
 include/asm-x86/io.h    |   56 +++++++++++++++++++++++++++++++++++++
 include/asm-x86/io_32.h |   49 --------------------------------
 include/asm-x86/io_64.h |   71 -----------------------------------------------
 3 files changed, 56 insertions(+), 120 deletions(-)

diff --git a/include/asm-x86/io.h b/include/asm-x86/io.h
index d5b11f6..8e9eca9 100644
--- a/include/asm-x86/io.h
+++ b/include/asm-x86/io.h
@@ -3,6 +3,62 @@
 
 #define ARCH_HAS_IOREMAP_WC
 
+#include <linux/compiler.h>
+
+#define build_mmio_read(name, size, type, reg, barrier) \
+static inline type name(const volatile void __iomem *addr) \
+{ type ret; asm volatile("mov" size " %1,%0":"=" reg (ret) \
+:"m" (*(volatile type __force *)addr) barrier); return ret; }
+
+#define build_mmio_write(name, size, type, reg, barrier) \
+static inline void name(type val, volatile void __iomem *addr) \
+{ asm volatile("mov" size " %0,%1": :reg (val), \
+"m" (*(volatile type __force *)addr) barrier); }
+
+build_mmio_read(readb, "b", unsigned char, "q", :"memory")
+build_mmio_read(readw, "w", unsigned short, "r", :"memory")
+build_mmio_read(readl, "l", unsigned int, "r", :"memory")
+
+build_mmio_read(__readb, "b", unsigned char, "q", )
+build_mmio_read(__readw, "w", unsigned short, "r", )
+build_mmio_read(__readl, "l", unsigned int, "r", )
+
+build_mmio_write(writeb, "b", unsigned char, "q", :"memory")
+build_mmio_write(writew, "w", unsigned short, "r", :"memory")
+build_mmio_write(writel, "l", unsigned int, "r", :"memory")
+
+build_mmio_write(__writeb, "b", unsigned char, "q", )
+build_mmio_write(__writew, "w", unsigned short, "r", )
+build_mmio_write(__writel, "l", unsigned int, "r", )
+
+#define readb_relaxed(a) __readb(a)
+#define readw_relaxed(a) __readw(a)
+#define readl_relaxed(a) __readl(a)
+#define __raw_readb __readb
+#define __raw_readw __readw
+#define __raw_readl __readl
+
+#define __raw_writeb __writeb
+#define __raw_writew __writew
+#define __raw_writel __writel
+
+#define mmiowb() barrier()
+
+#ifdef CONFIG_X86_64
+build_mmio_read(readq, "q", unsigned long, "r", :"memory")
+build_mmio_read(__readq, "q", unsigned long, "r", )
+build_mmio_write(writeq, "q", unsigned long, "r", :"memory")
+build_mmio_write(__writeq, "q", unsigned long, "r", )
+
+#define readq_relaxed(a) __readq(a)
+#define __raw_readq __readq
+#define __raw_writeq writeq
+
+/* Let people know we have them */
+#define readq readq
+#define writeq writeq
+#endif
+
 #ifdef CONFIG_X86_32
 # include "io_32.h"
 #else
diff --git a/include/asm-x86/io_32.h b/include/asm-x86/io_32.h
index 049e81e..d71be8d 100644
--- a/include/asm-x86/io_32.h
+++ b/include/asm-x86/io_32.h
@@ -149,55 +149,6 @@ extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 #define virt_to_bus virt_to_phys
 #define bus_to_virt phys_to_virt
 
-/*
- * readX/writeX() are used to access memory mapped devices. On some
- * architectures the memory mapped IO stuff needs to be accessed
- * differently. On the x86 architecture, we just read/write the
- * memory location directly.
- */
-
-static inline unsigned char readb(const volatile void __iomem *addr)
-{
-	return *(volatile unsigned char __force *)addr;
-}
-
-static inline unsigned short readw(const volatile void __iomem *addr)
-{
-	return *(volatile unsigned short __force *)addr;
-}
-
-static inline unsigned int readl(const volatile void __iomem *addr)
-{
-	return *(volatile unsigned int __force *) addr;
-}
-
-#define readb_relaxed(addr) readb(addr)
-#define readw_relaxed(addr) readw(addr)
-#define readl_relaxed(addr) readl(addr)
-#define __raw_readb readb
-#define __raw_readw readw
-#define __raw_readl readl
-
-static inline void writeb(unsigned char b, volatile void __iomem *addr)
-{
-	*(volatile unsigned char __force *)addr = b;
-}
-
-static inline void writew(unsigned short b, volatile void __iomem *addr)
-{
-	*(volatile unsigned short __force *)addr = b;
-}
-
-static inline void writel(unsigned int b, volatile void __iomem *addr)
-{
-	*(volatile unsigned int __force *)addr = b;
-}
-#define __raw_writeb writeb
-#define __raw_writew writew
-#define __raw_writel writel
-
-#define mmiowb()
-
 static inline void
 memset_io(volatile void __iomem *addr, unsigned char val, int count)
 {
diff --git a/include/asm-x86/io_64.h b/include/asm-x86/io_64.h
index 0930bed..ddd8058 100644
--- a/include/asm-x86/io_64.h
+++ b/include/asm-x86/io_64.h
@@ -204,77 +204,6 @@ extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 #define virt_to_bus virt_to_phys
 #define bus_to_virt phys_to_virt
 
-/*
- * readX/writeX() are used to access memory mapped devices. On some
- * architectures the memory mapped IO stuff needs to be accessed
- * differently. On the x86 architecture, we just read/write the
- * memory location directly.
- */
-
-static inline __u8 __readb(const volatile void __iomem *addr)
-{
-	return *(__force volatile __u8 *)addr;
-}
-
-static inline __u16 __readw(const volatile void __iomem *addr)
-{
-	return *(__force volatile __u16 *)addr;
-}
-
-static __always_inline __u32 __readl(const volatile void __iomem *addr)
-{
-	return *(__force volatile __u32 *)addr;
-}
-
-static inline __u64 __readq(const volatile void __iomem *addr)
-{
-	return *(__force volatile __u64 *)addr;
-}
-
-#define readb(x) __readb(x)
-#define readw(x) __readw(x)
-#define readl(x) __readl(x)
-#define readq(x) __readq(x)
-#define readb_relaxed(a) readb(a)
-#define readw_relaxed(a) readw(a)
-#define readl_relaxed(a) readl(a)
-#define readq_relaxed(a) readq(a)
-#define __raw_readb readb
-#define __raw_readw readw
-#define __raw_readl readl
-#define __raw_readq readq
-
-#define mmiowb()
-
-static inline void __writel(__u32 b, volatile void __iomem *addr)
-{
-	*(__force volatile __u32 *)addr = b;
-}
-
-static inline void __writeq(__u64 b, volatile void __iomem *addr)
-{
-	*(__force volatile __u64 *)addr = b;
-}
-
-static inline void __writeb(__u8 b, volatile void __iomem *addr)
-{
-	*(__force volatile __u8 *)addr = b;
-}
-
-static inline void __writew(__u16 b, volatile void __iomem *addr)
-{
-	*(__force volatile __u16 *)addr = b;
-}
-
-#define writeq(val, addr) __writeq((val), (addr))
-#define writel(val, addr) __writel((val), (addr))
-#define writew(val, addr) __writew((val), (addr))
-#define writeb(val, addr) __writeb((val), (addr))
-#define __raw_writeb writeb
-#define __raw_writew writew
-#define __raw_writel writel
-#define __raw_writeq writeq
-
 void __memcpy_fromio(void *, unsigned long, unsigned);
 void __memcpy_toio(unsigned long, const void *, unsigned);
 
