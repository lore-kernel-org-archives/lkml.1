Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbYCMOtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbYCMOtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 10:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYCMOtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 10:49:31 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:41623 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754014AbYCMOta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 10:49:30 -0400
X-Greylist: delayed 521 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Mar 2008 10:49:30 EDT
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>
Subject: [PATCH 02/10] atmel_serial: Fix build on avr32 with CONFIG_PM enabled
Date: Thu, 13 Mar 2008 15:39:37 +0100
Message-Id: <1205419185-26395-3-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1205419185-26395-2-git-send-email-hskinnemoen@atmel.com>
References: <>
 <1205419185-26395-1-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-2-git-send-email-hskinnemoen@atmel.com>
X-OriginalArrivalTime: 13 Mar 2008 14:39:46.0352 (UTC) FILETIME=[1552DB00:01C88518]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AVR32 doesn't have at91_suspend_entering_slow_clock(). Just assume the
clock will keep running for now.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/serial/atmel_serial.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index d57bf3e..2efbdf6 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1428,6 +1428,15 @@ static struct uart_driver atmel_uart = {
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
@@ -1435,7 +1444,7 @@ static int atmel_serial_suspend(struct platform_device *pdev,
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (device_may_wakeup(&pdev->dev)
-	    && !at91_suspend_entering_slow_clock())
+	    && !atmel_serial_clk_will_stop())
 		enable_irq_wake(port->irq);
 	else {
 		uart_suspend_port(&atmel_uart, port);
-- 
1.5.4.3

