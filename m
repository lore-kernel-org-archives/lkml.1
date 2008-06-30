Return-Path: <linux-kernel-owner+w=401wt.eu-S1759240AbYF3JVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbYF3JVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbYF3JVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:21:34 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:62525 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbYF3JVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:21:33 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>,
       Andrew Victor <linux@maxim.org.za>
Subject: [PATCH 1/8] atmel_serial: Fix build on avr32 with CONFIG_PM enabled
Date: Mon, 30 Jun 2008 11:21:09 +0200
Message-Id: <1214817676-30378-2-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214817676-30378-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214817676-30378-1-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 30 Jun 2008 09:21:07.0508 (UTC) FILETIME=[A0A18740:01C8DA92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haavard Skinnemoen <hskinnemoen@atmel.com>

AVR32 doesn't have at91_suspend_entering_slow_clock(). Just assume the
clock will keep running for now.

David has a better solution for this, but this works for now. Leaving
the USART clock running won't prevent the PM code from entering deep
power-down modes anyway.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Andrew Victor <linux@maxim.org.za>
---
 drivers/serial/atmel_serial.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 42be8b0..5f0414f 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1439,6 +1439,15 @@ static struct uart_driver atmel_uart = {
 };
 
 #ifdef CONFIG_PM
+static bool atmel_serial_clk_will_stop(void)
+{
+#ifdef CONFIG_ARCH_AT91
+	return at91_suspend_entering_slow_clock();
+#else
+	return false;
+#endif
+}
+
 static int atmel_serial_suspend(struct platform_device *pdev,
 				pm_message_t state)
 {
@@ -1446,7 +1455,7 @@ static int atmel_serial_suspend(struct platform_device *pdev,
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (device_may_wakeup(&pdev->dev)
-	    && !at91_suspend_entering_slow_clock())
+	    && !atmel_serial_clk_will_stop())
 		enable_irq_wake(port->irq);
 	else {
 		uart_suspend_port(&atmel_uart, port);
-- 
1.5.5.4

