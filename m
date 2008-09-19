Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbYISPk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbYISPk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 11:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYISPkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 11:40:17 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:35278 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbYISPkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 11:40:16 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Victor <linux@maxim.org.za>,
       Anti Sullin <anti.sullin@artecdesign.ee>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH v2] atmel_serial: update the powersave handler to match serial core
Date: Fri, 19 Sep 2008 17:39:32 +0200
Message-Id: <1221838772-28218-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <48D3C319.4040605@artecdesign.ee>
References: <48D3C319.4040605@artecdesign.ee>
X-OriginalArrivalTime: 19 Sep 2008 15:39:22.0279 (UTC) FILETIME=[E33A8370:01C91A6D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anti Sullin <anti.sullin@artecdesign.ee>

This problem seems to be unnoticed so far:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b3b708fa2780cd2b5d8266a8f0c3a1cab364d4d2

has changed the serial core behavior to not to suspend the port if the
device is enabled as a wakeup source. If the AT91 system goes to slow
clock mode, the port should be suspended always and the clocks should be
switched off.  The patch attached updates the atmel_serial driver to
match the changes in serial core.

Also, the interrupts are disabled when the clock is disabled. If we
disable the clock with interrupts enabled, an interrupt may get stuck.
If this is the DBGU interrupt, this blocks the OR logic at system
controller and thus all other sysc interrupts.

Signed-off-by: Anti Sullin <anti.sullin@artecdesign.ee>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
Anti Sullin <anti.sullin@artecdesign.ee> wrote:
> > +	device_set_wakeup_enable(&pdev->dev, atmel_port->may_wakeup);
> > +
> > +	uart_resume_port(&atmel_uart, port);
> Just now noticed - these two lines should be switched.

Makes sense to me.

 drivers/serial/atmel_serial.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 3a6da80..61fb8b6 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -131,7 +131,8 @@ struct atmel_uart_char {
 struct atmel_uart_port {
 	struct uart_port	uart;		/* uart */
 	struct clk		*clk;		/* uart clock */
-	unsigned short		suspended;	/* is port suspended? */
+	int			may_wakeup;	/* cached value of device_may_wakeup for times we need to disable it */
+	u32			backup_imr;	/* IMR saved during suspend */
 	int			break_active;	/* break being received */
 
 	short			use_dma_rx;	/* enable PDC receiver */
@@ -984,8 +985,15 @@ static void atmel_serial_pm(struct uart_port *port, unsigned int state,
 		 * This is called on uart_open() or a resume event.
 		 */
 		clk_enable(atmel_port->clk);
+
+		/* re-enable interrupts if we disabled some on suspend */
+		UART_PUT_IER(port, atmel_port->backup_imr);
 		break;
 	case 3:
+		/* Back up the interrupt mask and disable all interrupts */
+		atmel_port->backup_imr = UART_GET_IMR(port);
+		UART_PUT_IDR(port, -1);
+
 		/*
 		 * Disable the peripheral clock for this serial port.
 		 * This is called on uart_close() or a suspend event.
@@ -1475,13 +1483,12 @@ static int atmel_serial_suspend(struct platform_device *pdev,
 			cpu_relax();
 	}
 
-	if (device_may_wakeup(&pdev->dev)
-	    && !atmel_serial_clk_will_stop())
-		enable_irq_wake(port->irq);
-	else {
-		uart_suspend_port(&atmel_uart, port);
-		atmel_port->suspended = 1;
-	}
+	/* we can not wake up if we're running on slow clock */
+	atmel_port->may_wakeup = device_may_wakeup(&pdev->dev);
+	if (atmel_serial_clk_will_stop())
+		device_set_wakeup_enable(&pdev->dev, 0);
+
+	uart_suspend_port(&atmel_uart, port);
 
 	return 0;
 }
@@ -1491,11 +1498,8 @@ static int atmel_serial_resume(struct platform_device *pdev)
 	struct uart_port *port = platform_get_drvdata(pdev);
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
-	if (atmel_port->suspended) {
-		uart_resume_port(&atmel_uart, port);
-		atmel_port->suspended = 0;
-	} else
-		disable_irq_wake(port->irq);
+	uart_resume_port(&atmel_uart, port);
+	device_set_wakeup_enable(&pdev->dev, atmel_port->may_wakeup);
 
 	return 0;
 }
@@ -1513,6 +1517,8 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
 	BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
 
 	port = &atmel_ports[pdev->id];
+	port->backup_imr = 0;
+
 	atmel_init_port(port, pdev);
 
 	if (!atmel_use_dma_rx(&port->uart)) {
-- 
1.5.6.5

