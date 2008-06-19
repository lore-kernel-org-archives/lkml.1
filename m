Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbYFSMml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbYFSMml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbYFSMmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:42:33 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:49770 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbYFSMmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:42:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=O+MjwAgm/SqbKF0/ytS6h0/oDzRsUFm27F23svJNrAvkvD67534dVdj+bfFInDfmuU
         JFkQqqpJXqEmB41D9CZv4Uz2cgilNev4/s+8Q+Ho++oOzs8LVPf3xNUV2fWDNg/VqKIZ
         Sr+umxiN7zpYy3+R1iwZS+JtpyP8pAC9nisCM=
Message-ID: <386072610806190542l167445b1o3c75c7b7f77033f1@mail.gmail.com>
Date: Thu, 19 Jun 2008 20:42:30 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel List" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Blackfin arch updates for 2.6.26-rc6
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 74a091a87ea97a24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 drivers/serial/bfin_5xx.c                         |   40 +++++++++-----------
 include/asm-blackfin/mach-bf527/bfin_serial_5xx.h |    2 +-
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h |    2 +-
 include/asm-blackfin/mach-bf537/bfin_serial_5xx.h |    2 +-
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h |    6 ++--
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h |    2 +-
 6 files changed, 25 insertions(+), 29 deletions(-)

Sonic Zhang (2):
      Blackfin arch: fix typo error in bf548 serial header file
      Blackfin Serial Driver: Use timer to poll CTS PIN instead of workqueue.

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index f20952c..fd9bb77 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -49,6 +49,7 @@
 #define DMA_RX_YCOUNT		(PAGE_SIZE / DMA_RX_XCOUNT)

 #define DMA_RX_FLUSH_JIFFIES	(HZ / 50)
+#define CTS_CHECK_JIFFIES	(HZ / 50)

 #ifdef CONFIG_SERIAL_BFIN_DMA
 static void bfin_serial_dma_tx_chars(struct bfin_serial_port *uart);
