Return-Path: <linux-kernel-owner+w=401wt.eu-S1763370AbXGTDdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763370AbXGTDdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbXGTDdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:33:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35614 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762662AbXGTDc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:32:59 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 2/8] m68k iomem (based on Geert's tree + memcpy_... stuff)
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Message-Id: <E1IBjEg-0004kX-55@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 20 Jul 2007 04:32:58 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m68k/Kconfig         |    4 ++
 include/asm-m68k/io.h     |   75 +++++++++++++++++++++++++++++++++++++-------
 include/asm-m68k/raw_io.h |    8 +++-
 3 files changed, 73 insertions(+), 14 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index a86e2e9..684de4c 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -37,6 +37,10 @@ config TIME_LOW_RES
 	bool
 	default y
 
+config GENERIC_IOMAP
+	bool
+	default y
+
 config ARCH_MAY_HAVE_PC_FDC
 	bool
 	depends on Q40 || (BROKEN && SUN3X)
diff --git a/include/asm-m68k/io.h b/include/asm-m68k/io.h
index 5e0fcf4..47bb9cf 100644
--- a/include/asm-m68k/io.h
+++ b/include/asm-m68k/io.h
@@ -27,6 +27,7 @@
 #include <asm/raw_io.h>
 #include <asm/virtconvert.h>
 
+#include <asm-generic/iomap.h>
 
 #ifdef CONFIG_ATARI
 #include <asm/atarihw.h>
@@ -152,6 +153,16 @@ static inline u16 __iomem *isa_itw(unsigned long addr)
     default: return NULL; /* avoid warnings, just in case */
     }
 }
