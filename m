Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbYJMJgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbYJMJgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759029AbYJMJdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:33:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56133 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758926AbYJMJdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:33:54 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 12/80] Blackfin Serial Driver: Fix bug - request UART2/3
	peripheral mapped interrupts in PIO mode
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:33:51 +0100
Message-ID: <20081013093347.21645.54210.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Alan Cox <alan@redhat.com>
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
index a5cf0e7..569f0e2 100644
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