@@ -290,11 +291,6 @@ static void bfin_serial_tx_chars(struct
bfin_serial_port *uart)
 {
 	struct circ_buf *xmit = &uart->port.info->xmit;

-	if (uart->port.x_char) {
-		UART_PUT_CHAR(uart, uart->port.x_char);
-		uart->port.icount.tx++;
-		uart->port.x_char = 0;
-	}
 	/*
 	 * Check the modem control lines before
 	 * transmitting anything.
@@ -306,6 +302,12 @@ static void bfin_serial_tx_chars(struct
bfin_serial_port *uart)
 		return;
 	}

+	if (uart->port.x_char) {
+		UART_PUT_CHAR(uart, uart->port.x_char);
+		uart->port.icount.tx++;
+		uart->port.x_char = 0;
+	}
+
 	while ((UART_GET_LSR(uart) & THRE) && xmit->tail != xmit->head) {
 		UART_PUT_CHAR(uart, xmit->buf[xmit->tail]);
 		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
@@ -345,15 +347,6 @@ static irqreturn_t bfin_serial_tx_int(int irq,
void *dev_id)
 }
 #endif

-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-static void bfin_serial_do_work(struct work_struct *work)
-{
-	struct bfin_serial_port *uart = container_of(work, struct
bfin_serial_port, cts_workqueue);
-
-	bfin_serial_mctrl_check(uart);
-}
-#endif
-
 #ifdef CONFIG_SERIAL_BFIN_DMA
 static void bfin_serial_dma_tx_chars(struct bfin_serial_port *uart)
 {
@@ -361,6 +354,12 @@ static void bfin_serial_dma_tx_chars(struct
bfin_serial_port *uart)

 	uart->tx_done = 0;

+	/*
+	 * Check the modem control lines before
+	 * transmitting anything.
+	 */
+	bfin_serial_mctrl_check(uart);
+
 	if (uart_circ_empty(xmit) || uart_tx_stopped(&uart->port)) {
 		uart->tx_count = 0;
 		uart->tx_done = 1;
@@ -373,12 +372,6 @@ static void bfin_serial_dma_tx_chars(struct
bfin_serial_port *uart)
 		uart->port.x_char = 0;
 	}

-	/*
-	 * Check the modem control lines before
-	 * transmitting anything.
-	 */
-	bfin_serial_mctrl_check(uart);
-
 	uart->tx_count = CIRC_CNT(xmit->head, xmit->tail, UART_XMIT_SIZE);
 	if (uart->tx_count > (UART_XMIT_SIZE - xmit->tail))
 		uart->tx_count = UART_XMIT_SIZE - xmit->tail;
@@ -565,7 +558,10 @@ static void bfin_serial_mctrl_check(struct
bfin_serial_port *uart)
 	uart_handle_cts_change(&uart->port, status & TIOCM_CTS);
 	if (!(status & TIOCM_CTS)) {
 		tty->hw_stopped = 1;
-		schedule_work(&uart->cts_workqueue);
+		uart->cts_timer.data = (unsigned long)(uart);
+		uart->cts_timer.function = (void *)bfin_serial_mctrl_check;
+		uart->cts_timer.expires = jiffies + CTS_CHECK_JIFFIES;
+		add_timer(&(uart->cts_timer));
 	} else {
 		tty->hw_stopped = 0;
 	}
@@ -885,7 +881,7 @@ static void __init bfin_serial_init_ports(void)
 		init_timer(&(bfin_serial_ports[i].rx_dma_timer));
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
-		INIT_WORK(&bfin_serial_ports[i].cts_workqueue, bfin_serial_do_work);
+		init_timer(&(bfin_serial_ports[i].cts_timer));
 		bfin_serial_ports[i].cts_pin	    =
 			bfin_serial_resource[i].uart_cts_pin;
 		bfin_serial_ports[i].rts_pin	    =
diff --git a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
index 96bd09e..2526b6e 100644
--- a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
@@ -96,7 +96,7 @@ struct bfin_serial_port {
 	struct work_struct tx_dma_workqueue;
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	struct work_struct cts_workqueue;
+	struct timer_list cts_timer;
 	int cts_pin;
 	int rts_pin;
 #endif
diff --git a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
index e924569..ebf592b 100644
--- a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
@@ -88,7 +88,7 @@ struct bfin_serial_port {
 # endif
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	struct work_struct 	cts_workqueue;
+	struct timer_list       cts_timer;
 	int			cts_pin;
 	int			rts_pin;
 #endif
diff --git a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
index 41d7b64..1bf56ff 100644
--- a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
@@ -96,7 +96,7 @@ struct bfin_serial_port {
 	struct work_struct	tx_dma_workqueue;
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	struct work_struct 	cts_workqueue;
+	struct timer_list 	cts_timer;
 	int		cts_pin;
 	int 		rts_pin;
 #endif
diff --git a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
index 59b4ad4..5e29446 100644
--- a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
@@ -99,7 +99,7 @@ struct bfin_serial_port {
 	struct work_struct	tx_dma_workqueue;
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	struct work_struct 	cts_workqueue;
+	struct timer_list 	cts_timer;
 	int		cts_pin;
 	int 		rts_pin;
 #endif
@@ -187,7 +187,7 @@ static void bfin_serial_hw_init(struct
bfin_serial_port *uart)

 #ifdef CONFIG_BFIN_UART1_CTSRTS
 	peripheral_request(P_UART1_RTS, DRIVER_NAME);
-	peripheral_request(P_UART1_CTS DRIVER_NAME);
+	peripheral_request(P_UART1_CTS, DRIVER_NAME);
 #endif
 #endif

@@ -202,7 +202,7 @@ static void bfin_serial_hw_init(struct
bfin_serial_port *uart)

 #ifdef CONFIG_BFIN_UART3_CTSRTS
 	peripheral_request(P_UART3_RTS, DRIVER_NAME);
-	peripheral_request(P_UART3_CTS DRIVER_NAME);
+	peripheral_request(P_UART3_CTS, DRIVER_NAME);
 #endif
 #endif
 	SSYNC();
diff --git a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
index 30d90b5..8aa0278 100644
--- a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
@@ -88,7 +88,7 @@ struct bfin_serial_port {
 # endif
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	struct work_struct 	cts_workqueue;
+	struct timer_list       cts_timer;
 	int			cts_pin;
 	int			rts_pin;
 #endif