+static inline u32 __iomem *isa_itl(unsigned long addr)
+{
+  switch(ISA_TYPE)
+    {
+#ifdef CONFIG_AMIGA_PCMCIA
+    case AG_ISA: return (u32 __iomem *)AG_ISA_IO_W(addr);
+#endif
+    default: return 0; /* avoid warnings, just in case */
+    }
+}
 static inline u8 __iomem *isa_mtb(unsigned long addr)
 {
   switch(ISA_TYPE)
@@ -188,8 +199,10 @@ static inline u16 __iomem *isa_mtw(unsigned long addr)
 
 #define isa_inb(port)      in_8(isa_itb(port))
 #define isa_inw(port)      (ISA_SEX ? in_be16(isa_itw(port)) : in_le16(isa_itw(port)))
+#define isa_inl(port)      (ISA_SEX ? in_be32(isa_itl(port)) : in_le32(isa_itl(port)))
 #define isa_outb(val,port) out_8(isa_itb(port),(val))
 #define isa_outw(val,port) (ISA_SEX ? out_be16(isa_itw(port),(val)) : out_le16(isa_itw(port),(val)))
+#define isa_outl(val,port) (ISA_SEX ? out_be32(isa_itl(port),(val)) : out_le32(isa_itl(port),(val)))
 
 #define isa_readb(p)       in_8(isa_mtb((unsigned long)(p)))
 #define isa_readw(p)       \
@@ -234,6 +247,15 @@ static inline void isa_delay(void)
 #define isa_outsw(port, buf, nr)    \
        (ISA_SEX ? raw_outsw(isa_itw(port), (u16 *)(buf), (nr)) :  \
                   raw_outsw_swapw(isa_itw(port), (u16 *)(buf), (nr)))
+
+#define isa_insl(port, buf, nr)     \
+       (ISA_SEX ? raw_insl(isa_itl(port), (u32 *)(buf), (nr)) :    \
+                  raw_insw_swapw(isa_itw(port), (u16 *)(buf), (nr)<<1))
+
+#define isa_outsl(port, buf, nr)    \
+       (ISA_SEX ? raw_outsl(isa_itl(port), (u32 *)(buf), (nr)) :  \
+                  raw_outsw_swapw(isa_itw(port), (u16 *)(buf), (nr)<<1))
+
 #endif  /* CONFIG_ISA */
 
 
@@ -246,14 +268,16 @@ static inline void isa_delay(void)
 #define inw_p   isa_inw_p
 #define outw    isa_outw
 #define outw_p  isa_outw_p
-#define inl     isa_inw
-#define inl_p   isa_inw_p
-#define outl    isa_outw
-#define outl_p  isa_outw_p
+#define inl     isa_inl
+#define inl_p   isa_inl_p
+#define outl    isa_outl
+#define outl_p  isa_outl_p
 #define insb    isa_insb
 #define insw    isa_insw
+#define insl    isa_insl
 #define outsb   isa_outsb
 #define outsw   isa_outsw
+#define outsl   isa_outsl
 #define readb   isa_readb
 #define readw   isa_readw
 #define writeb  isa_writeb
@@ -262,8 +286,6 @@ static inline void isa_delay(void)
 
 #if defined(CONFIG_PCI)
 
-#define inl(port)        in_le32(port)
-#define outl(val,port)   out_le32((port),(val))
 #define readl(addr)      in_le32(addr)
 #define writel(val,addr) out_le32((addr),(val))
 
@@ -282,6 +304,8 @@ static inline void isa_delay(void)
 #define outb(val,port) out_8((port),(val))
 #define inw(port)      in_le16(port)
 #define outw(val,port) out_le16((port),(val))
+#define inl(port)      in_le32(port)
+#define outl(val,port) out_le32((port),(val))
 
 #else
 /*
@@ -306,20 +330,35 @@ static inline void isa_delay(void)
 #endif
 #endif /* CONFIG_PCI */
 
-#if !defined(CONFIG_ISA) && !defined(CONFIG_PCI) && defined(CONFIG_HP300)
+#if !defined(CONFIG_ISA) && !defined(CONFIG_PCI)
 /*
- * We need to define dummy functions otherwise drivers/serial/8250.c doesn't link
+ * We need to define dummy functions for GENERIC_IOMAP support.
  */
-#define inb(port)        0xff
-#define inb_p(port)      0xff
-#define outb(val,port)   do { } while (0)
-#define outb_p(val,port) do { } while (0)
+#define inb(port)          0xff
+#define inb_p(port)        0xff
+#define outb(val,port)     ((void)0)
+#define outb_p(val,port)   ((void)0)
+#define inw(port)          0xffff
+#define outw(val,port)     ((void)0)
+#define inl(port)          0xffffffffUL
+#define outl(val,port)     ((void)0)
+
+#define insb(port,buf,nr)  ((void)0)
+#define outsb(port,buf,nr) ((void)0)
+#define insw(port,buf,nr)  ((void)0)
+#define outsw(port,buf,nr) ((void)0)
+#define insl(port,buf,nr)  ((void)0)
+#define outsl(port,buf,nr) ((void)0)
 
 /*
  * These should be valid on any ioremap()ed region
  */
 #define readb(addr)      in_8(addr)
 #define writeb(val,addr) out_8((addr),(val))
+#define readw(addr)      in_le16(addr)
+#define writew(val,addr) out_le16((addr),(val))
+#endif
+#if !defined(CONFIG_PCI)
 #define readl(addr)      in_le32(addr)
 #define writel(val,addr) out_le32((addr),(val))
 #endif
@@ -351,6 +390,18 @@ extern void dma_cache_wback_inv(unsigned long start, unsigned long size);
 extern void dma_cache_wback(unsigned long start, unsigned long size);
 extern void dma_cache_inv(unsigned long start, unsigned long size);
 
+static inline void memset_io(volatile void __iomem *addr, unsigned char val, int count)
+{
+	__builtin_memset((void __force *) addr, val, count);
+}
+static inline void memcpy_fromio(void *dst, const volatile void __iomem *src, int count)
+{
+	__builtin_memcpy(dst, (void __force *) src, count);
+}
+static inline void memcpy_toio(volatile void __iomem *dst, const void *src, int count)
+{
+	__builtin_memcpy((void __force *) dst, src, count);
+}
 
 #ifndef CONFIG_SUN3
 #define IO_SPACE_LIMIT 0xffff
diff --git a/include/asm-m68k/raw_io.h b/include/asm-m68k/raw_io.h
index 811ccd2..91c623f 100644
--- a/include/asm-m68k/raw_io.h
+++ b/include/asm-m68k/raw_io.h
@@ -49,10 +49,16 @@ extern void __iounmap(void *addr, unsigned long size);
 #define raw_inb in_8
 #define raw_inw in_be16
 #define raw_inl in_be32
+#define __raw_readb in_8
+#define __raw_readw in_be16
+#define __raw_readl in_be32
 
 #define raw_outb(val,port) out_8((port),(val))
 #define raw_outw(val,port) out_be16((port),(val))
 #define raw_outl(val,port) out_be32((port),(val))
+#define __raw_writeb(val,addr) out_8((addr),(val))
+#define __raw_writew(val,addr) out_be16((addr),(val))
+#define __raw_writel(val,addr) out_be32((addr),(val))
 
 static inline void raw_insb(volatile u8 __iomem *port, u8 *buf, unsigned int len)
 {
@@ -336,8 +342,6 @@ static inline void raw_outsw_swapw(volatile u16 __iomem *port, const u16 *buf,
 		: "d0", "a0", "a1", "d6");
 }
 
-#define __raw_writel raw_outl
-
 #endif /* __KERNEL__ */
 
 #endif /* _RAW_IO_H */
-- 
1.5.3.GIT


