Return-Path: <linux-kernel-owner+w=401wt.eu-S1761979AbXEUKJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761979AbXEUKJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbXEUKJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:11 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:5145 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460AbXEUKJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:09 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="30505436:sNHT24791445"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 09/32] Blackfin arch: DMA operation cleanup
Date: Mon, 21 May 2007 18:09:17 +0800
Message-Id: <11797421841321-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

1) Disable Interrupts during DMA memcpy to avoid raise conditions.
2) Mark MDMA channel 0 as reserved, since were using it internally.
3) Add DMA based equivalents for insX and outsX.
4) Our insX and outsX only handles len <= 2^16.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/bfin_dma_5xx.c |  204 ++++++++++++++++++++++++++++++++++-
 include/asm-blackfin/io.h           |   20 +++-
 2 files changed, 214 insertions(+), 10 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c b/arch/blackfin/kernel/bfin_dma_5xx.c
index 1431424..1c344ac 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -130,7 +130,9 @@ static int __init blackfin_dma_init(void)
 		dma_ch[i].regs = base_addr[i];
 		mutex_init(&(dma_ch[i].dmalock));
 	}
-
+	/* Mark MEMDMA Channel 0 as requested since we're using it internally */
+	dma_ch[CH_MEM_STREAM0_DEST].chan_status = DMA_CHANNEL_REQUESTED;
+	dma_ch[CH_MEM_STREAM0_SRC].chan_status = DMA_CHANNEL_REQUESTED;
 	return 0;
 }
 
@@ -598,9 +600,12 @@ void *dma_memcpy(void *dest, const void *src, size_t size)
 	int direction;	/* 1 - address decrease, 0 - address increase */
 	int flag_align;	/* 1 - address aligned,  0 - address unaligned */
 	int flag_2D;	/* 1 - 2D DMA needed,	 0 - 1D DMA needed */
+	unsigned long flags;
 
 	if (size <= 0)
 		return NULL;
+	
+	local_irq_save(flags);
 
 	if ((unsigned long)src < memory_end)
 		blackfin_dcache_flush_range((unsigned int)src,
@@ -725,6 +730,7 @@ void *dma_memcpy(void *dest, const void *src, size_t size)
 	if ((unsigned long)dest < memory_end)
 		blackfin_dcache_invalidate_range((unsigned int)dest,
 						 (unsigned int)(dest + size));
+	local_irq_restore(flags);
 
 	return dest;
 }
@@ -732,11 +738,201 @@ EXPORT_SYMBOL(dma_memcpy);
 
 void *safe_dma_memcpy(void *dest, const void *src, size_t size)
 {
-	int flags = 0;
 	void *addr;
-	local_irq_save(flags);
 	addr = dma_memcpy(dest, src, size);
-	local_irq_restore(flags);
 	return addr;
 }
 EXPORT_SYMBOL(safe_dma_memcpy);
