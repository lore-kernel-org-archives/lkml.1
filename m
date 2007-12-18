Return-Path: <linux-kernel-owner+w=401wt.eu-S1761028AbXLRRHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761028AbXLRRHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759282AbXLRRHC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:07:02 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:50032 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758731AbXLRRHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:07:01 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Victor <linux@maxim.org.za>
Cc: Remy Bohmer <linux@bohmer.net>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 3/5] atmel_serial: Use existing console options only if BRG is running
Date: Tue, 18 Dec 2007 18:06:13 +0100
Message-Id: <1197997575-13292-4-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1197997575-13292-3-git-send-email-hskinnemoen@atmel.com>
References: <1197997575-13292-1-git-send-email-hskinnemoen@atmel.com>
 <1197997575-13292-2-git-send-email-hskinnemoen@atmel.com>
 <1197997575-13292-3-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If BRGR is zero, the baud rate generator isn't running, so the boot
loader can't have initialized the port.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/serial/atmel_serial.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 61d71b0..a6b3828 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -842,13 +842,13 @@ static void __init atmel_console_get_options(struct uart_port *port, int *baud,
 {
 	unsigned int mr, quot;
 
-// TODO: CR is a write-only register
-//	unsigned int cr;
-//
-//	cr = UART_GET_CR(port) & (ATMEL_US_RXEN | ATMEL_US_TXEN);
-//	if (cr == (ATMEL_US_RXEN | ATMEL_US_TXEN)) {
-//		/* ok, the port was enabled */
-//	}
+	/*
+	 * If the baud rate generator isn't running, the port wasn't
+	 * initialized by the boot loader.
+	 */
+	quot = UART_GET_BRGR(port);
+	if (!quot)
+		return;
 
 	mr = UART_GET_MR(port) & ATMEL_US_CHRL;
 	if (mr == ATMEL_US_CHRL_8)
@@ -868,7 +868,6 @@ static void __init atmel_console_get_options(struct uart_port *port, int *baud,
 	 * lower than one of those, as it would make us fall through
 	 * to a much lower baud rate than we really want.
 	 */
-	quot = UART_GET_BRGR(port);
 	*baud = port->uartclk / (16 * (quot - 1));
 }
 
-- 
1.5.3.4

