Return-Path: <linux-kernel-owner+w=401wt.eu-S1764243AbYCUXtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764243AbYCUXtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757917AbYCUXpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:45:54 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:60208 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757504AbYCUXpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:45:51 -0400
Message-Id: <20080321224406.987488959@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:27 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ned Forrester <nforrester@whoi.edu>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Russell King <rmk@arm.linux.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 37/76] spi: pxa2xx_spi clock polarity fix
Content-Disposition: inline; filename=spi-pxa2xx_spi-clock-polarity-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Ned Forrester <nforrester@whoi.edu>

Fixes a sequencing bug in spi driver pxa2xx_spi.c in which the chip select
for a transfer may be asserted before the clock polarity is set on the
interface.  As a result of this bug, the clock signal may have the wrong
polarity at transfer start, so it may need to make an extra half transition
before the intended clock/data signals begin.  (This probably means all
transfers are one bit out of sequence.)

This only occurs on the first transfer following a change in clock polarity
in systems using more than one more than one such polarity.  The fix
assures that the clock mode is properly set before asserting chip select.

This bug was introduced in a patch merged on 2006/12/10, kernel 2.6.20.
The patch defines an additional bit in: include/asm-arm/arch-pxa/regs-ssp.h
for 2.6.25 and newer kernels but this addition must be made in:
include/asm-arm/arch-pxa/pxa-regs.h for kernels between 2.6.20 and 2.6.24,
inclusive

Signed-off-by: Ned Forrester <nforrester@whoi.edu>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[chrisw@sous-sol.org: backport to 2.6.24.3]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/spi/pxa2xx_spi.c            |   41 +++++++++++++++++++++++-------------
 include/asm-arm/arch-pxa/pxa-regs.h |    1 
 2 files changed, 28 insertions(+), 14 deletions(-)

--- a/drivers/spi/pxa2xx_spi.c
+++ b/drivers/spi/pxa2xx_spi.c
@@ -48,13 +48,19 @@ MODULE_LICENSE("GPL");
 #define RESET_DMA_CHANNEL (DCSR_NODESC | DMA_INT_MASK)
 #define IS_DMA_ALIGNED(x) (((u32)(x)&0x07)==0)
 
-/* for testing SSCR1 changes that require SSP restart, basically
- * everything except the service and interrupt enables */
-#define SSCR1_CHANGE_MASK (SSCR1_TTELP | SSCR1_TTE | SSCR1_EBCEI | SSCR1_SCFR \
+/*
+ * for testing SSCR1 changes that require SSP restart, basically
+ * everything except the service and interrupt enables, the pxa270 developer
+ * manual says only SSCR1_SCFR, SSCR1_SPH, SSCR1_SPO need to be in this
+ * list, but the PXA255 dev man says all bits without really meaning the
+ * service and interrupt enables
+ */
+#define SSCR1_CHANGE_MASK (SSCR1_TTELP | SSCR1_TTE | SSCR1_SCFR \
 				| SSCR1_ECRA | SSCR1_ECRB | SSCR1_SCLKDIR \
-				| SSCR1_RWOT | SSCR1_TRAIL | SSCR1_PINTE \
-				| SSCR1_STRF | SSCR1_EFWR |SSCR1_RFT \
-				| SSCR1_TFT | SSCR1_SPH | SSCR1_SPO | SSCR1_LBM)
+				| SSCR1_SFRMDIR | SSCR1_RWOT | SSCR1_TRAIL \
+				| SSCR1_IFS | SSCR1_STRF | SSCR1_EFWR \
+				| SSCR1_RFT | SSCR1_TFT | SSCR1_MWDS \
+				| SSCR1_SPH | SSCR1_SPO | SSCR1_LBM)
 
 #define DEFINE_SSP_REG(reg, off) \
 static inline u32 read_##reg(void *p) { return __raw_readl(p + (off)); } \
@@ -961,9 +967,6 @@ static void pump_transfers(unsigned long
 		if (drv_data->ssp_type == PXA25x_SSP)
 			DCMD(drv_data->tx_channel) |= DCMD_ENDIRQEN;
 
-		/* Fix me, need to handle cs polarity */
-		drv_data->cs_control(PXA2XX_CS_ASSERT);
-
 		/* Clear status and start DMA engine */
 		cr1 = chip->cr1 | dma_thresh | drv_data->dma_cr1;
 		write_SSSR(drv_data->clear_sr, reg);
@@ -973,9 +976,6 @@ static void pump_transfers(unsigned long
 		/* Ensure we have the correct interrupt handler	*/
 		drv_data->transfer_handler = interrupt_transfer;
 
-		/* Fix me, need to handle cs polarity */
-		drv_data->cs_control(PXA2XX_CS_ASSERT);
-
 		/* Clear status  */
 		cr1 = chip->cr1 | chip->threshold | drv_data->int_cr1;
 		write_SSSR(drv_data->clear_sr, reg);
@@ -986,16 +986,29 @@ static void pump_transfers(unsigned long
 		|| (read_SSCR1(reg) & SSCR1_CHANGE_MASK) !=
 			(cr1 & SSCR1_CHANGE_MASK)) {
 
+		/* stop the SSP, and update the other bits */
 		write_SSCR0(cr0 & ~SSCR0_SSE, reg);
 		if (drv_data->ssp_type != PXA25x_SSP)
 			write_SSTO(chip->timeout, reg);
-		write_SSCR1(cr1, reg);
+		/* first set CR1 without interrupt and service enables */
+		write_SSCR1(cr1 & SSCR1_CHANGE_MASK, reg);
+		/* restart the SSP */
 		write_SSCR0(cr0, reg);
+
 	} else {
 		if (drv_data->ssp_type != PXA25x_SSP)
 			write_SSTO(chip->timeout, reg);
-		write_SSCR1(cr1, reg);
 	}
+
+	/* FIXME, need to handle cs polarity,
+	 * this driver uses struct pxa2xx_spi_chip.cs_control to
+	 * specify a CS handling function, and it ignores most
+	 * struct spi_device.mode[s], including SPI_CS_HIGH */
+	drv_data->cs_control(PXA2XX_CS_ASSERT);
+
+	/* after chip select, release the data by enabling service
+	 * requests and interrupts, without changing any mode bits */
+	write_SSCR1(cr1, reg);
 }
 
 static void pump_messages(struct work_struct *work)
--- a/include/asm-arm/arch-pxa/pxa-regs.h
+++ b/include/asm-arm/arch-pxa/pxa-regs.h
@@ -1669,6 +1669,7 @@
 #define SSCR1_RSRE		(1 << 20)	/* Receive Service Request Enable */
 #define SSCR1_TINTE		(1 << 19)	/* Receiver Time-out Interrupt enable */
 #define SSCR1_PINTE		(1 << 18)	/* Peripheral Trailing Byte Interupt Enable */
+#define SSCR1_IFS		(1 << 16)	/* Invert Frame Signal */
 #define SSCR1_STRF		(1 << 15)	/* Select FIFO or EFWR */
 #define SSCR1_EFWR		(1 << 14)	/* Enable FIFO Write/Read */
 

-- 
