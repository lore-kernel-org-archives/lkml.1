Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbZAGM4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbZAGM4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbZAGM4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:56:30 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:34033 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752803AbZAGM42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:56:28 -0500
Subject: GPIO: Fix probe() error return in gpio driver probes
Message-Id: <20090107125619.052023040@fluff.org.uk>
User-Agent: quilt/0.46-1
From: ben@fluff.org.uk
To: linux-kernel@vger.kernel.org
Cc: david-b@pacbell.net, linux-i2c@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net,
       Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/check-gpio-driver-return-codes.patch
Date: Wed, 07 Jan 2009 12:56:19 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of drivers in drivers/gpio return -ENODEV when confronted
with missing setup parameters such as the platform data. However,
returning -ENODEV causes the driver layer to silently ignore the
driver as it assumes the probe did not find anything and was only
speculative.

To make life easier to discern why a driver is not being attached,
change to returning -EINVAL, which is a better description of the
fact that the driver data was not valid.

Also add a set of dev_dbg() statements to the error paths to provide
an better explanation of the error as there may be more that one point
in the driver.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Index: linux.git3/drivers/gpio/max7301.c
===================================================================
--- linux.git3.orig/drivers/gpio/max7301.c	2008-10-22 09:50:45.000000000 +0100
+++ linux.git3/drivers/gpio/max7301.c	2009-01-07 12:37:46.000000000 +0000
@@ -217,8 +217,10 @@ static int __devinit max7301_probe(struc
 	int i, ret;
 
 	pdata = spi->dev.platform_data;
-	if (!pdata || !pdata->base)
-		return -ENODEV;
+	if (!pdata || !pdata->base) {
+		dev_dbg(&spi->dev, "incorrect or missing platform data\n");
+		return -EINVAL;
+	}
 
 	/*
 	 * bits_per_word cannot be configured in platform data
Index: linux.git3/drivers/gpio/max732x.c
===================================================================
--- linux.git3.orig/drivers/gpio/max732x.c	2008-10-22 09:50:45.000000000 +0100
+++ linux.git3/drivers/gpio/max732x.c	2009-01-07 12:22:10.000000000 +0000
@@ -267,8 +267,10 @@ static int __devinit max732x_probe(struc
 	int ret, nr_port;
 
 	pdata = client->dev.platform_data;
-	if (pdata == NULL)
-		return -ENODEV;
+	if (pdata == NULL) {
+		dev_dbg(&client->dev, "no platform data\n");
+		return -EINVAL;
+	}
 
 	chip = kzalloc(sizeof(struct max732x_chip), GFP_KERNEL);
 	if (chip == NULL)
Index: linux.git3/drivers/gpio/mcp23s08.c
===================================================================
--- linux.git3.orig/drivers/gpio/mcp23s08.c	2008-10-22 09:50:45.000000000 +0100
+++ linux.git3/drivers/gpio/mcp23s08.c	2009-01-07 12:23:24.000000000 +0000
@@ -310,8 +310,10 @@ static int mcp23s08_probe(struct spi_dev
 	unsigned			base;
 
 	pdata = spi->dev.platform_data;
-	if (!pdata || !gpio_is_valid(pdata->base))
-		return -ENODEV;
+	if (!pdata || !gpio_is_valid(pdata->base)) {
+		dev_dbg(&spi->dev, "invalid or missing platform data\n");
+		return -EINVAL;
+	}
 
 	for (addr = 0; addr < 4; addr++) {
 		if (!pdata->chip[addr].is_present)
Index: linux.git3/drivers/gpio/pca953x.c
===================================================================
--- linux.git3.orig/drivers/gpio/pca953x.c	2008-10-22 09:50:45.000000000 +0100
+++ linux.git3/drivers/gpio/pca953x.c	2009-01-07 12:36:00.000000000 +0000
@@ -200,8 +200,10 @@ static int __devinit pca953x_probe(struc
 	int ret;
 
 	pdata = client->dev.platform_data;
-	if (pdata == NULL)
-		return -ENODEV;
+	if (pdata == NULL) {
+		dev_dbg(&client->dev, "no platform data\n");
+		return -EINVAL;
+	}
 
 	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
 	if (chip == NULL)
Index: linux.git3/drivers/gpio/pcf857x.c
===================================================================
--- linux.git3.orig/drivers/gpio/pcf857x.c	2008-10-22 09:50:45.000000000 +0100
+++ linux.git3/drivers/gpio/pcf857x.c	2009-01-07 12:27:00.000000000 +0000
@@ -188,8 +188,10 @@ static int pcf857x_probe(struct i2c_clie
 	int				status;
 
 	pdata = client->dev.platform_data;
-	if (!pdata)
-		return -ENODEV;
+	if (!pdata) {
+		dev_dbg(&client->dev, "no platform data\n");
+		return -EINVAL;
+	}
 
 	/* Allocate, initialize, and register this gpio_chip. */
 	gpio = kzalloc(sizeof *gpio, GFP_KERNEL);
@@ -248,8 +250,10 @@ static int pcf857x_probe(struct i2c_clie
 		else
 			status = i2c_read_le16(client);
 
-	} else
-		status = -ENODEV;
+	} else {
+		dev_dbg(&client->dev, "unsupported number of gpios\n");
+		status = -EINVAL;
+	}
 
 	if (status < 0)
 		goto fail;

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
