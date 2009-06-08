Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbZFHIPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbZFHIPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZFHIPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:15:37 -0400
Received: from relay.atmel.no ([80.232.32.139]:53989 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514AbZFHIPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:15:36 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Eirik Aanonsen <eaa@wprmedical.com>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Nicolas Ferre <Nicolas.FERRE@atmel.com>,
       Andrew Victor <avictor.za@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] atmel_serial: Fix hang in set_termios when crtscts is enabled
Date: Mon,  8 Jun 2009 10:15:21 +0200
Message-Id: <1244448921-22942-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After enabling hardware flow control, any subsequent termios call may
hang waiting for the transmitter to drain. This appears to be caused by
a busy-loop in set_termios() waiting for the transmitter to become
empty, which may take a very long time (or hang indefinitely) if the
device at the other end is blocking us.

A quick look through the tty and serial_core code indicates that any
necessary flushing (which is optional) has already been done at this
point, so there's no need for the driver to flush the transmitter on its
own.

Fix it by removing the busy-loop altogether.

Reported-by: Eirik Aanonsen <eaa@wprmedical.com>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
I have not tested this patch yet. Eirik, can you give it a try?

 drivers/serial/atmel_serial.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index b3497d7..338b15c 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1104,11 +1104,13 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 	/* update the per-port timeout */
 	uart_update_timeout(port, termios->c_cflag, baud);
 
-	/* save/disable interrupts and drain transmitter */
+	/*
+	 * save/disable interrupts. The tty layer will ensure that the
+	 * transmitter is empty if requested by the caller, so there's
+	 * no need to wait for it here.
+	 */
 	imr = UART_GET_IMR(port);
 	UART_PUT_IDR(port, -1);
-	while (!(UART_GET_CSR(port) & ATMEL_US_TXEMPTY))
-		cpu_relax();
 
 	/* disable receiver and transmitter */
 	UART_PUT_CR(port, ATMEL_US_TXDIS | ATMEL_US_RXDIS);
-- 
1.6.0.4

