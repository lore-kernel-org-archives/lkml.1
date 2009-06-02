Return-Path: <linux-kernel-owner+w=401wt.eu-S1760484AbZFBHNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760484AbZFBHNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759478AbZFBHLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:11:54 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46640 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758919AbZFBHLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:11:51 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 09/11] Blackfin Serial Driver: annotate anomalies 05000215 and 05000099
Date: Tue,  2 Jun 2009 03:11:38 -0400
Message-Id: <1243926700-30485-9-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
References: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Add some comments for how these anomalies are addressed:

05000215 - UART TX Interrupt Masked Erroneously
We always clear ETBEI within last UART TX interrupt to end
a string.  It is always set when starting a new tx transfer.

05000099 - UART Line Status Register (UART_LSR) Bits Are Not Updated at
the Same Time
This anomaly affects driver only in POLL code where multi bits of
UART_LSR are checked. It doesn't affect current bfin_5xx.c driver.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/bfin_5xx.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 854e96d..ab583ef 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -330,6 +330,11 @@ static void bfin_serial_tx_chars(struct bfin_serial_port *uart)
 		/* Clear TFI bit */
 		UART_PUT_LSR(uart, TFI);
 #endif
+		/* Anomaly notes:
+		 *  05000215 -	we always clear ETBEI within last UART TX
+		 *		interrupt to end a string. It is always set
+		 *		when start a new tx.
+		 */
 		UART_CLEAR_IER(uart, ETBEI);
 		return;
 	}
@@ -528,6 +533,11 @@ static irqreturn_t bfin_serial_dma_tx_int(int irq, void *dev_id)
 	if (!(get_dma_curr_irqstat(uart->tx_dma_channel)&DMA_RUN)) {
 		disable_dma(uart->tx_dma_channel);
 		clear_dma_irqstat(uart->tx_dma_channel);
+		/* Anomaly notes:
+		 *  05000215 -	we always clear ETBEI within last UART TX
+		 *		interrupt to end a string. It is always set
+		 *		when start a new tx.
+		 */
 		UART_CLEAR_IER(uart, ETBEI);
 		xmit->tail = (xmit->tail + uart->tx_count) & (UART_XMIT_SIZE - 1);
 		uart->port.icount.tx += uart->tx_count;
@@ -969,6 +979,10 @@ static void bfin_serial_reset_irda(struct uart_port *port)
 }
 
 #ifdef CONFIG_CONSOLE_POLL
+/* Anomaly notes:
+ *  05000099 -  Because we only use THRE in poll_put and DR in poll_get,
+ *		losing other bits of UART_LSR is not a problem here.
+ */
 static void bfin_serial_poll_put_char(struct uart_port *port, unsigned char chr)
 {
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
-- 
1.6.3.1

