Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZFEINX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZFEINX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbZFEIGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:15 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37483 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbZFEIFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:33 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 21/62] Blackfin: fix early L1 relocation crash
Date: Fri,  5 Jun 2009 04:04:30 -0400
Message-Id: <1244189111-19639-22-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Our early L1 relocate code may implicitly call code which lives in L1
memory.  This is due to the dma_memcpy() rewrite that made the DMA code
lockless and safe to be used by multiple processes.  If we start the
early DMA memcpy to relocate things into L1 instruction but then our
DMA memcpy code calls a function that lives in L1, things fall apart.
As such, create a small dedicated DMA memcpy routine that we can assume
sanity at boot time.

Reported-by: Filip Van Rillaer <filip.vanrillaer@oneaccess-net.com>
Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/dma.h     |    2 +
 arch/blackfin/kernel/bfin_dma_5xx.c |   81 +++++++++++++++++++++++++++++++++++
 arch/blackfin/kernel/setup.c        |   51 ++++++++++++----------
 3 files changed, 111 insertions(+), 23 deletions(-)

diff --git a/arch/blackfin/include/asm/dma.h b/arch/blackfin/include/asm/dma.h
index e4f7b80..46c5618 100644
--- a/arch/blackfin/include/asm/dma.h
+++ b/arch/blackfin/include/asm/dma.h
@@ -253,5 +253,7 @@ static inline void clear_dma_irqstat(unsigned int channel)
 void *dma_memcpy(void *dest, const void *src, size_t count);
 void *safe_dma_memcpy(void *dest, const void *src, size_t count);
 void blackfin_dma_early_init(void);
+void early_dma_memcpy(void *dest, const void *src, size_t count);
+void early_dma_memcpy_done(void);
 
 #endif
diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c b/arch/blackfin/kernel/bfin_dma_5xx.c
index 8531693..704419e 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -232,6 +232,87 @@ void blackfin_dma_resume(void)
 void __init blackfin_dma_early_init(void)
 {
 	bfin_write_MDMA_S0_CONFIG(0);
+	bfin_write_MDMA_S1_CONFIG(0);
+}
+
+void __init early_dma_memcpy(void *pdst, const void *psrc, size_t size)
+{
+	unsigned long dst = (unsigned long)pdst;
+	unsigned long src = (unsigned long)psrc;
+	struct dma_register *dst_ch, *src_ch;
+
+	/* We assume that everything is 4 byte aligned, so include
+	 * a basic sanity check
+	 */
+	BUG_ON(dst % 4);
+	BUG_ON(src % 4);
+	BUG_ON(size % 4);
+
+	/* Force a sync in case a previous config reset on this channel
+	 * occurred.  This is needed so subsequent writes to DMA registers
+	 * are not spuriously lost/corrupted.
+	 */
+	__builtin_bfin_ssync();
+
+	src_ch = 0;
+	/* Find an avalible memDMA channel */
+	while (1) {
+		if (!src_ch || src_ch == (struct dma_register *)MDMA_S1_NEXT_DESC_PTR) {
+			dst_ch = (struct dma_register *)MDMA_D0_NEXT_DESC_PTR;
+			src_ch = (struct dma_register *)MDMA_S0_NEXT_DESC_PTR;
+		} else {
+			dst_ch = (struct dma_register *)MDMA_D1_NEXT_DESC_PTR;
+			src_ch = (struct dma_register *)MDMA_S1_NEXT_DESC_PTR;
+		}
+
+		if (!bfin_read16(&src_ch->cfg)) {
+			break;
+		} else {
+			if (bfin_read16(&src_ch->irq_status) & DMA_DONE)
+				bfin_write16(&src_ch->cfg, 0);
+		}
+
+	}
+
+	/* Destination */
+	bfin_write32(&dst_ch->start_addr, dst);
+	bfin_write16(&dst_ch->x_count, size >> 2);
+	bfin_write16(&dst_ch->x_modify, 1 << 2);
+	bfin_write16(&dst_ch->irq_status, DMA_DONE | DMA_ERR);
+
+	/* Source */
+	bfin_write32(&src_ch->start_addr, src);
+	bfin_write16(&src_ch->x_count, size >> 2);
+	bfin_write16(&src_ch->x_modify, 1 << 2);
+	bfin_write16(&src_ch->irq_status, DMA_DONE | DMA_ERR);
+
+	/* Enable */
+	bfin_write16(&src_ch->cfg, DMAEN | WDSIZE_32);
+	bfin_write16(&dst_ch->cfg, WNR | DI_EN | DMAEN | WDSIZE_32);
+
+	/* Since we are atomic now, don't use the workaround ssync */
+	__builtin_bfin_ssync();
+}
+
+void __init early_dma_memcpy_done(void)
+{
+	while ((bfin_read_MDMA_S0_CONFIG() && !(bfin_read_MDMA_D0_IRQ_STATUS() & DMA_DONE)) ||
+	       (bfin_read_MDMA_S1_CONFIG() && !(bfin_read_MDMA_D1_IRQ_STATUS() & DMA_DONE)))
+		continue;
+
+	bfin_write_MDMA_D0_IRQ_STATUS(DMA_DONE | DMA_ERR);
+	bfin_write_MDMA_D1_IRQ_STATUS(DMA_DONE | DMA_ERR);
+	/*
+	 * Now that DMA is done, we would normally flush cache, but
+	 * i/d cache isn't running this early, so we don't bother,
+	 * and just clear out the DMA channel for next time
+	 */
+	bfin_write_MDMA_S0_CONFIG(0);
+	bfin_write_MDMA_S1_CONFIG(0);
+	bfin_write_MDMA_D0_CONFIG(0);
+	bfin_write_MDMA_D1_CONFIG(0);
+
+	__builtin_bfin_ssync();
 }
 
 /**
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index a58687b..0838eaf 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -150,40 +150,45 @@ void __init bfin_relocate_l1_mem(void)
 	unsigned long l1_data_b_length;
 	unsigned long l2_length;
 
+	/*
+	 * due to the ALIGN(4) in the arch/blackfin/kernel/vmlinux.lds.S
+	 * we know that everything about l1 text/data is nice and aligned,
+	 * so copy by 4 byte chunks, and don't worry about overlapping
+	 * src/dest.
+	 *
+	 * We can't use the dma_memcpy functions, since they can call
+	 * scheduler functions which might be in L1 :( and core writes
+	 * into L1 instruction cause bad access errors, so we are stuck,
+	 * we are required to use DMA, but can't use the common dma
+	 * functions. We can't use memcpy either - since that might be
+	 * going to be in the relocated L1
+	 */
+
 	blackfin_dma_early_init();
 
