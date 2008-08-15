Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbYHOIOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbYHOIOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 04:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYHOIOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 04:14:16 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:57470 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbYHOIOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 04:14:15 -0400
X-IronPort-AV: E=Sophos;i="4.32,214,1217822400"; 
   d="scan'208";a="73535488"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/2] Blackfin Serial Driver: Fix bug - request UART2/3 peripheral mapped interrupts in PIO mode
Date: Fri, 15 Aug 2008 16:14:08 +0800
Message-Id: <1218788049-7632-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1218788049-7632-1-git-send-email-cooloney@kernel.org>
References: <1218788049-7632-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/kernel/bfin_dma_5xx.c |   13 ++++-----
 drivers/serial/bfin_5xx.c           |   50 +++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c b/arch/blackfin/kernel/bfin_dma_5xx.c
index 93229b3..339293d 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -117,15 +117,14 @@ int request_dma(unsigned int channel, char *device_id)
 
 #ifdef CONFIG_BF54x
 	if (channel >= CH_UART2_RX && channel <= CH_UART3_TX) {
-		if (strncmp(device_id, "BFIN_UART", 9) == 0) {
-			dma_ch[channel].regs->peripheral_map &= 0x0FFF;
-			dma_ch[channel].regs->peripheral_map |=
+		unsigned int per_map;
+		per_map = dma_ch[channel].regs->peripheral_map & 0xFFF;
+		if (strncmp(device_id, "BFIN_UART", 9) == 0)
+			dma_ch[channel].regs->peripheral_map = per_map |
 				((channel - CH_UART2_RX + 0xC)<<12);
-		} else {
-			dma_ch[channel].regs->peripheral_map &= 0x0FFF;
-			dma_ch[channel].regs->peripheral_map |=
+		else
+			dma_ch[channel].regs->peripheral_map = per_map |
 				((channel - CH_UART2_RX + 0x6)<<12);
-		}
 	}
 #endif
 
diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 5ae1bfa..487a562 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -649,6 +649,42 @@ static int bfin_serial_startup(struct uart_port *port)
 		free_irq(uart->port.irq, uart);
 		return -EBUSY;
 	}
+
+# ifdef CONFIG_BF54x
+	{
+		unsigned uart_dma_ch_rx, uart_dma_ch_tx;
+
+		switch (uart->port.irq) {
+		case IRQ_UART3_RX:
+			uart_dma_ch_rx = CH_UART3_RX;
+			uart_dma_ch_tx = CH_UART3_TX;
+			break;
+		case IRQ_UART2_RX:
+			uart_dma_ch_rx = CH_UART2_RX;
+			uart_dma_ch_tx = CH_UART2_TX;
+			break;
+		default:
+			uart_dma_ch_rx = uart_dma_ch_tx = 0;
+			break;
+		};
+
+		if (uart_dma_ch_rx &&
+			request_dma(uart_dma_ch_rx, "BFIN_UART_RX") < 0) {
+			printk(KERN_NOTICE"Fail to attach UART interrupt\n");
+			free_irq(uart->port.irq, uart);
+			free_irq(uart->port.irq + 1, uart);
+			return -EBUSY;
+		}
+		if (uart_dma_ch_tx &&
+			request_dma(uart_dma_ch_tx, "BFIN_UART_TX") < 0) {
+			printk(KERN_NOTICE "Fail to attach UART interrupt\n");
+			free_dma(uart_dma_ch_rx);
+			free_irq(uart->port.irq, uart);
+			free_irq(uart->port.irq + 1, uart);
+			return -EBUSY;
+		}
+	}
+# endif
 #endif
 	UART_SET_IER(uart, ERBFI);
 	return 0;
@@ -666,6 +702,20 @@ static void bfin_serial_shutdown(struct uart_port *port)
 	del_timer(&(uart->rx_dma_timer));
 	dma_free_coherent(NULL, PAGE_SIZE, uart->rx_dma_buf.buf, 0);
 #else
+#ifdef CONFIG_BF54x
+	switch (uart->port.irq) {
+	case IRQ_UART3_RX:
+		free_dma(CH_UART3_RX);
+		free_dma(CH_UART3_TX);
+		break;
+	case IRQ_UART2_RX:
+		free_dma(CH_UART2_RX);
+		free_dma(CH_UART2_TX);
+		break;
+	default:
+		break;
+	};
+#endif
 #ifdef	CONFIG_KGDB_UART
 	if (uart->port.line != CONFIG_KGDB_UART_PORT)
 #endif
-- 
1.5.6
