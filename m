Return-Path: <linux-kernel-owner+w=401wt.eu-S1760381AbYF3JW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760381AbYF3JW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbYF3JWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:22:10 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:62538 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882AbYF3JWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:22:07 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Andrew Victor <linux@maxim.org.za>
Subject: [PATCH 2/8] atmel_serial: Drain console TX shifter before suspending
Date: Mon, 30 Jun 2008 11:21:10 +0200
Message-Id: <1214817676-30378-3-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214817676-30378-2-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214817676-30378-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-2-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 30 Jun 2008 09:21:07.0570 (UTC) FILETIME=[A0AAFD20:01C8DA92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Funny things may happen if we stop the USART clock before the shifter is
empty. Prevent this from happening by waiting until the shifter is
completely drained before allowing suspend to continue.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
---
 drivers/serial/atmel_serial.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 5f0414f..6aeef22 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1454,6 +1454,12 @@ static int atmel_serial_suspend(struct platform_device *pdev,
 	struct uart_port *port = platform_get_drvdata(pdev);
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
+	if (atmel_is_console_port(port) && console_suspend_enabled) {
+		/* Drain the TX shifter */
+		while (!(UART_GET_CSR(port) & ATMEL_US_TXEMPTY))
+			cpu_relax();
+	}
+
 	if (device_may_wakeup(&pdev->dev)
 	    && !atmel_serial_clk_will_stop())
 		enable_irq_wake(port->irq);
-- 
1.5.5.4