+
+void dma_outsb(void __iomem *addr, const void *buf, unsigned short len)
+{
+
+	unsigned long flags;
+	
+	local_irq_save(flags);
+	
+	blackfin_dcache_flush_range((unsigned int)buf,(unsigned int)(buf) + len);
+
+   	bfin_write_MDMA_D0_START_ADDR(addr);
+	bfin_write_MDMA_D0_X_COUNT(len);
+	bfin_write_MDMA_D0_X_MODIFY(0);
+	bfin_write_MDMA_D0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+
+	bfin_write_MDMA_S0_START_ADDR(buf);
+	bfin_write_MDMA_S0_X_COUNT(len);
+	bfin_write_MDMA_S0_X_MODIFY(1);
+	bfin_write_MDMA_S0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+
+	bfin_write_MDMA_S0_CONFIG(DMAEN | WDSIZE_8);
+	bfin_write_MDMA_D0_CONFIG(WNR | DI_EN | DMAEN | WDSIZE_8);
+
+	while (!(bfin_read_MDMA_D0_IRQ_STATUS() & DMA_DONE));
+
+	bfin_write_MDMA_D0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+
+	bfin_write_MDMA_S0_CONFIG(0);
+	bfin_write_MDMA_D0_CONFIG(0);
+	local_irq_restore(flags);
+
+}
+EXPORT_SYMBOL(dma_outsb);
+
+
+void dma_insb(const void __iomem *addr, void *buf, unsigned short len)
+{
+	unsigned long flags;
+		
+	local_irq_save(flags);
+   	bfin_write_MDMA_D0_START_ADDR(buf);
+	bfin_write_MDMA_D0_X_COUNT(len);
+	bfin_write_MDMA_D0_X_MODIFY(1);
+	bfin_write_MDMA_D0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+
+	bfin_write_MDMA_S0_START_ADDR(addr);
+	bfin_write_MDMA_S0_X_COUNT(len);
+	bfin_write_MDMA_S0_X_MODIFY(0);
+	bfin_write_MDMA_S0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+
+	bfin_write_MDMA_S0_CONFIG(DMAEN | WDSIZE_8);
+	bfin_write_MDMA_D0_CONFIG(WNR | DI_EN | DMAEN | WDSIZE_8);
+
+	blackfin_dcache_invalidate_range((unsigned int)buf, (unsigned int)(buf) + len);
+
+	while (!(bfin_read_MDMA_D0_IRQ_STATUS() & DMA_DONE));
+
+	bfin_write_MDMA_D0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+
+	bfin_write_MDMA_S0_CONFIG(0);
+	bfin_write_MDMA_D0_CONFIG(0);
+	local_irq_restore(flags);
+
+}
+EXPORT_SYMBOL(dma_insb);
+
+void dma_outsw(void __iomem *addr, const void  *buf, unsigned short len)
+{
+	unsigned long flags;
+	
+	local_irq_save(flags);
+		
+	blackfin_dcache_flush_range((unsigned int)buf,(unsigned int)(buf) + len);
+
+   	bfin_write_MDMA_D0_START_ADDR(addr);
+	bfin_write_MDMA_D0_X_COUNT(len);
+	bfin_write_MDMA_D0_X_MODIFY(0);
+	bfin_write_MDMA_D0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+
+	bfin_write_MDMA_S0_START_ADDR(buf);
+	bfin_write_MDMA_S0_X_COUNT(len);
+	bfin_write_MDMA_S0_X_MODIFY(2);
+	bfin_write_MDMA_S0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+
+	bfin_write_MDMA_S0_CONFIG(DMAEN | WDSIZE_16);
+	bfin_write_MDMA_D0_CONFIG(WNR | DI_EN | DMAEN | WDSIZE_16);
+
+	while (!(bfin_read_MDMA_D0_IRQ_STATUS() & DMA_DONE));
+
+	bfin_write_MDMA_D0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+
+	bfin_write_MDMA_S0_CONFIG(0);
+	bfin_write_MDMA_D0_CONFIG(0);
+	local_irq_restore(flags);
+
+}
+EXPORT_SYMBOL(dma_outsw);
+
+void dma_insw(const void __iomem *addr, void *buf, unsigned short len)
+{
+	unsigned long flags;
+		
+	local_irq_save(flags);
+	
+   	bfin_write_MDMA_D0_START_ADDR(buf);
+	bfin_write_MDMA_D0_X_COUNT(len);
+	bfin_write_MDMA_D0_X_MODIFY(2);
+	bfin_write_MDMA_D0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+
+	bfin_write_MDMA_S0_START_ADDR(addr);
+	bfin_write_MDMA_S0_X_COUNT(len);
+	bfin_write_MDMA_S0_X_MODIFY(0);
+	bfin_write_MDMA_S0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+
+	bfin_write_MDMA_S0_CONFIG(DMAEN | WDSIZE_16);
+	bfin_write_MDMA_D0_CONFIG(WNR | DI_EN | DMAEN | WDSIZE_16);
+
+	blackfin_dcache_invalidate_range((unsigned int)buf, (unsigned int)(buf) + len);
+
+	while (!(bfin_read_MDMA_D0_IRQ_STATUS() & DMA_DONE));
+
+	bfin_write_MDMA_D0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+
+	bfin_write_MDMA_S0_CONFIG(0);
+	bfin_write_MDMA_D0_CONFIG(0);
+	local_irq_restore(flags);
+
+}
+EXPORT_SYMBOL(dma_insw);
+
+void dma_outsl(void __iomem *addr, const void *buf, unsigned short len)
+{
+	unsigned long flags;
+	
+	local_irq_save(flags);
+	
+	blackfin_dcache_flush_range((unsigned int)buf,(unsigned int)(buf) + len);
+
+   	bfin_write_MDMA_D0_START_ADDR(addr);
+	bfin_write_MDMA_D0_X_COUNT(len);
+	bfin_write_MDMA_D0_X_MODIFY(0);
+	bfin_write_MDMA_D0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+
+	bfin_write_MDMA_S0_START_ADDR(buf);
+	bfin_write_MDMA_S0_X_COUNT(len);
+	bfin_write_MDMA_S0_X_MODIFY(4);
+	bfin_write_MDMA_S0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+
+	bfin_write_MDMA_S0_CONFIG(DMAEN | WDSIZE_32);
+	bfin_write_MDMA_D0_CONFIG(WNR | DI_EN | DMAEN | WDSIZE_32);
+
+	while (!(bfin_read_MDMA_D0_IRQ_STATUS() & DMA_DONE));
+
+	bfin_write_MDMA_D0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+
+	bfin_write_MDMA_S0_CONFIG(0);
+	bfin_write_MDMA_D0_CONFIG(0);
+	local_irq_restore(flags);
+
+}
+EXPORT_SYMBOL(dma_outsl);
+
+void dma_insl(const void __iomem *addr, void *buf, unsigned short len)
+{
+	unsigned long flags;
+	
+	local_irq_save(flags);
+	
+   	bfin_write_MDMA_D0_START_ADDR(buf);
+	bfin_write_MDMA_D0_X_COUNT(len);
+	bfin_write_MDMA_D0_X_MODIFY(4);
+	bfin_write_MDMA_D0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+
+	bfin_write_MDMA_S0_START_ADDR(addr);
+	bfin_write_MDMA_S0_X_COUNT(len);
+	bfin_write_MDMA_S0_X_MODIFY(0);
+	bfin_write_MDMA_S0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+
+	bfin_write_MDMA_S0_CONFIG(DMAEN | WDSIZE_32);
+	bfin_write_MDMA_D0_CONFIG(WNR | DI_EN | DMAEN | WDSIZE_32);
+
+	blackfin_dcache_invalidate_range((unsigned int)buf, (unsigned int)(buf) + len);
+
+	while (!(bfin_read_MDMA_D0_IRQ_STATUS() & DMA_DONE));
+
+	bfin_write_MDMA_D0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+
+	bfin_write_MDMA_S0_CONFIG(0);
+	bfin_write_MDMA_D0_CONFIG(0);
+	local_irq_restore(flags);
+
+}
+EXPORT_SYMBOL(dma_insl);
diff --git a/include/asm-blackfin/io.h b/include/asm-blackfin/io.h
index 7e6995e..eac8bca 100644
--- a/include/asm-blackfin/io.h
+++ b/include/asm-blackfin/io.h
@@ -115,13 +115,21 @@ static inline unsigned int readl(void __iomem *addr)
 
 #ifndef __ASSEMBLY__
 
