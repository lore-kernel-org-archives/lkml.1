Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZBUVDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZBUVDt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 16:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbZBUVDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 16:03:40 -0500
Received: from bu3sch.de ([62.75.166.246]:60370 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbZBUVDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 16:03:39 -0500
From: Michael Buesch <mb@bu3sch.de>
To: David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH] spi-gpio: Allow operation without CS signal
Date: Sat, 21 Feb 2009 22:01:52 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902212201.52952.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes spi-gpio so that it is possible to drive SPI
communications over GPIO without the need for a chipselect signal.

This is useful in very small setups where there's only one slave device
on the bus.

This patch does not affect existing setups.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

I use this for a tiny communication channel between an embedded device
and a microcontroller. There are not enough GPIOs available for chipselect
and it's not needed anyway in this case.

PS: Dave, please give me some hint on how to fixup the spi-delay patch
    that I sent recently. Should I add a member to the spi-gpio pdata that
    tells whether to use the delay? This way existing setups would continue
    to work unchanged and the max_bus_speed=0 issue would be resolved.


Index: linux-2.6/drivers/spi/spi_gpio.c
===================================================================
--- linux-2.6.orig/drivers/spi/spi_gpio.c	2009-02-21 21:57:03.000000000 +0100
+++ linux-2.6/drivers/spi/spi_gpio.c	2009-02-21 21:57:58.000000000 +0100
@@ -178,8 +178,10 @@ static void spi_gpio_chipselect(struct s
 	if (is_active)
 		setsck(spi, spi->mode & SPI_CPOL);
 
-	/* SPI is normally active-low */
-	gpio_set_value(cs, (spi->mode & SPI_CS_HIGH) ? is_active : !is_active);
+	if (cs != SPI_GPIO_NO_CHIPSELECT) {
+		/* SPI is normally active-low */
+		gpio_set_value(cs, (spi->mode & SPI_CS_HIGH) ? is_active : !is_active);
+	}
 }
 
 static int spi_gpio_setup(struct spi_device *spi)
@@ -191,15 +193,17 @@ static int spi_gpio_setup(struct spi_dev
 		return -EINVAL;
 
 	if (!spi->controller_state) {
-		status = gpio_request(cs, spi->dev.bus_id);
-		if (status)
-			return status;
-		status = gpio_direction_output(cs, spi->mode & SPI_CS_HIGH);
+		if (cs != SPI_GPIO_NO_CHIPSELECT) {
+			status = gpio_request(cs, spi->dev.bus_id);
+			if (status)
+				return status;
+			status = gpio_direction_output(cs, spi->mode & SPI_CS_HIGH);
+		}
 	}
 	if (!status)
 		status = spi_bitbang_setup(spi);
 	if (status) {
-		if (!spi->controller_state)
+		if (!spi->controller_state && cs != SPI_GPIO_NO_CHIPSELECT)
 			gpio_free(cs);
 	}
 	return status;
@@ -209,7 +213,8 @@ static void spi_gpio_cleanup(struct spi_
 {
 	unsigned long	cs = (unsigned long) spi->controller_data;
 
-	gpio_free(cs);
+	if (cs != SPI_GPIO_NO_CHIPSELECT)
+		gpio_free(cs);
 	spi_bitbang_cleanup(spi);
 }
 
Index: linux-2.6/include/linux/spi/spi_gpio.h
===================================================================
--- linux-2.6.orig/include/linux/spi/spi_gpio.h	2009-02-21 21:48:36.000000000 +0100
+++ linux-2.6/include/linux/spi/spi_gpio.h	2009-02-21 21:57:58.000000000 +0100
@@ -25,10 +25,16 @@
  *	...
  *	};
  *
+ * If chipselect is not used (there's only one device on the bus), assign
+ * SPI_GPIO_NO_CHIPSELECT to the controller_data:
+ *		.controller_data = (void *) SPI_GPIO_NO_CHIPSELECT;
+ *
  * If the bitbanged bus is later switched to a "native" controller,
  * that platform_device and controller_data should be removed.
  */
 
+#define SPI_GPIO_NO_CHIPSELECT		((unsigned long)-1l)
+
 /**
  * struct spi_gpio_platform_data - parameter for bitbanged SPI master
  * @sck: number of the GPIO used for clock output


-- 
Greetings, Michael.
