Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbYBXFvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbYBXFvQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 00:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbYBXFvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 00:51:04 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:15234 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbYBXFvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 00:51:02 -0500
Date: Sat, 23 Feb 2008 22:49:55 -0700
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] [POWERPC] mpc5200: fix build error on mpc52xx_psc_spi device
	driver
To: dbrownell@users.sourceforge.net, dragos.carp@toptica.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       spi-devel-general@lists.sourceforge.net
Message-id: <20080224054955.21886.79000.stgit@trillian.secretlab.ca>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
User-Agent: StGIT/0.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Commit id 94f389485e27641348c1951ab8d65157122a8939 (Separate MPC52xx PSC
FIOF regsiters from the rest of PSC) split the PSC fifo registers away
from the core PSC regs.  Doing so broke the mpc52xx_psc_spi driver.

This patch teaches the mpc52xx_psc_spi driver about the new PSC fifo
register definitions.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

---
This is a build error bug fix which needs to go into .25
---

 drivers/spi/mpc52xx_psc_spi.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/mpc52xx_psc_spi.c b/drivers/spi/mpc52xx_psc_spi.c
index 253ed56..a86315a 100644
--- a/drivers/spi/mpc52xx_psc_spi.c
+++ b/drivers/spi/mpc52xx_psc_spi.c
@@ -42,6 +42,7 @@ struct mpc52xx_psc_spi {
 
 	/* driver internal data */
 	struct mpc52xx_psc __iomem *psc;
+	struct mpc52xx_psc_fifo __iomem *fifo;
 	unsigned int irq;
 	u8 bits_per_word;
 	u8 busy;
@@ -139,6 +140,7 @@ static int mpc52xx_psc_spi_transfer_rxtx(struct spi_device *spi,
 {
 	struct mpc52xx_psc_spi *mps = spi_master_get_devdata(spi->master);
 	struct mpc52xx_psc __iomem *psc = mps->psc;
+	struct mpc52xx_psc_fifo __iomem *fifo = mps->fifo;
 	unsigned rb = 0;	/* number of bytes receieved */
 	unsigned sb = 0;	/* number of bytes sent */
 	unsigned char *rx_buf = (unsigned char *)t->rx_buf;
@@ -190,11 +192,11 @@ static int mpc52xx_psc_spi_transfer_rxtx(struct spi_device *spi,
 			out_8(&psc->mode, 0);
 		} else {
 			out_8(&psc->mode, MPC52xx_PSC_MODE_FFULL);
-			out_be16(&psc->rfalarm, rfalarm);
+			out_be16(&fifo->rfalarm, rfalarm);
 		}
 		out_be16(&psc->mpc52xx_psc_imr, MPC52xx_PSC_IMR_RXRDY);
 		wait_for_completion(&mps->done);
-		recv_at_once = in_be16(&psc->rfnum);
+		recv_at_once = in_be16(&fifo->rfnum);
 		dev_dbg(&spi->dev, "%d bytes received\n", recv_at_once);
 
 		send_at_once = recv_at_once;
@@ -331,6 +333,7 @@ static void mpc52xx_psc_spi_cleanup(struct spi_device *spi)
 static int mpc52xx_psc_spi_port_config(int psc_id, struct mpc52xx_psc_spi *mps)
 {
 	struct mpc52xx_psc __iomem *psc = mps->psc;
+	struct mpc52xx_psc_fifo __iomem *fifo = mps->fifo;
 	u32 mclken_div;
 	int ret = 0;
 
@@ -346,7 +349,7 @@ static int mpc52xx_psc_spi_port_config(int psc_id, struct mpc52xx_psc_spi *mps)
 	/* Disable interrupts, interrupts are based on alarm level */
 	out_be16(&psc->mpc52xx_psc_imr, 0);
 	out_8(&psc->command, MPC52xx_PSC_SEL_MODE_REG_1);
-	out_8(&psc->rfcntl, 0);
+	out_8(&fifo->rfcntl, 0);
 	out_8(&psc->mode, MPC52xx_PSC_MODE_FFULL);
 
 	/* Configure 8bit codec mode as a SPI master and use EOF flags */
@@ -419,6 +422,8 @@ static int __init mpc52xx_psc_spi_do_probe(struct device *dev, u32 regaddr,
 		ret = -EFAULT;
 		goto free_master;
 	}
+	/* On the 5200, fifo regs are immediately ajacent to the psc regs */
+	mps->fifo = ((void __iomem *)mps->psc) + sizeof(struct mpc52xx_psc);
 
 	ret = request_irq(mps->irq, mpc52xx_psc_spi_isr, 0, "mpc52xx-psc-spi",
 				mps);

