Return-Path: <linux-kernel-owner+w=401wt.eu-S1760598AbYF3KZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598AbYF3KZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbYF3KZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:25:07 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:63799 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788AbYF3KZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:25:06 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel@avr32linux.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 2/2] atmel_serial: Implement flush_buffer() hook
Date: Mon, 30 Jun 2008 12:24:21 +0200
Message-Id: <1214821461-11772-2-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214821461-11772-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214821461-11772-1-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 30 Jun 2008 10:24:12.0880 (UTC) FILETIME=[70E37500:01C8DA9B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid dumping garbage to the serial port when the tty is flushed. This
tends to happen when rebooting from a serial console.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/serial/atmel_serial.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 42be8b0..7691f42 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -956,6 +956,20 @@ static void atmel_shutdown(struct uart_port *port)
 }
 
 /*
+ * Flush any TX data submitted for DMA. Called when the TX circular
+ * buffer is reset.
+ */
+static void atmel_flush_buffer(struct uart_port *port)
+{
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
+
+	if (atmel_use_dma_tx(port)) {
+		UART_PUT_TCR(port, 0);
+		atmel_port->pdc_tx.ofs = 0;
+	}
+}
+
+/*
  * Power / Clock management.
  */
 static void atmel_serial_pm(struct uart_port *port, unsigned int state,
@@ -1189,6 +1203,7 @@ static struct uart_ops atmel_pops = {
 	.break_ctl	= atmel_break_ctl,
 	.startup	= atmel_startup,
 	.shutdown	= atmel_shutdown,
+	.flush_buffer	= atmel_flush_buffer,
 	.set_termios	= atmel_set_termios,
 	.type		= atmel_type,
 	.release_port	= atmel_release_port,
-- 
1.5.5.4

