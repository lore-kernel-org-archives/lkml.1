Return-Path: <linux-kernel-owner+w=401wt.eu-S1762243AbXEPKUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762243AbXEPKUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 06:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759033AbXEPKUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 06:20:18 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:63637 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758549AbXEPKUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 06:20:16 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: wux@landicorp.com, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] atmel_spi: Pass correct DMA address to controller
Date: Wed, 16 May 2007 12:19:49 +0200
Message-Id: <11793107892086-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.4.4.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When either rx_buf or tx_buf is not being used, i.e. for plain read-
or write operations, the atmel_spi uses a fixed-size DMA buffer
instead. If the transfer is longer than the size of this buffer, it is
split into multiple DMA transfers.

When the transfer is split like this, the atmel_spi driver ends up
using the same DMA address again and again even for the buffer that
came from the user, which is of course wrong. Fix this by adding the
number of bytes already transferred to the DMA address so that the
data ends up in the right place.

Thanks to Wu Xuan for discovering this bug.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/spi/atmel_spi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
index 1d8a2f6..8b2601d 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -113,16 +113,16 @@ static void atmel_spi_next_xfer(struct spi_master *master,
 
 	len = as->remaining_bytes;
 
-	tx_dma = xfer->tx_dma;
-	rx_dma = xfer->rx_dma;
+	tx_dma = xfer->tx_dma + xfer->len - len;
+	rx_dma = xfer->rx_dma + xfer->len - len;
 
 	/* use scratch buffer only when rx or tx data is unspecified */
-	if (rx_dma == INVALID_DMA_ADDRESS) {
+	if (!xfer->rx_buf) {
 		rx_dma = as->buffer_dma;
 		if (len > BUFFER_SIZE)
 			len = BUFFER_SIZE;
 	}
-	if (tx_dma == INVALID_DMA_ADDRESS) {
+	if (!xfer->tx_buf) {
 		tx_dma = as->buffer_dma;
 		if (len > BUFFER_SIZE)
 			len = BUFFER_SIZE;
-- 
1.4.4.4