-extern void outsb(void __iomem *port, const void *addr, unsigned long count);
-extern void outsw(void __iomem *port, const void *addr, unsigned long count);
-extern void outsl(void __iomem *port, const void *addr, unsigned long count);
+extern void outsb(void __iomem *port, const void *addr, unsigned short count);
+extern void outsw(void __iomem *port, const void *addr, unsigned short count);
+extern void outsl(void __iomem *port, const void *addr, unsigned short count);
 
-extern void insb(const void __iomem *port, void *addr, unsigned long count);
-extern void insw(const void __iomem *port, void *addr, unsigned long count);
-extern void insl(const void __iomem *port, void *addr, unsigned long count);
+extern void insb(const void __iomem *port, void *addr, unsigned short count);
+extern void insw(const void __iomem *port, void *addr, unsigned short count);
+extern void insl(const void __iomem *port, void *addr, unsigned short count);
+
+extern void dma_outsb(void __iomem *port, const void *addr, unsigned short count);
+extern void dma_outsw(void __iomem *port, const void *addr, unsigned short count);
+extern void dma_outsl(void __iomem *port, const void *addr, unsigned short count);
+
+extern void dma_insb(const void __iomem *port, void *addr, unsigned short count);
+extern void dma_insw(const void __iomem *port, void *addr, unsigned short count);
+extern void dma_insl(const void __iomem *port, void *addr, unsigned short count);
 
 /*
  * Map some physical address range into the kernel address space.
-- 
1.5.1.2
