Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbZF3JF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbZF3JF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 05:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756850AbZF3JFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 05:05:47 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:38816 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966AbZF3JFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 05:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QiRateLPl/OVmC3rROrXShN2ms36IMsKByXwFsL5aRTaztxAkC9vdcm35zj0C6f1Dd
         7eYVBXG7c9JddCPjCOCjz/Ii687FsY8CGxKSW0uryMUGNcjDHwo95rL9/theEfRUZU1j
         4aTRl/fmM1E0gezqJBeQ+ouyYnA8ekrXkKaXI=
From: Albin Tonnerre <albin.tonnerre@gmail.com>
To: hskinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: [PATCH] Add poll_get_char and poll_put_char uart_ops to atmel_serial.
Date: Tue, 30 Jun 2009 11:05:45 +0200
Message-Id: <1246352745-31323-1-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Please CC: me on replies, I'm not subscribed]

This patch allows using KGDB over the console with the atmel_serial
driver.

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
---
 drivers/serial/atmel_serial.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index b3497d7..aaab321 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1211,6 +1211,29 @@ static int atmel_verify_port(struct uart_port *port, struct serial_struct *ser)
 	return ret;
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+static int atmel_poll_get_char(struct uart_port *port)
+{
+	struct atmel_uart_port *aup = to_atmel_uart_port(port);
+
+	while (!(readb(aup->uart.membase + ATMEL_US_CSR) & ATMEL_US_RXRDY))
+		barrier();
+
+	return readb(aup->uart.membase + ATMEL_US_RHR);
+}
+
+static void atmel_poll_put_char(struct uart_port *port, unsigned char ch)
+{
+	struct atmel_uart_port *aup = to_atmel_uart_port(port);
+	unsigned int status;
+
+	while (!(readb(aup->uart.membase + ATMEL_US_CSR) & ATMEL_US_TXRDY))
+		barrier();
+
+	writeb(ch, aup->uart.membase + ATMEL_US_THR);
+}
+#endif
+
 static struct uart_ops atmel_pops = {
 	.tx_empty	= atmel_tx_empty,
 	.set_mctrl	= atmel_set_mctrl,
@@ -1230,6 +1253,10 @@ static struct uart_ops atmel_pops = {
 	.config_port	= atmel_config_port,
 	.verify_port	= atmel_verify_port,
 	.pm		= atmel_serial_pm,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char	= atmel_poll_get_char,
+	.poll_put_char	= atmel_poll_put_char,
+#endif
 };
 
 /*
-- 
1.6.0.4

