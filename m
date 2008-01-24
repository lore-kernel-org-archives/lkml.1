Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbYAXMnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbYAXMnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 07:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbYAXMmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 07:42:10 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53523 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753267AbYAXMmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 07:42:01 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Victor <linux@maxim.org.za>, Remy Bohmer <linux@bohmer.net>,
       Chip Coldwell <coldwell@redhat.com>, Marc Pignat <marc.pignat@hevs.ch>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH -mm v4 4/9] atmel_serial: Use existing console options only if BRG is running
Date: Thu, 24 Jan 2008 13:41:46 +0100
Message-Id: <1201178511-12133-5-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201178511-12133-4-git-send-email-hskinnemoen@atmel.com>
References: <1201178511-12133-1-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-2-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-3-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-4-git-send-email-hskinnemoen@atmel.com>
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
index 4b5c6ff..746aea0 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -835,13 +835,13 @@ static void __init atmel_console_get_options(struct uart_port *port, int *baud,
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
@@ -861,7 +861,6 @@ static void __init atmel_console_get_options(struct uart_port *port, int *baud,
 	 * lower than one of those, as it would make us fall through
 	 * to a much lower baud rate than we really want.
 	 */
-	quot = UART_GET_BRGR(port);
 	*baud = port->uartclk / (16 * (quot - 1));
 }
 
-- 
1.5.3.8

