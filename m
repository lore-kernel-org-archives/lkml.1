Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbZKJJM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbZKJJM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbZKJJM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:12:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34860 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbZKJJM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:12:27 -0500
From: Luotao Fu <l.fu@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       l.fu@pengutronix.de
Subject: [PATCH 1/3] mpc52xx_spi: fix clearing status register
Date: Tue, 10 Nov 2009 10:12:07 +0100
Message-Id: <1257844329-20687-2-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257844329-20687-1-git-send-email-l.fu@pengutronix.de>
References: <1257844329-20687-1-git-send-email-l.fu@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before reading status register to check MODF failure, we have to clear it
first since the MODF flag will be set after initializing the spi master,
if the hardware comes up with a low SS. The processor datasheet reads:
Mode Fault flag -- bit sets if SS input goes low while SPI is configured as a
master. Flag is cleared automatically by an SPI status register read (with MODF
set) followed by a SPI control register 1 write.
Hence simply rereading the register is not sufficient to clear the flag. We
redo the write also to make sure to clear the flag.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 drivers/spi/mpc52xx_spi.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/mpc52xx_spi.c b/drivers/spi/mpc52xx_spi.c
index ef8379b..5b036f2 100644
--- a/drivers/spi/mpc52xx_spi.c
+++ b/drivers/spi/mpc52xx_spi.c
@@ -391,6 +391,7 @@ static int __devinit mpc52xx_spi_probe(struct of_device *op,
 	struct mpc52xx_spi *ms;
 	void __iomem *regs;
 	int rc;
+	int ctrl1;
 
 	/* MMIO registers */
 	dev_dbg(&op->dev, "probing mpc5200 SPI device\n");
@@ -399,7 +400,8 @@ static int __devinit mpc52xx_spi_probe(struct of_device *op,
 		return -ENODEV;
 
 	/* initialize the device */
-	out_8(regs+SPI_CTRL1, SPI_CTRL1_SPIE | SPI_CTRL1_SPE | SPI_CTRL1_MSTR);
+	ctrl1 = SPI_CTRL1_SPIE | SPI_CTRL1_SPE | SPI_CTRL1_MSTR;
+	out_8(regs + SPI_CTRL1, ctrl1);
 	out_8(regs + SPI_CTRL2, 0x0);
 	out_8(regs + SPI_DATADIR, 0xe);	/* Set output pins */
 	out_8(regs + SPI_PORTDATA, 0x8);	/* Deassert /SS signal */
@@ -409,6 +411,8 @@ static int __devinit mpc52xx_spi_probe(struct of_device *op,
 	 * on the SPI bus.  This fault will also occur if the SPI signals
 	 * are not connected to any pins (port_config setting) */
 	in_8(regs + SPI_STATUS);
+	out_8(regs + SPI_CTRL1, ctrl1);
+
 	in_8(regs + SPI_DATA);
 	if (in_8(regs + SPI_STATUS) & SPI_STATUS_MODF) {
 		dev_err(&op->dev, "mode fault; is port_config correct?\n");
-- 
1.6.5.2

