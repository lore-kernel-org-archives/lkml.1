Return-Path: <linux-kernel-owner+w=401wt.eu-S1762696AbZDAIye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762696AbZDAIye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762091AbZDAIyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:54:15 -0400
Received: from relay.atmel.no ([80.232.32.139]:50765 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762169AbZDAIyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:54:14 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Victor <linux@maxim.org.za>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Ma <pma@mediamatech.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 2/2] avr32: add hardware handshake support to atmel_serial
Date: Wed,  1 Apr 2009 10:53:58 +0200
Message-Id: <1238576038-8915-2-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1238576038-8915-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1238576038-8915-1-git-send-email-haavard.skinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Ma <pma@mediamatech.com>

Adds Hardware Handshake (aka RTS/CTS flow-control) support to
atmel_serial driver, as a termios flag.

For this to actually work, the platform code needs to configure the RTS
and CTS pins for use by the USART. This has been done for AVR32 as a
separate patch.

Signed-off-by: Peter Ma <pma@mediamatech.com>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/serial/atmel_serial.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 8f58f7f..b3497d7 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1020,7 +1020,8 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	/* Get current mode register */
 	mode = UART_GET_MR(port) & ~(ATMEL_US_USCLKS | ATMEL_US_CHRL
-					| ATMEL_US_NBSTOP | ATMEL_US_PAR);
+					| ATMEL_US_NBSTOP | ATMEL_US_PAR
+					| ATMEL_US_USMODE);
 
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk / 16);
 	quot = uart_get_divisor(port, baud);
@@ -1065,6 +1066,12 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 	} else
 		mode |= ATMEL_US_PAR_NONE;
 
+	/* hardware handshake (RTS/CTS) */
+	if (termios->c_cflag & CRTSCTS)
+		mode |= ATMEL_US_USMODE_HWHS;
+	else
+		mode |= ATMEL_US_USMODE_NORMAL;
+
 	spin_lock_irqsave(&port->lock, flags);
 
 	port->read_status_mask = ATMEL_US_OVRE;
-- 
1.6.0.4

