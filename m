Return-Path: <linux-kernel-owner+w=401wt.eu-S1760155AbZFBHMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155AbZFBHMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbZFBHLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:11:49 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46613 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459AbZFBHLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:11:46 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Cliff Cai <cliff.cai@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 04/11] Blackfin SPORT UART: fix overrun errors
Date: Tue,  2 Jun 2009 03:11:33 -0400
Message-Id: <1243926700-30485-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
References: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

Push the ty_flip_buffer_push() call from the IRQ handler to a timer so as
to improve performance and decrease likelihood of overruns.

URL: http://blackfin.uclinux.org/gf/tracker/3911
Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_sport_uart.c |   31 ++++++++++++++++++++++++-------
 1 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 34b4ae0..fa80411 100644
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
@@ -116,9 +117,10 @@ static inline void tx_one_byte(struct sport_uart_port *up, unsigned int value)
 	SPORT_PUT_TX(up, value);
 }
 
-static inline unsigned int rx_one_byte(struct sport_uart_port *up)
+static inline unsigned char rx_one_byte(struct sport_uart_port *up)
 {
-	unsigned int value, extract;
+	unsigned int value;
+	unsigned char extract;
 	u32 tmp_mask1, tmp_mask2, tmp_shift, tmp;
 
 	value = SPORT_GET_RX32(up);
@@ -175,11 +177,19 @@ static int sport_uart_setup(struct sport_uart_port *up, int sclk, int baud_rate)
 	return 0;
 }
 
+static void rx_push(unsigned long data)
+{
+	struct sport_uart_port *up = (struct sport_uart_port *)data;
+	struct tty_struct *tty = up->port.info->port.tty;
+	tty_flip_buffer_push(tty);
+	add_timer(&up->rx_timer);
+}
+
 static irqreturn_t sport_uart_rx_irq(int irq, void *dev_id)
 {
 	struct sport_uart_port *up = dev_id;
 	struct tty_struct *tty = up->port.info->port.tty;
-	unsigned int ch;
+	unsigned char ch;
 
 	do {
 		ch = rx_one_byte(up);
@@ -190,8 +200,10 @@ static irqreturn_t sport_uart_rx_irq(int irq, void *dev_id)
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
 
@@ -257,7 +269,10 @@ static int sport_startup(struct uart_port *port)
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
@@ -384,6 +399,8 @@ static void sport_stop_rx(struct uart_port *port)
 {
 	struct sport_uart_port *up = (struct sport_uart_port *)port;
 
+	del_timer(&up->rx_timer);
+	up->once = 0;
 	pr_debug("%s enter\n", __func__);
 	/* Disable sport to stop rx */
 	SPORT_PUT_RCR1(up, (SPORT_GET_RCR1(up) & ~RSPEN));
-- 
1.6.3.1

