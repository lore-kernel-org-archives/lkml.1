Return-Path: <linux-kernel-owner+w=401wt.eu-S1759575AbXLRRI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbXLRRI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759246AbXLRRIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:08:44 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:56335 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761831AbXLRRIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:08:43 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Victor <linux@maxim.org.za>
Cc: Remy Bohmer <linux@bohmer.net>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 2/5] atmel_serial: Use cpu_relax() when busy-waiting
Date: Tue, 18 Dec 2007 18:06:12 +0100
Message-Id: <1197997575-13292-3-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1197997575-13292-2-git-send-email-hskinnemoen@atmel.com>
References: <1197997575-13292-1-git-send-email-hskinnemoen@atmel.com>
 <1197997575-13292-2-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace two instances of barrier() with cpu_relax() since that's the
right thing to do when busy-waiting. This does not actually change
anything since cpu_relax() is defined as barrier() on both ARM and
AVR32.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/serial/atmel_serial.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index bd41529..61d71b0 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -623,7 +623,7 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 	imr = UART_GET_IMR(port);
 	UART_PUT_IDR(port, -1);
 	while (!(UART_GET_CSR(port) & ATMEL_US_TXEMPTY))
-		barrier();
+		cpu_relax();
 
 	/* disable receiver and transmitter */
 	UART_PUT_CR(port, ATMEL_US_TXDIS | ATMEL_US_RXDIS);
@@ -802,7 +802,7 @@ void __init atmel_register_uart_fns(struct atmel_port_fns *fns)
 static void atmel_console_putchar(struct uart_port *port, int ch)
 {
 	while (!(UART_GET_CSR(port) & ATMEL_US_TXRDY))
-		barrier();
+		cpu_relax();
 	UART_PUT_CHAR(port, ch);
 }
 
-- 
1.5.3.4

