Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbYGaRKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbYGaRKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 13:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYGaRKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 13:10:42 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:45842 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbYGaRKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 13:10:41 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: spi-devel-general@lists.sourceforge.net,
       Lars Steubesand <lars.steubesand@philips.com>,
       linux-kernel@vger.kernel.org, Gerard Kam <gerardk5@verizon.net>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] atmel_spi: fix hang due to missed interrupt
Date: Thu, 31 Jul 2008 19:10:13 +0200
Message-Id: <1217524213-4027-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.3
X-OriginalArrivalTime: 31 Jul 2008 17:10:13.0885 (UTC) FILETIME=[4BFC12D0:01C8F330]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerard Kam <gerardk5@verizon.net>

For some time my at91sam9260 board with JFFS2 on serial flash (m25p80) would
hang when accessing the serial flash and SPI bus.  Slowing the SPI clock
down to 9 MHz reduced the occurrence of the hang from "always" during boot
to a nuisance level that allowed other SW development to continue.  Finally
had to address this issue when an application stresses the I/O to always
cause a hang.

Hang seems to be caused by a missed SPI interrupt, so that the task ends up
waiting forever after calling spi_sync().  The fix has 2 parts.  First is to
halt the DMA engine before the "current" PDC registers are loaded.  This
ensures that the "next" registers are loaded before the DMA operation takes
off.  The second part of the fix is a kludge that adds a "completion"
interrupt in case the ENDRX interrupt for the last segment of the DMA
chaining operation was missed.

The patch allows the SPI clock for the serial flash to be increased from 9
MHz to 15 MHz (or more?).  No hangs or SPI overruns were encountered.

Signed-off-by: Gerard Kam <gerardk5@verizon.net>

While this patch does indeed improve things, I still see overruns and
CRC errors on my NGW100 board when running the DataFlash at 10 MHz.
However, I think some improvement is better than nothing, so I'm
passing this on for inclusion in 2.6.27.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/spi/atmel_spi.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
index 0c71656..95190c6 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -184,7 +184,8 @@ static void atmel_spi_next_xfer(struct spi_master *master,
 {
 	struct atmel_spi	*as = spi_master_get_devdata(master);
 	struct spi_transfer	*xfer;
-	u32			len, remaining, total;
+	u32			len, remaining;
+	u32			ieval;
 	dma_addr_t		tx_dma, rx_dma;
 
 	if (!as->current_transfer)
@@ -197,6 +198,8 @@ static void atmel_spi_next_xfer(struct spi_master *master,
 		xfer = NULL;
 
 	if (xfer) {
+		spi_writel(as, PTCR, SPI_BIT(RXTDIS) | SPI_BIT(TXTDIS));
+
 		len = xfer->len;
 		atmel_spi_next_xfer_data(master, xfer, &tx_dma, &rx_dma, &len);
 		remaining = xfer->len - len;
@@ -234,6 +237,8 @@ static void atmel_spi_next_xfer(struct spi_master *master,
 	as->next_transfer = xfer;
 
 	if (xfer) {
+		u32	total;
+
 		total = len;
 		atmel_spi_next_xfer_data(master, xfer, &tx_dma, &rx_dma, &len);
 		as->next_remaining_bytes = total - len;
@@ -250,9 +255,11 @@ static void atmel_spi_next_xfer(struct spi_master *master,
 			"  next xfer %p: len %u tx %p/%08x rx %p/%08x\n",
 			xfer, xfer->len, xfer->tx_buf, xfer->tx_dma,
 			xfer->rx_buf, xfer->rx_dma);
+		ieval = SPI_BIT(ENDRX) | SPI_BIT(OVRES);
 	} else {
 		spi_writel(as, RNCR, 0);
 		spi_writel(as, TNCR, 0);
+		ieval = SPI_BIT(RXBUFF) | SPI_BIT(ENDRX) | SPI_BIT(OVRES);
 	}
 
 	/* REVISIT: We're waiting for ENDRX before we start the next
@@ -265,7 +272,7 @@ static void atmel_spi_next_xfer(struct spi_master *master,
 	 *
 	 * It should be doable, though. Just not now...
 	 */
-	spi_writel(as, IER, SPI_BIT(ENDRX) | SPI_BIT(OVRES));
+	spi_writel(as, IER, ieval);
 	spi_writel(as, PTCR, SPI_BIT(TXTEN) | SPI_BIT(RXTEN));
 }
 
@@ -396,7 +403,7 @@ atmel_spi_interrupt(int irq, void *dev_id)
 
 		ret = IRQ_HANDLED;
 
-		spi_writel(as, IDR, (SPI_BIT(ENDTX) | SPI_BIT(ENDRX)
+		spi_writel(as, IDR, (SPI_BIT(RXBUFF) | SPI_BIT(ENDRX)
 				     | SPI_BIT(OVRES)));
 
 		/*
@@ -418,7 +425,7 @@ atmel_spi_interrupt(int irq, void *dev_id)
 		if (xfer->delay_usecs)
 			udelay(xfer->delay_usecs);
 
-		dev_warn(master->dev.parent, "fifo overrun (%u/%u remaining)\n",
+		dev_warn(master->dev.parent, "overrun (%u/%u remaining)\n",
 			 spi_readl(as, TCR), spi_readl(as, RCR));
 
 		/*
@@ -442,7 +449,7 @@ atmel_spi_interrupt(int irq, void *dev_id)
 		spi_readl(as, SR);
 
 		atmel_spi_msg_done(master, as, msg, -EIO, 0);
-	} else if (pending & SPI_BIT(ENDRX)) {
+	} else if (pending & (SPI_BIT(RXBUFF) | SPI_BIT(ENDRX))) {
 		ret = IRQ_HANDLED;
 
 		spi_writel(as, IDR, pending);
-- 
1.5.6.3

