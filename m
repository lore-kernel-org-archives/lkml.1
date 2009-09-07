Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbZIGJwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbZIGJwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 05:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbZIGJwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 05:52:33 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:58661 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbZIGJwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 05:52:32 -0400
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: avictor.za@gmail.com
Cc: linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       nicolas.ferre@atmel.com,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: [PATCH v2] Add poll_get_char and poll_put_char uart_ops to atmel_serial.
Date: Mon,  7 Sep 2009 11:52:50 +0200
Message-Id: <1252317170-9782-1-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <cd73a99e0909062322j683952e6m803dd6b703bf758d@mail.gmail.com>
References: <cd73a99e0909062322j683952e6m803dd6b703bf758d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows using KGDB over the console with the atmel_serial
driver.

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
---
changes: Use register access macros instead of __raw_readl/writel

 drivers/serial/atmel_serial.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 607d43a..c562883 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1213,6 +1213,24 @@ static int atmel_verify_port(struct uart_port *port, struct serial_struct *ser)
 	return ret;
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+static int atmel_poll_get_char(struct uart_port *port)
+{
+	while (!(UART_GET_CSR(port) & ATMEL_US_RXRDY))
+		barrier();
+
+	return UART_GET_CHAR(port);
+}
+
+static void atmel_poll_put_char(struct uart_port *port, unsigned char ch)
+{
+	while (!(UART_GET_CSR(port) & ATMEL_US_TXRDY))
+		barrier();
+
+	UART_PUT_CHAR(port, ch);
+}
+#endif
+
 static struct uart_ops atmel_pops = {
 	.tx_empty	= atmel_tx_empty,
 	.set_mctrl	= atmel_set_mctrl,
@@ -1232,6 +1250,10 @@ static struct uart_ops atmel_pops = {
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
1.6.3.3