+	/* if necessary, copy _stext_l1 to _etext_l1 to L1 instruction SRAM */
 	l1_code_length = _etext_l1 - _stext_l1;
-	if (l1_code_length > L1_CODE_LENGTH)
-		panic("L1 Instruction SRAM Overflow\n");
-	/* cannot complain as printk is not available as yet.
-	 * But we can continue booting and complain later!
-	 */
-
-	/* Copy _stext_l1 to _etext_l1 to L1 instruction SRAM */
-	dma_memcpy(_stext_l1, _l1_lma_start, l1_code_length);
+	if (l1_code_length)
+		early_dma_memcpy(_stext_l1, _l1_lma_start, l1_code_length);
 
+	/* if necessary, copy _sdata_l1 to _sbss_l1 to L1 data bank A SRAM */
 	l1_data_a_length = _sbss_l1 - _sdata_l1;
-	if (l1_data_a_length > L1_DATA_A_LENGTH)
-		panic("L1 Data SRAM Bank A Overflow\n");
-
-	/* Copy _sdata_l1 to _sbss_l1 to L1 data bank A SRAM */
-	dma_memcpy(_sdata_l1, _l1_lma_start + l1_code_length, l1_data_a_length);
+	if (l1_data_a_length)
+		early_dma_memcpy(_sdata_l1, _l1_lma_start + l1_code_length, l1_data_a_length);
 
+	/* if necessary, copy _sdata_b_l1 to _sbss_b_l1 to L1 data bank B SRAM */
 	l1_data_b_length = _sbss_b_l1 - _sdata_b_l1;
-	if (l1_data_b_length > L1_DATA_B_LENGTH)
-		panic("L1 Data SRAM Bank B Overflow\n");
-
-	/* Copy _sdata_b_l1 to _sbss_b_l1 to L1 data bank B SRAM */
-	dma_memcpy(_sdata_b_l1, _l1_lma_start + l1_code_length +
+	if (l1_data_b_length)
+		early_dma_memcpy(_sdata_b_l1, _l1_lma_start + l1_code_length +
 			l1_data_a_length, l1_data_b_length);
 
+	early_dma_memcpy_done();
+
+	/* if necessary, copy _stext_l2 to _edata_l2 to L2 SRAM */
 	if (L2_LENGTH != 0) {
 		l2_length = _sbss_l2 - _stext_l2;
-		if (l2_length > L2_LENGTH)
-			panic("L2 SRAM Overflow\n");
-
-		/* Copy _stext_l2 to _edata_l2 to L2 SRAM */
-		dma_memcpy(_stext_l2, _l2_lma_start, l2_length);
+		if (l2_length)
+			memcpy(_stext_l2, _l2_lma_start, l2_length);
 	}
 }
 
-- 
1.6.3.1

