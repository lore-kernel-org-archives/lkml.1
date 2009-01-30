Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbZA3XOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbZA3XOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbZA3XO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:14:29 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:14652 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbZA3XO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:14:29 -0500
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: :O2kGeEG7b/pS1EW8QnKjhhg/vO4pzqdNytm2/tv3UCjfco8bJsX/GzAObRbmhgZo
From: Michael Heimpold <michael@heimpold.de>
To: hskinnemoen@atmel.com
Subject: [PATCH] atmel_spi: Fix handling of chipselect after SPI transfer
Date: Sat, 31 Jan 2009 00:14:41 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901310014.41327.michael@heimpold.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to include/linux/spi/spi.h chipselect should stay active after a SPI
transfer or after a SPI message unless modified by
spi_transfer.cs_change != 0.

The current atmel driver passes this field to atmel_spi_msg_done as a
parameter with oppositional meaning: "cs_change" -> "stay" (see
atmel_spi_interrupt).

This patch fixes this behavoir by adapting the called function and its
callers. IMHO this solution is better than an one line fix of inverting the
function's argument as the meaning of the field remains throughout
the hole stack.

Signed-off-by: Michael Heimpold <mhei@heimpold.de>

---
 drivers/spi/atmel_spi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
index 8abae4a..6b8c020 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -351,9 +351,9 @@ static void atmel_spi_dma_unmap_xfer(struct spi_master *master,
 
 static void
 atmel_spi_msg_done(struct spi_master *master, struct atmel_spi *as,
-		struct spi_message *msg, int status, int stay)
+		struct spi_message *msg, int status, int cs_change)
 {
-	if (!stay || status < 0)
+	if (cs_change || status < 0)
 		cs_deactivate(as, msg->spi);
 	else
 		as->stay = msg->spi;
@@ -448,7 +448,7 @@ atmel_spi_interrupt(int irq, void *dev_id)
 		/* Clear any overrun happening while cleaning up */
 		spi_readl(as, SR);
 
-		atmel_spi_msg_done(master, as, msg, -EIO, 0);
+		atmel_spi_msg_done(master, as, msg, -EIO, 1);
 	} else if (pending & (SPI_BIT(RXBUFF) | SPI_BIT(ENDRX))) {
 		ret = IRQ_HANDLED;
 
-- 
1.5.4.3

