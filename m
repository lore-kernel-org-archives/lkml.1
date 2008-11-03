Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYKCLZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYKCLZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 06:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbYKCLZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 06:25:16 -0500
Received: from smtpeu1.atmel.com ([195.65.72.27]:48550 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873AbYKCLZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 06:25:14 -0500
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jean-Christophe Lallemand <jcl@develtech.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] atmel_spi: work-around required for new HW bug in AT91SAM9263 Rev.B SPI controller
Date: Mon,  3 Nov 2008 12:24:57 +0100
Message-Id: <1225711497-12913-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 03 Nov 2008 11:24:37.0535 (UTC) FILETIME=[C1666AF0:01C93DA6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe Lallemand <jcl@develtech.com>

We're working with an AT91SAM9263 Rev B in our design and I experienced
some inconsistency in spi-based touchscreen usage between our board and
the Atmel evaluation kit we have that runs on a Rev A chip. The data was
apparently delayed by 1 byte and got ridiculous data out of the
touchscreen driver, very strange. As everything looked normal in the
spi, touchscreen and dma logs, I contacted the Atmel support and they
triggered me on a new HW bug that appeared in the Rev B SPI controller.

The problem is that the SPI controller on the Rev B needs that the
software reset is performed two times so that it's performed correctly.

Applying the patch below solves the issue on my Rev B board. I've tested
it as well on my Rev A evaluation kit and it has apparently no unwanted
side effect, things continue to work as expected.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/spi/atmel_spi.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
index 02f9320..8abae4a 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -766,6 +766,7 @@ static int __init atmel_spi_probe(struct platform_device *pdev)
 	/* Initialize the hardware */
 	clk_enable(clk);
 	spi_writel(as, CR, SPI_BIT(SWRST));
+	spi_writel(as, CR, SPI_BIT(SWRST)); /* AT91SAM9263 Rev B workaround */
 	spi_writel(as, MR, SPI_BIT(MSTR) | SPI_BIT(MODFDIS));
 	spi_writel(as, PTCR, SPI_BIT(RXTDIS) | SPI_BIT(TXTDIS));
 	spi_writel(as, CR, SPI_BIT(SPIEN));
@@ -782,6 +783,7 @@ static int __init atmel_spi_probe(struct platform_device *pdev)
 
 out_reset_hw:
 	spi_writel(as, CR, SPI_BIT(SWRST));
+	spi_writel(as, CR, SPI_BIT(SWRST)); /* AT91SAM9263 Rev B workaround */
 	clk_disable(clk);
 	free_irq(irq, master);
 out_unmap_regs:
@@ -805,6 +807,7 @@ static int __exit atmel_spi_remove(struct platform_device *pdev)
 	spin_lock_irq(&as->lock);
 	as->stopping = 1;
 	spi_writel(as, CR, SPI_BIT(SWRST));
+	spi_writel(as, CR, SPI_BIT(SWRST)); /* AT91SAM9263 Rev B workaround */
 	spi_readl(as, SR);
 	spin_unlock_irq(&as->lock);
 
-- 
1.5.6.5

