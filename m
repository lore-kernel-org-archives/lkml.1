Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbYC2KuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbYC2KuA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 06:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714AbYC2Ktv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 06:49:51 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:34561 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750703AbYC2Ktu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 06:49:50 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: akpm@linux-foundation.org
Cc: Andrew Victor <linux@maxim.org.za>, Remy Bohmer <linux@bohmer.net>,
       linux-kernel@vger.kernel.org, Marc Pignat <marc.pignat@hevs.ch>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] atmel_serial: fix uart/console concurrent access
Date: Sat, 29 Mar 2008 11:48:52 +0100
Message-Id: <1206787732-16945-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-OriginalArrivalTime: 29 Mar 2008 10:48:52.0053 (UTC) FILETIME=[7A209850:01C8918A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Pignat <marc.pignat@hevs.ch>

Strange chars appear on the serial port when a printk and a printf
happens at the same time. This is caused by the pdc sending chars
while atmel_console_write (called from printk) is executing

Concurent access of uart and console to the same port leads to
corrupted data to be transmitted, so disable tx dma (PDC) while
writing to the console.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
Andrew, I think we want this one before 2.6.25 as well.

 drivers/serial/atmel_serial.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index e99a283..430997e 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -107,6 +107,7 @@
 
 #define UART_PUT_TPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TPR)
 #define UART_PUT_TCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TCR)
+#define UART_GET_TCR(port)	__raw_readl((port)->membase + ATMEL_PDC_TCR)
 
 static int (*atmel_open_hook)(struct uart_port *);
 static void (*atmel_close_hook)(struct uart_port *);
@@ -1275,6 +1276,7 @@ static void atmel_console_write(struct console *co, const char *s, u_int count)
 {
 	struct uart_port *port = &atmel_ports[co->index].uart;
 	unsigned int status, imr;
+	unsigned int pdc_tx;
 
 	/*
 	 * First, save IMR and then disable interrupts
@@ -1282,6 +1284,10 @@ static void atmel_console_write(struct console *co, const char *s, u_int count)
 	imr = UART_GET_IMR(port);
 	UART_PUT_IDR(port, ATMEL_US_RXRDY | ATMEL_US_TXRDY);
 
+	/* Store PDC transmit status and disable it */
+	pdc_tx = UART_GET_PTSR(port) & ATMEL_PDC_TXTEN;
+	UART_PUT_PTCR(port, ATMEL_PDC_TXTDIS);
+
 	uart_console_write(port, s, count, atmel_console_putchar);
 
 	/*
@@ -1291,6 +1297,11 @@ static void atmel_console_write(struct console *co, const char *s, u_int count)
 	do {
 		status = UART_GET_CSR(port);
 	} while (!(status & ATMEL_US_TXRDY));
+
+	/* Restore PDC transmit status */
+	if (pdc_tx)
+		UART_PUT_PTCR(port, ATMEL_PDC_TXTEN);
+
 	/* set interrupts back the way they were */
 	UART_PUT_IER(port, imr);
 }
-- 
1.5.4.3

