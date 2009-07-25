Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbZGYU7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbZGYU7l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 16:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbZGYU7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 16:59:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:15629 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbZGYU7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 16:59:40 -0400
Date: Sat, 25 Jul 2009 22:59:37 +0200
From: Erik Ekman <erik@kryo.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Frans Pop <elendil@planet.nl>, Alan Cox <alan@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2 -tip][RFC] serial8250: update to dev_pm_ops
Message-Id: <20090725225937.dfbd4805.erik@kryo.se>
In-Reply-To: <200907252218.46364.rjw@sisk.pl>
References: <20090701083737.41f28c7d.erik@kryo.se>
	<20090708144337.7006fa0a@t61.ukuu.org.uk>
	<200907251612.34140.elendil@planet.nl>
	<200907252218.46364.rjw@sisk.pl>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

serial8250: update to dev_pm_ops

>From dmesg:
Platform driver 'serial8250' needs updating - please use dev_pm_ops

Signed-off-by: Erik Ekman <erik@kryo.se>
--
Updated to handle hibernation as understood based on info from Rafael J. Wysocki.
Please let me know if any special handling is needed.

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index fb867a9..e93222c 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2982,42 +2982,50 @@ static int __devexit serial8250_remove(struct platform_device *dev)
 	return 0;
 }
 
-static int serial8250_suspend(struct platform_device *dev, pm_message_t state)
+static int serial8250_suspend(struct device *dev)
 {
 	int i;
 
 	for (i = 0; i < UART_NR; i++) {
 		struct uart_8250_port *up = &serial8250_ports[i];
 
-		if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev->dev)
+		if (up->port.type != PORT_UNKNOWN && up->port.dev == dev)
 			uart_suspend_port(&serial8250_reg, &up->port);
 	}
 
 	return 0;
 }
 
-static int serial8250_resume(struct platform_device *dev)
+static int serial8250_resume(struct device *dev)
 {
 	int i;
 
 	for (i = 0; i < UART_NR; i++) {
 		struct uart_8250_port *up = &serial8250_ports[i];
 
-		if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev->dev)
+		if (up->port.type != PORT_UNKNOWN && up->port.dev == dev)
 			serial8250_resume_port(i);
 	}
 
 	return 0;
 }
 
+static struct dev_pm_ops serial8250_pm_ops = {
+	.resume   = serial8250_resume,
+	.suspend  = serial8250_suspend,
+	.freeze   = serial8250_resume,
+	.thaw     = serial8250_suspend,
+	.restore  = serial8250_resume,
+	.poweroff = serial8250_suspend,
+};
+
 static struct platform_driver serial8250_isa_driver = {
 	.probe		= serial8250_probe,
 	.remove		= __devexit_p(serial8250_remove),
-	.suspend	= serial8250_suspend,
-	.resume		= serial8250_resume,
 	.driver		= {
 		.name	= "serial8250",
 		.owner	= THIS_MODULE,
+		.pm     = &serial8250_pm_ops, 
 	},
 };
