Return-Path: <linux-kernel-owner+w=401wt.eu-S1751539AbZG0PTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbZG0PTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbZG0PTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:19:05 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:60631 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZG0PTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:19:04 -0400
Date: Mon, 27 Jul 2009 17:19:00 +0200
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: avictor.za@gmail.com, linux-kernel@vger.kernel.org,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Add poll_get_char and poll_put_char uart_ops to
	atmel_serial.
Message-ID: <20090727151900.GB4052@pc-ras4041.res.insa>
References: <1246352745-31323-1-git-send-email-albin.tonnerre@free-electrons.com> <20090727162312.35c2f9d4@hskinnemoen-d830>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090727162312.35c2f9d4@hskinnemoen-d830>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows using KGDB over the console with the atmel_serial
driver.

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
---
 Updated patch to use __raw_readl/__raw_writel, as per Haavard's comments.

 drivers/serial/atmel_serial.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 338b15c..1e65046 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1213,6 +1213,28 @@ static int atmel_verify_port(struct uart_port *port, struct serial_struct *ser)
 	return ret;
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+static int atmel_poll_get_char(struct uart_port *port)
+{
+	struct atmel_uart_port *aup = to_atmel_uart_port(port);
+
+	while (!(__raw_readl(aup->uart.membase + ATMEL_US_CSR) & ATMEL_US_RXRDY))
+		barrier();
+
+	return __raw_readl(aup->uart.membase + ATMEL_US_RHR);
+}
+
+static void atmel_poll_put_char(struct uart_port *port, unsigned char ch)
+{
+	struct atmel_uart_port *aup = to_atmel_uart_port(port);
+
+	while (!(__raw_readl(aup->uart.membase + ATMEL_US_CSR) & ATMEL_US_TXRDY))
+		barrier();
+
+	__raw_writel(ch, aup->uart.membase + ATMEL_US_THR);
+}
+#endif
+
 static struct uart_ops atmel_pops = {
 	.tx_empty	= atmel_tx_empty,
 	.set_mctrl	= atmel_set_mctrl,
@@ -1232,6 +1254,10 @@ static struct uart_ops atmel_pops = {
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
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
