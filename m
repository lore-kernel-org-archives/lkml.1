Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155Ab0ASLNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab0ASLNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 06:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190Ab0ASLNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 06:13:08 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:40534 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab0ASLNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 06:13:05 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 1/4] serial: bfin_5xx: remove useless gpio handling with hard flow control
Date: Tue, 19 Jan 2010 06:13:10 -0500
Message-Id: <1263899593-12178-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

For UARTs that have dedicated hardware flow control support, there will be
no gpios to request/free as they are part of the normal peripheral pins.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/bfin_5xx.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 50abb7e..15843cc 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -746,15 +746,6 @@ static int bfin_serial_startup(struct uart_port *port)
 			Status interrupt.\n");
 	}
 
-	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, DRIVER_NAME);
-		gpio_direction_output(uart->cts_pin, 1);
-	}
-	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, DRIVER_NAME);
-		gpio_direction_output(uart->rts_pin, 0);
-	}
-
 	/* CTS RTS PINs are negative assertive. */
 	UART_PUT_MCR(uart, ACTS);
 	UART_SET_IER(uart, EDSSI);
@@ -801,10 +792,6 @@ static void bfin_serial_shutdown(struct uart_port *port)
 		gpio_free(uart->rts_pin);
 #endif
 #ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
-	if (uart->cts_pin >= 0)
-		gpio_free(uart->cts_pin);
-	if (uart->rts_pin >= 0)
-		gpio_free(uart->rts_pin);
 	if (UART_GET_IER(uart) && EDSSI)
 		free_irq(uart->status_irq, uart);
 #endif
@@ -1409,8 +1396,7 @@ static int bfin_serial_remove(struct platform_device *dev)
 			continue;
 		uart_remove_one_port(&bfin_serial_reg, &bfin_serial_ports[i].port);
 		bfin_serial_ports[i].port.dev = NULL;
-#if defined(CONFIG_SERIAL_BFIN_CTSRTS) || \
-	defined(CONFIG_SERIAL_BFIN_HARD_CTSRTS)
+#if defined(CONFIG_SERIAL_BFIN_CTSRTS)
 		gpio_free(bfin_serial_ports[i].cts_pin);
 		gpio_free(bfin_serial_ports[i].rts_pin);
 #endif
-- 
1.6.6

