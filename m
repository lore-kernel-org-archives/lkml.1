Return-Path: <linux-kernel-owner+w=401wt.eu-S1759809AbYA3Jb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809AbYA3Jb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757357AbYA3JaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:30:24 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:62036 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbYA3JaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:30:17 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="61204645"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 05/12] [Blackfin] serial driver: Fix bug serial driver in DMA mode spams history to console on shell restart
Date: Wed, 30 Jan 2008 17:30:05 +0800
Message-Id: <1201685412-29095-6-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
References: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=2920
Fix by increasing buffer tail immediately before starting tx dma.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/serial/bfin_5xx.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 838f491..0074146 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -411,6 +411,10 @@ static void bfin_serial_dma_tx_chars(struct bfin_serial_port *uart)
 	set_dma_x_count(uart->tx_dma_channel, uart->tx_count);
 	set_dma_x_modify(uart->tx_dma_channel, 1);
 	enable_dma(uart->tx_dma_channel);
+
+	xmit->tail = (xmit->tail + uart->tx_count) & (UART_XMIT_SIZE - 1);
+	uart->port.icount.tx += uart->tx_count;
+
 #ifdef CONFIG_BF54x
 	UART_SET_IER(uart, ETBEI);
 #else
@@ -502,9 +506,6 @@ static irqreturn_t bfin_serial_dma_tx_int(int irq, void *dev_id)
 		ier &= ~ETBEI;
 		UART_PUT_IER(uart, ier);
 #endif
-		xmit->tail = (xmit->tail+uart->tx_count) &(UART_XMIT_SIZE -1);
-		uart->port.icount.tx+=uart->tx_count;
-
 		if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 			uart_write_wakeup(&uart->port);
 
-- 
1.5.3.4
