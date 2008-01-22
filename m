Return-Path: <linux-kernel-owner+w=401wt.eu-S1761820AbYAVOwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761820AbYAVOwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 09:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760833AbYAVOwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 09:52:07 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:54340 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753042AbYAVOwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:52:06 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Victor <linux@maxim.org.za>
Cc: Remy Bohmer <linux@bohmer.net>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 3/6] atmel_serial: Use existing console options only if BRG is running
Date: Tue, 22 Jan 2008 15:50:41 +0100
Message-Id: <1201013444-30370-4-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201013444-30370-3-git-send-email-hskinnemoen@atmel.com>
References: <1201013444-30370-1-git-send-email-hskinnemoen@atmel.com>
 <1201013444-30370-2-git-send-email-hskinnemoen@atmel.com>
 <1201013444-30370-3-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If BRGR is zero, the baud rate generator isn't running, so the boot
loader can't have initialized the port.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
---
 drivers/serial/atmel_serial.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 991b01a..38bdc7a 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -839,13 +839,13 @@ static void __init atmel_console_get_options(struct uart_port *port, int *baud,
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
@@ -865,7 +865,6 @@ static void __init atmel_console_get_options(struct uart_port *port, int *baud,
 	 * lower than one of those, as it would make us fall through
 	 * to a much lower baud rate than we really want.
 	 */
-	quot = UART_GET_BRGR(port);
 	*baud = port->uartclk / (16 * (quot - 1));
 }
 
-- 
1.5.3.7

