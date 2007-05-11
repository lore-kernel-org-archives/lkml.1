Return-Path: <linux-kernel-owner+w=401wt.eu-S933490AbXEKSCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbXEKSCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 14:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932290AbXEKSCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 14:02:25 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:1893 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762572AbXEKSCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 14:02:23 -0400
Date: Fri, 11 May 2007 22:02:50 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Jay Estabrook <jay.estabrook@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ALPHA: correct low-level I/O routines for sable-lynx
Message-ID: <20070511220250.B16980@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Files:

include/asm-alpha/core_t2.h

This code corrects the behavior of the t2_readX/t2_writeX routines,
and t2_ioreadNN/t2_iowriteNN routines.

The value T2_DENSE_MEM is now subtracted from the "xaddr" argument in
each of the readX/writeX routines, since those routines may be called
directly, rather than always through the ioreadNN/iowriteNN routines.

Examples of the direct calls, via the __raw_readX/writeX macros, are
the memcpy_fromio/toio, _memset_c_io, and scr_memcpyw routines.


Signed-off-by: Jay Estabrook <jay.estabrook@hp.com>
Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>


diff -Naurp a/include/asm-alpha/core_t2.h b/include/asm-alpha/core_t2.h
--- a/include/asm-alpha/core_t2.h	2007-02-04 13:44:54.000000000 -0500
+++ b/include/asm-alpha/core_t2.h	2007-05-04 14:05:12.000000000 -0400
@@ -437,9 +437,15 @@ static inline void t2_outl(u32 b, unsign
 
 static DEFINE_SPINLOCK(t2_hae_lock);
 
+/*
+ * NOTE: take T2_DENSE_MEM off in each readX/writeX routine, since
+ *       they may be called directly, rather than through the
+ *       ioreadNN/iowriteNN routines.
+ */
+
 __EXTERN_INLINE u8 t2_readb(const volatile void __iomem *xaddr)
 {
-	unsigned long addr = (unsigned long) xaddr;
+	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
 	unsigned long result, msb;
 	unsigned long flags;
 	spin_lock_irqsave(&t2_hae_lock, flags);
@@ -453,7 +459,7 @@ __EXTERN_INLINE u8 t2_readb(const volati
 
 __EXTERN_INLINE u16 t2_readw(const volatile void __iomem *xaddr)
 {
-	unsigned long addr = (unsigned long) xaddr;
+	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
 	unsigned long result, msb;
 	unsigned long flags;
 	spin_lock_irqsave(&t2_hae_lock, flags);
@@ -471,7 +477,7 @@ __EXTERN_INLINE u16 t2_readw(const volat
  */
 __EXTERN_INLINE u32 t2_readl(const volatile void __iomem *xaddr)
 {
-	unsigned long addr = (unsigned long) xaddr;
+	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
 	unsigned long result, msb;
 	unsigned long flags;
 	spin_lock_irqsave(&t2_hae_lock, flags);
@@ -485,7 +491,7 @@ __EXTERN_INLINE u32 t2_readl(const volat
 
 __EXTERN_INLINE u64 t2_readq(const volatile void __iomem *xaddr)
 {
-	unsigned long addr = (unsigned long) xaddr;
+	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
 	unsigned long r0, r1, work, msb;
 	unsigned long flags;
 	spin_lock_irqsave(&t2_hae_lock, flags);
@@ -501,7 +507,7 @@ __EXTERN_INLINE u64 t2_readq(const volat
 
 __EXTERN_INLINE void t2_writeb(u8 b, volatile void __iomem *xaddr)
 {
-	unsigned long addr = (unsigned long) xaddr;
+	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
 	unsigned long msb, w;
 	unsigned long flags;
 	spin_lock_irqsave(&t2_hae_lock, flags);
@@ -515,7 +521,7 @@ __EXTERN_INLINE void t2_writeb(u8 b, vol
 
 __EXTERN_INLINE void t2_writew(u16 b, volatile void __iomem *xaddr)
 {
-	unsigned long addr = (unsigned long) xaddr;
+	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
 	unsigned long msb, w;
 	unsigned long flags;
 	spin_lock_irqsave(&t2_hae_lock, flags);
@@ -533,7 +539,7 @@ __EXTERN_INLINE void t2_writew(u16 b, vo
  */
 __EXTERN_INLINE void t2_writel(u32 b, volatile void __iomem *xaddr)
 {
-	unsigned long addr = (unsigned long) xaddr;
+	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
 	unsigned long msb;
 	unsigned long flags;
 	spin_lock_irqsave(&t2_hae_lock, flags);
@@ -546,7 +552,7 @@ __EXTERN_INLINE void t2_writel(u32 b, vo
 
 __EXTERN_INLINE void t2_writeq(u64 b, volatile void __iomem *xaddr)
 {
-	unsigned long addr = (unsigned long) xaddr;
+	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
 	unsigned long msb, work;
 	unsigned long flags;
 	spin_lock_irqsave(&t2_hae_lock, flags);
@@ -587,14 +593,14 @@ __EXTERN_INLINE int t2_is_mmio(const vol
 __EXTERN_INLINE unsigned int t2_ioread##NS(void __iomem *xaddr)		\
 {									\
 	if (t2_is_mmio(xaddr))						\
-		return t2_read##OS(xaddr - T2_DENSE_MEM);		\
+		return t2_read##OS(xaddr);				\
 	else								\
 		return t2_in##OS((unsigned long)xaddr - T2_IO);		\
 }									\
 __EXTERN_INLINE void t2_iowrite##NS(u##NS b, void __iomem *xaddr)	\
 {									\
 	if (t2_is_mmio(xaddr))						\
-		t2_write##OS(b, xaddr - T2_DENSE_MEM);			\
+		t2_write##OS(b, xaddr);					\
 	else								\
 		t2_out##OS(b, (unsigned long)xaddr - T2_IO);		\
 }
