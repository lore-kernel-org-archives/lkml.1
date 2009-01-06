Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbZAFMiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbZAFMiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 07:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZAFMiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 07:38:04 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:61482 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750775AbZAFMiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 07:38:02 -0500
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Andrew Victor" <avictor.za@gmail.com>,
       Itai Levi <itai.levi.devel@gmail.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] atmel_serial: Fix flow control bug
Date: Tue,  6 Jan 2009 13:37:21 +0100
Message-Id: <1231245441-9188-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Itai Levi <itai.levi.devel@gmail.com>

I am suggesting a patch to atmel_srial.c.
It fixes the following problem, related to hardware flow control
(CTS/RTS): Transmitting while CTS line is asserted in DMA mode, due to
not checking for tx-stopped condition.

We found these problems while testing the UARTs with hardware
flow-control.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/serial/atmel_serial.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index d5efd6c..89362d7 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -579,7 +579,7 @@ static void atmel_tx_dma(struct uart_port *port)
 	/* disable PDC transmit */
 	UART_PUT_PTCR(port, ATMEL_PDC_TXTDIS);
 
-	if (!uart_circ_empty(xmit)) {
+	if (!uart_circ_empty(xmit) && !uart_tx_stopped(port)) {
 		dma_sync_single_for_device(port->dev,
 					   pdc->dma_addr,
 					   pdc->dma_size,
-- 
1.5.6.3

