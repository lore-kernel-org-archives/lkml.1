Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbZAQAGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbZAQAGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 19:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932606AbZAQAGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 19:06:14 -0500
Received: from monster.nessie.de ([84.200.20.120]:47383 "EHLO
	monster.nessie.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400AbZAQAGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 19:06:13 -0500
Message-ID: <497120F1.7020409@nessie.de>
Date: Sat, 17 Jan 2009 01:06:09 +0100
From: Michael Roth <mroth@nessie.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: dmitry.torokhov@gmail.com, imre.deak@nokia.com
Subject: [PATCH] ads7846: Pin change interrupt support
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some SoC supports only pin change interrupts on GPIO pins
used as irq lines.

The ads7846 core is not affected from the additional irqs
on the rising edge because the code accounts touch bounce
anyway by kicking in a timer and disabling the irq after
the first request and reenabling the irq after a timeout
when there is no longer pen down detected.

Signed-off-by: Michael Roth <mroth@nessie.de>
---
diff -ur linux-2.6.28/drivers/input/touchscreen/ads7846.c linux-2.6.28-work/drivers/input/touchscreen/ads7846.c
--- linux-2.6.28/drivers/input/touchscreen/ads7846.c    2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28-work/drivers/input/touchscreen/ads7846.c       2009-01-17 00:40:15.000000000 +0100
@@ -1131,9 +1131,14 @@

        if (request_irq(spi->irq, ads7846_irq, IRQF_TRIGGER_FALLING,
                        spi->dev.driver->name, ts)) {
-               dev_dbg(&spi->dev, "irq %d busy?\n", spi->irq);
-               err = -EBUSY;
-               goto err_free_gpio;
+               dev_info(&spi->dev, "trying pin change workaround on irq %d\n", spi->irq);
+               if (request_irq(spi->irq, ads7846_irq,
+                               IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+                               spi->dev.driver->name, ts)) {
+                       dev_dbg(&spi->dev, "irq %d busy?\n", spi->irq);
+                       err = -EBUSY;
+                       goto err_free_gpio;
+               }
        }

        err = ads784x_hwmon_register(spi, ts);

