Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab0CIRXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:23:46 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54720 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab0CIRWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:22:34 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 10/13] serial: bfin_sport_uart: only enable SPORT TX if data is to be sent
Date: Tue,  9 Mar 2010 12:25:37 -0500
Message-Id: <1268155540-8241-11-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
References: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Rather than always turn on the SPORT TX interrupt, only do it when we've
actually queued up data for transmission.  This avoids useless interrupt
processing.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/bfin_sport_uart.c |   30 +++++++++++++++++++++---------
 1 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 1b22c59..9d777e4 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -53,7 +53,7 @@ struct sport_uart_port {
 #endif
 };
 
-static void sport_uart_tx_chars(struct sport_uart_port *up);
+static int sport_uart_tx_chars(struct sport_uart_port *up);
 static void sport_stop_tx(struct uart_port *port);
 
 static inline void tx_one_byte(struct sport_uart_port *up, unsigned int value)
@@ -306,18 +306,24 @@ static int sport_startup(struct uart_port *port)
 	return ret;
 }
 
-static void sport_uart_tx_chars(struct sport_uart_port *up)
+/*
+ * sport_uart_tx_chars
+ *
+ * ret 1 means need to enable sport.
+ * ret 0 means do nothing.
+ */
+static int sport_uart_tx_chars(struct sport_uart_port *up)
 {
 	struct circ_buf *xmit = &up->port.state->xmit;
 
 	if (SPORT_GET_STAT(up) & TXF)
-		return;
+		return 0;
 
 	if (up->port.x_char) {
 		tx_one_byte(up, up->port.x_char);
 		up->port.icount.tx++;
 		up->port.x_char = 0;
-		return;
+		return 1;
 	}
 
 	if (uart_circ_empty(xmit) || uart_tx_stopped(&up->port)) {
@@ -328,7 +334,7 @@ static void sport_uart_tx_chars(struct sport_uart_port *up)
 		 */
 		if (SPORT_GET_STAT(up) & TXHRE)
 			sport_stop_tx(&up->port);
-		return;
+		return 0;
 	}
 
 	while(!(SPORT_GET_STAT(up) & TXF) && !uart_circ_empty(xmit)) {
@@ -339,6 +345,8 @@ static void sport_uart_tx_chars(struct sport_uart_port *up)
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(&up->port);
+
+	return 1;
 }
 
 static unsigned int sport_tx_empty(struct uart_port *port)
@@ -360,6 +368,9 @@ static void sport_stop_tx(struct uart_port *port)
 
 	pr_debug("%s enter\n", __func__);
 
+	if (!(SPORT_GET_TCR1(up) & TSPEN))
+		return;
+
 	/* Although the hold register is empty, last byte is still in shift
 	 * register and not sent out yet. So, put a dummy data into TX FIFO.
 	 * Then, sport tx stops when last byte is shift out and the dummy
@@ -382,11 +393,12 @@ static void sport_start_tx(struct uart_port *port)
 	pr_debug("%s enter\n", __func__);
 
 	/* Write data into SPORT FIFO before enable SPROT to transmit */
-	sport_uart_tx_chars(up);
+	if (sport_uart_tx_chars(up)) {
+		/* Enable transmit, then an interrupt will generated */
+		SPORT_PUT_TCR1(up, (SPORT_GET_TCR1(up) | TSPEN));
+		SSYNC();
+	}
 
-	/* Enable transmit, then an interrupt will generated */
-	SPORT_PUT_TCR1(up, (SPORT_GET_TCR1(up) | TSPEN));
-	SSYNC();
 	pr_debug("%s exit\n", __func__);
 }
 
-- 
1.7.0.2

