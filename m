Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbYELEL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbYELEL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 00:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYELEKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 00:10:13 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:26780 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbYELEKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 00:10:09 -0400
X-IronPort-AV: E=Sophos;i="4.27,470,1204520400"; 
   d="scan'208";a="68119601"
From: Bryan Wu <cooloney@kernel.org>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Cc: Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/3] Blackfin Sports UART Driver: fix bug - the bug caused by sport overrun, use timer to flip the tty buffer in order to return from rx ISR quickly
Date: Mon, 12 May 2008 12:10:08 +0800
Message-Id: <1210565409-3655-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1210565409-3655-1-git-send-email-cooloney@kernel.org>
References: <1210565409-3655-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=3911

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_sport_uart.c |   32 +++++++++++++++++++++++++-------
 1 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index aca1240..c31ca6f 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -88,7 +88,8 @@ unsigned short bfin_uart_pin_req_sport1[] =
 struct sport_uart_port {
 	struct uart_port	port;
 	char			*name;
-
+	struct timer_list	rx_timer;
+	int			once;
 	int			tx_irq;
 	int			rx_irq;
 	int			err_irq;
@@ -115,9 +116,10 @@ static inline void tx_one_byte(struct sport_uart_port *up, unsigned int value)
 	SPORT_PUT_TX(up, value);
 }
 
-static inline unsigned int rx_one_byte(struct sport_uart_port *up)
+static inline unsigned char rx_one_byte(struct sport_uart_port *up)
 {
-	unsigned int value, extract;
+	unsigned int value;
+	unsigned char extract;
 
 	value = SPORT_GET_RX32(up);
 	pr_debug("%s value:%x\n", __FUNCTION__, value);
@@ -171,11 +173,20 @@ static int sport_uart_setup(struct sport_uart_port *up, int sclk, int baud_rate)
 	return 0;
 }
 
+static void rx_push(unsigned long data)
+{
+	struct sport_uart_port *up = (struct sport_uart_port *)data;
+	struct tty_struct *tty = up->port.info->tty;
+	tty_flip_buffer_push(tty);
+	add_timer(&up->rx_timer);
+}
+
+
 static irqreturn_t sport_uart_rx_irq(int irq, void *dev_id)
 {
 	struct sport_uart_port *up = dev_id;
 	struct tty_struct *tty = up->port.info->tty;
-	unsigned int ch;
+	unsigned char ch;
 
 	do {
 		ch = rx_one_byte(up);
@@ -186,8 +197,10 @@ static irqreturn_t sport_uart_rx_irq(int irq, void *dev_id)
 		else
 			tty_insert_flip_char(tty, ch, TTY_NORMAL);
 	} while (SPORT_GET_STAT(up) & RXNE);
-	tty_flip_buffer_push(tty);
-
+	if (up->once == 0) {
+		add_timer(&up->rx_timer);
+		up->once = 1;
+	}
 	return IRQ_HANDLED;
 }
 
@@ -253,7 +266,10 @@ static int sport_startup(struct uart_port *port)
 		printk(KERN_ERR "Unable to request interrupt %s\n", buffer);
 		goto fail2;
 	}
-
+	init_timer(&up->rx_timer);
+	up->rx_timer.data = (unsigned long)up;
+	up->rx_timer.expires = jiffies + 5;
+	up->rx_timer.function = (void *)rx_push;
 	if (port->line) {
 		if (peripheral_request_list(bfin_uart_pin_req_sport1, DRV_NAME))
 			goto fail3;
@@ -380,6 +396,8 @@ static void sport_stop_rx(struct uart_port *port)
 {
 	struct sport_uart_port *up = (struct sport_uart_port *)port;
 
+	del_timer(&up->rx_timer);
+	up->once = 0;
 	pr_debug("%s enter\n", __FUNCTION__);
 	/* Disable sport to stop rx */
 	SPORT_PUT_RCR1(up, (SPORT_GET_RCR1(up) & ~RSPEN));
-- 
1.5.5
