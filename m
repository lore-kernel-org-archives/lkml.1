Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbZGYMRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbZGYMRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 08:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZGYMRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 08:17:49 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:33120 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbZGYMRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 08:17:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pnfwOJcVJ2VhWVP0SjNGDIYEp7+RnPoAbMtfaw/xRecP2tMWaTVbCKpCjCMwfiVeuf
         JcrbyN9SYNkdI86ZmDrv+Hza/z4MS6mc4hsMLewEdBqSVjnApAOnvzJSyw39LyNTVqhr
         gX7eTC279OEmP3lxpfCBXwTWkYnKixBWohGYk=
From: Arnaud Faucher <arnaud.faucher@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Faucher <arnaud.faucher@gmail.com>
Subject: [PATCH] serial: 8250: switch to dev_pm_ops
Date: Sat, 25 Jul 2009 08:17:15 -0400
Message-Id: <1248524235-11167-1-git-send-email-arnaud.faucher@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Arnaud Faucher <arnaud.faucher@gmail.com>
---
 drivers/serial/8250.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index fb867a9..e6b41b1 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2982,42 +2982,46 @@ static int __devexit serial8250_remove(struct platform_device *dev)
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
+	.suspend	= serial8250_suspend,
+	.resume		= serial8250_resume,
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
+		.pm	= &serial8250_pm_ops,
 	},
 };
 
-- 
1.6.3.3

