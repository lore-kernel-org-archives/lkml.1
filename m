Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab0CBXg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:36:58 -0500
Received: from kroah.org ([198.145.64.141]:51554 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab0CBXgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:36:49 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/36] serial: atmel_serial: add poll_get_char and poll_put_char uart_ops
Date: Tue,  2 Mar 2010 15:36:11 -0800
Message-Id: <1267573003-782-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Albin Tonnerre <albin.tonnerre@free-electrons.com>

Permits using KGDB over the console with the atmel_serial driver.

[akpm@linux-foundation.org: s/barrier/cpu_relax/]
Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/atmel_serial.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 9d948bc..2c9bf9b 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1213,6 +1213,24 @@ static int atmel_verify_port(struct uart_port *port, struct serial_struct *ser)
 	return ret;
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+static int atmel_poll_get_char(struct uart_port *port)
+{
+	while (!(UART_GET_CSR(port) & ATMEL_US_RXRDY))
+		cpu_relax();
+
+	return UART_GET_CHAR(port);
+}
+
+static void atmel_poll_put_char(struct uart_port *port, unsigned char ch)
+{
+	while (!(UART_GET_CSR(port) & ATMEL_US_TXRDY))
+		cpu_relax();
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
1.7.0.1

